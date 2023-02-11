; initializes a screen animation from wTempAnimation
; loads a function pointer for updating a frame
; and initializes the duration of the animation.
InitScreenAnimation:
	ld a, [wAnimationsDisabled]
	or a
	jr nz, .skip
	ld a, [wTempAnimation]
	ld [wActiveScreenAnim], a
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

; for the following animations, these functions
; are run with the corresponding duration.
; this duration decides different effects,
; depending on which function runs
; and is decreased by one each time.
; when it is down to 0, the animation is done.

MACRO screen_effect
	dw \1 ; function pointer
	db \2 ; duration
	db $00 ; padding
ENDM

Data_1cc9f:
; function pointer, duration
	screen_effect ShakeScreenX_Small, 24 ; DUEL_ANIM_SMALL_SHAKE_X
	screen_effect ShakeScreenX_Big,   32 ; DUEL_ANIM_BIG_SHAKE_X
	screen_effect ShakeScreenY_Small, 24 ; DUEL_ANIM_SMALL_SHAKE_Y
	screen_effect ShakeScreenY_Big,   32 ; DUEL_ANIM_BIG_SHAKE_Y
	screen_effect WhiteFlashScreen,    8 ; DUEL_ANIM_FLASH
	screen_effect DistortScreen,      63 ; DUEL_ANIM_DISTORT

; checks if screen animation duration is over
; and if so, loads the default update function
LoadDefaultScreenAnimationUpdateWhenFinished:
	ld a, [wScreenAnimDuration]
	or a
	ret nz
	; fallthrough

; function called for the screen animation update when it is over
DefaultScreenAnimationUpdate:
	ld a, $ff
	ld [wActiveScreenAnim], a
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

; runs the screen update function set in wScreenAnimUpdatePtr
DoScreenAnimationUpdate:
	ld a, 1
	ld [wScreenAnimDuration], a
	ld hl, wScreenAnimUpdatePtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CallHL2
	jr DefaultScreenAnimationUpdate

ShakeScreenX_Small:
	ld hl, SmallShakeOffsets
	jr ShakeScreenX

ShakeScreenX_Big:
	ld hl, BigShakeOffsets
	jr ShakeScreenX

ShakeScreenX:
	ld a, l
	ld [wScreenShakeOffsetsPtr], a
	ld a, h
	ld [wScreenShakeOffsetsPtr + 1], a
	ld hl, wScreenAnimUpdatePtr
	ld [hl], LOW(.Update)
	inc hl
	ld [hl], HIGH(.Update)
	ret

.Update
	call DecrementScreenAnimDuration
	call UpdateShakeOffset
	jp nc, LoadDefaultScreenAnimationUpdateWhenFinished
	ldh a, [hSCX]
	add [hl]
	ldh [hSCX], a
	jp LoadDefaultScreenAnimationUpdateWhenFinished

ShakeScreenY_Small:
	ld hl, SmallShakeOffsets
	jr ShakeScreenY

ShakeScreenY_Big:
	ld hl, BigShakeOffsets
	jr ShakeScreenY

ShakeScreenY:
	ld a, l
	ld [wScreenShakeOffsetsPtr], a
	ld a, h
	ld [wScreenShakeOffsetsPtr + 1], a
	ld hl, wScreenAnimUpdatePtr
	ld [hl], LOW(.Update)
	inc hl
	ld [hl], HIGH(.Update)
	ret

.Update
	call DecrementScreenAnimDuration
	call UpdateShakeOffset
	jp nc, LoadDefaultScreenAnimationUpdateWhenFinished
	ldh a, [hSCY]
	add [hl]
	ldh [hSCY], a
	jp LoadDefaultScreenAnimationUpdateWhenFinished

; get the displacement of the current frame
; depending on the value of wScreenAnimDuration
; returns carry if displacement was updated
UpdateShakeOffset:
	ld hl, wScreenShakeOffsetsPtr
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
	ld [wScreenShakeOffsetsPtr], a
	ld a, h
	ld [wScreenShakeOffsetsPtr + 1], a
	pop hl
	scf
	ret

SmallShakeOffsets:
; timer, offset
	db 21,  2
	db 17, -2
	db 13,  2
	db  9, -2
	db  5,  1
	db  1, -1

BigShakeOffsets:
; timer, offset
	db 29,  4
	db 25, -4
	db 21,  4
	db 17, -4
	db 13,  3
	db  9, -3
	db  5,  2
	db  1, -2

DecrementScreenAnimDuration:
	ld hl, wScreenAnimDuration
	dec [hl]
	ret

WhiteFlashScreen:
	ld hl, wScreenAnimUpdatePtr
	ld [hl], LOW(.Update)
	inc hl
	ld [hl], HIGH(.Update)
	ld a, [wBGP]
	ld [wTempWhiteFlashBGP], a
	; backup the current background pals
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	ld de, PALRGB_WHITE
	ld hl, wBackgroundPalettesCGB
	ld bc, (8 palettes) / 2
	call FillMemoryWithDE
	xor a
	call SetBGP
	call FlushAllPalettes

.Update
	call DecrementScreenAnimDuration
	ld a, [wScreenAnimDuration]
	or a
	ret nz
	; retrieve the previous background pals
	ld hl, wTempBackgroundPalettesCGB
	ld de, wBackgroundPalettesCGB
	ld bc, 8 palettes
	call CopyDataHLtoDE_SaveRegisters
	ld a, [wTempWhiteFlashBGP]
	call SetBGP
	call FlushAllPalettes
	jp DefaultScreenAnimationUpdate

DistortScreen:
	ld hl, wScreenAnimUpdatePtr
	ld [hl], LOW(.Update)
	inc hl
	ld [hl], HIGH(.Update)
	xor a
	ld [wApplyBGScroll], a
	ld hl, wLCDCFunctionTrampoline + 1
	ld [hl], LOW(ApplyBackgroundScroll)
	inc hl
	ld [hl], HIGH(ApplyBackgroundScroll)
	ld a, 1
	ld [wBGScrollMod], a
	call EnableInt_LYCoincidence

.Update
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

Func_1ce03:
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
