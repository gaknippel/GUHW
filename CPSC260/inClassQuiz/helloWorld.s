.global _start
.text
_start: 
        movq $1, %rax
        movq $1, %rdi
        movq $message, %rsi
        movq $14, %rdx
        syscall

exit:
        movq $60, %rax
        xor %rdi,%rdi
        syscall


message: ascii "hello world!\n" 