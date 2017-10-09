segment .data
msg_divisionByZero db "ERROR: DIVISON BY ZERO", 0
segment .bss
	__esp resd 1
	_x resd 1
	_y resd 1
	_z resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float
	
main:
	mov dword [__esp], esp
	push dword  8 
	pop dword eax
	mov [_x], eax
	push dword _y
	call scan_int
	add esp, 4
	push dword  _y 
	push dword  _x 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	add eax, edx
	push dword eax
	pop dword eax
	mov [_z], eax
	push dword  _z 
	pop eax
	push dword [eax]
	call print_int
	add esp, 4
	mov dword esp, [__esp]
	ret
gestion_error_div_cero:
	push dword msg_error_division
	call print_string
	add esp, 4
	call print_endofline
	ret
