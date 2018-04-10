const_def: MACRO
if _NARG > 0
const_value = \1
else
const_value = 0
endc
ENDM

const: MACRO
\1 EQU const_value
const_value = const_value + 1
ENDM

deck_const: MACRO
if const_value > 1
\1_ID EQU const_value + -2
endc
	const \1
ENDM
