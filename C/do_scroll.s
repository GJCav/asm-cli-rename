.include "helper.inc"  

.section .rodata
.text
.globl do_scroll       

.type do_scroll, @function 

do_scroll:
.LFB11:                 

    begin_func         

    movl	%edi, -20(%rbp)
	cmpl	$258, -20(%rbp)
	jne	.L0

	movl	offset_y(%rip), %eax
	subl	$1, %eax
	movl	%eax, offset_y(%rip)

	jmp	.L5
.L0:
	cmpl	$259, -20(%rbp)
	jne	.L1                   # if not equal 

	movl	offset_y(%rip), %eax
	addl	$1, %eax
	movl	%eax, offset_y(%rip)

	jmp	.L5
.L1:
	cmpl	$260, -20(%rbp)
	jne	.L2

	movl	offset_x(%rip), %eax
	addl	$1, %eax
	movl	%eax, offset_x(%rip)

	jmp	.L5
.L2:
	cmpl	$261, -20(%rbp)
	jne	.L3

	movl	offset_x(%rip), %eax
	subl	$1, %eax         # add 1
	movl	%eax, offset_x(%rip)

	jmp	.L5
.L3:
	cmpl	$339, -20(%rbp)
	jne	.L4

	movl	offset_y(%rip), %eax
	addl	$10, %eax
	movl	%eax, offset_y(%rip)

	jmp	.L5
.L4:
	cmpl	$338, -20(%rbp)
	jne	.L5

	movl	offset_y(%rip), %eax
	subl	$10, %eax
	movl	%eax, offset_y(%rip)
.L5:
	movl	offset_x(%rip), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	min@PLT       # call func min
	movl	%eax, offset_x(%rip)

	movl	file_count(%rip), %eax  # file_count
	movl	$10, %edx
	subl	%eax, %edx
	movl	offset_y(%rip), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	max@PLT
	movl	%eax, offset_y(%rip)  # to offset_y

	movl	offset_y(%rip), %eax
	movl	$0, %esi
	movl	%eax, %edi
	call	min@PLT
	movl	%eax, offset_y(%rip)
        # initialize
	movl	$0, -8(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L7
.L6:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	list_items(%rip), %rax  # list_items[] address
	movq	(%rdx,%rax), %rax
	movq	%rax, %rdi
	call	strlen@PLT

	movl	%eax, %edx
	movl	-8(%rbp), %eax
	movl	%edx, %esi  # string length
	movl	%eax, %edi
	call	max@PLT
	movl	%eax, -8(%rbp)  # result to -8(%rbp)

	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	out_items(%rip), %rax    # out_items[] address
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
.L7:
	movl	file_count(%rip), %eax  # filecount to %eax
	cmpl	%eax, -4(%rbp)
	jl	.L6   # if < filecount,jump
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

    end_func            

