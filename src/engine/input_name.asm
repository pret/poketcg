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

; set each byte zero from hl for b bytes.
ClearMemory:
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

; play different sfx by a.
; if a is 0xff play SFX_03 (usually following a B press),
; else play SFX_02 (usually following an A press).
PlayAcceptOrDeclineSFX:
	push af
	inc a
	jr z, .sfx_decline
	ld a, SFX_02
	jr .sfx_accept
.sfx_decline
	ld a, SFX_03
.sfx_accept
	call PlaySFX
	pop af
	ret

; get player name from the user
; into hl
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
	call DrawNamingScreenBG
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
	; if pressed start button.
	ld a, $01
	call PlayAcceptOrDeclineSFX
	call Func_1aa07
	ld a, 6
	ld [wNamingScreenCursorX], a
	ld a, 5
	ld [wNamingScreenCursorY], a
	call Func_1aa23
	jr .loop
.else
	call NamingScreen_CheckButtonState
	jr nc, .loop ; if not pressed, go back to the loop.
	cp $ff
	jr z, .on_b_button
	; on A button.
	call NamingScreen_ProcessInput
	jr nc, .loop
	; if the player selected the end button,
	; end its naming.
	call FinalizeInputName
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

; it's called when naming(either player's or deck's) starts.
; a: maximum length of name(depending on whether player's or deck's).
; bc: position of name.
; de: dest. pointer.
; hl: pointer to text item of the question.
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
	call ClearMemory
	ld hl, wNamingScreenBuffer
	ld a, [wNamingScreenBufferMaxLength]
	ld b, a
	inc b
.loop
	; copy data from de to hl
	; for b bytes.
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

; draws the keyboard frame
; and the question if it exists.
DrawNamingScreenBG:
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
	ldtx hl, PlayerNameKeyboardText
	lb de, 2, 4
	call InitTextPrinting
	call ProcessTextFromID
	call EnableLCD
	ret
.data
	textitem $0f, $10, EndText ; "End"
	db $ff

DrawTextboxForKeyboard:
	lb de, 0, 3 ; x, y
	lb bc, 20, 15 ; w, h
	call DrawRegularTextBox
	ret

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
	; print the underbars
	; before print the input.
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
	textfw3 "_"
ENDR
	done

; check if button pressed.
; if pressed, set the carry bit on.
NamingScreen_CheckButtonState:
	xor a
	ld [wPlaysSfx], a
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
	push bc
	push af
	call GetCharInfoFromPos_Player
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	dec a
	ld d, a
	pop af
	pop bc
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
	push bc
	push af
	call GetCharInfoFromPos_Player
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	dec a
	ld d, a
	pop af
	pop bc
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
	call GetCharInfoFromPos_Player
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
	call Func_1aa07
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
	jp z, NamingScreen_CheckButtonState
	ld a, $01
	ld [wPlaysSfx], a
.no_press
	ldh a, [hKeysPressed]
	and A_BUTTON | B_BUTTON
	jr z, .asm_69ef
	and A_BUTTON
	jr nz, .asm_69e5
	ld a, $ff
.asm_69e5
	call PlayAcceptOrDeclineSFX
	push af
	call Func_1aa23
	pop af
	scf
	ret
.asm_69ef
	ld a, [wPlaysSfx]
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
	jr z, Func_1aa07.asm_6a0a

Func_1aa07:
	ld a, [wInvisibleCursorTile]
.asm_6a0a
	ld e, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call GetCharInfoFromPos_Player
	ld a, [hli]
	ld c, a
	ld b, [hl]
	dec b
	ld a, e
	call Func_1aa28
	call WriteByteToBGMap0
	or a
	ret

Func_1aa23:
	ld a, [wVisibleCursorTile]
	jr Func_1aa07.asm_6a0a

Func_1aa28:
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

; load, to the first tile of v0Tiles0, the graphics for the
; blinking black square used in name input screens.
; for inputting full width text.
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

; set the carry bit on,
; if "End" was selected.
NamingScreen_ProcessInput:
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call GetCharInfoFromPos_Player
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
	jp .asm_6ace
.asm_6aac
	dec a
	jr nz, .asm_6ab4
	ld a, $02
	jp .asm_6ace
.asm_6ab4
	xor a
	jp .asm_6ace
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
.asm_6ace
	ld [wd009], a
	call DrawNamingScreenBG
	or a
	ret
.asm_6ad6
	ld a, [wd009]
	cp $02
	jr z, .read_char
	ldfw3 bc, "゛"
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
	ldfw3 bc, "゜"
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
; hl: pointer.
.read_char
	ld e, [hl]
	inc hl
	ld a, [hl] ; a: first byte of the code.
	or a
	; if 2 bytes code, jump.
	jr nz, .asm_6b37
	; if 1 byte code(ascii),
	; set first byte to $0e.
	ld a, $0e
; on 2 bytes code.
.asm_6b37
	ld d, a ; de: character code.
	ld hl, wNamingScreenBufferLength
	ld a, [hl]
	ld c, a
	push hl
	ld hl, wNamingScreenBufferMaxLength
	cp [hl]
	pop hl
	jr nz, .asm_6b4c
	; if the buffer is full
	; just change the last character of it.
	ld hl, wNamingScreenBuffer
	dec hl
	dec hl
	jr .asm_6b51
; increase name length before add the character.
.asm_6b4c
	inc [hl]
	inc [hl]
	ld hl, wNamingScreenBuffer
; write 2 bytes character codes to the name buffer.
; de: 2 bytes character codes.
; hl: dest.
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
; it seems to have been deprecated as the game was translated into english.
; but it can still be applied to english, such as upper-lower case transition.
; hl: info. pointer.
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
	; de: last character in the buffer,
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
	jr z, .return
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

; given the position of the current cursor,
; it returns the pointer to the proper information.
; h: position x.
; l: position y.
GetCharInfoFromPos_Player:
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
	ld hl, KeyboardData_Player
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

KeyboardData_Player:
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

; a set of transition datum.
; unit: 4 bytes.
; structure:
; previous char. code (2) / translated char. code (2)
; - the former char. code contains 0x0e in high byte.
; - the latter char. code contains only low byte.
TransitionTable1:
	dw $0e16, $003e
	dw $0e17, $003f
	dw $0e18, $0040
	dw $0e19, $0041
	dw $0e1a, $0042
	dw $0e1b, $0043
	dw $0e1c, $0044
	dw $0e1d, $0045
	dw $0e1e, $0046
	dw $0e1f, $0047
	dw $0e20, $0048
	dw $0e21, $0049
	dw $0e22, $004a
	dw $0e23, $004b
	dw $0e24, $004c
	dw $0e2a, $004d
	dw $0e2b, $004e
	dw $0e2c, $004f
	dw $0e2d, $0050
	dw $0e2e, $0051
	dw $0e52, $004d
	dw $0e53, $004e
	dw $0e54, $004f
	dw $0e55, $0050
	dw $0e56, $0051
	dw $0000

TransitionTable2:
	dw $0e2a, $0052
	dw $0e2b, $0053
	dw $0e2c, $0054
	dw $0e2d, $0055
	dw $0e2e, $0056
	dw $0e4d, $0052
	dw $0e4e, $0053
	dw $0e4f, $0054
	dw $0e50, $0055
	dw $0e51, $0056
	dw $0000

; get deck name from the user into de.
; function description is similar to the player's.
; refer to 'InputPlayerName'.
InputDeckName:
	push af
	; check if the buffer is empty.
	ld a, [de]
	or a
	jr nz, .not_empty
	; this buffer will contain half-width chars.
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
	call Func_1ae99

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
	jr z, .on_start

	ld a, $01
	call PlayAcceptOrDeclineSFX
	call Func_1afa1

	ld a, 6
	ld [wNamingScreenCursorX], a
	ld [wNamingScreenCursorY], a
	call Func_1afbd

	jr .loop
.on_start
	call Func_1aefb
	jr nc, .loop

	cp $ff
	jr z, .asm_6e1c

	call Func_1aec3
	jr nc, .loop

	call FinalizeInputName

	ld hl, wNamingScreenDestPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl

	ld a, [hl]
	or a
	jr nz, .return

	dec hl
	ld [hl], TX_END
.return
	ret
.asm_6e1c
	ld a, [wNamingScreenBufferLength]
	cp $02
	jr c, .loop

	ld e, a
	ld d, 0
	ld hl, wNamingScreenBuffer
	add hl, de
	dec hl
	ld [hl], TX_END

	ld hl, wNamingScreenBufferLength
	dec [hl]
	call ProcessTextWithUnderbar

	jp .loop

; load, to the first tile of v0Tiles0, the graphics for the
; blinking black square used in name input screens.
; for inputting half width text.
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

; it's only for naming the deck.
ProcessTextWithUnderbar:
	ld hl, wNamingScreenNamePosition
	ld d, [hl]
	inc hl
	ld e, [hl]
	call InitTextPrinting
	ld hl, .underbar_data
	ld de, wDefaultText
.loop ; copy the underbar string.
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, .loop

	ld hl, wNamingScreenBuffer
	ld de, wDefaultText
.loop2 ; copy the input from the user.
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

Func_1ae99:
	call DrawTextboxForKeyboard
	call ProcessTextWithUnderbar
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
	; print "End"
	ld hl, DrawNamingScreenBG.data
	call PlaceTextItems
	; print the keyboard characters.
	ldtx hl, DeckNameKeyboardText ; "A B C D..."
	lb de, 2, 4
	call InitTextPrinting
	call ProcessTextFromID
	call EnableLCD
	ret

Func_1aec3:
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call GetCharInfoFromPos_Deck
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
	ld hl, wNamingScreenBuffer
	dec hl
	jr .asm_6eef
.asm_6eeb
	inc [hl]
	ld hl, wNamingScreenBuffer
.asm_6eef
	ld b, 0
	add hl, bc
	ld [hl], d
	inc hl
	ld [hl], TX_END
	call ProcessTextWithUnderbar
	or a
	ret

Func_1aefb:
	xor a
	ld [wPlaysSfx], a
	ldh a, [hDPadHeld]
	or a
	jp z, .asm_6f73
	ld b, a
	ld a, [wNamingScreenKeyboardHeight]
	ld c, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	bit 6, b
	jr z, .asm_6f1f
	dec a
	bit 7, a
	jr z, .asm_6f4b
	ld a, c
	dec a
	jr .asm_6f4b
.asm_6f1f
	bit 7, b
	jr z, .asm_6f2a
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
	bit 5, b
	jr z, .asm_6f40
	dec a
	bit 7, a
	jr z, .asm_6f4e
	ld a, c
	dec a
	jr .asm_6f4e
.asm_6f40
	bit 4, b
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
	call GetCharInfoFromPos_Deck
	inc hl
	inc hl
	ld d, [hl]
	push de
	call Func_1afa1
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
	jp z, Func_1aefb
	ld a, $01
	ld [wPlaysSfx], a
.asm_6f73
	ldh a, [hKeysPressed]
	and $03
	jr z, .asm_6f89
	and $01
	jr nz, .asm_6f7f
	ld a, $ff
.asm_6f7f
	call PlayAcceptOrDeclineSFX
	push af
	call Func_1afbd
	pop af
	scf
	ret
.asm_6f89
	ld a, [wPlaysSfx]
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
	jr z, Func_1afa1.asm_6fa4

Func_1afa1:
	ld a, [wInvisibleCursorTile]
.asm_6fa4
	ld e, a
	ld a, [wNamingScreenCursorX]
	ld h, a
	ld a, [wNamingScreenCursorY]
	ld l, a
	call GetCharInfoFromPos_Deck
	ld a, [hli]
	ld c, a
	ld b, [hl]
	dec b
	ld a, e
	call Func_1afc2
	call WriteByteToBGMap0
	or a
	ret

Func_1afbd:
	ld a, [wVisibleCursorTile]
	jr Func_1afa1.asm_6fa4

Func_1afc2:
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

; given the cursor position,
; returns the character information which the cursor directs.
; it's similar to "GetCharInfoFromPos_Player",
; but the data structure is different in its unit size.
; its unit size is 3, and player's is 6.
; h: x
; l: y
GetCharInfoFromPos_Deck:
	push de
	ld e, l
	ld d, h
	ld a, [wNamingScreenKeyboardHeight]
	ld l, a
	call HtimesL
	ld a, l
	add e
	; x * h + y
	ld hl, KeyboardData_Deck
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

KeyboardData_Deck:
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
