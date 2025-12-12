.data
mensaje: .asciiz "Introduce un n�mero entero\n"
mensaje_error: .asciiz "ERROR: El número introducido tiene un factor primo mayor que los considerados"
menor_que_dos: .asciiz "El numero es menor que 2"
nuevalinea: .asciiz "\n"
asterisco: .asciiz " * "
elevado: .asciiz "^"
divisor_encontrado_msg: .asciiz "Divisor encontrado: "
new_line: .asciiz "\n"
vectorPrimos: .word 2, 3, 5, 7, 11, 13, 17, 19, 23, 29,0  # Lista de primos, termina en 0
vectorResultados: .space 100
debug_message: .asciiz "Ingresando a FactoresPrimos\n"
pause_message: .asciiz "Presione Enter para continuar\n"

.text


main:
    # Imprimir el mensaje de introducir un numero
    li $v0, 4       
    la $a0, mensaje  
    syscall          

    # Leer un n�mero entero desde el teclado
    li $v0, 5       
    syscall          
    move $a0, $v0    

    # Cargamos la direcci�n del vector de primos en $a1
    # y el vector vacio en $a2 para los resultados
    la $a1, vectorPrimos 
    la $a2, vectorResultados
    
    # Llamar a FactoresPrimos
    jal FactoresPrimos
    
    # Utilizamos ambos $a0 y $a2 para recorrer el vector de resultados antes de llamar a la funcion de imprimir
    la $a0, vectorResultados
    la $a2, vectorResultados
    loop_1:
    	lw $t7, 0($a2)
    	sw $t7, ($a0)
    	addi $a0, $a0, 4
    	addi $a2, $a2, 4
    	beq $t7, $zero, reset
    	j loop_1
    reset:
    	la $a2, vectorResultados
    	la $a0, vectorResultados
    	jal ImprimeFactores
    
# Esta funcion recorre el vector de Primos en el loop dividiendo el numero entre cada uno para encontrar factores primos
FactoresPrimos: 
    li $t0, 2
    blt $a0, $t0, error_menor_que_dos
    move $t1, $a1 # Copia el puntero al vector en $t1
    lw $t3, 0($t1) # Cargar el valor del vector en $t3
    
    loop:
        beq $t3, $zero, error_primo_no_encontrado
        div $a0, $t3  # Divide $a0 por $t3
        mfhi $t5  
        mflo $t6
        beq $t5, $zero, divisor_found  # Si el resto es 0, es un divisor
        addi $t1, $t1, 4 # Avanza al siguiente elemento del vector
        lw $t3, 0($t1)    # Carga el proximo elemento 
        b loop         #Funcion recursiva

    # Cuando encuenta un factor lo almacena en el vector vacio
    divisor_found:
     	sw  $t3, ($a2)
        move $a0, $t6  
        addi $a2, $a2, 4
        li $t8, 0
        addi $t8, $t8, 4
	li $t7, 1
	beq $t6, $t7, end_loop
        bne $t6, $t7, loop
        
       
    # Si el numero introducido es 1 imprime un mensaje de error
    error_menor_que_dos:
    li $v0, 4
    la $a0, menor_que_dos
    syscall
    jr $ra        

    # Si el numero tiene un factor mayor a los del vector de primos imprime un mensaje de error
    error_primo_no_encontrado:
    li $v0, 4
    la $a0, mensaje_error
    syscall
    j end
       

    end_loop:
        sw $zero, ($a2)
        jr $ra
        
ImprimeFactores:
    li $t6, 1
    li $t5, 0
    li, $t2, 1
    loop_impresion:
        bne $t9, $zero, multiplicacion_solo
        lw $t9, 0($a2)
        beq $t9, $zero final
	addi $a2, $a2, 4
	lw $t7, 0($a2)
	beq $t7, $zero, final
	beq $t7, $t9, potencia
	bne $t7, $t9, multiplicacion
	
        
    potencia:
        addi $t2, $t2, 1
        addi $a2, $a2, 4
        lw $t3, 0($a2)
        beq $t3, $t7, potencia
        move $a0, $t7  # Mover el numero del divisor a $a0 para imprimirlo
        li $v0, 1  # Codigo de servicio para imprimir un entero
        syscall     # Realizar la llamada al sistema para imprimir el numero
        li $v0, 11    # Codigo para imprimir un caracter
        li $a0, 94     # Caracter ? (ASCII = 94)
        syscall
        move $a0, $t2  # Mover el numero del divisor a $a0 para imprimirlo
        li $v0, 1  # Codigo de servicio para imprimir un entero
        syscall     # Realizar la llamada al sistema para imprimir el numero
        beq $t3, $zero, end
        j loop_impresion
            
    multiplicacion:
        move $a0, $t9
        li, $v0, 1
        syscall
        li $v0, 11
        li $a0, 42     # Asterisco (*)
        syscall
        addi $a2, $a2, 4
        lw $t9, 0($a2)
        beq $t7, $t9, potencia
        move $a0, $t7
        li, $v0, 1
        syscall
        beq $t9, $zero, end
        bne $t9, $zero, loop_impresion 
    multiplicacion_solo:
        li $v0, 11 
        li $a0, 42     # Asterisco (*)
        syscall        # Llamar al sistema para imprimir el asterisco
        li $t9, 0
        j loop_impresion
    final:
        beq $t9, $zero, end
        move $t9, $t9
        move $a0, $t9
        li $v0, 1
        syscall
        li $v0, 10  # Cargar el Codigo de servicio para terminar el programa en $v0
        syscall     # Realizar la llamada al sistema para terminar el programa
    end:    
        li $v0, 10  # Cargar el codigo de servicio para terminar el programa en $v0
        syscall     # Realizar la llamada al sistema para terminar el programa



