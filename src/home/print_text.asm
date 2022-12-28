; writes n items of text each given in the following format in hl:
; x coord, y coord, text id
; $ff-terminated
PlaceTextItems::
	ld d, [hl] ; x coord
	inc hl
	bit 7, d
	ret nz ; return if no more items of text
	ld e, [hl] ; y coord
	inc hl ; hl = text id
	call InitTextPrinting
	push hl
	call ProcessTextFromPointerToID
	pop hl
	inc hl
	inc hl
	jr PlaceTextItems ; do next item

; like ProcessTextFromID, except it calls InitTextPrinting first
InitTextPrinting_ProcessTextFromID::
	call InitTextPrinting
	jr ProcessTextFromID

; like ProcessTextFromPointerToID, except it calls InitTextPrinting first
InitTextPrinting_ProcessTextFromPointerToID::
	call InitTextPrinting
;	fallthrough

; like ProcessTextFromID below, except a memory address containing a text ID is
; provided in hl rather than the text ID directly.
ProcessTextFromPointerToID::
	ld a, [hli]
	or [hl]
	ret z
	ld a, [hld]
	ld l, [hl]
	ld h, a
;	fallthrough

; given the ID of a text in hl, reads the characters from it processes them.
; loops until TX_END is found. ignores TX_RAM1, TX_RAM2, and TX_RAM3 characters.
; restores original ROM bank before returning.
ProcessTextFromID::
	ldh a, [hBankROM]
	push af
	call GetTextOffsetFromTextID
	call ProcessText
	pop af
	call BankswitchROM
	ret

; return, in a, the number of lines of the text given in hl as an ID
; this is calculated by counting the amount of '\n' characters and adding 1 to the result
CountLinesOfTextFromID::
	push hl
	push de
	push bc
	ldh a, [hBankROM]
	push af
	call GetTextOffsetFromTextID
	ld c, $00
.char_loop
	ld a, [hli]
	or a ; TX_END
	jr z, .end
	cp TX_CTRL_END
	jr nc, .char_loop
	cp TX_HALFWIDTH
	jr c, .skip
	cp "\n"
	jr nz, .char_loop
	inc c
	jr .char_loop
.skip
	inc hl
	jr .char_loop
.end
	pop af
	call BankswitchROM
	ld a, c
	inc a
	pop bc
	pop de
	pop hl
	ret

; call PrintScrollableText with text box label, then wait for the
; player to press A or B to advance the printed text
PrintScrollableText_WithTextBoxLabel::
	call PrintScrollableText_WithTextBoxLabel_NoWait
	jr WaitForPlayerToAdvanceText

PrintScrollableText_WithTextBoxLabel_NoWait::
	push hl
	ld hl, wTextBoxLabel
	ld [hl], e
	inc hl
	ld [hl], d
	pop hl
	ld a, $01
	jr PrintScrollableText

; call PrintScrollableText with no text box label, then wait for the
; player to press A or B to advance the printed text
PrintScrollableText_NoTextBoxLabel::
	xor a
	call PrintScrollableText
;	fallthrough

; when a text box is full or the text is over, prompt the player to
; press A or B in order to clear the text and print the next lines.
WaitForPlayerToAdvanceText::
	lb bc, SYM_CURSOR_D, SYM_BOX_BOTTOM ; cursor tile, tile behind cursor
	lb de, 18, 17 ; x, y
	call SetCursorParametersForTextBox
	call WaitForButtonAorB
	ret

; draws a text box, and prints the text with id at hl, with letter delay. unlike PrintText,
; PrintScrollableText also supports scrollable text, and prompts the user to press A or B
; to advance the page or close the text. register a determines whether the textbox is
; labeled or not. if labeled, the text id of the label is provided in wTextBoxLabel.
; PrintScrollableText is used mostly for overworld NPC text.
PrintScrollableText::
	ld [wIsTextBoxLabeled], a
	ldh a, [hBankROM]
	push af
	call GetTextOffsetFromTextID
	call DrawTextReadyLabeledOrRegularTextBox
	call ResetTxRam_WriteToTextHeader
.print_char_loop
	ld a, [wTextSpeed]
	ld c, a
	inc c
	jr .go
.nonzero_text_speed
	ld a, [wTextSpeed]
	cp 2
	jr nc, .apply_delay
	; if text speed is 1, pressing b ignores it
	ldh a, [hKeysHeld]
	and B_BUTTON
	jr nz, .skip_delay
.apply_delay
	push bc
	call DoFrame
	pop bc
.go
	dec c
	jr nz, .nonzero_text_speed
.skip_delay
	call ProcessTextHeader
	jr c, .asm_2cc3
	ld a, [wCurTextLine]
	cp 3
	jr c, .print_char_loop
	; two lines of text already printed, so need to advance text
	call WaitForPlayerToAdvanceText
	call DrawTextReadyLabeledOrRegularTextBox
	jr .print_char_loop
.asm_2cc3
	pop af
	call BankswitchROM
	ret

; zero wWhichTextHeader, wWhichTxRam2 and wWhichTxRam3, and set hJapaneseSyllabary to TX_KATAKANA
; fill wTextHeader1 with TX_KATAKANA, wFontWidth, hBankROM, and register bc for the text's pointer.
ResetTxRam_WriteToTextHeader::
	xor a
	ld [wWhichTextHeader], a
	ld [wWhichTxRam2], a
	ld [wWhichTxRam3], a
	ld a, TX_KATAKANA
	ld [hJapaneseSyllabary], a
;	fallthrough

; fill the wTextHeader specified in wWhichTextHeader (0-3) with hJapaneseSyllabary,
; wFontWidth, hBankROM, and register bc for the text's pointer.
WriteToTextHeader::
	push hl
	call GetPointerToTextHeader
	pop bc
	ld a, [hJapaneseSyllabary]
	ld [hli], a
	ld a, [wFontWidth]
	ld [hli], a
	ldh a, [hBankROM]
	ld [hli], a
	ld [hl], c
	inc hl
	ld [hl], b
	ret

; same as WriteToTextHeader, except it then increases wWhichTextHeader to
; set the next text header to the current one (usually, because
; it will soon be written to due to a TX_RAM command).
WriteToTextHeader_MoveToNext::
	call WriteToTextHeader
	ld hl, wWhichTextHeader
	inc [hl]
	ret

; read the wTextHeader specified in wWhichTextHeader (0-3) and use the data to
; populate the corresponding memory addresses. also switch to the text's rombank
; and return the address of the next character in hl.
ReadTextHeader::
	call GetPointerToTextHeader
	ld a, [hli]
	ld [hJapaneseSyllabary], a
	ld a, [hli]
	ld [wFontWidth], a
	ld a, [hli]
	call BankswitchROM
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

; return in hl, the address of the wTextHeader specified in wWhichTextHeader (0-3)
GetPointerToTextHeader::
	ld a, [wWhichTextHeader]
	ld e, a
	add a
	add a
	add e
	ld e, a
	ld d, $0
	ld hl, wTextHeader1
	add hl, de
	ret

; draws a wide text box with or without label depending on wIsTextBoxLabeled
; if labeled, the label's text ID is provided in wTextBoxLabel
; calls InitTextPrintingInTextbox after drawing the text box
DrawTextReadyLabeledOrRegularTextBox::
	push hl
	lb de, 0, 12
	lb bc, 20, 6
	call AdjustCoordinatesForBGScroll
	ld a, [wIsTextBoxLabeled]
	or a
	jr nz, .labeled
	call DrawRegularTextBox
	call EnableLCD
	jr .init_text
.labeled
	ld hl, wTextBoxLabel
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DrawLabeledTextBox
.init_text
	lb de, 1, 14
	call AdjustCoordinatesForBGScroll
	ld a, 19
	call InitTextPrintingInTextbox
	pop hl
	ret

; reads the incoming character from the current wTextHeader and processes it
; then updates the current wTextHeader to point to the next character.
; a TX_RAM command causes a switch to a wTextHeader in the level below, and a TX_END
; command terminates the text unless there is a pending wTextHeader in the above level.
ProcessTextHeader::
	call ReadTextHeader
	ld a, [hli]
	or a ; TX_END
	jr z, .tx_end
	cp TX_CTRL_START
	jr c, .character_pair
	cp TX_CTRL_END
	jr nc, .character_pair
	call ProcessSpecialTextCharacter
	jr nc, .processed_char
	cp TX_RAM1
	jr z, .tx_ram1
	cp TX_RAM2
	jr z, .tx_ram2
	cp TX_RAM3
	jr z, .tx_ram3
	jr .processed_char
.character_pair
	ld e, a ; first char
	ld d, [hl] ; second char
	call ClassifyTextCharacterPair
	jr nc, .not_tx_fullwidth
	inc hl
.not_tx_fullwidth
	call Func_22ca
	xor a
	call ProcessSpecialTextCharacter
.processed_char
	call WriteToTextHeader
	or a
	ret
.tx_end
	ld a, [wWhichTextHeader]
	or a
	jr z, .no_more_text
	; handle text header in the above level
	dec a
	ld [wWhichTextHeader], a
	jr ProcessTextHeader
.no_more_text
	call TerminateHalfWidthText
	scf
	ret
.tx_ram2
	call WriteToTextHeader_MoveToNext
	ld a, TX_KATAKANA
	ld [hJapaneseSyllabary], a
	xor a ; FULL_WIDTH
	ld [wFontWidth], a
	ld de, wTxRam2
	ld hl, wWhichTxRam2
	call HandleTxRam2Or3
	ld a, l
	or h
	jr z, .empty
	call GetTextOffsetFromTextID
	call WriteToTextHeader
	jr ProcessTextHeader
.empty
	ld hl, wDefaultText
	call WriteToTextHeader
	jr ProcessTextHeader
.tx_ram3
	call WriteToTextHeader_MoveToNext
	ld de, wTxRam3
	ld hl, wWhichTxRam3
	call HandleTxRam2Or3
	call TwoByteNumberToText_CountLeadingZeros
	call WriteToTextHeader
	jp ProcessTextHeader
.tx_ram1
	call WriteToTextHeader_MoveToNext
	call CopyPlayerNameOrTurnDuelistName
	ld a, [wStringBuffer]
	cp TX_HALFWIDTH
	jr z, .tx_halfwidth
	ld a, TX_HALF2FULL
	call ProcessSpecialTextCharacter
.tx_halfwidth
	call WriteToTextHeader
	jp ProcessTextHeader

; input:
  ; de: wTxRam2 or wTxRam3
  ; hl: wWhichTxRam2 or wWhichTxRam3
; return, in hl, the contents of the contents of the
; wTxRam* buffer's current entry, and increment wWhichTxRam*.
HandleTxRam2Or3::
	push de
	ld a, [hl]
	inc [hl]
	add a
	ld e, a
	ld d, $0
	pop hl
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

; uses the two byte text id in hl to read the three byte text offset
; loads the correct bank for the specific text and returns the pointer in hl
GetTextOffsetFromTextID::
	push de
	ld e, l
	ld d, h
	add hl, hl
	add hl, de
	set 6, h ; hl = (hl * 3) + $4000
	ld a, BANK(TextOffsets)
	call BankswitchROM
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hl]
	ld h, d
	rl h
	rla
	rl h
	rla
	add BANK(TextOffsets)
	call BankswitchROM
	res 7, d
	set 6, d ; $4000 ≤ de ≤ $7fff
	ld l, e
	ld h, d
	pop de
	ret

; if [wFontWidth] == HALF_WIDTH:
;   convert the number at hl to text (ascii) format and write it to wStringBuffer
;   return c = 4 - leading_zeros
; if [wFontWidth] == FULL_WIDTH:
;   convert the number at hl to TX_SYMBOL text format and write it to wStringBuffer
;   replace leading zeros with SYM_SPACE
TwoByteNumberToText_CountLeadingZeros::
	ld a, [wFontWidth]
	or a ; FULL_WIDTH
	jp z, TwoByteNumberToTxSymbol_TrimLeadingZeros
	ld de, wStringBuffer
	push de
	call TwoByteNumberToText
	pop hl
	ld c, 4
.digit_loop
	ld a, [hl]
	cp "0"
	ret nz
	inc hl
	dec c
	jr nz, .digit_loop
	ret

; in the overworld: copy the player's name to wStringBuffer
; in a duel: copy the name of the duelist whose turn it is to wStringBuffer
CopyPlayerNameOrTurnDuelistName::
	ld de, wStringBuffer
	push de
	ldh a, [hWhoseTurn]
	cp OPPONENT_TURN
	jp z, .opponent_turn
	call CopyPlayerName
	pop hl
	ret
.opponent_turn
	call CopyOpponentName
	pop hl
	ret

; prints text with id at hl, with letter delay, in a textbox area.
; the text must fit in the textbox; PrintScrollableText should be used instead.
PrintText::
	ld a, l
	or h
	jr z, .from_ram
	ldh a, [hBankROM]
	push af
	call GetTextOffsetFromTextID
	call .print_text
	pop af
	call BankswitchROM
	ret
.from_ram
	ld hl, wDefaultText
.print_text
	call ResetTxRam_WriteToTextHeader
.next_tile_loop
	ldh a, [hKeysHeld]
	ld b, a
	ld a, [wTextSpeed]
	inc a
	cp 3
	jr nc, .apply_delay
	; if text speed is 1, pressing b ignores it
	bit B_BUTTON_F, b
	jr nz, .skip_delay
	jr .apply_delay
.text_delay_loop
	; wait a number of frames equal to [wTextSpeed] between printing each text tile
	call DoFrame
.apply_delay
	dec a
	jr nz, .text_delay_loop
.skip_delay
	call ProcessTextHeader
	jr nc, .next_tile_loop
	ret

; prints text with id at hl, without letter delay, in a textbox area.
; the text must fit in the textbox; PrintScrollableText should be used instead.
PrintTextNoDelay::
	ldh a, [hBankROM]
	push af
	call GetTextOffsetFromTextID
	call ResetTxRam_WriteToTextHeader
.next_tile_loop
	call ProcessTextHeader
	jr nc, .next_tile_loop
	pop af
	call BankswitchROM
	ret

; copies a text given its id at hl, to de
; if hl is 0, the name of the turn duelist is copied instead
CopyText::
	ld a, l
	or h
	jr z, .special
	ldh a, [hBankROM]
	push af
	call GetTextOffsetFromTextID
.next_tile_loop
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, .next_tile_loop
	pop af
	call BankswitchROM
	dec de
	ret
.special
	ldh a, [hWhoseTurn]
	cp OPPONENT_TURN
	jp z, CopyOpponentName
	jp CopyPlayerName

; copy text of maximum length a (in tiles) from its ID at hl to de,
; then terminate the text with TX_END if it doesn't contain it already.
; fill any remaining bytes with spaces plus TX_END to match the length specified in a.
; return the text's actual length in characters (i.e. before the first TX_END) in e.
CopyTextData_FromTextID::
	ldh [hff96], a
	ldh a, [hBankROM]
	push af
	call GetTextOffsetFromTextID
	ldh a, [hff96]
	call CopyTextData
	pop af
	call BankswitchROM
	ret

; text id (usually of a card name) for TX_RAM2
LoadTxRam2::
	ld a, l
	ld [wTxRam2], a
	ld a, h
	ld [wTxRam2 + 1], a
	ret

; a number between 0 and 65535 for TX_RAM3
LoadTxRam3::
	ld a, l
	ld [wTxRam3], a
	ld a, h
	ld [wTxRam3 + 1], a
	ret
