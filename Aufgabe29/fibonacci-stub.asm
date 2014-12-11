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
    movq    $10, %rax	
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
.type printnumber, @function
printnumber:
stackframe:
    enter $16000, $1
loop:
	movq	$0, %rdx    #bereite Division durch 10 vor
	movq 	$10, %rbx
	divq	%rbx        #dividiere rax durch 10 --> in rax steht Ergebnis und in rdx steht jetzt Rest der Division 
	addq	$48, %rdx   #addiere 48, da 48 die 0 in ASCII darstellt
	pushq	%rdx        #(lege die Zahl auf den Stack)
    incq	%rsi        # #Schleifeniterationen
	cmpq $0, %rax       #ist rax=0?
	jz next
	jmp loop

next:
	cmpq $0, %rsi       #wenn keine Ziffer mehr uebrig ist, breche ab
	jz exit
	decq %rsi           #dekrementiere #Schleifeniterationen
	movq $4, %rax       #bereite Ausgabe vor
	movq %rsp, %rcx     #hole Ziffer vom Stack
	movq $1, %rbx       #Filedescriptor fuer stdout
	movq $1, %rdx       #Laenge

	int $0x80           #Syscall
	addq $8, %rsp       #Addiere 8(64bit) zum Stack-Pointer um bei der naechsten Iteration auf die richtige Ziffer zuzugreifen
	jmp next            
exit:
    leave
	ret
