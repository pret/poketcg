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
	unknown_data_20000 $05, ENERGY_REMOVAL,         $4895, $4880
	unknown_data_20000 $05, SUPER_ENERGY_REMOVAL,   $49bc, $4994
	unknown_data_20000 $07, POKEMON_BREEDER,        $4b1b, $4b06
	unknown_data_20000 $0f, PROFESSOR_OAK,          $4cc1, $4cae
	unknown_data_20000 $0a, ENERGY_RETRIEVAL,       $4e6e, $4e44
	unknown_data_20000 $0b, SUPER_ENERGY_RETRIEVAL, $4fc1, $4f80
	unknown_data_20000 $06, POKEMON_CENTER,         $50eb, $50e0
	unknown_data_20000 $07, IMPOSTER_PROFESSOR_OAK, $517b, $5170
	unknown_data_20000 $0c, ENERGY_SEARCH,          $51aa, $519a
	unknown_data_20000 $03, POKEDEX,                $52dc, $52b4
	unknown_data_20000 $07, FULL_HEAL,              $5428, $541d
	unknown_data_20000 $0a, MR_FUJI,                $54a7, $5497
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
	jr nc, .asm_2041b
	farcall CheckIfSelectedMoveIsUnusable
	jr nc, .no_carry
	farcall LookForEnergyNeededForMoveInHand
	jr c, .no_carry

.asm_2041b
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
	jr c, .asm_20780
	ret
.asm_20780
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
	call .CheckIfAnyMoveKnocksOut
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
.CheckIfAnyMoveKnocksOut ; 20806 (8:4806)
	xor a ; first attack
	call .asm_2080d
	ret c
	ld a, $01 ; second attack

; returns carry if attack KOs player card
; in location stored in e
.asm_2080d
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

; return carry if cards not in deck < 51
CheckDeckCardsAmount: ; 20878 (8:4878)
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp 51
	ret
; 0x20880

Func_20880: ; 20880 (8:4880)
	INCROM $20880, $2282e

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

Func_22875: ; 22875 (8:6875)
	INCROM $22875, $2297b

; copies $ff terminated buffer from hl to de
CopyBuffer: ; 2297b (8:697b)
	ld a, [hli]
	ld [de], a
	cp $ff
	ret z
	inc de
	jr CopyBuffer
; 0x22983

Func_22983: ; 22983 (8:6983)
	INCROM $22983, $22990

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

Func_229a3 ; 229a3 (8:69a3)
	INCROM $229a3, $22bad

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
