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
pp linea 
pp usersIndex[0]
pp ln 
pp passIndex[0]
pp linea 
INC ind[0]
endM
activarModoVideo MACRO
    MOV ax,13h
    int 10h 
    mov ax,0A000h
    MOV ds,ax; DS=A000h activa mem grafics
endM  
activaModoTexto macro
MOV ax,03h
int 10h 
moverArrobaDS
endM

ppMargen MACRO color ; formula 320*i+j = (i,j)  0 a 319 y de 0 a 199 
LOCAL arriba,abajo,izquierda,derecha
MOV dl,color

MOV di,6405;(20,5) 
arriba:
MOV [di],dl
inc di
cmp di,6714;(20,314)
JNE arriba

MOV di,60805;(190,5)
abajo:
MOV [di],dl
inc di
cmp di,61115;(190,315)
JNE abajo


MOV di,6405;(20,5)
izquierda:
MOV [di],dl
add di,320 ;salta de fila 
cmp di,60805;(190,5)
JNE izquierda

MOV di,6714;(20,314)
derecha:
MOV [di],dl
add di,320;salta de fila 
cmp di,61114;(190,314)
JNE derecha
endM

pintarBall macro pos,color
push dx
MOV di,pos
MOV dl,color
MOV [di],dl
pop dx
endM 

delay macro valor 
LOCAL r1_,r2_,ex
push di
push si
MOV si,valor
r1_:
    dec si
    JZ ex
    mov di,valor
    r2_:
    dec di
    JNZ r2_
    JMP r1_
ex:     
pop si 
pop di 
endm 

validarPass macro entrada
local recorre,ex,error_,v1_,v2_
push si
xor si,si 
recorre:
cmp entrada[si],36
JE ex
cmp entrada[si],48;0
JAE v1_
JMP error_
        v1_:
            cmp entrada[si],57
            JBE v2_
            JMP error_
v2_:
inc si 
JMP recorre
error_:
pp passOnlyNum
JMP pedirPass
ex:
pop si 
endM 

ppBloques macro x,y
LOCAL ciclo,space,ex,rellena
push bx 
push ax
PUSH si 
    xor ax,ax
    xor si,si
    MOV dl,5 ;color 
    getPos x,y
    MOV ax,si
    add ax,305
        MOV contpp,si;reset
        MOV di,contpp
        add di,59
        ciclo:
        mov cx,8
        mov bx,si
        rellena:
        MOV [bx],dl
        add bx,320
        loop rellena
        inc si
        inc contpp
        cmp contpp,di
        JE  space
        cmp si,ax
        JNE ciclo
        JMP ex
space:
        add si,3
        MOV contpp,si;reset
        MOV di,contpp
        add di,59
        inc dl
JMP ciclo
ex:
pop si 
pop ax
pop bx 
endM

ppBarra macro color 
LOCAL ciclo,rellena,lim
push ax 
push bx 
    
    getPos 180,barr.y; SIEMPRE ESTA EN 160
    MOV dl,color;color
    MOV ax,si
    add ax,barr.len
    ciclo:
    MOV [si],dl
        mov cx,5
        mov bx,si
        rellena:
        MOV [bx],dl
        add bx,320
        loop rellena
    inc si
    cmp si,ax;si+len,fin
    JNE ciclo

pop bx
pop ax 
endM
 
getPos  macro x,y;SI tiene le valor 
PUSH dx
push ax 
push bx
    MOV ax,320
    mov bx,x
    mul bx
    MOV si,ax;resultado de la mult
    ADD si,y
pop bx
pop ax
pop dx 
endM 

verificaState MACRO ball
LOCAL ex,Arriba_izq,Arriba_Der,Abajo_izq,Abajo_derecha,t1,t2,t3,t4 ,a1,a2,a3,a4
    cmp ball.estado,0
    JE Arriba_izq
    cmp ball.estado,1
    JE Arriba_Der
    cmp ball.estado,2
    JE Abajo_izq
    cmp ball.estado,3
    JE Abajo_derecha

    Arriba_izq:
          getPos ball.x,ball.y ; SALE EL VALOR EN EL SI
          pintarBall si,0 
          dec ball.x 
          dec ball.y
   revisarColor  ball.x , ball.y   
          cmp ball.y,6
          JBE t1
          cmp ball.x,21
          JBE t3
          jmp ex
          t1:
          mov ball.estado,1
          JMP ex
          t3:
          mov ball.estado,2
    JMP ex

    Arriba_Der:
          getPos ball.x,ball.y
          pintarBall si,0 
          dec ball.x;si decremento la fila voy para arriba 
          INC ball.y; voy para la derecha
revisarColor  ball.x , ball.y   
          cmp ball.y,312
          JAE t2
          cmp ball.x,21
          JBE t4
          JMP ex
          t2:
          MOV ball.estado,0
          JMP ex
          t4:
          MOV ball.estado,3
    JMP ex
    Abajo_izq: 
          getPos ball.x,ball.y
          pintarBall si,0 
          INC ball.x;para abajo 
          dec ball.y;IZQUIERDA
 revisarColor  ball.x , ball.y   
          cmp ball.y,6
          JBE a1
          cmp ball.x,189
          JAE a2
          JMP ex
          a1:
          MOV ball.estado,3  
          JMP ex
          a2:
          MOV ball.estado,0
    JMP ex
    Abajo_derecha:
          getPos ball.x,ball.y
          pintarBall si,0 
          INC ball.x ;para abajo 
          INC ball.y;derecha
revisarColor  ball.x , ball.y   
          cmp ball.y,312
          JAE a3
          cmp ball.x,189
          JAE a4
          JMP ex
          a3: 
          MOV ball.estado,2
          JMP ex
          a4: 
          MOV ball.estado,1
    JMP ex 
ex:     
getPos ball.x,ball.y
pintarBall si,12

endM

JUGAR MACRO ball 
        encicla:
            subMenu
            delay               vel 
            verificaState       ball  
        jmp encicla
endM 

revisarColor MACRO  x , y ;LA SALIDA AL
LOCAL ex,gris,rosa,naranja,blanco,azul
Push bx
push ax
    xor bx,bx
    xor ax,ax

    MOV DX,x;row-rev
    MOV CX,y;column-rev
    MOV ah,0Dh
    MOV bh,0
    int 10h
        CMP AL,5h
        JE rosa
        CMP AL,6h
        JE naranja
        CMP AL,7h
        JE blanco
        CMP AL,8h
        JE gris
        CMP AL,9h
        JE azul
    JMP ex
    rosa:
    MOV vel,100
    JMP ex
    naranja:
    MOV vel,600
    JMP ex
    blanco:
    MOV vel,200
    JMP ex
    gris:
    MOV vel,170
    JMP ex
    azul:
    MOV vel,500
    JMP ex
    ex:
pop ax
pop bx
endM 

subMenu MACRO
LOCAL der,izq,nada ,pausa
xor ax,ax 
    MOV ah,11h
    int 16h
    JZ nada
    ; pregunta estado buffer 
    xor ax,ax
    MOV ah,00
    int 16h  
    cmp al,1bH;esc
    JE pausa
    cmp al,'4'
    JE izq
    cmp al,'6'
    JE der
    JMP nada
    der:
        call moveBarraD
        JMP nada
    izq:
        call moveBarraI
        JMP nada
    pausa: 

nada:

endM 

