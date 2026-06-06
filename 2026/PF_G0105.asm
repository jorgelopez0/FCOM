.data
Entrada_str:	.asciiz "Algoritmo de división con restauración\n"
Cociente_str:	.asciiz "Cociente:"
Resto_str:	.asciiz "Resto:"
Dividendo_str:	.asciiz "Dividendo:"
Divisor_str:	.asciiz "Divisor:"
errorDividendo: .asciiz "Error: Dividendo fuera de rango"
errorDivisor: .asciiz "Error: Divisor fuera de rango"
errorCero: .asciiz "Error: División entre cero"

.macro print_tab
	li $a0, '\t'		# Imprimimos linea en blanco
	li $v0, 11
	syscall
.end_macro

.macro print_salto
	li $a0, '\n'		# Imprimimos linea en blanco
	li $v0, 11
	syscall
.end_macro
	

.text

#Pablo Lopez Salgado y Jorge Lopez Rodriguez
main:
	#Leer dividendo
	li $v0, 4
	la $a0, Dividendo_str
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	
	#Validar dividendo (0-65535)
	slt $t2, $s0, $zero
	bne $t2, $zero, errorEnDividendo
	li $t1, 65535
	blt $t1, $s0, errorEnDividendo
	
	
    	#Leer divisor 
    	li $v0, 4
    	la $a0, Divisor_str
    	syscall
    	li $v0, 5
    	syscall
    	move $s1, $v0
    	
    	print_salto
    	
    	#Validar divisor (0-65535 y != 0)
    	slt $t2, $s1, $zero
    	bne $t2, $zero, errorEnDivisor
    	blt $t1, $s1, errorEnDivisor
    	beq $s1, $zero errorDivisorCero
    	
    	#Cabecera de operaciones
    	li $v0, 4
    	la $a0, Entrada_str
    	syscall
    	
    	print_salto
    	
 	#Mostrar dividendo
    	li $v0, 4
    	la $a0, Dividendo_str
    	syscall
    	print_tab
    	li $v0, 1
    	move $a0, $s0
    	jal printB
    	print_salto
    	
    	#Mostrar divisor
    	li $v0, 4
    	la $a0, Divisor_str
    	syscall
    	print_tab
    	sll $a0, $s1, 16
    	jal printB
    	print_salto
    	print_salto
    	
    	
    	#Paso de parametros a funcion
    	move $a0, $s0
    	move $a1, $s1
    	jal divisionR
    	
    	move $t0, $v0
    	move $t1, $v1
    	
    	#Imprimir resto
    	li $v0, 4
    	la $a0, Resto_str
    	syscall
    	
    	print_tab
    	li $v0, 1
    	move $a0, $t1
    	syscall
    	
    	print_salto
    	
    	#Imprimir cociente
    	li $v0, 4
    	la $a0, Cociente_str
    	syscall
    	
    	print_tab
    	li $v0, 1
    	move $a0, $t0
    	syscall
    	
    	
    	li $v0, 10
    	syscall
    	
    	
    	
    	
divisionR:
	addi $sp, $sp, -20
	sw $ra, 0($sp) 
	sw $s0, 4($sp) #Divisor
	sw $s1, 8($sp) #Contador
	sw $s2, 12($sp) #Temporal P_HI
	sw $s7, 16($sp) # P(P_HI|P_LO)
	
	#Inicializar P
	move $s7, $a0 #Mitad baja = dividendo | mitad alta = 0
	move $s0, $a1 #Guardamos divisor
	
	#Mostrar estado inicial
	move $a0, $s7
	jal printB
	print_salto

	li $s1, 0 #Inializar contador
	
bucle_div:
	li $t6, 16
	beq $s1, $t6, fin_division #se ejecuta el bucle 16 veces
	
	#Desplazar P un lugar a la izquierda
	sll $s7, $s7, 1 
	
	#Extraemos p_hi que contiene el resto parcial
	srl $s2, $s7, 16
	
	#realizamos la resta de la division con restauracion: p_hi=p_hi-divisor
	sub $s2, $s2, $s0
	
	#si el resultado es negativo lo tenemos que restaurar
	slt $t5, $s2, $zero
	beq $t5, $zero, no_restaurar
	
	#deshacemos la resta anterior: p_hi=p_hi+divisor
	add $s2, $s2, $s0
	j actualizar_P

no_restaurar:
	#Si la resta no es negativa, ponemos p0=1.
	ori $s7, $s7, 1
actualizar_P:
	andi $s7, $s7, 0x0000FFFF # Limpiar parte alta de s7
	sll $s2, $s2, 16 	# Colocar P_HI en la parte alta
	or $s7, $s2, $s7 	# Combinar
	
	
	#Mostrar numero de iteracion
	li $v0, 1
	addi $a0, $s1, 1
	syscall
	print_tab
	
	#Mostrar iteración
	move $a0, $s7
	jal printB
	print_salto
	
	addi $s1, $s1, 1  	#Actualizar contador
	j bucle_div
	
fin_division:
	andi $v0, $s7, 0x0000FFFF	#Cociente en la mitad baja
	srl $v1, $s7, 16   	#Resto en la mitad alta
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s7, 16($sp)
	addi $sp, $sp, 20
	jr $ra

printB:
	move $t0, $a0
	lui $t1, 0x8000  #cargo un 1 y el resto 0 para comprobar si el bit actual es 1 o 0
	li $t2, 32   #hay 32 bits a imprimir
	
bucle_print:
	and $t3, $t0, $t1  #comprobacion de si el bit actual es 1 o 0
	
	beq $t3, $zero, imprimirCero
	
imprimirUno:  #imprime el 1
	li $v0, 11
	li $a0, '1'
	syscall
	
	j despuesDeImprimir
	
imprimirCero:  #imprime el 0
	li $v0, 11
	li $a0, '0'
	syscall
	
despuesDeImprimir:  #si el bit que acabamos de imprimir es el 16 hay que poner un separador
	srl $t1, $t1, 1   #desplazo el 1 una posicion a la derecha para asi comprobar el siguiente bit
	addi $t2, $t2, -1   #resto 1 al contador
	li $t4, 16
	beq $t2, $t4, imprimirSeparador
	bne $t2, $zero, bucle_print
	jr $ra
	
imprimirSeparador:
	print_tab
	bne $t2, $zero, bucle_print
	jr $ra   #si no quedan bits volvemos

	

#MENSAJES DE ERROR
errorEnDividendo:
	li $v0, 4
	la $a0, errorDividendo
	syscall
	
	li $v0, 10
	syscall
	
errorEnDivisor:
	li $v0, 4
	la $a0, errorDivisor
	syscall
	
	li $v0, 10
	syscall

#Error cuando el divisor es 0	
errorDivisorCero:
	li $v0, 4
	la $a0, errorCero
	syscall
	
	li $v0, 10
	syscall
