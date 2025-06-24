;LOSESCR.ASM;

loseScreen:
    call checkScores                    ; put scores in order
    call init_vars                      ; initialize all vars that relates to snake
    hide_mouse                          ; hides the mouse
    print_bmp loseScr, 200, 320, 0, 0   ; prints loseScreen pic
    init_mouse                          ; initialize mouse
    show_mouse                          ; show mouse on screen
    sound_off                           ; turns off sound (just incase you dont go to stopSound in GAME.ASM)
    call set_mouse                      ; change palette (mouse is white)
	startInputLoopp:	
		; keyboard input
			mov ah, 1                   ; check keyboard status   
        	int 16h   
        	jz @@@startNoKey            ; starts to check mouse if theres nothing
        	; input a key
        	mov ah, 0                   ; gets an input from keyboard
        	int 16h
			cmp al, esc_key             ; cmp to 1h (esc button)
			je exit                     ; close the program if pressed
			cmp al, back_key            ; cmp to 'b'
			je setstartscreen           ; jmps to startScreen if pressed
			cmp al, replay_key          ; cmp to 'r'
			je startGame                ; restart the game (jmps to GAME.ASM)
			cmp al, ledBor_key          ; cmp to 'l'
			je leaderboard              ; jmps to leaderBoard if pressed
			@@@startNoKey:
		; mouse input
			get_mouse                   ; get position of the mouse
			and bx,01h	                ; check left mouse click
			jz startInputLoopp          ; jmps back to keyboard if theres no click
			movMouseXY                  ; movs cx -> mouse_x and dx -> mouse_y

			; check buttons
			checkMouse 54, 86, 98, 104, [mouse_x], [mouse_y]
			je setStartScreen           ; if click has been between (54,86), (98,104) -> jmps to startScreen (home button)
			checkMouse 132, 86, 177, 104, [mouse_x], [mouse_y]
			je startGame                ; if click has been between (132, 86), (177, 104) -> jmps to GAME.ASM (replay button)
			checkMouse 212, 86, 258, 104, [mouse_x], [mouse_y]
			je leaderboard              ; if click has been between (212, 86), (258, 104) -> jmps to leaderBoard
			@@@closeNotClicked:
			; Check that the mouse is released before continuing
			@@@startMouseNotReleased:        
				get_mouse             
				and bx,01h	         
				jnz @@@startMouseNotReleased 
	jmp startInputLoopp

leaderboard:
    hide_mouse                          ; hides mouse 
    print_bmp lbscr, 200, 320, 0, 0     ; prints leaderBoard screen pic
    init_mouse                          ; initialize mouse
    show_mouse                          ; show mouse
    call set_mouse                      ; change palette colors (mouse is white)
    mov al,[scores]                     ; movs (scores+0) into al
    printCoordinates 13,9               ; coordianates of the text is (13,9) (not in graphic mode x,y)
    call printNumber                    ; prints the score according to requested coordianates
    mov al,[scores+1]                   ; movs second index (scores+1) into al
    printCoordinates 13,11              ; coordianates of the text is (13,11) (not in graphic mode x,y)
    call printNumber                    ; prints the score according to requested coordianates
    mov al,[scores+2]                   ; movs third index (scores+2) into al
    printCoordinates 13,13              ; coordianates of the text is (13,13) (not in graphic mode x,y)
    call printNumber                    ; prints the score according to requested coordianates
    mov al,[scores+3]                   ; movs forth index (scores+3) into al
    printCoordinates 13,15              ; coordianates of the text is (13,15) (not in graphic mode x,y)
    call printNumber                    ; prints the score according to requested coordianates

	startInputLooppp:	
		; keyboard input
			mov ah, 1                   ; checks keyBoard status
        	int 16h   
        	jz @@@startNoKey            ; starts to check mouse if theres nothing 
        	; input a key
        	mov ah, 0                   ; gets an input from keyboard
        	int 16h
			cmp al, back_key            ; cmp al, 'b'
			je setstartscreen           ; jmps to startScreen if pressed
			@@@startNoKey:
		; mouse input
			get_mouse                   ; get position of the mouse
			and bx,01h	                ; check left mouse click
			jz startInputLooppp         ; jmps back to keyboard if theres no click
			movMouseXY                  ; movs cx -> mouse_x and dx -> mouse_y

			; check buttons
			checkMouse 136, 140, 181, 158, [mouse_x], [mouse_y]
			je setstartscreen           ; if click has been between (136, 140), (181, 158) -> jumps to startScreen
        @@@startMouseNotReleased:        
				get_mouse             
				and bx,01h	         
				jnz @@@startMouseNotReleased 
	jmp startInputLooppp


setStartScreen:
    ; wait for mouse release before entering startScreen logic
    call waitForMouseRelease
    jmp startScreen