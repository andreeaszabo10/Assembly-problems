section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here

section .text
	global pwd
    extern strcat

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories
pwd:
	enter 0, 0
    pusha
   
    mov edi, [ebp + 8] ;; vectorul de stringuri
    mov ecx, [ebp + 12] ;; numarul de elemente
    mov edx, [ebp + 16] ;; output-ul

    ;; am pus slash-ul de inceput in output
    mov [edx], byte '/'
    ;; am initializat contorul cu nr de directoare ca sa scad din el
    mov esi, ecx

new_directory:
    ;; daca am terminat de citit directoare ies
    cmp esi, 0
    je end
    ;; modific contorul
    sub esi, 1
    ;; pun in ebx adresa directorului curent
    xor ebx, ebx
    mov ebx, dword [edi]
    ;; daca directorul curent este . sau .. nu scriu
    cmp byte [ebx], '.'
    je dont_write
    ;; pun in eax adresa urmatorului director pentru ca daca urmatorul
    ;; este .., nu il mai pun in output pe cel curent
    xor eax, eax
    mov eax, dword [edi + 4]
    ;; daca incepe cu . poate fi .. deci verific daca scriu sau nu
    cmp byte [eax], '.'
    je verify

;; scriu in output directorul curent
write:
    ;; concatenez directorul la ce era deja in output
    push ebx
    push edx
    call strcat
    add esp, 8
    ;; ma asigur ca edx are adresa buna
    mov edx, [ebp + 16]
    ;; trec la urmatorul director din vector
    add edi, 4
    ;; concatenez si un slash
    push slash
    push edx
    call strcat
    add esp, 8
    ;; ma asigur ca edx are adresa buna
    mov edx, [ebp + 16]
    jmp new_directory

;; trec la adresa urmatorului director si nu il scriu pe cel curent
dont_write: 
    add edi, 4
    jmp new_directory

;; verific daca .. este pe pozitia urmatoare sau a doua care urmeaza
verify:
    ;; urmeaza .. deci nu scriu in output directorul curent
    cmp byte [eax + 1], '.'
    je dont_write
    ;; verifc daca .. e pe pozitia a 2 a urmatoare
    xor eax, eax
    mov eax, dword [edi + 8]
    ;; daca nu incepe cu . n-are cum sa fie .. 
    cmp byte [eax], '.'
    jne write
    ;; daca e .. nu scriu, altfel e doar . deci scriu
    cmp byte [eax + 1], '.'
    je dont_write
    jne write

end:
    popa
    leave
    ret