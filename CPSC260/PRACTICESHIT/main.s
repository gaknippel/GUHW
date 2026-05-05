.global _start

.section .text

_start:

    movq $5, %rdi
    movq $2, %rsi

    call add

    movq $60, %rax
    xorq %rdi, %rdi
    syscall
    # put your two numbers into the right argument registers
    # then call the function
    # then exit



add:
    movq %rdi, %rax

    addq %rsi, %rax

    ret
    # add the two arguments together
    # put the result in the right place
    # return
    