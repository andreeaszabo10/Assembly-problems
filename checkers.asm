
section .data

section .text
	global checkers

checkers:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table


    push ebx
    mov ebx, 0

;; umplu matricea cu 0
zeros:
    cmp ebx, 64
    jge bottom_left_corner
    mov dword [ecx + ebx], 0
    add ebx, 1
    jmp zeros

;; cazul pentru coltul din stanga jos
bottom_left_corner:
    pop ebx
    cmp eax, 0
    jne top_left_corner
    cmp ebx, 0
    jne bottom_right_corner
    ;; gasesc adresa potrivita si pun 1 in matrice
    add eax, 1
    add ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    jmp end

;; cazul pentru coltul din stanga sus
top_left_corner:
    cmp eax, 7
    jne bit_left_down
    cmp ebx, 0
    jne top_right_corner
    ;; gasesc adresa potrivita si pun 1 in matrice
    sub eax, 1
    add ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    jmp end

;; cazul pentru coltul din dreapta jos
bottom_right_corner:
    cmp ebx, 7
    jne bit_left_down
    ;; gasesc adresa potrivita si pun 1 in matrice
    add eax, 1
    sub ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    jmp end

;; cazul pentru coltul din dreapta sus
top_right_corner:
    cmp ebx, 7
    jne bit_left_down
    ;; gasesc adresa potrivita si pun 1 in matrice
    sub eax, 1
    sub ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    jmp end

;; pun bitul din stanga jos daca trebuie
bit_left_down:

    ;; daca se afla pe linia de jos sau prima coloana, sare peste
    cmp eax, 0
    je bit_right_down
    cmp ebx, 0
    je bit_right_down
    ;; pun bitul la pozitia buna, scad ca sa gasesc linia si coloana
    sub eax, 1
    sub ebx, 1
    ;; instructiune pentru ca nu pot sa pun 3 registri la adresa
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    add eax, 1
    add ebx, 1

;; pun bitul din dreapta jos daca trebuie
bit_right_down:
    ;; daca e pe linia de jos sau ultima coloana sar
    cmp eax, 0
    je bit_left_up
    cmp ebx, 7
    je bit_left_up
;; pun 1 la pozitia calculata scazand 1 din linie si adunand 1 la coloana
    sub eax, 1
    add ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    sub ebx, 1
    add eax, 1

;; pun bitul din stanga sus daca trebuie
bit_left_up:
    ;; daca e pe linia de sus sau prima coloana sar
    cmp eax, 7
    je bit_right_up
    cmp ebx, 0
    je bit_right_up
;; pun 1 la pozitia calculata adunand 1 la linie si scazand 1 din coloana
    sub ebx, 1
    add eax, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    sub eax, 1
    add ebx, 1

;; pun bitul din dreapta sus daca trebuie
bit_right_up:
    ;; daca se afla pe linia de sus sau ultima coloana sar
    cmp eax, 7
    je end
    cmp ebx, 7
    je end
;; pun 1 la pozitia calculata adunand 1 la linie si adunand 1 la coloana
    add eax, 1
    add ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1

end:

    popa
    leave
    ret