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
menu_str:	                .asciiz "===============================\nMENU\n\n1 - Inserir elemento\n2 - Remover elemento\n3 - Buscar elemento\n4 - Visualizar arvore\n5 - Sair do programa\n\n===============================\nOpção: "

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
	
mainloop:	li $v0, 4		# imprimir menu na tela
		la $a0, menu_str
		syscall
	
		li $v0, 5		# ler opcao escolhida do teclado
		syscall
		move $t0, $v0
	
		li $t5, 1
		li $t6, 2
		li $t7, 3
		li $t8, 4
		li $t9, 5

		# switch (1 = inserir, 2 = remover, 3 = buscar, 4 = ver arvore, 5 = sair)
		beq $t0, $t5, insert
		beq $t0, $t6, remove
		beq $t0, $t7, search
		beq $t0, $t8, visual
		beq $t0, $t9, quit

		j main
			
#	struct node_trie {
#		node *child_left;
#		node *child_right;
#		int terminator
#	}

insert:		j main
		# TODO

remove: 	j main
		# TODO

search: 	j main
		# TODO

visual: 	j main
		# TODO

quit:		# TODO	