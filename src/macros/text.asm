text EQUS "db TX_HALFWIDTH, "
line EQUS "db TX_LINE, "
done EQUS "db TX_END"

half2full EQUS "db TX_HALF2FULL"

katakana: MACRO
	db TX_KATAKANA
	for i, STRLEN(\1)
		db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
	endr
ENDM

hiragana: MACRO
	db TX_HIRAGANA
	for i, STRLEN(\1)
		db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
	endr
ENDM

textfw0: MACRO
	rept _NARG
if STRSUB(\1, 1, 1) == "<" && STRLEN(\1) > 1
	db \1
else
	for i, STRLEN(\1)
		db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
	endr
endc
	shift
	endr
ENDM

textfw1: MACRO
	rept _NARG
if STRSUB(\1, 1, 1) == "<" && STRLEN(\1) > 1
	db \1
else
	for i, STRLEN(\1)
		if (STRSUB(\1, i + 1, 1)) == " "
			db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
		else
			db TX_FULLWIDTH1, STRCAT("FW1_", STRSUB(\1, i + 1, 1))
		endc
	endr
endc
	shift
	endr
ENDM

textfw2: MACRO
	rept _NARG
if STRSUB(\1, 1, 1) == "<" && STRLEN(\1) > 1
	db \1
else
	for i, STRLEN(\1)
		if (STRSUB(\1, i + 1, 1)) == " "
			db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
		else
			db TX_FULLWIDTH2, STRCAT("FW2_", STRSUB(\1, i + 1, 1))
		endc
	endr
endc
	shift
	endr
ENDM

textfw3: MACRO
	rept _NARG
if STRSUB(\1, 1, 1) == "<" && STRLEN(\1) > 1
	db \1
else
	for i, STRLEN(\1)
		if (STRSUB(\1, i + 1, 1)) == " "
			db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
		else
			db TX_FULLWIDTH3, STRCAT("FW3_", STRSUB(\1, i + 1, 1))
		endc
	endr
endc
	shift
	endr
ENDM

textfw4: MACRO
	rept _NARG
if STRSUB(\1, 1, 1) == "<" && STRLEN(\1) > 1
	db \1
else
	for i, STRLEN(\1)
		if (STRSUB(\1, i + 1, 1)) == " "
			db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
		else
			db TX_FULLWIDTH4, STRCAT("FW4_", STRSUB(\1, i + 1, 1))
		endc
	endr
endc
	shift
	endr
ENDM

ldfw3: MACRO
	ld \1, (TX_FULLWIDTH3 << 8) | STRCAT("FW3_", \2)
ENDM
