section .text
    global inorder_fixing

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

; ATENTIE: DOAR in frunze pot aparea valori gresite! 
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

inorder_fixing:
	enter 0, 0
	pusha

	mov ebx, [ebp + 8]           ; struct node *node
	mov ecx, [ebp + 12]          ; struct node *parent
	
	mov  ecx, [ebx + 4]          ; nodul din stanga
	push 0                       ; 0 reprezinta ca e copilul din stanga
	push ebx                     ; parinte
	push ecx                     ; nodul din stanga
	call parcurgere              ; apelare parcurgere
	add  esp, 12
	
	mov  ecx, [ebx + 8]          ; nodul din dreapta
	push 1                       ; 1 reprezinta ca e nodul din dreapta
	push ebx                     ; tatal
	push ecx                     ; nodul
	call parcurgere              ; apelare parcurgere
	add  esp, 12
	
	jmp terminare
	
parcurgere:
	enter 0, 0
	pusha
	mov ebx, [ebp + 8]           ; nodul
	mov ecx, [ebp + 12]          ; parintele
	mov esi, [ebp + 16]          ; 0 sau 1
	
	cmp ebx, 0                   ; verifica daca e NULL
	je  terminare
	

	mov  eax, [ebx + 4]          ; nodul din stanga
	push 0                       ; 0 ca se apeleaza pentru stanga
	push ebx                     ; parintele
	push eax                     ; nodul
	call parcurgere              ; apelare parcurgere
	add  esp, 12
	
	cmp esi, 0                   ; se verifica daca e nodul din stanga
	je  stanga
	
dreapta:
	xor edi, edi
	xor eax, eax
	
	mov eax, [ecx]               ; valoarea parintelui
	mov edi, [ebx]               ; valoarea nodului
	cmp eax, edi
	jl continuare
	
	xor eax, eax
	mov eax, [ecx]               ; se retine valoare parintelui
	inc eax                      ; o creste cu o unitate
	mov [ebx], eax               ; actualizeaza valoarea nodului
	jmp continuare
	
	
stanga:
	xor edi, edi
	xor eax, eax
	
	mov eax, [ecx]               ; valoarea parintelui
	mov edi, [ebx]               ; valoarea nodului
	cmp eax, edi
	jg  continuare
	
	xor eax, eax
	mov eax, [ecx]               ; se retine valoare parintelui
	dec eax                      ; o scade cu o unitate
	mov [ebx], eax               ; actualizeaza valoarea nodului
	
continuare:
	
	mov  eax, [ebx + 8]          ; nodul din dreapta
	push 1                       ; pune 1 ca se apeleaza pentru copilul din dreapta
	push ebx                     ; parintele
	push eax                     ; nodul
	call parcurgere              ; apelare parcurgere
	add  esp, 12
	
	
terminare:
	popa
	leave
	ret
