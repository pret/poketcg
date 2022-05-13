DEF text EQUS "db TX_HALFWIDTH, "
DEF line EQUS "db TX_LINE, "
DEF done EQUS "db TX_END"

DEF half2full EQUS "db TX_HALF2FULL"

MACRO katakana
	db TX_KATAKANA
	for i, STRLEN(\1)
		db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
	endr
ENDM

MACRO hiragana
	db TX_HIRAGANA
	for i, STRLEN(\1)
		db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
	endr
ENDM

MACRO textfw0
	rept _NARG
		if STRCMP(STRSUB(\1, 1, 1), "<") == 0 && STRLEN(\1) > 1
			db \1
		else
			for i, STRLEN(\1)
				db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
			endr
		endc
		shift
	endr
ENDM

MACRO textfw1
	rept _NARG
		if STRCMP(STRSUB(\1, 1, 1), "<") == 0 && STRLEN(\1) > 1
			db \1
		else
			for i, STRLEN(\1)
				if STRCMP(STRSUB(\1, i + 1, 1), " ") == 0
					db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
				else
					db TX_FULLWIDTH1, STRCAT("FW1_", STRSUB(\1, i + 1, 1))
				endc
			endr
		endc
		shift
	endr
ENDM

MACRO textfw2
	rept _NARG
		if STRCMP(STRSUB(\1, 1, 1), "<") == 0 && STRLEN(\1) > 1
			db \1
		else
			for i, STRLEN(\1)
				if STRCMP(STRSUB(\1, i + 1, 1), " ") == 0
					db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
				else
					db TX_FULLWIDTH2, STRCAT("FW2_", STRSUB(\1, i + 1, 1))
				endc
			endr
		endc
		shift
	endr
ENDM

MACRO textfw3
	rept _NARG
		if STRCMP(STRSUB(\1, 1, 1), "<") == 0 && STRLEN(\1) > 1
			db \1
		else
			for i, STRLEN(\1)
				if STRCMP(STRSUB(\1, i + 1, 1), " ") == 0
					db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
				else
					db TX_FULLWIDTH3, STRCAT("FW3_", STRSUB(\1, i + 1, 1))
				endc
			endr
		endc
		shift
	endr
ENDM

MACRO textfw4
	rept _NARG
		if STRCMP(STRSUB(\1, 1, 1), "<") == 0 && STRLEN(\1) > 1
			db \1
		else
			for i, STRLEN(\1)
				if STRCMP(STRSUB(\1, i + 1, 1), " ") == 0
					db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
				else
					db TX_FULLWIDTH4, STRCAT("FW4_", STRSUB(\1, i + 1, 1))
				endc
			endr
		endc
		shift
	endr
ENDM

MACRO ldfw3
	ld \1, (TX_FULLWIDTH3 << 8) | STRCAT("FW3_", \2)
ENDM
