; unreferenced debug menu
Func_12661:
	xor a
	ld [wDebugMenuSelection], a
	ld [wDebugBoosterSelection], a
	ld a, $03
	ld [wDebugSGBBorder], a
.asm_1266d
	call DisableLCD
	ld a, $00
	ld [wTileMapFill], a
	call EmptyScreen
	call LoadSymbolsFont
	lb de, $30, $7f
	call SetupText
	call EnableAndClearSpriteAnimations
	call Func_12871
	ld a, SINGLE_SPACED
	ld [wLineSeparation], a
	ld a, [wDebugMenuSelection]
	ld hl, Unknown_128f7
	call InitAndPrintMenu
	call EnableLCD
.asm_12698
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .asm_12698
	ldh a, [hCurMenuItem]
	bit 7, a
	jr nz, .asm_12698
	ld [wDebugMenuSelection], a
	xor a ; DOUBLE_SPACED
	ld [wLineSeparation], a
	call Func_126b3
	jr c, .asm_1266d
	ret

Func_126b3:
	ldh a, [hCurMenuItem]
	ld hl, Unknown_126bb
	jp JumpToFunctionInTable

Unknown_126bb:
	dw _GameLoop
	dw DebugDuelMode
	dw MainMenu_ContinueFromDiary
	dw DebugCGBTest
	dw DebugSGBFrame
	dw DebugStandardBGCharacter
	dw DebugLookAtSprite
	dw DebugVEffect
	dw DebugCreateBoosterPack
	dw DebugCredits
	dw DebugQuit
