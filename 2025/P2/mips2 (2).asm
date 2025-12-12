.data
prompt: .asciiz "Ingrese un numero: "
# Nombres de registros, cada nombre seguido de null-terminator
nombres: .asciiz "$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
                 "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
                 "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
                 "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"
buffer: .space 20  # Espacio para el nombre del registro

.text
.globl main
main:
# Imprime mensaje idicando la entrada del numero entero
	li $v0, 4             
 	la $a0, prompt        
 	syscall              

	li $v0, 5  
	syscall
	move $a0, $v0  
	
	la $a1, buffer 
	
	jal nombreRegistro 

# Imprimir resultado si es válido
    	beq $v0, 0, print_result
    	li $v0, 4
    	la $a0, prompt
    	syscall
    	j end

print_result:
   	li $v0, 4
    	la $a0, buffer
    	syscall

end:
	li $v0, 10  # Salir
    	syscall

#Número de registro no válido.\n"

.globl nombreRegistro
nombreRegistro:
	li $t0, 31
    	blt $a0, $zero, fuera_rango  # Si $a0 < 0
    	bgt $a0, $t0, fuera_rango   # Si $a0 > 31

# Calcular dirección del nombre del registro
    	li $t1, 5 # Tamaño estimado de cada nombre
    	mul $t2, $a0, $t1  # Índice * tamaño
    	la $t3, nombres
    	add $t2, $t3, $t2  # Sumar base + desplazamiento

# Copiar el nombre del registro a la dirección dada por $a1
    	li $t0, 0
copy_loop:
    	lb $t3, 0($t2)
    	beq $t3, $zero, end_copy  # Si llegamos al terminador de cadena
    	sb $t3, 0($a1)
    	addi $t2, $t2, 1
    	addi $a1, $a1, 1
    	j copy_loop
end_copy:
    	sb $zero, 0($a1)  # Asegurar terminador de cadena
    	li $v0, 0 
    	jr $ra

fuera_rango:
    	li $v0, 1  # Error
    	jr $ra