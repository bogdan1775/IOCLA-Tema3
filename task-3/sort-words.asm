global get_words
global compare_func
global sort
section .data
    delimitator db " ,.", 0

section .text
    extern strtok
    extern strlen
    extern strcmp
    extern qsort
;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
	enter 0, 0
	pusha
	
	mov ebx, [ebp + 8]           ; char **words
	mov edi, [ebp + 12]          ; int number_of_words
	mov ecx, [ebp + 16]          ; int size
	
	pusha
	
	push comparare               ; se pune functia de comparare
	push ecx                     ; se pune size-ul
	push edi                     ; se pune numarul de cuvinte
	push ebx                     ; se pune matricea de cuvinte **words
	call qsort                   ; se apeleaza qsort
	add  esp, 16
	
	popa
	
	jmp terminare_sort
	
comparare:
	enter 0, 0
	
	push ebx                     ; se pun registrele pe stiva 
	push ecx
	push edx
	push edi
	push esi
	
	xor eax, eax
	mov eax, [ebp + 8]           ; se retine primul cuvant
	mov eax, dword [eax]
	
	push eax
	call strlen                  ; se ala dimensiunea acestuia
	add  esp, 4
	
	push eax                     ; se pune dimensiunea primului cuvant pe stiva
	
	xor eax, eax
	mov eax, [ebp + 12]          ; se retine al doilea cuvant
	mov eax, dword [eax]
	
	push eax
	call strlen                  ; se afla dimensiunea celui de-al doilea cuvant
	add  esp, 4
	
	pop esi                      ; se extrage dimensiunea primului cuvant
	
	cmp esi, eax                 ; se compara dimensiunile celor 2 cuvinte
	jg  mare_nr_lit
	je  egal
	
	xor eax, eax
	mov eax, - 1                 ; pune in eax -1 daca dimensiunea primului e mai mica
	jmp continuare
	
mare_nr_lit:
	xor eax, eax
	mov eax, 1                   ; pune in eax 1 daca dimensiunea primului e mai mare
	jmp continuare
	
egal:
	push ebx                     ; se pun registrele pe stiva
	push ecx
	push edx
	push esi
	push edi
	
	xor eax, eax
	xor edx, edx
	mov eax, [ebp + 8]           ; primul cuvant
	mov edx, [ebp + 12]          ; al doilea cuvant
	mov eax, dword [eax]
	mov edx, dword [edx]
	
	push edx                     ; pune al doilea cuvant
	push eax                     ; pune primul cuvant
	call strcmp                  ; le compara lexico-grafic
	add  esp, 8
	
	pop edi                      ; scoate registrele de pe stiva
	pop esi
	pop edx
	pop ecx
	pop ebx
	
	
	cmp eax, 0                   ; compara eax cu 0
	jg mare_lexico               ; daca e mai mare sare
	xor eax, eax
	jmp continuare
	
mare_lexico:
	xor eax, eax
	mov eax, 1                   ; 1 deoarece primul cuvant e mai mare lexico-grafic
	jmp continuare
	
	
continuare:
	pop esi                      ; scot registrele de pe stiva
	pop edi
	pop edx
	pop ecx
	pop ebx
	
terminare_comparare:
	leave
	ret
	
terminare_sort:
	popa
	leave
	ret
	
;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
	enter 0, 0
	pusha
	mov ebx, [ebp + 8]           ; char *s
	mov edx, [ebp + 12]          ; char **words
	mov ecx, [ebp + 16]          ; int number_of_words
	
	
	push ebx                     ; se pun registrele pe stiva
	push ecx
	push edx
	push esi
	push edi
	
	push delimitator             ; pune delimitatorul
	push ebx                     ; pune sirul s
	call strtok                  ; extrage primul cuvant
	add  esp, 8
	
	pop edi                      ; scot registrele de pe stiva
	pop esi
	pop edx
	pop ecx
	pop ebx
	
	mov [edx], eax               ; pune din **words primul cuvant
	xor esi, esi                 ; esi este contor
	inc esi
	
parcurgere:
	cmp esi, ecx                 ; compara sa vada daca a trecut prin toate cuvintele
	je  terminare
	
	push ebx                     ; se pun registrele pe stiva
	push ecx
	push edx
	push esi
	push edi
	
	push delimitator             ; pune delimitatorul
	push 0                       ; pune NULL
	call strtok                  ; se scoate urmatorul cuvant din sirul s
	add  esp, 8
	
	pop edi                      ; scot registrele de pe stiva
	pop esi
	pop edx
	pop ecx
	pop ebx
	
	mov [edx + esi * 4], eax     ; pune din **words cuvantul
	inc esi                      ; creste contorul
	jmp parcurgere
	
terminare:
	popa
	leave
	ret
