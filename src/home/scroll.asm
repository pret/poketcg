; something window scroll
Func_3e44::
	push af
	push hl
	push bc
	push de
	ld hl, wd657
	bit 0, [hl]
	jr nz, .done
	set 0, [hl]
	ld b, $00
	ld hl, wd658
	ld c, [hl]
	inc [hl]
	ld hl, wd64b
	add hl, bc
	ld a, [hl]
	ldh [rWX], a
	ld hl, rLCDC
	cp $a7
	jr c, .disable_sprites
	set 1, [hl] ; enable sprites
	jr .asm_3e6c
.disable_sprites
	res 1, [hl] ; disable sprites
.asm_3e6c
	ld hl, wd651
	add hl, bc
	ld a, [hl]
	cp $8f
	jr c, .asm_3e9a
	ld a, [wd665]
	or a
	jr z, .asm_3e93
	ld hl, wd659
	ld de, wd64b
	ld bc, $6
	call CopyDataHLtoDE
	ld hl, wd65f
	ld de, wd651
	ld bc, $6
	call CopyDataHLtoDE
.asm_3e93
	xor a
	ld [wd665], a
	ld [wd658], a
.asm_3e9a
	ldh [rLYC], a
	ld hl, wd657
	res 0, [hl]
.done
	pop de
	pop bc
	pop hl
	pop af
	ret

; apply background scroll for lines 0 to 96 using the values at BGScrollData
; skip if wApplyBGScroll is non-0
ApplyBackgroundScroll::
	push af
	push hl
	call DisableInt_LYCoincidence
	ld hl, rSTAT
	res STAT_LYCFLAG, [hl] ; reset coincidence flag
	ei
	ld hl, wApplyBGScroll
	ld a, [hl]
	or a
	jr nz, .done
	inc [hl]
	push bc
	push de
	xor a
	ld [wNextScrollLY], a
.ly_loop
	ld a, [wNextScrollLY]
	ld b, a
.wait_ly
	ldh a, [rLY]
	cp $60
	jr nc, .ly_over_0x60
	cp b ; already hit LY=b?
	jr c, .wait_ly
	call GetNextBackgroundScroll
	ld hl, rSTAT
.wait_hblank_or_vblank
	bit STAT_BUSY, [hl]
	jr nz, .wait_hblank_or_vblank
	ldh [rSCX], a
	ldh a, [rLY]
	inc a
	ld [wNextScrollLY], a
	jr .ly_loop
.ly_over_0x60
	xor a
	ldh [rSCX], a
	ld a, $00
	ldh [rLYC], a
	call GetNextBackgroundScroll
	ldh [hSCX], a
	pop de
	pop bc
	xor a
	ld [wApplyBGScroll], a
	call EnableInt_LYCoincidence
.done
	pop hl
	pop af
	ret

BGScrollData::
	db  0,  0,  0,  1,  1,  1,  2,  2,  2,  3,  3,  3,  3,  3,  3,  3
	db  4,  3,  3,  3,  3,  3,  3,  3,  2,  2,  2,  1,  1,  1,  0,  0
	db  0, -1, -1, -1, -2, -2, -2, -3, -3, -3, -4, -4, -4, -4, -4, -4
	db -5, -4, -4, -4, -4, -4, -4, -3, -3, -3, -2, -2, -2, -1, -1, -1

; x = BGScrollData[(wVBlankCounter + a) & $3f]
; return, in register a, x rotated right [wBGScrollMod]-1 times (max 3 times)
GetNextBackgroundScroll::
	ld hl, wVBlankCounter
	add [hl]
	and $3f
	ld c, a
	ld b, $00
	ld hl, BGScrollData
	add hl, bc
	ld a, [wBGScrollMod]
	ld c, a
	ld a, [hl]
	dec c
	jr z, .done
	dec c
	jr z, .halve
	dec c
	jr z, .quarter
; effectively zero
	sra a
.quarter
	sra a
.halve
	sra a
.done
	ret

; enable lcdc interrupt on LYC=LC coincidence
EnableInt_LYCoincidence::
	push hl
	ld hl, rSTAT
	set STAT_LYC, [hl]
	xor a
	ld hl, rIE
	set INT_LCD_STAT, [hl]
	pop hl
	ret

; disable lcdc interrupt and the LYC=LC coincidence trigger
DisableInt_LYCoincidence::
	push hl
	ld hl, rSTAT
	res STAT_LYC, [hl]
	xor a
	ld hl, rIE
	res INT_LCD_STAT, [hl]
	pop hl
	ret
