; switch to rombank (a + top2 of h shifted down),
; set top2 of h to 01 (switchable ROM bank area),
; return old rombank id on top-of-stack
BankpushROM::
	push hl
	push bc
	push af
	push de
	ld e, l
	ld d, h
	ld hl, sp+$9
	ld b, [hl]
	dec hl
	ld c, [hl]
	dec hl
	ld [hl], b
	dec hl
	ld [hl], c
	ld hl, sp+$9
	ldh a, [hBankROM]
	ld [hld], a
	ld [hl], $0
	ld a, d
	rlca
	rlca
	and $3
	ld b, a
	res 7, d
	set 6, d ; $4000 ≤ de ≤ $7fff
	ld l, e
	ld h, d
	pop de
	pop af
	add b
	call BankswitchROM
	pop bc
	ret

; switch to rombank a,
; return old rombank id on top-of-stack
BankpushROM2::
	push hl
	push bc
	push af
	push de
	ld e, l
	ld d, h
	ld hl, sp+$9
	ld b, [hl]
	dec hl
	ld c, [hl]
	dec hl
	ld [hl], b
	dec hl
	ld [hl], c
	ld hl, sp+$9
	ldh a, [hBankROM]
	ld [hld], a
	ld [hl], $0
	ld l, e
	ld h, d
	pop de
	pop af
	call BankswitchROM
	pop bc
	ret

; restore rombank from top-of-stack
BankpopROM::
	push hl
	push de
	ld hl, sp+$7
	ld a, [hld]
	call BankswitchROM
	dec hl
	ld d, [hl]
	dec hl
	ld e, [hl]
	inc hl
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop de
	pop hl
	pop af
	ret

; switch ROM bank to a
BankswitchROM::
	ldh [hBankROM], a
	ld [MBC3RomBank], a
	ret
