PointerTable_14000: ; 14000 (05:4000)
	dw $47bd ; SAMS_PRACTICE_DECK
	dw PointerTable_14668 ; PRACTICE_PLAYER_DECK
	dw PointerTable_14668 ; SAMS_NORMAL_DECK
	dw PointerTable_14668 ; CHARMANDER_AND_FRIENDS_DECK
	dw PointerTable_14668 ; CHARMANDER_EXTRA_DECK
	dw PointerTable_14668 ; SQUIRTLE_AND_FRIENDS_DECK
	dw PointerTable_14668 ; SQUIRTLE_EXTRA_DECK
	dw PointerTable_14668 ; BULBASAUR_AND_FRIENDS_DECK
	dw PointerTable_14668 ; BULBASAUR_EXTRA_DECK
	dw PointerTable_14668 ; LIGHTNING_AND_FIRE_DECK
	dw PointerTable_14668 ; WATER_AND_FIGHTING_DECK
	dw PointerTable_14668 ; GRASS_AND_PSYCHIC_DECK
	dw $49e8 ; LEGENDARY_MOLTRES_DECK
	dw $4b0f ; LEGENDARY_ZAPDOS_DECK
	dw $4c0b ; LEGENDARY_ARTICUNO_DECK
	dw $4d60 ; LEGENDARY_DRAGONITE_DECK
	dw $4e89 ; FIRST_STRIKE_DECK
	dw $4f0e ; ROCK_CRUSHER_DECK
	dw $4f8f ; GO_GO_RAIN_DANCE_DECK
	dw $5019 ; ZAPPING_SELFDESTRUCT_DECK
	dw $509b ; FLOWER_POWER_DECK
	dw $5122 ; STRANGE_PSYSHOCK_DECK
	dw $51ad ; WONDERS_OF_SCIENCE_DECK
	dw $5232 ; FIRE_CHARGE_DECK
	dw $52bd ; IM_RONALD_DECK
	dw $534b ; POWERFUL_RONALD_DECK
	dw $53e8 ; INVINCIBLE_RONALD_DECK
	dw $546f ; LEGENDARY_RONALD_DECK
	dw $48dc ; MUSCLES_FOR_BRAINS_DECK
	dw PointerTable_14668 ; HEATED_BATTLE_DECK
	dw PointerTable_14668 ; LOVE_TO_BATTLE_DECK
	dw PointerTable_14668 ; EXCAVATION_DECK
	dw PointerTable_14668 ; BLISTERING_POKEMON_DECK
	dw PointerTable_14668 ; HARD_POKEMON_DECK
	dw PointerTable_14668 ; WATERFRONT_POKEMON_DECK
	dw PointerTable_14668 ; LONELY_FRIENDS_DECK
	dw PointerTable_14668 ; SOUND_OF_THE_WAVES_DECK
	dw PointerTable_14668 ; PIKACHU_DECK
	dw PointerTable_14668 ; BOOM_BOOM_SELFDESTRUCT_DECK
	dw PointerTable_14668 ; POWER_GENERATOR_DECK
	dw PointerTable_14668 ; ETCETERA_DECK
	dw PointerTable_14668 ; FLOWER_GARDEN_DECK
	dw PointerTable_14668 ; KALEIDOSCOPE_DECK
	dw PointerTable_14668 ; GHOST_DECK
	dw PointerTable_14668 ; NAP_TIME_DECK
	dw PointerTable_14668 ; STRANGE_POWER_DECK
	dw PointerTable_14668 ; FLYIN_POKEMON_DECK
	dw PointerTable_14668 ; LOVELY_NIDORAN_DECK
	dw PointerTable_14668 ; POISON_DECK
	dw PointerTable_14668 ; ANGER_DECK
	dw PointerTable_14668 ; FLAMETHROWER_DECK
	dw PointerTable_14668 ; RESHUFFLE_DECK
	dw $48dc ; IMAKUNI_DECK
; 1406a

PointerTable_1406a: ; 1406a (5:406a)
	dw $406c
	dw Func_14078
	dw Func_14078
	dw Func_1409e
	dw $40a2
	dw $40a6
	dw $40aa

Func_14078: ; 14078 (5:4078)
	call AIDecidePlayPokemonCard
	call AIDecideWhetherToRetreat
	jr nc, .asm_14091
	call AIDecideBenchPokemonToSwitchTo
	call AIChooseEnergyToDiscardForRetreatCost
	call AIDecideWhetherToRetreat
	jr nc, .asm_14091
	call AIDecideBenchPokemonToSwitchTo
	call AIChooseEnergyToDiscardForRetreatCost
.asm_14091
	call AIDecidePlayEnergyCard
	call Func_169f8
	ret c
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret
; 0x1409e

Func_1409e: ; 1409e (5:409e)
	INCROM $1409e, $140ae

; returns carry if damage dealt from any of
; a card's moves KOs defending Pokémon
; outputs index of the move that KOs
; input:
; 	[hTempPlayAreaLocation_ff9d] = location of attacking card to consider
; output:
; 	[wSelectedMoveIndex] = move index that KOs
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
; 0x140c5

	INCROM $140c5, $140df

; checks AI scores for all benched Pokémon
; returns the location of the card with highest score
; in hTempPlayAreaLocation_ff9d
FindHighestBenchScore: ; 140df (5:40df)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld b, a
	ld c, 0
	ld e, c
	ld d, c
	ld hl, wBenchAIScore + 1
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
; 0x140fe

; adds a to wAIScore
; if there's overflow, it's capped at $ff
; output:
; 	a = a + wAIScore (capped at $ff)
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
; 0x1410a

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
; 0x1411d

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
; 0x14145

Func_14145: ; 14145 (5:4145)
	INCROM $14145, $14184

; return carry if any of the following is satisfied:
;	- deck index in a corresponds to a double colorless energy card;
;	- card type in wTempCardType is double colorless energy;
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
; 0x141da

Func_141da: ; 141da (5:41da)
	INCROM $141da, $14226

Func_14226: ; 14226 (5:4226)
	call CreateHandCardList
	ld hl, wDuelTempList
.check_for_next_card
	ld a, [hli]
	ldh [hTempCardIndex_ff98], a
	cp $ff
	ret z

	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .check_for_next_card
	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .check_for_next_card
	push hl
	ldh a, [hTempCardIndex_ff98]
	call PutHandPokemonCardInPlayArea
	pop hl
	jr .check_for_next_card
; 0x1424b

; returns carry if Pokémon at hTempPlayAreaLocation_ff9d
; can't use a move or if that selected move doesn't have enough energy
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedMoveIndex]         = selected move to examine
CheckIfCardCanUseSelectedMove: ; 1424b (5:424b)
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
	ld a, [wSelectedMoveIndex]
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
	ld a, $0d ; $00001101
	call CheckLoadedMoveFlag
	ret
; 0x14279

; load selected move from Pokémon in hTempPlayAreaLocation_ff9d
; and checks if there is enough energy to execute the selected move
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedMoveIndex]         = selected move to examine
; output:
;	b = colorless energy still needed
;	c = basic energy still needed
;	e = output of ConvertColorToEnergyCardID, or $0 if not a move
;	carry set if no move 
;	       OR if it's a Pokémon Power
;	       OR if not enough energy for move
CheckEnergyNeededForAttack: ; 14279 (5:4279)
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wSelectedMoveIndex]
	ld e, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld hl, wLoadedMoveName
	ld a, [hli]
	or [hl]
	jr z, .no_move
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr nz, .is_move
.no_move
	lb bc, 0, 0
	ld e, c
	scf
	ret
	
.is_move
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
; 0x142f4

; takes as input the energy cost of a move for a 
; particular energy, stored in the lower nibble of a
; if the move costs some amount of this energy, the lower nibble of a != 0,
; and this amount is stored in wTempLoadedMoveEnergyCost
; sets carry flag if not enough energy of this type attached
; input:
; 	a    = this energy cost of move (lower nibble)
; 	[hl] = attached energy
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
; 0x1430f

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
; 0x1438c

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
; 0x143bf

; looks for card ID in hand and
; sets carry if a card wasn't found
; as opposed to LookForCardIDInHandList
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
; 0x143e5

; stores in wDamage, wAIMinDamage and wAIMaxDamage the calculated damage
; done to the defending Pokémon by a given card and move
; input:
;	a = move index to take into account
;	[hTempPlayAreaLocation_ff9d] = location of attacking card to consider
EstimateDamage_VersusDefendingCard: ; 143e5 (5:43e5)
	ld [wSelectedMoveIndex], a
	ld e, a
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr nz, .is_move

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

.is_move
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
	; skips the weak/res checks if bit 7 is set
	; I guess to avoid overflowing?
	; should probably just have skipped weakness test instead?
	bit 7, d
	res 7, d
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
; 0x1450b

; stores in wDamage, wAIMinDamage and wAIMaxDamage the calculated damage
; done to the Pokémon at hTempPlayAreaLocation_ff9d
; by the defending Pokémon, using the move index at a
; input:
;	a = move index
;	[hTempPlayAreaLocation_ff9d] = location of card to calculate
;	                               damage as the receiver
EstimateDamage_FromDefendingPokemon: ; 1450b (5:450b)
	call SwapTurn
	ld [wSelectedMoveIndex], a
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	call SwapTurn
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr nz, .is_move

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

.is_move
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
; 	[wAIMinDamage] = base damage
; 	[wAIMaxDamage] = base damage
; 	[wDamage]      = base damage
;	[hTempPlayAreaLocation_ff9d] = location of card to calculate
;								 damage as the receiver
CalculateDamage_FromDefendingPokemon: ; 1458c (5:458c)
	ld hl, wAIMinDamage
	call _CalculateDamage_FromDefendingPokemon
	ld hl, wAIMaxDamage
	call _CalculateDamage_FromDefendingPokemon
	ld hl, wDamage
;	fallthrough

_CalculateDamage_FromDefendingPokemon: ; 1459b (5:459b)
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
	bit 7, d
	res 7, d
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
; 0x14663

Func_14663: ; 14663 (5:4663)
	farcall Func_200e5
	ret

; GENERAL DECK POINTER LIST - Not sure on all of these.
; This is an example of an AI pointer table, there's one for each AI type.
PointerTable_14668: ; 14668 (05:4668)
	dw Func_14674 ; not used
	dw Func_14674 ; general AI for battles
	dw Func_14678 ; basic pokemon placement / cheater shuffling on better AI
	dw Func_1467f
	dw Func_14683
	dw Func_14687

; when battle AI gets called
Func_14674: ; 14674 (5:4674)
	call Func_1468b
	ret

Func_14678: ; 14678 (5:4678)
	call Func_15636
	call $4226
	ret

Func_1467f: ; 1467f (5:467f)
	call $5b72
	ret

Func_14683: ; 14683 (5:4683)
	call $5b72
	ret

Func_14687: ; 14687 (5:4687)
	call $41e5
	ret

; AI for general decks i think
Func_1468b: ; 1468b (5:468b)
	call Func_15649
	ld a, $1
	call Func_14663
	farcall $8, $67d3
	jp nc, $4776
	farcall $8, $6790
	farcall $8, $66a3
	farcall $8, $637f
	ret c
	farcall $8, $662d
	ld a, $2
	call Func_14663
	ld a, $3
	call Func_14663
	ld a, $4
	call Func_14663
	call $5eae
	ret c
	ld a, $5
	call Func_14663
	ld a, $6
	call Func_14663
	ld a, $7
	call Func_14663
	ld a, $8
	call Func_14663
	call $4786
	ld a, $a
	call Func_14663
	ld a, $b
	call Func_14663
	ld a, $c
	call Func_14663
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .asm_146ed
	call $64e8

.asm_146ed
	call $5eae
	farcall $8, $66a3
	farcall $8, $637f
	ret c
	farcall $8, $6790
	ld a, $d
	farcall $8, $619b
	ld a, $d
	call Func_14663
	ld a, $f
	call Func_14663
	ld a, [wce20]
	and $4
	jr z, .asm_14776
	ld a, $1
	call Func_14663
	ld a, $2
	call Func_14663
	ld a, $3
	call Func_14663
	ld a, $4
	call Func_14663
	call $5eae
	ret c
	ld a, $5
	call Func_14663
	ld a, $6
	call Func_14663
	ld a, $7
	call Func_14663
	ld a, $8
	call Func_14663
	call $4786
	ld a, $a
	call Func_14663
	ld a, $b
	call Func_14663
	ld a, $c
	call Func_14663
	ld a, [wAlreadyPlayedEnergy]
	or a
	jr nz, .asm_1475b
	call $64e8

.asm_1475b
	call $5eae
	farcall $8, $66a3
	farcall $8, $637f
	ret c
	farcall $8, $6790
	ld a, $d
	farcall $8, $619b
	ld a, $d
	call Func_14663

.asm_14776
	ld a, $e
	farcall $8, $619b
	call $69f8
	ret c
	ld a, $5
	bank1call AIMakeDecision
	ret
; 0x14786

Func_14786: ; 14786 (5:4786)
	INCROM $14786, $14c91

; this routine handles how Legendary Articuno
; prioritises playing energy cards to each Pokémon.
; first, it makes sure that all Lapras have at least
; 3 energy cards before moving on to Articuno,
; and then to Dewgong and Seel
ScoreLegendaryArticunoCards: ; 14c91 (5:4c91)
	call SwapTurn
	call CountPrizes
	call SwapTurn
	cp 3
	ret c

; player prizes >= 3
; if Lapras has more than half HP and
; can use second move, check next for Articuno
; otherwise, check if Articuno or Dewgong
; have more than half HP and can use second move
; and if so, the next Pokémon to check is Lapras
	ld a, LAPRAS
	call CheckForBenchIDAtHalfHPAndCanUseSecondMove
	jr c, .articuno
	ld a, ARTICUNO1
	call CheckForBenchIDAtHalfHPAndCanUseSecondMove
	jr c, .lapras
	ld a, DEWGONG
	call CheckForBenchIDAtHalfHPAndCanUseSecondMove
	jr c, .lapras
	jr .articuno

; the following routines check for certain card IDs in bench
; and call RaiseAIScoreToAllMatchingIDsInBench if these are found.
; for Lapras, an additional check is made to its
; attached energy count, which skips calling the routine
; if this count is >= 3
.lapras
	ld a, LAPRAS
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInBench
	jr nc, .articuno
	ld e, a
	call CountNumberOfEnergyCardsAttached
	cp 3
	jr nc, .articuno
	ld a, LAPRAS
	call RaiseAIScoreToAllMatchingIDsInBench
	ret

.articuno
	ld a, ARTICUNO1
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInBench
	jr nc, .dewgong
	ld a, ARTICUNO1
	call RaiseAIScoreToAllMatchingIDsInBench
	ret

.dewgong
	ld a, DEWGONG
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInBench
	jr nc, .seel
	ld a, DEWGONG
	call RaiseAIScoreToAllMatchingIDsInBench
	ret

.seel
	ld a, SEEL
	ld b, PLAY_AREA_BENCH_1
	call LookForCardIDInBench
	ret nc
	ld a, SEEL
	call RaiseAIScoreToAllMatchingIDsInBench
	ret
; 0x14cf7

Func_14cf7: ; 14cf7 (5:4cf7)
	INCROM $14cf7, $1514f

; these seem to be lists of card IDs
; for the AI to look up in their hand
Data_1514f: ; 1514f (5:514f)
	db KANGASKHAN
	db CHANSEY
	db SNORLAX
	db MR_MIME
	db ABRA
	db $00

	db ABRA
	db MR_MIME
	db KANGASKHAN
	db SNORLAX
	db CHANSEY
	db $00

	INCROM $1515b, $155d2

; return carry if card ID loaded in a is found in hand
; and outputs in a the deck index of that card
; as opposed to LookForCardIDInHand, this function
; creates a list in wDuelTempList
; input:
;	a = card ID
; output:
; 	a = card deck index, if found
;	carry set if found
LookForCardIDInHandList: ; 155d2 (5:55d2)
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
; 0x155ef

; returns carry if card ID in a
; is found in bench, starting with
; location in b
; input:
;	a = card ID
;	b = PLAY_AREA_* to start with
; ouput:
;	a = PLAY_AREA_* of found card
;	carry set if found
LookForCardIDInBench: ; 155ef (5:55ef)
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
; 0x15612

Func_15612: ; 15612 (5:5612)
	INCROM $15612, $15636

Func_15636: ; 15636 (5:5636)
	ld a, $10
	ld hl, wcda5
	call ZeroData
	ld a, $5
	ld [wcda6], a
	ld a, $ff
	ld [wcda5], a
	ret

Func_15649: ; 15649 (5:5649)
	ld a, [wcda6]
	inc a
	ld [wcda6], a
	xor a
	ld [wce20], a
	ld [wcddb], a
	ld [wcddc], a
	ld [wce03], a
	ld a, [wPlayerAttackingMoveIndex]
	cp $ff
	jr z, .asm_156b1
	or a
	jr z, .asm_156b1
	ld a, [wPlayerAttackingCardIndex]
	cp $ff
	jr z, .asm_156b1
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MEWTWO1 ; I believe this is a check for Mewtwo1's Barrier move
	jr nz, .asm_156b1
	ld a, [wcda7]
	bit 7, a
	jr nz, .asm_156aa
	inc a
	ld [wcda7], a
	cp $3
	jr c, .asm_156c2
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MEWTWO1
	jr nz, .asm_156a4
	farcall $8, $67a9
	jr nc, .asm_156aa

.asm_156a4
	xor a
	ld [wcda7], a
	jr .asm_156c2

.asm_156aa
	ld a, $80
	ld [wcda7], a
	jr .asm_156c2

.asm_156b1
	ld a, [wcda7]
	bit 7, a
	jr z, .asm_156be
	inc a
	ld [wcda7], a
	jr .asm_156c2

.asm_156be
	xor a
	ld [wcda7], a

.asm_156c2
	ret
; 0x156c3

	INCROM $156c3, $1575e

; zeroes a bytes starting at hl
ZeroData: ; 1575e (5:575e)
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
; 0x1576b

; returns in a the tens digit of value in a
CalculateTensDigit: ; 1576b (5:576b)
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
; 0x15778

; returns in a the result of
; dividing b by a, rounded down
; input:
; 	a = divisor
; 	b = dividend
CalculateBDividedByA: ; 15778 (5:5778)
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
; 0x15787

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
; 0x157a3

Func_157a3: ; 157a3 (5:57a3)
	INCROM $157a3, $158b2

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
	ld a, [$cdb4]
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
	call CheckIfCardCanUseSelectedMove
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
	call CheckIfCardCanUseSelectedMove
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
	call CheckIfCardCanUseSelectedMove
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
	call CheckIfBenchCardsAreAtHalfHPCanEvolveAndUseSecondMove
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
; 0x15b54

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
; 0x15b72

; calculates AI score for bench Pokémon
; returns in hTempPlayAreaLocation_ff9d the
; Play Area location of best card to switch to
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
	call CheckIfCardCanUseSelectedMove
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
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
	call nc, .calculate_damage
	ld a, $01
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
	call nc, .calculate_damage
	jr .check_energy_card

; adds to AI score depending on amount of damage
; it can inflict to the defending Pokémon
; AI score += floor(Damage / 10) + 1
.calculate_damage
	ld a, [wSelectedMoveIndex]
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	call CalculateTensDigit
	inc a
	call AddToAIScore
	ret

; if an energy card that is needed is found in hand
; calculate damage of the move and raise AI score
; AI score += floor(Damage / 20)
.check_energy_card
	call LookForEnergyNeededInHand
	jr nc, .check_attached_energy
	ld a, [wSelectedMoveIndex]
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	call CalculateTensDigit
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
	call CalculateBDividedByA
	call CalculateTensDigit
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
	jr nz, .asm_15d0c
.lower_score_2
	ld a, 10
	call SubFromAIScore

.asm_15d0c
	ld b, a
	ld a, [$cdb1]
	or a
	jr z, .store_score
	ld h, a
	ld a, [$cdb0]
	ld l, a

.loop
	ld a, [hli]
	or a
	jr z, .store_score
	cp b
	jr nz, .asm_15d32
	ld a, [hl]
	cp $80
	jr c, .asm_15d2b
	sub $80
	call AddToAIScore
	jr .asm_15d32
.asm_15d2b
	ld c, a
	ld a, $80
	sub c
	call SubFromAIScore
.asm_15d32
	inc hl
	jr .loop

.store_score
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld c, a
	ld b, $00
	ld hl, wBenchAIScore
	add hl, bc
	ld a, [wAIScore]
	ld [hl], a
	pop bc
	inc c
	dec b
	jp nz, .next_bench

; done
	xor a
	ld [$cdb4], a
	jp FindHighestBenchScore
; 0x15d4f

; handles AI action of retreating Arena Pokémon
; and chooses which energy cards to discard
; if card can't discard, return carry
AIChooseEnergyToDiscardForRetreatCost: ; 15d4f (5:5d4f)
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
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, OPPACTION_EXECUTE_PKMN_POWER_EFFECT
	bank1call AIMakeDecision
	ld a, OPPACTION_DUEL_MAIN_SCENE
	bank1call AIMakeDecision
	or a
	ret
; 0x15ea6

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

; store this Play Area location in wCurCardPlayAreaLocation
; and initialize the AI score
	ld a, b
	ld [wCurCardPlayAreaLocation], a
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, 128
	ld [wAIScore], a
	call Func_16120

; check if the card can use any moves
; and if any of those moves can KO
	xor a
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
	jr nc, .can_attack
	ld a, $01
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
	jr c, .cant_attack_or_ko
.can_attack
	ld a, $01
	ld [wCurCardCanAttack], a
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .check_evolution_attacks
	call CheckIfCardCanUseSelectedMove
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
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
	jr nc, .evolution_can_attack
	ld a, $01
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
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
	ld a, [wCurCardPlayAreaLocation]
	or a
	jr nz, .check_defending_can_ko_evolution
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .evolution_cant_ko
	call CheckIfCardCanUseSelectedMove
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
	ld a, [wCurCardPlayAreaLocation]
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
	ld a, [wCurCardPlayAreaLocation]
	call CheckDamageToMrMime
	jr c, .check_defending_can_ko
	ld a, 20
	call SubFromAIScore

; if defending Pokémon can KO current card, raise AI score
.check_defending_can_ko
	ld a, [wCurCardPlayAreaLocation]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	ld a, [wCurCardPlayAreaLocation]
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
	ld a, [wCurCardPlayAreaLocation]
	ld e, a
	call GetCardDamage
	or a
	jr z, .check_mysterious_fossil
	srl a
	srl a
	call CalculateTensDigit
	call SubFromAIScore

; if is Mysterious Fossil or 
; wLoadedCard1Unknown2 is set to $02,
; raise AI score
.check_mysterious_fossil
	ld a, [wCurCardPlayAreaLocation]
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
	ld a, [wCurCardPlayAreaLocation]
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
	farcall CountEnergyCardsInHand
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
	call GetCardDamage
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
	call GetCardDamage
	cp 50
	jr c, .lower_score
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	cp 3
	jr c, .lower_score
	jr .check_muk
; 0x161d5

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
; 0x16270

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
; 0x1628f

; returns carry if arena card
; can knock out defending Pokémon
CheckIfActiveCardCanKnockOut: ; 1628f (5:628f)
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .fail
	call CheckIfCardCanUseSelectedMove
	jp c, .fail
	scf
	ret
	
.fail
	or a
	ret
; 0x162a1

; outputs carry if any of the active Pokémon attacks
; can be used and are not residual
CheckIfActivePokemonCanUseAnyNonResidualMove: ; 162a1 (5:62a1)
	xor a ; active card
	ldh [hTempPlayAreaLocation_ff9d], a
; first move
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
	jr c, .next_move
	ld a, [wLoadedMoveCategory]
	and RESIDUAL
	jr z, .ok

.next_move
; second move
	ld a, $01
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
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
; 0x162c8

; looks for energy card(s) in hand depending on
; what is needed for selected card, for both moves
; 	- if one basic energy is required, look for that energy;
;	- if one colorless is required, create a list at wDuelTempList
;	  of all energy cards;
;	- if two colorless are required, look for double colorless;
; return carry if successful in finding card
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
LookForEnergyNeededInHand: ; 162c8 (5:62c8)
	xor a ; first move
	ld [wSelectedMoveIndex], a
	call CheckEnergyNeededForAttack
	ld a, b
	add c
	cp 1
	jr z, .one_energy
	cp 2
	jr nz, .second_move
	ld a, c
	cp 2
	jr z, .two_colorless

.second_move
	ld a, $01 ; second move
	ld [wSelectedMoveIndex], a
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
	call LookForCardIDInHandList
	ret c
	jr .no_carry

.one_colorless
	call CreateEnergyCardListFromHand
	jr c, .no_carry
	scf
	ret

.two_colorless
	ld a, DOUBLE_COLORLESS_ENERGY
	call LookForCardIDInHandList
	ret c
	jr .no_carry
; 0x16311

; looks for energy card(s) in hand depending on
; what is needed for selected card and move
; 	- if one basic energy is required, look for that energy;
;	- if one colorless is required, create a list at wDuelTempList
;	  of all energy cards;
;	- if two colorless are required, look for double colorless;
; return carry if successful in finding card
; input:
;	[hTempPlayAreaLocation_ff9d] = location of Pokémon card
;	[wSelectedMoveIndex]         = selected move to examine
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
	call LookForCardIDInHandList
	ret c
	jr .done

.one_colorless
	call CreateEnergyCardListFromHand
	jr c, .done
	scf
	ret

.two_colorless
	ld a, DOUBLE_COLORLESS_ENERGY
	call LookForCardIDInHandList
	ret c
	jr .done
; 0x1633f

; goes through $00 terminated list pointed 
; by wcdae and compares it to each card in hand.
; Sorts the hand in wDuelTempList so that the found card IDs
; are in the same order as the list pointed by de.
SortTempHandByIDList: ; 1633f (5:633f)
	ld a, [wcdae+1]
	or a
	ret z

; start going down the ID list
	ld d, a
	ld a, [wcdae]
	ld e, a
	ld c, 0
.next_list_id
; get this item's ID
; if $00, list has ended
	ld a, [de]
	or a
	ret z
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
	jr z, .next_list_id
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
; 0x1637b

; looks for energy card(s) in list at wDuelTempList
; depending on energy flags set in a
; return carry if successful in finding card
; input:
; 	a = energy flags needed
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
; 0x163c9

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
; 0x163dd

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
; 0x16422

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
; 0x16451

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
; 0x16488

Func_16488 ; 16488 (5:6488)
	INCROM $16488, $164d3

; copies bench AI score to wcddd
; and loads in wAIscore value in wcde3
Func_164d3: ; 164d3 (5:64d3)
	push af
	ld de, wBenchAIScore
	ld hl, wcddd
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
; 0x164e8

AIDecidePlayEnergyCard: ; 164e8 (5:64e8)
	xor a
	ld [wcdd8], a
	call CreateEnergyCardListFromHand
	jr nc, .has_energy

; no energy
	ld a, [wcdd8]
	or a
	jr z, .exit
	; can this even be reached?
	jp Func_164d3
.exit
	or a
	ret

; initialize wcde4 to $80
.has_energy
	ld a, $80
	ld b, MAX_PLAY_AREA_POKEMON
	ld hl, wcde4
.loop
	ld [hli], a
	dec b
	jr nz, .loop

	call HandleLegendaryArticunoEnergyScoring

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
	ld [wCurCardPlayAreaLocation], a
	ld a, [wcdd8]
	and $02
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
	ld [wCurCardPlayAreaLocation], a
	ld a, 2
	call AddToAIScore
	jr .check_venusaur

.no_evolution_in_hand
	ld a, [wCurCardCanAttack]
	call CheckForEvolutionInDeck
	jr nc, .check_venusaur
	ld a, 1
	call AddToAIScore

; if there's no Muk in Play Area
; and there's Venusaur2, add to AI score
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
	ld a, [wcda7]
	bit 7, a
	jr z, .check_arena_hp
	ld a, 5
	call SubFromAIScore
	jr .check_defending_can_ko

; lower AI score if poison/double poison
; will KO Pokémon between turns
; or if the defending Pokémon can KO
.check_arena_hp
	ld a, 4
	call AddToAIScore

	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	call CalculateTensDigit
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
	jr nc, .asm_165e1
	ld a, 10
	call SubFromAIScore

; if either poison will KO or defending Pokémon can KO,
; check if there are bench Pokémon,
; if there are not, add AI score
.check_bench
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	dec a
	jr nz, .asm_165e1
	ld a, 6
	call AddToAIScore
	jr .asm_165e1

; lower AI score by 3 - (bench HP)/10
; if bench HP < 30
.bench
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	call CalculateTensDigit
	cp 3
	jr nc, .asm_165e1
; hp < 30
	ld b, a
	ld a, 3
	sub b
	call SubFromAIScore

; check list in wcdb2
.asm_165e1
	ld a, [wcdb3]
	or a
	jr z, .check_boss_deck
	ld h, a
	ld a, [wcdb2]
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
	ld hl, wcde4
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
	
	xor a ; first move
	call Func_16695
	ld a, $01 ; second move
	call Func_16695
	
.store_score
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld c, a
	ld b, $00
	ld hl, wBenchAIScore
	add hl, bc
	ld a, [wAIScore]
	ld [hl], a
	pop bc
	inc b
	dec c
	jp nz, .loop_play_area

	call Func_167b5
	jp nc, Func_1668a

	ld a, [wcdd8]
	or a
	jr z, .asm_16684
	scf
	jp Func_164d3

.asm_16684
	call CreateEnergyCardListFromHand
	jp Func_1689f
; 0x1668a

Func_1668a ; 1668a (5:668a)
	INCROM $1668a, $16695

Func_16695: ; 16695 (5:6695)
	ld [wSelectedMoveIndex], a
	call CheckEnergyNeededForAttack
	jp c, .asm_1671e
	ld a, $0c ; ATTACHED_ENERGY_BOOST
	call CheckLoadedMoveFlag
	jr c, .asm_166af
	ld a, $0b ; FLAG_2_BIT_5
	call CheckLoadedMoveFlag
	jr c, .asm_16710
	jp .check_evolution

.asm_166af
	ld a, [wLoadedMoveUnknown1]
	cp $02
	jr z, .asm_166bc
	call AddToAIScore
	jp .check_evolution

.asm_166bc
	call Func_171fb
	jr c, .asm_166cd
	cp 3
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
; will KO defending Pokémon
	ld a, $0c
	call CheckLoadedMoveFlag
	jp nc, .check_evolution
	ld a, [wSelectedMoveIndex]
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
	jr c, .asm_166ff
	jr nz, .check_evolution
.asm_166ff
	ld a, 20
	call AddToAIScore
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .check_evolution
	ld a, 10
	call AddToAIScore
	jr .check_evolution

; FLAG_2_BIT_5 is set only for Pokémon Powers,
; except for Magnemite2's Magnetic Storm attack
.asm_16710
	ld a, [wLoadedCard1ID]
	cp ZAPDOS2
	jr z, .check_evolution
	call Func_171fb
	jr c, .asm_166cd
	jr .asm_166c5

.asm_1671e
	ld a, $0d ; FLAG_2_BIT_5
	call CheckLoadedMoveFlag
	jr nc, .asm_1672a
	ld a, 5
	call SubFromAIScore

.asm_1672a
	ld a, b
	or a
	jr z, .asm_1673b
	ld a, e
	call LookForCardIDInHand
	jr c, .asm_1673b
	ld a, 4
	call AddToAIScore
	jr .asm_16744
.asm_1673b
	ld a, c
	or a
	jr z, .check_evolution
	ld a, 3
	call AddToAIScore

.asm_16744
	ld a, b
	add c
	dec a
	jr nz, .check_evolution
	ld a, 3
	call AddToAIScore

	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .check_evolution
	ld a, [wSelectedMoveIndex]
	call EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr z, .asm_16766
	jr nc, .check_evolution
.asm_16766
	ld a, 20
	call AddToAIScore
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .check_evolution
	ld a, 10
	call AddToAIScore

.check_evolution
	ld a, [wCurCardPlayAreaLocation]
	cp $ff
	ret z
	ld b, a
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	push af
	ld [hl], b
	call CheckEnergyNeededForAttack
	jr nc, .done
	ld a, $0d ; FLAG_2_BIT_5
	call CheckLoadedMoveFlag
	jr c, .done
	ld a, b
	or a
	jr z, .asm_167a2
	ld a, e
	call LookForCardIDInHand
	jr c, .asm_167a2
	ld a, 2
	call AddToAIScore
	jr .done
.asm_167a2
	ld a, c
	or a
	jr z, .done
	ld a, 1
	call AddToAIScore

.done
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af
	ld [hl], a
	ret
; 0x167b5

Func_167b5 ; 167b5 (5:67b5)
	INCROM $167b5, $1689f

Func_1689f ; 1689f (5:689f)
	INCROM $1689f, $169f8

Func_169f8 ; 169f8 (5:69f8)
	INCROM $169f8, $170c9

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
	jr z, .check_second_move
	ld a, d
	call CheckCardEvolutionInHandOrDeck
	jr c, .no_carry

.check_second_move
	xor a ; active card
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, $01 ; second move
	ld [wSelectedMoveIndex], a
	push hl
	call CheckIfCardCanUseSelectedMove
	pop hl
	jr c, .no_carry
	scf
	ret
.no_carry
	or a
	ret
; 0x17101

; returns carry if at least one Pokémon in bench
; meets the following conditions:
;	- card HP >= half max HP
;	- card Unknown2's 4 bit is not set or
;	  is set but there's no evolution of card in hand/deck
;	- card can use second move
; Also outputs the number of Pokémon in bench
; that meet these requirements in b
CheckIfBenchCardsAreAtHalfHPCanEvolveAndUseSecondMove: ; 17101 (5:7101)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld d, a
	ld a, [wSelectedMoveIndex]
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
	ld a, c
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wLoadedCard1HP]
	rrca
	cp d
	pop de
	jr nc, .next

	ld a, [wLoadedCard1Unknown2]
	and $10
	jr z, .check_second_move

	ld a, d
	push bc
	call CheckCardEvolutionInHandOrDeck
	pop bc
	jr c, .next

.check_second_move
	ld a, c
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, $01 ; second move
	ld [wSelectedMoveIndex], a
	push bc
	push hl
	call CheckIfCardCanUseSelectedMove
	pop hl
	pop bc
	jr c, .next
	inc b
	jr .next

.done
	pop hl
	pop de
	ld a, e
	ld [wSelectedMoveIndex], a
	ld a, d
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, b
	or a
	ret z
	scf
	ret
; 0x17161

Func_17161 ; 17161 (5:7161)
	INCROM $17161, $171fb

; return carry if Pokémon at play area location
; in hTempPlayAreaLocation_ff9d does not have
; energy required for the move index in wSelectedMoveIndex
; or has exactly the same amount of energy needed
; input:
;	[hTempPlayAreaLocation_ff9d] = play area location
;	[wSelectedMoveIndex]         = move index to check
Func_171fb: ; 171fb (5:71fb)
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ld a, [wSelectedMoveIndex]
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
; 0x17258

; takes as input the energy cost of a move for a 
; particular energy, stored in the lower nibble of a
; if the move costs some amount of this energy, the lower nibble of a != 0,
; and this amount is stored in wTempLoadedMoveEnergyCost
; also adds the amount of energy still needed
; to wTempLoadedMoveEnergyNeededAmount
; input:
; 	a    = this energy cost of move (lower nibble)
; 	[hl] = attached energy
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
; 0x17274

; return carry if there is a card that
; can evolve a Pokémon in hand or deck
; input:
;	a = deck index of card to check
CheckCardEvolutionInHandOrDeck: ; 17274 (5:7274)
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	push af
	ld [hl], b
	ld e, $00

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
; 0x172af

Func_172af ; 172af (5:72af)
	INCROM $172af, $17383

; returns carry if Pokemon at PLAY_AREA* in a
; can damage defending Pokémon with any of its moves
; input:
; 	a = location of card to check
CheckIfCanDamageDefendingPokemon: ; 17383 (5:7383)
	ldh [hTempPlayAreaLocation_ff9d], a
	xor a ; first move
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
	jr c, .second_move
	xor a
	call EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr nz, .set_carry

.second_move
	ld a, $01 ; second move
	ld [wSelectedMoveIndex], a
	call CheckIfCardCanUseSelectedMove
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
; 0x173b1

; checks if defending Pokémon can knock out
; card at hTempPlayAreaLocation_ff9d with any of its moves
; and if so, stores the damage to wce00 and wce01
; sets carry if any on the moves knocks out
; also outputs the largest damage dealt in a
; input:
;	[hTempPlayAreaLocation_ff9d] = locaion of card to check
; output:
;	a = largest damage of both moves
;	carry set if can knock out
CheckIfDefendingPokemonCanKnockOut: ; 173b1 (5:73b1)
	xor a ; first move
	ld [wce00], a
	ld [wce01], a
	call CheckIfDefendingPokemonCanKnockOutWithMove
	jr nc, .second_move
	ld a, [wDamage]
	ld [wce00], a

.second_move
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
; 0x173e4

; return carry if defending Pokémon can knock out
; card at hTempPlayAreaLocation_ff9d
; input:
;	a = move index
;	[hTempPlayAreaLocation_ff9d] = location of card to check
CheckIfDefendingPokemonCanKnockOutWithMove: ; 173e4 (5:73e4)
	ld [wSelectedMoveIndex], a
	ldh a, [hTempPlayAreaLocation_ff9d]
	push af
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call SwapTurn
	call CheckIfCardCanUseSelectedMove
	call SwapTurn
	pop bc
	ld a, b
	ldh [hTempPlayAreaLocation_ff9d], a
	jr c, .done

; player's active Pokémon can use move
	ld a, [wSelectedMoveIndex]
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
; 0x17414

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
; 0x17426

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
; 0x1743b

Func_1743b ; 1743b (5:743b)
	INCROM $1743b, $17474

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
	ld a, [wSelectedMoveIndex]
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
	ld [wSelectedMoveIndex], a
	push bc
	call CheckIfCardCanUseSelectedMove
	pop bc
	jr c, .loop
	inc b
.done
	pop hl
	pop de
	ld a, e
	ld [wSelectedMoveIndex], a
	ld a, d
	ldh [hTempPlayAreaLocation_ff9d], a
	ld a, b
	or a
	ret z
	scf
	ret
; 0x174cd

; add 5 to wcde4 AI score corresponding to all cards
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
	ld hl, wcde4
	add hl, bc
	ld a, 5
	add [hl]
	ld [hl], a
	pop hl
	jr .loop
; 0x174f2

; goes through each play area Pokémon, and
; for all cards of the same ID, determine which
; card has highest value calculated from Func_17583
; the card with highest value gets increased wcde4
; while all others get decreased wcde4
Func_174f2: ; 174f2 (5:74f2)
	ld a, MAX_PLAY_AREA_POKEMON
	ld hl, wcdfa
	call ZeroData
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
	ld e, 0

.loop_play_area
	push hl
	ld a, MAX_PLAY_AREA_POKEMON
	ld hl, wcdea
	call ZeroData
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
; decrease wcde4 score for all cards with same ID
; except for the one with highest score
; increase wcde4 score for card with highest ID
.asm_17560
	ld hl, wcde4
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
; 0x17583

; loads wcdea + play area location in e
; with nenergy  * 2 + $80 - floor(dam / 10)
; loads wcdfa + play area location in e
; with $01
Func_17583: ; 17583 (5:7583)
	push hl
	push de
	call GetCardDamage
	call CalculateTensDigit
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
; 0x175a8

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
; 0x175bd

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
; 0x175c9

Func_175c9 ; 175c9 (5:75c9)
	INCROM $175c9, $18000