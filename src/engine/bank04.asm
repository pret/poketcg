Func_10000: ; 10000 (4:4000)
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
	jr nz, .asm_10025
	xor a
	ldh [rSCX], a
	ldh [rSCY], a

.asm_10025
	call Func_1288c
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ret

; saves all pals to SRAM, then fills them with white.
; after flushing, it loads back the saved pals from SRAM.
FlashWhiteScreen: ; 10031 (4:4031)
	ldh a, [hBankSRAM]

	push af
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	call CopyPalsToSRAMBuffer
	call DisableSRAM
	call Func_10b28
	call FlushAllPalettes
	call EnableLCD
	call DoFrameIfLCDEnabled
	call LoadPalsFromSRAMBuffer
	call FlushAllPalettes
	pop af

	call BankswitchSRAM
	call DisableSRAM
	ret

_PauseMenu_Status: ; 10059 (4:4059)
	ld a, [wd291]
	push af
	call Func_10000
	xor a
	ld [wMedalScreenYOffset], a
	call LoadCollectedMedalTilemaps
	lb de,  0,  0
	lb bc, 20,  8
	call DrawRegularTextBox
	ld hl, StatusScreenLabels
	call Func_111b3
	ld bc, $101
	call Func_1029a
	ld bc, $c04
	call Func_1024a
	ld bc, $d06
	call Func_101cd
	call FlashWhiteScreen
	ld a, $0b
	call Func_12863
	pop af
	ld [wd291], a
	ret

StatusScreenLabels: ; 10095 (4:4095)
	db 7, 2
	tx PlayerStatusNameText

	db 7, 4
	tx PlayerStatusAlbumText

	db 7, 6
	tx PlayerStatusPlayTimeText

	db $ff

_PauseMenu_Diary: ; 100a2 (4:40a2)
	ld a, [wd291]
	push af
	call Func_10000
	lb de,  0,  0
	lb bc, 20, 12
	call DrawRegularTextBox
	ld hl, Unknown_100f7
	call Func_111b3
	ld bc, $103
	call Func_1029a
	ld bc, $c08
	call Func_1024a
	ld bc, $d0a
	call Func_101cd
	lb bc, 16, 6
	call Func_1027c
	call FlashWhiteScreen
	ldtx hl, PlayerDiarySaveQuestionText
	call YesOrNoMenuWithText_SetCursorToYes
	jr c, .asm_100ec
	farcall BackupPlayerPosition
	call SaveAndBackupData
	ld a, SFX_56
	call PlaySFX
	ldtx hl, PlayerDiarySaveConfirmText
	jr .asm_100ef
.asm_100ec
	ldtx hl, PlayerDiarySaveCancelText
.asm_100ef
	call PrintScrollableText_NoTextBoxLabel
	pop af
	ld [wd291], a
	ret

Unknown_100f7: ; 100f7 (4:40f7)
	db 5, 1
	tx PlayerDiaryTitleText

	db 7, 4
	tx PlayerStatusNameText

	db 7, 6
	tx PlayerDiaryMedalsWonText

	db 7, 8
	tx PlayerStatusAlbumText

	db 7, 10
	tx PlayerStatusPlayTimeText

	db $ff

LoadCollectedMedalTilemaps: ; 1010c (4:410c)
	xor a
	ld [wd291], a
	lb de,  0,  8
	ld a, [wMedalScreenYOffset]
	add e
	ld e, a
	lb bc, 20, 10
	call DrawRegularTextBox
	lb de, 6, 9
	ld a, [wMedalScreenYOffset]
	add e
	ld e, a
	call AdjustCoordinatesForBGScroll
	call InitTextPrinting
	ldtx hl, PlayerStatusMedalsTitleText
	call PrintTextNoDelay
	ld hl, MedalCoordsAndTilemaps
	ld a, EVENT_MEDAL_FLAGS
	farcall GetEventValue
	or a
	jr z, .asm_1017e
	ld c, NUM_MEDALS
.asm_10140
	push bc
	push hl
	push af
	bit 7, a
	jr z, .asm_10157
	ld b, [hl]
	inc hl
	ld a, [wMedalScreenYOffset]
	add [hl]
	ld c, a
	inc hl
	ld a, [hli]
	ld [wCurTilemap], a
	farcall LoadTilemap_ToVRAM
.asm_10157
	pop af
	rlca
	pop hl
	ld bc, $3
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_10140
	ld a, $80
	ld [wd4ca], a
	xor a
	ld [wd4cb], a
	farcall LoadTilesetGfx
	xor a
	ld [wd4ca], a
	ld a, $01
	ld [wd4cb], a
	ld a, $76
	farcall SetBGPAndLoadedPal
.asm_1017e
	ret

MedalCoordsAndTilemaps: ; 1017f (4:417f)
; x, y, tilemap
	db  1, 10, TILEMAP_GRASS_MEDAL
	db  6, 10, TILEMAP_SCIENCE_MEDAL
	db 11, 10, TILEMAP_FIRE_MEDAL
	db 16, 10, TILEMAP_WATER_MEDAL
	db  1, 14, TILEMAP_LIGHTNING_MEDAL
	db  6, 14, TILEMAP_PSYCHIC_MEDAL
	db 11, 14, TILEMAP_ROCK_MEDAL
	db 16, 14, TILEMAP_FIGHTING_MEDAL

FlashReceivedMedal: ; 10197 (4:4197)
	xor a
	ld [wd291], a
	ld hl, MedalCoordsAndTilemaps
	ld a, [wWhichMedal]
	ld c, a
	add a
	add c
	ld c, a
	ld b, $00
	add hl, bc
	ld b, [hl]
	inc hl
	ld a, [wMedalScreenYOffset]
	add [hl]
	ld c, a
	ld a, [wMedalDisplayTimer]
	bit 4, a
	jr z, .show
; hide
	xor a
	ld e, c
	ld d, b
	lb bc, 3, 3
	lb hl, 0, 0
	call FillRectangle
	ret

.show
	inc hl
	ld a, [hl]
	ld [wCurTilemap], a
	farcall LoadTilemap_ToVRAM
	ret

Func_101cd: ; 101cd (4:41cd)
	ld a, [wPlayTimeCounter + 2]
	ld [wPlayTimeHourMinutes], a
	ld a, [wPlayTimeCounter + 3]
	ld [wPlayTimeHourMinutes + 1], a
	ld a, [wPlayTimeCounter + 4]
	ld [wPlayTimeHourMinutes + 2], a
;	fallthrough
Func_101df: ; 101df (4:41df)
	push bc
	ld a, [wPlayTimeHourMinutes + 1]
	ld l, a
	ld a, [wPlayTimeHourMinutes + 2]
	ld h, a
	call Func_10217
	pop bc
	push bc
	call BCCoordToBGMap0Address
	ld hl, wd4b4
	ld b, $03
	call SafeCopyDataHLtoDE
	ld a, [wPlayTimeHourMinutes]
	add 100
	ld l, a
	ld a, 0
	adc 0
	ld h, a
	call Func_10217
	pop bc
	ld a, b
	add $04
	ld b, a
	call BCCoordToBGMap0Address
	ld hl, wd4b4 + 1
	ld b, $02
	call SafeCopyDataHLtoDE
	ret

Func_10217: ; 10217 (4:4217)
	ld de, wd4b4
	ld bc, -100
	call Func_1023b
	ld bc, -10
	call Func_1023b
	ld a, l
	add $20
	ld [de], a
	ld hl, wd4b4
	ld c, $02
.asm_1022f
	ld a, [hl]
	cp $20
	jr nz, .asm_1023a
	ld [hl], $00
	inc hl
	dec c
	jr nz, .asm_1022f
.asm_1023a
	ret

Func_1023b: ; 1023b (4:423b)
	ld a, $1f
.asm_1023d
	inc a
	add hl, bc
	jr c, .asm_1023d
	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret

Func_1024a: ; 1024a (4:424a)
	push bc
	call GetCardAlbumProgress
	pop bc
;	fallthrough
Func_1024f: ; 1024f (4:424f)
	push bc
	push de
	push bc
	ld l, d
	ld h, $00
	call Func_10217
	pop bc
	call BCCoordToBGMap0Address
	ld hl, wd4b4
	ld b, $03
	call SafeCopyDataHLtoDE
	pop de
	ld l, e
	ld h, $00
	call Func_10217
	pop bc
	ld a, b
	add $04
	ld b, a
	call BCCoordToBGMap0Address
	ld hl, wd4b4
	ld b, $03
	call SafeCopyDataHLtoDE
	ret

Func_1027c: ; 1027c (4:427c)
	push bc
	farcall TryGiveMedalPCPacks
	ld a, EVENT_MEDAL_COUNT
	farcall GetEventValue
	ld l, a
	ld h, $00
	call Func_10217
	pop bc
	call BCCoordToBGMap0Address
	ld hl, wd4b4 + 2
	ld b, $01
	call SafeCopyDataHLtoDE
	ret

Func_1029a: ; 1029a (4:429a)
	call DrawPlayerPortrait
	ret

ShowMedalReceivedScreen: ; 1029e (4:429e)
	sub $8
	ld c, a
	ld [wWhichMedal], a
	ld a, [wd291]
	push af
	push bc
	call PauseSong
	ld a, MUSIC_STOP
	call PlaySong
	farcall SetMainSGBBorder
	call DisableLCD
	call Func_10000
	ld a, -6
	ld [wMedalScreenYOffset], a
	call LoadCollectedMedalTilemaps
	pop bc
	ld a, c
	add a
	ld c, a
	ld b, $0
	ld hl, MasterMedalNames
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	call FlashWhiteScreen
	ld a, MUSIC_MEDAL
	call PlaySong
	ld a, $ff
	ld [wMedalDisplayTimer], a
.flash_loop
	call DoFrameIfLCDEnabled
	ld a, [wMedalDisplayTimer]
	inc a
	ld [wMedalDisplayTimer], a
	and $f
	jr nz, .flash_loop
	call FlashReceivedMedal
	ld a, [wMedalDisplayTimer]
	cp $e0
	jr nz, .flash_loop
	ldtx hl, WonTheMedalText
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	pop af
	ld [wd291], a
	ret

MasterMedalNames: ; 1030b (4:430b)
	tx GrassClubMapNameText
	tx ScienceClubMapNameText
	tx FireClubMapNameText
	tx WaterClubMapNameText
	tx LightningClubMapNameText
	tx PsychicClubMapNameText
	tx RockClubMapNameText
	tx FightingClubMapNameText

GiveBoosterPack: ; 1031b (4:431b)
	ld c, a
	ld a, [wd291]
	push af
	push bc
	call DisableLCD
	call Func_10000
	xor a
	ld [wTextBoxFrameType], a
	pop bc
	push bc
	ld b, 0
	ld hl, BoosterTypes
	add hl, bc
	ld a, [hl]
	ld c, a
	add a
	add a
	ld c, a
	ld hl, BoosterScenesAndNameTexts
	add hl, bc
	ld a, [hli]
	push hl
	lb bc, 6, 0
	call LoadBoosterGfx
	pop hl
	ld a, [hli]
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	call FlashWhiteScreen
	call PauseSong
	ld a, MUSIC_BOOSTER_PACK
	call PlaySong
	pop bc
	ld a, c
	farcall GenerateBoosterPack
	ldtx hl, ReceivedBoosterPackText
	ld a, [wAnotherBoosterPack]
	cp TRUE
	jr nz, .first_booster
	ldtx hl, AndAnotherBoosterPackText
.first_booster
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	ldtx hl, CheckedCardsInBoosterPackText
	call PrintScrollableText_NoTextBoxLabel
	call DisableLCD
	call Func_1288c
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ld a, $4
	ld [wTextBoxFrameType], a
	farcall OpenBoosterPack
	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	pop af
	ld [wd291], a
	ret

BoosterTypes: ; 103a5 (4:43a5)
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_NEUTRAL
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_GRASS
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_FIRE
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_WATER
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_LIGHTNING
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_FIGHTING
	db BOOSTER_COLOSSEUM  ; BOOSTER_COLOSSEUM_TRAINER
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_NEUTRAL
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_GRASS
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_FIRE
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_WATER
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_FIGHTING
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_PSYCHIC
	db BOOSTER_EVOLUTION  ; BOOSTER_EVOLUTION_TRAINER
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_NEUTRAL
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_GRASS_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_WATER_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_LIGHTNING_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_FIGHTING_COLORLESS
	db BOOSTER_MYSTERY    ; BOOSTER_MYSTERY_TRAINER_COLORLESS
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_NEUTRAL
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_GRASS
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_WATER
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_PSYCHIC
	db BOOSTER_LABORATORY ; BOOSTER_LABORATORY_TRAINER
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_LIGHTNING_FIRE
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_WATER_FIGHTING
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_GRASS_PSYCHIC
	db BOOSTER_COLOSSEUM  ; BOOSTER_ENERGY_RANDOM

BoosterScenesAndNameTexts: ; 103c2 (4:43c2)
	db SCENE_COLOSSEUM_BOOSTER, SCENE_COLOSSEUM_BOOSTER
	tx ColosseumBoosterText

	db SCENE_EVOLUTION_BOOSTER, SCENE_EVOLUTION_BOOSTER
	tx EvolutionBoosterText

	db SCENE_MYSTERY_BOOSTER, SCENE_MYSTERY_BOOSTER
	tx MysteryBoosterText

	db SCENE_LABORATORY_BOOSTER, SCENE_LABORATORY_BOOSTER
	tx LaboratoryBoosterText

_PauseMenu_Exit: ; 103d2 (4:43d2)
	ret

Duel_Init: ; 103d3 (4:43d3)
	ld a, [wd291]
	push af
	call DisableLCD
	call Func_10000
	ld a, $4
	ld [wTextBoxFrameType], a
	lb de,  0, 12
	lb bc, 20,  6
	call DrawRegularTextBox
	ld a, [wNPCDuelDeckID]
	add a
	add a
	ld c, a
	ld b, $0
	ld hl, OpponentTitlesAndDeckNames
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hli]
	ld [wTxRam2 + 1], a
	push hl
	ld a, [wOpponentName]
	ld [wTxRam2_b], a
	ld a, [wOpponentName + 1]
	ld [wTxRam2_b + 1], a
	ld hl, OpponentTitleAndNameTextCoords
	call Func_111b3 ; LoadDuelistName
	pop hl
	ld a, [hli]
	ld [wTxRam2], a
	ld c, a
	ld a, [hli]
	ld [wTxRam2 + 1], a
	or c
	jr z, .asm_10425
	ld hl, OpponentDeckNameTextCoords
	call Func_111b3 ; LoadDeckName

.asm_10425
	lb bc, 7, 3
	ld a, [wOpponentPortrait]
	call Func_3e2a ; LoadDuelistPortrait
	ld a, [wMatchStartTheme]
	call PlaySong
	call FlashWhiteScreen
	call DoFrameIfLCDEnabled
	lb bc, $2f, $1d ; cursor tile, tile behind cursor
	lb de, 18, 17 ; x, y
	call SetCursorParametersForTextBox
	call WaitForButtonAorB
	call WaitForSongToFinish
	call Func_10ab4 ; fade out
	pop af
	ld [wd291], a
	ret

OpponentTitleAndNameTextCoords: ; 10451 (4:4451)
	db 1, 14
	tx OpponentTitleAndNameText
	db $ff

OpponentDeckNameTextCoords: ; 10456 (4:4456)
	db 1, 16
	tx OpponentDeckNameText
	db $ff

OpponentTitlesAndDeckNames: ; 1045b (4:445b)
	tx TechText
	tx SamsPracticeDeckName

	tx EmptyText
	dw NULL

	tx TechText
	tx SamsPracticeDeckName

	tx EmptyText
	dw NULL

	tx EmptyText
	dw NULL

	tx EmptyText
	dw NULL

	tx EmptyText
	dw NULL

	tx EmptyText
	dw NULL

	tx EmptyText
	dw NULL

	tx TechText
	tx LightningAndFireDeckName

	tx TechText
	tx WaterAndFightingDeckName

	tx TechText
	tx GrassAndPsychicDeckName

	tx GrandMasterText
	tx LegendaryMoltresDeckName

	tx GrandMasterText
	tx LegendaryZapdosDeckName

	tx GrandMasterText
	tx LegendaryArticunoDeckName

	tx GrandMasterText
	tx LegendaryDragoniteDeckName

	tx FightingClubMasterText
	tx FirstStrikeDeckName

	tx RockClubMasterText
	tx RockCrusherDeckName

	tx WaterClubMasterText
	tx GoGoRainDanceDeckName

	tx LightningClubMasterText
	tx ZappingSelfdestructDeckName

	tx GrassClubMasterText
	tx FlowerPowerDeckName

	tx PsychicClubMasterText
	tx StrangePsyshockDeckName

	tx ScienceClubMasterText
	tx WondersofScienceDeckName

	tx FireClubMasterText
	tx FireChargeDeckName

	tx EmptyText
	tx ImRonaldDeckName

	tx EmptyText
	tx PowerfulRonaldDeckName

	tx EmptyText
	tx InvincibleRonaldDeckName

	tx EmptyText
	tx LegendaryRonaldDeckName

	tx FightingClubMemberText
	tx MusclesforBrainsDeckName

	tx FightingClubMemberText
	tx HeatedBattleDeckName

	tx FightingClubMemberText
	tx LovetoBattleDeckName

	tx RockClubMemberText
	tx ExcavationDeckName

	tx RockClubMemberText
	tx BlisteringPokemonDeckName

	tx RockClubMemberText
	tx HardPokemonDeckName

	tx WaterClubMemberText
	tx WaterfrontPokemonDeckName

	tx WaterClubMemberText
	tx LonelyFriendsDeckName

	tx WaterClubMemberText
	tx SoundoftheWavesDeckName

	tx LightningClubMemberText
	tx PikachuDeckName

	tx LightningClubMemberText
	tx BoomBoomSelfdestructDeckName

	tx LightningClubMemberText
	tx PowerGeneratorDeckName

	tx GrassClubMemberText
	tx EtceteraDeckName

	tx GrassClubMemberText
	tx FlowerGardenDeckName

	tx GrassClubMemberText
	tx KaleidoscopeDeckName

	tx PsychicClubMemberText
	tx GhostDeckName

	tx PsychicClubMemberText
	tx NapTimeDeckName

	tx PsychicClubMemberText
	tx StrangePowerDeckName

	tx ScienceClubMemberText
	tx FlyinPokemonDeckName

	tx ScienceClubMemberText
	tx LovelyNidoranDeckName

	tx ScienceClubMemberText
	tx PoisonDeckName

	tx FireClubMemberText
	tx AngerDeckName

	tx FireClubMemberText
	tx FlamethrowerDeckName

	tx FireClubMemberText
	tx ReshuffleDeckName

	tx StrangeLifeformText
	tx ImakuniDeckName

_PCMenu_Glossary: ; 1052f (4:452f)
	ld a, [wd291]
	push af
	call Func_10000
	lb de, $30, $ff
	call SetupText
	call FlashWhiteScreen
	farcall OpenGlossaryScreen
	pop af
	ld [wd291], a
	ret

_PauseMenu_Config: ; 10548 (4:4548)
	ld a, [wd291]
	push af
	ld a, [wLineSeparation]
	push af
	xor a
	ld [wConfigExitSettingsCursorPos], a
	ld a, 1
	ld [wLineSeparation], a
	call Func_10000
	lb de,  0,  3
	lb bc, 20,  5
	call DrawRegularTextBox
	lb de,  0,  9
	lb bc, 20,  5
	call DrawRegularTextBox
	ld hl, Unknown_105bc
	call Func_111b3
	call Func_105cd
	ld a, 0
	call ShowRightArrowCursor
	ld a, 1
	call ShowRightArrowCursor
	xor a
	ld [wCursorBlinkTimer], a
	call FlashWhiteScreen
.asm_10588
	call DoFrameIfLCDEnabled
	ld a, [wConfigCursorYPos]
	call Func_10649
	ld hl, wCursorBlinkTimer
	inc [hl]
	call ConfigScreenHandleDPadInput
	ldh a, [hKeysPressed]
	and B_BUTTON | START
	jr nz, .asm_105ab
	ld a, [wConfigCursorYPos]
	cp $02
	jr nz, .asm_10588
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .asm_10588
.asm_105ab
	ld a, SFX_02
	call PlaySFX
	call Func_10606
	pop af
	ld [wLineSeparation], a
	pop af
	ld [wd291], a
	ret

Unknown_105bc: ; 105bc (4:45bc)
	db 1, 1
	tx ConfigMenuTitleText

	db 1, 4
	tx ConfigMenuMessageSpeedText

	db 1, 10
	tx ConfigMenuDuelAnimationText

	db 1, 16
	tx ConfigMenuExitText

	db $ff

Func_105cd: ; 105cd (4:45cd)
	call EnableSRAM
	ld c, $00
	ld hl, Unknown_10644
.loop
	ld a, [sTextSpeed]
	cp [hl]
	jr nc, .match
	inc hl
	inc c
	ld a, c
	cp $04
	jr c, .loop
.match
	ld a, c
	ld [wConfigMessageSpeedCursorPos], a
	ld a, [sSkipDelayAllowed]
	and $01
	rlca
	ld c, a
	ld a, [wAnimationsDisabled]
	and $01
	or c
	ld c, a
	ld b, $00
	ld hl, Unknown_10602
	add hl, bc
	ld a, [hl]
	ld [wConfigDuelAnimationCursorPos], a
	call DisableSRAM
	ret

; indexes into Unknown_1063c
; $00: show all
; $01: skip some
; $02: none
Unknown_10602: ; 10602 (4:4602)
	db $00 ; skip delay allowed = false, animations disabled = false
	db $00 ; skip delay allowed = false, animations disabled = true (unused)
	db $01 ; skip delay allowed = true, animations disabled = false
	db $02 ; skip delay allowed = true, animations disabled = true

Func_10606: ; 10606 (4:4606)
	call EnableSRAM
	ld a, [wConfigDuelAnimationCursorPos]
	and $03
	rlca
	ld c, a
	ld b, $00
	ld hl, Unknown_1063c
	add hl, bc
	ld a, [hli]
	ld [wAnimationsDisabled], a
	ld [sAnimationsDisabled], a
	ld a, [hl]
	ld [sSkipDelayAllowed], a
	call DisableSRAM
	ld a, [wConfigMessageSpeedCursorPos]
	ld c, a
	ld b, $00
	ld hl, Unknown_10644
	add hl, bc
	call EnableSRAM
	ld a, [hl]
	ld [sTextSpeed], a
	ld [wTextSpeed], a
	call DisableSRAM
	ret

Unknown_1063c: ; 1063c (4:463c)
; animation disabled, skip delay allowed
	db FALSE, FALSE ; show all
	db FALSE, TRUE  ; skip some
	db TRUE,  TRUE  ; none
	db FALSE, FALSE ; unused

; text printing delay
Unknown_10644: ; 10644 (4:4644)
	; slow to fast
	db 6, 4, 2, 1, 0

Func_10649: ; 10649 (4:4649)
	push af
	ld a, [wCursorBlinkTimer]
	and $10
	jr z, .asm_10654
	pop af
	jr HideRightArrowCursor
.asm_10654
	pop af
	jr ShowRightArrowCursor

ShowRightArrowCursor: ; 10657 (4:4657)
	push bc
	ld c, a
	ld a, SYM_CURSOR_R
	call Func_10669
	pop bc
	ret

HideRightArrowCursor: ; 10660 (4:4660)
	push bc
	ld c, a
	ld a, SYM_SPACE
	call Func_10669
	pop bc
	ret

Func_10669: ; 10669 (4:4669)
	push af
	sla c
	ld b, $00
	ld hl, ConfigScreenCursorPositions
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [bc]
	add a
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	pop af
	call WriteByteToBGMap0
	ret

ConfigScreenCursorPositions: ; 10688 (4:4688)
	dw MessageSpeedCursorPositions
	dw DuelAnimationsCursorPositions
	dw ExitSettingsCursorPosition

MessageSpeedCursorPositions: ; 1068e (4:468e)
	dw wConfigMessageSpeedCursorPos
	db  5, 6
	db  7, 6
	db  9, 6
	db 11, 6
	db 13, 6

DuelAnimationsCursorPositions: ; 1069a (4:469a)
	dw wConfigDuelAnimationCursorPos
	db  1, 12
	db  7, 12
	db 15, 12

ExitSettingsCursorPosition: ; 106a2 (4:46a2)
	dw wConfigExitSettingsCursorPos
	db 1, 16

	db 0

ConfigScreenHandleDPadInput: ; 106a7 (4:46a7)
	ldh a, [hDPadHeld]
	and D_PAD
	ret z
	farcall GetDirectionFromDPad
	ld hl, ConfigScreenDPadHandlers
	jp JumpToFunctionInTable

ConfigScreenDPadHandlers: ; 106b6 (4:46b6)
	dw ConfigScreenDPadUp ; up
	dw ConfigScreenDPadRight ; right
	dw ConfigScreenDPadDown ; down
	dw ConfigScreenDPadLeft ; left

ConfigScreenDPadUp: ; 106be (4:46be)
	ld a, -1
	jr ConfigScreenDPadDown.up_or_down

ConfigScreenDPadDown: ; 106c2 (4:46c2)
	ld a, 1
.up_or_down
	push af
	ld a, [wConfigCursorYPos]
	cp 2
	jr z, .hide_cursor
	call ShowRightArrowCursor
	jr .skip
.hide_cursor
; hide "exit settings" cursor if leaving bottom row
	call HideRightArrowCursor
.skip
	ld a, [wConfigCursorYPos]
	ld b, a
	pop af
	add b
	cp 3
	jr c, .valid
	jr z, .wrap_min
; wrap max
	ld a, 2 ; max
	jr .valid
.wrap_min
	xor a ; min
.valid
	ld [wConfigCursorYPos], a
	ld c, a
	ld b, 0
	ld hl, Unknown_106ff
	add hl, bc
	ld a, [hl]
	ld [wCursorBlinkTimer], a
	ld a, [wConfigCursorYPos]
	call Func_10649
	ld a, SFX_01
	call PlaySFX
	ret

Unknown_106ff: ; 106ff (4:46ff)
	db $18 ; message speed, start hidden
	db $18 ; duel animation, start hidden
	db $8 ; exit settings, start visible

ConfigScreenDPadRight: ; 10702 (4:4702)
	ld a, $01
	jr ConfigScreenDPadLeft.left_or_right

ConfigScreenDPadLeft: ; 10706 (4:4706)
	ld a, $ff
.left_or_right
	push af
	ld a, [wConfigCursorYPos]
	call HideRightArrowCursor
	pop af
	call Func_1071e
	ld a, [wConfigCursorYPos]
	call ShowRightArrowCursor
	xor a
	ld [wCursorBlinkTimer], a
	ret

Func_1071e: ; 1071e (4:471e)
	push af
	ld a, [wConfigCursorYPos]
	ld c, a
	add a
	add c
	ld c, a
	ld b, $00
	ld hl, Unknown_1074d
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld c, [hl]
	ld a, [de]
	ld b, a
	pop af
	add b
	cp c
	jr c, .asm_10742
	jr z, .asm_10742
	cp $80
	jr c, .asm_10741
	ld a, c
	jr .asm_10742
.asm_10741
	xor a
.asm_10742
	ld [de], a
	ld a, c
	or a
	jr z, .asm_1074c
	ld a, SFX_01
	call PlaySFX
.asm_1074c
	ret

Unknown_1074d: ; 1074d (4:474d)
; x pos variable, max x value
	dwb wConfigMessageSpeedCursorPos, 4
	dwb wConfigDuelAnimationCursorPos, 2
	dwb wConfigExitSettingsCursorPos, 0

Func_10756: ; 10756 (4:4756)
	push hl
	push bc
	xor a
	ld [wPCPackSelection], a
	ld hl, wPCPacks
	ld c, NUM_PC_PACKS
.asm_10761
	ld [hli], a
	dec c
	jr nz, .asm_10761
	ld a, $1
	call TryGivePCPack
	pop bc
	pop hl
	ret

_PCMenu_ReadMail: ; 1076d (4:476d)
	ld a, [wd291]
	push af
	call Func_10000
	lb de, $30, $ff
	call SetupText
	lb de,  0,  0
	lb bc, 20, 12
	call DrawRegularTextBox
	lb de,  0, 12
	lb bc, 20,  6
	call DrawRegularTextBox
	ld hl, Unknown_107d2
	call Func_111b3
	call Func_10996
	xor a
	ld [wCursorBlinkTimer], a
	call FlashWhiteScreen
.asm_1079c
	call DoFrameIfLCDEnabled
	ld a, [wPCPackSelection]
	call Func_1097c
	call Func_10a05
	ld hl, wCursorBlinkTimer
	inc [hl]
	call PCMailHandleDPadInput
	call PCMailHandleAInput
	ldh a, [hKeysPressed]
	and B_BUTTON
	jr z, .asm_1079c
	ld a, SFX_03
	call PlaySFX
	pop af
	ld [wd291], a
	ret

; unreferenced?
Unknown_107c2: ; 107c2 (4:47c2)
	db $01, $00, $00, $4a, $21, $b5, $42, $e0
	db $03, $4a, $29, $94, $52, $fF, $7f, $00

Unknown_107d2: ; 107d2 (4:47d2)
	db 1, 0
	tx Text0359

	db 1, 14
	tx Text035a

	db 0, 20
	tx Text035b

	db $ff

PCMailHandleDPadInput: ; 107df (4:47df)
	ldh a, [hDPadHeld]
	and D_PAD
	ret z
	farcall GetDirectionFromDPad
	ld [wPCLastDirectionPressed], a
	ld a, [wPCPackSelection]
	push af
	call Func_10989
.asm_107f2
	ld a, [wPCPackSelection]
	add a
	add a
	ld c, a
	ld a, [wPCLastDirectionPressed]
	add c
	ld c, a
	ld b, $00
	ld hl, PCMailTransitionTable
	add hl, bc
	ld a, [hl]
	ld [wPCPackSelection], a
	ld c, a
	ld hl, wPCPacks
	add hl, bc
	ld a, [hl]
	or a
	jr z, .asm_107f2
	pop af
	ld c, a
	ld a, [wPCPackSelection]
	cp c
	jr z, .asm_1081d
	ld a, SFX_01
	call PlaySFX
.asm_1081d
	call Func_10985
	xor a
	ld [wCursorBlinkTimer], a
	ret

PCMailTransitionTable: ; 10825 (4:4825)
; up, right, down, left
	db $0c, $01, $03, $02 ; mail 1
	db $0d, $02, $04, $00 ; mail 2
	db $0e, $00, $05, $01 ; mail 3
	db $00, $04, $06, $05 ; mail 4
	db $01, $05, $07, $03 ; mail 5
	db $02, $03, $08, $04 ; mail 6
	db $03, $07, $09, $08 ; mail 7
	db $04, $08, $0a, $06 ; mail 8
	db $05, $06, $0b, $07 ; mail 9
	db $06, $0a, $0c, $0b ; mail 10
	db $07, $0b, $0d, $09 ; mail 11
	db $08, $09, $0e, $0a ; mail 12
	db $09, $0d, $00, $0e ; mail 13
	db $0a, $0e, $01, $0c ; mail 14
	db $0b, $0c, $02, $0d ; mail 15

PCMailHandleAInput: ; 10861 (4:4861)
	ldh a, [hKeysPressed]
	and A_BUTTON
	ret z
	ld a, SFX_02
	call PlaySFX
	call Func_10996
	call Func_10985
	ld a, [wPCPackSelection]
	ld c, a
	ld b, $00
	ld hl, wPCPacks
	add hl, bc
	ld a, [hl]
	ld [wSelectedPCPack], a
	and $7f
	ld [hl], a
	or a
	ret z
	add a
	add a
	ld c, a
	ld hl, PCMailTextPages
	add hl, bc
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	ld a, [wPCPackSelection]
	call Func_109ab
	call PrintScrollableText_WithTextBoxLabel
	call TryOpenPCMailBoosterPack
	call Func_10000
	lb de, $30, $ff
	call SetupText
	lb de,  0,  0
	lb bc, 20, 12
	call DrawRegularTextBox
	ld hl, Unknown_107d2
	call Func_111b3
	call Func_10996
	call Func_10985
	call FlashWhiteScreen
	pop hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .no_page_two
	ld a, [wPCPackSelection]
	call Func_109ab
	call PrintScrollableText_WithTextBoxLabel
.no_page_two
	lb de,  0, 12
	lb bc, 20,  6
	call DrawRegularTextBox
	ld hl, Unknown_107d2
	call Func_111b3
	call DoFrameIfLCDEnabled
	ret

PCMailTextPages: ; 108e0 (4:48e0)
	; unused
	dw NULL
	dw NULL

	; mail 1
	tx Text0401
	tx Text0402

	; mail 2
	tx Text0403
	tx Text0404

	; mail 3
	tx Text0405
	tx Text0406

	; mail 4
	tx Text0407
	tx Text0408

	; mail 5
	tx Text0409
	tx Text040a

	; mail 6
	tx Text040b
	tx Text040c

	; mail 7
	tx Text040d
	tx Text040e

	; mail 8
	tx Text040f
	tx Text0410

	; mail 9
	tx Text0411
	tx Text0412

	; mail 10
	tx Text0413
	dw NULL

	; mail 11
	tx Text0414
	dw NULL

	; mail 12
	tx Text0415
	dw NULL

	; mail 13
	tx Text0416
	dw NULL

	; mail 14
	tx Text0417
	dw NULL

	; mail 15
	tx Text0418
	dw NULL

TryOpenPCMailBoosterPack: ; 10920 (4:4920)
	xor a
	ld [wAnotherBoosterPack], a
	ld a, [wSelectedPCPack]
	bit 7, a
	jr z, .booster_already_open
	and $7f
	add a
	ld c, a
	ld b, $00
	ld hl, PCMailBoosterPacks
	add hl, bc
	ld a, [hli]
	push hl
	call GiveBoosterPack
	ld a, $01
	ld [wAnotherBoosterPack], a
	pop hl
	ld a, [hl]
	or a
	jr z, .done
	call GiveBoosterPack
.done
	call DisableLCD
	ret

.booster_already_open
	call Func_10000
	lb de, $30, $ff
	call SetupText
	ldtx hl, Text0419
	call PrintScrollableText_NoTextBoxLabel
	jr .done

PCMailBoosterPacks: ; 1095c (4:495c)
	db $00, $00 ; unused
	db BOOSTER_COLOSSEUM_NEUTRAL, $00 ; mail 1
	db BOOSTER_LABORATORY_PSYCHIC, $00 ; mail 2
	db BOOSTER_EVOLUTION_GRASS, $00 ; mail 3
	db BOOSTER_MYSTERY_LIGHTNING_COLORLESS, $00 ; mail 4
	db BOOSTER_EVOLUTION_FIGHTING, $00 ; mail 5
	db BOOSTER_COLOSSEUM_FIRE, $00 ; mail 6
	db BOOSTER_LABORATORY_PSYCHIC, $00 ; mail 7
	db BOOSTER_LABORATORY_PSYCHIC, $00 ; mail 8
	db BOOSTER_MYSTERY_WATER_COLORLESS, $00 ; mail 9
	db BOOSTER_COLOSSEUM_NEUTRAL, BOOSTER_EVOLUTION_NEUTRAL ; mail 10
	db BOOSTER_MYSTERY_NEUTRAL, BOOSTER_LABORATORY_NEUTRAL ; mail 11
	db BOOSTER_COLOSSEUM_TRAINER, $00 ; mail 12
	db BOOSTER_EVOLUTION_TRAINER, $00 ; mail 13
	db BOOSTER_MYSTERY_TRAINER_COLORLESS, $00 ; mail 14
	db BOOSTER_LABORATORY_TRAINER, $00 ; mail 15

Func_1097c: ; 1097c (4:497c)
	ld a, [wCursorBlinkTimer]
	and $10
	jr z, Func_10985
	jr Func_10989
Func_10985: ; 10985 (4:4985)
	ld a, SYM_CURSOR_R
	jr Func_1098d
Func_10989: ; 10989 (4:4989)
	ld a, SYM_SPACE
	jr Func_1098d
Func_1098d: ; 1098d (4:498d)
	push af
	call Func_10a41
	pop af
	call WriteByteToBGMap0
	ret

Func_10996: ; 10996 (4:4996)
	ld e, $00
	ld hl, wPCPacks
.asm_1099b
	ld a, [hl]
	or a
	jr z, .asm_109a3
	ld a, e
	call Func_109d7
.asm_109a3
	inc hl
	inc e
	ld a, e
	cp $0f
	jr c, .asm_1099b
	ret

Func_109ab: ; 109ab (4:49ab)
	push hl
	add a
	ld e, a
	ld d, $00
	ld hl, Unknown_109b9
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ret

Unknown_109b9: ; 109b9 (4:49b9)
	tx Text035d
	tx Text035e
	tx Text035f
	tx Text0360
	tx Text0361
	tx Text0362
	tx Text0363
	tx Text0364
	tx Text0365
	tx Text0366
	tx Text0367
	tx Text0368
	tx Text0369
	tx Text036a
	tx Text036b

Func_109d7: ; 109d7 (4:49d7)
	push hl
	push bc
	push de
	push af
	call Func_109ab
	ld l, e
	ld h, d
	pop af
	call Func_10a2f
	ld e, c
	ld d, b
	call InitTextPrinting
	call PrintTextNoDelay
	pop de
	pop bc
	pop hl
	ret

Func_109f0: ; 109f0 (4:49f0)
	push hl
	push bc
	push de
	call Func_10a2f
	ld e, c
	ld d, b
	call InitTextPrinting
	ldtx hl, Text035c
	call PrintTextNoDelay
	pop de
	pop bc
	pop hl
	ret

Func_10a05: ; 10a05 (4:4a05)
	ld e, $00
	ld hl, wPCPacks
.asm_10a0a
	ld a, [hl]
	or a
	jr z, .asm_10a27
	bit 7, a
	jr z, .asm_10a27
	ld a, [wCursorBlinkTimer]
	and $0c
	jr z, .asm_10a23
	cp $0c
	jr nz, .asm_10a27
	ld a, e
	call Func_109f0
	jr .asm_10a27
.asm_10a23
	ld a, e
	call Func_109d7
.asm_10a27
	inc hl
	inc e
	ld a, e
	cp $0f
	jr c, .asm_10a0a
	ret

Func_10a2f: ; 10a2f (4:4a2f)
	ld c, a
	ld a, [wPCPackSelection]
	push af
	ld a, c
	ld [wPCPackSelection], a
	call Func_10a41
	inc b
	pop af
	ld [wPCPackSelection], a
	ret

Func_10a41: ; 10a41 (4:4a41)
	push hl
	ld a, [wPCPackSelection]
	add a
	ld c, a
	ld b, $00
	ld hl, PCMailCoordinates
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	ret

PCMailCoordinates: ; 10a52 (4:4a52)
	db  1,  2 ; mail 1
	db  7,  2 ; mail 2
	db 13,  2 ; mail 3
	db  1,  4 ; mail 4
	db  7,  4 ; mail 5
	db 13,  4 ; mail 6
	db  1,  6 ; mail 7
	db  7,  6 ; mail 8
	db 13,  6 ; mail 9
	db  1,  8 ; mail 10
	db  7,  8 ; mail 11
	db 13,  8 ; mail 12
	db  1, 10 ; mail 13
	db  7, 10 ; mail 14
	db 13, 10 ; mail 15

; gives the pc pack described in a
TryGivePCPack: ; 10a70 (4:4a70)
	push hl
	push bc
	push de
	ld b, a
	ld c, NUM_PC_PACKS
	ld hl, wPCPacks
.searchLoop1
	ld a, [hli]
	and $7f
	cp b
	jr z, .quit
	dec c
	jr nz, .searchLoop1
	ld c, NUM_PC_PACKS
	ld hl, wPCPacks
.findFreeSlotLoop
	ld a, [hl]
	and $7f
	jr z, .foundFreeSlot
	inc hl
	dec c
	jr nz, .findFreeSlotLoop
	debug_nop
	jr .quit

.foundFreeSlot
	ld a, b
	or PACK_OPENED ; mark pack as unopened
	ld [hl], a

.quit
	pop de
	pop bc
	pop hl
	ret

; writes wd293 with byte depending on console
; every entry in the list is $00
Func_10a9b: ; 10a9b (4:4a9b)
	push hl
	ld a, [wConsole]
	add LOW(.data_10ab1)
	ld l, a
	ld a, HIGH(.data_10ab1)
	adc 0
	ld h, a
	ld a, [hl]
	ld [wd293], a
	xor a
	ld [wd317], a
	pop hl
	ret

.data_10ab1
	db $00 ; CONSOLE_DMG
	db $00 ; CONSOLE_SGB
	db $00 ; CONSOLE_CGB

Func_10ab4: ; 10ab4 (4:4ab4)
	ld a, [wLCDC]
	bit 7, a
	jr z, .lcd_off
	ld a, [wd293]
	ld [wd294], a
	ld [wd295], a
	ld [wd296], a
	ld de, PALRGB_WHITE
	ld hl, wTempBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes
	call FillMemoryWithDE
	call RestoreFirstColorInOBPals
	call FadeScreenToTempPals
	call DisableLCD
	ret

.lcd_off
	ld a, [wd293]
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	ld de, PALRGB_WHITE
	ld hl, wBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes
	call FillMemoryWithDE
	call FlushAllPalettes
	ret

Func_10af9: ; 10af9 (4:4af9)
	call BackupPalsAndSetWhite
	call RestoreFirstColorInOBPals
	call FlushAllPalettes
	call EnableLCD
	jp FadeScreenToTempPals

BackupPalsAndSetWhite: ; 10b08 (4:4b08)
	ld a, [wBGP]
	ld [wd294], a
	ld a, [wOBP0]
	ld [wd295], a
	ld a, [wOBP1]
	ld [wd296], a
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes + NUM_OBJECT_PALETTES palettes
	call CopyDataHLtoDE_SaveRegisters
	jr Func_10b28 ; can be fallthrough

; fills wBackgroundPalettesCGB with white pal
Func_10b28: ; 10b28 (4:4b28)
	ld a, [wd293]
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	ld de, PALRGB_WHITE
	ld hl, wBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes
	call FillMemoryWithDE
	ret

; gets from backup OB pals the first color
; of each pal and writes them in wObjectPalettesCGB
RestoreFirstColorInOBPals: ; 10b41 (4:4b41)
	ld hl, wTempObjectPalettesCGB
	ld de, wObjectPalettesCGB
	ld c, NUM_OBJECT_PALETTES
.loop_pals
	push bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld bc, CGB_PAL_SIZE - 1
	add hl, bc
	ld a, c
	add e
	ld e, a
	ld a, b
	adc d
	ld d, a
	pop bc
	dec c
	jr nz, .loop_pals
	ret

FadeScreenToTempPals: ; 10b5e (4:4b5e)
	ld a, [wVBlankCounter]
	push af
	ld c, $10
.loop
	push bc
	ld a, c
	and %11
	cp 0
	call z, Func_10b85
	call FadeBGPalIntoTemp3
	call FadeOBPalIntoTemp
	call FlushAllPalettes
	call DoFrameIfLCDEnabled
	pop bc
	dec c
	dec c
	jr nz, .loop
	pop af
	ld b, a
	ld a, [wVBlankCounter]
	sub b
	ret

; does something with wBGP given wd294
; mixes them into a single value?
Func_10b85: ; 10b85 (4:4b85)
	push bc
	ld c, $03
	ld hl, wBGP
	ld de, wd294
.asm_10b8e
	push bc
	ld b, [hl]
	ld a, [de]
	ld c, a
	call .Func_10b9e
	ld [hl], a
	pop bc
	inc de
	inc hl
	dec c
	jr nz, .asm_10b8e
	pop bc
	ret

.Func_10b9e
	push bc
	push de
	ld e, 4
	ld d, $00
.loop
	call .Func_10bba
	or d
	rlca
	rlca
	ld d, a
	rlc b
	rlc b
	rlc c
	rlc c
	dec e
	jr nz, .loop
	ld a, d
	pop de
	pop bc
	ret

; calculates ((b & %11) << 2) | (c & %11)
; that is, %0000xxyy, where x and y are
; the 2 lower bits of b and c respectively
; and outputs the entry from a table given that value
.Func_10bba
	push hl
	push bc
	ld a, %11
	and b
	add a
	add a
	ld b, a
	ld a, %11
	and c
	or b
	ld c, a
	ld b, $00
	ld hl, .data_10bd1
	add hl, bc
	ld a, [hl]
	pop bc
	pop hl
	ret

.data_10bd1
	db %00 ; b = %00 | c = %00
	db %01 ; b = %00 | c = %01
	db %01 ; b = %00 | c = %10
	db %01 ; b = %00 | c = %11
	db %00 ; b = %01 | c = %00
	db %01 ; b = %01 | c = %01
	db %10 ; b = %01 | c = %10
	db %10 ; b = %01 | c = %11
	db %01 ; b = %10 | c = %00
	db %01 ; b = %10 | c = %01
	db %10 ; b = %10 | c = %10
	db %11 ; b = %10 | c = %11
	db %10 ; b = %11 | c = %00
	db %10 ; b = %11 | c = %01
	db %10 ; b = %11 | c = %10
	db %11 ; b = %11 | c = %11

FadeOBPalIntoTemp: ; 10be1 (4:4be1)
	push bc
	ld c, 4 palettes
	ld hl, wObjectPalettesCGB
	ld de, wTempObjectPalettesCGB
	jr FadePalIntoAnother

FadeBGPalIntoTemp1: ; 10bec (4:4bec)
	push bc
	ld c, 2 palettes
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	jr FadePalIntoAnother

FadeBGPalIntoTemp2: ; 10bf7 (4:4bf7)
	push bc
	ld c, 2 palettes
	ld hl, wBackgroundPalettesCGB + 4 palettes
	ld de, wTempBackgroundPalettesCGB + 4 palettes
	jr FadePalIntoAnother

FadeBGPalIntoTemp3: ; 10c02 (4:4c02)
	push bc
	ld c, 4 palettes
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
;	fallthrough

; hl = input pal to modify
; de = pal to fade into
; c = number of colors to fade
FadePalIntoAnother: ; 10c0b (4:4c0b)
	push bc
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	push de
	push bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop de
	call .GetFadedColor
	; overwrite with new color
	ld [hld], a
	ld [hl], c
	inc hl
	inc hl
	pop de
	pop bc
	dec c
	jr nz, FadePalIntoAnother
	pop bc
	ret

; fade pal bc to de
; output resulting pal in a and c
.GetFadedColor
	push hl
	ld a, c
	cp e
	jr nz, .unequal
	ld a, b
	cp d
	jr z, .skip

.unequal
	; red
	ld a, e
	and %11111
	ld l, a
	ld a, c
	and %11111
	call .FadeColor
	ldh [hffb6], a

	; green
	ld a, e
	and %11100000
	ld l, a
	ld a, d
	and %11
	or l
	swap a
	rrca
	ld l, a
	ld a, c
	and %11100000
	ld h, a
	ld a, b
	and %11
	or h
	swap a
	rrca
	call .FadeColor
	rlca
	swap a
	ld h, a
	and %11
	ldh [hffb7], a
	ld a, %11100000
	and h
	ld h, a
	ldh a, [hffb6]
	or h
	ld h, a

	; blue
	ld a, d
	and %1111100
	rrca
	rrca
	ld l, a
	ld a, b
	and %1111100
	rrca
	rrca
	call .FadeColor
	rlca
	rlca
	ld b, a
	ldh a, [hffb7]
	or b
	ld c, h
.skip
	pop hl
	ret

; compares color in a and in l
; if a is smaller/greater than l, then
; increase/decrease its value up to l
; up to a maximum of 4
; a = pal color (red, green or blue)
; l = pal color (red, green or blue)
.FadeColor
	cp l
	ret z ; same value
	jr c, .incr_a
; decr a
	dec a
	cp l
	ret z
	dec a
	cp l
	ret z
	dec a
	cp l
	ret z
	dec a
	ret

.incr_a
	inc a
	cp l
	ret z
	inc a
	cp l
	ret z
	inc a
	cp l
	ret z
	inc a
	ret

Func_10c96: ; 10c96 (4:4c96)
	ldh a, [hBankSRAM]
	push af
	push bc
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	call CopyPalsToSRAMBuffer
	call Func_10ab4
	pop bc
	ld a, c
	or a
	jr nz, .asm_10cb0
	call LoadPalsFromSRAMBuffer
	call Func_10af9

.asm_10cb0
	call EnableLCD
	pop af
	call BankswitchSRAM
	call DisableSRAM
	ret

; copies current BG and OP pals,
; wBackgroundPalettesCGB and wObjectPalettesCGB
; to sGfxBuffer2
CopyPalsToSRAMBuffer: ; 10cbb (4:4cbb)
	ldh a, [hBankSRAM]

	push af
	cp BANK("SRAM1")
	jr z, .ok
	debug_nop
.ok
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	ld hl, sGfxBuffer2
	ld a, [wBGP]
	ld [hli], a
	ld a, [wOBP0]
	ld [hli], a
	ld a, [wOBP1]
	ld [hli], a
	ld e, l
	ld d, h
	ld hl, wBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes + NUM_OBJECT_PALETTES palettes
	call CopyDataHLtoDE_SaveRegisters
	pop af

	call BankswitchSRAM
	call DisableSRAM
	ret

; loads BG and OP pals,
; wBackgroundPalettesCGB and wObjectPalettesCGB
; from sGfxBuffer2
LoadPalsFromSRAMBuffer: ; 10cea (4:4cea)
	ldh a, [hBankSRAM]

	push af
	cp BANK("SRAM1")
	jr z, .ok
	debug_nop
.ok
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	ld hl, sGfxBuffer2
	ld a, [hli]
	ld [wBGP], a
	ld a, [hli]
	ld [wOBP0], a
	ld a, [hli]
	ld [wOBP1], a
	ld de, wBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes + NUM_OBJECT_PALETTES palettes
	call CopyDataHLtoDE_SaveRegisters
	pop af

	call BankswitchSRAM
	call DisableSRAM
	ret

; backs up all palettes
; and writes 4 BG pals with white pal
Func_10d17: ; 10d17 (4:4d17)
	ld a, [wBGP]
	ld [wd294], a
	ld a, [wOBP0]
	ld [wd295], a
	ld a, [wOBP1]
	ld [wd296], a
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes + NUM_OBJECT_PALETTES palettes
	call CopyDataHLtoDE_SaveRegisters

	ld a, [wd293]
	ld [wBGP], a
	ld de, PALRGB_WHITE
	ld hl, wBackgroundPalettesCGB
	ld bc, 4 palettes
	call FillMemoryWithDE
	call FlushAllPalettes

	ld a, $10
	ld [wd317], a
	ret

Func_10d50: ; 10d50 (4:4d50)
	ld a, [wd293]
	ld [wd294], a
	ld a, [wOBP0]
	ld [wd295], a
	ld a, [wOBP1]
	ld [wd296], a
	ld de, PALRGB_WHITE
	ld hl, wTempBackgroundPalettesCGB
	ld bc, 4 palettes
	call FillMemoryWithDE
	ld a, $10
	ld [wd317], a
	ret

; does stuff according to bottom 2 bits from wd317:
; - if equal to %01, modify wBGP
; - if bottom bit not set, fade BG pals 0 and 1
; - if bottom bit is set, fade BG pals 4 and 5
;   and Flush Palettes
; then decrements wd317
; does nothing if wd317 is 0
Func_10d74: ; 10d74 (4:4d74)
	ld a, [wd317]
	or a
	ret z
	and %11
	ld c, a
	cp $1
	call z, Func_10b85
	bit 0, c
	call z, FadeBGPalIntoTemp1
	bit 0, c
	call nz, FadeBGPalIntoTemp2
	bit 0, c
	call nz, FlushAllPalettes
	ld a, [wd317]
	dec a
	ld [wd317], a
	ret

Unknown_10d98: ; 10d98 (4:4d98)
	db 12,  0 ; start menu coords
	db  8, 14 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx PauseMenuOptionsText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 6 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_10da9: ; 10da9 (4:4da9)
	db 10,  0 ; start menu coords
	db 10, 12 ; start menu text box dimensions

	db 12, 2 ; text alignment for InitTextPrinting
	tx Text0351
	db $ff

	db 11, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Func_10dba: ; 10dba (4:4dba)
	ld a, 1 << AUTO_CLOSE_TEXTBOX
	farcall SetOverworldNPCFlags
	ld a, [wSelectedGiftCenterMenuItem]
	ld hl, Unknown_10e17
	farcall InitAndPrintPauseMenu
.asm_10dca
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .asm_10dca
	ld a, e
	ld [wSelectedGiftCenterMenuItem], a
	ldh a, [hCurMenuItem]
	cp e
	jr z, .asm_10ddd
	ld a, $4

.asm_10ddd
	ld [wd10e], a
	push af
	ld hl, Unknown_10df0
	call JumpToFunctionInTable
	farcall CloseTextBox
	call DoFrameIfLCDEnabled
	pop af
	ret

Unknown_10df0: ; 10df0 (4:4df0)
	dw Func_10dfb
	dw Func_10dfb
	dw Func_10dfb
	dw Func_10dfb
	dw Func_10dfa

Func_10dfa: ; 10dfa (4:4dfa)
	ret

Func_10dfb: ; 10dfb (4:4dfb)
	ld a, [wd10e]
	add a
	ld c, a
	ld b, $00
	ld hl, Unknown_10e0f
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	ret

Unknown_10e0f: ; 10e0f (4:4e0f)
	tx Text0355
	tx Text0356
	tx Text0357
	tx Text0358

Unknown_10e17: ; 10e17 (4:4e17)
	db  4,  0 ; start menu coords
	db 16, 12 ; start menu text box dimensions

	db  6, 2 ; text alignment for InitTextPrinting
	tx Text0354
	db $ff

	db 5, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; refresh the cursor's position based on the currently selected map
; and refresh the player's position based on the starting map
; but only if the player is not being animated across the overworld
OverworldMap_UpdatePlayerAndCursorSprites: ; 10e28 (4:4e28)
	push hl
	push bc
	push de
	ld a, [wOverworldMapCursorSprite]
	ld [wWhichSprite], a
	ld a, [wOverworldMapSelection]
	ld d, 0
	ld e, -12
	call OverworldMap_SetSpritePosition
	ld a, [wOverworldMapPlayerAnimationState]
	or a
	jr nz, .player_walking
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wOverworldMapStartingPosition]
	ld d, 0
	ld e, 0
	call OverworldMap_SetSpritePosition
.player_walking
	pop de
	pop bc
	pop hl
	ret

; if no selection has been made yet, call OverworldMap_HandleKeyPress
; if the player is being animated across the screen, call OverworldMap_UpdatePlayerWalkingAnimation
; if the player has finished walking, call OverworldMap_LoadSelectedMap
OverworldMap_Update: ; 10e55 (4:4e55)
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wOverworldMapPlayerAnimationState]
	or a
	jr nz, .player_walking
	call OverworldMap_HandleKeyPress
	ret
.player_walking
	cp 2
	jr z, .player_finished_walking
	call OverworldMap_UpdatePlayerWalkingAnimation
	ret
.player_finished_walking
	call OverworldMap_LoadSelectedMap
	ret

; update the map selection if the DPad is pressed
; or finalize the selection if the A button is pressed
OverworldMap_HandleKeyPress: ; 10e71 (4:4e71)
	ldh a, [hKeysPressed]
	and D_PAD
	jr z, .no_d_pad
	farcall GetDirectionFromDPad
	ld [wPlayerDirection], a
	call OverworldMap_HandleDPad
	jr .done
.no_d_pad
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .done
	ld a, SFX_02
	call PlaySFX
	call OverworldMap_UpdateCursorAnimation
	call OverworldMap_BeginPlayerMovement
	jr .done
.done
	ret

; update wOverworldMapSelection based on the pressed direction in wPlayerDirection
OverworldMap_HandleDPad: ; 10e97 (4:4e97)
	push hl
	pop hl
	ld a, [wOverworldMapSelection]
	rlca
	rlca
	ld c, a
	ld a, [wPlayerDirection]
	add c
	ld c, a
	ld b, 0
	ld hl, OverworldMap_CursorTransitions
	add hl, bc
	ld a, [hl]
	or a
	jr z, .no_transition
	ld [wOverworldMapSelection], a
	call OverworldMap_PrintMapName
	ld a, SFX_01
	call PlaySFX
.no_transition
	pop bc
	pop hl
	ret

OverworldMap_CursorTransitions: ; 10ebc (4:4ebc)
	; unused
	db OWMAP_SCIENCE_CLUB     ; NORTH
	db OWMAP_SCIENCE_CLUB     ; EAST
	db OWMAP_SCIENCE_CLUB     ; SOUTH
	db OWMAP_SCIENCE_CLUB     ; WEST

	; OWMAP_MASON_LABORATORY
	db OWMAP_LIGHTNING_CLUB   ; NORTH
	db OWMAP_FIGHTING_CLUB    ; EAST
	db $00                    ; SOUTH
	db $00                    ; WEST

	; OWMAP_ISHIHARAS_HOUSE
	db $00                    ; NORTH
	db OWMAP_CHALLENGE_HALL   ; EAST
	db OWMAP_ROCK_CLUB        ; SOUTH
	db $00                    ; WEST

	; OWMAP_FIGHTING_CLUB
	db OWMAP_LIGHTNING_CLUB   ; NORTH
	db OWMAP_WATER_CLUB       ; EAST
	db $00                    ; SOUTH
	db OWMAP_MASON_LABORATORY ; WEST

	; OWMAP_ROCK_CLUB
	db OWMAP_ISHIHARAS_HOUSE  ; NORTH
	db OWMAP_POKEMON_DOME     ; EAST
	db OWMAP_LIGHTNING_CLUB   ; SOUTH
	db $00                    ; WEST

	; OWMAP_WATER_CLUB
	db OWMAP_GRASS_CLUB       ; NORTH
	db $00                    ; EAST
	db $00                    ; SOUTH
	db OWMAP_FIGHTING_CLUB    ; WEST

	; OWMAP_LIGHTNING_CLUB
	db OWMAP_ROCK_CLUB        ; NORTH
	db OWMAP_POKEMON_DOME     ; EAST
	db OWMAP_FIGHTING_CLUB    ; SOUTH
	db OWMAP_MASON_LABORATORY ; WEST

	; OWMAP_GRASS_CLUB
	db OWMAP_SCIENCE_CLUB     ; NORTH
	db $00                    ; EAST
	db OWMAP_WATER_CLUB       ; SOUTH
	db OWMAP_PSYCHIC_CLUB     ; WEST

	; OWMAP_PSYCHIC_CLUB
	db OWMAP_FIRE_CLUB        ; NORTH
	db OWMAP_SCIENCE_CLUB     ; EAST
	db OWMAP_GRASS_CLUB       ; SOUTH
	db OWMAP_POKEMON_DOME     ; WEST

	; OWMAP_SCIENCE_CLUB
	db OWMAP_FIRE_CLUB        ; NORTH
	db $00                    ; EAST
	db OWMAP_GRASS_CLUB       ; SOUTH
	db OWMAP_PSYCHIC_CLUB     ; WEST

	; OWMAP_FIRE_CLUB
	db $00                    ; NORTH
	db OWMAP_SCIENCE_CLUB     ; EAST
	db OWMAP_SCIENCE_CLUB     ; SOUTH
	db OWMAP_PSYCHIC_CLUB     ; WEST

	; OWMAP_CHALLENGE_HALL
	db $00                    ; NORTH
	db OWMAP_PSYCHIC_CLUB     ; EAST
	db OWMAP_POKEMON_DOME     ; SOUTH
	db OWMAP_ISHIHARAS_HOUSE  ; WEST

	; OWMAP_POKEMON_DOME
	db OWMAP_CHALLENGE_HALL   ; NORTH
	db OWMAP_PSYCHIC_CLUB     ; EAST
	db OWMAP_FIGHTING_CLUB    ; SOUTH
	db OWMAP_ROCK_CLUB        ; WEST

; set the active sprite (player or cursor) at the appropriate map position
; input:
; a = OWMAP_* value
; d = x offset
; e = y offset
OverworldMap_SetSpritePosition: ; 10ef0 (4:4ef0)
	call OverworldMap_GetMapPosition
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	ret

; input:
; a = OWMAP_* value
; d = x offset
; e = y offset
; output:
; d = x position
; e = y position
OverworldMap_GetMapPosition: ; 10efd (4:4efd)
	push hl
	push de
	rlca
	ld e, a
	ld d, 0
	ld hl, OverworldMap_MapPositions
	add hl, de
	pop de
	ld a, [hli]
	add $8
	add d
	ld d, a
	ld a, [hl]
	add $10
	add e
	ld e, a
	pop hl
	ret

OverworldMap_MapPositions: ; 10f14 (4:4f14)
	db $00, $00 ; unused
	db $0c, $68 ; OWMAP_MASON_LABORATORY
	db $04, $18 ; OWMAP_ISHIHARAS_HOUSE
	db $34, $68 ; OWMAP_FIGHTING_CLUB
	db $14, $38 ; OWMAP_ROCK_CLUB
	db $6c, $64 ; OWMAP_WATER_CLUB
	db $24, $50 ; OWMAP_LIGHTNING_CLUB
	db $7c, $40 ; OWMAP_GRASS_CLUB
	db $5c, $2c ; OWMAP_PSYCHIC_CLUB
	db $7c, $20 ; OWMAP_SCIENCE_CLUB
	db $6c, $10 ; OWMAP_FIRE_CLUB
	db $3c, $20 ; OWMAP_CHALLENGE_HALL
	db $44, $44 ; OWMAP_POKEMON_DOME

OverworldMap_PrintMapName: ; 10f2e (4:4f2e)
	push hl
	push de
	lb de, 1, 1
	call InitTextPrinting
	call OverworldMap_GetOWMapID
	rlca
	ld e, a
	ld d, 0
	ld hl, OverworldMapNames
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	pop de
	pop hl
	ret

; returns [wOverworldMapSelection] in a
; or OWMAP_MYSTERY_HOUSE if [wOverworldMapSelection] == OWMAP_ISHIHARAS_HOUSE
;   and EVENT_ISHIHARAS_HOUSE_MENTIONED == FALSE
OverworldMap_GetOWMapID: ; 10f4a (4:4f4a)
	push bc
	ld a, [wOverworldMapSelection]
	cp OWMAP_ISHIHARAS_HOUSE
	jr nz, .got_map
	ld c, a
	ld a, EVENT_ISHIHARAS_HOUSE_MENTIONED
	farcall GetEventValue
	or a
	ld a, c
	jr nz, .got_map
	ld a, OWMAP_MYSTERY_HOUSE
.got_map
	pop bc
	ret

OverworldMap_LoadSelectedMap: ; 10f61 (4:4f61)
	push hl
	push bc
	ld a, [wOverworldMapSelection]
	rlca
	rlca
	ld c, a
	ld b, 0
	ld hl, OverworldMapIndexes
	add hl, bc
	ld a, [hli]
	ld [wTempMap], a
	ld a, [hli]
	ld [wTempPlayerXCoord], a
	ld a, [hli]
	ld [wTempPlayerYCoord], a
	ld a, NORTH
	ld [wTempPlayerDirection], a
	ld hl, wOverworldTransition
	set 4, [hl]
	pop bc
	pop hl
	ret

INCLUDE "data/overworld_indexes.asm"

OverworldMap_InitVolcanoSprite: ; 10fbc (4:4fbc)
	ld a, SPRITE_OW_MAP_OAM
	farcall CreateSpriteAndAnimBufferEntry
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, $80
	ld [hli], a ; x
	ld a, $10
	ld [hl], a ; y
	ld b, SPRITE_ANIM_SGB_VOLCANO_SMOKE
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld b, SPRITE_ANIM_CGB_VOLCANO_SMOKE
.not_cgb
	ld a, b
	farcall StartNewSpriteAnimation
	ret

OverworldMap_InitCursorSprite: ; 10fde (4:4fde)
	ld a, [wOverworldMapSelection]
	ld [wOverworldMapStartingPosition], a
	xor a
	ld [wOverworldMapPlayerAnimationState], a
	ld a, SPRITE_OW_MAP_OAM
	call CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [wOverworldMapCursorSprite], a
	ld b, SPRITE_ANIM_SGB_OWMAP_CURSOR
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld b, SPRITE_ANIM_CGB_OWMAP_CURSOR
.not_cgb
	ld a, b
	ld [wOverworldMapCursorAnimation], a
	call StartNewSpriteAnimation
	ld a, EVENT_MASON_LAB_STATE
	farcall GetEventValue
	or a
	jr nz, .visited_lab
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	set SPRITE_ANIM_FLAG_UNSKIPPABLE, [hl]
.visited_lab
	ret

; play animation SPRITE_ANIM_SGB_OWMAP_CURSOR_FAST (non-cgb) or SPRITE_ANIM_CGB_OWMAP_CURSOR_FAST (cgb)
; to make the cursor blink faster after a selection is made
OverworldMap_UpdateCursorAnimation: ; 11016 (4:5016)
	ld a, [wOverworldMapCursorSprite]
	ld [wWhichSprite], a
	ld a, [wOverworldMapCursorAnimation]
	inc a
	call StartNewSpriteAnimation
	ret

; begin walking the player across the overworld
; from wOverworldMapStartingPosition to wOverworldMapSelection
OverworldMap_BeginPlayerMovement: ; 11024 (4:5024)
	ld a, SFX_57
	call PlaySFX
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	set SPRITE_ANIM_FLAG_SPEED, [hl]

; get pointer table for starting map
	ld hl, OverworldMap_PlayerMovementPaths
	ld a, [wOverworldMapStartingPosition]
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

; get path sequence for selected map
	ld a, [wOverworldMapSelection]
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [wOverworldMapPlayerMovementPtr], a
	ld a, [hl]
	ld [wOverworldMapPlayerMovementPtr + 1], a

	ld a, 1
	ld [wOverworldMapPlayerAnimationState], a
	xor a
	ld [wOverworldMapPlayerMovementCounter], a
	ret

; update the player walking across the overworld
; either by advancing along the current path
; or determining the next direction to move along the path
OverworldMap_UpdatePlayerWalkingAnimation: ; 11060 (4:5060)
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wOverworldMapPlayerMovementCounter]
	or a
	jp nz, OverworldMap_ContinuePlayerWalkingAnimation

; get next x,y on the path
	ld a, [wOverworldMapPlayerMovementPtr]
	ld l, a
	ld a, [wOverworldMapPlayerMovementPtr + 1]
	ld h, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	and b
	cp $ff
	jr z, .player_finished_walking
	ld a, c
	or b
	jr nz, .next_point

; point 0,0 means walk straight towards [wOverworldMapSelection]
	ld a, [wOverworldMapStartingPosition]
	ld e, a
	ld a, [wOverworldMapSelection]
	cp e
	jr z, .player_finished_walking
	lb de, 0, 0
	call OverworldMap_GetMapPosition
	ld b, d
	ld c, e

.next_point
	ld a, l
	ld [wOverworldMapPlayerMovementPtr], a
	ld a, h
	ld [wOverworldMapPlayerMovementPtr + 1], a
	call OverworldMap_InitNextPlayerVelocity
	ret

.player_finished_walking
	ld a, 2
	ld [wOverworldMapPlayerAnimationState], a
	ret

; input:
; b = target x position
; c = target y position
OverworldMap_InitNextPlayerVelocity: ; 110a6 (4:50a6)
	push hl
	push bc
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty

	pop bc
	ld a, b
	sub [hl] ; a = target x - current x
	ld [wOverworldMapPlayerPathHorizontalMovement], a
	ld a, 0
	sbc 0
	ld [wOverworldMapPlayerPathHorizontalMovement + 1], a

	inc hl
	ld a, c
	sub [hl] ; a = target y - current y
	ld [wOverworldMapPlayerPathVerticalMovement], a
	ld a, 0
	sbc 0
	ld [wOverworldMapPlayerPathVerticalMovement + 1], a

	ld a, [wOverworldMapPlayerPathHorizontalMovement]
	ld b, a
	ld a, [wOverworldMapPlayerPathHorizontalMovement + 1]
	bit 7, a
	jr z, .positive
; absolute value
	ld a, [wOverworldMapPlayerPathHorizontalMovement]
	cpl
	inc a
	ld b, a

.positive
	ld a, [wOverworldMapPlayerPathVerticalMovement]
	ld c, a
	ld a, [wOverworldMapPlayerPathVerticalMovement + 1]
	bit 7, a
	jr z, .positive2
; absolute value
	ld a, [wOverworldMapPlayerPathVerticalMovement]
	cpl
	inc a
	ld c, a

.positive2
; if the absolute value of wOverworldMapPlayerPathVerticalMovement is larger than
; the absolute value of wOverworldMapPlayerPathHorizontalMovement, this is dominantly
; a north/south movement. otherwise, an east/west movement
	ld a, b
	cp c
	jr c, .north_south
	call OverworldMap_InitPlayerEastWestMovement
	jr .done
.north_south
	call OverworldMap_InitPlayerNorthSouthMovement
.done
	xor a
	ld [wOverworldMapPlayerHorizontalSubPixelPosition], a
	ld [wOverworldMapPlayerVerticalSubPixelPosition], a
	farcall UpdatePlayerSprite
	pop hl
	ret

; input:
; b = absolute value of horizontal movement distance
; c = absolute value of vertical movement distance
OverworldMap_InitPlayerEastWestMovement: ; 11102 (4:5102)
; use horizontal distance for counter
	ld a, b
	ld [wOverworldMapPlayerMovementCounter], a

; de = absolute horizontal distance, for later
	ld e, a
	ld d, 0

; overwrite wOverworldMapPlayerPathHorizontalMovement with either -1.0 or +1.0
; always move east/west by 1 pixel per frame
	ld hl, wOverworldMapPlayerPathHorizontalMovement
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .east
	dec a
	jr .west
.east
	inc a
.west
	ld [hl], a

; divide (total vertical distance * $100) by total horizontal distance
	ld b, c ; vertical distance in high byte
	ld c, 0
	call DivideBCbyDE
	ld a, [wOverworldMapPlayerPathVerticalMovement + 1]
	bit 7, a
	jr z, .positive
; restore negative sign
	call OverworldMap_NegateBC
.positive
	ld a, c
	ld [wOverworldMapPlayerPathVerticalMovement], a
	ld a, b
	ld [wOverworldMapPlayerPathVerticalMovement + 1], a

; set player direction
	ld hl, wOverworldMapPlayerPathHorizontalMovement + 1
	ld a, EAST
	bit 7, [hl]
	jr z, .east2
	ld a, WEST
.east2
	ld [wPlayerDirection], a
	ret

; input:
; b = absolute value of horizontal movement distance
; c = absolute value of vertical movement distance
OverworldMap_InitPlayerNorthSouthMovement: ; 1113e (4:513e)
; use vertical distance for counter
	ld a, c
	ld [wOverworldMapPlayerMovementCounter], a

; de = absolute vertical distance, for later
	ld e, a
	ld d, 0

; overwrite wOverworldMapPlayerPathVerticalMovement with either -1.0 or +1.0
; always move north/south by 1 pixel per frame
	ld hl, wOverworldMapPlayerPathVerticalMovement
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .south
	dec a
	jr .north
.south
	inc a
.north
	ld [hl], a

; divide (total horizontal distance * $100) by total vertical distance
; horizontal distance in high byte
	ld c, 0
	call DivideBCbyDE
	ld a, [wOverworldMapPlayerPathHorizontalMovement + 1]
	bit 7, a
	jr z, .positive
; restore negative sign
	call OverworldMap_NegateBC
.positive
	ld a, c
	ld [wOverworldMapPlayerPathHorizontalMovement], a
	ld a, b
	ld [wOverworldMapPlayerPathHorizontalMovement + 1], a

; set player direction
	ld hl, wOverworldMapPlayerPathVerticalMovement + 1
	ld a, SOUTH
	bit 7, [hl]
	jr z, .south2
	ld a, NORTH
.south2
	ld [wPlayerDirection], a
	ret

; output:
; bc = bc * -1
OverworldMap_NegateBC: ; 11179 (4:5179)
	ld a, c
	cpl
	add 1
	ld c, a
	ld a, b
	cpl
	adc 0
	ld b, a
	ret

; add the x/y speed to the current sprite position,
; accounting for sub-pixel position
; and decrement [wOverworldMapPlayerMovementCounter]
OverworldMap_ContinuePlayerWalkingAnimation: ; 11184 (4:5184)
	ld a, [wOverworldMapPlayerHorizontalSubPixelPosition]
	ld d, a
	ld a, [wOverworldMapPlayerVerticalSubPixelPosition]
	ld e, a
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, [wOverworldMapPlayerPathHorizontalMovement]
	add d
	ld d, a
	ld a, [wOverworldMapPlayerPathHorizontalMovement + 1]
	adc [hl] ; add carry from sub-pixel movement
	ld [hl], a
	inc hl
	ld a, [wOverworldMapPlayerPathVerticalMovement]
	add e
	ld e, a
	ld a, [wOverworldMapPlayerPathVerticalMovement + 1]
	adc [hl] ; add carry from sub-pixel movement
	ld [hl], a
	ld a, d
	ld [wOverworldMapPlayerHorizontalSubPixelPosition], a
	ld a, e
	ld [wOverworldMapPlayerVerticalSubPixelPosition], a
	ld hl, wOverworldMapPlayerMovementCounter
	dec [hl]
	ret

; prints $ff-terminated list of text to text box
; given 2 bytes for text alignment and 2 bytes for text ID
Func_111b3: ; 111b3 (4:51b3)
	ldh a, [hffb0]
	push af
	ld a, $02
	ldh [hffb0], a

	push hl
.loop_text_print_1
	ld d, [hl]
	inc hl
	bit 7, d
	jr nz, .next
	inc hl
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call PrintTextNoDelay
	pop hl
	inc hl
	jr .loop_text_print_1

.next
	pop hl
	pop af
	ldh [hffb0], a
.loop_text_print_2
	ld d, [hl]
	inc hl
	bit 7, d
	ret nz
	ld e, [hl]
	inc hl
	call AdjustCoordinatesForBGScroll
	call InitTextPrinting
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call PrintTextNoDelay
	pop hl
	inc hl
	jr .loop_text_print_2

InitAndPrintPauseMenu: ; 111e9 (4:51e9)
	push hl
	push bc
	push de
	push af
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	push hl
	call AdjustCoordinatesForBGScroll
	farcall Func_c3ca
	call DrawRegularTextBox
	call DoFrameIfLCDEnabled
	pop hl
	call Func_111b3
	pop af
	call InitializeMenuParameters
	pop de
	pop bc
	pop hl
	ret

; xors sb800
; this has the effect of invalidating the save data checksum
; which the game interprets as being having no save data
InvalidateSaveData: ; 1120f (4:520f)
	push hl
	ldh a, [hBankSRAM]

	push af
	ld a, BANK("SRAM2")
	call BankswitchSRAM
	ld a, $08
	xor $ff
	ld [sBackupGeneralSaveData + 0], a
	ld a, $00
	xor $ff
	ld [sBackupGeneralSaveData + 1], a
	pop af

	call BankswitchSRAM
	call DisableSRAM
	call EnableSRAM
	bank1call DiscardSavedDuelData
	call DisableSRAM
	pop hl
	ret

; saves all data to SRAM, including
; General save data and Album/Deck data
; and backs up in SRAM2
SaveAndBackupData: ; 11238 (4:5238)
	push de
	ld de, sGeneralSaveData
	call SaveGeneralSaveDataFromDE
	ld de, sAlbumProgress
	call UpdateAlbumProgress
	call WriteBackupGeneralSaveData
	call WriteBackupCardAndDeckSaveData
	pop de
	ret

_SaveGeneralSaveData: ; 1124d (4:524d)
	push de
	call GetReceivedLegendaryCards
	ld de, sGeneralSaveData
	call SaveGeneralSaveDataFromDE
	ld de, sAlbumProgress
	call UpdateAlbumProgress
	pop de
	ret

; de = pointer to general game data in SRAM
SaveGeneralSaveDataFromDE: ; 1125f (4:525f)
	push hl
	push bc
	call EnableSRAM
	push de
	farcall TryGiveMedalPCPacks
	ld [wMedalCount], a
	farcall OverworldMap_GetOWMapID
	ld [wCurOverworldMap], a
	pop de
	push de
	call CopyGeneralSaveDataToSRAM
	pop de
	call DisableSRAM
	pop bc
	pop hl
	ret

; writes in de total num of cards collected
; and in (de + 1) total num of cards to collect
; also updates wTotalNumCardsCollected and wTotalNumCardsToCollect 
UpdateAlbumProgress: ; 1127f (4:527f)
	push hl
	push de
	push de
	call GetCardAlbumProgress
	call EnableSRAM
	pop hl
	ld a, d
	ld [wTotalNumCardsCollected], a
	ld [hli], a
	ld a, e
	ld [wTotalNumCardsToCollect], a
	ld [hl], a
	call DisableSRAM
	pop de
	pop hl
	ret

; save values that are listed in WRAMToSRAMMapper
; from WRAM to SRAM, and calculate its checksum
CopyGeneralSaveDataToSRAM: ; 11299 (4:5299)
	push hl
	push bc
	push de
	push de
	ld hl, sGeneralSaveDataHeaderEnd - sGeneralSaveData
	add hl, de
	ld e, l
	ld d, h
	xor a
	ld [wGeneralSaveDataByteCount + 0], a
	ld [wGeneralSaveDataByteCount + 1], a
	ld [wGeneralSaveDataCheckSum + 0], a
	ld [wGeneralSaveDataCheckSum + 1], a

	ld hl, WRAMToSRAMMapper
.loop_map
	ld a, [hli]
	ld [wTempPointer + 0], a
	ld c, a
	ld a, [hli]
	ld [wTempPointer + 1], a
	or c
	jr z, .done_copy
	ld a, [hli]
	ld c, a ; number of bytes LO
	ld a, [hli]
	ld b, a ; number of bytes HI
	ld a, [wGeneralSaveDataByteCount + 0]
	add c
	ld [wGeneralSaveDataByteCount + 0], a
	ld a, [wGeneralSaveDataByteCount + 1]
	adc b
	ld [wGeneralSaveDataByteCount + 1], a
	call .CopyBytesToSRAM
	inc hl
	inc hl
	jr .loop_map

.done_copy
	pop hl
	ld a, $08
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, [wGeneralSaveDataByteCount + 0]
	ld [hli], a
	ld a, [wGeneralSaveDataByteCount + 1]
	ld [hli], a
	ld a, [wGeneralSaveDataCheckSum + 0]
	ld [hli], a
	ld a, [wGeneralSaveDataCheckSum + 1]
	ld [hli], a
	pop de
	pop bc
	pop hl
	ret

.CopyBytesToSRAM
	push hl
	ld a, [wTempPointer + 0]
	ld l, a
	ld a, [wTempPointer + 1]
	ld h, a
.loop_bytes
	push bc
	ld a, [hli]
	ld [de], a
	inc de
	ld c, a
	ld a, [wGeneralSaveDataCheckSum + 0]
	add c
	ld [wGeneralSaveDataCheckSum + 0], a
	ld a, [wGeneralSaveDataCheckSum + 1]
	adc 0
	ld [wGeneralSaveDataCheckSum + 1], a
	pop bc
	dec bc
	ld a, c
	or b
	jr nz, .loop_bytes
	ld a, l
	ld [wTempPointer + 0], a
	ld a, h
	ld [wTempPointer + 1], a
	pop hl
	ret

; returns carry if no error
; is found in sBackupGeneralSaveData
ValidateBackupGeneralSaveData: ; 11320 (4:5320)
	push de
	ldh a, [hBankSRAM]
	push af
	ld a, BANK(sBackupGeneralSaveData)
	call BankswitchSRAM
	ld de, sBackupGeneralSaveData
	call ValidateGeneralSaveDataFromDE
	ld de, sAlbumProgress
	call LoadAlbumProgressFromSRAM
	pop af
	call BankswitchSRAM
	call DisableSRAM
	pop de
	ld a, [wNumSRAMValidationErrors]
	cp 1
	ret

; returns carry if no error
; is found in sGeneralSaveData
_ValidateGeneralSaveData: ; 11343 (4:5343)
	push de
	call EnableSRAM
	ld de, sGeneralSaveData
	call ValidateGeneralSaveDataFromDE
	ld de, sAlbumProgress
	call LoadAlbumProgressFromSRAM
	call DisableSRAM
	pop de
	ld a, [wNumSRAMValidationErrors]
	cp 1
	ret

; validates the general game data saved in SRAM
; de = pointer to general game data in SRAM
ValidateGeneralSaveDataFromDE: ; 1135d (4:535d)
	push hl
	push bc
	push de
	xor a
	ld [wNumSRAMValidationErrors], a
	push de

	push de
	inc de
	inc de
	ld a, [de]
	inc de
	ld [wGeneralSaveDataByteCount + 0], a
	ld a, [de]
	inc de
	ld [wGeneralSaveDataByteCount + 1], a
	ld a, [de]
	inc de
	ld [wGeneralSaveDataCheckSum + 0], a
	ld a, [de]
	inc de
	ld [wGeneralSaveDataCheckSum + 1], a
	pop de

	ld hl, sGeneralSaveDataHeaderEnd - sGeneralSaveData
	add hl, de
	ld e, l
	ld d, h
	ld hl, WRAMToSRAMMapper
.loop
	ld a, [hli]
	ld c, a
	ld a, [hli]
	or c
	jr z, .exit_loop
	ld a, [hli]
	ld c, a ; number of bytes LO
	ld a, [hli]
	ld b, a ; number of bytes HI
	ld a, [wGeneralSaveDataByteCount + 0]
	sub c
	ld [wGeneralSaveDataByteCount + 0], a
	ld a, [wGeneralSaveDataByteCount + 1]
	sbc b
	ld [wGeneralSaveDataByteCount + 1], a

; loop all the bytes of this struct
.loop_bytes
	push hl
	push bc
	ld a, [de]
	push af
	ld c, a
	ld a, [wGeneralSaveDataCheckSum + 0]
	sub c
	ld [wGeneralSaveDataCheckSum + 0], a
	ld a, [wGeneralSaveDataCheckSum + 1]
	sbc 0
	ld [wGeneralSaveDataCheckSum + 1], a
	pop af

	; check if it's within the specified values
	cp [hl] ; min value
	jr c, .error
	inc hl
	cp [hl] ; max value
	jr z, .next_byte
	jr c, .next_byte
.error
	ld a, [wNumSRAMValidationErrors]
	inc a
	ld [wNumSRAMValidationErrors], a
.next_byte
	inc de
	pop bc
	pop hl
	dec bc
	ld a, c
	or b
	jr nz, .loop_bytes
	; next mapped struct
	inc hl
	inc hl
	jr .loop

.exit_loop
	pop hl
	ld a, [hli]
	sub $8
	ld c, a
	ld a, [hl]
	sub 0
	or c
	ld hl, wGeneralSaveDataByteCount
	or [hl]
	inc hl
	or [hl]
	ld hl, wGeneralSaveDataCheckSum
	or [hl]
	inc hl
	or [hl]
	jr z, .no_header_error
	ld hl, wNumSRAMValidationErrors
	inc [hl]
.no_header_error
	pop de
	; copy play time minutes and hours
	ld hl, (sPlayTimeCounter + 2) - sGeneralSaveData
	add hl, de
	ld a, [hli]
	ld [wPlayTimeHourMinutes + 0], a
	ld a, [hli]
	ld [wPlayTimeHourMinutes + 1], a
	ld a, [hli]
	ld [wPlayTimeHourMinutes + 2], a

	; copy medal count and current overworld map
	ld hl, sGeneralSaveDataHeaderEnd - sGeneralSaveData
	add hl, de
	ld a, [hli]
	ld [wMedalCount], a
	ld a, [hl]
	ld [wCurOverworldMap], a
	pop bc
	pop hl
	ret

LoadAlbumProgressFromSRAM: ; 1140a (4:540a)
	push de
	ld a, [de]
	ld [wTotalNumCardsCollected], a
	inc de
	ld a, [de]
	ld [wTotalNumCardsToCollect], a
	pop de
	ret

; first copies data from backup SRAM to main SRAM
; then loads it to WRAM from main SRAM
LoadBackupSaveData: ; 11416 (4:5416)
	push hl
	push de
	call EnableSRAM
	bank1call DiscardSavedDuelData
	call DisableSRAM
	call LoadBackupGeneralSaveData
	call LoadBackupCardAndDeckSaveData
	ld de, sGeneralSaveData
	call LoadGeneralSaveDataFromDE
	pop de
	pop hl
	ret

_LoadGeneralSaveData: ; 11430 (4:5430)
	push de
	ld de, sGeneralSaveData
	call LoadGeneralSaveDataFromDE
	pop de
	ret

; de = pointer to save data
LoadGeneralSaveDataFromDE: ; 11439 (4:5439)
	push hl
	push bc
	call EnableSRAM
	call .LoadData
	call DisableSRAM
	pop bc
	pop hl
	ret

.LoadData
	push hl
	push bc
	push de
	ld a, e
	add sGeneralSaveDataHeaderEnd - sGeneralSaveData
	ld [wTempPointer + 0], a
	ld a, d
	adc 0
	ld [wTempPointer + 1], a

	ld hl, WRAMToSRAMMapper
.asm_11459
	ld a, [hli]
	ld e, a
	ld d, [hl]
	or d
	jr z, .done_copy
	inc hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a

; copy bc bytes from wTempPointer to de
	push hl
	ld a, [wTempPointer + 0]
	ld l, a
	ld a, [wTempPointer + 1]
	ld h, a
.loop_copy
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .loop_copy

	ld a, l
	ld [wTempPointer + 0], a
	ld a, h
	ld [wTempPointer + 1], a
	pop hl
	inc hl
	inc hl
	jr .asm_11459

.done_copy
	call EnableSRAM
	ld a, [sAnimationsDisabled]
	ld [wAnimationsDisabled], a
	ld a, [sTextSpeed]
	ld [wTextSpeed], a
	call DisableSRAM
	pop de
	pop bc
	pop hl
	ret

wram_sram_map: MACRO
	dw \1 ; WRAM address
	dw \2 ; number of bytes
	db \3 ; min allowed value
	db \4 ; max allowed value
ENDM

; maps WRAM addresses to SRAM addresses in order
; to save and subsequently retrieve them on game load
; also works as a test in order check whether
; the saved values is SRAM are legal, within the given value range
WRAMToSRAMMapper: ; 11498 (4:5498)
	wram_sram_map wMedalCount,                        1, $00, $ff ; sMedalCount
	wram_sram_map wCurOverworldMap,                   1, $00, $ff ; sCurOverworldMap
	wram_sram_map wPlayTimeCounter + 0,               1, $00, $ff ; sPlayTimeCounter
	wram_sram_map wPlayTimeCounter + 1,               1, $00, $ff
	wram_sram_map wPlayTimeCounter + 2,               1, $00, $ff
	wram_sram_map wPlayTimeCounter + 3,               2, $00, $ff
	wram_sram_map wOverworldMapSelection,             1, $00, $ff ; sOverworldMapSelection
	wram_sram_map wTempMap,                           1, $00, $ff ; sTempMap
	wram_sram_map wTempPlayerXCoord,                  1, $00, $ff ; sTempPlayerXCoord
	wram_sram_map wTempPlayerYCoord,                  1, $00, $ff ; sTempPlayerYCoord
	wram_sram_map wTempPlayerDirection,               1, $00, $ff ; sTempPlayerDirection
	wram_sram_map wActiveGameEvent,                   1, $00, $ff ; sActiveGameEvent
	wram_sram_map wDuelResult,                        1, $00, $ff ; sDuelResult
	wram_sram_map wNPCDuelist,                        1, $00, $ff ; sNPCDuelist
	wram_sram_map wChallengeHallNPC,                  1, $00, $ff ; sChallengeHallNPC
	wram_sram_map wd698,                              4, $00, $ff ; sb818
	wram_sram_map wOWMapEvents,          NUM_MAP_EVENTS, $00, $ff ; sOWMapEvents
	wram_sram_map .EmptySRAMSlot,                     1, $00, $ff ; sb827
	wram_sram_map wSelectedPauseMenuItem,             1, $00, $ff ; sSelectedPauseMenuItem
	wram_sram_map wSelectedPCMenuItem,                1, $00, $ff ; sSelectedPCMenuItem
	wram_sram_map wConfigCursorYPos,                  1, $00, $ff ; sConfigCursorYPos
	wram_sram_map wSelectedGiftCenterMenuItem,        1, $00, $ff ; sSelectedGiftCenterMenuItem
	wram_sram_map wPCPackSelection,                   1,   0,  14 ; sPCPackSelection
	wram_sram_map wPCPacks,                NUM_PC_PACKS, $00, $ff ; sPCPacks
	wram_sram_map wDefaultSong,                       1, $00, $ff ; sDefaultSong
	wram_sram_map wDebugPauseAllowed,                 1, $00, $ff ; sDebugPauseAllowed
	wram_sram_map wRonaldIsInMap,                     1, $00, $ff ; sRonaldIsInMap
	wram_sram_map wMastersBeatenList,                10, $00, $ff ; sMastersBeatenList
	wram_sram_map wNPCDuelistDirection,               1, $00, $ff ; sNPCDuelistDirection
	wram_sram_map wMultichoiceTextboxResult_ChooseDeckToDuelAgainst, 1, $00, $ff ; sMultichoiceTextboxResult_ChooseDeckToDuelAgainst
	wram_sram_map wd10e,                              1, $00, $ff ; sb84b
	wram_sram_map .EmptySRAMSlot,                    15, $00, $ff ; sb84c
	wram_sram_map .EmptySRAMSlot,                    16, $00, $ff ; sb85b
	wram_sram_map .EmptySRAMSlot,                    16, $00, $ff ; sb86b
	wram_sram_map wEventVars,                        64, $00, $ff ; sEventVars
	dw NULL

; fills an empty SRAM slot with zero
.EmptySRAMSlot: ; 1156c (4:556c)
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; save the game
; if c is 0, save the player at their current position
; otherwise, save the player in Mason's lab
_SaveGame: ; 1157c (4:557c)
	ld a, c
	or a
	jr nz, .force_mason_lab
	farcall BackupPlayerPosition
	jr .save

.force_mason_lab
	ld a, $2
	ld [wTempPlayerXCoord], a
	ld a, $4
	ld [wTempPlayerYCoord], a
	ld a, SOUTH
	ld [wTempPlayerDirection], a
	ld a, MASON_LABORATORY
	ld [wTempMap], a
	ld a, OWMAP_MASON_LABORATORY
	ld [wOverworldMapSelection], a

.save
	call SaveAndBackupData
	ret

_AddCardToCollectionAndUpdateAlbumProgress: ; 115a3 (4:55a3)
	ld [wCardToAddToCollection], a
	push hl
	push bc
	push de
	ldh a, [hBankSRAM]
	push af
	ld a, BANK(sAlbumProgress)
	call BankswitchSRAM
	ld a, [wCardToAddToCollection]
	call AddCardToCollection
	ld de, sAlbumProgress
	call UpdateAlbumProgress
	pop af
	call BankswitchSRAM
	call DisableSRAM ; unnecessary

; unintentional? runs the same write operation
; on the same address but on the current SRAM bank
	ld a, [wCardToAddToCollection]
	call AddCardToCollection
	ld de, $b8fe
	call UpdateAlbumProgress
	pop de
	pop bc
	pop hl
	ret

WriteBackupCardAndDeckSaveData: ; 115d4 (4:55d4)
	ld bc, sCardAndDeckSaveDataEnd - sCardAndDeckSaveData
	ld hl, sCardCollection
	jr WriteDataToBackup

WriteBackupGeneralSaveData: ; 115dc (4:55dc)
	ld bc, sGeneralSaveDataEnd - sGeneralSaveData
	ld hl, sGeneralSaveData
;	fallthrough

; bc = number of bytes to copy to backup
; hl = pointer in SRAM of data to backup
WriteDataToBackup: ; 115e2 (4:55e2)
	ldh a, [hBankSRAM]
	push af
.loop
	xor a ; SRAM0
	call BankswitchSRAM
	ld a, [hl]
	push af
	ld a, BANK("SRAM2")
	call BankswitchSRAM
	pop af
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop af
	call BankswitchSRAM
	call DisableSRAM
	ret

LoadBackupCardAndDeckSaveData: ; 115ff (4:55ff)
	ld bc, sCardAndDeckSaveDataEnd - sCardAndDeckSaveData
	ld hl, sCardCollection
	jr LoadDataFromBackup

LoadBackupGeneralSaveData: ; 11607 (4:5607)
	ld bc, sGeneralSaveDataEnd - sGeneralSaveData
	ld hl, sGeneralSaveData
;	fallthrough

; bc = number of bytes to load from backup
; hl = pointer in SRAM of backup data
LoadDataFromBackup: ; 1160d (4:560d)
	ldh a, [hBankSRAM]
	push af

.loop
	ld a, BANK("SRAM2")
	call BankswitchSRAM
	ld a, [hl]
	push af
	xor a
	call BankswitchSRAM
	pop af
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop af
	call BankswitchSRAM
	call DisableSRAM
	ret

INCLUDE "data/map_scripts.asm"

; loads a pointer into hl found on NPCHeaderPointers
GetNPCHeaderPointer: ; 1184a (4:584a)
	rlca
	add LOW(NPCHeaderPointers)
	ld l, a
	ld a, HIGH(NPCHeaderPointers)
	adc 0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

LoadNPCSpriteData: ; 11857 (4:5857)
	push hl
	push bc
	call GetNPCHeaderPointer
	ld a, [hli]
	ld [wTempNPC], a
	ld a, [hli]
	ld [wNPCSpriteID], a
	ld a, [hli]
	ld [wNPCAnim], a
	ld a, [hli]
	push af
	ld a, [hli]
	ld [wNPCAnimFlags], a
	pop bc
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld a, b
	ld [wNPCAnim], a
.not_cgb
	pop bc
	pop hl
	ret

; Loads Name into wCurrentNPCNameTx and gets Script ptr into bc
GetNPCNameAndScript: ; 1187d (4:587d)
	push hl
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_SCRIPT_PTR
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hli]
	ld [wCurrentNPCNameTx], a
	ld a, [hli]
	ld [wCurrentNPCNameTx + 1], a
	pop hl
	ret

; Sets Dialog Box title to the name of the npc in 'a'
SetNPCDialogName: ; 11893 (4:5893)
	push hl
	push bc
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_NAME_TEXT
	add hl, bc
	ld a, [hli]
	ld [wCurrentNPCNameTx], a
	ld a, [hli]
	ld [wCurrentNPCNameTx + 1], a
	pop bc
	pop hl
	ret

; set the opponent name and portrait for the NPC id in register a
SetNPCOpponentNameAndPortrait: ; 118a7 (4:58a7)
	push hl
	push bc
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_NAME_TEXT
	add hl, bc
	ld a, [hli]
	ld [wOpponentName], a
	ld a, [hli]
	ld [wOpponentName + 1], a
	ld a, [hli]
	ld [wOpponentPortrait], a
	pop bc
	pop hl
	ret

; set the deck id and duel theme for the NPC id in register a
SetNPCDeckIDAndDuelTheme: ; 118bf (4:58bf)
	push hl
	push bc
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_DECK_ID
	add hl, bc
	ld a, [hli]
	ld [wNPCDuelDeckID], a
	ld a, [hli]
	ld [wDuelTheme], a
	pop bc
	pop hl
	ret

; set the start theme for the NPC id in register a
SetNPCMatchStartTheme: ; 118d3 (4:58d3)
	push hl
	push bc
	push af
	call GetNPCHeaderPointer
	ld bc, NPC_DATA_MATCH_START_ID
	add hl, bc
	ld a, [hli]
	ld [wMatchStartTheme], a
	pop af
	cp NPC_RONALD1
	jr nz, .not_ronald_final_duel
	ld a, [wCurMap]
	cp POKEMON_DOME
	jr nz, .not_ronald_final_duel
	ld a, MUSIC_MATCH_START_3
	ld [wMatchStartTheme], a

.not_ronald_final_duel
	pop bc
	pop hl
	ret

INCLUDE "data/npcs.asm"

_GetNPCDuelConfigurations: ; 11f4e (4:5f4e)
	push hl
	push bc
	push de
	ld a, [wNPCDuelDeckID]
	ld e, a
	ld bc, 9 ; size of struct - 1
	ld hl, DeckIDDuelConfigurations
.loop_deck_ids
	ld a, [hli]
	cp -1 ; end of list?
	jr z, .done
	cp e
	jr nz, .next_deck_id
	ld a, [hli]
	ld [wOpponentPortrait], a
	ld a, [hli]
	ld [wOpponentName], a
	ld a, [hli]
	ld [wOpponentName + 1], a
	ld a, [hl]
	ld [wNPCDuelPrizes], a
	scf
	jr .done
.next_deck_id
	add hl, bc
	jr .loop_deck_ids
.done
	pop de
	pop bc
	pop hl
	ret

_GetChallengeMachineDuelConfigurations: ; 11f7d (4:5f7d)
	push bc
	push de
	ld a, [wNPCDuelDeckID]
	ld e, a
	ld bc, 9 ; size of struct - 1
	ld hl, DeckIDDuelConfigurations
.loop_deck_ids
	ld a, [hli]
	cp -1 ; end of list?
	jr z, .done
	cp e
	jr nz, .next_deck_id
	push hl
	ld a, [hli]
	ld [wOpponentPortrait], a
	ld a, [hli]
	ld [wOpponentName], a
	ld a, [hli]
	ld [wOpponentName + 1], a
	inc hl
	ld a, [hli]
	ld [wDuelTheme], a
	pop hl
	dec hl
	scf
	jr .done
.next_deck_id
	add hl, bc
	jr .loop_deck_ids
.done
	pop de
	pop bc
	ret

DeckIDDuelConfigurations: ; 11fae (4:5fae)
	db SAMS_PRACTICE_DECK_ID ; deck ID
	db SAM_PIC ; NPC portrait
	tx SamNPCName ; name text ID
	db PRIZES_2 ; number of prize cards
	db MUSIC_STOP ; theme
	dw NULL ; rank
	dw NULL ; element

	db SAMS_NORMAL_DECK_ID ; deck ID
	db SAM_PIC ; NPC portrait
	tx SamNPCName ; name text ID
	db PRIZES_2 ; number of prize cards
	db MUSIC_STOP ; theme
	dw NULL ; rank
	dw NULL ; element

	db LIGHTNING_AND_FIRE_DECK_ID ; deck ID
	db AARON_PIC ; NPC portrait
	tx AaronNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx TechText ; rank
	dw NULL ; element

	db WATER_AND_FIGHTING_DECK_ID ; deck ID
	db AARON_PIC ; NPC portrait
	tx AaronNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx TechText ; rank
	dw NULL ; element

	db GRASS_AND_PSYCHIC_DECK_ID ; deck ID
	db AARON_PIC ; NPC portrait
	tx AaronNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx TechText ; rank
	dw NULL ; element

	db LEGENDARY_MOLTRES_DECK_ID ; deck ID
	db COURTNEY_PIC ; NPC portrait
	tx CourtneyNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_3 ; theme
	tx GrandMasterText ; rank
	dw NULL ; element

	db LEGENDARY_ZAPDOS_DECK_ID ; deck ID
	db STEVE_PIC ; NPC portrait
	tx SteveNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_3 ; theme
	tx GrandMasterText ; rank
	dw NULL ; element

	db LEGENDARY_ARTICUNO_DECK_ID ; deck ID
	db JACK_PIC ; NPC portrait
	tx JackNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_3 ; theme
	tx GrandMasterText ; rank
	dw NULL ; element

	db LEGENDARY_DRAGONITE_DECK_ID ; deck ID
	db ROD_PIC ; NPC portrait
	tx RodNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_3 ; theme
	tx GrandMasterText ; rank
	dw NULL ; element

	db FIRST_STRIKE_DECK_ID ; deck ID
	db MITCH_PIC ; NPC portrait
	tx MitchNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_2 ; theme
	tx ClubMasterText ; rank
	tx ChallengeMachineFightingIconText ; element

	db ROCK_CRUSHER_DECK_ID ; deck ID
	db GENE_PIC ; NPC portrait
	tx GeneNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_2 ; theme
	tx ClubMasterText ; rank
	tx ChallengeMachineFightingIconText ; element

	db GO_GO_RAIN_DANCE_DECK_ID ; deck ID
	db AMY_PIC ; NPC portrait
	tx AmyNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_2 ; theme
	tx ClubMasterText ; rank
	tx ChallengeMachineWaterIconText ; element

	db ZAPPING_SELFDESTRUCT_DECK_ID ; deck ID
	db ISAAC_PIC ; NPC portrait
	tx IsaacNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_2 ; theme
	tx ClubMasterText ; rank
	tx ChallengeMachineLightningIconText ; element

	db FLOWER_POWER_DECK_ID ; deck ID
	db NIKKI_PIC ; NPC portrait
	tx NikkiNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_2 ; theme
	tx ClubMasterText ; rank
	tx ChallengeMachineGrassIconText ; element

	db STRANGE_PSYSHOCK_DECK_ID ; deck ID
	db MURRAY_PIC ; NPC portrait
	tx MurrayNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_2 ; theme
	tx ClubMasterText ; rank
	tx ChallengeMachinePsychicIconText ; element

	db WONDERS_OF_SCIENCE_DECK_ID ; deck ID
	db RICK_PIC ; NPC portrait
	tx RickNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_2 ; theme
	tx ClubMasterText ; rank
	tx ChallengeMachineGrassIconText ; element

	db FIRE_CHARGE_DECK_ID ; deck ID
	db KEN_PIC ; NPC portrait
	tx KenNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_DUEL_THEME_2 ; theme
	tx ClubMasterText ; rank
	tx ChallengeMachineFireIconText ; element

	db IM_RONALD_DECK_ID ; deck ID
	db RONALD_PIC ; NPC portrait
	tx RonaldNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_STOP ; theme
	dw NULL ; rank
	dw NULL ; element

	db POWERFUL_RONALD_DECK_ID ; deck ID
	db RONALD_PIC ; NPC portrait
	tx RonaldNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_STOP ; theme
	dw NULL ; rank
	dw NULL ; element

	db INVINCIBLE_RONALD_DECK_ID ; deck ID
	db RONALD_PIC ; NPC portrait
	tx RonaldNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_STOP ; theme
	dw NULL ; rank
	dw NULL ; element

	db LEGENDARY_RONALD_DECK_ID ; deck ID
	db RONALD_PIC ; NPC portrait
	tx RonaldNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_STOP ; theme
	dw NULL ; rank
	dw NULL ; element

	db MUSCLES_FOR_BRAINS_DECK_ID ; deck ID
	db CHRIS_PIC ; NPC portrait
	tx ChrisNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineFightingIconText ; element

	db HEATED_BATTLE_DECK_ID ; deck ID
	db MICHAEL_PIC ; NPC portrait
	tx MichaelNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineFightingIconText ; element

	db LOVE_TO_BATTLE_DECK_ID ; deck ID
	db JESSICA_PIC ; NPC portrait
	tx JessicaNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineFightingIconText ; element

	db EXCAVATION_DECK_ID ; deck ID
	db RYAN_PIC ; NPC portrait
	tx RyanNPCName ; name text ID
	db PRIZES_3 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineFightingIconText ; element

	db BLISTERING_POKEMON_DECK_ID ; deck ID
	db ANDREW_PIC ; NPC portrait
	tx AndrewNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineFightingIconText ; element

	db HARD_POKEMON_DECK_ID ; deck ID
	db MATTHEW_PIC ; NPC portrait
	tx MatthewNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineFightingIconText ; element

	db WATERFRONT_POKEMON_DECK_ID ; deck ID
	db SARA_PIC ; NPC portrait
	tx SaraNPCName ; name text ID
	db PRIZES_2 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineWaterIconText ; element

	db LONELY_FRIENDS_DECK_ID ; deck ID
	db AMANDA_PIC ; NPC portrait
	tx AmandaNPCName ; name text ID
	db PRIZES_3 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineWaterIconText ; element

	db SOUND_OF_THE_WAVES_DECK_ID ; deck ID
	db JOSHUA_PIC ; NPC portrait
	tx JoshuaNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineWaterIconText ; element

	db PIKACHU_DECK_ID ; deck ID
	db JENNIFER_PIC ; NPC portrait
	tx JenniferNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineLightningIconText ; element

	db BOOM_BOOM_SELFDESTRUCT_DECK_ID ; deck ID
	db NICHOLAS_PIC ; NPC portrait
	tx NicholasNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineLightningIconText ; element

	db POWER_GENERATOR_DECK_ID ; deck ID
	db BRANDON_PIC ; NPC portrait
	tx BrandonNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineLightningIconText ; element

	db ETCETERA_DECK_ID ; deck ID
	db BRITTANY_PIC ; NPC portrait
	tx BrittanyNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineGrassIconText ; element

	db FLOWER_GARDEN_DECK_ID ; deck ID
	db KRISTIN_PIC ; NPC portrait
	tx KristinNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineGrassIconText ; element

	db KALEIDOSCOPE_DECK_ID ; deck ID
	db HEATHER_PIC ; NPC portrait
	tx HeatherNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineGrassIconText ; element

	db GHOST_DECK_ID ; deck ID
	db ROBERT_PIC ; NPC portrait
	tx RobertNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachinePsychicIconText ; element

	db NAP_TIME_DECK_ID ; deck ID
	db DANIEL_PIC ; NPC portrait
	tx DanielNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachinePsychicIconText ; element

	db STRANGE_POWER_DECK_ID ; deck ID
	db STEPHANIE_PIC ; NPC portrait
	tx StephanieNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachinePsychicIconText ; element

	db FLYIN_POKEMON_DECK_ID ; deck ID
	db JOSEPH_PIC ; NPC portrait
	tx JosephNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineGrassIconText ; element

	db LOVELY_NIDORAN_DECK_ID ; deck ID
	db DAVID_PIC ; NPC portrait
	tx DavidNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineGrassIconText ; element

	db POISON_DECK_ID ; deck ID
	db ERIK_PIC ; NPC portrait
	tx ErikNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineGrassIconText ; element

	db ANGER_DECK_ID ; deck ID
	db JOHN_PIC ; NPC portrait
	tx JohnNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineFireIconText ; element

	db FLAMETHROWER_DECK_ID ; deck ID
	db ADAM_PIC ; NPC portrait
	tx AdamNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineFireIconText ; element

	db RESHUFFLE_DECK_ID ; deck ID
	db JONATHAN_PIC ; NPC portrait
	tx JonathanNPCName ; name text ID
	db PRIZES_4 ; number of prize cards
	db MUSIC_DUEL_THEME_1 ; theme
	tx ClubMemberText ; rank
	tx ChallengeMachineFireIconText ; element

	db IMAKUNI_DECK_ID ; deck ID
	db IMAKUNI_PIC ; NPC portrait
	tx ImakuniNPCName ; name text ID
	db PRIZES_6 ; number of prize cards
	db MUSIC_IMAKUNI ; theme
	tx StrangeLifeformText ; rank
	dw NULL ; element

	db -1 ; end

OverworldScriptTable: ; 1217b (4:617b)
	dw ScriptCommand_EndScript
	dw ScriptCommand_CloseAdvancedTextBox
	dw ScriptCommand_PrintNPCText
	dw ScriptCommand_PrintText
	dw ScriptCommand_AskQuestionJump
	dw ScriptCommand_StartDuel
	dw ScriptCommand_PrintVariableNPCText
	dw ScriptCommand_PrintVariableText
	dw ScriptCommand_PrintTextQuitFully
	dw ScriptCommand_UnloadActiveNPC
	dw ScriptCommand_MoveActiveNPCByDirection
	dw ScriptCommand_CloseTextBox
	dw ScriptCommand_GiveBoosterPacks
	dw ScriptCommand_JumpIfCardOwned
	dw ScriptCommand_JumpIfCardInCollection
	dw ScriptCommand_GiveCard
	dw ScriptCommand_TakeCard
	dw ScriptCommand_JumpIfAnyEnergyCardsInCollection
	dw ScriptCommand_RemoveAllEnergyCardsFromCollection
	dw ScriptCommand_JumpIfEnoughCardsOwned
	dw ScriptCommand_JumpBasedOnFightingClubPupilStatus
	dw ScriptCommand_SetActiveNPCDirection
	dw ScriptCommand_PickNextMan1RequestedCard
	dw ScriptCommand_LoadMan1RequestedCardIntoTxRamSlot
	dw ScriptCommand_JumpIfMan1RequestedCardOwned
	dw ScriptCommand_JumpIfMan1RequestedCardInCollection
	dw ScriptCommand_RemoveMan1RequestedCardFromCollection
	dw ScriptCommand_Jump
	dw ScriptCommand_TryGiveMedalPCPacks
	dw ScriptCommand_SetPlayerDirection
	dw ScriptCommand_MovePlayer
	dw ScriptCommand_ShowCardReceivedScreen
	dw ScriptCommand_SetDialogNPC
	dw ScriptCommand_SetNextNPCAndScript
	dw ScriptCommand_SetSpriteAttributes
	dw ScriptCommand_SetActiveNPCCoords
	dw ScriptCommand_DoFrames
	dw ScriptCommand_JumpIfActiveNPCCoordsMatch
	dw ScriptCommand_JumpIfPlayerCoordsMatch
	dw ScriptCommand_MoveActiveNPC
	dw ScriptCommand_GiveOneOfEachTrainerBooster
	dw ScriptCommand_JumpIfNPCLoaded
	dw ScriptCommand_ShowMedalReceivedScreen
	dw ScriptCommand_LoadCurrentMapNameIntoTxRamSlot
	dw ScriptCommand_LoadChallengeHallNPCIntoTxRamSlot
	dw ScriptCommand_StartChallengeHallDuel
	dw ScriptCommand_PrintTextForChallengeCup
	dw ScriptCommand_MoveChallengeHallNPC
	dw ScriptCommand_UnloadChallengeHallNPC
	dw ScriptCommand_SetChallengeHallNPCCoords
	dw ScriptCommand_PickChallengeHallOpponent
	dw ScriptCommand_OpenMenu
	dw ScriptCommand_PickChallengeCupPrizeCard
	dw ScriptCommand_QuitScriptFully
	dw ScriptCommand_ReplaceMapBlocks
	dw ScriptCommand_ChooseDeckToDuelAgainstMultichoice
	dw ScriptCommand_OpenDeckMachine
	dw ScriptCommand_ChooseStarterDeckMultichoice
	dw ScriptCommand_EnterMap
	dw ScriptCommand_MoveArbitraryNPC
	dw ScriptCommand_PickLegendaryCard
	dw ScriptCommand_FlashScreen
	dw ScriptCommand_SaveGame
	dw ScriptCommand_BattleCenter
	dw ScriptCommand_GiftCenter
	dw ScriptCommand_PlayCredits
	dw ScriptCommand_TryGivePCPack
	dw ScriptCommand_nop
	dw ScriptCommand_GiveStarterDeck
	dw ScriptCommand_WalkPlayerToMasonLaboratory
	dw ScriptCommand_OverrideSong
	dw ScriptCommand_SetDefaultSong
	dw ScriptCommand_PlaySong
	dw ScriptCommand_PlaySFX
	dw ScriptCommand_PauseSong
	dw ScriptCommand_ResumeSong
	dw ScriptCommand_PlayDefaultSong
	dw ScriptCommand_WaitForSongToFinish
	dw ScriptCommand_RecordMasterWin
	dw ScriptCommand_AskQuestionJumpDefaultYes
	dw ScriptCommand_ShowSamNormalMultichoice
	dw ScriptCommand_ShowSamRulesMultichoice
	dw ScriptCommand_ChallengeMachine
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_SetEventValue
	dw ScriptCommand_JumpIfEventZero
	dw ScriptCommand_JumpIfEventNonzero
	dw ScriptCommand_JumpIfEventEqual
	dw ScriptCommand_JumpIfEventNotEqual
	dw ScriptCommand_JumpIfEventGreaterOrEqual
	dw ScriptCommand_JumpIfEventLessThan
	dw ScriptCommand_MaxOutEventValue
	dw ScriptCommand_ZeroOutEventValue
	dw ScriptCommand_JumpIfEventTrue
	dw ScriptCommand_JumpIfEventFalse
	dw ScriptCommand_IncrementEventValue
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript
	dw ScriptCommand_EndScript


MultichoiceTextbox_ConfigTable_ChooseDeckToDuelAgainst: ; 1224b (4:624b)
	db $04, $00     ; x, y to start drawing box
	db $10, $08     ; width, height of box
	db $06, $02     ; x, y coordinate to start printing next text
	tx LightningAndFireDeckChoiceText     ; text id to print next
	db $06, $04     ; x, y coordinate to start printing next text
	tx WaterAndFightingDeckChoiceText     ; text id to print next
	db $06, $06     ; x, y coordinate to start printing next text
	tx GrassAndPsychicDeckChoiceText      ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $05, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $03          ; cursor max index
	db SYM_CURSOR_R ; cursor image
	db SYM_SPACE    ; tile behind cursor
	dw NULL         ; function pointer if non-0

MultichoiceTextbox_ConfigTable_ChooseDeckStarterDeck: ; 12264 (4:6264)
	db $04, $00     ; x, y to start drawing box
	db $10, $08     ; width, height of box
	db $06, $02     ; x, y coordinate to start printing next text
	tx CharmanderAndFriendsDeckChoiceText     ; text id to print next
	db $06, $04     ; x, y coordinate to start printing next text
	tx SquirtleAndFriendsDeckChoiceText       ; text id to print next
	db $06, $06     ; x, y coordinate to start printing next text
	tx BulbasaurAndFriendsDeckChoiceText      ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $05, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $03          ; cursor max index
	db SYM_CURSOR_R ; cursor image
	db SYM_SPACE    ; tile behind cursor
	dw NULL         ; function pointer if non-0

SamNormalMultichoice_ConfigurationTable: ; 1227d (4:627d)
	db $0a, $00     ; x, y to start drawing box
	db $0a, $0a     ; width, height of box
	db $0c, $02     ; x, y coordinate to start printing next text
	tx Text03ff     ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $0b, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $04          ; cursor max index
	db SYM_CURSOR_R ; cursor image
	db SYM_SPACE    ; tile behind cursor
	dw NULL         ; function pointer if non-0

SamRulesMultichoice_ConfigurationTable: ; 1228e (4:628e)
	db $06, $00     ; x, y to start drawing box
	db $0e, $12     ; width, height of box
	db $08, $02     ; x coordinate to start printing text
	tx Text0400     ; text id to print next
	db $ff          ; marker byte -- end text entries
	db $07, $02     ; cursor starting x, y
	db $02          ; number of tiles the cursor moves per toggle
	db $08          ; cursor max index
	db SYM_CURSOR_R ; cursor image
	db SYM_SPACE    ; tile behind cursor
	dw NULL         ; function pointer if non-0

OverworldMap_PlayerMovementPaths: ; 1229f (4:629f)
	dw OverworldMap_MasonLaboratoryPaths
	dw OverworldMap_IshiharasHousePaths
	dw OverworldMap_FightingClubPaths
	dw OverworldMap_RockClubPaths
	dw OverworldMap_WaterClubPaths
	dw OverworldMap_LightningClubPaths
	dw OverworldMap_GrassClubPaths
	dw OverworldMap_PsychicClubPaths
	dw OverworldMap_ScienceClubPaths
	dw OverworldMap_FireClubPaths
	dw OverworldMap_ChallengeHallPaths
	dw OverworldMap_PokemonDomePaths

OverworldMap_MasonLaboratoryPaths: ; 122b7 (4:62b7)
	dw OverworldMap_NoMovement
	dw OverworldMap_MasonLaboratoryPathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_MasonLaboratoryPathToRockClub
	dw OverworldMap_MasonLaboratoryPathToWaterClub
	dw OverworldMap_MasonLaboratoryPathToLightningClub
	dw OverworldMap_MasonLaboratoryPathToGrassClub
	dw OverworldMap_MasonLaboratoryPathToPsychicClub
	dw OverworldMap_MasonLaboratoryPathToScienceClub
	dw OverworldMap_MasonLaboratoryPathToFireClub
	dw OverworldMap_MasonLaboratoryPathToChallengeHall
	dw OverworldMap_MasonLaboratoryPathToPokemonDome

OverworldMap_IshiharasHousePaths: ; 122cf (4:62cf)
	dw OverworldMap_IshiharasHousePathToMasonLaboratory
	dw OverworldMap_NoMovement
	dw OverworldMap_IshiharasHousePathToFightingClub
	dw OverworldMap_IshiharasHousePathToRockClub
	dw OverworldMap_IshiharasHousePathToWaterClub
	dw OverworldMap_IshiharasHousePathToLightningClub
	dw OverworldMap_IshiharasHousePathToGrassClub
	dw OverworldMap_IshiharasHousePathToPsychicClub
	dw OverworldMap_IshiharasHousePathToScienceClub
	dw OverworldMap_IshiharasHousePathToFireClub
	dw OverworldMap_IshiharasHousePathToChallengeHall
	dw OverworldMap_IshiharasHousePathToPokemonDome

OverworldMap_FightingClubPaths: ; 122e7 (4:62e7)
	dw OverworldMap_StraightPath
	dw OverworldMap_FightingClubPathToIshiharasHouse
	dw OverworldMap_NoMovement
	dw OverworldMap_FightingClubPathToRockClub
	dw OverworldMap_FightingClubPathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_FightingClubPathToPsychicClub
	dw OverworldMap_StraightPath
	dw OverworldMap_FightingClubPathToFireClub
	dw OverworldMap_FightingClubPathToChallengeHall
	dw OverworldMap_StraightPath

OverworldMap_RockClubPaths: ; 122ff (4:62ff)
	dw OverworldMap_RockClubPathToMasonLaboratory
	dw OverworldMap_RockClubPathToIshiharasHouse
	dw OverworldMap_RockClubPathToFightingClub
	dw OverworldMap_NoMovement
	dw OverworldMap_RockClubPathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_RockClubPathToGrassClub
	dw OverworldMap_StraightPath
	dw OverworldMap_RockClubPathToScienceClub
	dw OverworldMap_RockClubPathToFireClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath

OverworldMap_WaterClubPaths: ; 12317 (4:6317)
	dw OverworldMap_WaterClubPathToMasonLaboratory
	dw OverworldMap_WaterClubPathToIshiharasHouse
	dw OverworldMap_WaterClubPathToFightingClub
	dw OverworldMap_WaterClubPathToRockClub
	dw OverworldMap_NoMovement
	dw OverworldMap_WaterClubPathToLightningClub
	dw OverworldMap_WaterClubPathToGrassClub
	dw OverworldMap_WaterClubPathToPsychicClub
	dw OverworldMap_WaterClubPathToScienceClub
	dw OverworldMap_WaterClubPathToFireClub
	dw OverworldMap_WaterClubPathToChallengeHall
	dw OverworldMap_WaterClubPathToPokemonDome

OverworldMap_LightningClubPaths: ; 1232f (4:632f)
	dw OverworldMap_LightningClubPathToMasonLaboratory
	dw OverworldMap_LightningClubPathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_LightningClubPathToWaterClub
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath
	dw OverworldMap_LightningClubPathToPsychicClub
	dw OverworldMap_LightningClubPathToScienceClub
	dw OverworldMap_LightningClubPathToFireClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath

OverworldMap_GrassClubPaths: ; 12347 (4:6347)
	dw OverworldMap_GrassClubPathToMasonLaboratory
	dw OverworldMap_GrassClubPathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_GrassClubPathToRockClub
	dw OverworldMap_GrassClubPathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_GrassClubPathToChallengeHall
	dw OverworldMap_StraightPath

OverworldMap_PsychicClubPaths: ; 1235f (4:635f)
	dw OverworldMap_PsychicClubPathToMasonLaboratory
	dw OverworldMap_PsychicClubPathToIshiharasHouse
	dw OverworldMap_PsychicClubPathToFightingClub
	dw OverworldMap_StraightPath
	dw OverworldMap_PsychicClubPathToWaterClub
	dw OverworldMap_PsychicClubPathToLightningClub
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath

OverworldMap_ScienceClubPaths: ; 12377 (4:6377)
	dw OverworldMap_ScienceClubPathToMasonLaboratory
	dw OverworldMap_ScienceClubPathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_ScienceClubPathToRockClub
	dw OverworldMap_ScienceClubPathToWaterClub
	dw OverworldMap_ScienceClubPathToLightningClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath
	dw OverworldMap_ScienceClubPathToChallengeHall
	dw OverworldMap_StraightPath

OverworldMap_FireClubPaths: ; 1238f (4:638f)
	dw OverworldMap_FireClubPathToMasonLaboratory
	dw OverworldMap_FireClubPathToIshiharasHouse
	dw OverworldMap_FireClubPathToFightingClub
	dw OverworldMap_FireClubPathToRockClub
	dw OverworldMap_FireClubPathToWaterClub
	dw OverworldMap_FireClubPathToLightningClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement
	dw OverworldMap_FireClubPathToChallengeHall
	dw OverworldMap_FireClubPathToPokemonDome

OverworldMap_ChallengeHallPaths: ; 123a7 (4:63a7)
	dw OverworldMap_ChallengeHallPathToMasonLaboratory
	dw OverworldMap_ChallengeHallPathToIshiharasHouse
	dw OverworldMap_ChallengeHallPathToFightingClub
	dw OverworldMap_StraightPath
	dw OverworldMap_ChallengeHallPathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_ChallengeHallPathToGrassClub
	dw OverworldMap_StraightPath
	dw OverworldMap_ChallengeHallPathToScienceClub
	dw OverworldMap_ChallengeHallPathToFireClub
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath

OverworldMap_PokemonDomePaths: ; 123bf (4:63bf)
	dw OverworldMap_PokemonDomePathToMasonLaboratory
	dw OverworldMap_PokemonDomePathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_PokemonDomePathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_PokemonDomePathToFireClub
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement

OverworldMap_IshiharasHousePathToRockClub: ; 123d7 (4:63d7)
OverworldMap_RockClubPathToIshiharasHouse: ; 123d7 (4:63d7)
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToWaterClub: ; 123dd (4:63dd)
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToMasonLaboratory: ; 123eb (4:63eb)
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToFireClub: ; 123f9 (4:63f9)
	db $2c, $28
	db $3c, $40
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToIshiharasHouse: ; 12403 (4:6403)
	db $5c, $30
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToIshiharasHouse: ; 1240d (4:640d)
	db $2c, $78
	db $3c, $68
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToMasonLaboratory: ; 12419 (4:6419)
	db $2c, $28
	db $3c, $40
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToRockClub: ; 12425 (4:6425)
	db $2c, $78
	db $3c, $68
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToMasonLaboratory: ; 1242f (4:642f)
	db $3c, $48
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToLightningClub: ; 12439 (4:6439)
OverworldMap_LightningClubPathToMasonLaboratory: ; 12439 (4:6439)
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToGrassClub: ; 1243f (4:643f)
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_GrassClubPathToMasonLaboratory: ; 12449 (4:6449)
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToPsychicClub: ; 12453 (4:6453)
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_PsychicClubPathToMasonLaboratory: ; 1245f (4:645f)
	db $5c, $48
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToScienceClub: ; 1246b (4:646b)
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_ScienceClubPathToMasonLaboratory: ; 12475 (4:6475)
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToFireClub: ; 1247f (4:647f)
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToMasonLaboratory: ; 1248b (4:648b)
	db $5c, $30
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToChallengeHall: ; 12497 (4:6497)
	db $2c, $78
	db $3c, $68
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_ChallengeHallPathToMasonLaboratory: ; 124a1 (4:64a1)
	db $3c, $40
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToPokemonDome: ; 124ab (4:64ab)
	db $2c, $78
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_PokemonDomePathToMasonLaboratory: ; 124b3 (4:64b3)
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToFightingClub: ; 124bb (4:64bb)
OverworldMap_FightingClubPathToIshiharasHouse: ; 124bb (4:64bb)
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToWaterClub: ; 124c1 (4:64c1)
	db $2c, $28
	db $3c, $48
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToIshiharasHouse: ; 124d1 (4:64d1)
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $3c, $48
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToLightningClub: ; 124e1 (4:64e1)
OverworldMap_LightningClubPathToIshiharasHouse: ; 124e1 (4:64e1)
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToGrassClub: ; 124e7 (4:64e7)
	db $2c, $28
	db $3c, $40
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_GrassClubPathToIshiharasHouse: ; 124f1 (4:64f1)
	db $5c, $48
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToPsychicClub: ; 124fb (4:64fb)
	db $2c, $28
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_PsychicClubPathToIshiharasHouse: ; 12503 (4:6503)
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToScienceClub: ; 1250b (4:650b)
	db $2c, $28
	db $3c, $40
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_ScienceClubPathToIshiharasHouse: ; 12515 (4:6515)
	db $5c, $48
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToChallengeHall: ; 1251f (4:651f)
	db $2c, $28
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_ChallengeHallPathToIshiharasHouse: ; 12527 (4:6527)
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToPokemonDome: ; 1252f (4:652f)
	db $2c, $28
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_PokemonDomePathToIshiharasHouse: ; 12537 (4:6537)
	db $3c, $48
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToRockClub: ; 1253f (4:653f)
	db $3c, $68
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToFightingClub: ; 12547 (4:6547)
	db $3c, $48
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToWaterClub: ; 1254f (4:654f)
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToFightingClub: ; 1255b (4:655b)
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToPsychicClub: ; 12567 (4:6567)
OverworldMap_PsychicClubPathToFightingClub: ; 12567 (4:6567)
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToFireClub: ; 1256d (4:656d)
	db $5c, $68
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToFightingClub: ; 12575 (4:6575)
	db $5c, $30
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToChallengeHall: ; 1257d (4:657d)
OverworldMap_ChallengeHallPathToFightingClub: ; 1257d (4:657d)
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToWaterClub: ; 12583 (4:6583)
	db $3c, $48
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToRockClub: ; 12591 (4:6591)
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToGrassClub: ; 1259f (4:659f)
OverworldMap_GrassClubPathToRockClub: ; 1259f (4:659f)
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToFireClub: ; 125a5 (4:65a5)
	db $3c, $40
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToRockClub: ; 125ad (4:65ad)
	db $5c, $30
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToLightningClub: ; 125b5 (4:65b5)
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_LightningClubPathToWaterClub: ; 125c1 (4:65c1)
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToGrassClub: ; 125cd (4:65cd)
OverworldMap_WaterClubPathToPsychicClub: ; 125cd (4:65cd)
OverworldMap_WaterClubPathToScienceClub: ; 125cd (4:65cd)
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_GrassClubPathToWaterClub: ; 125d7 (4:65d7)
OverworldMap_PsychicClubPathToWaterClub: ; 125d7 (4:65d7)
OverworldMap_ScienceClubPathToWaterClub: ; 125d7 (4:65d7)
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToFireClub: ; 125e1 (4:65e1)
	db $74, $7c
	db $5c, $7c
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToWaterClub: ; 125eb (4:65eb)
	db $5c, $30
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToChallengeHall: ; 125f5 (4:65f5)
	db $74, $7c
	db $5c, $7c
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_ChallengeHallPathToWaterClub: ; 125ff (4:65ff)
	db $5c, $48
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToPokemonDome: ; 12609 (4:6609)
	db $74, $7c
	db $5c, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_PokemonDomePathToWaterClub: ; 12611 (4:6611)
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_LightningClubPathToPsychicClub: ; 12619 (4:6619)
OverworldMap_PsychicClubPathToLightningClub: ; 12619 (4:6619)
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_LightningClubPathToScienceClub: ; 1261f (4:661f)
	db $3c, $68
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_ScienceClubPathToLightningClub: ; 12627 (4:6627)
	db $5c, $68
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_LightningClubPathToFireClub: ; 1262f (4:662f)
	db $3c, $48
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToLightningClub: ; 12637 (4:6637)
	db $5c, $30
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_GrassClubPathToChallengeHall: ; 1263f (4:663f)
OverworldMap_ScienceClubPathToChallengeHall: ; 1263f (4:663f)
OverworldMap_ChallengeHallPathToGrassClub: ; 1263f (4:663f)
OverworldMap_ChallengeHallPathToScienceClub: ; 1263f (4:663f)
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToChallengeHall: ; 12645 (4:6645)
OverworldMap_FireClubPathToPokemonDome: ; 12645 (4:6645)
OverworldMap_ChallengeHallPathToFireClub: ; 12645 (4:6645)
OverworldMap_PokemonDomePathToFireClub: ; 12645 (4:6645)
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToScienceClub: ; 1264b (4:664b)
	db $3c, $40
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_ScienceClubPathToRockClub: ; 12653 (4:6653)
	db $5c, $48
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_StraightPath: ; 1265b (4:665b)
	db $00, $00
	db $ff, $ff

OverworldMap_NoMovement: ; 1265f (4:665f)
	db $ff, $ff

; unreferenced debug menu
Func_12661: ; 12661 (4:6661)
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
	call Func_3ca0
	call Func_12871
	ld a, $01
	ld [wLineSeparation], a
	ld a, [wDebugMenuSelection]
	ld hl, Unknown_128f7
	call InitAndPrintPauseMenu
	call EnableLCD
.asm_12698
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .asm_12698
	ldh a, [hCurMenuItem]
	bit 7, a
	jr nz, .asm_12698
	ld [wDebugMenuSelection], a
	xor a
	ld [wLineSeparation], a
	call Func_126b3
	jr c, .asm_1266d
	ret

Func_126b3: ; 126b3 (4:66b3)
	ldh a, [hCurMenuItem]
	ld hl, Unknown_126bb
	jp JumpToFunctionInTable

Unknown_126bb: ; 126bb (4:66bb)
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

; usually, the game doesn't loop here at all, since as soon as a main menu option
; is selected, there is no need to come back to the menu.
; the only exception is after returning from Card Pop!
_GameLoop: ; 126d1 (4:66d1)
	call ZeroObjectPositions
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	farcall SetIntroSGBBorder
	ld a, $ff
	ld [wLastSelectedStartMenuItem], a
.main_menu_loop
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	farcall Func_c1f8
	farcall HandleTitleScreen
	ld a, [wStartMenuChoice]
	ld hl, MainMenuFunctionTable
	call JumpToFunctionInTable
	jr c, .main_menu_loop ; return to main menu
	jr _GameLoop ; virtually restart game

; this is never reached
	scf
	ret

MainMenuFunctionTable: ; 126fc (4:66fc)
	dw MainMenu_CardPop
	dw MainMenu_ContinueFromDiary
	dw MainMenu_NewGame
	dw MainMenu_ContinueDuel

MainMenu_NewGame: ; 12704 (4:6704)
	farcall Func_c1b1
	call DisplayPlayerNamingScreen
	farcall InitSaveData
	call EnableSRAM
	ld a, [sAnimationsDisabled]
	ld [wAnimationsDisabled], a
	ld a, [sTextSpeed]
	ld [wTextSpeed], a
	call DisableSRAM
	ld a, MUSIC_STOP
	call PlaySong
	farcall SetMainSGBBorder
	ld a, MUSIC_OVERWORLD
	ld [wDefaultSong], a
	call PlayDefaultSong
	farcall DrawPlayerPortraitAndPrintNewGameText
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret

MainMenu_ContinueFromDiary: ; 12741 (4:6741)
	ld a, MUSIC_STOP
	call PlaySong
	call ValidateBackupGeneralSaveData
	jr nc, MainMenu_NewGame
	farcall Func_c1ed
	farcall SetMainSGBBorder
	call EnableSRAM
	xor a
	ld [sPlayerInChallengeMachine], a
	call DisableSRAM
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret

MainMenu_CardPop: ; 12768 (4:6768)
	ld a, MUSIC_CARD_POP
	call PlaySong
	bank1call DoCardPop
	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	ld a, MUSIC_STOP
	call PlaySong
	scf
	ret

MainMenu_ContinueDuel: ; 1277e (4:677e)
	ld a, MUSIC_STOP
	call PlaySong
	farcall ClearEvents
	farcall $04, LoadGeneralSaveData
	farcall SetMainSGBBorder
	ld a, GAME_EVENT_CONTINUE_DUEL
	ld [wGameEvent], a
	farcall $03, ExecuteGameEvent
	or a
	ret

DebugLookAtSprite: ; 1279a (4:679a)
	farcall Func_80cd7
	scf
	ret

DebugVEffect: ; 127a0 (4:67a0)
	farcall Func_80cd6
	scf
	ret

DebugCreateBoosterPack: ; 127a6 (4:67a6)
.go_back
	ld a, [wDebugBoosterSelection]
	ld hl, Unknown_12919
	call InitAndPrintPauseMenu
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
	call InitAndPrintPauseMenu
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

Unknown_127f1: ; 127f1 (4:67f1)
	dw Unknown_1292a
	dw Unknown_1292a
	dw Unknown_1293b
	dw Unknown_1294c
	dw Unknown_1295d

Unknown_127fb: ; 127fb (4:67fb)
	db BOOSTER_COLOSSEUM_NEUTRAL
	db BOOSTER_EVOLUTION_NEUTRAL
	db BOOSTER_MYSTERY_NEUTRAL
	db BOOSTER_LABORATORY_NEUTRAL
	db BOOSTER_ENERGY_LIGHTNING_FIRE

DebugCredits: ; 12800 (4:6800)
	farcall Credits_1d6ad
	scf
	ret

DebugCGBTest: ; 12806 (4:6806)
	farcall Func_1c865
	scf
	ret

DebugSGBFrame: ; 1280c (4:680c)
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

DebugDuelMode: ; 12824 (4:6824)
	call EnableSRAM
	ld a, [sDebugDuelMode]
	and $01
	ld [sDebugDuelMode], a
	ld hl, Unknown_12908
	call InitAndPrintPauseMenu
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

DebugStandardBGCharacter: ; 1284c (4:684c)
	ld a, $80
	ld de, $0
	lb bc, 16, 16
	lb hl,  1, 16
	call FillRectangle
	ld a, $ff
	call Func_12863
	scf
	ret

DebugQuit: ; 12861 (4:6861)
	or a
	ret

Func_12863: ; 12863 (4:6863)
	push bc
	ld b, a
.asm_12865
	push bc
	call DoFrameIfLCDEnabled
	pop bc
	ldh a, [hKeysPressed]
	and b
	jr z, .asm_12865
	pop bc
	ret

Func_12871: ; 12871 (4:6871)
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call Set_OBJ_8x8
	call Func_1288c
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [hWX], a
	ldh [hWY], a
	call Set_WD_off
	ret

Func_1288c: ; 1288c (4:688c)
	push hl
	push bc
	push de
	ld a, %11100100
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	ld a, 4
	ld [wTextBoxFrameType], a
	bank1call SetDefaultPalettes
	call FlushAllPalettes
	pop de
	pop bc
	pop hl
	ret

DisplayPlayerNamingScreen:: ; 128a9 (4:68a9)
	; clear the name buffer.
	ld hl, wNameBuffer ; c500: name buffer.
	ld bc, NAME_BUFFER_LENGTH
	ld a, TX_END
	call FillMemoryWithA

	; get player's name
	; from the user into hl.
	ld hl, wNameBuffer
	farcall InputPlayerName

	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	call DisableLCD
	ld hl, wNameBuffer
	; get the first byte of the name buffer.
	ld a, [hl]
	or a
	; check if anything typed.
	jr nz, .no_name
	ld hl, .default_name
.no_name
	; set the default name.
	ld de, sPlayerName
	ld bc, NAME_BUFFER_LENGTH
	call EnableSRAM
	call CopyDataHLtoDE_SaveRegisters
	; it seems for integrity checking.
	call UpdateRNGSources
	ld [sPlayerName+$e], a
	call UpdateRNGSources
	ld [sPlayerName+$f], a
	call DisableSRAM
	ret

.default_name
	; "MARK": default player name.
	textfw3 "M", "A", "R", "K"
	db TX_END, TX_END, TX_END, TX_END

Unknown_128f7: ; 128f7 (4:68f7)
	db  0,  0 ; start menu coords
	db 16, 18 ; start menu text box dimensions

	db  2, 2 ; text alignment for InitTextPrinting
	tx Text037a
	db $ff

	db 1, 2 ; cursor x, cursor y
	db 1 ; y displacement between items
	db 11 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_12908: ; 12908 (4:6908)
	db 10, 0 ; start menu coords
	db 10, 6 ; start menu text box dimensions

	db 12, 2 ; text alignment for InitTextPrinting
	tx Text037b
	db $ff

	db 11, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_12919: ; 12919 (4:6919)
	db  0,  0 ; start menu coords
	db 12, 12 ; start menu text box dimensions

	db  2, 2 ; text alignment for InitTextPrinting
	tx Text037c
	db $ff

	db 1, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1292a: ; 1292a (4:692a)
	db 12,  0 ; start menu coords
	db  4, 16 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx Text037d
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 7 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1293b: ; 1293b (4:693b)
	db 12,  0 ; start menu coords
	db  4, 14 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx Text037e
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 6 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1294c: ; 1294c (4:694c)
	db 12,  0 ; start menu coords
	db  4, 12 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx Text037f
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1295d: ; 1295d (4:695d)
	db 12,  0 ; start menu coords
	db  4, 10 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx Text0380
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 4 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; disables all sprite animations
; and clears memory related to sprites
Func_1296e: ; 1296e (4:696e)
	push af
	ld a, [wd5d7]
	or a
	jr z, .asm_12977
	pop af
	ret

.asm_12977
	pop af
	push bc
	push hl
	xor a
	ld [wWhichSprite], a
	call GetFirstSpriteAnimBufferProperty
	lb bc, 0, SPRITE_ANIM_LENGTH

; disable all sprite animations
.loop_sprites
	xor a
	ld [hl], a ; set SPRITE_ANIM_ENABLED to 0
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp SPRITE_ANIM_BUFFER_CAPACITY
	jr nz, .loop_sprites

	call Func_12bf3
	call ZeroObjectPositions
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	pop hl
	pop bc
	ret

; creates a new entry in SpriteAnimBuffer, else loads the sprite if need be
CreateSpriteAndAnimBufferEntry: ; 1299f (4:699f)
	push af
	ld a, [wd5d7]
	or a
	jr z, .continue
	pop af
	ret
.continue
	pop af
	push bc
	push hl
	call Func_12c05
	ld [wCurrSpriteTileID], a
	xor a
	ld [wWhichSprite], a
	call GetFirstSpriteAnimBufferProperty
	ld bc, SPRITE_ANIM_LENGTH
.findFirstEmptyAnimField
	ld a, [hl]
	or a
	jr z, .foundEmptyAnimField
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp $10
	jr nz, .findFirstEmptyAnimField
	debug_nop
	scf
	jr .quit
.foundEmptyAnimField
	ld a, $1
	ld [hl], a
	call FillNewSpriteAnimBufferEntry
	or a
.quit
	pop hl
	pop bc
	ret

FillNewSpriteAnimBufferEntry: ; 129d9 (4:69d9)
	push hl
	push bc
	push hl
	inc hl
	ld c, SPRITE_ANIM_LENGTH - 1
	xor a
.clearSpriteAnimBufferEntryLoop
	ld [hli], a
	dec c
	jr nz, .clearSpriteAnimBufferEntryLoop
	pop hl
	ld bc, SPRITE_ANIM_ID - 1
	add hl, bc
	ld a, [wCurrSpriteTileID]
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ld bc, SPRITE_ANIM_COUNTER - SPRITE_ANIM_ID
	add hl, bc
	ld a, $ff
	ld [hl], a
	pop bc
	pop hl
	ret

DisableCurSpriteAnim: ; 129fa (4:69fa)
	ld a, [wWhichSprite]
	; fallthrough

; sets SPRITE_ANIM_ENABLED to false
; of sprite in register a
DisableSpriteAnim: ; 129fd (4:69fd)
	push af
	ld a, [wd5d7]
	or a
	jr z, .disable
	pop af
	ret
.disable
	pop af
	push hl
	push bc
	ld c, SPRITE_ANIM_ENABLED
	call GetSpriteAnimBufferProperty_SpriteInA
	ld [hl], FALSE
	pop bc
	pop hl
	ret

GetSpriteAnimCounter: ; 12a13 (4:6a13)
	ld a, [wWhichSprite]
	push hl
	push bc
	ld c, SPRITE_ANIM_COUNTER
	call GetSpriteAnimBufferProperty_SpriteInA
	ld a, [hl]
	pop bc
	pop hl
	ret

_HandleAllSpriteAnimations: ; 12a21 (4:6a21)
	push af
	ld a, [wd5d7] ; skip animating this frame if enabled
	or a
	jr z, .continue
	pop af
	ret
.continue
	pop af
	push af
	push bc
	push de
	push hl
	call ZeroObjectPositions
	xor a
	ld [wWhichSprite], a
	call GetFirstSpriteAnimBufferProperty
.spriteLoop
	ld a, [hl]
	or a
	jr z, .nextSprite ; skip if SPRITE_ANIM_ENABLED is 0
	call TryHandleSpriteAnimationFrame
	call LoadSpriteDataForAnimationFrame
.nextSprite
	ld bc, SPRITE_ANIM_LENGTH
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp SPRITE_ANIM_BUFFER_CAPACITY
	jr nz, .spriteLoop
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	pop hl
	pop de
	pop bc
	pop af
	ret

LoadSpriteDataForAnimationFrame: ; 12a5b (4:6a5b)
	push hl
	push bc
	inc hl
	ld a, [hli]
	ld [wCurrSpriteAttributes], a
	ld a, [hli]
	ld [wCurrSpriteXPos], a
	ld a, [hli]
	ld [wCurrSpriteYPos], a
	ld a, [hl]
	ld [wCurrSpriteTileID], a
	ld bc, SPRITE_ANIM_FLAGS - SPRITE_ANIM_TILE_ID
	add hl, bc
	ld a, [hl]
	and 1 << SPRITE_ANIM_FLAG_UNSKIPPABLE
	jr nz, .quit
	ld bc, SPRITE_ANIM_FRAME_BANK - SPRITE_ANIM_FLAGS
	add hl, bc
	ld a, [hli]
	ld [wd5d6], a
	or a
	jr z, .quit
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DrawSpriteAnimationFrame
.quit
	pop bc
	pop hl
	ret

; decrements the given sprite's movement counter (2x if SPRITE_ANIM_FLAG_SPEED is set)
; moves to the next animation frame if necessary
TryHandleSpriteAnimationFrame: ; 12a8b (4:6a8b)
	push hl
	push bc
	push de
	push hl
	ld d, 1
	ld bc, SPRITE_ANIM_FLAGS
	add hl, bc
	bit SPRITE_ANIM_FLAG_SPEED, [hl]
	jr z, .skipSpeedIncrease
	inc d
.skipSpeedIncrease
	pop hl
	ld bc, SPRITE_ANIM_COUNTER
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .exit
	sub d
	ld [hl], a
	jr z, .doNextAnimationFrame
	jr nc, .exit
.doNextAnimationFrame
	ld bc, SPRITE_ANIM_ENABLED - SPRITE_ANIM_COUNTER
	add hl, bc
	call HandleAnimationFrame
.exit
	pop de
	pop bc
	pop hl
	ret

StartNewSpriteAnimation: ; 12ab5 (4:6ab5)
	push hl
	push af
	ld c, SPRITE_ANIM_ID
	call GetSpriteAnimBufferProperty
	pop af
	cp [hl]
	pop hl
	ret z
	; fallthrough

StartSpriteAnimation: ; 12ac0 (4:6ac0)
	push hl
	call LoadSpriteAnimPointers
	call HandleAnimationFrame
	pop hl
	ret

; a = sprite animation
; c = animation counter value
Func_12ac9: ; 12ac9 (4:6ac9)
	push bc
	ld b, a
	ld a, c
	or a
	ld a, b
	pop bc
	jr z, StartSpriteAnimation

	push hl
	push bc
	call LoadSpriteAnimPointers
	ld a, $ff
	call GetAnimFramePointerFromOffset
	pop bc
	ld a, c
	call SetAnimationCounterAndLoop
	pop hl
	ret

; Given an animation ID, fills the current sprite's Animation Pointer and Frame Offset Pointer
; a - Animation ID for current sprite
LoadSpriteAnimPointers: ; 12ae2 (4:6ae2)
	push bc
	push af
	call GetFirstSpriteAnimBufferProperty
	pop af
	push hl
	ld bc, SPRITE_ANIM_ID
	add hl, bc
	ld [hli], a
	push hl
	ld l, 6 ; SpriteAnimations
	farcall GetMapDataPointer
	farcall LoadGraphicsPointerFromHL
	pop hl ; hl is animation bank
	ld a, [wTempPointerBank]
	ld [hli], a
	ld a, [wTempPointer + 0]
	ld [hli], a
	ld c, a
	ld a, [wTempPointer + 1]
	ld [hli], a
	ld b, a
	; offset pointer = pointer + $3
	ld a, $3
	add c
	ld [hli], a
	ld a, $0
	adc b
	ld [hli], a
	pop hl
	pop bc
	ret

; hl - beginning of current sprite_anim_buffer
; Handles a full animation frame using all values in animation structure
; (frame data offset, anim counter, X Mov, Y Mov)
HandleAnimationFrame: ; 12b13 (4:6b13)
	push bc
	push de
	push hl
.tryHandlingFrame
	push hl
	ld bc, SPRITE_ANIM_BANK
	add hl, bc
	ld a, [hli]
	ld [wTempPointerBank], a

	inc hl
	inc hl
	ld a, [hl] ; SPRITE_ANIM_FRAME_OFFSET_POINTER
	ld [wTempPointer + 0], a
	add SPRITE_FRAME_OFFSET_SIZE ; advance FRAME_OFFSET_POINTER by 1 frame, 4 bytes
	ld [hli], a
	ld a, [hl]
	ld [wTempPointer + 1], a
	adc 0
	ld [hl], a

	ld de, wLoadedPalData
	ld bc, SPRITE_FRAME_OFFSET_SIZE
	call CopyBankedDataToDE
	pop hl ; beginning of current sprite_anim_buffer
	ld de, wLoadedPalData
	ld a, [de]
	call GetAnimFramePointerFromOffset
	inc de
	ld a, [de]
	call SetAnimationCounterAndLoop
	jr c, .tryHandlingFrame
	inc de
	ld bc, SPRITE_ANIM_COORD_X
	add hl, bc
	push hl
	ld bc, SPRITE_ANIM_FLAGS - SPRITE_ANIM_COORD_X
	add hl, bc
	ld b, [hl]
	pop hl
	ld a, [de]
	bit SPRITE_ANIM_FLAG_X_SUBTRACT, b
	jr z, .addXOffset
	cpl
	inc a
.addXOffset
	add [hl]
	ld [hli], a
	inc de
	ld a, [de]
	bit SPRITE_ANIM_FLAG_Y_SUBTRACT, b
	jr z, .addYOffset
	cpl
	inc a
.addYOffset
	add [hl]
	ld [hl], a
	pop hl
	pop de
	pop bc
	ret

; Calls GetAnimationFramePointer after setting up wTempPointerBank
; and wVRAMTileOffset
; a - frame offset from Animation Data
; hl - beginning of Sprite Anim Buffer
GetAnimFramePointerFromOffset: ; 12b6a (4:6b6a)
	ld [wVRAMTileOffset], a
	push hl
	push bc
	push de
	push hl
	ld bc, SPRITE_ANIM_BANK
	add hl, bc
	ld a, [hli]
	ld [wTempPointerBank], a
	ld a, [hli]
	ld [wTempPointer + 0], a
	ld a, [hli]
	ld [wTempPointer + 1], a
	pop hl
	call GetAnimationFramePointer ; calls with the original map data script pointer/bank
	pop de
	pop bc
	pop hl
	ret

; Sets the animation counter for the current sprite. If the value is zero, loop the animation
; a - new animation counter
SetAnimationCounterAndLoop: ; 12b89 (4:6b89)
	push hl
	push bc
	ld bc, SPRITE_ANIM_COUNTER
	add hl, bc
	ld [hl], a
	or a
	jr nz, .exit
	ld bc, SPRITE_ANIM_POINTER - SPRITE_ANIM_COUNTER
	add hl, bc
	ld a, [hli]
	add $3 ; skip base bank/pointer at beginning of data structure
	ld c, a
	ld a, [hli]
	adc 0
	ld b, a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	scf
.exit
	pop bc
	pop hl
	ret

Func_12ba7: ; 12ba7 (4:6ba7)
	push hl
	push bc
	push de
	call EnableSRAM
	ld hl, wSpriteAnimBuffer
	ld de, sGeneralSaveDataEnd
	ld bc, $100
	call CopyDataHLtoDE
	ld hl, wSpriteVRAMBuffer
	ld bc, $40
	call CopyDataHLtoDE
	ld a, [wSpriteVRAMBufferSize]
	ld [de], a
	call DisableSRAM
	pop de
	pop bc
	pop hl
	ret

Func_12bcd: ; 12bcd (4:6bcd)
	push hl
	push bc
	push de
	call EnableSRAM
	ld hl, sGeneralSaveDataEnd
	ld de, wSpriteAnimBuffer
	ld bc, $100
	call CopyDataHLtoDE
	ld de, wSpriteVRAMBuffer
	ld bc, $40
	call CopyDataHLtoDE
	ld a, [hl]
	ld [wSpriteVRAMBufferSize], a
	call DisableSRAM
	pop de
	pop bc
	pop hl
	ret

; clears wSpriteVRAMBufferSize and wSpriteVRAMBuffer
Func_12bf3: ; 12bf3 (4:6bf3)
	push hl
	push bc
	xor a
	ld [wSpriteVRAMBufferSize], a
	ld c, $40
	ld hl, wSpriteVRAMBuffer
.asm_12bfe
	ld [hli], a
	dec c
	jr nz, .asm_12bfe
	pop bc
	pop hl
	ret

; gets some value based on the sprite in a and wSpriteVRAMBuffer
; loads the sprites data if it doesn't already exist
Func_12c05: ; 12c05 (4:6c05)
	push hl
	push bc
	push de
	ld b, a
	ld d, $0
	ld a, [wSpriteVRAMBufferSize]
	ld c, a
	ld hl, wSpriteVRAMBuffer
	or a
	jr z, .tryToAddSprite

.findSpriteMatchLoop
	inc hl
	ld a, [hl]
	cp b
	jr z, .foundSpriteMatch
	inc hl
	ld a, [hli]
	add [hl] ; add tile size to tile offset
	ld d, a
	inc hl
	dec c
	jr nz, .findSpriteMatchLoop

.tryToAddSprite
	ld a, [wSpriteVRAMBufferSize]
	cp $10
	jr nc, .quitFail
	inc a
	ld [wSpriteVRAMBufferSize], a ; increase number of entries by 1
	inc hl
	push hl
	ld a, b
	ld [hli], a ; store sprite index
	call Func_12c4f
	push af
	ld a, d
	ld [hli], a ; store tile offset
	pop af
	ld [hl], a ; store tile size
	pop hl

.foundSpriteMatch
	dec hl
	inc [hl] ; mark this entry as valid
	inc hl
	inc hl
	ld a, [hli]
	add [hl]
	cp $81
	jr nc, .quitFail ; exceeds total tile size
	ld a, d
	or a
	jr .quitSucceed

.quitFail
	debug_nop
	xor a
	scf
.quitSucceed
	pop de
	pop bc
	pop hl
	ret

; input:
; a = sprite index within the data map
; d = tile offset in VRAM
; output:
; a = number of tiles in sprite
Func_12c4f: ; 12c4f (4:6c4f)
	push af
	xor a
	ld [wd4cb], a
	ld a, d
	ld [wVRAMTileOffset], a
	pop af
	farcall Func_8025b
	ret

Func_12c5e: ; 12c5e (4:6c5e)
	push hl
	push bc
	push de
	ld c, $10
	ld de, $4
	ld hl, wSpriteVRAMBuffer
.asm_12c69
	ld a, [hl]
	or a
	jr z, .asm_12c77
	push hl
	push de
	inc hl
	ld a, [hli]
	ld d, [hl]
	call Func_12c4f
	pop de
	pop hl
.asm_12c77
	add hl, de
	dec c
	jr nz, .asm_12c69
	pop de
	pop bc
	pop hl
	ret

; input:
; a = scene ID (SCENE_* constant)
; b = base X position of scene in tiles
; c = base Y position of scene in tiles
_LoadScene: ; 12c7f (4:6c7f)
	push hl
	push bc
	push de
	ld e, a
	ld a, [wCurTilemap]
	push af
	ld a, [wd291]
	push af
	ld a, e
	push bc
	push af
	ld a, b
	add a
	add a
	add a
	add $08
	ld [wSceneBaseX], a
	ld a, c
	add a
	add a
	add a
	add $10
	ld [wSceneBaseY], a
	pop af
	add a
	ld c, a
	ld b, 0
	ld hl, ScenePointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wSceneSGBPacketPtr], a
	ld a, [hli]
	ld [wSceneSGBPacketPtr + 1], a
	ld a, [hli]
	ld [wSceneSGBRoutinePtr], a
	ld a, [hli]
	ld [wSceneSGBRoutinePtr + 1], a
	call LoadScene_LoadCompressedSGBPacket
	ld a, %11100100
	ld [wBGP], a
	ld a, [wConsole]
	cp CONSOLE_CGB
	ld a, [hli]
	jr nz, .not_cgb_1
	ld a, [hl]
.not_cgb_1
	inc hl
	push af ; palette
	xor a
	ld [wd4ca], a
	ld a, [hli]
	ld [wd4cb], a ; palette offset
	ld [wd291], a ; palette offset
	pop af ; palette
	farcall SetBGPAndLoadedPal ; load palette
	ld a, [wConsole]
	cp CONSOLE_CGB
	ld a, [hli]
	jr nz, .not_cgb_2
	ld a, [hl]
.not_cgb_2
	inc hl
	ld [wCurTilemap], a
	pop bc
	push bc
	farcall LoadTilemap_ToVRAM
	pop bc ; base x,y
	call LoadScene_LoadSGBPacket
	ld a, [hli]
	ld [wd4ca], a ; tile offset
	ld a, [hli]
	ld [wd4cb], a ; vram0 or vram1
	farcall LoadTilesetGfx
.next_sprite
	ld a, [hli]
	or a
	jr z, .done ; no sprite
	ld [wSceneSprite], a
	ld a, [wConsole]
	cp CONSOLE_CGB
	ld a, [hli]
	jr nz, .not_cgb_3
	ld a, [hl]
.not_cgb_3
	inc hl
	push af ; sprite palette
	xor a
	ld [wd4ca], a
	ld a, [hli]
	ld [wd4cb], a ; palette offset
	pop af ; sprite palette
	farcall LoadPaletteData
.next_animation
	ld a, [hli]
	or a
	jr z, .next_sprite
	dec hl
	ld a, [wConsole]
	cp CONSOLE_CGB
	ld a, [hli]
	jr nz, .not_cgb_4
	ld a, [hl]
.not_cgb_4
	inc hl
	ld [wSceneSpriteAnimation], a
	ld a, [wSceneSprite]
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [wSceneSpriteIndex], a
	push hl
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld e, l
	ld d, h
	pop hl
	ld a, [wSceneBaseX]
	add [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [wSceneBaseY]
	add [hl]
	ld [de], a
	inc hl
	ld a, [wSceneSpriteAnimation]
	cp $ff
	jr z, .no_animation
	farcall StartSpriteAnimation
.no_animation
	jr .next_animation
.done
	pop af
	ld [wd291], a
	pop af
	ld [wCurTilemap], a
	pop de
	pop bc
	pop hl
	ret

ScenePointers: ; 12d6f (4:6d6f)
	dw Scene_TitleScreen
	dw Scene_ColosseumBooster
	dw Scene_EvolutionBooster
	dw Scene_MysteryBooster
	dw Scene_LaboratoryBooster
	dw Scene_CharizardIntro
	dw Scene_ScytherIntro
	dw Scene_AerodactylIntro
	dw Scene_GradientBlackAndRed
	dw Scene_GradientWhiteAndRed
	dw Scene_GradientBlackAndGreen
	dw Scene_GradientWhiteAndGreen
	dw Scene_ColorWheel
	dw Scene_ColorTest
	dw Scene_GameBoyLinkConnecting
	dw Scene_GameBoyLinkTransmitting
	dw Scene_GameBoyLinkNotConnected
	dw Scene_GameBoyPrinterTransmitting
	dw Scene_GameBoyPrinterNotConnected
	dw Scene_CardPop
	dw Scene_CardPopError
	dw Scene_JapaneseTitleScreen
	dw Scene_Nintendo
	dw Scene_Companies
	dw Scene_JapaneseTitleScreen2
	dw Scene_Copyright
	dw Scene_JapaneseTitleScreen2
	dw Scene_ColorPalette

; format:
; dw compressed sgb packet
; dw custom sgb packet loading routine
; db palette (non-cgb), palette (cgb), palette offset
; db tilemap (non-cgb), tilemap (cgb), vram tile offset, vram0 or vram1
; db sprite
;
; if sprite is non-zero:
; db palette (non-cgb), palette (cgb), palette offset
; db animation (non-cgb), animation (cgb), x offset, y offset
; dw 0-terminator

Scene_TitleScreen: ; 12da7 (4:6da7)
	dw SGBData_TitleScreen
	dw NULL
	db PALETTE_25, PALETTE_25, $00
	db TILEMAP_TITLE_SCREEN, TILEMAP_TITLE_SCREEN_CGB, $00, $00
	db $00

Scene_JapaneseTitleScreen: ; 12db3 (4:6db3)
	dw SGBData_TitleScreen
	dw NULL
	db PALETTE_25, PALETTE_25, $00
	db TILEMAP_JAPANESE_TITLE_SCREEN, TILEMAP_JAPANESE_TITLE_SCREEN_CGB, $80, $00
	db $00

Scene_ColosseumBooster: ; 12dbf (4:6dbf)
	dw SGBData_ColosseumBooster
	dw NULL
	db PALETTE_108, PALETTE_101, $01
	db TILEMAP_COLOSSEUM, TILEMAP_COLOSSEUM_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_EvolutionBooster: ; 12dd4 (4:6dd4)
	dw SGBData_EvolutionBooster
	dw NULL
	db PALETTE_108, PALETTE_102, $01
	db TILEMAP_EVOLUTION, TILEMAP_EVOLUTION_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_MysteryBooster: ; 12de9 (4:6de9)
	dw SGBData_MysteryBooster
	dw NULL
	db PALETTE_108, PALETTE_103, $01
	db TILEMAP_MYSTERY, TILEMAP_MYSTERY_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_LaboratoryBooster: ; 12dfe (4:6dfe)
	dw SGBData_LaboratoryBooster
	dw NULL
	db PALETTE_108, PALETTE_104, $01
	db TILEMAP_LABORATORY, TILEMAP_LABORATORY_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_CharizardIntro: ; 12e13 (4:6e13)
	dw SGBData_CharizardIntro
	dw NULL
	db PALETTE_108, PALETTE_105, $01
	db TILEMAP_CHARIZARD_INTRO, TILEMAP_CHARIZARD_INTRO_CGB, $80, $00
	db $00

Scene_ScytherIntro: ; 12e1f (4:6e1f)
	dw SGBData_ScytherIntro
	dw NULL
	db PALETTE_108, PALETTE_106, $01
	db TILEMAP_SCYTHER_INTRO, TILEMAP_SCYTHER_INTRO_CGB, $80, $00
	db $00

Scene_AerodactylIntro: ; 12e2b (4:6e2b)
	dw SGBData_AerodactylIntro
	dw NULL
	db PALETTE_108, PALETTE_107, $01
	db TILEMAP_AERODACTYL_INTRO, TILEMAP_AERODACTYL_INTRO_CGB, $80, $00
	db $00

Scene_GradientBlackAndRed: ; 12e37 (4:6e37)
	dw NULL
	dw NULL
	db PALETTE_94, PALETTE_94, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientWhiteAndRed: ; 12e43 (4:6e43)
	dw NULL
	dw NULL
	db PALETTE_95, PALETTE_95, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientBlackAndGreen: ; 12e4f (4:6e4f)
	dw NULL
	dw NULL
	db PALETTE_96, PALETTE_96, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientWhiteAndGreen: ; 12e5b (4:6e5b)
	dw NULL
	dw NULL
	db PALETTE_97, PALETTE_97, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_ColorWheel: ; 12e67 (4:6e67)
	dw NULL
	dw NULL
	db PALETTE_98, PALETTE_98, $00
	db TILEMAP_SOLID_TILES_2, TILEMAP_SOLID_TILES_2, $01, $00
	db $00

Scene_ColorTest: ; 12e73 (4:6e73)
	dw NULL
	dw NULL
	db PALETTE_99, PALETTE_99, $00
	db TILEMAP_SOLID_TILES_3, TILEMAP_SOLID_TILES_3, $01, $00
	db $00

Scene_ColorPalette: ; 12e7f (4:6e7f)
	dw NULL
	dw NULL
	db PALETTE_110, PALETTE_110, $00
	db TILEMAP_SOLID_TILES_4, TILEMAP_SOLID_TILES_4, $fc, $01
	db $00

Scene_GameBoyLinkConnecting: ; 12e8b (4:6e8b)
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_GAMEBOY_LINK_CONNECTING, TILEMAP_GAMEBOY_LINK_CONNECTING_CGB, $90, $00
	db $00

Scene_GameBoyLinkTransmitting: ; 12e97 (4:6e97)
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_GAMEBOY_LINK, TILEMAP_GAMEBOY_LINK_CGB, $90, $00
	db SPRITE_DUEL_52
	db PALETTE_114, PALETTE_114, $00
	db SPRITE_ANIM_179, SPRITE_ANIM_176, $50, $50
	dw $00

Scene_GameBoyLinkNotConnected: ; 12eac (4:6eac)
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_GAMEBOY_LINK, TILEMAP_GAMEBOY_LINK_CGB, $90, $00
	db SPRITE_DUEL_52
	db PALETTE_114, PALETTE_114, $00
	db SPRITE_ANIM_180, SPRITE_ANIM_177, $50, $50
	dw $00

Scene_GameBoyPrinterTransmitting: ; 12ec1 (4:6ec1)
	dw SGBData_GameBoyPrinter
	dw LoadScene_SetGameBoyPrinterAttrBlk
	db PALETTE_112, PALETTE_112, $00
	db TILEMAP_GAMEBOY_PRINTER, TILEMAP_GAMEBOY_PRINTER_CGB, $90, $00
	db SPRITE_DUEL_53
	db PALETTE_115, PALETTE_115, $00
	db SPRITE_ANIM_183, SPRITE_ANIM_181, $50, $30
	dw $00

Scene_GameBoyPrinterNotConnected: ; 12ed6 (4:6ed6)
	dw SGBData_GameBoyPrinter
	dw LoadScene_SetGameBoyPrinterAttrBlk
	db PALETTE_112, PALETTE_112, $00
	db TILEMAP_GAMEBOY_PRINTER, TILEMAP_GAMEBOY_PRINTER_CGB, $90, $00
	db SPRITE_DUEL_53
	db PALETTE_115, PALETTE_115, $00
	db SPRITE_ANIM_184, SPRITE_ANIM_182, $50, $30
	dw $00

Scene_CardPop: ; 12eeb (4:6eeb)
	dw SGBData_CardPop
	dw LoadScene_SetCardPopAttrBlk
	db PALETTE_113, PALETTE_113, $00
	db TILEMAP_CARD_POP, TILEMAP_CARD_POP_CGB, $80, $00
	db SPRITE_DUEL_54
	db PALETTE_116, PALETTE_116, $00
	db SPRITE_ANIM_187, SPRITE_ANIM_185, $50, $40
	dw $00

Scene_CardPopError: ; 12f00 (4:6f00)
	dw SGBData_CardPop
	dw LoadScene_SetCardPopAttrBlk
	db PALETTE_113, PALETTE_113, $00
	db TILEMAP_CARD_POP, TILEMAP_CARD_POP_CGB, $80, $00
	db SPRITE_DUEL_54
	db PALETTE_116, PALETTE_116, $00
	db SPRITE_ANIM_188, SPRITE_ANIM_186, $50, $40
	dw $00

Scene_Nintendo: ; 12f15 (4:6f15)
	dw NULL
	dw NULL
	db PALETTE_27, PALETTE_27, $00
	db TILEMAP_NINTENDO, TILEMAP_NINTENDO, $00, $00
	db $00

Scene_Companies: ; 12f21 (4:6f21)
	dw NULL
	dw NULL
	db PALETTE_28, PALETTE_28, $00
	db TILEMAP_COMPANIES, TILEMAP_COMPANIES, $00, $00
	db $00

Scene_Copyright: ; 12f2d (4:6f2d)
	dw NULL
	dw NULL
	db PALETTE_26, PALETTE_26, $00
	db TILEMAP_COPYRIGHT, TILEMAP_COPYRIGHT_CGB, $00, $00
	db $00

Scene_JapaneseTitleScreen2: ; 12f39 (4:6f39)
	dw NULL
	dw NULL
	db PALETTE_109, PALETTE_100, $00
	db TILEMAP_JAPANESE_TITLE_SCREEN_2, TILEMAP_JAPANESE_TITLE_SCREEN_2_CGB, $01, $00
	db $00

LoadScene_LoadCompressedSGBPacket: ; 12f45 (4:6f45)
	ld a, [wConsole]
	cp CONSOLE_SGB
	ret nz
	push hl
	ld hl, wSceneSGBPacketPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .skip
	farcall Func_703cb
.skip
	pop hl
	ret

LoadScene_LoadSGBPacket: ; 12f5b (4:6f5b)
	ld a, [wConsole]
	cp CONSOLE_SGB
	ret nz
	push hl
	push bc
	push de
	ld hl, wSceneSGBPacketPtr
	ld a, [hli]
	or [hl]
	jr z, .done
	ld hl, wSceneSGBRoutinePtr + 1
	ld a, [hld]
	or [hl]
	jr z, .use_default
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CallHL2
	jr .done
.use_default
	ld l, %001010 ; outside, border, inside palette numbers
	ld a, [wBGMapWidth]
	ld d, a
	ld a, [wBGMapHeight]
	ld e, a
	farcall Func_70498
.done
	pop de
	pop bc
	pop hl
	ret

LoadScene_SetGameBoyPrinterAttrBlk: ; 12f8c (4:6f8c)
	push hl
	push bc
	push de
	ld hl, SGBPacket_GameBoyPrinter
	call SendSGB
	pop de
	pop bc
	pop hl
	ret

SGBPacket_GameBoyPrinter: ; 12f99 (4:6f99)
	sgb ATTR_BLK, 1
	db 1 ; number of data sets
	db ATTR_BLK_CTRL_OUTSIDE | ATTR_BLK_CTRL_LINE | ATTR_BLK_CTRL_INSIDE
	db %101111 ; Color Palette Designation
	db 11 ; x1
	db 0  ; y1
	db 16 ; x2
	db 9  ; y2
	ds 6 ; data set 2
	ds 2 ; data set 3

LoadScene_SetCardPopAttrBlk: ; 12fa9 (4:6fa9)
	push hl
	push bc
	push de
	ld hl, SGBPacket_CardPop
	call SendSGB
	pop de
	pop bc
	pop hl
	ret

SGBPacket_CardPop: ; 12fb6 (4:6fb6)
	sgb ATTR_BLK, 1
	db 1 ; number of data sets
	db ATTR_BLK_CTRL_OUTSIDE | ATTR_BLK_CTRL_LINE | ATTR_BLK_CTRL_INSIDE
	db %101111 ; Color Palette Designation
	db 0  ; x1
	db 0  ; y1
	db 19 ; x2
	db 4  ; y3
	ds 6 ; data set 2
	ds 2 ; data set 3

Func_12fc6: ; 12fc6 (4:6fc6)
	ld a, [wd291]
	push af
	push de
	push bc
	ld de, wNamingScreenNamePosition
	ld a, [wCurTilemap]
	cp TILEMAP_PLAYER
	jr z, .asm_12fd9
	ld de, sTextSpeed
.asm_12fd9
	ld a, e
	ld [wd291], a
	farcall LoadTilemap_ToVRAM
	ld a, [wd61e]
	add a
	add a
	ld c, a
	ld b, $00
	ld hl, Unknown_1301e
	add hl, bc
	ld a, [hli]
	push hl
	ld [wCurTileset], a
	ld a, d
	ld [wd4ca], a
	xor a
	ld [wd4cb], a
	farcall LoadTilesetGfx
	pop hl
	xor a
	ld [wd4ca], a
	ld a, [wd291]
	ld [wd4cb], a
	ld a, [hli]
	push hl
	farcall SetBGPAndLoadedPal
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	farcall Func_7041d
	pop de
	pop af
	ld [wd291], a
	ret

Unknown_1301e: ; 1301e (4:701e)
	db TILESET_PLAYER, PALETTE_119
	dw SGBData_PlayerPortraitPals

	db TILESET_PLAYER, PALETTE_119
	dw SGBData_PlayerPortraitPals

	db TILESET_RONALD, PALETTE_121
	dw SGBData_RonaldPortraitPals

	db TILESET_SAM, PALETTE_122
	dw SGBData_SamPortraitPals

	db TILESET_IMAKUNI, PALETTE_123
	dw SGBData_ImakuniPortraitPals

	db TILESET_NIKKI, PALETTE_124
	dw SGBData_NikkiPortraitPals

	db TILESET_RICK, PALETTE_125
	dw SGBData_RickPortraitPals

	db TILESET_KEN, PALETTE_126
	dw SGBData_KenPortraitPals

	db TILESET_AMY, PALETTE_127
	dw SGBData_AmyPortraitPals

	db TILESET_ISAAC, PALETTE_128
	dw SGBData_IsaacPortraitPals

	db TILESET_MITCH, PALETTE_129
	dw SGBData_MitchPortraitPals

	db TILESET_GENE, PALETTE_130
	dw SGBData_GenePortraitPals

	db TILESET_MURRAY, PALETTE_131
	dw SGBData_MurrayPortraitPals

	db TILESET_COURTNEY, PALETTE_132
	dw SGBData_CourtneyPortraitPals

	db TILESET_STEVE, PALETTE_133
	dw SGBData_StevePortraitPals

	db TILESET_JACK, PALETTE_134
	dw SGBData_JackPortraitPals

	db TILESET_ROD, PALETTE_135
	dw SGBData_RodPortraitPals

	db TILESET_JOSEPH, PALETTE_136
	dw SGBData_JosephPortraitPals

	db TILESET_DAVID, PALETTE_137
	dw SGBData_DavidPortraitPals

	db TILESET_ERIK, PALETTE_138
	dw SGBData_ErikPortraitPals

	db TILESET_JOHN, PALETTE_139
	dw SGBData_JohnPortraitPals

	db TILESET_ADAM, PALETTE_140
	dw SGBData_AdamPortraitPals

	db TILESET_JONATHAN, PALETTE_141
	dw SGBData_JonathanPortraitPals

	db TILESET_JOSHUA, PALETTE_142
	dw SGBData_JoshuaPortraitPals

	db TILESET_NICHOLAS, PALETTE_143
	dw SGBData_NicholasPortraitPals

	db TILESET_BRANDON, PALETTE_144
	dw SGBData_BrandonPortraitPals

	db TILESET_MATTHEW, PALETTE_145
	dw SGBData_MatthewPortraitPals

	db TILESET_RYAN, PALETTE_146
	dw SGBData_RyanPortraitPals

	db TILESET_ANDREW, PALETTE_147
	dw SGBData_AndrewPortraitPals

	db TILESET_CHRIS, PALETTE_148
	dw SGBData_ChrisPortraitPals

	db TILESET_MICHAEL, PALETTE_149
	dw SGBData_MichaelPortraitPals

	db TILESET_DANIEL, PALETTE_150
	dw SGBData_DanielPortraitPals

	db TILESET_ROBERT, PALETTE_151
	dw SGBData_RobertPortraitPals

	db TILESET_BRITTANY, PALETTE_152
	dw SGBData_BrittanyPortraitPals

	db TILESET_KRISTIN, PALETTE_153
	dw SGBData_KristinPortraitPals

	db TILESET_HEATHER, PALETTE_154
	dw SGBData_HeatherPortraitPals

	db TILESET_SARA, PALETTE_155
	dw SGBData_SaraPortraitPals

	db TILESET_AMANDA, PALETTE_156
	dw SGBData_AmandaPortraitPals

	db TILESET_JENNIFER, PALETTE_157
	dw SGBData_JenniferPortraitPals

	db TILESET_JESSICA, PALETTE_158
	dw SGBData_JessicaPortraitPals

	db TILESET_STEPHANIE, PALETTE_159
	dw SGBData_StephaniePortraitPals

	db TILESET_AARON, PALETTE_160
	dw SGBData_AaronPortraitPals

	db TILESET_PLAYER, PALETTE_120
	dw SGBData_LinkOpponentPortraitPals

LoadBoosterGfx: ; 130ca (4:70ca)
	push hl
	push bc
	push de
	ld e, a
	ld a, [wCurTilemap]
	push af
	push bc
	ld a, e
	call _LoadScene
	call FlushAllPalettes
	call SetBoosterLogoOAM
	pop bc
	pop af
	ld [wCurTilemap], a
	pop de
	pop bc
	pop hl
	ret

SetBoosterLogoOAM: ; 130e6 (4:70e6)
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret nz
	push hl
	push bc
	push de
	push bc
	xor a
	ld [wd4cb], a
	ld [wd4ca], a
	ld a, SPRITE_BOOSTER_PACK_OAM
	farcall Func_8025b
	pop bc
	call ZeroObjectPositions
	ld hl, BoosterLogoOAM
	ld c, [hl]
	inc hl
.oam_loop
	push bc
	ldh a, [hSCX]
	ld d, a
	ldh a, [hSCY]
	ld e, a
	ld a, [wSceneBaseY]
	sub e
	add [hl]
	ld e, a
	inc hl
	ld a, [wSceneBaseX]
	sub d
	add [hl]
	ld d, a
	inc hl
	ld a, [wd61f]
	add [hl]
	ld c, a
	inc hl
	ld b, [hl]
	inc hl
	call SetOneObjectAttributes
	pop bc
	dec c
	jr nz, .oam_loop
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	pop de
	pop bc
	pop hl
	ret

BoosterLogoOAM: ; 13132 (4:7132)
	db $20
	db $00, $00, $00, $00
	db $00, $08, $01, $00
	db $00, $10, $02, $00
	db $00, $18, $03, $00
	db $00, $20, $04, $00
	db $00, $28, $05, $00
	db $00, $30, $06, $00
	db $00, $38, $07, $00
	db $08, $00, $10, $00
	db $08, $08, $11, $00
	db $08, $10, $12, $00
	db $08, $18, $13, $00
	db $08, $20, $14, $00
	db $08, $28, $15, $00
	db $08, $30, $16, $00
	db $08, $38, $17, $00
	db $10, $00, $08, $00
	db $10, $08, $09, $00
	db $10, $10, $0a, $00
	db $10, $18, $0b, $00
	db $10, $20, $0c, $00
	db $10, $28, $0d, $00
	db $10, $30, $0e, $00
	db $10, $38, $0f, $00
	db $18, $00, $18, $00
	db $18, $08, $19, $00
	db $18, $10, $1a, $00
	db $18, $18, $1b, $00
	db $18, $20, $1c, $00
	db $18, $28, $1d, $00
	db $18, $30, $1e, $00
	db $18, $38, $1f, $00

Func_131b3: ; 131b3 (4:71b3)
	call ChallengeMachine_Initialize
	call EnableSRAM
	xor a
	ld [sTotalChallengeMachineWins], a
	ld [sTotalChallengeMachineWins + 1], a
	ld [sPresentConsecutiveWins], a
	ld [sPresentConsecutiveWins + 1], a
	ld [sPresentConsecutiveWinsBackup], a
	ld [sPresentConsecutiveWinsBackup + 1], a
	ld [sPlayerInChallengeMachine], a
	call DisableSRAM
	ret

; if a challenge is already in progress, then resume
; otherwise, start a new 5 round challenge
ChallengeMachine_Start: ; 131d3 (4:71d3)
	ld a, 0
	ld [wLineSeparation], a
	call Func_10a9b
	call ChallengeMachine_Initialize

	call EnableSRAM
	ld a, [sPlayerInChallengeMachine]
	call DisableSRAM
	cp $ff
	jr z, .resume_challenge

; new challenge
	call ChallengeMachine_PickOpponentSequence
	call ChallengeMachine_DrawScoreScreen
	call FlashWhiteScreen
	ldtx hl, PlayTheChallengeMachineText
	call YesOrNoMenuWithText_SetCursorToYes
	jp c, .end_challenge

	ldtx hl, LetUsChooseYourOpponentText
	call PrintScrollableText_NoTextBoxLabel
	call Func_10ab4
	call EnableSRAM
	xor a
	ld [sPresentConsecutiveWinsBackup], a
	ld [sPresentConsecutiveWinsBackup + 1], a
	call DisableSRAM

	call ChallengeMachine_DrawOpponentList
	call FlashWhiteScreen
	ldtx hl, YourOpponentsForThisGameText
	call PrintScrollableText_NoTextBoxLabel
; begin challenge loop
.next_opponent
	call ChallengeMachine_GetCurrentOpponent
	call ChallengeMachine_AreYouReady
	jr nc, .start_duel
	ldtx hl, IfYouQuitTheDuelText
	call PrintScrollableText_NoTextBoxLabel
	ldtx hl, WouldYouLikeToQuitTheDuelText
	call YesOrNoMenuWithText
	jr c, .next_opponent
	jp .quit

.start_duel
	call EnableSRAM
	ld a, $ff
	ld [sPlayerInChallengeMachine], a
	call DisableSRAM
	call ChallengeMachine_Duel
.resume_challenge
	call EnableSRAM
	xor a
	ld [sPlayerInChallengeMachine], a
	bank1call DiscardSavedDuelData
	call DisableSRAM
	call ChallengeMachine_GetCurrentOpponent
	call ChallengeMachine_RecordDuelResult
	call ChallengeMachine_DrawOpponentList
	call FlashWhiteScreen
	ld a, [wDuelResult]
	or a
	jr nz, .lost
; won
	call ChallengeMachine_DuelWon
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	cp NUM_CHALLENGE_MACHINE_OPPONENTS - 1
	jr z, .defeated_five_opponents
	ld hl, sChallengeMachineOpponentNumber
	inc [hl]
	call DisableSRAM
	jr .next_opponent

.defeated_five_opponents
	ld hl, sTotalChallengeMachineWins
	call ChallengeMachine_IncrementHLMax999
	call Func_10ab4
	call ChallengeMachine_CheckForNewRecord
	call ChallengeMachine_DrawScoreScreen
	call FlashWhiteScreen
	call EnableSRAM
	ld a, [sTotalChallengeMachineWins]
	ld [wTxRam3], a
	ld a, [sTotalChallengeMachineWins + 1]
	ld [wTxRam3 + 1], a
	call DisableSRAM
	ldtx hl, SuccessfullyDefeated5OpponentsText
	call PrintScrollableText_NoTextBoxLabel
	jr .end_challenge

.lost
	call ChallengeMachine_GetCurrentOpponent
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	inc a
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	call DisableSRAM
	call ChallengeMachine_GetOpponentNameAndDeck
	ld a, [wOpponentName]
	ld [wTxRam2], a
	ld a, [wOpponentName + 1]
	ld [wTxRam2 + 1], a
	ldtx hl, LostToTheNthOpponentText
	call PrintScrollableText_NoTextBoxLabel
.quit
	call ChallengeMachine_PrintFinalConsecutiveWinStreak
	call Func_10ab4
	call ChallengeMachine_CheckForNewRecord
	call ChallengeMachine_DrawScoreScreen
	call FlashWhiteScreen
	call EnableSRAM
; reset streak
	xor a
	ld [sPresentConsecutiveWins], a
	ld [sPresentConsecutiveWins + 1], a
	call DisableSRAM
.end_challenge ; end, win or lose
	call ChallengeMachine_CheckForNewRecord ; redundant?
	call EnableSRAM
	ld a, [sPresentConsecutiveWins]
	ld [sPresentConsecutiveWinsBackup], a
	ld a, [sPresentConsecutiveWins + 1]
	ld [sPresentConsecutiveWinsBackup + 1], a
	call ChallengeMachine_ShowNewRecord
	call DisableSRAM
	ldtx hl, WeAwaitYourNextChallengeText
	call PrintScrollableText_NoTextBoxLabel
	ret

; update wChallengeMachineOpponent with the current
; opponent in the sChallengeMachineOpponents list
ChallengeMachine_GetCurrentOpponent: ; 1330b (4:730b)
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	ld e, a
	ld d, 0
	ld hl, sChallengeMachineOpponents
	add hl, de
	ld a, [hl]
	ld [wChallengeMachineOpponent], a
	call DisableSRAM
	ret

; play the appropriate match start theme
; then duel the current opponent
ChallengeMachine_Duel: ; 13320 (4:7320)
	call ChallengeMachine_PrepareDuel
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	ld e, a
	call DisableSRAM
	ld d, 0
	ld hl, ChallengeMachine_SongIDs
	add hl, de
	ld a, [hl]
	call PlaySong
	call WaitForSongToFinish
	xor a
	ld [wSongOverride], a
	call SaveGeneralSaveData
	bank1call StartDuel_VSAIOpp
	ret

ChallengeMachine_SongIDs: ; 13345 (4:7345)
	db MUSIC_MATCH_START_1
	db MUSIC_MATCH_START_1
	db MUSIC_MATCH_START_1
	db MUSIC_MATCH_START_2
	db MUSIC_MATCH_START_2

; get the current opponent's name, deck, and prize count
ChallengeMachine_PrepareDuel: ; 1334a (4:734a)
	call ChallengeMachine_GetOpponentNameAndDeck
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	ld e, a
	call DisableSRAM
	ld d, 0
	ld hl, ChallengeMachine_Prizes
	add hl, de
	ld a, [hl]
	ld [wNPCDuelPrizes], a
	ret

ChallengeMachine_Prizes: ; 13362 (4:7362)
	db PRIZES_4
	db PRIZES_4
	db PRIZES_4
	db PRIZES_6
	db PRIZES_6

; store the result of the last duel in the current
; position of the sChallengeMachineDuelResults list
ChallengeMachine_RecordDuelResult: ; 13367 (4:7367)
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	ld e, a
	ld d, 0
	ld hl, sChallengeMachineDuelResults
	add hl, de
	ld a, [wDuelResult]
	or a
	jr nz, .lost
	ld a, 1 ; won
	ld [hl], a
	call DisableSRAM
	ld hl, sPresentConsecutiveWins
	call ChallengeMachine_IncrementHLMax999
	ret

.lost
	ld a, 2 ; lost
	ld [hl], a
	call DisableSRAM
	ret

; increment the value at hl
; without going above 999
ChallengeMachine_IncrementHLMax999: ; 1338e (4:738e)
	call EnableSRAM
	inc hl
	ld a, [hld]
	cp HIGH(999)
	jr nz, .increment
	ld a, [hl]
	cp LOW(999)
	jr z, .skip
.increment
	ld a, [hl]
	add 1
	ld [hli], a
	ld a, [hl]
	adc 0
	ld [hl], a
.skip
	call DisableSRAM
	ret

; update sMaximumConsecutiveWins if the player set a new record
ChallengeMachine_CheckForNewRecord: ; 133a8 (4:73a8)
	call EnableSRAM
	ld hl, sMaximumConsecutiveWins + 1
	ld a, [sPresentConsecutiveWins + 1]
	cp [hl]
	jr nz, .high_bytes_different
; high bytes equal, check low bytes
	dec hl
	ld a, [sPresentConsecutiveWins]
	cp [hl]
.high_bytes_different
	jr c, .no_record
	jr z, .no_record
; new record
	ld hl, sMaximumConsecutiveWins
	ld a, [sPresentConsecutiveWins]
	ld [hli], a
	ld a, [sPresentConsecutiveWins + 1]
	ld [hl], a
	ld hl, sPlayerName
	ld de, sChallengeMachineRecordHolderName
	ld bc, NAME_BUFFER_LENGTH
	call CopyDataHLtoDE_SaveRegisters
; remember to show congrats message later
	ld a, TRUE
	ld [sConsecutiveWinRecordIncreased], a
.no_record
	call DisableSRAM
	ret

; print the next opponent's name and ask the
; player if they want to begin the next duel
ChallengeMachine_AreYouReady: ; 133dd (4:73dd)
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	inc a
	ld [wTxRam3], a
	ld [wTxRam3_b], a
	xor a
	ld [wTxRam3 + 1], a
	ld [wTxRam3_b + 1], a
	ldtx hl, NthOpponentIsText
	ld a, [sPresentConsecutiveWins + 1]
	or a
	jr nz, .streak
	ld a, [sPresentConsecutiveWins]
	cp 2
	jr c, .no_streak
.streak
	ldtx hl, XConsecutiveWinsNthOpponentIsText
	ld a, [sPresentConsecutiveWins]
	ld [wTxRam3], a
	ld a, [sPresentConsecutiveWins + 1]
	ld [wTxRam3 + 1], a
.no_streak
	call DisableSRAM
	push hl ; text id
	call ChallengeMachine_GetOpponentNameAndDeck
	ld a, [wOpponentName]
	ld [wTxRam2], a
	ld a, [wOpponentName + 1]
	ld [wTxRam2 + 1], a
	pop hl ; text id
	call PrintScrollableText_NoTextBoxLabel
	ldtx hl, WouldYouLikeToBeginTheDuelText
	call YesOrNoMenuWithText_SetCursorToYes
	ret

; print opponent win count
; play a jingle for beating 5 opponents
ChallengeMachine_DuelWon: ; 1342e (4:742e)
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	inc a
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	ldtx hl, WonAgainstXOpponentsText
	ld a, [sChallengeMachineOpponentNumber]
	call DisableSRAM
	cp NUM_CHALLENGE_MACHINE_OPPONENTS - 1
	jr z, .beat_five_opponents
	call PrintScrollableText_NoTextBoxLabel
	ret

.beat_five_opponents
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ldtx hl, Defeated5OpponentsText
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	ret

; when a player's streak ends, print the final
; consecutive win count
ChallengeMachine_PrintFinalConsecutiveWinStreak: ; 13462 (4:7462)
	call EnableSRAM
	ld a, [sPresentConsecutiveWins]
	ld [wTxRam3], a
	ld a, [sPresentConsecutiveWins + 1]
	ld [wTxRam3 + 1], a
	or a
	jr nz, .streak
	ld a, [sPresentConsecutiveWins]
	cp 2
	jr c, .no_streak
.streak
	ldtx hl, ConsecutiveWinsEndedAtText
	call PrintScrollableText_NoTextBoxLabel
.no_streak
	call DisableSRAM
	ret

; if the player achieved a new record, play a jingle
; otherwise, do nothing
ChallengeMachine_ShowNewRecord: ; 13485 (4:7485)
	call EnableSRAM
	ld a, [sConsecutiveWinRecordIncreased]
	or a
	ret z ; no new record
	ld a, [sMaximumConsecutiveWins]
	ld [wTxRam3], a
	ld a, [sMaximumConsecutiveWins + 1]
	ld [wTxRam3 + 1], a
	call DisableSRAM
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ldtx hl, ConsecutiveWinRecordIncreasedText
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	ret

ChallengeMachine_DrawScoreScreen: ; 134b1 (4:74b1)
	call Func_10000
	lb de, $30, $bf
	call SetupText
	lb de,  0,  0
	lb bc, 20, 13
	call DrawRegularTextBox
	lb de,  0, 12
	lb bc, 20,  6
	call DrawRegularTextBox
	call EnableSRAM
	ld hl, sChallengeMachineRecordHolderName
	ld de, wDefaultText
	ld bc, NAME_BUFFER_LENGTH
	call CopyDataHLtoDE
	call DisableSRAM
	xor a
	ld [wTxRam2], a
	ld [wTxRam2 + 1], a
	ld hl, ChallengeMachine_PlayerScoreTexts
	call Func_111b3
	ld hl, ChallengeMachine_PlayerScoreValues
	call ChallengeMachine_PrintScores
	ret

ChallengeMachine_PlayerScoreTexts: ; 134f2 (4:74f2)
	db 1, 0
	tx ChallengeMachineText

	db 1, 2
	tx PlayersScoreText

	db 2, 4
	tx Defeated5OpponentsXTimesText

	db 2, 6
	tx PresentConsecutiveWinsText

	db 1, 8
	tx MaximumConsecutiveWinsText

	db 17, 6
	tx WinsText

	db 16, 10
	tx WinsText
	db $ff

ChallengeMachine_PlayerScoreValues: ; 1350f (4:750f)
	dw sTotalChallengeMachineWins
	db 12, 4

	dw sPresentConsecutiveWins
	db 14, 6

	dw sMaximumConsecutiveWins
	db 13, 10

	dw NULL

ChallengeMachine_DrawOpponentList: ; 1351d (4:751d)
	call Func_10000
	lb de, $30, $bf
	call SetupText
	lb de,  0,  0
	lb bc, 20, 13
	call DrawRegularTextBox
	lb de,  0, 12
	lb bc, 20,  6
	call DrawRegularTextBox
	ld hl, ChallengeMachine_OpponentNumberTexts
	call Func_111b3
	call ChallengeMachine_PrintOpponentInfo
	call ChallengeMachine_PrintDuelResultIcons
	ret

ChallengeMachine_OpponentNumberTexts: ; 13545 (4:7545)
	db 1, 0
	tx ChallengeMachineText

	db 2, 2
	tx ChallengeMachineOpponent1Text

	db 2, 4
	tx ChallengeMachineOpponent2Text

	db 2, 6
	tx ChallengeMachineOpponent3Text

	db 2, 8
	tx ChallengeMachineOpponent4Text

	db 2, 10
	tx ChallengeMachineOpponent5Text
	db $ff

ChallengeMachine_PrintOpponentInfo: ; 1355e (4:755e)
	ld hl, sChallengeMachineOpponents
	ld bc, 2 ; beginning y-pos
	ld e, NUM_CHALLENGE_MACHINE_OPPONENTS
.loop
	push hl
	push bc
	push de
	call EnableSRAM
	ld a, [hl]
	ld [wChallengeMachineOpponent], a
	ld b, 14 ; x-pos
	call ChallengeMachine_PrintOpponentName
	ld b, 4 ; x-pos
	call ChallengeMachine_PrintOpponentClubStatus
	pop de
	pop bc
	pop hl
	inc hl

; down two rows
	inc c
	inc c

	dec e
	jr nz, .loop
	call DisableSRAM
	ret

ChallengeMachine_PrintOpponentName: ; 13587 (4:7587)
	push bc
	call ChallengeMachine_GetOpponentNameAndDeck
	ld de, 2 ; name
	add hl, de
	call ChallengeMachine_PrintText
	pop bc
	ret

ChallengeMachine_PrintText: ; 13594 (4:7594)
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, c
	ld d, b
	push de
	call InitTextPrinting
	call PrintTextNoDelay
	pop de
	ret

; print the opponent's rank and element
ChallengeMachine_PrintOpponentClubStatus: ; 135a2 (4:75a2)
	push bc
	call ChallengeMachine_GetOpponentNameAndDeck
	push hl
	ld de, 6 ; rank
	add hl, de
	call ChallengeMachine_PrintText
	ld a, d
	add $07
	ld d, a
	call InitTextPrinting
	pop hl
	ld bc, 8 ; element
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .no_element
	call PrintTextNoDelay
.no_element
	pop bc
	ret

ChallengeMachine_GetOpponentNameAndDeck: ; 135c5 (4:75c5)
	push de
	ld a, [wChallengeMachineOpponent]
	ld e, a
	ld d, 0
	ld hl, ChallengeMachine_OpponentDeckIDs
	add hl, de
	ld a, [hl]
	ld [wNPCDuelDeckID], a
	call _GetChallengeMachineDuelConfigurations
	pop de
	ret

ChallengeMachine_PrintDuelResultIcons: ; 135d9 (4:75d9)
	ld hl, sChallengeMachineDuelResults
	ld c, NUM_CHALLENGE_MACHINE_OPPONENTS
	lb de, 1, 2
.print_loop
	push hl
	push bc
	push de
	call InitTextPrinting
	call EnableSRAM
	ld a, [hl]
	add a
	ld e, a
	ld d, 0
	ld hl, ChallengeMachine_DuelResultIcons
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintTextNoDelay
	pop de
	pop bc
	pop hl
	inc hl

; down two rows
	inc e
	inc e

	dec c
	jr nz, .print_loop
	call DisableSRAM
	ret

ChallengeMachine_DuelResultIcons: ; 13606 (4:7606)
	tx ChallengeMachineNotDuelledIconText
	tx ChallengeMachineDuelWonIconText
	tx ChallengeMachineDuelLostIconText

; print all scores in the table pointed to by hl
ChallengeMachine_PrintScores: ; 1360c (4:760c)
.loop
	call EnableSRAM
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	or e
	jr z, .done
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	push hl
	push bc
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	call Func_10217
	pop bc
	call BCCoordToBGMap0Address
	ld hl, wd4b4
	ld b, 3
	call SafeCopyDataHLtoDE
	pop hl
	jr .loop

.done
	call DisableSRAM
	ret

; if this is the first time the challenge machine has ever
; been used on this cartridge, then clear all vars and
; set Dr. Mason as the record holder
ChallengeMachine_Initialize: ; 13637 (4:7637)
	call EnableSRAM
	ld a, [sChallengeMachineMagic]
	cp $e3
	jr nz, .init_vars
	ld a, [sChallengeMachineMagic + 1]
	cp $95
	jr z, .done

.init_vars
	ld hl, sChallengeMachineMagic
	ld c, sChallengeMachineEnd - sChallengeMachineStart
	ld a, $e3
	ld [hli], a
	ld a, $95
	ld [hli], a

	xor a
.clear_loop
	ld [hli], a
	dec c
	jr nz, .clear_loop

	ld hl, ChallengeMachine_DrMasonText
	ld de, sChallengeMachineRecordHolderName
	ld bc, NAME_BUFFER_LENGTH
	call CopyDataHLtoDE_SaveRegisters
	ld a, 1
	ld [sMaximumConsecutiveWins], a
	xor a
	ld [sMaximumConsecutiveWins + 1], a

.done
	ld a, [sPlayerInChallengeMachine]
	call DisableSRAM
	ret

ChallengeMachine_DrMasonText: ; 13674 (4:7674)
	text "Dr. Mason", TX_END, TX_END, TX_END, TX_END, TX_END, TX_END

; pick the next opponent sequence and clear challenge vars
ChallengeMachine_PickOpponentSequence: ; 13684 (4:7684)
	call EnableSRAM

; pick first opponent
	ld a, CLUB_MASTERS_START
	call Random
	ld [sChallengeMachineOpponents], a

.pick_second_opponent
	ld a, CLUB_MASTERS_START
	call Random
	ld c, 1
	call ChallengeMachine_CheckIfOpponentAlreadySelected
	jr c, .pick_second_opponent
	ld [sChallengeMachineOpponents + 1], a

.pick_third_opponent
	ld a, CLUB_MASTERS_START
	call Random
	ld c, 2
	call ChallengeMachine_CheckIfOpponentAlreadySelected
	jr c, .pick_third_opponent
	ld [sChallengeMachineOpponents + 2], a

; pick fourth opponent
	ld a, GRAND_MASTERS_START - CLUB_MASTERS_START
	call Random
	add CLUB_MASTERS_START
	ld [sChallengeMachineOpponents + 3], a

; pick fifth opponent
	call UpdateRNGSources
	ld hl, ChallengeMachine_FinalOpponentProbabilities
.next
	sub [hl]
	jr c, .got_opponent
	inc hl
	inc hl
	jr .next
.got_opponent
	inc hl
	ld a, [hl]
	ld [sChallengeMachineOpponents + 4], a

	xor a
	ld [sChallengeMachineOpponentNumber], a
	ld [sConsecutiveWinRecordIncreased], a
	ld hl, sChallengeMachineDuelResults
	ld c, NUM_CHALLENGE_MACHINE_OPPONENTS
.clear_results
	ld [hli], a
	dec c
	jr nz, .clear_results
	ld a, [sPresentConsecutiveWinsBackup]
	ld [sPresentConsecutiveWins], a
	ld a, [sPresentConsecutiveWinsBackup + 1]
	ld [sPresentConsecutiveWins + 1], a
	call DisableSRAM
	ret

ChallengeMachine_FinalOpponentProbabilities: ; 136e9 (4:76e9)
	db  56, GRAND_MASTERS_START + 0 ; 56/256, courtney
	db  56, GRAND_MASTERS_START + 1 ; 56/256, steve
	db  56, GRAND_MASTERS_START + 2 ; 56/256, jack
	db  56, GRAND_MASTERS_START + 3 ; 56/256, rod
	db   8, GRAND_MASTERS_START + 4 ;  8/256, aaron
	db   8, GRAND_MASTERS_START + 5 ;  8/256, aaron
	db   8, GRAND_MASTERS_START + 6 ;  8/256, aaron
	db 255, GRAND_MASTERS_START + 7 ;  8/256, imakuni (catch-all)

; return carry if the opponent in a is already among
; the first c opponents in sChallengeMachineOpponents
ChallengeMachine_CheckIfOpponentAlreadySelected: ; 136f9 (4:76f9)
	ld hl, sChallengeMachineOpponents
.loop
	cp [hl]
	jr z, .found
	inc hl
	dec c
	jr nz, .loop
; not found
	or a
	ret
.found
	scf
	ret

ChallengeMachine_OpponentDeckIDs: ; 13707 (4:7707)
.club_members
	db MUSCLES_FOR_BRAINS_DECK_ID
	db HEATED_BATTLE_DECK_ID
	db LOVE_TO_BATTLE_DECK_ID
	db EXCAVATION_DECK_ID
	db BLISTERING_POKEMON_DECK_ID
	db HARD_POKEMON_DECK_ID
	db WATERFRONT_POKEMON_DECK_ID
	db LONELY_FRIENDS_DECK_ID
	db SOUND_OF_THE_WAVES_DECK_ID
	db PIKACHU_DECK_ID
	db BOOM_BOOM_SELFDESTRUCT_DECK_ID
	db POWER_GENERATOR_DECK_ID
	db ETCETERA_DECK_ID
	db FLOWER_GARDEN_DECK_ID
	db KALEIDOSCOPE_DECK_ID
	db GHOST_DECK_ID
	db NAP_TIME_DECK_ID
	db STRANGE_POWER_DECK_ID
	db FLYIN_POKEMON_DECK_ID
	db LOVELY_NIDORAN_DECK_ID
	db POISON_DECK_ID
	db ANGER_DECK_ID
	db FLAMETHROWER_DECK_ID
	db RESHUFFLE_DECK_ID
.club_masters
	db FIRST_STRIKE_DECK_ID
	db ROCK_CRUSHER_DECK_ID
	db GO_GO_RAIN_DANCE_DECK_ID
	db ZAPPING_SELFDESTRUCT_DECK_ID
	db FLOWER_POWER_DECK_ID
	db STRANGE_PSYSHOCK_DECK_ID
	db WONDERS_OF_SCIENCE_DECK_ID
	db FIRE_CHARGE_DECK_ID
.grand_masters
	db LEGENDARY_MOLTRES_DECK_ID
	db LEGENDARY_ZAPDOS_DECK_ID
	db LEGENDARY_ARTICUNO_DECK_ID
	db LEGENDARY_DRAGONITE_DECK_ID
	db LIGHTNING_AND_FIRE_DECK_ID
	db WATER_AND_FIGHTING_DECK_ID
	db GRASS_AND_PSYCHIC_DECK_ID
	db IMAKUNI_DECK_ID

CLUB_MASTERS_START  EQU ChallengeMachine_OpponentDeckIDs.club_masters - ChallengeMachine_OpponentDeckIDs.club_members
GRAND_MASTERS_START EQU ChallengeMachine_OpponentDeckIDs.grand_masters - ChallengeMachine_OpponentDeckIDs.club_members

INCLUDE "data/npc_map_data.asm"
INCLUDE "data/map_objects.asm"
