	INCROM $1c000, $1c056

Func_1c056: ; 1c056 (7:4056)
	push hl
	push bc
	push de
	ld a, [wCurMap]
	add a
	ld c, a
	ld b, $0
	ld hl, WarpDataPointers
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0005
	ld a, [wPlayerXCoord]
	ld d, a
	ld a, [wPlayerYCoord]
	ld e, a
.asm_1c072
	ld a, [hli]
	or [hl]
	jr z, .asm_1c095
	ld a, [hld]
	cp e
	jr nz, .asm_1c07e
	ld a, [hl]
	cp d
	jr z, .asm_1c081
.asm_1c07e
	add hl, bc
	jr .asm_1c072
.asm_1c081
	inc hl
	inc hl
	ld a, [hli]
	ld [wTempMap], a
	ld a, [hli]
	ld [wTempPlayerXCoord], a
	ld a, [hli]
	ld [wTempPlayerYCoord], a
	ld a, [wPlayerDirection]
	ld [wTempPlayerDirection], a
.asm_1c095
	pop de
	pop bc
	pop hl
	ret

INCLUDE "data/warps.asm"

; loads data from the map header of wCurMap
LoadMapHeader: ; 1c33b (7:433b)
	push hl
	push bc
	push de
	ld a, [wCurMap]
	add a
	ld c, a
	add a
	add c
	ld c, a
	ld b, 0
	ld hl, MapHeaders
	add hl, bc
	ld a, [hli]
	ld [wCurTilemap], a
	ld a, [hli]
	ld c, a ; CGB tilemap variant
	ld a, [hli]
	ld [wd28f], a
	ld a, [hli]
	ld [wd132], a
	ld a, [hli]
	ld [wd290], a
	ld a, [hli]
	ld [wDefaultSong], a

	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .got_tilemap
	; use CGB variant, if valid
	ld a, c
	or a
	jr z, .got_tilemap
	ld [wCurTilemap], a
.got_tilemap

	pop de
	pop bc
	pop hl
	ret

INCLUDE "data/map_headers.asm"

ClearNPCs: ; 1c440 (7:4440)
	push hl
	push bc
	ld hl, wLoadedNPCs
	ld c, LOADED_NPC_MAX * LOADED_NPC_LENGTH
	xor a
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ld [wNumLoadedNPCs], a
	ld [wRonaldIsInMap], a
	pop bc
	pop hl
	ret
; 0x1c455

GetNPCDirection: ; 1c455 (7:4455)
	push hl
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	ld a, [hl]
	pop hl
	ret

; sets new position to active NPC
; and updates its tile permissions
; bc = new coords
SetNPCPosition: ; 1c461 (7:4461)
	push hl
	push bc
	call UpdateNPCsTilePermission
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_COORD_X
	call GetItemInLoadedNPCIndex
	ld a, b
	ld [hli], a
	ld [hl], c
	call SetNPCsTilePermission
	pop bc
	pop hl
	ret

GetNPCPosition: ; 1c477 (7:4477)
	push hl
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_COORD_X
	call GetItemInLoadedNPCIndex
	ld a, [hli]
	ld b, a
	ld c, [hl]
	pop hl
	ret

; Loads NPC Sprite Data
LoadNPC: ; 1c485 (7:4485)
	push hl
	push bc
	push de
	xor a
	ld [wLoadedNPCTempIndex], a
	ld b, a
	ld c, LOADED_NPC_MAX
	ld hl, wLoadedNPCs
	ld de, LOADED_NPC_LENGTH
.findEmptyIndexLoop
	ld a, [hl]
	or a
	jr z, .foundEmptyIndex
	add hl, de
	inc b
	dec c
	jr nz, .findEmptyIndexLoop
	ld hl, wLoadedNPCs
	debug_nop
	jr .exit
.foundEmptyIndex
	ld a, b
	ld [wLoadedNPCTempIndex], a
	ld a, [wNPCSpriteID]
	farcall CreateSpriteAndAnimBufferEntry
	jr c, .exit
	ld a, [wLoadedNPCTempIndex]
	call GetLoadedNPCID
	push hl
	ld a, [wTempNPC]
	ld [hli], a
	ld a, [wWhichSprite]
	ld [hli], a
	ld a, [wLoadNPCXPos]
	ld [hli], a
	ld a, [wLoadNPCYPos]
	ld [hli], a
	ld a, [wLoadNPCDirection]
	ld [hli], a
	ld a, [wNPCAnimFlags]
	ld [hli], a
	ld a, [wNPCAnim]
	ld [hli], a
	ld a, [wLoadNPCDirection]
	ld [hli], a
	call UpdateNPCAnimation
	call ApplyRandomCountToNPCAnim
	ld hl, wNumLoadedNPCs
	inc [hl]
	pop hl

	call UpdateNPCSpritePosition
	call SetNPCsTilePermission

	ld a, [wTempNPC]
	call CheckIfNPCIsRonald
	jr nc, .exit
	ld a, TRUE
	ld [wRonaldIsInMap], a
.exit
	pop de
	pop bc
	pop hl
	ret

; returns carry if input NPC ID in register a is Ronald
CheckIfNPCIsRonald: ; 1c4fa (7:44fa)
	cp NPC_RONALD1
	jr z, .set_carry
	cp NPC_RONALD2
	jr z, .set_carry
	cp NPC_RONALD3
	jr z, .set_carry
	or a
	ret
.set_carry
	scf
	ret

UnloadNPC: ; 1c50a (7:450a)
	push hl
	call UpdateNPCsTilePermission
	ld a, [wLoadedNPCTempIndex]
	call GetLoadedNPCID
	ld a, [hl]
	or a
	jr z, .exit
	call CheckIfNPCIsRonald
	jr nc, .not_ronald
	xor a ; FALSE
	ld [wRonaldIsInMap], a
.not_ronald

	xor a
	ld [hli], a
	ld a, [hl]
	farcall DisableSpriteAnim
	ld hl, wNumLoadedNPCs
	dec [hl]

.exit
	pop hl
	ret

Func_1c52e: ; 1c52e (7:452e)
	push hl
	push af
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_UNKNOWN
	call GetItemInLoadedNPCIndex
	pop af
	ld [hl], a
	call Func_1c5e9
	pop hl
	ret

Func_1c53f: ; 1c53f (7:453f)
	push hl
	push bc
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	ld a, [hl]
	ld bc, LOADED_NPC_UNKNOWN - LOADED_NPC_DIRECTION
	add hl, bc
	ld [hl], a
	push af
	call Func_1c5e9
	pop af
	pop bc
	pop hl
	ret

Func_1c557: ; 1c557 (7:4557)
	push bc
	ld c, a
	ld a, [wLoadedNPCTempIndex]
	push af
	ld a, [wTempNPC]
	push af
	ld a, c
	ld [wTempNPC], a
	ld c, $0
	call FindLoadedNPC
	jr c, .asm_1c570
	call Func_1c53f
	ld c, a

.asm_1c570
	pop af
	ld [wTempNPC], a
	pop af
	ld [wLoadedNPCTempIndex], a
	ld a, c
	pop bc
	ret

; a = NPC animation
SetNPCAnimation: ; 1c57b (7:457b)
	push hl
	push bc
	push af
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_ANIM
	call GetItemInLoadedNPCIndex
	pop af
	ld [hl], a
	call UpdateNPCAnimation
	pop bc
	pop hl
	ret

UpdateNPCAnimation: ; 1c58e (7:458e)
	push hl
	push bc
	ld a, [wWhichSprite]
	push af
	ld a, [wLoadedNPCTempIndex]
	call GetLoadedNPCID
	ld a, [hli]
	or a
	jr z, .quit
	ld a, [hl]
	ld [wWhichSprite], a
	ld bc, LOADED_NPC_ANIM - LOADED_NPC_SPRITE
	add hl, bc
	ld a, [hld] ; LOADED_NPC_ANIM
	bit NPC_FLAG_DIRECTIONLESS_F, [hl] ; LOADED_NPC_FLAGS
	jr nz, .asm_1c5ae
	dec hl
	add [hl] ; LOADED_NPC_ANIM + LOADED_NPC_DIRECTION
	inc hl
.asm_1c5ae
	farcall StartNewSpriteAnimation
.quit
	pop af
	ld [wWhichSprite], a
	pop bc
	pop hl
	ret
; 0x1c5b9

; if NPC's sprite has an animation,
; give it a random initial value
; this makes it so that all NPCs are out of phase
; when they are loaded into a map
ApplyRandomCountToNPCAnim: ; 1c5b9 (7:45b9)
	push hl
	push bc
	ld a, [wWhichSprite]
	push af
	ld a, [wLoadedNPCTempIndex]
	call GetLoadedNPCID
	ld a, [hli]
	or a
	jr z, .done
	ld a, [hl]
	ld [wWhichSprite], a
	ld c, SPRITE_ANIM_COUNTER
	call GetSpriteAnimBufferProperty
	ld a, [hl]
	or a
	jr z, .done
	cp $ff
	jr z, .done
	dec a
	call Random
	ld c, a
	ld a, [hl]
	sub c
	ld [hl], a
.done
	pop af
	ld [wWhichSprite], a
	pop bc
	pop hl
	ret
; 0x1c5e9

; sets the loaded NPC's direction
; to the direction that is in LOADED_NPC_UNKNOWN
Func_1c5e9: ; 1c5e9 (7:45e9)
	push hl
	push bc
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_UNKNOWN
	call GetItemInLoadedNPCIndex
	ld a, [hl]
	ld bc, LOADED_NPC_DIRECTION - LOADED_NPC_UNKNOWN
	add hl, bc
	ld [hl], a
	call UpdateNPCAnimation
	pop bc
	pop hl
	ret
; 0x1c5ff

; a = new direction
SetNPCDirection: ; 1c5ff (7:45ff)
	push hl
	push af
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	pop af
	ld [hl], a
	call UpdateNPCAnimation
	pop hl
	ret
; 0x1c610

HandleAllNPCMovement: ; 1c610 (7:4610)
	push hl
	push bc
	push de
	xor a
	ld [wIsAnNPCMoving], a
	ld a, [wNumLoadedNPCs]
	or a
	jr z, .exit

	ld c, LOADED_NPC_MAX
	ld hl, wLoadedNPCs
	ld de, LOADED_NPC_LENGTH
.loop_npcs
	ld a, [hl]
	or a
	jr z, .next_npc
	push bc
	inc hl
	ld a, [hld]
	ld [wWhichSprite], a
	call UpdateNPCMovementStep
	call .UpdateSpriteAnimFlag
	call UpdateNPCSpritePosition
	call UpdateIsAnNPCMovingFlag
	pop bc
.next_npc
	add hl, de
	dec c
	jr nz, .loop_npcs
.exit
	pop de
	pop bc
	pop hl
	ret

.UpdateSpriteAnimFlag
	push hl
	push bc
	ld bc, LOADED_NPC_COORD_X
	add hl, bc
	ld b, [hl]
	inc hl
	ld c, [hl]
	call GetPermissionOfMapPosition
	and $10
	push af
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	pop af
	ld a, [hl]
	jr z, .reset_flag
	set SPRITE_ANIM_FLAG_UNSKIPPABLE, [hl]
	jr .done
.reset_flag
	res SPRITE_ANIM_FLAG_UNSKIPPABLE, [hl]
.done
	pop bc
	pop hl
	ret
; 0x1c665

UpdateNPCSpritePosition: ; 1c665 (7:4665)
	push hl
	push bc
	push de
	call .GetOffset

	; get NPC and sprite coords
	push bc
	ld de, LOADED_NPC_COORD_X
	add hl, de
	ld e, l
	ld d, h
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	pop bc

	; hl = sprite coords
	; de = NPC coords
	ld a, [de] ; x
	sla a
	sla a
	sla a
	add $8
	sub b
	ld [hli], a
	inc de
	ld a, [de] ; y
	sla a
	sla a
	sla a
	add $10
	sub c
	ld [hli], a
	pop de
	pop bc
	pop hl
	ret

; outputs in bc the coordinate offsets
; given NPCs direction and its movement step
.GetOffset
	push hl
	ld bc, $0
	ld de, LOADED_NPC_FLAGS
	add hl, de
	ld e, 0
	ld a, [hl]
	and NPC_FLAG_MOVING
	jr z, .got_direction
	dec hl
	ld a, [hl] ; LOADED_NPC_DIRECTION
	ld de, LOADED_NPC_MOVEMENT_STEP - LOADED_NPC_DIRECTION
	add hl, de
	ld e, [hl] ; LOADED_NPC_MOVEMENT_STEP
.got_direction
	ld hl, .function_table
	call JumpToFunctionInTable
	pop hl
	ret

.function_table
	dw .north
	dw .east
	dw .south
	dw .west

.west
	ld a, e
	cpl
	inc a
	ld e, a
.east
	ld b, e
	ldh a, [hSCX]
	sub b
	ld b, a
	ldh a, [hSCY]
	ld c, a
	ret

.north
	ld a, e
	cpl
	inc a
	ld e, a
.south
	ld c, e
	ldh a, [hSCY]
	sub c
	ld c, a
	ldh a, [hSCX]
	ld b, a
	ret
; 0x1c6d3

; ands wIsAnNPCMoving with the current
; NPC's NPC_FLAG_MOVING_F
UpdateIsAnNPCMovingFlag: ; 1c6d3 (7:46d3)
	push hl
	push bc
	ld bc, LOADED_NPC_FLAGS
	add hl, bc
	ld a, [wIsAnNPCMoving]
	or [hl]
	ld [wIsAnNPCMoving], a
	pop bc
	pop hl
	ret
; 0x1c6e3

SetNPCsTilePermission: ; 1c6e3 (7:46e3)
	push hl
	push bc
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_COORD_X
	call GetItemInLoadedNPCIndex
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, $40
	call SetPermissionOfMapPosition
	pop bc
	pop hl
	ret

SetAllNPCTilePermissions: ; 1c6f8 (7:46f8)
	push hl
	push bc
	push de
	ld b, $00
	ld c, LOADED_NPC_MAX
	ld hl, wLoadedNPCs
	ld de, LOADED_NPC_LENGTH
.loop_npcs
	ld a, [hl]
	or a
	jr z, .next_npc
	ld a, b
	ld [wLoadedNPCTempIndex], a
	call SetNPCsTilePermission
.next_npc
	add hl, de
	inc b
	dec c
	jr nz, .loop_npcs
	pop de
	pop bc
	pop hl
	ret
; 0x1c719

UpdateNPCsTilePermission: ; 1c719 (7:4719)
	push hl
	push bc
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_COORD_X
	call GetItemInLoadedNPCIndex
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, $40
	call UpdatePermissionOfMapPosition
	pop bc
	pop hl
	ret

; Find NPC at coords b (x) c (y)
FindNPCAtLocation: ; 1c72e (7:472e)
	push hl
	push bc
	push de
	ld d, $00
	ld e, LOADED_NPC_MAX
	ld hl, wLoadedNPC1CoordX
.findValidNPCLoop
	ld a, [hli]
	cp b
	jr nz, .noValidNPCHere
	ld a, [hl]
	cp c
	jr nz, .noValidNPCHere
	push hl
	inc hl
	inc hl
	bit 6, [hl]
	pop hl
	jr nz, .noValidNPCHere
	push hl
	dec hl
	dec hl
	ld a, [hl]
	or a
	pop hl
	jr nz, .foundNPCExit
.noValidNPCHere
	ld a, LOADED_NPC_LENGTH - 1
	add l
	ld l, a
	ld a, h
	adc $00
	ld h, a
	inc d
	dec e
	jr nz, .findValidNPCLoop
	scf
	jr .exit
.foundNPCExit
	ld a, d
	ld [wLoadedNPCTempIndex], a
	or a
.exit
	pop de
	pop bc
	pop hl
	ret

; Probably needs a new name. Loads data for NPC that the next Script is for
; Sets direction, Loads Image data for it, loads name, and more
SetNewScriptNPC: ; 1c768 (7:4768)
	push hl
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	ld a, [wPlayerDirection]
	xor $02
	ld [hl], a
	call UpdateNPCAnimation
	ld a, $02
	farcall Func_c29b
	ld a, [wLoadedNPCTempIndex]
	call GetLoadedNPCID
	ld a, [hl]
	farcall GetNPCNameAndScript
	pop hl
	ret

StartNPCMovement: ; 1c78d (7:478d)
	push hl
; set NPC as moving
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_FLAGS
	call GetItemInLoadedNPCIndex
	set NPC_FLAG_MOVING_F, [hl]

; reset its movement step
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_MOVEMENT_STEP
	call GetItemInLoadedNPCIndex
	xor a
	ld [hli], a
.loop_movement
	ld [hl], c ; LOADED_NPC_MOVEMENT_PTR
	inc hl
	ld [hl], b
	dec hl
	call GetNextNPCMovementByte
	cp $f0
	jr nc, .special_command
	push af
	and DIRECTION_MASK
	call SetNPCDirection
	pop af
	; if it was not a rotation, exit...
	bit 7, a
	jr z, .exit
	; ...otherwise jump to next movement instruction
	inc bc
	jr .loop_movement

.special_command
	cp $ff
	jr z, .stop_movement
; jump to a movement command
	; read its argument
	inc bc
	call GetNextNPCMovementByte
	push hl
	ld l, a
	ld h, $0
	bit 7, l
	jr z, .got_offset
	dec h ; $ff
.got_offset
	; add the offset to bc
	add hl, bc
	ld c, l
	ld b, h
	pop hl
	jr .loop_movement

.stop_movement
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_FLAGS
	call GetItemInLoadedNPCIndex
	res NPC_FLAG_MOVING_F, [hl]

.exit
	pop hl
	ret

; returns nz if there is an NPC currently moving
CheckIsAnNPCMoving: ; 1c7de (7:47de)
	ld a, [wIsAnNPCMoving]
	and NPC_FLAG_MOVING
	ret
; 0x1c7e4

; while the NPC is moving, increment its movement step by 1
; once it reaches a value greater than 16, update
; its tile permission and its position and start next movement
UpdateNPCMovementStep: ; 1c7e4 (7:47e4)
	push hl
	push bc
	push de
	ld bc, LOADED_NPC_FLAGS
	add hl, bc
	bit NPC_FLAG_MOVING_F, [hl]
	jr z, .exit
	ld bc, LOADED_NPC_MOVEMENT_STEP - LOADED_NPC_FLAGS
	add hl, bc
	inc [hl] ; increment movement step
	bit 4, [hl]
	jr z, .exit ; still hasn't reached the next tile
	call UpdateNPCsTilePermission
	call UpdateNPCPosition
	inc hl
	ld c, [hl] ; LOADED_NPC_MOVEMENT_PTR
	inc hl
	ld b, [hl]
	inc bc
	call StartNPCMovement
	call SetNPCsTilePermission
.exit
	pop de
	pop bc
	pop hl
	ret
; 0x1c80d

UpdateNPCPosition: ; 1c80d (7:480d)
	push hl
	push bc
	ld a, [wLoadedNPCTempIndex]
	ld l, LOADED_NPC_DIRECTION
	call GetItemInLoadedNPCIndex
	ld a, [hld]
	push hl
	rlca ; *2
	ld c, a
	ld b, $00
	ld hl, PlayerMovementOffsetTable_Tiles
	add hl, bc
	ld b, [hl] ; x offset
	inc hl
	ld c, [hl] ; y offset
	pop hl
	ld a, [hl] ; LOADED_NPC_COORD_Y
	add c
	ld [hld], a
	ld a, [hl] ; LOADED_NPC_COORD_X
	add b
	ld [hl], a
	pop bc
	pop hl
	ret
; 0x1c82e

ClearMasterBeatenList: ; 1c82e (7:482e)
	push hl
	push bc
	ld c, $a
	ld hl, wMastersBeatenList
	xor a
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	pop bc
	pop hl
	ret
; 0x1c83d

; writes Master in register a to
; first empty slot in wMastersBeatenList
AddMasterBeatenToList: ; 1c83d (7:483d)
	push hl
	push bc
	ld b, a
	ld c, $a
	ld hl, wMastersBeatenList
.loop
	ld a, [hl]
	or a
	jr z, .found_empty_slot
	cp b
	jr z, .exit
	inc hl
	dec c
	jr nz, .loop
	debug_nop
	jr .exit

.found_empty_slot
	ld a, b
	ld [hl], a

.exit
	pop bc
	pop hl
	ret

; iterates all masters and attempts to
; add each of them to wMastersBeatenList
AddAllMastersToMastersBeatenList: ; 1c858 (7:4858)
	ld a, $01
.loop
	push af
	call AddMasterBeatenToList
	pop af
	inc a
	cp $0b
	jr c, .loop
	ret
; 0x1c865

	INCROM $1c865, $1c8bc

Func_1c8bc: ; 1c8bc (7:48bc)
	push hl
	push bc
	call Set_OBJ_8x8
	ld a, LOW(Func_3ba2)
	ld [wDoFrameFunction], a
	ld a, HIGH(Func_3ba2)
	ld [wDoFrameFunction + 1], a
	ld a, $ff
	ld hl, wAnimationQueue
	ld c, ANIMATION_QUEUE_LENGTH
.fill_queue
	ld [hli], a
	dec c
	jr nz, .fill_queue
	ld [wd42a], a
	ld [wd4c0], a
	xor a
	ld [wDuelAnimBufferCurPos], a
	ld [wDuelAnimBufferSize], a
	ld [wd4b3], a
	call DefaultScreenAnimationUpdate
	call Func_3ca0
	pop bc
	pop hl
	ret
; 0x1c8ef

PlayLoadedDuelAnimation: ; 1c8ef (7:48ef)
	ld a, [wDoFrameFunction + 0]
	cp LOW(Func_3ba2)
	jr nz, .error
	ld a, [wDoFrameFunction + 1]
	cp HIGH(Func_3ba2)
	jr z, .okay
.error
	debug_nop
	ret

.okay
	ld a, [wTempAnimation]
	ld [wd4bf], a
	cp DUEL_SPECIAL_ANIMS
	jp nc, Func_1cb5e

	push hl
	push bc
	push de
	call GetAnimationData
; hl: pointer

	ld a, [wAnimationsDisabled]
	or a
	jr z, .check_to_play_sfx
	; animations are disabled
	push hl
	ld bc, ANIM_SPRITE_ANIM_FLAGS
	add hl, bc
	ld a, [hl]
	; if flag is set, play animation anyway
	and (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE)
	pop hl
	jr z, .return

.check_to_play_sfx
	push hl
	ld bc, ANIM_SOUND_FX_ID
	add hl, bc
	ld a, [hl]
	pop hl
	or a
	jr z, .calc_addr
	call PlaySFX

.calc_addr
; this data field is always $00,
; so this calculation is unnecessary
; seems like there was supposed to be
; more than 1 function to handle animation
	push hl
	ld bc, ANIM_HANDLER_FUNCTION
	add hl, bc
	ld a, [hl]
	rlca
	add LOW(.address) ; $48
	ld l, a ; LO
	ld a, HIGH(.address) ; $49
	adc 0
	ld h, a ; HI
; hl: pointer
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl

	call CallBC
.return
	pop de
	pop bc
	pop hl
	ret

.address
	dw .handler_func

.handler_func ; 1c94a (7:494a)
; if any of ANIM_SPRITE_ID, ANIM_PALETTE_ID and ANIM_SPRITE_ANIM_ID
; are 0, then return
	ld e, l
	ld d, h
	ld c, ANIM_SPRITE_ANIM_ID + 1
.loop
	ld a, [de]
	or a
	jr z, .return_with_carry
	inc de
	dec c
	jr nz, .loop

	ld a, [hli] ; ANIM_SPRITE_ID
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [wAnimationQueue], a ; push an animation to the queue

	xor a
	ld [wVRAMTileOffset], a
	ld [wd4cb], a

	ld a, [hli] ; ANIM_PALETTE_ID
	farcall LoadPaletteData
	ld a, [hli] ; ANIM_SPRITE_ANIM_ID

	push af
	ld a, [hli] ; ANIM_SPRITE_ANIM_FLAGS
	ld [wAnimFlags], a
	call LoadAnimCoordsAndFlags
	pop af

	farcall StartNewSpriteAnimation
	or a
	jr .done

.return_with_carry
	scf
.done
	ret

; loads the correct coordinates/flags for
; sprite animation in wAnimationQueue
LoadAnimCoordsAndFlags: ; 1c980 (7:4980)
	push hl
	push bc
	ld a, [wAnimationQueue]
	ld c, SPRITE_ANIM_ATTRIBUTES
	call GetSpriteAnimBufferProperty_SpriteInA
	call GetAnimCoordsAndFlags

	push af
	and (1 << SPRITE_ANIM_FLAG_6) | (1 << SPRITE_ANIM_FLAG_5)
	or [hl]
	ld [hli], a
	ld a, b
	ld [hli], a ; SPRITE_ANIM_COORD_X
	ld [hl], c ; SPRITE_ANIM_COORD_Y
	pop af

	ld bc, SPRITE_ANIM_FLAGS - SPRITE_ANIM_COORD_Y
	add hl, bc
	ld c, a ; useless
	and (1 << SPRITE_ANIM_FLAG_Y_SUBTRACT) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT)
	or [hl]
	ld [hl], a
	pop bc
	pop hl
	ret

; outputs x and y coordinates for the sprite animation
; taking into account who the turn duelist is.
; also returns in a the allowed animation flags of
; the configuration that is selected.
; output:
; a = anim flags
; b = x coordinate
; c = y coordinate
GetAnimCoordsAndFlags: ; 1c9a2 (7:49a2)
	push hl
	ld c, 0
	ld a, [wAnimFlags]
	and (1 << SPRITE_ANIM_FLAG_SPEED)
	jr nz, .calc_addr

	ld a, [wDuelAnimationScreen]
	add a ; 2 * [wDuelAnimationScreen]
	ld c, a
	add a ; 4 * [wDuelAnimationScreen]
	add c ; 6 * [wDuelAnimationScreen]
	add a ; 12 * [wDuelAnimationScreen]
	ld c, a

	ld a, [wDuelAnimDuelistSide]
	cp PLAYER_TURN
	jr z, .player_side
; opponent side
	ld a, 6
	add c
	ld c, a
.player_side
	ld a, [wDuelAnimLocationParam]
	add c ; a = [wDuelAnimLocationParam] + c
	ld c, a
	ld b, 0
	ld hl, AnimationCoordinatesIndex
	add hl, bc
	ld c, [hl]

.calc_addr
	ld a, c
	add a ; a = c * 2
	add c ; a = c * 3
	ld c, a
	ld b, 0
	ld hl, AnimationCoordinates
	add hl, bc
	ld b, [hl] ; x coord
	inc hl
	ld c, [hl] ; y coord
	inc hl
	ld a, [wAnimFlags]
	and [hl] ; flags
	pop hl
	ret

AnimationCoordinatesIndex:
; animations in the Duel Main Scene
	db $01, $01, $01, $01, $01, $01 ; player
	db $02, $02, $02, $02, $02, $02 ; opponent

; animations in the Player's Play Area, for each Play Area Pokemon
	db $03, $04, $05, $06, $07, $08 ; player
	db $03, $04, $05, $06, $07, $08 ; opponent

; animations in the Opponent's Play Area, for each Play Area Pokemon
	db $09, $0a, $0b, $0c, $0d, $0e ; player
	db $09, $0a, $0b, $0c, $0d, $0e ; opponent

anim_coords: MACRO
	db \1
	db \2
	db \3
ENDM

AnimationCoordinates:
; x coord, y coord, animation flags
	anim_coords 88,  88, (1 << SPRITE_ANIM_FLAG_3)

; animations in the Duel Main Scene
	anim_coords 40,  80, $00
	anim_coords 136, 48, (1 << SPRITE_ANIM_FLAG_6) | (1 << SPRITE_ANIM_FLAG_5) | (1 << SPRITE_ANIM_FLAG_Y_SUBTRACT) | (1 << SPRITE_ANIM_FLAG_X_SUBTRACT)

; animations in the Player's Play Area, for each Play Area Pokemon
	anim_coords 88,  72, $00
	anim_coords 24,  96, $00
	anim_coords 56,  96, $00
	anim_coords 88,  96, $00
	anim_coords 120, 96, $00
	anim_coords 152, 96, $00

; animations in the Opponent's Play Area, for each Play Area Pokemon
	anim_coords 88,  80, $00
	anim_coords 152, 40, $00
	anim_coords 120, 40, $00
	anim_coords 88,  40, $00
	anim_coords 56,  40, $00
	anim_coords 24,  40, $00

; appends to end of wDuelAnimBuffer
; the current duel animation
LoadDuelAnimationToBuffer: ; 1ca31 (7:4a31)
	push hl
	push bc
	ld a, [wDuelAnimBufferCurPos]
	ld b, a
	ld hl, wDuelAnimBufferSize
	ld a, [hl]
	ld c, a
	add DUEL_ANIM_STRUCT_SIZE
	and %01111111
	cp b
	jp z, .skip
	ld [hl], a

	ld b, $00
	ld hl, wDuelAnimBuffer
	add hl, bc
	ld a, [wTempAnimation]
	ld [hli], a
	ld a, [wDuelAnimationScreen]
	ld [hli], a
	ld a, [wDuelAnimDuelistSide]
	ld [hli], a
	ld a, [wDuelAnimLocationParam]
	ld [hli], a
	ld a, [wDuelAnimDamage]
	ld [hli], a
	ld a, [wDuelAnimDamage + 1]
	ld [hli], a
	ld a, [wd4b3]
	ld [hli], a
	ld a, [wDuelAnimReturnBank]
	ld [hl], a

.skip
	pop bc
	pop hl
	ret

; loads the animations from wDuelAnimBuffer
; in acending order, starting at wDuelAnimBufferCurPos
PlayBufferedDuelAnimations: ; 1ca6e (7:4a6e)
	push hl
	push bc
.next_duel_anim
	ld a, [wDuelAnimBufferSize]
	ld b, a
	ld a, [wDuelAnimBufferCurPos]
	cp b
	jr z, .skip

	ld c, a
	add DUEL_ANIM_STRUCT_SIZE
	and %01111111
	ld [wDuelAnimBufferCurPos], a

	ld b, $00
	ld hl, wDuelAnimBuffer
	add hl, bc
	ld a, [hli]
	ld [wTempAnimation], a
	ld a, [hli]
	ld [wDuelAnimationScreen], a
	ld a, [hli]
	ld [wDuelAnimDuelistSide], a
	ld a, [hli]
	ld [wDuelAnimLocationParam], a
	ld a, [hli]
	ld [wDuelAnimDamage], a
	ld a, [hli]
	ld [wDuelAnimDamage + 1], a
	ld a, [hli]
	ld [wd4b3], a
	ld a, [hl]
	ld [wDuelAnimReturnBank], a

	call PlayLoadedDuelAnimation
	call CheckAnyAnimationPlaying
	jr nc, .next_duel_anim

.skip
	pop bc
	pop hl
	ret
; 0x1cab3

; gets data from Animations for anim ID in a
; outputs the pointer to the data in hl
GetAnimationData: ; 1cab3 (7:4ab3)
	push bc
	ld a, [wTempAnimation]
	ld l, a
	ld h, 0
	add hl, hl ; hl = anim * 2
	ld b, h
	ld c, l
	add hl, hl ; hl = anim * 4
	add hl, bc ; hl = anim * 6
	ld bc, Animations
	add hl, bc
	pop bc
	ret

Func_1cac5: ; 1cac5 (7:4ac5)
	ld a, [wd42a]
	cp $ff
	jr nz, .asm_1cb03

	ld a, [wd4c0]
	or a
	jr z, .asm_1cafb
	cp $80
	jr z, .asm_1cb11
	ld hl, wAnimationQueue
	ld c, ANIMATION_QUEUE_LENGTH
.loop_queue
	push af
	push bc
	ld a, [hl]
	cp $ff
	jr z, .next
	ld [wWhichSprite], a
	farcall GetSpriteAnimCounter
	cp $ff
	jr nz, .next
	farcall DisableCurSpriteAnim
	ld a, $ff
	ld [hl], a

.next
	pop bc
	pop af
	and [hl]
	inc hl
	dec c
	jr nz, .loop_queue

.asm_1cafb
	cp $ff
	jr nz, .skip_play_anims
	call PlayBufferedDuelAnimations
.skip_play_anims
	ret

.asm_1cb03
	ld hl, wScreenAnimUpdatePtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CallHL2
	ld a, [wd42a]
	jr .asm_1cafb

.asm_1cb11
	ld a, $ff
	ld [wd4c0], a
	jr .asm_1cafb
; 0x1cb18

Func_1cb18: ; 1cb18 (7:4b18)
	push hl
	push bc
	push de
	ld a, [wDoFrameFunction]
	cp LOW(Func_3ba2)
	jr nz, .asm_1cb5b
	ld a, [wDoFrameFunction + 1]
	cp HIGH(Func_3ba2)
	jr nz, .asm_1cb5b
	ld a, $ff
	ld [wd4c0], a
	ld a, [wd42a]
	cp $ff
	call nz, Func_1ccd4
	ld hl, wAnimationQueue
	ld c, $07
.asm_1cb3b
	push bc
	ld a, [hl]
	cp $ff
	jr z, .asm_1cb4b
	ld [wWhichSprite], a
	farcall DisableCurSpriteAnim
	ld a, $ff
	ld [hl], a
.asm_1cb4b
	pop bc
	inc hl
	dec c
	jr nz, .asm_1cb3b
	xor a
	ld [wDuelAnimBufferCurPos], a
	ld [wDuelAnimBufferSize], a
.asm_1cb57
	pop de
	pop bc
	pop hl
	ret
.asm_1cb5b
	scf
	jr .asm_1cb57
; 0x1cb5e

Func_1cb5e: ; 1cb5e (7:4b5e)
	cp $96
	jp nc, Func_1ce03
	cp $8c
	jp nz, InitScreenAnimation
	jr .asm_1cb6a ; redundant
.asm_1cb6a
	ld a, [wDuelAnimDamage + 1]
	cp $03
	jr nz, .asm_1cb76
	ld a, [wDuelAnimDamage]
	cp $e8
.asm_1cb76
	ret nc

	xor a
	ld [wd4b8], a
	ld [wVRAMTileOffset], a
	ld [wd4cb], a

	ld a, $25
	farcall LoadPaletteData
	call Func_1cba6

	ld hl, wd4b3
	bit 0, [hl]
	call nz, Func_1cc3e

	ld a, $12
	ld [wd4b8], a
	bit 1, [hl]
	call nz, Func_1cc4e

	bit 2, [hl]
	call nz, Func_1cc66

	xor a
	ld [wd4b3], a
	ret
; 0x1cba6

Func_1cba6: ; 1cba6 (7:4ba6)
	call Func_1cc03
	xor a
	ld [wd4b7], a

	ld hl, wd4b4
	ld de, wAnimationQueue + 1
.asm_1cbb3
	push hl
	push de
	ld a, [hl]
	or a
	jr z, .asm_1cbbc
	call Func_1cbcc

.asm_1cbbc
	pop de
	pop hl
	inc hl
	inc de
	ld a, [wd4b7]
	inc a
	ld [wd4b7], a
	cp $03
	jr c, .asm_1cbb3
	ret
; 0x1cbcc

Func_1cbcc: ; 1cbcc (7:4bcc)
	push af
	ld a, SPRITE_DUEL_4
	farcall CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [de], a
	ld a, (1 << SPRITE_ANIM_FLAG_UNSKIPPABLE)
	ld [wAnimFlags], a
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	call GetAnimCoordsAndFlags

	ld a, [wd4b7]
	add -3
	ld e, a
	ld a, $4b
	adc 0
	ld d, a
	ld a, [de]
	add b

	ld [hli], a ; SPRITE_ANIM_COORD_X
	ld [hl], c ; SPRITE_ANIM_COORD_Y

	ld a, [wd4b8]
	ld c, a
	pop af
	farcall Func_12ac9
	ret
; 0x1cbfd

	INCROM $1cbfd, $1cc03

Func_1cc03: ; 1cc03 (7:4c03)
	ld a, [wDuelAnimDamage]
	ld l, a
	ld a, [wDuelAnimDamage + 1]
	ld h, a

	ld de, wd4b4
	ld bc, -100
	call .Func_1cc2f
	ld bc, -10
	call .Func_1cc2f

	ld a, l
	add $4f
	ld [de], a
	ld hl, wd4b4
	ld c, 2
.asm_1cc23
	ld a, [hl]
	cp $4f
	jr nz, .asm_1cc2e
	ld [hl], $00
	inc hl
	dec c
	jr nz, .asm_1cc23
.asm_1cc2e
	ret
; 0x1cc2f

.Func_1cc2f
	ld a, $4e
.loop
	inc a
	add hl, bc
	jr c, .loop

	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret
; 0x1cc3e

Func_1cc3e: ; 1cc3e (7:4c3e)
	push hl
	ld a, $03
	ld [wd4b7], a
	ld de, wAnimationQueue + 4
	ld a, $5b
	call Func_1cbcc
	pop hl
	ret
; 0x1cc4e

Func_1cc4e: ; 1cc4e (7:4c4e)
	push hl
	ld a, $04
	ld [wd4b7], a
	ld de, wAnimationQueue + 5
	ld a, $5a
	call Func_1cbcc
	ld a, [wd4b8]
	add $12
	ld [wd4b8], a
	pop hl
	ret
; 0x1cc66

Func_1cc66: ; 1cc66 (7:4c66)
	push hl
	ld a, $05
	ld [wd4b7], a
	ld de, wAnimationQueue + 6
	ld a, $59
	call Func_1cbcc
	pop hl
	ret
; 0x1cc76

; initializes a screen animation from wTempAnimation
; loads a function pointer for updating a frame
; and initializes the duration of the animation.
InitScreenAnimation: ; 1cc76 (7:4c76)
	ld a, [wAnimationsDisabled]
	or a
	jr nz, .skip
	ld a, [wTempAnimation]
	ld [wd42a], a
	sub DUEL_SCREEN_ANIMS
	add a
	add a
	ld c, a
	ld b, $00
	ld hl, Data_1cc9f
	add hl, bc
	ld a, [hli]
	ld [wScreenAnimUpdatePtr], a
	ld c, a
	ld a, [hli]
	ld [wScreenAnimUpdatePtr + 1], a
	ld b, a
	ld a, [hl]
	ld [wScreenAnimDuration], a
	call CallBC
.skip
	ret
; 0x1cc9f

; for the following animations, these functions
; are run with the corresponding duration.
; this duration decides different effects,
; depending on which function runs
; and is decreased by one each time.
; when it is down to 0, the animation is done.

screen_effect: MACRO
	dw \1 ; function pointer
	db \2 ; duration
	db $00 ; padding
ENDM

Data_1cc9f: ; 1cc9f (7:4c9f)
; function pointer, duration
	screen_effect ShakeScreenX_Small, 24 ; DUEL_ANIM_SMALL_SHAKE_X
	screen_effect ShakeScreenX_Big,   32 ; DUEL_ANIM_BIG_SHAKE_X
	screen_effect ShakeScreenY_Small, 24 ; DUEL_ANIM_SMALL_SHAKE_Y
	screen_effect ShakeScreenY_Big,   32 ; DUEL_ANIM_BIG_SHAKE_Y
	screen_effect WhiteFlashScreen,    8 ; DUEL_ANIM_FLASH
	screen_effect DistortScreen,      63 ; DUEL_ANIM_DISTORT

; checks if screen animation duration is over
; and if so, loads the default update function
LoadDefaultScreenAnimationUpdateWhenFinished: ; 1ccb7 (7:4cb7)
	ld a, [wScreenAnimDuration]
	or a
	ret nz
	; fallthrough

; function called for the screen animation update when it is over
DefaultScreenAnimationUpdate: ; 1ccbc (7:4cbc)
	ld a, $ff
	ld [wd42a], a
	call DisableInt_LYCoincidence
	xor a
	ldh [hSCX], a
	ldh [rSCX], a
	ldh [hSCY], a
	ld hl, wScreenAnimUpdatePtr
	ld [hl], LOW(DefaultScreenAnimationUpdate)
	inc hl
	ld [hl], HIGH(DefaultScreenAnimationUpdate)
	ret
; 0x1ccd4

Func_1ccd4: ; 1ccd4 (7:4cd4)
	ld a, 1
	ld [wScreenAnimDuration], a
	ld hl, wScreenAnimUpdatePtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CallHL2
	jr DefaultScreenAnimationUpdate
; 0x1cce4

ShakeScreenX_Small: ; 1cce4 (7:4ce4)
	ld hl, SmallShakeOffsets
	jr ShakeScreenX

ShakeScreenX_Big: ; 1cce9 (7:4ce9)
	ld hl, BigShakeOffsets
	jr ShakeScreenX

ShakeScreenX: ; 1ccee (7:4cee)
	ld a, l
	ld [wd4bc], a
	ld a, h
	ld [wd4bc + 1], a

	ld hl, wScreenAnimUpdatePtr
	ld [hl], LOW(.update)
	inc hl
	ld [hl], HIGH(.update)
	ret

.update
	call DecrementScreenAnimDuration
	call UpdateShakeOffset
	jp nc, LoadDefaultScreenAnimationUpdateWhenFinished
	ldh a, [hSCX]
	add [hl]
	ldh [hSCX], a
	jp LoadDefaultScreenAnimationUpdateWhenFinished
; 0x1cd10

ShakeScreenY_Small: ; 1cd10 (7:4d10)
	ld hl, SmallShakeOffsets
	jr ShakeScreenY

ShakeScreenY_Big: ; 1cd15 (7:4d15)
	ld hl, BigShakeOffsets
	jr ShakeScreenY

ShakeScreenY: ; 1cd1a (7:4d1a)
	ld a, l
	ld [wd4bc], a
	ld a, h
	ld [wd4bc + 1], a
	ld hl, wScreenAnimUpdatePtr
	ld [hl], LOW(.update)
	inc hl
	ld [hl], HIGH(.update)
	ret

.update
	call DecrementScreenAnimDuration
	call UpdateShakeOffset
	jp nc, LoadDefaultScreenAnimationUpdateWhenFinished
	ldh a, [hSCY]
	add [hl]
	ldh [hSCY], a
	jp LoadDefaultScreenAnimationUpdateWhenFinished
; 0x1cd3c

; get the displacement of the current frame
; depending on the value of wScreenAnimDuration
; returns carry if displacement was updated
UpdateShakeOffset: ; 1cd3c (7:4d3c)
	ld hl, wd4bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wScreenAnimDuration]
	cp [hl]
	ret nc
	inc hl
	push hl
	inc hl
	ld a, l
	ld [wd4bc], a
	ld a, h
	ld [wd4bc + 1], a
	pop hl
	scf
	ret
; 0x1cd55

SmallShakeOffsets: ; 1cd55 (7:4d55)
	db 21,  2
	db 17, -2
	db 13,  2
	db  9, -2
	db  5,  1
	db  1, -1

BigShakeOffsets: ; 1cd61 (7:4d61)
	db 29,  4
	db 25, -4
	db 21,  4
	db 17, -4
	db 13,  3
	db  9, -3
	db  5,  2
	db  1, -2

DecrementScreenAnimDuration: ; 1cd71 (7:4d71)
	ld hl, wScreenAnimDuration
	dec [hl]
	ret
; 0x1cd76

WhiteFlashScreen: ; 1cd76 (7:4d76)
	ld hl, wScreenAnimUpdatePtr
	ld [hl], LOW(.update)
	inc hl
	ld [hl], HIGH(.update)
	ld a, [wBGP]
	ld [wd4bc], a
	; backup the current background pals
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	ld de, $7fff ; rgb 31, 31, 31
	ld hl, wBackgroundPalettesCGB
	ld bc, (8 palettes) / 2
	call FillMemoryWithDE
	xor a
	call SetBGP
	call FlushAllPalettes

.update
	call DecrementScreenAnimDuration
	ld a, [wScreenAnimDuration]
	or a
	ret nz
	; retreive the previous background pals
	ld hl, wTempBackgroundPalettesCGB
	ld de, wBackgroundPalettesCGB
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	ld a, [wd4bc]
	call SetBGP
	call FlushAllPalettes
	jp DefaultScreenAnimationUpdate
; 0x1cdc3

DistortScreen: ; 1cdc3 (7:4dc3)
	ld hl, wScreenAnimUpdatePtr
	ld [hl], LOW(.update)
	inc hl
	ld [hl], HIGH(.update)
	xor a
	ld [wApplyBGScroll], a
	ld hl, wLCDCFunctionTrampoline + 1
	ld [hl], LOW(ApplyBackgroundScroll)
	inc hl
	ld [hl], HIGH(ApplyBackgroundScroll)
	ld a, 1
	ld [wBGScrollMod], a
	call EnableInt_LYCoincidence

.update
	ld a, [wScreenAnimDuration]
	srl a
	srl a
	srl a
	and %00000111
	ld c, a
	ld b, $00
	ld hl, .BGScrollModData
	add hl, bc
	ld a, [hl]
	ld [wBGScrollMod], a
	call DecrementScreenAnimDuration
	jp LoadDefaultScreenAnimationUpdateWhenFinished

; each value is applied for 8 "ticks" of wScreenAnimDuration
; starting from the last and running backwards
.BGScrollModData
	db 4, 3, 2, 1, 1, 1, 1, 2
; 0x1ce03

Func_1ce03: ; 1ce03 (7:4e03)
	cp DUEL_ANIM_158
	jr z, .asm_1ce17
	sub $96
	add a
	ld c, a
	ld b, $00
	ld hl, .pointer_table
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Func_3bb5
	
.asm_1ce17
	ld a, [wDuelAnimDamage]
	ld l, a
	ld a, [wDuelAnimDamage + 1]
	ld h, a
	jp Func_3bb5

.pointer_table
	dw Func_190f4         ; DUEL_ANIM_150
	dw PrintDamageText    ; DUEL_ANIM_PRINT_DAMAGE
	dw UpdateMainSceneHUD ; DUEL_ANIM_UPDATE_HUD
	dw Func_191a3         ; DUEL_ANIM_153
	dw Func_191a3         ; DUEL_ANIM_154
	dw Func_191a3         ; DUEL_ANIM_155
	dw Func_191a3         ; DUEL_ANIM_156
	dw Func_191a3         ; DUEL_ANIM_157

INCLUDE "data/duel_animations.asm"

Func_1d078: ; 1d078 (7:5078)
	ld a, [wd627]
	or a
	jr z, .asm_1d0c7
.asm_1d07e
	ld a, MUSIC_STOP
	call PlaySong
	call Func_3ca0
	call Func_1d335
	call Func_1d3ce
	xor a
	ld [wd635], a
	ld a, $3c
	ld [wd626], a
.asm_1d095
	call DoFrameIfLCDEnabled
	call UpdateRNGSources
	call Func_1d614
	ld hl, wd635
	inc [hl]
	call AssertSongFinished
	or a
	jr nz, .asm_1d0ae
	farcall Func_10ab4
	jr .asm_1d07e
.asm_1d0ae
	ld hl, wd626
	ld a, [hl]
	or a
	jr z, .asm_1d0b8
	dec [hl]
	jr .asm_1d095
.asm_1d0b8
	ldh a, [hKeysPressed]
	and A_BUTTON | START
	jr z, .asm_1d095
	ld a, SFX_02
	call PlaySFX
	farcall Func_10ab4

.asm_1d0c7
	call Func_1d0fa
	call Func_1d11c
	ld a, [wd628]
	cp $2
	jr nz, .asm_1d0db
	call Func_1d289
	jr c, Func_1d078
	jr .asm_1d0e7
.asm_1d0db
	ld a, [wd628]
	cp $1
	jr nz, .asm_1d0e7
	call Func_1d2b8
	jr c, Func_1d078
.asm_1d0e7
	ld a, [wd628]
	cp $0
	jr nz, .asm_1d0f3
	call Func_1d2dd
	jr c, Func_1d078
.asm_1d0f3
	call ResetDoFrameFunction
	call Func_3ca0
	ret

Func_1d0fa: ; 1d0fa (7:50fa)
	farcall Func_11320
	ld a, $01
	jr c, .asm_1d104
	ld a, $00
.asm_1d104
	ld [wd624], a
	cp $00
	jr z, .asm_1d114
	bank1call ValidateSavedNonLinkDuelData
	ld a, $01
	jr nc, .asm_1d114
	ld a, $00
.asm_1d114
	ld [wd625], a
	farcall Func_11320
	ret
; 0x1d11c

Func_1d11c: ; 1d11c (7:511c)
	ld a, MUSIC_PC_MAIN_MENU
	call PlaySong
	call DisableLCD
	farcall Func_10000
	lb de, $30, $8f
	call SetupText
	call Func_3ca0
	xor a
	ld [wLineSeparation], a
	call Func_1d1e1
	call Func_1d17f
	ld a, $ff
	ld [wd626], a
	ld a, [wd627]
	cp $4
	jr c, .asm_1d14f
	ld a, [wd624]
	or a
	jr z, .asm_1d14f
	ld a, $1
.asm_1d14f
	ld hl, wd636
	farcall Func_111e9
	farcall Func_10031
.asm_1d15a
	call DoFrameIfLCDEnabled
	call UpdateRNGSources
	call HandleMenuInput
	push af
	call Func_1d1e9
	pop af
	jr nc, .asm_1d15a
	ldh a, [hCurMenuItem]
	cp e
	jr nz, .asm_1d15a
	ld [wd627], a
	ld a, [wd624]
	or a
	jr nz, .asm_1d17a
	inc e
	inc e
.asm_1d17a
	ld a, e
	ld [wd628], a
	ret

Func_1d17f: ; 1d17f (7:517f)
	INCROM $1d17f, $1d1e1

Func_1d1e1: ; 1d1e1 (7:51e1)
	INCROM $1d1e1, $1d1e9

Func_1d1e9: ; 1d1e9 (7:51e9)
	INCROM $1d1e9, $1d289

Func_1d289: ; 1d289 (7:5289)
	INCROM $1d289, $1d2b8

Func_1d2b8: ; 1d2b8 (7:52b8)
	INCROM $1d2b8, $1d2dd

Func_1d2dd: ; 1d2dd (7:52dd)
	INCROM $1d2dd, $1d306

Func_1d306: ; 1d306 (7:5306)
	INCROM $1d306, $1d335

Func_1d335: ; 1d335 (7:5335)
	INCROM $1d335, $1d386

Titlescreen_1d386: ; 1d386 (7:5386)
	call AssertSongFinished
	or a
	jr nz, .asm_1d39f
	call DisableLCD
	ld a, MUSIC_TITLESCREEN
	call PlaySong
	lb bc, 0, 0
	ld a, SCENE_TITLE_SCREEN
	call LoadScene
	call Func_1d59c
.asm_1d39f
	call Func_3ca0
	call Func_1d3a9
	call EnableLCD
	ret

Func_1d3a9: ; 1d3a9 (7:53a9)
	INCROM $1d3a9, $1d3ce

Func_1d3ce: ; 1d3ce (7:53ce)
	INCROM $1d3ce, $1d42e

Func_1d42e: ; 1d42e (7:542e)
	INCROM $1d42e, $1d519

Titlescreen_1d519: ; 1d519 (7:5519)
	ld a, MUSIC_TITLESCREEN
	call PlaySong
	call Func_1d42e
	scf
	ret
; 0x1d523

	INCROM $1d523, $1d59c

Func_1d59c: ; 1d59c (7:559c)
	INCROM $1d59c, $1d614

Func_1d614: ; 1d614 (7:5614)
	INCROM $1d614, $1d6ad

Credits_1d6ad: ; 1d6ad (7:56ad)
	ld a, MUSIC_STOP
	call PlaySong
	call Func_1d705
	call AddAllMastersToMastersBeatenList
	xor a
	ld [wOWMapEvents + 1], a
	ld a, MUSIC_CREDITS
	call PlaySong
	farcall Func_10031
	call Func_1d7fc
.asm_1d6c8
	call DoFrameIfLCDEnabled
	call Func_1d765
	call Func_1d80b
	ld a, [wd633]
	cp $ff
	jr nz, .asm_1d6c8
	call WaitForSongToFinish
	ld a, $8
	farcall Func_12863
	ld a, MUSIC_STOP
	call PlaySong
	farcall Func_10ab4
	call Func_3ca4
	call Set_WD_off
	call Func_1d758
	call EnableLCD
	call DoFrameIfLCDEnabled
	call DisableLCD
	ld hl, wLCDC
	set 1, [hl]
	call ResetDoFrameFunction
	ret

Func_1d705: ; 1d705 (7:5705)
	INCROM $1d705, $1d758

Func_1d758: ; 1d758 (7:5758)
	INCROM $1d758, $1d765

Func_1d765: ; 1d765 (7:5765)
	INCROM $1d765, $1d7fc

Func_1d7fc: ; 1d7fc (7:57fc)
	INCROM $1d7fc, $1d80b

Func_1d80b: ; 1d80b (7:580b)
	INCROM $1d80b, $1e1c4
