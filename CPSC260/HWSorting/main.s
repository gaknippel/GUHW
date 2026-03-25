	.global _start
	.text
_start:

# i decided to use bubble sort here, with an inner and outer loop.

	# print the message string before sorting
	mov	$1, %rax
	mov	$1, %rdi
	mov	$message, %rsi
	mov	$16, %rdx
	syscall


	movq $15, %rcx # 15 is the size of the message string.
outer_loop: 
# our outer loop of the sorting function. 
	movq $message, %rsi

inner_loop: 
	movq	%rsi, %rdi
	inc		%rdi  # increment index of sort

	movb (%rsi), %al # al and dl are temp registers, for holding char values for swapping
	movb (%rdi), %dl

	# compare
	cmpb %dl, %al # compare if the char is less than or equal to the other char
	jle	no_swap

	# swap

	movb %dl, (%rsi)  # swap!
	movb %al, (%rdi)

no_swap: 
# move to next pos
	inc %rsi # increment our index

# this is a stop condition for preventing seg faults.
	movq $message, %rax
	addq $14, %rax
	cmpq %rax, %rsi
	jl inner_loop

	loop outer_loop

	# print the message string after sorting
	mov	$1, %rax
	mov	$1, %rdi
	mov	$message, %rsi
	mov	$16, %rdx
	syscall

	# exit the program
	movq	$60, %rax
	xor	%rdi, %rdi
	syscall

	.data
message:	.ascii "GONZAGABULLDOGS\n"
