segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_resultado resd 1
	_vector resd 3
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float
_or:
	push ebp
	mov ebp, esp
	sub esp, 4*1
	lea eax, [ebp+16]
	push dword [eax]
	lea eax, [ebp+12]
	push dword [eax]
	pop ebx
	pop eax
	or eax, ebx
	push dword eax
	lea eax, [ebp+8]
	push dword [eax]
	pop ebx
	pop eax
	or eax, ebx
	push dword eax
	pop dword ebx
	lea eax, [ebp-4]
	mov [eax], ebx
	lea eax, [ebp-4]
	push dword [eax]
	pop dword eax
	mov esp, ebp
	pop ebp
	ret

main:
	mov dword [__esp], esp
	push dword  0 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector
	lea eax, [edx + eax*4]
	push dword eax
	push dword  0 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
	push dword  1 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector
	lea eax, [edx + eax*4]
	push dword eax
	push dword  1 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
	push dword  2 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector
	lea eax, [edx + eax*4]
	push dword eax
	push dword  0 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
	push dword  0 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector
	lea eax, [edx + eax*4]
	push dword [eax]
	push dword  1 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector
	lea eax, [edx + eax*4]
	push dword [eax]
	push dword  2 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _vector
	lea eax, [edx + eax*4]
	push dword [eax]
	call _or
	add esp, 4*3
	push dword eax
	pop dword eax
	mov [_resultado], eax
	push dword  _resultado 
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
