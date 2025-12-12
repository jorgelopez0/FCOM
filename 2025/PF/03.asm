.data
mensaje: .asciiz "Introduce un n�mero entero\n"
mensaje_error: .asciiz "ERROR: No se encuentra ningun factor primo"
menor_que_dos: .asciiz "El numero es menor que 2"
nuevalinea: .asciiz "\n"
asterisco: .asciiz " * "
elevado: .asciiz "^"
divisor_encontrado_msg: .asciiz "Divisor encontrado: "
new_line: .asciiz "\n"
vectorPrimos: .word 2, 3, 5, 7, 11, 13, 17, 19, 23, 0  # Lista de primos, termina en 0
vectorResultados: .space 100
debug_message: .asciiz "Ingresando a FactoresPrimos\n"
pause_message: .asciiz "Presione Enter para continuar\n"

.text
.globl main

main:
    # Imprimir el mensaje
    li $v0, 4       # C�digo para imprimir una cadena
    la $a0, mensaje  # Cargar la direcci�n de la cadena en $a0
    syscall          # Llamar al sistema para imprimir la cadena

    # Leer un n�mero entero desde el teclado
    li $v0, 5       # C�digo para leer un entero desde el teclado
    syscall          # Llamar al sistema para leer el entero
    move $a0, $v0    # Mover el n�mero le�do a $a0

    la $a1, vectorPrimos  # Cargar la direcci�n del vector de primos en $a1
    la $a2, vectorResultados
    # Llamar a FactoresPrimos
    jal FactoresPrimos


    
    
    
    
    
    # Terminar el programa
    li $v0, 10      # C�digo para terminar el programa
    syscall          # Llamar al sistema para terminar el programa

FactoresPrimos: 
    move $t1, $a1 # Copia el puntero al vector en $t1
    lw $t3, 0($t1) # Cargar el valor del vector en $t3
    loop:
        div $a0, $t3  # Divide $a0 por $t3, el resultado est� en lo y el residuo en hi
        mfhi $t5  # Mueve el residuo a $t5 para comprobar si es 0
        mflo $t6
        beq $t5, $zero, divisor_found  # Si el residuo es 0, es un divisor
        addiu $t1, $t1, 4 # Avanza al siguiente elemento del vector, 4 bits, el tama�o de un Word
        lw $t3, 0($t1)    # Carga el pr�ximo elemento en $t3
        b loop          # Vuelve al inicio del bucle
        
    divisor_found:
     	sw  $t3, ($a2)
        move $a0, $t6  # Mover el n�mero del divisor a $a0 para imprimirlo
        
	li $t7, 1
	beq $t6, $t7, end_loop
        bne $t6, $t7, loop
        
        # Imprimir un salto de l�nea
       

    end_loop:
        sw $zero, ($a2)
        jr $ra
        
