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
    enter 0,0
    pusha

    mov edx, [ebp + 8]      ; processes
    mov eax, [ebp + 12]     ; length

    mov ecx, 0 
    ;; store the length in ebx so I can modify it
    ;; without losing the initial value
    mov ebx, eax
    ;; set counter i to 0
    mov edi, 0

outer:
    ;; set counter j to 0
    mov esi, 0
    cmp edi, eax
    je end
    push edi
    mov edi, 0
    sub ebx, 1

;; check each process with all the others
inner:
        ;; check if I should move to the next process
        cmp esi, ebx
        jge newout
        push ebx
        mov ebx, 0
        ;; edi increments by 5 each iteration so I can check
        ;; the current process with all the others without losing the address
        add edi, 5
        mov cl, byte [edx + proc.prio]
        mov bl, byte [edx + proc.prio + edi]
        cmp cl, bl
        jl no_swap
        ;; if priorities are equal, check time, then pid
        cmp cl, bl
        je time

;; swapping two processes
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

;; don't swap or already swapped
no_swap:
    ;; increment the counter and continue
    add esi, 1
    pop ebx
    jmp inner

newout:
    ;; move to the next process by increasing the address by 5
    lea edx, [edx + 5]
    pop edi
    ;; increment the counter
    add edi, 1
    jmp outer

time:
    ;; if the time is greater, swap
    mov cx, word [edx + proc.time]
    mov bx, word [edx + proc.time + edi]
    cmp cx, bx
    jg swap
    cmp cx, bx
    jl no_swap

pid:
    ;; if the pid is greater, swap
    mov cx, word [edx + proc.pid]
    mov bx, word [edx + proc.pid + edi]
    cmp cx, bx
    jg swap
    jmp no_swap

end:
    popa
    leave
    ret
