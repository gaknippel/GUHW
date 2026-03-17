.global _start
.text

_start:
    # make h lowercase
    movb    mystr, %al        # load first char h into %al

    addb    $32, %al          # h + 32 = h (ascii table)

    movb    %al, mystr        # store back

    # make e uppercas
    movq    $mystr, %rax      # load address of mystr into %rax

    addq    $1, %rax          # move address forward 1 byte to point at 'e'

    movb    (%rax), %bl       # follow the pointer and load e into %bl

    subb    $32, %bl          # e - 32 = E

    movb    %bl, (%rax)       # store back with pointer dereference


    # write
    movq    $1, %rax          # syscall 1 = write

    movq    $1, %rdi          # file handle 1 = stdout

    movq    $mystr, %rsi      # address of string
    
    movq    $mylen, %rdx      # number of bytes
    syscall

    # closing stuff
    movq    $60, %rax         # smooth exit

    xorq    %rdi, %rdi      

    syscall

.data
mystr:  .ascii "Hello, World!\n"
        .equ mylen, (. - mystr)
