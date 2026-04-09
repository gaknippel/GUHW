.global _start
.text
_start:

        movq $0, %r10 # initialize a counter register. starts at 0.

loop: 

        leaq message(%r10), %rsi # loads effective address. stores address of
                                # (message (0x100) + 0) into %rsi. so
                                # rsi = 0x100 rn.
        movb (%rsi), %al # move content of %rsi ('s') into %al.
        subb $32, %al # subtract 32 from 's', becoming 'S'
        movb %al, (%rsi) # replace the value of %rsi with %al ('S')

        inc %r10 # increment the index counter
        cmpq $7, %r10 # %r10 - 7.
                # say we %r10 was 2. so 2 - 7 = -5. -5 is LESS than 0, so no 0 flag.
                # and jump back to the loop.
        jl loop

                # but if %r10 was 7, we get 7 - 7 = 0. 0 is NOT less than 0.
                # this sets the 0 flag, and we exit.

exit: 
        movq    $1, %rax 
        movq    $1, %rdi
        movq    $message, %rsi
        movq    $8, %rdx
        syscall

        movq    $60, %rax
        xor     %rdi, %rdi
        syscall

.data
message: .ascii "seattle\n"
