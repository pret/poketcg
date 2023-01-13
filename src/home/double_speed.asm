; switch to CGB Normal Speed Mode if playing on CGB and current mode is Double Speed Mode
SwitchToCGBNormalSpeed::
	call CheckForCGB
	ret c
	ld hl, rKEY1
	bit 7, [hl]
	ret z
	jr CGBSpeedSwitch

; switch to CGB Double Speed Mode if playing on CGB and current mode is Normal Speed Mode
SwitchToCGBDoubleSpeed::
	call CheckForCGB
	ret c
	ld hl, rKEY1
	bit 7, [hl]
	ret nz
;	fallthrough

; switch between CGB Double Speed Mode and Normal Speed Mode
CGBSpeedSwitch::
	ldh a, [rIE]
	push af
	xor a
	ldh [rIE], a
	set 0, [hl]
	xor a
	ldh [rIF], a
	ldh [rIE], a
	ld a, $30
	ldh [rJOYP], a
	stop
	call SetupTimer
	pop af
	ldh [rIE], a
	ret
