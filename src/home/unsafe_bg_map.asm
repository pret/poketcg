; reads struct:
;   x (1 byte), y (1 byte), data (n bytes), $00
; writes data to BGMap0-translated x,y
; important: make sure VRAM can be accessed first, else use WriteDataBlockToBGMap0
UnsafeWriteDataBlockToBGMap0::
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	call BCCoordToBGMap0Address
	jr .next
.loop
	ld [de], a
	inc de
.next
	ld a, [hli]
	or a
	jr nz, .loop
	ret
