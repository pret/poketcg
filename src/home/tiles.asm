; Fill a bxc rectangle at de and at sp-$26,
; using tile a and the subsequent ones in the following pattern:
; | a+0*l+0*h | a+0*l+1*h | a+0*l+2*h |
; | a+1*l+0*h | a+1*l+1*h | a+1*l+2*h |
; | a+2*l+0*h | a+2*l+1*h | a+2*l+2*h |
FillRectangle::
	push de
	push af
	push hl
	add sp, -TILEMAP_WIDTH
	call DECoordToBGMap0Address
.next_row
	push hl
	push bc
	ld hl, sp+$25
	ld d, [hl]
	ld hl, sp+$27
	ld a, [hl]
	ld hl, sp+$4
	push hl
.next_tile
	ld [hli], a
	add d
	dec b
	jr nz, .next_tile
	pop de
	pop bc
	pop hl
	push hl
	push bc
	ld c, b
	ld b, 0
	call SafeCopyDataDEtoHL
	ld hl, sp+$24
	ld a, [hl]
	ld hl, sp+$27
	add [hl]
	ld [hl], a
	pop bc
	pop de
	ld hl, TILEMAP_WIDTH
	add hl, de
	dec c
	jr nz, .next_row
	add sp, $24
	pop de
	ret

Func_1f96::
	add sp, -10
	ld hl, sp+0
	ld [hli], a ; sp-10 <- a
	ld [hl], $00 ; sp-9 <- 0
	inc hl
	ld a, [de]
	inc de
	ld [hli], a ; sp-8 <- [de]
	ld [hl], $00 ; sp-7 <- 0
	ld hl, sp+5
	ld a, [de]
	inc de
	ld [hld], a ; sp-5 <- [de+1]
	ld a, [de]
	inc de
	ld [hl], a ; sp-6 <- [de+2]
	ld hl, sp+6
	ld a, [de]
	inc de
	ld [hli], a ; sp-4 <- [de+3]
	ld a, [de]
	inc de
	ld [hli], a ; sp-3 <- [de+4]
	ld a, [de]
	inc de
	ld l, a ; l <- [de+5]
	ld a, [de]
	dec de
	ld h, a ; h <- [de+6]
	or l
	jr z, .asm_1fbd
	add hl, de
.asm_1fbd
	ld e, l
	ld d, h ; de += hl
	ld hl, sp+8
	ld [hl], e ; sp-2 <- e
	inc hl
	ld [hl], d ; sp-1 <- d
	ld hl, sp+0
	ld e, [hl] ; e <- sp
	jr .asm_2013
	push hl
	push de
	push hl
	add sp, -4
	ld hl, sp+0
	ld [hl], c
	inc hl
	ld [hl], $00
	inc hl
	ld [hl], b
	ld hl, sp+8
	xor a
	ld [hli], a
	ld [hl], a
.asm_1fdb
	call DoFrame
	ld hl, sp+3
	ld [hl], a
	ld c, a
	and $09
	jr nz, .asm_2032
	ld a, c
	and $06
	jr nz, .asm_203c
	ld hl, sp+2
	ld b, [hl]
	ld hl, sp+0
	ld a, [hl]
	bit 6, c
	jr nz, .asm_1ffe
	bit 7, c
	jr nz, .asm_2007
	call Func_2046
	jr .asm_1fdb
.asm_1ffe
	dec a
	bit 7, a
	jr z, .asm_200c
	ld a, b
	dec a
	jr .asm_200c
.asm_2007
	inc a
	cp b
	jr c, .asm_200c
	xor a
.asm_200c
	ld e, a
	call Func_2051
	ld hl, sp+0
	ld [hl], e
.asm_2013
	inc hl
	ld [hl], $00
	inc hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	ld hl, sp+8
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .asm_202d
	ld a, e
	ld de, .asm_2028
	push de
	jp hl
.asm_2028
	jr nc, .asm_202d
	ld hl, sp+0
	ld [hl], a
.asm_202d
	call Func_2046
	jr .asm_1fdb
.asm_2032
	call Func_2051
	ld hl, sp+0
	ld a, [hl]
	add sp, 10
	or a
	ret
.asm_203c
	call Func_2051
	ld hl, sp+0
	ld a, [hl]
	add sp, 10
	scf
	ret

Func_2046::
	ld hl, sp+3
	ld a, [hl]
	inc [hl]
	and $0f
	ret nz
	bit 4, [hl]
	jr z, Func_2055
;	fallthrough

Func_2051::
	ld hl, sp+9
	jr Func_2057

Func_2055::
	ld hl, sp+8
;	fallthrough

Func_2057::
	ld e, [hl]
	ld hl, sp+2
	ld a, [hl]
	ld hl, sp+6
	add [hl]
	inc hl
	ld c, a
	ld b, [hl]
	ld a, e
	call HblankWriteByteToBGMap0
	ret

; loads the four tiles of the card set 2 icon constant provided in register a
; returns carry if the specified set does not have an icon
LoadCardSet2Tiles::
	and $7 ; mask out PRO
	ld e, a
	ld d, 0
	ld hl, .tile_offsets
	add hl, de
	ld a, [hl]
	cp -1
	ccf
	ret z
	ld e, a
	ld d, 0
	ld hl, RealCardSetSymbolGraphics
	add hl, de
	ld de, v0Tiles1 + $7c tiles
	ld b, REGULAR_ICON_TILE_SIZE
	call CopyFontsOrDuelGraphicsTiles
	or a
	ret

.tile_offsets
	db -1                     ; PRO/NONE
	db ICON_TILE_JUNGLE tiles ; JUNGLE
	db ICON_TILE_FOSSIL tiles ; FOSSIL
	db -1                     ; unused
	db -1                     ; unused
	db -1                     ; unused
	db -1                     ; unused
	db ICON_TILE_GB tiles     ; GB

; loads the Deck and Hand icons for the "Draw X card(s) from the deck." screen
LoadDuelDrawCardsScreenTiles::
	ld hl, DuelDrawCardsScreenGraphics
	ld de, v0Tiles1 + $74 tiles
	ld b, NUM_DRAW_CARDS_SCREEN_ICON_TILES
	jp CopyFontsOrDuelGraphicsTiles

; loads the 8 tiles that make up the border of the main duel menu as well as the border
; of a large card picture (displayed after drawing the card or placing it in the arena).
LoadCardOrDuelMenuBorderTiles::
	ld hl, CardOrDuelMenuBorderGraphics
	ld de, v0Tiles1 + $50 tiles
	ld b, NUM_CARD_OR_DUEL_MENU_BORDER_TILES
	jr CopyFontsOrDuelGraphicsTiles

; loads the graphics of HEADER_* in a
; to display a picture of a card after drawing it or placing it in the arena
LoadCardTypeHeaderTiles::
	ld d, a ; * CARD_HEADER_TILE_SIZE tiles
	ld e, 0
	ld hl, DuelCardHeaderGraphics - $4000
	add hl, de
	ld de, v0Tiles1 + $60 tiles
	ld b, CARD_HEADER_TILE_SIZE
	jr CopyFontsOrDuelGraphicsTiles

; loads the symbols that are displayed near the names of a list of cards in the hand or discard pile
LoadDuelCardSymbolTiles::
	ld hl, DuelDmgSgbCardSymbolGraphics - $4000
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .copy
	ld hl, DuelCgbCardSymbolGraphics - $4000
.copy
	ld de, v0Tiles1 + $50 tiles
	ld b, NUM_CARD_TYPE_ICON_TILES
	jr CopyFontsOrDuelGraphicsTiles

; loads the symbols for Stage 1 Pkmn card, Stage 2 Pkmn card, and Trainer card.
; unlike LoadDuelCardSymbolTiles excludes the symbols for Basic Pkmn and all energies.
LoadDuelCardSymbolTiles2::
	ld hl, DuelDmgSgbCardSymbolGraphics + ICON_TILE_EVO_OR_TRAINER_OFFSET tiles - $4000
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .copy
	ld hl, DuelCgbCardSymbolGraphics + ICON_TILE_EVO_OR_TRAINER_OFFSET tiles - $4000
.copy
	ld de, v0Tiles1 + ($50 + ICON_TILE_EVO_OR_TRAINER_OFFSET) tiles
	ld b, NUM_EVO_OR_TRAINER_ICON_TILES
	jr CopyFontsOrDuelGraphicsTiles

; load the basic, Stage 1, and Stage 2 icons shown in the check Pokemon screens
LoadDuelCheckPokemonScreenTiles_OnlyPokemonStages::
	ld b, NUM_CHECK_POKEMON_SCREEN_STAGE_ICON_TILES
	jr LoadDuelCheckPokemonScreenTiles.got_num_tiles

; load all tiles in the check Pokemon screens
; (Pokemon stage icons, plus the ACT / BPx tiles)
LoadDuelCheckPokemonScreenTiles::
	ld b, NUM_CHECK_POKEMON_SCREEN_ICON_TILES
.got_num_tiles
	ld hl, DuelDmgSgbCheckPokemonScreenGraphics - $4000
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .copy
	ld hl, DuelCgbCheckPokemonScreenGraphics - $4000
.copy
	ld de, v0Tiles1 + $50 tiles
	jr CopyFontsOrDuelGraphicsTiles

; load the tiles for the face-down arena cards and prize cards
; for the "Placing the prizes..." screen,
; plus the ones for the play area screen
LoadPlacingThePrizesScreenTiles::
	ld hl, DuelSetupScreenGraphics
	ld de, v0Tiles1 + $20 tiles
	ld b, NUM_SETUP_ICON_TILES
	call CopyFontsOrDuelGraphicsTiles
; fallthrough

; load the tiles for the player's / opponent's Play Area screen
; harmless bug: 3 more tiles get loaded from the next graphic set
LoadDuelPlayAreaScreenTiles::
	ld hl, DuelDmgSgbPlayAreaScreenGraphics - $4000
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .copy
	ld hl, DuelCgbPlayAreaScreenGraphics - $4000
.copy
	ld de, v0Tiles1 + $50 tiles
	ld b, NUM_PLAY_AREA_SCREEN_ICON_TILES + 3
	jr CopyFontsOrDuelGraphicsTiles

; load the tiles for the [O] and [X] symbols used to display the results of a coin toss
LoadDuelCoinTossResultTiles::
	ld hl, DuelCoinTossResultSymbolGraphics
	ld de, v0Tiles2 + $30 tiles
	ld b, NUM_COIN_TOSS_RESULT_ICON_TILES
	jr CopyFontsOrDuelGraphicsTiles

; load the tiles of the text characters used with TX_SYMBOL
LoadSymbolsFont::
	ld hl, SymbolsFont - $4000
	ld de, v0Tiles2 ; destination
	ld b, (SymbolsFontEnd - SymbolsFont) / TILE_SIZE ; number of tiles
;	fallthrough

; if hl ≤ $3fff
;   copy b tiles from Gfx1:(hl+$4000) to de
; if $4000 ≤ hl ≤ $7fff
;   copy b tiles from Gfx2:hl to de
CopyFontsOrDuelGraphicsTiles::
	ld a, BANK(Fonts) ; BANK(DuelGraphics)
	call BankpushROM
	ld c, TILE_SIZE
	call CopyGfxData
	call BankpopROM
	ret

; load the card data tiles for the printer into sram:
;   PRINTER_TILE_* to sGfxBuffer1;
;   all card symbols to sGfxBuffer4 + $10 tiles
LoadPrinterCardDataTiles::
	; symbols font
	ld hl, SymbolsFont - $4000
	ld de, sGfxBuffer1 + PRINTER_TILE_SYMBOLS tiles
	ld b, NUM_PRINTER_SYM_CHARS
	call CopyFontsOrDuelGraphicsTiles
	; borders
	ld hl, CardOrDuelMenuBorderGraphics
	ld de, sGfxBuffer1 + PRINTER_TILE_BORDERS tiles
	ld b, NUM_CARD_OR_DUEL_MENU_BORDER_TILES
	call CopyFontsOrDuelGraphicsTiles
	; card symbol of the selected card
	call GetCardSymbolData
	sub CARD_TYPE_ICON_TILE_START
	ld l, a
	ld h, $00
REPT 4 ; *TILE_SIZE
	add hl, hl
ENDR
	ld de, DuelDmgSgbCardSymbolGraphics - $4000
	add hl, de
	ld de, sGfxBuffer1 + PRINTER_TILE_CARD_TYPE tiles
	ld b, REGULAR_ICON_TILE_SIZE
	call CopyFontsOrDuelGraphicsTiles
	; all card symbols
	ld hl, DuelDmgSgbCardSymbolGraphics - $4000
	ld de, sGfxBuffer4 + $10 tiles
	ld b, NUM_CARD_TYPE_ICON_TILES
	jr CopyFontsOrDuelGraphicsTiles

; load the graphics and draw the duel box message given a BOXMSG_* constant in a
DrawDuelBoxMessage::
	ld l, a
	ld h, DUEL_BOX_MESSAGE_TILE_SIZE tiles / 4
	call HtimesL
	add hl, hl
	add hl, hl
	; hl = a * 40 tiles
	ld de, DuelBoxMessages
	add hl, de
	ld de, v0Tiles1 + $20 tiles
	ld b, DUEL_BOX_MESSAGE_TILE_SIZE
	call CopyFontsOrDuelGraphicsTiles
	ld a, $a0
	lb hl, 1, 10
	lb bc, 10, 4
	lb de, 5, 4
	jp FillRectangle

; load the tiles for the latin, katakana, and hiragana fonts into VRAM
; from gfx/fonts/full_width/3.1bpp and gfx/fonts/full_width/4.1bpp
LoadFullWidthFontTiles::
	ld hl, FullWidthFonts + $3cc tiles_1bpp - $4000
	ld a, BANK(Fonts) ; BANK(DuelGraphics)
	call BankpushROM
	push hl
	ld e, l
	ld d, h
	ld hl, v0Tiles0
	call Copy1bppTiles
	pop de
	ld hl, v0Tiles2
	call Copy1bppTiles
	ld hl, v0Tiles1
	call Copy1bppTiles
	call BankpopROM
	ret

; copy 128 1bpp tiles from de to hl as 2bpp
Copy1bppTiles::
	ld b, $80
.tile_loop
	ld c, TILE_SIZE_1BPP
.pixel_loop
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, .pixel_loop
	dec b
	jr nz, .tile_loop
	ret
