; stores in wDamage, wAIMinDamage and wAIMaxDamage the calculated damage
; done to the defending Pokémon by a given card and attack
; input:
;	a = attack index to take into account
;	[hTempPlayAreaLocation_ff9d] = location of attacking card to consider
EstimateDamage_VersusDefendingCard:
	ld [wSelectedAttack], a
	ld e, a
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyAttackDataAndDamage_FromDeckIndex
	ld a, [wLoadedAttackCategory]
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
; set wAIMinDamage and wAIMaxDamage to damage of attack
; these values take into account the range of damage
; that the attack can span (e.g. min and max number of hits)
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
; ...and subsequently recovered to continue the duel normally
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
CalculateDamage_VersusDefendingPokemon:
	ld hl, wAIMinDamage
	call _CalculateDamage_VersusDefendingPokemon
	ld hl, wAIMaxDamage
	call _CalculateDamage_VersusDefendingPokemon
	ld hl, wDamage
;	fallthrough

_CalculateDamage_VersusDefendingPokemon:
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
; by the defending Pokémon, using the attack index at a
; input:
;	a = attack index
;	[hTempPlayAreaLocation_ff9d] = location of card to calculate
;	                               damage as the receiver
EstimateDamage_FromDefendingPokemon:
	call SwapTurn
	ld [wSelectedAttack], a
	ld e, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call CopyAttackDataAndDamage_FromDeckIndex
	call SwapTurn
	ld a, [wLoadedAttackCategory]
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
; set wAIMinDamage and wAIMaxDamage to damage of attack
; these values take into account the range of damage
; that the attack can span (e.g. min and max number of hits)
	ld a, [wDamage]
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	call SwapTurn
	ldh a, [hTempPlayAreaLocation_ff9d]
	push af
	xor a ; PLAY_AREA_ARENA
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
; ...and subsequently recovered to continue the duel normally
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
CalculateDamage_FromDefendingPokemon:
	ld hl, wAIMinDamage
	call .CalculateDamage
	ld hl, wAIMaxDamage
	call .CalculateDamage
	ld hl, wDamage
	; fallthrough

.CalculateDamage
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
