
;MACROS.ASM;

; enter - x,y of snake
; exit - calculate the pos in the map as the 16x16 squares
calcPos macro x_pos, y_pos
    push ax bx cx dx
    mov cl, [x_pos]               ; x
    mov dl, [y_pos]               ; y
    mov [pos], leftOutlineGap     ; adds pos the left gap of the map
    mulByScreenReg topOutlineGap  ; mul ax (pos) by 320 to fit screen
    add [pos], ax             
    mul16  cl                     ; mul x by 16 to be exacly in the square in map
    add [pos], ax               
    mul16 dl                      ; mul x by 16 to be exacly in the square in map
    mulByScreenReg ax             ; mul ax (pos) by 320 to fit screen
    add [pos], ax                 ; puts ax in pos
    pop dx cx bx ax
    ;pos = leftGap + topGap * 320
    ;pos += x_pos * 16
    ;pos += 320 * (y_pos * 16)
endm


; enter - x,y of apple
; exit - calculate the pos in the map as the 16x16 squares
calcApplePos macro x_pos, y_pos
    push ax bx cx dx
    mov cl, [x_pos]                 ; x
    mov dl, [y_pos]                 ; y
    mov [apple_pos], leftOutlineGap ; adds pos the left gap of the map
    mulByScreenReg topOutlineGap    ; mul ax (pos) by 320 to fit screen 
    add [apple_pos], ax
    mul16  cl                       ; mul x by 16 to be exacly in the square in map
    add [apple_pos], ax
    mul16 dl                        ; mul x by 16 to be exacly in the square in map
    mulByScreenReg ax
    add [apple_pos], ax             ; puts ax in apple pos
    pop dx cx bx ax
endm

; enter - x,y
; exit - calculate the x,y in the map
xyRec macro x_pos, y_pos
	mov [x_rec], leftOutlineGap
	mul16 [x_pos]
	add [x_rec], ax
	
	mov [y_rec], topOutlineGap
	mul16 [y_pos]
	add [y_rec], ax
endm



; enter - var1, var2
; exit - replace var2 with var1
movWVars macro var1, var2
    push ax
    mov al, var1
    mov var2, al
    pop ax
endm

; enter - index in arr
; exit - mov x,y into x,y arrays
mov2vars macro index
    push ax si bx
	xor ah, ah
    mov bx, index           ; gets index in arr
    mov si, bx
    add bx, offset x_arr    ; start of x arr
    add si, offset y_arr    ; start of y arr
    mov al, [bx]            ; index is now in al
    mov [x], al
    mov al, [si]
    mov [y], al
    pop bx si ax
endm

;mul variable by 320
mulByScreen macro variable
	push ax bx
    mov ax, [variable]      ; gets var
    shl ax, 1 ; 64
    shl ax, 1
    shl ax, 1
    shl ax, 1
    shl ax, 1
    shl ax, 1
    mov bx, ax
    shl bx, 1 ;4
    shl bx, 1
    add ax, bx
    mov [variable], ax      ; puts var back after mul by 320
	pop bx ax
endm

;mul reg by 320
mulByScreenReg macro var
	push bx
    mov ax, var
    shl ax, 1 ; 64
    shl ax, 1
    shl ax, 1
    shl ax, 1
    shl ax, 1
    shl ax, 1
    mov bx, ax
    shl bx, 1 ;4
    shl bx, 1
    add ax, bx
	pop bx 
endm

; enter - byte
; exit - ax
mul16 macro var
	xor ah, ah
    mov al, var
    shl ax, 1 ; 16
    shl ax, 1
    shl ax, 1
    shl ax, 1
endm 
; enter - void
; exit - move to graffic  mode
callGraphic macro
    mov ax, 13h
    int 10h
endm

; enter - void
; exit - return to text mode
retText macro
    push ax
    mov  ax, 3
    int  10h
    pop  ax
endm
; ========== BITMAP IMAGE MACRO ==========

; enter - filename, height, width, leftGap, topGap
; exit - loads the bitmap parameters and calls printPic
print_bmp macro filen, hight, wid, leftg, topg
    mov [currentFile], offset filen ; Set file name
    mov [picHigh], hight            ; Set picture height
    mov [picWidth], wid             ; Set picture width
    mov [leftGap], leftg            ; Set horizontal position
    mov [topGap], topg*320          ; Convert vertical position to pixel offset
    call printPic                   ; Display BMP image
endm

; ========== SOUND MACROS ==========

; enter - void
; exit - enables speaker output
sound_on macro
    in al, 61h                      ; Read port 61h
    or al, 00000011b               ; Set bits 0 and 1
    out 61h, al                    ; Write back to port
endm

; enter - void
; exit - disables speaker output
sound_off macro
    in al, 61h                      ; Read port 61h
    and al, 11111100b              ; Clear bits 0 and 1
    out 61h, al                    ; Write back to port
endm

; ========== RECTANGLE DRAWING MACRO ==========

; set values for rectangle and call printrec
; enter - x, y, color, length, height
drawRec macro xx, yy, cc, lenn, heightt
    mov [xr], xx                   ; X position
    mov [yr], yy                   ; Y position
    mov [colorr], cc               ; Fill color
    mov [lenr], lenn               ; Rectangle width
    mov [heightr], heightt         ; Rectangle height
    call printrec
endm

; ========== MOUSE CONTROL MACROS ==========

; enter - void
; exit - initialize the mouse driver
init_mouse macro 
    push ax
    mov ax, 0h
    int 33h                        ; Mouse interrupt: initialize
    pop ax
endm 

; enter - void
; exit - show mouse cursor
show_mouse macro
    push ax
    mov ax, 1h
    int 33h                        ; Mouse interrupt: show cursor
    pop ax
endm

; enter - void
; exit - get mouse coordinates and button status
get_mouse macro
    push ax
    mov ax, 3h
    int 33h                        ; Mouse interrupt: get position
    pop ax
endm

; enter - void
; exit - wait for any key to be pressed
press_any_key macro 
    push ax
    mov ah, 00h
    int 16h                        ; Keyboard interrupt: wait for key
    pop ax
endm

; enter - void
; exit - hide mouse cursor
hide_mouse macro
    push ax
    mov ax, 2h
    int 33h                        ; Mouse interrupt: hide cursor
endm

; ========== BUTTON CHECK MACRO ==========

; enter - top left (x1,y1), bottom right (x2,y2), mouse x, mouse y
; exit - sets AL to 1 if mouse click is within bounds, 0 otherwise
checkMouse macro cornerTLX, cornerTLY, cornerBRX, cornerBRY, x, y
    local checksDone
    mov al, 0
    cmp x, cornerTLX               ; Check if mouseX < left edge
    jb checksDone
    cmp x, cornerBRX               ; Check if mouseX > right edge
    ja checksDone
    cmp y, cornerTLY               ; Check if mouseY < top edge
    jb checksDone
    cmp y, cornerBRY               ; Check if mouseY > bottom edge
    ja checksDone
    mov al, 1                      ; Inside bounds = valid press
checksDone:
    cmp al, 1                      ; Result usable as conditional
endm
; ========== INPUT / POSITION MACROS ==========

; enter - none
; exit - sets mouse_x and mouse_y based on current mouse click
movMouseXY macro
    shr cx, 1               ; Convert CX (mouse x) from 0–639 to 0–319
    mov [mouse_x], cx       ; Store adjusted x
    mov [mouse_y], dx       ; Store y directly
endm

; enter - x, y (text mode coordinates)
; exit - sets cursor to given screen location
printCoordinates macro x, y
    ; Move cursor to (x,y) in text mode (not graphics)
    mov dh, y               ; Row
    mov dl, x               ; Column
    mov ah, 2h              ; Function: set cursor position
    xor bh, bh              ; Page 0
    int 10h
endm

; enter - none
; exit - if self-touch flag is 1, jump to loseScreen
checkFlag macro
    cmp [self_touch_flag], 1
    je loseScreen
endm

; ========== MAP COLOR SETTER ==========

; enter - 9 RGB values for background, darkSquare, lightSquare
; exit - stores values into memory and calls set_map to apply
setMapVars macro RBack, GBack, BBack, RDark, GDark , BDark, RLight, GLight, BLight
    push ax
    mov al, RBack              ; Set background red
    mov [RBackground], al
    mov al, GBack              ; Set background green
    mov [GBackground], al
    mov al, BBack              ; Set background blue
    mov [BBackground], al
    mov al, RDark              ; Set dark square red
    mov [RDarkSquare], al
    mov al, GDark              ; Set dark square green
    mov [GDarkSquare], al
    mov al, BDark              ; Set dark square blue
    mov [BDarkSquare], al
    mov al, RLight             ; Set light square red
    mov [RLightSquare], al
    mov al, GLight             ; Set light square green
    mov [GLightSquare], al
    mov al, BLight             ; Set light square blue
    mov [BLightSquare], al
    call set_map               ; Apply values to hardware
    pop ax
endm
