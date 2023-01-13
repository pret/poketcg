SaveGeneralSaveData::
	farcall _SaveGeneralSaveData
	ret

LoadGeneralSaveData::
	farcall _LoadGeneralSaveData
	ret

ValidateGeneralSaveData::
	farcall _ValidateGeneralSaveData
	ret

; adds card with card ID in register a to collection
; and updates album progress in RAM
AddCardToCollectionAndUpdateAlbumProgress::
	farcall _AddCardToCollectionAndUpdateAlbumProgress
	ret

SaveGame::
	push af
	push bc
	push de
	push hl
	ld c, $00
	farcall _SaveGame
	pop hl
	pop de
	pop bc
	pop af
	ret
