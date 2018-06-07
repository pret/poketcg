lb: MACRO ; r, hi, lo
	ld \1, (\2) << 8 + ((\3) & $ff)
ENDM

ldtx: MACRO
if _NARG == 2
	ld \1, \2_
else
	ld \1, \2_ \3
endc
ENDM

bank1call: MACRO
	rst $18
	dw \1
ENDM

farcall: MACRO
	rst $28
if _NARG == 1
	db BANK(\1)
	dw \1
else
	db \1
	dw \2
endc
ENDM

; the rst $38 handler is a single ret instruction
; probably used for testing purposes during development
debug_ret EQUS "rst $38"
