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
	table_width 2, MasterMedalNames
	tx GrassClubMapName
	tx ScienceClubMapName
	tx FireClubMapName
	tx WaterClubMapName
	tx LightningClubMapName
	tx PsychicClubMapName
	tx RockClubMapName
	tx FightingClubMapName
	assert_table_length NUM_MEDALS
