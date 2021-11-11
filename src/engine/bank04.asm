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

_PauseMenu_Status:
	ld a, [wd291]
	push af
	call InitMenuScreen
	xor a
	ld [wMedalScreenYOffset], a
	call LoadCollectedMedalTilemaps
	lb de,  0,  0
	lb bc, 20,  8
	call DrawRegularTextBox
	ld hl, StatusScreenLabels
	call PrintLabels
	lb bc, 1, 1
	call DrawPauseMenuPlayerPortrait
	lb bc, 12, 4
	call PrintAlbumProgress
	lb bc, 13, 6
	call PrintPlayTime
	call FlashWhiteScreen
	ld a, A_BUTTON | B_BUTTON | START
	call WaitUntilKeysArePressed
	pop af
	ld [wd291], a
	ret

StatusScreenLabels:
	db 7, 2
	tx PlayerStatusNameText

	db 7, 4
	tx PlayerStatusAlbumText

	db 7, 6
	tx PlayerStatusPlayTimeText

	db $ff

_PauseMenu_Diary:
	ld a, [wd291]
	push af
	call InitMenuScreen
	lb de,  0,  0
	lb bc, 20, 12
	call DrawRegularTextBox
	ld hl, DiaryScreenLabels
	call PrintLabels
	lb bc, 1, 3
	call DrawPauseMenuPlayerPortrait
	lb bc, 12, 8
	call PrintAlbumProgress
	lb bc, 13, 10
	call PrintPlayTime
	lb bc, 16, 6
	call PrintMedalCount
	call FlashWhiteScreen
	ldtx hl, PlayerDiarySaveQuestionText
	call YesOrNoMenuWithText_SetCursorToYes
	jr c, .cancel
	farcall BackupPlayerPosition
	call SaveAndBackupData
	ld a, SFX_56
	call PlaySFX
	ldtx hl, PlayerDiarySaveConfirmText
	jr .print_result_text
.cancel
	ldtx hl, PlayerDiarySaveCancelText
.print_result_text
	call PrintScrollableText_NoTextBoxLabel
	pop af
	ld [wd291], a
	ret

DiaryScreenLabels:
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

LoadCollectedMedalTilemaps:
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
	jr z, .done ; no medals?

; load tilemaps of only the collected medals
	ld c, NUM_MEDALS
.loop_medals
	push bc
	push hl
	push af
	bit 7, a
	jr z, .skip_medal
	ld b, [hl]
	inc hl
	ld a, [wMedalScreenYOffset]
	add [hl]
	ld c, a
	inc hl
	ld a, [hli]
	ld [wCurTilemap], a
	farcall LoadTilemap_ToVRAM
.skip_medal
	pop af
	rlca
	pop hl
	ld bc, $3
	add hl, bc
	pop bc
	dec c
	jr nz, .loop_medals

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
.done
	ret

MedalCoordsAndTilemaps:
; x, y, tilemap
	db  1, 10, TILEMAP_GRASS_MEDAL
	db  6, 10, TILEMAP_SCIENCE_MEDAL
	db 11, 10, TILEMAP_FIRE_MEDAL
	db 16, 10, TILEMAP_WATER_MEDAL
	db  1, 14, TILEMAP_LIGHTNING_MEDAL
	db  6, 14, TILEMAP_PSYCHIC_MEDAL
	db 11, 14, TILEMAP_ROCK_MEDAL
	db 16, 14, TILEMAP_FIGHTING_MEDAL

FlashReceivedMedal:
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

PrintPlayTime:
	ld a, [wPlayTimeCounter + 2]
	ld [wPlayTimeHourMinutes], a
	ld a, [wPlayTimeCounter + 3]
	ld [wPlayTimeHourMinutes + 1], a
	ld a, [wPlayTimeCounter + 4]
	ld [wPlayTimeHourMinutes + 2], a
;	fallthrough
PrintPlayTime_SkipUpdateTime:
	push bc
	ld a, [wPlayTimeHourMinutes + 1]
	ld l, a
	ld a, [wPlayTimeHourMinutes + 2]
	ld h, a
	call ConvertWordToNumericalDigits
	pop bc
	push bc
	call BCCoordToBGMap0Address
	ld hl, wDecimalChars
	ld b, 3
	call SafeCopyDataHLtoDE
	ld a, [wPlayTimeHourMinutes]
	add 100
	ld l, a
	ld a, 0
	adc 0
	ld h, a
	call ConvertWordToNumericalDigits
	pop bc
	ld a, b
	add 4
	ld b, a
	call BCCoordToBGMap0Address
	ld hl, wDecimalChars + 1
	ld b, 2
	call SafeCopyDataHLtoDE
	ret

; input:
; hl = value to convert
ConvertWordToNumericalDigits:
	ld de, wDecimalChars
	ld bc, -100 ; hundreds
	call .GetNumberSymbol
	ld bc, -10 ; tens
	call .GetNumberSymbol
	ld a, l ; ones
	add SYM_0
	ld [de], a

; remove leading zeroes
	ld hl, wDecimalChars
	ld c, 2
.loop_digits
	ld a, [hl]
	cp SYM_0
	jr nz, .done ; reached a non-zero digit?
	ld [hl], SYM_SPACE
	inc hl
	dec c
	jr nz, .loop_digits
.done
	ret

.GetNumberSymbol
	ld a, SYM_0 - 1
.loop
	inc a
	add hl, bc
	jr c, .loop
	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret

; prints album progress in coords bc
PrintAlbumProgress:
	push bc
	call GetCardAlbumProgress
	pop bc
;	fallthrough
PrintAlbumProgress_SkipGetProgress:
	push bc
	push de
	push bc
	ld l, d ; number of different cards collected
	ld h, $00
	call ConvertWordToNumericalDigits
	pop bc
	call BCCoordToBGMap0Address
	ld hl, wDecimalChars
	ld b, 3
	call SafeCopyDataHLtoDE
	pop de
	ld l, e ; total number of cards
	ld h, $00
	call ConvertWordToNumericalDigits
	pop bc
	ld a, b
	add 4
	ld b, a
	call BCCoordToBGMap0Address
	ld hl, wDecimalChars
	ld b, 3
	call SafeCopyDataHLtoDE
	ret

; prints the number of medals collected in bc
PrintMedalCount:
	push bc
	farcall TryGiveMedalPCPacks
	ld a, EVENT_MEDAL_COUNT
	farcall GetEventValue
	ld l, a
	ld h, $00
	call ConvertWordToNumericalDigits
	pop bc
	call BCCoordToBGMap0Address
	ld hl, wDecimalChars + 2
	ld b, 1
	call SafeCopyDataHLtoDE
	ret

; bc = coordinates
DrawPauseMenuPlayerPortrait:
	call DrawPlayerPortrait
	ret

ShowMedalReceivedScreen:
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
	call InitMenuScreen
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

MasterMedalNames:
	tx GrassClubMapNameText
	tx ScienceClubMapNameText
	tx FireClubMapNameText
	tx WaterClubMapNameText
	tx LightningClubMapNameText
	tx PsychicClubMapNameText
	tx RockClubMapNameText
	tx FightingClubMapNameText

GiveBoosterPack:
	ld c, a
	ld a, [wd291]
	push af
	push bc
	call DisableLCD
	call InitMenuScreen
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
	call SetDefaultPalettes
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

BoosterTypes:
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

BoosterScenesAndNameTexts:
	db SCENE_COLOSSEUM_BOOSTER, SCENE_COLOSSEUM_BOOSTER
	tx ColosseumBoosterText

	db SCENE_EVOLUTION_BOOSTER, SCENE_EVOLUTION_BOOSTER
	tx EvolutionBoosterText

	db SCENE_MYSTERY_BOOSTER, SCENE_MYSTERY_BOOSTER
	tx MysteryBoosterText

	db SCENE_LABORATORY_BOOSTER, SCENE_LABORATORY_BOOSTER
	tx LaboratoryBoosterText

_PauseMenu_Exit:
	ret

Duel_Init:
	ld a, [wd291]
	push af
	call DisableLCD
	call InitMenuScreen
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
	ld hl, OpponentTitleAndNameLabel
	call PrintLabels ; LoadDuelistName
	pop hl
	ld a, [hli]
	ld [wTxRam2], a
	ld c, a
	ld a, [hli]
	ld [wTxRam2 + 1], a
	or c
	jr z, .skip_deck_name
	ld hl, OpponentDeckNameLabel
	call PrintLabels ; LoadDeckName
.skip_deck_name
	lb bc, 7, 3
	ld a, [wOpponentPortrait]
	call DrawOpponentPortrait
	ld a, [wMatchStartTheme]
	call PlaySong
	call FlashWhiteScreen
	call DoFrameIfLCDEnabled
	lb bc, $2f, $1d ; cursor tile, tile behind cursor
	lb de, 18, 17 ; x, y
	call SetCursorParametersForTextBox
	call WaitForButtonAorB
	call WaitForSongToFinish
	call FadeScreenToWhite ; fade out
	pop af
	ld [wd291], a
	ret

OpponentTitleAndNameLabel:
	db 1, 14
	tx OpponentTitleAndNameText
	db $ff

OpponentDeckNameLabel:
	db 1, 16
	tx OpponentDeckNameText
	db $ff

OpponentTitlesAndDeckNames:
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

_PCMenu_Glossary:
	ld a, [wd291]
	push af
	call InitMenuScreen
	lb de, $30, $ff
	call SetupText
	call FlashWhiteScreen
	farcall OpenGlossaryScreen
	pop af
	ld [wd291], a
	ret

_PauseMenu_Config:
	ld a, [wd291]
	push af
	ld a, [wLineSeparation]
	push af
	xor a
	ld [wConfigExitSettingsCursorPos], a
	ld a, 1
	ld [wLineSeparation], a
	call InitMenuScreen
	lb de,  0,  3
	lb bc, 20,  5
	call DrawRegularTextBox
	lb de,  0,  9
	lb bc, 20,  5
	call DrawRegularTextBox
	ld hl, ConfigScreenLabels
	call PrintLabels
	call GetConfigCursorPositions
	ld a, 0
	call ShowConfigMenuCursor
	ld a, 1
	call ShowConfigMenuCursor
	xor a
	ld [wCursorBlinkTimer], a
	call FlashWhiteScreen
.asm_10588
	call DoFrameIfLCDEnabled
	ld a, [wConfigCursorYPos]
	call UpdateConfigMenuCursor
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
	call SaveConfigSettings
	pop af
	ld [wLineSeparation], a
	pop af
	ld [wd291], a
	ret

ConfigScreenLabels:
	db 1, 1
	tx ConfigMenuTitleText

	db 1, 4
	tx ConfigMenuMessageSpeedText

	db 1, 10
	tx ConfigMenuDuelAnimationText

	db 1, 16
	tx ConfigMenuExitText

	db $ff

; checks the current saved configuration settings
; and sets wConfigMessageSpeedCursorPos and wConfigDuelAnimationCursorPos
; to the right positions for those values
GetConfigCursorPositions:
	call EnableSRAM
	ld c, 0
	ld hl, TextDelaySettings
.loop
	ld a, [sTextSpeed]
	cp [hl]
	jr nc, .match
	inc hl
	inc c
	ld a, c
	cp 4
	jr c, .loop
.match
	ld a, c
	ld [wConfigMessageSpeedCursorPos], a
	ld a, [sSkipDelayAllowed]
	and $1
	rlca
	ld c, a
	ld a, [wAnimationsDisabled]
	and $1
	or c
	ld c, a
	ld b, $00
	ld hl, DuelAnimationSettingsIndices
	add hl, bc
	ld a, [hl]
	ld [wConfigDuelAnimationCursorPos], a
	call DisableSRAM
	ret

; indexes into DuelAnimationSettings
; 0: show all
; 1: skip some
; 2: none
DuelAnimationSettingsIndices:
	db 0 ; skip delay allowed = false, animations disabled = false
	db 0 ; skip delay allowed = false, animations disabled = true (unused)
	db 1 ; skip delay allowed = true, animations disabled = false
	db 2 ; skip delay allowed = true, animations disabled = true

SaveConfigSettings:
	call EnableSRAM
	ld a, [wConfigDuelAnimationCursorPos]
	and %11
	rlca
	ld c, a
	ld b, $00
	ld hl, DuelAnimationSettings
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
	ld hl, TextDelaySettings
	add hl, bc
	call EnableSRAM
	ld a, [hl]
	ld [sTextSpeed], a
	ld [wTextSpeed], a
	call DisableSRAM
	ret

DuelAnimationSettings:
; animation disabled, skip delay allowed
	db FALSE, FALSE ; show all
	db FALSE, TRUE  ; skip some
	db TRUE,  TRUE  ; none
	db FALSE, FALSE ; unused

; text printing delay
TextDelaySettings:
	; slow to fast
	db 6, 4, 2, 1, 0

UpdateConfigMenuCursor:
	push af
	ld a, [wCursorBlinkTimer]
	and $10
	jr z, .show
	pop af
	jr HideConfigMenuCursor
.show
	pop af
	jr ShowConfigMenuCursor ; can be fallthrough

ShowConfigMenuCursor:
	push bc
	ld c, a
	ld a, SYM_CURSOR_R
	call DrawConfigMenuCursor
	pop bc
	ret

HideConfigMenuCursor:
	push bc
	ld c, a
	ld a, SYM_SPACE
	call DrawConfigMenuCursor
	pop bc
	ret

DrawConfigMenuCursor:
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

ConfigScreenCursorPositions:
	dw MessageSpeedCursorPositions
	dw DuelAnimationsCursorPositions
	dw ExitSettingsCursorPosition

MessageSpeedCursorPositions:
	dw wConfigMessageSpeedCursorPos
	db  5, 6
	db  7, 6
	db  9, 6
	db 11, 6
	db 13, 6

DuelAnimationsCursorPositions:
	dw wConfigDuelAnimationCursorPos
	db  1, 12
	db  7, 12
	db 15, 12

ExitSettingsCursorPosition:
	dw wConfigExitSettingsCursorPos
	db 1, 16

	db 0

ConfigScreenHandleDPadInput:
	ldh a, [hDPadHeld]
	and D_PAD
	ret z
	farcall GetDirectionFromDPad
	ld hl, ConfigScreenDPadHandlers
	jp JumpToFunctionInTable

ConfigScreenDPadHandlers:
	dw ConfigScreenDPadUp ; up
	dw ConfigScreenDPadRight ; right
	dw ConfigScreenDPadDown ; down
	dw ConfigScreenDPadLeft ; left

ConfigScreenDPadUp:
	ld a, -1
	jr ConfigScreenDPadDown.up_or_down

ConfigScreenDPadDown:
	ld a, 1
.up_or_down
	push af
	ld a, [wConfigCursorYPos]
	cp 2
	jr z, .hide_cursor
	call ShowConfigMenuCursor
	jr .skip
.hide_cursor
; hide "exit settings" cursor if leaving bottom row
	call HideConfigMenuCursor
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
	call UpdateConfigMenuCursor
	ld a, SFX_01
	call PlaySFX
	ret

Unknown_106ff:
	db $18 ; message speed, start hidden
	db $18 ; duel animation, start hidden
	db $8 ; exit settings, start visible

ConfigScreenDPadRight:
	ld a, 1
	jr ConfigScreenDPadLeft.left_or_right

ConfigScreenDPadLeft:
	ld a, -1
.left_or_right
	push af
	ld a, [wConfigCursorYPos]
	call HideConfigMenuCursor
	pop af
	call .ApplyPosChange
	ld a, [wConfigCursorYPos]
	call ShowConfigMenuCursor
	xor a
	ld [wCursorBlinkTimer], a
	ret

; a = 1 for right, -1 for left
.ApplyPosChange
	push af
	ld a, [wConfigCursorYPos]
	ld c, a
	add a
	add c ; *3
	ld c, a
	ld b, $00
	ld hl, .MaxCursorPositions
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld c, [hl] ; max value
	ld a, [de]
	ld b, a
	pop af
	add b ; apply pos change
	cp c
	jr c, .got_new_pos
	jr z, .got_new_pos
	cp $80
	jr c, .wrap_around
	; wrap to last
	ld a, c
	jr .got_new_pos
.wrap_around
	; wrap to first
	xor a
.got_new_pos
	ld [de], a
	ld a, c
	or a
	jr z, .skip_sfx
	ld a, SFX_01
	call PlaySFX
.skip_sfx
	ret

.MaxCursorPositions:
; x pos variable, max x value
	dwb wConfigMessageSpeedCursorPos,  4
	dwb wConfigDuelAnimationCursorPos, 2
	dwb wConfigExitSettingsCursorPos,  0

; clears all PC packs in WRAM 
; and then gives the 1st pack
; this doesn't clear in SRAM so
; it's not done to clear PC pack data
InitPCPacks:
	push hl
	push bc
	xor a
	ld [wPCPackSelection], a
	ld hl, wPCPacks
	ld c, NUM_PC_PACKS
.loop_packs
	ld [hli], a
	dec c
	jr nz, .loop_packs
	ld a, $1
	call TryGivePCPack
	pop bc
	pop hl
	ret

_PCMenu_ReadMail:
	ld a, [wd291]
	push af
	call InitMenuScreen
	lb de, $30, $ff
	call SetupText
	lb de,  0,  0
	lb bc, 20, 12
	call DrawRegularTextBox
	lb de,  0, 12
	lb bc, 20,  6
	call DrawRegularTextBox
	ld hl, MailScreenLabels
	call PrintLabels
	call PrintObtainedPCPacks
	xor a
	ld [wCursorBlinkTimer], a
	call FlashWhiteScreen
.asm_1079c
	call DoFrameIfLCDEnabled
	ld a, [wPCPackSelection]
	call UpdateMailMenuCursor
	call BlinkUnopenedPCPacks
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
Unknown_107c2:
	db $01, $00, $00, $4a, $21, $b5, $42, $e0
	db $03, $4a, $29, $94, $52, $fF, $7f, $00

MailScreenLabels:
	db 1, 0
	tx MailText

	db 1, 14
	tx WhichMailWouldYouLikeToReadText

	db 0, 20
	tx MailNumbersText

	db $ff

PCMailHandleDPadInput:
	ldh a, [hDPadHeld]
	and D_PAD
	ret z
	farcall GetDirectionFromDPad
	ld [wPCLastDirectionPressed], a
	ld a, [wPCPackSelection]
	push af
	call HideMailMenuCursor
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
	call ShowMailMenuCursor
	xor a
	ld [wCursorBlinkTimer], a
	ret

PCMailTransitionTable:
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

PCMailHandleAInput:
	ldh a, [hKeysPressed]
	and A_BUTTON
	ret z
	ld a, SFX_02
	call PlaySFX
	call PrintObtainedPCPacks
	call ShowMailMenuCursor
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
	call GetPCPackNameTextID
	call PrintScrollableText_WithTextBoxLabel
	call TryOpenPCMailBoosterPack
	call InitMenuScreen
	lb de, $30, $ff
	call SetupText
	lb de,  0,  0
	lb bc, 20, 12
	call DrawRegularTextBox
	ld hl, MailScreenLabels
	call PrintLabels
	call PrintObtainedPCPacks
	call ShowMailMenuCursor
	call FlashWhiteScreen
	pop hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .no_page_two
	ld a, [wPCPackSelection]
	call GetPCPackNameTextID
	call PrintScrollableText_WithTextBoxLabel
.no_page_two
	lb de,  0, 12
	lb bc, 20,  6
	call DrawRegularTextBox
	ld hl, MailScreenLabels
	call PrintLabels
	call DoFrameIfLCDEnabled
	ret

PCMailTextPages:
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

TryOpenPCMailBoosterPack:
	xor a
	ld [wAnotherBoosterPack], a
	ld a, [wSelectedPCPack]
	bit PACK_UNOPENED_F, a
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
	call InitMenuScreen
	lb de, $30, $ff
	call SetupText
	ldtx hl, Text0419
	call PrintScrollableText_NoTextBoxLabel
	jr .done

PCMailBoosterPacks:
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

UpdateMailMenuCursor:
	ld a, [wCursorBlinkTimer]
	and $10
	jr z, ShowMailMenuCursor
	jr HideMailMenuCursor
ShowMailMenuCursor:
	ld a, SYM_CURSOR_R
	jr DrawMailMenuCursor
HideMailMenuCursor:
	ld a, SYM_SPACE
	jr DrawMailMenuCursor ; can be fallthrough
DrawMailMenuCursor:
	push af
	call GePCPackSelectionCoordinates
	pop af
	call WriteByteToBGMap0
	ret

; prints all the PC packs that player
; has already obtained
PrintObtainedPCPacks:
	ld e, $0
	ld hl, wPCPacks
.loop_packs
	ld a, [hl]
	or a
	jr z, .next_pack
	ld a, e
	call PrintPCPackName
.next_pack
	inc hl
	inc e
	ld a, e
	cp NUM_PC_PACKS
	jr c, .loop_packs
	ret

; outputs in de the text ID
; corresponding to the name
; of the mail in input a
GetPCPackNameTextID:
	push hl
	add a
	ld e, a
	ld d, $00
	ld hl, .PCPackNameTextIDs
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ret

.PCPackNameTextIDs:
	tx Mail1Text
	tx Mail2Text
	tx Mail3Text
	tx Mail4Text
	tx Mail5Text
	tx Mail6Text
	tx Mail7Text
	tx Mail8Text
	tx Mail9Text
	tx Mail10Text
	tx Mail11Text
	tx Mail12Text
	tx Mail13Text
	tx Mail14Text
	tx Mail15Text

; prints on screen the name of
; the PC pack from input in a
PrintPCPackName:
	push hl
	push bc
	push de
	push af
	call GetPCPackNameTextID
	ld l, e
	ld h, d
	pop af
	call GetPCPackCoordinates
	ld e, c
	ld d, b
	call InitTextPrinting
	call PrintTextNoDelay
	pop de
	pop bc
	pop hl
	ret

; prints empty characters on screen
; corresponding to the PC pack in a
; this is to create the blinking
; effect of unopened PC packs
PrintEmptyPCPackName:
	push hl
	push bc
	push de
	call GetPCPackCoordinates
	ld e, c
	ld d, b
	call InitTextPrinting
	ldtx hl, EmptyMailNameText
	call PrintTextNoDelay
	pop de
	pop bc
	pop hl
	ret

BlinkUnopenedPCPacks:
	ld e, $00
	ld hl, wPCPacks
.loop_packs
	ld a, [hl]
	or a
	jr z, .next_pack
	bit PACK_UNOPENED_F, a
	jr z, .next_pack
	ld a, [wCursorBlinkTimer]
	and $0c
	jr z, .show
	cp $0c
	jr nz, .next_pack
; hide
	ld a, e
	call PrintEmptyPCPackName
	jr .next_pack
.show
	ld a, e
	call PrintPCPackName
.next_pack
	inc hl
	inc e
	ld a, e
	cp NUM_PC_PACKS
	jr c, .loop_packs
	ret

; outputs in bc the coordinates
; corresponding to the PC pack in a
GetPCPackCoordinates:
	ld c, a
	ld a, [wPCPackSelection]
	push af
	ld a, c
	ld [wPCPackSelection], a
	call GePCPackSelectionCoordinates
	inc b
	pop af
	ld [wPCPackSelection], a
	ret

; outputs in bc the coordinates
; corresponding to the PC pack
; that is stored in wPCPackSelection
GePCPackSelectionCoordinates:
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

PCMailCoordinates:
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
TryGivePCPack:
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
	or PACK_UNOPENED ; mark pack as unopened
	ld [hl], a

.quit
	pop de
	pop bc
	pop hl
	ret

; writes wd293 with byte depending on console
; every entry in the list is $00
Func_10a9b:
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

FadeScreenToWhite:
	ld a, [wLCDC]
	bit LCDC_ENABLE_F, a
	jr z, .lcd_off
	ld a, [wd293]
	ld [wTempBGP], a
	ld [wTempOBP0], a
	ld [wTempOBP1], a
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

FadeScreenFromWhite:
	call .BackupPalsAndSetWhite
	call RestoreFirstColorInOBPals
	call FlushAllPalettes
	call EnableLCD
	jp FadeScreenToTempPals

.BackupPalsAndSetWhite
	ld a, [wBGP]
	ld [wTempBGP], a
	ld a, [wOBP0]
	ld [wTempOBP0], a
	ld a, [wOBP1]
	ld [wTempOBP1], a
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes + NUM_OBJECT_PALETTES palettes
	call CopyDataHLtoDE_SaveRegisters
	jr SetWhitePalettes ; can be fallthrough

; fills wBackgroundPalettesCGB with white pal
SetWhitePalettes:
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
RestoreFirstColorInOBPals:
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

FadeScreenToTempPals:
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

; does something with wBGP given wTempBGP
; mixes them into a single value?
Func_10b85:
	push bc
	ld c, $03
	ld hl, wBGP
	ld de, wTempBGP
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

FadeOBPalIntoTemp:
	push bc
	ld c, 4 palettes
	ld hl, wObjectPalettesCGB
	ld de, wTempObjectPalettesCGB
	jr FadePalIntoAnother

FadeBGPalIntoTemp1:
	push bc
	ld c, 2 palettes
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	jr FadePalIntoAnother

FadeBGPalIntoTemp2:
	push bc
	ld c, 2 palettes
	ld hl, wBackgroundPalettesCGB + 4 palettes
	ld de, wTempBackgroundPalettesCGB + 4 palettes
	jr FadePalIntoAnother

FadeBGPalIntoTemp3:
	push bc
	ld c, 4 palettes
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
;	fallthrough

; hl = input pal to modify
; de = pal to fade into
; c = number of colors to fade
FadePalIntoAnother:
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

; fades screen to white then
; if c == 0, fade back in
; keep white otherwise
FlashScreenToWhite:
	ldh a, [hBankSRAM]
	push af
	push bc
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	call CopyPalsToSRAMBuffer
	call FadeScreenToWhite
	pop bc
	ld a, c
	or a
	jr nz, .skip_fade_in
	call LoadPalsFromSRAMBuffer
	call FadeScreenFromWhite
.skip_fade_in
	call EnableLCD
	pop af
	call BankswitchSRAM
	call DisableSRAM
	ret

; copies current BG and OP pals,
; wBackgroundPalettesCGB and wObjectPalettesCGB
; to sGfxBuffer2
CopyPalsToSRAMBuffer:
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
LoadPalsFromSRAMBuffer:
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
Func_10d17:
	ld a, [wBGP]
	ld [wTempBGP], a
	ld a, [wOBP0]
	ld [wTempOBP0], a
	ld a, [wOBP1]
	ld [wTempOBP1], a
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

Func_10d50:
	ld a, [wd293]
	ld [wTempBGP], a
	ld a, [wOBP0]
	ld [wTempOBP0], a
	ld a, [wOBP1]
	ld [wTempOBP1], a
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
Func_10d74:
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

Unknown_10d98:
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

Unknown_10da9:
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

GiftCenterMenu:
	ld a, 1 << AUTO_CLOSE_TEXTBOX
	farcall SetOverworldNPCFlags
	ld a, [wSelectedGiftCenterMenuItem]
	ld hl, Unknown_10e17
	farcall InitAndPrintMenu
.loop_input
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .loop_input
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

Unknown_10df0:
	dw Func_10dfb
	dw Func_10dfb
	dw Func_10dfb
	dw Func_10dfb
	dw Func_10dfa

Func_10dfa:
	ret

Func_10dfb:
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

Unknown_10e0f:
	tx SendCardText
	tx ReceiveCardText
	tx SendDeckConfigurationText
	tx ReceiveDeckConfigurationText

Unknown_10e17:
	db  4,  0 ; start menu coords
	db 16, 12 ; start menu text box dimensions

	db  6, 2 ; text alignment for InitTextPrinting
	tx GiftCenterMenuText
	db $ff

	db 5, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

INCLUDE "engine/overworld_map.asm"

; prints $ff-terminated list of text to text box
; given 2 bytes for text alignment and 2 bytes for text ID
PrintLabels:
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

InitAndPrintMenu:
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
	call PrintLabels
	pop af
	call InitializeMenuParameters
	pop de
	pop bc
	pop hl
	ret

; xors sb800
; this has the effect of invalidating the save data checksum
; which the game interprets as being having no save data
InvalidateSaveData:
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
SaveAndBackupData:
	push de
	ld de, sGeneralSaveData
	call SaveGeneralSaveDataFromDE
	ld de, sAlbumProgress
	call UpdateAlbumProgress
	call WriteBackupGeneralSaveData
	call WriteBackupCardAndDeckSaveData
	pop de
	ret

_SaveGeneralSaveData:
	push de
	call GetReceivedLegendaryCards
	ld de, sGeneralSaveData
	call SaveGeneralSaveDataFromDE
	ld de, sAlbumProgress
	call UpdateAlbumProgress
	pop de
	ret

; de = pointer to general game data in SRAM
SaveGeneralSaveDataFromDE:
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
UpdateAlbumProgress:
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
CopyGeneralSaveDataToSRAM:
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
ValidateBackupGeneralSaveData:
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
_ValidateGeneralSaveData:
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
ValidateGeneralSaveDataFromDE:
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

LoadAlbumProgressFromSRAM:
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
LoadBackupSaveData:
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

_LoadGeneralSaveData:
	push de
	ld de, sGeneralSaveData
	call LoadGeneralSaveDataFromDE
	pop de
	ret

; de = pointer to save data
LoadGeneralSaveDataFromDE:
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
WRAMToSRAMMapper:
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
.EmptySRAMSlot:
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; save the game
; if c is 0, save the player at their current position
; otherwise, save the player in Mason's lab
_SaveGame:
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

_AddCardToCollectionAndUpdateAlbumProgress:
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

WriteBackupCardAndDeckSaveData:
	ld bc, sCardAndDeckSaveDataEnd - sCardAndDeckSaveData
	ld hl, sCardCollection
	jr WriteDataToBackup

WriteBackupGeneralSaveData:
	ld bc, sGeneralSaveDataEnd - sGeneralSaveData
	ld hl, sGeneralSaveData
;	fallthrough

; bc = number of bytes to copy to backup
; hl = pointer in SRAM of data to backup
WriteDataToBackup:
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

LoadBackupCardAndDeckSaveData:
	ld bc, sCardAndDeckSaveDataEnd - sCardAndDeckSaveData
	ld hl, sCardCollection
	jr LoadDataFromBackup

LoadBackupGeneralSaveData:
	ld bc, sGeneralSaveDataEnd - sGeneralSaveData
	ld hl, sGeneralSaveData
;	fallthrough

; bc = number of bytes to load from backup
; hl = pointer in SRAM of backup data
LoadDataFromBackup:
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
GetNPCHeaderPointer:
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

LoadNPCSpriteData:
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
GetNPCNameAndScript:
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
SetNPCDialogName:
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
SetNPCOpponentNameAndPortrait:
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
SetNPCDeckIDAndDuelTheme:
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
SetNPCMatchStartTheme:
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

_GetNPCDuelConfigurations:
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

_GetChallengeMachineDuelConfigurations:
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

DeckIDDuelConfigurations:
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

OverworldScriptTable:
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

MultichoiceTextbox_ConfigTable_ChooseDeckToDuelAgainst:
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

MultichoiceTextbox_ConfigTable_ChooseDeckStarterDeck:
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

SamNormalMultichoice_ConfigurationTable:
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

SamRulesMultichoice_ConfigurationTable:
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

INCLUDE "data/overworld_map/player_movement_paths.asm"

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
	call Func_3ca0
	call Func_12871
	ld a, $01
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
	xor a
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

; usually, the game doesn't loop here at all, since as soon as a main menu option
; is selected, there is no need to come back to the menu.
; the only exception is after returning from Card Pop!
_GameLoop:
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

MainMenuFunctionTable:
	dw MainMenu_CardPop
	dw MainMenu_ContinueFromDiary
	dw MainMenu_NewGame
	dw MainMenu_ContinueDuel

MainMenu_NewGame:
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

MainMenu_ContinueFromDiary:
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

MainMenu_CardPop:
	ld a, MUSIC_CARD_POP
	call PlaySong
	bank1call DoCardPop
	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	ld a, MUSIC_STOP
	call PlaySong
	scf
	ret

MainMenu_ContinueDuel:
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

; a = keys to escape
WaitUntilKeysArePressed:
	push bc
	ld b, a
.loop_input
	push bc
	call DoFrameIfLCDEnabled
	pop bc
	ldh a, [hKeysPressed]
	and b
	jr z, .loop_input
	pop bc
	ret

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
; to be the defaultm
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

DisplayPlayerNamingScreen::
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
	textfw3 "MARK"
	db TX_END, TX_END, TX_END, TX_END

Unknown_128f7:
	db  0,  0 ; start menu coords
	db 16, 18 ; start menu text box dimensions

	db  2, 2 ; text alignment for InitTextPrinting
	tx DebugMenuText
	db $ff

	db 1, 2 ; cursor x, cursor y
	db 1 ; y displacement between items
	db 11 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_12908:
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

Unknown_12919:
	db  0,  0 ; start menu coords
	db 12, 12 ; start menu text box dimensions

	db  2, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackMenuText
	db $ff

	db 1, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1292a:
	db 12,  0 ; start menu coords
	db  4, 16 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackColosseumEvolutionMenuText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 7 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1293b:
	db 12,  0 ; start menu coords
	db  4, 14 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackMysteryMenuText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 6 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1294c:
	db 12,  0 ; start menu coords
	db  4, 12 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackLaboratoryMenuText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1295d:
	db 12,  0 ; start menu coords
	db  4, 10 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackEnergyMenuText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 4 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; disables all sprite animations
; and clears memory related to sprites
Func_1296e:
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

	call ClearSpriteVRAMBuffer
	call ZeroObjectPositions
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	pop hl
	pop bc
	ret

; creates a new entry in SpriteAnimBuffer, else loads the sprite if need be
CreateSpriteAndAnimBufferEntry:
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

FillNewSpriteAnimBufferEntry:
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

DisableCurSpriteAnim:
	ld a, [wWhichSprite]
	; fallthrough

; sets SPRITE_ANIM_ENABLED to false
; of sprite in register a
DisableSpriteAnim:
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

GetSpriteAnimCounter:
	ld a, [wWhichSprite]
	push hl
	push bc
	ld c, SPRITE_ANIM_COUNTER
	call GetSpriteAnimBufferProperty_SpriteInA
	ld a, [hl]
	pop bc
	pop hl
	ret

_HandleAllSpriteAnimations:
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

LoadSpriteDataForAnimationFrame:
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
TryHandleSpriteAnimationFrame:
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

StartNewSpriteAnimation:
	push hl
	push af
	ld c, SPRITE_ANIM_ID
	call GetSpriteAnimBufferProperty
	pop af
	cp [hl]
	pop hl
	ret z
	; fallthrough

StartSpriteAnimation:
	push hl
	call LoadSpriteAnimPointers
	call HandleAnimationFrame
	pop hl
	ret

; a = sprite animation
; c = animation counter value
Func_12ac9:
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
LoadSpriteAnimPointers:
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
HandleAnimationFrame:
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
GetAnimFramePointerFromOffset:
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
SetAnimationCounterAndLoop:
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

Func_12ba7:
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

Func_12bcd:
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
ClearSpriteVRAMBuffer:
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
Func_12c05:
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
Func_12c4f:
	push af
	xor a
	ld [wd4cb], a
	ld a, d
	ld [wVRAMTileOffset], a
	pop af
	farcall Func_8025b
	ret

Func_12c5e:
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
_LoadScene:
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

ScenePointers:
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

Scene_TitleScreen:
	dw SGBData_TitleScreen
	dw NULL
	db PALETTE_25, PALETTE_25, $00
	db TILEMAP_TITLE_SCREEN, TILEMAP_TITLE_SCREEN_CGB, $00, $00
	db $00

Scene_JapaneseTitleScreen:
	dw SGBData_TitleScreen
	dw NULL
	db PALETTE_25, PALETTE_25, $00
	db TILEMAP_JAPANESE_TITLE_SCREEN, TILEMAP_JAPANESE_TITLE_SCREEN_CGB, $80, $00
	db $00

Scene_ColosseumBooster:
	dw SGBData_ColosseumBooster
	dw NULL
	db PALETTE_108, PALETTE_101, $01
	db TILEMAP_COLOSSEUM, TILEMAP_COLOSSEUM_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_EvolutionBooster:
	dw SGBData_EvolutionBooster
	dw NULL
	db PALETTE_108, PALETTE_102, $01
	db TILEMAP_EVOLUTION, TILEMAP_EVOLUTION_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_MysteryBooster:
	dw SGBData_MysteryBooster
	dw NULL
	db PALETTE_108, PALETTE_103, $01
	db TILEMAP_MYSTERY, TILEMAP_MYSTERY_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_LaboratoryBooster:
	dw SGBData_LaboratoryBooster
	dw NULL
	db PALETTE_108, PALETTE_104, $01
	db TILEMAP_LABORATORY, TILEMAP_LABORATORY_CGB, $80, $00
	db SPRITE_BOOSTER_PACK_OAM
	db PALETTE_117, PALETTE_117, $00
	db $ff, SPRITE_ANIM_189, $00, $00
	dw $00

Scene_CharizardIntro:
	dw SGBData_CharizardIntro
	dw NULL
	db PALETTE_108, PALETTE_105, $01
	db TILEMAP_CHARIZARD_INTRO, TILEMAP_CHARIZARD_INTRO_CGB, $80, $00
	db $00

Scene_ScytherIntro:
	dw SGBData_ScytherIntro
	dw NULL
	db PALETTE_108, PALETTE_106, $01
	db TILEMAP_SCYTHER_INTRO, TILEMAP_SCYTHER_INTRO_CGB, $80, $00
	db $00

Scene_AerodactylIntro:
	dw SGBData_AerodactylIntro
	dw NULL
	db PALETTE_108, PALETTE_107, $01
	db TILEMAP_AERODACTYL_INTRO, TILEMAP_AERODACTYL_INTRO_CGB, $80, $00
	db $00

Scene_GradientBlackAndRed:
	dw NULL
	dw NULL
	db PALETTE_94, PALETTE_94, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientWhiteAndRed:
	dw NULL
	dw NULL
	db PALETTE_95, PALETTE_95, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientBlackAndGreen:
	dw NULL
	dw NULL
	db PALETTE_96, PALETTE_96, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_GradientWhiteAndGreen:
	dw NULL
	dw NULL
	db PALETTE_97, PALETTE_97, $00
	db TILEMAP_SOLID_TILES_1, TILEMAP_SOLID_TILES_1, $01, $00
	db $00

Scene_ColorWheel:
	dw NULL
	dw NULL
	db PALETTE_98, PALETTE_98, $00
	db TILEMAP_SOLID_TILES_2, TILEMAP_SOLID_TILES_2, $01, $00
	db $00

Scene_ColorTest:
	dw NULL
	dw NULL
	db PALETTE_99, PALETTE_99, $00
	db TILEMAP_SOLID_TILES_3, TILEMAP_SOLID_TILES_3, $01, $00
	db $00

Scene_ColorPalette:
	dw NULL
	dw NULL
	db PALETTE_110, PALETTE_110, $00
	db TILEMAP_SOLID_TILES_4, TILEMAP_SOLID_TILES_4, $fc, $01
	db $00

Scene_GameBoyLinkConnecting:
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_GAMEBOY_LINK_CONNECTING, TILEMAP_GAMEBOY_LINK_CONNECTING_CGB, $90, $00
	db $00

Scene_GameBoyLinkTransmitting:
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_GAMEBOY_LINK, TILEMAP_GAMEBOY_LINK_CGB, $90, $00
	db SPRITE_DUEL_52
	db PALETTE_114, PALETTE_114, $00
	db SPRITE_ANIM_179, SPRITE_ANIM_176, $50, $50
	dw $00

Scene_GameBoyLinkNotConnected:
	dw SGBData_GameBoyLink
	dw NULL
	db PALETTE_111, PALETTE_111, $00
	db TILEMAP_GAMEBOY_LINK, TILEMAP_GAMEBOY_LINK_CGB, $90, $00
	db SPRITE_DUEL_52
	db PALETTE_114, PALETTE_114, $00
	db SPRITE_ANIM_180, SPRITE_ANIM_177, $50, $50
	dw $00

Scene_GameBoyPrinterTransmitting:
	dw SGBData_GameBoyPrinter
	dw LoadScene_SetGameBoyPrinterAttrBlk
	db PALETTE_112, PALETTE_112, $00
	db TILEMAP_GAMEBOY_PRINTER, TILEMAP_GAMEBOY_PRINTER_CGB, $90, $00
	db SPRITE_DUEL_53
	db PALETTE_115, PALETTE_115, $00
	db SPRITE_ANIM_183, SPRITE_ANIM_181, $50, $30
	dw $00

Scene_GameBoyPrinterNotConnected:
	dw SGBData_GameBoyPrinter
	dw LoadScene_SetGameBoyPrinterAttrBlk
	db PALETTE_112, PALETTE_112, $00
	db TILEMAP_GAMEBOY_PRINTER, TILEMAP_GAMEBOY_PRINTER_CGB, $90, $00
	db SPRITE_DUEL_53
	db PALETTE_115, PALETTE_115, $00
	db SPRITE_ANIM_184, SPRITE_ANIM_182, $50, $30
	dw $00

Scene_CardPop:
	dw SGBData_CardPop
	dw LoadScene_SetCardPopAttrBlk
	db PALETTE_113, PALETTE_113, $00
	db TILEMAP_CARD_POP, TILEMAP_CARD_POP_CGB, $80, $00
	db SPRITE_DUEL_54
	db PALETTE_116, PALETTE_116, $00
	db SPRITE_ANIM_187, SPRITE_ANIM_185, $50, $40
	dw $00

Scene_CardPopError:
	dw SGBData_CardPop
	dw LoadScene_SetCardPopAttrBlk
	db PALETTE_113, PALETTE_113, $00
	db TILEMAP_CARD_POP, TILEMAP_CARD_POP_CGB, $80, $00
	db SPRITE_DUEL_54
	db PALETTE_116, PALETTE_116, $00
	db SPRITE_ANIM_188, SPRITE_ANIM_186, $50, $40
	dw $00

Scene_Nintendo:
	dw NULL
	dw NULL
	db PALETTE_27, PALETTE_27, $00
	db TILEMAP_NINTENDO, TILEMAP_NINTENDO, $00, $00
	db $00

Scene_Companies:
	dw NULL
	dw NULL
	db PALETTE_28, PALETTE_28, $00
	db TILEMAP_COMPANIES, TILEMAP_COMPANIES, $00, $00
	db $00

Scene_Copyright:
	dw NULL
	dw NULL
	db PALETTE_26, PALETTE_26, $00
	db TILEMAP_COPYRIGHT, TILEMAP_COPYRIGHT_CGB, $00, $00
	db $00

Scene_JapaneseTitleScreen2:
	dw NULL
	dw NULL
	db PALETTE_109, PALETTE_100, $00
	db TILEMAP_JAPANESE_TITLE_SCREEN_2, TILEMAP_JAPANESE_TITLE_SCREEN_2_CGB, $01, $00
	db $00

LoadScene_LoadCompressedSGBPacket:
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

LoadScene_LoadSGBPacket:
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

LoadScene_SetGameBoyPrinterAttrBlk:
	push hl
	push bc
	push de
	ld hl, SGBPacket_GameBoyPrinter
	call SendSGB
	pop de
	pop bc
	pop hl
	ret

SGBPacket_GameBoyPrinter:
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

LoadScene_SetCardPopAttrBlk:
	push hl
	push bc
	push de
	ld hl, SGBPacket_CardPop
	call SendSGB
	pop de
	pop bc
	pop hl
	ret

SGBPacket_CardPop:
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

Func_12fc6:
	ld a, [wd291]
	push af
	push de
	push bc
	lb de, $d0, $07
	ld a, [wCurTilemap]
	cp TILEMAP_PLAYER
	jr z, .asm_12fd9
	lb de, $a0, $06
.asm_12fd9
	ld a, e
	ld [wd291], a
	farcall LoadTilemap_ToVRAM
	ld a, [wd61e]
	add a
	add a
	ld c, a
	ld b, $00
	ld hl, PortraitGfxData
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
	farcall SendSGBPortraitPalettes
	pop de
	pop af
	ld [wd291], a
	ret

PortraitGfxData:
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

LoadBoosterGfx:
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

SetBoosterLogoOAM:
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

BoosterLogoOAM:
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

INCLUDE "engine/challenge_machine.asm"

INCLUDE "data/npc_map_data.asm"
INCLUDE "data/map_objects.asm"
