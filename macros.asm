RGB: MACRO
	dw (\3 << 10 | \2 << 5 | \1)
ENDM

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

note: MACRO
	db (\1 << 4) | (\2 - 1)
ENDM

rest: MACRO
	db \1 - 1
ENDM

Speed: MACRO
	db $d0, \1
ENDM

musicdx: MACRO
	db ($d << 4) | \1
ENDM

musicd7: MACRO
	db $d7
ENDM

musicd8: MACRO
	db $d8
ENDM

musicd9: MACRO
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

music_jp: MACRO
	db $e1
	dw \1
ENDM

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

musice5: MACRO
	db $e5, \1
ENDM

musice6: MACRO
	db $e6, \1
ENDM

musice7: MACRO
	db $e7, \1
ENDM

musice8: MACRO
	db $e8, \1
ENDM

musice9: MACRO
	db $e9, \1
ENDM

musicea: MACRO
	db $ea, \1
ENDM

musiceb: MACRO
	db $eb, \1
ENDM

musicec: MACRO
	db $ec, \1
ENDM

musiced: MACRO
	db $ed, \1
ENDM

music_end: MACRO
	db $ff
ENDM