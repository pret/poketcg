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
