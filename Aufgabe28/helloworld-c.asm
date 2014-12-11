.section .data #Datenteil des Programms

str: 	.ascii "Hello World! \n" #Die ASCII-Datenkette "Hello World!"
	strlen = . - str #Die Laenge der Zeichenkette

num: 	.long 1337 #long Variable mit Wert 1337

.section .text  

.global _start #Label, das auch fuer den Linker sichtbar ist

.type printnumber, @function

printnumber:

loop:
	movl	$0, %edx    #bereite Division durch 10 vor
	movl 	$10, %ebx   
	divl	%ebx        #dividiere rax durch 10 --> in rax steht Ergebnis und in rdx steht jetzt Rest der Division 
	addl	$48, %edx   #addiere 48, da 48 die 0 in ASCII darstellt
	pushl	%edx        #lege die Ziffer auf den Stack
	incl	%esi        # #Schleifeniterationen 
	cmpl $0, %eax       #ist rax=0?
	jz next     
	jmp loop

next:
	cmpl $0, %esi       #wenn keine Ziffer mehr uebrig ist, breche ab
	jz exit 
	decl %esi           #dekrementiere #Schleifeniterationen
	movl $4, %eax       #bereite Ausgabe vor
	movl %esp, %ecx     #hole Ziffer vom Stack
	movl $1, %ebx       #Filedescriptor fur stdout
	movl $1, %edx       #Laenge

	int $0x80           #Syscall
	addl $4, %esp       #Addiere 4 zum Stack-Pointer um bei der naechsten Iteration auf die richtige Ziffer zuzugreifen
	jmp next           
exit:
	ret

_start: #Label fuer das Hauptprogramm
	movl	$4, %eax #Konstante 4 in Register %eax
	movl	$1, %ebx #Konstante 1 in Register %ebx
	movl	$str, %ecx #String in Register %ecx
	movl	$strlen, %edx #Laenge des Strings in Register %edx
	int $0x80 #Syscall - da %eax = 4 -> sys_write mit Parameter %ecx (Ausgabestring) und %edx (Laenge des Strings)

	movl num, %eax
	call printnumber
	
	movl	$1, %eax #Konstante 1 in Register %eax
	movl	$0, %ebx #Konstante 0 in Register %ebx
	int $0x80 #Syscall - da 1 in Register %eax -> sys_exit (Programm beenden)
