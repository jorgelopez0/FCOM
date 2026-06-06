.data
pedirCad: .asciiz "Introduzca una cadena: "
msgNorm: .asciiz "\nCadena normalizada: "
msgInv: .asciiz "\nCadena invertida: "
msgPal: .asciiz "\nLa cadena es palindroma.\n"
msgVacia: .asciiz "\nCadena vacia.\n"
msgNoPal: .asciiz "\nLa cadena no es palindroma.\n"

cadena: .space 22      # 20 caracteres + '\n' + '\0'
normalizada: .space 22
invertida: .space 22

.text
.globl main

main:
	#pedir cadena
	li $v0, 4
	la $a0, pedirCad
	syscall

	#leo cadena
	li $v0, 8
	la $a0, cadena
	li $a1, 22
	syscall

	#llamo a f3
	la $a0, cadena
	la $a1, normalizada
	la $a2, invertida
	jal F3

	move $t0, $v0   # guardar resultado

	#imprimo cadena normalizada
	li $v0, 4
	la $a0, msgNorm
	syscall

	li $v0, 4
	la $a0, normalizada
	syscall

	#imprimo la cadena invertida
	li $v0, 4
	la $a0, msgInv
	syscall

	li $v0, 4
	la $a0, invertida
	syscall

	#compruebo si es palindromo
	beq $t0, $zero, es_pal

	li $t1, 1
	beq $t0, $t1, es_vacia

	j no_es_pal

es_pal:
	li $v0, 4
	la $a0, msgPal
	syscall
	j fin_main

es_vacia:
	li $v0, 4
	la $a0, msgVacia
	syscall
	j fin_main

no_es_pal:
	li $v0, 4
	la $a0, msgNoPal
	syscall

#fin del main
fin_main:
	li $v0, 10
	syscall


##FUNCIONES

#recibe en a0 la direccion de la cadena original y en a1 esta la direccion destino de la cadena normalizada. elimina
#espacios, cambia minusculas a mayusculas, cambia el \n por \0.
F2:
bucleF2:
	lb $t0, 0($a0)

	beq $t0, $zero, finF2  #si la cadena esta terminada (\0) termino
    
	li $t1, 10
	beq $t0, $t1, finF2  #si estamos en \n termino

	li $t1, 32
	beq $t0, $t1, saltarF2   #un espacio lo salto

	#compruebo que sea minuscula
	li $t1, 97
	blt $t0, $t1, copiarF2

	li $t2, 122
	blt $t2, $t0, copiarF2

	addi $t0, $t0, -32  #convierto a mayusc restando 32

copiarF2:
	sb $t0, 0($a1)
	addi $a1, $a1, 1

saltarF2:
	addi $a0, $a0, 1
	j bucleF2

finF2:
	sb $zero, 0($a1)
	jr $ra

#recibe en a0 la cadena original, en a1 la normalizada y en a2 la invertida. 
#devuelve en $v0 0 si es palindromo, 1 si la cadena normalizada esta vacia y 2 si no es palindromo
#llama a f2 y construye la invertida para compararlas.
F3:
	#control de la pila
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)

	#movemos los registros para no perderlos
	move $s0, $a0       # original
	move $s1, $a1       # normalizada
	move $s2, $a2       # invertida
	#llamo a f2
	move $a0, $s0
	move $a1, $s1
	jal F2
	move $t5, $s1
	#compruebo si la normalizada esta vacia
	lb $t0, 0($t5)
	bne $t0, $zero, noVaciaF3

	sb $zero, 0($s2)
	li $v0, 1
	j finF3

noVaciaF3:
	#calculo longitud de la normalizada
	move $t0, $s1
	li $t6, 0

calcLenF3:
	lb $t1, 0($t0)
	beq $t1, $zero, finLenF3
	addi $t6, $t6, 1
	addi $t0, $t0, 1
	j calcLenF3

finLenF3:
	#construyo la cadena invertida
	add $t0, $s1, $t6
	addi $t0, $t0, -1

	move $t1, $s2 #recupero el puntero de la cadena invertida
	li $t7, 0

bucleInvF3:
	blt $t7, $t6, copiarInvF3
	j finInvF3

copiarInvF3:
	lb $t2, 0($t0)
	sb $t2, 0($t1)
	addi $t0, $t0, -1
	addi $t1, $t1, 1
	addi $t7, $t7, 1
	j bucleInvF3

finInvF3:
	sb $zero, 0($t1)

	#comparacion de cadena invertida y normalizada
	move $t0, $s1
	move $t1, $s2

compF3:
	lb $t2, 0($t0)
	lb $t3, 0($t1)

	bne $t2, $t3, noPalF3
	beq $t2, $zero, siPalF3

	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j compF3

siPalF3:
	li $v0, 0
	j finF3

noPalF3:
	li $v0, 2
    
finF3:
	#libero la pila
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	jr $ra