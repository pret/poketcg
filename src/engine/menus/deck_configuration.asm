; goes through whole deck in hl
; for each card ID, goes to its corresponding
; entry in sCardCollection and decrements its count
DecrementDeckCardsInCollection:
	push hl
	ld b, $0
	ld d, DECK_SIZE
.loop_deck
	ld a, [hli]
	or a
	jr z, .done
	ld c, a
	push hl
	ld hl, sCardCollection
	add hl, bc
	dec [hl]
	pop hl
	dec d
	jr nz, .loop_deck
.done
	pop hl
	ret

; like AddDeckToCollection, but takes care to
; check if increasing the collection count would
; go over MAX_AMOUNT_OF_CARD and caps it
; this is because it's used within Gift Center,
; so we cannot assume that the deck configuration
; won't make it go over MAX_AMOUNT_OF_CARD
; hl = deck configuration, with cards to add
AddGiftCenterDeckCardsToCollection:
	push hl
	ld b, $0
	ld d, DECK_SIZE
.loop_deck
	ld a, [hli]
	or a
	jr z, .done
	ld c, a
	push hl
	push de
	push bc
	ld a, ALL_DECKS
	call CreateCardCollectionListWithDeckCards
	pop bc
	pop de
	ld hl, wTempCardCollection
	add hl, bc
	ld a, [hl]
	cp MAX_AMOUNT_OF_CARD
	jr z, .next_card ; capped
	call EnableSRAM ; no DisableSRAM
	ld hl, sCardCollection
	add hl, bc
	ld a, [hl]
	cp CARD_NOT_OWNED
	jr nz, .incr
	; not owned
	xor a
	ld [hl], a
.incr
	inc [hl]
.next_card
	pop hl
	dec d
	jr nz, .loop_deck
.done
	pop hl
	ret

; adds all cards in deck in hl to player's collection
; assumes SRAM is enabled
; hl = pointer to deck cards
AddDeckToCollection:
	push hl
	ld b, $0
	ld d, DECK_SIZE
.loop_deck
	ld a, [hli]
	or a
	jr z, .done
	ld c, a
	push hl
	ld hl, sCardCollection
	add hl, bc
	inc [hl]
	pop hl
	dec d
	jr nz, .loop_deck
.done
	pop hl
	ret

; draws the screen which shows the player's current
; deck configurations
; a = DECK_* flags to pick which deck names to show
DrawDecksScreen:
	ld [hffb5], a
	call EmptyScreenAndLoadFontDuelAndHandCardsIcons
	lb de, 0,  0
	lb bc, 20, 4
	call DrawRegularTextBox
	lb de, 0,  3
	lb bc, 20, 4
	call DrawRegularTextBox
	lb de, 0,  6
	lb bc, 20, 4
	call DrawRegularTextBox
	lb de, 0,  9
	lb bc, 20, 4
	call DrawRegularTextBox
	ld hl, DeckNameMenuData
	call PlaceTextItems

; mark all decks as invalid
	ld a, NUM_DECKS
	ld hl, wDecksValid
	call ClearMemory_Bank2

; for each deck, check if it has cards and if so
; mark is as valid in wDecksValid

; deck 1
	ld a, [hffb5] ; should be ldh
	bit 0, a
	jr z, .skip_name_1
	ld hl, sDeck1Name
	lb de, 6, 2
	call PrintDeckName
.skip_name_1
	ld hl, sDeck1Cards
	call CheckIfDeckHasCards
	jr c, .deck_2
	ld a, TRUE
	ld [wDeck1Valid], a

.deck_2
	ld a, [hffb5] ; should be ldh
	bit 1, a
	jr z, .skip_name_2
	ld hl, sDeck2Name
	lb de, 6, 5
	call PrintDeckName
.skip_name_2
	ld hl, sDeck2Cards
	call CheckIfDeckHasCards
	jr c, .deck_3
	ld a, TRUE
	ld [wDeck2Valid], a

.deck_3
	ld a, [hffb5] ; should be ldh
	bit 2, a
	jr z, .skip_name_3
	ld hl, sDeck3Name
	lb de, 6, 8
	call PrintDeckName
.skip_name_3
	ld hl, sDeck3Cards
	call CheckIfDeckHasCards
	jr c, .deck_4
	ld a, TRUE
	ld [wDeck3Valid], a

.deck_4
	ld a, [hffb5] ; should be ldh
	bit 3, a
	jr z, .skip_name_4
	ld hl, sDeck4Name
	lb de, 6, 11
	call PrintDeckName
.skip_name_4
	ld hl, sDeck4Cards
	call CheckIfDeckHasCards
	jr c, .place_cursor
	ld a, TRUE
	ld [wDeck4Valid], a

.place_cursor
; places cursor on sCurrentlySelectedDeck
; if it's an empty deck, then advance the cursor
; until it's selecting a valid deck
	call EnableSRAM
	ld a, [sCurrentlySelectedDeck]
	ld c, a
	ld b, $0
	ld d, 2
.check_valid_deck
	ld hl, wDecksValid
	add hl, bc
	ld a, [hl]
	or a
	jr nz, .valid_selected_deck
	inc c
	ld a, NUM_DECKS
	cp c
	jr nz, .check_valid_deck
	ld c, 0 ; roll back to deck 1
	dec d
	jr z, .valid_selected_deck
	jr .check_valid_deck

.valid_selected_deck
	ld a, c
	ld [sCurrentlySelectedDeck], a
	call DisableSRAM
	call DrawHandCardsTileOnCurDeck
	call EnableLCD
	ret

DeckNameMenuData:
	textitem 4,  2, Deck1Text
	textitem 4,  5, Deck2Text
	textitem 4,  8, Deck3Text
	textitem 4, 11, Deck4Text
	db $ff

; copies text from hl to wDefaultText
; with " deck" appended to the end
; hl = ptr to deck name
CopyDeckName:
	ld de, wDefaultText
	call CopyListFromHLToDE
	ld hl, wDefaultText
	call GetTextLengthInTiles
	ld b, $0
	ld hl, wDefaultText
	add hl, bc
	ld d, h
	ld e, l
	ld hl, DeckNameSuffix
	call CopyListFromHLToDE
	ret

; prints deck name given in hl in position de
; if it's an empty deck, print "NEW DECK" instead
; returns carry if it's an empty deck
; hl = deck name (sDeck1Name ~ sDeck4Name)
; de = coordinates to print text
PrintDeckName:
	push hl
	call CheckIfDeckHasCards
	pop hl
	jr c, .new_deck

; print "<deck name> deck"
	push de
	ld de, wDefaultText
	call CopyListFromHLToDEInSRAM
	ld hl, wDefaultText
	call GetTextLengthInTiles
	ld b, $0
	ld hl, wDefaultText
	add hl, bc
	ld d, h
	ld e, l
	ld hl, DeckNameSuffix
	call CopyListFromHLToDE
	pop de
	ld hl, wDefaultText
	call InitTextPrinting
	call ProcessText
	or a
	ret

.new_deck
; print "NEW DECK"
	call InitTextPrinting
	ldtx hl, NewDeckText
	call ProcessTextFromID
	scf
	ret

DeckNameSuffix:
	db " deck"
	done

; copies a $00-terminated list from hl to de
CopyListFromHLToDE:
	ld a, [hli]
	ld [de], a
	or a
	ret z
	inc de
	jr CopyListFromHLToDE

; same as CopyListFromHLToDE, but for SRAM copying
CopyListFromHLToDEInSRAM:
	call EnableSRAM
	call CopyListFromHLToDE
	call DisableSRAM
	ret

; appends text in hl to wDefaultText
; then adds "deck" to the end
; returns carry if deck has no cards
; hl = text to append
; de = input to InitTextPrinting
AppendDeckName:
	push hl
	call CheckIfDeckHasCards
	pop hl
	ret c ; no cards

	push de
	; append the text from hl
	ld de, wDefaultText
	call CopyListFromHLToDEInSRAM

	; get string length (up to DECK_NAME_SIZE_WO_SUFFIX)
	ld hl, wDefaultText
	call GetTextLengthInTiles
	ld a, c
	cp DECK_NAME_SIZE_WO_SUFFIX
	jr c, .got_len
	ld c, DECK_NAME_SIZE_WO_SUFFIX
.got_len
	ld b, $0
	ld hl, wDefaultText
	add hl, bc
	ld d, h
	ld e, l
	; append "deck" starting from the given length
	ld hl, .text_start
	ld b, .text_end - .text_start
	call CopyNBytesFromHLToDE
	xor a ; TX_END
	ld [wDefaultText + DECK_NAME_SIZE + 2], a
	pop de
	ld hl, wDefaultText
	call InitTextPrinting
	call ProcessText
	or a
	ret

.text_start
	db " deck                       "
.text_end

; returns carry if the deck in hl
; is not valid, that is, has no cards
; alternatively, the direct address of the cards
; can be used, since DECK_SIZE > DECK_NAME_SIZE
; hl = deck name (sDeck1Name ~ sDeck4Name)
;   or deck cards (sDeck1Cards ~ sDeck4Cards)
CheckIfDeckHasCards:
	ld bc, DECK_NAME_SIZE
	add hl, bc
	call EnableSRAM
	ld a, [hl]
	call DisableSRAM
	; being max size means last char
	; is not TX_END, i.e. $0
	or a
	jr nz, .max_size
	scf
	ret
.max_size
	or a
	ret

; calculates the y coordinate of the currently selected deck
; and draws the hands card tile at that position
DrawHandCardsTileOnCurDeck:
	call EnableSRAM
	ld a, [sCurrentlySelectedDeck]
	call DisableSRAM
	ld h, 3
	ld l, a
	call HtimesL
	ld e, l
	inc e ; (sCurrentlySelectedDeck * 3) + 1
	ld d, 2
;	fallthrough

; de = coordinates to draw rectangle
DrawHandCardsTileAtDE:
	ld a, $38 ; hand cards tile
	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle
	ret

; handles user input when selecting a card filter
; when building a deck configuration
; the handling of selecting cards themselves from the list
; to add/remove to the deck is done in HandleDeckCardSelectionList
HandleDeckBuildScreen:
	call WriteCardListsTerminatorBytes
	call CountNumberOfCardsForEachCardType
.skip_count
	call DrawCardTypeIconsAndPrintCardCounts

	xor a
	ld [wCardListVisibleOffset], a
	ld [wCurCardTypeFilter], a ; FILTER_GRASS
	call PrintFilteredCardList

.skip_draw
	ld hl, FiltersCardSelectionParams
	call InitCardSelectionParams
.wait_input
	call DoFrame
	ldh a, [hDPadHeld]
	and START
	jr z, .no_start_btn_1
	ld a, $01
	call PlaySFXConfirmOrCancel
	call ConfirmDeckConfiguration
	ld a, [wCurCardTypeFilter]
	ld [wTempCardTypeFilter], a
	jr .wait_input

.no_start_btn_1
	ld a, [wCurCardTypeFilter]
	ld b, a
	ld a, [wTempCardTypeFilter]
	cp b
	jr z, .check_down_btn
	; need to refresh the filtered card list
	ld [wCurCardTypeFilter], a
	ld hl, wCardListVisibleOffset
	ld [hl], 0
	call PrintFilteredCardList
	ld a, NUM_FILTERS
	ld [wCardListNumCursorPositions], a

.check_down_btn
	ldh a, [hDPadHeld]
	and D_DOWN
	jr z, .no_down_btn
	call ConfirmSelectionAndReturnCarry
	jr .jump_to_list

.no_down_btn
	call HandleCardSelectionInput
	jr nc, .wait_input
	ld a, [hffb3]
	cp $ff ; operation cancelled?
	jp z, OpenDeckConfigurationMenu

; input was made to jump to the card list
.jump_to_list
	ld a, [wNumEntriesInCurFilter]
	or a
	jr z, .wait_input
	xor a
.wait_list_input
	ld hl, FilteredCardListSelectionParams
	call InitCardSelectionParams
	ld a, [wNumEntriesInCurFilter]
	ld [wNumCardListEntries], a
	ld hl, wNumVisibleCardListEntries
	cp [hl]
	jr nc, .ok
	; if total number of entries is greater than or equal to
	; the number of visible entries, then set number of cursor positions
	; as number of visible entries
	ld [wCardListNumCursorPositions], a
.ok
	ld hl, PrintDeckBuildingCardList
	ld d, h
	ld a, l
	ld hl, wCardListUpdateFunction
	ld [hli], a
	ld [hl], d

	ld a, $01
	ld [wced2], a
.loop_input
	call DoFrame
	ldh a, [hDPadHeld]
	and START
	jr z, .no_start_btn_2
	ld a, $01
	call PlaySFXConfirmOrCancel

	; temporarily store current cursor position
	; to retrieve it later
	ld a, [wCardListCursorPos]
	ld [wTempFilteredCardListNumCursorPositions], a
	call ConfirmDeckConfiguration
	ld a, [wTempFilteredCardListNumCursorPositions]
	jr .wait_list_input

.no_start_btn_2
	call HandleSelectUpAndDownInList
	jr c, .loop_input
	call HandleDeckCardSelectionList
	jr c, .selection_made
	jr .loop_input

.open_card_page
	ld a, $01
	call PlaySFXConfirmOrCancel
	ld a, [wCardListNumCursorPositions]
	ld [wTempCardListNumCursorPositions], a
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a

	; set wFilteredCardList as current card list
	; and show card page screen
	ld de, wFilteredCardList
	ld hl, wCurCardListPtr
	ld [hl], e
	inc hl
	ld [hl], d
	call OpenCardPageFromCardList
	call DrawCardTypeIconsAndPrintCardCounts

	ld hl, FiltersCardSelectionParams
	call InitCardSelectionParams
	ld a, [wCurCardTypeFilter]
	ld [wTempCardTypeFilter], a
	call DrawHorizontalListCursor_Visible
	call PrintDeckBuildingCardList
	ld hl, FilteredCardListSelectionParams
	call InitCardSelectionParams
	ld a, [wTempCardListNumCursorPositions]
	ld [wCardListNumCursorPositions], a
	ld a, [wTempCardListCursorPos]
	ld [wCardListCursorPos], a
	jr .loop_input

.selection_made
	call DrawListCursor_Invisible
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a
	ld a, [hffb3]
	cp $ff
	jr nz, .open_card_page
	; cancelled
	ld hl, FiltersCardSelectionParams
	call InitCardSelectionParams
	ld a, [wCurCardTypeFilter]
	ld [wTempCardTypeFilter], a
	jp .wait_input

OpenDeckConfigurationMenu:
	xor a
	ld [wYourOrOppPlayAreaCurPosition], a
	ld de, wDeckConfigurationMenuTransitionTable
	ld hl, wMenuInputTablePointer
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	ld a, $ff
	ld [wDuelInitialPrizesUpperBitsSet], a
.skip_init
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	ld hl, wDeckConfigurationMenuHandlerFunction
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

HandleDeckConfigurationMenu:
	lb de, 0, 0
	lb bc, 20, 6
	call DrawRegularTextBox
	ld hl, DeckBuildMenuData
	call PlaceTextItems

.do_frame
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call YourOrOppPlayAreaScreen_HandleInput
	jr nc, .do_frame
	ld [wced6], a
	cp $ff
	jr nz, .asm_94b5
.draw_icons
	call DrawCardTypeIconsAndPrintCardCounts
	ld a, [wTempCardListCursorPos]
	ld [wCardListCursorPos], a
	ld a, [wCurCardTypeFilter]
	call PrintFilteredCardList
	jp HandleDeckBuildScreen.skip_draw

.asm_94b5
	push af
	call YourOrOppPlayAreaScreen_HandleInput.draw_cursor
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	pop af
	ld hl, .func_table
	call JumpToFunctionInTable
	jr OpenDeckConfigurationMenu.skip_init

.func_table
	dw ConfirmDeckConfiguration ; Confirm
	dw ModifyDeckConfiguration  ; Modify
	dw ChangeDeckName           ; Name
	dw SaveDeckConfiguration    ; Save
	dw DismantleDeck            ; Dismantle
	dw CancelDeckModifications  ; Cancel

ConfirmDeckConfiguration:
	ld hl, wCardListVisibleOffset
	ld a, [hl]
	ld hl, wCardListVisibleOffsetBackup
	ld [hl], a
	call HandleDeckConfirmationMenu
	ld hl, wCardListVisibleOffsetBackup
	ld a, [hl]
	ld hl, wCardListVisibleOffset
	ld [hl], a
	call DrawCardTypeIconsAndPrintCardCounts
	ld hl, FiltersCardSelectionParams
	call InitCardSelectionParams
	ld a, [wCurCardTypeFilter]
	ld [wTempCardTypeFilter], a
	call DrawHorizontalListCursor_Visible
	ld a, [wCurCardTypeFilter]
	call PrintFilteredCardList
	ld a, [wced6]
	ld [wCardListCursorPos], a
	ret

ModifyDeckConfiguration:
	add sp, $2
	jr HandleDeckConfigurationMenu.draw_icons

; returns carry set if player chose to go back
CancelDeckModifications:
; if deck was not changed, cancel modification immediately
	call CheckIfCurrentDeckWasChanged
	jr nc, .cancel_modification
; else prompt the player to confirm
	ldtx hl, QuitModifyingTheDeckText
	call YesOrNoMenuWithText
	jr c, SaveDeckConfiguration.go_back
.cancel_modification
	add sp, $2
	or a
	ret

SaveDeckConfiguration:
; handle deck configuration size
	ld a, [wTotalCardCount]
	cp DECK_SIZE
	jp z, .ask_to_save_deck ; can be jr
	ldtx hl, ThisIsntA60CardDeckText
	call DrawWideTextBox_WaitForInput
	ldtx hl, ReturnToOriginalConfigurationText
	call YesOrNoMenuWithText
	jr c, .print_deck_size_warning
; return no carry
	add sp, $2
	or a
	ret
.print_deck_size_warning
	ldtx hl, TheDeckMustInclude60CardsText
	call DrawWideTextBox_WaitForInput
	jr .go_back

.ask_to_save_deck
	ldtx hl, SaveThisDeckText
	call YesOrNoMenuWithText
	jr c, .go_back
	call CheckIfThereAreAnyBasicCardsInDeck
	jr c, .set_carry
	ldtx hl, ThereAreNoBasicPokemonInThisDeckText
	call DrawWideTextBox_WaitForInput
	ldtx hl, YouMustIncludeABasicPokemonInTheDeckText
	call DrawWideTextBox_WaitForInput

.go_back
	call DrawCardTypeIconsAndPrintCardCounts
	call PrintDeckBuildingCardList
	ld a, [wced6]
	ld [wCardListCursorPos], a
	ret

.set_carry
	add sp, $2
	scf
	ret

DismantleDeck:
	ldtx hl, DismantleThisDeckText
	call YesOrNoMenuWithText
	jr c, SaveDeckConfiguration.go_back
	call CheckIfHasOtherValidDecks
	jp nc, .Dismantle ; can be jr
	ldtx hl, ThereIsOnly1DeckSoCannotBeDismantledText
	call DrawWideTextBox_WaitForInput
	call EmptyScreen
	ld hl, FiltersCardSelectionParams
	call InitCardSelectionParams
	ld a, [wCurCardTypeFilter]
	ld [wTempCardTypeFilter], a
	call DrawHorizontalListCursor_Visible
	call PrintDeckBuildingCardList
	call EnableLCD
	ld a, [wced6]
	ld [wCardListCursorPos], a
	ret

.Dismantle
	call EnableSRAM
	call GetPointerToDeckName
	ld a, [hl]
	or a
	jr z, .done_dismantle
	ld a, NAME_BUFFER_LENGTH
	call ClearMemory_Bank2
	call GetPointerToDeckCards
	call AddDeckToCollection
	ld a, DECK_SIZE
	call ClearMemory_Bank2
.done_dismantle
	call DisableSRAM
	add sp, $2
	ret

ChangeDeckName:
	call InputCurDeckName
	add sp, $2
	jp HandleDeckBuildScreen.skip_count

; returns carry if current deck was changed
; either through its card configuration or its name
CheckIfCurrentDeckWasChanged:
	ld a, [wTotalCardCount]
	or a
	jr z, .skip_size_check
	cp DECK_SIZE
	jr nz, .set_carry
.skip_size_check

; copy the selected deck to wCurDeckCardChanges
	call GetPointerToDeckCards
	ld de, wCurDeckCardChanges
	ld b, DECK_SIZE
	call EnableSRAM
	call CopyNBytesFromHLToDE
	call DisableSRAM

; loops through cards in wCurDeckCards
; then if that card is found in wCurDeckCardChanges
; overwrite it by $0
	ld a, $ff ; terminator byte
	ld [wCurDeckCardChanges + DECK_SIZE], a
	ld de, wCurDeckCards
.loop_outer
	ld a, [de]
	or a
	jr z, .check_empty
	ld b, a
	inc de
	ld hl, wCurDeckCardChanges
.loop_inner
	ld a, [hli]
	cp $ff
	jr z, .loop_outer
	cp b
	jr nz, .loop_inner
	; found
	dec hl
	xor a
	ld [hli], a ; remove
	jr .loop_outer

.check_empty
	ld hl, wCurDeckCardChanges
.loop_check_empty
	ld a, [hli]
	cp $ff
	jr z, .is_empty
	or a
	jr nz, .set_carry
	jr .loop_check_empty

.is_empty
; wCurDeckCardChanges is empty (all $0)
; check if name was changed
	call GetPointerToDeckName
	ld de, wCurDeckName
	call EnableSRAM
.loop_name
	ld a, [de]
	cp [hl]
	jr nz, .set_carry
	inc de
	inc hl
	or a
	jr nz, .loop_name
	call DisableSRAM
	ret

.set_carry
	call DisableSRAM
	scf
	ret

; returns carry if doesn't have a valid deck
; aside from the current deck
CheckIfHasOtherValidDecks:
	ld hl, wDecksValid
	lb bc, 0, 0
.loop
	inc b
	ld a, NUM_DECKS
	cp b
	jr c, .check_has_cards
	ld a, [hli]
	or a
	jr z, .loop
	; is valid
	inc c
	ld a, 1
	cp c
	jr nc, .loop ; just 1 valid
	; at least 2 decks are valid
.no_carry
	or a
	ret

.check_has_cards
; doesn't have at least 2 valid decks
; check if current deck is the only one
; that is valid (i.e. has cards)
	call GetPointerToDeckCards
	call EnableSRAM
	ld a, [hl]
	call DisableSRAM
	or a
	jr z, .no_carry ; no cards
	; has cards, is the only valid deck!
	scf
	ret

; checks if wCurDeckCards has any basics
; returns carry set if there is at least
; 1 Basic Pokemon card
CheckIfThereAreAnyBasicCardsInDeck:
	ld hl, wCurDeckCards
.loop_cards
	ld a, [hli]
	ld e, a
	or a
	jr z, .no_carry
	call LoadCardDataToBuffer1_FromCardID
	jr c, .no_carry
	ld a, [wLoadedCard1Type]
	and TYPE_ENERGY
	jr nz, .loop_cards
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .loop_cards
	; is basic card
	scf
	ret
.no_carry
	or a
	ret

FiltersCardSelectionParams:
	db 1 ; x pos
	db 1 ; y pos
	db 0 ; y spacing
	db 2 ; x spacing
	db NUM_FILTERS ; num entries
	db SYM_CURSOR_D ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

FilteredCardListSelectionParams:
	db 0 ; x pos
	db 7 ; y pos
	db 2 ; y spacing
	db 0 ; x spacing
	db NUM_FILTERED_LIST_VISIBLE_CARDS ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

DeckConfigurationMenu_TransitionTable:
	cursor_transition $10, $20, $00, $03, $03, $01, $02
	cursor_transition $48, $20, $00, $04, $04, $02, $00
	cursor_transition $80, $20, $00, $05, $05, $00, $01
	cursor_transition $10, $30, $00, $00, $00, $04, $05
	cursor_transition $48, $30, $00, $01, $01, $05, $03
	cursor_transition $80, $30, $00, $02, $02, $03, $04

; draws each card type icon in a line
; the respective card counts underneath each icon
; and prints"X/60" in the upper-right corner,
; where X is the total card count
DrawCardTypeIconsAndPrintCardCounts:
	call Set_OBJ_8x8
	call PrepareMenuGraphics
	lb bc, 0, 5
	ld a, SYM_BOX_TOP
	call FillBGMapLineWithA
	call DrawCardTypeIcons
	call PrintCardTypeCounts
	lb de, 15, 0
	call PrintTotalCardCount
	lb de, 17, 0
	call PrintSlashSixty
	call EnableLCD
	ret

; fills one line at coordinate bc in BG Map
; with the byte in register a
; fills the same line with $04 in VRAM1 if in CGB
; bc = coordinates
FillBGMapLineWithA:
	call BCCoordToBGMap0Address
	ld b, SCREEN_WIDTH
	call FillDEWithA
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret nz ; return if not CGB
	ld a, $04
	ld b, SCREEN_WIDTH
	call BankswitchVRAM1
	call FillDEWithA
	call BankswitchVRAM0
	ret

; saves the count of each type of card that is in wCurDeckCards
; stores these values in wCardFilterCounts
CountNumberOfCardsForEachCardType:
	ld hl, wCardFilterCounts
	ld de, CardTypeFilters
.loop
	ld a, [de]
	cp -1
	ret z
	inc de
	call CountNumberOfCardsOfType
	ld [hli], a
	jr .loop

; fills de with b bytes of the value in register a
FillDEWithA:
	push hl
	ld l, e
	ld h, d
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	pop hl
	ret

; draws all the card type icons
; in a line specified by .CardTypeIcons
DrawCardTypeIcons:
	ld hl, .CardTypeIcons
.loop
	ld a, [hli]
	or a
	ret z ; done
	ld d, [hl] ; x coord
	inc hl
	ld e, [hl] ; y coord
	inc hl
	call .DrawIcon
	jr .loop

; input:
; de = coordinates
.DrawIcon
	push hl
	push af
	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle
	pop af
	call GetCardTypeIconPalette
	ld b, a
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld a, b
	lb bc, 2, 2
	lb hl, 0, 0
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0
.not_cgb
	pop hl
	ret

.CardTypeIcons
; icon tile, x coord, y coord
	db ICON_TILE_GRASS,      1, 2
	db ICON_TILE_FIRE,       3, 2
	db ICON_TILE_WATER,      5, 2
	db ICON_TILE_LIGHTNING,  7, 2
	db ICON_TILE_FIGHTING,   9, 2
	db ICON_TILE_PSYCHIC,   11, 2
	db ICON_TILE_COLORLESS, 13, 2
	db ICON_TILE_TRAINER,   15, 2
	db ICON_TILE_ENERGY,    17, 2
	db $00

DeckBuildMenuData:
	; x, y, text id
	textitem  2, 2, ConfirmText
	textitem  9, 2, ModifyText
	textitem 16, 2, NameText
	textitem  2, 4, SaveText
	textitem  9, 4, DismantleText
	textitem 16, 4, CancelText
	db $ff

; prints "/60" to the coordinates given in de
PrintSlashSixty:
	ld hl, wDefaultText
	ld a, TX_SYMBOL
	ld [hli], a
	ld a, SYM_SLASH
	ld [hli], a
	ld a, TX_SYMBOL
	ld [hli], a
	ld a, SYM_6
	ld [hli], a
	ld a, TX_SYMBOL
	ld [hli], a
	ld a, SYM_0
	ld [hli], a
	ld [hl], TX_END
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ret

; creates two separate lists given the card type in register a
; if a card matches the card type given, then it's added to wFilteredCardList
; if a card has been owned by the player, and its card count is at least 1,
; (or in case it's 0 if it's in any deck configurations saved)
; then its collection count is also added to wOwnedCardsCountList
; if input a is $ff, then all card types are included
CreateFilteredCardList:
	push af
	push bc
	push de
	push hl

; clear wOwnedCardsCountList and wFilteredCardList
	push af
	ld a, DECK_SIZE
	ld hl, wOwnedCardsCountList
	call ClearMemory_Bank2
	ld a, DECK_SIZE
	ld hl, wFilteredCardList
	call ClearMemory_Bank2
	pop af

; loops all cards in collection
	ld hl, $0
	ld de, $0
	ld b, a ; input card type
.loop_card_ids
	inc e
	call GetCardType
	jr c, .store_count
	ld c, a
	ld a, b
	cp $ff
	jr z, .add_card
	and FILTER_ENERGY
	cp FILTER_ENERGY
	jr z, .check_energy
	ld a, c
	cp b
	jr nz, .loop_card_ids
	jr .add_card
.check_energy
	ld a, c
	and TYPE_ENERGY
	cp TYPE_ENERGY
	jr nz, .loop_card_ids

.add_card
	push bc
	push hl
	ld bc, wFilteredCardList
	add hl, bc
	ld [hl], e
	ld hl, wTempCardCollection
	add hl, de
	ld a, [hl]
	pop hl
	cp CARD_NOT_OWNED
	jr z, .next_card ; jump if never seen card
	or a
	jr nz, .ok ; has at least 1
	call IsCardInAnyDeck
	jr c, .next_card ; jump if not in any deck
.ok
	push hl
	ld bc, wOwnedCardsCountList
	add hl, bc
	ld [hl], a
	pop hl
	inc l
.next_card
	pop bc
	jr .loop_card_ids

.store_count
	ld a, l
	ld [wNumEntriesInCurFilter], a
; add terminator bytes in both lists
	xor a
	ld c, l
	ld b, h
	ld hl, wFilteredCardList
	add hl, bc
	ld [hl], a ; $00
	ld a, $ff
	ld hl, wOwnedCardsCountList
	add hl, bc
	ld [hl], a ; $ff
	pop hl
	pop de
	pop bc
	pop af
	ret

; returns carry if card ID in register e is not
; found in any of the decks saved in SRAM
IsCardInAnyDeck:
	push af
	push hl
	ld hl, sDeck1Cards
	call .FindCardInDeck
	jr nc, .found_card
	ld hl, sDeck2Cards
	call .FindCardInDeck
	jr nc, .found_card
	ld hl, sDeck3Cards
	call .FindCardInDeck
	jr nc, .found_card
	ld hl, sDeck4Cards
	call .FindCardInDeck
	jr nc, .found_card
	pop hl
	pop af
	scf
	ret
.found_card
	pop hl
	pop af
	or a
	ret

; returns carry if input card ID in register e
; is not found in deck given by hl
.FindCardInDeck
	call EnableSRAM
	ld b, DECK_SIZE
.loop
	ld a, [hli]
	cp e
	jr z, .not_found
	dec b
	jr nz, .loop
; not found
	call DisableSRAM
	scf
	ret
.not_found
	call DisableSRAM
	or a
	ret


; zeroes a bytes starting from hl.
; this function is identical to 'ClearMemory_Bank5',
; 'ClearMemory_Bank6' and 'ClearMemory_Bank8'.
; preserves all registers
; input:
;	a = number of bytes to clear
;	hl = where to begin erasing
ClearMemory_Bank2:
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

; returns the number of times that card e
; appears in wCurDeckCards
GetCountOfCardInCurDeck:
	push hl
	ld hl, wCurDeckCards
	ld d, 0
.loop
	ld a, [hli]
	or a
	jr z, .done
	cp e
	jr nz, .loop
	inc d
	jr .loop
.done
	ld a, d
	pop hl
	ret

; returns total count of card ID e
; looks it up in wFilteredCardList
; then uses the index to retrieve the count
; value from wOwnedCardsCountList
GetOwnedCardCount:
	push hl
	ld hl, wFilteredCardList
	ld d, -1
.loop
	inc d
	ld a, [hli]
	or a
	jr z, .not_found
	cp e
	jr nz, .loop
	ld hl, wOwnedCardsCountList
	push de
	ld e, d
	ld d, $00
	add hl, de
	pop de
	ld a, [hl]
	pop hl
	ret
.not_found
	xor a
	pop hl
	ret

; appends text "X/Y", where X is the number of included cards
; and Y is the total number of cards in storage of a given card ID
; input:
; e = card ID
AppendOwnedCardCountAndStorageCountNumbers:
	push af
	push bc
	push de
	push hl
; count how many bytes until $00
.loop
	ld a, [hl]
	or a
	jr z, .print
	inc hl
	jr .loop
.print
	push de
	call GetCountOfCardInCurDeck
	call ConvertToNumericalDigits
	ld [hl], TX_SYMBOL
	inc hl
	ld [hl], SYM_SLASH
	inc hl
	pop de
	call GetOwnedCardCount
	call ConvertToNumericalDigits
	ld [hl], TX_END
	pop hl
	pop de
	pop bc
	pop af
	ret

; determines the ones and tens digits in a for printing
; the ones place is added $20 (SYM_0) so that it maps to a numerical character
; if the tens is 0, it maps to an empty character
; a = value to calculate digits
CalculateOnesAndTensDigits:
	push af
	push bc
	push de
	push hl
	ld c, -1
.loop
	inc c
	sub 10
	jr nc, .loop
	jr z, .zero1
	add 10
	; a = a mod 10
	; c = floor(a / 10)
.zero1
; ones digit
	add SYM_0
	ld hl, wDecimalDigitsSymbols
	ld [hli], a

; tens digit
	ld a, c
	or a
	jr z, .zero2
	add SYM_0
.zero2
	ld [hl], a

	pop hl
	pop de
	pop bc
	pop af
	ret

; converts value in register a to
; numerical symbols for ProcessText
; places the symbols in hl
ConvertToNumericalDigits:
	call CalculateOnesAndTensDigits
	push hl
	ld hl, wDecimalDigitsSymbols
	ld a, [hli]
	ld b, a
	ld a, [hl]
	pop hl
	ld [hl], TX_SYMBOL
	inc hl
	ld [hli], a
	ld [hl], TX_SYMBOL
	inc hl
	ld a, b
	ld [hli], a
	ret

; counts the number of cards in wCurDeckCards
; that are the same type as input in register a
; if input is $20, counts all energy cards instead
; input:
; - a = card type
; output:
; - a = number of cards of same type
CountNumberOfCardsOfType:
	push de
	push hl
	ld hl, $0
	ld b, a
	ld c, 0
.loop_cards
	push hl
	push bc
	ld bc, wCurDeckCards
	add hl, bc
	ld a, [hl]
	pop bc
	pop hl
	inc l
	or a
	jr z, .done ; end of card list

; get card type and compare it with input type
; if input is FILTER_ENERGY, run a separate comparison
; if it's the same type, increase the count
	ld e, a
	call GetCardType
	jr c, .done
	push hl
	ld l, a
	ld a, b
	and FILTER_ENERGY
	cp FILTER_ENERGY
	jr z, .check_energy
	ld a, l
	pop hl
	cp b
	jr nz, .loop_cards
	jr .incr_count

; counts all energy cards as the same
.check_energy
	ld a, l
	pop hl
	and TYPE_ENERGY
	cp TYPE_ENERGY
	jr nz, .loop_cards
.incr_count
	inc c
	jr .loop_cards
.done
	ld a, c
	pop hl
	pop de
	ret

; prints the card count of each individual card type
; assumes CountNumberOfCardsForEachCardType was already called
; this is done by processing text in a single line
; and concatenating all digits
PrintCardTypeCounts:
	ld bc, $0
	ld hl, wDefaultText
.loop
	push hl
	ld hl, wCardFilterCounts
	add hl, bc
	ld a, [hl]
	pop hl
	push bc
	call ConvertToNumericalDigits
	pop bc
	inc c
	ld a, NUM_FILTERS
	cp c
	jr nz, .loop
	ld [hl], TX_END
	lb de, 1, 4
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ret

; prints the list of cards, applying the filter from register a
; the counts of each card displayed is taken from wCurDeck
; a = card type filter
PrintFilteredCardList:
	push af
	ld hl, CardTypeFilters
	ld b, $00
	ld c, a
	add hl, bc
	ld a, [hl]
	push af

; copy sCardCollection to wTempCardCollection
	call EnableSRAM
	ld hl, sCardCollection
	ld de, wTempCardCollection
	ld b, CARD_COLLECTION_SIZE - 1
	call CopyNBytesFromHLToDE
	call DisableSRAM

	ld a, [wIncludeCardsInDeck]
	or a
	jr z, .ok
	call GetPointerToDeckCards
	ld d, h
	ld e, l
	call IncrementDeckCardsInTempCollection
.ok
	pop af

	call CreateFilteredCardList
	ld a, NUM_FILTERED_LIST_VISIBLE_CARDS
	ld [wNumVisibleCardListEntries], a
	lb de, 1, 7
	ld hl, wCardListCoords
	ld [hl], e
	inc hl
	ld [hl], d
	call PrintDeckBuildingCardList
	pop af
	ret

; used to filter the cards in the deck building/card selection screen
CardTypeFilters:
	db FILTER_GRASS
	db FILTER_FIRE
	db FILTER_WATER
	db FILTER_LIGHTNING
	db FILTER_FIGHTING
	db FILTER_PSYCHIC
	db FILTER_COLORLESS
	db FILTER_TRAINER
	db FILTER_ENERGY
	db -1 ; end of list

; counts all the cards from each card type
; (stored in wCardFilterCounts) and store it in wTotalCardCount
; also prints it in coordinates de
PrintTotalCardCount:
	push de
	ld bc, $0
	ld hl, wCardFilterCounts
.loop
	ld a, [hli]
	add b
	ld b, a
	inc c
	ld a, NUM_FILTERS
	cp c
	jr nz, .loop
	ld hl, wDefaultText
	ld a, b
	ld [wTotalCardCount], a
	push bc
	call ConvertToNumericalDigits
	pop bc
	ld [hl], TX_END
	pop de
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ret

; prints the name, level and storage count of the cards
; that are visible in the list window
; in the form:
; CARD NAME/LEVEL X/Y
; where X is the current count of that card
; and Y is the storage count of that card
PrintDeckBuildingCardList:
	push bc
	ld hl, wCardListCoords
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, 19 ; x coord
	ld c, e
	dec c
	ld a, [wCardListVisibleOffset]
	or a
	jr z, .no_cursor
	ld a, SYM_CURSOR_U
	jr .got_cursor_tile
.no_cursor
	ld a, SYM_SPACE
.got_cursor_tile
	call WriteByteToBGMap0

; iterates by decreasing value in wNumVisibleCardListEntries
; by 1 until it reaches 0
	ld a, [wCardListVisibleOffset]
	ld c, a
	ld b, $0
	ld hl, wFilteredCardList
	add hl, bc
	ld a, [wNumVisibleCardListEntries]
.loop_filtered_cards
	push de
	or a
	jr z, .exit_loop
	ld b, a
	ld a, [hli]
	or a
	jr z, .invalid_card ; card ID of 0
	ld e, a
	call AddCardIDToVisibleList
	call LoadCardDataToBuffer1_FromCardID
	ld a, 13
	push bc
	push hl
	push de
	call CopyCardNameAndLevel
	pop de
	call AppendOwnedCardCountAndStorageCountNumbers
	pop hl
	pop bc
	pop de
	push hl
	call InitTextPrinting
	ld hl, wDefaultText
	jr .process_text

.invalid_card
	pop de
	push hl
	call InitTextPrinting
	ld hl, Text_9a30
.process_text
	call ProcessText
	pop hl

	ld a, b
	dec a
	inc e
	inc e
	jr .loop_filtered_cards

.exit_loop
	ld a, [hli]
	or a
	jr z, .cannot_scroll
	pop de
; draw down cursor because
; there are still more cards
; to be scrolled down
	xor a ; FALSE
	ld [wUnableToScrollDown], a
	ld a, SYM_CURSOR_D
	jr .draw_cursor
.cannot_scroll
	pop de
	ld a, TRUE
	ld [wUnableToScrollDown], a
	ld a, SYM_SPACE
.draw_cursor
	ld b, 19 ; x coord
	ld c, e
	dec c
	dec c
	call WriteByteToBGMap0
	pop bc
	ret

Text_9a30:
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
Text_9a36:
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	db "<SPACE>"
	done

; writes the card ID in register e to wVisibleListCardIDs
; given its position in the list in register b
; input:
; b = list position (starts from bottom)
; e = card ID
AddCardIDToVisibleList:
	push af
	push bc
	push hl
	ld hl, wVisibleListCardIDs
	ld c, b
	ld a, [wNumVisibleCardListEntries]
	sub c
	ld c, a ; wNumVisibleCardListEntries - b
	ld b, $0
	add hl, bc
	ld [hl], e
	pop hl
	pop bc
	pop af
	ret

; copies data from hl to:
; wCardListCursorXPos
; wCardListCursorYPos
; wCardListYSpacing
; wCardListXSpacing
; wCardListNumCursorPositions
; wVisibleCursorTile
; wInvisibleCursorTile
; wCardListHandlerFunction
InitCardSelectionParams:
	ld [wCardListCursorPos], a
	ld [hffb3], a
	ld de, wCardListCursorXPos
	ld b, $9
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	ret

HandleCardSelectionInput:
	xor a ; FALSE
	ld [wMenuInputSFX], a
	ldh a, [hDPadHeld]
	or a
	jr z, .handle_ab_btns

; handle d-pad
	ld b, a
	ld a, [wCardListNumCursorPositions]
	ld c, a
	ld a, [wCardListCursorPos]
	bit D_LEFT_F, b
	jr z, .check_d_right
	dec a
	bit 7, a
	jr z, .got_cursor_pos
	; if underflow, set to max cursor pos
	ld a, [wCardListNumCursorPositions]
	dec a
	jr .got_cursor_pos
.check_d_right
	bit D_RIGHT_F, b
	jr z, .handle_ab_btns
	inc a
	cp c
	jr c, .got_cursor_pos
	; if over max pos, set to pos 0
	xor a
.got_cursor_pos
	push af
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	call DrawHorizontalListCursor_Invisible
	pop af
	ld [wCardListCursorPos], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a

.handle_ab_btns
	ld a, [wCardListCursorPos]
	ld [hffb3], a
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, HandleCardSelectionCursorBlink
	and A_BUTTON
	jr nz, ConfirmSelectionAndReturnCarry
	; b button
	ld a, $ff
	ld [hffb3], a
	call PlaySFXConfirmOrCancel
	scf
	ret

; outputs cursor position in e and selection in a
ConfirmSelectionAndReturnCarry:
	call DrawHorizontalListCursor_Visible
	ld a, $01
	call PlaySFXConfirmOrCancel
	ld a, [wCardListCursorPos]
	ld e, a
	ld a, [hffb3]
	scf
	ret

HandleCardSelectionCursorBlink:
	ld a, [wMenuInputSFX]
	or a
	jr z, .skip_sfx
	call PlaySFX
.skip_sfx
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	ld a, [wVisibleCursorTile]
	bit 4, [hl]
	jr z, DrawHorizontalListCursor

DrawHorizontalListCursor_Invisible:
	ld a, [wInvisibleCursorTile]
;	fallthrough

; like DrawListCursor but only
; for lists with one line, and each entry
; being laid horizontally
; a = tile to write
DrawHorizontalListCursor:
	ld e, a
	ld a, [wCardListXSpacing]
	ld l, a
	ld a, [wCardListCursorPos]
	ld h, a
	call HtimesL
	ld a, l
	ld hl, wCardListCursorXPos
	add [hl]
	ld b, a ; x coord
	ld hl, wCardListCursorYPos
	ld a, [hl]
	ld c, a ; y coord
	ld a, e
	call WriteByteToBGMap0
	or a
	ret

DrawHorizontalListCursor_Visible:
	ld a, [wVisibleCursorTile]
	jr DrawHorizontalListCursor

; handles user input when selecting cards to add
; to deck configuration
; returns carry if a selection was made
; (either selected card or cancelled)
; outputs in a the list index if selection was made
; or $ff if operation was cancelled
HandleDeckCardSelectionList:
	xor a ; FALSE
	ld [wMenuInputSFX], a

	ldh a, [hDPadHeld]
	or a
	jp z, .asm_9bb9

	ld b, a
	ld a, [wCardListNumCursorPositions]
	ld c, a
	ld a, [wCardListCursorPos]
	bit D_UP_F, b
	jr z, .check_d_down
	push af
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	pop af
	dec a
	bit 7, a
	jr z, .asm_9b8f
	ld a, [wCardListVisibleOffset]
	or a
	jr z, .asm_9b5a
	dec a
	ld [wCardListVisibleOffset], a
	ld hl, wCardListUpdateFunction
	call CallIndirect
	xor a
	jr .asm_9b8f
.asm_9b5a
	xor a
	ld [wMenuInputSFX], a
	jr .asm_9b8f

.check_d_down
	bit D_DOWN_F, b
	jr z, .asm_9b9d
	push af
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	pop af
	inc a
	cp c
	jr c, .asm_9b8f
	push af
	ld a, [wUnableToScrollDown]
	or a
	jr nz, .cannot_scroll_down
	ld a, [wCardListVisibleOffset]
	inc a
	ld [wCardListVisibleOffset], a
	ld hl, wCardListUpdateFunction
	call CallIndirect
	pop af
	dec a
	jr .asm_9b8f

.cannot_scroll_down
	pop af
	dec a
	push af
	xor a ; FALSE
	ld [wMenuInputSFX], a
	pop af

.asm_9b8f
	push af
	call DrawListCursor_Invisible
	pop af
	ld [wCardListCursorPos], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	jr .asm_9bb9
.asm_9b9d
	ld a, [wced2]
	or a
	jr z, .asm_9bb9

	bit D_LEFT_F, b
	jr z, .check_d_right
	call GetSelectedVisibleCardID
	call RemoveCardFromDeckAndUpdateCount
	jr .asm_9bb9
.check_d_right
	bit D_RIGHT_F, b
	jr z, .asm_9bb9
	call GetSelectedVisibleCardID
	call AddCardToDeckAndUpdateCount

.asm_9bb9
	ld a, [wCardListCursorPos]
	ld [hffb3], a
	ld hl, wCardListHandlerFunction
	ld a, [hli]
	or [hl]
	jr z, .handle_ab_btns

	; this code seemingly never runs
	; because wCardListHandlerFunction is always NULL
	ld a, [hld]
	ld l, [hl]
	ld h, a
	ld a, [hffb3]
	call CallHL
	jr nc, .handle_blink

.select_card
	call DrawListCursor_Visible
	ld a, $01
	call PlaySFXConfirmOrCancel
	ld a, [wCardListCursorPos]
	ld e, a
	ld a, [hffb3]
	scf
	ret

.handle_ab_btns
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .check_sfx
	and A_BUTTON
	jr nz, .select_card
	ld a, $ff
	ld [hffb3], a
	call PlaySFXConfirmOrCancel
	scf
	ret

.check_sfx
	ld a, [wMenuInputSFX]
	or a
	jr z, .handle_blink
	call PlaySFX
.handle_blink
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	ld a, [wVisibleCursorTile]
	bit 4, [hl]
	jr z, DrawListCursor
;	fallthrough

DrawListCursor_Invisible:
	ld a, [wInvisibleCursorTile]
;	fallthrough

; draws cursor considering wCardListCursorPos
; spaces each entry horizontally by wCardListXSpacing
; and vertically by wCardListYSpacing
; a = tile to write
DrawListCursor:
	ld e, a
	ld a, [wCardListXSpacing]
	ld l, a
	ld a, [wCardListCursorPos]
	ld h, a
	call HtimesL
	ld a, l
	ld hl, wCardListCursorXPos
	add [hl]
	ld b, a ; x coord
	ld a, [wCardListYSpacing]
	ld l, a
	ld a, [wCardListCursorPos]
	ld h, a
	call HtimesL
	ld a, l
	ld hl, wCardListCursorYPos
	add [hl]
	ld c, a ; y coord
	ld a, e
	call WriteByteToBGMap0
	or a
	ret

DrawListCursor_Visible:
	ld a, [wVisibleCursorTile]
	jr DrawListCursor

OpenCardPageFromCardList:
; get the card index that is selected
; and open its card page
	ld hl, wCurCardListPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCardListCursorPos]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wCardListVisibleOffset]
	ld c, a
	ld b, $0
	add hl, bc
	ld e, [hl]
	ld d, $0
	push de
	call LoadCardDataToBuffer1_FromCardID
	lb de, $38, $9f
	call SetupText
	bank1call OpenCardPage_FromCheckHandOrDiscardPile
	pop de

.handle_input
	ldh a, [hDPadHeld]
	ld b, a
	and A_BUTTON | B_BUTTON | SELECT | START
	jp nz, .exit

; check d-pad
; if UP or DOWN is pressed, change the
; card that is being shown, given the
; order in the current card list
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
	pop af
	dec a
	bit 7, a
	jr z, .reopen_card_page
	ld a, [wCardListVisibleOffset]
	or a
	jr z, .handle_regular_card_page_input
	dec a
	ld [wCardListVisibleOffset], a
	xor a
	jr .reopen_card_page

.check_d_down
	bit D_DOWN_F, b
	jr z, .handle_regular_card_page_input
	push af
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	pop af
	inc a
	cp c
	jr c, .reopen_card_page
	push af
	ld hl, wCurCardListPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCardListCursorPos]
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wCardListVisibleOffset]
	inc a
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	or a
	jr z, .skip_change_card
	ld a, [wCardListVisibleOffset]
	inc a
	ld [wCardListVisibleOffset], a
	pop af
	dec a
.reopen_card_page
	ld [wCardListCursorPos], a
	ld a, [wMenuInputSFX]
	or a
	jp z, OpenCardPageFromCardList
	call PlaySFX
	jp OpenCardPageFromCardList

.skip_change_card
	pop af
	jr .handle_regular_card_page_input ; unnecessary jr
.handle_regular_card_page_input
	push de
	bank1call OpenCardPage.input_loop
	pop de
	jp .handle_input

.exit
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a
	ret

; opens card page from the card list
Func_9ced: ; unreferenced
	ld hl, wVisibleListCardIDs
	ld a, [wCardListCursorPos]
	ld c, a
	ld b, $00
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	call LoadCardDataToBuffer1_FromCardID
	ld de, $389f
	call SetupText
	bank1call OpenCardPage_FromHand
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret

; adds card in register e to deck configuration
; and updates the values shown for its count
; in the card selection list
; input:
; e = card ID
AddCardToDeckAndUpdateCount:
	call TryAddCardToDeck
	ret c ; failed to add card
	push de
	call PrintCardTypeCounts
	lb de, 15, 0
	call PrintTotalCardCount
	pop de
	call GetCountOfCardInCurDeck
	call PrintNumberValueInCursorYPos
	ret

; tries to add card ID in register e to wCurDeckCards
; fails to add card if one of the following conditions are met:
; - total cards are equal to wMaxNumCardsAllowed
; - cards with the same name as it reached the allowed limit
; - player doesn't own more copies in the collection
; returns carry if fails
; otherwise, writes card ID to first empty slot in wCurDeckCards
; input:
; e = card ID
TryAddCardToDeck:
	ld a, [wMaxNumCardsAllowed]
	ld d, a
	ld a, [wTotalCardCount]
	cp d
	jr nz, .not_equal
	; wMaxNumCardsAllowed == wTotalCardCount
	scf
	ret

.not_equal
	push de
	call .CheckIfCanAddCardWithSameName
	pop de
	ret c ; cannot add more cards with this name

	push de
	call GetCountOfCardInCurDeck
	ld b, a
	ld hl, wOwnedCardsCountList
	ld d, $0
	ld a, [wCardListVisibleOffset]
	ld e, a
	add hl, de
	ld a, [wCardListCursorPos]
	ld e, a
	add hl, de
	ld d, [hl]
	ld a, b
	cp d
	pop de
	scf
	ret z ; cannot add because player doesn't own more copies

	ld a, SFX_CURSOR
	call PlaySFX
	push de
	call .AddCardToCurDeck
	ld a, [wCurCardTypeFilter]
	ld c, a
	ld b, $0
	ld hl, wCardFilterCounts
	add hl, bc
	inc [hl]
	pop de
	or a
	ret

; finds first empty slot in wCurDeckCards
; then writes the value in e to it
.AddCardToCurDeck
	ld hl, wCurDeckCards
.loop
	ld a, [hl]
	or a
	jr z, .empty
	inc hl
	jr .loop
.empty
	ld [hl], e
	inc hl
	xor a
	ld [hl], a
	ret

; returns carry if card ID in e cannot be
; added to the current deck configuration
; due to having reached the maximum number
; of cards allowed with that same name
; e = card id
.CheckIfCanAddCardWithSameName
	call LoadCardDataToBuffer1_FromCardID
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY_DOUBLE_COLORLESS
	jr z, .double_colorless
	; basic energy cards have no limit
	and TYPE_ENERGY
	cp TYPE_ENERGY
	jr z, .exit ; return if basic energy card
.double_colorless

; compare this card's name to
; the names of cards in list wCurDeckCards
	ld a, [wLoadedCard1Name + 0]
	ld c, a
	ld a, [wLoadedCard1Name + 1]
	ld b, a
	ld hl, wCurDeckCards
	ld d, 0
	push de
.loop_cards
	ld a, [hli]
	or a
	jr z, .exit_pop_de
	ld e, a
	ld d, $0
	call GetCardName
	ld a, e
	cp c
	jr nz, .loop_cards
	ld a, d
	cp b
	jr nz, .loop_cards
	; has same name
	pop de
	inc d ; increment counter of cards with this name
	ld a, [wSameNameCardsLimit]
	cp d
	push de
	jr nz, .loop_cards
	; reached the maximum number
	; of cards with same name allowed
	pop de
	scf
	ret

.exit_pop_de
	pop de
.exit
	or a
	ret

; gets the element in wVisibleListCardIDs
; corresponding to index wCardListCursorPos
GetSelectedVisibleCardID:
	ld hl, wVisibleListCardIDs
	ld a, [wCardListCursorPos]
	ld e, a
	ld d, $00
	add hl, de
	ld e, [hl]
	ret

; appends the digits of value in register a to wDefaultText
; then prints it in cursor Y position
; a = value to convert to numerical digits
PrintNumberValueInCursorYPos:
	ld hl, wDefaultText
	call ConvertToNumericalDigits
	ld [hl], TX_END
	ld a, [wCardListYSpacing]
	ld l, a
	ld a, [wCardListCursorPos]
	ld h, a
	call HtimesL
	ld a, l
	ld hl, wCardListCursorYPos
	add [hl]
	ld e, a
	ld d, 14
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ret

; removes card in register e from deck configuration
; and updates the values shown for its count
; in the card selection list
; input:
; e = card ID
RemoveCardFromDeckAndUpdateCount:
	call RemoveCardFromDeck
	ret nc
	push de
	call PrintCardTypeCounts
	lb de, 15, 0
	call PrintTotalCardCount
	pop de
	call GetCountOfCardInCurDeck
	call PrintNumberValueInCursorYPos
	ret

; removes card ID in e from wCurDeckCards
RemoveCardFromDeck:
	push de
	call GetCountOfCardInCurDeck
	pop de
	or a
	ret z ; card is not in deck
	ld a, SFX_CURSOR
	call PlaySFX
	push de
	call .RemoveCard
	ld a, [wCurCardTypeFilter]
	ld c, a
	ld b, $0
	ld hl, wCardFilterCounts
	add hl, bc
	dec [hl]
	pop de
	scf
	ret

; remove first card instance of card ID in e
; and shift all elements up by one
.RemoveCard
	ld hl, wCurDeckCards
	ld d, 0 ; unnecessary
.loop_1
	inc d ; unnecessary
	ld a, [hli]
	cp e
	jr nz, .loop_1
	ld c, l
	ld b, h
	dec bc

.loop_2
	inc d ; unnecessary
	ld a, [hli]
	or a
	jr z, .done
	ld [bc], a
	inc bc
	jr .loop_2

.done
	xor a
	ld [bc], a
	ret

UpdateConfirmationCardScreen:
	ld hl, hffb0
	ld [hl], $01
	call PrintCurDeckNumberAndName
	ld hl, hffb0
	ld [hl], $00
	jp PrintConfirmationCardList

HandleDeckConfirmationMenu:
; if deck is empty, just show deck info header with empty card list
	ld a, [wTotalCardCount]
	or a
	jp z, ShowDeckInfoHeaderAndWaitForBButton

; create list of all unique cards
	call SortCurDeckCardsByID
	call CreateCurDeckUniqueCardList

	xor a
	ld [wCardListVisibleOffset], a
.init_params
	ld hl, .CardSelectionParams
	call InitCardSelectionParams
	ld a, [wNumUniqueCards]
	ld [wNumCardListEntries], a
	cp NUM_DECK_CONFIRMATION_VISIBLE_CARDS
	jr c, .no_cap
	ld a, NUM_DECK_CONFIRMATION_VISIBLE_CARDS
.no_cap
	ld [wCardListNumCursorPositions], a
	ld [wNumVisibleCardListEntries], a
	call ShowConfirmationCardScreen

	ld hl, UpdateConfirmationCardScreen
	ld d, h
	ld a, l
	ld hl, wCardListUpdateFunction
	ld [hli], a
	ld [hl], d

	xor a
	ld [wced2], a
.loop_input
	call DoFrame
	call HandleDeckCardSelectionList
	jr c, .selection_made
	call HandleLeftRightInCardList
	jr c, .loop_input
	ldh a, [hDPadHeld]
	and START
	jr z, .loop_input

.selected_card
	ld a, $01
	call PlaySFXConfirmOrCancel
	ld a, [wCardListCursorPos]
	ld [wced7], a

	; set wUniqueDeckCardList as current card list
	; and show card page screen
	ld de, wUniqueDeckCardList
	ld hl, wCurCardListPtr
	ld [hl], e
	inc hl
	ld [hl], d
	call OpenCardPageFromCardList
	jr .init_params

.selection_made
	ld a, [hffb3]
	cp $ff
	ret z ; operation cancelled
	jr .selected_card

.CardSelectionParams
	db 0 ; x pos
	db 5 ; y pos
	db 2 ; y spacing
	db 0 ; x spacing
	db 7 ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

; handles pressing left/right in card lists
; scrolls up/down a number of wCardListNumCursorPositions
; entries respectively
; returns carry if scrolling happened
HandleLeftRightInCardList:
	ld a, [wCardListNumCursorPositions]
	ld d, a
	ld a, [wCardListVisibleOffset]
	ld c, a
	ldh a, [hDPadHeld]
	cp D_RIGHT
	jr z, .right
	cp D_LEFT
	jr z, .left
	or a
	ret

.right
	ld a, [wCardListVisibleOffset]
	add d
	ld b, a
	add d
	ld hl, wNumCardListEntries
	cp [hl]
	jr c, .got_new_pos
	ld a, [wNumCardListEntries]
	sub d
	ld b, a
	jr .got_new_pos

.left
	ld a, [wCardListVisibleOffset]
	sub d
	ld b, a
	jr nc, .got_new_pos
	ld b, 0 ; first index
.got_new_pos
	ld a, b
	ld [wCardListVisibleOffset], a
	cp c
	jr z, .asm_9efa
	ld a, SFX_CURSOR
	call PlaySFX
	ld hl, wCardListUpdateFunction
	call CallIndirect
.asm_9efa
	scf
	ret

; handles scrolling up and down with Select button
; in this case, the cursor position goes up/down
; by wCardListNumCursorPositions entries respectively
; return carry if scrolling happened, otherwise no carry
HandleSelectUpAndDownInList:
	ld a, [wCardListNumCursorPositions]
	ld d, a
	ld a, [wCardListVisibleOffset]
	ld c, a
	ldh a, [hDPadHeld]
	cp SELECT | D_DOWN
	jr z, .sel_down
	cp SELECT | D_UP
	jr z, .sel_up
	or a
	ret

.sel_down
	ld a, [wCardListVisibleOffset]
	add d
	ld b, a ; wCardListVisibleOffset + wCardListNumCursorPositions
	add d
	ld hl, wNumCardListEntries
	cp [hl]
	jr c, .got_new_pos
	ld a, [wNumCardListEntries]
	sub d
	ld b, a ; wNumCardListEntries - wCardListNumCursorPositions
	jr .got_new_pos
.sel_up
	ld a, [wCardListVisibleOffset]
	sub d
	ld b, a ; wCardListVisibleOffset - wCardListNumCursorPositions
	jr nc, .got_new_pos
	ld b, 0 ; go to first position

.got_new_pos
	ld a, b
	ld [wCardListVisibleOffset], a
	cp c
	jr z, .set_carry
	ld a, SFX_CURSOR
	call PlaySFX
	ld hl, wCardListUpdateFunction
	call CallIndirect
.set_carry
	scf
	ret

; simply draws the deck info header
; then awaits a b button press to exit
ShowDeckInfoHeaderAndWaitForBButton:
	call ShowDeckInfoHeader
.wait_input
	call DoFrame
	ldh a, [hKeysPressed]
	and B_BUTTON
	jr z, .wait_input
	ld a, $ff
	call PlaySFXConfirmOrCancel
	ret

ShowConfirmationCardScreen:
	call ShowDeckInfoHeader
	lb de, 3, 5
	ld hl, wCardListCoords
	ld [hl], e
	inc hl
	ld [hl], d
	call PrintConfirmationCardList
	ret

; counts all values stored in wCardFilterCounts
; if the total count is 0, then
; prints "No cards chosen."
TallyCardsInCardFilterLists:
	lb bc, 0, 0
	ld hl, wCardFilterCounts
.loop
	ld a, [hli]
	add b
	ld b, a
	inc c
	ld a, NUM_FILTERS
	cp c
	jr nz, .loop
	ld a, b
	or a
	ret nz
	lb de, 11, 1
	call InitTextPrinting
	ldtx hl, NoCardsChosenText
	call ProcessTextFromID
	ret

; draws a box on the top of the screen
; with wCurDeck's number, name and card count
; and draws the Hand Cards icon if it's
; the current dueling deck
ShowDeckInfoHeader:
	call EmptyScreenAndLoadFontDuelAndHandCardsIcons
	lb de, 0, 0
	lb bc, 20, 4
	call DrawRegularTextBox
	ld a, [wCurDeckName]
	or a
	jp z, .print_card_count ; can be jr

; draw hand cards icon if it's the current dueling deck
	call PrintCurDeckNumberAndName
	ld a, [wCurDeck]
	ld b, a
	call EnableSRAM
	ld a, [sCurrentlySelectedDeck]
	call DisableSRAM
	cp b
	jr nz, .print_card_count
	lb de, 2, 1
	call DrawHandCardsTileAtDE

.print_card_count
	lb de, 14, 1
	call PrintTotalCardCount
	lb de, 16, 1
	call PrintSlashSixty
	call TallyCardsInCardFilterLists
	call EnableLCD
	ret

; prints the name of wCurDeck in the form
; "X・ <deck name> deck", where X is the number
; of the deck in the given menu
; if no current deck, print blank line
PrintCurDeckNumberAndName:
	ld a, [wCurDeck]
	cp $ff
	jr z, .skip_deck_numeral

; print the deck number in the menu
; in the form "X・"
	lb de, 3, 2
	call InitTextPrinting
	ld a, [wCurDeck]
	bit 7, a
	jr z, .incr_by_one
	and $7f
	jr .got_deck_numeral
.incr_by_one
	inc a
.got_deck_numeral
	ld hl, wDefaultText
	call ConvertToNumericalDigits
	ld [hl], "FW0_・"
	inc hl
	ld [hl], TX_END
	ld hl, wDefaultText
	call ProcessText

.skip_deck_numeral
	ld hl, wCurDeckName
	ld de, wDefaultText
	call CopyListFromHLToDE
	ld a, [wCurDeck]
	cp $ff
	jr z, .blank_deck_name

; print "<deck name> deck"
	ld hl, wDefaultText
	call GetTextLengthInTiles
	ld b, $0
	ld hl, wDefaultText
	add hl, bc
	ld d, h
	ld e, l
	ld hl, DeckNameSuffix
	call CopyListFromHLToDE
	lb de, 6, 2
	ld hl, wDefaultText
	call InitTextPrinting
	call ProcessText
	ret

.blank_deck_name
	lb de, 2, 2
	ld hl, wDefaultText
	call InitTextPrinting
	call ProcessText
	ret

; sorts wCurDeckCards by ID
SortCurDeckCardsByID:
; wOpponentDeck is used to temporarily store deck's cards
; so that it can be later sorted by ID
	ld hl, wCurDeckCards
	ld de, wOpponentDeck
	ld bc, wDuelTempList
	ld a, -1
	ld [bc], a
.loop_copy
	inc a ; incr deck index
	push af
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr z, .sort_cards
	pop af
	ld [bc], a ; store deck index
	inc bc
	jr .loop_copy

.sort_cards
	pop af
	ld a, $ff ; terminator byte for wDuelTempList
	ld [bc], a

; force Opp Turn so that SortCardsInDuelTempListByID can be used
	ldh a, [hWhoseTurn]
	push af
	ld a, OPPONENT_TURN
	ldh [hWhoseTurn], a
	call SortCardsInDuelTempListByID
	pop af
	ldh [hWhoseTurn], a

; given the ordered cards in wOpponentDeck,
; each entry in it corresponds to its deck index
; (first ordered card is deck index 0, second is deck index 1, etc)
; place these in this order in wCurDeckCards
	ld hl, wCurDeckCards
	ld de, wDuelTempList
.loop_order_by_deck_index
	ld a, [de]
	cp $ff
	jr z, .done
	ld c, a
	ld b, $0
	push hl
	ld hl, wOpponentDeck
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hli], a
	inc de
	jr .loop_order_by_deck_index

.done
	xor a
	ld [hl], a
	ret

; goes through list in wCurDeckCards, and for each card in it
; creates list in wUniqueDeckCardList of all unique cards
; it finds (assuming wCurDeckCards is sorted by ID)
; also counts the total number of the different cards
CreateCurDeckUniqueCardList:
	ld b, 0
	ld c, $0
	ld hl, wCurDeckCards
	ld de, wUniqueDeckCardList
.loop
	ld a, [hli]
	cp c
	jr z, .loop
	ld c, a
	ld [de], a
	inc de
	or a
	jr z, .done
	inc b
	jr .loop
.done
	ld a, b
	ld [wNumUniqueCards], a
	ret

; prints the list of cards visible in the window
; of the confirmation screen
; card info is presented with name, level and
; its count preceded by "x"
PrintConfirmationCardList:
	push bc
	ld hl, wCardListCoords
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, 19 ; x coord
	ld c, e
	dec c
	ld a, [wCardListVisibleOffset]
	or a
	jr z, .no_cursor
	ld a, SYM_CURSOR_U
	jr .got_cursor_tile_1
.no_cursor
	ld a, SYM_SPACE
.got_cursor_tile_1
	call WriteByteToBGMap0

; iterates by decreasing value in wNumVisibleCardListEntries
; by 1 until it reaches 0
	ld a, [wCardListVisibleOffset]
	ld c, a
	ld b, $0
	ld hl, wOwnedCardsCountList
	add hl, bc
	ld a, [wNumVisibleCardListEntries]
.loop_cards
	push de
	or a
	jr z, .exit_loop
	ld b, a
	ld a, [hli]
	or a
	jr z, .no_more_cards
	ld e, a
	call AddCardIDToVisibleList
	call LoadCardDataToBuffer1_FromCardID
	; places in wDefaultText the card's name and level
	; then appends at the end "x" with the count of that card
	; draws the card's type icon as well
	ld a, 13
	push bc
	push hl
	push de
	call CopyCardNameAndLevel
	pop de
	call .PrintCardCount
	pop hl
	pop bc
	pop de
	call .DrawCardTypeIcon
	push hl
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	pop hl
	ld a, b
	dec a
	inc e
	inc e
	jr .loop_cards

.exit_loop
	ld a, [hli]
	or a
	jr z, .no_more_cards
	pop de
	xor a ; FALSE
	ld [wUnableToScrollDown], a
	ld a, SYM_CURSOR_D
	jr .got_cursor_tile_2

.no_more_cards
	pop de
	ld a, TRUE
	ld [wUnableToScrollDown], a
	ld a, SYM_SPACE
.got_cursor_tile_2
	ld b, 19 ; x coord
	ld c, e
	dec c
	dec c
	call WriteByteToBGMap0
	pop bc
	ret

; prints the card count preceded by a cross
; for example "x42"
.PrintCardCount
	push af
	push bc
	push de
	push hl
.loop_search
	ld a, [hl]
	or a
	jr z, .found_card_id
	inc hl
	jr .loop_search
.found_card_id
	call GetCountOfCardInCurDeck
	ld [hl], TX_SYMBOL
	inc hl
	ld [hl], SYM_CROSS
	inc hl
	call ConvertToNumericalDigits
	ld [hl], TX_END
	pop hl
	pop de
	pop bc
	pop af
	ret

; draws the icon corresponding to the loaded card's type
; can be any of Pokemon stages (basic, 1st and 2nd stage)
; Energy or Trainer
; draws it 2 tiles to the left and 1 up to
; the current coordinate in de
.DrawCardTypeIcon
	push hl
	push de
	push bc
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .not_pkmn_card

; pokemon card
	ld a, [wLoadedCard1Stage]
	ld b, a
	add b
	add b
	add b ; *4
	add ICON_TILE_BASIC_POKEMON
	jr .got_tile

.not_pkmn_card
	cp TYPE_TRAINER
	jr nc, .trainer_card

; energy card
	sub TYPE_ENERGY
	ld b, a
	add b
	add b
	add b ; *4
	add ICON_TILE_FIRE
	jr .got_tile

.trainer_card
	ld a, ICON_TILE_TRAINER
.got_tile
	dec d
	dec d
	dec e
	push af
	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle
	pop af

	call GetCardTypeIconPalette
	ld b, a
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .skip_pal
	ld a, b
	lb bc, 2, 2
	lb hl, 0, 0
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0
.skip_pal
	pop bc
	pop de
	pop hl
	ret

; returns in a the BG Pal corresponding to the
; card type icon in input register a
; if not found, returns $00
GetCardTypeIconPalette:
	push bc
	push hl
	ld b, a
	ld hl, .CardTypeIconPalettes
.loop
	ld a, [hli]
	or a
	jr z, .done
	cp b
	jr z, .done
	inc hl
	jp .loop ; can be jr
.done
	ld a, [hl]
	pop hl
	pop bc
	ret

.CardTypeIconPalettes
; icon tile, BG pal
	db ICON_TILE_FIRE,            1
	db ICON_TILE_GRASS,           2
	db ICON_TILE_LIGHTNING,       1
	db ICON_TILE_WATER,           2
	db ICON_TILE_FIGHTING,        3
	db ICON_TILE_PSYCHIC,         3
	db ICON_TILE_COLORLESS,       0
	db ICON_TILE_ENERGY,          2
	db ICON_TILE_BASIC_POKEMON,   2
	db ICON_TILE_STAGE_1_POKEMON, 2
	db ICON_TILE_STAGE_2_POKEMON, 1
	db ICON_TILE_TRAINER,         2
	db $00, $ff

; inits WRAM vars to start creating deck configuration to send
PrepareToBuildDeckConfigurationToSend:
	ld hl, wCurDeckCards
	ld a, wCurDeckCardsEnd - wCurDeckCards
	call ClearMemory_Bank2
	ld a, $ff
	ld [wCurDeck], a
	ld hl, .text
	ld de, wCurDeckName
	call CopyListFromHLToDE
	ld hl, .DeckConfigurationParams
	call InitDeckBuildingParams
	call HandleDeckBuildScreen
	ret

.text
	text "Cards chosen to send"
	done

.DeckConfigurationParams
	db DECK_SIZE ; max number of cards
	db 60 ; max number of same name cards
	db FALSE ; whether to include deck cards
	dw HandleSendDeckConfigurationMenu
	dw SendDeckConfigurationMenu_TransitionTable

SendDeckConfigurationMenu_TransitionTable:
	cursor_transition $10, $20, $00, $00, $00, $01, $02
	cursor_transition $48, $20, $00, $01, $01, $02, $00
	cursor_transition $80, $20, $00, $02, $02, $00, $01

SendDeckConfigurationMenuData:
	textitem  2, 2, ConfirmText
	textitem  9, 2, SendText
	textitem 16, 2, CancelText
	db $ff

HandleSendDeckConfigurationMenu:
	ld de, $0
	lb bc, 20, 6
	call DrawRegularTextBox
	ld hl, SendDeckConfigurationMenuData
	call PlaceTextItems
	ld a, $ff
	ld [wDuelInitialPrizesUpperBitsSet], a
.loop_input
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call YourOrOppPlayAreaScreen_HandleInput
	jr nc, .loop_input
	ld [wced6], a
	cp $ff
	jr nz, .asm_a23b
	call DrawCardTypeIconsAndPrintCardCounts
	ld a, [wTempCardListCursorPos]
	ld [wCardListCursorPos], a
	ld a, [wCurCardTypeFilter]
	call PrintFilteredCardList
	jp HandleDeckBuildScreen.skip_draw
.asm_a23b
	ld hl, .func_table
	call JumpToFunctionInTable
	jp OpenDeckConfigurationMenu.skip_init

.func_table
	dw ConfirmDeckConfiguration     ; Confirm
	dw .SendDeckConfiguration       ; Send
	dw .CancelSendDeckConfiguration ; Cancel

.SendDeckConfiguration
	ld a, [wCurDeckCards]
	or a
	jr z, .CancelSendDeckConfiguration
	xor a
	ld [wCardListVisibleOffset], a
	ld hl, Data_b04a
	call InitCardSelectionParams
	ld hl, wCurDeckCards
	ld de, wDuelTempList
	call CopyListFromHLToDE
	call PrintCardToSendText
	call Func_b088
	call EnableLCD
	ldtx hl, SendTheseCardsText
	call YesOrNoMenuWithText
	jr nc, .asm_a279
	add sp, $2
	jp HandleDeckBuildScreen.skip_count
.asm_a279
	add sp, $2
	scf
	ret

.CancelSendDeckConfiguration
	add sp, $2
	or a
	ret

; copies b bytes from hl to de
CopyNBytesFromHLToDE:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, CopyNBytesFromHLToDE
	ret

; handles the screen showing all the player's cards
HandlePlayersCardsScreen:
	call WriteCardListsTerminatorBytes
	call PrintPlayersCardsHeaderInfo
	xor a
	ld [wCardListVisibleOffset], a
	ld [wCurCardTypeFilter], a
	call PrintFilteredCardSelectionList
	call EnableLCD
	xor a
	ld hl, FiltersCardSelectionParams
	call InitCardSelectionParams
.wait_input
	call DoFrame
	ld a, [wCurCardTypeFilter]
	ld b, a
	ld a, [wTempCardTypeFilter]
	cp b
	jr z, .check_d_down
	ld [wCurCardTypeFilter], a
	ld hl, wCardListVisibleOffset
	ld [hl], $00
	call PrintFilteredCardSelectionList

	ld hl, hffb0
	ld [hl], $01
	call PrintPlayersCardsText
	ld hl, hffb0
	ld [hl], $00

	ld a, NUM_FILTERS
	ld [wCardListNumCursorPositions], a
.check_d_down
	ldh a, [hDPadHeld]
	and D_DOWN
	jr z, .no_d_down
	call ConfirmSelectionAndReturnCarry
	jr .jump_to_list

.no_d_down
	call HandleCardSelectionInput
	jr nc, .wait_input
	ld a, [hffb3]
	cp $ff ; operation cancelled
	jr nz, .jump_to_list
	ret

.jump_to_list
	ld a, [wNumEntriesInCurFilter]
	or a
	jr z, .wait_input

	xor a
	ld hl, Data_a396
	call InitCardSelectionParams
	ld a, [wNumEntriesInCurFilter]
	ld [wNumCardListEntries], a
	ld hl, wNumVisibleCardListEntries
	cp [hl]
	jr nc, .asm_a300
	ld [wCardListNumCursorPositions], a
.asm_a300
	ld hl, PrintCardSelectionList
	ld d, h
	ld a, l
	ld hl, wCardListUpdateFunction
	ld [hli], a
	ld [hl], d
	xor a
	ld [wced2], a

.loop_input
	call DoFrame
	call HandleSelectUpAndDownInList
	jr c, .loop_input
	call HandleDeckCardSelectionList
	jr c, .asm_a36a
	ldh a, [hDPadHeld]
	and START
	jr z, .loop_input
	; start btn pressed

.open_card_page
	ld a, $01
	call PlaySFXConfirmOrCancel
	ld a, [wCardListNumCursorPositions]
	ld [wTempCardListNumCursorPositions], a
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a

	; set wFilteredCardList as current card list
	; and show card page screen
	ld de, wFilteredCardList
	ld hl, wCurCardListPtr
	ld [hl], e
	inc hl
	ld [hl], d
	call OpenCardPageFromCardList
	call PrintPlayersCardsHeaderInfo

	ld hl, FiltersCardSelectionParams
	call InitCardSelectionParams
	ld a, [wCurCardTypeFilter]
	ld [wTempCardTypeFilter], a
	call DrawHorizontalListCursor_Visible
	call PrintCardSelectionList
	call EnableLCD
	ld hl, Data_a396
	call InitCardSelectionParams
	ld a, [wTempCardListNumCursorPositions]
	ld [wCardListNumCursorPositions], a
	ld a, [wTempCardListCursorPos]
	ld [wCardListCursorPos], a
	jr .loop_input

.asm_a36a
	call DrawListCursor_Invisible
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a
	ld a, [hffb3]
	cp $ff
	jr nz, .open_card_page
	ld hl, FiltersCardSelectionParams
	call InitCardSelectionParams
	ld a, [wCurCardTypeFilter]
	ld [wTempCardTypeFilter], a
	ld hl, hffb0
	ld [hl], $01
	call PrintPlayersCardsText
	ld hl, hffb0
	ld [hl], $00
	jp .wait_input

Data_a396:
	db 1 ; x pos
	db 5 ; y pos
	db 2 ; y spacing
	db 0 ; x spacing
	db 7 ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

; a = which card type filter
PrintFilteredCardSelectionList:
	push af
	ld hl, CardTypeFilters
	ld b, $00
	ld c, a
	add hl, bc
	ld a, [hl]
	push af
	ld a, ALL_DECKS
	call CreateCardCollectionListWithDeckCards
	pop af
	call CreateFilteredCardList

	ld a, NUM_DECK_CONFIRMATION_VISIBLE_CARDS
	ld [wNumVisibleCardListEntries], a
	lb de, 2, 5
	ld hl, wCardListCoords
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, SYM_SPACE
	ld [wCursorAlternateTile], a
	call PrintCardSelectionList
	pop af
	ret

; outputs in wTempCardCollection all the cards in sCardCollection
; plus the cards that are being used in built decks
; a = DECK_* flags for which decks to include in the collection
CreateCardCollectionListWithDeckCards:
	ld [hffb5], a
; copies sCardCollection to wTempCardCollection
	ld hl, sCardCollection
	ld de, wTempCardCollection
	ld b, CARD_COLLECTION_SIZE - 1
	call EnableSRAM
	call CopyNBytesFromHLToDE
	call DisableSRAM

; deck_1
	ld a, [hffb5] ; should be ldh
	bit DECK_1_F, a
	jr z, .deck_2
	ld de, sDeck1Cards
	call IncrementDeckCardsInTempCollection
.deck_2
	ld a, [hffb5] ; should be ldh
	bit DECK_2_F, a
	jr z, .deck_3
	ld de, sDeck2Cards
	call IncrementDeckCardsInTempCollection
.deck_3
	ld a, [hffb5] ; should be ldh
	bit DECK_3_F, a
	jr z, .deck_4
	ld de, sDeck3Cards
	call IncrementDeckCardsInTempCollection
.deck_4
	ld a, [hffb5] ; should be ldh
	bit DECK_4_F, a
	ret z
	ld de, sDeck4Cards
	call IncrementDeckCardsInTempCollection
	ret

; goes through cards in deck in de
; and for each card ID, increments its corresponding
; entry in wTempCardCollection
IncrementDeckCardsInTempCollection:
	call EnableSRAM
	ld bc, wTempCardCollection
	ld h, DECK_SIZE
.loop
	ld a, [de]
	inc de
	or a
	jr z, .done
	push hl
	ld h, $0
	ld l, a
	add hl, bc
	inc [hl]
	pop hl
	dec h
	jr nz, .loop
.done
	call DisableSRAM
	ret

; prints the name, level and storage count of the cards
; that are visible in the list window
; in the form:
; CARD NAME/LEVEL X
; where X is the current count of that card
PrintCardSelectionList:
	push bc
	ld hl, wCardListCoords
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, 19 ; x coord
	ld c, e
	ld a, [wCardListVisibleOffset]
	or a
	jr z, .alternate_cursor_tile
	ld a, SYM_CURSOR_U
	jr .got_cursor_tile_1
.alternate_cursor_tile
	ld a, [wCursorAlternateTile]
.got_cursor_tile_1
	call WriteByteToBGMap0

; iterates by decreasing value in wNumVisibleCardListEntries
; by 1 until it reaches 0
	ld a, [wCardListVisibleOffset]
	ld c, a
	ld b, $0
	ld hl, wFilteredCardList
	add hl, bc
	ld a, [wNumVisibleCardListEntries]
.loop_filtered_cards
	push de
	or a
	jr z, .exit_loop
	ld b, a
	ld a, [hli]
	or a
	jr z, .invalid_card ; card ID of 0
	ld e, a
	call AddCardIDToVisibleList
	call LoadCardDataToBuffer1_FromCardID
	; places in wDefaultText the card's name and level
	; then appends at the end the count of that card
	; in the card storage
	ld a, 14
	push bc
	push hl
	push de
	call CopyCardNameAndLevel
	pop de
	call AppendOwnedCardCountNumber
	pop hl
	pop bc
	pop de
	push hl
	call InitTextPrinting
	ld hl, wDefaultText
	jr .process_text
.invalid_card
	pop de
	push hl
	call InitTextPrinting
	ld hl, Text_9a36
.process_text
	call ProcessText
	pop hl

	ld a, b
	dec a
	inc e
	inc e
	jr .loop_filtered_cards

.exit_loop
	ld a, [hli]
	or a
	jr z, .cannot_scroll
	pop de
; draw down cursor because
; there are still more cards
; to be scrolled down
	xor a ; FALSE
	ld [wUnableToScrollDown], a
	ld a, SYM_CURSOR_D
	jr .got_cursor_tile_2
.cannot_scroll
	pop de
	ld a, TRUE
	ld [wUnableToScrollDown], a
	ld a, [wCursorAlternateTile]
.got_cursor_tile_2
	ld b, 19 ; x coord
	ld c, e
	dec c
	dec c
	call WriteByteToBGMap0
	pop bc
	ret

; appends the card count given in register e
; to the list in hl, in numerical form
; (i.e. its numeric symbol representation)
AppendOwnedCardCountNumber:
	push af
	push bc
	push de
	push hl
; increment hl until end is reached ($00 byte)
.loop
	ld a, [hl]
	or a
	jr z, .end
	inc hl
	jr .loop
.end
	call GetOwnedCardCount
	call ConvertToNumericalDigits
	ld [hl], $00 ; insert byte terminator
	pop hl
	pop de
	pop bc
	pop af
	ret

; print header info (card count and player name)
PrintPlayersCardsHeaderInfo:
	call Set_OBJ_8x8
	call PrepareMenuGraphics
.skip_empty_screen
	lb bc, 0, 4
	ld a, SYM_BOX_TOP
	call FillBGMapLineWithA
	call PrintTotalNumberOfCardsInCollection
	call PrintPlayersCardsText
	call DrawCardTypeIcons
	ret

; prints "<PLAYER>'s cards"
PrintPlayersCardsText:
	lb de, 1, 0
	call InitTextPrinting
	ld de, wDefaultText
	call CopyPlayerName
	ld hl, wDefaultText
	call ProcessText
	ld hl, wDefaultText
	call GetTextLengthInTiles
	inc b
	ld d, b
	ld e, 0
	call InitTextPrinting
	ldtx hl, SCardsText
	call ProcessTextFromID
	ret

PrintTotalNumberOfCardsInCollection:
	ld a, ALL_DECKS
	call CreateCardCollectionListWithDeckCards

; count all the cards in collection
	ld de, wTempCardCollection + 1
	ld b, 0
	ld hl, 0
.loop_all_cards
	ld a, [de]
	inc de
	and $7f
	push bc
	ld b, $00
	ld c, a
	add hl, bc
	pop bc
	inc b
	ld a, NUM_CARDS
	cp b
	jr nz, .loop_all_cards

; hl = total number of cards in collection
	call .GetTotalCountDigits
	ld hl, wTempCardCollection
	ld de, wDecimalDigitsSymbols
	ld b, $00
	call .PlaceNumericalChar
	call .PlaceNumericalChar
	call .PlaceNumericalChar
	call .PlaceNumericalChar
	call .PlaceNumericalChar
	ld a, $07
	ld [hli], a
	ld [hl], TX_END
	lb de, 13, 0
	call InitTextPrinting
	ld hl, wTempCardCollection
	call ProcessText
	ret

; places a numerical character in hl from de
; doesn't place a 0 if no non-0
; numerical character has been placed before
; this makes it so that there are no
; 0s in more significant digits
.PlaceNumericalChar
	ld [hl], TX_SYMBOL
	inc hl
	ld a, b
	or a
	jr z, .leading_num
	ld a, [de]
	inc de
	ld [hli], a
	ret
.leading_num
; don't place a 0 as a leading number
	ld a, [de]
	inc de
	cp SYM_0
	jr z, .space_char
	ld [hli], a
	ld b, $01 ; at least one non-0 char was placed
	ret
.space_char
	xor a ; SYM_SPACE
	ld [hli], a
	ret

; gets the digits in decimal form
; of value stored in hl
; stores the result in wDecimalDigitsSymbols
.GetTotalCountDigits
	ld de, wDecimalDigitsSymbols
	ld bc, -10000
	call .GetDigit
	ld bc, -1000
	call .GetDigit
	ld bc, -100
	call .GetDigit
	ld bc, -10
	call .GetDigit
	ld bc, -1
	call .GetDigit
	ret

.GetDigit
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
