MACRO const_def
	IF _NARG > 0
		DEF const_value = \1
	ELSE
		DEF const_value = 0
	ENDC
ENDM

MACRO const
	DEF \1 EQU const_value
	DEF const_value = const_value + 1
ENDM

MACRO event_def
	db \1
	db \2
ENDM
