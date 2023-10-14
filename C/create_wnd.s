.include "helper.inc"

	.section .rodata
    .text
	.globl	create_wnd
	.type	create_wnd, @function
create_wnd:
.LFB7:
	begin_func
	subq	$16, %rsp       # align to 16

	call	newwin
	movq	%rax, -8(%rbp)  # -8(%rbp) = wnd

	subq	$8, %rsp        # align to 16
	pushq	$0
	pushq	$0
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	movl	$0, %ecx
	movl	$0, %edx
	movl	$0, %esi
	movq	 -8(%rbp), %rdi
	call	wborder

	addq	$32, %rsp      # pop 4 times
	
	movq	-8(%rbp), %rdi
	call	wrefresh

	movq	-8(%rbp), %rax # return wnd
	end_func

