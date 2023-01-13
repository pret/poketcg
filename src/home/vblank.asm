; vblank interrupt handler
VBlankHandler::
	push af
	push bc
	push de
	push hl
	ldh a, [hBankROM]
	push af
	ld hl, wReentrancyFlag
	bit IN_VBLANK, [hl]
	jr nz, .done
	set IN_VBLANK, [hl]
	ld a, [wVBlankOAMCopyToggle]
	or a
	jr z, .no_oam_copy
	call hDMAFunction ; DMA-copy $ca00-$ca9f to OAM memory
	xor a
	ld [wVBlankOAMCopyToggle], a
.no_oam_copy
	; flush scaling/windowing parameters
	ldh a, [hSCX]
	ldh [rSCX], a
	ldh a, [hSCY]
	ldh [rSCY], a
	ldh a, [hWX]
	ldh [rWX], a
	ldh a, [hWY]
	ldh [rWY], a
	; flush LCDC
	ld a, [wLCDC]
	ldh [rLCDC], a
	ei
	call wVBlankFunctionTrampoline
	call FlushPalettesIfRequested
	ld hl, wVBlankCounter
	inc [hl]
	ld hl, wReentrancyFlag
	res IN_VBLANK, [hl]
.done
	pop af
	call BankswitchROM
	pop hl
	pop de
	pop bc
	pop af
	reti
