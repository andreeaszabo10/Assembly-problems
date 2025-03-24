
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

;; fill the matrix with 0
zeros:
    cmp ebx, 64
    jge bottom_left_corner
    mov dword [ecx + ebx], 0
    add ebx, 1
    jmp zeros

;; bottom left corner case
bottom_left_corner:
    pop ebx

    cmp eax, 0
    jne top_left_corner

    cmp ebx, 0
    jne bottom_right_corner

;; find the right address, then mark it with 1 in the matrix
    add eax, 1
    add ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    jmp end

;; top left corner case
top_left_corner:
    cmp eax, 7
    jne bit_left_down

    cmp ebx, 0
    jne top_right_corner

;; find the right address, then mark it with 1 in the matrix
    sub eax, 1
    add ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    jmp end

;; bottom right corner case
bottom_right_corner:
    cmp ebx, 7
    jne bit_left_down
    
;; find the right address, then mark it with 1 in the matrix
    add eax, 1
    sub ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    jmp end

;; top right corner case
top_right_corner:
    cmp ebx, 7
    jne bit_left_down

;; find the right address, then mark it with 1 in the matrix
    sub eax, 1
    sub ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    jmp end

;; check the diagonal down-left space
bit_left_down:
;; jump over if the current position is on the first column or the bottom row
    cmp eax, 0
    je bit_right_down

    cmp ebx, 0
    je bit_right_down

    ;; subtract 1 from both coordinates to get the right position
    sub eax, 1
    sub ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    add eax, 1
    add ebx, 1

;; check the diagonal down-right space
bit_right_down:
;; jump over if the current position is on the last column or the bottom row
    cmp eax, 0
    je bit_left_up
    cmp ebx, 7
    je bit_left_up
;; subtract 1 from x and add 1 to y to get the right position
    sub eax, 1
    add ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    sub ebx, 1
    add eax, 1

;; check the diagonal up-left space
bit_left_up:
;; jump over if the current position is on the first column or the top row
    cmp eax, 7
    je bit_right_up
    cmp ebx, 0
    je bit_right_up
;; subtract 1 from y and add 1 to x to get the right position
    sub ebx, 1
    add eax, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1
    sub eax, 1
    add ebx, 1

;; check the diagonal up-right space
bit_right_up:
;; jump over if the current position is on the last column or the top row
    cmp eax, 7
    je end
    cmp ebx, 7
    je end
;; add 1 to both coordinates to get the right position
    add eax, 1
    add ebx, 1
    lea edi, [eax*8 + ebx]
    mov dword [ecx + edi], 1

end:

    popa
    leave
    ret
