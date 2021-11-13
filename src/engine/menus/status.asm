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
