; RST18
; this function affects the stack so that it returns to the pointer following
; the rst call. similar to rst 28, except this always loads bank 1
Bank1Call::
	push hl
	push hl
	push hl
	push hl
	push de
	push af
	ld hl, sp+$d
	ld d, [hl]
	dec hl
	ld e, [hl]
	dec hl
	ld [hl], $0
	dec hl
	ldh a, [hBankROM]
	ld [hld], a
	ld [hl], HIGH(SwitchToBankAtSP)
	dec hl
	ld [hl], LOW(SwitchToBankAtSP)
	dec hl
	inc de
	ld a, [de]
	ld [hld], a
	dec de
	ld a, [de]
	ld [hl], a
	ld a, $1
;	fallthrough

Bank1Call_FarCall_Common::
	call BankswitchROM
	ld hl, sp+$d
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	pop af
	pop de
	pop hl
	ret

; switch to the ROM bank at sp+4
SwitchToBankAtSP::
	push af
	push hl
	ld hl, sp+$04
	ld a, [hl]
	call BankswitchROM
	pop hl
	pop af
	inc sp
	inc sp
	ret

; RST28
; this function affects the stack so that it returns
; to the three byte pointer following the rst call
FarCall::
	push hl
	push hl
	push hl
	push hl
	push de
	push af
	ld hl, sp+$d
	ld d, [hl]
	dec hl
	ld e, [hl]
	dec hl
	ld [hl], $0
	dec hl
	ldh a, [hBankROM]
	ld [hld], a
	ld [hl], HIGH(SwitchToBankAtSP)
	dec hl
	ld [hl], LOW(SwitchToBankAtSP)
	dec hl
	inc de
	inc de
	ld a, [de]
	ld [hld], a
	dec de
	ld a, [de]
	ld [hl], a
	dec de
	ld a, [de]
	inc de
	jr Bank1Call_FarCall_Common
