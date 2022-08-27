; determine AI score for retreating
; return carry if AI decides to retreat
AIDecideWhetherToRetreat:
	ld a, [wGotHeadsFromConfusionCheckDuringRetreat]
	or a
	jp nz, .no_carry
	xor a
	ld [wAIPlayEnergyCardForRetreat], a
	call LoadDefendingPokemonColorWRAndPrizeCards
	ld a, $80 ; initial retreat score
	ld [wAIScore], a
	ld a, [wAIRetreatScore]
	or a
	jr z, .check_status
	; add wAIRetreatScore * 8 to score
	srl a
	srl a
	sla a ; *8
	call AddToAIScore

.check_status
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	or a
	jr z, .check_ko_1 ; no status
	and DOUBLE_POISONED
	jr z, .check_cnf ; no poison
	ld a, 2
	call AddToAIScore
.check_cnf
	ld a, [hl]
	and CNF_SLP_PRZ
	cp CONFUSED
	jr nz, .check_ko_1
	ld a, 1
	call AddToAIScore

.check_ko_1
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfAnyAttackKnocksOutDefendingCard
	jr nc, .active_cant_ko_1
	call CheckIfSelectedAttackIsUnusable
	jp nc, .active_cant_use_atk
	call LookForEnergyNeededForAttackInHand
	jr nc, .active_cant_ko_1

.active_cant_use_atk
	ld a, 5
	call SubFromAIScore
	ld a, [wAIOpponentPrizeCount]
	cp 2
	jr nc, .active_cant_ko_1
	ld a, 35
	call SubFromAIScore

.active_cant_ko_1
	call CheckIfDefendingPokemonCanKnockOut
	jr nc, .defending_cant_ko
	ld a, 2
	call AddToAIScore

	call CheckIfNotABossDeckID
	jr c, .check_resistance_1
	ld a, [wAIPlayerPrizeCount]
	cp 2
	jr nc, .check_prize_count
	ld a, $01
	ld [wAIPlayEnergyCardForRetreat], a

.defending_cant_ko
	call CheckIfNotABossDeckID
	jr c, .check_resistance_1
	ld a, [wAIPlayerPrizeCount]
	cp 2
	jr nc, .check_prize_count
	ld a, 2
	call AddToAIScore

.check_prize_count
	ld a, [wAIOpponentPrizeCount]
	cp 2
	jr nc, .check_resistance_1
	ld a, 2
	call SubFromAIScore

.check_resistance_1
	call GetArenaCardColor
	call TranslateColorToWR
	ld b, a
	ld a, [wAIPlayerResistance]
	and b
	jr z, .check_weakness_1
	ld a, 1
	call AddToAIScore

; check bench for Pokémon that
; the defending card is not resistant to
; if one is found, skip SubFromAIScore
	ld a, [wAIPlayerResistance]
	ld b, a
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.loop_resistance_1
	ld a, [hli]
	cp $ff
	jr z, .exit_loop_resistance_1
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	call TranslateColorToWR
	and b
	jr nz, .loop_resistance_1
	jr .check_weakness_1
.exit_loop_resistance_1
	ld a, 2
	call SubFromAIScore

.check_weakness_1
	ld a, [wAIPlayerColor]
	ld b, a
	call GetArenaCardWeakness
	and b
	jr z, .check_resistance_2
	ld a, 2
	call AddToAIScore

; check bench for Pokémon that
; is not weak to defending Pokémon
; if one is found, skip SubFromAIScore
	ld a, [wAIPlayerColor]
	ld b, a
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.loop_weakness_1
	ld a, [hli]
	cp $ff
	jr z, .exit_loop_weakness_1
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Weakness]
	and b
	jr nz, .loop_weakness_1
	jr .check_resistance_2
.exit_loop_weakness_1
	ld a, 3
	call SubFromAIScore

.check_resistance_2
	ld a, [wAIPlayerColor]
	ld b, a
	call GetArenaCardResistance
	and b
	jr z, .check_weakness_2
	ld a, 3
	call SubFromAIScore

; check bench for Pokémon that
; is the defending Pokémon's weakness
; if none is found, skip AddToAIScore
.check_weakness_2
	ld a, [wAIPlayerWeakness]
	ld b, a
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	ld e, $00
.loop_weakness_2
	inc e
	ld a, [hli]
	cp $ff
	jr z, .check_resistance_3
	push de
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	call TranslateColorToWR
	pop de
	and b
	jr z, .loop_weakness_2
	ld a, 2
	call AddToAIScore

	push de
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	cp PORYGON
	jr nz, .check_weakness_3

; handle Porygon
	ld a, e
	call CheckIfCanDamageDefendingPokemon
	jr nc, .check_weakness_3
	ld a, 10
	call AddToAIScore
	jr .check_resistance_3

.check_weakness_3
	call GetArenaCardColor
	call TranslateColorToWR
	ld b, a
	ld a, [wAIPlayerWeakness]
	and b
	jr z, .check_resistance_3
	ld a, 3
	call SubFromAIScore

; check bench for Pokémon that
; is resistant to defending Pokémon
; if none is found, skip AddToAIScore
.check_resistance_3
	ld a, [wAIPlayerColor]
	ld b, a
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.loop_resistance_2
	ld a, [hli]
	cp $ff
	jr z, .check_ko_2
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Resistance]
	and b
	jr z, .loop_resistance_2
	ld a, 1
	call AddToAIScore

; check bench for Pokémon that
; can KO defending Pokémon
; if none is found, skip AddToAIScore
.check_ko_2
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	ld c, 0
.loop_ko_1
	inc c
	ld a, [hli]
	cp $ff
	jr z, .check_defending_id
	ld a, c
	ldh [hTempPlayAreaLocation_ff9d], a
	push hl
	push bc
	call CheckIfAnyAttackKnocksOutDefendingCard
	jr nc, .no_ko
	call CheckIfSelectedAttackIsUnusable
	jr nc, .success
	call LookForEnergyNeededForAttackInHand
	jr c, .success
.no_ko
	pop bc
	pop hl
	jr .loop_ko_1
.success
	pop bc
	pop hl
	ld a, 2
	call AddToAIScore

; a bench Pokémon was found that can KO
; if this is a boss deck and it's at last prize card
; if arena Pokémon cannot KO, add to AI score
; and set wAIPlayEnergyCardForRetreat to $01

	ld a, [wAIOpponentPrizeCount]
	cp 2
	jr nc, .check_defending_id
	call CheckIfNotABossDeckID
	jr c, .check_defending_id

	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfAnyAttackKnocksOutDefendingCard
	jr nc, .active_cant_ko_2
	call CheckIfSelectedAttackIsUnusable
	jp nc, .check_defending_id
.active_cant_ko_2
	ld a, 40
	call AddToAIScore
	ld a, $01
	ld [wAIPlayEnergyCardForRetreat], a

.check_defending_id
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MR_MIME
	jr z, .mr_mime_or_hitmonlee
	cp HITMONLEE ; ??
	jr nz, .check_retreat_cost

; check bench if there's any Pokémon
; that can damage defending Pokémon
; this is done because of Mr. Mime's PKMN PWR
; but why Hitmonlee ($87) as well?
.mr_mime_or_hitmonlee
	xor a
	call CheckIfCanDamageDefendingPokemon
	jr c, .check_retreat_cost
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	ld c, 0
.loop_damage
	inc c
	ld a, [hli]
	cp $ff
	jr z, .check_retreat_cost
	ld a, c
	push hl
	push bc
	call CheckIfCanDamageDefendingPokemon
	jr c, .can_damage
	pop bc
	pop hl
	jr .loop_damage
.can_damage
	pop bc
	pop hl
	ld a, 5
	call AddToAIScore
	ld a, $01
	ld [wAIPlayEnergyCardForRetreat], a

; subtract from wAIScore if retreat cost is larger than 1
; then check if any cards have at least half HP,
; are final evolutions and can use second attack in the bench
; and adds to wAIScore if the active Pokémon doesn't meet
; these conditions
.check_retreat_cost
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call GetPlayAreaCardRetreatCost
	cp 2
	jr c, .one_or_none
	cp 3
	jr nc, .three_or_more
	; exactly two
	ld a, 1
	call SubFromAIScore
	jr .one_or_none

.three_or_more
	ld a, 2
	call SubFromAIScore

.one_or_none
	call CheckIfArenaCardIsAtHalfHPCanEvolveAndUseSecondAttack
	jr c, .check_defending_can_ko
	call CountNumberOfSetUpBenchPokemon
	cp 2
	jr c, .check_defending_can_ko
	call AddToAIScore

; check bench for Pokémon that
; the defending Pokémon can't knock out
; if none is found, skip SubFromAIScore
.check_defending_can_ko
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	ld e, 0
.loop_ko_2
	inc e
	ld a, [hli]
	cp $ff
	jr z, .exit_loop_ko
	push de
	push hl
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2ID]
	pop hl
	pop de
	cp MYSTERIOUS_FOSSIL
	jr z, .loop_ko_2
	cp CLEFAIRY_DOLL
	jr z, .loop_ko_2
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a
	push de
	push hl
	call CheckIfDefendingPokemonCanKnockOut
	pop hl
	pop de
	jr c, .loop_ko_2
	jr .check_active_id
.exit_loop_ko
	ld a, 20
	call SubFromAIScore

.check_active_id
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp MYSTERIOUS_FOSSIL
	jr z, .mysterious_fossil_or_clefairy_doll
	cp CLEFAIRY_DOLL
	jr z, .mysterious_fossil_or_clefairy_doll

; if wAIScore is at least 131, set carry
	ld a, [wAIScore]
	cp 131
	jr nc, .set_carry
.no_carry
	or a
	ret
.set_carry
	scf
	ret

; set carry regardless if active card is
; either Mysterious Fossil or Clefairy Doll
; and there's a bench Pokémon who is not KO'd
; by defending Pokémon and can damage it
.mysterious_fossil_or_clefairy_doll
	ld e, 0
.loop_ko_3
	inc e
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp $ff
	jr z, .no_carry
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a
	push de
	call CheckIfDefendingPokemonCanKnockOut
	pop de
	jr c, .loop_ko_3
	ld a, e
	push de
	call CheckIfCanDamageDefendingPokemon
	pop de
	jr nc, .loop_ko_3
	jr .set_carry

; if player's turn and loaded attack is not a Pokémon Power OR
; if opponent's turn and wAITriedAttack == 0
; set wcdda's bit 7 flag
Func_15b54:
	xor a
	ld [wcdda], a
	ld a, [wWhoseTurn]
	cp OPPONENT_TURN
	jr z, .opponent

; player
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	ret z
	jr .set_flag

.opponent
	ld a, [wAITriedAttack]
	or a
	ret nz

.set_flag
	ld a, %10000000
	ld [wcdda], a
	ret

; calculates AI score for bench Pokémon
; returns in a and [hTempPlayAreaLocation_ff9d] the
; Play Area location of best card to switch to.
; returns carry if no Bench Pokemon.
AIDecideBenchPokemonToSwitchTo:
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 2
	ret c

; has at least 2 Pokémon in Play Area
	call Func_15b54
	call LoadDefendingPokemonColorWRAndPrizeCards
	ld a, 50
	ld [wAIScore], a
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld b, a
	ld c, PLAY_AREA_ARENA
	push bc
	jp .store_score

.next_bench
	push bc
	ld a, c
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, 50
	ld [wAIScore], a

; check if card can KO defending Pokémon
; if it can, raise AI score
; if on last prize card, raise AI score again
	call CheckIfAnyAttackKnocksOutDefendingCard
	jr nc, .check_can_use_atks
	call CheckIfSelectedAttackIsUnusable
	jr c, .check_can_use_atks
	ld a, 10
	call AddToAIScore
	ld a, [wcdda]
	or %00000001
	ld [wcdda], a
	call CountPrizes
	cp 2
	jp nc, .check_defending_weak
	ld a, 10
	call AddToAIScore

; calculates damage of both attacks
; to raise AI score accordingly
.check_can_use_atks
	xor a
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	call nc, .HandleAttackDamageScore
	ld a, $01
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	call nc, .HandleAttackDamageScore
	jr .check_energy_card

; adds to AI score depending on amount of damage
; it can inflict to the defending Pokémon
; AI score += floor(Damage / 10) + 1
.HandleAttackDamageScore
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	call CalculateByteTensDigit
	inc a
	call AddToAIScore
	ret

; if an energy card that is needed is found in hand
; calculate damage of the move and raise AI score
; AI score += floor(Damage / 20)
.check_energy_card
	call LookForEnergyNeededInHand
	jr nc, .check_attached_energy
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	call CalculateByteTensDigit
	srl a
	call AddToAIScore

; if no energies attached to card, lower AI score
.check_attached_energy
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	or a
	jr nz, .check_mr_mime
	ld a, 1
	call SubFromAIScore

; if can damage Mr Mime, raise AI score
.check_mr_mime
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call LoadCardDataToBuffer2_FromDeckIndex
	call SwapTurn
	cp MR_MIME
	jr nz, .check_defending_weak
	xor a
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr nz, .can_damage
	ld a, $01
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr z, .check_defending_weak
.can_damage
	ld a, 5
	call AddToAIScore

; if defending card is weak to this card, raise AI score
.check_defending_weak
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	call TranslateColorToWR
	ld c, a
	ld hl, wAIPlayerWeakness
	and [hl]
	jr z, .check_defending_resist
	ld a, 3
	call AddToAIScore

; if defending card is resistant to this card, lower AI score
.check_defending_resist
	ld a, c
	ld hl, wAIPlayerResistance
	and [hl]
	jr z, .check_resistance
	ld a, 2
	call SubFromAIScore

; if this card is resistant to defending Pokémon, raise AI score
.check_resistance
	ld a, [wAIPlayerColor]
	ld hl, wLoadedCard1Resistance
	and [hl]
	jr z, .check_weakness
	ld a, 2
	call AddToAIScore

; if this card is weak to defending Pokémon, lower AI score
.check_weakness
	ld a, [wAIPlayerColor]
	ld hl, wLoadedCard1Weakness
	and [hl]
	jr z, .check_retreat_cost
	ld a, 3
	call SubFromAIScore

; if this card's retreat cost < 2, raise AI score
; if this card's retreat cost > 2, lower AI score
.check_retreat_cost
	call GetPlayAreaCardRetreatCost
	cp 2
	jr c, .one_or_none
	jr z, .check_player_prize_count
	ld a, 1
	call SubFromAIScore
	jr .check_player_prize_count
.one_or_none
	ld a, 1
	call AddToAIScore

; if wcdda != $81
; if defending Pokémon can KO this card
; if player is not at last prize card, lower 3 from AI score
; if player is at last prize card, lower 10 from AI score
.check_player_prize_count
	ld a, [wcdda]
	cp %10000000 | %00000001
	jr z, .check_hp
	call CheckIfDefendingPokemonCanKnockOut
	jr nc, .check_hp
	ld e, 3
	ld a, [wAIPlayerPrizeCount]
	cp 1
	jr nz, .lower_score_1
	ld e, 10
.lower_score_1
	ld a, e
	call SubFromAIScore

; if this card's HP is 0, make AI score 0
.check_hp
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	jr nz, .add_hp_score
	ld [wAIScore], a
	jr .store_score

; AI score += floor(HP/40)
.add_hp_score
	ld b, a
	ld a, 4
	call CalculateBDividedByA_Bank5
	call CalculateByteTensDigit
	call AddToAIScore

; raise AI score if
;	- is a Mr Mime OR
;	- is a MewLv8 and defending card is not basic stage
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	cp MR_MIME
	jr z, .raise_score
	cp MEW_LV8
	jr nz, .asm_15cf0
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Stage]
	or a
	jr z, .asm_15cf0
.raise_score
	ld a, 5
	call AddToAIScore

; if wLoadedCard1Unknown2 == $01, lower AI score
.asm_15cf0
	ld a, [wLoadedCard1Unknown2]
	cp $01
	jr nz, .mysterious_fossil_or_clefairy_doll
	ld a, 2
	call SubFromAIScore

; if card is Mysterious Fossil or Clefairy Doll,
; lower AI score
.mysterious_fossil_or_clefairy_doll
	ld a, [wLoadedCard1ID]
	cp MYSTERIOUS_FOSSIL
	jr z, .lower_score_2
	cp CLEFAIRY_DOLL
	jr nz, .ai_score_bonus
.lower_score_2
	ld a, 10
	call SubFromAIScore

.ai_score_bonus
	ld b, a
	ld a, [wAICardListRetreatBonus + 1]
	or a
	jr z, .store_score
	ld h, a
	ld a, [wAICardListRetreatBonus]
	ld l, a

.loop_ids
	ld a, [hli]
	or a
	jr z, .store_score ; list is over
	cp b
	jr nz, .next_id
	ld a, [hl]
	cp $80
	jr c, .subtract_score
	sub $80
	call AddToAIScore
	jr .next_id
.subtract_score
	ld c, a
	ld a, $80
	sub c
	call SubFromAIScore
.next_id
	inc hl
	jr .loop_ids

.store_score
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld c, a
	ld b, $00
	ld hl, wPlayAreaAIScore
	add hl, bc
	ld a, [wAIScore]
	ld [hl], a
	pop bc
	inc c
	dec b
	jp nz, .next_bench

; done
	xor a
	ld [wAIRetreatScore], a
	jp FindHighestBenchScore

; handles AI action of retreating Arena Pokémon
; and chooses which energy cards to discard.
; if card can't discard, return carry.
; in case it's Clefairy Doll or Mysterious Fossil,
; handle its effect to discard itself instead of retreating.
; input:
;	- a = Play Area location (PLAY_AREA_*) of card to retreat to.
AITryToRetreat:
	push af
	ld a, [wAIPlayEnergyCardForRetreat]
	or a
	jr z, .check_id

; AI is allowed to play an energy card
; from the hand in order to provide
; the necessary energy for retreat cost

; check status
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	cp ASLEEP
	jp z, .check_id
	cp PARALYZED
	jp z, .check_id

; if an energy card hasn't been played yet,
; checks if the Pokémon needs just one more energy to retreat
; if it does, check if there are any energy cards in hand
; and if there are, play that energy card
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .check_id
	ld e, PLAY_AREA_ARENA
	call CountNumberOfEnergyCardsAttached
	push af
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call GetPlayAreaCardRetreatCost
	pop bc
	cp b
	jr c, .check_id
	jr z, .check_id
	; energy attached < retreat cost
	sub b
	cp 1
	jr nz, .check_id
	call CreateEnergyCardListFromHand
	jr c, .check_id
	ld a, [wDuelTempList]
	ldh [hTemp_ffa0], a
	xor a
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, OPPACTION_PLAY_ENERGY
	bank1call AIMakeDecision

.check_id
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp MYSTERIOUS_FOSSIL
	jp z, .mysterious_fossil_or_clefairy_doll
	cp CLEFAIRY_DOLL
	jp z, .mysterious_fossil_or_clefairy_doll

; if card is Asleep or Paralyzed, set carry and exit
; else, load the status in hTemp_ffa0
	pop af
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	ld b, a
	and CNF_SLP_PRZ
	cp ASLEEP
	jp z, .set_carry
	cp PARALYZED
	jp z, .set_carry
	ld a, b
	ldh [hTemp_ffa0], a
	ld a, $ff
	ldh [hTempRetreatCostCards], a

; check energy required to retreat
; if the cost is 0, retreat right away
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call GetPlayAreaCardRetreatCost
	ld [wTempCardRetreatCost], a
	or a
	jp z, .retreat

; if cost > 0 and number of energy cards attached == cost
; discard them all
	xor a
	call CreateArenaOrBenchEnergyCardList
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	ld c, a
	ld a, [wTempCardRetreatCost]
	cp c
	jr nz, .choose_energy_discard

	ld hl, hTempRetreatCostCards
	ld de, wDuelTempList
.loop_1
	ld a, [de]
	inc de
	ld [hli], a
	cp $ff
	jr nz, .loop_1
	jp .retreat

; if cost > 0 and number of energy cards attached > cost
; choose energy cards to discard according to color
.choose_energy_discard
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempCardID], a
	call LoadCardDataToBuffer1_FromCardID
	ld a, [wLoadedCard1Type]
	or TYPE_ENERGY
	ld [wTempCardType], a
	ld a, [wTempCardRetreatCost]
	ld c, a

; first, look for and discard double colorless energy
; if retreat cost is >= 2
	ld hl, wDuelTempList
	ld de, hTempRetreatCostCards
.loop_2
	ld a, c
	cp 2
	jr c, .energy_not_same_color
	ld a, [hli]
	cp $ff
	jr z, .energy_not_same_color
	ld [de], a
	push de
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	cp DOUBLE_COLORLESS_ENERGY
	jr nz, .loop_2
	ld a, [de]
	call RemoveCardFromDuelTempList
	dec hl
	inc de
	dec c
	dec c
	jr nz, .loop_2
	jr .end_retreat_list

; second, shuffle attached cards and discard energy cards
; that are not of the same type as the Pokémon
; the exception for this are cards that are needed for
; some attacks but are not of the same color as the Pokémon
; (i.e. Psyduck's Headache attack)
; and energy cards attached to Eevee corresponding to a
; color of any of its evolutions (water, fire, lightning)
.energy_not_same_color
	ld hl, wDuelTempList
	call CountCardsInDuelTempList
	call ShuffleCards
.loop_3
	ld a, [hli]
	cp $ff
	jr z, .any_energy
	ld [de], a
	call CheckIfEnergyIsUseful
	jr c, .loop_3
	ld a, [de]
	call RemoveCardFromDuelTempList
	dec hl
	inc de
	dec c
	jr nz, .loop_3
	jr .end_retreat_list

; third, discard any card until
; cost requirement is met
.any_energy
	ld hl, wDuelTempList
.loop_4
	ld a, [hli]
	cp $ff
	jr z, .set_carry
	ld [de], a
	inc de
	push de
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	cp DOUBLE_COLORLESS_ENERGY
	jr nz, .not_double_colorless
	dec c
	jr z, .end_retreat_list
.not_double_colorless
	dec c
	jr nz, .loop_4

.end_retreat_list
	ld a, $ff
	ld [de], a

.retreat
	ld a, OPPACTION_ATTEMPT_RETREAT
	bank1call AIMakeDecision
	or a
	ret
.set_carry
	scf
	ret

; handle Mysterious Fossil and Clefairy Doll
; if there are bench Pokémon, use effect to discard card
; this is equivalent to using its Pokémon Power
.mysterious_fossil_or_clefairy_doll
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 2
	jr nc, .has_bench
	; doesn't have any bench
	pop af
	jr .set_carry

.has_bench
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [hTempCardIndex_ff9f], a
	xor a
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_USE_PKMN_POWER
	bank1call AIMakeDecision
	pop af
	ldh [hAIPkmnPowerEffectParam], a
	ld a, OPPACTION_EXECUTE_PKMN_POWER_EFFECT
	bank1call AIMakeDecision
	ld a, OPPACTION_DUEL_MAIN_SCENE
	bank1call AIMakeDecision
	or a
	ret
