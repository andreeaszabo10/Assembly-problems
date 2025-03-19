section .data
	; declare global vars here

section .text
	global reverse_vowels
    extern printf

reverse_vowels:

    push ebp
    push esp
    pop ebp
    push ebx
    
    ;; pun in edx adresa la care se afla string-ul
    push dword [ebp + 8]
    pop edx

;; loop pentru a pune pe stiva toate vocalele din string
loop1:
    ;; daca am ajuns la finalul string-ului trec la loop-ul in care adaug
    cmp byte [edx], 0
    je next
    ;; verific caracterul si daca e vocala, sar la label-ul unde o pun pe stiva
    cmp byte [edx], 'a'
    je next1
    cmp byte [edx], 'e'
    je next1
    cmp byte [edx], 'i'
    je next1
    cmp byte [edx], 'o'
    je next1
    cmp byte [edx], 'u'
    je next1
    ;; nu e vocala deci trec la urmatorul caracter pur si simplu
    add edx, 1
    jmp loop1
    
next1:
    ;; pun vocala pe stiva apoi trec la urmatorul caracter
    push dword [edx]
    add edx, 1
    jmp loop1

;; partea in care schimb vocalele cu cele din stiva
next:
    ;; pun iar in edx adresa string-ului ptr ca am modificat edx in loop-ul de sus
    push dword [ebp + 8]
    pop edx

;; verific daca fiecare caracter e vocala
loop2:
    ;; verific daca am ajuns la finalul string-ului si daca da, ies
    cmp byte [edx], 0
    je end
    ;; verific daca e vocala caracterul la care ma aflu si daca e, sar
    ;; la label-ul unde incepe schimbarea
    cmp byte [edx], 'a'
    je next2
    cmp byte [edx], 'e'
    je next2
    cmp byte [edx], 'i'
    je next2
    cmp byte [edx], 'o'
    je next2
    cmp byte [edx], 'u'
    je next2
    ;; nu e vocala deci trec la urmatorul caracter
    add edx, 1
    jmp loop2

;; scot din stiva ultima vocala pusa, si vad ce vocala e ca sa vad in ce caz ma duc
next2:
    ;; scot vocala
    pop ebx
    ;; verific ce vocala e si merg in cazul corespunzator
    cmp byte bl, 'a'
    je is_a
    cmp byte bl, 'e'
    je is_e
    cmp byte bl, 'i'
    je is_i
    cmp byte bl, 'o'
    je is_o
    jmp is_u

;; daca litera pe care vreau sa o introduc e a
is_a:
    ;; fac and intre bitii literei si 0 ca sa ii resetez pe toti la 0
    and byte [edx], byte 0
    ;; fac or intre bitii de la adresa literei pe care vreau sa o schimb
    ;; (care acum sunt 0 )si bitii literei pe care vreau sa o adaug (adica a)
    or byte [edx], 'a'
    jmp next3

;; daca litera pe care vreau sa o introduc e e
is_e:
    ;; fac and intre bitii literei si 0 ca sa ii resetez pe toti la 0
    and byte [edx], byte 0
    ;; fac or intre bitii de la adresa literei pe care vreau sa o schimb
    ;; (care acum sunt 0) si bitii literei pe care vreau sa o adaug (adica e)
    or byte [edx], 'e'
    jmp next3

;; daca litera pe care vreau sa o introduc e i
is_i:
    ;; fac and intre bitii literei si 0 ca sa ii resetez pe toti la 0
    and byte [edx], byte 0
    ;; fac or intre bitii de la adresa literei pe care vreau sa o schimb
    ;; (care acum sunt 0) si bitii literei pe care vreau sa o adaug (adica i)
    or byte [edx], 'i'
    jmp next3

;; daca litera pe care vreau sa o introduc e o
is_o:
    ;; fac and intre bitii literei si 0 ca sa ii resetez pe toti la 0
    and byte [edx], byte 0
    ;; fac or intre bitii de la adresa literei pe care vreau sa o schimb
    ;; (care acum sunt 0) si bitii literei pe care vreau sa o adaug (adica o)
    or byte [edx], 'o'
    jmp next3

;; daca litera pe care vreau sa o introduc e u
is_u:
    ;; fac and intre bitii literei si 0 ca sa ii resetez pe toti la 0
    and byte [edx], byte 0
    ;; fac or intre bitii de la adresa literei pe care vreau sa o schimb
    ;; (care acum sunt 0) si bitii literei pe care vreau sa o adaug (adica u)
    or byte [edx], 'u'

;; sar aici cand am terminat de verificat caracterul curent
next3:
    ;; trec la pozitia urmatorului caracter
    add edx, 1
    ;; trec la urmatoarea verificare
    jmp loop2

;; sar aici cand nu mai sunt alte caractere de verificat
end:
    pop ebx
    push ebp
    pop esp
    pop ebp
ret