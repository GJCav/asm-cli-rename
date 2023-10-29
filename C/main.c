#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <memory.h>
#include <ncurses.h>
#include <cdk.h>
#define PCRE2_CODE_UNIT_WIDTH 8
#include <pcre2.h>
#include "util.h"

#define min_width            40
#define min_height           20
#define form_height          4
#define max_file_count       256

/**
 * 256 + 32, multiple of 16 for stack alignment
 * 256 is the max file name length in linux
 */ 
#define max_str_len          288  

extern struct {
    int width;
    int height;
    int y;
    int x;
} list_rect, out_rect, form_rect;

extern WINDOW *list_win;
extern int file_count;
extern char filenames[max_file_count][max_str_len];
extern char *list_items[max_file_count];
extern int offset_x;
extern int offset_y;

extern WINDOW *out_win;
extern char outstr[max_file_count][max_str_len];
extern char *out_items[max_file_count];
extern bool out_err[max_file_count];

extern bool mat_err;
extern char sub_buf[max_str_len];

extern WINDOW *create_wnd(int height, int width, int y, int x);
extern int pstrcmp( const void* a, const void* b );

void fill_filenames();
void match(const char* subject);
void fill_outitems();
void do_scroll(int ch);
void draw_scroll(WINDOW *wnd, int offset_x, int offset_y, char **items, bool *errs);

extern WINDOW *form_win;
extern CDKSCREEN *form_cdk;
extern CDKENTRY *pat_entry;
extern CDKENTRY *rep_entry;
extern CDKBUTTON *ftr_btn; // filter
extern CDKBUTTON *cfm_btn; // confirm

void init_form();
void do_filter();
void do_apply();

extern void *focus_group[16];
extern int current_focus;
extern int focus_group_size;

extern void init_focus();
void *cur_focus();

int main() {


    initscr();
    cbreak();
    keypad(stdscr, TRUE);
    initCDKColor();
    use_default_colors();
    refresh();

    // Check if terminal is big enough
    int width, height;
    getmaxyx(stdscr, height, width);
    if(width < min_width || height < min_height) {
        endwin();
        printf("Terminal is too small. Minimum size is %d x %d\n", min_width, min_height);
        printf("Current size is %dx%d\n", width, height);
        return 1;
    }

    // calculate wnd sizes
    list_rect.x = 0;
    list_rect.y = 0;
    list_rect.width = width / 2;
    list_rect.height = height - form_height - 1; // -1 for help line

    out_rect.x = list_rect.width;
    out_rect.y = 0;
    out_rect.width = width - list_rect.width;
    out_rect.height = list_rect.height;

    form_rect.x = 0;
    form_rect.y = list_rect.height;
    form_rect.width = width;
    form_rect.height = form_height;

    // draw help line
    init_pair(4, COLOR_MAGENTA, -1);
    attron(COLOR_PAIR(4));
    mvwprintw(stdscr, height - 1, 0, "TAB to switch focus, q to quit");
    attroff(COLOR_PAIR(4));

    // initialize windows, sequence is important
    list_win = create_wnd(list_rect.height, list_rect.width, list_rect.y, list_rect.x);
    out_win = create_wnd(out_rect.height, out_rect.width, out_rect.y, out_rect.x);

    init_pair(16, COLOR_RED, -1); // error color

    init_form();
    init_focus();

    fill_filenames();
    fill_outitems();

    draw_scroll(list_win, offset_x, offset_y, list_items, NULL);
    draw_scroll(out_win, offset_x, offset_y, out_items, NULL);


    int ch = 0;
    while(true) {
        ch = getch();
        if(ch == 'q') break;

        if (ch == KEY_TAB) {
            current_focus += 1;
            current_focus %= focus_group_size;
        }

        void *focus = cur_focus();

        // event handling and focus drawing
        // the sequence is really important

        if(focus != ftr_btn) {
            setCDKButtonBackgroundColor(ftr_btn, "</32>");
            drawCDKButton(ftr_btn, FALSE);
        }
        if(focus != cfm_btn) {
            setCDKButtonBackgroundColor(cfm_btn, "</32>");
            drawCDKButton(cfm_btn, FALSE);
        }

        if (focus == (void*) list_win) {
            do_scroll(ch);
            draw_scroll(list_win, offset_x, offset_y, list_items, NULL);
            draw_scroll(out_win, offset_x, offset_y, out_items, out_err);
            wmove(list_win, 0, 0);
            wrefresh(list_win);
        } else if (focus == (void*) pat_entry) {
            injectCDKEntry(pat_entry, ch);
            fill_outitems();
            draw_scroll(out_win, offset_x, offset_y, out_items, out_err);
            drawCDKEntry(pat_entry, FALSE); // redraw entry to update cursor position
        } else if (focus == (void*) rep_entry) {
            injectCDKEntry(rep_entry, ch);
            fill_outitems();
            draw_scroll(out_win, offset_x, offset_y, out_items, out_err);
            drawCDKEntry(rep_entry, FALSE); // redraw entry to update cursor position
        } else if (focus == (void*) ftr_btn) {
            injectCDKButtonbox(ftr_btn, ch);
            setCDKButtonBackgroundColor(ftr_btn, "</33>");
            if (ch == '\n') {
                do_filter();
                draw_scroll(list_win, offset_x, offset_y, list_items, NULL);
                draw_scroll(out_win, offset_x, offset_y, out_items, out_err);
            }
            drawCDKButton(ftr_btn, FALSE);
        } else if (focus == (void*) cfm_btn) {
            injectCDKButtonbox(cfm_btn, ch);
            setCDKButtonBackgroundColor(cfm_btn, "</33>");
            if (ch == '\n') {
                do_apply();
                draw_scroll(list_win, offset_x, offset_y, list_items, NULL);
                draw_scroll(out_win, offset_x, offset_y, out_items, out_err);
            }
            drawCDKButton(cfm_btn, FALSE);
        }
    }

    refresh();
    endwin();
    return 0;
}

// WINDOW *create_wnd(int height, int width, int y, int x) {
//     WINDOW *wnd = newwin(height, width, y, x);
//     box(wnd, 0, 0);
//     wrefresh(wnd);
//     return wnd;
// }

// int pstrcmp( const void* a, const void* b ) {
//   return strcmp( *(const char**)a, *(const char**)b );
// }

//void fill_filenames() {
    // read filenames from directory
//    DIR *dir;
//    struct dirent *ent;
//    dir = opendir(".");
//    if (dir == NULL) {
//        endwin();
//        printf("Error opening current directory\n");
//        exit(1);
//    }
//
//    file_count = 0;
//    while ((ent = readdir(dir)) != NULL) {
//       if (ent->d_type == DT_DIR) continue;
//        strcpy(filenames[file_count], ent->d_name);
//        list_items[file_count] = filenames[file_count];
//        file_count++;
//    }
//    closedir(dir);
//
//    qsort(list_items, file_count, sizeof(list_items[0]), pstrcmp);
//}

void match(const char* subject) {
    
    pcre2_code *re;
    const char* pattern = getCDKEntryValue(pat_entry);
    const char* replace = getCDKEntryValue(rep_entry);

    int errnumber = 0, erroffset = 0;
    re = pcre2_compile(
        (PCRE2_SPTR)pattern, 
        PCRE2_ZERO_TERMINATED, 
        0, 
        &errnumber, 
        &erroffset, 
        NULL
    );

    if (re == NULL) {
        mat_err = true;
        pcre2_get_error_message(errnumber, sub_buf, max_str_len);
        return;
    }

    pcre2_match_data *match_data;
    match_data = pcre2_match_data_create_from_pattern(re, NULL);
    int rc = 0;
    rc = pcre2_match(
        re, 
        (PCRE2_SPTR)subject, 
        PCRE2_ZERO_TERMINATED, 
        0, 
        0, 
        match_data, 
        NULL
    );

    if (rc < 0) {
        mat_err = true;
        if (rc == PCRE2_ERROR_NOMATCH) {
            strcpy(sub_buf, "No match");
        } else {
            char buf[max_str_len];
            pcre2_get_error_message(rc, buf, max_str_len);
            snprintf(sub_buf, max_str_len, "Matching error: %s", buf);
        }
    } else {
        mat_err = false;
        int len = max_str_len;
        errnumber = pcre2_substitute(
            re,
            subject,
            PCRE2_ZERO_TERMINATED, 0, // length, start offset
            0,                        // options
            NULL, NULL,               // match data block, context
            replace,
            PCRE2_ZERO_TERMINATED,
            sub_buf, &len                 // output buffer, output length
        );

        if (errnumber < 0) {
            mat_err = true;
            char buf[max_str_len];
            pcre2_get_error_message(errnumber, buf, max_str_len);
            snprintf(sub_buf, max_str_len, "error: %s", buf);
        } else if (len == 0) {
            mat_err = true;
            strcpy(sub_buf, "empty result");
        }
    }

    pcre2_match_data_free(match_data);
    pcre2_code_free(re);
}

// void fill_outitems() {
//     // TODO: apply regex replace to filenames
//     // here we just copy filenames

//     for(int i = 0; i < file_count; i++) {
//         match(list_items[i]);
//         out_err[i] = mat_err;
//         strncpy(outstr[i], sub_buf, max_str_len);
//         out_items[i] = outstr[i];
//     }
// }

void do_scroll(int ch) {
    if (ch == KEY_DOWN) {
        offset_y--;
    } else if (ch == KEY_UP) {
        offset_y++;
    } else if (ch == KEY_LEFT) {
        offset_x++;
    } else if (ch == KEY_RIGHT) {
        offset_x--;
    } else if (ch == KEY_PPAGE) {
        offset_y += 10;
    } else if (ch == KEY_NPAGE) {
        offset_y -= 10;
    }

    offset_x = min(offset_x, 0);
    offset_y = max(offset_y, -file_count + 10);
    offset_y = min(offset_y, 0);

    int max_len = 0;
    for(int i = 0; i < file_count; i++) {
        max_len = max(max_len, strlen(list_items[i]));
        max_len = max(max_len, strlen(out_items[i]));
    }
    offset_x = max(offset_x, -(max_len - list_rect.width + 2));
}


void draw_scroll(WINDOW *wnd, int offset_x, int offset_y,  char **items, bool *errs) {
    wclear(wnd);
    box(wnd, 0, 0);

    int width, height;
    getmaxyx(wnd, height, width);
    height -= 3; // borders & status line
    width -= 2;

    // draw list
    char buf[max_str_len];
    int i;
    for(i = max(0, -offset_y); i < min(file_count, -offset_y + height); i++) {
        int item_len = strlen(items[i]);
        int dx = 0;
        if(offset_x > 0) dx = 0;
        else if(item_len < width) dx = 0;
        else if(item_len + offset_x < width) dx = item_len - width + 1;
        else dx = - offset_x;

        snprintf(
            buf, 
            min(width, max_str_len), 
            "%s", 
            items[i] + dx
        );

        if(errs != NULL && errs[i]) {
            wattron(wnd, COLOR_PAIR(16));
        }
        mvwaddnstr(wnd, i + offset_y + 1, 1, buf, width);
        if(errs != NULL && errs[i]) {
            wattroff(wnd, COLOR_PAIR(16));
        }
    }

    // draw status line
    int len = snprintf(buf, min(width, max_str_len), "%d / %d", i, file_count);
    mvwaddstr(wnd, height + 1, width - len, buf);
    wrefresh(wnd);
}

void init_form() {
    const int button_width = 10;

    // init input entry
    form_win = create_wnd(form_rect.height, form_rect.width, form_rect.y, form_rect.x);
    form_cdk = initCDKScreen(form_win);
    int entry_width = form_rect.width 
        -2              // borders
        -button_width 
        - 10;           // label
    pat_entry = newCDKEntry(
        form_cdk,           // CDK screen
        form_rect.x + 1,    // xpos
        form_rect.y + 1,    // ypos
        NULL,               // title
        "Pattern: ",        // label 
        A_NORMAL,           // field attribute
        '_',                // filler character
        vMIXED,             // field type
        entry_width,        // field width
        0, 
        max_str_len,                
        FALSE, 
        FALSE
    );
    rep_entry = newCDKEntry(
        form_cdk, 
        form_rect.x + 1, 
        form_rect.y + 2, 
        NULL, 
        "Replace: ", 
        A_NORMAL, 
        '_', 
        vMIXED, 
        entry_width, 
        0, 
        max_str_len, 
        FALSE, 
        FALSE
    );

    if (pat_entry == NULL || rep_entry == NULL) {
        endCDK();
        endwin();
        printf("Error creating entry fields\n");
        exit(1);
    }

    drawCDKEntry(pat_entry, FALSE);
    drawCDKEntry(rep_entry, FALSE);

    int btn_x = form_rect.x + 1 + entry_width + 10; // 10 for label
    // init buttons
    ftr_btn = newCDKButton(
        form_cdk, 
        btn_x, 
        form_rect.y + 1,
        "  Filter  ",
        NULL,
        FALSE,
        FALSE
    );
    cfm_btn = newCDKButton(
        form_cdk, 
        btn_x, 
        form_rect.y + 2,
        "  Apply   ",
        NULL,
        FALSE,
        FALSE
    );

    if (ftr_btn == NULL || cfm_btn == NULL) {
        endCDK();
        endwin();
        printf("Error creating buttons\n");
        exit(1);
    }

    init_pair(32, -1, -1); // normal
    init_pair(33, COLOR_BLUE, -1); // highlight
    
    setCDKButtonBackgroundColor(ftr_btn, "</32>");
    setCDKButtonBackgroundColor(cfm_btn, "</32>");

    drawCDKButton(ftr_btn, FALSE);
    drawCDKButton(cfm_btn, FALSE);
}

/*void init_focus() {
    focus_group[0] = (void*) list_win;
    focus_group[1] = (void*) pat_entry;
    focus_group[2] = (void*) rep_entry;
    focus_group[3] = (void*) ftr_btn;
    focus_group[4] = (void*) cfm_btn;
    focus_group_size = 5;
}*/

// void *cur_focus(){
//     return focus_group[current_focus];
// }

void do_filter() {
    int count = file_count;
    file_count = 0;
    for(int i = 0;i < count; i++) {
        if(!out_err[i]) {
            strcpy(outstr[file_count], list_items[i]); // first copy to outstr as a buffer
            file_count++;
        }
    }
    for(int i = 0;i < file_count;i++){
        strcpy(filenames[i], outstr[i]); // then copy back to list_items
        list_items[i] = filenames[i];
    }


    fill_outitems();
}

void do_apply() {
    // rename all file in filenames to outstr

    for(int i = 0; i < file_count; i++) {
        if(out_err[i]) continue;
        if(strcmp(filenames[i], outstr[i]) == 0) continue;
        if(rename(filenames[i], outstr[i]) != 0) {
            endwin();
            printf("Error renaming %s to %s\n", filenames[i], outstr[i]);
            exit(1);
        }
    }

    fill_filenames();
    fill_outitems();
}