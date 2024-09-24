; similar to ProcessText except it calls InitTextPrinting first
; with the first two bytes of hl being used to set hTextBGMap0Address.
; (the caller to ProcessText usually calls InitTextPrinting first)
InitTextPrinting_ProcessText::
	push de
	push bc
	ld d, [hl]
	inc hl
	ld e, [hl]
	inc hl
	call InitTextPrinting
	jr ProcessText.next_char

; reads the characters from the text at hl processes them. loops until
; TX_END is found. ignores TX_RAM1, TX_RAM2, and TX_RAM3 characters.
ProcessText::
	push de
	push bc
	call InitTextFormat
	jr .next_char
.char_loop
	cp TX_CTRL_START
	jr c, .character_pair
	cp TX_CTRL_END
	jr nc, .character_pair
	call ProcessSpecialTextCharacter
	jr .next_char
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
.next_char
	ld a, [hli]
	or a
	jr nz, .char_loop
	; TX_END
	call TerminateHalfWidthText
	pop bc
	pop de
	ret

; processes the text character provided in a checking for specific control characters.
; hl points to the text character coming right after the one loaded into a.
; returns carry if the character was not processed by this function.
ProcessSpecialTextCharacter::
	or a ; TX_END
	jr z, .tx_end
	cp TX_HIRAGANA
	jr z, .set_syllabary
	cp TX_KATAKANA
	jr z, .set_syllabary
	cp "\n"
	jr z, .end_of_line
	cp TX_SYMBOL
	jr z, .tx_symbol
	cp TX_HALFWIDTH
	jr z, .tx_halfwidth
	cp TX_HALF2FULL
	jr z, .tx_half2full
	scf
	ret
.tx_halfwidth
	ld a, HALF_WIDTH
	ld [wFontWidth], a
	ret
.tx_half2full
	call TerminateHalfWidthText
	xor a ; FULL_WIDTH
	ld [wFontWidth], a
	ld a, TX_KATAKANA
	ldh [hJapaneseSyllabary], a
	ret
.set_syllabary
	ldh [hJapaneseSyllabary], a
	xor a
	ret
.tx_symbol
	ld a, [wFontWidth]
	push af
	ld a, HALF_WIDTH
	ld [wFontWidth], a
	call TerminateHalfWidthText
	pop af
	ld [wFontWidth], a
	ldh a, [hffb0]
	or a
	jr nz, .skip_placing_tile
	ld a, [hl]
	push hl
	call PlaceNextTextTile
	pop hl
.skip_placing_tile
	inc hl
.tx_end
	ldh a, [hTextLineLength]
	or a
	ret z
	ld b, a
	ldh a, [hTextLineCurPos]
	cp b
	jr z, .end_of_line
	xor a
	ret
.end_of_line
	call TerminateHalfWidthText
	ld a, [wLineSeparation]
	or a
	call z, .next_line ; extra line if DOUBLE_SPACED
.next_line
	xor a
	ldh [hTextLineCurPos], a
	ldh a, [hTextHorizontalAlign]
	add BG_MAP_WIDTH
	ld b, a
	; get current line's starting BGMap0 address
	ldh a, [hTextBGMap0Address]
	and $e0
	; advance to next line
	add b ; apply background scroll correction
	ldh [hTextBGMap0Address], a
	ldh a, [hTextBGMap0Address + 1]
	adc $0
	ldh [hTextBGMap0Address + 1], a
	ld a, [wCurTextLine]
	inc a
	ld [wCurTextLine], a
	xor a
	ret

; calls InitTextFormat, selects tiles at $8800-$97FF for text, and clears the wc600.
; selects the first and last tile to be reserved for constructing text tiles in VRAM
; based on the values given in d and e respectively.
SetupText::
	ld a, d
	dec a
	ld [wcd04], a
	ld a, e
	ldh [hffa8], a
	call InitTextFormat
	xor a
	ldh [hffb0], a
	ldh [hffa9], a
	ld a, $88
	ld [wTilePatternSelector], a
	ld a, $80
	ld [wTilePatternSelectorCorrection], a
	ld hl, wc600
.clear_loop
	xor a
	ld [hl], a
	inc l
	jr nz, .clear_loop
	ret

; wFontWidth <- FULL_WIDTH
; hTextLineCurPos <- 0
; wHalfWidthPrintState <- 0
; hJapaneseSyllabary <- TX_KATAKANA
InitTextFormat::
	xor a ; FULL_WIDTH
	ld [wFontWidth], a
	ldh [hTextLineCurPos], a
	ld [wHalfWidthPrintState], a
	ld a, TX_KATAKANA
	ldh [hJapaneseSyllabary], a
	ret

; call InitTextPrinting
; hTextLineLength <- a
InitTextPrintingInTextbox::
	push af
	call InitTextPrinting
	pop af
	ldh [hTextLineLength], a
	ret

; hTextHorizontalAlign <- d
; hTextLineLength <- 0
; wCurTextLine <- 0
; write BGMap0-translated DE to hTextBGMap0Address
; call InitTextFormat
InitTextPrinting::
	push hl
	ld a, d
	ldh [hTextHorizontalAlign], a
	xor a
	ldh [hTextLineLength], a
	ld [wCurTextLine], a
	call DECoordToBGMap0Address
	ld a, l
	ldh [hTextBGMap0Address], a
	ld a, h
	ldh [hTextBGMap0Address + 1], a
	call InitTextFormat
	xor a
	ld [wHalfWidthPrintState], a
	pop hl
	ret

; requests a text tile to be generated and prints it in the screen
; different modes depending on hffb0:
   ; hffb0 == $0: generate and place text tile
   ; hffb0 == $2 (bit 1 set): only generate text tile?
   ; hffb0 == $1 (bit 0 set): not even generate it, but just update text buffers?
Func_22ca::
	push hl
	push de
	push bc
	ldh a, [hffb0]
	and $1
	jr nz, .asm_22ed
	call Func_2325
	jr c, .tile_already_exists
	or a
	jr nz, .done
	call GenerateTextTile
.tile_already_exists
	ldh a, [hffb0]
	and $2
	jr nz, .done
	ldh a, [hffa9]
	call PlaceNextTextTile
.done
	pop bc
	pop de
	pop hl
	ret
.asm_22ed
	call Func_235e
	jr .done

; writes a to wCurTextTile and to the tile pointed to by hTextBGMap0Address,
; then increments hTextBGMap0Address and hTextLineCurPos
PlaceNextTextTile::
	ld [wCurTextTile], a
	ld hl, hTextBGMap0Address
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	dec de
	ld l, e
	ld h, d
	ld de, wCurTextTile
	ld c, 1
	call SafeCopyDataDEtoHL
	ld hl, hTextLineCurPos
	inc [hl]
	ret

; when terminating half-width text with "\n" or TX_END, or switching to full-width
; with TX_HALF2FULL or to symbols with TX_SYMBOL, check if it's necessary to append
; a half-width space to finish an incomplete character pair.
TerminateHalfWidthText::
	ld a, [wFontWidth]
	or a ; FULL_WIDTH
	ret z
	ld a, [wHalfWidthPrintState]
	or a
	ret z ; return if the last printed character was the second of a pair
	push hl
	push de
	push bc
	ld e, " "
	call Func_22ca
	pop bc
	pop de
	pop hl
	ret

Func_2325::
	call Func_235e
	ret c
	or a
	ret nz
	ldh a, [hffa8]
	ld hl, wcd04
	cp [hl]
	jr nz, .asm_2345
	ldh a, [hffa9]
	ld h, $c8
.asm_2337
	ld l, a
	ld a, [hl]
	or a
	jr nz, .asm_2337
	ld h, $c9
	ld c, [hl]
	ld b, $c8
	xor a
	ld [bc], a
	jr .asm_234a
.asm_2345
	inc [hl]
	jr nz, .asm_2349
	inc [hl]
.asm_2349
	ld l, [hl]
.asm_234a
	ldh a, [hffa9]
	ld c, a
	ld b, $c9
	ld a, l
	ldh [hffa9], a
	ld [bc], a
	ld h, $c8
	ld [hl], c
	ld h, $c6
	ld [hl], e
	inc h ; $c7
	ld [hl], d
	ld b, l
	xor a
	ret

; search linked-list for text characters e/d (registers), if found hoist
; the result to head of list and return it. carry flag denotes success.
Func_235e::
	ld a, [wFontWidth]
	or a
	jr z, .print
	call CaseHalfWidthLetter
	; if [wHalfWidthPrintState] != 0, load it to d and print the pair of chars
	; zero wHalfWidthPrintState for next iteration
	ld a, [wHalfWidthPrintState]
	ld d, a
	or a
	jr nz, .print
	; if [wHalfWidthPrintState] == 0, don't print text in this iteration
	; load the next value of register d into wHalfWidthPrintState
	ld a, e
	ld [wHalfWidthPrintState], a
	ld a, $1
	or a
	ret ; nz
.print
	xor a
	ld [wHalfWidthPrintState], a
	ldh a, [hffa9]
	ld l, a              ; l ← [hffa9]; index to to linked-list head
.asm_237d
	ld h, $c6                                     ;
	ld a, [hl]           ; a ← key1[l]            ;
	or a                                          ;
	ret z                ; if NULL, return a = 0  ;
	cp e                                          ; loop for e/d key in
	jr nz, .asm_238a     ;                        ; linked list
	inc h ; $c7          ;                        ;
	ld a, [hl]           ; if key1[l] == e and    ;
	cp d                 ;   key2[l] == d:        ;
	jr z, .asm_238f      ;   break                ;
.asm_238a
	ld h, $c8            ;                        ;
	ld l, [hl]           ; l ← next[l]            ;
	jr .asm_237d
.asm_238f
	ldh a, [hffa9]
	cp l
	jr z, .asm_23af      ; assert at least one iteration
	ld c, a
	ld b, $c9
	ld a, l
	ld [bc], a           ; prev[i0] ← i
	ldh [hffa9], a       ; [hffa9] ← i  (update linked-list head)
	ld h, $c9
	ld b, [hl]
	ld [hl], $0          ; prev[i] ← 0
	ld h, $c8
	ld a, c
	ld c, [hl]
	ld [hl], a           ; next[i] ← i0
	ld l, b
	ld [hl], c           ; next[prev[i]] ← next[i]
	ld h, $c9
	inc c
	dec c
	jr z, .asm_23af      ; if next[i] != NULL:
	ld l, c              ;   l ← next[i]
	ld [hl], b           ;   prev[next[i]] ← prev[i]
.asm_23af
	scf                  ; set carry to indicate success
	ret                  ; (return new linked-list head in a)

; uppercases e if [wUppercaseHalfWidthLetters] is nonzero
CaseHalfWidthLetter::
	ld a, [wUppercaseHalfWidthLetters]
	or a
	ret z
	ld a, e
	cp $60
	ret c
	cp $7b
	ret nc
	sub "a" - "A"
	ld e, a
	ret

; iterates over text at hl until TX_END is found, and sets wFontWidth to
; FULL_WIDTH if the first character is TX_HALFWIDTH
; returns:
;   b = length of text in tiles
;   c = length of text in bytes
;   a = -b
GetTextLengthInTiles::
	ld a, [hl]
	cp TX_HALFWIDTH
	jr nz, .full_width
	call GetTextLengthInHalfTiles
	; return a = - ceil(b/2)
	inc b
	srl b
	xor a
	sub b
	ret
.full_width
	xor a ; FULL_WIDTH
	ld [wFontWidth], a
;	fallthrough

; iterates over text at hl until TX_END is found
; returns:
;   b = length of text in half-tiles
;   c = length of text in bytes
;   a = -b
GetTextLengthInHalfTiles::
	push hl
	push de
	lb bc, $00, $00
.char_loop
	ld a, [hli]
	or a ; TX_END
	jr z, .tx_end
	inc c ; any char except TX_END: c ++
	; TX_FULLWIDTH, TX_SYMBOL, or > TX_CTRL_END : b ++
	cp TX_CTRL_START
	jr c, .character_pair
	cp TX_CTRL_END
	jr nc, .character_pair
	cp TX_SYMBOL
	jr nz, .char_loop
	inc b
	jr .next
.character_pair
	ld e, a ; first char
	ld d, [hl] ; second char
	inc b
	call ClassifyTextCharacterPair
	jr nc, .char_loop
	; TX_FULLWIDTH
.next
	inc c ; TX_FULLWIDTH or TX_SYMBOL: c ++
	inc hl
	jr .char_loop
.tx_end
	; return a = -b
	xor a
	sub b
	pop de
	pop hl
	ret

; copy text of maximum length a (in tiles) from hl to de, then terminate
; the text with TX_END if it doesn't contain it already.
; fill any remaining bytes with spaces plus TX_END to match the length specified in a.
; return the text's actual length in characters (i.e. before the first TX_END) in e.
CopyTextData::
	ld [wTextMaxLength], a
	ld a, [hl]
	cp TX_HALFWIDTH
	jr z, .half_width_text
	ld a, [wTextMaxLength]
	call .copyTextData
	jr c, .fw_text_done
	push hl
.fill_fw_loop
	ld a, FW_SPACE
	ld [hli], a
	dec d
	jr nz, .fill_fw_loop
	ld [hl], TX_END
	pop hl
.fw_text_done
	ld a, e
	ret
.half_width_text
	ld a, [wTextMaxLength]
	add a
	call .copyTextData
	jr c, .hw_text_done
	push hl
.fill_hw_loop
	ld a, " "
	ld [hli], a
	dec d
	jr nz, .fill_hw_loop
	ld [hl], TX_END
	pop hl
.hw_text_done
	ld a, e
	ret

.copyTextData
	push bc
	ld c, l
	ld b, h
	ld l, e
	ld h, d
	ld d, a
	ld e, 0
.loop
	ld a, [bc]
	or a ; TX_END
	jr z, .done
	inc bc
	ld [hli], a
	cp TX_CTRL_START
	jr c, .character_pair
	cp TX_CTRL_END
	jr c, .loop
.character_pair
	push de
	ld e, a ; first char
	ld a, [bc]
	ld d, a ; second char
	call ClassifyTextCharacterPair
	jr nc, .not_tx_fullwidth
	ld a, [bc]
	inc bc
	ld [hli], a
.not_tx_fullwidth
	pop de
	inc e ; return in e the amount of characters actually copied
	dec d ; return in d the difference between the maximum length and e
	jr nz, .loop
	ld [hl], TX_END
	pop bc
	scf ; return carry if the text did not already end with TX_END
	ret
.done
	pop bc
	or a
	ret

; convert the number at hl to TX_SYMBOL text format and write it to wStringBuffer
; replace leading zeros with SYM_SPACE
TwoByteNumberToTxSymbol_TrimLeadingZeros::
	push de
	push bc
	ld de, wStringBuffer
	push de
	ld bc, -10000
	call .get_digit
	ld bc, -1000
	call .get_digit
	ld bc, -100
	call .get_digit
	ld bc, -10
	call .get_digit
	ld bc, -1
	call .get_digit
	xor a ; TX_END
	ld [de], a
	pop hl
	ld e, 5
.digit_loop
	inc hl
	ld a, [hl]
	cp SYM_0
	jr nz, .done ; jump if not zero
	ld [hl], SYM_SPACE ; trim leading zero
	inc hl
	dec e
	jr nz, .digit_loop
	dec hl
	ld [hl], SYM_0
.done
	dec hl
	pop bc
	pop de
	ret

.get_digit
	ld a, TX_SYMBOL
	ld [de], a
	inc de
	ld a, SYM_0 - 1
.subtract_loop
	inc a
	add hl, bc
	jr c, .subtract_loop
	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret

; generates a text tile and copies it to VRAM
; if wFontWidth == FULL_WIDTH
	; de = full-width font tile number
; if wFontWidth == HALF_WIDTH
	; d = half-width character 1 (left)
	; e = half-width character 2 (right)
; b = destination VRAM tile number
GenerateTextTile::
	push hl
	push de
	push bc
	ld a, [wFontWidth]
	or a
	jr nz, .half_width
;.full_width
	call CreateFullWidthFontTile_ConvertToTileDataAddress
	call SafeCopyDataDEtoHL
.done
	pop bc
	pop de
	pop hl
	ret
.half_width
	call CreateHalfWidthFontTile
	call ConvertTileNumberToTileDataAddress
	call SafeCopyDataDEtoHL
	jr .done

; create, at wTextTileBuffer, a half-width font tile
; made from the ascii characters given in d and e
CreateHalfWidthFontTile::
	push bc
	ldh a, [hBankROM]
	push af
	ld a, BANK(HalfWidthFont)
	call BankswitchROM
	; write the right half of the tile (first character) to wTextTileBuffer + 2n
	push de
	ld a, e
	ld de, wTextTileBuffer
	call CopyHalfWidthCharacterToDE
	pop de
	; write the left half of the tile (second character) to wTextTileBuffer + 2n+1
	ld a, d
	ld de, wTextTileBuffer + 1
	call CopyHalfWidthCharacterToDE
	; construct the 2bpp-converted half-width font tile
	ld hl, wTextTileBuffer
	ld b, TILE_SIZE_1BPP
.loop
	ld a, [hli]
	swap a
	or [hl]
	dec hl
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .loop
	call BankpopROM
	pop bc
	ld de, wTextTileBuffer
	ret

; copies a 1bpp tile corresponding to a half-width font character to de.
; the ascii value of the character to copy is provided in a.
; assumes BANK(HalfWidthFont) is already loaded.
CopyHalfWidthCharacterToDE::
	sub $20 ; HalfWidthFont begins at ascii $20
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, HalfWidthFont
	add hl, bc
	ld b, TILE_SIZE_1BPP
.loop
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	dec b
	jr nz, .loop
	ret

; create, at wTextTileBuffer, a full-width font tile given its tile
; number within the full-width font graphics (FullWidthFonts) in de.
; return its v*Tiles address in hl, and return c = TILE_SIZE.
CreateFullWidthFontTile_ConvertToTileDataAddress::
	push bc
	call GetFullWidthFontTileOffset
	call CreateFullWidthFontTile
	pop bc
;	fallthrough

; given a tile number in b, return its v*Tiles address in hl, and return c = TILE_SIZE
; wTilePatternSelector and wTilePatternSelectorCorrection are used to select the source:
; - if wTilePatternSelector == $80 and wTilePatternSelectorCorrection == $00 -> $8000-$8FFF
; - if wTilePatternSelector == $88 and wTilePatternSelectorCorrection == $80 -> $8800-$97FF
ConvertTileNumberToTileDataAddress::
	ld hl, wTilePatternSelectorCorrection
	ld a, b
	xor [hl]
	ld h, $0
	ld l, a
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, [wTilePatternSelector]
	ld b, a
	ld c, $0
	add hl, bc
	ld c, TILE_SIZE
	ret

; create, at wTextTileBuffer, a full-width font tile given its
; within the full-width font graphics (FullWidthFonts) in hl
CreateFullWidthFontTile::
	ld a, BANK(Fonts) ; BANK(DuelGraphics)
	call BankpushROM
	ld de, wTextTileBuffer
	push de
	ld c, TILE_SIZE_1BPP
.loop
	ld a, [hli]
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	pop de
	call BankpopROM
	ret

; given two text characters at de, use the char at e (first one)
; to determine which type of text this pair of characters belongs to.
; return carry if TX_FULLWIDTH1 to TX_FULLWIDTH4.
ClassifyTextCharacterPair::
	ld a, [wFontWidth]
	or a ; FULL_WIDTH
	jr nz, .half_width
	ld a, e
	cp TX_CTRL_END
	jr c, .continue_check
	cp $60
	jr nc, .not_katakana
	ldh a, [hJapaneseSyllabary]
	cp TX_KATAKANA
	jr nz, .not_katakana
	ld d, TX_KATAKANA
	or a
	ret
.half_width
; in half width mode, the first character goes in e, so leave them like that
	or a
	ret
.continue_check
	cp TX_CTRL_START
	jr c, .ath_font
.not_katakana
; 0_1_hiragana.1bpp (e < $60) or 0_2_digits_kanji1.1bpp (e >= $60)
	ld d, $0
	or a
	ret
.ath_font
; TX_FULLWIDTH1 to TX_FULLWIDTH4
; swap d and e to put the TX_FULLWIDTH* character first
	ld e, d
	ld d, a
	scf
	ret

; convert the full-width font tile number at de to the
; equivalent offset within the full-width font tile graphics.
;   if d == TX_KATAKANA: get tile from the 0_0_katakana.1bpp font.
;   if d == TX_HIRAGANA or d == $0: get tile from the 0_1_hiragana.1bpp or 0_2_digits_kanji1.1bpp font.
;   if d >= TX_FULLWIDTH1 and d <= TX_FULLWIDTH4: get tile from one of the other full-width fonts.
GetFullWidthFontTileOffset::
	ld bc, $50 tiles_1bpp
	ld a, d
	cp TX_HIRAGANA
	jr z, .hiragana
	cp TX_KATAKANA
	jr nz, .get_address
	ld bc, $0 tiles
	ld a, e
	sub $10 ; the first $10 are control characters, but this font's graphics start at $0
	ld e, a
.hiragana
	ld d, $0
.get_address
	ld l, e
	ld h, d
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc
	ret

; pointers to VRAM?
; unreferenced
Unknown_2589::
	db $18
	dw $8140
	dw $817e
	dw $8180
	dw $81ac
	dw $81b8
	dw $81bf
	dw $81c8
	dw $81ce
	dw $81da
	dw $81e8
	dw $81f0
	dw $81f7
	dw $81fc
	dw $81fc
	dw $824f
	dw $8258
	dw $8260
	dw $8279
	dw $8281
	dw $829a
	dw $829f
	dw $82f1
	dw $8340
	dw $837e
	dw $8380
	dw $8396
	dw $839f
	dw $83b6
	dw $83bf
	dw $83d6
	dw $8440
	dw $8460
	dw $8470
	dw $847e
	dw $8480
	dw $8491
	dw $849f
	dw $84be
	dw $889f
	dw $88fc
	dw $8940
	dw $9443
	dw $9840
	dw $9872
	dw $989f
	dw $98fc
	dw $9940
	dw $ffff
