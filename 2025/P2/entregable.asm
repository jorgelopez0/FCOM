   .data
msg1: .asciiz "Introduce un n�mero entero: "
msg2: .asciiz "La suma de los primeros "
msg3: .asciiz " n�meros naturales pares es: "
n:   .word 0
sum: .word 0

    .text
    
main:
    #Solicitar al usuario un n�mero entero
    li $v0, 4
    la $a0, msg1
    syscall

    #Leemos el n�mero entero
    li $v0, 5
    syscall
    move $t0, $v0 #Lo guardardamos el n�mero entero en $t0

    #Calculamos el valor absoluto de n
    bgez $t0, positivo
    sub $t0, $zero, $t0  #Calcular el valor absoluto de $t0, restando t0 de 0
positivo:  #si t0 es mayor o igual a 0
   sw $t0, n
    #Inicializamos el contador para el bucle for
    li $t1, 0
    #En t1 la suma a 0, para usarlo como contador
    li $v0, 0   #en v0 

bucle:
    #Incremento n dos veces cada vez
    addiu $t1, $t1, 2
    #Comprobamos si hemos alcanzado el valor m�ximo de n
    bgt $t1, $t0, terminar_bucle
    #Sumar el n�mero par actual en la iteraci�n a la suma total
    add $v0, $v0, $t1
    j bucle

terminar_bucle:
    sw $v0, sum
    
    # Mostrar el resultado
    li $v0, 4
    la $a0, msg2
    syscall

    #Mover el n�mero de elementos a $a0 para imprimirlo
    lw $a0, n 
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, msg3
    syscall

    lw $a0, sum #mover el resultado a $a0 para imprimirlo
    li $v0, 1
    syscall

    li $v0, 10
    syscall
    
.data
	rs: .space 5
	pedir: .asciiz "Ingrese un numero: "
	NoR: .asciiz "La instruccion no es de tipo R"
	valores:.asciiz "$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"
.text
    main:
        jal pedirNumero      
    	move $a0, $v0 # en a0 tenemos el numero metido por teclado
    	la $s0, rs
    	move $a1,$s0
    	jal mascara
    	move $a0, $s0         # Mueve el nombre del registro encontrado a $a0
    	li $v0, 4             # Carga el codigo de la syscall para imprimir un string
    	syscall
        li $v0, 10           
        syscall
    pedirNumero:
        li $v0, 4           
        la $a0, pedir        
        syscall               
        li $v0, 5            
        syscall    	
        jr $ra
    mascara:
    	move $t3, $a1
        addi $sp,$sp,-16
        sw $ra,0($sp)
        sw $s0,4($sp)
        sw $s1,8($sp)
        sw $s2,12($sp) 
    	li $t0,0xFC000000
    	and $t1, $t0, $a0
    	bne $t1,$zero,final #va a final si no es de tipo r
    	li $t2,0x03E00000
    	and $t2,$t2,$a0 #tenemos rs
    	srl $t2,$t2,21
    	move $a0,$t2
    	la $a1, valores
    	jal cuenta
    	move $s0,$v0
    seguir:
    	lb $t4, 0($s0)
    	sb $t4, 0($t3)
    	addi $s0,$s0,1
    	addi $t3,$t3,1
    	bne $t4,$zero,seguir
    	
    final:
   	li $v0,0
   	lw $ra,0($sp)
   	lw $s0,4($sp)
   	lw $s1,8($sp)
   	lw $s2,12($sp)
   	addi $sp,$sp,16
   	jr $ra
    	
    	
    	
cuenta: 
       sll $a0, $a0, 2        
       bne $a0, $zero, norestar  
       addi $a0, $a0, -2      
norestar:
    addi $a0, $a0, 2       
    add $v0, $a1, $a0      
    jr $ra
    
    .data
buffer: .space 100 # Reserva espacio para la cadena de 100 caracteres
cifrado: .space 100 # Reserva espacio para la cadena cifrada de 100 caracteres
mensaje: .asciiz "Mensaje: "
claveMensaje: .asciiz "clave: "
cifradoMensaje: .asciiz "Cifrado: "
errorMensaje: .asciiz "Clave incorrecta"

    .text
    .globl main
main:
    #Cargo la cadena en $a0
    la $a0, mensaje
    li $v0, 4
    syscall
    #Lee la cadena y la almacena en el buffer
    la $a0, buffer
    li $a1, 100
    li $v0, 8
    syscall

    #Inicializo el contador al buffer, el contador a la cadena cifrada y el contador de caracteres le�dos, que se usar�n posteriormente
    la $s0, buffer
    la $s1, cifrado
    li $t0, 0

    la $a0, claveMensaje
    li $v0, 4
    syscall

    #Lee el n�mero entero del usuario
    li $v0, 5
    syscall
    move $t1, $v0   #Guardo el n�mero clave le�do en $t1

    #Verifico si la clave es superior a 100
    li $t2, 100
    bgt $t1, $t2, error_clave_superior

traduccion_impresion_bucle:
    lb $a0, 0($s0) #Cargo el car�cter actual en $a0
    beqz $a0, acabar_traduccion_impresion_bucle  #si el valor en $a0 es cero, termina el bucle de traducci�n e impresi�n

    #Sumo el n�mero clave al valor ASCII del car�cter
    add $a0, $a0, $t1

    #Verifico si el car�cter cifrado est� fuera del rango imprimible
    li $t2, 32
    blt $a0, $t2, error_caracter_invalido
    li $t2, 127
    bgt $a0, $t2, error_caracter_invalido
	
    #Almaceno el resultado en la cadena cifrada, para su posterior impresi�n
    sb $a0, 0($s1)

    #Incremento de contadores
    addiu $s0, $s0, 1 #Incremento contador buffer
    addiu $s1, $s1, 1 #Incremento contador cadena cifrada
    addiu $t0, $t0, 1 #Incremento contador caracteres le�dos
    j traduccion_impresion_bucle   #Vuelve al inicio del bucle

acabar_traduccion_impresion_bucle:
    #Imprimo el mensaje "Cifrado: y carga la direcci�n del mensaje de cifrado en $a0
    la $a0, cifradoMensaje
    li $v0, 4
    syscall

    #Imprimo la cadena cifrada
    la $a0, cifrado #Carga la direcci�n de la cadena cifrada en $a0
    li $v0, 4
    syscall

    #Finalizo el programa
    li $v0, 10
    syscall

#La clave es superior a 100, error
error_clave_superior:
    li $v0, 1
    j acabar_programa

error_caracter_invalido:
    #Verifica si el car�cter es 10 m�s la clave.
    #Esto, lo hacemos, ya que cuando introducimos la cadena, se introduce la cadena m�s el cambio de linea(enter) cuando le doy para continuar con
    # la compilaci�n del programa. Al introducirse el caracter de cambio de linea (10 en el ASCII) hago, que cuando el caracter sea 10 m�s la 
    #cadena, no se vaya al error de caracter inferior al valor 32.
    addi $t2, $t1, 10 # Suma 10 a la clave y lo guarda en $t2
    beq $a0, $t2, continuar_sin_cifrar # Si el car�cter es 10 m�s la clave, continua sin cifrar

    #Un car�cter cifrado est� fuera del rango imprimible
    li $v0, 2
    j acabar_programa

continuar_sin_cifrar:
    #Incremento los contadores para continuar con el siguiente car�cter
    addiu $s0, $s0, 1 # Incrementa contador buffer
    addiu $s1, $s1, 1 # Incrementa contador cadena cifrada
    addiu $t0, $t0, 1 #Incrementa contador caracteres le�dos
    j traduccion_impresion_bucle   #Vuelta al inicio del bucle, as� se toma en cuenta la cadena, y no es considerada como error a pesar de tener
                                   #un caracter inferior a 32.

acabar_programa:
    #Imprimo el mensaje de error.
    la $a0, errorMensaje
    li $v0, 4
    syscall

    #Acabo el programa
    li $v0, 10
    syscall

