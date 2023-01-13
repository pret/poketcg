; return nc if wActiveScreenAnim, wd4c0, and wAnimationQueue[] are all equal to $ff
; nc means no animation is playing (or animation(s) has/have ended)
CheckAnyAnimationPlaying::
	push hl
	push bc
	ld a, [wActiveScreenAnim]
	ld hl, wd4c0
	and [hl]
	ld hl, wAnimationQueue
	ld c, ANIMATION_QUEUE_LENGTH
.loop
	and [hl]
	inc hl
	dec c
	jr nz, .loop
	cp $ff
	pop bc
	pop hl
	ret

; plays duel animation
; the animations are loaded to a buffer
; and played in order, so they can be stacked
; input:
; - a = animation index
PlayDuelAnimation::
	ld [wTempAnimation], a ; hold an animation temporarily
	ldh a, [hBankROM]
	push af
	ld [wDuelAnimReturnBank], a

	push hl
	push bc
	push de
	ld a, BANK(LoadDuelAnimationToBuffer)
	call BankswitchROM
	ld a, [wTempAnimation]
	cp DUEL_SPECIAL_ANIMS
	jr nc, .load_buffer

	ld hl, wDuelAnimBufferSize
	ld a, [wDuelAnimBufferCurPos]
	cp [hl]
	jr nz, .load_buffer
	call CheckAnyAnimationPlaying
	jr nc, .play_anim

.load_buffer
	call LoadDuelAnimationToBuffer
	jr .done

.play_anim
	call PlayLoadedDuelAnimation
	jr .done

.done
	pop de
	pop bc
	pop hl
	pop af
	call BankswitchROM
	ret

UpdateQueuedAnimations::
	ldh a, [hBankROM]
	push af
	ld a, BANK(_UpdateQueuedAnimations)
	call BankswitchROM
	call _UpdateQueuedAnimations
	call HandleAllSpriteAnimations
	pop af
	call BankswitchROM
	ret

Func_3bb5::
	xor a
	ld [wd4c0], a
	ldh a, [hBankROM]
	push af
	ld a, [wDuelAnimReturnBank]
	call BankswitchROM
	call HandleAllSpriteAnimations
	call CallHL2
	pop af
	call BankswitchROM
	ld a, $80
	ld [wd4c0], a
	ret

; writes from hl the pointer to the function to be called by DoFrame
SetDoFrameFunction::
	ld a, l
	ld [wDoFrameFunction], a
	ld a, h
	ld [wDoFrameFunction + 1], a
	ret

ResetDoFrameFunction::
	push hl
	ld hl, NULL
	call SetDoFrameFunction
	pop hl
	ret
