; initializes variables used to decompress data in DecompressData
; de = source of compressed data
; b = HIGH byte of secondary buffer ($100 bytes of buffer space)
; also clears this $100 byte space
InitDataDecompression::
	ld hl, wDecompSourcePosPtr
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wDecompNumCommandBitsLeft
	ld [hl], 1
	inc hl
	xor a
	ld [hli], a ; wDecompCommandByte
	ld [hli], a ; wDecompRepeatModeToggle
	ld [hli], a ; wDecompRepeatLengths
	ld [hli], a ; wDecompNumBytesToRepeat
	ld [hl], b  ; wDecompSecondaryBufferPtrHigh
	inc hl
	ld [hli], a ; wDecompRepeatSeqOffset
	ld [hl], LOW(wDecompressionSecondaryBufferStart) ; wDecompSecondaryBufferPtrLow

; clear buffer
	ld h, b
	ld l, LOW(wDecompressionSecondaryBuffer)
	xor a
.loop
	ld [hl], a
	inc l
	jr nz, .loop
	ret

; decompresses data
; uses values initialized by InitDataDecompression
; wDecompSourcePosPtr holds the pointer for compressed source
; input:
; bc = buffer length
; de = buffer to place decompressed data
DecompressData::
	push hl
	push de
.loop
	push bc
	call .Decompress
	ld [de], a
	inc de
	pop bc
	dec bc
	ld a, c
	or b
	jr nz, .loop
	pop de
	pop hl
	ret

; decompression works as follows:
; first a command byte is read that will dictate how the
; following bytes will be copied
; the position will then move to the next byte (0xXX), and
; the command byte's bits are read from higher to lower bit
; - if command bit is set, then copy 0xXX to buffer;
; - if command bit is not set, then decompression enters "repeat mode,"
; which means it stores 0xXX in memory as number of bytes to repeat
; from a given offset. This offset is in the next byte in the data,
; 0xYZ, which tells the offset to start repeating. A toggle is switched
; each time the algorithm hits "repeat mode":
;  - if off -> on it reads 0xYZ and stores it,
;  then repeats (0x0Y + 2) bytes from the offset starting at 0xXX;
;  - if on -> off, then the data only provides the offset,
;  and the previous byte read for number of bytes to repeat, 0xYZ, is reused
;  in which case (0x0Z + 2) bytes are repeated starting from the offset.
.Decompress::
	ld hl, wDecompNumBytesToRepeat
	ld a, [hl]
	or a
	jr z, .read_command

; still repeating sequence
	dec [hl]
	inc hl
.repeat_byte
	ld b, [hl] ; wDecompSecondaryBufferPtrHigh
	inc hl
	ld c, [hl] ; wDecompRepeatSeqOffset
	inc [hl]
	inc hl
	ld a, [bc]
	ld c, [hl] ; wDecompSecondaryBufferPtrLow
	inc [hl]
	ld [bc], a
	ret

.read_command
	ld hl, wDecompSourcePosPtr
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl ; wDecompNumCommandBitsLeft
	dec [hl]
	inc hl ; wDecompCommandByte
	jr nz, .read_command_bit
	dec hl ; wDecompNumCommandBitsLeft
	ld [hl], 8 ; number of bits
	inc hl ; wDecompCommandByte
	ld a, [bc]
	inc bc
	ld [hl], a
.read_command_bit
	rl [hl]
	ld a, [bc]
	inc bc
	jr nc, .repeat_command

; copy 1 byte literally
	ld hl, wDecompSourcePosPtr
	ld [hl], c
	inc hl
	ld [hl], b
	ld hl, wDecompSecondaryBufferPtrHigh
	ld b, [hl]
	inc hl
	inc hl
	ld c, [hl] ; wDecompSecondaryBufferPtrLow
	inc [hl]
	ld [bc], a
	ret

.repeat_command
	ld [wDecompRepeatSeqOffset], a ; save the offset to repeat from
	ld hl, wDecompRepeatModeToggle
	bit 0, [hl]
	jr nz, .repeat_mode_toggle_on
	set 0, [hl]
	inc hl
; read byte for num of bytes to read
; and use its higher nybble
	ld a, [bc]
	inc bc
	ld [hli], a ; wDecompRepeatLengths
	swap a
.get_sequence_len
	and $f
	inc a ; number of times to repeat
	ld [hli], a ; wDecompNumBytesToRepeat
	push hl
	ld hl, wDecompSourcePosPtr
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	jr .repeat_byte

.repeat_mode_toggle_on
; get the previous byte (num of bytes to repeat)
; and use its lower nybble
	res 0, [hl]
	inc hl
	ld a, [hli] ; wDecompRepeatLengths
	jr .get_sequence_len
