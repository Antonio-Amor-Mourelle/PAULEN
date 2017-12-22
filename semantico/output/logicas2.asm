segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_a resd 1
	_b resd 1
	_c resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float

main:
	mov dword [__esp], esp
	push dword _a
	call scan_boolean
	add esp, 4
	push dword _b
	call scan_boolean
	add esp, 4
	push dword _c
	call scan_boolean
	add esp, 4
	push dword  _a 
	push dword  _b 
	pop ebx
	pop eax
	mov eax, [eax]
	mov ebx, [ebx]
	or eax, ebx
	push dword eax
	push dword  _c 
	pop ebx
	pop eax
	mov ebx, [ebx]
	and eax, ebx
	push dword eax
	pop eax
	push dword eax
	call print_boolean
	add esp, 4
	call print_endofline
	push dword  _a 
	push dword  _b 
	pop ebx
	pop eax
	mov eax, [eax]
	mov ebx, [ebx]
	or eax, ebx
	push dword eax
	push dword  _c 
	pop ebx
	pop eax
	mov ebx, [ebx]
	and eax, ebx
	push dword eax
	pop eax
	push dword eax
	call print_boolean
	add esp, 4
	call print_endofline
	push dword  _a 
	pop eax
	 mov eax, [eax]
	cmp eax, 0
	je _uno_1
	push dword 0
	jmp _fin_negar_1
_uno_1:   push dword 1
_fin_negar_1:
	push dword  _b 
	pop ebx
	pop eax
	mov ebx, [ebx]
	and eax, ebx
	push dword eax
	push dword  _c 
	pop eax
	 mov eax, [eax]
	cmp eax, 0
	je _uno_2
	push dword 0
	jmp _fin_negar_2
_uno_2:   push dword 1
_fin_negar_2:
	pop ebx
	pop eax
	and eax, ebx
	push dword eax
	pop eax
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
