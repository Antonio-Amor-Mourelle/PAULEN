segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_x resd 1
	_resultado resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float
_fibonacci:
	push ebp
	mov ebp, esp
	sub esp, 4*2
	lea eax, [ebp+8]
	push dword [eax]
	push dword  0 
	pop dword edx
	pop dword eax
	cmp eax, edx
	jne near no_igual_1
	push dword 1
	jmp near fin_igual_1
no_igual_1:
	push dword 0
fin_igual_1:
	pop dword eax
	cmp eax, 0
	je near fin_then_1
	push dword  0 
	pop dword eax
	mov esp, ebp
	pop ebp
	ret
	jmp near fin_ifelse_1
fin_then_1:
fin_ifelse_1:
	lea eax, [ebp+8]
	push dword [eax]
	push dword  1 
	pop dword edx
	pop dword eax
	cmp eax, edx
	jne near no_igual_3
	push dword 1
	jmp near fin_igual_3
no_igual_3:
	push dword 0
fin_igual_3:
	pop dword eax
	cmp eax, 0
	je near fin_then_3
	push dword  1 
	pop dword eax
	mov esp, ebp
	pop ebp
	ret
	jmp near fin_ifelse_3
fin_then_3:
fin_ifelse_3:
	lea eax, [ebp+8]
	push dword [eax]
	push dword  1 
	pop dword edx
	pop dword eax
	sub eax, edx
	push dword eax
	call _fibonacci
	add esp, 4*1
	push dword eax
	pop dword ebx
	lea eax, [ebp-4]
	mov [eax], ebx
	lea eax, [ebp+8]
	push dword [eax]
	push dword  2 
	pop dword edx
	pop dword eax
	sub eax, edx
	push dword eax
	call _fibonacci
	add esp, 4*1
	push dword eax
	pop dword ebx
	lea eax, [ebp-8]
	mov [eax], ebx
	lea eax, [ebp-4]
	push dword [eax]
	lea eax, [ebp-8]
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
	push dword _x
	call scan_int
	add esp, 4
	push dword  [_x] 
	call _fibonacci
	add esp, 4*1
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
