.global _start
.text
_start:

        movq    $5, %r9

loop:

        cmpq    $0, %r9  # r9 - 0
        je      done     # if r9 - 0 is zero, jump to done
        decq    %r9      # else, decrement r9
        # printing the string
        movq    $1, %rax
        movq    $1, %rdi
        movq    $message, %rsi
        movq    $13, %rdx
        syscall
        jmp loop


done:

        movq    $60, %rax
        xor     %rdi, %rdi
        syscall


.data

message: .ascii "Hello World!\n"
