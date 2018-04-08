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
repeated_insertion_str:		.asciiz "Chave repetida. Insercao nao permitida. \n"
invalid_insertion_str:		.asciiz "Chave invalida. Insira somente numeros binarios(ou -1 retorna ao menu). \n"
enter_removal_str:		.asciiz "Digite o binario para remocao: "
succeeded_removal_str:		.asciiz "Chave removida com sucesso. \n"
search_number_str:		.asciiz "Digite o binario para busca: "

found_key_str:			.asciiz "Chave encontrada na arvore: "		
not_found_key_str:		.asciiz "Chave nao encontrada na arvore: "												
path_str:			.asciiz "Caminho percorrido: "		
menu_return_str:		.asciiz "Retornando ao menu. \n"

esq_str:			.asciiz "esq, "
dir_str:			.asciiz "dir, "
raiz_str:			.asciiz "raiz, "

endl_str:			.asciiz "\n"  #quebra de linha




	.text
	.globl main

main:
	li $a1, 2			# Passando 2 como argumento em a1 para que o nó raiz seja criado
	jal create_node			# Criar o node raiz da arvore
	move $s1, $v0			# Salvar a raiz. Seu endereço está agora na heap
	
	li $v0, 9			# Alocar 16 (4*4) bytes na memoria
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
    	move $s4, $t0		# guardar a opção escolhida em um registrador s4 para uso futuro 
    
  	li $t1, 1
  	li $t2, 2
  	li $t3, 3
  	li $t4, 4
  	li $t5, 5
  
	# switch (1 = Insercao, 2 = Remocao, 3 = Busca, 4 = Visualizacao, 5 = Fim)
	beq $t0, $t1, insert
	beq $t0, $t2, remove
	beq $t0, $t3, search
	beq $t0, $t4, print_tree
	beq $t0, $t5, quit

	j main_loop
			
read_str:
   	li $v0, 8			# Ler uma string vinda do teclado	
   	la $a0, binary_number 		# A string digitada fica salva em binary_number . O $a0 tem o endereço base para a string alocada dinamicamente.
   	li $a1, 16		
    	syscall

    	move $t0, $a0 			# Guardando o numero binario em um registrador para usá-lo durante o processo de verificacao
    
    
    	lb $t1, ($t0) 			# Carregando a primeira posição da string do numero binario em t1
    	lb $t2, 1($t0)			# Carregando a proxima posição da string do numero binario em t2
    
	subi $t3, $t1, 45		# if (string[i] == "-") t3 = 0
    	subi $t4, $t2, 49		# if (string[i + 1] == "1") t4 = 0
   	 		
    
	beq $t3, $t4, print_return	# if (t3 == t4) volte para o menu
					# Se o numero digitado for exatamente o -1 , volte para o menu
	

str_checker_loop:    
   
    beq $t1, 10 , TenToZero		# if( string[i] == '\n' ) Substitua o \n por um outro valor, no caso o \0	
    beq $t1, $zero, end_checker_loop	# if( string[i] == '\0' ) saia do loop de verificacao
    bgt $t1, 49, print_str_err		# if( string[i] > 49 ) imprima a mensagem de erro 
    blt $t1, 48, print_str_err		# if( string[i] < 48 ) imprima a mensagem de erro 
    
    
    addi $t0, $t0, 1			# Some 1 ao endereço base da string para ter acesso ao proximo caractere
    lb $t1, ($t0)			# Carregue o proximo caractere da string 
    j str_checker_loop


TenToZero:			# TenToZero é a substituição do 10 == ENTER por mais um \0 
	
	move $t1, $zero 
	sb $t1, ($t0) 		# O endereço que contem o 10 == ENTER , recebe o valor zero

		
end_checker_loop:

	move $s0, $a0 	# No caso de o numero digitado ser válido, ele será salvo em um registrador s0				
		      	# Até aqui o endereço que é guardado por a0, tem seu conteudo alterado 
		    
	jr $ra

	
print_str_err:			
   	li $v0, 4	
   	la $a0, invalid_insertion_str
  	syscall
    
    	li $s0, -1 	#Carregando um valor negativo em s0 para marcar que a leitura da entrada encontrou um erro
	
    	jr $ra
    
    

print_return:		#imprime "Retornando ao menu.".
   	li $v0, 4
   	la $a0, menu_return_str
   	syscall

   	j main_loop	

#	struct node_trie { t1 = endereco dessa struct
#		node_trie *child_left;  0(t1)
#		node_trie *child_right; 4(t1)
#		int terminator 8(t1)
#	}

create_node:	
			
	subi $sp, $sp, 8		# armazenar o endereco de retorno na pilha
	sw $ra, 0($sp)
	sw $s0, 4($sp)
		
	move $s0, $a0
	li $v0, 9			# alocar 12 (4*3) bytes na memoria
	li $a0, 12
	syscall
		
	li $t9, 0			
	sw $zero, 0($v0)		# node->child_left = NULL;
	sw $zero, 4($v0)		# node->child_right = NULL;
	sw $t9, 8($v0)			# node->terminator = FALSE;
		
	beq $a1, 2, fim_create_node_dir	#Se $a1 == 2 cria-se a raiz
	beq $a1, 1, create_node_dir  	#Se $a0 == 1 insere v0 no filho da direita se nao na esquerda
	sw $v0, 0($s0)			# salva o conteudo de v0 no nó da esquerda
		
	j fim_create_node_dir

create_node_dir:		
	sw $v0, 4($s0)		# salva o conteudo de v0 no nó da direita

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
	
	li $t2, 1		#setando o terminador da raiz como 1
	sw $t2, 8($t1)
			
	bgezal $s0, insert_loop #Se o valor contido em s0 for maior ou igual a zero , pode-se criar um nó valido
	
	j insert


insert_loop:	
															
																
	lb $t2, 0($t0)			
	beq $t2, $zero, end_insert_loop # condição de parada do loop de insercao
	
	
	li $t3 , 48			# 48 == 0 em ascII
	beq $t2, $t3, insert_left	# se num[i] == 0, inserir a esquerda da raiz

	lw $t4, 4($t1)			# carregue o conteudo de node_right
	
	
	seq $t5, $t4, $zero		# se node_right == NULL, t5 = 1, do contrario, t5 = 0
	subi $t5, $t5, 1		# t0 = t0 - 1
	
	
	move $a0, $t1			# Passando o nó atual como parametro em $a0
	li $a1, 1			# Passando 1 como argumento para que seja criado um nó a direita do nó atual
	bgezal $t5, create_node		# Se t0 == 0, node nao existe entao crie. Se t0 < 0, node existe.

			
	
	lw $t1, 4($t1)
	
	addi $t0, $t0, 1		# Acessar o proximo indice do numero (isto eh, i++)

	j insert_loop
	


insert_left:
	
	lw $t4, 0($t1)			# Carregue o conteudo de node_left
	seq $t5, $t4, $zero		# Se node_left == NULL, t4 = 1, do contrario, t4 = 0
	subi $t5, $t5, 1		# t0 = t0 - 1
	
	move $a0, $t1			# Passando o nó atual como parametro em $a0
	li $a1, 0			# Passando 0 como argumento para que seja criado um no a esquerda do no atual
	bgezal $t5, create_node		# Se t0 == 0, node nao existe entao crie. Se t0 < 0, node existe.
	
	lw $t1, 0($t1)
	addi $t0, $t0, 1		# Acessar o proximo indice do numero (isto eh, i++)
	
	j insert_loop			# volte ao loop de insercao

		
end_insert_loop:
	li $v0, 4			# print "Numero inserido com sucesso"
	la $a0, succeeded_insertion_str
	syscall
		
	li $t5, 1 			# O 1 representa um true booleano
	sw $t5, 8($t1) 			# O true será atribuído ao terminador no ultimo nó que será inserido
	
	j insert			# retorne para a insercao , para que um novo valor possa ser inserido


search: 
   	li $v0, 4 			#print "Digite o binario para  busca"
   	la $a0, search_number_str
   	syscall

   	jal read_str			# Verifique se o numero digitado eh valido (binario)
   	
   	blt $s0, $zero, search		# Se string[i] == \0, retorne ao inicio da busca
   	
   	move $t0, $s0			# t0 guarda temporariamente o endereço para a string. 
	move $t1, $s1			# O mesmo ocorre com t1, que agora recebe o endereço para a raiz da arvore
   	move $t9, $s2			# t9 guarda temporariamente o endereço para a string do caminho percorrido


	li $t6, 50			# Colocando o valor 2 ( 50 == 2 em ascII ) na primeira posição da string do caminho percorrido,
	sb $t6, 0($t9)			# para indicar que passamos pela raiz
	addi $t9, $t9, 1		# Acessando a proxima posição da string do caminho percorrido

	lb $t2, 0($t0)			# Guardando o caractere atual do numero binario em t2
	
	beq $t2, 48, node_left		# Se t2 == 48 (caractere 0 em ascII) , vá para a o no da esquerda
	beq $t2, 49, node_right		# Se t2 == 49 (caractere 1 em ascII), vá para a o no da direita
	j search			

node_left:
	
	jal left_path			# Processo que atribui caractere 0 para a posicao atual da string do caminho percorrido

	lw $t2, 0($t1)			# Carregue o conteudo de node_esq para verificar se ele eh NULL
	beq $t2, $zero, not_found	# Se node_esq == NULL , o numero nao foi encontrado
	
	lw $t1, 0($t1)			# Acessando o proximo no da esquerda
	bgezal $s0, search_loop		# Se s0 >= 0, para o loop de busca
   	j search			# Senao retorne para o inicio da busca

node_right:		

	jal right_path			# Processo que atribui caractere 1 para a posicao atual da string do caminho percorrido

	lw $t2, 4($t1)			# Carregue o conteudo de node_right para verificar se ele eh NULL
	beq $t2, $zero, not_found	# Se node_dir == NULL , o numero nao foi encontrado
	
	lw $t1, 4($t1)			# Acessando o proximo no da direita
	bgezal $s0, search_loop		# Se s0 >= 0, va para o loop de busca
   	j search			# Senao retorne para o inicio da busca





search_loop:
	
	
	li $t3, 48			# t3 = 48 (caractere 0 em ascII)
	lb $t5, 1($t0)			# Carregue o conteudo do proximo byte de t0( ou seja, num[i]) em t5, 
					# para verificar se o proximo caracter é o final da string 
	
	beq $t5, $zero, terminator_check# Condicao de parada. Verificação do terminador
	beq $t5, $t3, search_left	# Se num[i] == 0, navegue ao filho esquerdo
	
	jal right_path			# Processo que atribui caractere 1 para a posicao atual da string do caminho percorrido
	
	
	lw $t2, 4($t1)			# Carregue o conteudo de node_right
	beq $t2, $zero, not_found	# Se node_right == NULL, o numero nao esta na arvore
	
		
	addi $t0, $t0, 1		# navegue para o proximo caractere do numero binario
	lw $t1, 4($t1)			# navegue para o endereco do node filho	da direita
	
	j search_loop			# retorne para o loop de busca
	

	
search_left:

	jal left_path			# Processo que atribui caractere 0 para a posicao atual da string do caminho percorrido
		
	lw $t2, 0($t1)			# Carregue o conteudo de node_esq	
	beq $t2, $zero, not_found	# Se node_esq == NULL, o numero nao esta na arvore
	
	addi $t0, $t0, 1		# navegue para o proximo caractere do numero binario
	lw $t1, 0($t1)			# navegue para o endereco do node filho da esquerda
	j search_loop


terminator_check:
		
	lw $t5, 8($t1)			# Coloque o terminador do no atual em t5
	
	beq $t5, $zero, not_found	# Se terminador == 0 , o numero nao foi encontrado
	beq $t5, 1, end_search_loop	# Se terminador == 1 , finalize o loop de busca, pois o numero foi encontrado

	
end_search_loop:
	
	jal end_path			# Processo que marca o final do caminho (fim da string do caminho), com o valor 3

	
	li $v0, 4			# print "Chave encontrada"
	la $a0, found_key_str
	syscall
	
	li $v0, 4			# print numero encontrado
	move $a0, $s0
	syscall
	
	li $v0, 4			# print \n
	la $a0, endl_str
	syscall
	
	jal path_print			# Processo para a impressao da string que contem o caminho percorrido
	j search			# retorne para o inicio da busca
	
	
not_found:
	
	jal end_path			# Coloca uma flag na ultima posição da string 
					# para marcar o fim do caminho 

														
	li $v0, 4			# print "Chave nao encontrada"
	la $a0, not_found_key_str
	syscall
	
	li $v0, 1			# print numero
	li $a0, -1
	syscall
		
	li $v0, 4			# print "\n" 
	la $a0, endl_str
	syscall	
	
		
	jal path_print 			
	
	beq $s4, 2, remove		# Usa o conteudo de s4 setado no inicio do programa para retornar para a função correta
	beq $s4, 3, search


	
path_print:
	li $v0, 4 			# imprimindo a string "Caminho percorrido: "
	la $a0, path_str
	syscall	
	
	move $t9, $s2			# Guardando a primeira posicao da string do caminho em t9
	
path_print_loop:
	
	lb $t0, ($t9)

					# Imprimindo o caminho de acordo com os valores contidos na string armazenada em t9
	beq $t0, 48, print_esq_str	# Se a posicao atual da string tiver o valor 0, imprima "esq, "
	beq $t0, 49, print_dir_str	# Se a posicao atual da string tiver o valor 1, imprima "dir, "	
	beq $t0, 50, print_root		# Se a posicao atual da string tiver o valor 2, imprima "raiz, "
	beq $t0, 51 ,end_path_loop 	# Se a posicao atual da string tiver o valor 3, saia do processo de impressao
	
left_path:
	
	li $t6, 48			# Guardando o valor 0, que indica que fui pra esquerda , na posição atual de t9
	sb $t6, ($t9)			
	addi $t9, $t9, 1
	jr $ra

right_path:

	li $t6, 49			# Guardando o valor 1, que indica que fui pra direita , na posição atual de t9
	sb $t6, ($t9)			
	addi $t9, $t9, 1
	jr $ra

end_path:

	li $t6, 51			# flag que será armazenada na ultima posição da string( 51 == 3 em ascII )
	sb $t6, ($t9)
	jr $ra


print_root:
	li $v0, 4			
	la $a0, raiz_str
	syscall	
	
	addi $t9, $t9, 1
	
	j path_print_loop
			
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
	
	
	jr $ra		# Retornando ao processo que chamou print_path_loop


remove: 
  	li $v0, 4 			# Print "Digite o binario para remocao"
	la $a0, enter_removal_str
	syscall

	jal read_str			# Verifique se o binario digitado é valido, invalido ou -1
	
	move $t0, $s0			# Numero a ser removido
	move $t1, $s1			# Raiz da arvore
	move $t9, $s2			# String que representa o caminho percorrido
	
	la $t2, ($s1)			# ultimo terminador TRUE lido
	
	li $t6, 50			
	sb $t6, 0($t9)			# Guardando o valor 2 na string do caminho percorrido para indicar que passamos pela raiz
	addi $t9, $t9, 1		# Ir para a proxima posição da string do caminho percorrido
	
	bgezal $s0, remove_loop		# Se o numero eh valido, entre no loop de remocao
	j remove

remove_loop:
	lb $t3, ($t0)			# Carregue num[i]
	beq $t3, 48, remove_left	# Se num[i] == 0, navegue para o filho esquerdo
	
	jal right_path
	
	lw $t3, 4($t1)			# Obtenha o conteudo de node_right
	beq $t3, $zero, not_found	# Se node_right == NULL, a chave nao existe na arvore
	
	lw $t3, 8($t1)			# Guarde terminator do node atual

	lb $t5, 1($t0)			# Carregue num[i+1]
	beq $t5, $zero, remove_check	# Remova o numero, checando o ultimo terminador TRUE lido
	
	addi $t0, $t0, 1
	lw $t1, 4($t1)
	beq $t3, 0, remove_loop		# Guarde o terminador apenas se ele for TRUE para o node atual
	beq $t3, 1, store_terminator	
	
remove_left:
	jal left_path
	
	lw $t3, 0($t1)			# Obtenha o conteudo de node_esq
	beq $t3, $zero, not_found	# Se node_esq == NULL, a chave nao existe na arvore
	
	lw $t3, 8($t1)

	lb $t5, 1($t0)			# Carregue num[i+1]
	beq $t5, $zero, remove_check	# Remova o numero, checando o ultimo terminador TRUE lido
	
	addi $t0, $t0, 1
	lw $t1, 0($t1)
	beq $t3, 0, remove_loop		# Guarde o terminador se ele for TRUE para o node atual
	
store_terminator:
	la $a0, ($t1)			# Guarde o ultimo node de terminador TRUE lido
	lb $a1, ($t0)			# Guarde o seu filho que pertenca ao numero a ser removido
	j remove_loop
	
remove_check:
	lw $t2, 0($t1)			# Carregue node_left do ultimo node de terminador TRUE lido
	lw $t3, 4($t1)			# Carregue node_right do ultimo node de terminador TRUE lido
	sne $t4, $t2, $zero		# Se node_left != NULL, t2 = 1, do contrario, t2 = 0
	sne $t5, $t3, $zero		# Se node_right != NULL, t3 = 1, do contrario, t3 = 0
	add $t4, $t4, $t5		# t4 = t4 OR t5 (se houver ao menos um filho, t4 = TRUE)
	lw $t5, 8($t1)			# Carregue o terminator do ultimo node visitado
	sne $t5, $t4, 1			# Se o ultimo node visitado tiver pelo menos um filho, terminator = FALSE
	beq $t5, 0, null_t_child	# Se nao tiver filhos, remova o filho do ultimo node de terminator TRUE lido
					# que pertenca ao numero a ser removido
	
end_remove_loop:
	
	jal end_path			# Setando uma flag para indicar fim do caminho
	
	li $v0, 4			# print "Chave encontrada"
	la $a0, found_key_str
	syscall
	
	li $v0, 4			# print numero
	move $a0, $s0
	syscall
	
	li $v0, 4			# print "\n" 
	la $a0, endl_str
	syscall
	
	jal path_print			
	
	li $v0, 4			# print "Chave removida com sucesso"
	la $a0, succeeded_removal_str
	syscall
	
	j remove
	
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
		
