; fills wFilteredCardList and wOwnedCardsCountList
; with cards IDs and counts, respectively,
; from given Card Set in register a
; a = CARD_SET_* constant
CreateCardSetList:
	push af
	ld a, DECK_SIZE
	ld hl, wFilteredCardList
	call ClearMemory_Bank2
	ld a, DECK_SIZE
	ld hl, wOwnedCardsCountList
	call ClearMemory_Bank2
	xor a
	ld [wOwnedPhantomCardFlags], a
	pop af

	ld hl, 0
	lb de, 0, 0
	ld b, a
.loop_all_cards
	inc e
	call LoadCardDataToBuffer1_FromCardID
	jr c, .done_pkmn_cards
	ld a, [wLoadedCard1Set]
	and $f0 ; set 1
	swap a
	cp b
	jr nz, .loop_all_cards

; it's same set as input
	ld a, e
	cp VENUSAUR_LV64
	jp z, .SetVenusaurLv64OwnedFlag
	cp MEW_LV15
	jp z, .SetMewLv15OwnedFlag

	push bc
	push hl
	ld bc, wFilteredCardList
	add hl, bc
	ld [hl], e ; card ID

	ld hl, wTempCardCollection
	add hl, de
	ld a, [hl]
	pop hl
	push hl
	ld bc, wOwnedCardsCountList
	add hl, bc
	ld [hl], a ; card count in collection
	pop hl

	inc l
	pop bc
	jr .loop_all_cards

.done_pkmn_cards
; for the energy cards, put all basic energy cards in Colosseum
; and Double Colorless energy in Mystery
	ld a, b
	cp CARD_SET_MYSTERY
	jr z, .mystery
	or a
	jr nz, .skip_energy_cards

; colosseum
; places all basic energy cards in wFilteredCardList
	lb de, 0, 0
.loop_basic_energy_cards
	inc e
	ld a, e
	cp DOUBLE_COLORLESS_ENERGY
	jr z, .skip_energy_cards
	push bc
	push hl
	ld bc, wFilteredCardList
	add hl, bc
	ld [hl], e
	ld hl, wTempCardCollection
	add hl, de
	ld a, [hl]
	pop hl
	push hl
	ld bc, wOwnedCardsCountList
	add hl, bc
	ld [hl], a
	pop hl
	inc l
	pop bc
	jr .loop_basic_energy_cards

.mystery
; places double colorless energy card in wFilteredCardList
	lb de, 0, 0
.loop_find_double_colorless
	inc e
	ld a, e
	cp BULBASAUR
	jr z, .skip_energy_cards
	cp DOUBLE_COLORLESS_ENERGY
	jr nz, .loop_find_double_colorless
	; double colorless energy
	push bc
	push hl
	ld bc, wFilteredCardList
	add hl, bc
	ld [hl], e
	ld hl, wTempCardCollection
	add hl, de
	ld a, [hl]
	pop hl
	push hl
	ld bc, wOwnedCardsCountList
	add hl, bc
	ld [hl], a
	pop hl
	inc l
	pop bc
	jr .loop_find_double_colorless

.skip_energy_cards
	ld a, [wOwnedPhantomCardFlags]
	bit VENUSAUR_OWNED_PHANTOM_F, a
	jr z, .check_mew
	call .PlaceVenusaurLv64InList
.check_mew
	bit MEW_OWNED_PHANTOM_F, a
	jr z, .find_first_owned
	call .PlaceMewLv15InList

.find_first_owned
	dec l
	ld c, l
	ld b, h
.loop_owned_cards
	ld hl, wOwnedCardsCountList
	add hl, bc
	ld a, [hl]
	cp CARD_NOT_OWNED
	jr nz, .found_owned
	dec c
	jr .loop_owned_cards

.found_owned
	inc c
	ld a, c
	ld [wNumEntriesInCurFilter], a
	xor a
	ld hl, wFilteredCardList
	add hl, bc
	ld [hl], a
	ld a, $ff ; terminator byte
	ld hl, wOwnedCardsCountList
	add hl, bc
	ld [hl], a
	ret

.SetMewLv15OwnedFlag
	ld a, (1 << MEW_OWNED_PHANTOM_F)
;	fallthrough

.SetPhantomOwnedFlag
	push hl
	push bc
	ld b, a
	ld hl, wTempCardCollection
	add hl, de
	ld a, [hl]
	cp CARD_NOT_OWNED
	jr z, .skip_set_flag
	ld a, [wOwnedPhantomCardFlags]
	or b
	ld [wOwnedPhantomCardFlags], a
.skip_set_flag
	pop bc
	pop hl
	jp .loop_all_cards

.SetVenusaurLv64OwnedFlag
	ld a, (1 << VENUSAUR_OWNED_PHANTOM_F)
	jr .SetPhantomOwnedFlag

.PlaceVenusaurLv64InList
	push af
	push hl
	ld e, VENUSAUR_LV64
;	fallthrough

; places card in register e directly in the list
.PlaceCardInList
	ld bc, wFilteredCardList
	add hl, bc
	ld [hl], e
	pop hl
	push hl
	ld bc, wOwnedCardsCountList
	add hl, bc
	ld [hl], $01
	pop hl
	inc l
	pop af
	ret

.PlaceMewLv15InList
	push af
	push hl
	ld e, MEW_LV15
	jr .PlaceCardInList

; a = CARD_SET_* constant
CreateCardSetListAndInitListCoords:
	push af
	ld hl, sCardCollection
	ld de, wTempCardCollection
	ld b, CARD_COLLECTION_SIZE - 1
	call EnableSRAM
	call CopyNBytesFromHLToDE
	call DisableSRAM
	pop af

	push af
	call .GetEntryPrefix
	call CreateCardSetList
	ld a, NUM_CARD_ALBUM_VISIBLE_CARDS
	ld [wNumVisibleCardListEntries], a
	lb de, 2, 4
	ld hl, wCardListCoords
	ld [hl], e
	inc hl
	ld [hl], d
	pop af
	ret

; places in entry name the prefix associated with the selected Card Set
; a = CARD_SET_* constant
.GetEntryPrefix
	push af
	cp CARD_SET_PROMOTIONAL
	jr nz, .laboratory
	lb de, 3, "FW3_P"
	jr .got_prefix
.laboratory
	cp CARD_SET_LABORATORY
	jr nz, .mystery
	lb de, 3, "FW3_D"
	jr .got_prefix
.mystery
	cp CARD_SET_MYSTERY
	jr nz, .evolution
	lb de, 3, "FW3_C"
	jr .got_prefix
.evolution
	cp CARD_SET_EVOLUTION
	jr nz, .colosseum
	lb de, 3, "FW3_B"
	jr .got_prefix
.colosseum
	lb de, 3, "FW3_A"

.got_prefix
	ld hl, wCurDeckName
	ld [hl], d
	inc hl
	ld [hl], e
	pop af
	ret

; prints the cards being shown in the Card Album screen
; for the corresponding Card Set
PrintCardSetListEntries:
	push bc
	ld hl, wCardListCoords
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, $13
	ld c, e
	dec c
	dec c

; draw up cursor on top right
	ld a, [wCardListVisibleOffset]
	or a
	jr z, .no_up_cursor
	ld a, SYM_CURSOR_U
	jr .got_up_cursor_tile
.no_up_cursor
	ld a, SYM_BOX_TOP_R
.got_up_cursor_tile
	call WriteByteToBGMap0

	ld a, [wCardListVisibleOffset]
	ld l, a
	ld h, $00
	ld a, [wNumVisibleCardListEntries]
.loop_visible_cards
	push de
	or a
	jr z, .handle_down_cursor
	ld b, a
	ld de, wFilteredCardList
	push hl
	add hl, de
	ld a, [hl]
	pop hl
	inc l
	or a
	jr z, .no_down_cursor
	ld e, a
	call AddCardIDToVisibleList
	call LoadCardDataToBuffer1_FromCardID
	push bc
	push hl
	ld de, wOwnedCardsCountList
	add hl, de
	dec hl
	ld a, [hl]
	cp CARD_NOT_OWNED
	jr nz, .owned
	ld hl, .EmptySlotText
	ld de, wDefaultText
	call CopyListFromHLToDE
	jr .print_text
.owned
	ld a, 13
	call CopyCardNameAndLevel
.print_text
	pop hl
	pop bc
	pop de
	push hl
	call InitTextPrinting
	pop hl
	push hl
	call .AppendCardListIndex
	call ProcessText
	ld hl, wDefaultText
	jr .asm_a76d

	; this code is never reached
	pop de
	push hl
	call InitTextPrinting
	ld hl, Text_9a36

.asm_a76d
	call ProcessText
	pop hl
	ld a, b
	dec a
	inc e
	inc e
	jr .loop_visible_cards

.handle_down_cursor
	ld de, wFilteredCardList
	add hl, de
	ld a, [hl]
	or a
	jr z, .no_down_cursor
	pop de
	xor a ; FALSE
	ld [wUnableToScrollDown], a
	ld a, SYM_CURSOR_D
	jr .got_down_cursor_tile
.no_down_cursor
	pop de
	ld a, TRUE
	ld [wUnableToScrollDown], a
	ld a, SYM_BOX_BTM_R
.got_down_cursor_tile
	ld b, 19
	ld c, 17
	call WriteByteToBGMap0
	pop bc
	ret

.EmptySlotText
	textfw "-------------"
	done

; gets the index in the card list and adds it to wCurDeckName
.AppendCardListIndex
	push bc
	push de
	ld de, wFilteredCardList
	add hl, de
	dec hl
	ld a, [hl]
	cp DOUBLE_COLORLESS_ENERGY + 1
	jr c, .energy_card
	cp VENUSAUR_LV64
	jr z, .phantom_card
	cp MEW_LV15
	jr z, .phantom_card

	ld a, [wNumVisibleCardListEntries]
	sub b
	ld hl, wCardListVisibleOffset
	add [hl]
	inc a
	call CalculateOnesAndTensDigits
	ld hl, wDecimalDigitsSymbols
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or a
	jr nz, .got_index
	ld a, SYM_0
.got_index
	ld hl, wCurDeckName + 2 ; skip prefix
	ld [hl], TX_SYMBOL
	inc hl
	ld [hli], a ; tens place
	ld [hl], TX_SYMBOL
	inc hl
	ld a, b
	ld [hli], a ; ones place
	ld [hl], TX_SYMBOL
	inc hl
	xor a ; SYM_SPACE
	ld [hli], a
	ld [hl], a
	ld hl, wCurDeckName
	pop de
	pop bc
	ret

.energy_card
	call CalculateOnesAndTensDigits
	ld hl, wDecimalDigitsSymbols
	ld a, [hli]
	ld b, a
	ld hl, wCurDeckName + 2
	lb de, 3, "FW3_E"
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], TX_SYMBOL
	inc hl
	ld a, SYM_0
	ld [hli], a
	ld [hl], TX_SYMBOL
	inc hl
	ld a, b
	ld [hli], a
	ld [hl], TX_SYMBOL
	inc hl
	xor a ; SYM_SPACE
	ld [hli], a
	ld [hl], a
	ld hl, wCurDeckName + 2
	pop de
	pop bc
	ret

.phantom_card
; phantom cards get only "××" in their index number
	ld hl, wCurDeckName + 2
	ld [hl], "FW0_×"
	inc hl
	ld [hl], "FW0_×"
	inc hl
	ld [hl], TX_SYMBOL
	inc hl
	xor a ; SYM_SPACE
	ld [hli], a
	ld [hl], a
	ld hl, wCurDeckName
	pop de
	pop bc
	ret

; handles opening card page, and inputs when inside Card Album
HandleCardAlbumCardPage:
	ld a, [wCardListCursorPos]
	ld b, a
	ld a, [wCardListVisibleOffset]
	add b
	ld c, a
	ld b, $00
	ld hl, wOwnedCardsCountList
	add hl, bc
	ld a, [hl]
	cp CARD_NOT_OWNED
	jr z, .handle_input

	ld hl, wCurCardListPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld e, [hl]
	ld d, $00
	push de
	call LoadCardDataToBuffer1_FromCardID
	lb de, $38, $9f
	call SetupText
	bank1call OpenCardPage_FromCheckHandOrDiscardPile
	pop de

.handle_input
	ldh a, [hDPadHeld]
	ld b, a
	and BUTTONS
	jp nz, .exit
	xor a ; FALSE
	ld [wMenuInputSFX], a
	ld a, [wCardListNumCursorPositions]
	ld c, a
	ld a, [wCardListCursorPos]
	bit D_UP_F, b
	jr z, .check_d_down

	push af
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	ld a, [wCardListCursorPos]
	ld hl, wCardListVisibleOffset
	add [hl]
	ld hl, wFirstOwnedCardIndex
	cp [hl]
	jr z, .open_card_page_pop_af_2
	pop af

	dec a
	bit 7, a
	jr z, .got_new_pos
	ld a, [wCardListVisibleOffset]
	or a
	jr z, .open_card_page
	dec a
	ld [wCardListVisibleOffset], a
	xor a
	jr .got_new_pos

.check_d_down
	bit D_DOWN_F, b
	jr z, .asm_a8d6

	push af
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	pop af

	inc a
	cp c
	jr c, .got_new_pos
	push af
	ld hl, wCurCardListPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCardListCursorPos]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [wCardListVisibleOffset]
	inc a
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	or a
	jr z, .open_card_page_pop_af_1
	ld a, [wCardListVisibleOffset]
	inc a
	ld [wCardListVisibleOffset], a
	pop af
	dec a
.got_new_pos
	; loop back to the start
	ld [wCardListCursorPos], a
	ld a, [wMenuInputSFX]
	or a
	jp z, HandleCardAlbumCardPage
	call PlaySFX
	jp HandleCardAlbumCardPage
.open_card_page_pop_af_1
	pop af
	jr .open_card_page

.asm_a8d6
	ld a, [wced2]
	or a
	jr z, .open_card_page
	bit D_LEFT_F, b
	jr z, .check_d_right
	call RemoveCardFromDeck
	jr .open_card_page
.check_d_right
	bit D_RIGHT_F, b
	jr z, .open_card_page
	call TryAddCardToDeck

.open_card_page_pop_af_2
	pop af
.open_card_page
	push de
	bank1call OpenCardPage.input_loop
	pop de
	jp .handle_input

.exit
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a
	ret

GetFirstOwnedCardIndex:
	ld hl, wOwnedCardsCountList
	ld b, 0
.loop_cards
	ld a, [hli]
	cp CARD_NOT_OWNED
	jr nz, .owned
	inc b
	jr .loop_cards
.owned
	ld a, b
	ld [wFirstOwnedCardIndex], a
	ret

CardAlbum:
	ld a, $01
	ld [hffb4], a ; should be ldh

	xor a
.booster_pack_menu
	ld hl, .BoosterPackMenuParams
	call InitializeMenuParameters
	call .ShowBoosterPackMenu
.loop_input_1
	call DoFrame
	call HandleMenuInput
	jp nc, .loop_input_1 ; can be jr
	ldh a, [hCurMenuItem]
	cp $ff
	ret z

	; ignore input if this Card Set is unavailable
	ld c, a
	ld b, $0
	ld hl, wUnavailableAlbumCardSets
	add hl, bc
	ld a, [hl]
	or a
	jr nz, .loop_input_1

	ld a, c
	ld [wSelectedCardSet], a
	call CreateCardSetListAndInitListCoords
	call .PrintCardCount
	xor a
	ld [wCardListVisibleOffset], a
	call PrintCardSetListEntries
	call EnableLCD
	ld a, [wNumEntriesInCurFilter]
	or a
	jr nz, .asm_a968

.loop_input_2
	call DoFrame
	ldh a, [hKeysPressed]
	and B_BUTTON
	jr z, .loop_input_2
	ld a, $ff
	call PlaySFXConfirmOrCancel
	ldh a, [hCurMenuItem]
	jp .booster_pack_menu

.asm_a968
	call .GetNumCardEntries
	xor a
	ld hl, .BoosterPackCardsMenuParams
	call InitCardSelectionParams
	ld a, [wNumEntriesInCurFilter]
	ld hl, wNumVisibleCardListEntries
	cp [hl]
	jr nc, .asm_a97e
	ld [wCardListNumCursorPositions], a
.asm_a97e
	ld hl, PrintCardSetListEntries
	ld d, h
	ld a, l
	ld hl, wCardListUpdateFunction
	ld [hli], a
	ld [hl], d

	xor a
	ld [wced2], a
.loop_input_3
	call DoFrame
	call HandleDeckCardSelectionList
	jr c, .selection_made
	call HandleLeftRightInCardList
	jr c, .loop_input_3
	ldh a, [hDPadHeld]
	and START
	jr z, .loop_input_3
.open_card_page
	ld a, $01
	call PlaySFXConfirmOrCancel
	ld a, [wCardListNumCursorPositions]
	ld [wTempCardListNumCursorPositions], a
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a
	ld c, a
	ld a, [wCardListVisibleOffset]
	add c
	ld hl, wOwnedCardsCountList
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	cp CARD_NOT_OWNED
	jr z, .loop_input_3

	; set wFilteredCardList as current card list
	ld de, wFilteredCardList
	ld hl, wCurCardListPtr
	ld [hl], e
	inc hl
	ld [hl], d

	call GetFirstOwnedCardIndex
	call HandleCardAlbumCardPage
	call .PrintCardCount
	call PrintCardSetListEntries
	call EnableLCD
	ld hl, .BoosterPackCardsMenuParams
	call InitCardSelectionParams
	ld a, [wTempCardListNumCursorPositions]
	ld [wCardListNumCursorPositions], a
	ld a, [wTempCardListCursorPos]
	ld [wCardListCursorPos], a
	jr .loop_input_3

.selection_made
	call DrawListCursor_Invisible
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a
	ld a, [hffb3]
	cp $ff
	jr nz, .open_card_page
	ldh a, [hCurMenuItem]
	jp .booster_pack_menu

.BoosterPackMenuParams:
	db 3, 3 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

.BoosterPackCardsMenuParams:
	db 1 ; x pos
	db 4 ; y pos
	db 2 ; y spacing
	db 0 ; x spacing
	db NUM_CARD_ALBUM_VISIBLE_CARDS ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

.GetNumCardEntries
	ld hl, wFilteredCardList
	ld b, $00
.loop_card_ids
	ld a, [hli]
	or a
	jr z, .asm_aa1f
	inc b
	jr .loop_card_ids
.asm_aa1f
	ld a, b
	ld [wNumCardListEntries], a
	ret

; prints "X/Y" where X is number of cards owned in the set
; and Y is the total card count of the Card Set
.PrintCardCount
	call Set_OBJ_8x8
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	call EmptyScreen
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call LoadCursorTile
	call LoadSymbolsFont
	call LoadDuelCardSymbolTiles
	bank1call SetDefaultConsolePalettes
	lb de, $3c, $ff
	call SetupText
	lb de, 1, 1
	call InitTextPrinting

; print the total number of cards that are in the Card Set
	ld a, [wSelectedCardSet]
	cp CARD_SET_PROMOTIONAL
	jr nz, .check_laboratory
; promotional
	ldtx hl, Item5PromotionalCardText
	ld e, NUM_CARDS_PROMOTIONAL - 2 ; minus the phantom cards
	ld a, [wOwnedPhantomCardFlags]
	bit VENUSAUR_OWNED_PHANTOM_F, a
	jr z, .check_owns_mew
	inc e
.check_owns_mew
	bit MEW_OWNED_PHANTOM_F, a
	jr z, .has_card_set_count
	inc e
	jr .has_card_set_count
.check_laboratory
	cp CARD_SET_LABORATORY
	jr nz, .check_mystery
	ldtx hl, Item4LaboratoryText
	ld e, NUM_CARDS_LABORATORY
	jr .has_card_set_count
.check_mystery
	cp CARD_SET_MYSTERY
	jr nz, .check_evolution
	ldtx hl, Item3MysteryText
	ld e, NUM_CARDS_MYSTERY
	jr .has_card_set_count
.check_evolution
	cp CARD_SET_EVOLUTION
	jr nz, .colosseum
	ldtx hl, Item2EvolutionText
	ld e, NUM_CARDS_EVOLUTION
	jr .has_card_set_count
.colosseum
	ldtx hl, Item1ColosseumText
	ld e, NUM_CARDS_COLOSSEUM

.has_card_set_count
	push de
	call ProcessTextFromID
	call .CountOwnedCardsInSet
	lb de, 14, 1
	call InitTextPrinting

	ld a, [wNumOwnedCardsInSet]
	ld hl, wDefaultText
	call ConvertToNumericalDigits
	call CalculateOnesAndTensDigits
	ld [hl], TX_SYMBOL
	inc hl
	ld [hl], SYM_SLASH
	inc hl
	pop de

	ld a, e
	call ConvertToNumericalDigits
	ld [hl], TX_END
	ld hl, wDefaultText
	call ProcessText
	lb de, 0, 2
	lb bc, 20, 16
	call DrawRegularTextBox
	call EnableLCD
	ret

; counts number of cards in wOwnedCardsCountList
; that is not set as CARD_NOT_OWNED
.CountOwnedCardsInSet
	ld hl, wOwnedCardsCountList
	ld b, 0
.loop_card_count
	ld a, [hli]
	cp $ff
	jr z, .got_num_owned_cards
	cp CARD_NOT_OWNED
	jr z, .loop_card_count
	inc b
	jr .loop_card_count
.got_num_owned_cards
	ld a, b
	ld [wNumOwnedCardsInSet], a
	ret

.ShowBoosterPackMenu:
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	ld a, [hffb4]
	dec a
	jr nz, .draw_box
	ld [hffb4], a
	call Set_OBJ_8x8
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a

	call LoadCursorTile
	call LoadSymbolsFont
	call LoadDuelCardSymbolTiles
	bank1call SetDefaultConsolePalettes
	lb de, $3c, $ff
	call SetupText

.draw_box
	lb de, 0, 0
	lb bc, 20, 13
	call DrawRegularTextBox
	ld hl, .BoosterPacksMenuData
	call PlaceTextItems

	; set all Card Sets as available
	ld a, NUM_CARD_SETS
	ld hl, wUnavailableAlbumCardSets
	call ClearMemory_Bank2

	; check whether player has had promotional cards
	call EnableSRAM
	ld a, [sHasPromotionalCards]
	call DisableSRAM
	or a
	jr nz, .has_promotional

	; doesn't have promotional, check if
	; this is still the case by checking the collection
	ld a, CARD_SET_PROMOTIONAL
	call CreateCardSetListAndInitListCoords
	ld a, [wFilteredCardList]
	or a
	jr nz, .set_has_promotional
	; still has no promotional, print empty Card Set name
	ld a, TRUE
	ld [wUnavailableAlbumCardSets + CARD_SET_PROMOTIONAL], a
	ld e, 11
	ld d, 5
	call InitTextPrinting
	ldtx hl, EmptyPromotionalCardText
	call ProcessTextFromID
	jr .has_promotional

.set_has_promotional
	call EnableSRAM
	ld a, TRUE
	ld [sHasPromotionalCards], a
	call DisableSRAM
.has_promotional
	ldtx hl, ViewWhichCardFileText
	call DrawWideTextBox_PrintText
	call EnableLCD
	ret

.BoosterPacksMenuData
	textitem 7,  1, BoosterPackTitleText
	textitem 5,  3, Item1ColosseumText
	textitem 5,  5, Item2EvolutionText
	textitem 5,  7, Item3MysteryText
	textitem 5,  9, Item4LaboratoryText
	textitem 5, 11, Item5PromotionalCardText
	db $ff
