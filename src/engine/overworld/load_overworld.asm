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
	ld [wWhichVRAMBank], a
	call LoadTilesetGfx

	xor a
	ld [wWhichOBP], a ; not used
	ld a, [wd291]
	ld [wWhichBGPalIndex], a
	ld a, [wCurMapInitialPalette]
	call LoadBGPalette
	ld a, [wd291]
	ld [wWhichBGPalIndex], a
	ld a, [wCurMapPalette]
	or a
	jr z, .asm_80076
	call LoadBGPalette
.asm_80076
	ret
