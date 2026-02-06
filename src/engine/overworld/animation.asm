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
