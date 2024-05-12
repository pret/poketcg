Func_18661: ; unreferenced
	xor a
	ld [wMenuInputSFX], a
	ld a, [wCheckMenuCursorXPosition]
	ld d, a
	ld a, [wCheckMenuCursorYPosition]
	ld e, a
	ldh a, [hDPadHeld]
	or a
	jr z, .check_button
; check input from dpad
	bit D_LEFT_F, a
	jr nz, .left_or_right
	bit D_RIGHT_F, a
	jr z, .check_up_and_down
.left_or_right
; swap the lsb of x position value.
	ld a, d
	xor $1
	ld d, a
	jr .cursor_moved

.check_up_and_down
	bit D_UP_F, a
	jr nz, .up_or_down
	bit D_DOWN_F, a
	jr z, .check_button
.up_or_down
	ld a, e
	xor $1
	ld e, a
.cursor_moved
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	push de
	call .draw_blank_cursor
	pop de
	ld a, d
	ld [wCheckMenuCursorXPosition], a
	ld a, e
	ld [wCheckMenuCursorYPosition], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
.check_button
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .check_cursor_moved
	and A_BUTTON
	jr nz, .a_button

; b button
	ld a, -1
	call Func_190fb
	scf
	ret

; a button
.a_button
	call .draw_cursor
	ld a, 1
	call Func_190fb
	scf
	ret

.check_cursor_moved
	ld a, [wMenuInputSFX]
	or a
	jr z, .check_cursor_blink
	call PlaySFX
.check_cursor_blink
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and %00001111
	ret nz
	ld a, SYM_CURSOR_R
	bit D_RIGHT_F, [hl]
	jr z, .draw_tile
.draw_blank_cursor
	ld a, SYM_SPACE
.draw_tile
	ld e, a
	ld a, 10
	ld l, a
	ld a, [wCheckMenuCursorXPosition]
	ld h, a
	call HtimesL
	ld a, l
	add 1
	ld b, a
	ld a, [wCheckMenuCursorYPosition]
	sla a
	add 14
	ld c, a
	ld a, e
	; b = 11, c = y_pos * 2 + 14
	; h = x_pos * 10, l = 10
	call WriteByteToBGMap0
	or a
	ret
.draw_cursor
	ld a, SYM_CURSOR_R
	jr .draw_tile
