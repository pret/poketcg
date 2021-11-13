; empties screen in preparation to draw some menu
InitMenuScreen:
	ld a, $0
	ld [wTileMapFill], a
	call EmptyScreen
	call LoadSymbolsFont
	lb de, $30, $7f
	call SetupText
	call Set_OBJ_8x8
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ld a, [wLCDC]
	bit LCDC_ENABLE_F, a
	jr nz, .skip_clear_scroll
	xor a
	ldh [rSCX], a
	ldh [rSCY], a
.skip_clear_scroll
	call SetDefaultPalettes
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ret

; saves all pals to SRAM, then fills them with white.
; after flushing, it loads back the saved pals from SRAM.
FlashWhiteScreen:
	ldh a, [hBankSRAM]

	push af
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	call CopyPalsToSRAMBuffer
	call DisableSRAM
	call SetWhitePalettes
	call FlushAllPalettes
	call EnableLCD
	call DoFrameIfLCDEnabled
	call LoadPalsFromSRAMBuffer
	call FlushAllPalettes
	pop af

	call BankswitchSRAM
	call DisableSRAM
	ret
