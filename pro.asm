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
Barra ENDS
barr Barra<'0','0'>
;login
.code
moverArrobaDS
    limpiaArr usersIndex , sizeOF usersIndex , 36
    limpiaArr passIndex , sizeOF passIndex , 36 
InitPassAdmin
pp bienvenida

;declaracion del struct

leerChar
    activarModoVideo
    ppMargen 95D
    ppBloques 22,6
    ppBloques 36,6 
    MOV barr.y,160
    MOV barr.len,95
    ppBarra 14
        ;150,320 (i,j)=150*320+40 = 
        MOV vel,150
        MOV pelota1.x,150
        MOV pelota1.y,280
        MOV pelota1.estado,1
        JUGAR pelota1
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

moveBarraD PROC
    mov ax,barr.y
    inc ax
    cmp ax,220
    JE exD 
    ppBarra 0h
    inc barr.y
    ppBarra 14
    exD:
RET
moveBarraD ENDP

moveBarraI PROC
    mov ax,barr.y
    dec ax
    cmp ax,5
    JE exD 
    ppBarra 0h
    dec barr.y
    ppBarra 14
    exD:
RET  
moveBarraI ENDP

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
