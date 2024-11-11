INCLUDE "engine/duel/ai/decks/unreferenced.asm"

; returns carry if damage dealt from any of
; a card's attacks KOs defending Pokémon
; outputs index of the attack that KOs
; input:
;	[hTempPlayAreaLocation_ff9d] = location of attacking card to consider
; output:
;	[wSelectedAttack] = attack index that KOs
CheckIfAnyAttackKnocksOutDefendingCard:
	xor a ; FIRST_ATTACK_OR_PKMN_POWER
	call .CheckAttack
	ret c
	ld a, SECOND_ATTACK
.CheckAttack:
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
; outputs that attack index in wSelectedAttack.
CheckIfAnyDefendingPokemonAttackDealsSameDamageAsHP:
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
FindHighestBenchScore:
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld b, a
	ld c, 0
	ld e, c
	ld d, c
	ld hl, wPlayAreaAIScore + 1
	jp .next ; can be jr

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
; if there's overflow, it's capped at 255
; output:
;	a = a + wAIScore (capped at 255)
AIEncourage:
	push hl
	ld hl, wAIScore
	add [hl]
	jr nc, .no_cap
	ld a, 255
.no_cap
	ld [hl], a
	pop hl
	ret

; subs a from wAIScore
; if there's underflow, it's capped at 0
AIDiscourage:
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
	ld [hl], 0
.done
	pop de
	pop hl
	ret

; loads defending Pokémon's weakness/resistance
; and the number of prize cards in both sides
LoadDefendingPokemonColorWRAndPrizeCards:
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
AITryUseAttack:
	ld a, [wSelectedAttack]
	ldh [hTemp_ffa0], a
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [hTempCardIndex_ff9f], a
	ld d, a
	call CopyAttackDataAndDamage_FromDeckIndex
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
	call CopyAttackDataAndDamage_FromDeckIndex
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
;	  attacks that require energy other than its color and
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
CheckIfEnergyIsUseful:
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
	cp SURFING_PIKACHU_LV13
	jr z, .check_energy
	cp SURFING_PIKACHU_ALT_LV13
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
PickRandomBenchPokemon:
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	dec a
	call Random
	inc a
	ret

AIPickPrizeCards:
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
.PickPrizeCard:
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

.prize_flags
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
AIPlayInitialBasicCards:
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
; can't use an attack or if that selected attack doesn't have enough energy
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedAttack]         = selected attack to examine
CheckIfSelectedAttackIsUnusable:
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
	call CopyAttackDataAndDamage_FromDeckIndex
	call HandleAmnesiaSubstatus
	ret c
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_1
	call TryExecuteEffectCommandFunction
	ret c

.bench
	call CheckEnergyNeededForAttack
	ret c ; can't be used
	ld a, ATTACK_FLAG2_ADDRESS | FLAG_2_BIT_5_F
	call CheckLoadedAttackFlag
	ret

; load selected attack from Pokémon in hTempPlayAreaLocation_ff9d
; and checks if there is enough energy to execute the selected attack
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedAttack]         = selected attack to examine
; output:
;	b = basic energy still needed
;	c = colorless energy still needed
;	e = output of ConvertColorToEnergyCardID, or $0 if not an attack
;	carry set if no attack
;	       OR if it's a Pokémon Power
;	       OR if not enough energy for attack
CheckEnergyNeededForAttack:
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wSelectedAttack]
	ld e, a
	call CopyAttackDataAndDamage_FromDeckIndex
	ld hl, wLoadedAttackName
	ld a, [hli]
	or [hl]
	jr z, .no_attack
	ld a, [wLoadedAttackCategory]
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
	ld [wTempLoadedAttackEnergyCost], a
	ld [wTempLoadedAttackEnergyNeededAmount], a
	ld [wTempLoadedAttackEnergyNeededType], a

	ld hl, wAttachedEnergies
	ld de, wLoadedAttackEnergyCost
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
; however, no attack in the game has energy requirements for two
; different energy types (excluding colorless), so this routine
; will always just return the result for one type of basic energy,
; while all others will necessarily have an energy cost of 0
; if attacks are added to the game with energy requirements of
; two different basic energy types, then this routine only accounts
; for the type with the highest index

	; colorless
	ld a, [de]
	swap a
	and %00001111
	ld b, a ; colorless energy still needed
	ld a, [wTempLoadedAttackEnergyCost]
	ld hl, wTempLoadedAttackEnergyNeededAmount
	sub [hl]
	ld c, a ; basic energy still needed
	ld a, [wTotalAttachedEnergies]
	sub c
	sub b
	jr c, .not_enough

	ld a, [wTempLoadedAttackEnergyNeededAmount]
	or a
	ret z

; being here means the energy cost isn't satisfied,
; including with colorless energy
	xor a
.not_enough
	cpl
	inc a
	ld c, a ; colorless energy still needed
	ld a, [wTempLoadedAttackEnergyNeededAmount]
	ld b, a ; basic energy still needed
	ld a, [wTempLoadedAttackEnergyNeededType]
	call ConvertColorToEnergyCardID
	ld e, a
	ld d, 0
	scf
	ret

; takes as input the energy cost of an attack for a
; particular energy, stored in the lower nibble of a
; if the attack costs some amount of this energy, the lower nibble of a != 0,
; and this amount is stored in wTempLoadedAttackEnergyCost
; sets carry flag if not enough energy of this type attached
; input:
;	a    = this energy cost of attack (lower nibble)
;	[hl] = attached energy
; output:
;	carry set if not enough of this energy type attached
CheckIfEnoughParticularAttachedEnergy:
	and %00001111
	jr nz, .check
.has_enough
	inc hl
	inc b
	or a
	ret

.check
	ld [wTempLoadedAttackEnergyCost], a
	sub [hl]
	jr z, .has_enough
	jr c, .has_enough

	; not enough energy
	ld [wTempLoadedAttackEnergyNeededAmount], a
	ld a, b
	ld [wTempLoadedAttackEnergyNeededType], a
	inc hl
	inc b
	scf
	ret

; input:
;	a = energy type
; output:
;	a = energy card ID
ConvertColorToEnergyCardID:
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

; returns carry if loaded attack effect has
; an "initial effect 2" or "require selection" command type
; unreferenced
Func_14323:
	ld hl, wLoadedAttackEffectCommands
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_2
	push hl
	call CheckMatchingCommand
	pop hl
	jr nc, .set_carry
	ld a, EFFECTCMDTYPE_REQUIRE_SELECTION
	call CheckMatchingCommand
	jr nc, .set_carry
	or a
	ret
.set_carry
	scf
	ret

; return carry depending on card index in a:
;	- if energy card, return carry if no energy card has been played yet
;	- if basic Pokémon card, return carry if there's space in bench
;	- if evolution card, return carry if there's a Pokémon
;	  in Play Area it can evolve
;	- if trainer card, return carry if it can be used
; input:
;	a = card index to check
CheckIfCardCanBePlayed:
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
	bank1call CheckCantUseTrainerDueToEffect
	ret c
	call LoadNonPokemonCardEffectCommands
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_1
	call TryExecuteEffectCommandFunction
	ret

; loads all the energy cards
; in hand in wDuelTempList
; return carry if no energy cards found
CreateEnergyCardListFromHand:
	push hl
	push de
	push bc
	ld de, wDuelTempList
	ld b, a
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	ld c, a
	inc c
	ld l, DUELVARS_HAND
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
LookForCardIDInHand:
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

INCLUDE "engine/duel/ai/damage_calculation.asm"

AIProcessHandTrainerCards:
	farcall _AIProcessHandTrainerCards
	ret

INCLUDE "engine/duel/ai/deck_ai.asm"

; return carry if card ID loaded in a is found in hand
; and outputs in a the deck index of that card
; as opposed to LookForCardIDInHand, this function
; creates a list in wDuelTempList
; input:
;	a = card ID
; output:
;	a = card deck index, if found
;	carry set if found
LookForCardIDInHandList_Bank5:
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
LookForCardIDInPlayArea_Bank5:
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

; not found
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
AIAttachEnergyInHandToCardInPlayArea:
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
AIAttachEnergyInHandToCardInBench:
	ld a, e
	push de
	call LookForCardIDInHandList_Bank5
	pop de
	ret nc
	ld b, PLAY_AREA_BENCH_1
	jr AIAttachEnergyInHandToCardInPlayArea.attach

INCLUDE "engine/duel/ai/init.asm"

; load selected attack from Pokémon in hTempPlayAreaLocation_ff9d,
; gets an energy card to discard and subsequently
; check if there is enough energy to execute the selected attack
; after removing that attached energy card.
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedAttack]         = selected attack to examine
; output:
;	b = basic energy still needed
;	c = colorless energy still needed
;	e = output of ConvertColorToEnergyCardID, or $0 if not an attack
;	carry set if no attack
;	       OR if it's a Pokémon Power
;	       OR if not enough energy for attack
CheckEnergyNeededForAttackAfterDiscard:
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wSelectedAttack]
	ld e, a
	call CopyAttackDataAndDamage_FromDeckIndex
	ld hl, wLoadedAttackName
	ld a, [hli]
	or [hl]
	jr z, .no_attack
	ld a, [wLoadedAttackCategory]
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
	ld [wTempLoadedAttackEnergyCost], a
	ld [wTempLoadedAttackEnergyNeededAmount], a
	ld [wTempLoadedAttackEnergyNeededType], a
	ld hl, wAttachedEnergies
	ld de, wLoadedAttackEnergyCost
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
	ld a, [wTempLoadedAttackEnergyCost]
	ld hl, wTempLoadedAttackEnergyNeededAmount
	sub [hl]
	ld c, a ; basic energy still needed
	ld a, [wTotalAttachedEnergies]
	sub c
	sub b
	jr c, .not_enough_energy

	ld a, [wTempLoadedAttackEnergyNeededAmount]
	or a
	ret z

; being here means the energy cost isn't satisfied,
; including with colorless energy
	xor a
.not_enough_energy
	cpl
	inc a
	ld c, a ; colorless energy still needed
	ld a, [wTempLoadedAttackEnergyNeededAmount]
	ld b, a ; basic energy still needed
	ld a, [wTempLoadedAttackEnergyNeededType]
	call ConvertColorToEnergyCardID
	ld e, a
	ld d, 0
	scf
	ret

; zeroes a bytes starting from hl.
; this function is identical to 'ClearMemory_Bank2',
; 'ClearMemory_Bank6' and 'ClearMemory_Bank8'.
; preserves all registers
; input:
;	a = number of bytes to clear
;	hl = where to begin erasing
ClearMemory_Bank5:
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

; converts an HP value or amount of damage to the number of equivalent damage counters
; preserves all registers except af
; input:
;	a = HP value to convert
; output:
;	a = number of damage counters
ConvertHPToDamageCounters_Bank5:
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
CalculateBDividedByA_Bank5:
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
CountNumberOfEnergyCardsAttached:
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
;	a = CARD_LOCATION_* constant
;	e = card ID to look for
; output:
;	a & e = deck index of a matching card, if any
;	carry set if found
LookForCardIDInLocation_Bank5:
	ld b, a
	ld c, e
	lb de, 0, 0 ; d is never used
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
	jr z, .found
.next
	inc e
	ld a, DECK_SIZE
	cp e
	jr nz, .loop

; not found
	or a
	ret
.found
	ld a, e
	scf
	ret

; counts total number of energy cards in opponent's hand
; plus all the cards attached in Turn Duelist's Play Area.
; output:
;	a and wTempAI = total number of energy cards.
CountOppEnergyCardsInHandAndAttached:
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
RemoveCardIDInList:
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
TrySetUpBossStartingPlayArea:
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
.PlayPokemonCardInOrder
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

; expects a $00-terminated list of 3-byte data with the following:
; - non-zero value (anything but $1 is ignored)
; - card ID to look for in Play Area
; - number of energy cards
; returns carry if a card ID is found in bench with at least the
; listed number of energy cards
; unreferenced
Func_1585b:
	ld a, [hli]
	or a
	jr z, .no_carry
	dec a
	jr nz, .next_1
	ld a, [hli]
	ld b, PLAY_AREA_BENCH_1
	push hl
	call LookForCardIDInPlayArea_Bank5
	jr nc, .next_2
	ld e, a
	push de
	call CountNumberOfEnergyCardsAttached
	pop de
	pop hl
	ld b, [hl]
	cp b
	jr nc, .set_carry
	inc hl
	jr Func_1585b

.next_1
	inc hl
	inc hl
	jr Func_1585b

.next_2
	pop hl
	inc hl
	jr Func_1585b

.no_carry
	or a
	ret

.set_carry
	ld a, e
	scf
	ret

; expects a $00-terminated list of 3-byte data with the following:
; - non-zero value
; - card ID
; - number of energy cards
; goes through the given list and if a card with a listed ID is found
; with less than the number of energy cards corresponding to its entry
; then have AI try to play an energy card from the hand to it
; unreferenced
Func_15886:
	push hl
	call CreateEnergyCardListFromHand
	pop hl
	ret c ; quit if no energy cards in hand

.loop_energy_cards
	ld a, [hli]
	or a
	ret z ; done
	ld a, [hli]
	ld b, PLAY_AREA_ARENA
	push hl
	call LookForCardIDInPlayArea_Bank5
	jr nc, .next ; skip if not found in Play Area
	ld e, a
	push de
	call CountNumberOfEnergyCardsAttached
	pop de
	pop hl
	cp [hl]
	inc hl
	jr nc, .loop_energy_cards
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a
	push hl
	call AITryToPlayEnergyCard
	pop hl
	ret c
	jr .loop_energy_cards
.next
	pop hl
	inc hl
	jr .loop_energy_cards

INCLUDE "engine/duel/ai/retreat.asm"

; copies an $ff-terminated list from hl to de.
; preserves bc
; input:
;	hl = address from which to start copying the data
;	de = where to copy the data
CopyListWithFFTerminatorFromHLToDE_Bank5:
	ld a, [hli]
	ld [de], a
	cp $ff
	ret z
	inc de
	jr CopyListWithFFTerminatorFromHLToDE_Bank5

INCLUDE "engine/duel/ai/hand_pokemon.asm"

; check if player's active Pokémon is Mr Mime
; if it isn't, set carry
; if it is, check if Pokémon at a
; can damage it, and if it can, set carry
; input:
;	a = location of Pokémon card
CheckDamageToMrMime:
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
CheckIfActiveCardCanKnockOut:
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfAnyAttackKnocksOutDefendingCard
	jr nc, .fail
	call CheckIfSelectedAttackIsUnusable
	jp c, .fail
	scf
	ret

.fail
	or a
	ret

; outputs carry if any of the active Pokémon attacks
; can be used and are not residual
CheckIfActivePokemonCanUseAnyNonResidualAttack:
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
; first atk
	ld [wSelectedAttack], a ; FIRST_ATTACK_OR_PKMN_POWER
	call CheckIfSelectedAttackIsUnusable
	jr c, .next_atk
	ld a, [wLoadedAttackCategory]
	and RESIDUAL
	jr z, .ok

.next_atk
; second atk
	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	jr c, .fail
	ld a, [wLoadedAttackCategory]
	and RESIDUAL
	jr z, .ok
.fail
	or a
	ret

.ok
	scf
	ret

; looks for energy card(s) in hand depending on
; what is needed for selected card, for both attacks
;	- if one basic energy is required, look for that energy;
;	- if one colorless is required, create a list at wDuelTempList
;	  of all energy cards;
;	- if two colorless are required, look for double colorless;
; return carry if successful in finding card
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
LookForEnergyNeededInHand:
	xor a ; FIRST_ATTACK_OR_PKMN_POWER
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
	ld a, SECOND_ATTACK
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
; what is needed for selected card and attack
;	- if one basic energy is required, look for that energy;
;	- if one colorless is required, create a list at wDuelTempList
;	  of all energy cards;
;	- if two colorless are required, look for double colorless;
; return carry if successful in finding card
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedAttack]         = selected attack to examine
LookForEnergyNeededForAttackInHand:
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
SortTempHandByIDList:
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
CheckEnergyFlagsNeededInList:
	ld e, a
	ld hl, wDuelTempList
.loop_cards
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
	jr nz, .loop_cards
	ld a, COLORLESS_F

; if energy card matches required energy, return carry
.check_energy
	ld d, e
	and e
	ld e, d
	jr z, .loop_cards
	scf
	ret
.no_carry
	or a
	ret

; returns in a the energy cost of both attacks from card index in a
; represented by energy flags
; i.e. each bit represents a different energy type cost
; if any colorless energy is required, all bits are set
; input:
;	a = card index
; output:
;	a = bits of each energy requirement
GetAttacksEnergyCostBits:
	call LoadCardDataToBuffer2_FromDeckIndex
	ld hl, wLoadedCard2Atk1EnergyCost
	call .GetEnergyCostBits
	ld b, a

	push bc
	ld hl, wLoadedCard2Atk2EnergyCost
	call .GetEnergyCostBits
	pop bc
	or b
	ret

; returns in a the energy cost of an attack in [hl]
; represented by energy flags
; i.e. each bit represents a different energy type cost
; if any colorless energy is required, all bits are set
; input:
;	[hl] = Loaded card attack energy cost
; output:
;	a = bits of each energy requirement
.GetEnergyCostBits:
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
CheckForEvolutionInList:
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
CheckForEvolutionInDeck:
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

INCLUDE "engine/duel/ai/energy.asm"

INCLUDE "engine/duel/ai/attacks.asm"

INCLUDE "engine/duel/ai/special_attacks.asm"

; checks in other Play Area for non-basic cards.
; afterwards, that card is checked for damage,
; and if the damage counters it has is greater than or equal
; to the max HP of the card stage below it,
; return carry and that card's Play Area location in a.
; output:
;	a = card location of Pokémon card, if found;
;	carry set if such a card is found.
LookForCardThatIsKnockedOutOnDevolution:
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
;	- arena card cannot potentially evolve
;	- arena card can use second attack
CheckIfArenaCardIsFullyPowered:
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

	ld a, [wLoadedCard1AIInfo]
	and HAS_EVOLUTION
	jr z, .check_second_attack
	ld a, d
	call CheckCardEvolutionInHandOrDeck
	jr c, .no_carry

.check_second_attack
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	push hl
	call CheckIfSelectedAttackIsUnusable
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
;	- card can use second attack
; Outputs the number of Pokémon in bench
; that meet these requirements in a
; and returns carry if at least one is found
CountNumberOfSetUpBenchPokemon:
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

	ld a, [wLoadedCard1AIInfo]
	and HAS_EVOLUTION
	jr z, .check_second_attack
	ld a, d
	push bc
	call CheckCardEvolutionInHandOrDeck
	pop bc
	jr c, .next

.check_second_attack
	ld a, c
	ldh [hTempPlayAreaLocation_ff9d], a
	; bug, there is an assumption that the card
	; has a second attack, but it may be the case
	; that it doesn't, which will return carry
	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	push bc
	push hl
	call CheckIfSelectedAttackIsUnusable
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
AISelectSpecialAttackParameters:
	ld a, [wSelectedAttack]
	push af
	call .SelectAttackParameters
	pop bc
	ld a, b
	ld [wSelectedAttack], a
	ret

.SelectAttackParameters:
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp MEW_LV23
	jr z, .DevolutionBeam
	cp MEWTWO_ALT_LV60
	jr z, .EnergyAbsorption
	cp MEWTWO_LV60
	jr z, .EnergyAbsorption
	cp EXEGGUTOR
	jr z, .Teleport
	cp ELECTRODE_LV35
	jr z, .EnergySpike
	; fallthrough

.no_carry
	or a
	ret

.DevolutionBeam
; in case selected attack is Devolution Beam
; store in hTempPlayAreaLocation_ffa1
; the location of card to select to devolve
	ld a, [wSelectedAttack]
	or a
	jp z, .no_carry ; can be jr

	ld a, $01 ; always target the Player's play area
	ldh [hTemp_ffa0], a
	call LookForCardThatIsKnockedOutOnDevolution
	ldh [hTempPlayAreaLocation_ffa1], a

.set_carry_1
	scf
	ret

.EnergyAbsorption
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
	call LookForCardIDInLocation_Bank5
	ldh [hTemp_ffa0], a
	farcall CreateEnergyCardListFromDiscardPile_AllEnergy

; find any energy card different from
; the one found by LookForCardIDInLocation_Bank5.
; since using this attack requires a Psychic energy card,
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

.set_carry_2
	scf
	ret

.Teleport
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

.EnergySpike
; in case selected attack is Energy Spike
; decide basic energy card to fetch from Deck.
	ld a, [wSelectedAttack]
	or a
	jp z, .no_carry  ; can be jr

; if none were found in Deck, return carry...
	ld a, CARD_LOCATION_DECK
	ld e, LIGHTNING_ENERGY

; if none were found in Deck, return carry...
	call LookForCardIDInLocation_Bank5
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
; energy required for the attack index in wSelectedAttack
; or has exactly the same amount of energy needed
; input:
;	[hTempPlayAreaLocation_ff9d] = play area location
;	[wSelectedAttack]         = attack index to check
; output:
;	a = number of extra energy cards attached
CheckIfNoSurplusEnergyForAttack:
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wSelectedAttack]
	ld e, a
	call CopyAttackDataAndDamage_FromDeckIndex
	ld hl, wLoadedAttackName
	ld a, [hli]
	or [hl]
	jr z, .not_attack
	ld a, [wLoadedAttackCategory]
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
	ld [wTempLoadedAttackEnergyCost], a
	ld [wTempLoadedAttackEnergyNeededAmount], a
	ld [wTempLoadedAttackEnergyNeededType], a
	ld hl, wAttachedEnergies
	ld de, wLoadedAttackEnergyCost
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
	ld hl, wTempLoadedAttackEnergyCost
	ld a, [wTotalAttachedEnergies]
	sub [hl]
	sub b
	ret c ; return if not enough energy

	or a
	ret nz ; return if surplus energy

	; exactly the amount of energy needed
	scf
	ret

; takes as input the energy cost of an attack for a
; particular energy, stored in the lower nibble of a
; if the attack costs some amount of this energy, the lower nibble of a != 0,
; and this amount is stored in wTempLoadedAttackEnergyCost
; also adds the amount of energy still needed
; to wTempLoadedAttackEnergyNeededAmount
; input:
;	a    = this energy cost of attack (lower nibble)
;	[hl] = attached energy
; output:
;	carry set if not enough of this energy type attached
CalculateParticularAttachedEnergyNeeded:
	and %00001111
	jr nz, .check
.done
	inc hl
	inc b
	ret

.check
	ld [wTempLoadedAttackEnergyCost], a
	sub [hl]
	jr z, .done
	jr nc, .done
	push bc
	ld a, [wTempLoadedAttackEnergyCost]
	ld b, a
	ld a, [hl]
	sub b
	pop bc
	ld [wTempLoadedAttackEnergyNeededAmount], a
	jr .done

; return carry if there is a card that
; can evolve a Pokémon in hand or deck.
; input:
;	a = deck index of card to check;
; output:
;	a = deck index of evolution in hand, if found;
;	carry set if there's a card in hand that can evolve.
CheckCardEvolutionInHandOrDeck:
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

INCLUDE "engine/duel/ai/boss_deck_set_up.asm"

; returns carry if Pokemon at PLAY_AREA* in a
; can damage defending Pokémon with any of its attacks
; input:
;	a = location of card to check
CheckIfCanDamageDefendingPokemon:
	ldh [hTempPlayAreaLocation_ff9d], a
	xor a ; FIRST_ATTACK_OR_PKMN_POWER
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	jr c, .second_attack
	xor a ; FIRST_ATTACK_OR_PKMN_POWER
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr nz, .set_carry

.second_attack
	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	call CheckIfSelectedAttackIsUnusable
	jr c, .no_carry
	ld a, SECOND_ATTACK
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
; card at hTempPlayAreaLocation_ff9d with any of its attacks
; and if so, stores the damage to wAIFirstAttackDamage and wAISecondAttackDamage
; sets carry if any on the attacks knocks out
; also outputs the largest damage dealt in a
; input:
;	[hTempPlayAreaLocation_ff9d] = location of card to check
; output:
;	a = largest damage of both attacks
;	carry set if can knock out
CheckIfDefendingPokemonCanKnockOut:
	xor a
	ld [wAIFirstAttackDamage], a
	ld [wAISecondAttackDamage], a

	; first attack
	call .CheckAttack
	jr nc, .second_attack
	ld a, [wDamage]
	ld [wAIFirstAttackDamage], a
.second_attack
	ld a, SECOND_ATTACK
	call .CheckAttack
	jr nc, .return_if_neither_kos
	ld a, [wDamage]
	ld [wAISecondAttackDamage], a
	jr .compare

.return_if_neither_kos
	ld a, [wAIFirstAttackDamage]
	or a
	ret z

.compare
	ld a, [wAIFirstAttackDamage]
	ld b, a
	ld a, [wAISecondAttackDamage]
	cp b
	jr nc, .set_carry ; wAIFirstAttackDamage < wAISecondAttackDamage
	ld a, b
.set_carry
	scf
	ret

; return carry if defending Pokémon can knock out
; card at hTempPlayAreaLocation_ff9d
; input:
;	a = attack index
;	[hTempPlayAreaLocation_ff9d] = location of card to check
.CheckAttack:
	ld [wSelectedAttack], a
	ldh a, [hTempPlayAreaLocation_ff9d]
	push af
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call SwapTurn
	call CheckIfSelectedAttackIsUnusable
	call SwapTurn
	pop bc
	ld a, b
	ldh [hTempPlayAreaLocation_ff9d], a
	jr c, .done

; player's active Pokémon can use attack
	ld a, [wSelectedAttack]
	call EstimateDamage_FromDefendingPokemon
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr z, .can_ko
	ret

.can_ko
	scf
	ret

.done
	or a
	ret

; sets carry if Opponent's deck ID
; is between LEGENDARY_MOLTRES_DECK_ID (inclusive)
; and MUSCLES_FOR_BRAINS_DECK_ID (exclusive)
; these are the decks for Grandmaster/Club Master/Ronald
CheckIfOpponentHasBossDeckID:
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
; and if hasn't received legendary cards yet
CheckIfNotABossDeckID:
	call EnableSRAM
	ld a, [sReceivedLegendaryCards]
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
AIChooseRandomlyNotToDoAction:
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
; half health and can use its second attack
; input:
;	a = card ID to check for
; output:
;	carry set if the above requirements are met
CheckForBenchIDAtHalfHPAndCanUseSecondAttack:
	ld [wSamePokemonCardID], a
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
	ld hl, wSamePokemonCardID
	cp [hl]
	jr nz, .loop

	ld a, c
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, SECOND_ATTACK
	ld [wSelectedAttack], a
	push bc
	call CheckIfSelectedAttackIsUnusable
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
RaiseAIScoreToAllMatchingIDsInBench:
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

; used by AI to determine which Pokémon it should favor in the bench
; in order to attach an energy card from the hand, in case there are repeats
; if there is repeated Pokémon in bench, then increase wPlayAreaEnergyAIScore
; from the Pokémon with less damage and more energy cards,
; and decrease from all others
HandleAIEnergyScoringForRepeatedBenchPokemon:
	; clears wSamePokemonEnergyScoreHandled
	ld a, MAX_PLAY_AREA_POKEMON
	ld hl, wSamePokemonEnergyScoreHandled
	call ClearMemory_Bank5

	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	ld e, 0
.loop_bench
	; clears wSamePokemonEnergyScore
	push hl
	ld a, MAX_PLAY_AREA_POKEMON
	ld hl, wSamePokemonEnergyScore
	call ClearMemory_Bank5
	pop hl

	inc e
	ld a, [hli]
	cp $ff
	ret z ; done looping bench

	ld [wSamePokemonCardID], a ; deck index

; checks wSamePokemonEnergyScoreHandled of location in e
; if != 0, go to next in play area
	push de
	push hl
	ld d, $00
	ld hl, wSamePokemonEnergyScoreHandled
	add hl, de
	ld a, [hl]
	or a
	pop hl
	pop de
	jr nz, .loop_bench ; already handled

	; store this card's ID
	push de
	ld a, [wSamePokemonCardID]
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wSamePokemonCardID], a
	pop de

	; calculate score of this Pokémon
	; and all cards with same ID
	push hl
	push de
	call .CalculateScore
.loop_search_same_card_id
	inc e
	ld a, [hli]
	cp $ff
	jr z, .tally_repeated_pokemon
	push de
	call GetCardIDFromDeckIndex
	ld a, [wSamePokemonCardID]
	cp e
	pop de
	jr nz, .loop_search_same_card_id
	call .CalculateScore
	jr .loop_search_same_card_id

.tally_repeated_pokemon
	call .CountNumberOfCardsWithSameID
	jr c, .next

	; has repeated card IDs in bench
	; find which one has highest score
	lb bc, 0, 0
	ld hl, wSamePokemonEnergyScore + PLAY_AREA_BENCH_5
	ld d, PLAY_AREA_BENCH_5 + 1
.loop_2
	dec d
	jr z, .got_highest_score
	ld a, [hld]
	cp b
	jr c, .loop_2
	ld b, a ; highest score
	ld c, d ; play area location
	jr .loop_2

; c = play area location of highest score
; increase wPlayAreaEnergyAIScore score for card with highest ID
; decrease wPlayAreaEnergyAIScore score for all cards with same ID
.got_highest_score
	ld hl, wPlayAreaEnergyAIScore
	ld de, wSamePokemonEnergyScore
	ld b, PLAY_AREA_ARENA
.loop_3
	ld a, c
	cp b
	jr z, .card_with_highest
	ld a, [de] ; score
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
	jp .loop_bench

; loads wSamePokemonEnergyScore + play area location in e
; with energy  * 2 + $80 - floor(dam / 10)
; loads wSamePokemonEnergyScoreHandled + play area location in e
; with $01
.CalculateScore:
	push hl
	push de
	call GetCardDamageAndMaxHP
	call ConvertHPToDamageCounters_Bank5
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
	ld hl, wSamePokemonEnergyScore
	add hl, de
	ld [hl], a
	ld hl, wSamePokemonEnergyScoreHandled
	add hl, de
	ld [hl], $01
	pop de
	pop hl
	ret

; counts how many play area locations in wSamePokemonEnergyScore
; are != 0, and outputs result in a
; also returns carry if result is < 2
.CountNumberOfCardsWithSameID:
	ld hl, wSamePokemonEnergyScore
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
HandleLegendaryArticunoEnergyScoring:
	ld a, [wOpponentDeckID]
	cp LEGENDARY_ARTICUNO_DECK_ID
	jr z, .articuno_deck
	ret
.articuno_deck
	call ScoreLegendaryArticunoCards
	ret
