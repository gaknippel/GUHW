.global _start

.section .data
message: .ascii "radar\n"

.section .text
_start:


        movq $0, %r10 # index loop counter (up)
        movq $4, %r11 # index loop counter (down)

loop: 
        cmpq %r11, %r10
        jge isEqual

        movb message(%r10), %al
        movb message(%r11), %bl

        cmpb %bl,%al
        jne notEqual

        inc %r10
        dec %r11

        jmp loop



notEqual:
        movq $0, %r9

isEqual:
        movq $1, %r9


exit:
        movq $60, %rax
        xor %rdi, %rdi
        syscall
