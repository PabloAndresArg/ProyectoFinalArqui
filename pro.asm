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
si_3 dw 1 dup('$'),'$'
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

stateP1 db 0
stateP2  db 0
stateP3  db 0
posxP1  dw 0
posxP2  dw 0
posxP3  dw 0
posyP1  dw 0
posyP2  dw 0
posyP3  dw 0
BarraInicio dw 1 dup('0'),'$'


;login
.code
moverArrobaDS
    limpiaArr usersIndex , sizeOF usersIndex , 36
    limpiaArr passIndex , sizeOF passIndex , 36 
InitPassAdmin
pp bienvenida



leerChar
    activarModoVideo
    ppMargen 95D
    ppBloques 22,6
    ppBloques 36,6 
    ppBarra 180,160,95

        mov dx,35360
        mover2:
          pintarBall dx,0 
          sub dx,319 
          pintarBall  dx,12
          delay 200      
        jmp mover2
    activaModoTexto



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
;subRutinas
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
    
    ; activarModoVideo
    ; ppMargen 95D

    ;     mov dx,35360
    ;     mover:
    ;       pintarBall dx,0 
    ;       sub dx,319 
    ;       pintarBall  dx,12
    ;       delay 200        
    ;     jmp mover

    ; mov ah,10h
    ; int 16h ; lee si se presiona una tecla para salir del modo video

    activaModoTexto
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
