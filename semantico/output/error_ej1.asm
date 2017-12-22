segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_a resd 1
	_b resd 1
	_v resd 10
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
	push dword  12 
	pop dword eax
	cmp eax, 0
	jl near gestion_indice_fuera_rango
	cmp eax, 10
	jge near gestion_indice_fuera_rango
	mov dword edx, _v
	lea eax, [edx + eax*4]
	push dword eax
	push dword  3 
	pop dword eax
	pop dword edx
	mov dword [edx] , eax
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
