; 8086 Assembly Program: TechStore Shop with User Login, Item Add/Remove, Cart

.model small
.stack 100h
.data
    ; Constants
    max_users      equ 5
    username_len   equ 20
    password_len   equ 20
    user_size      equ username_len + password_len

    ; User list: 5 users max
    user_list db user_size * max_users dup('$')
    curr_user_count db 0

    ; Temporary buffers
    temp_username db username_len dup('$')
    temp_password db password_len dup('$')

    ; Item names & prices
    item_menu db 13,10,'1. Laptop - $1000',13,10,'2. Mouse - $20',13,10,'3. Keyboard - $30',13,10,'Choice: $'
    cart_total dw 0
    qty_laptop dw 0
    qty_mouse dw 0
    qty_keyboard dw 0
    price_laptop dw 1000
    price_mouse dw 20
    price_keyboard dw 30

    ; Messages
    main_menu db 13,10,'1. Register',13,10,'2. Login',13,10,'3. Exit',13,10,'Choice: $'
    login_menu db 13,10,'1. Add Item',13,10,'2. Remove Item',13,10,'3. Show Cart',13,10,'4. Logout',13,10,'Choice: $'
    input_msg db 'Enter username: $'
    pass_msg db 13,10,'Enter password: $'
    reg_success db 13,10,'Registration successful!',13,10,'$'
    reg_fail db 13,10,'Registration failed. Max users reached.',13,10,'$'
    login_success db 13,10,'Login successful!',13,10,'$'
    login_fail db 13,10,'Login failed.',13,10,'$'
    cart_msg db 13,10,'Cart total: $'
    newline db 13,10,'$'
    qty_laptop_msg    db 13,10,'Laptop x', '$'
    qty_mouse_msg     db 13,10,'Mouse x', '$'
    qty_keyboard_msg  db 13,10,'Keyboard x', '$'
    buffer db 6 dup('$')

.code
main:
    mov ax, @data
    mov ds, ax

main_loop:
    mov ah, 09h
    lea dx, main_menu
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 1
    je register
    cmp al, 2
    je login
    cmp al, 3
    je exit_program
    jmp main_loop

register:
    mov al, curr_user_count
    cmp al, max_users
    jae reg_full

    lea dx, input_msg
    mov ah, 09h
    int 21h
    lea si, temp_username
    call get_input

    lea dx, pass_msg
    mov ah, 09h
    int 21h
    lea si, temp_password
    call get_input

    ; Store user
    mov al, curr_user_count
    mov bl, al
    mov ax, user_size
    mul bl
    mov di, offset user_list
    add di, ax

    ; Copy username
    lea si, temp_username
    mov cx, username_len
    rep movsb

    ; Copy password
    lea si, temp_password
    mov cx, password_len
    rep movsb

    inc curr_user_count
    lea dx, reg_success
    mov ah, 09h
    int 21h
    jmp main_loop

reg_full:
    lea dx, reg_fail
    mov ah, 09h
    int 21h
    jmp main_loop

login:
    lea dx, input_msg
    mov ah, 09h
    int 21h
    lea si, temp_username
    call get_input

    lea dx, pass_msg
    mov ah, 09h
    int 21h
    lea si, temp_password
    call get_input

    xor bx, bx
check_users:
    mov cx, username_len
    lea si, temp_username
    mov ax, user_size
    mul bx
    mov di, offset user_list
    add di, ax
    push di
    repe cmpsb
    pop di
    jne next_user

    ; Compare password
    lea si, temp_password
    add di, username_len
    mov cx, password_len
    repe cmpsb
    je login_ok

next_user:
    inc bx
    cmp bl, curr_user_count
    jb check_users

    lea dx, login_fail
    mov ah, 09h
    int 21h
    jmp main_loop

login_ok:
    lea dx, login_success
    mov ah, 09h
    int 21h
    jmp store_menu

store_menu:
    lea dx, login_menu
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 1
    je add_item
    cmp al, 2
    je remove_item
    cmp al, 3
    je show_cart
    cmp al, 4
    je main_loop
    jmp store_menu

add_item:
    lea dx, item_menu
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 1
    je add_laptop
    cmp al, 2
    je add_mouse
    cmp al, 3
    je add_keyboard
    jmp store_menu

add_laptop:
    inc qty_laptop
    mov ax, cart_total
    add ax, price_laptop
    mov cart_total, ax
    jmp store_menu
add_mouse:
    inc qty_mouse
    mov ax, cart_total
    add ax, price_mouse
    mov cart_total, ax
    jmp store_menu
add_keyboard:
    inc qty_keyboard
    mov ax, cart_total
    add ax, price_keyboard
    mov cart_total, ax
    jmp store_menu

remove_item:
    lea dx, item_menu
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    sub al, '0'
    cmp al, 1
    je rem_laptop
    cmp al, 2
    je rem_mouse
    cmp al, 3
    je rem_keyboard
    jmp store_menu

rem_laptop:
    cmp qty_laptop, 0
    je store_menu
    dec qty_laptop
    mov ax, cart_total
    sub ax, price_laptop
    mov cart_total, ax
    jmp store_menu
rem_mouse:
    cmp qty_mouse, 0
    je store_menu
    dec qty_mouse
    mov ax, cart_total
    sub ax, price_mouse
    mov cart_total, ax
    jmp store_menu
rem_keyboard:
    cmp qty_keyboard, 0
    je store_menu
    dec qty_keyboard
    mov ax, cart_total
    sub ax, price_keyboard
    mov cart_total, ax
    jmp store_menu

show_cart:
    lea dx, cart_msg
    mov ah, 09h
    int 21h
    mov ax, cart_total
    call print_number

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, qty_laptop_msg
    mov ah, 09h
    int 21h
    mov ax, qty_laptop
    call print_number

    lea dx, qty_mouse_msg
    mov ah, 09h
    int 21h
    mov ax, qty_mouse
    call print_number

    lea dx, qty_keyboard_msg
    mov ah, 09h
    int 21h
    mov ax, qty_keyboard
    call print_number

    lea dx, newline
    mov ah, 09h
    int 21h

    jmp store_menu

exit_program:
    mov ah, 4Ch
    int 21h

;---------------------
; Utility functions
;---------------------
get_input:
    ; DS:SI -> destination, max 20 chars
    push cx
    xor cx, cx
.loop:
    mov ah, 01h
    int 21h
    cmp al, 13
    je .done
    mov [si], al
    inc si
    loop .loop
.done:
    mov byte ptr [si], '$'
    pop cx
    ret

print_number:
    ; AX = number, prints it as ASCII
    push ax
    push bx
    push cx
    push dx
    xor cx, cx
    mov bx, 10
next_digit:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz next_digit
print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop
    pop dx
    pop cx
    pop bx
    pop ax
    ret

end main