DuelCheckInterface: ; 8000 (2:4000)
.begin
	call ResetCursorPosAndBlink
	xor a
	ld [wce5e], a
	call DrawWideTextBox
	xor a
	ld [wDuelCursorBlinkCounter], a
	ld hl, CheckMenuData
	call PlaceTextItems
.asm_8014
	call DoFrame
	call Func_9065
	jr nc, .asm_8014
	cp $ff
	ret z
	ld a, [wCursorDuelYPosition]
	sla a
	ld b, a
	ld a, [wCursorDuelXPosition]
	add b
	ld hl, DuelCheckMenuFunctionTable
	call JumpToFunctionInTable
	jr .begin

DuelCheckMenuFunctionTable: ; 8031 (2:4031)
	dw DuelCheckMenu_InPlayArea
	dw DuelCheckMenu_Glossary
	dw DuelCheckMenu_YourPlayArea
	dw DuelCheckMenu_OppPlayArea

DuelCheckMenu_InPlayArea: ; 8039 (2:4039)
	xor a
	ld [wce60], a
	farcall Func_180d5
	ret

DuelCheckMenu_Glossary: ; 8042 (2:4042)
	farcall Func_006_44c8
	ret

DuelCheckMenu_YourPlayArea: ; 8047 (2:4047)
	INCROM $8047, $80da

DuelCheckMenu_OppPlayArea: ; 80da (2:40da)
	INCROM $80da, $8158

CheckMenuData: ; (2:4158)
	textitem  2, 14, InPlayAreaText
	textitem  2, 16, YourPlayAreaText
	textitem 12, 14, GlossaryText
	textitem 12, 16, OppPlayAreaText
	db $ff

Func_8169: ; 8169 (2:4169)
	INCROM $8169, $8211

Func_8211: ; 8211 (2:4211)
	INCROM $8211, $833c

Func_833c: ; 833c (2:433c)
	INCROM $833c, $8764

Func_8764: ; 8764 (2:4764)
	INCROM $8764, $8932

Func_8932: ; 8932 (2:4932)
	INCROM $8932, $8aaa

Func_8aaa: ; 8aaa (2:4aaa)
	INCROM $8aaa, $8b85

Func_8b85: ; 8b85 (2:4b85)
	INCROM $8b85, $8cd4

Func_8cd4: ; 8cd4 (2:4cd4)
	push bc
	call EnableSRAM
	ld b, $3c
.asm_8cda
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .asm_8cda
	xor a
	ld [hl], a
	call DisableSRAM
	pop bc
	ret
; 0x8ce7

	INCROM $8ce7, $8cf9

Func_8cf9: ; 8cf9 (2:4cf9)
	call EnableSRAM
	xor a
	ld hl, $b703
	ld [hli], a
	inc a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [$b701], a
	call DisableSRAM
Func_8d0b: ; 8d0b (2:4d0b)
	ld hl, Unknown_8d15
	ld de, $9380
	call Func_92ad
	ret

Unknown_8d15: ; 8d15 (2:4d15)
	INCROM $8d15, $8d56

Func_8d56: ; 8d56 (2:4d56)
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont
	call LoadDuelCardSymbolTiles
	call Func_8d0b
	bank1call SetDefaultPalettes
	lb de, $3c, $bf
	call SetupText
	ret
; 0x8d78

	INCROM $8d78, $8d9d

Func_8d9d: ; 8d9d (2:4d9d)
	ld de, wcfd1
	ld b, $7
.asm_8da2
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_8da2
	ret

Unknown_8da9: ; 8da9 (2:4da9)
	INCROM $8da9, $8db0

Func_8db0: ; 8db0 (2:4db0)
	ld hl, Unknown_8da9
	call Func_8d9d
	ld a, $ff
	call Func_9168
	xor a

Func_8dbc: ; 8dbc (2:4dbc)
	ld hl, Unknown_8de2
	call InitializeMenuParameters
	ldtx hl, PleaseSelectDeckText
	call DrawWideTextBox_PrintText
.asm_8dc8
	call DoFrame
	jr c, Func_8dbc
	call Func_8dea
	jr c, Func_8dbc
	call HandleMenuInput
	jr nc, .asm_8dc8
	ldh a, [hCurMenuItem]
	cp $ff
	ret z
	ld [wceb1], a
	jp Func_8e42

Unknown_8de2: ; 8de2 (2:4de2)
	INCROM $8de2, $8dea

Func_8dea: ; 8dea (2:4dea)
	ldh a, [hDPadHeld]
	and START
	ret z
	ld a, [wCurMenuItem]
	ld [wceb1], a
	call Func_8ff2
	jp nc, Func_8e05
	ld a, $ff
	call Func_90fb
	call Func_8fe8
	scf
	ret

Func_8e05: ; 8e05 (2:4e05)
	ld a, $1
	call Func_90fb
	call GetPointerToDeckCards
	push hl
	call GetPointerToDeckName
	pop de
	call Func_8e1f
	ld a, $ff
	call Func_9168
	ld a, [wceb1]
	scf
	ret

Func_8e1f: ; 8e1f (2:4e1f)
	push de
	ld de, wcfb9
	call Func_92b4
	pop de
	ld hl, wcf17
	call Func_8cd4
	ld a, $9
	ld hl, wcebb
	call Func_9843
	ld a, $3c
	ld [wcecc], a
	ld hl, wcebb
	ld [hl], a
	call Func_9e41
	ret

Func_8e42: ; 8e42 (2:4e42)
	call DrawWideTextBox
	ld hl, Unknown_9027
	call PlaceTextItems
	call ResetCursorPosAndBlink
.asm_8e4e
	call DoFrame
	call Func_9065
	jp nc, .asm_8e4e
	cp $ff
	jr nz, .asm_8e64
	call Func_90d8
	ld a, [wceb1]
	jp Func_8dbc
.asm_8e64
	ld a, [wCursorDuelXPosition]
	or a
	jp nz, Func_8f8a
	ld a, [wCursorDuelYPosition]
	or a
	jp nz, .asm_8ecf
	call GetPointerToDeckCards
	ld e, l
	ld d, h
	ld hl, wcf17
	call Func_8cd4
	ld a, $14
	ld hl, wcfb9
	call Func_9843
	ld de, wcfb9
	call GetPointerToDeckName
	call Func_92b4
	call Func_9345
	jr nc, .asm_8ec4
	call EnableSRAM
	ld hl, wcf17
	call Func_910a
	call GetPointerToDeckCards
	call Func_9152
	ld e, l
	ld d, h
	ld hl, wcf17
	ld b, $3c
.asm_8ea9
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_8ea9
	call GetPointerToDeckName
	ld d, h
	ld e, l
	ld hl, wcfb9
	call Func_92ad
	call GetPointerToDeckName
	ld a, [hl]
	call DisableSRAM
	or a
	jr z, .asm_8edb
.asm_8ec4
	ld a, $ff
	call Func_9168
	ld a, [wceb1]
	jp Func_8dbc
.asm_8ecf
	call Func_8ff2
	jp nc, .asm_8edb
	call Func_8fe8
	jp Func_8dbc
.asm_8edb
	ld a, $14
	ld hl, wcfb9
	call Func_9843
	ld de, wcfb9
	call GetPointerToDeckName
	call Func_92b4
	call Func_8f05
	call GetPointerToDeckName
	ld d, h
	ld e, l
	ld hl, wcfb9
	call Func_92b4
	ld a, $ff
	call Func_9168
	ld a, [wceb1]
	jp Func_8dbc

Func_8f05: ; 8f05 (2:4f05)
	ld a, [wceb1]
	or a
	jr nz, .asm_8f10
	; it refers to a data in the other bank without any bank desc.
	ld hl, Deck1Data
	jr .asm_8f23
.asm_8f10
	dec a
	jr nz, .asm_8f18
	ld hl, Deck2Data
	jr .asm_8f23
.asm_8f18
	dec a
	jr nz, .asm_8f20
	ld hl, Deck3Data
	jr .asm_8f23
.asm_8f20
	ld hl, Deck4Data
.asm_8f23
	ld a, MAX_DECK_NAME_LENGTH
	lb bc, 4, 1
	ld de, wcfb9
	farcall InputDeckName
	ld a, [wcfb9]
	or a
	ret nz
	call Func_8f38
	ret

Func_8f38: ; 8f38 (2:4f38)
	ld hl, $b701
	call EnableSRAM
	ld a, [hli]
	ld h, [hl]
	call DisableSRAM
	ld l, a
	ld de, wDefaultText
	call TwoByteNumberToText
	ld hl, wcfb9
	ld [hl], $6
	inc hl
	ld [hl], $44
	inc hl
	ld [hl], $65
	inc hl
	ld [hl], $63
	inc hl
	ld [hl], $6b
	inc hl
	ld [hl], $20
	inc hl
	ld de, $c592
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	xor a
	ld [hl], a
	ld hl, $b701
	call EnableSRAM
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, $3
	cp d
	jr nz, .asm_8f82
	ld a, $e7
	cp e
	jr nz, .asm_8f82
	ld de, $0000
.asm_8f82
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	call DisableSRAM
	ret

Func_8f8a: ; 8f8a (2:4f8a)
	ld a, [wCursorDuelYPosition]
	or a
	jp nz, Func_9026
	call Func_8ff2
	jp nc, Func_8f9d
	call Func_8fe8
	jp Func_8dbc

Func_8f9d: ; 8f9d (2:4f9d)
	call EnableSRAM
	ld a, [s0b700]
	call DisableSRAM
	ld h, $3
	ld l, a
	call HtimesL
	ld e, l
	inc e
	ld d, 2
	xor a
	lb hl, 0, 0
	lb bc, 2, 2
	call FillRectangle
	ld a, [wceb1]
	call EnableSRAM
	ld [s0b700], a
	call DisableSRAM
	call Func_9326
	call GetPointerToDeckName
	call EnableSRAM
	call Func_9253
	call DisableSRAM
	xor a
	ld [wTxRam2], a
	ld [wTxRam2 + 1], a
	ldtx hl, ChosenAsDuelingDeckText
	call DrawWideTextBox_WaitForInput
	ld a, [wceb1]
	jp Func_8dbc

Func_8fe8: ; 8fe8 (2:4fe8)
	ldtx hl, ThereIsNoDeckHereText
	call DrawWideTextBox_WaitForInput
	ld a, [wceb1]
	ret

Func_8ff2: ; 8ff2 (2:4ff2)
	ld a, [wceb1]
	ld hl, wceb2
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	or a
	ret nz
	scf
	ret
; 0x9001

	INCROM $9001, $9026

Func_9026: ; 9026 (2:5026)
	ret

Unknown_9027: ; 9027 (2:5027)
	INCROM $9027, $9038

; return, in hl, the pointer to sDeckXName where X is [wceb1] + 1
GetPointerToDeckName: ; 9038 (2:5038)
	ld a, [wceb1]
	ld h, a
	ld l, sDeck2Name - sDeck1Name
	call HtimesL
	push de
	ld de, sDeck1Name
	add hl, de
	pop de
	ret

; return, in hl, the pointer to sDeckXCards where X is [wceb1] + 1
GetPointerToDeckCards: ; 9048 (2:5048)
	push af
	ld a, [wceb1]
	ld h, a
	ld l, sDeck2Cards - sDeck1Cards
	call HtimesL
	push de
	ld de, sDeck1Cards
	add hl, de
	pop de
	pop af
	ret

ResetCursorPosAndBlink: ; 905a (2:505a)
	xor a
	ld [wCursorDuelXPosition], a
	ld [wCursorDuelYPosition], a
	ld [wDuelCursorBlinkCounter], a
	ret

Func_9065: ; 9065 (2:5065)
	xor a
	ld [wcfe3], a
	ld a, [wCursorDuelXPosition]
	ld d, a
	ld a, [wCursorDuelYPosition]
	ld e, a
	ldh a, [hDPadHeld]
	or a
	jr z, .asm_90a6
	bit D_LEFT_F, a
	jr nz, .asm_907e
	bit D_RIGHT_F, a
	jr z, .asm_9084
.asm_907e
	ld a, d
	xor $1
	ld d, a
	jr .asm_9090
.asm_9084
	bit D_UP_F, a
	jr nz, .asm_908c
	bit D_DOWN_F, a
	jr z, .asm_90a6
.asm_908c
	ld a, e
	xor $1
	ld e, a
.asm_9090
	ld a, $1
	ld [wcfe3], a
	push de
	call Func_90d8
	pop de
	ld a, d
	ld [wCursorDuelXPosition], a
	ld a, e
	ld [wCursorDuelYPosition], a
	xor a
	ld [wDuelCursorBlinkCounter], a
.asm_90a6
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .asm_90c1
	and A_BUTTON
	jr nz, .asm_90b7
	ld a, $ff
	call Func_90fb
	scf
	ret
.asm_90b7
	call Func_90f7
	ld a, $1
	call Func_90fb
	scf
	ret
.asm_90c1
	ld a, [wcfe3]
	or a
	jr z, .asm_90ca
	call PlaySFX
.asm_90ca
	ld hl, wDuelCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and $f
	ret nz
	ld a, $f
	bit 4, [hl]
	jr z, asm_90da
Func_90d8: ; 90d8 (2:50d8)
	ld a, $0
asm_90da
	ld e, a
	ld a, $a
	ld l, a
	ld a, [wCursorDuelXPosition]
	ld h, a
	call HtimesL
	ld a, l
	add $1
	ld b, a
	ld a, [wCursorDuelYPosition]
	sla a
	add $e
	ld c, a
	ld a, e
	call WriteByteToBGMap0
	or a
	ret

Func_90f7: ; 90f7 (2:50f7)
	ld a, $f
	jr asm_90da

Func_90fb: ; 90fb (2:50fb)
	push af
	inc a
	jr z, .asm_9103
	ld a, $2
	jr .asm_9105
.asm_9103
	ld a, $3
.asm_9105
	call PlaySFX
	pop af
	ret

Func_910a: ; 910a (2:510a)
	push hl
	ld b, $0
	ld d, $3c
.asm_910f
	ld a, [hli]
	or a
	jr z, .asm_911e
	ld c, a
	push hl
	ld hl, sCardCollection
	add hl, bc
	dec [hl]
	pop hl
	dec d
	jr nz, .asm_910f
.asm_911e
	pop hl
	ret
; 0x9120

	INCROM $9120, $9152

Func_9152: ; 9152 (2:5152)
	push hl
	ld b, $0
	ld d, $3c
.asm_9157
	ld a, [hli]
	or a
	jr z, .asm_9166
	ld c, a
	push hl
	ld hl, sCardCollection
	add hl, bc
	inc [hl]
	pop hl
	dec d
	jr nz, .asm_9157
.asm_9166
	pop hl
	ret

Func_9168: ; 9168 (2:5168)
	ld [hffb5], a
	call Func_8d56
	ld de, $0000
	ld bc, $1404
	call DrawRegularTextBox
	ld de, $0003
	ld bc, $1404
	call DrawRegularTextBox
	ld de, $0006
	ld bc, $1404
	call DrawRegularTextBox
	ld de, $0009
	ld bc, $1404
	call DrawRegularTextBox
	ld hl, Unknown_9242
	call PlaceTextItems
	ld a, $4
	ld hl, wceb2
	call Func_9843
	ld a, [hffb5]
	bit 0, a
	jr z, .asm_91b0
	ld hl, sDeck1Name
	ld de, $0602
	call Func_926e
.asm_91b0
	ld hl, sDeck1Cards
	call Func_9314
	jr c, .asm_91bd
	ld a, $1
	ld [wceb2], a
.asm_91bd
	ld a, [hffb5]
	bit 1, a
	jr z, .asm_91cd
	ld hl, sDeck2Name
	ld de, $0605
	call Func_926e
.asm_91cd
	ld hl, sDeck2Cards
	call Func_9314
	jr c, .asm_91da
	ld a, $1
	ld [wceb3], a
.asm_91da
	ld a, [hffb5]
	bit 2, a
	jr z, .asm_91ea
	ld hl, sDeck3Name
	ld de, $0608
	call Func_926e
.asm_91ea
	ld hl, sDeck3Cards
	call Func_9314
	jr c, .asm_91f7
	ld a, $1
	ld [wceb4], a
.asm_91f7
	ld a, [hffb5]
	bit 3, a
	jr z, .asm_9207
	ld hl, sDeck4Name
	ld de, $060b
	call Func_926e
.asm_9207
	ld hl, sDeck4Cards
	call Func_9314
	jr c, .asm_9214
	ld a, $1
	ld [wceb5], a
.asm_9214
	call EnableSRAM
	ld a, [s0b700]
	ld c, a
	ld b, $0
	ld d, $2
.asm_921f
	ld hl, wceb2
	add hl, bc
	ld a, [hl]
	or a
	jr nz, .asm_9234
	inc c
	ld a, $4
	cp c
	jr nz, .asm_921f
	ld c, $0
	dec d
	jr z, .asm_9234
	jr .asm_921f
.asm_9234
	ld a, c
	ld [s0b700], a
	call DisableSRAM
	call Func_9326
	call EnableLCD
	ret

Unknown_9242: ; 9242 (2:5242)
	INCROM $9242, $9253

Func_9253: ; 9253 (2:5253)
	ld de, wDefaultText
	call Func_92ad
	ld hl, wDefaultText
	call GetTextLengthInTiles
	ld b, $0
	ld hl, wDefaultText
	add hl, bc
	ld d, h
	ld e, l
	ld hl, Unknown_92a7
	call Func_92ad
	ret

Func_926e: ; 926e (2:526e)
	push hl
	call Func_9314
	pop hl
	jr c, .asm_929c
	push de
	ld de, wDefaultText
	call Func_92b4
	ld hl, wDefaultText
	call GetTextLengthInTiles
	ld b, $0
	ld hl, wDefaultText
	add hl, bc
	ld d, h
	ld e, l
	ld hl, Unknown_92a7
	call Func_92ad
	pop de
	ld hl, wDefaultText
	call InitTextPrinting
	call ProcessText
	or a
	ret
.asm_929c
	call InitTextPrinting
	ldtx hl, NewDeckText
	call ProcessTextFromID
	scf
	ret

Unknown_92a7: ; 92a7 (2:52a7)
	INCROM $92a7, $92ad

Func_92ad: ; 92ad (2:52ad)
	ld a, [hli]
	ld [de], a
	or a
	ret z
	inc de
	jr Func_92ad

Func_92b4: ; 92b4 (2:52b4)
	call EnableSRAM
	call Func_92ad
	call DisableSRAM
	ret
; 0x92be

	INCROM $92be, $9314

Func_9314: ; 9314 (2:5314)
	ld bc, $0018
	add hl, bc
	call EnableSRAM
	ld a, [hl]
	call DisableSRAM
	or a
	jr nz, .asm_9324
	scf
	ret
.asm_9324
	or a
	ret

Func_9326: ; 9326 (2:5326)
	call EnableSRAM
	ld a, [s0b700]
	call DisableSRAM
	ld h, 3
	ld l, a
	call HtimesL
	ld e, l
	inc e
	ld d, 2
	ld a, $38
	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle
	ret

Func_9345: ; 9345 (2:5345)
	INCROM $9345, $9843

Func_9843: ; 9843 (2:5843)
	INCROM $9843, $9e41

Func_9e41: ; 9e41 (2:5e41)
	INCROM $9e41, $a288

Func_a288: ; a288 (2:6288)
	INCROM $a288, $b177

Func_b177: ; b177 (2:7177)
	INCROM $b177, $b19d

Func_b19d: ; b19d (2:719d)
	xor a
	ld [wcea1], a
	ld de, CheckForCGB
	ld hl, wd0a2
	ld [hl], e
	inc hl
	ld [hl], d
	call $7379
	ld a, $3c
	ld [wd0a5], a
	xor a
.asm_b1b3
	ld hl, $76fb
	call $5a6d
	call $7704
	call $7545
	ldtx hl, PleaseSelectDeckText
	call DrawWideTextBox_PrintText
	ld de, $0224 ; PleaseSelectDeckText?
	call $7285
	call $729f
	jr c, .asm_b1b3
	cp $ff
	ret z
	ld b, a
	ld a, [wcea1]
	add b
	ld [wd088], a
	call ResetCursorPosAndBlink
	call DrawWideTextBox
	ld hl, $7274
	call PlaceTextItems
	call DoFrame
	call Func_9065
	jp nc, $71e7
	cp $ff
	jr nz, .asm_b1fa
	ld a, [wd086]
	jp $71b3

.asm_b1fa
	ld a, [wCursorDuelYPosition]
	sla a
	ld hl, wCursorDuelXPosition
	add [hl]
	or a
	jr nz, .asm_b22c
	call $735b
	jr nc, .asm_b216
	call $7592
	ld a, [wd086]
	jp c, $71b3
	jr .asm_b25e

.asm_b216
	ld hl, $0272
	call YesOrNoMenuWithText
	ld a, [wd086]
	jr c, .asm_b1b3
	call $7592
	ld a, [wd086]
	jp c, $71b3
	jr .asm_b25e

.asm_b22c
	cp $1
	jr nz, .asm_b24c
	call $735b
	jr c, .asm_b240
	call $76ca
	ld a, [wd086]
	jp c, $71b3
	jr .asm_b25e

.asm_b240
	ld hl, WaitForVBlank
	call DrawWideTextBox_WaitForInput
	ld a, [wd086]
	jp $71b3

.asm_b24c
	cp $2
	jr nz, .asm_b273
	call $735b
	jr c, .asm_b240
	call $77c6
	ld a, [wd086]
	jp nc, $71b3

.asm_b25e
	ld a, [wd087]
	ld [wcea1], a
	call $7379
	call $7704
	call $7545
	ld a, [wd086]
	jp $71b3

.asm_b273
	ret
; 0xb274

	INCROM $b274, $ba04

Func_ba04: ; ba04 (2:7a04)
	ld a, [wd0a9]
	ld hl, $7b83
	sla a
	ld c, a
	ld b, $0
	add hl, bc
	ld de, wd0a2
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	xor a
	ld [wcea1], a
	call $7b97
	ld a, $5
	ld [wd0a5], a
	xor a
	ld hl, $7b6e
	call InitializeMenuParameters
	ldtx hl, PleaseSelectDeckText
	call DrawWideTextBox_PrintText
	ld a, $5
	ld [wNamingScreenKeyboardHeight], a
	ld hl, $73fe
	ld d, h
	ld a, l
	ld hl, wcece
	ld [hli], a
	ld [hl], d
.asm_ba40
	call DoFrame
	call HandleMenuInput
	jr c, .asm_baa3
	ldh a, [hDPadHeld]
	and D_UP | D_DOWN
	jr z, .asm_ba4e

.asm_ba4e
	ldh a, [hDPadHeld]
	and START
	jr z, .asm_ba40
	ld a, [wcea1]
	ld [wd087], a
	ld b, a
	ld a, [wCurMenuItem]
	ld [wd086], a
	add b
	ld c, a
	inc a
	or $80
	ld [wceb1], a
	sla c
	ld b, $0
	ld hl, wd00d
	add hl, bc
	call $7653
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, $0018
	add hl, bc
	ld d, h
	ld e, l
	ld a, [hl]
	pop hl
	call $7644
	or a
	jr z, .asm_ba40
	ld a, $1
	call Func_90fb
	call $7653
	call Func_8e1f
	call $7644
	ld a, [wd087]
	ld [wcea1], a
	call $7b97
	ld a, [wd086]
	jp $7a25

.asm_baa3
	call DrawCursor2
	ld a, [wcea1]
	ld [wd087], a
	ld a, [wCurMenuItem]
	ld [wd086], a
	ldh a, [hCurMenuItem]
	cp $ff
	jp z, $7b0d
	ld [wd088], a
	call ResetCursorPosAndBlink
	xor a
	ld [wce5e], a
	call DrawWideTextBox
	ld hl, $7b76
	call PlaceTextItems
	call DoFrame
	call $46ac
	jp nc, $7acc
	cp $ff
	jr nz, .asm_badf
	ld a, [wd086]
	jp $7a25

.asm_badf
	ld a, [wCursorDuelYPosition]
	sla a
	ld hl, wCursorDuelXPosition
	add [hl]
	or a
	jr nz, .asm_bb09
	call $7653
	call $77c6
	call $7644
	ld a, [wd086]
	jp nc, $7a25
	ld a, [wd087]
	ld [wcea1], a
	call $7b97
	ld a, [wd086]
	jp $7a25

.asm_bb09
	cp $1
	jr nz, .asm_bb12
	xor a
	ld [wd0a4], a
	ret

.asm_bb12
	ld a, [wcea1]
	ld [wd087], a
	ld b, a
	ld a, [wCurMenuItem]
	ld [wd086], a
	add b
	ld c, a
	ld [wceb1], a
	sla c
	ld b, $0
	ld hl, wd00d
	add hl, bc
	push hl
	ld hl, wd0aa
	add hl, bc
	ld bc, wcfda
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hl]
	ld [bc], a
	pop hl
	call $7653
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, $0018
	add hl, bc
	ld d, h
	ld e, l
	ld a, [hl]
	pop hl
	call $7644
	or a
	jp z, $7a40
	ld a, $1
	call Func_90fb
	call $7653
	xor a
	call $6dfe
	call $7644
	ld a, [wd087]
	ld [wcea1], a
	call $7b97
	ld a, [wd086]
	jp $7a25
; 0xbb6e

	INCROM $bb6e, $c000
