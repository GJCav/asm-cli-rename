.include "helper.inc"
.LC0:
	.string	"."
	.align 8
.LC1:
	.string	"Error opening current directory"
	.section .rodata
    .text
    .globl	fill_filenames
	.type	fill_filenames, @function
fill_filenames:
.LFB7:
    begin_func
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	opendir@PLT #opendir(".")
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)  # dir==NULL
	jne	.L0              
	call	endwin@PLT   #endwin()

	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT   #printf(.LC1)

	movl	$1, %edi
	call	exit@PLT   # exit(1)
.L0:
	movl	$0, file_count(%rip)  # file_count = 0
	jmp	.L3
.L1:
	movq	-8(%rbp), %rax #ent
	movzbl	18(%rax), %eax #ent->d_type
	cmpb	$4, %al  # ent->d_type == DT_DIR
	jne	.L2
	jmp	.L3
.L2:
	movq	-8(%rbp), %rax  #ent
	leaq	19(%rax), %rdx  #ent->d_name
	movl	file_count(%rip), %eax
	movslq	%eax, %rcx
	movq	%rcx, %rax
	salq	$3, %rax
	addq	%rcx, %rax
	salq	$5, %rax
	leaq	filenames(%rip), %rcx
	addq	%rcx, %rax   #filenames[file_count]

	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy@PLT #strcpy(filenames[file_count], ent->d_name)

	movl	file_count(%rip), %eax
	movl	file_count(%rip), %esi
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$3, %rax
	addq	%rdx, %rax
	salq	$5, %rax
	leaq	filenames(%rip), %rdx
	leaq	(%rax,%rdx), %rcx  # list_items[file_count]

	movslq	%esi, %rax
	leaq	0(,%rax,8), %rdx
	leaq	list_items(%rip), %rax
	movq	%rcx, (%rdx,%rax)   # list_items[file_count] = filenames[file_count]

	movl	file_count(%rip), %eax
	addl	$1, %eax               
	movl	%eax, file_count(%rip) #file_count++;
.L3:
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	readdir@PLT # readdir(dir)

	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)  #ent != NULL
	jne	.L1

	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	closedir@PLT #closedir(dir)

	movl	file_count(%rip), %eax
	cltq
	movq	pstrcmp@GOTPCREL(%rip), %rdx
	movq	%rdx, %rcx
	movl	$8, %edx
	movq	%rax, %rsi
	leaq	list_items(%rip), %rax
	movq	%rax, %rdi
	call	qsort@PLT # qsort(list_items, file_count, sizeof(list_items[0]), pstrcmp)+
	end_func