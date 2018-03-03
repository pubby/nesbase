.include "globals.inc"

.segment "CODE"
; Sets button flags of 'buttons_held' and 'buttons_pressed'.
; Clobbers A, X, Y.
; 21+199+10+10+6 = 246 cycles (not counting JSR)
.proc read_gamepads
    ; 3+2+3+4+2+4+3 cycles = 21 cycles
    ldx p1_buttons_held
    ldy #1
    sty p1_buttons_held
    sty $4016
    dey
    sty $4016
    ldy p2_buttons_held
readControllerLoop:
    ; (4+2+5+4+2+5+3)*8-1 = 199 cycles
    lda $4017
    lsr
    rol p2_buttons_held
    lda $4016
    lsr
    rol p1_buttons_held
    bcc readControllerLoop

    ; 2+2+3+3 = 10 cycles
    txa
    eor #$FF
    and p1_buttons_held
    sta p1_buttons_pressed

    ; 2+2+3+3 = 10 cycles
    tya
    eor #$FF
    and p2_buttons_held
    sta p2_buttons_pressed

    ; 6 cycles
    rts
.endproc


