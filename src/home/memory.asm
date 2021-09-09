; decompresses data from a given bank
; uses values initialized by InitDataDecompression
; input:
; bc = row width
; de = buffer to place decompressed data
DecompressDataFromBank: ; 3be4 (0:3be4)
	ldh a, [hBankROM]
	push af
	ld a, [wTempPointerBank]
	call BankswitchROM
	call DecompressData
	pop af
	call BankswitchROM
	ret

; Copies bc bytes from [wTempPointer] to de
CopyBankedDataToDE: ; 3bf5 (0:3bf5)
	ldh a, [hBankROM]
	push af
	push hl
	ld a, [wTempPointerBank]
	call BankswitchROM
	ld a, [wTempPointer]
	ld l, a
	ld a, [wTempPointer + 1]
	ld h, a
	call CopyDataHLtoDE_SaveRegisters
	pop hl
	pop af
	call BankswitchROM
	ret

; fill bc bytes of data at hl with a
FillMemoryWithA: ; 3c10 (0:3c10)
	push hl
	push de
	push bc
	ld e, a
.loop
	ld [hl], e
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop bc
	pop de
	pop hl
	ret

; fill 2*bc bytes of data at hl with d,e
FillMemoryWithDE: ; 3c1f (0:3c1f)
	push hl
	push bc
.loop
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop
	pop bc
	pop hl
	ret

; gets far byte a:hl, outputs value in a
GetFarByte: ; 3c2d (0:3c2d)
	push hl
	push af
	ldh a, [hBankROM]
	push af
	push hl
	ld hl, sp+$05
	ld a, [hl]
	call BankswitchROM
	pop hl
	ld a, [hl]
	ld hl, sp+$03
	ld [hl], a
	pop af
	call BankswitchROM
	pop af
	pop hl
	ret
