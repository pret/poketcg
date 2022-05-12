MACRO const_def
	if _NARG > 0
		DEF const_value = \1
	else
		DEF const_value = 0
	endc
ENDM

MACRO const
	DEF \1 EQU const_value
	DEF const_value = const_value + 1
ENDM

MACRO event_def
	db \1
	db \2
ENDM
