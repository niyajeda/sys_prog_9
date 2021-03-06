.section .data #Datenteil des Programms

str: 	.ascii "Hello World! \n" #Die ASCII-Datenkette "Hello World!"
	strlen = . - str #Die Laenge der Zeichenkette

num: 	.long 1337 #long Variable mit Wert 1337

.section .text  

.global _start #Label, das auch fuer den Linker sichtbar ist

_start: #Label fuer das Hauptprogramm
	movl	$4, %eax #Konstante 4 in Register %eax
	movl	$1, %ebx #Konstante 1 in Register %ebx
	movl	$str, %ecx #String in Register %ecx
	movl	$strlen, %edx #Laenge des Strings in Register %edx
	int $0x80 #Syscall - da %eax = 4 -> sys_write mit Parameter %ecx (Ausgabestring) und %edx (Laenge des Strings)

	movl num, %eax

loop:
	movl	$0, %edx
	movl 	$10, %ebx
	divl	%ebx
	addl	$48, %edx
	pushl	%edx
	incl	%esi
	cmpl $0, %eax
	jz next
	jmp loop

next:
	cmpl $0, %esi
	jz exit
	decl %esi
	movl $4, %eax
	movl %esp, %ecx
	movl $1, %ebx
	movl $1, %edx

	int $0x80
	addl $4, %esp
	jmp next

exit:
	movl	$1, %eax #Konstante 1 in Register %eax
	movl	$0, %ebx #Konstante 0 in Register %ebx
	int $0x80 #Syscall - da 1 in Register %eax -> sys_exit (Programm beenden)
