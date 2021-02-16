Func_80000: ; 80000 (20:4000)
	call ClearSRAMBGMaps
	xor a
	ld [wTextBoxFrameType], a
	call Func_8003d
	farcall Func_c37a
	farcall Func_c9c7
	call Func_801a1
	farcall Func_c3ff
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	ret nz
	farcall OverworldMap_PrintMapName
	farcall OverworldMap_InitVolcanoSprite
	ret
; 0x80028

Func_80028: ; 80028 (20:4028)
	call ClearSRAMBGMaps
	ld bc, $0000
	call Func_80077
	farcall Func_c9c7
	call Func_801a1
	farcall Func_c3ee
	ret
; 0x8003d

Func_8003d: ; 8003d (20:403d)
	farcall LoadMapHeader
	farcall SetSGB2AndSGB3MapPalette
	ld bc, $0
	call Func_80077
	ld a, $80
	ld [wd4ca], a
	xor a
	ld [wd4cb], a
	call LoadTilesetGfx
	xor a
	ld [wd4ca], a
	ld a, [wd291]
	ld [wd4cb], a
	ld a, [wd28f]
	call Func_803c9
	ld a, [wd291]
	ld [wd4cb], a
	ld a, [wd290]
	or a
	jr z, .asm_80076
	call Func_803c9
.asm_80076
	ret
; 0x80077

Func_80077: ; 80077 (20:4077)
	ld a, TRUE
	ld [wWriteBGMapToSRAM], a
	jr Func_80082

Func_8007e: ; 8007e (20:407e)
	xor a
	ld [wWriteBGMapToSRAM], a
;	fallthrough

Func_80082: ; 80082 (20:4082)
	push hl
	push bc
	push de
	call BCCoordToBGMap0Address
	ld hl, wVRAMPointer
	ld [hl], e
	inc hl
	ld [hl], d

; get pointer and bank for BG Map
	call Func_803b9
	ld a, [wTempPointerBank]
	ld [wd23d], a

; store header data
	ld de, wDecompressionBuffer
	ld bc, $0006 ; header + 1st instruction
	call CopyBankedDataToDE
	ld l, e
	ld h, d
	ld a, [hli]
	ld [wBGMapWidth], a
	ld a, [hli]
	ld [wBGMapHeight], a
	ld a, [hli]
	ld [wd23a], a
	ld a, [hli]
	ld [wd23a + 1], a
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
	ld b, HIGH(wc000)
	call InitDataDecompression
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
; if wd23c != 0, then use double wBGMapWidth
	push hl
	ld hl, wd28e
	ld a, [wBGMapWidth]
	ld [hl], a
	ld a, [wd23c]
	or a
	jr z, .asm_800f0
	sla [hl]
.asm_800f0

	ld c, $40
	ld hl, wDecompressionBuffer
	xor a
.loop_clear
	ld [hli], a
	dec c
	jr nz, .loop_clear

; loop each row, up to the number of tiles in height
	ld a, [wBGMapHeight]
	ld c, a
.loop
	push bc
	push de
	ld b, $00
	ld a, [wd28e]
	ld c, a
	ld de, wDecompressionBuffer
	call DecompressDataFromBank

	ld a, [wBGMapWidth]
	ld b, a
	pop de
	push de
	ld hl, wDecompressionBuffer
	call CopyBGDataToVRAMOrSRAM
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .next_row

	; cgb only
	call BankswitchVRAM1
	ld a, [wBGMapWidth]
	ld c, a
	ld b, $00
	ld hl, wDecompressionBuffer
	add hl, bc
	pop de
	push de
	ld a, [wBGMapWidth]
	ld b, a
	call Func_80148
	call CopyBGDataToVRAMOrSRAM
	call BankswitchVRAM0

.next_row
	pop de
	ld hl, BG_MAP_WIDTH
	add hl, de
	ld e, l
	ld d, h
	pop bc
	dec c
	jr nz, .loop

	pop hl
	ret

Func_80148: ; 80148 (20:4148)
	ld a, [wd291]
	or a
	ret z
	ld a, [wd23c]
	or a
	jr z, .asm_80162

; add wd291 to b bytes in hl
	push hl
	push bc
.loop_1
	push bc
	ld a, [wd291]
	add [hl]
	ld [hli], a
	pop bc
	dec b
	jr nz, .loop_1
	pop bc
	pop hl
	ret

; store wd291 to b bytes in hl
.asm_80162
	push hl
	push bc
	ld a, [wd291]
.loop_2
	ld [hli], a
	dec b
	jr nz, .loop_2
	pop bc
	pop hl
	ret

; copies BG Map data pointed by hl
; to either VRAM or SRAM, depending on wWriteBGMapToSRAM
; de is the target address in VRAM,
; if SRAM is the target address to copy,
; copies data to s0BGMap or s1BGMap
; for VRAM0 or VRAM1 respectively
CopyBGDataToVRAMOrSRAM: ; 8016e (20:416e)
	ld a, [wWriteBGMapToSRAM]
	or a
	jp z, SafeCopyDataHLtoDE

; copies b bytes from hl to SRAM1
	push hl
	push bc
	push de
	ldh a, [hBankSRAM]
	push af
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	push hl
	ld hl, s0BGMap - v0BGMap0
	ldh a, [hBankVRAM]
	or a
	jr z, .got_pointer
	ld hl, s1BGMap - v1BGMap0
.got_pointer
	add hl, de
	ld e, l
	ld d, h
	pop hl
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
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

; clears s0BGMap and s1BGMap
ClearSRAMBGMaps: ; 801f1 (20:41f1)
	push hl
	push bc
	ldh a, [hBankSRAM]
	push af
	ld a, BANK(s0BGMap) ; SRAM 1
	call BankswitchSRAM
	ld hl, s0BGMap
	ld bc, $800 ; s0BGMap + s1BGMap
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
	ld [wTotalNumTiles], a
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
	call GetTileOffsetPointerAndSwitchVRAM_Tiles0ToTiles2

; loads graphics data pointed by wTempPointer in wTempPointerBank
; to wVRAMPointer
LoadGfxDataFromTempPointer:
	push hl
	push bc
	push de
	ld a, [wTotalNumTiles]
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
	and $0f
	add HIGH(v0Tiles0) ; $80
	ld [wVRAMPointer + 1], a

; if bottom bit in wd4cb is not set = VRAM0
; if bottom bit in wd4cb is set     = VRAM1
	ld a, [wd4cb]
	and $1
	call BankswitchVRAM
	ret

; converts wVRAMTileOffset to address in VRAM
; and stores it in wVRAMPointer
; switches VRAM according to wd4cb
; then changes wVRAMPointer such that
; addresses to Tiles0 is changed to Tiles2
GetTileOffsetPointerAndSwitchVRAM_Tiles0ToTiles2: ; 802bb (20:42bb)
	ld a, [wVRAMTileOffset]
	push af
	xor $80 ; toggle top bit
	ld [wVRAMTileOffset], a
	call GetTileOffsetPointerAndSwitchVRAM
	ld a, [wVRAMPointer + 1]
	add $8
	ld [wVRAMPointer + 1], a
	pop af
	ld [wVRAMTileOffset], a
	ret
; 0x802d4

; loads tileset gfx to VRAM corresponding to wCurTileset
LoadTilesetGfx: ; 802d4 (20:42d4)
	push hl
	ld l, $02
	ld a, [wCurTileset]
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
	call .LoadTileGfx
	call BankswitchVRAM0
	pop hl
	ret
; 0x802e8

; loads gfx data from wTempPointerBank:wTempPointer
.LoadTileGfx ; 802e8 (20:42e8)
	push hl
	push bc
	push de
	ld hl, wTempPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wTempPointerBank]
	call GetFarByte ; get number of tiles (low byte)
	ld [wTotalNumTiles], a
	inc hl
	ld a, [wTempPointerBank]
	call GetFarByte ; get number of tiles (high byte)
	ld [wTotalNumTiles + 1], a
	inc hl
	ld a, l
	ld [wTempPointer], a
	ld a, h
	ld [wTempPointer + 1], a

; used to sequentially copy gfx data in the order
; v0Tiles1 -> v0Tiles2 -> v1Tiles1 -> v1Tiles2

	lb bc, $0, LOW(v0Tiles2 / TILE_SIZE) ; $00
	call .CopyGfxData
	jr z, .done
	lb bc, $0, LOW(v0Tiles1 / TILE_SIZE) ; $80
	call .CopyGfxData
	jr z, .done
	; VRAM1 only used in CGB console
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .done
	lb bc, $1, LOW(v1Tiles2 / TILE_SIZE) ; $00
	call .CopyGfxData
	jr z, .done
	lb bc, $1, LOW(v1Tiles1 / TILE_SIZE) ; $80
	call .CopyGfxData

.done
	pop de
	pop bc
	pop hl
	ret
; 0x80336

; copies gfx data from wTempPointer to VRAM
; c must match with wVRAMTileOffset
; if c = $00, copies it to Tiles2
; if c = $80, copies it to Tiles1
; b must match with VRAM bank in wd4cb
; prepares next call to this routine if data wasn't fully copied
; so that it copies to the right VRAM section
.CopyGfxData ; 80336 (20:4336)
	push hl
	push bc
	push de
	ld a, [wd4cb]
	cp b
	jr nz, .skip
	ld a, [wVRAMTileOffset]
	ld d, a
	xor c
	bit 7, a
	jr nz, .skip

; (wd4cb == b) and
; bit 7 in c is same as bit 7 in wVRAMTileOffset
	ld a, c
	add $80
	sub d
	ld d, a ; total number of tiles
	ld a, [wTotalNumTiles + 1]
	or a
	jr nz, .asm_8035a
	; if d > wTotalNumTiles,
	; overwrite it with wTotalNumTiles
	ld a, [wTotalNumTiles]
	cp d
	jr nc, .asm_8035a
	ld d, a
.asm_8035a
	ld a, [wTotalNumTiles]
	sub d
	ld [wTotalNumTiles], a
	ld a, [wTotalNumTiles + 1]
	sbc $00
	ld [wTotalNumTiles + 1], a
	call GetTileOffsetPointerAndSwitchVRAM_Tiles0ToTiles2

	ld b, d ; number of tiles
	ld c, TILE_SIZE
	ld hl, wVRAMPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wTempPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push bc
	push hl
	ldh a, [hBankVRAM]
	push af
	ld a, [wd4cb]
	and $01
	call BankswitchVRAM
	call CopyGfxDataFromTempBank
	pop af
	call BankswitchVRAM
	pop de
	pop bc

	; add number of tiles * TILE_SIZE
	; to wVRAMPointer and store it in wTempPointer
	ld l, b
	ld h, $00
	add hl, hl ; *2
	add hl, hl ; *4
	add hl, hl ; *8
	add hl, hl ; *16 (TILE_SIZE)
	add hl, de
	ld a, l
	ld [wTempPointer], a
	ld a, h
	ld [wTempPointer + 1], a

	ld hl, wVRAMTileOffset
	ld a, [hl]
	add $80
	push af
	and $80 ; start of next group of tiles
	ld [hli], a
	pop af
	; if it overflows
	; (which means a tile group after Tiles2)
	; then set wd4cb for VRAM1
	ld a, [hl] ; wd4cb
	adc $00
	ld [hl], a

.skip
	ld hl, wTotalNumTiles
	ld a, [hli]
	or [hl] ; wTotalNumTiles + 1
	pop de
	pop bc
	pop hl
	ret
; 0x803b9

; gets pointer to BG map with ID from wCurTilemap
Func_803b9: ; 803b9 (20:43b9)
	ld l, $00
	ld a, [wCurTilemap]
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
	ld a, [hl]
	ld [wCurTileset], a
	ret
; 0x803c9

Func_803c9: ; 803c9 (20:43c9)
	push hl
	push bc
	push de
	call CopyPaletteDataToBuffer
	ld hl, wLoadedPalData
	ld a, [hli]
	or a
	jr z, .asm_803dc
	ld a, [hli]
	push hl
	call SetBGP
	pop hl
.asm_803dc
	ld a, [hli]
	or a
	jr z, .asm_803e8
	ld c, a
	ld a, [wd4cb]
	ld b, a
	call LoadPaletteDataFromHL
.asm_803e8
	pop de
	pop bc
	pop hl
	ret
; 0x803ec

; copies from palette data in hl c*8 bytes to palette index b
; in WRAM, starting from wBackgroundPalettesCGB
; b = palette index
; c = palette size
; hl = palette data to copy
LoadPaletteDataFromHL: ; 803ec (20:43ec)
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
	debug_nop

.success_return
	pop de
	pop bc
	pop hl
	ret
; 0x80418

; loads palette index a
LoadPaletteData: ; 80418 (20:4418)
	push hl
	push bc
	push de
	call CopyPaletteDataToBuffer

	ld hl, wLoadedPalData
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
	call LoadPaletteDataFromHL

.done
	pop de
	pop bc
	pop hl
	ret
; 0x80456

; copies palette data of index in a to wLoadedPalData
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

	ld de, wLoadedPalData
	call CopyBankedDataToDE
	pop de
	pop bc
	pop hl
	ret
; 0x8047b

	INCROM $8047b, $80480

; for the current map, process the animation
; data of its corresponding OW tiles
DoMapOWFrame: ; 80480 (20:4480)
	push hl
	push bc
	ld a, [wCurMap]
	add a
	add a ; *4
	ld c, a
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld a, c
	add 2
	ld c, a
.not_cgb
	ld b, $0
	ld hl, MapOWFramesetPointers
	add hl, bc
	; got pointer for current map's frameset data
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessOWFrameset
	pop bc
	pop hl
	ret
; 0x804a2

; processes the OW frameset pointed by hl
ProcessOWFrameset: ; 804a2 (20:44a2)
	push hl
	push bc
	ld a, l
	ld [wCurMapOWFrameset], a
	ld a, h
	ld [wCurMapOWFrameset + 1], a
	xor a
	ld [wumLoadedFramesetSubgroups], a
	call ClearOWFramesetSubgroups
	ld c, 0
.loop_subgroups
	call LoadOWFramesetSubgroup
	call GetOWFramesetSubgroupData
	ld a, [wCurOWFrameDataOffset]
	cp -1
	jr z, .next_subgroup
	ld a, [wumLoadedFramesetSubgroups]
	inc a
	ld [wumLoadedFramesetSubgroups], a
	call LoadOWFrameTiles
	call StoreOWFramesetSubgroup
.next_subgroup
	inc c
	ld a, c
	cp NUM_OW_FRAMESET_SUBGROUPS
	jr c, .loop_subgroups
	pop bc
	pop hl
	ret
; 0x804d8

; for each of the loaded frameset subgroups
; load their tiles and advance their durations
DoLoadedFramesetSubgroupsFrame: ; 804d8 (20:44d8)
	ld a, [wumLoadedFramesetSubgroups]
	or a
	ret z
	ld c, 0
.loop_subgroups
	call LoadOWFramesetSubgroup
	cp -1
	jr z, .next_subgroup
	call LoadOWFrameTiles
	call StoreOWFramesetSubgroup
.next_subgroup
	inc c
	ld a, c
	cp NUM_OW_FRAMESET_SUBGROUPS
	jr c, .loop_subgroups
	ret
; 0x804f3

; from subgroup in register c, get
; from OW frameset in hl its corresponding
; data offset and duration
GetOWFramesetSubgroupData: ; 804f3 (20:44f3)
	push hl
	push bc
	push hl
	ld b, $0
	add hl, bc
	ld c, [hl]
	pop hl
	add hl, bc
	ld a, [hl] ; beginning of OW_FRAME
	cp -1
	jr z, .end_of_list ; skip if it's end of list
	ld a, c ; store its addr offset
	ld [wCurOWFrameDataOffset], a
	xor a
	ld [wCurOWFrameDuration], a
.end_of_list
	pop bc
	pop hl
	ret
; 0x8050c

; if wCurOWFrameDuration == 0, processes next frame for OW map
; by loading the tiles corresponding to current frame
; if wCurOWFrameDuration != 0, then simply decrements it and returns
LoadOWFrameTiles: ; 8050c (20:450c)
	ld a, [wCurOWFrameDuration]
	or a
	jr z, .next_frame
	dec a
	ld [wCurOWFrameDuration], a
	ret

.next_frame
	push hl
	push de
	push bc
	; add wCurOWFrameDataOffset to pointer in wCurMapOWFrameset
	ld a, [wCurOWFrameDataOffset]
	ld c, a
	ld a, [wCurMapOWFrameset]
	add c
	ld l, a
	ld a, [wCurMapOWFrameset + 1]
	adc 0
	ld h, a

	ld a, [hl]
	ld [wCurOWFrameDuration], a
.loop_ow_frames
	call .LoadTile
	ld de, OW_FRAME_STRUCT_SIZE
	add hl, de ; next frame data
	ld a, c
	add e
	ld c, a
	; OW frames with 0 duration are processed
	; at the same time as the previous frame data
	ld a, [hl]
	or a
	jr z, .loop_ow_frames

	cp -1
	ld a, c
	ld [wCurOWFrameDataOffset], a
	jr nz, .done

; there's no more frames to process for this map
; reset the frame data offset
	pop bc
	push bc
	ld a, [wCurOWFrameDuration]
	push af
	ld a, [wCurMapOWFrameset]
	ld l, a
	ld a, [wCurMapOWFrameset + 1]
	ld h, a
	call GetOWFramesetSubgroupData
	pop af
	ld [wCurOWFrameDuration], a

.done
	pop bc
	pop de
	pop hl
	ret

; load a single tile specified
; by the OW frame data pointed by hl
.LoadTile
	push hl
	push bc
	push de
	ldh a, [hBankVRAM]
	push af
	inc hl
	ld a, [hli] ; tile number
	xor $80
	ld e, a
	ld a, [hli] ; VRAM bank

; get tile offset of register e
; and load its address in de
	push hl
	call BankswitchVRAM
	ld h, $00
	ld l, e
	add hl, hl ; *2
	add hl, hl ; *4
	add hl, hl ; *8
	add hl, hl ; *16
	ld de, v0Tiles1 ; or v1Tiles1
	add hl, de
	ld e, l
	ld d, h
	pop hl

	ld a, [hli] ; bank of tileset
	add BANK(MapOWFramesetPointers)
	ld [wTempPointerBank], a
	ld a, [hli] ; tileset addr lo byte
	ld c, a
	ld a, [hli] ; tileset addr hi byte
	ld b, a
	ld a, [hli] ; tile number lo byte
	ld h, [hl]  ; tile number hi byte
	ld l, a
	add hl, hl ; *2
	add hl, hl ; *4
	add hl, hl ; *8
	add hl, hl ; *16
	add hl, bc
	; copy tile from the tileset to VRAM addr
	lb bc, 1, TILE_SIZE
	call CopyGfxDataFromTempBank
	pop af
	call BankswitchVRAM
	pop de
	pop bc
	pop hl
	ret
; 0x8059a

; fills wOWFramesetSubgroups with $ff
ClearOWFramesetSubgroups: ; 8059a (20:459a)
	push hl
	push bc
	ld hl, wOWFramesetSubgroups
	ld c, NUM_OW_FRAMESET_SUBGROUPS * 2
	ld a, $ff
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	pop bc
	pop hl
	ret
; 0x805aa

; copies wOWFramesetSubgroups + 2*c
; to wCurOWFrameDataOffset and wCurOWFrameDuration
; also returns its current duration
LoadOWFramesetSubgroup: ; 805aa (20:45aa)
	push hl
	push bc
	ld hl, wOWFramesetSubgroups
	sla c
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld [wCurOWFrameDataOffset], a
	push af
	ld a, [hl]
	ld [wCurOWFrameDuration], a
	pop af
	pop bc
	pop hl
	ret
; 0x805c1

; copies wCurOWFrameDataOffset and wCurOWFrameDuration
; to wOWFramesetSubgroups + 2*c
StoreOWFramesetSubgroup: ; 805c1 (20:45c1)
	push hl
	push bc
	ld hl, wOWFramesetSubgroups
	sla c
	ld b, $00
	add hl, bc
	ld a, [wCurOWFrameDataOffset]
	ld [hli], a
	ld a, [wCurOWFrameDuration]
	ld [hl], a
	pop bc
	pop hl
	ret
; 0x805d6

INCLUDE "data/map_ow_framesets.asm"

; clears wd323
Func_80b7a: ; 80b7a (20:4b7a)
	push hl
	push bc
	ld c, $b
	ld hl, wd323
	xor a
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	pop bc
	pop hl
	ret
; 0x80b89

Func_80b89: ; 80b89 (20:4b89)
	push hl
	push bc
	push af
	ld c, a
	ld a, TRUE
	ld [wWriteBGMapToSRAM], a
	ld b, $00
	ld hl, wd323
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
	ld [wWriteBGMapToSRAM], a
	pop af
;	fallthrough

Func_80baa: ; 80baa (20:4baa)
	push hl
	push bc
	push de
	ld c, a
	ld a, [wCurTilemap]
	push af
	ld a, [wd23d]
	push af
	ld a, [wBGMapWidth]
	push af
	ld a, [wBGMapHeight]
	push af
	ld a, [wd23a]
	push af
	ld a, [wd23a + 1]
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
	ld hl, .unknown_80c21
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
	ld [wCurTilemap], a
	push bc
	farcall Func_80082 ; unnecessary farcall
	pop bc
	srl b
	ld a, c
	rrca
	and $0f
	swap a ; * $10
	add b
	ld c, a
	ld b, $0
	ld hl, wBoosterViableCardList
	add hl, bc
	farcall Func_c38f
	pop af
	ld [wd23a + 1], a
	pop af
	ld [wd23a], a
	pop af
	ld [wBGMapHeight], a
	pop af
	ld [wBGMapWidth], a
	pop af
	ld [wd23d], a
	pop af
	ld [wCurTilemap], a
	pop de
	pop bc
	pop hl
	ret

.unknown_80c21
	dw .data_1
	dw .data_2
	dw .data_3
	dw .data_4
	dw .data_5
	dw .data_6
	dw .data_7
	dw .data_8
	dw .data_9
	dw .data_10
	dw .data_11

.data_1
	db $16, $00, TILEMAP_UNUSED_5, TILEMAP_UNUSED_6
.data_2
	db $0e, $00, TILEMAP_UNUSED_7, TILEMAP_UNUSED_8
.data_3
	db $06, $02, TILEMAP_UNUSED_3, TILEMAP_UNUSED_4
.data_4
	db $0a, $02, TILEMAP_UNUSED_3, TILEMAP_UNUSED_4
.data_5
	db $0e, $02, TILEMAP_UNUSED_3, TILEMAP_UNUSED_4
.data_6
	db $12, $02, TILEMAP_UNUSED_3, TILEMAP_UNUSED_4
.data_7
	db $0e, $0a, TILEMAP_UNUSED_3, TILEMAP_UNUSED_4
.data_8
	db $12, $0a, TILEMAP_UNUSED_3, TILEMAP_UNUSED_4
.data_9
	db $0e, $12, TILEMAP_UNUSED_3, TILEMAP_UNUSED_4
.data_10
	db $12, $12, TILEMAP_UNUSED_3, TILEMAP_UNUSED_4
.data_11
	db $0a, $00, TILEMAP_UNUSED_1, TILEMAP_UNUSED_2

	INCROM $80c63, $80e5a

SpriteNullAnimationPointer: ; 80e5a (20:4e5a)
	dw SpriteNullAnimationFrame

SpriteNullAnimationFrame:
	db 0

; might be closer to "screen specific data" than map data
MapDataPointers: ; 80e5d (20:4e5d)
	dw Tilemaps
	dw Tilesets
	dw MapDataPointers_8116b
	dw SpriteAnimationPointers
	dw MapDataPointers_81697

; \1 = pointer
; \2 = tileset
tilemap: MACRO
	dwb \1, BANK(\1) - BANK(Tilemaps)
	db \2
ENDM

Tilemaps: ; 80e67 (20:4e67)
	tilemap OverworldMapTilemap,             TILESET_OVERWORLD_MAP         ; TILEMAP_OVERWORLD_MAP
	tilemap OverworldMapCGBTilemap,          TILESET_OVERWORLD_MAP         ; TILEMAP_OVERWORLD_MAP_CGB
	tilemap MasonLaboratoryTilemap,          TILESET_MASON_LABORATORY      ; TILEMAP_MASON_LABORATORY
	tilemap MasonLaboratoryCGBTilemap,       TILESET_MASON_LABORATORY      ; TILEMAP_MASON_LABORATORY_CGB
	tilemap Unused1Tilemap,                  TILESET_MASON_LABORATORY      ; TILEMAP_UNUSED_1
	tilemap Unused2Tilemap,                  TILESET_MASON_LABORATORY      ; TILEMAP_UNUSED_2
	tilemap DeckMachineRoomTilemap,          TILESET_MASON_LABORATORY      ; TILEMAP_DECK_MACHINE_ROOM
	tilemap DeckMachineRoomCGBTilemap,       TILESET_MASON_LABORATORY      ; TILEMAP_DECK_MACHINE_ROOM_CGB
	tilemap Unused3Tilemap,                  TILESET_MASON_LABORATORY      ; TILEMAP_UNUSED_3
	tilemap Unused4Tilemap,                  TILESET_MASON_LABORATORY      ; TILEMAP_UNUSED_4
	tilemap IshiharaTilemap,                 TILESET_ISHIHARA              ; TILEMAP_ISHIHARA
	tilemap IshiharaCGBTilemap,              TILESET_ISHIHARA              ; TILEMAP_ISHIHARA_CGB
	tilemap FightingClubEntranceTilemap,     TILESET_CLUB_ENTRANCE         ; TILEMAP_FIGHTING_CLUB_ENTRANCE
	tilemap FightingClubEntranceCGBTilemap,  TILESET_CLUB_ENTRANCE         ; TILEMAP_FIGHTING_CLUB_ENTRANCE_CGB
	tilemap RockClubEntranceTilemap,         TILESET_CLUB_ENTRANCE         ; TILEMAP_ROCK_CLUB_ENTRANCE
	tilemap RockClubEntranceCGBTilemap,      TILESET_CLUB_ENTRANCE         ; TILEMAP_ROCK_CLUB_ENTRANCE_CGB
	tilemap WaterClubEntranceTilemap,        TILESET_CLUB_ENTRANCE         ; TILEMAP_WATER_CLUB_ENTRANCE
	tilemap WaterClubEntranceCGBTilemap,     TILESET_CLUB_ENTRANCE         ; TILEMAP_WATER_CLUB_ENTRANCE_CGB
	tilemap LightningClubEntranceTilemap,    TILESET_CLUB_ENTRANCE         ; TILEMAP_LIGHTNING_CLUB_ENTRANCE
	tilemap LightningClubEntranceCGBTilemap, TILESET_CLUB_ENTRANCE         ; TILEMAP_LIGHTNING_CLUB_ENTRANCE_CGB
	tilemap GrassClubEntranceTilemap,        TILESET_CLUB_ENTRANCE         ; TILEMAP_GRASS_CLUB_ENTRANCE
	tilemap GrassClubEntranceCGBTilemap,     TILESET_CLUB_ENTRANCE         ; TILEMAP_GRASS_CLUB_ENTRANCE_CGB
	tilemap PsychicClubEntranceTilemap,      TILESET_CLUB_ENTRANCE         ; TILEMAP_PSYCHIC_CLUB_ENTRANCE
	tilemap PsychicClubEntranceCGBTilemap,   TILESET_CLUB_ENTRANCE         ; TILEMAP_PSYCHIC_CLUB_ENTRANCE_CGB
	tilemap ScienceClubEntranceTilemap,      TILESET_CLUB_ENTRANCE         ; TILEMAP_SCIENCE_CLUB_ENTRANCE
	tilemap ScienceClubEntranceCGBTilemap,   TILESET_CLUB_ENTRANCE         ; TILEMAP_SCIENCE_CLUB_ENTRANCE_CGB
	tilemap FireClubEntranceTilemap,         TILESET_CLUB_ENTRANCE         ; TILEMAP_FIRE_CLUB_ENTRANCE
	tilemap FireClubEntranceCGBTilemap,      TILESET_CLUB_ENTRANCE         ; TILEMAP_FIRE_CLUB_ENTRANCE_CGB
	tilemap ChallengeHallEntranceTilemap,    TILESET_CLUB_ENTRANCE         ; TILEMAP_CHALLENGE_HALL_ENTRANCE
	tilemap ChallengeHallEntranceCGBTilemap, TILESET_CLUB_ENTRANCE         ; TILEMAP_CHALLENGE_HALL_ENTRANCE_CGB
	tilemap ClubLobbyTilemap,                TILESET_CLUB_LOBBY            ; TILEMAP_CLUB_LOBBY
	tilemap ClubLobbyCGBTilemap,             TILESET_CLUB_LOBBY            ; TILEMAP_CLUB_LOBBY_CGB
	tilemap FightingClubTilemap,             TILESET_FIGHTING_CLUB         ; TILEMAP_FIGHTING_CLUB
	tilemap FightingClubCGBTilemap,          TILESET_FIGHTING_CLUB         ; TILEMAP_FIGHTING_CLUB_CGB
	tilemap RockClubTilemap,                 TILESET_ROCK_CLUB             ; TILEMAP_ROCK_CLUB
	tilemap RockClubCGBTilemap,              TILESET_ROCK_CLUB             ; TILEMAP_ROCK_CLUB_CGB
	tilemap WaterClubTilemap,                TILESET_WATER_CLUB            ; TILEMAP_WATER_CLUB
	tilemap WaterClubCGBTilemap,             TILESET_WATER_CLUB            ; TILEMAP_WATER_CLUB_CGB
	tilemap LightningClubTilemap,            TILESET_LIGHTNING_CLUB        ; TILEMAP_LIGHTNING_CLUB
	tilemap LightningClubCGBTilemap,         TILESET_LIGHTNING_CLUB        ; TILEMAP_LIGHTNING_CLUB_CGB
	tilemap GrassClubTilemap,                TILESET_GRASS_CLUB            ; TILEMAP_GRASS_CLUB
	tilemap GrassClubCGBTilemap,             TILESET_GRASS_CLUB            ; TILEMAP_GRASS_CLUB_CGB
	tilemap PsychicClubTilemap,              TILESET_PSYCHIC_CLUB          ; TILEMAP_PSYCHIC_CLUB
	tilemap PsychicClubCGBTilemap,           TILESET_PSYCHIC_CLUB          ; TILEMAP_PSYCHIC_CLUB_CGB
	tilemap ScienceClubTilemap,              TILESET_SCIENCE_CLUB          ; TILEMAP_SCIENCE_CLUB
	tilemap ScienceClubCGBTilemap,           TILESET_SCIENCE_CLUB          ; TILEMAP_SCIENCE_CLUB_CGB
	tilemap FireClubTilemap,                 TILESET_FIRE_CLUB             ; TILEMAP_FIRE_CLUB
	tilemap FireClubCGBTilemap,              TILESET_FIRE_CLUB             ; TILEMAP_FIRE_CLUB_CGB
	tilemap ChallengeHallTilemap,            TILESET_CHALLENGE_HALL        ; TILEMAP_CHALLENGE_HALL
	tilemap ChallengeHallCGBTilemap,         TILESET_CHALLENGE_HALL        ; TILEMAP_CHALLENGE_HALL_CGB
	tilemap PokemonDomeEntranceTilemap,      TILESET_POKEMON_DOME_ENTRANCE ; TILEMAP_POKEMON_DOME_ENTRANCE
	tilemap PokemonDomeEntranceCGBTilemap,   TILESET_POKEMON_DOME_ENTRANCE ; TILEMAP_POKEMON_DOME_ENTRANCE_CGB
	tilemap Unused5Tilemap,                  TILESET_POKEMON_DOME_ENTRANCE ; TILEMAP_UNUSED_5
	tilemap Unused6Tilemap,                  TILESET_POKEMON_DOME_ENTRANCE ; TILEMAP_UNUSED_6
	tilemap PokemonDomeTilemap,              TILESET_POKEMON_DOME          ; TILEMAP_POKEMON_DOME
	tilemap PokemonDomeGBTilemap,            TILESET_POKEMON_DOME          ; TILEMAP_POKEMON_DOME_CGB
	tilemap Unused7Tilemap,                  TILESET_POKEMON_DOME          ; TILEMAP_UNUSED_7
	tilemap Unused8Tilemap,                  TILESET_POKEMON_DOME          ; TILEMAP_UNUSED_8
	tilemap HallOfHonorTilemap,              TILESET_HALL_OF_HONOR         ; TILEMAP_HALL_OF_HONOR
	tilemap HallOfHonorCGBTilemap,           TILESET_HALL_OF_HONOR         ; TILEMAP_HALL_OF_HONOR_CGB
	tilemap CardPopCGBTilemap,               TILESET_CARD_POP              ; TILEMAP_CARD_POP_CGB
	tilemap CardPopTilemap,                  TILESET_CARD_POP              ; TILEMAP_CARD_POP
	tilemap GrassMedalTilemap,               TILESET_MEDAL                 ; TILEMAP_GRASS_MEDAL
	tilemap ScienceMedalTilemap,             TILESET_MEDAL                 ; TILEMAP_SCIENCE_MEDAL
	tilemap FireMedalTilemap,                TILESET_MEDAL                 ; TILEMAP_FIRE_MEDAL
	tilemap WaterMedalTilemap,               TILESET_MEDAL                 ; TILEMAP_WATER_MEDAL
	tilemap LightningMedalTilemap,           TILESET_MEDAL                 ; TILEMAP_LIGHTNING_MEDAL
	tilemap FightingMedalTilemap,            TILESET_MEDAL                 ; TILEMAP_FIGHTING_MEDAL
	tilemap RockMedalTilemap,                TILESET_MEDAL                 ; TILEMAP_ROCK_MEDAL
	tilemap PsychicMedalTilemap,             TILESET_MEDAL                 ; TILEMAP_PSYCHIC_MEDAL
	tilemap GameBoyLinkCGBTilemap,           TILESET_GAMEBOY_LINK          ; TILEMAP_GAMEBOY_LINK_CGB
	tilemap GameBoyLinkTilemap,              TILESET_GAMEBOY_LINK          ; TILEMAP_GAMEBOY_LINK
	tilemap GameBoyLinkConnectingCGBTilemap, TILESET_GAMEBOY_LINK          ; TILEMAP_GAMEBOY_LINK_CONNECTING_CGB
	tilemap GameBoyLinkConnectingTilemap,    TILESET_GAMEBOY_LINK          ; TILEMAP_GAMEBOY_LINK_CONNECTING
	tilemap GameBoyPrinterCGBTilemap,        TILESET_GAMEBOY_PRINTER       ; TILEMAP_GAMEBOY_PRINTER_CGB
	tilemap GameBoyPrinterTilemap,           TILESET_GAMEBOY_PRINTER       ; TILEMAP_GAMEBOY_PRINTER
	tilemap ColosseumTilemap,                TILESET_COLOSSEUM_1           ; TILEMAP_COLOSSEUM
	tilemap ColosseumCGBTilemap,             TILESET_COLOSSEUM_2           ; TILEMAP_COLOSSEUM_CGB
	tilemap EvolutionTilemap,                TILESET_EVOLUTION_1           ; TILEMAP_EVOLUTION
	tilemap EvolutionCGBTilemap,             TILESET_EVOLUTION_2           ; TILEMAP_EVOLUTION_CGB
	tilemap MysteryTilemap,                  TILESET_MYSTERY_1             ; TILEMAP_MYSTERY
	tilemap MysteryCGBTilemap,               TILESET_MYSTERY_2             ; TILEMAP_MYSTERY_CGB
	tilemap LaboratoryTilemap,               TILESET_LABORATORY_1          ; TILEMAP_LABORATORY
	tilemap LaboratoryCGBTilemap,            TILESET_LABORATORY_2          ; TILEMAP_LABORATORY_CGB
	tilemap CharizardIntroTilemap,           TILESET_CHARIZARD_INTRO_1     ; TILEMAP_CHARIZARD_INTRO
	tilemap CharizardIntroCGBTilemap,        TILESET_CHARIZARD_INTRO_2     ; TILEMAP_CHARIZARD_INTRO_CGB
	tilemap ScytherIntroTilemap,             TILESET_SCYTHER_INTRO_1       ; TILEMAP_SCYTHER_INTRO
	tilemap ScytherIntroCGBTilemap,          TILESET_SCYTHER_INTRO_2       ; TILEMAP_SCYTHER_INTRO_CGB
	tilemap AerodactylIntroTilemap,          TILESET_AERODACTYL_INTRO_1    ; TILEMAP_AERODACTYL_INTRO
	tilemap AerodactylIntroCGBTilemap,       TILESET_AERODACTYL_INTRO_2    ; TILEMAP_AERODACTYL_INTRO_CGB
	tilemap TitleScreen1Tilemap,             TILESET_TITLE_SCREEN_1        ; TILEMAP_JAPANESE_TITLE_SCREEN
	tilemap TitleScreen2Tilemap,             TILESET_TITLE_SCREEN_2        ; TILEMAP_JAPANESE_TITLE_SCREEN_CGB
	tilemap SolidTiles1Tilemap,              TILESET_SOLID_TILES_1         ; TILEMAP_SOLID_TILES_1
	tilemap SolidTiles2Tilemap,              TILESET_SOLID_TILES_1         ; TILEMAP_SOLID_TILES_2
	tilemap SolidTiles3Tilemap,              TILESET_SOLID_TILES_1         ; TILEMAP_SOLID_TILES_3
	tilemap TitleScreen3Tilemap,             TILESET_TITLE_SCREEN_3        ; TILEMAP_JAPANESE_TITLE_SCREEN_2
	tilemap TitleScreen4Tilemap,             TILESET_TITLE_SCREEN_4        ; TILEMAP_JAPANESE_TITLE_SCREEN_2_CGB
	tilemap SolidTiles4Tilemap,              TILESET_SOLID_TILES_2         ; TILEMAP_SOLID_TILES_4
	tilemap PlayerTilemap,                   TILESET_PLAYER                ; TILEMAP_PLAYER
	tilemap OpponentTilemap,                 TILESET_RONALD                ; TILEMAP_OPPONENT
	tilemap TitleScreen5Tilemap,             TILESET_TITLE_SCREEN_5        ; TILEMAP_TITLE_SCREEN
	tilemap TitleScreen6Tilemap,             TILESET_TITLE_SCREEN_6        ; TILEMAP_TITLE_SCREEN_CGB
	tilemap CopyrightTilemap,                TILESET_COPYRIGHT             ; TILEMAP_COPYRIGHT
	tilemap CopyrightCGBTilemap,             TILESET_COPYRIGHT             ; TILEMAP_COPYRIGHT_CGB
	tilemap NintendoTilemap,                 TILESET_NINTENDO              ; TILEMAP_NINTENDO
	tilemap CompaniesTilemap,                TILESET_COMPANIES             ; TILEMAP_COMPANIES

; \1 = pointer
; \2 = number of tiles
tileset: MACRO
	dwb \1, BANK(\1) - BANK(Tilesets)
	db \2
ENDM

Tilesets: ; 8100f (20:500f)
	tileset OverworldMapTiles,             193 ; TILESET_OVERWORLD_MAP
	tileset MasonLaboratoryTilesetGfx,     151 ; TILESET_MASON_LABORATORY
	tileset IshiharaTilesetGfx,             77 ; TILESET_ISHIHARA
	tileset ClubEntranceTilesetGfx,        129 ; TILESET_CLUB_ENTRANCE
	tileset ClubLobbyTilesetGfx,           120 ; TILESET_CLUB_LOBBY
	tileset FightingClubTilesetGfx,         99 ; TILESET_FIGHTING_CLUB
	tileset RockClubTilesetGfx,             60 ; TILESET_ROCK_CLUB
	tileset WaterClubTilesetGfx,           161 ; TILESET_WATER_CLUB
	tileset LightningClubTilesetGfx,       131 ; TILESET_LIGHTNING_CLUB
	tileset GrassClubTilesetGfx,            87 ; TILESET_GRASS_CLUB
	tileset PsychicClubTilesetGfx,          58 ; TILESET_PSYCHIC_CLUB
	tileset ScienceClubTilesetGfx,          82 ; TILESET_SCIENCE_CLUB
	tileset FireClubTilesetGfx,             87 ; TILESET_FIRE_CLUB
	tileset ChallengeHallTilesetGfx,       157 ; TILESET_CHALLENGE_HALL
	tileset PokemonDomeEntranceTilesetGfx,  78 ; TILESET_POKEMON_DOME_ENTRANCE
	tileset PokemonDomeTilesetGfx,         207 ; TILESET_POKEMON_DOME
	tileset HallOfHonorTilesetGfx,         121 ; TILESET_HALL_OF_HONOR
	tileset CardPopGfx,                    189 ; TILESET_CARD_POP
	tileset MedalGfx,                       72 ; TILESET_MEDAL
	tileset GameBoyLinkGfx,                109 ; TILESET_GAMEBOY_LINK
	tileset GameBoyPrinterGfx,              93 ; TILESET_GAMEBOY_PRINTER
	tileset Colosseum1Gfx,                  96 ; TILESET_COLOSSEUM_1
	tileset Colosseum2Gfx,                  86 ; TILESET_COLOSSEUM_2
	tileset Evolution1Gfx,                  96 ; TILESET_EVOLUTION_1
	tileset Evolution2Gfx,                  86 ; TILESET_EVOLUTION_2
	tileset Mystery1Gfx,                    96 ; TILESET_MYSTERY_1
	tileset Mystery2Gfx,                    86 ; TILESET_MYSTERY_2
	tileset Laboratory1Gfx,                 96 ; TILESET_LABORATORY_1
	tileset Laboratory2Gfx,                 86 ; TILESET_LABORATORY_2
	tileset CharizardIntro1Gfx,             96 ; TILESET_CHARIZARD_INTRO_1
	tileset CharizardIntro2Gfx,             96 ; TILESET_CHARIZARD_INTRO_2
	tileset ScytherIntro1Gfx,               96 ; TILESET_SCYTHER_INTRO_1
	tileset ScytherIntro2Gfx,               96 ; TILESET_SCYTHER_INTRO_2
	tileset AerodactylIntro1Gfx,            96 ; TILESET_AERODACTYL_INTRO_1
	tileset AerodactylIntro2Gfx,            96 ; TILESET_AERODACTYL_INTRO_2
	tileset Titlescreen1Gfx,                97 ; TILESET_TITLE_SCREEN_1
	tileset Titlescreen2Gfx,                97 ; TILESET_TITLE_SCREEN_2
	tileset SolidTiles1,                     4 ; TILESET_SOLID_TILES_1
	tileset Titlescreen3Gfx,               244 ; TILESET_TITLE_SCREEN_3
	tileset Titlescreen4Gfx,                59 ; TILESET_TITLE_SCREEN_4
	tileset SolidTiles2,                     4 ; TILESET_SOLID_TILES_2
	tileset PlayerGfx,                      36 ; TILESET_PLAYER
	tileset RonaldGfx,                      36 ; TILESET_RONALD
	tileset Titlescreen5Gfx,               220 ; TILESET_TITLE_SCREEN_5
	tileset Titlescreen6Gfx,               212 ; TILESET_TITLE_SCREEN_6
	tileset CopyrightGfx,                   36 ; TILESET_COPYRIGHT
	tileset NintendoGfx,                    24 ; TILESET_NINTENDO
	tileset CompaniesGfx,                   49 ; TILESET_COMPANIES
	tileset SamGfx,                         36 ; TILESET_SAM
	tileset ImakuniGfx,                     36 ; TILESET_IMAKUNI
	tileset NikkiGfx,                       36 ; TILESET_NIKKI
	tileset RickGfx,                        36 ; TILESET_RICK
	tileset KenGfx,                         36 ; TILESET_KEN
	tileset AmyGfx,                         36 ; TILESET_AMY
	tileset IsaacGfx,                       36 ; TILESET_ISAAC
	tileset MitchGfx,                       36 ; TILESET_MITCH
	tileset GeneGfx,                        36 ; TILESET_GENE
	tileset MurrayGfx,                      36 ; TILESET_MURRAY
	tileset CourtneyGfx,                    36 ; TILESET_COURTNEY
	tileset SteveGfx,                       36 ; TILESET_STEVE
	tileset JackGfx,                        36 ; TILESET_JACK
	tileset RodGfx,                         36 ; TILESET_ROD
	tileset JosephGfx,                      36 ; TILESET_JOSEPH
	tileset DavidGfx,                       36 ; TILESET_DAVID
	tileset ErikGfx,                        36 ; TILESET_ERIK
	tileset JohnGfx,                        36 ; TILESET_JOHN
	tileset AdamGfx,                        36 ; TILESET_ADAM
	tileset JonathanGfx,                    36 ; TILESET_JONATHAN
	tileset JoshuaGfx,                      36 ; TILESET_JOSHUA
	tileset NicholasGfx,                    36 ; TILESET_NICHOLAS
	tileset BrandonGfx,                     36 ; TILESET_BRANDON
	tileset MatthewGfx,                     36 ; TILESET_MATTHEW
	tileset RyanGfx,                        36 ; TILESET_RYAN
	tileset AndrewGfx,                      36 ; TILESET_ANDREW
	tileset ChrisGfx,                       36 ; TILESET_CHRIS
	tileset MichaelGfx,                     36 ; TILESET_MICHAEL
	tileset DanielGfx,                      36 ; TILESET_DANIEL
	tileset RobertGfx,                      36 ; TILESET_ROBERT
	tileset BrittanyGfx,                    36 ; TILESET_BRITTANY
	tileset KristinGfx,                     36 ; TILESET_KRISTIN
	tileset HeatherGfx,                     36 ; TILESET_HEATHER
	tileset SaraGfx,                        36 ; TILESET_SARA
	tileset AmandaGfx,                      36 ; TILESET_AMANDA
	tileset JenniferGfx,                    36 ; TILESET_JENNIFER
	tileset JessicaGfx,                     36 ; TILESET_JESSICA
	tileset StephanieGfx,                   36 ; TILESET_STEPHANIE
	tileset AaronGfx,                       36 ; TILESET_AARON

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
	palette_pointer Palette0,   8, 1 ; PALETTE_0
	palette_pointer Palette1,   8, 0 ; PALETTE_1
	palette_pointer Palette2,   8, 0 ; PALETTE_2
	palette_pointer Palette3,   8, 0 ; PALETTE_3
	palette_pointer Palette4,   8, 0 ; PALETTE_4
	palette_pointer Palette5,   8, 0 ; PALETTE_5
	palette_pointer Palette6,   8, 0 ; PALETTE_6
	palette_pointer Palette7,   8, 0 ; PALETTE_7
	palette_pointer Palette8,   8, 0 ; PALETTE_8
	palette_pointer Palette9,   8, 0 ; PALETTE_9
	palette_pointer Palette10,  8, 0 ; PALETTE_10
	palette_pointer Palette11,  8, 0 ; PALETTE_11
	palette_pointer Palette12,  8, 0 ; PALETTE_12
	palette_pointer Palette13,  8, 0 ; PALETTE_13
	palette_pointer Palette14,  8, 0 ; PALETTE_14
	palette_pointer Palette15,  8, 0 ; PALETTE_15
	palette_pointer Palette16,  8, 0 ; PALETTE_16
	palette_pointer Palette17,  8, 0 ; PALETTE_17
	palette_pointer Palette18,  8, 0 ; PALETTE_18
	palette_pointer Palette19,  8, 0 ; PALETTE_19
	palette_pointer Palette20,  8, 0 ; PALETTE_20
	palette_pointer Palette21,  8, 0 ; PALETTE_21
	palette_pointer Palette22,  8, 0 ; PALETTE_22
	palette_pointer Palette23,  8, 0 ; PALETTE_23
	palette_pointer Palette24,  8, 0 ; PALETTE_24
	palette_pointer Palette25,  8, 0 ; PALETTE_25
	palette_pointer Palette26,  8, 0 ; PALETTE_26
	palette_pointer Palette27,  8, 0 ; PALETTE_27
	palette_pointer Palette28,  8, 0 ; PALETTE_28
	palette_pointer Palette29,  8, 2 ; PALETTE_29
	palette_pointer Palette30,  8, 2 ; PALETTE_30
	palette_pointer Palette31,  1, 1 ; PALETTE_31
	palette_pointer Palette32,  1, 1 ; PALETTE_32
	palette_pointer Palette33,  1, 1 ; PALETTE_33
	palette_pointer Palette34,  1, 1 ; PALETTE_34
	palette_pointer Palette35,  1, 1 ; PALETTE_35
	palette_pointer Palette36,  1, 1 ; PALETTE_36
	palette_pointer Palette37,  1, 1 ; PALETTE_37
	palette_pointer Palette38,  1, 1 ; PALETTE_38
	palette_pointer Palette39,  1, 1 ; PALETTE_39
	palette_pointer Palette40,  1, 1 ; PALETTE_40
	palette_pointer Palette41,  1, 1 ; PALETTE_41
	palette_pointer Palette42,  1, 1 ; PALETTE_42
	palette_pointer Palette43,  1, 1 ; PALETTE_43
	palette_pointer Palette44,  1, 1 ; PALETTE_44
	palette_pointer Palette45,  1, 1 ; PALETTE_45
	palette_pointer Palette46,  1, 1 ; PALETTE_46
	palette_pointer Palette47,  1, 1 ; PALETTE_47
	palette_pointer Palette48,  1, 1 ; PALETTE_48
	palette_pointer Palette49,  1, 1 ; PALETTE_49
	palette_pointer Palette50,  1, 1 ; PALETTE_50
	palette_pointer Palette51,  1, 1 ; PALETTE_51
	palette_pointer Palette52,  1, 1 ; PALETTE_52
	palette_pointer Palette53,  1, 1 ; PALETTE_53
	palette_pointer Palette54,  1, 1 ; PALETTE_54
	palette_pointer Palette55,  1, 1 ; PALETTE_55
	palette_pointer Palette56,  1, 1 ; PALETTE_56
	palette_pointer Palette57,  1, 1 ; PALETTE_57
	palette_pointer Palette58,  1, 1 ; PALETTE_58
	palette_pointer Palette59,  1, 1 ; PALETTE_59
	palette_pointer Palette60,  1, 1 ; PALETTE_60
	palette_pointer Palette61,  1, 1 ; PALETTE_61
	palette_pointer Palette62,  1, 1 ; PALETTE_62
	palette_pointer Palette63,  1, 1 ; PALETTE_63
	palette_pointer Palette64,  1, 1 ; PALETTE_64
	palette_pointer Palette65,  1, 1 ; PALETTE_65
	palette_pointer Palette66,  1, 1 ; PALETTE_66
	palette_pointer Palette67,  1, 1 ; PALETTE_67
	palette_pointer Palette68,  1, 1 ; PALETTE_68
	palette_pointer Palette69,  1, 1 ; PALETTE_69
	palette_pointer Palette70,  1, 1 ; PALETTE_70
	palette_pointer Palette71,  1, 1 ; PALETTE_71
	palette_pointer Palette72,  1, 1 ; PALETTE_72
	palette_pointer Palette73,  1, 1 ; PALETTE_73
	palette_pointer Palette74,  1, 1 ; PALETTE_74
	palette_pointer Palette75,  1, 1 ; PALETTE_75
	palette_pointer Palette76,  1, 1 ; PALETTE_76
	palette_pointer Palette77,  1, 1 ; PALETTE_77
	palette_pointer Palette78,  1, 1 ; PALETTE_78
	palette_pointer Palette79,  1, 1 ; PALETTE_79
	palette_pointer Palette80,  1, 1 ; PALETTE_80
	palette_pointer Palette81,  1, 1 ; PALETTE_81
	palette_pointer Palette82,  1, 1 ; PALETTE_82
	palette_pointer Palette83,  1, 1 ; PALETTE_83
	palette_pointer Palette84,  1, 1 ; PALETTE_84
	palette_pointer Palette85,  1, 1 ; PALETTE_85
	palette_pointer Palette86,  1, 1 ; PALETTE_86
	palette_pointer Palette87,  1, 1 ; PALETTE_87
	palette_pointer Palette88,  1, 1 ; PALETTE_88
	palette_pointer Palette89,  1, 1 ; PALETTE_89
	palette_pointer Palette90,  1, 1 ; PALETTE_90
	palette_pointer Palette91,  1, 1 ; PALETTE_91
	palette_pointer Palette92,  1, 1 ; PALETTE_92
	palette_pointer Palette93,  1, 1 ; PALETTE_93
	palette_pointer Palette94,  8, 0 ; PALETTE_94
	palette_pointer Palette95,  8, 0 ; PALETTE_95
	palette_pointer Palette96,  8, 0 ; PALETTE_96
	palette_pointer Palette97,  8, 0 ; PALETTE_97
	palette_pointer Palette98,  8, 0 ; PALETTE_98
	palette_pointer Palette99,  8, 0 ; PALETTE_99
	palette_pointer Palette100, 8, 0 ; PALETTE_100
	palette_pointer Palette101, 7, 0 ; PALETTE_101
	palette_pointer Palette102, 7, 0 ; PALETTE_102
	palette_pointer Palette103, 7, 0 ; PALETTE_103
	palette_pointer Palette104, 7, 0 ; PALETTE_104
	palette_pointer Palette105, 7, 0 ; PALETTE_105
	palette_pointer Palette106, 7, 0 ; PALETTE_106
	palette_pointer Palette107, 7, 0 ; PALETTE_107
	palette_pointer Palette108, 0, 1 ; PALETTE_108
	palette_pointer Palette109, 0, 1 ; PALETTE_109
	palette_pointer Palette110, 0, 0 ; PALETTE_110
	palette_pointer Palette111, 8, 1 ; PALETTE_111
	palette_pointer Palette112, 8, 1 ; PALETTE_112
	palette_pointer Palette113, 8, 1 ; PALETTE_113
	palette_pointer Palette114, 4, 2 ; PALETTE_114
	palette_pointer Palette115, 4, 2 ; PALETTE_115
	palette_pointer Palette116, 4, 2 ; PALETTE_116
	palette_pointer Palette117, 1, 0 ; PALETTE_117
	palette_pointer Palette118, 6, 0 ; PALETTE_118
	palette_pointer Palette119, 1, 0 ; PALETTE_119
	palette_pointer Palette120, 1, 0 ; PALETTE_120
	palette_pointer Palette121, 1, 0 ; PALETTE_121
	palette_pointer Palette122, 1, 0 ; PALETTE_122
	palette_pointer Palette123, 1, 0 ; PALETTE_123
	palette_pointer Palette124, 1, 0 ; PALETTE_124
	palette_pointer Palette125, 1, 0 ; PALETTE_125
	palette_pointer Palette126, 1, 0 ; PALETTE_126
	palette_pointer Palette127, 1, 0 ; PALETTE_127
	palette_pointer Palette128, 1, 0 ; PALETTE_128
	palette_pointer Palette129, 1, 0 ; PALETTE_129
	palette_pointer Palette130, 1, 0 ; PALETTE_130
	palette_pointer Palette131, 1, 0 ; PALETTE_131
	palette_pointer Palette132, 1, 0 ; PALETTE_132
	palette_pointer Palette133, 1, 0 ; PALETTE_133
	palette_pointer Palette134, 1, 0 ; PALETTE_134
	palette_pointer Palette135, 1, 0 ; PALETTE_135
	palette_pointer Palette136, 1, 0 ; PALETTE_136
	palette_pointer Palette137, 1, 0 ; PALETTE_137
	palette_pointer Palette138, 1, 0 ; PALETTE_138
	palette_pointer Palette139, 1, 0 ; PALETTE_139
	palette_pointer Palette140, 1, 0 ; PALETTE_140
	palette_pointer Palette141, 1, 0 ; PALETTE_141
	palette_pointer Palette142, 1, 0 ; PALETTE_142
	palette_pointer Palette143, 1, 0 ; PALETTE_143
	palette_pointer Palette144, 1, 0 ; PALETTE_144
	palette_pointer Palette145, 1, 0 ; PALETTE_145
	palette_pointer Palette146, 1, 0 ; PALETTE_146
	palette_pointer Palette147, 1, 0 ; PALETTE_147
	palette_pointer Palette148, 1, 0 ; PALETTE_148
	palette_pointer Palette149, 1, 0 ; PALETTE_149
	palette_pointer Palette150, 1, 0 ; PALETTE_150
	palette_pointer Palette151, 1, 0 ; PALETTE_151
	palette_pointer Palette152, 1, 0 ; PALETTE_152
	palette_pointer Palette153, 1, 0 ; PALETTE_153
	palette_pointer Palette154, 1, 0 ; PALETTE_154
	palette_pointer Palette155, 1, 0 ; PALETTE_155
	palette_pointer Palette156, 1, 0 ; PALETTE_156
	palette_pointer Palette157, 1, 0 ; PALETTE_157
	palette_pointer Palette158, 1, 0 ; PALETTE_158
	palette_pointer Palette159, 1, 0 ; PALETTE_159
	palette_pointer Palette160, 1, 0 ; PALETTE_160

OverworldMapTilemap:: ; 8191b (20:591b)
	db $14 ; width
	db $12 ; height
	dw $0000
	db $00

	INCBIN "data/maps/map0.bin"

OverworldMapCGBTilemap:: ; 81a22 (20:5a22)
	db $14 ; width
	db $12 ; height
	dw $0000
	db $01

	INCBIN "data/maps/map1.bin"

MasonLaboratoryTilemap:: ; 81c13 (20:5c13)
	db $1c ; width
	db $1e ; height
	dw $5d11
	db $00

	INCBIN "data/maps/map2.bin"

MasonLaboratoryCGBTilemap:: ; 81d2e (20:5d2e)
	db $1c ; width
	db $1e ; height
	dw $5eb4
	db $01

	INCBIN "data/maps/map3.bin"

Unused1Tilemap:: ; 81ed1 (20:5ed1)
	db $04 ; width
	db $06 ; height
	dw $5ef0
	db $00

	INCBIN "data/maps/map4.bin"

Unused2Tilemap:: ; 81ef5 (20:5ef5)
	db $04 ; width
	db $06 ; height
	dw $5f21
	db $01

	INCBIN "data/maps/map5.bin"

DeckMachineRoomTilemap:: ; 81f26 (20:5f26)
	db $18 ; width
	db $1e ; height
	dw $5fd3
	db $00

	INCBIN "data/maps/map6.bin"

DeckMachineRoomCGBTilemap:: ; 81feb (20:5feb)
	db $18 ; width
	db $1e ; height
	dw $612b
	db $01

	INCBIN "data/maps/map7.bin"

Unused3Tilemap:: ; 82143 (20:6143)
	db $04 ; width
	db $01 ; height
	dw $614d
	db $00

	INCBIN "data/maps/map8.bin"

Unused4Tilemap:: ; 82150 (20:6150)
	db $04 ; width
	db $01 ; height
	dw $615d
	db $01

	INCBIN "data/maps/map9.bin"

IshiharaTilemap:: ; 82160 (20:6160)
	db $14 ; width
	db $18 ; height
	dw $620e
	db $00

	INCBIN "data/maps/map10.bin"

IshiharaCGBTilemap:: ; 82222 (20:6222)
	db $14 ; width
	db $18 ; height
	dw $6322
	db $01

	INCBIN "data/maps/map11.bin"

FightingClubEntranceTilemap:: ; 82336 (20:6336)
	db $14 ; width
	db $12 ; height
	dw $63ec
	db $00

	INCBIN "data/maps/map12.bin"

FightingClubEntranceCGBTilemap:: ; 82400 (20:6400)
	db $14 ; width
	db $12 ; height
	dw $6509
	db $01

	INCBIN "data/maps/map13.bin"

RockClubEntranceTilemap:: ; 8251d (20:651d)
	db $14 ; width
	db $12 ; height
	dw $65d3
	db $00

	INCBIN "data/maps/map14.bin"

RockClubEntranceCGBTilemap:: ; 825e7 (20:65e7)
	db $14 ; width
	db $12 ; height
	dw $66f0
	db $01

	INCBIN "data/maps/map15.bin"

WaterClubEntranceTilemap:: ; 82704 (20:6704)
	db $14 ; width
	db $12 ; height
	dw $67ba
	db $00

	INCBIN "data/maps/map16.bin"

WaterClubEntranceCGBTilemap:: ; 827ce (20:67ce)
	db $14 ; width
	db $12 ; height
	dw $68d7
	db $01

	INCBIN "data/maps/map17.bin"

LightningClubEntranceTilemap:: ; 828eb (20:68eb)
	db $14 ; width
	db $12 ; height
	dw $69a1
	db $00

	INCBIN "data/maps/map18.bin"

LightningClubEntranceCGBTilemap:: ; 829b5 (20:69b5)
	db $14 ; width
	db $12 ; height
	dw $6abe
	db $01

	INCBIN "data/maps/map19.bin"

GrassClubEntranceTilemap:: ; 82ad2 (20:6ad2)
	db $14 ; width
	db $12 ; height
	dw $6b88
	db $00

	INCBIN "data/maps/map20.bin"

GrassClubEntranceCGBTilemap:: ; 82b9c (20:6b9c)
	db $14 ; width
	db $12 ; height
	dw $6ca5
	db $01

	INCBIN "data/maps/map21.bin"

PsychicClubEntranceTilemap:: ; 82cb9 (20:6cb9)
	db $14 ; width
	db $12 ; height
	dw $6d6f
	db $00

	INCBIN "data/maps/map22.bin"

PsychicClubEntranceCGBTilemap:: ; 82d83 (20:6d83)
	db $14 ; width
	db $12 ; height
	dw $6e8c
	db $01

	INCBIN "data/maps/map23.bin"

ScienceClubEntranceTilemap:: ; 82ea0 (20:6ea0)
	db $14 ; width
	db $12 ; height
	dw $6f56
	db $00

	INCBIN "data/maps/map24.bin"

ScienceClubEntranceCGBTilemap:: ; 82f6a (20:6f6a)
	db $14 ; width
	db $12 ; height
	dw $7073
	db $01

	INCBIN "data/maps/map25.bin"

FireClubEntranceTilemap:: ; 83087 (20:7087)
	db $14 ; width
	db $12 ; height
	dw $713d
	db $00

	INCBIN "data/maps/map26.bin"

FireClubEntranceCGBTilemap:: ; 83151 (20:7151)
	db $14 ; width
	db $12 ; height
	dw $725a
	db $01

	INCBIN "data/maps/map27.bin"

ChallengeHallEntranceTilemap:: ; 8326e (20:726e)
	db $14 ; width
	db $12 ; height
	dw $730d
	db $00

	INCBIN "data/maps/map28.bin"

ChallengeHallEntranceCGBTilemap:: ; 83321 (20:7321)
	db $14 ; width
	db $12 ; height
	dw $7410
	db $01

	INCBIN "data/maps/map29.bin"

ClubLobbyTilemap:: ; 83424 (20:7424)
	db $1c ; width
	db $1a ; height
	dw $7529
	db $00

	INCBIN "data/maps/map30.bin"

ClubLobbyCGBTilemap:: ; 83545 (20:7545)
	db $1c ; width
	db $1a ; height
	dw $76bf
	db $01

	INCBIN "data/maps/map31.bin"

FightingClubTilemap:: ; 836db (20:76db)
	db $18 ; width
	db $12 ; height
	dw $777b
	db $00

	INCBIN "data/maps/map32.bin"

FightingClubCGBTilemap:: ; 8378c (20:778c)
	db $18 ; width
	db $12 ; height
	dw $787c
	db $01

	INCBIN "data/maps/map33.bin"

RockClubTilemap:: ; 8388d (20:788d)
	db $1c ; width
	db $1e ; height
	dw $79b5
	db $00

	INCBIN "data/maps/map34.bin"

RockClubCGBTilemap:: ; 839d6 (20:79d6)
	db $1c ; width
	db $1e ; height
	dw $7bd0
	db $01

	INCBIN "data/maps/map35.bin"

Unused5Tilemap:: ; 83bf1 (20:7bf1)
	db $04 ; width
	db $03 ; height
	dw $7c00
	db $00

	INCBIN "data/maps/map52.bin"

Unused6Tilemap:: ; 83c03 (20:7c03)
	db $04 ; width
	db $03 ; height
	dw $7c17
	db $01

	INCBIN "data/maps/map53.bin"

Unused7Tilemap:: ; 83c1a (20:7c1a)
	db $04 ; width
	db $03 ; height
	dw $7c23
	db $00

	INCBIN "data/maps/map56.bin"

Unused8Tilemap:: ; 83c26 (20:7c26)
	db $04 ; width
	db $03 ; height
	dw $7c33
	db $01

	INCBIN "data/maps/map57.bin"

GrassMedalTilemap:: ; 83c36 (20:7c36)
	db $03 ; width
	db $03 ; height
	dw $0000
	db $01

	INCBIN "data/maps/map62.bin"

AnimData1:: ; 83c4c (20:7c4c)
	frame_table AnimFrameTable0
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0

Palette110:: ; 83c5b (20:7c5b)
	db $00, $00

rept $3a3
	db $ff
endr
