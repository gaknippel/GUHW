# %ecx = length
# %ebx = height
# %esi = width
# %edi = gallons

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