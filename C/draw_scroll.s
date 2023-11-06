 .include "helper.inc"   
    
    .section .rodata
    .text
.LC0:
	.string	"%s"
.LC1:
	.string	"%d / %d"
	.globl	draw_scroll
	.type	draw_scroll, @function
draw_scroll:
.LFB7:
	begin_func
	pushq	%rbx
	subq	$376, %rsp
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
	call	wclear@PLT # wclear(wnd)

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
	call	wborder@PLT # box(wnd, 0, 0)

	addq	$32, %rsp
	cmpq	$0, -360(%rbp)
	je	.L1
	movq	-360(%rbp), %rax
	movzwl	4(%rax), %eax
	cwtl
	addl	$1, %eax
	jmp	.L2
.L1:
	movl	$-1, %eax
.L2:
	movl	%eax, -336(%rbp)
	cmpq	$0, -360(%rbp)
	je	.L3
	movq	-360(%rbp), %rax
	movzwl	6(%rax), %eax
	cwtl
	addl	$1, %eax
	jmp	.L4
.L3:
	movl	$-1, %eax
.L4:
	movl	%eax, -332(%rbp) # getmaxyx(stdscr, height, width)

	subl	$3, -336(%rbp) # height -= 3
	subl	$2, -332(%rbp) # width -= 2

	movl	-368(%rbp), %eax
	negl	%eax # -offset_y

	movl	%eax, %esi
	movl	$0, %edi
	call	max@PLT # max(0, -offset_y)

	movl	%eax, -344(%rbp) # i = max(0, -offset_y)

	jmp	.L13
.L5:
	movl	-344(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-376(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	strlen@PLT # strlen(items[i])

	movl	%eax, -324(%rbp) # int item_len = strlen(items[i])

	movl	$0, -340(%rbp) # int dx = 0

	cmpl	$0, -364(%rbp)
	jle	.L6 # !if(offset_x > 0)

	movl	$0, -340(%rbp) # dx = 0

	jmp	.L9
.L6:
	movl	-324(%rbp), %eax
	cmpl	-332(%rbp), %eax
	jge	.L7 # !else if(item_len < width)

	movl	$0, -340(%rbp) # dx = 0

	jmp	.L9
.L7:
	movl	-324(%rbp), %edx
	movl	-364(%rbp), %eax
	addl	%edx, %eax
	cmpl	%eax, -332(%rbp)
	jle	.L8 # ! else if(item_len + offset_x < width)

	movl	-324(%rbp), %eax
	subl	-332(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -340(%rbp) # dx = item_len - width + 1

	jmp	.L9

.L8:
	movl	-364(%rbp), %eax
	negl	%eax
	movl	%eax, -340(%rbp) # dx = - offset_x

.L9:
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
	movslq	%eax, %rsi # min(width, max_str_len)

	leaq	-320(%rbp), %rax
	movq	%rbx, %rcx
	leaq	.LC0(%rip), %rdx
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT # snprintf(buf,min(width, max_str_len), "%s", items[i] + dx)

	cmpq	$0, -384(%rbp)
	je	.L10 # if(errs != NULL)

	movl	-344(%rbp), %eax
	movslq	%eax, %rdx
	movq	-384(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L10 # if( errs[i])

	movq	-360(%rbp), %rax
	movl	$0, %edx
	movl	$4096, %esi
	movq	%rax, %rdi
	call	wattr_on@PLT# wattron(wnd, COLOR_PAIR(16))

.L10:
	movl	-344(%rbp), %edx
	movl	-368(%rbp), %eax
	addl	%edx, %eax
	leal	1(%rax), %ecx
	movq	-360(%rbp), %rax
	movl	$1, %edx
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	wmove@PLT # mv(wnd, i + offset_y + 1, 1, buf, width)
	cmpl	$-1, %eax
	je	.L11
	movl	-332(%rbp), %edx
	leaq	-320(%rbp), %rcx
	movq	-360(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	waddnstr@PLT # waddnstr(wnd, i + offset_y + 1, 1, buf, width)

.L11:
	cmpq	$0, -384(%rbp)
	je	.L12 # if(errs != NULL )

	movl	-344(%rbp), %eax
	movslq	%eax, %rdx
	movq	-384(%rbp), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L12 # if( errs[i])

	movq	-360(%rbp), %rax
	movl	$0, %edx
	movl	$4096, %esi
	movq	%rax, %rdi
	call	wattr_off@PLT # wattroff(wnd, COLOR_PAIR(16))

.L12:
	addl	$1, -344(%rbp) # i++ 

.L13:
	movl	-336(%rbp), %eax
	subl	-368(%rbp), %eax
	movl	%eax, %edx
	movl	file_count(%rip), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	min@PLT
	cmpl	%eax, -344(%rbp) # i < min(file_count, -offset_y + height)

	jl	.L5

	movl	file_count(%rip), %ebx # file_count

	movl	-332(%rbp), %eax
	movl	$288, %esi
	movl	%eax, %edi
	call	min@PLT 
	movslq	%eax, %rsi # min(width, max_str_len)

	movl	-344(%rbp), %edx
	leaq	-320(%rbp), %rax
	movl	%ebx, %r8d
	movl	%edx, %ecx

	leaq	.LC1(%rip), %rdx # "%d / %d"

	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT # snprintf(buf, min(width, max_str_len), "%d / %d", i, file_count)

	movl	%eax, -328(%rbp) #int len赋值

	movl	-332(%rbp), %eax
	subl	-328(%rbp), %eax
	movl	%eax, %edx
	movl	-336(%rbp), %eax
	leal	1(%rax), %ecx
	movq	-360(%rbp), %rax
	movl	%ecx, %esi
	movq	%rax, %rdi
	call	wmove@PLT # mv(wnd, height + 1, width - len, buf)

	cmpl	$-1, %eax
	je	.L14
	leaq	-320(%rbp), %rcx
	movq	-360(%rbp), %rax
	movl	$-1, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	waddnstr@PLT # waddstr(wnd, height + 1, width - len, buf)

.L14:
	movq	-360(%rbp), %rax
	movq	%rax, %rdi
	call	wrefresh@PLT # wrefresh(wnd)

	movq	-24(%rbp), %rax
	subq	%fs:40, %rax
	je	.L15
	call	__stack_chk_fail@PLT # 函数失败
.L15:
    end_func
