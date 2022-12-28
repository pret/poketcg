; switch SRAM bank to a
BankswitchSRAM::
	push af
	ldh [hBankSRAM], a
	ld [MBC3SRamBank], a
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; enable external RAM (SRAM)
EnableSRAM::
	push af
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; disable external RAM (SRAM)
DisableSRAM::
	push af
	xor a ; SRAM_DISABLE
	ld [MBC3SRamEnable], a
	pop af
	ret
