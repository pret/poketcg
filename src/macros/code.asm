lb: MACRO ; r, hi, lo
	ld \1, (\2) << 8 + ((\3) & $ff)
ENDM

ldtx: MACRO
if _NARG == 2
	ld \1, \2_
else
	ld \1, \2_ \3
endc
ENDM

bank1call: MACRO
	rst $18
	dw \1
ENDM

farcall: MACRO
	rst $28
if _NARG == 1
	db BANK(\1)
	dw \1
else
	db \1
	dw \2
endc
ENDM

; runs SetEventFlagValue with the next value as the flag, c as the new value
set_flag_value: MACRO
	call SetStackFlagValue
	db \1
ENDM

; runs ZeroOutEventFlag with the next value as the flag
zero_flag_value: MACRO
	call ZeroStackFlagValue
	db \1
ENDM

; a second version of the above with no real differences
zero_flag_value2: MACRO
	call ZeroStackFlagValue2
	db \1
ENDM

; runs MaxOutEventFlag with the next value as the flag
max_flag_value: MACRO
	call MaxStackFlagValue
	db \1
ENDM

; runs GetEventFlagValue with the next value as the flag. returns value in a
get_flag_value: MACRO
	call GetStackFlagValue
	db \1
ENDM

; the rst $38 handler is a single ret instruction
; probably used for testing purposes during development
debug_ret EQUS "rst $38"

; Returns to the pointer in bc instead of where the stack was.
retbc: MACRO
	push bc
	ret
ENDM
