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
.warp
	farcall Func_10ab4
	call WhiteOutDMGPals
	call Func_c241
	call EmptyScreen
	call Func_3ca0
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	farcall ClearNPCs
	ld a, [wTempMap]
	ld [wCurMap], a
	ld a, [wTempPlayerXCoord]
	ld [wPlayerXCoord], a
	ld a, [wTempPlayerYCoord]
	ld [wPlayerYCoord], a
	call Func_c36a
	call Func_c184
	call Func_c49c
	farcall LoadMapGfxAndPermissions
	call Func_c4b9
	call Func_c943
	call Func_c158
	farcall DoMapOWFrame
	call SetOverworldDoFrameFunction
	xor a
	ld [wOverworldTransition], a
	ld [wd0c1], a
	call PlayDefaultSong
	farcall Func_10af9
	call Func_c141
	call Func_c17a
.overworld_loop
	call DoFrameIfLCDEnabled
	call SetScreenScroll
	call HandleOverworldMode
	ld hl, wOverworldTransition
	ld a, [hl]
	and %11010000
	jr z, .overworld_loop
	call DoFrameIfLCDEnabled
	ld hl, wOverworldTransition
	ld a, [hl]
	bit 4, [hl]
	jr z, .no_warp
	ld a, SFX_0C
	call PlaySFX
	jp .warp
.no_warp
	farcall Func_10ab4
	call Func_c1a0
	ld a, [wMatchStartTheme]
	or a
	jr z, .no_duel
	call Func_c280
	farcall Duel_Init
.no_duel
	call Func_c280
	ret

HandleOverworldMode: ; c0ce (3:40ce)
	ld a, [wOverworldMode]
	res 7, a
	rlca
	add LOW(OverworldModePointers)
	ld l, a
	ld a, HIGH(OverworldModePointers)
	adc $0
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

OverworldModePointers: ; c0e0 (3:40e0)
	dw UpdateOverworldMap
	dw CallHandlePlayerMoveMode
	dw SetScriptData
	dw EnterScript

UpdateOverworldMap: ; c0e8 (3:40e8)
	farcall OverworldMap_Update
	ret

CallHandlePlayerMoveMode: ; c0ed (3:40ed)
	call HandlePlayerMoveMode
	ret

SetScriptData: ; c0f1 (3:40f1)
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
	farcall SetNewScriptNPC
	ld a, c
	ld [wNextScript], a
	ld a, b
	ld [wNextScript + 1], a
	ld a, OWMODE_SCRIPT
	ld [wOverworldMode], a
	jr EnterScript

EnterScript: ; c10a (3:410a)
	ld hl, wNextScript
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
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
	farcall Func_1c5e9
.asm_c12a
	xor a
	ld [wd0c1], a
	ld a, [wd0c0]
	ld [wOverworldMode], a
	ret

; redraws the background and removes textbox control
CloseTextBox: ; c135 (3:4135)
	push hl
	farcall ReloadMapAfterTextClose
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
	ld a, [wNPCDuelist]
	ld [wTempNPC], a
	call FindLoadedNPC
	jr c, .asm_c179
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	ld a, [wd0c5]
	ld [hl], a
	farcall UpdateNPCAnimation
.asm_c179
	ret

Func_c17a: ; c17a (3:417a)
	ld a, [wOverworldMode]
	cp OWMODE_SCRIPT
	ret z
	call Func_c9b8
	ret

Func_c184: ; c184 (3:4184)
	push bc
	ld c, OWMODE_MOVE
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .not_map
	ld c, OWMODE_MAP
.not_map
	ld a, c
	ld [wOverworldMode], a
	ld [wd0c0], a
	pop bc
	ret

SetOverworldDoFrameFunction: ; c199 (3:4199)
	ld hl, OverworldDoFrameFunction
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
	ld a, OWMAP_POKEMON_DOME
	ld [wOverworldMapSelection], a
	ld a, OVERWORLD_MAP
	ld [wTempMap], a
	ld a, $c
	ld [wTempPlayerXCoord], a
	ld a, $c
	ld [wTempPlayerYCoord], a
	ld a, SOUTH
	ld [wTempPlayerDirection], a
	call ClearEvents
	call DetermineImakuniAndChallengeHall
	farcall Func_80b7a
	farcall ClearMasterBeatenList
	farcall Func_131b3
	xor a
	ld [wPlayTimeCounter + 0], a
	ld [wPlayTimeCounter + 1], a
	ld [wPlayTimeCounter + 2], a
	ld [wPlayTimeCounter + 3], a
	ld [wPlayTimeCounter + 4], a
	ret

Func_c1ed: ; c1ed (3:41ed)
	call ClearEvents
	farcall LoadBackupSaveData
	call DetermineImakuniAndChallengeHall
	ret

Func_c1f8: ; c1f8 (3:41f8)
	xor a
	ld [wd0b8], a
	ld [wd0b9], a
	ld [wd0ba], a
	ld [wConfigCursorYPos], a
	ld [wd0c2], a
	ld [wDefaultSong], a
	ld [wd112], a
	ld [wRonaldIsInMap], a
	call EnableSRAM
	ld a, [sAnimationsDisabled]
	ld [wAnimationsDisabled], a
	ld a, [sTextSpeed]
	ld [wTextSpeed], a
	call DisableSRAM
	farcall Func_10756
	ret

BackupPlayerPosition: ; c228 (3:4228)
	ld a, [wCurMap]
	ld [wTempMap], a
	ld a, [wPlayerXCoord]
	ld [wTempPlayerXCoord], a
	ld a, [wPlayerYCoord]
	ld [wTempPlayerYCoord], a
	ld a, [wPlayerDirection]
	ld [wTempPlayerDirection], a
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
	jr Func_c258.asm_c25d

Func_c258: ; c258 (3:4258)
	ldh a, [hffb0]
	push af
	ld a, $2
.asm_c25d
	ldh [hffb0], a
	push hl
	call Func_c268
	pop hl
	pop af
	ldh [hffb0], a
	ret

Func_c268: ; c268 (3:4268)
	ld hl, PauseMenuTextList
.loop
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .done
	call ProcessTextFromID
	pop hl
	inc hl
	inc hl
	jr .loop
.done
	pop hl
	ret

PauseMenuTextList: ; c27c (3:427c)
	tx PauseMenuOptionsText
	dw NULL

Func_c280: ; c280 (3:4280)
	call BackupPlayerPosition
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
	ld a, [wDefaultSong]
	push af
	farcall LoadMapGfxAndPermissions
	pop af
	ld [wDefaultSong], a
	ld hl, wd0c1
	res 0, [hl]
	call Func_c34e
	farcall Func_12c5e
	farcall SetAllNPCTilePermissions
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
	ld [wOWMapEvents], a
	ld a, [wCurMap]
	cp POKEMON_DOME_ENTRANCE
	jr nz, .asm_c379
	xor a
	ld [wOWMapEvents + 1], a
.asm_c379
	ret

; loads in wPermissionMap the permissions
; of the map, which has its compressed permission data
; pointed by wBGMapPermissionDataPtr
LoadPermissionMap: ; c37a (3:437a)
	push hl
	push bc
	ld hl, wPermissionMap
	push hl
	ld a, $80 ; impassable and untalkable
	ld c, $00
.loop_map
	ld [hli], a
	dec c
	jr nz, .loop_map
	pop hl
	call DecompressPermissionMap
	pop bc
	pop hl
	ret

; decompresses permission data pointed by wBGMapPermissionDataPtr
; hl = address to write to
DecompressPermissionMap: ; c38f (3:438f)
	push hl
	push bc
	ld a, [wBGMapPermissionDataPtr]
	ld e, a
	ld a, [wBGMapPermissionDataPtr + 1]
	ld d, a
	or e
	jr z, .skip

; permissions are applied to 2x2 square tiles
; so the data is half the width and height
; of the actual tile map
	push hl
	ld b, HIGH(wDecompressionSecondaryBuffer)
	call InitDataDecompression
	ld a, [wd23d]
	ld [wTempPointerBank], a
	ld a, [wBGMapHeight]
	inc a
	srl a
	ld b, a ; (height + 1) / 2
	ld a, [wBGMapWidth]
	inc a
	srl a
	ld c, a ; (width + 1) / 2
	pop de

.loop
	push bc
	ld b, 0 ; one row (with width in c)
	call DecompressDataFromBank
	ld hl, $10 ; next row
	add hl, de
	ld d, h
	ld e, l
	pop bc
	dec b
	jr nz, .loop

.skip
	pop bc
	pop hl
	ret

Func_c3ca: ; c3ca (3:43ca)
	push hl
	push bc
	push de
	push bc
	push de
	pop bc
	call GetPermissionByteOfMapPosition
	pop bc
	srl b
	srl c
	ld de, $10
.asm_c3db
	push bc
	push hl
.asm_c3dd
	ld a, [hl]
	or $10
	ld [hli], a
	dec b
	jr nz, .asm_c3dd
	pop hl
	add hl, de
	pop bc
	dec c
	jr nz, .asm_c3db
	pop de
	pop bc
	pop hl
	ret

; removes flag in whole wPermissionMap
; most likely relate to menu and text boxes
Func_c3ee: ; c3ee (3:43ee)
	push hl
	push bc
	ld c, $00
	ld hl, wPermissionMap
.loop
	ld a, [hl]
	and ~$10 ; removes this flag
	ld [hli], a
	dec c
	jr nz, .loop
	pop bc
	pop hl
	ret

Func_c3ff: ; c3ff (3:43ff)
	ld a, [wBGMapWidth]
	sub $14
	ld [wd237], a
	ld a, [wBGMapHeight]
	sub $12
	ld [wd238], a
	call Func_c41c
	call Func_c469
	call SetScreenScrollWram
	call SetScreenScroll
	ret

Func_c41c: ; c41c (3:441c)
	ld a, [wPlayerXCoordPixels]
	sub $40
	ld [wSCXBuffer], a
	ld a, [wPlayerYCoordPixels]
	sub $40
	ld [wSCYBuffer], a
	call Func_c430
	ret

Func_c430: ; c430 (3:4430)
; update wSCXBuffer
	push bc
	ld a, [wd237]
	sla a
	sla a
	sla a ; *8
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

; update wSCYBuffer
	ld a, [wd238]
	sla a
	sla a
	sla a ; *8
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
	ld [wPlayerXCoordPixels], a
	ld a, [wPlayerYCoord]
	and $1f
	ld [wPlayerYCoord], a
	rlca
	rlca
	rlca
	ld [wPlayerYCoordPixels], a
	ret

Func_c4b9: ; c4b9 (3:44b9)
	xor a
	ld [wVRAMTileOffset], a
	ld [wd4cb], a
	ld a, PALETTE_29
	farcall LoadPaletteData
	ld b, $0
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld b, $1e
.not_cgb
	ld a, b
	ld [wd337], a

	; load Player's sprite for overworld
	ld a, SPRITE_OW_PLAYER
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [wPlayerSpriteIndex], a

	ld b, SOUTH
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr z, .ow_map
	ld a, [wTempPlayerDirection]
	ld b, a
.ow_map
	ld a, b
	ld [wPlayerDirection], a
	call UpdatePlayerSprite
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	call nz, Func_c6f7
	xor a
	ld [wPlayerCurrentlyMoving], a
	ld [wd338], a
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .not_ow_map
	farcall OverworldMap_InitCursorSprite
.not_ow_map
	ret

HandlePlayerMoveMode: ; c510 (3:4510)
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wPlayerCurrentlyMoving]
	bit 4, a
	ret nz
	bit 0, a
	call z, HandlePlayerMoveModeInput
	ld a, [wPlayerCurrentlyMoving]
	or a
	jr z, .not_moving
	bit 0, a
	call nz, Func_c66c
	ld a, [wPlayerCurrentlyMoving]
	bit 1, a
	call nz, Func_c6dc
	ret

.not_moving
	ldh a, [hKeysPressed]
	and START
	call nz, OpenPauseMenu
	ret

Func_c53d: ; c53d (3:453d)
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wPlayerCurrentlyMoving]
	bit 0, a
	call nz, Func_c687
	ld a, [wPlayerCurrentlyMoving]
	bit 1, a
	call nz, Func_c6dc
	ret

Func_c554: ; c554 (3:4554)
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .not_ow_map
	farcall OverworldMap_UpdatePlayerAndCursorSprites
	ret

.not_ow_map
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
	ld a, [wPlayerXCoordPixels]
	sub d
	add $8
	ld [hli], a
	ld a, [wPlayerYCoordPixels]
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
	ld c, SPRITE_ANIM_FLAGS
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

HandlePlayerMoveModeInput: ; c5ac (3:45ac)
	ldh a, [hKeysHeld]
	and D_PAD
	jr z, .skip_moving
	call UpdatePlayerDirectionFromDPad
	call AttemptPlayerMovementFromDirection
	ld a, [wPlayerCurrentlyMoving]
	and $1
	jr nz, .done
.skip_moving
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .done
	call FindNPCOrObject
	jr .done
.done
	ret

UpdatePlayerDirectionFromDPad: ; c5cb (3:45cb)
	call GetDirectionFromDPad
UpdatePlayerDirection: ; c5ce (3:45ce)
	ld [wPlayerDirection], a
	call UpdatePlayerSprite
	ret

GetDirectionFromDPad: ; c5d5 (3:45d5)
	push hl
	ld hl, KeypadDirectionMap
	or a
	jr z, .get_direction
.loop
	rlca
	jr c, .get_direction
	inc hl
	jr .loop
.get_direction
	ld a, [hl]
	pop hl
	ret

KeypadDirectionMap: ; c5e5 (3:45e5)
	db SOUTH, NORTH, WEST, EAST

; Updates sprite depending on direction
UpdatePlayerSprite: ; c5e9 (3:45e9)
	push bc
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wd337]
	ld b, a
	ld a, [wPlayerDirection]
	add b
	farcall StartNewSpriteAnimation
	pop bc
	ret

AttemptPlayerMovementFromDirection: ; c5fe (3:45fe)
	push bc
	call FindPlayerMovementFromDirection
	call AttemptPlayerMovement
	pop bc
	ret

StartScriptedMovement: ; c607 (3:4607)
	push bc
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wd339]
	call FindPlayerMovementWithOffset
	call AttemptPlayerMovement
	pop bc
	ret

; bc is the location the player is being scripted to move towards.
AttemptPlayerMovement: ; c619 (3:4619)
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
	ld a, [wPlayerCurrentlyMoving] ; I believe everything starting here is animation related.
	or $1
	ld [wPlayerCurrentlyMoving], a
	ld a, $10
	ld [wd338], a
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	set 2, [hl]
	ld c, SPRITE_ANIM_COUNTER
	call GetSpriteAnimBufferProperty
	ld a, $4
	ld [hl], a
.quit_movement
	pop bc
	pop hl
	ret

FindPlayerMovementFromDirection: ; c653 (3:4653)
	ld a, [wPlayerDirection]

FindPlayerMovementWithOffset: ; c656 (3:4656)
	rlca
	ld c, a
	ld b, $0
	push hl
	ld hl, PlayerMovementOffsetTable_Tiles
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
	ld a, [wPlayerDirection]
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
	ld hl, PlayerMovementOffsetTable
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
	ld hl, wPlayerCurrentlyMoving
	set 1, [hl]
.asm_c6c3
	call Func_c41c
	call Func_c469
	pop bc
	pop hl
	ret

Func_c6cc: ; c6cc (3:46cc)
	push hl
	ld hl, wPlayerXCoordPixels
	add [hl]
	ld [hl], a
	pop hl
	ret

Func_c6d4: ; c6d4 (3:46d4)
	push hl
	ld hl, wPlayerYCoordPixels
	add [hl]
	ld [hl], a
	pop hl
	ret

Func_c6dc: ; c6dc (3:46dc)
	push hl
	ld hl, wPlayerCurrentlyMoving
	res 0, [hl]
	res 1, [hl]
	call Func_c6f7
	call Func_3997
	call Func_c70d
	ld a, [wOverworldMode]
	cp OWMODE_MOVE
	call z, Func_c9c0
	pop hl
	ret

Func_c6f7: ; c6f7 (3:46f7)
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	res 2, [hl]
	ld c, SPRITE_ANIM_COUNTER
	call GetSpriteAnimBufferProperty
	ld a, $ff
	ld [hl], a
	ret

Func_c70d: ; c70d (3:470d)
	push hl
	ld hl, wTempMap
	ld a, [wCurMap]
	cp [hl]
	jr z, .asm_c71c
	ld hl, wOverworldTransition
	set 4, [hl]
.asm_c71c
	pop hl
	ret

; Arrives here if A button is pressed when not moving + in map move state
FindNPCOrObject: ; c71e (3:471e)
	ld a, $ff
	ld [wScriptNPC], a
	call FindPlayerMovementFromDirection
	call GetPermissionOfMapPosition
	and $40
	jr z, .no_npc
	farcall FindNPCAtLocation
	jr c, .no_npc
	ld a, [wLoadedNPCTempIndex]
	ld [wScriptNPC], a
	ld a, OWMODE_START_SCRIPT
	jr .set_mode

.no_npc
	call HandleMoveModeAPress
	jr nc, .exit
	ld a, OWMODE_SCRIPT
	jr .set_mode
.exit
	or a
	ret

.set_mode
	ld [wOverworldMode], a
	scf
	ret

OpenPauseMenu: ; c74d (3:474d)
	push hl
	push bc
	push de
	call PauseMenu
	call CloseAdvancedDialogueBox
	pop de
	pop bc
	pop hl
	ret

PauseMenu: ; c75a (3:475a)
	call PauseSong
	ld a, MUSIC_PAUSE_MENU
	call PlaySong
	call Func_c797
.loop
	ld a, $1
	call Func_c29b
.wait_input
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .wait_input
	ld a, e
	ld [wd0b8], a
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .exit
	cp $5
	jr z, .exit
	call Func_c2a3
	ld a, [wd0b8]
	ld hl, PauseMenuPointerTable
	call JumpToFunctionInTable
	ld hl, Func_c797
	call Func_c32b
	jr .loop
.exit
	call ResumeSong
	ret

Func_c797: ; c797 (3:4797)
	ld a, [wd0b8]
	ld hl, Unknown_10d98
	farcall InitAndPrintPauseMenu
	ret

PauseMenuPointerTable: ; c7a2 (3:47a2)
	dw PauseMenu_Status
	dw PauseMenu_Diary
	dw PauseMenu_Deck
	dw PauseMenu_Card
	dw PauseMenu_Config
	dw PauseMenu_Exit

PauseMenu_Status: ; c7ae (3:47ae)
	farcall _PauseMenu_Status
	ret

PauseMenu_Diary: ; c7b3 (3:47b3)
	farcall _PauseMenu_Diary
	ret

PauseMenu_Deck: ; c7b8 (3:47b8)
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall Func_1288c
	farcall DeckSelectionMenu
	call Set_OBJ_8x8
	ret

PauseMenu_Card: ; c7cc (3:47cc)
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall Func_1288c
	farcall HandlePlayersCardsScreen
	call Set_OBJ_8x8
	ret

PauseMenu_Config: ; c7e0 (3:47e0)
	farcall _PauseMenu_Config
	ret

PauseMenu_Exit: ; c7e5 (3:47e5)
	farcall _PauseMenu_Exit
	ret

PCMenu: ; c7ea (3:47ea)
	ld a, MUSIC_PC_MAIN_MENU
	call PlaySong
	call Func_c241
	call Func_c915
	call DoFrameIfLCDEnabled
	ldtx hl, TurnedPCOnText
	call PrintScrollableText_NoTextBoxLabel
	call Func_c84e
.loop
	ld a, $1
	call Func_c29b
.wait_input
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .wait_input
	ld a, e
	ld [wd0b9], a
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .exit
	cp $4
	jr z, .exit
	call Func_c2a3
	ld a, [wd0b9]
	ld hl, PointerTable_c846
	call JumpToFunctionInTable
	ld hl, Func_c84e
	call Func_c32b
	jr .loop
.exit
	call CloseTextBox
	call DoFrameIfLCDEnabled
	ldtx hl, TurnedPCOffText
	call Func_c891
	call CloseAdvancedDialogueBox
	xor a
	ld [wd112], a
	call PlayDefaultSong
	ret

PointerTable_c846: ; c846 (3:4846)
	dw PCMenu_CardAlbum
	dw PCMenu_ReadMail
	dw PCMenu_Glossary
	dw PCMenu_Print

Func_c84e: ; c84e (3:484e)
	ld a, [wd0b9]
	ld hl, Unknown_10da9
	farcall InitAndPrintPauseMenu
	ret

PCMenu_CardAlbum: ; c859 (3:4859)
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall Func_1288c
	farcall HandleCardAlbumScreen
	call Set_OBJ_8x8
	ret

PCMenu_ReadMail: ; c86d (3:486d)
	farcall _PCMenu_ReadMail
	ret

PCMenu_Glossary: ; c872 (3:4872)
	farcall _PCMenu_Glossary
	ret

PCMenu_Print: ; c877 (3:4877)
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall Func_1288c
	farcall HandlePrinterMenu
	call Set_OBJ_8x8
	call WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	ret

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
	call Func_c915
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
	call Func_c915
	call DoFrameIfLCDEnabled
	call PrintScrollableText_WithTextBoxLabel
	ret

Func_c8ed: ; c8ed (3:48ed)
	push hl
	push bc
	push de
	push hl
	ld a, $1
	call Func_c29b
	call Func_c915
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
	lb de, $00, $0c
	lb bc, $14, $06
	call AdjustCoordinatesForBGScroll
	call Func_c3ca
	pop de
	pop bc
	ret

SetNextNPCAndScript: ; c926 (3:4926)
	push bc
	call FindLoadedNPC
	ld a, [wLoadedNPCTempIndex]
	ld [wScriptNPC], a
	farcall SetNewScriptNPC
	pop bc
;	fallthrough

SetNextScript: ; c935 (3:4935)
	push hl
	ld hl, wNextScript
	ld [hl], c
	inc hl
	ld [hl], b
	ld a, OWMODE_SCRIPT
	ld [wOverworldMode], a
	pop hl
	ret

Func_c943: ; c943 (3:4943)
	push hl
	push bc
	push de
	ld l, MAP_SCRIPT_NPCS
	call GetMapScriptPointer
	jr nc, .quit
.load_npc_loop
	ld a, l
	ld [wTempPointer], a
	ld a, h
	ld [wTempPointer + 1], a
	ld a, BANK(MapScripts)
	ld [wTempPointerBank], a
	ld de, wTempNPC
	ld bc, NPC_MAP_SIZE
	call CopyBankedDataToDE
	ld a, [wTempNPC]
	or a
	jr z, .quit
	push hl
	ld a, [wLoadNPCFunction]
	ld l, a
	ld a, [wLoadNPCFunction + 1]
	ld h, a
	or l
	jr z, .no_script
	call CallHL2
	jr nc, .next_npc
.no_script
	ld a, [wTempNPC]
	farcall LoadNPCSpriteData
	call Func_c998
	farcall LoadNPC
.next_npc
	pop hl
	ld bc, NPC_MAP_SIZE
	add hl, bc
	jr .load_npc_loop
.quit
	ld l, MAP_SCRIPT_POST_NPC
	call CallMapScriptPointerIfExists
	pop de
	pop bc
	pop hl
	ret

Func_c998: ; c998 (3:4998)
	ld a, [wTempNPC]
	cp NPC_AMY
	ret nz
	ld a, [wd3d0]
	or a
	ret z
	ld b, $4
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld b, $e
.not_cgb
	ld a, b
	ld [wNPCAnim], a
	ld a, $0
	ld [wNPCAnimFlags], a
	ret

Func_c9b8: ; c9b8 (3:49b8)
	ld l, MAP_SCRIPT_LOAD_MAP
	jr CallMapScriptPointerIfExists

Func_c9bc: ; c9bc (3:49bc)
	ld l, MAP_SCRIPT_AFTER_DUEL
	jr CallMapScriptPointerIfExists

Func_c9c0: ; c9c0 (3:49c0)
	ld l, MAP_SCRIPT_MOVED_PLAYER

CallMapScriptPointerIfExists: ; c9c2 (3:49c2)
	call GetMapScriptPointer
	ret nc
	jp hl

Func_c9c7: ; c9c7 (3:49c7)
	ld l, MAP_SCRIPT_CLOSE_TEXTBOX
	jr CallMapScriptPointerIfExists

ClearEvents: ; c9cb (3:49cb)
	push hl
	push bc
	ld hl, wEventVars
	ld bc, EVENT_VAR_BYTES
.loop
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop bc
	pop hl
	ret

; Clears temporary event vars before determining Imakuni Room
DetermineImakuniAndChallengeHall: ; c9dd (3:49dd)
	xor a
	ld [wEventVars + EVENT_VAR_BYTES - 1], a
	call DetermineImakuniRoom
	call DetermineChallengeHallEvent
	ret

; Determines what room Imakuni is in when you reset
; Skips current room and does not occur if you haven't talked to Imakuni
DetermineImakuniRoom: ; c9e8 (3:49e8)
	ld c, IMAKUNI_FIGHTING_CLUB
	get_event_value EVENT_IMAKUNI_STATE
	cp IMAKUNI_TALKED
	jr c, .skip
.loop
	call UpdateRNGSources
	and %11
	ld c, a
	ld b, 0
	ld hl, ImakuniPossibleRooms
	add hl, bc
	ld a, [wTempMap]
	cp [hl]
	jr z, .loop
.skip
	ld a, c
	set_event_value EVENT_IMAKUNI_ROOM
	ret

ImakuniPossibleRooms: ; ca0a (3:4a04)
	db FIGHTING_CLUB_LOBBY
	db SCIENCE_CLUB_LOBBY
	db LIGHTNING_CLUB_LOBBY
	db WATER_CLUB_LOBBY

DetermineChallengeHallEvent: ; ca0e (3:4a0e)
	ld a, [wOverworldMapSelection]
	cp OWMAP_CHALLENGE_HALL
	jr z, .done
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	jr nz, .challenge_cup_three
; challenge cup two
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	cp CHALLENGE_CUP_OVER
	jr z, .done
	or a ; cp CHALLENGE_CUP_NOT_STARTED
	jr z, .challenge_cup_one
	cp CHALLENGE_CUP_WON
	jr z, .close_challenge_cup_one
	ld c, CHALLENGE_CUP_READY_TO_START
	set_event_value EVENT_CHALLENGE_CUP_2_STATE
	jr .close_challenge_cup_one
.challenge_cup_one
	get_event_value EVENT_CHALLENGE_CUP_1_STATE
	cp CHALLENGE_CUP_OVER
	jr z, .done
	or a ; cp CHALLENGE_CUP_NOT_STARTED
	jr z, .done
	cp CHALLENGE_CUP_WON
	jr z, .done
	ld c, CHALLENGE_CUP_READY_TO_START
	set_event_value EVENT_CHALLENGE_CUP_1_STATE
	jr .done
.challenge_cup_three
	call UpdateRNGSources
	ld c, CHALLENGE_CUP_READY_TO_START
	and %11
	or a
	jr z, .start_challenge_cup_three
	ld c, CHALLENGE_CUP_NOT_STARTED
.start_challenge_cup_three
	set_event_value EVENT_CHALLENGE_CUP_3_STATE
	jr .close_challenge_cup_two
.close_challenge_cup_two
	ld c, CHALLENGE_CUP_OVER
	set_event_value EVENT_CHALLENGE_CUP_2_STATE
.close_challenge_cup_one
	ld c, CHALLENGE_CUP_OVER
	set_event_value EVENT_CHALLENGE_CUP_1_STATE
.done
	ret

GetStackEventValue: ; ca69 (3:4a69)
	call GetByteAfterCall
;	fallthrough

; returns the event var's value in a
; also ors it with itself before returning
GetEventValue: ; ca6c (3:4a6c)
	push hl
	push bc
	call GetEventVar
	ld c, [hl]
	ld a, [wLoadedEventBits]
.loop
	bit 0, a
	jr nz, .done
	srl a
	srl c
	jr .loop
.done
	and c
	pop bc
	pop hl
	or a
	ret

SetStackEventZero: ; ca84 (3:4a84)
	call GetByteAfterCall
	push bc
	ld c, 0
	call SetEventValue
	pop bc
	ret

; Use macro set_event_value. The byte db'd after this func is called
; is used as the event value argument for SetEventValue
SetStackEventValue: ; ca8f (3:4a8f)
	call GetByteAfterCall
;	fallthrough

; a - event
; c - value - truncated to fit only the event var's bounds
SetEventValue: ; ca92 (3:4a92)
	push hl
	push bc
	call GetEventVar
	ld a, [wLoadedEventBits]
.loop
	bit 0, a
	jr nz, .done
	srl a
	sla c
	jr .loop
.done
	ld a, [wLoadedEventBits]
	and c
	ld c, a
	ld a, [wLoadedEventBits]
	cpl
	and [hl]
	or c
	ld [hl], a
	pop bc
	pop hl
	ret

; returns in a the byte db'd after the call to a function that calls this
GetByteAfterCall: ; cab3 (3:4ab3)
	push hl
	ld hl, sp+4
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

MaxStackEventValue: ; cac2 (3:4ac2)
	call GetByteAfterCall
;	fallthrough

MaxOutEventValue: ; cac5 (3:4ac5)
	push bc
	ld c, $ff
	call SetEventValue
	pop bc
	ret

SetStackEventFalse: ; cacd (3:4acd)
	call GetByteAfterCall
;	fallthrough

ZeroOutEventValue: ; cad0 (3:4ad0)
	push bc
	ld c, 0
	call SetEventValue
	pop bc
	ret

TryGiveMedalPCPacks: ; cad8 (3:4ad8)
	push hl
	push bc
	ld hl, MedalEvents
	lb bc, 0, 8
.loop
	ld a, [hli]
	call GetEventValue
	jr z, .no_medal
	inc b
.no_medal
	dec c
	jr nz, .loop

	ld c, b
	set_event_value EVENT_MEDAL_COUNT
	ld a, c
	push af
	cp 8
	jr nc, .give_packs_for_eight_medals
	cp 7
	jr nc, .give_packs_for_seven_medals
	cp 3
	jr nc, .give_packs_for_three_medals
	jr .done

.give_packs_for_eight_medals
	ld a, $c
	farcall TryGivePCPack

.give_packs_for_seven_medals
	ld a, $b
	farcall TryGivePCPack

.give_packs_for_three_medals
	ld a, $a
	farcall TryGivePCPack

.done
	pop af
	pop bc
	pop hl
	ret

MedalEvents: ; cb15 (3:4b15)
	db EVENT_BEAT_NIKKI
	db EVENT_BEAT_RICK
	db EVENT_BEAT_KEN
	db EVENT_BEAT_AMY
	db EVENT_BEAT_ISAAC
	db EVENT_BEAT_MURRAY
	db EVENT_BEAT_GENE
	db EVENT_BEAT_MITCH

; returns wEventVars byte in hl, related bits in wLoadedEventBits
GetEventVar: ; cb1d (3:4b1d)
	push bc
	ld c, a
	ld b, 0
	sla c
	rl b
	ld hl, EventVarMasks
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld [wLoadedEventBits], a
	ld b, 0
	ld hl, wEventVars
	add hl, bc
	pop bc
	ret

; location in wEventVars of each event var:
; offset - which byte holds the event value
; mask - which bits in the byte hold the value
; events 0-7 are reset when game resets
EventVarMasks: ; cb37 (3:4b37)
	event_def $3f, %10000000 ; EVENT_TEMP_TRADED_WITH_ISHIHARA
	event_def $3f, %01000000 ; EVENT_TEMP_GIFTED_TO_MAN1
	event_def $3f, %00100000 ; EVENT_TEMP_TALKED_TO_IMAKUNI
	event_def $3f, %00010000 ; EVENT_TEMP_DUELED_IMAKUNI
	event_def $3f, %00001000 ; EVENT_TEMP_TRADED_WITH_LASS2
	event_def $3f, %00000100 ; EVENT_TEMP_05 unused?
	event_def $3f, %00000010 ; EVENT_TEMP_06 unused?
	event_def $3f, %00000001 ; EVENT_TEMP_07 unused?
	event_def $00, %10000000 ; EVENT_BEAT_NIKKI
	event_def $00, %01000000 ; EVENT_BEAT_RICK
	event_def $00, %00100000 ; EVENT_BEAT_KEN
	event_def $00, %00010000 ; EVENT_BEAT_AMY
	event_def $00, %00001000 ; EVENT_BEAT_ISAAC
	event_def $00, %00000100 ; EVENT_BEAT_MURRAY
	event_def $00, %00000010 ; EVENT_BEAT_GENE
	event_def $00, %00000001 ; EVENT_BEAT_MITCH
	event_def $00, %11111111 ; EVENT_MEDAL_FLAGS
	event_def $01, %11110000 ; EVENT_PUPIL_MICHAEL_STATE
	event_def $01, %00001111 ; EVENT_GAL1_TRADE_STATE
	event_def $02, %11000000 ; EVENT_IMAKUNI_STATE
	event_def $02, %00110000 ; EVENT_LASS1_MENTIONED_IMAKUNI
	event_def $02, %00001000 ; EVENT_BEAT_SARA
	event_def $02, %00000100 ; EVENT_BEAT_AMANDA
	event_def $03, %11110000 ; EVENT_PUPIL_CHRIS_STATE
	event_def $03, %00001111 ; EVENT_MATTHEW_STATE
	event_def $04, %11110000 ; EVENT_CHAP2_TRADE_STATE
	event_def $04, %00001111 ; EVENT_DAVID_STATE
	event_def $05, %10000000 ; EVENT_BEAT_JOSEPH
	event_def $05, %01000000 ; EVENT_ISHIHARA_MENTIONED
	event_def $05, %00100000 ; EVENT_ISHIHARA_MET
	event_def $05, %00010000 ; EVENT_ISHIHARAS_HOUSE_MENTIONED
	event_def $05, %00001111 ; EVENT_ISHIHARA_TRADE_STATE
	event_def $06, %11110000 ; EVENT_PUPIL_JESSICA_STATE
	event_def $06, %00001100 ; EVENT_LAD2_STATE
	event_def $06, %00000010 ; EVENT_RECEIVED_LEGENDARY_CARDS
	event_def $06, %00000001 ; EVENT_KEN_HAD_ENOUGH_CARDS
	event_def $07, %11000000 ; EVENT_KEN_TALKED
	event_def $07, %00100000 ; EVENT_BEAT_JENNIFER
	event_def $07, %00010000 ; EVENT_BEAT_NICHOLAS
	event_def $07, %00001000 ; EVENT_BEAT_BRANDON
	event_def $07, %00000100 ; EVENT_ISAAC_TALKED
	event_def $07, %00000010 ; EVENT_MAN1_TALKED
	event_def $07, %00000001 ; EVENT_MAN1_WAITING_FOR_CARD
	event_def $08, %11111111 ; EVENT_MAN1_REQUESTED_CARD_ID
	event_def $09, %11100000 ; EVENT_MAN1_GIFT_SEQUENCE_STATE
	event_def $09, %00011111 ; EVENT_MAN1_GIFTED_CARD_FLAGS
	event_def $0a, %11110000 ; EVENT_MEDAL_COUNT
	event_def $0a, %00001000 ; EVENT_DANIEL_TALKED
	event_def $0a, %00000100 ; EVENT_MURRAY_TALKED
	event_def $0a, %00000011 ; EVENT_PAPPY1_STATE
	event_def $0b, %10000000 ; EVENT_RONALD_PSYCHIC_CLUB_LOBBY_ENCOUNTER
	event_def $0b, %01110000 ; EVENT_JOSHUA_STATE
	event_def $0b, %00001100 ; EVENT_IMAKUNI_ROOM
	event_def $0b, %00000011 ; EVENT_NIKKI_STATE
	event_def $0c, %11100000 ; EVENT_IMAKUNI_WIN_COUNT
	event_def $0c, %00011100 ; EVENT_LASS2_TRADE_STATE
	event_def $0c, %00000010 ; EVENT_ISHIHARA_WANTS_TO_TRADE
	event_def $0c, %00000001 ; EVENT_ISHIHARA_CONGRATULATED_PLAYER
	event_def $0d, %10000000 ; EVENT_BEAT_KRISTIN
	event_def $0d, %01000000 ; EVENT_BEAT_HEATHER
	event_def $0d, %00100000 ; EVENT_BEAT_BRITTANY
	event_def $0d, %00010000 ; EVENT_DRMASON_CONGRATULATED_PLAYER
	event_def $0d, %00001110 ; EVENT_MASON_LAB_STATE
	event_def $0e, %11100000 ; EVENT_CHALLENGE_CUP_1_STATE
	event_def $0e, %00011100 ; EVENT_CHALLENGE_CUP_2_STATE
	event_def $0f, %11100000 ; EVENT_CHALLENGE_CUP_3_STATE
	event_def $10, %10000000 ; EVENT_CHALLENGE_CUP_STARTING
	event_def $10, %01000000 ; EVENT_CHALLENGE_CUP_STAGE_VISITED
	event_def $10, %00110000 ; EVENT_CHALLENGE_CUP_NUMBER
	event_def $10, %00001100 ; EVENT_CHALLENGE_CUP_OPPONENT_NUMBER
	event_def $10, %00000010 ; EVENT_CHALLENGE_CUP_OPPONENT_CHOSEN
	event_def $10, %00000001 ; EVENT_CHALLENGE_CUP_IN_MENU
	event_def $11, %11100000 ; EVENT_CHALLENGE_CUP_1_RESULT
	event_def $11, %00011100 ; EVENT_CHALLENGE_CUP_2_RESULT
	event_def $12, %11100000 ; EVENT_CHALLENGE_CUP_3_RESULT
	event_def $13, %10000000 ; EVENT_RONALD_FIRST_CLUB_ENTRANCE_ENCOUNTER
	event_def $13, %01100000 ; EVENT_RONALD_FIRST_DUEL_STATE
	event_def $13, %00011000 ; EVENT_RONALD_SECOND_DUEL_STATE
	event_def $13, %00000100 ; EVENT_RONALD_TALKED
	event_def $13, %00000010 ; EVENT_RONALD_POKEMON_DOME_ENTRANCE_ENCOUNTER
	event_def $14, %10000000 ; EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_1
	event_def $14, %01000000 ; EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_2
	event_def $14, %00100000 ; EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_3
	event_def $14, %00010000 ; EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_4
	event_def $14, %00001000 ; EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_5
	event_def $14, %00000100 ; EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_6
	event_def $14, %00000010 ; EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_7
	event_def $14, %00000001 ; EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_8
	event_def $15, %11110000 ; EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE
	event_def $15, %00001000 ; EVENT_PLAYER_ENTERED_CHALLENGE_CUP
	event_def $16, %10000000 ; EVENT_FIGHTING_DECK_MACHINE_ACTIVE
	event_def $16, %01000000 ; EVENT_ROCK_DECK_MACHINE_ACTIVE
	event_def $16, %00100000 ; EVENT_WATER_DECK_MACHINE_ACTIVE
	event_def $16, %00010000 ; EVENT_LIGHTNING_DECK_MACHINE_ACTIVE
	event_def $16, %00001000 ; EVENT_GRASS_DECK_MACHINE_ACTIVE
	event_def $16, %00000100 ; EVENT_PSYCHIC_DECK_MACHINE_ACTIVE
	event_def $16, %00000010 ; EVENT_SCIENCE_DECK_MACHINE_ACTIVE
	event_def $16, %00000001 ; EVENT_FIRE_DECK_MACHINE_ACTIVE
	event_def $16, %11111111 ; EVENT_ALL_DECK_MACHINE_FLAGS
	event_def $17, %10000000 ; EVENT_HALL_OF_HONOR_DOORS_OPEN
	event_def $17, %01000000 ; EVENT_CHALLENGED_GRAND_MASTERS
	event_def $17, %00110000 ; EVENT_POKEMON_DOME_STATE
	event_def $17, %00001000 ; EVENT_POKEMON_DOME_IN_MENU
	event_def $17, %00000100 ; EVENT_CHALLENGED_RONALD
	event_def $18, %11000000 ; EVENT_COURTNEY_STATE
	event_def $18, %00110000 ; EVENT_STEVE_STATE
	event_def $18, %00001100 ; EVENT_JACK_STATE
	event_def $18, %00000011 ; EVENT_ROD_STATE
	event_def $19, %11000000 ; EVENT_RONALD_POKEMON_DOME_STATE
	event_def $19, %00100000 ; EVENT_RECEIVED_ZAPDOS
	event_def $19, %00010000 ; EVENT_RECEIVED_MOLTRES
	event_def $19, %00001000 ; EVENT_RECEIVED_ARTICUNO
	event_def $19, %00000100 ; EVENT_RECEIVED_DRAGONITE
	event_def $19, %00111100 ; EVENT_LEGENDARY_CARDS_RECEIVED_FLAGS
	event_def $1a, %11111100 ; EVENT_GIFT_CENTER_MENU_CHOICE
	event_def $1a, %00000011 ; EVENT_AARON_BOOSTER_REWARD
	event_def $1b, %11111111 ; EVENT_CONSOLE
	event_def $1c, %11110000 ; EVENT_SAM_MENU_CHOICE
	event_def $1c, %00001111 ; EVENT_AARON_DECK_MENU_CHOICE

; Used for basic level objects that just print text and quit
PrintInteractableObjectText: ; cc25 (3:4c25)
	ld hl, wDefaultObjectText
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_cc32
	call CloseAdvancedDialogueBox
	ret

Func_cc32: ; cc32 (3:4c32)
	push hl
	ld hl, wCurrentNPCNameTx
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	call Func_c8ba
	ret

; Used for things that are represented as NPCs but don't have a Script
; EX: Clerks and legendary cards that interact through Level Objects
Script_Clerk10: ; cc3e (3:4c3e)
Script_GiftCenterClerk: ; cc3e (3:4c3e)
Script_Woman2: ; cc3e (3:4c3e)
Script_Torch: ; cc3e (3:4c3e)
Script_LegendaryCardTopLeft: ; cc3e (3:4c3e)
Script_LegendaryCardTopRight: ; cc3e (3:4c3e)
Script_LegendaryCardLeftSpark: ; cc3e (3:4c3e)
Script_LegendaryCardBottomLeft: ; cc3e (3:4c3e)
Script_LegendaryCardBottomRight: ; cc3e (3:4c3e)
Script_LegendaryCardRightSpark: ; cc3e (3:4c3e)
	call CloseAdvancedDialogueBox
	ret

; Enters into the script loop, continuing until wBreakScriptLoop > 0
; When the loop is broken, it resumes normal code execution where script ended
; Note: Some scripts "double return" and skip this.
RST20: ; cc42 (3:4c42)
	pop hl
	ld a, l
	ld [wScriptPointer], a
	ld a, h
	ld [wScriptPointer + 1], a
	xor a
	ld [wBreakScriptLoop], a
.loop
	call RunOverworldScript
	ld a, [wBreakScriptLoop] ; if you break out, it jumps
	or a
	jr z, .loop
	ld hl, wScriptPointer
	ld a, [hli]
	ld c, a
	ld b, [hl]
	retbc

IncreaseScriptPointerBy1: ; cc60 (3:4c60)
	ld a, 1
	jr IncreaseScriptPointer

IncreaseScriptPointerBy2: ; cc64 (3:4c64)
	ld a, 2
	jr IncreaseScriptPointer

IncreaseScriptPointerBy4: ; cc68 (3:4c68)
	ld a, 4
	jr IncreaseScriptPointer

IncreaseScriptPointerBy5: ; cc6c (3:4c6c)
	ld a, 5
	jr IncreaseScriptPointer

IncreaseScriptPointerBy6: ; cc70 (3:4c70)
	ld a, 6
	jr IncreaseScriptPointer

IncreaseScriptPointerBy7: ; cc74 (3:4c74)
	ld a, 7
	jr IncreaseScriptPointer

IncreaseScriptPointerBy3: ; cc78 (3:4c78)
	ld a, 3
IncreaseScriptPointer: ; cc7a (3:4c7a)
	ld c, a
	ld a, [wScriptPointer]
	add c
	ld [wScriptPointer], a
	ld a, [wScriptPointer + 1]
	adc 0
	ld [wScriptPointer + 1], a
	ret

SetScriptPointer: ; cc8b (3:4c8b)
	ld hl, wScriptPointer
	ld [hl], c
	inc hl
	ld [hl], b
	ret

GetScriptArgs5AfterPointer: ; cc92 (3:4c92)
	ld a, 5
	jr GetScriptArgsAfterPointer

GetScriptArgs1AfterPointer: ; cc96 (3:4c96)
	ld a, 1
	jr GetScriptArgsAfterPointer

GetScriptArgs2AfterPointer: ; cc9a (3:4c9a)
	ld a, 2
	jr GetScriptArgsAfterPointer

GetScriptArgs3AfterPointer: ; cc9e (3:4c9e)
	ld a, 3
GetScriptArgsAfterPointer: ; cca0 (3:4ca0)
	push hl
	ld l, a
	ld a, [wScriptPointer]
	add l
	ld l, a
	ld a, [wScriptPointer + 1]
	adc 0
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

; Exits Script mode and runs the next instruction like normal
ScriptCommand_EndScript: ; ccbe (3:4cbe)
	ld a, TRUE
	ld [wBreakScriptLoop], a
	jp IncreaseScriptPointerBy1

ScriptCommand_CloseAdvancedTextBox: ; ccc6 (3:4cc6)
	call CloseAdvancedDialogueBox
	jp IncreaseScriptPointerBy1

ScriptCommand_QuitScriptFully: ; cccc (3:4ccc)
	call ScriptCommand_CloseAdvancedTextBox
	call ScriptCommand_EndScript
	pop hl
	ret

; args: 2-Text String Index
ScriptCommand_PrintNPCText: ; ccd4 (3:4cd4)
	ld l, c
	ld h, b
	call Func_cc32
	jp IncreaseScriptPointerBy3

ScriptCommand_PrintText: ; ccdc (3:4cdc)
	ld l, c
	ld h, b
	call Func_c891
	jp IncreaseScriptPointerBy3

ScriptCommand_AskQuestionJumpDefaultYes: ; cce4 (3:4ce4)
	ld a, TRUE
	ld [wDefaultYesOrNo], a
;	fallthrough

; Asks the player a question then jumps if they answer yes. Seem to be able to
; take a text of 0000 (NULL) to overwrite last with (yes no) prompt at the bottom
ScriptCommand_AskQuestionJump: ; cce9 (3:4ce9)
	ld l, c
	ld h, b
	call Func_c8ed
	ld a, [hCurMenuItem]
	ld [wScriptControlByte], a
	jr c, .no_jump
	call GetScriptArgs3AfterPointer
	jr z, .no_jump
	jp SetScriptPointer

.no_jump
	jp IncreaseScriptPointerBy5

; args - prize cards, deck id, duel theme index
; sets a duel up, doesn't start until we break out of the script system.
ScriptCommand_StartDuel: ; cd01 (3:4d01)
	call SetNPCDuelParams
	ld a, [wScriptNPC]
	ld l, LOADED_NPC_ID
	call GetItemInLoadedNPCIndex
	ld a, [hl]
	farcall SetNPCMatchStartTheme
	ld a, [wNPCDuelDeckID]
	cp $ff
	jr nz, .not_aaron_duel
	ld a, [wMultichoiceTextboxResult_ChooseDeckToDuelAgainst]
	ld c, a
	ld b, 0
	ld hl, AaronDeckIDs
	add hl, bc
	ld a, [hl]
	ld [wNPCDuelDeckID], a
.not_aaron_duel
	ld a, [wScriptNPC]
	ld l, LOADED_NPC_ID
	call GetItemInLoadedNPCIndex
	ld a, [hl]
.start_duel
	ld [wNPCDuelist], a
	ld [wNPCDuelistCopy], a
	push af
	farcall Func_1c557
	ld [wd0c5], a
	pop af
	farcall SetNPCOpponentNameAndPortrait
	ld a, GAME_EVENT_DUEL
	ld [wGameEvent], a
	ld hl, wOverworldTransition
	set 6, [hl]
	jp IncreaseScriptPointerBy4

ScriptCommand_StartChallengeHallDuel: ; cd4f (3:4d4f)
	call SetNPCDuelParams
	ld a, [wChallengeHallNPC]
	farcall SetNPCDeckIDAndDuelTheme
	ld a, MUSIC_MATCH_START_2
	ld [wMatchStartTheme], a
	ld a, [wChallengeHallNPC]
	jr ScriptCommand_StartDuel.start_duel

AaronDeckIDs: ; cd63 (3:4d63)
	db LIGHTNING_AND_FIRE_DECK_ID
	db WATER_AND_FIGHTING_DECK_ID
	db GRASS_AND_PSYCHIC_DECK_ID

SetNPCDuelParams: ; cd66 (3:4d66)
	ld a, c
	ld [wNPCDuelPrizes], a
	ld a, b
	ld [wNPCDuelDeckID], a
	call GetScriptArgs3AfterPointer
	ld a, c
	ld [wDuelTheme], a
	ret

ScriptCommand_BattleCenter: ; cd76 (3:4d76)
	ld a, GAME_EVENT_BATTLE_CENTER
	ld [wGameEvent], a
	ld hl, wOverworldTransition
	set 6, [hl]
	jp IncreaseScriptPointerBy1

; prints text arg 1 or arg 2 depending on wScriptControlByte.
ScriptCommand_PrintVariableNPCText: ; cd83 (3:4d83)
	ld a, [wScriptControlByte]
	or a
	jr nz, .print_text
	call GetScriptArgs3AfterPointer
.print_text
	ld l, c
	ld h, b
	call Func_cc32
	jp IncreaseScriptPointerBy5

ScriptCommand_PrintTextForChallengeCup: ; cd94 (3:4d94)
	get_event_value EVENT_CHALLENGE_CUP_NUMBER
	dec a
	and %11
	add a
	inc a
	call GetScriptArgsAfterPointer
	ld l, c
	ld h, b
	call Func_cc32
	jp IncreaseScriptPointerBy7

ScriptCommand_PrintVariableText: ; cda8 (3:4da8)
	ld a, [wScriptControlByte]
	or a
	jr nz, .print_text
	call GetScriptArgs3AfterPointer
.print_text
	ld l, c
	ld h, b
	call Func_c891
	jp IncreaseScriptPointerBy5

; Does not return to RST20 - pops an extra time to skip that.
ScriptCommand_PrintTextQuitFully: ; cdb9 (3:4db9)
	ld l, c
	ld h, b
	call Func_cc32
	call CloseAdvancedDialogueBox
	ld a, TRUE
	ld [wBreakScriptLoop], a
	call IncreaseScriptPointerBy3
	pop hl
	ret

ScriptCommand_UnloadActiveNPC: ; cdcb (3:4dcb)
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
Func_cdd1: ; cdd1 (3:4dd1)
	farcall UnloadNPC
	jp IncreaseScriptPointerBy1

ScriptCommand_UnloadChallengeHallNPC: ; cdd8 (3:4dd8)
	ld a, [wLoadedNPCTempIndex]
	push af
	ld a, [wTempNPC]
	push af
	ld a, [wChallengeHallNPC]
	ld [wTempNPC], a
	call FindLoadedNPC
	call Func_cdd1
	pop af
	ld [wTempNPC], a
	pop af
	ld [wLoadedNPCTempIndex], a
	ret

ScriptCommand_SetChallengeHallNPCCoords: ; cdf5 (3:4df5)
	ld a, [wLoadedNPCTempIndex]
	push af
	ld a, [wTempNPC]
	push af
	ld a, [wChallengeHallNPC]
	ld [wTempNPC], a
	ld a, c
	ld [wLoadNPCXPos], a
	ld a, b
	ld [wLoadNPCYPos], a
	ld a, SOUTH
	ld [wLoadNPCDirection], a
	ld a, [wTempNPC]
	farcall LoadNPCSpriteData
	farcall LoadNPC
	pop af
	ld [wTempNPC], a
	pop af
	ld [wLoadedNPCTempIndex], a
	jp IncreaseScriptPointerBy3

; Finds and executes an NPCMovement script in the table provided in bc
; based on the active NPC's current direction
ScriptCommand_MoveActiveNPCByDirection: ; ce26 (3:4e26)
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
	farcall GetNPCDirection
	rlca
	add c
	ld l, a
	ld a, b
	adc 0
	ld h, a
	ld c, [hl]
	inc hl
	ld b, [hl]
;	fallthrough

; Moves an NPC given the list of directions pointed to by bc
; set bit 7 to only rotate the NPC
ExecuteNPCMovement: ; ce3a (3:4e3a)
	farcall StartNPCMovement
.loop
	call DoFrameIfLCDEnabled
	farcall CheckIsAnNPCMoving
	jr nz, .loop
	jp IncreaseScriptPointerBy3

; Begin a series of NPC movements on the currently talking NPC
; based on the series of directions pointed to by bc
ScriptCommand_MoveActiveNPC: ; ce4a (3:4e4a)
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
	jr ExecuteNPCMovement

; Begin a series of NPC movements on the Challenge Hall opponent NPC
; based on the series of directions pointed to by bc
ScriptCommand_MoveChallengeHallNPC: ; ce52 (3:4e52)
	ld a, [wLoadedNPCTempIndex]
	push af
	ld a, [wTempNPC]
	push af
	ld a, [wChallengeHallNPC]
;	fallthrough

; Executes movement on an arbitrary NPC using values in a and on the stack
; Changes and fixes Temp NPC using stack values
ExecuteArbitraryNPCMovementFromStack: ; ce5d (3:4e5d)
	ld [wTempNPC], a
	call FindLoadedNPC
	call ExecuteNPCMovement
	pop af
	ld [wTempNPC], a
	pop af
	ld [wLoadedNPCTempIndex], a
	ret

ScriptCommand_MoveArbitraryNPC: ; ce6f (3:4e6f)
	ld a, [wLoadedNPCTempIndex]
	push af
	ld a, [wTempNPC]
	push af
	ld a, c
	push af
	call GetScriptArgs2AfterPointer
	push bc
	call IncreaseScriptPointerBy1
	pop bc
	pop af
	jr ExecuteArbitraryNPCMovementFromStack

ScriptCommand_CloseTextBox: ; ce84 (3:4e84)
	call CloseTextBox
	jp IncreaseScriptPointerBy1

; args: booster pack index, booster pack index, booster pack index
ScriptCommand_GiveBoosterPacks: ; ce8a (3:4e8a)
	xor a
	ld [wAnotherBoosterPack], a
	push bc
	call Func_c2a3
	pop bc
	push bc
	ld a, c
	farcall GiveBoosterPack
	ld a, TRUE
	ld [wAnotherBoosterPack], a
	pop bc
	ld a, b
	cp NO_BOOSTER
	jr z, .done
	farcall GiveBoosterPack
	call GetScriptArgs3AfterPointer
	ld a, c
	cp NO_BOOSTER
	jr z, .done
	farcall GiveBoosterPack
.done
	call Func_c2d4
	jp IncreaseScriptPointerBy4

ScriptCommand_GiveOneOfEachTrainerBooster: ; ceba (3:4eba)
	xor a
	ld [wAnotherBoosterPack], a
	call Func_c2a3
	ld hl, .booster_type_table
.loop
	ld a, [hl]
	cp NO_BOOSTER
	jr z, .done
	push hl
	farcall GiveBoosterPack
	ld a, TRUE
	ld [wAnotherBoosterPack], a
	pop hl
	inc hl
	jr .loop
.done
	call Func_c2d4
	jp IncreaseScriptPointerBy1

.booster_type_table
	db BOOSTER_COLOSSEUM_TRAINER
	db BOOSTER_EVOLUTION_TRAINER
	db BOOSTER_MYSTERY_TRAINER_COLORLESS
	db BOOSTER_LABORATORY_TRAINER
	db NO_BOOSTER ; $ff

; Shows the card received screen for a given promotional card
; arg can either be the card, $00 for a wram card, or $ff for the 4 legendary cards
ScriptCommand_ShowCardReceivedScreen: ; cee2 (3:4ee2)
	call Func_c2a3
	ld a, c
	cp $ff
	jr z, .legendary_card
	or a
	jr nz, .show_card
	ld a, [wCardReceived]

.show_card
	push af
	farcall Func_10000
	farcall FlashWhiteScreen
	pop af
	bank1call Func_7594
	call WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	call Func_c2d4
	jp IncreaseScriptPointerBy2

.legendary_card
	xor a
	jr .show_card

ScriptCommand_JumpIfCardOwned: ; cf0c (3:4f0c)
	ld a, c
	call GetCardCountInCollectionAndDecks
	jr ScriptCommand_JumpIfCardInCollection.count_check

ScriptCommand_JumpIfCardInCollection: ; cf12 (3:4f12)
	ld a, c
	call GetCardCountInCollection

.count_check
	or a
	jr nz, .pass_try_jump

.fail
	call SetScriptControlByteFail
	jp IncreaseScriptPointerBy4

.pass_try_jump
	call SetScriptControlBytePass
	call GetScriptArgs2AfterPointer
	jr z, .no_jump
	jp SetScriptPointer

.no_jump
	jp IncreaseScriptPointerBy4

ScriptCommand_JumpIfEnoughCardsOwned: ; cf2d (3:4f2d)
	push bc
	call IncreaseScriptPointerBy1
	pop bc
	call GetAmountOfCardsOwned
	ld a, h
	cp b
	jr nz, .high_byte_not_equal
	ld a, l
	cp c

.high_byte_not_equal
	jr nc, ScriptCommand_JumpIfCardInCollection.pass_try_jump
	jr ScriptCommand_JumpIfCardInCollection.fail

; Gives the first arg as a card. If that's 0 pulls from wCardReceived
ScriptCommand_GiveCard: ; cf3f (3:4f3f)
	ld a, c
	or a
	jr nz, .give_card
	ld a, [wCardReceived]

.give_card
	call AddCardToCollection
	jp IncreaseScriptPointerBy2

ScriptCommand_TakeCard: ; cf4c (3:4f4c)
	ld a, c
	call RemoveCardFromCollection
	jp IncreaseScriptPointerBy2

ScriptCommand_JumpIfAnyEnergyCardsInCollection: ; cf53 (3:4f53)
	ld c, GRASS_ENERGY
	ld b, 0
.loop
	ld a, c
	call GetCardCountInCollection
	add b
	ld b, a
	inc c
	ld a, c
	cp DOUBLE_COLORLESS_ENERGY + 1
	jr c, .loop
	ld a, b
	or a
	jr nz, .pass_try_jump

.fail
	call SetScriptControlByteFail
	jp IncreaseScriptPointerBy3

.pass_try_jump
	call SetScriptControlBytePass
	call GetScriptArgs1AfterPointer
	jr z, .no_jump
	jp SetScriptPointer

.no_jump
	jp IncreaseScriptPointerBy3

ScriptCommand_RemoveAllEnergyCardsFromCollection: ; cf7b (3:4f7b)
	ld c, GRASS_ENERGY
.next_energy
	push bc
	ld a, c
	call GetCardCountInCollection
	jr c, .no_energy
	ld b, a
.remove_loop
	ld a, c
	call RemoveCardFromCollection
	dec b
	jr nz, .remove_loop

.no_energy
	pop bc
	inc c
	ld a, c
	cp DOUBLE_COLORLESS_ENERGY + 1
	jr c, .next_energy
	jp IncreaseScriptPointerBy1

ScriptCommand_JumpBasedOnFightingClubPupilStatus: ; cf96 (3:4f96)
	ld c, 0
	get_event_value EVENT_PUPIL_MICHAEL_STATE
	or a ; cp PUPIL_INACTIVE
	jr z, .first_interaction
	cp PUPIL_DEFEATED
	jr c, .pupil1_not_defeated
	inc c
.pupil1_not_defeated
	get_event_value EVENT_PUPIL_CHRIS_STATE
	cp PUPIL_DEFEATED
	jr c, .pupil2_not_defeated
	inc c
.pupil2_not_defeated
	get_event_value EVENT_PUPIL_JESSICA_STATE
	cp PUPIL_DEFEATED
	jr c, .pupil3_not_defeated
	inc c
.pupil3_not_defeated
	ld a, c
	rlca
	add 3
	call GetScriptArgsAfterPointer
	jp SetScriptPointer

.first_interaction
	call GetScriptArgs1AfterPointer
	jp SetScriptPointer

ScriptCommand_SetActiveNPCDirection: ; cfc6 (3:4fc6)
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
	ld a, c
	farcall Func_1c52e
	jp IncreaseScriptPointerBy2

ScriptCommand_PickNextMan1RequestedCard: ; cfd4 (3:4fd4)
	get_event_value EVENT_MAN1_GIFTED_CARD_FLAGS
	ld b, a
.choose_again
	ld a, Man1RequestedCardsList.end - Man1RequestedCardsList
	call Random
	ld e, 1
	ld c, a
	push bc
	or a
	jr z, .skip_shift
.shift_loop
	sla e
	dec c
	jr nz, .shift_loop
.skip_shift
	ld a, e
	and b ; has this card already been chosen before?
	pop bc
	jr nz, .choose_again
	ld a, e
	or b
	push bc
	ld c, a
	set_event_value EVENT_MAN1_GIFTED_CARD_FLAGS
	pop bc
	ld b, 0
	ld hl, Man1RequestedCardsList
	add hl, bc
	ld c, [hl]
	set_event_value EVENT_MAN1_REQUESTED_CARD_ID
	jp IncreaseScriptPointerBy1

Man1RequestedCardsList: ; d006 (3:5006)
	db GRAVELER
	db OMASTAR
	db PARASECT
	db RAPIDASH
	db WEEZING
.end

ScriptCommand_LoadMan1RequestedCardIntoTxRamSlot: ; d00b (3:500b)
	sla c
	ld b, 0
	ld hl, wTxRam2
	add hl, bc
	push hl
	get_event_value EVENT_MAN1_REQUESTED_CARD_ID
	ld e, a
	ld d, 0
	call GetCardName
	pop hl
	ld [hl], e
	inc hl
	ld [hl], d
	jp IncreaseScriptPointerBy2

ScriptCommand_JumpIfMan1RequestedCardOwned: ; d025 (3:5025)
	get_event_value EVENT_MAN1_REQUESTED_CARD_ID
	call GetCardCountInCollectionAndDecks
	jp c, ScriptCommand_JumpIfAnyEnergyCardsInCollection.fail
	jp ScriptCommand_JumpIfAnyEnergyCardsInCollection.pass_try_jump

ScriptCommand_JumpIfMan1RequestedCardInCollection: ; d032 (3:5032)
	get_event_value EVENT_MAN1_REQUESTED_CARD_ID
	call GetCardCountInCollection
	jp c, ScriptCommand_JumpIfAnyEnergyCardsInCollection.fail
	jp ScriptCommand_JumpIfAnyEnergyCardsInCollection.pass_try_jump

ScriptCommand_RemoveMan1RequestedCardFromCollection: ; d03f (3:503f)
	get_event_value EVENT_MAN1_REQUESTED_CARD_ID
	call RemoveCardFromCollection
	jp IncreaseScriptPointerBy1

ScriptCommand_Jump: ; d049 (3:5049)
	call GetScriptArgs1AfterPointer
	jp SetScriptPointer

ScriptCommand_TryGiveMedalPCPacks: ; d04f (3:504f)
	call TryGiveMedalPCPacks
	jp IncreaseScriptPointerBy1

ScriptCommand_SetPlayerDirection: ; d055 (3:5055)
	ld a, c
	call UpdatePlayerDirection
	jp IncreaseScriptPointerBy2

; arg1 - Direction (index in PlayerMovementOffsetTable_Tiles)
; arg2 - Tiles Moves (Speed)
ScriptCommand_MovePlayer: ; 505c (3:505c)
	ld a, c
	ld [wd339], a
	ld a, b
	ld [wd33a], a
	call StartScriptedMovement
.wait
	call DoFrameIfLCDEnabled
	call SetScreenScroll
	call Func_c53d
	ld a, [wPlayerCurrentlyMoving]
	and $03
	jr nz, .wait
	call DoFrameIfLCDEnabled
	call SetScreenScroll
	jp IncreaseScriptPointerBy3

ScriptCommand_SetDialogNPC: ; d080 (3:5080)
	ld a, c
	farcall SetNPCDialogName
	jp IncreaseScriptPointerBy2

ScriptCommand_SetNextNPCAndScript: ; d088 (3:5088)
	ld a, c
	ld [wTempNPC], a
	call GetScriptArgs2AfterPointer
	call SetNextNPCAndScript
	jp IncreaseScriptPointerBy4

ScriptCommand_SetSpriteAttributes: ; d095 (3:5095)
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
	push bc
	call GetScriptArgs3AfterPointer
	ld a, [wScriptNPC]
	ld l, LOADED_NPC_FLAGS
	call GetItemInLoadedNPCIndex
	res NPC_FLAG_DIRECTIONLESS_F, [hl]
	ld a, [hl]
	or c
	ld [hl], a
	pop bc
	ld e, c
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld e, b
.not_cgb
	ld a, e
	farcall SetNPCAnimation
	jp IncreaseScriptPointerBy4

ScriptCommand_SetActiveNPCCoords: ; d0be (3:50be)
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
	ld a, c
	ld c, b
	ld b, a
	farcall SetNPCPosition
	jp IncreaseScriptPointerBy3

ScriptCommand_DoFrames: ; d0ce (3:50ce)
	push bc
	call DoFrameIfLCDEnabled
	pop bc
	dec c
	jr nz, ScriptCommand_DoFrames
	jp IncreaseScriptPointerBy2

ScriptCommand_JumpIfActiveNPCCoordsMatch: ; d0d9 (3:50d9)
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
	ld d, c
	ld e, b
	farcall GetNPCPosition
	ld a, e
	cp c
	jp nz, ScriptCommand_JumpIfEventEqual.fail
	ld a, d
	cp b
	jp nz, ScriptCommand_JumpIfEventEqual.fail
	jp ScriptCommand_JumpIfEventEqual.pass_try_jump

ScriptCommand_JumpIfPlayerCoordsMatch: ; d0f2 (3:50f2)
	ld a, [wPlayerXCoord]
	cp c
	jp nz, ScriptCommand_JumpIfEventEqual.fail
	ld a, [wPlayerYCoord]
	cp b
	jp nz, ScriptCommand_JumpIfEventEqual.fail
	jp ScriptCommand_JumpIfEventEqual.pass_try_jump

ScriptCommand_JumpIfNPCLoaded: ; d103 (3:5103)
	ld a, [wLoadedNPCTempIndex]
	push af
	ld a, [wTempNPC]
	push af
	ld a, c
	ld [wTempNPC], a
	call FindLoadedNPC
	jr c, .not_loaded
	call ScriptCommand_JumpIfEventTrue.pass_try_jump
	jr .done

.not_loaded
	call ScriptCommand_JumpIfEventFalse.fail

.done
	pop af
	ld [wTempNPC], a
	pop af
	ld [wLoadedNPCTempIndex], a
	ret

ScriptCommand_ShowMedalReceivedScreen: ; d125 (3:5125)
	ld a, c
	push af
	call Func_c2a3
	pop af
	farcall Medal_1029e
	call Func_c2d4
	jp IncreaseScriptPointerBy2

ScriptCommand_LoadCurrentMapNameIntoTxRamSlot: ; d135 (3:5135)
	sla c
	ld b, 0
	ld hl, wTxRam2
	add hl, bc
	push hl
	ld a, [wOverworldMapSelection]
	rlca
	ld c, a
	ld b, 0
	ld hl, MapNames - 2
	add hl, bc
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ld [hl], e
	inc hl
	ld [hl], d
	jp IncreaseScriptPointerBy2

MapNames: ; d153 (3:5153)
	tx MasonLaboratoryMapNameText
	tx MrIshiharasHouseMapNameText
	tx FightingClubMapNameText
	tx RockClubMapNameText
	tx WaterClubMapNameText
	tx LightningClubMapNameText
	tx GrassClubMapNameText
	tx PsychicClubMapNameText
	tx ScienceClubMapNameText
	tx FireClubMapNameText
	tx ChallengeHallMapNameText
	tx PokemonDomeMapNameText

ScriptCommand_LoadChallengeHallNPCIntoTxRamSlot: ; d16b (3:516b)
	ld hl, wCurrentNPCNameTx
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	sla c
	ld b, 0
	ld hl, wTxRam2
	add hl, bc
	push hl
	ld a, [wChallengeHallNPC]
	farcall SetNPCDialogName
	pop hl
	ld a, [wCurrentNPCNameTx]
	ld [hli], a
	ld a, [wCurrentNPCNameTx + 1]
	ld [hl], a
	pop de
	ld hl, wCurrentNPCNameTx
	ld [hl], e
	inc hl
	ld [hl], d
	jp IncreaseScriptPointerBy2

ScriptCommand_PickChallengeHallOpponent: ; d195 (3:5195)
	ld a, [wTempNPC]
	push af
	get_event_value EVENT_CHALLENGE_CUP_OPPONENT_NUMBER
	inc a
	ld c, a
	set_event_value EVENT_CHALLENGE_CUP_OPPONENT_NUMBER
	call Func_f580
	pop af
	ld [wTempNPC], a
	jp IncreaseScriptPointerBy1

ScriptCommand_OpenMenu: ; d1ad (3:51ad)
	call PauseMenu
	jp IncreaseScriptPointerBy1

ScriptCommand_PickChallengeCupPrizeCard: ; d1b3 (3:51b3)
	get_event_value EVENT_CHALLENGE_CUP_NUMBER
	dec a
	cp 2
	jr c, .first_or_second_cup
	ld a, (ChallengeCupPrizeCards.end - ChallengeCupPrizeCards) / 3 - 2
	call Random
	add 2
.first_or_second_cup
	ld hl, ChallengeCupPrizeCards
.get_card_from_list
	ld e, a
	add a
	add e
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld [wCardReceived], a
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	jp IncreaseScriptPointerBy1

ChallengeCupPrizeCards: ; d1dc (3:51dc)
	db MEWTWO2
	tx MewtwoTradeCardName

	db MEW1
	tx MewTradeCardName

	db ARCANINE1
	tx ArcanineTradeCardName

	db PIKACHU3
	tx PikachuTradeCardName

	db PIKACHU4
	tx PikachuTradeCardName

	db SURFING_PIKACHU1
	tx SurfingPikachuTradeCardName

	db SURFING_PIKACHU2
	tx SurfingPikachuTradeCardName

	db ELECTABUZZ1
	tx ElectabuzzTradeCardName

	db SLOWPOKE1
	tx SlowpokeTradeCardName

	db MEWTWO3
	tx MewtwoTradeCardName

	db MEWTWO2
	tx MewtwoTradeCardName

	db MEW1
	tx MewTradeCardName

	db JIGGLYPUFF1
	tx JigglypuffTradeCardName

	db SUPER_ENERGY_RETRIEVAL
	tx SuperEnergyRetrievalTradeCardName

	db FLYING_PIKACHU
	tx FlyingPikachuTradeCardName
.end

ScriptCommand_PickLegendaryCard: ; d209 (3:5209)
	get_event_value EVENT_LEGENDARY_CARDS_RECEIVED_FLAGS
	ld e, a
.new_random
	call UpdateRNGSources
	ld d, %00001000
	and %11
	ld c, a
	ld b, a
.loop
	jr z, .done
	srl d
	dec b
	jr .loop
.done
	ld a, d
	and e ; has this legendary been given already?
	jr nz, .new_random
	push bc
	ld b, 0
	ld hl, LegendaryCardEvents
	add hl, bc
	ld a, [hl]
	call MaxOutEventValue ; also modifies EVENT_LEGENDARY_CARDS_RECEIVED_FLAGS
	pop bc
	ld hl, LegendaryCards
	ld a, c
	jr ScriptCommand_PickChallengeCupPrizeCard.get_card_from_list

LegendaryCards: ; d234 (3:5234)
	db ZAPDOS3
	tx ZapdosLegendaryCardName

	db MOLTRES2
	tx MoltresLegendaryCardName

	db ARTICUNO2
	tx ArticunoLegendaryCardName

	db DRAGONITE1
	tx DragoniteLegendaryCardName

LegendaryCardEvents: ; d240 (3:5240)
	db EVENT_RECEIVED_ZAPDOS
	db EVENT_RECEIVED_MOLTRES
	db EVENT_RECEIVED_ARTICUNO
	db EVENT_RECEIVED_DRAGONITE

ScriptCommand_ReplaceMapBlocks: ; d244 (3:5244)
	ld a, c
	farcall Func_80ba4
	jp IncreaseScriptPointerBy2

ScriptCommand_ChooseDeckToDuelAgainstMultichoice: ; d24c (3:524c)
	ld hl, .multichoice_menu_args
	xor a
	call ShowMultichoiceTextbox
	ld a, [wMultichoiceTextboxResult_ChooseDeckToDuelAgainst]
	ld c, a
	set_event_value EVENT_AARON_DECK_MENU_CHOICE
	jp IncreaseScriptPointerBy1

.multichoice_menu_args ; d25e
	dw NULL ; NPC title for textbox under menu
	tx SelectDeckToDuelText ; text for textbox under menu
	dw MultichoiceTextbox_ConfigTable_ChooseDeckToDuelAgainst ; location of table configuration in bank 4
	db AARON_DECK_MENU_CANCEL ; the value to return when b is pressed
	dw wMultichoiceTextboxResult_ChooseDeckToDuelAgainst ; ram location to return result into
	dw .text_entries ; location of table containing text entries

.text_entries ; d269
	tx LightningAndFireDeckChoiceText
	tx WaterAndFightingDeckChoiceText
	tx GrassAndPsychicDeckChoiceText

	dw NULL

ScriptCommand_ChooseStarterDeckMultichoice: ; d271 (3:5271)
	ld hl, .multichoice_menu_args
	xor a
	call ShowMultichoiceTextbox
	jp IncreaseScriptPointerBy1

.multichoice_menu_args ; d27b
	dw NULL ; NPC title for textbox under menu
	tx SelectDeckToTakeText ; text for textbox under menu
	dw MultichoiceTextbox_ConfigTable_ChooseDeckStarterDeck ; location of table configuration in bank 4
	db $00 ; the value to return when b is pressed
	dw wStarterDeckChoice ; ram location to return result into
	dw .text_entries ; location of table containing text entries

.text_entries
	tx CharmanderAndFriendsDeckChoiceText
	tx SquirtleAndFriendsDeckChoiceText
	tx BulbasaurAndFriendsDeckChoiceText

; displays a textbox with multiple choices and a cursor.
; takes as an argument in h1 a pointer to a table
;	dw text id for NPC title for textbox under menu
;	dw text id for textbox under menu
;	dw location of table configuration in bank 4
;	db the value to return when b is pressed
;	dw ram location to return result into
;	dw location of table containing text entries (optional)

ShowMultichoiceTextbox: ; d28c (3:528c)
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
	jr z, .no_text
	call Func_c8ba
.no_text
	ld a, $1
	call Func_c29b
	pop hl
	inc hl
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	ld a, [wd416]
	farcall InitAndPrintPauseMenu
	pop hl
	inc hl
	ld a, [hli]
	ld [wd417], a
	push hl

.wait_input
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .wait_input
	ld a, [hCurMenuItem]
	cp e
	jr z, .got_result
	ld a, [wd417]
	or a
	jr z, .wait_input
	ld e, a
	ld [hCurMenuItem], a

.got_result
	pop hl
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	ld a, e
	ld [hl], a ; store result
	add a
	ld c, a
	ld b, $0
	pop hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .no_text_2
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
.no_text_2
	ret

ScriptCommand_ShowSamNormalMultichoice: ; d2f6 (3:52f6)
	ld hl, .multichoice_menu_args
	xor a
	call ShowMultichoiceTextbox
	ld a, [wMultichoiceTextboxResult_Sam]
	ld c, a
	set_event_value EVENT_SAM_MENU_CHOICE
	xor a
	ld [wMultichoiceTextboxResult_Sam], a
	jp IncreaseScriptPointerBy1

.multichoice_menu_args ; d30c
	tx SamNPCName ; NPC title for textbox under menu
	tx HowCanIHelpText ; text for textbox under menu
	dw SamNormalMultichoice_ConfigurationTable ; location of table configuration in bank 4
	db SAM_MENU_NOTHING ; the value to return when b is pressed
	dw wMultichoiceTextboxResult_Sam ; ram location to return result into
	dw NULL ; location of table containing text entries

ScriptCommand_ShowSamRulesMultichoice: ; d317 (3:5317)
	ld hl, .multichoice_menu_args
	ld a, [wMultichoiceTextboxResult_Sam]
	call ShowMultichoiceTextbox
	ld a, [wMultichoiceTextboxResult_Sam]
	ld c, a
	set_event_value EVENT_SAM_MENU_CHOICE
	jp IncreaseScriptPointerBy1

.multichoice_menu_args ; d32b (3:532b)
	dw NULL ; NPC title for textbox under menu
	dw NULL ; text for textbox under menu
	dw SamRulesMultichoice_ConfigurationTable ; location of table configuration in bank 4
	db SAM_MENU_NOTHING_TO_ASK ; the value to return when b is pressed
	dw wMultichoiceTextboxResult_Sam ; ram location to return result into
	dw NULL ; location of table containing text entries

ScriptCommand_OpenDeckMachine: ; d336 (3:5336)
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
	ld [wCurAutoDeckMachine], a
	farcall HandleAutoDeckMenu
	jr .asm_d364
.asm_d360
	farcall HandleDeckSaveMachineMenu
.asm_d364
	call ResumeSong
	call Func_c2d4
	jp IncreaseScriptPointerBy2

; args: unused, room, new player x, new player y, new player direction
ScriptCommand_EnterMap: ; d36d (3:536d)
	ld a, [wScriptPointer]
	ld l, a
	ld a, [wScriptPointer + 1]
	ld h, a
	inc hl
	ld a, [hli]
	ld a, [hli]
	ld [wTempMap], a
	ld a, [hli]
	ld [wTempPlayerXCoord], a
	ld a, [hli]
	ld [wTempPlayerYCoord], a
	ld a, [hli]
	ld [wTempPlayerDirection], a
	ld hl, wOverworldTransition
	set 4, [hl]
	jp IncreaseScriptPointerBy6

ScriptCommand_FlashScreen: ; d38f (3:538f)
	farcall Func_10c96
	jp IncreaseScriptPointerBy2

ScriptCommand_SaveGame: ; d396 (3:5396)
	farcall _SaveGame
	jp IncreaseScriptPointerBy2

ScriptCommand_GiftCenter: ; d39d (3:539d)
	ld a, c
	or a
	jr nz, .load_gift_center
	; show menu
	farcall Func_10dba
	ld c, a
	set_event_value EVENT_GIFT_CENTER_MENU_CHOICE
	jr .done

.load_gift_center
	ld a, GAME_EVENT_GIFT_CENTER
	ld [wGameEvent], a
	ld hl, wOverworldTransition
	set 6, [hl]
.done
	jp IncreaseScriptPointerBy2

ScriptCommand_PlayCredits: ; d3b9 (3:53b9)
	call GetReceivedLegendaryCards
	ld a, GAME_EVENT_CREDITS
	ld [wGameEvent], a
	ld hl, wOverworldTransition
	set 6, [hl]
	jp IncreaseScriptPointerBy1

ScriptCommand_TryGivePCPack: ; d3c9 (3:53c9)
	ld a, c
	farcall TryGivePCPack
	jp IncreaseScriptPointerBy2

ScriptCommand_nop: ; d3d1 (3:53d1)
	jp IncreaseScriptPointerBy1

ScriptCommand_GiveStarterDeck: ; d3d4 (3:53d4)
	ld a, [wStarterDeckChoice]
	bank1call Func_7576
	jp IncreaseScriptPointerBy1

Unknown_d3dd: ; d3dd (3:53dd)
	db $03, $05, $07

ScriptCommand_WalkPlayerToMasonLaboratory: ; d3e0 (3:53e0)
	ld a, OWMAP_MASON_LABORATORY
	ld [wOverworldMapSelection], a
	farcall OverworldMap_BeginPlayerMovement
.asm_d3e9
	call DoFrameIfLCDEnabled
	farcall OverworldMap_UpdatePlayerWalkingAnimation
	ld a, [wOverworldMapPlayerAnimationState]
	cp $2
	jr nz, .asm_d3e9
	farcall OverworldMap_PrintMapName
	jp IncreaseScriptPointerBy1

ScriptCommand_OverrideSong: ; d3fe (3:53fe)
	ld a, c
	ld [wd112], a
	call PlaySong
	jp IncreaseScriptPointerBy2

ScriptCommand_SetDefaultSong: ; d408 (3:5408)
	ld a, c
	ld [wDefaultSong], a
	jp IncreaseScriptPointerBy2

ScriptCommand_PlaySong: ; d40f (3:540f)
	ld a, c
	call ScriptPlaySong
	jp IncreaseScriptPointerBy2

ScriptCommand_PlaySFX: ; d416 (3:5416)
	ld a, c
	call PlaySFX
	jp IncreaseScriptPointerBy2

ScriptCommand_PlayDefaultSong: ; d41d (3:541d)
	call PlayDefaultSong
	jp IncreaseScriptPointerBy1

ScriptCommand_PauseSong: ; d423 (3:5423)
	call PauseSong
	jp IncreaseScriptPointerBy1

ScriptCommand_ResumeSong: ; d429 (3:5429)
	call ResumeSong
	jp IncreaseScriptPointerBy1

ScriptCommand_WaitForSongToFinish: ; d42f (3:542f)
	call WaitForSongToFinish
	jp IncreaseScriptPointerBy1

ScriptCommand_RecordMasterWin: ; d435 (3:5435)
	ld a, c
	farcall AddMasterBeatenToList
	jp IncreaseScriptPointerBy2

ScriptCommand_ChallengeMachine: ; d43d (3:543d)
	ld a, GAME_EVENT_CHALLENGE_MACHINE
	ld [wGameEvent], a
	ld hl, wOverworldTransition
	set 6, [hl]
	jp IncreaseScriptPointerBy1

; sets the event var in arg 1 to the value in arg 2
ScriptCommand_SetEventValue: ; d44a (3:544a)
	ld a, c
	ld c, b
	call SetEventValue
	jp IncreaseScriptPointerBy3

ScriptCommand_IncrementEventValue: ; d452 (3:5452)
	ld a, c
	push af
	call GetEventValue
	inc a
	ld c, a
	pop af
	call SetEventValue
	jp IncreaseScriptPointerBy2

ScriptCommand_JumpIfEventZero: ; d460 (3:5460)
	ld a, c
	call GetEventValue
	or a
	jr z, .pass_try_jump

.fail
	call SetScriptControlByteFail
	jp IncreaseScriptPointerBy4

.pass_try_jump
	call SetScriptControlBytePass
	call GetScriptArgs2AfterPointer
	jr z, .no_jump
	jp SetScriptPointer

.no_jump
	jp IncreaseScriptPointerBy4

ScriptCommand_JumpIfEventNonzero: ; d47b (3:547b)
	ld a, c
	call GetEventValue
	or a
	jr nz, ScriptCommand_JumpIfEventZero.pass_try_jump
	jr ScriptCommand_JumpIfEventZero.fail

; args - event var, value, jump address
ScriptCommand_JumpIfEventEqual: ; d484 (3:5484)
	call GetEventValueBC
	cp c
	jr z, .pass_try_jump

.fail
	call SetScriptControlByteFail
	jp IncreaseScriptPointerBy5

.pass_try_jump
	call SetScriptControlBytePass
	call GetScriptArgs3AfterPointer
	jr z, .no_jump
	jp SetScriptPointer

.no_jump
	jp IncreaseScriptPointerBy5

ScriptCommand_JumpIfEventNotEqual: ; d49e (3:549e)
	call GetEventValueBC
	cp c
	jr nz, ScriptCommand_JumpIfEventEqual.pass_try_jump
	jr ScriptCommand_JumpIfEventEqual.fail

ScriptCommand_JumpIfEventGreaterOrEqual: ; d4a6 (3:54a6)
	call GetEventValueBC
	cp c
	jr nc, ScriptCommand_JumpIfEventEqual.pass_try_jump
	jr ScriptCommand_JumpIfEventEqual.fail

ScriptCommand_JumpIfEventLessThan: ; d4ae (3:54ae)
	call GetEventValueBC
	cp c
	jr c, ScriptCommand_JumpIfEventEqual.pass_try_jump
	jr ScriptCommand_JumpIfEventEqual.fail

; Gets event value at c (Script defaults)
; c takes on the value of b as a side effect
GetEventValueBC: ; d4b6 (3:54b6)
	ld a, c
	ld c, b
	call GetEventValue
	ret

ScriptCommand_MaxOutEventValue: ; d4bc (3:54bc)
	ld a, c
	call MaxOutEventValue
	jp IncreaseScriptPointerBy2

ScriptCommand_ZeroOutEventValue: ; d4c3 (3:54c3)
	ld a, c
	call ZeroOutEventValue
	jp IncreaseScriptPointerBy2

ScriptCommand_JumpIfEventTrue: ; d4ca (3:54ca)
	ld a, c
	call GetEventValue
	or a
	jr z, ScriptCommand_JumpIfEventFalse.fail

.pass_try_jump
	call SetScriptControlBytePass
	call GetScriptArgs2AfterPointer
	jr z, .no_jump
	jp SetScriptPointer

.no_jump
	jp IncreaseScriptPointerBy4

ScriptCommand_JumpIfEventFalse: ; d4df (3:54df)
	ld a, c
	call GetEventValue
	or a
	jr z, ScriptCommand_JumpIfEventTrue.pass_try_jump

.fail
	call SetScriptControlByteFail
	jp IncreaseScriptPointerBy4

LoadOverworld: ; d4ec (3:54ec)
	call Func_d4fb
	get_event_value EVENT_MASON_LAB_STATE
	or a
	ret nz
	ld bc, Script_BeginGame
	jp SetNextScript

Func_d4fb: ; d4fb (3:54fb)
	set_event_false EVENT_PLAYER_ENTERED_CHALLENGE_CUP
	call Func_f602
	get_event_value EVENT_CHALLENGE_CUP_1_STATE
	cp CHALLENGE_CUP_WON
	jr z, .close_challenge_cup_one
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	cp CHALLENGE_CUP_WON
	jr z, .close_challenge_cup_two
	get_event_value EVENT_CHALLENGE_CUP_3_STATE
	cp CHALLENGE_CUP_WON
	jr z, .close_challenge_cup_three
	ret

.close_challenge_cup_three
	ld c, CHALLENGE_CUP_OVER
	set_event_value EVENT_CHALLENGE_CUP_3_STATE
.close_challenge_cup_two
	ld c, CHALLENGE_CUP_OVER
	set_event_value EVENT_CHALLENGE_CUP_2_STATE
.close_challenge_cup_one
	ld c, CHALLENGE_CUP_OVER
	set_event_value EVENT_CHALLENGE_CUP_1_STATE
	ret

Script_BeginGame: ; d52e (3:552e)
	start_script
	do_frames 60
	walk_player_to_mason_lab
	do_frames 120
	enter_map $02, MASON_LABORATORY, 14, 26, NORTH
	quit_script_fully

MasonLaboratoryAfterDuel: ; d53b (3:553b)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_SAM
	db NPC_SAM
	dw Script_BeatSam
	dw Script_LostToSam
	db $00

MasonLabLoadMap: ; d549 (3:5549)
	get_event_value EVENT_MASON_LAB_STATE
	cp MASON_LAB_RECEIVED_STARTER_DECK
	ret nc
	ld a, NPC_DRMASON
	ld [wTempNPC], a
	call FindLoadedNPC
	ld bc, Script_EnterLabFirstTime
	jp SetNextNPCAndScript

MasonLabCloseTextBox: ; d55e (3:555e)
	ld a, MAP_EVENT_CHALLENGE_MACHINE
	farcall Func_80b89
	ret

; Lets you access the Challenge Machine if available
MasonLabPressedA: ; d565 (3:5565)
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	ret z
	ld hl, ChallengeMachineObjectTable
	call FindExtraInteractableObjects
	ret

ChallengeMachineObjectTable: ; d572 (3:5572)
	db 10, 4, NORTH
	dw Script_ChallengeMachine
	db 12, 4, NORTH
	dw Script_ChallengeMachine
	db $00

Script_ChallengeMachine: ; d57d (3:557d)
	start_script
	print_text ItsTheChallengeMachineText
	challenge_machine
	quit_script_fully

Script_Tech1: ; d583 (3:5583)
	lb bc, 0, EnergyCardList.end - EnergyCardList
	ld hl, EnergyCardList
.count_loop
	ld a, [hli]
	call GetCardCountInCollection
	add b
	ld b, a
	dec c
	jr nz, .count_loop
	ld a, b
	cp 10
	jr c, .low_on_energies

	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech1MasterMedalExplanationText, Tech1AutoDeckMachineExplanationText
	quit_script_fully

.low_on_energies
	ld c, EnergyCardList.end - EnergyCardList
	ld hl, EnergyCardList
.next_energy_card
	ld b, 10
	ld a, [hli]
.add_loop
	push af
	call AddCardToCollection
	pop af
	dec b
	jr nz, .add_loop
	dec c
	jr nz, .next_energy_card

	start_script
	print_npc_text Tech1FewEnergyCardsText
	pause_song
	play_song MUSIC_BOOSTER_PACK
	print_npc_text Tech1ReceivedEnergyCardsText
	wait_for_song_to_finish
	resume_song
	print_text_quit_fully Tech1GoodbyeText

EnergyCardList: ; d5c4 (3:55c4)
	db GRASS_ENERGY
	db FIRE_ENERGY
	db WATER_ENERGY
	db LIGHTNING_ENERGY
	db FIGHTING_ENERGY
	db PSYCHIC_ENERGY
.end

Script_Tech2: ; d5ca (3:55ca)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech2LegendaryCardsExplanationText, Tech2LegendaryCardsCongratsText
	quit_script_fully

Script_Tech3: ; d5d5 (3:55d5)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech3BoosterPackExplanationText, Tech3LegendaryCardsCongratsText
	quit_script_fully

Script_Tech4: ; d5e0 (3:55e0)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech4ClubsExplanationText, Tech4DefeatedTheGrandMastersText
	quit_script_fully

Preload_Tech5: ; d5eb (3:55eb)
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	jr z, .skip
	ld hl, wLoadNPCXPos
	inc [hl]
	inc [hl]
.skip
	scf
	ret

Script_Tech5: ; d5f9 (3:55f9)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech5DiaryAndEmailExplanationText, Tech5ChallengeMachineExplanationText
	quit_script_fully

Preload_Sam: ; d604 (3:5604)
	get_event_value EVENT_MASON_LAB_STATE
	cp MASON_LAB_IN_PRACTICE_DUEL
	jr nc, .sam_at_table
	ld a, $0a
	ld [wLoadNPCXPos], a
	ld a, $08
	ld [wLoadNPCYPos], a
	ld a, SOUTH
	ld [wLoadNPCDirection], a
.sam_at_table
	scf
	ret

Script_Sam: ; d61d (3:561d)
	start_script
	show_sam_normal_multichoice
	close_text_box
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NORMAL_DUEL, .ows_d63b
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_RULES, Script_LostToSam.ows_d6b0
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NOTHING, .ows_d637
; SAM_MENU_PRACTICE_DUEL
	print_npc_text Text05cb
	ask_question_jump Text05cc, .ows_d647
.ows_d637
	print_npc_text Text05cd
	quit_script_fully

.ows_d63b
	print_npc_text Text05ce
	ask_question_jump Text05cf, .ows_d647
	print_npc_text Text05d0
	quit_script_fully

.ows_d647
	close_text_box
	jump_if_player_coords_match 4, 12, .ows_above_sam
	jump_if_player_coords_match 2, 14, .ows_left_of_sam
; ows_below_sam
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction NORTH
	move_player NORTH, 1
.ows_left_of_sam
	set_player_direction NORTH
	move_player NORTH, 1
	set_player_direction EAST
	move_player EAST, 1
.ows_above_sam
	set_player_direction EAST
	move_player EAST, 1
	move_player EAST, 1
	move_player EAST, 1
	set_player_direction SOUTH
	move_player SOUTH, 1
	set_player_direction WEST
	move_active_npc NPCMovement_d889
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NORMAL_DUEL, .ows_d685
	start_duel PRIZES_2, SAMS_PRACTICE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

.ows_d685
	start_duel PRIZES_2, SAMS_NORMAL_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatSam: ; d68a (3:568a)
	start_script
	jump_if_event_equal EVENT_MASON_LAB_STATE, MASON_LAB_IN_PRACTICE_DUEL, Script_EnterLabFirstTime.ows_d82d
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_PRACTICE_DUEL, Script_LostToSam.ows_d6ad
	print_npc_text Text05d1
	give_booster_packs BOOSTER_ENERGY_RANDOM, NO_BOOSTER, NO_BOOSTER
	print_text_quit_fully Text05d2

Script_LostToSam: ; d69f (3:569f)
	start_script
	jump_if_event_equal EVENT_MASON_LAB_STATE, MASON_LAB_IN_PRACTICE_DUEL, Script_EnterLabFirstTime.ows_d82d
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_PRACTICE_DUEL, .ows_d6ad
	print_text_quit_fully Text05d3

.ows_d6ad
	print_text_quit_fully Text05d4

.ows_d6b0
	print_npc_text Text05d5
.ows_d6b3
	close_text_box
	show_sam_rules_multichoice
	close_text_box
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NOTHING_TO_ASK, Script_Sam.ows_d637
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_ATTACKING, .ows_d6df
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_RETREATING, .ows_d6e5
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_EVOLVING, .ows_d6eb
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_POKEMON_POWER, .ows_d6f1
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_ENDING_YOUR_TURN, .ows_d6f7
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_WIN_OR_LOSS, .ows_d6fd
; SAM_MENU_ENERGY
	print_npc_text Text05d6
	script_jump .ows_d6b3

.ows_d6df
	print_npc_text Text05d7
	script_jump .ows_d6b3

.ows_d6e5
	print_npc_text Text05d8
	script_jump .ows_d6b3

.ows_d6eb
	print_npc_text Text05d9
	script_jump .ows_d6b3

.ows_d6f1
	print_npc_text Text05da
	script_jump .ows_d6b3

.ows_d6f7
	print_npc_text Text05db
	script_jump .ows_d6b3

.ows_d6fd
	print_npc_text Text05dc
	script_jump .ows_d6b3

Func_d703: ; d703 (3:5703)
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	ret z
	ld a, $0a
	farcall Func_80ba4
	ret

Preload_DrMason: ; d710 (3:5710)
	call Func_d703
	get_event_value EVENT_MASON_LAB_STATE
	cp MASON_LAB_IN_PRACTICE_DUEL
	jr nz, .not_practice_duel
	ld a, $06
	ld [wLoadNPCXPos], a
	ld a, $0c
	ld [wLoadNPCYPos], a
.not_practice_duel
	scf
	ret

Script_DrMason: ; d727 (3:5727)
	start_script
	jump_if_event_true EVENT_RONALD_FIRST_CLUB_ENTRANCE_ENCOUNTER, .ows_d72f
	print_text_quit_fully Text05dd

.ows_d72f
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 2, .ows_d738
	print_text_quit_fully Text05de

.ows_d738
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 7, .ows_d740
	print_text_quit_fully Text05df

.ows_d740
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_d747
	print_text_quit_fully Text05e0

.ows_d747
	jump_if_event_true EVENT_DRMASON_CONGRATULATED_PLAYER, .ows_d750
	max_out_event_value EVENT_DRMASON_CONGRATULATED_PLAYER
	print_text_quit_fully Text05e1

.ows_d750
	print_text_quit_fully Text05e2

Script_EnterLabFirstTime: ; d753 (3:5753)
	start_script
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	print_npc_text Text05e3
	close_advanced_text_box
	set_next_npc_and_script NPC_SAM, .ows_d779
	end_script
	ret

.ows_d779
	start_script
	move_active_npc NPCMovement_d880
	print_npc_text Text05e4
	set_dialog_npc NPC_DRMASON
	print_npc_text Text05e5
	close_text_box
	move_active_npc NPCMovement_d882
	set_active_npc_direction EAST
	set_player_direction WEST
	close_advanced_text_box
	set_next_npc_and_script NPC_DRMASON, .ows_d794
	end_script
	ret

.ows_d794
	start_script
	move_active_npc NPCMovement_d88b
	do_frames 40
	print_npc_text Text05e6
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	set_player_direction WEST
	move_active_npc NPCMovement_d894
	print_npc_text Text05e7
	set_dialog_npc NPC_SAM
	print_npc_text Text05e8
.ows_d7bc
	close_text_box
	show_sam_rules_multichoice
	close_text_box
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NOTHING_TO_ASK, .ows_d80c
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_ATTACKING, .ows_d7e8
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_RETREATING, .ows_d7ee
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_EVOLVING, .ows_d7f4
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_POKEMON_POWER, .ows_d7fa
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_ENDING_YOUR_TURN, .ows_d800
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_WIN_OR_LOSS, .ows_d806
; SAM_MENU_ENERGY
	print_npc_text Text05d6
	script_jump .ows_d7bc

.ows_d7e8
	print_npc_text Text05d7
	script_jump .ows_d7bc

.ows_d7ee
	print_npc_text Text05d8
	script_jump .ows_d7bc

.ows_d7f4
	print_npc_text Text05d9
	script_jump .ows_d7bc

.ows_d7fa
	print_npc_text Text05da
	script_jump .ows_d7bc

.ows_d800
	print_npc_text Text05db
	script_jump .ows_d7bc

.ows_d806
	print_npc_text Text05dc
	script_jump .ows_d7bc

.ows_d80c
	print_npc_text Text05e9
	ask_question_jump_default_yes NULL, .ows_d817
	script_jump .ows_d7bc

.ows_d817
	set_dialog_npc NPC_DRMASON
	print_npc_text Text05ea
	script_nop
	set_event EVENT_MASON_LAB_STATE, MASON_LAB_IN_PRACTICE_DUEL
	close_advanced_text_box
	set_next_npc_and_script NPC_SAM, .ows_d827
	end_script
	ret

.ows_d827
	start_script
	start_duel PRIZES_2, SAMS_PRACTICE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

.ows_d82d
	close_advanced_text_box
	set_next_npc_and_script NPC_DRMASON, Script_AfterPracticeDuel
	end_script
	ret

Script_AfterPracticeDuel: ; d834 (3:5834)
	start_script
	print_npc_text Text05eb
	print_npc_text Text05ef
	close_text_box
	move_active_npc NPCMovement_d896
	set_player_direction NORTH
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	set_player_direction EAST
	move_player EAST, 1
	move_player EAST, 1
	set_player_direction NORTH
	print_npc_text Text05f0
	close_text_box
	print_text Text05f1
	close_text_box
	print_npc_text Text05f2
.ows_d85f
	choose_starter_deck
	close_text_box
	ask_question_jump Text05f3, .ows_d869
	script_jump .ows_d85f

.ows_d869
	print_npc_text Text05f4
	close_text_box
	pause_song
	play_song MUSIC_BOOSTER_PACK
	print_text Text05f5
	wait_for_song_to_finish
	resume_song
	close_text_box
	set_event EVENT_MASON_LAB_STATE, MASON_LAB_RECEIVED_STARTER_DECK
	give_stater_deck
	print_npc_text Text05f6
	save_game 0
	quit_script_fully

NPCMovement_d880: ; d880 (3:5880)
	db EAST
	db $ff

NPCMovement_d882: ; d882 (3:5882)
	db SOUTH
	db SOUTH
	db WEST
	db WEST
	db WEST
	db WEST
	db SOUTH
NPCMovement_d889: ; d889 (3:5889)
	db EAST | NO_MOVE
	db $ff

NPCMovement_d88b: ; d88b (3:588b)
	db WEST
	db SOUTH
	db SOUTH
	db SOUTH
	db WEST
	db WEST
	db WEST
	db EAST | NO_MOVE
	db $ff

NPCMovement_d894: ; d894 (3:5894)
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_d896: ; d896 (3:5896)
	db NORTH
	db NORTH
	db NORTH
	db EAST
	db EAST
	db EAST
	db EAST
	db SOUTH | NO_MOVE
	db $ff

DeckMachineRoomAfterDuel: ; d89f (3:589f)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_AARON
	db NPC_AARON
	dw Script_BeatAaron
	dw Script_LostToAaron
	db $00

DeckMachineRoomCloseTextBox: ; d8ad (3:58ad)
	ld a, MAP_EVENT_FIGHTING_DECK_MACHINE
.asm_d8af
	push af
	farcall Func_80b89
	pop af
	inc a
	cp MAP_EVENT_FIRE_DECK_MACHINE + 1
	jr c, .asm_d8af
	ret

Script_Tech6: ; d8bb (3:58bb)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text05f7, Text05f8
	quit_script_fully

Script_Tech7: ; d8c6 (3:58c6)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text05f9, Text05fa
	quit_script_fully

Script_Tech8: ; d8d1 (3:58d1)
	start_script
	test_if_event_not_equal EVENT_ALL_DECK_MACHINE_FLAGS, $ff
	print_variable_npc_text Text05fb, Text05fc
	quit_script_fully

Script_Aaron: ; d8dd (3:58dd)
	start_script
	print_npc_text Text05fd
	ask_question_jump Text05fe, .ows_d8e9
.ows_d8e6
	print_text_quit_fully Text05ff

.ows_d8e9
	print_npc_text Text0600
	choose_deck_to_duel_against
	close_text_box
	jump_if_event_equal EVENT_AARON_DECK_MENU_CHOICE, AARON_DECK_MENU_CANCEL, .ows_d8e6
	ask_question_jump Text0601, .ows_d8fb
	script_jump .ows_d8e6

.ows_d8fb
	print_npc_text Text0602
	start_duel PRIZES_4, $ff, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatAaron: ; d903 (3:5903)
	ld a, [wMultichoiceTextboxResult_ChooseDeckToDuelAgainst]
	ld c, a
	set_event_value EVENT_AARON_BOOSTER_REWARD

	start_script
	print_npc_text Text0603
	jump_if_event_equal EVENT_AARON_BOOSTER_REWARD, 1, .ows_d920
	jump_if_event_equal EVENT_AARON_BOOSTER_REWARD, 2, .ows_d927
	give_booster_packs BOOSTER_ENERGY_RANDOM, NO_BOOSTER, NO_BOOSTER
	script_jump Script_LostToAaron.ows_d92f

.ows_d920
	give_booster_packs BOOSTER_ENERGY_RANDOM, NO_BOOSTER, NO_BOOSTER
	script_jump Script_LostToAaron.ows_d92f

.ows_d927
	give_booster_packs BOOSTER_ENERGY_RANDOM, NO_BOOSTER, NO_BOOSTER
	script_jump Script_LostToAaron.ows_d92f

Script_LostToAaron: ; d92e (3:592e)
	start_script
.ows_d92f
	print_text_quit_fully Text0604

Script_d932: ; d932 (3:5932)
	start_script
	print_text Text0605
	ask_question_jump_default_yes Text0606, .ows_d93c
	quit_script_fully

.ows_d93c
	open_deck_machine $09
	quit_script_fully

Script_d93f: ; d93f (3:593f)
	ld a, $02
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_FIGHTING_DECK_MACHINE_ACTIVE, .ows_d963
	print_text Text0608
	jump_if_event_true EVENT_BEAT_MITCH, .ows_d954
	quit_script_fully

.ows_d954
	ask_question_jump_default_yes Text0609, .ows_d95a
	quit_script_fully

.ows_d95a
	play_sfx SFX_5A
	max_out_event_value EVENT_FIGHTING_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_FIGHTING_DECK_MACHINE
	print_text Text060a
.ows_d963
	ask_question_jump_default_yes Text060b, .ows_d969
	quit_script_fully

.ows_d969
	open_deck_machine $01
	quit_script_fully

Func_d96c: ; d96c (3:596c)
	sub 2
	add a
	ld c, a
	ld b, 0
	ld hl, ClubMapNames
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld [wTxRam2_b], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	ld [wTxRam2_b + 1], a
	ret

ClubMapNames: ; d985 (3:5985)
	tx FightingClubMapNameText
	tx RockClubMapNameText
	tx WaterClubMapNameText
	tx LightningClubMapNameText
	tx GrassClubMapNameText
	tx PsychicClubMapNameText
	tx ScienceClubMapNameText
	tx FireClubMapNameText

Script_d995: ; d995 (3:5995)
	ld a, $03
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_ROCK_DECK_MACHINE_ACTIVE, .ows_d9b9
	print_text Text0608
	jump_if_event_true EVENT_BEAT_GENE, .ows_d9aa
	quit_script_fully

.ows_d9aa
	ask_question_jump_default_yes Text0609, .ows_d9b0
	quit_script_fully

.ows_d9b0
	play_sfx SFX_5A
	max_out_event_value EVENT_ROCK_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_ROCK_DECK_MACHINE
	print_text Text060a
.ows_d9b9
	ask_question_jump_default_yes Text060b, .ows_d9bf
	quit_script_fully

.ows_d9bf
	open_deck_machine $02
	quit_script_fully

Script_d9c2: ; d9c2 (3:59c2)
	ld a, $04
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_WATER_DECK_MACHINE_ACTIVE, .ows_d9e6
	print_text Text0608
	jump_if_event_true EVENT_BEAT_AMY, .ows_d9d7
	quit_script_fully

.ows_d9d7
	ask_question_jump_default_yes Text0609, .ows_d9dd
	quit_script_fully

.ows_d9dd
	play_sfx SFX_5A
	max_out_event_value EVENT_WATER_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_WATER_DECK_MACHINE
	print_text Text060a
.ows_d9e6
	ask_question_jump_default_yes Text060b, .ows_d9ec
	quit_script_fully

.ows_d9ec
	open_deck_machine $03
	quit_script_fully

Script_d9ef: ; d9ef (3:59ef)
	ld a, $05
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_LIGHTNING_DECK_MACHINE_ACTIVE, .ows_da13
	print_text Text0608
	jump_if_event_true EVENT_BEAT_ISAAC, .ows_da04
	quit_script_fully

.ows_da04
	ask_question_jump_default_yes Text0609, .ows_da0a
	quit_script_fully

.ows_da0a
	play_sfx SFX_5A
	max_out_event_value EVENT_LIGHTNING_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_LIGHTNING_DECK_MACHINE
	print_text Text060a
.ows_da13
	ask_question_jump_default_yes Text060b, .ows_da19
	quit_script_fully

.ows_da19
	open_deck_machine $04
	quit_script_fully

Script_da1c: ; da1c (3:5a1c)
	ld a, $06
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_GRASS_DECK_MACHINE_ACTIVE, .ows_da40
	print_text Text0608
	jump_if_event_true EVENT_BEAT_NIKKI, .ows_da31
	quit_script_fully

.ows_da31
	ask_question_jump_default_yes Text0609, .ows_da37
	quit_script_fully

.ows_da37
	play_sfx SFX_5A
	max_out_event_value EVENT_GRASS_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_GRASS_DECK_MACHINE
	print_text Text060a
.ows_da40
	ask_question_jump_default_yes Text060b, .ows_da46
	quit_script_fully

.ows_da46
	open_deck_machine $05
	quit_script_fully

Script_da49: ; da49 (3:5a49)
	ld a, $07
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_PSYCHIC_DECK_MACHINE_ACTIVE, .ows_da6d
	print_text Text0608
	jump_if_event_true EVENT_BEAT_MURRAY, .ows_da5e
	quit_script_fully

.ows_da5e
	ask_question_jump_default_yes Text0609, .ows_da64
	quit_script_fully

.ows_da64
	play_sfx SFX_5A
	max_out_event_value EVENT_PSYCHIC_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_PSYCHIC_DECK_MACHINE
	print_text Text060a
.ows_da6d
	ask_question_jump_default_yes Text060b, .ows_da73
	quit_script_fully

.ows_da73
	open_deck_machine $06
	quit_script_fully

Script_da76: ; da76 (3:5a76)
	ld a, $08
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_SCIENCE_DECK_MACHINE_ACTIVE, .ows_da9a
	print_text Text0608
	jump_if_event_true EVENT_BEAT_RICK, .ows_da8b
	quit_script_fully

.ows_da8b
	ask_question_jump_default_yes Text0609, .ows_da91
	quit_script_fully

.ows_da91
	play_sfx SFX_5A
	max_out_event_value EVENT_SCIENCE_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_SCIENCE_DECK_MACHINE
	print_text Text060a
.ows_da9a
	ask_question_jump_default_yes Text060b, .ows_daa0
	quit_script_fully

.ows_daa0
	open_deck_machine $07
	quit_script_fully

Script_daa3: ; daa3 (3:5aa3)
	ld a, $09
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_FIRE_DECK_MACHINE_ACTIVE, .ows_dac7
	print_text Text0608
	jump_if_event_true EVENT_BEAT_KEN, .ows_dab8
	quit_script_fully

.ows_dab8
	ask_question_jump_default_yes Text0609, .ows_dabe
	quit_script_fully

.ows_dabe
	play_sfx SFX_5A
	max_out_event_value EVENT_FIRE_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_FIRE_DECK_MACHINE
	print_text Text060a
.ows_dac7
	ask_question_jump_default_yes Text060b, .ows_dacd
	quit_script_fully

.ows_dacd
	open_deck_machine $08
	quit_script_fully

Script_dad0: ; dad0 (3:5ad0)
	start_script
	print_text Text060c
	ask_question_jump_default_yes Text060d, .ows_dada
	quit_script_fully

.ows_dada
	open_deck_machine $00
	quit_script_fully

Preload_NikkiInIshiharasHouse: ; dadd (3:5add)
	get_event_value EVENT_NIKKI_STATE
	cp NIKKI_IN_ISHIHARAS_HOUSE
	jr nz, .dont_load
	scf
	ret
.dont_load
	or a
	ret

Script_NikkiInIshiharasHouse: ; dae9 (3:5ae9)
	start_script
	print_npc_text Text0723
	set_event EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB
	close_text_box
	jump_if_npc_loaded NPC_ISHIHARA, .ows_dafb
	move_active_npc_by_direction NPCMovementTable_db24
	script_jump .ows_db0f

.ows_dafb
	move_active_npc_by_direction NPCMovementTable_db11
	print_npc_text Text0724
	set_dialog_npc NPC_ISHIHARA
	print_npc_text Text0725
	set_dialog_npc NPC_NIKKI
	print_npc_text Text0726
	close_text_box
	move_active_npc NPCMovement_db31
.ows_db0f
	unload_active_npc
	quit_script_fully

NPCMovementTable_db11: ; db11 (3:5b11)
	dw NPCMovement_db19
	dw NPCMovement_db20
	dw NPCMovement_db19
	dw NPCMovement_db19

NPCMovement_db19: ; db19 (3:5b19)
	db EAST
	db SOUTH
	db SOUTH
	db SOUTH
	db EAST
	db NORTH | NO_MOVE
	db $ff

NPCMovement_db20: ; db20 (3:5b20)
	db SOUTH
	db EAST
	db $fe, -8

NPCMovementTable_db24: ; db24 (3:5b24)
	dw NPCMovement_db2c
	dw NPCMovement_db39
	dw NPCMovement_db2c
	dw NPCMovement_db2c

NPCMovement_db2c: ; db2c (3:5b2c)
	db EAST
	db SOUTH
	db SOUTH
	db SOUTH
	db EAST
NPCMovement_db31: ; db31 (3:5b31)
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

NPCMovement_db39: ; db39 (3:5b39)
	db SOUTH
	db EAST
	db $fe, -14

Preload_IshiharaInIshiharasHouse: ; db3d (3:5b3d)
	get_event_value EVENT_ISHIHARA_MENTIONED
	or a
	ret z
	get_event_value EVENT_ISHIHARA_TRADE_STATE
	cp ISHIHARA_LEFT
	ret

Script_Ishihara: ; db4a (3:5b4a)
	start_script
	max_out_event_value EVENT_ISHIHARA_MET
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_INTRODUCTION, .ows_db80
	jump_if_event_true EVENT_ISHIHARA_CONGRATULATED_PLAYER, .ows_db5a
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_dc3e
.ows_db5a
	jump_if_event_true EVENT_TEMP_TRADED_WITH_ISHIHARA, .ows_db90
	jump_if_event_false EVENT_ISHIHARA_WANTS_TO_TRADE, .ows_db90
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_RUMORED, .ows_db93
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_OFFERED, .ows_db93
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED, .ows_dbcc
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_OFFERED, .ows_dbcc
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED, .ows_dc05
	jump_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_OFFERED, .ows_dc05
.ows_db80
	max_out_event_value EVENT_TEMP_TRADED_WITH_ISHIHARA
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_RUMORED
	zero_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	jump_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS, .ows_db8d
	max_out_event_value EVENT_ISHIHARA_CONGRATULATED_PLAYER
.ows_db8d
	print_text_quit_fully Text0727

.ows_db90
	print_text_quit_fully Text0728

.ows_db93
	test_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_RUMORED
	print_variable_npc_text Text0729, Text072a
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_1_OFFERED
	ask_question_jump Text072b, .check_if_clefable_owned
	print_text_quit_fully Text072c

.check_if_clefable_owned
	jump_if_card_owned CLEFABLE, .check_if_clefable_in_collection
	print_text_quit_fully Text072d

.check_if_clefable_in_collection
	jump_if_card_in_collection CLEFABLE, .do_clefable_trade
	print_text_quit_fully Text072e

.do_clefable_trade
	max_out_event_value EVENT_TEMP_TRADED_WITH_ISHIHARA
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED
	zero_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_npc_text Text072f
	print_text Text0730
	take_card CLEFABLE
	give_card SURFING_PIKACHU1
	show_card_received_screen SURFING_PIKACHU1
	print_text_quit_fully Text0731

.ows_dbcc
	test_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED
	print_variable_npc_text Text0732, Text0733
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_OFFERED
	ask_question_jump Text072b, .check_if_ditto_owned
	print_text_quit_fully Text072c

.check_if_ditto_owned
	jump_if_card_owned DITTO, .check_if_ditto_in_collection
	print_text_quit_fully Text0734

.check_if_ditto_in_collection
	jump_if_card_in_collection DITTO, .do_ditto_trade
	print_text_quit_fully Text0735

.do_ditto_trade
	max_out_event_value EVENT_TEMP_TRADED_WITH_ISHIHARA
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED
	zero_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_npc_text Text072f
	print_text Text0736
	take_card DITTO
	give_card FLYING_PIKACHU
	show_card_received_screen FLYING_PIKACHU
	print_text_quit_fully Text0737

.ows_dc05
	test_if_event_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED
	print_variable_npc_text Text0738, Text0739
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_OFFERED
	ask_question_jump Text072b, .check_if_chansey_owned
	print_text_quit_fully Text072c

.check_if_chansey_owned
	jump_if_card_owned CHANSEY, .check_if_chansey_in_collection
	print_text_quit_fully Text073a

.check_if_chansey_in_collection
	jump_if_card_in_collection CHANSEY, .do_chansey_trade
	print_text_quit_fully Text073b

.do_chansey_trade
	max_out_event_value EVENT_TEMP_TRADED_WITH_ISHIHARA
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADES_COMPLETE
	zero_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_npc_text Text072f
	print_text Text073c
	take_card CHANSEY
	give_card SURFING_PIKACHU2
	show_card_received_screen SURFING_PIKACHU2
	print_text_quit_fully Text073d

.ows_dc3e
	max_out_event_value EVENT_ISHIHARA_CONGRATULATED_PLAYER
	print_text_quit_fully Text073e

Preload_Ronald1InIshiharasHouse: ; dc43 (3:5c43)
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	cp TRUE
	ccf
	ret

Script_Ronald: ; dc4b (3:5c4b)
	start_script
	jump_if_event_true EVENT_RONALD_TALKED, .ows_dc55
	max_out_event_value EVENT_RONALD_TALKED
	print_text_quit_fully Text073f

.ows_dc55
	print_npc_text Text0740
	ask_question_jump Text0741, .ows_dc60
	print_text_quit_fully Text0742

.ows_dc60
	print_text_quit_fully Text0743

	; could be a commented function, or could be placed by mistake from
	; someone thinking that the Ronald script ended with more code execution
	ret

Script_Clerk1: ; dc64 (3:5c64)
	start_script
	print_text_quit_fully Text045a

FightingClubLobbyAfterDuel: ; dc68 (3:5c68)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_IMAKUNI
	db NPC_IMAKUNI
	dw Script_BeatImakuni
	dw Script_LostToImakuni
	db $00

Script_Man1: ; dc76 (3:5c76)
	start_script
	jump_if_event_equal EVENT_MAN1_GIFT_SEQUENCE_STATE, MAN1_GIFT_SEQUENCE_COMPLETE, .ows_dce8
	jump_if_event_true EVENT_TEMP_GIFTED_TO_MAN1, .ows_dce5
	jump_if_event_true EVENT_MAN1_TALKED, .ows_dc91
	max_out_event_value EVENT_MAN1_TALKED
	pick_next_man1_requested_card
	load_man1_requested_card_into_txram_slot 0
	print_npc_text Text045b
	max_out_event_value EVENT_MAN1_WAITING_FOR_CARD
	script_jump .ows_dca5

.ows_dc91
	jump_if_event_false EVENT_MAN1_WAITING_FOR_CARD, .ows_dc9d
	load_man1_requested_card_into_txram_slot 0
	print_npc_text Text045c
	script_jump .ows_dca5

.ows_dc9d
	pick_next_man1_requested_card
	load_man1_requested_card_into_txram_slot 0
	print_npc_text Text045d
	max_out_event_value EVENT_MAN1_WAITING_FOR_CARD
.ows_dca5
	load_man1_requested_card_into_txram_slot 0
	ask_question_jump Text045e, .ows_dcaf
	print_text_quit_fully Text045f

.ows_dcaf
	jump_if_man1_requested_card_owned .ows_dcb9
	load_man1_requested_card_into_txram_slot 0
	load_man1_requested_card_into_txram_slot 1
	print_text_quit_fully Text0460

.ows_dcb9
	jump_if_man1_requested_card_in_collection .ows_dcc3
	load_man1_requested_card_into_txram_slot 0
	load_man1_requested_card_into_txram_slot 1
	print_text_quit_fully Text0461

.ows_dcc3
	load_man1_requested_card_into_txram_slot 0
	load_man1_requested_card_into_txram_slot 1
	print_npc_text Text0462
	remove_man1_requested_card_from_collection
	max_out_event_value EVENT_TEMP_GIFTED_TO_MAN1
	zero_out_event_value EVENT_MAN1_WAITING_FOR_CARD
	increment_event_value EVENT_MAN1_GIFT_SEQUENCE_STATE
	jump_if_event_equal EVENT_MAN1_GIFT_SEQUENCE_STATE, 5, .ows_dcd7
	quit_script_fully

.ows_dcd7
	print_npc_text Text0463
	give_card PIKACHU4
	show_card_received_screen PIKACHU4
	print_npc_text Text0464
	set_event EVENT_MAN1_GIFT_SEQUENCE_STATE, MAN1_GIFT_SEQUENCE_COMPLETE
	quit_script_fully

.ows_dce5
	print_text_quit_fully Text0465

.ows_dce8
	print_text_quit_fully Text0466

Preload_ImakuniInFightingClubLobby: ; dceb (3:5ceb)
	get_event_value EVENT_IMAKUNI_STATE
	cp IMAKUNI_MENTIONED
	jr z, .load_imakuni
	or a ; cp IMAKUNI_NOT_MENTIONED
	jr z, .dont_load
	get_event_value EVENT_TEMP_DUELED_IMAKUNI
	jr nz, .dont_load
	get_event_value EVENT_IMAKUNI_ROOM
	cp IMAKUNI_FIGHTING_CLUB
	jr z, .load_imakuni
.dont_load
	or a
	ret

.load_imakuni
	ld a, MUSIC_IMAKUNI
	ld [wDefaultSong], a
	scf
	ret

Script_Imakuni: ; dd0d (3:5d0d)
	start_script
	set_event EVENT_IMAKUNI_STATE, IMAKUNI_TALKED
	test_if_event_false EVENT_TEMP_TALKED_TO_IMAKUNI
	print_variable_npc_text Text0467, Text0468
	max_out_event_value EVENT_TEMP_TALKED_TO_IMAKUNI
	ask_question_jump Text0469, .start_duel
	print_npc_text Text046a
	quit_script_fully

.start_duel
	print_npc_text Text046b
	start_duel PRIZES_6, IMAKUNI_DECK_ID, MUSIC_IMAKUNI
	quit_script_fully

Script_BeatImakuni: ; dd2d (3:5d2d)
	start_script
	jump_if_event_equal EVENT_IMAKUNI_WIN_COUNT, 7, .give_boosters
	increment_event_value EVENT_IMAKUNI_WIN_COUNT
	jump_if_event_equal EVENT_IMAKUNI_WIN_COUNT, 3, .three_wins
	jump_if_event_equal EVENT_IMAKUNI_WIN_COUNT, 6, .six_wins
.give_boosters
	print_npc_text Text046c
	give_one_of_each_trainer_booster
	script_jump .done

.three_wins
	print_npc_text Text046d
	script_jump .give_imakuni_card

.six_wins
	print_npc_text Text046e
.give_imakuni_card
	print_npc_text Text046f
	give_card IMAKUNI_CARD
	show_card_received_screen IMAKUNI_CARD
.done
	print_npc_text Text0470
	script_jump Script_LostToImakuni.imakuni_common

Script_LostToImakuni: ; dd5c (3:5d5c)
	start_script
	print_npc_text Text0471
.imakuni_common
	close_text_box
	jump_if_player_coords_match 18, 4, .ows_dd69
	script_jump .ows_dd6e

.ows_dd69
	set_player_direction EAST
	move_player WEST, 1
.ows_dd6e
	move_active_npc NPCMovement_dd78
	unload_active_npc
	max_out_event_value EVENT_TEMP_DUELED_IMAKUNI
	set_default_song MUSIC_OVERWORLD
	play_default_song
	quit_script_fully

NPCMovement_dd78: ; dd78 (3:5d78)
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff

Script_Specs1: ; dd82 (3:5d82)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0472, Text0473
	quit_script_fully

Script_Butch: ; dd8d (3:5d8d)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0474, Text0475
	quit_script_fully

Preload_Granny1: ; dd98 (3:5d98)
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	cp TRUE
	ret

Script_Granny1: ; dd9f (3:5d9f)
	start_script
	print_text_quit_fully Text0476

FightingClubAfterDuel: ; dda3 (3:5da3)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_CHRIS
	db NPC_CHRIS
	dw Script_BeatChrisInFightingClub
	dw Script_LostToChrisInFightingClub

	db NPC_MICHAEL
	db NPC_MICHAEL
	dw Script_BeatMichaelInFightingClub
	dw Script_LostToMichaelInFightingClub

	db NPC_JESSICA
	db NPC_JESSICA
	dw Script_BeatJessicaInFightingClub
	dw Script_LostToJessicaInFightingClub

	db NPC_MITCH
	db NPC_MITCH
	dw Script_BeatMitch
	dw Script_LostToMitch
	db $00

Script_Mitch: ; ddc3 (3:5dc3)
	start_script
	try_give_pc_pack $02
	jump_if_event_true EVENT_BEAT_MITCH, Script_Mitch_AlreadyHaveMedal
	fight_club_pupil_jump .first_interaction, .three_pupils_remaining, \
		.two_pupils_remaining, .one_pupil_remaining, .all_pupils_defeated
.first_interaction
	print_npc_text Text0477
	set_event EVENT_PUPIL_MICHAEL_STATE, PUPIL_ACTIVE
	set_event EVENT_PUPIL_CHRIS_STATE, PUPIL_ACTIVE
	set_event EVENT_PUPIL_JESSICA_STATE, PUPIL_ACTIVE
	quit_script_fully

.three_pupils_remaining
	print_text_quit_fully Text0478

.two_pupils_remaining
	print_text_quit_fully Text0479

.one_pupil_remaining
	print_text_quit_fully Text047a

.all_pupils_defeated
	print_npc_text Text047b
	ask_question_jump Text047c, .start_duel
	print_npc_text Text047d
	quit_script_fully

.start_duel
	print_npc_text Text047e
	start_duel PRIZES_6, FIRST_STRIKE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatMitch: ; ddff (3:5dff)
	start_script
	jump_if_event_true EVENT_BEAT_MITCH, Script_Mitch_GiveBoosters
	print_npc_text Text047f
	max_out_event_value EVENT_BEAT_MITCH
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_MITCH
	record_master_win $01
	print_npc_text Text0480
	give_booster_packs BOOSTER_LABORATORY_NEUTRAL, BOOSTER_LABORATORY_NEUTRAL, NO_BOOSTER
	print_npc_text Text0481
	quit_script_fully

Script_LostToMitch: ; de19 (3:5e19)
	start_script
	jump_if_event_true EVENT_BEAT_MITCH, Script_Mitch_PrintTrainHarderText
	print_text_quit_fully Text0482

Script_Mitch_AlreadyHaveMedal: ; de21 (3:5e21)
	print_npc_text Text0483
	ask_question_jump Text047c, .start_duel
	print_npc_text Text0484
	quit_script_fully

.start_duel
	print_npc_text Text0485
	start_duel PRIZES_6, FIRST_STRIKE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_Mitch_GiveBoosters: ; de35 (3:5e35)
	print_npc_text Text0486
	give_booster_packs BOOSTER_LABORATORY_NEUTRAL, BOOSTER_LABORATORY_NEUTRAL, NO_BOOSTER
	print_npc_text Text0487
	quit_script_fully

Script_Mitch_PrintTrainHarderText: ; de40 (3:5e40)
	print_text_quit_fully Text0488

Preload_ChrisInFightingClub: ; de43 (3:5e43)
	get_event_value EVENT_PUPIL_CHRIS_STATE
	cp PUPIL_DEFEATED
	ccf
	ret

Script_de4b: ; de4b (3:5e4b)
	test_if_event_equal EVENT_PUPIL_CHRIS_STATE, PUPIL_DEFEATED
	print_variable_npc_text Text0489, Text048a
	set_event EVENT_PUPIL_CHRIS_STATE, PUPIL_REVISITED
	ask_question_jump Text048b, .ows_de61
	print_npc_text Text048c
	quit_script_fully

.ows_de61
	print_npc_text Text048d
	start_duel PRIZES_4, MUSCLES_FOR_BRAINS_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatChrisInFightingClub: ; de69 (3:5e69)
	start_script
	print_npc_text Text048e
	give_booster_packs BOOSTER_EVOLUTION_FIGHTING, BOOSTER_EVOLUTION_FIGHTING, NO_BOOSTER
	print_npc_text Text048f
	quit_script_fully

Script_LostToChrisInFightingClub: ; de75 (3:5e75)
	start_script
	print_text_quit_fully Text0490

Preload_MichaelInFightingClub: ; de79 (3:5e79)
	get_event_value EVENT_PUPIL_MICHAEL_STATE
	cp PUPIL_DEFEATED
	ccf
	ret

Script_MichaelRematch: ; de81 (3:5e81)
	print_npc_text Text0491
	ask_question_jump Text0492, .ows_de8d
	print_npc_text Text0493
	quit_script_fully

.ows_de8d
	print_npc_text Text0494
	start_duel PRIZES_4, HEATED_BATTLE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatMichaelInFightingClub: ; de95 (3:5e95)
	start_script
	print_npc_text Text0495
	give_booster_packs BOOSTER_COLOSSEUM_FIGHTING, BOOSTER_COLOSSEUM_FIGHTING, NO_BOOSTER
	print_npc_text Text0496
	quit_script_fully

Script_LostToMichaelInFightingClub: ; dea1 (3:5ea1)
	start_script
	print_text_quit_fully Text0497

Preload_JessicaInFightingClub: ; dea5 (3:5ea5)
	get_event_value EVENT_PUPIL_JESSICA_STATE
	cp PUPIL_DEFEATED
	ccf
	ret

Script_dead: ; dead (3:5ead)
	print_npc_text Text0498
	ask_question_jump Text0499, .ows_deb9
	print_npc_text Text049a
	quit_script_fully

.ows_deb9
	print_npc_text Text049b
	start_duel PRIZES_4, LOVE_TO_BATTLE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJessicaInFightingClub: ; dec1 (3:5ec1)
	start_script
	print_npc_text Text049c
	give_booster_packs BOOSTER_COLOSSEUM_FIGHTING, BOOSTER_COLOSSEUM_FIGHTING, NO_BOOSTER
	print_npc_text Text049d
	quit_script_fully

Script_LostToJessicaInFightingClub: ; decd (3:5ecd)
	start_script
	print_text_quit_fully Text049e

Script_Clerk2: ; ded1 (3:5ed1)
	start_script
	print_text_quit_fully Text0779

RockClubLobbyAfterDuel: ; ded5 (3:5ed5)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_CHRIS
	db NPC_CHRIS
	dw Script_BeatChrisInRockClubLobby
	dw Script_LostToChrisInRockClubLobby

	db NPC_MATTHEW
	db NPC_MATTHEW
	dw Script_BeatMatthew
	dw Script_LostToMatthew
	db $00

Preload_ChrisInRockClubLobby: ; dee9 (3:5ee9)
	get_event_value EVENT_PUPIL_CHRIS_STATE
	or a ; cp PUPIL_INACTIVE
	ret z
	cp PUPIL_DEFEATED
	ret

Script_Chris: ; def2 (3:5ef2)
	start_script
	jump_if_event_greater_or_equal EVENT_PUPIL_CHRIS_STATE, PUPIL_DEFEATED, Script_de4b
	print_npc_text Text077a
	ask_question_jump Text077b, .ows_df04
	print_npc_text Text077c
	quit_script_fully

.ows_df04
	print_npc_text Text077d
	start_duel PRIZES_4, MUSCLES_FOR_BRAINS_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatChrisInRockClubLobby: ; df0c (3:5f0c)
	start_script
	set_event EVENT_PUPIL_CHRIS_STATE, PUPIL_DEFEATED
	print_npc_text Text077e
	give_booster_packs BOOSTER_EVOLUTION_FIGHTING, BOOSTER_EVOLUTION_FIGHTING, NO_BOOSTER
	print_npc_text Text077f
	close_text_box
	move_active_npc_by_direction NPCMovementTable_df24
	unload_active_npc
	quit_script_fully

Script_LostToChrisInRockClubLobby: ; df20 (3:5f20)
	start_script
	print_text_quit_fully Text0780

NPCMovementTable_df24: ; df24 (3:5f24)
	dw NPCMovement_df2c
	dw NPCMovement_df2c
	dw NPCMovement_df34
	dw NPCMovement_df2c

NPCMovement_df2c: ; df2c (3:5f2c)
	db SOUTH
	db SOUTH
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff

NPCMovement_df34: ; df34 (3:5f34)
	db EAST
	db SOUTH
	db SOUTH
	db $fe, -9

Script_Matthew: ; df39 (3:5f39)
	start_script
	try_give_pc_pack $03
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_df4c
	test_if_event_zero EVENT_MATTHEW_STATE
	print_variable_npc_text Text0781, Text0782
	script_jump .ows_df4f

.ows_df4c
	print_npc_text Text0783
.ows_df4f
	set_event EVENT_MATTHEW_STATE, MATTHEW_TALKED
	ask_question_jump Text0784, .ows_df5b
	print_npc_text Text0785
	quit_script_fully

.ows_df5b
	print_npc_text Text0786
	start_duel PRIZES_4, HARD_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatMatthew: ; df63 (3:5f63)
	start_script
	set_event EVENT_MATTHEW_STATE, MATTHEW_DEFEATED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0787, Text0788
	give_booster_packs BOOSTER_MYSTERY_FIGHTING_COLORLESS, BOOSTER_MYSTERY_FIGHTING_COLORLESS, NO_BOOSTER
	print_npc_text Text0789
	quit_script_fully

Script_LostToMatthew: ; df78 (3:5f78)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text078a, Text078b
	quit_script_fully

Script_Woman1: ; df83 (3:5f83)
	start_script
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADES_COMPLETE, .ows_dfba
	jump_if_event_true EVENT_ISHIHARA_MET, .ows_df96
	max_out_event_value EVENT_ISHIHARA_MENTIONED
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text078c

.ows_df96
	jump_if_event_true EVENT_TEMP_TRADED_WITH_ISHIHARA, .ows_dfb7
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED, .ows_dfae
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED, .ows_dfa9
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text078d

.ows_dfa9
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text078e

.ows_dfae
	jump_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS, .ows_dfb7
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text078f

.ows_dfb7
	print_text_quit_fully Text0790

.ows_dfba
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_LEFT
	print_text_quit_fully Text0791

Script_Chap1: ; dfc0 (3:5fc0)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0792, Text0793
	quit_script_fully

Preload_Lass3: ; dfcb (3:5fcb)
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	cp TRUE
	ret

Script_Lass3: ; dfd2 (3:5fd2)
	start_script
	print_text_quit_fully Text0794

RockClubAfterDuel: ; dfd6 (3:5fd6)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_RYAN
	db NPC_RYAN
	dw Script_BeatRyan
	dw Script_LostToRyan

	db NPC_ANDREW
	db NPC_ANDREW
	dw Script_BeatAndrew
	dw Script_LostToAndrew

	db NPC_GENE
	db NPC_GENE
	dw Script_BeatGene
	dw Script_LostToGene
	db $00

Script_Ryan: ; dff0 (3:5ff0)
	start_script
	try_give_pc_pack $03
	print_npc_text Text0795
	ask_question_jump Text0796, .ows_dfff
	print_npc_text Text0797
	quit_script_fully

.ows_dfff
	print_npc_text Text0798
	start_duel PRIZES_3, EXCAVATION_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatRyan: ; e007 (3:6007)
	start_script
	print_npc_text Text0799
	give_booster_packs BOOSTER_EVOLUTION_FIGHTING, BOOSTER_EVOLUTION_FIGHTING, NO_BOOSTER
	print_npc_text Text079a
	quit_script_fully

Script_LostToRyan: ; e013 (3:6013)
	start_script
	print_text_quit_fully Text079b

Script_Andrew: ; e017 (3:6017)
	start_script
	try_give_pc_pack $03
	print_npc_text Text079c
	ask_question_jump Text079d, .ows_e026
	print_npc_text Text079e
	quit_script_fully

.ows_e026
	print_npc_text Text079f
	start_duel PRIZES_4, BLISTERING_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatAndrew: ; e02e (3:602e)
	start_script
	print_npc_text Text07a0
	give_booster_packs BOOSTER_COLOSSEUM_FIGHTING, BOOSTER_COLOSSEUM_FIGHTING, NO_BOOSTER
	print_npc_text Text07a1
	quit_script_fully

Script_LostToAndrew: ; e03a (3:603a)
	start_script
	print_text_quit_fully Text07a2

Script_Gene: ; e03e (3:603e)
	start_script
	try_give_pc_pack $03
	jump_if_event_true EVENT_BEAT_GENE, Script_LostToGene.ows_e07b
	print_npc_text Text07a3
	ask_question_jump Text07a4, .ows_e051
	print_npc_text Text07a5
	quit_script_fully

.ows_e051
	print_npc_text Text07a6
	start_duel PRIZES_6, ROCK_CRUSHER_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatGene: ; e059 (3:6059)
	start_script
	jump_if_event_true EVENT_BEAT_GENE, Script_LostToGene.ows_e08f
	print_npc_text Text07a7
	max_out_event_value EVENT_BEAT_GENE
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_GENE
	record_master_win $02
	print_npc_text Text07a8
	give_booster_packs BOOSTER_MYSTERY_FIGHTING_COLORLESS, BOOSTER_MYSTERY_FIGHTING_COLORLESS, NO_BOOSTER
	print_npc_text Text07a9
	quit_script_fully

Script_LostToGene: ; e073 (3:6073)
	start_script
	jump_if_event_true EVENT_BEAT_GENE, .ows_e09a
	print_text_quit_fully Text07aa

.ows_e07b
	print_npc_text Text07ab
	ask_question_jump Text07a4, .ows_e087
	print_npc_text Text07ac
	quit_script_fully

.ows_e087
	print_npc_text Text07ad
	start_duel PRIZES_6, ROCK_CRUSHER_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_e08f
	print_npc_text Text07ae
	give_booster_packs BOOSTER_MYSTERY_FIGHTING_COLORLESS, BOOSTER_MYSTERY_FIGHTING_COLORLESS, NO_BOOSTER
	print_npc_text Text07af
	quit_script_fully

.ows_e09a
	print_text_quit_fully Text07b0
	ret

Script_Clerk3: ; e09e (3:609e)
	start_script
	print_text_quit_fully Text041c

WaterClubLobbyAfterDuel: ; e0a2 (3:60a2)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_IMAKUNI
	db NPC_IMAKUNI
	dw Script_BeatImakuni
	dw Script_LostToImakuni
	db $00

Preload_ImakuniInWaterClubLobby: ; e0b0 (3:60b0)
	get_event_value EVENT_IMAKUNI_STATE
	cp IMAKUNI_TALKED
	jr c, .dont_load
	get_event_value EVENT_TEMP_DUELED_IMAKUNI
	jr nz, .dont_load
	get_event_value EVENT_IMAKUNI_ROOM
	cp IMAKUNI_WATER_CLUB
	jr z, .load_imakuni
.dont_load
	or a
	ret

.load_imakuni
	ld a, MUSIC_IMAKUNI
	ld [wDefaultSong], a
	scf
	ret

Script_Gal1: ; e0cf (3:60cf)
	start_script
	jump_if_event_equal EVENT_GAL1_TRADE_STATE, GAL1_TRADE_COMPLETED, .ows_e10e
	test_if_event_equal EVENT_GAL1_TRADE_STATE, GAL1_TRADE_NOT_OFFERED
	print_variable_npc_text Gal1WantToTrade1Text, Gal1WantToTrade2Text
	set_event EVENT_GAL1_TRADE_STATE, GAL1_TRADE_OFFERED
	ask_question_jump Gal1WouldYouLikeToTradeText, .ows_e0eb
	print_npc_text Gal1DeclinedTradeText
	quit_script_fully

.ows_e0eb
	jump_if_card_owned LAPRAS, .ows_e0f3
	print_npc_text Gal1DontOwnCardText
	quit_script_fully

.ows_e0f3
	jump_if_card_in_collection LAPRAS, .ows_e0fb
	print_npc_text Gal1CardInDeckText
	quit_script_fully

.ows_e0fb
	set_event EVENT_GAL1_TRADE_STATE, GAL1_TRADE_COMPLETED
	print_npc_text Gal1LetsTradeText
	print_text Gal1TradeCompleteText
	take_card LAPRAS
	give_card ARCANINE1
	show_card_received_screen ARCANINE1
	print_npc_text Gal1ThanksText
	quit_script_fully

.ows_e10e
	print_text_quit_fully Gal1AfterTradeText

Script_Lass1: ; e111 (3:6111)
	start_script
	jump_if_event_equal EVENT_LASS1_MENTIONED_IMAKUNI, TRUE, .ows_e121
	print_npc_text Text0427
	set_event EVENT_LASS1_MENTIONED_IMAKUNI, TRUE
	set_event EVENT_IMAKUNI_STATE, IMAKUNI_MENTIONED
	quit_script_fully

.ows_e121
	jump_if_event_not_equal EVENT_IMAKUNI_ROOM, IMAKUNI_WATER_CLUB, .ows_e12d
	jump_if_event_true EVENT_TEMP_DUELED_IMAKUNI, .ows_e12d
	print_text_quit_fully Text0428

.ows_e12d
	print_text_quit_fully Text0429

Preload_Man2: ; e130 (3:6130)
	get_event_value EVENT_JOSHUA_STATE
	cp JOSHUA_DEFEATED
	ret

Script_Man2: ; e137 (3:6137)
	start_script
	print_text_quit_fully Text042a

Script_Pappy2: ; e13b (3:613b)
	start_script
	print_text_quit_fully Text042b

WaterClubMovePlayer: ; e13f (3:613f)
	ld a, [wPlayerYCoord]
	cp $8
	ret nz
	get_event_value EVENT_JOSHUA_STATE
	cp JOSHUA_DEFEATED
	ret nc
	ld a, NPC_JOSHUA
	ld [wTempNPC], a
	ld bc, Script_NotReadyToSeeAmy
	jp SetNextNPCAndScript

WaterClubAfterDuel: ; e157 (3:6157)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_SARA
	db NPC_SARA
	dw Script_BeatSara
	dw Script_LostToSara

	db NPC_AMANDA
	db NPC_AMANDA
	dw Script_BeatAmanda
	dw Script_LostToAmanda

	db NPC_JOSHUA
	db NPC_JOSHUA
	dw Script_BeatJoshua
	dw Script_LostToJoshua

	db NPC_AMY
	db NPC_AMY
	dw Script_BeatAmy
	dw Script_LostToAmy
	db $00

Script_Sara: ; e177 (3:6177)
	start_script
	print_npc_text Text042c
	ask_question_jump Text042d, .start_duel
	print_npc_text Text042e
	quit_script_fully

.start_duel
	print_npc_text Text042f
	start_duel PRIZES_2, WATERFRONT_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatSara: ; e18c (3:618c)
	start_script
	max_out_event_value EVENT_BEAT_SARA
	print_npc_text Text0430
	give_booster_packs BOOSTER_COLOSSEUM_WATER, BOOSTER_COLOSSEUM_WATER, NO_BOOSTER
	print_npc_text Text0431
	quit_script_fully

Script_LostToSara: ; e19a (3:619a)
	start_script
	print_text_quit_fully Text0432

Script_Amanda: ; e19e (3:619e)
	start_script
	print_npc_text Text0433
	ask_question_jump Text0434, .start_duel
	print_npc_text Text0435
	quit_script_fully

.start_duel
	print_npc_text Text0436
	start_duel PRIZES_3, LONELY_FRIENDS_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatAmanda: ; e1b3 (3:61b3)
	start_script
	max_out_event_value EVENT_BEAT_AMANDA
	print_npc_text Text0437
	give_booster_packs BOOSTER_MYSTERY_LIGHTNING_COLORLESS, BOOSTER_MYSTERY_LIGHTNING_COLORLESS, NO_BOOSTER
	print_npc_text Text0438
	quit_script_fully

Script_LostToAmanda: ; e1c1 (3:61c1)
	start_script
	print_text_quit_fully Text0439

Script_NotReadyToSeeAmy: ; e1c5 (3:61c5)
	start_script
	jump_if_player_coords_match 18, 8, .ows_e1ec
	jump_if_player_coords_match 20, 8, .ows_e1f2
	jump_if_player_coords_match 24, 8, .ows_e1f8
.ows_e1d5
	move_player SOUTH, 4
	move_active_npc NPCMovement_e213
	print_npc_text Text043a
	jump_if_player_coords_match 18, 10, .ows_e1fe
	jump_if_player_coords_match 20, 10, .ows_e202
	move_active_npc NPCMovement_e215
	quit_script_fully

.ows_e1ec
	move_active_npc NPCMovement_e206
	script_jump .ows_e1d5

.ows_e1f2
	move_active_npc NPCMovement_e20b
	script_jump .ows_e1d5

.ows_e1f8
	move_active_npc NPCMovement_e20f
	script_jump .ows_e1d5

.ows_e1fe
	move_active_npc NPCMovement_e218
	quit_script_fully

.ows_e202
	move_active_npc NPCMovement_e219
	quit_script_fully

NPCMovement_e206: ; e206 (3:6206)
	db NORTH
	db WEST
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_e20b: ; e20b (3:620b)
	db NORTH
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_e20f: ; e20f (3:620f)
	db NORTH
	db EAST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_e213: ; e213 (3:6213)
	db SOUTH
	db $ff

NPCMovement_e215: ; e215 (3:6215)
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_e218: ; e218 (3:6218)
	db EAST
NPCMovement_e219: ; e219 (3:6219)
	db EAST
	db SOUTH | NO_MOVE
	db $ff

Script_Joshua: ; e21c (3:621c)
	start_script
	jump_if_event_false EVENT_BEAT_AMANDA, .sara_and_amanda_not_beaten
	jump_if_event_false EVENT_BEAT_SARA, .sara_and_amanda_not_beaten
	script_jump .beat_sara_and_amanda

.sara_and_amanda_not_beaten
	set_event EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_npc_text Text043b
	quit_script_fully

.beat_sara_and_amanda
	jump_if_event_nonzero EVENT_JOSHUA_STATE, .already_talked
	set_event EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_npc_text Text043b
	print_npc_text Text043c
.already_talked
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text Text043d, Text043e
	ask_question_jump Text043f, .start_duel
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text Text0440, Text0441
	quit_script_fully

.start_duel
	print_npc_text Text0442
	try_give_pc_pack $04
	start_duel PRIZES_4, SOUND_OF_THE_WAVES_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_LostToJoshua: ; e260 (3:6260)
	start_script
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text Text0443, Text0444
	quit_script_fully

Script_BeatJoshua: ; e26c (3:626c)
	start_script
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text Text0445, Text0446
	give_booster_packs BOOSTER_MYSTERY_WATER_COLORLESS, BOOSTER_MYSTERY_WATER_COLORLESS, NO_BOOSTER
	test_if_event_equal EVENT_JOSHUA_STATE, JOSHUA_TALKED
	print_variable_npc_text Text0447, Text0448
	jump_if_event_not_equal EVENT_JOSHUA_STATE, JOSHUA_DEFEATED, .first_joshua_win
	quit_script_fully

.first_joshua_win
	set_event EVENT_JOSHUA_STATE, JOSHUA_DEFEATED
	print_npc_text Text0449
	close_text_box
	move_active_npc_by_direction NPCMovementTable_e2a1
	print_npc_text Text044a
	set_active_npc_direction NORTH
	close_advanced_text_box
	set_next_npc_and_script NPC_AMY, Script_MeetAmy
	end_script
	ret

NPCMovementTable_e2a1: ; e2a1 (3:62a1)
	dw NPCMovement_e2a9
	dw NPCMovement_e2a9
	dw NPCMovement_e2a9
	dw NPCMovement_e2a9

NPCMovement_e2a9: ; e2a9 (3:62a9)
	db NORTH
	db $ff

NPCMovement_e2ab: ; e2ab (3:62ab)
	db SOUTH
	db $ff

Preload_Amy: ; e2ad (3:62ad)
	xor a
	ld [wd3d0], a
	ld a, [wd0c2]
	or a
	jr z, .asm_e2cf
	ld a, [wPlayerXCoord]
	cp $14
	jr nz, .asm_e2cf
	ld a, [wPlayerYCoord]
	cp $06
	jr nz, .asm_e2cf
	ld a, $14
	ld [wLoadNPCXPos], a
	ld a, $01
	ld [wd3d0], a
.asm_e2cf
	scf
	ret

Script_MeetAmy: ; e2d1 (3:62d1)
	start_script
	print_npc_text Text044b
	set_dialog_npc NPC_JOSHUA
	print_npc_text Text044c
	set_dialog_npc NPC_AMY
	print_npc_text Text044d
	close_text_box
	set_sprite_attributes $09, $2f, $10
	do_frames 32
	set_sprite_attributes $04, $0e, $00
	set_active_npc_coords 20, 4
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction NORTH
	move_player NORTH, 1
	move_player NORTH, 1
	move_npc NPC_JOSHUA, NPCMovement_e2ab
	print_npc_text Text044e
	script_jump Script_Amy.ask_for_duel

Script_Amy: ; e304 (3:6304)
	start_script
	jump_if_event_true EVENT_BEAT_AMY, Script_Amy_AlreadyHaveMedal
	print_npc_text Text044f
.ask_for_duel
	ask_question_jump Text0450, .start_duel
.deny_duel
	print_npc_text Text0451
	jump_if_active_npc_coords_match 20, 4, Script_LostToAmy.ows_e34e
	quit_script_fully

.start_duel
	print_npc_text Text0452
	start_duel PRIZES_6, GO_GO_RAIN_DANCE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatAmy: ; e322 (3:6322)
	start_script
	print_npc_text Text0453
	jump_if_event_true EVENT_BEAT_AMY, .give_booster_packs
	print_npc_text Text0454
	max_out_event_value EVENT_BEAT_AMY
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_AMY
	record_master_win $03
	print_npc_text Text0455
.give_booster_packs
	give_booster_packs BOOSTER_LABORATORY_WATER, BOOSTER_LABORATORY_WATER, NO_BOOSTER
	print_npc_text Text0456
	jump_if_active_npc_coords_match 20, 4, Script_LostToAmy.ows_e34e
	quit_script_fully

Script_LostToAmy: ; e344 (3:6344)
	start_script
	print_npc_text Text0457
	jump_if_active_npc_coords_match 20, 4, .ows_e34e
	quit_script_fully

.ows_e34e
	set_sprite_attributes $08, $2e, $10
	set_active_npc_coords 22, 4
	quit_script_fully

Script_Amy_AlreadyHaveMedal: ; e356 (3:6356)
	print_npc_text Text0458
	ask_question_jump Text0450, .start_duel
	script_jump Script_Amy.deny_duel

.start_duel
	print_npc_text Text0459
	start_duel PRIZES_6, GO_GO_RAIN_DANCE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_Clerk4: ; e369 (3:6369)
	start_script
	print_text_quit_fully Text060e

LightningClubLobbyAfterDuel: ; e36d (3:636d)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_IMAKUNI
	db NPC_IMAKUNI
	dw Script_BeatImakuni
	dw Script_LostToImakuni
	db $00

Preload_ImakuniInLightningClubLobby: ; e37b (3:637b)
	get_event_value EVENT_IMAKUNI_STATE
	cp IMAKUNI_TALKED
	jr c, .dont_load
	get_event_value EVENT_TEMP_DUELED_IMAKUNI
	jr nz, .dont_load
	get_event_value EVENT_IMAKUNI_ROOM
	cp IMAKUNI_LIGHTNING_CLUB
	jr z, .load_imakuni
.dont_load
	or a
	ret

.load_imakuni
	ld a, MUSIC_IMAKUNI
	ld [wDefaultSong], a
	scf
	ret

Script_Chap2: ; e39a (3:639a)
	start_script
	jump_if_event_equal EVENT_CHAP2_TRADE_STATE, CHAP2_TRADE_COMPLETED, .ows_e3d6
	test_if_event_equal EVENT_CHAP2_TRADE_STATE, CHAP2_TRADE_NOT_OFFERED
	print_variable_npc_text Text060f, Text0610
	set_event EVENT_CHAP2_TRADE_STATE, CHAP2_TRADE_OFFERED
	ask_question_jump Text0611, .ows_e3b6
	print_npc_text Text0612
	quit_script_fully

.ows_e3b6
	jump_if_card_owned ELECTABUZZ2, .ows_e3be
	print_npc_text Text0613
	quit_script_fully

.ows_e3be
	jump_if_card_in_collection ELECTABUZZ2, .ows_e3c6
	print_npc_text Text0614
	quit_script_fully

.ows_e3c6
	set_event EVENT_CHAP2_TRADE_STATE, CHAP2_TRADE_COMPLETED
	print_npc_text Text0615
	take_card ELECTABUZZ2
	give_card ELECTABUZZ1
	show_card_received_screen ELECTABUZZ1
	print_npc_text Text0616
	quit_script_fully

.ows_e3d6
	print_text_quit_fully Text0617

Script_Lass4: ; e3d9 (3:63d9)
	start_script
	print_text_quit_fully Text0618

Script_Hood1: ; e3dd (3:63dd)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0619, Text061a
	quit_script_fully

LightningClubAfterDuel: ; e3e8 (3:63e8)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_JENNIFER
	db NPC_JENNIFER
	dw Script_BeatJennifer
	dw Script_LostToJennifer

	db NPC_NICHOLAS
	db NPC_NICHOLAS
	dw Script_BeatNicholas
	dw Script_LostToNicholas

	db NPC_BRANDON
	db NPC_BRANDON
	dw Script_BeatBrandon
	dw Script_LostToBrandon

	db NPC_ISAAC
	db NPC_ISAAC
	dw Script_BeatIsaac
	dw Script_LostToIsaac
	db $00

Script_Jennifer: ; e408 (3:6408)
	start_script
	print_npc_text Text061b
	ask_question_jump Text061c, .ows_e415
	print_npc_text Text061d
	quit_script_fully

.ows_e415
	print_npc_text Text061e
	start_duel PRIZES_4, PIKACHU_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJennifer: ; e41d (3:641d)
	start_script
	max_out_event_value EVENT_BEAT_JENNIFER
	print_npc_text Text061f
	give_booster_packs BOOSTER_MYSTERY_LIGHTNING_COLORLESS, BOOSTER_MYSTERY_LIGHTNING_COLORLESS, NO_BOOSTER
	print_npc_text Text0620
	quit_script_fully

Script_LostToJennifer: ; e42b (3:642b)
	start_script
	print_text_quit_fully Text0621

Script_Nicholas: ; e42f (3:642f)
	start_script
	print_npc_text Text0622
	ask_question_jump Text0623, .ows_e43c
	print_npc_text Text0624
	quit_script_fully

.ows_e43c
	print_npc_text Text0625
	start_duel PRIZES_4, BOOM_BOOM_SELFDESTRUCT_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatNicholas: ; e444 (3:6444)
	start_script
	max_out_event_value EVENT_BEAT_NICHOLAS
	print_npc_text Text0626
	give_booster_packs BOOSTER_COLOSSEUM_LIGHTNING, BOOSTER_COLOSSEUM_LIGHTNING, NO_BOOSTER
	print_npc_text Text0627
	quit_script_fully

Script_LostToNicholas: ; e452 (3:6452)
	start_script
	print_text_quit_fully Text0628

Script_Brandon: ; e456 (3:6456)
	start_script
	jump_if_event_false EVENT_BEAT_JENNIFER, .ows_e469
	jump_if_event_false EVENT_BEAT_NICHOLAS, .ows_e469
	jump_if_event_false EVENT_BEAT_BRANDON, .ows_e469
	print_npc_text Text0629
	script_jump .ows_e46c

.ows_e469
	print_npc_text Text062a
.ows_e46c
	print_npc_text Text062b
	ask_question_jump Text062c, .ows_e478
	print_npc_text Text062d
	quit_script_fully

.ows_e478
	print_npc_text Text062e
	start_duel PRIZES_4, POWER_GENERATOR_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatBrandon: ; e480 (3:6480)
	start_script
	try_give_pc_pack $05
	max_out_event_value EVENT_BEAT_BRANDON
	print_npc_text Text062f
	give_booster_packs BOOSTER_COLOSSEUM_LIGHTNING, BOOSTER_COLOSSEUM_LIGHTNING, NO_BOOSTER
	print_npc_text Text0630
	quit_script_fully

Script_LostToBrandon: ; e490 (3:6490)
	start_script
	print_text_quit_fully Text0631

Preload_Isaac: ; e494 (3:6494)
	get_event_value EVENT_BEAT_JENNIFER
	jr z, .asm_e4ab
	get_event_value EVENT_BEAT_NICHOLAS
	jr z, .asm_e4ab
	get_event_value EVENT_BEAT_BRANDON
	jr z, .asm_e4ab
	ld a, SOUTH
	ld [wLoadNPCDirection], a
.asm_e4ab
	scf
	ret

Script_Isaac: ; e4ad (3:64ad)
	start_script
	jump_if_event_false EVENT_BEAT_JENNIFER, .ows_e4bd
	jump_if_event_false EVENT_BEAT_NICHOLAS, .ows_e4bd
	jump_if_event_false EVENT_BEAT_BRANDON, .ows_e4bd
	script_jump .ows_e4c1

.ows_e4bd
	print_npc_text Text0632
	quit_script_fully

.ows_e4c1
	jump_if_event_true EVENT_BEAT_ISAAC, Script_LostToIsaac.ows_e503
	test_if_event_false EVENT_ISAAC_TALKED
	print_variable_npc_text Text0633, Text0634
	max_out_event_value EVENT_ISAAC_TALKED
	ask_question_jump Text0635, .ows_e4d9
	print_npc_text Text0636
	quit_script_fully

.ows_e4d9
	print_npc_text Text0637
	start_duel PRIZES_6, ZAPPING_SELFDESTRUCT_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatIsaac: ; e4e1 (3:64e1)
	start_script
	jump_if_event_true EVENT_BEAT_ISAAC, Script_LostToIsaac.ows_e517
	print_npc_text Text0638
	max_out_event_value EVENT_BEAT_ISAAC
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_ISAAC
	record_master_win $04
	print_npc_text Text0639
	give_booster_packs BOOSTER_MYSTERY_LIGHTNING_COLORLESS, BOOSTER_MYSTERY_LIGHTNING_COLORLESS, NO_BOOSTER
	print_npc_text Text063a
	quit_script_fully

Script_LostToIsaac: ; e4fb (3:64fb)
	start_script
	jump_if_event_true EVENT_BEAT_ISAAC, .ows_e522
	print_text_quit_fully Text063b

.ows_e503
	print_npc_text Text063c
	ask_question_jump Text0635, .ows_e50f
	print_npc_text Text063d
	quit_script_fully

.ows_e50f
	print_npc_text Text063e
	start_duel PRIZES_6, ZAPPING_SELFDESTRUCT_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_e517
	print_npc_text Text063f
	give_booster_packs BOOSTER_MYSTERY_LIGHTNING_COLORLESS, BOOSTER_MYSTERY_LIGHTNING_COLORLESS, NO_BOOSTER
	print_npc_text Text0640
	quit_script_fully

.ows_e522
	print_text_quit_fully Text0641

GrassClubEntranceAfterDuel: ; e525 (3:6525)
	ld hl, GrassClubEntranceAfterDuelTable
	call FindEndOfDuelScript
	ret

FindEndOfDuelScript: ; e52c (3:652c)
	ld c, 0
	ld a, [wDuelResult]
	or a ; cp DUEL_WIN
	jr z, .player_won
	ld c, 2

.player_won
	ld a, [wNPCDuelist]
	ld b, a
	ld de, 5
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
	ld [wTempNPC], a
	ld b, 0
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	jp SetNextNPCAndScript

GrassClubEntranceAfterDuelTable: ; e553 (3:6553)
	db NPC_MICHAEL
	db NPC_MICHAEL
	dw Script_BeatMichaelInGrassClubEntrance
	dw Script_LostToMichaelInGrassClubEntrance

	db NPC_RONALD2
	db NPC_RONALD2
	dw Script_BeatFirstRonaldDuel
	dw Script_LostToFirstRonaldDuel

	db NPC_RONALD3
	db NPC_RONALD3
	dw Script_BeatSecondRonaldDuel
	dw Script_LostToSecondRonaldDuel
	db $00

Script_Clerk5: ; e566 (3:6566)
	start_script
	print_text_quit_fully Text06d7

Preload_MichaelInGrassClubEntrance: ; e56a (3:656a)
	get_event_value EVENT_PUPIL_MICHAEL_STATE
	or a ; cp PUPIL_INACTIVE
	ret z
	cp PUPIL_DEFEATED
	ret

Script_Michael: ; e573 (3:6573)
	start_script
	jump_if_event_greater_or_equal EVENT_PUPIL_MICHAEL_STATE, PUPIL_DEFEATED,  Script_MichaelRematch
	test_if_event_equal EVENT_PUPIL_MICHAEL_STATE, PUPIL_ACTIVE
	print_variable_npc_text Text06d8, Text06d9
	set_event EVENT_PUPIL_MICHAEL_STATE, PUPIL_TALKED
	ask_question_jump Text06da, .ows_e58f
	print_npc_text Text06db
	quit_script_fully

.ows_e58f
	print_npc_text Text06dc
	start_duel PRIZES_4, HEATED_BATTLE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatMichaelInGrassClubEntrance: ; e597 (3:6597)
	start_script
	set_event EVENT_PUPIL_MICHAEL_STATE, PUPIL_DEFEATED
	print_npc_text Text06dd
	give_booster_packs BOOSTER_COLOSSEUM_FIGHTING, BOOSTER_COLOSSEUM_FIGHTING, NO_BOOSTER
	print_npc_text Text06de
	close_text_box
	move_active_npc_by_direction NPCMovementTable_e5af
	unload_active_npc
	quit_script_fully

Script_LostToMichaelInGrassClubEntrance: ; e5ab (3:65ab)
	start_script
	print_text_quit_fully Text06df

NPCMovementTable_e5af: ; e5af (3:65af)
	dw NPCMovement_e5b7
	dw NPCMovement_e5b7
	dw NPCMovement_e5b7
	dw NPCMovement_e5bf

NPCMovement_e5b7: ; e5b7 (3:65b7)
	db WEST
	db WEST
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

NPCMovement_e5bf: ; e5bf (3:65bf)
	db SOUTH
	db WEST
	db WEST
	db $fe, -9

GrassClubLobbyAfterDuel: ; e5c4 (3:65c4)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_BRITTANY
	db NPC_BRITTANY
	dw Script_BeatBrittany
	dw Script_LostToBrittany
	db $00

Script_Brittany: ; e5d2 (3:65d2)
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	print_variable_npc_text Text06e0, Text06e1
	ask_question_jump Text06e2, .start_duel
	print_npc_text Text06e3
	quit_script_fully

.start_duel
	print_npc_text Text06e4
	start_duel PRIZES_4, ETCETERA_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatBrittany: ; e5ee (3:65ee)
	start_script
	print_npc_text Text06e5
	give_booster_packs BOOSTER_MYSTERY_GRASS_COLORLESS, BOOSTER_MYSTERY_GRASS_COLORLESS, NO_BOOSTER
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB
	print_variable_npc_text Text06e6, Text06e7
	max_out_event_value EVENT_BEAT_BRITTANY
	jump_if_event_greater_or_equal EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB, .quit
	jump_if_event_false EVENT_BEAT_KRISTIN, .quit
	jump_if_event_false EVENT_BEAT_HEATHER, .quit
	set_event EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	print_npc_text Text06e8
.quit
	quit_script_fully

Script_LostToBrittany: ; e618 (3:6618)
	start_script
	print_text_quit_fully Text06e9

Script_e61c: ; e61c (3:661c)
	print_text_quit_fully Text06ea

Script_Lass2: ; e61f (3:661f)
	start_script
	jump_if_event_true EVENT_TEMP_TRADED_WITH_LASS2, Script_e61c
	jump_if_event_greater_or_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADES_COMPLETE, Script_e61c
	jump_if_event_greater_or_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_3_AVAILABLE, .ows_e6a1
	jump_if_event_greater_or_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_2_AVAILABLE, .ows_e66a
	test_if_event_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_1_AVAILABLE
	print_variable_npc_text Text06eb, Text06ec
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_1_OFFERED
	ask_question_jump Text06ed, .ows_e648
	print_text_quit_fully Text06ee

.ows_e648
	jump_if_card_owned ODDISH, .ows_e64f
	print_text_quit_fully Text06ef

.ows_e64f
	jump_if_card_in_collection ODDISH, .ows_e656
	print_text_quit_fully Text06f0

.ows_e656
	max_out_event_value EVENT_TEMP_TRADED_WITH_LASS2
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_2_AVAILABLE
	print_npc_text Text06f1
	print_text Text06f2
	take_card ODDISH
	give_card VILEPLUME
	show_card_received_screen VILEPLUME
	print_text_quit_fully Text06f3

.ows_e66a
	test_if_event_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_2_AVAILABLE
	print_variable_npc_text Text06f4, Text06f5
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_2_OFFERED
	ask_question_jump Text06ed, .ows_e67f
	print_text_quit_fully Text06f6

.ows_e67f
	jump_if_card_owned CLEFAIRY, .ows_e686
	print_text_quit_fully Text06f7

.ows_e686
	jump_if_card_in_collection CLEFAIRY, .ows_e68d
	print_text_quit_fully Text06f8

.ows_e68d
	max_out_event_value EVENT_TEMP_TRADED_WITH_LASS2
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_3_AVAILABLE
	print_npc_text Text06f9
	print_text Text06fa
	take_card CLEFAIRY
	give_card PIKACHU3
	show_card_received_screen PIKACHU3
	print_text_quit_fully Text06f3

.ows_e6a1
	test_if_event_equal EVENT_LASS2_TRADE_STATE, LASS2_TRADE_3_AVAILABLE
	print_variable_npc_text Text06fb, Text06fc
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADE_3_OFFERED
	ask_question_jump Text06ed, .ows_e6b6
	print_text_quit_fully Text06fd

.ows_e6b6
	jump_if_card_owned CHARIZARD, .ows_e6bd
	print_text_quit_fully Text06fe

.ows_e6bd
	jump_if_card_in_collection CHARIZARD, .ows_e6c4
	print_text_quit_fully Text06ff

.ows_e6c4
	max_out_event_value EVENT_TEMP_TRADED_WITH_LASS2
	set_event EVENT_LASS2_TRADE_STATE, LASS2_TRADES_COMPLETE
	print_npc_text Text0700
	print_text Text0701
	take_card CHARIZARD
	give_card BLASTOISE
	show_card_received_screen BLASTOISE
	print_text_quit_fully Text06f3

Script_Granny2: ; e6d8 (3:66d8)
	start_script
	print_text_quit_fully Text0702

Preload_Gal2: ; e6dc (3:66dc)
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	cp TRUE
	ret

Script_Gal2: ; e6e3 (3:66e3)
	start_script
	print_text_quit_fully Text0703

GrassClubAfterDuel: ; e6e7 (3:66e7)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_KRISTIN
	db NPC_KRISTIN
	dw Script_BeatKristin
	dw Script_LostToKristin

	db NPC_HEATHER
	db NPC_HEATHER
	dw Script_BeatHeather
	dw Script_LostToHeather

	db NPC_NIKKI
	db NPC_NIKKI
	dw Script_BeatNikki
	dw Script_LostToNikki
	db $00

Script_Kristin: ; e701 (3:6701)
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	print_variable_npc_text Text0704, Text0705
	ask_question_jump Text0706, .ows_e714
	print_text_quit_fully Text0707

.ows_e714
	print_npc_text Text0708
	start_duel PRIZES_4, FLOWER_GARDEN_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatKristin: ; e71c (3:671c)
	start_script
	try_give_pc_pack $06
	print_npc_text Text0709
	give_booster_packs BOOSTER_EVOLUTION_GRASS, BOOSTER_EVOLUTION_GRASS, NO_BOOSTER
	print_npc_text Text070a
	max_out_event_value EVENT_BEAT_KRISTIN
	jump_if_event_greater_or_equal EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB, .ows_e740
	jump_if_event_false EVENT_BEAT_BRITTANY, .ows_e740
	jump_if_event_false EVENT_BEAT_HEATHER, .ows_e740
	set_event EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	print_npc_text Text070b
.ows_e740
	quit_script_fully

Script_LostToKristin: ; e741 (3:6741)
	start_script
	print_text_quit_fully Text070c

Script_Heather: ; e745 (3:6745)
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	print_variable_npc_text Text070d, Text070e
	ask_question_jump Text070f, .ows_e758
	print_text_quit_fully Text0710

.ows_e758
	print_npc_text Text0711
	start_duel PRIZES_4, KALEIDOSCOPE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatHeather: ; e760 (3:6760)
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB
	print_variable_npc_text Text0712, Text0713
	give_booster_packs BOOSTER_COLOSSEUM_GRASS, BOOSTER_COLOSSEUM_GRASS, NO_BOOSTER
	print_npc_text Text0714
	max_out_event_value EVENT_BEAT_HEATHER
	jump_if_event_greater_or_equal EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB, .ows_e789
	jump_if_event_false EVENT_BEAT_BRITTANY, .ows_e789
	jump_if_event_false EVENT_BEAT_KRISTIN, .ows_e789
	set_event EVENT_NIKKI_STATE, NIKKI_IN_ISHIHARAS_HOUSE
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	print_npc_text Text0715
.ows_e789
	quit_script_fully

Script_LostToHeather: ; e78a (3:678a)
	start_script
	test_if_event_less_than EVENT_NIKKI_STATE, NIKKI_IN_GRASS_CLUB
	print_variable_npc_text Text0716, Text0717
	quit_script_fully

Preload_NikkiInGrassClub: ; e796 (3:6796)
	get_event_value EVENT_NIKKI_STATE
	cp NIKKI_IN_GRASS_CLUB
	ccf
	ret

Script_Nikki: ; e79e (3:679e)
	ld a, [wCurMap]
	cp ISHIHARAS_HOUSE
	jp z, Script_NikkiInIshiharasHouse

	start_script
	test_if_event_false EVENT_BEAT_NIKKI
	print_variable_npc_text Text0718, Text0719
	ask_question_jump Text071a, .ows_e7bf
	test_if_event_false EVENT_BEAT_NIKKI
	print_variable_npc_text Text071b, Text071c
	quit_script_fully

.ows_e7bf
	jump_if_event_true EVENT_BEAT_NIKKI, .ows_e7cb
	print_npc_text Text071d
	start_duel PRIZES_6, FLOWER_POWER_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_e7cb
	print_npc_text Text071e
	start_duel PRIZES_6, FLOWER_POWER_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatNikki: ; e7d3 (3:67d3)
	start_script
	test_if_event_false EVENT_BEAT_NIKKI
	print_variable_npc_text Text071f, Text0720
	jump_if_event_true EVENT_BEAT_NIKKI, .ows_e7eb
	max_out_event_value EVENT_BEAT_NIKKI
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_NIKKI
	record_master_win $05
	print_npc_text Text0721
.ows_e7eb
	give_booster_packs BOOSTER_LABORATORY_NEUTRAL, BOOSTER_LABORATORY_NEUTRAL, NO_BOOSTER
	script_jump Script_LostToNikki.ows_e7f3

Script_LostToNikki: ; e7f2 (3:67f2)
	start_script
.ows_e7f3
	print_text_quit_fully Text0722

ClubEntranceAfterDuel: ; e7f6 (3:67f6)
	ld hl, .after_duel_table
	jp FindEndOfDuelScript

.after_duel_table
	db NPC_RONALD2
	db NPC_RONALD2
	dw Script_BeatFirstRonaldDuel
	dw Script_LostToFirstRonaldDuel

	db NPC_RONALD3
	db NPC_RONALD3
	dw Script_BeatSecondRonaldDuel
	dw Script_LostToSecondRonaldDuel
	db $00

; A Ronald is already loaded or not loaded depending on Pre-Load scripts
; in data/npc_map_data.asm. This just starts a script if possible.
LoadClubEntrance: ; e809 (3:6809)
	call TryFirstRonaldDuel
	call TrySecondRonaldDuel
	call TryFirstRonaldEncounter
	ret

TryFirstRonaldEncounter: ; e813 (3:6813)
	ld a, NPC_RONALD1
	ld [wTempNPC], a
	call FindLoadedNPC
	ret c
	ld bc, Script_FirstRonaldEncounter
	jp SetNextNPCAndScript

TryFirstRonaldDuel: ; e822 (3:6822)
	ld a, NPC_RONALD2
	ld [wTempNPC], a
	call FindLoadedNPC
	ret c
	get_event_value EVENT_RONALD_FIRST_DUEL_STATE
	or a
	ret nz ; already dueled
	ld bc, Script_FirstRonaldDuel
	jp SetNextNPCAndScript

TrySecondRonaldDuel: ; e837 (3:6837)
	ld a, NPC_RONALD3
	ld [wTempNPC], a
	call FindLoadedNPC
	ret c
	get_event_value EVENT_RONALD_SECOND_DUEL_STATE
	or a
	ret nz ; already dueled
	ld bc, Script_SecondRonaldDuel
	jp SetNextNPCAndScript

Script_Clerk6: ; e84c (3:684c)
	start_script
	print_text_quit_fully Text0642

Script_Lad3: ; e850 (3:6850)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0643, Text0644
	quit_script_fully

Preload_Ronald1InClubEntrance: ; e85b (3:685b)
	get_event_value EVENT_RONALD_FIRST_CLUB_ENTRANCE_ENCOUNTER
	cp TRUE
	ret

Script_FirstRonaldEncounter: ; e862 (3:6862)
	start_script
	max_out_event_value EVENT_RONALD_FIRST_CLUB_ENTRANCE_ENCOUNTER
	move_active_npc NPCMovement_e894
	load_current_map_name_into_txram_slot 0
	print_npc_text Text0645
	close_text_box
	move_player NORTH, 1
	move_player NORTH, 1
	print_npc_text Text0646
	ask_question_jump_default_yes NULL, .ows_e882
	print_npc_text Text0647
	script_jump .ows_e885

.ows_e882
	print_npc_text Text0648
.ows_e885
	print_npc_text Text0649
	close_text_box
	set_player_direction WEST
	move_player EAST, 4
	move_active_npc NPCMovement_e894
	unload_active_npc
	play_default_song
	quit_script_fully

NPCMovement_e894: ; e894 (3:6894)
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

Preload_Ronald2InClubEntrance: ; e89a (3:689a)
	get_event_value EVENT_RONALD_FIRST_DUEL_STATE
	ld e, 2 ; medal requirement for ronald duel
Func_e8a0: ; e8a0 (3:68a0)
	cp RONALD_DUEL_WON
	jr z, .asm_e8b4
	cp RONALD_DUEL_LOST
	jr nc, .asm_e8b2
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	cp e
	jr z, .asm_e8be
.asm_e8b2
	or a
	ret

.asm_e8b4
	ld a, $08
	ld [wLoadNPCXPos], a
	ld a, $08
	ld [wLoadNPCYPos], a
.asm_e8be
	scf
	ret

Script_FirstRonaldDuel: ; e8c0 (3:68c0)
	start_script
	move_active_npc NPCMovement_e905
	do_frames 60
	move_active_npc NPCMovement_e90d
	print_npc_text Text064a
	jump_if_player_coords_match 8, 2, .ows_e8d6
	set_player_direction WEST
	move_player WEST, 1
.ows_e8d6
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	print_npc_text Text064b
	set_event EVENT_RONALD_FIRST_DUEL_STATE, RONALD_DUEL_WON
	start_duel PRIZES_6, IM_RONALD_DECK_ID, MUSIC_RONALD
	quit_script_fully

Script_BeatFirstRonaldDuel: ; e8e9 (3:68e9)
	start_script
	print_npc_text Text064c
	give_card JIGGLYPUFF1
	show_card_received_screen JIGGLYPUFF1
	print_npc_text Text064d
	script_jump Script_LostToFirstRonaldDuel.ows_e8fb

Script_LostToFirstRonaldDuel: ; e8f7 (3:68f7)
	start_script
	print_npc_text Text064e
.ows_e8fb
	set_event EVENT_RONALD_FIRST_DUEL_STATE, RONALD_DUEL_LOST
	close_text_box
	move_active_npc NPCMovement_e90f
	unload_active_npc
	play_default_song
	quit_script_fully

NPCMovement_e905: ; e905 (3:6905)
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db SOUTH
	db NORTH | NO_MOVE
	db $ff

NPCMovement_e90d: ; e90d (3:690d)
	db NORTH
	db $ff

NPCMovement_e90f: ; e90f (3:690f)
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

Preload_Ronald3InClubEntrance: ; e915 (3:6915)
	get_event_value EVENT_RONALD_SECOND_DUEL_STATE
	ld e, 5 ; medal requirement for ronald duel
	jp Func_e8a0

Script_SecondRonaldDuel: ; e91e (3:691e)
	start_script
	move_active_npc NPCMovement_e905
	do_frames 60
	move_active_npc NPCMovement_e90d
	print_npc_text Text064f
	jump_if_player_coords_match 8, 2, .ows_6934
	set_player_direction WEST
	move_player WEST, 1
.ows_6934
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	print_npc_text Text0650
	set_event EVENT_RONALD_SECOND_DUEL_STATE, RONALD_DUEL_WON
	start_duel PRIZES_6, POWERFUL_RONALD_DECK_ID, MUSIC_RONALD
	quit_script_fully

Script_BeatSecondRonaldDuel: ; e947 (3:6947)
	start_script
	print_npc_text Text0651
	give_card SUPER_ENERGY_RETRIEVAL
	show_card_received_screen SUPER_ENERGY_RETRIEVAL
	print_npc_text Text0652
	script_jump Script_LostToSecondRonaldDuel.ows_e959

Script_LostToSecondRonaldDuel: ; e955 (3:6955)
	start_script
	print_npc_text Text0653
.ows_e959
	set_event EVENT_RONALD_SECOND_DUEL_STATE, RONALD_DUEL_LOST
	close_text_box
	move_active_npc NPCMovement_e90f
	unload_active_npc
	play_default_song
	quit_script_fully

PsychicClubLobbyAfterDuel: ; e963 (3:6963)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_ROBERT
	db NPC_ROBERT
	dw Script_BeatRobert
	dw Script_LostToRobert
	db $00

PsychicClubLobbyLoadMap: ; e971 (3:6971)
	ld a, NPC_RONALD1
	ld [wTempNPC], a
	call FindLoadedNPC
	ret c
	ld bc, Script_ea02
	jp SetNextNPCAndScript

Script_Robert: ; e980 (3:6980)
	start_script
	print_npc_text Text0654
	ask_question_jump Text0655, .ows_e98d
	print_npc_text Text0656
	quit_script_fully

.ows_e98d
	print_npc_text Text0657
	start_duel PRIZES_4, GHOST_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatRobert: ; e995 (3:6995)
	start_script
	print_npc_text Text0658
	give_booster_packs BOOSTER_EVOLUTION_PSYCHIC, BOOSTER_EVOLUTION_PSYCHIC, NO_BOOSTER
	print_npc_text Text0659
	quit_script_fully

Script_LostToRobert: ; e9a1 (3:69a1)
	start_script
	print_text_quit_fully Text065a

Script_Pappy1: ; e9a5 (3:69a5)
	start_script
	jump_if_event_equal EVENT_PAPPY1_STATE, PAPPY1_CHALLENGE_COMPLETE, .ows_e9de
	jump_if_event_true EVENT_BEAT_MURRAY, .ows_e9cb
	jump_if_event_equal EVENT_PAPPY1_STATE, PAPPY1_CHALLENGE_ACCEPTED, .ows_e9c8
	set_event EVENT_PAPPY1_STATE, PAPPY1_TALKED
	print_npc_text Text065b
	ask_question_jump_default_yes Text065c, .ows_e9c2
	print_text_quit_fully Text065d

.ows_e9c2
	set_event EVENT_PAPPY1_STATE, PAPPY1_CHALLENGE_ACCEPTED
	print_text_quit_fully Text065e

.ows_e9c8
	print_text_quit_fully Text065f

.ows_e9cb
	test_if_event_zero EVENT_PAPPY1_STATE
	print_variable_npc_text Text0660, Text0661
	give_card MEWTWO3
	show_card_received_screen MEWTWO3
	set_event EVENT_PAPPY1_STATE, PAPPY1_CHALLENGE_COMPLETE
	print_text_quit_fully Text0662

.ows_e9de
	print_text_quit_fully Text0663

_Preload_Ronald1InPsychicClubLobby: ; e9e1 (3:69e1)
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	cp 4
	jr nz, .dont_load
	get_event_value EVENT_RONALD_PSYCHIC_CLUB_LOBBY_ENCOUNTER
	or a
	jr nz, .dont_load
	scf
	ret
.dont_load
	or a
	ret

Preload_Ronald1InPsychicClubLobby: ; e9f7 (3:69f7)
	call _Preload_Ronald1InPsychicClubLobby
	ret nc
	ld a, [wPlayerYCoord]
	ld [wLoadNPCYPos], a
	ret

Script_ea02: ; ea02 (3:6a02)
	start_script
	move_active_npc_by_direction NPCMovementTable_ea1a
	max_out_event_value EVENT_RONALD_PSYCHIC_CLUB_LOBBY_ENCOUNTER
	print_npc_text Text0664
	close_text_box
	set_player_direction SOUTH
	move_player NORTH, 4
	move_player NORTH, 1
	move_active_npc_by_direction NPCMovementTable_ea22
	unload_active_npc
	play_default_song
	quit_script_fully

NPCMovementTable_ea1a: ; ea1a (3:6a1a)
	dw NPCMovement_ea2a
	dw NPCMovement_ea2a
	dw NPCMovement_ea2a
	dw NPCMovement_ea2a

NPCMovementTable_ea22: ; ea22 (3:6a22)
	dw NPCMovement_ea2c
	dw NPCMovement_ea2c
	dw NPCMovement_ea2c
	dw NPCMovement_ea2c

NPCMovement_ea2a: ; ea2a (3:6a2a)
	db EAST
	db EAST
NPCMovement_ea2c: ; ea2c (3:6a2c)
	db EAST
	db EAST
	db EAST
	db $ff

Script_Gal3: ; ea30 (3:6a30)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0665, Text0666
	quit_script_fully

Script_Chap4: ; ea3b (3:6a3b)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0667, Text0668
	quit_script_fully

PsychicClubAfterDuel: ; ea46 (3:6a46)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_DANIEL
	db NPC_DANIEL
	dw Script_BeatDaniel
	dw Script_LostToDaniel

	db NPC_STEPHANIE
	db NPC_STEPHANIE
	dw Script_BeatStephanie
	dw Script_LostToStephanie

	db NPC_MURRAY1
	db NPC_MURRAY1
	dw Script_BeatMurray
	dw Script_LostToMurray
	db $00

Script_Daniel: ; ea60 (3:6a60)
	start_script
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 4, .ows_ea7e
	jump_if_event_true EVENT_DANIEL_TALKED, .ows_ea70
	max_out_event_value EVENT_DANIEL_TALKED
	print_npc_text Text0669
.ows_ea70
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 1, .ows_ea78
	print_text_quit_fully Text066a

.ows_ea78
	print_npc_text Text066b
	script_jump .ows_ea81

.ows_ea7e
	print_npc_text Text066c
.ows_ea81
	ask_question_jump Text066d, .ows_ea8a
	print_npc_text Text066e
	quit_script_fully

.ows_ea8a
	print_npc_text Text066f
	start_duel PRIZES_4, NAP_TIME_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatDaniel: ; ea92 (3:6a92)
	start_script
	print_npc_text Text0670
	give_booster_packs BOOSTER_EVOLUTION_PSYCHIC, BOOSTER_EVOLUTION_PSYCHIC, NO_BOOSTER
	print_npc_text Text0671
	quit_script_fully

Script_LostToDaniel: ; ea9e (3:6a9e)
	start_script
	print_text_quit_fully Text0672

Script_Stephanie: ; eaa2 (3:6aa2)
	start_script
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 2, .ows_eaac
	print_text_quit_fully Text0673

.ows_eaac
	print_npc_text Text0674
	ask_question_jump Text0675, .ows_eab8
	print_npc_text Text0676
	quit_script_fully

.ows_eab8
	print_npc_text Text0677
	start_duel PRIZES_4, STRANGE_POWER_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatStephanie: ; eac0 (3:6ac0)
	start_script
	print_npc_text Text0678
	give_booster_packs BOOSTER_LABORATORY_PSYCHIC, BOOSTER_LABORATORY_PSYCHIC, NO_BOOSTER
	print_npc_text Text0679
	quit_script_fully

Script_LostToStephanie: ; eacc (3:6acc)
	start_script
	print_text_quit_fully Text067a

Preload_Murray2: ; ead0 (3:6ad0)
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	cp 4
	ret

Preload_Murray1: ; eada (3:6ada)
	call Preload_Murray2
	ccf
	ret

Script_Murray: ; eadf (3:6adf)
	start_script
	try_give_pc_pack $07
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 4, .ows_eaef
	print_npc_text Text067b
	print_text Text067c
	quit_script_fully

.ows_eaef
	jump_if_event_true EVENT_BEAT_MURRAY, Script_LostToMurray.ows_eb31
	test_if_event_false EVENT_MURRAY_TALKED
	print_variable_npc_text Text067d, Text067e
	max_out_event_value EVENT_MURRAY_TALKED
	ask_question_jump Text067f, .ows_eb07
	print_npc_text Text0680
	quit_script_fully

.ows_eb07
	print_npc_text Text0681
	start_duel PRIZES_6, STRANGE_PSYSHOCK_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatMurray: ; eb0f (3:6b0f)
	start_script
	jump_if_event_true EVENT_BEAT_MURRAY, Script_LostToMurray.ows_eb45
	print_npc_text Text0682
	max_out_event_value EVENT_BEAT_MURRAY
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_MURRAY
	record_master_win $06
	print_npc_text Text0683
	give_booster_packs BOOSTER_LABORATORY_PSYCHIC, BOOSTER_LABORATORY_PSYCHIC, NO_BOOSTER
	print_npc_text Text0684
	quit_script_fully

Script_LostToMurray: ; eb29 (3:6b29)
	start_script
	jump_if_event_true EVENT_BEAT_MURRAY, .ows_eb50
	print_text_quit_fully Text0685

.ows_eb31
	print_npc_text Text0686
	ask_question_jump Text067f, .ows_eb3d
	print_npc_text Text0687
	quit_script_fully

.ows_eb3d
	print_npc_text Text0688
	start_duel PRIZES_6, STRANGE_PSYSHOCK_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_eb45
	print_npc_text Text0689
	give_booster_packs BOOSTER_LABORATORY_PSYCHIC, BOOSTER_LABORATORY_PSYCHIC, NO_BOOSTER
	print_npc_text Text068a
	quit_script_fully

.ows_eb50
	print_text_quit_fully Text068b

Script_Clerk7: ; eb53 (3:6b53)
	start_script
	print_text_quit_fully Text0744

ScienceClubLobbyAfterDuel:; eb57 (3:6b57)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_IMAKUNI
	db NPC_IMAKUNI
	dw Script_BeatImakuni
	dw Script_LostToImakuni
	db $00

Preload_ImakuniInScienceClubLobby: ; eb65 (3:6b65)
	get_event_value EVENT_IMAKUNI_STATE
	cp IMAKUNI_TALKED
	jr c, .dont_load
	get_event_value EVENT_TEMP_DUELED_IMAKUNI
	jr nz, .dont_load
	get_event_value EVENT_IMAKUNI_ROOM
	cp IMAKUNI_SCIENCE_CLUB
	jr z, .load_imakuni
.dont_load
	or a
	ret

.load_imakuni
	ld a, MUSIC_IMAKUNI
	ld [wDefaultSong], a
	scf
	ret

Script_Lad1: ; eb84 (3:6b84)
	start_script
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADES_COMPLETE, .ows_ebbb
	jump_if_event_true EVENT_ISHIHARA_MET, .ows_eb97
	max_out_event_value EVENT_ISHIHARA_MENTIONED
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0745

.ows_eb97
	jump_if_event_true EVENT_TEMP_TRADED_WITH_ISHIHARA, .ows_ebb8
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED, .ows_ebaf
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED, .ows_ebaa
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0746

.ows_ebaa
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0747

.ows_ebaf
	jump_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS, .ows_ebb8
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0748

.ows_ebb8
	print_text_quit_fully Text0749

.ows_ebbb
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_LEFT
	print_text_quit_fully Text074a

Script_Man3: ; ebc1 (3:6bc1)
	start_script
	print_text_quit_fully Text074b

Script_Specs2: ; ebc5 (3:6bc5)
	call UpdateRNGSources
	and %11
	ld c, a
	ld b, 0
	ld hl, Data_ebe7
	add hl, bc
	ld e, [hl]
	ld d, 0
	call GetCardName
	ld hl, wTxRam2
	ld a, e
	ld [hli], a
	ld [hl], d

	start_script
	print_npc_text Text074c
	move_active_npc NPCMovement_ebeb
	print_text_quit_fully Text074d

Data_ebe7: ; ebe7 (3:6be7)
	db PORYGON
	db DITTO
	db MUK
	db WEEZING

NPCMovement_ebeb: ; ebeb (3:6beb)
	db WEST | NO_MOVE
	db $ff

Script_Specs3: ; ebed (3:6bed)
	start_script
	print_text_quit_fully Text074e

ScienceClubAfterDuel: ; ebf1 (3:6bf1)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_JOSEPH
	db NPC_JOSEPH
	dw Script_BeatJoseph
	dw Script_LostToJoseph

	db NPC_DAVID
	db NPC_DAVID
	dw Script_BeatDavid
	dw Script_LostToDavid

	db NPC_ERIK
	db NPC_ERIK
	dw Script_BeatErik
	dw Script_LostToErik

	db NPC_RICK
	db NPC_RICK
	dw Script_BeatRick
	dw Script_LostToRick
	db $00

Script_David: ; ec11 (3:6c11)
	start_script
	test_if_event_zero EVENT_DAVID_STATE
	print_variable_npc_text Text074f, Text0750
	set_event EVENT_DAVID_STATE, DAVID_TALKED
	ask_question_jump Text0751, .ows_ec27
	print_npc_text Text0752
	quit_script_fully

.ows_ec27
	print_npc_text Text0753
	start_duel PRIZES_4, LOVELY_NIDORAN_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatDavid: ; ec2f (3:6c2f)
	start_script
	set_event EVENT_DAVID_STATE, DAVID_DEFEATED
	print_npc_text Text0754
	give_booster_packs BOOSTER_MYSTERY_GRASS_COLORLESS, BOOSTER_MYSTERY_GRASS_COLORLESS, NO_BOOSTER
	print_npc_text Text0755
	quit_script_fully

Script_LostToDavid: ; ec3e (3:6c3e)
	start_script
	print_text_quit_fully Text0756

Script_Erik: ; ec42 (3:6c42)
	start_script
	print_npc_text Text0757
	ask_question_jump Text0758, .ows_ec4f
	print_npc_text Text0759
	quit_script_fully

.ows_ec4f
	print_npc_text Text075a
	start_duel PRIZES_4, POISON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatErik: ; ec57 (3:6c57)
	start_script
	print_npc_text Text075b
	give_booster_packs BOOSTER_EVOLUTION_GRASS, BOOSTER_EVOLUTION_GRASS, NO_BOOSTER
	print_npc_text Text075c
	quit_script_fully

Script_LostToErik: ; ec63 (3:6c63)
	start_script
	print_text_quit_fully Text075d

Script_Rick: ; ec67 (3:6c67)
	start_script
	jump_if_event_true EVENT_BEAT_RICK, Script_LostToRick.ows_eca2
	print_npc_text Text075e
	ask_question_jump Text075f, .ows_ec78
	print_npc_text Text0760
	quit_script_fully

.ows_ec78
	print_npc_text Text0761
	start_duel PRIZES_6, WONDERS_OF_SCIENCE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatRick: ; ec80 (3:6c80)
	start_script
	jump_if_event_true EVENT_BEAT_RICK, Script_LostToRick.ows_ecb6
	print_npc_text Text0762
	max_out_event_value EVENT_BEAT_RICK
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_RICK
	record_master_win $07
	print_npc_text Text0763
	give_booster_packs BOOSTER_LABORATORY_GRASS, BOOSTER_LABORATORY_GRASS, NO_BOOSTER
	print_npc_text Text0764
	quit_script_fully

Script_LostToRick: ; ec9a (3:6c9a)
	start_script
	jump_if_event_true EVENT_BEAT_RICK, .ows_ecc1
	print_text_quit_fully Text0765

.ows_eca2
	print_npc_text Text0766
	ask_question_jump Text075f, .ows_ecae
	print_npc_text Text0767
	quit_script_fully

.ows_ecae
	print_npc_text Text0768
	start_duel PRIZES_6, WONDERS_OF_SCIENCE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_ecb6
	print_npc_text Text0769
	give_booster_packs BOOSTER_LABORATORY_GRASS, BOOSTER_LABORATORY_GRASS, NO_BOOSTER
	print_npc_text Text076a
	quit_script_fully

.ows_ecc1
	print_text_quit_fully Text076b

Preload_Joseph: ; ecc4 (3:6cc4)
	ld a, EVENT_BEAT_JOSEPH
	call GetEventValue
	or a
	jr z, .not_defeated
	; move joseph to unblock the science master's room
	ld a, [wLoadNPCXPos]
	add 2
	ld [wLoadNPCXPos], a
	ld a, WEST
	ld [wLoadNPCDirection], a
.not_defeated
	scf
	ret

Script_Joseph: ; ecdb (3:6cdb)
	start_script
	try_give_pc_pack $08
	jump_if_event_true EVENT_BEAT_JOSEPH, Script_LostToJoseph.ows_ed24
	print_npc_text Text076c
	ask_question_jump Text076d, .ows_ecee
	print_npc_text Text076e
	quit_script_fully

.ows_ecee
	print_npc_text Text076f
	start_duel PRIZES_4, FLYIN_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJoseph: ; ecf6 (3:6cf6)
	start_script
	jump_if_event_true EVENT_BEAT_JOSEPH, Script_LostToJoseph.ows_ed37
	print_npc_text Text0770
	close_text_box
	move_active_npc_by_direction NPCMovementTable_ed11
	set_active_npc_direction WEST
	max_out_event_value EVENT_BEAT_JOSEPH
	print_npc_text Text0771
	give_booster_packs BOOSTER_LABORATORY_GRASS, BOOSTER_LABORATORY_GRASS, NO_BOOSTER
	print_npc_text Text0772
	quit_script_fully

NPCMovementTable_ed11: ; ed11 (3:6d11)
	dw NPCMovement_ed19
	dw NPCMovement_ed19
	dw NPCMovement_ed19
	dw NPCMovement_ed19

NPCMovement_ed19: ; ed19 (3:6d19)
	db EAST
	db WEST | NO_MOVE
	db $ff

Script_LostToJoseph: ; ed1c (3:6d1c)
	start_script
	jump_if_event_true EVENT_BEAT_JOSEPH, .ows_ed42
	print_text_quit_fully Text0773

.ows_ed24
	print_npc_text Text0774
	ask_question_jump Text076d, .ows_ed2f
	print_text_quit_fully Text076e

.ows_ed2f
	print_npc_text Text0775
	start_duel PRIZES_4, FLYIN_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

.ows_ed37
	print_npc_text Text0776
	give_booster_packs BOOSTER_LABORATORY_GRASS, BOOSTER_LABORATORY_GRASS, NO_BOOSTER
	print_npc_text Text0777
	quit_script_fully

.ows_ed42
	print_text_quit_fully Text0778

Script_Clerk8: ; ed45 (3:6d45)
	start_script
	print_text_quit_fully Text068c

FireClubLobbyAfterDuel: ; ed49 (3:6d49)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_JESSICA
	db NPC_JESSICA
	dw Script_BeatJessicaInFireClubLobby
	dw Script_LostToJessicaInFireClubLobby
	db $00

FireClubPressedA: ; ed57 (3:6d57)
	ld hl, SlowpokePaintingObjectTable
	call FindExtraInteractableObjects
	ret

SlowpokePaintingObjectTable: ; ed5e (3:6d5e)
	db 16, 2, NORTH
	dw Script_ee76
	db $00

; Given a table with data of the form:
;	X, Y, Dir, Script
; Searches to try to find a match, and starts a Script if possible
FindExtraInteractableObjects: ; ed64 (3:6d64)
	ld de, 5
.loop
	ld a, [hl]
	or a
	ret z
	push hl
	ld a, [wPlayerXCoord]
	cp [hl]
	jr nz, .not_match
	inc hl
	ld a, [wPlayerYCoord]
	cp [hl]
	jr nz, .not_match
	inc hl
	ld a, [wPlayerDirection]
	cp [hl]
	jr z, .match
.not_match
	pop hl
	add hl, de
	jr .loop
.match
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	call SetNextScript
	scf
	ret

Preload_JessicaInFireClubLobby: ; ed8d (3:6d8d)
	get_event_value EVENT_PUPIL_JESSICA_STATE
	or a ; cp PUPIL_INACTIVE
	ret z
	cp PUPIL_DEFEATED
	ret

Script_Jessica: ; ed96 (3:6d96)
	start_script
	jump_if_event_greater_or_equal EVENT_PUPIL_JESSICA_STATE, PUPIL_DEFEATED, Script_dead
	test_if_event_equal EVENT_PUPIL_JESSICA_STATE, PUPIL_ACTIVE
	print_variable_npc_text Text068d, Text068e
	set_event EVENT_PUPIL_JESSICA_STATE, PUPIL_TALKED
	ask_question_jump Text068f, .ows_edb2
	print_npc_text Text0690
	quit_script_fully

.ows_edb2
	print_npc_text Text0691
	start_duel PRIZES_4, LOVE_TO_BATTLE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJessicaInFireClubLobby: ; edba (3:6dba)
	start_script
	set_event EVENT_PUPIL_JESSICA_STATE, PUPIL_DEFEATED
	print_npc_text Text0692
	give_booster_packs BOOSTER_COLOSSEUM_FIGHTING, BOOSTER_COLOSSEUM_FIGHTING, NO_BOOSTER
	print_npc_text Text0693
	close_text_box
	move_active_npc_by_direction NPCMovementTable_edd2
	unload_active_npc
	quit_script_fully

Script_LostToJessicaInFireClubLobby: ; edce (3:6dce)
	start_script
	print_text_quit_fully Text0694

NPCMovementTable_edd2: ; edd2 (3:6dd2)
	dw NPCMovement_edda
	dw NPCMovement_ede4
	dw NPCMovement_edda
	dw NPCMovement_edda

NPCMovement_edda: ; edda (3:6dda)
	db EAST
	db NORTH
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff

NPCMovement_ede4: ; ede4 (3:6de4)
	db NORTH
	db EAST
	db $fe, -11

Script_Chap3: ; ede8 (3:6de8)
	start_script
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADES_COMPLETE, .ows_ee1f
	jump_if_event_true EVENT_ISHIHARA_MET, .ows_edfb
	max_out_event_value EVENT_ISHIHARA_MENTIONED
	max_out_event_value EVENT_ISHIHARAS_HOUSE_MENTIONED
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0695

.ows_edfb
	jump_if_event_true EVENT_TEMP_TRADED_WITH_ISHIHARA, .ows_ee1c
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_3_RUMORED, .ows_ee13
	jump_if_event_greater_or_equal EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_TRADE_2_RUMORED, .ows_ee0e
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0696

.ows_ee0e
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0697

.ows_ee13
	jump_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS, .ows_ee1c
	max_out_event_value EVENT_ISHIHARA_WANTS_TO_TRADE
	print_text_quit_fully Text0698

.ows_ee1c
	print_text_quit_fully Text0699

.ows_ee1f
	set_event EVENT_ISHIHARA_TRADE_STATE, ISHIHARA_LEFT
	print_text_quit_fully Text069a

Preload_Lad2: ; ee25 (3:6e25)
	get_event_value EVENT_LAD2_STATE
	cp LAD2_SLOWPOKE_AVAILABLE
	ret

Script_Lad2: ; ee2c (3:6e2c)
	start_script
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 3, .ows_ee36
	print_text_quit_fully Text069b

.ows_ee36
	print_npc_text Text069c
	ask_question_jump Text069d, .ows_ee4a
	print_npc_text Text069e
	set_event EVENT_LAD2_STATE, LAD2_SLOWPOKE_GONE
	close_text_box
	move_active_npc_by_direction NPCMovementTable_ee61
	unload_active_npc
	quit_script_fully

.ows_ee4a
	jump_if_any_energy_cards_in_collection .ows_ee51
	print_npc_text Text069f
	quit_script_fully

.ows_ee51
	remove_all_energy_cards_from_collection
	print_text Text06a0
	print_npc_text Text06a1
	set_event EVENT_LAD2_STATE, LAD2_SLOWPOKE_AVAILABLE
	close_text_box
	move_active_npc_by_direction NPCMovementTable_ee61
	unload_active_npc
	quit_script_fully

NPCMovementTable_ee61: ; ee61 (3:6e61)
	dw NPCMovement_ee69
	dw NPCMovement_ee72
	dw NPCMovement_ee69
	dw NPCMovement_ee69

NPCMovement_ee69: ; ee69 (3:6e69)
	db EAST
	db SOUTH
	db SOUTH
	db SOUTH
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff

NPCMovement_ee72: ; ee72 (3:6e72)
	db SOUTH
	db EAST
	db $fe, -10

Script_ee76: ; ee76 (3:6e76)
	start_script
	jump_if_event_equal EVENT_LAD2_STATE, LAD2_SLOWPOKE_AVAILABLE, .ows_ee7d
	quit_script_fully

.ows_ee7d
	set_event EVENT_LAD2_STATE, LAD2_SLOWPOKE_GONE
	print_text FoundLv9SlowpokeText
	give_card SLOWPOKE1
	show_card_received_screen SLOWPOKE1
	quit_script_fully

Script_Mania: ; ee88 (3:6e88)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text06a3, Text06a4
	quit_script_fully

FireClubAfterDuel: ; ee93  (3:6e93)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_JOHN
	db NPC_JOHN
	dw Script_BeatJohn
	dw Script_LostToJohn

	db NPC_ADAM
	db NPC_ADAM
	dw Script_BeatAdam
	dw Script_LostToAdam

	db NPC_JONATHAN
	db NPC_JONATHAN
	dw Script_BeatJonathan
	dw Script_LostToJonathan

	db NPC_KEN
	db NPC_KEN
	dw Script_BeatKen
	dw Script_LostToKen
	db $00

Script_John: ; eeb3 (3:6eb3)
	start_script
	print_npc_text Text06a5
	ask_question_jump Text06a6, .ows_eec0
	print_npc_text Text06a7
	quit_script_fully

.ows_eec0
	print_npc_text Text06a8
	start_duel PRIZES_4, ANGER_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJohn: ; eec8 (3:6ec8)
	start_script
	print_npc_text Text06a9
	give_booster_packs BOOSTER_EVOLUTION_FIRE, BOOSTER_EVOLUTION_FIRE, NO_BOOSTER
	print_npc_text Text06aa
	quit_script_fully

Script_LostToJohn: ; eed4 (3:6ed4)
	start_script
	print_text_quit_fully Text06ab

Script_Adam: ; eed8 (3:6ed8)
	start_script
	print_npc_text Text06ac
	ask_question_jump Text06ad, .ows_eee5
	print_npc_text Text06ae
	quit_script_fully

.ows_eee5
	print_npc_text Text06af
	start_duel PRIZES_4, FLAMETHROWER_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatAdam: ; eeed (3:6eed)
	start_script
	print_npc_text Text06b0
	give_booster_packs BOOSTER_COLOSSEUM_FIRE, BOOSTER_COLOSSEUM_FIRE, NO_BOOSTER
	print_npc_text Text06b1
	quit_script_fully

Script_LostToAdam: ; eef9 (3:6ef9)
	start_script
	print_text_quit_fully Text06b2

Script_Jonathan: ; eefd (3:6efd)
	start_script
	print_npc_text Text06b3
	ask_question_jump Text06b4, .ows_ef0a
	print_npc_text Text06b5
	quit_script_fully

.ows_ef0a
	print_npc_text Text06b6
	start_duel PRIZES_4, RESHUFFLE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJonathan: ; ef12 (3:6f12)
	start_script
	print_npc_text Text06b7
	give_booster_packs BOOSTER_COLOSSEUM_FIRE, BOOSTER_COLOSSEUM_FIRE, NO_BOOSTER
	print_npc_text Text06b8
	quit_script_fully

Script_LostToJonathan: ; ef1e (3:6f1e)
	start_script
	print_text_quit_fully Text06b9

Script_Ken: ; ef22 (3:6f22)
	start_script
	try_give_pc_pack $09
	jump_if_event_true EVENT_KEN_HAD_ENOUGH_CARDS, .have_300_cards
	jump_if_enough_cards_owned 300, .have_300_cards
	test_if_event_zero EVENT_KEN_TALKED
	print_variable_npc_text Text06ba, Text06bb
	set_event EVENT_KEN_TALKED, TRUE
	quit_script_fully

.have_300_cards
	max_out_event_value EVENT_KEN_HAD_ENOUGH_CARDS
	jump_if_event_true EVENT_BEAT_KEN, Script_Ken_AlreadyHaveMedal
	test_if_event_zero EVENT_KEN_TALKED
	print_variable_npc_text Text06bc, Text06bd
	set_event EVENT_KEN_TALKED, TRUE
	ask_question_jump Text06be, .start_duel
	print_npc_text Text06bf
	quit_script_fully

.start_duel
	print_npc_text Text06c0
	start_duel PRIZES_6, FIRE_CHARGE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatKen: ; ef5e (3:6f5e)
	start_script
	print_npc_text Text06c1
	jump_if_event_true EVENT_BEAT_KEN, .give_booster_packs
	max_out_event_value EVENT_BEAT_KEN
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_KEN
	record_master_win $08
	print_npc_text Text06c2
.give_booster_packs
	give_booster_packs BOOSTER_MYSTERY_NEUTRAL, BOOSTER_MYSTERY_NEUTRAL, NO_BOOSTER
	print_npc_text Text06c3
	quit_script_fully

Script_LostToKen: ; ef78 (3:6f78)
	start_script
	test_if_event_false EVENT_BEAT_KEN
	print_variable_npc_text Text06c4, Text06c5
	quit_script_fully

Script_Ken_AlreadyHaveMedal: ; ef83 (3:6f83)
	print_npc_text Text06c6
	ask_question_jump Text06be, .start_duel
	print_text_quit_fully Text06bf

.start_duel
	print_npc_text Text06c7
	start_duel PRIZES_6, FIRE_CHARGE_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Preload_Clerk9: ; ef96 (3:6f96)
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	ld hl, .jump_table
	cp 9
	jp c, JumpToFunctionInTable
	debug_nop
	jr .less_than_three_medals

.jump_table
	dw .less_than_three_medals
	dw .less_than_three_medals
	dw .less_than_three_medals
	dw .three_medals
	dw .four_medals
	dw .five_medals
	dw .more_than_five_medals
	dw .more_than_five_medals
	dw .more_than_five_medals

.three_medals
	get_event_value EVENT_CHALLENGE_CUP_1_STATE
	or a ; cp CHALLENGE_CUP_NOT_STARTED
	jr nz, .less_than_three_medals
	ld c, CHALLENGE_CUP_READY_TO_START
	set_event_value EVENT_CHALLENGE_CUP_1_STATE
	jr .less_than_three_medals

.five_medals
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	or a ; cp CHALLENGE_CUP_NOT_STARTED
	jr nz, .four_medals
	ld c, CHALLENGE_CUP_READY_TO_START
	set_event_value EVENT_CHALLENGE_CUP_2_STATE
	jr .four_medals

.more_than_five_medals
	ld c, CHALLENGE_CUP_OVER
	set_event_value EVENT_CHALLENGE_CUP_2_STATE
.four_medals
	ld c, CHALLENGE_CUP_OVER
	set_event_value EVENT_CHALLENGE_CUP_1_STATE
.less_than_three_medals
	set_event_false EVENT_CHALLENGE_CUP_STARTING
	get_event_value EVENT_CHALLENGE_CUP_1_STATE
	cp CHALLENGE_CUP_NOT_STARTED
	jr z, .check_challenge_cup_two
	cp CHALLENGE_CUP_OVER
	jr z, .check_challenge_cup_two
	ld c, 1
	jr .start_challenge_cup

.check_challenge_cup_two
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	cp CHALLENGE_CUP_NOT_STARTED
	jr z, .check_challenge_cup_three
	cp CHALLENGE_CUP_OVER
	jr z, .check_challenge_cup_three
	ld c, 2
	jr .start_challenge_cup

.check_challenge_cup_three
	get_event_value EVENT_CHALLENGE_CUP_3_STATE
	cp CHALLENGE_CUP_NOT_STARTED
	jr z, .no_challenge_cup
	cp CHALLENGE_CUP_OVER
	jr z, .no_challenge_cup
	ld c, 3
.start_challenge_cup
	set_event_value EVENT_CHALLENGE_CUP_NUMBER
	max_event_value EVENT_CHALLENGE_CUP_STARTING
	ld a, MUSIC_CHALLENGE_HALL
	ld [wDefaultSong], a
.no_challenge_cup
	scf
	ret

Script_Clerk9: ; f025 (3:7025)
	start_script
	jump_if_event_zero EVENT_CHALLENGE_CUP_1_STATE, .ows_f066
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_OVER, .ows_f069
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_LOST, .ows_f06f
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_WON, .ows_f072
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_READY_TO_START, .ows_f06c
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_OVER, .ows_f069
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_LOST, .ows_f06f
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_WON, .ows_f072
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_READY_TO_START, .ows_f06c
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_OVER, .ows_f069
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_LOST, .ows_f06f
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_WON, .ows_f072
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_READY_TO_START, .ows_f06c
.ows_f066
	print_text_quit_fully Text050a

.ows_f069
	print_text_quit_fully Text050b

.ows_f06c
	print_text_quit_fully Text050c

.ows_f06f
	print_text_quit_fully Text050d

.ows_f072
	print_text_quit_fully Text050e

Preload_ChallengeHallNPCs2: ; f075 (3:7075)
	call Preload_ChallengeHallNPCs1
	ccf
	ret

Preload_ChallengeHallNPCs1: ; f07a (3:707a)
	get_event_value EVENT_CHALLENGE_CUP_STARTING
	or a
	jr z, .quit
	ld a, MUSIC_CHALLENGE_HALL
	ld [wDefaultSong], a
	scf
.quit
	ret

ChallengeHallLobbyLoadMap: ; f088 (3:7088)
	get_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE
	or a
	ret z
	ld a, NPC_RONALD1
	ld [wTempNPC], a
	call FindLoadedNPC
	ld bc, Script_f166
	jp SetNextNPCAndScript

Script_Pappy3: ; f09c (3:709c)
	start_script
	print_text_quit_fully Text050f

Script_Gal4: ; f0a0 (3:70a0)
	start_script
	print_text_quit_fully Text0510

Script_Champ: ; f0a4 (3:70a4)
	start_script
	print_text_quit_fully Text0511

Script_Hood2: ; f0a8 (3:70a8)
	start_script
	print_text_quit_fully Text0512

Script_Lass5: ; f0ac (3:70ac)
	start_script
	print_text_quit_fully Text0513

Script_Chap5: ; f0b0 (3:70b0)
	start_script
	print_text_quit_fully Text0514

Preload_ChallengeHallLobbyRonald1: ; f0b4 (3:70b4)
	set_event_zero EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	jr nz, .challenge_cup_2_ended
	get_event_value EVENT_PLAYER_ENTERED_CHALLENGE_CUP
	or a
	jr nz, .dont_load
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	cp CHALLENGE_CUP_NOT_STARTED
	jr z, .check_challenge_cup_1
	call .challenge_cup_1_ended
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	ld e, a
	get_event_value EVENT_CHALLENGE_CUP_2_RESULT
	ld d, a
	ld hl, RonaldChallengeHallLobbyCup2States
	call SetRonaldChallengeHallLobbyState
	jr nc, .dont_load
	jr .load_ronald

.check_challenge_cup_1
	get_event_value EVENT_CHALLENGE_CUP_1_STATE
	ld e, a
	get_event_value EVENT_CHALLENGE_CUP_1_RESULT
	ld d, a
	ld hl, RonaldChallengeHallLobbyCup1States
	call SetRonaldChallengeHallLobbyState
	jr nc, .dont_load
.load_ronald
	ld a, [wPlayerYCoord]
	ld [wLoadNPCYPos], a
	scf
	ret

.challenge_cup_2_ended
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_5
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_6
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_7
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_8
.challenge_cup_1_ended
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_1
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_2
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_3
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_4
.dont_load
	or a
	ret

SetRonaldChallengeHallLobbyState: ; f121 (3:7121)
	ld c, 4
.loop
	ld a, [hli]
	cp e
	jr nz, .next_inc
	ld a, [hli]
	cp d
	jr nz, .next
	ld a, [hl]
	call GetEventValue
	or a
	jr nz, .next
	ld a, [hl]
	call MaxOutEventValue
	inc hl
	ld c, [hl]
	set_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE
	scf
	ret

.next_inc
	inc hl
.next
	inc hl
	inc hl
	dec c
	jr nz, .loop
	or a
	ret

; format: cup state, cup result, convo event, convo number
; if the current cup state/result match a row in the table
; and the convo has not already occurred,
;   then load the corresponding conversation
RonaldChallengeHallLobbyCup1States: ; f146 (3:7146)
	db CHALLENGE_CUP_READY_TO_START, CHALLENGE_CUP_NOT_STARTED, EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_1, 1
	db CHALLENGE_CUP_LOST,           CHALLENGE_CUP_LOST,        EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_2, 2
	db CHALLENGE_CUP_OVER,           CHALLENGE_CUP_LOST,        EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_3, 3
	db CHALLENGE_CUP_OVER,           CHALLENGE_CUP_NOT_STARTED, EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_4, 4

RonaldChallengeHallLobbyCup2States: ; f156 (3:7156)
	db CHALLENGE_CUP_READY_TO_START, CHALLENGE_CUP_NOT_STARTED, EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_5, 5
	db CHALLENGE_CUP_LOST,           CHALLENGE_CUP_LOST,        EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_6, 6
	db CHALLENGE_CUP_OVER,           CHALLENGE_CUP_LOST,        EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_7, 7
	db CHALLENGE_CUP_OVER,           CHALLENGE_CUP_NOT_STARTED, EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_8, 8

Script_f166: ; f166 (3:7166)
	start_script
	move_active_npc NPCMovement_f232
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 1, .ows_f192
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 2, .ows_f1a5
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 3, .ows_f1b8
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 4, .ows_f1cb
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 5, .ows_f1de
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 6, .ows_f1f1
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 7, .ows_f204
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 8, .ows_f217
.ows_f192
	print_npc_text Text0515
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text Text0516
	script_jump .ows_f227

.ows_f1a5
	print_npc_text Text0517
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text Text0518
	script_jump .ows_f227

.ows_f1b8
	print_npc_text Text0519
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text Text051a
	script_jump .ows_f227

.ows_f1cb
	print_npc_text Text051b
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text Text051c
	script_jump .ows_f227

.ows_f1de
	print_npc_text Text051d
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text Text051e
	script_jump .ows_f227

.ows_f1f1
	print_npc_text Text051f
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text Text0520
	script_jump .ows_f227

.ows_f204
	print_npc_text Text0521
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text Text0522
	script_jump .ows_f227

.ows_f217
	print_npc_text Text0523
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text Text0524
.ows_f227
	close_text_box
	set_player_direction SOUTH
	move_player NORTH, 4
	move_active_npc NPCMovement_f232
	unload_active_npc
	quit_script_fully

NPCMovement_f232: ; f232 (3:7232)
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff

ChallengeHallAfterDuel: ; f239 (3:7239)
	ld c, 0
	ld a, [wDuelResult]
	or a ; cp DUEL_WIN
	jr z, .won
	ld c, 2
.won
	ld b, 0
	ld hl, ChallengeHallAfterDuelTable
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, NPC_HOST
	ld [wTempNPC], a
	jp SetNextNPCAndScript

ChallengeHallAfterDuelTable:
	dw Script_WonAtChallengeHall
	dw Script_LostAtChallengeHall

ChallengeHallLoadMap: ; f258 (3:7258)
	get_event_value EVENT_CHALLENGE_CUP_IN_MENU
	or a
	ret z
	ld a, NPC_HOST
	ld [wTempNPC], a
	call FindLoadedNPC
	ld bc, Script_f433
	jp SetNextNPCAndScript

Script_Clerk13: ; f26c (3:726c)
	start_script
	print_text_quit_fully Text0525

Preload_Guide: ; f270 (3:7270)
	get_event_value EVENT_CHALLENGE_CUP_STARTING
	or a
	jr z, .asm_f281
	ld a, $1c
	ld [wLoadNPCXPos], a
	ld a, $02
	ld [wLoadNPCYPos], a
.asm_f281
	scf
	ret

Script_Guide: ; f283 (3:7283)
	start_script
	jump_if_event_false EVENT_CHALLENGE_CUP_STARTING, .ows_f28b
	print_text_quit_fully Text0526

.ows_f28b
	jump_if_event_zero EVENT_CHALLENGE_CUP_1_STATE, .ows_f292
	print_text_quit_fully Text0527

.ows_f292
	print_text_quit_fully Text0528

Script_Clerk12: ; f295 (3:7295)
	start_script
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_LOST, .ows_f2c4
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_WON, .ows_f2c1
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_LOST, .ows_f2c4
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_WON, .ows_f2c1
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_LOST, .ows_f2c4
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_WON, .ows_f2c1
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 2, .ows_f2cd
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f2d3
	script_jump .ows_f2c7

.ows_f2c1
	print_text_quit_fully Text0529

.ows_f2c4
	print_text_quit_fully Text052a

.ows_f2c7
	print_npc_text Text052b
	script_jump .ows_f2d6

.ows_f2cd
	print_npc_text Text052c
	script_jump .ows_f2d6

.ows_f2d3
	print_npc_text Text052d
.ows_f2d6
	print_npc_text Text052e
	ask_question_jump Text052f, .ows_f2e1
	print_text_quit_fully Text0530

.ows_f2e1
	max_out_event_value EVENT_PLAYER_ENTERED_CHALLENGE_CUP
	print_npc_text Text0531
	close_text_box
	move_active_npc NPCMovement_f349
	jump_if_player_coords_match 8, 18, .ows_f2fa
	jump_if_player_coords_match 12, 18, .ows_f302
	move_player NORTH, 2
	script_jump .ows_f307

.ows_f2fa
	set_player_direction EAST
	move_player EAST, 2
	script_jump .ows_f307

.ows_f302
	set_player_direction WEST
	move_player WEST, 2
.ows_f307
	set_player_direction NORTH
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	jump_if_event_true EVENT_CHALLENGE_CUP_STAGE_VISITED, .ows_f33a
	max_out_event_value EVENT_CHALLENGE_CUP_STAGE_VISITED
	move_player NORTH, 1
	move_player NORTH, 1
	set_player_direction EAST
	do_frames 30
	set_player_direction SOUTH
	do_frames 20
	set_player_direction EAST
	do_frames 20
	set_player_direction SOUTH
	do_frames 30
	move_player SOUTH, 1
	move_player SOUTH, 1
.ows_f33a
	set_player_direction EAST
	move_player EAST, 1
	move_active_npc NPCMovement_f34e
	close_advanced_text_box
	set_next_npc_and_script NPC_HOST, Script_f353
	end_script
	ret

NPCMovement_f349: ; f349 (3:7349)
	db NORTH
	db NORTH
	db EAST
NPCMovement_f34c: ; f34c (3:734c)
	db WEST | NO_MOVE
	db $ff

NPCMovement_f34e: ; f34e (3:734e)
	db WEST
	db SOUTH
	db SOUTH
	db $ff

Script_Host: ; f352 (3:7352)
	ret

Script_f353: ; f353 (3:7353)
	start_script
	do_frames 20
	move_active_npc NPCMovement_f37d
	do_frames 20
	move_active_npc NPCMovement_f390
	load_challenge_hall_npc_into_txram_slot 0
	print_npc_text Text0532
	close_text_box
	move_active_npc NPCMovement_f37f
	print_npc_text Text0533
	close_text_box
	move_active_npc NPCMovement_f388
	print_npc_text Text0534
	close_text_box
	move_active_npc NPCMovement_f38e
	print_npc_text Text0535
	start_challenge_hall_duel PRIZES_4, SAMS_PRACTICE_DECK_ID, MUSIC_STOP
	quit_script_fully

NPCMovement_f37d: ; f37d (3:737d)
	db EAST | NO_MOVE
	db $ff

NPCMovement_f37f: ; f37f (3:737f)
	db EAST
	db EAST
	db SOUTH
	db $ff

NPCMovement_f383: ; f383 (3:7383)
	db NORTH
	db WEST
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_f388: ; f388 (3:7388)
	db NORTH
	db WEST
	db WEST
NPCMovement_f38b: ; f38b (3:738b)
	db WEST
	db SOUTH
	db $ff

NPCMovement_f38e: ; f38e (3:738e)
	db NORTH
	db EAST
NPCMovement_f390: ; f390 (3:7390)
	db SOUTH | NO_MOVE
	db $ff

Script_LostAtChallengeHall: ; f392 (3:7392)
	start_script
	do_frames 20
	move_active_npc NPCMovement_f37d
	do_frames 20
	move_active_npc NPCMovement_f390
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2, Script_f410
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 3, Script_f410.ows_f41a
	load_challenge_hall_npc_into_txram_slot 0
	load_challenge_hall_npc_into_txram_slot 1
	print_npc_text Text0536
.ows_f3ae
	close_text_box
	move_active_npc NPCMovement_f38b
	print_npc_text Text0537
	close_text_box
	move_active_npc NPCMovement_f38e
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 2, .ows_f3ce
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f3d9
	set_event EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_LOST
	set_event EVENT_CHALLENGE_CUP_1_RESULT, CHALLENGE_CUP_LOST
	zero_out_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_2
	script_jump .ows_f3e2

.ows_f3ce
	set_event EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_LOST
	set_event EVENT_CHALLENGE_CUP_2_RESULT, CHALLENGE_CUP_LOST
	zero_out_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_6
	script_jump .ows_f3e2

.ows_f3d9
	set_event EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_LOST
	set_event EVENT_CHALLENGE_CUP_3_RESULT, CHALLENGE_CUP_LOST
	script_jump .ows_f3e2

.ows_f3e2
	close_advanced_text_box
	set_next_npc_and_script NPC_CLERK12, Script_f3e9
	end_script
	ret

Script_f3e9: ; f3e9 (3:73e9)
	start_script
	move_active_npc NPCMovement_f40a
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_active_npc NPCMovement_f40d
	quit_script_fully

NPCMovement_f40a: ; f40a (3:740a)
	db WEST
	db EAST | NO_MOVE
	db $ff

NPCMovement_f40d: ; f40d (3:740d)
	db EAST
	db SOUTH | NO_MOVE
	db $ff

Script_f410: ; f410 (3:7410)
	load_challenge_hall_npc_into_txram_slot 0
	load_challenge_hall_npc_into_txram_slot 1
	print_npc_text Text0538
	script_jump Script_LostAtChallengeHall.ows_f3ae

.ows_f41a
	print_npc_text Text0539
	set_dialog_npc NPC_RONALD1
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f42e
	test_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 1
	print_variable_npc_text Text053a, Text053b
.ows_f42e
	set_dialog_npc NPC_HOST
	script_jump Script_LostAtChallengeHall.ows_f3ae

Script_f433: ; f433 (3:7433)
	start_script
	do_frames 20
	move_active_npc NPCMovement_f37d
	do_frames 20
	move_active_npc NPCMovement_f390
	script_jump Script_WonAtChallengeHall.ows_f4a4

Script_WonAtChallengeHall: ; f441 (3:7441)
	start_script
	do_frames 20
	move_active_npc NPCMovement_f37d
	do_frames 20
	move_active_npc NPCMovement_f390
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 3, Script_f4db
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2, .ows_f456
.ows_f456
	test_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 1
	print_variable_npc_text Text053c, Text053d
	move_active_npc NPCMovement_f37f
	load_challenge_hall_npc_into_txram_slot 0
	print_npc_text Text053e
	close_text_box
	move_challenge_hall_npc NPCMovement_f4c8
	unload_challenge_hall_npc
	print_npc_text Text053f
	close_text_box
	pick_challenge_hall_opponent
	set_challenge_hall_npc_coords 20, 20
	move_challenge_hall_npc NPCMovement_f4d0
	load_challenge_hall_npc_into_txram_slot 0
	test_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2
	print_variable_npc_text Text0540, Text0541
	move_active_npc NPCMovement_f383
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2, .ows_f4a4
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f4a1
	close_text_box
	set_dialog_npc NPC_RONALD1
	test_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 1
	print_variable_npc_text Text0542, Text0543
	set_dialog_npc NPC_HOST
	close_text_box
.ows_f4a1
	print_npc_text Text0544
.ows_f4a4
	zero_out_event_value EVENT_CHALLENGE_CUP_IN_MENU
	print_npc_text Text0545
	ask_question_jump_default_yes Text0546, .ows_f4bd
	test_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2
	print_variable_npc_text Text0547, Text0548
	start_challenge_hall_duel PRIZES_4, SAMS_PRACTICE_DECK_ID, MUSIC_STOP
	quit_script_fully

.ows_f4bd
	print_npc_text Text0549
	close_text_box
	max_out_event_value EVENT_CHALLENGE_CUP_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_f4a4

NPCMovement_f4c8: ; f4c8 (3:74c8)
	db EAST
NPCMovement_f4c9: ; f4c9 (3:74c9)
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

NPCMovement_f4d0: ; f4d0 (3:74d0)
	db NORTH
	db NORTH
	db NORTH
	db NORTH
	db NORTH
	db NORTH
	db WEST
	db $ff

NPCMovement_f4d8: ; f4d8 (3:74d8)
	db EAST
	db SOUTH | NO_MOVE
	db $ff

Script_f4db: ; f4db (3:74db)
	print_npc_text Text054a
	move_active_npc NPCMovement_f37f
	load_challenge_hall_npc_into_txram_slot 0
	print_npc_text Text054b
	close_text_box
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f513
	set_dialog_npc NPC_RONALD1
	test_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 1
	print_variable_npc_text Text054c, Text054d
	move_challenge_hall_npc NPCMovement_f4d8
	do_frames 40
	move_challenge_hall_npc NPCMovement_f34c
	test_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 1
	print_variable_npc_text Text054e, Text054f
	set_dialog_npc NPC_HOST
	close_text_box
	move_challenge_hall_npc NPCMovement_f4c9
	script_jump .ows_f516

.ows_f513
	move_challenge_hall_npc NPCMovement_f4c8
.ows_f516
	unload_challenge_hall_npc
	move_active_npc NPCMovement_f383
	print_npc_text Text0550
	close_text_box
	move_active_npc NPCMovement_f38b
	pick_challenge_cup_prize_card
	print_npc_text Text0551
	give_card VARIABLE_CARD
	show_card_received_screen VARIABLE_CARD
	print_npc_text Text0552
	close_text_box
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 2, .ows_f540
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f549
	set_event EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_WON
	set_event EVENT_CHALLENGE_CUP_1_RESULT, CHALLENGE_CUP_WON
	script_jump .ows_f552

.ows_f540
	set_event EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_WON
	set_event EVENT_CHALLENGE_CUP_2_RESULT, CHALLENGE_CUP_WON
	script_jump .ows_f552

.ows_f549
	set_event EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_WON
	set_event EVENT_CHALLENGE_CUP_3_RESULT, CHALLENGE_CUP_WON
	script_jump .ows_f552

.ows_f552
	close_advanced_text_box
	set_next_npc_and_script NPC_CLERK12, Script_f3e9
	end_script
	ret

; Loads the NPC to fight at the challenge hall
Preload_ChallengeHallOpponent: ; f559 (3:7559)
	get_event_value EVENT_CHALLENGE_CUP_STARTING
	or a
	ret z
	get_event_value EVENT_CHALLENGE_CUP_OPPONENT_CHOSEN
	or a
	jr z, .asm_f56e
	ld a, [wChallengeHallNPC]
	ld [wTempNPC], a
	scf
	ret

.asm_f56e
	call Func_f5db
	ld c, 1
	set_event_value EVENT_CHALLENGE_CUP_OPPONENT_NUMBER
	call Func_f580
	max_event_value EVENT_CHALLENGE_CUP_OPPONENT_CHOSEN
	scf
	ret

Func_f580: ; f580 (3:7580)
	get_event_value EVENT_CHALLENGE_CUP_NUMBER
	cp 3
	jr z, .pick_challenger_include_ronald
	get_event_value EVENT_CHALLENGE_CUP_OPPONENT_NUMBER
	cp 3
	ld d, ChallengeHallNPCs.end - ChallengeHallNPCs - 1 ; discount Ronald
	jr nz, .pick_challenger
	ld a, NPC_RONALD1
	jr .force_ronald

.pick_challenger_include_ronald
	ld d, ChallengeHallNPCs.end - ChallengeHallNPCs

.pick_challenger
	ld a, d
	call Random
	ld c, a
	call Func_f5cc
	jr c, .pick_challenger
	call Func_f5d4
	ld b, 0
	ld hl, ChallengeHallNPCs
	add hl, bc
	ld a, [hl]

.force_ronald
	ld [wTempNPC], a
	ld [wChallengeHallNPC], a
	ret

ChallengeHallNPCs: ; f5b3 (3:75b3)
	db NPC_CHRIS
	db NPC_MICHAEL
	db NPC_JESSICA
	db NPC_MATTHEW
	db NPC_RYAN
	db NPC_ANDREW
	db NPC_SARA
	db NPC_AMANDA
	db NPC_JOSHUA
	db NPC_JENNIFER
	db NPC_NICHOLAS
	db NPC_BRANDON
	db NPC_BRITTANY
	db NPC_KRISTIN
	db NPC_HEATHER
	db NPC_ROBERT
	db NPC_DANIEL
	db NPC_STEPHANIE
	db NPC_JOSEPH
	db NPC_DAVID
	db NPC_ERIK
	db NPC_JOHN
	db NPC_ADAM
	db NPC_JONATHAN
	db NPC_RONALD1
.end

Func_f5cc: ; f5cc (3:75cc)
	call Func_f5e9
	ld a, [hl]
	and b
	ret z
	scf
	ret

Func_f5d4: ; f5d4 (3:75d4)
	call Func_f5e9
	ld a, [hl]
	or b
	ld [hl], a
	ret

Func_f5db: ; f5db (3:75db)
	xor a
	ld [wd698 + 0], a
	ld [wd698 + 1], a
	ld [wd698 + 2], a
	ld [wd698 + 3], a
	ret

Func_f5e9: ; f5e9 (3:75e9)
	ld hl, wd698
	ld a, c
.asm_f5ed
	cp $08
	jr c, .asm_f5f6
	sub $08
	inc hl
	jr .asm_f5ed
.asm_f5f6
	ld b, $80
	jr .asm_f5fd
.asm_f5fa
	srl b
	dec a
.asm_f5fd
	cp $00
	jr nz, .asm_f5fa
	ret

Func_f602: ; f602 (3:7602)
	set_event_false EVENT_CHALLENGE_CUP_OPPONENT_CHOSEN
	ret

PokemonDomeEntranceLoadMap: ; f607 (3:7607)
	set_event_false EVENT_HALL_OF_HONOR_DOORS_OPEN
	set_event_zero EVENT_POKEMON_DOME_STATE
	set_event_zero EVENT_COURTNEY_STATE
	set_event_zero EVENT_STEVE_STATE
	set_event_zero EVENT_JACK_STATE
	set_event_zero EVENT_ROD_STATE
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	ret nz
	set_event_zero EVENT_RONALD_POKEMON_DOME_STATE
	ret

PokemonDomeEntranceCloseTextBox: ; f62a (3:762a)
	ld a, MAP_EVENT_POKEMON_DOME_DOOR
	farcall Func_80b89
	ret

Script_f631: ; f631 (3:7631)
	start_script
	print_npc_text Text0508
	close_advanced_text_box
	set_next_npc_and_script NPC_RONALD1, .ows_f63c
	end_script
	ret

.ows_f63c
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	ld [wTxRam3], a
	inc a
	ld [wTxRam3_b], a
	xor a
	ld [wTxRam3 + 1], a
	ld [wTxRam3_b + 1], a

	start_script
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 7, .ows_f69b
	jump_if_event_false EVENT_RONALD_FIRST_CLUB_ENTRANCE_ENCOUNTER, .ows_f69b
	jump_if_event_true EVENT_RONALD_POKEMON_DOME_ENTRANCE_ENCOUNTER, .ows_f69b
	override_song MUSIC_RONALD
	max_out_event_value EVENT_RONALD_POKEMON_DOME_ENTRANCE_ENCOUNTER
	jump_if_player_coords_match 18, 2, .ows_f66e
	move_active_npc NPCMovement_f69c
	script_jump .ows_f671

.ows_f66e
	move_active_npc NPCMovement_f69d
.ows_f671
	print_npc_text Text0553
	close_text_box
	set_player_direction SOUTH
	move_player SOUTH, 1
	print_npc_text Text0554
	ask_question_jump_default_yes NULL, .ows_f688
	print_npc_text Text0555
	script_jump .ows_f695

.ows_f688
	jump_if_event_zero EVENT_MEDAL_COUNT, .ows_f692
	print_npc_text Text0556
	script_jump .ows_f695

.ows_f692
	print_npc_text Text0557
.ows_f695
	close_text_box
	move_active_npc NPCMovement_f6a6
	unload_active_npc
	play_default_song
.ows_f69b
	quit_script_fully

NPCMovement_f69c: ; f69c (3:769c)
	db EAST
NPCMovement_f69d: ; f69d (3:769d)
	db NORTH
	db NORTH
	db NORTH
	db NORTH
	db EAST
	db EAST
	db NORTH
	db NORTH
	db $ff

NPCMovement_f6a6: ; f6a6 (3:76a6)
	db WEST
	db WEST
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

Script_f6af: ; f6af (3:76af)
	start_script
	try_give_medal_pc_packs
	jump_if_event_equal EVENT_MEDAL_COUNT, 8, .ows_f6b9
	print_text_quit_fully Text0558

.ows_f6b9
	print_npc_text Text0559
	play_sfx SFX_0F
	replace_map_blocks MAP_EVENT_POKEMON_DOME_DOOR
	do_frames 30
	move_player NORTH, 1
	quit_script_fully

PokemonDomeMovePlayer: ; f6c6 (3:76c6)
	ld a, [wPlayerYCoord]
	cp $16
	ret nz
	ld a, [wPlayerXCoord]
	cp $0e
	ret c
	cp $11
	ret nc
	ld a, NPC_ROD
	ld [wTempNPC], a
	ld bc, Script_f84c
	jp SetNextNPCAndScript

PokemonDomeAfterDuel: ; f6e0 (3:76e0)
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_COURTNEY
	db NPC_COURTNEY
	dw Script_BeatCourtney
	dw Script_LostToCourtney

	db NPC_STEVE
	db NPC_STEVE
	dw Script_BeatSteve
	dw Script_LostToSteve

	db NPC_JACK
	db NPC_JACK
	dw Script_BeatJack
	dw Script_LostToJack

	db NPC_ROD
	db NPC_ROD
	dw Script_BeatRod
	dw Script_LostToRod

	db NPC_RONALD1
	db NPC_RONALD1
	dw Script_BeatRonald1InPokemonDome
	dw Script_LostToRonald1InPokemonDome
	db $00

PokemonDomeLoadMap: ; f706 (3:7706)
	ld a, $0d
	farcall TryGivePCPack
	get_event_value EVENT_POKEMON_DOME_IN_MENU
	or a
	ret z
	ld bc, Script_f80b
	jp SetNextScript

PokemonDomeCloseTextBox: ; f718 (3:7718)
	ld a, MAP_EVENT_HALL_OF_HONOR_DOOR
	farcall Func_80b89
	ret

Script_Courtney: ; f71f (3:771f)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text055a, Text055b
	quit_script_fully

Script_Steve: ; f72a (3:772a)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text055c, Text055d
	quit_script_fully

Script_Jack: ; f735 (3:7735)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text055e, Text055f
	quit_script_fully

Script_Rod: ; f740 (3:7740)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0560, Text0561
	quit_script_fully

Preload_Courtney: ; f74b (3:774b)
	get_event_value EVENT_COURTNEY_STATE
	cp COURTNEY_CHALLENGED
	jr z, PlacePokemonDomeOpponentAtDuelTable
	lb bc, $16, $0c
	cp COURTNEY_DEFEATED
	jr z, Func_f77d
	get_event_value EVENT_CHALLENGED_GRAND_MASTERS
	jr nz, Func_f762
	scf
	ret

Func_f762: ; f762 (3:7762)
	ld a, [wLoadNPCYPos]
	add $02
	ld [wLoadNPCYPos], a
	scf
	ret

PlacePokemonDomeOpponentAtDuelTable: ; f76c (3:776c)
	ld a, $12
	ld [wLoadNPCXPos], a
	ld a, $0e
	ld [wLoadNPCYPos], a
	ld a, WEST
	ld [wLoadNPCDirection], a
	scf
	ret

Func_f77d: ; f77d (3:777d)
	ld a, WEST
	ld [wLoadNPCDirection], a
Func_f782: ; f782 (3:7782)
	ld a, b
	ld [wLoadNPCXPos], a
	ld a, c
	ld [wLoadNPCYPos], a
	scf
	ret

Preload_Steve: ; f78c (3:778c)
	get_event_value EVENT_STEVE_STATE
	cp STEVE_CHALLENGED
	jr z, PlacePokemonDomeOpponentAtDuelTable
	lb bc, $16, $0e
	cp STEVE_DEFEATED
	jr z, Func_f77d
	get_event_value EVENT_CHALLENGED_GRAND_MASTERS
	jr nz, Func_f762
	scf
	ret

Preload_Jack: ; f7a3 (3:77a3)
	get_event_value EVENT_JACK_STATE
	cp JACK_CHALLENGED
	jr z, PlacePokemonDomeOpponentAtDuelTable
	lb bc, $14, $0a
	cp JACK_DEFEATED
	jr z, Func_f77d
	get_event_value EVENT_CHALLENGED_GRAND_MASTERS
	jr nz, Func_f762
	scf
	ret

Preload_Rod: ; f7ba (3:77ba)
	get_event_value EVENT_ROD_STATE
	cp ROD_CHALLENGED
	jr z, PlacePokemonDomeOpponentAtDuelTable
	get_event_value EVENT_POKEMON_DOME_STATE
	lb bc, $10, $0a
	cp POKEMON_DOME_DEFEATED
	jr z, Func_f782
	lb bc, $0e, $0a
	cp POKEMON_DOME_CHALLENGED
	jr z, Func_f782
	scf
	ret

Preload_Ronald1InPokemonDome: ; f7d6 (3:77d6)
	get_event_value EVENT_RONALD_POKEMON_DOME_STATE
	cp RONALD_DEFEATED
	ret nc
	get_event_value EVENT_RONALD_POKEMON_DOME_STATE
	or a
	jr z, .not_challenged
	ld a, MUSIC_RONALD
	ld [wDefaultSong], a
	jr PlacePokemonDomeOpponentAtDuelTable
.not_challenged
	scf
	ret

Script_f7ed: ; f7ed (3:77ed)
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_f7f9
	print_npc_text Text0562
.ows_f7f4
	close_text_box
	move_player NORTH, 2
	quit_script_fully

.ows_f7f9
	print_npc_text Text0563
	ask_question_jump Text0564, .ows_f804
	script_jump .ows_f7f4

.ows_f804
	enter_map $0c, POKEMON_DOME_ENTRANCE, 22, 4, NORTH
	quit_script_fully

Script_f80b: ; f80b (3:780b)
	start_script
	jump_if_event_equal EVENT_STEVE_STATE, STEVE_CHALLENGED, .ows_f820
	jump_if_event_equal EVENT_JACK_STATE, JACK_CHALLENGED, .ows_f82b
	jump_if_event_equal EVENT_ROD_STATE, ROD_CHALLENGED, .ows_f836
	jump_if_event_equal EVENT_RONALD_POKEMON_DOME_STATE, RONALD_CHALLENGED, .ows_f841
.ows_f820
	close_advanced_text_box
	set_next_npc_and_script NPC_STEVE, .ows_f827
	end_script
	ret

.ows_f827
	start_script
	script_jump Script_BeatCourtney.ows_f996

.ows_f82b
	close_advanced_text_box
	set_next_npc_and_script NPC_JACK, .ows_f832
	end_script
	ret

.ows_f832
	start_script
	script_jump Script_BeatSteve.ows_fa02

.ows_f836
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f83d
	end_script
	ret

.ows_f83d
	start_script
	script_jump Script_BeatJack.ows_fa78

.ows_f841
	close_advanced_text_box
	set_next_npc_and_script NPC_RONALD1, .ows_f848
	end_script
	ret

.ows_f848
	start_script
	script_jump Script_BeatRod.ows_fb20

Script_f84c: ; f84c (3:784c)
	start_script
	jump_if_event_true EVENT_HALL_OF_HONOR_DOORS_OPEN, Script_f7ed
	print_npc_text Text0565
	ask_question_jump Text0566, .ows_f85f
	print_npc_text Text0567
	script_jump Script_f7ed.ows_f804

.ows_f85f
	print_npc_text Text0568
	close_text_box
	jump_if_player_coords_match 14, 22, .ows_f86f
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction NORTH
.ows_f86f
	move_player NORTH, 1
	move_player NORTH, 1
	set_player_direction WEST
	move_player WEST, 1
	move_player WEST, 1
	set_player_direction NORTH
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	set_player_direction EAST
	move_player EAST, 1
	move_player EAST, 1
	set_player_direction NORTH
	test_if_event_false EVENT_CHALLENGED_GRAND_MASTERS
	print_variable_npc_text Text0569, Text056a
	move_active_npc NPCMovement_fb8c
	jump_if_event_true EVENT_CHALLENGED_GRAND_MASTERS, .ows_f8ef
	print_npc_text Text056b
	close_advanced_text_box
	set_next_npc_and_script NPC_COURTNEY, .ows_f8af
	end_script
	ret

.ows_f8af
	start_script
	move_active_npc NPCMovement_fb8e
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f8ba
	end_script
	ret

.ows_f8ba
	start_script
	print_npc_text Text056c
	close_advanced_text_box
	set_next_npc_and_script NPC_STEVE, .ows_f8c5
	end_script
	ret

.ows_f8c5
	start_script
	move_active_npc NPCMovement_fb8e
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f8d0
	end_script
	ret

.ows_f8d0
	start_script
	print_npc_text Text056d
	close_advanced_text_box
	set_next_npc_and_script NPC_JACK, .ows_f8db
	end_script
	ret

.ows_f8db
	start_script
	move_active_npc NPCMovement_fb8e
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f8e6
	end_script
	ret

.ows_f8e6
	start_script
	max_out_event_value EVENT_CHALLENGED_GRAND_MASTERS
	print_npc_text Text056e
	script_jump .ows_f8f8

.ows_f8ef
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text056f, Text0570
.ows_f8f8
	print_npc_text Text0571
	close_text_box
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	set_player_direction EAST
	move_active_npc NPCMovement_fb8d
	set_event EVENT_POKEMON_DOME_STATE, POKEMON_DOME_CHALLENGED
	close_advanced_text_box
	set_next_npc_and_script NPC_COURTNEY, .ows_f918
	end_script
	ret

.ows_f918
	start_script
	try_give_pc_pack $0e
	set_event EVENT_COURTNEY_STATE, COURTNEY_CHALLENGED
	set_dialog_npc NPC_ROD
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0572, Text0573
	close_text_box
	set_dialog_npc NPC_COURTNEY
	move_active_npc NPCMovement_fba6
	set_active_npc_direction WEST
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0574, Text0575
	start_duel PRIZES_6, LEGENDARY_MOLTRES_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

Script_LostToCourtney: ; f93f (3:793f)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0576, Text0577
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f950
	end_script
	ret

.ows_f950
	start_script
	move_active_npc NPCMovement_fba1
	print_npc_text Text0578
	script_jump Script_f7ed.ows_f804

Script_BeatCourtney: ; f95a (3:795a)
	start_script
	set_event EVENT_COURTNEY_STATE, COURTNEY_DEFEATED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0579, Text057a
	close_text_box
	move_active_npc NPCMovement_fbb7
	set_active_npc_direction WEST
	close_advanced_text_box
	set_next_npc_and_script NPC_STEVE, .ows_f974
	end_script
	ret

.ows_f974
	start_script
	try_give_pc_pack $0f
	set_event EVENT_STEVE_STATE, STEVE_CHALLENGED
	set_dialog_npc NPC_ROD
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text057b, Text057c
	close_text_box
	set_dialog_npc NPC_STEVE
	move_active_npc NPCMovement_fba4
	set_active_npc_direction WEST
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text057d, Text057e
.ows_f996
	zero_out_event_value EVENT_POKEMON_DOME_IN_MENU
	set_dialog_npc NPC_ROD
	print_npc_text Text057f
	ask_question_jump_default_yes Text0580, .ows_f9af
	print_npc_text Text0581
	set_dialog_npc NPC_STEVE
	print_npc_text Text0582
	start_duel PRIZES_6, LEGENDARY_ZAPDOS_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

.ows_f9af
	close_text_box
	max_out_event_value EVENT_POKEMON_DOME_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_f996

Script_LostToSteve: ; f9b7 (3:79b7)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0583, Text0584
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, Script_LostToCourtney.ows_f950
	end_script
	ret

Script_BeatSteve: ; f9c8 (3:79c8)
	start_script
	set_event EVENT_STEVE_STATE, STEVE_DEFEATED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0585, Text0586
	close_text_box
	move_active_npc NPCMovement_fbb8
	set_active_npc_direction WEST
	close_advanced_text_box
	set_next_npc_and_script NPC_JACK, .ows_f9e2
	end_script
	ret

.ows_f9e2
	start_script
	set_event EVENT_JACK_STATE, JACK_CHALLENGED
	set_dialog_npc NPC_ROD
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0587, Text0588
	close_text_box
	set_dialog_npc NPC_JACK
	move_active_npc NPCMovement_fbbc
	set_active_npc_direction WEST
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0589, Text058a
.ows_fa02
	zero_out_event_value EVENT_POKEMON_DOME_IN_MENU
	set_dialog_npc NPC_ROD
	print_npc_text Text058b
	ask_question_jump_default_yes Text058c, .ows_fa1b
	print_npc_text Text058d
	set_dialog_npc NPC_JACK
	print_npc_text Text058e
	start_duel PRIZES_6, LEGENDARY_ARTICUNO_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

.ows_fa1b
	close_text_box
	max_out_event_value EVENT_POKEMON_DOME_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_fa02

Script_LostToJack: ; fa23 (3:7a23)
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text058f, Text0590
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, Script_LostToCourtney.ows_f950
	end_script
	ret

Script_BeatJack: ; fa34 (3:7a34)
	start_script
	set_event EVENT_JACK_STATE, JACK_DEFEATED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0591, Text0592
	close_text_box
	move_active_npc NPCMovement_fbc2
	set_active_npc_direction WEST
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_fa52
	move_npc NPC_ROD, NPCMovement_f390
	end_script
	ret

.ows_fa52
	start_script
	set_event EVENT_ROD_STATE, ROD_CHALLENGED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0593, Text0594
	close_text_box
	move_active_npc NPCMovement_fbaf
	set_active_npc_direction WEST
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_fa75
	test_if_event_false EVENT_CHALLENGED_RONALD
	print_variable_npc_text Text0595, Text0596
	script_jump .ows_fa78

.ows_fa75
	print_npc_text Text0597
.ows_fa78
	zero_out_event_value EVENT_POKEMON_DOME_IN_MENU
	print_npc_text Text0598
	ask_question_jump_default_yes Text0599, .ows_fa90
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text059a, Text059b
	start_duel PRIZES_6, LEGENDARY_DRAGONITE_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

.ows_fa90
	close_text_box
	max_out_event_value EVENT_POKEMON_DOME_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_fa78

Script_LostToRod: ; fa98 (3:7a98)
	start_script
	print_npc_text Text059c
	close_text_box
	move_active_npc NPCMovement_fb9d
	set_active_npc_direction SOUTH
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text059d, Text059e
	script_jump Script_f7ed.ows_f804

Script_BeatRod: ; faae (3:7aae)
	start_script
	set_event EVENT_ROD_STATE, ROD_DEFEATED
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_fad5
	test_if_event_false EVENT_CHALLENGED_RONALD
	print_variable_npc_text Text059f, Text05a0
	close_text_box
	move_active_npc NPCMovement_fb90
	set_active_npc_direction SOUTH
	test_if_event_false EVENT_CHALLENGED_RONALD
	print_variable_npc_text Text05a1, Text05a2
	close_advanced_text_box
	set_next_npc_and_script NPC_RONALD1, .ows_fae9
	end_script
	ret

.ows_fad5
	print_npc_text Text05a3
	move_active_npc NPCMovement_fb96
	set_active_npc_direction SOUTH
	play_sfx SFX_0F
	replace_map_blocks MAP_EVENT_HALL_OF_HONOR_DOOR
	set_event EVENT_POKEMON_DOME_STATE, POKEMON_DOME_DEFEATED
	max_out_event_value EVENT_HALL_OF_HONOR_DOORS_OPEN
	print_text_quit_fully Text05a4

.ows_fae9
	start_script
	override_song MUSIC_STOP
	set_event EVENT_RONALD_POKEMON_DOME_STATE, RONALD_CHALLENGED
	play_sfx SFX_0F
	replace_map_blocks MAP_EVENT_HALL_OF_HONOR_DOOR
	move_active_npc NPCMovement_fbd2
	set_default_song MUSIC_RONALD
	play_default_song
	jump_if_event_true EVENT_CHALLENGED_RONALD, .ows_fb15
	print_npc_text Text05a5
	set_dialog_npc NPC_ROD
	move_npc NPC_ROD, NPCMovement_fb9b
	print_npc_text Text05a6
	set_dialog_npc NPC_RONALD1
	print_npc_text Text05a7
	move_npc NPC_ROD, NPCMovement_fb99
	script_jump .ows_fb18

.ows_fb15
	print_npc_text Text05a8
.ows_fb18
	close_text_box
	move_active_npc NPCMovement_fba8
	set_active_npc_direction WEST
	max_out_event_value EVENT_CHALLENGED_RONALD
.ows_fb20
	zero_out_event_value EVENT_POKEMON_DOME_IN_MENU
	set_dialog_npc NPC_ROD
	print_npc_text Text05a9
	ask_question_jump_default_yes Text05aa, .ows_fb40
	print_npc_text Text05ab
	set_dialog_npc NPC_RONALD1
	print_npc_text Text05ac
	set_dialog_npc NPC_ROD
	print_npc_text Text05ad
	set_dialog_npc NPC_RONALD1
	start_duel PRIZES_6, LEGENDARY_RONALD_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

.ows_fb40
	close_text_box
	max_out_event_value EVENT_POKEMON_DOME_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_fb20

Script_LostToRonald1InPokemonDome: ; fb48 (3:7b48)
	start_script
	print_npc_text Text05ae
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, Script_LostToCourtney.ows_f950
	end_script
	ret

Script_BeatRonald1InPokemonDome: ; fb53 (3:7b53)
	start_script
	set_event EVENT_RONALD_POKEMON_DOME_STATE, RONALD_DEFEATED
	print_npc_text Text05af
	set_dialog_npc NPC_ROD
	print_npc_text Text05b0
	print_text Text05b1
	set_dialog_npc NPC_RONALD1
	print_npc_text Text05b2
	close_text_box
	move_active_npc NPCMovement_fbc7
	unload_active_npc
	set_default_song MUSIC_HALL_OF_HONOR
	play_default_song
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_fb76
	end_script
	ret

.ows_fb76
	start_script
	move_active_npc NPCMovement_fba1
	set_player_direction NORTH
	print_npc_text Text05b3
	move_active_npc NPCMovement_fbb2
	set_event EVENT_POKEMON_DOME_STATE, POKEMON_DOME_DEFEATED
	max_out_event_value EVENT_HALL_OF_HONOR_DOORS_OPEN
	record_master_win $0a
	print_text_quit_fully Text05b4

NPCMovement_fb8c: ; fb8c (3:7b8c)
	db EAST
NPCMovement_fb8d: ; fb8d (3:7b8d)
	db SOUTH
NPCMovement_fb8e: ; fb8e (3:7b8e)
	db SOUTH
	db $ff

NPCMovement_fb90: ; fb90 (3:7b90)
	db NORTH
	db NORTH
	db WEST
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_fb96: ; fb96 (3:7b96)
	db NORTH
	db NORTH
	db WEST
NPCMovement_fb99: ; fb99 (3:7b99)
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_fb9b: ; fb9b (3:7b9b)
	db NORTH | NO_MOVE
	db $ff

NPCMovement_fb9d: ; fb9d (3:7b9d)
	db NORTH
	db NORTH
	db WEST
	db WEST
NPCMovement_fba1: ; fba1 (3:7ba1)
	db WEST
	db SOUTH
	db $ff

NPCMovement_fba4: ; fba4 (3:7ba4)
	db WEST
	db WEST
NPCMovement_fba6: ; fba6 (3:7ba6)
	db WEST
	db SOUTH
NPCMovement_fba8: ; fba8 (3:7ba8)
	db SOUTH
	db SOUTH
	db EAST
	db SOUTH
	db SOUTH
	db WEST | NO_MOVE
	db $ff

NPCMovement_fbaf: ; fbaf (3:7baf)
	db EAST
	db $fe, -7

NPCMovement_fbb2: ; fbb2 (3:7bb2)
	db NORTH
	db EAST
	db EAST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_fbb7: ; fbb7 (3:7bb7)
	db NORTH
NPCMovement_fbb8: ; fbb8 (3:7bb8)
	db EAST
	db EAST
	db WEST | NO_MOVE
	db $ff

NPCMovement_fbbc: ; fbbc (3:7bbc)
	db EAST
	db EAST
	db EAST
	db EAST
	db $fe, -26

NPCMovement_fbc2: ; fbc2 (3:7bc2)
	db NORTH
	db NORTH
	db EAST
	db WEST | NO_MOVE
	db $ff

NPCMovement_fbc7: ; fbc7 (3:7bc7)
	db SOUTH
	db SOUTH
	db WEST
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

NPCMovement_fbd2: ; fbd2 (3:7bd2)
	db WEST
	db WEST
	db WEST
	db WEST
	db WEST
	db WEST
	db WEST
	db $fe, -12

HallOfHonorLoadMap: ; fbdb (3:7bdb)
	ld a, SFX_10
	call PlaySFX
	ret

Script_fbe1: ; fbe1 (3:7be1)
	start_script
	print_text Text05b5
	ask_question_jump_default_yes Text05b6, .ows_fbee
	print_text Text05b7
	quit_script_fully

.ows_fbee
	open_deck_machine $0a
	quit_script_fully

Script_fbf1: ; fbf1 (3:7bf1)
	start_script
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_fc10
	max_out_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	print_text Text05b8
	give_card ZAPDOS3
	give_card MOLTRES2
	give_card ARTICUNO2
	give_card DRAGONITE1
	show_card_received_screen $ff
.ows_fc05
	flash_screen 0
	print_text Text05b9
.ows_fc0a
	flash_screen 1
	save_game 1
	play_credits
	quit_script_fully

.ows_fc10
	jump_if_event_equal EVENT_LEGENDARY_CARDS_RECEIVED_FLAGS, %1111, .ows_fc20
	pick_legendary_card
	print_text Text05ba
	give_card VARIABLE_CARD
	show_card_received_screen VARIABLE_CARD
	script_jump .ows_fc05

.ows_fc20
	print_text Text05bb
	flash_screen 0
	print_text Text05bc
	script_jump .ows_fc0a

Func_fc2b: ; fc2b (3:7c2b)
	ld a, [wDuelResult]
	cp DUEL_LOSS + 1
	jr c, .win_or_loss
	ld a, 2 ; transmission error
.win_or_loss
	rlca
	ld c, a
	ld b, 0
	ld hl, PointerTable_fc4c
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, LOW(ClerkNPCName_)
	ld [wCurrentNPCNameTx], a
	ld a, HIGH(ClerkNPCName_)
	ld [wCurrentNPCNameTx + 1], a
	jp SetNextScript

PointerTable_fc4c: ; fc4c (3:7c4c)
	dw Script_fc64
	dw Script_fc68
	dw Script_fc60

Script_fc52: ; fc52 (3:7c52)
	start_script
	print_npc_text Text06c8
	ask_question_jump_default_yes NULL, .ows_fc5e
	print_text_quit_fully Text06c9

.ows_fc5e
	battle_center
	quit_script_fully

Script_fc60: ; fc60 (3:7c60)
	start_script
	print_text_quit_fully Text06ca

Script_fc64: ; fc64 (3:7c64)
	start_script
	print_text_quit_fully Text06cb

Script_fc68: ; fc68 (3:7c68)
	start_script
	print_text_quit_fully Text06cc

; Clerk looks away from you if you can't use infrared
; This is one of the preloads that does not change whether or not they appear
Preload_GiftCenterClerk: ; fc6c (3:7c6c)
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr z, .cgb
	ld a, NORTH
	ld [wLoadNPCDirection], a
.cgb
	scf
	ret

Func_fc7a: ; fc7a (3:7c7a)
	ld a, [wConsole]
	ld c, a
	set_event_value EVENT_CONSOLE

	start_script
	jump_if_event_not_equal EVENT_CONSOLE, CONSOLE_CGB, Func_fcad.ows_fcd5
	print_npc_text Text06cd
	gift_center 0
	jump_if_event_greater_or_equal EVENT_GIFT_CENTER_MENU_CHOICE, GIFT_CENTER_MENU_EXIT, .ows_fcaa
	print_npc_text Text06ce
	ask_question_jump_default_yes Text06cf, .ows_fca0
	print_npc_text Text06d0
	script_jump .ows_fcaa

.ows_fca0
	save_game 0
	play_sfx SFX_56
	print_text Text06d1
	gift_center 1
	quit_script_fully

.ows_fcaa
	print_text_quit_fully Text06d2

Func_fcad: ; fcad (3:7cad)
	ld a, [wd10e]
	ld c, a
	set_event_value EVENT_GIFT_CENTER_MENU_CHOICE

	start_script
	play_sfx SFX_56
	save_game 0
	jump_if_event_equal EVENT_GIFT_CENTER_MENU_CHOICE, GIFT_CENTER_MENU_SEND_CARD, .ows_fccc
	jump_if_event_equal EVENT_GIFT_CENTER_MENU_CHOICE, GIFT_CENTER_MENU_SEND_DECK, .ows_fccf
	jump_if_event_equal EVENT_GIFT_CENTER_MENU_CHOICE, GIFT_CENTER_MENU_RECEIVE_DECK, .ows_fcd2
; GIFT_CENTER_MENU_RECEIVE_CARD
	script_jump Func_fc7a.ows_fcaa

.ows_fccc
	print_text_quit_fully Text06d3

.ows_fccf
	print_text_quit_fully Text06d4

.ows_fcd2
	print_text_quit_fully Text06d5

.ows_fcd5
	move_npc NPC_GIFT_CENTER_CLERK, NPCMovement_fce1
	print_npc_text Text06d6
	move_npc NPC_GIFT_CENTER_CLERK, NPCMovement_fce3
	quit_script_fully

NPCMovement_fce1: ; fce1 (3:7ce1)
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_fce3: ; fce3 (3:7ce3)
	db NORTH | NO_MOVE
	db $ff
