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
	and PAD_A | PAD_B
	cp b
	jr nz, JumpSetWindowOff
	and PAD_B
	jr z, JumpSetWindowOff

	ld bc, $20
	ld a, [wPlayerXCoord]
	bank1call WriteTwoByteNumberInTxSymbolFormat
	ld bc, $320
	ld a, [wPlayerYCoord]
	bank1call WriteTwoByteNumberInTxSymbolFormat
	ld a, 112 + WX_OFS
	ldh [hWX], a
	ld a, 136
	ldh [hWY], a

	ldh a, [hKeysPressed]
	and PAD_A
	jr z, .skip_load_scene
	ld a, SCENE_COLOR_PALETTE
	lb bc, 0, 33
	call LoadScene
.skip_load_scene
	ldh a, [hKeysHeld]
	and PAD_A
	jr z, .set_wd_on
	ld a, 96 + WX_OFS
	ldh [hWX], a
	ld a, 104
	ldh [hWY], a
.set_wd_on
	call SetWindowOn
	ret
