.model small
.stack 100h
.data
menu db 13,10,'--- Retro Diner Menu ---',13,10
     db '1. Burger - $5',13,10
     db '2. Pizza  - $8',13,10
     db '3. Soda   - $2',13,10
     db '4. Exit',13,10
     db 'Enter your choice: $'

thankyou db 13,10,'Thank you for your order!',13,10,'$'
invalid db 13,10,'Invalid choice.',13,10,'$'
burger db 13,10,'Burger added. Total: $5',13,10,'$'
pizza db 13,10,'Pizza added. Total: $8',13,10,'$'
soda db 13,10,'Soda added. Total: $2',13,10,'$'

.code
start:
    mov ax, @data
    mov ds, ax

menu_loop:
    mov ah, 09h
    lea dx, menu
    int 21h

    mov ah, 01h
    int 21h
    mov bl, al

    cmp bl, '1'
    je burger_option
    cmp bl, '2'
    je pizza_option
    cmp bl, '3'
    je soda_option
    cmp bl, '4'
    je exit_app
    jmp invalid_option

burger_option:
    mov ah, 09h
    lea dx, burger
    int 21h
    jmp menu_loop

pizza_option:
    mov ah, 09h
    lea dx, pizza
    int 21h
    jmp menu_loop

soda_option:
    mov ah, 09h
    lea dx, soda
    int 21h
    jmp menu_loop

invalid_option:
    mov ah, 09h
    lea dx, invalid
    int 21h
    jmp menu_loop

exit_app:
    mov ah, 09h
    lea dx, thankyou
    int 21h
    mov ah, 4Ch
    int 21h
end start
