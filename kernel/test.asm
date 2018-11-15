disk_load:
	mov bx, SECTORS_ERROR
	call print_string
	ret

SECTORS_ERROR: db "Incorect number of sectors lol", 0
