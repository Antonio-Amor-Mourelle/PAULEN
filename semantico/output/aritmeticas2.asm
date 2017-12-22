segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
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
	push dword _x
	call scan_int
	add esp, 4
	push dword _y
	call scan_int
	add esp, 4
	push dword _z
	call scan_int
	add esp, 4
	push dword  _x 
	push dword  _y 
	push dword  _z 
	pop dword ebx
	pop dword eax
	mov eax, dword [eax]
	mov ebx, dword [ebx]
	imul ebx
	push dword eax
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	add eax, edx
	push dword eax
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  _x 
	push dword  _y 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	add eax, edx
	push dword eax
	push dword  _z 
	pop dword ebx
	pop dword eax
	mov ebx, dword [ebx]
	imul ebx
	push dword eax
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  _x 
	pop dword eax
	mov eax, [eax]
	neg eax
	push dword eax
	push dword  _y 
	pop dword ebx
	pop dword eax
	mov ebx, dword [ebx]
	imul ebx
	push dword eax
	push dword  _z 
	pop dword eax
	mov eax, [eax]
	neg eax
	push dword eax
	pop dword ebx
	pop dword eax
	imul ebx
	push dword eax
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
fin:	mov dword esp, [__esp]
	ret
gestion_error_div_cero:
	push dword msg_error_division
	call print_string
	add esp, 4
	call print_endofline
	jmp near fin
gestion_indice_fuera_rango:
	push dword msg_error_vector
	call print_string
	add esp, 4
	jmp near fin
