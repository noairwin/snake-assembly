
;PROCS.ASM;
; enter - x , y (for dot), color
; exit - prints a dot on requested x, y
proc drawPixel
    push cx ax               ; Save registers that will be used

    mov bh, 0h               ; Page number = 0 (standard for mode 13h)
    mov cx, [x_rec]          ; CX = x coordinate of pixel
    mov dx, [y_rec]          ; DX = y coordinate of pixel
    mov al, [color]          ; AL = color to draw
    mov ah, 0Ch              ; AH = function 0Ch (write pixel)
    int 10h                  ; Call BIOS interrupt to draw pixel

    pop ax cx                ; Restore registers
    ret
endp drawPixel
; enter - length of key
; exit - prints line from x + requested length
proc draw_Line
    push cx                  ; Save CX (used as loop counter)

    mov cx, [len]            ; Set loop counter to the desired line length

pixelLoop:
    call drawPixel           ; Draw a pixel at (x_rec, y_rec)
    inc [x_rec]              ; Move one pixel to the right (increase x)
    loop pixelLoop           ; Repeat until CX = 0

    pop cx                   ; Restore CX
    ret
endp draw_Line

; enter - height of key
; exit - prints whole key (rectangle) at [x_rec], [y_rec]
proc print_rec
    push cx si [len] [height]  ; Save registers and variables

    mov cx, [height]           ; CX = number of rows (height of rectangle)
    mov si, [len]              ; SI = original line length (for resetting x)

lineLoop:
    call draw_Line             ; Draw a full horizontal line
    inc [y_rec]                ; Move one pixel down
    sub [x_rec], si            ; Reset x_rec to original start position
    loop lineLoop              ; Repeat for 'height' lines

    pop [height] [len] si cx   ; Restore registers and vars
    ret
endp print_rec

;enter – file name in filename
;exit - Open file, put handle in filehandle
proc Open_File
	push ax dx 
	mov ah, 3Dh
	xor al, al
	mov dx, [currentFile]
	int 21h
	jc openerror
	mov [filehandle], ax
	pop dx ax
	ret
openerror:
	mov dx, offset ErrorMsg
	mov ah, 9h
	int 21h
	mov ax, 4c00h ; exit the program
	int 21h
endp Open_File

proc ReadHeader
; Read BMP file header, 54 bytes
      push ax bx cx dx
      mov ah,3fh
      mov bx, [filehandle]
      mov cx , 54
      mov dx,offset Palette
      int 21h 
      pop dx cx bx ax
      ret
endp ReadHeader

proc ReadPalette
; Read BMP file color palette, 256 
; colors * 4 bytes (400h)
    push ax bx cx dx
    mov ah,3fh
    mov bx, [filehandle]
    mov cx , 400h 
    mov dx,offset Palette
    int 21h 
    pop dx cx bx ax
    ret
endp ReadPalette

proc CopyPal
; Copy the colors palette to the video memory registers 
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
	push ax cx dx si
	mov si,offset Palette 
	mov cx,256 
	mov dx,3C8h
	mov al,0 
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h
	inc dx 
PalLoop:
; Note: Colors in a BMP file are saved as BGR values rather than RGB.
	mov al,[si+2] 	; Get red value.
	shr al,1 		; Max. is 255, but video palette maximal
	shr al, 1
 ; value is 63. Therefore dividing by 4.
	out dx,al		 ; Send it.
	mov al,[si+1] 	; Get green value.
	shr al,1
	shr al, 1
	out dx,al 		; Send it.
	mov al,[si] 	; Get blue value.
	shr al,1
	shr al, 1
	out dx,al 		; Send it.
	add si,4		 ; Point to next color.
 ; (There is a null chr. after every color.)
	loop PalLoop
    pop si dx cx ax
	ret
endp CopyPal

proc CopyBitmap
; BMP graphics are saved upside-down.
; Read the graphic line by line (200 lines in VGA format),
; displaying the lines from bottom to top.
	push ax bx cx dx di es
	mov ax, 0A000h
	mov es, ax
	mov bx, [filehandle]
	mov cx,[picHigh] 
	PrintBMPLoop:
	push cx ; di = cx*320, point to the correct screen line
	mov di,cx 
	shl cx,1
	shl cx,1 
	shl cx,1 
	shl cx,1 
	shl cx,1 
	shl cx,1  
	shl di,1
	shl di,1 
	shl di,1 
	shl di,1 
	shl di,1 
	shl di,1 
	shl di,1 
	shl di,1 
	  
	add di,cx
	; ----------------------------------------------------------
	 add di,[leftGap]
	 add di,[topGap]
	; Read one line
	mov ah,3fh
	mov cx,[picWidth]
	mov dx,offset ScrLine
	int 21h 
	; Copy one line into video memory
	cld 		; Clear direction flag, for movsb
	mov cx,320
	mov si,offset ScrLine
	rep movsb 	; Copy line to the screen
	pop cx
	loop PrintBMPLoop
	pop es di dx cx bx ax
	ret
endp CopyBitmap


; enter - nothing
; exit - print bmp pic
proc printPic 
	call Open_File
	call ReadHeader
	call ReadPalette
	call CopyPal
	call CopyBitmap
	call CloseFile
ret
endp printPic

; enter - pos: location, charOff: offset of character
; exit - AND between character and screen (snake)
proc anding
	push ax es di si cx
	mov ax, 0A000h              ; Set video segment to VGA
	mov es, ax
	mov di, [pos]               ; Destination index = screen position
	mov si, offset qb_mask      ; SI = sprite mask source
	mov cx, [qb_height]         ; Loop for each row of the sprite
and1:
	push cx
	mov cx, [qb_wid]            ; Loop through sprite row width
xx:
	lodsb                       ; Load byte from [SI] to AL
	and [es:di], al             ; AND with screen content
	inc di
	loop xx
	add di, 320                 ; Move to next screen line
	sub di, [qb_wid]            ; Align di to start of next sprite row
	pop cx
	loop and1
	pop cx si di es ax
	ret 
endp anding

; enter - pos: location, charOff: offset of character
; exit - OR between character and screen (snake)
proc oring 
	push ax es di si cx
	mov ax, 0A000h
	mov es, ax
	mov di, [pos]
	mov si, offset qb          ; SI = snake sprite data
	mov cx, [qb_height]
or1:
	push cx
	mov cx, [qb_wid]
yy:
	lodsb
	or [es:di], al             ; OR pixel to screen
	inc di
	loop yy 
	add di, 320
	sub di, [qb_wid]
	pop cx
	loop or1
	pop cx si di es ax
	ret
endp oring

; enter - pos: location, charOff: offset of character
; exit - AND between character and screen (apple)
proc anding_apple
	push ax es di si cx
	mov ax, 0A000h
	mov es, ax
	mov di, [apple_pos]
	mov si, offset appleCh_mask
	mov cx, [qb_height]
and2:
	push cx
	mov cx, [qb_wid]
xx1:
	lodsb
	and [es:di], al
	inc di
	loop xx1
	add di, 320
	sub di, [qb_wid]
	pop cx
	loop and2
	pop cx si di es ax
	ret 
endp anding_apple

; enter - pos: location, charOff: offset of character
; exit - OR between character and screen (apple)
proc oring_apple
	push ax es di si cx
	mov ax, 0A000h
	mov es, ax
	mov di, [apple_pos]
	mov si, offset appleCh
	mov cx, [qb_height]
or2:
	push cx
	mov cx, [qb_wid]
yy1:
	lodsb
	or [es:di], al
	inc di
	loop yy1
	add di, 320
	sub di, [qb_wid]
	pop cx
	loop or2
	pop cx si di es ax
	ret
endp oring_apple

; enter - nothing
; exit - print the takeSqr in the correct color
proc retSqr
	push ax bx
	mov al, [x]
	add al, [y]                 ; Calculate (x + y)
	xor ah, ah
	mov bl, 2
	div bl                     ; AL MOD 2 → AH = parity

	mov [color], lightGreen
	cmp ah, 0
	je green                   ; Even square → dark color
	mov [color], darkGreen
green: 
	xyRec x, y
	call print_rec             ; Draw square with the chosen color
	pop bx ax
	ret 
endp retSqr

	
	; enter - gets key inside
; exit - updates the snake's direction after a movement
proc CheckKey
    mov [pause_flag], 0         ; Clear pause flag
    mov [flagEsc], 0            ; Clear escape flag
    mov ah, 1
    int 16h                     ; Check for key press
    jz noKey                    ; If no key, skip

    mov ah, 0
    int 16h                     ; Read the key from buffer

    cmp ah, 11h                 ; 'W'
    je setUp
    cmp ah, 48h                 ; Up arrow
    je setUp

    cmp ah, 1Fh                 ; 'S'
    je setDown
    cmp ah, 50h                 ; Down arrow
    je setDown

    cmp ah, 1Eh                 ; 'A'
    je setLeft
    cmp ah, 4Bh                 ; Left arrow
    je setLeft

    cmp ah, 20h                 ; 'D'
    je setRight
    cmp ah, 4Dh                 ; Right arrow
    je setRight

    cmp ah, 19h                 ; 'P' - Pause
    je pauseScre

    cmp ah, 1h                  ; ESC
    je exit
    jmp noKey

escFlag:
    mov [flagESC], 1
    jmp noKey

setUp:    
    mov [direction], 0          ; 0 = UP
    jmp nokey
setRight: 
    mov [direction], 1          ; 1 = RIGHT
    jmp nokey
setDown:  
    mov [direction], 2          ; 2 = DOWN
    jmp nokey
setLeft:  
    mov [direction], 3          ; 3 = LEFT
    jmp noKey

pauseScre:
    mov [pause_flag], 1         ; Signal pause

noKey:
    ret
endp CheckKey

; enter - nothing
; exit - creates a short delay (used for pacing snake movement)
proc DelaySmall
    push cx dx
    mov cx, 3500                ; Outer loop count
delay_loop:
    mov dx, 2300                ; Inner loop count
inner_loop:
    nop                         ; No operation = short CPU delay
    dec dx
    jnz inner_loop
    loop delay_loop
    pop dx cx
    ret
endp DelaySmall

; enter - nothing
; exit - generates a random x position (0–18), stores in x_apple
proc x_random
    push ax es cx si
    mov ax, 40h                 ; BIOS data segment (timer)
    mov es, ax
rndX:
    mov ax, [clock]             ; Read current time tick
    mov ah, [byte cs:bx]        ; Read a memory byte from code segment
    xor al, ah                  ; Mix both for "randomness"
    and al, 00001111b           ; Limit result to 0–18 (19 options)
    mov [x_apple], al
    mov ax, [clock]             ; Read current time tick
    mov ah, [byte cs:bx]        ; Read a memory byte from code segment
    xor al, ah                  ; Mix both for "randomness"
    and al, 00000011b
    add [x_apple], al
;     mov cx, [snake_length]
;     inc cx
;     mov si, [snake_length]
; checkX:
;     mov al, [x_arr + si]
;     cmp al, [x_apple]
;     je rndx
;     dec si
;     loop checkx
    pop si cx es ax 
    ret
endp x_random

; enter - nothing
; exit - generates a random y position (0–10), stores in y_apple
proc y_random
    push ax es cx si
    mov ax, 40h                 ; BIOS timer segment
    mov es, ax
rndY:
    ; First "random" part (0–7)
    mov ax, [clock]
    mov ah, [byte cs:bx]
    xor al, ah
    and al, 00000111b           ; 0–7
    mov [y_apple], al

    ; Second "random" part (0–3)
    mov ax, [clock]
    mov ah, [byte cs:bx]
    xor al, ah
    and al, 00000011b           ; 0–3
    add [y_apple], al           ; Total: 0–10

    ; Clamp in case something went wrong (very unlikely)
    mov al, [y_apple]
    cmp al, 10
    jbe skipClamp
    mov al, 10
    mov [y_apple], al

skipClamp:
    mov [y_apple], al

;     mov cx, [snake_length]
;     inc cx
;     mov si, [snake_length]
; checky:
;     mov al, [y_arr + si]
;     cmp al, [y_apple]
;     je rndy
;     dec si
;     loop checky
    pop si cx es ax
    ret
endp y_random

; enter - nothing
; exit - if snake eats apple, generate new one, increase length and score
proc apple_eaten
    push ax bx cx si dx

    ; Check if head is on apple
    mov al, [x]
    cmp al, [x_apple]
    jne finish

    mov al, [y]
    cmp al, [y_apple]
    jne finish

; generate_new_apple:
;     call x_random
;     call y_random
    
;     mov cx, [snake_length]
;     inc cx
;     xor si,si
; check_again:
;     mov al, [x_apple]
;     cmp al, [x_arr+si]
;     jne skip_y

;     mov al, [y_apple]
;     cmp al, [y_arr+si]
;     je generate_new_apple

; skip_y:
;     inc si
;     loop check_again


printApple:
    inc [score]
    
    call playnote
    mov [sound1IsOn], 1
    mov [sound2IsOn], 1
    mov [sound3IsOn], 1

    inc [snake_length]
    inc [tail]
    
    mov al, [x_tail]
    mov bl, [tail]
    mov [x_arr + bx], al

    mov al, [y_tail]
    mov [y_arr + bx], al
generate_new_apple:
    call x_random
    call y_random
    
    mov cx, [snake_length]
    xor si,si
check_again:
    mov al, [x_apple]
    cmp al, [x_arr+si]
    jne skip_y

    mov al, [y_apple]
    cmp al, [y_arr+si]
    je generate_new_apple

skip_y:
    inc si
    loop check_again

    calcApplePos x_apple, y_apple
    call movewholesnake
    call anding_apple
    call oring_apple

finish:
    pop dx si cx bx ax
    ret
endp apple_eaten




; enter - none
; exit - draws an apple on a random position
proc draw_apple
    call x_random                     ; Generate random x_apple
    call y_random                     ; Generate random y_apple
    calcApplePos x_apple ,y_apple    ; Calculate screen position
    call anding_apple                ; Clear area with apple mask
    call oring_apple                 ; Draw apple sprite
    ret 
endp draw_apple

; enter - nothing
; exit - initialize all snake-related variables
proc init_vars
    mov [direction], 1               ; Start direction: right
    mov [tail], 1                    ; Tail index starts at 1
    mov [x], 1                       ; Initial x
    mov [y], 3                       ; Initial y
    mov cx, [snake_length]          ; Get snake length
    mov si, [snake_length]          
    dec si                          

    mov [score], 0                  ; Reset score
    mov [sound1IsOn], 0             ; Sound flags off
    mov [sound2IsOn], 0
    mov [sound3IsOn], 0
    mov [note], 4560                ; Default sound freq

init_arrs:
    mov [x_arr + si], 0             ; Zero out x_arr
    mov [y_arr + si], 0             ; Zero out y_arr
    dec si
    loop init_arrs

    mov [snake_length], 2           ; Start with length 2
    mov [x_tail], 0
    mov [y_tail], 0
    mov [pos], 320*92+144           ; Default screen pos
    ret
endp init_vars

; enter - x_arr, y_arr
; exit - move all snake segments one step forward
proc moveWholeSnake
    push ax bx cx dx
    xor bx, bx                      ; Start from index 0
    mov bl, [tail]                 ; Get tail index
    mov cx, bx                     ; Use CX as loop counter

copySnake:
    dec bx                         ; Move to previous segment
    mov al, [x_arr+bx]             ; Copy x
    mov dl, [y_arr+bx]             ; Copy y
    inc bx
    mov [x_arr+bx], al             ; Paste to next
    mov [y_arr+bx], dl
    dec bx
    loop copySnake

    pop dx cx bx ax
    ret
endp movewholesnake

; enter - none
; exit - Check if [x],[y] matches any value in x_arr and y_arr (excluding head)
proc checkSnakeTouch
    push ax bx cx si

    mov [self_touch_flag], 0       ; Reset touch flag
    mov cx, [snake_length]         
    dec cx                         ; Exclude head
    mov si, 1                      ; Start from second segment

loopCheck:
    mov al, [x_arr + si]
    cmp al, [x]                    ; Compare x
    jne next

    mov al, [y_arr + si]
    cmp al, [y]                    ; Compare y
    jne next

    mov [self_touch_flag], 1       ; Snake collided with itself
    jmp done

next:
    inc si
    loop loopCheck

done:
    pop si bx cx ax
    ret
endp checkSnakeTouch

; enter - x, y, color values in [xr], [yr], [colorr]
; exit - draw one pixel at (xr, yr) in desired color
proc printpixel
    push ax bx cx dx

    xor bh, bh                     ; Page number 0
    mov cx, [xr]                   ; Load x into CX
    mov dx, [yr]                   ; Load y into DX
    mov al, [colorr]               ; Load color
    mov ah, 0Ch                    ; BIOS function: write pixel
    int 10h

    pop dx cx bx ax
    ret
endp printpixel

; enter - lenr = number of pixels to draw horizontally
; exit - draw horizontal line starting from (xr, yr)
proc printhorzline
    push ax bx cx dx

    mov cx, [lenr]                 ; Load line length
lineh:
    call printpixel                ; Draw pixel
    inc [xr]                       ; Move right
    loop lineh                     ; Repeat

    pop dx cx bx ax
    ret
endp printhorzline
; enter - nothing
; exit - print a square using [height] and [len]
proc printrec
    push ax bx cx dx

    push [xr] [yr]            ; Save original position

    mov cx, [heightr]         ; Set loop for height

rec:
    call printhorzline        ; Draw horizontal line
    mov ax, [lenr]
    sub [xr], ax              ; Reset X to line start
    add [yr], 1               ; Move down one row
    loop rec

    pop [yr] [xr]             ; Restore original position

    pop dx cx bx ax
    ret
endp printrec

; enter - nothing
; exit - display all 256 palette colors as colored squares
proc printCurrentPallete
    mov [xr], 110
    mov [yr], 10
    mov [lenr], 7
    mov [heightr], 7
    mov [colorr], 0

    mov cx, 16                ; 16 rows
drawlines:
    push cx
    mov cx, 16                ; 16 columns
drawline:
    call printrec            ; Draw one color square
    inc [colorr]             ; Next color index
    add [xr], 9              ; Move right
    loop drawline
    sub [xr], 16*9           ; Move to next line
    add [yr], 9
    pop cx
    loop drawlines
    ret
endp printCurrentPallete

; enter - RGB color vars for background and squares
; exit - sets those values in the DAC palette
proc set_map
    mov ax, 1010h
    mov bx, 16                ; Background color index
    mov dh, [RBackground]
    mov ch, [GBackground]
    mov cl, [BBackground]
    int 10h

    mov ax, 1010h
    mov bx, 32                ; Dark square color index
    mov dh, [RDarkSquare]
    mov ch, [GDarkSquare]
    mov cl, [BDarkSquare]
    int 10h

    mov bx, 50                ; Light square color index
    mov dh, [RLightSquare]
    mov ch, [GLightSquare]
    mov cl, [BLightSquare]
    int 10h
    ret
endp set_map

; enter - none
; exit - set mouse color (white)
proc set_mouse
    push ax bx cx dx
    mov ax, 1010h
    mov bx, 0Fh               ; Palette index 15
    mov dh, 63                ; R = max
    mov ch, 63                ; G = max
    mov cl, 63                ; B = max
    int 10h
    pop dx cx bx ax
    ret
endp set_mouse

; enter - none
; exit - open file into [filehandle]
proc OpenFile
    mov ah, 3Dh               ; Open file function
    mov al, 2                 ; Read/Write access
    mov dx, offset scoresFile ; File name address
    int 21h
    jc openerror1             ; If error, jump to error
    mov [filehandle], ax      ; Save file handle
    jmp finproc
openerror1:
    mov dx, offset ErrorMsg
    mov ah, 9h
    int 21h
finProc:
    ret
endp OpenFile

; enter - none
; exit - closes the opened file
proc CloseFile
    push ax bx
    mov ah, 3Eh
    mov bx, [filehandle]
    int 21h
    pop bx ax
    ret
endp CloseFile

; enter - note in [note]
; exit - plays note using PC speaker
proc playNote
    sound_on                 ; Enable speaker
    mov ax, [note]           ; Load note frequency
    out 42h, al              ; Send low byte to PIT
    mov al, ah
    out 42h, al              ; Send high byte
    ret
endp playNote

; enter - none
; exit - waits until left mouse button is released
proc waitForMouseRelease
waitReleaseLoop:
    get_mouse
    and bx, 01h
    jnz waitReleaseLoop      ; Loop while still pressed
    ret
endp waitForMouseRelease

; enter - [snakeColor]
; exit - fills sprite buffer with the selected color
proc fillSnakeSprite
    push ax bx cx di
    mov al, [snakeColor]
    mov cx, 256              ; 16x16 = 256 pixels
    mov di, offset qb
fill_loop:
    mov bl, [di]
    cmp bl, 0
    je skip_pixel            ; Preserve black border
    mov [di], al
skip_pixel:
    inc di
    loop fill_loop
    pop di cx bx ax
    ret
endp fillSnakeSprite

; enter – number in AL
; exit – prints the number digit by digit
proc printNumber
    push ax 
    call set_mouse           ; Ensure cursor is visible
    mov bx, offset divisorTable
@@@nextDigit:
    xor ah, ah
    div [byte ptr bx]        ; AL = quotient, AH = remainder
    add al, '0'
    call printCharacter
    mov al, ah
    add bx, 1
    cmp [byte ptr bx], 0
    jne @@@nextDigit
    pop ax
    ret
endp printNumber

; enter – character in AL
; exit – prints that character
proc printCharacter
    push ax dx
    mov ah, 2
    mov dl, al
    int 21h
    pop dx ax
    ret
endp printCharacter
; enter - txt file handle in HandleScores
; exit - writes 5 bytes from [scores] to the file
proc WriteToFile
    push ax bx cx dx
    mov ah, 40h                ; Function: write to file
    mov bx, [HandleScores]     ; File handle
    mov cx, 5                  ; Number of bytes to write
    mov dx, offset scores      ; Address of buffer to write
    int 21h                    ; DOS interrupt
    pop dx cx bx ax
    ret
endp WriteToFile

; enter - txt file handle in HandleScores
; exit - reads 5 bytes from file into [scores]
proc ReadFile
    push ax bx cx dx
    mov ah, 3Fh                ; Function: read from file
    mov bx, [HandleScores]     ; File handle
    mov cx, 5                  ; Number of bytes to read
    mov dx, offset scores      ; Address of buffer to fill
    int 21h                    ; DOS interrupt
    pop dx cx bx ax
    ret
endp ReadFile

; enter - txt file handle in HandleScores
; exit - moves file pointer back to start
proc seekToStart
    push ax bx cx dx
    mov ah, 42h                ; Function: move file pointer
    mov al, 0                  ; Origin: start of file
    mov bx, [HandleScores]     ; File handle
    mov cx, 0
    mov dx, 0                  ; Move to offset 0:0
    int 21h
    pop dx cx bx ax
    ret
endp seekToStart

; enter - current score
; sort top 4 scoresproc checkScores
proc checkScores
    push si ax bx         ; Save registers to stack
    xor si, si            ; Start from index 0
    mov bx, 4             ; BX = position to insert (starts from 4, decrements when inserting earlier)
    mov al, [score]       ; AL = current score to insert
    jmp checkscore        ; Jump to first comparison

checkNextscore:
    inc si                ; Move to next index in scores array
    cmp si, 4             ; Check if we've reached the end of top 5 (indexes 0–4)
    je finished           ; If so, exit (score not high enough)

checkscore:
    cmp al, [scores+si]   ; Compare current score with scores[si]
    jbe checkNextscore    ; If it's less or equal, continue checking next spot

    dec bx                ; Decrease insert index (we're shifting later scores down)
    mov ah, [scores+si]   ; Store existing score at that spot into AH
    mov [scores+si], al   ; Insert current score into scores[si]
    mov al, ah            ; Move the previous score into AL to continue bubbling down
    inc si                ; Move to next index
    cmp si, 4             ; Are we at the end?
    je finished           ; If yes, done
    jmp checkscore        ; Otherwise, continue checking

finished:
    ; call updateNames    ; Optionally update names list in leaderboard
    pop bx ax si          ; Restore saved registers
    ret
endp checkScores


; enter - mapColor
; exit - sets map with requested colors
proc setMap
    cmp [mapColor], 1
    je finishLoop
    cmp [mapColor], 2
    je blueMap
    cmp [mapColor], 3
    je pinkMap
    cmp [mapColor], 4
    je yellowMap
    cmp [mapColor], 5
    je greyMap
    cmp [mapColor], 6
    je purpleMap
    cmp [mapColor], 7
    je turquoisemap
    cmp [mapColor], 8
    je orangemap
    cmp [mapColor], 9
    je icemap
    cmp [mapColor], 10
    je oceanMap
    cmp [mapColor], 11
    je lavaMap
    cmp [mapColor], 12
    je pastelMap
    cmp [mapColor], 13
    je auttumMap
    cmp [mapColor], 14
    je mintMap
    cmp [mapColor], 15
    je neonMap
    cmp [mapColor], 16
    je roseMap
    cmp [mapColor], 17
    je vintgeMap
   cmp [mapColor], 18
    je cyberMap
    cmp [mapColor], 19
    je sandMap
    cmp [mapColor], 20
    je galexyMap

greenMap: 
    ; Default green palette
    setMapVars 0,64,0, 64,192,0, 0,128,0
    jmp finishLoop

blueMap:
    ; Ocean blue
    setMapVars 0,90,105, 0,88,100, 10,100,100
    jmp finishLoop

pinkMap:
    ; Candy pink
    setMapVars 250,90,175, 255,95,180, 245,85,170
    jmp finishLoop

yellowMap:
    ; Bright yellow
    setMapVars 255,240,0, 255,255,0, 255,220,0
    jmp finishLoop

greyMap:
    ; Neutral grayscale
    setMapVars 10,10,10, 30,30,30, 255,255,255
    jmp finishLoop

purpleMap:
    ; Pale purple
    setMapVars 220,225,240, 235,240,255, 255,255,255
    jmp finishLoop

turquoiseMap:
    ; Rich turquoise
    setMapVars 130,120,160, 130,120,170, 70,60,110
    jmp finishLoop

orangeMap:
    ; Warm orange-red
    setMapVars 50,20,10, 63,30,15, 63,40,30
    jmp finishLoop

iceMap:
    ; Cold blue tones
    setMapVars 10,30,50, 20,45,63, 40,55,63
    jmp finishLoop

oceanMap:
    ; Citrus ocean (yellow-green)
    setMapVars 60,60,0, 63,63,15, 63,45,0
    jmp finishLoop

lavaMap:
    ; Lava heat
    setMapVars 50,10,0, 63,15,5, 63,25,15
    jmp finishLoop

pastelMap:
    ; Soft pastel blend
    setMapVars 50,50,63, 60,50,50, 45,35,63
    jmp finishLoop

auttumMap:
    ; Autumn leaf tones
    setMapVars 45,20,0, 50,35,5, 55,25,10
    jmp finishLoop

mintMap:
    ; Minty cool greens
    setMapVars 30,63,50, 30,60,50, 20,55,40
    jmp finishLoop

neonMap:
    ; Bright neon cyan/green
    setMapVars 0,63,63, 25,63,63, 0,40,40
    jmp finishLoop

roseMap:
    ; Romantic rose shades
    setMapVars 63,20,40, 63,40,55, 45,15,25
    jmp finishLoop

vintgeMap:
    ; Warm brown vintage
    setMapVars 30,25,15, 40,30,20, 50,35,25
    jmp finishLoop

cyberMap:
    ; Cyberpunk violet
    setMapVars 30,0,40, 50,0,63, 63,10,63
    jmp finishLoop

sandMap:
    ; Desert tones
    setMapVars 50,45,20, 60,50,30, 63,63,40
    jmp finishLoop

galexyMap:
    ; Galaxy twilight
    setMapVars 10,10,20, 20,20,35, 30,30,50

finishLoop:
    ret
endp setMap