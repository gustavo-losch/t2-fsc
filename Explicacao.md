1. Estruturação do problema
O problema é dividido em três etapas principais:

Entrada de dados: Pedir ao usuário os valores do vetor principal (vetorDados) e do vetor padrão (vetorPadrao).
Busca pelo padrão: Comparar cada sequência de elementos no vetorDados com o vetorPadrao.
Saída do resultado: Informar quantas vezes o padrão foi encontrado.
O raciocínio baseia-se em:

Percorrer vetorDados em busca de subsequências de tamanho m (tamanho do vetorPadrao) que sejam iguais ao padrão.
Contar o número de vezes que o padrão ocorre.
2. Estruturação do código
O código MIPS segue as seguintes seções:

.data
Esta seção define os dados que serão usados pelo programa:

Espaços para armazenar os vetores vetorDados (50 palavras = 200 bytes) e vetorPadrao (5 palavras = 20 bytes).
Mensagens de interação com o usuário, como as instruções para inserir valores ou mostrar resultados.
asm
Copiar código
.data
vetorDados: .space 200          # Espaço para 50 palavras (4 bytes cada)
vetorPadrao: .space 20          # Espaço para 5 palavras (4 bytes cada)
msgEntradaDados: .asciiz "\nInsira o número de elementos no vetorDados (1 a 50): "
msgEntradaValorDados: .asciiz "\nInsira o elemento do vetorDados: "
msgEntradaPadrao: .asciiz "\nInsira o número de elementos no vetorPadrao (1 a 5): "
msgEntradaValorPadrao: .asciiz "\nInsira o elemento do vetorPadrao: "
msgResultado: .asciiz "\nQuantidade de padrões encontrados: "
.text
Aqui está a lógica principal do programa. Ela é dividida em três partes principais.

3. Explicação do código
Entrada do vetorDados
Solicitar o tamanho do vetor:

Exibimos a mensagem pedindo o tamanho (n) do vetor principal vetorDados.
Usamos syscall com $v0 = 5 para ler um número inteiro do usuário.
Guardamos o valor em $t0 (o número de elementos em vetorDados).
Preencher o vetorDados:

Usamos um loop para ler os n valores digitados pelo usuário e armazená-los em vetorDados.
Calculamos o endereço onde cada valor será salvo usando deslocamento (multiplicamos o índice por 4, já que cada palavra ocupa 4 bytes).
asm
Copiar código
    li $v0, 4                      # Mensagem: "Insira o número de elementos"
    la $a0, msgEntradaDados
    syscall

    li $v0, 5                      # Lê inteiro
    syscall
    move $t0, $v0                  # Salva o tamanho do vetorDados (n)

    li $t1, 0                      # Índice do vetorDados
preenche_vetorDados:
    bge $t1, $t0, preenche_vetorPadrao # Sai do loop se i >= n

    li $v0, 4                      # Mensagem: "Insira o elemento"
    la $a0, msgEntradaValorDados
    syscall

    li $v0, 5                      # Lê valor
    syscall
    sll $t2, $t1, 2                # Calcula deslocamento: i * 4
    la $t3, vetorDados             # Carrega endereço base do vetor
    add $t3, $t3, $t2              # Adiciona deslocamento
    sw $v0, 0($t3)                 # Armazena valor em vetorDados[i]

    addi $t1, $t1, 1               # i++
    j preenche_vetorDados
Entrada do vetorPadrao
Solicitar o tamanho do vetor padrão:

Exibimos a mensagem pedindo o tamanho (m) do vetor padrão vetorPadrao.
Guardamos o valor em $t4.
Preencher o vetorPadrao:

Usamos um loop para ler os m valores digitados pelo usuário e armazená-los em vetorPadrao.
asm
Copiar código
    li $v0, 4                      # Mensagem: "Insira o número de elementos"
    la $a0, msgEntradaPadrao
    syscall

    li $v0, 5                      # Lê inteiro
    syscall
    move $t4, $v0                  # Salva o tamanho do vetorPadrao (m)

    li $t5, 0                      # Índice do vetorPadrao
preenche_vetorPadrao_loop:
    bge $t5, $t4, busca_padroes    # Sai do loop se j >= m

    li $v0, 4                      # Mensagem: "Insira o elemento"
    la $a0, msgEntradaValorPadrao
    syscall

    li $v0, 5                      # Lê valor
    syscall
    sll $t6, $t5, 2                # Calcula deslocamento: j * 4
    la $t7, vetorPadrao             # Carrega endereço base do vetor
    add $t7, $t7, $t6              # Adiciona deslocamento
    sw $v0, 0($t7)                 # Armazena valor em vetorPadrao[j]

    addi $t5, $t5, 1               # j++
    j preenche_vetorPadrao_loop
Busca pelo padrão
A lógica principal para encontrar os padrões é implementada em dois loops:

Percorrer o vetorDados:

Cada iteração verifica se a subsequência atual (de tamanho m) no vetorDados corresponde ao vetorPadrao.
O índice atual é $t9.
Comparar elementos do padrão:

Para cada posição do padrão, verificamos se o valor no vetorDados corresponde ao valor no vetorPadrao.
Se qualquer valor for diferente, marcamos que o padrão não corresponde ($s1 = 0).
Incrementar o contador de padrões:

Quando todos os valores do padrão correspondem, incrementamos o contador $t8.
asm
Copiar código
loop_vetorDados:
    sub $a0, $t0, $t9              # $a0 = tamanho restante
    blt $a0, $t4, fim_busca        # Sai do loop se espaço restante < padrão

    li $s0, 0                      # Índice do padrão
    li $s1, 1                      # Flag de correspondência (1 = sim)

verifica_padrao:
    bge $s0, $t4, padrao_encontrado # Sai do loop se padrão foi percorrido

    # Carregar elemento do padrão e correspondente no vetorDados
    sll $s2, $s0, 2
    la $s3, vetorPadrao
    add $s3, $s3, $s2
    lw $s4, 0($s3)

    sll $s5, $t9, 2
    add $s5, $s5, $s2
    la $s6, vetorDados
    add $s6, $s6, $s5
    lw $s7, 0($s6)

    bne $s4, $s7, padrao_nao_encontrado # Se diferente, não é padrão
    addi $s0, $s0, 1               # Próximo índice
    j verifica_padrao

padrao_encontrado:
    addi $t8, $t8, 1               # Incrementa contador de padrões
    j avanca_busca

padrao_nao_encontrado:
    li $s1, 0                      # Não corresponde

avanca_busca:
    addi $t9, $t9, 1               # Avança índice no vetorDados
    j loop_vetorDados
Saída do resultado
Por fim, exibimos o valor de $t8 (contador de padrões encontrados) ao usuário.

asm
Copiar código
fim_busca:
    li $v0, 4
    la $a0, msgResultado
    syscall

    li $v0, 1
    move $a0, $t8
    syscall

    li $v0, 10
    syscall
4. Como pensar no raciocínio
Divida o problema em partes claras:

Entrada dos vetores.
Comparação de subsequências.
Saída dos resultados.
Defina como armazenar dados:

Vetores em memória (vetorDados e vetorPadrao).
Índices e contadores como registros.
Implemente cada etapa separadamente e teste individualmente.

Com essa abordagem, o código é desenvolvido de forma estruturada, garantindo funcionalidade e clareza! 🚀
