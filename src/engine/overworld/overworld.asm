LoadMap:
	call DisableLCD
	call EnableSRAM
	bank1call DiscardSavedDuelData
	call DisableSRAM
	ld a, GAME_EVENT_OVERWORLD
	ld [wGameEvent], a
	xor a
	ld [wReloadOverworldCallbackPtr], a
	ld [wReloadOverworldCallbackPtr + 1], a
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
	farcall FadeScreenToWhite
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
	ld [wOverworldNPCFlags], a
	call PlayDefaultSong
	farcall FadeScreenFromWhite
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
	farcall FadeScreenToWhite
	call Func_c1a0
	ld a, [wMatchStartTheme]
	or a
	jr z, .no_duel
	call Func_c280
	farcall Duel_Init
.no_duel
	call Func_c280
	ret

HandleOverworldMode:
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

OverworldModePointers:
	dw UpdateOverworldMap
	dw CallHandlePlayerMoveMode
	dw SetScriptData
	dw EnterScript

UpdateOverworldMap:
	farcall OverworldMap_Update
	ret

CallHandlePlayerMoveMode:
	call HandlePlayerMoveMode
	ret

SetScriptData:
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

EnterScript:
	ld hl, wNextScript
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; closes dialogue window. seems to be for other things as well.
CloseAdvancedDialogueBox:
	ld a, [wOverworldNPCFlags]
	bit AUTO_CLOSE_TEXTBOX, a
	call nz, CloseTextBox
	ld a, [wOverworldNPCFlags]
	bit RESTORE_FACING_DIRECTION, a
	jr z, .skip
	ld a, [wScriptNPC]
	ld [wLoadedNPCTempIndex], a
	farcall Func_1c5e9
.skip
	xor a
	ld [wOverworldNPCFlags], a
	ld a, [wOverworldModeBackup]
	ld [wOverworldMode], a
	ret

; redraws the background and removes textbox control
CloseTextBox:
	push hl
	farcall ReloadMapAfterTextClose
	ld hl, wOverworldNPCFlags
	res AUTO_CLOSE_TEXTBOX, [hl]
	pop hl
	ret

Func_c141:
	ld hl, wActiveGameEvent
	ld a, [hl]
	or a
	ret z
	push af
	xor a
	ld [hl], a ; clear game event
	pop af
	dec a
	ld hl, PointerTable_c152
	jp JumpToFunctionInTable

PointerTable_c152:
	dw Func_c9bc ; GAME_EVENT_DUEL
	dw Func_fc2b ; GAME_EVENT_BATTLE_CENTER
	dw Func_fcad ; GAME_EVENT_GIFT_CENTER

Func_c158:
	ld a, [wActiveGameEvent]
	cp GAME_EVENT_DUEL
	ret nz
	ld a, [wNPCDuelist]
	ld [wTempNPC], a
	call FindLoadedNPC
	jr c, .asm_c179
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	ld a, [wNPCDuelistDirection]
	ld [hl], a
	farcall UpdateNPCAnimation
.asm_c179
	ret

Func_c17a:
	ld a, [wOverworldMode]
	cp OWMODE_SCRIPT
	ret z
	call Func_c9b8
	ret

Func_c184:
	push bc
	ld c, OWMODE_MOVE
	ld a, [wCurMap]
	cp OVERWORLD_MAP
	jr nz, .not_map
	ld c, OWMODE_MAP
.not_map
	ld a, c
	ld [wOverworldMode], a
	ld [wOverworldModeBackup], a
	pop bc
	ret

SetOverworldDoFrameFunction:
	ld hl, OverworldDoFrameFunction
	call SetDoFrameFunction
	ret

Func_c1a0:
	call ResetDoFrameFunction
	ret

WhiteOutDMGPals:
	xor a
	call SetBGP
	xor a
	call SetOBP0
	xor a
	call SetOBP1
	ret

Func_c1b1:
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
	farcall ChallengeMachine_Reset
	xor a
	ld [wPlayTimeCounter + 0], a
	ld [wPlayTimeCounter + 1], a
	ld [wPlayTimeCounter + 2], a
	ld [wPlayTimeCounter + 3], a
	ld [wPlayTimeCounter + 4], a
	ret

Func_c1ed:
	call ClearEvents
	farcall LoadBackupSaveData
	call DetermineImakuniAndChallengeHall
	ret

Func_c1f8:
	xor a
	ld [wSelectedPauseMenuItem], a
	ld [wSelectedPCMenuItem], a
	ld [wSelectedGiftCenterMenuItem], a
	ld [wConfigCursorYPos], a
	ld [wActiveGameEvent], a
	ld [wDefaultSong], a
	ld [wSongOverride], a
	ld [wRonaldIsInMap], a
	call EnableSRAM
	ld a, [sAnimationsDisabled]
	ld [wAnimationsDisabled], a
	ld a, [sTextSpeed]
	ld [wTextSpeed], a
	call DisableSRAM
	farcall InitPCPacks
	ret

BackupPlayerPosition:
	ld a, [wCurMap]
	ld [wTempMap], a
	ld a, [wPlayerXCoord]
	ld [wTempPlayerXCoord], a
	ld a, [wPlayerYCoord]
	ld [wTempPlayerYCoord], a
	ld a, [wPlayerDirection]
	ld [wTempPlayerDirection], a
	ret

Func_c241:
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

Func_c251:
	ldh a, [hffb0]
	push af
	ld a, $1
	jr Func_c258.asm_c25d

Func_c258:
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

Func_c268:
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

PauseMenuTextList:
	tx PauseMenuOptionsText
	dw NULL

Func_c280:
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

SetOverworldNPCFlags:
	push hl
	ld hl, wOverworldNPCFlags
	or [hl]
	ld [hl], a
	pop hl
	ret

Func_c2a3:
	push hl
	push bc
	push de
	call BackupObjectPalettes
	farcall FadeScreenToWhite
	ld a, 1 << HIDE_ALL_NPC_SPRITES
	call SetOverworldNPCFlags
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

ReturnToOverworldNoCallback:
	xor a
	ld [wReloadOverworldCallbackPtr], a
	ld [wReloadOverworldCallbackPtr + 1], a
;	fallthrough

ReturnToOverworld:
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
	ld hl, wOverworldNPCFlags
	res AUTO_CLOSE_TEXTBOX, [hl]
	call RestoreObjectPalettes
	farcall Func_12c5e
	farcall SetAllNPCTilePermissions
	ld hl, wOverworldNPCFlags
	res HIDE_ALL_NPC_SPRITES, [hl]
	ld hl, wReloadOverworldCallbackPtr
	ld a, [hli]
	or [hl]
	jr z, .no_callback
	ld a, [hld]
	ld l, [hl]
	ld h, a
	call CallHL2
.no_callback
	farcall FadeScreenFromWhite
	pop de
	pop bc
	pop hl
	ret

ReturnToOverworldWithCallback:
	ld a, l
	ld [wReloadOverworldCallbackPtr], a
	ld a, h
	ld [wReloadOverworldCallbackPtr + 1], a
	jr ReturnToOverworld

BackupObjectPalettes:
	ld a, [wOBP0]
	ld [wOBP0Backup], a
	ld a, [wOBP1]
	ld [wOBP1Backup], a
	ld hl, wObjectPalettesCGB
	ld de, wObjectPalettesCGBBackup
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	ret

RestoreObjectPalettes:
	ld a, [wOBP0Backup]
	ld [wOBP0], a
	ld a, [wOBP1Backup]
	ld [wOBP1], a
	ld hl, wObjectPalettesCGBBackup
	ld de, wObjectPalettesCGB
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	call FlushAllPalettes
	ret

Func_c36a:
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
LoadPermissionMap:
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
DecompressPermissionMap:
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

; de = coordinates
Func_c3ca:
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
Func_c3ee:
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

Func_c3ff:
	ld a, [wBGMapWidth]
	sub SCREEN_WIDTH
	ld [wd237], a
	ld a, [wBGMapHeight]
	sub SCREEN_HEIGHT
	ld [wd238], a
	call Func_c41c
	call Func_c469
	call SetScreenScrollWram
	call SetScreenScroll
	ret

Func_c41c:
	ld a, [wPlayerXCoordPixels]
	sub $40
	ld [wSCXBuffer], a
	ld a, [wPlayerYCoordPixels]
	sub $40
	ld [wSCYBuffer], a
	call Func_c430
	ret

Func_c430:
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

Func_c469:
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

SetScreenScrollWram:
	ld a, [wSCXBuffer]
	ld [wSCX], a
	ld a, [wSCYBuffer]
	ld [wSCY], a
	ret

SetScreenScroll:
	ld a, [wSCX]
	ldh [hSCX], a
	ld a, [wSCY]
	ldh [hSCY], a
	ret

Func_c49c:
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

Func_c4b9:
	xor a
	ld [wVRAMTileOffset], a
	ld [wd4cb], a
	ld a, PALETTE_29
	farcall LoadPaletteData
	ld b, SPRITE_ANIM_LIGHT_NPC_UP
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld b, SPRITE_ANIM_RED_NPC_UP
.not_cgb
	ld a, b
	ld [wPlayerSpriteBaseAnimation], a

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

HandlePlayerMoveMode:
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

Func_c53d:
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wPlayerCurrentlyMoving]
	bit 0, a
	call nz, Func_c687
	ld a, [wPlayerCurrentlyMoving]
	bit 1, a
	call nz, Func_c6dc
	ret

Func_c554:
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

Func_c58b:
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

HandlePlayerMoveModeInput:
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

UpdatePlayerDirectionFromDPad:
	call GetDirectionFromDPad
UpdatePlayerDirection:
	ld [wPlayerDirection], a
	call UpdatePlayerSprite
	ret

GetDirectionFromDPad:
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

KeypadDirectionMap:
	db SOUTH, NORTH, WEST, EAST

; Updates sprite depending on direction
UpdatePlayerSprite:
	push bc
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wPlayerSpriteBaseAnimation]
	ld b, a
	ld a, [wPlayerDirection]
	add b
	farcall StartNewSpriteAnimation
	pop bc
	ret

AttemptPlayerMovementFromDirection:
	push bc
	call FindPlayerMovementFromDirection
	call AttemptPlayerMovement
	pop bc
	ret

StartScriptedMovement:
	push bc
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wd339]
	call FindPlayerMovementWithOffset
	call AttemptPlayerMovement
	pop bc
	ret

; bc is the location the player is being scripted to move towards.
AttemptPlayerMovement:
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

FindPlayerMovementFromDirection:
	ld a, [wPlayerDirection]

FindPlayerMovementWithOffset:
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

Func_c66c:
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

Func_c687:
	push bc
	ld a, [wd33a]
	ld c, a
	ld a, [wd339]
	call Func_c694
	pop bc
	ret

Func_c694:
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

Func_c6cc:
	push hl
	ld hl, wPlayerXCoordPixels
	add [hl]
	ld [hl], a
	pop hl
	ret

Func_c6d4:
	push hl
	ld hl, wPlayerYCoordPixels
	add [hl]
	ld [hl], a
	pop hl
	ret

Func_c6dc:
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

Func_c6f7:
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

Func_c70d:
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
FindNPCOrObject:
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

OpenPauseMenu:
	push hl
	push bc
	push de
	call PauseMenu
	call CloseAdvancedDialogueBox
	pop de
	pop bc
	pop hl
	ret

PauseMenu:
	call PauseSong
	ld a, MUSIC_PAUSE_MENU
	call PlaySong
	call DisplayPauseMenu
.loop
	ld a, 1 << AUTO_CLOSE_TEXTBOX
	call SetOverworldNPCFlags
.wait_input
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .wait_input
	ld a, e
	ld [wSelectedPauseMenuItem], a
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .exit
	cp $5
	jr z, .exit
	call Func_c2a3
	ld a, [wSelectedPauseMenuItem]
	ld hl, PauseMenuPointerTable
	call JumpToFunctionInTable
	ld hl, DisplayPauseMenu
	call ReturnToOverworldWithCallback
	jr .loop
.exit
	call ResumeSong
	ret

DisplayPauseMenu:
	ld a, [wSelectedPauseMenuItem]
	ld hl, Unknown_10d98
	farcall InitAndPrintMenu
	ret

PauseMenuPointerTable:
	dw PauseMenu_Status
	dw PauseMenu_Diary
	dw PauseMenu_Deck
	dw PauseMenu_Card
	dw PauseMenu_Config
	dw PauseMenu_Exit

PauseMenu_Status:
	farcall _PauseMenu_Status
	ret

PauseMenu_Diary:
	farcall _PauseMenu_Diary
	ret

PauseMenu_Deck:
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall SetDefaultPalettes
	farcall DeckSelectionMenu
	call Set_OBJ_8x8
	ret

PauseMenu_Card:
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall SetDefaultPalettes
	farcall HandlePlayersCardsScreen
	call Set_OBJ_8x8
	ret

PauseMenu_Config:
	farcall _PauseMenu_Config
	ret

PauseMenu_Exit:
	farcall _PauseMenu_Exit
	ret

PCMenu:
	ld a, MUSIC_PC_MAIN_MENU
	call PlaySong
	call Func_c241
	call Func_c915
	call DoFrameIfLCDEnabled
	ldtx hl, TurnedPCOnText
	call PrintScrollableText_NoTextBoxLabel
	call DisplayPCMenu
.loop
	ld a, 1 << AUTO_CLOSE_TEXTBOX
	call SetOverworldNPCFlags
.wait_input
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .wait_input
	ld a, e
	ld [wSelectedPCMenuItem], a
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .exit
	cp $4
	jr z, .exit
	call Func_c2a3
	ld a, [wSelectedPCMenuItem]
	ld hl, PointerTable_c846
	call JumpToFunctionInTable
	ld hl, DisplayPCMenu
	call ReturnToOverworldWithCallback
	jr .loop
.exit
	call CloseTextBox
	call DoFrameIfLCDEnabled
	ldtx hl, TurnedPCOffText
	call Func_c891
	call CloseAdvancedDialogueBox
	xor a
	ld [wSongOverride], a
	call PlayDefaultSong
	ret

PointerTable_c846:
	dw PCMenu_CardAlbum
	dw PCMenu_ReadMail
	dw PCMenu_Glossary
	dw PCMenu_Print

DisplayPCMenu:
	ld a, [wSelectedPCMenuItem]
	ld hl, Unknown_10da9
	farcall InitAndPrintMenu
	ret

PCMenu_CardAlbum:
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall SetDefaultPalettes
	farcall HandleCardAlbumScreen
	call Set_OBJ_8x8
	ret

PCMenu_ReadMail:
	farcall _PCMenu_ReadMail
	ret

PCMenu_Glossary:
	farcall _PCMenu_Glossary
	ret

PCMenu_Print:
	xor a
	ldh [hSCX], a
	ldh [hSCY], a
	call Set_OBJ_8x16
	farcall SetDefaultPalettes
	farcall HandlePrinterMenu
	call Set_OBJ_8x8
	call WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	ret

Func_c891:
	push hl
	ld a, [wOverworldNPCFlags]
	bit AUTO_CLOSE_TEXTBOX, a
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
	ld a, 1 << AUTO_CLOSE_TEXTBOX
	call SetOverworldNPCFlags
	call Func_c241
	call Func_c915
	call DoFrameIfLCDEnabled
	call PrintScrollableText_NoTextBoxLabel
	ret

Func_c8ba:
	ld a, e
	or d
	jr z, Func_c891
	push hl
	ld a, [wOverworldNPCFlags]
	bit AUTO_CLOSE_TEXTBOX, a
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
	ld a, 1 << AUTO_CLOSE_TEXTBOX
	call SetOverworldNPCFlags
	call Func_c241
	call Func_c915
	call DoFrameIfLCDEnabled
	call PrintScrollableText_WithTextBoxLabel
	ret

Func_c8ed:
	push hl
	push bc
	push de
	push hl
	ld a, 1 << AUTO_CLOSE_TEXTBOX
	call SetOverworldNPCFlags
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

Func_c915:
	push bc
	push de
	lb de, $00, $0c
	lb bc, $14, $06
	call AdjustCoordinatesForBGScroll
	call Func_c3ca
	pop de
	pop bc
	ret
