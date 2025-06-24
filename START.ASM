;START.ASM;

startScreen:
    hide_mouse                          ; hides mouse
    print_bmp startScr, 200, 320, 0, 0  ; prints home screen pic
    init_mouse                          ; initialize the mouse
    show_mouse                          ; show mouse
    call set_mouse                      ; change palette (mouse is white)
	startInputLoop:	
		; keyboard input
			mov ah, 1                   ; gets keyboard status
        	int 16h   
        	jz startNoKey               ; starts to check mouse if theres nothing
        	; input a key
        	mov ah, 0                   ; gets input from keyBoard
        	int 16h
            cmp ah, esc_key             ; cmp ah, esc
			je exit                     ; closing the program if pressed (escape button)
			cmp al, space_key           ; cmp al, ' '
			je startGame                ; jmps to GAME.ASM if pressed (play button)
			cmp al, accs_key            ; cmp al, 'a'
			je accs                     ; jmps to accs if pressed (accessories button)
			cmp al, inst_key            ; cmp al, 'i'
			je inst                     ; jmps to inst if pressed (instructions button)
			startNoKey:
		; mouse input
			get_mouse                   ; get positon of the mouse
			and bx,01h	                ; check left mouse click
			jz startInputLoop           ; jmps to keyboard if theres no click
			movMouseXY                  ; movs cx -> mouse_x and dx -> mouse_y

			; check buttons
            checkMouse 12, 159, 31, 178, [mouse_x], [mouse_y]
            je exit                     ; if click has been between (12,159), (31,178) -> closes the program
			checkMouse 54, 86, 98, 104, [mouse_x], [mouse_y]
			je accs                     ; if click has been between (54,86), (98,104) -> jmps to accs (accessories button)
			checkMouse 132, 86, 177, 104, [mouse_x], [mouse_y]
			je startGame                ; if click has been between (132,86), (177,104) -> jmps to GAME.ASM (play button)
			checkMouse 212, 86, 258, 104, [mouse_x], [mouse_y]
			je inst                     ; if click has been between (212,86), (258,104) -> jmps to inst (instructions button)

			closeNotClicked:
			; Check that the mouse is released before continuing
			startMouseNotReleased:        
				get_mouse             
				and bx,01h	         
				jnz startMouseNotReleased 
	jmp startInputLoop



Accs:
    hide_mouse                          ; hides the mouse
    print_bmp acces, 200, 320, 0, 0     ; prints accessories screen pic
    init_mouse                          ; initialize the mouse
    show_mouse                          ; show the mouse
    call set_mouse                      ; change palette (mouse is white)
accs_wait:	
    mov ah, 1          ; Check if a key is pressed
    int 16h
    jz sstartNoKey     ; If no key pressed, skip to mouse input
    mov ah, 0          ; Get key
    int 16h
    cmp al, back_key   ; If key == back_key (e.g. 'b')
    je startscreen     ; Go back to start screen

sstartNoKey:
    ; ==== Mouse input ====
    get_mouse
    and bx, 01h             ; Check if left mouse button is clicked
    jz accs_wait            ; If not clicked, loop back

    movMouseXY              ; Store mouse click position in [mouse_x], [mouse_y]

    checkMouse 40, 65, 55, 80, [mouse_x], [mouse_y]     ; check if mouse pressed on red snake color
    je red                                              ; if so - jmp to red
    checkMouse 60, 65, 75, 80, [mouse_x], [mouse_y]     ; check if mouse pressed on orange snake color
    je orange                                           ; if so - jmp to orange
    checkMouse 80, 65, 95, 80, [mouse_x], [mouse_y]     ; check if mouse pressed on yellow snake color
    je yellow                                           ; if so - jmp to yellow
    checkMouse 100, 65, 115, 80, [mouse_x], [mouse_y]   ; check if mouse pressed on green snake color
    je greenn                                           ; ; if so - jmp to green
    checkMouse 120, 65, 135, 80, [mouse_x], [mouse_y]   ; check if mouse pressed on blue snake color
    je blue                                             ; if so - jmp to blue
    checkMouse 40, 85, 55, 100, [mouse_x], [mouse_y]    ; check if mouse pressed on dark green snake color
    je dark_green                                       ; if so - jmp to dark green
    checkMouse 60, 85, 75, 100, [mouse_x], [mouse_y]    ; check if mouse pressed on olive green snake color
    je olive_green                                      ; if so - jmp to olive green
    checkMouse 80, 85, 95, 100, [mouse_x], [mouse_y]    ; check if mouse pressed on light green snake color
    je light_green                                      ; if so - jmp to light green
    checkMouse 100, 85, 115, 100, [mouse_x], [mouse_y]  ; check if mouse pressed on light blue snake color
    je light_blue                                       ; if so - jmp to light blue
    checkMouse 120, 85, 135, 100, [mouse_x], [mouse_y]  ; check if mouse pressed on turquoise snake color
    je turquoise                                        ; if so - jmp to turquoise
    checkMouse 40, 105, 55, 120, [mouse_x], [mouse_y]   ; check if mouse pressed on dark turquoise snake color
    je dark_turquoise                                   ; if so - jmp to dark turquoise
    checkMouse 60, 105, 75, 120, [mouse_x], [mouse_y]   ; check if mouse pressed on blue2 snake color
    je blue2                                            ; if so - jmp to blue2
    checkMouse 80, 105, 95, 120, [mouse_x], [mouse_y]   ; check if mouse pressed on red snake color
    je purple                                           ; if so - jmp to purple
    checkMouse 100, 105, 115, 120, [mouse_x], [mouse_y] ; check if mouse pressed on red snake color
    je hot_pink                                         ; if so - jmp to hot pink
    checkMouse 120, 105, 135, 120, [mouse_x], [mouse_y] ; check if mouse pressed on red snake color
    je purple2                                          ; if so - jmp to purple 2
    checkMouse 40, 125, 55, 140, [mouse_x], [mouse_y]   ; check if mouse pressed on red snake color
    je dark_purple                                      ; if so - jmp to dark purple
    checkMouse 60, 125, 75, 140, [mouse_x], [mouse_y]   ; check if mouse pressed on red snake color
    je light_purple                                     ; if so - jmp to light purple
    checkMouse 80, 125, 95, 140, [mouse_x], [mouse_y]   ; check if mouse pressed on red snake color
    je light_pink                                       ; if so - jmp to light pink
    checkMouse 100, 125, 115, 140, [mouse_x], [mouse_y] ; check if mouse pressed on red snake color
    je grey                                             ; if so - jmp to grey
    checkMouse 120, 125, 135, 140, [mouse_x], [mouse_y] ; check if mouse pressed on red snake color
    je white                                            ; if so - jmp to white
    checkMouse 197, 65, 212, 80, [mouse_x], [mouse_y]   ; check if mouse pressed on red snake color
    je mapGreen
    checkMouse 177, 65, 192, 80, [mouse_x], [mouse_y]   ; check if mouse pressed on red map color
    je blue_map
    checkMouse 217,65, 232, 80, [mouse_x], [mouse_y]    ; check if mouse pressed on red map color
    je mapPink
    checkMouse 237, 65, 252, 80, [mouse_x], [mouse_y]   ; check if mouse pressed on red map color
    je mapYellow
    checkMouse 257, 65, 272, 80, [mouse_x], [mouse_y]   ; check if mouse pressed on red map color
    je mapGrey
    checkMouse 177, 85, 192, 100, [mouse_x], [mouse_y]  ; check if mouse pressed on red map color
    je mapPurple
    checkMouse 197, 85, 212, 100, [mouse_x], [mouse_y]  ; check if mouse pressed on red map color  
    je mapTorquise
    checkMouse 217, 85, 232, 100, [mouse_x], [mouse_y]  ; check if mouse pressed on red map color
    je maporange
    checkMouse 237, 85, 252, 100, [mouse_x], [mouse_y]  ; check if mouse pressed on red map color
    je mapice
    checkMouse 257, 85, 272, 100, [mouse_x], [mouse_y]  ; check if mouse pressed on red map color
    je mapocean
    checkMouse 177, 105, 192, 120, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je maplava
    checkMouse 197, 105, 212, 120, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je mappastel
    checkMouse 217, 105, 232, 120, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je mapauttum
    checkMouse 237, 105, 252, 120, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je mapmint
    checkMouse 257, 105, 272, 120, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je mapneon
    checkMouse 177, 125, 192, 140, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je maprose
    checkMouse 197, 125, 212, 140, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je mapVintage
    checkMouse 217, 125, 232, 140, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je mapCyber
    checkMouse 237, 125, 252, 140, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je mapsand
    checkMouse 257, 125, 272, 140, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je mapGalaxy
    checkMouse 140, 145, 185, 163, [mouse_x], [mouse_y] ; check if mouse pressed on red map color
    je setStartScreen
    jmp accs_wait

red:
    mov [snakeColor], 249
    drawRec 84, 149, 249, 6, 6
    jmp Accs_wait
orange:
    mov [snakeColor], 30
    drawRec 84, 149, 30, 6, 6
    jmp accs_wait
yellow:
    mov [snakeColor], 251
    drawRec 84, 149, 251, 6, 6
    jmp accs_wait
greenn:
    mov [snakeColor], 2
    drawRec 84, 149, 2, 6, 6
    jmp accs_wait
blue:
    mov [snakeColor], 4
    drawRec 84, 149, 4, 6, 6
    jmp accs_wait
dark_green:
    mov [snakeColor], 80
    drawRec 84, 149, 80, 6, 6
    jmp accs_wait
olive_green:
    mov [snakeColor], 90
    drawRec 84, 149, 90, 6, 6
    jmp accs_wait
light_green:
    mov [snakeColor], 176
    drawRec 84, 149, 176, 6, 6
    jmp accs_wait
light_blue:
    mov [snakeColor], 242
    drawRec 84, 149, 242, 6, 6
    jmp accs_wait
turquoise:
    mov [snakeColor], 6
    drawRec 84, 149, 6, 6, 6
    jmp accs_wait 
dark_turquoise:
    mov [snakeColor], 152
    drawRec 84, 149, 152, 6, 6
    jmp accs_wait 
blue2:
    mov [snakeColor], 216
    drawRec 84, 149, 216, 6, 6
    jmp accs_wait 
purple:
    mov [snakeColor], 213
    drawRec 84, 149, 213, 6, 6
    jmp accs_wait 
hot_pink:
    mov [snakeColor], 207
    drawRec 84, 149, 207, 6, 6
    jmp accs_wait 
purple2:
    mov [snakeColor], 211
    drawRec 84, 149, 211, 6, 6
    jmp accs_wait 
dark_purple:
    mov [snakeColor], 5
    drawRec 84, 149, 5, 6, 6
    jmp accs_wait 
light_purple:
    mov [snakeColor], 229
    drawRec 84, 149, 229, 6, 6
    jmp accs_wait 
light_pink:
    mov [snakeColor], 239
    drawRec 84, 149, 239, 6, 6
    jmp accs_wait 
grey:
    mov [snakeColor], 7
    drawRec 84, 149, 7, 6, 6
    jmp accs_wait 
white:
    mov [snakeColor], 255
    drawRec 84, 149, 255, 6, 6
    jmp accs_wait
mapGreen: 
    mov [mapColor], 1
    drawRec 304, 147,32h, 6,6
    drawRec 307, 147, 20h, 3,3
    drawRec 304, 150, 20h, 3,3
    jmp accs_wait
blue_map:
    mov [mapColor], 2
    drawRec 304, 147,242, 6,6
    drawRec 307, 147, 224, 3,3
    drawRec 304, 150, 224, 3,3
    jmp accs_wait
mapPink:
    mov [mapColor], 3
    drawRec 304, 147,231, 6,6
    drawRec 307, 147, 223, 3,3
    drawRec 304, 150, 223, 3,3
    jmp accs_wait
mapYellow:
    mov [mapColor], 4
    drawRec 304, 147,63, 6,6
    drawRec 307, 147, 31, 3,3
    drawRec 304, 150, 31, 3,3
    jmp accs_wait 
mapGrey:
    mov [mapColor], 5
    drawRec 304, 147,246, 6,6
    drawRec 307, 147, 248, 3,3
    drawRec 304, 150, 248, 3,3
    jmp accs_wait
mapPurple:
    mov [mapColor], 6
    drawRec 304, 147,255, 6,6
    drawRec 307, 147, 9, 3,3
    drawRec 304, 150, 9, 3,3
    jmp accs_wait
mapTorquise:
    mov [mapColor], 7
    drawRec 304, 147,176, 6,6
    drawRec 307, 147, 170, 3,3
    drawRec 304, 150, 170, 3,3
    jmp accs_wait
mapOrange:
    mov [mapColor], 8
    drawRec 304, 147,175, 6,6
    drawRec 307, 147, 95, 3,3
    drawRec 304, 150, 95, 3,3
    jmp accs_wait
mapice:
    mov [mapColor], 9
    drawRec 304, 147,246, 6,6
    drawRec 307, 147, 242, 3,3
    drawRec 304, 150, 242, 3,3
    jmp accs_wait
mapOcean:
    mov [mapColor], 10
    drawRec 304, 147,251, 6,6
    drawRec 307, 147, 47, 3,3
    drawRec 304, 150, 47, 3,3
    jmp accs_wait
mapLava:
    mov [mapColor], 11
    drawRec 304, 147,14, 6,6
    drawRec 307, 147, 1, 3,3
    drawRec 304, 150, 1, 3,3
    jmp accs_wait
mapPastel:
    mov [mapColor], 12
    drawRec 304, 147,183, 6,6
    drawRec 307, 147, 229, 3,3
    drawRec 304, 150, 229, 3,3
    jmp accs_wait

mapAuttum:
    mov [mapColor], 13
    drawRec 304, 147,47, 6,6
    drawRec 307, 147, 31, 3,3
    drawRec 304, 150, 31, 3,3
    jmp accs_wait

mapMint:
    mov [mapColor], 14
    drawRec 304, 147,188, 6,6
    drawRec 307, 147, 178, 3,3
    drawRec 304, 150, 178, 3,3
    jmp accs_wait
mapNeon:
    mov [mapColor], 15
    drawRec 304, 147,242, 6,6
    drawRec 307, 147, 6, 3,3
    drawRec 304, 150, 6, 3,3
    jmp accs_wait
mapRose:
    mov [mapColor], 16
    drawRec 304, 147,231, 6,6
    drawRec 307, 147, 134, 3,3
    drawRec 304, 150, 134, 3,3
    jmp accs_wait
mapVintage:
    mov [mapColor], 17
    drawRec 304, 147,183, 6,6
    drawRec 307, 147, 93, 3,3
    drawRec 304, 150, 93, 3,3
    jmp accs_wait
mapCyber:
    mov [mapColor], 18
    drawRec 304, 147,199, 6,6
    drawRec 307, 147, 198, 3,3
    drawRec 304, 150, 198, 3,3
    jmp accs_wait
mapSand:
    mov [mapColor], 19
    drawRec 304, 147,191, 6,6
    drawRec 307, 147, 182, 3,3
    drawRec 304, 150, 182, 3,3
    jmp accs_wait
mapGalaxy:
    mov [mapColor], 20
    drawRec 304, 147,228, 6,6
    drawRec 307, 147, 219, 3,3
    drawRec 304, 150, 219, 3,3
    jmp accs_wait

inst:
    hide_mouse                          ; Hide mouse 
    print_bmp instScr, 200, 320, 0, 0   ; Print the instructions screen (BMP image)
    init_mouse                          ; Initialize mouse 
    show_mouse                          ; Show the mouse again
    call set_mouse                      ; Set mouse color (palette entry 15 = white)

sstartInputLoop:
    ; -------- KEYBOARD INPUT --------
    mov ah, 1                           ; Check if a key is pressed
    int 16h
    jz @@@startNoKey                    ; If no key, skip to mouse

    mov ah, 0                           ; Get the actual key pressed
    int 16h
    cmp al, back_key                    ; If 'back' key pressed ('b')
    je startscreen                      ; Go back to the start screen

@@@startNoKey:
    ; -------- MOUSE INPUT --------
    get_mouse                           ; gets pos of mouse
    and bx, 01h                         ; Check if left mouse button is pressed
    jz sstartInputLoop                  ; If not clicked, loop back

    movMouseXY                          ; Store mouse click position in [mouse_x], [mouse_y]

    ; -------- CHECK IF "Close" BUTTON WAS CLICKED --------
    checkMouse 136, 120, 181, 138, [mouse_x], [mouse_y]
    je setStartScreen                   ; If click was inside the "start" button, go back to start screen

@@@closeNotClicked:
    ; -------- WAIT FOR MOUSE RELEASE --------
@@@startMouseNotReleased:
    get_mouse                           ; gets pos of mouse
    and bx, 01h                         ; Keep checking until mouse is released
    jnz @@@startMouseNotReleased

    jmp sstartInputLoop                 ; Return to input loop (keep checking)
