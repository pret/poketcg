; determine whether AI plays
; basic cards from hand
AIDecidePlayPokemonCard:
	call CreateHandCardList
	call SortTempHandByIDList
	ld hl, wDuelTempList
	ld de, wHandTempList
	call CopyHandCardList
	ld hl, wHandTempList

.next_hand_card
	ld a, [hli]
	cp $ff
	jp z, AIDecideEvolution

	ld [wTempAIPokemonCard], a
	push hl
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .skip
	; skip non-pokemon cards

	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .skip
	; skip non-basic pokemon

	ld a, 130
	ld [wAIScore], a
	call AIDecidePlayLegendaryBirds

; if Play Area has more than 4 Pokémon, decrease AI score
; else, increase AI score
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 4
	jr c, .has_4_or_fewer
	ld a, 20
	call SubFromAIScore
	jr .check_defending_can_ko
.has_4_or_fewer
	ld a, 50
	call AddToAIScore

; if defending Pokémon can KO active card, increase AI score
.check_defending_can_ko
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfDefendingPokemonCanKnockOut
	jr nc, .check_energy_cards
	ld a, 20
	call AddToAIScore

; if energy cards are found in hand
; for this card's attacks, raise AI score
.check_energy_cards
	ld a, [wTempAIPokemonCard]
	call GetAttacksEnergyCostBits
	call CheckEnergyFlagsNeededInList
	jr nc, .check_evolution_hand
	ld a, 20
	call AddToAIScore

; if evolution card is found in hand
; for this card, raise AI score
.check_evolution_hand
	ld a, [wTempAIPokemonCard]
	call CheckForEvolutionInList
	jr nc, .check_evolution_deck
	ld a, 20
	call AddToAIScore

; if evolution card is found in deck
; for this card, raise AI score
.check_evolution_deck
	ld a, [wTempAIPokemonCard]
	call CheckForEvolutionInDeck
	jr nc, .check_score
	ld a, 10
	call AddToAIScore

; if AI score is >= 180, play card from hand
.check_score
	ld a, [wAIScore]
	cp 180
	jr c, .skip
	ld a, [wTempAIPokemonCard]
	ldh [hTemp_ffa0], a
	call CheckIfCardCanBePlayed
	jr c, .skip
	ld a, OPPACTION_PLAY_BASIC_PKMN
	bank1call AIMakeDecision
	jr c, .done
.skip
	pop hl
	jp .next_hand_card
.done
	pop hl
	ret

; determine whether AI evolves
; Pokémon in the Play Area
AIDecideEvolution:
	call CreateHandCardList
	ld hl, wDuelTempList
	ld de, wHandTempList
	call CopyHandCardList
	ld hl, wHandTempList

.next_hand_card
	ld a, [hli]
	cp $ff
	jp z, .done
	ld [wTempAIPokemonCard], a

; check if Prehistoric Power is active
; and if so, skip to next card in hand
	push hl
	call IsPrehistoricPowerActive
	jp c, .done_hand_card

; load evolution data to buffer1
; skip if it's not a Pokémon card
; and if it's a basic stage card
	ld a, [wTempAIPokemonCard]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jp nc, .done_hand_card
	ld a, [wLoadedCard1Stage]
	or a
	jp z, .done_hand_card

; start looping Pokémon in Play Area
; to find a card to evolve
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld b, 0
.next_bench_pokemon
	push bc
	ld e, b
	ld a, [wTempAIPokemonCard]
	ld d, a
	call CheckIfCanEvolveInto
	pop bc
	push bc
	jp c, .done_bench_pokemon

; store this Play Area location in wTempAI
; and initialize the AI score
	ld a, b
	ld [wTempAI], a
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, $80
	ld [wAIScore], a
	call AIDecideSpecialEvolutions

; check if the card can use any attacks
; and if any of those attacks can KO
	xor a
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	jr nc, .can_attack
	ld a, $01
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	jr c, .cant_attack_or_ko
.can_attack
	ld a, $01
	ld [wCurCardCanAttack], a
	call CheckIfAnyAttackKnocksOutDefendingCard
	jr nc, .check_evolution_attacks
	call CheckIfSelectedAttackIsUnusable
	jr c, .check_evolution_attacks
	ld a, $01
	ld [wCurCardCanKO], a
	jr .check_evolution_attacks
.cant_attack_or_ko
	xor a
	ld [wCurCardCanAttack], a
	ld [wCurCardCanKO], a

; check evolution to see if it can use any of its attacks:
; if it can, raise AI score;
; if it can't, decrease AI score and if an energy card that is needed
; can be played from the hand, raise AI score.
.check_evolution_attacks
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	push af
	ld a, [wTempAIPokemonCard]
	ld [hl], a
	xor a
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	jr nc, .evolution_can_attack
	ld a, $01
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	jr c, .evolution_cant_attack
.evolution_can_attack
	ld a, 5
	call AddToAIScore
	jr .check_evolution_ko
.evolution_cant_attack
	ld a, [wCurCardCanAttack]
	or a
	jr z, .check_evolution_ko
	ld a, 2
	call SubFromAIScore
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .check_evolution_ko
	call LookForEnergyNeededInHand
	jr nc, .check_evolution_ko
	ld a, 7
	call AddToAIScore

; if it's an active card:
; if evolution can't KO but the current card can, lower AI score;
; if evolution can KO as well, raise AI score.
.check_evolution_ko
	ld a, [wCurCardCanAttack]
	or a
	jr z, .check_defending_can_ko_evolution
	ld a, [wTempAI]
	or a
	jr nz, .check_defending_can_ko_evolution
	call CheckIfAnyAttackKnocksOutDefendingCard
	jr nc, .evolution_cant_ko
	call CheckIfSelectedAttackIsUnusable
	jr c, .evolution_cant_ko
	ld a, 5
	call AddToAIScore
	jr .check_defending_can_ko_evolution
.evolution_cant_ko
	ld a, [wCurCardCanKO]
	or a
	jr z, .check_defending_can_ko_evolution
	ld a, 20
	call SubFromAIScore

; if defending Pokémon can KO evolution, lower AI score
.check_defending_can_ko_evolution
	ld a, [wTempAI]
	or a
	jr nz, .check_mr_mime
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfDefendingPokemonCanKnockOut
	jr nc, .check_mr_mime
	ld a, 5
	call SubFromAIScore

; if evolution can't damage player's Mr Mime, lower AI score
.check_mr_mime
	ld a, [wTempAI]
	call CheckDamageToMrMime
	jr c, .check_defending_can_ko
	ld a, 20
	call SubFromAIScore

; if defending Pokémon can KO current card, raise AI score
.check_defending_can_ko
	ld a, [wTempAI]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	ld a, [wTempAI]
	or a
	jr nz, .check_2nd_stage_hand
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfDefendingPokemonCanKnockOut
	jr nc, .check_status
	ld a, 5
	call AddToAIScore

; if current card has a status condition, raise AI score
.check_status
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	or a
	jr z, .check_2nd_stage_hand
	ld a, 4
	call AddToAIScore

; if hand has 2nd stage card to evolve evolution card, raise AI score
.check_2nd_stage_hand
	ld a, [wTempAIPokemonCard]
	call CheckForEvolutionInList
	jr nc, .check_2nd_stage_deck
	ld a, 2
	call AddToAIScore
	jr .check_damage

; if deck has 2nd stage card to evolve evolution card, raise AI score
.check_2nd_stage_deck
	ld a, [wTempAIPokemonCard]
	call CheckForEvolutionInDeck
	jr nc, .check_damage
	ld a, 1
	call AddToAIScore

; decrease AI score proportional to damage
; AI score -= floor(Damage / 40)
.check_damage
	ld a, [wTempAI]
	ld e, a
	call GetCardDamageAndMaxHP
	or a
	jr z, .check_mysterious_fossil
	srl a
	srl a
	call CalculateByteTensDigit
	call SubFromAIScore

; if is Mysterious Fossil or
; wLoadedCard1Unknown2 is set to $02,
; raise AI score
.check_mysterious_fossil
	ld a, [wTempAI]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1ID]
	cp MYSTERIOUS_FOSSIL
	jr z, .mysterious_fossil
	ld a, [wLoadedCard1Unknown2]
	cp $02
	jr nz, .pikachu_deck
	ld a, 2
	call AddToAIScore
	jr .pikachu_deck

.mysterious_fossil
	ld a, 5
	call AddToAIScore

; in Pikachu Deck, decrease AI score for evolving Pikachu
.pikachu_deck
	ld a, [wOpponentDeckID]
	cp PIKACHU_DECK_ID
	jr nz, .check_score
	ld a, [wLoadedCard1ID]
	cp PIKACHU_LV12
	jr z, .pikachu
	cp PIKACHU_LV14
	jr z, .pikachu
	cp PIKACHU_LV16
	jr z, .pikachu
	cp PIKACHU_ALT_LV16
	jr nz, .check_score
.pikachu
	ld a, 3
	call SubFromAIScore

; if AI score >= 133, go through with the evolution
.check_score
	ld a, [wAIScore]
	cp 133
	jr c, .done_bench_pokemon
	ld a, [wTempAI]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, [wTempAIPokemonCard]
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_EVOLVE_PKMN
	bank1call AIMakeDecision
	pop bc
	jr .done_hand_card

.done_bench_pokemon
	pop bc
	inc b
	dec c
	jp nz, .next_bench_pokemon
.done_hand_card
	pop hl
	jp .next_hand_card
.done
	or a
	ret

; determine AI score for evolving
; Charmeleon, Magikarp, Dragonair and Grimer
; in certain decks
AIDecideSpecialEvolutions:
; check if deck applies
	ld a, [wOpponentDeckID]
	cp LEGENDARY_DRAGONITE_DECK_ID
	jr z, .legendary_dragonite
	cp INVINCIBLE_RONALD_DECK_ID
	jr z, .invincible_ronald
	cp LEGENDARY_RONALD_DECK_ID
	jr z, .legendary_ronald
	ret

.legendary_dragonite
	ld a, [wLoadedCard2ID]
	cp CHARMELEON
	jr z, .charmeleon
	cp MAGIKARP
	jr z, .magikarp
	cp DRAGONAIR
	jr z, .dragonair
	ret

; check if number of energy cards attached to Charmeleon are at least 3
; and if adding the energy cards in hand makes at least 6 energy cards
.charmeleon
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call CountNumberOfEnergyCardsAttached
	cp 3
	jr c, .not_enough_energy
	push af
	farcall CountOppEnergyCardsInHand
	pop bc
	add b
	cp 6
	jr c, .not_enough_energy
	ld a, 3
	call AddToAIScore
	ret
.not_enough_energy
	ld a, 10
	call SubFromAIScore
	ret

; check if Magikarp is not the active card
; and has at least 2 energy cards attached
.magikarp
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a ; active card
	ret z
	ld e, a
	call CountNumberOfEnergyCardsAttached
	cp 2
	ret c
	ld a, 3
	call AddToAIScore
	ret

.invincible_ronald
	ld a, [wLoadedCard2ID]
	cp GRIMER
	jr z, .grimer
	ret

; check if Grimer is not active card
.grimer
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a ; active card
	ret z
	ld a, 10
	call AddToAIScore
	ret

.legendary_ronald
	ld a, [wLoadedCard2ID]
	cp DRAGONAIR
	jr z, .dragonair
	ret

.dragonair
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a ; active card
	jr z, .is_active

; if Dragonair is benched, check all Pokémon in Play Area
; and sum all the damage in HP of all cards
; if this result is >= 70, check if there's
; a Muk in any duelist's Play Area
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld b, a
	ld c, 0
.loop
	dec b
	ld e, b
	push bc
	call GetCardDamageAndMaxHP
	pop bc
	add c
	ld c, a
	ld a, b
	or a
	jr nz, .loop
	ld a, 70
	cp c
	jr c, .check_muk
.lower_score
	ld a, 10
	call SubFromAIScore
	ret

; if there's no Muk, raise score
.check_muk
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .lower_score
	ld a, 10
	call AddToAIScore
	ret

; if Dragonair is active, check its damage in HP
; if this result is >= 50,
; and if at least 3 energy cards attached,
; check if there's a Muk in any duelist's Play Area
.is_active
	ld e, 0
	call GetCardDamageAndMaxHP
	cp 50
	jr c, .lower_score
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	cp 3
	jr c, .lower_score
	jr .check_muk

; determine AI score for the legendary cards
; Moltres, Zapdos and Articuno
AIDecidePlayLegendaryBirds:
; check if deck applies
	ld a, [wOpponentDeckID]
	cp LEGENDARY_ZAPDOS_DECK_ID
	jr z, .begin
	cp LEGENDARY_ARTICUNO_DECK_ID
	jr z, .begin
	cp LEGENDARY_RONALD_DECK_ID
	jr z, .begin
	ret

; check if card applies
.begin
	ld a, [wLoadedCard1ID]
	cp ARTICUNO_LV37
	jr z, .articuno
	cp MOLTRES_LV37
	jr z, .moltres
	cp ZAPDOS_LV68
	jr z, .zapdos
	ret

.articuno
	; exit if not enough Pokemon in Play Area
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 2
	ret c

	call CheckIfActiveCardCanKnockOut
	jr c, .subtract
	call CheckIfActivePokemonCanUseAnyNonResidualAttack
	jr nc, .subtract
	call AIDecideWhetherToRetreat
	jr c, .subtract

	; checks for player's active card status
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	and CNF_SLP_PRZ
	or a
	jr nz, .subtract

	; checks for player's Pokemon Power
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld e, $00
	call CopyAttackDataAndDamage_FromDeckIndex
	call SwapTurn
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	jr z, .check_muk_and_snorlax

	; return if no space on the bench
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_BENCH_POKEMON
	jr c, .check_muk_and_snorlax
	ret

.check_muk_and_snorlax
	; checks for Muk in both Play Areas
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .subtract
	; checks if player's active card is Snorlax
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp SNORLAX
	jr z, .subtract

; add
	ld a, 70
	call AddToAIScore
	ret
.subtract
	ld a, 100
	call SubFromAIScore
	ret

.moltres
	; checks if there's enough cards in deck
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp 56 ; max number of cards not in deck to activate
	jr nc, .subtract
	ret

.zapdos
	; checks for Muk in both Play Areas
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .subtract
	ret
