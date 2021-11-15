Func_12871:
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call Set_OBJ_8x8
	call SetDefaultPalettes
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [hWX], a
	ldh [hWY], a
	call SetWindowOff
	ret

; same as SetDefaultConsolePalettes
; but forces all wBGP, wOBP0 and wOBP1
; to be the default
SetDefaultPalettes:
	push hl
	push bc
	push de
	ld a, %11100100
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	ld a, 4
	ld [wTextBoxFrameType], a
	bank1call SetDefaultConsolePalettes
	call FlushAllPalettes
	pop de
	pop bc
	pop hl
	ret
