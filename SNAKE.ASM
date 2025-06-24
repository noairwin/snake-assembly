;SNAKE.ASM (main)

include macros.asm          ; import macros file

jumps
IDEAL
MODEL small
STACK 100h

DATASEG
include 'dataseg.asm'       ; import dataseg file

CODESEG
include 'procs.asm'         ; import procs file


start:
    mov ax, @data
    mov ds, ax
    mov [currentFile], offset scoresFile    ; gets the beginning of the score.txt file
    call openFile                           ; opens score.txt file
    mov ax, [fileHandle]                    ; mov filehandle into scorehandle (filehandle = score.txt filehandle)
    mov [handleScores], ax                  ; puts score filehandle
    call readFile                           ; reads scores saved in score.txt file

    callGraphic             ; graphic mode
    include 'start.asm'     ; import start file
    include 'game.asm'      ; import game file 
    include 'loseScr.asm'   ; import loseScreen file


exit:   
    call seekToStart        ; pointer is back to the first index of scores
    call writeToFile        ; writing all scores in scores.txt file
    mov ax, [HandleScores]  ; mov the filehandle of score.txt into ax
    mov [fileHandle], ax    ; mov the score.txt filehandle into ax 
    call closeFile          ; closing scores.txt file   
    retText                 ; text mode
    mov ax, 4c00h
    int 21h                 ; closing program

END start
