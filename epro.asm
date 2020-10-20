ppChar MACRO  dl_
MOV ah,06h
MOV dl , dl_
int 21h
endM 
pp MACRO cad
PUSH ax 
PUSH dx    
    MOV ah , 09h 
    MOV dx , offset cad
    int 21h
POP dx
POP ax  
endM
leerChar MACRO 
    MOV ah, 01h
    int 21h;la ejecuto 
endM 
moverArrobaDS MACRO
    MOV dx , @data 
    MOV ds , dx 
endM
limpiaArr MACRO arreglo ,  len , charClean
LOCAL bucle 
    PUSH bx 
    PUSH cx 
    xor cx , cx
    xor bx,bx
    MOV cx, len
    bucle:
        MOV arreglo[bx],charClean
        inc bx 
        loop bucle
    pop cx 
    pop bx 
endM 
getCadena MACRO arrayLlenador 
LOCAL obtenerCaracter ,  finSalida , del_
    MOV si,0
    obtenerCaracter:
    leerChar
    CMP al , 127;tecla eliminar 
    JE del_
    CMP al,0dh;ascii de salto de linea
    JE finSalida
    MOV arrayLlenador[si] , al 
    INC si
    JMP obtenerCaracter
    del_:
        MOV al , 24h
        DEC si
        MOV arrayLlenador[si] , al 
        JMP obtenerCaracter    
    finSalida:
        MOV al , 24h 
        MOV arrayLlenador[si],al
endM
getPorID MACRO  ID__ , vector ; OPTIMIZAR 
        LOCAL t1,ex,c2
        PUSH cx
        PUSH ax
        PUSH bx
        push si 
        limpiaArr aux_,sizeOf aux_,36
        XOR cx,cx
        MOV si,ID__
        cmp ID__,0
        JE c2
        xor ah,ah ; limpio
        mov al,20   
        mul si ;el resultado se guarda en al
        MOV si,ax
        sub si,1
        xor bx,bx
        mov cx,20;len
        c2:
            MOV al,vector[si]
            MOV aux_[bx],al
            inc si 
            inc bx 
            cmp vector[si],36
            JE ex
        loop c2
        ex:
        pop si 
        POP bx 
        POP ax
        POP cx 
endm
buscaCadena MACRO auxDef , vector , var;me interesa obtener el numero
        LOCAL buscando,No_ig,comparando,ex,igualdad
        xor bx,bx
        MOV si_2[0],0
        buscando:
            getPorID si_2[0],vector
            comparando:
            compare auxDef
            cmp zero[0],1
            JE igualdad
            cmp si_2[0],20;sale si llega al ultimo
            JE No_ig
            INC si_2[0]
            JMP buscando
        No_ig:
        pp No_reg
        igualdad:
        MOV bx, si_2[0]
        xor bh,bh
        MOV var[0],bl

endM
UserNoRep MACRO auxDef , vector;NO REPETIDOS VALIDACION
        LOCAL buscando,No_ig,comparando,ex,igualdad
        xor bx,bx
        MOV si_2[0],0
        buscando:
            getPorID si_2[0],vector
            comparando:
            compare auxDef
            cmp zero[0],1
            JE igualdad
            cmp si_2[0],20;sale si llega al ultimo
            JE No_ig
            INC si_2[0]
            JMP buscando
        No_ig:
        saveCadena  auxDef,vector
        JMP ex
        igualdad:
        pp repetido
        pp aux_
        pp yaenUso
        JMP registrar;esta afuera de mi MACRO 
        ex:  
endM
saveCadena macro auxDef,vectorG
    LOCAL compara,outSave
        push SI
        xor ah,ah ; limpio
        xor si,si
        xor bx,bx
        MOV si,ind[0]
        cmp ind[0],0
        JE compara
        mov al,20
        mul si ; el resultado se guarda en al
        MOV si,ax;asigno
        sub si,1
        compara:
            MOV al,auxDef[bx]
            MOV vectorG[si],al
            cmp auxDef[bx],36
            JE outSave 
            inc si
            inc bx
        JMP compara
        outSave:
        POP SI 
endM
compare MACRO auxDef ;aux_ vs auxDef  iguales Zero = 1  
    LOCAL buck,igual ,exitCom,noIgual
    push si 
    push cx
    xor si,si
    xor cx,cx
    mov cx,20
        buck:
        MOV dl, aux_[si]
        cmp auxDef[si],dl
        JNE noIgual  
        inc si 
        loop buck
    igual:
    MOV zero[0],1
    JMP exitCom
    noIgual:
    MOV zero[0],0
    exitCom:
    pop cx
    pop si
endM 

ppPixel macro x,y,COLOR
    push cx
    MOV ah,0ch; funcion 0ch pinta pixel
    MOV al,COLOR
    MOV bh,0
    MOV dx,y
    MOV cx,x
    int 10h
    pop cx
endM

InitPassAdmin MACRO
;usuario = admin<Sección>P, contraseña = 1234

limpiaArr buffUser , sizeOF buffUser , 36
limpiaArr buffPass , sizeOF buffPass , 36  
MOV buffUser[0], 97;a 
MOV buffUser[1], 64h;d
MOV buffUser[2], 6Dh;m
MOV buffUser[3], 69h;i
MOV buffUser[4], 6Eh;n
MOV buffUser[5], 62h;b
MOV buffUser[6], 70h;p
saveCadena  buffUser,usersIndex
MOV buffPass[0],31h;1
MOV buffPass[1],32h;2
MOV buffPass[2],33h;3
MOV buffPass[3],34h;4
saveCadena  buffPass,passIndex
pp usersIndex[0]
pp passIndex[0]
INC ind[0]
endM