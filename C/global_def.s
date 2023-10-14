	.file	"global_def.s"

	.text
	.globl	list_rect
	.bss
	.align 16
	.type	list_rect, @object
	.size	list_rect, 16
list_rect:
	.zero	16

	.globl	out_rect
	.align 16
	.type	out_rect, @object
	.size	out_rect, 16
out_rect:
	.zero	16

	.globl	form_rect
	.align 16
	.type	form_rect, @object
	.size	form_rect, 16
form_rect:
	.zero	16

	.globl	list_win
	.align 8
	.type	list_win, @object
	.size	list_win, 8
list_win:
	.zero	8

	.globl	file_count
	.align 4
	.type	file_count, @object
	.size	file_count, 4
file_count:
	.zero	4

	.globl	filenames
	.align 32
	.type	filenames, @object
	.size	filenames, 73728
filenames:
	.zero	73728

	.globl	list_items
	.align 32
	.type	list_items, @object
	.size	list_items, 2048
list_items:
	.zero	2048

	.globl	offset_x
	.align 4
	.type	offset_x, @object
	.size	offset_x, 4
offset_x:
	.zero	4

	.globl	offset_y
	.align 4
	.type	offset_y, @object
	.size	offset_y, 4
offset_y:
	.zero	4

	.globl	out_win
	.align 8
	.type	out_win, @object
	.size	out_win, 8
out_win:
	.zero	8

	.globl	outstr
	.align 32
	.type	outstr, @object
	.size	outstr, 73728
outstr:
	.zero	73728

	.globl	out_items
	.align 32
	.type	out_items, @object
	.size	out_items, 2048
out_items:
	.zero	2048

	.globl	out_err
	.align 32
	.type	out_err, @object
	.size	out_err, 256
out_err:
	.zero	256

	.globl	mat_err
	.type	mat_err, @object
	.size	mat_err, 1
mat_err:
	.zero	1

	.globl	sub_buf
	.align 32
	.type	sub_buf, @object
	.size	sub_buf, 288
sub_buf:
	.zero	288

	.globl	form_win
	.align 8
	.type	form_win, @object
	.size	form_win, 8
form_win:
	.zero	8

	.globl	form_cdk
	.align 8
	.type	form_cdk, @object
	.size	form_cdk, 8
form_cdk:
	.zero	8

	.globl	pat_entry
	.align 8
	.type	pat_entry, @object
	.size	pat_entry, 8
pat_entry:
	.zero	8

	.globl	rep_entry
	.align 8
	.type	rep_entry, @object
	.size	rep_entry, 8
rep_entry:
	.zero	8

	.globl	ftr_btn
	.align 8
	.type	ftr_btn, @object
	.size	ftr_btn, 8
ftr_btn:
	.zero	8

	.globl	cfm_btn
	.align 8
	.type	cfm_btn, @object
	.size	cfm_btn, 8
cfm_btn:
	.zero	8

	.globl	focus_group
	.align 32
	.type	focus_group, @object
	.size	focus_group, 128
focus_group:
	.zero	128

	.globl	current_focus
	.align 4
	.type	current_focus, @object
	.size	current_focus, 4
current_focus:
	.zero	4

	.globl	focus_group_size
	.align 4
	.type	focus_group_size, @object
	.size	focus_group_size, 4
focus_group_size:
	.zero	4