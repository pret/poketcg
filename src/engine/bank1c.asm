Func_70000: ; 70000 (1c:4000)
	ld a, [wConsole]
	cp $1
	ret nz
	ld b, $1
	ld a, $22
	farcall GetEventFlagValue
	or a
	jr z, .asm_70013
	ld b, $2
.asm_70013
	ld a, b
	call Func_70044
	ret

Func_70018: ; 70018 (1c:4018)
	ld a, [wConsole]
	cp $1
	ret nz
	ld a, $0
	call Func_70044
	ret

AtrcEnPacket_Disable: ; 70024 (1c:4024)
	sgb ATRC_EN, 1 ; sgb_command, length
	db 1
	ds $0e

; disable Controller Set-up Screen
IconEnPacket: ; 70034 (1c:4034)
	sgb ICON_EN, 3 ; sgb_command, length
	db $01
	ds $0e

Func_70044: ; 70044 (1c:4044)
	push hl
	push bc
	add a
	ld c, a
	add a
	add c
	ld c, a
	ld b, $0
	ld hl, Unknown_70057
	add hl, bc
	call Func_70082
	pop bc
	pop hl
	ret

Unknown_70057: ; 70057 (1c:4057)
	INCROM $70057, $70082

Func_70082: ; 70082 (1c:4082)
	ld a, [wConsole]
	cp $1
	ret nz
	push hl
	push bc
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call Func_700a3
	pop hl
	inc hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_700fe
	call Func_701c0
	pop bc
	pop hl
	ret

Func_700a3: ; 700a3 (1c:40a3)
	push hl
	push bc
	push de
	push hl
	call Func_70136
	pop hl
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, v0Tiles1
	call Func_701e9
	call Func_701fe
	ld hl, ChrTrnPacket_BGTiles1
	call Func_70177
	pop hl
	ld de, $0002
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	or [hl]
	jr z, .asm_700da
	call Func_70136
	dec hl
	ld de, v0Tiles1
	call Func_701e9
	ld hl, ChrTrnPacket_BGTiles2
	call Func_70177
.asm_700da
	pop de
	pop bc
	pop hl
	ret

; CHR_TRN: tiles $00-$7F, BG (border) tiles (from SNES $000-$FFF)
ChrTrnPacket_BGTiles1: ; 700de (1c:40de)
	sgb CHR_TRN, 1 ; sgb_command, length
	db 0
	ds $0e

; CHR_TRN: tiles $80-$FF, BG (border) tiles (from SNES $000-$FFF)
ChrTrnPacket_BGTiles2: ; 700ee (1c:40ee)
	sgb CHR_TRN, 1 ; sgb_command, length
	db 1
	ds $0e

Func_700fe: ; 700fe (1c:40fe)
	push hl
	push bc
	push de
	push hl
	push de
	push hl
	call Func_70136
	pop hl
	ld de, v0Tiles1
	call Func_701e9
	pop hl
	ld de, v0Tiles2
	call Func_701e9
	call Func_701fe
	pop hl
	call Func_70214
	ld hl, PctTrnPacket
	call Func_70177
	pop de
	pop bc
	pop hl
	ret

; PCT_TRN: read tile map & palette data into VRAM (from SNES $000-$87F)
PctTrnPacket: ; 70126 (1c:4126)
	sgb PCT_TRN, 1 ; sgb_command, length
	ds $0f

Func_70136: ; 70136 (1c:4136)
	push hl
	push bc
	push de
	ldh a, [hSCX]
	ld [wd41d], a
	ldh a, [hSCY]
	ld [wd41e], a
	ld a, [wBGP]
	ld [wd41f], a
	ld a, [wLCDC]
	ld [wd420], a
	di
	ld hl, MaskEnPacket_Freeze_Bank1c
	call SendSGB
	call DisableLCD
	ld a, [wLCDC]
	and LCDC_BGENABLE | LCDC_WINSELECT
	or LCDC_BGON
	ld [wLCDC], a
	ld a, %11100100
	ldh [rBGP], a
	call SetBGP
	xor a
	ldh [hSCX], a
	ldh [rSCX], a
	ldh [hSCY], a
	ldh [rSCY], a
	pop de
	pop bc
	pop hl
	ret

Func_70177: ; 70177 (1c:4177)
	push hl
	push bc
	push de
	push hl
	call EnableLCD
	pop hl
	call SendSGB
	ld a, [wd41d]
	ldh [hSCX], a
	ld a, [wd41e]
	ldh [hSCY], a
	ld a, [wd41f]
	call SetBGP
	ld a, [wd420]
	ld [wLCDC], a
	call DisableLCD
	ei
	pop de
	pop bc
	pop hl
	ret

; MASK_EN on
MaskEnPacket_Freeze_Bank1c: ; 701a0 (1c:41a0)
	sgb MASK_EN, 1 ; sgb_command, length
	db MASK_EN_FREEZE_SCREEN
	ds $0e

; MASK_EN off
MaskEnPacket_Cancel_Bank1c: ; 701b0 (1c:41b0)
	sgb MASK_EN, 1 ; sgb_command, length
	db MASK_EN_CANCEL_MASK
	ds $0e

Func_701c0: ; 701c0 (1c:41c0)
	push hl
	push bc
	call DisableLCD
	xor a
	ld c, $10
	ld hl, v0Tiles2
.asm_701cb
	ld [hli], a
	dec c
	jr nz, .asm_701cb
	ld a, [wTileMapFill]
	push af
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	pop af
	ld [wTileMapFill], a
	di
	ld hl, MaskEnPacket_Cancel_Bank1c
	call SendSGB
	ei
	pop bc
	pop hl
	ret

Func_701e9: ; 701e9 (1c:41e9)
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	or c
	ret z
	push de
	push bc
	ld e, l
	ld d, h
	ld b, HIGH(wc000)
	call InitBGMapDecompression
	pop bc
	pop de
	call DecompressBGMap
	ret

Func_701fe: ; 701fe (1c:41fe)
	ld hl, v0BGMap0
	ld de, $000c
	ld a, $80
	ld c, $d
.asm_70208
	ld b, $14
.asm_7020a
	ld [hli], a
	inc a
	dec b
	jr nz, .asm_7020a
	add hl, de
	dec c
	jr nz, .asm_70208
	ret

Func_70214: ; 70214 (1c:4214)
	ld a, l
	cp $dc
	ret nz
	ld a, h
	cp $49
	ret nz
	ld hl, Unknown_7024a
	ld a, $10
	farcall GetEventFlagValue
	ld c, $8
.asm_70227
	push bc
	push hl
	push af
	bit 7, a
	jr z, .asm_7023e
	ld c, $9
.asm_70230
	push bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop bc
	dec c
	jr nz, .asm_70230
.asm_7023e
	pop af
	rlca
	pop hl
	ld bc, $0024
	add hl, bc
	pop bc
	dec c
	jr nz, .asm_70227
	ret

Unknown_7024a: ; 7024a (1c:424a)
	INCROM $7024a, $7036a

; decompresses palette data depending on wd132
; then sends it as SGB packet
SetSGB2AndSGB3MapPalette: ; 7036a (1c:436a)
	ld a, [wConsole]
	cp CONSOLE_SGB
	ret nz ; return if not SGB
	ld a, [wd132]
	or a
	ret z ; not valid

	push hl
	push bc
	push de
	ld a, [wd132]
	add a
	ld c, a
	ld b, $0
	ld hl, .pal_data_pointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DecompressSGBPalette

	; load palettes to wTempSGBPacket
	ld hl, wBGMapBuffer
	ld de, wTempSGBPacket + 1 ; PAL Packet color #0 (PAL23's SGB2)
	ld bc, 8 ; pal size
	call CopyDataHLtoDE
	ld hl, wBGMapBuffer + 34
	ld de, wTempSGBPacket + 9 ; PAL Packet color #4 (PAL23's SGB3)
	ld bc, 6
	call CopyDataHLtoDE

	xor a
	ld [wTempSGBPacket + 15], a
	ld hl, wTempSGBPacket
	ld a, $1
	ld [hl], a
	call Func_704c7
	call SendSGB
	pop de
	pop bc
	pop hl
	ret

.pal_data_pointers
	dw $722f ; unused
	dw $722f ; MAP_SGB_PALETTE_1
	dw $7253 ; MAP_SGB_PALETTE_2
	dw $7277 ; MAP_SGB_PALETTE_3
	dw $729a ; MAP_SGB_PALETTE_4
	dw $72bd ; MAP_SGB_PALETTE_5
	dw $72e0 ; MAP_SGB_PALETTE_6
	dw $7304 ; MAP_SGB_PALETTE_7
	dw $7328 ; MAP_SGB_PALETTE_8
	dw $734b ; MAP_SGB_PALETTE_9
	dw $736f ; MAP_SGB_PALETTE_10

	INCROM $703cb, $70403

DecompressSGBPalette: ; 70403 (1c:4403)
	push hl
	push bc
	push de
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	push bc
	ld e, l
	ld d, h
	ld b, HIGH(wc000)
	call InitBGMapDecompression
	pop bc
	ld de, wBGMapBuffer
	call DecompressBGMap
	pop de
	pop bc
	pop hl
	ret
; 0x7041d

	INCROM $7041d, $704c7

; load some values to wTempSGBPacket
Func_704c7: ; 704c7 (1c:44c7)
	push af
	push hl
	inc hl
	ld a, $9c
	ld [hli], a
	ld a, $63
	ld [hl], a
	pop hl
	pop af
	ret
; 0x704d3

	INCROM $704d3, $74000
