text   EQUS "db TX_HALFWIDTH, "
line   EQUS "db TX_LINE, "
done   EQUS "db TX_END"

half2full EQUS "db TX_HALF2FULL"

katakana: MACRO
	db TX_KATAKANA
	rept _NARG
	db STRCAT("FW0_", \1)
	shift
	endr
ENDM

hiragana: MACRO
	db TX_HIRAGANA
	rept _NARG
	db STRCAT("FW0_", \1)
	shift
	endr
ENDM

textfw0: MACRO
	rept _NARG
	db STRCAT("FW0_", \1)
	shift
	endr
ENDM

textfw1: MACRO
	rept _NARG
	db TX_FULLWIDTH1, STRCAT("FW1_", \1)
	shift
	endr
ENDM

textfw2: MACRO
	rept _NARG
	db TX_FULLWIDTH2, STRCAT("FW2_", \1)
	shift
	endr
ENDM

textfw3: MACRO
	rept _NARG
	db TX_FULLWIDTH3, STRCAT("FW3_", \1)
	shift
	endr
ENDM

textfw4: MACRO
	rept _NARG
	db TX_FULLWIDTH2, STRCAT("FW4_", \1)
	shift
	endr
ENDM
