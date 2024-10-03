_PauseMenu_Config:
	ld a, [wd291]
	push af
	ld a, [wLineSeparation]
	push af
	xor a
	ld [wConfigExitSettingsCursorPos], a
	ld a, SINGLE_SPACED
	ld [wLineSeparation], a
	call InitMenuScreen
	lb de,  0,  3
	lb bc, 20,  5
	call DrawRegularTextBox
	lb de,  0,  9
	lb bc, 20,  5
	call DrawRegularTextBox
	ld hl, ConfigScreenLabels
	call PrintLabels
	call GetConfigCursorPositions
	ld a, 0
	call ShowConfigMenuCursor
	ld a, 1
	call ShowConfigMenuCursor
	xor a
	ld [wCursorBlinkTimer], a
	call FlashWhiteScreen
.asm_10588
	call DoFrameIfLCDEnabled
	ld a, [wConfigCursorYPos]
	call UpdateConfigMenuCursor
	ld hl, wCursorBlinkTimer
	inc [hl]
	call ConfigScreenHandleDPadInput
	ldh a, [hKeysPressed]
	and B_BUTTON | START
	jr nz, .asm_105ab
	ld a, [wConfigCursorYPos]
	cp $02
	jr nz, .asm_10588
	ldh a, [hKeysPressed]
	and A_BUTTON
	jr z, .asm_10588
.asm_105ab
	ld a, SFX_CONFIRM
	call PlaySFX
	call SaveConfigSettings
	pop af
	ld [wLineSeparation], a
	pop af
	ld [wd291], a
	ret

ConfigScreenLabels:
	db 1, 1
	tx ConfigMenuTitleText

	db 1, 4
	tx ConfigMenuMessageSpeedText

	db 1, 10
	tx ConfigMenuDuelAnimationText

	db 1, 16
	tx ConfigMenuExitText

	db $ff

; checks the current saved configuration settings
; and sets wConfigMessageSpeedCursorPos and wConfigDuelAnimationCursorPos
; to the right positions for those values
GetConfigCursorPositions:
	call EnableSRAM
	ld c, 0
	ld hl, TextDelaySettings
.loop
	ld a, [sTextSpeed]
	cp [hl]
	jr nc, .match
	inc hl
	inc c
	ld a, c
	cp 4
	jr c, .loop
.match
	ld a, c
	ld [wConfigMessageSpeedCursorPos], a
	ld a, [sSkipDelayAllowed]
	and $1
	rlca
	ld c, a
	ld a, [wAnimationsDisabled]
	and $1
	or c
	ld c, a
	ld b, $00
	ld hl, DuelAnimationSettingsIndices
	add hl, bc
	ld a, [hl]
	ld [wConfigDuelAnimationCursorPos], a
	call DisableSRAM
	ret

; indexes into DuelAnimationSettings
; 0: show all
; 1: skip some
; 2: none
DuelAnimationSettingsIndices:
	db 0 ; skip delay allowed = false, animations disabled = false
	db 0 ; skip delay allowed = false, animations disabled = true (unused)
	db 1 ; skip delay allowed = true, animations disabled = false
	db 2 ; skip delay allowed = true, animations disabled = true

SaveConfigSettings:
	call EnableSRAM
	ld a, [wConfigDuelAnimationCursorPos]
	and %11
	rlca
	ld c, a
	ld b, $00
	ld hl, DuelAnimationSettings
	add hl, bc
	ld a, [hli]
	ld [wAnimationsDisabled], a
	ld [sAnimationsDisabled], a
	ld a, [hl]
	ld [sSkipDelayAllowed], a
	call DisableSRAM
	ld a, [wConfigMessageSpeedCursorPos]
	ld c, a
	ld b, $00
	ld hl, TextDelaySettings
	add hl, bc
	call EnableSRAM
	ld a, [hl]
	ld [sTextSpeed], a
	ld [wTextSpeed], a
	call DisableSRAM
	ret

DuelAnimationSettings:
; animation disabled, skip delay allowed
	db FALSE, FALSE ; show all
	db FALSE, TRUE  ; skip some
	db TRUE,  TRUE  ; none
	db FALSE, FALSE ; unused

; text printing delay
TextDelaySettings:
	; slow to fast
	db 6, 4, 2, 1, 0

UpdateConfigMenuCursor:
	push af
	ld a, [wCursorBlinkTimer]
	and $10
	jr z, .show
	pop af
	jr HideConfigMenuCursor
.show
	pop af
	jr ShowConfigMenuCursor ; can be fallthrough

ShowConfigMenuCursor:
	push bc
	ld c, a
	ld a, SYM_CURSOR_R
	call DrawConfigMenuCursor
	pop bc
	ret

HideConfigMenuCursor:
	push bc
	ld c, a
	ld a, SYM_SPACE
	call DrawConfigMenuCursor
	pop bc
	ret

DrawConfigMenuCursor:
	push af
	sla c
	ld b, $00
	ld hl, ConfigScreenCursorPositions
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [bc]
	add a
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	pop af
	call WriteByteToBGMap0
	ret

ConfigScreenCursorPositions:
	dw MessageSpeedCursorPositions
	dw DuelAnimationsCursorPositions
	dw ExitSettingsCursorPosition

MessageSpeedCursorPositions:
	dw wConfigMessageSpeedCursorPos
	db  5, 6
	db  7, 6
	db  9, 6
	db 11, 6
	db 13, 6

DuelAnimationsCursorPositions:
	dw wConfigDuelAnimationCursorPos
	db  1, 12
	db  7, 12
	db 15, 12

ExitSettingsCursorPosition:
	dw wConfigExitSettingsCursorPos
	db 1, 16

	db 0

ConfigScreenHandleDPadInput:
	ldh a, [hDPadHeld]
	and D_PAD
	ret z
	farcall GetDirectionFromDPad
	ld hl, ConfigScreenDPadHandlers
	jp JumpToFunctionInTable

ConfigScreenDPadHandlers:
	dw ConfigScreenDPadUp ; up
	dw ConfigScreenDPadRight ; right
	dw ConfigScreenDPadDown ; down
	dw ConfigScreenDPadLeft ; left

ConfigScreenDPadUp:
	ld a, -1
	jr ConfigScreenDPadDown.up_or_down

ConfigScreenDPadDown:
	ld a, 1
.up_or_down
	push af
	ld a, [wConfigCursorYPos]
	cp 2
	jr z, .hide_cursor
	call ShowConfigMenuCursor
	jr .skip
.hide_cursor
; hide "exit settings" cursor if leaving bottom row
	call HideConfigMenuCursor
.skip
	ld a, [wConfigCursorYPos]
	ld b, a
	pop af
	add b
	cp 3
	jr c, .valid
	jr z, .wrap_min
; wrap max
	ld a, 2 ; max
	jr .valid
.wrap_min
	xor a ; min
.valid
	ld [wConfigCursorYPos], a
	ld c, a
	ld b, 0
	ld hl, Unknown_106ff
	add hl, bc
	ld a, [hl]
	ld [wCursorBlinkTimer], a
	ld a, [wConfigCursorYPos]
	call UpdateConfigMenuCursor
	ld a, SFX_CURSOR
	call PlaySFX
	ret

Unknown_106ff:
	db $18 ; message speed, start hidden
	db $18 ; duel animation, start hidden
	db $8 ; exit settings, start visible

ConfigScreenDPadRight:
	ld a, 1
	jr ConfigScreenDPadLeft.left_or_right

ConfigScreenDPadLeft:
	ld a, -1
.left_or_right
	push af
	ld a, [wConfigCursorYPos]
	call HideConfigMenuCursor
	pop af
	call .ApplyPosChange
	ld a, [wConfigCursorYPos]
	call ShowConfigMenuCursor
	xor a
	ld [wCursorBlinkTimer], a
	ret

; a = 1 for right, -1 for left
.ApplyPosChange
	push af
	ld a, [wConfigCursorYPos]
	ld c, a
	add a
	add c ; *3
	ld c, a
	ld b, $00
	ld hl, .MaxCursorPositions
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld c, [hl] ; max value
	ld a, [de]
	ld b, a
	pop af
	add b ; apply pos change
	cp c
	jr c, .got_new_pos
	jr z, .got_new_pos
	cp $80
	jr c, .wrap_around
	; wrap to last
	ld a, c
	jr .got_new_pos
.wrap_around
	; wrap to first
	xor a
.got_new_pos
	ld [de], a
	ld a, c
	or a
	jr z, .skip_sfx
	ld a, SFX_CURSOR
	call PlaySFX
.skip_sfx
	ret

.MaxCursorPositions:
; x pos variable, max x value
	dwb wConfigMessageSpeedCursorPos,  4
	dwb wConfigDuelAnimationCursorPos, 2
	dwb wConfigExitSettingsCursorPos,  0
