.MODEL SMALL
.STACK 100H

.DATA
; Data section from 1st code
welcome_msg DB 10, 13, 'Welcome!$'
name_prompt DB 10, 13, 'What''s your name?$'
account_msg DB 10,13, 'Do you have an account? Press 1 for Yes or 2 for No. Enter your choice: $'
enter_password DB 10, 13, 'Enter your password: $'
new_password DB 10, 13, 'Enter a new password: $'
invalid_msg DB 10, 13, 'Invalid. No account found. Exiting...$'
success_msg DB 10, 13, 'Account created successfully! You can now log in.$'
invalid_choice_msg DB 10, 13, 'Invalid choice. Please try again.$'
login_failed_msg DB 10, 13, 'Incorrect password. Please try again.$'
welcome_trivia_msg DB 10, 13, 'Welcome to Seham-Samira Trivia Game!$'

name_buffer DB 20, 0, 20 DUP(0)
password_buffer DB 20, 0, 20 DUP(0)
stored_password DB 20, 0, 20 DUP(0)

; Data section from 2nd code
MSG1 DB '*************************************************$'
MSG2 DB 10,13,10,13,'Basic Mathematics Quiz$'
MSG3 DB 10,13,'Press Enter to start the quiz : $'
MSG4 DB 10,13,'Enter your answer : $'
MSG5 DB 10,13,'Correct.$'
MSG6 DB 10,13,'Wrong.$'
MSG7 DB 10,13,'You have successfully completed the quiz.$'
MSG8 DB 10,13,'You scored : $'
MSG9 DB 10,13,'Execellent, You completed the quiz with a perfect score: 10/10.$'
MSG10 DB 10,13,'   ***Thank you for participating in the quiz.! ***$'  

Q DB ?, '. '
OPRD1 DB ?, '+'
OPRD2 DB ?, '=?$'
OPTS DB '   a) '
OPT1 DB ?,'    b) '
OPT2 DB ?,'    c) '
OPT3 DB ?,'$'
LP DB 10
DIGIT1 DB ?
DIGIT2 DB ?
SUM DB ?
COUNT DB '0'
CRCTOPT DB ?


.CODE

; Code section from 1st code
MAIN PROC
    ; Initialize the data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Execute 1st code
    CALL FirstProgram

    ; Transition to 2nd code
    CALL SecondProgram

    ; Exit program
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

; Subroutine for the 1st code
FirstProgram PROC
    ; Welcome message
    MOV DX, OFFSET welcome_msg
    MOV AH, 09h
    INT 21h

    ; Ask for name
    MOV DX, OFFSET name_prompt
    MOV AH, 09h
    INT 21h

    ; Input name
    MOV AH, 0Ah
    LEA DX, name_buffer
    INT 21h

    ; Display account options
account_options:
    MOV DX, OFFSET account_msg
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h
    CMP AL, '1'        ; Check if user pressed 1 for "Yes"
    JE has_account
    CMP AL, '2'        ; Check if user pressed 2 for "No"
    JE create_account
    JMP invalid_choice

has_account:
    ; Simulate checking for account existence (password check)
    MOV DX, OFFSET enter_password
    MOV AH, 09h
    INT 21h

    MOV AH, 0Ah
    LEA DX, password_buffer
    INT 21h

    ; Compare entered password with stored password
    LEA SI, stored_password
    LEA DI, password_buffer + 2  ; Skip the length byte of password_buffer

    ; Compare each byte of the password
    MOV CX, 20  ; Max length for password (20 chars)
    CLD
    REPE CMPSB
    JZ login_success  ; If passwords match, jump to login success

    ; If passwords do not match
    MOV DX, OFFSET login_failed_msg
    MOV AH, 09h
    INT 21h
    RET

create_account:
    ; Account creation
    MOV DX, OFFSET new_password
    MOV AH, 09h
    INT 21h

    MOV AH, 0Ah
    LEA DX, password_buffer
    INT 21h

    ; Store the entered password in stored_password
    LEA SI, stored_password
    LEA DI, password_buffer + 2  ; Skip the length byte of password_buffer

    MOV CX, 20  ; Max length for password (20 chars)
    CLD
    REPE MOVSB  ; Copy the password to the stored_password buffer

    MOV DX, OFFSET success_msg
    MOV AH, 09h
    INT 21h
    JMP account_options

invalid_choice:
    MOV DX, OFFSET invalid_choice_msg
    MOV AH, 09h
    INT 21h
    JMP account_options

login_success:
    ; Successfully logged in, display welcome message
    MOV DX, OFFSET welcome_trivia_msg
    MOV AH, 09h
    INT 21h

    ; End the program after successful login
    RET
FirstProgram ENDP

RANDDIGIT MACRO RANGE 
    MOV AH, 00h  ;        
    INT 1AH      ; 
            
    MOV AX, DX
    XOR DX, DX   ;
    MOV CX, RANGE  
    DIV CX       ; 

    ADD DL, '0'
ENDM    

NL MACRO
    
    MOV AH,2
	MOV DL, 0AH
	INT 21H   
    MOV DL, 0DH
    INT 21H

ENDM    


; Subroutine for the 2nd code
SecondProgram PROC
    ; Display quiz introduction
    LEA DX, MSG1
    MOV AH, 09h
    INT 21h

    LEA DX, MSG2
    MOV AH, 09h
    INT 21h

    LEA DX, MSG3
    MOV AH, 09h
    INT 21h

    ; Wait for Enter key
    WAIT_FOR_ENTER:
        MOV AH, 01h
        INT 21h
        CMP AL, 0Dh
        JNE WAIT_FOR_ENTER

    ; Proceed with quiz logic
    ; (Contents of the 2nd code go here, adapted as needed)
    ; ...  
    QUES:
         MOV AH, 2      
         MOV DL, 0AH    
         INT 21H
         MOV DL, 0DH    
         INT 21H
          
        MOV AH, 2      
        MOV DL, 0AH    
        INT 21H
        MOV DL, 0DH    
        INT 21H


        
        
        CMP BL, 58 
        JNE NOT_TEN 
        
        
        MOV SI, OFFSET Q
        MOV [SI], '01'   
        JMP RANDOM_OPERANDS
        
        
        NOT_TEN:
        MOV SI, OFFSET Q
        MOV [SI], BL
        

        INC BL
        
        RANDOM_OPERANDS:

        MOV SI, OFFSET OPRD1
        RANDDIGIT 6
        MOV [SI], DL
        MOV DIGIT1, DL

        MOV SI, OFFSET OPRD2
        RANDDIGIT 5
        MOV [SI], DL
        MOV DIGIT2, DL

        XOR AL, AL
        ADD AL, DIGIT1
        ADD AL, DIGIT2
        MOV SUM, AL
        SUB SUM, 48

        LEA DX,Q
        MOV AH,9
        INT 21H
        
        MOV AH, 2      
        MOV DL, 0AH    
        INT 21H
        MOV DL, 0DH    
        INT 21H

        RANDDIGIT 3
        MOV CRCTOPT, DL
        ADD CRCTOPT, 49    
       
        CMP CRCTOPT, 'a'
        JE OPTION1

        CMP CRCTOPT, 'b'
        JE OPTION2

        JMP OPTION3        
        

        OPTION1:
            
            MOV SI, OFFSET OPT1
            MOV DL, SUM
            MOV [SI], DL

            MOV SI, OFFSET OPT2
            RANDDIGIT 9
            CMP DL, SUM
            JE OPTION1
            MOV [SI], DL

            MOV SI, OFFSET OPT3
            RANDDIGIT 8
            CMP DL, SUM
            JE OPTION1
            MOV [SI], DL

        JMP OPTIONS
        OPTION2:

            MOV SI, OFFSET OPT1
            RANDDIGIT 9
            CMP DL, SUM
            JE OPTION2
            MOV [SI], DL

            MOV SI, OFFSET OPT2
            MOV DL, SUM
            MOV [SI], DL

            MOV SI, OFFSET OPT3
            RANDDIGIT 8
            CMP DL, SUM
            JE OPTION2
            MOV [SI], DL


        JMP OPTIONS
        OPTION3:

            MOV SI, OFFSET OPT1
            RANDDIGIT 9
            CMP DL, SUM
            JE OPTION3
            MOV [SI], DL

            MOV SI, OFFSET OPT2
            RANDDIGIT 8
            CMP DL, SUM
            JE OPTION3
            MOV [SI], DL

            MOV SI, OFFSET OPT3
            MOV DL, SUM
            MOV [SI], DL

        OPTIONS:

            LEA DX,OPTS
            MOV AH,9
            INT 21H

            MOV AH, 2      
            MOV DL, 0AH    
            INT 21H
            MOV DL, 0DH    
            INT 21H

            

            LEA DX, MSG4
            MOV AH, 9
            INT 21H

            MOV AH, 1
            INT 21H

            CMP CRCTOPT, AL
            JE CORRECT

            
            MOV AH, 2      
            MOV DL, 0AH    
            INT 21H
            MOV DL, 0DH    
            INT 21H
            LEA DX, MSG6
            MOV AH, 9
            INT 21H
            DEC LP
            JZ FINISHED
            JMP QUES
            
        
        CORRECT:
            
            MOV AH, 2      
            MOV DL, 0AH    
            INT 21H
            MOV DL, 0DH    
            INT 21H
            INC COUNT
            LEA DX, MSG5
            MOV AH, 9
            INT 21H

        DEC LP
    JZ FINISHED
    JMP QUES


    FINISHED:

        MOV AH, 2      
        MOV DL, 0AH    
        INT 21H
        MOV DL, 0DH    
        INT 21H
        LEA DX, MSG7
        MOV AH, 9
        INT 21H 
        
        CMP COUNT,58
        JE WINNER
 
         MOV AH, 2      
         MOV DL, 0AH    
         INT 21H
         MOV DL, 0DH    
         INT 21H
        LEA DX, MSG8
        MOV AH, 9
        INT 21H

        MOV DL, COUNT
        MOV AH, 2
        INT 21H  
        
        JMP THANKYOU
        
        WINNER:    
        
            MOV AH, 2      
            MOV DL, 0AH    
            INT 21H
            MOV DL, 0DH    
            INT 21H           
            LEA DX, MSG9
            MOV AH, 9
            INT 21H 
            
        THANKYOU:
              
            MOV AH, 2      
            MOV DL, 0AH    
            INT 21H
            MOV DL, 0DH    
            INT 21H
            LEA DX, MSG10  
            MOV AH, 9
            INT 21H           

        MOV AH, 4CH
        INT 21H

;MAIN ENDP
    ;END MAIN    



    RET
SecondProgram ENDP

END MAIN

