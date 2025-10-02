Task1 - Sortari

esi --> Vectorul de visitati
ebx --> n
edx --> node[i]
ecx --> primul loop
edi --> al doilea loop
eax --> tmp pt a determina valoarea maxima

Voi implementa acest task folosind un vector de vizitati pe care la inceput il
voi initializa cu 0 pentru toate elementele. Dupa accea, voi merge prin
elementele vectorului cu 2 for-uri de la 1 la n si voi determina la fiecare pas
elementul maxim nevizitat si indexul sau. Daca suntem la primul pas (i = 1),
voi lasa next-ul elementului ca fiind NULL si voi stabili index-ul anterior ca
fiind indexul curent. Daca am trecut de primul numar, initializez next-ul
elementului curent ca fiind valoarea de la index-ul maxim anterior si
actualizez index-ul maxim anterior. La finalul primului loop, initializez eax
ca fiind inceputul celui mai mic element (ultimul la care am ajuns, pentru ca
am facut determinat elementele de la cel mai mare la cel mai mic).

Task 2 - Operatii

In eticheta compare compar lungimile celor 2 cuvinte si returnez 1 sau -1  in
functie de lungimile lor, sau daca au aceeasi lungime le compar lexicografic
folosind strcmp si returnez rezultatul ei.

In eticheta sort apelez quicksort cu functia de compare descrisa mai sus.

In eticheta loop_sir iterez prin toate caracterele sirului initial si verific
daca am ajuns la terminator, sau la un delimitator sau ma aflu la inceputul
unui cuvant. Astfel, de fiecare data cand gasesc un delimitator pun in locul
sau terminatorul pentru a incheia cuvantul corespunzator vectorului de cuvinte,
iar in caz contrar verific daca ma aflu la un cuvant. Daca nu ma aflu trec la
urmatorul caracter, iar daca da marchez inceputul sau sau in vectorul de
cuvinte, urmand sa inchei cuvantul cand am ajuns la un delimitator.

Task 3 - KFib

eax --> suma
ebx --> n
ecx --> 1 ... n
edx --> k
esi --> vectorul de elemente
edi --> tmp pt esi si cazul extrem 1 dupa 1

In cadrul acestui task, iterez prin elementele de la 1 la n si construiesc
sirul lui Fibonacci in urmatorul fel : daca indexul elementului curent este < k
pun in vectorul de elemente valoarea 0, daca este egal cu k pun in vector
valoarea 1, daca este egal cu k + 1 pun in vector din nou valoarea 1 (suma
primelor k valori este 1 pt ca primele k - 1 sunt 0 si al k-lea este 1) ,iar
pentru valorile mai mari decat k + 1, pentru a determina elementul de pe o
pozitie aleatoare m, adaug la suma elementul m - 1 si scad elementul m - k - 1.

Task 4 - Composite Palindrome

In primul subtask iterez cu 2 registre de la inceputul cuvantului pana la final
respectiv de la final pana la inceput si returnez 0 sau 1 daca sirul este
palindrom sau nu.

In cel de-al doilea subtask iterez iterez cu o masca de la 1 la 2^15 prin toate
posibilitatile de a concatena subsirurile, apeland de fiecare data functia care
imi concateneaza sirurile. In continuare, determin lungimea curenta a sirului
si o retin, cat si sirul in sine. Apelez functia de la primul subtask si daca
aceasta imi returneaza 0 continui iterarea prin masca, iar in caz contrar voi
compara lungimea sirului curent cu lungimea sirului final, pe care am
initializat-o ca fiind 0. Astfel, daca lungimea curenta este mai mare decat
lungimea sirului final copiez lungimea si sirul in sirul final, daca este mai
mica voi sari peste ea iar daca cele 2 lungimi sunt egale compar lexicografic
cele 2 siruri si aleg sirul care este mai mic lexicografic, actualizand sirul
final si lungimea lui, in final dupa cele 2^15 iteratii returnand acest sir.

In functia concatenate_strings care primeste ca argumente sirurile, numarul lor
si masca, mai intai aloc dinamic sirul pe care vreau sa il concatenez, si
iterez prin siruri pana cand bit-ul i din masca este 1, caz in care aplic
strcpy daca in sirul pe care vreau sa il returnez se afla decat terminatorul,
iar altfel aplic strcat intre sirul pe care vreau sa il returnez si al i-lea
sir. La final, returnez sirul cautat in crt_string.