.model small
.stack 100h
.data
    name db 'Enter your name: $'
    budget_msg db 13,10, 'Enter your budget: $'
    menu db 13,10, 'MENU:',13,10,
         '1. Coffee - 30',13,10,
         '2. Sandwich - 50',13,10,
         '3. Burger - 80',13,10,
         '4. Tea - 20',13,10,
         '5. Cake Slice - 40',13,10,
         'Enter item number (9 to finish): $'
    total_msg db 13,10,'Total bill is: $'
    input db ?
    total dw 0

.code
start:
    mov ax, @data
    mov ds, ax

; --- Ask for name
    mov ah, 09h
    lea dx, name
    int 21h

; --- Dummy name input
    mov ah, 01h     ; read char (simulate name)
    int 21h
    mov ah, 02h     ; print newline
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

; --- Ask for budget
    mov ah, 09h
    lea dx, budget_msg
    int 21h

    mov ah, 01h     ; read budget (simulate input)
    int 21h
    mov ah, 02h     ; print newline
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

; --- Show menu
menu_loop:
    mov ah, 09h
    lea dx, menu
    int 21h

    mov ah, 01h     ; get item number
    int 21h
    sub al, 30h     ; convert ASCII to number
    cmp al, 9       ; if 9, finish
    je show_total

    cmp al, 1
    je add_coffee
    cmp al, 2
    je add_sandwich
    cmp al, 3
    je add_burger
    cmp al, 4
    je add_tea
    cmp al, 5
    je add_cake
    jmp me
