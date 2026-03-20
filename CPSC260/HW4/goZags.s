.global _start
.text

_start:
    # make o uppercase
    movq    $mystr, %rax      # load address of mystr

    addq    $1, %rax          # point to index 1 "o"

    movb    (%rax), %bl       # load o

    subb    $32, %bl          # o - 32 = O

    movb    %bl, (%rax)       # store back
    

    # make a uppercase
    movq    $mystr, %rax      # reload address

    addq    $4, %rax          # point to index 4 "a"

    movb    (%rax), %bl       # load a

    subb    $32, %bl          # a - 32 = A

    movb    %bl, (%rax)       # store back

    # make g uppercase
    movq    $mystr, %rax      # reload address

    addq    $5, %rax          # point to index 5 "g"

    movb    (%rax), %bl       # load g

    subb    $32, %bl          # g - 32 = G

    movb    %bl, (%rax)       # store back


    # make s uppercase
    movq    $mystr, %rax      # reload base address

    addq    $6, %rax          # point to index 6 "s"

    movb    (%rax), %bl       # load s

    subb    $32, %bl          # s - 32 = S

    movb    %bl, (%rax)       # store back


    # write
    movq    $1, %rax          # syscall 1 = write

    movq    $1, %rdi          # stdout

    movq    $mystr, %rsi      # address of string

    movq    $mylen, %rdx      # number of bytes

    syscall

    # exit
    movq    $60, %rax         # syscall 60 exit

    xorq    %rdi, %rdi
    syscall

.data
mystr:  .ascii "Go Zags\n"
        .equ mylen, (. - mystr)
