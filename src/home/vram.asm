; set current dest VRAM bank to 0
BankswitchVRAM0: ; 07c5 (0:07c5)
	push af
	xor a
	ldh [hBankVRAM], a
	ldh [rVBK], a
	pop af
	ret

; set current dest VRAM bank to 1
BankswitchVRAM1: ; 07cd (0:07cd)
	push af
	ld a, $1
	ldh [hBankVRAM], a
	ldh [rVBK], a
	pop af
	ret

; set current dest VRAM bank to a
BankswitchVRAM: ; 07d6 (0:07d6)
	ldh [hBankVRAM], a
	ldh [rVBK], a
	ret
