segment .data
msg_error_division db "ERROR: DIVISON BY ZERO", 0
segment .bss
	__esp resd 1
	_x resd 1
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
	push dword  _x 
	push dword  _x 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  8 
	push dword  3 
	pop dword edx
	pop dword eax
	add eax, edx
	push dword eax
	pop dword eax
	mov [_x], eax
	push dword  _x 
	push dword  _x 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  3 
	pop dword eax
	neg eax
	push dword eax
	pop dword eax
	mov [_x], eax
	push dword  _x 
	push dword  _x 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  4 
	push dword  2 
	pop dword ebx
	pop dword eax
	cdq
	cmp ebx, 0
	je msg_error_division
	idiv ebx
	push dword eax
	pop dword eax
	mov [_x], eax
	push dword  _x 
	push dword  _x 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  10 
	push dword  3 
	pop dword ebx
	pop dword eax
	imul ebx
	push dword eax
	pop dword eax
	mov [_x], eax
	push dword  _x 
	push dword  _x 
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
	mov dword esp, [__esp]
	ret