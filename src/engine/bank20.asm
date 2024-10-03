; loads the graphics and permissions for the current map
; according to its Map Header configurations
; if it's the Overworld Map, also prints the map name
; and sets up the volcano animation
LoadMapGfxAndPermissions:
	call ClearSRAMBGMaps
	xor a
	ld [wTextBoxFrameType], a
	call LoadMapTilesAndPals
	farcall LoadPermissionMap
	farcall Func_c9c7
	call SafelyCopyBGMapFromSRAMToVRAM
	farcall Func_c3ff
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	ret nz
	farcall OverworldMap_PrintMapName
	farcall OverworldMap_InitVolcanoSprite
	ret

; reloads the map tiles and permissions
; after a textbox has been closed
ReloadMapAfterTextClose:
	call ClearSRAMBGMaps
	lb bc, 0, 0
	call LoadTilemap_ToSRAM
	farcall Func_c9c7
	call SafelyCopyBGMapFromSRAMToVRAM
	farcall Func_c3ee
	ret

LoadMapTilesAndPals:
	farcall LoadMapHeader
	farcall SetSGB2AndSGB3MapPalette
	lb bc, 0, 0
	call LoadTilemap_ToSRAM

	ld a, LOW(v0Tiles1 / TILE_SIZE)
	ld [wVRAMTileOffset], a
	xor a ; VRAM0
	ld [wd4cb], a
	call LoadTilesetGfx

	xor a ; LOW(v0Tiles2 / TILE_SIZE)
	ld [wVRAMTileOffset], a
	ld a, [wd291]
	ld [wd4cb], a
	ld a, [wCurMapInitialPalette]
	call SetBGPAndLoadedPal
	ld a, [wd291]
	ld [wd4cb], a
	ld a, [wCurMapPalette]
	or a
	jr z, .asm_80076
	call SetBGPAndLoadedPal
.asm_80076
	ret

; loads the BG map corresponding to wCurTilemap to SRAM
; bc = starting coordinates
LoadTilemap_ToSRAM:
	ld a, TRUE
	ld [wWriteBGMapToSRAM], a
	jr LoadTilemap

; loads the BG map corresponding to wCurTilemap to VRAM
; bc = starting coordinates
LoadTilemap_ToVRAM:
	xor a ; FALSE
	ld [wWriteBGMapToSRAM], a
;	fallthrough

; loads the BG map corresponding to wCurTilemap
; either loads them in VRAM or SRAM,
; depending on wWriteBGMapToSRAM
; bc = starting coordinates
LoadTilemap:
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
	ld [wBGMapBank], a

; store header data
	ld de, wDecompressionBuffer
	ld bc, $6 ; header + 1st instruction
	call CopyBankedDataToDE
	ld l, e
	ld h, d
	ld a, [hli]
	ld [wBGMapWidth], a
	ld a, [hli]
	ld [wBGMapHeight], a
	ld a, [hli]
	ld [wBGMapPermissionDataPtr], a
	ld a, [hli]
	ld [wBGMapPermissionDataPtr + 1], a
	ld a, [hli]
	ld [wBGMapCGBMode], a
	call .InitAndDecompressBGMap
	pop de
	pop bc
	pop hl
	ret

; prepares the pointers for decompressing BG Map
; and calls InitDataDecompression
; then decompresses the data
.InitAndDecompressBGMap
	push hl
	push bc
	push de
	ld a, [wTempPointer]
	add $5 ; header
	ld e, a
	ld a, [wTempPointer + 1]
	adc 0
	ld d, a
	ld b, HIGH(wDecompressionSecondaryBuffer)
	call InitDataDecompression
	ld a, [wVRAMPointer]
	ld e, a
	ld a, [wVRAMPointer + 1]
	ld d, a
	call .Decompress
	pop de
	pop bc
	pop hl
	ret

; wTempBank:wTempPointer = source of compressed data
; wVRAMPointer = destination of decompressed data
.Decompress
; if wBGMapCGBMode is true, then use double wBGMapWidth
; since one "width" length goes to VRAM0
; and the other "width" length goes to VRAM1
	push hl
	ld hl, wDecompressionRowWidth
	ld a, [wBGMapWidth]
	ld [hl], a
	ld a, [wBGMapCGBMode]
	or a
	jr z, .skip_doubling_width
	sla [hl]
.skip_doubling_width

; clear wDecompressionBuffer
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
	ld a, [wDecompressionRowWidth]
	ld c, a
	ld de, wDecompressionBuffer
	call DecompressDataFromBank

	; copy to VRAM0
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
	; copy the second "half" to VRAM1
	call BankswitchVRAM1
	ld a, [wBGMapWidth]
	ld c, a
	ld b, $0
	ld hl, wDecompressionBuffer
	add hl, bc
	pop de
	push de
	ld a, [wBGMapWidth]
	ld b, a
	call Func_80148 ; adds some wd291 offset to tiles
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

Func_80148:
	ld a, [wd291]
	or a
	ret z
	ld a, [wBGMapCGBMode]
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
; copies data to sGfxBuffer0 or sGfxBuffer1
; for VRAM0 or VRAM1 respectively
CopyBGDataToVRAMOrSRAM:
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
	ld hl, sGfxBuffer0 - v0BGMap0
	ldh a, [hBankVRAM]
	or a
	jr z, .got_pointer
	ld hl, sGfxBuffer1 - v1BGMap0
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

; safely copies $20 bytes at a time
; sGfxBuffer0 -> v0BGMap0
; sGfxBuffer1 -> v0BGMap1 (if in CGB)
SafelyCopyBGMapFromSRAMToVRAM:
	push hl
	push bc
	push de
	ldh a, [hBankSRAM]
	push af
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	ld hl, sGfxBuffer0
	ld de, v0BGMap0
	ld c, $20
.loop
	push bc
	push hl
	push de
	ld b, $20
	call SafeCopyDataHLtoDE
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .skip_vram1
	pop de
	pop hl
	push hl
	push de
	ld bc, sGfxBuffer1 - sGfxBuffer0 ; $400
	add hl, bc
	call BankswitchVRAM1
	ld b, $20
	call SafeCopyDataHLtoDE
	call BankswitchVRAM0
.skip_vram1

	pop hl
	ld de, $20
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld bc, $20
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
	pop af
	call BankswitchSRAM
	call DisableSRAM
	pop de
	pop bc
	pop hl
	ret

; clears sGfxBuffer0 and sGfxBuffer1
ClearSRAMBGMaps:
	push hl
	push bc
	ldh a, [hBankSRAM]
	push af
	ld a, BANK(sGfxBuffer0) ; SRAM 1
	call BankswitchSRAM
	ld hl, sGfxBuffer0
	ld bc, $800 ; sGfxBuffer0 + sGfxBuffer1
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
GetMapDataPointer:
	push bc
	push af
	ld bc, GfxTablePointers
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
LoadGraphicsPointerFromHL:
	ld a, [hli]
	ld [wTempPointer], a
	ld a, [hli]
	ld [wTempPointer + 1], a
	ld a, [hli]
	add BANK(GfxTablePointers)
	ld [wTempPointerBank], a
	ret

Func_80238: ; unreferenced
	push hl
	ld l, $2 ; Tilesets
	ld a, [wCurTileset]
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
	ld a, [hl]
	ld [wTotalNumTiles], a
	ld a, $10
	ld [wCurSpriteTileSize], a
	xor a
	ld [wd4cb], a
	ld a, $80
	ld [wd4ca], a
	call LoadGfxDataFromTempPointerToVRAMBank_Tiles0ToTiles2
	pop hl
	ret

; loads graphics data from third map data pointers
; input:
; a = sprite index within the data map
; output:
; a = number of tiles in sprite
Func_8025b:
	push hl
	ld l, $4 ; Sprites
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
LoadGfxDataFromTempPointerToVRAMBank:
	call GetTileOffsetPointerAndSwitchVRAM
	jr LoadGfxDataFromTempPointer

LoadGfxDataFromTempPointerToVRAMBank_Tiles0ToTiles2:
	call GetTileOffsetPointerAndSwitchVRAM_Tiles0ToTiles2
;	fallthrough

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
GetTileOffsetPointerAndSwitchVRAM:
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
GetTileOffsetPointerAndSwitchVRAM_Tiles0ToTiles2:
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

; loads tileset gfx to VRAM corresponding to wCurTileset
LoadTilesetGfx:
	push hl
	ld l, $02 ; Tilesets
	ld a, [wCurTileset]
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
	call .LoadTileGfx
	call BankswitchVRAM0
	pop hl
	ret

; loads gfx data from wTempPointerBank:wTempPointer
.LoadTileGfx
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

; copies gfx data from wTempPointer to VRAM
; c must match with wVRAMTileOffset
; if c = $00, copies it to Tiles2
; if c = $80, copies it to Tiles1
; b must match with VRAM bank in wd4cb
; prepares next call to this routine if data wasn't fully copied
; so that it copies to the right VRAM section
.CopyGfxData
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

; gets pointer to BG map with ID from wCurTilemap
Func_803b9:
	ld l, $00 ; Tilemaps
	ld a, [wCurTilemap]
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
	ld a, [hl]
	ld [wCurTileset], a
	ret

; sets BGP in wLoadedPalData (if any)
; then loads the rest of the palette data
; a = palette index to load
SetBGPAndLoadedPal:
	push hl
	push bc
	push de
	call LoadPaletteDataToBuffer
	ld hl, wLoadedPalData
	ld a, [hli]
	or a
	jr z, .skip_bgp
	ld a, [hli]
	push hl
	call SetBGP
	pop hl
.skip_bgp

	ld a, [hli]
	or a
	jr z, .skip_pal
	ld c, a
	ld a, [wd4cb]
	ld b, a
	call LoadPaletteDataFromHL
.skip_pal
	pop de
	pop bc
	pop hl
	ret

; copies from palette data in hl c*8 bytes to palette index b
; in WRAM, starting from wBackgroundPalettesCGB
; b = palette index
; c = palette size
; hl = palette data to copy
LoadPaletteDataFromHL:
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

; loads palette index a
LoadPaletteData:
	push hl
	push bc
	push de
	call LoadPaletteDataToBuffer

	ld hl, wLoadedPalData
	ld a, [hli] ; number palettes
	ld c, a
	or a
	jr z, .check_palette_size

	ld a, [wd4ca]
	cp $01
	jr z, .obp1

	ld a, [hli] ; palette for OBP0
	push hl
	push bc
	call SetOBP0
	pop bc
	pop hl
	dec c
	jr z, .check_palette_size

.obp1
	ld a, [hli] ; palette for OBP1
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

; copies palette data of index in a to wLoadedPalData
LoadPaletteDataToBuffer:
	push hl
	push bc
	push de
	ld l, $08 ; Palettes
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

ClearNumLoadedFramesetSubgroups:
	xor a
	ld [wNumLoadedFramesetSubgroups], a
	ret

; for the current map, process the animation
; data of its corresponding OW tiles
DoMapOWFrame:
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

; processes the OW frameset pointed by hl
ProcessOWFrameset:
	push hl
	push bc
	ld a, l
	ld [wCurMapOWFrameset], a
	ld a, h
	ld [wCurMapOWFrameset + 1], a
	xor a
	ld [wNumLoadedFramesetSubgroups], a
	call ClearOWFramesetSubgroups
	ld c, 0
.loop_subgroups
	call LoadOWFramesetSubgroup
	call GetOWFramesetSubgroupData
	ld a, [wCurOWFrameDataOffset]
	cp -1
	jr z, .next_subgroup
	ld a, [wNumLoadedFramesetSubgroups]
	inc a
	ld [wNumLoadedFramesetSubgroups], a
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

; for each of the loaded frameset subgroups
; load their tiles and advance their durations
DoLoadedFramesetSubgroupsFrame::
	ld a, [wNumLoadedFramesetSubgroups]
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

; from subgroup in register c, get
; from OW frameset in hl its corresponding
; data offset and duration
GetOWFramesetSubgroupData:
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

; if wCurOWFrameDuration == 0, processes next frame for OW map
; by loading the tiles corresponding to current frame
; if wCurOWFrameDuration != 0, then simply decrements it and returns
LoadOWFrameTiles:
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

; fills wOWFramesetSubgroups with $ff
ClearOWFramesetSubgroups:
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

; copies wOWFramesetSubgroups + 2*c
; to wCurOWFrameDataOffset and wCurOWFrameDuration
; also returns its current duration
LoadOWFramesetSubgroup:
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

; copies wCurOWFrameDataOffset and wCurOWFrameDuration
; to wOWFramesetSubgroups + 2*c
StoreOWFramesetSubgroup:
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

INCLUDE "data/map_ow_framesets.asm"

; clears wOWMapEvents
Func_80b7a:
	push hl
	push bc
	ld c, $b
	ld hl, wOWMapEvents
	xor a
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	pop bc
	pop hl
	ret

; a = MAP_EVENT_* constant
Func_80b89:
	push hl
	push bc
	push af
	ld c, a
	ld a, TRUE
	ld [wWriteBGMapToSRAM], a
	ld b, $0
	ld hl, wOWMapEvents
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

Func_80ba4:
	push af
	xor a
	ld [wWriteBGMapToSRAM], a
	pop af
;	fallthrough

Func_80baa:
	push hl
	push bc
	push de
	ld c, a
	ld a, [wCurTilemap]
	push af
	ld a, [wBGMapBank]
	push af
	ld a, [wBGMapWidth]
	push af
	ld a, [wBGMapHeight]
	push af
	ld a, [wBGMapPermissionDataPtr]
	push af
	ld a, [wBGMapPermissionDataPtr + 1]
	push af

	ld b, $0
	ld hl, wOWMapEvents
	add hl, bc
	ld a, $1
	ld [hl], a

	ld a, c
	add a
	ld c, a
	ld b, $0
	ld hl, .TilemapPointers
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
	jr nz, .got_tilemap
	inc hl
.got_tilemap
	ld a, [hl]
	ld [wCurTilemap], a

	push bc
	farcall LoadTilemap ; unnecessary farcall
	pop bc
	srl b
	ld a, c
	rrca
	and $0f
	swap a ; * $10
	add b
	ld c, a
	ld b, $0
	ld hl, wPermissionMap
	add hl, bc
	farcall DecompressPermissionMap
	pop af
	ld [wBGMapPermissionDataPtr + 1], a
	pop af
	ld [wBGMapPermissionDataPtr], a
	pop af
	ld [wBGMapHeight], a
	pop af
	ld [wBGMapWidth], a
	pop af
	ld [wBGMapBank], a
	pop af
	ld [wCurTilemap], a
	pop de
	pop bc
	pop hl
	ret

.TilemapPointers
	table_width 2, Func_80baa.TilemapPointers
	dw .PokemonDomeDoor      ; MAP_EVENT_POKEMON_DOME_DOOR
	dw .HallOfHonorDoor      ; MAP_EVENT_HALL_OF_HONOR_DOOR
	dw .FightingDeckMachine  ; MAP_EVENT_FIGHTING_DECK_MACHINE
	dw .RockDeckMachine      ; MAP_EVENT_ROCK_DECK_MACHINE
	dw .WaterDeckMachine     ; MAP_EVENT_WATER_DECK_MACHINE
	dw .LightningDeckMachine ; MAP_EVENT_LIGHTNING_DECK_MACHINE
	dw .GrassDeckMachine     ; MAP_EVENT_GRASS_DECK_MACHINE
	dw .PsychicDeckMachine   ; MAP_EVENT_PSYCHIC_DECK_MACHINE
	dw .ScienceDeckMachine   ; MAP_EVENT_SCIENCE_DECK_MACHINE
	dw .FireDeckMachine      ; MAP_EVENT_FIRE_DECK_MACHINE
	dw .ChallengeMachine     ; MAP_EVENT_CHALLENGE_MACHINE
	assert_table_length NUM_MAP_EVENTS

; x coordinate, y coordinate, non-cgb tilemap, cgb tilemap
.PokemonDomeDoor
	db $16, $00, TILEMAP_POKEMON_DOME_DOOR_MAP_EVENT, TILEMAP_POKEMON_DOME_DOOR_MAP_EVENT_CGB
.HallOfHonorDoor
	db $0e, $00, TILEMAP_HALL_OF_HONOR_DOOR_MAP_EVENT, TILEMAP_HALL_OF_HONOR_DOOR_MAP_EVENT_CGB
.FightingDeckMachine
	db $06, $02, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.RockDeckMachine
	db $0a, $02, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.WaterDeckMachine
	db $0e, $02, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.LightningDeckMachine
	db $12, $02, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.GrassDeckMachine
	db $0e, $0a, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.PsychicDeckMachine
	db $12, $0a, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.ScienceDeckMachine
	db $0e, $12, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.FireDeckMachine
	db $12, $12, TILEMAP_DECK_MACHINE_MAP_EVENT, TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
.ChallengeMachine
	db $0a, $00, TILEMAP_CHALLENGE_MACHINE_MAP_EVENT, TILEMAP_CHALLENGE_MACHINE_MAP_EVENT_CGB

	ret ; stray ret

Func_80c64: ; unreferenced
	ld a, [wLineSeparation]
	push af
	ld a, SINGLE_SPACED
	ld [wLineSeparation], a
	; load opponent's name
	ld a, [wOpponentName]
	ld [wTxRam2], a
	ld a, [wOpponentName + 1]
	ld [wTxRam2 + 1], a
	ld a, [wNPCDuelistCopy]
	ld [wTxRam3_b], a
	xor a
	ld [wTxRam3_b + 1], a
	; load number of duel prizes
	ld a, [wNPCDuelPrizes]
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a

	lb de, 2, 13
	call InitTextPrinting
	ldtx hl, WinLosePrizesDuelWithText
	call PrintTextNoDelay

	ld a, [wNPCDuelDeckID]
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	lb de, 2, 15
	call InitTextPrinting
	ldtx hl, UseDuelistsDeckText
	call PrintTextNoDelay

	pop af
	ld [wLineSeparation], a
	xor a
	ld hl, .menu_parameters
	call InitializeMenuParameters
	ret

.menu_parameters
	db 1, 13 ; cursor x, cursor y
	db 1 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; fills Tiles0 with random bytes
Func_80cc3: ; unreferenced
	call DisableLCD
	ld hl, v0Tiles0
	ld bc, $800
.loop
	call UpdateRNGSources
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

Func_80cd6:
	ret

; seems to be used to look at each OW NPC sprites
; with functions to rotate NPC and animate them
Func_80cd7:
	call DisableLCD
	call EmptyScreen
	call ClearSpriteAnimations
	xor a
	ld [wd4ca], a
	ld [wd4cb], a
	ld a, PALETTE_0
	farcall SetBGPAndLoadedPal
	xor a
	ld [wd4ca], a
	ld [wd4cb], a
	ld a, PALETTE_29
	farcall LoadPaletteData
	ld a, SOUTH
	ld [wLoadNPCDirection], a
	ld a, $01
	ld [wLoadedNPCTempIndex], a
	call .DrawNPCSprite
	call .PrintNPCInfo
	call EnableLCD
.loop
	call DoFrameIfLCDEnabled
	call .HandleInput
	call HandleAllSpriteAnimations
	ldh a, [hKeysPressed]
	and SELECT ; if select is pressed, exit
	jr z, .loop
	ret

	ret ; stray ret

; A button makes NPC rotate
; D-pad scrolls through the NPCs
; from $01 to $2c
; these are not aligned with the regular NPC indices
.HandleInput
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .no_a_button
	ld a, [wLoadNPCDirection]
	inc a ; rotate NPC
	and %11
	ld [wLoadNPCDirection], a
	call ClearSpriteAnimations
	call .DrawNPCSprite
.no_a_button
	ldh a, [hKeysPressed]
	and D_PAD
	ret z
	farcall GetDirectionFromDPad
	ld hl, .func_table
	jp JumpToFunctionInTable

.func_table
	dw .up ; D_UP
	dw .right ; D_RIGHT
	dw .down ; D_DOWN
	dw .left ; D_LEFT
.up
	ld a, 10
	jr .decr_npc_id
.down
	ld a, 10
	jr .incr_npc_id
.right
	ld a, 1
	jr .incr_npc_id
.left
	ld a, 1
	jr .decr_npc_id

.incr_npc_id
	ld c, a
	ld a, [wLoadedNPCTempIndex]
	cp $2c
	jr z, .load_first_npc
	add c
	jr c, .load_last_npc
	cp $2c
	jr nc, .load_last_npc
	jr .got_npc

.decr_npc_id
	ld c, a
	ld a, [wLoadedNPCTempIndex]
	cp $01
	jr z, .load_last_npc
	sub c
	jr c, .load_first_npc
	cp $01
	jr c, .load_first_npc
	jr .got_npc
.load_first_npc
	ld a, $01
	jr .got_npc
.load_last_npc
	ld a, $2c

.got_npc
	ld [wLoadedNPCTempIndex], a
	call ClearSpriteAnimations
	call .DrawNPCSprite
	jr .PrintNPCInfo

.PrintNPCInfo
	lb de, 0, 4
	call InitTextPrinting
	ldtx hl, SPRText
	call ProcessTextFromID
	ld bc, FlushAllPalettes
	ld a, [wLoadedNPCTempIndex]
	farcall WriteTwoByteNumberInTxSymbolFormat
	ret

.DrawNPCSprite
	ld a, [wLoadedNPCTempIndex]
	ld c, a
	add a
	add c ; *3
	ld c, a
	ld b, $0
	ld hl, .NPCSpriteAnimData - 3
	add hl, bc
	ld a, [hli]
	cp $ff
	jr z, .skip_draw_sprite
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	inc hl
.not_cgb
	ld a, [wLoadNPCDirection]
	add [hl]
	farcall StartNewSpriteAnimation
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, $48
	ld [hli], a
	ld a, $40
	ld [hl], a ; SPRITE_ANIM_COORD_Y
.skip_draw_sprite
	ret

.NPCSpriteAnimData
	db SPRITE_OW_PLAYER,   SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_RED_NPC_UP       ; $01
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $02
	db SPRITE_OW_RONALD,   SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_BLUE_NPC_UP      ; $03
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $04
	db SPRITE_OW_DRMASON,  SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_WHITE_NPC_UP     ; $05
	db SPRITE_OW_ISHIHARA, SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_PURPLE_NPC_UP    ; $06
	db SPRITE_OW_IMAKUNI,  SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $07
	db SPRITE_OW_NIKKI,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_GREEN_NPC_UP     ; $08
	db SPRITE_OW_RICK,     SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $09
	db SPRITE_OW_KEN,      SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_RED_NPC_UP       ; $0a
	db SPRITE_OW_AMY,      SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_BLUE_NPC_UP      ; $0b
	db SPRITE_OW_ISAAC,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $0c
	db SPRITE_OW_MITCH,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $0d
	db SPRITE_OW_GENE,     SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_PURPLE_NPC_UP    ; $0e
	db SPRITE_OW_MURRAY,   SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_PINK_NPC_UP      ; $0f
	db SPRITE_OW_COURTNEY, SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_PINK_NPC_UP      ; $10
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $11
	db SPRITE_OW_STEVE,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_INDIGO_NPC_UP    ; $12
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $13
	db SPRITE_OW_JACK,     SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_WHITE_NPC_UP     ; $14
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $15
	db SPRITE_OW_ROD,      SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $16
	db $ff,                SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_LIGHT_NPC_UP     ; $17
	db SPRITE_OW_BOY,      SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_YELLOW_NPC_UP    ; $18
	db SPRITE_OW_LAD,      SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_GREEN_NPC_UP     ; $19
	db SPRITE_OW_SPECS,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_PURPLE_NPC_UP    ; $1a
	db SPRITE_OW_BUTCH,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $1b
	db SPRITE_OW_MANIA,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_WHITE_NPC_UP     ; $1c
	db SPRITE_OW_JOSHUA,   SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_WHITE_NPC_UP     ; $1d
	db SPRITE_OW_HOOD,     SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_RED_NPC_UP       ; $1e
	db SPRITE_OW_TECH,     SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_BLUE_NPC_UP      ; $1f
	db SPRITE_OW_CHAP,     SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_GREEN_NPC_UP     ; $20
	db SPRITE_OW_MAN,      SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $21
	db SPRITE_OW_PAPPY,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_PURPLE_NPC_UP    ; $22
	db SPRITE_OW_GIRL,     SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_BLUE_NPC_UP      ; $23
	db SPRITE_OW_LASS1,    SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_PURPLE_NPC_UP    ; $24
	db SPRITE_OW_LASS2,    SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_RED_NPC_UP       ; $25
	db SPRITE_OW_LASS3,    SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_GREEN_NPC_UP     ; $26
	db SPRITE_OW_SWIMMER,  SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $27
	db SPRITE_OW_CLERK,    SPRITE_ANIM_SGB_CLERK_NPC_UP, SPRITE_ANIM_CGB_CLERK_NPC_UP ; $28
	db SPRITE_OW_GAL,      SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $29
	db SPRITE_OW_WOMAN,    SPRITE_ANIM_DARK_NPC_UP,      SPRITE_ANIM_RED_NPC_UP       ; $2a
	db SPRITE_OW_GRANNY,   SPRITE_ANIM_LIGHT_NPC_UP,     SPRITE_ANIM_YELLOW_NPC_UP    ; $2b
	db SPRITE_OW_AMY,      SPRITE_ANIM_SGB_AMY_LAYING,   SPRITE_ANIM_CGB_AMY_LAYING   ; $2c

SpriteNullAnimationPointer::
	dw SpriteNullAnimationFrame

SpriteNullAnimationFrame:
	db 0
