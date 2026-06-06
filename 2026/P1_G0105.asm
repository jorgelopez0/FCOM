# Jorge López Rodríguez, Pablo López Salgado
# Grupo 5
.data
V: .word 1 8 9 10 14 16 23 25 31 32
	
.text
	main: 
		la $t1, V # dirección del vector
		li $t0, 0 # indice
	loop: 
		li $t2, 2
		div $t0, $t2
		mfhi $t4
		mul $t3, $t0, $t2
		beq $t4, $zero, par
		addi $t3, $t3, 1
	par:
		sw $t3, 0($t1)
		addi $t0, $t0, 1
		addi $t1, $t1, 4
		bne $t0, 10, loop
		
		li $v0, 10 
		la $t0, V
		lw $t1, 12($t0) # R[3]
		lw $t2, 24($t0) # R[6]
		add $s4, $t1, $t2 # R[3] + R[6]
		sw $s4, 36($t0) # R[9] = R[3] + R[6]
		syscall
	
