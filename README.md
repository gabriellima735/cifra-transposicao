# Projeto de Cifra de Transposição 🧮

## Universidade Federal da Paraíba
**Disciplina**: Arquitetura de Computadores 1  
**Alunos**: Gabriel Lima, Lucas Dantas  

## Descrição
Este projeto implementa uma cifra de transposição utilizando arquivos para entrada e saída. O usuário fornece um arquivo de texto a ser codificado, escolhe a opção de cifrar, e fornece uma sequência de números de 0 a 7 para ser o código da cifra. O texto codificado é salvo em um arquivo de saída. Para decodificar, basta escolher a opção de descifrar e repetir o processo com o mesmo código.

## Sumário
- [Introdução](#introdução)
- [Instalação](#instalação)
- [Uso](#uso)
- [Funcionalidades](#funcionalidades)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Autores](#autores)

## Introdução
A cifra de transposição é uma técnica de criptografia que reorganiza os caracteres do texto original com base em uma sequência específica. Este projeto foi desenvolvido na disciplina de Arquitetura de Computadores 1 da Universidade Federal da Paraíba.

## Instalação
### Pré-requisitos
Para rodar este projeto no Windows, é necessário baixar e instalar o MASM32.

- [Download do MASM32](https://masm32.com/)

### Instruções
1. Baixe e instale o MASM32.
2. Clone o repositório do projeto:
    ```bash
    git clone https://github.com/seu-usuario/seu-repositorio.git
    ```
3. Abra o projeto no MASM32.
4. No menu, vá em `Project > Console Build All`.
5. No terminal, digite o nome do projeto ou abra o executável gerado.

## Uso
1. Coloque um arquivo `.txt` com o texto que deseja codificar na pasta do projeto.
2. Execute o projeto e escolha a opção **Criptografar**.
3. Digite o nome do arquivo de entrada, o nome do arquivo de saída e uma sequência de números de 0 a 7 em qualquer ordem para ser o código da cifra.
4. Abra o arquivo de saída para ver o resultado codificado.
5. Para decodificar, escolha a opção **Descriptografar** e repita o processo com o mesmo código.

### Exemplo:
```
Bem vindo ao programa CIFRA DE TRANSPOSICAO!
OPCOES [1] Criptografar - [2] Descriptografar - [3] Sair - Sua opcao:
1
Voce escolheu CRIPTOGRAFAR!
- Digite a entrada (nome_entrada.txt):
entrada.txt
- Digite a saida (nome_saida.txt):
saida.txt
Digite um codigo chave numerico de 8 caracteres entre '0' e '7':
76543210
OPCOES [1] Criptografar - [2] Descriptografar - [3] Sair - Sua opcao:
2
Voce escolheu DESCRIPTOGRAFAR!
- Digite a entrada (nome_entrada.txt):
saida.txt
- Digite a saida (nome_saida.txt):
saida_dois.txt
Digite um codigo chave numerico de 8 caracteres entre '0' e '7':
76543210
OPCOES [1] Criptografar - [2] Descriptografar - [3] Sair - Sua opcao:
3
Voce escolheu SAIR!
```

## Funcionalidades
- Cifrar um texto utilizando uma sequência de transposição.
- Descifrar um texto codificado utilizando a mesma sequência de transposição.

## Tecnologias Utilizadas
- Assembly
- MASM32

## Autores
- **Gabriel Lima** - [GitHub](https://github.com/gabriellima735)
- **Lucas Dantas** - [GitHub](https://github.com/cori4nder)

