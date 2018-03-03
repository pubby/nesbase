.include "globals.inc"

.segment "CODE"

.proc prepare_blank_sprites
    ldx #0
    jmp clear_remaining_sprites
.endproc

.proc prepare_game_sprites
    ldx #0
    jmp clear_remaining_sprites
.endproc

.proc clear_remaining_sprites
    lda #$FF
clearOAMLoop:
    sta OAM_Y, x
    axs #.lobyte(-4)
    bne clearOAMLoop    ; OAM is 256 bytes. Overflow signifies completion.
    rts
.endproc


