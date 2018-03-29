# =====================================================================================
#		Trabalho 1 de Organização de Computadores Digitais I
#
#         Filename:  T1.asm 
#  	  Description:  Implementação de uma Árvore de Busca Digital Binária 
#
#         Nome:	Eduardo Zaboto Mirolli			Nº USP:9778501
#	  Participação:	
#
#         Nome:				 		Nº USP:	
#	  Participação:
#
#         Nome:				 		Nº USP:
#	  Participação:
#
#         Nome:						Nº USP:
#	  Participação:
#
# =====================================================================================

	.data
	.align 0

menu:	.asciiz "1 - Inserção, \n2 - Remoção, \n3 - Busca, \n4 - Visualização, \n5 - Fim. \nEscolha uma opção (1 a 5): "	
binary_number: .space 16 #each character is one ascII letter


enter_insertion_str:		.asciiz "\nDigite o binário para inserção: "
succeeded_insertion_str:	.asciiz "Chave inserida com sucesso. \n"
repeated_insertion_str:		.asciiz "Chave repetida. Inserção não permitida \n"
invalid_insertion_str:		.asciiz "Chave inválida. Insira somente números binários(ou -1 retorna ao menu) \n"
enter_removal_str:		.asciiz "Digite o binário para remoção: "
succeeded_removal_str:		.asciiz "Chave removida com sucesso. \n"
search_number_str:		.asciiz "Digite o binário para busca: "


found_key_str:		.asciiz "Chave encontrada na arvore: "		
not_found_key_str:	.asciiz "Chave não encontrada na arvore: " #quando ocorrer essa string preciso escrever o -1 pra voltar pro menu												
path_str:		.asciiz "Caminho percorrido: "		
menu_return_str:	.asciiz "Retornando ao menu. \n"

	
	.text
	.globl main

main:
	li $v0, 4
	la $a0, menu
	syscall

	li $v0 , 5
	syscall

	move $t0, $v0
	
	
	li $t1, 1
	li $t2, 2
	li $t3, 3
	li $t4, 4
	li $t5, 5

	beq $t0, $t1, insertion	
	beq $t0, $t2, removal
	beq $t0, $t3, search
	beq $t0, $t4, print_tree
	beq $t0, $t5, end

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
		
insertion:
	li $v0, 4 
	la $a0, enter_insertion_str
	syscall
		
	jal read_str
	
	j insertion



removal:
	li $v0, 4 
	la $a0, enter_removal_str
	syscall

	jal read_str
	
	j removal				


												
search:
	li $v0, 4 
	la $a0, search_number_str
	syscall
	
	jal read_str
	
	j search



print_tree:	



end:
	li $v0, 10
	syscall










