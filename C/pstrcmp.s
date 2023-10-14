.include "helper.inc"

	.section .rodata
    .text
	.globl	pstrcmp
	.type	pstrcmp, @function
pstrcmp:
    pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp        # align to 16
	movq	%rdi, -8(%rbp)   # -8(%rbp) = a
	movq	%rsi, -16(%rbp)  # -16(%rbp) = b
	movq	-16(%rbp), %rax 
	movq	(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp
	leave
	ret
   