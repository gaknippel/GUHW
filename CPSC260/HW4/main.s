.global _start
.text
_start:
# %ecx = length
# %ebx = height
# %esi = width
# %edi = gallons

    # VOLUME STUFF
        # int legnth = 24;
        movl    $24, %ecx

        # int height = 16;

        movl    $16, %ebx

        # int width = 12;

        movl    $12, %esi

        # compute (length * width * height) / 231

        # we are loading ecx into eax to start multiplying 

        movl    %ecx, %eax      #%eax = 24

        # %eax = length * width
        mull    %esi  # %edx:%eax = 24 * 12  = 288

        # %eax = (length * width) * height
        mull    %ebx  # %edx:%eax = 288 * 16 = 4608

        # dividing part

        movl    $0, %edx

        movl    $231, %ecx # put divisor in ecx

        divl    %ecx
    # HORSEPOWER STUFF

        # int rpm = 5000;
        movl    $5000, %ecx

        movl    %ecx, %esi  # %esi = 5000

        subl    $2000, %esi # %esi = 5000 - 2000 = 3000

        # (rpm - 2000) * (rpm - 2000)

        movl    %esi, %eax # load 3000 into %eax for mull
        mull    %esi  # %edx:%eax = 3000 * 3000 = 9000000


        # divide by 150000

        movl    $0, %edx
        movl    $150000, %ecx # divisor

        divl    %ecx  # 9000000 / 150000 = 60

        # sub by 15

        subl    $15, %eax       # %eax = 60 - 15 = 45

        # int horsepower = result

        movl    %eax, %ebx  # %ebx = 45

    # MPH STUFF

        movl    $5000, %ecx # int meters = 5000

        movl    $960, %ebx  # int seconds = 960

        movl    $3600, %eax # 3600 * meters

        mull    %ecx # %eax = 3600 * 5000 = 18000000

        movl    %eax, %esi # stash in safe reg

        movl    $1609, %eax # store into eax as multiplier

        mull    %ebx # 1609 * 960 = 1544640 

        movl    %eax, %edi # stash safely

        movl    %esi, %eax # store result from earlier for dividend

        movl    $0, %edx # clear our %edx

        divl    %edi # divide %esi with %edi! (%edi / %eax = %eax)

        movl    %eax, %edx # store result 
# MOD STUFF

        movl    $17, %eax         # load 17 into %eax

        movl    $23, %ecx         # load 23 into %ecx

        mull    %ecx              # %eax = 17 * 23 = 391

        movl    $0, %edx          # clear out %edx
        
        movl    $3, %ecx          # divisor = 3

        divl    %ecx              # %eax = 391 / 3 = 130, %edx = remainder

        movl    $0, %edx          # clear out %edx again for next divl

        divl    %ecx              # %eax = 130 / 3 = 43, %edx = 130 % 3 = 1

        # int x = result
        movl    %edx, %ebx        # %ebx = 1

# closing stuff
        movq    $60, %rax
        xor     %rdi, %rdi
        syscall
        