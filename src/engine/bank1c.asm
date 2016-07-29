Func_70000: ; 70000 (1c:4000)
	ld a, [wConsole]
	cp $1
	ret nz
	ld b, $1
	ld a, $22
	farcall CheckIfEventFlagSet
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
; 0x70024

INCBIN "baserom.gbc",$70024,$70044 - $70024

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
INCBIN "baserom.gbc",$70057,$70082 - $70057

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
	ld de, $8800
	call Func_701e9
	call Func_701fe
	ld hl, SGB_700de
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
	ld de, $8800
	call Func_701e9
	ld hl, SGB_700ee
	call Func_70177
.asm_700da
	pop de
	pop bc
	pop hl
	ret

; CHR_TRN: tiles $00-$7F, BG (border) tiles (from SNES $000-$FFF)
SGB_700de: ; 700de (1c:40de)
INCBIN "baserom.gbc",$700de,$700ee - $700de

; CHR_TRN: tiles $80-$FF, BG (border) tiles (from SNES $000-$FFF)
SGB_700ee: ; 700ee (1c:40ee)
INCBIN "baserom.gbc",$700ee,$700fe - $700ee

Func_700fe: ; 700fe (1c:40fe)
	push hl
	push bc
	push de
	push hl
	push de
	push hl
	call Func_70136
	pop hl
	ld de, $8800
	call Func_701e9
	pop hl
	ld de, $9000
	call Func_701e9
	call Func_701fe
	pop hl
	call Func_70214
	ld hl, SGB_70126
	call Func_70177
	pop de
	pop bc
	pop hl
	ret

; PCT_TRN: read tile map & palette data into VRAM (from SNES $000-$87F)
SGB_70126: ; 70126 (1c:4126)
INCBIN "baserom.gbc",$70126,$70136 - $70126

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
	ld hl, SGB_MASK_EN_ON_701a0
	call SendSGB
	call DisableLCD
	ld a, [wLCDC]
	and $41
	or $1
	ld [wLCDC], a
	ld a, $e4
	ld [rBGP], a
	call Func_040c
	xor a
	ldh [hSCX], a
	ld [rSCX], a
	ldh [hSCY], a
	ld [rSCY], a
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
	call Func_040c
	ld a, [wd420]
	ld [wLCDC], a
	call DisableLCD
	ei
	pop de
	pop bc
	pop hl
	ret

; MASK_EN on
SGB_MASK_EN_ON_701a0: ; 701a0 (1c:41a0)
INCBIN "baserom.gbc",$701a0,$701b0 - $701a0

; MASK_EN off
SGB_MASK_EN_OFF_701b0: ; 701b0 (1c:41b0)
INCBIN "baserom.gbc",$701b0,$701c0 - $701b0

Func_701c0: ; 701c0 (1c:41c0)
	push hl
	push bc
	call DisableLCD
	xor a
	ld c, $10
	ld hl, $9000
.asm_701cb
	ld [hli], a
	dec c
	jr nz, .asm_701cb
	ld a, [wTileMapFill]
	push af
	xor a
	ld [wTileMapFill], a
	call Func_04a2
	pop af
	ld [wTileMapFill], a
	di
	ld hl, SGB_MASK_EN_OFF_701b0
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
	ld b, $c0
	call Func_08bf
	pop bc
	pop de
	call Func_08de
	ret

Func_701fe: ; 701fe (1c:41fe)
	ld hl, $9800
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
	farcall CheckIfEventFlagSet
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
INCBIN "baserom.gbc",$7024a,$74000 - $7024a
