section .data
    back db "..", 0
    curr db ".", 0
    slash db "/", 0

section .text
    global pwd
    extern strcat

;; void pwd(char **directories, int n, char *output)
;; Adds the resulting path to the output parameter from
;; traversing the n folders in directories
pwd:
    enter 0, 0
    pusha
   
    mov edi, [ebp + 8] ;; array of strings
    mov ecx, [ebp + 12] ;; number of elements
    mov edx, [ebp + 16] ;; output

    ;; add the leading slash to the output
    mov [edx], byte '/'
    ;; initialize the counter with the number of directories to subtract from it
    mov esi, ecx

new_directory:
    ;; if we've finished reading directories, exit
    cmp esi, 0
    je end
    ;; decrement the counter
    sub esi, 1
    ;; store the address of the current directory in ebx
    xor ebx, ebx
    mov ebx, dword [edi]
    ;; if the current directory is . or .., don't write it
    cmp byte [ebx], '.'
    je dont_write
    ;; store the address of the next directory in eax
    ;; because if the next directory is .., we shouldn't add the current one to the output
    xor eax, eax
    mov eax, dword [edi + 4]
    ;; if it starts with ., it could be .., so we need to check if we write it or not
    cmp byte [eax], '.'
    je verify

;; write the current directory to the output
write:
    ;; concatenate the directory to what was already in the output
    push ebx
    push edx
    call strcat
    add esp, 8
    ;; ensure that edx has the correct address
    mov edx, [ebp + 16]
    ;; move to the next directory in the array
    add edi, 4
    ;; concatenate a slash
    push slash
    push edx
    call strcat
    add esp, 8
    ;; ensure that edx has the correct address
    mov edx, [ebp + 16]
    jmp new_directory

;; move to the next directory address and don't write the current one
dont_write: 
    add edi, 4
    jmp new_directory

;; check if .. is in the next position or two positions ahead
verify:
    ;; if .. follows, don't write the current directory in the output
    cmp byte [eax + 1], '.'
    je dont_write
    ;; check if .. is in the second next position
    xor eax, eax
    mov eax, dword [edi + 8]
    ;; if it doesn't start with ., it can't be ..
    cmp byte [eax], '.'
    jne write
    ;; if it is .., don't write it, otherwise, if it's just ., write it
    cmp byte [eax + 1], '.'
    je dont_write
    jne write

end:
    popa
    leave
    ret
