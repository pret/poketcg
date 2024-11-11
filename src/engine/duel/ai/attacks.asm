; have AI choose an attack to use, but do not execute it.
; return carry if an attack is chosen.
AIProcessButDontUseAttack:
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
RetrievePlayAreaAIScoreFromBackup2:
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
AIProcessAndTryToUseAttack:
	xor a
	ld [wAIExecuteProcessedAttack], a
	; fallthrough

; checks which of the Active card's attacks for AI to use.
; If any of the attacks has enough AI score to be used,
; AI will use it if wAIExecuteProcessedAttack is 0.
; in either case, return carry if an attack is chosen to be used.
AIProcessAttacks:
; if AI used Pluspower, load its attack index
	ld a, [wPreviousAIFlags]
	and AI_FLAG_USED_PLUSPOWER
	jr z, .no_pluspower
	ld a, [wAIPluspowerAttack]
	ld [wSelectedAttack], a
	jr .attack_chosen

.no_pluspower
; if Player is running MewtwoLv53 mill deck,
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
	ld [wAIRetreatScore], a
	jr .use_attack

.check_damage_bench
; check if it can otherwise damage player's bench
	ld a, ATTACK_FLAG1_ADDRESS | DAMAGE_TO_OPPONENT_BENCH_F
	call CheckLoadedAttackFlag
	jr c, .can_damage

; cannot damage either Defending Pokemon or Bench
	ld hl, wAIRetreatScore
	inc [hl]

; return carry if attack is chosen
; and AI tries to use it.
.use_attack
	ld a, TRUE
	ld [wAITriedAttack], a
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
	ld hl, wAIRetreatScore
	inc [hl]
	or a
	ret

; determines the AI score of attack index in a
; of card in Play Area location hTempPlayAreaLocation_ff9d.
GetAIScoreOfAttack:
; initialize AI score.
	ld [wSelectedAttack], a
	ld a, $50
	ld [wAIScore], a

	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocation_ff9d], a
	call CheckIfSelectedAttackIsUnusable
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
; in the case the player does, check if this attack
; has a residual effect, or if it can damage the opposing bench.
; If none of those are true, render the attack unusable.
; also if it's a PKMN power, consider it unusable as well.
	bank1call HandleNoDamageOrEffectSubstatus
	call SwapTurn
	jr nc, .check_if_can_ko

	; player is under No Damage substatus
	ld a, $01
	ld [wAICannotDamage], a
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, [wLoadedAttackCategory]
	cp POKEMON_POWER
	jr z, .unusable
	and RESIDUAL
	jr nz, .check_if_can_ko
	ld a, ATTACK_FLAG1_ADDRESS | DAMAGE_TO_OPPONENT_BENCH_F
	call CheckLoadedAttackFlag
	jr nc, .unusable

; calculate damage to player to check if attack can KO.
; encourage attack if it's able to KO.
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
	call AIEncourage

; raise AI score by the number of damage counters that this attack deals.
; if no damage is dealt, subtract AI score. in case wDamage is zero
; but wMaxDamage is not, then encourage attack afterwards.
; otherwise, if wMaxDamage is also zero, check for damage against
; player's bench, and encourage attack in case there is.
.check_damage
	xor a
	ld [wAIAttackIsNonDamaging], a
	ld a, [wDamage]
	ld [wTempAI], a
	or a
	jr z, .no_damage
	call ConvertHPToDamageCounters_Bank5
	call AIEncourage
	jr .check_recoil
.no_damage
	ld a, $01
	ld [wAIAttackIsNonDamaging], a
	call AIDiscourage
	ld a, [wAIMaxDamage]
	or a
	jr z, .no_max_damage
	ld a, 2
	call AIEncourage
	xor a
	ld [wAIAttackIsNonDamaging], a
.no_max_damage
	ld a, ATTACK_FLAG1_ADDRESS | DAMAGE_TO_OPPONENT_BENCH_F
	call CheckLoadedAttackFlag
	jr nc, .check_recoil
	ld a, 2
	call AIEncourage

; handle recoil attacks (low and high recoil).
.check_recoil
	ld a, ATTACK_FLAG1_ADDRESS | LOW_RECOIL_F
	call CheckLoadedAttackFlag
	jr c, .is_recoil
	ld a, ATTACK_FLAG1_ADDRESS | HIGH_RECOIL_F
	call CheckLoadedAttackFlag
	jp nc, .check_defending_can_ko
.is_recoil
	; sub from AI score number of damage counters
	; that attack deals to itself.
	ld a, [wLoadedAttackEffectParam]
	or a
	jp z, .check_defending_can_ko
	ld [wDamage], a
	call ApplyDamageModifiers_DamageToSelf
	ld a, e
	call ConvertHPToDamageCounters_Bank5
	call AIDiscourage

	push de
	ld a, ATTACK_FLAG1_ADDRESS | HIGH_RECOIL_F
	call CheckLoadedAttackFlag
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
	call AIDiscourage

.high_recoil
	; dismiss this attack if no benched Pokémon
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	cp 2
	jr c, .dismiss_high_recoil_atk
	; has benched Pokémon

; here the AI handles high recoil attacks differently
; depending on what deck it's playing.
	ld a, [wOpponentDeckID]
	cp ROCK_CRUSHER_DECK_ID
	jr z, .rock_crusher_deck
	cp ZAPPING_SELFDESTRUCT_DECK_ID
	jr z, .zapping_selfdestruct_deck
	cp BOOM_BOOM_SELFDESTRUCT_DECK_ID
	jr z, .encourage_high_recoil_atk
	; Boom Boom Selfdestruct deck always encourages
	cp POWER_GENERATOR_DECK_ID
	jr nz, .high_recoil_generic_checks
	; Power Generator deck always dismisses

.dismiss_high_recoil_atk
	xor a
	ld [wAIScore], a
	jp .done

.encourage_high_recoil_atk
	ld a, 20
	call AIEncourage
	jp .done

; Zapping Selfdestruct deck only uses this attack
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
	cp MAGNEMITE_LV13
	jr z, .magnemite1
	ld b, 10 ; bench damage
.magnemite1
	ld a, 10
	add b
	ld b, a ; 20 bench damage if not MagnemiteLv13

; if this attack causes player to win the duel by
; knocking out own Pokémon, dismiss attack.
	ld a, 1 ; count active Pokémon as KO'd
	call .check_if_kos_bench
	jr c, .dismiss_high_recoil_atk
	jr .encourage_high_recoil_atk

; Rock Crusher Deck only uses this attack if
; prize count is below 4 and attack wins (or potentially draws) the duel,
; (i.e. at least gets KOs equal to prize cards left).
.rock_crusher_deck
	call CountPrizes
	cp 4
	jr nc, .dismiss_high_recoil_atk
	; prize count < 4
	ld b, 20 ; damage dealt to bench
	call SwapTurn
	xor a
	call .check_if_kos_bench
	call SwapTurn
	jr c, .encourage_high_recoil_atk

; generic checks for all other deck IDs.
; encourage attack if it wins (or potentially draws) the duel,
; (i.e. at least gets KOs equal to prize cards left).
; dismiss it if it causes the player to win.
.high_recoil_generic_checks
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp CHANSEY
	jr z, .chansey
	cp MAGNEMITE_LV13
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

; attack causes player to draw all prize cards
	xor a
	ld [wAIScore], a
	jp .done

; attack causes CPU to draw all prize cards
.wins_the_duel
	ld a, 20
	call AIEncourage
	jp .done

; subtract from AI score number of own benched Pokémon KO'd
.count_own_ko_bench
	push bc
	ld a, d
	or a
	jr z, .count_player_ko_bench
	dec a
	call AIDiscourage

; add to AI score number of player benched Pokémon KO'd
.count_player_ko_bench
	pop bc
	ld a, b
	call AIEncourage
	jr .check_defending_can_ko

; local function that gets called to determine damage to
; benched Pokémon caused by a HIGH_RECOIL attack.
; return carry if using attack causes number of benched Pokémon KOs
; equal to or larger than remaining prize cards.
; this function is independent on duelist turn, so whatever
; turn it is when this is called, it's that duelist's
; bench/prize cards that get checked.
; input:
;	a = initial number of KO's beside benched Pokémon,
;		so that if the active Pokémon is KO'd by the attack,
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

; if defending card can KO, encourage attack
; unless attack is non-damaging.
.check_defending_can_ko
	ld a, [wSelectedAttack]
	push af
	call CheckIfDefendingPokemonCanKnockOut
	pop bc
	ld a, b
	ld [wSelectedAttack], a
	jr nc, .check_discard
	ld a, 5
	call AIEncourage
	ld a, [wAIAttackIsNonDamaging]
	or a
	jr z, .check_discard
	ld a, 5
	call AIDiscourage

; subtract from AI score if this attack requires
; discarding any energy cards.
.check_discard
	ld a, [wSelectedAttack]
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyAttackDataAndDamage_FromDeckIndex
	ld a, ATTACK_FLAG2_ADDRESS | DISCARD_ENERGY_F
	call CheckLoadedAttackFlag
	jr nc, .asm_16ca6
	ld a, 1
	call AIDiscourage
	ld a, [wLoadedAttackEffectParam]
	call AIDiscourage

.asm_16ca6
	ld a, ATTACK_FLAG2_ADDRESS | FLAG_2_BIT_6_F
	call CheckLoadedAttackFlag
	jr nc, .check_nullify_flag
	ld a, [wLoadedAttackEffectParam]
	call AIEncourage

; encourage attack if it has a nullify or weaken attack effect.
.check_nullify_flag
	ld a, ATTACK_FLAG2_ADDRESS | NULLIFY_OR_WEAKEN_ATTACK_F
	call CheckLoadedAttackFlag
	jr nc, .check_draw_flag
	ld a, 1
	call AIEncourage

; encourage attack if it has an effect to draw a card.
.check_draw_flag
	ld a, ATTACK_FLAG1_ADDRESS | DRAW_CARD_F
	call CheckLoadedAttackFlag
	jr nc, .check_heal_flag
	ld a, 1
	call AIEncourage

.check_heal_flag
	ld a, ATTACK_FLAG2_ADDRESS | HEAL_USER_F
	call CheckLoadedAttackFlag
	jr nc, .check_status_effect
	ld a, [wLoadedAttackEffectParam]
	cp 1
	jr z, .tally_heal_score
	ld a, [wTempAI]
	call ConvertHPToDamageCounters_Bank5
	ld b, a
	ld a, [wLoadedAttackEffectParam]
	cp 3
	jr z, .asm_16cec
	srl b
	jr nc, .asm_16cec
	inc b
.asm_16cec
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	call ConvertHPToDamageCounters_Bank5
	cp b
	jr c, .tally_heal_score
	ld a, b
.tally_heal_score
	push af
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	call ConvertHPToDamageCounters_Bank5
	pop bc
	cp b
	jr c, .add_heal_score
	ld a, b
.add_heal_score
	call AIEncourage

.check_status_effect
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	call SwapTurn
	call GetCardIDFromDeckIndex
	call SwapTurn
	ld a, e
	; skip if player has Snorlax
	cp SNORLAX
	jp z, .handle_special_atks

	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	ld [wTempAI], a

; encourage a poison inflicting attack if opposing Pokémon
; isn't (doubly) poisoned already.
; if opposing Pokémon is only poisoned and not double poisoned,
; and this attack has FLAG_2_BIT_6 set, discourage it
; (possibly to make Nidoking's Toxic attack less likely to be chosen
; if the other Pokémon is poisoned.)
	ld a, ATTACK_FLAG1_ADDRESS | INFLICT_POISON_F
	call CheckLoadedAttackFlag
	jr nc, .check_sleep
	ld a, [wTempAI]
	and DOUBLE_POISONED
	jr z, .add_poison_score
	and $40 ; only double poisoned?
	jr z, .check_sleep
	ld a, ATTACK_FLAG2_ADDRESS | FLAG_2_BIT_6_F
	call CheckLoadedAttackFlag
	jr nc, .check_sleep
	ld a, 2
	call AIDiscourage
	jr .check_sleep
.add_poison_score
	ld a, 2
	call AIEncourage

; encourage sleep-inducing attack if other Pokémon isn't asleep.
.check_sleep
	ld a, ATTACK_FLAG1_ADDRESS | INFLICT_SLEEP_F
	call CheckLoadedAttackFlag
	jr nc, .check_paralysis
	ld a, [wTempAI]
	and CNF_SLP_PRZ
	cp ASLEEP
	jr z, .check_paralysis
	ld a, 1
	call AIEncourage

; encourage paralysis-inducing attack if other Pokémon isn't asleep.
; otherwise, if other Pokémon is asleep, discourage attack.
.check_paralysis
	ld a, ATTACK_FLAG1_ADDRESS | INFLICT_PARALYSIS_F
	call CheckLoadedAttackFlag
	jr nc, .check_confusion
	ld a, [wTempAI]
	and CNF_SLP_PRZ
	cp ASLEEP
	jr z, .sub_prz_score
	ld a, 1
	call AIEncourage
	jr .check_confusion
.sub_prz_score
	ld a, 1
	call AIDiscourage

; encourage confuse-inducing attack if other Pokémon isn't asleep
; or confused already.
; otherwise, if other Pokémon is asleep or confused,
; discourage attack instead.
.check_confusion
	ld a, ATTACK_FLAG1_ADDRESS | INFLICT_CONFUSION_F
	call CheckLoadedAttackFlag
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
	call AIEncourage
	jr .check_if_confused
.sub_cnf_score
	ld a, 1
	call AIDiscourage

; if this Pokémon is confused, subtract from score.
.check_if_confused
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	cp CONFUSED
	jr nz, .handle_special_atks
	ld a, 1
	call AIDiscourage

; SPECIAL_AI_HANDLING marks attacks that the AI handles individually.
; each attack has its own checks and modifies AI score accordingly.
.handle_special_atks
	ld a, ATTACK_FLAG3_ADDRESS | SPECIAL_AI_HANDLING_F
	call CheckLoadedAttackFlag
	jr nc, .done
	call HandleSpecialAIAttacks
	cp $80
	jr c, .negative_score
	sub $80
	call AIEncourage
	jr .done
.negative_score
	ld b, a
	ld a, $80
	sub b
	call AIDiscourage

.done
	ret
