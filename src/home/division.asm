; divides BC by DE. Stores result in BC and stores remainder in HL
DivideBCbyDE::
	ld hl, $0000
	rl c
	rl b
	ld a, $10
.asm_3c63
	ldh [hffb6], a
	rl l
	rl h
	push hl
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ccf
	jr nc, .asm_3c78
	ld h, a
	add sp, $2
	scf
	jr .asm_3c79
.asm_3c78
	pop hl
.asm_3c79
	rl c
	rl b
	ldh a, [hffb6]
	dec a
	jr nz, .asm_3c63
	ret
