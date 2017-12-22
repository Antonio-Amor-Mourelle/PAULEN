segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_x resd 1
	_y resd 1
	_resultado resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float
_suma:
	push ebp
	mov ebp, esp
	sub esp, 4*0
	lea eax, [ebp+12]
	push dword [eax]
	lea eax, [ebp+8]
	push dword [eax]
	pop dword edx
	pop dword eax
	add eax, edx
	push dword eax
	pop dword eax
	mov esp, ebp
	pop ebp
	ret

main:
	mov dword [__esp], esp
	push dword  1 
	pop dword eax
	mov [_x], eax
	push dword  3 
	pop dword eax
	mov [_y], eax
	push dword  [_x] 
	push dword  [_y] 
	call _suma
	add esp, 4*2
	push dword eax
	pop dword eax
	mov [_resultado], eax
	push dword  _resultado 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  [_x] 
	push dword  1 
	call _suma
	add esp, 4*2
	push dword eax
	pop dword eax
	mov [_resultado], eax
	push dword  _resultado 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  10 
	push dword  [_y] 
	call _suma
	add esp, 4*2
	push dword eax
	pop dword eax
	mov [_resultado], eax
	push dword  _resultado 
	pop eax
	mov eax, [eax]
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	push dword  3 
	push dword  5 
	call _suma
	add esp, 4*2
	push dword eax
	pop dword eax
	mov [_resultado], eax
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
