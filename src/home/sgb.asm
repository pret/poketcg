; setup SNES memory $810-$867 and palette
InitSGB::
	ld hl, MaskEnPacket_Freeze
	call SendSGB
	ld hl, DataSndPacket1
	call SendSGB
	ld hl, DataSndPacket2
	call SendSGB
	ld hl, DataSndPacket3
	call SendSGB
	ld hl, DataSndPacket4
	call SendSGB
	ld hl, DataSndPacket5
	call SendSGB
	ld hl, DataSndPacket6
	call SendSGB
	ld hl, DataSndPacket7
	call SendSGB
	ld hl, DataSndPacket8
	call SendSGB
	ld hl, Pal01Packet_InitSGB
	call SendSGB
	ld hl, MaskEnPacket_Cancel
	call SendSGB
	ret

DataSndPacket1::
	sgb DATA_SND, 1 ; sgb_command, length
	dwb $085d, $00 ; destination address, bank
	db $0b ; number of bytes to write
	db $8c, $d0, $f4, $60, $00, $00, $00, $00, $00, $00, $00 ; data bytes

DataSndPacket2::
	sgb DATA_SND, 1 ; sgb_command, length
	dwb $0852, $00 ; destination address, bank
	db $0b ; number of bytes to write
	db $a9, $e7, $9f, $01, $c0, $7e, $e8, $e8, $e8, $e8, $e0 ; data bytes

DataSndPacket3::
	sgb DATA_SND, 1 ; sgb_command, length
	dwb $0847, $00 ; destination address, bank
	db $0b ; number of bytes to write
	db $c4, $d0, $16, $a5, $cb, $c9, $05, $d0, $10, $a2, $28 ; data bytes

DataSndPacket4::
	sgb DATA_SND, 1 ; sgb_command, length
	dwb $083c, $00 ; destination address, bank
	db $0b ; number of bytes to write
	db $f0, $12, $a5, $c9, $c9, $c8, $d0, $1c, $a5, $ca, $c9 ; data bytes

DataSndPacket5::
	sgb DATA_SND, 1 ; sgb_command, length
	dwb $0831, $00 ; destination address, bank
	db $0b ; number of bytes to write
	db $0c, $a5, $ca, $c9, $7e, $d0, $06, $a5, $cb, $c9, $7e ; data bytes

DataSndPacket6::
	sgb DATA_SND, 1 ; sgb_command, length
	dwb $0826, $00 ; destination address, bank
	db $0b ; number of bytes to write
	db $39, $cd, $48, $0c, $d0, $34, $a5, $c9, $c9, $80, $d0 ; data bytes

DataSndPacket7::
	sgb DATA_SND, 1 ; sgb_command, length
	dwb $081b, $00 ; destination address, bank
	db $0b ; number of bytes to write
	db $ea, $ea, $ea, $ea, $ea, $a9, $01, $cd, $4f, $0c, $d0 ; data bytes

DataSndPacket8::
	sgb DATA_SND, 1 ; sgb_command, length
	dwb $0810, $00 ; destination address, bank
	db $0b ; number of bytes to write
	db $4c, $20, $08, $ea, $ea, $ea, $ea, $ea, $60, $ea, $ea ; data bytes

MaskEnPacket_Freeze::
	sgb MASK_EN, 1 ; sgb_command, length
	db MASK_EN_FREEZE_SCREEN
	ds $0e

MaskEnPacket_Cancel::
	sgb MASK_EN, 1 ; sgb_command, length
	db MASK_EN_CANCEL_MASK
	ds $0e

Pal01Packet_InitSGB::
	sgb PAL01, 1 ; sgb_command, length
	rgb 28, 28, 24
	rgb 20, 20, 16
	rgb 8, 8, 8
	rgb 0, 0, 0
	rgb 31, 0, 0
	rgb 15, 0, 0
	rgb 7, 0, 0
	db $00

Pal23Packet_0b00::
	sgb PAL23, 1 ; sgb_command, length
	rgb 0, 31, 0
	rgb 0, 15, 0
	rgb 0, 7, 0
	rgb 0, 0, 0
	rgb 0, 0, 31
	rgb 0, 0, 15
	rgb 0, 0, 7
	db $00

AttrBlkPacket_0b10::
	sgb ATTR_BLK, 1 ; sgb_command, length
	db 1 ; number of data sets
	; Control Code, Color Palette Designation, X1, Y1, X2, Y2
	db ATTR_BLK_CTRL_INSIDE + ATTR_BLK_CTRL_LINE, 1 << 0 + 2 << 2, 5, 5, 10, 10 ; data set 1
	ds 6 ; data set 2
	ds 2 ; data set 3

; send SGB packet at hl (or packets, if length > 1)
SendSGB::
	ld a, [hl]
	and $7
	ret z ; return if packet length is 0
	ld b, a ; length (1-7)
	ld c, LOW(rJOYP)
.send_packets_loop
	push bc
	ld a, $0
	ld [$ff00+c], a
	ld a, P15 | P14
	ld [$ff00+c], a
	ld b, SGB_PACKET_SIZE
.send_packet_loop
	ld e, $8
	ld a, [hli]
	ld d, a
.read_byte_loop
	bit 0, d
	ld a, P14 ; '1' bit
	jr nz, .transfer_bit
	ld a, P15 ; '0' bit
.transfer_bit
	ld [$ff00+c], a
	ld a, P15 | P14
	ld [$ff00+c], a
	rr d
	dec e
	jr nz, .read_byte_loop
	dec b
	jr nz, .send_packet_loop
	ld a, P15 ; stop bit
	ld [$ff00+c], a
	ld a, P15 | P14
	ld [$ff00+c], a
	pop bc
	dec b
	jr nz, .send_packets_loop
	ld bc, 4
	call Wait
	ret

; SGB hardware detection
; return carry if SGB detected and disable multi-controller mode before returning
DetectSGB::
	ld bc, 60
	call Wait
	ld hl, MltReq2Packet
	call SendSGB
	ldh a, [rJOYP]
	and %11
	cp SNES_JOYPAD1
	jr nz, .sgb
	ld a, P15
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ld a, P15 | P14
	ldh [rJOYP], a
	ld a, P14
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ld a, P15 | P14
	ldh [rJOYP], a
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	ldh a, [rJOYP]
	and %11
	cp SNES_JOYPAD1
	jr nz, .sgb
	ld hl, MltReq1Packet
	call SendSGB
	or a
	ret
.sgb
	ld hl, MltReq1Packet
	call SendSGB
	scf
	ret

MltReq1Packet::
	sgb MLT_REQ, 1 ; sgb_command, length
	db MLT_REQ_1_PLAYER
	ds $0e

MltReq2Packet::
	sgb MLT_REQ, 1 ; sgb_command, length
	db MLT_REQ_2_PLAYERS
	ds $0e

; fill v*Tiles1 and v*Tiles2 with data at hl
; write $0d sequences of $80,$81,$82,...,$94 separated each by $0c bytes to v*BGMap0
; send the SGB packet at de
Func_0bcb::
	di
	push de
.wait_vblank
	ldh a, [rLY]
	cp LY_VBLANK + 3
	jr nz, .wait_vblank
	ld a, LCDC_BGON | LCDC_OBJON | LCDC_WIN9C00
	ldh [rLCDC], a
	ld a, %11100100
	ldh [rBGP], a
	ld de, v0Tiles1
	ld bc, v0BGMap0 - v0Tiles1
.tiles_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .tiles_loop
	ld hl, v0BGMap0
	ld de, $000c
	ld a, $80
	ld c, $0d
.bgmap_outer_loop
	ld b, $14
.bgmap_inner_loop
	ld [hli], a
	inc a
	dec b
	jr nz, .bgmap_inner_loop
	add hl, de
	dec c
	jr nz, .bgmap_outer_loop
	ld a, LCDC_BGON | LCDC_OBJON | LCDC_WIN9C00 | LCDC_ON
	ldh [rLCDC], a
	pop hl
	call SendSGB
	ei
	ret

; loops 63000 * bc cycles (~15 * bc ms)
Wait::
	ld de, 1750
.loop
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, .loop
	dec bc
	ld a, b
	or c
	jr nz, Wait
	ret
