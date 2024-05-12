; refresh the cursor's position based on the currently selected map
; and refresh the player's position based on the starting map
; but only if the player is not being animated across the overworld
OverworldMap_UpdatePlayerAndCursorSprites:
	push hl
	push bc
	push de
	ld a, [wOverworldMapCursorSprite]
	ld [wWhichSprite], a
	ld a, [wOverworldMapSelection]
	ld d, 0
	ld e, -12
	call OverworldMap_SetSpritePosition
	ld a, [wOverworldMapPlayerAnimationState]
	or a
	jr nz, .player_walking
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wOverworldMapStartingPosition]
	ld d, 0
	ld e, 0
	call OverworldMap_SetSpritePosition
.player_walking
	pop de
	pop bc
	pop hl
	ret

; if no selection has been made yet, call OverworldMap_HandleKeyPress
; if the player is being animated across the screen, call OverworldMap_UpdatePlayerWalkingAnimation
; if the player has finished walking, call OverworldMap_LoadSelectedMap
OverworldMap_Update:
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wOverworldMapPlayerAnimationState]
	or a
	jr nz, .player_walking
	call OverworldMap_HandleKeyPress
	ret
.player_walking
	cp 2
	jr z, .player_finished_walking
	call OverworldMap_UpdatePlayerWalkingAnimation
	ret
.player_finished_walking
	call OverworldMap_LoadSelectedMap
	ret

; update the map selection if the DPad is pressed
; or finalize the selection if the A button is pressed
OverworldMap_HandleKeyPress:
	ldh a, [hKeysPressed]
	and D_PAD
	jr z, .no_d_pad
	farcall GetDirectionFromDPad
	ld [wPlayerDirection], a
	call OverworldMap_HandleDPad
	jr .done
.no_d_pad
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .done
	ld a, SFX_CONFIRM
	call PlaySFX
	call OverworldMap_UpdateCursorAnimation
	call OverworldMap_BeginPlayerMovement
	jr .done
.done
	ret

; update wOverworldMapSelection based on the pressed direction in wPlayerDirection
OverworldMap_HandleDPad:
	push hl
	pop hl
	ld a, [wOverworldMapSelection]
	rlca
	rlca
	ld c, a
	ld a, [wPlayerDirection]
	add c
	ld c, a
	ld b, 0
	ld hl, OverworldMap_CursorTransitions
	add hl, bc
	ld a, [hl]
	or a
	jr z, .no_transition
	ld [wOverworldMapSelection], a
	call OverworldMap_PrintMapName
	ld a, SFX_CURSOR
	call PlaySFX
.no_transition
	pop bc
	pop hl
	ret

INCLUDE "data/overworld_map/cursor_transitions.asm"

; set the active sprite (player or cursor) at the appropriate map position
; input:
; a = OWMAP_* value
; d = x offset
; e = y offset
OverworldMap_SetSpritePosition:
	call OverworldMap_GetMapPosition
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	ret

; input:
; a = OWMAP_* value
; d = x offset
; e = y offset
; output:
; d = x position
; e = y position
OverworldMap_GetMapPosition:
	push hl
	push de
	rlca
	ld e, a
	ld d, 0
	ld hl, OverworldMap_MapPositions
	add hl, de
	pop de
	ld a, [hli]
	add $8
	add d
	ld d, a
	ld a, [hl]
	add $10
	add e
	ld e, a
	pop hl
	ret

INCLUDE "data/overworld_map/map_positions.asm"

OverworldMap_PrintMapName:
	push hl
	push de
	lb de, 1, 1
	call InitTextPrinting
	call OverworldMap_GetOWMapID
	rlca
	ld e, a
	ld d, 0
	ld hl, OverworldMapNames
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID
	pop de
	pop hl
	ret

; returns [wOverworldMapSelection] in a
; or OWMAP_MYSTERY_HOUSE if [wOverworldMapSelection] == OWMAP_ISHIHARAS_HOUSE
;   and EVENT_ISHIHARAS_HOUSE_MENTIONED == FALSE
OverworldMap_GetOWMapID:
	push bc
	ld a, [wOverworldMapSelection]
	cp OWMAP_ISHIHARAS_HOUSE
	jr nz, .got_map
	ld c, a
	ld a, EVENT_ISHIHARAS_HOUSE_MENTIONED
	farcall GetEventValue
	or a
	ld a, c
	jr nz, .got_map
	ld a, OWMAP_MYSTERY_HOUSE
.got_map
	pop bc
	ret

OverworldMap_LoadSelectedMap:
	push hl
	push bc
	ld a, [wOverworldMapSelection]
	rlca
	rlca
	ld c, a
	ld b, 0
	ld hl, OverworldMapWarps
	add hl, bc
	ld a, [hli]
	ld [wTempMap], a
	ld a, [hli]
	ld [wTempPlayerXCoord], a
	ld a, [hli]
	ld [wTempPlayerYCoord], a
	ld a, NORTH
	ld [wTempPlayerDirection], a
	ld hl, wOverworldTransition
	set 4, [hl]
	pop bc
	pop hl
	ret

INCLUDE "data/overworld_map/overworld_warps.asm"

OverworldMap_InitVolcanoSprite:
	ld a, SPRITE_OW_MAP_OAM
	farcall CreateSpriteAndAnimBufferEntry
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, $80
	ld [hli], a ; x
	ld a, $10
	ld [hl], a ; y
	ld b, SPRITE_ANIM_SGB_VOLCANO_SMOKE
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld b, SPRITE_ANIM_CGB_VOLCANO_SMOKE
.not_cgb
	ld a, b
	farcall StartNewSpriteAnimation
	ret

OverworldMap_InitCursorSprite:
	ld a, [wOverworldMapSelection]
	ld [wOverworldMapStartingPosition], a
	xor a
	ld [wOverworldMapPlayerAnimationState], a
	ld a, SPRITE_OW_MAP_OAM
	call CreateSpriteAndAnimBufferEntry
	ld a, [wWhichSprite]
	ld [wOverworldMapCursorSprite], a
	ld b, SPRITE_ANIM_SGB_OWMAP_CURSOR
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .not_cgb
	ld b, SPRITE_ANIM_CGB_OWMAP_CURSOR
.not_cgb
	ld a, b
	ld [wOverworldMapCursorAnimation], a
	call StartNewSpriteAnimation
	ld a, EVENT_MASON_LAB_STATE
	farcall GetEventValue
	or a
	jr nz, .visited_lab
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	set SPRITE_ANIM_FLAG_UNSKIPPABLE, [hl]
.visited_lab
	ret

; play animation SPRITE_ANIM_SGB_OWMAP_CURSOR_FAST (non-cgb) or SPRITE_ANIM_CGB_OWMAP_CURSOR_FAST (cgb)
; to make the cursor blink faster after a selection is made
OverworldMap_UpdateCursorAnimation:
	ld a, [wOverworldMapCursorSprite]
	ld [wWhichSprite], a
	ld a, [wOverworldMapCursorAnimation]
	inc a
	call StartNewSpriteAnimation
	ret

; begin walking the player across the overworld
; from wOverworldMapStartingPosition to wOverworldMapSelection
OverworldMap_BeginPlayerMovement:
	ld a, SFX_PLAYER_WALK_MAP
	call PlaySFX
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld c, SPRITE_ANIM_FLAGS
	call GetSpriteAnimBufferProperty
	set SPRITE_ANIM_FLAG_SPEED, [hl]

; get pointer table for starting map
	ld hl, OverworldMap_PlayerMovementPaths
	ld a, [wOverworldMapStartingPosition]
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

; get path sequence for selected map
	ld a, [wOverworldMapSelection]
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld [wOverworldMapPlayerMovementPtr], a
	ld a, [hl]
	ld [wOverworldMapPlayerMovementPtr + 1], a

	ld a, 1
	ld [wOverworldMapPlayerAnimationState], a
	xor a
	ld [wOverworldMapPlayerMovementCounter], a
	ret

; update the player walking across the overworld
; either by advancing along the current path
; or determining the next direction to move along the path
OverworldMap_UpdatePlayerWalkingAnimation:
	ld a, [wPlayerSpriteIndex]
	ld [wWhichSprite], a
	ld a, [wOverworldMapPlayerMovementCounter]
	or a
	jp nz, OverworldMap_ContinuePlayerWalkingAnimation

; get next x,y on the path
	ld a, [wOverworldMapPlayerMovementPtr]
	ld l, a
	ld a, [wOverworldMapPlayerMovementPtr + 1]
	ld h, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	and b
	cp $ff
	jr z, .player_finished_walking
	ld a, c
	or b
	jr nz, .next_point

; point 0,0 means walk straight towards [wOverworldMapSelection]
	ld a, [wOverworldMapStartingPosition]
	ld e, a
	ld a, [wOverworldMapSelection]
	cp e
	jr z, .player_finished_walking
	lb de, 0, 0
	call OverworldMap_GetMapPosition
	ld b, d
	ld c, e

.next_point
	ld a, l
	ld [wOverworldMapPlayerMovementPtr], a
	ld a, h
	ld [wOverworldMapPlayerMovementPtr + 1], a
	call OverworldMap_InitNextPlayerVelocity
	ret

.player_finished_walking
	ld a, 2
	ld [wOverworldMapPlayerAnimationState], a
	ret

; input:
; b = target x position
; c = target y position
OverworldMap_InitNextPlayerVelocity:
	push hl
	push bc
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty

	pop bc
	ld a, b
	sub [hl] ; a = target x - current x
	ld [wOverworldMapPlayerPathHorizontalMovement], a
	ld a, 0
	sbc 0
	ld [wOverworldMapPlayerPathHorizontalMovement + 1], a

	inc hl
	ld a, c
	sub [hl] ; a = target y - current y
	ld [wOverworldMapPlayerPathVerticalMovement], a
	ld a, 0
	sbc 0
	ld [wOverworldMapPlayerPathVerticalMovement + 1], a

	ld a, [wOverworldMapPlayerPathHorizontalMovement]
	ld b, a
	ld a, [wOverworldMapPlayerPathHorizontalMovement + 1]
	bit 7, a
	jr z, .positive
; absolute value
	ld a, [wOverworldMapPlayerPathHorizontalMovement]
	cpl
	inc a
	ld b, a

.positive
	ld a, [wOverworldMapPlayerPathVerticalMovement]
	ld c, a
	ld a, [wOverworldMapPlayerPathVerticalMovement + 1]
	bit 7, a
	jr z, .positive2
; absolute value
	ld a, [wOverworldMapPlayerPathVerticalMovement]
	cpl
	inc a
	ld c, a

.positive2
; if the absolute value of wOverworldMapPlayerPathVerticalMovement is larger than
; the absolute value of wOverworldMapPlayerPathHorizontalMovement, this is dominantly
; a north/south movement. otherwise, an east/west movement
	ld a, b
	cp c
	jr c, .north_south
	call OverworldMap_InitPlayerEastWestMovement
	jr .done
.north_south
	call OverworldMap_InitPlayerNorthSouthMovement
.done
	xor a
	ld [wOverworldMapPlayerHorizontalSubPixelPosition], a
	ld [wOverworldMapPlayerVerticalSubPixelPosition], a
	farcall UpdatePlayerSprite
	pop hl
	ret

; input:
; b = absolute value of horizontal movement distance
; c = absolute value of vertical movement distance
OverworldMap_InitPlayerEastWestMovement:
; use horizontal distance for counter
	ld a, b
	ld [wOverworldMapPlayerMovementCounter], a

; de = absolute horizontal distance, for later
	ld e, a
	ld d, 0

; overwrite wOverworldMapPlayerPathHorizontalMovement with either -1.0 or +1.0
; always move east/west by 1 pixel per frame
	ld hl, wOverworldMapPlayerPathHorizontalMovement
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .east
	dec a
	jr .west
.east
	inc a
.west
	ld [hl], a

; divide (total vertical distance * $100) by total horizontal distance
	ld b, c ; vertical distance in high byte
	ld c, 0
	call DivideBCbyDE
	ld a, [wOverworldMapPlayerPathVerticalMovement + 1]
	bit 7, a
	jr z, .positive
; restore negative sign
	call OverworldMap_NegateBC
.positive
	ld a, c
	ld [wOverworldMapPlayerPathVerticalMovement], a
	ld a, b
	ld [wOverworldMapPlayerPathVerticalMovement + 1], a

; set player direction
	ld hl, wOverworldMapPlayerPathHorizontalMovement + 1
	ld a, EAST
	bit 7, [hl]
	jr z, .east2
	ld a, WEST
.east2
	ld [wPlayerDirection], a
	ret

; input:
; b = absolute value of horizontal movement distance
; c = absolute value of vertical movement distance
OverworldMap_InitPlayerNorthSouthMovement:
; use vertical distance for counter
	ld a, c
	ld [wOverworldMapPlayerMovementCounter], a

; de = absolute vertical distance, for later
	ld e, a
	ld d, 0

; overwrite wOverworldMapPlayerPathVerticalMovement with either -1.0 or +1.0
; always move north/south by 1 pixel per frame
	ld hl, wOverworldMapPlayerPathVerticalMovement
	xor a
	ld [hli], a
	bit 7, [hl]
	jr z, .south
	dec a
	jr .north
.south
	inc a
.north
	ld [hl], a

; divide (total horizontal distance * $100) by total vertical distance
; horizontal distance in high byte
	ld c, 0
	call DivideBCbyDE
	ld a, [wOverworldMapPlayerPathHorizontalMovement + 1]
	bit 7, a
	jr z, .positive
; restore negative sign
	call OverworldMap_NegateBC
.positive
	ld a, c
	ld [wOverworldMapPlayerPathHorizontalMovement], a
	ld a, b
	ld [wOverworldMapPlayerPathHorizontalMovement + 1], a

; set player direction
	ld hl, wOverworldMapPlayerPathVerticalMovement + 1
	ld a, SOUTH
	bit 7, [hl]
	jr z, .south2
	ld a, NORTH
.south2
	ld [wPlayerDirection], a
	ret

; output:
; bc = bc * -1
OverworldMap_NegateBC:
	ld a, c
	cpl
	add 1
	ld c, a
	ld a, b
	cpl
	adc 0
	ld b, a
	ret

; add the x/y speed to the current sprite position,
; accounting for sub-pixel position
; and decrement [wOverworldMapPlayerMovementCounter]
OverworldMap_ContinuePlayerWalkingAnimation:
	ld a, [wOverworldMapPlayerHorizontalSubPixelPosition]
	ld d, a
	ld a, [wOverworldMapPlayerVerticalSubPixelPosition]
	ld e, a
	ld c, SPRITE_ANIM_COORD_X
	call GetSpriteAnimBufferProperty
	ld a, [wOverworldMapPlayerPathHorizontalMovement]
	add d
	ld d, a
	ld a, [wOverworldMapPlayerPathHorizontalMovement + 1]
	adc [hl] ; add carry from sub-pixel movement
	ld [hl], a
	inc hl
	ld a, [wOverworldMapPlayerPathVerticalMovement]
	add e
	ld e, a
	ld a, [wOverworldMapPlayerPathVerticalMovement + 1]
	adc [hl] ; add carry from sub-pixel movement
	ld [hl], a
	ld a, d
	ld [wOverworldMapPlayerHorizontalSubPixelPosition], a
	ld a, e
	ld [wOverworldMapPlayerVerticalSubPixelPosition], a
	ld hl, wOverworldMapPlayerMovementCounter
	dec [hl]
	ret
