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
	ld hl, wVRAMPointer
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
	ld a, [wVRAMPointer]
	ld e, a
	ld a, [wVRAMPointer + 1]
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

; loads graphics data from third map data pointers
; input:
; a = sprite index within the data map
; output:
; a = number of tiles in sprite
Func_8025b: ; 8025b (20:425b)
	push hl
	ld l, $4
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
	ld a, [hl] ; sprite number of tiles
	push af
	ld [wCurSpriteNumTiles], a
	ld a, TILE_SIZE
	ld [wCurSpriteTileSize], a
	call LoadGfxDataFromTempPointerToVRAMBank
	pop af
	pop hl
	ret

; loads graphics data pointed by wTempPointer in wTempPointerBank
; to the VRAM bank according to wd4cb, in address pointed by wVRAMPointer
LoadGfxDataFromTempPointerToVRAMBank: ; 80274 (20:4274)
	call GetTileOffsetPointerAndSwitchVRAM
	jr LoadGfxDataFromTempPointer

Func_80279: ; 80279 (20:4279)
	call Func_802bb

; loads graphics data pointed by wTempPointer in wTempPointerBank
; to wVRAMPointer
LoadGfxDataFromTempPointer:
	push hl
	push bc
	push de
	ld a, [wCurSpriteNumTiles]
	ld b, a
	ld a, [wCurSpriteTileSize]
	ld c, a
	ld hl, wVRAMPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wTempPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	inc hl
	call CopyGfxDataFromTempBank
	call BankswitchVRAM0
	pop de
	pop bc
	pop hl
	ret

; convert wVRAMTileOffset to address in VRAM
; and stores it in wVRAMPointer
; switches VRAM according to wd4cb
GetTileOffsetPointerAndSwitchVRAM: ; 8029f (20:429f)
; address of the tile offset is wVRAMTileOffset * $10 + $8000
	ld a, [wVRAMTileOffset]
	swap a
	push af
	and $f0
	ld [wVRAMPointer], a
	pop af
	and $f
	add HIGH(v0Tiles0) ; $80
	ld [wVRAMPointer + 1], a

; if bottom bit in wd4cb is not set = VRAM0
; if bottom bit in wd4cb is set     = VRAM1
	ld a, [wd4cb]
	and $1
	call BankswitchVRAM
	ret

Func_802bb: ; 802bb (20:42bb)
	ld a, [wd4ca]
	push af
	xor $80
	ld [wd4ca], a
	call GetTileOffsetPointerAndSwitchVRAM
	ld a, [wVRAMPointer + 1]
	add $8
	ld [wVRAMPointer + 1], a
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

	INCROM $803c9, $803ec

; copies from palette data in hl c*8 bytes to palette index b
; in WRAM, starting from wBackgroundPalettesCGB
; b = palette index
; c = palette size
; hl = palette data to copy
LoadPaletteData: ; 803ec (20:43ec)
	push hl
	push bc
	push de
	ld a, b
	cp NUM_BACKGROUND_PALETTES + NUM_OBJECT_PALETTES ; total palettes available
	jr nc, .fail_return

	add a ; 2 * index
	add a ; 4 * index
	add a ; 8 * index
	add LOW(wBackgroundPalettesCGB)
	ld e, a
	ld a, HIGH(wBackgroundPalettesCGB)
	adc 0
	ld d, a

	ld a, c
	cp $09
	jr nc, .fail_return

	add a ; 2 * size
	add a ; 4 * size
	add a ; 8 * size
	ld c, a
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	call FlushAllPalettes
	jr .success_return

.fail_return
	debug_ret

.success_return
	pop de
	pop bc
	pop hl
	ret
; 0x80418

Func_80418: ; 80418 (20:4418)
	push hl
	push bc
	push de
	call CopyPaletteDataToBuffer

	ld hl, wd23e
	ld a, [hli] ; number palettes
	ld c, a
	or a
	jr z, .check_palette_size

	ld a, [wd4ca]
	cp $01
	jr z, .obp1

	ld a, [hli] ; pallete for OBP0
	push hl
	push bc
	call SetOBP0
	pop bc
	pop hl
	dec c
	jr z, .check_palette_size

.obp1
	ld a, [hli] ; pallete for OBP1
	push hl
	push bc
	call SetOBP1
	pop bc
	pop hl
	dec c
	jr z, .check_palette_size
	inc hl

.check_palette_size
	ld a, [hli]
	or a
	jr z, .done

; non-zero size, so load it from data
	ld c, a
	ld a, [wd4cb]
	; ensure it's a palette index starting from wObjectPalettesCGB
	or NUM_BACKGROUND_PALETTES
	ld b, a
	call LoadPaletteData

.done
	pop de
	pop bc
	pop hl
	ret
; 0x80456

; copies palette data of index in a to wd23e
CopyPaletteDataToBuffer: ; 80456 (20:4456)
	push hl
	push bc
	push de
	ld l, $08
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL

; size parameter
	ld a, [hl]
	ld b, a
	and $0f
	inc a
	ld c, a
	ld a, b
	and $f0
	srl a
	inc a
	add c
	ld c, a
	ld b, $00

	ld de, wd23e
	call CopyBankedDataToDE
	pop de
	pop bc
	pop hl
	ret
; 0x8047b

	INCROM $8047b, $80480

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
MapDataPointers: ; 80e5d (20:4e5d)
	dw MapDataPointers_80e67
	dw MapDataPointers_8100f
	dw MapDataPointers_8116b
	dw SpriteAnimationPointers
	dw MapDataPointers_81697

MapDataPointers_80e67: ; 80e67 (20:4e67)
	db $1b, $59, $00, $00
	db $22, $5a, $00, $00
	db $13, $5c, $00, $01
	db $2e, $5d, $00, $01
	db $d1, $5e, $00, $01
	db $f5, $5e, $00, $01
	db $26, $5f, $00, $01
	db $eb, $5f, $00, $01
	db $43, $61, $00, $01
	db $50, $61, $00, $01
	db $60, $61, $00, $02
	db $22, $62, $00, $02
	db $36, $63, $00, $03
	db $00, $64, $00, $03
	db $1d, $65, $00, $03
	db $e7, $65, $00, $03
	db $04, $67, $00, $03
	db $ce, $67, $00, $03
	db $eb, $68, $00, $03
	db $b5, $69, $00, $03
	db $d2, $6a, $00, $03
	db $9c, $6b, $00, $03
	db $b9, $6c, $00, $03
	db $83, $6d, $00, $03
	db $a0, $6e, $00, $03
	db $6a, $6f, $00, $03
	db $87, $70, $00, $03
	db $51, $71, $00, $03
	db $6e, $72, $00, $03
	db $21, $73, $00, $03
	db $24, $74, $00, $04
	db $45, $75, $00, $04
	db $db, $76, $00, $05
	db $8c, $77, $00, $05
	db $8d, $78, $00, $06
	db $d6, $79, $00, $06
	db $00, $40, $01, $07
	db $88, $41, $01, $07
	db $bb, $43, $01, $08
	db $33, $45, $01, $08
	db $2e, $47, $01, $09
	db $d8, $48, $01, $09
	db $73, $4b, $01, $0a
	db $6f, $4c, $01, $0a
	db $fe, $4d, $01, $0b
	db $1d, $4f, $01, $0b
	db $b6, $50, $01, $0c
	db $91, $51, $01, $0c
	db $15, $53, $01, $0d
	db $b3, $54, $01, $0d
	db $0a, $57, $01, $0e
	db $ce, $57, $01, $0e
	db $f1, $7b, $00, $0e
	db $03, $7c, $00, $0e
	db $ef, $58, $01, $0f
	db $79, $5a, $01, $0f
	db $1a, $7c, $00, $0f
	db $26, $7c, $00, $0f
	db $e2, $5c, $01, $10
	db $f4, $5d, $01, $10
	db $7c, $5f, $01, $11
	db $7f, $60, $01, $11
	db $36, $7c, $00, $12
	db $7d, $61, $01, $12
	db $93, $61, $01, $12
	db $a9, $61, $01, $12
	db $bf, $61, $01, $12
	db $d5, $61, $01, $12
	db $eb, $61, $01, $12
	db $01, $62, $01, $12
	db $17, $62, $01, $13
	db $da, $62, $01, $13
	db $64, $63, $01, $13
	db $43, $64, $01, $13
	db $df, $64, $01, $14
	db $b5, $65, $01, $14
	db $47, $66, $01, $15
	db $b8, $66, $01, $16
	db $3e, $67, $01, $17
	db $af, $67, $01, $18
	db $33, $68, $01, $19
	db $a4, $68, $01, $1a
	db $25, $69, $01, $1b
	db $96, $69, $01, $1c
	db $14, $6a, $01, $1d
	db $85, $6a, $01, $1e
	db $28, $6b, $01, $1f
	db $99, $6b, $01, $20
	db $34, $6c, $01, $21
	db $a5, $6c, $01, $22
	db $37, $6d, $01, $23
	db $cc, $6d, $01, $24
	db $8a, $6e, $01, $25
	db $18, $6f, $01, $25
	db $c0, $6f, $01, $25
	db $4f, $70, $01, $26
	db $a5, $71, $01, $27
	db $97, $73, $01, $28
	db $b7, $73, $01, $29
	db $e5, $73, $01, $2a
	db $13, $74, $01, $2b
	db $38, $75, $01, $2c
	db $9f, $76, $01, $2d
	db $f6, $76, $01, $2d
	db $7c, $77, $01, $2e
	db $c4, $77, $01, $2f

MapDataPointers_8100f: ; 8100f (20:500f)
	db $00, $40, $02, $c1
	db $12, $4c, $02, $97
	db $28, $78, $01, $4d
	db $84, $55, $02, $81
	db $96, $5d, $02, $78
	db $18, $65, $02, $63
	db $4a, $6b, $02, $3c
	db $0c, $6f, $02, $a1
	db $00, $40, $03, $83
	db $1e, $79, $02, $57
	db $32, $48, $03, $3a
	db $d4, $4b, $03, $52
	db $f6, $50, $03, $57
	db $68, $56, $03, $9d
	db $3a, $60, $03, $4e
	db $1c, $65, $03, $cf
	db $0e, $72, $03, $79
	db $00, $40, $04, $bd
	db $a0, $79, $03, $48
	db $d2, $4b, $04, $6d
	db $a4, $52, $04, $5d
	db $76, $58, $04, $60
	db $78, $5e, $04, $56
	db $da, $63, $04, $60
	db $dc, $69, $04, $56
	db $3e, $6f, $04, $60
	db $40, $75, $04, $56
	db $00, $40, $05, $60
	db $02, $46, $05, $56
	db $64, $4b, $05, $60
	db $66, $51, $05, $60
	db $68, $57, $05, $60
	db $6a, $5d, $05, $60
	db $6c, $63, $05, $60
	db $6e, $69, $05, $60
	db $70, $6f, $05, $61
	db $82, $75, $05, $61
	db $fa, $7c, $01, $04
	db $00, $40, $06, $f4
	db $42, $4f, $06, $3b
	db $3c, $7d, $01, $04
	db $7e, $7d, $01, $24
	db $a2, $7a, $04, $24
	db $f4, $62, $06, $dc
	db $b6, $70, $06, $d4
	db $e4, $7c, $04, $24
	db $22, $7e, $03, $18
	db $94, $7b, $05, $31
	db $00, $40, $07, $24
	db $42, $42, $07, $24
	db $84, $44, $07, $24
	db $c6, $46, $07, $24
	db $08, $49, $07, $24
	db $4a, $4b, $07, $24
	db $8c, $4d, $07, $24
	db $ce, $4f, $07, $24
	db $10, $52, $07, $24
	db $52, $54, $07, $24
	db $94, $56, $07, $24
	db $d6, $58, $07, $24
	db $18, $5b, $07, $24
	db $5a, $5d, $07, $24
	db $9c, $5f, $07, $24
	db $de, $61, $07, $24
	db $20, $64, $07, $24
	db $62, $66, $07, $24
	db $a4, $68, $07, $24
	db $e6, $6a, $07, $24
	db $28, $6d, $07, $24
	db $6a, $6f, $07, $24
	db $ac, $71, $07, $24
	db $ee, $73, $07, $24
	db $30, $76, $07, $24
	db $72, $78, $07, $24
	db $b4, $7a, $07, $24
	db $f6, $7c, $07, $24
	db $00, $40, $08, $24
	db $42, $42, $08, $24
	db $84, $44, $08, $24
	db $c6, $46, $08, $24
	db $08, $49, $08, $24
	db $4a, $4b, $08, $24
	db $8c, $4d, $08, $24
	db $ce, $4f, $08, $24
	db $10, $52, $08, $24
	db $52, $54, $08, $24
	db $94, $56, $08, $24

; \1 = gfx pointer
; \2 = number of tiles
gfx_pointer: MACRO
	dwb \1, BANK(\1) - BANK(MapDataPointers_8116b)
	db \2
ENDM

MapDataPointers_8116b: ; 8116b (20:516b)
	gfx_pointer OWPlayerGfx,        $14 ; SPRITE_OW_PLAYER
	gfx_pointer OWRonaldGfx,        $14 ; SPRITE_OW_RONALD
	gfx_pointer OWDrMasonGfx,       $14 ; SPRITE_OW_DRMASON
	gfx_pointer OWIshiharaGfx,      $14 ; SPRITE_OW_ISHIHARA
	gfx_pointer OWImakuniGfx,       $14 ; SPRITE_OW_IMAKUNI
	gfx_pointer OWNikkiGfx,         $14 ; SPRITE_OW_NIKKI
	gfx_pointer OWRickGfx,          $14 ; SPRITE_OW_RICK
	gfx_pointer OWKenGfx,           $14 ; SPRITE_OW_KEN
	gfx_pointer OWAmyGfx,           $1b ; SPRITE_OW_AMY
	gfx_pointer OWIsaacGfx,         $14 ; SPRITE_OW_ISAAC
	gfx_pointer OWMitchGfx,         $14 ; SPRITE_OW_MITCH
	gfx_pointer OWGeneGfx,          $14 ; SPRITE_OW_GENE
	gfx_pointer OWMurrayGfx,        $14 ; SPRITE_OW_MURRAY
	gfx_pointer OWCourtneyGfx,      $14 ; SPRITE_OW_COURTNEY
	gfx_pointer OWSteveGfx,         $14 ; SPRITE_OW_STEVE
	gfx_pointer OWJackGfx,          $14 ; SPRITE_OW_JACK
	gfx_pointer OWRodGfx,           $14 ; SPRITE_OW_ROD
	gfx_pointer OWBoyGfx,           $14 ; SPRITE_OW_BOY
	gfx_pointer OWLadGfx,           $14 ; SPRITE_OW_LAD
	gfx_pointer OWSpecsGfx,         $14 ; SPRITE_OW_SPECS
	gfx_pointer OWButchGfx,         $14 ; SPRITE_OW_BUTCH
	gfx_pointer OWManiaGfx,         $14 ; SPRITE_OW_MANIA
	gfx_pointer OWJoshuaGfx,        $14 ; SPRITE_OW_JOSHUA
	gfx_pointer OWHoodGfx,          $14 ; SPRITE_OW_HOOD
	gfx_pointer OWTechGfx,          $14 ; SPRITE_OW_TECH
	gfx_pointer OWChapGfx,          $14 ; SPRITE_OW_CHAP
	gfx_pointer OWManGfx,           $14 ; SPRITE_OW_MAN
	gfx_pointer OWPappyGfx,         $14 ; SPRITE_OW_PAPPY
	gfx_pointer OWGirlGfx,          $14 ; SPRITE_OW_GIRL
	gfx_pointer OWLass1Gfx,         $14 ; SPRITE_OW_LASS1
	gfx_pointer OWLass2Gfx,         $14 ; SPRITE_OW_LASS2
	gfx_pointer OWLass3Gfx,         $14 ; SPRITE_OW_LASS3
	gfx_pointer OWSwimmerGfx,       $14 ; SPRITE_OW_SWIMMER
	gfx_pointer OWClerkGfx,         $08 ; SPRITE_OW_CLERK
	gfx_pointer OWGalGfx,           $14 ; SPRITE_OW_GAL
	gfx_pointer OWWomanGfx,         $14 ; SPRITE_OW_WOMAN
	gfx_pointer OWGrannyGfx,        $14 ; SPRITE_OW_GRANNY
	gfx_pointer OverworldMapOAMGfx, $08 ; SPRITE_OW_MAP_OAM
	gfx_pointer Duel0Gfx,           $16 ; SPRITE_DUEL_0
	gfx_pointer Duel63Gfx,          $0a ; SPRITE_DUEL_63
	gfx_pointer DuelGlowGfx,        $0b ; SPRITE_DUEL_GLOW
	gfx_pointer Duel1Gfx,           $06 ; SPRITE_DUEL_1
	gfx_pointer Duel2Gfx,           $08 ; SPRITE_DUEL_2
	gfx_pointer Duel55Gfx,          $02 ; SPRITE_DUEL_55
	gfx_pointer Duel58Gfx,          $04 ; SPRITE_DUEL_58
	gfx_pointer Duel3Gfx,           $09 ; SPRITE_DUEL_3
	gfx_pointer Duel4Gfx,           $12 ; SPRITE_DUEL_4
	gfx_pointer Duel5Gfx,           $09 ; SPRITE_DUEL_5
	gfx_pointer Duel6Gfx,           $11 ; SPRITE_DUEL_6
	gfx_pointer Duel59Gfx,          $03 ; SPRITE_DUEL_59
	gfx_pointer Duel7Gfx,           $2d ; SPRITE_DUEL_7
	gfx_pointer Duel8Gfx,           $0d ; SPRITE_DUEL_8
	gfx_pointer Duel9Gfx,           $1c ; SPRITE_DUEL_9
	gfx_pointer Duel10Gfx,          $4c ; SPRITE_DUEL_10
	gfx_pointer Duel61Gfx,          $03 ; SPRITE_DUEL_61
	gfx_pointer Duel11Gfx,          $1b ; SPRITE_DUEL_11
	gfx_pointer Duel12Gfx,          $07 ; SPRITE_DUEL_12
	gfx_pointer Duel13Gfx,          $0c ; SPRITE_DUEL_13
	gfx_pointer Duel62Gfx,          $01 ; SPRITE_DUEL_62
	gfx_pointer Duel14Gfx,          $22 ; SPRITE_DUEL_14
	gfx_pointer Duel15Gfx,          $20 ; SPRITE_DUEL_15
	gfx_pointer Duel16Gfx,          $0a ; SPRITE_DUEL_16
	gfx_pointer Duel17Gfx,          $25 ; SPRITE_DUEL_17
	gfx_pointer Duel18Gfx,          $18 ; SPRITE_DUEL_18
	gfx_pointer Duel19Gfx,          $1b ; SPRITE_DUEL_19
	gfx_pointer Duel20Gfx,          $08 ; SPRITE_DUEL_20
	gfx_pointer Duel21Gfx,          $0d ; SPRITE_DUEL_21
	gfx_pointer Duel22Gfx,          $22 ; SPRITE_DUEL_22
	gfx_pointer Duel23Gfx,          $0c ; SPRITE_DUEL_23
	gfx_pointer Duel24Gfx,          $25 ; SPRITE_DUEL_24
	gfx_pointer Duel25Gfx,          $22 ; SPRITE_DUEL_25
	gfx_pointer Duel26Gfx,          $0c ; SPRITE_DUEL_26
	gfx_pointer Duel27Gfx,          $4c ; SPRITE_DUEL_27
	gfx_pointer Duel28Gfx,          $08 ; SPRITE_DUEL_28
	gfx_pointer Duel29Gfx,          $07 ; SPRITE_DUEL_29
	gfx_pointer Duel56Gfx,          $01 ; SPRITE_DUEL_56
	gfx_pointer Duel30Gfx,          $1a ; SPRITE_DUEL_30
	gfx_pointer Duel31Gfx,          $0a ; SPRITE_DUEL_31
	gfx_pointer Duel32Gfx,          $2e ; SPRITE_DUEL_32
	gfx_pointer Duel33Gfx,          $08 ; SPRITE_DUEL_33
	gfx_pointer Duel34Gfx,          $07 ; SPRITE_DUEL_34
	gfx_pointer Duel35Gfx,          $1c ; SPRITE_DUEL_35
	gfx_pointer Duel66Gfx,          $04 ; SPRITE_DUEL_66
	gfx_pointer Duel36Gfx,          $08 ; SPRITE_DUEL_36
	gfx_pointer Duel37Gfx,          $0b ; SPRITE_DUEL_37
	gfx_pointer Duel57Gfx,          $01 ; SPRITE_DUEL_57
	gfx_pointer Duel38Gfx,          $1c ; SPRITE_DUEL_38
	gfx_pointer Duel39Gfx,          $16 ; SPRITE_DUEL_39
	gfx_pointer Duel40Gfx,          $10 ; SPRITE_DUEL_40
	gfx_pointer Duel41Gfx,          $0f ; SPRITE_DUEL_41
	gfx_pointer Duel42Gfx,          $07 ; SPRITE_DUEL_42
	gfx_pointer Duel43Gfx,          $0a ; SPRITE_DUEL_43
	gfx_pointer Duel44Gfx,          $09 ; SPRITE_DUEL_44
	gfx_pointer Duel60Gfx,          $02 ; SPRITE_DUEL_60
	gfx_pointer Duel64Gfx,          $02 ; SPRITE_DUEL_64
	gfx_pointer Duel45Gfx,          $03 ; SPRITE_DUEL_45
	gfx_pointer Duel46Gfx,          $08 ; SPRITE_DUEL_46
	gfx_pointer Duel47Gfx,          $0f ; SPRITE_DUEL_47
	gfx_pointer Duel48Gfx,          $03 ; SPRITE_DUEL_48
	gfx_pointer Duel49Gfx,          $05 ; SPRITE_DUEL_49
	gfx_pointer Duel50Gfx,          $17 ; SPRITE_DUEL_50
	gfx_pointer Duel51Gfx,          $36 ; SPRITE_DUEL_WON_LOST_DRAW
	gfx_pointer Duel52Gfx,          $0b ; SPRITE_DUEL_52
	gfx_pointer Duel53Gfx,          $06 ; SPRITE_DUEL_53
	gfx_pointer Duel54Gfx,          $16 ; SPRITE_DUEL_54
	gfx_pointer BoosterPackOAMGfx,  $20 ; SPRITE_BOOSTER_PACK_OAM
	gfx_pointer PressStartGfx,      $14 ; SPRITE_PRESS_START
	gfx_pointer GrassGfx,           $04 ; SPRITE_GRASS
	gfx_pointer FireGfx,            $04 ; SPRITE_FIRE
	gfx_pointer WaterGfx,           $04 ; SPRITE_WATER
	gfx_pointer ColorlessGfx,       $04 ; SPRITE_COLORLESS
	gfx_pointer LightningGfx,       $04 ; SPRITE_LIGHTNING
	gfx_pointer PsychicGfx,         $04 ; SPRITE_PSYCHIC
	gfx_pointer FightingGfx,        $04 ; SPRITE_FIGHTING

; \1 = anim data pointer
anim_data_pointer: MACRO
	dwb \1, BANK(\1) - BANK(SpriteAnimationPointers)
	db $00 ; unused (padding?)
ENDM

SpriteAnimationPointers: ; 81333 (20:5333)
	anim_data_pointer AnimData0   ; $00
	anim_data_pointer AnimData1   ; $01
	anim_data_pointer AnimData2   ; $02
	anim_data_pointer AnimData3   ; $03
	anim_data_pointer AnimData4   ; $04
	anim_data_pointer AnimData5   ; $05
	anim_data_pointer AnimData6   ; $06
	anim_data_pointer AnimData7   ; $07
	anim_data_pointer AnimData8   ; $08
	anim_data_pointer AnimData9   ; $09
	anim_data_pointer AnimData10  ; $0a
	anim_data_pointer AnimData11  ; $0b
	anim_data_pointer AnimData12  ; $0c
	anim_data_pointer AnimData13  ; $0d
	anim_data_pointer AnimData14  ; $0e
	anim_data_pointer AnimData15  ; $0f
	anim_data_pointer AnimData16  ; $10
	anim_data_pointer AnimData17  ; $11
	anim_data_pointer AnimData18  ; $12
	anim_data_pointer AnimData19  ; $13
	anim_data_pointer AnimData20  ; $14
	anim_data_pointer AnimData21  ; $15
	anim_data_pointer AnimData22  ; $16
	anim_data_pointer AnimData23  ; $17
	anim_data_pointer AnimData24  ; $18
	anim_data_pointer AnimData25  ; $19
	anim_data_pointer AnimData26  ; $1a
	anim_data_pointer AnimData27  ; $1b
	anim_data_pointer AnimData28  ; $1c
	anim_data_pointer AnimData29  ; $1d
	anim_data_pointer AnimData30  ; $1e
	anim_data_pointer AnimData31  ; $1f
	anim_data_pointer AnimData32  ; $20
	anim_data_pointer AnimData33  ; $21
	anim_data_pointer AnimData34  ; $22
	anim_data_pointer AnimData35  ; $23
	anim_data_pointer AnimData36  ; $24
	anim_data_pointer AnimData37  ; $25
	anim_data_pointer AnimData38  ; $26
	anim_data_pointer AnimData39  ; $27
	anim_data_pointer AnimData40  ; $28
	anim_data_pointer AnimData41  ; $29
	anim_data_pointer AnimData42  ; $2a
	anim_data_pointer AnimData43  ; $2b
	anim_data_pointer AnimData44  ; $2c
	anim_data_pointer AnimData45  ; $2d
	anim_data_pointer AnimData46  ; $2e
	anim_data_pointer AnimData47  ; $2f
	anim_data_pointer AnimData48  ; $30
	anim_data_pointer AnimData49  ; $31
	anim_data_pointer AnimData50  ; $32
	anim_data_pointer AnimData51  ; $33
	anim_data_pointer AnimData52  ; $34
	anim_data_pointer AnimData53  ; $35
	anim_data_pointer AnimData54  ; $36
	anim_data_pointer AnimData55  ; $37
	anim_data_pointer AnimData56  ; $38
	anim_data_pointer AnimData57  ; $39
	anim_data_pointer AnimData58  ; $3a
	anim_data_pointer AnimData59  ; $3b
	anim_data_pointer AnimData60  ; $3c
	anim_data_pointer AnimData61  ; $3d
	anim_data_pointer AnimData62  ; $3e
	anim_data_pointer AnimData63  ; $3f
	anim_data_pointer AnimData64  ; $40
	anim_data_pointer AnimData65  ; $41
	anim_data_pointer AnimData66  ; $42
	anim_data_pointer AnimData67  ; $43
	anim_data_pointer AnimData68  ; $44
	anim_data_pointer AnimData69  ; $45
	anim_data_pointer AnimData70  ; $46
	anim_data_pointer AnimData71  ; $47
	anim_data_pointer AnimData72  ; $48
	anim_data_pointer AnimData73  ; $49
	anim_data_pointer AnimData74  ; $4a
	anim_data_pointer AnimData75  ; $4b
	anim_data_pointer AnimData76  ; $4c
	anim_data_pointer AnimData77  ; $4d
	anim_data_pointer AnimData78  ; $4e
	anim_data_pointer AnimData79  ; $4f
	anim_data_pointer AnimData80  ; $50
	anim_data_pointer AnimData81  ; $51
	anim_data_pointer AnimData82  ; $52
	anim_data_pointer AnimData83  ; $53
	anim_data_pointer AnimData84  ; $54
	anim_data_pointer AnimData85  ; $55
	anim_data_pointer AnimData86  ; $56
	anim_data_pointer AnimData87  ; $57
	anim_data_pointer AnimData88  ; $58
	anim_data_pointer AnimData89  ; $59
	anim_data_pointer AnimData90  ; $5a
	anim_data_pointer AnimData91  ; $5b
	anim_data_pointer AnimData92  ; $5c
	anim_data_pointer AnimData93  ; $5d
	anim_data_pointer AnimData94  ; $5e
	anim_data_pointer AnimData95  ; $5f
	anim_data_pointer AnimData96  ; $60
	anim_data_pointer AnimData97  ; $61
	anim_data_pointer AnimData98  ; $62
	anim_data_pointer AnimData99  ; $63
	anim_data_pointer AnimData100 ; $64
	anim_data_pointer AnimData101 ; $65
	anim_data_pointer AnimData102 ; $66
	anim_data_pointer AnimData103 ; $67
	anim_data_pointer AnimData104 ; $68
	anim_data_pointer AnimData105 ; $69
	anim_data_pointer AnimData106 ; $6a
	anim_data_pointer AnimData107 ; $6b
	anim_data_pointer AnimData108 ; $6c
	anim_data_pointer AnimData109 ; $6d
	anim_data_pointer AnimData110 ; $6e
	anim_data_pointer AnimData111 ; $6f
	anim_data_pointer AnimData112 ; $70
	anim_data_pointer AnimData113 ; $71
	anim_data_pointer AnimData114 ; $72
	anim_data_pointer AnimData115 ; $73
	anim_data_pointer AnimData116 ; $74
	anim_data_pointer AnimData117 ; $75
	anim_data_pointer AnimData118 ; $76
	anim_data_pointer AnimData119 ; $77
	anim_data_pointer AnimData120 ; $78
	anim_data_pointer AnimData121 ; $79
	anim_data_pointer AnimData122 ; $7a
	anim_data_pointer AnimData123 ; $7b
	anim_data_pointer AnimData124 ; $7c
	anim_data_pointer AnimData125 ; $7d
	anim_data_pointer AnimData126 ; $7e
	anim_data_pointer AnimData127 ; $7f
	anim_data_pointer AnimData128 ; $80
	anim_data_pointer AnimData129 ; $81
	anim_data_pointer AnimData130 ; $82
	anim_data_pointer AnimData131 ; $83
	anim_data_pointer AnimData132 ; $84
	anim_data_pointer AnimData133 ; $85
	anim_data_pointer AnimData134 ; $86
	anim_data_pointer AnimData135 ; $87
	anim_data_pointer AnimData136 ; $88
	anim_data_pointer AnimData137 ; $89
	anim_data_pointer AnimData138 ; $8a
	anim_data_pointer AnimData139 ; $8b
	anim_data_pointer AnimData140 ; $8c
	anim_data_pointer AnimData141 ; $8d
	anim_data_pointer AnimData142 ; $8e
	anim_data_pointer AnimData143 ; $8f
	anim_data_pointer AnimData144 ; $90
	anim_data_pointer AnimData145 ; $91
	anim_data_pointer AnimData146 ; $92
	anim_data_pointer AnimData147 ; $93
	anim_data_pointer AnimData148 ; $94
	anim_data_pointer AnimData149 ; $95
	anim_data_pointer AnimData150 ; $96
	anim_data_pointer AnimData151 ; $97
	anim_data_pointer AnimData152 ; $98
	anim_data_pointer AnimData153 ; $99
	anim_data_pointer AnimData154 ; $9a
	anim_data_pointer AnimData155 ; $9b
	anim_data_pointer AnimData156 ; $9c
	anim_data_pointer AnimData157 ; $9d
	anim_data_pointer AnimData158 ; $9e
	anim_data_pointer AnimData159 ; $9f
	anim_data_pointer AnimData160 ; $a0
	anim_data_pointer AnimData161 ; $a1
	anim_data_pointer AnimData162 ; $a2
	anim_data_pointer AnimData163 ; $a3
	anim_data_pointer AnimData164 ; $a4
	anim_data_pointer AnimData165 ; $a5
	anim_data_pointer AnimData166 ; $a6
	anim_data_pointer AnimData167 ; $a7
	anim_data_pointer AnimData168 ; $a8
	anim_data_pointer AnimData169 ; $a9
	anim_data_pointer AnimData170 ; $aa
	anim_data_pointer AnimData171 ; $ab
	anim_data_pointer AnimData172 ; $ac
	anim_data_pointer AnimData173 ; $ad
	anim_data_pointer AnimData174 ; $ae
	anim_data_pointer AnimData175 ; $af
	anim_data_pointer AnimData176 ; $b0
	anim_data_pointer AnimData177 ; $b1
	anim_data_pointer AnimData178 ; $b2
	anim_data_pointer AnimData179 ; $b3
	anim_data_pointer AnimData180 ; $b4
	anim_data_pointer AnimData181 ; $b5
	anim_data_pointer AnimData182 ; $b6
	anim_data_pointer AnimData183 ; $b7
	anim_data_pointer AnimData184 ; $b8
	anim_data_pointer AnimData185 ; $b9
	anim_data_pointer AnimData186 ; $ba
	anim_data_pointer AnimData187 ; $bb
	anim_data_pointer AnimData188 ; $bc
	anim_data_pointer AnimData189 ; $bd
	anim_data_pointer AnimData190 ; $be
	anim_data_pointer AnimData191 ; $bf
	anim_data_pointer AnimData192 ; $c0
	anim_data_pointer AnimData193 ; $c1
	anim_data_pointer AnimData194 ; $c2
	anim_data_pointer AnimData195 ; $c3
	anim_data_pointer AnimData196 ; $c4
	anim_data_pointer AnimData197 ; $c5
	anim_data_pointer AnimData198 ; $c6
	anim_data_pointer AnimData199 ; $c7
	anim_data_pointer AnimData200 ; $c8
	anim_data_pointer AnimData201 ; $c9
	anim_data_pointer AnimData202 ; $ca
	anim_data_pointer AnimData203 ; $cb
	anim_data_pointer AnimData204 ; $cc
	anim_data_pointer AnimData205 ; $cd
	anim_data_pointer AnimData206 ; $ce
	anim_data_pointer AnimData207 ; $cf
	anim_data_pointer AnimData208 ; $d0
	anim_data_pointer AnimData209 ; $d1
	anim_data_pointer AnimData210 ; $d2
	anim_data_pointer AnimData211 ; $d3
	anim_data_pointer AnimData212 ; $d4
	anim_data_pointer AnimData213 ; $d5
	anim_data_pointer AnimData214 ; $d6
	anim_data_pointer AnimData215 ; $d7
	anim_data_pointer AnimData216 ; $d8

; \1 = palette pointer
; \2 = number of palettes
; \3 = number of OBJ colors
palette_pointer: MACRO
	dwb \1, BANK(\1) - BANK(MapDataPointers_81697)
	db (\2 << 4) + \3
ENDM

MapDataPointers_81697: ; 81697 (20:5697)
	palette_pointer Palette0,   8, 1 ; $00
	palette_pointer Palette1,   8, 0 ; $01
	palette_pointer Palette2,   8, 0 ; $02
	palette_pointer Palette3,   8, 0 ; $03
	palette_pointer Palette4,   8, 0 ; $04
	palette_pointer Palette5,   8, 0 ; $05
	palette_pointer Palette6,   8, 0 ; $06
	palette_pointer Palette7,   8, 0 ; $07
	palette_pointer Palette8,   8, 0 ; $08
	palette_pointer Palette9,   8, 0 ; $09
	palette_pointer Palette10,  8, 0 ; $0a
	palette_pointer Palette11,  8, 0 ; $0b
	palette_pointer Palette12,  8, 0 ; $0c
	palette_pointer Palette13,  8, 0 ; $0d
	palette_pointer Palette14,  8, 0 ; $0e
	palette_pointer Palette15,  8, 0 ; $0f
	palette_pointer Palette16,  8, 0 ; $10
	palette_pointer Palette17,  8, 0 ; $11
	palette_pointer Palette18,  8, 0 ; $12
	palette_pointer Palette19,  8, 0 ; $13
	palette_pointer Palette20,  8, 0 ; $14
	palette_pointer Palette21,  8, 0 ; $15
	palette_pointer Palette22,  8, 0 ; $16
	palette_pointer Palette23,  8, 0 ; $17
	palette_pointer Palette24,  8, 0 ; $18
	palette_pointer Palette25,  8, 0 ; $19
	palette_pointer Palette26,  8, 0 ; $1a
	palette_pointer Palette27,  8, 0 ; $1b
	palette_pointer Palette28,  8, 0 ; $1c
	palette_pointer Palette29,  8, 2 ; $1d
	palette_pointer Palette30,  8, 2 ; $1e
	palette_pointer Palette31,  1, 1 ; $1f
	palette_pointer Palette32,  1, 1 ; $20
	palette_pointer Palette33,  1, 1 ; $21
	palette_pointer Palette34,  1, 1 ; $22
	palette_pointer Palette35,  1, 1 ; $23
	palette_pointer Palette36,  1, 1 ; $24
	palette_pointer Palette37,  1, 1 ; $25
	palette_pointer Palette38,  1, 1 ; $26
	palette_pointer Palette39,  1, 1 ; $27
	palette_pointer Palette40,  1, 1 ; $28
	palette_pointer Palette41,  1, 1 ; $29
	palette_pointer Palette42,  1, 1 ; $2a
	palette_pointer Palette43,  1, 1 ; $2b
	palette_pointer Palette44,  1, 1 ; $2c
	palette_pointer Palette45,  1, 1 ; $2d
	palette_pointer Palette46,  1, 1 ; $2e
	palette_pointer Palette47,  1, 1 ; $2f
	palette_pointer Palette48,  1, 1 ; $30
	palette_pointer Palette49,  1, 1 ; $31
	palette_pointer Palette50,  1, 1 ; $32
	palette_pointer Palette51,  1, 1 ; $33
	palette_pointer Palette52,  1, 1 ; $34
	palette_pointer Palette53,  1, 1 ; $35
	palette_pointer Palette54,  1, 1 ; $36
	palette_pointer Palette55,  1, 1 ; $37
	palette_pointer Palette56,  1, 1 ; $38
	palette_pointer Palette57,  1, 1 ; $39
	palette_pointer Palette58,  1, 1 ; $3a
	palette_pointer Palette59,  1, 1 ; $3b
	palette_pointer Palette60,  1, 1 ; $3c
	palette_pointer Palette61,  1, 1 ; $3d
	palette_pointer Palette62,  1, 1 ; $3e
	palette_pointer Palette63,  1, 1 ; $3f
	palette_pointer Palette64,  1, 1 ; $40
	palette_pointer Palette65,  1, 1 ; $41
	palette_pointer Palette66,  1, 1 ; $42
	palette_pointer Palette67,  1, 1 ; $43
	palette_pointer Palette68,  1, 1 ; $44
	palette_pointer Palette69,  1, 1 ; $45
	palette_pointer Palette70,  1, 1 ; $46
	palette_pointer Palette71,  1, 1 ; $47
	palette_pointer Palette72,  1, 1 ; $48
	palette_pointer Palette73,  1, 1 ; $49
	palette_pointer Palette74,  1, 1 ; $4a
	palette_pointer Palette75,  1, 1 ; $4b
	palette_pointer Palette76,  1, 1 ; $4c
	palette_pointer Palette77,  1, 1 ; $4d
	palette_pointer Palette78,  1, 1 ; $4e
	palette_pointer Palette79,  1, 1 ; $4f
	palette_pointer Palette80,  1, 1 ; $50
	palette_pointer Palette81,  1, 1 ; $51
	palette_pointer Palette82,  1, 1 ; $52
	palette_pointer Palette83,  1, 1 ; $53
	palette_pointer Palette84,  1, 1 ; $54
	palette_pointer Palette85,  1, 1 ; $55
	palette_pointer Palette86,  1, 1 ; $56
	palette_pointer Palette87,  1, 1 ; $57
	palette_pointer Palette88,  1, 1 ; $58
	palette_pointer Palette89,  1, 1 ; $59
	palette_pointer Palette90,  1, 1 ; $a5
	palette_pointer Palette91,  1, 1 ; $5b
	palette_pointer Palette92,  1, 1 ; $5c
	palette_pointer Palette93,  1, 1 ; $5d
	palette_pointer Palette94,  8, 0 ; $5e
	palette_pointer Palette95,  8, 0 ; $5f
	palette_pointer Palette96,  8, 0 ; $60
	palette_pointer Palette97,  8, 0 ; $61
	palette_pointer Palette98,  8, 0 ; $62
	palette_pointer Palette99,  8, 0 ; $63
	palette_pointer Palette100, 8, 0 ; $64
	palette_pointer Palette101, 7, 0 ; $65
	palette_pointer Palette102, 7, 0 ; $66
	palette_pointer Palette103, 7, 0 ; $67
	palette_pointer Palette104, 7, 0 ; $68
	palette_pointer Palette105, 7, 0 ; $69
	palette_pointer Palette106, 7, 0 ; $6a
	palette_pointer Palette107, 7, 0 ; $6b
	palette_pointer Palette108, 0, 1 ; $6c
	palette_pointer Palette109, 0, 1 ; $6d
	palette_pointer Palette110, 0, 0 ; $6e
	palette_pointer Palette111, 8, 1 ; $6f
	palette_pointer Palette112, 8, 1 ; $70
	palette_pointer Palette113, 8, 1 ; $71
	palette_pointer Palette114, 4, 2 ; $72
	palette_pointer Palette115, 4, 2 ; $73
	palette_pointer Palette116, 4, 2 ; $74
	palette_pointer Palette117, 1, 0 ; $75
	palette_pointer Palette118, 6, 0 ; $76
	palette_pointer Palette119, 1, 0 ; $77
	palette_pointer Palette120, 1, 0 ; $78
	palette_pointer Palette121, 1, 0 ; $79
	palette_pointer Palette122, 1, 0 ; $7a
	palette_pointer Palette123, 1, 0 ; $7b
	palette_pointer Palette124, 1, 0 ; $7c
	palette_pointer Palette125, 1, 0 ; $7d
	palette_pointer Palette126, 1, 0 ; $7e
	palette_pointer Palette127, 1, 0 ; $7f
	palette_pointer Palette128, 1, 0 ; $80
	palette_pointer Palette129, 1, 0 ; $81
	palette_pointer Palette130, 1, 0 ; $82
	palette_pointer Palette131, 1, 0 ; $83
	palette_pointer Palette132, 1, 0 ; $84
	palette_pointer Palette133, 1, 0 ; $85
	palette_pointer Palette134, 1, 0 ; $86
	palette_pointer Palette135, 1, 0 ; $87
	palette_pointer Palette136, 1, 0 ; $88
	palette_pointer Palette137, 1, 0 ; $89
	palette_pointer Palette138, 1, 0 ; $8a
	palette_pointer Palette139, 1, 0 ; $8b
	palette_pointer Palette140, 1, 0 ; $8c
	palette_pointer Palette141, 1, 0 ; $8d
	palette_pointer Palette142, 1, 0 ; $8e
	palette_pointer Palette143, 1, 0 ; $8f
	palette_pointer Palette144, 1, 0 ; $90
	palette_pointer Palette145, 1, 0 ; $91
	palette_pointer Palette146, 1, 0 ; $92
	palette_pointer Palette147, 1, 0 ; $93
	palette_pointer Palette148, 1, 0 ; $94
	palette_pointer Palette149, 1, 0 ; $95
	palette_pointer Palette150, 1, 0 ; $96
	palette_pointer Palette151, 1, 0 ; $97
	palette_pointer Palette152, 1, 0 ; $98
	palette_pointer Palette153, 1, 0 ; $99
	palette_pointer Palette154, 1, 0 ; $9a
	palette_pointer Palette155, 1, 0 ; $9b
	palette_pointer Palette156, 1, 0 ; $9c
	palette_pointer Palette157, 1, 0 ; $9d
	palette_pointer Palette158, 1, 0 ; $9e
	palette_pointer Palette159, 1, 0 ; $9f
	palette_pointer Palette160, 1, 0 ; $a0

	INCROM $8191b, $83c4c

AnimData1:: ; 83c4c (20:7c4c)
	frame_table AnimFrameTable0
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0

Palette110:: ; 83c5b (20:7c5b)
	db $00, $00

	INCROM $83c5d, $84000
