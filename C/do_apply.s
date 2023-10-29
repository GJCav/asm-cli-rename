.include "helper.inc" 	
    .section	.rodata
.LC17:
	.string	"Error renaming %s to %s\n"
	.text
	.globl	do_apply
	.type	do_apply, @function
do_apply:
.LFB17:
	begin_func

	movl	$0, -4(%rbp)
	jmp	.L4
.L0:
	movl	-4(%rbp), %eax
	cltq                         #  Sign-extend %eax into %rdx.

	leaq	out_err(%rip), %rdx
	movzbl	(%rax,%rdx), %eax

	testb	%al, %al             #  Test if the byte is zero (end of string).
	jne	.L1
       # compare strings and perform file operations
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax

	salq	$3, %rax  # *8
	addq	%rdx, %rax

	salq	$5, %rax  # *32

	leaq	outstr(%rip), %rdx  # get address
	addq	%rax, %rdx

	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax

	salq	$3, %rax
	addq	%rcx, %rax

	salq	$5, %rax

	leaq	filenames(%rip), %rcx  # filenames[]address
	addq	%rcx, %rax

	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT

	testl	%eax, %eax
	je	.L2

	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax

	salq	$3, %rax
	addq	%rdx, %rax

	salq	$5, %rax

	leaq	outstr(%rip), %rdx # String outstr address
	addq	%rax, %rdx

	movl	-4(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax

	salq	$3, %rax
	addq	%rcx, %rax

	salq	$5, %rax

	leaq	filenames(%rip), %rcx   # filenames[]address
	addq	%rcx, %rax

	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	rename@PLT  # rename func

	testl	%eax, %eax
	je	.L3

	call	endwin@PLT   # if rename failed ,call
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax

	salq	$3, %rax  # *8
	addq	%rdx, %rax

	salq	$5, %rax   # *32

	leaq	outstr(%rip), %rdx  # outstr address
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
.L1:
	nop
	jmp	.L3
.L2:
	nop
.L3:
	addl	$1, -4(%rbp)    #  Increment the local variable by 1.
.L4:
	movl	file_count(%rip), %eax
	cmpl	%eax, -4(%rbp)    #  Compare file_count with the local variable.
	jl	.L0                  #  Jump to .L0 if the loop condition is met.
	movl	$0, %eax
	call	fill_filenames
	movl	$0, %eax
	call	fill_outitems
	end_func