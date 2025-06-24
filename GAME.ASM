
;GAME.ASM;
startGame:
    init_mouse                      ; init the mouse
	print_bmp map, 200, 320, 0, 0   ; print map
    ; call set_Map
    call setMap
print_snake:
    mov [x_arr], 1                 ; get the first x pos of the snake to the x_arr
    mov [y_arr], 3                  ; get the first x pos of the snake to the x_arr
    mov [x_arr + 1], 0              ; get the second seg of snake
    mov [y_arr + 1], 3              ; get the second seg of snake
    call fillSnakeSprite            ; fills the snake sprite in requested color
    mov2vars 0                      ; moves first x var into the first index of xy arrs 
    calcPos x ,y                    ; calc pos of xy in map
    call anding                     ; 
    call oring                      ; prints the snake
    movWVars [x], [keep_x]          ; keeps x bc theres overWrite
    movWVars [y], [keep_y]          ; keeps y theres overWrite
    mov2vars 1                      ; moves first x var into the first index of xy arrs 
    calcPos x ,y                    ; calc pos of xy in map
    call anding
    call oring                      ; prints the snake

    movWVars [keep_x], [x]          ; return the x to his place
    movWVars [keep_y], [y]          ; return the x to his place
    call draw_apple                 ; prints apple
    mov al, [score]                 
    printCoordinates 21, 1
    call printnumber                ; prints score

game:
waitFor:
    ; check keyboard status
	mov	ah, 1 	
	int	16h
	jz 	waitfor
	; read key
	mov ah, 0	
	int 16h

    cmp al, space_key         
    je gameloop                 ; waits for space to start the game
    jmp waitFor
; play 3 sounds of score (when apple is eaten)
gameLoop:  
    cmp [sound3IsOn], 0
    je stopSound
    cmp [sound2IsOn], 0
    je playsound3
    cmp [sound1IsOn], 0
    je playSound2
    mov [sound1IsOn], 0
    jmp contLoop
; plays second score when note1 is done
playSound2:
    mov [note], 4061
    call playNote
    mov [sound2IsOn], 0
    jmp contloop
; plays third score when note2 is done
playSound3:
    mov [note], 3615
    call playNote
    mov [sound3IsOn], 0
    jmp contloop

; stops playing sound 
stopSound:
    sound_off
    mov [note], 4560

contLoop:
    call set_mouse          ; paint mouse in white
    call DelaySmall         ; delay so snake will always move
    call CheckKey           ; gets input from keyboard
    cmp [pause_flag], 1     
    je pauseScr             ; checks if pauses, if so jmp to pause screen
    cmp [flagESC], 1  
    je exit                 ; checks if exit, if so jmp to exit
    
        xor bx, bx             ; Clear BX (set it to 0)
    mov bl, [tail]         ; Load tail index into BL (BX now points to the tail cell)

    mov al, [x_arr+bx]     ; Load x-coordinate of the tail into AL
    mov [x_tail], al       ; Store it into x_tail (to use later for erasing or adding)

    mov al, [y_arr+bx]     ; Load y-coordinate of the tail into AL
    mov [y_tail], al       ; Store it into y_tail

    cmp [direction], 0     ; Check if direction == 0 (UP)
    je move_up             ; If so, jump to move_up

    cmp [direction], 1     ; Check if direction == 1 (RIGHT)
    je move_right          ; If so, jump to move_right

    cmp [direction], 2     ; Check if direction == 2 (DOWN)
    je move_down           ; If so, jump to move_down

    cmp [direction], 3     ; Check if direction == 3 (LEFT)
    je move_left           ; If so, jump to move_left

    jmp gameLoop           ; If no match (shouldn’t happen), return to gameLoop
move_up:
    cmp [y], 1                 ; Check if snake is at top edge
    jl loseScreen              ; If y < 1, go to lose screen
    dec [y]                    ; Move snake head one unit up
    call checkSnakeTouch       ; Check if snake touched itself
    checkFlag                  ; Check if self_touch_flag is set
    movWVars [y], [y_head]     ; Save current y as new y_head
    movWVars [x], [x_head]     ; Save current x as new x_head
    
    call moveWholeSnake      ; ✅ Shift old head into body first

    mov al, [x]              ; ✅ Now store the new head into [0]
    mov [x_arr], al
    mov al, [y]
    mov [y_arr], al

    call apple_eaten         ; ✅ Apple check includes full up-to-date body
    jmp update                 ; Jump to update graphics
    

move_right:
    cmp [x], 17                ; Check if snake is at right edge
    ja loseScreen              ; If x > 17, go to lose screen
    inc [x]                    ; Move head one unit right
    call checkSnakeTouch
    checkFlag
    movWVars [y], [y_head]
    movWVars [x], [x_head]
   call moveWholeSnake      ; ✅ Shift old head into body first

    mov al, [x]              ; ✅ Now store the new head into [0]
    mov [x_arr], al
    mov al, [y]
    mov [y_arr], al

    call apple_eaten         ; ✅ Apple check includes full up-to-date body
    jmp update

move_down:
    cmp [y], 9                 ; Check if snake is at bottom edge
    ja loseScreen              ; If y > 9, go to lose screen
    inc [y]                    ; Move head one unit down
    call checkSnakeTouch
    checkFlag
    movWVars [y], [y_head]
    movWVars [x], [x_head]
   call moveWholeSnake      ; ✅ Shift old head into body first

    mov al, [x]              ; ✅ Now store the new head into [0]
    mov [x_arr], al
    mov al, [y]
    mov [y_arr], al

    call apple_eaten         ; ✅ Apple check includes full up-to-date body

    call apple_eaten
    jmp update

move_left:
    cmp [x], 1
    jl loseScreen
    dec [x]

    call checkSnakeTouch
    checkFlag

    movWVars [y], [y_head]
    movWVars [x], [x_head]

    call moveWholeSnake          ; ✅ 1. shift body first

    mov al, [x]                  ; ✅ 2. now update head
    mov [x_arr], al
    mov al, [y]
    mov [y_arr], al

    call apple_eaten             ; ✅ 3. check apple now (full body in arrays)

    jmp update

update:

    push ax                       ; Save AX (we’ll use it for score display)
    mov al, [score]               ; Load current score into AL
    printCoordinates 21,1         ; Set cursor to row 1, column 21
    call printnumber              ; Print the score on screen
    pop ax                        ; Restore AX

    movWVars [x], [keep_x]        ; Restore x to the head's previous position
    movWVars [y], [keep_y]        ; Restore y to the head's previous position

    mov cx, [snake_length]        ; CX = length of the snake (how many segments to draw)
    xor bx, bx                    ; Start BX = 0 (index into arrays)

snakeLoop:
    mov2vars bx                   ; Load x and y from x_arr[bx], y_arr[bx]
    calcPos x, y                  ; Calculate memory position from x and y
    call anding                   ; AND sprite mask with screen (erase background)

    call oring                    ; OR sprite on screen (draw actual body)
    inc bx                        ; Move to next segment
    loop snakeLoop                ; Repeat for all snake segments

    movWVars [x_tail], [x]        ; Save current x as tail's x (for erasing or extending)
    movWVars [y_tail], [y]        ; Save current y as tail's y

    call retSqr                   ; Re-draw the square under the snake head

    movWVars [keep_x], [x]        ; Save x for next update
    movWVars [keep_y], [y]        ; Save y for next update

    jmp gameLoop                  ; Return to main game loop



pauseScr:
    hide_mouse                              ; Hide mouse cursor
    print_bmp pauseScreen, 200, 320, 0, 0   ; Display the pause screen image
    call set_mouse                          ; Set mouse palette color (index 15)
    init_mouse                              ; Initialize mouse driver
    show_mouse                              ; Show mouse cursor again

    mov al, [score]                         ; Load current score into AL
    printCoordinates 19,9                   ; Set cursor to row 9, col 19
    call printNumber                        ; Print the score on the pause screen

startInput2:
    ; Keyboard input check
    mov ah, 1                               ; Function 01h - check if key is available
    int 16h                                 ; Call BIOS keyboard interrupt
    jz startNoKey2                          ; If no key pressed, jump to mouse input

    ; Key is available - read it
    mov ah, 0                               ; Function 00h - read key
    int 16h                                 ; Call BIOS keyboard interrupt

    cmp al, back_key                        ; Compare key with 'b' (back to game)
    je setBackGame                          ; If matched, jump to resume game

    cmp ah, esc_key                         ; Compare with ESC key scancode
    je setStartScreen                                 ; If matched, exit game

startNoKey2:
    ; Mouse input
    mov bx, 0
    get_mouse                               ; Call mouse interrupt, BX = button status
    and bx, 01h                             ; Check if left button is clicked
    jz startInput2                          ; If not clicked, check again

    movMouseXY                              ; Read mouse x/y into [mouse_x], [mouse_y]

    checkMouse 102, 96, 147, 114, [mouse_x], [mouse_y] ; Check if click is on "back" button
    je setBackGame

    checkMouse 180, 96, 225, 114, [mouse_x], [mouse_y] ; Check if click is on "home" button
    je setStartScreen

MouseNotReleased2:
    get_mouse                               ; Wait for mouse release
    and bx, 01h
    jnz MouseNotReleased2                   ; Loop until left click is released

    jmp startInput2                         ; Go back to input check

setBackGame:
    hide_mouse                              ; Hide mouse
    print_bmp map, 200, 320, 0, 0           ; Redraw the map image
    call setMap                             ; Load and apply current map palette
    call anding_apple                       ; Redraw the apple (masking)
    call oring_apple                        ; Redraw the apple (coloring)
    jmp gameloop                            ; Resume game loop

