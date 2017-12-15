segment .data
msg_error_division db "ERROR: DIVISON BY ZERO", 0
segment .bss
	__esp resd 1
	_x1 resd 1
	_x2 resd 1
	_y1 resd 1
	_y2 resd 1
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
	push dword  _x1 
	push dword  _x2 
	pop dword ebx
	pop dword eax
	mov eax, [eax]
	cdq
	mov ebx, [ebx]
	cmp ebx, 0
	je gestion_error_div_cero
	idiv ebx
	push dword eax
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  _x1 
	push dword  _x2 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	cmp eax, edx
	jne near no_igual_1
	push dword 1
	jmp near fin_igual_1
no_igual_1:
	push dword 0
fin_igual_1:
	pop dword eax
	mov [_y1], eax
	push dword  _y1 
	push dword  _y1 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_boolean
	add esp, 4
	call print_endofline
	push dword  _x1 
	push dword  _x2 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	cmp eax, edx
	jg near mayor_2
	push dword 0
	jmp near fin_mayor_2
mayor_2:
	push dword 1
fin_mayor_2:
	pop dword eax
	mov [_y1], eax
	push dword  _y1 
	push dword  _y1 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_boolean
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