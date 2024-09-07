; sends serial data to printer
; if there's an error in connection,
; show Printer Not Connected scene with error message
_PreparePrinterConnection:
	ld bc, 0
	lb de, PRINTERPKT_DATA, FALSE
	call SendPrinterPacket
	ret nc ; return if no error

	ld hl, wPrinterStatus
	ld a, [hl]
	or a
	jr nz, .asm_19e55
	ld [hl], $ff
.asm_19e55
	ld a, [hl]
	cp $ff
	jr z, ShowPrinterIsNotConnected
;	fallthrough

; shows message on screen depending on wPrinterStatus
; also shows SCENE_GAMEBOY_PRINTER_NOT_CONNECTED.
HandlePrinterError:
	ld a, [wPrinterStatus]
	cp $ff
	jr z, .cable_or_printer_switch
	or a
	jr z, .interrupted
	bit PRINTER_ERROR_BATTERIES_LOST_CHARGE, a
	jr nz, .batteries_lost_charge
	bit PRINTER_ERROR_CABLE_PRINTER_SWITCH, a
	jr nz, .cable_or_printer_switch
	bit PRINTER_ERROR_PAPER_JAMMED, a
	jr nz, .jammed_printer

	ldtx hl, PrinterPacketErrorText
	ld a, $04
	jr ShowPrinterConnectionErrorScene
.cable_or_printer_switch
	ldtx hl, CheckCableOrPrinterSwitchText
	ld a, $02
	jr ShowPrinterConnectionErrorScene
.jammed_printer
	ldtx hl, PrinterPaperIsJammedText
	ld a, $03
	jr ShowPrinterConnectionErrorScene
.batteries_lost_charge
	ldtx hl, BatteriesHaveLostTheirChargeText
	ld a, $01
	jr ShowPrinterConnectionErrorScene
.interrupted
	ldtx hl, PrintingWasInterruptedText
	call DrawWideTextBox_WaitForInput
	scf
	ret

ShowPrinterIsNotConnected:
	ldtx hl, PrinterIsNotConnectedText
	ld a, $02
;	fallthrough

; a = error code
; hl = text ID to print in text box
ShowPrinterConnectionErrorScene:
	push hl
	; unnecessary loading TxRam, since the text data
	; already incorporate the error number
	ld l, a
	ld h, $00
	call LoadTxRam3

	call SetSpriteAnimationsAsVBlankFunction
	ld a, SCENE_GAMEBOY_PRINTER_NOT_CONNECTED
	lb bc, 0, 0
	call LoadScene
	pop hl
	call DrawWideTextBox_WaitForInput
	call RestoreVBlankFunction
	scf
	ret

; main card printer function
_RequestToPrintCard:
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer1_FromCardID
	call SetSpriteAnimationsAsVBlankFunction
	ld a, SCENE_GAMEBOY_PRINTER_TRANSMITTING
	lb bc, 0, 0
	call LoadScene
	ld a, 20
	call CopyCardNameAndLevel
	ld [hl], TX_END
	ld hl, $0
	call LoadTxRam2
	ldtx hl, NowPrintingText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call PrepareForPrinterCommunications
	call .DrawTopCardInfoInSRAMGfxBuffer0
	call Func_19f87
	call .DrawCardPicInSRAMGfxBuffer2
	call Func_19f99
	jr c, .error
	call DrawBottomCardInfoInSRAMGfxBuffer0
	call Func_1a011
	jr c, .error
	call RestoreVBlankFunction
	call ResetPrinterCommunicationSettings
	or a
	ret
.error
	call RestoreVBlankFunction
	call ResetPrinterCommunicationSettings
	jp HandlePrinterError

; draw card's picture in sGfxBuffer2
.DrawCardPicInSRAMGfxBuffer2:
	ld hl, wLoadedCard1Gfx
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, sGfxBuffer2
	call Func_37a5
	ld a, $40
	lb hl, 12,  1
	lb de,  2, 68
	lb bc, 16, 12
	call FillRectangle
	ret

; writes the tiles necessary to draw
; the card's information in sGfxBuffer0
; this includes card's type, lv, HP and attacks if Pokemon card
; or otherwise just the card's name and type symbol
.DrawTopCardInfoInSRAMGfxBuffer0:
	call Func_1a025
	call Func_212f

	; draw empty text box frame
	ld hl, sGfxBuffer0
	ld a, $34
	lb de, $30, $31
	ld b, 20
	call CopyLine
	ld c, 15
.loop_lines
	xor a ; SYM_SPACE
	lb de, $36, $37
	ld b, 20
	call CopyLine
	dec c
	jr nz, .loop_lines

	; draw card type symbol
	ld a, $38
	lb hl, 1,  2
	lb de, 1, 65
	lb bc, 2,  2
	call FillRectangle
	; print card's name
	lb de, 4, 65
	ld hl, wLoadedCard1Name
	call InitTextPrinting_ProcessTextFromPointerToID

; prints card's type, lv, HP and attacks if it's a Pokemon card
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .skip_pokemon_data
	inc a ; symbol corresponding to card's type (color)
	lb bc, 18, 65
	call WriteByteToBGMap0
	ld a, SYM_Lv
	lb bc, 11, 66
	call WriteByteToBGMap0
	ld a, [wLoadedCard1Level]
	lb bc, 12, 66
	bank1call WriteTwoDigitNumberInTxSymbolFormat
	ld a, SYM_HP
	lb bc, 15, 66
	call WriteByteToBGMap0
	ld a, [wLoadedCard1HP]
	inc b
	bank1call WriteTwoByteNumberInTxSymbolFormat
.skip_pokemon_data
	ret

Func_19f87:
	call TryInitPrinterCommunications
	ret c ; aborted
	ld hl, sGfxBuffer0
	call SendTilesToPrinter
	ret c
	call SendTilesToPrinter
	call SendPrinterInstructionPacket_1Sheet
	ret

Func_19f99:
	call TryInitPrinterCommunications
	ret c
	ld hl, sGfxBuffer0 + $8 tiles
	ld c, $06
.asm_19fa2
	call SendTilesToPrinter
	ret c
	dec c
	jr nz, .asm_19fa2
	call SendPrinterInstructionPacket_1Sheet
	ret

; writes the tiles necessary to draw
; the card's information in sGfxBuffer0
; this includes card's Retreat cost, Weakness, Resistance,
; and attack if it's Pokemon card
; or otherwise just the card's description.
DrawBottomCardInfoInSRAMGfxBuffer0:
	call Func_1a025
	xor a ; CARDPAGETYPE_NOT_PLAY_AREA
	ld [wCardPageType], a
	ld hl, sGfxBuffer0
	ld b, 20
	ld c, 9
.loop_lines
	xor a ; SYM_SPACE
	lb de, $36, $37
	call CopyLine
	dec c
	jr nz, .loop_lines
	ld a, $35
	lb de, $32, $33
	call CopyLine

	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
	jr nc, .not_pkmn_card
	ld hl, RetreatWeakResistData
	call PlaceTextItems
	ld c, 66
	bank1call DisplayCardPage_PokemonOverview.attacks
	ld a, SYM_No
	lb bc, 15, 72
	call WriteByteToBGMap0
	inc b
	ld a, [wLoadedCard1PokedexNumber]
	bank1call WriteTwoByteNumberInTxSymbolFormat
	ret

.not_pkmn_card
	bank1call SetNoLineSeparation
	lb de, 1, 66
	ld a, 19
	call InitTextPrintingInTextbox
	ld hl, wLoadedCard1NonPokemonDescription
	call ProcessTextFromPointerToID
	bank1call SetOneLineSeparation
	ret

RetreatWeakResistData:
	textitem 1, 70, RetreatText
	textitem 1, 71, WeaknessText
	textitem 1, 72, ResistanceText
	db $ff

Func_1a011:
	call TryInitPrinterCommunications
	ret c
	ld hl, sGfxBuffer0
	ld c, $05
.asm_1a01a
	call SendTilesToPrinter
	ret c
	dec c
	jr nz, .asm_1a01a
	call SendPrinterInstructionPacket_1Sheet_3LineFeeds
	ret

; calls setup text and sets wTilePatternSelector
Func_1a025:
	lb de, $40, $bf
	call SetupText
	ld a, $a4
	ld [wTilePatternSelector], a
	xor a
	ld [wTilePatternSelectorCorrection], a
	ret

; switches to CGB normal speed, resets serial
; enables SRAM and switches to SRAM1
; and clears sGfxBuffer0
PrepareForPrinterCommunications:
	call SwitchToCGBNormalSpeed
	call ResetSerial
	ld a, $10
	ld [wPrinterNumberLineFeeds], a
	call EnableSRAM
	ld a, [sPrinterContrastLevel]
	ld [wPrinterContrastLevel], a
	call DisableSRAM
	ldh a, [hBankSRAM]
	ld [wTempPrinterSRAM], a
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	call EnableSRAM
;	fallthrough

ClearPrinterGfxBuffer:
	ld hl, sGfxBuffer0
	ld bc, $400
.loop
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .loop
	xor a
	ld [wce9f], a
	ret

; reverts settings changed by PrepareForPrinterCommunications
ResetPrinterCommunicationSettings:
	push af
	call SwitchToCGBDoubleSpeed
	ld a, [wTempPrinterSRAM]
	call BankswitchSRAM
	call DisableSRAM
	lb de, $30, $bf
	call SetupText
	pop af
	ret

; send some bytes through serial
Func_1a080: ; unreferenced
	ld bc, 0
	lb de, PRINTERPKT_NUL, FALSE
	jp SendPrinterPacket

; tries initiating the communications for
; sending data to printer
; returns carry if operation was cancelled
; by pressing B button or serial transfer took long
TryInitPrinterCommunications:
	xor a
	ld [wPrinterInitAttempts], a
.wait_input
	call DoFrame
	ldh a, [hKeysHeld]
	and B_BUTTON
	jr nz, .b_button
	ld bc, 0
	lb de, PRINTERPKT_NUL, FALSE
	call SendPrinterPacket
	jr c, .delay
	and (1 << PRINTER_STATUS_BUSY) | (1 << PRINTER_STATUS_PRINTING)
	jr nz, .wait_input

.init
	ld bc, 0
	lb de, PRINTERPKT_INIT, FALSE
	call SendPrinterPacket
	jr nc, .no_carry
	ld hl, wPrinterInitAttempts
	inc [hl]
	ld a, [hl]
	cp 3
	jr c, .wait_input
	; time out
	scf
	ret
.no_carry
	ret

.b_button
	xor a
	ld [wPrinterStatus], a
	scf
	ret

.delay
	ld c, 10
.delay_loop
	call DoFrame
	dec c
	jr nz, .delay_loop
	jr .init

; loads tiles given by map in hl to sGfxBuffer5
; copies first 20 tiles, then offsets by 2 tiles
; and copies another 20
; compresses this data and sends it to printer
SendTilesToPrinter:
	push bc
	ld de, sGfxBuffer5
	call .Copy20Tiles
	call .Copy20Tiles
	push hl
	call CompressDataForPrinterSerialTransfer
	call SendPrinterPacket
	pop hl
	pop bc
	ret

; copies 20 tiles given by hl to de
; then adds 2 tiles to hl
.Copy20Tiles
	push hl
	ld c, 20
.loop_tiles
	ld a, [hli]
	call .CopyTile
	dec c
	jr nz, .loop_tiles
	pop hl
	ld bc, 2 tiles
	add hl, bc
	ret

; copies a tile to de
; a = tile to get from sGfxBuffer1
.CopyTile
	push hl
	push bc
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl ; *TILE_SIZE
	ld bc, sGfxBuffer1
	add hl, bc
	ld c, TILE_SIZE
.loop_copy
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop_copy
	pop bc
	pop hl
	ret

SendPrinterInstructionPacket_1Sheet_3LineFeeds:
	call GetPrinterContrastSerialData
	push hl
	lb hl, 3, 1
	jr SendPrinterInstructionPacket

; uses wPrinterNumberLineFeeds to get number
; of line feeds to insert before print
SendPrinterInstructionPacket_1Sheet:
	call GetPrinterContrastSerialData
	push hl
	ld hl, wPrinterNumberLineFeeds
	ld a, [hl]
	ld [hl], $00
	ld h, a
	ld l, 1
;	fallthrough

; h = number of line feeds where:
;     high nybble is number of line feeds before printing
;     low nybble is number of line feeds after printing
; l = number of sheets
; expects printer contrast information to be on stack
SendPrinterInstructionPacket:
	push hl
	ld bc, 0
	lb de, PRINTERPKT_DATA, FALSE
	call SendPrinterPacket
	jr c, .aborted
	ld hl, sp+$00 ; contrast level bytes
	ld bc, 4 ; instruction packets are 4 bytes in size
	lb de, PRINTERPKT_PRINT_INSTRUCTION, FALSE
	call SendPrinterPacket
.aborted
	pop hl
	pop hl
	ret

; returns in h and l the bytes
; to be sent through serial to the printer
; for the set contrast level
GetPrinterContrastSerialData:
	ld a, [wPrinterContrastLevel]
	ld e, a
	ld d, $00
	ld hl, .contrast_level_data
	add hl, de
	ld h, [hl]
	ld l, %11100100 ; palette format
	ret

.contrast_level_data
	db $00, $20, $40, $60, $7f

Func_1a14b: ; unreferenced
	ld a, $01
	jr .asm_1a15d
	ld a, $02
	jr .asm_1a15d
	ld a, $03
	jr .asm_1a15d
	ld a, $04
	jr .asm_1a15d
	ld a, $05
.asm_1a15d
	ld [wce9d], a
	scf
	ret

; a = saved deck index to print
_PrintDeckConfiguration:
; copies selected deck from SRAM to wDuelTempList
	call EnableSRAM
	ld l, a
	ld h, DECK_STRUCT_SIZE
	call HtimesL
	ld de, sSavedDeck1
	add hl, de
	ld de, wDuelTempList
	ld bc, DECK_STRUCT_SIZE
	call CopyDataHLtoDE
	call DisableSRAM

	call ShowPrinterTransmitting
	call PrepareForPrinterCommunications
	call Func_1a025
	call Func_212f
	lb de, 0, 64
	lb bc, 20, 4
	call DrawRegularTextBoxDMG
	lb de, 4, 66
	call InitTextPrinting
	ld hl, wDuelTempList ; print deck name
	call ProcessText
	ldtx hl, DeckPrinterText
	call ProcessTextFromID

	ld a, 5
	ld [wPrinterHorizontalOffset], a
	ld hl, wPrinterTotalCardCount
	xor a
	ld [hli], a
	ld [hl], a
	ld [wPrintOnlyStarRarity], a

	ld hl, wCurDeckCards
.loop_cards
	ld a, [hl]
	or a
	jr z, .asm_1a1d6
	ld e, a
	ld d, $00
	call LoadCardDataToBuffer1_FromCardID

	; find out this card's count
	ld a, [hli]
	ld b, a
	ld c, 1
.loop_card_count
	cp [hl]
	jr nz, .got_card_count
	inc hl
	inc c
	jr .loop_card_count

.got_card_count
	ld a, c
	ld [wPrinterCardCount], a
	call LoadCardInfoForPrinter
	call AddToPrinterGfxBuffer
	jr c, .printer_error
	jr .loop_cards

.asm_1a1d6
	call SendCardListToPrinter
	jr c, .printer_error
	call ResetPrinterCommunicationSettings
	call RestoreVBlankFunction
	or a
	ret

.printer_error
	call ResetPrinterCommunicationSettings
	call RestoreVBlankFunction
	jp HandlePrinterError

SendCardListToPrinter:
	ld a, [wPrinterHorizontalOffset]
	cp 1
	jr z, .skip_load_gfx
	call LoadGfxBufferForPrinter
	ret c
.skip_load_gfx
	call TryInitPrinterCommunications
	ret c
	call SendPrinterInstructionPacket_1Sheet_3LineFeeds
	ret

; increases printer horizontal offset by 2
AddToPrinterGfxBuffer:
	push hl
	ld hl, wPrinterHorizontalOffset
	inc [hl]
	inc [hl]
	ld a, [hl]
	pop hl
	; return no carry if below 18
	cp 18
	ccf
	ret nc
	; >= 18
;	fallthrough

; copies Gfx to Gfx buffer and sends some serial data
; returns carry set if unsuccessful
LoadGfxBufferForPrinter:
	push hl
	call TryInitPrinterCommunications
	jr c, .set_carry
	ld a, [wPrinterHorizontalOffset]
	srl a
	ld c, a
	ld hl, sGfxBuffer0
.loop_gfx_buffer
	call SendTilesToPrinter
	jr c, .set_carry
	dec c
	jr nz, .loop_gfx_buffer
	call SendPrinterInstructionPacket_1Sheet
	jr c, .set_carry

	call ClearPrinterGfxBuffer
	ld a, 1
	ld [wPrinterHorizontalOffset], a
	pop hl
	or a
	ret

.set_carry
	pop hl
	scf
	ret

; load symbol, name, level and card count to buffer
LoadCardInfoForPrinter:
	push hl
	ld a, [wPrinterHorizontalOffset]
	or %1000000
	ld e, a
	ld d, 3
	ld a, [wPrintOnlyStarRarity]
	or a
	jr nz, .skip_card_symbol
	ld hl, wPrinterTotalCardCount
	ld a, [hli]
	or [hl]
	call z, DrawCardSymbol
.skip_card_symbol
	ld a, 14
	call CopyCardNameAndLevel
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ld a, [wPrinterHorizontalOffset]
	or %1000000
	ld c, a
	ld b, 16
	ld a, SYM_CROSS
	call WriteByteToBGMap0
	inc b
	ld a, [wPrinterCardCount]
	bank1call WriteTwoDigitNumberInTxSymbolFormat
	pop hl
	ret

_PrintCardList:
; if Select button is held when printing card list
; only print cards with Star rarity (excluding Promotional cards)
; even if it's not marked as seen in the collection
	ld e, FALSE
	ldh a, [hKeysHeld]
	and SELECT
	jr z, .no_select
	inc e ; TRUE
.no_select
	ld a, e
	ld [wPrintOnlyStarRarity], a

	call ShowPrinterTransmitting
	call CreateTempCardCollection
	ld de, wDefaultText
	call CopyPlayerName
	call PrepareForPrinterCommunications
	call Func_1a025
	call Func_212f

	lb de, 0, 64
	lb bc, 20, 4
	call DrawRegularTextBoxDMG
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	lb de, 2, 66
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText
	ldtx hl, AllCardsOwnedText
	call ProcessTextFromID
	ld a, [wPrintOnlyStarRarity]
	or a
	jr z, .asm_1a2c2
	ld a, TX_HALF2FULL
	call ProcessSpecialTextCharacter
	lb de, 3, 84
	call Func_22ca
.asm_1a2c2
	ld a, $ff
	ld [wCurPrinterCardType], a
	xor a
	ld hl, wPrinterTotalCardCount
	ld [hli], a
	ld [hl], a
	ld [wPrinterNumCardTypes], a
	ld a, 5
	ld [wPrinterHorizontalOffset], a

	ld e, GRASS_ENERGY
.loop_cards
	push de
	ld d, $00
	call LoadCardDataToBuffer1_FromCardID
	jr c, .done_card_loop
	ld d, HIGH(wTempCardCollection)
	ld a, [de] ; card ID count in collection
	ld [wPrinterCardCount], a
	call .LoadCardTypeEntry
	jr c, .printer_error_pop_de

	ld a, [wPrintOnlyStarRarity]
	or a
	jr z, .all_owned_cards_mode
	ld a, [wLoadedCard1Set]
	and %11110000
	cp PROMOTIONAL
	jr z, .next_card
	ld a, [wLoadedCard1Rarity]
	cp STAR
	jr nz, .next_card
	; not Promotional, and Star rarity
	ld hl, wPrinterCardCount
	res CARD_NOT_OWNED_F, [hl]
	jr .got_card_count

.all_owned_cards_mode
	ld a, [wPrinterCardCount]
	or a
	jr z, .next_card
	cp CARD_NOT_OWNED
	jr z, .next_card ; ignore not owned cards

.got_card_count
	ld a, [wPrinterCardCount]
	and CARD_COUNT_MASK
	ld c, a

	; add to total card count
	ld hl, wPrinterTotalCardCount
	add [hl]
	ld [hli], a
	ld a, 0
	adc [hl]
	ld [hl], a

	; add to current card type count
	ld hl, wPrinterCurCardTypeCount
	ld a, c
	add [hl]
	ld [hli], a
	ld a, 0
	adc [hl]
	ld [hl], a

	ld hl, wPrinterNumCardTypes
	inc [hl]
	ld hl, wce98
	inc [hl]
	call LoadCardInfoForPrinter
	call AddToPrinterGfxBuffer
	jr c, .printer_error_pop_de
.next_card
	pop de
	inc e
	jr .loop_cards

.printer_error_pop_de
	pop de
.printer_error
	call ResetPrinterCommunicationSettings
	call RestoreVBlankFunction
	jp HandlePrinterError

.done_card_loop
	pop de
	; add separator line
	ld a, [wPrinterHorizontalOffset]
	dec a
	or $40
	ld c, a
	ld b, 0
	call BCCoordToBGMap0Address
	ld a, $35
	lb de, $35, $35
	ld b, 20
	call CopyLine
	call AddToPrinterGfxBuffer
	jr c, .printer_error

	ld hl, wPrinterTotalCardCount
	ld c, [hl]
	inc hl
	ld b, [hl]
	ldtx hl, TotalNumberOfCardsText
	call .PrintTextWithNumber
	jr c, .printer_error
	ld a, [wPrintOnlyStarRarity]
	or a
	jr nz, .done
	ld a, [wPrinterNumCardTypes]
	ld c, a
	ld b, 0
	ldtx hl, TypesOfCardsText
	call .PrintTextWithNumber
	jr c, .printer_error

.done
	call SendCardListToPrinter
	jr c, .printer_error
	call ResetPrinterCommunicationSettings
	call RestoreVBlankFunction
	or a
	ret

; prints text ID given in hl
; with decimal representation of
; the number given in bc
; hl = text ID
; bc = number
.PrintTextWithNumber
	push bc
	ld a, [wPrinterHorizontalOffset]
	dec a
	or $40
	ld e, a
	ld d, 2
	call InitTextPrinting
	call ProcessTextFromID
	ld d, 14
	call InitTextPrinting
	pop hl
	call TwoByteNumberToTxSymbol_TrimLeadingZeros
	ld hl, wStringBuffer
	call ProcessText
	call AddToPrinterGfxBuffer
	ret

; loads this card's type icon and text
; if it's a new card type that hasn't been printed yet
.LoadCardTypeEntry
	ld a, [wLoadedCard1Type]
	ld c, a
	cp TYPE_ENERGY
	jr c, .got_type ; jump if Pokemon card
	ld c, $08
	cp TYPE_TRAINER
	jr nc, .got_type ; jump if Trainer card
	ld c, $07
.got_type
	ld hl, wCurPrinterCardType
	ld a, [hl]
	cp c
	ret z ; already handled this card type

	; show corresponding icon and text
	; for this new card type
	ld a, c
	ld [hl], a ; set it as current card type
	add a
	add c ; *3
	ld c, a
	ld b, $00
	ld hl, .IconTextList
	add hl, bc
	ld a, [wPrinterHorizontalOffset]
	dec a
	or %1000000
	ld e, a
	ld d, 1
	ld a, [hli]
	push hl
	lb bc, 2, 2
	lb hl, 1, 2
	call FillRectangle
	pop hl
	ld d, 3
	inc e
	call InitTextPrinting
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call ProcessTextFromID

	call AddToPrinterGfxBuffer
	ld hl, wPrinterCurCardTypeCount
	xor a
	ld [hli], a
	ld [hl], a
	ld [wce98], a
	ret

.IconTextList
	; Fire
	db $e0 ; icon tile
	tx FirePokemonText

	; Grass
	db $e4 ; icon tile
	tx GrassPokemonText

	; Lightning
	db $e8 ; icon tile
	tx LightningPokemonText

	; Water
	db $ec ; icon tile
	tx WaterPokemonText

	; Fighting
	db $f0 ; icon tile
	tx FightingPokemonText

	; Psychic
	db $f4 ; icon tile
	tx PsychicPokemonText

	; Colorless
	db $f8 ; icon tile
	tx ColorlessPokemonText

	; Energy
	db $fc ; icon tile
	tx EnergyCardText

	; Trainer
	db $dc ; icon tile
	tx TrainerCardText

ShowPrinterTransmitting:
	call SetSpriteAnimationsAsVBlankFunction
	ld a, SCENE_GAMEBOY_PRINTER_TRANSMITTING
	lb bc, 0, 0
	call LoadScene
	ldtx hl, NowPrintingPleaseWaitText
	call DrawWideTextBox_PrintText
	call EnableLCD
	ret

; compresses $28 tiles in sGfxBuffer5
; and writes it in sGfxBuffer5 + $28 tiles.
; compressed data has 2 commands to instruct on how to decompress it.
; - a command byte with bit 7 not set, means to copy that many + 1
; bytes that are following it literally.
; - a command byte with bit 7 set, means to copy the following byte
; that many times + 2 (after masking the top bit of command byte).
; returns in bc the size of the compressed data and
; in de the packet type data.
CompressDataForPrinterSerialTransfer:
	ld hl, sGfxBuffer5
	ld de, sGfxBuffer5 + $28 tiles
	ld bc, $28 tiles
.loop_remaining_data
	ld a, $ff
	inc b
	dec b
	jr nz, .check_compression
	ld a, c
.check_compression
	push bc
	push de
	ld c, a
	call CheckDataCompression
	ld a, e
	ld c, e
	pop de
	jr c, .copy_byte
	ld a, c
	ld b, c
	dec a
	ld [de], a ; number of bytes to  copy literally - 1
	inc de
.copy_literal_sequence
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_literal_sequence
	ld c, b
	jr .sub_added_bytes

.copy_byte
	ld a, c
	dec a
	dec a
	or %10000000 ; set high bit
	ld [de], a ; = (n times to copy - 2) | %10000000
	inc de
	ld a, [hl] ; byte to copy n times
	ld [de], a
	inc de
	ld b, $0
	add hl, bc

.sub_added_bytes
	ld a, c
	cpl
	inc a
	pop bc
	add c
	ld c, a
	ld a, $ff
	adc b
	ld b, a
	or c
	jr nz, .loop_remaining_data

	ld hl, $10000 - (sGfxBuffer5 + $28 tiles)
	add hl, de ; gets the size of the compressed data
	ld c, l
	ld b, h
	ld hl, sGfxBuffer5 + $28 tiles
	lb de, PRINTERPKT_DATA, TRUE
	ret

; checks whether the next byte sequence in hl, up to c bytes, can be compressed
; returns carry if the next sequence of bytes can be compressed,
; i.e. has at least 3 consecutive bytes with the same value.
; in that case, returns in e the number of consecutive
; same value bytes that were found.
; if there are no bytes with same value, then count as many bytes left
; as possible until either there are no more remaining data bytes,
; or until a sequence of 3 bytes with the same value are found.
; in that case, the number of bytes in this sequence is returned in e.
CheckDataCompression:
	push hl
	ld e, c
	ld a, c
; if number of remaining bytes is less than 4
; then no point in compressing
	cp 4
	jr c, .no_carry

; check first if there are at least
; 3 consecutive bytes with the same value
	ld b, c
	ld a, [hli]
	cp [hl]
	inc hl
	jr nz, .literal_copy ; not same
	cp [hl]
	inc hl
	jr nz, .literal_copy ; not same

; 3 consecutive bytes were found with same value
; keep track of how many consecutive bytes
; with the same value there are in e
	dec c
	dec c
	dec c
	ld e, 3
.loop_same_value
	cp [hl]
	jr nz, .set_carry ; exit when a different byte is found
	inc hl
	inc e
	dec c
	jr z, .set_carry ; exit when there is no more remaining data
	bit 5, e
	; exit if number of consecutive bytes >= $20
	jr z, .loop_same_value
.set_carry
	pop hl
	scf
	ret

.literal_copy
; consecutive bytes are not the same value
; count the number of bytes there are left
; until a sequence of 3 bytes with the same value is found
	pop hl
	push hl
	ld c, b ; number of remaining bytes
	ld e, 1
	ld a, [hli]
	dec c
	jr z, .no_carry ; exit if no more data
.reset_same_value_count
	ld d, 2 ; number of consecutive same value bytes to exit
.next_byte
	inc e
	dec c
	jr z, .no_carry
	bit 7, e
	jr nz, .no_carry ; exit if >= $80
	cp [hl]
	jr z, .same_consecutive_value
	ld a, [hli]
	jr .reset_same_value_count
.no_carry
	pop hl
	or a
	ret

.same_consecutive_value
	inc hl
	dec d
	jr nz, .next_byte
	; 3 consecutive bytes with same value found
	; discard the last 3 bytes in the sequence
	dec e
	dec e
	dec e
	jr .no_carry
