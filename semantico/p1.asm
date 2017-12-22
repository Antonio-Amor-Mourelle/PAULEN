segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_i resd 1
	_x resd 1
	_y resd 1
	_resultado resd 1
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
	push dword  0 
	pop dword eax
	mov [_resultado], eax
	push dword  0 
	pop dword eax
	mov [_i], eax
while_0:
	push dword  _i 
	push dword  _y 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	cmp eax, edx
	jl near menor_2
	push dword 0
	jmp near fin_menor_2
menor_2:
	push dword 1
fin_menor_2:
	pop eax
	cmp eax, 0
	je near fin_while_0
	push dword  _resultado 
	push dword  _x 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	add eax, edx
	push dword eax
	pop dword eax
	mov [_resultado], eax
	push dword  _i 
	push dword  1 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	add eax, edx
	push dword eax
	pop dword eax
	mov [_i], eax
	jmp near while_0
fin_while_0:
	push dword  _resultado 
	pop eax
	mov eax, [eax]
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
