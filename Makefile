#!/usr/bin/make -f
#
# Makefile for NES game
# Copyright 2011-2014 Damian Yerrick
# (Edited by Pubby)
#
# Copying and distribution of this file, with or without
# modification, are permitted in any medium without royalty
# provided the copyright notice and this notice are preserved.
# This file is offered as-is, without any warranty.
#

# These are used in the title of the NES program
title := game
version := 0.01

# Space-separated list of assembly language files that make up the
# PRG ROM.  If it gets too long for one line, you can add a backslash
# (the \ character) at the end of the line and continue on the next.
objlist := ines init nmi globals main sprites palette gamepad rng

AS65 := ca65
LD65 := ld65
CFLAGS65 := --cpu 6502X
objdir := obj/nes
srcdir := src
imgdir := tilesets

DEBUG_EMU := wine ./fceux.exe
EMU := fceux

headers := $(srcdir)/nes.inc $(srcdir)/globals.inc $(srcdir)/macros.inc

.PHONY: all run debug clean

all: $(title).nes

run: $(title).nes
	$(EMU) $<

debug: $(title).nes
	$(DEBUG_EMU) $<

clean:
	-rm $(objdir)/*.o $(objdir)/*.s $(objdir)/*.chr $(objdir)/*.cchr

# Rules for PRG ROM

objlist := $(foreach o,$(objlist),$(objdir)/$(o).o)

map.txt $(title).nes: config.cfg $(objlist)
	$(LD65) -o $(title).nes -m map.txt -C $^

$(objdir)/%.o: $(srcdir)/%.s $(headers)
	$(AS65) $(CFLAGS65) $< -o $@

$(objdir)/%.o: $(objdir)/%.s
	$(AS65) $(CFLAGS65) $< -o $@

# Files that depend on .incbin'd files
$(objdir)/main.o: $(srcdir)/bg.chr $(srcdir)/sprites16.chr

# CHR

$(srcdir)/%.chr: $(imgdir)/%.png
	tools/pilbmp2nes.py $< $@

$(srcdir)/%16.chr: $(imgdir)/%.png
	tools/pilbmp2nes.py -H 16 $< $@

