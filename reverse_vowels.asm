section .data
    	
section .text
	global reverse_vowels
    extern printf

reverse_vowels:

    push ebp
    push esp
    pop ebp
    push ebx
    
    ;; push the address of the string into edx
    push dword [ebp + 8]
    pop edx

;; loop to push all vowels from the string onto the stack
loop1:
    ;; if we have reached the end of the string, go to the next loop to swap
    cmp byte [edx], 0
    je next
    ;; check the character, and if it is a vowel, jump to the label where we push it onto the stack
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
    ;; it's not a vowel, so just move to the next character
    add edx, 1
    jmp loop1
    
next1:
    ;; push the vowel onto the stack and move to the next character
    push dword [edx]
    add edx, 1
    jmp loop1

;; part where we swap vowels with those on the stack
next:
    ;; push the string's address into edx again because we modified edx in the previous loop
    push dword [ebp + 8]
    pop edx

;; check if each character is a vowel
loop2:
    ;; check if we've reached the end of the string and if so, exit
    cmp byte [edx], 0
    je end
    ;; check if the current character is a vowel and jump to swap it
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
    ;; it's not a vowel, so move to the next character
    add edx, 1
    jmp loop2

;; pop the last vowel and check which one it is to know where to go
next2:
    ;; pop the vowel
    pop ebx
    ;; check which vowel it is and jump to the corresponding case
    cmp byte bl, 'a'
    je is_a
    cmp byte bl, 'e'
    je is_e
    cmp byte bl, 'i'
    je is_i
    cmp byte bl, 'o'
    je is_o
    jmp is_u

;; if the vowel is 'a'
is_a:
    ;; reset all bits of the current character to 0
    and byte [edx], byte 0
    ;; set the bits of the current character to 'a'
    or byte [edx], 'a'
    jmp next3

;; if the vowel is 'e'
is_e:
    ;; reset all bits of the current character to 0
    and byte [edx], byte 0
    ;; set the bits of the current character to 'e'
    or byte [edx], 'e'
    jmp next3

;; if the vowel is 'i'
is_i:
    ;; reset all bits of the current character to 0
    and byte [edx], byte 0
    ;; set the bits of the current character to 'i'
    or byte [edx], 'i'
    jmp next3

;; if the vowel is 'o'
is_o:
    ;; reset all bits of the current character to 0
    and byte [edx], byte 0
    ;; set the bits of the current character to 'o'
    or byte [edx], 'o'
    jmp next3

;; if the vowel is 'u'
is_u:
    ;; reset all bits of the current character to 0
    and byte [edx], byte 0
    ;; set the bits of the current character to 'u'
    or byte [edx], 'u'

;; jump here when done checking the current character
next3:
    ;; move to the next character
    add edx, 1
    ;; continue with the next check
    jmp loop2

;; jump here when there are no more characters to check
end:
    pop ebx
    push ebp
    pop esp
    pop ebp
ret
