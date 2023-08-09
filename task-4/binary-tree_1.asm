extern array_idx_1      ;; int array_idx_1

section .text
    global inorder_parc

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

;;  inorder_parc(struct node *node, int *array);
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor in vectorul array.
;    @params:
;        node  -> nodul actual din arborele de cautare;
;        array -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!
; HINT: folositi variabila importata array_idx_1 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test.

inorder_parc:
	enter 0, 0
	pusha
	
	mov ebx, [ebp + 8]           ; struct node *node
	mov edx, [ebp + 12]          ; int *array
	
	cmp ebx, 0                   ; daca nodul este NULL
	je  terminare
	
	
	mov  eax, [ebx + 4]          ; nodul din stanga
	push edx                     ; se pune vectorul
	push eax                     ; se pune nodul
	call inorder_parc            ; se apeleaza parcurgerea in inordine
	add esp, 8
	
	
	mov edi, dword [array_idx_1] ; pozitia care trebuie
	mov esi, [ebx]               ; valoarea nodului
	mov [edx + edi * 4], esi     ; se adauga in vector valoarea nodului
	inc dword [array_idx_1]      ; creste pozitia
	
	
	
	mov  eax, [ebx + 8]          ; nodul din dreapta
	push edx                     ; se pune vectorul
	push eax                     ; se pune nodul
	call inorder_parc            ; se apeleaza parcurgerea in inordine
	add  esp, 8
	
	
	
terminare:
	popa
	leave
	ret
