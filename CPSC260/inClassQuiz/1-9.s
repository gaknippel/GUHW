# A simple program that prints every number from 1 to 9

.global _start
.text
_start:
        movq    $1, %rax  # syscall number 1 = sys_write
        movq    $1, %rdi  # file descriptor 1 = stdout (the screen)

        movq    $49, %r10 # moves 49 (1) into register r10


loop:
        push %r10  # decrements rsp by 8, stores r10's value at that memory address
        movq %rsp, %rsi # makes rsi point to stack address, so it can print the stack
        movq $1, %rdx # moves 1 into rdx, (the print call)
        syscall # prints
        popq %r10 # takes away the stack memory address?
        addq $1, %r10 # increments %r10 by 1
        cmpq $57, %r10  # "compare 57 to r10" → is r10 > 57? (57 = 9)
        jle loop # jump back to loop if %r10 is less than or equal to 57


exit:
        movq    $60, %rax # exits program
        xor     %rdi, %rdi
        syscall
