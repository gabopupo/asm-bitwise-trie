# =====================================================================================
#		Trabalho 1 de Organizacao de Computadores Digitais I
#
#         Filename:  T1.asm 
#  	  Description:  Implementacao de uma Arvore de Busca Digital Binaria 
#
#         Nome:	Eduardo Zaboto Mirolli			No USP:	9778501
#	  Participacao:	
#
#         Nome:	Paulo Henrique Bodnarchuki da Cruz	No USP:	9790944
#	  Participacao:
#
#         Nome:	Gabriel Romualdo Silveira Pupo 		No USP: 9896250
#	  Participacao:
#
# =====================================================================================

	.data
	.align 0

menu:	.asciiz "1 - Inserir\n2 - Remover\n3 - Buscar\n4 - Visualizar\n5 - Sair\nEscolha uma operacao (1 a 5): "
binary_number: .space 16 
                                                                         
enter_insertion_str:		.asciiz "Digite o binario para insercao: "
succeeded_insertion_str:	.asciiz "Chave inserida com sucesso. \n"
repeated_insertion_str:		.asciiz "Chave repetida. Insercao nao permitida \n"
invalid_insertion_str:		.asciiz "Chave invalida. Insira somente numeros binarios(ou -1 retorna ao menu) \n"
enter_removal_str:		.asciiz "Digite o binario para remocao: "
succeeded_removal_str:		.asciiz "Chave removida com sucesso. \n"
search_number_str:		.asciiz "Digite o binario para busca: "

found_key_str:			.asciiz "Chave encontrada na arvore: "		
not_found_key_str:		.asciiz "Chave nao encontrada na arvore: "												
path_str:			.asciiz "Caminho percorrido: "		
menu_return_str:		.asciiz "Retornando ao menu. \n"

endl_str:			.asciiz "\n"

success: .asciiz "Entrei na função \n"

	.text
	.globl main

main:
	jal create_node			# criar o node raiz da arvore
	move $s1, $v0			# salvar a raiz
	
main_loop:
	li $v0, 4		# imprimir menu na tela
	la $a0, menu
	syscall
	
	li $v0, 5		# ler opcao escolhida do teclado
	syscall
	move $t0, $v0
    
  	li $t1, 1
  	li $t2, 2
  	li $t3, 3
  	li $t4, 4
  	li $t5, 5
  
		# switch (1 = inserir, 2 = remover, 3 = buscar, 4 = ver arvore, 5 = sair)
	beq $t0, $t1, insert
	beq $t0, $t2, remove
	beq $t0, $t3, search
	beq $t0, $t4, print_tree
	beq $t0, $t5, quit

	j main_loop
			
read_str:
    li $v0, 8
    la $a0, binary_number # a string digitada fica salva em binary_number
    li $a1, 16
    syscall

    move $t1, $a0 # guardando o numero binario em um registrador para usá-lo durante esse processo
    
    lb $t0, 0($t1)
    beq $t0, 45, print_return # 45 == ascII para " - " ---> if(string[i] == '-') 

str_checker_loop:    
   
    beq $t0, 10 , TenToZero	#TenToZero é a conversão do 10 == ENTER para um \0 
    beq $t0, $zero, end_loop	# if( string[i] == '\0' )  
    bgt $t0, 49, print_err	# if( string[i] > 49 ) --> se o caractere for maior do que o 1 em ASCII, imprima uma mensagem de erro 
    blt $t0, 48, print_err	# if( string[i] < 48 )
    
    
    addi $t1, $t1, 1		# some 1 ao endereço base da string para ter acesso ao seu proximo caractere
    lb $t0, ($t1)		# carregue o proximo byte da string no byte mais a direita do registrador $t0
    j str_checker_loop


TenToZero:
	
	li $t0, 0
	sb $t0, ($t1)
	
end_loop:
	move $s0, $a0 # no caso de o numero digitado ser válido, ele será salvo em um registrador s0
			#problema: o a0 armazenado 
	jr $ra


print_err:
   	li $v0, 4	
   	la $a0, invalid_insertion_str
  	syscall
    
    	li $s0, -1 	#carregando um valor negativo em s0 para marcar que a leitura da entrada encontrou um erro
	
    	jr $ra
    
    

print_return:
    li $v0, 4
    la $a0, menu_return_str
    syscall

    j main_loop	


create_node:	
		
		
		
		subi $sp, $sp, 4		# armazenar o endereco de retorno na pilha
		sw $ra, 0($sp)
		
		li $v0, 9			# alocar 12 (4*3) bytes na memoria
		li $a0, 12
		syscall
		
		li $t0, 1
		sw $zero, 0($v0)		# node->child_left = NULL;
		sw $zero, 4($v0)		# node->child_right = NULL;
		sw $t0, 8($v0)			# node->terminator = TRUE;
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
	
		jr $ra		



insert:		
	
   	li $v0, 4 
   	la $a0, enter_insertion_str
	syscall

	jal read_str

	move $t0, $s0	
	move $t1, $s1
	
	bgezal $s0, insert_loop #se o valor contido em s0 for maior ou igual a zero , pode-se criar um nó valido
	
	j insert

insert_loop:	

			
	lb $t3, ($t0)			
	beq $t3, $zero, end_insert_loop # condição de parada!
	
	
	li $t3 , 48			# 48 == 0 em ascII
	beq $t0, $t3, insert_left	# se num[i] == 0, inserir a esquerda da raiz
	lw $t2, 4($t1)			# carregue o conteudo de node_right
	seq $t4, $t0, $zero		# se node_right == NULL, t4 = 1, do contrario, t4 = 0
	subi $t4, $t4, 1		# t0 = t0 - 1
	bgezal $t4, create_node		# se t0 == 0, node nao existe entao crie. se t0 < 0, node existe.

	sw $v0, 4($t1)			# node_right recebe o node criado ($v0 contem o retorno de create_node)
	
	addi $t1, $t1, 12		# acessar o endereco do proximo node
	addi $t0, $t0, 1		# acessar o proximo indice do numero (isto eh, i++)

	j insert_loop

	
#	struct node_trie {
#		node_trie *child_left;
#		node_trie *child_right;
#		int terminator
#	}

insert_left:
	lw $t2, 0($t1)			# carregue o conteudo de node_left
	seq $t4, $t0, $zero		# se node_left == NULL, t4 = 1, do contrario, t4 = 0
	subi $t4, $t4, 1		# t0 = t0 - 1
	bgezal $t4, create_node		# se t0 == 0, node nao existe entao crie. se t0 < 0, node existe.
	
	sw $v0, 0($t0)			# node_left recebe o node criado ($v0 contem o retorno de create_node)
	addi $t1, $t1, 12		# acessar o endereco do proximo node
	addi $t0, $t0, 1		# acessar o proximo indice do numero (isto eh, i++)
	j insert_loop			# volte ao loop de insercao

		
end_insert_loop:
	li $t4, 1 			# O 1 representa um true booleano
	sw $t4, 8($s1) 			# O true será atribuído ao terminador no ultimo nó que será inserido
	
	
	j insert



search: 
   	li $v0, 4 
   	la $a0, search_number_str
   	syscall

   	jal read_str
   	move $t0, $s0	
	move $t1, $s1
   	
   	bgezal $s0, search_loop
		# TODO	
   	j search


search_loop:
	lb $t3, ($t0)
	beq $t3, $zero, end_search_loop # condicao de parada
	
	li $t3, 48			# 48 == 0 em ascII
	lb $t4, ($t0)			# carregue num[i]
	beq $t4, $t3, search_left	# se num[i] == 0, navegue ao filho esquerdo
	
	lw $t2, 4($t1)			# carregue o conteudo de node_right
	beq $t2, $zero, not_found	# se node_right == NULL, o numero nao esta na arvore
	
	addi $t0, $t0, 1		# i++
	la $t1, 4($t1)			# navegue para o endereco do node filho
	
	j search_loop
	
search_left:
	lw $t2, 0($t1)
	beq $t2, $zero, not_found
	
	addi $t0, $t0, 1
	la $t1, 0($t1)
	j search_loop
	
	
end_search_loop:
	li $v0, 4				# print "Chave encontrada"
	la $a0, found_key_str
	syscall
	
	li $v0, 4				# print numero
	move $a0, $t7
	syscall
	
	# TODO: caminho percorrido
	j main_loop
	
not_found:
	li $v0, 4				# print "Chave nao encontrada"
	la $a0, not_found_key_str
	syscall
	
	li $v0, 1				# print numero
	li $a0, -1
	syscall
	
	# TODO: caminho percorrido
	j main_loop







remove: 
    li $v0, 4 
    la $a0, enter_removal_str
    syscall

    jal read_str

    j remove
		# TODO



print_tree:
	 	j main_loop
		# TODO

quit:
	  li $v0, 10
	  syscall
		# TODO
