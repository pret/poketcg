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
	db $a0 | (\1 - 1)
ENDM

A#: MACRO
	db $b0 | (\1 - 1)
ENDM

B_: MACRO
	db $c0 | (\1 - 1)
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
	db $c0 | (\1 - 1)
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

stereo_panning: MACRO
	db $dc, (\1 << 4) | \2
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

frequency_offset: MACRO
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

cutoff: MACRO
	db $e8, \1
ENDM

echo: MACRO
	db $e9, \1
ENDM

vibrato_type: MACRO
	db $ea, \1
ENDM

vibrato_delay: MACRO
	db $eb, \1
ENDM

; unused
;pitch_offset: MACRO
;	db $ec, \1
;ENDM

; unused
;adjust_pitch_offset: MACRO
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
