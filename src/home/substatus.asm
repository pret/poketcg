; doubles the damage at de if swords dance or focus energy was used
; in the last turn by the turn holder's arena Pokemon
HandleDoubleDamageSubstatus::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetTurnDuelistVariable
	bit SUBSTATUS3_THIS_TURN_DOUBLE_DAMAGE_F, [hl]
	call nz, .double_damage_at_de
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	or a
	call nz, .ret1
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	call nz, .ret2
	ret
.ret1
	ret
.double_damage_at_de
	ld a, e
	or d
	ret z
	sla e
	rl d
	ret
.ret2
	ret

; check if the attacking card (non-turn holder's arena card) has any substatus that
; reduces the damage dealt this turn (SUBSTATUS2).
; check if the defending card (turn holder's arena card) has any substatus that
; reduces the damage dealt to it this turn (SUBSTATUS1 or Pkmn Powers).
; damage is given in de as input and the possibly updated damage is also returned in de.
HandleDamageReduction::
	call HandleDamageReductionExceptSubstatus2
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetNonTurnDuelistVariable
	or a
	ret z
	cp SUBSTATUS2_REDUCE_BY_20
	jr z, .reduce_damage_by_20
	cp SUBSTATUS2_POUNCE
	jr z, .reduce_damage_by_10
	cp SUBSTATUS2_GROWL
	jr z, .reduce_damage_by_10
	ret
.reduce_damage_by_20
	ld hl, -20
	add hl, de
	ld e, l
	ld d, h
	ret
.reduce_damage_by_10
	ld hl, -10
	add hl, de
	ld e, l
	ld d, h
	ret

; check if the defending card (turn holder's arena card) has any substatus that
; reduces the damage dealt to it this turn. (SUBSTATUS1 or Pkmn Powers)
; damage is given in de as input and the possibly updated damage is also returned in de.
HandleDamageReductionExceptSubstatus2::
	ld a, [wNoDamageOrEffect]
	or a
	jr nz, .no_damage
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	or a
	jr z, .not_affected_by_substatus1

	cp SUBSTATUS1_NO_DAMAGE_STIFFEN
	jr z, .no_damage
	cp SUBSTATUS1_NO_DAMAGE_10
	jr z, .no_damage
	cp SUBSTATUS1_NO_DAMAGE_11
	jr z, .no_damage
	cp SUBSTATUS1_NO_DAMAGE_17
	jr z, .no_damage
	cp SUBSTATUS1_REDUCE_BY_10
	jr z, .reduce_damage_by_10
	cp SUBSTATUS1_REDUCE_BY_20
	jr z, .reduce_damage_by_20
	cp SUBSTATUS1_HARDEN
	jr z, .prevent_less_than_40_damage
	cp SUBSTATUS1_HALVE_DAMAGE
	jr z, .halve_damage

.not_affected_by_substatus1
	call CheckIsIncapableOfUsingPkmnPower_ArenaCard
	ret c
.pkmn_power
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	ret z
	ld a, [wTempNonTurnDuelistCardID]
	cp MR_MIME
	jr z, .invisible_wall
	cp KABUTO
	jr z, .kabuto_armor
	ret

.no_damage
	ld de, 0
	ret

.reduce_damage_by_10
	ld hl, -10
	add hl, de
	ld e, l
	ld d, h
	ret

.reduce_damage_by_20
	ld hl, -20
	add hl, de
	ld e, l
	ld d, h
	ret

.prevent_less_than_40_damage
	ld bc, 40
	call CompareDEtoBC
	ret nc
	ld de, 0
	ret

.halve_damage
	sla d ; bug, should be sra d
	rr e
	bit 0, e
	ret z
	ld hl, -5
	add hl, de
	ld e, l
	ld d, h
	ret

.invisible_wall
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	ret z
	ld bc, 30
	call CompareDEtoBC
	ret c
	ld de, 0
	ret

.kabuto_armor
	sla d ; bug, should be sra d
	rr e
	bit 0, e
	ret z
	ld hl, -5
	add hl, de
	ld e, l
	ld d, h
	ret

; check for Invisible Wall, Kabuto Armor, NShield, or Transparency, in order to
; possibly reduce or make zero the damage at de.
HandleDamageReductionOrNoDamageFromPkmnPowerEffects::
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	ret z
	ld a, MUK
	call CountPokemonWithActivePkmnPowerInBothPlayAreas
	ret c
	ld a, [wTempPlayAreaLocation_cceb]
	or a
	call nz, HandleDamageReductionExceptSubstatus2.pkmn_power
	push de ; push damage from call above, which handles Invisible Wall and Kabuto Armor
	call HandleNoDamageOrEffectSubstatus.pkmn_power
	call nc, HandleTransparency
	pop de ; restore damage
	ret nc
	; if carry was set due to NShield or Transparency, damage is 0
	ld de, 0
	ret

; when MACHAMP is damaged, if its Strikes Back is active, the
; attacking Pokemon (turn holder's arena Pokemon) takes 10 damage.
; ignore if damage taken at de is 0.
; used to bounce back a damaging attack.
HandleStrikesBack_AgainstDamagingAttack::
	ld a, e
	or d
	ret z
	ld a, [wIsDamageToSelf]
	or a
	ret nz
	ld a, [wTempNonTurnDuelistCardID] ; ID of defending Pokemon
	cp MACHAMP
	ret nz
	ld a, MUK
	call CountPokemonWithActivePkmnPowerInBothPlayAreas
	ret c
	ld a, [wLoadedAttackCategory] ; category of attack used
	cp POKEMON_POWER
	ret z
	ld a, [wTempPlayAreaLocation_cceb] ; defending Pokemon's PLAY_AREA_*
	or a ; cp PLAY_AREA_ARENA
	jr nz, .in_bench
	call CheckIsIncapableOfUsingPkmnPower_ArenaCard
	ret c
.in_bench
	push hl
	push de
	; subtract 10 HP from attacking Pokemon (turn holder's arena Pokemon)
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	push af
	push hl
	ld de, 10
	call SubtractHP
	ld a, [wLoadedCard2ID]
	ld [wTempNonTurnDuelistCardID], a
	ld hl, 10
	call LoadTxRam3
	ld hl, wLoadedCard2Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ldtx hl, ReceivesDamageDueToStrikesBackText
	call DrawWideTextBox_WaitForInput
	pop hl
	pop af
	or a
	jr z, .not_knocked_out
	xor a ; PLAY_AREA_ARENA
	call PrintPlayAreaCardKnockedOutIfNoHP
.not_knocked_out
	call SwapTurn
	pop de
	pop hl
	ret

; return carry if NShield or Transparency activate (if MEW_LV8 or HAUNTER_LV17 is
; the turn holder's arena Pokemon), and print their corresponding text if so
HandleNShieldAndTransparency::
	push de
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp MEW_LV8
	jr z, .nshield
	cp HAUNTER_LV17
	jr z, .transparency
.done
	pop de
	or a
	ret
.nshield
	ld a, DUELVARS_ARENA_CARD_STAGE
	call GetNonTurnDuelistVariable
	or a
	jr z, .done
	ld a, NO_DAMAGE_OR_EFFECT_NSHIELD
	ld [wNoDamageOrEffect], a
	ldtx hl, NoDamageOrEffectDueToNShieldText
.print_text
	call DrawWideTextBox_WaitForInput
	pop de
	scf
	ret
.transparency
	xor a
	ld [wDuelDisplayedScreen], a
	ldtx de, TransparencyCheckText
	call TossCoin
	jr nc, .done
	ld a, NO_DAMAGE_OR_EFFECT_TRANSPARENCY
	ld [wNoDamageOrEffect], a
	ldtx hl, NoDamageOrEffectDueToTransparencyText
	jr .print_text

; return carry if the turn holder's arena Pokemon is under a condition that makes
; it unable to attack. also return in hl the text id to be displayed
HandleCantAttackSubstatus::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	ret z
	ldtx hl, UnableToAttackDueToTailWagText
	cp SUBSTATUS2_TAIL_WAG
	jr z, .return_with_cant_attack
	ldtx hl, UnableToAttackDueToLeerText
	cp SUBSTATUS2_LEER
	jr z, .return_with_cant_attack
	ldtx hl, UnableToAttackDueToBoneAttackText
	cp SUBSTATUS2_BONE_ATTACK
	jr z, .return_with_cant_attack
	or a
	ret
.return_with_cant_attack
	scf
	ret

; return carry if the turn holder's arena Pokemon cannot use
; selected attack at wSelectedAttack due to amnesia
HandleAmnesiaSubstatus::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	jr nz, .check_amnesia
	ret
.check_amnesia
	cp SUBSTATUS2_AMNESIA
	jr z, .affected_by_amnesia
.not_the_disabled_atk
	or a
	ret
.affected_by_amnesia
	ld a, DUELVARS_ARENA_CARD_DISABLED_ATTACK_INDEX
	call GetTurnDuelistVariable
	ld a, [wSelectedAttack]
	cp [hl]
	jr nz, .not_the_disabled_atk
	ldtx hl, UnableToUseAttackDueToAmnesiaText
	scf
	ret

; return carry if the turn holder's attack was unsuccessful due to sand attack or smokescreen effect
HandleSandAttackOrSmokescreenSubstatus::
	call CheckSandAttackOrSmokescreenSubstatus
	ret nc
	call TossCoin
	ld [wGotHeadsFromSandAttackOrSmokescreenCheck], a
	ccf
	ret nc
	ldtx hl, AttackUnsuccessfulText
	call DrawWideTextBox_WaitForInput
	scf
	ret

; return carry if the turn holder's arena card is under
; the effects of sand attack or smokescreen
; and got tails on the coin toss
CheckSandAttackOrSmokescreenSubstatus::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	ret z
	ldtx de, SandAttackCheckText
	cp SUBSTATUS2_SAND_ATTACK
	jr z, .card_is_affected
	ldtx de, SmokescreenCheckText
	cp SUBSTATUS2_SMOKESCREEN
	jr z, .card_is_affected
	or a
	ret
.card_is_affected
	ld a, [wGotHeadsFromSandAttackOrSmokescreenCheck]
	or a
	ret nz ; got heads
	; got tails
	scf
	ret

; return carry if the defending card (turn holder's arena card) is under a substatus
; that prevents any damage or effect dealt to it for a turn.
; also return the cause of the substatus in wNoDamageOrEffect
HandleNoDamageOrEffectSubstatus::
	xor a
	ld [wNoDamageOrEffect], a
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	ret z
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	ld e, NO_DAMAGE_OR_EFFECT_FLY
	ldtx hl, NoDamageOrEffectDueToFlyText
	cp SUBSTATUS1_FLY
	jr z, .no_damage_or_effect
	ld e, NO_DAMAGE_OR_EFFECT_BARRIER
	ldtx hl, NoDamageOrEffectDueToBarrierText
	cp SUBSTATUS1_BARRIER
	jr z, .no_damage_or_effect
	ld e, NO_DAMAGE_OR_EFFECT_AGILITY
	ldtx hl, NoDamageOrEffectDueToAgilityText
	cp SUBSTATUS1_AGILITY
	jr z, .no_damage_or_effect
	call CheckIsIncapableOfUsingPkmnPower_ArenaCard
	ccf
	ret nc
.pkmn_power
	ld a, [wTempNonTurnDuelistCardID]
	cp MEW_LV8
	jr z, .neutralizing_shield
	or a
	ret
.no_damage_or_effect
	ld a, e
	ld [wNoDamageOrEffect], a
	scf
	ret
.neutralizing_shield
	ld a, [wIsDamageToSelf]
	or a
	ret nz
	; prevent damage if attacked by a non-basic Pokemon
	ld a, [wTempTurnDuelistCardID]
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer2_FromCardID
	ld a, [wLoadedCard2Stage]
	or a
	ret z
	ld e, NO_DAMAGE_OR_EFFECT_NSHIELD
	ldtx hl, NoDamageOrEffectDueToNShieldText
	jr .no_damage_or_effect

; if the Pokemon being attacked is HAUNTER_LV17, and its Transparency is active,
; there is a 50% chance that any damage or effect is prevented
; return carry if damage is prevented
HandleTransparency::
	ld a, [wTempNonTurnDuelistCardID]
	cp HAUNTER_LV17
	jr z, .transparency
.done
	or a
	ret
.transparency
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	jr z, .done ; Transparency has no effect against Pkmn Powers
	ld a, [wTempPlayAreaLocation_cceb]
	call CheckIsIncapableOfUsingPkmnPower
	jr c, .done
	xor a
	ld [wDuelDisplayedScreen], a
	ldtx de, TransparencyCheckText
	call TossCoin
	ret nc
	ld a, NO_DAMAGE_OR_EFFECT_TRANSPARENCY
	ld [wNoDamageOrEffect], a
	ldtx hl, NoDamageOrEffectDueToTransparencyText
	scf
	ret

; return carry and return the appropriate text id in hl if the target has an
; special status or power that prevents any damage or effect done to it this turn
; input: a = NO_DAMAGE_OR_EFFECT_*
CheckNoDamageOrEffect::
	ld a, [wNoDamageOrEffect]
	or a
	ret z
	bit 7, a
	jr nz, .dont_print_text ; already been here so don't repeat the text
	ld hl, wNoDamageOrEffect
	set 7, [hl]
	dec a
	add a
	ld e, a
	ld d, $0
	ld hl, NoDamageOrEffectTextIDTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	scf
	ret

.dont_print_text
	ld hl, $0000
	scf
	ret

NoDamageOrEffectTextIDTable::
	tx NoDamageOrEffectDueToAgilityText      ; NO_DAMAGE_OR_EFFECT_AGILITY
	tx NoDamageOrEffectDueToBarrierText      ; NO_DAMAGE_OR_EFFECT_BARRIER
	tx NoDamageOrEffectDueToFlyText          ; NO_DAMAGE_OR_EFFECT_FLY
	tx NoDamageOrEffectDueToTransparencyText ; NO_DAMAGE_OR_EFFECT_TRANSPARENCY
	tx NoDamageOrEffectDueToNShieldText      ; NO_DAMAGE_OR_EFFECT_NSHIELD

; return carry if turn holder has Omanyte and its Clairvoyance Pkmn Power is active
IsClairvoyanceActive::
	ld a, MUK
	call CountPokemonWithActivePkmnPowerInBothPlayAreas
	ccf
	ret nc
	ld a, OMANYTE
	call CountTurnDuelistPokemonWithActivePkmnPower
	ret

; returns carry if turn holder's arena card is paralyzed, asleep, confused,
; and/or toxic gas in play (i.e. its pkmn power cannot be used)
CheckIsIncapableOfUsingPkmnPower_ArenaCard::
	xor a ; PLAY_AREA_ARENA

; returns carry if Pokemon in turn holder's Play Area location in register a
; cannot use its Pkmn Power
; input:
;	a = play area location offset of the Pokémon to check (PLAY_AREA_* constant)
CheckIsIncapableOfUsingPkmnPower::
	or a
	jr nz, .check_toxic_gas
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	ldtx hl, CannotUseDueToStatusText
	scf
	jr nz, .done ; return carry
.check_toxic_gas
	ld a, MUK
	call CountPokemonWithActivePkmnPowerInBothPlayAreas
	ldtx hl, UnableDueToToxicGasText
.done
	ret

; return, in a, the amount of times that the Pokemon card with a given ID is found in the
; play area of both duelists. Also return carry if the Pokemon card is at least found once.
; if the arena Pokemon is asleep, confused, or paralyzed (Pkmn Power-incapable), it doesn't count.
; input: a = Pokemon card ID to search
CountPokemonWithActivePkmnPowerInBothPlayAreas::
	push bc
	ld [wTempPokemonID_ce7c], a
	call CountTurnDuelistPokemonWithActivePkmnPower
	ld c, a
	call SwapTurn
	ld a, [wTempPokemonID_ce7c]
	call CountTurnDuelistPokemonWithActivePkmnPower
	call SwapTurn
	add c
	or a
	scf
	jr nz, .found
	or a
.found
	pop bc
	ret

; return, in a, the amount of times that the Pokemon card with a given ID is found in the
; turn holder's play area. Also return carry if the Pokemon card is at least found once.
; if the arena Pokemon is asleep, confused, or paralyzed (Pkmn Power-incapable), it doesn't count.
; input: a = Pokemon card ID to search
CountTurnDuelistPokemonWithActivePkmnPower::
	push hl
	push de
	push bc
	ld [wTempPokemonID_ce7c], a
	ld c, $0
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	jr z, .check_bench
	call GetCardIDFromDeckIndex
	ld a, [wTempPokemonID_ce7c]
	cp e
	jr nz, .check_bench
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	jr nz, .check_bench
	inc c
.check_bench
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.next_bench_slot
	ld a, [hli]
	cp -1
	jr z, .done
	call GetCardIDFromDeckIndex
	ld a, [wTempPokemonID_ce7c]
	cp e
	jr nz, .skip
	inc c
.skip
	inc b
	jr .next_bench_slot
.done
	ld a, c
	or a
	scf
	jr nz, .found
	or a
.found
	pop bc
	pop de
	pop hl
	ret

; return, in a, the retreat cost of the card in wLoadedCard1,
; adjusting for any Dodrio's Retreat Aid Pkmn Power that is active.
GetLoadedCard1RetreatCost::
	ld c, 0
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.check_bench_loop
	ld a, [hli]
	cp -1
	jr z, .no_more_bench
	call GetCardIDFromDeckIndex
	ld a, e
	cp DODRIO
	jr nz, .not_dodrio
	inc c
.not_dodrio
	jr .check_bench_loop
.no_more_bench
	ld a, c
	or a
	jr nz, .dodrio_found
.muk_found
	ld a, [wLoadedCard1RetreatCost] ; return regular retreat cost
	ret
.dodrio_found
	ld a, MUK
	call CountPokemonWithActivePkmnPowerInBothPlayAreas
	jr c, .muk_found
	ld a, [wLoadedCard1RetreatCost]
	sub c ; apply Retreat Aid for each Pkmn Power-capable Dodrio
	ret nc
	xor a
	ret

; return carry if the turn holder's arena Pokemon is affected by Acid and can't retreat
CheckUnableToRetreatDueToEffect::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	ret z
	cp SUBSTATUS2_UNABLE_RETREAT
	jr z, .cant_retreat
	or a
	ret
.cant_retreat
	ldtx hl, UnableToRetreatDueToAcidText
	scf
	ret

; return carry if the turn holder is affected by Headache and trainer cards can't be used
CheckCantUseTrainerDueToEffect::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetTurnDuelistVariable
	or a
	bit SUBSTATUS3_HEADACHE_F, [hl]
	ret z
	ldtx hl, UnableToUseTrainerDueToHeadacheText
	scf
	ret

; return carry if any duelist has Aerodactyl and its Prehistoric Power Pkmn Power is active
IsPrehistoricPowerActive::
	ld a, AERODACTYL
	call CountPokemonWithActivePkmnPowerInBothPlayAreas
	ret nc
	ld a, MUK
	call CountPokemonWithActivePkmnPowerInBothPlayAreas
	ldtx hl, UnableToEvolveDueToPrehistoricPowerText
	ccf
	ret

; clears some SUBSTATUS2 conditions from the turn holder's active Pokemon.
; more specifically, those conditions that reduce the damage from an attack
; or prevent the opposing Pokemon from attacking the substatus condition inducer.
ClearDamageReductionSubstatus2::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	ret z
	cp SUBSTATUS2_REDUCE_BY_20
	jr z, .zero
	cp SUBSTATUS2_POUNCE
	jr z, .zero
	cp SUBSTATUS2_GROWL
	jr z, .zero
	cp SUBSTATUS2_TAIL_WAG
	jr z, .zero
	cp SUBSTATUS2_LEER
	jr z, .zero
	ret
.zero
	ld [hl], 0
	ret

; clears the SUBSTATUS1 and updates the double damage condition of the player about to start his turn
UpdateSubstatusConditions_StartOfTurn::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	ld [hl], $0
	or a
	ret z
	cp SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE
	ret nz
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetTurnDuelistVariable
	set SUBSTATUS3_THIS_TURN_DOUBLE_DAMAGE_F, [hl]
	ret

; clears the SUBSTATUS2, Headache, and updates the double damage condition of the player ending his turn
UpdateSubstatusConditions_EndOfTurn::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetTurnDuelistVariable
	res SUBSTATUS3_HEADACHE_F, [hl]
	push hl
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	xor a
	ld [hl], a
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	pop hl
	cp SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE
	ret z
	res SUBSTATUS3_THIS_TURN_DOUBLE_DAMAGE_F, [hl]
	ret

; return carry if turn holder has Blastoise and its Rain Dance Pkmn Power is active
IsRainDanceActive::
	ld a, BLASTOISE
	call CountTurnDuelistPokemonWithActivePkmnPower
	ret nc ; return if no Pkmn Power-capable Blastoise found in turn holder's play area
	ld a, MUK
	call CountPokemonWithActivePkmnPowerInBothPlayAreas
	ccf
	ret

; return carry if card at [hTempCardIndex_ff98] is a water energy card AND
; if card at [hTempPlayAreaLocation_ff9d] is a water Pokemon card.
CheckRainDanceScenario::
	ldh a, [hTempCardIndex_ff98]
	call GetCardIDFromDeckIndex
	call GetCardType
	cp TYPE_ENERGY_WATER
	jr nz, .no_carry
	ldh a, [hTempPlayAreaLocation_ff9d]
	call GetPlayAreaCardColor
	cp TYPE_PKMN_WATER
	jr nz, .no_carry
	scf
	ret
.no_carry
	or a
	ret

; if the defending (non-turn) card's HP is 0 and the attacking (turn) card's HP
;  is not, the attacking card faints if it was affected by destiny bond
HandleDestinyBondSubstatus::
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetNonTurnDuelistVariable
	cp SUBSTATUS1_DESTINY_BOND
	jr z, .check_hp
	ret

.check_hp
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	cp -1
	ret z
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	or a
	ret nz
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	ret z
	ld [hl], 0
	push hl
	call DrawDuelMainScene
	call DrawDuelHUDs
	pop hl
	ld l, DUELVARS_ARENA_CARD
	ld a, [hl]
	call LoadCardDataToBuffer2_FromDeckIndex
	ld hl, wLoadedCard2Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ldtx hl, KnockedOutDueToDestinyBondText
	call DrawWideTextBox_WaitForInput
	ret

; when MACHAMP is damaged, if its Strikes Back is active, the
; attacking Pokemon (turn holder's arena Pokemon) takes 10 damage.
; used to bounce back an attack of the RESIDUAL category
HandleStrikesBack_AgainstResidualAttack::
	ld a, [wTempNonTurnDuelistCardID]
	cp MACHAMP
	jr z, .strikes_back
	ret
.strikes_back
	ld a, [wLoadedAttackCategory]
	and RESIDUAL
	ret nz
	ld a, [wDealtDamage]
	or a
	ret z
	call SwapTurn
	call CheckIsIncapableOfUsingPkmnPower_ArenaCard
	call SwapTurn
	ret c
	ld hl, 10 ; damage to be dealt to attacker
	call ApplyStrikesBack_AgainstResidualAttack
	call nc, WaitForWideTextBoxInput
	ret

ApplyStrikesBack_AgainstResidualAttack::
	push hl
	call LoadTxRam3
	ld a, [wTempTurnDuelistCardID]
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer2_FromCardID
	ld hl, wLoadedCard2Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	pop de
	push af
	push hl
	call SubtractHP
	ldtx hl, ReceivesDamageDueToStrikesBackText
	call DrawWideTextBox_PrintText
	pop hl
	pop af
	or a
	ret z
	call WaitForWideTextBoxInput
	xor a ; PLAY_AREA_ARENA
	call PrintPlayAreaCardKnockedOutIfNoHP
	call DrawDuelHUDs
	scf
	ret

; if the id of the card provided in register a as a deck index is MUK,
; clear the changed type of all arena and bench Pokemon
ClearChangedTypesIfMuk::
	call GetCardIDFromDeckIndex
	ld a, e
	cp MUK
	ret nz
	call SwapTurn
	call .zero_changed_types
	call SwapTurn
.zero_changed_types
	ld a, DUELVARS_ARENA_CARD_CHANGED_TYPE
	call GetTurnDuelistVariable
	ld c, MAX_PLAY_AREA_POKEMON
.zero_changed_types_loop
	xor a
	ld [hli], a
	dec c
	jr nz, .zero_changed_types_loop
	ret
