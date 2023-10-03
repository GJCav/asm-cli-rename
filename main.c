#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <ncurses.h>
#include <cdk.h>

const int min_width = 80;
const int min_height = 20;
const int form_height = 4;
const int max_file_count = 256;
const int max_filename_length = 256;

struct {
    int width;
    int height;
    int y;
    int x;
} list_rect, out_rect, form_rect;

WINDOW *form_win;

WINDOW *list_win;
CDKSCREEN *list_cdk;
CDKSCROLL *list_cdk_scroll;
int file_count = 0;
char filenames[max_file_count][max_filename_length];
// char **list_items;
char *list_items[max_file_count];
const int list_win_bypass[] = {
    KEY_UP,
    KEY_DOWN,
    KEY_LEFT,
    KEY_RIGHT,
    'j',
    'k',
    'h',
    'l',
    KEY_PPAGE,
    KEY_NPAGE,
    '\0'
};

WINDOW *out_win;
CDKSCREEN *out_cdk;
CDKSCROLL *out_cdk_scroll;
char outstr[max_file_count][max_filename_length];
char *out_items[max_file_count];

WINDOW *create_wnd(int height, int width, int y, int x);
void fill_filenames();
void init_list_win();
void fill_outitems();
void init_out_win();

int main() {

    initscr();
    cbreak();
    keypad(stdscr, TRUE);
    // initCDKColor();

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
    list_rect.height = height - form_height;

    out_rect.x = list_rect.width;
    out_rect.y = 0;
    out_rect.width = width - list_rect.width;
    out_rect.height = list_rect.height;

    form_rect.x = 0;
    form_rect.y = list_rect.height;
    form_rect.width = width;
    form_rect.height = form_height;

    // create windows with borders
    form_win = create_wnd(form_rect.height, form_rect.width, form_rect.y, form_rect.x);

    init_list_win();
    init_out_win();

    int ch = 0;
    while(true) {
        ch = getch();
        if(ch == 'q') break;

        // dispatch arrow keys to CDK
        bool bypass = false;
        for(int i = 0; list_win_bypass[i] != '\0'; i++) {
            if(ch == list_win_bypass[i]) {
                bypass = true;
                break;
            }
        }
        if(bypass) {
            injectCDKScroll(list_cdk_scroll, ch);
            injectCDKScroll(out_cdk_scroll, ch);

            // sync list scroll to out scroll
            int selected = getCDKScrollCurrentItem(list_cdk_scroll);
            int top = getCDKScrollCurrentTop(list_cdk_scroll);
            // setCDKScrollCurrentItem(out_cdk_scroll, selected);
            // setCDKScrollCurrentTop(out_cdk_scroll, top);

            mvwprintw(form_win, 1, 1, "list_scoll: %d, top: %d", selected, top);
            selected = getCDKScrollCurrentItem(out_cdk_scroll);
            top = getCDKScrollCurrentTop(out_cdk_scroll);
            mvwprintw(form_win, 2, 1, "out_scoll:  %d, top: %d", selected, top);
            wrefresh(form_win);
            continue;
        }
    }
    

    refresh();
    endwin();
    return 0;
}

WINDOW *create_wnd(int height, int width, int y, int x) {
    WINDOW *wnd = newwin(height, width, y, x);
    box(wnd, 0, 0);
    wrefresh(wnd);
    return wnd;
}

void fill_filenames() {
    // TODO: fill filenames
    // here just fill it with some random strings

    file_count = 40;
    for(int i = 0; i < file_count; i++) {
        sprintf(filenames[i], "test-file-%d", i);
    }

    // update items
    for(int i = 0; i < file_count; i++) {
        list_items[i] = (char*) &filenames[i];
    }
}

void init_list_win() {
    list_win = create_wnd(list_rect.height, list_rect.width, list_rect.y, list_rect.x);
    fill_filenames();
    list_cdk = initCDKScreen(list_win);
    list_cdk_scroll = newCDKScroll(
        list_cdk,               // CDK screen
        LEFT,                   // align x
        TOP,                    // align y
        RIGHT,                  // scroll bar position
        0,                      // 100% height
        0,                      // 100% width
        "Filenames",            // title
        list_items,                  // items
        file_count,             // item count
        TRUE,                   // numbers
        A_REVERSE,               // highlight
        TRUE,                   // box
        FALSE                   // shadow
    );

    if(list_cdk_scroll == NULL) {
        endCDK();
        endwin();
        printf("Error creating list window\n");
        exit(1);
    }

    drawCDKScroll(list_cdk_scroll, TRUE);
}

void fill_outitems() {
    // TODO: apply regex replace on filenames
    // here just copy filenames to outstr

    for(int i = 0; i < file_count; i++) {
        sprintf(outstr[i], "out-%s", filenames[i]);
    }

    // update items
    for(int i = 0; i < file_count; i++) {
        out_items[i] = (char*) &outstr[i];
    }
}

void init_out_win() {
    out_win = create_wnd(out_rect.height, out_rect.width, out_rect.y, out_rect.x);
    fill_outitems();
    out_cdk = initCDKScreen(out_win);
    out_cdk_scroll = newCDKScroll(
        out_cdk,                // CDK screen
        LEFT,                   // align x
        TOP,                    // align y
        RIGHT,                  // scroll bar position
        0,                      // 100% height
        0,                      // 100% width
        "Output",               // title
        out_items,              // items
        file_count,             // item count
        TRUE,                   // numbers
        A_REVERSE,               // highlight
        TRUE,                   // box
        FALSE                   // shadow
    );

    if(out_cdk_scroll == NULL) {
        endCDK();
        endwin();
        printf("Error creating output window\n");
        exit(1);
    }

    drawCDKScroll(out_cdk_scroll, TRUE);
}