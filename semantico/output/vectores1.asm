segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_vector1 resd 3
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float

main:
	mov dword [__esp], esp
	push dword  0 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector1
	lea eax, [edx + eax*4]
	push dword eax
	push dword  10 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
	push dword  1 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector1
	lea eax, [edx + eax*4]
	push dword eax
	push dword  20 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
	push dword  2 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector1
	lea eax, [edx + eax*4]
	push dword eax
	push dword  30 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
	push dword  0 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector1
	lea eax, [edx + eax*4]
	push dword eax
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  1 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector1
	lea eax, [edx + eax*4]
	push dword eax
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  2 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector1
	lea eax, [edx + eax*4]
	push dword eax
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
