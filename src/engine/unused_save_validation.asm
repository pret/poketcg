; this is a commented out routine for save data validation
; sUnusedSaveDataValidationByte would be used to store some validation byte
; and xor'd with $250 bytes in SRAM starting from sCardCollection
; if the result wasn't 0, then it would mean there was
; some save corruption and an error message would pop up
StubbedUnusedSaveDataValidation:
	ret

UnusedSaveDataValidation: ; unreferenced
	ldh a, [hBankSRAM]
	or a
	ret nz

	push hl
	push de
	push bc
	ld hl, sCardCollection
	ld bc, $250
	ld a, [sUnusedSaveDataValidationByte]
	ld e, a
.loop_xor
	ld a, [hli]
	xor e
	ld e, a
	dec bc
	ld a, c
	or b
	jr nz, .loop_xor
	ld a, e
	pop bc
	pop de
	pop hl
	or a
	ret z

	xor a
	ld [wTileMapFill], a
	ld hl, wDoFrameFunction
	ld [hli], a
	ld [hl], a
	ldh [hSCX], a
	ldh [hSCY], a
	bank1call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadSymbolsFont
	bank1call SetDefaultConsolePalettes
	ld a, [wConsole]
	cp CONSOLE_SGB
	jr nz, .not_sgb
	ld a, %11100100
	ld [wOBP0], a
	ld [wBGP], a
	ld a, $01
	ld [wFlushPaletteFlags], a
.not_sgb
	lb de, $38, $9f
	call SetupText
	ldtx hl, YourDataWasDestroyedSomehowText
	bank1call DrawWholeScreenTextBox
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	xor a
	ldh [hBankSRAM], a
	ld [MBC3SRamBank], a
	ld [MBC3RTC], a
	ld [MBC3SRamEnable], a
	jp Reset

	ret

UnusedCalculateSaveDataValidationByte: ; unreferenced
	ldh a, [hBankSRAM]
	or a
	ret nz
	push hl
	push de
	push bc
	ld hl, sCardCollection
	ld bc, $250
	ld e, $00
.loop_xor
	ld a, [hli]
	xor e
	ld e, a
	dec bc
	ld a, c
	or b
	jr nz, .loop_xor
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	ld a, e
	ld [sUnusedSaveDataValidationByte], a
	pop bc
	pop de
	pop hl
	ret
