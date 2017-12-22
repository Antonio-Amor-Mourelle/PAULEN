segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_a resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float

main:
	mov dword [__esp], esp
	push dword  1 
	pop dword eax
	mov [_a], eax
	push dword  _a 
	pop dword eax
	mov eax, dword [eax]
	cmp eax, 0
	je near fin_then_0
	push dword  1 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	jmp near fin_ifelse_0
fin_then_0:
fin_ifelse_0:
	push dword  _a 
	pop dword eax
	mov eax, dword [eax]
	cmp eax, 0
	je near fin_then_1
	push dword  1 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	jmp near fin_ifelse_1
fin_then_1:
fin_ifelse_1:
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
