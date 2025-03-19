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

;; initializez un contor
	mov ebx, 0

;; iau urmatorul caracter din sir si verific ce fac cu el 
get:
    ;; verific daca trebuie sa ies din loop
    cmp ecx, ebx
    jle end
    ;; iau urmatorul caracter si ii adun valoarea data
    mov al, [ebx + esi]
    add al, dl
;; pun in vector litera corespunzatoare
put:
    ;; verific daca in al este o litera sau nu
    mov [ebx + edi], al
    ;; daca nu e litera scad 26 si verific iar pana e ok
    cmp al, 90
    jg subtract
    ;; adaug 1 la contor si trec la urmatorul caracter
    add ebx, 1
    jmp get

;; scad 26 daca valoarea este prea mare, adica nu e litera
subtract:
    sub al, 26
    jmp put

end:

    popa
    leave
    ret
    
