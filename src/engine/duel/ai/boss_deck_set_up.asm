; sets up the initial hand of boss deck.
; always draws at least 2 Basic Pokemon cards and 2 Energy cards.
; also sets up so that the next cards to be drawn have
; some minimum number of Basic Pokemon and Energy cards.
SetUpBossStartingHandAndDeck:
; shuffle all hand cards in deck
	ld a, DUELVARS_HAND
	call GetTurnDuelistVariable
	ld b, STARTING_HAND_SIZE
.loop_hand
	ld a, [hl]
	call RemoveCardFromHand
	call ReturnCardToDeck
	dec b
	jr nz, .loop_hand
	jr .count_energy_basic

.shuffle_deck
	call ShuffleDeck

; count number of Energy and basic Pokemon cards
; in the first STARTING_HAND_SIZE in deck.
.count_energy_basic
	xor a
	ld [wAISetupBasicPokemonCount], a
	ld [wAISetupEnergyCount], a

	ld a, DUELVARS_DECK_CARDS
	call GetTurnDuelistVariable
	ld b, STARTING_HAND_SIZE
.loop_deck_1
	ld a, [hli]
	push bc
	call LoadCardDataToBuffer1_FromDeckIndex
	pop bc
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr c, .pokemon_card_1
	cp TYPE_TRAINER
	jr z, .next_card_deck_1

; energy card
	ld a, [wAISetupEnergyCount]
	inc a
	ld [wAISetupEnergyCount], a
	jr .next_card_deck_1

.pokemon_card_1
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .next_card_deck_1 ; not basic
	ld a, [wAISetupBasicPokemonCount]
	inc a
	ld [wAISetupBasicPokemonCount], a

.next_card_deck_1
	dec b
	jr nz, .loop_deck_1

; tally the number of Energy and basic Pokemon cards
; and if any of them is smaller than 2, re-shuffle deck.
	ld a, [wAISetupBasicPokemonCount]
	cp 2
	jr c, .shuffle_deck
	ld a, [wAISetupEnergyCount]
	cp 2
	jr c, .shuffle_deck

; now check the following 6 cards (prize cards).
; re-shuffle deck if any of these cards is listed in wAICardListAvoidPrize.
	ld b, 6
.check_card_ids
	ld a, [hli]
	push bc
	call .CheckIfIDIsInList
	pop bc
	jr c, .shuffle_deck
	dec b
	jr nz, .check_card_ids

; finally, check 6 cards after that.
; if Energy or Basic Pokemon counter is below 4
; (counting with the ones found in the initial hand)
; then re-shuffle deck.
	ld b, 6
.loop_deck_2
	ld a, [hli]
	push bc
	call LoadCardDataToBuffer1_FromDeckIndex
	pop bc
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr c, .pokemon_card_2
	cp TYPE_TRAINER
	jr z, .next_card_deck_2

; energy card
	ld a, [wAISetupEnergyCount]
	inc a
	ld [wAISetupEnergyCount], a
	jr .next_card_deck_2

.pokemon_card_2
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .next_card_deck_2
	ld a, [wAISetupBasicPokemonCount]
	inc a
	ld [wAISetupBasicPokemonCount], a

.next_card_deck_2
	dec b
	jr nz, .loop_deck_2

	ld a, [wAISetupBasicPokemonCount]
	cp 4
	jp c, .shuffle_deck
	ld a, [wAISetupEnergyCount]
	cp 4
	jp c, .shuffle_deck

; draw new set of hand cards
	ld a, DUELVARS_DECK_CARDS
	call GetTurnDuelistVariable
	ld b, STARTING_HAND_SIZE
.draw_loop
	ld a, [hli]
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	dec b
	jr nz, .draw_loop
	ret

; expectation: return carry if card ID corresponding
; to the input deck index is listed in wAICardListAvoidPrize;
; reality: always returns no carry because when checking terminating
; byte in wAICardListAvoidPrize ($00), it wrongfully uses 'cp a' instead of 'or a',
; so it always ends up returning in the first item in list.
; input:
;	- a = deck index of card to check
.CheckIfIDIsInList ; 17366 (5:7366)
	ld b, a
	ld a, [wAICardListAvoidPrize + 1]
	or a
	ret z ; null
	push hl
	ld h, a
	ld a, [wAICardListAvoidPrize]
	ld l, a

	ld a, b
	call GetCardIDFromDeckIndex
.loop_id_list
	ld a, [hli]
	cp a ; bug, should be 'or a'
	jr z, .false
	cp e
	jr nz, .loop_id_list

; true
	pop hl
	scf
	ret
.false
	pop hl
	or a
	ret
