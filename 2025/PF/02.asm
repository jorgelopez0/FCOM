.data
mensaje_error: .asciiz "ERROR: El número introducido tiene un factor primo mayor que los considerados.\n"
prompt: .asciiz "Introduce un número: "
menor_que_dos: .asciiz "el numero es menor que 2"
vectorPrimos: .word 2, 3, 5, 7, 11, 13, 17, 0  # Lista de primos, termina en 0
vectorResultados: .space 40  # Espacio para almacenar los resultados
newline: .asciiz "\n"
asterisco: .asciiz " * "
flecha: .asciiz "^"
.text


main:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $s0, $v0  # Almacenar el número ingresado en $s0

    move $a0, $s0
    la $a1, vectorPrimos
    la $a2, vectorResultados
    jal FactoresPrimos

    beq $v0, $zero, imprimir
    li $v0, 4
    la $a0, mensaje_error
    syscall
    j exit

imprimir:
    la $a0, vectorResultados
    jal ImprimeFactores

exit:
    li $v0, 10
    syscall

FactoresPrimos:
    li $t0, 2
    blt $a0, $t0, error_menor_que_dos
    

    li $t1, 0
loop_primos:
    lw $t2, 0($a1)
    beq $t2, $zero, error_primo_no_encontrado
    div $a0, $t2
    mfhi $t3
    beq $t3, $zero, encontrado
    addiu $a1, $a1, 4
    j loop_primos

encontrado:
    sw $t2, 0($a2)
    addiu $a2, $a2, 4
    div $a0, $t2
    mflo $a0
    beq $a0, $t0, fin
    jal FactoresPrimos
    b fin

error_menor_que_dos:
    li $v0, 1
    la $a0, menor_que_dos
    syscall
    jr $ra

error_primo_no_encontrado:
    li $v0, 2
    la $a0, mensaje_error
    syscall
    jr $ra

fin:
    sw $zero, 0($a2)  # Marcar el final del vector con 0
    li $v0, 0
    jr $ra
ImprimeFactores:
    li $t0, 0
    lw $t1, 0($a0)  # Cargar el primer factor
    li $t3, 1       # Inicializar contador de repeticiones

loop_impresion:
    lw $t4, 4($a0)  # Cargar el siguiente factor
    beq $t4, $zero, print_last  # Si no hay más factores, imprimir el último
    bne $t4, $t1, print_factor  # Si el factor cambia, imprimir el actual

    # Si el factor no cambia, incrementar el contador y continuar
    addi $t3, $t3, 1
    addiu $a0, $a0, 4
    j loop_impresion

print_factor:
    # Imprimir el factor actual y el contador
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, flecha
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, asterisco
    syscall

    # Preparar para el próximo factor
    lw $t1, 4($a0)  # Cargar nuevo factor
    li $t3, 1       # Restablecer contador
    addiu $a0, $a0, 4
    j loop_impresion

print_last:
    # Imprimir el último factor y su contador
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, flecha
    syscall
    li $v0, 1
    move $a0, $t3
    syscall
    li $v0, 4
    la $a0, newline
    syscall

fin_impresion:
    jr $ra
