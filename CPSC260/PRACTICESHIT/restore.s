.global _start

.section .text

_start:
    movq $10, %rbx      # store something important in a callee-saved register

    pushq %rbx
    movq %rbx, %rdi
    call myFunction
    # %rbx should still be 10 here after the call!

    movq $60, %rax
    xor %rdi, %rdi
    syscall

myFunction:

    movq %rdi, %rax
    incq %rax
    popq %rbx
    # save %rbx before using it
    # do something with %rbx (change it to anything)
    # restore %rbx before returning
    ret