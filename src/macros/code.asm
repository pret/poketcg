INCROM: MACRO
INCBIN "baserom.gbc", \1, \2 - \1
ENDM

const_def: MACRO
if _NARG > 0
const_value = \1
else
const_value = 0
endc
ENDM

const: MACRO
\1 EQU const_value
const_value = const_value + 1
ENDM

lb: MACRO ; r, hi, lo
	ld \1, (\2) << 8 + ((\3) & $ff)
ENDM

ldtx: MACRO
	ld \1, \2_
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

textpointer: MACRO
	dw ((\1 + ($4000 * (BANK(\1) - 1))) - (TextOffsets + ($4000 * (BANK(TextOffsets) - 1)))) & $ffff
	db ((\1 + ($4000 * (BANK(\1) - 1))) - (TextOffsets + ($4000 * (BANK(TextOffsets) - 1)))) >> 16
	const \1_
GLOBAL \1_
ENDM
