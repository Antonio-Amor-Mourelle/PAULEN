segment .data
msg_error_division db "ERROR: DIVISON BY ZERO", 0
segment .bss
	__esp resd 1
	_x1 resd 1
	_x2 resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float
	
main:
	mov dword [__esp], esp
	push dword _x1
	call scan_int
	add esp, 4
	push dword _x2
	call scan_int
	add esp, 4
	push dword  3 
	push dword  _x1 
	pop dword edx
	pop dword eax
	mov edx, dword [edx]
	add eax, edx
	push dword eax
	push dword  _x2 
	pop dword edx
	pop dword eax
	mov edx, dword [edx]
	add eax, edx
	push dword eax
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	mov dword esp, [__esp]
	ret
gestion_error_div_cero:
	push dword msg_error_division
	call print_string
	add esp, 4
	call print_endofline
	mov dword esp, [__esp]
	ret