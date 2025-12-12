.data
mensaje: .asciiz "Introduce un numero entero\n"
mensaje_error: .asciiz "ERROR: El numero introducido tiene un factor primo mayor que los considerados"
menor_que_dos: .asciiz "El numero es menor que 2"
divisor_encontrado_msg: .asciiz "Divisor encontrado: "
new_line: .asciiz "\n"
vectorPrimos: .word 2, 3, 5, 7, 11, 13, 17, 19, 23, 29,
31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 0  # Lista de primos, termina en 0
vectorResultados: .space 100
debug_message: .asciiz "Ingresando a FactoresPrimos\n"
pause_message: .asciiz "Presione Enter para continuar\n"

.text


main:
    # Imprimir el mensaje de introducir un numero
    li $v0, 4       
    la $a0, mensaje  
    syscall          

    # Leer un numero entero desde el teclado
    li $v0, 5       
    syscall          
    move $a0, $v0    
    move $a3, $a0

    # Cargamos la direccion del vector de primos en $a1
    # y el vector vacio en $a2 para los resultados
    la $a1, vectorPrimos 
    la $a2, vectorResultados
    
    # Llamar a FactoresPrimos
    jal FactoresPrimos
    
    #Metemos en a0 el vector de los resultados y reseteamos a2 con el mismo vector para que se recorra desde el primer elemento
    la $a0, vectorResultados
    la $a2, vectorResultados
    loop_1: #paso de a2 a a0
    	lw $t7, 0($a2)
    	sw $t7, ($a0)
    	addi $a0, $a0, 4
    	addi $a2, $a2, 4
    	beq $t7, $zero, reset  # Si t7 es 0 reseteo los vectores para que se recorran desde el primer elemento y me voy a imprimir los factores
    	j loop_1
    reset:  # Reseteo y me voy a imprimir los factores
    	la $a2, vectorResultados
    	la $a0, vectorResultados
    	jal ImprimeFactores
    
# Esta funcion recorre el vector de Primos en el loop dividiendo el numero entre cada uno para encontrar factores primos
FactoresPrimos: 
    li $t0, 2
    blt $a0, $t0, error_menor_que_dos
    move $t1, $a1 # Copia el puntero al vector en $t1
    lw $t3, 0($t1) # Cargar el valor del vector en $t3
    
    loop:
        beq $t3, $zero, error_primo_no_encontrado
        div $a0, $t3  # Divide $a0 por $t3
        mfhi $t5  
        mflo $t6
        beq $t5, $zero, divisor_found  # Si el resto es 0, es un divisor
        addi $t1, $t1, 4 # Avanza al siguiente elemento del vector
        lw $t3, 0($t1)    # Carga el proximo elemento 
        b loop         #Funcion recursiva

    # Cuando encuenta un factor lo almacena en el vector vacio
    divisor_found:
     	sw  $t3, ($a2)
        move $a0, $t6  
        addi $a2, $a2, 4
        li $t8, 0
        addi $t8, $t8, 4
	li $t7, 1
	beq $t6, $t7, end_loop
        bne $t6, $t7, loop
        
       
    # Si el numero introducido es 1 imprime un mensaje de error
    error_menor_que_dos:
        li $v0, 4
        la $a0, menor_que_dos
        syscall
        j end       

    # Si el numero tiene un factor mayor a los del vector de primos imprime un mensaje de error
    error_primo_no_encontrado:
        li $v0, 4
        la $a0, mensaje_error
        syscall
        j end
       

    end_loop:
        sw $zero, ($a2)
        jr $ra
        
ImprimeFactores:  #Antes de las etiquetas imprimo el numero introducido por teclado y el =
    li, $t2, 1  #inicio contador de potencia
    move $a0, $a3  
    li $v0, 1  
    syscall 
    li $v0, 11     # C�digo para imprimir un caracter
    li $a0, 32      # Caracter de espacio (ASCII = 32)
    syscall
    li $v0, 11 
    li $a0, 61      # Caracter de = (ASCII = 31)
    syscall
    li $v0, 11 
    li $a0, 32      
    syscall
    
    loop_impresion:  #etiqueta que contiene el bucle principal, compara a los dos primeros numeros y los manda a otra etiqueta segun corresponda
        bne $t9, $zero, multiplicacion_solo  #en el retorno de las otras etiquetas, imprime el pr�ximo asterisco de multiplicaci�n
        lw $t9, 0($a2)
        beq $t9, $zero final
	addi $a2, $a2, 4
	lw $t7, 0($a2)
	beq $t7, $zero, final
	beq $t7, $t9, potencia
	bne $t7, $t9, multiplicacion
	
        
    potencia: # Si los dos numeros han sido iguales van a esta etiqueta. Compara con el siguiente numero, y si es igual retorna, as� en bucle
              # Si no es igual, imprime el numero con la potencia y vuelve al loop principal
        addi $t2, $t2, 1  #aumento contador de potencia
        addi $a2, $a2, 4
        lw $t3, 0($a2)
        beq $t3, $t7, potencia
        move $a0, $t7  
        li $v0, 1  
        syscall     
        li $v0, 11    # Codigo para imprimir un caracter
        li $a0, 94     # Caracter ? (ASCII = 94)
        syscall
        move $a0, $t2  #El contador de potencia es a lo que elevo el numero
        li $v0, 1  
        syscall     
        beq $t3, $zero, end #Si el siguiente numero era cero acabo
        j loop_impresion  #vuelvo al loop principal
            
    multiplicacion:  # Cuando dos numeros son distintos, imprimo el primero con la multiplicacion, y comparo el siguiente para ver si es igual
                     #si el numero contenido en t7 fuera igual al siguiente me voy a potencia, si no imprimo el numero de t7
        move $a0, $t9
        li, $v0, 1
        syscall
        li $v0, 11     # Codigo para imprimir un caracter
        li $a0, 32      # Caracter de espacio (ASCII = 32)
        syscall
        li $v0, 11
        li $a0, 42     # Asterisco (*) (ASCII = 42)
        syscall
        addi $a2, $a2, 4
        lw $t9, 0($a2)
        beq $t7, $t9, potencia    #Si t7 es igual al siguiente van a potencia, si no continuan
        li $v0, 11     
        li $a0, 32      
        syscall
        move $a0, $t7              #imprimo t7 con su * ya que no era igual al siguiente
        li, $v0, 1
        syscall             
        beq $t9, $zero, end         #Si el anterior numero era 0 ya he acabado
        bne $t9, $zero, loop_impresion       #Si no era 0, vuelvo al bucle principal
        
    multiplicacion_solo:  #Etiqueta transitoria para que cuando haya acabado la funcion, si el siguiente numero no es 0, imprima la multiplicacion
                          #Con lo proximo que venga
        li $v0, 11     
        li $a0, 32      
        syscall
        li $v0, 11 
        li $a0, 42     
        syscall        
        li $t9, 0   #reseteo el t9, ya que sino entrariamos en bucle infinito
        li $v0, 11     
        li $a0, 32      
        syscall
        j loop_impresion       #despues de hacerlo, retorno al bucle principal
        
    final:     #etiqueta de finalizacion, si t9 es 0, lo acabo, si no es 0, lo imprimo y acabo (Casos en los que el numero introducido en pantalla
               #es primo
        beq $t9, $zero, end
        move $a0, $t9
        li $v0, 1
        syscall
        li $v0, 10  #Acabo
        syscall     
        
    end:    
        li $v0, 10  
        syscall     #Acabo



