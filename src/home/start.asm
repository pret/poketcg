SECTION "start", ROM0
Start::
	di
	ld sp, $fffe
	push af
	xor a
	ldh [rIF], a
	ldh [rIE], a
	call ZeroRAM
	ld a, $1
	call BankswitchROM
	xor a
	call BankswitchSRAM
	call BankswitchVRAM0
	call DisableLCD
	pop af
	ld [wInitialA], a
	call DetectConsole
	ld a, $20
	ld [wTileMapFill], a
	call SetupVRAM
	call SetupRegisters
	call SetupPalettes
	call SetupSound
	call SetupTimer
	call ResetSerial
	call CopyDMAFunction
	call ValidateSRAM
	ld a, BANK(GameLoop)
	call BankswitchROM
	ld sp, $e000
	jp GameLoop
