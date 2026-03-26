.global _start

.section .data
message: .ascii "radar\n"

.section .text
_start:

    movq $message, %r10   # base pointer

    movb 0(%r10), %al
    cmpb 4(%r10), %al
    jne notEqual

    movb 1(%r10), %al
    cmpb 3(%r10), %al
    jne notEqual

    movq $1, %r9
    jmp exit

notEqual:
    movq $0, %r9

exit:
    movq $60, %rax
    xor %rdi, %rdi
    syscall
