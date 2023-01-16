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

_SaveGeneralSaveData::
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
_ValidateGeneralSaveData::
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

_LoadGeneralSaveData::
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

MACRO wram_sram_map
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
	wram_sram_map wGiftCenterChoice,                  1, $00, $ff ; sGiftCenterChoice
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
_SaveGame::
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

_AddCardToCollectionAndUpdateAlbumProgress::
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
