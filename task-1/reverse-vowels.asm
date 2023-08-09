section .data
	; declare global vars here

section .text
	global reverse_vowels

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	push ebp
	xor  ebp, ebp
	or   ebp, esp
	
	xor ecx, ecx
	or  ecx, [ebp + 8]           ; char * string
	
	xor edi, edi                 ; contor pentru a parcurge literele
	
parcurgere1:
	
	cmp byte [ecx + edi], 0      ; verifica daca e sfarsit de rand
	je  schimbare
	
	cmp byte [ecx + edi], 'a'    ; verifica daca e a
	je  pune_vocale_stiva
	
	cmp byte [ecx + edi], 'e'    ; verifica daca e e
	je  pune_vocale_stiva
	
	cmp byte [ecx + edi], 'i'    ; verifica daca e i
	je  pune_vocale_stiva
	
	cmp byte [ecx + edi], 'o'    ; verifica daca e o
	je  pune_vocale_stiva
	
	cmp byte [ecx + edi], 'u'    ; verifica daca e u
	je  pune_vocale_stiva
	
	
	inc edi                      ; creste contorul
	jmp parcurgere1
	

pune_vocale_stiva:
	push dword [ecx + edi]
	inc  edi					 ; creste contorul
	jmp  parcurgere1             ; se duce la urmatoarea litera


; se pregateste contorul pentru a parcurge a doua oara
schimbare:
	xor edi, edi                 ; contor pentru a parcurge


; parcurge din nou stringul, sa gaseasca pozitia vocalelor
parcurgere2:
	cmp byte [ecx + edi], 0      ; verifica daca e sfarsit de rand
	je  terminare
	
	cmp byte [ecx + edi], 'a'    ; verifica daca e a
	je  schimbare_vocale
	
	cmp byte [ecx + edi], 'e'    ; verifica daca e e
	je  schimbare_vocale
	
	cmp byte [ecx + edi], 'i'    ; verifica daca e i
	je  schimbare_vocale
	
	cmp byte [ecx + edi], 'o'    ; verifica daca e o
	je  schimbare_vocale
	
	cmp byte [ecx + edi], 'u'    ; verifica daca e u
	je  schimbare_vocale
	
	
	inc edi
	jmp parcurgere2


schimbare_vocale:
	pop edx                      ; se extrage vocala
	xor dh, dh                   ; se face xor la jumatate
	
	sub dl, byte [ecx + edi]     ; se afla diferenta intre codul ascii al vocalelor
	add byte [ecx + edi], dl     ; se adauga la codul ascii al vocalei curente
	inc edi
	jmp parcurgere2              ; se continua parcurgerea
	
terminare:
	xor esp, esp
	or  esp, ebp
	pop ebp
	
	ret
