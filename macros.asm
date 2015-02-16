RGB: MACRO
	dw (\3 << 10 | \2 << 5 | \1)
ENDM

bank1call: MACRO
	rst $18
	dw \1
ENDM

farcall: MACRO
	rst $28
	db BANK(\1)
	dw \1
ENDM

; used when the specified bank does not match the bank of the specified function
; otherwise, farcall is preferred
farcallx: MACRO
	rst $28
	db \1
	dw \2
ENDM

emptybank: MACRO
	rept $4000
	db $ff
	endr
ENDM

text: MACRO
	dw ((\1 + ($4000 * (BANK(\1) - 1))) - (TextOffsets + ($4000 * (BANK(TextOffsets) - 1)))) & $ffff
	db ((\1 + ($4000 * (BANK(\1) - 1))) - (TextOffsets + ($4000 * (BANK(TextOffsets) - 1)))) >> 16
ENDM

; notes/instruments
C_: MACRO
	db $10 | (\1 - 1)
ENDM

C#: MACRO
	db $20 | (\1 - 1)
ENDM

D_: MACRO
	db $30 | (\1 - 1)
ENDM

D#: MACRO
	db $40 | (\1 - 1)
ENDM

E_: MACRO
	db $50 | (\1 - 1)
ENDM

F_: MACRO
	db $60 | (\1 - 1)
ENDM

F#: MACRO
	db $70 | (\1 - 1)
ENDM

G_: MACRO
	db $80 | (\1 - 1)
ENDM

G#: MACRO
	db $90 | (\1 - 1)
ENDM

A_: MACRO
	db $A0 | (\1 - 1)
ENDM

A#: MACRO
	db $B0 | (\1 - 1)
ENDM

B_: MACRO
	db $C0 | (\1 - 1)
ENDM

bass: MACRO
	db $10 | (\1 - 1)
ENDM

snare1: MACRO ; medium length
	db $30 | (\1 - 1)
ENDM

snare2: MACRO ; medium length
	db $50 | (\1 - 1)
ENDM

snare3: MACRO ; short
	db $70 | (\1 - 1)
ENDM

snare4: MACRO ; long
	db $90 | (\1 - 1)
ENDM

snare5: MACRO ; long
	db $C0 | (\1 - 1)
ENDM

rest: MACRO
	db \1 - 1
ENDM

speed: MACRO
	db $d0, \1
ENDM

octave: MACRO
	db ($d << 4) | \1
ENDM

inc_octave: MACRO
	db $d7
ENDM

dec_octave: MACRO
	db $d8
ENDM

tie: MACRO
	db $d9
ENDM

musicdc: MACRO
	db $dc, \1
ENDM

MainLoop: MACRO
	db $dd
ENDM

EndMainLoop: MACRO
	db $de
ENDM

Loop: MACRO
	db $df, \1
ENDM

EndLoop: MACRO
	db $e0
ENDM

; unused
;music_jp: MACRO
;	db $e1
;	dw \1
;ENDM

music_call: MACRO
	db $e2
	dw \1
ENDM

music_ret: MACRO
	db $e3
ENDM

musice4: MACRO
	db $e4, \1
ENDM

duty: MACRO
	db $e5, \1 << 6
ENDM

volume: MACRO
	db $e6, \1
ENDM

wave: MACRO
	db $e7, \1
ENDM

musice8: MACRO
	db $e8, \1
ENDM

musice9: MACRO
	db $e9, \1
ENDM

vibrato_type: MACRO
	db $ea, \1
ENDM

vibrato_delay: MACRO
	db $eb, \1
ENDM

; unused
;musicec: MACRO
;	db $ec, \1
;ENDM

; unused
;musiced: MACRO
;	db $ed, \1
;ENDM

music_end: MACRO
	db $ff
ENDM

sfx_0: MACRO
	db \1, \2
ENDM

sfx_1: MACRO
	db $10, \1
ENDM

sfx_2: MACRO
	db $20 | \1
ENDM

sfx_loop: MACRO
	db $30, \1
ENDM

sfx_endloop: MACRO
	db $40
ENDM

sfx_5: MACRO
	db $50, \1
ENDM

sfx_6: MACRO
	db $60, \1
ENDM

sfx_8: MACRO
	db $80, \1
ENDM

sfx_end: MACRO
	db $f0
ENDM
