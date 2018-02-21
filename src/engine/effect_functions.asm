Poison50PercentEffect: ; 2c000 (b:4000)
	ldtx de, PoisonCheckText
	call TossCoin_BankB
	ret nc

PoisonEffect: ; 2c007 (b:4007)
	lb bc, $0f, POISONED
	jr ApplyStatusEffect

	lb bc, $0f, DOUBLE_POISONED
	jr ApplyStatusEffect

Paralysis50PercentEffect: ; 2c011 (b:4011)
	ldtx de, ParalysisCheckText
	call TossCoin_BankB
	ret nc
	lb bc, $f0, PARALYZED
	jr ApplyStatusEffect

Confusion50PercentEffect: ; 2c01d (b:401d)
	ldtx de, ConfusionCheckText
	call TossCoin_BankB
	ret nc

ConfusionEffect: ; 2c024 (b:4024)
	lb bc, $f0, CONFUSED
	jr ApplyStatusEffect

	ldtx de, SleepCheckText
	call TossCoin_BankB
	ret nc

SleepEffect: ; 2c030 (b:4030)
	lb bc, $f0, ASLEEP
	jr ApplyStatusEffect

ApplyStatusEffect:
	ldh a, [hWhoseTurn]
	ld hl, wcc05
	cp [hl]
	jr nz, .can_induce_status
	ld a, [wTempNonTurnDuelistCardId]
	cp CLEFAIRY_DOLL
	jr z, .cant_induce_status
	cp MYSTERIOUS_FOSSIL
	jr z, .cant_induce_status
	; snorlax's thick skinned prevents it from being statused...
	cp SNORLAX
	jr nz, .can_induce_status
	call SwapTurn
	xor a
	; ...unless already so, or if affected by muk's toxic gas
	call CheckIfUnderAnyCannotUseStatus2
	call SwapTurn
	jr c, .can_induce_status

.cant_induce_status
	ld a, c
	ld [wccf1], a
	call Func_2c09c
	or a
	ret

.can_induce_status
	ld hl, wcccd
	push hl
	ld e, [hl]
	ld d, $0
	ld hl, wccce
	add hl, de
	call SwapTurn
	ldh a, [hWhoseTurn]
	ld [hli], a
	call SwapTurn
	ld [hl], b
	inc hl
	ld [hl], c
	pop hl
	inc [hl]
	inc [hl]
	inc [hl]
	scf
	ret
; 0x2c07e

TossCoin_BankB: ; 2c07e (b:407e)
	call TossCoin
	ret
; 0x2c082

TossCoinATimes_BankB: ; 2c082 (b:4082)
	call TossCoinATimes
	ret
; 0x2c086

CommentedOut_2c086: ; 2c086 (b:4086)
	ret
; 0x2c087

Func_2c087: ; 2c087 (b:4087)
	xor a
	jr asm_2c08c

Func_2c08a: ; 2c08a (b:408a)
	ld a, $1

asm_2c08c
	push de
	push af
	ld a, $11
	call SetDuelAIAction
	pop af
	pop de
	call Func_0fac
	call TossCoinATimes
	ret
; 0x2c09c

Func_2c09c: ; 2c09c (b:409c)
	ld a, $1
	ld [wcced], a
	ret
; 0x2c0a2

Func_2c0a2: ; 2c0a2 (b:40a2)
	ld a, $2
	ld [wcced], a
	ret
; 0x2c0a8

	INCROM $2c0a8, $2c0d4

; Sets some flags for AI use
; if target double poisoned
; 	[wccbb]   <- [wDamage]
; 	[wccbc]   <- [wDamage]
; else
; 	[wccbb]   <- [wDamage] + d
; 	[wccbc]   <- [wDamage] + e
; 	[wDamage] <- [wDamage] + a
Func_2c0d4: ; 2c0d4 (b:40d4)
	push af
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	and DOUBLE_POISONED
	jr z, .not_double_poisoned
	pop af
	ld a, [wDamage]
	ld [wccbb], a
	ld [wccbc], a
	ret

	push af

.not_double_poisoned
	ld hl, wDamage
	ld a, [hl]
	add d
	ld [wccbb], a
	ld a, [hl]
	add e
	ld [wccbc], a
	pop af
	add [hl]
	ld [hl], a
	ret
; 0x2c0fb

; Sets some flags for AI use
; [wDamage] <- a
; [wccbb]   <- d
; [wccbc]   <- e
Func_2c0fb: ; 2c0fb (b:40fb)
	ld [wDamage], a
	xor a
	ld [wDamage + 1], a
	ld a, d
	ld [wccbb], a
	ld a, e
	ld [wccbc], a
	ret
; 0x2c10b

	INCROM $2c10b, $2c140

; apply a status condition of type 1 identified by register a to the target
ApplySubstatus1ToDefendingCard: ; 2c140 (b:4140)
	push af
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	pop af
	ld [hli], a
	ret
; 0x2c149

; apply a status condition of type 2 identified by register a to the target,
; unless prevented by wNoDamageOrEffect
ApplySubstatus2ToDefendingCard: ; 2c149 (b:4149)
	push af
	call CheckNoDamageOrEffect
	jr c, .no_damage_orEffect
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	ld l, $f6
	ld [hl], a
	ret

.no_damage_orEffect
	pop af
	push hl
	bank1call $4f9d
	pop hl
	ld a, l
	or h
	call nz, DrawWideTextBox_PrintText
	ret
; 0x2c166

	INCROM $2c166, $2c6f0

SpitPoison_AIEffect: ; 2c6f0 (b:46f0)
	ld a, $5
	lb de, $0, $a
	jp Func_2c0fb
; 0x2c6f8

SpitPoison_Poison50PercentEffect: ; 2c6f8 (b:46f8)
	ldtx de, PoisonCheckText
	call TossCoin_BankB
	jp c, PoisonEffect
	ld a, $8c
	ld [wLoadedMoveAnimation], a
	call Func_2c09c
	ret
; 0x2c70a

	INCROM $2c70a, $2c730

PoisonFang_AIEffect: ; 2c730 (b:4730)
	ld a, $a
	lb de, $a, $a
	jp Func_2c0d4
; 0x2c738

WeepinbellPoisonPowder_AIEffect: ; 2c738 (b:4738)
	ld a, $5
	lb de, $0, $a
	jp Func_2c0d4
; 0x2c740

	INCROM $2c740, $2c77e

AcidEffect: ; 2c77e (b:477e)
	ldtx de, AcidCheckText
	call TossCoin_BankB
	ret nc
	ld a, SUBSTATUS2_UNABLE_RETREAT
	call ApplySubstatus2ToDefendingCard
	ret
; 0x2c78b

GloomPoisonPowder_AIEffect: ; 2c78b (b:478b)
	ld a, $a
	lb de, $a, $a
	jp Func_2c0d4
; 0x2c793

; confuses both the target and the user
FoulOdorEffect: ; 2c793 (b:4793)
	call ConfusionEffect
	call SwapTurn
	call ConfusionEffect
	call SwapTurn
	ret
; 0x2c7a0

KakunaStiffenEffect: ; 2c7a0 (b:47a0)
	ldtx de, IfHeadsNoDamageNextTurnText
	call TossCoin_BankB
	jp nc, Func_2c0a2
	ld a, $4f
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_NO_DAMAGE_STIFFEN
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2c7b4

KakunaPoisonPowder_AIEffect: ; 2c7b4 (b:47b4)
	ld a, $5
	lb de, $0, $a
	jp Func_2c0d4
; 0x2c7bc

	INCROM $2c7bc, $2c7d0

SwordsDanceEffect: ; 2c7d0 (b:47d0)
	ld a, [wTempTurnDuelistCardId]
	cp SCYTHER
	ret nz
	ld a, SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2c7dc

ZubatSupersonicEffect: ; 2c7dc (b:47dc)
	call Confusion50PercentEffect
	call nc, Func_2c09c
	ret
; 0x2c7e3

	INCROM $2c7e3, $2c836

; an exact copy of KakunaStiffenEffect
MetapodStiffenEffect: ; 2c836 (b:4836)
	ldtx de, IfHeadsNoDamageNextTurnText
	call TossCoin_BankB
	jp nc, Func_2c0a2
	ld a, $4f
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_NO_DAMAGE_STIFFEN
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2c84a

	INCROM $2c84a, $30000
