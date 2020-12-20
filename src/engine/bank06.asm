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
_CopyCardNameAndLevel_HalfwidthText: ; 18086 (6:4086)
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

; this function is called when the player is shown the "In Play Area" screen.
; it can be called with either the select button (DuelMenuShortcut_BothActivePokemon),
; or via the "In Play Area" item of the Check menu (DuelCheckMenu_InPlayArea)
OpenInPlayAreaScreen: ; 180d5 (6:40d5)
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
	ld hl, wInPlayAreaInputTablePointer
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
	ld hl, .jump_table
	call JumpToFunctionInTable
	ld a, [wInPlayAreaPreservedPosition]
	ld [wInPlayAreaCurPosition], a

	jp .start

.print_associated_text ; 18171 (6:4171)
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

.jump_table ; (6:4228)
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

OpenInPlayAreaScreen_TurnHolderPlayArea: ; 18248 (6:4248)
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

OpenInPlayAreaScreen_NonTurnHolderPlayArea: ; 1826a (6:426a)
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

OpenInPlayAreaScreen_TurnHolderHand: ; 18293 (6:4293)
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

OpenInPlayAreaScreen_NonTurnHolderHand: ; 1829d (6:429d)
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenNonTurnHolderHandScreen_Simple
	pop af
	ldh [hWhoseTurn], a
	ret

OpenInPlayAreaScreen_TurnHolderDiscardPile: ; 182a7 (6:42a7)
	ldh a, [hWhoseTurn]
	push af
	bank1call OpenTurnHolderDiscardPileScreen
	pop af
	ldh [hWhoseTurn], a
	ret

OpenInPlayAreaScreen_NonTurnHolderDiscardPile: ; 182b1 (6:42b1)
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
	dw NONE                   ; INPLAYAREA_PLAYER_ACTIVE
	tx DuelistHandText_2      ; INPLAYAREA_PLAYER_HAND
	tx DuelistDiscardPileText ; INPLAYAREA_PLAYER_DISCARD_PILE
	dw NONE                   ; INPLAYAREA_OPP_ACTIVE
	tx DuelistHandText_2      ; INPLAYAREA_OPP_HAND
	tx DuelistDiscardPileText ; INPLAYAREA_OPP_DISCARD_PILE
	tx HandText               ; INPLAYAREA_OPP_BENCH_1
	tx CheckText              ; INPLAYAREA_OPP_BENCH_2
	tx AttackText             ; INPLAYAREA_OPP_BENCH_3
	tx PKMNPowerText          ; INPLAYAREA_OPP_BENCH_4
	tx DoneText               ; INPLAYAREA_OPP_BENCH_5

in_play_area_cursor_transition: MACRO
	cursor_transition \1, \2, \3, INPLAYAREA_\4, INPLAYAREA_\5, INPLAYAREA_\6, INPLAYAREA_\7
ENDM

; it's related to wInPlayAreaInputTablePointer.
; with this table, the cursor moves into the proper location by the input.
; note that the unit of the position is not a 8x8 tile.
OpenInPlayAreaScreen_TransitionTable1:
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

OpenInPlayAreaScreen_TransitionTable2:
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

OpenInPlayAreaScreen_HandleInput: ; 183bb (6:43bb)
	xor a
	ld [wPlaysSfx], a
	ld hl, wInPlayAreaInputTablePointer
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
	ld a, $01
	ld [wPlaysSfx], a
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
	ld a, [wPlaysSfx]
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

.draw_cursor ; 184a0 (6:44a0)
	call ZeroObjectPositions
	ld hl, wInPlayAreaInputTablePointer
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

ZeroObjectPositionsAndToggleOAMCopy_Bank6: ; 184bf (6:44bf)
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	ret

OpenGlossaryScreen: ; 184c8 (6:44c8)
	xor a
	ld [wGlossaryPageNo], a
	call .display_menu

	xor a
	ld [wInPlayAreaCurPosition], a
	ld de, OpenGlossaryScreen_TransitionTable ; this data is stored in bank 2.
	ld hl, wInPlayAreaInputTablePointer
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $ff
	ld [wDuelInitialPrizesUpperBitsSet], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
.next
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	ldh a, [hKeysPressed]
	and SELECT
	jr nz, .on_select

	farcall Func_89ae
	jr nc, .next

	cp -1 ; b button
	jr nz, .check_button

	farcall ZeroObjectPositionsWithCopyToggleOn
	ret

.check_button
	push af
	farcall ZeroObjectPositionsWithCopyToggleOn
	pop af

	cp $09 ; $09: next page or prev page
	jr z, .change_page

	call .print_description
	call .display_menu
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	jr .next

.on_select
	ld a, $01
	farcall PlaySFXConfirmOrCancel
.change_page
	ld a, [wGlossaryPageNo]
	xor $01 ; swap page
	ld [wGlossaryPageNo], a
	call .print_menu
	jr .next

; display glossary menu.
.display_menu ; 1852b (6:452b)
	xor a
	ld [wTileMapFill], a
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call EmptyScreen
	call Set_OBJ_8x8
	farcall LoadCursorTile

	lb de, 5, 0
	call InitTextPrinting
	ldtx hl, PokemonCardGlossaryText
	call ProcessTextFromID
	call .print_menu
	ldtx hl, ChooseWordAndPressAButtonText
	call DrawWideTextBox_PrintText
	ret

; print texts in glossary menu.
.print_menu ; 1855a (6:455a)
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
.print_description ; 18598 (6:4598)
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

	ld hl, GlossaryData1
	jr .front_page

.back_page
	ld hl, GlossaryData2
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
	farcall PlaySFXConfirmOrCancel
	ret

; unit: 5 bytes.
; [structure]
; horizontal align (1) / title text id (2) / desc. text id (2)
glossary_entry: MACRO
	db \1
	tx \2
	tx \3
ENDM

GlossaryData1:
	glossary_entry 7, Text02fa, Text030c
	glossary_entry 5, Text02fb, Text030d
	glossary_entry 7, Text02fc, Text030e
	glossary_entry 6, Text02fd, Text030f
	glossary_entry 6, Text02fe, Text0310
	glossary_entry 4, Text02ff, Text0311
	glossary_entry 5, Text0300, Text0312
	glossary_entry 7, Text0301, Text0313
	glossary_entry 5, Text0302, Text0314

GlossaryData2:
	glossary_entry 5, Text0303, Text0315
	glossary_entry 5, Text0304, Text0316
	glossary_entry 5, Text0305, Text0317
	glossary_entry 5, Text0306, Text0318
	glossary_entry 6, Text0307, Text0319
	glossary_entry 5, Text0308, Text031a
	glossary_entry 6, Text0309, Text031b
	glossary_entry 6, Text030a, Text031c
	glossary_entry 6, Text030b, Text031d

Func_18661: ; 18661 (6:4661)
	xor a
	ld [wPlaysSfx], a
	ld a, [wCheckMenuCursorXPosition]
	ld d, a
	ld a, [wCheckMenuCursorYPosition]
	ld e, a
	ldh a, [hDPadHeld]
	or a
	jr z, .check_button
; check input from dpad
	bit D_LEFT_F, a
	jr nz, .left_or_right
	bit D_RIGHT_F, a
	jr z, .check_up_and_down
.left_or_right
; swap the lsb of x position value.
	ld a, d
	xor $1
	ld d, a
	jr .cursor_moved

.check_up_and_down
	bit D_UP_F, a
	jr nz, .up_or_down
	bit D_DOWN_F, a
	jr z, .check_button
.up_or_down
	ld a, e
	xor $1
	ld e, a
.cursor_moved
	ld a, $1
	ld [wPlaysSfx], a
	push de
	call .draw_blank_cursor
	pop de
	ld a, d
	ld [wCheckMenuCursorXPosition], a
	ld a, e
	ld [wCheckMenuCursorYPosition], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
.check_button
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .check_cursor_moved
	and A_BUTTON
	jr nz, .a_button

; b button
	ld a, -1
	call Func_190fb
	scf
	ret

; a button
.a_button
	call .draw_cursor
	ld a, 1
	call Func_190fb
	scf
	ret

.check_cursor_moved
	ld a, [wPlaysSfx]
	or a
	jr z, .check_cursor_blink
	call PlaySFX
.check_cursor_blink
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and %00001111
	ret nz
	ld a, SYM_CURSOR_R
	bit D_RIGHT_F, [hl]
	jr z, .draw_tile
.draw_blank_cursor ; 186d4 (6:46d4)
	ld a, SYM_SPACE
.draw_tile
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
	; b = 11, c = y_pos * 2 + 14
	; h = x_pos * 10, l = 10
	call WriteByteToBGMap0
	or a
	ret
.draw_cursor ; 186f3 (6:46f3)
	ld a, SYM_CURSOR_R
	jr .draw_tile

; (6:46f7)
INCLUDE "data/effect_commands.asm"

Func_18f9c: ; 18f9c (6:4f9c)
	ld a, [wLoadedMoveAnimation]
	or a
	ret z
	ld l, a
	ld h, 0
	add hl, hl
	ld de, PointerTable_MoveAnimation
.asm_4fa8
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	ld hl, wce7e
	ld a, [hl]
	or a
	jr nz, .asm_4fd3
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
	jr z, .asm_4fd3
	ld a, $96
	call Func_3b6a
.asm_4fd3
	pop de
.asm_4fd4
	ld a, [de]
	inc de
	ld hl, PointerTable_006_508f
	jp JumpToFunctionInTable

Func_18fdc: ; 18fdc (6:4fdc)
	ret

Func_18fdd: ; 18fdd (6:4fdd)
	ldh a, [hWhoseTurn]
	ld [wd4af], a
	ld a, [wDuelType]
	cp $00
	jr nz, Func_19014
	ld a, $c2
	ld [wd4af], a
	jr Func_19014

Func_18ff0: ; 18ff0 (6:4ff0)
	call SwapTurn
	ldh a, [hWhoseTurn]
	ld [wd4af], a
	call SwapTurn
	ld a, [wDuelType]
	cp $00
	jr nz, Func_19014
	ld a, $c3
	ld [wd4af], a
	jr Func_19014

Func_19009: ; 19009 (6:5009)
	ld a, [wce82]
	and $7f
	ld [wd4b0], a
	jr Func_19014

Func_19013: ; 19013 (6:5013)
	ret

Func_19014: ; 19014 (6:5014)
	ld a, [de]
	inc de
	cp $09
	jr z, .asm_502b
	cp $fa
	jr z, .asm_5057
	cp $fb
	jr z, .asm_505d
	cp $fc
	jr z, .asm_5063
.asm_5026
	call Func_3b6a
	jr Func_18f9c.asm_4fd4
.asm_502b
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
	jr nz, .asm_5054
	ld a, $98
	call Func_3b6a
.asm_5054
	jp Func_18f9c.asm_4fd4
.asm_5057
	ld c, $61
	ld b, $63
	jr .asm_5067
.asm_505d
	ld c, $62
	ld b, $64
	jr .asm_5067
.asm_5063
	ld c, $63
	ld b, $61
.asm_5067
	ldh a, [hWhoseTurn]
	cp $c2
	ld a, c
	jr z, .asm_5026
	ld a, [wDuelType]
	cp $00
	ld a, c
	jr z, .asm_5026
	ld a, b
	jr .asm_5026

Func_19079: ; 19079 (6:5079)
	ld a, [de]
	inc de
	ld [$d4b3], a
	ld a, [wce82]
	ld [wd4b0], a
	call Func_1909d
	ld a, $96
	call Func_3b6a
	jp Func_18f9c.asm_4fd4

PointerTable_006_508f: ; 1908f (6:508f)
	dw Func_18fdc
	dw Func_19014
	dw Func_18fdd
	dw Func_18ff0
	dw Func_19079
	dw Func_19009
	dw Func_19013

Func_1909d: ; 1909d (6:509d)
	ld a, [$d4b3]
	cp $04
	jr z, .asm_50ad
	cp $01
	ret nz
	ld a, $00
	ld [wd4ae], a
	ret
.asm_50ad
	ld a, [wd4b0]
	ld l, a
	ld a, [wWhoseTurn]
	ld h, a
	cp $c2
	jr z, .asm_50cc
	ld a, [wDuelType]
	cp $00
	jr z, .asm_50c6
	bit 7, l
	jr z, .asm_50e2
	jr .asm_50d2
.asm_50c6
	bit 7, l
	jr z, .asm_50da
	jr .asm_50ea
.asm_50cc
	bit 7, l
	jr z, .asm_50d2
	jr .asm_50e2
.asm_50d2
	ld l, $04
	ld h, $c2
	ld a, $01
	jr .asm_50f0
.asm_50da
	ld l, $04
	ld h, $c3
	ld a, $01
	jr .asm_50f0
.asm_50e2
	ld l, $05
	ld h, $c3
	ld a, $02
	jr .asm_50f0
.asm_50ea
	ld l, $05
	ld h, $c2
	ld a, $02
.asm_50f0:
	ld [wd4ae], a
	ret

; this part is not perfectly analyzed.
; needs some fix.
	ld a, [$d4b3]
	cp $04
	jr z, Func_190fb.asm_510f
Func_190fb: ; 190fb (6:50fb)
	cp $01
	jr nz, .asm_510e
	ld a, $00
	ld [wd4ae], a
	ld a, [wDuelDisplayedScreen]
	cp $01
	jr z, .asm_510e
	bank1call DrawDuelMainScene
.asm_510e
	ret
.asm_510f
	call Func_1909d
	ld a, [wDuelDisplayedScreen]
	cp l
	jr z, .asm_512e
	ld a, l
	push af
	ld l, $c2
	ld a, [wDuelType]
	cp $00
	jr nz, .asm_5127
	ld a, [wWhoseTurn]
	ld l, a
.asm_5127
	call DrawYourOrOppPlayAreaScreen_Bank0
	pop af
	ld [wDuelDisplayedScreen], a
.asm_512e
	call DrawWideTextBox
	ret

; needs analyze.
	push hl
	push bc
	push de
	ld a, [wLoadedMoveAnimation]
	cp $79
	jr z, .asm_5164
	cp $86
	jr z, .asm_5164
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
	call Func_19168
	ld a, l
	or h
	call nz, DrawWideTextBox_PrintText
.asm_5164
	pop de
	pop bc
	pop hl
	ret

Func_19168: ; 19168 (6:5168)
	ld a, l
	or h
	jr z, .asm_5188
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
.asm_5188
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

INCLUDE "data/move_animations.asm"

	INCROM $19674, $1991f

Func_1991f: ; 1991f (6:591f)
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
.asm_594c
	ld a, [de]
	inc de
	ld l, a
	res 7, [hl]
	dec c
	jr nz, .asm_594c

	ld h, $a1
	ld de, wOpponentDeck
	ld c, $1e
.asm_595b
	ld a, [de]
	inc de
	ld l, a
	res 7, [hl]
	inc [hl]
	dec c
	jr nz, .asm_595b

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

	INCROM $19a1f, $19c20

Func_19c20: ; 19c20 (6:5c20)
	INCROM $19c20, $1a4cf

Func_1a4cf: ; 1a4cf (6:64cf)
	INCROM $1a4cf, $1a61f

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

Func_1a68d: ; 1a68d (6:668d)
	ld a, $c2 ; player's turn
	ldh [hWhoseTurn], a
	ld h, a
	ld l, $00
.asm_6694
	xor a
	ld [hli], a
	ld a, l
	cp $3c
	jr c, .asm_6694
	xor a
	ld hl, wBoosterCardsDrawn
	ld de, wDuelTempList
	ld c, $00
.asm_66a4
	ld a, [hli]
	or a
	jr z, .asm_66ae
	ld a, c
	ld [de], a
	inc de
	inc c
	jr .asm_66a4
.asm_66ae
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

Func_1a6cd: ; 1a6cd (6:66cd)
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
.asm_66de
	ld a, [hli]
	xor e
	ld e, a
	dec bc
	ld a, c
	or b
	jr nz, .asm_66de
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
	jr nz, .asm_6719
	ld a, $e4
	ld [wOBP0], a
	ld [wBGP], a
	ld a, $01
	ld [wFlushPaletteFlags], a
.asm_6719
	lb de, $38, $9f
	call SetupText
	ld hl, $00a3
	bank1call DrawWholeScreenTextBox
	ld a, $0a
	ld [$0000], a
	xor a
	ldh [hBankSRAM], a
	ld [$4000], a
	ld [$a000], a
	ld [$0000], a
	jp Reset
	ret

Func_1a73a: ; 1a73a (6:673a)
	ldh a, [hBankSRAM]
	or a
	ret nz
	push hl
	push de
	push bc
	ld hl, sCardCollection
	ld bc, $0250
	ld e, $00
.asm_6749
	ld a, [hli]
	xor e
	ld e, a
	dec bc
	ld a, c
	or b
	jr nz, .asm_6749
	ld a, $0a
	ld [$0000], a
	ld a, e
	ld [s0a00b], a
	pop bc
	pop de
	pop hl
	ret

WhatIsYourNameData: ; 1a75e (6:675e)
	textitem 1, 1, WhatIsYourNameText
	db $ff
; [Deck1Data ~ Deck4Data]
; These are directed from around (2:4f05),
; without any bank description.
; That is, the developers hard-coded it. -_-;;
Deck1Data: ; 1a763 (6:6763)
	textitem 2, 1, Text022b
	textitem 14, 1, Text0219
	db $ff
Deck2Data: ; 1a76c (6:676c)
	textitem 2, 1, Text022c
	textitem 14, 1, Text0219
	db $ff
Deck3Data: ; 1a775 (6:6775)
	textitem 2, 1, Text022d
	textitem 14, 1, Text0219
	db $ff
Deck4Data: ; 1a77e (6:677e)
	textitem 2, 1, Text022e
	textitem 14, 1, Text0219
	db $ff

; set each byte zero from hl for b bytes.
ClearMemory: ; 1a787 (6:6787)
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
PlayAcceptOrDeclineSFX: ; 1a794 (6:6794)
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
InputPlayerName: ; 1a7a3 (6:67a3)
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
	call Func_1aa07
	ld a, 6
	ld [wNamingScreenCursorX], a
	ld a, 5
	ld [wNamingScreenCursorY], a
	call Func_1aa23
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
InitializeInputName: ; 1a846 (6:6846)
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

FinalizeInputName: ; 1a880 (6:6880)
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
DrawNamingScreenBG: ; 1a892 (6:6892)
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

DrawTextboxForKeyboard: ; 1a8c1 (6:68c1)
	lb de, 0, 3 ; x, y
	lb bc, 20, 15 ; w, h
	call DrawRegularTextBox
	ret

PrintPlayerNameFromInput: ; 1a8cb (6:68cb)
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
NamingScreen_CheckButtonState: ; 1a908 (6:6908)
	xor a
	ld [wPlaysSfx], a
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
	jr z, .asm_692c
	; up
	dec a
	bit D_DOWN_F, a
	jr z, .asm_69a7
	ld a, c
	dec a
	jr .asm_69a7
.asm_692c
	bit D_DOWN_F, b
	jr z, .asm_6937
	; down
	inc a
	cp c
	jr c, .asm_69a7
	xor a
	jr .asm_69a7
.asm_6937
	ld a, [wd005]
	ld c, a
	ld a, h
	bit D_LEFT_F, b
	jr z, .asm_6974
	; left
	ld d, a
	ld a, $06
	cp l
	ld a, d
	jr nz, .asm_696b
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
	jr nz, .asm_6962
	ld a, c
	sub $02
	jr .asm_69aa
.asm_6962
	cp $fe
	jr nz, .asm_696b
	ld a, c
	sub $03
	jr .asm_69aa
.asm_696b
	dec a
	bit D_DOWN_F, a
	jr z, .asm_69aa
	ld a, c
	dec a
	jr .asm_69aa
.asm_6974
	bit D_RIGHT_F, b
	jr z, .no_press
	ld d, a
	ld a, $06
	cp l
	ld a, d
	jr nz, .asm_6990
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
.asm_6990
	inc a
	cp c
	jr c, .asm_69aa
	inc c
	cp c
	jr c, .asm_69a4
	inc c
	cp c
	jr c, .asm_69a0
	ld a, $02
	jr .asm_69aa
.asm_69a0
	ld a, $01
	jr .asm_69aa
.asm_69a4
	xor a
	jr .asm_69aa
.asm_69a7
	ld l, a
	jr .asm_69ab
.asm_69aa
	ld h, a
.asm_69ab
	push hl
	call GetCharInfoFromPos_Player
	inc hl
	inc hl
	inc hl
	ld a, [wd009]
	cp $02
	jr nz, .asm_69bb
	inc hl
	inc hl
.asm_69bb
	ld d, [hl]
	push de
	call Func_1aa07
	pop de
	pop hl
	ld a, l
	ld [wNamingScreenCursorY], a
	ld a, h
	ld [wNamingScreenCursorX], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	ld a, $06
	cp d
	jp z, NamingScreen_CheckButtonState
	ld a, $01
	ld [wPlaysSfx], a
.no_press
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .asm_69ef
	and A_BUTTON
	jr nz, .asm_69e5
	ld a, $ff
.asm_69e5
	call PlayAcceptOrDeclineSFX
	push af
	call Func_1aa23
	pop af
	scf
	ret
.asm_69ef
	ld a, [wPlaysSfx]
	or a
	jr z, .asm_69f8
	call PlaySFX
.asm_69f8
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	ld a, [wceaa]
	bit 4, [hl]
	jr z, Func_1aa07.asm_6a0a

Func_1aa07: ; 1aa07 (6:6a07)
	ld a, [wceab]
.asm_6a0a
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
	call Func_1aa28
	call WriteByteToBGMap0
	or a
	ret

Func_1aa23: ; 1aa23 (6:6a23)
	ld a, [wceaa]
	jr Func_1aa07.asm_6a0a

Func_1aa28: ; 1aa28 (6:6a28)
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
	jr z, .asm_6a60
	ld a, [wNamingScreenBufferLength]
	srl a
	ld d, a
	ld a, [wNamingScreenBufferMaxLength]
	srl a
	ld e, a
	ld a, d
	cp e
	jr nz, .asm_6a49
	dec a
.asm_6a49
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
.asm_6a60
	pop hl
	pop de
	pop bc
	pop af
	ret

; load, to the first tile of v0Tiles0, the graphics for the
; blinking black square used in name input screens.
; for inputting full width text.
LoadTextCursorTile: ; 1aa65 (6:6a65)
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
NamingScreen_ProcessInput: ; 1aa87 (6:6a87)
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
	jr nz, .asm_6ab8
	ld a, [wd009]
	or a
	jr nz, .asm_6aac
	ld a, $01
	jp .asm_6ace
.asm_6aac
	dec a
	jr nz, .asm_6ab4
	ld a, $02
	jp .asm_6ace
.asm_6ab4
	xor a
	jp .asm_6ace
.asm_6ab8
	cp $08
	jr nz, .asm_6ad6
	ld a, [wd009]
	or a
	jr nz, .asm_6ac6
	ld a, $02
	jr .asm_6ace
.asm_6ac6
	dec a
	jr nz, .asm_6acc
	xor a
	jr .asm_6ace
.asm_6acc
	ld a, $01
.asm_6ace
	ld [wd009], a
	call DrawNamingScreenBG
	or a
	ret
.asm_6ad6
	ld a, [wd009]
	cp $02
	jr z, .read_char
	ldfw3 bc, "“"
	ld a, d
	cp b
	jr nz, .asm_6af4
	ld a, e
	cp c
	jr nz, .asm_6af4
	push hl
	ld hl, TransitionTable1 ; from 55th.
	call TransformCharacter
	pop hl
	jr c, .nothing
	jr .asm_6b09
.asm_6af4
	ldfw3 bc, "º(2)"
	ld a, d
	cp b
	jr nz, .asm_6b1d
	ld a, e
	cp c
	jr nz, .asm_6b1d
	push hl
	ld hl, TransitionTable2 ; from 72th.
	call TransformCharacter
	pop hl
	jr c, .nothing
.asm_6b09
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
	jr .asm_6b37
.asm_6b1d
	ld a, d
	or a
	jr nz, .asm_6b37
	ld a, [wd009]
	or a
	jr nz, .asm_6b2b
	ld a, TX_HIRAGANA
	jr .asm_6b37
.asm_6b2b
	ld a, TX_KATAKANA
	jr .asm_6b37
; read character code from info. to register.
; hl: pointer.
.read_char
	ld e, [hl]
	inc hl
	ld a, [hl] ; a: first byte of the code.
	or a
	; if 2 bytes code, jump.
	jr nz, .asm_6b37
	; if 1 byte code(ascii),
	; set first byte to $0e.
	ld a, $0e
; on 2 bytes code.
.asm_6b37
	ld d, a ; de: character code.
	ld hl, wNamingScreenBufferLength
	ld a, [hl]
	ld c, a
	push hl
	ld hl, wNamingScreenBufferMaxLength
	cp [hl]
	pop hl
	jr nz, .asm_6b4c
	; if the buffer is full
	; just change the last character of it.
	ld hl, wNamingScreenBuffer
	dec hl
	dec hl
	jr .asm_6b51
; increase name length before add the character.
.asm_6b4c
	inc [hl]
	inc [hl]
	ld hl, wNamingScreenBuffer
; write 2 bytes character codes to the name buffer.
; de: 2 bytes character codes.
; hl: dest.
.asm_6b51
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
TransformCharacter: ; 1ab61 (6:6b61)
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
GetCharInfoFromPos_Player: ; 1ab93 (6:6b93)
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

KeyboardData_Player: ; 1abaf (6:6baf)
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
	kbitem $0a, $12, $3a, $00,                  "c"
	kbitem $0c, $12, $3b, $00,                  "p"
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
	call Func_1ae99

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
	call Func_1afa1

	ld a, 6
	ld [wNamingScreenCursorX], a
	ld [wNamingScreenCursorY], a
	call Func_1afbd

	jr .loop
.on_start
	call Func_1aefb
	jr nc, .loop

	cp $ff
	jr z, .asm_6e1c

	call Func_1aec3
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
.asm_6e1c
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
LoadHalfWidthTextCursorTile: ; 1ae37 (6:6e37)
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
ProcessTextWithUnderbar: ; 1ae59 (6:6e59)
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

Func_1ae99: ; 1ae99 (6:6e99)
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

Func_1aec3: ; 1aec3 (6:6ec3)
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call GetCharInfoFromPos_Deck
	inc hl
	inc hl
	ld a, [hl]
	cp $01
	jr nz, .asm_6ed7
	scf
	ret
.asm_6ed7
	ld d, a
	ld hl, wNamingScreenBufferLength
	ld a, [hl]
	ld c, a
	push hl
	ld hl, wNamingScreenBufferMaxLength
	cp [hl]
	pop hl
	jr nz, .asm_6eeb
	ld hl, wNamingScreenBuffer
	dec hl
	jr .asm_6eef
.asm_6eeb
	inc [hl]
	ld hl, wNamingScreenBuffer
.asm_6eef
	ld b, 0
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], TX_END
	call ProcessTextWithUnderbar
	or a
	ret

Func_1aefb: ; 1aefb (6:6efb)
	xor a
	ld [wPlaysSfx], a
	ldh a, [hDPadHeld]
	or a
	jp z, .asm_6f73
	ld b, a
	ld a, [wNamingScreenKeyboardHeight]
	ld c, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	bit 6, b
	jr z, .asm_6f1f
	dec a
	bit 7, a
	jr z, .asm_6f4b
	ld a, c
	dec a
	jr .asm_6f4b
.asm_6f1f
	bit 7, b
	jr z, .asm_6f2a
	inc a
	cp c
	jr c, .asm_6f4b
	xor a
	jr .asm_6f4b
.asm_6f2a
	cp $06
	jr z, .asm_6f73
	ld a, [wd005]
	ld c, a
	ld a, h
	bit 5, b
	jr z, .asm_6f40
	dec a
	bit 7, a
	jr z, .asm_6f4e
	ld a, c
	dec a
	jr .asm_6f4e
.asm_6f40
	bit 4, b
	jr z, .asm_6f73
	inc a
	cp c
	jr c, .asm_6f4e
	xor a
	jr .asm_6f4e
.asm_6f4b
	ld l, a
	jr .asm_6f4f
.asm_6f4e
	ld h, a
.asm_6f4f
	push hl
	call GetCharInfoFromPos_Deck
	inc hl
	inc hl
	ld d, [hl]
	push de
	call Func_1afa1
	pop de
	pop hl
	ld a, l
	ld [wNamingScreenCursorY], a
	ld a, h
	ld [wNamingScreenCursorX], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	ld a, $02
	cp d
	jp z, Func_1aefb
	ld a, $01
	ld [wPlaysSfx], a
.asm_6f73
	ldh a, [hKeysPressed]
	and $03
	jr z, .asm_6f89
	and $01
	jr nz, .asm_6f7f
	ld a, $ff
.asm_6f7f
	call PlayAcceptOrDeclineSFX
	push af
	call Func_1afbd
	pop af
	scf
	ret
.asm_6f89
	ld a, [wPlaysSfx]
	or a
	jr z, .asm_6f92
	call PlaySFX
.asm_6f92
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	ld a, [wceaa]
	bit 4, [hl]
	jr z, Func_1afa1.asm_6fa4

Func_1afa1: ; 1afa1 (6:6fa1)
	ld a, [wceab]
.asm_6fa4
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
	call Func_1afc2
	call WriteByteToBGMap0
	or a
	ret

Func_1afbd: ; 1afbd (6:6fbd)
	ld a, [wceaa]
	jr Func_1afa1.asm_6fa4

Func_1afc2: ; 1afc2 (6:6fc2)
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
	jr z, .asm_6ffb
	ld a, [wNamingScreenBufferLength]
	ld d, a
	ld a, [wNamingScreenBufferMaxLength]
	ld e, a
	ld a, d
	cp e
	jr nz, .asm_6fdf
	dec a
.asm_6fdf
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
.asm_6ffb
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
GetCharInfoFromPos_Deck: ; 1b000 (6:7000)
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

KeyboardData_Deck: ; 1b019 (6:7019)
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

Func_1ba12: ; 1ba12 (6:7a12)
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
.asm_7a26
	call Func_1ba4c
	call Func_1ba5b
	call Func_1ba7d
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
	jr nz, .asm_7a26
	call DisableSRAM
	ret

Func_1ba4c: ; 1ba4c (6:7a4c)
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

Func_1ba5b: ; 1ba5b (6:7a5b)
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
.asm_7a67
	ld a, [de]
	inc de
	ld b, a
	or a
	jr z, .asm_7a77
	ld a, [de]
	inc de
	ld c, a
.asm_7a70
	ld [hl], c
	inc hl
	dec b
	jr nz, .asm_7a70
	jr .asm_7a67
.asm_7a77
	pop de
	pop bc
	pop hl
	inc hl
	inc hl
	ret

Func_1ba7d: ; 1ba7d (6:7a7d)
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
.asm_7a8d
	ld a, [de]
	ld [hli], a
	or a
	jr z, .asm_7a95
	inc de
	jr .asm_7a8d
.asm_7a95
	pop bc
	pop hl
	inc hl
	inc hl
	ret

; farcall from 0xb87e(2:787d): [EF|06|9A|7A]
Func_1ba9a: ; 1ba9a (6:7a9a)
	xor a
	ld [wd0a6], a
	ld a, $01
.asm_7aa0
	call Func_1bae4
	ret nc
	sla a
	cp $10
	jr z, .asm_7aac
	jr .asm_7aa0
.asm_7aac
	ld a, $03
	call Func_1bae4
	ret nc
	ld a, $05
	call Func_1bae4
	ret nc
	ld a, $09
	call Func_1bae4
	ret nc
	ld a, $06
	call Func_1bae4
	ret nc
	ld a, $0a
	call Func_1bae4
	ret nc
	ld a, $0c
	call Func_1bae4
	ret nc
	ld a, $f7
.asm_7ad2
	call Func_1bae4
	ret nc
	sra a
	cp $ff
	jr z, .asm_7ade
	jr .asm_7ad2
.asm_7ade
	call Func_1bae4
	ret nc
	scf
	ret

Func_1bae4: ; 1bae4 (6:7ae4)
	push af
	ld hl, wd088
	ld b, [hl]
	farcall $2, $7625
	jr c, .asm_7af5
	pop af
	ld [wd0a6], a
	or a
	ret
.asm_7af5
	pop af
	scf
	ret

rept $508
	db $ff
endr
