.data
mensaje_error: .asciiz "ERROR: El número introducido tiene un factor primo mayor que los considerados.\n"
.text
main:
    # Código para pedir el número al usuario

    # Llamada a FactoresPrimos
    jal FactoresPrimos
    beq $v0, $zero, imprimir
    li $v0, 4
    la $a0, mensaje_error
    syscall

imprimir:
    # Llamada a ImprimeFactores
    jal ImprimeFactores

    # Fin del programa
    li $v0, 10
    syscall

FactoresPrimos:
    # $a0: número a factorizar
    # $a1: dirección del vector de primos
    # $a2: dirección del vector de salida

    # Verificar si el número es menor que 2
    li $t0, 2
    blt $a0, $t0, error_menor_que_dos

    # Loop para encontrar el primer divisor primo
    li $t1, 0                  # Índice del vector de primos
loop_primos:
    lw $t2, 0($a1)             # Cargar el primo actual
    beq $t2, $zero, error_primo_no_encontrado  # Si $t2 es 0, fin del vector de primos
    div $a0, $t2
    mfhi $t3                   # Resto de la división
    beq $t3, $zero, encontrado # Si el resto es 0, divisor encontrado
    addiu $a1, $a1, 4          # Avanzar al siguiente primo
    j loop_primos

encontrado:
    # Almacenar el factor primo encontrado
    sw $t2, 0($a2)
    addiu $a2, $a2, 4          # Avanzar al siguiente espacio en el vector de salida
    div $a0, $t2
    mflo $a0                   # Cociente de la división
    beq $a0, $t0, fin          # Si el cociente es 1, terminar
    jal FactoresPrimos         # Llamada recursiva
    b fin

error_menor_que_dos:
    li $v0, 1
    jr $ra

error_primo_no_encontrado:
    li $v0, 2
    jr $ra

fin:
    li $v0, 0
    jr $ra
 
ImprimeFactores:
    # $a0: dirección del vector de factores
    li $t0, 0
    lw $t1, 0($a0)            # Cargar el primer factor

loop_impresion:
    beq $t1, $zero, fin_impresion  # Fin del vector
    # Contar repeticiones del factor actual
    move $t2, $t1             # Factor actual
    li $t3, 1                 # Contador de repeticiones

next_factor:
    lw $t4, 4($a0)            # Cargar siguiente factor
    beq $t4, $t2, contar      # Si es igual, contar
    # Imprimir factor actual y su recuento
    # Código para imprimir $t2 y $t3, manejar el formato
    addiu $a0, $a0, 4         # Avanzar al siguiente factor
    move $t1, $t4             # Actualizar factor actual
    j loop_impresion

contar:
    addiu $t3, $t3, 1         # Incrementar contador
    addiu $a0, $a0, 4         # Avanzar al siguiente factor
    j next_factor

fin_impresion:
    # Código para finalizar impresión
    jr $ra