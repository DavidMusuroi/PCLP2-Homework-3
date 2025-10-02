section .text
global kfib

kfib:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    ; pun in ebx pe n
    mov ebx, [ebp + 8]
    mov eax, ebx
    ; voi pune din eax in esi numarul de byti pentru cele n elementele ale 
    ; sirului
    mov edi, 4
    mul edi
    ; pun in edx pe k
    mov edx, [ebp + 12]
    sub esp, eax
    mov esi, esp
    xor ecx, ecx

compare:
    inc ecx
    cmp ecx, ebx
    jg end
    cmp ecx, edx
    jl add_0
    je add_1
    mov edi, edx
    inc edi
    cmp ecx, edi
    je add_1
    jg add_fibo

add_0:
    dec ecx
    ; pun in vectorul de elemente valoarea 0
    mov dword[esi + 4 * ecx], 0
    inc ecx
    jmp compare

add_1:
    dec ecx
    ; pun in vectorul de elemente valoarea 1
    mov dword[esi + 4 * ecx], 1
    inc ecx
    ; initializez suma cu 1
    mov eax, 1
    jmp compare

add_fibo:
    ; ma voi referi la pozitia curenta ca fiind ecx - 1
    dec ecx
    ; ma duc pe pozitia curenta anterioara
    dec ecx
    ; pun in edi valoarea anterioara
    mov edi, dword[esi + 4 * ecx]
    ; adaug la suma aceasta valoare
    add eax, edi
    sub ecx, edx
    ; pun in edi valoarea de pe pozitia curenta - k
    mov edi, dword[esi + 4 * ecx]
    ; scad din suma elementul de pe pozitia curenta - k
    sub eax, edi
    add ecx, edx
    inc ecx
    ; pun in elementul de pe pozitia curenta valoarea calculata in suma
    mov dword[esi + 4 * ecx], eax
    inc ecx
    jmp compare

end:
    leave
    ret