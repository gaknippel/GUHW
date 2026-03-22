
	.global _start
	.text
_start:

	# print the message string before sorting
	mov	$1, %rax
	mov	$1, %rdi
	mov	$message, %rsi
	mov	$16, %rdx
	syscall


	movq $15, %rcx
outer_loop:
	movq $message, %rsi

inner_loop: 
	movq	%rsi, %rdi
	inc		%rdi

	movb (%rsi), %al
	movb (%rdi), %dl

	# compare
	cmpb %dl, %al
	jle	no_swap

	# swap

	movb %dl, (%rsi)
	movb %al, (%rdi)

no_swap: 
# move to next pos
	inc %rsi


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
