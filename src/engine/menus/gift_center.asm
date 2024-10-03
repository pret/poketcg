PauseMenuParams:
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

PCMenuParams:
	db 10,  0 ; start menu coords
	db 10, 12 ; start menu text box dimensions

	db 12, 2 ; text alignment for InitTextPrinting
	tx PCMenuOptionsText
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
	ld hl, .GiftCenterMenuParams
	farcall InitAndPrintMenu
.loop_input
	call DoFrameIfLCDEnabled
	call HandleMenuInput
	jr nc, .loop_input
	ld a, e
	ld [wSelectedGiftCenterMenuItem], a
	ldh a, [hCurMenuItem]
	cp e
	jr z, .got_choice
	ld a, GIFT_CENTER_MENU_EXIT
.got_choice
	ld [wGiftCenterChoice], a
	push af
	ld hl, .LoadTextPointerFunctionTable
	call JumpToFunctionInTable
	farcall CloseTextBox
	call DoFrameIfLCDEnabled
	pop af
	ret

.LoadTextPointerFunctionTable:
	dw .LoadChoiceTextPointer ; GIFT_CENTER_MENU_SEND_CARD
	dw .LoadChoiceTextPointer ; GIFT_CENTER_MENU_RECEIVE_CARD
	dw .LoadChoiceTextPointer ; GIFT_CENTER_MENU_SEND_DECK
	dw .LoadChoiceTextPointer ; GIFT_CENTER_MENU_RECEIVE_DECK
	dw .stub                  ; GIFT_CENTER_MENU_EXIT

.stub
	ret

.LoadChoiceTextPointer:
	ld a, [wGiftCenterChoice]
	add a
	ld c, a
	ld b, $00
	ld hl, .GiftCenterTextPointers
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	ret

.GiftCenterTextPointers:
	tx SendCardText                 ; GIFT_CENTER_MENU_SEND_CARD
	tx ReceiveCardText              ; GIFT_CENTER_MENU_RECEIVE_CARD
	tx SendDeckConfigurationText    ; GIFT_CENTER_MENU_SEND_DECK
	tx ReceiveDeckConfigurationText ; GIFT_CENTER_MENU_RECEIVE_DECK

.GiftCenterMenuParams:
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
