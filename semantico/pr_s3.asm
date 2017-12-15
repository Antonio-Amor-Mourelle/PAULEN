segment .data
msg_error_division db "ERROR: DIVISON BY ZERO", 0
segment .bss
	__esp resd 1
	_x resd 1
segment .text
	global main
	extern scan_int, print_int, scan_float, print_float
	extern scan_boolean, print_boolean
	extern print_endofline, print_blank, print_string
	extern alfa_malloc, alfa_free, ld_float
_hola:
	push ebp
	mov ebp, esp
	mov esp, 4*0
	push dword  [n] 
	pop dword eax
	mov eax , [eax]
	mov esp, ebp
	pop ebp
	ret

main:
	mov dword [__esp], esp
	push dword  1 
	pop eax
	push dword eax
	call print_int
	add esp, 4
	call print_endofline
	mov dword esp, [__esp]
	ret
gestion_error_div_cero:
	push dword msg_error_division
	call print_string
	add esp, 4
	call print_endofline
	mov dword esp, [__esp]
	ret