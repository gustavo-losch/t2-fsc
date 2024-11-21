.data
# Vetores e mensagens
vetorDados: .space 200          # Espaço para 50 palavras (4 bytes cada)
vetorPadrao: .space 20          # Espaço para 5 palavras (4 bytes cada)
msgEntradaDados: .asciiz "\nInsira o número de elementos no vetorDados (1 a 50): "
msgEntradaValorDados: .asciiz "\nInsira o elemento do vetorDados: "
msgEntradaPadrao: .asciiz "\nInsira o número de elementos no vetorPadrao (1 a 5): "
msgEntradaValorPadrao: .asciiz "\nInsira o elemento do vetorPadrao: "
msgResultado: .asciiz "\nQuantidade de padrões encontrados: "
msgNovaLinha: .asciiz "\n"

.text
.globl main

main:
    # Solicita número de elementos em vetorDados
    li $v0, 4                      # syscall para imprimir string
    la $a0, msgEntradaDados        # mensagem: insira tamanho do vetorDados
    syscall

    li $v0, 5                      # syscall para ler inteiro
    syscall
    move $t0, $v0                  # $t0 = tamanho do vetorDados (n)

    # Loop para preencher vetorDados
    li $t1, 0                      # índice do vetorDados (i = 0)
preenche_vetorDados:
    bge $t1, $t0, preenche_vetorPadrao # Se i >= n, ir para o próximo passo

    li $v0, 4                      # syscall para imprimir string
    la $a0, msgEntradaValorDados   # mensagem: insira valor do vetorDados
    syscall

    li $v0, 5                      # syscall para ler inteiro
    syscall
    sll $t2, $t1, 2                # $t2 = i * 4 (calcula o deslocamento)
    la $t3, vetorDados             # Carrega endereço base do vetorDados
    add $t3, $t3, $t2              # Adiciona deslocamento
    sw $v0, 0($t3)                 # Salva valor no vetorDados[i]

    addi $t1, $t1, 1               # i++
    j preenche_vetorDados

# Solicita número de elementos em vetorPadrao
preenche_vetorPadrao:
    li $v0, 4                      # syscall para imprimir string
    la $a0, msgEntradaPadrao       # mensagem: insira tamanho do vetorPadrao
    syscall

    li $v0, 5                      # syscall para ler inteiro
    syscall
    move $t4, $v0                  # $t4 = tamanho do vetorPadrao (m)

    # Loop para preencher vetorPadrao
    li $t5, 0                      # índice do vetorPadrao (j = 0)
preenche_vetorPadrao_loop:
    bge $t5, $t4, busca_padroes    # Se j >= m, ir para busca de padrões

    li $v0, 4                      # syscall para imprimir string
    la $a0, msgEntradaValorPadrao  # mensagem: insira valor do vetorPadrao
    syscall

    li $v0, 5                      # syscall para ler inteiro
    syscall
    sll $t6, $t5, 2                # $t6 = j * 4 (calcula o deslocamento)
    la $t7, vetorPadrao            # Carrega endereço base do vetorPadrao
    add $t7, $t7, $t6              # Adiciona deslocamento
    sw $v0, 0($t7)                 # Salva valor no vetorPadrao[j]

    addi $t5, $t5, 1               # j++
    j preenche_vetorPadrao_loop

# Busca padrões em vetorDados
busca_padroes:
    li $t8, 0                      # $t8 = contador de padrões encontrados
    li $t9, 0                      # $t9 = índice inicial de busca no vetorDados

loop_vetorDados:
    sub $a0, $t0, $t9              # $a0 = n - índice atual
    blt $a0, $t4, fim_busca        # Se tamanho restante < m, termina busca

    # Verifica correspondência do padrão
    li $s0, 0                      # $s0 = índice do padrão
    li $s1, 1                      # $s1 = flag de correspondência (1 = sim)
verifica_padrao:
    bge $s0, $t4, padrao_encontrado # Se percorreu todo padrão, padrão encontrado

    sll $s2, $s0, 2                # $s2 = índice do padrão * 4
    la $s3, vetorPadrao            # Endereço base do vetorPadrao
    add $s3, $s3, $s2              # Calcula endereço de vetorPadrao[s0]
    lw $s4, 0($s3)                 # Carrega vetorPadrao[s0]

    sll $s5, $t9, 2                # $s5 = índice atual * 4
    add $s5, $s5, $s2              # Adiciona deslocamento para posição correspondente
    la $s6, vetorDados             # Endereço base do vetorDados
    add $s6, $s6, $s5              # Calcula endereço de vetorDados[indice + s0]
    lw $s7, 0($s6)                 # Carrega vetorDados[indice + s0]

    bne $s4, $s7, padrao_nao_encontrado # Se valores diferentes, não corresponde
    addi $s0, $s0, 1               # Próximo índice do padrão
    j verifica_padrao

padrao_encontrado:
    addi $t8, $t8, 1               # Incrementa contador de padrões
    j avanca_busca

padrao_nao_encontrado:
    li $s1, 0                      # Marca como não correspondente

avanca_busca:
    addi $t9, $t9, 1               # Avança índice do vetorDados
    j loop_vetorDados

fim_busca:
    # Exibe o resultado
    li $v0, 4                      # syscall para imprimir string
    la $a0, msgResultado           # mensagem: quantidade de padrões encontrados
    syscall

    li $v0, 1                      # syscall para imprimir inteiro
    move $a0, $t8                  # Passa contador de padrões
    syscall

    li $v0, 10                     # syscall para encerrar programa
    syscall