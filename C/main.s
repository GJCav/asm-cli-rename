	.file	"main.c"
	.text
	.section	.rodata
	.align 8
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
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	call	initscr@PLT
	call	cbreak@PLT
	movq	stdscr(%rip), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	keypad@PLT
	call	initCDKColor@PLT
	call	use_default_colors@PLT
	movq	stdscr(%rip), %rax
	movq	%rax, %rdi
	call	wrefresh@PLT
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
	testq	%rax, %rax
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
	cmpl	$39, -16(%rbp)
	jle	.L6
	cmpl	$19, -20(%rbp)
	jg	.L7
.L6:
	call	endwin@PLT
	movl	$20, %edx
	movl	$40, %esi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	-20(%rbp), %edx
	movl	-16(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %eax
	jmp	.L8
.L7:
	movl	$0, 12+list_rect(%rip)
	movl	$0, 8+list_rect(%rip)
	movl	-16(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	movl	%eax, list_rect(%rip)
	movl	-20(%rbp), %eax
	subl	$5, %eax
	movl	%eax, 4+list_rect(%rip)
	movl	list_rect(%rip), %eax
	movl	%eax, 12+out_rect(%rip)
	movl	$0, 8+out_rect(%rip)
	movl	list_rect(%rip), %edx
	movl	-16(%rbp), %eax
	subl	%edx, %eax
	movl	%eax, out_rect(%rip)
	movl	4+list_rect(%rip), %eax
	movl	%eax, 4+out_rect(%rip)
	movl	$0, 12+form_rect(%rip)
	movl	4+list_rect(%rip), %eax
	movl	%eax, 8+form_rect(%rip)
	movl	-16(%rbp), %eax
	movl	%eax, form_rect(%rip)
	movl	$4, 4+form_rect(%rip)
	movl	$-1, %edx
	movl	$5, %esi
	movl	$4, %edi
	call	init_pair@PLT
	movq	stdscr(%rip), %rax
	movl	$0, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	call	wattr_on@PLT
	movl	-20(%rbp), %eax
	leal	-1(%rax), %esi
	movq	stdscr(%rip), %rax
	leaq	.LC2(%rip), %rdx
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	%rax, %rdi
	movl	$0, %eax
	call	mvwprintw@PLT
	movq	stdscr(%rip), %rax
	movl	$0, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	call	wattr_off@PLT
	movl	12+list_rect(%rip), %ecx
	movl	8+list_rect(%rip), %edx
	movl	list_rect(%rip), %esi
	movl	4+list_rect(%rip), %eax
	movl	%eax, %edi
	call	create_wnd@PLT
	movq	%rax, list_win(%rip)
	movl	12+out_rect(%rip), %ecx
	movl	8+out_rect(%rip), %edx
	movl	out_rect(%rip), %esi
	movl	4+out_rect(%rip), %eax
	movl	%eax, %edi
	call	create_wnd@PLT
	movq	%rax, out_win(%rip)
	movl	$-1, %edx
	movl	$1, %esi
	movl	$16, %edi
	call	init_pair@PLT
	movl	$0, %eax
	call	init_form
	movl	$0, %eax
	call	init_focus
	movl	$0, %eax
	call	fill_filenames
	movl	$0, %eax
	call	fill_outitems
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	list_win(%rip), %rax
	movl	$0, %r8d
	leaq	list_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	movl	$0, %r8d
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
	movl	$0, -12(%rbp)
.L29:
	movq	stdscr(%rip), %rax
	movq	%rax, %rdi
	call	wgetch@PLT
	movl	%eax, -12(%rbp)
	cmpl	$113, -12(%rbp)
	je	.L31
	cmpl	$9, -12(%rbp)
	jne	.L11
	movl	current_focus(%rip), %eax
	addl	$1, %eax
	movl	%eax, current_focus(%rip)
	movl	current_focus(%rip), %eax
	movl	focus_group_size(%rip), %ecx
	cltd
	idivl	%ecx
	movl	%edx, %eax
	movl	%eax, current_focus(%rip)
.L11:
	movl	$0, %eax
	call	cur_focus
	movq	%rax, -8(%rbp)
	movq	ftr_btn(%rip), %rax
	cmpq	%rax, -8(%rbp)
	je	.L12
	movq	ftr_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT
	movq	ftr_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	ftr_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
.L12:
	movq	cfm_btn(%rip), %rax
	cmpq	%rax, -8(%rbp)
	je	.L13
	movq	cfm_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT
	movq	cfm_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	cfm_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
.L13:
	movq	list_win(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L14
	movl	-12(%rbp), %eax
	movl	%eax, %edi
	call	do_scroll
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	list_win(%rip), %rax
	movl	$0, %r8d
	leaq	list_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
	movq	list_win(%rip), %rax
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	wmove@PLT
	movq	list_win(%rip), %rax
	movq	%rax, %rdi
	call	wrefresh@PLT
	jmp	.L29
.L14:
	movq	pat_entry(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L16
	movq	pat_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	movq	pat_entry(%rip), %rcx
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	*%rdx
	testl	%eax, %eax
	movl	$0, %eax
	call	fill_outitems
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
	movq	pat_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	pat_entry(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	jmp	.L29
.L16:
	movq	rep_entry(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L19
	movq	rep_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	movq	rep_entry(%rip), %rcx
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	*%rdx
	testl	%eax, %eax
	movl	$0, %eax
	call	fill_outitems
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
	movq	rep_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	rep_entry(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	jmp	.L29
.L19:
	movq	ftr_btn(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L22
	movq	ftr_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	movq	ftr_btn(%rip), %rcx
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	*%rdx
	testl	%eax, %eax
	movq	ftr_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC4(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT
	cmpl	$10, -12(%rbp)
	jne	.L25
	movl	$0, %eax
	call	do_filter
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	list_win(%rip), %rax
	movl	$0, %r8d
	leaq	list_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
.L25:
	movq	ftr_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	ftr_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	jmp	.L29
.L22:
	movq	cfm_btn(%rip), %rax
	cmpq	%rax, -8(%rbp)
	jne	.L29
	movq	cfm_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	32(%rax), %rdx
	movl	-12(%rbp), %eax
	movq	cfm_btn(%rip), %rcx
	movl	%eax, %esi
	movq	%rcx, %rdi
	call	*%rdx
	testl	%eax, %eax
	movq	cfm_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC4(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT
	cmpl	$10, -12(%rbp)
	jne	.L28
	movl	$0, %eax
	call	do_apply
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	list_win(%rip), %rax
	movl	$0, %r8d
	leaq	list_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
	movl	offset_y(%rip), %edx
	movl	offset_x(%rip), %esi
	movq	out_win(%rip), %rax
	leaq	out_err(%rip), %r8
	leaq	out_items(%rip), %rcx
	movq	%rax, %rdi
	call	draw_scroll
.L28:
	movq	cfm_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	cfm_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	jmp	.L29
.L31:
	nop
	movq	stdscr(%rip), %rax
	movq	%rax, %rdi
	call	wrefresh@PLT
	call	endwin@PLT
	movl	$0, %eax
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.globl	pstrcmp
	.type	pstrcmp, @function
pstrcmp:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	pstrcmp, .-pstrcmp
	.section	.rodata
.LC5:
	.string	"."
	.align 8
.LC6:
	.string	"Error opening current directory"
	.text
	.globl	fill_filenames
	.type	fill_filenames, @function
fill_filenames:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	opendir@PLT
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L35
	call	endwin@PLT
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L35:
	movl	$0, file_count(%rip)
	jmp	.L36
.L38:
	movq	-8(%rbp), %rax
	movzbl	18(%rax), %eax
	cmpb	$4, %al
	jne	.L37
	jmp	.L36
.L37:
	movq	-8(%rbp), %rax
	leaq	19(%rax), %rdx
	movl	file_count(%rip), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	salq	$5, %rax
	leaq	filenames(%rip), %rcx
	addq	%rcx, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT
	movl	file_count(%rip), %eax
	movl	file_count(%rip), %esi
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	filenames(%rip), %rdx
	leaq	(%rax,%rdx), %rcx
	movslq	%esi, %rax
	leaq	0(,%rax,8), %rdx
	leaq	list_items(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	movl	file_count(%rip), %eax
	addl	$1, %eax
	movl	%eax, file_count(%rip)
.L36:
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	readdir@PLT
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L38
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	closedir@PLT
	movl	file_count(%rip), %eax
	cltq
	leaq	pstrcmp(%rip), %rdx
	movq	%rdx, %rcx
	movl	$8, %edx
	movq	%rax, %rsi
	leaq	list_items(%rip), %rax
	movq	%rax, %rdi
	call	qsort@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	fill_filenames, .-fill_filenames
	.section	.rodata
.LC7:
	.string	"Matching error: %s"
.LC8:
	.string	"error: %s"
	.text
	.globl	match
	.type	match, @function
match:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$368, %rsp
	movq	%rdi, -360(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	pat_entry(%rip), %rax
	movq	%rax, %rdi
	call	getCDKEntryValue@PLT
	movq	%rax, -336(%rbp)
	movq	rep_entry(%rip), %rax
	movq	%rax, %rdi
	call	getCDKEntryValue@PLT
	movq	%rax, -328(%rbp)
	movl	$0, -352(%rbp)
	movl	$0, -348(%rbp)
	leaq	-348(%rbp), %rcx
	leaq	-352(%rbp), %rdx
	movq	-336(%rbp), %rax
	movl	$0, %r9d
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	$-1, %rsi
	movq	%rax, %rdi
	call	pcre2_compile_8@PLT
	movq	%rax, -320(%rbp)
	cmpq	$0, -320(%rbp)
	jne	.L40
	movb	$1, mat_err(%rip)
	movl	-352(%rbp), %eax
	movl	$288, %edx
	leaq	sub_buf(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	pcre2_get_error_message_8@PLT
	jmp	.L39
.L40:
	movq	-320(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pcre2_match_data_create_from_pattern_8@PLT
	movq	%rax, -312(%rbp)
	movl	$0, -340(%rbp)
	movq	-312(%rbp), %rdx
	movq	-360(%rbp), %rsi
	movq	-320(%rbp), %rax
	subq	$8, %rsp
	pushq	$0
	movq	%rdx, %r9
	movl	$0, %r8d
	movl	$0, %ecx
	movq	$-1, %rdx
	movq	%rax, %rdi
	call	pcre2_match_8@PLT
	addq	$16, %rsp
	movl	%eax, -340(%rbp)
	cmpl	$0, -340(%rbp)
	jns	.L42
	movb	$1, mat_err(%rip)
	cmpl	$-1, -340(%rbp)
	jne	.L43
	movabsq	$7521983764430352206, %rax
	movq	%rax, sub_buf(%rip)
	movb	$0, 8+sub_buf(%rip)
	jmp	.L44
.L43:
	leaq	-304(%rbp), %rcx
	movl	-340(%rbp), %eax
	movl	$288, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	pcre2_get_error_message_8@PLT
	leaq	-304(%rbp), %rax
	movq	%rax, %rcx
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdx
	movl	$288, %esi
	leaq	sub_buf(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	jmp	.L44
.L42:
	movb	$0, mat_err(%rip)
	movl	$288, -344(%rbp)
	movq	-360(%rbp), %rsi
	movq	-320(%rbp), %rax
	subq	$8, %rsp
	leaq	-344(%rbp), %rdx
	pushq	%rdx
	leaq	sub_buf(%rip), %rdx
	pushq	%rdx
	pushq	$-1
	pushq	-328(%rbp)
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	movl	$0, %ecx
	movq	$-1, %rdx
	movq	%rax, %rdi
	call	pcre2_substitute_8@PLT
	addq	$48, %rsp
	movl	%eax, -352(%rbp)
	movl	-352(%rbp), %eax
	testl	%eax, %eax
	jns	.L45
	movb	$1, mat_err(%rip)
	movl	-352(%rbp), %eax
	leaq	-304(%rbp), %rcx
	movl	$288, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	pcre2_get_error_message_8@PLT
	leaq	-304(%rbp), %rax
	movq	%rax, %rcx
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdx
	movl	$288, %esi
	leaq	sub_buf(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	jmp	.L44
.L45:
	movl	-344(%rbp), %eax
	testl	%eax, %eax
	jne	.L44
	movb	$1, mat_err(%rip)
	movabsq	$7309940851192393061, %rax
	movq	%rax, sub_buf(%rip)
	movl	$1953265011, 8+sub_buf(%rip)
	movb	$0, 12+sub_buf(%rip)
.L44:
	movq	-312(%rbp), %rax
	movq	%rax, %rdi
	call	pcre2_match_data_free_8@PLT
	movq	-320(%rbp), %rax
	movq	%rax, %rdi
	call	pcre2_code_free_8@PLT
.L39:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L47
	call	__stack_chk_fail@PLT
.L47:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	match, .-match
	.globl	fill_outitems
	.type	fill_outitems, @function
fill_outitems:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	jmp	.L49
.L50:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	list_items(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, %rdi
	call	match
	movzbl	mat_err(%rip), %edx
	movl	-4(%rbp), %eax
	cltq
	leaq	out_err(%rip), %rcx
	movb	%dl, (%rax,%rcx)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	outstr(%rip), %rdx
	addq	%rdx, %rax
	movl	$288, %edx
	leaq	sub_buf(%rip), %rcx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy@PLT
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	outstr(%rip), %rdx
	leaq	(%rax,%rdx), %rcx
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	out_items(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	addl	$1, -4(%rbp)
.L49:
	movl	file_count(%rip), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L50
	nop
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	fill_outitems, .-fill_outitems
	.globl	do_scroll
	.type	do_scroll, @function
do_scroll:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	cmpl	$258, -20(%rbp)
	jne	.L52
	movl	offset_y(%rip), %eax
	subl	$1, %eax
	movl	%eax, offset_y(%rip)
	jmp	.L53
.L52:
	cmpl	$259, -20(%rbp)
	jne	.L54
	movl	offset_y(%rip), %eax
	addl	$1, %eax
	movl	%eax, offset_y(%rip)
	jmp	.L53
.L54:
	cmpl	$260, -20(%rbp)
	jne	.L55
	movl	offset_x(%rip), %eax
	addl	$1, %eax
	movl	%eax, offset_x(%rip)
	jmp	.L53
.L55:
	cmpl	$261, -20(%rbp)
	jne	.L56
	movl	offset_x(%rip), %eax
	subl	$1, %eax
	movl	%eax, offset_x(%rip)
	jmp	.L53
.L56:
	cmpl	$339, -20(%rbp)
	jne	.L57
	movl	offset_y(%rip), %eax
	addl	$10, %eax
	movl	%eax, offset_y(%rip)
	jmp	.L53
.L57:
	cmpl	$338, -20(%rbp)
	jne	.L53
	movl	offset_y(%rip), %eax
	subl	$10, %eax
	movl	%eax, offset_y(%rip)
.L53:
	movl	offset_x(%rip), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	min@PLT
	movl	%eax, offset_x(%rip)
	movl	file_count(%rip), %eax
	movl	$10, %edx
	subl	%eax, %edx
	movl	offset_y(%rip), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	max@PLT
	movl	%eax, offset_y(%rip)
	movl	offset_y(%rip), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	min@PLT
	movl	%eax, offset_y(%rip)
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L58
.L59:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	list_items(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, %edx
	movl	-8(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	max@PLT
	movl	%eax, -8(%rbp)
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	out_items(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, %edx
	movl	-8(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	max@PLT
	movl	%eax, -8(%rbp)
	addl	$1, -4(%rbp)
.L58:
	movl	file_count(%rip), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L59
	movl	list_rect(%rip), %edx
	movl	-8(%rbp), %eax
	subl	%edx, %eax
	movl	$-2, %edx
	subl	%eax, %edx
	movl	offset_x(%rip), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	max@PLT
	movl	%eax, offset_x(%rip)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	do_scroll, .-do_scroll
	.section	.rodata
.LC9:
	.string	"%s"
.LC10:
	.string	"%d / %d"
	.text
	.globl	draw_scroll
	.type	draw_scroll, @function
draw_scroll:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$376, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -360(%rbp)
	movl	%esi, -364(%rbp)
	movl	%edx, -368(%rbp)
	movq	%rcx, -376(%rbp)
	movq	%r8, -384(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -24(%rbp)
	xorl	%eax, %eax
	movq	-360(%rbp), %rax
	movq	%rax, %rdi
	call	wclear@PLT
	movq	-360(%rbp), %rax
	subq	$8, %rsp
	pushq	$0
	pushq	$0
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	wborder@PLT
	addq	$32, %rsp
	cmpq	$0, -360(%rbp)
	je	.L61
	movq	-360(%rbp), %rax
	movzwl	4(%rax), %eax
	cwtl
	addl	$1, %eax
	jmp	.L62
.L61:
	movl	$-1, %eax
.L62:
	movl	%eax, -336(%rbp)
	cmpq	$0, -360(%rbp)
	je	.L63
	movq	-360(%rbp), %rax
	movzwl	6(%rax), %eax
	cwtl
	addl	$1, %eax
	jmp	.L64
.L63:
	movl	$-1, %eax
.L64:
	movl	%eax, -332(%rbp)
	subl	$3, -336(%rbp)
	subl	$2, -332(%rbp)
	movl	-368(%rbp), %eax
	negl	%eax
	movl	%eax, %esi
	movl	$0, %edi
	call	max@PLT
	movl	%eax, -344(%rbp)
	jmp	.L65
.L74:
	movl	-344(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-376(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	strlen@PLT
	movl	%eax, -324(%rbp)
	movl	$0, -340(%rbp)
	cmpl	$0, -364(%rbp)
	jle	.L66
	movl	$0, -340(%rbp)
	jmp	.L67
.L66:
	movl	-324(%rbp), %eax
	cmpl	-332(%rbp), %eax
	jge	.L68
	movl	$0, -340(%rbp)
	jmp	.L67
.L68:
	movl	-324(%rbp), %edx
	movl	-364(%rbp), %eax
	addl	%edx, %eax
	cmpl	%eax, -332(%rbp)
	jle	.L69
	movl	-324(%rbp), %eax
	subl	-332(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -340(%rbp)
	jmp	.L67
.L69:
	movl	-364(%rbp), %eax
	negl	%eax
	movl	%eax, -340(%rbp)
.L67:
	movl	-344(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-376(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movl	-340(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rbx
	movl	-332(%rbp), %eax
	movl	$288, %esi
	movl	%eax, %edi
	call	min@PLT
	movslq	%eax, %rsi
	leaq	-320(%rbp), %rax
	movq	%rbx, %rcx
	leaq	.LC9(%rip), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	cmpq	$0, -384(%rbp)
	je	.L70
	movl	-344(%rbp), %eax
	movslq	%eax, %rdx
	movq	-384(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L70
	movq	-360(%rbp), %rax
	movl	$0, %edx
	movl	$4096, %esi
	movq	%rax, %rdi
	call	wattr_on@PLT
.L70:
	movl	-344(%rbp), %edx
	movl	-368(%rbp), %eax
	addl	%edx, %eax
	leal	1(%rax), %ecx
	movq	-360(%rbp), %rax
	movl	$1, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	wmove@PLT
	cmpl	$-1, %eax
	je	.L72
	movl	-332(%rbp), %edx
	leaq	-320(%rbp), %rcx
	movq	-360(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	waddnstr@PLT
.L72:
	cmpq	$0, -384(%rbp)
	je	.L73
	movl	-344(%rbp), %eax
	movslq	%eax, %rdx
	movq	-384(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L73
	movq	-360(%rbp), %rax
	movl	$0, %edx
	movl	$4096, %esi
	movq	%rax, %rdi
	call	wattr_off@PLT
.L73:
	addl	$1, -344(%rbp)
.L65:
	movl	-336(%rbp), %eax
	subl	-368(%rbp), %eax
	movl	%eax, %edx
	movl	file_count(%rip), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	min@PLT
	cmpl	%eax, -344(%rbp)
	jl	.L74
	movl	file_count(%rip), %ebx
	movl	-332(%rbp), %eax
	movl	$288, %esi
	movl	%eax, %edi
	call	min@PLT
	movslq	%eax, %rsi
	movl	-344(%rbp), %edx
	leaq	-320(%rbp), %rax
	movl	%ebx, %r8d
	movl	%edx, %ecx
	leaq	.LC10(%rip), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	movl	%eax, -328(%rbp)
	movl	-332(%rbp), %eax
	subl	-328(%rbp), %eax
	movl	%eax, %edx
	movl	-336(%rbp), %eax
	leal	1(%rax), %ecx
	movq	-360(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	wmove@PLT
	cmpl	$-1, %eax
	je	.L76
	leaq	-320(%rbp), %rcx
	movq	-360(%rbp), %rax
	movl	$-1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	waddnstr@PLT
.L76:
	movq	-360(%rbp), %rax
	movq	%rax, %rdi
	call	wrefresh@PLT
	nop
	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L77
	call	__stack_chk_fail@PLT
.L77:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	draw_scroll, .-draw_scroll
	.section	.rodata
.LC11:
	.string	"Pattern: "
.LC12:
	.string	"Replace: "
.LC13:
	.string	"Error creating entry fields"
.LC14:
	.string	"  Filter  "
.LC15:
	.string	"  Apply   "
.LC16:
	.string	"Error creating buttons"
	.text
	.globl	init_form
	.type	init_form, @function
init_form:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$10, -12(%rbp)
	movl	12+form_rect(%rip), %ecx
	movl	8+form_rect(%rip), %edx
	movl	form_rect(%rip), %esi
	movl	4+form_rect(%rip), %eax
	movl	%eax, %edi
	call	create_wnd@PLT
	movq	%rax, form_win(%rip)
	movq	form_win(%rip), %rax
	movq	%rax, %rdi
	call	initCDKScreen@PLT
	movq	%rax, form_cdk(%rip)
	movl	form_rect(%rip), %eax
	subl	$2, %eax
	subl	-12(%rbp), %eax
	subl	$10, %eax
	movl	%eax, -8(%rbp)
	movl	8+form_rect(%rip), %eax
	leal	1(%rax), %edx
	movl	12+form_rect(%rip), %eax
	leal	1(%rax), %esi
	movq	form_cdk(%rip), %rax
	subq	$8, %rsp
	pushq	$0
	pushq	$0
	pushq	$288
	pushq	$0
	movl	-8(%rbp), %ecx
	pushq	%rcx
	pushq	$5
	pushq	$95
	movl	$0, %r9d
	leaq	.LC11(%rip), %r8
	movl	$0, %ecx
	movq	%rax, %rdi
	call	newCDKEntry@PLT
	addq	$64, %rsp
	movq	%rax, pat_entry(%rip)
	movl	8+form_rect(%rip), %eax
	leal	2(%rax), %edx
	movl	12+form_rect(%rip), %eax
	leal	1(%rax), %esi
	movq	form_cdk(%rip), %rax
	subq	$8, %rsp
	pushq	$0
	pushq	$0
	pushq	$288
	pushq	$0
	movl	-8(%rbp), %ecx
	pushq	%rcx
	pushq	$5
	pushq	$95
	movl	$0, %r9d
	leaq	.LC12(%rip), %r8
	movl	$0, %ecx
	movq	%rax, %rdi
	call	newCDKEntry@PLT
	addq	$64, %rsp
	movq	%rax, rep_entry(%rip)
	movq	pat_entry(%rip), %rax
	testq	%rax, %rax
	je	.L79
	movq	rep_entry(%rip), %rax
	testq	%rax, %rax
	jne	.L80
.L79:
	call	endCDK@PLT
	call	endwin@PLT
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L80:
	movq	pat_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	pat_entry(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	movq	rep_entry(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	rep_entry(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	movl	12+form_rect(%rip), %eax
	leal	1(%rax), %edx
	movl	-8(%rbp), %eax
	addl	%edx, %eax
	addl	$10, %eax
	movl	%eax, -4(%rbp)
	movl	8+form_rect(%rip), %eax
	leal	1(%rax), %edx
	movq	form_cdk(%rip), %rax
	movl	-4(%rbp), %esi
	subq	$8, %rsp
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	leaq	.LC14(%rip), %rcx
	movq	%rax, %rdi
	call	newCDKButton@PLT
	addq	$16, %rsp
	movq	%rax, ftr_btn(%rip)
	movl	8+form_rect(%rip), %eax
	leal	2(%rax), %edx
	movq	form_cdk(%rip), %rax
	movl	-4(%rbp), %esi
	subq	$8, %rsp
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	leaq	.LC15(%rip), %rcx
	movq	%rax, %rdi
	call	newCDKButton@PLT
	addq	$16, %rsp
	movq	%rax, cfm_btn(%rip)
	movq	ftr_btn(%rip), %rax
	testq	%rax, %rax
	je	.L81
	movq	cfm_btn(%rip), %rax
	testq	%rax, %rax
	jne	.L82
.L81:
	call	endCDK@PLT
	call	endwin@PLT
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L82:
	movl	$-1, %edx
	movl	$-1, %esi
	movl	$32, %edi
	call	init_pair@PLT
	movl	$-1, %edx
	movl	$4, %esi
	movl	$33, %edi
	call	init_pair@PLT
	movq	ftr_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT
	movq	cfm_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT
	movq	ftr_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	ftr_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	movq	cfm_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	cfm_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	init_form, .-init_form
	.globl	init_focus
	.type	init_focus, @function
init_focus:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	list_win(%rip), %rax
	movq	%rax, focus_group(%rip)
	movq	pat_entry(%rip), %rax
	movq	%rax, 8+focus_group(%rip)
	movq	rep_entry(%rip), %rax
	movq	%rax, 16+focus_group(%rip)
	movq	ftr_btn(%rip), %rax
	movq	%rax, 24+focus_group(%rip)
	movq	cfm_btn(%rip), %rax
	movq	%rax, 32+focus_group(%rip)
	movl	$5, focus_group_size(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	init_focus, .-init_focus
	.globl	cur_focus
	.type	cur_focus, @function
cur_focus:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	current_focus(%rip), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	focus_group(%rip), %rax
	movq	(%rdx,%rax), %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	cur_focus, .-cur_focus
	.globl	do_filter
	.type	do_filter, @function
do_filter:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	file_count(%rip), %eax
	movl	%eax, -4(%rbp)
	movl	$0, file_count(%rip)
	movl	$0, -12(%rbp)
	jmp	.L87
.L89:
	movl	-12(%rbp), %eax
	cltq
	leaq	out_err(%rip), %rdx
	movzbl	(%rax,%rdx), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L88
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	list_items(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movl	file_count(%rip), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	salq	$5, %rax
	leaq	outstr(%rip), %rcx
	addq	%rcx, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT
	movl	file_count(%rip), %eax
	addl	$1, %eax
	movl	%eax, file_count(%rip)
.L88:
	addl	$1, -12(%rbp)
.L87:
	movl	-12(%rbp), %eax
	cmpl	-4(%rbp), %eax
	jl	.L89
	movl	$0, -8(%rbp)
	jmp	.L90
.L91:
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	outstr(%rip), %rdx
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	salq	$5, %rax
	leaq	filenames(%rip), %rcx
	addq	%rcx, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	filenames(%rip), %rdx
	leaq	(%rax,%rdx), %rcx
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	list_items(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	addl	$1, -8(%rbp)
.L90:
	movl	file_count(%rip), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L91
	movl	$0, %eax
	call	fill_outitems
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	do_filter, .-do_filter
	.section	.rodata
.LC17:
	.string	"Error renaming %s to %s\n"
	.text
	.globl	do_apply
	.type	do_apply, @function
do_apply:
.LFB17:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	jmp	.L93
.L97:
	movl	-4(%rbp), %eax
	cltq
	leaq	out_err(%rip), %rdx
	movzbl	(%rax,%rdx), %eax
	testb	%al, %al
	jne	.L98
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	outstr(%rip), %rdx
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	salq	$5, %rax
	leaq	filenames(%rip), %rcx
	addq	%rcx, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	je	.L99
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	outstr(%rip), %rdx
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	salq	$5, %rax
	leaq	filenames(%rip), %rcx
	addq	%rcx, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	rename@PLT
	testl	%eax, %eax
	je	.L95
	call	endwin@PLT
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	outstr(%rip), %rdx
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	salq	$5, %rax
	leaq	filenames(%rip), %rcx
	addq	%rcx, %rax
	movq	%rax, %rsi
	leaq	.LC17(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$1, %edi
	call	exit@PLT
.L98:
	nop
	jmp	.L95
.L99:
	nop
.L95:
	addl	$1, -4(%rbp)
.L93:
	movl	file_count(%rip), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L97
	movl	$0, %eax
	call	fill_filenames
	movl	$0, %eax
	call	fill_outitems
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	do_apply, .-do_apply
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
