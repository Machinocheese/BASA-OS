[org 0x7c00] ; tells program to use offset 7c00 for mem. addresses
KERNEL_OFFSET equ 0x1000

	mov [BOOT_DRIVE], dl
	mov bp, 0x9000
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print_string

	call load_kernel
	call switch_to_pm ; transitions to protected mode
	jmp $

%include "../boot_32_bit/load.asm"
%include "../print/print_real.asm"
%include "../print/print_pm.asm"
%include "../boot_32_bit/switch_to_pm.asm"
%include "../boot_32_bit/gdt.asm"

[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string

	mov bx, KERNEL_OFFSET
	mov dh, 2
	mov dl, [BOOT_DRIVE]
	call disk_load	

	mov bx, MSG_DISK_LOAD
	call print_string
	ret

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm ; calls protected mode print function
	call KERNEL_OFFSET
	jmp $
	
BOOT_DRIVE db 0 ; store dl in memory
MSG_REAL_MODE: 
	db 'Started in 16-bit Real Mode', 0xa, 0xd, 0
MSG_PROT_MODE:
	db 'Successfully booted into 32-bit Protected Mode', 0
MSG_LOAD_KERNEL:
	db 'Loading kernel into memory', 0xa, 0xd, 0
MSG_DISK_LOAD: db 'Disk loaded', 0xa, 0xd, 0

times 510-($-$$) db 0
dw 0xaa55

