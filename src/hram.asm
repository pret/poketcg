SECTION "HRAM", HRAM

hBankROM:: ; ff80
	ds 1

hBankSRAM:: ; ff81
	ds 1

hBankVRAM:: ; ff82
	ds 1

hDMAFunction:: ; ff83
	ds 10

hDPadRepeat:: ; ff8d
	ds 1

hButtonsReleased:: ; ff8e
	ds 1

hButtonsPressed2:: ; ff8f
	ds 1

hButtonsHeld:: ; ff90
	ds 1

hButtonsPressed:: ; ff91
	ds 1

hSCX:: ; ff92
	ds 1

hSCY:: ; ff93
	ds 1

hWX:: ; ff94
	ds 1

hWY:: ; ff95
	ds 1

hff96:: ; ff96
	ds 1

; $c2 = player ; $c3 = opponent
hWhoseTurn:: ; ff97
	ds 1

; deck index of a card (0-59)
hTempCardIndex_ff98:: ; ff98
	ds 1

; used in SortCardsInListByID
hTempListPtr_ff99:: ; ff99
	ds 2

; used in SortCardsInListByID
; this function supports 16-bit card IDs
hTempCardID_ff9b:: ; ff9b
	ds 2

; a PLAY_AREA_ARENA constant (0: arena card, 1-5: bench card)
hTempPlayAreaLocationOffset_ff9d:: ; ff9d
	ds 1

hAIActionTableIndex:: ; ff9e
	ds 1

hTempCardIndex_ff9f:: ; ff9f
	ds 1

; multipurpose temp storage
hffa0:: ; ffa0
	ds 1

hTempPlayAreaLocationOffset_ffa1:: ; ffa1
	ds 1

	ds 6

; hffa8 through hffb0 appear to be related to text processing
hffa8:: ; ffa8
	ds 1

hffa9:: ; ffa9
	ds 1

hffaa:: ; ffaa
	ds 1

hffab:: ; ffab
	ds 1

hffac:: ; ffac
	ds 1

hffad:: ; ffad
	ds 1

hffae:: ; ffae
	ds 1

hffaf:: ; ffaf
	ds 1

hffb0:: ; ffb0
	ds 1

hCurrentMenuItem:: ; ffb1
	ds 1

	ds 3

hffb5:: ; ffb5
	ds 1

; used in DivideBCbyDE
hffb6:: ; ffb6
	ds 1