.include "helper.inc"  


.LC0:
	.string	"Terminal is too small. Minimum size is %d x %d\n"
.LC1:
	.string	"Current size is %dx%d\n"
	.align 8
.LC2:
	.string	"TAB to switch focus, q to quit"
.LC3:
	.string	"</32>"
.LC4:
	.string	"</33>"
    .section .rodata
    .text
    .globl	main
	.type	main, @function
main:
.LFB6:
	begin_func

	call	initscr@PLT #initscr();

	call	cbreak@PLT  #cbreak();

	movl	$1, %esi  #true

    movq	stdscr(%rip), %rax
	movq	%rax, %rdi  #stdscr

	call	keypad@PLT # keypad(stdscr, TRUE)

	call	initCDKColor@PLT # initCDKColor()

	call	use_default_colors@PLT # use_default_colors();

	movq	stdscr(%rip), %rax
	movq	%rax, %rdi
	call	wrefresh@PLT # refresh();

	movq	stdscr(%rip), %rax
	testq	%rax, %rax
	je	.L2
	movq	stdscr(%rip), %rax
	movzwl	4(%rax), %eax
	cwtl
	addl	$1, %eax
	jmp	.L3
.L2:
	movl	$-1, %eax
.L3:
	movl	%eax, -20(%rbp)
	movq	stdscr(%rip), %rax
	testq	%rax, %rax  # stdscr exist
	je	.L4
	movq	stdscr(%rip), %rax
	movzwl	6(%rax), %eax
	cwtl
	addl	$1, %eax
	jmp	.L5
.L4:
	movl	$-1, %eax
.L5:
	movl	%eax, -16(%rbp)
	cmpl	$39, -16(%rbp) # width < min_width
	jle	.L6
	cmpl	$19, -20(%rbp) # height < min_height
	jg	.L7
.L6:

	call	endwin@PLT # endwin();

	movl	$20, %edx
	movl	$40, %esi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT # printf("Terminal is too small. Minimum size is %d x %d\n", min_width, min_height)

	movl	-20(%rbp), %edx
	movl	-16(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT # printf("Current size is %dx%d\n", width, height)

	movl	$1, %eax
	end_func # return 1
.L7:
	movl	$0, 12+list_rect(%rip) # list_rect.x = 0

	movl	$0, 8+list_rect(%rip) # list_rect.y = 0

	movl	-16(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, list_rect(%rip)  # list_rect.width = width / 2

	movl	-20(%rbp), %eax
	subl	$5, %eax
	movl	%eax, 4+list_rect(%rip) #  list_rect.height = height - form_height - 1

	movl	list_rect(%rip), %eax
	movl	%eax, 12+out_rect(%rip) #  out_rect.x = list_rect.width;

	movl	$0, 8+out_rect(%rip) #  out_rect.y = 0

	movl	list_rect(%rip), %edx # list_rect.width

	movl	-16(%rbp), %eax # width

	subl	%edx, %eax # width - list_rect.width

	movl	%eax, out_rect(%rip)  # out_rect.width = width - list_rect.width

	movl	4+list_rect(%rip), %eax
	movl	%eax, 4+out_rect(%rip) # out_rect.height = list_rect.height

	movl	$0, 12+form_rect(%rip) # form_rect.x = 0

	movl	4+list_rect(%rip), %eax
	movl	%eax, 8+form_rect(%rip) # form_rect.y = list_rect.height

	movl	-16(%rbp), %eax
	movl	%eax, form_rect(%rip) # form_rect.width = width

	movl	$4, 4+form_rect(%rip) # form_rect.height = form_height

	movl	$-1, %edx
	movl	$5, %esi
	movl	$4, %edi
	call	init_pair@PLT # init_pair(4, COLOR_MAGENTA, -1)

	movq	stdscr(%rip), %rax
	movl	$0, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	call	wattr_on@PLT # attron(COLOR_PAIR(4))

	movl	-20(%rbp), %eax
	leal	-1(%rax), %esi
	movq	stdscr(%rip), %rax
	leaq	.LC2(%rip), %rdx
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	mvwprintw@PLT # mvwprintw(stdscr, height - 1, 0, "TAB to switch focus, q to quit")
    
	movq	stdscr(%rip), %rax
	movl	$0, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	call	wattr_off@PLT # attroff(COLOR_PAIR(4))

	movl	12+list_rect(%rip), %ecx
	movl	8+list_rect(%rip), %edx
	movl	list_rect(%rip), %esi
	movl	4+list_rect(%rip), %eax
	movl	%eax, %edi
	call	create_wnd@PLT # list_win = create_wnd(list_rect.height, list_rect.width, list_rect.y, list_rect.x)

	movq	%rax, list_win(%rip)
	movl	12+out_rect(%rip), %ecx
	movl	8+out_rect(%rip), %edx
	movl	out_rect(%rip), %esi
	movl	4+out_rect(%rip), %eax
	movl	%eax, %edi
	call	create_wnd@PLT # out_win = create_wnd(out_rect.height, out_rect.width, out_rect.y, out_rect.x)

	movq	%rax, out_win(%rip)
	movl	$-1, %edx
	movl	$1, %esi
	movl	$16, %edi
	call	init_pair@PLT # init_pair(16, COLOR_RED, -1)

	movl	$0, %eax
	call	init_form # init_form()

	movl	$0, %eax
	call	init_focus@PLT # init_focus()

	movl	$0, %eax
	call	fill_filenames@PLT # fill_filenames()

	movl	$0, %eax
	call	fill_outitems@PLT # fill_outitems()

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	list_win(%rip), %rax
	movl	$0, %r8d
	leaq	list_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(list_win, offset_x, offset_y, list_items, NULL)

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	movl	$0, %r8d
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(out_win, offset_x, offset_y, out_items, NULL)

	movl	$0, -12(%rbp) # int ch = 0

.L8:
	movq	stdscr(%rip), %rax
	movq	%rax, %rdi
	call	wgetch@PLT # ch = getch()

	movl	%eax, -12(%rbp)
	cmpl	$113, -12(%rbp) 
	je	.L18 # if(ch == 'q')

	cmpl	$9, -12(%rbp) 
	jne	.L9 # !if (ch == KEY_TAB)

	movl	current_focus(%rip), %eax
	addl	$1, %eax
	movl	%eax, current_focus(%rip) #  current_focus += 1

	movl	current_focus(%rip), %eax
	movl	focus_group_size(%rip), %ecx
	cltd
	idivl	%ecx
	movl	%edx, %eax
	movl	%eax, current_focus(%rip) # current_focus %= focus_group_size

.L9:
	movl	$0, %eax
	call	cur_focus@PLT
	movq	%rax, -8(%rbp) # void *focus = cur_focus()

	movq	ftr_btn(%rip), %rax
	cmpq	%rax, -8(%rbp) 
	je	.L10 # !if(focus != ftr_btn)

	movq	ftr_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT # setCDKButtonBackgroundColor(ftr_btn, "</32>")

	movq	ftr_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	ftr_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax # drawCDKButton(ftr_btn, FALSE)
.L10:
	movq	cfm_btn(%rip), %rax
	cmpq	%rax, -8(%rbp)
	je	.L11 # !if(focus != cfm_btn)

	movq	cfm_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT # setCDKButtonBackgroundColor(cfm_btn, "</32>")

	movq	cfm_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	cfm_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax # drawCDKButton(cfm_btn, FALSE)

.L11:
	movq	list_win(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L12 # !if (focus == (void*) list_win)

	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	do_scroll # do_scroll(ch)

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	list_win(%rip), %rax
	movl	$0, %r8d
	leaq	list_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(list_win, offset_x, offset_y, list_items, NULL)

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(out_win, offset_x, offset_y, out_items, out_err)

	movq	list_win(%rip), %rax
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	wmove@PLT # wmove(list_win, 0, 0)
     
	movq	list_win(%rip), %rax
	movq	%rax, %rdi
	call	wrefresh@PLT

	jmp	.L8
.L12:
	movq	pat_entry(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L13 # !else if (focus == (void*) pat_entry)

	movq	pat_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	movq	pat_entry(%rip), %rcx
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	*%rdx 
	testl	%eax, %eax # injectCDKEntry(pat_entry, ch)

	movl	$0, %eax
	call	fill_outitems@PLT # fill_outitems()

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(out_win, offset_x, offset_y, out_items, out_err)

	movq	pat_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	pat_entry(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax # drawCDKEntry(pat_entry, FALSE)

	jmp	.L8
.L13:
	movq	rep_entry(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L14 # !else if (focus == (void*) pat_entry)

	movq	rep_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	movq	rep_entry(%rip), %rcx
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	*%rdx 
	testl	%eax, %eax # injectCDKEntry(pat_entry, ch)

	movl	$0, %eax
	call	fill_outitems@PLT # fill_outitems()

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(out_win, offset_x, offset_y, out_items, out_err)

	movq	rep_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	rep_entry(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax # drawCDKEntry(rep_entry, FALSE)

	jmp	.L8
.L14:
	movq	ftr_btn(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L16 # !else if (focus == (void*) ftr_btn)

	movq	ftr_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	movq	ftr_btn(%rip), %rcx
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	*%rdx
	testl	%eax, %eax # injectCDKButtonbox(ftr_btn, ch)

	movq	ftr_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC4(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT # setCDKButtonBackgroundColor(ftr_btn, "</33>")

	cmpl	$10, -12(%rbp)
	jne	.L15 # !if (ch == '\n')

	movl	$0, %eax
	call	do_filter@PLT # do_filter()

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	list_win(%rip), %rax
	movl	$0, %r8d
	leaq	list_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(list_win, offset_x, offset_y, list_items, NULL)

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(out_win, offset_x, offset_y, out_items, out_err)

.L15:
	movq	ftr_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	ftr_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax # drawCDKButton(ftr_btn, FALSE)

	jmp	.L8
.L16:
	movq	cfm_btn(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L8 # !else if (focus == (void*) cfm_btn)

	movq	cfm_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	movq	cfm_btn(%rip), %rcx
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	*%rdx
	testl	%eax, %eax # injectCDKButtonbox(cfm_btn, ch)

	movq	cfm_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC4(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT # setCDKButtonBackgroundColor(cfm_btn, "</33>")

	cmpl	$10, -12(%rbp)
	jne	.L17 # if (ch == '\n')

	movl	$0, %eax
	call	do_apply # do_apply()

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	list_win(%rip), %rax
	movl	$0, %r8d
	leaq	list_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(list_win, offset_x, offset_y, list_items, NULL)

	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll # draw_scroll(out_win, offset_x, offset_y, out_items, out_err)

.L17:
	movq	cfm_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	cfm_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax # drawCDKButton(cfm_btn, FALSE)

	jmp	.L8
.L18:
	nop
	movq	stdscr(%rip), %rax
	movq	%rax, %rdi
	call	wrefresh@PLT # refresh()

	call	endwin@PLT #  endwin()

	movl	$0, %eax
    end_func # return 0 

