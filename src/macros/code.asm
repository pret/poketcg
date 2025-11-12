MACRO? lb ; r, hi, lo
	ld \1, (\2) << 8 + ((\3) & $ff)
ENDM

MACRO? ldtx
	IF _NARG == 2
		ld \1, \2_
	ELSE
		ld \1, \2_ \3
	ENDC
ENDM

MACRO? bank1call
	rst $18
	dw \1
ENDM

MACRO? farcall
	rst $28
	IF _NARG == 1
		db BANK(\1)
		dw \1
	ELSE
		db \1
		dw \2
	ENDC
ENDM

; runs SetEventValue with the next byte as the event, c as the new value
MACRO? set_event_value
	call SetStackEventValue
	db \1
ENDM

; runs ZeroOutEventValue with the next byte as the event
; functionally identical to set_event_zero but intended for single-bit events
MACRO? set_event_false
	call SetStackEventFalse
	db \1
ENDM

; runs ZeroOutEventValue with the next byte as the event
; functionally identical to set_event_false but intended for multi-bit events
MACRO? set_event_zero
	call SetStackEventZero
	db \1
ENDM

; runs MaxOutEventValue with the next byte as the event
MACRO? max_event_value
	call MaxStackEventValue
	db \1
ENDM

; runs GetEventValue with the next byte as the event. returns value in a
MACRO? get_event_value
	call GetStackEventValue
	db \1
ENDM

; the rst $38 handler is a single ret instruction
; probably used for testing purposes during development
MACRO? debug_nop
	rst $38
ENDM

; Returns to the pointer in bc instead of where the stack was.
MACRO? retbc
	push bc
	ret
ENDM

; loads into a register the GameBoy (DMG) palette given
; by the arguments as SHADE_* constants
MACRO? ldgbpal
	ld \1, (\2 << 0) | (\3 << 2) | (\4 << 4) | (\5 << 6)
ENDM
