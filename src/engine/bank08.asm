; unknown byte / card ID / function pointer 1 / function pointer 2
unknown_data_20000: MACRO
	db \1, \2
	dw \3
	dw \4
ENDM

Data_20000: ; 20000 (8:4000)
	unknown_data_20000 $07, POTION,                 CheckIfPotionPreventsKnockOut, AIPlayPotion
	unknown_data_20000 $0a, POTION,                 FindTargetCardForPotion, AIPlayPotion
	unknown_data_20000 $08, SUPER_POTION,           CheckIfSuperPotionPreventsKnockOut, AIPlaySuperPotion
	unknown_data_20000 $0b, SUPER_POTION,           FindTargetCardForSuperPotion, AIPlaySuperPotion
	unknown_data_20000 $0d, DEFENDER,               CheckIfDefenderPreventsKnockOut, AIPlayDefender
	unknown_data_20000 $0e, DEFENDER,               CheckIfDefenderPreventsRecoilKnockOut, AIPlayDefender
	unknown_data_20000 $0d, PLUSPOWER,              CheckIfPluspowerBoostCausesKnockOut, AIPlayPluspower
	unknown_data_20000 $0e, PLUSPOWER,              CheckIfMoveNeedsPluspowerBoostToKnockOut, AIPlayPluspower
	unknown_data_20000 $09, SWITCH,                 CheckIfActiveCardCanSwitch, AIPlaySwitch
	unknown_data_20000 $07, GUST_OF_WIND,           CheckWhetherToUseGustOfWind, AIPlayGustOfWind
	unknown_data_20000 $0a, GUST_OF_WIND,           CheckWhetherToUseGustOfWind, AIPlayGustOfWind
	unknown_data_20000 $04, BILL,                   CheckDeckCardsAmount, AIPlayBill
	unknown_data_20000 $05, ENERGY_REMOVAL,         CheckEnergyCardToRemoveInPlayArea, AIPlayEnergyRemoval
	unknown_data_20000 $05, SUPER_ENERGY_REMOVAL,   CheckTwoEnergyCardsToRemoveInPlayArea, AIPlaySuperEnergyRemoval
	unknown_data_20000 $07, POKEMON_BREEDER,        CheckIfCanEvolve2StageFromHand, AIPlayPokemonBreeder
	unknown_data_20000 $0f, PROFESSOR_OAK,          CheckIfCanPlayProfessorOak, AIPlayProfessorOak
	unknown_data_20000 $0a, ENERGY_RETRIEVAL,       CheckEnergyRetrievalCardsToPick, AIPlayEnergyRetrieval
	unknown_data_20000 $0b, SUPER_ENERGY_RETRIEVAL, CheckSuperEnergyRetrievalCardsToPick, AIPlaySuperEnergyRetrieval
	unknown_data_20000 $06, POKEMON_CENTER,         CheckIfCanPlayPokemonCenter, AIPlayPokemonCenter
	unknown_data_20000 $07, IMPOSTER_PROFESSOR_OAK, CheckWhetherToPlayImposterProfessorOak, AIPlayImposterProfessorOak
	unknown_data_20000 $0c, ENERGY_SEARCH,          CheckIfEnergySearchCanBePlayed, AIPlayEnergySearch
	unknown_data_20000 $03, POKEDEX,                CheckWhetherToPlayPokedex, AIPlayPokedex
	unknown_data_20000 $07, FULL_HEAL,              CheckWhetherToPlayFullHeal, AIPlayFullHeal
	unknown_data_20000 $0a, MR_FUJI,                CheckWetherToPlayMrFuji, AIPlayMrFuji
	unknown_data_20000 $0a, SCOOP_UP,               $5506, $54f1
	unknown_data_20000 $02, MAINTENANCE,            $562c, $560f
	unknown_data_20000 $03, RECYCLE,                $56b8, $569a
	unknown_data_20000 $0d, LASS,                   $5768, $5755
	unknown_data_20000 $04, ITEM_FINDER,            $57b1, $578f
	unknown_data_20000 $01, IMAKUNI_CARD,           $581e, $5813
	unknown_data_20000 $01, GAMBLER,                $5875, $582d
	unknown_data_20000 $05, REVIVE,                 $58a9, $5899
	unknown_data_20000 $0d, POKEMON_FLUTE,          $58e8, $58d8
	unknown_data_20000 $05, CLEFAIRY_DOLL,          $5982, $5977
	unknown_data_20000 $05, MYSTERIOUS_FOSSIL,      $5982, $5977
	unknown_data_20000 $02, POKE_BALL,              $59c6, $59a6
	unknown_data_20000 $02, COMPUTER_SEARCH,        $5b34, $5b12
	unknown_data_20000 $02, POKEMON_TRADER,         $5d8f, $5d7a
	db $ff

Func_200e5: ; 200e5 (8:40e5)
	ld [wce18], a
; create hand list in wDuelTempList and wTempHandCardList.
	call CreateHandCardList
	ld hl, wDuelTempList
	ld de, wTempHandCardList
	call CopyBuffer
	ld hl, wTempHandCardList

.loop_hand
	ld a, [hli]
	ld [wce16], a
	cp $ff
	ret z

	push hl
	ld a, [wce18]
	ld d, a
	ld hl, Data_20000
.loop_data
	xor a
	ld [wce21], a
	ld a, [hli]
	cp $ff
	jp z, .pop_hl

; compare input to first byte in data and continue if equal.
	cp d
	jp nz, .inc_hl_by_5
	ld a, [hli]
	ld [wce17], a
	ld a, [wce16]
	call LoadCardDataToBuffer1_FromDeckIndex
	cp SWITCH
	jr nz, .skip_switch_check

	ld b, a
	ld a, [wce20]
	and $02
	jr nz, .inc_hl_by_4
	ld a, b

.skip_switch_check
; compare hand card to second byte in data and continue if equal.
	ld b, a
	ld a, [wce17]
	cp b
	jr nz, .inc_hl_by_4

	push hl
	push de
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	bank1call CheckCantUseTrainerDueToHeadache
	jp c, .next_in_data
	call LoadNonPokemonCardEffectCommands
	ld a, EFFECTCMDTYPE_INITIAL_EFFECT_1
	call TryExecuteEffectCommandFunction
	jp c, .next_in_data
	farcall Func_1743b
	jr c, .next_in_data
	pop de
	pop hl
	push hl
	call CallIndirect
	pop hl
	jr nc, .inc_hl_by_4
	inc hl
	inc hl
	ld [wce19], a

	push de
	push hl
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, OPPACTION_PLAY_TRAINER
	bank1call AIMakeDecision
	pop hl
	pop de
	jr c, .inc_hl_by_2
	push hl
	call CallIndirect
	pop hl

	inc hl
	inc hl
	ld a, [wce20]
	ld b, a
	ld a, [wce21]
	or b
	ld [wce20], a
	pop hl
	and $08
	jp z, .loop_hand

.asm_20186 ; 20186 (8:4186)
	call CreateHandCardList
	ld hl, wDuelTempList
	ld de, wTempHandCardList
	call CopyBuffer
	ld hl, wTempHandCardList
	ld a, [wce20]
	and $f7
	ld [wce20], a
	jp .loop_hand

.inc_hl_by_5
	inc hl
.inc_hl_by_4
	inc hl
	inc hl
.inc_hl_by_2
	inc hl
	inc hl
	jp .loop_data

.next_in_data
	pop de
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	jp .loop_data

.pop_hl
	pop hl
	jp .loop_hand
; 0x201b5

; makes AI use Potion card.
AIPlayPotion: ; 201b5 (8:41b5)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTemp_ffa0], a
	ld e, a
	call GetCardDamage
	cp 20
	jr c, .play_card
	ld a, 20
.play_card
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x201d1

; if AI doesn't decide to retreat this card,
; check if defending Pokémon can KO active card
; next turn after using Potion.
; if it cannot, return carry.
; also take into account whether move is high recoil.
CheckIfPotionPreventsKnockOut: ; 201d1 (8:41d1)
	farcall AIDecideWhetherToRetreat
	jr c, .no_carry
	call Func_22bad
	jr c, .no_carry
	xor a ; active card
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckIfDefendingPokemonCanKnockOut
	jr nc, .no_carry
	ld d, a

	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld h, a
	ld e, PLAY_AREA_ARENA
	call GetCardDamage
	cp 20 + 1 ; if damage <= 20
	jr c, .calculate_hp
	ld a, 20 ; amount of Potion HP healing

; if damage done by defending Pokémon next turn will still
; KO this card after healing, return no carry.
.calculate_hp
	ld l, a
	ld a, h
	add l
	sub d
	jr c, .no_carry
	jr z, .no_carry

; return carry.
	xor a
	scf
	ret
.no_carry
	or a
	ret
; 0x20204

; finds a card in Play Area to use Potion on.
; output:
;	a = card to use Potion on;
;	carry set if Potion should be used.
FindTargetCardForPotion: ; 20204 (8:4204)
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckIfDefendingPokemonCanKnockOut
	jr nc, .start_from_active
; can KO
	ld d, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld h, a
	ld e, PLAY_AREA_ARENA
	call GetCardDamage
	cp 20 + 1  ; if damage <= 20
	jr c, .calculate_hp
	ld a, 20
; return if using healing prevents KO.
.calculate_hp
	ld l, a
	ld a, h
	add l
	sub d
	jr c, .count_prizes
	jr z, .count_prizes
	or a
	ret

; using Potion on active card does not prevent a KO.
; if player is at last prize, start loop with active card.
; otherwise start loop at first bench Pokémon.
.count_prizes
	call SwapTurn
	call CountPrizes
	call SwapTurn
	dec a
	jr z, .start_from_active
	ld e, PLAY_AREA_BENCH_1
	jr .loop

; find Play Area Pokémon with more than 10 damage.
; skip Pokémon if it has a BOOST_IF_TAKEN_DAMAGE attack.
.start_from_active
	ld e, PLAY_AREA_ARENA
.loop
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	cp $ff
	ret z
	call .check_boost_if_taken_damage	
	jr c, .has_boost_damage
	call GetCardDamage
	cp 20 ; if damage >= 20
	jr nc, .found
.has_boost_damage
	inc e
	jr .loop

; a card was found, now to check if it's active or benched.
.found
	ld a, e
	or a
	jr z, .active_card

; bench card
	push de
	call SwapTurn
	call CountPrizes
	call SwapTurn
	dec a
	or a
	jr z, .check_random
	ld a, 10
	call Random
	cp 3
; 7/10 chance of returning carry.
.check_random
	pop de
	jr c, .no_carry
	ld a, e
	scf
	ret

; return carry for active card if not Hgh Recoil.
.active_card
	push de
	call Func_22bad
	pop de
	jr c, .no_carry
	ld a, e
	scf
	ret
.no_carry
	or a
	ret
; 0x2027e

; return carry if either of the attacks are usable
; and have the BOOST_IF_TAKEN_DAMAGE effect.
.check_boost_if_taken_damage ; 2027e (8:427e)
	push de
	xor a ; first attack
	ld [wSelectedMoveIndex], a
	farcall CheckIfSelectedMoveIsUnusable
	jr c, .second_attack
	ld a, MOVE_FLAG3_ADDRESS | BOOST_IF_TAKEN_DAMAGE_F
	call CheckLoadedMoveFlag
	jr c, .set_carry
.second_attack
	ld a, $01 ; second attack
	ld [wSelectedMoveIndex], a
	farcall CheckIfSelectedMoveIsUnusable
	jr c, .false
	ld a, MOVE_FLAG3_ADDRESS | BOOST_IF_TAKEN_DAMAGE_F
	call CheckLoadedMoveFlag
	jr c, .set_carry
.false
	pop de
	or a
	ret
.set_carry
	pop de
	scf
	ret
; 0x202a8

; makes AI use Super Potion card.
AIPlaySuperPotion: ; 202a8 (8:42a8)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTempPlayAreaLocation_ffa1], a
	call GetEnergyCardToDiscard
	ldh [hTemp_ffa0], a
	ld a, [wce19]
	ld e, a
	call GetCardDamage
	cp 40
	jr c, .play_card
	ld a, 40
.play_card
	ldh [hTempRetreatCostCards], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x202cc

; if AI doesn't decide to retreat this card and card has
; any energy cards attached,  check if defending Pokémon can KO
; active card next turn after using Super Potion.
; if it cannot, return carry.
; also take into account whether move is high recoil.
CheckIfSuperPotionPreventsKnockOut: ; 202cc (8:42cc)
	farcall AIDecideWhetherToRetreat
	jr c, .no_carry
	call Func_22bad
	jr c, .no_carry
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	ld e, a
	call .check_attached_energy
	ret nc
	farcall CheckIfDefendingPokemonCanKnockOut
	jr nc, .no_carry

	ld d, a
	ld d, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld h, a
	ld e, $00
	call GetCardDamage
	cp 40 + 1 ; if damage < 40
	jr c, .calculate_hp
	ld a, 40
.calculate_hp
	ld l, a
	ld a, h
	add l
	sub d
	jr c, .no_carry
	jr z, .no_carry

; return carry
	ld a, e
	scf
	ret
.no_carry
	or a
	ret
; 0x20305

; returns carry if card has energies attached.
.check_attached_energy ; 20305 (8:4305)
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	or a
	ret z
	scf
	ret
; 0x2030f

; finds a card in Play Area to use Super Potion on.
; output:
;	a = card to use Super Potion on;
;	carry set if Super Potion should be used.
FindTargetCardForSuperPotion: ; 2030f (8:430f)
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckIfDefendingPokemonCanKnockOut
	jr nc, .start_from_active
; can KO
	ld d, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld h, a
	ld e, $00
	call GetCardDamage
	cp 40 + 1 ; if damage < 40
	jr c, .calculate_hp
	ld a, 40
; return if using healing prevents KO.
.calculate_hp
	ld l, a
	ld a, h
	add l
	sub d
	jr c, .count_prizes
	jr z, .count_prizes
	or a
	ret

; using Super Potion on active card does not prevent a KO.
; if player is at last prize, start loop with active card.
; otherwise start loop at first bench Pokémon.
.count_prizes
	call SwapTurn
	call CountPrizes
	call SwapTurn
	dec a
	jr z, .start_from_active
	ld e, PLAY_AREA_BENCH_1
	jr .loop

; find Play Area Pokémon with more than 30 damage.
; skip Pokémon if it doesn't have any energy attached,
; has a BOOST_IF_TAKEN_DAMAGE attack,
; or if discarding makes any attack of its attacks unusable.
.start_from_active
	ld e, PLAY_AREA_ARENA
.loop
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	cp $ff
	ret z
	ld d, a
	call .check_attached_energy
	jr nc, .next
	call .check_boost_if_taken_damage
	jr c, .next
	call .check_energy_cost
	jr c, .next
	call GetCardDamage
	cp 40 ; if damage >= 40
	jr nc, .found
.next
	inc e
	jr .loop

; a card was found, now to check if it's active or benched.
.found
	ld a, e
	or a
	jr z, .active_card

; bench card
	push de
	call SwapTurn
	call CountPrizes
	call SwapTurn
	dec a
	or a
	jr z, .check_random
	ld a, 10
	call Random
	cp 3
; 7/10 chance of returning carry.
.check_random
	pop de
	jr c, .no_carry
	ld a, e
	scf
	ret

; return carry for active card if not Hgh Recoil.
.active_card
	push de
	call Func_22bad
	pop de
	jr c, .no_carry
	ld a, e
	scf
	ret
.no_carry
	or a
	ret
; 0x20394

; returns carry if card has energies attached.
.check_attached_energy ; 20394 (8:4394)
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	or a
	ret z
	scf
	ret
; 0x2039e

; return carry if either of the attacks are usable
; and have the BOOST_IF_TAKEN_DAMAGE effect.
.check_boost_if_taken_damage ; 2039e (8:439e)
	push de
	xor a ; first attack
	ld [wSelectedMoveIndex], a
	farcall CheckIfSelectedMoveIsUnusable
	jr c, .second_attack_1
	ld a, MOVE_FLAG3_ADDRESS | BOOST_IF_TAKEN_DAMAGE_F
	call CheckLoadedMoveFlag
	jr c, .true_1
.second_attack_1
	ld a, $01 ; second attack
	ld [wSelectedMoveIndex], a
	farcall CheckIfSelectedMoveIsUnusable
	jr c, .false_1
	ld a, MOVE_FLAG3_ADDRESS | BOOST_IF_TAKEN_DAMAGE_F
	call CheckLoadedMoveFlag
	jr c, .true_1
.false_1
	pop de
	or a
	ret
.true_1
	pop de
	scf
	ret
; 0x203c8

; returns carry if discarding energy card renders any attack unusable,
; given that they have enough energy to be used before discarding.
.check_energy_cost ; 203c8 (8:43c8)
	push de
	xor a ; first attack
	ld [wSelectedMoveIndex], a
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckEnergyNeededForAttack
	jr c, .second_attack_2
	farcall CheckEnergyNeededForAttackAfterDiscard
	jr c, .true_2

.second_attack_2
	pop de
	push de
	ld a, $01 ; second attack
	ld [wSelectedMoveIndex], a
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckEnergyNeededForAttack
	jr c, .false_2
	farcall CheckEnergyNeededForAttackAfterDiscard
	jr c, .true_2

.false_2
	pop de
	or a
	ret
.true_2
	pop de
	scf
	ret
; 0x203f8

AIPlayDefender: ; 203f8 (8:43f8)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	xor a
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x20406

; returns carry if using Defender can prevent a KO
; by the defending Pokémon.
; this takes into account both attacks and whether they're useable.
CheckIfDefenderPreventsKnockOut: ; 20406 (8:4406)
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .cannot_ko
	farcall CheckIfSelectedMoveIsUnusable
	jr nc, .no_carry
	farcall LookForEnergyNeededForMoveInHand
	jr c, .no_carry

.cannot_ko
; check if any of the defending Pokémon's attacks deal
; damage exactly equal to current HP, and if so,
; only continue if that move is useable.
	farcall CheckIfAnyDefendingPokemonAttackDealsSameDamageAsHP
	jr nc, .no_carry
	call SwapTurn
	farcall CheckIfSelectedMoveIsUnusable
	call SwapTurn
	jr c, .no_carry

	ld a, [wSelectedMoveIndex]
	farcall EstimateDamage_FromDefendingPokemon
	ld a, [wDamage]
	ld [wce06], a
	ld d, a

; load in a the attack that was not selected,
; and check if it is useable.
	ld a, [wSelectedMoveIndex]
	ld b, a
	ld a, $01
	sub b
	ld [wSelectedMoveIndex], a
	push de
	call SwapTurn
	farcall CheckIfSelectedMoveIsUnusable
	call SwapTurn
	pop de
	jr c, .switch_back

; the other attack is useable.
; compare its damage to the selected move.
	ld a, [wSelectedMoveIndex]
	push de
	farcall EstimateDamage_FromDefendingPokemon
	pop de
	ld a, [wDamage]
	cp d
	jr nc, .subtract

; in case the non-selected move is useable
; and deals less damage than the selected move,
; switch back to the other attack.
.switch_back
	ld a, [wSelectedMoveIndex]
	ld b, a
	ld a, $01
	sub b
	ld [wSelectedMoveIndex], a
	ld a, [wce06]
	ld [wDamage], a

; now the selected attack is the one that deals
; the most damage of the two (and is useable).
; if subtracting damage by using Defender
; still prevents a KO, return carry.
.subtract
	ld a, [wDamage]
	sub 20
	ld d, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	sub d
	jr c, .no_carry
	jr z, .no_carry
	scf
	ret
.no_carry
	or a
	ret
; 0x20486

; return carry if using Defender prevents Pokémon
; from being knocked out by an attack with recoil.
CheckIfDefenderPreventsRecoilKnockOut: ; 20486 (8:4486)
	ld a, MOVE_FLAG1_ADDRESS | HIGH_RECOIL_F
	call CheckLoadedMoveFlag
	jr c, .recoil
	ld a, MOVE_FLAG1_ADDRESS | LOW_RECOIL_F
	call CheckLoadedMoveFlag
	jr c, .recoil
	or a
	ret

.recoil
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wSelectedMoveIndex]
	or a
	jr nz, .second_attack
; first attack
	ld a, [wLoadedCard2Move1Unknown1]
	jr .check_weak
.second_attack
	ld a, [wLoadedCard2Move2Unknown1]

; double recoil damage if card is weak to its own color.
.check_weak
	ld d, a
	push de
	call GetArenaCardColor
	call TranslateColorToWR
	ld b, a
	call GetArenaCardWeakness
	and b
	pop de
	jr z, .check_resist
	sla d

; subtract 30 from recoil damage if card resists its own color.
; if this yields a negative number, return no carry.
.check_resist
	push de
	call GetArenaCardColor
	call TranslateColorToWR
	ld b, a
	call GetArenaCardResistance
	and b
	pop de
	jr z, .subtract
	ld a, d
	sub 30
	jr c, .no_carry
	ld d, a

; subtract damage prevented by Defender.
; if damage still knocks out card, return no carry.
; if damage does not knock out, return carry.
.subtract
	ld a, d
	or a
	jr z, .no_carry
	sub 20
	ld d, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	sub d
	jr c, .no_carry
	jr z, .no_carry
	scf
	ret
.no_carry
	or a
	ret
; 0x204e8

AIPlayPluspower: ; 204e8 (8:44e8)
	ld a, [wce21]
	or $01
	ld [wce21], a
	ld a, [wce19]
	ld [wcdd6], a
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x20501

; returns carry if using a Pluspower can KO defending Pokémon
; if active card cannot KO without the boost.
CheckIfPluspowerBoostCausesKnockOut: ; 20501 (8:4501)
; this is mistakenly duplicated
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a

; continue if no attack can knock out.
; if there's an attack that can, only continue
; if it's unusable and there's no card in hand
; to fulfill its energy cost.
	farcall CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .cannot_ko
	farcall CheckIfSelectedMoveIsUnusable
	jr nc, .no_carry
	farcall LookForEnergyNeededForMoveInHand
	jr c, .no_carry

; cannot use an attack that knocks out.
.cannot_ko
; get active Pokémon's info.
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempTurnDuelistCardID], a

; get defending Pokémon's info and check
; its No Damage or Effect substatus.
; if substatus is active, return.
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempNonTurnDuelistCardID], a
	bank1call HandleNoDamageOrEffectSubstatus
	call SwapTurn
	jr c, .no_carry

; check both attacks and decide which one
; can KO with Pluspower boost.
; if neither can KO, return no carry.
	xor a ; first attack
	ld [wSelectedMoveIndex], a
	call .check_ko_with_pluspower
	jr c, .kos_with_pluspower_1
	ld a, $01 ; second attack
	ld [wSelectedMoveIndex], a
	call .check_ko_with_pluspower
	jr c, .kos_with_pluspower_2

.no_carry
	or a
	ret

; first attack can KO with Pluspower.
.kos_with_pluspower_1
	call .check_mr_mime
	jr nc, .no_carry
	xor a ; first attack
	scf
	ret
; second attack can KO with Pluspower.
.kos_with_pluspower_2
	call .check_mr_mime
	jr nc, .no_carry
	ld a, $01 ; second attack
	scf
	ret
; 0x20562

; return carry if move is useable and KOs
; defending Pokémon with Pluspower boost.
.check_ko_with_pluspower ; 20562 (8:4562)
	farcall CheckIfSelectedMoveIsUnusable
	jr c, .unusable
	ld a, [wSelectedMoveIndex]
	farcall EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld b, a
	ld hl, wDamage
	sub [hl]
	jr c, .no_carry
	jr z, .no_carry
	ld a, [hl]
	add 10 ; add Pluspower boost
	ld c, a
	ld a, b
	sub c
	ret c ; return carry if damage > HP left
	ret nz ; does not KO
	scf
	ret ; KOs with Pluspower boost
.unusable
	or a
	ret
; 0x20589

; returns carry if Pluspower boost does
; not exceed 30 damage when facing Mr. Mime.
.check_mr_mime ; 20589 (8:4589)
	ld a, [wDamage]
	add 10 ; add Pluspower boost
	cp 30 ; no danger in preventing damage
	ret c
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MR_MIME
	ret z
; damage is >= 30 but not Mr. Mime
	scf
	ret
; 0x205a5

; returns carry 7/10 of the time
; if selected move is useable, can't KO without Pluspower boost
; can damage Mr. Mime even with Pluspower boost
; and has a minimum damage > 0.
CheckIfMoveNeedsPluspowerBoostToKnockOut: ; 205a5 (8:45a5)
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a
	call .check_can_ko
	jr nc, .no_carry
	call .check_random
	jr nc, .no_carry
	call .check_mr_mime
	jr nc, .no_carry
	scf
	ret
.no_carry
	or a
	ret
; 0x205bb

; returns carry if Pluspower boost does
; not exceed 30 damage when facing Mr. Mime.
.check_mr_mime ; 205bb (8:45bb)
	ld a, [wDamage]
	add 10 ; add Pluspower boost
	cp 30 ; no danger in preventing damage
	ret c
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	cp MR_MIME
	ret z
; damage is >= 30 but not Mr. Mime
	scf
	ret
; 0x205d7

; return carry if move is useable but cannot KO.
.check_can_ko ; 205d7 (8:45d7)
	farcall CheckIfSelectedMoveIsUnusable
	jr c, .unuseable
	ld a, [wSelectedMoveIndex]
	farcall EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld b, a
	ld hl, wDamage
	sub [hl]
	jr c, .no_carry
	jr z, .no_carry
; can't KO.
	scf
	ret
.unuseable
	or a
	ret
; 0x205f6

; return carry 7/10 of the time if
; move is useable and minimum damage > 0.
.check_random ; 205f6 (8:45f6)
	farcall CheckIfSelectedMoveIsUnusable
	jr c, .unuseable
	ld a, [wSelectedMoveIndex]
	farcall EstimateDamage_VersusDefendingCard
	ld a, [wAIMinDamage]
	cp 10
	jr c, .unuseable
	ld a, 10
	call Random
	cp 3
	ret
; 0x20612

AIPlaySwitch: ; 20612 (8:4612)
	ld a, [wce21]
	or $02
	ld [wce21], a
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	xor a
	ld [wcdb4], a
	ret
; 0x2062e

; returns carry if the active card has less energy cards
; than the retreat cost and if AI can't play an energy
; card from the hand to fulfill the cost
CheckIfActiveCardCanSwitch: ; 2062e (8:462e)
; check if AI can already play an energy card from hand to retreat
	ld a, [wAIPlayEnergyCardForRetreat]
	or a
	jr z, .check_cost_amount

; can't play energy card from hand to retreat
; compare number of energy cards attached to retreat cost
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call GetPlayAreaCardRetreatCost
	push af
	ld e, PLAY_AREA_ARENA
	farcall CountNumberOfEnergyCardsAttached
	ld b, a
	pop af
	sub b
	; jump if cards attached > retreat cost
	jr c, .check_cost_amount
	cp 2
	; jump if retreat cost is 2 more energy cards
	; than the number of cards attached
	jr nc, .switch

.check_cost_amount
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call GetPlayAreaCardRetreatCost
	cp 3
	; jump if retreat cost >= 3
	jr nc, .switch

	push af
	ld e, PLAY_AREA_ARENA
	farcall CountNumberOfEnergyCardsAttached
	pop bc
	cp b
	; jump if energy cards attached < retreat cost
	jr c, .switch
	ret

.switch
	farcall AIDecideBenchPokemonToSwitchTo
	ccf
	ret
; 0x20666

AIPlayGustOfWind: ; 20666 (8:4666)
	ld a, [wce21]
	or $10
	ld [wce21], a
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x2067e

CheckWhetherToUseGustOfWind: ; 2067e (8:467e)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	dec a
	or a
	ret z ; no bench cards
	ld a, [wce20]
	and $10
	ret nz
	farcall CheckIfActivePokemonCanUseAnyNonResidualMove
	ret nc ; no non-residual move can be used

	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .check_id ; if can't KO
	farcall CheckIfSelectedMoveIsUnusable
	jr nc, .no_carry ; if KO move is useable
	farcall LookForEnergyNeededForMoveInHand
	jr c, .no_carry ; if energy card is in hand

.check_id
	; skip if current active card is MEW3 or MEWTWO1
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp MEW3
	jr z, .no_carry
	cp MEWTWO1
	jr z, .no_carry

	call .FindBenchCardToKnockOut
	ret c

	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call .CheckIfNoAttackDealsDamage
	jr c, .check_bench_energy

	; skip if current arena card's color is
	; the defending card's weakness
	call GetArenaCardColor
	call TranslateColorToWR
	ld b, a
	call SwapTurn
	call GetArenaCardWeakness
	call SwapTurn
	and b
	jr nz, .no_carry

; check weakness
	call .FindBenchCardWithWeakness
	ret nc ; no bench card weak to arena card
	scf
	ret ; found bench card weak to arena card

.no_carry
	or a
	ret

; being here means AI's arena card cannot damage player's arena card

; first check if there is a card in player's bench that
; has no attached energy cards and that the AI can damage
.check_bench_energy
	; return carry if there's a bench card with weakness
	call .FindBenchCardWithWeakness
	ret c

	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA
; loop through bench and check attached energy cards
.loop_1
	inc e
	dec d
	jr z, .check_bench_hp
	call SwapTurn
	call GetPlayAreaCardAttachedEnergies
	call SwapTurn
	ld a, [wTotalAttachedEnergies]
	or a
	jr nz, .loop_1 ; skip if has energy attached
	call .CheckIfCanDamageBenchedCard
	jr nc, .loop_1
	ld a, e
	scf
	ret

.check_bench_hp
	ld a, $ff
	ld [wce06], a
	xor a
	ld [wce08], a
	ld e, a
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	ld d, a

; find bench card with least amount of available HP
.loop_2
	inc e
	dec d
	jr z, .check_found
	ld a, e
	add DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld b, a
	ld a, [wce06]
	inc b
	cp b
	jr c, .loop_2
	call .CheckIfCanDamageBenchedCard
	jr nc, .loop_2
	dec b
	ld a, b
	ld [wce06], a
	ld a, e
	ld [wce08], a
	jr .loop_2

.check_found
	ld a, [wce08]
	or a
	jr z, .no_carry
; a card was found

.set_carry
	scf
	ret

.check_can_damage
	push bc
	push hl
	xor a ; PLAY_AREA_ARENA
	farcall CheckIfCanDamageDefendingPokemon
	pop hl
	pop bc
	jr nc, .loop_3
	ld a, c
	scf
	ret

; returns carry if any of the player's
; benched cards is weak to color in b
; and has a way to damage it
.FindBenchCardWithWeakness ; 2074d (8:474d)
	ld a, DUELVARS_BENCH
	call GetNonTurnDuelistVariable
	ld c, PLAY_AREA_ARENA
.loop_3
	inc c
	ld a, [hli]
	cp $ff
	jr z, .no_carry
	call SwapTurn
	call LoadCardDataToBuffer1_FromDeckIndex
	call SwapTurn
	ld a, [wLoadedCard1Weakness]
	and b
	jr nz, .check_can_damage
	jr .loop_3

; returns carry if neither attack can deal damage
.CheckIfNoAttackDealsDamage ; 2076b (8:476b)
	xor a ; first attack
	ld [wSelectedMoveIndex], a
	call .CheckIfAttackDealsNoDamage
	jr c, .second_attack
	ret
.second_attack
	ld a, $01 ; second attack
	ld [wSelectedMoveIndex], a
	call .CheckIfAttackDealsNoDamage
	jr c, .true
	ret
.true
	scf
	ret

; returns carry if attack is Pokemon Power
; or otherwise doesn't deal any damage
.CheckIfAttackDealsNoDamage ; 20782 (8:4782)
	ld a, [wSelectedMoveIndex]
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld a, [wLoadedMoveCategory]

	; skip if move is a Power or has 0 damage
	cp POKEMON_POWER
	jr z, .no_damage
	ld a, [wDamage]
	or a
	ret z

	; check damage against defending card
	ld a, [wSelectedMoveIndex]
	farcall EstimateDamage_VersusDefendingCard
	ld a, [wAIMaxDamage]
	or a
	ret nz

.no_damage
	scf
	ret

; returns carry if there is a player's bench card that
; the opponent's current active card can KO
.FindBenchCardToKnockOut ; 207a9 (8:47a9)
	ld a, DUELVARS_BENCH
	call GetNonTurnDuelistVariable
	ld e, PLAY_AREA_BENCH_1

.loop_4
	ld a, [hli]
	cp $ff
	ret z

; overwrite the player's active card and its HP
; with the current bench card that is being checked
	push hl
	push de
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	push af
	ld [hl], b
	ld a, e
	add DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld b, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	push af
	ld [hl], b

	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call .CheckIfAnyAttackKnocksOut
	jr nc, .next
	farcall CheckIfSelectedMoveIsUnusable
	jr nc, .found
	farcall LookForEnergyNeededForMoveInHand
	jr c, .found

; the following two local routines can be condensed into one
; since they both revert the player's arena card
.next
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	pop de
	inc e
	pop hl
	jr .loop_4

; revert player's arena card and set carry
.found
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	pop de
	ld a, e
	pop hl
	scf
	ret

; returns carry if any of arena card's attacks
; KOs player card in location stored in e
.CheckIfAnyAttackKnocksOut ; 20806 (8:4806)
	xor a ; first attack
	call .CheckIfAttackKnocksOut
	ret c
	ld a, $01 ; second attack

; returns carry if attack KOs player card
; in location stored in e
.CheckIfAttackKnocksOut
	push de
	farcall EstimateDamage_VersusDefendingCard
	pop de
	ld a, DUELVARS_ARENA_CARD_HP
	add e
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	ret c
	ret nz
	scf
	ret

; returns carry if opponent's arena card can damage
; this benched card if it were switched with
; the player's arena card
.CheckIfCanDamageBenchedCard ; 20821 (8:4821)
	push bc
	push de
	push hl

	; overwrite arena card data
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	push af
	ld [hl], b

	; overwrite arena card HP
	ld a, e
	add DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld b, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	push af
	ld [hl], b

	xor a ; PLAY_AREA_ARENA
	farcall CheckIfCanDamageDefendingPokemon
	jr c, .can_damage

; the following two local routines can be condensed into one
; since they both revert the player's arena card

; can't damage
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	pop hl
	pop de
	pop bc
	or a
	ret

.can_damage
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	pop hl
	pop de
	pop bc
	scf
	ret
; 0x2086d

AIPlayBill: ; 2086d (8:486d)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x20878

; return carry if cards in deck > 9
CheckDeckCardsAmount: ; 20878 (8:4878)
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE - 9
	ret
; 0x20880

AIPlayEnergyRemoval: ; 20880 (8:4880)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTemp_ffa0], a
	ld a, [wce1a]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x20895

; picks an energy card in the player's Play Area to remove
CheckEnergyCardToRemoveInPlayArea: ; 20895 (8:4895)
; check if the current active card can KO player's card
; if it's possible to KO, then do not consider the player's
; active card to remove its attached energy
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .cannot_ko
	farcall CheckIfSelectedMoveIsUnusable
	jr nc, .can_ko
	farcall LookForEnergyNeededForMoveInHand
	jr nc, .cannot_ko

.can_ko
	; start checking from the bench
	ld a, PLAY_AREA_BENCH_1
	ld [wce0f], a
	jr .check_bench_energy
.cannot_ko
	; start checking from the arena card
	xor a ; PLAY_AREA_ARENA
	ld [wce0f], a

; loop each card and check if it has enough energy to use any attack
; if it does, then proceed to pick an energy card to remove
.check_bench_energy
	call SwapTurn
	ld a, [wce0f]
	ld e, a
.loop_1
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	cp $ff
	jr z, .default

	ld d, a
	call .CheckIfCardHasEnergyAttached
	jr nc, .next_1
	call .CheckIfNotEnoughEnergyToAttack
	jr nc, .pick_energy ; jump if enough energy to attack
.next_1
	inc e
	jr .loop_1

.pick_energy
; a play area card was picked to remove energy
; store the picked energy card to remove in wce1a
; and set carry
	ld a, e
	push af
	call PickAttachedEnergyCard
	ld [wce1a], a
	pop af
	call SwapTurn
	scf
	ret

; if no card in player's Play Area was found with enough energy
; to attack, just pick an energy card from player's active card
; (in case the AI cannot KO it this turn)
.default
	ld a, [wce0f]
	or a
	jr nz, .check_bench_damage ; not active card
	call .CheckIfCardHasEnergyAttached
	jr c, .pick_energy

; lastly, check what attack on player's Play Area is highest damaging
; and pick an energy card attached to that Pokemon to remove
.check_bench_damage
	xor a
	ld [wce06], a
	ld [wce08], a

	ld e, PLAY_AREA_BENCH_1
.loop_2
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	cp $ff
	jr z, .found_damage

	ld d, a
	call .CheckIfCardHasEnergyAttached
	jr nc, .next_2
	call .FindHighestDamagingAttack
.next_2
	inc e
	jr .loop_2

.found_damage
	ld a, [wce08]
	or a
	jr z, .no_carry ; skip if none found
	ld e, a
	jr .pick_energy
.no_carry
	call SwapTurn
	or a
	ret

; returns carry if this card has any energy cards attached
.CheckIfCardHasEnergyAttached ; 2091a (8:491a)
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	or a
	ret z
	scf
	ret

; returns carry if this card does not
; have enough energy for either of its attacks
.CheckIfNotEnoughEnergyToAttack ; 20924 (8:4924)
	push de
	xor a ; first attack
	ld [wSelectedMoveIndex], a
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckEnergyNeededForAttack
	jr nc, .enough_energy
	pop de

	push de
	ld a, $01 ; second attack
	ld [wSelectedMoveIndex], a
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckEnergyNeededForAttack
	jr nc, .check_surplus
	pop de

; neither attack has enough energy
	scf
	ret

.enough_energy
	pop de
	or a
	ret

; first attack doesn't have enough energy (or is just a Pokemon Power)
; but second attack has enough energy to be used
; check if there's surplus energy for attack and, if so, return carry
.check_surplus
	farcall CheckIfNoSurplusEnergyForMove
	pop de
	ccf
	ret

; stores in wce06 the highest damaging attack
; for the card in play area location in e
; and stores this card's location in wce08
.FindHighestDamagingAttack ; 2094f (8:494f)
	push de
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a

	xor a ; first attack
	farcall EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr z, .skip_1
	ld e, a
	ld a, [wce06]
	cp e
	jr nc, .skip_1
	ld a, e
	ld [wce06], a ; store this damage value
	pop de
	ld a, e
	ld [wce08], a ; store this location
	jr .second_attack

.skip_1
	pop de

.second_attack
	push de
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a

	ld a, $01 ; second attack
	farcall EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr z, .skip_2
	ld e, a
	ld a, [wce06]
	cp e
	jr nc, .skip_2
	ld a, e
	ld [wce06], a ; store this damage value
	pop de
	ld a, e
	ld [wce08], a ; store this location
	ret
.skip_2
	pop de
	ret
; 0x20994

AIPlaySuperEnergyRemoval: ; 20994 (8:4994)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTemp_ffa0], a
	ld a, [wce1a]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, [wce1b]
	ldh [hTempRetreatCostCards], a
	ld a, [wce1c]
	ldh [hTempRetreatCostCards + 1], a
	ld a, [wce1d]
	ldh [hTempRetreatCostCards + 2], a
	ld a, $ff
	ldh [hTempRetreatCostCards + 3], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x209bc

; picks two energy cards in the player's Play Area to remove
CheckTwoEnergyCardsToRemoveInPlayArea: ; 209bc (8:49bc)
	ld e, PLAY_AREA_BENCH_1
.loop_1
; first find an Arena card with a color energy card
; to discard for card effect
; return immediately if no Arena cards
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	cp $ff
	jr z, .exit
	
	ld d, a
	push de
	call .LookForNonDoubleColorless
	pop de
	jr c, .not_double_colorless
	inc e
	jr .loop_1

; returns carry if an energy card other than double colorless
; is found attached to the card in play area location e
.LookForNonDoubleColorless
	ld a, e
	call CreateArenaOrBenchEnergyCardList
	ld hl, wDuelTempList
.loop_2
	ld a, [hli]
	cp $ff
	ret z
	call LoadCardDataToBuffer1_FromDeckIndex
	cp DOUBLE_COLORLESS_ENERGY
	; any basic energy card
	; will set carry flag here
	jr nc, .loop_2
	ret

.exit
	or a
	ret

; card in Play Area location e was found with
; a basic energy card
.not_double_colorless
	ld a, e
	ld [wce0f], a

; check if the current active card can KO player's card
; if it's possible to KO, then do not consider the player's
; active card to remove its attached energy
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .cannot_ko
	farcall CheckIfSelectedMoveIsUnusable
	jr nc, .can_ko
	farcall LookForEnergyNeededForMoveInHand
	jr nc, .cannot_ko

.can_ko
	; start checking from the bench
	call SwapTurn
	ld e, PLAY_AREA_BENCH_1
	jr .loop_3
.cannot_ko
	; start checking from the arena card
	call SwapTurn
	ld e, PLAY_AREA_ARENA

; loop each card and check if it has enough energy to use any attack
; if it does, then proceed to pick energy cards to remove
.loop_3
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	cp $ff
	jr z, .no_carry

	ld d, a
	call .CheckIfFewerThanTwoEnergyCards
	jr c, .next_1
	call .CheckIfNotEnoughEnergyToAttack
	jr nc, .found_card ; jump if enough energy to attack
.next_1
	inc e
	jr .loop_3

.found_card
; a play area card was picked to remove energy
; if this is not the Arena Card, then check
; entire bench to pick the highest damage
	ld a, e
	or a
	jr nz, .check_bench_damage

; store the picked energy card to remove in wce1a
; and set carry
.pick_energy
	ld [wce1b], a
	call PickTwoAttachedEnergyCards
	ld [wce1c], a
	ld a, b
	ld [wce1d], a
	call SwapTurn
	ld a, [wce0f]
	push af
	call GetEnergyCardToDiscard
	ld [wce1a], a
	pop af
	scf
	ret

; check what attack on player's Play Area is highest damaging
; and pick an energy card attached to that Pokemon to remove
.check_bench_damage
	xor a
	ld [wce06], a
	ld [wce08], a

	ld e, PLAY_AREA_BENCH_1
.loop_4
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	cp $ff
	jr z, .found_damage

	ld d, a
	call .CheckIfFewerThanTwoEnergyCards
	jr c, .next_2
	call .CheckIfNotEnoughEnergyToAttack
	jr c, .next_2
	call .FindHighestDamagingAttack
.next_2
	inc e
	jr .loop_4

.found_damage
	ld a, [wce08]
	or a
	jr z, .no_carry
	jr .pick_energy
.no_carry
	call SwapTurn
	or a
	ret

; returns carry if the number of energy cards attached
; is fewer than 2, or if all energy combined yields
; fewer than 2 energy
.CheckIfFewerThanTwoEnergyCards ; 20a77 (8:4a77)
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	cp 2
	ret c ; return if fewer than 2 attached cards

; count all energy attached
; i.e. colored energy card = 1
; and double colorless energy card = 2
	xor a
	ld b, NUM_COLORED_TYPES
	ld hl, wAttachedEnergies
.loop_5
	add [hl]
	inc hl
	dec b
	jr nz, .loop_5
	ld b, [hl]
	srl b
	add b
	cp 2
	ret

; returns carry if this card does not
; have enough energy for either of its attacks
.CheckIfNotEnoughEnergyToAttack ; 20a92 (8:4a92)
	push de
	xor a ; first attack
	ld [wSelectedMoveIndex], a
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckEnergyNeededForAttack
	jr nc, .enough_energy
	pop de

	push de
	ld a, $01 ; second attack
	ld [wSelectedMoveIndex], a
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a
	farcall CheckEnergyNeededForAttack
	jr nc, .check_surplus
	pop de

; neither attack has enough energy
	scf
	ret

.enough_energy
	pop de
	or a
	ret

; first attack doesn't have enough energy (or is just a Pokemon Power)
; but second attack has enough energy to be used
; check if there's surplus energy for attack and, if so,
; return carry if this surplus energy is at least 2
.check_surplus
	farcall CheckIfNoSurplusEnergyForMove
	cp 2
	jr c, .enough_energy
	pop de
	scf
	ret
; 0x20ac1

; stores in wce06 the highest damaging attack
; for the card in play area location in e
; and stores this card's location in wce08
.FindHighestDamagingAttack ; 20ac1 (8:4ac1)
	push de
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a

	xor a ; first attack
	farcall EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr z, .skip_1
	ld e, a
	ld a, [wce06]
	cp e
	jr nc, .skip_1
	ld a, e
	ld [wce06], a ; store this damage value
	pop de
	ld a, e
	ld [wce08], a ; store this location
	jr .second_attack

.skip_1
	pop de

.second_attack
	push de
	ld a, e
	ldh [hTempPlayAreaLocation_ff9d], a

	ld a, $01 ; second attack
	farcall EstimateDamage_VersusDefendingCard
	ld a, [wDamage]
	or a
	jr z, .skip_2
	ld e, a
	ld a, [wce06]
	cp e
	jr nc, .skip_2
	ld a, e
	ld [wce06], a ; store this damage value
	pop de
	ld a, e
	ld [wce08], a ; store this location
	ret
.skip_2
	pop de
	ret
; 0x20b06

AIPlayPokemonBreeder: ; 20b06 (8:4b06)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, [wce1a]
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x20b1b

CheckIfCanEvolve2StageFromHand: ; 20b1b (8:4b1b)
	call IsPrehistoricPowerActive
	jp c, .done

	ld a, 7
	ld hl, wce08
	call ClearMemory_Bank8

	xor a
	ld [wce06], a
	call CreateHandCardList
	ld hl, wDuelTempList

.loop_hand_1
	ld a, [hli]
	cp $ff
	jr z, .not_found_in_hand

; check if card in hand is any of the following
; stage 2 Pokemon cards
	ld d, a
	call LoadCardDataToBuffer1_FromDeckIndex
	cp VENUSAUR1
	jr z, .found
	cp VENUSAUR2
	jr z, .found
	cp BLASTOISE
	jr z, .found
	cp VILEPLUME
	jr z, .found
	cp ALAKAZAM
	jr z, .found
	cp GENGAR
	jr nz, .loop_hand_1

.found
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	push hl
	call GetTurnDuelistVariable
	pop hl
	ld c, a
	ld e, PLAY_AREA_ARENA

; check Play Area for card that can evolve into
; the picked stage 2 Pokemon
.loop_play_area_1
	push hl
	push bc
	push de
	call CheckIfCanEvolveInto_BasicToStage2
	pop de
	call nc, .can_evolve
	pop bc
	pop hl
	inc e
	dec c
	jr nz, .loop_play_area_1
	jr .loop_hand_1

.can_evolve
	ld a, DUELVARS_ARENA_CARD_HP
	add e
	call GetTurnDuelistVariable
	call ConvertHPToCounters
	swap a
	ld b, a

; count number of energy cards attached and keep
; the lowest 4 bits (capped at $0f)
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	cp $10
	jr c, .not_maxed_out
	ld a, %00001111
.not_maxed_out
	or b

; 4 high bits of a = HP counters Pokemon still has
; 4 low  bits of a = number of energy cards attached

; store this score in wce08 + PLAY_AREA*
	ld hl, wce08
	ld c, e
	ld b, $00
	add hl, bc
	ld [hl], a

; store the deck index of stage 2 Pokemon in wce0f + PLAY_AREA*
	ld hl, wce0f
	add hl, bc
	ld [hl], d

; increase wce06 by one
	ld hl, wce06
	inc [hl]
	ret

.not_found_in_hand
	ld a, [wce06]
	or a
	jr z, .check_evolution_and_dragonite

; an evolution has been found before
	xor a
	ld [wce06], a
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld e, $00
	ld d, $00

; find highest score in wce08
.loop_score_1
	ld hl, wce08
	add hl, de
	ld a, [wce06]
	cp [hl]
	jr nc, .not_higher

; store this score to wce06
	ld a, [hl]
	ld [wce06], a
; store this PLay Area location to wce07
	ld a, e
	ld [wce07], a

.not_higher
	inc e
	dec c
	jr nz, .loop_score_1

; store the deck index of the stage 2 card
; that has been decided in wce1a,
; return the Play Area location of card
; to evolve in a and return carry
	ld a, [wce07]
	ld e, a
	ld hl, wce0f
	add hl, de
	ld a, [hl]
	ld [wce1a], a
	ld a, [wce07]
	scf
	ret

.check_evolution_and_dragonite
	ld a, 7
	ld hl, wce08
	call ClearMemory_Bank8

	xor a
	ld [wce06], a
	call CreateHandCardList
	ld hl, wDuelTempList
	push hl

.loop_hand_2
	pop hl
	ld a, [hli]
	cp $ff
	jr z, .check_evolution_found

	push hl
	ld d, a
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld e, PLAY_AREA_ARENA

.loop_play_area_2
; check if evolution is possible
	push bc
	push de
	call CheckIfCanEvolveInto_BasicToStage2
	pop de
	call nc, .HandleDragonite1Evolution
	call nc, .can_evolve

; not possible to evolve or returned carry
; when handling Dragonite1 evolution
	pop bc
	inc e
	dec c
	jr nz, .loop_play_area_2
	jr .loop_hand_2

.check_evolution_found
	ld a, [wce06]
	or a
	jr nz, .evolution_was_found
; no evolution was found before
	or a
	ret

.evolution_was_found
	xor a
	ld [wce06], a
	ld a, $ff
	ld [wce07], a

	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld e, $00
	ld d, $00

; find highest score in wce08 with at least
; 2 energy cards attached
.loop_score_2
	ld hl, wce08
	add hl, de
	ld a, [wce06]
	cp [hl]
	jr nc, .next_score

; take the lower 4 bits (total energy cards)
; and skip if less than 2
	ld a, [hl]
	ld b, a
	and %00001111
	cp 2
	jr c, .next_score

; has at least 2 energy cards
; store the score in wce06
	ld a, b
	ld [wce06], a
; store this PLay Area location to wce07
	ld a, e
	ld [wce07], a

.next_score
	inc e
	dec c
	jr nz, .loop_score_2

	ld a, [wce07]
	cp $ff
	jr z, .done

; a card to evolve was found
; store the deck index of the stage 2 card
; that has been decided in wce1a,
; return the Play Area location of card
; to evolve in a and return carry
	ld e, a
	ld hl, wce0f
	add hl, de
	ld a, [hl]
	ld [wce1a], a
	ld a, [wce07]
	scf
	ret

.done
	or a
	ret

; return carry if card is evolving to Dragonite1 and if
; - the card that is evolving is not Arena card and
;   number of damage counters in Play Area is under 8;
; - the card that is evolving is Arena card and has under 5
;   damage counters or has less than 3 energy cards attached.
.HandleDragonite1Evolution ; 20c5c (8:4c5c)
	push af
	push bc
	push de
	push hl
	push de

; check card ID
	ld a, d
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	cp DRAGONITE1
	jr nz, .no_carry

; check card Play Area location
	ld a, e
	or a
	jr z, .active_card_dragonite

; the card that is evolving is not active card
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld b, a
	ld c, 0

; count damage counters in Play Area
.loop_play_area_damage
	dec b
	ld e, b
	push bc
	call GetCardDamage
	pop bc
	call ConvertHPToCounters
	add c
	ld c, a

	ld a, b
	or a
	jr nz, .loop_play_area_damage

; compare number of total damage counters
; with 7, if less or equal to that, set carry
	ld a, 7
	cp c
	jr c, .no_carry
	jr .set_carry

.active_card_dragonite
; the card that is evolving is active card
; compare number of this card's damage counters
; with 5, if less than that, set carry
	ld e, PLAY_AREA_ARENA
	call GetCardDamage
	cp 5
	jr c, .set_carry

; compare number of this card's attached energy cards
; with 3, if less than that, set carry
	ld e, PLAY_AREA_ARENA
	farcall CountNumberOfEnergyCardsAttached
	cp 3
	jr c, .set_carry
	jr .no_carry

.no_carry
	pop hl
	pop de
	pop bc
	pop af
	ret

.set_carry
	pop hl
	pop de
	pop bc
	pop af
	scf
	ret
; 0x20cae

AIPlayProfessorOak: ; 20cae (8:4cae)
	ld a, [wce21]
	or $0c
	ld [wce21], a
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x20cc1

; sets carry if AI determines a score of playing
; Professor Oak is over a certain threshold.
CheckIfCanPlayProfessorOak: ; 20cc1 (8:4cc1)
; return if cards in deck <= 6
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE - 6
	ret nc

	ld a, [wOpponentDeckID]
	cp LEGENDARY_ARTICUNO_DECK_ID
	jp z, .HandleLegendaryArticunoDeck
	cp EXCAVATION_DECK_ID
	jp z, .HandleExcavationDeck
	cp WONDERS_OF_SCIENCE_DECK_ID
	jp z, .HandleWondersOfScienceDeck

; return if cards in deck <= 14
.check_cards_deck
	ld a, [hl]
	cp DECK_SIZE - 14
	ret nc

; initialize score
	ld a, $1e
	ld [wce06], a

; check number of cards in hand
.check_cards_hand
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	cp 4
	jr nc, .more_than_3_cards

; less than 4 cards in hand
	ld a, [wce06]
	add $32
	ld [wce06], a
	jr .check_energy_cards

.more_than_3_cards
	cp 9
	jr c, .check_energy_cards

; more than 8 cards
	ld a, [wce06]
	sub $1e
	ld [wce06], a

.check_energy_cards
	farcall CreateEnergyCardListFromHand
	jr nc, .handle_blastoise

; no energy cards in hand
	ld a, [wce06]
	add $28
	ld [wce06], a

.handle_blastoise
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .check_hand

; no Muk in Play Area
	ld a, BLASTOISE
	call CountPokemonIDInPlayArea
	jr nc, .check_hand

; at least one Blastoise in AI Play Area
	ld a, WATER_ENERGY
	farcall LookForCardIDInHand
	jr nc, .check_hand

; no Water energy in hand
	ld a, [wce06]
	add $0a
	ld [wce06], a

; this part seems buggy
; the AI loops through all the cards in hand and checks
; if any of them is not a Pokemon card and has Basic stage.
; it seems like the intention was that if there was
; any Basic Pokemon still in hand, the AI would add to the score.
.check_hand
	call CreateHandCardList
	ld hl, wDuelTempList
.loop_hand
	ld a, [hli]
	cp $ff
	jr z, .check_evolution

	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr c, .loop_hand ; bug, should be jr nc

	ld a, [wLoadedCard1Stage]
	or a
	jr nz, .loop_hand

	ld a, [wce06]
	add $0a
	ld [wce06], a

.check_evolution
	xor a
	ld [wce0f], a
	ld [wce0f + 1], a

	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA

.loop_play_area
	push de
	call .LookForEvolution
	pop de
	jr nc, .not_in_hand

; there's a card in hand that can evolve
	ld a, $01
	ld [wce0f], a

.not_in_hand
; check if a card that can evolve was found at all
; if not, go to the next card in the Play Area
	ld a, [wce08]
	cp $01
	jr nz, .next_play_area

; if it was found, set wce0f + 1 to $01
	ld a, $01
	ld [wce0f + 1], a

.next_play_area
	inc e
	dec d
	jr nz, .loop_play_area

; if a card was found that evolves...
	ld a, [wce0f + 1]
	or a
	jr z, .check_score

; ...but that card is not in the hand...
	ld a, [wce0f]
	or a
	jr nz, .check_score

; ...add to the score
	ld a, [wce06]
	add $0a
	ld [wce06], a

; only return carry if score >  $3c
.check_score
	ld a, [wce06]
	ld b, $3c
	cp b
	jr nc, .set_carry
	or a
	ret

.set_carry
	scf
	ret
; 0x20d9d

; return carry if there's a card in the hand that
; can evolve the card in Play Area location in e.
; sets wce08 to $01 if any card is found that can
; evolve regardless of card location.
.LookForEvolution ; 20d9d (8:4d9d)
	xor a
	ld [wce08], a
	ld d, 0

; loop through the whole deck to check if there's
; a card that can evolve this Pokemon.
.loop_deck_evolution
	push de
	call CheckIfCanEvolveInto
	pop de
	jr nc, .can_evolve
.evolution_not_in_hand
	inc d
	ld a, DECK_SIZE
	cp d
	jr nz, .loop_deck_evolution

	or a
	ret

; a card was found that can evolve, set wce08 to $01
; and if the card is in the hand, return carry.
; otherwise resume looping through deck.
.can_evolve
	ld a, $01
	ld [wce08], a
	ld a, DUELVARS_CARD_LOCATIONS
	add d
	call GetTurnDuelistVariable
	cp CARD_LOCATION_HAND
	jr nz, .evolution_not_in_hand

	scf
	ret
; 0x20dc3

; handles Legendary Articuno Deck AI logic.
.HandleLegendaryArticunoDeck ; 20dc3 (8:4dc3)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 3
	jr nc, .check_playable_cards

; has less than 3 Pokemon in Play Area.
	push af
	call CreateHandCardList
	pop af
	ld d, a
	ld e, PLAY_AREA_ARENA

; if no cards in hand evolve cards in Play Area,
; returns carry.
.loop_play_area_articuno
	ld a, DUELVARS_ARENA_CARD
	add e

	push de
	call GetTurnDuelistVariable
	farcall CheckForEvolutionInList
	pop de
	jr c, .check_playable_cards

	inc e
	ld a, d
	cp e
	jr nz, .loop_play_area_articuno

.set_carry_articuno
	scf
	ret

; if there are more than 3 energy cards in hand,
; return no carry, otherwise check for playable cards.
.check_playable_cards
	call CountEnergyCardsInHand
	cp 4
	jr nc, .no_carry_articuno

; remove both Professor Oak cards from list
; before checking for playable cards
	call CreateHandCardList
	ld hl, wDuelTempList
	ld e, PROFESSOR_OAK
	farcall RemoveCardIDInList
	ld e, PROFESSOR_OAK
	farcall RemoveCardIDInList

; look in hand for cards that can be played.
; if a card that cannot be played is found, return no carry.
; otherwise return carry.
.loop_hand_articuno
	ld a, [hli]
	cp $ff
	jr z, .set_carry_articuno
	push hl
	farcall CheckIfCardCanBePlayed
	pop hl
	jr c, .loop_hand_articuno

.no_carry_articuno
	or a
	ret
; 0x20e11

; handles Excavation deck AI logic.
; sets score depending on whether there's no
; Mysterious Fossil in play and in hand.
.HandleExcavationDeck ; 20e11 (8:4e11)
; return no carry if cards in deck < 15
	ld a, [hl]
	cp 46
	ret nc

; look for Mysterious Fossil
	ld a, MYSTERIOUS_FOSSIL
	call LookForCardIDInHandAndPlayArea
	jr c, .found_mysterious_fossil
	ld a, $50
	ld [wce06], a
	jp .check_cards_hand
.found_mysterious_fossil
	ld a, $1e
	ld [wce06], a
	jp .check_cards_hand
; 0x20e2c

; handles Wonders of Science AI logic.
; if there's either Grimer or Muk in hand,
; do not play Professor Oak.
.HandleWondersOfScienceDeck ; 20e2c (8:4e2c)
	ld a, GRIMER
	call LookForCardIDInHandList_Bank8
	jr c, .found_grimer_or_muk
	ld a, MUK
	call LookForCardIDInHandList_Bank8
	jr c, .found_grimer_or_muk

	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	jp .check_cards_deck

.found_grimer_or_muk
	or a
	ret
; 0x20e44

AIPlayEnergyRetrieval: ; 20e44 (8:4e44)
	ld a, [wce21]
	or $08
	ld [wce21], a
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTemp_ffa0], a
	ld a, [wce1a]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, [wce1b]
	ldh [hTempRetreatCostCards], a
	cp $ff
	jr z, .asm_20e68
	ld a, $ff
	ldh [$ffa3], a
.asm_20e68
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x20e6e

; checks whether AI can play Energy Retrieval and
; picks the energy cards from the discard pile,
; and duplicate cards in hand to discard.
CheckEnergyRetrievalCardsToPick: ; 20e6e (8:4e6e)
; return no carry if no cards in hand
	farcall CreateEnergyCardListFromHand
	jp nc, .no_carry

; handle Go Go Rain Dance deck
; return no carry if there's no Muk card in play and
; if there's no Blastoise card in Play Area
; if there's a Muk in play, continue as normal
	ld a, [wOpponentDeckID]
	cp GO_GO_RAIN_DANCE_DECK_ID
	jr nz, .start
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .start
	ld a, BLASTOISE
	call CountPokemonIDInPlayArea
	jp nc, .no_carry

.start
; find duplicate cards in hand
	call CreateHandCardList
	ld hl, wDuelTempList
	call CheckDuplicatePokemonAndNonPokemonCards
	jp c, .no_carry

	ld [wce06], a
	ld a, CARD_LOCATION_DISCARD_PILE
	call FindBasicEnergyCardsInLocation
	jp c, .no_carry

; some basic energy cards were found in Discard Pile
	ld a, $ff
	ld [wce1a], a
	ld [wce1b], a
	ld [wce1c], a

	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA

; first check if there are useful energy cards in the list
; and choose them for retrieval first
.loop_play_area
	ld a, DUELVARS_ARENA_CARD
	add e
	push de

; load this card's ID in wTempCardID
; and this card's Type in wTempCardType
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempCardID], a
	call LoadCardDataToBuffer1_FromCardID
	pop de
	ld a, [wLoadedCard1Type]
	or TYPE_ENERGY
	ld [wTempCardType], a

; loop the energy cards in the Discard Pile
; and check if they are useful for this Pokemon
	ld hl, wDuelTempList
.loop_energy_cards_1
	ld a, [hli]
	cp $ff
	jr z, .next_play_area

	ld b, a
	push hl
	farcall CheckIfEnergyIsUseful
	pop hl
	jr nc, .loop_energy_cards_1

	ld a, [wce1a]
	cp $ff
	jr nz, .second_energy_1

; check if there were already chosen cards,
; if this is the second chosen card, return carry

; first energy card found
	ld a, b
	ld [wce1a], a
	call RemoveCardFromList
	jr .next_play_area
.second_energy_1
	ld a, b
	ld [wce1b], a
	jr .set_carry

.next_play_area
	inc e
	dec d
	jr nz, .loop_play_area

; next, if there are still energy cards left to choose,
; loop through the energy cards again and select
; them in order.
	ld hl, wDuelTempList
.loop_energy_cards_2
	ld a, [hli]
	cp $ff
	jr z, .check_chosen
	ld b, a
	ld a, [wce1a]
	cp $ff
	jr nz, .second_energy_2
	ld a, b
	ld [wce1a], a
	call RemoveCardFromList
	jr .loop_energy_cards_2

.second_energy_2
	ld a, b
	ld [wce1b], a
	jr .set_carry

; will set carry if at least one has been chosen
.check_chosen
	ld a, [wce1a]
	cp $ff
	jr nz, .set_carry
.no_carry
	or a
	ret

.set_carry
	ld a, [wce06]
	scf
	ret
; 0x20f27

; remove an element from the list
; and shortens it accordingly
; input:
;   hl = pointer to element to remove
RemoveCardFromList: ; 20f27 (8:4f27)
	push de
	ld d, h
	ld e, l
	dec hl
	push hl
.loop_remove
	ld a, [de]
	ld [hli], a
	cp $ff
	jr z, .done_remove
	inc de
	jr .loop_remove
.done_remove
	pop hl
	pop de
	ret
; 0x20f38

; returns carry if duplicate cards are found for
; at least one Pokemon card and at least one Non-Pokemon card
; input:
;   hl = list to look in
; output:
;   a = deck index of duplicate non-Pokemon card
CheckDuplicatePokemonAndNonPokemonCards: ; 20f38 (8:4f38)
	ld a, $ff
	ld [wce0f], a
	ld [wce0f + 1], a
	push hl

.loop_outer
; get ID of current card
	pop hl
	ld a, [hli]
	cp $ff
	jr z, .check_found
	call GetCardIDFromDeckIndex
	ld b, e
	push hl

; loop the rest of the list to find
; another card with the same ID
.loop_inner
	ld a, [hli]
	cp $ff
	jr z, .loop_outer
	ld c, a
	call GetCardIDFromDeckIndex
	ld a, e
	cp b
	jr nz, .loop_inner

; found two cards with same ID
	push bc
	call GetCardType
	pop bc
	cp TYPE_ENERGY
	jr c, .not_energy

; they are energy or trainer cards
; loads wce0f+1 with this card deck index
	ld a, c
	ld [wce0f + 1], a
	jr .loop_outer

.not_energy
; they are Pokemon cards
; loads wce0f with this card deck index
	ld a, c
	ld [wce0f], a
	jr .loop_outer

.check_found
	ld a, [wce0f]
	cp $ff
	jr nz, .no_carry
	ld a, [wce0f + 1]
	cp $ff
	jr nz, .no_carry

; only set carry if duplicate cards were found
; for both Pokemon and Non-Pokemon cards
	scf
	ret

.no_carry
; two cards with the same ID were not found
; of either Pokemon and Non-Pokemon cards
	or a
	ret
; 0x20f80

AIPlaySuperEnergyRetrieval: ; 20f80 (8:4f80)
	ld a, [wce21]
	or $08
	ld [wce21], a
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTemp_ffa0], a
	ld a, [wce1a]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, [wce1b]
	ldh [hTempRetreatCostCards], a
	ld a, [wce1c]
	ldh [$ffa3], a
	cp $ff
	jr z, .asm_20fbb
	ld a, [wce1d]
	ldh [$ffa4], a
	cp $ff
	jr z, .asm_20fbb
	ld a, [wce1e]
	ldh [$ffa5], a
	cp $ff
	jr z, .asm_20fbb
	ld a, $ff
	ldh [$ffa6], a
.asm_20fbb
	ld a, $07
	bank1call AIMakeDecision
	ret
; 0x20fc1

CheckSuperEnergyRetrievalCardsToPick: ; 20fc1 (8:4fc1)
; return no carry if no cards in hand
	farcall CreateEnergyCardListFromHand
	jp nc, .no_carry

; handle Go Go Rain Dance deck
; return no carry if there's no Muk card in play and
; if there's no Blastoise card in Play Area
; if there's a Muk in play, continue as normal
	ld a, [wOpponentDeckID]
	cp GO_GO_RAIN_DANCE_DECK_ID
	jr nz, .start
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .start
	ld a, BLASTOISE
	call CountPokemonIDInPlayArea
	jp nc, .no_carry

.start
; find duplicate cards in hand
	call CreateHandCardList
	ld hl, wDuelTempList
	call CheckDuplicatePokemonAndNonPokemonCards
	jp c, .no_carry

; remove the duplicate non-Pokemon card in hand
; and run the hand check again
	ld [wce06], a
	ld hl, wDuelTempList
	call .RemoveDuplicateCardFromHandList
	call CheckDuplicatePokemonAndNonPokemonCards
	jp c, .no_carry

	ld [wce08], a
	ld a, CARD_LOCATION_DISCARD_PILE
	call FindBasicEnergyCardsInLocation
	jp c, .no_carry

; some basic energy cards were found in Discard Pile
	ld a, $ff
	ld [wce1b], a
	ld [wce1c], a
	ld [wce1d], a
	ld [wce1e], a
	ld [wce1f], a

	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA

; first check if there are useful energy cards in the list
; and choose them for retrieval first
.loop_play_area
	ld a, DUELVARS_ARENA_CARD
	add e
	push de

; load this card's ID in wTempCardID
; and this card's Type in wTempCardType
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempCardID], a
	call LoadCardDataToBuffer1_FromCardID
	pop de
	ld a, [wLoadedCard1Type]
	or TYPE_ENERGY
	ld [wTempCardType], a

; loop the energy cards in the Discard Pile
; and check if they are useful for this Pokemon
	ld hl, wDuelTempList
.loop_energy_cards_1
	ld a, [hli]
	cp $ff
	jr z, .next_play_area

	ld b, a
	push hl
	farcall CheckIfEnergyIsUseful
	pop hl
	jr nc, .loop_energy_cards_1

; first energy
	ld a, [wce1b]
	cp $ff
	jr nz, .second_energy_1
	ld a, b
	ld [wce1b], a
	call RemoveCardFromList
	jr .next_play_area

.second_energy_1
	ld a, [wce1c]
	cp $ff
	jr nz, .third_energy_1
	ld a, b
	ld [wce1c], a
	call RemoveCardFromList
	jr .next_play_area

.third_energy_1
	ld a, [wce1d]
	cp $ff
	jr nz, .fourth_energy_1
	ld a, b
	ld [wce1d], a
	call RemoveCardFromList
	jr .next_play_area

.fourth_energy_1
	ld a, b
	ld [wce1e], a
	jr .set_carry

.next_play_area
	inc e
	dec d
	jr nz, .loop_play_area

; next, if there are still energy cards left to choose,
; loop through the energy cards again and select
; them in order.
	ld hl, wDuelTempList
.loop_energy_cards_2
	ld a, [hli]
	cp $ff
	jr z, .check_chosen
	ld b, a
	ld a, [wce1b]
	cp $ff
	jr nz, .second_energy_2
	ld a, b

; first energy
	ld [wce1b], a
	call RemoveCardFromList
	jr .loop_energy_cards_2

.second_energy_2
	ld a, [wce1c]
	cp $ff
	jr nz, .third_energy_2
	ld a, b
	ld [wce1c], a
	call RemoveCardFromList
	jr .loop_energy_cards_2

.third_energy_2
	ld a, [wce1d]
	cp $ff
	jr nz, .fourth_energy
	ld a, b
	ld [wce1d], a
	call RemoveCardFromList
	jr .loop_energy_cards_2

.fourth_energy
	ld a, b
	ld [wce1e], a
	jr .set_carry

; will set carry if at least one has been chosen
.check_chosen
	ld a, [wce1b]
	cp $ff
	jr nz, .set_carry

.no_carry
	or a
	ret
.set_carry
	ld a, [wce08]
	ld [wce1a], a
	ld a, [wce06]
	scf
	ret
; 0x210d5

; finds the energy card that was found to be a duplicate
; and removes it from the hand card list.
.RemoveDuplicateCardFromHandList ; 210d5 (8:50d5)
	push hl
	ld b, a
.loop_duplicate
	ld a, [hli]
	cp b
	jr nz, .loop_duplicate
	call RemoveCardFromList
	pop hl
	ret
; 0x210e0

AIPlayPokemonCenter: ; 210e0 (8:50e0)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x210eb

CheckIfCanPlayPokemonCenter: ; 210eb (8:50eb)
	xor a
	ldh [hTempPlayAreaLocation_ff9d], a

; return if active Pokemon can KO player's card.
	farcall CheckIfAnyMoveKnocksOutDefendingCard
	jr nc, .start
	farcall CheckIfSelectedMoveIsUnusable
	jr nc, .no_carry
	farcall LookForEnergyNeededForMoveInHand
	jr c, .no_carry

.start
	xor a
	ld [wce06], a
	ld [wce08], a
	ld [wce0f], a

	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA

.loop_play_area
	ld a, DUELVARS_ARENA_CARD
	add e
	push de
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, e
	pop de

; get this Pokemon's current HP in number of counters
; and add it to the total.
	ld a, [wLoadedCard1HP]
	call ConvertHPToCounters
	ld b, a
	ld a, [wce06]
	add b
	ld [wce06], a

; get this Pokemon's current damage counters
; and add it to the total.
	call GetCardDamage
	call ConvertHPToCounters
	ld b, a
	ld a, [wce08]
	add b
	ld [wce08], a

; get this Pokemon's number of attached energy cards
; and add it to the total.
; if there's overflow, return no carry.
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	ld b, a
	ld a, [wce0f]
	add b
	jr c, .no_carry
	ld [wce0f], a

	inc e
	dec d
	jr nz, .loop_play_area

; if (number of damage counters / 2) < (total energy cards attached)
; return no carry.
	ld a, [wce08]
	srl a
	ld hl, wce0f
	cp [hl]
	jr c, .no_carry

; if (number of HP counters * 6 / 10) >= (number of damage counters)
; return no carry.
	ld a, [wce06]
	ld l, a
	ld h, 6
	call HtimesL
	call CalculateWordTensDigit
	ld a, l
	ld hl, wce08
	cp [hl]
	jr nc, .no_carry

	scf
	ret

.no_carry
	or a
	ret
; 0x21170

AIPlayImposterProfessorOak: ; 21170 (8:5170)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x2117b

; sets carry depending on player's number of cards
; in deck in in hand.
CheckWhetherToPlayImposterProfessorOak: ; 2117b (8:517b)
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetNonTurnDuelistVariable
	cp DECK_SIZE - 14
	jr c, .more_than_14_cards

; if player has less than 14 cards in deck, only
; set carry if number of cards in their hands < 6
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetNonTurnDuelistVariable
	cp 6
	jr c, .set_carry
.no_carry
	or a
	ret

; if player has more than 14 cards in deck, only
; set carry if number of cards in their hands >= 9
.more_than_14_cards
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetNonTurnDuelistVariable
	cp 9
	jr c, .no_carry
.set_carry
	scf
	ret
; 0x2119a

AIPlayEnergySearch: ; 2119a (8:519a)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTemp_ffa0], a
	ld a, $07
	bank1call AIMakeDecision
	ret
; 0x211aa

; AI checks for playing Energy Search
CheckIfEnergySearchCanBePlayed: ; 211aa (8:51aa)
	farcall CreateEnergyCardListFromHand
	jr c, .start
	call .CheckForUsefulEnergyCards
	jr c, .start

; there are energy cards in hand and at least
; one of them is useful to a card in Play Area
.no_carry
	or a
	ret

.start
	ld a, [wOpponentDeckID]
	cp HEATED_BATTLE_DECK_ID
	jr z, .heated_battle
	cp WONDERS_OF_SCIENCE_DECK_ID
	jr z, .wonders_of_science

; if no energy cards in deck, return no carry
	ld a, CARD_LOCATION_DECK
	call FindBasicEnergyCardsInLocation
	jr c, .no_carry

; if any of the energy cards in deck is useful
; return carry right away...
	call .CheckForUsefulEnergyCards
	jr c, .no_useful
	scf
	ret

; ...otherwise save the list in a before return carry.
.no_useful
	ld a, [wDuelTempList]
	scf
	ret

; Heated Battle deck only searches for Fire and Lightning
; if they are found to be useful to some card in Play Area
.heated_battle
	ld a, CARD_LOCATION_DECK
	call FindBasicEnergyCardsInLocation
	jr c, .no_carry
	call .CheckUsefulFireOrLightningEnergy
	jr c, .no_carry
	scf
	ret

; this subroutine has a bug.
; it was supposed to use the .CheckUsefulGrassEnergy subroutine
; but uses .CheckUsefulFireOrLightningEnergy instead.
.wonders_of_science
	ld a, CARD_LOCATION_DECK
	call FindBasicEnergyCardsInLocation
	jr c, .no_carry
	call .CheckUsefulFireOrLightningEnergy
	jr c, .no_carry
	scf
	ret
; 0x211f1

; return carry if cards in wDuelTempList are not
; useful to any of the Play Area Pokemon
.CheckForUsefulEnergyCards ; 211f1 (8:51f1)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA

.loop_play_area_1
	ld a, DUELVARS_ARENA_CARD
	add e
	push de
	call GetTurnDuelistVariable

; store ID and type of card
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempCardID], a
	call LoadCardDataToBuffer1_FromCardID
	pop de
	ld a, [wLoadedCard1Type]
	or TYPE_ENERGY
	ld [wTempCardType], a

; look in list for a useful energy,
; is any is found return no carry.
	ld hl, wDuelTempList
.loop_energy_1
	ld a, [hli]
	cp $ff
	jr z, .none_found
	ld b, a
	push hl
	farcall CheckIfEnergyIsUseful
	pop hl
	jr nc, .loop_energy_1

	ld a, b
	or a
	ret

.none_found
	inc e
	ld a, e
	cp d
	jr nz, .loop_play_area_1

	scf
	ret
; 0x2122e

; checks whether there are useful energies
; only for Fire and Lightning type Pokemon cards
; in Play Area. If none found, return carry.
.CheckUsefulFireOrLightningEnergy ; 2122e (8:522e)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA

.loop_play_area_2
	ld a, DUELVARS_ARENA_CARD
	add e
	push de
	call GetTurnDuelistVariable

; get card's ID and Type
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempCardID], a
	call LoadCardDataToBuffer1_FromCardID
	pop de
	ld a, [wLoadedCard1Type]
	or TYPE_ENERGY

; only do check if the Pokemon's type
; is either Fire or Lightning
	cp TYPE_ENERGY_FIRE
	jr z, .fire_or_lightning
	cp TYPE_ENERGY_LIGHTNING
	jr nz, .next_play_area

; loop each energy card in list
.fire_or_lightning
	ld [wTempCardType], a
	ld hl, wDuelTempList
.loop_energy_2
	ld a, [hli]
	cp $ff
	jr z, .next_play_area

; if this energy card is useful,
; return no carry.
	ld b, a
	push hl
	farcall CheckIfEnergyIsUseful
	pop hl
	jr nc, .loop_energy_2

	ld a, b
	or a
	ret

.next_play_area
	inc e
	ld a, e
	cp d
	jr nz, .loop_play_area_2

; no card was found to be useful
; for Fire/Lightning type Pokemon card.
	scf
	ret
; 0x21273

; checks whether there are useful energies
; only for Grass type Pokemon cards
; in Play Area. If none found, return carry.
.CheckUsefulGrassEnergy ; 21273 (8:5273)
; unreferenced
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA

.loop_play_area_3
	ld a, DUELVARS_ARENA_CARD
	add e
	push de
	call GetTurnDuelistVariable

; get card's ID and Type
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempCardID], a
	call LoadCardDataToBuffer1_FromCardID
	pop de
	ld a, [wLoadedCard1Type]
	or TYPE_ENERGY

; only do check if the Pokemon's type is Grass
	cp TYPE_ENERGY_GRASS
	jr nz, .next_play_area_3

; loop each energy card in list
	ld [wTempCardType], a
	ld hl, wDuelTempList
.loop_energy_3
	ld a, [hli]
	cp $ff
	jr z, .next_play_area_3

; if this energy card is useful,
; return no carry.
	ld b, a
	push hl
	farcall CheckIfEnergyIsUseful
	pop hl
	jr nc, .loop_energy_3

	ld a, b
	or a
	ret

.next_play_area_3
	inc e
	ld a, e
	cp d
	jr nz, .loop_play_area_3

; no card was found to be useful
; for Grass type Pokemon card.
	scf
	ret
; 0x212b4

AIPlayPokedex: ; 212b4 (8:52b4)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce1a]
	ldh [hTemp_ffa0], a
	ld a, [wce1b]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, [wce1c]
	ldh [hTempRetreatCostCards], a
	ld a, [wce1d]
	ldh [$ffa3], a
	ld a, [wce1e]
	ldh [$ffa4], a
	ld a, $ff
	ldh [$ffa5], a
	ld a, $07
	bank1call AIMakeDecision
	ret
; 0x212dc

CheckWhetherToPlayPokedex: ; 212dc (8:52dc)
	ld a, [wcda6]
	cp $06
	jr c, .no_carry

; return no carry if number of cards in deck <= 4
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE - 4
	jr nc, .no_carry

; has a 3 in 10 chance of actually playing card
	ld a, 10
	call Random
	cp 3
	jr c, .pick_cards

.no_carry
	or a
	ret

.pick_cards
; the following comparison is disregarded
; the Wonders of Science deck was probably intended
; to use PickPokedexCards_Unreferenced instead
	ld a, [wOpponentDeckID]
	cp WONDERS_OF_SCIENCE_DECK_ID
	jp PickPokedexCards ; bug, should be jp nz
; 0x212ff

; picks order of the cards in deck from the effects of Pokedex.
; prioritises Pokemon cards, then Trainer cards, then energy cards.
; stores the resulting order in wce1a.
PickPokedexCards_Unreferenced: ; 212ff (8:52ff)
; unreferenced
	xor a
	ld [wcda6], a

	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	add DUELVARS_DECK_CARDS
	ld l, a
	lb de, $00, $00
	ld b, 5

; run through 5 of the remaining cards in deck
.next_card
	ld a, [hli]
	ld c, a
	call .GetCardType

; load this card's deck index and type in memory
; wce08 = card types
; wce0f = card deck indices
	push hl
	ld hl, wce08
	add hl, de
	ld [hl], a
	ld hl, wce0f
	add hl, de
	ld [hl], c
	pop hl

	inc e
	dec b
	jr nz, .next_card

; terminate the wce08 list
	ld a, $ff
	ld [wce08 + 5], a

	ld de, wce1a

; find Pokemon
	ld hl, wce08
	ld c, -1
	ld b, $00

; run through the stored cards
; and look for any Pokemon cards.
.loop_pokemon
	inc c
	ld a, [hli]
	cp $ff
	jr z, .find_trainers
	cp TYPE_ENERGY
	jr nc, .loop_pokemon
; found a Pokemon card
; store it in wce1a list
	push hl
	ld hl, wce0f
	add hl, bc
	ld a, [hl]
	pop hl
	ld [de], a
	inc de
	jr .loop_pokemon

; run through the stored cards
; and look for any Trainer cards.
.find_trainers
	ld hl, wce08
	ld c, -1
	ld b, $00

.loop_trainers
	inc c
	ld a, [hli]
	cp $ff
	jr z, .find_energy
	cp TYPE_TRAINER
	jr nz, .loop_trainers
; found a Trainer card
; store it in wce1a list
	push hl
	ld hl, wce0f
	add hl, bc
	ld a, [hl]
	pop hl
	ld [de], a
	inc de
	jr .loop_trainers

.find_energy
	ld hl, wce08
	ld c, -1
	ld b, $00

; run through the stored cards
; and look for any energy cards.
.loop_energy
	inc c
	ld a, [hli]
	cp $ff
	jr z, .done
	and TYPE_ENERGY
	jr z, .loop_energy
; found an energy card
; store it in wce1a list
	push hl
	ld hl, wce0f
	add hl, bc
	ld a, [hl]
	pop hl
	ld [de], a
	inc de
	jr .loop_energy

.done
	scf
	ret
; 0x21383

.GetCardType ; 21383 (8:5383)
	push bc
	push de
	call GetCardIDFromDeckIndex
	call GetCardType
	pop de
	pop bc
	ret
; 0x2138e

; picks order of the cards in deck from the effects of Pokedex.
; prioritises energy cards, then Pokemon cards, then Trainer cards.
; stores the resulting order in wce1a.
PickPokedexCards: ; 2138e (8:538e)
	xor a
	ld [wcda6], a

	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	add DUELVARS_DECK_CARDS
	ld l, a
	lb de, $00, $00
	ld b, 5

; run through 5 of the remaining cards in deck
.next_card
	ld a, [hli]
	ld c, a
	call .GetCardType

; load this card's deck index and type in memory
; wce08 = card types
; wce0f = card deck indices
	push hl
	ld hl, wce08
	add hl, de
	ld [hl], a
	ld hl, wce0f
	add hl, de
	ld [hl], c
	pop hl

	inc e
	dec b
	jr nz, .next_card

; terminate the wce08 list
	ld a, $ff
	ld [wce08 + 5], a

	ld de, wce1a

; find energy
	ld hl, wce08
	ld c, -1
	ld b, $00

; run through the stored cards
; and look for any energy cards.
.loop_energy
	inc c
	ld a, [hli]
	cp $ff
	jr z, .find_pokemon
	and TYPE_ENERGY
	jr z, .loop_energy
; found an energy card
; store it in wce1a list
	push hl
	ld hl, wce0f
	add hl, bc
	ld a, [hl]
	pop hl
	ld [de], a
	inc de
	jr .loop_energy

.find_pokemon
	ld hl, wce08
	ld c, -1
	ld b, $00

; run through the stored cards
; and look for any Pokemon cards.
.loop_pokemon
	inc c
	ld a, [hli]
	cp $ff
	jr z, .find_trainers
	cp TYPE_ENERGY
	jr nc, .loop_pokemon
; found a Pokemon card
; store it in wce1a list
	push hl
	ld hl, wce0f
	add hl, bc
	ld a, [hl]
	pop hl
	ld [de], a
	inc de
	jr .loop_pokemon

; run through the stored cards
; and look for any Trainer cards.
.find_trainers
	ld hl, wce08
	ld c, -1
	ld b, $00

.loop_trainers
	inc c
	ld a, [hli]
	cp $ff
	jr z, .done
	cp TYPE_TRAINER
	jr nz, .loop_trainers
; found a Trainer card
; store it in wce1a list
	push hl
	ld hl, wce0f
	add hl, bc
	ld a, [hl]
	pop hl
	ld [de], a
	inc de
	jr .loop_trainers

.done
	scf
	ret
; 0x21412

.GetCardType ; 21412 (8:5412)
	push bc
	push de
	call GetCardIDFromDeckIndex
	call GetCardType
	pop de
	pop bc
	ret
; 0x2141d

AIPlayFullHeal: ; 2141d (8:541d)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x21428

CheckWhetherToPlayFullHeal: ; 21428 (8:5428)
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable

; skip if no status on arena card
	or a ; NO_STATUS
	jr z, .no_carry

	and CNF_SLP_PRZ
	cp PARALYZED
	jr z, .paralyzed
	cp ASLEEP
	jr z, .asleep
	cp CONFUSED
	jr z, .confused
	; if either PSN or DBLPSN, fallthrough

.set_carry
	scf
	ret

.asleep
; set carry if any of the following
; cards are in the Play Area.
	ld a, GASTLY1
	ld b, PLAY_AREA_ARENA
	call LookForCardIDInPlayArea_Bank8
	jr c, .set_carry
	ld a, GASTLY2
	ld b, PLAY_AREA_ARENA
	call LookForCardIDInPlayArea_Bank8
	jr c, .set_carry
	ld a, HAUNTER2
	ld b, PLAY_AREA_ARENA
	call LookForCardIDInPlayArea_Bank8
	jr c, .set_carry

; otherwise fallthrough

.paralyzed
; if Scoop Up is in hand and decided to be played, skip.
	ld a, SCOOP_UP
	call LookForCardIDInHandList_Bank8
	jr nc, .no_scoop_up_prz
	call Func_21506
	jr c, .no_carry

.no_scoop_up_prz
; if card can damage defending Pokemon...
	xor a ; PLAY_AREA_ARENA
	farcall CheckIfCanDamageDefendingPokemon
	jr nc, .no_carry
; ...and can play an energy card to retreat, set carry.
	ld a, [wAIPlayEnergyCardForRetreat]
	or a
	jr nz, .set_carry

; if not, check whether it's a card it would rather retreat,
; and if it isn't, set carry.
	farcall AIDecideWhetherToRetreat
	jr nc, .set_carry

.no_carry
	or a
	ret

.confused
; if Scoop Up is in hand and decided to be played, skip.
	ld a, SCOOP_UP
	call LookForCardIDInHandList_Bank8
	jr nc, .no_scoop_up_cnf
	call Func_21506
	jr c, .no_carry

.no_scoop_up_cnf
; if card can damage defending Pokemon...
	xor a ; PLAY_AREA_ARENA
	farcall CheckIfCanDamageDefendingPokemon
	jr nc, .no_carry
; ...and can play an energy card to retreat, set carry.
	ld a, [wAIPlayEnergyCardForRetreat]
	or a
	jr nz, .set_carry
; if not, return no carry.
	jr .no_carry
; 0x21497

AIPlayMrFuji: ; 21497 (8:5497)
	ld a, [wce16]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wce19]
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_EXECUTE_TRAINER_EFFECTS
	bank1call AIMakeDecision
	ret
; 0x214a7

; AI logic for playing Mr Fuji
CheckWetherToPlayMrFuji: ; 214a7 (8:54a7)
	ld a, $ff
	ld [wce06], a
	ld [wce08], a

; if just one Pokemon in Play Area, skip.
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 1
	ret z

	dec a
	ld d, a
	ld e, PLAY_AREA_BENCH_1

; find a Pokemon in the bench that has damage counters.
.loop_bench
	ld a, DUELVARS_ARENA_CARD
	add e
	push de
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	pop de

	ld a, [wLoadedCard1HP]
	ld b, a

	; skip if zero damage counters
	call GetCardDamage
	call ConvertHPToCounters
	or a
	jr z, .next

; a = damage counters
; b = hp left
	call CalculateBDividedByA_Bank8
	cp 20
	jr nc, .next

; here, HP left in counters is less than twice
; the number of damage counters, that is:
; HP < 1/3 max HP

; if value is less than the one found before, store this one.
	ld hl, wce08
	cp [hl]
	jr nc, .next
	ld [hl], a
	ld a, e
	ld [wce06], a
.next
	inc e
	dec d
	jr nz, .loop_bench

	ld a, [wce06]
	cp $ff
	ret z

	scf
	ret
; 0x214f1

	INCROM $214f1, $21506

Func_21506: ; 21506 (8:5506)
	INCROM $21506, $227f6

; lists in wDuelTempList all the basic energy cards
; is card location of a.
; returns carry if none were found.
; input:
;   a = CARD_LOCATION_* to look
FindBasicEnergyCardsInLocation: ; 227f6 (8:67f6)
	ld [wTempAI], a
	lb de, 0, 0
	ld hl, wDuelTempList

; d = number of basic energy cards found
; e = current card in deck
; loop entire deck
.loop
	ld a, DUELVARS_CARD_LOCATIONS
	add e
	push hl
	call GetTurnDuelistVariable
	ld hl, wTempAI
	cp [hl]
	pop hl
	jr nz, .next_card

; is in the card location we're looking for
	ld a, e
	push de
	push hl
	call GetCardIDFromDeckIndex
	pop hl
	ld a, e
	pop de
	cp DOUBLE_COLORLESS_ENERGY
	; only basic energy cards
	; will set carry here
	jr nc, .next_card

; is a basic energy card
; add this card to the TempList
	ld a, e
	ld [hli], a
	inc d
.next_card
	inc e
	ld a, DECK_SIZE
	cp e
	jr nz, .loop

; check if any were found
	ld a, d
	or a
	jr z, .set_carry

; some were found, add the termination byte on TempList
	ld a, $ff
	ld [hl], a
	ld a, d
	ret

.set_carry
	scf
	ret
; 0x2282e

; returns in a the card index of energy card
; attached to Pokémon in Play Area location a,
; that is to be discarded.
GetEnergyCardToDiscard: ; 2282e (8:682e)
; load Pokémon's attached energy cards.
	ldh [hTempPlayAreaLocation_ff9d], a
	call CreateArenaOrBenchEnergyCardList
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	or a
	jr z, .no_energy

; load card's ID and type.
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	add b
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempCardID], a
	call LoadCardDataToBuffer1_FromCardID
	ld a, [wLoadedCard1Type]
	or TYPE_ENERGY
	ld [wTempCardType], a

; find a card that is not useful.
; if none is found, just return the first energy card attached.
	ld hl, wDuelTempList
.loop
	ld a, [hl]
	cp $ff
	jr z, .not_found
	farcall CheckIfEnergyIsUseful
	jr nc, .found
	inc hl
	jr .loop

.found
	ld a, [hl]
	ret
.not_found
	ld hl, wDuelTempList
	ld a, [hl]
	ret
.no_energy
	ld a, $ff
	ret
; 0x22875

; returns in a the deck index of an energy card attached to card
; in Play Area location a..
; prioritises double colorless energy, then any useful energy,
; then defaults to the first energy card attached if neither
; of those are found.
; returns $ff in a if there are no energy cards attached.
; input:
;   a = Play Area location to check
; output:
;   a = deck index of attached energy card
PickAttachedEnergyCard: ; 22875 (8:6875)
; construct energy list and check if there are any energy cards attached
	ldh [hTempPlayAreaLocation_ff9d], a
	call CreateArenaOrBenchEnergyCardList
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	or a
	jr z, .no_energy

; load card data and store its type
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	add b
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempCardID], a
	call LoadCardDataToBuffer1_FromCardID
	ld a, [wLoadedCard1Type]
	or TYPE_ENERGY
	ld [wTempCardType], a

; first look for any double colorless energy
	ld hl, wDuelTempList
.loop_1
	ld a, [hl]
	cp $ff
	jr z, .check_useful
	push hl
	call GetCardIDFromDeckIndex
	ld a, e
	cp DOUBLE_COLORLESS_ENERGY
	pop hl
	jr z, .found
	inc hl
	jr .loop_1

; then look for any energy cards that are useful
.check_useful
	ld hl, wDuelTempList
.loop_2
	ld a, [hl]
	cp $ff
	jr z, .default
	farcall CheckIfEnergyIsUseful
	jr c, .found
	inc hl
	jr .loop_2

; return the energy card that was found
.found
	ld a, [hl]
	ret

; if none were found with the above criteria,
; just return the first option
.default
	ld hl, wDuelTempList
	ld a, [hl]
	ret

; return $ff if no energy cards attached
.no_energy
	ld a, $ff
	ret
; 0x228d1

; stores in wTempAI and wCurCardCanAttack the deck indices
; of energy cards attached to card in Play Area location a.
; prioritises double colorless energy, then any useful energy,
; then defaults to the first two energy cards attached if neither
; of those are found.
; returns $ff in a if there are no energy cards attached.
; input:
;   a = Play Area location to check
; output:
;   [wTempAI] = deck index of attached energy card
;   [wCurCardCanAttack] = deck index of attached energy card
PickTwoAttachedEnergyCards: ; 228d1 (8:68d1)
	ldh [hTempPlayAreaLocation_ff9d], a
	call CreateArenaOrBenchEnergyCardList
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	farcall CountNumberOfEnergyCardsAttached
	cp 2
	jp c, .not_enough

; load card data and store its type
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	add b
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempCardID], a
	call LoadCardDataToBuffer1_FromCardID
	ld a, [wLoadedCard1Type]
	or TYPE_ENERGY
	ld [wTempCardType], a
	ld a, $ff
	ld [wTempAI], a
	ld [wCurCardCanAttack], a

; first look for any double colorless energy
	ld hl, wDuelTempList
.loop_1
	ld a, [hl]
	cp $ff
	jr z, .check_useful
	push hl
	call GetCardIDFromDeckIndex
	ld a, e
	cp DOUBLE_COLORLESS_ENERGY
	pop hl
	jr z, .found_double_colorless
	inc hl
	jr .loop_1
.found_double_colorless
	ld a, [wTempAI]
	cp $ff
	jr nz, .already_chosen_1
	ld a, [hli]
	ld [wTempAI], a
	jr .loop_1
.already_chosen_1
	ld a, [hl]
	ld [wCurCardCanAttack], a
	jr .done

; then look for any energy cards that are useful
.check_useful
	ld hl, wDuelTempList
.loop_2
	ld a, [hl]
	cp $ff
	jr z, .default
	farcall CheckIfEnergyIsUseful
	jr c, .found_useful
	inc hl
	jr .loop_2
.found_useful
	ld a, [wTempAI]
	cp $ff
	jr nz, .already_chosen_2
	ld a, [hli]
	ld [wTempAI], a
	jr .loop_2
.already_chosen_2
	ld a, [hl]
	ld [wCurCardCanAttack], a
	jr .done

; if none were found with the above criteria,
; just return the first 2 options
.default
	ld hl, wDuelTempList
	ld a, [wTempAI]
	cp $ff
	jr nz, .pick_one_card

; pick 2 cards
	ld a, [hli]
	ld [wTempAI], a
	ld a, [hl]
	ld [wCurCardCanAttack], a
	jr .done
.pick_one_card
	ld a, [wTempAI]
	ld b, a
.loop_3
	ld a, [hli]
	cp b
	jr z, .loop_3 ; already picked
	ld [wCurCardCanAttack], a

.done
	ld a, [wCurCardCanAttack]
	ld b, a
	ld a, [wTempAI]
	ret

; return $ff if no energy cards attached
.not_enough
	ld a, $ff
	ret
; 0x2297b

; copies $ff terminated buffer from hl to de
CopyBuffer: ; 2297b (8:697b)
	ld a, [hli]
	ld [de], a
	cp $ff
	ret z
	inc de
	jr CopyBuffer
; 0x22983

; zeroes a bytes starting at hl
ClearMemory_Bank8: ; 22983 (8:6983)
	push af
	push bc
	push hl
	ld b, a
	xor a
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	pop hl
	pop bc
	pop af
	ret
; 0x22990

; counts number of energy cards found in hand
; and outputs result in a
; sets carry if none are found
; output:
; 	a = number of energy cards found
CountEnergyCardsInHand: ; 22990 (8:6990)
	farcall CreateEnergyCardListFromHand
	ret c
	ld b, -1
	ld hl, wDuelTempList
.loop
	inc b
	ld a, [hli]
	cp $ff
	jr nz, .loop
	ld a, b
	or a
	ret
; 0x229a3

; converts HP in a to number of equivalent damage counters
; input:
; 	a = HP
; output:
; 	a = number of damage counters
ConvertHPToCounters: ; 229a3 (8:69a3)
	push bc
	ld c, 0
.loop
	sub 10
	jr c, .carry
	inc c
	jr .loop
.carry
	ld a, c
	pop bc
	ret
; 0x229b0

; calculates floor(hl / 10)
CalculateWordTensDigit: ; 229b0 (8:69b0)
	push bc
	push de
	lb bc, $ff, -10
	lb de, $ff, -1
.asm_229b8
	inc de
	add hl, bc
	jr c, .asm_229b8
	ld h, d
	ld l, e
	pop de
	pop bc
	ret
; 0x229c1

CalculateBDividedByA_Bank8: ; 229c1 (8:69c1)
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
; 0x229d0

Func_229d0 ; 229d0 (8:69d0)
	INCROM $229d0, $229f3

; return carry if card ID loaded in a is found in hand
; and outputs in a the deck index of that card
; input:
;	a = card ID
; output:
; 	a = card deck index, if found
;	carry set if found
LookForCardIDInHandList_Bank8: ; 229f3 (8:69f3)
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
; 0x22a10

Func_22a10 ; 22a10 (8:6a10)
	INCROM $22a10, $22a39

; returns carry if card ID in a
; is found in Play Area or in hand
; input:
;	a = card ID
LookForCardIDInHandAndPlayArea: ; 22a39 (8:6a39)
	ld b, a
	push bc
	call LookForCardIDInHandList_Bank8
	pop bc
	ret c

	ld a, b
	ld b, PLAY_AREA_ARENA
	call LookForCardIDInPlayArea_Bank8
	ret c
	or a
	ret
; 0x22a49

Func_22a49 ; 22a49 (8:6a49)
	INCROM $22a49, $22a72

; returns carry if card ID in a
; is found in Play Area, starting with
; location in b
; input:
;	a = card ID
;	b = PLAY_AREA_* to start with
; ouput:
;	a = PLAY_AREA_* of found card
;	carry set if found
LookForCardIDInPlayArea_Bank8: ; 22a72 (8:6a72)
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
	jr z, .is_same

	inc b
	ld a, MAX_PLAY_AREA_POKEMON
	cp b
	jr nz, .loop
	ld b, $ff
	or a
	ret

.is_same
	ld a, b
	scf
	ret
; 0x22a95

Func_22a95 ; 22a95 (8:6a95)
	INCROM $22a95, $22bad

; return carry flag if move is not high recoil.
Func_22bad: ; 22bad (8:6bad)
	farcall Func_169ca
	ret nc
	ld a, [wSelectedMoveIndex]
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyMoveDataAndDamage_FromDeckIndex
	ld a, MOVE_FLAG1_ADDRESS | HIGH_RECOIL_F
	call CheckLoadedMoveFlag
	ccf
	ret
; 0x22bc6

Func_22bc6 ; 22bc6 (8:6bc6)
	INCROM $22bc6, $24000
