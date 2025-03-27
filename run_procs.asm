%include "../include/io.mac"

struc avg
    .quo: resw 1
    .remain: resw 1
endstruc

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

section .text
    global run_procs
    extern printf

run_procs:

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

    mov edi, 0
;; perform this operation for all processes
outer:
    cmp edi, ebx
    jg end
    mov edx, 0
    ;; check the priority of the process
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
;; process of finding elements in the vectors
process:
    add edi, 1
    lea ecx, [ecx + 5]
    jmp outer

;; for each priority, I have a different case where I increase the number of
;; components for the respective priority in the prio_result vector
;; and add the time at the appropriate position in the time_result vector
;; calculate the position in the vector by adding 4 times the desired position
add1:
    ;; put the prio vector in a register
    mov edx, prio_result
    ;; get the address of the position being sought
    mov esi, [edx]
    ;; add 1 since I found another element with this priority
    add esi, 1
    ;; put the value back
    mov [edx], esi
    ;; put the prio vector in a register
    mov edx, time_result
    ;; add the time to the previous value in the vector
    mov esi, [edx]
    add esi, [ecx + proc.time]
    mov [edx], esi
    jmp process

;; do the same thing for the next cases, just adding 4 for each
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

;; add the final values in the avg structure
;; there are 5 cases like this, I'll write just for one
end:
    push eax
    ;; put the vectors in registers
    mov ebx, prio_result
    mov ecx, time_result
    ;; get the values for the first priority
    mov bx, word [ebx]
    mov ax, word [ecx]
    mov edx, 0
    ;; if the divisor is 0, skip division and set 0 directly
    cmp bx, 0
    je no1
    ;; perform the division
    div bx
    mov bx, ax
    jmp avg1
no1:
    mov dx, 0
avg1:
    pop eax
    ;; put the found values in the avg structure
    mov [eax + avg.quo], bx
    mov [eax + avg.remain], dx
    ;; add 4 to the address and move to the next priority
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

    popa
    leave
    ret
