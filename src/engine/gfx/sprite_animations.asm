; disables all sprite animations
; and clears memory related to sprites
_ClearSpriteAnimations::
	push af
	ld a, [wAllSpriteAnimationsDisabled]
	or a
	jr z, .continue
	pop af
	ret
.continue
	pop af
	push bc
	push hl
	xor a
	ld [wWhichSprite], a
	call GetFirstSpriteAnimBufferProperty
	lb bc, 0, SPRITE_ANIM_LENGTH

; disable all sprite animations
.loop_sprites
	xor a
	ld [hl], a ; set SPRITE_ANIM_ENABLED to 0
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp SPRITE_ANIM_BUFFER_CAPACITY
	jr nz, .loop_sprites

	call ClearSpriteVRAMBuffer
	call ZeroObjectPositions
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	pop hl
	pop bc
	ret

; creates a new entry in SpriteAnimBuffer, else loads the sprite if need be
CreateSpriteAndAnimBufferEntry:
	push af
	ld a, [wAllSpriteAnimationsDisabled]
	or a
	jr z, .continue
	pop af
	ret
.continue
	pop af
	push bc
	push hl
	call Func_12c05
	ld [wCurrSpriteTileID], a
	xor a
	ld [wWhichSprite], a
	call GetFirstSpriteAnimBufferProperty
	ld bc, SPRITE_ANIM_LENGTH
.findFirstEmptyAnimField
	ld a, [hl]
	or a
	jr z, .foundEmptyAnimField
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp $10
	jr nz, .findFirstEmptyAnimField
	debug_nop
	scf
	jr .quit
.foundEmptyAnimField
	ld a, $1
	ld [hl], a
	call FillNewSpriteAnimBufferEntry
	or a
.quit
	pop hl
	pop bc
	ret

FillNewSpriteAnimBufferEntry:
	push hl
	push bc
	push hl
	inc hl
	ld c, SPRITE_ANIM_LENGTH - 1
	xor a
.clearSpriteAnimBufferEntryLoop
	ld [hli], a
	dec c
	jr nz, .clearSpriteAnimBufferEntryLoop
	pop hl
	ld bc, SPRITE_ANIM_ID - 1
	add hl, bc
	ld a, [wCurrSpriteTileID]
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ld bc, SPRITE_ANIM_COUNTER - SPRITE_ANIM_ID
	add hl, bc
	ld a, $ff
	ld [hl], a
	pop bc
	pop hl
	ret

DisableCurSpriteAnim:
	ld a, [wWhichSprite]
	; fallthrough

; sets SPRITE_ANIM_ENABLED to false
; of sprite in register a
DisableSpriteAnim:
	push af
	ld a, [wAllSpriteAnimationsDisabled]
	or a
	jr z, .disable
	pop af
	ret
.disable
	pop af
	push hl
	push bc
	ld c, SPRITE_ANIM_ENABLED
	call GetSpriteAnimBufferProperty_SpriteInA
	ld [hl], FALSE
	pop bc
	pop hl
	ret

GetSpriteAnimCounter:
	ld a, [wWhichSprite]
	push hl
	push bc
	ld c, SPRITE_ANIM_COUNTER
	call GetSpriteAnimBufferProperty_SpriteInA
	ld a, [hl]
	pop bc
	pop hl
	ret

_HandleAllSpriteAnimations::
	push af
	ld a, [wAllSpriteAnimationsDisabled] ; skip animating this frame if enabled
	or a
	jr z, .continue
	pop af
	ret
.continue
	pop af
	push af
	push bc
	push de
	push hl
	call ZeroObjectPositions
	xor a
	ld [wWhichSprite], a
	call GetFirstSpriteAnimBufferProperty
.spriteLoop
	ld a, [hl]
	or a
	jr z, .nextSprite ; skip if SPRITE_ANIM_ENABLED is 0
	call TryHandleSpriteAnimationFrame
	call LoadSpriteDataForAnimationFrame
.nextSprite
	ld bc, SPRITE_ANIM_LENGTH
	add hl, bc
	ld a, [wWhichSprite]
	inc a
	ld [wWhichSprite], a
	cp SPRITE_ANIM_BUFFER_CAPACITY
	jr nz, .spriteLoop
	ld hl, wVBlankOAMCopyToggle
	inc [hl]
	pop hl
	pop de
	pop bc
	pop af
	ret

LoadSpriteDataForAnimationFrame:
	push hl
	push bc
	inc hl
	ld a, [hli]
	ld [wCurrSpriteAttributes], a
	ld a, [hli]
	ld [wCurrSpriteXPos], a
	ld a, [hli]
	ld [wCurrSpriteYPos], a
	ld a, [hl]
	ld [wCurrSpriteTileID], a
	ld bc, SPRITE_ANIM_FLAGS - SPRITE_ANIM_TILE_ID
	add hl, bc
	ld a, [hl]
	and 1 << SPRITE_ANIM_FLAG_UNSKIPPABLE
	jr nz, .quit
	ld bc, SPRITE_ANIM_FRAME_BANK - SPRITE_ANIM_FLAGS
	add hl, bc
	ld a, [hli]
	ld [wCurrSpriteFrameBank], a
	or a
	jr z, .quit
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DrawSpriteAnimationFrame
.quit
	pop bc
	pop hl
	ret

; decrements the given sprite's movement counter (2x if SPRITE_ANIM_FLAG_SPEED is set)
; moves to the next animation frame if necessary
TryHandleSpriteAnimationFrame:
	push hl
	push bc
	push de
	push hl
	ld d, 1
	ld bc, SPRITE_ANIM_FLAGS
	add hl, bc
	bit SPRITE_ANIM_FLAG_SPEED, [hl]
	jr z, .skipSpeedIncrease
	inc d
.skipSpeedIncrease
	pop hl
	ld bc, SPRITE_ANIM_COUNTER
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .exit
	sub d
	ld [hl], a
	jr z, .doNextAnimationFrame
	jr nc, .exit
.doNextAnimationFrame
	ld bc, SPRITE_ANIM_ENABLED - SPRITE_ANIM_COUNTER
	add hl, bc
	call HandleAnimationFrame
.exit
	pop de
	pop bc
	pop hl
	ret

StartNewSpriteAnimation:
	push hl
	push af
	ld c, SPRITE_ANIM_ID
	call GetSpriteAnimBufferProperty
	pop af
	cp [hl]
	pop hl
	ret z
	; fallthrough

StartSpriteAnimation:
	push hl
	call LoadSpriteAnimPointers
	call HandleAnimationFrame
	pop hl
	ret

; a = sprite animation
; c = animation counter value
Func_12ac9:
	push bc
	ld b, a
	ld a, c
	or a
	ld a, b
	pop bc
	jr z, StartSpriteAnimation

	push hl
	push bc
	call LoadSpriteAnimPointers
	ld a, $ff
	call GetAnimFramePointerFromOffset
	pop bc
	ld a, c
	call SetAnimationCounterAndLoop
	pop hl
	ret

; Given an animation ID, fills the current sprite's Animation Pointer and Frame Offset Pointer
; a - Animation ID for current sprite
LoadSpriteAnimPointers:
	push bc
	push af
	call GetFirstSpriteAnimBufferProperty
	pop af
	push hl
	ld bc, SPRITE_ANIM_ID
	add hl, bc
	ld [hli], a
	push hl
	ld l, 6 ; SpriteAnimations
	farcall GetMapDataPointer
	farcall LoadGraphicsPointerFromHL
	pop hl ; hl is animation bank
	ld a, [wTempPointerBank]
	ld [hli], a
	ld a, [wTempPointer + 0]
	ld [hli], a
	ld c, a
	ld a, [wTempPointer + 1]
	ld [hli], a
	ld b, a
	; offset pointer = pointer + $3
	ld a, $3
	add c
	ld [hli], a
	ld a, $0
	adc b
	ld [hli], a
	pop hl
	pop bc
	ret

; hl - beginning of current sprite_anim_buffer
; Handles a full animation frame using all values in animation structure
; (frame data offset, anim counter, X Mov, Y Mov)
HandleAnimationFrame:
	push bc
	push de
	push hl
.tryHandlingFrame
	push hl
	ld bc, SPRITE_ANIM_BANK
	add hl, bc
	ld a, [hli]
	ld [wTempPointerBank], a

	inc hl
	inc hl
	ld a, [hl] ; SPRITE_ANIM_FRAME_OFFSET_POINTER
	ld [wTempPointer + 0], a
	add SPRITE_FRAME_OFFSET_SIZE ; advance FRAME_OFFSET_POINTER by 1 frame, 4 bytes
	ld [hli], a
	ld a, [hl]
	ld [wTempPointer + 1], a
	adc 0
	ld [hl], a

	ld de, wLoadedPalData
	ld bc, SPRITE_FRAME_OFFSET_SIZE
	call CopyBankedDataToDE
	pop hl ; beginning of current sprite_anim_buffer
	ld de, wLoadedPalData
	ld a, [de]
	call GetAnimFramePointerFromOffset
	inc de
	ld a, [de]
	call SetAnimationCounterAndLoop
	jr c, .tryHandlingFrame
	inc de
	ld bc, SPRITE_ANIM_COORD_X
	add hl, bc
	push hl
	ld bc, SPRITE_ANIM_FLAGS - SPRITE_ANIM_COORD_X
	add hl, bc
	ld b, [hl]
	pop hl
	ld a, [de]
	bit SPRITE_ANIM_FLAG_X_SUBTRACT, b
	jr z, .addXOffset
	cpl
	inc a
.addXOffset
	add [hl]
	ld [hli], a
	inc de
	ld a, [de]
	bit SPRITE_ANIM_FLAG_Y_SUBTRACT, b
	jr z, .addYOffset
	cpl
	inc a
.addYOffset
	add [hl]
	ld [hl], a
	pop hl
	pop de
	pop bc
	ret

; Calls GetAnimationFramePointer after setting up wTempPointerBank
; and wVRAMTileOffset
; a - frame offset from Animation Data
; hl - beginning of Sprite Anim Buffer
GetAnimFramePointerFromOffset:
	ld [wVRAMTileOffset], a
	push hl
	push bc
	push de
	push hl
	ld bc, SPRITE_ANIM_BANK
	add hl, bc
	ld a, [hli]
	ld [wTempPointerBank], a
	ld a, [hli]
	ld [wTempPointer + 0], a
	ld a, [hli]
	ld [wTempPointer + 1], a
	pop hl
	call GetAnimationFramePointer ; calls with the original map data script pointer/bank
	pop de
	pop bc
	pop hl
	ret

; Sets the animation counter for the current sprite. If the value is zero, loop the animation
; a - new animation counter
SetAnimationCounterAndLoop:
	push hl
	push bc
	ld bc, SPRITE_ANIM_COUNTER
	add hl, bc
	ld [hl], a
	or a
	jr nz, .exit
	ld bc, SPRITE_ANIM_POINTER - SPRITE_ANIM_COUNTER
	add hl, bc
	ld a, [hli]
	add $3 ; skip base bank/pointer at beginning of data structure
	ld c, a
	ld a, [hli]
	adc 0
	ld b, a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	scf
.exit
	pop bc
	pop hl
	ret

Func_12ba7:
	push hl
	push bc
	push de
	call EnableSRAM
	ld hl, wSpriteAnimBuffer
	ld de, sGeneralSaveDataEnd
	ld bc, $100
	call CopyDataHLtoDE
	ld hl, wSpriteVRAMBuffer
	ld bc, $40
	call CopyDataHLtoDE
	ld a, [wSpriteVRAMBufferSize]
	ld [de], a
	call DisableSRAM
	pop de
	pop bc
	pop hl
	ret

Func_12bcd:
	push hl
	push bc
	push de
	call EnableSRAM
	ld hl, sGeneralSaveDataEnd
	ld de, wSpriteAnimBuffer
	ld bc, $100
	call CopyDataHLtoDE
	ld de, wSpriteVRAMBuffer
	ld bc, $40
	call CopyDataHLtoDE
	ld a, [hl]
	ld [wSpriteVRAMBufferSize], a
	call DisableSRAM
	pop de
	pop bc
	pop hl
	ret

; clears wSpriteVRAMBufferSize and wSpriteVRAMBuffer
ClearSpriteVRAMBuffer:
	push hl
	push bc
	xor a
	ld [wSpriteVRAMBufferSize], a
	ld c, $40
	ld hl, wSpriteVRAMBuffer
.asm_12bfe
	ld [hli], a
	dec c
	jr nz, .asm_12bfe
	pop bc
	pop hl
	ret

; gets some value based on the sprite in a and wSpriteVRAMBuffer
; loads the sprites data if it doesn't already exist
Func_12c05:
	push hl
	push bc
	push de
	ld b, a
	ld d, $0
	ld a, [wSpriteVRAMBufferSize]
	ld c, a
	ld hl, wSpriteVRAMBuffer
	or a
	jr z, .tryToAddSprite

.findSpriteMatchLoop
	inc hl
	ld a, [hl]
	cp b
	jr z, .foundSpriteMatch
	inc hl
	ld a, [hli]
	add [hl] ; add tile size to tile offset
	ld d, a
	inc hl
	dec c
	jr nz, .findSpriteMatchLoop

.tryToAddSprite
	ld a, [wSpriteVRAMBufferSize]
	cp $10
	jr nc, .quitFail
	inc a
	ld [wSpriteVRAMBufferSize], a ; increase number of entries by 1
	inc hl
	push hl
	ld a, b
	ld [hli], a ; store sprite index
	call Func_12c4f
	push af
	ld a, d
	ld [hli], a ; store tile offset
	pop af
	ld [hl], a ; store tile size
	pop hl

.foundSpriteMatch
	dec hl
	inc [hl] ; mark this entry as valid
	inc hl
	inc hl
	ld a, [hli]
	add [hl]
	cp $81
	jr nc, .quitFail ; exceeds total tile size
	ld a, d
	or a
	jr .quitSucceed

.quitFail
	debug_nop
	xor a
	scf
.quitSucceed
	pop de
	pop bc
	pop hl
	ret

; input:
; a = sprite index within the data map
; d = tile offset in VRAM
; output:
; a = number of tiles in sprite
Func_12c4f:
	push af
	xor a
	ld [wd4cb], a
	ld a, d
	ld [wVRAMTileOffset], a
	pop af
	farcall Func_8025b
	ret

Func_12c5e:
	push hl
	push bc
	push de
	ld c, $10
	ld de, $4
	ld hl, wSpriteVRAMBuffer
.asm_12c69
	ld a, [hl]
	or a
	jr z, .asm_12c77
	push hl
	push de
	inc hl
	ld a, [hli]
	ld d, [hl]
	call Func_12c4f
	pop de
	pop hl
.asm_12c77
	add hl, de
	dec c
	jr nz, .asm_12c69
	pop de
	pop bc
	pop hl
	ret
