.data
regNames: .asciiz "$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
                   "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
                   "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
                   "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"
nameLength: .word 5  #Cada nombre tiene un máximo de 4 caracteres + null terminator

.text
.globl getRegisterName
getRegisterName:
    # Verificar si el índice está en el rango válido
    li $t0, 31
    bgt $a0, $t0, invalid_index  # Si $a0 > 31, salta a invalid_index
    blt $a0, $zero, invalid_index  # Si $a0 < 0, salta a invalid_index

    # Calcular la dirección del nombre en la tabla
    li $t1, 5  # Longitud máxima de cada nombre de registro
    mul $t2, $a0, $t1  # $t2 = índice * longitud de cada nombre
    add $t2, $t2, $regNames  # $t2 = dirección base + desplazamiento calculado

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

invalid_index:
    # Establecer $v0 a 1 (índice no válido)
    li $v0, 1
    jr $ra  # Retornar a la dirección de retorno