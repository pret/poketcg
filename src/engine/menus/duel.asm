_OpenDuelCheckMenu::
	call ResetCheckMenuCursorPositionAndBlink
	xor a
	ld [wce5e], a
	call DrawWideTextBox

; reset cursor blink
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	ld hl, CheckMenuData
	call PlaceTextItems
.loop
	call DoFrame
	call HandleCheckMenuInput
	jr nc, .loop
	cp $ff
	ret z ; B pressed

; A was pressed
	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld b, a
	ld a, [wCheckMenuCursorXPosition]
	add b
	ld hl, .jump_table
	call JumpToFunctionInTable
	jr _OpenDuelCheckMenu

.jump_table
	dw DuelCheckMenu_InPlayArea
	dw DuelCheckMenu_Glossary
	dw DuelCheckMenu_YourPlayArea
	dw DuelCheckMenu_OppPlayArea

; opens the In Play Area submenu
DuelCheckMenu_InPlayArea:
	xor a
	ld [wInPlayAreaFromSelectButton], a
	farcall OpenInPlayAreaScreen
	ret

; opens the Glossary submenu
DuelCheckMenu_Glossary:
	farcall OpenGlossaryScreen
	ret

; opens the Your Play Area submenu
DuelCheckMenu_YourPlayArea:
	call ResetCheckMenuCursorPositionAndBlink
	xor a
	ld [wce5e], a
	ldh a, [hWhoseTurn]
.draw
	ld h, a
	ld l, a
	call DrawYourOrOppPlayAreaScreen

	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld b, a
	ld a, [wCheckMenuCursorXPosition]
	add b
	ld [wYourOrOppPlayAreaLastCursorPosition], a
	ld b, $f8 ; black arrow tile
	call DrawYourOrOppPlayArea_DrawArrows

	call DrawWideTextBox

; reset cursor blink
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	ld hl, YourPlayAreaMenuData
	call PlaceTextItems

.loop
	call DoFrame
	xor a
	call DrawYourOrOppPlayArea_RefreshArrows
	call HandleCheckMenuInput_YourOrOppPlayArea
	jr nc, .loop

	call DrawYourOrOppPlayArea_EraseArrows
	cp $ff
	ret z

	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld b, a
	ld a, [wCheckMenuCursorXPosition]
	add b
	ld hl, .jump_table
	call JumpToFunctionInTable
	jr .draw

.jump_table
	dw OpenYourOrOppPlayAreaScreen_TurnHolderPlayArea
	dw OpenYourOrOppPlayAreaScreen_TurnHolderHand
	dw OpenYourOrOppPlayAreaScreen_TurnHolderDiscardPile

OpenYourOrOppPlayAreaScreen_TurnHolderPlayArea:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderPlayAreaScreen
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_NonTurnHolderPlayArea:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderPlayAreaScreen
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_TurnHolderHand:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_NonTurnHolderHand:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_TurnHolderDiscardPile:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderDiscardPileScreen
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_NonTurnHolderDiscardPile:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderDiscardPileScreen
	pop af
	ldh [hWhoseTurn], a
	ret

; opens the Opp. Play Area submenu
; if clairvoyance is active, add the option to check
; opponent's hand
DuelCheckMenu_OppPlayArea:
	call ResetCheckMenuCursorPositionAndBlink
	call IsClairvoyanceActive
	jr c, .clairvoyance1

	ld a, %10000000
	ld [wce5e], a
	jr .begin
.clairvoyance1
	xor a
	ld [wce5e], a

.begin
	ldh a, [hWhoseTurn]
.turns
	ld l, a
	cp PLAYER_TURN
	jr nz, .opponent
	ld a, OPPONENT_TURN
	ld h, a
	jr .cursor
.opponent
	ld a, PLAYER_TURN
	ld h, a

.cursor
	call DrawYourOrOppPlayAreaScreen

; convert cursor position and
; store it in wYourOrOppPlayAreaLastCursorPosition
	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld b, a
	ld a, [wCheckMenuCursorXPosition]
	add b
	add 3
	ld [wYourOrOppPlayAreaLastCursorPosition], a

; draw black arrows in the Play Area
	ld b, $f8 ; black arrow tile
	call DrawYourOrOppPlayArea_DrawArrows
	call DrawWideTextBox

; reset cursor blink
	xor a
	ld [wCheckMenuCursorBlinkCounter], a

; place text items depending on clairvoyance
; when active, allows to look at opp. hand
	call IsClairvoyanceActive
	jr c, .clairvoyance2
	ld hl, OppPlayAreaMenuData
	call PlaceTextItems
	jr .loop
.clairvoyance2
	ld hl, OppPlayAreaMenuData_WithClairvoyance
	call PlaceTextItems

; handle input
.loop
	call DoFrame
	ld a, 1
	call DrawYourOrOppPlayArea_RefreshArrows
	call HandleCheckMenuInput_YourOrOppPlayArea
	jr nc, .loop
	call DrawYourOrOppPlayArea_EraseArrows
	cp $ff
	ret z ; B was pressed

; A was pressed
; jump to function corresponding to cursor position
	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld b, a
	ld a, [wCheckMenuCursorXPosition]
	add b
	ld hl, .jump_table
	call JumpToFunctionInTable
	jr .turns

.jump_table
	dw OpenYourOrOppPlayAreaScreen_NonTurnHolderPlayArea
	dw OpenYourOrOppPlayAreaScreen_NonTurnHolderHand
	dw OpenYourOrOppPlayAreaScreen_NonTurnHolderDiscardPile

CheckMenuData:
	textitem  2, 14, InPlayAreaText
	textitem  2, 16, YourPlayAreaText
	textitem 12, 14, GlossaryText
	textitem 12, 16, OppPlayAreaText
	db $ff

YourPlayAreaMenuData:
	textitem  2, 14, YourPokemonText
	textitem 12, 14, YourHandText
	textitem  2, 16, YourDiscardPileText2
	db $ff

OppPlayAreaMenuData:
	textitem  2, 14, OpponentsPokemonText
	textitem  2, 16, OpponentsDiscardPileText2
	db $ff

OppPlayAreaMenuData_WithClairvoyance:
	textitem  2, 14, OpponentsPokemonText
	textitem 12, 14, OpponentsHandText
	textitem  2, 16, OpponentsDiscardPileText2
	db $ff

; checks if arrows need to be erased in Your Play Area or Opp. Play Area
; and draws new arrows upon cursor position change
; input:
; a = an initial offset applied to the cursor position (used to adjust
; for the different layouts of the Your Play Area and Opp. Play Area screens)
DrawYourOrOppPlayArea_RefreshArrows:
	push af
	ld b, a
	add b
	add b
	ld c, a
	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld b, a
	ld a, [wCheckMenuCursorXPosition]
	add b
	add c
; a = 2 * cursor ycoord + cursor xcoord + 3*a

; if cursor position is different than
; last position, then update arrows
	ld hl, wYourOrOppPlayAreaLastCursorPosition
	cp [hl]
	jr z, .unchanged

; erase and draw arrows
	call DrawYourOrOppPlayArea_EraseArrows
	ld [wYourOrOppPlayAreaLastCursorPosition], a
	ld b, $f8 ; black arrow tile byte
	call DrawYourOrOppPlayArea_DrawArrows

.unchanged
	pop af
	ret

; write SYM_SPACE to positions tabulated in
; YourOrOppPlayAreaArrowPositions, with offset calculated from the
; cursor x and y positions in [wYourOrOppPlayAreaLastCursorPosition]
; input:
; [wYourOrOppPlayAreaLastCursorPosition]: cursor position (2*y + x)
DrawYourOrOppPlayArea_EraseArrows:
	push af
	ld a, [wYourOrOppPlayAreaLastCursorPosition]
	ld b, SYM_SPACE ; white tile
	call DrawYourOrOppPlayArea_DrawArrows
	pop af
	ret

; writes tile in b to positions tabulated in
; YourOrOppPlayAreaArrowPositions, with offset calculated from the
; cursor x and y positions in a
; input:
; a = cursor position (2*y + x)
; b = byte to draw
DrawYourOrOppPlayArea_DrawArrows:
	push bc
	ld hl, YourOrOppPlayAreaArrowPositions
	sla a
	ld c, a
	ld b, $00
	add hl, bc
; hl points to YourOrOppPlayAreaArrowPositions
; plus offset corresponding to a

; load hl with draw position pointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de

.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, d
	call WriteByteToBGMap0
	jr .loop
.done
	ret

YourOrOppPlayAreaArrowPositions:
	dw YourOrOppPlayAreaArrowPositions_PlayerPokemon
	dw YourOrOppPlayAreaArrowPositions_PlayerHand
	dw YourOrOppPlayAreaArrowPositions_PlayerDiscardPile
	dw YourOrOppPlayAreaArrowPositions_OpponentPokemon
	dw YourOrOppPlayAreaArrowPositions_OpponentHand
	dw YourOrOppPlayAreaArrowPositions_OpponentDiscardPile

YourOrOppPlayAreaArrowPositions_PlayerPokemon:
; x and y coordinates to draw byte
	db  5,  5
	db  0, 10
	db  4, 10
	db  8, 10
	db 12, 10
	db 16, 10
	db $ff

YourOrOppPlayAreaArrowPositions_PlayerHand:
	db 14, 7
	db $ff

YourOrOppPlayAreaArrowPositions_PlayerDiscardPile:
	db 14, 5
	db $ff

YourOrOppPlayAreaArrowPositions_OpponentPokemon:
	db  5, 7
	db  0, 3
	db  4, 3
	db  8, 3
	db 12, 3
	db 16, 3
	db $ff

YourOrOppPlayAreaArrowPositions_OpponentHand:
	db 0, 5
	db $ff

YourOrOppPlayAreaArrowPositions_OpponentDiscardPile:
	db 0, 8
	db $ff

; loads tiles and icons to display Your Play Area / Opp. Play Area screen,
; and draws the screen according to the turn player
; input: h -> [wCheckMenuPlayAreaWhichDuelist] and l -> [wCheckMenuPlayAreaWhichLayout]
DrawYourOrOppPlayAreaScreen:
; loads the turn holders
	ld a, h
	ld [wCheckMenuPlayAreaWhichDuelist], a
	ld a, l
	ld [wCheckMenuPlayAreaWhichLayout], a
; fallthrough

; loads tiles and icons to display Your Play Area / Opp. Play Area screen,
; and draws the screen according to the turn player
; input: [wCheckMenuPlayAreaWhichDuelist] and [wCheckMenuPlayAreaWhichLayout]
_DrawYourOrOppPlayAreaScreen::
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions

	ld a, $01
	ld [wVBlankOAMCopyToggle], a

	call DoFrame
	call EmptyScreen
	call Set_OBJ_8x8
	call LoadCursorTile
	call LoadSymbolsFont
	call LoadDeckAndDiscardPileIcons

	ld a, [wCheckMenuPlayAreaWhichDuelist]
	cp PLAYER_TURN
	jr nz, .opp_turn1

; print <RAMNAME>'s Play Area
	ld de, wDefaultText
	call CopyPlayerName
	jr .get_text_length
.opp_turn1
	ld de, wDefaultText
	call CopyOpponentName
.get_text_length
	ld hl, wDefaultText

	call GetTextLengthInTiles
	ld a, 6 ; max name size in tiles
	sub b
	srl a
	add 4
; a = (6 - name text in tiles) / 2 + 4
	ld d, a ; text horizontal alignment

	ld e, 0
	call InitTextPrinting
	ldtx hl, DuelistsPlayAreaText
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr nz, .opp_turn2
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	cp PLAYER_TURN
	jr nz, .swap
.opp_turn2
	call PrintTextNoDelay
	jr .draw
.swap
	call SwapTurn
	call PrintTextNoDelay
	call SwapTurn

.draw
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld b, a
	ld a, [wCheckMenuPlayAreaWhichLayout]
	cp b
	jr nz, .not_equal

	ld hl, PrizeCardsCoordinateData_YourOrOppPlayArea.player
	call DrawPlayArea_PrizeCards
	lb de, 6, 2 ; coordinates of player's active card
	call DrawYourOrOppPlayArea_ActiveCardGfx
	lb de, 1, 9 ; coordinates of player's bench cards
	ld c, 4 ; spacing
	call DrawPlayArea_BenchCards
	xor a
	call DrawYourOrOppPlayArea_Icons
	jr .done

.not_equal
	ld hl, PrizeCardsCoordinateData_YourOrOppPlayArea.opponent
	call DrawPlayArea_PrizeCards
	lb de, 6, 5 ; coordinates of opponent's active card
	call DrawYourOrOppPlayArea_ActiveCardGfx
	lb de, 1, 2 ; coordinates of opponent's bench cards
	ld c, 4 ; spacing
	call DrawPlayArea_BenchCards
	ld a, $01
	call DrawYourOrOppPlayArea_Icons

.done
	call EnableLCD
	ret

Func_82b6:
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld b, a
	ld a, [wCheckMenuPlayAreaWhichLayout]
	cp b
	jr nz, .not_equal

	ld hl, PrizeCardsCoordinateData_YourOrOppPlayArea.player
	call DrawPlayArea_PrizeCards
	ret

.not_equal
	ld hl, PrizeCardsCoordinateData_YourOrOppPlayArea.opponent
	call DrawPlayArea_PrizeCards
	ret

; loads tiles and icons to display the In Play Area screen,
; and draws the screen
DrawInPlayAreaScreen:
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions

	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call EmptyScreen

	ld a, CHECK_PLAY_AREA
	ld [wDuelDisplayedScreen], a
	call Set_OBJ_8x8
	call LoadCursorTile
	call LoadSymbolsFont
	call LoadDeckAndDiscardPileIcons

	lb de, $80, $9f
	call SetupText

; reset turn holders
	ldh a, [hWhoseTurn]
	ld [wCheckMenuPlayAreaWhichDuelist], a
	ld [wCheckMenuPlayAreaWhichLayout], a

; player prize cards
	ld hl, PrizeCardsCoordinateData_InPlayArea.player
	call DrawPlayArea_PrizeCards

; player bench cards
	lb de, 3, 15
	ld c, 3
	call DrawPlayArea_BenchCards

	ld hl, PlayAreaIconCoordinates.player2
	call DrawInPlayArea_Icons

	call SwapTurn
	ldh a, [hWhoseTurn]
	ld [wCheckMenuPlayAreaWhichDuelist], a
	call SwapTurn

; opponent prize cards
	ld hl, PrizeCardsCoordinateData_InPlayArea.opponent
	call DrawPlayArea_PrizeCards

; opponent bench cards
	lb de, 3, 0
	ld c, 3
	call DrawPlayArea_BenchCards

	call SwapTurn
	ld hl, PlayAreaIconCoordinates.opponent2
	call DrawInPlayArea_Icons

	call SwapTurn
	call DrawInPlayArea_ActiveCardGfx
	ret

; draws players prize cards and bench cards
_DrawPlayersPrizeAndBenchCards::
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call EmptyScreen
	call LoadSymbolsFont
	call LoadDeckAndDiscardPileIcons

; player cards
	ld a, PLAYER_TURN
	ld [wCheckMenuPlayAreaWhichDuelist], a
	ld [wCheckMenuPlayAreaWhichLayout], a
	ld hl, PrizeCardsCoordinateData_2.player
	call DrawPlayArea_PrizeCards
	lb de, 5, 10 ; coordinates
	ld c, 3 ; spacing
	call DrawPlayArea_BenchCards

; opponent cards
	ld a, OPPONENT_TURN
	ld [wCheckMenuPlayAreaWhichDuelist], a
	ld hl, PrizeCardsCoordinateData_2.opponent
	call DrawPlayArea_PrizeCards
	lb de, 1, 0 ; coordinates
	ld c, 3 ; spacing
	call DrawPlayArea_BenchCards
	ret

; draws the active card gfx at coordinates de
; of the player (or opponent) depending on wCheckMenuPlayAreaWhichDuelist
; input:
; de = coordinates
DrawYourOrOppPlayArea_ActiveCardGfx:
	push de
	ld a, DUELVARS_ARENA_CARD
	ld l, a
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld h, a
	ld a, [hl]
	cp -1
	jr z, .no_pokemon

	ld d, a
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld b, a
	ldh a, [hWhoseTurn]
	cp b
	jr nz, .swap
	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
	jr .draw
.swap
	call SwapTurn
	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
	call SwapTurn

.draw
	ld de, v0Tiles1 + $20 tiles ; destination offset of loaded gfx
	ld hl, wLoadedCard1Gfx
	ld a, [hli]
	ld h, [hl]
	ld l, a
	lb bc, $30, TILE_SIZE
	call LoadCardGfx
	bank1call SetBGP6OrSGB3ToCardPalette
	bank1call FlushAllPalettesOrSendPal23Packet
	pop de

; draw card gfx
	ld a, $a0
	lb hl, 6, 1
	lb bc, 8, 6
	call FillRectangle
	bank1call ApplyBGP6OrSGB3ToCardImage
	ret

.no_pokemon
	pop de
	ret

; draws player and opponent arena card graphics
; in the "In Play Area" screen
DrawInPlayArea_ActiveCardGfx:
	xor a
	ld [wArenaCardsInPlayArea], a

	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1 ; no pokemon
	jr z, .opponent1

	push af
	ld a, [wArenaCardsInPlayArea]
	or %00000001 ; set the player arena Pokemon bit
	ld [wArenaCardsInPlayArea], a
	pop af

; load card gfx
	call LoadCardDataToBuffer1_FromDeckIndex
	lb de, $8a, $00
	ld hl, wLoadedCard1Gfx
	ld a, [hli]
	ld h, [hl]
	ld l, a
	lb bc, $30, TILE_SIZE
	call LoadCardGfx
	bank1call SetBGP6OrSGB3ToCardPalette

.opponent1
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	cp -1 ; no pokemon
	jr z, .draw

	push af
	ld a, [wArenaCardsInPlayArea]
	or %00000010 ; set the opponent arena Pokemon bit
	ld [wArenaCardsInPlayArea], a
	pop af

; load card gfx
	call SwapTurn
	call LoadCardDataToBuffer1_FromDeckIndex
	lb de, $95, $00
	ld hl, wLoadedCard1Gfx
	ld a, [hli]
	ld h, [hl]
	ld l, a
	lb bc, $30, TILE_SIZE
	call LoadCardGfx
	bank1call SetBGP7OrSGB2ToCardPalette
	call SwapTurn

.draw
	ld a, [wArenaCardsInPlayArea]
	or a
	ret z ; no arena cards in play

	bank1call FlushAllPalettesOrSendPal23Packet
	ld a, [wArenaCardsInPlayArea]
	and %00000001 ; test player arena card bit
	jr z, .opponent2

; draw player arena card
	ld a, $a0
	lb de, 6, 9
	lb hl, 6, 1
	lb bc, 8, 6
	call FillRectangle
	bank1call ApplyBGP6OrSGB3ToCardImage

.opponent2
	ld a, [wArenaCardsInPlayArea]
	and %00000010 ; test opponent arena card bit
	ret z

; draw opponent arena card
	call SwapTurn
	ld a, $50
	lb de, 6, 2
	lb hl, 6, 1
	lb bc, 8, 6
	call FillRectangle
	bank1call ApplyBGP7OrSGB2ToCardImage
	call SwapTurn
	ret

; draws prize cards depending on the turn
; loaded in wCheckMenuPlayAreaWhichDuelist
; input:
; hl = pointer to coordinates
DrawPlayArea_PrizeCards:
	push hl
	call GetDuelInitialPrizesUpperBitsSet
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld h, a
	ld l, DUELVARS_PRIZES
	ld a, [hl]

	pop hl
	ld b, 0
	push af
; loop each prize card
.loop
	inc b
	ld a, [wDuelInitialPrizes]
	inc a
	cp b
	jr z, .done

	pop af
	srl a ; right shift prize cards left
	push af
	jr c, .not_taken
	ld a, $e0 ; tile byte for empty slot
	jr .draw
.not_taken
	ld a, $dc ; tile byte for card
.draw
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl

	push hl
	push bc
	lb hl, $01, $02 ; card tile gfx
	lb bc, 2, 2 ; rectangle size
	call FillRectangle

	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld a, $02 ; blue colour
	lb bc, 2, 2
	lb hl, 0, 0
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0
.not_cgb
	pop bc
	pop hl
	jr .loop
.done
	pop af
	ret

PrizeCardsCoordinateData_YourOrOppPlayArea:
; x and y coordinates for player prize cards
.player
	db 2, 1
	db 2, 3
	db 4, 1
	db 4, 3
	db 6, 1
	db 6, 3
; x and y coordinates for opponent prize cards
.opponent
	db 9, 17
	db 9, 15
	db 7, 17
	db 7, 15
	db 5, 17
	db 5, 15

; used by Func_833c
PrizeCardsCoordinateData_2:
; x and y coordinates for player prize cards
.player
	db  6, 0
	db  6, 2
	db  8, 0
	db  8, 2
	db 10, 0
	db 10, 2
; x and y coordinates for opponent prize cards
.opponent
	db 4, 18
	db 4, 16
	db 2, 18
	db 2, 16
	db 0, 18
	db 0, 16

PrizeCardsCoordinateData_InPlayArea:
; x and y coordinates for player prize cards
.player
	db  9, 1
	db  9, 3
	db 11, 1
	db 11, 3
	db 13, 1
	db 13, 3
; x and y coordinates for opponent prize cards
.opponent
	db 6, 17
	db 6, 15
	db 4, 17
	db 4, 15
	db 2, 17
	db 2, 15

; calculates bits set up to the number of initial prizes, with upper 2 bits set, i.e:
; 6 prizes: a = %11111111
; 4 prizes: a = %11001111
; 3 prizes: a = %11000111
; 2 prizes: a = %11000011
GetDuelInitialPrizesUpperBitsSet:
	ld a, [wDuelInitialPrizes]
	ld b, $01
.loop
	or a
	jr z, .done
	sla b
	dec a
	jr .loop
.done
	dec b
	ld a, b
	or %11000000
	ld [wDuelInitialPrizesUpperBitsSet], a
	ret

; draws filled and empty bench slots depending on the turn loaded in wCheckMenuPlayAreaWhichDuelist
; if wCheckMenuPlayAreaWhichDuelist is different from wCheckMenuPlayAreaWhichLayout adjusts coordinates of the bench slots
; input:
; de = coordinates to draw bench
; c  = spacing between slots
DrawPlayArea_BenchCards:
	ld a, [wCheckMenuPlayAreaWhichLayout]
	ld b, a
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	cp b
	jr z, .skip

; adjust the starting bench position for opponent
	ld a, d
	add c
	add c
	add c
	add c
	ld d, a
	; d = d + 4 * c

; have the spacing go to the left instead of right
	xor a
	sub c
	ld c, a
	; c = $ff - c + 1

	ld a, [wCheckMenuPlayAreaWhichDuelist]
.skip
	ld h, a
	ld l, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	ld b, [hl]
	ld l, DUELVARS_BENCH1_CARD_STAGE
.loop_1
	dec b ; num of Bench Pokemon left
	jr z, .done

	ld a, [hli]
	push hl
	push bc
	sla a
	sla a
	add $e4
; a holds the correct stage gfx tile
	ld b, a
	push bc

	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle

	ld a, [wConsole]
	cp CONSOLE_CGB
	pop bc
	jr nz, .next

	ld a, b
	cp $ec ; tile offset of 2 stage
	jr z, .two_stage
	cp $f0 ; tile offset of 2 stage with no 1 stage
	jr z, .two_stage

	ld a, $02 ; blue colour
	jr .palette
.two_stage
	ld a, $01 ; red colour
.palette
	lb bc, 2, 2
	lb hl, 0, 0
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0

.next ; adjust coordinates for next card
	pop bc
	pop hl
	ld a, d
	add c
	ld d, a
	; d = d + c
	jr .loop_1

.done
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld h, a
	ld l, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	ld b, [hl]
	ld a, MAX_PLAY_AREA_POKEMON
	sub b
	ret z ; return if already full

	ld b, a
	inc b
.loop_2
	dec b
	ret z

	push bc
	ld a, $f4 ; empty bench slot tile
	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle

	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb

	ld a, $02 ; colour
	lb bc, 2, 2
	lb hl, 0, 0
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0

.not_cgb
	pop bc
	ld a, d
	add c
	ld d, a
	jr .loop_2

; draws Your/Opp Play Area icons depending on value in a
; the icons correspond to Deck, Discard Pile, and Hand
; the corresponding number of cards is printed alongside each icon
; for "Hand", text is displayed rather than an icon
; input:
; a = $00: draws player icons
; a = $01: draws opponent icons
DrawYourOrOppPlayArea_Icons:
	or a
	jr nz, .opponent
	ld hl, PlayAreaIconCoordinates.player1
	jr .draw
.opponent
	ld hl, PlayAreaIconCoordinates.opponent1

.draw
; hand icon and value
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld d, a
	ld e, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	ld a, [de]
	ld b, a
	ld a, $d0 ; hand icon, unused?
	call DrawPlayArea_HandText

; deck icon and value
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld d, a
	ld e, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	ld a, [de]
	ld b, a
	ld a, DECK_SIZE
	sub b
	ld b, a
	ld a, $d4 ; deck icon
	call DrawPlayArea_IconWithValue

; discard pile icon and value
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld d, a
	ld e, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	ld a, [de]
	ld b, a
	ld a, $d8 ; discard pile icon
	call DrawPlayArea_IconWithValue
	ret

; draws the interface icon corresponding to the gfx tile in a
; also prints the number in decimal corresponding to the value in b
; the coordinates in screen are given by [hl]
; input:
; a  = tile for the icon
; b  = value to print alongside icon
; hl = pointer to coordinates
DrawPlayArea_IconWithValue:
; drawing the icon
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	push hl
	push bc
	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle

	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .skip

	ld a, $02
	lb bc, 2, 2
	lb hl, 0, 0
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0

.skip
; adjust coordinate to the lower right
	inc d
	inc d
	inc e
	call InitTextPrinting
	pop bc
	ld a, b
	call CalculateOnesAndTensDigits

	ld hl, wDecimalDigitsSymbols
	ld a, [hli]
	ld b, a
	ld a, [hl]

; loading numerical and cross symbols
	ld hl, wDefaultText
	ld [hl], TX_SYMBOL
	inc hl
	ld [hl], SYM_CROSS
	inc hl
	ld [hl], TX_SYMBOL
	inc hl
	ld [hli], a ; tens place
	ld [hl], TX_SYMBOL
	inc hl
	ld a, b
	ld [hli], a ; ones place
	ld [hl], TX_END

; printing the decimal value
	ld hl, wDefaultText
	call ProcessText
	pop hl
	ret

PlayAreaIconCoordinates:
; used for "Your/Opp. Play Area" screen
.player1
	db 15,  7 ; hand
	db 15,  2 ; deck
	db 15,  4 ; discard pile
.opponent1
	db  1,  5 ; hand
	db  1,  9 ; deck
	db  1,  7 ; discard pile

; used for "In Play Area" screen
.player2
	db 15, 14
	db 15,  9
	db 15, 11
.opponent2
	db  0,  2
	db  0,  6
	db  0,  4

; draws In Play Area icons depending on value in a
; the icons correspond to Deck, Discard Pile, and Hand
; the corresponding number of cards is printed alongside each icon
; for "Hand", text is displayed rather than an icon
; input:
; a = $00: draws player icons
; a = $01: draws opponent icons
DrawInPlayArea_Icons:
	ldh a, [hWhoseTurn]
	ld d, a
	ld e, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	ld a, [de]
	ld b, a
	ld a, $d0 ; hand icon, unused?
	call DrawPlayArea_HandText

; deck
	ldh a, [hWhoseTurn]
	ld d, a
	ld e, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	ld a, [de]
	ld b, a
	ld a, DECK_SIZE
	sub b
	ld b, a
	ld a, $d4 ; deck tile
	call DrawPlayArea_IconWithValue

; discard pile
	ldh a, [hWhoseTurn]
	ld d, a
	ld e, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	ld a, [de]
	ld b, a
	ld a, $d8 ; discard pile tile
	call DrawPlayArea_IconWithValue
	ret

; prints text HandText_2 and a cross with decimal value of b
; input
; b = value to print alongside text
DrawPlayArea_HandText:
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl

; text
	push hl
	push bc
	call InitTextPrinting
	ldtx hl, HandText_2
	call ProcessTextFromID
	pop bc

; decimal value
	ld a, b
	call CalculateOnesAndTensDigits
	ld hl, wDecimalDigitsSymbols
	ld a, [hli]
	ld b, a
	ld a, [hl]

	ld hl, wDefaultText
	ld [hl], TX_SYMBOL
	inc hl
	ld [hl], SYM_CROSS
	inc hl
	ld [hl], TX_SYMBOL
	inc hl
	ld [hli], a
	ld [hl], TX_SYMBOL
	inc hl

; draw to screen
	ld a, b
	ld [hli], a
	ld [hl], TX_END
	ld hl, wDefaultText
	call ProcessText
	pop hl
	ret

; handle player input in menu in Your or Opp. Play Area
; works out which cursor coordinate to go to
; and sets carry flag if A or B are pressed
; returns a =  $1 if A pressed
; returns a = $ff if B pressed
HandleCheckMenuInput_YourOrOppPlayArea:
	xor a
	ld [wMenuInputSFX], a
	ld a, [wCheckMenuCursorXPosition]
	ld d, a
	ld a, [wCheckMenuCursorYPosition]
	ld e, a

; d = cursor x position
; e = cursor y position

	ldh a, [hDPadHeld]
	or a
	jr z, .skip

; pad is pressed
	ld a, [wce5e]
	and %10000000
	ldh a, [hDPadHeld]
	jr nz, .check_vertical
	bit D_LEFT_F, a ; test left button
	jr nz, .horizontal
	bit D_RIGHT_F, a ; test right button
	jr z, .check_vertical

; handle horizontal input
.horizontal
	ld a, [wce5e]
	and %01111111
	or a
	jr nz, .asm_86dd ; jump if wce5e's lower 7 bits aren't set
	ld a, e
	or a
	jr z, .flip_x ; jump if y is 0

; wce5e = %10000000
; e = 1
	dec e ; change y position
	jr .flip_x

.asm_86dd
	ld a, e
	or a
	jr nz, .flip_x ; jump if y is not 0
	inc e ; change y position
.flip_x
	ld a, d
	xor $01 ; flip x position
	ld d, a
	jr .erase

.check_vertical
	bit D_UP_F, a
	jr nz, .vertical
	bit D_DOWN_F, a
	jr z, .skip

; handle vertical input
.vertical
	ld a, d
	or a
	jr z, .flip_y ; jump if x is 0
	dec d
.flip_y
	ld a, e
	xor $01 ; flip y position
	ld e, a

.erase
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	push de
	call EraseCheckMenuCursor_YourOrOppPlayArea
	pop de

; update x and y cursor positions
	ld a, d
	ld [wCheckMenuCursorXPosition], a
	ld a, e
	ld [wCheckMenuCursorYPosition], a

; reset cursor blink
	xor a
	ld [wCheckMenuCursorBlinkCounter], a

.skip
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .sfx
	and A_BUTTON
	jr nz, .a_pressed

; B pressed
	ld a, $ff ; cancel
	call PlaySFXConfirmOrCancel
	scf
	ret

.a_pressed
	call DisplayCheckMenuCursor_YourOrOppPlayArea
	ld a, $01
	call PlaySFXConfirmOrCancel
	scf
	ret

.sfx
	ld a, [wMenuInputSFX]
	or a
	jr z, .draw_cursor
	call PlaySFX

.draw_cursor
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and %00001111
	ret nz ; only update cursor if blink's lower nibble is 0

	ld a, SYM_CURSOR_R ; cursor byte
	bit 4, [hl] ; only draw cursor if blink counter's fourth bit is not set
	jr z, DrawCheckMenuCursor_YourOrOppPlayArea
; fallthrough

; transforms cursor position into coordinates
; in order to draw byte on menu cursor
EraseCheckMenuCursor_YourOrOppPlayArea:
	ld a, SYM_SPACE ; white tile
; fallthrough

; draws in the cursor position
; input:
; a = tile byte to draw
DrawCheckMenuCursor_YourOrOppPlayArea:
	ld e, a
	ld a, 10
	ld l, a
	ld a, [wCheckMenuCursorXPosition]
	ld h, a
	call HtimesL
; h = 10 * cursor x pos

	ld a, l
	add 1
	ld b, a
	ld a, [wCheckMenuCursorYPosition]
	sla a
	add 14
	ld c, a
; c = 11 + 2 * cursor y pos + 14

; draw tile loaded in e
	ld a, e
	call WriteByteToBGMap0
	or a
	ret

DisplayCheckMenuCursor_YourOrOppPlayArea:
	ld a, SYM_CURSOR_R ; load cursor byte
	jr DrawCheckMenuCursor_YourOrOppPlayArea

; handles Peek Pkmn Power selection menus
_HandlePeekSelection::
	call Set_OBJ_8x8
	call LoadCursorTile
; reset wce5c and wIsSwapTurnPending
	xor a
	ld [wce5c], a
	ld [wIsSwapTurnPending], a

; draw play area screen for the turn player
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, a
	call DrawYourOrOppPlayAreaScreen

.check_swap
	ld a, [wIsSwapTurnPending]
	or a
	jr z, .draw_menu_1
; if wIsSwapTurnPending is TRUE, swap turn
	call SwapTurn
	xor a
	ld [wIsSwapTurnPending], a

; prompt player to choose either own Play Area or opponent's
.draw_menu_1
	xor a
	ld hl, .PlayAreaMenuParameters
	call InitializeMenuParameters
	call DrawWideTextBox
	ld hl, .YourOrOppPlayAreaData
	call PlaceTextItems

.loop_input_1
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input_1
	cp -1
	jr z, .loop_input_1 ; can't use B btn

	call EraseCursor
	ldh a, [hCurMenuItem]
	or a
	jp nz, .PrepareYourPlayAreaSelection ; jump if not Opp Play Area

; own Play Area was chosen
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld b, a
	ldh a, [hWhoseTurn]
	cp b
	jr z, .text_1

; switch the play area to draw
	ld h, a
	ld l, a
	call DrawYourOrOppPlayAreaScreen
	xor a
	ld [wIsSwapTurnPending], a

.text_1
	call DrawWideTextBox
	lb de, 1, 14
	call InitTextPrinting
	ldtx hl, WhichCardWouldYouLikeToSeeText
	call ProcessTextFromID

	xor a
	ld [wYourOrOppPlayAreaCurPosition], a
	ld de, PeekYourPlayAreaTransitionTable
	ld hl, wTransitionTablePtr
	ld [hl], e
	inc hl
	ld [hl], d

.loop_input_2
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call YourOrOppPlayAreaScreen_HandleInput
	jr c, .selection_cancelled
	jr .loop_input_2
.selection_cancelled
	cp -1
	jr nz, .selection_made
	call ZeroObjectPositionsWithCopyToggleOn
	jr .check_swap
.selection_made
	ld hl, .SelectionFunctionTable
	call JumpToFunctionInTable
	jr .loop_input_2

.SelectionFunctionTable
REPT 6
	dw .SelectedPrize
ENDR
	dw .SelectedOppsHand
	dw .SelectedDeck

.YourOrOppPlayAreaData
	textitem 2, 14, YourPlayAreaText
	textitem 2, 16, OppPlayAreaText
	db $ff

.PlayAreaMenuParameters
	db 1, 14 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

.SelectedPrize
	ld a, [wYourOrOppPlayAreaCurPosition]
	ld c, a
	ld b, $1

; left-shift b a number of times
; corresponding to this prize card
.loop_prize_bitmask
	or a
	jr z, .got_prize_bitmask
	sla b
	dec a
	jr .loop_prize_bitmask

.got_prize_bitmask
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	and b
	ret z ; return if prize card taken

	ld a, c
	add $40
	ld [wce5c], a
	ld a, c
	add DUELVARS_PRIZE_CARDS
	call GetTurnDuelistVariable
	jr .ShowSelectedCard

.SelectedOppsHand
	call CreateHandCardList
	ret c
	ld hl, wDuelTempList
	call ShuffleCards
	ld a, [hl]
	jr .ShowSelectedCard

.SelectedDeck
	call CreateDeckCardList
	ret c
	ld a, %01111111
	ld [wce5c], a
	ld a, [wDuelTempList]
; fallthrough

; input:
; a = deck index of card to be loaded
; output:
; a = wce5c
; with upper bit set if turn was swapped
.ShowSelectedCard
	ld b, a
	ld a, [wce5c]
	or a
	jr nz, .display
	; if wce5c is not set, set it as input deck index
	ld a, b
	ld [wce5c], a
.display
	ld a, b
	call LoadCardDataToBuffer1_FromDeckIndex
	call Set_OBJ_8x16
	bank1call OpenCardPage_FromHand
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	pop af

; if wIsSwapTurnPending is TRUE, swap turn
	ld a, [wIsSwapTurnPending]
	or a
	jr z, .dont_swap
	call SwapTurn
	ld a, [wce5c]
	or %10000000
	ret
.dont_swap
	ld a, [wce5c]
	ret

; prepare menu parameters to handle selection
; of player's own Play Area
.PrepareYourPlayAreaSelection:
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld b, a
	ldh a, [hWhoseTurn]
	cp b
	jr nz, .text_2

	ld l, a
	cp PLAYER_TURN
	jr nz, .opponent
	ld a, OPPONENT_TURN
	jr .draw_menu_2
.opponent
	ld a, PLAYER_TURN

.draw_menu_2
	ld h, a
	call DrawYourOrOppPlayAreaScreen

.text_2
	call DrawWideTextBox
	lb de, 1, 14
	call InitTextPrinting
	ldtx hl, WhichCardWouldYouLikeToSeeText
	call ProcessTextFromID

	xor a
	ld [wYourOrOppPlayAreaCurPosition], a
	ld de, PeekOppPlayAreaTransitionTable
	ld hl, wTransitionTablePtr
	ld [hl], e
	inc hl
	ld [hl], d

	call SwapTurn
	ld a, TRUE
	ld [wIsSwapTurnPending], a ; mark pending to swap turn
	jp .loop_input_2

PeekYourPlayAreaTransitionTable:
	cursor_transition $08, $28, $00, $04, $02, $01, $07
	cursor_transition $30, $28, $20, $05, $03, $07, $00
	cursor_transition $08, $38, $00, $00, $04, $03, $07
	cursor_transition $30, $38, $20, $01, $05, $07, $02
	cursor_transition $08, $48, $00, $02, $00, $05, $07
	cursor_transition $30, $48, $20, $03, $01, $07, $04
	cursor_transition $78, $50, $00, $07, $07, $00, $01
	cursor_transition $78, $28, $00, $07, $07, $00, $01

PeekOppPlayAreaTransitionTable:
	cursor_transition $a0, $60, $20, $02, $04, $07, $01
	cursor_transition $78, $60, $00, $03, $05, $00, $07
	cursor_transition $a0, $50, $20, $04, $00, $06, $03
	cursor_transition $78, $50, $00, $05, $01, $02, $06
	cursor_transition $a0, $40, $20, $00, $02, $06, $05
	cursor_transition $78, $40, $00, $01, $03, $04, $06
	cursor_transition $08, $38, $00, $07, $07, $05, $04
	cursor_transition $08, $60, $00, $06, $06, $01, $00

_DrawAIPeekScreen::
	push bc
	call Set_OBJ_8x8
	call LoadCursorTile
	xor a
	ld [wIsSwapTurnPending], a
	ldh a, [hWhoseTurn]
	ld l, a
	ld de, PeekYourPlayAreaTransitionTable
	pop bc
	bit AI_PEEK_TARGET_HAND_F, b
	jr z, .draw_play_area

; AI chose the hand
	call SwapTurn
	ld a, TRUE
	ld [wIsSwapTurnPending], a ; mark pending to swap turn
	ldh a, [hWhoseTurn]
	ld de, PeekOppPlayAreaTransitionTable
.draw_play_area
	ld h, a
	push bc
	push de
	call DrawYourOrOppPlayAreaScreen
	pop de
	pop bc

; get the right cursor position
; depending on what action the AI chose
; (prize card, hand, deck)
	ld hl, wMenuInputTablePointer
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, b
	and $7f
	cp $7f
	jr nz, .prize_card
; cursor on the deck
	ld a, $7
	ld [wYourOrOppPlayAreaCurPosition], a
	jr .got_cursor_position
.prize_card
	bit AI_PEEK_TARGET_PRIZE_F, a
	jr z, .hand
	and $3f
	ld [wYourOrOppPlayAreaCurPosition], a
	jr .got_cursor_position
.hand
	ld a, $6
	ld [wYourOrOppPlayAreaCurPosition], a
.got_cursor_position
	call YourOrOppPlayAreaScreen_HandleInput.draw_cursor

	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	ld a, [wIsSwapTurnPending]
	or a
	ret z
	call SwapTurn
	ret

LoadCursorTile:
	ld de, v0Tiles0
	ld hl, .tile_data
	ld b, 16
	call SafeCopyDataHLtoDE
	ret

.tile_data:
	db $e0, $c0, $98, $b0, $84, $8c, $83, $82
	db $86, $8f, $9d, $be, $f4, $f8, $50, $60

; handles input inside the "Your Play Area" or "Opp Play Area" screens
; returns carry if either A or B button were pressed
; returns -1 in a if B button was pressed
YourOrOppPlayAreaScreen_HandleInput:
	xor a
	ld [wMenuInputSFX], a

; get the transition data for the prize card with cursor
	ld hl, wTransitionTablePtr
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wYourOrOppPlayAreaCurPosition]
	ld [wPrizeCardCursorTemporaryPosition], a
	ld l, a
	ld h, 7 ; length of each transition table item
	call HtimesL
	add hl, de

; get the transition index related to the directional input
	ldh a, [hDPadHeld]
	or a
	jp z, .check_button
	inc hl
	inc hl
	inc hl

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
	ld [wYourOrOppPlayAreaCurPosition], a
	cp $8 ; if a >= 0x8
	jr nc, .next
	ld b, $1

; this loop equals to
; b = (1 << a)
.make_bitmask_loop
	or a
	jr z, .make_bitmask_done
	sla b
	dec a
	jr .make_bitmask_loop

.make_bitmask_done
; check if the moved cursor refers to an existing item.
; it's always true when this function was called from the glossary procedure.
	ld a, [wDuelInitialPrizesUpperBitsSet]
	and b
	jr nz, .next

; when no cards exist at the cursor,
	ld a, [wPrizeCardCursorTemporaryPosition]
	cp $06
	jr nz, YourOrOppPlayAreaScreen_HandleInput
	; move once more in the direction (recursively) until it reaches an existing item.

; check if one of the dpad, left or right, is pressed.
; if not, just go back to the start.
	ldh a, [hDPadHeld]
	bit D_RIGHT_F, a
	jr nz, .left_or_right
	bit D_LEFT_F, a
	jr z, YourOrOppPlayAreaScreen_HandleInput

.left_or_right
	; if started with 5 or 6 prize cards
	; can switch sides normally,
	ld a, [wDuelInitialPrizes]
	cp PRIZES_5
	jr nc, .next
	; else if it's last card,
	ld a, [wYourOrOppPlayAreaCurPosition]
	cp 5
	jr nz, .not_last_card
	; place it at pos 3
	ld a, 3
	ld [wYourOrOppPlayAreaCurPosition], a
	jr .ok
.not_last_card
	; otherwise place at pos 2
	ld a, 2
	ld [wYourOrOppPlayAreaCurPosition], a

.ok
	ld a, [wDuelInitialPrizes]
	cp PRIZES_3
	jr nc, .handled_cursor_pos
	; in this case can just sub 2 from pos
	ld a, [wYourOrOppPlayAreaCurPosition]
	sub 2
	ld [wYourOrOppPlayAreaCurPosition], a

.handled_cursor_pos
	ld a, [wYourOrOppPlayAreaCurPosition]
	ld [wPrizeCardCursorTemporaryPosition], a
	ld b, $1
	jr .make_bitmask_loop

.next
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a

; reset cursor blink
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
.check_button
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .return

	and A_BUTTON
	jr nz, .a_button

	ld a, -1 ; cancel
	call PlaySFXConfirmOrCancel
	scf
	ret

.a_button
	call .draw_cursor
	ld a, $01
	call PlaySFXConfirmOrCancel
	ld a, [wYourOrOppPlayAreaCurPosition]
	scf
	ret

.return
	ld a, [wMenuInputSFX]
	or a
	jr z, .skip_sfx
	call PlaySFX
.skip_sfx
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and (1 << 4) - 1
	ret nz
	bit 4, [hl]
	jr nz, ZeroObjectPositionsWithCopyToggleOn

.draw_cursor
	call ZeroObjectPositions
	ld hl, wTransitionTablePtr
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wYourOrOppPlayAreaCurPosition]
	ld l, a
	ld h, 7
	call HtimesL
	add hl, de
; hl = [wTransitionTablePtr] + 7 * wce52

	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld b, [hl]
	ld c, $00
	call SetOneObjectAttributes
	or a
	ret

ZeroObjectPositionsWithCopyToggleOn:
	call ZeroObjectPositions

	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret

; handles the screen for Player to select prize card(s)
_SelectPrizeCards::
	xor a
	call GetFirstSetPrizeCard
	ld [wYourOrOppPlayAreaCurPosition], a
	ld de, hTempPlayAreaLocation_ffa1
	ld hl, wSelectedPrizeCardListPtr
	ld [hl], e
	inc hl
	ld [hl], d

.check_prize_cards_to_select
	ld a, [wNumberOfPrizeCardsToSelect]
	or a
	jr z, .done_selection
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	or a
	jr nz, .got_prizes

.done_selection
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	ldh [hTemp_ffa0], a
	ld a, [wSelectedPrizeCardListPtr + 0]
	ld l, a
	ld a, [wSelectedPrizeCardListPtr + 1]
	ld h, a
	ld [hl], $ff
	ret

.got_prizes
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, a
	call DrawYourOrOppPlayAreaScreen
	call DrawWideTextBox
	lb de, 1, 14
	call InitTextPrinting
	ldtx hl, PleaseChooseAPrizeText
	call ProcessTextFromID
	ld de, .cursor_transition_table
	ld hl, wMenuInputTablePointer
	ld [hl], e
	inc hl
	ld [hl], d
.loop_handle_input
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call YourOrOppPlayAreaScreen_HandleInput
	jr nc, .loop_handle_input
	cp $ff
	jr z, .loop_handle_input

	call ZeroObjectPositionsWithCopyToggleOn

; get prize bit mask that corresponds
; to the one pointed by the cursor
	ld a, [wYourOrOppPlayAreaCurPosition]
	ld c, a
	ld b, $1
.loop
	or a
	jr z, .got_prize_mask
	sla b
	dec a
	jr .loop

.got_prize_mask
	; if cursor prize is not set,
	; then return to input loop
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	and b
	jp z, .loop_handle_input ; can be jr

	; remove prize
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	sub b
	ld [hl], a

	; get its deck index
	ld a, c
	add DUELVARS_PRIZE_CARDS
	call GetTurnDuelistVariable

	ld hl, wSelectedPrizeCardListPtr
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld [de], a ; store deck index
	inc de
	ld [hl], d
	dec hl
	ld [hl], e

	; add prize card to hand
	call AddCardToHand
	call LoadCardDataToBuffer1_FromDeckIndex
	call Set_OBJ_8x16
	bank1call OpenCardPage_FromHand
	ld a, [wNumberOfPrizeCardsToSelect]
	dec a
	ld [wNumberOfPrizeCardsToSelect], a
	ld a, [wYourOrOppPlayAreaCurPosition]
	call GetFirstSetPrizeCard
	ld [wYourOrOppPlayAreaCurPosition], a
	jp .check_prize_cards_to_select

.cursor_transition_table
	cursor_transition $08, $28, $00, $04, $02, $01, $01
	cursor_transition $30, $28, $20, $05, $03, $00, $00
	cursor_transition $08, $38, $00, $00, $04, $03, $03
	cursor_transition $30, $38, $20, $01, $05, $02, $02
	cursor_transition $08, $48, $00, $02, $00, $05, $05
	cursor_transition $30, $48, $20, $03, $01, $04, $04

_DrawPlayAreaToPlacePrizeCards::
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	call EmptyScreen
	call LoadSymbolsFont
	call LoadPlacingThePrizesScreenTiles

	ldh a, [hWhoseTurn]
	ld [wCheckMenuPlayAreaWhichLayout], a
	ld [wCheckMenuPlayAreaWhichDuelist], a

	lb de, 0, 10
	ld c, 3
	call DrawPlayArea_BenchCards
	ld hl, .player_icon_coordinates
	call DrawYourOrOppPlayArea_Icons.draw
	lb de, 8, 6
	ld a, $a0
	lb hl, 1, 4
	lb bc, 4, 3
	call FillRectangle

	call SwapTurn
	ld a, TRUE
	ld [wIsSwapTurnPending], a ; mark pending to swap turn
	ldh a, [hWhoseTurn]
	ld [wCheckMenuPlayAreaWhichDuelist], a
	lb de, 6, 0
	ld c, 3
	call DrawPlayArea_BenchCards
	ld hl, .opp_icon_coordinates
	call DrawYourOrOppPlayArea_Icons.draw
	lb de, 8, 3
	ld a, $a0
	lb hl, 1, 4
	lb bc, 4, 3
	call FillRectangle
	call SwapTurn
	ret

.player_icon_coordinates
	db 15, 11
	db 15,  6
	db 15,  8

.opp_icon_coordinates
	db  0,  0
	db  0,  4
	db  0,  2

; seems like a function to draw prize cards
; given a list of coordinates in hl
; hl = pointer to coords
Func_8bf2: ; unreferenced
	push hl
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld h, a
	ld l, DUELVARS_PRIZES
	ld a, [hl]
	pop hl

	ld b, 0
	push af
.loop_prize_cards
	inc b
	ld a, [wDuelInitialPrizes]
	inc a
	cp b
	jr z, .done
	pop af
	srl a
	push af
	jr c, .not_taken
	; same tile whether the prize card is taken or not
	ld a, $ac
	jr .got_tile
.not_taken
	ld a, $ac
.got_tile
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	push bc
	lb hl, 0, 0
	lb bc, 1, 1
	call FillRectangle
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .skip_pal
	ld a, $02
	lb bc, 1, 1
	lb hl, 0, 0
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0
.skip_pal
	pop bc
	pop hl
	jr .loop_prize_cards
.done
	pop af
	ret

; unknown data
Data_8c3f: ; unreferenced
	db $06, $05, $06, $06, $07, $05, $07, $06
	db $08, $05, $08, $06, $05, $0e, $05, $0d
	db $04, $0e, $04, $0d, $03, $0e, $03, $0d

; gets the first prize card index that is set
; beginning from index in register a
; a = prize card index
GetFirstSetPrizeCard:
	push bc
	push de
	push hl
	ld e, PRIZES_6
	ld c, a
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_PRIZES
	ld d, [hl]
.loop_prizes
	call .GetPrizeMask
	and d
	jr nz, .done ; prize is set
	dec e
	jr nz, .next_prize
	ld c, 0
	jr .done
.next_prize
	inc c
	ld a, PRIZES_6
	cp c
	jr nz, .loop_prizes
	ld c, 0
	jr .loop_prizes

.done
	ld a, c ; first prize index that is set
	pop hl
	pop de
	pop bc
	ret

; returns 1 shifted left by c bits
.GetPrizeMask
	push bc
	ld a, c
	ld b, $1
.loop
	or a
	jr z, .got_mask
	sla b
	dec a
	jr .loop
.got_mask
	ld a, b
	pop bc
	ret
