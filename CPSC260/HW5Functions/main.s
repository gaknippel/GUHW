.global _start
    .text

_start:
    # print the unsorted string
    mov     $1, %rax
    mov     $1, %rdi
    mov     $message, %rsi
    mov     $16, %rdx
    syscall

    # calling bubble sort
    movq    $message, %rdi
    movq    $15, %rsi
    call    bubble_sort

    # print the sorted string
    mov     $1, %rax
    mov     $1, %rdi
    mov     $message, %rsi
    mov     $16, %rdx
    syscall

    # exit
    movq    $60, %rax
    xor     %rdi, %rdi
    syscall


    # compares the byte at rsi with the byte at rsi+1

compare_and_swap:
    pushq   %rbp            
    movq    %rsp, %rbp

    movq    %rdi, %rsi      # rsi = pointer to current char
    movq    %rdi, %rdx      # rdx = pointer to next char
    incq    %rdx

    movb    (%rsi), %al     # al = current char
    movb    (%rdx), %cl     # cl = next char

    cmpb    %cl, %al        # compare current vs next
    jle     .no_swap        # if current <= next, skip swap

    movb    %cl, (%rsi)     # swap: write next into current slot
    movb    %al, (%rdx)     # swap: write current into next slot

.no_swap:
    popq    %rbp         
    ret


    # runs bubble sort on the text

bubble_sort:
    pushq   %rbp         
    movq    %rsp, %rbp

    # save callee saved regs
    pushq   %rbx            # array base address
    pushq   %r12            # length
    pushq   %r13            # outer loop counter
    pushq   %r14            # inner loop pointer

    # add 8 bytes of padding for stack alignment
    subq    $8, %rsp        # alignment padding

    movq    %rdi, %rbx      # rbx = base address of array
    movq    %rsi, %r12      # r12 = length

    movq    %r12, %r13      # r13 = outer loop counter

.outer_loop:
    movq    %rbx, %r14      # r14 = pointer to start of array

.inner_loop:
    movq    %r14, %rdi      # current position pointer
    call    compare_and_swap

    incq    %r14            # ++ inner pointer

    # stop inner loop when (base + r13 - 1)
    # shrink the loop by 1 each time
    movq    %rbx, %rax      
    addq    %r13, %rax      
    decq    %rax            # rax = one before the current outer boundary
    cmpq    %rax, %r14
    jl      .inner_loop

    decq    %r13            # shrink the outer loop
    cmpq    $1, %r13        # if loop is 1: done
    jg      .outer_loop

    # restore stack and callee saved registers
    addq    $8, %rsp        # undo alignment 
    popq    %r14
    popq    %r13
    popq    %r12
    popq    %rbx

    popq    %rbp            
    ret



    .data
message:    .ascii "GONZAGABULLDOGS\n"
