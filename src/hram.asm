SECTION "HRAM", HRAM

hBankROM:: ; ff80
	ds 1

hBankRAM:: ; ff81
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

	ds 1

; $c2 = player ; $c3 = opponent
hWhoseTurn:: ; ff97
	ds 1

	ds 23

hffaf:: ; ffaf
	ds 1

	ds 5

hffb5:: ; ffb5
	ds 1
