.include "helper.inc"

	.section .rodata
    .text
	.globl	cur_focus
	.type	cur_focus, @function

cur_focus:
	pushq	%rbp
	movq	%rsp, %rbp

	movl	current_focus(%rip), %eax # eax = current_focus
	leaq	0(,%rax,8), %rdx          # rdx = current_focus * 8
	leaq	focus_group(%rip), %rax   # rax = &focus_group
	movq	(%rdx,%rax), %rax         # rax = focus_group[current_focus]

	popq	%rbp
	ret

