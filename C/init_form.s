.include "helper.inc"

    .section	.rodata

.LC3:
	.string	"</32>"
.LC11:
	.string	"Pattern: "
.LC12:
	.string	"Replace: "
.LC13:
	.string	"Error creating entry fields"
.LC14:
	.string	"  Filter  "
.LC15:
	.string	"  Apply   "
.LC16:
	.string	"Error creating buttons"
	.text
	.globl	init_form
	.type	init_form, @function
	
init_form:
.Loop:
	begin_func

	movl	$10, -12(%rbp)
	movl	12+form_rect(%rip), %ecx  # form_rect.height
	movl	8+form_rect(%rip), %edx   # form_rect.width

	movl	form_rect(%rip), %esi
	movl	4+form_rect(%rip), %eax
	movl	%eax, %edi

	call	create_wnd@PLT  # 调用create_wnd函数创建窗口

	movq	%rax, form_win(%rip)  # 将create_wnd的返回值存储到form_win变量中
	movq	form_win(%rip), %rax
	movq	%rax, %rdi
	call	initCDKScreen@PLT  # 初始化CDK屏幕和界面元素

	movq	%rax, form_cdk(%rip)
	movl	form_rect(%rip), %eax
	subl	$2, %eax
	subl	-12(%rbp), %eax
	subl	$10, %eax
	movl	%eax, -8(%rbp)

	movl	8+form_rect(%rip), %eax # 从内存中读取form_rect的width
	leal	1(%rax), %edx
	movl	12+form_rect(%rip), %eax # 从内存中读取form_rect的height
	leal	1(%rax), %esi
	movq	form_cdk(%rip), %rax
	subq	$8, %rsp
	pushq	$0
	pushq	$0
	pushq	$288
	pushq	$0
	movl	-8(%rbp), %ecx
	pushq	%rcx
	pushq	$5
	pushq	$95
	movl	$0, %r9d
	leaq	.LC11(%rip), %r8
	movl	$0, %ecx
	movq	%rax, %rdi
	call	newCDKEntry@PLT

	addq	$64, %rsp # 释放栈空间
	movq	%rax, pat_entry(%rip)
	movl	8+form_rect(%rip), %eax # form_rect的width
	leal	2(%rax), %edx
	movl	12+form_rect(%rip), %eax # height
	leal	1(%rax), %esi
	movq	form_cdk(%rip), %rax
	subq	$8, %rsp
	pushq	$0
	pushq	$0
	pushq	$288
	pushq	$0
	movl	-8(%rbp), %ecx
	pushq	%rcx
	pushq	$5
	pushq	$95
	movl	$0, %r9d
	leaq	.LC12(%rip), %r8
	movl	$0, %ecx
	movq	%rax, %rdi
	call	newCDKEntry@PLT
	addq	$64, %rsp
	movq	%rax, rep_entry(%rip)
	movq	pat_entry(%rip), %rax
	testq	%rax, %rax
	je	.L1
	movq	rep_entry(%rip), %rax
	testq	%rax, %rax
	jne	.L2
.L1:
	call	endCDK@PLT
	call	endwin@PLT
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L2:
	movq	pat_entry(%rip), %rax # pat_entry地址
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	pat_entry(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax

	movq	rep_entry(%rip), %rax # rep_entry地址
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	rep_entry(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax

	movl	12+form_rect(%rip), %eax # 读取form_rect的width到%eax
	leal	1(%rax), %edx
	movl	-8(%rbp), %eax
	addl	%edx, %eax
	addl	$10, %eax
	movl	%eax, -4(%rbp)

	movl	8+form_rect(%rip), %eax
	leal	1(%rax), %edx
	movq	form_cdk(%rip), %rax
	movl	-4(%rbp), %esi
	subq	$8, %rsp
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	leaq	.LC14(%rip), %rcx
	movq	%rax, %rdi
	call	newCDKButton@PLT # 初始化输入框和按钮等界面元素

	addq	$16, %rsp
	movq	%rax, ftr_btn(%rip)
	
	movl	8+form_rect(%rip), %eax
	leal	2(%rax), %edx
	movq	form_cdk(%rip), %rax
	movl	-4(%rbp), %esi
	subq	$8, %rsp
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	leaq	.LC15(%rip), %rcx
	movq	%rax, %rdi
	call	newCDKButton@PLT  # 调用newCDKButton函数

	addq	$16, %rsp # 释放栈空间
	movq	%rax, cfm_btn(%rip) # 将newCDKButton的返回值存储到cfm_btn变量中

	movq	ftr_btn(%rip), %rax
	testq	%rax, %rax
	je	.L3
	movq	cfm_btn(%rip), %rax
	testq	%rax, %rax # 测试%rax值是否为0
	jne	.L4
.L3:
	call	endCDK@PLT # 结束CDK库的使用
	call	endwin@PLT
	leaq	.LC16(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L4:
	movl	$-1, %edx
	movl	$-1, %esi
	movl	$32, %edi
	call	init_pair@PLT  # 传参，定义颜色
	movl	$-1, %edx
	movl	$4, %esi
	movl	$33, %edi
	call	init_pair@PLT
	movq	ftr_btn(%rip), %rax # 读取偏移地址
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT
	movq	cfm_btn(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	setCDKObjectBackgroundColor@PLT
	movq	ftr_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	ftr_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	movq	cfm_btn(%rip), %rax
	movq	16(%rax), %rax
	movq	8(%rax), %rax
	movq	cfm_btn(%rip), %rdx
	movl	$0, %esi
	movq	%rdx, %rdi
	call	*%rax
	
	end_func