;PABLO ANDRES ARGUETA HERNANDEZ,201800464
include epro.asm
.model small
.stack 
.data
menu db 10,13,'1) INGRESAR',10,13,'2) REGISTRAR',10,13,'3) SALIR',10,13,'Entrada:$'
noEsparada db 10,13,'Entrada no esperada',10,13,'$'
repetido db 10,13,'EL usuario : ' ,'$'
yaenUso db ' YA ESTA EN USO',10,13,'$'
form1 db 10,13,'User: ','$'
form2 db 10,13,'Pass: ','$'
resultados dw 20 dup('$'),'$'
menos  db 10,13,'-','$'
ln db 10 ,13,'$'
once dw 1 dup('$'),'$'
burbuja db 5 dup('$'),'$'
;COMPARACION
aux_ db 20 dup('$'),'$'
zero db 1 dup('0'),'$'
idUser  db 1 dup('0'),'$'
idContra  db 1 dup('0'),'$'
;COMPARACION 
;login
mIguales db 10,13, 'OK iguales','$'
buffUser  db 20 dup('$'),'$'
buffPass  db 20 dup('$'),'$'
ind dw 1 dup(0),'$';indice ids-results
usersIndex db 300 dup('$'),'$';15*20
passIndex db 300 dup('$'),'$';15*20
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
pelota1 pelota<'0','0','1'>
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
ppBarra proc 
push ax 
push bx 
    getPos 180,barr.y
    MOV dl,barr.px;color
    MOV ax,si
    add ax,barr.len
    cic:
    MOV [si],dl
        mov cx,5
        mov bx,si
        rell:
        MOV [bx],dl
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
RET
ppMargen ENDP
limpiarP PROC  
MOV dl,0h
MOV di,32006;(100,6) 
lim:
MOV [di],dl
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
JUGAR PROC 
        MOV once,0
        MOV ptsActuales,0
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
RET
JUGAR ENDP

bloNivel1 PROC
    MOV lev,1
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
        MOV [bx],dl
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
            MOV [bx],dl
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
    pp okLogeo
;=======================
    activarModoVideo
    call JUGAR
    activaModoTexto
;======================
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
