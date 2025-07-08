DEF text EQUS "db TX_HALFWIDTH, "
DEF line EQUS "db TX_LINE, "
DEF done EQUS "db TX_END"

DEF half2full EQUS "db TX_HALF2FULL"

MACRO get_charset
	PUSHC katakana
	IF INCHARMAP(\1)
		DEF charset = TX_KATAKANA
	ELSE
		SETCHARMAP hiragana
		IF INCHARMAP(\1)
			DEF charset = TX_HIRAGANA
		ELSE
			DEF charset = 0
		ENDC
	ENDC
	POPC
ENDM

MACRO _textfw
	PUSHC fullwidth
	REPT _NARG
		FOR i, CHARLEN(\1)
			REDEF char EQUS STRCHAR(\1, i)
			get_charset "{char}"
			IF charset != 0 && charset != cur_set
				DEF cur_set = charset
				db charset
			ENDC
			db "{char}"
		ENDR
		SHIFT
	ENDR
	POPC
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

MACRO dwfw
	PUSHC fullwidth
	IF CHARSIZE(\1) > 1
		dw CHARVAL(\1, 0) << 8 + CHARVAL(\1, 1)
	ELSE
		dw \1
	ENDC
	POPC
ENDM

MACRO ldfw
	PUSHC fullwidth
	IF CHARSIZE(\2) > 1
		ld \1, CHARVAL(\2, 0) << 8 + CHARVAL(\2, 1)
	ELSE
		ld \1, \2
	ENDC
	POPC
ENDM
