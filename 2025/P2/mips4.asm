   .data
	msg1: .asciiz "Introduce un numero entero: "
	msg2: .asciiz "La suma de los primeros "
	msg3: .asciiz " numeros naturales pares es: "
	n:   .word 0
	sum: .word 0

    .text

main:
    # Solicitar al usuario un numero entero
    li $v0, 4
    la $a0, msg1
    syscall

    # Leer el numero entero
    li $v0, 5
    syscall
    move $t0, $v0 
    # Guardar el numero entero en $t0

    # Calcular el valor absoluto de n
    bgez $t0, positive
    sub $t0, $zero, $t0 # Calcular el valor absoluto
positive:
   sw $t0, n
    # Inicializar el contador para el bucle for
    li $t1, 0
    # Inicializar la suma a 0
    li $v0, 0

for_loop:
    # Incrementar n dos veces cada vez
    addiu $t1, $t1, 2
    # Comprobar si hemos alcanzado el valor maximo de n
    bgt $t1, $t0, end_for_loop
    # Sumar el numero par actual a la suma total
    add $v0, $v0, $t1
    j for_loop

end_for_loop:
    # Almacenar la suma total en la memoria
    sw $v0, sum

    # Mostrar el resultado
    li $v0, 4
    la $a0, msg2
    syscall

    lw $a0, n # Mover el numero de elementos a $a0 para imprimirlo
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, msg3
    syscall

    lw $a0, sum # Mover el resultado a $a0 para imprimirlo
    li $v0, 1
    syscall

    # Terminar el programa
    li $v0, 10
    syscall
