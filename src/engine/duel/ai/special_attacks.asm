; this function handles attacks with the SPECIAL_AI_HANDLING set,
; and makes specific checks in each of these attacks
; to either return a positive score (value above $80)
; or a negative score (value below $80).
; input:
;	hTempPlayAreaLocation_ff9d = location of card with attack.
HandleSpecialAIAttacks:
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e

	cp NIDORANF
	jr z, .NidoranFCallForFamily
	cp ODDISH
	jr z, .CallForFamily
	cp BELLSPROUT
	jr z, .CallForFamily
	cp EXEGGUTOR
	jp z, .Teleport
	cp SCYTHER
	jp z, .SwordsDanceAndFocusEnergy
	cp KRABBY
	jr z, .CallForFamily
	cp VAPOREON_LV29
	jp z, .SwordsDanceAndFocusEnergy
	cp ELECTRODE_LV42
	jp z, .ChainLightning
	cp MAROWAK_LV26
	jr z, .CallForFriend
	cp MEW_LV23
	jp z, .DevolutionBeam
	cp JIGGLYPUFF_LV13
	jp z, .FriendshipSong
	cp PORYGON
	jp z, .Conversion
	cp MEWTWO_ALT_LV60
	jp z, .EnergyAbsorption
	cp MEWTWO_LV60
	jp z, .EnergyAbsorption
	cp NINETALES_LV35
	jp z, .MixUp
	cp ZAPDOS_LV68
	jp z, .BigThunder
	cp KANGASKHAN
	jp z, .Fetch
	cp DUGTRIO
	jp z, .Earthquake
	cp ELECTRODE_LV35
	jp z, .EnergySpike
	cp GOLDUCK
	jp z, .HyperBeam
	cp DRAGONAIR
	jp z, .HyperBeam

; return zero score.
.zero_score
	xor a
	ret

; if any of card ID in a is found in deck,
; return a score of $80 + slots available in bench.
.CallForFamily:
	ld a, CARD_LOCATION_DECK
	call LookForCardIDInLocation_Bank5
	jr nc, .zero_score
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_BENCH_POKEMON
	jr nc, .zero_score
	ld b, a
	ld a, MAX_BENCH_POKEMON
	sub b
	add $80
	ret

; if any of NidoranM or NidoranF is found in deck,
; return a score of $80 + slots available in bench.
.NidoranFCallForFamily:
	ld e, NIDORANM
	ld a, CARD_LOCATION_DECK
	call LookForCardIDInLocation_Bank5
	jr c, .found_nidoran
	ld e, NIDORANF
	ld a, CARD_LOCATION_DECK
	call LookForCardIDInLocation_Bank5
	jr nc, .zero_score
.found_nidoran
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .zero_score
	ld b, a
	ld a, MAX_PLAY_AREA_POKEMON
	sub b
	add $80
	ret

; checks for certain card IDs of Fighting color in deck.
; if any of them are found, return a score of
; $80 + slots available in bench.
.CallForFriend:
	ld e, GEODUDE
	ld a, CARD_LOCATION_DECK
	call LookForCardIDInLocation_Bank5
	jr c, .found_fighting_card
	ld e, ONIX
	ld a, CARD_LOCATION_DECK
	call LookForCardIDInLocation_Bank5
	jr c, .found_fighting_card
	ld e, CUBONE
	ld a, CARD_LOCATION_DECK
	call LookForCardIDInLocation_Bank5
	jr c, .found_fighting_card
	ld e, RHYHORN
	ld a, CARD_LOCATION_DECK
	call LookForCardIDInLocation_Bank5
	jr c, .found_fighting_card
	jr .zero_score
.found_fighting_card
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_BENCH_POKEMON
	jr nc, .zero_score
	ld b, a
	ld a, MAX_BENCH_POKEMON
	sub b
	add $80
	ret

; if any basic cards are found in deck,
; return a score of $80 + slots available in bench.
.FriendshipSong:
	call CheckIfAnyBasicPokemonInDeck
	jr nc, .zero_score
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .zero_score
	ld b, a
	ld a, MAX_PLAY_AREA_POKEMON
	sub b
	add $80
	ret

; if AI decides to retreat, return a score of $80 + 10.
.Teleport:
	call AIDecideWhetherToRetreat
	jp nc, .zero_score
	ld a, $8a
	ret

; tests for the following conditions:
; - player is under No Damage substatus;
; - second attack is unusable;
; - second attack deals no damage;
; if any are true, returns score of $80 + 5.
.SwordsDanceAndFocusEnergy:
	ld a, [wAICannotDamage]
	or a
	jr nz, .swords_dance_focus_energy_success
	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	jr c, .swords_dance_focus_energy_success
	ld a, SECOND_ATTACK
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jp nz, .zero_score
.swords_dance_focus_energy_success
	ld a, $85
	ret

; checks player's active card color, then
; loops through own bench looking for a Pokémon
; with that same color.
; if none are found, returns score of $80 + 2.
.ChainLightning:
	call SwapTurn
	call GetArenaCardColor
	call SwapTurn
	ld b, a
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.loop_chain_lightning_bench
	ld a, [hli]
	cp $ff
	jr z, .chain_lightning_success
	push bc
	call GetCardIDFromDeckIndex
	call GetCardType
	pop bc
	cp b
	jr nz, .loop_chain_lightning_bench
	jp .zero_score
.chain_lightning_success
	ld a, $82
	ret

.DevolutionBeam:
	call LookForCardThatIsKnockedOutOnDevolution
	jp nc, .zero_score
	ld a, $85
	ret

; first checks if card is confused, and if so return 0.
; then checks number of Pokémon in bench that are viable to use:
; - if that number is < 2  and this attack is Conversion 1 OR
; - if that number is >= 2 and this attack is Conversion 2
; then return score of $80 + 2.
; otherwise return score of $80 + 1.
.Conversion:
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	cp CONFUSED
	jp z, .zero_score

	ld a, [wSelectedAttack]
	or a
	jr nz, .conversion_2

; conversion 1
	call CountNumberOfSetUpBenchPokemon
	cp 2
	jr c, .low_conversion_score
	ld a, $82
	ret

.conversion_2
	call CountNumberOfSetUpBenchPokemon
	cp 2
	jr nc, .low_conversion_score
	ld a, $82
	ret

.low_conversion_score
	ld a, $81
	ret

; if any Psychic Energy is found in the Discard Pile,
; return a score of $80 + 2.
.EnergyAbsorption:
	ld e, PSYCHIC_ENERGY
	ld a, CARD_LOCATION_DISCARD_PILE
	call LookForCardIDInLocation_Bank5
	jp nc, .zero_score
	ld a, $82
	ret

; if player has cards in hand, AI calls Random:
; - 1/3 chance to encourage attack regardless;
; - 1/3 chance to dismiss attack regardless;
; - 1/3 change to make some checks to player's hand.
; AI tallies number of basic cards in hand, and if this
; number is >= 2, encourage attack.
; otherwise, if it finds an evolution card in hand that
; can evolve a card in player's deck, encourage.
; if encouraged, returns a score of $80 + 3.
.MixUp:
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetNonTurnDuelistVariable
	or a
	ret z

	ld a, 3
	call Random
	or a
	jr z, .encourage_mix_up
	dec a
	ret z
	call SwapTurn
	call CreateHandCardList
	call SwapTurn
	or a
	ret z ; return if no hand cards (again)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	cp 3
	jr nc, .mix_up_check_play_area

	ld hl, wDuelTempList
	ld b, 0
.loop_mix_up_hand
	ld a, [hli]
	cp $ff
	jr z, .tally_basic_cards
	push bc
	call SwapTurn
	call LoadCardDataToBuffer2_FromDeckIndex
	call SwapTurn
	pop bc
	ld a, [wLoadedCard2Type]
	cp TYPE_ENERGY
	jr nc, .loop_mix_up_hand
	ld a, [wLoadedCard2Stage]
	or a
	jr nz, .loop_mix_up_hand
	; is a basic Pokémon card
	inc b
	jr .loop_mix_up_hand
.tally_basic_cards
	ld a, b
	cp 2
	jr nc, .encourage_mix_up

; less than 2 basic cards in hand
.mix_up_check_play_area
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
.loop_mix_up_play_area
	ld a, [hli]
	cp $ff
	jp z, .zero_score
	push hl
	call SwapTurn
	call CheckForEvolutionInList
	call SwapTurn
	pop hl
	jr nc, .loop_mix_up_play_area

.encourage_mix_up
	ld a, $83
	ret

; return score of $80 + 3.
.BigThunder:
	ld a, $83
	ret

; dismiss attack if cards in deck <= 20.
; otherwise return a score of $80 + 0.
.Fetch:
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp 41
	jp nc, .zero_score
	ld a, $80
	ret

; dismiss attack if number of own benched cards which would
; be KOd is greater than or equal to the number
; of prize cards left for player.
.Earthquake:
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable

	lb de, 0, 0
.loop_earthquake
	inc e
	ld a, [hli]
	cp $ff
	jr z, .count_prizes
	ld a, e
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	cp 20
	jr nc, .loop_earthquake
	inc d
	jr .loop_earthquake

.count_prizes
	push de
	call CountPrizes
	pop de
	cp d
	jp c, .zero_score
	jp z, .zero_score
	ld a, $80
	ret

; if there's any lightning energy cards in deck,
; return a score of $80 + 3.
.EnergySpike:
	ld a, CARD_LOCATION_DECK
	ld e, LIGHTNING_ENERGY
	call LookForCardIDInLocation_Bank5
	jp nc, .zero_score
	call AIProcessButDontPlayEnergy_SkipEvolution
	jp nc, .zero_score
	ld a, $83
	ret

; only incentivize attack if player's active card,
; has any energy cards attached, and if so,
; return a score of $80 + 3.
.HyperBeam:
	call SwapTurn
	ld e, PLAY_AREA_ARENA
	call CountNumberOfEnergyCardsAttached
	call SwapTurn
	or a
	jr z, .hyper_beam_neutral
	ld a, $83
	ret
.hyper_beam_neutral
	ld a, $80
	ret

; called when second attack is determined by AI to have
; more AI score than the first attack, so that it checks
; whether the first attack is a better alternative.
CheckWhetherToSwitchToFirstAttack:
; this checks whether the first attack is also viable
; (has more than minimum score to be used)
	ld a, [wFirstAttackAIScore]
	cp $50
	jr c, .keep_second_attack

; first attack has more than minimum score to be used.
; check if second attack can KO.
; in case it can't, the AI keeps it as the attack to be used.
; (possibly due to the assumption that if the
; second attack cannot KO, the first attack can't KO as well.)
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr z, .check_flag
	jr nc, .keep_second_attack

; second attack can ko, check its flag.
; in case its effect is to heal user or nullify/weaken damage
; next turn, keep second attack as the option.
; otherwise switch to the first attack.
.check_flag
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld e, SECOND_ATTACK
	call CopyAttackDataAndDamage_FromDeckIndex
	ld a, ATTACK_FLAG2_ADDRESS | HEAL_USER_F
	call CheckLoadedAttackFlag
	jr c, .keep_second_attack
	ld a, ATTACK_FLAG2_ADDRESS | NULLIFY_OR_WEAKEN_ATTACK_F
	call CheckLoadedAttackFlag
	jr c, .keep_second_attack
; switch to first attack
	xor a ; FIRST_ATTACK_OR_PKMN_POWER
	ld [wSelectedAttack], a
	ret
.keep_second_attack
	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	ret

; returns carry if there are
; any basic Pokémon cards in deck.
CheckIfAnyBasicPokemonInDeck:
	ld e, 0
.loop
	ld a, DUELVARS_CARD_LOCATIONS
	add e
	call GetTurnDuelistVariable
	cp CARD_LOCATION_DECK
	jr nz, .next
	push de
	ld a, e
	call LoadCardDataToBuffer2_FromDeckIndex
	pop de
	ld a, [wLoadedCard2Type]
	cp TYPE_ENERGY
	jr nc, .next
	ld a, [wLoadedCard2Stage]
	or a
	jr z, .set_carry
.next
	inc e
	ld a, DECK_SIZE
	cp e
	jr nz, .loop
	or a
	ret
.set_carry
	scf
	ret
