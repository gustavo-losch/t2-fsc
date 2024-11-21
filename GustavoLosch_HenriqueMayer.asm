.data
    dados: .space 12 # 4 bytes para cada inteiro (array com 3 posições)

.text
    
    # Inicializa o vetor com os valores
    addi $s0, $zero, 4
    addi $s1, $zero, 10
    addi $s2, $zero, 12

    # Index = $t0