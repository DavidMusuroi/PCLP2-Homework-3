section .bss
    ; valoarea maxima curenta
    max_val resd 1
    ; indexul maxim curent
    max_index resd 1
    ; indexul maxim anterior
    prev_max_index resd 1

section .text
global sort

;   struct node {
;    int val;
;    struct node* next;
;   };

;; struct node* sort(int n, struct node* node);
;   The function will link the nodes in the array
;   in ascending order and will return the address
;   of the new found head of the list
; @params:
;   n -> the number of nodes in the array
;   node -> a pointer to the beginning in the array
;   @returns:
;   the address of the head of the sorted list
sort:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    ; pun in ebx numarul de elemente al structurii
    mov ebx, [ebp + 8]

    mov eax, ebx
    ; pun in eax numarul de byti alocati pentru structura (4 * n)
    mov edi, 4
    mul edi
    xor edi, edi
    ; pun in edx vectorul de structuri
    mov edx, [ebp + 12]

    sub esp, eax
    xor eax, eax
    mov esi, esp
    xor ecx, ecx
    ; incep indexarea de la -1
    mov dword[prev_max_index], -1

loop_unvisited:
    inc ecx
    cmp ecx, ebx
    jle mark_unvisited

    xor ecx, ecx
    jmp first_loop

mark_unvisited:
    dec ecx
    ; initializez la inceput vectorul de vizitati ca fiind toti nevizitati
    mov dword[esi + 4 * ecx], 0
    inc ecx
    jmp loop_unvisited

first_loop:
    inc ecx
    ; valoarea maxima curenta o initializez cu -1
    mov dword[max_val], -1
    ; index-ul maxim curent il initializez cu -1
    mov dword[max_index], -1
    xor edi, edi
    cmp ecx, ebx
    jle second_loop

second_loop:
    cmp edi, ebx
    je establish_first_link
    ; compar valoarea nodului curent cu valoarea maxima curenta
    mov eax, [edx + 8 * edi]
    cmp eax, dword[max_val]
    jg check_if_already_visited

    inc edi
    jmp second_loop

check_if_already_visited:
    ; verific daca am linkat deja acest nod
    cmp dword[esi + 4 * edi], 0
    jg next_elem
    je get_max_index_and_value

next_elem:
    inc edi
    jmp second_loop

get_max_index_and_value:
    mov dword[max_val], eax
    mov dword[max_index], edi
    inc edi
    jmp second_loop

establish_first_link:
    push ecx
    mov ecx, dword[max_index]
    ; pun elementul maxim gasit ca fiind vizitat
    mov dword[esi + 4 * ecx], 1
    pop ecx
    ; daca am mai linkat ceva pana acum
    cmp dword[prev_max_index], -1
    jg establish_next_link
    push ebx
    mov ebx, dword[max_index]
    ; daca nu, initializez indexul maxim anterior ca fiind indexul curent
    ; pentru urmatorul loop
    mov dword[prev_max_index], ebx
    pop ebx
    jmp first_loop

establish_next_link:
    push ecx
    mov ecx, dword[max_index]
    push ebx
    push edi
    mov edi, dword[prev_max_index]
    mov dword[prev_max_index], ecx
    ; copiez adresa elementului structurii din al doilea loop in ebx
    lea ebx, [edx + 8 * edi]
    pop edi
    ; pun next-ul elementului din primul loop ca fiind ebx
    mov [edx + 8 * ecx + 4], ebx
    pop ebx
    pop ecx
    cmp ecx, ebx
    je end
    jl first_loop

end:
    mov ecx, dword[prev_max_index]
    ; eax este inceputul next-ului celui mai mic element
    lea eax, [edx + 8 * ecx]
    leave
    ret