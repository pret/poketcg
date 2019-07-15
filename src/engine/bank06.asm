; copy the name and level of the card at wLoadedCard1 to wDefaultText
; a = length in number of tiles (the resulting string will be padded with spaces to match it)
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
	jp z, _CopyCardNameAndLevel_HalfwidthText

; the name doesn't start with TX_HALFWIDTH
; this doesn't appear to be ever the case (unless caller manipulates wLoadedCard1Name)
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
	call GetTextLengthInTiles
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

; the name starts with TX_HALFWIDTH
_CopyCardNameAndLevel_HalfwidthText:
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

; this function is called when the player is shown the appearance of the play area.
; it can be called in the command window from either pressing select button
; or selecting check command.
HandlePlayAreaView: ; 180d5 (6:40d5)
	ld a, $05
	ld [wPlayAreaCursorPosition], a
.start
	xor a
	ld [wCheckCommandCounter], a
	farcall $2, $42ce
	call EnableLCD
	call IsClairvoyanceActive
	jr c, .clairvoyance_on

	ld de, PlayAreaViewTransitionTable1
	jr .clairvoyance_off

.clairvoyance_on
	ld de, PlayAreaViewTransitionTable2
.clairvoyance_off
	ld hl, wPlayAreaInputTablePointer
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, [wPlayAreaCursorPosition]
	call PrintCardName_HandlePlayAreaView
.on_frame
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame

	ldh a, [hDPadHeld]
	and START
	jr nz, .selection

	; if this function's been called from 'select' button,
	; wIsFromSelectButton is on.
	ld a, [wIsFromSelectButton]
	or a
	jr z, .handle_input ; if it's from the check command, jump.

	ldh a, [hDPadHeld]
	and SELECT
	jr nz, .toggle_view

.handle_input
	ld a, [wPlayAreaCursorPosition]
	ld [wPlayAreaPreservedPosition_2], a
	call HandleInput_PlayArea
	jr c, .pressed

	ld a, [wPlayAreaCursorPosition]
	cp $10 ; player's hand
	jp z, ShowPlayerHand_HandlePlayAreaView
	cp $11 ; opponent's hand
	jp z, ShowOpponentHand_HandlePlayAreaView

	; check if the cursor moved.
	ld hl, wPlayAreaPreservedPosition_2
	cp [hl]
	call nz, PrintCardName_HandlePlayAreaView
	
	jr .on_frame

.pressed
	cp -1
	jr nz, .selection

	; pressed b button.
	call HandleInput_PlayArea.non_draw_cursor
	lb de, $38, $9f
	call SetupText
	scf
	ret

.toggle_view
	call HandleInput_PlayArea.non_draw_cursor
	lb de, $38, $9f
	call SetupText
	or a
	ret

.selection ; pressed a button or start button.
	call HandleInput_PlayArea.non_draw_cursor
	lb de, $38, $9f
	call SetupText
	ld a, [wPlayAreaCursorPosition]
	ld [wPlayAreaPreservedPosition], a
	ld hl, JumpTable_HandlePlayAreaView
	call JumpToFunctionInTable
	ld a, [wPlayAreaPreservedPosition]
	ld [wPlayAreaCursorPosition], a

	jp .start

PrintCardName_HandlePlayAreaView: ; 18171 (6:4171)
	push af
	lb de, 1, 17
	call InitTextPrinting
	ldtx hl, EmptyLineText
	call ProcessTextFromID

	ld hl, hffb0
	ld [hl], $01
	ldtx hl, HandText_2
	call ProcessTextFromID

	ld hl, hffb0
	ld [hl], $00
	lb de, 1, 17
	call InitTextPrinting
	pop af
	ld hl, TextIDTable_182bb
	ld b, 0
	sla a
	ld c, a
	add hl, bc ; hl = TextIDTable_182bb + 2 * (wPlayAreaCursorPostion)

	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h
	
	or a
	jr nz, .raw_string

	ld a, l
	cp $06
	jr nc, .raw_string

	ld a, [wPlayAreaCursorPosition]
	cp $06
	jr nc, .opponent_side

	ld a, l
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	ret z

	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	jr .display_card_info

.opponent_side
	ld a, l
	add DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	cp -1
	ret z

	call SwapTurn
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	call SwapTurn
.display_card_info
	ld a, 18
	call CopyCardNameAndLevel
	ld hl, wDefaultText
	call ProcessText
	ret

.raw_string
	ld a, [wPlayAreaCursorPosition]
	cp $08
	jr nc, .opponent_side_raw_string
	call PrintTextNoDelay
	ret

.opponent_side_raw_string
	call SwapTurn
	call PrintTextNoDelay
	call SwapTurn
	ret

ShowPlayerHand_HandlePlayAreaView:
	lb de, $38, $9f
	call SetupText
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderPlayAreaScreen
	pop af
	ldh [hWhoseTurn], a
	ld a, [wPlayAreaPreservedPosition]
	ld [wPlayAreaCursorPosition], a
	jp HandlePlayAreaView.start

ShowOpponentHand_HandlePlayAreaView:
	lb de, $38, $9f
	call SetupText
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderPlayAreaScreen
	pop af
	ldh [hWhoseTurn], a
	ld a, [wPlayAreaPreservedPosition]
	ld [wPlayAreaCursorPosition], a
	jp HandlePlayAreaView.start

JumpTable_HandlePlayAreaView ; (6:4228)
	dw ShowPlayerAreaPokemon_HandlePlayAreaView ; 0x00: my bench pokemon 1
	dw ShowPlayerAreaPokemon_HandlePlayAreaView ; 0x01: my bench pokemon 2
	dw ShowPlayerAreaPokemon_HandlePlayAreaView ; 0x02: my bench pokemon 3
	dw ShowPlayerAreaPokemon_HandlePlayAreaView ; 0x03: my bench pokemon 4
	dw ShowPlayerAreaPokemon_HandlePlayAreaView ; 0x04: my bench pokemon 5
	dw ShowPlayerAreaPokemon_HandlePlayAreaView ; 0x05: my active pokemon
	dw ShowPlayerHand_HandlePlayAreaView_2 ; 0x06: my hand
	dw ShowPlayerDiscardPile_HandlePlayAreaView ; 0x07: my discard pile
	
	dw ShowOpponentAreaPokemon_HandlePlayAreaView ; 0x08: opp. active pokemon
	dw ShowOpponentHand_HandlePlayAreaView_2 ; 0x09: opp. hand
	dw ShowOpponentDiscardPile_HandlePlayAreaView ; 0x0a: opp. discard pile
	dw ShowOpponentAreaPokemon_HandlePlayAreaView ; 0x0b: opp. bench pokemon 1
	dw ShowOpponentAreaPokemon_HandlePlayAreaView ; 0x0c: opp. bench pokemon 2
	dw ShowOpponentAreaPokemon_HandlePlayAreaView ; 0x0d: opp. bench pokemon 3
	dw ShowOpponentAreaPokemon_HandlePlayAreaView ; 0x0e: opp. bench pokemon 4
	dw ShowOpponentAreaPokemon_HandlePlayAreaView ; 0x0f: opp. bench pokemon 5

ShowPlayerAreaPokemon_HandlePlayAreaView:
	ld a, [wPlayAreaCursorPosition]
	inc a
	cp $05 + 1 ; $05: my active pokemon
	jr nz, .on_bench
	xor a ; PLAY_AREA_ARENA
.on_bench
	ld [wCurPlayAreaSlot], a
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	ret z
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	xor a
	ld [wCurPlayAreaY], a
	bank1call OpenCardPage_FromCheckPlayArea
	ret

ShowOpponentAreaPokemon_HandlePlayAreaView:
	ld a, [wPlayAreaCursorPosition]
	sub $08
	or a
	jr z, .on_bench
	sub $02
.on_bench
	ld [wCurPlayAreaSlot], a
	add DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	cp -1
	ret z
	call SwapTurn
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	xor a
	ld [wCurPlayAreaY], a
	bank1call OpenCardPage_FromCheckPlayArea
	call SwapTurn
	ret

ShowPlayerHand_HandlePlayAreaView_2:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

ShowOpponentHand_HandlePlayAreaView_2:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

ShowPlayerDiscardPile_HandlePlayAreaView:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderDiscardPileScreen
	pop af
	ldh [hWhoseTurn], a
	ret

ShowOpponentDiscardPile_HandlePlayAreaView:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderDiscardPileScreen
	pop af
	ldh [hWhoseTurn], a
	ret

TextIDTable_182bb:
	tx HandText
	tx CheckText
	tx AttackText
	tx PKMNPowerText
	tx DoneText
	dw NONE
	tx DuelistHandText_2
	tx DuelistDiscardPileText
	dw NONE
	tx DuelistHandText_2
	tx DuelistDiscardPileText
	tx HandText
	tx CheckText
	tx AttackText
	tx PKMNPowerText
	tx DoneText

; it's related to wPlayAreaInputTablePointer.
; with this table, the cursor moves into the proper location by the input.
; note that the unit of the position is not a 8x8 tile.
; idx-[direction] means the index to get when the input is in the direction.
; its attribute is used for drawing a flipped cursor.
PlayAreaViewTransitionTable1:
; cursor x pos. / cursor y pos. / attribute / idx-up / idx-down / idx-right / idx-left
	db $18, $8c, $00, $05, $10, $01, $04
	db $30, $8c, $00, $05, $10, $02, $00
	db $48, $8c, $00, $05, $10, $03, $01
	db $60, $8c, $00, $05, $10, $04, $02
	db $78, $8c, $00, $05, $10, $00, $03
	db $30, $6c, $00, $08, $00, $07, $07
	db $78, $80, $00, $07, $00, $05, $05
	db $78, $70, $00, $08, $06, $05, $05
	db $78, $34, $20, $0b, $05, $0a, $0a
	db $30, $20, $20, $0b, $0a, $08, $08
	db $30, $38, $20, $0b, $05, $08, $08
	db $90, $14, $20, $11, $08, $0f, $0c
	db $78, $14, $20, $11, $08, $0b, $0d
	db $60, $14, $20, $11, $08, $0c, $0e
	db $48, $14, $20, $11, $08, $0d, $0f
	db $30, $14, $20, $11, $08, $0e, $0b

PlayAreaViewTransitionTable2:
; same as 1.
	db $18, $8c, $00, $05, $10, $01, $04
	db $30, $8c, $00, $05, $10, $02, $00
	db $48, $8c, $00, $05, $10, $03, $01
	db $60, $8c, $00, $05, $10, $04, $02
	db $78, $8c, $00, $05, $10, $00, $03
	db $30, $6c, $00, $08, $00, $07, $07
	db $78, $80, $00, $07, $00, $05, $05
	db $78, $70, $00, $08, $06, $05, $05
	db $78, $34, $20, $0b, $05, $0a, $0a
	db $30, $20, $20, $0b, $0a, $08, $08
	db $30, $38, $20, $09, $05, $08, $08
	db $90, $14, $20, $11, $08, $0f, $0c
	db $78, $14, $20, $11, $08, $0b, $0d
	db $60, $14, $20, $11, $08, $0c, $0e
	db $48, $14, $20, $11, $08, $0d, $0f
	db $30, $14, $20, $11, $08, $0e, $0b

HandleInput_PlayArea: ; 183bb (6:43bb)
	xor a
	ld [wcfe3], a
	ld hl, wPlayAreaInputTablePointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wPlayAreaCursorPosition]
	ld l, a
	ld h, $07
	call HtimesL
	add hl, de

	ldh a, [hDPadHeld]
	or a
	jp z, .check_button

	inc hl
	inc hl
	inc hl

	; check d-pad
	bit D_UP_F, a
	jr z, .else_if_down
	
	; up
	ld a, [hl]
	jr .process_dpad

.else_if_down
	inc hl
	bit D_DOWN_F, a
	jr z, .else_if_right
	
	; down
	ld a, [hl]
	jr .process_dpad

.else_if_right
	inc hl
	bit D_RIGHT_F, a
	jr z, .else_if_left
	
	; right
	ld a, [hl]
	jr .process_dpad

.else_if_left
	inc hl
	bit D_LEFT_F, a
	jr z, .check_button

	; left
	ld a, [hl]
.process_dpad
	push af
	ld a, [wPlayAreaCursorPosition]
	ld [wPlayAreaPreservedPosition], a
	pop af

	ld [wPlayAreaCursorPosition], a

	cp $05
	jr c, .player_area
	cp $0b
	jr c, .next
	cp $10
	jr c, .opponent_area

	jr .next

.player_area
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	dec a
	jr nz, .bench_pokemon_exists

	; no pokemon in player's bench.
	; then move to player's hand.
	ld a, $10
	ld [wPlayAreaCursorPosition], a
	jr .next
	
.bench_pokemon_exists
	ld b, a
	ld a, [wPlayAreaCursorPosition]
	cp b
	jr c, .next

	; handle index overflow
	ldh a, [hDPadHeld]
	bit D_RIGHT_F, a
	jr z, .on_left

	xor a
	ld [wPlayAreaCursorPosition], a
	jr .next

.on_left
	ld a, b
	dec a
	ld [wPlayAreaCursorPosition], a
	jr .next

.opponent_area
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	dec a
	jr nz, .bench_pokemon_exists_2

	ld a, $11
	ld [wPlayAreaCursorPosition], a
	jr .next

.bench_pokemon_exists_2
	ld b, a
	ld a, [wPlayAreaCursorPosition]
	sub $0b
	cp b
	jr c, .next

	ldh a, [hDPadHeld]
	bit D_LEFT_F, a
	jr z, .on_right

	ld a, $0b
	ld [wPlayAreaCursorPosition], a
	jr .next

.on_right
	ld a, b
	add $0a
	ld [wPlayAreaCursorPosition], a
.next
	ld a, $01
	ld [wcfe3], a
	xor a
	ld [wCheckCommandCounter], a
.check_button
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .return

	and A_BUTTON
	jr nz, .a_button

	; pressed b button
	ld a, -1
	farcall Func_90fb
	scf
	ret

.a_button
	call .draw_cursor
	ld a, $01
	farcall Func_90fb
	ld a, [wPlayAreaCursorPosition]
	scf
	ret

.return
	ld a, [wcfe3]
	or a
	jr z, .skip_sfx
	call PlaySFX
.skip_sfx
	ld hl, wCheckCommandCounter
	ld a, [hl]
	inc [hl]
	and $10 - 1
	ret nz

	bit 4, [hl] ; = and $10
	jr nz, .non_draw_cursor

.draw_cursor ; 184a0 (6:44a0)
	call ZeroObjectPositions
	ld hl, wPlayAreaInputTablePointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wPlayAreaCursorPosition]
	ld l, a
	ld h, $07
	call HtimesL
	add hl, de
	
	ld d, [hl] ; x position.
	inc hl
	ld e, [hl] ; y position.
	inc hl
	ld b, [hl] ; attribute.
	ld c, $00
	call SetOneObjectAttributes
	or a
	ret

.non_draw_cursor ; 184bf (6:44bf)
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret

Func_006_44c8: ; (6:44c8)
	xor a
	ld [wGlossaryPageNo], a
	call Func_006_452b

	xor a
	ld [wPlayAreaCursorPosition], a
	ld de, $4c8e ; this data is stored in bank 2.
	ld hl, wPlayAreaInputTablePointer
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $ff
	ld [wce55], a
	xor a
	ld [wCheckCommandCounter], a
.next
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	ldh a, [hKeysPressed]
	and SELECT
	jr nz, .on_select

	farcall $2, $49ae
	jr nc, .next
	
	cp -1 ; b button
	jr nz, .check_button

	farcall $2, $4aa1
	ret
	
.check_button
	push af
	farcall $2, $4aa1
	pop af

	cp $09 ; $09: next page or prev page
	jr z, .change_page

	call Func_006_4598
	call Func_006_452b
	xor a
	ld [wCheckCommandCounter], a
	jr .next

.on_select
	ld a, $01
	farcall Func_90fb
.change_page
	ld a, [wGlossaryPageNo]
	xor $01 ; swap page
	ld [wGlossaryPageNo], a
	call Func_006_455a
	jr .next

; display glossary menu.
Func_006_452b: ; 1852b (6:452b)
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call EmptyScreen
	call Set_OBJ_8x8
	farcall $2, $4992

	lb de, 5, 0
	call InitTextPrinting
	ldtx hl, PokemonCardGlossaryText
	call ProcessTextFromID
	call Func_006_455a
	ldtx hl, ChooseWordAndPressAButtonText
	call DrawWideTextBox_PrintText
	ret

; print texts in glossary menu.
Func_006_455a: ; 1855a (6:455a)
	ld hl, wDefaultText

	ld a, TX_SYMBOL
	ld [hli], a

	ld a, [wGlossaryPageNo]
	add SYM_1
	ld [hli], a

	ld a, TX_SYMBOL
	ld [hli], a

	ld a, SYM_SLASH
	ld [hli], a

	ld a, TX_SYMBOL
	ld [hli], a

	ld a, SYM_2
	ld [hli], a

	ld [hl], TX_END

	lb de, 16, 1
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText

	lb de, 1, 3
	call InitTextPrinting
	ld a, [wGlossaryPageNo]
	or a
	jr nz, .page_two

	ldtx hl, GlossaryMenuPage1Text
	jr .page_one

.page_two
	ldtx hl, GlossaryMenuPage2Text
.page_one
	call ProcessTextFromID
	ret

; display glossary description.
Func_006_4598: ; 18598 (6:4598)
	push af
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	lb de, 5, 0
	call InitTextPrinting
	ldtx hl, PokemonCardGlossaryText
	call ProcessTextFromID
	lb de, 0, 4
	lb bc, 20, 14
	call DrawRegularTextBox

	ld a, [wGlossaryPageNo]
	or a
	jr nz, .back_page

	ld hl, GlossaryData_1
	jr .front_page

.back_page
	ld hl, GlossaryData_2
.front_page
	pop af
	; hl += (a + (a << 2)).
	; that is,
	; hl += (5 * a).
	ld c, a
	ld b, 0
	add hl, bc
	sla a
	sla a
	ld c, a
	add hl, bc
	ld a, [hli]
	push hl
	ld d, a
	ld e, $02
	call InitTextPrinting
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	pop hl
	lb de, 1, 5
	call InitTextPrinting
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $01
	ld [wLineSeparation], a
	call ProcessTextFromID
	xor a
	ld [wLineSeparation], a
	call EnableLCD
.loop
	call DoFrame
	ldh a, [hKeysPressed]
	and B_BUTTON
	jr z, .loop

	ld a, -1
	farcall Func_90fb
	ret

; unit: 5 bytes.
; [structure]
; horizonal align (1) / title text id (2) / desc. text id (2)
glossary_entry: MACRO
	db \1
	tx \2
	tx \3
ENDM
GlossaryData_1:
	glossary_entry 7, Text02fa, Text030c
	glossary_entry 5, Text02fb, Text030d
	glossary_entry 7, Text02fc, Text030e
	glossary_entry 6, Text02fd, Text030f
	glossary_entry 6, Text02fe, Text0310
	glossary_entry 4, Text02ff, Text0311
	glossary_entry 5, Text0300, Text0312
	glossary_entry 7, Text0301, Text0313
	glossary_entry 5, Text0302, Text0314
GlossaryData_2:
	glossary_entry 5, Text0303, Text0315
	glossary_entry 5, Text0304, Text0316
	glossary_entry 5, Text0305, Text0317
	glossary_entry 5, Text0306, Text0318
	glossary_entry 6, Text0307, Text0319
	glossary_entry 5, Text0308, Text031a
	glossary_entry 6, Text0309, Text031b
	glossary_entry 6, Text030a, Text031c
	glossary_entry 6, Text030b, Text031d

; (6:4661)
	xor a
	ld [wcfe3], a
	ld a, [wceaf]
	ld d, a
	ld a, [wceb0]
	ld e, a
	ldh a, [hDPadHeld]
	or a
	jr z, .asm_006_46a2
	bit D_LEFT_F, a
	jr nz, .asm_006_467a
	bit D_RIGHT_F, a
	jr z, .asm_006_4680
.asm_006_467a
	ld a, d
	xor $01
	ld d, a
	jr .asm_006_468c
.asm_006_4680
	bit D_UP_F, a
	jr nz, .asm_006_4688
	bit D_DOWN_F, a
	jr z, .asm_006_46a2
.asm_006_4688
	ld a, e
	xor $01
	ld e, a
.asm_006_468c
	ld a, $01
	ld [wcfe3], a
	push de
	call .asm_006_46d4
	pop de
	ld a, d
	ld [wceaf], a
	ld a, e
	ld [wceb0], a
	xor a
	ld [wCheckCommandCounter], a
.asm_006_46a2
	ldh a, [hKeysPressed]
	and $03
	jr z, .asm_006_46bd
	and $01
	jr nz, .asm_006_46b3
	ld a, $ff
	call Func_006_50fb
	scf
	ret
.asm_006_46b3
	call .asm_006_46f3
	ld a, $01
	call Func_006_50fb
	scf
	ret
.asm_006_46bd
	ld a, [wcfe3]
	or a
	jr z, .asm_006_46c6
	call PlaySFX
.asm_006_46c6
	ld hl, wCheckCommandCounter
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	ld a, $0f
	bit D_RIGHT_F, [hl]
	jr z, .asm_006_46d6
.asm_006_46d4 ; 186d4 (6:46d4)
	ld a, $00
.asm_006_46d6
	ld e, a
	ld a, $0a
	ld l, a
	ld a, [wceaf]
	ld h, a
	call HtimesL
	ld a, l
	add $01
	ld b, a
	ld a, [wceb0]
	sla a
	add $0e
	ld c, a
	ld a, e
	call WriteByteToBGMap0
	or a
	ret
.asm_006_46f3: ; 186f3 (6:46f3)
	ld a, $0f
	jr .asm_006_46d6

; (6:46f7)
INCLUDE "data/effect_commands.asm"

Func_006_4f9c: ; 18f9c (6:4f9c)
	ld a, [wLoadedMoveAnimation]
	or a
	ret z
	ld l, a
	ld h, 0
	add hl, hl
	ld de, Data_006_51a4
.asm_006_4fa8
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	ld hl, wce7e
	ld a, [hl]
	or a
	jr nz, .asm_006_4fd3
	ld [hl], $01
	call Func_3b21
	pop de
	push de
	ld a, $00
	ld [wd4ae], a
	ld a, $01
	ld [$d4b3], a
	xor a
	ld [wd4b0], a
	ld a, [de]
	cp $04
	jr z, .asm_006_4fd3
	ld a, $96
	call Func_3b6a
.asm_006_4fd3
	pop de
.asm_006_4fd4
	ld a, [de]
	inc de
	ld hl, PointerTable_006_508f
	jp JumpToFunctionInTable

Func_006_4fdc:
	ret

Func_006_4fdd:
	ldh a, [hWhoseTurn]
	ld [wd4af], a
	ld a, [wDuelType]
	cp $00
	jr nz, Func_006_5014
	ld a, $c2
	ld [wd4af], a
	jr Func_006_5014

Func_006_4ff0:
	call SwapTurn
	ldh a, [hWhoseTurn]
	ld [wd4af], a
	call SwapTurn
	ld a, [wDuelType]
	cp $00
	jr nz, Func_006_5014
	ld a, $c3
	ld [wd4af], a
	jr Func_006_5014

Func_006_5009:
	ld a, [wce82]
	and $7f
	ld [wd4b0], a
	jr Func_006_5014

Func_006_5013:
	ret

Func_006_5014:
	ld a, [de]
	inc de
	cp $09
	jr z, .asm_006_502b
	cp $fa
	jr z, .asm_006_5057
	cp $fb
	jr z, .asm_006_505d
	cp $fc
	jr z, .asm_006_5063
.asm_006_5026
	call Func_3b6a
	jr Func_006_4f9c.asm_006_4fd4
.asm_006_502b
	ld a, $97
	call Func_3b6a
	ld a, [wce81]
	ld [$d4b3], a
	push de
	ld hl, wce7f
	ld de, $d4b1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop de
	ld a, $8c
	call Func_3b6a
	ld a, [wDuelDisplayedScreen]
	cp $01
	jr nz, .asm_006_5054
	ld a, $98
	call Func_3b6a
.asm_006_5054
	jp Func_006_4f9c.asm_006_4fd4
.asm_006_5057
	ld c, $61
	ld b, $63
	jr .asm_006_5067
.asm_006_505d
	ld c, $62
	ld b, $64
	jr .asm_006_5067
.asm_006_5063
	ld c, $63
	ld b, $61
.asm_006_5067
	ldh a, [hWhoseTurn]
	cp $c2
	ld a, c
	jr z, .asm_006_5026
	ld a, [wDuelType]
	cp $00
	ld a, c
	jr z, .asm_006_5026
	ld a, b
	jr .asm_006_5026

Func_006_5079:
	ld a, [de]
	inc de
	ld [$d4b3], a
	ld a, [wce82]
	ld [wd4b0], a
	call Func_006_509d
	ld a, $96
	call Func_3b6a
	jp Func_006_4f9c.asm_006_4fd4

PointerTable_006_508f: ; (6:508f)
	dw Func_006_4fdc
	dw Func_006_5014
	dw Func_006_4fdd
	dw Func_006_4ff0
	dw Func_006_5079
	dw Func_006_5009
	dw Func_006_5013

Func_006_509d: ; 1909d (6:509d)
	ld a, [$d4b3]
	cp $04
	jr z, .asm_006_50ad
	cp $01
	ret nz
	ld a, $00
	ld [wd4ae], a
	ret
.asm_006_50ad
	ld a, [wd4b0]
	ld l, a
	ld a, [wWhoseTurn]
	ld h, a
	cp $c2
	jr z, .asm_006_50cc
	ld a, [wDuelType]
	cp $00
	jr z, .asm_006_50c6
	bit 7, l
	jr z, .asm_006_50e2
	jr .asm_006_50d2
.asm_006_50c6
	bit 7, l
	jr z, .asm_006_50da
	jr .asm_006_50ea
.asm_006_50cc
	bit 7, l
	jr z, .asm_006_50d2
	jr .asm_006_50e2
.asm_006_50d2
	ld l, $04
	ld h, $c2
	ld a, $01
	jr .asm_006_50f0
.asm_006_50da
	ld l, $04
	ld h, $c3
	ld a, $01
	jr .asm_006_50f0
.asm_006_50e2
	ld l, $05
	ld h, $c3
	ld a, $02
	jr .asm_006_50f0
.asm_006_50ea
	ld l, $05
	ld h, $c2
	ld a, $02
.asm_006_50f0:
	ld [wd4ae], a
	ret

; this part is not perfectly analyzed.
; needs some fix.
	ld a, [$d4b3]
	cp $04
	jr z, Func_006_50fb.asm_006_510f
Func_006_50fb: ; 190fb (6:50fb)
	cp $01
	jr nz, .asm_006_510e
	ld a, $00
	ld [wd4ae], a
	ld a, [wDuelDisplayedScreen]
	cp $01
	jr z, .asm_006_510e
	bank1call DrawDuelMainScene
.asm_006_510e
	ret
.asm_006_510f
	call Func_006_509d
	ld a, [wDuelDisplayedScreen]
	cp l
	jr z, .asm_006_512e
	ld a, l
	push af
	ld l, $c2
	ld a, [wDuelType]
	cp $00
	jr nz, .asm_006_5127
	ld a, [wWhoseTurn]
	ld l, a
.asm_006_5127
	call Func_30bc
	pop af
	ld [wDuelDisplayedScreen], a
.asm_006_512e
	call DrawWideTextBox
	ret

; needs analyze.
	push hl
	push bc
	push de
	ld a, [wLoadedMoveAnimation]
	cp $79
	jr z, .asm_006_5164
	cp $86
	jr z, .asm_006_5164
	ld a, [wTempNonTurnDuelistCardID]
	ld e, a
	ld d, $00
	call LoadCardDataToBuffer1_FromCardID
	ld a, $12
	call CopyCardNameAndLevel
	ld [hl], $00
	ld hl, wTxRam2
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wce7f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_006_5168
	ld a, l
	or h
	call nz, DrawWideTextBox_PrintText
.asm_006_5164
	pop de
	pop bc
	pop hl
	ret

Func_006_5168: ; 19168 (6:5168)
	ld a, l
	or h
	jr z, .asm_006_5188
	call LoadTxRam3
	ld a, [wce81]
	ld hl, $003a
	and $06
	ret z
	ld hl, $0038
	cp $06
	ret z
	and $02
	ld hl, $0037
	ret nz
	ld hl, $0036
	ret
.asm_006_5188
	call CheckNoDamageOrEffect
	ret c
	ld hl, $003b
	ld a, [wce81]
	and $04
	ret z
	ld hl, $0039
	ret

; needs analyze.
	ld a, [wDuelDisplayedScreen]
	cp $01
	ret nz
	bank1call DrawDuelHUDs
	ret

	ret

Data_006_51a4:
	dw $0000
	dw $52c6
	dw $52cf
	dw $52c6
	dw $52c6
	dw $52c6
	dw $52d8
	dw $52d8
	dw $52e3
	dw $52d8
	dw $52f0
	dw $52f0
	dw $52f0
	dw $52f0
	dw $52fd
	dw $5308
	dw $5313
	dw $531e
	dw $5329
	dw $5334
	dw $533f
	dw $534a
	dw $5357
	dw $5362
	dw $5362
	dw $536d
	dw $536d
	dw $536d
	dw $5378
	dw $5383
	dw $538e
	dw $5383
	dw $5399
	dw $53a4
	dw $53af
	dw $53ba
	dw $53c5
	dw $53d0
	dw $53d5
	dw $53e0
	dw $53eb
	dw $53f6
	dw $53f6
	dw $53f6
	dw $5401
	dw $540c
	dw $5417
	dw $5422
	dw $542d
	dw $542d
	dw $5438
	dw $5438
	dw $5438
	dw $5438
	dw $5438
	dw $5443
	dw $5443
	dw $544e
	dw $5443
	dw $5443
	dw $5443
	dw $5453
	dw $5453
	dw $5460
	dw $5453
	dw $5467
	dw $5467
	dw $5472
	dw $5472
	dw $547d
	dw $5488
	dw $548f
	dw $549c
	dw $549c
	dw $54a9
	dw $54a9
	dw $54ae
	dw $54ae
	dw $54b3
	dw $54be
	dw $54c3
	dw $54c8
	dw $54d3
	dw $54e0
	dw $54eb
	dw $54f2
	dw $54f9
	dw $5504
	dw $5513
	dw $5516
	dw $5521
	dw $552e
	dw $5533
	dw $553a
	dw $5543
	dw $554a
	dw $5555
	dw $555e
	dw $556d
	dw $5574
	dw $557b
	dw $557e
	dw $5583
	dw $5583
	dw $5583
	dw $558c
	dw $5597
	dw $559c
	dw $55a1
	dw $55a4
	dw $55a9
	dw $55b4
	dw $55b4
	dw $55bf
	dw $55c4
	dw $55c9
	dw $55ce
	dw $55d5
	dw $55e0
	dw $55e5
	dw $55e6
	dw $55ed
	dw $55f2
	dw $55fb
	dw $55fe
	dw $5601
	dw $5604
	dw $5607
	dw $560a
	dw $560f
	dw $5612
	dw $561d
	dw $5628
	dw $562d
	dw $5632
	dw $5637
	dw $5644
	dw $564f
	dw $5654
	dw $5659
	dw $565e
	dw $5665
	dw $5668
	dw $5673
	dw $5673

	INCROM $192c6, $1991f

Func_006_591f:
	add a
	ld e, a
	ld d, 0
	ld hl, .data
	add hl, de
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ld a, [hli]
	add $02
	push hl
	ld hl, sDeck1Name
	call Func_199e0
	pop hl
	call SwapTurn
	ld a, [hli]
	add $02
	call LoadDeck
	call SwapTurn
	call EnableSRAM
	ld h, $a1
	ld de, wPlayerDeck
	ld c, $3c
.asm_006_594c
	ld a, [de]
	inc de
	ld l, a
	res 7, [hl]
	dec c
	jr nz, .asm_006_594c

	ld h, $a1
	ld de, wOpponentDeck
	ld c, $1e
.asm_006_595b
	ld a, [de]
	inc de
	ld l, a
	res 7, [hl]
	inc [hl]
	dec c
	jr nz, .asm_006_595b

	call DisableSRAM
	ret
.data
	db $03, $04, $05, $06, $07, $08
	
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
	ldtx hl, ChooseTheCardYouWishToExamineText
	ldtx de, Text0196
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
; These are directed from around (2:4f05),
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

; set each byte zero from hl for b bytes.
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
; if a is 0xff play SFX_03 (usually following a B press),
; else play SFX_02 (usually following an A press).
PlayAcceptOrDeclineSFX: ; (6:6794)
	push af
	inc a
	jr z, .sfx_decline
	ld a, SFX_02
	jr .sfx_accept
.sfx_decline
	ld a, SFX_03
.sfx_accept
	call PlaySFX
	pop af
	ret

; get player name from the user
; into hl
InputPlayerName: ; (6:67a3)
	ld e, l
	ld d, h
	ld a, MAX_PLAYER_NAME_LENGTH
	ld hl, WhatIsYourNameData
	lb bc, 12, 1
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
	call LoadTextCursorTile
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
	call PlayAcceptOrDeclineSFX
	call Func_006_6a07
	ld a, 6
	ld [wNamingScreenCursorX], a
	ld a, 5
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
	ld a, [wNamingScreenBufferLength]
	or a
	jr z, .loop ; empty string?
	; erase one character.
	ld e, a
	ld d, 0
	ld hl, wNamingScreenBuffer
	add hl, de
	dec hl
	dec hl
	ld [hl], TX_END
	ld hl, wNamingScreenBufferLength ; note that its unit is byte, not word.
	dec [hl]
	dec [hl]
	call PrintPlayerNameFromInput
	jr .loop

; it's called when naming(either player's or deck's) starts.
; a: maximum length of name(depending on whether player's or deck's).
; bc: position of name.
; de: dest. pointer.
; hl: pointer to text item of the question.
InitializeInputName:
	ld [wNamingScreenBufferMaxLength], a
	push hl
	ld hl, wNamingScreenNamePosition
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
	ld a, NAMING_SCREEN_BUFFER_LENGTH
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
	call GetTextLengthInTiles
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
	ldtx hl, Text0221
	lb de, 2, 4
	call InitTextPrinting
	call ProcessTextFromID
	call EnableLCD
	ret
.data
	textitem $0f, $10, EndText ; "End"
	db $ff

DrawTextboxForKeyboard:
	lb de, 0, 3 ; x, y
	lb bc, 20, 15 ; w, h
	call DrawRegularTextBox
	ret

PrintPlayerNameFromInput:
	ld hl, wNamingScreenNamePosition
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
	ld d, 0
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
    done

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
	call GetCharInfoFromPos_Player
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
	call GetCharInfoFromPos_Player
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
	call GetCharInfoFromPos_Player
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
	ld [wCheckCommandCounter], a
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
	call PlayAcceptOrDeclineSFX
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
	ld hl, wCheckCommandCounter
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
	call GetCharInfoFromPos_Player
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
	ld hl, wNamingScreenNamePosition
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

; load, to the first tile of v0Tiles0, the graphics for the
; blinking black square used in name input screens.
; for inputting full width text.
LoadTextCursorTile:
	ld hl, v0Tiles0 + $00 tiles
	ld de, .data
	ld b, 0
.loop
	ld a, TILE_SIZE
	cp b
	ret z
	inc b
	ld a, [de]
	inc de
	ld [hli], a
	jr .loop

.data
rept TILE_SIZE
	db $ff
endr

; set the carry bit on,
; if "End" was selected.
NamingScreen_ProcessInput:
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call GetCharInfoFromPos_Player
	inc hl
	inc hl
	; load types into de.
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
	ldfw3 bc, "“"
	ld a, d
	cp b
	jr nz, .asm_006_6af4
	ld a, e
	cp c
	jr nz, .asm_006_6af4
	push hl
	ld hl, TransitionTable1 ; from 55th.
	call TransformCharacter
	pop hl
	jr c, .nothing
	jr .asm_006_6b09
.asm_006_6af4
	ldfw3 bc, "º(2)"
	ld a, d
	cp b
	jr nz, .asm_006_6b1d
	ld a, e
	cp c
	jr nz, .asm_006_6b1d
	push hl
	ld hl, TransitionTable2 ; from 72th.
	call TransformCharacter
	pop hl
	jr c, .nothing
.asm_006_6b09
	ld a, [wNamingScreenBufferLength]
	dec a
	dec a
	ld [wNamingScreenBufferLength], a
	ld hl, wNamingScreenBuffer
	push de
	ld d, 0
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
	ld a, TX_HIRAGANA
	jr .asm_006_6b37
.asm_006_6b2b
	ld a, TX_KATAKANA
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
	ld b, 0
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], TX_END ; null terminator.
	call PrintPlayerNameFromInput
.nothing
	or a
	ret
.on_end
	scf
	ret

; this transforms the last japanese character
; in the name buffer into its dakuon shape or something.
; it seems to have been deprecated as the game was translated into english.
; but it can still be applied to english, such as upper-lower case transition.
; hl: info. pointer.
TransformCharacter:
	ld a, [wNamingScreenBufferLength]
	or a
	jr z, .return ; if the length is zero, just return.
	dec a
	dec a
	push hl
	ld hl, wNamingScreenBuffer
	ld d, 0
	ld e, a
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	; de: last character in the buffer,
	; but byte-wise swapped.
	ld a, TX_KATAKANA
	cp e
	jr nz, .hiragana
	; if it's katakana,
	; make it hiragana by decreasing its high byte.
	dec e
.hiragana
	pop hl
.loop
	ld a, [hli]
	or a
	jr z, .return
	cp d
	jr nz, .next
	ld a, [hl]
	cp e
	jr nz, .next
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	or a
	ret
.next
	inc hl
	inc hl
	inc hl
	jr .loop
.return
	scf
	ret

; given the position of the current cursor,
; it returns the pointer to the proper information.
; h: position x.
; l: position y.
GetCharInfoFromPos_Player:
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
	ld hl, KeyboardData_Player
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
; abs. y pos. (1) / abs. x pos. (1) / type 1 (1) / type 2 (1) / char. code (2)
; unused data contains its character code as zero.
kbitem: MACRO
	db \1, \2, \3, \4
if (_NARG == 5)
	dw \5
elif (\5 == TX_FULLWIDTH3)
	dw (\5 << 8) | STRCAT("FW3_", \6)
else
	dw (\5 << 8) | \6
endc
ENDM
KeyboardData_Player: ; (6:6baf)
	kbitem $04, $02, $11, $00, TX_FULLWIDTH3,   "A"
	kbitem $06, $02, $12, $00, TX_FULLWIDTH3,   "J"
	kbitem $08, $02, $13, $00, TX_FULLWIDTH3,   "S"
	kbitem $0a, $02, $14, $00,                  "o"
	kbitem $0c, $02, $15, $00,                  "d"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $04, $16, $00, TX_FULLWIDTH3,   "B"
	kbitem $06, $04, $17, $00, TX_FULLWIDTH3,   "K"
	kbitem $08, $04, $18, $00, TX_FULLWIDTH3,   "T"
	kbitem $0a, $04, $19, $00, TX_FULLWIDTH3,   "&"
	kbitem $0c, $04, $1a, $00,                  "e"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $06, $1b, $00, TX_FULLWIDTH3,   "C"
	kbitem $06, $06, $1c, $00, TX_FULLWIDTH3,   "L"
	kbitem $08, $06, $1d, $00, TX_FULLWIDTH3,   "U"
	kbitem $0a, $06, $1e, $00,                  "j"
	kbitem $0c, $06, $1f, $00,                  "f"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $08, $20, $00, TX_FULLWIDTH3,   "D"
	kbitem $06, $08, $21, $00, TX_FULLWIDTH3,   "M"
	kbitem $08, $08, $22, $00, TX_FULLWIDTH3,   "V"
	kbitem $0a, $08, $23, $00,                  "k"
	kbitem $0c, $08, $24, $00,                  "g"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $0a, $25, $00, TX_FULLWIDTH3,   "E"
	kbitem $06, $0a, $26, $00, TX_FULLWIDTH3,   "N"
	kbitem $08, $0a, $27, $00, TX_FULLWIDTH3,   "W"
	kbitem $0a, $0a, $28, $00,                  "w"
	kbitem $0c, $0a, $29, $00,                  "h"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $0c, $2a, $00, TX_FULLWIDTH3,   "F"
	kbitem $06, $0c, $2b, $00, TX_FULLWIDTH3,   "O"
	kbitem $08, $0c, $2c, $00, TX_FULLWIDTH3,   "X"
	kbitem $0a, $0c, $2d, $00,                  "`"
	kbitem $0c, $0c, $2e, $00,                  "i"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $0e, $2f, $00, TX_FULLWIDTH3,   "G"
	kbitem $06, $0e, $30, $00, TX_FULLWIDTH3,   "P"
	kbitem $08, $0e, $31, $00, TX_FULLWIDTH3,   "Y"
	kbitem $0a, $0e, $32, $00,                  "a"
	kbitem $0c, $0e, $33, $00, TX_SYMBOL,       SYM_No
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $10, $34, $00, TX_FULLWIDTH3,   "H"
	kbitem $06, $10, $35, $00, TX_FULLWIDTH3,   "Q"
	kbitem $08, $10, $36, $00, TX_FULLWIDTH3,   "Z"
	kbitem $0a, $10, $3c, $00,                  "b"
	kbitem $0c, $10, $3d, $00, TX_SYMBOL,       SYM_Lv
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $12, $37, $00, TX_FULLWIDTH3,   "I"
	kbitem $06, $12, $38, $00, TX_FULLWIDTH3,   "R"
	kbitem $08, $12, $39, $00,                  "n"
	kbitem $0a, $12, $3a, $00,	                "c"
	kbitem $0c, $12, $3b, $00,	                "p"
	kbitem $10, $0f, $01, $09, $0000
	kbitem $00, $00, $00, $00, $0000

; a set of transition datum.
; unit: 4 bytes.
; structure:
; previous char. code (2) / translated char. code (2)
; - the former char. code contains 0x0e in high byte.
; - the latter char. code contains only low byte.
TransitionTable1:
	dw $0e16, $003e
	dw $0e17, $003f
	dw $0e18, $0040
	dw $0e19, $0041
	dw $0e1a, $0042
	dw $0e1b, $0043
	dw $0e1c, $0044
	dw $0e1d, $0045
	dw $0e1e, $0046
	dw $0e1f, $0047
	dw $0e20, $0048
	dw $0e21, $0049
	dw $0e22, $004a
	dw $0e23, $004b
	dw $0e24, $004c
	dw $0e2a, $004d
	dw $0e2b, $004e
	dw $0e2c, $004f
	dw $0e2d, $0050
	dw $0e2e, $0051
	dw $0e52, $004d
	dw $0e53, $004e
	dw $0e54, $004f
	dw $0e55, $0050
	dw $0e56, $0051
	dw $0000

TransitionTable2:
	dw $0e2a, $0052
	dw $0e2b, $0053
	dw $0e2c, $0054
	dw $0e2d, $0055
	dw $0e2e, $0056
	dw $0e4d, $0052
	dw $0e4e, $0053
	dw $0e4f, $0054
	dw $0e50, $0055
	dw $0e51, $0056
	dw $0000

; get deck name from the user into de.
; function description is similar to the player's.
; refer to 'InputPlayerName'.
InputDeckName: ; 1ad89 (6:6d89)
	push af
	; check if the buffer is empty.
	ld a, [de]
	or a
	jr nz, .not_empty
	; this buffer will contain half-width chars.
	ld a, TX_HALFWIDTH
	ld [de], a
.not_empty
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
	call LoadHalfWidthTextCursorTile

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
.loop
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame

	call UpdateRNGSources

	ldh a, [hDPadHeld]
	and START
	jr z, .on_start

	ld a, $01
	call PlayAcceptOrDeclineSFX
	call Func_006_6fa1

	ld a, 6
	ld [wNamingScreenCursorX], a
	ld [wNamingScreenCursorY], a
	call Func_006_6fbd

	jr .loop
.on_start
	call Func_006_6efb
	jr nc, .loop

	cp $ff
	jr z, .asm_006_6e1c

	call Func_006_6ec3
	jr nc, .loop

	call FinalizeInputName

	ld hl, wNamingScreenDestPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl

	ld a, [hl]
	or a
	jr nz, .return

	dec hl
	ld [hl], TX_END
.return
	ret
.asm_006_6e1c
	ld a, [wNamingScreenBufferLength]
	cp $02
	jr c, .loop

	ld e, a
	ld d, 0
	ld hl, wNamingScreenBuffer
	add hl, de
	dec hl
	ld [hl], TX_END

	ld hl, wNamingScreenBufferLength
	dec [hl]
	call ProcessTextWithUnderbar

	jp .loop

; load, to the first tile of v0Tiles0, the graphics for the
; blinking black square used in name input screens.
; for inputting half width text.
LoadHalfWidthTextCursorTile:
	ld hl, v0Tiles0 + $00 tiles
	ld de, .data
	ld b, 0
.loop
	ld a, TILE_SIZE
	cp b
	ret z
	inc b
	ld a, [de]
	inc de
	ld [hli], a
	jr .loop

.data
rept TILE_SIZE
    db $f0
endr

; it's only for naming the deck.
ProcessTextWithUnderbar:
	ld hl, wNamingScreenNamePosition
	ld d, [hl]
	inc hl
	ld e, [hl]
	call InitTextPrinting
	ld hl, .underbar_data
	ld de, wDefaultText
.loop ; copy the underbar string.
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, .loop

	ld hl, wNamingScreenBuffer
	ld de, wDefaultText
.loop2 ; copy the input from the user.
	ld a, [hli]
	or a
	jr z, .print_name
	ld [de], a
	inc de
	jr .loop2
.print_name
	ld hl, wDefaultText
	call ProcessText
	ret
.underbar_data
	db TX_HALFWIDTH
rept MAX_DECK_NAME_LENGTH
	db "_"
endr
	db TX_END

Func_006_6e99:
	call DrawTextboxForKeyboard
	call ProcessTextWithUnderbar
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
	lb de, 2, 4
	call InitTextPrinting
	call ProcessTextFromID
	call EnableLCD
	ret

Func_006_6ec3:
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call GetCharInfoFromPos_Deck
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
	ld b, 0
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], TX_END
	call ProcessTextWithUnderbar
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
	call GetCharInfoFromPos_Deck
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
	ld [wCheckCommandCounter], a
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
	call PlayAcceptOrDeclineSFX
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
	ld hl, wCheckCommandCounter
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
	call GetCharInfoFromPos_Deck
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
	ld hl, wNamingScreenNamePosition
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

; given the cursor position,
; returns the character information which the cursor directs.
; it's similar to "GetCharInfoFromPos_Player",
; but the data structure is different in its unit size.
; its unit size is 3, and player's is 6.
; h: x
; l: y
GetCharInfoFromPos_Deck:
	push de
	ld e, l
	ld d, h
	ld a, [wNamingScreenKeyboardHeight]
	ld l, a
	call HtimesL
	ld a, l
	add e
	; x * h + y
	ld hl, KeyboardData_Deck
	pop de
	or a
	ret z
.loop
	inc hl
	inc hl
	inc hl
	dec a
	jr nz, .loop
	ret

KeyboardData_Deck: ; (6:7019)
	db $04, $02, "A"
	db $06, $02, "J"
	db $08, $02, "S"
	db $0a, $02, "?"
	db $0c, $02, "4"
	db $0e, $02, $02
	db $10, $0f, $01

	db $04, $04, "B"
	db $06, $04, "K"
	db $08, $04, "T"
	db $0a, $04, "&"
	db $0c, $04, "5"
	db $0e, $04, $02
	db $10, $0f, $01

	db $04, $06, "C"
	db $06, $06, "L"
	db $08, $06, "U"
	db $0a, $06, "+"
	db $0c, $06, "6"
	db $0e, $06, $02
	db $10, $0f, $01

	db $04, $08, "D"
	db $06, $08, "M"
	db $08, $08, "V"
	db $0a, $08, "-"
	db $0c, $08, "7"
	db $0e, $08, $02
	db $10, $0f, $01

	db $04, $0a, "E"
	db $06, $0a, "N"
	db $08, $0a, "W"
	db $0a, $0a, "'"
	db $0c, $0a, "8"
	db $0e, $0a, $02
	db $10, $0f, $01

	db $04, $0c, "F"
	db $06, $0c, "O"
	db $08, $0c, "X"
	db $0a, $0c, "0"
	db $0c, $0c, "9"
	db $0e, $0c, $02
	db $10, $0f, $01

	db $04, $0e, "G"
	db $06, $0e, "P"
	db $08, $0e, "Y"
	db $0a, $0e, "1"
	db $0c, $0e, " "
	db $0e, $0e, $02
	db $10, $0f, $01

	db $04, $10, "H"
	db $06, $10, "Q"
	db $08, $10, "Z"
	db $0a, $10, "2"
	db $0c, $10, " "
	db $0e, $10, $02
	db $10, $0f, $01

	db $04, $12, "I"
	db $06, $12, "R"
	db $08, $12, "!"
	db $0a, $12, "3"
	db $0c, $12, " "
	db $0e, $12, $02
	db $10, $0f, $01

; unknown data.
; needs analyze.
; (6:70d6)
	INCROM $1b0d6, $1ba12

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

; farcall from 0xb87e(2:787d): [EF|06|9A|7A]
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