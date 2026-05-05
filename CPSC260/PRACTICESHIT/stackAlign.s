.global _start

.section .text

_start:
    movq $5, %rdi       # first argument
    movq $3, %rsi       # second argument
    call myFunction

    movq $60, %rax
    xor %rdi, %rdi
    syscall

myFunction:

    pushq %rbp

    movq %rdi, %rax
    addq %rsi, %rax

    popq %rbp
    # prologue - set up the stack frame
    
    # do something with the two arguments
    # maybe add them together?

    # epilogue - tear down the stack frame
    ret