; clear [SOMETHING] - something relating to animations
Func_3ca0:
	xor a
	ld [wd5d7], a
	; fallthrough

Func_3ca4:
	ldh a, [hBankROM]
	push af
	ld a, BANK(Func_1296e)
	call BankswitchROM
	call Func_1296e
	pop af
	call BankswitchROM
	ret

HandleAllSpriteAnimations:
	ldh a, [hBankROM]
	push af
	ld a, BANK(_HandleAllSpriteAnimations)
	call BankswitchROM
	call _HandleAllSpriteAnimations
	pop af
	call BankswitchROM
	ret

; hl - pointer to animation frame
; wd5d6 - bank of animation frame
DrawSpriteAnimationFrame:
	ldh a, [hBankROM]
	push af
	ld a, [wd5d6]
	call BankswitchROM
	ld a, [wCurrSpriteXPos]
	cp $f0
	ld a, 0
	jr c, .notNearRight
	dec a
.notNearRight
	ld [wCurrSpriteRightEdgeCheck], a
	ld a, [wCurrSpriteYPos]
	cp $f0
	ld a, 0
	jr c, .setBottomEdgeCheck
	dec a
.setBottomEdgeCheck
	ld [wCurrSpriteBottomEdgeCheck], a
	ld a, [hli]
	or a
	jp z, .done
	ld c, a
.loop
	push bc
	push hl
	ld b, 0
	bit 7, [hl]
	jr z, .beginY
	dec b
.beginY
	ld a, [wCurrSpriteAttributes]
	bit OAM_Y_FLIP, a
	jr z, .unflippedY
	ld a, [hl]
	add 8 ; size of a tile
	ld c, a
	ld a, 0
	adc b
	ld b, a
	ld a, [wCurrSpriteYPos]
	sub c
	ld e, a
	ld a, [wCurrSpriteBottomEdgeCheck]
	sbc b
	jr .finishYPosition
.unflippedY
	ld a, [wCurrSpriteYPos]
	add [hl]
	ld e, a
	ld a, [wCurrSpriteBottomEdgeCheck]
	adc b
.finishYPosition
	or a
	jr nz, .endCurrentIteration
	inc hl
	ld b, 0
	bit 7, [hl]
	jr z, .beginX
	dec b
.beginX
	ld a, [wCurrSpriteAttributes]
	bit OAM_X_FLIP, a
	jr z, .unflippedX
	ld a, [hl]
	add 8 ; size of a tile
	ld c, a
	ld a, 0
	adc b
	ld b, a
	ld a, [wCurrSpriteXPos]
	sub c
	ld d, a
	ld a, [wCurrSpriteRightEdgeCheck]
	sbc b
	jr .finishXPosition
.unflippedX
	ld a, [wCurrSpriteXPos]
	add [hl]
	ld d, a
	ld a, [wCurrSpriteRightEdgeCheck]
	adc b
.finishXPosition
	or a
	jr nz, .endCurrentIteration
	inc hl
	ld a, [wCurrSpriteTileID]
	add [hl]
	ld c, a
	inc hl
	ld a, [wCurrSpriteAttributes]
	add [hl]
	and OAM_PALETTE | (1 << OAM_OBP_NUM)
	ld b, a
	ld a, [wCurrSpriteAttributes]
	xor [hl]
	and (1 << OAM_X_FLIP) | (1 << OAM_Y_FLIP) | (1 << OAM_PRIORITY)
	or b
	ld b, a
	inc hl ; unnecessary
	call SetOneObjectAttributes
.endCurrentIteration
	pop hl
	ld bc, 4 ; size of info for one sub tile
	add hl, bc
	pop bc
	dec c
	jr nz, .loop
.done
	pop af
	call BankswitchROM
	ret

; Loads a pointer to the current animation frame into SPRITE_ANIM_FRAME_DATA_POINTER using
; the current frame's offset
; [wd4ca] - current frame offset
; wTempPointer* - Pointer to current Animation
GetAnimationFramePointer:
	ldh a, [hBankROM]
	push af
	push hl
	push hl
	ld a, [wd4ca]
	cp $ff
	jr nz, .useLoadedOffset
	ld de, SpriteNullAnimationPointer
	xor a
	jr .loadPointer
.useLoadedOffset
	ld a, [wTempPointer]
	ld l, a
	ld a, [wTempPointer + 1]
	ld h, a
	ld a, [wTempPointerBank]
	call BankswitchROM
	ld a, [hli]

	push af
	ld a, [wd4ca]
	rlca
	ld e, [hl]
	add e
	ld e, a
	inc hl
	ld a, [hl]
	adc 0
	ld d, a
	pop af

.loadPointer
	add BANK(SpriteNullAnimationPointer)
	pop hl
	ld bc, SPRITE_ANIM_FRAME_BANK
	add hl, bc
	ld [hli], a
	call BankswitchROM
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	pop hl
	pop af
	call BankswitchROM
	ret

; return hl pointing to the start of a sprite in wSpriteAnimBuffer.
; the sprite is identified by its index in wWhichSprite.
GetFirstSpriteAnimBufferProperty:
	push bc
	ld c, SPRITE_ANIM_ENABLED
	call GetSpriteAnimBufferProperty
	pop bc
	ret

; return hl pointing to the property (byte) c of a sprite in wSpriteAnimBuffer.
; the sprite is identified by its index in wWhichSprite.
GetSpriteAnimBufferProperty:
	ld a, [wWhichSprite]
;	fallthrough

GetSpriteAnimBufferProperty_SpriteInA:
	cp SPRITE_ANIM_BUFFER_CAPACITY
	jr c, .got_sprite
	debug_nop
	ld a, SPRITE_ANIM_BUFFER_CAPACITY - 1 ; default to last sprite
.got_sprite
	push bc
	swap a ; a *= SPRITE_ANIM_LENGTH
	push af
	and $f
	ld b, a
	pop af
	and $f0
	or c ; add the property offset
	ld c, a
	ld hl, wSpriteAnimBuffer
	add hl, bc
	pop bc
	ret

Func_3ddb:
	push hl
	push bc
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty_SpriteInA
	res 2, [hl]
	pop bc
	pop hl
	ret

Func_3de7:
	push hl
	push bc
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty_SpriteInA
	set 2, [hl]
	pop bc
	pop hl
	ret

LoadScene:
	push af
	ldh a, [hBankROM]
	push af
	push hl
	ld a, BANK(_LoadScene)
	call BankswitchROM
	ld hl, sp+$5
	ld a, [hl]
	call _LoadScene
	call FlushAllPalettes
	pop hl
	pop af
	call BankswitchROM
	pop af
	ld a, [wSceneSpriteIndex]
	ret

; draws player's portrait at b,c
DrawPlayerPortrait:
	ld a, $1
	ld [wd61e], a
	ld a, TILEMAP_PLAYER
;	fallthrough

DrawPortrait:
	ld [wCurTilemap], a
	ldh a, [hBankROM]
	push af
	ld a, BANK(Func_12fc6)
	call BankswitchROM
	call Func_12fc6
	pop af
	call BankswitchROM
	ret

; draws opponent's portrait given in a at b,c
DrawOpponentPortrait:
	ld [wd61e], a
	ld a, TILEMAP_OPPONENT
	jr DrawPortrait

Func_3e31:
	ldh a, [hBankROM]
	push af
	call HandleAllSpriteAnimations
	ld a, BANK(DoLoadedFramesetSubgroupsFrame)
	call BankswitchROM
	call DoLoadedFramesetSubgroupsFrame
	pop af
	call BankswitchROM
	ret
