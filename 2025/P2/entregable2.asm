.data
	rs: .space 5
	pedir: .asciiz "Ingrese un numero: "
	NoR: .asciiz "La instruccion no es de tipo R"
	valores:.asciiz "$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"
.text
    main:
        jal pedirNumero      
    	move $a0, $v0 # en a0 tenemos el numero metido por teclado
    	la $s0, rs
    	move $a1,$s0
    	jal mascara
    	move $a0, $s0         # Mueve el nombre del registro encontrado a $a0
    	li $v0, 4             # Carga el codigo de la syscall para imprimir un string
    	syscall
        li $v0, 10           
        syscall
    pedirNumero:
        li $v0, 4           
        la $a0, pedir        
        syscall               
        li $v0, 5            
        syscall    	
        jr $ra
    mascara:
    	move $t3, $a1
        addi $sp,$sp,-16
        sw $ra,0($sp)
        sw $s0,4($sp)
        sw $s1,8($sp)
        sw $s2,12($sp) 
    	li $t0,0xFC000000
    	and $t1, $t0, $a0
    	bne $t1,$zero,final #va a final si no es de tipo r
    	li $t2,0x03E00000
    	and $t2,$t2,$a0 #tenemos rs
    	srl $t2,$t2,21
    	move $a0,$t2
    	la $a1, valores
    	jal cuenta
    	move $s0,$v0
    seguir:
    	lb $t4, 0($s0)
    	sb $t4, 0($t3)
    	addi $s0,$s0,1
    	addi $t3,$t3,1
    	bne $t4,$zero,seguir
    	
    final:
   	li $v0,0
   	lw $ra,0($sp)
   	lw $s0,4($sp)
   	lw $s1,8($sp)
   	lw $s2,12($sp)
   	addi $sp,$sp,16
   	jr $ra
    	
    	
    	
cuenta: 
       sll $a0, $a0, 2        
       bne $a0, $zero, norestar  
       addi $a0, $a0, -2      
norestar:
    addi $a0, $a0, 2       
    add $v0, $a1, $a0      
    jr $ra
   
   
   
   

   	
