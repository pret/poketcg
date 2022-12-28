; continuation of Bank0 Start
; meant as the main loop, but the game never returns from _GameLoop anyway
GameLoop::
	di
	ld sp, $e000
	call ResetSerial
	call EnableInt_VBlank
	call EnableInt_Timer
	call EnableSRAM
	ld a, [sTextSpeed]
	ld [wTextSpeed], a
	ld a, [sSkipDelayAllowed]
	ld [wSkipDelayAllowed], a
	call DisableSRAM
	ld a, 1
	ld [wUppercaseHalfWidthLetters], a
	ei
	farcall StubbedUnusedSaveDataValidation
	ldh a, [hKeysHeld]
	cp A_BUTTON | B_BUTTON
	jr z, .ask_erase_backup_ram
	farcall _GameLoop
	jr GameLoop
.ask_erase_backup_ram
	call SetupResetBackUpRamScreen
	call EmptyScreen
	ldtx hl, ResetBackUpRamText
	call YesOrNoMenuWithText
	jr c, .reset_game
; erase sram
	call EnableSRAM
	xor a
	ld [s0a000], a
	call DisableSRAM
.reset_game
	jp Reset

InitSaveDataAndSetUppercase::
	farcall InitSaveData
	ld a, 1
	ld [wUppercaseHalfWidthLetters], a
	ret

; basic setup to be able to print the ResetBackUpRamText in an empty screen
SetupResetBackUpRamScreen:
	xor a ; SYM_SPACE
	ld [wTileMapFill], a
	call DisableLCD
	call LoadSymbolsFont
	call SetDefaultConsolePalettes
	lb de, $38, $7f
	call SetupText
	ret

	ret ; stray ret
