; handle player input in check menu
; works out which cursor coordinate to go to
; and sets carry flag if A or B are pressed
; returns a =  $1 if A pressed
; returns a = $ff if B pressed
HandleCheckMenuInput:
	xor a
	ld [wMenuInputSFX], a
	ld a, [wCheckMenuCursorXPosition]
	ld d, a
	ld a, [wCheckMenuCursorYPosition]
	ld e, a

; d = cursor x position
; e = cursor y position

	ldh a, [hDPadHeld]
	or a
	jr z, .no_pad
	bit B_PAD_LEFT, a
	jr nz, .horizontal
	bit B_PAD_RIGHT, a
	jr z, .check_vertical

; handle horizontal input
.horizontal
	ld a, d
	xor $1 ; flips x coordinate
	ld d, a
	jr .okay
.check_vertical
	bit B_PAD_UP, a
	jr nz, .vertical
	bit B_PAD_DOWN, a
	jr z, .no_pad

; handle vertical input
.vertical
	ld a, e
	xor $01 ; flips y coordinate
	ld e, a

.okay
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
	push de
	call EraseCheckMenuCursor
	pop de

; update x and y cursor positions
	ld a, d
	ld [wCheckMenuCursorXPosition], a
	ld a, e
	ld [wCheckMenuCursorYPosition], a

; reset cursor blink
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
.no_pad
	ldh a, [hKeysPressed]
	and PAD_A | PAD_B
	jr z, .no_input
	and PAD_A
	jr nz, .a_press
	ld a, MENU_CANCEL
	call PlaySFXConfirmOrCancel
	scf
	ret

.a_press
	call DisplayCheckMenuCursor
	ld a, MENU_CONFIRM
	call PlaySFXConfirmOrCancel
	scf
	ret

.no_input
	ld a, [wMenuInputSFX]
	or a
	jr z, .check_blink
	call PlaySFX

.check_blink
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and CURSOR_BLINK_PERIOD_MASK
	ret nz

	ld a, SYM_CURSOR_R ; cursor byte
	bit B_CURSOR_BLINK_PERIOD, [hl]
	jr z, DrawCheckMenuCursor

; draws in the cursor position
EraseCheckMenuCursor:
	ld a, SYM_SPACE ; empty cursor
; fallthrough

; draws in the cursor position
; input:
; a = tile byte to draw
DrawCheckMenuCursor:
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
	call WriteByteToBGMap0
	or a
	ret

DisplayCheckMenuCursor:
	ld a, SYM_CURSOR_R
	jr DrawCheckMenuCursor

; play cancel sound if a = MENU_CANCEL (-1), confirm sound otherwise
; preserves all registers
; input:
; a = MENU_CANCEL (usually following B press) or MENU_CONFIRM (usually following A press)
PlaySFXConfirmOrCancel:
	push af
	inc a
	jr z, .cancel_sfx
; confirm
	ld a, SFX_CONFIRM
	jr .play_sfx
.cancel_sfx
	ld a, SFX_CANCEL
.play_sfx
	call PlaySFX
	pop af
	ret
