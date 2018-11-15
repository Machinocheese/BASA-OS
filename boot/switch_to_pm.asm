[bits 16]
; Switch to protected mode
switch_to_pm:
	cli ; ignore interrupts - 16 bit interrupt handling is screwed up in 32-bit
	lgdt [gdt_descriptor] ; load GDT (defines code / data segments)
	
	mov eax, cr0
	or eax, 0x1 ; Setting first bit of CR0 switches to protected mode
	mov cr0, eax

	jmp CODE_SEG:init_pm ; Makes a far jump (far jump = to a new segment) to
			     ; 32-bit code. This flushes the pipeline of pre-fetched
                             ; and real-mode instructions. Think OpSys process handling.

[bits 32]
; initializes registers and stack once in protected mode
init_pm:
	mov ax, DATA_SEG     ; old real-mode segments are worthless in protected mode
	mov ds, ax           ; set segment registers to newly defined DATA_SEG
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000     ; updates stack
	mov esp, ebp

	call BEGIN_PM	
