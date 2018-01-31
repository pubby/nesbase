.include "globals.inc"

.export nmi_handler
.export nmi_return
.export irq_handler
.export wait_for_nmi

.segment "CODE"
.align 16
nmi_handler:
    pha
    stx nmi_x
    sty nmi_y
    jmp (nmi_ptr)
nmi_return:
    inc nmi_counter
    ldx nmi_x
    ldy nmi_y
    pla
irq_handler:
    rti

.proc wait_for_nmi
    ; Wait for NMI
    lda nmi_counter
:
    cmp nmi_counter
    beq_aligned :-
    rts
.endproc
