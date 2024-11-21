Passo a Passo Explicado
Este código implementa a busca de um padrão em um vetor de dados. Ele coleta os vetores do usuário, realiza a busca e exibe a quantidade de padrões encontrados. Vamos analisar cada parte.

1. Declaração de Dados (.data)
   
    vetorDados: .space 200
    vetorPadrao: .space 20
    msgEntradaDados: .asciiz "\nInsira o número de elementos no vetorDados (1 a 50): "
    msgEntradaValorDados: .asciiz "\nInsira o elemento do vetorDados: "
    msgEntradaPadrao: .asciiz "\nInsira o número de elementos no vetorPadrao (1 a 5): "
    msgEntradaValorPadrao: .asciiz "\nInsira o elemento do vetorPadrao: "
    msgResultado: .asciiz "\nQuantidade de padrões encontrados: "
   
- vetorDados: Reserva 200 bytes (50 palavras, cada uma com 4 bytes) para armazenar os valores do vetor de dados.
- vetorPadrao: Reserva 20 bytes (5 palavras, 4 bytes cada) para o vetor padrão.
- Mensagens de texto (.asciiz): São strings usadas para exibir mensagens ao usuário.
   
2. Configuração Inicial (.text e main)
.text
.globl main

main:

- .text: Indica que o segmento de código executável começa aqui.
- .globl main: Declara a função principal como global, para que o simulador saiba onde iniciar a execução.

3. Entrada do Tamanho do vetorDados

    li $v0, 4                      # Exibe mensagem
    la $a0, msgEntradaDados
    syscall

    li $v0, 5                      # Lê número de elementos (n)
    syscall
    move $t0, $v0                  # Salva tamanho do vetorDados em $t0 (n)
   
- A mensagem é exibida usando o syscall 4, e o tamanho do vetor (n) é lido pelo syscall 5.
- O valor lido é armazenado em $t0 (número de elementos no vetorDados).

4. Entrada dos Elementos de vetorDados

    li $t1, 0                      # Índice do vetorDados
preenche_vetorDados:
    bge $t1, $t0, preenche_vetorPadrao # Sai do loop se i >= n
   
- Inicializa o índice $t1 = 0.
- Se $t1 >= $t0, o programa termina a entrada do vetor e vai para a próxima parte.

    li $v0, 4                      # Exibe mensagem
    la $a0, msgEntradaValorDados
    syscall
- Exibe a mensagem para solicitar a entrada de cada elemento do vetor.

    li $v0, 5                      # Lê valor
    syscall
    mul $t2, $t1, 4                # Calcula deslocamento: i * 4
    la $t3, vetorDados             # Carrega endereço base do vetor
    add $t3, $t3, $t2              # Adiciona deslocamento
    sw $v0, 0($t3)                 # Armazena valor em vetorDados[i]
  
- Lê o valor e calcula o deslocamento em memória para a posição correta do vetor (i * 4).
- O valor é armazenado em vetorDados[i].

    addi $t1, $t1, 1               # i++
    j preenche_vetorDados
  
- Incrementa o índice e repete o loop até que todos os elementos sejam lidos.
  
6. Entrada do Tamanho e Elementos de vetorPadrao
Semelhante à entrada do vetorDados, o tamanho (m) é lido e armazenado em $t4. Um loop é usado para armazenar os elementos no vetorPadrao.

    mul $t6, $t5, 4                # Calcula deslocamento: j * 4
    la $t7, vetorPadrao            # Carrega endereço base do vetor
    add $t7, $t7, $t6              # Adiciona deslocamento
    sw $v0, 0($t7)                 # Armazena valor em vetorPadrao[j]
   
- A lógica do deslocamento e armazenamento é idêntica à do vetorDados.
  
6. Busca de Padrões em vetorDados
O programa verifica, para cada subsequência de tamanho m em vetorDados, se ela corresponde a vetorPadrao.

Configuração Inicial:

busca_padroes:
    li $t8, 0                      # Contador de padrões encontrados
    li $t9, 0                      # Índice inicial do vetorDados
    
- $t8: Contador de padrões encontrados.
- $t9: Índice de início da subsequência atual em vetorDados.

Verificação de Subsequências:

loop_vetorDados:
    sub $a0, $t0, $t9              # Tamanho restante = n - i
    blt $a0, $t4, fim_busca        # Sai do loop se espaço restante < padrão
    
- Calcula o número de elementos restantes no vetor (n - i) e verifica se ainda há espaço suficiente para o padrão.
- Comparação de Padrão:

verifica_padrao:
    bge $s0, $t4, padrao_encontrado # Sai do loop se padrão foi percorrido
    
- Para cada elemento em vetorPadrao, verifica a correspondência com a subsequência atual em vetorDados.

    mul $s2, $s0, 4                # Deslocamento padrão: índice do padrão * 4
    la $s3, vetorPadrao
    add $s3, $s3, $s2
    lw $s4, 0($s3)                 # Carrega vetorPadrao[s0]

    mul $s5, $t9, 4                # Deslocamento vetorDados: índice * 4
    add $s5, $s5, $s2              # Adiciona deslocamento do índice do padrão
    la $s6, vetorDados
    add $s6, $s6, $s5
    lw $s7, 0($s6)                 # Carrega vetorDados[i + s0]
  
- Calcula os deslocamentos para acessar os elementos de vetorPadrao e vetorDados, e os compara.

    bne $s4, $s7, padrao_nao_encontrado # Se diferente, não é padrão
    addi $s0, $s0, 1               # Próximo índice do padrão
    j verifica_padrao
  
- Se algum elemento não coincidir, abandona a verificação.
- Finalização da Comparação:

padrao_encontrado:
    addi $t8, $t8, 1               # Incrementa contador de padrões
    j avanca_busca
    
- Incrementa o contador de padrões encontrados.

padrao_nao_encontrado:
    li $s1, 0                      # Não corresponde
    
Avança a Busca:

avanca_busca:
    addi $t9, $t9, 1               # Avança índice no vetorDados
    j loop_vetorDados
    
- Move o início da subsequência para a próxima posição em vetorDados.

7. Exibição do Resultado

fim_busca:
    li $v0, 4                      # Exibe mensagem
    la $a0, msgResultado
    syscall

    li $v0, 1                      # Exibe número de padrões encontrados
    move $a0, $t8
    syscall

    li $v0, 10                     # Finaliza o programa
    syscall
---
Mostra a quantidade de padrões encontrados ($t8) e finaliza o programa.
Resumo
Entrada: Lê vetorDados e vetorPadrao.
Busca: Verifica todas as subsequências possíveis no vetorDados.
Saída: Mostra o número de correspondências.
Este código usa lógica clara e direta para abordar o problema, com deslocamentos calculados manualmente e loops bem organizados.
