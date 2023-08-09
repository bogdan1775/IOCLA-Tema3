section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here

section .text
	global pwd
	extern strcmp
	extern strlen
	extern strcat

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
	enter 0, 0
	pusha
	
	mov ebx, [ebp + 8]           ; char **directories
	mov ecx, [ebp + 12]          ; int n
	mov edx, [ebp + 16]          ; char *output
	
	xor edi, edi                 ; contor pentru a parcurge
	
; pune slash inainte de fiecare cuvant
parcurgere:
	jmp pune_slash
	
continuare:
	cmp edi, ecx                 ; se verifica daca s-a parcurs tot
	je terminare


	; pentru ..
	push ebx                     ; se pun registrele pe stiva pentru a le pastra valoarea
	push ecx
	push edx
	push edi
	
	push back                    ; verifica daca este 2 puncte ..
	push dword [ebx + edi * 4]
	call strcmp
	add  esp, 8
	 
	pop edi                      ; se scot de pe stiva
	pop edx
	pop ecx
	pop ebx
	
	cmp eax, 0                   ; daca rezultatul comparatii este 0
	je  doua_punte


	; pentru .
	push ebx                     ; se pun registrele pe stiva pentru a le pastra valoarea
	push ecx
	push edx
	push edi
	
	push curr                    ; verifica da este un punct .
	push dword [ebx + edi * 4]
	call strcmp
	add  esp, 8
	
	pop edi                      ; se scot de pe stiva
	pop edx
	pop ecx
	pop ebx
	
	cmp eax, 0                   ; daca rezultatul comparatii este 0
	je  un_punt


	pusha
	push dword [ebx + edi * 4]   ; se pune cuvantul
	push edx                     ; se pune sirul creat puna in acest moment
	call strcat                  ; se realizeaza concatenarea
	add  esp, 8
	popa
	
	inc edi
	jmp parcurgere               ; se continua si pentru celelalte cuvinte


; adauga la sirul creat slash
pune_slash:
	pusha
	
	push slash                   ; pune / 
	push edx                     ; se pune sirul creat puna in acest moment
	call strcat                  ; se realizeaza concatenarea
	add  esp, 8
	
	popa
	jmp continuare               ; verifica in continuare
	
un_punt:
	inc edi                      ; creste contorul
	jmp continuare               ; verifica in continuare
	
doua_punte:
	push ebx                     ; se pun registrele pe stiva pentru a le pastra valoarea
	push ecx
	push edx
	push edi
	
	push edx                     ; se pune sirul pentru a-i afla dimensiunea
	call strlen
	add  esp, 4
	
	pop edi                      ; se scot de pe stiva
	pop edx
	pop ecx
	pop ebx
	
	dec eax
	dec eax
	jmp stergere_litere


continuare2:
	mov byte [edx + eax + 1], 0  ; pune pe pozitia eax sfarsitul de rand pt a sterge cuvantul
	inc edi
	jmp continuare


stergere_litere:
	cmp byte [edx + eax], '/'    ; se opreste cand da de / 
	je continuare2
	
	dec eax                      ; scadem eax
	jmp stergere_litere
	
	
terminare:
	popa
	leave
	ret
