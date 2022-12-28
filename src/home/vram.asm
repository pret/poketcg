; set current dest VRAM bank to 0
BankswitchVRAM0::
	push af
	xor a
	ldh [hBankVRAM], a
	ldh [rVBK], a
	pop af
	ret

; set current dest VRAM bank to 1
BankswitchVRAM1::
	push af
	ld a, $1
	ldh [hBankVRAM], a
	ldh [rVBK], a
	pop af
	ret

; set current dest VRAM bank to a
BankswitchVRAM::
	ldh [hBankVRAM], a
	ldh [rVBK], a
	ret
