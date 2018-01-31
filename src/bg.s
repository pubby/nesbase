.include "globals.inc"

.proc prep_scroll
    ; Now deal with tile updates.
    lda camera_x+1
    cmp drawn_x+1
    bne needsUpdating
    lda camera_x+0
    and #%11111000      ; Floor to multiple of 8.
    cmp drawn_x+0
    bne needsUpdating
    ror metatile_nt_lobyte      ; Set bit 7.
    rts
needsUpdating:
    bcc updateLeftSide


    ; Vertical update

    ; Load big metatile
    lax (ptr_temp), y
    ; Load small metatiles
    lda small_mt00, x
    tax
    lda tile00, x
    sta buffer, y
    lda tile01, x
    sta buffer, y


    ; Load big metatile
    lax (ptr_temp), y
    ; Load small metatiles
    lda small_mt01, x
    tax
    lda tile00, x
    sta buffer, y
    lda tile01, x
    sta buffer, y



    ; Horizontal update

    ldx #0
    lax (ptr_temp), x
    sta subroutine_temp

    ; Load small metatiles
    lda small_mt00, x
    tax
    lda tile00, x
    sta buffer, y
    lda tile10, x
    sta buffer, y

    ; Load big metatile
    ldx subroutine_temp
    lda small_mt10, x
    tax
    lda tile00, x
    sta buffer, y
    lda tile10, x
    sta buffer, y

    clc
    lda ptr_temp+0
    adc span+0
    sta ptr_temp+0
    lda ptr_temp+1
    adc span+1
    sta ptr_temp+1
    iny

; This subroutine updates all of the variables used in ppu_update_scrolling,
; excluding the attribute buffers which get set later on.
; This function uses draw_at_x as its input; set draw_at_x before calling.
; Clobbers A, Y. Sets X to the column number of the metatile.
setVars:
    ; Find metatile_column_ptr by adding an offest to the start of the 
    ; metatile array. The metatile array stores 32-pixels-wide columns in
    ; 16 bytes segments, and thus calculating the index involves dividing
    ; draw_at_x by two and then flooring it to a multiple of 16.
    lda draw_at_x+1
    lsr
    sta temp            ; Store the hibyte of the offset in 'temp'.
    lda draw_at_x+0
    and #%11100000
    ror                 ; Guaranteed to clear carry.
    sta temp2           ; Register A now holds the lobyte of the offset.
    adc level_ptr+0     ; Now do standard 16-bit addition with the level ptr.
    sta metatile_column_ptr+0
    lda temp
    adc level_ptr+1
    sta metatile_column_ptr+1
    lsr temp
    lda temp2
    and #%11100000
    ror                 ; Guaranteed to clear carry.
    adc #.lobyte(map_bitset)
    sta map_bitset_ptr+0
    lda temp
    adc #.hibyte(map_bitset)
    sta map_bitset_ptr+1

    ; Find nametable pointers.
    lda draw_at_x+0
    .repeat 3
        lsr
    .endrepeat
    sta metatile_nt_lobyte
    lsr
    sta temp
    lsr
    ora #$C0            ; Faster way of adding $C0.
    sta attr_buf_nt_lobyte

    lda temp
    and #%00000011
    tax
    lda bitset_masks, x
    sta map_bitset_mask+0
    asl
    sta map_bitset_mask+1

    ; Set X to be a value from [0,3] representing the column of the metatile.
    ; X will be a return value of this subroutine, so preserve X until rts!!
    lda metatile_nt_lobyte
    and #%00000011
    tax

    lda set_scroll_buf_subroutines_lo,x
    sta metatile_subroutine+0
    lda set_scroll_buf_subroutines_hi,x
    sta metatile_subroutine+1
    rts


.endproc

