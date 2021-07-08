
org 0x7e00
jmp 0x0000:start
 
data:
    msg_titulo db 'GENIUS',0
    msg_jogar db 'JOGAR {1}',0
    msg_manual db 'Manual {2}',0
    msg_credito db 'Creditos {3}',0

    menu_1 db 'voce tem boa memoria ???', 0
    menu_2 db 'Teste-a agora', 0

    manual_1 db 'Cores do Jogo :', 0
    manual_2 db 'Digite a sequencia de cores de acordo com sua inicial em ingles', 0
    manual_3 db 'EX: ROSA/VERMELHO/ROSA/VERDE = prpg', 0
    manual_4 db 'O jogo tera 5 fases', 0
    manual_5 db 'Ganha se completar todas', 0
    manual_6 db 'Boa sorte', 0
    
    c_rosa db 'ROSA', 0
    c_vermelho db 'VERMELHO', 0
    c_azul db 'AZUL', 0
    c_verde db 'VERDE', 0

    esc_msg db '{Pressione ESC para voltar}',0

    creditos_1 db 'Criado por FHV LTDA',0
    creditos_2 db 'CEO   Flavio Jose Canuto Vasconcelos Junior',0
    creditos_3 db 'CFO   Vinicius Pereira de Araujo',0
    creditos_4 db 'CTO   Heitor Brayner Prado',0

    msg_jogar1 db 'Pressione ENTER para comecar ...',0

    r_correta1 db 'rp',0
    r_correta2 db 'gpgb',0
    r_correta3 db 'rgbppb',0
    r_correta4 db 'pbbgrrpb',0
    r_correta5 db 'rpbgprgbpg',0

    msg_resposta db 'DIGITE SUA RESPOSTA:',0
    loser_msg db 'GAME OVER!!',0
    loser_msg1 db 'Tente novamente!!',0

    parabens db 'PARABENS',0
    prox_fase1 db 'Voce passou para a proxima fase',0
    prox_fase2 db 'Pressione ENTER para continuar ...',0

    win_frase1 db 'Voce venceu o jogo',0
    win_frase2 db 'Pressione ENTER para ir para os creditos!',0
    resposta times 20 db 0

 
 
putchar:    ;Printa um caractere na tela, pega o valor salvo em al
  mov ah, 0x0e
  int 10h
  ret
 
getchar:    ;Pega o caractere lido no teclado e salva em al
  mov ah, 0x00
  int 16h
  ret
 
delchar:    ;Deleta um caractere lido no teclado
  mov al, 0x08          ; backspace
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08          ; backspace
  call putchar
  ret
 
endl:       ;Pula uma linha, printando na tela o caractere que representa o /n
  mov al, 0x0a          ; line feed
  call putchar
  mov al, 0x0d          ; carriage return
  call putchar
  ret
 
 
gets:                 ; mov di, string, salva na string apontada por di, cada caractere lido na linha
  xor cx, cx          ; zerar contador
  .loop1:
    call getchar
    cmp al, 0x08      ; backspace
    je .backspace
    cmp al, 0x0d      ; carriage return
    je .done
    cmp cl, 10        ; string limit checker
    je .loop1
 
    stosb
    inc cl
    call putchar
 
    jmp .loop1
    .backspace:
      cmp cl, 0       ; is empty?
      je .loop1
      dec di
      dec cl
      mov byte[di], 0
      call delchar
    jmp .loop1
  .done:
  mov al, 0
  stosb
  call endl
  ret


prints:             ; mov si, string
    .loop:
        lodsb           ; bota character apontado por si em al 
        cmp al, 0       ; 0 é o valor atribuido ao final de uma string
        je .endloop     ; Se for o final da string, acaba o loop
        call putchar    ; printa o caractere
        jmp .loop       ; volta para o inicio do loop
    .endloop:
    ret
 
clear:                   ; mov bl, color
  ; set the cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10
 
  ; print 2000 blank chars to clean  
  mov cx, 2000 
  mov bh, 0
  mov al, 0x20 ; blank char
  mov ah, 0x9
  int 0x10
 
  ; reset cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10
  ret
 
ESC: ;funcao pra identificar o pressionamento do esc
  call getchar
  cmp al, 27
  je Menu
 
  ret
 
ENT: ;funcao pra identificar o pressionamento do enter
  call getchar
  cmp al, 13
  je jogar1
 
  ret
 
tela_azul: ;funcao que printa o background azul
  mov ah,0bh
  mov bh,0
  mov bl,1
  int 10h
  ret
 
tela_rosa: ;funcao que printa o background rosa
  mov ah,0bh
  mov bh,0
  mov bl,13
  int 10h
  ret
 
tela_verde: ;funcao que printa o background verde
  mov ah,0bh
  mov bh,0
  mov bl,2
  int 10h
  ret
 
tela_vermelho: ;funcao que printa o background vermelho
  mov ah,0bh
  mov bh,0
  mov bl,4
  int 10h
  ret
  
tela_preta: ;funcao que printa o background preto, que vai ser usada pra transicao
  mov ah,0xb
  mov bh,0
  mov bl,0
  int 10h
  ret
 
delay1:
  mov cx, 20    ;HIGH WORD.
  mov dx, 0A120h ;LOW WORD.
  mov ah, 86h    ;WAIT.
  int 15h
  ret

transicao: ;funcao que bota a tela preta, deixa la um tempinho com o delay e que vai ser usada pra transicao entre uma cor e outra
  call delay1
  call tela_preta
  call delay1
  ret

sequencia1: ;sequencia de cores da primeira fase: rp
  call tela_vermelho
  call transicao
  call tela_rosa
  call delay1
  ret

sequencia2: ;sequencia de cores da segunda fase: gpgb
  call tela_verde
  call transicao
  call tela_rosa
  call transicao
  call tela_verde
  call transicao
  call tela_azul
  call delay1
  ret

sequencia3: ;sequencia de cores da terceira fase: rgbppb
  call tela_vermelho
  call transicao
  call tela_verde
  call transicao
  call tela_azul
  call transicao
  call tela_rosa
  call transicao
  call tela_rosa
  call transicao
  call tela_azul
  call delay1
  ret

sequencia4: ;sequencia de cores da quarta fase: pbbgrrpb
  call tela_rosa
  call transicao
  call tela_azul
  call transicao
  call tela_azul
  call transicao
  call tela_verde
  call transicao
  call tela_vermelho
  call transicao
  call tela_vermelho
  call transicao
  call tela_rosa
  call transicao
  call tela_azul
  call delay1
  ret

sequencia5: ;sequencia de cores da quinta fase: rpbgprgbpg
  call tela_vermelho
  call transicao
  call tela_rosa
  call transicao
  call tela_azul
  call transicao
  call tela_verde
  call transicao
  call tela_rosa
  call transicao
  call tela_vermelho
  call transicao
  call tela_verde
  call transicao
  call tela_azul
  call transicao
  call tela_rosa
  call transicao
  call tela_verde
  call delay1
  ret
  
print_msg:  ; funcao que usamos para printar a mensagem que espera a resposta
            ;string msg_resposta
  
  mov ah, 0bh ;seta o modo video
  mov bh, 0
  mov bl, 0
  int 10h

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 0    ;Linha 0
  mov dl, 0   ;Coluna 0
  mov bl, 15
  int 10h ;no fim, a mensagem vai ser escrita no canto superior esquerdo

  mov si, msg_resposta
  call prints
  ret

init_video: ;funcao que vai setar o modo video quando necessario
  mov ah,0
  mov al,12h
  int 10h
  ret

clear_reg:
  mov ax, 0
 	mov ds, ax
 	mov es, ax
	mov bh, 0
  ret

strcmp:              ; mov si, string1, mov di, string2, compara as strings apontadas por si e di
  .loop1:
    lodsb
    cmp al, byte[di]
    jne .notequal
    cmp al, 0
    je .equal
    inc di
    jmp .loop1
  .notequal:
    clc
    ret
  .equal:
    stc
    ret

tela_loser: ;tela que usamos quando o usuario entra com a resposta errada
  call init_video

  mov ah,0xb
  mov bh,0
  mov bl,0
  int 10h

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 10   ;Linha 10
  mov dl, 32   ;Coluna 32
  mov bl, 4    ;por fim, seta a posicao onde a proxima string sera printada 
  int 10h   

  mov si, loser_msg
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 15   ;Linha 15
  mov dl, 30   ;Coluna 30
  mov bl, 4    ;por fim, seta a posicao onde a proxima string sera printada 
  int 10h

  mov si, loser_msg1
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 20    ;Linha
  mov dl, 26   ;Coluna
  mov bl, 4
  int 10h

  mov si, esc_msg
  call prints
  call ESC
  jmp tela_loser
  ret

tela_proxfase: ;tela que usamos quando o usuario entra com a resposta errada
  call init_video
  
  mov ah, 0bh ;seta o modo video
  mov bh, 0
  mov bl, 0
  int 10h

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 10   ;Linha 10
  mov dl, 33   ;Coluna 32
  mov bl, 10   ;por fim, seta a posicao onde a proxima string sera printada 
  int 10h   

  mov si, parabens
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 15   ;Linha 15
  mov dl, 23   ;Coluna 30
  mov bl, 10    ;por fim, seta a posicao onde a proxima string sera printada 
  int 10h

  mov si, prox_fase1
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 20    ;Linha
  mov dl, 21   ;Coluna
  mov bl, 10
  int 10h

  mov si, prox_fase2
  call prints

  call getchar
  cmp al,13
  je .done


  .done:
  ret

tela_win: ;tela que usamos quando o usuario entra com a resposta errada
  call init_video

  mov ah,0xb
  mov bh,0
  mov bl,0
  int 10h

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 10   ;Linha 10
  mov dl, 34   ;Coluna 32
  mov bl, 14    ;por fim, seta a posicao onde a proxima string sera printada 
  int 10h   

  mov si, parabens
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 15   ;Linha 15
  mov dl, 28   ;Coluna 30
  mov bl, 14    ;por fim, seta a posicao onde a proxima string sera printada 
  int 10h

  mov si, win_frase1
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 20    ;Linha
  mov dl, 19  ;Coluna
  mov bl, 14
  int 10h

  mov si, win_frase2
  call prints
  

  call getchar
  cmp al, 13
  je .done
  .done:
  ret


start:
  ;Zerando os registradores
  mov ax, 0
  mov ds, ax

  ;Chamando a função Menu
  call Menu
  jmp done

Menu:
  ;Carregando o video
  mov ah, 0
  mov al,12h

  int 10h

  ;Mudando a cor do background para azul escuro
  mov ah, 0bh
  mov bh, 0
  mov bl, 0
  int 10h 

  ;Colocando o Titulo
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 3    ;Linha
  mov dl, 35   ;Coluna
  mov bl, 14
  int 10h
  mov si, msg_titulo
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 8   ;Linha
  mov dl, 27   ;Coluna
  int 10h
  mov si, menu_1
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 11   ;Linha
  mov dl, 32  ;Coluna
  int 10h
  mov si, menu_2
  call prints

  ;Colocando a string jogar
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 15   ;Linha
  mov dl, 5   ;Coluna
  int 10h
  mov si, msg_jogar
  call prints

  ;Colocando a string intrucoes
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 20   ;Linha
  mov dl, 5   ;Coluna
  int 10h
  mov si, msg_manual
  call prints

  ;Colocando a string creditos
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 25   ;Linha
  mov dl, 5   ;Coluna
  int 10h
  mov si, msg_credito
  call prints

    ;Selecionar a opcao do usuario
    selecao:
 
        call getchar
 
        ;Comparando com '1'
        cmp al, 49
        je jogar
 
        ;Comparando com '2'
        cmp al, 50
        je manual
 
        ;Comparando com '3'
        cmp al, 51
        je creditos
 
        ;Caso não seja nem '1' ou '2' ou '3' ele vai receber a string dnv
        jne selecao
jogar:
  ;limpamos todos os registradores
  call clear_reg
 
  call init_video ;chama a funcao pra iniciar o video
 
  mov ah, 0bh 
  mov bh, 0
  mov bl, 0
  int 10h
 
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 15    ;Linha
  mov dl, 24   ;Coluna
  mov bl, 14
  int 10h
  mov si, msg_jogar1
  call prints
 
  call ENT ;chama a funcao que identifica o pressionamento do enter e fica aguardando o usuario apertar
  jmp jogar
 
jogar1:
 
  jmp .fase1
  .fase1:
    call init_video ;inicia o video
  
    call sequencia1 ;mostra na tela a sequencia da fase 1 do jogo

    call print_msg ;printa na tela a mensagem pedindo o usuario a resposta
 
    mov di, resposta ;le a resposta do usuario e coloca em resposta
    call gets
 
    mov di, resposta ;carrega os registradores com a string que o usuario entrou
    mov si, r_correta1 ;carrega os registradores com a string correta
 
    call strcmp ;compara as strings: se for igual-> carry == 1 e se for diferente carry == 0
 
    jnc tela_loser ;not carry == strings diferentes == usuario perdeu

    call tela_proxfase
 
  .fase2:
 
    call clear_reg ;limpa todos os registradores 
 
    call init_video ;inicia o video

    call sequencia2 ;mostra na tela a sequencia da fase 2 do jogo
 
    call print_msg ;printa na tela a mensagem pedindo o usuario a resposta
 
    mov di, resposta ;le a resposta do usuario e coloca em resposta
    call gets
 
    mov di, resposta ;carrega os registradores com a string que o usuario entrou
    mov si, r_correta2 ;carrega os registradores com a string correta
 
    call strcmp ;compara as strings: se for igual-> carry == 1 e se for diferente carry == 0
 
    jnc tela_loser ;not carry == strings diferentes == usuario perdeu
    
    call tela_proxfase
 
  .fase3:
 
    call clear_reg ;limpa todos os registradores 
 
    call init_video ;inicia o video

    call sequencia3 ;mostra na tela a sequencia da fase 3 do jogo
 
    call print_msg ;printa na tela a mensagem pedindo o usuario a resposta
 
    mov di, resposta ;le a resposta do usuario e coloca em resposta
    call gets
 
    mov di, resposta ;carrega os registradores com a string que o usuario entrou
    mov si, r_correta3 ;carrega os registradores com a string correta
 
    call strcmp ;compara as strings: se for igual-> carry == 1 e se for diferente carry == 0
 
    jnc tela_loser ;not carry == strings diferentes == usuario perdeu

    call tela_proxfase
  
  .fase4:
    call clear_reg ;limpa todos os registradores 
 
    call init_video ;inicia o video

    call sequencia4 ;mostra na tela a sequencia da fase 4 do jogo
 
    call print_msg ;printa na tela a mensagem pedindo o usuario a resposta
 
    mov di, resposta ;le a resposta do usuario e coloca em resposta
    call gets
 
    mov di, resposta ;carrega os registradores com a string que o usuario entrou
    mov si, r_correta4 ;carrega os registradores com a string correta
 
    call strcmp ;compara as strings: se for igual-> carry == 1 e se for diferente carry == 0
 
    jnc tela_loser ;not carry == strings diferentes == usuario perdeu
    
    call tela_proxfase

  .fase5:
    call clear_reg ;limpa todos os registradores 
 
    call init_video ;inicia o video

    call sequencia5 ;mostra na tela a sequencia da fase 5 do jogo
 
    call print_msg ;printa na tela a mensagem pedindo o usuario a resposta
 
    mov di, resposta ;le a resposta do usuario e coloca em resposta
    call gets
 
    mov di, resposta ;carrega os registradores com a string que o usuario entrou
    mov si, r_correta5 ;carrega os registradores com a string correta
 
    call strcmp ;compara as strings: se for igual-> carry == 1 e se for diferente carry == 0
 
    jnc tela_loser ;not carry == strings diferentes == usuario perdeu

    call tela_win

    jmp creditos
 
manual:
  ;Carregando o video para limpar a tela
  call init_video
 
  ;Mudando a cor do background para preto
  mov ah, 0bh
  mov bh, 0
  mov bl, 0
  int 10h 
 
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 3    ;Linha
  mov dl, 10   ;Coluna
  mov bl, 14
  int 10h
  mov si, manual_1
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 3    ;Linha
  mov dl, 29   ;Coluna
  mov bl, 13
  int 10h
  mov si, c_rosa
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 3    ;Linha
  mov dl, 35   ;Coluna
  mov bl, 2
  int 10h
  mov si, c_verde
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 3    ;Linha
  mov dl, 42   ;Coluna
  mov bl, 4
  int 10h
  mov si, c_vermelho
  call prints

  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 3    ;Linha
  mov dl, 52   ;Coluna
  mov bl, 1
  int 10h
  mov si, c_azul
  call prints
  
  ;Colocando a string instrucao1
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 7    ;Linha
  mov dl, 10   ;Coluna
  mov bl, 14
  int 10h
  mov si, manual_2
  call prints
 
  ;Colocando a string instrucao2
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 9    ;Linha
  mov dl, 10   ;Coluna
  int 10h
  mov si, manual_3
  call prints
 
  ;Colocando a string instrucao3
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 11   ;Linha
  mov dl, 10   ;Coluna
  int 10h
  mov si, manual_4
  call prints
 
  ;Colocando a string instrucao4
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 13   ;Linha
  mov dl, 10   ;Coluna
  int 10h
  mov si, manual_5
  call prints
 
  ;Colocando a string instrucao5
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 20   ;Linha
  mov dl, 10   ;Coluna
  int 10h
  mov si, manual_6
  call prints
 
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 25   ;Linha
  mov dl, 10   ;Coluna
  int 10h
  mov si, esc_msg
  call prints
 
  call ESC
  jmp manual
creditos:
  ;Carregando o video para limpar a tela
  mov ah, 0
  mov al,12h
  int 10h
 
  ;Mudando a cor do background para azul escuro
  mov ah, 0bh
  mov bh, 0
  mov bl, 0
  int 10h
 
  ;Colocando o Titulo
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 3    ;Linha
  mov dl, 30   ;Coluna
  mov bl, 14
  int 10h
  mov si, creditos_1
  call prints
 
  ;Colocando a s;Colocando o Titulo
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 10    ;Linhamake
  mov dl, 5   ;Coluna
  int 10h
  mov si, creditos_2
  call prints
 
  ;Colocando a string jogar
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 15   ;Linha
  mov dl, 5   ;Coluna
  int 10h
  mov si, creditos_3
  call prints
 
  ;Colocando a string intrucoes
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 20   ;Linha
  mov dl, 5   ;Coluna
  int 10h
  mov si, creditos_4
  call prints
 
  ;Colocando a string creditos
  mov ah, 02h  ;Setando o cursor
  mov bh, 0    ;Pagina 0
  mov dh, 25   ;Linha
  mov dl, 5   ;Coluna
  int 10h
  mov si, esc_msg
  call prints
 
  call ESC
  jmp creditos
 
done:
    jmp $


