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
	ld a, SFX_SAVE_GAME
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
