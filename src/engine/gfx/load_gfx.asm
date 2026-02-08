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
	ld hl, TILEMAP_WIDTH
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

; l - GFXTABLE_* constant (banks 0,1,2,3,4)
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
	ld l, GFXTABLE_TILESETS
	ld a, [wCurTileset]
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
	ld a, [hl]
	ld [wTotalNumTiles], a
	ld a, TILE_SIZE
	ld [wCurSpriteTileSize], a
	xor a
	ld [wWhichVRAMBank], a ; VRAM0
	ld a, $80
	ld [wVRAMTileOffset], a
	call LoadGfxDataFromTempPointerToVRAMBank_Tiles0ToTiles2
	pop hl
	ret

; loads graphics data from third map data pointers
; input:
; a = sprite index within the data map
; output:
; a = number of tiles in sprite
LoadSpriteGfx:
	push hl
	ld l, GFXTABLE_SPRITES
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
; to the VRAM bank according to wWhichVRAMBank, in address pointed by wVRAMPointer
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
; switches VRAM according to wWhichVRAMBank
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

; if bottom bit in wWhichVRAMBank is not set = VRAM0
; if bottom bit in wWhichVRAMBank is set     = VRAM1
	ld a, [wWhichVRAMBank]
	and $1
	call BankswitchVRAM
	ret

; converts wVRAMTileOffset to address in VRAM
; and stores it in wVRAMPointer
; switches VRAM according to wWhichVRAMBank
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
	ld l, GFXTABLE_TILESETS
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

	lb bc, BANK("VRAM0"), LOW(v0Tiles2 / TILE_SIZE) ; $00
	call .CopyGfxData
	jr z, .done
	lb bc, BANK("VRAM0"), LOW(v0Tiles1 / TILE_SIZE) ; $80
	call .CopyGfxData
	jr z, .done
	; VRAM1 only used in CGB console
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .done
	lb bc, BANK("VRAM1"), LOW(v1Tiles2 / TILE_SIZE) ; $00
	call .CopyGfxData
	jr z, .done
	lb bc, BANK("VRAM1"), LOW(v1Tiles1 / TILE_SIZE) ; $80
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
; b must match with VRAM bank in wWhichVRAMBank
; prepares next call to this routine if data wasn't fully copied
; so that it copies to the right VRAM section
.CopyGfxData
	push hl
	push bc
	push de
	ld a, [wWhichVRAMBank]
	cp b
	jr nz, .skip
	ld a, [wVRAMTileOffset]
	ld d, a
	xor c
	bit 7, a
	jr nz, .skip

; (wWhichVRAMBank == b) and
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
	ld a, [wWhichVRAMBank]
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
	; then set wWhichVRAMBank for VRAM1
	ld a, [hl] ; wWhichVRAMBank
	adc 0
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
	ld l, GFXTABLE_TILEMAPS
	ld a, [wCurTilemap]
	call GetMapDataPointer
	call LoadGraphicsPointerFromHL
	ld a, [hl]
	ld [wCurTileset], a
	ret

; loads background palette (PALETTE_*) given in a
; each palette has data for DMG BGP and for CGB RGB palettes
; DMG:
; - if palette has BGP data, load it
; CGB:
; - load palette starting from background palette index [wWhichBGPalIndex]
LoadBGPalette:
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
	ld a, [wWhichBGPalIndex]
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

; loads object palette (PALETTE_*) given in a
; each palette has data for DMG OBP and for CGB RGB palettes
; DMG:
; - if [wWhichOBP] is 1, then load to OBP1, otherwise start load to OBP0
; CGB:
; - load palette starting from object palette index [wWhichOBPalIndex]
LoadOBPalette:
	push hl
	push bc
	push de
	call LoadPaletteDataToBuffer

	ld hl, wLoadedPalData
	ld a, [hli] ; number palettes
	ld c, a
	or a
	jr z, .check_palette_size

	ld a, [wWhichOBP]
	cp 1
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
	ld a, [wWhichOBPalIndex]
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
	ld l, GFXTABLE_PALETTES
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
