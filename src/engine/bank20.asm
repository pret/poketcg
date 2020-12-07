Func_80000: ; 80000 (20:4000)
	INCROM $80000, $80028

Func_80028: ; 80028 (20:4028)
	call Func_801f1
	ld bc, $0000
	call Func_80077
	farcall $3, $49c7
	call $41a1
	farcall $3, $43ee
	ret
; 0x8003d

	INCROM $8003d, $80077

Func_80077: ; 80077 (20:4077)
	ld a, $1
	ld [wd292], a
	jr .asm_80082

	xor a
	ld [wd292], a

.asm_80082
	push hl
	push bc
	push de
	call BCCoordToBGMap0Address
	ld hl, wd4c2
	ld [hl], e
	inc hl
	ld [hl], d
	call Func_803b9
	ld a, [wTempPointerBank]
	ld [wd23d], a
	ld de, wd23e
	ld bc, $0006
	call CopyBankedDataToDE
	ld l, e
	ld h, d
	ld a, [hli]
	ld [wd12f], a
	ld a, [hli]
	ld [wd130], a
	ld a, [hli]
	ld [wd23a], a
	ld a, [hli]
	ld [wd23b], a
	ld a, [hli]
	ld [wd23c], a
	call Func_800bd
	pop de
	pop bc
	pop hl
	ret

Func_800bd: ; 800bd (20:40bd)
	push hl
	push bc
	push de
	ld a, [wTempPointer]
	add $05
	ld e, a
	ld a, [wTempPointer + 1]
	adc $00
	ld d, a
	ld b, $c0
	call Func_08bf
	ld a, [wd4c2]
	ld e, a
	ld a, [wd4c3]
	ld d, a
	call Func_800e0
	pop de
	pop bc
	pop hl
	ret

Func_800e0: ; 800e0 (20:40e0)
	push hl
	ld hl, $d28e
	ld a, [wd12f]
	ld [hl], a
	ld a, [wd23c]
	or a
	jr z, .asm_800f0
	sla [hl]
.asm_800f0
	ld c, $40
	ld hl, wd23e
	xor a
.asm_800f6
	ld [hli], a
	dec c
	jr nz, .asm_800f6
	ld a, [wd130]
	ld c, a
.asm_800fe
	push bc
	push de
	ld b, $00
	ld a, [$d28e]
	ld c, a
	ld de, wd23e
	call Func_3be4
	ld a, [wd12f]
	ld b, a
	pop de
	push de
	ld hl, wd23e
	call Func_8016e
	ld a, [wConsole]
	cp $02
	jr nz, .asm_8013b
	call BankswitchVRAM1
	ld a, [wd12f]
	ld c, a
	ld b, $00
	ld hl, wd23e
	add hl, bc
	pop de
	push de
	ld a, [wd12f]
	ld b, a
	call Func_80148
	call Func_8016e
	call BankswitchVRAM0
.asm_8013b
	pop de
	ld hl, $20
	add hl, de
	ld e, l
	ld d, h
	pop bc
	dec c
	jr nz, .asm_800fe
	pop hl
	ret

Func_80148: ; 80148 (20:4148)
	ld a, [$d291]
	or a
	ret z
	ld a, [$d23c]
	or a
	jr z, .asm_80162
	push hl
	push bc
.asm_80155
	push bc
	ld a, [$d291]
	add [hl]
	ld [hli], a
	pop bc
	dec b
	jr nz, .asm_80155
	pop bc
	pop hl
	ret
.asm_80162
	push hl
	push bc
	ld a, [$d291]
.asm_80167
	ld [hli], a
	dec b
	jr nz, .asm_80167
	pop bc
	pop hl
	ret

Func_8016e: ; 8016e (20:416e)
	ld a, [wd292]
	or a
	jp z, SafeCopyDataHLtoDE
	push hl
	push bc
	push de
	ldh a, [hBankSRAM]
	push af
	ld a, $01
	call BankswitchSRAM
	push hl
	ld hl, $800
	ldh a, [hBankVRAM]
	or a
	jr z, .asm_8018c
	ld hl, $c00
.asm_8018c
	add hl, de
	ld e, l
	ld d, h
	pop hl
.asm_80190
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_80190
	pop af
	call BankswitchSRAM
	call DisableSRAM
	pop de
	pop bc
	pop hl
	ret

Func_801a1: ; 801a1 (20:41a1)
	push hl
	push bc
	push de
	ldh a, [hBankSRAM]
	push af
	ld a, $1
	call BankswitchSRAM
	ld hl, v0End
	ld de, v0BGMap0
	ld c, $20
.asm_801b4
	push bc
	push hl
	push de
	ld b, $20
	call SafeCopyDataHLtoDE
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .asm_801d6
	pop de
	pop hl
	push hl
	push de
	ld bc, $0400
	add hl, bc
	call BankswitchVRAM1
	ld b, $20
	call SafeCopyDataHLtoDE
	call BankswitchVRAM0

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
	call BankswitchSRAM
	call DisableSRAM
	pop de
	pop bc
	pop hl
	ret

; Clears the first x800 bytes of S1:a000
Func_801f1: ; 801f1 (20:41f1)
	push hl
	push bc
	ldh a, [hBankSRAM]
	push af
	ld a, $1
	call BankswitchSRAM
	ld hl, $a000
	ld bc, $0800
	xor a
	call FillMemoryWithA
	pop af
	call BankswitchSRAM
	call DisableSRAM
	pop bc
	pop hl
	ret

; l - map data offset (0,2,4,6,8 for banks 0,1,2,3,4)
; a - map index (inside of the given bank)
GetMapDataPointer: ; 8020f (20:420f)
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

; Loads a pointer from [hl] to wTempPointer. Adds the graphics bank offset ($20)
LoadGraphicsPointerFromHL: ; 80229 (20:4229)
	ld a, [hli]
	ld [wTempPointer], a
	ld a, [hli]
	ld [wTempPointer + 1], a
	ld a, [hli]
	add BANK(MapDataPointers)
	ld [wTempPointerBank], a
	ret
; 0x80238

	INCROM $80238, $8025b

Func_8025b: ; 8025b (20:425b)
	push hl
	ld l, $4
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
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
asm_8027c:
	push hl
	push bc
	push de
	ld a, [wd4c8]
	ld b, a
	ld a, [wd4c7]
	ld c, a
	ld hl, wd4c2
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wTempPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	call Func_395a
	call BankswitchVRAM0
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

	INCROM $802d4, $803b9

Func_803b9: ; 803b9 (20:43b9)
	ld l, $00
	ld a, [wd131]
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
	ld a, [hl]
	ld [$d239], a
	ret
; 0x803c9

	INCROM $803c9, $80418

Func_80418: ; 80418 (20:4418)
	INCROM $80418, $80480

Func_80480: ; 80480 (20:4480)
	INCROM $80480, $804d8

Func_804d8: ; 804d8 (20:44d8)
	INCROM $804d8, $80b7a

Func_80b7a: ; 80b7a (20:4b7a)
	INCROM $80b7a, $80b89

Func_80b89: ; 80b89 (20:4b89)
	push hl
	push bc
	push af
	ld c, a
	ld a, $01
	ld [$d292], a
	ld b, $00
	ld hl, $d323
	add hl, bc
	ld a, [hl]
	or a
	jr z, .asm_80ba0
	ld a, c
	call Func_80baa
.asm_80ba0
	pop af
	pop bc
	pop hl
	ret

Func_80ba4: ; 80ba4 (20:4ba4)
	push af
	xor a
	ld [wd292], a
	pop af
;	Fallthrough

Func_80baa: ; 80baa (20:4baa)
	push hl
	push bc
	push de
	ld c, a
	ld a, [wd131]
	push af
	ld a, [wd23d]
	push af
	ld a, [wd12f]
	push af
	ld a, [wd130]
	push af
	ld a, [wd23a]
	push af
	ld a, [wd23b]
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
	cp CONSOLE_CGB
	jr nz, .asm_80be7
	inc hl

.asm_80be7
	ld a, [hl]
	ld [wd131], a
	push bc
	farcall $20, $4082
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
	farcall $3, $438f
	pop af
	ld [wd23b], a
	pop af
	ld [wd23a], a
	pop af
	ld [wd130], a
	pop af
	ld [wd12f], a
	pop af
	ld [wd23d], a
	pop af
	ld [wd131], a
	pop de
	pop bc
	pop hl
	ret
; 0x80c21

	INCROM $80c21, $80e5a

SpriteNullAnimationPointer: ; 80e5a (20:4e5a)
	dw SpriteNullAnimationFrame

SpriteNullAnimationFrame:
	db 0

; might be closer to "screen specific data" than map data
; data in each section is 4 bytes long.
MapDataPointers: ; 80e5d (20:4e5d)
	dw MapDataPointers_80e67
	dw MapDataPointers_8100f
	dw MapDataPointers_8116b
	dw SpriteAnimationPointers
	dw MapDataPointers_81697

MapDataPointers_80e67: ; 80e67 (20:4e67)
	INCROM $80e67, $8100f

MapDataPointers_8100f: ; 8100f (20:500f)
	INCROM $8100f, $8116b

MapDataPointers_8116b: ; 8116b (20:516b)
	INCROM $8116b, $81333

; pointer low, pointer high, bank (minus $20), unknown
SpriteAnimationPointers: ; 81333 (20:5333)
	INCROM $81333, $81697

MapDataPointers_81697: ; 81697 (20:5697)
	INCROM $81697, $84000
