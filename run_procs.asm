%include "../include/io.mac"

    ;;
    ;;   TODO: Declare 'avg' struct to match its C counterpart
    ;;
struc avg
    .quo: resw 1
    .remain: resw 1
endstruc

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

section .text
    global run_procs
    extern printf

run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    mov edi, 0
;; fac aceasta operatie pentru toate procesele
outer:
    cmp edi, ebx
    jg end
    mov edx, 0
    ;; verific prioritatea procesului
    mov dl, byte [ecx + proc.prio]
    cmp dl, 1
    je add1
    cmp dl, 2
    je add2
    cmp dl, 3
    je add3
    cmp dl, 4
    je add4
    cmp dl, 5
    je add5
;; procesul de aflare a elementelor vectorilor
process:
    add edi, 1
    lea ecx, [ecx + 5]
    jmp outer

;; pentru fiecare prioritate am alt caz in care cresc numarul de
;; componente pentru respectiva prioritate in vectorul prio_result
;; si adun timpul la pozitia potrivita in vectorul time_result
;; calculez pozitia in vector adunand cate inmultind 4 cu pozitia dorita
add1:
    ;; pun vectorul prio intr un registru
    mov edx, prio_result
    ;; iau adresa de la pozitia cautata
    mov esi, [edx]
    ;; adaug 1 ptr ca am mai gasit un element cu aceasta prioritate
    add esi, 1
    ;; pun la loc valoarea
    mov [edx], esi
    ;; pun vectorul prio intr un registru
    mov edx, time_result
    ;; adun timpul la valoarea anterioara din vector
    mov esi, [edx]
    add esi, [ecx + proc.time]
    mov [edx], esi
    jmp process

;; fac acelasi lucru pentru urmatoarele cazuri, doar ca adun cate 4 ptr fiecare
add2:
    mov edx, prio_result
    mov esi, [edx + 4]
    add esi, 1
    mov [edx + 4], esi
    mov edx, time_result
    mov esi, [edx + 4]
    add esi, [ecx + proc.time]
    mov [edx + 4], esi
    jmp process
add3:
    mov edx, prio_result
    mov esi, [edx + 8]
    add esi, 1
    mov [edx + 8], esi
    mov edx, time_result
    mov esi, [edx + 8]
    add esi, [ecx + proc.time]
    mov [edx + 8], esi
    jmp process
add4:
    mov edx, prio_result
    mov esi, [edx + 12]
    add esi, 1
    mov [edx + 12], esi
    mov edx, time_result
    mov esi, [edx + 12]
    add esi, [ecx + proc.time]
    mov [edx + 12], esi
    jmp process
add5:
    mov edx, prio_result
    mov esi, [edx + 16]
    add esi, 1
    mov [edx + 16], esi
    mov edx, time_result
    mov esi, [edx + 16]
    add esi, [ecx + proc.time]
    mov [edx + 16], esi
    jmp process

;; adaug valorile finale in structura avg
;; la fel am 5 cazuri, o sa scriu doar pentru unul
end:
    push eax
    ;; pun vectorii in registrii
    mov ebx, prio_result
    mov ecx, time_result
    ;; iau valorile pentru prima prioritate
    mov bx, word [ebx]
    mov ax, word [ecx]
    mov edx, 0
    ;; daca impartitorul e 0 sar peste imparire si pun 0 direct
    cmp bx, 0
    je no1
    ;; fac impartirea
    div bx
    mov bx, ax
    jmp avg1
no1:
    mov dx, 0
avg1:
    pop eax
    ;; pun valorile gasite in structura avg
    mov [eax + avg.quo], bx
    mov [eax + avg.remain], dx
    ;; adaug 4 la adresa si trec la urmatoarea prioritate
    add eax, 4
    push eax
    mov ebx, prio_result
    mov ecx, time_result
    mov bx, word [ebx + 4]
    mov ax, word [ecx + 4]
    mov edx, 0
    cmp bx, 0
    je no2
    div bx
    mov bx, ax
    jmp avg2
no2:
    mov dx, 0
avg2:
    pop eax
    mov [eax + avg.quo], bx
    mov [eax + avg.remain], dx
    add eax, 4
    push eax
    mov ebx, prio_result
    mov ecx, time_result
    mov bx, word [ebx + 8]
    mov ax, word [ecx + 8]
    mov edx, 0
    cmp bx, 0
    je no3
    div bx
    mov bx, ax
    jmp avg3
no3:
    mov dx, 0
avg3:
    pop eax
    mov [eax + avg.quo], bx
    mov [eax + avg.remain], dx
    add eax, 4
    push eax
    mov ebx, prio_result
    mov ecx, time_result
    mov bx, word [ebx + 12]
    mov ax, word [ecx + 12]
    mov edx, 0
    cmp bx, 0
    je no4
    div bx
    mov bx, ax
    jmp avg4
no4:
    mov dx, 0
avg4:
    pop eax
    mov [eax + avg.quo], bx
    mov [eax + avg.remain], dx
    add eax, 4
    push eax
    mov ebx, prio_result
    mov ecx, time_result
    mov bx, word [ebx + 16]
    mov ax, word [ecx + 16]
    mov edx, 0
    cmp bx, 0
    je no5
    div bx
    mov bx, ax
    jmp avg5
no5:
    mov dx, 0
avg5:
    pop eax
    mov [eax + avg.quo], bx
    mov [eax + avg.remain], dx

    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY