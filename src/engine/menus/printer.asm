PrinterMenu_PokemonCards:
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

.loop_frame_1
	call DoFrame
	ld a, [wCurCardTypeFilter]
	ld b, a
	ld a, [wTempCardTypeFilter]
	cp b
	jr z, .handle_input
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
.handle_input
	ldh a, [hDPadHeld]
	and D_DOWN
	jr z, .asm_abca
; d_down
	call ConfirmSelectionAndReturnCarry
	jr .asm_abd7
.asm_abca
	call HandleCardSelectionInput
	jr nc, .loop_frame_1
	ld a, [hffb3]
	cp $ff
	jr nz, .asm_abd7
	ret

.asm_abd7
	ld a, [wNumEntriesInCurFilter]
	or a
	jr z, .loop_frame_1

	xor a
	ld hl, Data_a396
	call InitCardSelectionParams
	ld a, [wNumEntriesInCurFilter]
	ld [wNumCardListEntries], a
	ld hl, wNumVisibleCardListEntries
	cp [hl]
	jr nc, .asm_abf6
	ld [wCardListNumCursorPositions], a
	ld [wTempCardListNumCursorPositions], a
.asm_abf6
	ld hl, PrintCardSelectionList
	ld d, h
	ld a, l
	ld hl, wCardListUpdateFunction
	ld [hli], a
	ld [hl], d
	xor a
	ld [wced2], a

.loop_frame_2
	call DoFrame
	call HandleSelectUpAndDownInList
	jr c, .loop_frame_2
	call HandleDeckCardSelectionList
	jr c, .asm_ac60
	ldh a, [hDPadHeld]
	and START
	jr z, .loop_frame_2
; start btn
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

.asm_ac37
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
	jr .loop_frame_2

.asm_ac60
	call DrawListCursor_Invisible
	ld a, [wCardListNumCursorPositions]
	ld [wTempCardListNumCursorPositions], a
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a
	ld a, [hffb3]
	cp $ff
	jr nz, .asm_ac92

	ld hl, FiltersCardSelectionParams
	call InitCardSelectionParams
	ld a, [wCurCardTypeFilter]
	ld [wTempCardTypeFilter], a
	ld hl, hffb0
	ld [hl], $01
	call PrintPlayersCardsText
	ld hl, hffb0
	ld [hl], $00
	jp .loop_frame_1

.asm_ac92
	call DrawListCursor_Visible
	call .Func_acde
	lb de, 1, 1
	call InitTextPrinting
	ldtx hl, PrintThisCardYesNoText
	call ProcessTextFromID
	ld a, $01
	ld hl, Data_ad05
	call InitCardSelectionParams
.loop_frame
	call DoFrame
	call HandleCardSelectionInput
	jr nc, .loop_frame
	ld a, [hffb3]
	or a
	jr nz, .asm_acd5
	ld hl, wFilteredCardList
	ld a, [wTempCardListCursorPos]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [wCardListVisibleOffset]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	bank1call RequestToPrintCard
	call PrintPlayersCardsHeaderInfo
	jp .asm_ac37

.asm_acd5
	call .Func_acde
	call PrintPlayersCardsHeaderInfo.skip_empty_screen
	jp .asm_ac37

.Func_acde
	xor a
	lb hl, 0, 0
	lb de, 0, 0
	lb bc, 20, 4
	call FillRectangle
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret nz ; exit if not CGB

	xor a
	lb hl, 0, 0
	lb de, 0, 0
	lb bc, 20, 4
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0
	ret

Data_ad05:
	db 3 ; x pos
	db 3 ; y pos
	db 0 ; y spacing
	db 4 ; x spacing
	db 2 ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

PrinterMenu_CardList:
	call WriteCardListsTerminatorBytes
	call Set_OBJ_8x8
	call PrepareMenuGraphics
	lb bc, 0, 4
	ld a, SYM_BOX_TOP
	call FillBGMapLineWithA

	xor a
	ld [wCardListVisibleOffset], a
	ld [wCurCardTypeFilter], a
	call PrintFilteredCardSelectionList
	call EnableLCD
	lb de, 1, 1
	call InitTextPrinting
	ldtx hl, PrintTheCardListText
	call ProcessTextFromID
	ld a, $01
	ld hl, Data_ad05
	call InitCardSelectionParams
.loop_frame
	call DoFrame
	call HandleCardSelectionInput
	jr nc, .loop_frame
	ld a, [hffb3]
	or a
	ret nz
	bank1call PrintCardList
	ret

HandlePrinterMenu:
	bank1call PreparePrinterConnection
	ret c
	xor a
.loop
	ld hl, PrinterMenuParameters
	call InitializeMenuParameters
	call EmptyScreenAndLoadFontDuelAndHandCardsIcons
	lb de, 4, 0
	lb bc, 12, 12
	call DrawRegularTextBox
	lb de, 6, 2
	call InitTextPrinting
	ldtx hl, PrintMenuItemsText
	call ProcessTextFromID
	ldtx hl, WhatWouldYouLikeToPrintText
	call DrawWideTextBox_PrintText
	call EnableLCD
.loop_input
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input
	ldh a, [hCurMenuItem]
	cp $ff
	call z, PrinterMenu_QuitPrint
	ld [wSelectedPrinterMenuItem], a
	ld hl, PrinterMenuFunctionTable
	call JumpToFunctionInTable
	ld a, [wSelectedPrinterMenuItem]
	jr .loop

PrinterMenu_QuitPrint:
	add sp, $2 ; exit menu
	ldtx hl, PleaseMakeSureToTurnGameBoyPrinterOffText
	call DrawWideTextBox_WaitForInput
	ret

PrinterMenuFunctionTable:
	dw PrinterMenu_PokemonCards
	dw PrinterMenu_DeckConfiguration
	dw PrinterMenu_CardList
	dw PrinterMenu_PrintQuality
	dw PrinterMenu_QuitPrint

PrinterMenuParameters:
	db 5, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

PrinterMenu_PrintQuality:
	ldtx hl, PleaseSetTheContrastText
	call DrawWideTextBox_PrintText
	call EnableSRAM
	ld a, [sPrinterContrastLevel]
	call DisableSRAM
	ld hl, Data_adf5
	call InitCardSelectionParams
.loop_frame
	call DoFrame
	call HandleCardSelectionInput
	jr nc, .loop_frame
	ld a, [hffb3]
	cp $ff
	jr z, .asm_ade2
	call EnableSRAM
	ld [sPrinterContrastLevel], a
	call DisableSRAM
.asm_ade2
	add sp, $2 ; exit menu
	ld a, [wSelectedPrinterMenuItem]
	ld hl, PrinterMenuParameters
	call InitializeMenuParameters
	ldtx hl, WhatWouldYouLikeToPrintText
	call DrawWideTextBox_PrintText
	jr HandlePrinterMenu.loop_input

Data_adf5:
	db 5  ; x pos
	db 16 ; y pos
	db 0  ; y spacing
	db 2  ; x spacing
	db 5  ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction
