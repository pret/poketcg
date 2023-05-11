_HandleMapWarp::
	push hl
	push bc
	push de
	ld a, [wCurMap]
	add a
	ld c, a
	ld b, $0
	ld hl, WarpDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $5
	ld a, [wPlayerXCoord]
	ld d, a
	ld a, [wPlayerYCoord]
	ld e, a
.loop_warp_list
	ld a, [hli]
	or [hl]
	jr z, .done ; end of warp data
	ld a, [hld] ; y coord
	cp e
	jr nz, .next_warp
	ld a, [hl] ; x coord
	cp d
	jr z, .warp_player
.next_warp
	add hl, bc
	jr .loop_warp_list
.warp_player
	inc hl
	inc hl
	ld a, [hli]
	ld [wTempMap], a
	ld a, [hli]
	ld [wTempPlayerXCoord], a
	ld a, [hli]
	ld [wTempPlayerYCoord], a
	ld a, [wPlayerDirection]
	ld [wTempPlayerDirection], a
.done
	pop de
	pop bc
	pop hl
	ret

INCLUDE "data/warps.asm"
