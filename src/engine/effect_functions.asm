Poison50PercentEffect: ; 2c000 (b:4000)
	ldtx de, PoisonCheckText
	call TossCoin_BankB
	ret nc

PoisonEffect: ; 2c007 (b:4007)
	lb bc, CNF_SLP_PRZ, POISONED
	jr ApplyStatusEffect

DoublePoisonEffect: ; 2c00c (b:400c)
	lb bc, CNF_SLP_PRZ, DOUBLE_POISONED
	jr ApplyStatusEffect

Paralysis50PercentEffect: ; 2c011 (b:4011)
	ldtx de, ParalysisCheckText
	call TossCoin_BankB
	ret nc
	lb bc, PSN_DBLPSN, PARALYZED
	jr ApplyStatusEffect

Confusion50PercentEffect: ; 2c01d (b:401d)
	ldtx de, ConfusionCheckText
	call TossCoin_BankB
	ret nc

ConfusionEffect: ; 2c024 (b:4024)
	lb bc, PSN_DBLPSN, CONFUSED
	jr ApplyStatusEffect

	ldtx de, SleepCheckText
	call TossCoin_BankB
	ret nc

SleepEffect: ; 2c030 (b:4030)
	lb bc, PSN_DBLPSN, ASLEEP
	jr ApplyStatusEffect

ApplyStatusEffect:
	ldh a, [hWhoseTurn]
	ld hl, wWhoseTurn
	cp [hl]
	jr nz, .can_induce_status
	ld a, [wTempNonTurnDuelistCardID]
	cp CLEFAIRY_DOLL
	jr z, .cant_induce_status
	cp MYSTERIOUS_FOSSIL
	jr z, .cant_induce_status
	; Snorlax's Thick Skinned prevents it from being statused...
	cp SNORLAX
	jr nz, .can_induce_status
	call SwapTurn
	xor a
	; ...unless already so, or if affected by Muk's Toxic Gas
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	call SwapTurn
	jr c, .can_induce_status

.cant_induce_status
	ld a, c
	ld [wNoEffectFromStatus], a
	call SetNoEffectFromStatus
	or a
	ret

.can_induce_status
	ld hl, wEffectFunctionsFeedbackIndex
	push hl
	ld e, [hl]
	ld d, $0
	ld hl, wEffectFunctionsFeedback
	add hl, de
	call SwapTurn
	ldh a, [hWhoseTurn]
	ld [hli], a
	call SwapTurn
	ld [hl], b ; mask of status conditions not to discard on the target
	inc hl
	ld [hl], c ; status condition to inflict to the target
	pop hl
	; advance wEffectFunctionsFeedbackIndex
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
	jr Func_2c08c

Func_2c08a: ; 2c08a (b:408a)
	ld a, $1

Func_2c08c:
	push de
	push af
	ld a, $11
	call SetOppAction_SerialSendDuelData
	pop af
	pop de
	call SerialSend8Bytes
	call TossCoinATimes
	ret
; 0x2c09c

SetNoEffectFromStatus: ; 2c09c (b:409c)
	ld a, EFFECT_FAILED_NO_EFFECT
	ld [wEffectFailed], a
	ret
; 0x2c0a2

SetWasUnsuccessful: ; 2c0a2 (b:40a2)
	ld a, EFFECT_FAILED_UNSUCCESSFUL
	ld [wEffectFailed], a
	ret
; 0x2c0a8

	INCROM $2c0a8, $2c0d4

; Sets some flags for AI use
; if target poisoned
; 	[wAIMinDamage] <- [wDamage]
; 	[wAIMaxDamage] <- [wDamage]
; else
; 	[wAIMinDamage] <- [wDamage] + d
; 	[wAIMaxDamage] <- [wDamage] + e
; 	[wDamage]      <- [wDamage] + a
Func_2c0d4: ; 2c0d4 (b:40d4)
	push af
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	and POISONED | DOUBLE_POISONED
	jr z, Func_2c0e9.skip_push_af
	pop af
	ld a, [wDamage]
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	ret

Func_2c0e9: ; 2c0e9 (b:40e9)
	push af

.skip_push_af
	ld hl, wDamage
	ld a, [hl]
	add d
	ld [wAIMinDamage], a
	ld a, [hl]
	add e
	ld [wAIMaxDamage], a
	pop af
	add [hl]
	ld [hl], a
	ret
; 0x2c0fb

; Sets some flags for AI use
; [wDamage]      <- a
; [wAIMinDamage] <- d
; [wAIMaxDamage] <- e
Func_2c0fb: ; 2c0fb (b:40fb)
	ld [wDamage], a
	xor a
	ld [wDamage + 1], a
	ld a, d
	ld [wAIMinDamage], a
	ld a, e
	ld [wAIMaxDamage], a
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

Func_2c166: ; 2c166 (b:4166)
	ld [wDamage], a
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	xor a
	ld [wDamage + 1], a
	ret
; 0x2c174

	INCROM $2c174, $2c6f0

SpitPoison_AIEffect: ; 2c6f0 (b:46f0)
	ld a, 5
	lb de, 0, 10
	jp Func_2c0fb
; 0x2c6f8

; If heads, defending Pokemon becomes poisoned
SpitPoison_Poison50PercentEffect: ; 2c6f8 (b:46f8)
	ldtx de, PoisonCheckText
	call TossCoin_BankB
	jp c, PoisonEffect
	ld a, $8c
	ld [wLoadedMoveAnimation], a
	call SetNoEffectFromStatus
	ret
; 0x2c70a

	INCROM $2c70a, $2c730

PoisonFang_AIEffect: ; 2c730 (b:4730)
	ld a, 10
	lb de, 10, 10
	jp Func_2c0d4
; 0x2c738

WeepinbellPoisonPowder_AIEffect: ; 2c738 (b:4738)
	ld a, 5
	lb de, 0, 10
	jp Func_2c0d4
; 0x2c740

	INCROM $2c740, $2c77e

; If heads, defending Pokemon can't retreat next turn
AcidEffect: ; 2c77e (b:477e)
	ldtx de, AcidCheckText
	call TossCoin_BankB
	ret nc
	ld a, SUBSTATUS2_UNABLE_RETREAT
	call ApplySubstatus2ToDefendingCard
	ret
; 0x2c78b

GloomPoisonPowder_AIEffect: ; 2c78b (b:478b)
	ld a, 10
	lb de, 10, 10
	jp Func_2c0d4
; 0x2c793

; Defending Pokemon and user become confused
FoulOdorEffect: ; 2c793 (b:4793)
	call ConfusionEffect
	call SwapTurn
	call ConfusionEffect
	call SwapTurn
	ret
; 0x2c7a0

; If heads, prevent all damage done to user next turn
KakunaStiffenEffect: ; 2c7a0 (b:47a0)
	ldtx de, IfHeadsNoDamageNextTurnText
	call TossCoin_BankB
	jp nc, SetWasUnsuccessful
	ld a, $4f
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_NO_DAMAGE_STIFFEN
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2c7b4

KakunaPoisonPowder_AIEffect: ; 2c7b4 (b:47b4)
	ld a, 5
	lb de, 0, 10
	jp Func_2c0d4
; 0x2c7bc

	INCROM $2c7bc, $2c7d0

; During your next turn, double damage
SwordsDanceEffect: ; 2c7d0 (b:47d0)
	ld a, [wTempTurnDuelistCardID]
	cp SCYTHER
	ret nz
	ld a, SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2c7dc

; If heads, defending Pokemon becomes confused
ZubatSupersonicEffect: ; 2c7dc (b:47dc)
	call Confusion50PercentEffect
	call nc, SetNoEffectFromStatus
	ret
; 0x2c7e3

	INCROM $2c7e3, $2c7ed

Twineedle_AIEffect: ; 2c7ed (b:47ed)
	ld a, 30
	lb de, 0, 60
	jp Func_2c0fb
; 0x2c7f5

; Flip 2 coins; deal 30x number of heads
Twineedle_MultiplierEffect: ; 2c7f5 (b:47f5)
	ld hl, 30
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 2
	call TossCoinATimes_BankB
	ld e, a
	add a
	add e
	call ATimes10
	call Func_2c166
	ret
; 0x2c80d

	INCROM $2c80d, $2c822

FoulGas_AIEffect: ; 2c822 (b:4822)
	ld a, 5
	lb de, 0, 10
	jp Func_2c0e9
; 0x2c82a

; If heads, defending Pokemon becomes poisoned. If tails, defending Pokemon becomes confused
FoulGas_PoisonOrConfusionEffect: ; 2c82a (b:482a)
	ldtx de, PoisonedIfHeadsConfusedIfTailsText
	call TossCoin_BankB
	jp c, PoisonEffect
	jp ConfusionEffect
; 0x2c836

; an exact copy of KakunaStiffenEffect
; If heads, prevent all damage done to user next turn
MetapodStiffenEffect: ; 2c836 (b:4836)
	ldtx de, IfHeadsNoDamageNextTurnText
	call TossCoin_BankB
	jp nc, SetWasUnsuccessful
	ld a, $4f
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_NO_DAMAGE_STIFFEN
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2c84a

	INCROM $2c84a, $2c925

BigEggsplosion_AIEffect: ; 2c925 (b:4925)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	call SetDamageToATimes20
	inc h
	jr nz, .capped
	ld l, 255
.capped
	ld a, l
	ld [wAIMaxDamage], a
	srl a
	ld [wDamage], a
	xor a
	ld [wAIMinDamage], a
	ret
; 0x2c944

; Flip coins equal to attached energies; deal 20x number of heads
BigEggsplosion_MultiplierEffect: ; 2c944 (b:4944)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld hl, 20
	call LoadTxRam3
	ld a, [wTotalAttachedEnergies]
	ldtx de, DamageCheckIfHeadsXDamageText
	call TossCoinATimes_BankB
;	fallthrough

; set damage to 20*a. Also return result in hl
SetDamageToATimes20: ; 2c958 (b:4958)
	ld l, a
	ld h, $00
	ld e, l
	ld d, h
	add hl, hl
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	ld a, l
	ld [wDamage], a
	ld a, h
	ld [wDamage + 1], a
	ret
; 0x2c96b

Thrash_AIEffect: ; 2c96b (b:496b)
	ld a, 35
	lb de, 30, 40
	jp Func_2c0fb
; 0x2c973

; If heads 10 more damage; if tails, 10 damage to itself
Thrash_ModifierEffect: ; 2c973 (b:4973)
	ldtx de, IfHeadPlus10IfTails10ToYourselfText
	call TossCoin_BankB
	ldh [hTemp_ffa0], a
	ret nc
	ld a, 10
	call AddToDamage
	ret
; 0x2c982

Func_2c982: ; 2c982 (b:4982)
	ldh a, [hTemp_ffa0]
	or a
	ret nz
	ld a, 10
	call Func_1955
	ret
; 0x2c98c

Toxic_AIEffect: ; 2c98c (b:498c)
	ld a, 20
	lb de, 20, 20
	jp Func_2c0e9
; 0x2c994

; Defending Pokémon becomes poisoned, but takes 20 damage (double poisoned)
Toxic_DoublePoisonEffect: ; 2c994 (b:4994)
	call DoublePoisonEffect
	ret
; 0x2c998

	INCROM $2c998, $30000
