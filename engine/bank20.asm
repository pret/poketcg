INCBIN "baserom.gbc",$80000,$8020f - $80000

Func_8020f: ; 8020f (20:420f)
	push bc
	push af
	ld bc, Unknown_80e5d
	ld h, $0
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop af
	ld l, a
	ld h, $0
	sla l
	rl h
	sla l
	rl h
	add hl, bc
	pop bc
	ret

Func_80229: ; 80229 (20:4229)
	ld a, [hli]
	ld [$d4c4], a
	ld a, [hli]
	ld [$d4c5], a
	ld a, [hli]
	add $20
	ld [$d4c6], a
	ret
; 0x80238

INCBIN "baserom.gbc",$80238,$8025b - $80238

Func_8025b: ; 8025b (20:425b)
	push hl
	ld l, $4
	call Func_8020f
	call Func_80229
	ld a, [hl]
	push af
	ld [$d4c8], a
	ld a, $10
	ld [$d4c7], a
	call Func_80274
	pop af
	pop hl
	ret

Func_80274: ; 80274 (20:4274)
	call Func_8029f
	jr asm_8027c

Func_80279: ; 80279 (20:4279)
	call Func_802bb
asm_8027c
	push hl
	push bc
	push de
	ld a, [$d4c8]
	ld b, a
	ld a, [$d4c7]
	ld c, a
	ld hl, $d4c2
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $d4c4
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	call Func_395a
	call Func_07c5
	pop de
	pop bc
	pop hl
	ret

Func_8029f: ; 8029f (20:429f)
	ld a, [$d4ca]
	swap a
	push af
	and $f0
	ld [$d4c2], a
	pop af
	and $f
	add $80
	ld [$d4c3], a
	ld a, [$d4cb]
	and $1
	call Func_07d6
	ret

Func_802bb: ; 802bb (20:42bb)
	ld a, [$d4ca]
	push af
	xor $80
	ld [$d4ca], a
	call Func_8029f
	ld a, [$d4c3]
	add $8
	ld [$d4c3], a
	pop af
	ld [$d4ca], a
	ret
; 0x802d4

INCBIN "baserom.gbc",$802d4,$80e5a - $802d4

Unknown_80e5a: ; 80e5a (20:4e5a)
INCBIN "baserom.gbc",$80e5a,$80e5d - $80e5a

Unknown_80e5d: ; 80e5d (20:4e5d)
INCBIN "baserom.gbc",$80e5d,$84000 - $80e5d