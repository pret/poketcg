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
