; returns h * l in hl
HtimesL::
	push de
	ld a, h
	ld e, l
	ld d, $0
	ld l, d
	ld h, d
	jr .asm_887
.asm_882
	add hl, de
.asm_883
	sla e
	rl d
.asm_887
	srl a
	jr c, .asm_882
	jr nz, .asm_883
	pop de
	ret

; return a random number between 0 and a (exclusive) in a
Random::
	push hl
	ld h, a
	call UpdateRNGSources
	ld l, a
	call HtimesL
	ld a, h
	pop hl
	ret

; get the next random numbers of the wRNG1 and wRNG2 sequences
UpdateRNGSources::
	push hl
	push de
	ld hl, wRNG1
	ld a, [hli]
	ld d, [hl] ; wRNG2
	inc hl
	ld e, a
	ld a, d
	rlca
	rlca
	xor e
	rra
	push af
	ld a, d
	xor e
	ld d, a
	ld a, [hl] ; wRNGCounter
	xor e
	ld e, a
	pop af
	rl e
	rl d
	ld a, d
	xor e
	inc [hl] ; wRNGCounter
	dec hl
	ld [hl], d ; wRNG2
	dec hl
	ld [hl], e ; wRNG1
	pop de
	pop hl
	ret
