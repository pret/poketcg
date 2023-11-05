DEF text EQUS "db TX_HALFWIDTH, "
DEF line EQUS "db TX_LINE, "
DEF done EQUS "db TX_END"

DEF half2full EQUS "db TX_HALF2FULL"

MACRO _textfw
	PUSHO
	OPT Wno-unmapped-char
	REPT _NARG
		IF STRLEN(\1) > 0
			IF STRCMP(STRSUB(\1, 1, 1), "<") == 0 && STRLEN(\1) > 1
				db \1
			ELSE
				FOR i, STRLEN(\1)
					IF CHARLEN(STRCAT("FW{x:TX_KATAKANA}_", STRSUB(\1, i + 1, 1))) == 1
						IF cur_set != TX_KATAKANA
							DEF cur_set = TX_KATAKANA
							db cur_set
						ENDC
						db STRCAT("FW{x:TX_KATAKANA}_", STRSUB(\1, i + 1, 1))
					ELIF CHARLEN(STRCAT("FW{x:TX_HIRAGANA}_", STRSUB(\1, i + 1, 1))) == 1
						IF cur_set != TX_HIRAGANA
							DEF cur_set = TX_HIRAGANA
							db cur_set
						ENDC
						db STRCAT("FW{x:TX_HIRAGANA}_", STRSUB(\1, i + 1, 1))
					ELIF CHARLEN(STRCAT("FW0_", STRSUB(\1, i + 1, 1))) == 1
						db STRCAT("FW0_", STRSUB(\1, i + 1, 1))
					ELIF CHARLEN(STRCAT("FW1_", STRSUB(\1, i + 1, 1))) == 1
						db TX_FULLWIDTH1, STRCAT("FW1_", STRSUB(\1, i + 1, 1))
					ELIF CHARLEN(STRCAT("FW2_", STRSUB(\1, i + 1, 1))) == 1
						db TX_FULLWIDTH2, STRCAT("FW2_", STRSUB(\1, i + 1, 1))
					ELIF CHARLEN(STRCAT("FW3_", STRSUB(\1, i + 1, 1))) == 1
						db TX_FULLWIDTH3, STRCAT("FW3_", STRSUB(\1, i + 1, 1))
					ELIF CHARLEN(STRCAT("FW4_", STRSUB(\1, i + 1, 1))) == 1
						db TX_FULLWIDTH4, STRCAT("FW4_", STRSUB(\1, i + 1, 1))
					ELSE
						FAIL STRCAT("Unmapped fullwidth character: ", STRSUB(\1, i + 1, 1))
					ENDC
				ENDR
			ENDC
		ENDC
		SHIFT
	ENDR
	POPO
ENDM

MACRO textfw
	DEF cur_set = TX_KATAKANA
	_textfw \#
ENDM

MACRO linefw
	db TX_LINE
	_textfw \#
ENDM

MACRO katakana
	DEF cur_set = TX_KATAKANA
	db TX_KATAKANA
	_textfw \#
ENDM

MACRO hiragana
	DEF cur_set = TX_HIRAGANA
	db TX_HIRAGANA
	_textfw \#
ENDM
