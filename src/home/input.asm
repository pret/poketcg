; read joypad data to refresh hKeysHeld, hKeysPressed, and hKeysReleased
; the A + B + Start + Select combination resets the game
ReadJoypad::
	ld a, JOYP_GET_CTRL_PAD
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and JOYP_INPUTS
	swap a
	ld b, a ; buttons data
	ld a, JOYP_GET_BUTTONS
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	cpl
	and JOYP_INPUTS
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
	and PAD_BUTTONS
	cp PAD_BUTTONS
	jr nz, SaveButtonsHeld
	; A + B + Start + Select: reset game
	call ResetSerial
;	fallthrough

Reset::
	ld a, [wInitialA]
	di
	jp Start

SaveButtonsHeld::
	ld a, c
	ldh [hKeysHeld], a
	ld a, JOYP_GET_NONE
	ldh [rJOYP], a
	ret

; clear joypad hmem data
ClearJoypad::
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
