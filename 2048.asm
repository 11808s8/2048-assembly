.model small
.stack 500h
.data
    ; Matriz Principal
    MatrizJogo DB  0,0,1,2,0,0,2,3,0,0,1,3,0,0,1,5
    ;=============

    ; Vars pertinentes a matriz e aos movimentos dela
    valColAnterior DW 1 0
    venceuPerdeu    DB 0
    existemMovimentos DB 1 0
    PecasJaMovidas DB 0
    CasasVazias DB 16
    ;=============

    ; parte grafica do tabuleiro
    numsTela DB "    ","  2 ","  4 ","  8 "," 16 "," 32 "," 64 "," 128"," 256"," 512","1024","2048"
    atribsTela DB 0FH,07h,08h,0Ch,04h,0Dh,05h,0Bh,03h,09h,01h,06h
    numsTelaScore dw 0,2,4,8,16,32,64,128,256,512,1024,2048

    ; variaveis auxiliares para os quadrados
    posSqrIL DB  0 ;define primeira pos da linha de um quadrado
    posSqrIC DB  0 ;define primeira col da linha de um quadrado
    colInicial equ 7 ; primeira posicao para o primeiron quadrado na tela
    ;=============

    ; gerador de numeros aleatorios
    Mask equ 1000000000010110b
    Seed DW 2

    ; Variaveis pertinentes ao simulador
    MatrizClone DB 16 dup(0)  ;matriz sobre a qual a IA ira iterar sobre
							  ; para descobrir em qual pos fara o 'melhor mov' (mais valioso)

    MatrizPesos db    0,1,2,7 ; matriz que atrela pesos as posicoes do tabuleiro, o que faz com
                db    8,4,4,4 ; que o simulador coloque pecas 'mais valiosas' no canto mais 'pesado'
                db    12,8,8,8
                db    13,13,14,15

    melhorScoreClone Dw 0  ; controle do melhor escore no clone
    melhorMovIA db 0       ; armazena a dir em que o mov gerou mais pontos
    melhorScoreIA DW 0     ; armazena qual foi o melhor escore da IA dentre as 4 direcoes

    ; Variaveis de controle para montar o resultado das simulacoes
    scoreValoresFimIA DW 7 dup(0)
    jogadasFimIA DW 7 dup(0)
    jogadasRoundIA Db 7 dup(0)
    ;=============
    ; Variaveis tela de status
    JogadasJogador dw 0
    scoreTela DW 0
    ;=============

    ; Mensagens tela de status
    msgEscoreJogador db "Score:"
    msgJogadasJogador db "Jogadas:"
    msgMelhorEscore db "TOP:"
    msgEscoreJ db "     ",'$'
    msgJogadasJ db "     ", "$"
    msgTopJ db "      ", "$"

    ; mensagens das simula�oes
    msgQtsVezesSimular db " Insira o numero de simulacoes: "
    simuladorNumero db ' ' ; utilidade para imprimir na tela um caractere
    msgResultadosFimSimulacoes db "Resultado das Simulacoes:", "$"
    msgStatusFimSimulacoes db "Peca      Jogadas      Valor", "$"
    ;=============

    ; Menu PRINCIPAL
    menu_titulo db 09,32,32,32,32,'Adriano G. Silva', 13, 10
                db 09,09,32,32,'e', 13, 10
                db 09,32,32,32,32,'Ricardo Turella', 13, 10,13,10,13,10
                db 09,32,32,32,32,32,32,'Jogar 2048', 13, 10
                db 09,32,32,32,32,32,32,32,'Recordes', 13, 10
                db 09,32,32,32,32,'Automatico 2048', 13, 10
                db 09,32,32,32,32,32,32,32,32,32,32,'Sair', 13, 10, 13, 10
    ;=============

    ; 2048 (byte a byte)do menu principal
    2048    db 64 dup (0)
            db 64 dup (0)
            db 4 dup (0), 7 dup(9),12 dup (0),2 dup (0EH),8 dup(0), 2 dup (0EH),10 dup (0),2 dup (0EH), 8 dup (0),2 dup(9), 7 dup(0)
            db 3 dup (0),3 dup (9),3 dup (0),3 dup (9),10 dup(0),4 dup(0EH),7 dup(0),2 dup(0EH),10 dup(0),2 dup(0EH), 7 dup(0),4 dup (9),6 dup (0)
            db 0,0,9,9, 7 dup(0) ,9,9, 8 dup(0) ,0EH,0EH,0,0,0EH,0EH, 6 dup (0) ,0EH,0EH,10 dup(0),0EH,0EH,6 dup(0) ,9,9,0,0,9,9, 5 dup(0)
            db 0,9,9,8 dup(0),3 dup(9),6 dup(0),0EH,0EH,4 dup(0),0EH,0EH,5 dup(0),0EH,0EH,10 dup(0),0EH,0EH,5 dup(0),9,9,4 dup(0),9,9,4 dup(0)
            db 0,9,10 dup(0),9,9,5 dup(0),0EH,0EH,6 dup(0),0EH,0EH,4 dup (0),0EH,0EH,10 dup(0),0EH,0EH,4 dup(0),9,9,6 dup(0),9,9,3 dup(0)
            db 0,9,10 dup(0),9,9,4 dup(0),0EH,0EH,8 dup(0),0EH,0EH,3 dup(0),0EH,0EH,10 dup(0),0EH,0EH,3 dup(0),9,9,8 dup(0),9,9,0,0
            db 12 dup(0),9,9,3 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,0EH,0EH,10 dup(0),0EH,0EH,0,0,9,9,10 dup(0),9,9,0
            db 12 dup(0),9,9,3 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,0EH,0EH,10 dup(0),0EH,0EH,0,0,9,9,10 dup(0),9,9,0
            db 12 dup(0),9,9,3 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,0EH,0EH,10 dup(0),0EH,0EH,0,0,9,9,10 dup(0),9,9,0
            db 11 dup(0),3 dup(9),3 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,0EH,0EH,10 dup(0),0EH,0EH,0,0,9,9,10 dup(0),9,9,0
            db 11 dup(0),3 dup(9),3 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,0EH,0EH,10 dup(0),0EH,0EH,0,0,9,9,9 dup(0),9,9,0,0
            db 10 dup(0),3 dup(9),4 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,0EH,0EH,0EH,8 dup(0),0EH,0EH,0EH,3 dup(0),9,9,7 dup(0),9,9,3 dup(0)
            db 9 dup(0),3 dup(9),5 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,0EH,0,0EH,0EH,6 dup(0),0EH,0EH,0,0EH,4 dup(0),9,9,5 dup(0),9,9,4 dup(0)
            db 8 dup(0),3 dup(9),6 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,0EH,0,0,0EH,0EH,4 dup(0),0EH,0EH,0,0,0EH,5 dup(0),3 dup(9),0,0,9,9,5 dup(0)
            db 7 dup(0),3 dup(9),7 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,0EH,3 dup(0),6 dup(0EH),0,0,0,0EH,6 dup(0),6 dup(9),5 dup(0)
            db 6 dup(0),3 dup(9),8 dup(0),0EH,0EH,10 dup (0),0EH,0EH,0,0,12 dup(0EH),0,0EH,5 dup(0),3 dup(9),0,0,3 dup(9),4 dup(0)
            db 5 dup(0),3 dup(9),9 dup(0),0EH,0EH,10 dup (0),0EH,0EH,13 dup(0),0EH,0,0EH,4 dup(0),9,9,6 dup(0),9,9,3 dup(0)
            db 4 dup(0),3 dup(9),10 dup(0),0EH,0EH,10 dup (0),0EH,0EH,13 dup(0),0EH,0,0EH,3 dup(0),9,9,8 dup(0),9,9,0,0
            db 3 dup(0),3 dup(9),11 dup(0),0EH,0EH,10 dup (0),0EH,0EH,13 dup(0),0EH,0,0EH,0,0,9,9,10 dup(0),9,9,0
            db 2 dup(0),3 dup(9),12 dup(0),0EH,0EH,10 dup (0),0EH,0EH,13 dup(0),0EH,0,0EH,0,0,9,9,10 dup(0),9,9,0
            db 0,3 dup(9),13 dup(0),0EH,0EH,10 dup (0),0EH,0EH,13 dup(0),0EH,0,0EH,0,0,9,9,10 dup(0),9,9,0
            db 3 dup(9),14 dup(0),0EH,0EH,10 dup (0),0EH,0EH,13 dup(0),0EH,0,0EH,0,0,9,9,10 dup(0),9,9,0
            db 3 dup(9),9 dup(0),9,5 dup(0),0EH,0EH, 8 dup(0),0EH,0EH,14 dup(0),0EH,0,0EH,3 dup(0),9,9,8 dup(0),9,9,0,0
            db 3 dup(9),8 dup(0),9,9,6 dup(0),0EH,0EH,6 dup(0),0EH,0EH,15 dup(0),0EH,0,0EH,4 dup(0),9,9,6 dup(0),9,9,3 dup(0)
            db 3 dup(9),8 dup(0),9,9,7 dup(0),0EH,0EH,4 dup(0),0EH,0EH,16 dup(0),0EH,0,0EH,5 dup(0),9,9,4 dup(0),9,9,4 dup(0)
            db 4 dup(9),6 dup(0),3 dup(9),8 dup(0),2 dup (0EH),2 dup(0),2 dup(0EH),17 dup (0),0EH,0,0EH,6 dup(0),2 dup(9),2 dup(0),2 dup(9),5 dup(0)
            db 0,11 dup(9),10 dup(0),4 dup(0EH),18 dup(0),0EH,0,0EH,7 dup(0),4 dup(9),6 dup(0)
            db 2 dup (0),9 dup (9), 12 dup(0), 2 dup(0EH),19 dup(0),3 dup (0EH),8 dup (0),2 dup (9), 7 dup(0)
            db 64 dup (0)
            db 64 dup (0)
            db 64 dup (9)
            db 16 dup (0),32 dup(0EH), 16 dup (0)
            db 16 dup (0),32 dup(0EH), 16 dup (0)
            db 64 dup (9)
    ; ================

    ; variaveis pertinentes ao print de sprites na tela (byte a byte)
    yposition equ 22
    xposition equ 128
    colsSprite equ 36
    ; ================
    ; var que mantem os chars para exibir na tela em qual direcao a IA moveu
    aiArrows db 24, 25, 27, 26, '$'
    ; ================================
    ; recordes
    RecordesTitulo db "RECORDES"
    RecordesCabecalho db "  NOME      JOGADAS PONTOS"
    RecordesTextos db    "1 Ricardo       101  12450"
                   db    "2 Ricardo        87    700"
                   db    "3 Ricardo        86    670"
                   db    "4 Ricardo        79    600"
                   db    "5 Ricardo        56    450"
    RecordesPontos dw 0,0,0,0,0
    RecordesContador db 0
    RecordesNenhum db "Nao ha nenhum recorde ainda..."
    PressioneUmaTecla db "Pressione uma tecla para voltar..."
    RecordesNovoRecore db "NOVO RECORDE"
    RecordeDigite db "Digite seu nome e pressione enter:"
    FimDeJogoStr db "FIM DE JOGO"
    ; ===============================
.code

; macros
empilhax macro
  push ax
  push bx
  push cx
  push dx
endm
desempilhax macro
  pop dx
  pop cx
  pop bx
  pop ax
endm

; Procs relacionadas a mudanca de modo
modoVGA proc  ; proc que muda para o modo 320x240 (grafico, com 1 pagina)
      push AX
        mov ax,13h ; modo 320x240 256 cores
        int 10h
      pop AX
    ret
endp modoVGA

modoText proc ; proc que muda para o modo DEFAULT do dos (texto 40x25)
      push AX
        mov ax, 03h ; modo original DOS
        int 10h
      pop AX
    ret
endp modoText

escChar proc     ;PROC que escreve o char passado em AX na posicao
    push AX 	 ; em que estiver o cursor. Nao recebe atributo (cor)
    push cx
      mov cx,1
      mov AH, 0Eh
      int 10h
    pop cx
    pop AX
    ret
endp

posicionaCursor proc        ;Proc responsavel por posicionar o cursor na tela
					                  ;recebe em :DH = linha.
	   push ax		            ;DL = coluna.
	   push bx
	   push dx
  	   mov ah,2
  	   xor al,al
  	   xor bx,bx
  	   INT 10h
	   pop dx
	   pop bx
	   pop ax
   ret

endp posicionaCursor


						; PROC que (SE SI ==0)
converteNumStr PROC     ; Escreve um numero armazenado em AX  em um
						; OFFSET passado para DI (ou seja, em um vetor>
        empilhax
        			; SE SI == 1, O FUNCIONAMENTO EH O A SEGUIR:
        			; RECEBE EM BP o offset para onde o número será copiado
        			; SE DI for passado como 0,
        push bp			; DX precisarah conter linha (DH) e coluna (DL)
						; para escrever o char na tela
						; Retorna em DI a posicao correta do vetor

        cmp SI,0
        jnz cns_prepara_divisao
               ; se for zero, posiciona o cursor na posicao passada por DX
               ; a pagina sempre serah 0 pois o modo VGA soh possui 1 page
        call posicionaCursor

   cns_prepara_divisao:
        xor cx, cx
        mov bx,10
   DIVIDE:
        xor dx,dx
        div bx
        ; obtem a unidade do n�mero
        xor dh,dh
        add dl,'0'
        ; transforma em caractere
        push dx
        ; empilha caractere
        inc cx
        or ax, ax
        jnz DIVIDE

        cmp SI,0
        jnz cns_escb_prepara       ; se entrou aqui, eh a parte final de simulacao

        mov ah, 2
        xor al,al
        mov dh, 4
        mov dl, 2
        xor bh,bh
        mov bl,0Eh

   cns_escChar:      ; escreve os valores empilhados onde o cursor estiver
        pop ax
        call escChar    ; nao aceita atributo :)

        loop cns_escChar

        jmp cns_pops
   cns_escb_prepara:
        mov DI, bp; offset passado em BP
        cld

   escb:  ; copia os valores empilhados para o vetor
        pop ax
        stosb
        loop escb

  cns_pops:

        pop bp
        desempilhax
      ret
endp converteNumStr


statusTela proc        ; PROC que printa a linha de status na tela

    empilhax
    push BP

    mov SI,1	; SI == 1 define 1 funcionamento
				; diferenciado para a procconverteNumStr
    ; ============================= Escore do Jogador
    ; ======== Mensagem
    mov BP, OFFSET msgEscoreJogador
    mov cx, 6
    mov bx, 9 ; atributo letra
    mov dh, 2   ; linha
    mov dl, 1   ; coluna

    call printTela

    ; ========= Escore (pontos)

    mov ax, [scoreTela]
    mov BP, offset msgEscoreJ
    call converteNumStr

    add dl, 6   ; coluna

    call statusPrintNums

    ; ========================

    call limpaMsgsStatus

    ; ============================= Jogadas do Jogador
    ; ======== Mensagem
    mov BP, OFFSET msgJogadasJogador
    mov cx, 8h ; tamanho string
    add dl, 6  ; coluna

    mov bx, 0Eh ; atributos string

    call printTela

    ; ========= Jogadas

    mov ax, [JogadasJogador]
    mov BP, offset msgJogadasJ
    call converteNumStr

    add dl, 8  ; coluna
    call statusPrintNums

    ; ========================

    call limpaMsgsStatus

    ; aqui converte e printa
    ; tera no maximo 5 numeros

    ; ============================= Top escore do Jogador
    ; ======== Mensagem
    mov BP, OFFSET msgMelhorEscore
    mov cx,  4h
    add dl, 6  ; coluna
    mov bx, 9

    call printTela

    mov ax, [RecordesPontos]
    cmp ax, [scoreTela]
    ja st_topescoreTop

    mov ax, [scoreTela]
    ; ========= Top Escore
st_topescoreTop:
    mov BP, offset msgTopJ
    call converteNumStr

    add dl, 4  ; coluna
    call statusPrintNums
    ; =========================

    call limpaMsgsStatus

    pop BP
    desempilhax

    ret
endp statusTela


limpaMsgsStatus proc  ; Proc que ZERA os valores das msg de status
      push ax         ; recebe em DI o valor das mensagens
      push cx
      push bp
        cld
        mov cx, 4
        xor ax,ax
        rep stosb
      pop bp
      pop cx
      pop ax
    ret
endp

aiSimulacoesFim proc  ; Proc que exibe o resultado
    empilhax          ; das simulacoes ao fim das N simulacoes
    push DI           ; definidas pelo usuario
    push SI
    push bp

      mov bp, offset msgResultadosFimSimulacoes
      mov dh, 2
      mov dl, 6
      mov bx, 0EH
      mov cx, 25
      call printTela

      ; seta e escreve mensagem relativa aos
      ; blocos, jogadas e escore
      mov bp, offset msgStatusFimSimulacoes
      mov dh, 4
      mov dl, 4
      mov bx, 9
      mov cx, 28
      call printTela

      mov bp, offset numsTela
      mov cx, 4
      add bp, 20                     ; para escrever o numero
      mov ax, cx                     ; dos blocos com seus
      inc ax                         ; valores corretos partindo do 32 (5*4 pois 4 casas cada num)
      mov dh, 7   ; linha
      mov dl, 4   ; coluna

  asf_telasnums:    ; a sequencia a seguir apenas escreve na tela as mensagens
      push ax       ; e os numeros (acima de 2^4)
      push cx
      push bp
        push dx
          xor dx,dx
          call setAtributoNum
        pop dx
        call printTela
      pop bp
      pop cx
      pop ax
      add bp, cx
      add dh, 2
      inc AX
      cmp AX, 11
      jna asf_telasnums ; loop até printar tod

      xor DI,DI
      xor si,si

      mov bp, offset jogadasFimIA
      mov cx, 7
      push cx
        mov dh, cl
        mov dl, 17
        mov bx,0
      asf_jogadas_scores:
        mov ax,DS:[BP][SI]
        push si
          xor si,si
          call converteNumStr
        pop si
        inc SI
        inc si
        add dh,2
        loop   asf_jogadas_scores
        inc bx
        cmp bx, 2
        jz   asf_fim
        xor si,si
      pop cx
      mov bp, offset scoreValoresFimIA
      mov dh, cl
      add dl, 12
      jmp asf_jogadas_scores

  asf_fim:
      call lerTecla ; apenas para manter a tela estatica enquanto
                    ; o usuario ve o resultado
      mov dx,2
      mov di, offset jogadasFimIA
      asf_limpaVals:            ; limpa as vars pertinentes
        xor ax,ax               ; aos valores de fim da simulacao
        mov cx,7
        rep stosw
        mov di, offset scoreValoresFimIA
        dec dx
        cmp dx,0
      jnz asf_limpaVals

    pop bp
    pop SI
    pop DI
    desempilhax
    ret
endp

statusPrintNums proc ; PROC que recebe em BP o offset da mensagem, em cx o
  push bx            ; tamanho eh padrao e em DL a quantidade correta de espacos
  push cx
    mov cx, 5       ; tamanho da string
    mov bx, 0Fh     ; Faz a passagem do atributo correto
    call printTela
  pop cx
  pop bx
  ret
endp statusPrintNums

printTelaNumeros   proc ; proc que coloca na tela os números e seus respectivos quadrados
                        ; ao fim, limpa o lixo grafico da tela com uma chamada a limpaFimTela
      empilhax
      push BP
      push DI
      ; inicio da matriz na tela
      mov dh, 4h
      mov [posSqrIL],  dh
      inc dh
      inc dh
      mov [posSqrIC],  colInicial
      xor cx, cx
      xor di,di
      ;========
ptn_print_lc:

      push AX
      push CX
        mov al, [MatrizJogo][DI]
        cbw
        mov cx, 4
        push dx
        mul cx
        pop dx
        mov BP, OFFSET numsTela ; pega o numero correto
        add BP, ax              ; com base em ax
      pop cx
      pop AX

      call setColuna    ; define qual a coluna

      push dx
        mov dx, 1
        call setAtributoNum ; define os atributos para determinado número na posicao
      pop dx

      call printSqrTela   ; Coloca 2 quadrados na tela, um com a cor do atributo do numero e outro preto

      push cx
        mov cx, 4           ; tamanho da string
        call printTela
      pop cx

ptn_cmp_c:   ; incrementa o contador de coluna

      inc DI
      inc ch
      cmp ch,4
      jnz ptn_print_lc
      xor ch,ch
      add dh, 5  ; inc linha
      push ax
        mov al, [posSqrIL]    ; incrementa a linha
        add al, 5
        mov [posSqrIL], al    ; armazena o inicio da linha
        mov [posSqrIC], colInicial
      pop ax
      inc cl
      cmp cl,4
      jnz ptn_print_lc

ptn_fim:
      call limpaFimTela
    pop DI
    pop BP
    desempilhax
    ret
endp printTelaNumeros


proc limpaFimTela ; PROC que limpa a tela com base em AL (para baixo) (ah==07)
	 empilhax       ; (faz isso chamando a executaScroll)
     mov al, 1
     mov ch, [posSqrIL]
     mov cl, colInicial
     mov dh, ch
     inc dh
     mov dl, cl
     add dl, 40
     xor bx,bx
     call executaScroll
	 desempilhax
  ret
endp limpaFimTela

proc executaScroll ; PROC que recebe em bh o atributo a ser passado para a tela ao scrollar
      mov ah, 07h ; em cx linha/coluna inicial; dx linha/coluna final; al o numero de linhas a
      int 10h     ; scrollar;
      ret
endp

proc telaPreta  ; PROC que limpa tudo que esta na tela
    empilhax    ; e deixa ela completamente preta (para baixo) (ah==07)
      xor bx,bx ; (faz isso chamando a executaScroll)
      xor cx,cx
      mov dh, 100
      mov dl, 100
      mov al, 00h
      call executaScroll
    desempilhax
    ret
endp telaPreta

proc printSqrTela       ; PROC que printa na tela os quadrados coloridos,
                        ; de acordo com os atributo recebido em BX (cor do quadrado)
     empilhax           ; Alem disso, ela printa o quadrado preto no centro
       ; ========= Quadrado normal
       mov ax, bx
       mov bh, al ; atributo
       xor bl,bl
       mov ch, [posSqrIL]
       mov cl, [posSqrIC]
       mov dh, ch
       mov dl, cl
       add dh, 5 ; inc linha por 5
       add dl, 5 ; inc col por 5
       mov al, 5    ; numero de linhas
       call executaScroll
       ; =======================
       ; armazena prox coluna
       inc dl
       mov [posSqrIC], dl
       dec dl
       ; ========= Quadrado preto
       mov al, 3
       inc ch
       inc cl
       inc dh
       dec dl
       xor bx,bx
       call executaScroll
       ; =======================
     desempilhax
     ret
endp

proc   printTela ; Proc que chama a int de printar na tela (teletype - ah=13h)
    push ax     ; recebe em BL o atributo; em BP, o que printar;
    push bx     ; em dh a linha em dl a coluna e em cx O TAMANHO DA STRINGS
      mov ah, 13h
      mov al,01h          ; define que moverah o cursor e o atributo estara em BL
      mov bh, 0h
      int 10h
      pop bx
      pop ax
    ret
endp printTela

printSetaIaTela PROC  ; PROC que apenas printa uma seta na tela
    push bx           ; de acordo com a direcao passada em BL
    push cx
    push dx
    push bp
      mov bp, offset aiArrows
      add bp, bx
      mov cx, 1
      mov bx, 9 ; atributo letra
      mov dh, 8   ; linha
      mov dl, 2   ; coluna
      call printTela
    pop bp
    pop dx
    pop cx
    pop bx
    ret
endp

proc setAtributoNum ; PROC que define a COR do atributo com base na matriz atribsTela
    push AX         ; se DX for passado como 0, devera conter em a posicao do num que
    push SI         ; deseja ter o atributo, caso contrario,
    push BP         ; recebe em DI a posicao correta do valor desejado
                    ; retorna em BX o atributo
      mov BP, OFFSET atribsTela
      cmp dx,0                  ; se for zero, busca o atributo com base em AX
      jz san_outramatriz        ; e nao DI
      mov BX, OFFSET MatrizJogo
      mov al, [bx][di] ; pega
      xor ah,ah
    san_outramatriz:
      mov SI, AX
      mov Al, DS:[BP][SI]
      mov BX, AX

    pop BP
    pop SI
    pop AX
    ret
endp  setAtributoNum


proc setColuna		; PROC que define a COLUNA onde serao escritos os numeros na TELA
    push AX       ; Em DH constara a LINHA. em DL, constara a COLUNA
    sc_chk_c:
        cmp ch, 0
        jnz sc_seta
        mov dl, 8
        jmp sc_fim
    sc_seta:
        mov al, 6   ; inc coluna
        add dl, al ; coluna
    sc_fim:
    pop AX
    ret
endp setColuna

verificaMultiplos proc       ; proc que verifica se ainda existem numeros iguais no tabuleiro
    empilhax                  ; e se sao contiguos; RETORNA EM AX: 1-- SIM ;  0-- NAO
    push DI                  ; esta proc nao verifica zeros pois
    push SI                   ; so sera chamada quando o tabuleiro
    push bp                   ; estiver cheio
      mov bx, offset MatrizJogo   ; prepara os valores
      mov bp, bx
      xor di,di

      push di
        mov ax,4    ; AQUI VERIFICA VERTICAL
        xor dh,dh
        mov dl,al
     vm_vertical_i:
        mov cx,3
        mov si,di
        add si,ax

        vm_vertical:
          push ax
            xor ax,ax
            mov al, ds:[bp+si]
            cmp [bx+di],al
            jz vm_fim_encontrou
          pop ax
          add di, ax              ; PRIMEIRO incrementa de 4 em 4
          add si, ax              ; Passando pelas 4 colunas
        loop vm_vertical        ; depois volta ao inicio
      pop di                  ; e incrementa de 1 em 1
      cmp dh, 0               ; para verificar as linhas
      ja vm_inc_4

      inc di
      jmp vm_continua

  vm_inc_4:
      add di, 4

  vm_continua:
      push di
        dec dl
        cmp dl,0
        jnz vm_vertical_i
        mov dl,4
      pop di
      mov di, 0
      push di
        mov ax, 1    ; PARTINDO DAQUI VERIFICA HORIZONTAL
        inc dh
        cmp dh,2
        jnz vm_vertical_i
        xor ax,ax                               ; nao encontrou 1 valor igual
        jmp vm_fim
        vm_fim_encontrou:
        pop ax
        mov ax, 1                               ; encontrou um valor igual
      vm_fim:
      pop DI	; Possui um POP extra pois ira ter empilhado DI 2x
    pop bp
    pop SI
    pop DI
    desempilhax

    ret
endp verificaMultiplos

; solicita a quantidade de simulacoes para realizar na IA
; retorna em CX um numero
lerQuantidadeJogadas proc

    call telaPreta
    push ax
    push bx
    push dx
    push bp
    ; cor do texto
    mov BL, 00eH
    ; mensagem para inserir a quantidade de vezes
    mov BP, offset msgQtsVezesSimular
    mov CX, 32
    mov DX, 0605h
    call printTela

    mov cx, 1 ; cx e o tamanho para imprimir o numero da tela
              ; e impresso um digito por vez, entao sempre sera um
    mov dh, 15 ; linha
    mov dl, 15 ; coluna
    mov bp, offset simuladorNumero
    xor ah, ah ; ah ser� o contador de digitos

    LOOP_LER_NUMERO:
        call lerTecla  ; em al tem um caractere
        ; enter
        cmp al, 13
        je LOOP_LER_NUMERO_ENTER
        ; valida um numero
        cmp al, '0'
        jb LOOP_LER_NUMERO
        cmp al, '9'
        ja LOOP_LER_NUMERO
        ; aqui j� tem um digito valido
        inc ah
        ; imprime o digito
        mov byte ptr [simuladorNumero], al
        inc dl
        call printTela
        ; converte para numero e bota na pilha
        sub al, '0'
        push ax
        ; continua o loop
        jmp LOOP_LER_NUMERO

        ; pressionou o enter
        LOOP_LER_NUMERO_ENTER:
            and ah, ah ; se o ah esta vazio, continua no loop, pq nenhum numero foi inserido
            jz LOOP_LER_NUMERO
    ;;;;
    ; converte em numero
    ; cx contem a quantidade de digitos
    xor cx, cx
    mov cl, ah
    xor bx, bx ; bx contera o numero retirado da pilha
    mov ax, 1 ; ax contera a potencia em base 10
    LOOP_CONVERTE_NUMERO:
        pop dx
        xor dh, dh ; somente dl contem um digito
        push ax ; salva o ax
          mul dx ; multiplica o ax (que tem uma potencia de 10) pelo numero na pilha
          add bx, ax ; adiciona o conteudo do ax
        pop ax ; recupera o ax
        mov dx, 10
        mul dx ; adiciona uma pontencia a AX
        loop LOOP_CONVERTE_NUMERO
    ; coloca em cx o resultado, que e onde deve ser retornado
    xchg cx, bx

    pop bp
    pop dx
    pop bx
    pop ax
    ret
endp lerQuantidadeJogadas

ai2048 proc                 ; proc que efetua a execucao do simulador de jogo 2048
    empilhax                ; ela utiliza 2 matrizes, 1 oficial e 1 que e um clone
    push DI                 ; da oficial. Para cada direcao, ela testa N vezes a matriz
    push SI                 ; clone, nas 4 direcoes (em profundidade?), para determinar
    push BP                 ; qual movimento gerara a melhor pontuacao N movs 'no futuro';
                            ; e entao efetua o mov na Matriz oficial e passa para o proximo round.
      call lerQuantidadeJogadas ; le a quantidade de jogadas em CX
      ; verifica se e zero....
      AND CX, CX
      JZ FIM_ai2048
      call telaPreta
  ai2_mainloop:

      push ax ; zera o controle das potencias maiores que 5
      push cx ; para a simulacao
      push es
      push DI

        mov cx,7
        xor ax,ax
        mov DI, offset jogadasRoundIA
        rep stosb

      pop DI
      pop es
      pop cx
      pop ax

      call resetarJogo

      push cx

    ai2_loop_um_jogo: ; prapara  as variaveis
        xor ax,ax     ; para uma simulacao
        mov [melhorScoreIA],ax
        mov [melhorMovIA], al
        cmp [CasasVazias], al
        jnz ai2_colocarPeca

        ; verifica��o quando n�o hah mais espa�os vazios, se serah possivel realizar 1 mov
        call verificaMultiplos
        cmp ax, 0
        je ai2_fimjogo
        jmp ai2_parteGrafica ; existem multiplos
    ai2_colocarPeca:
        cmp [PecasJaMovidas], al
        je ai2_parteGrafica
        mov [PecasJaMovidas], al
        call colocarPeca
    ai2_parteGrafica:
        ; PROCS GRAFICAS
        call statusTela ;
        call printTelaNumeros
        ;call delay   ; caso queira ver as pecas movendo, descomente isso :)
        ; armazena pois precisarah dps
        mov dl, [CasasVazias]
        xor dh,dh
        push dx
    ai2_clone:
          mov bh,2
          mov bl, 48h  ; comeca c o movimento p cima
          push bx
            mov [melhorMovIA], 0
    ai2_clone_testa_todos_movs: ; testa qual dos 4 movimentos para o tabuleiro oficial resultara
            mov cx,16           ; no melhor escore (primeiro testa no CLONE)
            mov SI, offset MatrizJogo ; e entao, passara para o oficial la no fim
            mov DI, offset MatrizClone
            rep movsb
            mov [melhorScoreClone],0

            mov BP, offset MatrizClone
          pop bx
          mov al, bl
          push bx
            xor ah,ah

            call qualDirMover
            cmp [PecasJaMovidas],0
            jz ai2_continua_pos_melhorScoreIa

            call aiFitness
            cmp ax,0
            je ai2_ava
          pop bx
          mov [melhorScoreIA], ax
          mov [melhorMovIa], bl
          push bx
    ai2_ava:
          mov cx, 2
    ai2_avalia_em_profundidade:     ; na direcao movida, move mais N (N == CX) vezes e retorna sempre o melhor score
                                    ; das N vezes
            mov BP, offset MatrizClone
            call ai2048mover            ;faz os movimentos no clone (nas 4 direcoes, N vezes)
            mov BP, offset MatrizClone
            call maiorPecaCanto         ; verifica se a maior peca esta no canto
            cmp ax, 0                   ; se estiver, blz
            jz ai2_continua_pos_punicao
            mov ax,01FFh        ; punicao ao escore pela peca
            sub dx,ax           ; maior nao estar no melhor canto
    ai2_continua_pos_punicao:
            cmp dx, [melhorScoreClone]
            jna ai2_continua_pos_melhorScoreClone
            mov [melhorScoreClone],dx
    ai2_continua_pos_melhorScoreClone:
            dec cx
            cmp cx,0
            jnz ai2_avalia_em_profundidade      ; loop enquanto nao avaliou ate a 'folha' da profundidade
            ; -----------------
            mov bx, [melhorScoreClone]
            cmp bx, [melhorScoreIA]       ; se o melhor escore de uma das N vezes for maior do que o escore
            jna ai2_continua_pos_melhorScoreIa         ; atual da IA, troca e passa o mov RAIZ das N vezes para a var de controle
            mov [melhorScoreIA], bx
          pop bx
          mov [melhorMovIA],bl ; classifica esse como melhor move
          push bx
    ai2_continua_pos_melhorScoreIa:
          pop bx

          add bl,3
          cmp bl,4Eh                   ; tecnica avancada de programaca
          jne ai2_continua_pos_dec_especial ; verifica se ja foi
          dec bl

    ai2_continua_pos_dec_especial:

          mov [PecasJaMovidas],0                   ; reseta
        pop dx
        mov [CasasVazias], dl                    ; reseta

        push dx
        push bx
          cmp bl, 50h     ; verifica se moveu em todas as direcoes
          jna ai2_clone_testa_todos_movs  ; se passar de 50, moveu
        pop bx
        pop dx

        mov al, [melhorMovIA]
        xor ah,ah
        mov bh,1            ; seta que eh a jogada oficial da IA
        mov bp, offset MatrizJogo
        call qualDirMover

        cmp [PecasJaMovidas], 0
        je ai2_venceuPerdeu
        inc [JogadasJogador]
    ai2_venceuPerdeu:
        cmp [venceuPerdeu], 1        ; venceu
        jb ai2_loop_um_jogo
                                     ; se cair 2. perdeu
    ai2_fimjogo:
        call statusTela
        call printTelaNumeros
      pop cx
      dec cx
      jnz ai2_mainloop

  ai2_pops:
      call telaPreta
      call aiSimulacoesFim  				; tela com os resultados da simulacao
  FIM_ai2048:
      mov DI, offset msgTopJ
      call limpaMsgsStatus

    pop BP
    pop SI
    pop DI
    desempilhax
    ret
endp ai2048

aiFitness proc       ;  PROC que efetua o produto escalar da matriz em BP pela matriz
    empilhax          ; de pesos. Este valor eh reunido em AX, que, por sua vez, sera
    push si           ; multiplicado pelo numero de casas vazias (se estiverem vazias + de 10)
    push bp           ; caso contrario, nao multiplica pelo nro de casas vazias :)
                      ; retorna em AX o fitness (pontuacao do tabuleiro levando o criterio acima)
                      ; recebe em BX a matriz peso
                      ;  recebe em BP a matriz normal
      mov cx,16
      mov bx, offset MatrizPesos
  aif_verifica_melhor_mov:
      cmp DS:[BP][SI],0
      jz aif_continua_loop_verifica_melhor_mov
                                ; efetua o produto escalar da matriz em BP com a matriz de pesos
      push dx
        xor ax,ax
        xor dh,dh
        mov al,DS:[BP][SI]
        mov dl, DS:[BX][SI]
        mul dx
      pop dx

      add dx,ax
  aif_continua_loop_verifica_melhor_mov:
      inc SI
      loop aif_verifica_melhor_mov
      mov ax, dx
      mov dl, 16
      xor dh,dh
      sub dl, [CasasVazias]
      cmp dl,10
      ja aif_pop
      mul dx
  aif_pop:

    pop bp
    pop si
    desempilhax
    ret
endp aiFitness

maiorPecaCanto proc ; Proc que verifica se a maior peca esta no canto
    push CX         ; de maior peso do tabuleiro. Retorna em ax 0 se nao estiver
    push BX         ; ou maior que 0 se sim e em BP recebe a matriz a ser verificada.
    push DX
    push DI       ; primeiro busca a pos de c o maior peso no tabuleiro de pesos
    push SI       ; depois busca a pos com a maior pesa no tabuleiro oficial
      mov cx,2
      mov BX, offset MatrizPesos
  mpc_set:
      push cx
        mov cx, 16
        xor DI,DI
        xor dx,dx
    mpc_verif:
        cmp [BX][DI], dl
        inc DI
        ja mpc_loop
        mov dx, DI
    mpc_loop:
        loop mpc_verif  ; busca o maior valor
      pop cx
      dec cx
      push DX     ; empilhara 2x para comparar
        mov BX, BP
        xor DI,DI
        cmp cx,0
        jne mpc_set
      pop AX    ; pop o primeiro valor
      pop DX    ; pop o segundo valor

      cmp ax,dx ; se encontrou na ultima pos o maior valor (compara as posicoes),
      je mpc_pops ; vai ao fim (maior que zero eh verdadeiro)
      xor ax,ax   ; p esse retorno, caso contrario, zera.

  mpc_pops:
    pop SI
    pop DI
    pop DX
    pop BX
    pop CX
    ret
endp maiorPecaCanto

ai2048mover proc        ;PROC que recebe em BP a matriz a ser movida
     empilhax           ; no caso, eh usada para testar a matriz CLONE
     push di            ; e verificar qual dos movs dela possui o melhor fitness
     push si            ; retorna em DX o melhor valor dentre os 4 possiveis movimentos

      mov al, [CasasVazias] ; armazena a [CasasVazias] para restaurar posteriormente
      push ax
    ai2_loop_um_jogo_clone_setup:
        mov bl, 48h   ; direcao inicial (cima)
        xor dx,dx
        mov bh,2     ; seta que serao os 4 movimentos da matriz CLONE
    ai2_loop_um_jogo_clone:          ;tentarah os 4 movs e armazenarah o escore

        mov [PecasJaMovidas],0
        mov al, bl
        xor ah,ah

        push BP
          call qualDirMover ; move na proxima direcao
        pop BP

        cmp [PecasJaMovidas],0 ; se nao moveu, vai pro proximo
        jz ai2_finaliza_verifica_melhor_mov

        xor SI,SI
        xor ax,ax
        call aiFitness

        cmp ax, dx    ;se o escore nao eh maior que o TOP escore do fitness,
        jna ai2_finaliza_verifica_melhor_mov_sem_pop  ;pula para o proximo mov
        mov dx, ax

        jmp ai2_finaliza_verifica_melhor_mov_sem_pop
    ai2_finaliza_verifica_melhor_mov:
        jmp ai2m_pops
    ai2_finaliza_verifica_melhor_mov_sem_pop:

        add bl, 3
        cmp bl,4Eh
        jne ai2_continua_dec
        dec bl

    ai2_continua_dec:
        cmp bl,50h
        jna ai2_loop_um_jogo_clone

    ai2m_pops:
      pop ax  ; restaura o valor do db [CasasVazias]
      mov [CasasVazias],al

    pop si
    pop di
    desempilhax
    ret
endp ai2048mover

player2048 proc		; PROC PRINCIPAL do jogo (player vs tabuleiro)

    empilhax
    push DI
    push SI
      xor ax,ax
      call telaPreta
      XOR DI,DI
      xor bx,bx         ; define que � o player e n�o a IA que est� jogando
      call resetarJogo	; ZERA o tabuleiro e o status
      mov BP, OFFSET MatrizJogo
  p2_letecla:
      push ax
        xor ax,ax
        cmp [CasasVazias], al
        jnz p2_colocarPeca
        ; verifica��o quando n�o hah mais espa�os vazios, se serah possivel realizar 1 mov
        call verificaMultiplos
        cmp ax, 0
        je p2_venceu_perdeu_compop
      pop ax
        jmp p2_prossegue
    p2_colocarPeca:
        cmp [PecasJaMovidas], al
      pop ax
      je p2_prossegue
      push ax
        xor ax,ax
        mov [PecasJaMovidas], al
        call colocarPeca
      pop ax
  p2_prossegue:
      ; PROCS GRAFICAS
      call statusTela ;
      call printTelaNumeros
      ;======================================
      call lerTecla       ; trecho de validacao user digitou opcao valida
        cmp al, 48h   ;CIMA.
        je  mov_qualdirmover
        cmp al, 50h   ;BAIXO.
        je  mov_qualdirmover
        cmp al, 4Bh   ;ESQUERDA.
        je  mov_qualdirmover
        cmp al, 4Dh   ;DIREITA.
        je  mov_qualdirmover
        cmp al, 1Bh      ; COMPARA COM ESC
        je p2_venceu_perdeu_sempop
        jmp p2_letecla
  ;   === Movimentação cima baixo
  mov_qualdirmover:
      call qualDirMover
  ;   ============
  ; verificacao de FINAL DE JOGO
  verif_mov:
      cmp [PecasJaMovidas], 0
      je p2_vp        ; se nao moveu nenhuma peca, acabou o games
      inc [JogadasJogador]
  p2_vp:
      cmp [venceuPerdeu], 1        ; venceu
      jb p2_letecla
      jmp p2_venceu_perdeu_sempop:        ; se cair 2. perdeu
  p2_venceu_perdeu_compop: ;atualizacao final da tela
      pop ax
  p2_venceu_perdeu_sempop:
      call statusTela
      call printTelaNumeros
      ; exibe mensagem de fim de jogo/entrar hall da fama!
      call fimDeJogo
  ;   ============
      call telaPreta
    POP SI
    POP DI
    desempilhax

    ret
endp

; proc para ser rodada no game over
fimDeJogo proc

    call telaPreta

    empilhax
    push BP
    push SI

    ; texto de game over
    mov BL, 00eH
    mov BP, offset FimDeJogoStr
    mov CX, 11
    mov DX, 050Eh
    call printTela

    ; pontos
    mov CX, 6
    mov DX, 090Ch
    mov bp, offset msgEscoreJogador
    call printTela

    add DL, 7
    MOV CX, 5
    mov bp, offset msgEscoreJ
    call printTela

    ; JOGADAS
    mov CX, 8
    mov DX, 0B0Ch
    mov bp, offset msgJogadasJogador
    call printTela

    add DL, 9
    MOV CX, 5
    mov bp, offset msgJogadasJ
    call printTela

    ; verifica se um novo recorde foi obtido

    mov AX, [scoreTela]
    mov BX, offset RecordesPontos
    mov SI, 8

    xor CX, CX
    mov CL, 5 ;[RecordesContador]

    xor DX, DX

    VERIFICA_RECORDE:
        cmp AX, BX[SI]
        jbe FIM_VERIFICA_RECORDE
        sub SI, 2
        inc DX
        loop VERIFICA_RECORDE

    FIM_VERIFICA_RECORDE:

    and DX, DX
    jz NAO_TEM_RECORDE

    ; tem recorde \o/
        mov CX, 5
        sub CX, DX ; cx contem a nova posicao do recorde
        call deslocaRecordes

        mov ax, cx ; ax contem a nova posicao do recorde

        ; mostra texto de novo recorde e mensagem para inserir nome
        mov BL, 00eH

        mov BP, offset RecordesNovoRecore
        mov CX, 12
        mov DX, 0F0Dh
        call printTela

        mov BP, offset RecordeDigite
        mov CX, 34
        mov DX, 01103h
        call printTela

        ; le o nome do jogador
        call leNomeRecorde

        ; incrementa o contador de recordes
        cmp byte ptr [RecordesContador], 5
        je MOSTRAR_RECORDES_NOME
        inc byte ptr [RecordesContador]

        MOSTRAR_RECORDES_NOME:
        call mostraRecordes

    jmp FIM_FIM_DE_JOGO

    NAO_TEM_RECORDE:
        mov BP, offset PressioneUmaTecla
        mov DX, 1303h
        mov BL, 00eH
        mov CX, 34
        call printTela
        call lerTecla
    FIM_FIM_DE_JOGO:

    pop SI
    pop BP
    desempilhax
    ret
endp fimDeJogo

  ;; le um nome digitado pelo usuario
  ; e coloca na posicao
  ; ax contem a posicao do recorde
leNomeRecorde proc

    empilhax
    PUSH SI
    PUSH BP

      mov AH, 26
      mul AH
      mov BP, offset RecordesTextos
      add BP, AX

      inc BP
      inc BP

      xor SI, SI

      mov CX, 0
      mov DX, 0140fh

      LER_LETRAS:
          call lerTecla

          ; teclou enter
          cmp AL, 13
          je lerTecla_ENTER

          ; teclou backspace
          cmp AL, 8
          je lerTecla_BACKSPACE

          ; acima de 10 letras soh enter e backspace
          cmp CX, 10
          je LER_LETRAS

          ; valida as letras
          ; soh aceita entre 20 (espaco) e 7e (~)
          cmp AL, 07eh
          ja LER_LETRAS

          cmp AL, 020h
          jb LER_LETRAS

          mov DS:[BP][SI], AL

          inc CX
          inc SI

          call printTela

          jmp LER_LETRAS

          ; teclou enter
          lerTecla_ENTER:
              and CX, CX
              jz LER_LETRAS ; nenhuma letra foi inserida
              jmp FIM_LER_RECORDE

          lerTecla_BACKSPACE:
              and CX, CX
              jz LER_LETRAS ; nenhuma letra foi inserida, nao apagar nada

              ; retroceder 1
              dec SI
              mov byte ptr DS:[BP][SI], ' '
              call printTela

              dec CX
              jmp LER_LETRAS

      FIM_LER_RECORDE:

      ; bota o resto com espacos
      BOTAR_ESPACOS:
          cmp CX, 10
          je CONTINUA_BOTAR_RECORDE

          mov byte ptr DS:[BP][SI], ' '

          inc CX
          inc SI

          jmp BOTAR_ESPACOS

      CONTINUA_BOTAR_RECORDE:

      mov di, si
      add di, 2
      add di, bp

      mov si, offset msgJogadasJ
      mov cx, 5
      cld
      rep movsb
      add di, 2
      mov si, offset msgEscoreJ
      mov cx, 5
      cld
      rep movsb

    POP BP
    POP SI
    desempilhax
    ret
endp leNomeRecorde

; desloca os recordes de CX pra tras
deslocaRecordes proc
    empilhax
    push SI
    push DI

    ;;;;
    ; move os scores na lista
    mov SI, offset RecordesPontos
    add SI, 8 ; aponta o SI para o final da lista de recordes (numero)

    mov DI, SI

    ; SI aponta para uma posicao antes do final
    dec SI
    dec SI

    std ; seta para decrementar o direction flag

    push cx
    push dx

    mov dx, 4
    sub dx, cx
    mov cx, dx

    and cx, cx
    jz PULA_LOOP_RECORDES_1

    LOOP_RECORDES_1:
        movsw
        loop LOOP_RECORDES_1

    PULA_LOOP_RECORDES_1:
    mov cx, [scoreTela]
    mov [di], cx

    pop dx
    pop cx
    ;;;;

    mov BX, 3
    xor CH, CH ; so pra garantir, zerar a parte alta de CX

    mov AX, 26 ; tamanho da linha da tabela do recorde
    xor DX, DX
    mul BX ; ax contem a posicao de deslocamento da posicao 3 do recorde

    mov SI, offset RecordesTextos
    add SI, AX ; SI aponta para a penultima posicao

    inc SI ; o primeiro caractere e um numero - e nao deve ser mudado.
           ; por isso SI comeca ali

    mov DI, SI
    add DI, 26 ; DI aponta para a ultima posicao

    cld ; incrementa SI e DI

    inc CX
    inc BX

    LACO_DESLOCA:
        cmp CX, BX
        ja FIM_LACO_DESLOCA
        push CX
        mov CX, 25
        DESLOCA_LINHA:
            movsb
            loop DESLOCA_LINHA
        pop CX

        ; cabalistico 51
        sub SI, 51  ; reverte o 25 da linha
        sub DI, 51  ; e o 26
        dec BX
        jmp LACO_DESLOCA

    FIM_LACO_DESLOCA:

    pop DI
    pop SI
    desempilhax
    ret
endp deslocaRecordes

qualDirMover proc ; proc cuja funcao e verificar em que posicao
   push AX        ; DI ira iniciar (em que coluna do tabuleiro)
   push bx        ; RECEBE em AL a direcao (cima == 48h, baixo == 50h)
   push DI        ; (esquerda == 4Bh, direita == 4Dh)
     cmp al, 48h   ;CIMA.
     je  qdm_cima
     cmp al, 50h   ;BAIXO.
     je  qdm_baixo
     cmp al, 4Bh   ;ESQUERDA.
     je  qdm_esq
     cmp al, 4Dh   ;DIREITA.
     je  qdm_dir

  qdm_cima:
      xor bl, bl
      xor DI, DI
      jmp  qdm_mov
  qdm_baixo:
      mov bl, 1
      mov DI, 12
      jmp  qdm_mov
  ;   === Movimentação esquerda direita
  qdm_esq:
      mov bl, 2
      XOR DI,DI ; zera o DI
      jmp  qdm_mov
  qdm_dir:
      mov bl, 3
      mov DI, 3
  qdm_mov:
      cmp bh,0
      jne qdm_mov_continua
      call printSetaIaTela      ; coloca uma seta na tela para indicar para onde
  qdm_mov_continua:             ; foi (ou nao) o mov :)
      call movimento

   pop DI
   pop bx
   pop ax
   ret
endp qualDirMover

delay proc    ; essa proc so existe para caso seja necessario ver os movimentos
  empilhax    ; do SIMULADOR
    xor cx,cx
    mov dx,12Ch     ; quantos ms de delay
    mov ah, 86h
    int 15h
  desempilhax
  ret
delay endp

; ============
movimento proc      ; proc responsavel pelo MOVIMENTO das pecas
    push AX         ; Usa BL  para verificar QUAL LADO e BH para indicar
    push cx         ; se o movimento eh da IA (BH=1), do clone da IA (BH=2) ou
    push dx         ; na principal (BH=0). Assume que em BP esta o OFFSET
    push di         ; correto do tabuleiro
    push si

        xor CX, CX
        ; EM CL controla as linhas/colunas
        ; EM CH o loop da busca dos valores
    m_inicio:
        mov [valColAnterior], DI
        mov SI, DI  ; valor inicial de DI/SI eh igual p facilitar o mov
        mov CH, 4   ; quantas casas verificara
        xor AX,AX
    m_si_busca_val:
        inc ah          ;faz o controle se encontrou o fim da linha/coluna
        cmp ah, ch      ; se sim, pula ao final para ver se incrementa ou
        jz m_proxima_l_c_verifica ; acaba

        push AX
          mov AX, SI
          call andaUmaPos
          mov SI, AX
        pop AX

        cmp DS:[BP][SI],0
        jz m_si_busca_val

        ; compara se sao iguais
        push AX
          xor AX, AX
          mov al, DS:[BP][SI]
          cmp DS:[BP][DI],Al
          ; se nao forem, move para DI a posicao do prox
          jne m_compara_di_zero;
          inc DS:[BP][DI]
          inc byte ptr [PecasJaMovidas] ; incrementa para controle (se foi movido)
          inc byte ptr [CasasVazias] ; incrementa as casas vazias para continuar usando

          cmp bh,2    ; se for 2, eh a MATRIZ CLONE!!!
          jnb m_fim_score_tela
          cmp bh, 1   ; se nao for a IA OFICIAL (ou seja, o mov que altera mesmo), pula
          jnz m_adiciona_escore_tela
          xor ah,ah
          mov al, DS:[BP][DI]
          cmp al,4                       ; SE FOR MENOR QUE 32, nao entra (2^4)
          jna m_adiciona_escore_tela
          call armazenaValsIA            ; Entra na proc que verifica se armazena da IA
      								   ; a jogada/escore (se for a menor jogada a chegar naquele val)
      m_adiciona_escore_tela: ; ============ SCORE TELA =================

          push BX
            mov bx, 2
            xor ah,ah
            mov al, DS:[BP][DI]
            mul bl
            mov bx, ax                     ; busca o valor a ser somado, de acordo
            mov AX, DS:[numsTelaScore][BX] ; com o vetorzao de valores+BX
            cmp AX, 2048                   ; checa se jogo vai acabar ao fim do move
            jnz m_nao_e_2048
            mov [venceuPerdeu], 1 ; condicao de fim de jogo por ter feito 2048

        m_nao_e_2048:
            mov DX, [scoreTela]
            add DX, AX
            mov [scoreTela], DX
          pop BX
          ; ============ ========== =================
      m_fim_score_tela:
          mov DS:[BP][SI], 0     ; zera a posicao de onde SAIU a peca
          jmp m_avanca_di
      m_compara_di_zero:
          cmp DS:[BP][DI], 0
          jnz m_avanca_di
      m_zerador:                  ; se caiu aqui, o valor em DI
          mov AL, DS:[BP][SI]     ; eh zero
          mov DS:[BP][DI], AL
          mov DS:[BP][SI], 0
          inc byte ptr [PecasJaMovidas]
      m_zerador_ia:
          pop AX
          dec CH
          dec ah
          cmp CH, 0
          jnz m_si_busca_val         ; se nao for zero, busca o prox
          jmp m_proxima_l_c_verifica ; caso contrario, vai pra proxima
      m_avanca_di:                   ; linha/coluna
          mov AX, DI
          call andaUmaPos         ; movimenta o DI
          mov DI, AX
          cmp DS:[BP][DI], 0      ; se ele for zero, vai
          jz m_zerador            ; para colocar o valor em DS:[BP][SI] nele
          dec CH
        pop AX
        cmp ch,ah
        jz m_proxima_l_c_verifica
        dec ah
        cmp CH, 0

        jz m_proxima_l_c_verifica
        cmp DS:[BP][DI], 0        ; se [bp][DI] for zero e chegou aqui
        jz m_si_busca_val         ; busca o proximo [bp][si] com valor
        cmp SI, DI                ; se forem iguais, busca o proximo [bp][si] com
        jz  m_si_busca_val        ; valor

    m_proxima_l_c_verifica:       ; aqui terminou a linha ou coluna

        mov DI, [valColAnterior]

      cmp bl, 1
      jbe m_v_bx_0_1:
    	cmp bl, 3
    	jbe m_v_bx_2_3
    m_v_bx_0_1:              ; cima - baixo (so incrementa 1)
    	inc DI
    	xor CH,CH
    	jmp m_proxima_l_c
    m_v_bx_2_3:             ; esq - dir (incrementa de 4 em 4)
    	add DI, 4             ; (ou seja, o inicio da coluna)

    m_proxima_l_c:  ; aumenta o contador de linhas
        INC CL
        cmp CL, 4   ; se for 4, acabou (comeca em 0)
    	jb m_inicio

    pop si
    pop di
	  pop dx
	  pop cx
    pop ax
    ret
endp    movimento

armazenaValsIA proc ; proc que verifica os valores do tabuleiro da IA caso encontre
    empilhax        ; um valor maior ou igual A 2^5
    push di         ; para ver se armazena ou nao (no caso a jogada)
    push si         ; Recebe em AX o valor acima de 32 a ser verificado
    push bp
      mov dx, 5
      xor SI,SI
      mov BX, offset jogadasRoundIA
  encontra_avIA:   ; compara ateh encontrar a posicao
      cmp DX,AX    ; correta. 5 representa o 32
      je encontrou_avIA    ; que estah na pos 0 do vetor
      inc SI
      inc DX
      jmp encontra_avIA
  encontrou_avIA:
      mov ax, [jogadasJogador]
      cmp [bx][si], 0
      jne fimproc_avIA ; tem zero na pos, ou seja, primeira vez que encontrou o numero
      inc [bx][si]      ; isso garante que na proxima rodada nao compararah os movs

      push ax       ; converte SI para SI*2, pois
        mov ax, si  ; a sequencia jogadasFimIA EH DW
        xor ah,ah
        xor bh,bh
        mov bl, 2
        mul bl
        mov si, ax
      pop ax
      mov bx, offset jogadasFimIA
      mov dx,[bx][si]  ; se encontrou a primeira vez (0) nas posicoes
      cmp dx, 0        ; copia direto
      jz avi_encontrou_primeira
      cmp ax, [bx][si]  ; jogadas sao maiores que as armazenadas. se sim, n armazena
      ja fimproc_avIA
  avi_encontrou_primeira: ; se for a primeira vez q encontrou uma peca qualquer
      mov [bx][si], ax    ; armazena o valor diretamente
      mov bx, offset scoreValoresFimIA
      mov ax, [scoreTela]
      mov [bx][si], ax
  fimproc_avIA:

    pop bp
    pop si
    pop di
    desempilhax
    ret
endp

andaUmaPos proc ; proc que incrementa um movimento na direcao
                ; especifica. Recebe em AX e em AX sera retornado
                ; o valor da posicao, ja feito o mov. Bl define a
    cmp bl,0    ; direcao (cima, baixo, esq, dir) cima
    jne aup_comp_b
    add AX, 4
    jmp aup_fim
  aup_comp_b:
    cmp bl,1    ; baixo
    jne aup_comp_e
    sub AX, 4
    jmp aup_fim
  aup_comp_e:
    cmp bl,2    ; esquerda
    jne aup_comp_d
    INC AX
    jmp aup_fim
  aup_comp_d:      ; direita
    dec AX
  aup_fim:
    ret
endp andaUmaPos

numeroAleatorio proc    ; proc que gera um numero aleatorio
    push BX             ; e coloca em AX
    push CX

    mov BX, offset Seed
    mov AX, [BX]
    mov CX, AX

    and CX, 1
    jz ROTATE_RIGHT
    ; bit menos significativo nao e zero
    xor AX, Mask
    ROTATE_RIGHT:
    ror AX, 1

    mov [BX], AX

    pop CX
    pop BX
    ret
endp

; coloca uma peca em algum lugar aleatorio
colocarPeca proc
    push AX
    push BX
    push CX
    push SI

      ; pega um numero aleatorio em AX
      call numeroAleatorio

      mov BX, offset MatrizJogo

      ; decide qual peca e
      mov CL, AL
      and CL, 1
      inc CL ; agora CL contem 1 ou 2: exatamente o valor da nova peca

      ; pega a posicao da peca
      xor AH, AH ; faz com que AX fique menor que 256; para evitar overflow na divisao
      div byte ptr [CasasVazias] ; AX dividido pela quantidade de casas vazias (1..16)
                                 ; o resto (AH) contera a posicao *ignorando as casas ocupadas*
      xor SI, SI
      xor AL, AL ; reusa o AL como contador

      LOOP_ACHA_CASA:
          ; verifica se a casa esta vazia
          cmp [BX][SI], 0
          jne CONTINUA_LOOP

          ; se a casa esta vazia, incrementa AL ate ficar igual AH
          cmp AL, AH ; se for igual, esta e a casa que deve-se colocar a nova peca
          je COLOCA_PECA
          inc AL

          CONTINUA_LOOP:
          inc SI
      jmp LOOP_ACHA_CASA

      COLOCA_PECA:
      mov [BX][SI], CL

      dec byte ptr [CasasVazias] ; decrementa as casas vazias para continuar usando

    pop SI
    pop CX
    pop BX
    pop AX
    ret
endp

; limpa o jogo e deixa-o no estado inicial para jogar
resetarJogo proc

    push BX
    push CX
    push SI
      ; Zera as mensagens da tela :)
    	mov DI, offset msgEscoreJ
    	call limpaMsgsStatus
    	mov DI, offset msgJogadasJ
    	call limpaMsgsStatus

      ; zera tudo
      mov CX, 16
      push cx
        mov BX, offset MatrizJogo
        xor SI, SI
        ZERAR:
            mov byte [BX][SI], 0
            inc SI
        loop ZERAR
      pop cx
      ; colocar casas vazias
      mov [CasasVazias], cl
      xor cx,cx
      ; zerar os scoreTela
      mov [scoreTela], cx
      ; zerar as pecas
      mov [PecasJaMovidas], cl
      ;zerar as jogadas
      mov [jogadasJogador], cx
      ; coloca a primeira peca
      call colocarPeca

    pop SI
    pop CX
    pop BX

    ret
endp resetarJogo

printSprite proc ; proc que printa o 2048 do menu principal na tela
  push AX        ; (copia para a memoria de video que comeca em ES==0A000h)
  push dx        ; recebe em SI o offset do que printar
                  ; e em BP a posicao de onde ira printar
    mov dl, yposition
    xor dh,dh
    loop_esc:
      mov al, dl
      xor ah,ah
      push dx
        mov bx, 320 ; proxima linha
        mul bx
      pop dx
      add ax, bp
      mov di, ax    ; DI recebe o ponto exato onde gravar
      mov cx, 64    ; tamanho da linha
        rep movsb     ; loop escrita
      inc dl
      inc dh
    cmp dh, colsSprite
    jnz loop_esc

  pop dx
  pop AX
  ret
endp printSprite

lerTecla proc      ; PROC que le uma tecla
    push BX        ; e retorna em AL o caractere lido
      mov BH, AH ; salva ah inicial
      mov AH, 07h
      int 21h
      mov AH, BH ; recupera ah
    pop BX
    ret
endp

mostraRecordes proc     ; Proc que mostra a tela com a tabela de recordes
    call telaPreta      ; Nao recebe nem devolve parametros

    push AX
    push BX
    push BP
    push SI

    xor BX, BX
    mov BL, 00eH

    mov BP, offset RecordesTitulo
    mov CX, 8
    mov DX, 0410h
    call printTela

    xor AX, AX
    mov AH, byte ptr [RecordesContador]

    and AH, AH
    jnz MOSTRA_TABELA_RECORDES
        ; nenhum recorde obtido ainda
        mov BP, offset RecordesNenhum
        mov CX, 30
        mov DX, 0a05h
        call printTela
        jmp MOSTRA_TEXTO_SAIR_RECORDES
    MOSTRA_TABELA_RECORDES:
    mov BP, offset RecordesCabecalho
    mov CX, 26
    mov Dx, 0707h
    call printTela
    inc dh
    mov BP, offset RecordesTextos
    mov BL, 09h
    LOOP_RECORDES:
        cmp AH, AL ; fim do loop - 5 elementos
        je MOSTRA_TEXTO_SAIR_RECORDES
        inc DH
        call printTela
        add BP, CX
        inc AL
        jmp LOOP_RECORDES
    MOSTRA_TEXTO_SAIR_RECORDES:
    mov BP, offset PressioneUmaTecla
    mov DX, 1303h
    mov BL, 00eH
    mov CX, 34
    call printTela
    call lerTecla
    call telaPreta

    pop SI
    pop BP
    pop BX
    pop AX
    ret
endp mostraRecordes


menu proc             ; proc do menu principal do jogo
  empilhax
  push BP
  m_monta_tela:
    mov ax, 0
    call telaPreta            ; limpa tela
    push si       ; prepara os registradores para
    push es       ; escrever o 2048 pixel a pixel
      push 0A000h ; na tela (na memoria hehe)
      pop es      ; atraves da proc printSprite
      mov si, offset 2048
      mov bp, xposition
      call printSprite
    pop es
    pop si

    mov BP, OFFSET menu_titulo;monta o menu e exibe
    mov cx, 130
    mov bx, 000Eh
    mov dh, 11
    mov dl, 0
    call printTela

  ;aguarda a tecla (loop principal, ate o user selecionar s para sair)
  m_loop:
    call lerTecla
    cmp al, 'j'
    jnz m_cmp_r
    call player2048
    jmp m_monta_tela
  m_cmp_r:				; recordes
    cmp Al, 'r'
    jnz m_cmp_a
    call mostraRecordes
    jmp m_monta_tela
  m_cmp_a:				; automatico
    cmp Al, 'a'
    jnz m_cmp_s
    call ai2048 ;
    jmp m_monta_tela
  m_cmp_s:
    cmp Al, 's'			; sair do jogo
    jnz m_loop

    call telaPreta
  pop BP
  desempilhax
  ret
endp menu

INICIO:
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    call modoVGA  ; modo grafico
    call menu     ; loop principal do jogo
    call modoText ; retorna ao modo default que o DOS utiliza
    mov al, 00h
    mov ah, 04ch
    int 21h
end INICIO
