    .data
buffer: .space 100 # Reserva espacio para la cadena de 100 caracteres
cifrado: .space 100 # Reserva espacio para la cadena cifrada de 100 caracteres
mensaje: .asciiz "Mensaje: "
claveMensaje: .asciiz "clave: "
cifradoMensaje: .asciiz "Cifrado: "
errorMensaje: .asciiz "Clave incorrecta"

    .text

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
