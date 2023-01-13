; reads structs:
;   x (1 byte), y (1 byte), data (n bytes), $00
;   x (1 byte), y (1 byte), data (n bytes), $00
;   ...
;   $ff
; for each struct, writes data to BGMap0-translated x,y
WriteDataBlocksToBGMap0::
	call WriteDataBlockToBGMap0
	bit 7, [hl] ; check for $ff
	jr z, WriteDataBlocksToBGMap0
	ret

; reads struct:
;   x (1 byte), y (1 byte), data (n bytes), $00
; writes data to BGMap0-translated x,y
WriteDataBlockToBGMap0::
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	push hl ; hl = addr of data
	push bc ; b,c = x,y
	ld b, -1
.find_zero_loop
	inc b
	ld a, [hli]
	or a
	jr nz, .find_zero_loop
	ld a, b ; length of data
	pop bc ; x,y
	push af
	call BCCoordToBGMap0Address
	pop af
	ld b, a ; length of data
	pop hl ; addr of data
	or a
	jr z, .move_to_next
	push bc
	push hl
	call SafeCopyDataHLtoDE ; copy data to de (BGMap0 translated x,y)
	pop hl
	pop bc

.move_to_next
	inc b ; length of data += 1 (to account for the last $0)
	ld c, b
	ld b, 0
	add hl, bc ; point to next structure
	ret

; writes a to [v*BGMap0 + BG_MAP_WIDTH * c + b]
WriteByteToBGMap0::
	push af
	ld a, [wLCDC]
	rla
	jr c, .lcd_on
	pop af
	push hl
	push de
	push bc
	push af
	call BCCoordToBGMap0Address
	pop af
	ld [de], a
	pop bc
	pop de
	pop hl
	ret
.lcd_on
	pop af
;	fallthrough

; writes a to [v*BGMap0 + BG_MAP_WIDTH * c + b] during hblank
HblankWriteByteToBGMap0::
	push hl
	push de
	push bc
	ld hl, wTempByte
	push hl
	ld [hl], a
	call BCCoordToBGMap0Address
	pop hl
	ld b, 1
	call HblankCopyDataHLtoDE
	pop bc
	pop de
	pop hl
	ret

; copy a bytes of data from hl to vBGMap0 address pointed to by coord at bc
CopyDataToBGMap0::
	push bc
	push hl
	push af
	call BCCoordToBGMap0Address
	pop af
	ld b, a
	pop hl
	call SafeCopyDataHLtoDE
	pop bc
	ret

; copy b bytes of data from hl to de
; if LCD on, copy during h-blank only
SafeCopyDataHLtoDE::
	ld a, [wLCDC]
	rla
	jr c, JPHblankCopyDataHLtoDE
.lcd_off_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .lcd_off_loop
	ret
JPHblankCopyDataHLtoDE::
	jp HblankCopyDataHLtoDE
