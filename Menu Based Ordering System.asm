.model small
.stack 100h
.data

    m0 db "        == WELCOME IN MY PROJECT ==$"
    m1 db 10,13,10, "Which menu do you want ??please select:$"
    m2 db 10,13,10,13, "1.Rice 100/- 2.Vegetable 50/- 3.Soup 20/- $"
    m3 db 10,13,10,13, "Select the menu number:$"
    m8 db 10,13,10,13, "SORRY!!!There is no more than 3 item,if u want,u can add one$"
    m9 db 10,13,10,13, "Enter Food name:$"
    m10 db 10,13,10,13,"          Price:$" 
    m4 db 10,13,10,13, "To add press 1 or press 2 to get back menu :$"
    m5 db 10,13,10,13, "Enter quantity:$" 
    m6 db 10,13,10,13, "Total price: $"
    m7 db 10,13,10,13, "      *****THANK YOU*****$"
    m11 db "4.$"  
    m12 db "/-$" 
    m13 db 10,13,10,13, " Re-odrer : Press <1>$",
    m14 db 10,13,10,13, " Exit : Press Any key$" 
   v db 0
    rprice db 100
    vprice db 50
    sprice db 20
    nprice dw 0
    
    var1 db 100 dup('$')
    
.code
    main proc
        
        mov ax,@data
        mov ds,ax
        
        mov ah,9
        Lea dx,m0
        int 21h  
        
        start:
        cmp v,0
        jg start1
        
        mov ah,9
        Lea dx,m1
        int 21h
        
        menu:
        
        mov ah,9
        Lea dx,m2
        int 21h
        
        mov ah,9
        Lea dx,m3
        int 21h
        
        mov ah,1
        int 21h        
        
        cmp al,31h
        je rice_
        cmp al,32h
        je veg_
        cmp al,33h
        je soup_
         
        
        
        menuadd:
        inc v
        
        mov ah,9
        Lea dx,m8
        int 21h 
        
        mov ah,9
        Lea dx,m4
        int 21h
        
        mov ah,1
        int 21h
        cmp al,32h
        je menu
                
        mov ah,9
        Lea dx,m9
        int 21h
        
        mov si,offset var1
        
        l1:
        mov ah,1
        int 21h
        cmp al,13
        je print
        mov [si],al
        inc si
        jmp l1
        
        print: 
        
        call price
        
        start1:
        
        mov ah,9
        Lea dx,m2
        int 21h
        
        mov ah,9
        Lea dx,m11
        int 21h  
        
        mov dx,offset var1
        mov ah,9
        int 21h
        
        mov ah,2
        mov dl,' '
        int 21h 
        
        xor ax,ax   
        mov ax,nprice
        call outdec
        
        mov ah,9
        Lea dx,m12
        int 21h 
        
        
        
        mov ah,9
        Lea dx,m3
        int 21h
        
        mov ah,1
        int 21h        
        
        cmp al,31h
        je rice_
        cmp al,32h
        je veg_
        cmp al,33h
        je soup_
        
        newmenu_:
        
            mov ah,9
            Lea dx,m5
            int 21h
            
            xor ax,ax            
            
            call indec
    
            mul nprice
            
            mov bx,ax
            
            jmp totalprice
         
        
        veg_:
        
            mov ah,9
            Lea dx,m5
            int 21h
            
            xor ax,ax            
            
            call indec
    
            mul vprice
            
            mov bx,ax
            
            jmp totalprice
        
        rice_:
        
            mov ah,9
            Lea dx,m5
            int 21h 
            
            xor ax,ax
            
            call indec
            
            mul rprice 
            
            mov bx,ax
            
            jmp totalprice 
            
        soup_:    
            mov ah,9
            Lea dx,m5
            int 21h 
            
            xor ax,ax
            
            call indec
           
            mul sprice
            
            mov bx,ax
            
            jmp totalprice 
            
        price:
        
            mov ah,9
            Lea dx,m10
            int 21h  
            
            mov ax,0
             mov bx,0
              mov cx,0
               mov dx,0
            
            input:
                and ax,000Fh
                push ax
                mov ax,10
                mul bx
                mov bx,ax
                pop ax
                add bx,ax
                
                mov ah,1
                int 21h
                
                cmp al,0Dh
                jne input
                
            add nprice,bx
            ret
               
            
            
        totalprice:
         
            mov ah,9
            Lea dx,m6
            int 21h 
            
            xor ax,ax
            
            
            mov ax,bx
            call outdec
            
            mov ah,9
            Lea dx,m13
            int 21h
            
            mov ah,9
            Lea dx,m14
            int 21h
            
            mov ah,1
            int 21h
            
            cmp al,31h
            je start
            
            mov ah,9
            Lea dx,m7
            int 21h
        
        
        mov ah,4ch
        int 21h
        
        main endp

OUTDEC proc
    
PUSH  AX
PUSH  BX
PUSH  CX
PUSH  DX

OR AX, AX
JGE @END_IF1

PUSH AX
MOV DL, ' '
MOV AH, 2
INT 21H
POP AX
NEG AX

@END_IF1:

    XOR CX, CX
    MOV  BX, 10D

@REPEAT1: 

    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX


    OR  AX, AX
    JNE   @REPEAT1
    
    MOV   AH, 2

@PRINT_LOOP:

   POP  DX
   OR DL, 30H
   INT 21H
   LOOP  @PRINT_LOOP

   POP DX
   POP CX
   POP BX
   POP AX

RET
OUTDEC ENDP 




INDEC PROC 

@BEGIN:

MOV AH, 2
MOV DL, ' '
INT 21H

XOR BX, BX
XOR CX, CX

MOV AH, 1
INT 21H

CMP AL, '-'
JE @MINUS

CMP AL, '+'
JE @PLUS
JMP @REPEAT2

@MINUS:
MOV CX, 1
@PLUS:
INT 21H

@REPEAT2:

AND AX, 000FH
PUSH AX

MOV AX,10
MUL BX
POP BX
ADD BX, AX

MOV AH, 1
INT 21H
CMP AL, 0DH
JE @REPEAT2

MOV AX, BX
OR CX, CX


@EXIT:

RET

@NOT_DIGIT:

MOV AH, 2
MOV DL, 0DH
INT 21H
MOV DL, 0AH
INT 21H
JMP @BEGIN
INDEC ENDP 

    end main