.include "globals.inc"

.segment "ZEROPAGE"

debug: .res 1
nmi_counter: .res 1
nmi_x: .res 1
nmi_y: .res 1
nmi_temp: .res 2
nmi_ptr: .res 2

subroutine_temp: .res 1
ptr_temp: .res 2
game_counter: .res 1
rng_state: .res 2

p1_buttons_held: .res 1
p1_buttons_pressed: .res 1
p2_buttons_held: .res 1
p2_buttons_pressed: .res 1

palette_buffer: .res 24
palette_buffer_bg: .res 1

.segment "BSS" ; RAM

tv_type: .res 1

.segment "RODATA"

asl4_table:
.repeat 16, i
    .byt i << 4
.endrepeat

powers_of_2_table:
.repeat 8, i
    .byt .lobyte(1 << i)
.endrepeat

