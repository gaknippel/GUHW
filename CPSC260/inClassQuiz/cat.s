.global _start
.text
_start:

        movq $0, %r10

loop:
        leaq message(%r10), %r11

        movb (%r11), %al # asci value 'c' currently in %al
        subb $32, %al
        movb %al, (%r11)

        inc %r10
        cmpq $3, %r10
        jl loop 

exit: 
        movq    $1, %rax
        movq    $1, %rdi
        movq    $message, %rsi
        movq    $4, %rdx
        syscall

        movq    $60, %rax
        xor     %rdi, %rdi
        syscall

.data
message: .ascii "cat\n"
