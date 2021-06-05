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
	ld a, TRUE
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
; 0x8760

DisplayCheckMenuCursor_YourOrOppPlayArea: ; 8760 (2:4760)
	ld a, SYM_CURSOR_R ; load cursor byte
	jr DrawCheckMenuCursor_YourOrOppPlayArea

; handles Peek Pkmn Power selection menus
_HandlePeekSelection: ; 8764 (2:4764)
	call Set_OBJ_8x8
	call LoadCursorTile
; reset ce5c and wIsSwapTurnPending
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
rept 6
	dw .SelectedPrize
endr
	dw .SelectedOppsHand
	dw .SelectedDeck

.YourOrOppPlayAreaData ; 8808 (2:4808)
	textitem 2, 14, YourPlayAreaText
	textitem 2, 16, OppPlayAreaText
	db $ff

.PlayAreaMenuParameters ; 8811 (2:4811)
	db 1, 14 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

.SelectedPrize: ; 8819 (2:4819)
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

.SelectedOppsHand ; 883c (2:483c)
	call CreateHandCardList
	ret c
	ld hl, wDuelTempList
	call ShuffleCards
	ld a, [hl]
	jr .ShowSelectedCard

.SelectedDeck ; 8849 (2:4849)
	call CreateDeckCardList
	ret c
	ld a, %01111111
	ld [wce5c], a
	ld a, [wDuelTempList]
; fallthrough

; input:
; a = deck index of card to be loaded
; output:
; a = ce5c
; with upper bit set if turn was swapped
.ShowSelectedCard ; 8855 (2:4855)
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
.PrepareYourPlayAreaSelection: ; 8883 (2:4883)
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

PeekYourPlayAreaTransitionTable: ; 88c2 (2:48c2)
	cursor_transition $08, $28, $00, $04, $02, $01, $07
	cursor_transition $30, $28, $20, $05, $03, $07, $00
	cursor_transition $08, $38, $00, $00, $04, $03, $07
	cursor_transition $30, $38, $20, $01, $05, $07, $02
	cursor_transition $08, $48, $00, $02, $00, $05, $07
	cursor_transition $30, $48, $20, $03, $01, $07, $04
	cursor_transition $78, $50, $00, $07, $07, $00, $01
	cursor_transition $78, $28, $00, $07, $07, $00, $01

PeekOppPlayAreaTransitionTable: ; 88fa (2:48fa)
	cursor_transition $a0, $60, $20, $02, $04, $07, $01
	cursor_transition $78, $60, $00, $03, $05, $00, $07
	cursor_transition $a0, $50, $20, $04, $00, $06, $03
	cursor_transition $78, $50, $00, $05, $01, $02, $06
	cursor_transition $a0, $40, $20, $00, $02, $06, $05
	cursor_transition $78, $40, $00, $01, $03, $04, $06
	cursor_transition $08, $38, $00, $07, $07, $05, $04
	cursor_transition $08, $60, $00, $06, $06, $01, $00

_DrawAIPeekScreen: ; 8932 (2:4932)
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
; 0x8992

LoadCursorTile: ; 8992 (2:4992)
	ld de, v0Tiles0
	ld hl, .tile_data
	ld b, 16
	call SafeCopyDataHLtoDE
	ret

.tile_data: ; 899e (2:499e)
	db $e0, $c0, $98, $b0, $84, $8c, $83, $82
	db $86, $8f, $9d, $be, $f4, $f8, $50, $60

; handles input inside the "Your Play Area" or "Opp Play Area" screens
; returns carry if either A or B button were pressed
; returns -1 in a if B button was pressed
YourOrOppPlayAreaScreen_HandleInput: ; 89ae (2:49ae)
	xor a
	ld [wPlaysSfx], a

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
	ld a, TRUE
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
	ld a, [wYourOrOppPlayAreaCurPosition]
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

ZeroObjectPositionsWithCopyToggleOn: ; 8aa1 (2:4aa1)
	call ZeroObjectPositions

	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret

; handles the screen for Player to select prize card(s)
_SelectPrizeCards: ; 8aaa (2:4aaa)
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
; 0x8b85

_DrawPlayAreaToPlacePrizeCards: ; 8b85 (2:4b85)
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
; 0x8bf2

; seems like a function to draw prize cards
; given a list of coordinates in hl
; unreferenced?
; hl = pointer to coords
Func_8bf2: ; 8bf2 (2:4bf2)
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
; 0x8c3f

; unknown data
; unreferenced?
Data_8c3f: ; 8c3f (6:4c3f)
	db $06, $05, $06, $06, $07, $05, $07, $06, $08, $05, $08, $06, $05, $0e, $05, $0d, $04, $0e, $04, $0d, $03, $0e, $03, $0d
; 0x8c57

; gets the first prize card index that is set
; beginning from index in register a
; a = prize card index
GetFirstSetPrizeCard: ; 8c57 (2:4c57)
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
; 0x8c8e

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

; copies DECK_SIZE number of cards from de to hl in SRAM
CopyDeckFromSRAM: ; 8cd4 (2:4cd4)
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
; 0x8ce7

; clears some WRAM addresses to act as
; terminator bytes to wFilteredCardList and wCurDeckCards
WriteCardListsTerminatorBytes: ; 8ce7 (2:4ce7)
	xor a
	ld hl, wFilteredCardList
	ld bc, DECK_SIZE
	add hl, bc
	ld [hl], a ; wcf16
	ld hl, wCurDeckCards
	ld bc, DECK_CONFIG_BUFFER_SIZE
	add hl, bc
	ld [hl], a ; wCurDeckCardsTerminator
	ret
; 0x8cf9

; inits some SRAM addresses
Func_8cf9: ; 8cf9 (2:4cf9)
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
LoadHandCardsIcon: ; 8d0b (2:4d0b)
	ld hl, HandCardsGfx
	ld de, v0Tiles2 + $38 tiles
	call CopyListFromHLToDE
	ret

HandCardsGfx: ; 8d15 (2:4d15)
	INCBIN "gfx/hand_cards.2bpp"
	db $00 ; end of data

EmptyScreenAndLoadFontDuelAndHandCardsIcons: ; 8d56 (2:4d56)
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont
	call LoadDuelCardSymbolTiles
	call LoadHandCardsIcon
	bank1call SetDefaultPalettes
	lb de, $3c, $bf
	call SetupText
	ret
; 0x8d78

; empties screen, zeroes object positions,
; loads cursor tile, symbol fonts, duel card symbols
; hand card icon and sets default palettes
Func_8d78: ; 8d78 (2:4d78)
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
	bank1call SetDefaultPalettes
	lb de, $3c, $bf
	call SetupText
	ret
; 0x8d9d

; inits the following deck building params from hl:
; wMaxNumCardsAllowed
; wSameNameCardsLimit
; wIncludeCardsInDeck
; wDeckConfigurationMenuHandlerFunction
; wDeckConfigurationMenuTransitionTable
InitDeckBuildingParams: ; 8d9d (2:4d9d)
	ld de, wMaxNumCardsAllowed
	ld b, $7
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ret

DeckBuildingParams: ; 8da9 (2:4da9)
	db DECK_CONFIG_BUFFER_SIZE ; max number of cards
	db MAX_NUM_SAME_NAME_CARDS ; max number of same name cards
	db TRUE ; whether to include deck cards
	dw HandleDeckConfigurationMenu
	dw DeckConfigurationMenu_TransitionTable
; 0x8db0

DeckSelectionMenu: ; 8db0 (2:4db0)
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
HandleStartButtonInDeckSelectionMenu: ; 8dea (2:4dea)
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
; 0x8e1f

OpenDeckConfirmationMenu: ; 8e1f (2:4e1f)
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
	call ClearNBytesFromHL
	ld a, DECK_SIZE
	ld [wTotalCardCount], a
	ld hl, wCardFilterCounts
	ld [hl], a
	call HandleDeckConfirmationMenu
	ret
; 0x8e42

; handles the submenu when selecting a deck
; (Modify Deck, Select Deck, Change Name and Cancel)
DeckSelectionSubMenu: ; 8e42 (2:4e42)
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
	call ClearNBytesFromHL
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
	call ClearNBytesFromHL
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
InputCurDeckName: ; 8f05 (2:4f05)
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
; 0x8f8a

; handle deck selection sub-menu
; the option is either "Select Deck" or "Cancel"
; depending on the cursor Y pos
DeckSelectionSubMenu_SelectOrCancel: ; 8f8a (2:4f8a)
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
; 0x8fe8

PrintThereIsNoDeckHereText: ; 8fe8 (2:4fe8)
	ldtx hl, ThereIsNoDeckHereText
	call DrawWideTextBox_WaitForInput
	ld a, [wCurDeck]
	ret

; returns carry if deck in wCurDeck
; is not a valid deck
CheckIfCurDeckIsValid: ; 8ff2 (2:4ff2)
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
; 0x9001

; write to $d00a the decimal representation (number characters)
; of the value in hl
; unreferenced?
Func_9001: ; 9001 (2:5001)
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
; 0x9026

CancelDeckSelectionSubMenu: ; 9026 (2:5026)
	ret

DeckSelectionData: ; 9027 (2:5027)
	textitem  2, 14, ModifyDeckText
	textitem 12, 14, SelectDeckText
	textitem  2, 16, ChangeNameText
	textitem 12, 16, CancelText
	db $ff
; 0x9038

; return, in hl, the pointer to sDeckXName where X is [wCurDeck] + 1
GetPointerToDeckName: ; 9038 (2:5038)
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
GetPointerToDeckCards: ; 9048 (2:5048)
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
	ld a, TRUE
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

; goes through whole deck in hl
; for each card ID, goes to its corresponding
; entry in sCardCollection and decrements its count
DecrementDeckCardsInCollection: ; 910a (2:510a)
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
; 0x9120

; like AddDeckToCollection, but takes care to
; check if increasing the collection count would
; go over MAX_AMOUNT_OF_CARD and caps it
; this is because it's used within Gift Center,
; so we cannot assume that the deck configuration
; won't make it go over MAX_AMOUNT_OF_CARD
; hl = deck configuration, with cards to add
AddGiftCenterDeckCardsToCollection: ; 9120 (2:5120)
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
; 0x9152

; adds all cards in deck in hl to player's collection
; assumes SRAM is enabled
; hl = pointer to deck cards
AddDeckToCollection: ; 9152 (2:5152)
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
DrawDecksScreen: ; 9168 (2:5168)
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
	call ClearNBytesFromHL

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
; 0x9242

DeckNameMenuData: ; 9242 (2:5242)
	textitem 4,  2, Deck1Text
	textitem 4,  5, Deck2Text
	textitem 4,  8, Deck3Text
	textitem 4, 11, Deck4Text
	db $ff
; 0x9253

; copies text from hl to wDefaultText
; with " deck" appended to the end
; hl = ptr to deck name
CopyDeckName: ; 9253 (2:5253)
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
PrintDeckName: ; 926e (2:526e)
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

DeckNameSuffix: ; 92a7 (2:52a7)
	db " deck"
	done

; copies a $00-terminated list from hl to de
CopyListFromHLToDE: ; 92ad (2:52ad)
	ld a, [hli]
	ld [de], a
	or a
	ret z
	inc de
	jr CopyListFromHLToDE

; same as CopyListFromHLToDE, but for SRAM copying
CopyListFromHLToDEInSRAM: ; 92b4 (2:52b4)
	call EnableSRAM
	call CopyListFromHLToDE
	call DisableSRAM
	ret
; 0x92be

; appends text in hl to wDefaultText
; then adds "deck" to the end
; returns carry if deck has no cards
; hl = text to append
; de = input to InitTextPrinting
AppendDeckName: ; 92be (2:52be)
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
; 0x9314

; returns carry if the deck in hl
; is not valid, that is, has no cards
; alternatively, the direct address of the cards
; can be used, since DECK_SIZE > DECK_NAME_SIZE
; hl = deck name (sDeck1Name ~ sDeck4Name)
;   or deck cards (sDeck1Cards ~ sDeck4Cards)
CheckIfDeckHasCards: ; 9314 (2:5314)
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
DrawHandCardsTileOnCurDeck: ; 9326 (2:5326)
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
DrawHandCardsTileAtDE: ; 9339 (2:5339)
	ld a, $38 ; hand cards tile
	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle
	ret
; 0x9345

; handles user input when selecting a card filter
; when building a deck configuration
; the handling of selecting cards themselves from the list
; to add/remove to the deck is done in HandleDeckCardSelectionList
HandleDeckBuildScreen: ; 9345 (2:5345)
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
; 0x9461

OpenDeckConfigurationMenu: ; 9461 (2:5461)
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
; 0x9480

HandleDeckConfigurationMenu: ; 9480 (2:5480)
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
; 0x94d3

ConfirmDeckConfiguration: ; 94d3 (2:54d3)
	ld hl, wCardListVisibleOffset
	ld a, [hl]
	ld hl, wced8
	ld [hl], a
	call HandleDeckConfirmationMenu
	ld hl, wced8
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
; 0x9505

ModifyDeckConfiguration: ; 9505 (2:5505)
	add sp, $2
	jr HandleDeckConfigurationMenu.draw_icons
; 0x9509

; returns carry set if player chose to go back
CancelDeckModifications: ; 9509 (2:5509)
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

SaveDeckConfiguration: ; 951a (2:551a)
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
; 0x9566

DismantleDeck: ; 9566 (2:5566)
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
	call ClearNBytesFromHL
	call GetPointerToDeckCards
	call AddDeckToCollection
	ld a, DECK_SIZE
	call ClearNBytesFromHL
.done_dismantle
	call DisableSRAM
	add sp, $2
	ret
; 0x95b9

ChangeDeckName: ; 95b9 (2:55b9)
	call InputCurDeckName
	add sp, $2
	jp HandleDeckBuildScreen.skip_count
; 0x95c1

; returns carry if current deck was changed
; either through its card configuration or its name
CheckIfCurrentDeckWasChanged: ; 95c1 (2:55c1)
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
; 0x9622

; returns carry if doesn't have a valid deck
; aside from the current deck
CheckIfHasOtherValidDecks: ; 9622 (2:5622)
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
; 0x9649

; checks if wCurDeckCards has any basics
; returns carry set if there is at least
; 1 Basic Pokemon card
CheckIfThereAreAnyBasicCardsInDeck: ; 9649 (2:5649)
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
; 0x9667

FiltersCardSelectionParams: ; 9667 (2:5667)
	db 1 ; x pos
	db 1 ; y pos
	db 0 ; y spacing
	db 2 ; x spacing
	db NUM_FILTERS ; num entries
	db SYM_CURSOR_D ; visible cusor tile
	db SYM_SPACE ; invisible cusor tile
	dw NULL ; wCardListHandlerFunction

FilteredCardListSelectionParams: ; 9670 (2:5670)
	db 0 ; x pos
	db 7 ; y pos
	db 2 ; y spacing
	db 0 ; x spacing
	db NUM_FILTERED_LIST_VISIBLE_CARDS ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

DeckConfigurationMenu_TransitionTable: ; 9679 (2:5679)
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
DrawCardTypeIconsAndPrintCardCounts: ; 96a3 (2:56a3)
	call Set_OBJ_8x8
	call Func_8d78
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
; 0x96c7

; fills one line at coordinate bc in BG Map
; with the byte in register a
; fills the same line with $04 in VRAM1 if in CGB
; bc = coordinates
FillBGMapLineWithA: ; 96c7 (2:56c7)
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
; 0x96e3

; saves the count of each type of card that is in wCurDeckCards
; stores these values in wCardFilterCounts
CountNumberOfCardsForEachCardType: ; 96e3 (2:56e3)
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
; 0x96f4

; fills de with b bytes of the value in register a
FillDEWithA: ; 96f4 (2:56f4)
	push hl
	ld l, e
	ld h, d
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	pop hl
	ret
; 0x96fd

; draws all the card type icons
; in a line specified by .CardTypeIcons
DrawCardTypeIcons: ; 96fd (2:56fd)
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
; 0x9751

DeckBuildMenuData: ; 9751 (1:5751)
	; x, y, text id
	textitem  2, 2, ConfirmText
	textitem  9, 2, ModifyText
	textitem 16, 2, NameText
	textitem  2, 4, SaveText
	textitem  9, 4, DismantleText
	textitem 16, 4, CancelText
	db $ff

; prints "/60" to the coordinates given in de
PrintSlashSixty: ; 976a (2:576a)
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
; 0x978b

; creates two separate lists given the card type in register a
; if a card matches the card type given, then it's added to wFilteredCardList
; if a card has been owned by the player, and its card count is at least 1,
; (or in case it's 0 if it's in any deck configurations saved)
; then its collection count is also added to wOwnedCardsCountList
; if input a is $ff, then all card types are included
CreateFilteredCardList: ; 978b (2:578b)
	push af
	push bc
	push de
	push hl

; clear wOwnedCardsCountList and wFilteredCardList
	push af
	ld a, DECK_SIZE
	ld hl, wOwnedCardsCountList
	call ClearNBytesFromHL
	ld a, DECK_SIZE
	ld hl, wFilteredCardList
	call ClearNBytesFromHL
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
; 0x9803

; returns carry if card ID in register e is not
; found in any of the decks saved in SRAM
IsCardInAnyDeck: ; 9803 (2:5803)
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
; 0x9843

; preserves all registers
; hl = start of bytes to set to $0
; a = number of bytes to set to $0
ClearNBytesFromHL: ; 9843 (2:5843)
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
; 0x9850

; returns the number of times that card e
; appears in wCurDeckCards
GetCountOfCardInCurDeck: ; 9850 (2:5850)
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
; 0x9863

; returns total count of card ID e
; looks it up in wFilteredCardList
; then uses the index to retrieve the count
; value from wOwnedCardsCountList
GetOwnedCardCount: ; 9863 (2:5863)
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
; 0x9880

; appends text "X/Y", where X is the number of included cards
; and Y is the total number of cards in storage of a given card ID
; input:
; e = card ID
AppendOwnedCardCountAndStorageCountNumbers: ; 9880 (2:5880)
	push af
	push bc
	push de
	push hl
; count how many bytes untill $00
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
; 0x98a6

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

; converts value in register a to
; numerical symbols for ProcessText
; places the symbols in hl
ConvertToNumericalDigits: ; 98c7 (2:58c7)
	call CalculateOnesAndTensDigits
	push hl
	ld hl, wOnesAndTensPlace
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
; 0x98dc

; counts the number of cards in wCurDeckCards
; that are the same type as input in register a
; if input is $20, counts all energy cards instead
; input:
; - a = card type
; output:
; - a = number of cards of same type
CountNumberOfCardsOfType: ; 98dc (2:58dc)
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
; 0x9916

; prints the card count of each individual card type
; assumes CountNumberOfCardsForEachCardType was already called
; this is done by processing text in a single line
; and concatenating all digits
PrintCardTypeCounts: ; 9916 (2:5916)
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
; 0x993d

; prints the list of cards, applying the filter from register a
; the counts of each card displayed is taken from wCurDeck
; a = card type filter
PrintFilteredCardList: ; 993d (2:593d)
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
; 0x997d

; used to filter the cards in the deck building/card selection screen
CardTypeFilters: ; 997d (2:597d)
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
; 0x9987

; counts all the cards from each card type
; (stored in wCardFilterCounts) and store it in wTotalCardCount
; also prints it in coordinates de
PrintTotalCardCount: ; 9987 (2:5987)
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
; 0x99b0

; prints the name, level and storage count of the cards
; that are visible in the list window
; in the form:
; CARD NAME/LEVEL X/Y
; where X is the current count of that card
; and Y is the storage count of that card
PrintDeckBuildingCardList: ; 99b0 (2:59b0)
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
	db TX_SYMBOL, TX_END

Text_9a32:
	db TX_SYMBOL, TX_END

Text_9a34:
	db TX_SYMBOL, TX_END

Text_9a36:
	db TX_SYMBOL, TX_END

Text_9a38:
	db TX_SYMBOL, TX_END

Text_9a3a:
	db TX_SYMBOL, TX_END

Text_9a3c:
	db TX_SYMBOL, TX_END

Text_9a3e:
	db TX_SYMBOL, TX_END

Text_9a40:
	db TX_SYMBOL, TX_END

Text_9a42:
	db TX_SYMBOL, TX_END

Text_9a44:
	db TX_SYMBOL, TX_END

Text_9a46:
	db TX_SYMBOL, TX_END

Text_9a48:
	db TX_SYMBOL, TX_END

Text_9a4a:
	db TX_SYMBOL, TX_END

Text_9a4c:
	db TX_SYMBOL, TX_END

Text_9a4e:
	db TX_SYMBOL, TX_END

Text_9a50:
	db TX_SYMBOL, TX_END

Text_9a52:
	db TX_SYMBOL, TX_END

Text_9a54:
	db TX_SYMBOL, TX_END

Text_9a56:
	db TX_SYMBOL, TX_END

Text_9a58:
	done

; writes the card ID in register e to wVisibleListCardIDs
; given its position in the list in register b
; input:
; b = list position (starts from bottom)
; e = card ID
AddCardIDToVisibleList: ; 9a59 (2:5a59)
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
; 0x9a6d

; copies data from hl to:
; wCardListCursorXPos
; wCardListCursorYPos
; wCardListYSpacing
; wCardListXSpacing
; wCardListNumCursorPositions
; wVisibleCursorTile
; wInvisibleCursorTile
; wCardListHandlerFunction
InitCardSelectionParams: ; 9a6d (2:5a6d)
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
; 0x9a83

HandleCardSelectionInput: ; 9a83 (2:5a83)
	xor a ; FALSE
	ld [wPlaysSfx], a
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
	ld a, TRUE
	ld [wPlaysSfx], a
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
; 0x9ad7

; outputs cursor position in e and selection in a
ConfirmSelectionAndReturnCarry: ; 9ad7 (2:5ad7)
	call DrawHorizontalListCursor_Visible
	ld a, $01
	call PlaySFXConfirmOrCancel
	ld a, [wCardListCursorPos]
	ld e, a
	ld a, [hffb3]
	scf
	ret
; 0x9ae8

HandleCardSelectionCursorBlink: ; 9ae8 (2:5ae8)
	ld a, [wPlaysSfx]
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
; 0x9b00

DrawHorizontalListCursor_Invisible: ; 9b00 (2:5b00)
	ld a, [wInvisibleCursorTile]
;	fallthrough

; like DrawListCursor but only
; for lists with one line, and each entry
; being laid horizontally
; a = tile to write
DrawHorizontalListCursor: ; 9b03 (2:5b03)
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
; 0x9b20

DrawHorizontalListCursor_Visible: ; 9b20 (2:5b20)
	ld a, [wVisibleCursorTile]
	jr DrawHorizontalListCursor
; 0x9b25

; handles user input when selecting cards to add
; to deck configuration
; returns carry if a selection was made
; (either selected card or cancelled)
; outputs in a the list index if selection was made
; or $ff if operation was cancelled
HandleDeckCardSelectionList: ; 9b25 (2:5b25)
	xor a ; FALSE
	ld [wPlaysSfx], a

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
	ld a, TRUE
	ld [wPlaysSfx], a
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
	ld [wPlaysSfx], a
	jr .asm_9b8f

.check_d_down
	bit D_DOWN_F, b
	jr z, .asm_9b9d
	push af
	ld a, TRUE
	ld [wPlaysSfx], a
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
	ld [wPlaysSfx], a
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
	ld a, [wPlaysSfx]
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

DrawListCursor_Invisible: ; 9c0e (2:5c0e)
	ld a, [wInvisibleCursorTile]
;	fallthrough

; draws cursor considering wCardListCursorPos
; spaces each entry horizontally by wCardListXSpacing
; and vertically by wCardListYSpacing
; a = tile to write
DrawListCursor: ; 9c11 (2:5c11)
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
; 0x9c3a

DrawListCursor_Visible: ; 9c3a (2:5c3a)
	ld a, [wVisibleCursorTile]
	jr DrawListCursor
; 0x9c3f

OpenCardPageFromCardList: ; 9c3f (2:5c3f)
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
	ld [wPlaysSfx], a
	ld a, [wCardListNumCursorPositions]
	ld c, a
	ld a, [wCardListCursorPos]
	bit D_UP_F, b
	jr z, .check_d_down
	push af
	ld a, TRUE
	ld [wPlaysSfx], a
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
	ld a, TRUE
	ld [wPlaysSfx], a
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
	ld a, [wPlaysSfx]
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
; 0x9ced

; opens card page from the card list
; unreferenced?
Func_9ced: ; 9ced (2:5ced)
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
; 0x9d0c

; adds card in register e to deck configuration
; and updates the values shown for its count
; in the card selection list
; input:
; e = card ID
AddCardToDeckAndUpdateCount: ; 9d0c (2:5d0c)
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
; 0x9d22

; tries to add card ID in register e to wCurDeckCards
; fails to add card if one of the following conditions are met:
; - total cards are equal to wMaxNumCardsAllowed
; - cards with the same name as it reached the allowed limit
; - player doesn't own more copies in the collection
; returns carry if fails
; otherwise, writes card ID to first empty slot in wCurDeckCards
; input:
; e = card ID
TryAddCardToDeck: ; 9d22 (2:5d22)
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

	ld a, SFX_01
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
; 0x9db3

; gets the element in wVisibleListCardIDs
; corresponding to index wCardListCursorPos
GetSelectedVisibleCardID: ; 9db3 (2:5db3)
	ld hl, wVisibleListCardIDs
	ld a, [wCardListCursorPos]
	ld e, a
	ld d, $00
	add hl, de
	ld e, [hl]
	ret
; 0x9dbf

; appends the digits of value in register a to wDefaultText
; then prints it in cursor Y position
; a = value to convert to numerical digits
PrintNumberValueInCursorYPos: ; 9dbf (2:5dbf)
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
; 0x9de4

; removes card in register e from deck configuration
; and updates the values shown for its count
; in the card selection list
; input:
; e = card ID
RemoveCardFromDeckAndUpdateCount: ; 9de4 (2:5de4)
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
; 0x9dfa

; removes card ID in e from wCurDeckCards
RemoveCardFromDeck: ; 9dfa (2:5dfa)
	push de
	call GetCountOfCardInCurDeck
	pop de
	or a
	ret z ; card is not in deck
	ld a, SFX_01
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
; 0x9e31

UpdateConfirmationCardScreen: ; 9e31 (2:5e31)
	ld hl, hffb0
	ld [hl], $01
	call PrintCurDeckNumberAndName
	ld hl, hffb0
	ld [hl], $00
	jp PrintConfirmationCardList
; 0x9e41

HandleDeckConfirmationMenu: ; 9e41 (2:5e41)
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

	; set wOwnedCardsCountList as current card list
	; and show card page screen
	ld de, wOwnedCardsCountList
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
; 0x9eb8

; handles pressing left/right in card lists
; scrolls up/down a number of wCardListNumCursorPositions
; entries respectively
; returns carry if scrolling happened
HandleLeftRightInCardList: ; 9eb8 (2:5eb8)
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
	ld a, SFX_01
	call PlaySFX
	ld hl, wCardListUpdateFunction
	call CallIndirect
.asm_9efa
	scf
	ret
; 0x9efc

; handles scrolling up and down with Select button
; in this case, the cursor position goes up/down
; by wCardListNumCursorPositions entries respectively
; return carry if scrolling happened, otherwise no carry
HandleSelectUpAndDownInList: ; 9efc (2:5efc)
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
	ld a, SFX_01
	call PlaySFX
	ld hl, wCardListUpdateFunction
	call CallIndirect
.set_carry
	scf
	ret
; 0x9f40

; simply draws the deck info header
; then awaits a b button press to exit
ShowDeckInfoHeaderAndWaitForBButton: ; 9f40 (2:5f40)
	call ShowDeckInfoHeader
.wait_input
	call DoFrame
	ldh a, [hKeysPressed]
	and B_BUTTON
	jr z, .wait_input
	ld a, $ff
	call PlaySFXConfirmOrCancel
	ret
; 0x9f52

ShowConfirmationCardScreen: ; 9f52 (2:5f52)
	call ShowDeckInfoHeader
	lb de, 3, 5
	ld hl, wCardListCoords
	ld [hl], e
	inc hl
	ld [hl], d
	call PrintConfirmationCardList
	ret
; 0x9f62

; counts all values stored in wCardFilterCounts
; if the total count is 0, then
; prints "No cards chosen."
TallyCardsInCardFilterLists: ; 9f62 (2:5f62)
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
; 0x9f81

; draws a box on the top of the screen
; with wCurDeck's number, name and card count
; and draws the Hand Cards icon if it's
; the current dueling deck
ShowDeckInfoHeader: ; 9f81 (2:5f81)
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
; 0x9fc0

; prints the name of wCurDeck in the form
; "X· <deck name> deck", where X is the number
; of the deck in the given menu
; if no current deck, print blank line
PrintCurDeckNumberAndName: ; 9fc0 (2:5fc0)
	ld a, [wCurDeck]
	cp $ff
	jr z, .skip_deck_numeral

; print the deck number in the menu
; in the form "X·"
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
	ld [hl], "FW0_·"
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
; 0xa028

; sorts wCurDeckCards by ID
SortCurDeckCardsByID: ; a028 (2:6028)
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
; 0xa06e

; goes through list in wCurDeckCards, and for each card in it
; creates list in wUniqueDeckCardList of all unique cards
; it finds (assuming wCurDeckCards is sorted by ID)
; also counts the total number of the different cards
CreateCurDeckUniqueCardList: ; a06e (2:606e)
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
; 0xa08a

; prints the list of cards visible in the window
; of the confirmation screen
; card info is presented with name, level and
; its count preceded by "x"
PrintConfirmationCardList: ; a08a (2:608a)
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
; 0xa173

; returns in a the BG Pal corresponding to the
; card type icon in input register a
; if not found, returns $00
GetCardTypeIconPalette: ; a173 (2:6173)
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
; 0xa1a2

; inits WRAM vars to start creating deck configuration to send
PrepareToBuildDeckConfigurationToSend: ; a1a2 (2:61a2)
	ld hl, wCurDeckCards
	ld a, wCurDeckCardsEnd - wCurDeckCards
	call ClearNBytesFromHL
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
; 0xa1df

SendDeckConfigurationMenu_TransitionTable: ; a1df (2:61df)
	cursor_transition $10, $20, $00, $00, $00, $01, $02
	cursor_transition $48, $20, $00, $01, $01, $02, $00
	cursor_transition $80, $20, $00, $02, $02, $00, $01

SendDeckConfigurationMenuData: ; a1f4 (2:61f4)
	textitem  2, 2, ConfirmText
	textitem  9, 2, SendText
	textitem 16, 2, CancelText
	db $ff

HandleSendDeckConfigurationMenu: ; a201 (2:6201)
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
; 0xa281

; copies b bytes from hl to de
CopyNBytesFromHLToDE: ; a281 (2:6281)
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, CopyNBytesFromHLToDE
	ret
; 0xa288

; handles the screen showing all the player's cards
HandlePlayersCardsScreen: ; a288 (2:6288)
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
; 0xa396

Data_a396: ; a396 (2:6396)
	db 1 ; x pos
	db 5 ; y pos
	db 2 ; y spacing
	db 0 ; x spacing
	db 7 ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction
; 0xa39f

; a = which card type filter
PrintFilteredCardSelectionList: ; a39f (2:639f)
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
; 0xa3ca

; outputs in wTempCardCollection all the cards in sCardCollection
; plus the cards that are being used in built decks
; a = DECK_* flags for which decks to include in the collection
CreateCardCollectionListWithDeckCards: ; a3ca (2:63ca)
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
; 0xa412

; goes through cards in deck in de
; and for each card ID, increments its corresponding
; entry in wTempCardCollection
IncrementDeckCardsInTempCollection: ; a412 (2:6412)
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
; 0xa42d

; prints the name, level and storage count of the cards
; that are visible in the list window
; in the form:
; CARD NAME/LEVEL X
; where X is the current count of that card
PrintCardSelectionList: ; a42d (2:642d)
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
; 0xa4ae

; appends the card count given in register e
; to the list in hl, in numerical form
; (i.e. its numeric symbol representation)
AppendOwnedCardCountNumber: ; a4ae (2:64ae)
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
; 0xa4c6

; print header info (card count and player name)
PrintPlayersCardsHeaderInfo: ; a4c6 (2:64c6)
	call Set_OBJ_8x8
	call Func_8d78
.skip_empty_screen
	lb bc, 0, 4
	ld a, SYM_BOX_TOP
	call FillBGMapLineWithA
	call PrintTotalNumberOfCardsInCollection
	call PrintPlayersCardsText
	call DrawCardTypeIcons
	ret
; 0xa4de

; prints "<PLAYER>'s cards"
PrintPlayersCardsText: ; a4de (2:64de)
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
; 0xa504

PrintTotalNumberOfCardsInCollection: ; a504 (2:6504)
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
	ld de, wOnesAndTensPlace
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
; stores the result in wOnesAndTensPlace
.GetTotalCountDigits
	ld de, wOnesAndTensPlace
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
; 0xa596

; fills wFilteredCardList and wOwnedCardsCountList
; with cards IDs and counts, respectively,
; from given Card Set in register a
; a = CARD_SET_* constant
CreateCardSetList: ; a596 (2:6596)
	push af
	ld a, DECK_SIZE
	ld hl, wFilteredCardList
	call ClearNBytesFromHL
	ld a, DECK_SIZE
	ld hl, wOwnedCardsCountList
	call ClearNBytesFromHL
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
	cp VENUSAUR1
	jp z, .SetVenusaur1OwnedFlag
	cp MEW2
	jp z, .SetMew2OwnedFlag

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
	call .PlaceVenusaur1InList
.check_mew
	bit MEW_OWNED_PHANTOM_F, a
	jr z, .find_first_owned
	call .PlaceMew2InList

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

.SetMew2OwnedFlag
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

.SetVenusaur1OwnedFlag
	ld a, (1 << VENUSAUR_OWNED_PHANTOM_F)
	jr .SetPhantomOwnedFlag

.PlaceVenusaur1InList
	push af
	push hl
	ld e, VENUSAUR1
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

.PlaceMew2InList
	push af
	push hl
	ld e, MEW2
	jr .PlaceCardInList
; 0xa6a0

; a = CARD_SET_* constant
CreateCardSetListAndInitListCoords: ; a6a0 (2:66a0)
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
; 0xa6fa

; prints the cards being shown in the Card Album screen
; for the corresponding Card Set
PrintCardSetListEntries: ; a6fa (2:66fa)
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
	textfw0 "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"
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
	cp VENUSAUR1
	jr z, .phantom_card
	cp MEW2
	jr z, .phantom_card

	ld a, [wNumVisibleCardListEntries]
	sub b
	ld hl, wCardListVisibleOffset
	add [hl]
	inc a
	call CalculateOnesAndTensDigits
	ld hl, wOnesAndTensPlace
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
	ld hl, wOnesAndTensPlace
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
; phantom cards get only "✕✕" in their index number
	ld hl, wCurDeckName + 2
	ld [hl], "FW0_✕"
	inc hl
	ld [hl], "FW0_✕"
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
; 0xa828

; handles opening card page, and inputs when inside Card Album
HandleCardAlbumCardPage: ; a828 (2:6828)
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
	and A_BUTTON | B_BUTTON | SELECT | START
	jp nz, .exit
	xor a ; FALSE
	ld [wPlaysSfx], a
	ld a, [wCardListNumCursorPositions]
	ld c, a
	ld a, [wCardListCursorPos]
	bit D_UP_F, b
	jr z, .check_d_down

	push af
	ld a, TRUE
	ld [wPlaysSfx], a
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
	ld a, TRUE
	ld [wPlaysSfx], a
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
	ld a, [wPlaysSfx]
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
; 0xa901

GetFirstOwnedCardIndex: ; a901 (2:6901)
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
; 0xa913

HandleCardAlbumScreen: ; a913 (2:6913)
	ld a, $01
	ld [hffb4], a ; should be ldh

	xor a
.album_card_list
	ld hl, .MenuParameters
	call InitializeMenuParameters
	call .DrawCardAlbumScreen
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
	jp .album_card_list

.asm_a968
	call .GetNumCardEntries
	xor a
	ld hl, .CardSelectionParams
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
	ld hl, .CardSelectionParams
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
	jp .album_card_list

.MenuParameters
	db 3, 3 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

.CardSelectionParams
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
	bank1call SetDefaultPalettes
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

.DrawCardAlbumScreen
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	ld a, [hffb4]
	dec a
	jr nz, .skip_clear_screen
	ld [hffb4], a
	call Set_OBJ_8x8
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call LoadCursorTile
	call LoadSymbolsFont
	call LoadDuelCardSymbolTiles
	bank1call SetDefaultPalettes
	lb de, $3c, $ff
	call SetupText

.skip_clear_screen
	lb de, 0, 0
	lb bc, 20, 13
	call DrawRegularTextBox
	ld hl, .BoosterPacksMenuData
	call PlaceTextItems

	; set all Card Sets as available
	ld a, NUM_CARD_SETS
	ld hl, wUnavailableAlbumCardSets
	call ClearNBytesFromHL

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
; 0xab7b

PrinterMenu_PokemonCards: ; ab7b (2:6b7b)
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
	bank1call Func_758a
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
; 0xad0e

Data_ad05: ; ad05 (2:6d05)
	db 3 ; x pos
	db 3 ; y pos
	db 0 ; y spacing
	db 4 ; x spacing
	db 2 ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction
; 0xad0e

PrinterMenu_CardList: ; ad0e (2:6d0e)
	call WriteCardListsTerminatorBytes
	call Set_OBJ_8x8
	call Func_8d78
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
	ld hl, EnableLCD
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
; 0xad51

HandlePrinterMenu: ; ad51 (2:6d51)
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
	ld [wcfe4], a
	ld hl, PrinterMenuFunctionTable
	call JumpToFunctionInTable
	ld a, [wcfe4]
	jr .loop
; 0xad9a

PrinterMenu_QuitPrint: ; ad9a (2:6d9a)
	add sp, $2 ; exit menu
	ldtx hl, PleaseMakeSureToTurnGameBoyPrinterOffText
	call DrawWideTextBox_WaitForInput
	ret
; 0xada3

PrinterMenuFunctionTable: ; ada3 (2:6da3)
	dw PrinterMenu_PokemonCards
	dw PrinterMenu_DeckConfiguration
	dw PrinterMenu_CardList
	dw PrinterMenu_PrintQuality
	dw PrinterMenu_QuitPrint
; 0xadad

PrinterMenuParameters: ; adad (2:6dad)
	db 5, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0
; 0xadb5

PrinterMenu_PrintQuality: ; adb5 (2:6db5)
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
	ld a, [wcfe4]
	ld hl, PrinterMenuParameters
	call InitializeMenuParameters
	ldtx hl, WhatWouldYouLikeToPrintText
	call DrawWideTextBox_PrintText
	jr HandlePrinterMenu.loop_input
; 0xadf5

Data_adf5: ; adf5 (2:6df5)
	db 5  ; x pos
	db 16 ; y pos
	db 0  ; y spacing
	db 2  ; x spacing
	db 5  ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction
; 0xadfe

; handles printing and player input
; in the card confirmation list shown
; when cards are missing for some deck configuration
; hl = deck name
; de = deck cards
HandleDeckMissingCardsList: ; adfe (2:6dfe)
; read deck name from hl and cards from de
	push de
	ld de, wCurDeckName
	call CopyListFromHLToDEInSRAM
	pop de
	ld hl, wCurDeckCards
	call CopyDeckFromSRAM

	ld a, NUM_FILTERS
	ld hl, wCardFilterCounts
	call ClearNBytesFromHL
	ld a, DECK_SIZE
	ld [wTotalCardCount], a
	ld hl, wCardFilterCounts
	ld [hl], a
	call .HandleList ; can skip call and fallthrough instead
	ret

.HandleList
	call SortCurDeckCardsByID
	call CreateCurDeckUniqueCardList
	xor a
	ld [wCardListVisibleOffset], a
.loop
	ld hl, .DeckConfirmationCardSelectionParams
	call InitCardSelectionParams
	ld a, [wNumUniqueCards]
	ld [wNumCardListEntries], a
	cp $05
	jr c, .got_num_positions
	ld a, $05
.got_num_positions
	ld [wCardListNumCursorPositions], a
	ld [wNumVisibleCardListEntries], a
	call .PrintTitleAndList
	ld hl, wCardConfirmationText
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DrawWideTextBox_PrintText

; set card update function
	ld hl, .CardListUpdateFunction
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

.open_card_pge
	ld a, $01
	call PlaySFXConfirmOrCancel
	ld a, [wCardListCursorPos]
	ld [wced7], a

	; set wOwnedCardsCountList as current card list
	; and show card page screen
	ld de, wOwnedCardsCountList
	ld hl, wCurCardListPtr
	ld [hl], e
	inc hl
	ld [hl], d
	call OpenCardPageFromCardList
	jr .loop

.selection_made
	ld a, [hffb3]
	cp $ff
	ret z
	jr .open_card_pge

.DeckConfirmationCardSelectionParams
	db 0 ; x pos
	db 3 ; y pos
	db 2 ; y spacing
	db 0 ; x spacing
	db 5 ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

.CardListUpdateFunction
	ld hl, hffb0
	ld [hl], $01
	call .PrintDeckIndexAndName
	lb de, 1, 14
	call InitTextPrinting
	ld hl, wCardConfirmationText
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	ld hl, hffb0
	ld [hl], $00
	jp PrintConfirmationCardList

.PrintTitleAndList
	call .ClearScreenAndPrintDeckTitle
	lb de, 3, 3
	ld hl, wCardListCoords
	ld [hl], e
	inc hl
	ld [hl], d
	call PrintConfirmationCardList
	ret

.ClearScreenAndPrintDeckTitle
	call EmptyScreenAndLoadFontDuelAndHandCardsIcons
	call .PrintDeckIndexAndName
	call EnableLCD
	ret

; prints text in the form "X.<DECK NAME> deck"
; where X is the deck index in the list
.PrintDeckIndexAndName
	ld a, [wCurDeckName]
	or a
	ret z ; not a valid deck
	lb de, 0, 1
	call InitTextPrinting
	ld a, [wCurDeck]
	inc a
	ld hl, wDefaultText
	call ConvertToNumericalDigits
	ld [hl], "FW0_·"
	inc hl
	ld [hl], TX_END
	ld hl, wDefaultText
	call ProcessText

	ld hl, wCurDeckName
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
	lb de, 3, 1
	ld hl, wDefaultText
	call InitTextPrinting
	call ProcessText
	ret
; 0xaf1d

Func_af1d: ; af1d (2:6f1d)
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	call EmptyScreen
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont
	bank1call SetDefaultPalettes

	lb de, $3c, $bf
	call SetupText
	lb de, 3, 1
	call InitTextPrinting
	ldtx hl, ProceduresForSendingCardsText
	call ProcessTextFromID
	lb de, 1, 3
	call InitTextPrinting
	ldtx hl, CardSendingProceduresText
	ld a, $01
	ld [wLineSeparation], a
	call ProcessTextFromID
	xor a
	ld [wLineSeparation], a
	ldtx hl, PleaseReadTheProceduresForSendingCardsText
	call DrawWideTextBox_WaitForInput

	call EnableLCD
	call PrepareToBuildDeckConfigurationToSend
	jr c, .asm_af6b
	ld a, $01
	or a
	ret

.asm_af6b
	ld hl, wCurDeckCards
	ld de, wDuelTempList
	call CopyListFromHLToDE
	xor a
	ld [wNameBuffer], a
	bank1call SendCard
	ret c
	call EnableSRAM
	ld hl, wCurDeckCards
	call DecrementDeckCardsInCollection
	call DisableSRAM
	call SaveGame
	ld hl, wNameBuffer
	ld de, wDefaultText
	call CopyListFromHLToDE
	xor a
	ret

; never reached
	scf
	ret
; 0xaf98

Func_af98: ; af98 (2:6f98)
	xor a
	ld [wDuelTempList], a
	ld [wNameBuffer], a
	bank1call ReceiveCard
	ret c

	call EnableSRAM
	ld hl, wDuelTempList
	call AddGiftCenterDeckCardsToCollection
	call DisableSRAM
	call SaveGame
	xor a
	ld [wCardListVisibleOffset], a
	ld hl, Data_b04a
	call InitCardSelectionParams
	call PrintReceivedTheseCardsText
	call Func_b088
	call EnableLCD
	ld a, [wNumEntriesInCurFilter]
	ld [wNumCardListEntries], a
	ld hl, wNumVisibleCardListEntries
	cp [hl]
	jr nc, .asm_afd4
	ld [wCardListNumCursorPositions], a
.asm_afd4
	ld hl, ShowReceivedCardsList
	ld d, h
	ld a, l
	ld hl, wCardListUpdateFunction
	ld [hli], a
	ld [hl], d

	xor a
	ld [wced2], a
.asm_afe2
	call DoFrame
	call HandleDeckCardSelectionList
	jr c, .asm_b02f
	call HandleLeftRightInCardList
	jr c, .asm_afe2
	ldh a, [hDPadHeld]
	and START
	jr z, .asm_afe2
.asm_aff5
	ld a, $01
	call PlaySFXConfirmOrCancel
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
	call PrintReceivedTheseCardsText

	call PrintCardSelectionList
	call EnableLCD
	ld hl, Data_b04a
	call InitCardSelectionParams
	ld a, [wNumEntriesInCurFilter]
	ld hl, wNumVisibleCardListEntries
	cp [hl]
	jr nc, .asm_b027
	ld [wCardListNumCursorPositions], a
.asm_b027
	ld a, [wTempCardListCursorPos]
	ld [wCardListCursorPos], a
	jr .asm_afe2
.asm_b02f
	call DrawListCursor_Invisible
	ld a, [wCardListCursorPos]
	ld [wTempCardListCursorPos], a
	ld a, [hffb3]
	cp $ff
	jr nz, .asm_aff5
	ld hl, wNameBuffer
	ld de, wDefaultText
	call CopyListFromHLToDE
	or a
	ret

Data_b04a: ; b04a (2:704a)
	db 1 ; x pos
	db 3 ; y pos
	db 2 ; y spacing
	db 0 ; x spacing
	db 5 ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

ShowReceivedCardsList: ; b053 (2:7053)
	ld hl, hffb0
	ld [hl], $01
	lb de, 1, 1
	call InitTextPrinting
	ldtx hl, CardReceivedText
	call ProcessTextFromID
	ld hl, wNameBuffer
	ld de, wDefaultText
	call CopyListFromHLToDE
	xor a
	ld [wTxRam2 + 0], a
	ld [wTxRam2 + 1], a
	lb de, 1, 14
	call InitTextPrinting
	ldtx hl, ReceivedTheseCardsFromText
	call PrintTextNoDelay
	ld hl, hffb0
	ld [hl], $00
	jp PrintCardSelectionList
; 0xb088

Func_b088: ; b088 (2:7088)
	ld a, CARD_COLLECTION_SIZE - 1
	ld hl, wTempCardCollection
	call ClearNBytesFromHL
	ld de, wDuelTempList
	call .Func_b0b2
	ld a, $ff
	call .Func_b0c0
	ld a, $05
	ld [wNumVisibleCardListEntries], a
	lb de, 2, 3
	ld hl, wCardListCoords
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, SYM_BOX_RIGHT
	ld [wCursorAlternateTile], a
	call PrintCardSelectionList
	ret

.Func_b0b2
	ld bc, wTempCardCollection
.loop
	ld a, [de]
	inc de
	or a
	ret z
	ld h, $00
	ld l, a
	add hl, bc
	inc [hl]
	jr .loop

.Func_b0c0
	push af
	push bc
	push de
	push hl
	push af
	ld a, DECK_SIZE
	ld hl, wOwnedCardsCountList
	call ClearNBytesFromHL
	ld a, DECK_SIZE
	ld hl, wFilteredCardList
	call ClearNBytesFromHL
	pop af
	ld hl, $0
	ld de, $0
	ld b, a
.asm_b0dd
	inc e
	call GetCardType
	jr c, .asm_b119
	ld c, a
	ld a, b
	cp $ff
	jr z, .asm_b0fc
	and FILTER_ENERGY
	cp FILTER_ENERGY
	jr z, .asm_b0f5
	ld a, c
	cp b
	jr nz, .asm_b0dd
	jr .asm_b0fc
.asm_b0f5
	ld a, c
	and TYPE_ENERGY
	cp TYPE_ENERGY
	jr nz, .asm_b0dd
.asm_b0fc
	push bc
	push hl
	ld bc, wFilteredCardList
	add hl, bc
	ld [hl], e
	ld hl, wTempCardCollection
	add hl, de
	ld a, [hl]
	and $7f
	pop hl
	or a
	jr z, .asm_b116
	push hl
	ld bc, wOwnedCardsCountList
	add hl, bc
	ld [hl], a
	pop hl
	inc l
.asm_b116
	pop bc
	jr .asm_b0dd

.asm_b119
	ld a, l
	ld [wNumEntriesInCurFilter], a
	xor a
	ld c, l
	ld b, h
	ld hl, wFilteredCardList
	add hl, bc
	ld [hl], a
	ld a, $ff
	ld hl, wOwnedCardsCountList
	add hl, bc
	ld [hl], a
	pop hl
	pop de
	pop bc
	pop af
	ret
; 0xb131

PrintCardToSendText: ; b131 (2:7131)
	call EmptyScreenAndDrawTextBox
	lb de, 1, 1
	call InitTextPrinting
	ldtx hl, CardToSendText
	call ProcessTextFromID
	ret
; 0xb141

PrintReceivedTheseCardsText: ; b141 (2:7141)
	call EmptyScreenAndDrawTextBox
	lb de, 1, 1
	call InitTextPrinting
	ldtx hl, CardReceivedText
	call ProcessTextFromID
	ld hl, wNameBuffer
	ld de, wDefaultText
	call CopyListFromHLToDE
	xor a
	ld [wTxRam2 + 0], a
	ld [wTxRam2 + 1], a
	ldtx hl, ReceivedTheseCardsFromText
	call DrawWideTextBox_PrintText
	ret
; 0xb167

EmptyScreenAndDrawTextBox: ; b167 (2:7167)
	call Set_OBJ_8x8
	call Func_8d78
	lb de, 0, 0
	lb bc, 20, 13
	call DrawRegularTextBox
	ret
; 0xb177

Func_b177: ; b177 (2:7177)
	ld a, [wd10e]
	and $03
	ld hl, .FunctionTable
	call JumpToFunctionInTable
	jr c, .asm_b18f
	or a
	jr nz, .asm_b18f
	xor a
	ld [wTxRam2 + 0], a
	ld [wTxRam2 + 1], a
	ret
.asm_b18f
	ld a, $ff
	ld [wd10e], a
	ret

.FunctionTable
	dw Func_af1d
	dw Func_af98
	dw Func_bc04
	dw Func_bc7a
; 0xb19d

HandleDeckSaveMachineMenu: ; b19d (2:719d)
	xor a
	ld [wCardListVisibleOffset], a
	ldtx de, DeckSaveMachineText
	ld hl, wDeckMachineTitleText
	ld [hl], e
	inc hl
	ld [hl], d
	call ClearScreenAndDrawDeckMachineScreen
	ld a, NUM_DECK_SAVE_MACHINE_SLOTS
	ld [wNumDeckMachineEntries], a

	xor a
.wait_input
	ld hl, DeckMachineSelectionParams
	call InitCardSelectionParams
	call DrawListScrollArrows
	call PrintNumSavedDecks
	ldtx hl, PleaseSelectDeckText
	call DrawWideTextBox_PrintText
	ldtx de, PleaseSelectDeckText
	call InitDeckMachineDrawingParams
	call HandleDeckMachineSelection
	jr c, .wait_input
	cp $ff
	ret z ; operation cancelled
	; get the index of selected deck
	ld b, a
	ld a, [wCardListVisibleOffset]
	add b
	ld [wSelectedDeckMachineEntry], a

	call ResetCheckMenuCursorPositionAndBlink
	call DrawWideTextBox
	ld hl, .DeckMachineMenuData
	call PlaceTextItems
.wait_input_submenu
	call DoFrame
	call HandleCheckMenuInput
	jp nc, .wait_input_submenu
	cp $ff
	jr nz, .submenu_option_selected
	; return from submenu
	ld a, [wTempDeckMachineCursorPos]
	jp .wait_input

.submenu_option_selected
	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld hl, wCheckMenuCursorXPosition
	add [hl]
	or a
	jr nz, .ok_1

; Save a Deck
	call CheckIfSelectedDeckMachineEntryIsEmpty
	jr nc, .prompt_ok_if_deleted
	call SaveDeckInDeckSaveMachine
	ld a, [wTempDeckMachineCursorPos]
	jp c, .wait_input
	jr .return_to_list
.prompt_ok_if_deleted
	ldtx hl, OKIfFileDeletedText
	call YesOrNoMenuWithText
	ld a, [wTempDeckMachineCursorPos]
	jr c, .wait_input
	call SaveDeckInDeckSaveMachine
	ld a, [wTempDeckMachineCursorPos]
	jp c, .wait_input
	jr .return_to_list

.ok_1
	cp $1
	jr nz, .ok_2

; Delete a Deck
	call CheckIfSelectedDeckMachineEntryIsEmpty
	jr c, .is_empty
	call TryDeleteSavedDeck
	ld a, [wTempDeckMachineCursorPos]
	jp c, .wait_input
	jr .return_to_list

.is_empty
	ld hl, WaitForVBlank
	call DrawWideTextBox_WaitForInput
	ld a, [wTempDeckMachineCursorPos]
	jp .wait_input

.ok_2
	cp $2
	jr nz, .cancel

; Build a Deck
	call CheckIfSelectedDeckMachineEntryIsEmpty
	jr c, .is_empty
	call TryBuildDeckMachineDeck
	ld a, [wTempDeckMachineCursorPos]
	jp nc, .wait_input

.return_to_list
	ld a, [wTempCardListVisibleOffset]
	ld [wCardListVisibleOffset], a
	call ClearScreenAndDrawDeckMachineScreen
	call DrawListScrollArrows
	call PrintNumSavedDecks
	ld a, [wTempDeckMachineCursorPos]
	jp .wait_input

.cancel
	ret

.DeckMachineMenuData
	textitem  2, 14, SaveADeckText
	textitem 12, 14, DeleteADeckText
	textitem  2, 16, BuildADeckText
	textitem 12, 16, CancelText
	db $ff
; 0xb285

; sets the number of cursor positions for deck machine menu,
; sets the text ID to show given by de
; and sets DrawDeckMachineScreen as the update function
; de = text ID
InitDeckMachineDrawingParams: ; b285 (2:7285)
	ld a, NUM_DECK_MACHINE_SLOTS
	ld [wCardListNumCursorPositions], a
	ld hl, wDeckMachineText
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, DrawDeckMachineScreen
	ld d, h
	ld a, l
	ld hl, wCardListUpdateFunction
	ld [hli], a
	ld [hl], d
	xor a
	ld [wced2], a
	ret
; 0xb29f

; handles player input inside the Deck Machine screen
; the Start button opens up the deck confirmation menu
; and returns carry
; otherwise, returns no carry and selection made in a
HandleDeckMachineSelection: ; b29f (2:729f)
	call DoFrame
	call HandleDeckCardSelectionList
	jr c, .selection_made

	call .HandleListJumps
	jr c, HandleDeckMachineSelection ; jump back to start
	ldh a, [hDPadHeld]
	and START
	jr z, HandleDeckMachineSelection ; jump back to start

; start btn
	ld a, [wCardListVisibleOffset]
	ld [wTempCardListVisibleOffset], a
	ld b, a
	ld a, [wCardListCursorPos]
	ld [wTempDeckMachineCursorPos], a
	add b
	ld c, a
	inc a
	or $80
	ld [wCurDeck], a

	; get pointer to selected deck cards
	; and if it's an empty deck, jump to start
	sla c
	ld b, $0
	ld hl, wMachineDeckPtrs
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, DECK_NAME_SIZE
	add hl, bc
	ld d, h
	ld e, l
	call EnableSRAM
	ld a, [hl]
	call DisableSRAM
	pop hl
	or a
	jr z, HandleDeckMachineSelection ; jump back to start

; show deck confirmation screen with deck cards
; and return carry set
	ld a, $01
	call PlaySFXConfirmOrCancel
	call OpenDeckConfirmationMenu
	ld a, [wTempCardListVisibleOffset]
	ld [wCardListVisibleOffset], a
	call ClearScreenAndDrawDeckMachineScreen
	call DrawListScrollArrows
	call PrintNumSavedDecks
	ld a, [wTempDeckMachineCursorPos]
	ld [wCardListCursorPos], a
	scf
	ret

.selection_made
	call DrawListCursor_Visible
	ld a, [wCardListVisibleOffset]
	ld [wTempCardListVisibleOffset], a
	ld a, [wCardListCursorPos]
	ld [wTempDeckMachineCursorPos], a
	ld a, [hffb3]
	or a
	ret

; handles right and left input for jumping several entries at once
; returns carry if jump was made
.HandleListJumps
	ld a, [wCardListVisibleOffset]
	ld c, a
	ldh a, [hDPadHeld]
	cp D_RIGHT
	jr z, .d_right
	cp D_LEFT
	jr z, .d_left
	or a
	ret

.d_right
	ld a, [wCardListVisibleOffset]
	add NUM_DECK_MACHINE_SLOTS
	ld b, a
	add NUM_DECK_MACHINE_SLOTS
	ld hl, wNumDeckMachineEntries
	cp [hl]
	jr c, .got_new_pos
	ld a, [wNumDeckMachineEntries]
	sub NUM_DECK_MACHINE_SLOTS
	ld b, a
	jr .got_new_pos

.d_left
	ld a, [wCardListVisibleOffset]
	sub NUM_DECK_MACHINE_SLOTS
	ld b, a
	jr nc, .got_new_pos
	ld b, 0 ; first entry

.got_new_pos
	ld a, b
	ld [wCardListVisibleOffset], a
	cp c
	jr z, .set_carry
	; play SFX if jump was made
	; and update UI
	ld a, SFX_01
	call PlaySFX
	call DrawDeckMachineScreen
	call PrintNumSavedDecks
.set_carry
	scf
	ret
; 0xb35b

; returns carry if deck corresponding to the
; entry selected in the Deck Machine menu is empty
CheckIfSelectedDeckMachineEntryIsEmpty: ; b35b (2:735b)
	ld a, [wSelectedDeckMachineEntry]
	sla a
	ld l, a
	ld h, $0
	ld bc, wMachineDeckPtrs
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, DECK_NAME_SIZE
	add hl, bc
	call EnableSRAM
	ld a, [hl]
	call DisableSRAM
	or a
	ret nz ; is valid
	scf
	ret; is empty
; 0xb379

ClearScreenAndDrawDeckMachineScreen: ; b379 (2:7379)
	call Set_OBJ_8x8
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	call EmptyScreen
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont
	call LoadDuelCardSymbolTiles
	bank1call SetDefaultPalettes
	lb de, $3c, $ff
	call SetupText
	lb de, 0, 0
	lb bc, 20, 13
	call DrawRegularTextBox
	call SetDeckMachineTitleText
	call GetSavedDeckPointers
	call PrintVisibleDeckMachineEntries
	call GetSavedDeckCount
	call EnableLCD
	ret
; 0xb3b3

; prints wDeckMachineTitleText as title text
SetDeckMachineTitleText: ; b3b3 (2:73b3)
	lb de, 1, 0
	call InitTextPrinting
	ld hl, wDeckMachineTitleText
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	ret
; 0xb3c3

; save all sSavedDecks pointers in wMachineDeckPtrs
GetSavedDeckPointers: ; b3c3 (2:73c3)
	ld a, NUM_DECK_SAVE_MACHINE_SLOTS
	add NUM_DECK_SAVE_MACHINE_SLOTS ; add a is better
	ld hl, wMachineDeckPtrs
	call ClearNBytesFromHL
	ld de, wMachineDeckPtrs
	ld hl, sSavedDecks
	ld bc, DECK_STRUCT_SIZE
	ld a, NUM_DECK_SAVE_MACHINE_SLOTS
.loop_saved_decks
	push af
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	add hl, bc
	pop af
	dec a
	jr nz, .loop_saved_decks
	ret
; 0xb3e5

; given the cursor position in the deck machine menu
; prints the deck names of all entries that are visible
PrintVisibleDeckMachineEntries: ; b3e5 (2:73e5)
	ld a, [wCardListVisibleOffset]
	lb de, 2, 2
	ld b, NUM_DECK_MACHINE_VISIBLE_DECKS
.loop
	push af
	push bc
	push de
	call PrintDeckMachineEntry
	pop de
	pop bc
	pop af
	ret c ; jump never made?
	dec b
	ret z ; no more entries
	inc a
	inc e
	inc e
	jr .loop
; 0xb3fe

UpdateDeckMachineScrollArrowsAndEntries: ; b3fe (2:73fe)
	call DrawListScrollArrows
	jr PrintVisibleDeckMachineEntries
; 0xb403

DrawDeckMachineScreen: ; b403 (2:7403)
	call DrawListScrollArrows
	ld hl, hffb0
	ld [hl], $01
	call SetDeckMachineTitleText
	lb de, 1, 14
	call InitTextPrinting
	ld hl, wDeckMachineText
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	ld hl, hffb0
	ld [hl], $00
	jr PrintVisibleDeckMachineEntries
; 0xb424

; prints the deck name of the deck corresponding
; to index in register a, from wMachineDeckPtrs
; also checks whether the deck can be built
; either by dismantling other decks or not,
; and places the corresponding symbol next to the name 
PrintDeckMachineEntry: ; b424 (2:7424)
	ld b, a
	push bc
	ld hl, wDefaultText
	inc a
	call ConvertToNumericalDigits
	ld [hl], "FW0_·"
	inc hl
	ld [hl], TX_END
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	pop af

; get the deck corresponding to input index
; and append its name to wDefaultText
	push af
	sla a
	ld l, a
	ld h, $0
	ld bc, wMachineDeckPtrs
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc d
	inc d
	inc d
	push de
	call AppendDeckName
	pop de
	pop bc
	jr nc, .valid_deck

; invalid deck, give it the default
; empty deck name ("--------------")
	call InitTextPrinting
	ldtx hl, EmptyDeckNameText
	call ProcessTextFromID
	ld d, 13
	inc e
	call InitTextPrinting
	ld hl, .text
	call ProcessText
	scf
	ret

.valid_deck
	push de
	push bc
	ld d, 18
	call InitTextPrinting

; print the symbol that symbolizes whether the deck can
; be built, or if another deck has to be dismantled to build it
	ld a, $0 ; no decks dismantled
	call CheckIfCanBuildSavedDeck
	pop bc
	ld hl, wDefaultText
	jr c, .cannot_build
	lb de, 3, "FW3_○" ; can build
	jr .asm_b4c2
.cannot_build
	push bc
	ld a, ALL_DECKS
	call CheckIfCanBuildSavedDeck
	jr c, .cannot_build_at_all
	pop bc
	lb de, 3, "FW3_❄" ; can build by dismantling
	jr .asm_b4c2

.cannot_build_at_all
	lb de, 0, "FW0_✕" ; cannot build even by dismantling
	call Func_22ca
	pop bc
	pop de

; place in wDefaultText the number of cards
; that are needed in order to build the deck
	push bc
	ld d, 17
	inc e
	call InitTextPrinting
	pop bc
	call .GetNumCardsMissingToBuildDeck
	call CalculateOnesAndTensDigits
	ld hl, wOnesAndTensPlace
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld hl, wDefaultText
	ld [hl], TX_SYMBOL
	inc hl
	ld [hli], a
	ld [hl], TX_SYMBOL
	inc hl
	ld a, b
	ld [hli], a
	ld [hl], TX_END
	ld hl, wDefaultText
	call ProcessText
	or a
	ret

.asm_b4c2
	call Func_22ca
	pop de
	ld d, 13
	inc e
	call InitTextPrinting
	ld hl, .text
	call ProcessText
	or a
	ret

.text
	db TX_SYMBOL, TX_END
	db TX_SYMBOL, TX_END
	db TX_SYMBOL, TX_END
	db TX_SYMBOL, TX_END
	db TX_SYMBOL, TX_END
	db TX_SYMBOL, TX_END
	done

; outputs in a the number of cards that the player does not own
; in order to build the deck entry from wMachineDeckPtrs
; given in register b
.GetNumCardsMissingToBuildDeck
	push bc
	call SafelySwitchToSRAM0
	call CreateCardCollectionListWithDeckCards
	call SafelySwitchToTempSRAMBank
	pop bc

; get address to cards for the corresponding deck entry
	sla b
	ld c, b
	ld b, $00
	ld hl, wMachineDeckPtrs
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, DECK_NAME_SIZE
	add hl, bc

	call EnableSRAM
	ld de, wTempCardCollection
	lb bc, 0, 0
.loop
	inc b
	ld a, DECK_SIZE
	cp b
	jr c, .done
	ld a, [hli]
	push hl
	ld l, a
	ld h, $00
	add hl, de
	ld a, [hl]
	and CARD_COUNT_MASK
	or a
	jr z, .none
	dec a
	ld [hl], a
	pop hl
	jr .loop
.none
	inc c
	pop hl
	jr .loop
.done
	ld a, c
	call DisableSRAM
	ret
; 0xb525

; counts how many decks in sSavedDecks are not empty
; stores value in wNumSavedDecks
GetSavedDeckCount: ; b525 (2:7525)
	call EnableSRAM
	ld hl, sSavedDecks
	ld bc, DECK_STRUCT_SIZE
	ld d, NUM_DECK_SAVE_MACHINE_SLOTS
	ld e, 0
.loop
	ld a, [hl]
	or a
	jr z, .empty_slot
	inc e
.empty_slot
	dec d
	jr z, .got_count
	add hl, bc
	jr .loop
.got_count
	ld a, e
	ld [wNumSavedDecks], a
	call DisableSRAM
	ret
; 0xb545

; prints "[wNumSavedDecks]/60"
PrintNumSavedDecks: ; b545 (2:7545)
	ld a, [wNumSavedDecks]
	ld hl, wDefaultText
	call ConvertToNumericalDigits
	ld a, TX_SYMBOL
	ld [hli], a
	ld a, SYM_SLASH
	ld [hli], a
	ld a, NUM_DECK_SAVE_MACHINE_SLOTS
	call ConvertToNumericalDigits
	ld [hl], TX_END
	lb de, 14, 1
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ret
; 0xb568

; prints "X/Y" where X is the current list index
; and Y is the total number of saved decks
; unreferenced?
Func_b568: ; b568 (2:7568)
	ld a, [wCardListCursorPos]
	ld b, a
	ld a, [wCardListVisibleOffset]
	add b
	inc a
	ld hl, wDefaultText
	call ConvertToNumericalDigits
	ld a, TX_SYMBOL
	ld [hli], a
	ld a, SYM_SLASH
	ld [hli], a
	ld a, [wNumSavedDecks]
	call ConvertToNumericalDigits
	ld [hl], TX_END
	lb de, 14, 1
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ret
; 0xb592

; handles player choice in what deck to save
; in the Deck Save Machine
; assumes the slot to save was selected and
; is stored in wSelectedDeckMachineEntry
; if operation was successful, return carry
SaveDeckInDeckSaveMachine: ; b592 (2:7592)
	ld a, ALL_DECKS
	call DrawDecksScreen
	xor a
.wait_input
	ld hl, DeckMachineMenuParameters
	call InitializeMenuParameters
	ldtx hl, ChooseADeckToSaveText
	call DrawWideTextBox_PrintText
.wait_submenu_input
	call DoFrame
	call HandleStartButtonInDeckSelectionMenu
	jr c, .wait_input
	call HandleMenuInput
	jp nc, .wait_submenu_input ; can be jr
	ldh a, [hCurMenuItem]
	cp $ff
	ret z ; operation cancelled
	ld [wCurDeck], a
	call CheckIfCurDeckIsValid
	jp nc, .SaveDeckInSelectedEntry ; can be jr
	; is an empty deck
	call PrintThereIsNoDeckHereText
	ld a, [wCurDeck]
	jr .wait_input

; overwrites data in the selected deck in SRAM
; with the deck that was chosen, in wCurDeck
; then returns carry
.SaveDeckInSelectedEntry
	call GetPointerToDeckName
	call GetSelectedSavedDeckPtr
	ld b, DECK_STRUCT_SIZE
	call EnableSRAM
	call CopyNBytesFromHLToDE
	call DisableSRAM

	call ClearScreenAndDrawDeckMachineScreen
	call DrawListScrollArrows
	call PrintNumSavedDecks
	ld a, [wTempDeckMachineCursorPos]
	ld hl, DeckMachineSelectionParams
	call InitCardSelectionParams
	call DrawListCursor_Visible
	call GetPointerToDeckName
	call EnableSRAM
	call CopyDeckName
	call DisableSRAM
	xor a
	ld [wTxRam2 + 0], a
	ld [wTxRam2 + 1], a
	ldtx hl, SavedTheConfigurationForText
	call DrawWideTextBox_WaitForInput
	scf
	ret
; 0xb609

DeckMachineMenuParameters: ; b609 (2:7609)
	db 1, 2 ; cursor x, cursor y
	db 3 ; y displacement between items
	db 4 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0
; 0xb611

; outputs in de pointer of saved deck
; corresponding to index in wSelectedDeckMachineEntry
GetSelectedSavedDeckPtr: ; b611 (2:7611)
	push af
	push hl
	ld a, [wSelectedDeckMachineEntry]
	sla a
	ld e, a
	ld d, $00
	ld hl, wMachineDeckPtrs
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	pop af
	ret
; 0xb625

; checks if it's possible to build saved deck with index b
; includes cards from already built decks from flags in a
; returns carry if cannot build the deck with the given criteria
; a = DECK_* flags for which decks to include in the collection
; b = saved deck index
CheckIfCanBuildSavedDeck: ; b625 (2:7625)
	push bc
	call SafelySwitchToSRAM0
	call CreateCardCollectionListWithDeckCards
	call SafelySwitchToTempSRAMBank
	pop bc
	sla b
	ld c, b
	ld b, $0
	ld hl, wMachineDeckPtrs
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, DECK_NAME_SIZE
	add hl, bc
	call CheckIfHasEnoughCardsToBuildDeck
	ret
; 0xb644

; switches to SRAM bank 0 and stores current SRAM bank in wTempBankSRAM
; skips if current SRAM bank is already 0
SafelySwitchToSRAM0: ; b644 (2:7644)
	push af
	ldh a, [hBankSRAM]
	or a
	jr z, .skip
	ld [wTempBankSRAM], a
	xor a
	call BankswitchSRAM
.skip
	pop af
	ret
; 0xb653

; switches to SRAM bank 1 and stores current SRAM bank in wTempBankSRAM
; skips if current SRAM bank is already 1
SafelySwitchToSRAM1: ; b653 (2:7653)
	push af
	ldh a, [hBankSRAM]
	cp BANK("SRAM1")
	jr z, .skip
	ld [wTempBankSRAM], a
	ld a, BANK("SRAM1")
	call BankswitchSRAM
.skip
	pop af
	ret
; 0xb664

SafelySwitchToTempSRAMBank: ; b664 (2:7664)
	push af
	push bc
	ldh a, [hBankSRAM]
	ld b, a
	ld a, [wTempBankSRAM]
	cp b
	jr z, .skip
	call BankswitchSRAM
.skip
	pop bc
	pop af
	ret
; 0xb675

; returns carry if wTempCardCollection does not
; have enough cards to build deck pointed by hl
; hl = pointer to cards of deck to check
CheckIfHasEnoughCardsToBuildDeck: ; b675 (2:7675)
	call EnableSRAM
	ld de, wTempCardCollection
	ld b, 0
.loop
	inc b
	ld a, DECK_SIZE
	cp b
	jr c, .no_carry
	ld a, [hli]
	push hl
	ld l, a
	ld h, $00
	add hl, de
	ld a, [hl]
	or a
	jr z, .set_carry
	cp CARD_NOT_OWNED
	jr z, .set_carry
	dec a
	ld [hl], a
	pop hl
	jr .loop

.set_carry
	pop hl
	call DisableSRAM
	scf
	ret

.no_carry
	call DisableSRAM
	or a
	ret
; 0xb6a1

; outputs in a the first slot that is empty to build a deck
; if no empty slot is found, return carry
FindFirstEmptyDeckSlot: ; b6a1 (2:76a1)
	ld hl, sDeck1Cards
	ld a, [hl]
	or a
	jr nz, .check_deck_2
	xor a
	ret

.check_deck_2
	ld hl, sDeck2Cards
	ld a, [hl]
	or a
	jr nz, .check_deck_3
	ld a, 1
	ret

.check_deck_3
	ld hl, sDeck3Cards
	ld a, [hl]
	or a
	jr nz, .check_deck_4
	ld a, 2
	ret

.check_deck_4
	ld hl, sDeck4Cards
	ld a, [hl]
	or a
	jr nz, .set_carry
	ld a, 3
	ret

.set_carry
	scf
	ret
; 0xb6ca

; prompts the player whether to delete selected saved deck
; if player selects yes, clears memory in SRAM
; corresponding to that saved deck slot
; if player selects no, return carry
TryDeleteSavedDeck: ; b6ca (2:76ca)
	ldtx hl, DoYouReallyWishToDeleteText
	call YesOrNoMenuWithText
	jr c, .no
	call GetSelectedSavedDeckPtr
	ld l, e
	ld h, d
	push hl
	call EnableSRAM
	call CopyDeckName
	pop hl
	ld a, DECK_STRUCT_SIZE
	call ClearNBytesFromHL
	call DisableSRAM
	xor a
	ld [wTxRam2 + 0], a
	ld [wTxRam2 + 1], a
	ldtx hl, DeletedTheConfigurationForText
	call DrawWideTextBox_WaitForInput
	or a
	ret

.no
	ld a, [wCardListCursorPos]
	scf
	ret
; 0xb6fb

DeckMachineSelectionParams: ; b6fb (2:76fb)
	db 1 ; x pos
	db 2 ; y pos
	db 2 ; y spacing
	db 0 ; x spacing
	db 5 ; num entries
	db SYM_CURSOR_R ; visible cursor tile
	db SYM_SPACE ; invisible cursor tile
	dw NULL ; wCardListHandlerFunction

DrawListScrollArrows: ; b704 (2:7704)
	ld a, [wCardListVisibleOffset]
	or a
	jr z, .no_up_cursor
	ld a, SYM_CURSOR_U
	jr .got_tile_1
.no_up_cursor
	ld a, SYM_BOX_RIGHT
.got_tile_1
	lb bc, 19, 1
	call WriteByteToBGMap0

	ld a, [wCardListVisibleOffset]
	add NUM_DECK_MACHINE_VISIBLE_DECKS + 1
	ld b, a
	ld a, [wNumDeckMachineEntries]
	cp b
	jr c, .no_down_cursor
	xor a ; FALSE
	ld [wUnableToScrollDown], a
	ld a, SYM_CURSOR_D
	jr .got_tile_2
.no_down_cursor
	ld a, TRUE
	ld [wUnableToScrollDown], a
	ld a, SYM_BOX_RIGHT
.got_tile_2
	lb bc, 19, 11
	call WriteByteToBGMap0
	ret
; 0xb738

; handles the deck menu for when the player
; needs to make space for new deck to build
HandleDismantleDeckToMakeSpace: ; b738 (2:7738)
	ldtx hl, YouMayOnlyCarry4DecksText
	call DrawWideTextBox_WaitForInput
	call SafelySwitchToSRAM0
	ld a, ALL_DECKS
	call DrawDecksScreen
	xor a
.init_menu_params
	ld hl, DeckMachineMenuParameters
	call InitializeMenuParameters
	ldtx hl, ChooseADeckToDismantleText
	call DrawWideTextBox_PrintText
.loop_input
	call DoFrame
	call HandleStartButtonInDeckSelectionMenu
	jr c, .init_menu_params
	call HandleMenuInput
	jp nc, .loop_input ; can be jr
	ldh a, [hCurMenuItem]
	cp $ff
	jr nz, .selected_deck
	; operation was cancelled
	call SafelySwitchToTempSRAMBank
	scf
	ret

.selected_deck
	ld [wCurDeck], a
	ldtx hl, DismantleThisDeckText
	call YesOrNoMenuWithText
	jr nc, .dismantle
	ld a, [wCurDeck]
	jr .init_menu_params

.dismantle
	call GetPointerToDeckName
	push hl
	ld de, wDismantledDeckName
	call EnableSRAM
	call CopyListFromHLToDE
	pop hl
	push hl
	ld bc, DECK_NAME_SIZE
	add hl, bc
	call AddDeckToCollection
	pop hl
	ld a, DECK_STRUCT_SIZE
	call ClearNBytesFromHL
	call DisableSRAM

	; redraw deck screen
	ld a, ALL_DECKS
	call DrawDecksScreen
	ld a, [wCurDeck]
	ld hl, DeckMachineMenuParameters
	call InitializeMenuParameters
	call DrawCursor2
	call SafelySwitchToTempSRAMBank
	ld hl, wDismantledDeckName
	call CopyDeckName
	xor a
	ld [wTxRam2 + 0], a
	ld [wTxRam2 + 1], a
	ldtx hl, DismantledDeckText
	call DrawWideTextBox_WaitForInput
	ld a, [wCurDeck]
	ret
; 0xb7c6

; tries to build the deck in wSelectedDeckMachineEntry
; will check if can be built with or without dismantling
; prompts the player in case a deck has to be dismantled
; or, if it's impossible to build deck, shows missing cards list
TryBuildDeckMachineDeck: ; b7c6 (2:77c6)
	ld a, [wSelectedDeckMachineEntry]
	ld b, a
	push bc
	ld a, $0
	call CheckIfCanBuildSavedDeck
	pop bc
	jr nc, .build_deck
	ld a, ALL_DECKS
	call CheckIfCanBuildSavedDeck
	jr c, .do_not_own_all_cards_needed
	; can only be built by dismantling some deck
	ldtx hl, ThisDeckCanOnlyBeBuiltIfYouDismantleText
	call DrawWideTextBox_WaitForInput
	call .DismantleDecksNeededToBuild
	jr nc, .build_deck
	; player chose not to dismantle

.set_carry_and_return
	ld a, [wCardListCursorPos]
	scf
	ret

.do_not_own_all_cards_needed
	ldtx hl, YouDoNotOwnAllCardsNeededToBuildThisDeckText
	call DrawWideTextBox_WaitForInput
	jp .ShowMissingCardList

.build_deck
	call EnableSRAM
	call SafelySwitchToSRAM0
	call FindFirstEmptyDeckSlot
	call SafelySwitchToTempSRAMBank
	call DisableSRAM
	jr nc, .got_deck_slot
	call HandleDismantleDeckToMakeSpace
	jr nc, .got_deck_slot
	scf
	ret

.got_deck_slot
	ld [wDeckSlotForNewDeck], a
	ld a, [wSelectedDeckMachineEntry]
	ld c, a
	ld b, $0
	sla c
	ld hl, wMachineDeckPtrs
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; copy deck to buffer
	ld de, wDeckToBuild
	ld b, DECK_STRUCT_SIZE
	call EnableSRAM
	call CopyNBytesFromHLToDE

	; remove the needed cards from collection
	ld hl, wDeckToBuild + DECK_NAME_SIZE
	call SafelySwitchToSRAM0
	call DecrementDeckCardsInCollection

	; copy the deck cards from the buffer
	; to the deck slot that was chosen
	ld a, [wDeckSlotForNewDeck]
	ld l, a
	ld h, DECK_STRUCT_SIZE
	call HtimesL
	ld bc, sBuiltDecks
	add hl, bc
	ld d, h
	ld e, l
	ld hl, wDeckToBuild
	ld b, DECK_STRUCT_SIZE
	call CopyNBytesFromHLToDE
	call DisableSRAM

	; draw Decks screen
	ld a, ALL_DECKS
	call DrawDecksScreen
	ld a, [wDeckSlotForNewDeck]
	ld [wCurDeck], a
	ld hl, DeckMachineMenuParameters
	call InitializeMenuParameters
	call DrawCursor2
	call GetPointerToDeckName
	call EnableSRAM
	call CopyDeckName
	call DisableSRAM
	call SafelySwitchToTempSRAMBank
	xor a
	ld [wTxRam2 + 0], a
	ld [wTxRam2 + 1], a
	ldtx hl, BuiltDeckText
	call DrawWideTextBox_WaitForInput
	scf
	ret

; asks the player for confirmation to dismantle decks
; needed to build the selected deck from the Deck Save Machine
; returns carry set if player selected "no"
; if player selected "yes", dismantle decks
.DismantleDecksNeededToBuild
; shows Decks screen with the names
; of the decks to be dismantled
	farcall CheckWhichDecksToDismantleToBuildSavedDeck
	call SafelySwitchToSRAM0
	call DrawDecksScreen
	ldtx hl, DismantleTheseDecksText
	call YesOrNoMenuWithText
	jr nc, .yes
; no
	call SafelySwitchToTempSRAMBank
	scf
	ret

.yes
	call EnableSRAM
	ld a, [wDecksToBeDismantled]
	bit DECK_1_F, a
	jr z, .deck_2
	ld a, DECK_1_F
	call .DismantleDeck
.deck_2
	ld a, [wDecksToBeDismantled]
	bit DECK_2_F, a
	jr z, .deck_3
	ld a, DECK_2_F
	call .DismantleDeck
.deck_3
	ld a, [wDecksToBeDismantled]
	bit DECK_3_F, a
	jr z, .deck_4
	ld a, DECK_3_F
	call .DismantleDeck
.deck_4
	ld a, [wDecksToBeDismantled]
	bit DECK_4_F, a
	jr z, .done_dismantling
	ld a, DECK_4_F
	call .DismantleDeck

.done_dismantling
	call DisableSRAM
	ld a, [wDecksToBeDismantled]
	call DrawDecksScreen
	call SafelySwitchToTempSRAMBank
	ldtx hl, DismantledTheDeckText
	call DrawWideTextBox_WaitForInput
	or a
	ret

; dismantles built deck given by a
; and adds its cards to the collection
; a = DECK_*_F to dismantle
.DismantleDeck
	ld l, a
	ld h, DECK_STRUCT_SIZE
	call HtimesL
	ld bc, sBuiltDecks
	add hl, bc
	push hl
	ld bc, DECK_NAME_SIZE
	add hl, bc
	call AddDeckToCollection
	pop hl
	ld a, DECK_STRUCT_SIZE
	call ClearNBytesFromHL
	ret

; collects cards missing from player's collection
; and shows its confirmation list
.ShowMissingCardList
; copy saved deck card from SRAM to wCurDeckCards
; and make unique card list sorted by ID
	ld a, [wSelectedDeckMachineEntry]
	ld [wCurDeck], a
	call GetSelectedSavedDeckPtr
	ld hl, DECK_NAME_SIZE
	add hl, de
	ld de, wCurDeckCards
	ld b, DECK_SIZE
	call EnableSRAM
	call CopyNBytesFromHLToDE
	call DisableSRAM
	xor a ; terminator byte for deck
	ld [wCurDeckCards + DECK_SIZE], a
	call SortCurDeckCardsByID
	call CreateCurDeckUniqueCardList

; create collection card list, including
; the cards from all built decks
	ld a, ALL_DECKS
	call SafelySwitchToSRAM0
	call CreateCardCollectionListWithDeckCards
	call SafelySwitchToTempSRAMBank

; creates list in wFilteredCardList with
; cards that are missing to build this deck
	ld hl, wUniqueDeckCardList
	ld de, wFilteredCardList
.loop_deck_configuration
	ld a, [hli]
	or a
	jr z, .finish_missing_card_list
	ld b, a
	push bc
	push de
	push hl
	ld hl, wCurDeckCards
	call .CheckIfCardIsMissing
	pop hl
	pop de
	pop bc
	jr nc, .loop_deck_configuration
	; this card is missing
	; store in wFilteredCardList this card ID
	; a number of times equal to the amount still needed
	ld c, a
	ld a, b
.loop_number_missing
	ld [de], a
	inc de
	dec c
	jr nz, .loop_number_missing
	jr .loop_deck_configuration

.finish_missing_card_list
	xor a ; terminator byte
	ld [de], a

	ldtx bc, TheseCardsAreNeededToBuildThisDeckText
	ld hl, wCardConfirmationText
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a

	call GetSelectedSavedDeckPtr
	ld h, d
	ld l, e
	ld de, wFilteredCardList
	call HandleDeckMissingCardsList
	jp .set_carry_and_return

; checks if player has enough cards with ID given in register a
; in the collection to build the deck and, if not, returns
; carry set and outputs in a the difference
; a = card ID
; hl = deck cards
.CheckIfCardIsMissing
	call .GetCardCountFromDeck
	ld hl, wTempCardCollection
	push de
	call .GetCardCountFromCollection
	ld a, e
	pop de

	; d = card count in deck
	; a = card count in collection
	cp d
	jr c, .not_enough
	or a
	ret

.not_enough
; needs more cards than player owns in collection
; return carry set and the number of cards needed
	ld e, a
	ld a, d
	sub e
	scf
	ret z

; returns in d the card count of card ID given in register a
; that is found in the card list in hl
; a = card ID
; hl = deck cards
.GetCardCountFromDeck
	push af
	ld e, a
	ld d, 0
.loop_deck_cards
	ld a, [hli]
	or a
	jr z, .done_deck_cards
	cp e
	jr nz, .loop_deck_cards
	inc d
	jr .loop_deck_cards
.done_deck_cards
	pop af
	ret

; returns in e the card count of card ID given in register a
; that is found in the card collection
; a = card ID
; hl = card collection
.GetCardCountFromCollection
	push af
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hl]
	and CARD_COUNT_MASK
	ld e, a
	pop af
	ret
; 0xb991

PrinterMenu_DeckConfiguration: ; b991 (2:7991)
	xor a
	ld [wCardListVisibleOffset], a
	call ClearScreenAndDrawDeckMachineScreen
	ld a, DECK_SIZE
	ld [wNumDeckMachineEntries], a

	xor a
.asm_b99e
	ld hl, DeckMachineSelectionParams
	call InitCardSelectionParams
	call DrawListScrollArrows
	call PrintNumSavedDecks
	ldtx hl, PleaseChooseDeckConfigurationToPrintText
	call DrawWideTextBox_PrintText
	ldtx de, PleaseChooseDeckConfigurationToPrintText
	call InitDeckMachineDrawingParams
.asm_b9b6
	call HandleDeckMachineSelection
	jr c, .asm_b99e
	cp $ff
	ret z

	ld b, a
	ld a, [wCardListVisibleOffset]
	add b
	ld [wSelectedDeckMachineEntry], a
	call CheckIfSelectedDeckMachineEntryIsEmpty
	jr c, .asm_b9b6
	call DrawWideTextBox
	ldtx hl, PrintThisDeckText
	call YesOrNoMenuWithText
	jr c, .no
	call GetSelectedSavedDeckPtr
	ld hl, $18
	add hl, de
	ld de, wCurDeckCards
	ld b, DECK_SIZE
	call EnableSRAM
	call CopyNBytesFromHLToDE
	call DisableSRAM
	xor a ; terminator byte for deck
	ld [wCurDeckCards + DECK_SIZE], a
	call SortCurDeckCardsByID
	ld a, [wSelectedDeckMachineEntry]
	bank1call PrintDeckConfiguration
	call ClearScreenAndDrawDeckMachineScreen

.no
	ld a, [wTempDeckMachineCursorPos]
	ld [wCardListCursorPos], a
	jp .asm_b99e
; 0xba04

HandleAutoDeckMenu: ; ba04 (2:7a04)
	ld a, [wCurAutoDeckMachine]
	ld hl, .DeckMachineTitleTextList
	sla a
	ld c, a
	ld b, $0
	add hl, bc
	ld de, wDeckMachineTitleText
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	xor a
	ld [wCardListVisibleOffset], a
	call .InitAutoDeckMenu
	ld a, NUM_DECK_MACHINE_SLOTS
	ld [wNumDeckMachineEntries], a
	xor a

.please_select_deck
	ld hl, .MenuParameters
	call InitializeMenuParameters
	ldtx hl, PleaseSelectDeckText
	call DrawWideTextBox_PrintText
	ld a, NUM_DECK_MACHINE_SLOTS
	ld [wCardListNumCursorPositions], a
	ld hl, UpdateDeckMachineScrollArrowsAndEntries
	ld d, h
	ld a, l
	ld hl, wCardListUpdateFunction
	ld [hli], a
	ld [hl], d
.wait_input
	call DoFrame
	call HandleMenuInput
	jr c, .deck_selection_made

; the following lines do nothing
	ldh a, [hDPadHeld]
	and D_UP | D_DOWN
	jr z, .asm_ba4e
.asm_ba4e

; check whether to show deck confirmation list
	ldh a, [hDPadHeld]
	and START
	jr z, .wait_input

	ld a, [wCardListVisibleOffset]
	ld [wTempCardListVisibleOffset], a
	ld b, a
	ld a, [wCurMenuItem]
	ld [wTempDeckMachineCursorPos], a
	add b
	ld c, a
	inc a
	or $80
	ld [wCurDeck], a
	sla c
	ld b, $0
	ld hl, wMachineDeckPtrs
	add hl, bc
	call SafelySwitchToSRAM1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, DECK_NAME_SIZE
	add hl, bc
	ld d, h
	ld e, l
	ld a, [hl]
	pop hl
	call SafelySwitchToSRAM0
	or a
	jr z, .wait_input ; invalid deck

	; show confirmation list
	ld a, $1
	call PlaySFXConfirmOrCancel
	call SafelySwitchToSRAM1
	call OpenDeckConfirmationMenu
	call SafelySwitchToSRAM0
	ld a, [wTempCardListVisibleOffset]
	ld [wCardListVisibleOffset], a
	call .InitAutoDeckMenu
	ld a, [wTempDeckMachineCursorPos]
	jp .please_select_deck

.deck_selection_made
	call DrawCursor2
	ld a, [wCardListVisibleOffset]
	ld [wTempCardListVisibleOffset], a
	ld a, [wCurMenuItem]
	ld [wTempDeckMachineCursorPos], a
	ldh a, [hCurMenuItem]
	cp $ff
	jp z, .exit ; operation cancelled
	ld [wSelectedDeckMachineEntry], a
	call ResetCheckMenuCursorPositionAndBlink
	xor a
	ld [wce5e], a
	call DrawWideTextBox
	ld hl, .DeckMachineMenuData
	call PlaceTextItems
.wait_submenu_input
	call DoFrame
	call HandleCheckMenuInput_YourOrOppPlayArea
	jp nc, .wait_submenu_input
	cp $ff
	jr nz, .submenu_option_selected
	ld a, [wTempDeckMachineCursorPos]
	jp .please_select_deck

.submenu_option_selected
	ld a, [wCheckMenuCursorYPosition]
	sla a
	ld hl, wCheckMenuCursorXPosition
	add [hl]
	or a
	jr nz, .asm_bb09

; Build a Deck
	call SafelySwitchToSRAM1
	call TryBuildDeckMachineDeck
	call SafelySwitchToSRAM0
	ld a, [wTempDeckMachineCursorPos]
	jp nc, .please_select_deck
	ld a, [wTempCardListVisibleOffset]
	ld [wCardListVisibleOffset], a
	call .InitAutoDeckMenu
	ld a, [wTempDeckMachineCursorPos]
	jp .please_select_deck

.asm_bb09
	cp $1
	jr nz, .read_the_instructions
.exit
	xor a
	ld [wTempBankSRAM], a
	ret

.read_the_instructions
; show card confirmation list
	ld a, [wCardListVisibleOffset]
	ld [wTempCardListVisibleOffset], a
	ld b, a
	ld a, [wCurMenuItem]
	ld [wTempDeckMachineCursorPos], a
	add b
	ld c, a
	ld [wCurDeck], a
	sla c
	ld b, $0
	ld hl, wMachineDeckPtrs
	add hl, bc

	; set the description text in text box
	push hl
	ld hl, wAutoDeckMachineTextDescriptions
	add hl, bc
	ld bc, wCardConfirmationText
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hl]
	ld [bc], a
	pop hl

	call SafelySwitchToSRAM1
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, DECK_NAME_SIZE
	add hl, bc
	ld d, h
	ld e, l
	ld a, [hl]
	pop hl
	call SafelySwitchToSRAM0
	or a
	jp z, .wait_input ; invalid deck

	; show confirmation list
	ld a, $1
	call PlaySFXConfirmOrCancel
	call SafelySwitchToSRAM1
	xor a
	call HandleDeckMissingCardsList
	call SafelySwitchToSRAM0
	ld a, [wTempCardListVisibleOffset]
	ld [wCardListVisibleOffset], a
	call .InitAutoDeckMenu
	ld a, [wTempDeckMachineCursorPos]
	jp .please_select_deck

.MenuParameters
	db 1, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

.DeckMachineMenuData
	textitem  2, 14, BuildADeckText
	textitem 12, 14, CancelText
	textitem  2, 16, ReadTheInstructionsText
	db $ff

.DeckMachineTitleTextList
	tx FightingMachineText
	tx RockMachineText
	tx WaterMachineText
	tx LightningMachineText
	tx GrassMachineText
	tx PsychicMachineText
	tx ScienceMachineText
	tx FireMachineText
	tx AutoMachineText
	tx LegendaryMachineText

; clears screen, loads the proper tiles
; prints the Auto Deck title and deck entries
; and creates the auto deck configurations
.InitAutoDeckMenu
	call Set_OBJ_8x8
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	call EmptyScreen
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont
	call LoadDuelCardSymbolTiles
	bank1call SetDefaultPalettes
	lb de, $3c, $ff
	call SetupText
	lb de, 0, 0
	lb bc, 20, 13
	call DrawRegularTextBox
	lb de, 1, 0
	call InitTextPrinting
	ld hl, wDeckMachineTitleText
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	call SafelySwitchToSRAM1
	farcall ReadAutoDeckConfiguration
	call .CreateAutoDeckPointerList
	call PrintVisibleDeckMachineEntries
	call SafelySwitchToSRAM0
	call EnableLCD
	ret

; writes to wMachineDeckPtrs the pointers
; to the Auto Decks in sAutoDecks
.CreateAutoDeckPointerList
	ld a, 2 * NUM_DECK_MACHINE_SLOTS
	ld hl, wMachineDeckPtrs
	call ClearNBytesFromHL
	ld de, wMachineDeckPtrs
	ld hl, sAutoDecks
	ld bc, DECK_STRUCT_SIZE
	ld a, NUM_DECK_MACHINE_SLOTS
.loop
	push af
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	add hl, bc
	pop af
	dec a
	jr nz, .loop
	ret
; 0xbc04

Func_bc04: ; bc04 (2:7c04)
	xor a
	ld [wCardListVisibleOffset], a
	ldtx de, DeckSaveMachineText
	ld hl, wDeckMachineTitleText
	ld [hl], e
	inc hl
	ld [hl], d
	call ClearScreenAndDrawDeckMachineScreen
	ld a, DECK_SIZE
	ld [wNumDeckMachineEntries], a
	xor a
.asm_bc1a
	ld hl, DeckMachineSelectionParams
	call InitCardSelectionParams
	call DrawListScrollArrows
	call PrintNumSavedDecks
	ldtx hl, PleaseChooseADeckConfigurationToSendText
	call DrawWideTextBox_PrintText
	ldtx de, PleaseChooseADeckConfigurationToSendText
	call InitDeckMachineDrawingParams
.asm_bc32
	call HandleDeckMachineSelection
	jr c, .asm_bc1a
	cp $ff
	jr nz, .asm_bc3f
	ld a, $01
	or a
	ret
.asm_bc3f
	ld b, a
	ld a, [wCardListVisibleOffset]
	add b
	ld [wSelectedDeckMachineEntry], a
	call CheckIfSelectedDeckMachineEntryIsEmpty
	jr c, .asm_bc32

	call GetSelectedSavedDeckPtr
	ld l, e
	ld h, d
	ld de, wDuelTempList
	ld b, DECK_STRUCT_SIZE
	call EnableSRAM
	call CopyNBytesFromHLToDE
	call DisableSRAM

	xor a
	ld [wNameBuffer], a
	bank1call SendDeckConfiguration
	ret c

	call GetSelectedSavedDeckPtr
	ld l, e
	ld h, d
	ld de, wDefaultText
	call EnableSRAM
	call CopyListFromHLToDE
	call DisableSRAM
	or a
	ret
; 0xbc7a

Func_bc7a: ; bc7a (2:7c7a)
	xor a
	ld [wCardListVisibleOffset], a
	ldtx de, DeckSaveMachineText
	ld hl, wDeckMachineTitleText
	ld [hl], e
	inc hl
	ld [hl], d
	call ClearScreenAndDrawDeckMachineScreen
	ld a, DECK_SIZE
	ld [wNumDeckMachineEntries], a
	xor a
.asm_bc90
	ld hl, DeckMachineSelectionParams
	call InitCardSelectionParams
	call DrawListScrollArrows
	call PrintNumSavedDecks
	ldtx hl, PleaseChooseASaveSlotText
	call DrawWideTextBox_PrintText
	ldtx de, PleaseChooseASaveSlotText
	call InitDeckMachineDrawingParams
	call HandleDeckMachineSelection
	jr c, .asm_bc90
	cp $ff
	jr nz, .asm_bcb5
	ld a, $01
	or a
	ret
.asm_bcb5
	ld b, a
	ld a, [wCardListVisibleOffset]
	add b
	ld [wSelectedDeckMachineEntry], a
	call CheckIfSelectedDeckMachineEntryIsEmpty
	jr nc, .asm_bcc4
	jr .asm_bcd1
.asm_bcc4
	ldtx hl, OKIfFileDeletedText
	call YesOrNoMenuWithText
	jr nc, .asm_bcd1
	ld a, [wCardListCursorPos]
	jr .asm_bc90
.asm_bcd1
	xor a
	ld [wDuelTempList], a
	ld [wNameBuffer], a
	bank1call ReceiveDeckConfiguration
	ret c
	call EnableSRAM
	ld hl, wDuelTempList
	call GetSelectedSavedDeckPtr
	ld b, DECK_STRUCT_SIZE
	call CopyNBytesFromHLToDE
	call DisableSRAM
	call SaveGame
	call ClearScreenAndDrawDeckMachineScreen
	ld a, [wCardListCursorPos]
	ld hl, DeckMachineSelectionParams
	call InitCardSelectionParams
	call DrawListScrollArrows
	call PrintNumSavedDecks
	call DrawListCursor_Visible
	ld hl, wNameBuffer
	ld de, wDefaultText
	call CopyListFromHLToDE
	xor a
	ld [wTxRam2 + 0], a
	ld [wTxRam2 + 1], a
	ldtx hl, ReceivedADeckConfigurationFromText
	call DrawWideTextBox_WaitForInput
	call GetSelectedSavedDeckPtr
	ld l, e
	ld h, d
	ld de, wDefaultText
	call EnableSRAM
	call CopyListFromHLToDE
	call DisableSRAM
	xor a
	ret
; 0xbd2e
