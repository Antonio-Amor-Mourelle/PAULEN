segment .data
msg_error_division db "****Error de ejecucion: Division por cero.", 0
msg_error_vector db "****Error de ejecucion: Indice fuera de rango.", 0
segment .bss
	__esp resd 1
	_a resd 1
	_b resd 1
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
	push dword  1 
	pop dword eax
	mov [_x], eax
	push dword  2 
	pop dword eax
	mov [_y], eax
	push dword  1 
	pop dword eax
	mov [_a], eax
	push dword  0 
	pop dword eax
	mov [_b], eax
while_0:
	push dword  _x 
	push dword  2 
	pop dword edx
	pop dword eax
	mov eax, dword [eax]
	add eax, edx
	push dword eax
