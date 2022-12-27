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
	table_width 4, OpponentTitlesAndDeckNames

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

	assert_table_length NUM_DECK_IDS
