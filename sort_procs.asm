%include "../include/io.mac"

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .text
    global sort_procs
    extern printf

sort_procs:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
    mov ecx, 0 
    ;; pun lungimea in ebx ca sa pot sa o modific
    ;; fara sa pierd valoarea initiala
    mov ebx, eax
    ;; fac contorul i sa fie 0
    mov edi, 0

outer:
    ;; fac contorul j sa fie 0
    mov esi, 0
    cmp edi, eax
    je end
    push edi
    mov edi, 0
    sub ebx, 1

;; verific fiecare proces cu toate restul
inner:
        ;; verific daca trebuie sa trec la urmatorul proces
        cmp esi, ebx
        jge newout
        push ebx
        mov ebx, 0
        ;; edi creste cu 5 la fiecare iteratie ca sa pot sa verific
        ;; procesul curent cu toate celelalte fara sa pierd adresa
        add edi, 5
        mov cl, byte [edx + proc.prio]
        mov bl, byte [edx + proc.prio + edi]
        cmp cl, bl
        jl no_swap
        ;; daca prioritatile sunt egale, verific timpul, apoi pidul
        cmp cl, bl
        je time

;; interschimbarea a 2 procese
swap:
        mov cx, word [edx + proc.pid]
        mov bx, word [edx + proc.pid + edi]
        mov [edx + proc.pid + edi], word cx
        mov [edx + proc.pid], word bx
        mov cl, byte [edx + proc.prio]
        mov bl, byte [edx + proc.prio + edi]
        mov [edx + proc.prio + edi], byte cl
        mov [edx + proc.prio], byte bl
        mov cx, word [edx + proc.time]
        mov bx, word [edx + proc.time + edi]
        mov [edx + proc.time + edi], word cx
        mov [edx + proc.time], word bx

;; nu interschimbam sau deja am interschimbat
no_swap:
    ;; crestem contorul si reluam
    add esi, 1
    pop ebx
    jmp inner

newout:
    ;; trecem la urmatorul proces, crescand adresa cu 5
    lea edx, [edx + 5]
    pop edi
    ;; crestem contorul
    add edi, 1
    jmp outer

time:
    ;; daca timpul este mai mare interchimbam
    mov cx, word [edx + proc.time]
    mov bx, word [edx + proc.time + edi]
    cmp cx, bx
    jg swap
    cmp cx, bx
    jl no_swap

pid:
    ;; daca pidul este mai mare interchimbam
    mov cx, word [edx + proc.pid]
    mov bx, word [edx + proc.pid + edi]
    cmp cx, bx
    jg swap
    jmp no_swap

end:
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY