segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_v1 resd 3
	_v2 resd 3
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float
_productoEscalar:
	push ebp
	mov ebp, esp
	sub esp, 4*1
	push dword  0 
	pop dword ebx
	lea eax, [ebp-4]
	mov [eax], ebx
while_0:
	lea eax, [ebp+8]
	push dword [eax]
	push dword  0 
	pop dword edx
	pop dword eax
	cmp eax, edx
	jge near mayor_o_igual_2
	push dword 0
	jmp near fin_mayor_o_igual_2
mayor_o_igual_2:
	push dword 1
fin_mayor_o_igual_2:
	pop eax
	cmp eax, 0
	je near fin_while_0
	lea eax, [ebp-4]
	push dword [eax]
	lea eax, [ebp+8]
	push dword [eax]
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _v1
	lea eax, [edx + eax*4]
	push dword eax
	lea eax, [ebp+8]
	push dword [eax]
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _v2
	lea eax, [edx + eax*4]
	push dword eax
	pop dword ebx
	pop dword eax
	mov eax, dword [eax]
	mov ebx, dword [ebx]
	imul ebx
	push dword eax
	pop dword edx
	pop dword eax
	add eax, edx
	push dword eax
	pop dword ebx
	lea eax, [ebp-4]
	mov [eax], ebx
	lea eax, [ebp+8]
	push dword [eax]
	push dword  1 
	pop dword edx
	pop dword eax
	sub eax, edx
	push dword eax
	pop dword ebx
	lea eax, [ebp+8]
	mov [eax], ebx
	jmp near while_0
fin_while_0:
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
	mov dword edx, _v1
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
	mov dword edx, _v1
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
	mov dword edx, _v1
	lea eax, [edx + eax*4]
	push dword eax
	push dword  2 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
	push dword  0 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _v2
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
	mov dword edx, _v2
	lea eax, [edx + eax*4]
	push dword eax
	push dword  3 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
	push dword  2 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 3
	jge near gestion_indice_fuera_rango
	mov dword edx, _v2
	lea eax, [edx + eax*4]
	push dword eax
	push dword  2 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
	push dword  2 
	call _productoEscalar
	add esp, 4*1
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
