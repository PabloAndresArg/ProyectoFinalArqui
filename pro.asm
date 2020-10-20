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
usersIndex db 200 dup('$'),'$';10*20
passIndex db 200 dup('$'),'$';10*20
si_2 dw 1 dup(0),'$'
noEsId db 10,13, 'NUEVO USUARIO OK' ,10 ,13,'$'
No_reg db 10,13, 'usuario no registrado' ,10 ,13,'$'
logIN_ db 10,13, '** LOGIN **' ,10 ,13,'$'
okReg db 10,13, 'OK REGISTRADO..' ,10 ,13,'$'
linea db 10,13, '--' ,10 ,13,'$'
okLogeo db 10,13, 'ACCESO PERMITIDO' ,10 ,13,'$'

;login
.code
moverArrobaDS
    limpiaArr usersIndex , sizeOF usersIndex , 36
    limpiaArr passIndex , sizeOF passIndex , 36 
InitPassAdmin
  
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
    leerChar
    
     



    MOV ax,13h
    int 10h 
    xor cx,cx
    mov cx,13eh
    ejex_:
       ppPixel cx,95D,4fh
    loop ejex_

    MOV cx,120
    ejey_:
        ppPixel 95D,cx,4fh
    loop ejey_

    mov ah,10h
    int 16h ; lee si se presiona una tecla para salir del modo video

    MOV ax,3h
    int 10h 
    jmp inicio
registrar:
    limpiaArr buffUser , sizeOF buffUser , 36
    limpiaArr buffPass , sizeOF buffPass , 36  
    MOV zero[0],0
    pp ln
    pp form1 
    getCadena  buffUser 
    UserNoRep buffUser,usersIndex 
    pp form2

    getCadena  buffPass
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
