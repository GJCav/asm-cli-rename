
.macro save_regs
    # pay attention to keep the stack 16-byte aligned
    # (see https://courses.cs.washington.edu/courses/cse378/10au/sections/Section1_recap.pdf)
    push    %rcx
    push    %rdx
    push    %rsi
    push    %rdi
    push    %r8
    push    %r9
    push    %r10
    push    %r11
.endm

.macro restore_regs
    pop     %r11
    pop     %r10
    pop     %r9
    pop     %r8
    pop     %rdi
    pop     %rsi
    pop     %rdx
    pop     %rcx
.endm

.macro begin_func
    push    %rbp
    mov     %rsp,  %rbp                 # create a stack frame

    # save callee-saved registers
    push    %rbx
    push    %rbx    # rbp is pushed twice to keep the stack 16-byte aligned
    push    %r12
    push    %r13
    push    %r14
    push    %r15
.endm

.macro end_func
    # restore callee-saved registers
    pop     %r15
    pop     %r14 
    pop     %r13
    pop     %r12
    pop     %rbx
    pop     %rbx
    leave
    ret
.endm
