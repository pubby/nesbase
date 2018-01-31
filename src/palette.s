.include "globals.inc"

.export ppu_set_palette
.export prep_palette
.export ppu_copy_palette_buffer

.segment "RODATA"
palette:
    .byt $0F,$11,$23,$35
    .byt $0F,$17,$29,$3B
    .byt $0F,$21,$24,$28
    .byt $0F,$21,$24,$28

    .byt $0F,$14,$25,$3a
    .byt $0F,$03,$21,$20
    .byt $0F,$03,$19,$38
    .byt $0F,$11,$23,$35

.segment "CODE"

.proc ppu_set_palette
    storePPUADDR #$3F00
    ldx #0
:
    lda palette, x
    sta PPUDATA
    inx
    cpx #32
    bne :-
    rts
.endproc

.proc prep_palette
    ldx #31
@loop:
    lda palette, x
    sta palette_buffer, x
    dex
    bpl @loop
    rts
.endproc

.proc ppu_copy_palette_buffer
    storePPUADDR #$3F00
    .repeat 8, i
        .if i = 4
            lda palette_buffer_bg
        .endif
        sta PPUDATA
        lda palette_buffer+3*i+0
        sta PPUDATA
        lda palette_buffer+3*i+1
        sta PPUDATA
        lda palette_buffer+3*i+2
        sta PPUDATA
    .endrepeat
    rts
.endproc

