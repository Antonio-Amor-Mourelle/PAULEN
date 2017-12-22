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
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jne near no_igual_1
	push dword 1
	jmp near fin_igual_1
no_igual_1:
	push dword 0
fin_igual_1:
	push dword  _y 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jne near no_igual_2
	push dword 1
	jmp near fin_igual_2
no_igual_2:
	push dword 0
fin_igual_2:
	pop ebx
	pop eax
	and eax, ebx
	push dword eax
	push dword  _z 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jne near no_igual_3
	push dword 1
	jmp near fin_igual_3
no_igual_3:
	push dword 0
fin_igual_3:
	pop ebx
	pop eax
	and eax, ebx
	push dword eax
	pop dword eax
	cmp eax, 0
	je near fin_then_3
	push dword  0 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	jmp near fin_ifelse_3
fin_then_3:
	push dword  _x 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jg near mayor_5
	push dword 0
	jmp near fin_mayor_5
mayor_5:
	push dword 1
fin_mayor_5:
	push dword  _y 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jg near mayor_6
	push dword 0
	jmp near fin_mayor_6
mayor_6:
	push dword 1
fin_mayor_6:
	pop ebx
	pop eax
	and eax, ebx
	push dword eax
	pop dword eax
	cmp eax, 0
	je near fin_then_6
	push dword  _z 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jg near mayor_8
	push dword 0
	jmp near fin_mayor_8
mayor_8:
	push dword 1
fin_mayor_8:
	pop dword eax
	cmp eax, 0
	je near fin_then_8
	push dword  1 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	jmp near fin_ifelse_8
fin_then_8:
	push dword  5 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
fin_ifelse_8:
	jmp near fin_ifelse_6
fin_then_6:
fin_ifelse_6:
	push dword  _x 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jl near menor_10
	push dword 0
	jmp near fin_menor_10
menor_10:
	push dword 1
fin_menor_10:
	push dword  _y 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jg near mayor_11
	push dword 0
	jmp near fin_mayor_11
mayor_11:
	push dword 1
fin_mayor_11:
	pop ebx
	pop eax
	and eax, ebx
	push dword eax
	pop dword eax
	cmp eax, 0
	je near fin_then_11
	push dword  _z 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jg near mayor_13
	push dword 0
	jmp near fin_mayor_13
mayor_13:
	push dword 1
fin_mayor_13:
	pop dword eax
	cmp eax, 0
	je near fin_then_13
	push dword  2 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	jmp near fin_ifelse_13
fin_then_13:
	push dword  6 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
fin_ifelse_13:
	jmp near fin_ifelse_11
fin_then_11:
fin_ifelse_11:
	push dword  _x 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jl near menor_15
	push dword 0
	jmp near fin_menor_15
menor_15:
	push dword 1
fin_menor_15:
	push dword  _y 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jl near menor_16
	push dword 0
	jmp near fin_menor_16
menor_16:
	push dword 1
fin_menor_16:
	pop ebx
	pop eax
	and eax, ebx
	push dword eax
	pop dword eax
	cmp eax, 0
	je near fin_then_16
	push dword  _z 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jg near mayor_18
	push dword 0
	jmp near fin_mayor_18
mayor_18:
	push dword 1
fin_mayor_18:
	pop dword eax
	cmp eax, 0
	je near fin_then_18
	push dword  3 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	jmp near fin_ifelse_18
fin_then_18:
	push dword  7 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
fin_ifelse_18:
	jmp near fin_ifelse_16
fin_then_16:
fin_ifelse_16:
	push dword  _x 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jg near mayor_20
	push dword 0
	jmp near fin_mayor_20
mayor_20:
	push dword 1
fin_mayor_20:
	push dword  _y 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jl near menor_21
	push dword 0
	jmp near fin_menor_21
menor_21:
	push dword 1
fin_menor_21:
	pop ebx
	pop eax
	and eax, ebx
	push dword eax
	pop dword eax
	cmp eax, 0
	je near fin_then_21
	push dword  _z 
	push dword  0 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	cmp eax, edx
	jg near mayor_23
	push dword 0
	jmp near fin_mayor_23
mayor_23:
	push dword 1
fin_mayor_23:
	pop dword eax
	cmp eax, 0
	je near fin_then_23
	push dword  4 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	jmp near fin_ifelse_23
fin_then_23:
	push dword  8 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
fin_ifelse_23:
	jmp near fin_ifelse_21
fin_then_21:
fin_ifelse_21:
fin_ifelse_3:
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
