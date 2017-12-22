segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_b resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float
_imprimir:
	push ebp
	mov ebp, esp
	sub esp, 4*0
	push dword  1000 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  1 
	pop dword eax
	mov esp, ebp
	pop ebp
	ret

main:
	mov dword [__esp], esp
	call _imprimir
	add esp, 4*0
	push dword eax
	pop dword eax
	mov [_b], eax
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
