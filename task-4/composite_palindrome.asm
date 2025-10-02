extern strlen
extern malloc
extern strcat
extern strcmp
extern free
extern strcpy

section .bss

    ; masca folosita de la 1 la 2^15
    mask resd 1
    ; lungimea curenta a sirurilor concatenate
    crt_len resd 1
    ; string-ul concatenat
    crt_string resd 1
    ; string-ul care trebuie afisat
    final_string resd 1
    ; lungimea finala a sirului
    final_len resd 1

section .text
global check_palindrome
global composite_palindrome

check_palindrome:
    ; create a new stack frame
    enter 0, 0
    pusha
    xor eax, eax
    ; pun in ecx string-ul
    mov ecx, [ebp + 8]
    ; pun in edx lungimea sirului
    mov edx, [ebp + 12]
    ; cu esi iterez de la inceputul sirului pana la final
    xor esi, esi
    ; cu edi iterez de la finalul sirului pana la inceput
    mov edi, edx
    dec edi

loop_string:
    cmp esi, edx
    je pal
    jne check_crt_char

check_crt_char:
    mov al, byte [ecx + esi]
    cmp al, byte [ecx + edi]
    jne not_pal
    inc esi
    dec edi
    jmp loop_string

not_pal:
    popa
    ; returnez 0 daca sirul nu este palindrom
    xor eax, eax
    leave
    ret

pal:
    popa
    ; returnez 1 daca sirul este palindrom
    mov eax, 1
    leave
    ret

concatenate_strings:
    ; creez un nou stack frame
    enter 0, 0
    xor eax, eax
    pusha
    ; esi : sirurile
    mov esi, [ebp + 8]
    ; ecx : numarul de siruri
    mov ecx, [ebp + 12]
    ; edx : masca
    mov edx, [ebp + 16]

    ; aloc dinamic
    mov ebx, 150
    push ebx
    call malloc
    ; pun stack-ul inapoi la locul lui
    add esp, 4
    ; pun in edi pointer-ul catre memoria alocata
    mov edi, eax
    ; pun terminatorul la inceputul lui edi pentru a delimita cazul strcpy de
    ; strcat
    mov byte [edi], 0
    ; pun in ecx numarul de siruri (15)
    mov ecx, [ebp + 12]
    ; cu ebx iterez prin cele ecx siruri
    xor ebx, ebx
    xor eax, eax

cat_result:
    cmp ebx, ecx
    jge end_concatenate

    ; shiftez la stanga pe 1 cu ebx pozitii
    mov eax, 1
    push ecx
    ; pun temporar in ecx iteratorul ebx
    mov ecx, ebx
    shl eax, cl
    ; pun temporar in ecx masca
    mov ecx, [ebp + 16]
    and eax, ecx
    pop ecx
    ; daca bit-ul i din masca este 0 continui loop-ul
    cmp eax, 0
    je inc_cat_loop

    ; daca nu, pun in eax sirul la care am ajuns
    mov eax, [esi + 4 * ebx]
    ; verific daca primul caracter al sirului pe care vreau sa il returnez este
    ; terminatorul sau alt caracter
    movzx edx, byte [edi]
    ; daca in edx se afla decat terminatorul, fac strcpy, iar altfel fac strcat
    cmp edx, 0
    je copy
    jne cat

copy:
    pusha
    push eax
    push edi
    call strcpy
    ; pun stack-ul inapoi la locul lui
    add esp, 8
    popa
    jmp inc_cat_loop

cat:

    pusha
    push eax
    push edi
    call strcat
    ; pun stack-ul inapoi la locul lui
    add esp, 8
    popa

inc_cat_loop:
    inc ebx
    jmp cat_result

end_concatenate:
    mov dword [crt_string], edi
    popa
    leave
    ret

composite_palindrome:
    ; create a new stack frame
    enter 0, 0
    pusha
    xor eax, eax
    ; esi : sirurile
    mov esi, [ebp + 8]
    ; initializez masca cu 1
    mov dword [mask], 1
    ; initializez final string cu terminatorul
    mov dword [final_string], 0
    ; lungimea finala o initializez cu 0
    mov dword [final_len], 0
    xor ebx, ebx

loop_mask:
    ; Trec cu masca de la 1 la 32768
    mov ebx, 1
    ; cand apelez functii externe e posibil sa imi modifice registrul ecx asa
    ; ca il voi initializez mereu aici ca fiind numarul de siruri (15)
    mov ecx, [ebp + 12]
    shl ebx, cl
    cmp dword [mask], ebx
    jge end2

    ; Apelez concatenate_strings
    push dword [mask]
    push ecx
    push esi
    call concatenate_strings
    ; pun stack-ul inapoi la locul lui
    add esp, 12

    pusha
    push dword [crt_string]
    call strlen
    ; pun stack-ul inapoi la locul lui
    add esp, 4
    mov dword [crt_len], eax
    popa

    push dword [crt_len]
    push dword [crt_string]
    call check_palindrome
    ; pun stack-ul inapoi la locul lui
    add esp, 8

    ; daca sirul nu este palindrom
    cmp eax, 1
    jne continue_loop

    ; daca sirul este palindrom verific cele 2 lungimi
    mov ebx, [crt_len]
    cmp ebx, dword [final_len]
    jg get_final_string
    jl continue_loop
    je check_lexicographic

check_lexicographic:
    push dword [crt_string]
    push dword [final_string]
    call strcmp
    ; pun stack-ul inapoi la locul lui
    add esp, 8
    ; daca strcmp(final, crt) <= 0
    cmp eax, 0
    jle continue_loop

    ; actualizez sirul final pentru a fi minim lexicografic
    mov ebx, dword [crt_string]
    mov dword [final_string], ebx
    jmp continue_loop


get_final_string:
    ; actualizez sirul final
    mov dword [final_len], ebx
    mov ebx, dword [crt_string]
    mov dword [final_string], ebx

continue_loop:
    ; adaug 1 la masca pentru a itera de la 1 la 2^15
    add dword [mask], 1
    jmp loop_mask

end2:
    popa
    mov eax, [final_string]
    leave
    ret