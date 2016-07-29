Func_80000: ; 80000 (20:4000)
INCBIN "baserom.gbc",$80000,$80028 - $80000

Func_80028: ; 80028 (20:4028)
	call Func_801f1
	ld bc, $0000
	call Func_80077
	farcallx $3, $49c7
	call $41a1
	farcallx $3, $43ee
	ret
; 0x8003d

INCBIN "baserom.gbc",$8003d,$80077 - $8003d

Func_80077: ; 80077 (20:4077)
	ld a, $1
	ld [$d292], a
	jr .asm_80082

	xor a
	ld [$d292], a

.asm_80082
	push hl
	push bc
	push de
	call Func_04cf
	ld hl, wd4c2
	ld [hl], e
	inc hl
	ld [hl], d
	call $43b9
	ld a, [wd4c6]
	ld [$d23d], a
	ld de, $d23e
	ld bc, $0006
	call Func_3bf5
	ld l, e
	ld h, d
	ld a, [hli]
	ld [$d12f], a
	ld a, [hli]
	ld [$d130], a
	ld a, [hli]
	ld [$d23a], a
	ld a, [hli]
	ld [$d23b], a
	ld a, [hli]
	ld [$d23c], a
	call $40bd
	pop de
	pop bc
	pop hl
	ret
; 0x800bd

INCBIN "baserom.gbc",$800bd,$801a1 - $800bd

Func_801a1: ; 801a1 (20:41a1)
	push hl
	push bc
	push de
	ld a, [$ff81]
	push af
	ld a, $1
	call BankswitchRAM
	ld hl, $a000
	ld de, $9800
	ld c, $20
.asm_801b4
	push bc
	push hl
	push de
	ld b, $20
	call $06fc
	ld a, [wConsole]
	cp $2
	jr nz, .asm_801d6
	pop de
	pop hl
	push hl
	push de
	ld bc, $0400
	add hl, bc
	call BankswitchVRAM_1
	ld b, $20
	call $06fc
	call BankswitchVRAM_0

.asm_801d6
	pop hl
	ld de, $0020
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld bc, $0020
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_801b4
	pop af
	call BankswitchRAM
	call DisableExtRAM
	pop de
	pop bc
	pop hl
	ret

Func_801f1: ; 801f1 (20:41f1)
	push hl
	push bc
	ld a, [$ff81]
	push af
	ld a, $1
	call BankswitchRAM
	ld hl, $a000
	ld bc, $0800
	xor a
	call $3c10
	pop af
	call BankswitchRAM
	call DisableExtRAM
	pop bc
	pop hl
	ret

Func_8020f: ; 8020f (20:420f)
	push bc
	push af
	ld bc, MapDataPointers
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
	ld [wd4c4], a
	ld a, [hli]
	ld [wd4c5], a
	ld a, [hli]
	add $20
	ld [wd4c6], a
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
	ld [wd4c8], a
	ld a, $10
	ld [wd4c7], a
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
	ld a, [wd4c8]
	ld b, a
	ld a, [wd4c7]
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
	call BankswitchVRAM_0
	pop de
	pop bc
	pop hl
	ret

Func_8029f: ; 8029f (20:429f)
	ld a, [wd4ca]
	swap a
	push af
	and $f0
	ld [wd4c2], a
	pop af
	and $f
	add $80
	ld [wd4c3], a
	ld a, [wd4cb]
	and $1
	call BankswitchVRAM
	ret

Func_802bb: ; 802bb (20:42bb)
	ld a, [wd4ca]
	push af
	xor $80
	ld [wd4ca], a
	call Func_8029f
	ld a, [wd4c3]
	add $8
	ld [wd4c3], a
	pop af
	ld [wd4ca], a
	ret
; 0x802d4

INCBIN "baserom.gbc",$802d4,$80418 - $802d4

Func_80418: ; 80418 (20:4418)
INCBIN "baserom.gbc",$80418,$80480 - $80418

Func_80480: ; 80480 (20:4480)
INCBIN "baserom.gbc",$80480,$804d8 - $80480

Func_804d8: ; 804d8 (20:44d8)
INCBIN "baserom.gbc",$804d8,$80b7a - $804d8

Func_80b7a: ; 80b7a (20:4b7a)
INCBIN "baserom.gbc",$80b7a,$80ba4 - $80b7a

Func_80ba4: ; 80ba4 (20:4ba4)
	push af
	xor a
	ld [$d292], a
	pop af
	push hl
	push bc
	push de
	ld c, a
	ld a, [wd131]
	push af
	ld a, [$d23d]
	push af
	ld a, [$d12f]
	push af
	ld a, [$d130]
	push af
	ld a, [$d23a]
	push af
	ld a, [$d23b]
	push af
	ld b, $0
	ld hl, wd323
	add hl, bc
	ld a, $1
	ld [hl], a
	ld a, c
	add a
	ld c, a
	ld b, $0
	ld hl, $4c21
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld a, [wConsole]
	cp $2
	jr nz, .asm_80be7
	inc hl

.asm_80be7
	ld a, [hl]
	ld [wd131], a
	push bc
	farcallx $20, $4082
	pop bc
	srl b
	ld a, c
	rrca
	and $f
	swap a
	add b
	ld c, a
	ld b, $0
	ld hl, wBoosterViableCardList
	add hl, bc
	farcallx $3, $438f
	pop af
	ld [$d23b], a
	pop af
	ld [$d23a], a
	pop af
	ld [$d130], a
	pop af
	ld [$d12f], a
	pop af
	ld [$d23d], a
	pop af
	ld [wd131], a
	pop de
	pop bc
	pop hl
	ret
; 0x80c21

INCBIN "baserom.gbc",$80c21,$80e5a - $80c21

Unknown_80e5a: ; 80e5a (20:4e5a)
INCBIN "baserom.gbc",$80e5a,$80e5d - $80e5a

MapDataPointers: ; 80e5d (20:4e5d)
INCBIN "baserom.gbc",$80e5d,$84000 - $80e5d
