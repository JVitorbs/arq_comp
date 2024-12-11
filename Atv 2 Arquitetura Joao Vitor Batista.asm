.data
msg_codificada: 
    .word 0x00051010, 0x116A23B1, 0x21347582, 0x10061231, 0x11642467, 0x008695AB, 
    .word 0x21CD6EEF, 0x00071323, 0x11264517, 0x2089A2B0, 0x00E5F601, 0x212360F1, 
    .word 0x11624533, 0x21676455, 0x00627089, 0x20AB8691, 0x10A6CDB3, 0x21EF6C5D, 
    .word 0x10E701F2, 0x00071423, 0x0162F345, 0x21677455, 0x10628971, 0x1082AB90, 
    .word 0x10A4CDB6, 0x016C9DEF, 0x21016031, 0x212362F3, 0x01745545, 0x10626770, 
    .word 0x10868993, 0x21AB6AFB, 0x00C6DDCD, 0x00E2F0EF, 0x116001E1, 0x0162F323, 
    .word 0x20454754, 0x00667167, 0x20898290, 0x113AAB1B, 0x113CCD0D, 0x000211EF

.text
main:
    la $t0, msg_codificada  # Carrega o endereço da mensagem codificada
    li $t1, 42              # Número total de palavras na mensagem

loop:
    beqz $t1, exit          # Se t1 (contador) for 0, sai do loop

    lw $t4, 0($t0)          # Carrega uma palavra de 32 bits da mensagem

    # Extrai e verifica cada byte da palavra
    srl $t5, $t4, 24        # Extrai o primeiro byte
    andi $t5, $t5, 0xFF     # Isola os 8 bits menos significativos
    jal check_and_print      # Chama a função para verificar e imprimir

    srl $t6, $t4, 16        # Extrai o segundo byte
    andi $t6, $t6, 0xFF
    move $a0, $t6
    jal check_and_print

    srl $t7, $t4, 8         # Extrai o terceiro byte
    andi $t7, $t7, 0xFF
    move $a0, $t7
    jal check_and_print

    andi $t8, $t4, 0xFF     # Extrai o quarto byte
    move $a0, $t8
    jal check_and_print

    addi $t0, $t0, 4        # Avança para a próxima palavra (4 bytes)
    addi $t1, $t1, -1       # Decrementa o contador
    j loop                  # Volta para o início do loop

check_and_print:
    blt $a0, 0x20, ret      # Ignora se o byte for menor que ASCII imprimível
    bgt $a0, 0x7E, ret      # Ignora se o byte for maior que ASCII imprimível
    li $v0, 11              # Código para imprimir caractere
    syscall
ret:
    jr $ra                  # Retorna para o chamador

exit:
    li $v0, 10              # Código para sair
    syscall
