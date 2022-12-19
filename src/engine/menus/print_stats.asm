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
	table_width 3, MedalCoordsAndTilemaps
	db  1, 10, TILEMAP_GRASS_MEDAL
	db  6, 10, TILEMAP_SCIENCE_MEDAL
	db 11, 10, TILEMAP_FIRE_MEDAL
	db 16, 10, TILEMAP_WATER_MEDAL
	db  1, 14, TILEMAP_LIGHTNING_MEDAL
	db  6, 14, TILEMAP_PSYCHIC_MEDAL
	db 11, 14, TILEMAP_ROCK_MEDAL
	db 16, 14, TILEMAP_FIGHTING_MEDAL
	assert_table_length NUM_MEDALS

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
