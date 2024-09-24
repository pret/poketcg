WhatIsYourNameData:
	textitem 1, 1, WhatIsYourNameText
	db $ff
; [Deck1Data ~ Deck4Data]
; These are directed from InputCurDeckName,
; without any bank description.
; That is, the developers hard-coded it. -_-;;
Deck1Data:
	textitem 2, 1, Deck1Text
	textitem 14, 1, DeckText
	db $ff
Deck2Data:
	textitem 2, 1, Deck2Text
	textitem 14, 1, DeckText
	db $ff
Deck3Data:
	textitem 2, 1, Deck3Text
	textitem 14, 1, DeckText
	db $ff
Deck4Data:
	textitem 2, 1, Deck4Text
	textitem 14, 1, DeckText
	db $ff

; zeroes a bytes starting from hl.
; this function is identical to 'ClearMemory_Bank2',
; 'ClearMemory_Bank5' and 'ClearMemory_Bank8'.
; preserves all registers
; input:
;	a = number of bytes to clear
;	hl = where to begin erasing
ClearMemory_Bank6:
	push af
	push bc
	push hl
	ld b, a
	xor a
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	pop hl
	pop bc
	pop af
	ret

; plays a sound effect depending on the value in a.
; this function is identical to 'PlaySFXConfirmOrCancel' in Bank $2.
; preserves all registers
; input:
;	a == -1:  play SFX_CANCEL  (usually following a B press)
;	a != -1:  play SFX_CONFIRM (usually following an A press)
PlaySFXConfirmOrCancel_Bank6:
	push af
	inc a
	jr z, .cancel_sfx
	ld a, SFX_CONFIRM
	jr .play_sfx
.cancel_sfx
	ld a, SFX_CANCEL
.play_sfx
	call PlaySFX
	pop af
	ret

; gets the Player's name from user input and stores it in [hl].
; input:
;	hl = where to store the name (wNameBuffer)
InputPlayerName:
	ld e, l
	ld d, h
	ld a, MAX_PLAYER_NAME_LENGTH
	ld hl, WhatIsYourNameData
	lb bc, 12, 1
	call InitializeInputName
	call Set_OBJ_8x8
	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	call ZeroObjectPositions
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont
	lb de, $38, $bf
	call SetupText
	call LoadTextCursorTile
	ld a, $02
	ld [wd009], a
	call DrawPlayerNamingScreenBG
	xor a
	ld [wNamingScreenCursorX], a
	ld [wNamingScreenCursorY], a
	ld a, $09
	ld [wNamingScreenNumColumns], a
	ld a, $06
	ld [wNamingScreenKeyboardHeight], a
	ld a, $0f
	ld [wVisibleCursorTile], a
	ld a, $00
	ld [wInvisibleCursorTile], a
.loop
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame
	call UpdateRNGSources
	ldh a, [hDPadHeld]
	and START
	jr z, .else
	; the Start button was pressed.
	ld a, $01
	call PlaySFXConfirmOrCancel_Bank6
	call PlayerNamingScreen_DrawInvisibleCursor
	ld a, 6
	ld [wNamingScreenCursorX], a
	ld a, 5
	ld [wNamingScreenCursorY], a
	call PlayerNamingScreen_DrawVisibleCursor
	jr .loop

.else
	call PlayerNamingScreen_CheckButtonState
	jr nc, .loop ; if not pressed, go back to the loop.
	cp -1
	jr z, .on_b_button
	; on A button
	call PlayerNamingScreen_ProcessInput
	jr nc, .loop
	; player selected the "End" button.
	call FinalizeInputName ; can be jr (delete ret)
	ret

.on_b_button
	ld a, [wNamingScreenBufferLength]
	or a
	jr z, .loop ; empty string?
	; erase one character.
	ld e, a
	ld d, 0
	ld hl, wNamingScreenBuffer
	add hl, de
	dec hl
	dec hl
	ld [hl], TX_END
	ld hl, wNamingScreenBufferLength ; note that its unit is byte, not word.
	dec [hl]
	dec [hl]
	call PrintPlayerNameFromInput
	jr .loop

; called when the Player is asked to name something (either the protagonist or a deck)
; input:
;	a = maximum length of a name
;	bc = coordinates at which to begin printing the name
;	de = where to store the name
;	hl = pointer for text items
InitializeInputName:
	ld [wNamingScreenBufferMaxLength], a
	push hl
	ld hl, wNamingScreenNamePosition
	ld [hl], b
	inc hl
	ld [hl], c
	pop hl
	ld b, h
	ld c, l
	; set the question string.
	ld hl, wNamingScreenQuestionPointer
	ld [hl], c
	inc hl
	ld [hl], b
	; set the destination buffer.
	ld hl, wNamingScreenDestPointer
	ld [hl], e
	inc hl
	ld [hl], d
	; clear the name buffer.
	ld a, NAMING_SCREEN_BUFFER_LENGTH
	ld hl, wNamingScreenBuffer
	call ClearMemory_Bank6
	ld hl, wNamingScreenBuffer
	ld a, [wNamingScreenBufferMaxLength]
	ld b, a
	inc b
.loop
	; copy b bytes of data from de to hl.
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .loop
	ld hl, wNamingScreenBuffer
	call GetTextLengthInTiles
	ld a, c
	ld [wNamingScreenBufferLength], a
	ret

FinalizeInputName:
	ld hl, wNamingScreenDestPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld l, e
	ld h, d
	ld de, wNamingScreenBuffer
	ld a, [wNamingScreenBufferMaxLength]
	ld b, a
	inc b
	jr InitializeInputName.loop

; draws the player naming keyboard and prints the question, if it exists.
; this function is very similar to 'DrawDeckNamingScreenBG'.
; input:
;	[wNamingScreenQuestionPointer] = pointer for text data (2 bytes)
DrawPlayerNamingScreenBG:
	call DrawTextboxForKeyboard
	call PrintPlayerNameFromInput
	ld hl, wNamingScreenQuestionPointer
	ld c, [hl]
	inc hl
	ld a, [hl]
	ld h, a
	or c
	jr z, .put_text_end
	; print the question string.
	; ex) "What is your name?"
	ld l, c
	call PlaceTextItems
.put_text_end
	; print "End".
	ld hl, .data
	call PlaceTextItems
	; print the keyboard characters.
	ldtx hl, PlayerNameKeyboardText
	lb de, 2, 4
	call InitTextPrinting
	call ProcessTextFromID
	call EnableLCD
	ret
.data
	textitem $0f, $10, EndText ; "End"
	db $ff

; draws the keyboard frame
DrawTextboxForKeyboard:
	lb de, 0, 3 ; x, y
	lb bc, 20, 15 ; w, h
	call DrawRegularTextBox
	ret

; this is called when naming the player character.
; it's similar to 'PrintDeckNameFromInput'.
; preserves bc
; input:
;	[wNamingScreenNamePosition] = screen coordinates for printing (2 bytes)
;	[wNamingScreenBufferMaxLength] = MAX_PLAYER_NAME_LENGTH
;	[wNamingScreenBuffer] = name generated from keyboard input (up to 24 bytes)
PrintPlayerNameFromInput:
	ld hl, wNamingScreenNamePosition
	ld d, [hl]
	inc hl
	ld e, [hl]
	push de
	call InitTextPrinting
	ld a, [wNamingScreenBufferMaxLength]
	ld e, a
	ld a, $14
	sub e
	inc a
	ld e, a
	ld d, 0
	; print the underbars before the input information.
	ld hl, .char_underbar
	add hl, de
	call ProcessText
	pop de
	call InitTextPrinting
	; print the input from the user.
	ld hl, wNamingScreenBuffer
	call ProcessText
	ret

.char_underbar
	db $56
REPT 10
	textfw "_"
ENDR
	done

; checks if any buttons were pressed and handles the input.
; returns carry if either the A button or the B button were pressed.
; this function is similar to 'DeckNamingScreen_CheckButtonState'.
PlayerNamingScreen_CheckButtonState:
	xor a
	ld [wMenuInputSFX], a
	ldh a, [hDPadHeld]
	or a
	jp z, .no_press
	; detected any button press.
	ld b, a
	ld a, [wNamingScreenKeyboardHeight]
	ld c, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	bit D_UP_F, b
	jr z, .asm_692c
	; up
	dec a
	bit D_DOWN_F, a
	jr z, .asm_69a7
	ld a, c
	dec a
	jr .asm_69a7
.asm_692c
	bit D_DOWN_F, b
	jr z, .asm_6937
	; down
	inc a
	cp c
	jr c, .asm_69a7
	xor a
	jr .asm_69a7
.asm_6937
	ld a, [wNamingScreenNumColumns]
	ld c, a
	ld a, h
	bit D_LEFT_F, b
	jr z, .asm_6974
	; left
	ld d, a
	ld a, $06
	cp l
	ld a, d
	jr nz, .asm_696b
	push hl
	push bc ; unnecessary
	push af
	call PlayerNamingScreen_GetCharInfoFromPos
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	dec a
	ld d, a
	pop af
	pop bc ; unnecessary
	pop hl
	sub d
	cp $ff
	jr nz, .asm_6962
	ld a, c
	sub $02
	jr .asm_69aa
.asm_6962
	cp $fe
	jr nz, .asm_696b
	ld a, c
	sub $03
	jr .asm_69aa
.asm_696b
	dec a
	bit D_DOWN_F, a
	jr z, .asm_69aa
	ld a, c
	dec a
	jr .asm_69aa
.asm_6974
	bit D_RIGHT_F, b
	jr z, .no_press
	ld d, a
	ld a, $06
	cp l
	ld a, d
	jr nz, .asm_6990
	push hl
	push bc ; unnecessary
	push af
	call PlayerNamingScreen_GetCharInfoFromPos
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	dec a
	ld d, a
	pop af
	pop bc ; unnecessary
	pop hl
	add d
.asm_6990
	inc a
	cp c
	jr c, .asm_69aa
	inc c
	cp c
	jr c, .asm_69a4
	inc c
	cp c
	jr c, .asm_69a0
	ld a, $02
	jr .asm_69aa
.asm_69a0
	ld a, $01
	jr .asm_69aa
.asm_69a4
	xor a
	jr .asm_69aa
.asm_69a7
	ld l, a
	jr .asm_69ab
.asm_69aa
	ld h, a
.asm_69ab
	push hl
	call PlayerNamingScreen_GetCharInfoFromPos
	inc hl
	inc hl
	inc hl
	ld a, [wd009]
	cp $02
	jr nz, .asm_69bb
	inc hl
	inc hl
.asm_69bb
	ld d, [hl]
	push de
	call PlayerNamingScreen_DrawInvisibleCursor
	pop de
	pop hl
	ld a, l
	ld [wNamingScreenCursorY], a
	ld a, h
	ld [wNamingScreenCursorX], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	ld a, $06
	cp d
	jp z, PlayerNamingScreen_CheckButtonState
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
.no_press
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .asm_69ef
	and A_BUTTON
	jr nz, .asm_69e5
	; the B button was pressed.
	ld a, -1
.asm_69e5
	call PlaySFXConfirmOrCancel_Bank6
	push af
	call PlayerNamingScreen_DrawVisibleCursor
	pop af
	scf
	ret
.asm_69ef
	ld a, [wMenuInputSFX]
	or a
	jr z, .asm_69f8
	call PlaySFX
.asm_69f8
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	ld a, [wVisibleCursorTile]
	bit 4, [hl]
	jr z, PlayerNamingScreen_DrawCursor
;	fallthrough

PlayerNamingScreen_DrawInvisibleCursor:
	ld a, [wInvisibleCursorTile]
;	fallthrough

; this function is very similar to 'DeckNamingScreen_DrawCursor'.
; input:
;	a = which tile to draw
;	[wNamingScreenCursorX] = cursor's x position on the keyboard screen
;	[wNamingScreenCursorY] = cursor's y position on the keyboard screen
PlayerNamingScreen_DrawCursor:
	ld e, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call PlayerNamingScreen_GetCharInfoFromPos
	ld a, [hli]
	ld c, a
	ld b, [hl]
	dec b
	ld a, e
	call PlayerNamingScreen_AdjustCursorPosition
	call WriteByteToBGMap0
	or a
	ret

PlayerNamingScreen_DrawVisibleCursor:
	ld a, [wVisibleCursorTile]
	jr PlayerNamingScreen_DrawCursor

; returns after calling ZeroObjectPositions if a = [wInvisibleCursorTile].
; otherwise, uses [wNamingScreenBufferLength], [wNamingScreenBufferMaxLength], and
; [wNamingScreenNamePosition] to determine x/y positions and calls SetOneObjectAttributes.
; this function is similar to 'DeckNamingScreen_AdjustCursorPosition'.
; preserves all registers
; input:
;	a = cursor tile
PlayerNamingScreen_AdjustCursorPosition:
	push af
	push bc
	push de
	push hl
	push af
	call ZeroObjectPositions
	pop af
	ld b, a
	ld a, [wInvisibleCursorTile]
	cp b
	jr z, .asm_6a60
	ld a, [wNamingScreenBufferLength]
	srl a
	ld d, a
	ld a, [wNamingScreenBufferMaxLength]
	srl a
	ld e, a
	ld a, d
	cp e
	jr nz, .asm_6a49
	dec a
.asm_6a49
	ld hl, wNamingScreenNamePosition
	add [hl]
	ld d, a
	ld h, $08
	ld l, d
	call HtimesL
	ld a, l
	add $08
	ld d, a
	ld e, $18
	ld bc, $0000
	call SetOneObjectAttributes
.asm_6a60
	pop hl
	pop de
	pop bc
	pop af
	ret

; loads, to the first tile of v0Tiles0, the graphics for the blinking black square
; used in name input screens for inputting full width text.
; this function is very similar to 'LoadHalfWidthTextCursorTile'.
LoadTextCursorTile:
	ld hl, v0Tiles0 + $00 tiles
	ld de, .data
	ld b, 0
.loop
	ld a, TILE_SIZE
	cp b
	ret z
	inc b
	ld a, [de]
	inc de
	ld [hli], a
	jr .loop

.data
REPT TILE_SIZE
	db $ff
ENDR

; returns carry if "End" was selected on the keyboard
PlayerNamingScreen_ProcessInput:
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call PlayerNamingScreen_GetCharInfoFromPos
	inc hl
	inc hl
	; load types into de.
	ld e, [hl]
	inc hl
	ld a, [hli]
	ld d, a
	cp $09
	jp z, .on_end
	cp $07
	jr nz, .asm_6ab8
	ld a, [wd009]
	or a
	jr nz, .asm_6aac
	ld a, $01
	jp .asm_6ace ; can be jr
.asm_6aac
	dec a
	jr nz, .asm_6ab4
	ld a, $02
	jp .asm_6ace ; can be jr
.asm_6ab4
	xor a
	jp .asm_6ace ; can be jr
.asm_6ab8
	cp $08
	jr nz, .asm_6ad6
	ld a, [wd009]
	or a
	jr nz, .asm_6ac6
	ld a, $02
	jr .asm_6ace
.asm_6ac6
	dec a
	jr nz, .asm_6acc
	xor a
	jr .asm_6ace
.asm_6acc
	ld a, $01
	; fallthrough
.asm_6ace
	ld [wd009], a
	call DrawPlayerNamingScreenBG
	or a
	ret

.asm_6ad6
	ld a, [wd009]
	cp $02
	jr z, .read_char
	lb bc, TX_FULLWIDTH3, "FW3_゛"
	ld a, d
	cp b
	jr nz, .asm_6af4
	ld a, e
	cp c
	jr nz, .asm_6af4
	push hl
	ld hl, TransitionTable1 ; from 55th.
	call TransformCharacter
	pop hl
	jr c, .nothing
	jr .asm_6b09

.asm_6af4
	lb bc, TX_FULLWIDTH3, "FW3_゜"
	ld a, d
	cp b
	jr nz, .asm_6b1d
	ld a, e
	cp c
	jr nz, .asm_6b1d
	push hl
	ld hl, TransitionTable2 ; from 72th.
	call TransformCharacter
	pop hl
	jr c, .nothing
.asm_6b09
	ld a, [wNamingScreenBufferLength]
	dec a
	dec a
	ld [wNamingScreenBufferLength], a
	ld hl, wNamingScreenBuffer
	push de
	ld d, 0
	ld e, a
	add hl, de
	pop de
	ld a, [hl]
	jr .asm_6b37

.asm_6b1d
	ld a, d
	or a
	jr nz, .asm_6b37
	ld a, [wd009]
	or a
	jr nz, .asm_6b2b
	ld a, TX_HIRAGANA
	jr .asm_6b37
.asm_6b2b
	ld a, TX_KATAKANA
	jr .asm_6b37

; read character code from info. to register.
; input:
;	hl = pointer
.read_char
	ld e, [hl]
	inc hl
	ld a, [hl] ; a = first byte of the code.
	or a
	; if 2 bytes code, jump.
	jr nz, .asm_6b37
	; if 1 byte code(ascii),
	; set first byte to $0e.
	ld a, $0e
; on 2 bytes code.
.asm_6b37
	ld d, a ; de = character code
	ld hl, wNamingScreenBufferLength
	ld a, [hl]
	ld c, a
	push hl
	ld hl, wNamingScreenBufferMaxLength
	cp [hl]
	pop hl
	jr nz, .asm_6b4c
	; if the buffer is full, just change the last character.
	ld hl, wNamingScreenBuffer
	dec hl
	dec hl
	jr .asm_6b51

; increase name length before adding the character.
.asm_6b4c
	inc [hl]
	inc [hl]
	ld hl, wNamingScreenBuffer

; write 2 byte character codes to the name buffer.
; input:
;	de = 2 byte character code
;	hl = copy destination
.asm_6b51
	ld b, 0
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld [hl], TX_END ; null terminator.
	call PrintPlayerNameFromInput
.nothing
	or a
	ret
.on_end
	scf
	ret

; this transforms the last japanese character
; in the name buffer into its dakuon shape or something.
; it seems to have been deprecated as the game was translated into english,
; but it can still be applied to english, such as upper-lower case transition.
; returns carry if there was no conversion
; preserves bc
; input:
;	hl = character conversion data (e.g. TransitionTable1)
; output:
;	de = updated 2 byte character code
TransformCharacter:
	ld a, [wNamingScreenBufferLength]
	or a
	jr z, .return ; if the length is zero, just return.
	dec a
	dec a
	push hl
	ld hl, wNamingScreenBuffer
	ld d, 0
	ld e, a
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	; de = last character in the buffer,
	; but byte-wise swapped.
	ld a, TX_KATAKANA
	cp e
	jr nz, .hiragana
	; if it's katakana,
	; make it hiragana by decreasing its high byte.
	dec e
.hiragana
	pop hl
.loop
	ld a, [hli]
	or a
	jr z, .return ; reached the end of the table
	cp d
	jr nz, .next
	ld a, [hl]
	cp e
	jr nz, .next
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	or a
	ret
.next
	inc hl
	inc hl
	inc hl
	jr .loop
.return
	scf
	ret

; given the cursor position, returns the pointer to the character information.
; this function is very similar to 'DeckNamingScreen_GetCharInfoFromPos',
; except that the data structure has a different unit size (6 bytes instead of 3).
; preserves bc and de
; input:
;	h = x position
;	l = y position
; output:
;	hl = PlayerNamingScreen_KeyboardData pointer
PlayerNamingScreen_GetCharInfoFromPos:
	push de
	; (information index) = (x) * (height) + (y)
	; (height) = 0x05(Deck) or 0x06(Player)
	ld e, l
	ld d, h
	ld a, [wNamingScreenKeyboardHeight]
	ld l, a
	call HtimesL
	ld a, l
	add e
	ld hl, PlayerNamingScreen_KeyboardData
	pop de
	or a
	ret z
.loop
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	dec a
	jr nz, .loop
	ret

; a set of keyboard datum.
; unit: 6 bytes.
; structure:
; abs. y pos. (1) / abs. x pos. (1) / type 1 (1) / type 2 (1) / char. code (2)
; unused data contains its character code as zero.
MACRO kbitem
	db \1, \2, \3, \4
	IF (_NARG == 5)
		dw \5
	ELIF (\5 == TX_FULLWIDTH0)
		dw (\5 << 8) | STRCAT("FW0_", \6)
	ELIF (\5 == TX_FULLWIDTH3)
		dw (\5 << 8) | STRCAT("FW3_", \6)
	ELSE
		dw (\5 << 8) | \6
	ENDC
ENDM

PlayerNamingScreen_KeyboardData:
	kbitem $04, $02, $11, $00, TX_FULLWIDTH3,   "A"
	kbitem $06, $02, $12, $00, TX_FULLWIDTH3,   "J"
	kbitem $08, $02, $13, $00, TX_FULLWIDTH3,   "S"
	kbitem $0a, $02, $14, $00, TX_FULLWIDTH0,   "?"
	kbitem $0c, $02, $15, $00, TX_FULLWIDTH0,   "4"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $04, $16, $00, TX_FULLWIDTH3,   "B"
	kbitem $06, $04, $17, $00, TX_FULLWIDTH3,   "K"
	kbitem $08, $04, $18, $00, TX_FULLWIDTH3,   "T"
	kbitem $0a, $04, $19, $00, TX_FULLWIDTH3,   "&"
	kbitem $0c, $04, $1a, $00, TX_FULLWIDTH0,   "5"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $06, $1b, $00, TX_FULLWIDTH3,   "C"
	kbitem $06, $06, $1c, $00, TX_FULLWIDTH3,   "L"
	kbitem $08, $06, $1d, $00, TX_FULLWIDTH3,   "U"
	kbitem $0a, $06, $1e, $00, TX_FULLWIDTH0,   "+"
	kbitem $0c, $06, $1f, $00, TX_FULLWIDTH0,   "6"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $08, $20, $00, TX_FULLWIDTH3,   "D"
	kbitem $06, $08, $21, $00, TX_FULLWIDTH3,   "M"
	kbitem $08, $08, $22, $00, TX_FULLWIDTH3,   "V"
	kbitem $0a, $08, $23, $00, TX_FULLWIDTH0,   "-"
	kbitem $0c, $08, $24, $00, TX_FULLWIDTH0,   "7"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $0a, $25, $00, TX_FULLWIDTH3,   "E"
	kbitem $06, $0a, $26, $00, TX_FULLWIDTH3,   "N"
	kbitem $08, $0a, $27, $00, TX_FULLWIDTH3,   "W"
	kbitem $0a, $0a, $28, $00, TX_FULLWIDTH0,   "・"
	kbitem $0c, $0a, $29, $00, TX_FULLWIDTH0,   "8"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $0c, $2a, $00, TX_FULLWIDTH3,   "F"
	kbitem $06, $0c, $2b, $00, TX_FULLWIDTH3,   "O"
	kbitem $08, $0c, $2c, $00, TX_FULLWIDTH3,   "X"
	kbitem $0a, $0c, $2d, $00, TX_FULLWIDTH0,   "0"
	kbitem $0c, $0c, $2e, $00, TX_FULLWIDTH0,   "9"
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $0e, $2f, $00, TX_FULLWIDTH3,   "G"
	kbitem $06, $0e, $30, $00, TX_FULLWIDTH3,   "P"
	kbitem $08, $0e, $31, $00, TX_FULLWIDTH3,   "Y"
	kbitem $0a, $0e, $32, $00, TX_FULLWIDTH0,   "1"
	kbitem $0c, $0e, $33, $00, TX_SYMBOL,       SYM_No
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $10, $34, $00, TX_FULLWIDTH3,   "H"
	kbitem $06, $10, $35, $00, TX_FULLWIDTH3,   "Q"
	kbitem $08, $10, $36, $00, TX_FULLWIDTH3,   "Z"
	kbitem $0a, $10, $3c, $00, TX_FULLWIDTH0,   "2"
	kbitem $0c, $10, $3d, $00, TX_SYMBOL,       SYM_Lv
	kbitem $10, $0f, $01, $09, $0000

	kbitem $04, $12, $37, $00, TX_FULLWIDTH3,   "I"
	kbitem $06, $12, $38, $00, TX_FULLWIDTH3,   "R"
	kbitem $08, $12, $39, $00, TX_FULLWIDTH0,   "!"
	kbitem $0a, $12, $3a, $00, TX_FULLWIDTH0,   "3"
	kbitem $0c, $12, $3b, $00, TX_FULLWIDTH0,   " "
	kbitem $10, $0f, $01, $09, $0000
	kbitem $00, $00, $00, $00, $0000

; a set of transition datum use to apply dakuten to katakana characters.
; unit: 4 bytes.
; structure:
; previous char. code (2) / translated char. code (2)
; - the former char. code contains 0x0e in high byte.
; - the latter char. code contains only low byte.
TransitionTable1:
	dw $0e16, $003e ; ka -> ga
	dw $0e17, $003f ; ki -> gi
	dw $0e18, $0040 ; ku -> gu
	dw $0e19, $0041 ; ke -> ge
	dw $0e1a, $0042 ; ko -> go
	dw $0e1b, $0043 ; sa -> za
	dw $0e1c, $0044 ; shi -> ji
	dw $0e1d, $0045 ; su -> zu
	dw $0e1e, $0046 ; se -> ze
	dw $0e1f, $0047 ; so -> zo
	dw $0e20, $0048 ; ta -> da
	dw $0e21, $0049 ; chi -> dji
	dw $0e22, $004a ; tsu -> dzu
	dw $0e23, $004b ; te -> de
	dw $0e24, $004c ; to -> do
	dw $0e2a, $004d ; ha -> ba
	dw $0e2b, $004e ; hi -> bi
	dw $0e2c, $004f ; fu -> bu
	dw $0e2d, $0050 ; he -> be
	dw $0e2e, $0051 ; ho -> bo
	dw $0e52, $004d ; pa -> ba
	dw $0e53, $004e ; pi -> bi
	dw $0e54, $004f ; pu -> bu
	dw $0e55, $0050 ; pe -> be
	dw $0e56, $0051 ; po -> bo
	dw $0000

; a set of transition datum use to apply handakuten to katakana characters.
; it has the same unit size and structure as TransitionTable1.
TransitionTable2:
	dw $0e2a, $0052 ; ha -> pa
	dw $0e2b, $0053 ; hi -> pi
	dw $0e2c, $0054 ; fu -> pu
	dw $0e2d, $0055 ; he -> pe
	dw $0e2e, $0056 ; ho -> po
	dw $0e4d, $0052 ; ba -> pa
	dw $0e4e, $0053 ; bi -> pi
	dw $0e4f, $0054 ; bu -> pu
	dw $0e50, $0055 ; be -> pe
	dw $0e51, $0056 ; bo -> po
	dw $0000

; gets a deck name from user input and stores it in [de].
; this function is similar to 'InputPlayerName'.
; input:
;	a = maximum length of a name (MAX_DECK_NAME_LENGTH)
;	bc = coordinates at which to begin printing the name
;	de = where to store the name (wCurDeckName)
;	hl = pointer for text items (Deck*Data)
InputDeckName:
	push af
	; check if the buffer is empty.
	ld a, [de]
	or a
	jr nz, .not_empty
	; this buffer will contain half-width characters.
	ld a, TX_HALFWIDTH
	ld [de], a
.not_empty
	pop af
	inc a
	call InitializeInputName
	call Set_OBJ_8x8

	xor a
	ld [wTileMapFill], a
	call EmptyScreen
	call ZeroObjectPositions

	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call LoadSymbolsFont

	lb de, $38, $bf
	call SetupText
	call LoadHalfWidthTextCursorTile

	xor a
	ld [wd009], a
	call DrawDeckNamingScreenBG

	xor a
	ld [wNamingScreenCursorX], a
	ld [wNamingScreenCursorY], a

	ld a, $09
	ld [wNamingScreenNumColumns], a
	ld a, $07
	ld [wNamingScreenKeyboardHeight], a
	ld a, $0f
	ld [wVisibleCursorTile], a
	ld a, $00
	ld [wInvisibleCursorTile], a
.loop
	ld a, $01
	ld [wVBlankOAMCopyToggle], a
	call DoFrame

	call UpdateRNGSources

	ldh a, [hDPadHeld]
	and START
	jr z, .else

	; the Start button was pressed.
	ld a, $01
	call PlaySFXConfirmOrCancel_Bank6
	call DeckNamingScreen_DrawInvisibleCursor

	ld a, 6
	ld [wNamingScreenCursorX], a
	ld [wNamingScreenCursorY], a
	call DeckNamingScreen_DrawVisibleCursor
	jr .loop

.else
	call DeckNamingScreen_CheckButtonState
	jr nc, .loop ; if not pressed, go back to the loop.

	cp -1
	jr z, .on_b_button

	; on A button
	call DeckNamingScreen_ProcessInput
	jr nc, .loop

	; Player selected the "End" button.
	call FinalizeInputName

	ld hl, wNamingScreenDestPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl

	ld a, [hl]
	or a
	jr nz, .return ; can be ret nz

	dec hl
	ld [hl], TX_END
.return
	ret

.on_b_button
	ld a, [wNamingScreenBufferLength]
	cp $02
	jr c, .loop

	; erase one character.
	ld e, a
	ld d, 0
	ld hl, wNamingScreenBuffer
	add hl, de
	dec hl
	ld [hl], TX_END

	ld hl, wNamingScreenBufferLength
	dec [hl]
	call PrintDeckNameFromInput

	jp .loop ; can be jr

; loads, to the first tile of v0Tiles0, the graphics for the
; blinking black square used in name input screens for inputting half width text.
; this function is very similar to 'LoadTextCursorTile'.
LoadHalfWidthTextCursorTile:
	ld hl, v0Tiles0 + $00 tiles
	ld de, .data
	ld b, 0
.loop
	ld a, TILE_SIZE
	cp b
	ret z
	inc b
	ld a, [de]
	inc de
	ld [hli], a
	jr .loop

.data
REPT TILE_SIZE
	db $f0
ENDR

; this is called when naming a deck.
; it's similar to 'PrintPlayerNameFromInput'.
; preserves bc
; input:
;	[wNamingScreenNamePosition] = screen coordinates for printing (2 bytes)
;	[wNamingScreenBuffer] = name generated from keyboard input (up to 24 bytes)
PrintDeckNameFromInput:
	ld hl, wNamingScreenNamePosition
	ld d, [hl]
	inc hl
	ld e, [hl]
	call InitTextPrinting
	ld hl, .underbar_data
	ld de, wDefaultText
.loop
; copy the underbar string to wDefaultText
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, .loop

	ld hl, wNamingScreenBuffer
	ld de, wDefaultText
.loop2
; copy the input from the user to wDefaultText
	ld a, [hli]
	or a
	jr z, .print_name
	ld [de], a
	inc de
	jr .loop2

.print_name
	ld hl, wDefaultText
	call ProcessText
	ret

.underbar_data
	db TX_HALFWIDTH
REPT MAX_DECK_NAME_LENGTH
	db "_"
ENDR
	db TX_END

; draws the deck naming keyboard and prints the question, if it exists.
; this function is very similar to 'DrawPlayerNamingScreenBG'.
; input:
;	[wNamingScreenQuestionPointer] = pointer for text data (2 bytes)
DrawDeckNamingScreenBG:
	call DrawTextboxForKeyboard
	call PrintDeckNameFromInput
	ld hl, wNamingScreenQuestionPointer
	ld c, [hl]
	inc hl
	ld a, [hl]
	ld h, a
	or c
	jr z, .print
	; print the question string.
	ld l, c
	call PlaceTextItems
.print
	; print "End".
	ld hl, DrawPlayerNamingScreenBG.data
	call PlaceTextItems
	; print the keyboard characters.
	ldtx hl, DeckNameKeyboardText ; "A B C D..."
	lb de, 2, 4
	call InitTextPrinting
	call ProcessTextFromID
	call EnableLCD
	ret

; returns carry if "End" was selected on the keyboard
DeckNamingScreen_ProcessInput:
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call DeckNamingScreen_GetCharInfoFromPos
	inc hl
	inc hl
	ld a, [hl]
	cp $01
	jr nz, .asm_6ed7
	scf
	ret

.asm_6ed7
	ld d, a
	ld hl, wNamingScreenBufferLength
	ld a, [hl]
	ld c, a
	push hl
	ld hl, wNamingScreenBufferMaxLength
	cp [hl]
	pop hl
	jr nz, .asm_6eeb
	; if the buffer is full, just change the last character
	ld hl, wNamingScreenBuffer
	dec hl
	jr .asm_6eef

.asm_6eeb
; increase name length before adding the character
	inc [hl]
	ld hl, wNamingScreenBuffer
.asm_6eef
	ld b, 0
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], TX_END
	call PrintDeckNameFromInput
	or a
	ret

; checks if any buttons were pressed and handles the input.
; returns carry if either the A button or the B button were pressed.
; this function is similar to 'PlayerNamingScreen_CheckButtonState'.
DeckNamingScreen_CheckButtonState:
	xor a
	ld [wMenuInputSFX], a
	ldh a, [hDPadHeld]
	or a
	jp z, .asm_6f73 ; can be jr
	; detected any button press
	ld b, a
	ld a, [wNamingScreenKeyboardHeight]
	ld c, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	bit D_UP_F, b
	jr z, .asm_6f1f
	; up
	dec a
	bit D_DOWN_F, a
	jr z, .asm_6f4b
	ld a, c
	dec a
	jr .asm_6f4b
.asm_6f1f
	bit D_DOWN_F, b
	jr z, .asm_6f2a
	; down
	inc a
	cp c
	jr c, .asm_6f4b
	xor a
	jr .asm_6f4b
.asm_6f2a
	cp $06
	jr z, .asm_6f73
	ld a, [wNamingScreenNumColumns]
	ld c, a
	ld a, h
	bit D_LEFT_F, b
	jr z, .asm_6f40
	dec a
	bit D_DOWN_F, a
	jr z, .asm_6f4e
	ld a, c
	dec a
	jr .asm_6f4e
.asm_6f40
	bit D_RIGHT_F, b
	jr z, .asm_6f73
	inc a
	cp c
	jr c, .asm_6f4e
	xor a
	jr .asm_6f4e
.asm_6f4b
	ld l, a
	jr .asm_6f4f
.asm_6f4e
	ld h, a
.asm_6f4f
	push hl
	call DeckNamingScreen_GetCharInfoFromPos
	inc hl
	inc hl
	ld d, [hl]
	push de
	call DeckNamingScreen_DrawInvisibleCursor
	pop de
	pop hl
	ld a, l
	ld [wNamingScreenCursorY], a
	ld a, h
	ld [wNamingScreenCursorX], a
	xor a
	ld [wCheckMenuCursorBlinkCounter], a
	ld a, $02
	cp d
	jp z, DeckNamingScreen_CheckButtonState ; can be jr
	ld a, SFX_CURSOR
	ld [wMenuInputSFX], a
.asm_6f73
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .asm_6f89
	and A_BUTTON
	jr nz, .asm_6f7f
	; B button was pressed
	ld a, -1
.asm_6f7f
	call PlaySFXConfirmOrCancel_Bank6
	push af
	call DeckNamingScreen_DrawVisibleCursor
	pop af
	scf
	ret
.asm_6f89
	ld a, [wMenuInputSFX]
	or a
	jr z, .asm_6f92
	call PlaySFX
.asm_6f92
	ld hl, wCheckMenuCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	ld a, [wVisibleCursorTile]
	bit 4, [hl]
	jr z, DeckNamingScreen_DrawCursor
;	fallthrough

DeckNamingScreen_DrawInvisibleCursor:
	ld a, [wInvisibleCursorTile]
;	fallthrough

; this function is very similar to 'PlayerNamingScreen_DrawCursor'.
; input:
;	a = which tile to draw
;	[wNamingScreenCursorX] = cursor's x position on the keyboard screen
;	[wNamingScreenCursorY] = cursor's y position on the keyboard screen
DeckNamingScreen_DrawCursor:
	ld e, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call DeckNamingScreen_GetCharInfoFromPos
	ld a, [hli]
	ld c, a
	ld b, [hl]
	dec b
	ld a, e
	call DeckNamingScreen_AdjustCursorPosition
	call WriteByteToBGMap0
	or a
	ret

DeckNamingScreen_DrawVisibleCursor:
	ld a, [wVisibleCursorTile]
	jr DeckNamingScreen_DrawCursor

; returns after calling ZeroObjectPositions if a = [wInvisibleCursorTile].
; otherwise, uses [wNamingScreenBufferLength], [wNamingScreenBufferMaxLength], and
; [wNamingScreenNamePosition] to determine x/y positions and calls SetOneObjectAttributes.
; this function is similar to 'PlayerNamingScreen_AdjustCursorPosition'.
; preserves all registers
; input:
;	a = cursor tile
DeckNamingScreen_AdjustCursorPosition:
	push af
	push bc
	push de
	push hl
	push af
	call ZeroObjectPositions
	pop af
	ld b, a
	ld a, [wInvisibleCursorTile]
	cp b
	jr z, .asm_6ffb
	ld a, [wNamingScreenBufferLength]
	ld d, a
	ld a, [wNamingScreenBufferMaxLength]
	ld e, a
	ld a, d
	cp e
	jr nz, .asm_6fdf
	dec a
.asm_6fdf
	dec a
	ld d, a
	ld hl, wNamingScreenNamePosition
	ld a, [hl]
	sla a
	add d
	ld d, a
	ld h, $04
	ld l, d
	call HtimesL
	ld a, l
	add $08
	ld d, a
	ld e, $18
	ld bc, $0000
	call SetOneObjectAttributes
.asm_6ffb
	pop hl
	pop de
	pop bc
	pop af
	ret

; given the cursor position, returns the pointer to the character information.
; this function is very similar to 'PlayerNamingScreen_GetCharInfoFromPos',
; except that the data structure has a different unit size (3 bytes instead of 6).
; preserves bc and de
; input:
;	h = x position
;	l = y position
; output:
;	hl = DeckNamingScreen_KeyboardData pointer
DeckNamingScreen_GetCharInfoFromPos:
	push de
	; (information index) = (x) * (height) + (y)
	; (height) = 0x05(Deck) or 0x06(Player)
	ld e, l
	ld d, h
	ld a, [wNamingScreenKeyboardHeight]
	ld l, a
	call HtimesL
	ld a, l
	add e
	ld hl, DeckNamingScreen_KeyboardData
	pop de
	or a
	ret z
.loop
	inc hl
	inc hl
	inc hl
	dec a
	jr nz, .loop
	ret

; a set of keyboard datum
; unit: 3 bytes
; structure: y position, x position, character code
DeckNamingScreen_KeyboardData:
	db $04, $02, "A"
	db $06, $02, "J"
	db $08, $02, "S"
	db $0a, $02, "?"
	db $0c, $02, "4"
	db $0e, $02, $02
	db $10, $0f, $01

	db $04, $04, "B"
	db $06, $04, "K"
	db $08, $04, "T"
	db $0a, $04, "&"
	db $0c, $04, "5"
	db $0e, $04, $02
	db $10, $0f, $01

	db $04, $06, "C"
	db $06, $06, "L"
	db $08, $06, "U"
	db $0a, $06, "+"
	db $0c, $06, "6"
	db $0e, $06, $02
	db $10, $0f, $01

	db $04, $08, "D"
	db $06, $08, "M"
	db $08, $08, "V"
	db $0a, $08, "-"
	db $0c, $08, "7"
	db $0e, $08, $02
	db $10, $0f, $01

	db $04, $0a, "E"
	db $06, $0a, "N"
	db $08, $0a, "W"
	db $0a, $0a, "'"
	db $0c, $0a, "8"
	db $0e, $0a, $02
	db $10, $0f, $01

	db $04, $0c, "F"
	db $06, $0c, "O"
	db $08, $0c, "X"
	db $0a, $0c, "0"
	db $0c, $0c, "9"
	db $0e, $0c, $02
	db $10, $0f, $01

	db $04, $0e, "G"
	db $06, $0e, "P"
	db $08, $0e, "Y"
	db $0a, $0e, "1"
	db $0c, $0e, " "
	db $0e, $0e, $02
	db $10, $0f, $01

	db $04, $10, "H"
	db $06, $10, "Q"
	db $08, $10, "Z"
	db $0a, $10, "2"
	db $0c, $10, " "
	db $0e, $10, $02
	db $10, $0f, $01

	db $04, $12, "I"
	db $06, $12, "R"
	db $08, $12, "!"
	db $0a, $12, "3"
	db $0c, $12, " "
	db $0e, $12, $02
	db $10, $0f, $01

	ds 4 ; empty
