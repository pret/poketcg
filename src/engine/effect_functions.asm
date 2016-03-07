Poison50PercentEffect: ; 2c000 (b:4000)
	text_de PoisonCheckText
	call TossCoin_BankB
	ret nc

PoisonEffect: ; 2c007 (b:4007)
	lb bc, $0f, POISONED
	jr applyEffect

	lb bc, $0f, DOUBLE_POISONED
	jr applyEffect

Paralysis50PercentEffect: ; 2c011 (b:4011)
	text_de ParalysisCheckText
	call TossCoin_BankB
	ret nc
	lb bc, $f0, PARALYZED
	jr applyEffect

Confusion50PercentEffect: ; 2c01d (b:401d)
	text_de ConfusionCheckText
	call TossCoin_BankB
	ret nc
	lb bc, $f0, CONFUSED
	jr applyEffect

	text_de SleepCheckText
	call TossCoin_BankB
	ret nc

SleepEffect: ; 2c030 (b:4030)
	lb bc, $f0, ASLEEP
	jr applyEffect

applyEffect
	ldh a, [hWhoseTurn]
	ld hl, $cc05
	cp [hl]
	jr nz, .canInduceStatus
	ld a, [wTempNonTurnDuelistCardId]
	cp CLEFAIRY_DOLL
	jr z, .cantInduceStatus
	cp MYSTERIOUS_FOSSIL
	jr z, .cantInduceStatus
    ; snorlax's thick skinned prevents it from being statused...
	cp SNORLAX
	jr nz, .canInduceStatus
	call SwapTurn
	xor a
    ; ...unless already so, or if affected by muk's toxic gas
	call CheckIfUnderAnyCannotUseStatus2
	call SwapTurn
	jr c, .canInduceStatus

.cantInduceStatus
	ld a, c
	ld [wccf1], a
	call Func_2c09c
	or a
	ret

.canInduceStatus
	ld hl, wcccd
	push hl
	ld e, [hl]
	ld d, $0
	ld hl, $ccce
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

INCBIN "baserom.gbc",$2c082,$2c09c - $2c082

Func_2c09c: ; 2c09c (b:409c)
	ld a, $1
	ld [wcced], a
	ret
; 0x2c0a2

INCBIN "baserom.gbc",$2c0a2,$30000 - $2c0a2
