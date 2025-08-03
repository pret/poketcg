Func_1c865:
	ret

; debug function
; adjusts hSCX and hSCY by using the arrow keys
; pressing B makes it scroll faster
Func_1c866: ; unreferenced
	ldh a, [hKeysHeld]
	and PAD_B
	call nz, .asm_1c86d ; executes following part twice
.asm_1c86d
	ldh a, [hSCX]
	ld b, a
	ldh a, [hSCY]
	ld c, a
	ldh a, [hKeysHeld]
	bit B_PAD_UP, a
	jr z, .check_d_down
	inc c
.check_d_down
	bit B_PAD_DOWN, a
	jr z, .check_d_left
	dec c
.check_d_left
	bit B_PAD_LEFT, a
	jr z, .check_d_right
	inc b
.check_d_right
	bit B_PAD_RIGHT, a
	jr z, .asm_1c889
	dec b
.asm_1c889
	ld a, b
	ldh [hSCX], a
	ld a, c
	ldh [hSCY], a
	ret

; sets some flags on a given sprite
Func_1c890: ; unreferenced
	ld a, [wVBlankCounter]
	and %111111
	ret nz

	ld a, [wd41b]
	cp $11
	jr z, .asm_1c8a3
	cp $0e
	ret c
	cp $10
	ret nc

; wd41b == $11 || (wd41b >= $0e && wd41b < $10)
.asm_1c8a3
	ld a, [wd41c]
	ld [wWhichSprite], a
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	call UpdateRNGSources
	and SPRITE_ANIM_FLAG_X_INVERTED
	jr nz, .asm_1c8b9
	res SPRITE_ANIM_FLAG_CENTERED_F, [hl]
	jr .asm_1c8bb
.asm_1c8b9
	set SPRITE_ANIM_FLAG_CENTERED_F, [hl]
.asm_1c8bb
	ret
