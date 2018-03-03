.include "globals.inc"

.segment "CODE"
; Init code.
; (See http://wiki.nesdev.com/w/index.php/Init_code )
.proc reset_handler
    ; Ignore IRQs.
    sei

    ; Disable NMI and rendering.
    lda #$00
    sta PPUCTRL
    sta PPUMASK

    ; Disable DMC IRQ.
    sta $4010

    ; Read the status registers to handle stray NMIs and DMC IRQs across
    ; resets.
    lda PPUSTATUS
    lda SNDCHN

    ; Disable APU frame counter IRQ.
    ; (See http://wiki.nesdev.com/w/index.php/APU_Frame_Counter )
    lda #%01000000
    sta $4017

    ; Disable DMC but initialize the other channels.
    lda #$0F
    sta SNDCHN
    
    ; Turn off decimal mode, just in case the game gets run on wonky hardware.
    cld

    ; Set the stack pointer.
    ldx #$FF
    txs

    ; Now wait two frames until the PPU stabilizes.
    ; Can't use NMI yet, so we'll spin on bit 7 of PPUSTATUS to determine
    ; when those frames pass.
waitFrame1:
    bit PPUSTATUS
    bpl waitFrame1

    lda #0
    ldx #0
:
.repeat 8, i
    sta i*256, x
.endrepeat
    inx
    bne :-

waitFrame2:
    bit PPUSTATUS
    bpl waitFrame2

    ; Init RNG
    lda #$82
    sta rng_state+0
    lda #$39
    sta rng_state+1

    ; Detect TV type

    store16into #nmi_return, nmi_ptr
    lda #PPUCTRL_NMI_ON
    bit PPUSTATUS
    sta PPUCTRL

    ldx #0
    ldy #0
    jsr wait_for_nmi
    lda nmi_counter
wait:
    ; Each iteration takes 11 cycles.
    ; NTSC NES: 29780 cycles or 2707 = $A93 iterations
    ; PAL NES:  33247 cycles or 3022 = $BCE iterations
    ; Dendy:    35464 cycles or 3224 = $C98 iterations
    ; so we can divide by $100 (rounding down), subtract ten,
    ; and end up with 0=ntsc, 1=pal, 2=dendy, 3=unknown
    inx
    bne_aligned :+
    iny
:
    cmp nmi_counter
    beq_aligned wait
    tya
    sec
    sbc #10
    cmp #3
    bcc notAbove3
    lda #3
notAbove3:
    sta tv_type

    ; Ok! Everything is initialized and we'll jump to 'main' at the start
    ; of vblank.
    jsr wait_for_nmi
    lda #0
    bit PPUSTATUS
    sta PPUCTRL
    jmp main
.endproc
