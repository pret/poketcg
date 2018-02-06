INCROM: MACRO
INCBIN "baserom.gbc", \1, \2 - \1
ENDM

const_def: MACRO
IF _NARG > 0
const_value = \1
ELSE
const_value = 0
ENDC
ENDM

const: MACRO
\1 EQU const_value
const_value = const_value + 1
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

lb: MACRO ; r, hi, lo
	ld \1, (\2) << 8 + ((\3) & $ff)
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

rgb: MACRO
	dw (\3 << 10 | \2 << 5 | \1)
ENDM

textpointer: MACRO
	dw ((\1 + ($4000 * (BANK(\1) - 1))) - (TextOffsets + ($4000 * (BANK(TextOffsets) - 1)))) & $ffff
	db ((\1 + ($4000 * (BANK(\1) - 1))) - (TextOffsets + ($4000 * (BANK(TextOffsets) - 1)))) >> 16
	const \1_
GLOBAL \1_
ENDM

text_hl: MACRO
	ld hl, \1_
ENDM

text_de: MACRO
	ld de, \1_
ENDM

sgb: MACRO
	db \1 * 8 + \2 ; sgb_command * 8 + length
ENDM

run_script: MACRO
	db \1_index
ENDM
