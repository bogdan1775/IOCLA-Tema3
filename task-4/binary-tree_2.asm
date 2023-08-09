extern array_idx_2      ;; int array_idx_2

section .text
    global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

; HINT: folositi variabila importata array_idx_2 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test al functiei inorder_intruders.      

inorder_intruders:
	enter 0, 0
	pusha
	
	mov ebx, [ebp + 8]           ; struct node *node
	mov ecx, [ebp + 12]          ; struct node *parent
	mov edx, [ebp + 16]          ; int *array
	
	mov  ecx, [ebx + 4]
	push 0                       ; se pune 0 daca este copilul din stanga
	push edx                     ; se pune vectorul
	push ebx                     ; se pune tatal
	push ecx                     ; se pune nodul din stanga
	call parcurgere              ; se apeleaza parcurgerea
	add  esp, 16
	
	mov  ecx, [ebx + 8]
	push 1                       ; se pune 1 daca este copilul din dreapta
	push edx                     ; se pune vectorul
	push ebx                     ; se pune tatal
	push ecx                     ; se pune nodul din dreapta
	call parcurgere              ; se apeleaza parcurgerea
	add  esp, 16
	
	jmp  terminare
	
parcurgere:
	enter 0, 0
	pusha
	mov ebx, [ebp + 8]           ; nodul
	mov ecx, [ebp + 12]          ; parintele
	mov edx, [ebp + 16]          ; vectorul in care retinem
	mov esi, [ebp + 20]          ; 0 sau 1 (daca e copilul din stanga sau dreapta)
	
	cmp ebx, 0                   ; se verifica daca e NULL
	je terminare
	
	mov  eax, [ebx + 4]
	push 0                       ; pune 0 ca se apeleaza pentru copilul din stanga
	push edx                     ; pune vectorul
	push ebx                     ; se pune tatal
	push eax                     ; se pune nodul
	call parcurgere              ; se apeleaza
	add  esp, 16
	
	cmp esi, 0                   ; se verifica daca e copilul din stanga
	je  stanga
	
dreapta:
	xor edi, edi
	xor eax, eax
	
	mov eax, [ecx]               ; valoare parintelui
	mov edi, [ebx]               ; valoare copilului din dreapta
	cmp eax, edi
	jl  continuare
	
	mov edi, dword[array_idx_2]  ; retine pozitia
	xor esi, esi
	mov esi, [ebx]               ; retine valoarea nodului care nu e bun
	mov [edx + edi * 4], esi     ; o adauga in vector
	inc dword [array_idx_2]      ; creste indexul
	jmp continuare
	
	
stanga:
	xor edi, edi
	xor eax, eax
	
	mov eax, [ecx]               ; valoare parintelui
	mov edi, [ebx]               ; valoare copilui din stanga
	cmp eax, edi
	jg  continuare
	
	mov edi, dword [array_idx_2] ; retine pozitia
	xor esi, esi
	mov esi, [ebx]               ; retine valoarea nodului care nu bun
	mov [edx + edi * 4], esi     ; o adauga in vector
	inc dword [array_idx_2]      ; creste indexul
	
continuare:
	mov  eax, [ebx + 8]
	push 1                       ; se pune 1 ca se apeleaza pentru nodul din dreapta
	push edx                     ; se pune vectorul
	push ebx                     ; se pune tatal
	push eax                     ; se pune nodul
	call parcurgere              ; se apeleaza
	add  esp, 16
	
	
terminare:
	popa
	leave
	ret
