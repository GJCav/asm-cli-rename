
	.section .rodata
    .text
	.globl	fill_outitems
	.type	fill_outitems, @function

fill_outitems:
	pushq	%rbp
	movq	%rsp, %rbp

	subq	$16, %rsp
	movl	$0, -4(%rbp)             # i = 0
	jmp	.loop_cnd
.loop_body:
	movl	-4(%rbp), %eax           # %eax = i
	leaq	0(,%rax,8), %rdx
	leaq	list_items(%rip), %rax   # %rax = &list_items[0]
	movq	(%rdx,%rax), %rax        # %rax = list_items[i]
	movq	%rax, %rdi
	call	match

	movzbl	mat_err(%rip), %edx
	movl	-4(%rbp), %eax           # %eax = i
	leaq	out_err(%rip), %rcx      # %rcx = &out_err
	movb	%dl, (%rax,%rcx)         # out_err[i] = mat_err

	movl	-4(%rbp), %eax           # %rax = i
	movslq	%eax, %rdx
	movq	%rdx, %rax               # signed extend
	salq	$3, %rax                 # %rax *= 8
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	outstr(%rip), %rdx
	addq	%rdx, %rax               # %rax = &outstr[i]
	movl	$288, %edx
	leaq	sub_buf(%rip), %rcx
	movq	%rcx, %rsi               # %rsi = &sub_buf
	movq	%rax, %rdi               # %rdi = &outstr[i]
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
	leaq	0(,%rax,8), %rdx
	leaq	out_items(%rip), %rax
	movq	%rcx, (%rdx,%rax)       # out_items[i] = &outstr[i]

	addl	$1, -4(%rbp)            # i += 1
.loop_cnd:
	movl	file_count(%rip), %eax
	cmpl	%eax, -4(%rbp)
	jl	.loop_body


	leave
	ret
