LeerArchivo MACRO Manejador , Array_A_llenar , numeroBytes_A_leer
LOCAL err , ok 
MOV ah , 3fh
MOV bx , Manejador
MOV cx , numeroBytes_A_leer
LEA dx , Array_A_llenar
int 21h 
JC err 
JMP ok 
err:
pp errorLectura
ok: 
endM
AbrirArchivo MACRO ruta , manejador
LOCAL ok , notOK
mov ah , 3dh 
mov al , 02h
LEA dx , ruta
int 21h
Jc notOK
mov manejador , ax 
JMP ok 
notOK:
    pp errorArchivo
ok:
endM
wr MACRO cade
    LOCAL err , ok 
    PUSH bx
    MOV AH,40h
    MOV BX,ManejadorRuta
    MOV CX,sizeOf cade
    LEA DX,cade
    int 21h
    JC err 
    JMP ok
    err: 
        pp errorArchivo
    ok: 
    pop bx 
endM
crearFichero MACRO ArrayName,Manejador,errorArchivo
  local err,salidaExito
  MOV AH , 3CH 
  MOV CX , 00h;fnormal
  LEA DX , ArrayName
  int 21h
  JC err
  MOV Manejador,ax
  JMP salidaExito
  err:
    pp errorArchivo
salidaExito:
endM
CerrarArchivo MACRO manejador
LOCAL ok , notOK
mov ah , 3eh
mov bx, manejador
int 21h 
JC notOK
JMP ok 
notOK:
    pp errorArchivo
ok:
endM
wrOk MACRO cade
    LOCAL contando,siCuenta,termino, err , ok 
PUSH cx
PUSH ax
PUSH bx 
PUSH si 
    contarCad cade
    MOV AH,40h
    MOV BX,ManejadorRuta
    MOV cx,contImp[0]
    LEA DX,cade
    int 21h
    JC err 
    JMP ok
    err: 
        pp errorArchivo
    ok:
pop si
POP bx 
pop ax 
pop cx
endM
contarCad MACRO cade
LOCAL contando,siCuenta,termino
    MOV contImp[0],0
    xor bx,bx
    contando:
        cmp cade[bx],36
        JNE siCuenta
        JE termino
        JMP contando
    siCuenta:
        inc contImp[0]
        inc bx
    JMP contando
    termino:
endM 


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

saveCadena macro buffUser,buffPass
    AbrirArchivo userstxt,ManejadorRuta
    limpiaArr bufferLector,sizeOF bufferLector,36
    LeerArchivo ManejadorRuta,bufferLector,SIZEOF bufferLector
    crearFichero userstxt,ManejadorRuta,errorArchivo
    wrOk bufferLector
    wrOk buffUser
    wr punto
    wrOk buffPass
    wr puntoC
CerrarArchivo ManejadorRuta
endM
saveEstadis macro
    AbrirArchivo estadistxt,ManejadorRuta
    limpiaArr bufferLector,sizeOF bufferLector,36
    LeerArchivo ManejadorRuta,bufferLector,SIZEOF bufferLector
    crearFichero estadistxt,ManejadorRuta,errorArchivo
    wrOk bufferLector
    wrOk buffUser
    wr punto
    xor ax,ax
    mov al,lev
    CALL ppArcNum 
    wr punto
    xor ax,ax
    MOV al,ptsActuales 
    CALL ppArcNum
    wr punto
    addMinutes
    CALL ppArcNum
    wr puntoC
CerrarArchivo ManejadorRuta
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


activarModoVideo MACRO
    MOV ax,13h
    int 10h 
    mov ax,0A000h
    MOV Es,ax; DS=A000h activa mem grafics
endM  
activaModoTexto macro
MOV ax,03h
int 10h 
endM
moverArrobaDS MACRO
    MOV dx , @data 
    MOV ds , dx 
endM


pintarBall macro pos,color
push dx
MOV di,pos
MOV dl,color
MOV es:[di],dl
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
    inc time
    call letrerotime    
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


validarPassLogin macro entrada
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
JMP PASS_LOGIN
ex:
pop si 
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
LOCAL ex,Arriba_izq,Arriba_Der,Abajo_izq,Abajo_derecha,t1,t2,t3,t4,a1,a2,a3,a4,nada,CLEAN
    cmp ptsActuales,45
    JE  END_GAME
    cmp ball.estado,0
    JE Arriba_izq
    cmp ball.estado,1
    JE Arriba_Der
    cmp ball.estado,2
    JE Abajo_izq
    cmp ball.estado,3
    JE Abajo_derecha
    CMP once,1
    JE CLEAN
    JMP nada
    Arriba_izq:
          getPos ball.x,ball.y ; SALE EL VALOR EN EL SI
          pintarBall si,0 
          dec ball.x 
          dec ball.y
          revisarColor  ball 
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
          revisarColor  ball  
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
          revisarColor  ball 
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
          JMP END_GAME
    JMP ex
    Abajo_derecha:
          getPos ball.x,ball.y
          pintarBall si,0 
          INC ball.x ;abajo 
          INC ball.y;der
          revisarColor  ball   
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
          JMP END_GAME
    JMP ex 
CLEAN:
    MOV al,ball.estado
    CMP pelota2.estado,al
    JNE nada
    INC once  
    CALL limpiarP 
    JMP nada
ex:
getPos ball.x,ball.y
pintarBall si,12
call ppBarra
nada:
endM


revisarColor MACRO ball;LA SALIDA AL
LOCAL ex,nada,gris,rosa,naranja,bar,blanco,azul,gr1,gr2,gr3,gr4,ro1,ro2,ro3,ro4,na1,na2,na3,na4,bla1,bla2,bla3,bla4,z1,z2,z3,z4,s1,level2,level3,b2,b3,b4
Push bx
push ax
 xor bx,bx
 xor ax,ax
    MOV DX,ball.x;row-rev
    MOV CX,ball.y;column-rev
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
        CMP AL,14
        JE bar
    JMP nada
    rosa:
            MOV di,6
            CMP ball.x,64
            JAE ro4
            CMP ball.x,50
            JAE ro3 
            CMP ball.x,36
            JAE ro1
            CMP ball.x,22
            JAE ro2
                ro1:
                    rebote 6,64,36,43,ball 
                    MOV bx,36
                    call ppClearBlock 
                JMP ex

                ro2:
                    rebote 6,64,22,29,ball
                    MOV bx,22
                    call ppClearBlock
                JMP ex   
                ro3:
                    rebote 6,64,50,57,ball
                    MOV bx,50
                    call ppClearBlock
                JMP ex   
                ro4:
                    rebote 6,64,64,71,ball
                    MOV bx,64
                    call ppClearBlock 
                JMP ex   
    naranja:
            MOV di,68;y
            CMP ball.x,64
            JAE na4
            CMP ball.x,50
            JAE na3 
            CMP ball.x,36
            JAE na1
            CMP ball.x,22
            JAE na2
                na1:
                    rebote  68,126,36,43,ball 
                    MOV bx,36;x
                    call ppClearBlock
                JMP ex

                na2:
                    rebote  68,126,22,29,ball
                    MOV bx,22
                    call ppClearBlock 
                JMP ex
                na3:
                    rebote  68,126,50,57,ball
                    MOV bx,50
                    call ppClearBlock
                JMP ex   
                na4:
                    rebote  68,126,64,71,ball
                    MOV bx,64
                    call ppClearBlock 
                JMP ex   
    blanco:
            MOV di,130
            CMP ball.x,64
            JAE bla4
            CMP ball.x,50
            JAE bla3     
            CMP ball.x,36
            JAE bla1
            CMP ball.x,22
            JAE bla2
                bla1:
                    rebote  130,188,36,43,ball
                    MOV bx,36
                    call ppClearBlock
                JMP ex

                bla2:
                    rebote  130,188,22,29,ball
                    MOV bx,22
                    call ppClearBlock
                JMP ex
                bla3:
                    rebote  130,188,50,57,ball
                    MOV bx,50
                    call ppClearBlock 
                JMP ex   
                bla4:
                    rebote  130,188,64,71,ball
                    MOV bx,64
                    call ppClearBlock 
                JMP ex    
    gris:   
            MOV di, 192
            CMP ball.x,64
            JAE gr4
            CMP ball.x,50
            JAE gr3   
            CMP ball.x,36
            JAE gr1 ; ENTRA AUNQUE NO SEA EXACTO 
            CMP ball.x,22
            JAE gr2
                gr1:                 
                    rebote  192,250,36,43,ball 
                    MOV bx,36
                    call ppClearBlock 
                JMP ex
                gr2:
                    rebote  192,250,22,29,ball
                    MOV bx,22
                    call ppClearBlock
                JMP ex
                gr3:
                    rebote  192,250,50,57,ball
                    MOV bx,50
                    call ppClearBlock 
                JMP ex   
                gr4:
                    rebote  192,250,64,71,ball
                    MOV bx,64
                    call ppClearBlock
                JMP ex    
    azul:
            MOV di,254
            CMP ball.x,64
            JAE z4
            CMP ball.x,50
            JAE z3  
            CMP ball.x,36
            JAE z1
            CMP ball.x,22
            JAE z2
                z1:
                    rebote  254,312,36,43,ball 
                    MOV bx,36
                    call ppClearBlock 
                JMP ex

                z2:
                    rebote  254,312,22,29,ball 
                    MOV bx,22
                    call ppClearBlock 
                JMP ex
                z3:
                    rebote  254,312,50,57,ball
                    MOV bx,50
                    call ppClearBlock 
                JMP ex   
                z4:
                    rebote  254,312,64,71,ball
                    MOV bx,64
                    call ppClearBlock 
                JMP ex    
    bar: 
        cmp ball.estado,2
        JE s1
        MOV ball.estado,1
        JMP nada
        s1:
        MOV ball.estado,0
        JMP nada
    ex:
        inc ptsActuales
        call letreroPuntos
        cmp ptsActuales,10
        JE  level2
        cmp ptsActuales,17
        JE  b2
        cmp ptsActuales,25
        JE  level3
        cmp ptsActuales,32
        JE  b2
        cmp ptsActuales,38
        JE  b3
        cmp ptsActuales,6
        JE  b4
    JMP nada
        level2:
        call bloNivel2
        JMP nada
        b2:
        MOV pelota2.estado,1
        JMP nada
        level3:
        call bloNivel3
        MOV once,1
        JMP nada
        b3:
        MOV pelota3.estado,1
        JMP nada 
        b4:
        MOV vel,165
        JMP nada
    nada:
pop ax
pop bx
endM 
subMenu MACRO
LOCAL der,izq,nada,pausa
xor ax,ax 
    MOV ah,11h
    int 16h
    JZ nada;pregunta estado buffer 
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
    MOV si,1 
    call pausar
    cmp si,0
    JNZ pausa
nada:
endM 
rebote MACRO  izq,der,Arriba,abajo,ball
    local left,rigth,up,down,ex,s1,s2,s3,s4
    cmp ball.y,izq
    JE  left
    cmp ball.y,der
    JE  rigth
    cmp ball.x,Arriba
    JE  up
    cmp ball.x,abajo
    JE  down
    JMP ex
        left:
        cmp ball.estado,1
        JE s3
            MOV ball.estado,2
            JMP ex 
        s3:
            MOV ball.estado,0
            JMP ex 
        rigth:
        cmp ball.estado,0
        JE s4
            MOV ball.estado,3
            JMP ex 
        s4:
            MOV ball.estado,1
            JMP ex        
        up: 
        cmp ball.estado,2
        JE s2;sino abajo der
            MOV ball.estado,1
            JMP ex
        s2:
        MOV ball.estado,0
            JMP ex
        down:
        cmp ball.estado,0;SINO ERA state 1
        JE s1
            MOV ball.estado,3
            JMP ex 
        s1:
            MOV ball.estado,2
            JMP ex
    ex:
endM 

imprimirChar MACRO  dl_
MOV ah,06h
MOV dl , dl_
int 21h
endM 

fillAdmin macro var
MOV var[0], 97;a 
MOV var[1], 64h;d
MOV var[2], 6Dh;m
MOV var[3], 69h;i
MOV var[4], 6Eh;n
MOV var[5], 62h;b
MOV var[6], 70h;p
endM 
validaLogin macro buffUser , buffPass  , ent
LOCAL s0,s1,s2,s3,s4,ex,NO_IMPORT,sig,no
xor si,si
xor bx,bx
limpiaArr aux_,sizeOF aux_,36
s0:
    MOV zero[0],0
    cmp ent[si],'$'
    JE no
    cmp ent[si],'.'
    JE s1
        MOV al,ent[si]
        MOV aux_[bx],al
        INC bx 
    inc si
    JMP s0
s1:;comparo el usuario
    compare buffUser
    limpiaArr aux_,sizeOF aux_,36
    MOV bx,0
    CMP zero[0],1
    JE s2
    JMP NO_IMPORT
s2:
    inc si 
    cmp ent[si],';'
    JE s3
    MOV al,ent[si]
    MOV aux_[bx],al
    inc bx 
    JMP s2
s3:;comparo la contra
    compare buffPass
    CMP zero[0],1
    JE s4 
JMP sig 
no:
pp No_reg
jmp ex
NO_IMPORT:
    inc si
    cmp ent[si],';'
    JE sig
    JMP NO_IMPORT
sig:
limpiaArr aux_,sizeOF aux_,36
MOV bx,0
inc si
JMP s0
s4:;aceptacion
inc si;me quito el ;
    MOV okLogIN,1
    MOV zero[0],0;admin
    JMP ex
ex:
endm
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
addMinutes macro 
xor ax,ax 
MOV al,min
MOV bl,60
MUL bl
;res en AX
ADD Al,segundos
endm

leerEstadis macro ent
LOCAL s0,s1,s2,s3,s4,punteo,ex
xor si,si
xor bx,bx
xor di,di
limpiaArr aux_,sizeOF aux_,36
s0:
    cmp ent[si],36
    JE ex
    cmp ent[si],'.'
    je s1
    MOV al, ent[si]
    MOV aux_[bx],al
    inc bx 
    inc si 
    JMP s0
s1:;user
    inc si
    CALL saveUser 
    JMP s2
s2:;numeros
    XOR dx,dx
    MOV dl,ent[si]
    sub dx,48;have number 
    INC si    
    recursiveNum:
    cmp ent[si],'.'
    JE s3
    cmp ent[si],';'
    JE s4
    ; sino soy un numero
    mov ax,10
    MUL dx
    MOV dx,ax;guardo res
    xor ax,ax
    MOV al,ent[si]
    sub ax,48;parseo
    add dx,ax;SUMO actual
    inc si 
    JMP recursiveNum
s3:;LVL O PUNTO
    inc di ; segun di me voy a guardar a respectivo lugar
    MOV bx,id_
    inc si
    cmp di,2
    JE punteo ;sino nivel
    MOV buffLevel[bx],dl
    JMP s2
    punteo:
    MOV buffPuntajes[bx],dl
    JMP s2
s4:;TIME
    MOV bx,id_
    MOV buffTimes[bx],dl
    inc si 
    inc id_ 
    limpiaArr aux_,sizeOF aux_,36
    MOV di,0
    MOV bx,0
    JMP s0
ex:
endm

printTop10Puntos macro vec
LOCAL IMP
CALL DeterminaCantidad;cambia bx 
xor si,si 
IMP: 
    MOV ax,si
    INC ax
    CALL ppNum
    ppChar punto
    pp tab
    xor ax,ax
    mov al,7
    mul si
    MOV di,ax
    CALL printUser
    pp aux_
    pp tab
    xor ax,ax  
    mov al,buffLevel[si]
    CALL ppNum 
    pp tab 
    XOR ax,ax 
    MOV al,vec[si]
    call ppNum
    inc si 
    pp  ln
    cmp si,bx
    JNE IMP 
endM 
printTop10Times macro vec
LOCAL IMP
CALL DeterminaCantidad;cambia bx
xor si,si 
IMP: 
    MOV ax,si
    INC ax
    CALL ppNum
    ppChar punto
    pp tab
    xor ax,ax
    mov al,7
    mul si
    MOV di,ax
    CALL printUser
    pp aux_
    pp tab
    xor ax,ax  
    mov al,buffLevel[si]
    CALL ppNum 
    pp tab 
    XOR ax,ax 
    MOV al,vec[si]
    call ppNum
    ppChar 's'
    inc si 
    pp  ln
    cmp si,bx
    JNE IMP 
endM 

Mmenu2 macro 
    LOCAL ex
    pp menu2
    m2:
    leerChar
    cmp al,49
    JE top1
    cmp al,50
    JE top2
    cmp al,51
    JE inicio
    pp noEsparada
    jmp m2
    top1:;puntos
        pp line 
        pp topP
        pp line 
        mov DI,0
        sortBurbuja buffPuntajes , DI
        printTop10Puntos buffPuntajes
        ReporteTopPuntaje buffPuntajes 
        activarModoVideo
        graficadora  AuxTop
        leerChar
        activaModoTexto
        pp line 
        pp presiona32
        leerChar
    JMP ex
    top2:;tiempo
        pp line 
        pp topT
        pp line 
        mov DI,0
        sortBurbuja buffTimes,DI
        printTop10Times buffTimes
        ReporteTopTime buffTimes
        activarModoVideo
        graficadora  AuxTop
        leerChar
        activaModoTexto
        pp line 
        leerChar
        pp presiona32
    ex:
endM

sortBurbuja MACRO arreglo,tipo ; di para saber si es asc o desc
LOCAL while1,while2,asc_,salida,salidita,continuar,cambia
    xor bx,bx
    xor ax,ax
    xor dx,dx  
    MOV dx,id_;indice recorrerdor 
    while1:
            cmp bx,dx;sale si llega al ultimo
            JNB salida
            MOV si,bx
            INC si
            while2:
                cmp si,dx;sale si llega al ultimo
                JNB salidita
                MOV cl,arreglo[bx];a[i]
                cmp tipo,1
                JE asc_ 
                    cmp cl,arreglo[si];a[j]
                    JB cambia
                    JMP continuar
                    asc_:
                    cmp cl,arreglo[si];a[j]
                    JA cambia
                continuar:
                INC si
            JMP while2
        salidita:
        INC bx
    JMP while1
    cambia:
    push dx
    MOV cl,buffTimes[bx]
    MOV ch,buffTimes[si]
    MOV dl,buffLevel[bx]
    MOV dh,buffLevel[si]
    MOV al,buffPuntajes[bx]
    MOV ah,buffPuntajes[si]
    MOV buffPuntajes[bx],ah
    MOV buffPuntajes[si],al
    MOV buffLevel[bx],dh
    MOV buffLevel[si],dl
    MOV buffTimes[bx],ch
    MOV buffTimes[si],cl
    CALL changeUser
    pop dx
    JMP continuar
    salida:
    limpiaArr AuxTop,sizeOF AuxTop,36
    CALL DeterminaCantidad 
    pusheaTop arreglo
    popeaTop  AuxTop
    calculaMayor arreglo
endM 
ppNumeros macro array
 LOCAL IMP 
 push si 
 xor si,si  
 IMP:
    xor ax,ax
    MOV al,array[si]
    CALL ppNum
    ppChar Ascii32
    inc si 
    CMP si,lenTop
    JNE IMP 
 pop si 
endM 

ReporteTopPuntaje macro vec
LOCAL con,IMP
crearFichero repPuntos,ManejadorRuta,errorArchivo
wr lineF
wrOk topP
wr lineF
CALL DeterminaCantidad;cambia bx
xor si,si 
IMP: 
    MOV ax,si
    INC ax
    CALL ppArcNum
    wr punto
    wr tabF
    xor ax,ax
    mov al,7
    mul si
    MOV di,ax
    CALL printUser
    wrOk aux_
    wr tabF
    xor ax,ax  
    mov al,buffLevel[si]
    CALL ppArcNum 
    wr tabF
    XOR ax,ax 
    MOV al,vec[si]
    call ppArcNum
    inc si 
    wr  lnF
    cmp si,bx
JNE IMP 
    wr lineF  
CerrarArchivo ManejadorRuta
endM
ReporteTopTime macro vec
LOCAL IMP
crearFichero repTime,ManejadorRuta,errorArchivo
wr lineF
wrOk topT
wr lineF
CALL DeterminaCantidad;cambia bx
xor si,si 
IMP: 
    MOV ax,si
    INC ax
    CALL ppArcNum
    wr punto
    wr tabF
    xor ax,ax
    mov al,7
    mul si
    MOV di,ax
    CALL printUser
    wrOk aux_
    wr tabF
    xor ax,ax  
    mov al,buffLevel[si]
    CALL ppArcNum 
    wr tabF
    XOR ax,ax 
    MOV al,vec[si]
    call ppArcNum
    inc si
    wr ese 
    wr  lnF
    cmp si,bx
JNE IMP 
    wr lineF  
CerrarArchivo ManejadorRuta
endM

pusheaTop macro arreglo
LOCAL inicio, fin
xor si,si 
inicio: 
    xor ax,ax
    cmp si,lenTop;longitud
    JE FIN  
    MOV al,arreglo[si]
    PUSH ax
    INC si 
    JMP inicio
fin:
endM
popeaTop macro arreglo
LOCAL inicio,fin
xor si,si 
mov si,lenTop;longitud 
dec si
inicio: 
    cmp si,0
    Jl fin
    pop ax
    mov arreglo[si],al
    dec si
    JMP inicio
fin:
endM 
calculaMayor macro arreglo
    LOCAL recorriendo, ex , cambia , con
    push ax
    PUSH bx 
        xor bx,bx
        xor ax,ax
        MOV mayor,0
        recorriendo:
        MOV al,arreglo[bx]
        cmp mayor,al;MAYOR<al
        JB cambia
        con:
        cmp bx,lenTop
        JE ex
        inc bx 
        JMP recorriendo
    cambia:
    MOV mayor,al
    JMP con
    ex:
POP bx
pop ax 
endM 
determinarAnchura macro anchuraY , espacio
    PUSH dx
    MOV ax,312  ; TAMAÑO HORIZONTAL 312
    xor dx,dx
    MOV bx,lenTop
    xor bh,bh
    DIV bl;res en al total para cada barra

    xor dx,dx
    mov dl,al ; ax al cociente ah residuo
    MOV espacioTotBarra,dx  ; espacioTotal
    
    xor bh,bh
    xor ah,ah
    mov bl,25;multiplico el cociente por 25
    mul bl;res ax
    MOV bl,100;PORCENTAJE 
    xor dx,dx 
    div bl ;res en al

    MOV espacio,al 
    MOV bx,espacioTotBarra
    sub bl,espacio;tamanio sobrante de barra 
    ;bx = espacio para barra
    MOV anchuraY,bx
    pop dx
endM 

determinarAltura macro alturaX,mayor
push si 
push bx 
push dx
push ax
    xor ax,ax
    MOV al,alturaX 
    MOV bl,168; espacio total para graficar
    mul bl
    ;res en ax 
    xor dh,dh 
    MOV dl,mayor ; la miultiplicacion dentro del mayor 
    div dl 
    ;res en al
    mov dl,190
    sub dl,al
    mov alturaX,dl;alturaX
pop ax
pop dx
pop bx
pop si 
endM
BarraPrint macro anchuraY,alturaX,espacio,color
LOCAL izq,arriba,der
PUSH si 
PUSH di
push ax 
push bx
    xor si,si
    xor di,di 
    ;get altura 
    xor ah,ah 
    MOV al,alturaX
    MOV di,ax
   
    ;1
    getPos di,relativPos;si pos final
    MOV di,si 
    ;2
    getPos 190,relativPos;si 
    ;pinto linea arriba 
    izq:
    MOV es:[di],dl
    add di,320
    cmp di,si
    JNE izq


    ;1
    xor ah,ah 
    MOV al,alturaX
    MOV di,ax
    getPos di,relativPos;si pos final
    MOV di,si 
    ;2
    MOV ax,relativPos
    add ax,anchuraY
    mov auxP,ax
    xor bh,bh 
    MOV bl,alturaX
    getPos  bx,auxP
    MOV auxP,si 
    ;si
    arriba:
    MOV es:[di],dl
    inc di
    cmp di,auxP
    JNE arriba
    


    ;punto 3
    MOV ax,relativPos
    add ax,anchuraY
    mov auxP,ax
    xor bh,bh 
    MOV bl,alturaX
    getPos bx,auxP;si pos final
    mov di,si    
    ;punto 4 
    getPos 190,auxP
    der:
    MOV es:[di],dl
    add di,320
    cmp di,si
    JNE der

        
    ; lleva el conteo a la derecha
    
    xor cx,cx
    MOV cx,espacioTotBarra
    add relativPos,cx
pop bx
pop ax
pop di 
pop si 
endM 
graficadora macro array
    LOCAL recorriendo , ex  
    MOV relativPos,7
    pusha
    CALL ppMargen
    call DeterminaCantidad
    determinarAnchura anchuraY , espacio
    ppNumeros array
    xor cx,cx 
    xor si,si 
    recorriendo:
        cmp si,lenTop;len
        JAE ex 
        xor ax,ax
         MOV al, array[si]
         MOV alturaX,al;aca num real 
PUSH ax
        xor dx,dx
        getColor alturaX;color en dl 
        determinarAltura alturaX,mayor
        BarraPrint anchuraY,alturaX,espacio,dl 
pop ax;recupero el valor orginal de alturaX
        MOV alturaX,al;pregunta en getSound
        getSound
        inc si
        JMP recorriendo
    ex:
    

    
    popa
endM 

getColor macro alturaX
    LOCAL  AZUL , AMA , verde ,white , ex
    CMP alturaX,1 
    JB ex 
    cmp alturaX,20
    JA AZUL
    MOV dl,40;rojo
    JMP ex 
    AZUL:
        cmp alturaX,40
        JA AMA
        mov dl,32;azul
        JMP ex
    AMA:
        cmp alturaX,60
        JA verde
        mov dl,44;amarillo
        JMP ex
    verde:
        cmp alturaX,80
        JA white
        mov dl,47;verde
        JMP ex
    white:
        mov dl,31;blanco
        JMP ex
    ex: 
endM
getSound macro
 LOCAL  tres , quinientos , setecientos ,nueve , ex
    CMP alturaX,1 
    JB ex 
    cmp alturaX,20
    JA tres
    sound 100 
    JMP ex 
    tres:
        cmp alturaX,40
        JA quinientos
        sound 300 
        JMP ex
    quinientos:
        cmp alturaX,60
        JA setecientos
        sound 500
        JMP ex
    setecientos:
        cmp alturaX,80
        JA nueve
        sound 700 
        JMP ex
    nueve:
        cmp alturaX,99 ; NO VA ACEPTAR MAS DE 100 :'V '
        sound 900 
    ex: 
endM 


sound macro hz
    mov al,86h
    out 43h,al;port
    mov ax,(1193180/hz) ;numero de hz 
    out 42h,al
    MOV al,ah
    out 42h,al
    in al,61h;produce sounds 
    OR al,00000011b
    out 61h,al
    delay tiempo; asi se escucha por un tiempo
    ;apagar bocina
    in al,61h
    AND al,11111100b
    out 61h,al
endM