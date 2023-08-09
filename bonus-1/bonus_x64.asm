section .text
	global intertwine
	extern printf

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	push	rbp
	mov 	rbp, rsp
	
	xor  rax, rax                ; contor pentru a pune valorile in v
	push rsi                     ; pune pe stiva n1
	push rcx                     ; pune pe stiva n2

	cmp rsi, rcx
	jl  incepere
	mov rsi, rcx                 ; rsi retine numarul minim dintre n1 si n2
	
incepere:
	xor rcx, rcx                 ; contor pentru a extrage valori din v1 si v2
parcurgere:
	cmp rcx, rsi                 ; daca s-a ajuns la numarul minim
	je  verificare
	
	push rbx
	
	mov rbx, [rdi + rcx * 4]     ; retine elementul din v1
	mov [r8 + rax * 4], rbx      ; il adauga in v
	inc rax                      ; creste contorul pentru v
	
	mov rbx, [rdx + rcx * 4]     ; retine elemetul din v2
	mov [r8 + rax * 4], ebx      ; il adauga in v
	
	inc rax                      ; creste contorul pentru v
	inc rcx                      ; creste contorul pentru v1 si v2
	
	pop rbx
	jmp parcurgere
	
verificare:
	mov rbx, rcx                 ; se retine contorul pana la care s-a ajuns
	
	pop rcx                      ; reprezinta n2
	pop rsi                      ; reprezinta n1
	cmp rsi, rcx                 ; se determina care e mai v1_mai_mare
	jg  v1_mai_mare
	jl  v2_mai_mare
	
v1_mai_mare:
	cmp  rbx, rsi                ; daca s-au adugat toate elementele
	je   terminare
	push rcx
	
	mov rcx, [rdi + rbx * 4]     ; retine elementul din v1
	mov [r8 + rax * 4], rcx      ; adauga elementul in v
	inc rax                      ; creste contorul pentru v
	inc rbx                      ; creste contorul pentru v1
	
	pop rcx
	jmp v1_mai_mare
	
v2_mai_mare:
	cmp  rbx, rcx                ; daca s-au adugat toate elementele
	je   terminare
	push rcx
	
	mov rcx, [rdx + rbx * 4]     ; retine elementul din v2
	mov [r8 + rax * 4], rcx      ; adauga elementul in v
	inc rax                      ; creste contorul pentru v
	inc rbx                      ; creste contorul pentru v2
	
	pop rcx
	jmp v2_mai_mare
	
terminare:
	leave
	ret
