JumpSetWindowOff:
	jp SetWindowOff

; debug function
; prints player's coordinates by pressing B
; and draws palettes by pressing A
Func_1c003: ; unreferenced
	ld a, [wCurMap]
	or a
	jr z, JumpSetWindowOff
	ld a, [wOverworldMode]
	cp OWMODE_START_SCRIPT
	jr nc, JumpSetWindowOff

	ldh a, [hKeysHeld]
	ld b, a
	and A_BUTTON | B_BUTTON
	cp b
	jr nz, JumpSetWindowOff
	and B_BUTTON
	jr z, JumpSetWindowOff

	ld bc, $20
	ld a, [wPlayerXCoord]
	bank1call WriteTwoByteNumberInTxSymbolFormat
	ld bc, $320
	ld a, [wPlayerYCoord]
	bank1call WriteTwoByteNumberInTxSymbolFormat
	ld a, $77
	ldh [hWX], a
	ld a, $88
	ldh [hWY], a

	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .skip_load_scene
	ld a, SCENE_COLOR_PALETTE
	lb bc, 0, 33
	call LoadScene
.skip_load_scene
	ldh a, [hKeysHeld]
	and A_BUTTON
	jr z, .set_wd_on
	ld a, $67
	ldh [hWX], a
	ld a, $68
	ldh [hWY], a
.set_wd_on
	call SetWindowOn
	ret
