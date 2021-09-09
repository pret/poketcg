SaveGeneralSaveData: ; 3a3b (0:3a3b)
	farcall _SaveGeneralSaveData
	ret

LoadGeneralSaveData: ; 3a40 (0:3a40)
	farcall _LoadGeneralSaveData
	ret

ValidateGeneralSaveData: ; 3a45 (0:3a45)
	farcall _ValidateGeneralSaveData
	ret

; adds card with card ID in register a to collection
; and updates album progress in RAM
AddCardToCollectionAndUpdateAlbumProgress: ; 3a4a (0:3a4a)
	farcall _AddCardToCollectionAndUpdateAlbumProgress
	ret

SaveGame: ; 3a4f (0:3a4f)
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
