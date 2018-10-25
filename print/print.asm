[org 0x7c00] ; boot sector initializes at 0x7c00 by default

;mov bx, the_secret ; parameter passing
;call print_string

mov bx, hexstring
mov cx, 0x3
call print_hex
ret

print_hex:
	push bx
	push bx
	mov bl, [bx] ; moves hex bytes into register
	and bl, 0xf0 ; chops off second digit
	shr bl, 0x4  ; shift to eliminate new 0 on right
	xor bh, bh   ; sets top half of register to 0
	
	mov ah, 0x0e ; sets INT 0x10/0xee = TTY
	mov al, [alphabet+bx] ; queries alphabet for num to print
	int 0x10     ; interrupt print

	pop bx       ; reset bx register
	mov bl, [bx] 
	and bl, 0x0f ; chop off first digit
	xor bh, bh

	mov al, [alphabet+bx]
	int 0x10

	dec cx       ; decrement size counter
	pop bx
	inc bx       ; move to new hex byte
	cmp cx, 0
	jne print_hex
	ret

	
print_string:
	mov ah, 0x0e
	mov al, [bx]
	cmp al, 0x0
	je end
	int 0x10
	dec bx
	jmp print_string

end:
	ret
	
the_secret:
    db 'ASDF', 0x41, 0xA, 0xD, 0;

hexstring:
    db 0x41, 0x42, 0x43, 0;

alphabet:
    db '0123456789abcdef', 0;

; zero padding and magic bios number
times 510-($-$$) db 0
dw 0xaa55
