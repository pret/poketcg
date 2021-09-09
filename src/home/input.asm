; read joypad data to refresh hKeysHeld, hKeysPressed, and hKeysReleased
; the A + B + Start + Select combination resets the game
ReadJoypad: ; 04de (0:04de)
	ld a, JOY_BTNS_SELECT
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and JOY_INPUT_MASK
	swap a
	ld b, a ; buttons data
	ld a, JOY_DPAD_SELECT
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and JOY_INPUT_MASK
	or b
	ld c, a ; dpad data
	cpl
	ld b, a ; buttons data
	ldh a, [hKeysHeld]
	xor c
	and b
	ldh [hKeysReleased], a
	ldh a, [hKeysHeld]
	xor c
	and c
	ld b, a
	ldh [hKeysPressed], a
	ldh a, [hKeysHeld]
	and BUTTONS
	cp BUTTONS
	jr nz, SaveButtonsHeld
	; A + B + Start + Select: reset game
	call ResetSerial
;	fallthrough

Reset: ; 051b (0:051b)
	ld a, [wInitialA]
	di
	jp Start

SaveButtonsHeld: ; 0522 (0:0522)
	ld a, c
	ldh [hKeysHeld], a
	ld a, JOY_BTNS_SELECT | JOY_DPAD_SELECT
	ldh [rJOYP], a
	ret

; clear joypad hmem data
ClearJoypad: ; 052a (0:052a)
	push hl
	ld hl, hDPadRepeat
	xor a
	ld [hli], a ; hDPadRepeat
	ld [hli], a ; hKeysReleased
	ld [hli], a ; hDPadHeld
	ld [hli], a ; hKeysHeld
	ld [hli], a ; hKeysPressed
	pop hl
	ret
