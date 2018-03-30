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

menu:	.asciiz "1 - Inserção, \n2 - Remoção, \n3 - Busca, \n4 - Visualização, \n5 - Fim. \nEscolha uma opção (1 a 5): "
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

	.text
	.globl main
		
main:
		li $v0, 4		# imprimir menu na tela
		la $a0, menu_str
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

		j main
			
read_str:
    li $v0, 8
    la $a0, binary_number # a string digitada fica salva em binary_number
    li $a1, 16
    syscall

    move $s0, $a0
    lb $t0, 0($s0)
    beq $t0, 45, print_return # 45 == ascII para " - " 

str_checker_loop:
    beq $t0, $zero, end_loop
    bgt $t0, 49, print_err
    addi $s0, $s0, 1
    lb $t0, ($s0)
    j str_checker_loop

end_loop:			
    jr $ra

print_err:
    li $v0, 4
    la $a0, invalid_insertion_str
    syscall

    jr $ra

print_return:
    li $v0, 4
    la $a0, menu_return_str
    syscall

    j main	

insert:		
	jal create_node
    
   	li $v0, 4 
   	la $a0, enter_insertion_str
    	syscall

    jal read_str

    j insert

		# TODO

#	struct node_trie {
#		node_trie *child_left;
#		node_trie *child_right;
#		int terminator
#	}

create_node:	
		subi $sp, $sp, 4		# armazenar o endereco de retorno na pilha
		sw $ra, 0($sp)
		
		li $v0, 9			# alocar 12 (4*3) bytes na memoria
		li $a0, 12
		syscall
		
		sw $zero, 0($v0)		# node->child_left = NULL;
		sw $zero, 4($v0)		# node->child_right = NULL;
		sw $zero, 8($v0)		# node->terminator = FALSE;
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra		

remove: 
    li $v0, 4 
    la $a0, enter_removal_str
    syscall

    jal read_str

    j remove
		# TODO

search: 
    li $v0, 4 
    la $a0, search_number_str
    syscall

    jal read_str

    j search
		# TODO

print_tree:
	 	j main
		# TODO

quit:
	  li $v0, 10
	  syscall
		# TODO
