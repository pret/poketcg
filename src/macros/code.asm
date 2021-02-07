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

; runs SetEventValue with the next byte as the event, c as the new value
set_event_value: MACRO
	call SetStackEventValue
	db \1
ENDM

; runs ZeroOutEventValue with the next byte as the event
; functionally identical to set_event_zero but intended for single-bit events
set_event_false: MACRO
	call SetStackEventFalse
	db \1
ENDM

; runs ZeroOutEventValue with the next byte as the event
; functionally identical to set_event_false but intended for multi-bit events
set_event_zero: MACRO
	call SetStackEventZero
	db \1
ENDM

; runs MaxOutEventValue with the next byte as the event
max_event_value: MACRO
	call MaxStackEventValue
	db \1
ENDM

; runs GetEventValue with the next byte as the event. returns value in a
get_event_value: MACRO
	call GetStackEventValue
	db \1
ENDM

; the rst $38 handler is a single ret instruction
; probably used for testing purposes during development
debug_nop EQUS "rst $38"

; Returns to the pointer in bc instead of where the stack was.
retbc: MACRO
	push bc
	ret
ENDM
