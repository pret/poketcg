; convert two-digit BCD number in a to text (ascii) format,
; and write it to wStringBuffer and BGMap0 address at bc
WriteTwoDigitBCDNumber::
	push hl
	push bc
	push de
	ld hl, wStringBuffer
	push hl
	push bc
	call WriteBCDNumberInTextFormat
	pop bc
	call BCCoordToBGMap0Address
	pop hl
	ld b, 2
	call JPHblankCopyDataHLtoDE
	pop de
	pop bc
	pop hl
	ret

; convert one-digit BCD number in the lower nybble of a to text (ascii) format,
; and write it to wStringBuffer and BGMap0 address at bc
WriteOneDigitBCDNumber::
	push hl
	push bc
	push de
	ld hl, wStringBuffer
	push hl
	push bc
	call WriteBCDDigitInTextFormat
	pop bc
	call BCCoordToBGMap0Address
	pop hl
	ld b, 1
	call JPHblankCopyDataHLtoDE
	pop de
	pop bc
	pop hl
	ret

; convert four-digit BCD number in hl to text (ascii) format,
; and write it to wStringBuffer and BGMap0 address at bc
WriteFourDigitBCDNumber::
	push hl
	push bc
	push de
	ld e, l
	ld d, h
	ld hl, wStringBuffer
	push hl
	push bc
	ld a, d
	call WriteBCDNumberInTextFormat
	ld a, e
	call WriteBCDNumberInTextFormat
	pop bc
	call BCCoordToBGMap0Address
	pop hl
	ld b, 4
	call JPHblankCopyDataHLtoDE
	pop de
	pop bc
	pop hl
	ret

; given two BCD digits in the two nybbles of register a,
; write them in text (ascii) format to hl (most significant nybble first).
; numbers above 9 end up converted to half-width font tiles.
WriteBCDNumberInTextFormat::
	push af
	swap a
	call WriteBCDDigitInTextFormat
	pop af
;	fallthrough

; given a BCD digit in the (lower nybble) of register a, write it in text (ascii)
;  format to hl. numbers above 9 end up converted to half-width font tiles.
WriteBCDDigitInTextFormat::
	and $0f
	add '0'
	cp '9' + 1
	jr c, .write_num
	add $07
.write_num
	ld [hli], a
	ret

; convert one-byte number in a to text (ascii) format,
; and write it to [wStringBuffer] and BGMap0 address at bc
WriteOneByteNumber::
	push bc
	push hl
	ld l, a
	ld h, $00
	ld de, wStringBuffer
	push de
	push bc
	ld bc, -100
	call TwoByteNumberToText.get_digit
	ld bc, -10
	call TwoByteNumberToText.get_digit
	ld bc, -1
	call TwoByteNumberToText.get_digit
	pop bc
	call BCCoordToBGMap0Address
	pop hl
	ld b, 3
	call JPHblankCopyDataHLtoDE
	pop hl
	pop bc
	ret

; convert two-byte number in hl to text (ascii) format,
; and write it to wStringBuffer and BGMap0 address at bc
WriteTwoByteNumber::
	push bc
	ld de, wStringBuffer
	push de
	call TwoByteNumberToText
	call BCCoordToBGMap0Address
	pop hl
	ld b, 5
	call JPHblankCopyDataHLtoDE
	pop bc
	ret

; convert two-byte number in hl to text (ascii) format and write it to de
TwoByteNumberToText::
	push bc
	ld bc, -10000
	call .get_digit
	ld bc, -1000
	call .get_digit
	ld bc, -100
	call .get_digit
	ld bc, -10
	call .get_digit
	ld bc, -1
	call .get_digit
	xor a ; TX_END
	ld [de], a
	pop bc
	ret
.get_digit
	ld a, '0' - 1
.subtract_loop
	inc a
	add hl, bc
	jr c, .subtract_loop
	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret
