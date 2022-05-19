MACRO C_
	db $10 | (\1 - 1)
ENDM

MACRO C#
	db $20 | (\1 - 1)
ENDM

MACRO D_
	db $30 | (\1 - 1)
ENDM

MACRO D#
	db $40 | (\1 - 1)
ENDM

MACRO E_
	db $50 | (\1 - 1)
ENDM

MACRO F_
	db $60 | (\1 - 1)
ENDM

MACRO F#
	db $70 | (\1 - 1)
ENDM

MACRO G_
	db $80 | (\1 - 1)
ENDM

MACRO G#
	db $90 | (\1 - 1)
ENDM

MACRO A_
	db $a0 | (\1 - 1)
ENDM

MACRO A#
	db $b0 | (\1 - 1)
ENDM

MACRO B_
	db $c0 | (\1 - 1)
ENDM

MACRO bass
	db $10 | (\1 - 1)
ENDM

MACRO snare1 ; medium length
	db $30 | (\1 - 1)
ENDM

MACRO snare2 ; medium length
	db $50 | (\1 - 1)
ENDM

MACRO snare3 ; short
	db $70 | (\1 - 1)
ENDM

MACRO snare4 ; long
	db $90 | (\1 - 1)
ENDM

MACRO snare5 ; long
	db $c0 | (\1 - 1)
ENDM

MACRO rest
	db \1 - 1
ENDM

MACRO speed
	db $d0, \1
ENDM

MACRO octave
	db ($d << 4) | \1
ENDM

MACRO inc_octave
	db $d7
ENDM

MACRO dec_octave
	db $d8
ENDM

MACRO tie
	db $d9
ENDM

MACRO stereo_panning
	db $dc, (\1 << 4) | \2
ENDM

MACRO MainLoop
	db $dd
ENDM

MACRO EndMainLoop
	db $de
ENDM

MACRO Loop
	db $df, \1
ENDM

MACRO EndLoop
	db $e0
ENDM

; unused
;MACRO music_jp
;	db $e1
;	dw \1
;ENDM

MACRO music_call
	db $e2
	dw \1
ENDM

MACRO music_ret
	db $e3
ENDM

MACRO frequency_offset
	db $e4, \1
ENDM

MACRO duty
	db $e5, \1 << 6
ENDM

MACRO volume
	db $e6, \1
ENDM

MACRO wave
	db $e7, \1
ENDM

MACRO cutoff
	db $e8, \1
ENDM

MACRO echo
	db $e9, \1
ENDM

MACRO vibrato_type
	db $ea, \1
ENDM

MACRO vibrato_delay
	db $eb, \1
ENDM

; unused
;MACRO pitch_offset
;	db $ec, \1
;ENDM

; unused
;MACRO adjust_pitch_offset
;	db $ed, \1
;ENDM

MACRO music_end
	db $ff
ENDM

MACRO sfx_0
	db \1, \2
ENDM

MACRO sfx_1
	db $10, \1
ENDM

MACRO sfx_2
	db $20 | \1
ENDM

MACRO sfx_loop
	db $30, \1
ENDM

MACRO sfx_endloop
	db $40
ENDM

MACRO sfx_5
	db $50, \1
ENDM

MACRO sfx_6
	db $60, \1
ENDM

MACRO sfx_8
	db $80, \1
ENDM

MACRO sfx_end
	db $f0
ENDM
