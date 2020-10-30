;PABLO ANDRES ARGUETA HERNANDEZ,201800464
include epro.asm
.model small
.stack 
.data
menu db 10,13,'1) INGRESAR',10,13,'2) REGISTRAR',10,13,'3) SALIR',10,13,'Entrada:$'
menu2 db 10,13,'1) TOP 10 puntos',10,13,'2) TOP 10 tiempo',10,13,'3) SALIR',10,13,'Entrada:$'
menu3 db 10,13,'1) BubbleSort',10,13,'2) QuickSort',10,13,'3) ShellSort',10,13,'4) SALIR',10,13,'Entrada:$'
noEsparada db 10,13,'Entrada no esperada',10,13,'$'
repetido db 10,13,'EL usuario : ' ,'$'
yaenUso db ' YA ESTA EN USO',10,13,'$'
presiona32 db 10,13,'Presiona La barra espaciadora',10,13,'$'
form1 db 10,13,'User: ','$'
form2 db 10,13,'Pass: ','$'
bufNum db 7 dup('$'),'$'
lvlNum db 1 dup('$'),'$'
menos  db 10,13,'-','$'
ln db 10 ,13,'$'
once dw 1 dup('$'),'$'
;COMPARACION
aux_ db 20 dup('$'),'$'
zero db 1 dup('0'),'$'
idUser  db 1 dup('0'),'$'
idContra  db 1 dup('0'),'$'
;COMPARACION 
;login
lvl db 'LVL','$'
mIguales db 10,13, 'OK iguales','$'
buffUser  db 20 dup('$'),'$'
buffPass  db 20 dup('$'),'$'
ind dw 1 dup(0),'$'
usersIndex db 400 dup('$'),'$';20*20
passIndex db 400 dup('$'),'$'
si_2 dw 1 dup(0),'$'
noEsId db 10,13, 'NUEVO USUARIO OK' ,10 ,13,'$'
No_reg db 10,13, 'usuario no registrado' ,10 ,13,'$'
logIN_ db 10,13, '** LOGIN **' ,10 ,13,'$'
okReg db 10,13, 'OK REGISTRADO..' ,10 ,13,'$'
linea db 10,13, '--' ,10 ,13,'$'
okLogeo db 10,13, 'ACCESO PERMITIDO' ,10 ,13,'$'
passOnlyNum db 10,13, 'SOLO SE ACEPTAN NUMEROS EN EL PASSWORD' ,10 ,13,'$'
bienvenida db 10,13,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',10,13,'FACULTAD DE INGENIERIA',10,13,'CIENCIAS Y SISTEMAS',10,13,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1',10,13,'PABLO ANDRES ARGUETA HERNANDEZ',10,13,'201800464',10,13,'SECCION B',10,13,'$' ; databyte porque el ascii va de 0 a 255  el $ indica hasta donde tiene que imprimir
contpp dw 0
BarraInicio dw 1 dup('0'),'$'
vel dw 0  
pelota STRUCT
    estado db 0 ; solo llega hasta el numero 3h 
    x dw 0
    y dw 0
pelota ENDS
pelota1 pelota<'0','0','0'>
pelota2 pelota<'0','0','0'>
pelota3 pelota<'0','0','0'>
Barra STRUCT
    y dw 0
    len dw 0
    px db 0
Barra ENDS
barr Barra<'0','0','0'>
ptsActuales db 0 
lev db 0 
PUNTAJES db 25 dup('$'),'$'
indPuntajes dw 0
burbuja db 10 dup('$'),'$'
time dw 0
;login
.code
leerChar
moverArrobaDS
    limpiaArr usersIndex , sizeOF usersIndex , 36
    limpiaArr passIndex , sizeOF passIndex , 36 
    InitPassAdmin
menuPrincipal:
    activaModoTexto
    pp bienvenida

     call JUGAR

inicio:
    xor ax,ax
    pp menu
    leerChar
    cmp al,49
    JE ingresar
    cmp al,50
    JE registrar
    cmp al,51
    JE salirGlobal
    pp noEsparada
    jmp inicio
;subRutinas
cursor proc ;dh = fila , dl = col 
MOV ah,02h
MOV bh,0
int 10h  
RET
cursor endp
ppBarra proc 
push ax 
push bx 
    getPos 180,barr.y
    MOV dl,barr.px;color
    MOV ax,si
    add ax,barr.len
    cic:
    MOV es:[si],dl
        mov cx,5
        mov bx,si
        rell:
        MOV es:[bx],dl
        add bx,320
        loop rell
    inc si
    cmp si,ax
    JNE cic
pop bx
pop ax 
RET
ppBarra endP
moveBarraD PROC
    mov ax,barr.y
    add ax,4
    cmp ax,215
    JAE exD 
    MOV barr.px,0
    call ppBarra
    add barr.y,4
    MOV barr.px,14
    call ppBarra 
    exD:
RET
moveBarraD ENDP

moveBarraI PROC
    mov ax,barr.y
    sub ax,4
    cmp ax,5
    JBE exD 
    MOV barr.px,0
    call ppBarra 
    sub barr.y,4
    MOV barr.px,14
    call ppBarra 
    exD:
RET  
moveBarraI ENDP
pausar PROC
    MOV ah,11h
    int 16h
    JZ nadaG
    ; pregunta estado buffer 
    xor ax,ax
    MOV ah,00
    int 16h 
    cmp al,1bH;esc
    JE salidaG
    cmp al,32
    JE menuPrincipal 
    JMP nadaG
    salidaG:
    mov si,0 
    nadaG:
RET  
pausar ENDP
ppMargen PROC; formula 320*i+j = (i,j)  0 a 319 y de 0 a 199 
    MOV dl,95D;color
    MOV di,6405;(20,5) 
    arriba:
    MOV es:[di],dl
    inc di
    cmp di,6714;(20,314)
    JNE arriba
    MOV di,60805;(190,5)
    abajo:
    MOV es:[di],dl
    inc di
    cmp di,61115;(190,315)
    JNE abajo
    MOV di,6405;(20,5)
    izquierda:
    MOV es:[di],dl
    add di,320 ;salta de fila 
    cmp di,60805;(190,5)
    JNE izquierda
    MOV di,6714;(20,314)
    derecha:
    MOV es:[di],dl
    add di,320;salta de fila 
    cmp di,61114;(190,314)
    JNE derecha
RET
ppMargen ENDP
limpiarP PROC  
MOV dl,0h
MOV di,32006;(100,6) 
lim:
MOV es:[di],dl
inc di 
cmp di,61112;(190,312)
JBE lim
call ppMargen
RET
limpiarP ENDP
reP1 PROC
MOV pelota1.x,150
MOV pelota1.y,280
MOV pelota1.estado,1
RET   
reP1 ENDP
reP2 PROC
MOV pelota2.x,150
MOV pelota2.y,280
MOV pelota2.estado,5;sin mov
RET   
reP2 ENDP
reP3 PROC
MOV pelota3.x,150
MOV pelota3.y,200
MOV pelota3.estado,5;sin mov
RET   
reP3 ENDP
ModoTieso proc
getPos pelota1.x,pelota1.y
pintarBall si,4
wait_:
    xor ax,ax
    MOV ah,11h
    int 16h
    JZ nada
    xor ax,ax
    MOV ah,00
    int 16h 
    cmp al,32;esc
    JE sal_
    nada:
JMP wait_
sal_:
RET
ModoTieso endP

letrerolvl proc ; di
        MOV dh,1
        MOV dl,10    
        CALL cursor
        xor ax,ax
        MOV al,lev[0]
        add al,48
        MOV lvlNum[0],al
        MOV lvlNum[1],'$'
        pp lvl
        pp lvlNum
RET
letrerolvl endP
letreroPuntos proc 
        MOV dh,1
        MOV dl,20  
        CALL cursor
        xor ax,ax
        mov AL,ptsActuales  
        call ppNum
RET
letreroPuntos endP
letreroUser proc 
        MOV dh,1
        MOV dl,1  
        CALL cursor
        pp buffUser
RET
letreroUser endP
letrerotime proc 
        MOV dh,1
        MOV dl,30  
        CALL cursor
        MOV ax,time
        CALL ppNum 
RET
letrerotime endP

JUGAR PROC 
        activarModoVideo
        mov time,0
        MOV once,0
        MOV ptsActuales,0
        CALL letreroPuntos
        call letreroUser
        call letrerotime
        call ppMargen 
        call bloNivel1
        MOV barr.y,160
        MOV barr.len,100
        MOV barr.px,14
        call ppBarra
        MOV vel,220;220
        call reP1
        MOV pelota1.y,130;Rapido
        call ModoTieso
        encicla:
            inc time
            call letrerotime
            subMenu
            delay               vel 
            verificaState       pelota1
        cmp lev,2
        JAE l2
        JMP con
            l2:
            verificaState       pelota2
        cmp lev,3
        JAE l3
        JMP con
            l3: 
            verificaState       pelota3
            con:  
        jmp encicla
        END_GAME:
        leerChar
        activaModoTexto
        MOV si,indPuntajes
       ; MOV PUNTAJES[si],
        INC indPuntajes
RET
JUGAR ENDP

bloNivel1 PROC
    MOV lev,1
    CALL letrerolvl
    MOV bx,22
    call ppBloques
    MOV bx,36
    call ppBloques 
    RET
bloNivel1 ENDP

bloNivel2 PROC
    call bloNivel1
    MOV vel,185;185
    MOV lev,2
    call reP1
    MOV pelota2.estado,5
    call reP2
    MOV bx,50
    call ppBloques 
    call letrerolvl
RET
bloNivel2 ENDP
bloNivel3 PROC
    call bloNivel2
    MOV vel,160;175
    MOV lev,3
    call reP1
    call reP2
    call reP3
    MOV bx,64
    call ppBloques
    call letrerolvl
RET
bloNivel3 ENDP
ppBloques PROC 
push di
PUSH si 
    xor ax,ax
    xor si,si
    getPos bx,6
    MOV dl,5 ;color 
    MOV ax,si
    add ax,305
        MOV contpp,si;reset
        MOV di,contpp
        add di,59
        c__:
        mov cx,8
        mov bx,si
        fill:
        MOV es:[bx],dl
        add bx,320
        loop fill
        inc si
        inc contpp
        cmp contpp,di
        JE  space
        cmp si,ax
        JNE c__
        JMP e_
space:
        add si,3
        MOV contpp,si;reset
        MOV di,contpp
        add di,59
        inc dl
JMP c__
e_:
pop si 
pop di
RET 
ppBloques endp

ppClearBlock proc
    push bx 
    push ax
    PUSH si 
        xor ax,ax
        xor si,si
        MOV dl,0h ;color 
        getPos bx,di;x,y
        MOV ax,si
        add ax,59
            c_:
            mov cx,8
            mov bx,si
            r_:
            MOV es:[bx],dl
            add bx,320
            loop r_
            inc si
            cmp si,ax
            JNE c_
    pop si 
    pop ax
    pop bx 
RET
ppClearBlock endP
ppNum proc ;AX= 16 bits sino xor ah,ah y al = 8bits
limpiaArr bufNum,sizeOF bufNum,36
PUSH dx
PUSH ax
PUSH bx
PUSH SI
   xor si,si
   buc:
   MOV bx,10
   xor dx,dx
   DIV bx
   add dx,48
   push dx ;guardo residuo 
        inc si
        cmp ax,0
   JNZ buc
   MOV cx,si
   xor si,si 
   i2:
        pop dx
        MOV bufNum[si],dl 
        inc si 
   loop i2
   pp bufNum
POP si
pop bx 
POP ax 
pop dx 
RET
ppNum endP 
;subRutinas-fin
ingresar:
    limpiaArr buffUser , sizeOF buffUser , 36
    limpiaArr buffPass , sizeOF buffPass , 36 
    MOV zero[0],0

    pp logIN_
    pp form1 
    getCadena  buffUser

    buscaCadena buffUser,usersIndex, idUser
    cmp zero[0],0
    JE ingresar
    pp form2
    getCadena  buffPass
    buscaCadena buffPass,passIndex ,idContra
    MOV bl,idContra[0]
    cmp idUser[0],bl
    JNE ingresar
    limpiaArr aux_ , sizeOF aux_ , 36
    MOV zero[0],0
    fillAdmin aux_
    compare buffUser
    CMP zero[0],1
    JE soyAdmin
    pp okLogeo
;=======================
    call JUGAR
;======================

    JMP inicio
    soyAdmin:
    Mmenu2 
    pp linea
    jmp inicio
registrar:
    limpiaArr buffUser , sizeOF buffUser , 36
    limpiaArr buffPass , sizeOF buffPass , 36  
    MOV zero[0],0
    pp ln
    pp form1 
    getCadena  buffUser 
    UserNoRep buffUser,usersIndex 
    
pedirPass:
    pp form2
    getCadena  buffPass
    validarPass buffPass
    saveCadena  buffPass,passIndex
    inc ind[0]
    pp linea
    pp okReg
    pp linea
JMP inicio
salirGlobal:
    MOV AH, 4CH
    int 21h ;fin
end
