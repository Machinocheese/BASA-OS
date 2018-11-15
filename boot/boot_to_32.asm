[org 0x7c00] ; tells program to use offset 7c00 for mem. addresses

mov bp, 0x9000 ; sets up stack
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string ; calls real mode print function

call switch_to_pm ; transitions to protected mode
jmp $

[bits 32]

BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm ; calls protected mode print function
	jmp $
	

MSG_REAL_MODE: 
	db 'Started in 16-bit Real Mode', 0
MSG_PROT_MODE:
	db 'Successfully booted into 32-bit Protected Mode', 0

times 510-($-$$) db 0
dw 0xaa55

