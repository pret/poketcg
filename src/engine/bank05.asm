INCLUDE "data/deck_ai_pointers.asm"

AIActionTable_Unreferenced: ; 1406a (5:406a)
	dw $406c
	dw .do_turn
	dw .do_turn
	dw .star_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14078 (5:4078)
	call AIDecidePlayPokemonCard
	call AIDecideWhetherToRetreat
	jr nc, .try_attack
	call AIDecideBenchPokemonToSwitchTo
	call AITryToRetreat
	call AIDecideWhetherToRetreat
	jr nc, .try_attack
	call AIDecideBenchPokemonToSwitchTo
	call AITryToRetreat
.try_attack
	call AIProcessAndTryToPlayEnergy
	call AIProcessAndTryToUseAttack
	ret c
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret

.star_duel ; 1409e (5:409e)
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 140a2 (5:40a2)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 140a6 (5:40a6)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 140aa (5:40aa)
	call AIPickPrizeCards
	ret

; returns carry if damage dealt from any of
; a card's moves KOs defending Pokémon
; outputs index of the move that KOs
; input:
;	[hTempPlayAreaLocation_ff9d] = location of attacking card to consider
; output:
;	[wSelectedAttack] = move index that KOs
CheckIfAnyMoveKnocksOutDefendingCard: ; 140ae (5:40ae)
	xor a ; first move
	call CheckIfMoveKnocksOutDefendingCard
	ret c
	ld a, $01 ; second move
;	fallthrough

CheckIfMoveKnocksOutDefendingCard: ; 140b5 (5:40b5)
	call EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	ret c
	ret nz
	scf
	ret

; returns carry if any of the defending Pokémon's attacks
; brings card at hTempPlayAreaLocation_ff9d down
; to exactly 0 HP.
; outputs that attack index in wSelectedMove.
CheckIfAnyDefendingPokemonAttackDealsSameDamageAsHP: ; 140c5 (5:40c5)
	xor a ; FIRST_ATTACK_OR_PKMN_POWER
	call .check_damage
	ret c
	ld a, SECOND_ATTACK

.check_damage
	call EstimateDamage_FromDefendingPokemon
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr z, .true
	ret
.true
	scf
	ret

; checks AI scores for all benched Pokémon
; returns the location of the card with highest score
; in a and [hTempPlayAreaLocation_ff9d]
FindHighestBenchScore: ; 140df (5:40df)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld b, a
	ld c, 0
	ld e, c
	ld d, c
	ld hl, wPlayAreaAIScore + 1
	jp .next

.loop
	ld a, [hli]
	cp e
	jr c, .next
	ld e, a
	ld d, c
.next
	inc c
	dec b
	jr nz, .loop

	ld a, d
	ldh [hTempPlayAreaLocation_ff9d], a
	or a
	ret

; adds a to wAIScore
; if there's overflow, it's capped at $ff
; output:
;	a = a + wAIScore (capped at $ff)
AddToAIScore: ; 140fe (5:40fe)
	push hl
	ld hl, wAIScore
	add [hl]
	jr nc, .no_cap
	ld a, $ff
.no_cap
	ld [hl], a
	pop hl
	ret

; subs a from wAIScore
; if there's underflow, it's capped at $00
SubFromAIScore: ; 1410a (5:410a)
	push hl
	push de
	ld e, a
	ld hl, wAIScore
	ld a, [hl]
	or a
	jr z, .done
	sub e
	ld [hl], a
	jr nc, .done
	ld [hl], $00
.done
	pop de
	pop hl
	ret

; loads defending Pokémon's weakness/resistance
; and the number of prize cards in both sides
LoadDefendingPokemonColorWRAndPrizeCards: ; 1411d (5:411d)
	call SwapTurn
	call GetArenaCardColor
	call TranslateColorToWR
	ld [wAIPlayerColor], a
	call GetArenaCardWeakness
	ld [wAIPlayerWeakness], a
	call GetArenaCardResistance
	ld [wAIPlayerResistance], a
	call CountPrizes
	ld [wAIPlayerPrizeCount], a
	call SwapTurn
	call CountPrizes
	ld [wAIOpponentPrizeCount], a
	ret

; called when AI has chosen its attack.
; executes all effects and damage.
; handles AI choosing parameters for certain attacks as well.
AITryUseAttack: ; 14145 (5:4145)
	ld a, [wSelectedAttack]
	ldh [hTemp_ffa0], a
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [hTempCardIndex_ff9f], a
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld a, OPPACTION_BEGIN_ATTACK
	bank1call AIMakeDecision
	ret c

	call AISelectSpecialAttackParameters
	jr c, .use_attack
	ld a, EFFECTCMDTYPE_AI_SELECTION
	call TryExecuteEffectCommandFunction

.use_attack
	ld a, [wSelectedAttack]
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld a, OPPACTION_USE_ATTACK
	bank1call AIMakeDecision
	ret c

	ld a, EFFECTCMDTYPE_AI_SWITCH_DEFENDING_PKMN
	call TryExecuteEffectCommandFunction
	ld a, OPPACTION_ATTACK_ANIM_AND_DAMAGE
	bank1call AIMakeDecision
	ret

; return carry if any of the following is satisfied:
;	- deck index in a corresponds to a double colorless energy card;
;	- card type in wTempCardType is colorless;
;	- card ID in wTempCardID is a Pokémon card that has
;	  moves that require energy other than its color and
;	  the deck index in a corresponds to that energy type;
;	- card ID is Eevee and a corresponds to an energy type
;	  of water, fire or lightning;
;	- type of card in register a is the same as wTempCardType.
; used for knowing if a given energy card can be discarded
; from a given Pokémon card
; input:
;	a = energy card attached to Pokémon to check
;	[wTempCardType] = TYPE_ENERGY_* of given Pokémon
;	[wTempCardID] = card index of Pokémon card to check
CheckIfEnergyIsUseful: ; 14184 (5:4184)
	push de
	call GetCardIDFromDeckIndex
	ld a, e
	cp DOUBLE_COLORLESS_ENERGY
	jr z, .set_carry
	ld a, [wTempCardType]
	cp TYPE_ENERGY_DOUBLE_COLORLESS
	jr z, .set_carry
	ld a, [wTempCardID]

	ld d, PSYCHIC_ENERGY
	cp EXEGGCUTE
	jr z, .check_energy
	cp EXEGGUTOR
	jr z, .check_energy
	cp PSYDUCK
	jr z, .check_energy
	cp GOLDUCK
	jr z, .check_energy

	ld d, WATER_ENERGY
	cp SURFING_PIKACHU1
	jr z, .check_energy
	cp SURFING_PIKACHU2
	jr z, .check_energy

	cp EEVEE
	jr nz, .check_type
	ld a, e
	cp WATER_ENERGY
	jr z, .set_carry
	cp FIRE_ENERGY
	jr z, .set_carry
	cp LIGHTNING_ENERGY
	jr z, .set_carry

.check_type
	ld d, $00 ; unnecessary?
	call GetCardType
	ld d, a
	ld a, [wTempCardType]
	cp d
	jr z, .set_carry
	pop de
	or a
	ret

.check_energy
	ld a, d
	cp e
	jr nz, .check_type
.set_carry
	pop de
	scf
	ret

; pick a random Pokemon in the bench.
; output:
;	- a = PLAY_AREA_* of Bench Pokemon picked.
PickRandomBenchPokemon: ; 141da (5:41da)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	dec a
	call Random
	inc a
	ret

AIPickPrizeCards: ; 141e5 (5:41e5)
	ld a, [wNumberPrizeCardsToTake]
	ld b, a
.loop
	call .PickPrizeCard
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	or a
	jr z, .done
	dec b
	jr nz, .loop
.done
	ret

; picks a prize card at random
; and adds it to the hand.
.PickPrizeCard: ; 141f8 (5:41f8)
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	push hl
	ld c, a

; choose a random prize card until
; one is found that isn't taken already.
.loop_pick_prize
	ld a, 6
	call Random
	ld e, a
	ld d, $00
	ld hl, .prize_flags
	add hl, de
	ld a, [hl]
	and c
	jr z, .loop_pick_prize ; no prize

; prize card was found
; remove this prize from wOpponentPrizes
	ld a, [hl]
	pop hl
	cpl
	and [hl]
	ld [hl], a

; add this prize card to the hand
	ld a, e
	add DUELVARS_PRIZE_CARDS
	call GetTurnDuelistVariable
	call AddCardToHand
	ret

.prize_flags ; 1421e (5:421e)
	db $1 << 0
	db $1 << 1
	db $1 << 2
	db $1 << 3
	db $1 << 4
	db $1 << 5
	db $1 << 6
	db $1 << 7

; routine for AI to play all Basic cards from its hand
; in the beginning of the Duel.
AIPlayInitialBasicCards: ; 14226 (5:4226)
	call CreateHandCardList
	ld hl, wDuelTempList
.check_for_next_card
	ld a, [hli]
	ldh [hTempCardIndex_ff98], a
	cp $ff
	ret z ; return when done

	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .check_for_next_card ; skip if not Pokemon card
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .check_for_next_card ; skip if not Basic Stage

; play Basic card from hand
	push hl
	ldh a, [hTempCardIndex_ff98]
	call PutHandPokemonCardInPlayArea
	pop hl
	jr .check_for_next_card

; returns carry if Pokémon at hTempPlayAreaLocation_ff9d
; can't use a move or if that selected move doesn't have enough energy
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedAttack]         = selected move to examine
CheckIfSelectedMoveIsUnusable: ; 1424b (5:424b)
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .bench

	bank1call HandleCantAttackSubstatus
	ret c
	bank1call CheckIfActiveCardParalyzedOrAsleep
	ret c

	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wSelectedAttack]
	ld e, a
	call CopyMoveDataAndDamage_FromDeckIndex
	call HandleAmnesiaSubstatus
	ret c
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_1
	call TryExecuteEffectCommandFunction
	ret c

.bench
	call CheckEnergyNeededForAttack
	ret c ; can't be used
	ld a, MOVE_FLAG2_ADDRESS | FLAG_2_BIT_5_F
	call CheckLoadedMoveFlag
	ret

; load selected move from Pokémon in hTempPlayAreaLocation_ff9d
; and checks if there is enough energy to execute the selected move
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedAttack]         = selected move to examine
; output:
;	b = basic energy still needed
;	c = colorless energy still needed
;	e = output of ConvertColorToEnergyCardID, or $0 if not a move
;	carry set if no move
;	       OR if it's a Pokémon Power
;	       OR if not enough energy for move
CheckEnergyNeededForAttack: ; 14279 (5:4279)
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wSelectedAttack]
	ld e, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld hl, wLoadedMoveName
	ld a, [hli]
	or [hl]
	jr z, .no_attack
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr nz, .is_attack
.no_attack
	lb bc, 0, 0
	ld e, c
	scf
	ret

.is_attack
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	bank1call HandleEnergyBurn

	xor a
	ld [wTempLoadedMoveEnergyCost], a
	ld [wTempLoadedMoveEnergyNeededAmount], a
	ld [wTempLoadedMoveEnergyNeededType], a

	ld hl, wAttachedEnergies
	ld de, wLoadedMoveEnergyCost
	ld b, 0
	ld c, (NUM_TYPES / 2) - 1

.loop
	; check all basic energy cards except colorless
	ld a, [de]
	swap a
	call CheckIfEnoughParticularAttachedEnergy
	ld a, [de]
	call CheckIfEnoughParticularAttachedEnergy
	inc de
	dec c
	jr nz, .loop

; running CheckIfEnoughParticularAttachedEnergy back to back like this
; overwrites the results of a previous call of this function,
; however, no move in the game has energy requirements for two
; different energy types (excluding colorless), so this routine
; will always just return the result for one type of basic energy,
; while all others will necessarily have an energy cost of 0
; if moves are added to the game with energy requirements of
; two different basic energy types, then this routine only accounts
; for the type with the highest index

	; colorless
	ld a, [de]
	swap a
	and %00001111
	ld b, a ; colorless energy still needed
	ld a, [wTempLoadedMoveEnergyCost]
	ld hl, wTempLoadedMoveEnergyNeededAmount
	sub [hl]
	ld c, a ; basic energy still needed
	ld a, [wTotalAttachedEnergies]
	sub c
	sub b
	jr c, .not_enough

	ld a, [wTempLoadedMoveEnergyNeededAmount]
	or a
	ret z

; being here means the energy cost isn't satisfied,
; including with colorless energy
	xor a
.not_enough
	cpl
	inc a
	ld c, a ; colorless energy still needed
	ld a, [wTempLoadedMoveEnergyNeededAmount]
	ld b, a ; basic energy still needed
	ld a, [wTempLoadedMoveEnergyNeededType]
	call ConvertColorToEnergyCardID
	ld e, a
	ld d, 0
	scf
	ret

; takes as input the energy cost of a move for a
; particular energy, stored in the lower nibble of a
; if the move costs some amount of this energy, the lower nibble of a != 0,
; and this amount is stored in wTempLoadedMoveEnergyCost
; sets carry flag if not enough energy of this type attached
; input:
;	a    = this energy cost of move (lower nibble)
;	[hl] = attached energy
; output:
;	carry set if not enough of this energy type attached
CheckIfEnoughParticularAttachedEnergy: ; 142f4 (5:42f4)
	and %00001111
	jr nz, .check
.has_enough
	inc hl
	inc b
	or a
	ret

.check
	ld [wTempLoadedMoveEnergyCost], a
	sub [hl]
	jr z, .has_enough
	jr c, .has_enough

	; not enough energy
	ld [wTempLoadedMoveEnergyNeededAmount], a
	ld a, b
	ld [wTempLoadedMoveEnergyNeededType], a
	inc hl
	inc b
	scf
	ret

; input:
;	a = energy type
; output:
;	a = energy card ID
ConvertColorToEnergyCardID: ; 1430f (5:430f)
	push hl
	push de
	ld e, a
	ld d, 0
	ld hl, .card_id
	add hl, de
	ld a, [hl]
	pop de
	pop hl
	ret

.card_id
	db FIRE_ENERGY
	db GRASS_ENERGY
	db LIGHTNING_ENERGY
	db WATER_ENERGY
	db FIGHTING_ENERGY
	db PSYCHIC_ENERGY
	db DOUBLE_COLORLESS_ENERGY

Func_14323: ; 14323 (5:4323)
	INCROM $14323, $1433d

; return carry depending on card index in a:
;	- if energy card, return carry if no energy card has been played yet
;	- if basic Pokémon card, return carry if there's space in bench
;	- if evolution card, return carry if there's a Pokémon
;	  in Play Area it can evolve
;	- if trainer card, return carry if it can be used
; input:
;	a = card index to check
CheckIfCardCanBePlayed: ; 1433d (5:433d)
	ldh [hTempCardIndex_ff9f], a
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr c, .pokemon_card
	cp TYPE_TRAINER
	jr z, .trainer_card

; energy card
	ld a, [wAlreadyPlayedEnergy]
	or a
	ret z
	scf
	ret

.pokemon_card
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .evolution_card
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	ccf
	ret

.evolution_card
	bank1call IsPrehistoricPowerActive
	ret c
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld b, 0
.loop
	push bc
	ld e, b
	ldh a, [hTempCardIndex_ff9f]
	ld d, a
	call CheckIfCanEvolveInto
	pop bc
	ret nc
	inc b
	dec c
	jr nz, .loop
	scf
	ret

.trainer_card
	bank1call CheckCantUseTrainerDueToHeadache
	ret c
	call LoadNonPokemonCardEffectCommands
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_1
	call TryExecuteEffectCommandFunction
	ret

; loads all the energy cards
; in hand in wDuelTempList
; return carry if no energy cards found
CreateEnergyCardListFromHand: ; 1438c (5:438c)
	push hl
	push de
	push bc
	ld de, wDuelTempList
	ld b, a
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	ld c, a
	inc c
	ld l, LOW(wOpponentHand)
	jr .decrease

.loop
	ld a, [hli]
	push de
	call GetCardIDFromDeckIndex
	call GetCardType
	pop de
	and TYPE_ENERGY
	jr z, .decrease
	dec hl
	ld a, [hli]
	ld [de], a
	inc de
.decrease
	dec c
	jr nz, .loop

	ld a, $ff
	ld [de], a
	pop bc
	pop de
	pop hl
	ld a, [wDuelTempList]
	cp $ff
	ccf
	ret

; looks for card ID in hand and
; sets carry if a card wasn't found
; as opposed to LookForCardIDInHandList_Bank5
; this function doesn't create a list
; and preserves hl, de and bc
; input:
;	a = card ID
; output:
;	a = card deck index, if found
;	carry set if NOT found
LookForCardIDInHand: ; 143bf (5:43bf)
	push hl
	push de
	push bc
	ld b, a
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	ld c, a
	inc c
	ld l, DUELVARS_HAND
	jr .next

.loop
	ld a, [hli]
	call GetCardIDFromDeckIndex
	ld a, e
	cp b
	jr z, .no_carry
.next
	dec c
	jr nz, .loop

	pop bc
	pop de
	pop hl
	scf
	ret

.no_carry
	dec hl
	ld a, [hl]
	pop bc
	pop de
	pop hl
	or a
	ret

; stores in wDamage, wAIMinDamage and wAIMaxDamage the calculated damage
; done to the defending Pokémon by a given card and move
; input:
;	a = move index to take into account
;	[hTempPlayAreaLocation_ff9d] = location of attacking card to consider
EstimateDamage_VersusDefendingCard: ; 143e5 (5:43e5)
	ld [wSelectedAttack], a
	ld e, a
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr nz, .is_attack

; is a Pokémon Power
; set wDamage, wAIMinDamage and wAIMaxDamage to zero
	ld hl, wDamage
	xor a
	ld [hli], a
	ld [hl], a
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	ld e, a
	ld d, a
	ret

.is_attack
; set wAIMinDamage and wAIMaxDamage to damage of move
; these values take into account the range of damage
; that the move can span (e.g. min and max number of hits)
	ld a, [wDamage]
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	ld a, EFFECTCMDTYPE_AI
	call TryExecuteEffectCommandFunction
	ld a, [wAIMinDamage]
	ld hl, wAIMaxDamage
	or [hl]
	jr nz, .calculation
	ld a, [wDamage]
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a

.calculation
; if temp. location is active, damage calculation can be done directly...
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr z, CalculateDamage_VersusDefendingPokemon

; ...otherwise substatuses need to be temporarily reset to account
; for the switching, to obtain the right damage calculation...
	; reset substatus1
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	push af
	push hl
	ld [hl], $00
	; reset substatus2
	ld l, DUELVARS_ARENA_CARD_SUBSTATUS2
	ld a, [hl]
	push af
	push hl
	ld [hl], $00
	; reset changed resistance
	ld l, DUELVARS_ARENA_CARD_CHANGED_RESISTANCE
	ld a, [hl]
	push af
	push hl
	ld [hl], $00
	call CalculateDamage_VersusDefendingPokemon
; ...and subsequently recovered to continue the battle normally
	pop hl
	pop af
	ld [hl], a
	pop hl
	pop af
	ld [hl], a
	pop hl
	pop af
	ld [hl], a
	ret

; calculates the damage that will be dealt to the player's active card
; using the card that is located in hTempPlayAreaLocation_ff9d
; taking into account weakness/resistance/pluspowers/defenders/etc
; and outputs the result capped at a max of $ff
; input:
;	[wAIMinDamage] = base damage
;	[wAIMaxDamage] = base damage
;	[wDamage]      = base damage
;	[hTempPlayAreaLocation_ff9d] = turn holder's card location as the attacker
CalculateDamage_VersusDefendingPokemon: ; 14453 (5:4453)
	ld hl, wAIMinDamage
	call _CalculateDamage_VersusDefendingPokemon
	ld hl, wAIMaxDamage
	call _CalculateDamage_VersusDefendingPokemon
	ld hl, wDamage
;	fallthrough

_CalculateDamage_VersusDefendingPokemon: ; 14462 (5:4462)
	ld e, [hl]
	ld d, $00
	push hl

	; load this card's data
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2ID]
	ld [wTempTurnDuelistCardID], a

	; load player's arena card data
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2ID]
	ld [wTempNonTurnDuelistCardID], a
	call SwapTurn

	push de
	call HandleNoDamageOrEffectSubstatus
	pop de
	jr nc, .vulnerable
	; invulnerable to damage
	ld de, $0
	jr .done
.vulnerable
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	call z, HandleDoubleDamageSubstatus
	; skips the weak/res checks if unaffected.
	bit UNAFFECTED_BY_WEAKNESS_RESISTANCE_F, d
	res UNAFFECTED_BY_WEAKNESS_RESISTANCE_F, d
	jr nz, .not_resistant

; handle weakness
	ldh a, [hTempPlayAreaLocation_ff9d]
	call GetPlayAreaCardColor
	call TranslateColorToWR
	ld b, a
	call SwapTurn
	call GetArenaCardWeakness
	call SwapTurn
	and b
	jr z, .not_weak
	; double de
	sla e
	rl d

.not_weak
; handle resistance
	call SwapTurn
	call GetArenaCardResistance
	call SwapTurn
	and b
	jr z, .not_resistant
	ld hl, -30
	add hl, de
	ld e, l
	ld d, h

.not_resistant
	; apply pluspower and defender boosts
	ldh a, [hTempPlayAreaLocation_ff9d]
	add CARD_LOCATION_ARENA
	ld b, a
	call ApplyAttachedPluspower
	call SwapTurn
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedDefender
	call HandleDamageReduction
	; test if de underflowed
	bit 7, d
	jr z, .no_underflow
	ld de, $0

.no_underflow
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and DOUBLE_POISONED
	jr z, .not_poisoned
	ld c, 20
	and DOUBLE_POISONED & (POISONED ^ $ff)
	jr nz, .add_poison
	ld c, 10
.add_poison
	ld a, c
	add e
	ld e, a
	ld a, $00
	adc d
	ld d, a
.not_poisoned
	call SwapTurn

.done
	pop hl
	ld [hl], e
	ld a, d
	or a
	ret z
	; cap damage
	ld a, $ff
	ld [hl], a
	ret

; stores in wDamage, wAIMinDamage and wAIMaxDamage the calculated damage
; done to the Pokémon at hTempPlayAreaLocation_ff9d
; by the defending Pokémon, using the move index at a
; input:
;	a = move index
;	[hTempPlayAreaLocation_ff9d] = location of card to calculate
;	                               damage as the receiver
EstimateDamage_FromDefendingPokemon: ; 1450b (5:450b)
	call SwapTurn
	ld [wSelectedAttack], a
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	call SwapTurn
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr nz, .is_attack

; is a Pokémon Power
; set wDamage, wAIMinDamage and wAIMaxDamage to zero
	ld hl, wDamage
	xor a
	ld [hli], a
	ld [hl], a
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	ld e, a
	ld d, a
	ret

.is_attack
; set wAIMinDamage and wAIMaxDamage to damage of move
; these values take into account the range of damage
; that the move can span (e.g. min and max number of hits)
	ld a, [wDamage]
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	call SwapTurn
	ldh a, [hTempPlayAreaLocation_ff9d]
	push af
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, EFFECTCMDTYPE_AI
	call TryExecuteEffectCommandFunction
	pop af
	ldh [hTempPlayAreaLocation_ff9d], a
	call SwapTurn
	ld a, [wAIMinDamage]
	ld hl, wAIMaxDamage
	or [hl]
	jr nz, .calculation
	ld a, [wDamage]
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a

.calculation
; if temp. location is active, damage calculation can be done directly...
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr z, CalculateDamage_FromDefendingPokemon

; ...otherwise substatuses need to be temporarily reset to account
; for the switching, to obtain the right damage calculation...
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	push af
	push hl
	ld [hl], $00
	; reset substatus2
	ld l, DUELVARS_ARENA_CARD_SUBSTATUS2
	ld a, [hl]
	push af
	push hl
	ld [hl], $00
	; reset changed resistance
	ld l, DUELVARS_ARENA_CARD_CHANGED_RESISTANCE
	ld a, [hl]
	push af
	push hl
	ld [hl], $00
	call CalculateDamage_FromDefendingPokemon
; ...and subsequently recovered to continue the battle normally
	pop hl
	pop af
	ld [hl], a
	pop hl
	pop af
	ld [hl], a
	pop hl
	pop af
	ld [hl], a
	ret

; similar to CalculateDamage_VersusDefendingPokemon but reversed,
; calculating damage of the defending Pokémon versus
; the card located in hTempPlayAreaLocation_ff9d
; taking into account weakness/resistance/pluspowers/defenders/etc
; and poison damage for two turns
; and outputs the result capped at a max of $ff
; input:
;	[wAIMinDamage] = base damage
;	[wAIMaxDamage] = base damage
;	[wDamage]      = base damage
;	[hTempPlayAreaLocation_ff9d] = location of card to calculate
;								 damage as the receiver
CalculateDamage_FromDefendingPokemon: ; 1458c (5:458c)
	ld hl, wAIMinDamage
	call .CalculateDamage
	ld hl, wAIMaxDamage
	call .CalculateDamage
	ld hl, wDamage
	; fallthrough

.CalculateDamage ; 1459b (5:459b)
	ld e, [hl]
	ld d, $00
	push hl

	; load player active card's data
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2ID]
	ld [wTempTurnDuelistCardID], a
	call SwapTurn

	; load opponent's card data
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2ID]
	ld [wTempNonTurnDuelistCardID], a

	call SwapTurn
	call HandleDoubleDamageSubstatus
	bit UNAFFECTED_BY_WEAKNESS_RESISTANCE_F, d
	res UNAFFECTED_BY_WEAKNESS_RESISTANCE_F, d
	jr nz, .not_resistant

; handle weakness
	call GetArenaCardColor
	call TranslateColorToWR
	ld b, a
	call SwapTurn
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .bench_weak
	ld a, DUELVARS_ARENA_CARD_CHANGED_WEAKNESS
	call GetTurnDuelistVariable
	or a
	jr nz, .unchanged_weak

.bench_weak
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Weakness]
.unchanged_weak
	and b
	jr z, .not_weak
	; double de
	sla e
	rl d

.not_weak
; handle resistance
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .bench_res
	ld a, DUELVARS_ARENA_CARD_CHANGED_RESISTANCE
	call GetTurnDuelistVariable
	or a
	jr nz, .unchanged_res

.bench_res
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Resistance]
.unchanged_res
	and b
	jr z, .not_resistant
	ld hl, -30
	add hl, de
	ld e, l
	ld d, h

.not_resistant
	; apply pluspower and defender boosts
	call SwapTurn
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	call SwapTurn
	ldh a, [hTempPlayAreaLocation_ff9d]
	add CARD_LOCATION_ARENA
	ld b, a
	call ApplyAttachedDefender
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	call z, HandleDamageReduction
	bit 7, d
	jr z, .no_underflow
	ld de, $0

.no_underflow
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .done
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and DOUBLE_POISONED
	jr z, .done
	ld c, 40
	and DOUBLE_POISONED & (POISONED ^ $ff)
	jr nz, .add_poison
	ld c, 20
.add_poison
	ld a, c
	add e
	ld e, a
	ld a, $00
	adc d
	ld d, a

.done
	pop hl
	ld [hl], e
	ld a, d
	or a
	ret z
	ld a, $ff
	ld [hl], a
	ret

AIProcessHandTrainerCards: ; 14663 (5:4663)
	farcall _AIProcessHandTrainerCards
	ret

INCLUDE "engine/deck_ai/deck_ai.asm"

; return carry if card ID loaded in a is found in hand
; and outputs in a the deck index of that card
; as opposed to LookForCardIDInHand, this function
; creates a list in wDuelTempList
; input:
;	a = card ID
; output:
;	a = card deck index, if found
;	carry set if found
LookForCardIDInHandList_Bank5: ; 155d2 (5:55d2)
	ld [wTempCardIDToLook], a
	call CreateHandCardList
	ld hl, wDuelTempList

.loop
	ld a, [hli]
	cp $ff
	ret z
	ldh [hTempCardIndex_ff98], a
	call LoadCardDataToBuffer1_FromDeckIndex
	ld b, a
	ld a, [wTempCardIDToLook]
	cp b
	jr nz, .loop

	ldh a, [hTempCardIndex_ff98]
	scf
	ret

; returns carry if card ID in a
; is found in Play Area, starting with
; location in b
; input:
;	a = card ID
;	b = PLAY_AREA_* to start with
; output:
;	a = PLAY_AREA_* of found card
;	carry set if found
LookForCardIDInPlayArea_Bank5: ; 155ef (5:55ef)
	ld [wTempCardIDToLook], a

.loop
	ld a, DUELVARS_ARENA_CARD
	add b
	call GetTurnDuelistVariable
	cp $ff
	ret z
	call LoadCardDataToBuffer1_FromDeckIndex
	ld c, a
	ld a, [wTempCardIDToLook]
	cp c
	jr z, .found
	inc b
	ld a, MAX_PLAY_AREA_POKEMON
	cp b
	jr nz, .loop

	ld b, $ff
	or a
	ret
.found
	ld a, b
	scf
	ret

; check if energy card ID in e is in AI hand and,
; if so, attaches it to card ID in d in Play Area.
; input:
;	e = Energy card ID
;	d = Pokemon card ID
AIAttachEnergyInHandToCardInPlayArea: ; 15612 (5:5612)
	ld a, e
	push de
	call LookForCardIDInHandList_Bank5
	pop de
	ret nc ; not in hand
	ld b, PLAY_AREA_ARENA

.attach
	ld e, a
	ld a, d
	call LookForCardIDInPlayArea_Bank5
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, e
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_PLAY_ENERGY
	bank1call AIMakeDecision
	ret

; same as AIAttachEnergyInHandToCardInPlayArea but
; only look for card ID in the Bench.
AIAttachEnergyInHandToCardInBench: ; 1562b (5:562b)
	ld a, e
	push de
	call LookForCardIDInHandList_Bank5
	pop de
	ret nc
	ld b, PLAY_AREA_BENCH_1
	jr AIAttachEnergyInHandToCardInPlayArea.attach

InitAIDuelVars: ; 15636 (5:5636)
	ld a, $10
	ld hl, wcda5
	call ClearMemory_Bank5
	ld a, 5
	ld [wAIPokedexCounter], a
	ld a, $ff
	ld [wcda5], a
	ret

; initializes some variables and sets value of wAIBarrierFlagCounter.
; if Player uses Barrier 3 times in a row, AI checks if Player's deck
; has only Mewtwo1 Pokemon cards (running a Mewtwo1 mill deck).
InitAITurnVars: ; 15649 (5:5649)
; increase Pokedex counter by 1
	ld a, [wAIPokedexCounter]
	inc a
	ld [wAIPokedexCounter], a

	xor a
	ld [wPreviousAIFlags], a
	ld [wcddb], a
	ld [wcddc], a
	ld [wAIRetreatedThisTurn], a

; checks if the Player used an attack last turn
; and if it was the second attack of their card.
	ld a, [wPlayerAttackingMoveIndex]
	cp $ff
	jr z, .check_flag
	or a
	jr z, .check_flag
	ld a, [wPlayerAttackingCardIndex]
	cp $ff
	jr z, .check_flag

; if the card is Mewtwo1, it means the Player
; used its second attack, Barrier.
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MEWTWO1
	jr nz, .check_flag
	; Player used Barrier last turn

; check if flag was already set, if so,
; reset wAIBarrierFlagCounter to $80.
	ld a, [wAIBarrierFlagCounter]
	bit AI_MEWTWO_MILL_F, a
	jr nz, .set_flag

; if not, increase it by 1 and check if it exceeds 2.
	inc a
	ld [wAIBarrierFlagCounter], a
	cp 3
	jr c, .done

; this means that the Player used Barrier
; at least 3 turns in a row.
; check if Player is running Mewtwo1-only deck,
; if so, set wAIBarrierFlagCounter flag.
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MEWTWO1
	jr nz, .reset_1
	farcall CheckIfPlayerHasPokemonOtherThanMewtwo1
	jr nc, .set_flag
.reset_1
; reset wAIBarrierFlagCounter
	xor a
	ld [wAIBarrierFlagCounter], a
	jr .done

.set_flag
	ld a, AI_MEWTWO_MILL
	ld [wAIBarrierFlagCounter], a
	jr .done

.check_flag
; increase counter by 1 if flag is set
	ld a, [wAIBarrierFlagCounter]
	bit AI_MEWTWO_MILL_F, a
	jr z, .reset_2
	inc a
	ld [wAIBarrierFlagCounter], a
	jr .done

.reset_2
; reset wAIBarrierFlagCounter
	xor a
	ld [wAIBarrierFlagCounter], a
.done
	ret

; load selected move from Pokémon in hTempPlayAreaLocation_ff9d,
; gets an energy card to discard and subsequently
; check if there is enough energy to execute the selected move
; after removing that attached energy card.
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedAttack]         = selected move to examine
; output:
;	b = basic energy still needed
;	c = colorless energy still needed
;	e = output of ConvertColorToEnergyCardID, or $0 if not a move
;	carry set if no move
;	       OR if it's a Pokémon Power
;	       OR if not enough energy for move
CheckEnergyNeededForAttackAfterDiscard: ; 156c3 (5:56c3)
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wSelectedAttack]
	ld e, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld hl, wLoadedMoveName
	ld a, [hli]
	or [hl]
	jr z, .no_attack
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr nz, .is_attack
.no_attack
	lb bc, 0, 0
	ld e, c
	scf
	ret

.is_attack
	ldh a, [hTempPlayAreaLocation_ff9d]
	farcall AIPickEnergyCardToDiscard
	call LoadCardDataToBuffer1_FromDeckIndex
	cp DOUBLE_COLORLESS_ENERGY
	jr z, .colorless

; color energy
; decrease respective attached energy by 1.
	ld hl, wAttachedEnergies
	dec a
	ld c, a
	ld b, $00
	add hl, bc
	dec [hl]
	ld hl, wTotalAttachedEnergies
	dec [hl]
	jr .asm_1570c
; decrease attached colorless by 2.
.colorless
	ld hl, wAttachedEnergies + COLORLESS
	dec [hl]
	dec [hl]
	ld hl, wTotalAttachedEnergies
	dec [hl]
	dec [hl]

.asm_1570c
	bank1call HandleEnergyBurn
	xor a
	ld [wTempLoadedMoveEnergyCost], a
	ld [wTempLoadedMoveEnergyNeededAmount], a
	ld [wTempLoadedMoveEnergyNeededType], a
	ld hl, wAttachedEnergies
	ld de, wLoadedMoveEnergyCost
	ld b, 0
	ld c, (NUM_TYPES / 2) - 1
.loop
	; check all basic energy cards except colorless
	ld a, [de]
	swap a
	call CheckIfEnoughParticularAttachedEnergy
	ld a, [de]
	call CheckIfEnoughParticularAttachedEnergy
	inc de
	dec c
	jr nz, .loop

	ld a, [de]
	swap a
	and $0f
	ld b, a ; colorless energy still needed
	ld a, [wTempLoadedMoveEnergyCost]
	ld hl, wTempLoadedMoveEnergyNeededAmount
	sub [hl]
	ld c, a ; basic energy still needed
	ld a, [wTotalAttachedEnergies]
	sub c
	sub b
	jr c, .not_enough_energy

	ld a, [wTempLoadedMoveEnergyNeededAmount]
	or a
	ret z

; being here means the energy cost isn't satisfied,
; including with colorless energy
	xor a
.not_enough_energy
	cpl
	inc a
	ld c, a ; colorless energy still needed
	ld a, [wTempLoadedMoveEnergyNeededAmount]
	ld b, a ; basic energy still needed
	ld a, [wTempLoadedMoveEnergyNeededType]
	call ConvertColorToEnergyCardID
	ld e, a
	ld d, 0
	scf
	ret

; zeroes a bytes starting at hl
ClearMemory_Bank5: ; 1575e (5:575e)
	push af
	push bc
	push hl
	ld b, a
	xor a
.clear_loop
	ld [hli], a
	dec b
	jr nz, .clear_loop
	pop hl
	pop bc
	pop af
	ret

; returns in a the tens digit of value in a
CalculateByteTensDigit: ; 1576b (5:576b)
	push bc
	ld c, 0
.loop
	sub 10
	jr c, .done
	inc c
	jr .loop
.done
	ld a, c
	pop bc
	ret

; returns in a the result of
; dividing b by a, rounded down
; input:
;	a = divisor
;	b = dividend
CalculateBDividedByA_Bank5: ; 15778 (5:5778)
	push bc
	ld c, a
	ld a, b
	ld b, c
	ld c, 0
.loop
	sub b
	jr c, .done
	inc c
	jr .loop
.done
	ld a, c
	pop bc
	ret

; returns in a the number of energy cards attached
; to Pokémon in location held by e
; this assumes that colorless are paired so
; that one colorless energy card provides 2 colorless energy
; input:
;	e = location to check, i.e. PLAY_AREA_*
; output:
;	a = number of energy cards attached
CountNumberOfEnergyCardsAttached: ; 15787 (5:5787)
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	or a
	ret z

	xor a
	push hl
	push bc
	ld b, NUM_COLORED_TYPES
	ld hl, wAttachedEnergies
; sum all the attached energies
.loop
	add [hl]
	inc hl
	dec b
	jr nz, .loop

	ld b, [hl]
	srl b
; counts colorless ad halves it
	add b
	pop bc
	pop hl
	ret

; returns carry if any card with ID in e is found
; in card location in a
; input:
;	a = card location to look in;
;	e = card ID to look for.
; output:
;	a = deck index of card found, if any
CheckIfAnyCardIDinLocation: ; 157a3 (5:57a3)
	ld b, a
	ld c, e
	lb de, 0, 0
.loop
	ld a, DUELVARS_CARD_LOCATIONS
	add e
	call GetTurnDuelistVariable
	cp b
	jr nz, .next
	ld a, e
	push de
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	cp c
	jr z, .set_carry
.next
	inc e
	ld a, DECK_SIZE
	cp e
	jr nz, .loop
	or a
	ret
.set_carry
	ld a, e
	scf
	ret

; counts total number of energy cards in opponent's hand
; plus all the cards attached in Turn Duelist's Play Area.
; output:
;	a and wTempAI = total number of energy cards.
CountOppEnergyCardsInHandAndAttached: ; 157c6 (5:57c6)
	xor a
	ld [wTempAI], a
	call CreateEnergyCardListFromHand
	jr c, .attached

; counts number of energy cards in hand
	ld b, -1
	ld hl, wDuelTempList
.loop_hand
	inc b
	ld a, [hli]
	cp $ff
	jr nz, .loop_hand
	ld a, b
	ld [wTempAI], a

; counts number of energy cards
; that are attached in Play Area
.attached
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA
.loop_play_area
	call CountNumberOfEnergyCardsAttached
	ld hl, wTempAI
	add [hl]
	ld [hl], a
	inc e
	dec d
	jr nz, .loop_play_area
	ret

; returns carry if any card with ID in e is found
; in the list that is pointed by hl.
; if one is found, it is removed from the list.
; input:
;   e  = card ID to look for.
;   hl = list to look in
RemoveCardIDInList: ; 157f3 (5:57f3)
	push hl
	push de
	push bc
	ld c, e

.loop_1
	ld a, [hli]
	cp $ff
	jr z, .no_carry

	ldh [hTempCardIndex_ff98], a
	call GetCardIDFromDeckIndex
	ld a, c
	cp e
	jr nz, .loop_1

; found
	ld d, h
	ld e, l
	dec hl

; remove this index from the list
; and reposition the rest of the list ahead.
.loop_2
	ld a, [de]
	inc de
	ld [hli], a
	cp $ff
	jr nz, .loop_2

	ldh a, [hTempCardIndex_ff98]
	pop bc
	pop de
	pop hl
	scf
	ret

.no_carry
	pop bc
	pop de
	pop hl
	or a
	ret

; play Pokemon cards from the hand to set the starting
; Play Area of Boss decks.
; each Boss deck has two ID lists in order of preference.
; one list is for the Arena card is the other is for the Bench cards.
; if Arena card could not be set (due to hand not having any card in its list)
; or if list is null, return carry and do not play any cards.
TrySetUpBossStartingPlayArea: ; 1581b (5:581b)
	ld de, wAICardListArenaPriority
	ld a, d
	or a
	jr z, .set_carry ; return if null

; pick Arena card
	call CreateHandCardList
	ld hl, wDuelTempList
	ld de, wAICardListArenaPriority
	call .PlayPokemonCardInOrder
	ret c

; play Pokemon cards to Bench until there are
; a maximum of 3 cards in Play Area.
.loop
	ld de, wAICardListBenchPriority
	call .PlayPokemonCardInOrder
	jr c, .done
	cp 3
	jr c, .loop

.done
	or a
	ret
.set_carry
	scf
	ret

; runs through input card ID list in de.
; plays to Play Area first card that is found in hand.
; returns carry if none of the cards in the list are found.
; returns number of Pokemon in Play Area in a.
.PlayPokemonCardInOrder ; 1583f (5:583f)
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld d, a
	ld e, c

; go in order of the list in de and
; add first card that matches ID.
; returns carry if hand doesn't have any card in list.
.loop_id_list
	ld a, [de]
	inc de
	or a
	jr z, .not_found
	push de
	ld e, a
	call RemoveCardIDInList
	pop de
	jr nc, .loop_id_list

	; play this card to Play Area and return
	push hl
	call PutHandPokemonCardInPlayArea
	pop hl
	or a
	ret

.not_found
	scf
	ret

Func_1585b: ; 1585b (5:585b)
	INCROM $1585b, $158b2

; determine AI score for retreating
; return carry if AI decides to retreat
AIDecideWhetherToRetreat: ; 158b2 (5:58b2)
	ld a, [wGotHeadsFromConfusionCheckDuringRetreat]
	or a
	jp nz, .no_carry
	xor a
	ld [wAIPlayEnergyCardForRetreat], a
	call LoadDefendingPokemonColorWRAndPrizeCards
	ld a, 128 ; initial retreat score
	ld [wAIScore], a
	ld a, [wcdb4]
	or a
	jr z, .check_status
	srl a
	srl a
	sla a
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
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .active_cant_ko_1
	call CheckIfSelectedMoveIsUnusable
	jp nc, .active_cant_use_move
	call LookForEnergyNeededForMoveInHand
	jr nc, .active_cant_ko_1

.active_cant_use_move
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
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .no_ko
	call CheckIfSelectedMoveIsUnusable
	jr nc, .success
	call LookForEnergyNeededForMoveInHand
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
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .active_cant_ko_2
	call CheckIfSelectedMoveIsUnusable
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
; are final evolutions and can use second move in the bench
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
	call CheckIfArenaCardIsAtHalfHPCanEvolveAndUseSecondMove
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

; if player's turn and loaded move is not a Pokémon Power OR
; if opponent's turn and wcddb == 0
; set wcdda's bit 7 flag
Func_15b54: ; 15b54 (5:5b54)
	xor a
	ld [wcdda], a
	ld a, [wWhoseTurn]
	cp OPPONENT_TURN
	jr z, .opponent

; player
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	ret z
	jr .set_flag

.opponent
	ld a, [wcddb]
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
AIDecideBenchPokemonToSwitchTo: ; 15b72 (5:5b72)
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
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .check_can_use_moves
	call CheckIfSelectedMoveIsUnusable
	jr c, .check_can_use_moves
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

; calculates damage of both moves
; to raise AI score accordingly
.check_can_use_moves
	xor a
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
	call nc, .HandleAttackDamageScore
	ld a, $01
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
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
;	- is a Mew1 and defending card is not basic stage
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	cp MR_MIME
	jr z, .raise_score
	cp MEW1
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
	ld [wcdb4], a
	jp FindHighestBenchScore

; handles AI action of retreating Arena Pokémon
; and chooses which energy cards to discard.
; if card can't discard, return carry.
; in case it's Clefairy Doll or Mysterious Fossil,
; handle its effect to discard itself instead of retreating.
; input:
;	- a = Play Area location (PLAY_AREA_*) of card to retreat to.
AITryToRetreat: ; 15d4f (5:5d4f)
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

; Copy cards from wDuelTempList in hl to wHandTempList in de
CopyHandCardList: ; 15ea6 (5:5ea6)
	ld a, [hli]
	ld [de], a
	cp $ff
	ret z
	inc de
	jr CopyHandCardList

; determine whether AI plays
; basic cards from hand
AIDecidePlayPokemonCard: ; 15eae (5:5eae)
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
	call Func_161d5

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
; for this card's moves, raise AI score
.check_energy_cards
	ld a, [wTempAIPokemonCard]
	call GetMovesEnergyCostBits
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
AIDecideEvolution: ; 15f4c (5:5f4c)
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
	ld a, 128
	ld [wAIScore], a
	call Func_16120

; check if the card can use any moves
; and if any of those moves can KO
	xor a
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
	jr nc, .can_attack
	ld a, $01
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
	jr c, .cant_attack_or_ko
.can_attack
	ld a, $01
	ld [wCurCardCanAttack], a
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .check_evolution_attacks
	call CheckIfSelectedMoveIsUnusable
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
	call CheckIfSelectedMoveIsUnusable
	jr nc, .evolution_can_attack
	ld a, $01
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
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
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .evolution_cant_ko
	call CheckIfSelectedMoveIsUnusable
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
	cp PIKACHU1
	jr z, .pikachu
	cp PIKACHU2
	jr z, .pikachu
	cp PIKACHU3
	jr z, .pikachu
	cp PIKACHU4
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
Func_16120: ; 16120 (5:6120)
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
Func_161d5: ; 161d5 (5:61d5)
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
	cp ARTICUNO2
	jr z, .articuno
	cp MOLTRES2
	jr z, .moltres
	cp ZAPDOS3
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
	call CheckIfActivePokemonCanUseAnyNonResidualMove
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
	call CopyMoveDataAndDamage_FromDeckIndex
	call SwapTurn
	ld a, [wLoadedMoveCategory]
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

; check if player's active Pokémon is Mr Mime
; if it isn't, set carry
; if it is, check if Pokémon at a
; can damage it, and if it can, set carry
; input:
;	a = location of Pokémon card
CheckDamageToMrMime: ; 16270 (5:6270)
	push af
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MR_MIME
	pop bc
	jr nz, .set_carry
	ld a, b
	call CheckIfCanDamageDefendingPokemon
	jr c, .set_carry
	or a
	ret
.set_carry
	scf
	ret

; returns carry if arena card
; can knock out defending Pokémon
CheckIfActiveCardCanKnockOut: ; 1628f (5:628f)
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .fail
	call CheckIfSelectedMoveIsUnusable
	jp c, .fail
	scf
	ret

.fail
	or a
	ret

; outputs carry if any of the active Pokémon attacks
; can be used and are not residual
CheckIfActivePokemonCanUseAnyNonResidualMove: ; 162a1 (5:62a1)
	xor a ; active card
	ldh [hTempPlayAreaLocation_ff9d], a
; first move
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
	jr c, .next_move
	ld a, [wLoadedMoveCategory]
	and RESIDUAL
	jr z, .ok

.next_move
; second move
	ld a, $01
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
	jr c, .fail
	ld a, [wLoadedMoveCategory]
	and RESIDUAL
	jr z, .ok
.fail
	or a
	ret

.ok
	scf
	ret

; looks for energy card(s) in hand depending on
; what is needed for selected card, for both moves
;	- if one basic energy is required, look for that energy;
;	- if one colorless is required, create a list at wDuelTempList
;	  of all energy cards;
;	- if two colorless are required, look for double colorless;
; return carry if successful in finding card
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
LookForEnergyNeededInHand: ; 162c8 (5:62c8)
	xor a ; first move
	ld [wSelectedAttack], a
	call CheckEnergyNeededForAttack
	ld a, b
	add c
	cp 1
	jr z, .one_energy
	cp 2
	jr nz, .second_attack
	ld a, c
	cp 2
	jr z, .two_colorless

.second_attack
	ld a, $01 ; second move
	ld [wSelectedAttack], a
	call CheckEnergyNeededForAttack
	ld a, b
	add c
	cp 1
	jr z, .one_energy
	cp 2
	jr nz, .no_carry
	ld a, c
	cp 2
	jr z, .two_colorless
.no_carry
	or a
	ret

.one_energy
	ld a, b
	or a
	jr z, .one_colorless
	ld a, e
	call LookForCardIDInHandList_Bank5
	ret c
	jr .no_carry

.one_colorless
	call CreateEnergyCardListFromHand
	jr c, .no_carry
	scf
	ret

.two_colorless
	ld a, DOUBLE_COLORLESS_ENERGY
	call LookForCardIDInHandList_Bank5
	ret c
	jr .no_carry

; looks for energy card(s) in hand depending on
; what is needed for selected card and move
;	- if one basic energy is required, look for that energy;
;	- if one colorless is required, create a list at wDuelTempList
;	  of all energy cards;
;	- if two colorless are required, look for double colorless;
; return carry if successful in finding card
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedAttack]         = selected move to examine
LookForEnergyNeededForMoveInHand: ; 16311 (5:6311)
	call CheckEnergyNeededForAttack
	ld a, b
	add c
	cp 1
	jr z, .one_energy
	cp 2
	jr nz, .done
	ld a, c
	cp 2
	jr z, .two_colorless
.done
	or a
	ret

.one_energy
	ld a, b
	or a
	jr z, .one_colorless
	ld a, e
	call LookForCardIDInHandList_Bank5
	ret c
	jr .done

.one_colorless
	call CreateEnergyCardListFromHand
	jr c, .done
	scf
	ret

.two_colorless
	ld a, DOUBLE_COLORLESS_ENERGY
	call LookForCardIDInHandList_Bank5
	ret c
	jr .done

; goes through $00 terminated list pointed
; by wAICardListPlayFromHandPriority and compares it to each card in hand.
; Sorts the hand in wDuelTempList so that the found card IDs
; are in the same order as the list pointed by de.
SortTempHandByIDList: ; 1633f (5:633f)
	ld a, [wAICardListPlayFromHandPriority+1]
	or a
	ret z ; return if list is empty

; start going down the ID list
	ld d, a
	ld a, [wAICardListPlayFromHandPriority]
	ld e, a
	ld c, 0
.loop_list_id
; get this item's ID
; if $00, list has ended
	ld a, [de]
	or a
	ret z ; return when list is over
	inc de
	ld hl, wDuelTempList
	ld b, 0
	add hl, bc
	ld b, a

; search in the hand card list
.next_hand_card
	ld a, [hl]
	ldh [hTempCardIndex_ff98], a
	cp -1
	jr z, .loop_list_id
	push bc
	push de
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	pop bc
	cp b
	jr nz, .not_same

; found
; swap this hand card with the spot
; in hand corresponding to c
	push bc
	push hl
	ld b, 0
	ld hl, wDuelTempList
	add hl, bc
	ld b, [hl]
	ldh a, [hTempCardIndex_ff98]
	ld [hl], a
	pop hl
	ld [hl], b
	pop bc
	inc c
.not_same
	inc hl
	jr .next_hand_card

; looks for energy card(s) in list at wDuelTempList
; depending on energy flags set in a
; return carry if successful in finding card
; input:
;	a = energy flags needed
CheckEnergyFlagsNeededInList: ; 1637b (5:637b)
	ld e, a
	ld hl, wDuelTempList
.next_card
	ld a, [hli]
	cp $ff
	jr z, .no_carry
	push de
	call GetCardIDFromDeckIndex
	ld a, e
	pop de

; fire
	cp FIRE_ENERGY
	jr nz, .grass
	ld a, FIRE_F
	jr .check_energy
.grass
	cp GRASS_ENERGY
	jr nz, .lightning
	ld a, GRASS_F
	jr .check_energy
.lightning
	cp LIGHTNING_ENERGY
	jr nz, .water
	ld a, LIGHTNING_F
	jr .check_energy
.water
	cp WATER_ENERGY
	jr nz, .fighting
	ld a, WATER_F
	jr .check_energy
.fighting
	cp FIGHTING_ENERGY
	jr nz, .psychic
	ld a, FIGHTING_F
	jr .check_energy
.psychic
	cp PSYCHIC_ENERGY
	jr nz, .colorless
	ld a, PSYCHIC_F
	jr .check_energy
.colorless
	cp DOUBLE_COLORLESS_ENERGY
	jr nz, .next_card
	ld a, COLORLESS_F

; if energy card matches required energy, return carry
.check_energy
	ld d, e
	and e
	ld e, d
	jr z, .next_card
	scf
	ret
.no_carry
	or a
	ret

; returns in a the energy cost of both moves from card index in a
; represented by energy flags
; i.e. each bit represents a different energy type cost
; if any colorless energy is required, all bits are set
; input:
;	a = card index
; output:
;	a = bits of each energy requirement
GetMovesEnergyCostBits: ; 163c9 (5:63c9)
	call LoadCardDataToBuffer2_FromDeckIndex
	ld hl, wLoadedCard2Move1EnergyCost
	call GetEnergyCostBits
	ld b, a

	push bc
	ld hl, wLoadedCard2Move2EnergyCost
	call GetEnergyCostBits
	pop bc
	or b
	ret

; returns in a the energy cost of a move in [hl]
; represented by energy flags
; i.e. each bit represents a different energy type cost
; if any colorless energy is required, all bits are set
; input:
;	[hl] = Loaded card move energy cost
; output:
;	a = bits of each energy requirement
GetEnergyCostBits: ; 163dd (5:63dd)
	ld c, $00
	ld a, [hli]
	ld b, a

; fire
	and $f0
	jr z, .grass
	ld c, FIRE_F
.grass
	ld a, b
	and $0f
	jr z, .lightning
	ld a, GRASS_F
	or c
	ld c, a
.lightning
	ld a, [hli]
	ld b, a
	and $f0
	jr z, .water
	ld a, LIGHTNING_F
	or c
	ld c, a
.water
	ld a, b
	and $0f
	jr z, .fighting
	ld a, WATER_F
	or c
	ld c, a
.fighting
	ld a, [hli]
	ld b, a
	and $f0
	jr z, .psychic
	ld a, FIGHTING_F
	or c
	ld c, a
.psychic
	ld a, b
	and $0f
	jr z, .colorless
	ld a, PSYCHIC_F
	or c
	ld c, a
.colorless
	ld a, [hli]
	ld b, a
	and $f0
	jr z, .done
	ld a, %11111111
	or c ; unnecessary
	ld c, a
.done
	ld a, c
	ret

; set carry flag if any card in
; wDuelTempList evolves card index in a
; if found, the evolution card index is returned in a
; input:
;	a = card index to check evolution
; output:
;	a = card index of evolution found
CheckForEvolutionInList: ; 16422 (5:6422)
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable

	push af
	ld [hl], b
	ld hl, wDuelTempList
.loop
	ld a, [hli]
	cp $ff
	jr z, .no_carry
	ld d, a
	ld e, PLAY_AREA_ARENA
	push de
	push hl
	call CheckIfCanEvolveInto
	pop hl
	pop de
	jr c, .loop

	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	ld a, d
	scf
	ret

.no_carry
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	or a
	ret

; set carry if it finds an evolution for
; the card index in a in the deck
; if found, return that evolution card index in a
; input:
;	a = card index to check evolution
; output:
;	a = card index of evolution found
CheckForEvolutionInDeck: ; 16451 (5:6451)
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable

	push af
	ld [hl], b
	ld e, 0
.loop
	ld a, DUELVARS_CARD_LOCATIONS
	add e
	call GetTurnDuelistVariable
	cp CARD_LOCATION_DECK
	jr nz, .not_in_deck
	push de
	ld d, e
	ld e, PLAY_AREA_ARENA
	call CheckIfCanEvolveInto
	pop de
	jr nc, .set_carry

; exit when it gets to the prize cards
.not_in_deck
	inc e
	ld a, DUELVARS_PRIZE_CARDS
	cp e
	jr nz, .loop

	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	or a
	ret

.set_carry
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	ld a, e
	scf
	ret

Func_16488: ; 16488 (5:6488)
	INCROM $16488, $164a1

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
	call GetMovesEnergyCostBits
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
; and there's Venusaur2 in own Play Area,
; add to AI score
.check_venusaur
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .check_if_active
	ld a, VENUSAUR2
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
; if Player is running Mewtwo1 mill deck.
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

; add AI score for both moves,
; according to their energy requirements.
	xor a ; first move
	call DetermineAIScoreOfMoveEnergyRequirement
	ld a, $01 ; second move
	call DetermineAIScoreOfMoveEnergyRequirement

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

; checks score related to selected move,
; in order to determine whether to play energy card.
; the AI score is increased/decreased accordingly.
; input:
;	[wSelectedAttack] = move to check.
DetermineAIScoreOfMoveEnergyRequirement: ; 16695 (5:6695)
	ld [wSelectedAttack], a
	call CheckEnergyNeededForAttack
	jp c, .not_enough_energy
	ld a, MOVE_FLAG2_ADDRESS | ATTACHED_ENERGY_BOOST_F
	call CheckLoadedMoveFlag
	jr c, .attached_energy_boost
	ld a, MOVE_FLAG2_ADDRESS | DISCARD_ENERGY_F
	call CheckLoadedMoveFlag
	jr c, .discard_energy
	jp .check_evolution

.attached_energy_boost
	ld a, [wLoadedMoveEffectParam]
	cp MAX_ENERGY_BOOST_IS_LIMITED
	jr z, .check_surplus_energy

	; is MAX_ENERGY_BOOST_IS_NOT_LIMITED,
	; which is equal to 3, add to score.
	call AddToAIScore
	jp .check_evolution

.check_surplus_energy
	call CheckIfNoSurplusEnergyForMove
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

; check whether move has ATTACHED_ENERGY_BOOST flag
; and add to AI score if attaching another energy
; will KO defending Pokémon.
; add more to score if this is currently active Pokémon.
	ld a, MOVE_FLAG2_ADDRESS | ATTACHED_ENERGY_BOOST_F
	call CheckLoadedMoveFlag
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

; checks if there is surplus energy for move
; that discards attached energy card.
; if current card is Zapdos2, don't add to score.
; if there is no surplus energy, encourage playing energy.
.discard_energy
	ld a, [wLoadedCard1ID]
	cp ZAPDOS2
	jr z, .check_evolution
	call CheckIfNoSurplusEnergyForMove
	jr c, .asm_166cd
	jr .asm_166c5

.not_enough_energy
	ld a, MOVE_FLAG2_ADDRESS | FLAG_2_BIT_5_F
	call CheckLoadedMoveFlag
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

; if only one energy card is needed for move,
; encourage playing energy card.
.check_total_needed
	ld a, b
	add c
	dec a
	jr nz, .check_evolution
	ld a, 3
	call AddToAIScore

; if the move KOs player and this is the active card, add to AI score.
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .check_evolution
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr z, .move_kos_defending
	jr nc, .check_evolution
.move_kos_defending
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
	ld a, MOVE_FLAG2_ADDRESS | FLAG_2_BIT_5_F
	call CheckLoadedMoveFlag
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
; and that card needs energy to use wSelectedMove.
CheckIfEvolutionNeedsEnergyForMove: ; 16805 (5:6805)
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
; if it's Zapdos2's Thunderbolt attack, return no carry.
; if it's Charizard's Fire Spin or Exeggutor's Big Eggsplosion
; attack, don't return energy card ID, but set carry.
; output:
;	b = 1 if needs color energy, 0 otherwise;
;	c = 1 if only needs colorless energy, 0 otherwise;
;	carry set if not Zapdos2's Thunderbolt attack.
GetEnergyCardForDiscardOrEnergyBoostAttack: ; 1683b (5:683b)
; load card ID and check selected move index.
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld b, a
	ld a, [wSelectedAttack]
	or a
	jr z, .first_attack

; check if second attack is Zapdos2's Thunderbolt,
; Charizard's Fire Spin or Exeggutor's Big Eggsplosion,
; for these to be treated differently.
; for both attacks, load its energy cost.
	ld a, b
	cp ZAPDOS2
	jr z, .zapdos2
	cp CHARIZARD
	jr z, .charizard_or_exeggutor
	cp EXEGGUTOR
	jr z, .charizard_or_exeggutor
	ld hl, wLoadedCard2Move2EnergyCost
	jr .fire
.first_attack
	ld hl, wLoadedCard2Move1EnergyCost

; check which energy color the move requires,
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

; for Zapdos2's Thunderbolt attack, return with no carry.
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
	ld a, MOVE_FLAG2_ADDRESS | ATTACHED_ENERGY_BOOST_F
	call CheckLoadedMoveFlag
	jr c, .energy_boost_or_discard_energy
	ld a, MOVE_FLAG2_ADDRESS | DISCARD_ENERGY_F
	call CheckLoadedMoveFlag
	jr c, .energy_boost_or_discard_energy

	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	call CheckEnergyNeededForAttack
	ld a, MOVE_FLAG2_ADDRESS | ATTACHED_ENERGY_BOOST_F
	call CheckLoadedMoveFlag
	jr c, .energy_boost_or_discard_energy
	ld a, MOVE_FLAG2_ADDRESS | DISCARD_ENERGY_F
	call CheckLoadedMoveFlag
	jr c, .energy_boost_or_discard_energy

; if none of the attacks have those flags, do an additional
; check to ascertain whether evolution card needs energy
; to use second attack. Return if all these checks fail.
	call CheckIfEvolutionNeedsEnergyForMove
	ret nc
	call CreateEnergyCardListFromHand
	jr .check_deck

; for attacks that discard energy or get boost for
; additional energy cards, get the energy card ID required by move.
; if it's Zapdos2's Thunderbolt move, return.
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
; these are cards that do not need double colorless to any of their moves
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

; have AI choose an attack to use, but do not execute it.
; return carry if an attack is chosen.
AIProcessButDontUseAttack: ; 169ca (5:69ca)
	ld a, $01
	ld [wAIExecuteProcessedAttack], a

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

; copies wAIScore to wTempAIScore
	ld a, [wAIScore]
	ld [de], a
	jr AIProcessAttacks

; copies wTempPlayAreaAIScore to wPlayAreaAIScore
; and loads wAIScore with value in wTempAIScore.
; identical to RetrievePlayAreaAIScoreFromBackup1.
RetrievePlayAreaAIScoreFromBackup2: ; 169e3 (5:69e3)
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

; have AI choose and execute an attack.
; return carry if an attack was chosen and attempted.
AIProcessAndTryToUseAttack: ; 169f8 (5:69f8)
	xor a
	ld [wAIExecuteProcessedAttack], a
	; fallthrough

; checks which of the Active card's attacks for AI to use.
; If any of the attacks has enough AI score to be used,
; AI will use it if wAIExecuteProcessedAttack is 0.
; in either case, return carry if an attack is chosen to be used.
AIProcessAttacks: ; 169fc (5:69fc)
; if AI used Pluspower, load its attack index
	ld a, [wPreviousAIFlags]
	and AI_FLAG_USED_PLUSPOWER
	jr z, .no_pluspower
	ld a, [wAIPluspowerAttack]
	ld [wSelectedAttack], a
	jr .attack_chosen

.no_pluspower
; if Player is running Mewtwo1 mill deck,
; skip attack if Barrier counter is 0.
	ld a, [wAIBarrierFlagCounter]
	cp AI_MEWTWO_MILL + 0
	jp z, .dont_attack

; determine AI score of both attacks.
	xor a ; FIRST_ATTACK_OR_PKMN_POWER
	call GetAIScoreOfAttack
	ld a, [wAIScore]
	ld [wFirstAttackAIScore], a
	ld a, SECOND_ATTACK
	call GetAIScoreOfAttack

; compare both attack scores
	ld c, SECOND_ATTACK
	ld a, [wFirstAttackAIScore]
	ld b, a
	ld a, [wAIScore]
	cp b
	jr nc, .check_score
	; first attack has higher score
	dec c
	ld a, b

; c holds the attack index chosen by AI,
; and a holds its AI score.
; first check if chosen attack has at least minimum score.
; then check if first attack is better than second attack
; in case the second one was chosen.
.check_score
	cp $50 ; minimum score to use attack
	jr c, .dont_attack
	; enough score, proceed

	ld a, c
	ld [wSelectedAttack], a
	or a
	jr z, .attack_chosen
	call CheckWhetherToSwitchToFirstAttack

.attack_chosen
; check whether to execute the attack chosen
	ld a, [wAIExecuteProcessedAttack]
	or a
	jr z, .execute

; set carry and reset Play Area AI score
; to the previous values.
	scf
	jp RetrievePlayAreaAIScoreFromBackup2

.execute
	ld a, AI_TRAINER_CARD_PHASE_14
	call AIProcessHandTrainerCards

; load this attack's damage output against
; the current Defending Pokemon.
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]

	or a
	jr z, .check_damage_bench
	; if damage is not 0, fallthrough

.can_damage
	xor a
	ld [wcdb4], a
	jr .use_attack

.check_damage_bench
; check if it can otherwise damage player's bench
	ld a, MOVE_FLAG1_ADDRESS | DAMAGE_TO_OPPONENT_BENCH_F
	call CheckLoadedMoveFlag
	jr c, .can_damage

; cannot damage either Defending Pokemon or Bench
	ld hl, wcdb4
	inc [hl]

; return carry if attack is chosen
; and AI tries to use it.
.use_attack
	ld a, $01
	ld [wcddb], a
	call AITryUseAttack
	scf
	ret

.dont_attack
	ld a, [wAIExecuteProcessedAttack]
	or a
	jr z, .failed_to_use

; reset Play Area AI score
; to the previous values.
	jp RetrievePlayAreaAIScoreFromBackup2

; return no carry if no viable attack.
.failed_to_use
	ld hl, wcdb4
	inc [hl]
	or a
	ret

; determines the AI score of attack index in a
; of card in Play Area location hTempPlayAreaLocation_ff9d.
GetAIScoreOfAttack: ; 16a86 (5:6a86)
; initialize AI score.
	ld [wSelectedAttack], a
	ld a, $50
	ld [wAIScore], a

	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfSelectedMoveIsUnusable
	jr nc, .usable

; return zero AI score.
.unusable
	xor a
	ld [wAIScore], a
	jp .done

; load arena card IDs
.usable
	xor a
	ld [wAICannotDamage], a
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

; handle the case where the player has No Damage substatus.
; in the case the player does, check if this move
; has a residual effect, or if it can damage the opposing bench.
; If none of those are true, render the move unusable.
; also if it's a PKMN power, consider it unusable as well.
	bank1call HandleNoDamageOrEffectSubstatus
	call SwapTurn
	jr nc, .check_if_can_ko

	; player is under No Damage substatus
	ld a, $01
	ld [wAICannotDamage], a
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr z, .unusable
	and RESIDUAL
	jr nz, .check_if_can_ko
	ld a, MOVE_FLAG1_ADDRESS | DAMAGE_TO_OPPONENT_BENCH_F
	call CheckLoadedMoveFlag
	jr nc, .unusable

; calculate damage to player to check if move can KO.
; encourage move if it's able to KO.
.check_if_can_ko
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr c, .can_ko
	jr z, .can_ko
	jr .check_damage
.can_ko
	ld a, 20
	call AddToAIScore

; raise AI score by the number of damage counters that this move deals.
; if no damage is dealt, subtract AI score. in case wDamage is zero
; but wMaxDamage is not, then encourage move afterwards.
; otherwise, if wMaxDamage is also zero, check for damage against
; player's bench, and encourage move in case there is.
.check_damage
	xor a
	ld [wAIMoveIsNonDamaging], a
	ld a, [wDamage]
	ld [wTempAI], a
	or a
	jr z, .no_damage
	call CalculateByteTensDigit
	call AddToAIScore
	jr .check_recoil
.no_damage
	ld a, $01
	ld [wAIMoveIsNonDamaging], a
	call SubFromAIScore
	ld a, [wAIMaxDamage]
	or a
	jr z, .no_max_damage
	ld a, 2
	call AddToAIScore
	xor a
	ld [wAIMoveIsNonDamaging], a
.no_max_damage
	ld a, MOVE_FLAG1_ADDRESS | DAMAGE_TO_OPPONENT_BENCH_F
	call CheckLoadedMoveFlag
	jr nc, .check_recoil
	ld a, 2
	call AddToAIScore

; handle recoil moves (low and high recoil).
.check_recoil
	ld a, MOVE_FLAG1_ADDRESS | LOW_RECOIL_F
	call CheckLoadedMoveFlag
	jr c, .is_recoil
	ld a, MOVE_FLAG1_ADDRESS | HIGH_RECOIL_F
	call CheckLoadedMoveFlag
	jp nc, .check_defending_can_ko
.is_recoil
	; sub from AI score number of damage counters
	; that move deals to itself.
	ld a, [wLoadedMoveEffectParam]
	or a
	jp z, .check_defending_can_ko
	ld [wDamage], a
	call ApplyDamageModifiers_DamageToSelf
	ld a, e
	call CalculateByteTensDigit
	call SubFromAIScore

	push de
	ld a, MOVE_FLAG1_ADDRESS | HIGH_RECOIL_F
	call CheckLoadedMoveFlag
	pop de
	jr c, .high_recoil

	; if LOW_RECOIL KOs self, decrease AI score
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	cp e
	jr c, .kos_self
	jp nz, .check_defending_can_ko
.kos_self
	ld a, 10
	call SubFromAIScore

.high_recoil
	; dismiss this move if no benched Pokémon
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 2
	jr c, .dismiss_high_recoil_move
	; has benched Pokémon

; here the AI handles high recoil moves differently
; depending on what deck it's playing.
	ld a, [wOpponentDeckID]
	cp ROCK_CRUSHER_DECK_ID
	jr z, .rock_crusher_deck
	cp ZAPPING_SELFDESTRUCT_DECK_ID
	jr z, .zapping_selfdestruct_deck
	cp BOOM_BOOM_SELFDESTRUCT_DECK_ID
	jr z, .encourage_high_recoil_move
	; Boom Boom Selfdestruct deck always encourages
	cp POWER_GENERATOR_DECK_ID
	jr nz, .high_recoil_generic_checks
	; Power Generator deck always dismisses

.dismiss_high_recoil_move
	xor a
	ld [wAIScore], a
	jp .done

.encourage_high_recoil_move
	ld a, 20
	call AddToAIScore
	jp .done

; Zapping Selfdestruct deck only uses this move
; if number of cards in deck >= 30 and
; HP of active card is < half max HP.
.zapping_selfdestruct_deck
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp 31
	jr nc, .high_recoil_generic_checks
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	sla a
	cp c
	jr c, .high_recoil_generic_checks
	ld b, 0
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp MAGNEMITE1
	jr z, .magnemite1
	ld b, 10 ; bench damage
.magnemite1
	ld a, 10
	add b
	ld b, a ; 20 bench damage if not Magnemite1

; if this move causes player to win the duel by
; knocking out own Pokémon, dismiss move.
	ld a, 1 ; count active Pokémon as KO'd
	call .check_if_kos_bench
	jr c, .dismiss_high_recoil_move
	jr .encourage_high_recoil_move

; Rock Crusher Deck only uses this move if
; prize count is below 4 and move wins (or potentially draws) the duel,
; (i.e. at least gets KOs equal to prize cards left).
.rock_crusher_deck
	call CountPrizes
	cp 4
	jr nc, .dismiss_high_recoil_move
	; prize count < 4
	ld b, 20 ; damage dealt to bench
	call SwapTurn
	xor a
	call .check_if_kos_bench
	call SwapTurn
	jr c, .encourage_high_recoil_move

; generic checks for all other deck IDs.
; encourage move if it wins (or potentially draws) the duel,
; (i.e. at least gets KOs equal to prize cards left).
; dismiss it if it causes the player to win.
.high_recoil_generic_checks
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp CHANSEY
	jr z, .chansey
	cp MAGNEMITE1
	jr z, .magnemite1_or_weezing
	cp WEEZING
	jr z, .magnemite1_or_weezing
	ld b, 20 ; bench damage
	jr .check_bench_kos
.magnemite1_or_weezing
	ld b, 10 ; bench damage
	jr .check_bench_kos
.chansey
	ld b, 0 ; no bench damage

.check_bench_kos
	push bc
	call SwapTurn
	xor a
	call .check_if_kos_bench
	call SwapTurn
	pop bc
	jr c, .wins_the_duel
	push de
	ld a, 1
	call .check_if_kos_bench
	pop bc
	jr nc, .count_own_ko_bench

; move causes player to draw all prize cards
	xor a
	ld [wAIScore], a
	jp .done

; move causes CPU to draw all prize cards
.wins_the_duel
	ld a, 20
	call AddToAIScore
	jp .done

; subtract from AI score number of own benched Pokémon KO'd
.count_own_ko_bench
	push bc
	ld a, d
	or a
	jr z, .count_player_ko_bench
	dec a
	call SubFromAIScore

; add to AI score number of player benched Pokémon KO'd
.count_player_ko_bench
	pop bc
	ld a, b
	call AddToAIScore
	jr .check_defending_can_ko

; local function that gets called to determine damage to
; benched Pokémon caused by a HIGH_RECOIL move.
; return carry if using move causes number of benched Pokémon KOs
; equal to or larger than remaining prize cards.
; this function is independent on duelist turn, so whatever
; turn it is when this is called, it's that duelist's
; bench/prize cards that get checked.
; input:
;	a = initial number of KO's beside benched Pokémon,
;		so that if the active Pokémon is KO'd by the move,
;		this counts towards the prize cards collected
;	b = damage dealt to bench Pokémon
.check_if_kos_bench
	ld d, a
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	ld e, PLAY_AREA_ARENA
.loop
	inc e
	ld a, [hli]
	cp $ff
	jr z, .exit_loop
	ld a, e
	add DUELVARS_ARENA_CARD_HP
	push hl
	call GetTurnDuelistVariable
	pop hl
	cp b
	jr z, .increase_count
	jr nc, .loop
.increase_count
	; increase d if damage dealt KOs
	inc d
	jr .loop
.exit_loop
	push de
	call SwapTurn
	call CountPrizes
	call SwapTurn
	pop de
	cp d
	jp c, .set_carry
	jp z, .set_carry
	or a
	ret
.set_carry
	scf
	ret

; if defending card can KO, encourage move
; unless move is non-damaging.
.check_defending_can_ko
	ld a, [wSelectedAttack]
	push af
	call CheckIfDefendingPokemonCanKnockOut
	pop bc
	ld a, b
	ld [wSelectedAttack], a
	jr nc, .check_discard
	ld a, 5
	call AddToAIScore
	ld a, [wAIMoveIsNonDamaging]
	or a
	jr z, .check_discard
	ld a, 5
	call SubFromAIScore

; subtract from AI score if this move requires
; discarding any energy cards.
.check_discard
	ld a, [wSelectedAttack]
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld a, MOVE_FLAG2_ADDRESS | DISCARD_ENERGY_F
	call CheckLoadedMoveFlag
	jr nc, .asm_16ca6
	ld a, 1
	call SubFromAIScore
	ld a, [wLoadedMoveEffectParam]
	call SubFromAIScore

.asm_16ca6
	ld a, MOVE_FLAG2_ADDRESS | FLAG_2_BIT_6_F
	call CheckLoadedMoveFlag
	jr nc, .check_nullify_flag
	ld a, [wLoadedMoveEffectParam]
	call AddToAIScore

; encourage move if it has a nullify or weaken attack effect.
.check_nullify_flag
	ld a, MOVE_FLAG2_ADDRESS | NULLIFY_OR_WEAKEN_ATTACK_F
	call CheckLoadedMoveFlag
	jr nc, .check_draw_flag
	ld a, 1
	call AddToAIScore

; encourage move if it has an effect to draw a card.
.check_draw_flag
	ld a, MOVE_FLAG1_ADDRESS | DRAW_CARD_F
	call CheckLoadedMoveFlag
	jr nc, .check_heal_flag
	ld a, 1
	call AddToAIScore

.check_heal_flag
	ld a, MOVE_FLAG2_ADDRESS | HEAL_USER_F
	call CheckLoadedMoveFlag
	jr nc, .check_status_effect
	ld a, [wLoadedMoveEffectParam]
	cp 1
	jr z, .tally_heal_score
	ld a, [wTempAI]
	call CalculateByteTensDigit
	ld b, a
	ld a, [wLoadedMoveEffectParam]
	cp 3
	jr z, .asm_16cec
	srl b
	jr nc, .asm_16cec
	inc b
.asm_16cec
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	call CalculateByteTensDigit
	cp b
	jr c, .tally_heal_score
	ld a, b
.tally_heal_score
	push af
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	call CalculateByteTensDigit
	pop bc
	cp b ; wLoadedMoveEffectParam
	jr c, .add_heal_score
	ld a, b
.add_heal_score
	call AddToAIScore

.check_status_effect
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	; skip if player has Snorlax
	cp SNORLAX
	jp z, .handle_flag3_bit1

	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	ld [wTempAI], a

; encourage a poison inflicting move if opposing Pokémon
; isn't (doubly) poisoned already.
; if opposing Pokémon is only poisoned and not double poisoned,
; and this move has FLAG_2_BIT_6 set, discourage it
; (possibly to make Nidoking's Toxic attack less likely to be chosen
; if the other Pokémon is poisoned.)
	ld a, MOVE_FLAG1_ADDRESS | INFLICT_POISON_F
	call CheckLoadedMoveFlag
	jr nc, .check_sleep
	ld a, [wTempAI]
	and DOUBLE_POISONED
	jr z, .add_poison_score
	and $40 ; only double poisoned?
	jr z, .check_sleep
	ld a, MOVE_FLAG2_ADDRESS | FLAG_2_BIT_6_F
	call CheckLoadedMoveFlag
	jr nc, .check_sleep
	ld a, 2
	call SubFromAIScore
	jr .check_sleep
.add_poison_score
	ld a, 2
	call AddToAIScore

; encourage sleep-inducing move if other Pokémon isn't asleep.
.check_sleep
	ld a, MOVE_FLAG1_ADDRESS | INFLICT_SLEEP_F
	call CheckLoadedMoveFlag
	jr nc, .check_paralysis
	ld a, [wTempAI]
	and CNF_SLP_PRZ
	cp ASLEEP
	jr z, .check_paralysis
	ld a, 1
	call AddToAIScore

; encourage paralysis-inducing move if other Pokémon isn't asleep.
; otherwise, if other Pokémon is asleep, discourage move.
.check_paralysis
	ld a, MOVE_FLAG1_ADDRESS | INFLICT_PARALYSIS_F
	call CheckLoadedMoveFlag
	jr nc, .check_confusion
	ld a, [wTempAI]
	and CNF_SLP_PRZ
	cp ASLEEP
	jr z, .sub_prz_score
	ld a, 1
	call AddToAIScore
	jr .check_confusion
.sub_prz_score
	ld a, 1
	call SubFromAIScore

; encourage confuse-inducing move if other Pokémon isn't asleep
; or confused already.
; otherwise, if other Pokémon is asleep or confused,
; discourage move instead.
.check_confusion
	ld a, MOVE_FLAG1_ADDRESS | INFLICT_CONFUSION_F
	call CheckLoadedMoveFlag
	jr nc, .check_if_confused
	ld a, [wTempAI]
	and CNF_SLP_PRZ
	cp ASLEEP
	jr z, .sub_cnf_score
	ld a, [wTempAI]
	and CNF_SLP_PRZ
	cp CONFUSED
	jr z, .check_if_confused
	ld a, 1
	call AddToAIScore
	jr .check_if_confused
.sub_cnf_score
	ld a, 1
	call SubFromAIScore

; if this Pokémon is confused, subtract from score.
.check_if_confused
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	cp CONFUSED
	jr nz, .handle_flag3_bit1
	ld a, 1
	call SubFromAIScore

; flag3_bit1 marks moves that the AI handles individually.
; each move has its own checks and modifies AI score accordingly.
.handle_flag3_bit1
	ld a, MOVE_FLAG3_ADDRESS | FLAG_3_BIT_1_F
	call CheckLoadedMoveFlag
	jr nc, .done
	call HandleSpecialAIMoves
	cp $80
	jr c, .negative_score
	sub $80
	call AddToAIScore
	jr .done
.negative_score
	ld b, a
	ld a, $80
	sub b
	call SubFromAIScore

.done
	ret

; this function handles moves with the FLAG_3_BIT_1 set,
; and makes specific checks in each of these moves
; to either return a positive score (value above $80)
; or a negative score (value below $80).
; input:
;	hTempPlayAreaLocation_ff9d = location of card with move.
HandleSpecialAIMoves: ; 16dcd (5:6dcd)
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e

	cp NIDORANF
	jr z, HandleNidoranFCallForFamily
	cp ODDISH
	jr z, HandleCallForFamily
	cp BELLSPROUT
	jr z, HandleCallForFamily
	cp EXEGGUTOR
	jp z, HandleExeggutorTeleport
	cp SCYTHER
	jp z, HandleSwordsDanceAndFocusEnergy
	cp KRABBY
	jr z, HandleCallForFamily
	cp VAPOREON1
	jp z, HandleSwordsDanceAndFocusEnergy
	cp ELECTRODE2
	jp z, HandleElectrode2ChainLightning
	cp MAROWAK1
	jr z, HandleMarowak1CallForFriend
	cp MEW3
	jp z, HandleMew3DevolutionBeam
	cp JIGGLYPUFF2
	jp z, HandleJigglypuff2FriendshipSong
	cp PORYGON
	jp z, HandlePorygonConversion
	cp MEWTWO3
	jp z, HandleEnergyAbsorption
	cp MEWTWO2
	jp z, HandleEnergyAbsorption
	cp NINETAILS2
	jp z, HandleNinetalesMixUp
	cp ZAPDOS3
	jp z, HandleZapdos3BigThunder
	cp KANGASKHAN
	jp z, HandleKangaskhanFetch
	cp DUGTRIO
	jp z, HandleDugtrioEarthquake
	cp ELECTRODE1
	jp z, HandleElectrode1EnergySpike
	cp GOLDUCK
	jp z, HandleHyperBeam
	cp DRAGONAIR
	jp z, HandleHyperBeam

; return zero score.
.zero
	xor a
	ret

; if any of card ID in a is found in deck,
; return a score of $80 + slots available in bench.
HandleCallForFamily: ; 16e3e (5:6e3e)
	ld a, CARD_LOCATION_DECK
	call CheckIfAnyCardIDinLocation
	jr nc, HandleSpecialAIMoves.zero
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_BENCH_POKEMON
	jr nc, HandleSpecialAIMoves.zero
	ld b, a
	ld a, MAX_BENCH_POKEMON
	sub b
	add $80
	ret

; if any of NidoranM or NidoranF is found in deck,
; return a score of $80 + slots available in bench.
HandleNidoranFCallForFamily: ; 16e55 (5:6e55)
	ld e, NIDORANM
	ld a, CARD_LOCATION_DECK
	call CheckIfAnyCardIDinLocation
	jr c, .found
	ld e, NIDORANF
	ld a, CARD_LOCATION_DECK
	call CheckIfAnyCardIDinLocation
	jr nc, HandleSpecialAIMoves.zero
.found
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, HandleSpecialAIMoves.zero
	ld b, a
	ld a, MAX_PLAY_AREA_POKEMON
	sub b
	add $80
	ret

; checks for certain card IDs of Fighting color in deck.
; if any of them are found, return a score of
; $80 + slots available in bench.
HandleMarowak1CallForFriend: ; 16e77 (5:6e77)
	ld e, GEODUDE
	ld a, CARD_LOCATION_DECK
	call CheckIfAnyCardIDinLocation
	jr c, .found
	ld e, ONIX
	ld a, CARD_LOCATION_DECK
	call CheckIfAnyCardIDinLocation
	jr c, .found
	ld e, CUBONE
	ld a, CARD_LOCATION_DECK
	call CheckIfAnyCardIDinLocation
	jr c, .found
	ld e, RHYHORN
	ld a, CARD_LOCATION_DECK
	call CheckIfAnyCardIDinLocation
	jr c, .found
	jr HandleSpecialAIMoves.zero
.found
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_BENCH_POKEMON
	jr nc, HandleSpecialAIMoves.zero
	ld b, a
	ld a, MAX_BENCH_POKEMON
	sub b
	add $80
	ret

; if any basic cards are found in deck,
; return a score of $80 + slots available in bench.
HandleJigglypuff2FriendshipSong: ; 16ead (5:6ead)
	call CheckIfAnyBasicPokemonInDeck
	jr nc, HandleSpecialAIMoves.zero
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, HandleSpecialAIMoves.zero
	ld b, a
	ld a, MAX_PLAY_AREA_POKEMON
	sub b
	add $80
	ret

; if AI decides to retreat, return a score of $80 + 10.
HandleExeggutorTeleport: ; 16ec2 (5:6ec2)
	call AIDecideWhetherToRetreat
	jp nc, HandleSpecialAIMoves.zero
	ld a, $8a
	ret

; tests for the following conditions:
; - player is under No Damage substatus;
; - second move is unusable;
; - second move deals no damage;
; if any are true, returns score of $80 + 5.
HandleSwordsDanceAndFocusEnergy: ; 16ecb (5:6ecb)
	ld a, [wAICannotDamage]
	or a
	jr nz, .success
	ld a, $01 ; second move
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
	jr c, .success
	ld a, $01 ; second move
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jp nz, HandleSpecialAIMoves.zero
.success
	ld a, $85
	ret

; checks player's active card color, then
; loops through bench looking for a Pokémon
; with that same color.
; if none are found, returns score of $80 + 2.
HandleElectrode2ChainLightning: ; 16eea (5:6eea)
	call SwapTurn
	call GetArenaCardColor
	call SwapTurn
	ld b, a
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.loop
	ld a, [hli]
	cp $ff
	jr z, .success
	push bc
	call GetCardIDFromDeckIndex
	call GetCardType
	pop bc
	cp b
	jr nz, .loop
	jp HandleSpecialAIMoves.zero
.success
	ld a, $82
	ret

HandleMew3DevolutionBeam: ; 16f0f (5:6f0f)
	call LookForCardThatIsKnockedOutOnDevolution
	jp nc, HandleSpecialAIMoves.zero
	ld a, $85
	ret

; first checks if card is confused, and if so return 0.
; then checks number of Pokémon in bench that are viable to use:
; - if that number is < 2  and this move is Conversion 1 OR
; - if that number is >= 2 and this move is Conversion 2
; then return score of $80 + 2.
; otherwise return score of $80 + 1.
HandlePorygonConversion: ; 16f18 (5:6f18)
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	cp CONFUSED
	jp z, HandleSpecialAIMoves.zero

	ld a, [wSelectedAttack]
	or a
	jr nz, .conversion_2

; conversion 1
	call CountNumberOfSetUpBenchPokemon
	cp 2
	jr c, .low_score
	ld a, $82
	ret

.conversion_2
	call CountNumberOfSetUpBenchPokemon
	cp 2
	jr nc, .low_score
	ld a, $82
	ret

.low_score
	ld a, $81
	ret

; if any Psychic Energy is found in the Discard Pile,
; return a score of $80 + 2.
HandleEnergyAbsorption: ; 16f41 (5:6f41)
	ld e, PSYCHIC_ENERGY
	ld a, CARD_LOCATION_DISCARD_PILE
	call CheckIfAnyCardIDinLocation
	jp nc, HandleSpecialAIMoves.zero
	ld a, $82
	ret

; if player has cards in hand, AI calls Random:
; - 1/3 chance to encourage move regardless;
; - 1/3 chance to dismiss move regardless;
; - 1/3 change to make some checks to player's hand.
; AI tallies number of basic cards in hand, and if this
; number is >= 2, encourage move.
; otherwise, if it finds an evolution card in hand that
; can evolve a card in player's deck, encourage.
; if encouraged, returns a score of $80 + 3.
HandleNinetalesMixUp: ; 16f4e (5:6f4e)
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetNonTurnDuelistVariable
	or a
	ret z

	ld a, 3
	call Random
	or a
	jr z, .encourage
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
	jr nc, .check_play_area

	ld hl, wDuelTempList
	ld b, 0
.loop_hand
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
	jr nc, .loop_hand
	ld a, [wLoadedCard2Stage]
	or a
	jr nz, .loop_hand
	; is a basic Pokémon card
	inc b
	jr .loop_hand
.tally_basic_cards
	ld a, b
	cp 2
	jr nc, .encourage

; less than 2 basic cards in hand
.check_play_area
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
.loop_play_area
	ld a, [hli]
	cp $ff
	jp z, HandleSpecialAIMoves.zero
	push hl
	call SwapTurn
	call CheckForEvolutionInList
	call SwapTurn
	pop hl
	jr nc, .loop_play_area

.encourage
	ld a, $83
	ret

; return score of $80 + 3.
HandleZapdos3BigThunder: ; 16fb8 (5:6fb8)
	ld a, $83
	ret

; dismiss move if cards in deck <= 20.
; otherwise return a score of $80 + 0.
HandleKangaskhanFetch: ; 16fbb (5:6fbb)
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp 41
	jp nc, HandleSpecialAIMoves.zero
	ld a, $80
	ret

; dismiss move if number of own benched cards which would
; be KOd is greater than or equal to the number
; of prize cards left for player.
HandleDugtrioEarthquake: ; 16fc8 (5:6fc8)
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable

	lb de, 0, 0
.loop
	inc e
	ld a, [hli]
	cp $ff
	jr z, .count_prizes
	ld a, e
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	cp 20
	jr nc, .loop
	inc d
	jr .loop

.count_prizes
	push de
	call CountPrizes
	pop de
	cp d
	jp c, HandleSpecialAIMoves.zero
	jp z, HandleSpecialAIMoves.zero
	ld a, $80
	ret

; if there's any lightning energy cards in deck,
; return a score of $80 + 3.
HandleElectrode1EnergySpike: ; 16ff2 (5:6ff2)
	ld a, CARD_LOCATION_DECK
	ld e, LIGHTNING_ENERGY
	call CheckIfAnyCardIDinLocation
	jp nc, HandleSpecialAIMoves.zero
	call AIProcessButDontPlayEnergy_SkipEvolution
	jp nc, HandleSpecialAIMoves.zero
	ld a, $83
	ret

; only incentivize move if player's active card,
; has any energy cards attached, and if so,
; return a score of $80 + 3.
HandleHyperBeam: ; 17005 (5:7005)
	call SwapTurn
	ld e, PLAY_AREA_ARENA
	call CountNumberOfEnergyCardsAttached
	call SwapTurn
	or a
	jr z, .keep_score
	ld a, $83
	ret
.keep_score
	ld a, $80
	ret

; called when second attack is determined by AI to have
; more AI score than the first attack, so that it checks
; whether the first attack is a better alternative.
CheckWhetherToSwitchToFirstAttack: ; 17019 (5:7019)
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
	xor a
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
; next turn, keep second move as the option.
; otherwise switch to the first attack.
.check_flag
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld e, $01 ; second attack
	call CopyMoveDataAndDamage_FromDeckIndex
	ld a, MOVE_FLAG2_ADDRESS | HEAL_USER_F
	call CheckLoadedMoveFlag
	jr c, .keep_second_attack
	ld a, MOVE_FLAG2_ADDRESS | NULLIFY_OR_WEAKEN_ATTACK_F
	call CheckLoadedMoveFlag
	jr c, .keep_second_attack
; switch to first attack
	xor a
	ld [wSelectedAttack], a
	ret
.keep_second_attack
	ld a, $01
	ld [wSelectedAttack], a
	ret

; returns carry if there are
; any basic Pokémon cards in deck.
CheckIfAnyBasicPokemonInDeck: ; 17057 (5:7057)
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

; checks in other Play Area for non-basic cards.
; afterwards, that card is checked for damage,
; and if the damage counters it has is greater than or equal
; to the max HP of the card stage below it,
; return carry and that card's Play Area location in a.
; output:
;	a = card location of Pokémon card, if found;
;	carry set if such a card is found.
LookForCardThatIsKnockedOutOnDevolution: ; 17080 (5:7080)
	ldh a, [hTempPlayAreaLocation_ff9d]
	push af
	call SwapTurn
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld b, a
	ld c, PLAY_AREA_ARENA

.loop
	ld a, c
	ldh [hTempPlayAreaLocation_ff9d], a
	push bc
	bank1call GetCardOneStageBelow
	pop bc
	jr c, .next
	; is not a basic card
	; compare its HP with current damage
	ld a, d
	push bc
	call LoadCardDataToBuffer2_FromDeckIndex
	pop bc
	ld a, [wLoadedCard2HP]
	ld [wTempAI], a
	ld e, c
	push bc
	call GetCardDamageAndMaxHP
	pop bc
	ld e, a
	ld a, [wTempAI]
	cp e
	jr c, .set_carry
	jr z, .set_carry
.next
	inc c
	ld a, c
	cp b
	jr nz, .loop

	call SwapTurn
	pop af
	ldh [hTempPlayAreaLocation_ff9d], a
	or a
	ret

.set_carry
	call SwapTurn
	pop af
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, c
	scf
	ret

; returns carry if the following conditions are met:
;	- arena card HP >= half max HP
;	- arena card Unknown2's 4 bit is not set or
;	  is set but there's no evolution of card in hand/deck
;	- arena card can use second move
CheckIfArenaCardIsAtHalfHPCanEvolveAndUseSecondMove: ; 170c9 (5:70c9)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	push de
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wLoadedCard1HP]
	rrca
	cp d
	pop de
	jr nc, .no_carry

	ld a, [wLoadedCard1Unknown2]
	and %00010000
	jr z, .check_second_attack
	ld a, d
	call CheckCardEvolutionInHandOrDeck
	jr c, .no_carry

.check_second_attack
	xor a ; active card
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, $01 ; second move
	ld [wSelectedAttack], a
	push hl
	call CheckIfSelectedMoveIsUnusable
	pop hl
	jr c, .no_carry
	scf
	ret
.no_carry
	or a
	ret

; count Pokemon in the Bench that
; meet the following conditions:
;	- card HP > half max HP
;	- card Unknown2's 4 bit is not set or
;	  is set but there's no evolution of card in hand/deck
;	- card can use second move
; Outputs the number of Pokémon in bench
; that meet these requirements in a
; and returns carry if at least one is found
CountNumberOfSetUpBenchPokemon: ; 17101 (5:7101)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld d, a
	ld a, [wSelectedAttack]
	ld e, a
	push de
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	lb bc, 0, 0
	push hl

.next
	inc c
	pop hl
	ld a, [hli]
	push hl
	cp $ff
	jr z, .done

	ld d, a
	push de
	push bc
	call LoadCardDataToBuffer1_FromDeckIndex
	pop bc

; compares card's current HP with max HP
	ld a, c
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wLoadedCard1HP]
	rrca

; a = max HP / 2
; d = current HP
; jumps if (current HP) <= (max HP / 2)
	cp d
	pop de
	jr nc, .next

	ld a, [wLoadedCard1Unknown2]
	and $10
	jr z, .check_second_attack

	ld a, d
	push bc
	call CheckCardEvolutionInHandOrDeck
	pop bc
	jr c, .next

.check_second_attack
	ld a, c
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, $01 ; second move
	ld [wSelectedAttack], a
	push bc
	push hl
	call CheckIfSelectedMoveIsUnusable
	pop hl
	pop bc
	jr c, .next
	inc b
	jr .next

.done
	pop hl
	pop de
	ld a, e
	ld [wSelectedAttack], a
	ld a, d
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, b
	or a
	ret z
	scf
	ret

; handles AI logic to determine some selections regarding certain attacks,
; if any of these attacks were chosen to be used.
; returns carry if selection was successful,
; and no carry if unable to make one.
; outputs in hTempPlayAreaLocation_ffa1 the chosen parameter.
AISelectSpecialAttackParameters: ; 17161 (5:7161)
	ld a, [wSelectedAttack]
	push af
	call .SelectAttackParameters
	pop bc
	ld a, b
	ld [wSelectedAttack], a
	ret

.SelectAttackParameters: ; 1716e (5:716e)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp MEW3
	jr z, .devolution_beam
	cp MEWTWO3
	jr z, .energy_absorption
	cp MEWTWO2
	jr z, .energy_absorption
	cp EXEGGUTOR
	jr z, .teleport
	cp ELECTRODE1
	jr z, .energy_spike
	; fallthrough

.no_carry
	or a
	ret

.devolution_beam
; in case selected attack is Devolution Beam
; store in hTempPlayAreaLocation_ffa1
; the location of card to select to devolve
	ld a, [wSelectedAttack]
	or a
	jp z, .no_carry ; can be jr

	ld a, $01
	ldh [hTemp_ffa0], a
	call LookForCardThatIsKnockedOutOnDevolution
	ldh [hTempPlayAreaLocation_ffa1], a

.set_carry_1
	scf
	ret

.energy_absorption
; in case selected attack is Energy Absorption
; make list from energy cards in Discard Pile
	ld a, [wSelectedAttack]
	or a
	jp nz, .no_carry  ; can be jr

	ld a, $ff
	ldh [hTempPlayAreaLocation_ffa1], a
	ldh [hTempRetreatCostCards], a

; search for Psychic energy cards in Discard Pile
	ld e, PSYCHIC_ENERGY
	ld a, CARD_LOCATION_DISCARD_PILE
	call CheckIfAnyCardIDinLocation
	ldh [hTemp_ffa0], a
	farcall CreateEnergyCardListFromDiscardPile_AllEnergy

; find any energy card different from
; the one found by CheckIfAnyCardIDinLocation.
; since using this move requires a Psychic energy card,
; and another one is in hTemp_ffa0,
; then any other energy card would account
; for the Energy Cost of Psyburn.
	ld hl, wDuelTempList
.loop_energy_cards
	ld a, [hli]
	cp $ff
	jr z, .set_carry_2
	ld b, a
	ldh a, [hTemp_ffa0]
	cp b
	jr z, .loop_energy_cards ; same card, keep looking

; store the deck index of energy card found
	ld a, b
	ldh [hTempPlayAreaLocation_ffa1], a
	; fallthrough

.set_carry_2
	scf
	ret

.teleport
; in case selected attack is Teleport
; decide Bench card to switch to.
	ld a, [wSelectedAttack]
	or a
	jp nz, .no_carry  ; can be jr
	call AIDecideBenchPokemonToSwitchTo
	jr c, .no_carry
	ldh [hTemp_ffa0], a
	scf
	ret

.energy_spike
; in case selected attack is Energy Spike
; decide basic energy card to fetch from Deck.
	ld a, [wSelectedAttack]
	or a
	jp z, .no_carry  ; can be jr

	ld a, CARD_LOCATION_DECK
	ld e, LIGHTNING_ENERGY

; if none were found in Deck, return carry...
	call CheckIfAnyCardIDinLocation
	ldh [hTemp_ffa0], a
	jp nc, .no_carry  ; can be jr

; ...else find a suitable Play Area Pokemon to
; attach the energy card to.
	call AIProcessButDontPlayEnergy_SkipEvolution
	jp nc, .no_carry  ; can be jr
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTempPlayAreaLocation_ffa1], a
	scf
	ret

; return carry if Pokémon at play area location
; in hTempPlayAreaLocation_ff9d does not have
; energy required for the move index in wSelectedAttack
; or has exactly the same amount of energy needed
; input:
;	[hTempPlayAreaLocation_ff9d] = play area location
;	[wSelectedAttack]         = move index to check
; output:
;	a = number of extra energy cards attached
CheckIfNoSurplusEnergyForMove: ; 171fb (5:71fb)
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wSelectedAttack]
	ld e, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld hl, wLoadedMoveName
	ld a, [hli]
	or [hl]
	jr z, .not_attack
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr nz, .is_attack
.not_attack
	scf
	ret

.is_attack
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	bank1call HandleEnergyBurn
	xor a
	ld [wTempLoadedMoveEnergyCost], a
	ld [wTempLoadedMoveEnergyNeededAmount], a
	ld [wTempLoadedMoveEnergyNeededType], a
	ld hl, wAttachedEnergies
	ld de, wLoadedMoveEnergyCost
	ld b, 0
	ld c, (NUM_TYPES / 2) - 1
.loop
	; check all basic energy cards except colorless
	ld a, [de]
	swap a
	call CalculateParticularAttachedEnergyNeeded
	ld a, [de]
	call CalculateParticularAttachedEnergyNeeded
	inc de
	dec c
	jr nz, .loop

	; colorless
	ld a, [de]
	swap a
	and %00001111
	ld b, a
	ld hl, wTempLoadedMoveEnergyCost
	ld a, [wTotalAttachedEnergies]
	sub [hl]
	sub b
	ret c ; return if not enough energy

	or a
	ret nz ; return if surplus energy

	; exactly the amount of energy needed
	scf
	ret

; takes as input the energy cost of a move for a
; particular energy, stored in the lower nibble of a
; if the move costs some amount of this energy, the lower nibble of a != 0,
; and this amount is stored in wTempLoadedMoveEnergyCost
; also adds the amount of energy still needed
; to wTempLoadedMoveEnergyNeededAmount
; input:
;	a    = this energy cost of move (lower nibble)
;	[hl] = attached energy
; output:
;	carry set if not enough of this energy type attached
CalculateParticularAttachedEnergyNeeded: ; 17258 (5:7258)
	and %00001111
	jr nz, .check
.done
	inc hl
	inc b
	ret

.check
	ld [wTempLoadedMoveEnergyCost], a
	sub [hl]
	jr z, .done
	jr nc, .done
	push bc
	ld a, [wTempLoadedMoveEnergyCost]
	ld b, a
	ld a, [hl]
	sub b
	pop bc
	ld [wTempLoadedMoveEnergyNeededAmount], a
	jr .done

; return carry if there is a card that
; can evolve a Pokémon in hand or deck.
; input:
;	a = deck index of card to check;
; output:
;	a = deck index of evolution in hand, if found;
;	carry set if there's a card in hand that can evolve.
CheckCardEvolutionInHandOrDeck: ; 17274 (5:7274)
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	push af
	ld [hl], b
	ld e, 0

.loop
	ld a, DUELVARS_CARD_LOCATIONS
	add e
	call GetTurnDuelistVariable
	cp CARD_LOCATION_DECK
	jr z, .deck_or_hand
	cp CARD_LOCATION_HAND
	jr nz, .next
.deck_or_hand
	push de
	ld d, e
	ld e, PLAY_AREA_ARENA
	call CheckIfCanEvolveInto
	pop de
	jr nc, .set_carry
.next
	inc e
	ld a, DECK_SIZE
	cp e
	jr nz, .loop

	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	or a
	ret

.set_carry
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	ld a, e
	scf
	ret

; sets up the initial hand of boss deck.
; always draws at least 2 Basic Pokemon cards and 2 Energy cards.
; also sets up so that the next cards to be drawn have
; some minimum number of Basic Pokemon and Energy cards.
SetUpBossStartingHandAndDeck: ; 172af (5:72af)
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
	ld [wce06], a
	ld [wce08], a

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
	ld a, [wce08]
	inc a
	ld [wce08], a
	jr .next_card_deck_1

.pokemon_card_1
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .next_card_deck_1 ; not basic
	ld a, [wce06]
	inc a
	ld [wce06], a

.next_card_deck_1
	dec b
	jr nz, .loop_deck_1

; tally the number of Energy and basic Pokemon cards
; and if any of them is smaller than 2, re-shuffle deck.
	ld a, [wce06]
	cp 2
	jr c, .shuffle_deck
	ld a, [wce08]
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
	ld a, [wce08]
	inc a
	ld [wce08], a
	jr .next_card_deck_2

.pokemon_card_2
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .next_card_deck_2
	ld a, [wce06]
	inc a
	ld [wce06], a

.next_card_deck_2
	dec b
	jr nz, .loop_deck_2

	ld a, [wce06]
	cp 4
	jp c, .shuffle_deck
	ld a, [wce08]
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

; returns carry if Pokemon at PLAY_AREA* in a
; can damage defending Pokémon with any of its moves
; input:
;	a = location of card to check
CheckIfCanDamageDefendingPokemon: ; 17383 (5:7383)
	ldh [hTempPlayAreaLocation_ff9d], a
	xor a ; first move
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
	jr c, .second_attack
	xor a
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr nz, .set_carry

.second_attack
	ld a, $01 ; second move
	ld [wSelectedAttack], a
	call CheckIfSelectedMoveIsUnusable
	jr c, .no_carry
	ld a, $01
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr nz, .set_carry

.no_carry
	or a
	ret
.set_carry
	scf
	ret

; checks if defending Pokémon can knock out
; card at hTempPlayAreaLocation_ff9d with any of its moves
; and if so, stores the damage to wce00 and wce01
; sets carry if any on the moves knocks out
; also outputs the largest damage dealt in a
; input:
;	[hTempPlayAreaLocation_ff9d] = location of card to check
; output:
;	a = largest damage of both moves
;	carry set if can knock out
CheckIfDefendingPokemonCanKnockOut: ; 173b1 (5:73b1)
	xor a ; first move
	ld [wce00], a
	ld [wce01], a
	call CheckIfDefendingPokemonCanKnockOutWithMove
	jr nc, .second_attack
	ld a, [wDamage]
	ld [wce00], a

.second_attack
	ld a, $01 ; second move
	call CheckIfDefendingPokemonCanKnockOutWithMove
	jr nc, .return_if_neither_kos
	ld a, [wDamage]
	ld [wce01], a
	jr .compare

.return_if_neither_kos
	ld a, [wce00]
	or a
	ret z

.compare
	ld a, [wce00]
	ld b, a
	ld a, [wce01]
	cp b
	jr nc, .set_carry
	ld a, b
.set_carry
	scf
	ret

; return carry if defending Pokémon can knock out
; card at hTempPlayAreaLocation_ff9d
; input:
;	a = move index
;	[hTempPlayAreaLocation_ff9d] = location of card to check
CheckIfDefendingPokemonCanKnockOutWithMove: ; 173e4 (5:73e4)
	ld [wSelectedAttack], a
	ldh a, [hTempPlayAreaLocation_ff9d]
	push af
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call SwapTurn
	call CheckIfSelectedMoveIsUnusable
	call SwapTurn
	pop bc
	ld a, b
	ldh [hTempPlayAreaLocation_ff9d], a
	jr c, .done

; player's active Pokémon can use move
	ld a, [wSelectedAttack]
	call EstimateDamage_FromDefendingPokemon
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr z, .set_carry
	ret

.set_carry
	scf
	ret

.done
	or a
	ret

; sets carry if Opponent's deck ID
; is between LEGENDARY_MOLTRES_DECK_ID (inclusive)
; and MUSCLES_FOR_BRAINS_DECK_ID (exclusive)
; these are the decks for Grandmaster/Club Master/Ronald
CheckIfOpponentHasBossDeckID: ; 17414 (5:7414)
	push af
	ld a, [wOpponentDeckID]
	cp LEGENDARY_MOLTRES_DECK_ID
	jr c, .no_carry
	cp MUSCLES_FOR_BRAINS_DECK_ID
	jr nc, .no_carry
	pop af
	scf
	ret

.no_carry
	pop af
	or a
	ret

; sets carry if not a boss fight
; and if s0a00a == 0
CheckIfNotABossDeckID: ; 17426 (5:7426)
	call EnableSRAM
	ld a, [s0a00a]
	call DisableSRAM
	or a
	jr nz, .no_carry
	call CheckIfOpponentHasBossDeckID
	jr nc, .set_carry
.no_carry
	or a
	ret

.set_carry
	scf
	ret

; probability to return carry:
; - 50% if deck AI is playing is on the list;
; - 25% for all other decks;
; - 0% for boss decks.
; used for certain decks to randomly choose
; not to play Trainer card or use PKMN Power
AIChooseRandomlyNotToDoAction: ; 1743b (5:743b)
; boss decks always use Trainer cards.
	push hl
	push de
	call CheckIfNotABossDeckID
	jr c, .check_deck
	pop de
	pop hl
	ret

.check_deck
	ld a, [wOpponentDeckID]
	cp MUSCLES_FOR_BRAINS_DECK_ID
	jr z, .carry_50_percent
	cp BLISTERING_POKEMON_DECK_ID
	jr z, .carry_50_percent
	cp WATERFRONT_POKEMON_DECK_ID
	jr z, .carry_50_percent
	cp BOOM_BOOM_SELFDESTRUCT_DECK_ID
	jr z, .carry_50_percent
	cp KALEIDOSCOPE_DECK_ID
	jr z, .carry_50_percent
	cp RESHUFFLE_DECK_ID
	jr z, .carry_50_percent

; carry 25 percent
	ld a, 4
	call Random
	cp 1
	pop de
	pop hl
	ret

.carry_50_percent
	ld a, 4
	call Random
	cp 2
	pop de
	pop hl
	ret

; checks if any bench Pokémon has same ID
; as input, and sets carry if it has more than
; half health and can use its second move
; input:
;	a = card ID to check for
; output:
;	carry set if the above requirements are met
CheckForBenchIDAtHalfHPAndCanUseSecondMove: ; 17474 (5:7474)
	ld [wcdf9], a
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld d, a
	ld a, [wSelectedAttack]
	ld e, a
	push de
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	lb bc, 0, PLAY_AREA_ARENA
	push hl

.loop
	inc c
	pop hl
	ld a, [hli]
	push hl
	cp $ff
	jr z, .done
	ld d, a
	push de
	push bc
	call LoadCardDataToBuffer1_FromDeckIndex
	pop bc
	ld a, c
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wLoadedCard1HP]
	rrca
	cp d
	pop de
	jr nc, .loop
	; half max HP < current HP
	ld a, [wLoadedCard1ID]
	ld hl, wcdf9
	cp [hl]
	jr nz, .loop

	ld a, c
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, $01 ; second move
	ld [wSelectedAttack], a
	push bc
	call CheckIfSelectedMoveIsUnusable
	pop bc
	jr c, .loop
	inc b
.done
	pop hl
	pop de
	ld a, e
	ld [wSelectedAttack], a
	ld a, d
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, b
	or a
	ret z
	scf
	ret

; add 5 to wPlayAreaEnergyAIScore AI score corresponding to all cards
; in bench that have same ID as register a
; input:
;	a = card ID to look for
RaiseAIScoreToAllMatchingIDsInBench: ; 174cd (5:74cd)
	ld d, a
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	ld e, 0
.loop
	inc e
	ld a, [hli]
	cp $ff
	ret z
	push de
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	cp d
	jr nz, .loop
	ld c, e
	ld b, $00
	push hl
	ld hl, wPlayAreaEnergyAIScore
	add hl, bc
	ld a, 5
	add [hl]
	ld [hl], a
	pop hl
	jr .loop

; goes through each play area Pokémon, and
; for all cards of the same ID, determine which
; card has highest value calculated from Func_17583
; the card with highest value gets increased wPlayAreaEnergyAIScore
; while all others get decreased wPlayAreaEnergyAIScore
Func_174f2: ; 174f2 (5:74f2)
	ld a, MAX_PLAY_AREA_POKEMON
	ld hl, wcdfa
	call ClearMemory_Bank5
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	ld e, 0

.loop_play_area
	push hl
	ld a, MAX_PLAY_AREA_POKEMON
	ld hl, wcdea
	call ClearMemory_Bank5
	pop hl
	inc e
	ld a, [hli]
	cp $ff
	ret z

	ld [wcdf9], a
	push de
	push hl

; checks wcdfa + play area location in e
; if != 0, go to next in play area
	ld d, $00
	ld hl, wcdfa
	add hl, de
	ld a, [hl]
	or a
	pop hl
	pop de
	jr nz, .loop_play_area

; loads wcdf9 with card ID
; and call Func_17583
	push de
	ld a, [wcdf9]
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wcdf9], a
	pop de
	push hl
	push de
	call Func_17583

; check play area Pokémon ahead
; if there is a card with the same ID,
; call Func_17583 for it as well
.loop_1
	inc e
	ld a, [hli]
	cp $ff
	jr z, .check_if_repeated_id
	push de
	call GetCardIDFromDeckIndex
	ld a, [wcdf9]
	cp e
	pop de
	jr nz, .loop_1
	call Func_17583
	jr .loop_1

; if there are more than 1 of the same ID
; in play area, iterate bench backwards
; and determines which card has highest
; score in wcdea
.check_if_repeated_id
	call Func_175a8
	jr c, .next
	lb bc, 0, 0
	ld hl, wcdea + MAX_BENCH_POKEMON
	ld d, MAX_PLAY_AREA_POKEMON
.loop_2
	dec d
	jr z, .asm_17560
	ld a, [hld]
	cp b
	jr c, .loop_2
	ld b, a
	ld c, d
	jr .loop_2

; c = play area location of highest score
; decrease wPlayAreaEnergyAIScore score for all cards with same ID
; except for the one with highest score
; increase wPlayAreaEnergyAIScore score for card with highest ID
.asm_17560
	ld hl, wPlayAreaEnergyAIScore
	ld de, wcdea
	ld b, PLAY_AREA_ARENA
.loop_3
	ld a, c
	cp b
	jr z, .card_with_highest
	ld a, [de]
	or a
	jr z, .check_next
; decrease score
	dec [hl]
	jr .check_next
.card_with_highest
; increase score
	inc [hl]
.check_next
	inc b
	ld a, MAX_PLAY_AREA_POKEMON
	cp b
	jr z, .next
	inc de
	inc hl
	jr .loop_3

.next
	pop de
	pop hl
	jp .loop_play_area

; loads wcdea + play area location in e
; with energy  * 2 + $80 - floor(dam / 10)
; loads wcdfa + play area location in e
; with $01
Func_17583: ; 17583 (5:7583)
	push hl
	push de
	call GetCardDamageAndMaxHP
	call CalculateByteTensDigit
	ld b, a
	push bc
	call CountNumberOfEnergyCardsAttached
	pop bc
	sla a
	add $80
	sub b
	pop de
	push de
	ld d, $00
	ld hl, wcdea
	add hl, de
	ld [hl], a
	ld hl, wcdfa
	add hl, de
	ld [hl], $01
	pop de
	pop hl
	ret

; counts how many play area locations in wcdea
; are != 0, and outputs result in a
; also returns carry if result is < 2
Func_175a8: ; 175a8 (5:75a8)
	ld hl, wcdea
	ld d, $00
	ld e, MAX_PLAY_AREA_POKEMON + 1
.loop
	dec e
	jr z, .done
	ld a, [hli]
	or a
	jr z, .loop
	inc d
	jr .loop
.done
	ld a, d
	cp 2
	ret

; handle how AI scores giving out Energy Cards
; when using Legendary Articuno deck
HandleLegendaryArticunoEnergyScoring: ; 175bd (5:75bd)
	ld a, [wOpponentDeckID]
	cp LEGENDARY_ARTICUNO_DECK_ID
	jr z, .articuno_deck
	ret
.articuno_deck
	call ScoreLegendaryArticunoCards
	ret

Func_175c9: ; 175c9 (5:75c9)
	INCROM $175c9, $18000
