; loads the graphics and permissions for the current map
; according to its Map Header configurations
; if it's the Overworld Map, also prints the map name
; and sets up the volcano animation
LoadMapGfxAndPermissions: ; 80000 (20:4000)
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
ReloadMapAfterTextClose: ; 80028 (20:4028)
	call ClearSRAMBGMaps
	lb bc, 0, 0
	call LoadTilemap_ToSRAM
	farcall Func_c9c7
	call SafelyCopyBGMapFromSRAMToVRAM
	farcall Func_c3ee
	ret

LoadMapTilesAndPals: ; 8003d (20:403d)
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
LoadTilemap_ToSRAM: ; 80077 (20:4077)
	ld a, TRUE
	ld [wWriteBGMapToSRAM], a
	jr LoadTilemap

; loads the BG map corresponding to wCurTilemap to VRAM
; bc = starting coordinates
LoadTilemap_ToVRAM: ; 8007e (20:407e)
	xor a ; FALSE
	ld [wWriteBGMapToSRAM], a
;	fallthrough

; loads the BG map corresponding to wCurTilemap
; either loads them in VRAM or SRAM,
; depending on wWriteBGMapToSRAM
; bc = starting coordinates
LoadTilemap: ; 80082 (20:4082)
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
.InitAndDecompressBGMap ; 800bd (20:40bd)
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
.Decompress ; 800e0 (20:40e0)
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

Func_80148: ; 80148 (20:4148)
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
SafelyCopyBGMapFromSRAMToVRAM: ; 801a1 (20:41a1)
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
ClearSRAMBGMaps: ; 801f1 (20:41f1)
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

; unreferenced?
Func_80238: ; 80238 (20:4238)
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
Func_8025b: ; 8025b (20:425b)
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
LoadGfxDataFromTempPointerToVRAMBank: ; 80274 (20:4274)
	call GetTileOffsetPointerAndSwitchVRAM
	jr LoadGfxDataFromTempPointer

LoadGfxDataFromTempPointerToVRAMBank_Tiles0ToTiles2: ; 80279 (20:4279)
	call GetTileOffsetPointerAndSwitchVRAM_Tiles0ToTiles2
;	fallthrough

; loads graphics data pointed by wTempPointer in wTempPointerBank
; to wVRAMPointer
LoadGfxDataFromTempPointer: ; 8027c (20:427c)
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

; loads tileset gfx to VRAM corresponding to wCurTileset
LoadTilesetGfx: ; 802d4 (20:42d4)
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

; gets pointer to BG map with ID from wCurTilemap
Func_803b9: ; 803b9 (20:43b9)
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
SetBGPAndLoadedPal: ; 803c9 (20:43c9)
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

; loads palette index a
LoadPaletteData: ; 80418 (20:4418)
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
LoadPaletteDataToBuffer: ; 80456 (20:4456)
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

ClearNumLoadedFramesetSubgroups: ; 8047b (20:447b)
	xor a
	ld [wNumLoadedFramesetSubgroups], a
	ret

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

; processes the OW frameset pointed by hl
ProcessOWFrameset: ; 804a2 (20:44a2)
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
DoLoadedFramesetSubgroupsFrame: ; 804d8 (20:44d8)
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

INCLUDE "data/map_ow_framesets.asm"

; clears wOWMapEvents
Func_80b7a: ; 80b7a (20:4b7a)
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
Func_80b89: ; 80b89 (20:4b89)
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
	ld hl, .tilemap_pointers
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
	ld [wd23d], a
	pop af
	ld [wCurTilemap], a
	pop de
	pop bc
	pop hl
	ret

.tilemap_pointers
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

	ret ; unreferenced stray ret?

; unreferenced?
Func_80c64: ; 80c64 (20:4c64)
	ld a, [wLineSeparation]
	push af
	ld a, $01 ; no line separator
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

.menu_parameters ; 80cbb (20:4cbb)
	db 1, 13 ; cursor x, cursor y
	db 1 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

; unreferenced?
; fills Tiles0 with random bytes
Func_80cc3: ; 80cc3 (20:4cc3)
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

Func_80cd6: ; 80cd6 (20:4cd6)
	ret

; seems to be used to look at each OW NPC sprites
; with functions to rotate NPC and animate them
Func_80cd7: ; 80cd7 (20:4cd7)
	call DisableLCD
	call EmptyScreen
	call Func_3ca4
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
	call Func_3ca4
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
	call Func_3ca4
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

SpriteNullAnimationPointer: ; 80e5a (20:4e5a)
	dw SpriteNullAnimationFrame

SpriteNullAnimationFrame:
	db 0

; might be closer to "screen specific data" than map data
MapDataPointers: ; 80e5d (20:4e5d)
	dw Tilemaps
	dw Tilesets
	dw Sprites
	dw SpriteAnimations
	dw Palettes

; \1 = pointer
; \2 = tileset
tilemap: MACRO
	dwb \1, BANK(\1) - BANK(Tilemaps)
	db \2
ENDM

Tilemaps: ; 80e67 (20:4e67)
	tilemap OverworldMapTilemap,               TILESET_OVERWORLD_MAP               ; TILEMAP_OVERWORLD_MAP
	tilemap OverworldMapCGBTilemap,            TILESET_OVERWORLD_MAP               ; TILEMAP_OVERWORLD_MAP_CGB
	tilemap MasonLaboratoryTilemap,            TILESET_MASON_LABORATORY            ; TILEMAP_MASON_LABORATORY
	tilemap MasonLaboratoryCGBTilemap,         TILESET_MASON_LABORATORY            ; TILEMAP_MASON_LABORATORY_CGB
	tilemap ChallengeMachineMapEventTilemap,   TILESET_MASON_LABORATORY            ; TILEMAP_CHALLENGE_MACHINE_MAP_EVENT
	tilemap ChallengeMachineMapEventCGBTilemap,TILESET_MASON_LABORATORY            ; TILEMAP_CHALLENGE_MACHINE_MAP_EVENT_CGB
	tilemap DeckMachineRoomTilemap,            TILESET_MASON_LABORATORY            ; TILEMAP_DECK_MACHINE_ROOM
	tilemap DeckMachineRoomCGBTilemap,         TILESET_MASON_LABORATORY            ; TILEMAP_DECK_MACHINE_ROOM_CGB
	tilemap DeckMachineMapEventTilemap,        TILESET_MASON_LABORATORY            ; TILEMAP_DECK_MACHINE_MAP_EVENT
	tilemap DeckMachineMapEventCGBTilemap,     TILESET_MASON_LABORATORY            ; TILEMAP_DECK_MACHINE_MAP_EVENT_CGB
	tilemap IshiharaTilemap,                   TILESET_ISHIHARA                    ; TILEMAP_ISHIHARA
	tilemap IshiharaCGBTilemap,                TILESET_ISHIHARA                    ; TILEMAP_ISHIHARA_CGB
	tilemap FightingClubEntranceTilemap,       TILESET_CLUB_ENTRANCE               ; TILEMAP_FIGHTING_CLUB_ENTRANCE
	tilemap FightingClubEntranceCGBTilemap,    TILESET_CLUB_ENTRANCE               ; TILEMAP_FIGHTING_CLUB_ENTRANCE_CGB
	tilemap RockClubEntranceTilemap,           TILESET_CLUB_ENTRANCE               ; TILEMAP_ROCK_CLUB_ENTRANCE
	tilemap RockClubEntranceCGBTilemap,        TILESET_CLUB_ENTRANCE               ; TILEMAP_ROCK_CLUB_ENTRANCE_CGB
	tilemap WaterClubEntranceTilemap,          TILESET_CLUB_ENTRANCE               ; TILEMAP_WATER_CLUB_ENTRANCE
	tilemap WaterClubEntranceCGBTilemap,       TILESET_CLUB_ENTRANCE               ; TILEMAP_WATER_CLUB_ENTRANCE_CGB
	tilemap LightningClubEntranceTilemap,      TILESET_CLUB_ENTRANCE               ; TILEMAP_LIGHTNING_CLUB_ENTRANCE
	tilemap LightningClubEntranceCGBTilemap,   TILESET_CLUB_ENTRANCE               ; TILEMAP_LIGHTNING_CLUB_ENTRANCE_CGB
	tilemap GrassClubEntranceTilemap,          TILESET_CLUB_ENTRANCE               ; TILEMAP_GRASS_CLUB_ENTRANCE
	tilemap GrassClubEntranceCGBTilemap,       TILESET_CLUB_ENTRANCE               ; TILEMAP_GRASS_CLUB_ENTRANCE_CGB
	tilemap PsychicClubEntranceTilemap,        TILESET_CLUB_ENTRANCE               ; TILEMAP_PSYCHIC_CLUB_ENTRANCE
	tilemap PsychicClubEntranceCGBTilemap,     TILESET_CLUB_ENTRANCE               ; TILEMAP_PSYCHIC_CLUB_ENTRANCE_CGB
	tilemap ScienceClubEntranceTilemap,        TILESET_CLUB_ENTRANCE               ; TILEMAP_SCIENCE_CLUB_ENTRANCE
	tilemap ScienceClubEntranceCGBTilemap,     TILESET_CLUB_ENTRANCE               ; TILEMAP_SCIENCE_CLUB_ENTRANCE_CGB
	tilemap FireClubEntranceTilemap,           TILESET_CLUB_ENTRANCE               ; TILEMAP_FIRE_CLUB_ENTRANCE
	tilemap FireClubEntranceCGBTilemap,        TILESET_CLUB_ENTRANCE               ; TILEMAP_FIRE_CLUB_ENTRANCE_CGB
	tilemap ChallengeHallEntranceTilemap,      TILESET_CLUB_ENTRANCE               ; TILEMAP_CHALLENGE_HALL_ENTRANCE
	tilemap ChallengeHallEntranceCGBTilemap,   TILESET_CLUB_ENTRANCE               ; TILEMAP_CHALLENGE_HALL_ENTRANCE_CGB
	tilemap ClubLobbyTilemap,                  TILESET_CLUB_LOBBY                  ; TILEMAP_CLUB_LOBBY
	tilemap ClubLobbyCGBTilemap,               TILESET_CLUB_LOBBY                  ; TILEMAP_CLUB_LOBBY_CGB
	tilemap FightingClubTilemap,               TILESET_FIGHTING_CLUB               ; TILEMAP_FIGHTING_CLUB
	tilemap FightingClubCGBTilemap,            TILESET_FIGHTING_CLUB               ; TILEMAP_FIGHTING_CLUB_CGB
	tilemap RockClubTilemap,                   TILESET_ROCK_CLUB                   ; TILEMAP_ROCK_CLUB
	tilemap RockClubCGBTilemap,                TILESET_ROCK_CLUB                   ; TILEMAP_ROCK_CLUB_CGB
	tilemap WaterClubTilemap,                  TILESET_WATER_CLUB                  ; TILEMAP_WATER_CLUB
	tilemap WaterClubCGBTilemap,               TILESET_WATER_CLUB                  ; TILEMAP_WATER_CLUB_CGB
	tilemap LightningClubTilemap,              TILESET_LIGHTNING_CLUB              ; TILEMAP_LIGHTNING_CLUB
	tilemap LightningClubCGBTilemap,           TILESET_LIGHTNING_CLUB              ; TILEMAP_LIGHTNING_CLUB_CGB
	tilemap GrassClubTilemap,                  TILESET_GRASS_CLUB                  ; TILEMAP_GRASS_CLUB
	tilemap GrassClubCGBTilemap,               TILESET_GRASS_CLUB                  ; TILEMAP_GRASS_CLUB_CGB
	tilemap PsychicClubTilemap,                TILESET_PSYCHIC_CLUB                ; TILEMAP_PSYCHIC_CLUB
	tilemap PsychicClubCGBTilemap,             TILESET_PSYCHIC_CLUB                ; TILEMAP_PSYCHIC_CLUB_CGB
	tilemap ScienceClubTilemap,                TILESET_SCIENCE_CLUB                ; TILEMAP_SCIENCE_CLUB
	tilemap ScienceClubCGBTilemap,             TILESET_SCIENCE_CLUB                ; TILEMAP_SCIENCE_CLUB_CGB
	tilemap FireClubTilemap,                   TILESET_FIRE_CLUB                   ; TILEMAP_FIRE_CLUB
	tilemap FireClubCGBTilemap,                TILESET_FIRE_CLUB                   ; TILEMAP_FIRE_CLUB_CGB
	tilemap ChallengeHallTilemap,              TILESET_CHALLENGE_HALL              ; TILEMAP_CHALLENGE_HALL
	tilemap ChallengeHallCGBTilemap,           TILESET_CHALLENGE_HALL              ; TILEMAP_CHALLENGE_HALL_CGB
	tilemap PokemonDomeEntranceTilemap,        TILESET_POKEMON_DOME_ENTRANCE       ; TILEMAP_POKEMON_DOME_ENTRANCE
	tilemap PokemonDomeEntranceCGBTilemap,     TILESET_POKEMON_DOME_ENTRANCE       ; TILEMAP_POKEMON_DOME_ENTRANCE_CGB
	tilemap PokemonDomeDoorMapEventTilemap,    TILESET_POKEMON_DOME_ENTRANCE       ; TILEMAP_POKEMON_DOME_DOOR_MAP_EVENT
	tilemap PokemonDomeDoorMapEventCGBTilemap, TILESET_POKEMON_DOME_ENTRANCE       ; TILEMAP_POKEMON_DOME_DOOR_MAP_EVENT_CGB
	tilemap PokemonDomeTilemap,                TILESET_POKEMON_DOME                ; TILEMAP_POKEMON_DOME
	tilemap PokemonDomeCGBTilemap,             TILESET_POKEMON_DOME                ; TILEMAP_POKEMON_DOME_CGB
	tilemap HallOfHonorDoorMapEventTilemap,    TILESET_POKEMON_DOME                ; TILEMAP_HALL_OF_HONOR_DOOR_MAP_EVENT
	tilemap HallOfHonorDoorMapEventCGBTilemap, TILESET_POKEMON_DOME                ; TILEMAP_HALL_OF_HONOR_DOOR_MAP_EVENT_CGB
	tilemap HallOfHonorTilemap,                TILESET_HALL_OF_HONOR               ; TILEMAP_HALL_OF_HONOR
	tilemap HallOfHonorCGBTilemap,             TILESET_HALL_OF_HONOR               ; TILEMAP_HALL_OF_HONOR_CGB
	tilemap CardPopCGBTilemap,                 TILESET_CARD_POP                    ; TILEMAP_CARD_POP_CGB
	tilemap CardPopTilemap,                    TILESET_CARD_POP                    ; TILEMAP_CARD_POP
	tilemap GrassMedalTilemap,                 TILESET_MEDAL                       ; TILEMAP_GRASS_MEDAL
	tilemap ScienceMedalTilemap,               TILESET_MEDAL                       ; TILEMAP_SCIENCE_MEDAL
	tilemap FireMedalTilemap,                  TILESET_MEDAL                       ; TILEMAP_FIRE_MEDAL
	tilemap WaterMedalTilemap,                 TILESET_MEDAL                       ; TILEMAP_WATER_MEDAL
	tilemap LightningMedalTilemap,             TILESET_MEDAL                       ; TILEMAP_LIGHTNING_MEDAL
	tilemap FightingMedalTilemap,              TILESET_MEDAL                       ; TILEMAP_FIGHTING_MEDAL
	tilemap RockMedalTilemap,                  TILESET_MEDAL                       ; TILEMAP_ROCK_MEDAL
	tilemap PsychicMedalTilemap,               TILESET_MEDAL                       ; TILEMAP_PSYCHIC_MEDAL
	tilemap GameBoyLinkCGBTilemap,             TILESET_GAMEBOY_LINK                ; TILEMAP_GAMEBOY_LINK_CGB
	tilemap GameBoyLinkTilemap,                TILESET_GAMEBOY_LINK                ; TILEMAP_GAMEBOY_LINK
	tilemap GameBoyLinkConnectingCGBTilemap,   TILESET_GAMEBOY_LINK                ; TILEMAP_GAMEBOY_LINK_CONNECTING_CGB
	tilemap GameBoyLinkConnectingTilemap,      TILESET_GAMEBOY_LINK                ; TILEMAP_GAMEBOY_LINK_CONNECTING
	tilemap GameBoyPrinterCGBTilemap,          TILESET_GAMEBOY_PRINTER             ; TILEMAP_GAMEBOY_PRINTER_CGB
	tilemap GameBoyPrinterTilemap,             TILESET_GAMEBOY_PRINTER             ; TILEMAP_GAMEBOY_PRINTER
	tilemap ColosseumTilemap,                  TILESET_COLOSSEUM_1                 ; TILEMAP_COLOSSEUM
	tilemap ColosseumCGBTilemap,               TILESET_COLOSSEUM_2                 ; TILEMAP_COLOSSEUM_CGB
	tilemap EvolutionTilemap,                  TILESET_EVOLUTION_1                 ; TILEMAP_EVOLUTION
	tilemap EvolutionCGBTilemap,               TILESET_EVOLUTION_2                 ; TILEMAP_EVOLUTION_CGB
	tilemap MysteryTilemap,                    TILESET_MYSTERY_1                   ; TILEMAP_MYSTERY
	tilemap MysteryCGBTilemap,                 TILESET_MYSTERY_2                   ; TILEMAP_MYSTERY_CGB
	tilemap LaboratoryTilemap,                 TILESET_LABORATORY_1                ; TILEMAP_LABORATORY
	tilemap LaboratoryCGBTilemap,              TILESET_LABORATORY_2                ; TILEMAP_LABORATORY_CGB
	tilemap CharizardIntroTilemap,             TILESET_CHARIZARD_INTRO_1           ; TILEMAP_CHARIZARD_INTRO
	tilemap CharizardIntroCGBTilemap,          TILESET_CHARIZARD_INTRO_2           ; TILEMAP_CHARIZARD_INTRO_CGB
	tilemap ScytherIntroTilemap,               TILESET_SCYTHER_INTRO_1             ; TILEMAP_SCYTHER_INTRO
	tilemap ScytherIntroCGBTilemap,            TILESET_SCYTHER_INTRO_2             ; TILEMAP_SCYTHER_INTRO_CGB
	tilemap AerodactylIntroTilemap,            TILESET_AERODACTYL_INTRO_1          ; TILEMAP_AERODACTYL_INTRO
	tilemap AerodactylIntroCGBTilemap,         TILESET_AERODACTYL_INTRO_2          ; TILEMAP_AERODACTYL_INTRO_CGB
	tilemap JapaneseTitleScreenTilemap,        TILESET_JAPANESE_TITLE_SCREEN       ; TILEMAP_JAPANESE_TITLE_SCREEN
	tilemap JapaneseTitleScreenCGBTilemap,     TILESET_JAPANESE_TITLE_SCREEN_CGB   ; TILEMAP_JAPANESE_TITLE_SCREEN_CGB
	tilemap SolidTiles1Tilemap,                TILESET_SOLID_TILES_1               ; TILEMAP_SOLID_TILES_1
	tilemap SolidTiles2Tilemap,                TILESET_SOLID_TILES_1               ; TILEMAP_SOLID_TILES_2
	tilemap SolidTiles3Tilemap,                TILESET_SOLID_TILES_1               ; TILEMAP_SOLID_TILES_3
	tilemap JapaneseTitleScreen2Tilemap,       TILESET_JAPANESE_TITLE_SCREEN_2     ; TILEMAP_JAPANESE_TITLE_SCREEN_2
	tilemap JapaneseTitleScreen2CGBTilemap,    TILESET_JAPANESE_TITLE_SCREEN_2_CGB ; TILEMAP_JAPANESE_TITLE_SCREEN_2_CGB
	tilemap SolidTiles4Tilemap,                TILESET_SOLID_TILES_2               ; TILEMAP_SOLID_TILES_4
	tilemap PlayerTilemap,                     TILESET_PLAYER                      ; TILEMAP_PLAYER
	tilemap OpponentTilemap,                   TILESET_RONALD                      ; TILEMAP_OPPONENT
	tilemap TitleScreenTilemap,                TILESET_TITLE_SCREEN                ; TILEMAP_TITLE_SCREEN
	tilemap TitleScreenCGBTilemap,             TILESET_TITLE_SCREEN_CGB            ; TILEMAP_TITLE_SCREEN_CGB
	tilemap CopyrightTilemap,                  TILESET_COPYRIGHT                   ; TILEMAP_COPYRIGHT
	tilemap CopyrightCGBTilemap,               TILESET_COPYRIGHT                   ; TILEMAP_COPYRIGHT_CGB
	tilemap NintendoTilemap,                   TILESET_NINTENDO                    ; TILEMAP_NINTENDO
	tilemap CompaniesTilemap,                  TILESET_COMPANIES                   ; TILEMAP_COMPANIES

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
	tileset JapaneseTitleScreenGfx,         97 ; TILESET_JAPANESE_TITLE_SCREEN
	tileset JapaneseTitleScreenCGBGfx,      97 ; TILESET_JAPANESE_TITLE_SCREEN_CGB
	tileset SolidTiles1,                     4 ; TILESET_SOLID_TILES_1
	tileset JapaneseTitleScreen2Gfx,       244 ; TILESET_JAPANESE_TITLE_SCREEN_2
	tileset JapaneseTitleScreen2CGBGfx,     59 ; TILESET_JAPANESE_TITLE_SCREEN_2_CGB
	tileset SolidTiles2,                     4 ; TILESET_SOLID_TILES_2
	tileset PlayerGfx,                      36 ; TILESET_PLAYER
	tileset RonaldGfx,                      36 ; TILESET_RONALD
	tileset TitleScreenGfx,                220 ; TILESET_TITLE_SCREEN
	tileset TitleScreenCGBGfx,             212 ; TILESET_TITLE_SCREEN_CGB
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
	dwb \1, BANK(\1) - BANK(Sprites)
	db \2
ENDM

Sprites: ; 8116b (20:516b)
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
	dwb \1, BANK(\1) - BANK(SpriteAnimations)
	db $00 ; unused (padding?)
ENDM

SpriteAnimations: ; 81333 (20:5333)
	anim_data_pointer AnimData0   ; SPRITE_ANIM_LIGHT_NPC_UP
	anim_data_pointer AnimData1   ; SPRITE_ANIM_LIGHT_NPC_RIGHT
	anim_data_pointer AnimData2   ; SPRITE_ANIM_LIGHT_NPC_DOWN
	anim_data_pointer AnimData3   ; SPRITE_ANIM_LIGHT_NPC_LEFT
	anim_data_pointer AnimData4   ; SPRITE_ANIM_DARK_NPC_UP
	anim_data_pointer AnimData5   ; SPRITE_ANIM_DARK_NPC_RIGHT
	anim_data_pointer AnimData6   ; SPRITE_ANIM_DARK_NPC_DOWN
	anim_data_pointer AnimData7   ; SPRITE_ANIM_DARK_NPC_LEFT
	anim_data_pointer AnimData8   ; SPRITE_ANIM_SGB_AMY_LAYING
	anim_data_pointer AnimData9   ; SPRITE_ANIM_SGB_AMY_STAND
	anim_data_pointer AnimData10  ; SPRITE_ANIM_SGB_CLERK_NPC_UP
	anim_data_pointer AnimData11  ; SPRITE_ANIM_SGB_CLERK_NPC_RIGHT
	anim_data_pointer AnimData12  ; SPRITE_ANIM_SGB_CLERK_NPC_DOWN
	anim_data_pointer AnimData13  ; SPRITE_ANIM_SGB_CLERK_NPC_LEFT
	anim_data_pointer AnimData14  ; SPRITE_ANIM_BLUE_NPC_UP
	anim_data_pointer AnimData15  ; SPRITE_ANIM_BLUE_NPC_RIGHT
	anim_data_pointer AnimData16  ; SPRITE_ANIM_BLUE_NPC_DOWN
	anim_data_pointer AnimData17  ; SPRITE_ANIM_BLUE_NPC_LEFT
	anim_data_pointer AnimData18  ; SPRITE_ANIM_PINK_NPC_UP
	anim_data_pointer AnimData19  ; SPRITE_ANIM_PINK_NPC_RIGHT
	anim_data_pointer AnimData20  ; SPRITE_ANIM_PINK_NPC_DOWN
	anim_data_pointer AnimData21  ; SPRITE_ANIM_PINK_NPC_LEFT
	anim_data_pointer AnimData22  ; SPRITE_ANIM_YELLOW_NPC_UP
	anim_data_pointer AnimData23  ; SPRITE_ANIM_YELLOW_NPC_RIGHT
	anim_data_pointer AnimData24  ; SPRITE_ANIM_YELLOW_NPC_DOWN
	anim_data_pointer AnimData25  ; SPRITE_ANIM_YELLOW_NPC_LEFT
	anim_data_pointer AnimData26  ; SPRITE_ANIM_GREEN_NPC_UP
	anim_data_pointer AnimData27  ; SPRITE_ANIM_GREEN_NPC_RIGHT
	anim_data_pointer AnimData28  ; SPRITE_ANIM_GREEN_NPC_DOWN
	anim_data_pointer AnimData29  ; SPRITE_ANIM_GREEN_NPC_LEFT
	anim_data_pointer AnimData30  ; SPRITE_ANIM_RED_NPC_UP
	anim_data_pointer AnimData31  ; SPRITE_ANIM_RED_NPC_RIGHT
	anim_data_pointer AnimData32  ; SPRITE_ANIM_RED_NPC_DOWN
	anim_data_pointer AnimData33  ; SPRITE_ANIM_RED_NPC_LEFT
	anim_data_pointer AnimData34  ; SPRITE_ANIM_PURPLE_NPC_UP
	anim_data_pointer AnimData35  ; SPRITE_ANIM_PURPLE_NPC_RIGHT
	anim_data_pointer AnimData36  ; SPRITE_ANIM_PURPLE_NPC_DOWN
	anim_data_pointer AnimData37  ; SPRITE_ANIM_PURPLE_NPC_LEFT
	anim_data_pointer AnimData38  ; SPRITE_ANIM_WHITE_NPC_UP
	anim_data_pointer AnimData39  ; SPRITE_ANIM_WHITE_NPC_RIGHT
	anim_data_pointer AnimData40  ; SPRITE_ANIM_WHITE_NPC_DOWN
	anim_data_pointer AnimData41  ; SPRITE_ANIM_WHITE_NPC_LEFT
	anim_data_pointer AnimData42  ; SPRITE_ANIM_INDIGO_NPC_UP
	anim_data_pointer AnimData43  ; SPRITE_ANIM_INDIGO_NPC_RIGHT
	anim_data_pointer AnimData44  ; SPRITE_ANIM_INDIGO_NPC_DOWN
	anim_data_pointer AnimData45  ; SPRITE_ANIM_INDIGO_NPC_LEFT
	anim_data_pointer AnimData46  ; SPRITE_ANIM_CGB_AMY_LAYING
	anim_data_pointer AnimData47  ; SPRITE_ANIM_CGB_AMY_STAND
	anim_data_pointer AnimData48  ; SPRITE_ANIM_CGB_CLERK_NPC_UP
	anim_data_pointer AnimData49  ; SPRITE_ANIM_CGB_CLERK_NPC_RIGHT
	anim_data_pointer AnimData50  ; SPRITE_ANIM_CGB_CLERK_NPC_DOWN
	anim_data_pointer AnimData51  ; SPRITE_ANIM_CGB_CLERK_NPC_LEFT
	anim_data_pointer AnimData52  ; SPRITE_ANIM_SGB_VOLCANO_SMOKE
	anim_data_pointer AnimData53  ; SPRITE_ANIM_SGB_OWMAP_CURSOR
	anim_data_pointer AnimData54  ; SPRITE_ANIM_SGB_OWMAP_CURSOR_FAST
	anim_data_pointer AnimData55  ; SPRITE_ANIM_CGB_VOLCANO_SMOKE
	anim_data_pointer AnimData56  ; SPRITE_ANIM_CGB_OWMAP_CURSOR
	anim_data_pointer AnimData57  ; SPRITE_ANIM_CGB_OWMAP_CURSOR_FAST
	anim_data_pointer AnimData58  ; SPRITE_ANIM_TORCH
	anim_data_pointer AnimData59  ; SPRITE_ANIM_SGB_CARD_TOP_LEFT
	anim_data_pointer AnimData60  ; SPRITE_ANIM_SGB_CARD_TOP_RIGHT
	anim_data_pointer AnimData61  ; SPRITE_ANIM_SGB_CARD_LEFT_SPARK
	anim_data_pointer AnimData62  ; SPRITE_ANIM_SGB_CARD_BOTTOM_LEFT
	anim_data_pointer AnimData63  ; SPRITE_ANIM_SGB_CARD_BOTTOM_RIGHT
	anim_data_pointer AnimData64  ; SPRITE_ANIM_SGB_CARD_RIGHT_SPARK
	anim_data_pointer AnimData65  ; SPRITE_ANIM_CGB_CARD_TOP_LEFT
	anim_data_pointer AnimData66  ; SPRITE_ANIM_CGB_CARD_TOP_RIGHT
	anim_data_pointer AnimData67  ; SPRITE_ANIM_CGB_CARD_LEFT_SPARK
	anim_data_pointer AnimData68  ; SPRITE_ANIM_CGB_CARD_BOTTOM_LEFT
	anim_data_pointer AnimData69  ; SPRITE_ANIM_CGB_CARD_BOTTOM_RIGHT
	anim_data_pointer AnimData70  ; SPRITE_ANIM_CGB_CARD_RIGHT_SPARK
	anim_data_pointer AnimData71  ; SPRITE_ANIM_71
	anim_data_pointer AnimData72  ; SPRITE_ANIM_72
	anim_data_pointer AnimData73  ; SPRITE_ANIM_73
	anim_data_pointer AnimData74  ; SPRITE_ANIM_74
	anim_data_pointer AnimData75  ; SPRITE_ANIM_75
	anim_data_pointer AnimData76  ; SPRITE_ANIM_76
	anim_data_pointer AnimData77  ; SPRITE_ANIM_77
	anim_data_pointer AnimData78  ; SPRITE_ANIM_78
	anim_data_pointer AnimData79  ; SPRITE_ANIM_79
	anim_data_pointer AnimData80  ; SPRITE_ANIM_80
	anim_data_pointer AnimData81  ; SPRITE_ANIM_81
	anim_data_pointer AnimData82  ; SPRITE_ANIM_82
	anim_data_pointer AnimData83  ; SPRITE_ANIM_83
	anim_data_pointer AnimData84  ; SPRITE_ANIM_84
	anim_data_pointer AnimData85  ; SPRITE_ANIM_85
	anim_data_pointer AnimData86  ; SPRITE_ANIM_86
	anim_data_pointer AnimData87  ; SPRITE_ANIM_87
	anim_data_pointer AnimData88  ; SPRITE_ANIM_88
	anim_data_pointer AnimData89  ; SPRITE_ANIM_89
	anim_data_pointer AnimData90  ; SPRITE_ANIM_90
	anim_data_pointer AnimData91  ; SPRITE_ANIM_91
	anim_data_pointer AnimData92  ; SPRITE_ANIM_92
	anim_data_pointer AnimData93  ; SPRITE_ANIM_93
	anim_data_pointer AnimData94  ; SPRITE_ANIM_94
	anim_data_pointer AnimData95  ; SPRITE_ANIM_95
	anim_data_pointer AnimData96  ; SPRITE_ANIM_96
	anim_data_pointer AnimData97  ; SPRITE_ANIM_97
	anim_data_pointer AnimData98  ; SPRITE_ANIM_98
	anim_data_pointer AnimData99  ; SPRITE_ANIM_99
	anim_data_pointer AnimData100 ; SPRITE_ANIM_100
	anim_data_pointer AnimData101 ; SPRITE_ANIM_101
	anim_data_pointer AnimData102 ; SPRITE_ANIM_102
	anim_data_pointer AnimData103 ; SPRITE_ANIM_103
	anim_data_pointer AnimData104 ; SPRITE_ANIM_104
	anim_data_pointer AnimData105 ; SPRITE_ANIM_105
	anim_data_pointer AnimData106 ; SPRITE_ANIM_106
	anim_data_pointer AnimData107 ; SPRITE_ANIM_107
	anim_data_pointer AnimData108 ; SPRITE_ANIM_108
	anim_data_pointer AnimData109 ; SPRITE_ANIM_109
	anim_data_pointer AnimData110 ; SPRITE_ANIM_110
	anim_data_pointer AnimData111 ; SPRITE_ANIM_111
	anim_data_pointer AnimData112 ; SPRITE_ANIM_112
	anim_data_pointer AnimData113 ; SPRITE_ANIM_113
	anim_data_pointer AnimData114 ; SPRITE_ANIM_114
	anim_data_pointer AnimData115 ; SPRITE_ANIM_115
	anim_data_pointer AnimData116 ; SPRITE_ANIM_116
	anim_data_pointer AnimData117 ; SPRITE_ANIM_117
	anim_data_pointer AnimData118 ; SPRITE_ANIM_118
	anim_data_pointer AnimData119 ; SPRITE_ANIM_119
	anim_data_pointer AnimData120 ; SPRITE_ANIM_120
	anim_data_pointer AnimData121 ; SPRITE_ANIM_121
	anim_data_pointer AnimData122 ; SPRITE_ANIM_122
	anim_data_pointer AnimData123 ; SPRITE_ANIM_123
	anim_data_pointer AnimData124 ; SPRITE_ANIM_124
	anim_data_pointer AnimData125 ; SPRITE_ANIM_125
	anim_data_pointer AnimData126 ; SPRITE_ANIM_126
	anim_data_pointer AnimData127 ; SPRITE_ANIM_127
	anim_data_pointer AnimData128 ; SPRITE_ANIM_128
	anim_data_pointer AnimData129 ; SPRITE_ANIM_129
	anim_data_pointer AnimData130 ; SPRITE_ANIM_130
	anim_data_pointer AnimData131 ; SPRITE_ANIM_131
	anim_data_pointer AnimData132 ; SPRITE_ANIM_132
	anim_data_pointer AnimData133 ; SPRITE_ANIM_133
	anim_data_pointer AnimData134 ; SPRITE_ANIM_134
	anim_data_pointer AnimData135 ; SPRITE_ANIM_135
	anim_data_pointer AnimData136 ; SPRITE_ANIM_136
	anim_data_pointer AnimData137 ; SPRITE_ANIM_137
	anim_data_pointer AnimData138 ; SPRITE_ANIM_138
	anim_data_pointer AnimData139 ; SPRITE_ANIM_139
	anim_data_pointer AnimData140 ; SPRITE_ANIM_140
	anim_data_pointer AnimData141 ; SPRITE_ANIM_141
	anim_data_pointer AnimData142 ; SPRITE_ANIM_142
	anim_data_pointer AnimData143 ; SPRITE_ANIM_143
	anim_data_pointer AnimData144 ; SPRITE_ANIM_144
	anim_data_pointer AnimData145 ; SPRITE_ANIM_145
	anim_data_pointer AnimData146 ; SPRITE_ANIM_146
	anim_data_pointer AnimData147 ; SPRITE_ANIM_147
	anim_data_pointer AnimData148 ; SPRITE_ANIM_148
	anim_data_pointer AnimData149 ; SPRITE_ANIM_149
	anim_data_pointer AnimData150 ; SPRITE_ANIM_150
	anim_data_pointer AnimData151 ; SPRITE_ANIM_151
	anim_data_pointer AnimData152 ; SPRITE_ANIM_152
	anim_data_pointer AnimData153 ; SPRITE_ANIM_153
	anim_data_pointer AnimData154 ; SPRITE_ANIM_154
	anim_data_pointer AnimData155 ; SPRITE_ANIM_155
	anim_data_pointer AnimData156 ; SPRITE_ANIM_156
	anim_data_pointer AnimData157 ; SPRITE_ANIM_157
	anim_data_pointer AnimData158 ; SPRITE_ANIM_158
	anim_data_pointer AnimData159 ; SPRITE_ANIM_159
	anim_data_pointer AnimData160 ; SPRITE_ANIM_160
	anim_data_pointer AnimData161 ; SPRITE_ANIM_161
	anim_data_pointer AnimData162 ; SPRITE_ANIM_162
	anim_data_pointer AnimData163 ; SPRITE_ANIM_163
	anim_data_pointer AnimData164 ; SPRITE_ANIM_164
	anim_data_pointer AnimData165 ; SPRITE_ANIM_165
	anim_data_pointer AnimData166 ; SPRITE_ANIM_166
	anim_data_pointer AnimData167 ; SPRITE_ANIM_167
	anim_data_pointer AnimData168 ; SPRITE_ANIM_168
	anim_data_pointer AnimData169 ; SPRITE_ANIM_169
	anim_data_pointer AnimData170 ; SPRITE_ANIM_170
	anim_data_pointer AnimData171 ; SPRITE_ANIM_171
	anim_data_pointer AnimData172 ; SPRITE_ANIM_172
	anim_data_pointer AnimData173 ; SPRITE_ANIM_173
	anim_data_pointer AnimData174 ; SPRITE_ANIM_174
	anim_data_pointer AnimData175 ; SPRITE_ANIM_175
	anim_data_pointer AnimData176 ; SPRITE_ANIM_176
	anim_data_pointer AnimData177 ; SPRITE_ANIM_177
	anim_data_pointer AnimData178 ; SPRITE_ANIM_178
	anim_data_pointer AnimData179 ; SPRITE_ANIM_179
	anim_data_pointer AnimData180 ; SPRITE_ANIM_180
	anim_data_pointer AnimData181 ; SPRITE_ANIM_181
	anim_data_pointer AnimData182 ; SPRITE_ANIM_182
	anim_data_pointer AnimData183 ; SPRITE_ANIM_183
	anim_data_pointer AnimData184 ; SPRITE_ANIM_184
	anim_data_pointer AnimData185 ; SPRITE_ANIM_185
	anim_data_pointer AnimData186 ; SPRITE_ANIM_186
	anim_data_pointer AnimData187 ; SPRITE_ANIM_187
	anim_data_pointer AnimData188 ; SPRITE_ANIM_188
	anim_data_pointer AnimData189 ; SPRITE_ANIM_189
	anim_data_pointer AnimData190 ; SPRITE_ANIM_190
	anim_data_pointer AnimData191 ; SPRITE_ANIM_191
	anim_data_pointer AnimData192 ; SPRITE_ANIM_192
	anim_data_pointer AnimData193 ; SPRITE_ANIM_193
	anim_data_pointer AnimData194 ; SPRITE_ANIM_194
	anim_data_pointer AnimData195 ; SPRITE_ANIM_195
	anim_data_pointer AnimData196 ; SPRITE_ANIM_196
	anim_data_pointer AnimData197 ; SPRITE_ANIM_197
	anim_data_pointer AnimData198 ; SPRITE_ANIM_198
	anim_data_pointer AnimData199 ; SPRITE_ANIM_199
	anim_data_pointer AnimData200 ; SPRITE_ANIM_200
	anim_data_pointer AnimData201 ; SPRITE_ANIM_201
	anim_data_pointer AnimData202 ; SPRITE_ANIM_202
	anim_data_pointer AnimData203 ; SPRITE_ANIM_203
	anim_data_pointer AnimData204 ; SPRITE_ANIM_204
	anim_data_pointer AnimData205 ; SPRITE_ANIM_205
	anim_data_pointer AnimData206 ; SPRITE_ANIM_206
	anim_data_pointer AnimData207 ; SPRITE_ANIM_207
	anim_data_pointer AnimData208 ; SPRITE_ANIM_208
	anim_data_pointer AnimData209 ; SPRITE_ANIM_209
	anim_data_pointer AnimData210 ; SPRITE_ANIM_210
	anim_data_pointer AnimData211 ; SPRITE_ANIM_211
	anim_data_pointer AnimData212 ; SPRITE_ANIM_212
	anim_data_pointer AnimData213 ; SPRITE_ANIM_213
	anim_data_pointer AnimData214 ; SPRITE_ANIM_214
	anim_data_pointer AnimData215 ; SPRITE_ANIM_215
	anim_data_pointer AnimData216 ; SPRITE_ANIM_216

; \1 = palette pointer
; \2 = number of palettes
; \3 = number of OBJ colors
palette_pointer: MACRO
	dwb \1, BANK(\1) - BANK(Palettes)
	db (\2 << 4) + \3
ENDM

Palettes: ; 81697 (20:5697)
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
	dw NULL
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/overworld_map.bin"

OverworldMapCGBTilemap:: ; 81a22 (20:5a22)
	db $14 ; width
	db $12 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/overworld_map_cgb.bin"

MasonLaboratoryTilemap:: ; 81c13 (20:5c13)
	db $1c ; width
	db $1e ; height
	dw MasonLaboratoryPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/mason_laboratory.bin"
MasonLaboratoryPermissions:
	INCBIN "data/maps/permissions/mason_laboratory.bin"

MasonLaboratoryCGBTilemap:: ; 81d2e (20:5d2e)
	db $1c ; width
	db $1e ; height
	dw MasonLaboratoryCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/mason_laboratory_cgb.bin"
MasonLaboratoryCGBPermissions:
	INCBIN "data/maps/permissions/mason_laboratory_cgb.bin"

ChallengeMachineMapEventTilemap:: ; 81ed1 (20:5ed1)
	db $04 ; width
	db $06 ; height
	dw ChallengeMachineMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/challenge_machine_map_event.bin"
ChallengeMachineMapEventPermissions:
	INCBIN "data/maps/permissions/challenge_machine_map_event.bin"

ChallengeMachineMapEventCGBTilemap:: ; 81ef5 (20:5ef5)
	db $04 ; width
	db $06 ; height
	dw ChallengeMachineMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/challenge_machine_map_event_cgb.bin"
ChallengeMachineMapEventCGBPermissions:
	INCBIN "data/maps/permissions/challenge_machine_map_event_cgb.bin"

DeckMachineRoomTilemap:: ; 81f26 (20:5f26)
	db $18 ; width
	db $1e ; height
	dw DeckMachineRoomPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_room.bin"
DeckMachineRoomPermissions:
	INCBIN "data/maps/permissions/deck_machine_room.bin"

DeckMachineRoomCGBTilemap:: ; 81feb (20:5feb)
	db $18 ; width
	db $1e ; height
	dw DeckMachineRoomCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_room_cgb.bin"
DeckMachineRoomCGBPermissions:
	INCBIN "data/maps/permissions/deck_machine_room_cgb.bin"

DeckMachineMapEventTilemap:: ; 82143 (20:6143)
	db $04 ; width
	db $01 ; height
	dw DeckMachineMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_map_event.bin"
DeckMachineMapEventPermissions:
	INCBIN "data/maps/permissions/deck_machine_map_event.bin"

DeckMachineMapEventCGBTilemap:: ; 82150 (20:6150)
	db $04 ; width
	db $01 ; height
	dw DeckMachineMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/deck_machine_map_event_cgb.bin"
DeckMachineMapEventCGBPermissions:
	INCBIN "data/maps/permissions/deck_machine_map_event_cgb.bin"

IshiharaTilemap:: ; 82160 (20:6160)
	db $14 ; width
	db $18 ; height
	dw IshiharaPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/ishihara.bin"
IshiharaPermissions:
	INCBIN "data/maps/permissions/ishihara.bin"

IshiharaCGBTilemap:: ; 82222 (20:6222)
	db $14 ; width
	db $18 ; height
	dw IshiharaCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/ishihara_cgb.bin"
IshiharaCGBPermissions:
	INCBIN "data/maps/permissions/ishihara_cgb.bin"

FightingClubEntranceTilemap:: ; 82336 (20:6336)
	db $14 ; width
	db $12 ; height
	dw FightingClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club_entrance.bin"
FightingClubEntrancePermissions:
	INCBIN "data/maps/permissions/fighting_club_entrance.bin"

FightingClubEntranceCGBTilemap:: ; 82400 (20:6400)
	db $14 ; width
	db $12 ; height
	dw FightingClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club_entrance_cgb.bin"
FightingClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/fighting_club_entrance_cgb.bin"

RockClubEntranceTilemap:: ; 8251d (20:651d)
	db $14 ; width
	db $12 ; height
	dw RockClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/rock_club_entrance.bin"
RockClubEntrancePermissions:
	INCBIN "data/maps/permissions/rock_club_entrance.bin"

RockClubEntranceCGBTilemap:: ; 825e7 (20:65e7)
	db $14 ; width
	db $12 ; height
	dw RockClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/rock_club_entrance_cgb.bin"
RockClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/rock_club_entrance_cgb.bin"

WaterClubEntranceTilemap:: ; 82704 (20:6704)
	db $14 ; width
	db $12 ; height
	dw WaterClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/water_club_entrance.bin"
WaterClubEntrancePermissions:
	INCBIN "data/maps/permissions/water_club_entrance.bin"

WaterClubEntranceCGBTilemap:: ; 827ce (20:67ce)
	db $14 ; width
	db $12 ; height
	dw WaterClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/water_club_entrance_cgb.bin"
WaterClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/water_club_entrance_cgb.bin"

LightningClubEntranceTilemap:: ; 828eb (20:68eb)
	db $14 ; width
	db $12 ; height
	dw LightningClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/lightning_club_entrance.bin"
LightningClubEntrancePermissions:
	INCBIN "data/maps/permissions/lightning_club_entrance.bin"

LightningClubEntranceCGBTilemap:: ; 829b5 (20:69b5)
	db $14 ; width
	db $12 ; height
	dw LightningClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/lightning_club_entrance_cgb.bin"
LightningClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/lightning_club_entrance_cgb.bin"

GrassClubEntranceTilemap:: ; 82ad2 (20:6ad2)
	db $14 ; width
	db $12 ; height
	dw GrassClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/grass_club_entrance.bin"
GrassClubEntrancePermissions:
	INCBIN "data/maps/permissions/grass_club_entrance.bin"

GrassClubEntranceCGBTilemap:: ; 82b9c (20:6b9c)
	db $14 ; width
	db $12 ; height
	dw GrassClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/grass_club_entrance_cgb.bin"
GrassClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/grass_club_entrance_cgb.bin"

PsychicClubEntranceTilemap:: ; 82cb9 (20:6cb9)
	db $14 ; width
	db $12 ; height
	dw PsychicClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/psychic_club_entrance.bin"
PsychicClubEntrancePermissions:
	INCBIN "data/maps/permissions/psychic_club_entrance.bin"

PsychicClubEntranceCGBTilemap:: ; 82d83 (20:6d83)
	db $14 ; width
	db $12 ; height
	dw PsychicClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/psychic_club_entrance_cgb.bin"
PsychicClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/psychic_club_entrance_cgb.bin"

ScienceClubEntranceTilemap:: ; 82ea0 (20:6ea0)
	db $14 ; width
	db $12 ; height
	dw ScienceClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/science_club_entrance.bin"
ScienceClubEntrancePermissions:
	INCBIN "data/maps/permissions/science_club_entrance.bin"

ScienceClubEntranceCGBTilemap:: ; 82f6a (20:6f6a)
	db $14 ; width
	db $12 ; height
	dw ScienceClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/science_club_entrance_cgb.bin"
ScienceClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/science_club_entrance_cgb.bin"

FireClubEntranceTilemap:: ; 83087 (20:7087)
	db $14 ; width
	db $12 ; height
	dw FireClubEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fire_club_entrance.bin"
FireClubEntrancePermissions:
	INCBIN "data/maps/permissions/fire_club_entrance.bin"

FireClubEntranceCGBTilemap:: ; 83151 (20:7151)
	db $14 ; width
	db $12 ; height
	dw FireClubEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fire_club_entrance_cgb.bin"
FireClubEntranceCGBPermissions:
	INCBIN "data/maps/permissions/fire_club_entrance_cgb.bin"

ChallengeHallEntranceTilemap:: ; 8326e (20:726e)
	db $14 ; width
	db $12 ; height
	dw ChallengeHallEntrancePermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/challenge_hall_entrance.bin"
ChallengeHallEntrancePermissions:
	INCBIN "data/maps/permissions/challenge_hall_entrance.bin"

ChallengeHallEntranceCGBTilemap:: ; 83321 (20:7321)
	db $14 ; width
	db $12 ; height
	dw ChallengeHallEntranceCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/challenge_hall_entrance_cgb.bin"
ChallengeHallEntranceCGBPermissions:
	INCBIN "data/maps/permissions/challenge_hall_entrance_cgb.bin"

ClubLobbyTilemap:: ; 83424 (20:7424)
	db $1c ; width
	db $1a ; height
	dw ClubLobbyPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/club_lobby.bin"
ClubLobbyPermissions:
	INCBIN "data/maps/permissions/club_lobby.bin"

ClubLobbyCGBTilemap:: ; 83545 (20:7545)
	db $1c ; width
	db $1a ; height
	dw ClubLobbyCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/club_lobby_cgb.bin"
ClubLobbyCGBPermissions:
	INCBIN "data/maps/permissions/club_lobby_cgb.bin"

FightingClubTilemap:: ; 836db (20:76db)
	db $18 ; width
	db $12 ; height
	dw FightingClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club.bin"
FightingClubPermissions:
	INCBIN "data/maps/permissions/fighting_club.bin"

FightingClubCGBTilemap:: ; 8378c (20:778c)
	db $18 ; width
	db $12 ; height
	dw FightingClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/fighting_club_cgb.bin"
FightingClubCGBPermissions:
	INCBIN "data/maps/permissions/fighting_club_cgb.bin"

RockClubTilemap:: ; 8388d (20:788d)
	db $1c ; width
	db $1e ; height
	dw RockClubPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/rock_club.bin"
RockClubPermissions:
	INCBIN "data/maps/permissions/rock_club.bin"

RockClubCGBTilemap:: ; 839d6 (20:79d6)
	db $1c ; width
	db $1e ; height
	dw RockClubCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/rock_club_cgb.bin"
RockClubCGBPermissions:
	INCBIN "data/maps/permissions/rock_club_cgb.bin"

PokemonDomeDoorMapEventTilemap:: ; 83bf1 (20:7bf1)
	db $04 ; width
	db $03 ; height
	dw PokemonDomeDoorMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome_door_map_event.bin"
PokemonDomeDoorMapEventPermissions:
	INCBIN "data/maps/permissions/pokemon_dome_door_map_event.bin"

PokemonDomeDoorMapEventCGBTilemap:: ; 83c03 (20:7c03)
	db $04 ; width
	db $03 ; height
	dw PokemonDomeDoorMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/pokemon_dome_door_map_event_cgb.bin"
PokemonDomeDoorMapEventCGBPermissions:
	INCBIN "data/maps/permissions/pokemon_dome_door_map_event_cgb.bin"

HallOfHonorDoorMapEventTilemap:: ; 83c1a (20:7c1a)
	db $04 ; width
	db $03 ; height
	dw HallOfHonorDoorMapEventPermissions
	db FALSE ; cgb mode
	INCBIN "data/maps/tiles/hall_of_honor_door_map_event.bin"
HallOfHonorDoorMapEventPermissions:
	INCBIN "data/maps/permissions/hall_of_honor_door_map_event.bin"

HallOfHonorDoorMapEventCGBTilemap:: ; 83c26 (20:7c26)
	db $04 ; width
	db $03 ; height
	dw HallOfHonorDoorMapEventCGBPermissions
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/hall_of_honor_door_map_event_cgb.bin"
HallOfHonorDoorMapEventCGBPermissions:
	INCBIN "data/maps/permissions/hall_of_honor_door_map_event_cgb.bin"

GrassMedalTilemap:: ; 83c36 (20:7c36)
	db $03 ; width
	db $03 ; height
	dw NULL
	db TRUE ; cgb mode
	INCBIN "data/maps/tiles/grass_medal.bin"

AnimData1:: ; 83c4c (20:7c4c)
	frame_table AnimFrameTable0
	frame_data 3, 16, 0, 0
	frame_data 4, 16, 0, 0
	frame_data 0, 0, 0, 0

Palette110:: ; 83c5b (20:7c5b)
	db $00, $00
