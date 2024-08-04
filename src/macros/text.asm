DEF text EQUS "db TX_HALFWIDTH, "
DEF line EQUS "db TX_LINE, "
DEF done EQUS "db TX_END"

DEF half2full EQUS "db TX_HALF2FULL"

MACRO _textfw
	REPT _NARG
		IF STRLEN(\1) > 0
			IF !STRCMP(STRSUB(\1, 1, 1), "<") && STRLEN(\1) > 1
				db \1
			ELSE
				FOR i, 1, STRLEN(\1) + 1
					REDEF char EQUS STRSUB(\1, i, 1)
					IF INCHARMAP("FW{x:TX_KATAKANA}_{char}")
						IF cur_set != TX_KATAKANA
							DEF cur_set = TX_KATAKANA
							db cur_set
						ENDC
						db "FW{x:TX_KATAKANA}_{char}"
					ELIF INCHARMAP("FW{x:TX_HIRAGANA}_{char}")
						IF cur_set != TX_HIRAGANA
							DEF cur_set = TX_HIRAGANA
							db cur_set
						ENDC
						db "FW{x:TX_HIRAGANA}_{char}"
					ELIF INCHARMAP("FW0_{char}")
						db "FW0_{char}"
					ELIF INCHARMAP("FW1_{char}")
						db TX_FULLWIDTH1, "FW1_{char}"
					ELIF INCHARMAP("FW2_{char}")
						db TX_FULLWIDTH2, "FW2_{char}"
					ELIF INCHARMAP("FW3_{char}")
						db TX_FULLWIDTH3, "FW3_{char}"
					ELIF INCHARMAP("FW4_{char}")
						db TX_FULLWIDTH4, "FW4_{char}"
					ELSE
						FAIL "Unmapped fullwidth character: {char}"
					ENDC
				ENDR
			ENDC
		ENDC
		SHIFT
	ENDR
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
