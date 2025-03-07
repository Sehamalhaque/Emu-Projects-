
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
.model small
.stack 100h
.data
    prompt db "Enter a 4-digit number: $"
    sum_msg db "Sum: $"
    sub_msg db " Subtraction: $"
    mul_msg db " Multiplication: $"
    div_msg db " Division: $"
    newline db 0Dh, 0Ah, "$"
    num db 4 dup(0)
    sum db ?
    sub_result db ?
    mul dw ?
    div db ?

.code
main proc
    mov ax, @data
    mov ds, ax

    mov dx, offset prompt
    mov ah, 09h
    int 21h

    mov si, offset num
    mov cx, 4
read_loop:
    mov ah, 01h
    int 21h
    sub al, '0'
    mov [si], al
    inc si
    loop read_loop

    mov al, num
    add al, num+1
    add al, num+2
    add al, num+3
    mov sum, al

    mov al, num
    mov bl, num+1
    sub al, bl
    mov bl, num+2
    sub al, bl
    mov bl, num+3
    sub al, bl
    mov sub_result, al

    mov ax, 1
    mov bl, num
    mul bl
    mov bl, num+1
    mul bl
    mov bl, num+2
    mul bl
    mov bl, num+3
    mul bl
    mov mul, ax

    mov al, num
    mov bl, num+1
    cmp bl, 0
    jne div_continue
    mov bl, 1
    div_continue:
    div bl
    mov bl, num+2
    cmp bl, 0
    jne div_next
    mov bl, 1
    div_next:
    div bl
    mov bl, num+3
    cmp bl, 0
    jne div_final
    mov bl, 1
    div_final:
    div bl
    mov div, al

    mov dx, offset sum_msg
    mov ah, 09h
    int 21h
    mov dl, sum
    add dl, '0'
    mov ah, 02h
    int 21h

    mov dx, offset sub_msg
    mov ah, 09h
    int 21h
    mov dl, sub_result
    add dl, '0'
    mov ah, 02h
    int 21h

    mov dx, offset mul_msg
    mov ah, 09h
    int 21h
    mov ax, mul
    call print_num

    mov dx, offset div_msg
    mov ah, 09h
    int 21h
    mov dl, div
    add dl, '0'
    mov ah, 02h
    int 21h

    mov ah, 4Ch
    int 21h

print_num proc
    aam
    add ax, 3030h
    mov dx, ax
    mov ah, 02h
    int 21h
    mov dl, dh
    int 21h
    ret
print_num endp

main endp
end main



ret




