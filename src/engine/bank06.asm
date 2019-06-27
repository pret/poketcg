_CopyCardNameAndLevel: ; 18000 (6:4000)
	push bc
	push de
	ld [wcd9b], a
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDefaultText
	push de
	call CopyText ; copy card name to wDefaultText
	pop hl
	ld a, [hli]
	cp TX_HALFWIDTH
	jp z, Func_18086
	ld a, [wcd9b]
	ld c, a
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .level_done ; jump if energy or trainer
	ld a, [wLoadedCard1Level]
	or a
	jr z, .level_done
	inc c
	inc c
	ld a, [wLoadedCard1Level]
	cp 10
	jr c, .level_done
	inc c ; second digit
.level_done
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDefaultText
	push de
	call CopyText
	pop hl
	push de
	ld e, c
	call GetTextSizeInTiles
	add e
	ld c, a
	pop hl
	push hl
.fill_loop
	ld a, $70
	ld [hli], a
	dec c
	jr nz, .fill_loop
	ld [hl], TX_END
	pop hl
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .done
	ld a, [wLoadedCard1Level]
	or a
	jr z, .done
	ld a, TX_SYMBOL
	ld [hli], a
	ld [hl], SYM_Lv
	inc hl
	ld a, [wLoadedCard1Level]
	cp 10
	jr c, .one_digit
	ld [hl], TX_SYMBOL
	inc hl
	ld b, SYM_0 - 1
.first_digit_loop
	inc b
	sub 10
	jr nc, .first_digit_loop
	add 10
	ld [hl], b ; first digit
	inc hl
.one_digit
	ld [hl], TX_SYMBOL
	inc hl
	add SYM_0
	ld [hl], a ; last (or only) digit
	inc hl
.done
	pop de
	pop bc
	ret
; 0x18086

Func_18086: ; 18086 (6:4086)
	ld a, [wcd9b]
	inc a
	add a
	ld b, a
	ld hl, wDefaultText
.find_end_text_loop
	dec b
	ld a, [hli]
	or a ; TX_END
	jr nz, .find_end_text_loop
	dec hl
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .level_done
	ld a, [wLoadedCard1Level]
	or a
	jr z, .level_done
	ld c, a
	ld a, " "
	ld [hli], a
	dec b
	ld a, "L"
	ld [hli], a
	dec b
	ld a, "v"
	ld [hli], a
	dec b
	ld a, c
	cp 10
	jr c, .got_level
	push bc
	ld b, "0" - 1
.first_digit_loop
	inc b
	sub 10
	jr nc, .first_digit_loop
	add 10
	ld [hl], b ; first digit
	inc hl
	pop bc
	ld c, a
	dec b
.got_level
	ld a, c
	add "0"
	ld [hli], a ; last (or only) digit
	dec b
.level_done
	push hl
	ld a, " "
.fill_spaces_loop
	ld [hli], a
	dec b
	jr nz, .fill_spaces_loop
	ld [hl], TX_END
	pop hl
	pop de
	pop bc
	ret
; 0x180d5

Func_180d5: ; 180d5 (6:40d5)
	INCROM $180d5, $186f7

INCLUDE "data/effect_commands.asm"

	INCROM $18f9c, $1996e

Func_1996e: ; 1996e (6:596e)
	call EnableSRAM
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ld hl, sCardCollection
	ld bc, $1607
.asm_1997b
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_1997b
	ld a, $5
	ld hl, s0a350
	call Func_199e0
	ld a, $7
	ld hl, s0a3a4
	call Func_199e0
	ld a, $9
	ld hl, s0a3f8
	call Func_199e0
	call EnableSRAM
	ld hl, sCardCollection
	ld a, CARD_NOT_OWNED
.asm_199a2
	ld [hl], a
	inc l
	jr nz, .asm_199a2
	ld hl, sCurrentDuel
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $bb00
	ld c, $10
.asm_199b2
	ld [hl], $0
	ld de, $0010
	add hl, de
	dec c
	jr nz, .asm_199b2
	ld a, $2
	ld [s0a003], a
	ld a, $2
	ld [s0a006], a
	ld [wTextSpeed], a
	xor a
	ld [s0a007], a
	ld [s0a009], a
	ld [s0a004], a
	ld [s0a005], a
	ld [s0a00a], a
	farcall Func_8cf9
	call DisableSRAM
	ret

Func_199e0: ; 199e0 (6:59e0)
	push de
	push bc
	push hl
	call LoadDeck
	jr c, .asm_19a0e
	call Func_19a12
	pop hl
	call EnableSRAM
	push hl
	ld de, wDefaultText
.asm_199f3
	ld a, [de]
	inc de
	ld [hli], a
	or a
	jr nz, .asm_199f3
	pop hl
	push hl
	ld de, $0018
	add hl, de
	ld de, wPlayerDeck
	ld c, $3c
.asm_19a04
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .asm_19a04
	call DisableSRAM
	or a
.asm_19a0e
	pop hl
	pop bc
	pop de
	ret

Func_19a12: ; 19a12 (6:5a12)
	ld hl, wcce9
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDefaultText
	call CopyText
	ret
; 0x19a1f

	INCROM $19a1f, $1a61f

Func_1a61f: ; 1a61f (6:661f)
	push af
	lb de, $38, $9f
	call SetupText
	pop af
	or a
	jr nz, .else
	ld a, $40
	call .legendary_card_text
	ld a, $5f
	call .legendary_card_text
	ld a, $76
	call .legendary_card_text
	ld a, $c1
.legendary_card_text
	ldtx hl, ReceivedLegendaryCardText
	jr .print_text
.else
	ldtx hl, ReceivedCardText
	cp $1e
	jr z, .print_text
	cp $43
	jr z, .print_text
	ldtx hl, ReceivedPromotionalFlyingPikachuText
	cp $64
	jr z, .print_text
	ldtx hl, ReceivedPromotionalSurfingPikachuText
	cp $65
	jr z, .print_text
	cp $66
	jr z, .print_text
	ldtx hl, ReceivedPromotionalCardText
.print_text
	push hl
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer1_FromCardID
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bank1call LoadTxRam2 ; switch to bank 1, but call a home func
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	pop hl
	bank1call _DisplayCardDetailScreen
.loop
	call AssertSongFinished
	or a
	jr nz, .loop

	call ResumeSong
	bank1call OpenCardPage_FromHand
	ret
; 0x1a68d

Func_006_668d:
	ld a, $c2 ; player's turn
	ldh [hWhoseTurn], a
	ld h, a
	ld l, $00
.asm_006_6694
	xor a
	ld [hli], a
	ld a, l
	cp $3c
	jr c, .asm_006_6694
	xor a
	ld hl, wBoosterCardsDrawn
	ld de, wDuelTempList
	ld c, $00
.asm_006_66a4
	ld a, [hli]
	or a
	jr z, .asm_006_66ae
	ld a, c
	ld [de], a
	inc de
	inc c
	jr .asm_006_66a4
.asm_006_66ae
	ld a, $ff
	ld [de], a
	lb de, $38, $9f
	call SetupText
    bank1call InitAndDrawCardListScreenLayout
	ld hl, $0056
	ld de, $0196
	bank1call SetCardListHeaderText
	ld a, A_BUTTON | START
	ld [wNoItemSelectionMenuKeys], a
    bank1call DisplayCardList
    ret

CommentedOut_1a6cc: ; 1a6cc (6:66cc)
	ret

Func_006_66cd: ; (6:66cd)
	ldh a, [hBankSRAM]
	or a
	ret nz
	push hl
	push de
	push bc
	ld hl, sCardCollection
	ld bc, $0250
	ld a, [s0a000 + $b]
	ld e, a
.asm_006_66de
	ld a, [hli]
	xor e
	ld e, a
	dec bc
	ld a, c
	or b
	jr nz, .asm_006_66de
	ld a, e
	pop bc
	pop de
	pop hl
	or a
	ret z
	xor a
	ld [wTileMapFill], a
	ld hl, wDoFrameFunction
	ld [hli], a
	ld [hl], a
	ldh [hSCX], a
	ldh [hSCY], a
	bank1call ZeroObjectPositionsAndToggleOAMCopy
	call EmptyScreen
	call LoadSymbolsFont
	bank1call SetDefaultPalettes
	ld a, [wConsole]
	cp $01
	jr nz, .asm_006_6719
	ld a, $e4
	ld [wOBP0], a
	ld [wBGP], a
	ld a, $01
	ld [wFlushPaletteFlags], a
.asm_006_6719
	lb de, $38, $9f
	call SetupText
	ld hl, $00a3
	bank1call Func_57df
	ld a, $0a
	ld [$0000], a
	xor a
	ldh [hBankSRAM], a
	ld [$4000], a
	ld [$a000], a
	ld [$0000], a
	jp Reset
	ret

Func_006_673a: ; (6:673a)
	ldh a, [hBankSRAM]
	or a
	ret nz
	push hl
	push de
	push bc
	ld hl, sCardCollection
	ld bc, $0250
	ld e, $00
.asm_006_6749
	ld a, [hli]
	xor e
	ld e, a
	dec bc
	ld a, c
	or b
	jr nz, .asm_006_6749
	ld a, $0a
	ld [$0000], a
	ld a, e
	ld [s0a00b], a
	pop bc
	pop de
	pop hl
	ret

WhatIsYourNameData: ; (6:675e)
	textitem 1, 1, WhatIsYourNameText
	db $ff
; [Deck1Data ~ Deck4Data]
; These are directed from (2:4f05),
; without any bank description.
; That is, the developers hard-coded it. -_-;;
Deck1Data: ; (6:6763)
	textitem 2, 1, Text022b
	textitem 14, 1, Text0219
	db $ff
Deck2Data: ; (6:676c)
	textitem 2, 1, Text022c
	textitem 14, 1, Text0219
	db $ff
Deck3Data: ; (6:6775)
	textitem 2, 1, Text022d
	textitem 14, 1, Text0219
	db $ff
Deck4Data: ; (6:677e)
	textitem 2, 1, Text022e
	textitem 14, 1, Text0219
	db $ff

; set each byte zero from hl for b bytes
ClearMemory: ; (6:6787)
	push af
	push bc
	push hl
	ld b, a
	xor a
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	pop hl
	pop bc
	pop af
	ret

; play different sfx by a.
PlaySFXByA: ; (6:6794)
	push af
	inc a
	jr z, .asm_006_679c
	ld a, $02
	jr .asm_006_679e
.asm_006_679c
	ld a, $03
.asm_006_679e
	call PlaySFX
	pop af
	ret

; get player name from the user
; into hl
InputPlayerName: ; (6:67a3)
	ld e, l
	ld d, h
	ld a, $0c
	ld hl, WhatIsYourNameData
	lb bc, $0c, $01
	call InitializeInputName
	call Set_OBJ_8x8
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont
	lb de, $38, $bf
	call SetupText
	call SetVram0xFF
	ld a, $02
	ld [wd009], a
	call DrawNamingScreenBG
	xor a
	ld [wNamingScreenCursorX], a
	ld [wNamingScreenCursorY], a
	ld a, $09
	ld [wd005], a
	ld a, $06
	ld [wNamingScreenKeyboardHeight], a
	ld a, $0f
	ld [wceaa], a
	ld a, $00
	ld [wceab], a
.loop
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call UpdateRNGSources
	ldh a, [hDPadHeld]
	and START
	jr z, .else
	; if pressed start button.
	ld a, $01
	call PlaySFXByA
	call Func_006_6a07
	ld a, $06
	ld [wNamingScreenCursorX], a
	ld a, $05
	ld [wNamingScreenCursorY], a
	call Func_006_6a23
	jr .loop
.else
	call NamingScreen_CheckButtonState
	jr nc, .loop ; if not pressed, go back to the loop.
	cp $ff
	jr z, .on_b_button
	; on A button.
	call NamingScreen_ProcessInput
	jr nc, .loop
	; if the player selected the end button,
	; end its naming.
	call FinalizeInputName
	ret
.on_b_button
	; erase one character.
	ld a, [wNamingScreenBufferLength]
	or a
	jr z, .loop
	ld e, a
	ld d, $00
	ld hl, wNamingScreenBuffer
	add hl, de
	dec hl
	dec hl
	ld [hl], $00
	ld hl, wNamingScreenBufferLength
	dec [hl]
	dec [hl]
	call PrintPlayerNameFromInput
	jr .loop
	
; it's called when naming(either player's or deck's) starts.
; a: maximum length of name.
; de: dest. pointer.
; hl: pointer to text item of the question.
InitializeInputName:
	ld [wNamingScreenBufferMaxLength], a
	push hl
	ld hl, wd007
	ld [hl], b
	inc hl
	ld [hl], c
	pop hl
	ld b, h
	ld c, l
	; set the question string.
	ld hl, wNamingScreenQuestionPointer
	ld [hl], c
	inc hl
	ld [hl], b
	; set the destination buffer.
	ld hl, wNamingScreenDestPointer
	ld [hl], e
	inc hl
	ld [hl], d
	; clear the name buffer.
	ld a, $18
	ld hl, wNamingScreenBuffer
	call ClearMemory
	ld hl, wNamingScreenBuffer
	ld a, [wNamingScreenBufferMaxLength]
	ld b, a
	inc b
.loop
	; copy data from de to hl
	; for b bytes.
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .loop
	ld hl, wNamingScreenBuffer
	call GetTextSizeInTiles
	ld a, c
	ld [wNamingScreenBufferLength], a
	ret

FinalizeInputName:
	ld hl, wNamingScreenDestPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld l, e
	ld h, d
	ld de, wNamingScreenBuffer
	ld a, [wNamingScreenBufferMaxLength]
	ld b, a
	inc b
	jr InitializeInputName.loop

; draws the keyboard frame
; and the question if it exists.
DrawNamingScreenBG:
	call DrawTextboxForKeyboard
	call PrintPlayerNameFromInput
	ld hl, wNamingScreenQuestionPointer
	ld c, [hl]
	inc hl
	ld a, [hl]
	ld h, a
	or c
	jr z, .put_text_end
	; print the question string.
	; ex) "What is your name?"
	ld l, c
	call PlaceTextItems
.put_text_end
	; print "End".
	ld hl, .data
	call PlaceTextItems
	ld hl, $0221
	ld de, $0204
	call InitTextPrinting
	call ProcessTextFromID
	call EnableLCD
	ret
.data
	textitem $0f, $10, EndText ; "End"
	db $ff

DrawTextboxForKeyboard:
	ld de, $0003 ; x, y
	ld bc, $140f ; w, h
	call DrawRegularTextBox
	ret

PrintPlayerNameFromInput:
	ld hl, wd007
	ld d, [hl]
	inc hl
	ld e, [hl]
	push de
	call InitTextPrinting
	ld a, [wNamingScreenBufferMaxLength]
	ld e, a
	ld a, $14
	sub e
	inc a
	ld e, a
	ld d, $00
	; print the underbars
	; before print the input.
	ld hl, .char_underbar
	add hl, de
	call ProcessText
	pop de
	call InitTextPrinting
	; print the input from the user.
	ld hl, wNamingScreenBuffer
	call ProcessText
	ret
.char_underbar
	db $56
rept 10
	textfw3 "_"
endr
    db $00 ; null

; check if button pressed.
; if pressed, set the carry bit on.
NamingScreen_CheckButtonState:
	xor a
	ld [wcfe3], a
	ldh a, [hDPadHeld]
	or a
	jp z, .no_press
	; detected any button press.
	ld b, a
	ld a, [wNamingScreenKeyboardHeight]
	ld c, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	bit D_UP_F, b
	jr z, .asm_006_692c
	; up
	dec a
	bit D_DOWN_F, a
	jr z, .asm_006_69a7
	ld a, c
	dec a
	jr .asm_006_69a7
.asm_006_692c
	bit D_DOWN_F, b
	jr z, .asm_006_6937
	; down
	inc a
	cp c
	jr c, .asm_006_69a7
	xor a
	jr .asm_006_69a7
.asm_006_6937
	ld a, [wd005]
	ld c, a
	ld a, h
	bit D_LEFT_F, b
	jr z, .asm_006_6974
	; left
	ld d, a
	ld a, $06
	cp l
	ld a, d
	jr nz, .asm_006_696b
	push hl
	push bc
	push af
	call GetCharacterInfoFromCursorPos
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	dec a
	ld d, a
	pop af
	pop bc
	pop hl
	sub d
	cp $ff
	jr nz, .asm_006_6962
	ld a, c
	sub $02
	jr .asm_006_69aa
.asm_006_6962
	cp $fe
	jr nz, .asm_006_696b
	ld a, c
	sub $03
	jr .asm_006_69aa
.asm_006_696b
	dec a
	bit D_DOWN_F, a
	jr z, .asm_006_69aa
	ld a, c
	dec a
	jr .asm_006_69aa
.asm_006_6974
	bit D_RIGHT_F, b
	jr z, .no_press
	ld d, a
	ld a, $06
	cp l
	ld a, d
	jr nz, .asm_006_6990
	push hl
	push bc
	push af
	call GetCharacterInfoFromCursorPos
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	dec a
	ld d, a
	pop af
	pop bc
	pop hl
	add d
.asm_006_6990
	inc a
	cp c
	jr c, .asm_006_69aa
	inc c
	cp c
	jr c, .asm_006_69a4
	inc c
	cp c
	jr c, .asm_006_69a0
	ld a, $02
	jr .asm_006_69aa
.asm_006_69a0
	ld a, $01
	jr .asm_006_69aa
.asm_006_69a4
	xor a
	jr .asm_006_69aa
.asm_006_69a7
	ld l, a
	jr .asm_006_69ab
.asm_006_69aa
	ld h, a
.asm_006_69ab
	push hl
	call GetCharacterInfoFromCursorPos
	inc hl
	inc hl
	inc hl
	ld a, [wd009]
	cp $02
	jr nz, .asm_006_69bb
	inc hl
	inc hl
.asm_006_69bb
	ld d, [hl]
	push de
	call Func_006_6a07
	pop de
	pop hl
	ld a, l
	ld [wNamingScreenCursorY], a
	ld a, h
	ld [wNamingScreenCursorX], a
	xor a
	ld [wcea3], a
	ld a, $06
	cp d
	jp z, NamingScreen_CheckButtonState
	ld a, $01
	ld [wcfe3], a
.no_press
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .asm_006_69ef
	and A_BUTTON
	jr nz, .asm_006_69e5
	ld a, $ff
.asm_006_69e5
	call PlaySFXByA
	push af
	call Func_006_6a23
	pop af
	scf
	ret
.asm_006_69ef
	ld a, [wcfe3]
	or a
	jr z, .asm_006_69f8
	call PlaySFX
.asm_006_69f8
	ld hl, wcea3
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	ld a, [wceaa]
	bit 4, [hl]
	jr z, Func_006_6a07.asm_006_6a0a

Func_006_6a07:
	ld a, [wceab]
.asm_006_6a0a
	ld e, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call GetCharacterInfoFromCursorPos
	ld a, [hli]
	ld c, a
	ld b, [hl]
	dec b
	ld a, e
	call Func_006_6a28
	call WriteByteToBGMap0
	or a
	ret

Func_006_6a23:
	ld a, [wceaa]
	jr Func_006_6a07.asm_006_6a0a

Func_006_6a28:
	push af
	push bc
	push de
	push hl
	push af
	call ZeroObjectPositions
	pop af
	ld b, a
	ld a, [wceab]
	cp b
	jr z, .asm_006_6a60
	ld a, [wNamingScreenBufferLength]
	srl a
	ld d, a
	ld a, [wNamingScreenBufferMaxLength]
	srl a
	ld e, a
	ld a, d
	cp e
	jr nz, .asm_006_6a49
	dec a
.asm_006_6a49
	ld hl, wd007
	add [hl]
	ld d, a
	ld h, $08
	ld l, d
	call HtimesL
	ld a, l
	add $08
	ld d, a
	ld e, $18
	ld bc, $0000
	call SetOneObjectAttributes
.asm_006_6a60
	pop hl
	pop de
	pop bc
	pop af
	ret

SetVram0xFF:
	ld hl, v0Tiles0
	ld de, .data
	ld b, $00
.loop
	; copy data from de to hl
	; for 0x10 bytes.
	; and de has all of 0xff data,
	; which means that it puts only 0xff.
	ld a, $10
	cp b
	ret z
	inc b
	ld a, [de]
	inc de
	ld [hli], a
	jr .loop
.data
rept $6a87-$6a77
	db $ff
endr

; set the carry bit on if "End" was selected.
NamingScreen_ProcessInput:
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call GetCharacterInfoFromCursorPos
	inc hl
	inc hl
	ld e, [hl]
	inc hl
	ld a, [hli]
	ld d, a
	cp $09
	jp z, .on_end
	cp $07
	jr nz, .asm_006_6ab8
	ld a, [wd009]
	or a
	jr nz, .asm_006_6aac
	ld a, $01
	jp .asm_006_6ace
.asm_006_6aac
	dec a
	jr nz, .asm_006_6ab4
	ld a, $02
	jp .asm_006_6ace
.asm_006_6ab4
	xor a
	jp .asm_006_6ace
.asm_006_6ab8
	cp $08
	jr nz, .asm_006_6ad6
	ld a, [wd009]
	or a
	jr nz, .asm_006_6ac6
	ld a, $02
	jr .asm_006_6ace
.asm_006_6ac6
	dec a
	jr nz, .asm_006_6acc
	xor a
	jr .asm_006_6ace
.asm_006_6acc
	ld a, $01
.asm_006_6ace
	ld [wd009], a
	call DrawNamingScreenBG
	or a
	ret
.asm_006_6ad6
	ld a, [wd009]
	cp $02
	jr z, .read_char
	ld bc, $0359
	ld a, d
	cp b
	jr nz, .asm_006_6af4
	ld a, e
	cp c
	jr nz, .asm_006_6af4
	push hl
	ld hl, KeyboardData + ($6cf9 - $6baf)
	call Func_006_6b61
	pop hl
	jr c, .asm_006_6b5d
	jr .asm_006_6b09
.asm_006_6af4
	ld bc, $035b
	ld a, d
	cp b
	jr nz, .asm_006_6b1d
	ld a, e
	cp c
	jr nz, .asm_006_6b1d
	push hl
	ld hl, KeyboardData + ($6d5f - $6baf)
	call Func_006_6b61
	pop hl
	jr c, .asm_006_6b5d
.asm_006_6b09
	ld a, [wNamingScreenBufferLength]
	dec a
	dec a
	ld [wNamingScreenBufferLength], a
	ld hl, wNamingScreenBuffer
	push de
	ld d, $00
	ld e, a
	add hl, de
	pop de
	ld a, [hl]
	jr .asm_006_6b37
.asm_006_6b1d
	ld a, d
	or a
	jr nz, .asm_006_6b37
	ld a, [wd009]
	or a
	jr nz, .asm_006_6b2b
	ld a, $0e
	jr .asm_006_6b37
.asm_006_6b2b
	ld a, $0f
	jr .asm_006_6b37
; read character code from info. to register.
; hl: pointer.
.read_char
	ld e, [hl]
	inc hl
	ld a, [hl] ; a: first byte of the code.
	or a
	; if 2 bytes code, jump.
	jr nz, .asm_006_6b37
	; if 1 byte code(ascii),
	; set first byte to $0e.
	ld a, $0e
; on 2 bytes code.
.asm_006_6b37
	ld d, a ; de: character code.
	ld hl, wNamingScreenBufferLength
	ld a, [hl]
	ld c, a
	push hl
	ld hl, wNamingScreenBufferMaxLength
	cp [hl]
	pop hl
	jr nz, .asm_006_6b4c
	; if the buffer is full
	; just change the last character of it.
	ld hl, wNamingScreenBuffer
	dec hl
	dec hl
	jr .asm_006_6b51
; increase name length before add the character.
.asm_006_6b4c
	inc [hl]
	inc [hl]
	ld hl, wNamingScreenBuffer
; write 2 bytes character codes to the name buffer.
; de: 2 bytes character codes.
; hl: dest.
.asm_006_6b51
	ld b, $00
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], $00 ; null terminator.
	call PrintPlayerNameFromInput
.asm_006_6b5d
	or a
	ret
.on_end
	scf
	ret

Func_006_6b61:
	ld a, [wNamingScreenBufferLength]
	or a
	jr z, .asm_006_6b91
	dec a
	dec a
	push hl
	ld hl, wNamingScreenBuffer
	ld d, $00
	ld e, a
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, $0f
	cp e
	jr nz, .asm_006_6b7a
	dec e
.asm_006_6b7a
	pop hl
.asm_006_6b7b
	ld a, [hli]
	or a
	jr z, .asm_006_6b91
	cp d
	jr nz, .asm_006_6b8c
	ld a, [hl]
	cp e
	jr nz, .asm_006_6b8c
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	or a
	ret
.asm_006_6b8c
	inc hl
	inc hl
	inc hl
	jr .asm_006_6b7b
.asm_006_6b91
	scf
	ret

; given the position of the current cursor,
; it returns the pointer to the proper information.
; h: position x.
; l: position y.
GetCharacterInfoFromCursorPos:
	push de
	; (information index) = (x) * (height) + (y)
	; (height) = 0x05(Deck) or 0x06(Player)
	ld e, l
	ld d, h
	ld a, [wNamingScreenKeyboardHeight]
	ld l, a
	call HtimesL
	ld a, l
	add e
	ld hl, KeyboardData
	pop de
	or a
	ret z
.loop
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	dec a
	jr nz, .loop
	ret

; a set of keyboard datum.
; unit: 6 bytes.
; structure:
; unk 1 (1) / unk 2 (1) / type 1 (1) / type 2 (1) / character (2)
; - some of one byte characters have 0x0e in their high byte.
; - unused data contains its character code as zero.
KeyboardData: ; (6:6baf)
	kbitem $04, $02, $11, $00, $0330
	kbitem $06, $02, $12, $00, $0339
	kbitem $08, $02, $13, $00, $0342
	kbitem $0a, $02, $14, $00, $006f
	kbitem $0c, $02, $15, $00, $0064
	kbitem $10, $0f, $01, $09, $0000
	kbitem $04, $04, $16, $00, $0331
	kbitem $06, $04, $17, $00, $033a
	kbitem $08, $04, $18, $00, $0343
	kbitem $0a, $04, $19, $00, $035d
	kbitem $0c, $04, $1a, $00, $0065
	kbitem $10, $0f, $01, $09, $0000
	kbitem $04, $06, $1b, $00, $0332
	kbitem $06, $06, $1c, $00, $033b
	kbitem $08, $06, $1d, $00, $0344
	kbitem $0a, $06, $1e, $00, $006a
	kbitem $0c, $06, $1f, $00, $0066
	kbitem $10, $0f, $01, $09, $0000
	kbitem $04, $08, $20, $00, $0333
	kbitem $06, $08, $21, $00, $033c
	kbitem $08, $08, $22, $00, $0345
	kbitem $0a, $08, $23, $00, $006b
	kbitem $0c, $08, $24, $00, $0067
	kbitem $10, $0f, $01, $09, $0000
	kbitem $04, $0a, $25, $00, $0334
	kbitem $06, $0a, $26, $00, $033d
	kbitem $08, $0a, $27, $00, $0346
	kbitem $0a, $0a, $28, $00, $0077
	kbitem $0c, $0a, $29, $00, $0068
	kbitem $10, $0f, $01, $09, $0000
	kbitem $04, $0c, $2a, $00, $0335
	kbitem $06, $0c, $2b, $00, $033e
	kbitem $08, $0c, $2c, $00, $0347
	kbitem $0a, $0c, $2d, $00, $0060
	kbitem $0c, $0c, $2e, $00, $0069
	kbitem $10, $0f, $01, $09, $0000
	kbitem $04, $0e, $2f, $00, $0336
	kbitem $06, $0e, $30, $00, $033f
	kbitem $08, $0e, $31, $00, $0348
	kbitem $0a, $0e, $32, $00, $0061
	kbitem $0c, $0e, $33, $00, $0513
	kbitem $10, $0f, $01, $09, $0000
	kbitem $04, $10, $34, $00, $0337
	kbitem $06, $10, $35, $00, $0340
	kbitem $08, $10, $36, $00, $0349
	kbitem $0a, $10, $3c, $00, $0062
	kbitem $0c, $10, $3d, $00, $0511
	kbitem $10, $0f, $01, $09, $0000
	kbitem $04, $12, $37, $00, $0338
	kbitem $06, $12, $38, $00, $0341
	kbitem $08, $12, $39, $00, $006e
	kbitem $0a, $12, $3a, $00, $0063
	kbitem $0c, $12, $3b, $00, $0070
	kbitem $10, $0f, $01, $09, $0000
	kbitem $00, $00, $00, $00, $0000
	kbitem $16, $0e, $3e, $00, $0e17
	kbitem $3f, $00, $18, $0e, $0040
	kbitem $19, $0e, $41, $00, $0e1a
	kbitem $42, $00, $1b, $0e, $0043
	kbitem $1c, $0e, $44, $00, $0e1d
	kbitem $45, $00, $1e, $0e, $0046
	kbitem $1f, $0e, $47, $00, $0e20
	kbitem $48, $00, $21, $0e, $0049
	kbitem $22, $0e, $4a, $00, $0e23
	kbitem $4b, $00, $24, $0e, $004c
	kbitem $2a, $0e, $4d, $00, $0e2b
	kbitem $4e, $00, $2c, $0e, $004f
	kbitem $2d, $0e, $50, $00, $0e2e
	kbitem $51, $00, $52, $0e, $004d
	kbitem $53, $0e, $4e, $00, $0e54
	kbitem $4f, $00, $55, $0e, $0050
	kbitem $56, $0e, $51, $00, $0000
	kbitem $2a, $0e, $52, $00, $0e2b
	kbitem $53, $00, $2c, $0e, $0054
	kbitem $2d, $0e, $55, $00, $0e2e
	kbitem $56, $00, $4d, $0e, $0052
	kbitem $4e, $0e, $53, $00, $0e4f
	kbitem $54, $00, $50, $0e, $0055
	kbitem $51, $0e, $56, $00, $0000

; get deck name from the user
; into de.
InputDeckName: ; 1ad89 (6:6d89)
	push af
	ld a, [de]
	or a
	jr nz, .asm_006_6d91
	ld a, $06
	ld [de], a
.asm_006_6d91
	pop af
	inc a
	call InitializeInputName
	call Set_OBJ_8x8
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont
	lb de, $38, $bf
	call SetupText
	call FillVramWith0xF0
	xor a
	ld [wd009], a
	call Func_006_6e99
	xor a
	ld [wNamingScreenCursorX], a
	ld [wNamingScreenCursorY], a
	ld a, $09
	ld [wd005], a
	ld a, $07
	ld [wNamingScreenKeyboardHeight], a
	ld a, $0f
	ld [wceaa], a
	ld a, $00
	ld [wceab], a
.asm_006_6dd6
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call UpdateRNGSources
	ldh a, [hDPadHeld]
	and START
	jr z, .on_start
	ld a, $01
	call PlaySFXByA
	call Func_006_6fa1
	ld a, $06
	ld [wNamingScreenCursorX], a
	ld [wNamingScreenCursorY], a
	call Func_006_6fbd
	jr .asm_006_6dd6
.on_start
	call Func_006_6efb
	jr nc, .asm_006_6dd6
	cp $ff
	jr z, .asm_006_6e1c
	call Func_006_6ec3
	jr nc, .asm_006_6dd6
	call FinalizeInputName
	ld hl, wNamingScreenDestPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld a, [hl]
	or a
	jr nz, .asm_006_6e1b
	dec hl
	ld [hl], $00
.asm_006_6e1b
	ret
.asm_006_6e1c
	ld a, [wNamingScreenBufferLength]
	cp $02
	jr c, .asm_006_6dd6
	ld e, a
	ld d, $00
	ld hl, wNamingScreenBuffer
	add hl, de
	dec hl
	ld [hl], $00
	ld hl, wNamingScreenBufferLength
	dec [hl]
	call Func_006_6e59
	jp .asm_006_6dd6

; fill v0Tiles0 for 0x10 tiles
; with 0xF0.
FillVramWith0xF0:
	ld hl, v0Tiles0
	ld de, .data
	ld b, $00
.asm_006_6e3f
	ld a, $10
	cp b
	ret z
	inc b
	ld a, [de]
	inc de
	ld [hli], a
	jr .asm_006_6e3f
.data
rept $10
    db $f0
endr

Func_006_6e59:
	ld hl, wd007
	ld d, [hl]
	inc hl
	ld e, [hl]
	call InitTextPrinting
	ld hl, .data
	ld de, wDefaultText
.asm_006_6e68
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, .asm_006_6e68
	ld hl, wNamingScreenBuffer
	ld de, wDefaultText
.asm_006_6e74
	ld a, [hli]
	or a
	jr z, .asm_006_6e7c
	ld [de], a
	inc de
	jr .asm_006_6e74
.asm_006_6e7c
	ld hl, wDefaultText
	call ProcessText
	ret
.data
	db $06
rept $14
	db $5f
endr
	db $00

Func_006_6e99:
	call DrawTextboxForKeyboard
	call Func_006_6e59
	ld hl, wNamingScreenQuestionPointer
	ld c, [hl]
	inc hl
	ld a, [hl]
	ld h, a
	or c
	jr z, .print
	; print the question string.
	ld l, c
	call PlaceTextItems
.print
	; print "End"
	ld hl, DrawNamingScreenBG.data
	call PlaceTextItems
	; print the keyboard characters.
	ldtx hl, NamingScreenKeyboardText ; "A B C D..."
	ld de, $0204
	call InitTextPrinting
	call ProcessTextFromID
	call EnableLCD
	ret

Func_006_6ec3:
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call Func_006_7000
	inc hl
	inc hl
	ld a, [hl]
	cp $01
	jr nz, .asm_006_6ed7
	scf
	ret
.asm_006_6ed7
	ld d, a
	ld hl, wNamingScreenBufferLength
	ld a, [hl]
	ld c, a
	push hl
	ld hl, wNamingScreenBufferMaxLength
	cp [hl]
	pop hl
	jr nz, .asm_006_6eeb
	ld hl, wNamingScreenBuffer
	dec hl
	jr .asm_006_6eef
.asm_006_6eeb
	inc [hl]
	ld hl, wNamingScreenBuffer
.asm_006_6eef
	ld b, $00
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], $00
	call Func_006_6e59
	or a
	ret

Func_006_6efb:
	xor a
	ld [wcfe3], a
	ldh a, [hDPadHeld]
	or a
	jp z, .asm_006_6f73
	ld b, a
	ld a, [wNamingScreenKeyboardHeight]
	ld c, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	bit 6, b
	jr z, .asm_006_6f1f
	dec a
	bit 7, a
	jr z, .asm_006_6f4b
	ld a, c
	dec a
	jr .asm_006_6f4b
.asm_006_6f1f
	bit 7, b
	jr z, .asm_006_6f2a
	inc a
	cp c
	jr c, .asm_006_6f4b
	xor a
	jr .asm_006_6f4b
.asm_006_6f2a
	cp $06
	jr z, .asm_006_6f73
	ld a, [wd005]
	ld c, a
	ld a, h
	bit 5, b
	jr z, .asm_006_6f40
	dec a
	bit 7, a
	jr z, .asm_006_6f4e
	ld a, c
	dec a
	jr .asm_006_6f4e
.asm_006_6f40
	bit 4, b
	jr z, .asm_006_6f73
	inc a
	cp c
	jr c, .asm_006_6f4e
	xor a
	jr .asm_006_6f4e
.asm_006_6f4b
	ld l, a
	jr .asm_006_6f4f
.asm_006_6f4e
	ld h, a
.asm_006_6f4f
	push hl
	call Func_006_7000
	inc hl
	inc hl
	ld d, [hl]
	push de
	call Func_006_6fa1
	pop de
	pop hl
	ld a, l
	ld [wNamingScreenCursorY], a
	ld a, h
	ld [wNamingScreenCursorX], a
	xor a
	ld [wcea3], a
	ld a, $02
	cp d
	jp z, Func_006_6efb
	ld a, $01
	ld [wcfe3], a
.asm_006_6f73
	ldh a, [hKeysPressed]
	and $03
	jr z, .asm_006_6f89
	and $01
	jr nz, .asm_006_6f7f
	ld a, $ff
.asm_006_6f7f
	call PlaySFXByA
	push af
	call Func_006_6fbd
	pop af
	scf
	ret
.asm_006_6f89
	ld a, [wcfe3]
	or a
	jr z, .asm_006_6f92
	call PlaySFX
.asm_006_6f92
	ld hl, wcea3
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	ld a, [wceaa]
	bit 4, [hl]
	jr z, Func_006_6fa1.asm_006_6fa4

Func_006_6fa1:
	ld a, [wceab]
.asm_006_6fa4
	ld e, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call Func_006_7000
	ld a, [hli]
	ld c, a
	ld b, [hl]
	dec b
	ld a, e
	call Func_006_6fc2
	call WriteByteToBGMap0
	or a
	ret

Func_006_6fbd:
	ld a, [wceaa]
	jr Func_006_6fa1.asm_006_6fa4

Func_006_6fc2:
	push af
	push bc
	push de
	push hl
	push af
	call ZeroObjectPositions
	pop af
	ld b, a
	ld a, [wceab]
	cp b
	jr z, .asm_006_6ffb
	ld a, [wNamingScreenBufferLength]
	ld d, a
	ld a, [wNamingScreenBufferMaxLength]
	ld e, a
	ld a, d
	cp e
	jr nz, .asm_006_6fdf
	dec a
.asm_006_6fdf
	dec a
	ld d, a
	ld hl, wd007
	ld a, [hl]
	sla a
	add d
	ld d, a
	ld h, $04
	ld l, d
	call HtimesL
	ld a, l
	add $08
	ld d, a
	ld e, $18
	ld bc, $0000
	call SetOneObjectAttributes
.asm_006_6ffb
	pop hl
	pop de
	pop bc
	pop af
	ret

Func_006_7000:
	push de
	ld e, l
	ld d, h
	ld a, [wNamingScreenKeyboardHeight]
	ld l, a
	call HtimesL
	ld a, l
	add e
	ld hl, Unknown_006_7019
	pop de
	or a
	ret z
.asm_006_7012
	inc hl
	inc hl
	inc hl
	dec a
	jr nz, .asm_006_7012
	ret

; a bunch of data
Unknown_006_7019: ; (6:7019)
    INCROM $1b019, $1b8e8
	INCROM $1b8e8, $1ba12

Func_006_7a12: ; (6:7a12)
	push af
	ld [bc], a
	call EnableSRAM
	ld a, [wd0a9]
	ld l, a
	ld h, $1e
	call HtimesL
	ld bc, $78e8
	add hl, bc
	ld b, $00
.asm_006_7a26
	call Func_006_7a4c
	call Func_006_7a5b
	call Func_006_7a7d
	push hl
	ld de, wd0aa
	ld h, b
	ld l, $02
	call HtimesL
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc b
	ld a, b
	cp $05
	jr nz, .asm_006_7a26
	call DisableSRAM
	ret

Func_006_7a4c:
	push hl
	ld l, b
	ld h, $54
	call HtimesL
	ld de, s0a350
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ret

Func_006_7a5b:
	push hl
	push bc
	push de
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ld bc, $0018
	add hl, bc
.asm_006_7a67
	ld a, [de]
	inc de
	ld b, a
	or a
	jr z, .asm_006_7a77
	ld a, [de]
	inc de
	ld c, a
.asm_006_7a70
	ld [hl], c
	inc hl
	dec b
	jr nz, .asm_006_7a70
	jr .asm_006_7a67
.asm_006_7a77
	pop de
	pop bc
	pop hl
	inc hl
	inc hl
	ret

Func_006_7a7d:
	push hl
	push bc
	push de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wd089
	call CopyText
	pop hl
	ld de, wd089
.asm_006_7a8d
	ld a, [de]
	ld [hli], a
	or a
	jr z, .asm_006_7a95
	inc de
	jr .asm_006_7a8d
.asm_006_7a95
	pop bc
	pop hl
	inc hl
	inc hl
	ret

; pointed from 0xb87e: [06|9A|7A]
Func_006_7a9a: ; (6:7a9a)
	xor a
	ld [wd0a6], a
	ld a, $01
.asm_006_7aa0
	call Func_006_7ae4
	ret nc
	sla a
	cp $10
	jr z, .asm_006_7aac
	jr .asm_006_7aa0
.asm_006_7aac
	ld a, $03
	call Func_006_7ae4
	ret nc
	ld a, $05
	call Func_006_7ae4
	ret nc
	ld a, $09
	call Func_006_7ae4
	ret nc
	ld a, $06
	call Func_006_7ae4
	ret nc
	ld a, $0a
	call Func_006_7ae4
	ret nc
	ld a, $0c
	call Func_006_7ae4
	ret nc
	ld a, $f7
.asm_006_7ad2
	call Func_006_7ae4
	ret nc
	sra a
	cp $ff
	jr z, .asm_006_7ade
	jr .asm_006_7ad2
.asm_006_7ade
	call Func_006_7ae4
	ret nc
	scf
	ret

Func_006_7ae4:
	push af
	ld hl, wd088
	ld b, [hl]
	farcall $2, $7625
	jr c, .asm_006_7af5
	pop af
	ld [wd0a6], a
	or a
	ret
.asm_006_7af5
	pop af
	scf
	ret

rept $508
	db $ff
endr