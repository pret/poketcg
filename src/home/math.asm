; returns a *= 10
ATimes10: ; 0c4b (0:0c4b)
	push de
	ld e, a
	add a
	add a
	add e
	add a
	pop de
	ret

; returns hl *= 10
HLTimes10: ; 0c53 (0:0c53)
	push de
	ld l, a
	ld e, a
	ld h, $00
	ld d, h
	add hl, hl
	add hl, hl
	add hl, de
	add hl, hl
	pop de
	ret

; returns a /= 10
; returns carry if a % 10 >= 5
ADividedBy10: ; 0c5f (0:0c5f)
	push de
	ld e, -1
.asm_c62
	inc e
	sub 10
	jr nc, .asm_c62
	add 5
	ld a, e
	pop de
	ret
