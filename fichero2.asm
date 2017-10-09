segment .data
msg_divisionByZero db "ERROR: DIVISON BY ZERO", 0
segment .bss
	__esp resd 1
	_b1 resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float,
scan_boolean, print_boolean
extern print_endofline, print_blank, print_string
extern alfa_malloc, alfa_free, ld_float
	
main:
	mov dword [__esp], esp
	push dword _b1
	call scan_boolean
	add esp, 4
	push dword  _b1 
	pop eax
	 mov eax, [eax]
	cmp eax, 0
	je _uno_0
	push dword 0
	jmp _fin_negar_0
_uno_0:   push dword 1
_fin_negar_0:
	call print_boolean
	push dword  _b1 
	pop eax
	 mov eax, [eax]
	cmp eax, 0
	je _uno_1
	push dword 0
	jmp _fin_negar_1
_uno_1:   push dword 1
_fin_negar_1:
	pop eax
	cmp eax, 0
	je _uno_2
	push dword 0
	jmp _fin_negar_2
_uno_2:   push dword 1
_fin_negar_2:
	call print_boolean
	mov dword esp, [__esp]
	ret
gestion_error_div_cero:
	push dw msg_error_division
	call print_string
	add esp, 4
	call print_endofline
	ret
