.data
# Inicia la secci�n de datos, donde se definen las variables y cadenas de texto.
msg1: .asciiz "Introduce un n�mero entero: "
# Define una cadena de texto que contiene el mensaje para solicitar al usuario un n�mero entero.
msg2: .asciiz "La suma de los primeros "
# Define una cadena de texto que contiene el mensaje para indicar el inicio de la suma de n�meros naturales pares.
msg3: .asciiz " n�meros naturales pares es: "
# Define una cadena de texto que contiene el mensaje para indicar el final de la suma de n�meros naturales pares.
n:   .word 0
# Define una variable de tipo word (32 bits) y la inicializa con el valor 0. Esta variable se utilizar� para almacenar el n�mero entero introducido por el usuario.
sum: .word 0
# Define una variable de tipo word (32 bits) y la inicializa con el valor 0. Esta variable se utilizar� para almacenar la suma de los primeros n n�meros naturales pares.

.text
# Inicia la secci�n de texto, donde se define el c�digo ejecutable del programa.
# Declara main como una funci�n global, lo que significa que puede ser llamada desde fuera del archivo.

main:
# Define el punto de entrada del programa, la funci�n main.
    li $v0, 4
    # Carga el valor 4 en el registro $v0. Este valor especifica que la pr�xima llamada al sistema imprimir� una cadena de texto.
    la $a0, msg1
    # Carga la direcci�n de la cadena msg1 en el registro $a0. Este registro se utiliza para pasar argumentos a las llamadas al sistema.
    syscall
    # Realiza la llamada al sistema especificada por el valor en $v0, en este caso, imprimir la cadena de texto apuntada por $a0.

    li $v0, 5
    # Carga el valor 5 en el registro $v0. Este valor especifica que la pr�xima llamada al sistema leer� un n�mero entero del usuario.
    syscall
    # Realiza la llamada al sistema especificada por el valor en $v0, en este caso, leer un n�mero entero del usuario. El n�mero le�do se almacena en el registro $v0.
    move $t0, $v0
    # Mueve el valor del registro $v0 (el n�mero entero le�do) al registro $t0.

    bgez $t0, positive
    # Comprueba si el valor en $t0 es mayor o igual a cero. Si es as�, salta a la etiqueta positive.
    sub $t0, $zero, $t0
    # Calcula el valor absoluto de $t0 restando $t0 de cero.

positive:
    # Etiqueta que marca el inicio del bloque de c�digo que se ejecuta si $t0 es mayor o igual a cero.
    sw $t0, n
    # Almacena el valor en $t0 (el valor absoluto de $t0) en la variable n.

    li $t1, 0
    # Inicializa el registro $t1 con el valor 0. Este registro se utilizar� como contador en el bucle for.

    li $v0, 0
    # Inicializa el registro $v0 con el valor 0. Este registro se utilizar� para acumular la suma de los n�meros naturales pares.

for_loop:
    # Etiqueta que marca el inicio del bucle for.
    addiu $t1, $t1, 2
    # Incrementa el valor en $t1 en 2. Este registro se utiliza como contador en el bucle for.

    bgt $t1, $t0, end_for_loop
    # Comprueba si el valor en $t1 es mayor que el valor en $t0. Si es as�, salta a la etiqueta end_for_loop.

    add $v0, $v0, $t1
    # Suma el valor en $t1 al valor en $v0. Este registro se utiliza para acumular la suma de los n�meros naturales pares.

    j for_loop
    # Salta de nuevo al inicio del bucle for.

end_for_loop:
    # Etiqueta que marca el final del bucle for.
    sw $v0, sum
    # Almacena el valor en $v0 (la suma de los n�meros naturales pares) en la variable sum.

    li $v0, 4
    # Carga el valor 4 en el registro $v0. Este valor especifica que la pr�xima llamada al sistema imprimir� una cadena de texto.
    la $a0, msg2
    # Carga la direcci�n de la cadena msg2 en el registro $a0.
    syscall
    # Realiza la llamada al sistema especificada por el valor en $v0, en este caso, imprimir la cadena de texto apuntada por $a0.

    lw $a0, n
    # Carga el valor de la variable n en el registro $a0.
    li $v0, 1
    # Carga el valor 1 en el registro $v0. Este valor especifica que la pr�xima llamada al sistema imprimir� un n�mero entero.
    syscall
    # Realiza la llamada al sistema especificada por el valor en $v0, en este caso, imprimir el n�mero entero apuntado por $a0.

    li $v0, 4
    # Carga el valor 4 en el registro $v0. Este valor especifica que la pr�xima llamada al sistema imprimir� una cadena de texto.
    la $a0, msg3
    # Carga la direcci�n de la cadena msg3 en el registro $a0.
    syscall
    # Realiza la llamada al sistema especificada por el valor en $v0, en este caso, imprimir la cadena de texto apuntada por $a0.

    lw $a0, sum
    # Carga el valor de la variable sum en el registro $a0.
    li $v0, 1
    # Carga el valor 1 en el registro $v0. Este valor especifica que la pr�xima llamada al sistema imprimir� un n�mero entero.
    syscall
    # Realiza la llamada al sistema especificada por el valor en $v0, en este caso, imprimir el n�mero entero apuntado por $a0.

    li $v0, 10
    # Carga el valor 10 en el registro $v0. Este valor especifica que la pr�xima llamada al sistema terminar� el programa.
    syscall
    # Realiza la llamada al sistema especificada por el valor en $v0, en este caso, terminar el programa.
