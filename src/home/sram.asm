; switch SRAM bank to a
BankswitchSRAM::
	push af
	ldh [hBankSRAM], a
	ld [rRAMB], a
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
	pop af
	ret

; enable external RAM (SRAM)
EnableSRAM::
	push af
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
	pop af
	ret

; disable external RAM (SRAM)
DisableSRAM::
	push af
	xor a ; RAMG_SRAM_DISABLE
	ld [rRAMG], a
	pop af
	ret
