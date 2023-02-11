; loads wConsolePaletteData depending on console
; every entry in the list is $00
LoadConsolePaletteData:
	push hl
	ld a, [wConsole]
	add LOW(.PaletteDataTable)
	ld l, a
	ld a, HIGH(.PaletteDataTable)
	adc 0
	ld h, a
	ld a, [hl]
	ld [wConsolePaletteData], a
	xor a
	ld [wd317], a
	pop hl
	ret

.PaletteDataTable:
	db $00 ; CONSOLE_DMG
	db $00 ; CONSOLE_SGB
	db $00 ; CONSOLE_CGB

FadeScreenToWhite:
	ld a, [wLCDC]
	bit LCDC_ENABLE_F, a
	jr z, .lcd_off
	ld a, [wConsolePaletteData]
	ld [wTempBGP], a
	ld [wTempOBP0], a
	ld [wTempOBP1], a
	ld de, PALRGB_WHITE
	ld hl, wTempBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes
	call FillMemoryWithDE
	call RestoreFirstColorInOBPals
	call FadeScreenToTempPals
	call DisableLCD
	ret

.lcd_off
	ld a, [wConsolePaletteData]
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	ld de, PALRGB_WHITE
	ld hl, wBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes
	call FillMemoryWithDE
	call FlushAllPalettes
	ret

FadeScreenFromWhite:
	call .BackupPalsAndSetWhite
	call RestoreFirstColorInOBPals
	call FlushAllPalettes
	call EnableLCD
	jp FadeScreenToTempPals

.BackupPalsAndSetWhite
	ld a, [wBGP]
	ld [wTempBGP], a
	ld a, [wOBP0]
	ld [wTempOBP0], a
	ld a, [wOBP1]
	ld [wTempOBP1], a
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes + NUM_OBJECT_PALETTES palettes
	call CopyDataHLtoDE_SaveRegisters
	jr SetWhitePalettes ; can be fallthrough

; fills wBackgroundPalettesCGB with white pal
SetWhitePalettes:
	ld a, [wConsolePaletteData]
	ld [wBGP], a
	ld [wOBP0], a
	ld [wOBP1], a
	ld de, PALRGB_WHITE
	ld hl, wBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes
	call FillMemoryWithDE
	ret

; gets from backup OB pals the first color
; of each pal and writes them in wObjectPalettesCGB
RestoreFirstColorInOBPals:
	ld hl, wTempObjectPalettesCGB
	ld de, wObjectPalettesCGB
	ld c, NUM_OBJECT_PALETTES
.loop_pals
	push bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld bc, CGB_PAL_SIZE - 1
	add hl, bc
	ld a, c
	add e
	ld e, a
	ld a, b
	adc d
	ld d, a
	pop bc
	dec c
	jr nz, .loop_pals
	ret

FadeScreenToTempPals:
	ld a, [wVBlankCounter]
	push af
	ld c, $10
.loop
	push bc
	ld a, c
	and %11
	cp 0
	call z, Func_10b85
	call FadeBGPalIntoTemp3
	call FadeOBPalIntoTemp
	call FlushAllPalettes
	call DoFrameIfLCDEnabled
	pop bc
	dec c
	dec c
	jr nz, .loop
	pop af
	ld b, a
	ld a, [wVBlankCounter]
	sub b
	ret

; does something with wBGP given wTempBGP
; mixes them into a single value?
Func_10b85:
	push bc
	ld c, $03
	ld hl, wBGP
	ld de, wTempBGP
.asm_10b8e
	push bc
	ld b, [hl]
	ld a, [de]
	ld c, a
	call .Func_10b9e
	ld [hl], a
	pop bc
	inc de
	inc hl
	dec c
	jr nz, .asm_10b8e
	pop bc
	ret

.Func_10b9e
	push bc
	push de
	ld e, 4
	ld d, $00
.loop
	call .Func_10bba
	or d
	rlca
	rlca
	ld d, a
	rlc b
	rlc b
	rlc c
	rlc c
	dec e
	jr nz, .loop
	ld a, d
	pop de
	pop bc
	ret

; calculates ((b & %11) << 2) | (c & %11)
; that is, %0000xxyy, where x and y are
; the 2 lower bits of b and c respectively
; and outputs the entry from a table given that value
.Func_10bba
	push hl
	push bc
	ld a, %11
	and b
	add a
	add a
	ld b, a
	ld a, %11
	and c
	or b
	ld c, a
	ld b, $00
	ld hl, .data_10bd1
	add hl, bc
	ld a, [hl]
	pop bc
	pop hl
	ret

.data_10bd1
	db %00 ; b = %00 | c = %00
	db %01 ; b = %00 | c = %01
	db %01 ; b = %00 | c = %10
	db %01 ; b = %00 | c = %11
	db %00 ; b = %01 | c = %00
	db %01 ; b = %01 | c = %01
	db %10 ; b = %01 | c = %10
	db %10 ; b = %01 | c = %11
	db %01 ; b = %10 | c = %00
	db %01 ; b = %10 | c = %01
	db %10 ; b = %10 | c = %10
	db %11 ; b = %10 | c = %11
	db %10 ; b = %11 | c = %00
	db %10 ; b = %11 | c = %01
	db %10 ; b = %11 | c = %10
	db %11 ; b = %11 | c = %11

FadeOBPalIntoTemp:
	push bc
	ld c, 4 palettes
	ld hl, wObjectPalettesCGB
	ld de, wTempObjectPalettesCGB
	jr FadePalIntoAnother

FadeBGPalIntoTemp1:
	push bc
	ld c, 2 palettes
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	jr FadePalIntoAnother

FadeBGPalIntoTemp2:
	push bc
	ld c, 2 palettes
	ld hl, wBackgroundPalettesCGB + 4 palettes
	ld de, wTempBackgroundPalettesCGB + 4 palettes
	jr FadePalIntoAnother

FadeBGPalIntoTemp3:
	push bc
	ld c, 4 palettes
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
;	fallthrough

; hl = input pal to modify
; de = pal to fade into
; c = number of colors to fade
FadePalIntoAnother:
	push bc
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	push de
	push bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop de
	call .GetFadedColor
	; overwrite with new color
	ld [hld], a
	ld [hl], c
	inc hl
	inc hl
	pop de
	pop bc
	dec c
	jr nz, FadePalIntoAnother
	pop bc
	ret

; fade pal bc to de
; output resulting pal in a and c
.GetFadedColor
	push hl
	ld a, c
	cp e
	jr nz, .unequal
	ld a, b
	cp d
	jr z, .skip

.unequal
	; red
	ld a, e
	and %11111
	ld l, a
	ld a, c
	and %11111
	call .FadeColor
	ldh [hffb6], a

	; green
	ld a, e
	and %11100000
	ld l, a
	ld a, d
	and %11
	or l
	swap a
	rrca
	ld l, a
	ld a, c
	and %11100000
	ld h, a
	ld a, b
	and %11
	or h
	swap a
	rrca
	call .FadeColor
	rlca
	swap a
	ld h, a
	and %11
	ldh [hffb7], a
	ld a, %11100000
	and h
	ld h, a
	ldh a, [hffb6]
	or h
	ld h, a

	; blue
	ld a, d
	and %1111100
	rrca
	rrca
	ld l, a
	ld a, b
	and %1111100
	rrca
	rrca
	call .FadeColor
	rlca
	rlca
	ld b, a
	ldh a, [hffb7]
	or b
	ld c, h
.skip
	pop hl
	ret

; compares color in a and in l
; if a is smaller/greater than l, then
; increase/decrease its value up to l
; up to a maximum of 4
; a = pal color (red, green or blue)
; l = pal color (red, green or blue)
.FadeColor
	cp l
	ret z ; same value
	jr c, .incr_a
; decr a
	dec a
	cp l
	ret z
	dec a
	cp l
	ret z
	dec a
	cp l
	ret z
	dec a
	ret

.incr_a
	inc a
	cp l
	ret z
	inc a
	cp l
	ret z
	inc a
	cp l
	ret z
	inc a
	ret

; fades screen to white then
; if c == 0, fade back in
; keep white otherwise
FlashScreenToWhite:
	ldh a, [hBankSRAM]
	push af
	push bc
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	call CopyPalsToSRAMBuffer
	call FadeScreenToWhite
	pop bc
	ld a, c
	or a
	jr nz, .skip_fade_in
	call LoadPalsFromSRAMBuffer
	call FadeScreenFromWhite
.skip_fade_in
	call EnableLCD
	pop af
	call BankswitchSRAM
	call DisableSRAM
	ret

; copies current BG and OP pals,
; wBackgroundPalettesCGB and wObjectPalettesCGB
; to sGfxBuffer2
CopyPalsToSRAMBuffer:
	ldh a, [hBankSRAM]

	push af
	cp BANK("SRAM1")
	jr z, .ok
	debug_nop
.ok
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	ld hl, sGfxBuffer2
	ld a, [wBGP]
	ld [hli], a
	ld a, [wOBP0]
	ld [hli], a
	ld a, [wOBP1]
	ld [hli], a
	ld e, l
	ld d, h
	ld hl, wBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes + NUM_OBJECT_PALETTES palettes
	call CopyDataHLtoDE_SaveRegisters
	pop af

	call BankswitchSRAM
	call DisableSRAM
	ret

; loads BG and OP pals,
; wBackgroundPalettesCGB and wObjectPalettesCGB
; from sGfxBuffer2
LoadPalsFromSRAMBuffer:
	ldh a, [hBankSRAM]

	push af
	cp BANK("SRAM1")
	jr z, .ok
	debug_nop
.ok
	ld a, BANK("SRAM1")
	call BankswitchSRAM
	ld hl, sGfxBuffer2
	ld a, [hli]
	ld [wBGP], a
	ld a, [hli]
	ld [wOBP0], a
	ld a, [hli]
	ld [wOBP1], a
	ld de, wBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes + NUM_OBJECT_PALETTES palettes
	call CopyDataHLtoDE_SaveRegisters
	pop af

	call BankswitchSRAM
	call DisableSRAM
	ret

; backs up all palettes
; and writes 4 BG pals with white pal
Func_10d17:
	ld a, [wBGP]
	ld [wTempBGP], a
	ld a, [wOBP0]
	ld [wTempOBP0], a
	ld a, [wOBP1]
	ld [wTempOBP1], a
	ld hl, wBackgroundPalettesCGB
	ld de, wTempBackgroundPalettesCGB
	ld bc, NUM_BACKGROUND_PALETTES palettes + NUM_OBJECT_PALETTES palettes
	call CopyDataHLtoDE_SaveRegisters

	ld a, [wConsolePaletteData]
	ld [wBGP], a
	ld de, PALRGB_WHITE
	ld hl, wBackgroundPalettesCGB
	ld bc, 4 palettes
	call FillMemoryWithDE
	call FlushAllPalettes

	ld a, $10
	ld [wd317], a
	ret

Func_10d50:
	ld a, [wConsolePaletteData]
	ld [wTempBGP], a
	ld a, [wOBP0]
	ld [wTempOBP0], a
	ld a, [wOBP1]
	ld [wTempOBP1], a
	ld de, PALRGB_WHITE
	ld hl, wTempBackgroundPalettesCGB
	ld bc, 4 palettes
	call FillMemoryWithDE
	ld a, $10
	ld [wd317], a
	ret

; does stuff according to bottom 2 bits from wd317:
; - if equal to %01, modify wBGP
; - if bottom bit not set, fade BG pals 0 and 1
; - if bottom bit is set, fade BG pals 4 and 5
;   and Flush Palettes
; then decrements wd317
; does nothing if wd317 is 0
Func_10d74:
	ld a, [wd317]
	or a
	ret z
	and %11
	ld c, a
	cp $1
	call z, Func_10b85
	bit 0, c
	call z, FadeBGPalIntoTemp1
	bit 0, c
	call nz, FadeBGPalIntoTemp2
	bit 0, c
	call nz, FlushAllPalettes
	ld a, [wd317]
	dec a
	ld [wd317], a
	ret
