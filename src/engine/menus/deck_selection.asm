INCLUDE "data/glossary_menu_transitions.asm"

; copies DECK_SIZE number of cards from de to hl in SRAM
CopyDeckFromSRAM:
	push bc
	call EnableSRAM
	ld b, DECK_SIZE
.loop
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .loop
	xor a
	ld [hl], a
	call DisableSRAM
	pop bc
	ret

; clears some WRAM addresses to act as
; terminator bytes to wFilteredCardList and wCurDeckCards
WriteCardListsTerminatorBytes:
	xor a
	ld hl, wFilteredCardList
	ld bc, DECK_SIZE
	add hl, bc
	ld [hl], a ; terminator byte
	ld hl, wCurDeckCards
	ld bc, DECK_CONFIG_BUFFER_SIZE
	add hl, bc
	ld [hl], a ; terminator byte
	ret

; inits some SRAM addresses
InitPromotionalCardAndDeckCounterSaveData:
	call EnableSRAM
	xor a
	ld hl, sHasPromotionalCards
	ld [hli], a
	inc a ; $1
	ld [hli], a ; sb704
	ld [hli], a
	ld [hl], a
	ld [sUnnamedDeckCounter], a
	call DisableSRAM
;	ret missing
;	unintentional fallthrough

; loads the Hard Cards icon gfx to v0Tiles2
LoadHandCardsIcon:
	ld hl, HandCardsGfx
	ld de, v0Tiles2 + $38 tiles
	call CopyListFromHLToDE
	ret

HandCardsGfx:
	INCBIN "gfx/hand_cards.2bpp"
	db $00 ; end of data

EmptyScreenAndLoadFontDuelAndHandCardsIcons:
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont
	call LoadDuelCardSymbolTiles
	call LoadHandCardsIcon
	bank1call SetDefaultConsolePalettes
	lb de, $3c, $bf
	call SetupText
	ret

; empties screen, zeroes object positions,
; loads cursor tile, symbol fonts, duel card symbols
; hand card icon and sets default palettes
PrepareMenuGraphics:
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	call EmptyScreen
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	call LoadCursorTile
	call LoadSymbolsFont
	call LoadDuelCardSymbolTiles
	call LoadHandCardsIcon
	bank1call SetDefaultConsolePalettes
	lb de, $3c, $bf
	call SetupText
	ret

; inits the following deck building params from hl:
; wMaxNumCardsAllowed
; wSameNameCardsLimit
; wIncludeCardsInDeck
; wDeckConfigurationMenuHandlerFunction
; wDeckConfigurationMenuTransitionTable
InitDeckBuildingParams:
	ld de, wMaxNumCardsAllowed
	ld b, $7
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ret

DeckBuildingParams:
	db DECK_CONFIG_BUFFER_SIZE ; max number of cards
	db MAX_NUM_SAME_NAME_CARDS ; max number of same name cards
	db TRUE ; whether to include deck cards
	dw HandleDeckConfigurationMenu
	dw DeckConfigurationMenu_TransitionTable

DeckSelectionMenu:
	ld hl, DeckBuildingParams
	call InitDeckBuildingParams
	ld a, ALL_DECKS
	call DrawDecksScreen
	xor a

.init_menu_params
	ld hl, .DeckSelectionMenuParameters
	call InitializeMenuParameters
	ldtx hl, PleaseSelectDeckText
	call DrawWideTextBox_PrintText
.loop_input
	call DoFrame
	jr c, .init_menu_params ; reinit menu parameters
	call HandleStartButtonInDeckSelectionMenu
	jr c, .init_menu_params
	call HandleMenuInput
	jr nc, .loop_input
	ldh a, [hCurMenuItem]
	cp $ff
	ret z ; B btn returns
; A btn pressed on a deck
	ld [wCurDeck], a
	jp DeckSelectionSubMenu

.DeckSelectionMenuParameters
	db 1, 2 ; cursor x, cursor y
	db 3 ; y displacement between items
	db 4 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; handles START button press when in deck selection menu
; does nothing if START button isn't pressed
; if a press was handled, returns carry
; prints "There is no deck here!" if the selected deck is empty
HandleStartButtonInDeckSelectionMenu:
	ldh a, [hDPadHeld]
	and START
	ret z ; skip

; set menu item as current deck
	ld a, [wCurMenuItem]
	ld [wCurDeck], a
	call CheckIfCurDeckIsValid
	jp nc, .valid_deck ; can be jr

; not a valid deck, cancel
	ld a, $ff ; cancel
	call PlaySFXConfirmOrCancel
	call PrintThereIsNoDeckHereText
	scf
	ret

.valid_deck
	ld a, $1
	call PlaySFXConfirmOrCancel
	call GetPointerToDeckCards
	push hl
	call GetPointerToDeckName
	pop de
	call OpenDeckConfirmationMenu
	ld a, ALL_DECKS
	call DrawDecksScreen
	ld a, [wCurDeck]
	scf
	ret

OpenDeckConfirmationMenu:
; copy deck name
	push de
	ld de, wCurDeckName
	call CopyListFromHLToDEInSRAM
	pop de

; copy deck cards
	ld hl, wCurDeckCards
	call CopyDeckFromSRAM

	ld a, NUM_FILTERS
	ld hl, wCardFilterCounts
	call ClearMemory_Bank2
	ld a, DECK_SIZE
	ld [wTotalCardCount], a
	ld hl, wCardFilterCounts
	ld [hl], a
	call HandleDeckConfirmationMenu
	ret

; handles the submenu when selecting a deck
; (Modify Deck, Select Deck, Change Name and Cancel)
DeckSelectionSubMenu:
	call DrawWideTextBox
	ld hl, DeckSelectionData
	call PlaceTextItems
	call ResetCheckMenuCursorPositionAndBlink
.loop_input
	call DoFrame
	call HandleCheckMenuInput
	jp nc, .loop_input
	cp $ff
	jr nz, .option_selected
; B btn pressed
; erase cursor and go back
; to deck selection handling
	call EraseCheckMenuCursor
	ld a, [wCurDeck]
	jp DeckSelectionMenu.init_menu_params

.option_selected
	ld a, [wCheckMenuCursorXPosition]
	or a
	jp nz, DeckSelectionSubMenu_SelectOrCancel
	ld a, [wCheckMenuCursorYPosition]
	or a
	jp nz, .ChangeName

; Modify Deck
; read deck from SRAM
; TODO
	call GetPointerToDeckCards
	ld e, l
	ld d, h
	ld hl, wCurDeckCards
	call CopyDeckFromSRAM
	ld a, 20
	ld hl, wCurDeckName
	call ClearMemory_Bank2
	ld de, wCurDeckName
	call GetPointerToDeckName
	call CopyListFromHLToDEInSRAM

	call HandleDeckBuildScreen
	jr nc, .asm_8ec4
	call EnableSRAM
	ld hl, wCurDeckCards
	call DecrementDeckCardsInCollection
	call GetPointerToDeckCards
	call AddDeckToCollection
	ld e, l
	ld d, h
	ld hl, wCurDeckCards
	ld b, DECK_SIZE
.asm_8ea9
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_8ea9
	call GetPointerToDeckName
	ld d, h
	ld e, l
	ld hl, wCurDeckName
	call CopyListFromHLToDE
	call GetPointerToDeckName
	ld a, [hl]
	call DisableSRAM
	or a
	jr z, .get_input_deck_name
.asm_8ec4
	ld a, ALL_DECKS
	call DrawDecksScreen
	ld a, [wCurDeck]
	jp DeckSelectionMenu.init_menu_params

.ChangeName
	call CheckIfCurDeckIsValid
	jp nc, .get_input_deck_name
	call PrintThereIsNoDeckHereText
	jp DeckSelectionMenu.init_menu_params
.get_input_deck_name
	ld a, 20
	ld hl, wCurDeckName
	call ClearMemory_Bank2
	ld de, wCurDeckName
	call GetPointerToDeckName
	call CopyListFromHLToDEInSRAM
	call InputCurDeckName
	call GetPointerToDeckName
	ld d, h
	ld e, l
	ld hl, wCurDeckName
	call CopyListFromHLToDEInSRAM
	ld a, ALL_DECKS
	call DrawDecksScreen
	ld a, [wCurDeck]
	jp DeckSelectionMenu.init_menu_params

; gets current deck's name from user input
InputCurDeckName:
	ld a, [wCurDeck]
	or a
	jr nz, .deck_2
	ld hl, Deck1Data
	jr .got_deck_ptr
.deck_2
	dec a
	jr nz, .deck_3
	ld hl, Deck2Data
	jr .got_deck_ptr
.deck_3
	dec a
	jr nz, .deck_4
	ld hl, Deck3Data
	jr .got_deck_ptr
.deck_4
	ld hl, Deck4Data
.got_deck_ptr
	ld a, MAX_DECK_NAME_LENGTH
	lb bc, 4, 1
	ld de, wCurDeckName
	farcall InputDeckName
	ld a, [wCurDeckName]
	or a
	ret nz
	; empty name
	call .UnnamedDeck
	ret

; handles the naming of unnamed decks
; inputs as the deck name "DECK XXX"
; where XXX is the current unnamed deck counter
.UnnamedDeck
; read the current unnamed deck number
; and convert it to text
	ld hl, sUnnamedDeckCounter
	call EnableSRAM
	ld a, [hli]
	ld h, [hl]
	call DisableSRAM
	ld l, a
	ld de, wDefaultText
	call TwoByteNumberToText

	ld hl, wCurDeckName
	ld [hl], $6
	inc hl
	ld [hl], "D"
	inc hl
	ld [hl], "e"
	inc hl
	ld [hl], "c"
	inc hl
	ld [hl], "k"
	inc hl
	ld [hl], " "
	inc hl
	ld de, wDefaultText + 2
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

; increment the unnamed deck counter
	ld hl, sUnnamedDeckCounter
	call EnableSRAM
	ld e, [hl]
	inc hl
	ld d, [hl]
; capped at 999
	ld a, HIGH(MAX_UNNAMED_DECK_NUM)
	cp d
	jr nz, .incr_counter
	ld a, LOW(MAX_UNNAMED_DECK_NUM)
	cp e
	jr nz, .incr_counter
	; reset counter
	ld de, 0
.incr_counter
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	call DisableSRAM
	ret

; handle deck selection sub-menu
; the option is either "Select Deck" or "Cancel"
; depending on the cursor Y pos
DeckSelectionSubMenu_SelectOrCancel:
	ld a, [wCheckMenuCursorYPosition]
	or a
	jp nz, CancelDeckSelectionSubMenu

; select deck
	call CheckIfCurDeckIsValid
	jp nc, .SelectDeck
	; invalid deck
	call PrintThereIsNoDeckHereText
	jp DeckSelectionMenu.init_menu_params

.SelectDeck
	call EnableSRAM
	ld a, [sCurrentlySelectedDeck]
	call DisableSRAM

; draw empty rectangle on currently selected deck
; i.e. erase the Hand Cards Gfx icon
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

; set current deck as the selected deck
; and draw the Hand Cards Gfx icon
	ld a, [wCurDeck]
	call EnableSRAM
	ld [sCurrentlySelectedDeck], a
	call DisableSRAM
	call DrawHandCardsTileOnCurDeck

; print "<DECK> was chosen as the dueling deck!"
	call GetPointerToDeckName
	call EnableSRAM
	call CopyDeckName
	call DisableSRAM
	xor a
	ld [wTxRam2], a
	ld [wTxRam2 + 1], a
	ldtx hl, ChosenAsDuelingDeckText
	call DrawWideTextBox_WaitForInput
	ld a, [wCurDeck]
	jp DeckSelectionMenu.init_menu_params

PrintThereIsNoDeckHereText:
	ldtx hl, ThereIsNoDeckHereText
	call DrawWideTextBox_WaitForInput
	ld a, [wCurDeck]
	ret

; returns carry if deck in wCurDeck
; is not a valid deck
CheckIfCurDeckIsValid:
	ld a, [wCurDeck]
	ld hl, wDecksValid
	ld b, $0
	ld c, a
	add hl, bc
	ld a, [hl]
	or a
	ret nz ; is valid
	scf
	ret ; is not valid

; write to $d00a the decimal representation (number characters)
; of the value in hl
; unreferenced?
Func_9001:
	ld de, $d00a
	ld bc, -100
	call .GetNumberChar
	ld bc, -10
	call .GetNumberChar
	ld bc, -1
	call .GetNumberChar
	ret

.GetNumberChar
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

CancelDeckSelectionSubMenu:
	ret

DeckSelectionData:
	textitem  2, 14, ModifyDeckText
	textitem 12, 14, SelectDeckText
	textitem  2, 16, ChangeNameText
	textitem 12, 16, CancelText
	db $ff

; return, in hl, the pointer to sDeckXName where X is [wCurDeck] + 1
GetPointerToDeckName:
	ld a, [wCurDeck]
	ld h, a
	ld l, DECK_STRUCT_SIZE
	call HtimesL
	push de
	ld de, sDeck1Name
	add hl, de
	pop de
	ret

; return, in hl, the pointer to sDeckXCards where X is [wCurDeck] + 1
GetPointerToDeckCards:
	push af
	ld a, [wCurDeck]
	ld h, a
	ld l, sDeck2Cards - sDeck1Cards
	call HtimesL
	push de
	ld de, sDeck1Cards
	add hl, de
	pop de
	pop af
	ret

ResetCheckMenuCursorPositionAndBlink:
	xor a
	ld [wCheckMenuCursorXPosition], a
	ld [wCheckMenuCursorYPosition], a
	ld [wCheckMenuCursorBlinkCounter], a
	ret
