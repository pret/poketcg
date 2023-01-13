; validate the saved data in SRAM
; it must contain with the sequence $04, $21, $05 at s0a000
ValidateSRAM::
	xor a
	call BankswitchSRAM
	ld hl, $a000
	ld bc, $2000 / 2
.check_pattern_loop
	ld a, [hli]
	cp $41
	jr nz, .check_sequence
	ld a, [hli]
	cp $93
	jr nz, .check_sequence
	dec bc
	ld a, c
	or b
	jr nz, .check_pattern_loop
	call RestartSRAM
	scf
	call InitSaveDataAndSetUppercase
	call DisableSRAM
	ret
.check_sequence
	ld hl, s0a000
	ld a, [hli]
	cp $04
	jr nz, .restart_sram
	ld a, [hli]
	cp $21
	jr nz, .restart_sram
	ld a, [hl]
	cp $05
	jr nz, .restart_sram
	ret
.restart_sram
	call RestartSRAM
	or a
	call InitSaveDataAndSetUppercase
	call DisableSRAM
	ret

; zero all SRAM banks and set s0a000 to $04, $21, $05
RestartSRAM::
	ld a, 3
.clear_loop
	call ClearSRAMBank
	dec a
	cp -1
	jr nz, .clear_loop
	ld hl, s0a000
	ld [hl], $04
	inc hl
	ld [hl], $21
	inc hl
	ld [hl], $05
	ret

; zero the loaded SRAM bank
ClearSRAMBank::
	push af
	call BankswitchSRAM
	call EnableSRAM
	ld hl, $a000
	ld bc, $2000
.loop
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .loop
	pop af
	ret
