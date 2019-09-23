LoadMap: ; c000 (3:4000)
	call DisableLCD
	call EnableSRAM
	bank1call DiscardSavedDuelData
	call DisableSRAM
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	xor a
	ld [wd10f], a
	ld [wd110], a
	ld [wMatchStartTheme], a
	farcall Func_10a9b
	call WhiteOutDMGPals
	call ZeroObjectPositions
	xor a
	ld [wTileMapFill], a
	call LoadSymbolsFont
	call Set_OBJ_8x8
	xor a
	ld [wLineSeparation], a
	xor a
	ld [wd291], a
.asm_c037
	farcall Func_10ab4
	call WhiteOutDMGPals
	call Func_c241
	call EmptyScreen
	call Func_3ca0
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	farcall Func_1c440
	ld a, [wd0bb]
	ld [wCurMap], a
	ld a, [wd0bc]
	ld [wPlayerXCoord], a
	ld a, [wd0bd]
	ld [wPlayerYCoord], a
	call Func_c36a
	call Func_c184
	call Func_c49c
	farcall Func_80000
	call Func_c4b9
	call Func_c943
	call Func_c158
	farcall Func_80480
	call Func_c199
	xor a
	ld [wd0b4], a
	ld [wd0c1], a
	call Func_39fc
	farcall Func_10af9
	call Func_c141
	call Func_c17a
.asm_c092
	call DoFrameIfLCDEnabled
	call SetScreenScroll
	call Func_c0ce
	ld hl, wd0b4
	ld a, [hl]
	and $d0
	jr z, .asm_c092
	call DoFrameIfLCDEnabled
	ld hl, wd0b4
	ld a, [hl]
	bit 4, [hl]
	jr z, .asm_c0b6
	ld a, SFX_0C
	call PlaySFX
	jp .asm_c037
.asm_c0b6
	farcall Func_10ab4
	call Func_c1a0
	ld a, [wMatchStartTheme]
	or a
	jr z, .asm_c0ca
	call Func_c280
	farcall Duel_Init
.asm_c0ca
	call Func_c280
	ret

Func_c0ce: ; c0ce (3:40ce)
	ld a, [wd0bf]
	res 7, a
	rlca
	add LOW(PointerTable_c0e0)
	ld l, a
	ld a, HIGH(PointerTable_c0e0)
	adc $0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

PointerTable_c0e0: ; c0e0 (3:40e0)
	dw Func_c0e8
	dw Func_c0ed
	dw Func_c0f1
	dw Func_c10a

Func_c0e8: ; c0e8 (3:40e8)
	farcall Func_10e55
	ret

Func_c0ed: ; c0ed (3:40ed)
	call Func_c510
	ret

Func_c0f1: ; c0f1 (3:40f1)
	ld a, [wd3b6]
	ld [wd3aa], a
	farcall Func_1c768
	ld a, c
	ld [wd0c6], a
	ld a, b
	ld [wd0c7], a
	ld a, $3
	ld [wd0bf], a
	jr Func_c10a

Func_c10a: ; c10a (3:410a)
	ld hl, wd0c6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; closes dialogue window. seems to be for other things as well.
CloseAdvancedDialogueBox: ; c111 (3:4111)
	ld a, [wd0c1]
	bit 0, a
	call nz, CloseTextBox
	ld a, [wd0c1]
	bit 1, a
	jr z, .asm_c12a
	ld a, [wd3b6]
	ld [wd3aa], a
	farcall Func_1c5e9
.asm_c12a
	xor a
	ld [wd0c1], a
	ld a, [wd0c0]
	ld [wd0bf], a
	ret

; redraws the background and removes textbox control
CloseTextBox: ; c135 (3:4135)
	push hl
	farcall Func_80028
	ld hl, wd0c1
	res 0, [hl]
	pop hl
	ret

Func_c141: ; c141 (3:4141)
	ld hl, wd0c2
	ld a, [hl]
	or a
	ret z
	push af
	xor a
	ld [hl], a
	pop af
	dec a
	ld hl, PointerTable_c152
	jp JumpToFunctionInTable

PointerTable_c152: ; c152 (3:4152)
	dw Func_c9bc
	dw Func_fc2b
	dw Func_fcad

Func_c158: ; c158 (3:4158)
	ld a, [wd0c2]
	cp $1
	ret nz
	ld a, [wd0c4]
	ld [wd3ab], a
	call Func_39c3
	jr c, .asm_c179
	ld a, [wd3aa]
	ld l, $4
	call Func_39ad
	ld a, [wd0c5]
	ld [hl], a
	farcall Func_1c58e
.asm_c179
	ret

Func_c17a: ; c17a (3:417a)
	ld a, [wd0bf]
	cp $3
	ret z
	call Func_c9b8
	ret

Func_c184: ; c184 (3:4184)
	push bc
	ld c, $1
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .asm_c190
	ld c, $0
.asm_c190
	ld a, c
	ld [wd0bf], a
	ld [wd0c0], a
	pop bc
	ret

Func_c199: ; c199 (3:4199)
	ld hl, Func_380e
	call SetDoFrameFunction
	ret

Func_c1a0: ; c1a0 (3:41a0)
	call ResetDoFrameFunction
	ret

WhiteOutDMGPals: ; c1a4 (3:41a4)
	xor a
	call SetBGP
	xor a
	call SetOBP0
	xor a
	call SetOBP1
	ret

Func_c1b1: ; c1b1 (3:41b1)
	ld a, $c
	ld [wd32e], a
	ld a, $0
	ld [wd0bb], a
	ld a, $c
	ld [wd0bc], a
	ld a, $c
	ld [wd0bd], a
	ld a, $2
	ld [wd0be], a
	call Func_c9cb
	call Func_c9dd
	farcall Func_80b7a
	farcall Func_1c82e
	farcall Func_131b3
	xor a
	ld [wPlayTimeCounter + 0], a
	ld [wPlayTimeCounter + 1], a
	ld [wPlayTimeCounter + 2], a
	ld [wPlayTimeCounter + 3], a
	ld [wPlayTimeCounter + 4], a
	ret

Func_c1ed: ; c1ed (3:41ed)
	call Func_c9cb
	farcall Func_11416
	call Func_c9dd
	ret

Func_c1f8: ; c1f8 (3:41f8)
	xor a
	ld [wd0b8], a
	ld [wd0b9], a
	ld [wd0ba], a
	ld [wd11b], a
	ld [wd0c2], a
	ld [wd111], a
	ld [wd112], a
	ld [wd3b8], a
	call EnableSRAM
	ld a, [s0a007]
	ld [wd421], a
	ld a, [s0a006]
	ld [wTextSpeed], a
	call DisableSRAM
	farcall Func_10756
	ret

Func_c228: ; c228 (3:4228)
	ld a, [wCurMap]
	ld [wd0bb], a
	ld a, [wPlayerXCoord]
	ld [wd0bc], a
	ld a, [wPlayerYCoord]
	ld [wd0bd], a
	ld a, [wd334]
	ld [wd0be], a
	ret

Func_c241: ; c241 (3:4241)
	push hl
	push bc
	push de
	lb de, $30, $7f
	call SetupText
	call Func_c258
	pop de
	pop bc
	pop hl
	ret

Func_c251: ; c251 (3:4251)
	ldh a, [hffb0]
	push af
	ld a, $1
	jr asm_c25d

Func_c258: ; c258 (3:4258)
	ldh a, [hffb0]
	push af
	ld a, $2
asm_c25d
	ldh [hffb0], a
	push hl
	call Func_c268
	pop hl
	pop af
	ldh [hffb0], a
	ret

Func_c268: ; c268 (3:4268)
	ld hl, Unknown_c27c
.asm_c26b
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .asm_c27a
	call ProcessTextFromID
	pop hl
	inc hl
	inc hl
	jr .asm_c26b
.asm_c27a
	pop hl
	ret

Unknown_c27c: ; c27c (3:427c)
	INCROM $c27c, $c280

Func_c280: ; c280 (3:4280)
	call Func_c228
	call Func_3ca0
	call ZeroObjectPositions
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	call EnableLCD
	call DoFrameIfLCDEnabled
	call DisableLCD
	farcall Func_12871
	ret

Func_c29b: ; c29b (3:429b)
	push hl
	ld hl, wd0c1
	or [hl]
	ld [hl], a
	pop hl
	ret

Func_c2a3: ; c2a3 (3:42a3)
	push hl
	push bc
	push de
	call Func_c335
	farcall Func_10ab4
	ld a, $80
	call Func_c29b
	lb de, $30, $7f
	call SetupText
	farcall Func_12ba7
	call Func_3ca0
	call ZeroObjectPositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	call EnableLCD
	call DoFrameIfLCDEnabled
	call DisableLCD
	pop de
	pop bc
	pop hl
	ret

Func_c2d4: ; c2d4 (3:42d4)
	xor a
	ld [wd10f], a
	ld [wd110], a

Func_c2db: ; c2db (3:42db)
	push hl
	push bc
	push de
	call DisableLCD
	call Set_OBJ_8x8
	call Func_3ca0
	farcall Func_12bcd
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call Func_c241
	call EmptyScreen
	ld a, [wd111]
	push af
	farcall Func_80000
	pop af
	ld [wd111], a
	ld hl, wd0c1
	res 0, [hl]
	call Func_c34e
	farcall Func_12c5e
	farcall Func_1c6f8
	ld hl, wd0c1
	res 7, [hl]
	ld hl, wd10f
	ld a, [hli]
	or [hl]
	jr z, .asm_c323
	ld a, [hld]
	ld l, [hl]
	ld h, a
	call CallHL2
.asm_c323
	farcall Func_10af9
	pop de
	pop bc
	pop hl
	ret

Func_c32b: ; c32b (3:432b)
	ld a, l
	ld [wd10f], a
	ld a, h
	ld [wd110], a
	jr Func_c2db

Func_c335: ; c335 (3:4335)
	ld a, [wOBP0]
	ld [wd10c], a
	ld a, [wOBP1]
	ld [wd10d], a
	ld hl, wObjectPalettesCGB
	ld de, wd0cc
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	ret

Func_c34e: ; c34e (3:434e)
	ld a, [wd10c]
	ld [wOBP0], a
	ld a, [wd10d]
	ld [wOBP1], a
	ld hl, wd0cc
	ld de, wObjectPalettesCGB
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	call FlushAllPalettes
	ret

Func_c36a: ; c36a (3:436a)
	xor a
	ld [wd323], a
	ld a, [wCurMap]
	cp POKEMON_DOME_ENTRANCE
	jr nz, .asm_c379
	xor a
	ld [wd324], a
.asm_c379
	ret
; 0xc37a

	INCROM $c37a, $c41c

Func_c41c: ; c41c (3:441c)
	ld a, [wd332]
	sub $40
	ld [wSCXBuffer], a
	ld a, [wd333]
	sub $40
	ld [wSCYBuffer], a
	call Func_c430
	ret

Func_c430: ; c430 (3:4430)
	push bc
	ld a, [wd237]
	sla a
	sla a
	sla a
	ld b, a
	ld a, [wSCXBuffer]
	cp $b1
	jr c, .asm_c445
	xor a
	jr .asm_c449
.asm_c445
	cp b
	jr c, .asm_c449
	ld a, b
.asm_c449
	ld [wSCXBuffer], a
	ld a, [wd238]
	sla a
	sla a
	sla a
	ld b, a
	ld a, [wSCYBuffer]
	cp $b9
	jr c, .asm_c460
	xor a
	jr .asm_c464
.asm_c460
	cp b
	jr c, .asm_c464
	ld a, b
.asm_c464
	ld [wSCYBuffer], a
	pop bc
	ret

Func_c469: ; c469 (3:4469)
	ld a, [wSCXBuffer]
	add $4
	and $f8
	rrca
	rrca
	rrca
	ld [wd233], a
	ld a, [wSCYBuffer]
	add $4
	and $f8
	rrca
	rrca
	rrca
	ld [wd234], a
	ret

SetScreenScrollWram: ; c484 (3:4484)
	ld a, [wSCXBuffer]
	ld [wSCX], a
	ld a, [wSCYBuffer]
	ld [wSCY], a
	ret

SetScreenScroll: ; c491 (3:4491)
	ld a, [wSCX]
	ldh [hSCX], a
	ld a, [wSCY]
	ldh [hSCY], a
	ret

Func_c49c: ; c49c (3:449c)
	ld a, [wPlayerXCoord]
	and $1f
	ld [wPlayerXCoord], a
	rlca
	rlca
	rlca
	ld [wd332], a
	ld a, [wPlayerYCoord]
	and $1f
	ld [wPlayerYCoord], a
	rlca
	rlca
	rlca
	ld [wd333], a
	ret

Func_c4b9: ; c4b9 (3:44b9)
	xor a
	ld [wd4ca], a
	ld [wd4cb], a
	ld a, $1d
	farcall Func_80418
	ld b, $0
	ld a, [wConsole]
	cp $2
	jr nz, .asm_c4d1
	ld b, $1e
.asm_c4d1
	ld a, b
	ld [wd337], a
	ld a, $0
	farcall Func_1299f
	ld a, [wWhichSprite]
	ld [wd336], a
	ld b, $2
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr z, .asm_c4ee
	ld a, [wd0be]
	ld b, a
.asm_c4ee
	ld a, b
	ld [wd334], a
	call Func_c5e9
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	call nz, Func_c6f7
	xor a
	ld [wd335], a
	ld [wd338], a
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .asm_c50f
	farcall Func_10fde
.asm_c50f
	ret

Func_c510: ; c510 (3:4510)
	ld a, [wd336]
	ld [wWhichSprite], a
	ld a, [wd335]
	bit 4, a
	ret nz
	bit 0, a
	call z, Func_c5ac
	ld a, [wd335]
	or a
	jr z, .asm_c535
	bit 0, a
	call nz, Func_c66c
	ld a, [wd335]
	bit 1, a
	call nz, Func_c6dc
	ret
.asm_c535
	ldh a, [hKeysPressed]
	and START
	call nz, Func_c74d
	ret

Func_c53d: ; c53d (3:453d)
	ld a, [wd336]
	ld [wWhichSprite], a
	ld a, [wd335]
	bit 0, a
	call nz, Func_c687
	ld a, [wd335]
	bit 1, a
	call nz, Func_c6dc
	ret

Func_c554: ; c554 (3:4554)
	ld a, [wd336]
	ld [wWhichSprite], a
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .asm_c566
	farcall Func_10e28
	ret
.asm_c566
	push hl
	push bc
	push de
	call Func_c58b
	ld a, [wSCXBuffer]
	ld d, a
	ld a, [wSCYBuffer]
	ld e, a
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, [wd332]
	sub d
	add $8
	ld [hli], a
	ld a, [wd333]
	sub e
	add $10
	ld [hli], a
	pop de
	pop bc
	pop hl
	ret

Func_c58b: ; c58b (3:458b)
	push hl
	ld a, [wPlayerXCoord]
	ld b, a
	ld a, [wPlayerYCoord]
	ld c, a
	call GetPermissionOfMapPosition
	and $10
	push af
	ld c, SPRITE_ANIM_FIELD_0F
	call GetSpriteAnimBufferProperty
	pop af
	ld a, [hl]
	jr z, .asm_c5a7
	or $80
	jr .asm_c5a9
.asm_c5a7
	and $7f
.asm_c5a9
	ld [hl], a
	pop hl
	ret

Func_c5ac: ; c5ac (3:45ac)
	ldh a, [hKeysHeld]
	and D_PAD
	jr z, .asm_c5bf
	call Func_c5cb
	call Func_c5fe
	ld a, [wd335]
	and $1
	jr nz, .asm_c5ca
.asm_c5bf
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .asm_c5ca
	call Func_c71e
	jr .asm_c5ca
.asm_c5ca
	ret

Func_c5cb: ; c5cb (3:45cb)
	call Func_c5d5
Func_c5ce: ; c5ce (3:45ce)
	ld [wd334], a
	call Func_c5e9
	ret

Func_c5d5: ; c5d5 (3:45d5)
	push hl
	ld hl, Unknown_c5e5
	or a
	jr z, .asm_c5e2
.asm_c5dc
	rlca
	jr c, .asm_c5e2
	inc hl
	jr .asm_c5dc
.asm_c5e2
	ld a, [hl]
	pop hl
	ret

Unknown_c5e5: ; c5e5 (3:45e5)
	db $02,$00,$03,$01

Func_c5e9: ; c5e9 (3:45e9)
	push bc
	ld a, [wd336]
	ld [wWhichSprite], a
	ld a, [wd337]
	ld b, a
	ld a, [wd334]
	add b
	farcall Func_12ab5
	pop bc
	ret

Func_c5fe: ; c5fe (3:45fe)
	push bc
	call Func_c653
	call AttemptScriptedMovement
	pop bc
	ret

StartScriptedMovement: ; c607 (3:4607)
	push bc
	ld a, [wd336]
	ld [wWhichSprite], a
	ld a, [wd339]
	call FindScriptedMovementWithOffset
	call AttemptScriptedMovement
	pop bc
	ret

; bc is the location the player is being scripted to move towards.
AttemptScriptedMovement: ; c619 (3:4619)
	push hl
	push bc
	ld a, b
	cp $1f
	jr nc, .quit_movement
	ld a, c
	cp $1f
	jr nc, .quit_movement
	call GetPermissionOfMapPosition
	and $40 | $80 ; the two impassable objects found in the floor map
	jr nz, .quit_movement
	ld a, b
	ld [wPlayerXCoord], a
	ld a, c
	ld [wPlayerYCoord], a
	ld a, [wd335] ; I believe everything starting here is animation related.
	or $1
	ld [wd335], a
	ld a, $10
	ld [wd338], a
	ld c, SPRITE_ANIM_FIELD_0F
	call GetSpriteAnimBufferProperty
	set 2, [hl]
	ld c, SPRITE_ANIM_MOVEMENT_COUNTER
	call GetSpriteAnimBufferProperty
	ld a, $4
	ld [hl], a
.quit_movement
	pop bc
	pop hl
	ret

Func_c653: ; c653 (3:4653)
	ld a, [wd334]

FindScriptedMovementWithOffset: ; c656 (3:4656)
	rlca
	ld c, a
	ld b, $0
	push hl
	ld hl, ScriptedMovementOffsetTable
	add hl, bc
	ld a, [wPlayerXCoord]
	add [hl]
	ld b, a
	inc hl
	ld a, [wPlayerYCoord]
	add [hl]
	ld c, a
	pop hl
	ret

Func_c66c: ; c66c (3:466c)
	push hl
	push bc
	ld c, $1
	ldh a, [hKeysHeld]
	bit B_BUTTON_F, a
	jr z, .asm_c67e
	ld a, [wd338]
	cp $2
	jr c, .asm_c67e
	inc c
.asm_c67e
	ld a, [wd334]
	call Func_c694
	pop bc
	pop hl
	ret

Func_c687: ; c687 (3:4687)
	push bc
	ld a, [wd33a]
	ld c, a
	ld a, [wd339]
	call Func_c694
	pop bc
    ret

Func_c694: ; c694 (3:4694)
	push hl
	push bc
	push bc
	rlca
	ld c, a
	ld b, $0
	ld hl, Unknown_396b
	add hl, bc
	pop bc
.asm_c6a0
	push hl
	ld a, [hli]
	or a
	call nz, Func_c6cc
	ld a, [hli]
	or a
	call nz, Func_c6d4
	pop hl
	ld a, [wd338]
	dec a
	ld [wd338], a
	jr z, .asm_c6b8
	dec c
	jr nz, .asm_c6a0
.asm_c6b8
	ld a, [wd338]
	or a
	jr nz, .asm_c6c3
	ld hl, wd335
	set 1, [hl]
.asm_c6c3
	call Func_c41c
	call Func_c469
	pop bc
	pop hl
	ret

Func_c6cc: ; c6cc (3:46cc)
	push hl
	ld hl, wd332
	add [hl]
	ld [hl], a
	pop hl
	ret

Func_c6d4: ; c6d4 (3:46d4)
	push hl
	ld hl, wd333
	add [hl]
	ld [hl], a
	pop hl
	ret

Func_c6dc: ; c6dc (3:46dc)
	push hl
	ld hl, wd335
	res 0, [hl]
	res 1, [hl]
	call Func_c6f7
	call Func_3997
	call Func_c70d
	ld a, [wd0bf]
	cp $1
	call z, Func_c9c0
	pop hl
	ret

Func_c6f7: ; c6f7 (3:46f7)
	ld a, [wd336]
	ld [wWhichSprite], a
	ld c, SPRITE_ANIM_FIELD_0F
	call GetSpriteAnimBufferProperty
	res 2, [hl]
	ld c, SPRITE_ANIM_MOVEMENT_COUNTER
	call GetSpriteAnimBufferProperty
	ld a, $ff
	ld [hl], a
	ret

Func_c70d: ; c70d (3:470d)
	push hl
	ld hl, wd0bb
	ld a, [wCurMap]
	cp [hl]
	jr z, .asm_c71c
	ld hl, wd0b4
	set 4, [hl]
.asm_c71c
	pop hl
	ret

Func_c71e: ; c71e (3:471e)
	ld a, $ff
	ld [wd3b6], a
	call Func_c653
	call GetPermissionOfMapPosition
	and $40
	jr z, .asm_c73d
	farcall Func_1c72e
	jr c, .asm_c73d
	ld a, [wd3aa]
	ld [wd3b6], a
	ld a, $2
	jr .asm_c748
.asm_c73d
	call Func_3a5e
	jr nc, .asm_c746
	ld a, $3
	jr .asm_c748
.asm_c746
	or a
	ret
.asm_c748
	ld [wd0bf], a
	scf
	ret

Func_c74d: ; c74d (3:474d)
	push hl
	push bc
	push de
	call MainMenu_c75a
	call CloseAdvancedDialogueBox
	pop de
	pop bc
	pop hl
	ret

MainMenu_c75a: ; c75a (3:475a)
	call PauseSong
	ld a, MUSIC_PAUSE_MENU
	call PlaySong
	call Func_c797
.asm_c765
	ld a, $1
	call Func_c29b
.asm_c76a
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .asm_c76a
	ld a, e
	ld [wd0b8], a
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .asm_c793
	cp $5
	jr z, .asm_c793
	call Func_c2a3
	ld a, [wd0b8]
	ld hl, PointerTable_c7a2
	call JumpToFunctionInTable
	ld hl, Func_c797
	call Func_c32b
	jr .asm_c765
.asm_c793
	call ResumeSong
	ret

Func_c797: ; c797 (3:4797)
	ld a, [wd0b8]
	ld hl, Unknown_cd98
	farcall Func_111e9
	ret

PointerTable_c7a2: ; c7a2 (3:47a2)
	dw Func_c7ae
	dw Func_c7b3
	dw Func_c7b8
	dw Func_c7cc
	dw Func_c7e0
	dw Func_c7e5

Func_c7ae: ; c7ae (3:47ae)
	farcall Func_10059
	ret

Func_c7b3: ; c7b3 (3:47b3)
	farcall Func_100a2
	ret

Func_c7b8: ; c7b8 (3:47b8)
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall Func_1288c
	farcall Func_8db0
	call Set_OBJ_8x8
	ret

Func_c7cc: ; c7cc (3:47cc)
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall Func_1288c
	farcall Func_a288
	call Set_OBJ_8x8
	ret

Func_c7e0: ; c7e0 (3:47e0)
	farcall Func_10548
	ret

Func_c7e5: ; c7e5 (3:47e5)
	farcall Func_103d2
	ret

PC_c7ea: ; c7ea (3:47ea)
	ld a, MUSIC_PC_MAIN_MENU
	call PlaySong
	call Func_c241
	call $4915
	call DoFrameIfLCDEnabled
	ldtx hl, TurnedPCOnText
	call PrintScrollableText_NoTextBoxLabel
	call $484e
.asm_c801
	ld a, $1
	call Func_c29b
.asm_c806
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .asm_c806
	ld a, e
	ld [wd0b9], a
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .asm_c82f
	cp $4
	jr z, .asm_c82f
	call Func_c2a3
	ld a, [wd0b9]
	ld hl, $4846
	call JumpToFunctionInTable
	ld hl, $484e
	call Func_c32b
	jr .asm_c801
.asm_c82f
	call CloseTextBox
	call DoFrameIfLCDEnabled
	ldtx hl, TurnedPCOffText
	call Func_c891
	call CloseAdvancedDialogueBox
	xor a
	ld [wd112], a
	call Func_39fc
	ret
; 0xc846

	INCROM $c846, $c891

Func_c891: ; c891 (3:4891)
	push hl
	ld a, [wd0c1]
	bit 0, a
	jr z, .asm_c8a1
	ld hl, wd3b9
	ld a, [hli]
	or [hl]
	call nz, CloseTextBox

.asm_c8a1
	xor a
	ld hl, wd3b9
	ld [hli], a
	ld [hl], a
	pop hl
	ld a, $1
	call Func_c29b
	call Func_c241
	call $4915
	call DoFrameIfLCDEnabled
	call PrintScrollableText_NoTextBoxLabel
	ret

Func_c8ba: ; c8ba (3:48ba)
	ld a, e
	or d
	jr z, Func_c891
	push hl
	ld a, [wd0c1]
	bit 0, a
	jr z, .asm_c8d4
	ld hl, wd3b9
	ld a, [hli]
	cp e
	jr nz, .asm_c8d1
	ld a, [hl]
	cp d
	jr z, .asm_c8d4

.asm_c8d1
	call CloseTextBox

.asm_c8d4
	ld hl, wd3b9
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	ld a, $1
	call Func_c29b
	call Func_c241
	call $4915
	call DoFrameIfLCDEnabled
	call $2c62
	ret
; 0xc8ed

Func_c8ed: ; c8ed (3:c8ed)
	push hl
	push bc
	push de
	push hl
	ld a, $1
	call Func_c29b
	call $4915
	call DoFrameIfLCDEnabled
	pop hl
	ld a, l
	or h
	jr z, .asm_c90e
	push hl
	xor a
	ld hl, wd3b9
	ld [hli], a
	ld [hl], a
	pop hl
	call YesOrNoMenuWithText
	jr .asm_c911

.asm_c90e
	call YesOrNoMenu

.asm_c911
	pop de
	pop bc
	pop hl
	ret

Func_c915: ; c915 (3:4915)
	push bc
	push de
	ld de, $000c
	ld bc, $1406
	call AdjustCoordinatesForBGScroll
	call $43ca
	pop de
	pop bc
	ret

Func_c926: ; c926 (3:4926)
	push bc
	call Func_39c3
	ld a, [wd3aa]
	ld [wd3b6], a
	farcall Func_1c768
	pop bc
;	fallthrough

Func_c935: ; c935 (3:4935)
	push hl
	ld hl, wd0c6
	ld [hl], c
	inc hl
	ld [hl], b
	ld a, $3
	ld [wd0bf], a
	pop hl
	ret

Func_c943: ; c943 (3:4943)
	push hl
	push bc
	push de
	ld l, $0
	call Func_3abd
	jr nc, .asm_c98f
.asm_c94d
	ld a, l
	ld [wd4c4], a
	ld a, h
	ld [wd4c5], a
	ld a, $4
	ld [wd4c6], a
	ld de, wd3ab
	ld bc, $0006
	call CopyBankedDataToDE
	ld a, [wd3ab]
	or a
	jr z, .asm_c98f
	push hl
	ld a, [wd3af]
	ld l, a
	ld a, [wd3b0]
	ld h, a
	or l
	jr z, .asm_c97a
	call CallHL2
	jr nc, .asm_c988
.asm_c97a
	ld a, [wd3ab]
	farcall Func_11857
	call Func_c998
	farcall Func_1c485
.asm_c988
	pop hl
	ld bc, $0006
	add hl, bc
	jr .asm_c94d
.asm_c98f
	ld l, $2
	call Func_c9c2
	pop de
	pop bc
	pop hl
	ret

Func_c998: ; c998 (3:4998)
	ld a, [wd3ab]
	cp $22
	ret nz
	ld a, [wd3d0]
	or a
	ret z
	ld b, $4
	ld a, [wConsole]
	cp $2
	jr nz, .asm_c9ae
	ld b, $e
.asm_c9ae
	ld a, b
	ld [wd3b1], a
	ld a, $0
	ld [wd3b2], a
	ret

Func_c9b8: ; c9b8 (3:49b8)
	ld l, $8
	jr Func_c9c2

Func_c9bc: ; c9bc (3:49bc)
	ld l, $a
	jr Func_c9c2

Func_c9c0: ; c9c0 (3:49c0)
	ld l, $c

Func_c9c2: ; c9c2 (3:49c2)
	call Func_3abd
	ret nc
	jp hl

Func_c9c7: ; c9c7 (3:49c7)
	ld l, $e
	jr Func_c9c2

Func_c9cb: ; c9cb (3:49cb)
	push hl
	push bc
	ld hl, wEventFlags
	ld bc, $0040
.asm_c9d3
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .asm_c9d3
	pop bc
	pop hl
	ret

Func_c9dd: ; c9dd (3:49dd)
	xor a
	ld [wd411], a
	call Func_c9e8
	call Func_ca0e
	ret

Func_c9e8: ; c9e8 (3:49e8)
	ld c, $0
	call Func_ca69
	db $13
	cp $2
	jr c, .asm_ca04
.asm_c9f2
	call UpdateRNGSources
	and $3
	ld c, a
	ld b, $0
	ld hl, Unknown_ca0a
	add hl, bc
	ld a, [wd0bb]
	cp [hl]
	jr z, .asm_c9f2
.asm_ca04
	ld a, c
	call Func_ca8f
	db $34
	ret

Unknown_ca0a: ; ca0a (3:4a04)
	INCROM $ca0a, $ca0e

Func_ca0e: ; ca0e (3:4a0e)
	ld a, [wd32e]
	cp $b
	jr z, .asm_ca68
	call Func_ca69
	db $22
	or a
	jr nz, .asm_ca4a
	call Func_ca69
	db $40
	cp $7
	jr z, .asm_ca68
	or a
	jr z, .asm_ca33
	cp $2
	jr z, .asm_ca62
	ld c, $1
	call Func_ca8f
	db $40
	jr .asm_ca62
.asm_ca33
	call Func_ca69
	db $3f
	cp $7
	jr z, .asm_ca68
	or a
	jr z, .asm_ca68
	cp $2
	jr z, .asm_ca68
	ld c, $1
	call Func_ca8f
	db $3f
	jr .asm_ca68
.asm_ca4a
	call UpdateRNGSources
	ld c, $1
	and $3
	or a
	jr z, .asm_ca56
	ld c, $0
.asm_ca56
	call Func_ca8f
	db $41
	jr .asm_ca5c
.asm_ca5c
	ld c, $7
	call Func_ca8f
	db $40
.asm_ca62
	ld c, $7
	call Func_ca8f
	db $3f
.asm_ca68
	ret

Func_ca69: ; ca69 (3:4a69)
	call Func_cab3

; returns the event flag's value in a
; also ors it with itself before returning
GetEventFlagValue: ; ca6c (3:4a6c)
	push hl
	push bc
	call GetEventFlag
	ld c, [hl]
	ld a, [wLoadedFlagBits]
.shiftLoop
	bit 0, a
	jr nz, .lsbReached
	srl a
	srl c
	jr .shiftLoop
.lsbReached
	and c
	pop bc
	pop hl
	or a
	ret
; 0xca84

	INCROM $ca84, $ca8f

Func_ca8f: ; ca8f (3:4a8f)
	call Func_cab3

; a - flag
; c - value - truncated to fit only the flag's bounds
SetEventFlagValue: ; ca92 (3:4a92)
	push hl
	push bc
	call GetEventFlag
	ld a, [wLoadedFlagBits]
.asm_ca9a
	bit 0, a
	jr nz, .asm_caa4
	srl a
	sla c
	jr .asm_ca9a
.asm_caa4
	ld a, [wLoadedFlagBits]
	and c
	ld c, a
	ld a, [wLoadedFlagBits]
	cpl
	and [hl]
	or c
	ld [hl], a
	pop bc
	pop hl
	ret

Func_cab3: ; cab3 (3:4ab3)
	push hl
	ld hl, sp+$4
	push bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [bc]
	inc bc
	ld [hl], b
	dec hl
	ld [hl], c
	pop bc
	pop hl
	ret
; 0xcac2

	INCROM $cac2, $cac5

MaxOutEventFlag: ; cac5 (3:4ac5)
	push bc
	ld c, $ff
	call SetEventFlagValue
	pop bc
	ret
; 0xcacd

	INCROM $cacd, $cad0

ZeroOutEventFlag: ; cad0 (3:4ad0)
	push bc
	ld c, $0
	call SetEventFlagValue
	pop bc
	ret

Func_cad8: ; cad8 (3:4ad8)
	push hl
	push bc
	ld hl, $4b15
	ld bc, $0008
.asm_cae0
	ld a, [hli]
	call GetEventFlagValue
	jr z, .asm_cae7
	inc b

.asm_cae7
	dec c
	jr nz, .asm_cae0
	ld c, b
	call Func_ca8f
	ld l, $79
	push af
	cp $8
	jr nc, .asm_caff
	cp $7
	jr nc, .asm_cb05
	cp $3
	jr nc, .asm_cb0b
	jr .asm_cb11

.asm_caff
	ld a, $c
	farcall $4, $4a70

.asm_cb05
	ld a, $b
	farcall $4, $4a70

.asm_cb0b
	ld a, $a
	farcall $4, $4a70

.asm_cb11
	pop af
	pop bc
	pop hl
	ret
; 0xcb15

	INCROM $cb15, $cb1d

; returns wEventFlags byte in hl, related bits in wLoadedFlagBits
GetEventFlag: ; cb1d (3:4b1d)
	push bc
	ld c, a
	ld b, $0
	sla c
	rl b
	ld hl, EventFlagMods
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld [wLoadedFlagBits], a
	ld b, $0
	ld hl, wEventFlags
	add hl, bc
	pop bc
	ret

; offset - bytes to set or reset
EventFlagMods: ; cb37 (3:4b37)
	const_def
	flag_def EVENT_FLAG_00,           $3f, %10000000
	flag_def EVENT_FLAG_01,           $3f, %01000000
	flag_def EVENT_FLAG_02,           $3f, %00100000
	flag_def EVENT_FLAG_03,           $3f, %00010000
	flag_def EVENT_FLAG_04,           $3f, %00001000
	flag_def EVENT_FLAG_05,           $3f, %00000100
	flag_def EVENT_FLAG_06,           $3f, %00000010
	flag_def EVENT_FLAG_07,           $3f, %00000001
	flag_def EVENT_FLAG_08,           $00, %10000000
	flag_def EVENT_FLAG_09,           $00, %01000000
	flag_def EVENT_FLAG_0A,           $00, %00100000
	flag_def EVENT_BEAT_AMY,          $00, %00010000
	flag_def EVENT_FLAG_0C,           $00, %00001000
	flag_def EVENT_FLAG_0D,           $00, %00000100
	flag_def EVENT_FLAG_0E,           $00, %00000010
	flag_def EVENT_FLAG_0F,           $00, %00000001
	flag_def EVENT_FLAG_10,           $00, %11111111
	flag_def EVENT_FLAG_11,           $01, %11110000
	flag_def EVENT_FLAG_12,           $01, %00001111
	flag_def EVENT_FLAG_13,           $02, %11000000
	flag_def EVENT_FLAG_14,           $02, %00110000
	flag_def EVENT_BEAT_SARA,         $02, %00001000
	flag_def EVENT_BEAT_AMANDA,       $02, %00000100
	flag_def EVENT_FLAG_17,           $03, %11110000
	flag_def EVENT_FLAG_18,           $03, %00001111
	flag_def EVENT_FLAG_19,           $04, %11110000
	flag_def EVENT_FLAG_1A,           $04, %00001111
	flag_def EVENT_FLAG_1B,           $05, %10000000
	flag_def EVENT_FLAG_1C,           $05, %01000000
	flag_def EVENT_FLAG_1D,           $05, %00100000
	flag_def EVENT_FLAG_1E,           $05, %00010000
	flag_def EVENT_FLAG_1F,           $05, %00001111
	flag_def EVENT_FLAG_20,           $06, %11110000
	flag_def EVENT_FLAG_21,           $06, %00001100
	flag_def EVENT_FLAG_22,           $06, %00000010
	flag_def EVENT_FLAG_23,           $06, %00000001
	flag_def EVENT_FLAG_24,           $07, %11000000
	flag_def EVENT_FLAG_25,           $07, %00100000
	flag_def EVENT_FLAG_26,           $07, %00010000
	flag_def EVENT_FLAG_27,           $07, %00001000
	flag_def EVENT_FLAG_28,           $07, %00000100
	flag_def EVENT_FLAG_29,           $07, %00000010
	flag_def EVENT_FLAG_2A,           $07, %00000001
	flag_def EVENT_FLAG_2B,           $08, %11111111
	flag_def EVENT_FLAG_2C,           $09, %11100000
	flag_def EVENT_FLAG_2D,           $09, %00011111
	flag_def EVENT_FLAG_2E,           $0a, %11110000
	flag_def EVENT_FLAG_2F,           $0a, %00001000
	flag_def EVENT_FLAG_30,           $0a, %00000100
	flag_def EVENT_FLAG_31,           $0a, %00000011
	flag_def EVENT_FLAG_32,           $0b, %10000000
	flag_def EVENT_JOSHUA_STATE,      $0b, %01110000

	INCROM $cb9f, $cc32

Func_cc32: ; cc32 (3:4c32)
	push hl
	ld hl, wCurrentNPCNameTx
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	call Func_c8ba
	ret
; 0xcc3e

	INCROM $cc3e, $cc42

; called when pressing a in front of an object. creates a pointer to the data right after an RST20
; was called, then runs RunOverworldScript to handle that data
RST20: ; cc42 (3:4c42)
	pop hl
	ld a, l
	ld [wOWScriptPointer], a
	ld a, h
	ld [wOWScriptPointer+1], a
	xor a
	ld [wBreakOWScriptLoop], a
.asm_cc4f
	call RunOverworldScript
	ld a, [wBreakOWScriptLoop] ; if you break out, it jumps
	or a
	jr z, .asm_cc4f
	ld hl, wOWScriptPointer
	ld a, [hli]
	ld c, a
	ld b, [hl]
	push bc
	ret

IncreaseOWScriptPointerBy1: ; cc60 (3:4c60)
	ld a, 1
	jr IncreaseOWScriptPointer
IncreaseOWScriptPointerBy2: ; cc64 (3:4c64)
	ld a, 2
	jr IncreaseOWScriptPointer
IncreaseOWScriptPointerBy4: ; cc68 (3:4c68)
	ld a, 4
	jr IncreaseOWScriptPointer
IncreaseOWScriptPointerBy5: ; cc6c (3:4c6c)
	ld a, 5
	jr IncreaseOWScriptPointer
IncreaseOWScriptPointerBy6: ; cc70 (3:4c70)
	ld a, 6
	jr IncreaseOWScriptPointer
IncreaseOWScriptPointerBy7: ; cc74 (3:4c74)
	ld a, 7
	jr IncreaseOWScriptPointer
IncreaseOWScriptPointerBy3: ; cc78 (3:4c78)
	ld a, 3

IncreaseOWScriptPointer: ; cc7a (3:4c7a)
	ld c, a
	ld a, [wOWScriptPointer]
	add c
	ld [wOWScriptPointer], a
	ld a, [wOWScriptPointer+1]
	adc 0
	ld [wOWScriptPointer+1], a
	ret

SetOWScriptPointer: ; cc8b (3:4c8b)
	ld hl, wOWScriptPointer
	ld [hl], c
	inc hl
	ld [hl], b
	ret
; 0xcc92

	INCROM $cc92, $cc96

GetOWSArgs1AfterPointer: ; cc96 (3:4c96)
	ld a, $1
	jr GetOWSArgsAfterPointer

GetOWSArgs2AfterPointer: ; cc9a (3:4c9a)
	ld a, $2
	jr GetOWSArgsAfterPointer
GetOWSArgs3AfterPointer: ; cc9e (3:4c9e)
	ld a, $3

GetOWSArgsAfterPointer: ; cca0 (3:4ca0)
	push hl
	ld l, a
	ld a, [wOWScriptPointer]
	add l
	ld l, a
	ld a, [wOWScriptPointer+1]
	adc $0
	ld h, a
	ld a, [hli]
	ld c, a
	ld b, [hl]
	pop hl
	or b
	ret

SetScriptControlBytePass: ; ccb3 (3:4cb3)
	ld a, $ff
	ld [wScriptControlByte], a
	ret

SetScriptControlByteFail: ; ccb9 (3:4cb9)
	xor a
	ld [wScriptControlByte], a
	ret

OWScript_EndScriptLoop1: ; ccbe (3:4cbe)
OWScript_EndScriptLoop2: ; ccbe (3:4cbe)
OWScript_EndScriptLoop3: ; ccbe (3:4cbe)
OWScript_EndScriptLoop4: ; ccbe (3:4cbe)
OWScript_EndScriptLoop5: ; ccbe (3:4cbe)
OWScript_EndScriptLoop6: ; ccbe (3:4cbe)
OWScript_EndScriptLoop7: ; ccbe (3:4cbe)
OWScript_EndScriptLoop8: ; ccbe (3:4cbe)
OWScript_EndScriptLoop9: ; ccbe (3:4cbe)
OWScript_EndScriptLoop10: ; ccbe (3:4cbe)
	ld a, $01
	ld [wBreakOWScriptLoop], a
	jp IncreaseOWScriptPointerBy1

OWScript_CloseAdvancedTextBox: ; ccc6 (3:4cc6)
	call CloseAdvancedDialogueBox
	jp IncreaseOWScriptPointerBy1

OWScript_EndScriptCloseText: ; cccc (3:4ccc)
	call OWScript_CloseAdvancedTextBox
	call OWScript_EndScriptLoop1
	pop hl
	ret

; args: 2-Text String Index
OWScript_PrintTextString: ; ccd4 (3:4cd4)
	ld l, c
	ld h, b
	call Func_cc32
	jp IncreaseOWScriptPointerBy3

Func_ccdc: ; ccdc (3:4cdc)
	ld l, c
	ld h, b
	call Func_c891
	jp IncreaseOWScriptPointerBy3

Func_cce4: ; cce4 (3:4ce4)
	ld a, $1
	ld [wDefaultYesOrNo], a

; Asks the player a question then jumps if they answer yes
OWScript_AskQuestionJump: ; cce9 (3:4ce9)
	ld l, c
	ld h, b
	call Func_c8ed
	ld a, [hCurMenuItem]
	ld [wScriptControlByte], a
	jr c, .asm_ccfe
	call GetOWSArgs3AfterPointer
	jr z, .asm_ccfe
	jp SetOWScriptPointer

.asm_ccfe
	jp IncreaseOWScriptPointerBy5

; args - prize cards, deck id, duel theme index
; sets a battle up, doesn't start until we break out of the script system.
OWScript_StartBattle: ; cd01 (3:4d01)
	call Func_cd66
	ld a, [wd3b6]
	ld l, $0
	call Func_39ad
	ld a, [hl]
	farcall Func_118d3
	ld a, [wcc19]
	cp $ff
	jr nz, .asm_cd26
	ld a, [wd695]
	ld c, a
	ld b, $0
	ld hl, $4d63
	add hl, bc
	ld a, [hl]
	ld [wcc19], a
.asm_cd26
	ld a, [wd3b6]
	ld l, $0
	call Func_39ad
	ld a, [hl]
asm_cd2f
	ld [wd0c4], a
	ld [wcc14], a
	push af
	farcall Func_1c557
	ld [wd0c5], a
	pop af
	farcall Func_118a7
	ld a, GAME_EVENT_DUEL
	ld [wGameEvent], a
	ld hl, wd0b4
	set 6, [hl]
	jp IncreaseOWScriptPointerBy4

Func_cd4f: ; cd4f (3:4d4f)
	call Func_cd66
	ld a, [wd696]
	farcall Func_118bf
	ld a, $16
	ld [wMatchStartTheme], a
	ld a, [wd696]
	jr asm_cd2f

Unknown_dd63: ; cd4f (3:4d4f)
	INCROM $cd63, $cd66

Func_cd66: ; cd66 (3:4d66)
	ld a, c
	ld [wcc18], a
	ld a, b
	ld [wcc19], a
	call GetOWSArgs3AfterPointer
	ld a, c
	ld [wDuelTheme], a
	ret

Func_cd76: ; cd76 (3:4d76)
	ld a, GAME_EVENT_BATTLE_CENTER
	ld [wGameEvent], a
	ld hl, wd0b4
	set 6, [hl]
	jp IncreaseOWScriptPointerBy1

; prints text arg 1 or arg 2 depending on wScriptControlByte.
OWScript_PrintVariableText: ; cd83 (3:4d83)
	ld a, [wScriptControlByte]
	or a
	jr nz, .printText
	call GetOWSArgs3AfterPointer
.printText
	ld l, c
	ld h, b
	call Func_cc32
	jp IncreaseOWScriptPointerBy5

Func_cd94: ; cd94 (3:4d94)
	call Func_ca69
	ld b, h
Unknown_cd98:
	dec a
	and $3
	add a
	inc a
	call GetOWSArgsAfterPointer
	ld l, c
	ld h, b
	call Func_cc32
	jp IncreaseOWScriptPointerBy7

Func_cda8: ; cda8 (3:4da8)
	ld a, [wScriptControlByte]
	or a
	jr nz, .asm_cdb1
	call GetOWSArgs3AfterPointer
.asm_cdb1
	ld l, c
	ld h, b
	call Func_c891
	jp IncreaseOWScriptPointerBy5

OWScript_PrintTextCloseBox: ; cdb9 (3:4db9)
	ld l, c
	ld h, b
	call Func_cc32
	call CloseAdvancedDialogueBox
	ld a, $1
	ld [wBreakOWScriptLoop], a
	call IncreaseOWScriptPointerBy3
	pop hl
	ret

Func_cdcb: ; cdcb (3:4dcb)
	ld a, [wd3b6]
	ld [wd3aa], a
Func_cdd1: ; cdd1 (3:4dd1)
	farcall Func_1c50a
	jp IncreaseOWScriptPointerBy1

Func_cdd8: ; cdd8 (3:4dd8)
	ld a, [wd3aa]
	push af
	ld a, [wd3ab]
	push af
	ld a, [wd696]
	ld [wd3ab], a
	call Func_39c3
	call Func_cdd1
	pop af
	ld [wd3ab], a
	pop af
	ld [wd3aa], a
	ret

Func_cdf5: ; cdf5 (3:4df5)
	ld a, [wd3aa]
	push af
	ld a, [wd3ab]
	push af
	ld a, [wd696]
	ld [wd3ab], a
	ld a, c
	ld [wd3ac], a
	ld a, b
	ld [wd3ad], a
	ld a, $2
	ld [wd3ae], a
	ld a, [wd3ab]
	farcall Func_11857
	farcall Func_1c485
	pop af
	ld [wd3ab], a
	pop af
	ld [wd3aa], a
	jp IncreaseOWScriptPointerBy3

Func_ce26: ; ce26 (3:4e26)
	ld a, [wd3b6]
	ld [wd3aa], a
	farcall Func_1c455
	rlca
	add c
	ld l, a
	ld a, b
	adc $0
	ld h, a
	ld c, [hl]
	inc hl
	ld b, [hl]

Func_ce3a: ; ce3a (3:4e3a)
	farcall Func_1c78d
.asm_ce3e
	call DoFrameIfLCDEnabled
	farcall Func_1c7de
	jr nz, .asm_ce3e
	jp IncreaseOWScriptPointerBy3

Func_ce4a: ; ce4a (3:4e4a)
	ld a, [wd3b6]
	ld [wd3aa], a
	jr Func_ce3a

Func_ce52: ; ce52 (3:4e52)
	ld a, [wd3aa]
	push af
	ld a, [wd3ab]
	push af
	ld a, [wd696]
asm_ce5d
	ld [wd3ab], a
	call Func_39c3
	call Func_ce3a
	pop af
	ld [wd3ab], a
	pop af
	ld [wd3aa], a
	ret

Func_ce6f: ; ce6f (3:4e6f)
	ld a, [wd3aa]
	push af
	ld a, [wd3ab]
	push af
	ld a, c
	push af
	call GetOWSArgs2AfterPointer
	push bc
	call IncreaseOWScriptPointerBy1
	pop bc
	pop af
	jr asm_ce5d

OWScript_CloseTextBox: ; ce84 (3:4e84)
	call CloseTextBox
	jp IncreaseOWScriptPointerBy1

; args: booster pack index, booster pack index, booster pack index
OWScript_GiveBoosterPacks: ; ce8a (3:4e8a)
	xor a
	ld [wd117], a
	push bc
	call Func_c2a3
	pop bc
	push bc
	ld a, c
	farcall BoosterPack_1031b
	ld a, 1
	ld [wd117], a
	pop bc
	ld a, b
	cp $ff
	jr z, .asm_ceb4
	farcall BoosterPack_1031b
	call GetOWSArgs3AfterPointer
	ld a, c
	cp $ff
	jr z, .asm_ceb4
	farcall BoosterPack_1031b
.asm_ceb4
	call Func_c2d4
	jp IncreaseOWScriptPointerBy4

Func_ceba: ; ceba (3:4eba)
	xor a
	ld [wd117], a
	call Func_c2a3
	ld hl, $4edd
.asm_cec4
	ld a, [hl]
	cp $ff
	jr z, .asm_ced7
	push hl
	farcall BoosterPack_1031b
	ld a, $1
	ld [wd117], a
	pop hl
	inc hl
	jr .asm_cec4
.asm_ced7
	call Func_c2d4
	jp IncreaseOWScriptPointerBy1
; 0xcedd

	INCROM $cedd, $cee2

Func_cee2: ; cee2 (3:4ee2)
	call Func_c2a3
	ld a, c
	cp $ff
	jr z, .asm_cf09
	or a
	jr nz, .asm_cef0
	ld a, [wd697]

.asm_cef0
	push af
	farcall Func_10000
	farcall Func_10031
	pop af
	bank1call Func_7594
	call WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	call Func_c2d4
	jp IncreaseOWScriptPointerBy2

.asm_cf09
	xor a
	jr .asm_cef0

Func_cf0c: ; cf0c (3:4f0c)
	ld a, c
	call GetCardCountInCollectionAndDecks
	jr asm_cf16

Func_cf12: ; cf12 (3:4f12)
	ld a, c
	call GetCardCountInCollection

asm_cf16
	or a
	jr nz, asm_cf1f

asm_cf19
	call SetScriptControlByteFail
	jp IncreaseOWScriptPointerBy4

asm_cf1f
	call SetScriptControlBytePass
	call GetOWSArgs2AfterPointer
	jr z, asm_cf2a
	jp SetOWScriptPointer

asm_cf2a
	jp IncreaseOWScriptPointerBy4

Func_cf2d: ; cf2d (3:4f2d)
	push bc
	call IncreaseOWScriptPointerBy1
	pop bc
	call GetRawAmountOfCardsOwned
	ld a, h
	cp b
	jr nz, .asm_cf3b
	ld a, l
	cp c

.asm_cf3b
	jr nc, asm_cf1f
	jr asm_cf19

Func_cf3f: ; cf3f (3:4f3f)
	ld a, c
	or a
	jr nz, .asm_cf46
	ld a, [wd697]

.asm_cf46
	call AddCardToCollection
	jp IncreaseOWScriptPointerBy2

Func_cf4c: ; cf4c (3:4f4c)
	ld a, c
	call RemoveCardFromCollection
	jp IncreaseOWScriptPointerBy2

Func_cf53: ; cf53 (3:4f53)
	ld c, $1
	ld b, $0
.asm_cf57
	ld a, c
	call GetCardCountInCollection
	add b
	ld b, a
	inc c
	ld a, c
	cp $8
	jr c, .asm_cf57
	ld a, b
	or a
	jr nz, Func_cf6d
Func_cf67: ; cf67 (3:4f67)
	call SetScriptControlByteFail
	jp IncreaseOWScriptPointerBy3

Func_cf6d: ; cf6d (3:4f6d)
	call SetScriptControlBytePass
	call GetOWSArgs1AfterPointer
	jr z, .asm_cf78
	jp SetOWScriptPointer

.asm_cf78
	jp IncreaseOWScriptPointerBy3

Func_cf7b: ; cf7b (3:4f7b)
	ld c, $1
.asm_cf7d
	push bc
	ld a, c
	call GetCardCountInCollection
	jr c, .asm_cf8c
	ld b, a
.asm_cf85
	ld a, c
	call RemoveCardFromCollection
	dec b
	jr nz, .asm_cf85

.asm_cf8c
	pop bc
	inc c
	ld a, c
	cp $8
	jr c, .asm_cf7d
	jp IncreaseOWScriptPointerBy1

; This function doesn't look like a valid function, but it's pointed to in the table.
Func_cf96: ; cf96 (3:4f96)
	ld c, $0
	call Func_ca69
	ld de, $28b7
	ld hl, $08fe
	jr c, .asm_cfa4
	inc c

.asm_cfa4
	call Func_ca69
	rla
	cp $8
	jr c, .asm_cfad
	inc c

.asm_cfad
	call Func_ca69
.asm_cfb0
	jr nz, .asm_cfb0
	ld [$0138], sp
	inc c
	ld a, c
	rlca
	add $3
	call GetOWSArgsAfterPointer
	jp SetOWScriptPointer

Func_cfc0: ; cfc0 (3:4fc0)
	call GetOWSArgs1AfterPointer
	jp SetOWScriptPointer

Func_cfc6: ; cfc6 (3:4fc6)
	ld a, [wd3b6]
	ld [wd3aa], a
	ld a, c
	farcall Func_1c52e
	jp IncreaseOWScriptPointerBy2

Func_cfd4: ; cfd4 (3:4fd4)
	call Func_ca69
	dec l
	ld b, a
.asm_cfd9
	ld a, $5
	call Random
	ld e, $1
	ld c, a
	push bc
	or a
	jr z, .asm_cfea
.asm_cfe5
	sla e
	dec c
	jr nz, .asm_cfe5

.asm_cfea
	ld a, e
	and b
	pop bc
	jr nz, .asm_cfd9
	ld a, e
	or b
	push bc
	ld c, a
	call Func_ca8f
	dec l
	pop bc
	ld b, $0
	ld hl, Data_d006
	add hl, bc
	ld c, [hl]
	call Func_ca8f
	dec hl
	jp IncreaseOWScriptPointerBy1

Data_d006: ; d006 (3:5006)
	INCROM $d006, $d00b

Func_d00b: ; d00b (3:500b)
	sla c
	ld b, $0
	ld hl, wTxRam2
	add hl, bc
	push hl
	call Func_ca69
	dec hl
	ld e, a
	ld d, $0
	call GetCardName
	pop hl
	ld [hl], e
	inc hl
	ld [hl], d
	jp IncreaseOWScriptPointerBy2

Func_d025: ; d025 (3:5025)
	call Func_ca69
	dec hl
	call GetCardCountInCollectionAndDecks
	jp c, Func_cf67
	jp Func_cf6d

Func_d032: ; d032 (3:5032)
	call Func_ca69
	dec hl
	call GetCardCountInCollection
	jp c, Func_cf67
	jp Func_cf6d

Func_d03f: ; d03f (3:503f)
	call Func_ca69
	dec hl
	call RemoveCardFromCollection
	jp IncreaseOWScriptPointerBy1

OWScript_Jump: ; d049 (3:5049)
	call GetOWSArgs1AfterPointer
	jp SetOWScriptPointer

Func_d04f: ; d04f (3:504f)
	call Func_cad8
	jp IncreaseOWScriptPointerBy1

Func_d055: ; d055 (3:5055)
	ld a, c
	call Func_c5ce
	jp IncreaseOWScriptPointerBy2


OWScript_MovePlayer: ; 505c (3:505c)
	ld a, c
	ld [wd339], a
	ld a, b
	ld [wd33a], a
	call StartScriptedMovement
.asm_d067
	call DoFrameIfLCDEnabled
	call SetScreenScroll
	call Func_c53d
	ld a, [wd335]
	and $03
	jr nz, .asm_d067
	call DoFrameIfLCDEnabled
	call SetScreenScroll
	jp IncreaseOWScriptPointerBy3

OWScript_SetDialogName: ; d080 (3:5080)
	ld a, c
	farcall SetNPCDialogName
	jp IncreaseOWScriptPointerBy2

; Calls another OWSequence with a specified NPC
; Not confident enough to give it a name yet
Func_d088: ; d088 (3:5088)
	ld a, c
	ld [wd3ab], a
	call GetOWSArgs2AfterPointer
	call Func_c926
	jp IncreaseOWScriptPointerBy4

Func_d095: ; d095 (3:5095)
	ld a, [wd3b6]
	ld [wd3aa], a
	push bc
	call GetOWSArgs3AfterPointer
	ld a, [wd3b6]
	ld l, $5
	call Func_39ad
	res 4, [hl]
	ld a, [hl]
	or c
	ld [hl], a
	pop bc
	ld e, c
	ld a, [wConsole]
	cp $2
	jr nz, .asm_d0b6
	ld e, b

.asm_d0b6
	ld a, e
	farcall Func_1c57b
	jp IncreaseOWScriptPointerBy4

Func_d0be: ; d0be (3:50be)
	ld a, [wd3b6]
	ld [wd3aa], a
	ld a, c
	ld c, b
	ld b, a
	farcall Func_1c461
	jp IncreaseOWScriptPointerBy3

OWScript_DoFrames: ; d0ce (3:50ce)
	push bc
	call DoFrameIfLCDEnabled
	pop bc
	dec c
	jr nz, OWScript_DoFrames
	jp IncreaseOWScriptPointerBy2

Func_d0d9: ; d0d9 (3:50d9)
	ld a, [wd3b6]
	ld [wd3aa], a
	ld d, c
	ld e, b
	farcall Func_1c477
	ld a, e
	cp c
	jp nz, ScriptEventFailedNoJump
	ld a, d
	cp b
	jp nz, ScriptEventFailedNoJump
	jp ScriptEventPassedTryJump

Func_d0f2: ; d0f2 (3:50f2)
	ld a, [wPlayerXCoord]
	cp c
	jp nz, ScriptEventFailedNoJump
	ld a, [wPlayerYCoord]
	cp b
	jp nz, ScriptEventFailedNoJump
	jp ScriptEventPassedTryJump

Func_d103: ; d103 (3:5103)
	ld a, [wd3aa]
	push af
	ld a, [wd3ab]
	push af
	ld a, c
	ld [wd3ab], a
	call Func_39c3
	jr c, .asm_d119
	call $54d1
	jr .asm_d11c

.asm_d119
	call $54e6

.asm_d11c
	pop af
	ld [wd3ab], a
	pop af
	ld [wd3aa], a
	ret

Func_d125: ; d125 (3:5125)
	ld a, c
	push af
	call Func_c2a3
	pop af
	farcall Medal_1029e
	call Func_c2d4
	jp IncreaseOWScriptPointerBy2

Func_d135: ; d135 (3:5135)
	sla c
	ld b, $0
	ld hl, wTxRam2
	add hl, bc
	push hl
	ld a, [wd32e]
	rlca
	ld c, a
	ld b, $0
	ld hl, $5151
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ld [hl], e
	inc hl
	ld [hl], d
	jp IncreaseOWScriptPointerBy2

	INCROM $d153, $d16b

Func_d16b: ; d16b (3:516b)
	ld hl, wCurrentNPCNameTx
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	sla c
	ld b, $0
	ld hl, wTxRam2
	add hl, bc
	push hl
	ld a, [wd696]
	farcall SetNPCDialogName
	pop hl
	ld a, [wCurrentNPCNameTx]
	ld [hli], a
	ld a, [wCurrentNPCNameTx+1]
	ld [hl], a
	pop de
	ld hl, wCurrentNPCNameTx
	ld [hl], e
	inc hl
	ld [hl], d
	jp IncreaseOWScriptPointerBy2

Func_d195: ; d195 (3:5195)
	ld a, [wd3ab]
	push af
	call Func_ca69
	ld b, l
	inc a
	ld c, a
	call Func_ca8f
	ld b, l
	call Func_f580
	pop af
	ld [wd3ab], a
	jp IncreaseOWScriptPointerBy1

Func_d1ad: ; d1ad (3:51ad)
	call MainMenu_c75a
	jp IncreaseOWScriptPointerBy1

Func_d1b3: ; d1b3 (3:51b3)
	call Func_ca69
	ld b, h
	dec a
	cp $2
	jr c, .asm_d1c3
	ld a, $d
	call Random
	add $2

.asm_d1c3
	ld hl, $51dc
asm_d1c6
	ld e, a
	add a
	add e
	ld e, a
	ld d, $0
	add hl, de
	ld a, [hli]
	ld [wd697], a
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	jp IncreaseOWScriptPointerBy1

	INCROM $d1dc, $d209

Func_d209: ; d209 (3:5209)
	call Func_ca69
	ld [hl], c
	ld e, a
.asm_d20e
	call UpdateRNGSources
	ld d, $8
	and $3
	ld c, a
	ld b, a
.asm_d217
	jr z, .asm_d21e
	srl d
	dec b
	jr .asm_d217

.asm_d21e
	ld a, d
	and e
	jr nz, .asm_d20e
	push bc
	ld b, $0
	ld hl, $5240
	add hl, bc
	ld a, [hl]
	call MaxOutEventFlag
	pop bc
	ld hl, $5234
	ld a, c
	jr asm_d1c6

	INCROM $d234, $d244

Func_d244: ; d244 (3:5244)
	ld a, c
	farcall Func_80ba4
	jp IncreaseOWScriptPointerBy2

Func_d24c: ; d24c (3:524c)
	ld hl, $525e
	xor a
	call Func_d28c
	ld a, [wd695]
	ld c, a
	call Func_ca8f
	halt
	jp IncreaseOWScriptPointerBy1

	INCROM $d25e, $d271

Func_d271: ; d271 (3:5271)
	ld hl, $527b
	xor a
	call Func_d28c
	jp IncreaseOWScriptPointerBy1
; 0xd27b

	INCROM $d27b, $d28c

Func_d28c: ; d28c (3:528c)
	ld [wd416], a
	push hl
	call Func_c241
	call Func_c915
	call DoFrameIfLCDEnabled
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	or h
	jr z, .asm_d2a8
	call Func_c8ba

.asm_d2a8
	ld a, $1
	call Func_c29b
	pop hl
	inc hl
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	ld a, [wd416]
	farcall Func_111e9
	pop hl
	inc hl
	ld a, [hli]
	ld [wd417], a
	push hl

.asm_d2c1
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .asm_d2c1
	ld a, [hCurMenuItem]
	cp e
	jr z, .asm_d2d9
	ld a, [wd417]
	or a
	jr z, .asm_d2c1
	ld e, a
	ld [hCurMenuItem], a

.asm_d2d9
	pop hl
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	ld a, e
	ld [hl], a
	add a
	ld c, a
	ld b, $0
	pop hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .asm_d2f5
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a

.asm_d2f5
	ret

Func_d2f6: ; d2f6 (3:52f6)
	ld hl, $530c
	xor a
	call Func_d28c
	ld a, [wd694]
	ld c, a
	call Func_ca8f
	ld [hl], l
	xor a
	ld [wd694], a
	jp IncreaseOWScriptPointerBy1
; 0xd30c

	INCROM $d30c, $d317

Func_d317: ; d317 (3:5317)
	ld hl, $532b
	ld a, [wd694]
	call Func_d28c
	ld a, [wd694]
	ld c, a
	call Func_ca8f
	ld [hl], l
	jp IncreaseOWScriptPointerBy1


	INCROM $d32b, $d336

OWScript_OpenDeckMachine: ; d336 (3:5336)
	push bc
	call Func_c2a3
	call PauseSong
	ld a, MUSIC_DECK_MACHINE
	call PlaySong
	call EmptyScreen
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	farcall Func_1288c
	call EnableLCD
	pop bc
	ld a, c
	or a
	jr z, .asm_d360
	dec a
	ld [wd0a9], a
	farcall Func_ba04
	jr .asm_d364
.asm_d360
	farcall Func_b19d
.asm_d364
	call ResumeSong
	call Func_c2d4
	jp IncreaseOWScriptPointerBy2

Func_d36d: ; d36d (3:536d)
	ld a, [wOWScriptPointer]
	ld l, a
	ld a, [wOWScriptPointer+1]
	ld h, a
	inc hl
	ld a, [hli]
	ld a, [hli]
	ld [wd0bb], a
	ld a, [hli]
	ld [wd0bc], a
	ld a, [hli]
	ld [wd0bd], a
	ld a, [hli]
	ld [wd0be], a
	ld hl, wd0b4
	set 4, [hl]
	jp IncreaseOWScriptPointerBy6

Func_d38f: ; d38f (3:538f)
	farcall Func_10c96
	jp IncreaseOWScriptPointerBy2

Func_d396: ; d396 (3:5396)
	farcall Func_1157c
	jp IncreaseOWScriptPointerBy2

Func_d39d: ; d39d (3:539d)
	ld a, c
	or a
	jr nz, .asm_d3ac
	farcall Func_10dba
	ld c, a
	call Func_ca8f
	ld [hl], d
	jr .asm_d3b6

.asm_d3ac
	ld a, GAME_EVENT_GIFT_CENTER
	ld [wGameEvent], a
	ld hl, wd0b4
	set 6, [hl]

.asm_d3b6
	jp IncreaseOWScriptPointerBy2

Func_d3b9: ; d3b9 (3:53b9)
	call Func_3917
	ld a, GAME_EVENT_CREDITS
	ld [wGameEvent], a
	ld hl, wd0b4
	set 6, [hl]
	jp IncreaseOWScriptPointerBy1

OWScript_GivePCPack: ; d3c9 (3:53c9)
	ld a, c
	farcall GivePCPack
	jp IncreaseOWScriptPointerBy2

Func_d3d1: ; d3d1 (3:53d1)
    jp IncreaseOWScriptPointerBy1

Func_d3d4: ; d3d4 (3:53d4)
	ld a, [wd693]
	bank1call Func_7576
	jp IncreaseOWScriptPointerBy1

	INCROM $d3dd, $d3e0

Func_d3e0: ; d3e0 (3:53e0)
	ld a, $1
	ld [wd32e], a
	farcall Func_11024
.asm_d3e9
	call DoFrameIfLCDEnabled
	farcall Func_11060
	ld a, [wd33e]
	cp $2
	jr nz, .asm_d3e9
	farcall Func_10f2e
	jp IncreaseOWScriptPointerBy1

Func_d3fe: ; d3fe (3:53fe)
	ld a, c
	ld [wd112], a
	call PlaySong
	jp IncreaseOWScriptPointerBy2

Func_d408: ; d408 (3:5408)
	ld a, c
	ld [wd111], a
	jp IncreaseOWScriptPointerBy2

Func_d40f: ; d40f (3:540f)
	ld a, c
	call Func_3c83
	jp IncreaseOWScriptPointerBy2

Func_d416: ; d416 (3:5416)
	ld a, c
	call PlaySFX
	jp IncreaseOWScriptPointerBy2

Func_d41d: ; d41d (3:541d)
	call Func_39fc
	jp IncreaseOWScriptPointerBy1

Func_d423: ; d423 (3:5423)
	call PauseSong
	jp IncreaseOWScriptPointerBy1

Func_d429: ; d429 (3:5429)
	call ResumeSong
	jp IncreaseOWScriptPointerBy1

Func_d42f: ; d42f (3:542f)
	call Func_3c96
	jp IncreaseOWScriptPointerBy1

Func_d435: ; d435 (3:5435)
	ld a, c
	farcall Func_1c83d
	jp IncreaseOWScriptPointerBy2

Func_d43d: ; d43d (3:543d)
	ld a, GAME_EVENT_CHALLENGE_MACHINE
	ld [wGameEvent], a
	ld hl, wd0b4
	set 6, [hl]
	jp IncreaseOWScriptPointerBy1

; sets the event flag in arg 1 to the value in arg 2
OWScript_SetFlagValue: ; d44a (3:544a)
	ld a, c
	ld c, b
	call SetEventFlagValue
	jp IncreaseOWScriptPointerBy3

OWScript_IncrementFlagValue: ; d452 (3:5452)
	ld a, c
	push af
	call GetEventFlagValue
	inc a
	ld c, a
	pop af
	call SetEventFlagValue
	jp IncreaseOWScriptPointerBy2

OWScript_JumpIfFlagZero1: ; d460 (3:5460)
	ld a, c
	call GetEventFlagValue
	or a
	jr z, OWScript_JumpIfFlagZero1.passTryJump

.fail
	call SetScriptControlByteFail ; 0 out wScriptControlByte
	jp IncreaseOWScriptPointerBy4

.passTryJump
	call SetScriptControlBytePass ; ff wScriptControlByte
	call GetOWSArgs2AfterPointer
	jr z, .noJumpTarget
	jp SetOWScriptPointer

.noJumpTarget
	jp IncreaseOWScriptPointerBy4

OWScript_JumpIfFlagNonzero1: ; d47b (3:547b)
	ld a, c
	call GetEventFlagValue
	or a
	jr nz, OWScript_JumpIfFlagZero1.passTryJump
	jr OWScript_JumpIfFlagZero1.fail

; args - event flag, value, jump address
OWScript_JumpIfFlagEqual: ; d484 (3:5484)
	call GetEventFlagValueBC
	cp c
	jr z, ScriptEventPassedTryJump

ScriptEventFailedNoJump ; d48a (3:548a)
	call SetScriptControlByteFail
	jp IncreaseOWScriptPointerBy5

ScriptEventPassedTryJump ; d490 (3:5490)
	call SetScriptControlBytePass
	call GetOWSArgs3AfterPointer
	jr z, .noJumpAddress
	jp SetOWScriptPointer

.noJumpAddress
	jp IncreaseOWScriptPointerBy5

OWScript_JumpIfFlagNotEqual: ; d49e (3:549e)
	call GetEventFlagValueBC
	cp c
	jr nz, ScriptEventPassedTryJump
	jr ScriptEventFailedNoJump

OWScript_JumpIfFlagNotLessThan: ; d4a6 (3:54a6)
	call GetEventFlagValueBC
	cp c
	jr nc, ScriptEventPassedTryJump
	jr ScriptEventFailedNoJump

OWScript_JumpIfFlagLessThan: ; d4ae (3:54ae)
	call GetEventFlagValueBC
	cp c
	jr c, ScriptEventPassedTryJump
	jr ScriptEventFailedNoJump

; Gets event flag at c (OWScript defaults)
; c takes on the value of b as a side effect
GetEventFlagValueBC: ; d4b6 (3:54b6)
	ld a, c
	ld c, b
	call GetEventFlagValue
	ret

OWScript_MaxOutFlagValue: ; d4bc (3:54bc)
	ld a, c
	call MaxOutEventFlag
	jp IncreaseOWScriptPointerBy2

OWScript_ZeroOutFlagValue: ; d4c3 (3:54c3)
	ld a, c
	call ZeroOutEventFlag
	jp IncreaseOWScriptPointerBy2

OWScript_JumpIfFlagNonzero2: ; d4ca (3:54ca)
	ld a, c
	call GetEventFlagValue
	or a
	jr z, OWScript_JumpIfFlagZero2.fail

.passTryJump:
	call SetScriptControlBytePass
	call GetOWSArgs2AfterPointer
	jr z, .noJumpArgs
	jp SetOWScriptPointer
.noJumpArgs
	jp IncreaseOWScriptPointerBy4

OWScript_JumpIfFlagZero2:
	ld a, c
	call GetEventFlagValue
	or a
	jr z, OWScript_JumpIfFlagNonzero2.passTryJump

.fail
	call SetScriptControlByteFail
	jp IncreaseOWScriptPointerBy4
; 0xd4ec

	INCROM $d4ec, $d52e

OWSequence_d52e: ; d52e (3:552e)
	start_script
	run_script OWScript_DoFrames
	db $3c
	run_script Func_d3e0
	run_script OWScript_DoFrames
	db $78
	run_script Func_d36d
	db $02
	db $01
	db $0e
	db $1a
	db $00
	run_script OWScript_EndScriptCloseText
; 0xd53b

	INCROM $d53b, $d753

OWSequence_d753: ; d753 (3:5753)
	start_script
	run_script OWScript_MovePlayer
	db $00
	db $02
	run_script OWScript_MovePlayer
	db $00
	db $02
	run_script OWScript_MovePlayer
	db $00
	db $02
	run_script OWScript_MovePlayer
	db $00
	db $02
	run_script OWScript_MovePlayer
	db $00
	db $02
	run_script OWScript_MovePlayer
	db $00
	db $02
	run_script OWScript_MovePlayer
	db $00
	db $02
	run_script OWScript_MovePlayer
	db $00
	db $02
	run_script OWScript_MovePlayer
	db $00
	db $02
	run_script OWScript_PrintTextString
	tx Text05e3
	run_script OWScript_CloseAdvancedTextBox
	run_script Func_d088
	db SAM
	dw OWSequence_d779
	run_script OWScript_EndScriptLoop1
	ret

OWSequence_d779: ; d779 (03:5779)
	start_script
	run_script Func_ce4a ; handles some sort of npc movement, and rotation?
	db $80
	db $58
	run_script OWScript_PrintTextString
	tx Text05e4
	run_script OWScript_SetDialogName
	db DRMASON
	run_script OWScript_PrintTextString
	tx Text05e5
	run_script OWScript_CloseTextBox
	run_script Func_ce4a
	db $82
	db $58
	run_script Func_cfc6
	db $01
	run_script Func_d055
	db $03
	run_script OWScript_CloseAdvancedTextBox
	run_script Func_d088
	db $01
	db $94
	db $57
	run_script OWScript_EndScriptLoop1

	INCROM $d793, $e13f

WaterClubMovePlayer: ; e13f (3:613f)
	ld a, [wPlayerYCoord]
	cp $8
	ret nz
	call Func_ca69
	inc sp
	cp $2
	ret nc
	ld a, $21
	ld [wd3ab], a
	ld bc, OWSequence_NotReadyToSeeAmy
	jp Func_c926

WaterClubAfterDuel: ;e157 (3:6157)
	ld hl, .after_duel_table
	call FindEndOfBattleScript
	ret

.after_duel_table
	db SARA
	db SARA
	dw OWSequence_BeatSara
	dw OWSequence_LostToSara

	db AMANDA
	db AMANDA
	dw OWSequence_BeatAmanda
	dw OWSequence_LostToAmanda

	db JOSHUA
	db JOSHUA
	dw OWSequence_BeatJoshua
	dw OWSequence_LostToJoshua

	db AMY
	db AMY
	dw OWSequence_BeatAmy
	dw OWSequence_LostToAmy
	db $00

OWSequence_Sara: ; e177 (3:6177)
	start_script
	run_script OWScript_PrintTextString
	tx Text042c
	run_script OWScript_AskQuestionJump
	tx Text042d
	dw .yes_duel
	run_script OWScript_PrintTextString
	tx Text042e
	run_script OWScript_EndScriptCloseText
.yes_duel
	run_script OWScript_PrintTextString
	tx Text042f
	run_script OWScript_StartBattle
	db PRIZES_2
	db WATERFRONT_POKEMON_DECK_ID ; 6189
	db MUSIC_DUEL_THEME_1
	run_script OWScript_EndScriptCloseText

OWSequence_BeatSara: ; e18c (3:618c)
	start_script
	run_script OWScript_MaxOutFlagValue
	db EVENT_BEAT_SARA
	run_script OWScript_PrintTextString
	tx Text0430
	run_script OWScript_GiveBoosterPacks
	db BOOSTER_COLOSSEUM_WATER
	db BOOSTER_COLOSSEUM_WATER
	db NO_BOOSTER
	run_script OWScript_PrintTextString
	tx Text0431
	run_script OWScript_EndScriptCloseText

OWSequence_LostToSara: ; e19a (03:619a)
	start_script
	run_script OWScript_PrintTextCloseBox
	tx Text0432

OWSequence_Amanda: ; e19e (03:619e)
	start_script
	run_script OWScript_PrintTextString
	tx Text0433
	run_script OWScript_AskQuestionJump
	tx Text0434
	dw .yes_duel
	run_script OWScript_PrintTextString
	tx Text0435
	run_script OWScript_EndScriptCloseText
.yes_duel
	run_script OWScript_PrintTextString
	tx Text0436
	run_script OWScript_StartBattle
	db PRIZES_3
	db LONELY_FRIENDS_DECK_ID
	db MUSIC_DUEL_THEME_1
	run_script OWScript_EndScriptCloseText

OWSequence_BeatAmanda: ; e1b3 (03:61b3)
	start_script
	run_script OWScript_MaxOutFlagValue
	db EVENT_BEAT_AMANDA
	run_script OWScript_PrintTextString
	tx Text0437
	run_script OWScript_GiveBoosterPacks
	db BOOSTER_MYSTERY_LIGHTNING_COLORLESS
	db BOOSTER_MYSTERY_LIGHTNING_COLORLESS
	db NO_BOOSTER
	run_script OWScript_PrintTextString
	tx Text0438
	run_script OWScript_EndScriptCloseText

OWSequence_LostToAmanda: ; e1c1 (03:61c1)
	start_script
	run_script OWScript_PrintTextCloseBox
	tx Text0439

OWSequence_NotReadyToSeeAmy:
	start_script
	run_script Func_d0f2
	db $12
	db $08
	dw $61ec
	run_script Func_d0f2
	db $14
	db $08
	dw $61f2
	run_script Func_d0f2
	db $18
	db $08
	dw $61f8
	run_script OWScript_MovePlayer
	db $02
	db $04
	run_script Func_ce4a
	db $13
	db $62
	run_script OWScript_PrintTextString
	tx Text043a
	run_script Func_d0f2
	db $12
	db $0a
	dw $61fe
	run_script Func_d0f2
	db $14
	db $0a
	dw $6202
	run_script Func_ce4a
	db $15
	db $62
	run_script OWScript_EndScriptCloseText

.ows_e1ec
	run_script Func_ce4a
	db $06
	db $62
	run_script OWScript_Jump
	dw $61d5
	run_script Func_ce4a
	db $0b
	db $62
	run_script OWScript_Jump
	dw $61d5
	run_script Func_ce4a
	db $0f
	db $62
	run_script OWScript_Jump
	dw $61d5
	run_script Func_ce4a
	db $18
	db $62
	run_script OWScript_EndScriptCloseText
; 0xe202

	INCROM $e202, $e21c

OWSequence_Joshua:
	start_script
	run_script OWScript_JumpIfFlagZero2
	db EVENT_BEAT_AMANDA
	dw .sara_and_amanda_not_beaten
	run_script OWScript_JumpIfFlagZero2
	db EVENT_BEAT_SARA
	dw .sara_and_amanda_not_beaten
	run_script OWScript_Jump
	dw .beat_sara_and_amanda
.sara_and_amanda_not_beaten
	run_script OWScript_SetFlagValue
	db EVENT_JOSHUA_STATE
	db JOSHUA_TALKED
	run_script OWScript_PrintTextString
	tx Text043b
	run_script OWScript_EndScriptCloseText

.beat_sara_and_amanda
	run_script OWScript_JumpIfFlagNonzero1
	db EVENT_JOSHUA_STATE
	dw .already_talked
	run_script OWScript_SetFlagValue
	db EVENT_JOSHUA_STATE
	db JOSHUA_TALKED
	run_script OWScript_PrintTextString
	tx Text043b
	run_script OWScript_PrintTextString
	tx Text043c
.already_talked
	run_script OWScript_JumpIfFlagEqual
	db EVENT_JOSHUA_STATE
	db JOSHUA_TALKED
	dw NO_JUMP
	run_script OWScript_PrintVariableText
	tx Text043d
	tx Text043e
	run_script OWScript_AskQuestionJump
	tx Text043f
	dw .startDuel
	run_script OWScript_JumpIfFlagEqual
	db EVENT_JOSHUA_STATE
	db JOSHUA_TALKED
	dw NO_JUMP
	run_script OWScript_PrintVariableText
	tx Text0440
	tx Text0441
	run_script OWScript_EndScriptCloseText

.startDuel:
	run_script OWScript_PrintTextString
	tx Text0442
	run_script OWScript_GivePCPack
	db $04
	run_script OWScript_StartBattle
	db PRIZES_4
	db SOUND_OF_THE_WAVES_DECK_ID
	db MUSIC_DUEL_THEME_1
	run_script OWScript_EndScriptCloseText

OWSequence_LostToJoshua: ; e260 (3:6260)
	start_script
	run_script OWScript_JumpIfFlagEqual
	db EVENT_JOSHUA_STATE
	db JOSHUA_TALKED
	dw NO_JUMP
	run_script OWScript_PrintVariableText
	tx Text0443
	tx Text0444
	run_script OWScript_EndScriptCloseText

OWSequence_BeatJoshua: ; e26c (3:626c)
	start_script
	run_script OWScript_JumpIfFlagEqual
	db EVENT_JOSHUA_STATE
	db JOSHUA_TALKED
	dw NO_JUMP
	run_script OWScript_PrintVariableText
	tx Text0445
	tx Text0446
	run_script OWScript_GiveBoosterPacks
	db BOOSTER_MYSTERY_WATER_COLORLESS
	db BOOSTER_MYSTERY_WATER_COLORLESS
	db NO_BOOSTER
	run_script OWScript_JumpIfFlagEqual
	db EVENT_JOSHUA_STATE
	db JOSHUA_TALKED
	dw NO_JUMP
	run_script OWScript_PrintVariableText
	tx Text0447
	tx Text0448
	run_script OWScript_JumpIfFlagNotEqual
	db EVENT_JOSHUA_STATE
	db JOSHUA_BEATEN
	dw .firstJoshuaWin
	run_script OWScript_EndScriptCloseText

.firstJoshuaWin:
	run_script OWScript_SetFlagValue
	db EVENT_JOSHUA_STATE
	db JOSHUA_BEATEN
	run_script OWScript_PrintTextString
	tx Text0449
	run_script OWScript_CloseTextBox
	run_script Func_ce26
	dw $62a1
	run_script OWScript_PrintTextString
	tx Text044a
	run_script Func_cfc6
	db $00
	run_script OWScript_CloseAdvancedTextBox
	run_script Func_d088
	db AMY
	dw OWSequence_MeetAmy
	run_script OWScript_EndScriptLoop1
; 0xe2a0

	INCROM $e2a0, $e2d1

OWSequence_MeetAmy: ; e2d1 (3:62d1)
	start_script
	run_script OWScript_PrintTextString
	tx Text044b
	run_script OWScript_SetDialogName
	db JOSHUA
	run_script OWScript_PrintTextString
	tx Text044c
	run_script OWScript_SetDialogName
	db AMY
	run_script OWScript_PrintTextString
	tx Text044d
	run_script OWScript_CloseTextBox
	run_script Func_d095
	db $09
	db $2f
	db $10
	run_script OWScript_DoFrames
	db $20
	run_script Func_d095
	db $04
	db $0e
	db $00
	run_script Func_d0be
	db $14
	db $04
	run_script Func_d055
	db $03
	run_script OWScript_MovePlayer
	db $03
	db $01
	run_script Func_d055
	db $00
	run_script OWScript_MovePlayer
	db $00
	db $01
	run_script OWScript_MovePlayer
	db $00
	db $01
	run_script Func_ce6f
	db $21
	db $ab
	db $62
	run_script OWScript_PrintTextString
	tx Text044e
	run_script OWScript_Jump
	dw OWSequence_Amy.askConfirmDuel

OWSequence_Amy: ; e304 (3:6304)
	start_script
	run_script OWScript_JumpIfFlagNonzero2
	db EVENT_BEAT_AMY
	dw OWJump_TalkToAmyAgain
	run_script OWScript_PrintTextString
	tx Text044f
.askConfirmDuel
	run_script OWScript_AskQuestionJump
	tx Text0450
	dw .startDuel

.denyDuel
	run_script OWScript_PrintTextString
	tx Text0451
	run_script Func_d0d9
	db $14
	db $04
	dw OWSequence_LostToAmy.ows_e34e
	run_script OWScript_EndScriptCloseText

.startDuel
	run_script OWScript_PrintTextString
	tx Text0452
	run_script OWScript_StartBattle
	db PRIZES_6
	db GO_GO_RAIN_DANCE_DECK_ID
	db MUSIC_DUEL_THEME_2
	run_script OWScript_EndScriptCloseText

OWSequence_BeatAmy: ; e322 (3:6322)
	start_script
	run_script OWScript_PrintTextString
	tx Text0453
	run_script OWScript_JumpIfFlagNonzero2
	db EVENT_BEAT_AMY
	dw .beatAmyCommon
	run_script OWScript_PrintTextString
	tx Text0454
	run_script OWScript_MaxOutFlagValue
	db EVENT_BEAT_AMY
	run_script Func_d04f
	run_script Func_d125
	db EVENT_BEAT_AMY
	run_script Func_d435
	db $03
	run_script OWScript_PrintTextString
	tx Text0455
.beatAmyCommon
	run_script OWScript_GiveBoosterPacks
	db BOOSTER_LABORATORY_WATER
	db BOOSTER_LABORATORY_WATER
	db NO_BOOSTER
	run_script OWScript_PrintTextString
	tx Text0456
	run_script Func_d0d9
	db $14
	db $04
	dw OWSequence_LostToAmy.ows_e34e
	run_script OWScript_EndScriptCloseText

OWSequence_LostToAmy: ; e344 (3:6344)
	start_script
	run_script OWScript_PrintTextString
	tx Text0457
	run_script Func_d0d9
	db $14
	db $04
	dw .ows_e34e
	run_script OWScript_EndScriptCloseText

.ows_e34e
	run_script Func_d095
	db $08
	db $2e
	db $10
	run_script Func_d0be
	db $16
	db $04
	run_script OWScript_EndScriptCloseText

OWJump_TalkToAmyAgain: ; e356 (3:6356)
	run_script OWScript_PrintTextString
	tx Text0458
	run_script OWScript_AskQuestionJump
	tx Text0450
	dw .startDuel
	run_script OWScript_Jump
	dw OWSequence_Amy.denyDuel

.startDuel
	run_script OWScript_PrintTextString
	tx Text0459
	run_script OWScript_StartBattle
	db PRIZES_6
	db GO_GO_RAIN_DANCE_DECK_ID
	db MUSIC_DUEL_THEME_2
	run_script OWScript_EndScriptCloseText
; 0xe369

	INCROM $e369, $e52c

FindEndOfBattleScript: ; e52c (3:652c)
	ld c, $0
	ld a, [wDuelResult]
	or a ; cp DUEL_WIN
	jr z, .player_won
	ld c, $2

.player_won
	ld a, [wd0c4]
	ld b, a
	ld de, $0005
.check_enemy_byte_loop
	ld a, [hli]
	or a
	ret z
	cp b
	jr z, .found_enemy
	add hl, de
	jr .check_enemy_byte_loop

.found_enemy
	ld a, [hli]
	ld [wd3ab], a
	ld b, $0
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	jp Func_c926
; 0xe553

	INCROM $e553, $f580

Func_f580: ; f580 (3:7580)
	call Func_ca69
	ld b, h
	cp $3
	jr z, .asm_f596
	call Func_ca69
	ld b, l
	cp $3
	ld d, $18
	jr nz, .asm_f598
	ld a, $2
	jr .asm_f5ac

.asm_f596
	ld d, $19

.asm_f598
	ld a, d
	call Random
	ld c, a
	call $75cc
	jr c, .asm_f598
	call $75d4
	ld b, $0
	ld hl, $75b3
	add hl, bc
	ld a, [hl]

.asm_f5ac
	ld [wd3ab], a
	ld [wd696], a
	ret
; 0xf5b3

	INCROM $f5b3, $fc2b

Func_fc2b: ; fc2b (3:7c2b)
	ld a, [wDuelResult]
	cp 2
	jr c, .asm_fc34
	ld a, $2
.asm_fc34
	rlca
	ld c, a
	ld b, $0
	ld hl, PointerTable_fc4c
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, $b0
	ld [wCurrentNPCNameTx], a
	ld a, $3
	ld [wCurrentNPCNameTx+1], a
	jp Func_c935

PointerTable_fc4c: ; fc4c (3:7c4c)
	dw Unknown_fc64
	dw Unknown_fc68
	dw Unknown_fc60

	INCROM $fc52, $fc60

Unknown_fc60: ; fc60 (3:7c60)
	INCROM $fc60, $fc64

Unknown_fc64: ; fc64 (3:7c64)
	INCROM $fc64, $fc68

Unknown_fc68: ; fc68 (3:7c68)
	INCROM $fc68, $fcad

Func_fcad: ; fcad (3:7cad)
	INCROM $fcad, $10000
