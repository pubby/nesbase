.ifndef GLOBAL_INC
.define GLOBAL_INC

.include "nes.inc"
.include "macros.inc"

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

; TABLES ;;;;;;;;;;;;;;;;;;;;;;;;;
.global asl4_table
.global powers_of_2_table

; ROUTINES ;;;;;;;;;;;;;;;;;;;;;;;

; init.s
.global reset_handler

; gamepad.s
.global read_gamepads

; palette.s
.global ppu_set_palette
.global prep_palette
.global ppu_copy_palette_buffer


; nmi.s
.global nmi_handler
.global irq_handler
.global nmi_return
.global wait_for_nmi

; sprites.s
.global prepare_blank_sprites
.global prepare_game_sprites
.global clear_remaining_sprites

; main.s
.global main

; rng.s
.global random_byte


.endif
