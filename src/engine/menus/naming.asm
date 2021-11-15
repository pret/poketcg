DisplayPlayerNamingScreen:
	; clear the name buffer.
	ld hl, wNameBuffer ; c500: name buffer.
	ld bc, NAME_BUFFER_LENGTH
	ld a, TX_END
	call FillMemoryWithA

	; get player's name
	; from the user into hl.
	ld hl, wNameBuffer
	farcall InputPlayerName

	farcall WhiteOutDMGPals
	call DoFrameIfLCDEnabled
	call DisableLCD
	ld hl, wNameBuffer
	; get the first byte of the name buffer.
	ld a, [hl]
	or a
	; check if anything typed.
	jr nz, .no_name
	ld hl, .default_name
.no_name
	; set the default name.
	ld de, sPlayerName
	ld bc, NAME_BUFFER_LENGTH
	call EnableSRAM
	call CopyDataHLtoDE_SaveRegisters
	; it seems for integrity checking.
	call UpdateRNGSources
	ld [sPlayerName+$e], a
	call UpdateRNGSources
	ld [sPlayerName+$f], a
	call DisableSRAM
	ret

.default_name
	; "MARK": default player name.
	textfw3 "MARK"
	db TX_END, TX_END, TX_END, TX_END

Unknown_128f7:
	db  0,  0 ; start menu coords
	db 16, 18 ; start menu text box dimensions

	db  2, 2 ; text alignment for InitTextPrinting
	tx DebugMenuText
	db $ff

	db 1, 2 ; cursor x, cursor y
	db 1 ; y displacement between items
	db 11 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_12908:
	db 10, 0 ; start menu coords
	db 10, 6 ; start menu text box dimensions

	db 12, 2 ; text alignment for InitTextPrinting
	tx Text037b
	db $ff

	db 11, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_12919:
	db  0,  0 ; start menu coords
	db 12, 12 ; start menu text box dimensions

	db  2, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackMenuText
	db $ff

	db 1, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1292a:
	db 12,  0 ; start menu coords
	db  4, 16 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackColosseumEvolutionMenuText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 7 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1293b:
	db 12,  0 ; start menu coords
	db  4, 14 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackMysteryMenuText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 6 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1294c:
	db 12,  0 ; start menu coords
	db  4, 12 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackLaboratoryMenuText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 5 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0

Unknown_1295d:
	db 12,  0 ; start menu coords
	db  4, 10 ; start menu text box dimensions

	db 14, 2 ; text alignment for InitTextPrinting
	tx DebugBoosterPackEnergyMenuText
	db $ff

	db 13, 2 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 4 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw NULL ; function pointer if non-0
