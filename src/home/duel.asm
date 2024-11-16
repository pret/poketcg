; save duel state to SRAM
; called between each two-player turn, just after player draws card (ROM bank 1 loaded)
SaveDuelStateToSRAM::
	ld a, $2
	call BankswitchSRAM
	; save duel data to sCurrentDuel
	call SaveDuelData
	xor a
	call BankswitchSRAM
	call EnableSRAM
	ld hl, s0a008
	ld a, [hl]
	inc [hl]
	call DisableSRAM
	; select hl = SRAM3:(a000 + $400 * [s0a008] & $3)
	; save wDuelTurns, non-turn holder's arena card ID, turn holder's arena card ID
	and $3
	add HIGH($a000) / 4
	ld l, $0
	ld h, a
	add hl, hl
	add hl, hl
	ld a, $3
	call BankswitchSRAM
	push hl
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempTurnDuelistCardID], a
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempNonTurnDuelistCardID], a
	call SwapTurn
	pop hl
	push hl
	call EnableSRAM
	ld a, [wDuelTurns]
	ld [hli], a
	ld a, [wTempNonTurnDuelistCardID]
	ld [hli], a
	ld a, [wTempTurnDuelistCardID]
	ld [hli], a
	; save duel data to SRAM3:(a000 + $400 * [s0a008] & $3) + $0010
	pop hl
	ld de, $0010
	add hl, de
	ld e, l
	ld d, h
	call DisableSRAM
	bank1call SaveDuelDataToDE
	xor a
	call BankswitchSRAM
	ret

; copies the deck pointed to by de to wPlayerDeck or wOpponentDeck (depending on whose turn it is)
CopyDeckData::
	ld hl, wPlayerDeck
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .copy_deck_data
	ld hl, wOpponentDeck
.copy_deck_data
	; start by putting a terminator at the end of the deck
	push hl
	ld bc, DECK_SIZE - 1
	add hl, bc
	ld [hl], $0
	pop hl
	push hl
.next_card
	ld a, [de]
	inc de
	ld b, a
	or a
	jr z, .done
	ld a, [de]
	inc de
	ld c, a
.card_quantity_loop
	ld [hl], c
	inc hl
	dec b
	jr nz, .card_quantity_loop
	jr .next_card
.done
	ld hl, wDeckName
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	pop hl
	ld bc, DECK_SIZE - 1
	add hl, bc
	ld a, [hl]
	or a
	ret nz
	debug_nop
	scf
	ret

; return, in register a, the amount of prizes that the turn holder has not yet drawn
CountPrizes::
	push hl
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	ld l, a
	xor a
.count_loop
	rr l
	adc $00
	inc l
	dec l
	jr nz, .count_loop
	pop hl
	ret

; shuffles the turn holder's deck
; if less than 60 cards remain in the deck, it makes sure that the rest are ignored
ShuffleDeck::
	ldh a, [hWhoseTurn]
	ld h, a
	ld d, a
	ld a, DECK_SIZE
	ld l, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	sub [hl]
	ld b, a
	ld a, DUELVARS_DECK_CARDS
	add [hl]
	ld l, a ; hl = DUELVARS_DECK_CARDS + [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK]
	ld a, b ; a = number of cards in the deck
	call ShuffleCards
	ret

; draw a card from the turn holder's deck, saving its location as CARD_LOCATION_JUST_DRAWN.
; returns carry if deck is empty, nc if a card was successfully drawn.
; AddCardToHand is meant to be called next (unless this function returned carry).
DrawCardFromDeck::
	push hl
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE
	jr nc, .empty_deck
	inc a
	ld [hl], a ; increment number of cards not in deck
	add DUELVARS_DECK_CARDS - 1 ; point to top card in the deck
	ld l, a
	ld a, [hl] ; grab card number (0-59) from wPlayerDeckCards or wOpponentDeckCards array
	ld l, a
	ld [hl], CARD_LOCATION_JUST_DRAWN ; temporarily write to corresponding card location variable
	pop hl
	or a
	ret
.empty_deck
	pop hl
	scf
	ret

; add a card to the top of the turn holder's deck
; the card is identified by register a, which contains the deck index (0-59) of the card
ReturnCardToDeck::
	push hl
	push af
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	dec a
	ld [hl], a ; decrement number of cards not in deck
	add DUELVARS_DECK_CARDS
	ld l, a ; point to top deck card
	pop af
	ld [hl], a ; set top deck card
	ld l, a
	ld [hl], CARD_LOCATION_DECK
	ld a, l
	pop hl
	ret

; search a card in the turn holder's deck, extract it, and set its location to
; CARD_LOCATION_JUST_DRAWN. AddCardToHand is meant to be called next.
; the card is identified by register a, which contains the deck index (0-59) of the card.
SearchCardInDeckAndAddToHand::
	push af
	push hl
	push de
	push bc
	ld c, a
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld a, DECK_SIZE
	sub [hl]
	inc [hl] ; increment number of cards not in deck
	ld b, a ; DECK_SIZE - [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK] (number of cards in deck)
	ld l, c
	set CARD_LOCATION_JUST_DRAWN_F, [hl]
	ld l, DUELVARS_DECK_CARDS + DECK_SIZE - 1
	ld e, l
	ld d, h ; hl = de = DUELVARS_DECK_CARDS + DECK_SIZE - 1 (last card)
	inc b
	jr .match
.loop
	ld a, [hld]
	cp c
	jr z, .match
	ld [de], a
	dec de
.match
	dec b
	jr nz, .loop
	pop bc
	pop de
	pop hl
	pop af
	ret

; adds a card to the turn holder's hand and increments the number of cards in the hand
; the card is identified by register a, which contains the deck index (0-59) of the card
AddCardToHand::
	push af
	push hl
	push de
	ld e, a
	ld l, a
	ldh a, [hWhoseTurn]
	ld h, a
	; write CARD_LOCATION_HAND into the location of this card
	ld [hl], CARD_LOCATION_HAND
	; increment number of cards in hand
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	inc [hl]
	; add card to hand
	ld a, DUELVARS_HAND - 1
	add [hl]
	ld l, a
	ld [hl], e
	pop de
	pop hl
	pop af
	ret

; removes a card from the turn holder's hand and decrements the number of cards in the hand
; the card is identified by register a, which contains the deck index (0-59) of the card
RemoveCardFromHand::
	push af
	push hl
	push bc
	push de
	ld c, a
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	or a
	jr z, .done ; done if no cards in hand
	ld b, a ; number of cards in hand
	ld l, DUELVARS_HAND
	ld e, l
	ld d, h
.next_card
	ld a, [hli]
	cp c
	jr nz, .no_match
	push hl
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	dec [hl]
	pop hl
	jr .done_card
.no_match
	ld [de], a ; keep any card that doesn't match in the player's hand
	inc de
.done_card
	dec b
	jr nz, .next_card
.done
	pop de
	pop bc
	pop hl
	pop af
	ret

; moves a card to the turn holder's discard pile, as long as it is in the hand
; the card is identified by register a, which contains the deck index (0-59) of the card
MoveHandCardToDiscardPile::
	call GetTurnDuelistVariable
	ld a, [hl]
	and $ff ^ CARD_LOCATION_JUST_DRAWN
	cp CARD_LOCATION_HAND
	ret nz ; return if card not in hand
	ld a, l
	call RemoveCardFromHand
;	fallthrough

; puts the turn holder's card with the deck index (0-59) given in a into the discard pile
PutCardInDiscardPile::
	push af
	push hl
	push de
	call GetTurnDuelistVariable
	ld [hl], CARD_LOCATION_DISCARD_PILE
	ld e, l
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	inc [hl]
	ld a, DUELVARS_DECK_CARDS - 1
	add [hl]
	ld l, a
	ld [hl], e ; save card to DUELVARS_DECK_CARDS + [DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE]
	pop de
	pop hl
	pop af
	ret

; search a card in the turn holder's discard pile, extract it, and set its location to
; CARD_LOCATION_JUST_DRAWN. AddCardToHand is meant to be called next.
; the card is identified by register a, which contains the deck index (0-59) of the card
MoveDiscardPileCardToHand::
	push hl
	push de
	push bc
	call GetTurnDuelistVariable
	set CARD_LOCATION_JUST_DRAWN_F, [hl]
	ld b, l
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	ld a, [hl]
	or a
	jr z, .done ; done if no cards in discard pile
	ld c, a
	dec [hl] ; decrement number of cards in discard pile
	ld l, DUELVARS_DECK_CARDS
	ld e, l
	ld d, h ; de = hl = DUELVARS_DECK_CARDS
.next_card
	ld a, [hli]
	cp b
	jr z, .match
	ld [de], a
	inc de
.match
	dec c
	jr nz, .next_card
	ld a, b
.done
	pop bc
	pop de
	pop hl
	ret

; return in the z flag whether turn holder's prize a (0-7) has been drawn or not
; z: drawn, nz: not drawn
CheckPrizeTaken::
	ld e, a
	ld d, 0
	ld hl, PowersOf2
	add hl, de
	ld a, [hl]
	ld e, a
	cpl
	ld d, a
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	and e
	ret

PowersOf2::
	db $01, $02, $04, $08, $10, $20, $40, $80

; fill wDuelTempList with the turn holder's discard pile cards (their 0-59 deck indexes)
; return carry if the turn holder has no cards in the discard pile
CreateDiscardPileCardList::
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	ld b, [hl]
	ld a, DUELVARS_DECK_CARDS - 1
	add [hl] ; point to last card in discard pile
	ld l, a
	ld de, wDuelTempList
	inc b
	jr .begin_loop
.next_card_loop
	ld a, [hld]
	ld [de], a
	inc de
.begin_loop
	dec b
	jr nz, .next_card_loop
	ld a, $ff ; $ff-terminated
	ld [de], a
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	ld a, [hl]
	or a
	ret nz
	scf
	ret

; fill wDuelTempList with the turn holder's remaining deck cards (their 0-59 deck indexes)
; return carry if the turn holder has no cards left in the deck
CreateDeckCardList::
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE
	jr nc, .no_cards_left_in_deck
	ld a, DECK_SIZE
	sub [hl]
	ld c, a
	ld b, a ; c = b = DECK_SIZE - [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK]
	ld a, [hl]
	add DUELVARS_DECK_CARDS
	ld l, a ; l = DUELVARS_DECK_CARDS + [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK]
	inc b
	ld de, wDuelTempList
	jr .begin_loop
.next_card
	ld a, [hli]
	ld [de], a
	inc de
.begin_loop
	dec b
	jr nz, .next_card
	ld a, $ff ; $ff-terminated
	ld [de], a
	ld a, c
	or a
	ret
.no_cards_left_in_deck
	ld a, $ff
	ld [wDuelTempList], a
	scf
	ret

; fill wDuelTempList with the turn holder's energy cards
; in the arena or in a bench slot (their 0-59 deck indexes).
; if a == 0: search in CARD_LOCATION_ARENA
; if a != 0: search in CARD_LOCATION_BENCH_[A]
; return carry if no energy cards were found
CreateArenaOrBenchEnergyCardList::
	or CARD_LOCATION_PLAY_AREA
	ld c, a
	ld de, wDuelTempList
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.next_card_loop
	ld a, [hl]
	cp c
	jr nz, .skip_card ; jump if not in specified play area location
	ld a, l
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	and 1 << TYPE_ENERGY_F
	jr z, .skip_card ; jump if Pokemon or trainer card
	ld a, l
	ld [de], a ; add to wDuelTempList
	inc de
.skip_card
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .next_card_loop
	; all cards checked
	ld a, $ff
	ld [de], a
	ld a, [wDuelTempList]
	cp $ff
	jr z, .no_energies_found
	or a
	ret
.no_energies_found
	scf
	ret

; fill wDuelTempList with the turn holder's hand cards (their 0-59 deck indexes)
; return carry if the turn holder has no cards in hand
; and outputs in a number of cards.
CreateHandCardList::
	call FindLastCardInHand
	inc b
	jr .skip_card

.check_next_card_loop
	ld a, [hld]
	push hl
	ld l, a
	bit CARD_LOCATION_JUST_DRAWN_F, [hl]
	pop hl
	jr nz, .skip_card
	ld [de], a
	inc de

.skip_card
	dec b
	jr nz, .check_next_card_loop
	ld a, $ff ; $ff-terminated
	ld [de], a
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	ld a, [hl]
	or a
	ret nz
	scf
	ret

; sort the turn holder's hand cards by ID (highest to lowest ID)
; makes use of wDuelTempList
SortHandCardsByID::
	call FindLastCardInHand
.loop
	ld a, [hld]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld a, $ff
	ld [de], a
	call SortCardsInDuelTempListByID
	call FindLastCardInHand
.loop2
	ld a, [de]
	inc de
	ld [hld], a
	dec b
	jr nz, .loop2
	ret

; returns:
; b = turn holder's number of cards in hand (DUELVARS_NUMBER_OF_CARDS_IN_HAND)
; hl = pointer to turn holder's last (newest) card in DUELVARS_HAND
; de = wDuelTempList
FindLastCardInHand::
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	ld b, [hl]
	ld a, DUELVARS_HAND - 1
	add [hl]
	ld l, a
	ld de, wDuelTempList
	ret

; shuffles the deck by swapping the position of each card with the position of another random card
; input:
   ; a  = how many cards to shuffle
   ; hl = DUELVARS_DECK_CARDS + [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK]
ShuffleCards::
	or a
	ret z ; return if deck is empty
	push hl
	push de
	push bc
	ld c, a
	ld b, a
	ld e, l
	ld d, h
.shuffle_next_card_loop
	push bc
	push de
	ld a, c
	call Random
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	pop de
	pop bc
	inc hl
	dec b
	jr nz, .shuffle_next_card_loop
	pop bc
	pop de
	pop hl
	ret

; sort a $ff-terminated list of deck index cards by ID (lowest to highest ID).
; the list is wDuelTempList.
SortCardsInDuelTempListByID::
	ld hl, hTempListPtr_ff99
	ld [hl], LOW(wDuelTempList)
	inc hl
	ld [hl], HIGH(wDuelTempList)
	jr SortCardsInListByID_CheckForListTerminator

; sort a $ff-terminated list of deck index cards by ID (lowest to highest ID).
; the pointer to the list is given in hTempListPtr_ff99.
; sorting by ID rather than deck index means that the order of equal (same ID) cards does not matter,
; even if they have a different deck index.
SortCardsInListByID::
	; load [hTempListPtr_ff99] into hl and de
	ld hl, hTempListPtr_ff99
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, l
	ld d, h
	; get ID of card with deck index at [de]
	ld a, [de]
	call GetCardIDFromDeckIndex_bc
	ld a, c
	ldh [hTempCardID_ff9b], a
	ld a, b
	ldh [hTempCardID_ff9b + 1], a ; 0
	; hl = [hTempListPtr_ff99] + 1
	inc hl
	jr .check_list_end

.next_card_in_list
	ld a, [hl]
	call GetCardIDFromDeckIndex_bc
	ldh a, [hTempCardID_ff9b + 1]
	cp b
	jr nz, .go
	ldh a, [hTempCardID_ff9b]
	cp c
.go
	jr c, .not_lower_id
	; this card has the lowest ID of those checked so far
	ld e, l
	ld d, h
	ld a, c
	ldh [hTempCardID_ff9b], a
	ld a, b
	ldh [hTempCardID_ff9b + 1], a
.not_lower_id
	inc hl
.check_list_end
	bit 7, [hl] ; $ff is the list terminator
	jr z, .next_card_in_list
	; reached list terminator
	ld hl, hTempListPtr_ff99
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; swap the lowest ID card found with the card in the current list position
	ld c, [hl]
	ld a, [de]
	ld [hl], a
	ld a, c
	ld [de], a
	pop hl
	; [hTempListPtr_ff99] += 1 (point hl to next card in list)
	inc [hl]
	jr nz, SortCardsInListByID_CheckForListTerminator
	inc hl
	inc [hl]
;	fallthrough

SortCardsInListByID_CheckForListTerminator::
	ld hl, hTempListPtr_ff99
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, [hl] ; $ff is the list terminator
	jr z, SortCardsInListByID
	ret

; returns, in register bc, the id of the card with the deck index specified in register a
; preserves hl
GetCardIDFromDeckIndex_bc::
	push hl
	call _GetCardIDFromDeckIndex
	ld c, a
	ld b, $0
	pop hl
	ret

; return [wDuelTempList + a] in a and in hTempCardIndex_ff98
GetCardInDuelTempList_OnlyDeckIndex::
	push hl
	push de
	ld e, a
	ld d, $0
	ld hl, wDuelTempList
	add hl, de
	ld a, [hl]
	ldh [hTempCardIndex_ff98], a
	pop de
	pop hl
	ret

; given the deck index (0-59) of a card in [wDuelTempList + a], return:
;  - the id of the card with that deck index in register de
;  - [wDuelTempList + a] in hTempCardIndex_ff98 and in register a
GetCardInDuelTempList::
	push hl
	ld e, a
	ld d, $0
	ld hl, wDuelTempList
	add hl, de
	ld a, [hl]
	ldh [hTempCardIndex_ff98], a
	call GetCardIDFromDeckIndex
	pop hl
	ldh a, [hTempCardIndex_ff98]
	ret

; returns, in register de, the id of the card with the deck index (0-59) specified by register a
; preserves af and hl
GetCardIDFromDeckIndex::
	push af
	push hl
	call _GetCardIDFromDeckIndex
	ld e, a
	ld d, $0
	pop hl
	pop af
	ret

; remove card c from wDuelTempList (it contains a $ff-terminated list of deck indexes)
; returns carry if no matches were found.
RemoveCardFromDuelTempList::
	push hl
	push de
	push bc
	ld hl, wDuelTempList
	ld e, l
	ld d, h
	ld c, a
	ld b, $00
.next
	ld a, [hli]
	cp $ff
	jr z, .end_of_list
	cp c
	jr z, .match
	ld [de], a
	inc de
	inc b
.match
	jr .next
.end_of_list
	ld [de], a
	ld a, b
	or a
	jr nz, .done
	scf
.done
	pop bc
	pop de
	pop hl
	ret

; return the number of cards in wDuelTempList in a
CountCardsInDuelTempList::
	push hl
	push bc
	ld hl, wDuelTempList
	ld b, -1
.loop
	inc b
	ld a, [hli]
	cp $ff
	jr nz, .loop
	ld a, b
	pop bc
	pop hl
	ret

; returns, in register a, the id of the card with the deck index (0-59) specified in register a
_GetCardIDFromDeckIndex::
	push de
	ld e, a
	ld d, $0
	ld hl, wPlayerDeck
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .load_card_from_deck
	ld hl, wOpponentDeck
.load_card_from_deck
	add hl, de
	ld a, [hl]
	pop de
	ret

; load data of card with deck index a (0-59) to wLoadedCard1
LoadCardDataToBuffer1_FromDeckIndex::
	push hl
	push de
	push bc
	push af
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	pop af
	ld hl, wLoadedCard1
	bank1call ConvertSpecialTrainerCardToPokemon
	ld a, e
	pop bc
	pop de
	pop hl
	ret

; load data of card with deck index a (0-59) to wLoadedCard2
LoadCardDataToBuffer2_FromDeckIndex::
	push hl
	push de
	push bc
	push af
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer2_FromCardID
	pop af
	ld hl, wLoadedCard2
	bank1call ConvertSpecialTrainerCardToPokemon
	ld a, e
	pop bc
	pop de
	pop hl
	ret

; evolve a turn holder's Pokemon card in the play area slot determined by hTempPlayAreaLocation_ff9d
; into another turn holder's Pokemon card identifier by its deck index (0-59) in hTempCardIndex_ff98.
; return nc if evolution was successful.
EvolvePokemonCardIfPossible::
	; first make sure the attempted evolution is viable
	ldh a, [hTempCardIndex_ff98]
	ld d, a
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call CheckIfCanEvolveInto
	ret c ; return if it's not capable of evolving into the selected Pokemon
;	fallthrough

; evolve a turn holder's Pokemon card in the play area slot determined by hTempPlayAreaLocation_ff9d
; into another turn holder's Pokemon card identifier by its deck index (0-59) in hTempCardIndex_ff98.
EvolvePokemonCard::
; place the evolved Pokemon card in the play area location of the pre-evolved Pokemon card
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld [wPreEvolutionPokemonCard], a ; save pre-evolved Pokemon card into wPreEvolutionPokemonCard
	call LoadCardDataToBuffer2_FromDeckIndex
	ldh a, [hTempCardIndex_ff98]
	ld [hl], a
	call LoadCardDataToBuffer1_FromDeckIndex
	ldh a, [hTempCardIndex_ff98]
	call PutHandCardInPlayArea
	; update the Pokemon's HP with the difference
	ldh a, [hTempPlayAreaLocation_ff9d] ; derp
	ld a, e
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld a, [wLoadedCard2HP]
	ld c, a
	ld a, [wLoadedCard1HP]
	sub c
	add [hl]
	ld [hl], a
	; reset status (if in arena) and set the flag that prevents it from evolving again this turn
	ld a, e
	add DUELVARS_ARENA_CARD_FLAGS
	ld l, a
	ld [hl], $00
	ld a, e
	add DUELVARS_ARENA_CARD_CHANGED_TYPE
	ld l, a
	ld [hl], $00
	ld a, e
	or a
	call z, ClearAllStatusConditions
	; set the new evolution stage of the card
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_STAGE
	call GetTurnDuelistVariable
	ld a, [wLoadedCard1Stage]
	ld [hl], a
	or a
	ret

; never executed
	scf
	ret

; check if the turn holder's Pokemon card at e can evolve into the turn holder's Pokemon card d.
; e is the play area location offset (PLAY_AREA_*) of the Pokemon trying to evolve.
; d is the deck index (0-59) of the Pokemon card that was selected to be the evolution target.
; return carry if can't evolve, plus nz if the reason for it is the card was played this turn.
CheckIfCanEvolveInto::
	push de
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
	ld hl, wLoadedCard2Name
	ld de, wLoadedCard1PreEvoName
	ld a, [de]
	cp [hl]
	jr nz, .cant_evolve ; jump if they are incompatible to evolve
	inc de
	inc hl
	ld a, [de]
	cp [hl]
	jr nz, .cant_evolve ; jump if they are incompatible to evolve
	pop de
	ld a, e
	add DUELVARS_ARENA_CARD_FLAGS
	call GetTurnDuelistVariable
	and CAN_EVOLVE_THIS_TURN
	jr nz, .can_evolve
	; if the card trying to evolve was played this turn, it can't evolve
	ld a, $01
	or a
	scf
	ret
.can_evolve
	or a
	ret
.cant_evolve
	pop de
	xor a
	scf
	ret

; check if the turn holder's Pokemon card at e can evolve this turn, and is a basic
; Pokemon card that whose second stage evolution is the turn holder's Pokemon card d.
; e is the play area location offset (PLAY_AREA_*) of the Pokemon trying to evolve.
; d is the deck index (0-59) of the Pokemon card that was selected to be the evolution target.
; return carry if not basic to stage 2 evolution, or if evolution not possible this turn.
CheckIfCanEvolveInto_BasicToStage2::
	ld a, e
	add DUELVARS_ARENA_CARD_FLAGS
	call GetTurnDuelistVariable
	and CAN_EVOLVE_THIS_TURN
	jr nz, .can_evolve
	jr .cant_evolve
.can_evolve
	ld a, e
	add DUELVARS_ARENA_CARD
	ld l, a
	ld a, [hl]
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
	ld hl, wLoadedCard1PreEvoName
	ld e, [hl]
	inc hl
	ld d, [hl]
	call LoadCardDataToBuffer1_FromName
	ld hl, wLoadedCard2Name
	ld de, wLoadedCard1PreEvoName
	ld a, [de]
	cp [hl]
	jr nz, .cant_evolve
	inc de
	inc hl
	ld a, [de]
	cp [hl]
	jr nz, .cant_evolve
	or a
	ret
.cant_evolve
	xor a
	scf
	ret

; clear the status, all substatuses, and temporary duelvars of the turn holder's
; arena Pokemon. called when sending a new Pokemon into the arena.
; does not reset Headache, since it targets a player rather than a Pokemon.
ClearAllStatusConditions::
	push hl
	ldh a, [hWhoseTurn]
	ld h, a
	xor a
	ld l, DUELVARS_ARENA_CARD_STATUS
	ld [hl], a ; NO_STATUS
	ld l, DUELVARS_ARENA_CARD_SUBSTATUS1
	ld [hl], a
	ld l, DUELVARS_ARENA_CARD_SUBSTATUS2
	ld [hl], a
	ld l, DUELVARS_ARENA_CARD_CHANGED_WEAKNESS
	ld [hl], a
	ld l, DUELVARS_ARENA_CARD_CHANGED_RESISTANCE
	ld [hl], a
	ld l, DUELVARS_ARENA_CARD_SUBSTATUS3
	res SUBSTATUS3_THIS_TURN_DOUBLE_DAMAGE_F, [hl]
	ld l, DUELVARS_ARENA_CARD_DISABLED_ATTACK_INDEX
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop hl
	ret

; Removes a Pokemon card from the hand and places it in the arena or first available bench slot.
; If the Pokemon is placed in the arena, the status conditions of the player's arena card are zeroed.
; input:
   ; a = deck index of the card
; return carry if there is no room for more Pokemon
PutHandPokemonCardInPlayArea::
	push af
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .already_max_pkmn_in_play
	inc [hl]
	ld e, a ; play area offset to place card
	pop af
	push af
	call PutHandCardInPlayArea
	ld a, e
	add DUELVARS_ARENA_CARD
	ld l, a
	pop af
	ld [hl], a ; set card in arena or benchx
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, DUELVARS_ARENA_CARD_HP
	add e
	ld l, a
	ld a, [wLoadedCard2HP]
	ld [hl], a ; set card's HP
	ld a, DUELVARS_ARENA_CARD_FLAGS
	add e
	ld l, a
	ld [hl], $0
	ld a, DUELVARS_ARENA_CARD_CHANGED_TYPE
	add e
	ld l, a
	ld [hl], $0
	ld a, DUELVARS_ARENA_CARD_ATTACHED_PLUSPOWER
	add e
	ld l, a
	ld [hl], $0
	ld a, DUELVARS_ARENA_CARD_ATTACHED_DEFENDER
	add e
	ld l, a
	ld [hl], $0
	ld a, DUELVARS_ARENA_CARD_STAGE
	add e
	ld l, a
	ld a, [wLoadedCard2Stage]
	ld [hl], a ; set card's evolution stage
	ld a, e
	or a
	call z, ClearAllStatusConditions ; only call if Pokemon is being placed in the arena
	ld a, e
	or a
	ret

.already_max_pkmn_in_play
	pop af
	scf
	ret

; Removes a card from the hand and changes its location to arena or bench. Given that
; DUELVARS_ARENA_CARD or DUELVARS_BENCH aren't affected, this function is meant for energy and trainer cards.
; input:
   ; a = deck index of the card
   ; e = play area location offset (PLAY_AREA_*)
; returns:
   ; a = CARD_LOCATION_PLAY_AREA + e
PutHandCardInPlayArea::
	call RemoveCardFromHand
	call GetTurnDuelistVariable
	ld a, e
	or CARD_LOCATION_PLAY_AREA
	ld [hl], a
	ret

; move the Pokemon card of the turn holder in the
; PLAY_AREA_* location given in e to the discard pile
MovePlayAreaCardToDiscardPile::
	call EmptyPlayAreaSlot
	ld l, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	dec [hl]
	ld l, DUELVARS_CARD_LOCATIONS
.next_card
	ld a, e
	or CARD_LOCATION_PLAY_AREA
	cp [hl]
	jr nz, .not_in_location
	push de
	ld a, l
	call PutCardInDiscardPile
	pop de
.not_in_location
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .next_card
	ret

; init a turn holder's play area slot to empty
; which slot (arena or benchx) is determined by the play area location offset (PLAY_AREA_*) in e
EmptyPlayAreaSlot::
	ldh a, [hWhoseTurn]
	ld h, a
	ld d, -1
	ld a, DUELVARS_ARENA_CARD
	call .init_duelvar
	ld d, 0
	ld a, DUELVARS_ARENA_CARD_HP
	call .init_duelvar
	ld a, DUELVARS_ARENA_CARD_STAGE
	call .init_duelvar
	ld a, DUELVARS_ARENA_CARD_CHANGED_TYPE
	call .init_duelvar
	ld a, DUELVARS_ARENA_CARD_ATTACHED_DEFENDER
	call .init_duelvar
	ld a, DUELVARS_ARENA_CARD_ATTACHED_PLUSPOWER
.init_duelvar
	add e
	ld l, a
	ld [hl], d
	ret

; shift play area Pokemon of both players to the first available play area (arena + benchx) slots
ShiftAllPokemonToFirstPlayAreaSlots::
	call ShiftTurnPokemonToFirstPlayAreaSlots
	call SwapTurn
	call ShiftTurnPokemonToFirstPlayAreaSlots
	call SwapTurn
	ret

; shift play area Pokemon of the turn holder to the first available play area (arena + benchx) slots
ShiftTurnPokemonToFirstPlayAreaSlots::
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	lb de, PLAY_AREA_ARENA, PLAY_AREA_ARENA
.next_play_area_slot
	bit 7, [hl]
	jr nz, .empty_slot
	call SwapPlayAreaPokemon
	inc e
.empty_slot
	inc hl
	inc d
	ld a, d
	cp MAX_PLAY_AREA_POKEMON
	jr nz, .next_play_area_slot
	ret

; swap the data of the turn holder's arena Pokemon card with the
; data of the turn holder's Pokemon card in play area e.
; reset the status and all substatuses of the arena Pokemon before swapping.
; e is the play area location offset of the bench Pokemon (PLAY_AREA_*).
SwapArenaWithBenchPokemon::
	call ClearAllStatusConditions
	ld d, PLAY_AREA_ARENA
;	fallthrough

; swap the data of the turn holder's Pokemon card in play area d with the
; data of the turn holder's Pokemon card in play area e.
; d and e are play area location offsets (PLAY_AREA_*).
SwapPlayAreaPokemon::
	push bc
	push de
	push hl
	ld a, e
	cp d
	jr z, .done
	ldh a, [hWhoseTurn]
	ld h, a
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call .swap_duelvar
	ld a, DUELVARS_ARENA_CARD_HP
	call .swap_duelvar
	ld a, DUELVARS_ARENA_CARD_FLAGS
	call .swap_duelvar
	ld a, DUELVARS_ARENA_CARD_STAGE
	call .swap_duelvar
	ld a, DUELVARS_ARENA_CARD_CHANGED_TYPE
	call .swap_duelvar
	ld a, DUELVARS_ARENA_CARD_ATTACHED_PLUSPOWER
	call .swap_duelvar
	ld a, DUELVARS_ARENA_CARD_ATTACHED_DEFENDER
	call .swap_duelvar
	set CARD_LOCATION_PLAY_AREA_F, d
	set CARD_LOCATION_PLAY_AREA_F, e
	ld l, DUELVARS_CARD_LOCATIONS
.update_card_locations_loop
	; update card locations of the two swapped cards
	ld a, [hl]
	cp e
	jr nz, .next1
	ld a, d
	jr .update_location
.next1
	cp d
	jr nz, .next2
	ld a, e
.update_location
	ld [hl], a
.next2
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .update_card_locations_loop
.done
	pop hl
	pop de
	pop bc
	ret

.swap_duelvar
	ld c, a
	add e ; play area location offset of card 1
	ld l, a
	ld a, c
	add d ; play area location offset of card 2
	ld c, a
	ld a, [bc]
	push af
	ld a, [hl]
	ld [bc], a
	pop af
	ld [hl], a
	ret

; Find which and how many energy cards are attached to the turn holder's Pokemon card in the arena,
; or a Pokemon card in the bench, depending on the value of register e.
; input: e = location to check, i.e. PLAY_AREA_*
; Feedback is returned in wAttachedEnergies and wTotalAttachedEnergies.
GetPlayAreaCardAttachedEnergies::
	push hl
	push de
	push bc
	xor a
	ld c, NUM_TYPES
	ld hl, wAttachedEnergies
.zero_energies_loop
	ld [hli], a
	dec c
	jr nz, .zero_energies_loop
	ld a, CARD_LOCATION_PLAY_AREA
	or e ; if e is non-0, a bench location is checked instead
	ld e, a
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_CARD_LOCATIONS
	ld c, DECK_SIZE
.next_card
	ld a, [hl]
	cp e
	jr nz, .not_in_requested_location

	push hl
	push de
	push bc
	ld a, l
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	bit TYPE_ENERGY_F, a
	jr z, .not_an_energy_card
	and TYPE_PKMN ; zero bit 3 to extract the type
	ld e, a
	ld d, $0
	ld hl, wAttachedEnergies
	add hl, de
	inc [hl] ; increment the number of energy cards of this type
	cp COLORLESS
	jr nz, .not_colorless
	inc [hl] ; each colorless energy counts as two
.not_an_energy_card
.not_colorless
	pop bc
	pop de
	pop hl

.not_in_requested_location
	inc l
	dec c
	jr nz, .next_card
	; all 60 cards checked
	ld hl, wAttachedEnergies
	ld c, NUM_TYPES
	xor a
.sum_attached_energies_loop
	add [hl]
	inc hl
	dec c
	jr nz, .sum_attached_energies_loop
	ld [hl], a ; save to wTotalAttachedEnergies
	pop bc
	pop de
	pop hl
	ret

; returns in a how many times card e can be found in location b
; e = card id to search
; b = location to consider (CARD_LOCATION_*)
; h = PLAYER_TURN or OPPONENT_TURN
CountCardIDInLocation::
	push bc
	ld l, DUELVARS_CARD_LOCATIONS
	ld c, $0
.next_card
	ld a, [hl]
	cp b
	jr nz, .unmatching_card_location_or_ID
	ld a, l
	push hl
	call _GetCardIDFromDeckIndex
	cp e
	pop hl
	jr nz, .unmatching_card_location_or_ID
	inc c
.unmatching_card_location_or_ID
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .next_card
	ld a, c
	pop bc
	ret

; returns [[hWhoseTurn] << 8 + a] in a and in [hl]
; i.e. duelvar a of the player whose turn it is
GetTurnDuelistVariable::
	ld l, a
	ldh a, [hWhoseTurn]
	ld h, a
	ld a, [hl]
	ret

; returns [([hWhoseTurn] ^ $1) << 8 + a] in a and in [hl]
; i.e. duelvar a of the player whose turn it is not
GetNonTurnDuelistVariable::
	ld l, a
	ldh a, [hWhoseTurn]
	ld h, OPPONENT_TURN
	cp PLAYER_TURN
	jr z, .ok
	ld h, PLAYER_TURN
.ok
	ld a, [hl]
	ret

; when playing a Pokemon card, initializes some variables according to the
; card played, and checks if the played card has Pokemon Power to show it to
; the player, and possibly to use it if it triggers when the card is played.
ProcessPlayedPokemonCard::
	ldh a, [hTempCardIndex_ff98]
	call ClearChangedTypesIfMuk
	ldh a, [hTempCardIndex_ff98]
	ld d, a
	ld e, FIRST_ATTACK_OR_PKMN_POWER
	call CopyAttackDataAndDamage_FromDeckIndex
	call UpdateArenaCardIDsAndClearTwoTurnDuelVars
	ldh a, [hTempCardIndex_ff98]
	ldh [hTempCardIndex_ff9f], a
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempTurnDuelistCardID], a
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	ret nz
	call DisplayUsePokemonPowerScreen
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ldtx hl, HavePokemonPowerText
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG
	ld a, [wLoadedCard1ID]
	cp MUK
	jr z, .use_pokemon_power
	ld a, PLAY_AREA_BENCH_1 ; don't check status
	call CheckIsIncapableOfUsingPkmnPower
	jr nc, .use_pokemon_power
	call DisplayUsePokemonPowerScreen
	ldtx hl, UnableToUsePkmnPowerDueToToxicGasText
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG
	ret

.use_pokemon_power
	ld hl, wLoadedAttackEffectCommands
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, EFFECTCMDTYPE_PKMN_POWER_TRIGGER
	call CheckMatchingCommand
	ret c ; return if command not found
	bank1call DrawDuelMainScene
	ldh a, [hTempCardIndex_ff9f]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld de, wLoadedCard1Name
	ld hl, wTxRam2
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld de, wLoadedAttackName
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ldtx hl, WillUseThePokemonPowerText
	call DrawWideTextBox_WaitForInput
	call ExchangeRNG
	call Func_7415
	ld a, EFFECTCMDTYPE_PKMN_POWER_TRIGGER
	call TryExecuteEffectCommandFunction
	ret

; copies, given a card identified by register a (card ID):
; - e into wSelectedAttack and d into hTempCardIndex_ff9f
; - Attack1 (if e == 0) or Attack2 (if e == 1) data into wLoadedAttack
; - Also from that attack, its Damage field into wDamage
; finally, clears wNoDamageOrEffect and wDealtDamage
CopyAttackDataAndDamage_FromCardID::
	push de
	push af
	ld a, e
	ld [wSelectedAttack], a
	ld a, d
	ldh [hTempCardIndex_ff9f], a
	pop af
	ld e, a
	ld d, $00
	call LoadCardDataToBuffer1_FromCardID
	pop de
	jr CopyAttackDataAndDamage

; copies, given a card identified by register d (0-59 deck index):
; - e into wSelectedAttack and d into hTempCardIndex_ff9f
; - Attack1 (if e == 0) or Attack2 (if e == 1) data into wLoadedAttack
; - Also from that attack, its Damage field into wDamage
; finally, clears wNoDamageOrEffect and wDealtDamage
CopyAttackDataAndDamage_FromDeckIndex::
	ld a, e
	ld [wSelectedAttack], a
	ld a, d
	ldh [hTempCardIndex_ff9f], a
	call LoadCardDataToBuffer1_FromDeckIndex
;	fallthrough

CopyAttackDataAndDamage::
	ld a, [wLoadedCard1ID]
	ld [wTempCardID_ccc2], a
	ld hl, wLoadedCard1Atk1
	dec e
	jr nz, .got_atk
	ld hl, wLoadedCard1Atk2
.got_atk
	ld de, wLoadedAttack
	ld c, CARD_DATA_ATTACK2 - CARD_DATA_ATTACK1
.copy_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_loop
	ld a, [wLoadedAttackDamage]
	ld hl, wDamage
	ld [hli], a
	xor a
	ld [hl], a
	ld [wNoDamageOrEffect], a
	ld hl, wDealtDamage
	ld [hli], a
	ld [hl], a
	ret

; inits hTempCardIndex_ff9f and wTempTurnDuelistCardID to the turn holder's arena card,
; wTempNonTurnDuelistCardID to the non-turn holder's arena card, and zeroes other temp
; variables that only last between each two-player turn.
; this is called when a Pokemon card is played or when an attack is used
UpdateArenaCardIDsAndClearTwoTurnDuelVars::
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [hTempCardIndex_ff9f], a
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempTurnDuelistCardID], a
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempNonTurnDuelistCardID], a
	call SwapTurn
	xor a
	ld [wccec], a
	ld [wStatusConditionQueueIndex], a
	ld [wEffectFailed], a
	ld [wIsDamageToSelf], a
	ld [wDefendingWasForcedToSwitch], a
	ld [wMetronomeEnergyCost], a
	ld [wNoEffectFromWhichStatus], a
	bank1call ClearNonTurnTemporaryDuelvars_CopyStatus
	ret

; Use an attack (from DuelMenu_Attack) or a Pokemon Power (from DuelMenu_PkmnPower)
UseAttackOrPokemonPower::
	ld a, [wSelectedAttack]
	ld [wPlayerAttackingAttackIndex], a
	ldh a, [hTempCardIndex_ff9f]
	ld [wPlayerAttackingCardIndex], a
	ld a, [wTempCardID_ccc2]
	ld [wPlayerAttackingCardID], a
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	jp z, UsePokemonPower
	call UpdateArenaCardIDsAndClearTwoTurnDuelVars
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_1
	call TryExecuteEffectCommandFunction
	jp c, DrawWideTextBox_WaitForInput_ReturnCarry
	call CheckSandAttackOrSmokescreenSubstatus
	jr c, .sand_attack_smokescreen
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_2
	call TryExecuteEffectCommandFunction
	jp c, ReturnCarry
	call SendAttackDataToLinkOpponent
	jr .next
.sand_attack_smokescreen
	call SendAttackDataToLinkOpponent
	call HandleSandAttackOrSmokescreenSubstatus
	jp c, ClearNonTurnTemporaryDuelvars_ResetCarry
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_2
	call TryExecuteEffectCommandFunction
	jp c, ReturnCarry
.next
	ld a, OPPACTION_USE_ATTACK
	call SetOppAction_SerialSendDuelData
	ld a, EFFECTCMDTYPE_DISCARD_ENERGY
	call TryExecuteEffectCommandFunction
	call CheckSelfConfusionDamage
	jp c, HandleConfusionDamageToSelf
	call DrawDuelMainScene_PrintPokemonsAttackText
	call WaitForWideTextBoxInput
	call ExchangeRNG
	ld a, EFFECTCMDTYPE_REQUIRE_SELECTION
	call TryExecuteEffectCommandFunction
	ld a, OPPACTION_ATTACK_ANIM_AND_DAMAGE
	call SetOppAction_SerialSendDuelData
;	fallthrough

PlayAttackAnimation_DealAttackDamage::
	call Func_7415
	ld a, [wLoadedAttackCategory]
	and RESIDUAL
	jr nz, .deal_damage
	call SwapTurn
	call HandleNoDamageOrEffectSubstatus
	call SwapTurn
.deal_damage
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, EFFECTCMDTYPE_BEFORE_DAMAGE
	call TryExecuteEffectCommandFunction
	call ApplyDamageModifiers_DamageToTarget
	call ApplyTransparencyIfApplicable
	ld hl, wDealtDamage
	ld [hl], e
	inc hl
	ld [hl], d
	ld b, PLAY_AREA_ARENA
	ld a, [wDamageEffectiveness]
	ld c, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	push de
	push hl
	call PlayAttackAnimation
	call PlayStatusConditionQueueAnimations
	call WaitAttackAnimation
	pop hl
	pop de
	call SubtractHP
	ld a, [wDuelDisplayedScreen]
	cp DUEL_MAIN_SCENE
	jr nz, .skip_draw_huds
	push hl
	bank1call DrawDuelHUDs
	pop hl
.skip_draw_huds
	call PrintKnockedOutIfHLZero
	jr HandleAfterDamageEffects

; unreferenced
Func_17ed::
	call DrawWideTextBox_WaitForInput
	xor a
	ld hl, wDamage
	ld [hli], a
	ld [hl], a
	ld a, NO_DAMAGE_OR_EFFECT_AGILITY
	ld [wNoDamageOrEffect], a
;	fallthrough

HandleAfterDamageEffects::
	ld a, [wTempNonTurnDuelistCardID]
	push af
	ld a, EFFECTCMDTYPE_AFTER_DAMAGE
	call TryExecuteEffectCommandFunction
	pop af
	ld [wTempNonTurnDuelistCardID], a
	call HandleStrikesBack_AgainstResidualAttack
	bank1call ApplyStatusConditionQueue
	call Func_1bb4
	bank1call UpdateArenaCardLastTurnDamage
	call HandleDestinyBondAndBetweenTurnKnockOuts
	or a
	ret

DisplayUsePokemonPowerScreen_WaitForInput::
	push hl
	call DisplayUsePokemonPowerScreen
	pop hl
;	fallthrough

DrawWideTextBox_WaitForInput_ReturnCarry::
	call DrawWideTextBox_WaitForInput
;	fallthrough

ReturnCarry::
	scf
	ret

ClearNonTurnTemporaryDuelvars_ResetCarry::
	bank1call ClearNonTurnTemporaryDuelvars
	or a
	ret

; called when attacker deals damage to itself due to confusion
; display the corresponding animation and deal 20 damage to self
HandleConfusionDamageToSelf::
	bank1call DrawDuelMainScene
	ld a, 1
	ld [wIsDamageToSelf], a
	ldtx hl, DamageToSelfDueToConfusionText
	call DrawWideTextBox_PrintText
	ld a, ATK_ANIM_CONFUSION_HIT
	ld [wLoadedAttackAnimation], a
	ld a, 20 ; damage
	call DealConfusionDamageToSelf
	call Func_1bb4
	call HandleDestinyBondAndBetweenTurnKnockOuts
	bank1call ClearNonTurnTemporaryDuelvars
	or a
	ret

; use Pokemon Power
UsePokemonPower::
	call Func_7415
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_2
	call TryExecuteEffectCommandFunction
	jr c, DisplayUsePokemonPowerScreen_WaitForInput
	ld a, EFFECTCMDTYPE_REQUIRE_SELECTION
	call TryExecuteEffectCommandFunction
	jr c, ReturnCarry
	ld a, OPPACTION_USE_PKMN_POWER
	call SetOppAction_SerialSendDuelData
	call ExchangeRNG
	ld a, OPPACTION_EXECUTE_PKMN_POWER_EFFECT
	call SetOppAction_SerialSendDuelData
	ld a, EFFECTCMDTYPE_BEFORE_DAMAGE
	call TryExecuteEffectCommandFunction
	ld a, OPPACTION_DUEL_MAIN_SCENE
	call SetOppAction_SerialSendDuelData
	ret

; called by UseAttackOrPokemonPower (on an attack only)
; in a link duel, it's used to send the other game data about the
; attack being in use, triggering a call to OppAction_BeginUseAttack in the receiver
SendAttackDataToLinkOpponent::
	ld a, [wccec]
	or a
	ret nz
	ldh a, [hTemp_ffa0]
	push af
	ldh a, [hTempCardIndex_ff9f]
	push af
	ld a, $1
	ld [wccec], a
	ld a, [wPlayerAttackingCardIndex]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wPlayerAttackingAttackIndex]
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_BEGIN_ATTACK
	call SetOppAction_SerialSendDuelData
	call ExchangeRNG
	pop af
	ldh [hTempCardIndex_ff9f], a
	pop af
	ldh [hTemp_ffa0], a
	ret

ApplyTransparencyIfApplicable::
	ld a, [wLoadedAttackCategory]
	bit RESIDUAL_F, a
	ret nz
	ld a, [wNoDamageOrEffect]
	or a
	ret nz
	ld a, e
	or d
	jr nz, .asm_18b9
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetNonTurnDuelistVariable
	or a
	jr nz, .asm_18b9
	ld a, [wStatusConditionQueueIndex]
	or a
	ret z
.asm_18b9
	push de
	call SwapTurn
	xor a ; PLAY_AREA_ARENA
	ld [wTempPlayAreaLocation_cceb], a
	call HandleTransparency
	call SwapTurn
	pop de
	ret nc
	bank1call DrawDuelMainScene
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetNonTurnDuelistVariable
	ld [hl], $0
	ld de, 0
	ret

; return carry and TRUE in wConfusionAttackCheckWasUnsuccessful if damage will be dealt to oneself due to confusion
CheckSelfConfusionDamage::
	xor a ; FALSE
	ld [wConfusionAttackCheckWasUnsuccessful], a
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	cp CONFUSED
	jr z, .confused
	or a
	ret
.confused
	ldtx de, ConfusionCheckDamageText
	call TossCoin
	jr c, .no_confusion_damage
	ld a, TRUE
	ld [wConfusionAttackCheckWasUnsuccessful], a
	scf
	ret
.no_confusion_damage
	or a
	ret

; play the trainer card with deck index at hTempCardIndex_ff98.
; a trainer card is like an attack effect, with its own effect commands.
; return nc if the card was played, carry if it wasn't.
PlayTrainerCard::
	call CheckCantUseTrainerDueToEffect
	jr c, .cant_use
	ldh a, [hWhoseTurn]
	ld h, a
	ldh a, [hTempCardIndex_ff98]
	ldh [hTempCardIndex_ff9f], a
	call LoadNonPokemonCardEffectCommands
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_1
	call TryExecuteEffectCommandFunction
	jr nc, .can_use
.cant_use
	call DrawWideTextBox_WaitForInput
	scf
	ret
.can_use
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_2
	call TryExecuteEffectCommandFunction
	jr c, .done
	ld a, OPPACTION_PLAY_TRAINER
	call SetOppAction_SerialSendDuelData
	call DisplayUsedTrainerCardDetailScreen
	call ExchangeRNG
	ld a, EFFECTCMDTYPE_DISCARD_ENERGY
	call TryExecuteEffectCommandFunction
	ld a, EFFECTCMDTYPE_REQUIRE_SELECTION
	call TryExecuteEffectCommandFunction
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	call SetOppAction_SerialSendDuelData
	ld a, EFFECTCMDTYPE_BEFORE_DAMAGE
	call TryExecuteEffectCommandFunction
	ldh a, [hTempCardIndex_ff9f]
	call MoveHandCardToDiscardPile
	call ExchangeRNG
.done
	or a
	ret

; loads the effect commands of a (trainer or energy) card with deck index (0-59) at hTempCardIndex_ff9f
; into wLoadedAttackEffectCommands. in practice, only used for trainer cards
LoadNonPokemonCardEffectCommands::
	ldh a, [hTempCardIndex_ff9f]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld hl, wLoadedCard1EffectCommands
	ld de, wLoadedAttackEffectCommands
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

; Make turn holder deal A damage to self due to recoil (e.g. Thrash, Selfdestruct)
; display recoil animation
DealRecoilDamageToSelf::
	push af
	ld a, ATK_ANIM_RECOIL_HIT
	ld [wLoadedAttackAnimation], a
	pop af
;	fallthrough

; Make turn holder deal A damage to self due to confusion
; display animation at wLoadedAttackAnimation
DealConfusionDamageToSelf::
	ld hl, wDamage
	ld [hli], a
	ld [hl], 0
	ld a, [wNoDamageOrEffect]
	push af
	xor a
	ld [wNoDamageOrEffect], a
	bank1call Func_7415
	ld a, [wTempNonTurnDuelistCardID]
	push af
	ld a, [wTempTurnDuelistCardID]
	ld [wTempNonTurnDuelistCardID], a
	bank1call ApplyDamageModifiers_DamageToSelf ; this is at bank 0
	ld a, [wDamageEffectiveness]
	ld c, a
	ld b, PLAY_AREA_ARENA
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	bank1call PlayAttackAnimation_DealAttackDamageSimple
	call PrintKnockedOutIfHLZero
	pop af
	ld [wTempNonTurnDuelistCardID], a
	pop af
	ld [wNoDamageOrEffect], a
	ret

; given a damage value at wDamage:
; - if the non-turn holder's arena card is weak to the turn holder's arena card color: double damage
; - if the non-turn holder's arena card resists the turn holder's arena card color: reduce damage by 30
; - also apply Pluspower, Defender, and other kinds of damage reduction accordingly
; return resulting damage in de
ApplyDamageModifiers_DamageToTarget::
	xor a
	ld [wDamageEffectiveness], a
	ld hl, wDamage
	ld a, [hli]
	or [hl]
	jr nz, .non_zero_damage
	ld de, 0
	ret
.non_zero_damage
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	ld d, [hl]
	dec hl
	ld e, [hl]
	bit UNAFFECTED_BY_WEAKNESS_RESISTANCE_F, d
	jr z, .affected_by_wr
	res UNAFFECTED_BY_WEAKNESS_RESISTANCE_F, d
	xor a
	ld [wDamageEffectiveness], a
	call HandleDoubleDamageSubstatus
	jr .check_pluspower_and_defender
.affected_by_wr
	call HandleDoubleDamageSubstatus
	ld a, e
	or d
	ret z
	ldh a, [hTempPlayAreaLocation_ff9d]
	call GetPlayAreaCardColor
	call TranslateColorToWR
	ld b, a
	call SwapTurn
	call GetArenaCardWeakness
	call SwapTurn
	and b
	jr z, .not_weak
	sla e
	rl d
	ld hl, wDamageEffectiveness
	set WEAKNESS, [hl]
.not_weak
	call SwapTurn
	call GetArenaCardResistance
	call SwapTurn
	and b
	jr z, .check_pluspower_and_defender ; jump if not resistant
	ld hl, -30
	add hl, de
	ld e, l
	ld d, h
	ld hl, wDamageEffectiveness
	set RESISTANCE, [hl]
.check_pluspower_and_defender
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	call SwapTurn
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedDefender
	call HandleDamageReduction
	bit 7, d
	jr z, .no_underflow
	ld de, 0
.no_underflow
	call SwapTurn
	ret

; convert a color to its equivalent WR_* (weakness/resistance) value
TranslateColorToWR::
	push hl
	add LOW(InvertedPowersOf2)
	ld l, a
	ld a, HIGH(InvertedPowersOf2)
	adc $0
	ld h, a
	ld a, [hl]
	pop hl
	ret

InvertedPowersOf2::
	db $80, $40, $20, $10, $08, $04, $02, $01

; given a damage value at wDamage:
; - if the turn holder's arena card is weak to its own color: double damage
; - if the turn holder's arena card resists its own color: reduce damage by 30
; return resulting damage in de
ApplyDamageModifiers_DamageToSelf::
	xor a
	ld [wDamageEffectiveness], a
	ld hl, wDamage
	ld a, [hli]
	or [hl]
	or a
	jr z, .no_damage
	ld d, [hl]
	dec hl
	ld e, [hl]
	call GetArenaCardColor
	call TranslateColorToWR
	ld b, a
	call GetArenaCardWeakness
	and b
	jr z, .not_weak
	sla e
	rl d
	ld hl, wDamageEffectiveness
	set WEAKNESS, [hl]
.not_weak
	call GetArenaCardResistance
	and b
	jr z, .not_resistant
	ld hl, -30
	add hl, de
	ld e, l
	ld d, h
	ld hl, wDamageEffectiveness
	set RESISTANCE, [hl]
.not_resistant
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedDefender
	bit 7, d ; test for underflow
	ret z
.no_damage
	ld de, 0
	ret

; increases de by 10 points for each Pluspower found in location b
ApplyAttachedPluspower::
	push de
	call GetTurnDuelistVariable
	ld de, PLUSPOWER
	call CountCardIDInLocation
	ld l, a
	ld h, 10
	call HtimesL
	pop de
	add hl, de
	ld e, l
	ld d, h
	ret

; reduces de by 20 points for each Defender found in location b
ApplyAttachedDefender::
	push de
	call GetTurnDuelistVariable
	ld de, DEFENDER
	call CountCardIDInLocation
	ld l, a
	ld h, 20
	call HtimesL
	pop de
	ld a, e
	sub l
	ld e, a
	ld a, d
	sbc h
	ld d, a
	ret

; hl: address to subtract HP from
; de: how much HP to subtract (damage to deal)
; returns carry if the HP does not become 0 as a result
SubtractHP::
	push hl
	push de
	ld a, [hl]
	sub e
	ld [hl], a
	ld a, $0
	sbc d
	and $80
	jr z, .no_underflow
	ld [hl], 0
.no_underflow
	ld a, [hl]
	or a
	jr z, .zero
	scf
.zero
	pop de
	pop hl
	ret

; given a play area location offset in a, check if the turn holder's Pokemon card in
; that location has no HP left, and, if so, print that it was knocked out.
PrintPlayAreaCardKnockedOutIfNoHP::
	ld e, a
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	ret nz ; return if arena card has non-0 HP
	ld a, [wTempNonTurnDuelistCardID]
	push af
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1ID]
	ld [wTempNonTurnDuelistCardID], a
	call PrintKnockedOut
	pop af
	ld [wTempNonTurnDuelistCardID], a
	scf
	ret

PrintKnockedOutIfHLZero::
	ld a, [hl] ; this is supposed to point to a remaining HP value after some form of damage calculation
	or a
	ret nz
;	fallthrough

; print in a text box that the Pokemon card at wTempNonTurnDuelistCardID
; was knocked out and wait 40 frames
PrintKnockedOut::
	ld a, [wTempNonTurnDuelistCardID]
	ld e, a
	call LoadCardDataToBuffer1_FromCardID
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ldtx hl, WasKnockedOutText
	call DrawWideTextBox_PrintText
	ld a, 40
.wait_frames
	call DoFrame
	dec a
	jr nz, .wait_frames
	scf
	ret

; deal damage to turn holder's Pokemon card at play area location at b (PLAY_AREA_*).
; damage to deal is given in de.
; shows the defending player's play area screen when dealing the damage
; instead of the main duel interface with regular attack animation.
DealDamageToPlayAreaPokemon_RegularAnim::
	ld a, ATK_ANIM_BENCH_HIT
	ld [wLoadedAttackAnimation], a
;	fallthrough

; deal damage to turn holder's Pokemon card at play area location at b (PLAY_AREA_*).
; damage to deal is given in de.
; shows the defending player's play area screen when dealing the damage
; instead of the main duel interface.
; plays animation that is loaded in wLoadedAttackAnimation.
DealDamageToPlayAreaPokemon::
	ld a, b
	ld [wTempPlayAreaLocation_cceb], a
	or a ; cp PLAY_AREA_ARENA
	jr nz, .skip_no_damage_or_effect_check
	ld a, [wNoDamageOrEffect]
	or a
	ret nz
.skip_no_damage_or_effect_check
	push hl
	push de
	push bc
	xor a
	ld [wNoDamageOrEffect], a
	push de
	ld a, [wTempPlayAreaLocation_cceb]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempNonTurnDuelistCardID], a
	pop de
	ld a, [wTempPlayAreaLocation_cceb]
	or a ; cp PLAY_AREA_ARENA
	jr nz, .next
	ld a, [wIsDamageToSelf]
	or a
	jr z, .turn_swapped
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	jr .next
.turn_swapped
	call SwapTurn
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	call SwapTurn
.next
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	jr z, .skip_defender
	ld a, [wTempPlayAreaLocation_cceb]
	or CARD_LOCATION_PLAY_AREA
	ld b, a
	call ApplyAttachedDefender
.skip_defender
	ld a, [wTempPlayAreaLocation_cceb]
	or a ; cp PLAY_AREA_ARENA
	jr nz, .in_bench
	push de
	call HandleNoDamageOrEffectSubstatus
	pop de
	call HandleDamageReduction
.in_bench
	bit 7, d
	jr z, .no_underflow
	ld de, 0
.no_underflow
	call HandleDamageReductionOrNoDamageFromPkmnPowerEffects
	ld a, [wTempPlayAreaLocation_cceb]
	ld b, a
	or a ; cp PLAY_AREA_ARENA
	jr nz, .benched
	; if arena Pokemon, add damage at de to [wDealtDamage]
	ld hl, wDealtDamage
	ld a, e
	add [hl]
	ld [hli], a
	ld a, d
	adc [hl]
	ld [hl], a
.benched
	ld c, $00
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	push af
	bank1call PlayAttackAnimation_DealAttackDamageSimple
	pop af
	or a
	jr z, .skip_knocked_out
	push de
	call PrintKnockedOutIfHLZero
	pop de
.skip_knocked_out
	call HandleStrikesBack_AgainstDamagingAttack
	pop bc
	pop de
	pop hl
	ret

; draw duel main scene, then print the "<Pokemon Lvxx>'s <attack>" text
; The Pokemon's name is the turn holder's arena Pokemon, and the
; attack's name is taken from wLoadedAttackName.
DrawDuelMainScene_PrintPokemonsAttackText::
	bank1call DrawDuelMainScene
;	fallthrough

; print the "<Pokemon Lvxx>'s <attack>" text
; The Pokemon's name is the turn holder's arena Pokemon, and the
; attack's name is taken from wLoadedAttackName.
PrintPokemonsAttackText::
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, 18
	call CopyCardNameAndLevel
	ld [hl], TX_END
	; zero wTxRam2 so that the name & level text just loaded to wDefaultText is printed
	ld hl, wTxRam2
	xor a
	ld [hli], a
	ld [hli], a
	ld a, [wLoadedAttackName]
	ld [hli], a ; wTxRam2_b
	ld a, [wLoadedAttackName + 1]
	ld [hli], a
	ldtx hl, PokemonsAttackText
	call DrawWideTextBox_PrintText
	ret

Func_1bb4::
	call FinishQueuedAnimations
	bank1call DrawDuelMainScene
	call DrawDuelHUDs
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call PrintFailedEffectText
	call WaitForWideTextBoxInput
	call ExchangeRNG
	ret

; prints one of the ThereWasNoEffectFrom*Text if wEffectFailed contains EFFECT_FAILED_NO_EFFECT,
; and prints WasUnsuccessfulText if wEffectFailed contains EFFECT_FAILED_UNSUCCESSFUL
PrintFailedEffectText::
	ld a, [wEffectFailed]
	or a
	ret z
	cp $1
	jr z, .no_effect_from_status
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, 18
	call CopyCardNameAndLevel
	; zero wTxRam2 so that the name & level text just loaded to wDefaultText is printed
	ld [hl], $0
	ld hl, $0000
	call LoadTxRam2
	ld hl, wLoadedAttackName
	ld de, wTxRam2_b
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ldtx hl, WasUnsuccessfulText
	call DrawWideTextBox_PrintText
	scf
	ret
.no_effect_from_status
	call PrintThereWasNoEffectFromStatusText
	call DrawWideTextBox_PrintText
	scf
	ret

; return in a the retreat cost of the turn holder's arena or bench Pokemon
; given the PLAY_AREA_* value in hTempPlayAreaLocation_ff9d
GetPlayAreaCardRetreatCost::
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	call GetLoadedCard1RetreatCost
	ret

; move all turn holder's card with ID at de to the discard pile
; that are currently in the Play Area
; this is used to discard all attached Pluspowers and Defenders
MoveCardToDiscardPileIfInPlayArea::
	ld c, e
	ld b, d
	ld l, DUELVARS_CARD_LOCATIONS
.next_card
	ld a, [hl]
	and CARD_LOCATION_PLAY_AREA
	jr z, .skip ; jump if card not in arena
	ld a, l
	call GetCardIDFromDeckIndex
	ld a, c
	cp e
	jr nz, .skip ; jump if not the card id provided in c
	ld a, b
	cp d ; card IDs are 8-bit so d is always 0
	jr nz, .skip
	ld a, l
	push bc
	call PutCardInDiscardPile
	pop bc
.skip
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .next_card
	ret

; calculate damage and max HP of card at PLAY_AREA_* in e.
; input:
;	e = PLAY_AREA_* of card;
; output:
;	a = damage;
;	c = max HP.
GetCardDamageAndMaxHP::
	push hl
	push de
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	pop de
	push de
	ld a, DUELVARS_ARENA_CARD_HP
	add e
	call GetTurnDuelistVariable
	ld a, [wLoadedCard2HP]
	ld c, a
	sub [hl]
	pop de
	pop hl
	ret

; check if a flag of wLoadedAttack is set
; input:
   ; a = %fffffbbb, where
      ; fffff = flag address counting from wLoadedAttackFlag1
      ; bbb = flag bit
; return carry if the flag is set
CheckLoadedAttackFlag::
	push hl
	push de
	push bc
	ld c, a ; %fffffbbb
	and $07
	ld e, a
	ld d, $00
	ld hl, PowersOf2
	add hl, de
	ld b, [hl]
	ld a, c
	rra
	rra
	rra
	and $1f
	ld e, a ; %000fffff
	ld hl, wLoadedAttackFlag1
	add hl, de
	ld a, [hl]
	and b
	jr z, .done
	scf ; set carry if the attack has this flag set
.done
	pop bc
	pop de
	pop hl
	ret

; returns [hWhoseTurn] <-- ([hWhoseTurn] ^ $1)
;   As a side effect, this also returns a duelist variable in a similar manner to
;   GetNonTurnDuelistVariable, but this function appears to be
;   only called to swap the turn value.
SwapTurn::
	push af
	push hl
	call GetNonTurnDuelistVariable
	ld a, h
	ldh [hWhoseTurn], a
	pop hl
	pop af
	ret

; copy the TX_END-terminated player's name from sPlayerName to de
CopyPlayerName::
	call EnableSRAM
	ld hl, sPlayerName
.loop
	ld a, [hli]
	ld [de], a
	inc de
	or a ; TX_END
	jr nz, .loop
	dec de
	call DisableSRAM
	ret

; copy the opponent's name to de
; if text ID at wOpponentName is non-0, copy it from there
; else, if text at wc500 is non-0, copy if from there
; else, copy Player2Text
CopyOpponentName::
	ld hl, wOpponentName
	ld a, [hli]
	or [hl]
	jr z, .special_name
	ld a, [hld]
	ld l, [hl]
	ld h, a
	jp CopyText
.special_name
	ld hl, wNameBuffer
	ld a, [hl]
	or a
	jr z, .print_player2
	jr CopyPlayerName.loop
.print_player2
	ldtx hl, Player2Text
	jp CopyText
