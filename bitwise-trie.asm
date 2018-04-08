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

menu:		.asciiz "1 - Inserir\n2 - Remover\n3 - Buscar\n4 - Visualizar\n5 - Sair\nEscolha uma operacao (1 a 5): "
binary_number: 	.space 16 


                                                                         
enter_insertion_str:		.asciiz "Digite o binario para insercao: "
succeeded_insertion_str:	.asciiz "Chave inserida com sucesso. \n"
repeated_insertion_str:		.asciiz "Chave repetida. Insercao nao permitida \n"
invalid_insertion_str:		.asciiz "Chave invalida. Insira somente numeros binarios(ou -1 retorna ao menu) \n"
enter_removal_str:		.asciiz "Digite o binario para remocao: "
succeeded_removal_str:		.asciiz "Chave removida com sucesso. \n"
search_number_str:		.asciiz "Digite o binario para busca: "


found_key_str:			.asciiz "Chave encontrada na arvore: "		
not_found_key_str:		.asciiz "Chave nao encontrada na arvore: "												
path_str:			.asciiz "\nCaminho percorrido: "		
menu_return_str:		.asciiz "Retornando ao menu. \n"


esq_str:			.asciiz "esq, "
dir_str:			.asciiz "dir, "
raiz_str:			.asciiz "raiz, "


endl_str:			.asciiz "\n"




success: .asciiz "Entrei na função \n"

	.text
	.globl main

main:
	li $a1, 2
	jal create_node			# criar o node raiz da arvore
	move $s1, $v0			# salvar a raiz. Seu endereço está agora na heap
	
	li $v0, 9			# alocar 16 (4*4) bytes na memoria
	li $a0, 16
	syscall

	move $s2, $v0			# s2 guarda o vetor que representa o caminho percorrido
			
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
    la $a0, binary_number # a string digitada fica salva em binary_number . O $a0 tem o endereço base para a string alocada dinamicamente.
    li $a1, 16
    syscall

    move $t0, $a0 # guardando o numero binario em um registrador para usá-lo durante esse processo
    
    lb $t1, ($t0)
    beq $t1, 45, print_return # 45 == ascII para " - " ---> if(string[i] == '-') 

str_checker_loop:    
   
    beq $t1, 10 , TenToZero	#TenToZero é a conversão do 10 == ENTER para um \0 
    beq $t1, $zero, end_loop	# if( string[i] == '\0' )  
    bgt $t1, 49, print_err	# if( string[i] > 49 ) --> se o caractere for maior do que o 1 em ASCII, imprima uma mensagem de erro 
    blt $t1, 48, print_err	# if( string[i] < 48 )
    
    
    addi $t0, $t0, 1		# some 1 ao endereço base da string para ter acesso ao proximo caractere
    lb $t1, ($t0)		# carregue o proximo byte da string no byte mais a direita do registrador $t0
    j str_checker_loop


TenToZero:
	
	move $t1, $zero 
	sb $t1, ($t0) #o endereço que contem o 10 == ENTER , recebe o valor zero, o que substitui o ENTER 
	
end_loop:
	move $s0, $a0 # no caso de o numero digitado ser válido, ele será salvo em um registrador s0				
		      #até aqui o endereço que é guardado por a0, tem seu CONTEUDO alterado 
		      #Significa que na proxima vez que acessar esse endereço usando um registrador temporario, o conteudo dele poderá ser diferente
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
		
		
		subi $sp, $sp, 8		# armazenar o endereco de retorno na pilha
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		
		move $s0, $a0
		li $v0, 9			# alocar 12 (4*3) bytes na memoria
		li $a0, 12
		syscall
		
		li $t9, 0			#OBS.: se atribuir a $t0, eu perco a referencia para a string que contem o numero binario
		sw $zero, 0($v0)		# node->child_left = NULL;
		sw $zero, 4($v0)		# node->child_right = NULL;
		sw $t9, 8($v0)			# node->terminator = FALSE;
		
		beq $a1, 2, fim_create_node_dir	#se $a1 == 2 cria-se a raiz
		beq $a1, 1, create_node_dir  	#Se $a0 == 1 insere v0 no filho da direita se nao na esquerda
		sw $v0, 0($s0)			# salva o conteudo de v0 no nó da esquerda
		
		j fim_create_node_dir

create_node_dir:		
		sw $v0, 4($s0)			# salva o conteudo de v0 no nó da direita

fim_create_node_dir:
		
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
	
		jr $ra		



insert:		
	
   	li $v0, 4 
   	la $a0, enter_insertion_str
	syscall

	jal read_str

	move $t0, $s0	
	move $t1, $s1
	
	li $t2, 1		#setando a raiz com o terminador 1
	sw $t2, 8($t1)
			
	bgezal $s0, insert_loop #se o valor contido em s0 for maior ou igual a zero , pode-se criar um nó valido
	
	j insert


insert_loop:	
	
						
															
																
	lb $t2, 0($t0)			
	beq $t2, $zero, end_insert_loop # condição de parada!
	
	
	li $t3 , 48			# 48 == 0 em ascII
	beq $t2, $t3, insert_left	# se num[i] == 0, inserir a esquerda da raiz

	lw $t4, 4($t1)			# carregue o conteudo de node_right
	
	
	seq $t5, $t4, $zero		# se node_right == NULL, t5 = 1, do contrario, t5 = 0
	subi $t5, $t5, 1		# t0 = t0 - 1
	
	
	move $a0, $t1			#Passando o nó atual como parametro em $a0
	li $a1, 1
	bgezal $t5, create_node		# se t0 == 0, node nao existe entao crie. se t0 < 0, node existe.

	

		
	#addi $t1, $t1, 12		# acessar o endereco do proximo node
	lw $t1, 4($t1)
	addi $t0, $t0, 1		# acessar o proximo indice do numero (isto eh, i++)

	j insert_loop

	
#	struct node_trie { t1 = endereco dessa struct
#		node_trie *child_left;  0(t1)
#		node_trie *child_right; 4(t1)
#		int terminator 8(t1)
#	}

insert_left:
	
	lw $t4, 0($t1)			# carregue o conteudo de node_left
	seq $t5, $t4, $zero		# se node_left == NULL, t4 = 1, do contrario, t4 = 0
	subi $t5, $t5, 1		# t0 = t0 - 1
	
	move $a0, $t1			#passando argumentos que serão usados na função de criar o nó
	li $a1, 0
	bgezal $t5, create_node		# se t0 == 0, node nao existe entao crie. se t0 < 0, node existe.
	
	
	#addi $t1, $t1, 12		# acessar o endereco do proximo node
	lw $t1, 0($t1)
	addi $t0, $t0, 1		# acessar o proximo indice do numero (isto eh, i++)
	
	j insert_loop			# volte ao loop de insercao

		
end_insert_loop:
	li $v0, 4
	la $a0, succeeded_insertion_str
	syscall
		
	li $t5, 1 			# O 1 representa um true booleano
	sw $t5, 8($t1) 			# O true será atribuído ao terminador no ultimo nó que será inserido
	
	
	j insert



search: 
   	li $v0, 4 
   	la $a0, search_number_str
   	syscall

   	jal read_str
   	move $t0, $s0		#$t0 guarda temporariamente o endereço para a string. As alterações feitas em t0 , afetam diretamente o endereço
   				# por ele guardado
   				#OBS.: Lembre-se que s0 vem de a0, que armazenava o endereço da string alocada dinamicamente
	move $t1, $s1		# o mesmo ocorre com t1, que agora recebe o endereço para a raiz da arvore
   	#move $t9, $s2		#OBS.: Só estou guardando em s0 e s1 , pq acredito que eles serão uteis a outras funções
   	
   	
   	bgezal $s0, search_loop
		# TODO	
   	j search


search_loop:
	
	#beq $t0, $zero, terminator_check
	#lb $t3, ($t0)
	
	lw $t7, 8($t1)
	
	li $v0, 1
	la $a0, ($t7)
	syscall
	
	
	li $t3, 48			# 48 == 0 em ascII
	lb $t4, ($t0)			# carregue o conteudo do byte de t0( ou seja, num[i]) em t4 
	lb $t5, 1($t0)			# carregue o conteudo do proximo byte de t0( ou seja, num[i]) em t5, para verificar se o proximo caracter é o final da string 
	
	
	beq $t4, $t3, search_left	# se num[i] == 0, navegue ao filho esquerdo
	beq $t5, $zero, terminator_check # condicao de parada. Verificação do terminador
	
	#sb $t4, ($t0)			# guarde a posição atual da numero binario em t9, que guarda temporariamente o caminho percorrido		
	#addi $s0, $s0, 1
	
	
	#la $t2, 4($t1)			# carregue o endereço do conteudo de node_right(não é isso que quero)
	lw $t2, 4($t1)			# carregue o conteudo de node_right
	beq $t2, $zero, not_found	# se node_right == NULL, o numero nao esta na arvore
	
		
	addi $t0, $t0, 1		# i++
	lw $t1, 4($t1)			# navegue para o endereco do node filho
	
	j search_loop
	
	
search_left:

	#beq $t0, $zero, terminator_check
	
	#sb $t4, ($t0)			# guarde a posição atual da numero binario em t9, que guarda temporariamente o caminho percorrido		
	#addi $s0, $s0, 1
	beq $t5, $zero, terminator_check
	
	lw $t2, 0($t1)
	beq $t2, $zero, not_found
	
	addi $t0, $t0, 1
	lw $t1, 0($t1)
	j search_loop


terminator_check:

	
	lw $t5, 8($t1)
	
	li $v0, 1
	la $a0, ($t5)
	syscall
	
	
	beq $t5, $zero, not_found
	beq $t5, 1, end_search_loop

		
			
	
end_search_loop:
	
	#subi $t9, $t9, 5
	#move $s2, $t9				# salvando a string do caminho percorrido em s2
	#li $t8, 50				# flag para indicar que a busca terminou 50 == 2 em ascII
	
	#sb $t8, ($s0)
	
	li $v0, 4				# print "Chave encontrada"
	la $a0, found_key_str
	syscall
	
	li $v0, 4				# print numero
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, endl_str
	syscall
	
	#jal path_print			# TODO: Caminho percorrido
	j search
	
	
not_found:
	
	
	#move $s2, $t9				# salvando a string do caminho percorrido em s2
	
	li $v0, 4				# print "Chave nao encontrada"
	la $a0, not_found_key_str
	syscall
	
	li $v0, 1				# print numero
	li $a0, -1
	syscall
	
	li $v0, 4
	la $a0, endl_str
	syscall
	
	#jal path_print 			# TODO: caminho percorrido

	j search



	

path_print:
	li $v0, 4 			#imprimindo a string "caminho percorrido"
	la $a0, path_str
	syscall
	
	li $v0, 4
	la $a0, raiz_str
	syscall

	li $v0, 4
	la $a0, ($s0)
	syscall
	
	
path_print_loop:
	
	move $t9, $s2
		
	lb $t0, ($t9)

	beq $t0, 48, print_esq_str	
	beq $t0, 49, print_dir_str		
	beq $t0, 50 ,end_path_loop 	
	
			
print_esq_str:
	li $v0, 4
	la $a0, esq_str
	syscall
	
	addi $t9, $t9, 1
	
	j path_print_loop

print_dir_str:
	li $v0, 4
	la $a0, dir_str
	syscall
	
	addi $t9, $t9, 1
	
	j path_print_loop

end_path_loop:
	
	li $v0, 4
	la $a0, endl_str
	syscall
	
	
	jr $ra		#retornando ao processo que chamou print_path_loop




remove: 
  	li $v0, 4 
	la $a0, enter_removal_str
	syscall

	jal read_str
	move $t0, $s0			# numero a ser removido
	move $t1, $s1			# raiz da arvore
	la $t2, ($s1)			# ultimo terminador TRUE lido
	
	bgezal $s0, remove_loop		# se o numero eh valido, entre na remocao
	j remove

remove_loop:
	lb $t3, ($t0)			# carrgue num[i]
	beq $t3, 48, remove_left	# se num[i] == 0, navegue para o filho esquerdo
	
	lw $t3, 4($t1)			# obtenha o conteudo de node_right
	beq $t3, $zero, not_found	# se node_right == NULL, a chave nao existe na arvore
	
	lw $t3, 8($t1)			# guarde terminator do node atual

	lb $t5, 1($t0)			# carregue num[i+1]
	beq $t5, $zero, remove_check	# remova o numero, checando o ultimo terminador TRUE lido
	
	addi $t0, $t0, 1
	lw $t1, 4($t1)
	beq $t3, 0, remove_loop		# guarde o terminador apenas se ele for TRUE para o node atual
	beq $t3, 1, store_terminator	
	
remove_left:
	lw $t3, 0($t1)			# obtenha o conteudo de node_right
	beq $t3, $zero, not_found	# se node_right == NULL, a chave nao existe na arvore
	
	lw $t3, 8($t1)

	lb $t5, 1($t0)			# carregue num[i+1]
	beq $t5, $zero, remove_check	# remova o numero, checando o ultimo terminador TRUE lido
	
	addi $t0, $t0, 1
	lw $t1, 0($t1)
	beq $t3, 0, remove_loop		# guarde o terminador se ele for TRUE para o node atual
	
store_terminator:
	la $a0, ($t1)			# guarde o ultimo node de terminador TRUE lido
	lb $a1, ($t0)			# guarde o seu filho que pertenca ao numero a ser removido
	j remove_loop
	
remove_check:
	lw $t2, 0($t1)			# carregue node_left do ultimo node de terminador TRUE lido
	lw $t3, 4($t1)			# carregue node_right do ultimo node de terminador TRUE lido
	sne $t4, $t2, $zero		# se node_left != NULL, t2 = 1, do contrario, t2 = 0
	sne $t5, $t3, $zero		# se node_right != NULL, t3 = 1, do contrario, t3 = 0
	add $t4, $t4, $t5		# t4 = t4 OR t5 (se houver ao menos um filho, t4 = TRUE)
	lw $t5, 8($t1)			# carregue o terminator do ultimo node visitado
	sne $t5, $t4, 1			# se o ultimo node visitado tiver pelo menos um filho, terminator = FALSE
	beq $t5, 0, null_t_child	# se nao tiver filhos, remova o filho do ultimo node de terminator TRUE lido
					# que pertenca ao numero a ser removido
	
end_remove_loop:
	li $v0, 4				# print "Chave encontrada"
	la $a0, found_key_str
	syscall
	
	li $v0, 4				# print numero
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, endl_str
	syscall
	
	# TODO: caminho percorrido
	
	li $v0, 4
	la $a0, succeeded_removal_str
	syscall
	
	j main_loop
	
null_t_child:
	beq $a1, 49, null_right
	sw $zero, 0($a0)
	j end_remove_loop
	
null_right:
	sw $zero, 4($a0)
	j end_remove_loop

print_tree:
	 	j main_loop
		# TODO

quit:
	  li $v0, 10
	  syscall
		# TODO
