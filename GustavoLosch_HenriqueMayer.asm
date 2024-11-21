.data
vetorDados: .space 200          # Espaço para 50 palavras (4 bytes cada)
vetorPadrao: .space 20          # Espaço para 5 palavras (4 bytes cada)
msgEntradaDados: .asciiz "\nInsira o número de elementos no vetorDados (1 a 50):\n"
msgEntradaValorDados: .asciiz "\nInsira o elemento do vetorDados:\n"
msgEntradaPadrao: .asciiz "\nInsira o número de elementos no vetorPadrao (1 a 5):\n"
msgEntradaValorPadrao: .asciiz "\nInsira o elemento do vetorPadrao:\n"
msgResultado: .asciiz "\nQuantidade de padrões encontrados:\n"

.text
.globl main

main:
    # Entrada do tamanho de vetorDados
    li $v0, 4                      # Syscall para exibir uma string
    la $a0, msgEntradaDados
    syscall

    li $v0, 5                      # Syscall para a leitura de inteiro (tamanho do vetor de dados)
    syscall
    move $t0, $v0                  # Move o tamanho de vetorDados para $t0

    # Entrada dos elementos de vetorDados
    li $t1, 0                      # Inicia o índice de vetorDados com 0 em $t1
preenchendo_vetorDados:
    # Sai do loop se i >= ao tamanho do vetorDados
    bge $t1, $t0, preenchendo_vetorPadrao

    li $v0, 4                      # Syscall para exibir uma string
    la $a0, msgEntradaValorDados
    syscall

    li $v0, 5                      # Syscall para leitura de inteiro (valor a ser armazenado no vetorDados)
    syscall
    mul $t2, $t1, 4                # Calcula deslocamento para inserção do elemento: i * 4
    la $t3, vetorDados             # Carrega endereço inicial do vetor
    add $t3, $t3, $t2              # Adiciona deslocamento
    sw $v0, 0($t3)                 # Armazena elemento em vetorDados[i]

    addi $t1, $t1, 1               # Incrementa o índice e volta para o início do loop
    j preenchendo_vetorDados

preenchendo_vetorPadrao:
    # Entrada do tamanho de vetorPadrao
    li $v0, 4                      # Syscall para exibir uma string
    la $a0, msgEntradaPadrao
    syscall

    li $v0, 5                      # Syscall para a leitura de inteiro (tamanho do vetor padrão)
    syscall
    move $t4, $v0                  # Move o tamanho de vetorPadrão para $t0

    # Entrada dos elementos de vetorPadrao
    li $t5, 0                      # Inicia o índice de vetorPadrao com 0 em $t5
preenche_vetorPadrao_loop:
    # Sai do loop se j >= ao tamanho do vetorPadrao
    bge $t5, $t4, busca_padroes

    li $v0, 4                      # Syscall para exibir uma string
    la $a0, msgEntradaValorPadrao
    syscall

    li $v0, 5                      # Syscall para leitura de inteiro (valor a ser armazenado no vetorPadrao)
    syscall
    mul $t6, $t5, 4                # Calcula deslocamento para inserção do elemento: j * 4
    la $t7, vetorPadrao            # Carrega endereço inicial do vetor
    add $t7, $t7, $t6              # Adiciona deslocamento
    sw $v0, 0($t7)                 # Armazena valor em vetorPadrao[j]

    addi $t5, $t5, 1               # Incrementa o índice do vetorPadrão e pula para o início do loop
    j preenche_vetorPadrao_loop

    # Busca por padrões em vetorDados
busca_padroes:
    li $t8, 0                      # Inicia o contador de padrões encontrados com 0 em $t8
    li $t9, 0                      # Índice inicial do vetorDados

loop_vetorDados:
    sub $a0, $t0, $t9              # Tamanho a ser percorrido: tamanho do vetorDados - indice
    blt $a0, $t4, fim_busca        # Sai do loop se espaço restante < padrão

    li $s0, 0                      # Índice do padrão
    li $s1, 1                      # Verifica padrão. 1 - Sim, 0 - Não

verifica_padrao:
    bge $s0, $t4, padrao_encontrado # Sai do loop se padrão foi encontrado

    # Carregar elemento do padrão e correspondente no vetorDados
    mul $s2, $s0, 4                # Deslocamento padrão: índice do padrão * 4
    la $s3, vetorPadrao
    add $s3, $s3, $s2
    lw $s4, 0($s3)                 # Carrega vetorPadrao[s0]

    mul $s5, $t9, 4                # Deslocamento vetorDados: índice * 4
    add $s5, $s5, $s2              # Adiciona deslocamento do índice do padrão
    la $s6, vetorDados
    add $s6, $s6, $s5
    lw $s7, 0($s6)                 # Carrega vetorDados[i + s0]

    bne $s4, $s7, padrao_nao_encontrado # Se diferente, não é padrão
    addi $s0, $s0, 1               # Próximo índice do padrão
    j verifica_padrao

padrao_encontrado:
    addi $t8, $t8, 1               # Incrementa contador de padrões
    j avanca_busca

padrao_nao_encontrado:
    li $s1, 0                      # Verifica padrão. 1 - Sim, 0 - Não

avanca_busca:
    addi $t9, $t9, 1               # Avança índice no vetorDados
    j loop_vetorDados

    # Exibe resultado
fim_busca:
    li $v0, 4                      # Syscall para exibir string
    la $a0, msgResultado
    syscall

    li $v0, 1                      # Syscall para exibir inteiro (numero de padroes encontrados)
    move $a0, $t8
    syscall

    li $v0, 10                     # Syscall para finalizar o programa
    syscall
