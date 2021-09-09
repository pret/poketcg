; switch SRAM bank to a
BankswitchSRAM: ; 07a9 (0:07a9)
	push af
	ldh [hBankSRAM], a
	ld [MBC3SRamBank], a
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; enable external RAM (SRAM)
EnableSRAM: ; 07b6 (0:07b6)
	push af
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; disable external RAM (SRAM)
DisableSRAM: ; 07be (0:07be)
	push af
	xor a ; SRAM_DISABLE
	ld [MBC3SRamEnable], a
	pop af
	ret
