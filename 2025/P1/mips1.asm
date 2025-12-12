.data
# Nombres de registros lista de strings
nombres: .asciiz "$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
                   "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
                   "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
                   "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"
.text
.globl main



main:
	li $v0, 5
	syscall
	move $a0, $v0
	
	la $a1, buffer
	
	jal nombreRegistro

    li $v0, 10  # Salir
    syscall

 .data
    buffer: .space 20  # Espacio para el nombre del registro

.text
.globl nombreRegistro

nombreRegistro:
# Verificar rango, # Si $a0 < 0, # Si $a0 > 31
	li $t0, 31
	blt $a0, $zero, fuera_rango 
	bgt $a0, $t0, fuera_rango 
    
# Copiar el nombre del registro a la dirección dada por $a1
	lb $t3, 0($t2)
	sb $t3, 0($a1)
	lb $t3, 1($t2)
 	sb $t3, 1($a1)
 	lb $t3, 2($t2)
	sb $t3, 2($a1)
	lb $t3, 3($t2)
	sb $t3, 3($a1)
   	lb $t3, 4($t2)
 	sb $t3, 4($a1)
    
# Establecer $v0 a 0 (éxito)
	li $v0, 0
	jr $ra  # Retornar a la dirección de retorno
    
fuera_rango:
    # Establecer $v0 a 1, # Retornar a la dirección de retorno
    li $v0, 1
    jr $ra  
	