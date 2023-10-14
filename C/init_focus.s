.include "helper.inc"

    .section .rodata
    .text

    .globl	init_focus
	.type	init_focus, @function
init_focus:
.LFB15:
	begin_func
	movq	list_win(%rip), %rax
	movq	%rax, focus_group(%rip)    #focus_group[0] = (void*) list_win;
	movq	pat_entry(%rip), %rax
	movq	%rax, 8+focus_group(%rip)  #focus_group[1] = (void*) pat_entry;
	movq	rep_entry(%rip), %rax
	movq	%rax, 16+focus_group(%rip) #focus_group[2] = (void*) rep_entry;
	movq	ftr_btn(%rip), %rax
	movq	%rax, 24+focus_group(%rip) #focus_group[3] = (void*) ftr_btn;
	movq	cfm_btn(%rip), %rax
	movq	%rax, 32+focus_group(%rip) #focus_group[4] = (void*) cfm_btn;
	movl	$5, focus_group_size(%rip) #focus_group_size = 5;
	nop
	end_func