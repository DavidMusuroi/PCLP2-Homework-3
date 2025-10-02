extern qsort
extern strcmp
extern strlen

section .bss
    ; verific daca am ajuns la un cuvant
    word_check resd 1
    ; dimensiunea primului cuvant pe care o voi folosi in functia de comparare
    length_first_word resd 1

section .text
global sort
global get_words

compare:
    push edi
    push esi
    ; Dereferentiez primul string
    mov edi, [esp + 12]
    mov edi, [edi]
    ; Dereferentiez al doilea string
    mov esi, [esp + 16]
    mov esi, [esi]

    push edi
    call strlen
    ; Determin lungimea primului cuvant
    add esp, 4
    mov dword[length_first_word], eax

    push esi
    call strlen
    ; Determin lungimea celui de-al doilea cuvant
    add esp, 4

    cmp dword[length_first_word], eax
    jl neg
    jg poz
    je sort_lexicographic

neg:
    ; Daca len(str1) < len(str2)
    mov eax, -1
    jmp end1

poz:
    ; Daca len(str1) > len(str2)
    mov eax, 1
    jmp end1

sort_lexicographic:
    push esi
    push edi
    call strcmp
    ; Sortez lexicografic cu strcmp cele 2 string-uri
    add esp, 8
    jmp end1

end1:
    pop esi
    pop edi
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix

sort:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    ; pun in ebx toate cuvintele
    mov ebx, [ebp + 8]
    ; pun in ecx numarul de cuvinte
    mov ecx, [ebp + 12]
    ; pun in edx dimensiunea unui cuvant
    mov edx, [ebp + 16]

    push compare
    push edx
    push ecx
    push ebx
    call qsort
    ; pun stack-ul inapoi la locul lui
    add esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    ; pun in ebx sirul de la inceput
    mov ebx, [ebp + 8]
    ; pun in ecx toate cuvintele
    mov ecx, [ebp + 12]
    ; pun in edx numarul de cuvinte
    mov edx, [ebp + 16]
    ; nu am gasit inca un cuvant
    mov dword[word_check], 0

loop_sir:
    ; daca am ajuns la terminator
    cmp byte [ebx], 0
    je end2

    cmp byte [ebx], ' '
    je found_delim

    cmp byte [ebx], ','
    je found_delim

    cmp byte [ebx], '.'
    je found_delim

    ; daca am gasit deja cuvantul
    cmp dword[word_check], 1
    je next_char
    jmp found_word

found_delim:
    ; daca nu este cuvant
    cmp dword[word_check], 0
    je next_char
    ; pun in sirul initial terminatorul ca sa inchei cuvantul curent
    mov byte [ebx], 0
    ; actualizez word_check din 1 in 0
    mov dword[word_check], 0
    jmp next_char

next_char:
    inc ebx
    jmp loop_sir

found_word:
    ; pun in vectorul de cuvinte inceputul cuvantului gasit
    mov [ecx + 4 * eax], ebx
    inc eax
    ; am gasit un cuvant si marchez acest lucru
    mov dword[word_check], 1
    jmp next_char

end2:
    leave
    ret