.data
mensaje_error: .asciiz "ERROR: No se encuentra ningun factor primo"
menor_que_dos: .asciiz "El número es menor que 2"
prompt: .asciiz "Introduce un número: "
vectorPrimos: .word 2, 3, 5, 7, 11, 13, 17, 23, 0
vectorResultados: .space 80
nuevalinea: .asciiz "\n"
asterisco: .asciiz " * "
elevado: .asciiz "^"
.text


main:
	#Entrada del usuario
    	li $v0, 4
    	la $a0, prompt
    	syscall

    	li $v0, 5
    	syscall
	move $a0, $v0

	#Llamar a FactoresPrimos
    	la $a1, vectorPrimos
    	la $a2, vectorResultados
    	jal FactoresPrimos

    	# Verificar
    	beq $v0, $zero, imprimir
    	li $v0, 4
    	la $a0, mensaje_error
    	syscall
    	j exit

	imprimir:
   
    		jal ImprimeFactores

	exit:
    		li $v0, 10
    		syscall

FactoresPrimos:
    	# $a0: número
    	# $a1: vector de primos
    	# $a2: vector de salida
	
    	# es menor que 2
    	
    	li $t0, 2
    	blt $a0, $t0, menor_que_dos

	loop_primos:
    		lw $t3, ($a1)             # Cargar el primo
    		beq $t3, $zero, fin
    		div $a0, $t3 
    		mfhi $t4                   # Resto
    		beq $t4, $zero, encontrado # Si el resto es 0, hemos encontrado un divisor
    		addiu $a1, $a1, 4          # Avanzar al siguiente primo
    		j loop_primos

	encontrado:
    		# Almacenar el factor primo encontrado
    		sw $t3, ($a2)
    		addi $a2, $a2, 4         
    		div $a0, $t3
   		mflo $a0                   # cociente
    		beq $a0, 1, fin        # Si el cociente es 1, fin
    		j loop_primos              # Continuar buscando 

	fin:
		sw $zero, ($a2)  # Terminar la lista de resultados
    		li $v0, 0
    		jr $ra
    
    
ImprimeFactores:
    		lw $t1, ($a0)             # Cargar el primer factor
    		beq $t1, $zero, fin_impresion  # Si es 0, fin del vector
		li $t3, 1
		li $v0, 5
	
	loop_impresion:
    		lw $t4, 4($a2)             # Cargar siguiente factor
    		beq $t4, $zero, print_ultimo # Si el siguiente es 0, imprimir último factor
    		bne $t4, $t1, print_factor 	#Si el siguiente no es igual al actual, imprimir
    		addi $t3, $t3, 1		# Incrementar contador si el siguiente factor es igual al actual
    		addi $t4, $t4, 4
    		j loop_impresion

	print_factor:             
    		li $v0, 1               # Imprimir el factor actual y el contador
    		move $a0, $t1           # Mover el factor primo actual a $a0
    		syscall                 # Imprimir el factor primo
    		li $v0, 4               
   		la $a0, elevado        
    		syscall                 # Imprimir '^'
    		li $v0, 1               
    		move $a0, $t3           # Mover el contador a $a0
    		syscall                 # Imprimir el contador
    		li $v0, 4              
    		la $a0, asterisco        
    		syscall                 # Imprimir '*'
    		lw $t1, 4($a2)          # Cargar el siguiente factor primo
    		li $t3, 1               # Reiniciar el contador para el próximo factor
    		addiu $a2, $a2, 4       # Avanzar al siguiente espacio en el vector de resultados
    		j loop_impresion       

	print_ultimo:
    					# Imprimir el último factor primo y su contador
    		li $v0, 1              
    		move $a0, $t1           # Mover el último factor primo a $a0
    		syscall                 # Imprimir el último factor primo
    		li $v0, 4               
    		la $a0, elevado        
    		syscall                 # Imprimir '^'
    		li $v0, 1               # syscall para imprimir entero
    		move $a0, $t3           # Mover el contador del último factor a $a0
    		syscall                 # Imprimir el contador del último factor
    		li $v0, 4              
    		la $a0, asterisco       
    		syscall                 # Imprimir '*'
    		li $v0, 4             
    		la $a0, nuevalinea       # Preparar para imprimir el carácter '\n'
    		syscall                 # Imprimir nueva línea para finalizar la impresión
    		j fin_impresion       

	fin_impresion:
    		jr $ra
