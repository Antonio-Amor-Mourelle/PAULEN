segment .data
msg_error_division db "ERROR: DIVISON BY ZERO", 0
segment .bss
	__esp resd 1
	_x resd 1
	_y resd 1
	_z resd 1
	_b1 resd 1
	_j resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float
	
main:
	mov dword [__esp], esp
	push dword _x
	call scan_int
	add esp, 4
	push dword _z
	call scan_int
	add esp, 4
	push dword _b1
	call scan_boolean
	add esp, 4
	push dword  _b1 
	pop eax
	 mov eax, [eax]
	cmp eax, 0
	je _uno_0
	push dword 0
	jmp _fin_negar_0
_uno_0:   push dword 1
_fin_negar_0:
	pop eax
	push dword eax
	call print_boolean
	add esp, 4
	call print_endofline
	push dword  _x 
	pop dword eax
	mov eax, [eax]
	neg eax
	pop dword eax
	mov [_j], eax
	push dword  _j 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  _x 
	push dword  _z 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	add eax, edx
	push dword eax
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  _z 
	pop eax
	mov eax, [eax]
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
	ret
