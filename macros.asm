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

emptybank: MACRO
	rept $4000
	db $ff
	endr
ENDM

; notes
C_		EQU $1
C#		EQU $2
D_		EQU $3
D#		EQU $4
E_		EQU $5
F_		EQU $6
F#		EQU $7
G_		EQU $8
G#		EQU $9
A_		EQU $A
A#		EQU $B
B_		EQU $C

; instruments
bass   EQU $1
snare1 EQU $3 ; medium length
snare2 EQU $5 ; medium length
snare3 EQU $7 ; short
snare4 EQU $9 ; long
snare5 EQU $C ; long

note: MACRO
	db (\1 << 4) | (\2 - 1)
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

no_fade: MACRO
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

duty3: MACRO
	db $e7, \1
ENDM

musice8: MACRO
	db $e8, \1
ENDM

musice9: MACRO
	db $e9, \1
ENDM

vibrato_rate: MACRO
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