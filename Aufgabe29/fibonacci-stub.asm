.section .data

n:	.quad	10		# define the fibonacci number that should be calculated

.section .text

.global _start

_start:
	# call Fibonacci function f(n)
	push	(n)		# parameter: fibonacci number to calculate
	call	f		# call function
	addq	$8, %rsp	# remove parameter from stack

	# print calculated Fibonacci number on stdout
	call	printnumber

	# exit process with exit code 0
	movq	$1, %rax
	movq	$0, %rbx
	int	$0x80

# f: Calculates a Fibonacci number
#   f(n) = {n, if n<=1; f(n-1)+f(n-2), else}.
#   Parameter: Integer n >= 0, passed on stack
#   Returns:   Fibonacci number f(n), returned in rax
.type f, @function
f:
	# ...
	ret
:notzero
:notone
.type printnumber, @function
printnumber:

loop:
	movl	$0, %rdx
	movl 	$10, %rbx
	divl	%ebx
	addl	$48, %rdx
	pushl	%rdx
	incl	%rsi
	cmpl $0, %rax
	jz next
	jmp loop

next:
	cmpl $0, %rsi
	jz exit
	decl %rsi
	movl $4, %rax
	movl %rsp, %rcx
	movl $1, %rbx
	movl $1, %rdx

	int $0x80
	addl $4, %rsp
	jmp next
exit:
	ret
