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

flag_def: MACRO
\1 EQU const_value
const_value = const_value + 1
db \2
db \3
ENDM
