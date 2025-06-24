
;DATASEG.ASM;
; ---------- snake vars ----------
        ; snake sprite
qb	 	db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
		db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
		db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
		db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
		db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
		db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
		db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
		db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
		db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
        db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
        db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
        db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
        db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
        db 00,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,0E7h,00
        db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

        ; snake sprite mask
qb_mask db 0FFh,00,00,00,00,00,00,00,00,00,00,00,00,00,00,0FFh
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
        db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
        db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
        db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
        db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
        db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
        db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
        db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
		db 0FFh,00,00,00,00,00,00,00,00,00,00,00,00,00,00,0FFh

	qb_height dw 16                 ; height of snake sprite
	qb_wid dw 16                    ; wid of snake sprite
	pos dw 320*92+144               ; pos of snake for anding+oring
	x               db 1            ; x pos of head               
	y               db 3            ; y pos of head
    
    keep_x          db ?            ; stores x if overWrite
    keep_y          db ?            ; stores y if overWrite

    x_tail          db 0            ; x pos of tail
    y_tail          db 0            ; y pos of tail

    x_head          db 0            ; stores x pos of head (first seg)
    y_head          db 0            ; stores y pos of head (first seg)
    x_arr           db 228 dup (?)  ; arr for storing the len of snake in axis x
    y_arr           db 228 dup (?)  ; arr for storing the len of snake in axis y
    tail            db 1            ; pointer that says where the tail of the snake is in both arrs (head,tail)

	x_rec			dw ?            ; used for retSqr
	y_rec 			dw ?            ; used for retSqr
	color 		    db ?			; color
	len 		    dw 16			; length of side
	height 		    dw 16			; height of side
	
    direction       db 1 ; the direction of the snake (it will start to the right)
	
	x_lines			equ 19                  ; num of columns in map
	y_lines 		equ 11                  ; num of lines in map
    
    snake_length    dw 2                    ; stores len of snake
    self_touch_flag db 0                    ; flag checking if snake touched himeself
    yr              dw ?                    ; y for printrec
    xr              dw ?                    ; x for printRec
    lenr            dw ?                   ; len for printrec
    heightr         dw ?                    ; height for printrec
    colorr          db ?                    ; color for printrec


; ---------- screens ----------
	map             db 'snakeMap.bmp',0     ; game map
    loseScr         db 'loseScr.bmp',0      ; game over screen
    startScr        db 'strScre.bmp',0      ; opening screen 
    instscr         db 'instscr.bmp',0      ; instructions screen
    acces           db 'accscr.bmp',0       ; accessories
    lbscr           db 'ldscr.bmp',0        ; leaderboard screen
    pauseScreen     db 'pause.bmp',0        ; pause screen
; ---------- bmp vars ----------
    filehandle      dw ? 
    currentFile     dw ? ; the current bmp file to dusplay
    Palette         db 256*4 dup (0)
    ScrLine         db 320 dup (0)
    ErrorMsg        db 'Error in open file$'
    picHigh	        dw  ? ; image height
    picWidth        dw  ? ; image width
    leftGap         dw ?  ; columns gap
    topGap          dw ?  ; rows gap (mult by 320)

; ---------- map vars ----------
    leftOutlineGap  equ 8   ; gap of the green outline in the map from the left
    topOutlineGap   equ 21   ; gap of the green outline in the map from the top
    side            equ 16  ; one side of the square in the map
    lightGreen      equ 32h ; light green in map
    darkGreen       equ 20h ; dark green in map
    
; ——————————— leaderBoard ———————————
    score           db 0            ; score temp per game
    HandleScores dw ?               ; scores.txt file handle
    scores db 4 dup (0)             ; keeps the top 4 scores
    scoresFile db 'scores.txt', 0 ; scores file

; ---------- xxxxx ----------
    mouse_x         dw ?        ; x pos of mouse
    mouse_y         dw ?        ; y pos of mouse
    pause_flag      db 0        ; flag checking of player wants to go to pause screen
    flagESC         db 0        ; flag checking of player wants to go to close program

; ---------- xxxxx ----------
    space_key       equ ' '     ; askii value
    Accs_key        equ 'a'     ; askii value
    inst_key        equ 'i'     ; askii value
    replay_key      equ 'r'     ; askii value
    back_key        equ 'b'     ; askii value
    ledBor_key      equ 'l'     ; askii value
    puase_key       equ 'p'     ; askii value
    esc_key         equ 1h      ; askii value

; ——————————— apple vars ———————————
    apple           db 'apple.bmp',0 ; apple bmp pic
    x_apple         db ?        ; first pos for x_apple
    y_apple         db ?        ; first pos for y_apple
    apple_pos       dw ?        ; pos for apple anding+oring
    clock           equ es:6ch  ; clock for random
    ; apple sprite
appleCh			db  00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
				db  00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01,00h, 00h, 00h, 00h, 00h, 00h
				db  00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01,04h,00h, 00h, 00h, 00h, 00h, 00h
				db  00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 01, 00h,00h, 00h, 00h, 00h, 00h, 00h
				db  00h, 00h, 00h, 00h, 00h, 04h, 04h, 04h,04h, 04h, 04h, 04h, 04h, 00h, 00h, 00h
				db  00h, 00h, 04h, 04h, 04h, 249, 249, 249, 249, 01, 01, 04h, 04h, 04h, 00h, 00h
				db  00h, 04h, 249, 249, 249, 249, 249, 249, 01, 249, 01, 01, 01, 04h, 04h, 00h
				db  00h, 04h, 249, 249, 249, 249, 249, 249, 249, 249, 249, 01, 01, 01, 04h, 00h
				db  00h, 04h, 249, 249, 249, 249, 249, 249, 249, 249, 249, 01, 01, 01,04h, 00h
				db  00h, 04h, 249, 249, 249, 249, 249, 249, 249, 249, 249, 01, 01, 01,04h, 00h
				db  00h, 04h, 249, 249, 249, 249, 249, 249, 249, 249, 249, 01, 01, 01,04h, 00h
				db  00h, 04h, 04h, 249, 249, 249, 249, 249, 249, 249, 01, 01, 01,04h,00h, 00h
				db  00h, 04h, 04h, 249, 249, 249, 249, 249, 249, 249, 01, 01, 01,04h,00h, 00h
				db  00h, 00h, 04h, 04h, 04h, 249, 249, 249, 01, 01, 01, 01, 01,04h,00h, 00h
				db  00h, 00h, 00h, 00h,04h, 04h, 249, 01, 01, 01, 01,04h,04h,04h,00h, 00h
				db  00h, 00h, 00h, 00h,00h,04h, 04h, 04h, 04h,04h,04h,00h,00h,00h, 00h, 00h
; apple mask
appleCh_mask	db  0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db  0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh,00, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db  0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh,00,00, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db  0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh,00, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
				db  0FFh, 0FFh, 0FFh, 0FFh, 0FFh,00,00,00,00,00,00, 00, 00, 0FFh, 0FFh, 0FFh
				db  0FFh, 0FFh,00,00,00,00,00,00,00,00,00,00,00,00, 0FFh, 0FFh
				db  0FFh,00,00,00,00,00,00,00,00,00,00,00,00,00,00, 0FFh
				db  0FFh,00,00,00,00,00,00,00,00,00,00,00,00,00,00, 0FFh
				db  0FFh,00,00,00,00,00,00,00,00,00,00,00,00,00,00, 0FFh
				db  0FFh,00,00,00,00,00,00,00,00,00,00,00,00,00,00, 0FFh
				db  0FFh,00,00,00,00,00,00,00,00,00,00,00,00,00,00, 0FFh
				db  0FFh,00,00,00,00,00,00,00,00,00,00,00,00,00, 0FFh, 0FFh
				db  0FFh,00,00,00,00,00,00,00,00,00,00,00,00,00, 0FFh, 0FFh
				db  0FFh, 0FFh,00,00,00,00,00,00,00,00,00,00,00,00, 0FFh, 0FFh
				db  0FFh, 0FFh, 0FFh, 0FFh,00,00,00,00,00,00,00,00,00,00, 0FFh, 0FFh
				db  0FFh, 0FFh, 0FFh, 0FFh, 0FFh,00,00,00,00,00,00, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh



;------- xxxx ------
    snakeColor db 0E7h          ; default snake color (light green)
    divisorTable db 100,10,1,0  ; table for random

    note         dw 4560        ; first freq for note
    sound1IsOn    db 0          ; note1 is playing flag
    sound2IsOn    db 0          ; note1 is playing flag
    sound3IsOn    db 0          ; note1 is playing flag

    mapColor      db 1          ; flag for checking maps
    RBackground   db ?          ; backgrond color red
    GBackground   db ?          ; backgrond color green
    BBackground   db ?          ; backgrond color blue
    RDarkSquare   db ?          ; dark sqaure color red
    GDarkSquare   db ?          ; dark sqaure color green
    BDarkSquare   db ?          ; dark sqaure color blue
    RLightSquare  db ?          ; light sqaure color red
    GLightSquare  db ?          ; light sqaure color green
    BLightSquare  db ?          ; light sqaure color blue
