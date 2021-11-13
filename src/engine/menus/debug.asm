DebugLookAtSprite:
	farcall Func_80cd7
	scf
	ret

DebugVEffect:
	farcall Func_80cd6
	scf
	ret

DebugCreateBoosterPack:
.go_back
	ld a, [wDebugBoosterSelection]
	ld hl, Unknown_12919
	call InitAndPrintMenu
.input_loop_1
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .input_loop_1
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .cancel
	ld [wDebugBoosterSelection], a
	add a
	ld c, a
	ld b, $00
	ld hl, Unknown_127f1
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a
	call InitAndPrintMenu
.input_loop_2
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .input_loop_2
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .go_back
	ld a, [wDebugBoosterSelection]
	ld c, a
	ld b, $00
	ld hl, Unknown_127fb
	add hl, bc
	ld a, [hl]
	add e
	farcall GenerateBoosterPack
	farcall OpenBoosterPack
.cancel
	scf
	ret

Unknown_127f1:
	dw Unknown_1292a
	dw Unknown_1292a
	dw Unknown_1293b
	dw Unknown_1294c
	dw Unknown_1295d

Unknown_127fb:
	db BOOSTER_COLOSSEUM_NEUTRAL
	db BOOSTER_EVOLUTION_NEUTRAL
	db BOOSTER_MYSTERY_NEUTRAL
	db BOOSTER_LABORATORY_NEUTRAL
	db BOOSTER_ENERGY_LIGHTNING_FIRE

DebugCredits:
	farcall PlayCreditsSequence
	scf
	ret

DebugCGBTest:
	farcall Func_1c865
	scf
	ret

DebugSGBFrame:
	call DisableLCD
	ld a, [wDebugSGBBorder]
	farcall SetSGBBorder
	ld a, [wDebugSGBBorder]
	inc a
	cp $04
	jr c, .asm_1281f
	xor a
.asm_1281f
	ld [wDebugSGBBorder], a
	scf
	ret

DebugDuelMode:
	call EnableSRAM
	ld a, [sDebugDuelMode]
	and $01
	ld [sDebugDuelMode], a
	ld hl, Unknown_12908
	call InitAndPrintMenu
.input_loop
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .input_loop
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .input_loop
	and $01
	ld [sDebugDuelMode], a
	call DisableSRAM
	scf
	ret

DebugStandardBGCharacter:
	ld a, $80
	ld de, $0
	lb bc, 16, 16
	lb hl,  1, 16
	call FillRectangle
	ld a, BUTTONS | D_PAD
	call WaitUntilKeysArePressed
	scf
	ret

DebugQuit:
	or a
	ret
