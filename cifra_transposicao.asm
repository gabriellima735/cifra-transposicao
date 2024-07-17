; ALUNOS: GABRIEL LIMA LINO DE ARAUJO e LUCAS GOMES DANTAS
; PROJETO ASSEMBLY : CRIFRA DE TRANSPOSICAO 
; ARQUITETURA DE COMPUTADORES 1 - 2024 - UFPB

.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data

; Escritas no Console
print_bemvindo db "Bem vindo ao programa CIFRA DE TRANSPOSICAO!", 0ah, 0h
print_menu db "OPCOES [1] Criptografar - [2] Descriptografar - [3] Sair - Sua opcao: ", 0ah, 0h
print_entrada db "- Digite a entrada (nome_entrada.txt): ", 0ah, 0h
print_saida db "- Digite a saida (nome_saida.txt): ", 0ah, 0h
print_codigo db "Digite um codigo chave numerico de 8 caracteres entre '0' e '7': ", 0ah, 0h
print_criptografar db "Voce escolheu CRIPTOGRAFAR!", 0ah, 0h
print_descriptografar db "Voce escolheu DESCRIPTOGRAFAR!", 0ah, 0h
print_sair db "Voce escolheu SAIR!", 0ah, 0h

; Buffers
input_buffer db 8 dup(0)
output_buffer db 8 dup(0)

; Inputs
in_code db 10 dup(0)
in_option db 3 dup(0)
input_file_entry db 50 dup(0)
input_file_exit db 50 dup(0)

; Handles
in_handle dd 0
out_handle dd 0

; File Handle
in_file_handle dd 0
out_file_handle dd 0

; Codigo convertido para inteiro
code_key dd 8 dup(0)

; Contador scanf
console_count dd 0

; Opcao escolhida
chosen_option dd 0

; Contadores
write_count dd 0
read_count dd 0

.code

Encode:

    PUSH EBP
    MOV EBP, ESP

    MOV EDI, [EBP + 8]  ; EDI: Acesso ao endereco do output_buffer na stack frame
    MOV ESI, [EBP + 12] ; ESI: Acesso ao endereco do input_buffer ''
    MOV EDX, [EBP + 16] ; EDX: Acesso ao endereco do code_key ''

    MOV EBX, 0 ; EBX: Contador
    XOR ECX, ECX ; ECX: Limpeza de ECX para utilizar como indice

    _loop_code:

        MOV AL, [EDX+EBX] ; AL recebe valor de code_key[EBX] 
        MOV CL, AL ; Move valor de AL para CL (8 bits menos significativos de ECX)
        
        MOV AL, [ESI+EBX] ; AL recebe valor de input_buffer[EBX]
        MOV [EDI+ECX], AL ; output_buffer[ECX] recebe valor de AL
        
    ADD EBX, 1
    CMP EBX, 8
    JLE _loop_code

    MOV ESP, EBP
    POP EBP
    RET 12

Decode:

    PUSH EBP
    MOV EBP, ESP

    MOV EDI, [EBP + 8]  ; EDI: Acesso ao endereco do output_buffer na stack frame
    MOV ESI, [EBP + 12] ; ESI: Acesso ao endereco do input_buffer ''
    MOV EDX, [EBP + 16] ; EDX: Acesso ao endereco do code_key ''

    MOV EBX, 0 ; EBX: Contador
    XOR ECX, ECX ; ECX: Limpeza de ECX para utilizar como indice

    _loop_decode:   

        MOV AL, [EDX+EBX] ; AL recebe valor de code_key[EBX] 
        MOV CL, AL ; Move valor de AL para CL (8 bits menos significativos de ECX)

        MOV AL, [ESI+ECX] ; AL recebe valor de input_buffer[ECX]
        MOV [EDI+EBX], AL ; output_buffer[EBX] recebe valor de AL
    
    ADD EBX, 1
    CMP EBX, 8
    JLE _loop_decode

    MOV ESP, EBP
    POP EBP
    RET 12

start:

    invoke GetStdHandle, STD_INPUT_HANDLE
    MOV in_handle, EAX
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    MOV out_handle, EAX

    invoke WriteConsole, out_handle, addr print_bemvindo, sizeof print_bemvindo, addr write_count, NULL

menu:
    
    invoke WriteConsole, out_handle, addr print_menu, sizeof print_menu, addr write_count, NULL
    invoke ReadConsole, in_handle, addr in_option, sizeof in_option, addr console_count, NULL

    ; Ajuste dos Caracteres ASCII
    MOV ESI, offset in_option ; Armazenar apontador da string em ESI
    _loop_escolha:
        MOV AL, [ESI] ; Mover caractere atual para AL
        INC ESI ; Apontar para o proximo caractere
        CMP AL, 48 ; Verificar se eh o caractere terminador 0 - FINALIZAR
        JL final_loop_escolha
        CMP AL, 58 ; Verifica se eh menor que 58 - Contagem ate o valor ASCII 57 = 9
        JL _loop_escolha
    final_loop_escolha:
        DEC ESI ; Apontar para caractere anterior, onde o CR foi encontrado
        XOR AL, AL ; ASCII 0, terminado de string
        MOV [ESI], AL ; Inserir ASCII 0 no lugar do ASCII CR
    
    invoke atodw, addr in_option
    MOV chosen_option, EAX

    CMP EAX, 1 
    JE criptografar
    CMP EAX, 2 
    JE descriptografar
    CMP EAX, 3 
    JE saida

    invoke WriteConsole, out_handle, addr print_bemvindo, sizeof print_bemvindo, addr write_count, NULL

    JMP menu        

criptografar:

    invoke WriteConsole, out_handle, addr print_criptografar, sizeof print_criptografar, addr write_count, NULL

    JMP coletaDados ; Coleta e trata o nome de arquivo input, output e o code_key/chave
    escrita_criptografar:

    ; Criacao arquivo de leitura
    ; GENERIC_READ = Ler arquivo
    ; OPEN_EXISTING = Abrir arquivo existente
    invoke CreateFile, addr input_file_entry, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    MOV in_file_handle, EAX
    
    ; Criacao arquivo de escrita
    ; GENERIC_WRITE = Escrever no arquivo
    ; CREATE_ALWAYS = Criar arquivo
    invoke CreateFile, addr input_file_exit, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    MOV out_file_handle, EAX

    leitura_arq_criptografar:

        ; Limpeza do buffer de Entrada
        MOV ESI, OFFSET input_buffer ; Aponta para endereco de input_buffer
        XOR ECX, ECX ; Zera contador
        MOV EBX, 32 ; Move caractere ASCII espaco (32) para EBX
        limparbuffer_entrada:
            MOV [ESI+ECX], EBX ; Atribui valor de EBX (ASCII 32) para o input_buffer[ECX]
            ADD ECX, 1 ; Incrementa contador
            CMP ECX, 8 ; Verifica se ECX ainda eh menor que 8 para continuar o loop
            JB limparbuffer_entrada

        ; Leitura do arquivo de 8 em 8 bytes
        invoke ReadFile, in_file_handle, addr input_buffer, 8, addr read_count, NULL
        CMP read_count, 0 ; Se a leitura for 0, finaliza a leitura do arquivo
        JE final_leitura_arq_criptografar
        
        ; Criptografar - Atribuir enderecos de memoria na stack frame
        PUSH offset code_key
        PUSH offset input_buffer
        PUSH offset output_buffer

        ; Chamada da funcao apos passagem de parametros
        CALL Encode
    
        ; Escrita do arquivo de 8 em 8 bytes
        invoke WriteFile, out_file_handle, addr output_buffer, 8, addr write_count, NULL

        JMP leitura_arq_criptografar

    final_leitura_arq_criptografar:

        invoke CloseHandle, in_file_handle
        invoke CloseHandle, out_file_handle
        JMP menu

descriptografar:
    ; print: Descriptografar
    invoke WriteConsole, out_handle, addr print_descriptografar, sizeof print_descriptografar, addr write_count, NULL

    JMP coletaDados ; Coleta e trata o nome de arquivo input, output e o code_key/chave
    escrita_descriptografar:

    invoke CreateFile, addr input_file_entry, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    MOV in_file_handle, EAX

    invoke CreateFile, addr input_file_exit, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    MOV out_file_handle, EAX
    
    leitura_arq_descriptografar:

        ; Leitura de arquivo de 8 em 8 bytes
        invoke ReadFile, in_file_handle, addr input_buffer, 8, addr read_count, NULL ; Le 10 bytes do arquivo
        CMP read_count, 0
        JE final_leitura_arq_descriptografar
        
        ; Criptografar - Atribuir enderecos de memoria na stack frame
        PUSH offset code_key 
        PUSH offset input_buffer 
        PUSH offset output_buffer 
        
        ; Chamada de funcao 
        CALL Decode
    
        ; Escrita de arquivo de 8 em 8 bytes
        invoke WriteFile, out_file_handle, addr output_buffer, 8, addr write_count, NULL ; Escreve 10 bytes do arquivo

        JMP leitura_arq_descriptografar
    
    final_leitura_arq_descriptografar:
    
        invoke CloseHandle, in_file_handle
        invoke CloseHandle, out_file_handle
        
        JMP menu

coletaDados:
    ; print/scanf : nome do arquivo de entrada
    invoke WriteConsole, out_handle, addr print_entrada, sizeof print_entrada, addr write_count, NULL
    invoke ReadConsole, in_handle, addr input_file_entry, sizeof input_file_entry, addr console_count, NULL
    MOV ESI, offset input_file_entry ; Armazenar apontador da string em ESI
   
    _loop_entrada:
        MOV AL, [ESI] ; Mover caractere atual para AL
        INC ESI ; Apontar para o proximo caractere
        CMP AL, 13 ; Verificar se eh o carac tere ASCII CR FINALIZAR
    JNE _loop_entrada
    DEC ESI ; Apontar para caractere anterior
    XOR AL, AL ; Zerando AL para 0
    MOV [ESI], AL ; Inserir 0 no lugar de CR
    
    ; print/scanf : nome do arquivo de saida
    invoke WriteConsole, out_handle, addr print_saida, sizeof print_saida, addr write_count, NULL
    invoke ReadConsole, in_handle, addr input_file_exit, sizeof input_file_exit, addr console_count, NULL
    MOV ESI, offset input_file_exit ; Armazenar apontador da string em ESI
    
    ; Mesmo processo que _loop_entrada, mas agora nos dados de saida
    _loop_saida:
        MOV AL, [ESI] 
        INC ESI 
        CMP AL, 13 
    JNE _loop_saida
    DEC ESI
    XOR AL, AL 
    MOV [ESI], AL

    ; print/scanf : code_key
    invoke WriteConsole, out_handle, addr print_codigo, sizeof print_codigo, addr write_count, NULL
    invoke ReadConsole, in_handle, addr in_code, sizeof in_code, addr console_count, NULL

        MOV ESI, offset in_code
        XOR ECX, ECX
        XOR EBX, EBX
    _loop_codigo:
        MOV EBX, [ESI+ECX]
        SUB EBX, 48 ; Subtrai 48, caractere '0' da tabela ASCII dos valores > Obter valor inteiro
        MOV [code_key+ECX], EBX ; Move valor inteiro para code_key[ECX]
        ADD ECX, 1 ; Incrementa ECX
        CMP ECX, 8 ; Verifica se ECX ainda eh menor que 8 para continuar o loop
        JB _loop_codigo
    
    CMP chosen_option, 1
    JE escrita_criptografar
    CMP chosen_option, 2
    JE escrita_descriptografar

saida:
    invoke WriteConsole, out_handle, addr print_sair, sizeof print_sair, addr write_count, NULL

invoke ExitProcess, 0
end start
