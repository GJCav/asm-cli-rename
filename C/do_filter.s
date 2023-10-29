 .include "helper.inc"   
    
    .section .rodata
    .text
    .globl	do_filter
	.type	do_filter, @function
do_filter:
.LFB11:
	begin_func
	movl	file_count(%rip), %eax 
	movl	%eax, -4(%rbp) #int count = file_count
	movl	$0, file_count(%rip) # file_count = 0;
	movl	$0, -12(%rbp)
	jmp	.L2
.L0:
	movl	-12(%rbp), %eax
	cltq
	leaq	out_err(%rip), %rdx
	movzbl	(%rax,%rdx), %eax
	xorl	$1, %eax
	testb	%al, %al
	je	.L1
	movl	-12(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	list_items(%rip), %rax
	movq	(%rdx,%rax), %rdx  # list_items[i]

	movl	file_count(%rip), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	salq	$5, %rax # file_count

	leaq	outstr(%rip), %rcx
	addq	%rcx, %rax # outstr[file_count]

	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT #  strcpy(outstr[file_count], list_items[i])

	movl	file_count(%rip), %eax
	addl	$1, %eax
	movl	%eax, file_count(%rip) # file_count++
.L1:
	addl	$1, -12(%rbp) # i++
.L2:
	movl	-12(%rbp), %eax
	cmpl	-4(%rbp), %eax  # if !out_err[i]
	jl	.L0
	movl	$0, -8(%rbp) # i = 0
	jmp	.L4
.L3:
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax  # i

	leaq	outstr(%rip), %rdx
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	salq	$5, %rax # outstr[i]

	leaq	filenames(%rip), %rcx
	addq	%rcx, %rax # filenames[i]

	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT # strcpy(filenames[i], outstr[i])

	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax # i

	leaq	filenames(%rip), %rdx
	leaq	(%rax,%rdx), %rcx
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx # filenames[i]

	leaq	list_items(%rip), %rax # list_items[i]
	movq	%rcx, (%rdx,%rax) # list_items[i] = filenames[i]

	addl	$1, -8(%rbp) # ++
.L4:
	movl	file_count(%rip), %eax
	cmpl	%eax, -8(%rbp)  # i < file_count
	jl	.L3

	movl	$0, %eax
	call	fill_outitems@PLT # fill_outitems();
	end_func