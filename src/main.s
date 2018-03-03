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
    lda #.hibyte(OAM)
    sta OAMDMA
    lda #PPUMASK_ON | PPUMASK_NO_CLIP
    sta PPUMASK
    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    bit PPUSTATUS
    sta PPUCTRL

    jmp nmi_return
.endproc

.proc main
    jsr ppu_set_palette
    jsr prepare_game_sprites
    store16into #main_nmi, nmi_ptr
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
