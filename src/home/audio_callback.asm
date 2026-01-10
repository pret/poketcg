SECTION "Audio Callback", ROM0

; jumps to 3f:hl, then switches to bank 3d
Bankswitch3dTo3f::
	push af
	ld a, BANK("Audio 3")
	ldh [hBankROM], a
	ld [rROMB], a
	pop af
	ld bc, .bankswitch3d
	push bc
	jp hl
.bankswitch3d
	ld a, BANK("Audio 1")
	ldh [hBankROM], a
	ld [rROMB], a
	ret
