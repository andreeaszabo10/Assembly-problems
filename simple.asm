%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:

    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

;; counter
    mov ebx, 0

;; get and check the first character
get:
;; exit loop
    cmp ecx, ebx
    jle end

;; take the next character and add it's value
    mov al, [ebx + esi]
    add al, dl

;; put the corresponding letter in the array
put:
;; check if it's a letter
    mov [ebx + edi], al
;; if it is not, subtract 26 until the value corresponds to a letter
    cmp al, 90
    jg subtract

;; increment the counter and check the next character
    add ebx, 1
    jmp get

;; subtract 26 if it is not a letter
subtract:
    sub al, 26
    jmp put

end:

    popa
    leave
    ret
    
