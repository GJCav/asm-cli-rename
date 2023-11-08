.section	.rodata
.LC7:
	.string	"Matching error: %s"  # 错误消息模板，格式化错误消息
.LC8:
	.string	"error: %s"
	.text
	.globl	match
	.type	match, @function
match:
.L0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$368, %rsp

	
	movq	%rdi, -360(%rbp)
	movq	%fs:40, %rax  # 栈溢出检查
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movq	pat_entry(%rip), %rax  # 获取正则表达式模式字符串的地址
	movq	%rax, %rdi

	call	getCDKEntryValue@PLT # getCDKEntryValue(pat_entry)
	movq	%rax, -336(%rbp)
	movq	rep_entry(%rip), %rax
	movq	%rax, %rdi
	call	getCDKEntryValue@PLT  # getCDKEntryValue(rep_entry)
	movq	%rax, -328(%rbp)

	movl	$0, -352(%rbp) # 错误信息及偏移量
	movl	$0, -348(%rbp)
	leaq	-348(%rbp), %rcx
	leaq	-352(%rbp), %rdx
	movq	-336(%rbp), %rax

	movl	$0, %r9d
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$0, %edx
	movq	$-1, %rsi
	movq	%rax, %rdi
	call	pcre2_compile_8@PLT

	movq	%rax, -320(%rbp)
	cmpq	$0, -320(%rbp)  # 检查编译是否成功
	jne	.L1
	movb	$1, mat_err(%rip)
	movl	-352(%rbp), %eax
	movl	$288, %edx
	leaq	sub_buf(%rip), %rcx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	pcre2_get_error_message_8@PLT  # 调用pcre2_get_error_message_8函数获取错误消息
	jmp	.L6
.L1:
	movq	-320(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pcre2_match_data_create_from_pattern_8@PLT
	movq	%rax, -312(%rbp)
	movl	$0, -340(%rbp)
	movq	-312(%rbp), %rdx
	movq	-360(%rbp), %rsi
	movq	-320(%rbp), %rax

	subq	$8, %rsp
	pushq	$0
	movq	%rdx, %r9
	movl	$0, %r8d
	movl	$0, %ecx
	movq	$-1, %rdx
	movq	%rax, %rdi
	call	pcre2_match_8@PLT # 调用pcre2_match_8函数进行匹配
	addq	$16, %rsp # 恢复栈

	movl	%eax, -340(%rbp)
	cmpl	$0, -340(%rbp)
	jns	.L3
	movb	$1, mat_err(%rip)
	cmpl	$-1, -340(%rbp)
	jne	.L2
	movabsq	$7521983764430352206, %rax
	movq	%rax, sub_buf(%rip)
	movb	$0, 8+sub_buf(%rip)
	jmp	.L5
.L2:
	leaq	-304(%rbp), %rcx
	movl	-340(%rbp), %eax
	movl	$288, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi

	call	pcre2_get_error_message_8@PLT
	leaq	-304(%rbp), %rax
	movq	%rax, %rcx
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdx
	movl	$288, %esi
	leaq	sub_buf(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax

	call	snprintf@PLT
	jmp	.L5
.L3:
	movb	$0, mat_err(%rip) # 设置匹配错误标志为假
	movl	$288, -344(%rbp)
	movq	-360(%rbp), %rsi
	movq	-320(%rbp), %rax # 获取编译后的正则表达式的地址
	subq	$8, %rsp
	leaq	-344(%rbp), %rdx

	pushq	%rdx    # 传参
	leaq	sub_buf(%rip), %rdx
	pushq	%rdx
	pushq	$-1
	pushq	-328(%rbp)
	pushq	$0
	movl	$0, %r9d
	movl	$0, %r8d
	movl	$0, %ecx
	movq	$-1, %rdx
	movq	%rax, %rdi
	call	pcre2_substitute_8@PLT
	addq	$48, %rsp      # 恢复栈指针

	movl	%eax, -352(%rbp)  # 替换结果的长度
	movl	-352(%rbp), %eax
	testl	%eax, %eax
	jns	.L4

	movb	$1, mat_err(%rip)
	movl	-352(%rbp), %eax
	leaq	-304(%rbp), %rcx
	movl	$288, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	pcre2_get_error_message_8@PLT
	leaq	-304(%rbp), %rax
	movq	%rax, %rcx
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdx
	movl	$288, %esi
	leaq	sub_buf(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf@PLT
	jmp	.L5
.L4:
	movl	-344(%rbp), %eax
	testl	%eax, %eax
	jne	.L5
	movb	$1, mat_err(%rip)
	movabsq	$7309940851192393061, %rax  # 将"empty result"字符串的地址加载到rax寄存器中
	movq	%rax, sub_buf(%rip)  # 将"empty result"字符串的地址存储到sub_buf中
	movl	$1953265011, 8+sub_buf(%rip)  # 将"empty result"字符串的长度存储到sub_buf中
	movb	$0, 12+sub_buf(%rip)  # 在sub_buf中添加NULL
.L5:
	movq	-312(%rbp), %rax
	movq	%rax, %rdi
	call	pcre2_match_data_free_8@PLT
	movq	-320(%rbp), %rax
	movq	%rax, %rdi
	call	pcre2_code_free_8@PLT
.L6:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax  # 计算当前栈边界与保存的栈边界的偏移量
	je	.L7  # 未溢出
	call	__stack_chk_fail@PLT # 溢出
.L7:
	leave
	ret
	.cfi_endproc