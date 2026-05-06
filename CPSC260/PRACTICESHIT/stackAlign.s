.global _start

.section .text

_start:
    movq $7, %rdi       # first argument
    movq $4, %rsi       # second argument
    call subtract

    # %rax should hold the result here

    movq $60, %rax
    xor %rdi, %rdi
    syscall

subtract:
    pusq %rbp

    movq %rdi, %rax
    subq %rsi, %rax

    popq %rbp
    # prologue
    
    # subtract second argument from first
    # result in %rax

    # epilogue
    ret