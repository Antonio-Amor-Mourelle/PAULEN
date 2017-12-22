segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_a resd 1
	_x resd 1
	_y resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float

main:
	mov dword [__esp], esp
	push dword  13 
	pop dword eax
	mov [_x], eax
	push dword  54 
	pop dword eax
	mov [_y], eax
	push dword  _x 
	push dword  _y 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	cmp eax, edx
	jl near menor_1
	push dword 0
	jmp near fin_menor_1
menor_1:
	push dword 1
fin_menor_1:
	pop dword eax
	mov [_a], eax
	push dword  _a 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_boolean
	add esp, 4
	call print_endofline
	push dword  _x 
	push dword  _y 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	cmp eax, edx
	jle near menor_o_igual_2
	push dword 0
	jmp near fin_menor_o_igual_2
menor_o_igual_2:
	push dword 1
fin_menor_o_igual_2:
	pop dword eax
	mov [_a], eax
	push dword  _a 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_boolean
	add esp, 4
	call print_endofline
	push dword  _x 
	push dword  _y 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	cmp eax, edx
	jne near no_igual_3
	push dword 0
	jmp near fin_igual_3
no_igual_3:
	push dword 1
fin_igual_3:
	pop dword eax
	mov [_a], eax
	push dword  _a 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_boolean
	add esp, 4
	call print_endofline
	push dword  _x 
	push dword  _y 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	cmp eax, edx
	jg near mayor_4
	push dword 0
	jmp near fin_mayor_4
mayor_4:
	push dword 1
fin_mayor_4:
	pop dword eax
	mov [_a], eax
	push dword  _a 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_boolean
	add esp, 4
	call print_endofline
	push dword  _x 
	push dword  _y 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	cmp eax, edx
	jge near mayor_o_igual_5
	push dword 0
	jmp near fin_mayor_o_igual_5
mayor_o_igual_5:
	push dword 1
fin_mayor_o_igual_5:
	pop dword eax
	mov [_a], eax
	push dword  _a 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_boolean
	add esp, 4
	call print_endofline
	push dword  _x 
	push dword  _y 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	mov edx, dword [edx]
	cmp eax, edx
	jne near no_igual_6
	push dword 1
	jmp near fin_igual_6
no_igual_6:
	push dword 0
fin_igual_6:
	pop dword eax
	mov [_a], eax
	push dword  _a 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_boolean
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
