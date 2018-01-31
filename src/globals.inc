.ifndef GLOBAL_INC
.define GLOBAL_INC

.include "nes.inc"
.include "macros.inc"

OAM_Y = $0200
OAM_P = $0201
OAM_A = $0202
OAM_X = $0203

.globalzp debug
.globalzp nmi_counter
.globalzp nmi_x
.globalzp nmi_y
.globalzp nmi_temp
.globalzp nmi_ptr

.globalzp subroutine_temp
.globalzp ptr_temp
.globalzp game_counter
.globalzp rng_state

.globalzp p1_buttons_held
.globalzp p1_buttons_pressed
.globalzp p2_buttons_held
.globalzp p2_buttons_pressed

.globalzp palette_ptr
.globalzp palette_buffer
.globalzp palette_buffer_bg

; BSS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.global tv_type

; tables
.global asl4_table
.global powers_of_2_table

.endif
