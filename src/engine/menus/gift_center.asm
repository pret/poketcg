Unknown_10d98:
	db 12,  0 ; start menu coords
	db  8, 14 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx PauseMenuOptionsText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 6 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_10da9:
	db 10,  0 ; start menu coords
	db 10, 12 ; start menu text box dimensions

	db 12, 2 ; text alignment for InitTextPrinting
	tx Text0351
	db $ff

	db 11, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

GiftCenterMenu:
	ld a, 1 << AUTO_CLOSE_TEXTBOX
	farcall SetOverworldNPCFlags
	ld a, [wSelectedGiftCenterMenuItem]
	ld hl, Unknown_10e17
	farcall InitAndPrintMenu
.loop_input
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .loop_input
	ld a, e
	ld [wSelectedGiftCenterMenuItem], a
	ldh a, [hCurMenuItem]
	cp e
	jr z, .asm_10ddd
	ld a, $4

.asm_10ddd
	ld [wd10e], a
	push af
	ld hl, Unknown_10df0
	call JumpToFunctionInTable
	farcall CloseTextBox
	call DoFrameIfLCDEnabled
	pop af
	ret

Unknown_10df0:
	dw Func_10dfb
	dw Func_10dfb
	dw Func_10dfb
	dw Func_10dfb
	dw Func_10dfa

Func_10dfa:
	ret

Func_10dfb:
	ld a, [wd10e]
	add a
	ld c, a
	ld b, $00
	ld hl, Unknown_10e0f
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	ret

Unknown_10e0f:
	tx SendCardText
	tx ReceiveCardText
	tx SendDeckConfigurationText
	tx ReceiveDeckConfigurationText

Unknown_10e17:
	db  4,  0 ; start menu coords
	db 16, 12 ; start menu text box dimensions

	db  6, 2 ; text alignment for InitTextPrinting
	tx GiftCenterMenuText
	db $ff

	db 5, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0
