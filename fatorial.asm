.data

line: .asciiz "-------------------------\n"
ProgramName: .asciiz "Calculadora de Fatorial\n"
message: .asciiz "Entre com um numero a ser fatorado: "
result: .asciiz "Resultado: "

.text

#codigo 4 para a syscall de printar string
li $v0, 4 
la $a0, line
syscall 

li $v0, 4 
la $a0, ProgramName
syscall 

li $v0, 4 
la $a0, line 
syscall 

li $v0, 4 
la $a0, message
syscall 

# codigo 5 para a syscall ler inteiro (read integer)
li $v0, 5 
syscall

move $s0, $v0 	# move a entrada do usuario para s0

li $v0, 4
la $a0, result
syscall
	
move $a0, $s0 	# move a entrada do usuario pro registrador a0 (vai como argumento pra funcao fatorialCalc)
jal fatorialCalc

move $a0, $v0
li $v0, 1 	# syscall pra printar um inteiro
syscall

li $v0, 10 	#syscall pro exit
syscall

fatorialCalc:
	sub $sp, $sp, 8 	# libera espaço na stack de 2 bytes, 2*4 = 8 
	sw $ra, 4($sp)		# salva o endereço de retorno
	sw $a0, 0($sp)		# salva o endereço do argumento
	
	# seria tipo um if (argumento <  1 ) retorna 1 ; senao vai pro else
	slti $t0, $a0, 1	# (argumento < 1) ? t0 = 1 ; t0 = 0
	beq $t0, $zero, else	# se t0 == 0 vai pro else, senao continua
	
	li $v0, 1 		# salva 1 em v0 para retornar 
	add $sp, $sp,8 		# desaloca o espaço na pilha 
	jr $ra 			# retorna 
	
else: 
	sub $a0, $a0, 1 	# subtrai 1 do argumento (n - 1)
	jal fatorialCalc 	#chama a funcao e atuliza endereço de retorno pra proxima instruçao dessa "funcao"

	# ponto de retorno da funcao recursiva
	lw $a0, 0($sp) 		# recupera o argumento passsado que foi salvo na pilha
	lw $ra, 4($sp)		# recupera o endereco de retorno que tambem tinha sido salvo na pilha
	add $sp, $sp, 8		# desaloca o espaço na pilha
	
	mul $v0, $a0, $v0	# multiplica o n(argumento) * fatorialCalc(n -1)
	jr $ra			
	

