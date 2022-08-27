; processes AI energy card playing logic
; with AI_ENERGY_FLAG_DONT_PLAY flag on
; unreferenced
Func_16488:
	ld a, AI_ENERGY_FLAG_DONT_PLAY
	ld [wAIEnergyAttachLogicFlags], a
	ld de, wTempPlayAreaAIScore
	ld hl, wPlayAreaAIScore
	ld b, MAX_PLAY_AREA_POKEMON
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld a, [wAIScore]
	ld [de], a
	jr AIProcessAndTryToPlayEnergy.has_logic_flags

; have AI choose an energy card to play, but do not play it.
; does not consider whether the cards have evolutions to be played.
; return carry if an energy card is chosen to use in any Play Area card,
; and if so, return its Play Area location in hTempPlayAreaLocation_ff9d.
AIProcessButDontPlayEnergy_SkipEvolution: ; 164a1 (5:64a1)
	ld a, AI_ENERGY_FLAG_DONT_PLAY | AI_ENERGY_FLAG_SKIP_EVOLUTION
	ld [wAIEnergyAttachLogicFlags], a

; backup wPlayAreaAIScore in wTempPlayAreaAIScore.
	ld de, wTempPlayAreaAIScore
	ld hl, wPlayAreaAIScore
	ld b, MAX_PLAY_AREA_POKEMON
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop

	ld a, [wAIScore]
	ld [de], a

	jr AIProcessEnergyCards

; have AI choose an energy card to play, but do not play it.
; does not consider whether the cards have evolutions to be played.
; return carry if an energy card is chosen to use in any Bench card,
; and if so, return its Play Area location in hTempPlayAreaLocation_ff9d.
AIProcessButDontPlayEnergy_SkipEvolutionAndArena: ; 164ba (5:64ba)
	ld a, AI_ENERGY_FLAG_DONT_PLAY | AI_ENERGY_FLAG_SKIP_EVOLUTION | AI_ENERGY_FLAG_SKIP_ARENA_CARD
	ld [wAIEnergyAttachLogicFlags], a

; backup wPlayAreaAIScore in wTempPlayAreaAIScore.
	ld de, wTempPlayAreaAIScore
	ld hl, wPlayAreaAIScore
	ld b, MAX_PLAY_AREA_POKEMON
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop

	ld a, [wAIScore]
	ld [de], a

	jr AIProcessEnergyCards

; copies wTempPlayAreaAIScore to wPlayAreaAIScore
; and loads wAIScore with value in wTempAIScore.
; identical to RetrievePlayAreaAIScoreFromBackup2.
RetrievePlayAreaAIScoreFromBackup1: ; 164d3 (5:64d3)
	push af
	ld de, wPlayAreaAIScore
	ld hl, wTempPlayAreaAIScore
	ld b, MAX_PLAY_AREA_POKEMON
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld a, [hl]
	ld [wAIScore], a
	pop af
	ret

; have AI decide whether to play energy card from hand
; and determine which card is best to attach it.
AIProcessAndTryToPlayEnergy: ; 164e8 (5:64e8)
	xor a
	ld [wAIEnergyAttachLogicFlags], a

.has_logic_flags
	call CreateEnergyCardListFromHand
	jr nc, AIProcessEnergyCards

; no energy
	ld a, [wAIEnergyAttachLogicFlags]
	or a
	jr z, .exit
	jp RetrievePlayAreaAIScoreFromBackup1
.exit
	or a
	ret

; have AI decide whether to play energy card
; and determine which card is best to attach it.
AIProcessEnergyCards: ; 164fc (5:64fc)
; initialize Play Area AI score
	ld a, $80
	ld b, MAX_PLAY_AREA_POKEMON
	ld hl, wPlayAreaEnergyAIScore
.loop
	ld [hli], a
	dec b
	jr nz, .loop

; Legendary Articuno Deck has its own energy card logic
	call HandleLegendaryArticunoEnergyScoring

; start the main Play Area loop
	ld b, PLAY_AREA_ARENA
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a

.loop_play_area
	push bc
	ld a, b
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, $80
	ld [wAIScore], a
	ld a, $ff
	ld [wTempAI], a
	ld a, [wAIEnergyAttachLogicFlags]
	and AI_ENERGY_FLAG_SKIP_EVOLUTION
	jr nz, .check_venusaur

; check if energy needed is found in hand
; and if there's an evolution in hand or deck
; and if so, add to AI score
	call CreateHandCardList
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld [wCurCardCanAttack], a
	call GetAttacksEnergyCostBits
	ld hl, wDuelTempList
	call CheckEnergyFlagsNeededInList
	jp nc, .store_score
	ld a, [wCurCardCanAttack]
	call CheckForEvolutionInList
	jr nc, .no_evolution_in_hand
	ld [wTempAI], a ; store evolution card found
	ld a, 2
	call AddToAIScore
	jr .check_venusaur

.no_evolution_in_hand
	ld a, [wCurCardCanAttack]
	call CheckForEvolutionInDeck
	jr nc, .check_venusaur
	ld a, 1
	call AddToAIScore

; if there's no Muk in any Play Area
; and there's VenusaurLv67 in own Play Area,
; add to AI score
.check_venusaur
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .check_if_active
	ld a, VENUSAUR_LV67
	call CountPokemonIDInPlayArea
	jr nc, .check_if_active
	ld a, 1
	call AddToAIScore

.check_if_active
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .bench

; arena
	ld a, [wAIBarrierFlagCounter]
	bit AI_MEWTWO_MILL_F, a
	jr z, .add_to_score

; subtract from score instead
; if Player is running MewtwoLv53 mill deck.
	ld a, 5
	call SubFromAIScore
	jr .check_defending_can_ko

.add_to_score
	ld a, 4
	call AddToAIScore

; lower AI score if poison/double poison
; will KO Pokémon between turns
; or if the defending Pokémon can KO
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	call CalculateByteTensDigit
	cp 3
	jr nc, .check_defending_can_ko
	; hp < 30
	cp 2
	jr z, .has_20_hp
	; hp = 10
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and POISONED
	jr z, .check_defending_can_ko
	jr .poison_will_ko
.has_20_hp
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and DOUBLE_POISONED
	jr z, .check_defending_can_ko
.poison_will_ko
	ld a, 10
	call SubFromAIScore
	jr .check_bench
.check_defending_can_ko
	call CheckIfDefendingPokemonCanKnockOut
	jr nc, .ai_score_bonus
	ld a, 10
	call SubFromAIScore

; if either poison will KO or defending Pokémon can KO,
; check if there are bench Pokémon,
; if there are not, add AI score
.check_bench
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	dec a
	jr nz, .ai_score_bonus
	ld a, 6
	call AddToAIScore
	jr .ai_score_bonus

; lower AI score by 3 - (bench HP)/10
; if bench HP < 30
.bench
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	call CalculateByteTensDigit
	cp 3
	jr nc, .ai_score_bonus
; hp < 30
	ld b, a
	ld a, 3
	sub b
	call SubFromAIScore

; check list in wAICardListEnergyBonus
.ai_score_bonus
	ld a, [wAICardListEnergyBonus + 1]
	or a
	jr z, .check_boss_deck ; is null
	ld h, a
	ld a, [wAICardListEnergyBonus]
	ld l, a

	push hl
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	pop hl

.loop_id_list
	ld a, [hli]
	or a
	jr z, .check_boss_deck
	cp e
	jr nz, .next_id

	; number of attached energy cards
	ld a, [hli]
	ld d, a
	push de
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	pop de
	cp d
	jr c, .check_id_score
	; already reached target number of energy cards
	ld a, 10
	call SubFromAIScore
	jr .store_score

.check_id_score
	ld a, [hli]
	cp $80
	jr c, .decrease_score_1
	sub $80
	call AddToAIScore
	jr .check_boss_deck

.decrease_score_1
	ld d, a
	ld a, $80
	sub d
	call SubFromAIScore
	jr .check_boss_deck

.next_id
	inc hl
	inc hl
	jr .loop_id_list

; if it's a boss deck, call Func_174f2
; and apply to the AI score the values
; determined for this card
.check_boss_deck
	call CheckIfNotABossDeckID
	jr c, .skip_boss_deck

	call Func_174f2
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld c, a
	ld b, $00
	ld hl, wPlayAreaEnergyAIScore
	add hl, bc
	ld a, [hl]
	cp $80
	jr c, .decrease_score_2
	sub $80
	call AddToAIScore
	jr .skip_boss_deck

.decrease_score_2
	ld b, a
	ld a, $80
	sub b
	call SubFromAIScore

.skip_boss_deck
	ld a, 1
	call AddToAIScore

; add AI score for both attacks,
; according to their energy requirements.
	xor a ; first attack
	call DetermineAIScoreOfAttackEnergyRequirement
	ld a, SECOND_ATTACK
	call DetermineAIScoreOfAttackEnergyRequirement

; store bench score for this card.
.store_score
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld c, a
	ld b, $00
	ld hl, wPlayAreaAIScore
	add hl, bc
	ld a, [wAIScore]
	ld [hl], a
	pop bc
	inc b
	dec c
	jp nz, .loop_play_area

; the Play Area loop is over and the score
; for each card has been calculated.
; now to determine the highest score.
	call FindPlayAreaCardWithHighestAIScore
	jp nc, .not_found

	ld a, [wAIEnergyAttachLogicFlags]
	or a
	jr z, .play_card
	scf
	jp RetrievePlayAreaAIScoreFromBackup1

.play_card
	call CreateEnergyCardListFromHand
	jp AITryToPlayEnergyCard

.not_found: ; 1668a (5:668a)
	ld a, [wAIEnergyAttachLogicFlags]
	or a
	jr z, .no_carry
	jp RetrievePlayAreaAIScoreFromBackup1
.no_carry
	or a
	ret

; checks score related to selected attack,
; in order to determine whether to play energy card.
; the AI score is increased/decreased accordingly.
; input:
;	[wSelectedAttack] = attack to check.
DetermineAIScoreOfAttackEnergyRequirement: ; 16695 (5:6695)
	ld [wSelectedAttack], a
	call CheckEnergyNeededForAttack
	jp c, .not_enough_energy
	ld a, ATTACK_FLAG2_ADDRESS | ATTACHED_ENERGY_BOOST_F
	call CheckLoadedAttackFlag
	jr c, .attached_energy_boost
	ld a, ATTACK_FLAG2_ADDRESS | DISCARD_ENERGY_F
	call CheckLoadedAttackFlag
	jr c, .discard_energy
	jp .check_evolution

.attached_energy_boost
	ld a, [wLoadedAttackEffectParam]
	cp MAX_ENERGY_BOOST_IS_LIMITED
	jr z, .check_surplus_energy

	; is MAX_ENERGY_BOOST_IS_NOT_LIMITED,
	; which is equal to 3, add to score.
	call AddToAIScore
	jp .check_evolution

.check_surplus_energy
	call CheckIfNoSurplusEnergyForAttack
	jr c, .asm_166cd
	cp 3 ; check how much surplus energy
	jr c, .asm_166cd

.asm_166c5
	ld a, 5
	call SubFromAIScore
	jp .check_evolution

.asm_166cd
	ld a, 2
	call AddToAIScore

; check whether attack has ATTACHED_ENERGY_BOOST flag
; and add to AI score if attaching another energy
; will KO defending Pokémon.
; add more to score if this is currently active Pokémon.
	ld a, ATTACK_FLAG2_ADDRESS | ATTACHED_ENERGY_BOOST_F
	call CheckLoadedAttackFlag
	jp nc, .check_evolution
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jp c, .check_evolution
	jp z, .check_evolution
	ld a, [wDamage]
	add 10 ; boost gained by attaching another energy card
	ld b, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	sub b
	jr c, .attaching_kos_player
	jr nz, .check_evolution

.attaching_kos_player
	ld a, 20
	call AddToAIScore
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .check_evolution
	ld a, 10
	call AddToAIScore
	jr .check_evolution

; checks if there is surplus energy for attack
; that discards attached energy card.
; if current card is ZapdosLv64, don't add to score.
; if there is no surplus energy, encourage playing energy.
.discard_energy
	ld a, [wLoadedCard1ID]
	cp ZAPDOS_LV64
	jr z, .check_evolution
	call CheckIfNoSurplusEnergyForAttack
	jr c, .asm_166cd
	jr .asm_166c5

.not_enough_energy
	ld a, ATTACK_FLAG2_ADDRESS | FLAG_2_BIT_5_F
	call CheckLoadedAttackFlag
	jr nc, .check_color_needed
	ld a, 5
	call SubFromAIScore

; if the energy card color needed is in hand, increase AI score.
; if a colorless card is needed, increase AI score.
.check_color_needed
	ld a, b
	or a
	jr z, .check_colorless_needed
	ld a, e
	call LookForCardIDInHand
	jr c, .check_colorless_needed
	ld a, 4
	call AddToAIScore
	jr .check_total_needed
.check_colorless_needed
	ld a, c
	or a
	jr z, .check_evolution
	ld a, 3
	call AddToAIScore

; if only one energy card is needed for attack,
; encourage playing energy card.
.check_total_needed
	ld a, b
	add c
	dec a
	jr nz, .check_evolution
	ld a, 3
	call AddToAIScore

; if the attack KOs player and this is the active card, add to AI score.
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .check_evolution
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr z, .atk_kos_defending
	jr nc, .check_evolution
.atk_kos_defending
	ld a, 20
	call AddToAIScore

; this is possibly a bug.
; this is an identical check as above to test whether this card is active.
; in case it is active, the score gets added 10 more points,
; in addition to the 20 points already added above.
; what was probably intended was to add 20 points
; plus 10 in case it is the Arena card.
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .check_evolution
	ld a, 10
	call AddToAIScore

.check_evolution
	ld a, [wTempAI] ; evolution in hand
	cp $ff
	ret z

; temporarily replace this card with evolution in hand.
	ld b, a
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	push af
	ld [hl], b

; check for energy still needed for evolution to attack.
; if FLAG_2_BIT_5 is not set, check what color is needed.
; if the energy card color needed is in hand, increase AI score.
; if a colorless card is needed, increase AI score.
	call CheckEnergyNeededForAttack
	jr nc, .done
	ld a, ATTACK_FLAG2_ADDRESS | FLAG_2_BIT_5_F
	call CheckLoadedAttackFlag
	jr c, .done
	ld a, b
	or a
	jr z, .check_colorless_needed_evo
	ld a, e
	call LookForCardIDInHand
	jr c, .check_colorless_needed_evo
	ld a, 2
	call AddToAIScore
	jr .done
.check_colorless_needed_evo
	ld a, c
	or a
	jr z, .done
	ld a, 1
	call AddToAIScore

; recover the original card in the Play Area location.
.done
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	ret

; returns in hTempPlayAreaLocation_ff9d the Play Area location
; of the card with the highest Play Area AI score, unless
; the highest score is below $85.
; if it succeeds in return a card location, set carry.
; if AI_ENERGY_FLAG_SKIP_ARENA_CARD is set in wAIEnergyAttachLogicFlags
; doesn't include the Arena card and there's no minimum score.
FindPlayAreaCardWithHighestAIScore: ; 167b5 (5:67b5)
	ld a, [wAIEnergyAttachLogicFlags]
	and AI_ENERGY_FLAG_SKIP_ARENA_CARD
	jr nz, .only_bench

	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld b, a
	ld c, PLAY_AREA_ARENA
	ld e, c
	ld d, c
	ld hl, wPlayAreaAIScore
; find highest Play Area AI score.
.loop_1
	ld a, [hli]
	cp e
	jr c, .next_1
	jr z, .next_1
	ld e, a ; overwrite highest score found
	ld d, c ; overwrite Play Area of highest score
.next_1
	inc c
	dec b
	jr nz, .loop_1

; if highest AI score is below $85, return no carry.
; else, store Play Area location and return carry.
	ld a, e
	cp $85
	jr c, .not_enough_score
	ld a, d
	ldh [hTempPlayAreaLocation_ff9d], a
	scf
	ret
.not_enough_score
	or a
	ret

; same as above but only check bench Pokémon scores.
.only_bench
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	dec a
	jr z, .no_carry

	ld b, a
	ld e, 0
	ld c, PLAY_AREA_BENCH_1
	ld d, c
	ld hl, wPlayAreaAIScore + 1
.loop_2
	ld a, [hli]
	cp e
	jr c, .next_2
	jr z, .next_2
	ld e, a ; overwrite highest score found
	ld d, c ; overwrite Play Area of highest score
.next_2
	inc c
	dec b
	jr nz, .loop_2

; in this case, there is no minimum threshold AI score.
	ld a, d
	ldh [hTempPlayAreaLocation_ff9d], a
	scf
	ret
.no_carry
	or a
	ret

; returns carry if there's an evolution card
; that can evolve card in hTempPlayAreaLocation_ff9d,
; and that card needs energy to use wSelectedAttack.
CheckIfEvolutionNeedsEnergyForAttack: ; 16805 (5:6805)
	call CreateHandCardList
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call CheckCardEvolutionInHandOrDeck
	jr c, .has_evolution
	or a
	ret

.has_evolution
	ld b, a
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	push af
	ld [hl], b
	call CheckEnergyNeededForAttack
	jr c, .not_enough_energy
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	or a
	ret

.not_enough_energy
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	scf
	ret

; returns in e the card ID of the energy required for
; the Discard/Energy Boost attack loaded in wSelectedAttack.
; if it's ZapdosLv64's Thunderbolt attack, return no carry.
; if it's Charizard's Fire Spin or Exeggutor's Big Eggsplosion
; attack, don't return energy card ID, but set carry.
; output:
;	b = 1 if needs color energy, 0 otherwise;
;	c = 1 if only needs colorless energy, 0 otherwise;
;	carry set if not ZapdosLv64's Thunderbolt attack.
GetEnergyCardForDiscardOrEnergyBoostAttack: ; 1683b (5:683b)
; load card ID and check selected attack index.
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld b, a
	ld a, [wSelectedAttack]
	or a
	jr z, .first_attack

; check if second attack is ZapdosLv64's Thunderbolt,
; Charizard's Fire Spin or Exeggutor's Big Eggsplosion,
; for these to be treated differently.
; for both attacks, load its energy cost.
	ld a, b
	cp ZAPDOS_LV64
	jr z, .zapdos2
	cp CHARIZARD
	jr z, .charizard_or_exeggutor
	cp EXEGGUTOR
	jr z, .charizard_or_exeggutor
	ld hl, wLoadedCard2Atk2EnergyCost
	jr .fire
.first_attack
	ld hl, wLoadedCard2Atk1EnergyCost

; check which energy color the attack requires,
; and load in e the card ID of corresponding energy card,
; then return carry flag set.
.fire
	ld a, [hli]
	ld b, a
	and $f0
	jr z, .grass
	ld e, FIRE_ENERGY
	jr .set_carry
.grass
	ld a, b
	and $0f
	jr z, .lightning
	ld e, GRASS_ENERGY
	jr .set_carry
.lightning
	ld a, [hli]
	ld b, a
	and $f0
	jr z, .water
	ld e, LIGHTNING_ENERGY
	jr .set_carry
.water
	ld a, b
	and $0f
	jr z, .fighting
	ld e, WATER_ENERGY
	jr .set_carry
.fighting
	ld a, [hli]
	ld b, a
	and $f0
	jr z, .psychic
	ld e, FIGHTING_ENERGY
	jr .set_carry
.psychic
	ld e, PSYCHIC_ENERGY

.set_carry
	lb bc, $01, $00
	scf
	ret

; for ZapdosLv64's Thunderbolt attack, return with no carry.
.zapdos2
	or a
	ret

; Charizard's Fire Spin and Exeggutor's Big Eggsplosion,
; return carry.
.charizard_or_exeggutor
	lb bc, $00, $01
	scf
	ret

; called after the AI has decided which card to attach
; energy from hand. AI does checks to determine whether
; this card needs more energy or not, and chooses the
; right energy card to play. If the card is played,
; return with carry flag set.
AITryToPlayEnergyCard: ; 1689f (5:689f)
; check if energy cards are still needed for attacks.
; if first attack doesn't need, test for the second attack.
	xor a
	ld [wTempAI], a
	ld [wSelectedAttack], a
	call CheckEnergyNeededForAttack
	jr nc, .second_attack
	ld a, b
	or a
	jr nz, .check_deck
	ld a, c
	or a
	jr nz, .check_deck

.second_attack
	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	call CheckEnergyNeededForAttack
	jr nc, .check_discard_or_energy_boost
	ld a, b
	or a
	jr nz, .check_deck
	ld a, c
	or a
	jr nz, .check_deck

; neither attack needs energy cards to be used.
; check whether these attacks can be given
; extra energy cards for their effects.
.check_discard_or_energy_boost
	ld a, $01
	ld [wTempAI], a

; for both attacks, check if it has the effect of
; discarding energy cards or attached energy boost.
	xor a ; FIRST_ATTACK_OR_PKMN_POWER
	ld [wSelectedAttack], a
	call CheckEnergyNeededForAttack
	ld a, ATTACK_FLAG2_ADDRESS | ATTACHED_ENERGY_BOOST_F
	call CheckLoadedAttackFlag
	jr c, .energy_boost_or_discard_energy
	ld a, ATTACK_FLAG2_ADDRESS | DISCARD_ENERGY_F
	call CheckLoadedAttackFlag
	jr c, .energy_boost_or_discard_energy

	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	call CheckEnergyNeededForAttack
	ld a, ATTACK_FLAG2_ADDRESS | ATTACHED_ENERGY_BOOST_F
	call CheckLoadedAttackFlag
	jr c, .energy_boost_or_discard_energy
	ld a, ATTACK_FLAG2_ADDRESS | DISCARD_ENERGY_F
	call CheckLoadedAttackFlag
	jr c, .energy_boost_or_discard_energy

; if none of the attacks have those flags, do an additional
; check to ascertain whether evolution card needs energy
; to use second attack. Return if all these checks fail.
	call CheckIfEvolutionNeedsEnergyForAttack
	ret nc
	call CreateEnergyCardListFromHand
	jr .check_deck

; for attacks that discard energy or get boost for
; additional energy cards, get the energy card ID required by attack.
; if it's ZapdosLv64's Thunderbolt attack, return.
.energy_boost_or_discard_energy
	call GetEnergyCardForDiscardOrEnergyBoostAttack
	ret nc

; some decks allow basic Pokémon to be given double colorless
; in anticipation for evolution, so play card if that is the case.
.check_deck
	call CheckSpecificDecksToAttachDoubleColorless
	jr c, .play_energy_card

	ld a, b
	or a
	jr z, .colorless_energy

; in this case, Pokémon needs a specific basic energy card.
; look for basic energy card needed in hand and play it.
	ld a, e
	call LookForCardIDInHand
	ldh [hTemp_ffa0], a
	jr nc, .play_energy_card

; in this case Pokémon just needs colorless (any basic energy card).
; if active card, check if it needs 2 colorless.
; if it does (and also doesn't additionally need a color energy),
; look for double colorless card in hand and play it if found.
.colorless_energy
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .look_for_any_energy
	ld a, c
	or a
	jr z, .check_if_done
	cp 2
	jr nz, .look_for_any_energy

	; needs two colorless
	ld hl, wDuelTempList
.loop_1
	ld a, [hli]
	cp $ff
	jr z, .look_for_any_energy
	ldh [hTemp_ffa0], a
	call GetCardIDFromDeckIndex
	ld a, e
	cp DOUBLE_COLORLESS_ENERGY
	jr nz, .loop_1
	jr .play_energy_card

; otherwise, look for any card and play it.
; if it's a boss deck, only play double colorless in this situation.
.look_for_any_energy
	ld hl, wDuelTempList
	call CountCardsInDuelTempList
	call ShuffleCards
.loop_2
	ld a, [hli]
	cp $ff
	jr z, .check_if_done
	call CheckIfOpponentHasBossDeckID
	jr nc, .load_card
	push af
	call GetCardIDFromDeckIndex
	ld a, e
	cp DOUBLE_COLORLESS_ENERGY
	pop bc
	jr z, .loop_2
	ld a, b
.load_card
	ldh [hTemp_ffa0], a

; plays energy card loaded in hTemp_ffa0 and sets carry flag.
.play_energy_card
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, OPPACTION_PLAY_ENERGY
	bank1call AIMakeDecision
	scf
	ret

; wTempAI is 1 if the attack had a Discard/Energy Boost effect,
; and 0 otherwise. If 1, then return. If not one, check if
; there is still a second attack to check.
.check_if_done
	ld a, [wTempAI]
	or a
	jr z, .check_first_attack
	ret
.check_first_attack
	ld a, [wSelectedAttack]
	or a
	jp z, .second_attack
	ret

; check if playing certain decks so that AI can decide whether to play
; double colorless to some specific cards.
; these are cards that do not need double colorless to any of their attacks
; but are required by their evolutions.
; return carry if there's a double colorless in hand to attach
; and it's one of the card IDs from these decks.
; output:
;	[hTemp_ffa0] = card index of double colorless in hand;
;	carry set if can play energy card.
CheckSpecificDecksToAttachDoubleColorless: ; 1696e (5:696e)
	push bc
	push de
	push hl

; check if AI is playing any of the applicable decks.
	ld a, [wOpponentDeckID]
	cp LEGENDARY_DRAGONITE_DECK_ID
	jr z, .legendary_dragonite_deck
	cp FIRE_CHARGE_DECK_ID
	jr z, .fire_charge_deck
	cp LEGENDARY_RONALD_DECK_ID
	jr z, .legendary_ronald_deck

.no_carry
	pop hl
	pop de
	pop bc
	or a
	ret

; if playing Legendary Dragonite deck,
; check for Charmander and Dratini.
.legendary_dragonite_deck
	call .get_id
	cp CHARMANDER
	jr z, .check_colorless_attached
	cp DRATINI
	jr z, .check_colorless_attached
	jr .no_carry

; if playing Fire Charge deck,
; check for Growlithe.
.fire_charge_deck
	call .get_id
	cp GROWLITHE
	jr z, .check_colorless_attached
	jr .no_carry

; if playing Legendary Ronald deck,
; check for Dratini.
.legendary_ronald_deck
	call .get_id
	cp DRATINI
	jr z, .check_colorless_attached
	jr .no_carry

; check if card has any colorless energy cards attached,
; and if there are any, return no carry.
.check_colorless_attached
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + COLORLESS]
	or a
	jr nz, .no_carry

; card has no colorless energy, so look for double colorless
; in hand and if found, return carry and its card index.
	ld a, DOUBLE_COLORLESS_ENERGY
	call LookForCardIDInHand
	jr c, .no_carry
	ldh [hTemp_ffa0], a
	pop hl
	pop de
	pop bc
	scf
	ret

.get_id:
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ret
