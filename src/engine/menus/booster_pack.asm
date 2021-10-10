_OpenBoosterPack:
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
; clears DECK_SIZE bytes starting from wPlayerDuelVariables
	ld h, a
	ld l, $00
.loop_clear
	xor a
	ld [hli], a
	ld a, l
	cp DECK_SIZE
	jr c, .loop_clear

; fills wDuelTempList with 0, 1, 2, 3, ...
; up to the number of cards received in Boster Pack
	xor a
	ld hl, wBoosterCardsDrawn
	ld de, wDuelTempList
	ld c, $00
.loop_index_sequence
	ld a, [hli]
	or a
	jr z, .done_index_sequence
	ld a, c
	ld [de], a
	inc de
	inc c
	jr .loop_index_sequence
.done_index_sequence
	ld a, $ff ; terminator byte
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
