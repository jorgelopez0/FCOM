.data
	cadena:         .asciiz "AHRSOMOSOBST"  # Cadena de ejemplo
			.align 2		# Alinea la cadena para almacenar las posiciones en el vector
	vector:         .space 400              # Espacio para 100 palabras, 4 bytes cada una
	entrada_L:      .asciiz "Longitud de los Palindromos: "
	error_N:        .asciiz "Error: la longitud de la cadena es menor que 3.\n"
	error_L:        .asciiz "Error: el valor introducido no es correcto, compruebe que no excede el de la cadena y sea mayor o igual que 3.\n"
	desbordamiento: .asciiz "Se encontraron mas de 100 palindromos. Solo se almacenaron los primeros 100.\n"
	encontrado_msg: .asciiz "Encontrados: "
	posiciones_msg: .asciiz "Posiciones: "
	coma:           .asciiz ", "
	saltoLinea:     .asciiz "\n"

.text
main:
	la $t0, cadena       # Puntero
	li $s5, 0            # $s5 almacenará N
	
contar_loop:
	lb   $t1, 0($t0)     # Iterador de la cadena para contar los caracteres
	beqz $t1, contar_fin # Si es 0, es dcir, terminador de cadena, ha terminado de contar
	addi $s5, $s5, 1     # Se le suma uno al contador de la cadena
	addi $t0, $t0, 1     # Se suma uno al puntero para leer el siguiente caracter
	j contar_loop        # Se continua leyendo los caracteres hasta llegar a 0
	
contar_fin:
	li $t1, 3		 # Cargo uun 3 en $t1 para compararlo
	bge $s5, $t1, busco_L    # Si N ≥ 3, entonces pido L
	
	# Si no aviso de que ha habido un error y salgo
	li $v0, 4
	la $a0, error_N
	syscall
	j salir			 # Salto a la funcion que sale del programa
# Funcion que pide y comprueba la longitud de los palindromos 
busco_L:

	# Pido la longitud de L
	li $v0, 4
	la $a0, entrada_L
	syscall
    
	# Almaceno L en $t0
	li $v0, 5
	syscall
	move $t0, $v0
    
	# Compruebo si 3 <= L <= N
	blt $t0, 3, L_invalida
	bgt $t0, $s5, L_invalida
    
	# Preparo los argumentos para buscaPalindromos	
	la $a0, cadena      # Cargo la direccion de la cadena en $a0
	move $a1, $s5       # Cargo en $a1 el numero de caracteres de la cadena
	move $a2, $t0       # Muevo a $a2 la longitud de los palindromos
	la $a3, vector      # Cargo en $a3 la direccion de la cadenade vecrores
    
	jal buscaPalindromos # LLamo a buscaPalindromos
    
	# Guardo resultados
	move $t0, $v0       # Guardo el número de palíndromos encontrados en $t0
	move $t1, $v1       # Guardo en $t1 si ha habido exito o desbrodamiento
    
	# Imprimo el número de palíndromos encontrados
	li $v0, 4
	la $a0, encontrado_msg
	syscall
    
	# Imprimo el numero de de palindromos encontrados
	li $v0, 1
	move $a0, $t0
	syscall
    
	# Imprimo el salto de linea 
	li $v0, 4
	la $a0, saltoLinea
	syscall
    
	# Imprimo advertencia si hubo desbordamiento, si no salto a imprime_posicion
	beqz $t1, imprime_posicion
	li $v0, 4
	la $a0, desbordamiento
	syscall
    
imprime_posicion:

	# Si no se han encontrado palindromos, salgo 
	beqz $t0, salir
	
	# Imprimo posiciones si hay palíndromos encontrados    
	li $v0, 4
	la $a0, posiciones_msg
	syscall
	    
	la $t2, vector      # Dirección de posiciones
	li $t3, 0           # Contador
    
imprime_loop:

	bge $t3, $t0, salir  # Si se imprimieron todos, salgo
    
	# Imprimo posición
	lw $a0, 0($t2)
	li $v0, 1
	syscall
    
	addi $t3, $t3, 1    # Incrementar contador
	addi $t2, $t2, 4    # Mover a la siguiente posición
    
	# Imprimo coma si no es el último
	bge $t3, $t0, salir
	li $v0, 4
	la $a0, coma
	syscall
    
	j imprime_loop
    
L_invalida:
	# Imprimo mensaje de error por longitud inválida de L
	li $v0, 4
	la $a0, error_L
	syscall
	j salir
    
salir:
	li $v0, 10
	syscall

# Función que buscaPalindromos en la cadena
buscaPalindromos:
	# Guardar registros en pila
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
    
	move $s0, $a0       # Dirección de la cadena
	move $s1, $a1       # Longitud de la cadena N
	move $s2, $a2       # Longitud de los palíndromos a buscar L
	move $s3, $a3       # Dirección del vector de posiciones
    
	li $s4, 0           # Contador de palíndromos encontrados
	li $t3, 0           # Posición actual en la cadena
    
busqueda_loop:
	# Calcular la posición máxima posible (N - L)
	sub $t2, $s1, $s2
	bgt $t3, $t2, fin_busqueda # Si la posicion actual es mayor que la maxima posible, he terminado de buscar
    
	# Preparar argumentos para esPalindromo
	add $a0, $s0, $t3   # Dirección de la subcadena actual
	move $a1, $s2       # Longitud de los palíndromos
	jal esPalindromo    # Llamo a esPalindromo
    
	# Comprobar si es palíndromo
	bnez $v0, no_palindromo
    
	# Solo almacenar si hay espacio
 	li $t8, 100
	bge $s4, $t8, no_espacio
	
	# Guardar la posición actual
	sw $t3, 0($s3)
	addi $s3, $s3, 4
    
no_espacio:
	addi $s4, $s4, 1    # Incrementar contador de palíndromos encontrados
    
no_palindromo:
	addi $t3, $t3, 1    # Mover a la siguiente posición
	j busqueda_loop
    
fin_busqueda:
	move $v0, $s4       # Número de palíndromos encontrados
    
	# Establecer bandera de desbordamiento
	li $t8, 100
	ble $s4, $t8, no_desbordamiento  
	li $v1, 1           # Si hay desbordamiento cargo un 0 en $v1
	j devuelve_busca	    # Salto a devuelve busca para recuperar los valores de la pila y restaurar la pìla
    
no_desbordamiento:
	li $v1, 0
    
devuelve_busca:
	# Restaurar registros
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
    
	jr $ra

# Función esPalindromo que comprueba si una cadena es o no palindroma
esPalindromo:

	ble $a1, 1, es_palindromo    # si longitud <= 1 es palíndromo
    
	# Cargo los primeros y últimos caracteres
	lb $t0, 0($a0)              # Primer carácter
	add $t1, $a0, $a1           # Guardo en $t1 el ultimo caracter
	addi $t1, $t1, -1           # Resto 1 para que no sea el terminador de cadena
	lb $t1, 0($t1)              # Último carácter
    
	bne $t0, $t1, no_esPalindromo # Comparo el primer y el ultimo caracter para ver si puede ser palindromo
    
	# Comprobar la subcadena interna entre los dos caracteres iguales
	addi $sp, $sp, -12          # Guardo en pila el registro ra para la recursividad y $a0, $a1
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
    
	addi $a0, $a0, 1            # Avanzo al siguiente carácter
	addi $a1, $a1, -2           # Reduzco la longitud en 2, ya que he comparado los extremos
    
	jal esPalindromo            # Llamo de nuevo a es palindromo para comparar los caracteres de forma recursiva
    
	# Guardo el resultado de la llamada recursiva y recupero la pila
	move $t2, $v0
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
    
	# Devuelvo el mismo resultado que la llamada recursiva
	move $v0, $t2
	jr $ra       # Vuelvo al primer jal esPalindromo  


es_palindromo:
	li $v0, 0    # Devuelvo un 0 en $v0 si es palindromo
	jr $ra       # Vuelvo al jal esPalindromo de la llamada recursiva


no_esPalindromo:
	li $v0, 1    # Devuelvo un 1 en $v0 si no es palindromo
	jr $ra       # Vuelvo al primer jal esPalindromo
