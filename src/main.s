.include "globals.inc"

.import reset_handler
.import read_gamepads
.import ppu_set_palette
.import nmi_return
.import wait_for_nmi
.import prepare_game_sprites

.export main 

.segment "CODE"

.proc main_nmi
    bit PPUSTATUS
    lda #PPUMASK_ON | PPUMASK_NO_CLIP
    sta PPUMASK
    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    sta PPUMASK

    jmp nmi_return
.endproc

.proc main
    lda #0
    bit PPUSTATUS
    sta PPUCTRL
    sta PPUMASK

    jsr ppu_set_palette

    jsr prepare_game_sprites
    lda #PPUCTRL_NMI_ON
    sta PPUCTRL
loop:
    jsr wait_for_nmi
    inc game_counter

    jsr read_gamepads
    jsr prepare_game_sprites

    jmp loop
.endproc

.segment "CHR"
    .incbin "bg.chr"
    .incbin "sprites16.chr"
