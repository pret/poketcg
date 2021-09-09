; jumps to index a in pointer table hl
JumpToFunctionInTable: ; 05ab (0:05ab)
	add a
	add l
	ld l, a
	ld a, $0
	adc h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; call function at [hl] if non-NULL
CallIndirect: ; 05b6 (0:05b6)
	push af
	ld a, [hli]
	or [hl]
	jr nz, .call_hl
	pop af
	ret
.call_hl
	ld a, [hld]
	ld l, [hl]
	ld h, a
	pop af
;	fallthrough

CallHL: ; 05c1 (0:05c1)
	jp hl
