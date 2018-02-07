	INCROM $20000, $200e5

; 0 - e4 is a big set of data, seems to be one entry for each card

Func_200e5: ; 200e5 (8:40e5)
	ld [$ce18], a
	call CreateHandCardBuffer
	ld hl, wDuelCardOrAttackList
	ld de, wHandCardBuffer
	call CopyBuffer
	ld hl, wHandCardBuffer
	ld a, [hli]
	ld [$ce16], a
	cp $ff
	ret z
	push hl
	ld a, [$ce18]
	ld d, a
	ld hl, $4000
.asm_4106
	xor a
	ld [$ce21], a
	ld a, [hli]
	cp $ff
	jp z, $41b1
	cp d
	jp nz, .incHL5
	ld a, [hli]
	ld [$ce17], a
	ld a, [$ce16]
	call LoadDeckCardToBuffer1
	cp $d2
	jr nz, .asm_2012b
	ld b, a
	ld a, [$ce20]
	and $2
	jr nz, .incHL4
	ld a, b

.asm_2012b
	ld b, a
	ld a, [$ce17]
	cp b
	jr nz, .incHL4
	push hl
	push de
	ld a, [$ce16]
	ld [$ff9f], a
	bank1call $35a9
	jp c, $41a8
	call $1944
	ld a, $1
	call TryExecuteEffectCommandFunction
	jp c, $41a8
	farcallx $5, $743b
	jr c, .asm_201a8
	pop de
	pop hl
	push hl
	call CallIndirect
	pop hl
	jr nc, .incHL4
	inc hl
	inc hl
	ld [$ce19], a
	push de
	push hl
	ld a, [$ce16]
	ld [$ff9f], a
	ld a, $6
	bank1call $67be
	pop hl
	pop de
	jr c, .incHL2
	push hl
	call CallIndirect
	pop hl
	inc hl
	inc hl
	ld a, [$ce20]
	ld b, a
	ld a, [$ce21]
	or b
	ld [$ce20], a
	pop hl
	and $8
	jp z, $40f7
	call $123b
	ld hl, wDuelCardOrAttackList
	ld de, $cf68
	call $697b
	ld hl, $cf68
	ld a, [$ce20]
	and $f7
	ld [$ce20], a
	jp $40f7

.incHL5
	inc hl

.incHL4
	inc hl
	inc hl

.incHL2
	inc hl
	inc hl
	jp .asm_4106

.asm_201a8
	pop de
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	jp .asm_4106
; 0x201b1

	INCROM $201b1, $2297b

; copies $ff terminated buffer from hl to de
CopyBuffer: ; 2297b (8:697b)
	ld a, [hli]
	ld [de], a
	cp $ff
	ret z
	inc de
	jr CopyBuffer
; 0x22983

	INCROM $22983, $24000
