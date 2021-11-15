; prints $ff-terminated list of text to text box
; given 2 bytes for text alignment and 2 bytes for text ID
PrintLabels:
	ldh a, [hffb0]
	push af
	ld a, $02
	ldh [hffb0], a

	push hl
.loop_text_print_1
	ld d, [hl]
	inc hl
	bit 7, d
	jr nz, .next
	inc hl
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call PrintTextNoDelay
	pop hl
	inc hl
	jr .loop_text_print_1

.next
	pop hl
	pop af
	ldh [hffb0], a
.loop_text_print_2
	ld d, [hl]
	inc hl
	bit 7, d
	ret nz
	ld e, [hl]
	inc hl
	call AdjustCoordinatesForBGScroll
	call InitTextPrinting
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call PrintTextNoDelay
	pop hl
	inc hl
	jr .loop_text_print_2

InitAndPrintMenu:
	push hl
	push bc
	push de
	push af
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	push hl
	call AdjustCoordinatesForBGScroll
	farcall Func_c3ca
	call DrawRegularTextBox
	call DoFrameIfLCDEnabled
	pop hl
	call PrintLabels
	pop af
	call InitializeMenuParameters
	pop de
	pop bc
	pop hl
	ret
