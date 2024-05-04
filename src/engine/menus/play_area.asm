; this function is called when the player is shown the "In Play Area" screen.
; it can be called with either the select button (DuelMenuShortcut_BothActivePokemon),
; or via the "In Play Area" item of the Check menu (DuelCheckMenu_InPlayArea)
OpenInPlayAreaScreen::
	ld a, INPLAYAREA_PLAYER_ACTIVE
	ld [wInPlayAreaCurPosition], a
.start
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	farcall DrawInPlayAreaScreen
	call EnableLCD
	call IsClairvoyanceActive
	jr c, .clairvoyance_on

	ld de, OpenInPlayAreaScreen_TransitionTable1
	jr .clairvoyance_off

.clairvoyance_on
	ld de, OpenInPlayAreaScreen_TransitionTable2
.clairvoyance_off
	ld hl, wMenuInputTablePointer
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, [wInPlayAreaCurPosition]
	call .print_associated_text
.on_frame
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame

	ldh a, [hDPadHeld]
	and START
	jr nz, .selection

	; if this function's been called from 'select' button,
	; wInPlayAreaFromSelectButton is on.
	ld a, [wInPlayAreaFromSelectButton]
	or a
	jr z, .handle_input ; if it's from the Check menu, jump.

	ldh a, [hDPadHeld]
	and SELECT
	jr nz, .skip_input

.handle_input
	ld a, [wInPlayAreaCurPosition]
	ld [wInPlayAreaTemporaryPosition], a
	call OpenInPlayAreaScreen_HandleInput
	jr c, .pressed

	ld a, [wInPlayAreaCurPosition]
	cp INPLAYAREA_PLAYER_PLAY_AREA
	jp z, .show_turn_holder_play_area
	cp INPLAYAREA_OPP_PLAY_AREA
	jp z, .show_non_turn_holder_play_area

	; check if the cursor moved.
	ld hl, wInPlayAreaTemporaryPosition
	cp [hl]
	call nz, .print_associated_text

	jr .on_frame

.pressed
	cp -1
	jr nz, .selection

	; pressed b button.
	call ZeroObjectPositionsAndToggleOAMCopy_Bank6
	lb de, $38, $9f
	call SetupText
	scf
	ret

.skip_input
	call ZeroObjectPositionsAndToggleOAMCopy_Bank6
	lb de, $38, $9f
	call SetupText
	or a
	ret

.selection ; pressed a button or start button.
	call ZeroObjectPositionsAndToggleOAMCopy_Bank6
	lb de, $38, $9f
	call SetupText
	ld a, [wInPlayAreaCurPosition]
	ld [wInPlayAreaPreservedPosition], a
	ld hl, .PositionsJumpTable
	call JumpToFunctionInTable
	ld a, [wInPlayAreaPreservedPosition]
	ld [wInPlayAreaCurPosition], a

	jp .start

.print_associated_text
; each position has a text associated to it,
; which is printed at the bottom of the screen
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
	ld hl, OpenInPlayAreaScreen_TextTable
	ld b, 0
	sla a
	ld c, a
	add hl, bc

	; hl = OpenInPlayAreaScreen_TextTable + 2 * (wInPlayAreaCurPosition)
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, h

	; jump ahead if entry does not contain null text (it's not active pokemon)
	or a
	jr nz, .print_hand_or_discard_pile

	ld a, l
	; bench slots have dummy text IDs assigned to them, which are never used.
	; these are secretly not text id's, but rather, 2-byte PLAY_AREA_BENCH_* constants
	; check if the value at register l is one of those, and jump ahead if not
	cp PLAY_AREA_BENCH_5 + $01
	jr nc, .print_hand_or_discard_pile

; if we make it here, we need to print a Pokemon card name.
; wInPlayAreaCurPosition determines which duelist
; and l contains the PLAY_AREA_* location of the card.
	ld a, [wInPlayAreaCurPosition]
	cp INPLAYAREA_PLAYER_HAND
	jr nc, .opponent_side

	ld a, l
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	ret z

	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	jr .display_card_name

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

.display_card_name
	ld a, 18
	call CopyCardNameAndLevel
	ld hl, wDefaultText
	call ProcessText
	ret

.print_hand_or_discard_pile
; if we make it here, cursor position is to Hand or Discard Pile
; so DuelistHandText_2 or DuelistDiscardPileText will be printed

	ld a, [wInPlayAreaCurPosition]
	cp INPLAYAREA_OPP_ACTIVE
	jr nc, .opp_side_print_hand_or_discard_pile
	call PrintTextNoDelay
	ret

.opp_side_print_hand_or_discard_pile
	call SwapTurn
	call PrintTextNoDelay
	call SwapTurn
	ret

.show_turn_holder_play_area
	lb de, $38, $9f
	call SetupText
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderPlayAreaScreen
	pop af
	ldh [hWhoseTurn], a
	ld a, [wInPlayAreaPreservedPosition]
	ld [wInPlayAreaCurPosition], a
	jp .start

.show_non_turn_holder_play_area
	lb de, $38, $9f
	call SetupText
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderPlayAreaScreen
	pop af
	ldh [hWhoseTurn], a
	ld a, [wInPlayAreaPreservedPosition]
	ld [wInPlayAreaCurPosition], a
	jp .start

.PositionsJumpTable
	table_width 2, OpenInPlayAreaScreen.PositionsJumpTable
	dw OpenInPlayAreaScreen_TurnHolderPlayArea       ; 0x00: INPLAYAREA_PLAYER_BENCH_1
	dw OpenInPlayAreaScreen_TurnHolderPlayArea       ; 0x01: INPLAYAREA_PLAYER_BENCH_2
	dw OpenInPlayAreaScreen_TurnHolderPlayArea       ; 0x02: INPLAYAREA_PLAYER_BENCH_3
	dw OpenInPlayAreaScreen_TurnHolderPlayArea       ; 0x03: INPLAYAREA_PLAYER_BENCH_4
	dw OpenInPlayAreaScreen_TurnHolderPlayArea       ; 0x04: INPLAYAREA_PLAYER_BENCH_5
	dw OpenInPlayAreaScreen_TurnHolderPlayArea       ; 0x05: INPLAYAREA_PLAYER_ACTIVE
	dw OpenInPlayAreaScreen_TurnHolderHand           ; 0x06: INPLAYAREA_PLAYER_HAND
	dw OpenInPlayAreaScreen_TurnHolderDiscardPile    ; 0x07: INPLAYAREA_PLAYER_DISCARD_PILE
	dw OpenInPlayAreaScreen_NonTurnHolderPlayArea    ; 0x08: INPLAYAREA_OPP_ACTIVE
	dw OpenInPlayAreaScreen_NonTurnHolderHand        ; 0x09: INPLAYAREA_OPP_HAND
	dw OpenInPlayAreaScreen_NonTurnHolderDiscardPile ; 0x0a: INPLAYAREA_OPP_DISCARD_PILE
	dw OpenInPlayAreaScreen_NonTurnHolderPlayArea    ; 0x0b: INPLAYAREA_OPP_BENCH_1
	dw OpenInPlayAreaScreen_NonTurnHolderPlayArea    ; 0x0c: INPLAYAREA_OPP_BENCH_2
	dw OpenInPlayAreaScreen_NonTurnHolderPlayArea    ; 0x0d: INPLAYAREA_OPP_BENCH_3
	dw OpenInPlayAreaScreen_NonTurnHolderPlayArea    ; 0x0e: INPLAYAREA_OPP_BENCH_4
	dw OpenInPlayAreaScreen_NonTurnHolderPlayArea    ; 0x0f: INPLAYAREA_OPP_BENCH_5
	assert_table_length NUM_INPLAYAREA_POSITIONS

OpenInPlayAreaScreen_TurnHolderPlayArea:
	; wInPlayAreaCurPosition constants conveniently map to (PLAY_AREA_* constants - 1)
	; for bench locations. this mapping is taken for granted in the following code.
	ld a, [wInPlayAreaCurPosition]
	inc a
	cp INPLAYAREA_PLAYER_ACTIVE + $01
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

OpenInPlayAreaScreen_NonTurnHolderPlayArea:
	ld a, [wInPlayAreaCurPosition]
	sub INPLAYAREA_OPP_ACTIVE
	or a
	jr z, .active
	; convert INPLAYAREA_OPP_BENCH_* constant to PLAY_AREA_BENCH_* constant
	sub INPLAYAREA_OPP_BENCH_1 - INPLAYAREA_OPP_ACTIVE - PLAY_AREA_BENCH_1
.active
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

OpenInPlayAreaScreen_TurnHolderHand:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

OpenInPlayAreaScreen_NonTurnHolderHand:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

OpenInPlayAreaScreen_TurnHolderDiscardPile:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderDiscardPileScreen
	pop af
	ldh [hWhoseTurn], a
	ret

OpenInPlayAreaScreen_NonTurnHolderDiscardPile:
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderDiscardPileScreen
	pop af
	ldh [hWhoseTurn], a
	ret

OpenInPlayAreaScreen_TextTable:
; note that for bench slots, the entries are
; PLAY_AREA_BENCH_* constants in practice
	tx HandText               ; INPLAYAREA_PLAYER_BENCH_1
	tx CheckText              ; INPLAYAREA_PLAYER_BENCH_2
	tx AttackText             ; INPLAYAREA_PLAYER_BENCH_3
	tx PKMNPowerText          ; INPLAYAREA_PLAYER_BENCH_4
	tx DoneText               ; INPLAYAREA_PLAYER_BENCH_5
	dw NULL                   ; INPLAYAREA_PLAYER_ACTIVE
	tx DuelistHandText_2      ; INPLAYAREA_PLAYER_HAND
	tx DuelistDiscardPileText ; INPLAYAREA_PLAYER_DISCARD_PILE
	dw NULL                   ; INPLAYAREA_OPP_ACTIVE
	tx DuelistHandText_2      ; INPLAYAREA_OPP_HAND
	tx DuelistDiscardPileText ; INPLAYAREA_OPP_DISCARD_PILE
	tx HandText               ; INPLAYAREA_OPP_BENCH_1
	tx CheckText              ; INPLAYAREA_OPP_BENCH_2
	tx AttackText             ; INPLAYAREA_OPP_BENCH_3
	tx PKMNPowerText          ; INPLAYAREA_OPP_BENCH_4
	tx DoneText               ; INPLAYAREA_OPP_BENCH_5

MACRO in_play_area_cursor_transition
	cursor_transition \1, \2, \3, INPLAYAREA_\4, INPLAYAREA_\5, INPLAYAREA_\6, INPLAYAREA_\7
ENDM

; it's related to wMenuInputTablePointer.
; with this table, the cursor moves into the proper location by the input.
; note that the unit of the position is not a 8x8 tile.
OpenInPlayAreaScreen_TransitionTable1:
	table_width 7, OpenInPlayAreaScreen_TransitionTable1
	in_play_area_cursor_transition $18, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_2, PLAYER_BENCH_5
	in_play_area_cursor_transition $30, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_3, PLAYER_BENCH_1
	in_play_area_cursor_transition $48, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_4, PLAYER_BENCH_2
	in_play_area_cursor_transition $60, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_5, PLAYER_BENCH_3
	in_play_area_cursor_transition $78, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_1, PLAYER_BENCH_4
	in_play_area_cursor_transition $30, $6c, $00,             OPP_ACTIVE, PLAYER_BENCH_1, PLAYER_DISCARD_PILE, PLAYER_DISCARD_PILE
	in_play_area_cursor_transition $78, $80, $00,             PLAYER_DISCARD_PILE, PLAYER_BENCH_1, PLAYER_ACTIVE, PLAYER_ACTIVE
	in_play_area_cursor_transition $78, $70, $00,             OPP_ACTIVE, PLAYER_HAND, PLAYER_ACTIVE, PLAYER_ACTIVE
	in_play_area_cursor_transition $78, $34, 1 << OAM_X_FLIP, OPP_BENCH_1, PLAYER_ACTIVE, OPP_DISCARD_PILE, OPP_DISCARD_PILE
	in_play_area_cursor_transition $30, $20, 1 << OAM_X_FLIP, OPP_BENCH_1, OPP_DISCARD_PILE, OPP_ACTIVE, OPP_ACTIVE
	in_play_area_cursor_transition $30, $38, 1 << OAM_X_FLIP, OPP_BENCH_1, PLAYER_ACTIVE, OPP_ACTIVE, OPP_ACTIVE
	in_play_area_cursor_transition $90, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_5, OPP_BENCH_2
	in_play_area_cursor_transition $78, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_1, OPP_BENCH_3
	in_play_area_cursor_transition $60, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_2, OPP_BENCH_4
	in_play_area_cursor_transition $48, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_3, OPP_BENCH_5
	in_play_area_cursor_transition $30, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_4, OPP_BENCH_1
	assert_table_length NUM_INPLAYAREA_POSITIONS

OpenInPlayAreaScreen_TransitionTable2:
	table_width 7, OpenInPlayAreaScreen_TransitionTable2
	in_play_area_cursor_transition $18, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_2, PLAYER_BENCH_5
	in_play_area_cursor_transition $30, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_3, PLAYER_BENCH_1
	in_play_area_cursor_transition $48, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_4, PLAYER_BENCH_2
	in_play_area_cursor_transition $60, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_5, PLAYER_BENCH_3
	in_play_area_cursor_transition $78, $8c, $00,             PLAYER_ACTIVE, PLAYER_PLAY_AREA, PLAYER_BENCH_1, PLAYER_BENCH_4
	in_play_area_cursor_transition $30, $6c, $00,             OPP_ACTIVE, PLAYER_BENCH_1, PLAYER_DISCARD_PILE, PLAYER_DISCARD_PILE
	in_play_area_cursor_transition $78, $80, $00,             PLAYER_DISCARD_PILE, PLAYER_BENCH_1, PLAYER_ACTIVE, PLAYER_ACTIVE
	in_play_area_cursor_transition $78, $70, $00,             OPP_ACTIVE, PLAYER_HAND, PLAYER_ACTIVE, PLAYER_ACTIVE
	in_play_area_cursor_transition $78, $34, 1 << OAM_X_FLIP, OPP_BENCH_1, PLAYER_ACTIVE, OPP_DISCARD_PILE, OPP_DISCARD_PILE
	in_play_area_cursor_transition $30, $20, 1 << OAM_X_FLIP, OPP_BENCH_1, OPP_DISCARD_PILE, OPP_ACTIVE, OPP_ACTIVE
	in_play_area_cursor_transition $30, $38, 1 << OAM_X_FLIP, OPP_HAND, PLAYER_ACTIVE, OPP_ACTIVE, OPP_ACTIVE
	in_play_area_cursor_transition $90, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_5, OPP_BENCH_2
	in_play_area_cursor_transition $78, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_1, OPP_BENCH_3
	in_play_area_cursor_transition $60, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_2, OPP_BENCH_4
	in_play_area_cursor_transition $48, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_3, OPP_BENCH_5
	in_play_area_cursor_transition $30, $14, 1 << OAM_X_FLIP, OPP_PLAY_AREA, OPP_ACTIVE, OPP_BENCH_4, OPP_BENCH_1
	assert_table_length NUM_INPLAYAREA_POSITIONS

OpenInPlayAreaScreen_HandleInput:
	xor a
	ld [wMenuInputSFX], a
	ld hl, wMenuInputTablePointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wInPlayAreaCurPosition]
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
	ld a, [wInPlayAreaCurPosition]
	ld [wInPlayAreaPreservedPosition], a
	pop af

	ld [wInPlayAreaCurPosition], a
	cp INPLAYAREA_PLAYER_ACTIVE
	jr c, .player_area
	cp INPLAYAREA_OPP_BENCH_1
	jr c, .next
	cp INPLAYAREA_PLAYER_PLAY_AREA
	jr c, .opponent_area

	jr .next

.player_area
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	dec a
	jr nz, .bench_pokemon_exists

	; no pokemon in player's bench.
	; then move to player's play area.
	ld a, INPLAYAREA_PLAYER_PLAY_AREA
	ld [wInPlayAreaCurPosition], a
	jr .next

.bench_pokemon_exists
	ld b, a
	ld a, [wInPlayAreaCurPosition]
	cp b
	jr c, .next

	; handle index overflow
	ldh a, [hDPadHeld]
	bit D_RIGHT_F, a
	jr z, .on_left

	xor a
	ld [wInPlayAreaCurPosition], a
	jr .next

.on_left
	ld a, b
	dec a
	ld [wInPlayAreaCurPosition], a
	jr .next

.opponent_area
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	dec a
	jr nz, .bench_pokemon_exists_2

	ld a, INPLAYAREA_OPP_PLAY_AREA
	ld [wInPlayAreaCurPosition], a
	jr .next

.bench_pokemon_exists_2
	ld b, a
	ld a, [wInPlayAreaCurPosition]
	sub INPLAYAREA_OPP_BENCH_1
	cp b
	jr c, .next

	ldh a, [hDPadHeld]
	bit D_LEFT_F, a
	jr z, .on_right

	ld a, INPLAYAREA_OPP_BENCH_1
	ld [wInPlayAreaCurPosition], a
	jr .next

.on_right
	ld a, b
	add INPLAYAREA_OPP_DISCARD_PILE
	ld [wInPlayAreaCurPosition], a
.next
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
.check_button
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .return

	and A_BUTTON
	jr nz, .a_button

	; pressed b button
	ld a, -1
	farcall PlaySFXConfirmOrCancel
	scf
	ret

.a_button
	call .draw_cursor
	ld a, $01
	farcall PlaySFXConfirmOrCancel
	ld a, [wInPlayAreaCurPosition]
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
	and $10 - 1
	ret nz

	bit 4, [hl] ; = and $10
	jr nz, ZeroObjectPositionsAndToggleOAMCopy_Bank6

.draw_cursor
	call ZeroObjectPositions
	ld hl, wMenuInputTablePointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wInPlayAreaCurPosition]
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

ZeroObjectPositionsAndToggleOAMCopy_Bank6:
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret
