dn: MACRO
	db \1 << 4 | \2
ENDM

dbw: MACRO
	db \1
	dw \2
ENDM

dwb: MACRO
	dw \1
	db \2
ENDM

dx: MACRO
x = 8 * ((\1) - 1)
	rept \1
	db ((\2) >> x) & $ff
x = x + -8
	endr
	ENDM

dt: MACRO ; three-byte (big-endian)
	dx 3, \1
	ENDM

dd: MACRO ; four-byte (big-endian)
	dx 4, \1
	ENDM

bigdw: MACRO ; big-endian word
	dx 2, \1
	ENDM

sgb: MACRO
	db \1 * 8 + \2 ; sgb_command * 8 + length
ENDM

rgb: MACRO
	dw (\3 << 10 | \2 << 5 | \1)
ENDM

; macros used in data/cards.asm, but might be useful elsewhere eventually

energy: MACRO
en = 0
if _NARG > 1
	rept _NARG / 2
x = 4 - 8 * (\1 % 2)
en = en + \2 << ((\1 * 4) + x)
	shift
	shift
	endr
	rept NUM_TYPES / 2
	db LOW(en)
en = en >> 8
	endr
else
	db 0, 0, 0, 0
endc
ENDM

gfx: MACRO
	dw ($4000 * (BANK(\1) - BANK(CardGraphics)) + (\1 - $4000)) / 8
ENDM

tx: MACRO
	dw \1_
ENDM
