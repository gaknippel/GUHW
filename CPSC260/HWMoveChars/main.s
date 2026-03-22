.global _start
.text

_start:
        movq    $6, %r12        

loop:
        dec     %r12  # r12 - 1

        leaq    message(%r12), %rsi   # pointer to the char the left of B
        movb    (%rsi), %al    # load left char
        movb    1(%rsi), %bl  # load right char (b)
        movb    %bl, (%rsi) # put b on the left
        movb    %al, 1(%rsi)  # put left char on the right
# printing stuff
        movq    $1, %rax
        movq    $1, %rdi
        movq    $message, %rsi
        movq    $8, %rdx
        syscall
# compare if r12 is not equal to 1 
        cmpq    $1, %r12
        jne     loop

done:
        movq    $60, %rax
        xorq    %rdi, %rdi
        syscall

.data
message: .ascii "ACDEFGB\n"
