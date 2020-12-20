_OpenDuelCheckMenu: ; 8000 (2:4000)
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

.jump_table: ; 8031 (2:4031)
	dw DuelCheckMenu_InPlayArea
	dw DuelCheckMenu_Glossary
	dw DuelCheckMenu_YourPlayArea
	dw DuelCheckMenu_OppPlayArea

; opens the In Play Area submenu
DuelCheckMenu_InPlayArea: ; 8039 (2:4039)
	xor a
	ld [wInPlayAreaFromSelectButton], a
	farcall OpenInPlayAreaScreen
	ret

; opens the Glossary submenu
DuelCheckMenu_Glossary: ; 8042 (2:4042)
	farcall OpenGlossaryScreen
	ret

; opens the Your Play Area submenu
DuelCheckMenu_YourPlayArea: ; 8047 (2:4047)
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

.jump_table ; 8098 (2:4098)
	dw OpenYourOrOppPlayAreaScreen_TurnHolderPlayArea
	dw OpenYourOrOppPlayAreaScreen_TurnHolderHand
	dw OpenYourOrOppPlayAreaScreen_TurnHolderDiscardPile

OpenYourOrOppPlayAreaScreen_TurnHolderPlayArea: ; 809e (2:409e)
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderPlayAreaScreen
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_NonTurnHolderPlayArea: ; 80a8 (2:40a8)
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderPlayAreaScreen
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_TurnHolderHand: ; 80b2 (2:40b2)
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_NonTurnHolderHand: ; 80bc (2:40bc)
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_TurnHolderDiscardPile: ; 80c6 (2:40c6)
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderDiscardPileScreen
	pop af
	ldh [hWhoseTurn], a
	ret

OpenYourOrOppPlayAreaScreen_NonTurnHolderDiscardPile: ; 80d0 (2:40d0)
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderDiscardPileScreen
	pop af
	ldh [hWhoseTurn], a
	ret

; opens the Opp. Play Area submenu
; if clairvoyance is active, add the option to check
; opponent's hand
DuelCheckMenu_OppPlayArea: ; 80da (2:40da)
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

CheckMenuData: ; 8158 (2:4158)
	textitem  2, 14, InPlayAreaText
	textitem  2, 16, YourPlayAreaText
	textitem 12, 14, GlossaryText
	textitem 12, 16, OppPlayAreaText
	db $ff

YourPlayAreaMenuData: ; 8169 (2:4169)
	textitem  2, 14, YourPokemonText
	textitem 12, 14, YourHandText
	textitem  2, 16, YourDiscardPileText2
	db $ff

OppPlayAreaMenuData: ; 8176 (2:4176)
	textitem  2, 14, OpponentsPokemonText
	textitem  2, 16, OpponentsDiscardPileText2
	db $ff

OppPlayAreaMenuData_WithClairvoyance: ; 8176 (2:4176)
	textitem  2, 14, OpponentsPokemonText
	textitem 12, 14, OpponentsHandText
	textitem  2, 16, OpponentsDiscardPileText2
	db $ff

; checks if arrows need to be erased in Your Play Area or Opp. Play Area
; and draws new arrows upon cursor position change
; input:
; a = an initial offset applied to the cursor position (used to adjust
; for the different layouts of the Your Play Area and Opp. Play Area screens)
DrawYourOrOppPlayArea_RefreshArrows: ; 818c (2:418c)
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
DrawYourOrOppPlayArea_EraseArrows: ; 81af (2:41af)
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
DrawYourOrOppPlayArea_DrawArrows: ; 81ba (2:41ba)
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

YourOrOppPlayAreaArrowPositions: ; 81d7 (2:41d7)
	dw YourOrOppPlayAreaArrowPositions_PlayerPokemon
	dw YourOrOppPlayAreaArrowPositions_PlayerHand
	dw YourOrOppPlayAreaArrowPositions_PlayerDiscardPile
	dw YourOrOppPlayAreaArrowPositions_OpponentPokemon
	dw YourOrOppPlayAreaArrowPositions_OpponentHand
	dw YourOrOppPlayAreaArrowPositions_OpponentDiscardPile

YourOrOppPlayAreaArrowPositions_PlayerPokemon: ; 81e3 (2:41e3)
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
DrawYourOrOppPlayAreaScreen: ; 8209 (2:4209)
; loads the turn holders
	ld a, h
	ld [wCheckMenuPlayAreaWhichDuelist], a
	ld a, l
	ld [wCheckMenuPlayAreaWhichLayout], a
; fallthrough

; loads tiles and icons to display Your Play Area / Opp. Play Area screen,
; and draws the screen according to the turn player
; input: [wCheckMenuPlayAreaWhichDuelist] and [wCheckMenuPlayAreaWhichLayout]
_DrawYourOrOppPlayAreaScreen: ; 8211 (2:4211)
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

	ld e, $00
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

Func_82b6: ; 82b6 (2:42b6)
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
DrawInPlayAreaScreen: ; 82ce (2:42ce)
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions

	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call EmptyScreen

	ld a, $0a
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
_DrawPlayersPrizeAndBenchCards: ; 833c (2:433c)
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
DrawYourOrOppPlayArea_ActiveCardGfx: ; 837e (2:437e)
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
DrawInPlayArea_ActiveCardGfx: ; 83cc (2:43cc)
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
DrawPlayArea_PrizeCards: ; 8464 (2:4464)
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

PrizeCardsCoordinateData_YourOrOppPlayArea: ; 84b4 (2:44b4)
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
PrizeCardsCoordinateData_2: ; 84cc (2:44cc)
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

PrizeCardsCoordinateData_InPlayArea: ; 84e4 (2:44e4)
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
GetDuelInitialPrizesUpperBitsSet: ; 84fc (2:44fc)
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
DrawPlayArea_BenchCards: ; 8511 (2:4511)
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
DrawYourOrOppPlayArea_Icons: ; 85aa (2:45aa)
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
DrawPlayArea_IconWithValue: ; 85e1 (2:45e1)
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

	ld hl, wOnesAndTensPlace
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

PlayAreaIconCoordinates: ; 8635 (2:4635)
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
DrawInPlayArea_Icons: ; 864d (2:464d)
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
	ld e, $ed
	ld a, [de]
	ld b, a
	ld a, $d8 ; discard pile tile
	call DrawPlayArea_IconWithValue
	ret

; prints text HandText_2 and a cross with decimal value of b
; input
; b = value to print alongside text
DrawPlayArea_HandText: ; 8676 (2:4676)
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
	ld hl, wOnesAndTensPlace
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
HandleCheckMenuInput_YourOrOppPlayArea: ; 86ac (2:46ac)
	xor a
	ld [wPlaysSfx], a
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
	ld a, $01
	ld [wPlaysSfx], a
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
	ld a, [wPlaysSfx]
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
EraseCheckMenuCursor_YourOrOppPlayArea: ; 8741 (2:4741)
	ld a, SYM_SPACE ; white tile
; fallthrough

; draws in the cursor position
; input:
; a = tile byte to draw
DrawCheckMenuCursor_YourOrOppPlayArea: ; 8743 (2:4743)
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

DisplayCheckMenuCursor_YourOrOppPlayArea: ; 8760 (2:4760)
	ld a, SYM_CURSOR_R ; load cursor byte
	jr DrawCheckMenuCursor_YourOrOppPlayArea

; seems to be function to deal with the Peek menu
; to select a prize card to view
Func_8764: ; 8764 (2:4764)
	call Set_OBJ_8x8
	call LoadCursorTile
; reset ce5c and ce56
	xor a
	ld [$ce5c], a
	ld [$ce56], a

; draw play area screen for the turn player
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, a
	call DrawYourOrOppPlayAreaScreen

.swap
	ld a, [$ce56]
	or a
	jr z, .draw_menu
; if ce56 != 0, swap turn
	call SwapTurn
	xor a
	ld [$ce56], a

.draw_menu
	xor a
	ld hl, PlayAreaMenuParameters
	call InitializeMenuParameters
	call DrawWideTextBox

	ld hl, YourOrOppPlayAreaData
	call PlaceTextItems

.loop_1
	call DoFrame
	call HandleMenuInput ; await input
	jr nc, .loop_1
	cp $ff
	jr z, .loop_1

	call EraseCursor
	ldh a, [hCurMenuItem]
	or a
	jp nz, Func_8883 ; jump if not first option

; hCurMenuItem = 0
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld b, a
	ldh a, [hWhoseTurn]
	cp b
	jr z, .text

; switch the play area to draw
	ld h, a
	ld l, a
	call DrawYourOrOppPlayAreaScreen
	xor a
	ld [$ce56], a

.text
	call DrawWideTextBox
	lb de, $01, $0e
	call InitTextPrinting
	ldtx hl, WhichCardWouldYouLikeToSeeText
	call ProcessTextFromID

	xor a
	ld [wPrizeCardCursorPosition], a
	ld de, Func_8764_TransitionTable
	ld hl, wce53
	ld [hl], e
	inc hl
	ld [hl], d

.loop_2
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call Func_89ae
	jr c, .asm_87e7
	jr .loop_2
.asm_87e7
	cp $ff
	jr nz, .asm_87f0
	call ZeroObjectPositionsWithCopyToggleOn
	jr .swap
.asm_87f0
	ld hl, .asm_87f8
	call JumpToFunctionInTable
	jr .loop_2

.asm_87f8
rept 6
	dw Func_8819
endr
	dw Func_883c
	dw Func_8849

YourOrOppPlayAreaData: ; 8808 (2:4808)
	textitem 2, 14, YourPlayAreaText
	textitem 2, 16, OppPlayAreaText
	db $ff

PlayAreaMenuParameters: ; 8811 (2:4811)
	db 1, 14 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw $0000 ; function pointer if non-0

Func_8819: ; 8819 (2:4819)
	ld a, [wPrizeCardCursorPosition]
	ld c, a
	ld b, $01

; left-shift b a number of times
; corresponding to this prize card
.loop
	or a
	jr z, .asm_8827
	sla b
	dec a
	jr .loop

.asm_8827
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	and b
	ret z ; return if prize card taken

	ld a, c
	add $40
	ld [$ce5c], a
	ld a, c
	add DUELVARS_PRIZE_CARDS
	call GetTurnDuelistVariable
	jr Func_8855

Func_883c: ; 883c (2:483c)
	call CreateHandCardList
	ret c
	ld hl, wDuelTempList
	call ShuffleCards
	ld a, [hl]
	jr Func_8855

Func_8849: ; 8849 (2:4849)
	call CreateDeckCardList
	ret c
	ld a, %01111111
	ld [$ce5c], a
	ld a, [wDuelTempList]
; fallthrough

; input:
; a = deck index of card to be loaded
; output:
; a = ce5c
; with upper bit set if turn was swapped
Func_8855: ; 8855 (2:4855)
	ld b, a
	ld a, [$ce5c]
	or a
	jr nz, .display
	ld a, b
	ld [$ce5c], a
.display
	ld a, b
	call LoadCardDataToBuffer1_FromDeckIndex
	call Set_OBJ_8x16
	bank1call OpenCardPage_FromHand
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	pop af

; if ce56 != 0, swap turn
	ld a, [$ce56]
	or a
	jr z, .dont_swap
	call SwapTurn
	ld a, [$ce5c]
	or %10000000
	ret
.dont_swap
	ld a, [$ce5c]
	ret

Func_8883: ; 8883 (2:4883)
	ld a, [wCheckMenuPlayAreaWhichDuelist]
	ld b, a
	ldh a, [hWhoseTurn]
	cp b
	jr nz, .text

	ld l, a
	cp PLAYER_TURN
	jr nz, .opponent
	ld a, OPPONENT_TURN
	jr .draw
.opponent
	ld a, PLAYER_TURN

.draw
	ld h, a
	call DrawYourOrOppPlayAreaScreen

.text
	call DrawWideTextBox
	lb de, $01, $0e
	call InitTextPrinting
	ldtx hl, WhichCardWouldYouLikeToSeeText
	call ProcessTextFromID

	xor a
	ld [wPrizeCardCursorPosition], a
	ld de, Func_8883_TransitionTable
	ld hl, wce53
	ld [hl], e
	inc hl
	ld [hl], d

	call SwapTurn
	ld a, $01
	ld [$ce56], a
	jp Func_8764.loop_2

Func_8764_TransitionTable: ; 88c2 (2:48c2)
	cursor_transition $08, $28, $00, $04, $02, $01, $07
	cursor_transition $30, $28, $20, $05, $03, $07, $00
	cursor_transition $08, $38, $00, $00, $04, $03, $07
	cursor_transition $30, $38, $20, $01, $05, $07, $02
	cursor_transition $08, $48, $00, $02, $00, $05, $07
	cursor_transition $30, $48, $20, $03, $01, $07, $04
	cursor_transition $78, $50, $00, $07, $07, $00, $01
	cursor_transition $78, $28, $00, $07, $07, $00, $01

Func_8883_TransitionTable:
	cursor_transition $a0, $60, $20, $02, $04, $07, $01
	cursor_transition $78, $60, $00, $03, $05, $00, $07
	cursor_transition $a0, $50, $20, $04, $00, $06, $03
	cursor_transition $78, $50, $00, $05, $01, $02, $06
	cursor_transition $a0, $40, $20, $00, $02, $06, $05
	cursor_transition $78, $40, $00, $01, $03, $04, $06
	cursor_transition $08, $38, $00, $07, $07, $05, $04
	cursor_transition $08, $60, $00, $06, $06, $01, $00

Func_8932: ; 8932 (2:4932)
	INCROM $8932, $8992

LoadCursorTile: ; 8992 (2:4992)
	ld de, v0Tiles0
	ld hl, .tile_data
	ld b, 16
	call SafeCopyDataHLtoDE
	ret

.tile_data: ; 899e (2:499e)
	db $e0, $c0, $98, $b0, $84, $8c, $83, $82
	db $86, $8f, $9d, $be, $f4, $f8, $50, $60

; similar to OpenInPlayAreaScreen_HandleInput
Func_89ae: ; 89ae (2:49ae)
	xor a
	ld [wPlaysSfx], a

	ld hl, wce53
	ld e, [hl]
	inc hl
	ld d, [hl]

	ld a, [wPrizeCardCursorPosition]
	ld [wPrizeCardCursorTemporaryPosition], a
	ld l, a
	ld h, 7
	call HtimesL
	add hl, de
; hl = [wce53] + 7 * wce52

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
	ld [wPrizeCardCursorPosition], a
	cp $08 ; if a >= 0x8
	jr nc, .next
	ld b, $01

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
	jr nz, Func_89ae
	; move once more in the direction (recursively) until it reaches an existing item.

; check if one of the dpad, left or right, is pressed.
; if not, just go back to the start.
	ldh a, [hDPadHeld]
	bit D_RIGHT_F, a
	jr nz, .left_or_right
	bit D_LEFT_F, a
	jr z, Func_89ae

.left_or_right
	ld a, [wDuelInitialPrizes]
	cp $05
	jr nc, .next
	ld a, [wPrizeCardCursorPosition]
	cp $05
	jr nz, .asm_8a28
	ld a, $03
	ld [wPrizeCardCursorPosition], a
	jr .asm_8a2d

.asm_8a28
	ld a, $02
	ld [wPrizeCardCursorPosition], a
.asm_8a2d
	ld a, [wDuelInitialPrizes]
	cp $03
	jr nc, .asm_8a3c
	ld a, [wPrizeCardCursorPosition]
	sub $02
	ld [wPrizeCardCursorPosition], a
.asm_8a3c
	ld a, [wPrizeCardCursorPosition]
	ld [wPrizeCardCursorTemporaryPosition], a
	ld b, $01
	jr .make_bitmask_loop

.next
	ld a, $01
	ld [wPlaysSfx], a

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
	ld a, [wPrizeCardCursorPosition]
	scf
	ret

.return
	ld a, [wPlaysSfx]
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
	ld hl, wce53
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wPrizeCardCursorPosition]
	ld l, a
	ld h, 7
	call HtimesL
	add hl, de
; hl = [wce53] + 7 * wce52

	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld b, [hl]
	ld c, $00
	call SetOneObjectAttributes
	or a
	ret

ZeroObjectPositionsWithCopyToggleOn: ; 8aa1 (2:4aa1)
	call ZeroObjectPositions

	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret

Func_8aaa: ; 8aaa (2:4aaa)
	INCROM $8aaa, $8b85

Func_8b85: ; 8b85 (2:4b85)
	INCROM $8b85, $8c8e

OpenGlossaryScreen_TransitionTable:
	cursor_transition $08, $28, $00, $04, $01, $05, $05
	cursor_transition $08, $38, $00, $00, $02, $06, $06
	cursor_transition $08, $48, $00, $01, $03, $07, $07
	cursor_transition $08, $58, $00, $02, $04, $08, $08
	cursor_transition $08, $68, $00, $03, $00, $09, $09
	cursor_transition $58, $28, $00, $09, $06, $00, $00
	cursor_transition $58, $38, $00, $05, $07, $01, $01
	cursor_transition $58, $48, $00, $06, $08, $02, $02
	cursor_transition $58, $58, $00, $07, $09, $03, $03
	cursor_transition $58, $68, $00, $08, $05, $04, $04

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
	ld a, $ff ; cancel
	call PlaySFXConfirmOrCancel
	call Func_8fe8
	scf
	ret

Func_8e05: ; 8e05 (2:4e05)
	ld a, $1
	call PlaySFXConfirmOrCancel
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
	call ResetCheckMenuCursorPositionAndBlink
.asm_8e4e
	call DoFrame
	call HandleCheckMenuInput
	jp nc, .asm_8e4e
	cp $ff
	jr nz, .asm_8e64
	call EraseCheckMenuCursor
	ld a, [wceb1]
	jp Func_8dbc
.asm_8e64
	ld a, [wCheckMenuCursorXPosition]
	or a
	jp nz, Func_8f8a
	ld a, [wCheckMenuCursorYPosition]
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
	ld a, [wCheckMenuCursorYPosition]
	or a
	jp nz, Func_9026
	call Func_8ff2
	jp nc, Func_8f9d
	call Func_8fe8
	jp Func_8dbc

Func_8f9d: ; 8f9d (2:4f9d)
	call EnableSRAM
	ld a, [sCurrentlySelectedDeck]
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
	ld [sCurrentlySelectedDeck], a
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

ResetCheckMenuCursorPositionAndBlink: ; 905a (2:505a)
	xor a
	ld [wCheckMenuCursorXPosition], a
	ld [wCheckMenuCursorYPosition], a
	ld [wCheckMenuCursorBlinkCounter], a
	ret

; handle player input in check menu
; works out which cursor coordinate to go to
; and sets carry flag if A or B are pressed
; returns a =  $1 if A pressed
; returns a = $ff if B pressed
HandleCheckMenuInput: ; 9065 (2:5065)
	xor a
	ld [wPlaysSfx], a
	ld a, [wCheckMenuCursorXPosition]
	ld d, a
	ld a, [wCheckMenuCursorYPosition]
	ld e, a

; d = cursor x position
; e = cursor y position

	ldh a, [hDPadHeld]
	or a
	jr z, .no_pad
	bit D_LEFT_F, a
	jr nz, .horizontal
	bit D_RIGHT_F, a
	jr z, .check_vertical

; handle horizontal input
.horizontal
	ld a, d
	xor $1 ; flips x coordinate
	ld d, a
	jr .okay
.check_vertical
	bit D_UP_F, a
	jr nz, .vertical
	bit D_DOWN_F, a
	jr z, .no_pad

; handle vertical input
.vertical
	ld a, e
	xor $01 ; flips y coordinate
	ld e, a

.okay
	ld a, $01
	ld [wPlaysSfx], a
	push de
	call EraseCheckMenuCursor
	pop de

; update x and y cursor positions
	ld a, d
	ld [wCheckMenuCursorXPosition], a
	ld a, e
	ld [wCheckMenuCursorYPosition], a

; reset cursor blink
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
.no_pad
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .no_input
	and A_BUTTON
	jr nz, .a_press
	ld a, $ff ; cancel
	call PlaySFXConfirmOrCancel
	scf
	ret

.a_press
	call DisplayCheckMenuCursor
	ld a, $01
	call PlaySFXConfirmOrCancel
	scf
	ret

.no_input
	ld a, [wPlaysSfx]
	or a
	jr z, .check_blink
	call PlaySFX

.check_blink
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and %00001111
	ret nz  ; only update cursor if blink's lower nibble is 0

	ld a, SYM_CURSOR_R ; cursor byte
	bit 4, [hl] ; only draw cursor if blink counter's fourth bit is not set
	jr z, DrawCheckMenuCursor

; draws in the cursor position
EraseCheckMenuCursor: ; 90d8 (2:50d8)
	ld a, SYM_SPACE ; empty cursor
; fallthrough

; draws in the cursor position
; input:
; a = tile byte to draw
DrawCheckMenuCursor: ; 90da (2:50da)
	ld e, a
	ld a, 10
	ld l, a
	ld a, [wCheckMenuCursorXPosition]
	ld h, a
	call HtimesL

	ld a, l
	add 1
	ld b, a
	ld a, [wCheckMenuCursorYPosition]
	sla a
	add 14
	ld c, a

	ld a, e
	call WriteByteToBGMap0
	or a
	ret

DisplayCheckMenuCursor: ; 90f7 (2:50f7)
	ld a, SYM_CURSOR_R
	jr DrawCheckMenuCursor

; plays sound depending on value in a
; input:
; a  = $ff: play cancel sound
; a != $ff: play confirm sound
PlaySFXConfirmOrCancel: ; 90fb (2:50fb)
	push af
	inc a
	jr z, .asm_9103
	ld a, SFX_02 ; confirmation sfx
	jr .asm_9105
.asm_9103
	ld a, SFX_03 ; cancellation sfx
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
	ld a, [sCurrentlySelectedDeck]
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
	ld [sCurrentlySelectedDeck], a
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
	ld a, [sCurrentlySelectedDeck]
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
	INCROM $9345, $9649

; checks if selected deck has any basics
Func_9649: ; 9649 (2:5649)
	ld hl, wcf17
.asm_964c
	ld a, [hli]
	ld e, a
	or a
	jr z, .asm_9665
	call LoadCardDataToBuffer1_FromCardID
	jr c, .asm_9665
	ld a, [wLoadedCard1Type]
	and $08
	jr nz, .asm_964c
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .asm_964c
	scf
	ret
.asm_9665
	or a
	ret
; 0x9667

	INCROM $9667, $9843

Func_9843: ; 9843 (2:5843)
	INCROM $9843, $98a6

; determines the ones and tens digits in a for printing
; the ones place is added $20 (SYM_0) so that it maps to a numerical character
; if the tens is 0, it maps to an empty character
; a = value to calculate digits
CalculateOnesAndTensDigits: ; 98a6 (2:58a6)
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
	ld hl, wOnesAndTensPlace
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

	INCROM $98c7, $9e41

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
	call ResetCheckMenuCursorPositionAndBlink
	call DrawWideTextBox
	ld hl, $7274
	call PlaceTextItems
	call DoFrame
	call HandleCheckMenuInput
	jp nc, $71e7
	cp $ff
	jr nz, .asm_b1fa
	ld a, [wd086]
	jp $71b3

.asm_b1fa
	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld hl, wCheckMenuCursorXPosition
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
	call PlaySFXConfirmOrCancel
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
	call ResetCheckMenuCursorPositionAndBlink
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
	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld hl, wCheckMenuCursorXPosition
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
	call PlaySFXConfirmOrCancel
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
