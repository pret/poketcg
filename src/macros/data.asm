energy: MACRO
fg = 0
lw = 0
fp = 0
c_ = 0

	if _NARG > 1

	rept _NARG / 2

	if \1 == FIRE
fg = fg + \2 * $10
	endc
	if \1 == GRASS
fg = fg + \2
	endc
	if \1 == LIGHTNING
lw = lw + \2 * $10
	endc
	if \1 == WATER
lw = lw + \2
	endc
	if \1 == FIGHTING
fp = fp + \2 * $10
	endc
	if \1 == PSYCHIC
fp = fp + \2
	endc
	if \1 == COLORLESS
c_ = c_ + \2 * $10
	endc

	shift
	shift

	endr

	endc
	db fg, lw, fp, c_
ENDM

gfx: MACRO
	dw ($4000 * (BANK(\1) - BANK(CardGraphics)) + (\1 - $4000)) / 8
ENDM

tx: MACRO
	dw \1_
ENDM
