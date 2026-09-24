MACRO? const_def
	IF _NARG > 0
		DEF const_value = \1
	ELSE
		DEF const_value = 0
	ENDC
ENDM

MACRO? const
	DEF \1 EQU const_value
	DEF const_value += 1
ENDM

MACRO? const_skip
	IF _NARG > 0
		DEF const_value += \1
	ELSE
		DEF const_value += 1
	ENDC
ENDM

MACRO? event_def
	db \1
	db \2
ENDM

MACRO? rsunion
	IF DEF(rsunion_level)
		DEF rsunion_level += 1
	ELSE
		DEF rsunion_level = 1
	ENDC
	DEF _rsunion{d:rsunion_level}_start = _RS
ENDM

MACRO? rsnextu
	RSSET _rsunion{d:rsunion_level}_start
ENDM

MACRO? endrsunion
	PURGE _rsunion{d:rsunion_level}_start
	DEF rsunion_level -= 1
	IF !rsunion_level
		PURGE rsunion_level
	ENDC
ENDM
