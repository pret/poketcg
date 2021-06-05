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

; it's related to wMenuInputTablePointer.
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
	ld hl, wMenuInputTablePointer
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

	farcall YourOrOppPlayAreaScreen_HandleInput
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
	glossary_entry 7, AboutTheDeckText, DeckDescriptionText
	glossary_entry 5, AboutTheDiscardPileText, DiscardPileDescriptionText
	glossary_entry 7, AboutTheHandText, HandDescriptionText
	glossary_entry 6, AboutTheArenaText, ArenaDescriptionText
	glossary_entry 6, AboutTheBenchText, BenchDescriptionText
	glossary_entry 4, AboutTheActivePokemonText, ActivePokemonDescriptionText
	glossary_entry 5, AboutBenchPokemonText, BenchPokemonDescriptionText
	glossary_entry 7, AboutPrizesText, PrizesDescriptionText
	glossary_entry 5, AboutDamageCountersText, DamageCountersDescriptionText

GlossaryData2:
	glossary_entry 5, AboutEnergyCardsText, EnergyCardsDescriptionText
	glossary_entry 5, AboutTrainerCardsText, TrainerCardsDescriptionText
	glossary_entry 5, AboutBasicPokemonText, BasicPokemonDescriptionText
	glossary_entry 5, AboutEvolutionCardsText, EvolutionCardsDescriptionText
	glossary_entry 6, AboutAttackingText, AttackingDescriptionText
	glossary_entry 5, AboutPokemonPowerText, PokemonPowerDescriptionText
	glossary_entry 6, AboutWeaknessText, WeaknessDescriptionText
	glossary_entry 6, AboutResistanceText, ResistanceDescriptionText
	glossary_entry 6, AboutRetreatingText, RetreatingDescriptionText

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

; reads the animation commands from PointerTable_AttackAnimation
; of attack in wLoadedAttackAnimation and plays them
PlayAttackAnimationCommands: ; 18f9c (6:4f9c)
	ld a, [wLoadedAttackAnimation]
	or a
	ret z

	ld l, a
	ld h, 0
	add hl, hl
	ld de, PointerTable_AttackAnimation
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]

	push de
	ld hl, wce7e
	ld a, [hl]
	or a
	jr nz, .read_command
	ld [hl], $01
	call Func_3b21
	pop de

	push de
	ld a, DUEL_ANIM_SCREEN_MAIN_SCENE
	ld [wDuelAnimationScreen], a
	ld a, $01
	ld [wd4b3], a
	xor a
	ld [wDuelAnimLocationParam], a
	ld a, [de]
	cp $04
	jr z, .read_command
	ld a, DUEL_ANIM_150
	call PlayDuelAnimation
.read_command
	pop de
	; fallthrough

PlayAttackAnimationCommands_NextCommand: ; 18fd4 (6:4fd4)
	ld a, [de]
	inc de
	ld hl, AnimationCommandPointerTable
	jp JumpToFunctionInTable

AnimationCommand_AnimEnd: ; 18fdc (6:4fdc)
	ret

AnimationCommand_AnimPlayer: ; 18fdd (6:4fdd)
	ldh a, [hWhoseTurn]
	ld [wDuelAnimDuelistSide], a
	ld a, [wDuelType]
	cp $00
	jr nz, AnimationCommand_AnimNormal
	ld a, PLAYER_TURN
	ld [wDuelAnimDuelistSide], a
	jr AnimationCommand_AnimNormal

AnimationCommand_AnimOpponent: ; 18ff0 (6:4ff0)
	call SwapTurn
	ldh a, [hWhoseTurn]
	ld [wDuelAnimDuelistSide], a
	call SwapTurn
	ld a, [wDuelType]
	cp $00
	jr nz, AnimationCommand_AnimNormal
	ld a, OPPONENT_TURN
	ld [wDuelAnimDuelistSide], a
	jr AnimationCommand_AnimNormal

AnimationCommand_AnimUnknown2: ; 19009 (6:5009)
	ld a, [wce82]
	and $7f
	ld [wDuelAnimLocationParam], a
	jr AnimationCommand_AnimNormal

AnimationCommand_AnimEnd2: ; 19013 (6:5013)
	ret

AnimationCommand_AnimNormal: ; 19014 (6:5014)
	ld a, [de]
	inc de
	cp DUEL_ANIM_SHOW_DAMAGE
	jr z, .show_damage
	cp DUEL_ANIM_SHAKE1
	jr z, .shake_1
	cp DUEL_ANIM_SHAKE2
	jr z, .shake_2
	cp DUEL_ANIM_SHAKE3
	jr z, .shake_3

.play_anim
	call PlayDuelAnimation
	jr PlayAttackAnimationCommands_NextCommand

.show_damage
	ld a, DUEL_ANIM_PRINT_DAMAGE
	call PlayDuelAnimation
	ld a, [wce81]
	ld [wd4b3], a

	push de
	ld hl, wce7f
	ld de, wDuelAnimDamage
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop de

	ld a, $8c
	call PlayDuelAnimation
	ld a, [wDuelDisplayedScreen]
	cp DUEL_MAIN_SCENE
	jr nz, .skip_update_hud
	ld a, DUEL_ANIM_UPDATE_HUD
	call PlayDuelAnimation
.skip_update_hud
	jp PlayAttackAnimationCommands_NextCommand

; screen shake happens differently
; depending on whose turn it is
.shake_1
	ld c, DUEL_ANIM_SMALL_SHAKE_X
	ld b, DUEL_ANIM_SMALL_SHAKE_Y
	jr .check_duelist

.shake_2
	ld c, DUEL_ANIM_BIG_SHAKE_X
	ld b, DUEL_ANIM_BIG_SHAKE_Y
	jr .check_duelist

.shake_3
	ld c, DUEL_ANIM_SMALL_SHAKE_Y
	ld b, DUEL_ANIM_SMALL_SHAKE_X

.check_duelist
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	ld a, c
	jr z, .play_anim
	ld a, [wDuelType]
	cp $00
	ld a, c
	jr z, .play_anim
	ld a, b
	jr .play_anim

AnimationCommand_AnimUnknown: ; 19079 (6:5079)
	ld a, [de]
	inc de
	ld [wd4b3], a
	ld a, [wce82]
	ld [wDuelAnimLocationParam], a
	call SetDuelAnimationScreen
	ld a, DUEL_ANIM_150
	call PlayDuelAnimation
	jp PlayAttackAnimationCommands_NextCommand

AnimationCommandPointerTable: ; 1908f (6:508f)
	dw AnimationCommand_AnimEnd      ; anim_end
	dw AnimationCommand_AnimNormal   ; anim_normal
	dw AnimationCommand_AnimPlayer   ; anim_player
	dw AnimationCommand_AnimOpponent ; anim_opponent
	dw AnimationCommand_AnimUnknown  ; anim_unknown
	dw AnimationCommand_AnimUnknown2 ; anim_unknown2
	dw AnimationCommand_AnimEnd2     ; anim_end2 (unused)

; sets wDuelAnimationScreen according to wd4b3
; if wd4b3 == $01, set it to Main Scene
; if wd4b3 == $04, st it to Play Area scene
SetDuelAnimationScreen: ; 1909d (6:509d)
	ld a, [wd4b3]
	cp $04
	jr z, .set_play_area_screen
	cp $01
	ret nz
	ld a, DUEL_ANIM_SCREEN_MAIN_SCENE
	ld [wDuelAnimationScreen], a
	ret

.set_play_area_screen
	ld a, [wDuelAnimLocationParam]
	ld l, a
	ld a, [wWhoseTurn]
	ld h, a
	cp PLAYER_TURN
	jr z, .player

; opponent
	ld a, [wDuelType]
	cp $00
	jr z, .asm_50c6

; link duel or vs. AI
	bit 7, l
	jr z, .asm_50e2
	jr .asm_50d2

.asm_50c6
	bit 7, l
	jr z, .asm_50da
	jr .asm_50ea

.player
	bit 7, l
	jr z, .asm_50d2
	jr .asm_50e2

.asm_50d2
	ld l, UNKNOWN_SCREEN_4
	ld h, PLAYER_TURN
	ld a, DUEL_ANIM_SCREEN_PLAYER_PLAY_AREA
	jr .ok
.asm_50da
	ld l, UNKNOWN_SCREEN_4
	ld h, OPPONENT_TURN
	ld a, DUEL_ANIM_SCREEN_PLAYER_PLAY_AREA
	jr .ok
.asm_50e2
	ld l, UNKNOWN_SCREEN_5
	ld h, OPPONENT_TURN
	ld a, DUEL_ANIM_SCREEN_OPP_PLAY_AREA
	jr .ok
.asm_50ea
	ld l, UNKNOWN_SCREEN_5
	ld h, PLAYER_TURN
	ld a, DUEL_ANIM_SCREEN_OPP_PLAY_AREA

.ok:
	ld [wDuelAnimationScreen], a
	ret

Func_190f4: ; 190f4 (6:50f4)
	ld a, [wd4b3]
	cp $04
	jr z, Func_1910f
	; fallthrough

Func_190fb: ; 190fb (6:50fb)
	cp $01
	jr nz, .asm_510e
	ld a, DUEL_ANIM_SCREEN_MAIN_SCENE
	ld [wDuelAnimationScreen], a
	ld a, [wDuelDisplayedScreen]
	cp $01
	jr z, .asm_510e
	bank1call DrawDuelMainScene
.asm_510e
	ret

Func_1910f: ; 1910f (6:510f)
	call SetDuelAnimationScreen
	ld a, [wDuelDisplayedScreen]
	cp l
	jr z, .skip_change_screen
	ld a, l
	push af
	ld l, PLAYER_TURN
	ld a, [wDuelType]
	cp $00
	jr nz, .asm_5127
	ld a, [wWhoseTurn]
	ld l, a
.asm_5127
	call DrawYourOrOppPlayAreaScreen_Bank0
	pop af
	ld [wDuelDisplayedScreen], a
.skip_change_screen
	call DrawWideTextBox
	ret

; prints text related to the damage received
; by card stored in wTempNonTurnDuelistCardID
; takes into account type effectiveness
PrintDamageText: ; 19132 (6:5132)
	push hl
	push bc
	push de
	ld a, [wLoadedAttackAnimation]
	cp ATK_ANIM_HEAL
	jr z, .skip
	cp ATK_ANIM_HEALING_WIND_PLAY_AREA
	jr z, .skip

	ld a, [wTempNonTurnDuelistCardID]
	ld e, a
	ld d, $00
	call LoadCardDataToBuffer1_FromCardID
	ld a, 18
	call CopyCardNameAndLevel
	ld [hl], TX_END
	ld hl, wTxRam2
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wce7f
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetDamageText
	ld a, l
	or h
	call nz, DrawWideTextBox_PrintText
.skip
	pop de
	pop bc
	pop hl
	ret

; returns in hl the text id associated with
; the damage in hl and its effectiveness
GetDamageText: ; 19168 (6:5168)
	ld a, l
	or h
	jr z, .no_damage
	call LoadTxRam3
	ld a, [wce81]
	ldtx hl, AttackDamageText
	and (1 << RESISTANCE) | (1 << WEAKNESS)
	ret z ; not weak or resistant
	ldtx hl, WeaknessMoreDamage2Text
	cp (1 << RESISTANCE) | (1 << WEAKNESS)
	ret z ; weak and resistant
	and (1 << WEAKNESS)
	ldtx hl, WeaknessMoreDamageText
	ret nz ; weak
	ldtx hl, ResistanceLessDamageText
	ret ; resistant

.no_damage
	call CheckNoDamageOrEffect
	ret c
	ldtx hl, NoDamageText
	ld a, [wce81]
	and (1 << RESISTANCE)
	ret z ; not resistant
	ldtx hl, ResistanceNoDamageText
	ret ; resistant

UpdateMainSceneHUD: ; 19199 (6:5199)
	ld a, [wDuelDisplayedScreen]
	cp DUEL_MAIN_SCENE
	ret nz
	bank1call DrawDuelHUDs
	ret

Func_191a3: ; 191a3 (6:51a3)
	ret

INCLUDE "data/attack_animations.asm"

; if carry flag is set, only delays
; if carry not set:
; - set rRP to $c1, wait;
; - set rRP to $c0, wait;
; - return
Func_19674: ; 19674 (6:5674)
	jr c, .delay_once
	ld [hl], $c1
	ld a, 5
	jr .loop_delay_1 ; jump to possibly to add more cycles?
.loop_delay_1
	dec a
	jr nz, .loop_delay_1
	ld [hl], $c0
	ld a, 14
	jr .loop_delay_2 ; jump to possibly to add more cycles?
.loop_delay_2
	dec a
	jr nz, .loop_delay_2
	ret

.delay_once
	ld a, 21
	jr .loop_delay_3 ; jump to possibly to add more cycles?
.loop_delay_3
	dec a
	jr nz, .loop_delay_3
	nop
	ret
; 0x19692

; input a = byte to transmit through IR
TransmitByteThroughIR: ; 19692 (6:5692)
	push hl
	ld hl, rRP
	push de
	push bc
	ld b, a
	scf  ; carry set
	call Func_19674
	or a ; carry not set
	call Func_19674
	ld c, 8
	ld c, 8 ; number of input bits
.loop
	ld a, $00
	rr b
	call Func_19674
	dec c
	jr nz, .loop
	pop bc
	pop de
	pop hl
	ldh a, [rJOYP]
	bit 1, a ; P11
	jr z, ReturnZFlagUnsetAndCarryFlagSet
	xor a ; return z set
	ret

; same as ReceiveByteThroughIR but
; returns $0 in a if there's an error in IR
ReceiveByteThroughIR_ZeroIfUnsuccessful: ; 196ba (6:56ba)
	call ReceiveByteThroughIR
	ret nc
	xor a
	ret
; 0x196c0

; returns carry if there's some time out
; and output in register a of $ff
; otherwise returns in a some sequence of bits
; related to how rRP sets/unsets bit 1
ReceiveByteThroughIR: ; 196c0 (6:56c0)
	push de
	push bc
	push hl

; waits for bit 1 in rRP to be unset
; up to $100 loops
	ld b, 0
	ld hl, rRP
.wait_ir
	bit 1, [hl]
	jr z, .ok
	dec b
	jr nz, .wait_ir
	; looped around $100 times
	; return $ff and carry set
	pop hl
	pop bc
	pop de
	scf
	ld a, $ff
	ret

.ok
; delay for some cycles
	ld a, 15
.loop_delay
	dec a
	jr nz, .loop_delay

; loop for each bit
	ld e, 8
.loop
	ld a, $01
	; possibly delay cycles?
	ld b, 9
	ld b, 9
	ld b, 9
	ld b, 9

; checks for bit 1 in rRP
; if in any of the checks it is unset,
; then a is set to 0
; this is done a total of 9 times
	bit 1, [hl]
	jr nz, .asm_196ec
	xor a
.asm_196ec
	bit 1, [hl]
	jr nz, .asm_196f1
	xor a
.asm_196f1
	dec b
	jr nz, .asm_196ec
	; one bit received
	rrca
	rr d
	dec e
	jr nz, .loop
	ld a, d ; has bits set for each "cycle" that bit 1 was not unset
	pop hl
	pop bc
	pop de
	or a
	ret
; 0x19700

ReturnZFlagUnsetAndCarryFlagSet: ; 19700 (6:5700)
	ld a, $ff
	or a ; z not set
	scf  ; carry set
	ret
; 0x19705

; called when expecting to transmit data
Func_19705: ; 19705 (6:5705)
	ld hl, rRP
.asm_19708
	ldh a, [rJOYP]
	bit 1, a
	jr z, ReturnZFlagUnsetAndCarryFlagSet
	ld a, $aa ; request
	call TransmitByteThroughIR
	push hl
	pop hl
	call ReceiveByteThroughIR_ZeroIfUnsuccessful
	cp $33 ; acknowledge
	jr nz, .asm_19708
	xor a
	ret
; 0x1971e

; called when expecting to receive data
Func_1971e: ; 1971e (6:571e)
	ld hl, rRP
.asm_19721
	ldh a, [rJOYP]
	bit 1, a
	jr z, ReturnZFlagUnsetAndCarryFlagSet
	call ReceiveByteThroughIR_ZeroIfUnsuccessful
	cp $aa ; request
	jr nz, .asm_19721
	ld a, $33 ; acknowledge
	call TransmitByteThroughIR
	xor a
	ret
; 0x19735

ReturnZFlagUnsetAndCarryFlagSet2: ; 19735 (6:5735)
	jp ReturnZFlagUnsetAndCarryFlagSet
; 0x19738

TransmitIRDataBuffer: ; 19738 (6:5738)
	call Func_19705
	jr c, ReturnZFlagUnsetAndCarryFlagSet2
	ld a, $49
	call TransmitByteThroughIR
	ld a, $52
	call TransmitByteThroughIR
	ld hl, wIRDataBuffer
	ld c, 8
	jr TransmitNBytesFromHLThroughIR

ReceiveIRDataBuffer: ; 1974e (6:5738)
	call Func_1971e
	jr c, ReturnZFlagUnsetAndCarryFlagSet2
	call ReceiveByteThroughIR
	cp $49
	jr nz, ReceiveIRDataBuffer
	call ReceiveByteThroughIR
	cp $52
	jr nz, ReceiveIRDataBuffer
	ld hl, wIRDataBuffer
	ld c, 8
	jr ReceiveNBytesToHLThroughIR

; hl = start of data to transmit
; c = number of bytes to transmit
TransmitNBytesFromHLThroughIR: ; 19768 (6:5768)
	ld b, $0
.loop_data_bytes
	ld a, b
	add [hl]
	ld b, a
	ld a, [hli]
	call TransmitByteThroughIR
	jr c, .asm_1977c
	dec c
	jr nz, .loop_data_bytes
	ld a, b
	cpl
	inc a
	call TransmitByteThroughIR
.asm_1977c
	ret

; hl = address to write received data
; c = number of bytes to be received
ReceiveNBytesToHLThroughIR: ; 1977d (6:577d)
	ld b, 0
.loop_data_bytes
	call ReceiveByteThroughIR
	jr c, ReturnZFlagUnsetAndCarryFlagSet2
	ld [hli], a
	add b
	ld b, a
	dec c
	jr nz, .loop_data_bytes
	call ReceiveByteThroughIR
	add b
	or a
	jr nz, ReturnZFlagUnsetAndCarryFlagSet2
	ret
; 0x19792

; disables interrupts, and sets joypad and IR communication port
; switches to CGB normal speed
StartIRCommunications: ; 19792 (6:5792)
	di
	call SwitchToCGBNormalSpeed
	ld a, P14
	ldh [rJOYP], a
	ld a, $c0
	ldh [rRP], a
	ret
; 0x1979f

; reenables interrupts, and switches CGB back to double speed
CloseIRCommunications: ; 1979f (6:579f)
	ld a, P14 | P15
	ldh [rJOYP], a
.wait_vblank_on
	ldh a, [rSTAT]
	and STAT_LCDC_STATUS
	cp STAT_ON_VBLANK
	jr z, .wait_vblank_on
.wait_vblank_off
	ldh a, [rSTAT]
	and STAT_LCDC_STATUS
	cp STAT_ON_VBLANK
	jr nz, .wait_vblank_off
	call SwitchToCGBDoubleSpeed
	ei
	ret
; 0x197b8

; set rRP to 0
ClearRP: ; 197b8 (6:57b8)
	ld a, $00
	ldh [rRP], a
	ret
; 0x197bd

; expects to receive a command (IRCMD_* constant)
; in wIRDataBuffer + 1, then calls the subroutine
; corresponding to that command
ExecuteReceivedIRCommands: ; 197bd (6:57bd)
	call StartIRCommunications
.loop_commands
	call ReceiveIRDataBuffer
	jr c, .error
	jr nz, .loop_commands
	ld hl, wIRDataBuffer + 1
	ld a, [hl]
	ld hl, .CmdPointerTable
	cp NUM_IR_COMMANDS
	jr nc, .loop_commands ; invalid command
	call .JumpToCmdPointer ; execute command
	jr .loop_commands
.error
	call CloseIRCommunications
	xor a
	scf
	ret

.JumpToCmdPointer
	add a ; *2
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
.jp_hl
	jp hl

.CmdPointerTable
	dw .Close                ; IRCMD_CLOSE
	dw .ReturnWithoutClosing ; IRCMD_RETURN_WO_CLOSING
	dw .TransmitData         ; IRCMD_TRANSMIT_DATA
	dw .ReceiveData          ; IRCMD_RECEIVE_DATA
	dw .CallFunction         ; IRCMD_CALL_FUNCTION

; closes the IR communications
; pops hl so that the sp points
; to the return address of ExecuteReceivedIRCommands
.Close
	pop hl
	call CloseIRCommunications
	or a
	ret

; returns without closing the IR communications
; will continue the command loop
.ReturnWithoutClosing
	or a
	ret

; receives an address and number of bytes
; and transmits starting at that address
.TransmitData
	call Func_19705
	ret c
	call LoadRegistersFromIRDataBuffer
	jp TransmitNBytesFromHLThroughIR

; receives an address and number of bytes
; and writes the data received to that address
.ReceiveData
	call LoadRegistersFromIRDataBuffer
	ld l, e
	ld h, d
	call ReceiveNBytesToHLThroughIR
	jr c, .asm_19812
	sub b
	call TransmitByteThroughIR
.asm_19812
	ret

; receives an address to call, then stores
; the registers in the IR data buffer
.CallFunction
	call LoadRegistersFromIRDataBuffer
	call .jp_hl
	call StoreRegistersInIRDataBuffer
	ret
; 0x1981d

; returns carry set if request sent was not acknowledged
TrySendIRRequest: ; 1981d (6:581d)
	call StartIRCommunications
	ld hl, rRP
	ld c, 4
.send_request
	ld a, $aa ; request
	push bc
	call TransmitByteThroughIR
	push bc
	pop bc
	call ReceiveByteThroughIR_ZeroIfUnsuccessful
	pop bc
	cp $33 ; acknowledgement
	jr z, .received_ack
	dec c
	jr nz, .send_request
	scf
	jr .close

.received_ack
	xor a
.close
	push af
	call CloseIRCommunications
	pop af
	ret
; 0x19842

; returns carry set if request was not received
TryReceiveIRRequest: ; 19842 (6:5842)
	call StartIRCommunications
	ld hl, rRP
.wait_request
	call ReceiveByteThroughIR_ZeroIfUnsuccessful
	cp $aa ; request
	jr z, .send_ack
	ldh a, [rJOYP]
	cpl
	and P10 | P11
	jr z, .wait_request
	scf
	jr .close

.send_ack
	ld a, $33 ; acknowledgement
	call TransmitByteThroughIR
	xor a
.close
	push af
	call CloseIRCommunications
	pop af
	ret
; 0x19865

; sends request for other device to close current communication
RequestCloseIRCommunication: ; 19865 (6:5865)
	call StartIRCommunications
	ld a, IRCMD_CLOSE
	ld [wIRDataBuffer + 1], a
	call TransmitIRDataBuffer
;	fallthrough

; calls CloseIRCommunications while perserving af
SafelyCloseIRCommunications: ; 19870 (6:5870)
	push af
	call CloseIRCommunications
	pop af
	ret
; 0x19876

; sends a request for data to be transmitted
; from the other device
; hl = start of data to request to transmit
; de = address to write data received
; c = length of data
RequestDataTransmissionThroughIR: ; 19876 (6:5876)
	ld a, IRCMD_TRANSMIT_DATA
	call TransmitRegistersThroughIR
	push de
	push bc
	call Func_1971e
	pop bc
	pop hl
	jr c, SafelyCloseIRCommunications
	call ReceiveNBytesToHLThroughIR
	jr SafelyCloseIRCommunications
; 0x19889

; transmits data to be written in the other device
; hl = start of data to transmit
; de = address for other device to write data
; c = length of data
RequestDataReceivalThroughIR: ; 19889 (6:5889)
	ld a, IRCMD_RECEIVE_DATA
	call TransmitRegistersThroughIR
	call TransmitNBytesFromHLThroughIR
	jr c, SafelyCloseIRCommunications
	call ReceiveByteThroughIR
	jr c, SafelyCloseIRCommunications
	add b
	jr nz, .asm_1989e
	xor a
	jr SafelyCloseIRCommunications
.asm_1989e
	call ReturnZFlagUnsetAndCarryFlagSet
	jr SafelyCloseIRCommunications
; 0x198a3

; first stores all the current registers in wIRDataBuffer
; then transmits it through IR
TransmitRegistersThroughIR: ; 198a3 (6:58a3)
	push hl
	push de
	push bc
	call StoreRegistersInIRDataBuffer
	call StartIRCommunications
	call TransmitIRDataBuffer
	pop bc
	pop de
	pop hl
	ret nc
	inc sp
	inc sp
	jr SafelyCloseIRCommunications
; 0x198b7

; stores af, hl, de and bc in wIRDataBuffer
StoreRegistersInIRDataBuffer: ; 198b7 (6:58b7)
	push de
	push hl
	push af
	ld hl, wIRDataBuffer
	pop de
	ld [hl], e ; <- f
	inc hl
	ld [hl], d ; <- a
	inc hl
	pop de
	ld [hl], e ; <- l
	inc hl
	ld [hl], d ; <- h
	inc hl
	pop de
	ld [hl], e ; <- e
	inc hl
	ld [hl], d ; <- d
	inc hl
	ld [hl], c ; <- c
	inc hl
	ld [hl], b ; <- b
	ret
; 0x198d0

; loads all the registers that were stored
; from StoreRegistersInIRDataBuffer
LoadRegistersFromIRDataBuffer: ; 198d0 (6:58d0)
	ld hl, wIRDataBuffer
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	pop af
	ret
; 0x198e7

; empties screen and replaces
; wVBlankFunctionTrampoline with HandleAllSpriteAnimations
Func_198e7: ; 198e7 (6:58e7)
	call EmptyScreen
	call Set_OBJ_8x8
	call Func_3ca4
	lb de, $38, $7f
	call SetupText
	ld hl, wVBlankFunctionTrampoline + 1
	ld de, wVBlankFunctionTrampolineBackup
	call BackupVBlankFunctionTrampoline
	di
	ld [hl], LOW(HandleAllSpriteAnimations)
	inc hl
	ld [hl], HIGH(HandleAllSpriteAnimations)
	ei
	ret
; 0x19907

; sets backup VBlank function as wVBlankFunctionTrampoline
RestoreVBlankFunction: ; 19907 (6:5907)
	ld hl, wVBlankFunctionTrampolineBackup
	ld de, wVBlankFunctionTrampoline + 1
	call BackupVBlankFunctionTrampoline
	call Func_3ca4
	bank1call ZeroObjectPositionsAndToggleOAMCopy
	ret
; 0x19917

; copies 2 bytes from hl to de while interrupts are disabled
; used to load or store wVBlankFunctionTrampoline
; to wVBlankFunctionTrampolineBackup
BackupVBlankFunctionTrampoline: ; 19917 (6:5917)
	di
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hld]
	ld [de], a
	ei
	ret
; 0x1991f

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
.loop_clear
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .loop_clear

	ld a, CHARMANDER_AND_FRIENDS_DECK
	ld hl, sSavedDeck1
	call Func_199e0
	ld a, SQUIRTLE_AND_FRIENDS_DECK
	ld hl, sSavedDeck2
	call Func_199e0
	ld a, BULBASAUR_AND_FRIENDS_DECK
	ld hl, sSavedDeck3
	call Func_199e0

	call EnableSRAM
	ld hl, sCardCollection
	ld a, CARD_NOT_OWNED
.loop_collection
	ld [hl], a
	inc l
	jr nz, .loop_collection

	ld hl, sCurrentDuel
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a

	ld hl, sCardPopNameList
	ld c, CARDPOP_NAME_LIST_MAX_ELEMS
.loop_card_pop_names
	ld [hl], $0
	ld de, NAME_BUFFER_LENGTH
	add hl, de
	dec c
	jr nz, .loop_card_pop_names

	ld a, 2
	ld [sPrinterContrastLevel], a
	ld a, $2
	ld [sTextSpeed], a
	ld [wTextSpeed], a
	xor a
	ld [sAnimationsDisabled], a
	ld [s0a009], a
	ld [s0a004], a
	ld [sTotalCardPopsDone], a
	ld [sReceivedLegendaryCards], a
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

; hl = text ID
LoadLinkConnectingScene: ; 19a1f (6:5a1f)
	push hl
	call Func_198e7
	ld a, SCENE_GAMEBOY_LINK_CONNECTING
	lb bc, 0, 0
	call LoadScene
	pop hl
	call DrawWideTextBox_PrintText
	call EnableLCD
	ret
; 0x19a33

; shows Link Not Connected scene
; then asks the player whether they want to try again
; if the player selectes "no", return carry
; input:
;  - hl = text ID
LoadLinkNotConnectedSceneAndAskWhetherToTryAgain: ; 19a33 (6:5a33)
	push hl
	call RestoreVBlankFunction
	call Func_198e7
	ld a, SCENE_GAMEBOY_LINK_NOT_CONNECTED
	lb bc, 0, 0
	call LoadScene
	pop hl
	call DrawWideTextBox_WaitForInput
	ldtx hl, WouldYouLikeToTryAgainText
	call YesOrNoMenuWithText_SetCursorToYes
;	fallthrough

ClearRPAndRestoreVBlankFunction: ; 19a4c (6:5a4c)
	push af
	call ClearRP
	call RestoreVBlankFunction
	pop af
	ret
; 0x19a55

; prepares IR communication parameter data
; a = a IRPARAM_* constant for the function of this connection
InitIRCommunications: ; 19a55 (6:5a55)
	ld hl, wOwnIRCommunicationParams
	ld [hl], a
	inc hl
	ld [hl], $50
	inc hl
	ld [hl], $4b
	inc hl
	ld [hl], $31
	ld a, $ff
	ld [wIRCommunicationErrorCode], a
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
; clear wNameBuffer and wOpponentName
	xor a
	ld [wNameBuffer], a
	ld hl, wOpponentName
	ld [hli], a
	ld [hl], a
; loads player's name from SRAM
; to wDefaultText
	call EnableSRAM
	ld hl, sPlayerName
	ld de, wDefaultText
	ld c, NAME_BUFFER_LENGTH
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	call DisableSRAM
	ret
; 0x19a89

; returns carry if communication was unsuccessful
; if a = 0, then it was a communication error
; if a = 1, then operation was cancelled by the player
PrepareSendCardOrDeckConfigurationThroughIR: ; 19a89 (6:5a89)
	call InitIRCommunications

; pressing A button triggers request for IR communication
.loop_frame
	call DoFrame
	ldh a, [hKeysPressed]
	bit B_BUTTON_F, a
	jr nz, .b_btn
	ldh a, [hKeysHeld]
	bit A_BUTTON_F, a
	jr z, .loop_frame
; a btn
	call TrySendIRRequest
	jr nc, .request_success
	or a
	jr z, .loop_frame
	xor a
	scf
	ret

.b_btn
	; cancelled by the player
	ld a, $01
	scf
	ret

.request_success
	call ExchangeIRCommunicationParameters
	ret c
	ld a, [wOtherIRCommunicationParams + 3]
	cp $31
	jr nz, SetIRCommunicationErrorCode_Error
	or a
	ret
; 0x19ab7

; exchanges player names and IR communication parameters
; checks whether parameters for communication match
; and if they don't, an error is issued
ExchangeIRCommunicationParameters: ; 19ab7 (6:5ab7)
	ld hl, wOwnIRCommunicationParams
	ld de, wOtherIRCommunicationParams
	ld c, 4
	call RequestDataTransmissionThroughIR
	jr c, .error
	ld hl, wOtherIRCommunicationParams + 1
	ld a, [hli]
	cp $50
	jr nz, .error
	ld a, [hli]
	cp $4b
	jr nz, .error
	ld a, [wOwnIRCommunicationParams]
	ld hl, wOtherIRCommunicationParams
	cp [hl] ; do parameters match?
	jr nz, SetIRCommunicationErrorCode_Error

; receives wDefaultText from other device
; and writes it to wNameBuffer
	ld hl, wDefaultText
	ld de, wNameBuffer
	ld c, NAME_BUFFER_LENGTH
	call RequestDataTransmissionThroughIR
	jr c, .error
; transmits wDefaultText to be
; written in wNameBuffer in the other device
	ld hl, wDefaultText
	ld de, wNameBuffer
	ld c, NAME_BUFFER_LENGTH
	call RequestDataReceivalThroughIR
	jr c, .error
	or a
	ret

.error
	xor a
	scf
	ret
; 0x19af9

SetIRCommunicationErrorCode_Error: ; 19af9 (6:5af9)
	ld hl, wIRCommunicationErrorCode
	ld [hl], $01
	ld de, wIRCommunicationErrorCode
	ld c, 1
	call RequestDataReceivalThroughIR
	call RequestCloseIRCommunication
	ld a, $01
	scf
	ret
; 0x19b0d

SetIRCommunicationErrorCode_NoError: ; 19b0d (6:5b0d)
	ld hl, wOwnIRCommunicationParams
	ld [hl], $00
	ld de, wIRCommunicationErrorCode
	ld c, 1
	call RequestDataReceivalThroughIR
	ret c
	call RequestCloseIRCommunication
	or a
	ret
; 0x19b20

; makes device receptive to receive data from other device
; to write in wDuelTempList (either list of cards or a deck configuration)
; returns carry if some error occured
TryReceiveCardOrDeckConfigurationThroughIR: ; 19b20 (6:5b20)
	call InitIRCommunications
.loop_receive_request
	xor a
	ld [wDuelTempList], a
	call TryReceiveIRRequest
	jr nc, .receive_data
	bit 1, a
	jr nz, .cancelled
	jr .loop_receive_request
.receive_data
	call ExecuteReceivedIRCommands
	ld a, [wIRCommunicationErrorCode]
	or a
	ret z ; no error
	xor a
	scf
	ret

.cancelled
	ld a, $01
	scf
	ret
; 0x19b41

; returns carry if card(s) wasn't successfully sent
_SendCard: ; 19b41 (6:5b41)
	call StopMusic
	ldtx hl, SendingACardText
	call LoadLinkConnectingScene
	ld a, IRPARAM_SEND_CARDS
	call PrepareSendCardOrDeckConfigurationThroughIR
	jr c, .fail

	; send cards
	xor a
	ld [wDuelTempList + DECK_SIZE], a
	ld hl, wDuelTempList
	ld e, l
	ld d, h
	ld c, DECK_SIZE + 1
	call RequestDataReceivalThroughIR
	jr c, .fail
	call SetIRCommunicationErrorCode_NoError
	jr c, .fail
	call ExecuteReceivedIRCommands
	jr c, .fail
	ld a, [wOwnIRCommunicationParams + 1]
	cp $4f
	jr nz, .fail
	call PlayCardPopSong
	xor a
	call ClearRPAndRestoreVBlankFunction
	ret

.fail
	call PlayCardPopSong
	ldtx hl, CardTransferWasntSuccessful1Text
	call LoadLinkNotConnectedSceneAndAskWhetherToTryAgain
	jr nc, _SendCard ; loop back and try again
	; failed
	scf
	ret
; 0x19b87

PlayCardPopSong: ; 19b87 (6:5b87)
	ld a, MUSIC_CARD_POP
	jp PlaySong
; 0x19b8c

_ReceiveCard: ; 19b8c (6:5b8c)
	call StopMusic
	ldtx hl, ReceivingACardText
	call LoadLinkConnectingScene
	ld a, IRPARAM_SEND_CARDS
	call TryReceiveCardOrDeckConfigurationThroughIR
	ld a, $4f
	ld [wOwnIRCommunicationParams + 1], a
	ld hl, wOwnIRCommunicationParams
	ld e, l
	ld d, h
	ld c, 4
	call RequestDataReceivalThroughIR
	jr c, .fail
	call RequestCloseIRCommunication
	jr c, .fail
	call PlayCardPopSong
	or a
	call ClearRPAndRestoreVBlankFunction
	ret

.fail
	call PlayCardPopSong
	ldtx hl, CardTransferWasntSuccessful2Text
	call LoadLinkNotConnectedSceneAndAskWhetherToTryAgain
	jr nc, _ReceiveCard
	scf
	ret
; 0x19bc5

_SendDeckConfiguration: ; 19bc5 (6:5bc5)
	call StopMusic
	ldtx hl, SendingADeckConfigurationText
	call LoadLinkConnectingScene
	ld a, IRPARAM_SEND_DECK
	call PrepareSendCardOrDeckConfigurationThroughIR
	jr c, .fail
	ld hl, wDuelTempList
	ld e, l
	ld d, h
	ld c, DECK_STRUCT_SIZE
	call RequestDataReceivalThroughIR
	jr c, .fail
	call SetIRCommunicationErrorCode_NoError
	jr c, .fail
	call PlayCardPopSong
	call ClearRPAndRestoreVBlankFunction
	or a
	ret

.fail
	call PlayCardPopSong
	ldtx hl, DeckConfigurationTransferWasntSuccessful1Text
	call LoadLinkNotConnectedSceneAndAskWhetherToTryAgain
	jr nc, _SendDeckConfiguration
	scf
	ret
; 0x19bfb

_ReceiveDeckConfiguration: ; 19bfb (6:5bfb)
	call StopMusic
	ldtx hl, ReceivingDeckConfigurationText
	call LoadLinkConnectingScene
	ld a, IRPARAM_SEND_DECK
	call TryReceiveCardOrDeckConfigurationThroughIR
	jr c, .fail
	call PlayCardPopSong
	call ClearRPAndRestoreVBlankFunction
	or a
	ret

.fail
	call PlayCardPopSong
	ldtx hl, DeckConfigurationTransferWasntSuccessful2Text
	call LoadLinkNotConnectedSceneAndAskWhetherToTryAgain
	jr nc, _ReceiveDeckConfiguration ; loop back and try again
	scf
	ret
; 0x19c20

_DoCardPop: ; 19c20 (6:5c20)
; loads scene for Card Pop! screen
; then checks if console is SGB
; and issues an error message in case it is
	call Func_198e7
	ld a,SCENE_CARD_POP
	lb bc, 0, 0
	call LoadScene
	ldtx hl, AreYouBothReadyToCardPopText
	call PrintScrollableText_NoTextBoxLabel
	call RestoreVBlankFunction
	ldtx hl, CardPopCannotBePlayedWithTheGameBoyText
	ld a, [wConsole]
	cp CONSOLE_SGB
	jr z, .error

; initiate the communications
	call PauseSong
	call Func_198e7
	ld a, SCENE_GAMEBOY_LINK_CONNECTING
	lb bc, 0, 0
	call LoadScene
	ldtx hl, PositionGameBoyColorsAndPressAButtonText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call HandleCardPopCommunications
	push af
	push hl
	call ClearRP
	call RestoreVBlankFunction
	pop hl
	pop af
	jr c, .error

; show the received card detail page
; and play the corresponding song
	ld a, [wLoadedCard1ID]
	call AddCardToCollectionAndUpdateAlbumProgress
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ld a, SFX_5D
	call PlaySFX
.wait_sfx
	call AssertSFXFinished
	or a
	jr nz, .wait_sfx
	ld a, [wCardPopCardObtainSong]
	call PlaySong
	ldtx hl, ReceivedThroughCardPopText
	bank1call _DisplayCardDetailScreen
	call ResumeSong
	lb de, $38, $9f
	call SetupText
	bank1call OpenCardPage_FromHand
	ret

.error
; show Card Pop! error scene
; and print text in hl
	push hl
	call ResumeSong
	call Func_198e7
	ld a, SCENE_CARD_POP_ERROR
	lb bc, 0, 0
	call LoadScene
	pop hl
	call PrintScrollableText_NoTextBoxLabel
	call RestoreVBlankFunction
	ret
; 0x19cb2

; handles all communications to the other device to do Card Pop!
; returns carry if Card Pop! is unsuccessful
; and returns in hl the corresponding error text ID
HandleCardPopCommunications: ; 19cb2 (6:5cb2)
; copy CardPopNameList from SRAM to WRAM
	call EnableSRAM
	ld hl, sCardPopNameList
	ld de, wCardPopNameList
	ld bc, CARDPOP_NAME_LIST_SIZE
	call CopyDataHLtoDE
	call DisableSRAM

	ld a, IRPARAM_CARD_POP
	call InitIRCommunications
.asm_19cc9
	call TryReceiveIRRequest ; receive request
	jr nc, .asm_19d05
	bit 1, a
	jr nz, .fail
	call TrySendIRRequest ; send request
	jr c, .asm_19cc9

; do the player name search, then transmit the result
	call ExchangeIRCommunicationParameters
	jr c, .fail
	ld hl, wCardPopNameList
	ld de, wOtherPlayerCardPopNameList
	ld c, 0 ; $100 bytes = CARDPOP_NAME_LIST_SIZE
	call RequestDataTransmissionThroughIR
	jr c, .fail
	call LookUpNameInCardPopNameList
	ld hl, wCardPopNameSearchResult
	ld de, wCardPopNameSearchResult
	ld c, 1
	call RequestDataReceivalThroughIR
	jr c, .fail
	call SetIRCommunicationErrorCode_NoError
	jr c, .fail
	call ExecuteReceivedIRCommands
	jr c, .fail
	jr .check_search_result

.asm_19d05
	call ExecuteReceivedIRCommands
	ld a, [wIRCommunicationErrorCode]
	or a
	jr nz, .fail
	call RequestCloseIRCommunication
	jr c, .fail

.check_search_result
	ld a, [wCardPopNameSearchResult]
	or a
	jr z, .success
	; not $00, means the name was found in the list
	ldtx hl, CannotCardPopWithFriendPreviouslyPoppedWithText
	scf
	ret

.success
	call DecideCardToReceiveFromCardPop

; increment number of times Card Pop! was done
; and write the other player's name to sCardPopNameList
; the spot where this is written in the list is derived
; from the lower nybble of sTotalCardPopsDone
; that means that after 16 Card Pop!, the older
; names start to get overwritten
	call EnableSRAM
	ld hl, sTotalCardPopsDone
	ld a, [hl]
	inc [hl]
	and $0f
	swap a ; *NAME_BUFFER_LENGTH
	ld l, a
	ld h, $0
	ld de, sCardPopNameList
	add hl, de
	ld de, wNameBuffer
	ld c, NAME_BUFFER_LENGTH
.loop_write_name
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop_write_name
	call DisableSRAM
	or a
	ret

.fail
	ldtx hl, ThePopWasntSuccessfulText
	scf
	ret
; 0x19d49

; looks up the name in wNameBuffer in wCardPopNameList
; used to know whether this save file has done Card Pop!
; with the other player already
; returns carry and wCardPopNameSearchResult = $ff if the name was found;
; returns no carry and wCardPopNameSearchResult = $00 otherwise
LookUpNameInCardPopNameList: ; 19d49 (6:5d49)
; searches for other player's name in this game's name list
	ld hl, wCardPopNameList
	ld c, CARDPOP_NAME_LIST_MAX_ELEMS
.loop_own_card_pop_name_list
	push hl
	ld de, wNameBuffer
	call .CompareNames
	pop hl
	jr nc, .found_name
	ld de, NAME_BUFFER_LENGTH
	add hl, de
	dec c
	jr nz, .loop_own_card_pop_name_list

; name was not found in wCardPopNameList

; searches for this player's name in the other game's name list
; this is useless since it discards the result from the name comparisons
; as a result this loop will always return no carry
	call EnableSRAM
	ld hl, wOtherPlayerCardPopNameList
	ld c, CARDPOP_NAME_LIST_MAX_ELEMS
.loop_other_card_pop_name_list
	push hl
	ld de, sPlayerName
	call .CompareNames ; discards result from comparison
	pop hl
	ld de, NAME_BUFFER_LENGTH
	add hl, de
	dec c
	jr nz, .loop_other_card_pop_name_list
	xor a
	jr .no_carry

.found_name
	ld a, $ff
	scf
.no_carry
	call DisableSRAM
	ld [wCardPopNameSearchResult], a ; $00 if name was not found, $ff otherwise
	ret

; compares names in hl and de
; if they are different, return carry
.CompareNames
	ld b, NAME_BUFFER_LENGTH
.loop_chars
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .not_same
	inc hl
	dec b
	jr nz, .loop_chars
	or a
	ret
.not_same
	scf
	ret
; 0x19d92

; loads in wLoadedCard1 a random card to be received
; this selection is done based on the rarity that is
; decided from the names of both participants
; the card will always be a Pokemon card that is not
; from a Promotional set, with the exception
; of Venusaur1 and Mew2
; output:
; - e = card ID chosen
DecideCardToReceiveFromCardPop: ; 19d92 (6:5d92)
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call EnableSRAM
	ld hl, sPlayerName
	call CalculateNameHash
	call DisableSRAM
	push de
	ld hl, wNameBuffer
	call CalculateNameHash
	pop bc

; de = other player's name  hash
; bc = this player's name hash

; updates RNG values to subtraction of these two hashes
	ld hl, wRNG1
	ld a, b
	sub d
	ld d, a ; b - d
	ld [hli], a ; wRNG1
	ld a, c
	sub e
	ld e, a ; c - e
	ld [hli], a ; wRNG2
	ld [hl], $0 ; wRNGCounter

; depending on the values obtained from the hashes,
; determine which rarity card to give to the player
; along with the song to play with each rarity
; the probabilites of each possibility can be calculated
; as follows (given 2 random player names):
; 101/256 ~ 39% for Circle
;  90/256 ~ 35% for Diamond
;  63/256 ~ 25% for Star
;   1/256 ~ .4% for Venusaur1 or Mew2
	ld a, e
	cp 5
	jr z, .venusaur1_or_mew2
	cp 64
	jr c, .star_rarity ; < 64
	cp 154
	jr c, .diamond_rarity ; < 154
	; >= 154

	ld a, MUSIC_BOOSTER_PACK
	ld b, CIRCLE
	jr .got_rarity
.diamond_rarity
	ld a, MUSIC_BOOSTER_PACK
	ld b, DIAMOND
	jr .got_rarity
.star_rarity
	ld a, MUSIC_MATCH_VICTORY
	ld b, STAR
.got_rarity
	ld [wCardPopCardObtainSong], a
	ld a, b
	call CreateCardPopCandidateList
	; shuffle candidates and pick first from list
	call ShuffleCards
	ld a, [hl]
	ld e, a
.got_card_id
	ld d, $0
	call LoadCardDataToBuffer1_FromCardID
	ld a, e
	ret

.venusaur1_or_mew2
; choose either Venusaur1 or Mew2
; depending on whether the lower
; bit of d is unset or set, respectively
	ld a, MUSIC_MEDAL
	ld [wCardPopCardObtainSong], a
	ld e, VENUSAUR1
	ld a, d
	and $1 ; get lower bit
	jr z, .got_card_id
	ld e, MEW2
	jr .got_card_id
; 0x19df7

; lists in wCardPopCardCandidates all cards that:
; - are Pokemon cards;
; - have the same rarity as input register a;
; - are not from Promotional set.
; input:
; - a = card rarity
; output:
; - a = number of candidates
CreateCardPopCandidateList: ; 19df7 (6:5df7)
	ld hl, wPlayerDeck
	push hl
	push de
	push bc
	ld b, a

	lb de, 0, GRASS_ENERGY
.loop_card_ids
	call LoadCardDataToBuffer1_FromCardID
	jr c, .count ; no more card IDs
	ld a, [wLoadedCard1Type]
	and TYPE_ENERGY
	jr nz, .next_card_id ; not Pokemon card
	ld a, [wLoadedCard1Rarity]
	cp b
	jr nz, .next_card_id ; not equal rarity
	ld a, [wLoadedCard1Set]
	and $f0
	cp PROMOTIONAL
	jr z, .next_card_id ; no promos
	ld [hl], e
	inc hl
.next_card_id
	inc de
	jr .loop_card_ids

; count all the cards that were listed
; and return it in a
.count
	ld [hl], $00 ; invalid card ID as end of list
	ld hl, wPlayerDeck
	ld c, -1
.loop_count
	inc c
	ld a, [hli]
	or a
	jr nz, .loop_count
	ld a, c
	pop bc
	pop de
	pop hl
	ret
; 0x19e32

; creates a unique two-byte hash from the name given in hl
; the low byte is calculated by simply adding up all characters
; the high byte is calculated by xoring all characters together
; input:
; - hl = points to the start of the name buffer
; output:
; - de = hash
CalculateNameHash: ; 19e32 (6:5e32)
	ld c, NAME_BUFFER_LENGTH
	ld de, $0
.loop
	ld a, e
	add [hl]
	ld e, a
	ld a, d
	xor [hl]
	ld d, a
	inc hl
	dec c
	jr nz, .loop
	ret
; 0x19e42

; sends serial data to printer
; if there's an error in connection,
; show Printer Not Connected scene with error message
_PreparePrinterConnection: ; 19e42 (6:5e42)
	ld bc, $0
	lb de, PRINTERPKT_DATA, $0
	call SendPrinterPacket
	ret nc ; return if no error

	ld hl, wPrinterStatus
	ld a, [hl]
	or a
	jr nz, .asm_19e55
	ld [hl], $ff
.asm_19e55
	ld a, [hl]
	cp $ff
	jr z, ShowPrinterIsNotConnected
;	falltrough

; shows message on screen depending on wPrinterStatus
; also shows SCENE_GAMEBOY_PRINTER_NOT_CONNECTED.
HandlePrinterError: ; 19e5a (6:5e5a)
	ld a, [wPrinterStatus]
	cp $ff
	jr z, .cable_or_printer_switch
	or a
	jr z, .interrupted
	bit PRINTER_ERROR_BATTERIES_LOST_CHARGE, a
	jr nz, .batteries_lost_charge
	bit PRINTER_ERROR_CABLE_PRINTER_SWITCH, a
	jr nz, .cable_or_printer_switch
	bit PRINTER_ERROR_PAPER_JAMMED, a
	jr nz, .jammed_printer

	ldtx hl, PrinterPacketErrorText
	ld a, $04
	jr ShowPrinterConnectionErrorScene
.cable_or_printer_switch
	ldtx hl, CheckCableOrPrinterSwitchText
	ld a, $02
	jr ShowPrinterConnectionErrorScene
.jammed_printer
	ldtx hl, PrinterPaperIsJammedText
	ld a, $03
	jr ShowPrinterConnectionErrorScene
.batteries_lost_charge
	ldtx hl, BatteriesHaveLostTheirChargeText
	ld a, $01
	jr ShowPrinterConnectionErrorScene
.interrupted
	ldtx hl, PrintingWasInterruptedText
	call DrawWideTextBox_WaitForInput
	scf
	ret

ShowPrinterIsNotConnected: ; 19e94 (6:5e94)
	ldtx hl, PrinterIsNotConnectedText
	ld a, $02
;	fallthrough

; a = error code
; hl = text ID to print in text box
ShowPrinterConnectionErrorScene: ; 19e99 (6:5e99)
	push hl
	; unnecessary loading TxRam, since the text data
	; already incorporate the error number
	ld l, a
	ld h, $00
	call LoadTxRam3

	call Func_198e7
	ld a, SCENE_GAMEBOY_PRINTER_NOT_CONNECTED
	lb bc, 0, 0
	call LoadScene
	pop hl
	call DrawWideTextBox_WaitForInput
	call RestoreVBlankFunction
	scf
	ret
; 0x19eb4

; main card printer function
Func_19eb4: ; 19eb4 (6:5eb4)
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer1_FromCardID
	call Func_198e7
	ld a, SCENE_GAMEBOY_PRINTER_TRANSMITTING
	lb bc, 0, 0
	call LoadScene
	ld a, 20
	call CopyCardNameAndLevel
	ld [hl], TX_END
	ld hl, $0
	call LoadTxRam2
	ldtx hl, NowPrintingText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call PrepareForPrinterCommunications
	call DrawTopCardInfoInSRAMGfxBuffer0
	call Func_19f87
	call DrawCardPicInSRAMGfxBuffer2
	call Func_19f99
	jr c, .error
	call DrawBottomCardInfoInSRAMGfxBuffer0
	call Func_1a011
	jr c, .error
	call RestoreVBlankFunction
	call ResetPrinterCommunicationSettings
	or a
	ret
.error
	call RestoreVBlankFunction
	call ResetPrinterCommunicationSettings
	jp HandlePrinterError
; 0x19f05

DrawCardPicInSRAMGfxBuffer2: ; 19f05 (6:5f05)
	ld hl, wLoadedCard1Gfx
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, sGfxBuffer2
	call Func_37a5
	; draw card's picture in sGfxBuffer2
	ld a, $40
	lb hl, 12,  1
	lb de,  2, 68
	lb bc, 16, 12
	call FillRectangle
	ret
; 0x19f20

; writes the tiles necessary to draw
; the card's information in sGfxBuffer0
; this includes card's type, lv, HP and attacks if Pokemon card
; or otherwise just the card's name and type symbol
DrawTopCardInfoInSRAMGfxBuffer0: ; 19f20 (6:5f20)
	call Func_1a025
	call Func_212f

	; draw empty text box frame
	ld hl, sGfxBuffer0
	ld a, $34
	lb de, $30, $31
	ld b, 20
	call CopyLine
	ld c, 15
.loop_lines
	xor a ; SYM_SPACE
	lb de, $36, $37
	ld b, 20
	call CopyLine
	dec c
	jr nz, .loop_lines

	; draw card type symbol
	ld a, $38
	lb hl, 1,  2
	lb de, 1, 65
	lb bc, 2,  2
	call FillRectangle
	; print card's name
	lb de, 4, 65
	ld hl, wLoadedCard1Name
	call InitTextPrinting_ProcessTextFromPointerToID

; prints card's type, lv, HP and attacks if it's a Pokemon card
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .skip_pokemon_data
	inc a ; symbol corresponding to card's type (color)
	lb bc, 18, 65
	call WriteByteToBGMap0
	ld a, SYM_Lv
	lb bc, 11, 66
	call WriteByteToBGMap0
	ld a, [wLoadedCard1Level]
	lb bc, 12, 66
	bank1call WriteTwoDigitNumberInTxSymbolFormat
	ld a, SYM_HP
	lb bc, 15, 66
	call WriteByteToBGMap0
	ld a, [wLoadedCard1EffectCommands]
	inc b
	bank1call WriteTwoByteNumberInTxSymbolFormat
.skip_pokemon_data
	ret
; 0x19f87

Func_19f87: ; 19f87 (6:5f87)
	call TryInitPrinterCommunications
	ret c
	ld hl, sGfxBuffer0
	call Func_1a0cc
	ret c
	call Func_1a0cc
	call Func_1a111
	ret
; 0x19f99

Func_19f99: ; 19f99 (6:5f99)
	call TryInitPrinterCommunications
	ret c
	ld hl, sGfxBuffer0 + $8 tiles
	ld c, $06
.asm_19fa2
	call Func_1a0cc
	ret c
	dec c
	jr nz, .asm_19fa2
	call Func_1a111
	ret
; 0x19fad

; writes the tiles necessary to draw
; the card's information in sGfxBuffer0
; this includes card's Retreat cost, Weakness, Resistance,
; and attack if it's Pokemon card
; or otherwise just the card's description.
DrawBottomCardInfoInSRAMGfxBuffer0: ; 19fad (6:5fad)
	call Func_1a025
	xor a
	ld [wCardPageType], a
	ld hl, sGfxBuffer0
	ld b, 20
	ld c, 9
.loop_lines
	xor a ; SYM_SPACE
	lb de, $36, $37
	call CopyLine
	dec c
	jr nz, .loop_lines
	ld a, $35
	lb de, $32, $33
	call CopyLine

	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .not_pkmn_card
	ld hl, RetreatWeakResistData
	call PlaceTextItems
	ld c, 66
	bank1call DisplayCardPage_PokemonOverview.attacks
	ld a, SYM_No
	lb bc, 15, 72
	call WriteByteToBGMap0
	inc b
	ld a, [wLoadedCard1PokedexNumber]
	bank1call WriteTwoByteNumberInTxSymbolFormat
	ret

.not_pkmn_card
	bank1call SetNoLineSeparation
	lb de, 1, 66
	ld a, SYM_No
	call InitTextPrintingInTextbox
	ld hl, wLoadedCard1NonPokemonDescription
	call ProcessTextFromPointerToID
	bank1call SetOneLineSeparation
	ret
; 0x1a004

RetreatWeakResistData: ; 1a004 (6:6004)
	textitem 1, 70, RetreatText
	textitem 1, 71, WeaknessText
	textitem 1, 72, ResistanceText
	db $ff
; 0x1a011

Func_1a011: ; 1a011 (6:6011)
	call TryInitPrinterCommunications
	ret c
	ld hl, sGfxBuffer0
	ld c, $05
.asm_1a01a
	call Func_1a0cc
	ret c
	dec c
	jr nz, .asm_1a01a
	call Func_1a108
	ret
; 0x1a025

; calls setup text and sets wTilePatternSelector
Func_1a025: ; 1a025 (6:6025)
	lb de, $40, $bf
	call SetupText
	ld a, $a4
	ld [wTilePatternSelector], a
	xor a
	ld [wTilePatternSelectorCorrection], a
	ret
; 0x1a035

; switches to CGB normal speed, resets serial
; enables SRAM and switches to SRAM1
; and clears sGfxBuffer0
PrepareForPrinterCommunications: ; 1a035 (6:6035)
	call SwitchToCGBNormalSpeed
	call ResetSerial
	ld a, $10
	ld [wce9b], a
	call EnableSRAM
	ld a, [sPrinterContrastLevel]
	ld [wPrinterContrastLevel], a
	call DisableSRAM
	ldh a, [hBankSRAM]
	ld [wce8f], a
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	call EnableSRAM
;	fallthrough

ClearPrinterGfxBuffer: ; 1a035 (6:6035)
	ld hl, sGfxBuffer0
	ld bc, $400
.loop
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .loop
	xor a
	ld [wce9f], a
	ret
; 0x1a06b

; reverts settings changed by PrepareForPrinterCommunications
ResetPrinterCommunicationSettings: ; 1a06b (6:606b)
	push af
	call SwitchToCGBDoubleSpeed
	ld a, [wce8f]
	call BankswitchSRAM
	call DisableSRAM
	lb de, $30, $bf
	call SetupText
	pop af
	ret
; 0x1a080

; unreferenced
; send some bytes through serial
Func_1a080: ; 1a080 (6:6080)
	ld bc, $0
	lb de, PRINTERPKT_NUL, $0
	jp SendPrinterPacket
; 0x1a089

; tries initiating the communications for
; sending data to printer
; returns carry if operation was cancelled
; by pressing B button or serial transfer took long
TryInitPrinterCommunications: ; 1a089 (6:6089)
	xor a
	ld [wPrinterInitAttempts], a
.wait_input
	call DoFrame
	ldh a, [hKeysHeld]
	and B_BUTTON
	jr nz, .b_button
	ld bc, $0
	lb de, PRINTERPKT_NUL, $0
	call SendPrinterPacket
	jr c, .delay
	and (1 << PRINTER_STATUS_BUSY) | (1 << PRINTER_STATUS_PRINTING)
	jr nz, .wait_input

.init
	ld bc, $0
	lb de, PRINTERPKT_INIT, $0
	call SendPrinterPacket
	jr nc, .no_carry
	ld hl, wPrinterInitAttempts
	inc [hl]
	ld a, [hl]
	cp 3
	jr c, .wait_input
	; time out
	scf
	ret
.no_carry
	ret

.b_button
	xor a
	ld [wPrinterStatus], a
	scf
	ret

.delay
	ld c, 10
.delay_loop
	call DoFrame
	dec c
	jr nz, .delay_loop
	jr .init
; 0x1a0cc

; loads tiles given by map in hl to sGfxBuffer5
; copies first 20 tiles, then offsets by 2 tiles
; and copies another 20
Func_1a0cc: ; 1a0cc (6:60cc)
	push bc
	ld de, sGfxBuffer5
	call .Copy20Tiles
	call .Copy20Tiles
	push hl
	call CompressDataForPrinterSerialTransfer
	call SendPrinterPacket
	pop hl
	pop bc
	ret

; copies 20 tiles given by hl to de
; then adds 2 tiles to hl
.Copy20Tiles ; 1a0e0 (6:60e0)
	push hl
	ld c, 20
.loop_tiles
	ld a, [hli]
	call .CopyTile
	dec c
	jr nz, .loop_tiles
	pop hl
	ld bc, 2 tiles
	add hl, bc
	ret

; copies a tile to de
; a = tile to get from sGfxBuffer1
.CopyTile ; 1a0f0 (6:60f0)
	push hl
	push bc
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *TILE_SIZE
	ld bc, sGfxBuffer1
	add hl, bc
	ld c, TILE_SIZE
.loop_copy
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop_copy
	pop bc
	pop hl
	ret
; 0x1a108

Func_1a108: ; 1a108 (6:6108)
	call GetPrinterContrastSerialData
	push hl
	lb hl, $3, $1
	jr SendPrinterInstructionPacket

Func_1a111: ; 1a111 (6:6111)
	call GetPrinterContrastSerialData
	push hl
	ld hl, wce9b
	ld a, [hl]
	ld [hl], $00
	ld h, a
	ld l, $01
;	fallthrough

SendPrinterInstructionPacket: ; 1a11e (6:611e)
	push hl
	ld bc, $0
	lb de, PRINTERPKT_DATA, $0
	call SendPrinterPacket
	jr c, .asm_1a135
	ld hl, sp+$00 ; contrast level bytes
	ld bc, $4 ; instruction packets are 4 bytes in size
	lb de, PRINTERPKT_PRINT_INSTRUCTION, $0
	call SendPrinterPacket
.asm_1a135
	pop hl
	pop hl
	ret

; returns in h and l the bytes
; to be sent through serial to the printer
; for the set contrast level
GetPrinterContrastSerialData: ; 1a138 (6:6138)
	ld a, [wPrinterContrastLevel]
	ld e, a
	ld d, $00
	ld hl, .contrast_level_data
	add hl, de
	ld h, [hl]
	ld l, $e4
	ret

.contrast_level_data
	db $00, $20, $40, $60, $7f
; 0x1a14b

; unreferenced
Func_1a14b: ; 1a14b (6:614b)
	ld a, $01
	jr .asm_1a15d
	ld a, $02
	jr .asm_1a15d
	ld a, $03
	jr .asm_1a15d
	ld a, $04
	jr .asm_1a15d
	ld a, $05
.asm_1a15d
	ld [wce9d], a
	scf
	ret
; 0x1a162

; a = saved deck index to print
_PrintDeckConfiguration: ; 1a162 (6:6162)
; copies selected deck from SRAM to wDuelTempList
	call EnableSRAM
	ld l, a
	ld h, DECK_STRUCT_SIZE
	call HtimesL
	ld de, sSavedDeck1
	add hl, de
	ld de, wDuelTempList
	ld bc, DECK_STRUCT_SIZE
	call CopyDataHLtoDE
	call DisableSRAM

	call ShowPrinterTransmitting
	call PrepareForPrinterCommunications
	call Func_1a025
	call Func_212f
	lb de, 0, 64
	lb bc, 20, 4
	call DrawRegularTextBoxDMG
	lb de, 4, 66
	call InitTextPrinting
	ld hl, wDuelTempList ; print deck name
	call ProcessText
	ldtx hl, DeckPrinterText
	call ProcessTextFromID

	ld a, 5
	ld [wPrinterHorizontalOffset], a
	ld hl, wPrinterTotalCardCount
	xor a
	ld [hli], a
	ld [hl], a
	ld [wPrintOnlyStarRarity], a

	ld hl, wCurDeckCards
.loop_cards
	ld a, [hl]
	or a
	jr z, .asm_1a1d6
	ld e, a
	ld d, $00
	call LoadCardDataToBuffer1_FromCardID

	; find out this card's count
	ld a, [hli]
	ld b, a
	ld c, 1
.loop_card_count
	cp [hl]
	jr nz, .got_card_count
	inc hl
	inc c
	jr .loop_card_count

.got_card_count
	ld a, c
	ld [wPrinterCardCount], a
	call LoadCardInfoForPrinter
	call AddToPrinterGfxBuffer
	jr c, .printer_error
	jr .loop_cards

.asm_1a1d6
	call SendCardListToPrinter
	jr c, .printer_error
	call ResetPrinterCommunicationSettings
	call RestoreVBlankFunction
	or a
	ret

.printer_error
	call ResetPrinterCommunicationSettings
	call RestoreVBlankFunction
	jp HandlePrinterError
; 0x1a1ec

SendCardListToPrinter: ; 1a1ec (6:61ec)
	ld a, [wPrinterHorizontalOffset]
	cp 1
	jr z, .skip_load_gfx
	call LoadGfxBufferForPrinter
	ret c
.skip_load_gfx
	call TryInitPrinterCommunications
	ret c
	call Func_1a108
	ret
; 0z1a1ff

; increases printer horizontal offset by 2
AddToPrinterGfxBuffer: ; 1a1ff (6:61ff)
	push hl
	ld hl, wPrinterHorizontalOffset
	inc [hl]
	inc [hl]
	ld a, [hl]
	pop hl
	; return no carry if below 18
	cp 18
	ccf
	ret nc
	; >= 18
;	fallthrough

; copies Gfx to Gfx buffer and sends some serial data
; returns carry set if unsuccessful
LoadGfxBufferForPrinter: ; 1a20b (6:620b)
	push hl
	call TryInitPrinterCommunications
	jr c, .set_carry
	ld a, [wPrinterHorizontalOffset]
	srl a
	ld c, a
	ld hl, sGfxBuffer0
.loop_gfx_buffer
	call Func_1a0cc
	jr c, .set_carry
	dec c
	jr nz, .loop_gfx_buffer
	call Func_1a111
	jr c, .set_carry

	call ClearPrinterGfxBuffer
	ld a, 1
	ld [wPrinterHorizontalOffset], a
	pop hl
	or a
	ret

.set_carry
	pop hl
	scf
	ret

; load symbol, name, level and card count to buffer
LoadCardInfoForPrinter: ; 1a235 (6:6235)
	push hl
	ld a, [wPrinterHorizontalOffset]
	or %1000000
	ld e, a
	ld d, 3
	ld a, [wPrintOnlyStarRarity]
	or a
	jr nz, .skip_card_symbol
	ld hl, wPrinterTotalCardCount
	ld a, [hli]
	or [hl]
	call z, DrawCardSymbol
.skip_card_symbol
	ld a, 14
	call CopyCardNameAndLevel
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ld a, [wPrinterHorizontalOffset]
	or %1000000
	ld c, a
	ld b, 16
	ld a, SYM_CROSS
	call WriteByteToBGMap0
	inc b
	ld a, [wPrinterCardCount]
	bank1call WriteTwoDigitNumberInTxSymbolFormat
	pop hl
	ret
; 0x1a270

_PrintCardList: ; 1a270 (6:6270)
; if Select button is held when printing card list
; only print cards with Star rarity (excluding Promotional cards)
; even if it's not marked as seen in the collection
	ld e, FALSE
	ldh a, [hKeysHeld]
	and SELECT
	jr z, .no_select
	inc e ; TRUE
.no_select
	ld a, e
	ld [wPrintOnlyStarRarity], a

	call ShowPrinterTransmitting
	call CreateTempCardCollection
	ld de, wDefaultText
	call CopyPlayerName
	call PrepareForPrinterCommunications
	call Func_1a025
	call Func_212f

	lb de, 0, 64
	lb bc, 20, 4
	call DrawRegularTextBoxDMG
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	lb de, 2, 66
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ldtx hl, AllCardsOwnedText
	call ProcessTextFromID
	ld a, [wPrintOnlyStarRarity]
	or a
	jr z, .asm_1a2c2
	ld a, TX_HALF2FULL
	call ProcessSpecialTextCharacter
	lb de, 3, 84
	call Func_22ca
.asm_1a2c2
	ld a, $ff
	ld [wCurPrinterCardType], a
	xor a
	ld hl, wPrinterTotalCardCount
	ld [hli], a
	ld [hl], a
	ld [wPrinterNumCardTypes], a
	ld a, 5
	ld [wPrinterHorizontalOffset], a

	ld e, GRASS_ENERGY
.loop_cards
	push de
	ld d, $00
	call LoadCardDataToBuffer1_FromCardID
	jr c, .done_card_loop
	ld d, HIGH(wTempCardCollection)
	ld a, [de] ; card ID count in collection
	ld [wPrinterCardCount], a
	call .LoadCardTypeEntry
	jr c, .printer_error_pop_de

	ld a, [wPrintOnlyStarRarity]
	or a
	jr z, .all_owned_cards_mode
	ld a, [wLoadedCard1Set]
	and %11110000
	cp PROMOTIONAL
	jr z, .next_card
	ld a, [wLoadedCard1Rarity]
	cp STAR
	jr nz, .next_card
	; not Promotional, and Star rarity
	ld hl, wPrinterCardCount
	res CARD_NOT_OWNED_F, [hl]
	jr .got_card_count

.all_owned_cards_mode
	ld a, [wPrinterCardCount]
	or a
	jr z, .next_card
	cp CARD_NOT_OWNED
	jr z, .next_card ; ignore not owned cards

.got_card_count
	ld a, [wPrinterCardCount]
	and CARD_COUNT_MASK
	ld c, a

	; add to total card count
	ld hl, wPrinterTotalCardCount
	add [hl]
	ld [hli], a
	ld a, 0
	adc [hl]
	ld [hl], a

	; add to current card type count
	ld hl, wPrinterCurCardTypeCount
	ld a, c
	add [hl]
	ld [hli], a
	ld a, 0
	adc [hl]
	ld [hl], a

	ld hl, wPrinterNumCardTypes
	inc [hl]
	ld hl, wce98
	inc [hl]
	call LoadCardInfoForPrinter
	call AddToPrinterGfxBuffer
	jr c, .printer_error_pop_de
.next_card
	pop de
	inc e
	jr .loop_cards

.printer_error_pop_de
	pop de
.printer_error
	call ResetPrinterCommunicationSettings
	call RestoreVBlankFunction
	jp HandlePrinterError

.done_card_loop
	pop de
	; add separator line
	ld a, [wPrinterHorizontalOffset]
	dec a
	or $40
	ld c, a
	ld b, 0
	call BCCoordToBGMap0Address
	ld a, $35
	lb de, $35, $35
	ld b, 20
	call CopyLine
	call AddToPrinterGfxBuffer
	jr c, .printer_error

	ld hl, wPrinterTotalCardCount
	ld c, [hl]
	inc hl
	ld b, [hl]
	ldtx hl, TotalNumberOfCardsText
	call .PrintTextWithNumber
	jr c, .printer_error
	ld a, [wPrintOnlyStarRarity]
	or a
	jr nz, .done
	ld a, [wPrinterNumCardTypes]
	ld c, a
	ld b, 0
	ldtx hl, TypesOfCardsText
	call .PrintTextWithNumber
	jr c, .printer_error

.done
	call SendCardListToPrinter
	jr c, .printer_error
	call ResetPrinterCommunicationSettings
	call RestoreVBlankFunction
	or a
	ret

; prints text ID given in hl
; with decimal representation of
; the number given in bc
; hl = text ID
; bc = number
.PrintTextWithNumber
	push bc
	ld a, [wPrinterHorizontalOffset]
	dec a
	or $40
	ld e, a
	ld d, 2
	call InitTextPrinting
	call ProcessTextFromID
	ld d, 14
	call InitTextPrinting
	pop hl
	call TwoByteNumberToTxSymbol_TrimLeadingZeros
	ld hl, wStringBuffer
	call ProcessText
	call AddToPrinterGfxBuffer
	ret

; loads this card's type icon and text
; if it's a new card type that hasn't been printed yet
.LoadCardTypeEntry
	ld a, [wLoadedCard1Type]
	ld c, a
	cp TYPE_ENERGY
	jr c, .got_type ; jump if Pokemon card
	ld c, $08
	cp TYPE_TRAINER
	jr nc, .got_type ; jump if Trainer card
	ld c, $07
.got_type
	ld hl, wCurPrinterCardType
	ld a, [hl]
	cp c
	ret z ; already handled this card type

	; show corresponding icon and text
	; for this new card type
	ld a, c
	ld [hl], a ; set it as current card type
	add a
	add c ; *3
	ld c, a
	ld b, $00
	ld hl, .IconTextList
	add hl, bc
	ld a, [wPrinterHorizontalOffset]
	dec a
	or %1000000
	ld e, a
	ld d, 1
	ld a, [hli]
	push hl
	lb bc, 2, 2
	lb hl, 1, 2
	call FillRectangle
	pop hl
	ld d, 3
	inc e
	call InitTextPrinting
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID

	call AddToPrinterGfxBuffer
	ld hl, wPrinterCurCardTypeCount
	xor a
	ld [hli], a
	ld [hl], a
	ld [wce98], a
	ret

.IconTextList
	; Fire
	db $e0 ; icon tile
	tx FirePokemonText

	; Grass
	db $e4 ; icon tile
	tx GrassPokemonText

	; Lightning
	db $e8 ; icon tile
	tx LightningPokemonText

	; Water
	db $ec ; icon tile
	tx WaterPokemonText

	; Fighting
	db $f0 ; icon tile
	tx FightingPokemonText

	; Psychic
	db $f4 ; icon tile
	tx PsychicPokemonText

	; Colorless
	db $f8 ; icon tile
	tx ColorlessPokemonText

	; Energy
	db $fc ; icon tile
	tx EnergyCardText

	; Trainer
	db $dc ; icon tile
	tx TrainerCardText
; 0x1a420

ShowPrinterTransmitting: ; 1a420 (6:6420)
	call Func_198e7
	ld a, SCENE_GAMEBOY_PRINTER_TRANSMITTING
	lb bc, 0, 0
	call LoadScene
	ldtx hl, NowPrintingPleaseWaitText
	call DrawWideTextBox_PrintText
	call EnableLCD
	ret
; 0x1a435

; compresses $28 tiles in sGfxBuffer5
; and writes it in sGfxBuffer5 + $28 tiles.
; compressed data has 2 commands to instruct on how to decompress it.
; - a command byte with bit 7 not set, means to copy that many + 1
; bytes that are following it literally.
; - a command byte with bit 7 set, means to copy the following byte
; that many times + 2 (after masking the top bit of command byte).
; returns in bc the size of the compressed data and
; in de the packet type data.
CompressDataForPrinterSerialTransfer: ; 1a435 (6:6435)
	ld hl, sGfxBuffer5
	ld de, sGfxBuffer5 + $28 tiles
	ld bc, $28 tiles
.loop_remaining_data
	ld a, $ff
	inc b
	dec b
	jr nz, .check_compression
	ld a, c
.check_compression
	push bc
	push de
	ld c, a
	call CheckDataCompression
	ld a, e
	ld c, e
	pop de
	jr c, .copy_byte
	ld a, c
	ld b, c
	dec a
	ld [de], a ; number of bytes to  copy literally - 1
	inc de
.copy_literal_sequence
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_literal_sequence
	ld c, b
	jr .sub_added_bytes

.copy_byte
	ld a, c
	dec a
	dec a
	or %10000000 ; set high bit
	ld [de], a ; = (n times to copy - 2) | %10000000
	inc de
	ld a, [hl] ; byte to copy n times
	ld [de], a
	inc de
	ld b, $0
	add hl, bc

.sub_added_bytes
	ld a, c
	cpl
	inc a
	pop bc
	add c
	ld c, a
	ld a, $ff
	adc b
	ld b, a
	or c
	jr nz, .loop_remaining_data

	ld hl, $10000 - (sGfxBuffer5 + $28 tiles)
	add hl, de ; gets the size of the compressed data
	ld c, l
	ld b, h
	ld hl, sGfxBuffer5 + $28 tiles
	lb de, PRINTERPKT_DATA, $1
	ret
; 0x1a485

; checks whether the next byte sequence in hl, up to c bytes, can be compressed
; returns carry if the next sequence of bytes can be compressed,
; i.e. has at least 3 consecutive bytes with the same value.
; in that case, returns in e the number of consecutive
; same value bytes that were found.
; if there are no bytes with same value, then count as many bytes left
; as possible until either there are no more remaining data bytes,
; or until a sequence of 3 bytes with the same value are found.
; in that case, the number of bytes in this sequence is returned in e.
CheckDataCompression: ; 1a485 (6:6485)
	push hl
	ld e, c
	ld a, c
; if number of remaining bytes is less than 4
; then no point in compressing
	cp 4
	jr c, .no_carry

; check first if there are at least
; 3 consecutive bytes with the same value
	ld b, c
	ld a, [hli]
	cp [hl]
	inc hl
	jr nz, .literal_copy ; not same
	cp [hl]
	inc hl
	jr nz, .literal_copy ; not same

; 3 consecutive bytes were found with same value
; keep track of how many consecutive bytes
; with the same value there are in e
	dec c
	dec c
	dec c
	ld e, 3
.loop_same_value
	cp [hl]
	jr nz, .set_carry ; exit when a different byte is found
	inc hl
	inc e
	dec c
	jr z, .set_carry ; exit when there is no more remaining data
	bit 5, e
	; exit if number of consecutive bytes >= $20
	jr z, .loop_same_value
.set_carry
	pop hl
	scf
	ret

.literal_copy
; consecutive bytes are not the same value
; count the number of bytes there are left
; until a sequence of 3 bytes with the same value is found
	pop hl
	push hl
	ld c, b ; number of remaining bytes
	ld e, 1
	ld a, [hli]
	dec c
	jr z, .no_carry ; exit if no more data
.reset_same_value_count
	ld d, 2 ; number of consecutive same value bytes to exit
.next_byte
	inc e
	dec c
	jr z, .no_carry
	bit 7, e
	jr nz, .no_carry ; exit if >= $80
	cp [hl]
	jr z, .same_consecutive_value
	ld a, [hli]
	jr .reset_same_value_count
.no_carry
	pop hl
	or a
	ret

.same_consecutive_value
	inc hl
	dec d
	jr nz, .next_byte
	; 3 consecutive bytes with same value found
	; discard the last 3 bytes in the sequence
	dec e
	dec e
	dec e
	jr .no_carry
; 0x1a4cf

; sets up to start a link duel
; decides which device will pick the number of prizes
; then exchanges names and duels between the players
; and starts the main duel routine
_SetUpAndStartLinkDuel: ; 1a4cf (6:64cf)
	ld hl, sp+$00
	ld a, l
	ld [wDuelReturnAddress + 0], a
	ld a, h
	ld [wDuelReturnAddress + 1], a
	call Func_198e7

	ld a, SCENE_GAMEBOY_LINK_TRANSMITTING
	lb bc, 0, 0
	call LoadScene

	bank1call LoadPlayerDeck
	call SwitchToCGBNormalSpeed
	bank1call DecideLinkDuelVariables
	push af
	call RestoreVBlankFunction
	pop af
	jp c, .error

	ld a, DUELIST_TYPE_PLAYER
	ld [wPlayerDuelistType], a
	ld a, DUELIST_TYPE_LINK_OPP
	ld [wOpponentDuelistType], a
	ld a, DUELTYPE_LINK
	ld [wDuelType], a

	call EmptyScreen
	ld a, [wSerialOp]
	cp $29
	jr nz, .asm_1a540

	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call .ExchangeNamesAndDecks
	jr c, .error
	lb de, 6, 2
	lb bc, 8, 6
	call DrawRegularTextBox
	lb de, 7, 4
	call InitTextPrinting
	ldtx hl, PrizesCardsText
	call ProcessTextFromID
	ldtx hl, ChooseTheNumberOfPrizesText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call .PickNumberOfPrizeCards
	ld a, [wNPCDuelPrizes]
	call SerialSend8Bytes
	jr .prizes_decided

.asm_1a540
	ld a, OPPONENT_TURN
	ldh [hWhoseTurn], a
	call .ExchangeNamesAndDecks
	jr c, .error
	ldtx hl, PleaseWaitDecidingNumberOfPrizesText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call SerialRecv8Bytes
	ld [wNPCDuelPrizes], a

.prizes_decided
	call ExchangeRNG
	ld a, LINK_OPP_PIC
	ld [wOpponentPortrait], a
	ldh a, [hWhoseTurn]
	push af
	call EmptyScreen
	bank1call SetDefaultPalettes
	ld a, SHUFFLE_DECK
	ld [wDuelDisplayedScreen], a
	bank1call DrawDuelistPortraitsAndNames
	ld a, OPPONENT_TURN
	ldh [hWhoseTurn], a
	ld a, [wNPCDuelPrizes]
	ld l, a
	ld h, $00
	call LoadTxRam3
	ldtx hl, BeginAPrizeDuelWithText
	call DrawWideTextBox_WaitForInput
	pop af
	ldh [hWhoseTurn], a
	call ExchangeRNG
	bank1call StartDuel_VSLinkOpp
	call SwitchToCGBDoubleSpeed
	ret

.error
	ld a, -1
	ld [wDuelResult], a
	call Func_198e7

	ld a, SCENE_GAMEBOY_LINK_NOT_CONNECTED
	lb bc, 0, 0
	call LoadScene

	ldtx hl, TransmissionErrorText
	call DrawWideTextBox_WaitForInput
	call RestoreVBlankFunction
	call ResetSerial
	ret

.ExchangeNamesAndDecks
	ld de, wDefaultText
	push de
	call CopyPlayerName
	pop hl
	ld de, wNameBuffer
	ld c, NAME_BUFFER_LENGTH
	call SerialExchangeBytes
	ret c
	xor a
	ld hl, wOpponentName
	ld [hli], a
	ld [hl], a
	ld hl, wPlayerDeck
	ld de, wOpponentDeck
	ld c, DECK_SIZE
	call SerialExchangeBytes
	ret

; handles player choice of number of prize cards
; pressing left/right makes it decrease/increase respectively
; selection is confirmed by pressing A button
.PickNumberOfPrizeCards
	ld a, PRIZES_4
	ld [wNPCDuelPrizes], a
	xor a
	ld [wPrizeCardSelectionFrameCounter], a
.loop_input
	call DoFrame
	ld a, [wNPCDuelPrizes]
	add SYM_0
	ld e, a
	; check frame counter so that it
	; either blinks or shows number
	ld hl, wPrizeCardSelectionFrameCounter
	ld a, [hl]
	inc [hl]
	and $10
	jr z, .no_blink
	ld e, SYM_SPACE
.no_blink
	ld a, e
	lb bc, 9, 6
	call WriteByteToBGMap0

	ldh a, [hDPadHeld]
	ld b, a
	ld a, [wNPCDuelPrizes]
	bit D_LEFT_F, b
	jr z, .check_d_right
	dec a
	cp PRIZES_2
	jr nc, .got_prize_count
	ld a, PRIZES_6 ; wrap around to 6
	jr .got_prize_count

.check_d_right
	bit D_RIGHT_F, b
	jr z, .check_a_btn
	inc a
	cp PRIZES_6 + 1
	jr c, .got_prize_count
	ld a, PRIZES_2
.got_prize_count
	ld [wNPCDuelPrizes], a
	xor a
	ld [wPrizeCardSelectionFrameCounter], a

.check_a_btn
	bit A_BUTTON_F, b
	jr z, .loop_input
	ret
; 0x1a61f

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

_OpenBoosterPack: ; 1a68d (6:668d)
	ld a, PLAYER_TURN
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
	ldtx de, BoosterPackText
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
	ld [MBC3SRamEnable], a
	xor a
	ldh [hBankSRAM], a
	ld [MBC3SRamBank], a
	ld [MBC3RTC], a
	ld [MBC3SRamEnable], a
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
	ld [MBC3SRamEnable], a
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
	textitem 2, 1, Deck1Text
	textitem 14, 1, DeckText
	db $ff
Deck2Data: ; 1a76c (6:676c)
	textitem 2, 1, Deck2Text
	textitem 14, 1, DeckText
	db $ff
Deck3Data: ; 1a775 (6:6775)
	textitem 2, 1, Deck3Text
	textitem 14, 1, DeckText
	db $ff
Deck4Data: ; 1a77e (6:677e)
	textitem 2, 1, Deck4Text
	textitem 14, 1, DeckText
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
	ld [wVisibleCursorTile], a
	ld a, $00
	ld [wInvisibleCursorTile], a
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
	ldtx hl, PlayerNameKeyboardText
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
	ld a, [wVisibleCursorTile]
	bit 4, [hl]
	jr z, Func_1aa07.asm_6a0a

Func_1aa07: ; 1aa07 (6:6a07)
	ld a, [wInvisibleCursorTile]
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
	ld a, [wVisibleCursorTile]
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
	ld a, [wInvisibleCursorTile]
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
	ld [wVisibleCursorTile], a
	ld a, $00
	ld [wInvisibleCursorTile], a
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
	ldtx hl, DeckNameKeyboardText ; "A B C D..."
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
	ld a, [wVisibleCursorTile]
	bit 4, [hl]
	jr z, Func_1afa1.asm_6fa4

Func_1afa1: ; 1afa1 (6:6fa1)
	ld a, [wInvisibleCursorTile]
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
	ld a, [wVisibleCursorTile]
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
	ld a, [wInvisibleCursorTile]
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

	ds 4 ; empty

INCLUDE "data/auto_deck_card_lists.asm"
INCLUDE "data/auto_deck_machines.asm"

; writes to sAutoDecks all the deck configurations
; from the Auto Deck Machine in wCurAutoDeckMachine
ReadAutoDeckConfiguration: ; 1ba14 (6:7a14)
	call EnableSRAM
	ld a, [wCurAutoDeckMachine]
	ld l, a
	ld h, 6 * NUM_DECK_MACHINE_SLOTS
	call HtimesL
	ld bc, AutoDeckMachineEntries
	add hl, bc
	ld b, 0
.loop_decks
	call .GetPointerToSRAMAutoDeck
	call .ReadDeckConfiguration
	call .ReadDeckName

	; store deck description text ID
	push hl
	ld de, wAutoDeckMachineTextDescriptions
	ld h, b
	ld l, 2
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
	cp NUM_DECK_MACHINE_SLOTS
	jr nz, .loop_decks
	call DisableSRAM
	ret

; outputs in de the saved deck with index b
.GetPointerToSRAMAutoDeck
	push hl
	ld l, b
	ld h, DECK_STRUCT_SIZE
	call HtimesL
	ld de, sAutoDecks
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ret

; writes the deck configuration in SRAM
; by reading the given deck card list
.ReadDeckConfiguration
	push hl
	push bc
	push de
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ld bc, DECK_NAME_SIZE
	add hl, bc
.loop_create_deck
	ld a, [de]
	inc de
	ld b, a ; card count
	or a
	jr z, .done_create_deck
	ld a, [de]
	inc de
	ld c, a ; card ID
.loop_card_count
	ld [hl], c
	inc hl
	dec b
	jr nz, .loop_card_count
	jr .loop_create_deck
.done_create_deck
	pop de
	pop bc
	pop hl
	inc hl
	inc hl
	ret

.ReadDeckName
	push hl
	push bc
	push de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wDismantledDeckName
	call CopyText
	pop hl
	ld de, wDismantledDeckName
.loop_copy_name
	ld a, [de]
	ld [hli], a
	or a
	jr z, .done_copy_name
	inc de
	jr .loop_copy_name
.done_copy_name
	pop bc
	pop hl
	inc hl
	inc hl
	ret

; tries out all combinations of dismantling the player's decks
; in order to build the deck in wSelectedDeckMachineEntry
; if none of the combinations work, return carry set
; otherwise, return in a which deck flags should be dismantled
CheckWhichDecksToDismantleToBuildSavedDeck: ; 1ba9a (6:7a9a)
	xor a
	ld [wDecksToBeDismantled], a

; first check if it can be built by
; only dismantling a single deck
	ld a, DECK_1
.loop_single_built_decks
	call .CheckIfCanBuild
	ret nc
	sla a ; next deck
	cp (1 << NUM_DECKS)
	jr z, .two_deck_combinations
	jr .loop_single_built_decks

.two_deck_combinations
; next check all two deck combinations
	ld a, DECK_1 | DECK_2
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_1 | DECK_3
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_1 | DECK_4
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_2 | DECK_3
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_2 | DECK_4
	call .CheckIfCanBuild
	ret nc
	ld a, DECK_3 | DECK_4
	call .CheckIfCanBuild
	ret nc

; all but one deck combinations
	ld a, $ff ^ DECK_4
.loop_three_deck_combinations
	call .CheckIfCanBuild
	ret nc
	sra a
	cp $ff
	jr z, .all_decks
	jr .loop_three_deck_combinations

.all_decks
; finally check if can be built by dismantling all decks
	call .CheckIfCanBuild
	ret nc

; none of the combinations work
	scf
	ret

; returns carry if wSelectedDeckMachineEntry cannot be built
; by dismantling the decks given by register a
; a = DECK_* flags
.CheckIfCanBuild
	push af
	ld hl, wSelectedDeckMachineEntry
	ld b, [hl]
	farcall CheckIfCanBuildSavedDeck
	jr c, .cannot_build
	pop af
	ld [wDecksToBeDismantled], a
	or a
	ret
.cannot_build
	pop af
	scf
	ret
