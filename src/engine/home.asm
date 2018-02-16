; rst vectors
SECTION "rst00", ROM0
	ret
SECTION "rst08", ROM0
	ret
SECTION "rst10", ROM0
	ret
SECTION "rst18", ROM0
	jp RST18
SECTION "rst20", ROM0
	jp RST20
SECTION "rst28", ROM0
	jp RST28
SECTION "rst30", ROM0
	ret
SECTION "rst38", ROM0
	ret

; interrupts
SECTION "vblank", ROM0
	jp VBlankHandler
SECTION "lcdc", ROM0
	call wLCDCFunctiontrampoline
	reti
SECTION "timer", ROM0
	jp TimerHandler
SECTION "serial", ROM0
	jp SerialHandler
SECTION "joypad", ROM0
	reti

SECTION "romheader", ROM0
	nop
	jp Start

SECTION "start", ROM0
Start: ; 0150 (0:0150)
	di
	ld sp, $fffe
	push af
	xor a
	ld [rIF], a
	ld [rIE], a
	call ZeroRAM
	ld a, $1
	call BankswitchHome
	xor a
	call BankswitchRAM
	call BankswitchVRAM_0
	call DisableLCD
	pop af
	ld [wInitialA], a
	call DetectConsole
	ld a, $20
	ld [wTileMapFill], a
	call SetupVRAM
	call SetupLCD
	call SetupPalettes
	call SetupSound
	call SetupTimer
	call ResetSerial
	call CopyDMAFunction
	call SetupExtRAM
	ld a, BANK(Start_Cont)
	call BankswitchHome
	ld sp, $e000
	jp Start_Cont

VBlankHandler: ; 019b (0:019b)
	push af
	push bc
	push de
	push hl
	ldh a, [hBankROM]
	push af
	ld hl, wReentrancyFlag
	bit 0, [hl]
	jr nz, .done
	set 0, [hl]
	ld a, [wVBlankOAMCopyToggle]
	or a
	jr z, .no_oam_copy
	call hDMAFunction    ; DMA-copy $ca00-$ca9f to OAM memory
	xor a
	ld [wVBlankOAMCopyToggle], a
.no_oam_copy
	; flush scaling/windowing parameters
	ldh a, [hSCX]
	ld [rSCX], a
	ldh a, [hSCY]
	ld [rSCY], a
	ldh a, [hWX]
	ld [rWX], a
	ldh a, [hWY]
	ld [rWY], a
	; flush LCDC
	ld a, [wLCDC]
	ld [rLCDC], a
	ei
	call wVBlankFunctionTrampoline
	call FlushPalettes
	ld hl, wVBlankCtr
	inc [hl]
	ld hl, wReentrancyFlag
	res 0, [hl]
.done
	pop af
	call BankswitchHome
	pop hl
	pop de
	pop bc
	pop af
	reti

TimerHandler: ; 01e6 (0:01e6)
	push af
	push hl
	push de
	push bc
	ei
	call SerialTimerHandler
	; only trigger every fourth interrupt ≈ 60.24 Hz
	ld hl, wCounterCtr
	ld a, [hl]
	inc [hl]
	and $3
	jr nz, .done
	; increment the 60-60-60-255-255 counter
	call IncrementPlayTimeCounter
	; check in-timer flag
	ld hl, wReentrancyFlag
	bit 1, [hl]
	jr nz, .done
	set 1, [hl]
	ldh a, [hBankROM]
	push af
	ld a, BANK(SoundTimerHandler)
	call BankswitchHome
	call SoundTimerHandler
	pop af
	call BankswitchHome
	; clear in-timer flag
	ld hl, wReentrancyFlag
	res 1, [hl]
.done
	pop bc
	pop de
	pop hl
	pop af
	reti

; increment timer counter by a tick
IncrementPlayTimeCounter: ; 021c (0:021c)
	ld a, [wPlayTimeCounterEnable]
	or a
	ret z
	ld hl, wPlayTimeCounter
	inc [hl]
	ld a, [hl]
	cp 60
	ret c
	ld [hl], $0
	inc hl
	inc [hl]
	ld a, [hl]
	cp 60
	ret c
	ld [hl], $0
	inc hl
	inc [hl]
	ld a, [hl]
	cp 60
	ret c
	ld [hl], $0
	inc hl
	inc [hl]
	ret nz
	inc hl
	inc [hl]
	ret

; setup timer to 16384/68 ≈ 240.94 Hz
SetupTimer: ; 0241 (0:0241)
	ld b, $100 - 68
	; ld b, $bc
	call CheckForCGB
	jr c, .asm_250
	ld a, [rKEY1]
	and $80
	jr z, .asm_250
	ld b, $100 - 2*68
.asm_250
	ld a, b
	ld [rTMA], a
	ld a, rTAC_16384_HZ
	ld [rTAC], a
	ld a, $7
	ld [rTAC], a
	ret

; carry flag: 0 if CGB
CheckForCGB: ; 025c (0:025c)
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret z
	scf
	ret

; wait for vblank
WaitForVBlank: ; 0264 (0:0264)
	push hl
	ld a, [wLCDC]
	bit rLCDC_ENABLE, a
	jr z, .asm_275
	ld hl, wVBlankCtr
	ld a, [hl]
.asm_270
	halt
	nop
	cp [hl]
	jr z, .asm_270
.asm_275
	pop hl
	ret

; turn LCD on
EnableLCD: ; 0277 (0:0277)
	ld a, [wLCDC]        ;
	bit rLCDC_ENABLE, a  ;
	ret nz               ; assert that LCD is off
	or rLCDC_ENABLE_MASK ;
	ld [wLCDC], a        ;
	ld [rLCDC], a        ; turn LCD on
	ld a, %11000000
	ld [wFlushPaletteFlags], a
	ret

; wait for vblank, then turn LCD off
DisableLCD: ; 028a (0:028a)
	ld a, [rLCDC]        ;
	bit rLCDC_ENABLE, a  ;
	ret z                ; assert that LCD is on
	ld a, [rIE]
	ld [wIE], a
	res 0, a             ;
	ld [rIE], a          ; disable vblank interrupt
.asm_298
	ld a, [rLY]          ;
	cp LY_VBLANK         ;
	jr nz, .asm_298      ; wait for vblank
	ld a, [rLCDC]        ;
	and $7f              ;
	ld [rLCDC], a        ;
	ld a, [wLCDC]        ;
	and $7f              ;
	ld [wLCDC], a        ; turn LCD off
	xor a
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	ld a, [wIE]
	ld [rIE], a
	ret

; set OBJ size: 8x8
Set_OBJ_8x8: ; 02b9 (0:02b9)
	ld a, [wLCDC]
	and $fb
	ld [wLCDC], a
	ret

; set OBJ size: 8x16
Set_OBJ_8x16: ; 02c2 (0:02c2)
	ld a, [wLCDC]
	or $4
	ld [wLCDC], a
	ret

; set Window Display on
Set_WD_on: ; 02cb (0:02cb)
	ld a, [wLCDC]
	or $20
	ld [wLCDC], a
	ret

; set Window Display off
Set_WD_off: ; 02d4 (0:02d4)
	ld a, [wLCDC]
	and $df
	ld [wLCDC], a
	ret

EnableInt_Timer: ; 02dd (0:02dd)
	ld a, [rIE]
	or $4
	ld [rIE], a
	ret

EnableInt_VBlank: ; 02e4 (0:02e4)
	ld a, [rIE]
	or $1
	ld [rIE], a
	ret

EnableInt_HBlank: ; 02eb (0:02eb)
	ld a, [rSTAT]
	or $8
	ld [rSTAT], a
	xor a
	ld [rIF], a
	ld a, [rIE]
	or $2
	ld [rIE], a
	ret

DisableInt_HBlank: ; 02fb (0:02fb)
	ld a, [rSTAT]
	and $f7
	ld [rSTAT], a
	xor a
	ld [rIF], a
	ld a, [rIE]
	and $fd
	ld [rIE], a
	ret

SetupLCD: ; 030b (0:030b)
	xor a
	ld [rSCY], a
	ld [rSCX], a
	ld [rWY], a
	ld [rWX], a
	ld [wcab0], a
	ld [wcab1], a
	ld [wcab2], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [hWX], a
	ldh [hWY], a
	xor a
	ld [wReentrancyFlag], a
	ld a, $c3            ; $c3 = jp nn
	ld [wLCDCFunctiontrampoline], a
	ld [wVBlankFunctionTrampoline], a
	ld hl, wVBlankFunctionTrampoline + 1
	ld [hl], NopF & $ff  ;
	inc hl               ; load `jp NopF`
	ld [hl], NopF >> $8  ;
	ld a, $47
	ld [wLCDC], a
	ld a, $1
	ld [MBC3LatchClock], a
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
NopF: ; 0348 (0:0348)
	ret

DetectConsole: ; 0349 (0:0349)
	ld b, CONSOLE_CGB
	cp GBC
	jr z, .asm_35b
	call DetectSGB
	ld b, CONSOLE_DMG
	jr nc, .asm_35b
	call InitSGB
	ld b, CONSOLE_SGB
.asm_35b
	ld a, b
	ld [wConsole], a
	cp CONSOLE_CGB
	ret nz
	ld a, CONSOLE_SGB
	ld [rSVBK], a
	call SwitchToCGBDoubleSpeed
	ret

; initialize the palettes (both monochrome and color)
SetupPalettes: ; 036a (0:036a)
	ld hl, wBGP
	ld a, %11100100
	ld [rBGP], a
	ld [hli], a ; wBGP
	ld [rOBP0], a
	ld [rOBP1], a
	ld [hli], a ; wOBP0
	ld [hl], a ; wOBP1
	xor a
	ld [wFlushPaletteFlags], a
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret nz
	ld de, wBackgroundPalettesCGB
	ld c, 16
.copy_pals_loop
	ld hl, InitialPalette
	ld b, CGB_PAL_SIZE
.copy_bytes_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_bytes_loop
	dec c
	jr nz, .copy_pals_loop
	call FlushAllCGBPalettes
	ret

InitialPalette: ; 0399 (0:0399)
	rgb 28,28,24
	rgb 21,21,16
	rgb 10,10,08
	rgb 00,00,00

SetupVRAM: ; 03a1 (0:03a1)
	call FillTileMap
	call CheckForCGB
	jr c, .asm_3b2
	call BankswitchVRAM_1
	call .asm_3b2
	call BankswitchVRAM_0
.asm_3b2
	ld hl, vTiles0
	ld bc, vBGMapTiles - vTiles0
.asm_3b8
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .asm_3b8
	ret

; fill VARM tile map banks with [wTileMapFill]
FillTileMap: ; 03c0 (0:03c0)
	call BankswitchVRAM_0
	ld hl, vBGMapTiles
	ld bc, vBGMapAttrs - vBGMapTiles
.asm_3c9
	ld a, [wTileMapFill]
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_3c9
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret nz
	call BankswitchVRAM_1
	ld hl, vBGMapTiles
	ld bc, vBGMapAttrs - vBGMapTiles
.asm_3e1
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_3e1
	call BankswitchVRAM_0
	ret

; zero work RAM, stack area & high RAM ($C000-$DFFF, $FF80-$FFEF)
ZeroRAM: ; 03ec (0:03ec)
	ld hl, $c000
	ld bc, $e000 - $c000
.zero_wram_loop
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .zero_wram_loop
	ld c, LOW($ff80)
	ld b, $fff0 - $ff80
	xor a
.zero_hram_loop
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .zero_hram_loop
	ret

; Flush all non-CGB and CGB palettes
SetFlushAllPalettes: ; 0404 (0:0404)
	ld a, $c0
	jr SetFlushPalettes

; Flush non-CGB palettes and a single CGB palette,
; provided in a as an index between 0-7 (BGP) or 8-15 (OBP)
SetFlushPalette: ; 0408 (0:0408)
	or $80
	jr SetFlushPalettes

; Set wBGP to the specified value, flush non-CGB palettes, and the first CGB palette.
SetBGP: ; 040c (0:040c)
	ld [wBGP], a

SetFlushPalette0:
	ld a, $80

SetFlushPalettes:
	ld [wFlushPaletteFlags], a
	ld a, [wLCDC]
	rla
	ret c
	push hl
	push de
	push bc
	call FlushPalettes
	pop bc
	pop de
	pop hl
	ret

; Set wOBP0 to the specified value, flush non-CGB palettes, and the first CGB palette.
SetOBP0: ; 0423 (0:0423)
	ld [wOBP0], a
	jr SetFlushPalette0

; Set wOBP1 to the specified value, flush non-CGB palettes, and the first CGB palette.
SetOBP1: ; 0428 (0:0428)
	ld [wOBP1], a
	jr SetFlushPalette0

; Flushes non-CGB palettes from [wBGP], [wOBP0], [wOBP1] as well as CGB
; palettes from [wBackgroundPalettesCGB..wBackgroundPalettesCGB+$3f] (BG palette)
; and [wObjectPalettesCGB+$00..wObjectPalettesCGB+$3f] (sprite palette).
; Only flushes if [wFlushPaletteFlags] is nonzero, and only flushes
; a single CGB palette if bit6 of that location is reset.
FlushPalettes: ; 042d (0:042d)
	ld a, [wFlushPaletteFlags]
	or a
	ret z
	; flush grayscale (non-CGB) palettes
	ld hl, wBGP
	ld a, [hli]
	ld [rBGP], a
	ld a, [hli]
	ld [rOBP0], a
	ld a, [hl]
	ld [rOBP1], a
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr z, .CGB
.done
	xor a
	ld [wFlushPaletteFlags], a
	ret
.CGB
	; flush a single CGB BG or OB palette
	; if bit6 of [wFlushPaletteFlags] is set, flush all 16 of them
	ld a, [wFlushPaletteFlags]
	bit 6, a
	jr nz, FlushAllCGBPalettes
	ld b, CGB_PAL_SIZE
	call CopyCGBPalettes
	jr .done

FlushAllCGBPalettes: ; 0458 (0:0458)
	; flush 8 BGP palettes
	xor a
	ld b, 8 * CGB_PAL_SIZE
	call CopyCGBPalettes
	; flush 8 OBP palettes
	ld a, CGB_PAL_SIZE
	ld b, 8 * CGB_PAL_SIZE
	call CopyCGBPalettes
	jr FlushPalettes.done

; copy b bytes of CGB palette data starting at
; wBackgroundPalettesCGB + a * CGB_PAL_SIZE into rBGPD or rOGPD.
CopyCGBPalettes: ; 0467 (0:0467)
	add a
	add a
	add a
	ld e, a
	ld d, $0
	ld hl, wBackgroundPalettesCGB
	add hl, de
	ld c, LOW(rBGPI)
	bit 6, a ; was a between 0-7 (BGP), or between 8-15 (OBP)?
	jr z, .copy
	ld c, LOW(rOBPI)
.copy
	and %10111111
	ld e, a
.next_byte
	ld a, e
	ld [$ff00+c], a
	inc c
.wait
	ld a, [rSTAT]
	and $2
	jr nz, .wait
	ld a, [hl]
	ld [$ff00+c], a
	ld a, [$ff00+c]
	cp [hl]
	jr nz, .wait
	inc hl
	dec c
	inc e
	dec b
	jr nz, .next_byte
	ret

Func_0492: ; 0492 (0:0492)
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	call BCCoordToBGMap0Address
	jr .asm_49d
.asm_49b
	ld [de], a
	inc de
.asm_49d
	ld a, [hli]
	or a
	jr nz, .asm_49b
	ret

Func_04a2: ; 04a2 (0:04a2)
	call DisableLCD
	call FillTileMap
	xor a
	ld [wcac2], a
	ld a, [wConsole]
	cp CONSOLE_SGB
	ret nz
	call EnableLCD
	ld hl, AttrBlkPacket_04bf
	call SendSGB
	call DisableLCD
	ret

AttrBlkPacket_04bf: ; 04bf (0:04bf)
	sgb ATTR_BLK, 1 ; sgb_command, length
	db 1 ; number of data sets
	; Control Code,  Color Palette Designation, X1, Y1, X2, Y2
	db ATTR_BLK_CTRL_INSIDE + ATTR_BLK_CTRL_LINE, 0 << 0 + 0 << 2, 0, 0, 19, 17 ; data set 1
	ds 6 ; data set 2
	ds 2 ; data set 3

; returns vBGMapTiles + BG_MAP_WIDTH * c + b in de.
; used to map coordinates at bc to a BGMap0 address.
BCCoordToBGMap0Address: ; 04cf (0:04cf)
	ld l, c
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld c, b
	ld b, HIGH(vBGMapTiles)
	add hl, bc
	ld e, l
	ld d, h
	ret

ReadJoypad: ; 04de (0:04de)
	ld a, $20
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	cpl
	and $f
	swap a
	ld b, a
	ld a, $10
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	cpl
	and $f
	or b
	ld c, a ; joypad data
	cpl
	ld b, a
	ldh a, [hButtonsHeld]
	xor c
	and b
	ldh [hButtonsReleased], a
	ldh a, [hButtonsHeld]
	xor c
	and c
	ld b, a
	ldh [hButtonsPressed], a
	ldh a, [hButtonsHeld]
	and BUTTONS
	cp BUTTONS
	jr nz, ReadJoypad_SaveButtonsHeld
	; A + B + Start + Select: reset game
	call ResetSerial
;	fallthrough

Reset: ; 051b (0:051b)
	ld a, [wInitialA]
	di
	jp Start

ReadJoypad_SaveButtonsHeld:
	ld a, c
	ldh [hButtonsHeld], a
	ld a, $30
	ld [rJOYP], a
	ret

; clear joypad hmem data
ClearJoypad: ; 052a (0:052a)
	push hl
	ld hl, hDPadRepeat
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
	ret

; calls DoFrame a times
DoAFrames: ; 0536 (0:0536)
.loop
	push af
	call DoFrame
	pop af
	dec a
	jr nz, .loop
	ret

; updates background, sprites and other game variables, halts until vblank, and reads user input
; if wcad5 is not 0, the game can be paused (and resumed) by pressing the select button
DoFrame: ; 053f (0:053f)
	push af
	push hl
	push de
	push bc
	ld hl, wDoFrameFunction ; context-specific function
	call CallIndirect
	call WaitForVBlank
	call ReadJoypad
	call HandleDPadRepeat
	ld a, [wcad5]
	or a
	jr z, .done
	ldh a, [hButtonsPressed]
	and SELECT
	jr z, .done
.game_paused_loop
	call WaitForVBlank
	call ReadJoypad
	call HandleDPadRepeat
	ldh a, [hButtonsPressed]
	and SELECT
	jr z, .game_paused_loop
.done
	pop bc
	pop de
	pop hl
	pop af
	ret

; handle D-pad repeatcounter
HandleDPadRepeat: ; 0572 (0:0572)
	ldh a, [hButtonsHeld]
	ldh [hButtonsPressed2], a
	and D_PAD
	jr z, .asm_58c
	ld hl, hDPadRepeat
	ldh a, [hButtonsPressed]
	and D_PAD
	jr z, .asm_586
	ld [hl], 24
	ret
.asm_586
	dec [hl]
	jr nz, .asm_58c
	ld [hl], 6
	ret
.asm_58c
	ldh a, [hButtonsPressed]
	and BUTTONS
	ldh [hButtonsPressed2], a
	ret

CopyDMAFunction: ; 0593 (0:0593)
	ld c, $83
	ld b, JumpToFunctionInTable - DMA
	ld hl, DMA
.asm_59a
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .asm_59a
	ret

; CopyDMAFunction copies this function to hDMAFunction ($ff83)
DMA: ; 05a1 (0:05a1)
	ld a, $ca
	ld [rDMA], a
	ld a, $28
.asm_5a7
	dec a
	jr nz, .asm_5a7
	ret

; jumps to index a in pointer table hl
JumpToFunctionInTable: ; 05ab (0:05ab)
	add a
	add l
	ld l, a
	ld a, $0
	adc h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; call function at [hl] if non-NULL
CallIndirect: ; 05b6 (0:05b6)
	push af
	ld a, [hli]
	or [hl]
	jr nz, .asm_5bd
	pop af
	ret
.asm_5bd
	ld a, [hld]
	ld l, [hl]
	ld h, a
	pop af
;	fallthrough
CallHL: ; 05c1 (0:05c1)
	jp hl
; 0x5c2

Func_05c2: ; 5c2 (0:5c2)
	push hl
	push bc
	push de
	ld hl, wcaa0
	push hl
	push bc
	call Func_0614
	pop bc
	call BCCoordToBGMap0Address
	pop hl
	ld b, $02
	call JumpToHblankCopyDataHLtoDE
	pop de
	pop bc
	pop hl
	ret
; 0x5db

Func_05db: ; 5db (0:5db)
	push hl
	push bc
	push de
	ld hl, wcaa0
	push hl
	push bc
	call Func_061b
	pop bc
	call BCCoordToBGMap0Address
	pop hl
	ld b, $01
	call JumpToHblankCopyDataHLtoDE
	pop de
	pop bc
	pop hl
	ret
; 0x5f4

Func_05f4: ; 5f4 (0:5f4)
	push hl
	push bc
	push de
	ld e, l
	ld d, h
	ld hl, wcaa0
	push hl
	push bc
	ld a, d
	call Func_0614
	ld a, e
	call Func_0614
	pop bc
	call BCCoordToBGMap0Address
	pop hl
	ld b, $04
	call JumpToHblankCopyDataHLtoDE
	pop de
	pop bc
	pop hl
	ret
; 0x614

Func_0614: ; 614 (0:614)
	push af
	swap a
	call Func_061b
	pop af
Func_061b:
	and $0f
	add $30
	cp $3a
	jr c, .asm_625
	add $07
.asm_625
	ld [hli], a
	ret
; 0x627

	INCROM $0627, $0663

Func_0663: ; 0663 (0:0663)
	push bc
	ld bc, $d8f0
	call Func_0686
	ld bc, $fc18
	call Func_0686
	ld bc, $ff9c
	call Func_0686
	ld bc, $fff6
	call Func_0686
	ld bc, $ffff
	call Func_0686
	xor a
	ld [de], a
	pop bc
	ret

Func_0686: ; 0686 (0:0686)
	ld a, $2f
.asm_688
	inc a
	add hl, bc
	jr c, .asm_688
	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret
; 0x695

Func_0695: ; 0695 (0:0695)
	call Func_069d
	bit 7, [hl]
	jr z, Func_0695
	ret
; 0x69d

Func_069d: ; 069d (0:069d)
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	push hl
	push bc
	ld b, $ff
.asm_6a5
	inc b
	ld a, [hli]
	or a
	jr nz, .asm_6a5
	ld a, b
	pop bc
	push af
	call BCCoordToBGMap0Address
	pop af
	ld b, a
	pop hl
	or a
	jr z, .asm_6bd
	push bc
	push hl
	call SafeCopyDataHLtoDE
	pop hl
	pop bc

.asm_6bd
	inc b
	ld c, b
	ld b, $0
	add hl, bc
	ret
; 0x6c3

Func_06c3: ; 06c3 (0:06c3)
	push af
	ld a, [wLCDC]
	rla
	jr c, .lcd_on
	pop af
	push hl
	push de
	push bc
	push af
	call BCCoordToBGMap0Address
	pop af
	ld [de], a
	pop bc
	pop de
	pop hl
	ret
.lcd_on
	pop af
	push hl
	push de
	push bc
	ld hl, wcac1
	push hl
	ld [hl], a
	call BCCoordToBGMap0Address
	pop hl
	ld b, $1
	call HblankCopyDataHLtoDE
	pop bc
	pop de
	pop hl
	ret
; 0x6ee

; copy a bytes of data from hl to vBGMap0 address pointed to by coord at bc
Func_06ee: ; 06ee (0:06ee)
	push bc
	push hl
	push af
	call BCCoordToBGMap0Address
	pop af
	ld b, a
	pop hl
	call SafeCopyDataHLtoDE
	pop bc
	ret
; 0x6fc

; memcpy(DE, HL, B)
; if LCD on, copy during h-blank only
SafeCopyDataHLtoDE: ; 6fc (0:6fc)
	ld a, [wLCDC]
	rla
	jr c, JumpToHblankCopyDataHLtoDE
.lcd_off_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .lcd_off_loop
	ret
JumpToHblankCopyDataHLtoDE: ; 0709 (0:0709)
	jp HblankCopyDataHLtoDE
; 0x70c

CopyGfxData: ; 070c (0:070c)
	ld a, [wLCDC]
	rla
	jr nc, .asm_726
.asm_712
	push bc
	push hl
	push de
	ld b, c
	call JumpToHblankCopyDataHLtoDE
	ld b, $0
	pop hl
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_712
	ret
.asm_726
	push bc
.asm_727
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .asm_727
	pop bc
	dec b
	jr nz, .asm_726
	ret

CopyDataHLtoDE_SaveRegisters: ; 0732 (0:0732)
	push hl
	push de
	push bc
	call CopyDataHLtoDE
	pop bc
	pop de
	pop hl
	ret

; copies bc bytes from hl to de
CopyDataHLtoDE: ; 073c (0:073c)
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, CopyDataHLtoDE
	ret

; switch to rombank (A + top2 of H shifted down),
; set top2 of H to 01,
; return old rombank id on top-of-stack
BankpushHome: ; 0745 (0:0745)
	push hl
	push bc
	push af
	push de
	ld e, l
	ld d, h
	ld hl, sp+$9
	ld b, [hl]
	dec hl
	ld c, [hl]
	dec hl
	ld [hl], b
	dec hl
	ld [hl], c
	ld hl, sp+$9
	ldh a, [hBankROM]
	ld [hld], a
	ld [hl], $0
	ld a, d
	rlca
	rlca
	and $3
	ld b, a
	res 7, d
	set 6, d
	ld l, e
	ld h, d
	pop de
	pop af
	add b
	call BankswitchHome
	pop bc
	ret
; 0x76f

; switch to rombank A,
; return old rombank id on top-of-stack
BankpushHome2: ; 076f (0:076f)
	push hl
	push bc
	push af
	push de
	ld e, l
	ld d, h
	ld hl, sp+$9
	ld b, [hl]
	dec hl
	ld c, [hl]
	dec hl
	ld [hl], b
	dec hl
	ld [hl], c
	ld hl, sp+$9
	ldh a, [hBankROM]
	ld [hld], a
	ld [hl], $0
	ld l, e
	ld h, d
	pop de
	pop af
	call BankswitchHome
	pop bc
	ret
; 0x78e

; restore rombank from top-of-stack
BankpopHome: ; 078e (0:078e)
	push hl
	push de
	ld hl, sp+$7
	ld a, [hld]
	call BankswitchHome
	dec hl
	ld d, [hl]
	dec hl
	ld e, [hl]
	inc hl
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	pop de
	pop hl
	pop af
	ret

; switch ROM bank
BankswitchHome: ; 07a3 (0:07a3)
	ldh [hBankROM], a
	ld [MBC3RomBank], a
	ret

; switch RAM bank
BankswitchRAM: ; 07a9 (0:07a9)
	push af
	ldh [hBankRAM], a
	ld [MBC3SRamBank], a
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; enable external RAM
EnableExtRAM: ; 07b6 (0:07b6)
	push af
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; disable external RAM
DisableExtRAM: ; 07be (0:07be)
	push af
	xor a ; SRAM_DISABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; set current dest VRAM bank to 0
BankswitchVRAM_0: ; 07c5 (0:07c5)
	push af
	xor a
	ldh [hBankVRAM], a
	ld [rVBK], a
	pop af
	ret

; set current dest VRAM bank to 1
BankswitchVRAM_1: ; 07cd (0:07cd)
	push af
	ld a, $1
	ldh [hBankVRAM], a
	ld [rVBK], a
	pop af
	ret

; set current dest VRAM bank
; a: value to write
BankswitchVRAM: ; 07d6 (0:07d6)
	ldh [hBankVRAM], a
	ld [rVBK], a
	ret
; 0x7db

SwitchToCGBNormalSpeed: ; 7db (0:7db)
	call CheckForCGB
	ret c
	ld hl, rKEY1
	bit 7, [hl]
	ret z
	jr CGBSpeedSwitch

SwitchToCGBDoubleSpeed: ; 07e7 (0:07e7)
	call CheckForCGB
	ret c
	ld hl, rKEY1
	bit 7, [hl]
	ret nz
;	fallthrough
CGBSpeedSwitch: ; 07f1 (0:07f1)
	ld a, [rIE]
	push af
	xor a
	ld [rIE], a
	set 0, [hl]
	xor a
	ld [rIF], a
	ld [rIE], a
	ld a, $30
	ld [rJOYP], a
	stop
	call SetupTimer
	pop af
	ld [rIE], a
	ret

SetupExtRAM: ; 080b (0:080b)
	xor a
	call BankswitchRAM
	ld hl, $a000
	ld bc, $1000
.asm_815
	ld a, [hli]
	cp $41
	jr nz, .asm_82f
	ld a, [hli]
	cp $93
	jr nz, .asm_82f
	dec bc
	ld a, c
	or b
	jr nz, .asm_815
	call Func_084d
	scf
	call Func_4050
	call DisableExtRAM
	ret
.asm_82f
	ld hl, $a000
	ld a, [hli]
	cp $4
	jr nz, .asm_842
	ld a, [hli]
	cp $21
	jr nz, .asm_842
	ld a, [hl]
	cp $5
	jr nz, .asm_842
	ret
.asm_842
	call Func_084d
	or a
	call Func_4050
	call DisableExtRAM
	ret

Func_084d: ; 084d (0:084d)
	ld a, $3
.asm_84f
	call ClearExtRAMBank
	dec a
	cp $ff
	jr nz, .asm_84f
	ld hl, $a000
	ld [hl], $4
	inc hl
	ld [hl], $21
	inc hl
	ld [hl], $5
	ret

ClearExtRAMBank: ; 0863 (0:0863)
	push af
	call BankswitchRAM
	call EnableExtRAM
	ld hl, $a000
	ld bc, $2000
.asm_870
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .asm_870
	pop af
	ret

; returns h * l in hl
HtimesL: ; 0879 (0:0879)
	push de
	ld a, h
	ld e, l
	ld d, $0
	ld l, d
	ld h, d
	jr .asm_887
.asm_882
	add hl, de
.asm_883
	sla e
	rl d
.asm_887
	srl a
	jr c, .asm_882
	jr nz, .asm_883
	pop de
	ret
; 0x88f

; return a random number between 0 and a (exclusive) in a
Random: ; 088f (0:088f)
	push hl
	ld h, a
	call UpdateRNGSources
	ld l, a
	call HtimesL
	ld a, h
	pop hl
	ret
; 0x89b

UpdateRNGSources: ; 089b (0:089b)
	push hl
	push de
	ld hl, wRNG1
	ld a, [hli]
	ld d, [hl]
	inc hl
	ld e, a
	ld a, d
	rlca
	rlca
	xor e
	rra
	push af
	ld a, d
	xor e
	ld d, a
	ld a, [hl]
	xor e
	ld e, a
	pop af
	rl e
	rl d
	ld a, d
	xor e
	inc [hl]
	dec hl
	ld [hl], d
	dec hl
	ld [hl], e
	pop de
	pop hl
	ret

Func_08bf: ; 08bf (0:08bf)
	ld hl, $cad6
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, $cad8
	ld [hl], $1
	inc hl
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], b
	inc hl
	ld [hli], a
	ld [hl], $ef
	ld h, b
	ld l, $0
	xor a
.asm_8d9
	ld [hl], a
	inc l
	jr nz, .asm_8d9
	ret

Func_08de: ; 08de (0:08de)
	push hl
	push de
.asm_8e0
	push bc
	call Func_08ef
	ld [de], a
	inc de
	pop bc
	dec bc
	ld a, c
	or b
	jr nz, .asm_8e0
	pop de
	pop hl
	ret

Func_08ef: ; 08ef (0:08ef)
	ld hl, $cadc
	ld a, [hl]
	or a
	jr z, .asm_902
	dec [hl]
	inc hl
.asm_8f8
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc [hl]
	inc hl
	ld a, [bc]
	ld c, [hl]
	inc [hl]
	ld [bc], a
	ret
.asm_902
	ld hl, $cad6
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	dec [hl]
	inc hl
	jr nz, .asm_914
	dec hl
	ld [hl], $8
	inc hl
	ld a, [bc]
	inc bc
	ld [hl], a
.asm_914
	rl [hl]
	ld a, [bc]
	inc bc
	jr nc, .asm_92a
	ld hl, $cad6
	ld [hl], c
	inc hl
	ld [hl], b
	ld hl, $cadd
	ld b, [hl]
	inc hl
	inc hl
	ld c, [hl]
	inc [hl]
	ld [bc], a
	ret
.asm_92a
	ld [wcade], a
	ld hl, $cada
	bit 0, [hl]
	jr nz, .asm_94a
	set 0, [hl]
	inc hl
	ld a, [bc]
	inc bc
	ld [hli], a
	swap a
.asm_93c
	and $f
	inc a
	ld [hli], a
	push hl
	ld hl, $cad6
	ld [hl], c
	inc hl
	ld [hl], b
	pop hl
	jr .asm_8f8
.asm_94a
	res 0, [hl]
	inc hl
	ld a, [hli]
	jr .asm_93c
; 0x950

	INCROM $0950, $099c

Func_099c: ; 099c (0:099c)
	xor a
	ld [wcab5], a
	ld hl, $ca00
	ld c, $28
	xor a
.asm_9a6
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	dec c
	jr nz, .asm_9a6
	ret

; this function affects the stack so that it returns
; to the pointer following the rst call
; similar to rst 28, except this always loads bank 1
RST18: ; 09ae (0:09ae)
	push hl
	push hl
	push hl
	push hl
	push de
	push af
	ld hl, sp+$d
	ld d, [hl]
	dec hl
	ld e, [hl]
	dec hl
	ld [hl], $0
	dec hl
	ldh a, [hBankROM]
	ld [hld], a
	ld [hl], $9
	dec hl
	ld [hl], $dc
	dec hl
	inc de
	ld a, [de]
	ld [hld], a
	dec de
	ld a, [de]
	ld [hl], a
	ld a, $1
;	fallthrough
Func_09ce: ; 09ce (0:09ce)
	call BankswitchHome
	ld hl, sp+$d
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	pop af
	pop de
	pop hl
	ret
; 0x9dc

SwitchToBankAtSP: ; 9dc (0:9dc)
	push af
	push hl
	ld hl, sp+$04
	ld a, [hl]
	call BankswitchHome
	pop hl
	pop af
	inc sp
	inc sp
	ret
; 0x9e9

; this function affects the stack so that it returns
; to the three byte pointer following the rst call
RST28: ; 09e9 (0:09e9)
	push hl
	push hl
	push hl
	push hl
	push de
	push af
	ld hl, sp+$d
	ld d, [hl]
	dec hl
	ld e, [hl]
	dec hl
	ld [hl], $0
	dec hl
	ldh a, [hBankROM]
	ld [hld], a
	ld [hl], $9
	dec hl
	ld [hl], $dc
	dec hl
	inc de
	inc de
	ld a, [de]
	ld [hld], a
	dec de
	ld a, [de]
	ld [hl], a
	dec de
	ld a, [de]
	inc de
	jr Func_09ce

; setup SNES memory $810-$867 and palette
InitSGB: ; 0a0d (0:0a0d)
	ld hl, MaskEnPacket_Freeze
	call SendSGB
	ld hl, DataSndPacket_0a50
	call SendSGB
	ld hl, DataSndPacket_0a60
	call SendSGB
	ld hl, DataSndPacket_0a70
	call SendSGB
	ld hl, DataSndPacket_0a80
	call SendSGB
	ld hl, DataSndPacket_0a90
	call SendSGB
	ld hl, DataSndPacket_0aa0
	call SendSGB
	ld hl, DataSndPacket_0ab0
	call SendSGB
	ld hl, DataSndPacket_0ac0
	call SendSGB
	ld hl, Pal01Packet
	call SendSGB
	ld hl, MaskEnPacket_Cancel
	call SendSGB
	ret

DataSndPacket_0a50: ; 0a50 (0:0a50)
	sgb DATA_SND, 1 ; sgb_command, length
	db $5d,$08,$00,$0b,$8c,$d0,$f4,$60,$00,$00,$00,$00,$00,$00,$00

DataSndPacket_0a60: ; 0a60 (0:0a60)
	sgb DATA_SND, 1 ; sgb_command, length
	db $52,$08,$00,$0b,$a9,$e7,$9f,$01,$c0,$7e,$e8,$e8,$e8,$e8,$e0

DataSndPacket_0a70: ; 0a70 (0:0a70)
	sgb DATA_SND, 1 ; sgb_command, length
	db $47,$08,$00,$0b,$c4,$d0,$16,$a5,$cb,$c9,$05,$d0,$10,$a2,$28

DataSndPacket_0a80: ; 0a80 (0:0a80)
	sgb DATA_SND, 1 ; sgb_command, length
	db $3c,$08,$00,$0b,$f0,$12,$a5,$c9,$c9,$c8,$d0,$1c,$a5,$ca,$c9

DataSndPacket_0a90: ; 0a90 (0:0a90)
	sgb DATA_SND, 1 ; sgb_command, length
	db $31,$08,$00,$0b,$0c,$a5,$ca,$c9,$7e,$d0,$06,$a5,$cb,$c9,$7e

DataSndPacket_0aa0: ; 0aa0 (0:0aa0)
	sgb DATA_SND, 1 ; sgb_command, length
	db $26,$08,$00,$0b,$39,$cd,$48,$0c,$d0,$34,$a5,$c9,$c9,$80,$d0

DataSndPacket_0ab0: ; 0ab0 (0:0ab0)
	sgb DATA_SND, 1 ; sgb_command, length
	db $1b,$08,$00,$0b,$ea,$ea,$ea,$ea,$ea,$a9,$01,$cd,$4f,$0c,$d0

DataSndPacket_0ac0: ; 0ac0 (0:0ac0)
	sgb DATA_SND, 1 ; sgb_command, length
	db $10,$08,$00,$0b,$4c,$20,$08,$ea,$ea,$ea,$ea,$ea,$60,$ea,$ea

MaskEnPacket_Freeze: ; 0ad0 (0:0ad0)
	sgb MASK_EN, 1 ; sgb_command, length
	db MASK_EN_FREEZE_SCREEN
	ds $0e

MaskEnPacket_Cancel: ; 0ae0 (0:0ae0)
	sgb MASK_EN, 1 ; sgb_command, length
	db MASK_EN_CANCEL_MASK
	ds $0e

Pal01Packet: ; 0af0 (0:0af0)
	sgb PAL01, 1 ; sgb_command, length
	rgb 28, 28, 24
	rgb 20, 20, 16
	rgb 8, 8, 8
	rgb 0, 0, 0
	rgb 31, 0, 0
	rgb 15, 0, 0
	rgb 7, 0, 0
	db $00

Pal23Packet: ; 0b00 (0:0b00)
	sgb PAL23, 1 ; sgb_command, length
	rgb 0, 31, 0
	rgb 0, 15, 0
	rgb 0, 7, 0
	rgb 0, 0, 0
	rgb 0, 0, 31
	rgb 0, 0, 15
	rgb 0, 0, 7
	db $00

AttrBlkPacket_0b10: ; 0b10 (0:0b10)
	sgb ATTR_BLK, 1 ; sgb_command, length
	db 1 ; number of data sets
	; Control Code,  Color Palette Designation, X1, Y1, X2, Y2
	db ATTR_BLK_CTRL_INSIDE + ATTR_BLK_CTRL_LINE, 1 << 0 + 2 << 2, 5, 5, 10, 10 ; data set 1
	ds 6 ; data set 2
	ds 2 ; data set 3

; send SGB command
SendSGB: ; 0b20 (0:0b20)
	ld a, [hl]
	and $7
	ret z
	ld b, a
	ld c, $0
.asm_b27
	push bc
	ld a, $0
	ld [$ff00+c], a
	ld a, $30
	ld [$ff00+c], a
	ld b, $10
.asm_b30
	ld e, $8
	ld a, [hli]
	ld d, a
.asm_b34
	bit 0, d
	ld a, $10
	jr nz, .asm_b3c
	ld a, $20
.asm_b3c
	ld [$ff00+c], a
	ld a, $30
	ld [$ff00+c], a
	rr d
	dec e
	jr nz, .asm_b34
	dec b
	jr nz, .asm_b30
	ld a, $20
	ld [$ff00+c], a
	ld a, $30
	ld [$ff00+c], a
	pop bc
	dec b
	jr nz, .asm_b27
	ld bc, 4
	call Wait
	ret

DetectSGB: ; 0b59 (0:0b59)
	ld bc, 60
	call Wait
	ld hl, MltReq2Packet
	call SendSGB
	ld a, [rJOYP]
	and $3
	cp $3
	jr nz, .sgb
	ld a, $20
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, $30
	ld [rJOYP], a
	ld a, $10
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, $30
	ld [rJOYP], a
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	ld a, [rJOYP]
	and $3
	cp $3
	jr nz, .sgb
	ld hl, MltReq1Packet
	call SendSGB
	or a
	ret
.sgb
	ld hl, MltReq1Packet
	call SendSGB
	scf
	ret

MltReq1Packet: ; 0bab (0:0bab)
	sgb MLT_REQ, 1 ; sgb_command, length
	db MLT_REQ_1_PLAYER
	ds $0e

MltReq2Packet: ; 0bbb (0:0bbb)
	sgb MLT_REQ, 1 ; sgb_command, length
	db MLT_REQ_2_PLAYERS
	ds $0e

Func_0bcb: ; 0bcb (0:0bcb)
	di
	push de
.wait_vbalnk
	ld a, [rLY]
	cp LY_VBLANK + 3
	jr nz, .wait_vbalnk
	ld a, $43
	ld [rLCDC], a
	ld a, %11100100
	ld [rBGP], a
	ld de, vTiles1
	ld bc, vBGMapTiles - vTiles1
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ld hl, vBGMapTiles
	ld de, $000c
	ld a, $80
	ld c, $d
.asm_bf3
	ld b, $14
.asm_bf5
	ld [hli], a
	inc a
	dec b
	jr nz, .asm_bf5
	add hl, de
	dec c
	jr nz, .asm_bf3
	ld a, $c3
	ld [rLCDC], a
	pop hl
	call SendSGB
	ei
	ret
; 0xc08

; loops 63000 * bc cycles (~15 * bc ms)
Wait: ; 0c08 (0:0c08)
	ld de, 1750
.loop
	nop
	nop
	nop
	dec de
	ld a, d
	or e
	jr nz, .loop
	dec bc
	ld a, b
	or c
	jr nz, Wait
	ret

; memcpy(DE, HL, B), but only during hblank
HblankCopyDataHLtoDE: ; 0c19 (0:0c19)
	push bc
.loop
	ei
	di
	ld a, [rSTAT]        ;
	and $3               ;
	jr nz, .loop         ; assert hblank
	ld a, [hl]
	ld [de], a
	ld a, [rSTAT]        ;
	and $3               ;
	jr nz, .loop         ; assert still in hblank
	ei
	inc hl
	inc de
	dec b
	jr nz, .loop
	pop bc
	ret

; memcpy(HL, DE, C), but only during hblank
HblankCopyDataDEtoHL: ; 0c32 (0:0c32)
	push bc
.loop
	ei
	di
	ld a, [rSTAT]
	and $3
	jr nz, .loop
	ld a, [de]
	ld [hl], a
	ld a, [rSTAT]
	and $3
	jr nz, .loop
	ei
	inc hl
	inc de
	dec c
	jr nz, .loop
	pop bc
	ret
; 0xc4b

	INCROM $0c4b, $0c91

; called at roughly 240Hz by TimerHandler
SerialTimerHandler: ; 0c91 (0:0c91)
	ld a, [wSerialOp]
	cp $29
	jr z, .begin_transfer
	cp $12
	jr z, .check_for_timeout
	ret
.begin_transfer
	ld a, [rSC]          ;
	add a                ; make sure that no serial transfer is active
	ret c                ;
	ld a, $1
	ld [rSC], a          ; use internal clock
	ld a, $81
	ld [rSC], a          ; use internal clock, set transfer start flag
	ret
.check_for_timeout
	; sets bit7 of [wSerialFlags] if the serial interrupt hasn't triggered
	; within four timer interrupts (60Hz)
	ld a, [wSerialCounter]
	ld hl, wSerialCounter2
	cp [hl]
	ld [hl], a
	ld hl, wSerialTimeoutCounter
	jr nz, .clear_counter
	inc [hl]
	ld a, [hl]
	cp $4
	ret c
	ld hl, wSerialFlags
	set 7, [hl]
	ret
.clear_counter
	ld [hl], $0
	ret
; 0xcc5

	INCROM $0cc5, $0d26

SerialHandler: ; 0d26 (0:0d26)
	push af
	push hl
	push de
	push bc
	ld a, [wce63]        ;
	or a                 ;
	jr z, .asm_d35       ; if [wce63] nonzero:
	call Func_3189       ; ?
	jr .done             ; return
.asm_d35
	ld a, [wSerialOp]    ;
	or a                 ;
	jr z, .asm_d55       ; skip ahead if [wcb74] zero
	; send/receive a byte
	ld a, [rSB]
	call SerialHandleRecv
	call SerialHandleSend ; returns byte to actually send
	push af
.wait_for_completion
	ld a, [rSC]
	add a
	jr c, .wait_for_completion
	pop af
	; end send/receive
	ld [rSB], a          ; prepare sending byte (from Func_0dc8?)
	ld a, [wSerialOp]
	cp $29
	jr z, .done          ; if [wcb74] != $29, use external clock
	jr .asm_d6a          ; and prepare for next byte.  either way, return
.asm_d55
	ld a, $1
	ld [wSerialRecvCounter], a
	ld a, [rSB]
	ld [wSerialRecvBuf], a
	ld a, $ac
	ld [rSB], a
	ld a, [wSerialRecvBuf]
	cp $12               ; if [wSerialRecvBuf] != $12, use external clock
	jr z, .done          ; and prepare for next byte.  either way, return
.asm_d6a
	ld a, $80            ;
	ld [rSC], a          ; transfer start, use external clock
.done
	ld hl, wSerialCounter
	inc [hl]
	pop bc
	pop de
	pop hl
	pop af
	reti

; handles a byte read from serial transfer by decoding it and storing it into
; the receive buffer
SerialHandleRecv: ; 0d77 (0:0d77)
	ld hl, wSerialLastReadCA
	ld e, [hl]
	dec e
	jr z, .last_was_ca
	cp $ac
	ret z ; return if read_data == $ac
	cp $ca
	jr z, .read_ca
	or a
	jr z, .read_00_or_ff
	cp $ff
	jr nz, .read_data
.read_00_or_ff
	ld hl, wSerialFlags
	set 6, [hl]
	ret
.read_ca
	inc [hl] ; inc [wSerialLastReadCA]
	ret
.last_was_ca
	; if last byte read was $ca, flip all bits of data received
	ld [hl], $0
	cpl
	jr .handle_byte
.read_data
	; flip top2 bits of data received
	xor $c0
.handle_byte
	push af
	ld a, [wSerialRecvIndex]
	ld e, a
	ld a, [wcba3]
	dec a
	and $1f
	cp e
	jr z, .set_flag_and_return
	ld d, $0
	; store into receive buffer
	ld hl, wSerialRecvBuf
	add hl, de
	pop af
	ld [hl], a
	; increment buffer index (mod 32)
	ld a, e
	inc a
	and $1f
	ld [wSerialRecvIndex], a
	; increment received bytes counter & clear flags
	ld hl, wSerialRecvCounter
	inc [hl]
	xor a
	ld [wSerialFlags], a
	ret
.set_flag_and_return
	pop af
	ld hl, wSerialFlags
	set 0, [hl]
	ret

; prepares a byte to send over serial transfer, either from the send-save byte
; slot or the send buffer
SerialHandleSend: ; 0dc8 (0:0dc8)
	ld hl, wSerialSendSave
	ld a, [hl]
	or a
	jr nz, .send_saved
	ld hl, wSerialSendBufToggle
	ld a, [hl]
	or a
	jr nz, .send_buf
	; no more data--send $ac to indicate this
	ld a, $ac
	ret
.send_saved
	ld a, [hl]
	ld [hl], $0
	ret
.send_buf
	; grab byte to send from send buffer, increment buffer index
	; and decrement to-send length
	dec [hl]
	ld a, [wSerialSendBufIndex]
	ld e, a
	ld d, $0
	ld hl, wSerialSendBuf
	add hl, de
	inc a
	and $1f
	ld [wSerialSendBufIndex], a
	ld a, [hl]
	; flip top2 bits of sent data
	xor $c0
	cp $ac
	jr z, .send_escaped
	cp $ca
	jr z, .send_escaped
	cp $ff
	jr z, .send_escaped
	or a
	jr z, .send_escaped
	ret
.send_escaped
	; escape tricky data by prefixing it with $ca and flipping all bits
	; instead of just top2
	xor $c0
	cpl
	ld [wSerialSendSave], a
	ld a, $ca
	ret

; store data in sendbuf for sending?
Func_0e0a: ; 0e0a (0:0e0a)
	push hl
	push de
	push bc
	push af
.asm_e0e
	ld a, [wcb80]
	ld e, a
	ld a, [wSerialSendBufIndex]
	dec a
	and $1f
	cp e
	jr z, .asm_e0e
	ld d, $0
	ld a, e
	inc a
	and $1f
	ld [wcb80], a
	ld hl, wSerialSendBuf
	add hl, de
	pop af
	ld [hl], a
	ld hl, wSerialSendBufToggle
	inc [hl]
	pop bc
	pop de
	pop hl
	ret

; sets carry if [wSerialRecvCounter] nonzero
Func_0e32: ; 0e32 (0:0e32)
	ld a, [wSerialRecvCounter]
	or a
	ret z
	scf
	ret

Func_0e39: ; 0e39 (0:0e39)
	push hl
	ld hl, wSerialRecvCounter
	ld a, [hl]
	or a
	jr nz, .asm_e49
	pop hl
	ld a, [wSerialFlags]
	or a
	ret nz
	scf
	ret
.asm_e49
	push de
	dec [hl]
	ld a, [wcba3]
	ld e, a
	ld d, $0
	ld hl, wSerialRecvBuf
	add hl, de
	ld a, [hl]
	push af
	ld a, e
	inc a
	and $1f
	ld [wcba3], a
	pop af
	pop de
	pop hl
	or a
	ret

Func_0e63: ; 0e63 (0:0e63)
	ld b, c
.asm_e64
	ld a, b
	sub c
	jr c, .asm_e6c
	cp $1f
	jr nc, .asm_e75
.asm_e6c
	inc c
	dec c
	jr z, .asm_e75
	ld a, [hli]
	call Func_0e0a
	dec c
.asm_e75
	inc b
	dec b
	jr z, .asm_e81
	call Func_0e39
	jr c, .asm_e81
	ld [de], a
	inc de
	dec b
.asm_e81
	ld a, [wSerialFlags]
	or a
	jr nz, .asm_e8c
	ld a, c
	or b
	jr nz, .asm_e64
	ret
.asm_e8c
	scf
	ret

; go into slave mode (external clock) for serial transfer?
Func_0e8e: ; 0e8e (0:0e8e)
	call ClearSerialData
	ld a, $12
	ld [rSB], a          ; send $12
	ld a, $80
	ld [rSC], a          ; use external clock, set transfer start flag
	ld a, [rIF]
	and $f7
	ld [rIF], a          ; clear serial interrupt flag
	ld a, [rIE]
	or $8                ; enable serial interrupt
	ld [rIE], a
	ret

ResetSerial: ; 0ea6 (0:0ea6)
	ld a, [rIE]
	and $f7
	ld [rIE], a
	xor a
	ld [rSB], a
	ld [rSC], a
;	fallthrough
ClearSerialData: ; 0eb1 (0:0eb1)
	ld hl, wSerialOp
	ld bc, $0051
.loop
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .loop
	ret

Func_0ebf: ; 0ebf (0:0ebf)
	push bc
.asm_ec0
	ld a, [hli]
	call Func_0e0a
	ld a, [wSerialFlags]
	or a
	jr nz, .asm_ed2
	dec bc
	ld a, c
	or b
	jr nz, .asm_ec0
	pop bc
	or a
	ret
.asm_ed2
	pop bc
	scf
	ret
; 0xed5

Func_0ed5: ; 0ed5 (0:0ed5)
	push bc
.asm_ed6
	call Func_0e39
	jr nc, .asm_edf
	halt
	nop
	jr .asm_ed6
.asm_edf
	ld [hli], a
	ld a, [wSerialFlags]
	or a
	jr nz, .asm_eee
	dec bc
	ld a, c
	or b
	jr nz, .asm_ed6
	pop bc
	or a
	ret
.asm_eee
	pop bc
	scf
	ret
; 0xef1

	INCROM $0ef1, $0f35

Func_0f35: ; 0f35 (0:0f35)
	ld a, [wSerialFlags]
	ld l, a
	ld h, $0
	call Func_2ec4
	ldtx hl, TransmissionErrorText
	call DrawWideTextBox_WaitForInput
	ld a, $ff
	ld [wd0c3], a
	ld hl, $cbe5
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld sp, hl
	xor a
	call PlaySong
	call ResetSerial
	ret

Func_0f58: ; 0f58 (0:0f58)
	ld a, [wcc09]
	cp $1
	jr z, .asm_f60
	ret
.asm_f60
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	or a ; cp DUELIST_TYPE_PLAYER
	jr z, .asm_f70
	ld hl, $cbe2
	ld de, wRNG1
	jr .asm_f76
.asm_f70
	ld hl, wRNG1
	ld de, $cbe2
.asm_f76
	ld c, $3
	call Func_0e63
	jp c, Func_0f35
	ret

Func_0f7f: ; 0f7f (0:0f7f)
	push hl
	push bc
	ld [$ff9e], a
	ld a, DUELVARS_DUELIST_TYPE
	call GetNonTurnDuelistVariable
	cp DUELIST_TYPE_LINK_OPP
	jr nz, .not_link
	ld hl, $ff9e
	ld bc, $000a
	call Func_0ebf
	call Func_0f58
.not_link
	pop bc
	pop hl
	ret
; 0xf9b

Func_0f9b: ; 0f9b (0:0f9b)
	push hl
	push bc
	ld hl, $ff9e
	ld bc, $000a
	call Func_0ed5
	call Func_0f58
	pop bc
	pop hl
	ret
; 0xfac

Func_0fac: ; 0fac (0:0fac)
	push hl
	push af
	ld a, DUELVARS_DUELIST_TYPE
	call GetNonTurnDuelistVariable
	cp DUELIST_TYPE_LINK_OPP
	jr z, .link
	pop af
	pop hl
	ret

.link
	pop af
	pop hl
	push af
	push hl
	push de
	push bc
	push de
	push hl
	push af
	ld hl, wcbed
	pop de
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	pop de
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	pop de
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	ld hl, wcbed
	ld bc, $0008
	call Func_0ebf
	jp c, Func_0f35
	pop bc
	pop de
	pop hl
	pop af
	ret
; 0xfe9

Func_0fe9: ; 0fe9 (0:0fe9)
	ld hl, wcbed
	ld bc, $0008
	push hl
	call Func_0ed5
	jp c, Func_0f35
	pop hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push de
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	pop hl
	pop af
	ret
; 0x100b

Func_100b: ; 100b (0:100b)
	ld a, $2
	call BankswitchRAM
	call $669d
	xor a
	call BankswitchRAM
	call EnableExtRAM
	ld hl, $a008
	ld a, [hl]
	inc [hl]
	call DisableExtRAM
	and $3
	add $28
	ld l, $0
	ld h, a
	add hl, hl
	add hl, hl
	ld a, $3
	call BankswitchRAM
	push hl
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardInDeckPosition
	ld a, e
	ld [wTempTurnDuelistCardId], a
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardInDeckPosition
	ld a, e
	ld [wTempNonTurnDuelistCardId], a
	call SwapTurn
	pop hl
	push hl
	call EnableExtRAM
	ld a, [wcc06]
	ld [hli], a
	ld a, [wTempNonTurnDuelistCardId]
	ld [hli], a
	ld a, [wTempTurnDuelistCardId]
	ld [hli], a
	pop hl
	ld de, $0010
	add hl, de
	ld e, l
	ld d, h
	call DisableExtRAM
	bank1call $66a4
	xor a
	call BankswitchRAM
	ret

; copies the deck pointed to by de to wPlayerDeck or wOpponentDeck
CopyDeckData: ; 1072 (0:1072)
	ld hl, wPlayerDeck
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .copy_deck_data
	ld hl, wOpponentDeck
.copy_deck_data
	; start by putting a terminator at the end of the deck
	push hl
	ld bc, DECK_SIZE - 1
	add hl, bc
	ld [hl], $0
	pop hl
	push hl
.next_card
	ld a, [de]
	inc de
	ld b, a
	or a
	jr z, .done
	ld a, [de]
	inc de
	ld c, a
.card_quantity_loop
	ld [hl], c
	inc hl
	dec b
	jr nz, .card_quantity_loop
	jr .next_card
.done
	ld hl, $cce9
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	pop hl
	ld bc, DECK_SIZE - 1
	add hl, bc
	ld a, [hl]
	or a
	ret nz
	rst $38
	scf
	ret
; 0x10aa

Func_10aa: ; 10aa (0:10aa)
	push hl
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	ld l, a
	xor a
.asm_10b2
	rr l
	adc $00
	inc l
	dec l
	jr nz, .asm_10b2
	pop hl
	ret
; 0x10bc

; shuffles the deck specified by hWhoseTurn
; if less than 60 cards remain in the deck, make sure the rest are ignored
ShuffleDeck: ; 10bc (0:10bc)
	ldh a, [hWhoseTurn]
	ld h, a
	ld d, a
	ld a, DECK_SIZE
	ld l, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	sub [hl]
	ld b, a
	ld a, DUELVARS_DECK_CARDS
	add [hl]
	ld l, a ; hl = position of the first (top) deck card in the wPlayerDeckCards or wOpponentDeckCards array
	ld a, b ; a = number of cards in the deck
	call ShuffleCards
	ret

; draw a card from the deck, saving its location as CARD_LOCATION_JUST_DRAWN
; returns c if deck is empty, nc if a card was succesfully drawn
DrawCardFromDeck: ; 10cf (0:10cf)
	push hl
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE
	jr nc, .empty_deck
	inc a
	ld [hl], a ; increment number of cards not in deck
	add DUELVARS_DECK_CARDS - 1 ; point to top card in the deck
	ld l, a
	ld a, [hl] ; grab card number (0-59) from wPlayerDeckCards or wOpponentDeckCards array
	ld l, a
	ld [hl], CARD_LOCATION_JUST_DRAWN ; temporarily write to corresponding card location variable
	pop hl
	or a
	ret

.empty_deck
	pop hl
	scf
	ret
; 0x10e8

	INCROM $10e8, $1123

; adds a card to the hand and increments the number of cards in the hand
; the card is identified by register a, which contains the card number within the deck (0-59)
AddCardToHand: ; 1123 (0:1123)
	push af
	push hl
	push de
	ld e, a
	ld l, a
	ldh a, [hWhoseTurn]
	ld h, a
	; write $1 (CARD_LOCATION_HAND) into the location of this card
	ld [hl], CARD_LOCATION_HAND
	; increment number of cards in hand
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	inc [hl]
	; add card to hand
	ld a, DUELVARS_HAND - 1
	add [hl]
	ld l, a
	ld [hl], e
	pop de
	pop hl
	pop af
	ret
; 0x1139

	INCROM $1139, $123b

CreateHandCardBuffer: ; 123b (0:123b)
	call FindLastCardInHand
	inc b
	jr .skip_card

.check_next_card_loop
	ld a, [hld]
	push hl
	ld l, a
	bit 6, [hl]
	pop hl
	jr nz, .skip_card
	ld [de], a
	inc de

.skip_card
	dec b
	jr nz, .check_next_card_loop
	ld a, $ff
	ld [de], a
	ld l, (wPlayerNumberOfCardsInHand & $ff)
	ld a, [hl]
	or a
	ret nz
	scf
	ret
; 0x1258

	INCROM $1258, $1271

; puts an index to the last (newest) card in current player's hand into hl.
FindLastCardInHand: ; 1271 (0:1271)
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, (wPlayerNumberOfCardsInHand & $ff)
	ld b, [hl]
	ld a, (wPlayerHand & $ff) - 1
	add [hl]
	ld l, a
	ld de, wDuelCardOrAttackList
	ret

; shuffles the deck by swapping the position of each card with the position of another random card
; input:
; - a  = how many cards to shuffle
; - hl = position of the first card within the wPlayerDeckCards or wOpponentDeckCards array
ShuffleCards: ; 127f (0:127f)
	or a
	ret z ; return if deck is empty
	push hl
	push de
	push bc
	ld c, a
	ld b, a
	ld e, l
	ld d, h
.shuffle_next_card_loop
	push bc
	push de
	ld a, c
	call Random
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	ld a, [de]
	ld b, [hl]
	ld [hl], a
	ld a, b
	ld [de], a
	pop de
	pop bc
	inc hl
	dec b
	jr nz, .shuffle_next_card_loop
	pop bc
	pop de
	pop hl
	ret
; 0x12a3

	INCROM $12a3, $1312


; given a position in wDuelCardOrAttackList (c510), return:
;   the id of the card in that position in register de
;   its index within the deck (0 - 59) in hTempCardNumber and in register a
GetCardInC510: ; 1312 (0:1312)
	push hl
	ld e, a
	ld d, $0
	ld hl, wDuelCardOrAttackList
	add hl, de
	ld a, [hl]
	ldh [hTempCardNumber], a
	call GetCardInDeckPosition
	pop hl
	ldh a, [hTempCardNumber]
	ret
; 0x1324

; returns, in register de, the id of the card in the deck position specified in register a,
; preserving af and hl
GetCardInDeckPosition: ; 1324 (0:1324)
	push af
	push hl
	call _GetCardInDeckPosition
	ld e, a
	ld d, $0
	pop hl
	pop af
	ret
; 0x132f

	INCROM $132f, $1362

; returns, in register a, the id of the card in the deck position specified in register a
_GetCardInDeckPosition: ; 1362 (0:1362)
	push de
	ld e, a
	ld d, $0
	ld hl, wPlayerDeck
	ldh a, [hWhoseTurn]
	cp PLAYER_TURN
	jr z, .load_card_from_deck
	ld hl, wOpponentDeck
.load_card_from_deck
	add hl, de
	ld a, [hl]
	pop de
	ret

; load data of card in position a to wLoadedCard1
LoadDeckCardToBuffer1: ; 1376 (0:1376)
	push hl
	push de
	push bc
	push af
	call GetCardInDeckPosition
	call LoadCardDataToBuffer1
	pop af
	ld hl, wLoadedCard1
	bank1call ConvertTrainerCardToPokemon
	ld a, e
	pop bc
	pop de
	pop hl
	ret

; load data of card in position a to wLoadedCard2
LoadDeckCardToBuffer2: ; 138c (0:138c)
	push hl
	push de
	push bc
	push af
	call GetCardInDeckPosition
	call LoadCardDataToBuffer2
	pop af
	ld hl, wLoadedCard2
	bank1call ConvertTrainerCardToPokemon
	ld a, e
	pop bc
	pop de
	pop hl
	ret
; 0x13a2

	INCROM $13a2, $1485

Func_1485: ; 1485 (0:1485)
	push af
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY
	call GetTurnDuelistVariable
	cp MAX_POKEMON_IN_PLAY
	jr nc, .too_many_pokemon_in_play
	inc [hl]
	ld e, a
	pop af
	push af
	call $14d2
	ld a, e
	add $bb
	ld l, a
	pop af
	ld [hl], a
	call LoadDeckCardToBuffer2
	ld a, $c8
	add e
	ld l, a
	ld a, [wLoadedCard2HP]
	ld [hl], a
	ld a, $c2
	add e
	ld l, a
	ld [hl], $0
	ld a, $d4
	add e
	ld l, a
	ld [hl], $0
	ld a, $e0
	add e
	ld l, a
	ld [hl], $0
	ld a, $da
	add e
	ld l, a
	ld [hl], $0
	ld a, $ce
	add e
	ld l, a
	ld a, [wLoadedCard2Stage]
	ld [hl], a
	ld a, e
	or a
	call z, $1461
	ld a, e
	or a
	ret

.too_many_pokemon_in_play
	pop af
	scf
	ret
; 0x14d2

	INCROM $14d2, $159f

; This function iterates through the card locations array to find out which and how many
; energy cards are in arena (i.e. attached to the active pokemon).
; One or more location constants (so long as they don't clash with the arena location constant)
; can be specified in register e; if so, energies found in that location will be counted too.
; Feedback is returned in wAttachedEnergies and wTotalAttachedEnergies.
GetAttachedEnergies: ; 159f (0:159f)
	push hl
	push de
	push bc
	xor a
	ld c, NUM_TYPES
	ld hl, wAttachedEnergies
.zero_energies_loop
	ld [hli], a
	dec c
	jr nz, .zero_energies_loop
	ld a, CARD_LOCATION_ARENA
	or e ; if e is non-0, arena is not the only location that counts
	ld e, a
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_CARD_LOCATIONS
	ld c, DECK_SIZE
.next_card
	ld a, [hl]
	cp e
	jr nz, .not_in_requested_location

	push hl
	push de
	push bc
	ld a, l
	call LoadDeckCardToBuffer2
	ld a, [wLoadedCard2Type]
	bit TYPE_ENERGY_F, a
	jr z, .not_an_energy_card
	and $7 ; zero bit 3 to extract the type
	ld e, a
	ld d, $0
	ld hl, wAttachedEnergies
	add hl, de
	inc [hl] ; increment the number of energy cards of this type
	cp COLORLESS
	jr nz, .not_colorless
	inc [hl] ; each colorless energy counts as two
.not_an_energy_card
.not_colorless
	pop bc
	pop de
	pop hl

.not_in_requested_location
	inc l
	dec c
	jr nz, .next_card
	; all 60 cards checked
	ld hl, wAttachedEnergies
	ld c, NUM_TYPES
	xor a
.sum_attached_energies_loop
	add [hl]
	inc hl
	dec c
	jr nz, .sum_attached_energies_loop
	ld [hl], a ; save to wTotalAttachedEnergies
	pop bc
	pop de
	pop hl
	ret
; 0x15ef

; returns in a how many times card e can be found in location b
; e = card id to search
; b = location to consider (deck, hand, arena...)
; h = PLAYER_TURN or OPPONENT_TURN
CountCardIDInLocation: ; 15ef (0:15ef)
	push bc
	ld l, $0
	ld c, $0
.next_card
	ld a, [hl]
	cp b
	jr nz, .unmatching_card_location_orID
	ld a, l
	push hl
	call _GetCardInDeckPosition
	cp e
	pop hl
	jr nz, .unmatching_card_location_orID
	inc c
.unmatching_card_location_orID
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .next_card
	ld a, c
	pop bc
	ret

; returns [[hWhoseTurn] << 8 + a] in a and in [hl]
; i.e. variable a of the player whose turn it is
GetTurnDuelistVariable: ; 160b (0:160b)
	ld l, a
	ldh a, [hWhoseTurn]
	ld h, a
	ld a, [hl]
	ret

; returns [([hWhoseTurn] ^ $1) << 8 + a] in a and in [hl]
; i.e. variable a of the player whose turn it is not
GetNonTurnDuelistVariable: ; 1611 (0:1611)
	ld l, a
	ldh a, [hWhoseTurn]
	ld h, OPPONENT_TURN
	cp PLAYER_TURN
	jr z, .asm_161c
	ld h, PLAYER_TURN
.asm_161c
	ld a, [hl]
	ret
; 0x161e

	INCROM $161e, $16c0

CopyMoveDataAndDamageToBuffer: ; 16c0 (0:16c0)
	ld a, e
	ld [wSelectedMoveIndex], a
	ld a, d
	ld [$ff9f], a
	call LoadDeckCardToBuffer1
	ld a, [wLoadedCard1ID]
	ld [wTempCardId], a
	ld hl, wLoadedCard1Move1
	dec e
	jr nz, .got_move
	ld hl, wLoadedCard1Move2
.got_move
	ld de, wLoadedMove
	ld c, wLoadedCard1Move2 - wLoadedCard1Move1
.copy_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_loop
	ld a, [wLoadedMoveDamage]
	ld hl, wDamage
	ld [hli], a
	xor a
	ld [hl], a
	ld [wNoDamageOrEffect], a
	ld hl, wccbf
	ld [hli], a
	ld [hl], a
	ret

Func_16f6: ; 16f6 (0:16f6)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld [$ff9f], a
	call GetCardInDeckPosition
	ld a, e
	ld [wTempTurnDuelistCardId], a
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardInDeckPosition
	ld a, e
	ld [wTempNonTurnDuelistCardId], a
	call SwapTurn
	xor a
	ld [wccec], a
	ld [wcccd], a
	ld [wcced], a
	ld [wcce6], a
	ld [wccef], a
	ld [wccf0], a
	ld [wccf1], a
	bank1call $7189
	ret

Func_1730: ; 1730 (0:1730)
	ld a, [wSelectedMoveIndex]
	ld [wcc10], a
	ld a, [$ff9f]
	ld [wcc11], a
	ld a, [wTempCardId]
	ld [wcc12], a
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jp z, Func_184b
	call Func_16f6
	ld a, $1
	call TryExecuteEffectCommandFunction
	jp c, Func_181e
	call CheckSandAttackOrSmokescreenSubstatus
	jr c, .asm_1766
	ld a, $2
	call TryExecuteEffectCommandFunction
	jp c, Func_1821
	call Func_1874
	jr .asm_1777
.asm_1766
	call Func_1874
	call HandleSandAttackOrSmokescreenSubstatus
	jp c, Func_1823
	ld a, $2
	call TryExecuteEffectCommandFunction
	jp c, Func_1821
.asm_1777
	ld a, $9
	call Func_0f7f
	ld a, $6
	call TryExecuteEffectCommandFunction
	call CheckSelfConfusionDamage
	jp c, DealConfusionDamageToSelf
	call Func_1b8d
	call WaitForWideTextBoxInput
	call Func_0f58
	ld a, $5
	call TryExecuteEffectCommandFunction
	ld a, $a
	call Func_0f7f
	call $7415
	ld a, [wLoadedMoveCategory]
	and RESIDUAL
	jr nz, .asm_17ad
	call SwapTurn
	call HandleNoDamageOrEffectSubstatus
	call SwapTurn
.asm_17ad
	xor a
	ld [$ff9d], a
	ld a, $3
	call TryExecuteEffectCommandFunction
	call Func_1994
	call Func_189d
	ld hl, wccbf
	ld [hl], e
	inc hl
	ld [hl], d
	ld b, $0
	ld a, [wccc1]
	ld c, a
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	push de
	push hl
	call $7494
	call $741a
	call $7484
	pop hl
	pop de
	call SubstractHP
	ld a, [wcac2]
	cp $1
	jr nz, .asm_17e8
	push hl
	bank1call $503a
	pop hl
.asm_17e8
	call Func_1ad0
	jr Func_17fb

Func_17ed: ; 17ed (0:17ed)
	call DrawWideTextBox_WaitForInput
	xor a
	ld hl, wDamage
	ld [hli], a
	ld [hl], a
	ld a, NO_DAMAGE_OR_EFFECT_AGILITY
	ld [wNoDamageOrEffect], a
Func_17fb: ; 17fb (0:17fb)
	ld a, [wTempNonTurnDuelistCardId]
	push af
	ld a, $4
	call TryExecuteEffectCommandFunction
	pop af
	ld [wTempNonTurnDuelistCardId], a
	call HandleStrikesBack
	bank1call $6df1
	call Func_1bb4
	bank1call $7195
	call $6e49
	or a
	ret

Func_1819: ; 1819 (0:1819)
	push hl
	call $6510
	pop hl

Func_181e: ; 181e (0:181e)
	call DrawWideTextBox_WaitForInput

Func_1821: ; 1821 (0:1821)
	scf
	ret

Func_1823: ; 1823 (0:1823)
	bank1call $717a
	or a
	ret

DealConfusionDamageToSelf: ; 1828 (0:1828)
	bank1call $4f9d
	ld a, $1
	ld [wcce6], a
	ldtx hl, DamageToSelfDueToConfusionText
	call DrawWideTextBox_PrintText
	ld a, $75
	ld [wLoadedMoveAnimation], a
	ld a, 20 ; damage
	call Func_195c
	call Func_1bb4
	call $6e49
	bank1call $717a
	or a
	ret

Func_184b: ; 184b (0:184b)
	call $7415
	ld a, $2
	call TryExecuteEffectCommandFunction
	jr c, Func_1819
	ld a, $5
	call TryExecuteEffectCommandFunction
	jr c, Func_1821
	ld a, $c
	call Func_0f7f
	call Func_0f58
	ld a, $d
	call Func_0f7f
	ld a, $3
	call TryExecuteEffectCommandFunction
	ld a, $16
	call Func_0f7f
	ret

Func_1874: ; 1874 (0:1874)
	ld a, [wccec]
	or a
	ret nz
	ld a, [$ffa0]
	push af
	ld a, [$ff9f]
	push af
	ld a, $1
	ld [wccec], a
	ld a, [wcc11]
	ld [$ff9f], a
	ld a, [wcc10]
	ld [$ffa0], a
	ld a, $8
	call Func_0f7f
	call Func_0f58
	pop af
	ld [$ff9f], a
	pop af
	ld [$ffa0], a
	ret

Func_189d: ; 189d (0:189d)
	ld a, [wLoadedMoveCategory]
	bit RESIDUAL_F, a
	ret nz
	ld a, [wNoDamageOrEffect]
	or a
	ret nz
	ld a, e
	or d
	jr nz, .asm_18b9
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetNonTurnDuelistVariable
	or a
	jr nz, .asm_18b9
	ld a, [wcccd]
	or a
	ret z
.asm_18b9
	push de
	call SwapTurn
	xor a
	ld [wcceb], a
	call HandleTransparency
	call SwapTurn
	pop de
	ret nc
	bank1call $4f9d
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetNonTurnDuelistVariable
	ld [hl], $0
	ld de, $0000
	ret

; return carry and 1 into wccc9 if damage is dealt to oneself due to confusion
CheckSelfConfusionDamage: ; 18d7 (0:18d7)
	xor a
	ld [wccc9], a
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and PASSIVE_STATUS_MASK
	cp CONFUSED
	jr z, .confused
	or a
	ret
.confused
	ldtx de, ConfusionCheckDamageText
	call TossCoin
	jr c, .no_confusion_damage
	ld a, $1
	ld [wccc9], a
	scf
	ret
.no_confusion_damage
	or a
	ret
; 0x18f9

	INCROM $18f9, $1944

; this loads HP and Stage (1 byte each) of card with id at $ff9f into wLoadedMoveEffectCommands
Func_1944: ; 1944 (0:1944)
	ld a, [$ff9f]
	call LoadDeckCardToBuffer1
	ld hl, wLoadedCard1HP
	ld de, wLoadedMoveEffectCommands
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret
; 0x1955

Func_1955: ; 1955 (0:1955)
	push af
	ld a, $7a
	ld [wLoadedMoveAnimation], a
	pop af
; this function appears to apply several damage modifiers
Func_195c: ; 195c (0:195c)
	ld hl, wDamage
	ld [hli], a
	ld [hl], $0
	ld a, [wNoDamageOrEffect]
	push af
	xor a
	ld [wNoDamageOrEffect], a
	bank1call $7415
	ld a, [wTempNonTurnDuelistCardId]
	push af
	ld a, [wTempTurnDuelistCardId]
	ld [wTempNonTurnDuelistCardId], a
	bank1call Func_1a22 ; switch to bank 1, but call a home func
	ld a, [wccc1]
	ld c, a
	ld b, $0
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	bank1call $7469
	call Func_1ad0
	pop af
	ld [wTempNonTurnDuelistCardId], a
	pop af
	ld [wNoDamageOrEffect], a
	ret

Func_1994: ; 1994 (0:1994)
	xor a
	ld [wccc1], a
	ld hl, wDamage
	ld a, [hli]
	or [hl]
	jr nz, .non_zero_damage
	ld de, $0000
	ret
.non_zero_damage
	xor a
	ld [$ff9d], a
	ld d, [hl]
	dec hl
	ld e, [hl]
	bit 7, d
	jr z, .safe
	res 7, d ; cap at 2^15
	xor a
	ld [wccc1], a
	call HandleDoubleDamageSubstatus
	jr .check_pluspower_and_defender
.safe
	call HandleDoubleDamageSubstatus
	ld a, e
	or d
	ret z
	ld a, [$ff9d]
	call Func_36f7
	call Func_1a0e
	ld b, a
	call SwapTurn
	call Func_3730
	call SwapTurn
	and b
	jr z, .asm_19dc
	sla e
	rl d
	ld hl, $ccc1
	set 1, [hl]
.asm_19dc
	call SwapTurn
	call Func_374a
	call SwapTurn
	and b
	jr z, .check_pluspower_and_defender
	ld hl, $ffe2
	add hl, de
	ld e, l
	ld d, h
	ld hl, $ccc1
	set 2, [hl]
.check_pluspower_and_defender
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	call SwapTurn
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedDefender
	call HandleDamageReduction
	bit 7, d
	jr z, .no_underflow
	ld de, $0000
.no_underflow
	call SwapTurn
	ret

Func_1a0e: ; 1a0e (0:1a0e)
	push hl
	add $1a
	ld l, a
	ld a, $1a
	adc $0
	ld h, a
	ld a, [hl]
	pop hl
	ret
; 0x1a1a

	INCROM $1a1a, $1a22

Func_1a22: ; 1a22 (0:1a22)
	xor a
	ld [wccc1], a
	ld hl, wDamage
	ld a, [hli]
	or [hl]
	or a
	jr z, .no_damage
	ld d, [hl]
	dec hl
	ld e, [hl]
	call Func_36f6
	call Func_1a0e
	ld b, a
	call Func_3730
	and b
	jr z, .asm_1a47
	sla e
	rl d
	ld hl, $ccc1
	set 1, [hl]
.asm_1a47
	call Func_374a
	and b
	jr z, .asm_1a58
	ld hl, $ffe2
	add hl, de
	ld e, l
	ld d, h
	ld hl, $ccc1
	set 2, [hl]
.asm_1a58
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedDefender
	bit 7, d ; test for underflow
	ret z
.no_damage
	ld de, $0000
	ret

; increases de by 10 points for each Pluspower found in location b
ApplyAttachedPluspower: ; 1a69 (0:1a69)
	push de
	call GetTurnDuelistVariable
	ld de, PLUSPOWER
	call CountCardIDInLocation
	ld l, a
	ld h, 10
	call HtimesL
	pop de
	add hl, de
	ld e, l
	ld d, h
	ret

; reduces de by 20 points for each Defender found in location b
ApplyAttachedDefender: ; 1a7e (0:1a7e)
	push de
	call GetTurnDuelistVariable
	ld de, DEFENDER
	call CountCardIDInLocation
	ld l, a
	ld h, 20
	call HtimesL
	pop de
	ld a, e
	sub l
	ld e, a
	ld a, d
	sbc h
	ld d, a
	ret

; hl: address to substract HP from
; de: how much HP to substract (damage to deal)
; returns carry if the HP does not become 0 as a result
SubstractHP: ; 1a96 (0:1a96)
	push hl
	push de
	ld a, [hl]
	sub e
	ld [hl], a
	ld a, $0
	sbc d
	and $80
	jr z, .no_underflow
	ld [hl], $0
.no_underflow
	ld a, [hl]
	or a
	jr z, .zero
	scf
.zero
	pop de
	pop hl
	ret

Func_1aac: ; 1aac (0:1aac)
	ld e, a
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	ret nz
	ld a, [wTempNonTurnDuelistCardId]
	push af
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadDeckCardToBuffer1
	ld a, [wLoadedCard1ID]
	ld [wTempNonTurnDuelistCardId], a
	call Func_1ad3
	pop af
	ld [wTempNonTurnDuelistCardId], a
	scf
	ret

Func_1ad0: ; 1ad0 (0:1ad0)
	ld a, [hl]
	or a
	ret nz
Func_1ad3: ; 1ad3 (0:1ad3)
	ld a, [wTempNonTurnDuelistCardId]
	ld e, a
	call LoadCardDataToBuffer1
	ld hl, $cc27
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_2ebb
	ldtx hl, WasKnockedOutText
	call DrawWideTextBox_PrintText
	ld a, $28
.asm_1aeb
	call DoFrame
	dec a
	jr nz, .asm_1aeb
	scf
	ret
; 0x1af3

	INCROM $1af3, $1b8d

Func_1b8d: ; 1b8d (0:1b8d)
	bank1call $4f9d
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadDeckCardToBuffer1
	ld a, $12
	call Func_29f5
	ld [hl], $0
	ld hl, $ce3f
	xor a
	ld [hli], a
	ld [hli], a
	ld a, [wLoadedMoveName]
	ld [hli], a
	ld a, [wLoadedMoveName + 1]
	ld [hli], a
	ldtx hl, PokemonsAttackText ; text when using an attack
	call DrawWideTextBox_PrintText
	ret

Func_1bb4: ; 1bb4 (0:1bb4)
	call Func_3b31
	bank1call $4f9d
	call $503a
	xor a
	ld [$ff9d], a
	call Func_1bca
	call WaitForWideTextBoxInput
	call Func_0f58
	ret

Func_1bca: ; 1bca (0:1bca)
	ld a, [wcced]
	or a
	ret z
	cp $1
	jr z, .asm_1bfd
	ld a, [$ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadDeckCardToBuffer1
	ld a, $12
	call Func_29f5
	ld [hl], $0
	ld hl, $0000
	call Func_2ebb
	ld hl, $ccaa
	ld de, $ce41
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ldtx hl, WasUnsuccessfulText
	call DrawWideTextBox_PrintText
	scf
	ret
.asm_1bfd
	call $700a
	call DrawWideTextBox_PrintText
	scf
	ret
; 0x1c05

	INCROM $1c05, $1c72

; returns [hWhoseTurn] <-- ([hWhoseTurn] ^ $1)
;   As a side effect, this also returns a duelist variable in a similar manner to
;   GetNonTurnDuelistVariable, but this function appears to be
;   only called to swap the turn value.
SwapTurn: ; 1c72 (0:1c72)
	push af
	push hl
	call GetNonTurnDuelistVariable
	ld a, h
	ldh [hWhoseTurn], a
	pop hl
	pop af
	ret

PrintPlayerName: ; 1c7d (0:1c7d)
	call EnableExtRAM
	ld hl, $a010
.loop
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, .loop
	dec de
	call DisableExtRAM
	ret

PrintOpponentName: ; 1c8e (0:1c8e)
	ld hl, $cc16
	ld a, [hli]
	or [hl]
	jr z, .special_name
	ld a, [hld]
	ld l, [hl]
	ld h, a
	jp PrintTextBoxBorderLabel
.special_name
	ld hl, $c500
	ld a, [hl]
	or a
	jr z, .print_player2
	jr PrintPlayerName.loop
.print_player2
	ldtx hl, Player2Text
	jp PrintTextBoxBorderLabel

Func_1caa: ; 1caa (0:1caa)
	push de
	push bc
	call EnableExtRAM
	ld hl, $0000
	ld de, sDeck1Cards
	ld c, $4
.asm_1cb7
	ld a, [de]
	or a
	jr z, .asm_1cc1
	ld a, c
	ld bc, $003c
	add hl, bc
	ld c, a

.asm_1cc1
	ld a, $54
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	dec c
	jr nz, .asm_1cb7
	ld de, sCardCollection
.asm_1ccf
	ld a, [de]
	bit 7, a
	jr nz, .asm_1cd8
	ld c, a
	ld b, $0
	add hl, bc

.asm_1cd8
	inc e
	jr nz, .asm_1ccf
	call DisableExtRAM
	pop bc
	pop de
	ret

Func_1ce1: ; 1ce1 (0:1ce1)
	push hl
	push de
	push bc
	call EnableExtRAM
	ld c, a
	ld b, $0
	ld hl, sDeck1Cards
	ld d, $4
.asm_1cef
	ld a, [hl]
	or a
	jr z, .asm_1cff
	push hl
	ld e, $3c
.asm_1cf6
	ld a, [hli]
	cp c
	jr nz, .asm_1cfb
	inc b

.asm_1cfb
	dec e
	jr nz, .asm_1cf6
	pop hl

.asm_1cff
	push de
	ld de, $0054
	add hl, de
	pop de
	dec d
	jr nz, .asm_1cef
	ld h, $a1
	ld l, c
	ld a, [hl]
	bit 7, a
	jr nz, .asm_1d11
	add b

.asm_1d11
	and $7f
	call DisableExtRAM
	pop bc
	pop de
	pop hl
	or a
	ret nz
	scf
	ret

Func_1d1d: ; 1d1d (0:1d1d)
	push hl
	call EnableExtRAM
	ld h, $a1
	ld l, a
	ld a, [hl]
	call DisableExtRAM
	pop hl
	and $7f
	ret nz
	scf
	ret

; creates a list at $c000 of every card the player owns and how many
CreateTempCardCollection: ; 1d2e (0:1d2e)
	call EnableExtRAM
	ld hl, sCardCollection
	ld de, wTempCardCollection
	ld bc, CARD_COLLECTION_SIZE
	call CopyDataHLtoDE
	ld de, sDeck1Name
	call AddDeckCardsToTempCardCollection
	ld de, sDeck2Name
	call AddDeckCardsToTempCardCollection
	ld de, sDeck3Name
	call AddDeckCardsToTempCardCollection
	ld de, sDeck4Name
	call AddDeckCardsToTempCardCollection
	call DisableExtRAM
	ret

AddDeckCardsToTempCardCollection: ; 1d59 (0:1d59)
	ld a, [de]
	or a
	ret z
	ld hl, sDeck1Cards - sDeck1Name
	add hl, de
	ld e, l
	ld d, h
	ld h, wTempCardCollection >> 8
	ld c, DECK_SIZE
.asm_1d66
	ld a, [de]
	inc de
	ld l, a
	inc [hl]
	dec c
	jr nz, .asm_1d66
	ret

; adds card a to collection, provided the player has less than 99 of them
AddCardToCollection: ; 1d6e (0:1d6e)
	push hl
	push de
	push bc
	ld l, a
	push hl
	call CreateTempCardCollection
	pop hl
	call EnableExtRAM
	ld h, wTempCardCollection >> 8
	ld a, [hl]
	and $7f
	cp 99
	jr nc, .asm_1d8a
	ld h, sCardCollection >> 8
	ld a, [hl]
	and $7f
	inc a
	ld [hl], a
.asm_1d8a
	call DisableExtRAM
	pop bc
	pop de
	pop hl
	ret

Func_1d91: ; 1d91 (0:1d91)
	push hl
	call EnableExtRAM
	ld h, $a1
	ld l, a
	ld a, [hl]
	and $7f
	jr z, .asm_1d9f
	dec a
	ld [hl], a

.asm_1d9f
	call DisableExtRAM
	pop hl
	ret
; 0x1da4

	INCROM $1da4, $1dca

; memcpy(HL, DE, C)
; if LCD on, copy during h-blank only
SafeCopyDataDEtoHL: ; 1dca (0:1dca)
	ld a, [wLCDC]        ;
	bit rLCDC_ENABLE, a  ;
	jr nz, .lcd_on       ; assert that LCD is on
.lcd_off_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .lcd_off_loop
	ret
.lcd_on
	jp HblankCopyDataDEtoHL

; returns vBGMapTiles + BG_MAP_WIDTH * e + d in hl.
; used to map coordinates at de to a BGMap0 address.
DECoordToBGMap0Address: ; 1ddb (0:1ddb)
	ld l, e
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, l
	add d
	ld l, a
	ld a, h
	adc HIGH(vBGMapTiles)
	ld h, a
	ret

; Apply window correction to xy coordinates at de
AdjustCoordinatesForWindow: ; 1deb (0:1deb)
	push af
	ldh a, [hSCX]
	rra
	rra
	rra
	and $1f
	add d
	ld d, a
	ldh a, [hSCY]
	rra
	rra
	rra
	and $1f
	add e
	ld e, a
	pop af
	ret

; Draws a bxc text box at de printing a name in the left side of the top border.
; The name's text id must be at hl when this function is called.
; Mostly used to print text boxes for talked-to NPCs, but occasionally used in duels as well.
DrawLabeledTextBox: ; 1e00 (0:1e00)
	ld a, [wConsole]
	cp CONSOLE_SGB
	jr nz, .draw_top_border
	ld a, [wFrameType]
	or a
	jr z, .draw_top_border
; Console is SGB and frame type is != 0.
; The text box will be colorized so a SGB command needs to be transferred
	push de
	push bc
	call .draw_top_border ; this falls through to drawing the whole box
	pop bc
	pop de
	jp ColorizeTextBoxSGB

.draw_top_border
	push de
	push bc
	push hl
	; top left tile of the box
	ld hl, wTempCardCollection
	ld a, $5
	ld [hli], a
	ld a, $18
	ld [hli], a
	; white tile before the text
	ld a, $70
	ld [hli], a
	ld e, l
	ld d, h
	pop hl
	call PrintTextBoxBorderLabel
	ld hl, $c003
	call Func_23c1
	ld l, e
	ld h, d
	; white tile after the text
	ld a, $7
	ld [hli], a
	ld a, $70
	ld [hli], a
	pop de
	push de
	ld a, d
	sub b
	sub $4
	jr z, .draw_top_border_right_tile
	ld b, a
.draw_top_border_line_loop
	ld a, $5
	ld [hli], a
	ld a, $1c
	ld [hli], a
	dec b
	jr nz, .draw_top_border_line_loop

.draw_top_border_right_tile
	ld a, $5
	ld [hli], a
	ld a, $19
	ld [hli], a
	ld [hl], $0
	pop bc
	pop de
	push de
	push bc
	call Func_22ae
	ld hl, wTempCardCollection
	call Func_21c5
	pop bc
	pop de
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr z, .cgb
; DMG or SGB
	inc e
	call DECoordToBGMap0Address
	; top border done, draw the rest of the text box
	jr ContinueDrawingTextBoxDMGorSGB

.cgb
	call DECoordToBGMap0Address
	push de
	call CopyCurrentLineAttrCGB ; BG Map attributes for current line, which is the top border
	pop de
	inc e
	; top border done, draw the rest of the text box
	jp ContinueDrawingTextBoxCGB

; Draws a bxc text box at de to print menu data in the overworld.
; Also used to print a text box during a duel.
; When talking to NPCs, DrawLabeledTextBox is used instead.
DrawRegularTextBox: ; 1e7c (0:1e7c)
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr z, DrawRegularTextBoxCGB
	cp CONSOLE_SGB
	jp z, DrawRegularTextBoxSGB
;	fallthrough
DrawRegularTextBoxDMG: ; 1e88 (0:1e88)
	call DECoordToBGMap0Address
	; top line (border) of the text box
	ld a, $1c
	lb de, $18, $19
	call CopyLine
;	fallthrough

ContinueDrawingTextBoxDMGorSGB:
	dec c
	dec c
.draw_text_box_body_loop
	ld a, $0
	lb de, $1e, $1f
	call CopyLine
	dec c
	jr nz, .draw_text_box_body_loop
	; bottom line (border) of the text box
	ld a, $1d
	lb de, $1a, $1b
;	fallthrough

; copies b bytes of data to sp+$1c and to hl, and returns hl += BG_MAP_WIDTH
; d = value of byte 0
; e = value of byte b
; a = value of bytes [1, b-1]
; b is supposed to be BG_MAP_WIDTH or smaller, else the stack would get corrupted
CopyLine: ; 1ea5 (0:1ea5)
	add sp, -BG_MAP_WIDTH
	push hl
	push bc
	ld hl, sp+$4
	dec b
	dec b
	push hl
	ld [hl], d
	inc hl
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ld [hl], e
	pop de
	pop bc
	pop hl
	push hl
	push bc
	ld c, b
	ld b, $0
	call SafeCopyDataDEtoHL
	pop bc
	pop de
	; advance pointer BG_MAP_WIDTH positions and restore stack pointer
	ld hl, BG_MAP_WIDTH
	add hl, de
	add sp, BG_MAP_WIDTH
	ret

DrawRegularTextBoxCGB:
	call DECoordToBGMap0Address
	; top line (border) of the text box
	ld a, $1c
	lb de, $18, $19
	call CopyCurrentLineTilesAndAttrCGB
;	fallthrough

ContinueDrawingTextBoxCGB:
	dec c
	dec c
.draw_text_box_body_loop
	ld a, $0
	lb de, $1e, $1f
	push hl
	call CopyLine
	pop hl
	call BankswitchVRAM_1
	ld a, [wFrameType]
	ld e, a
	ld d, a
	xor a
	call CopyLine
	call BankswitchVRAM_0
	dec c
	jr nz, .draw_text_box_body_loop
	; bottom line (border) of the text box
	ld a, $1d
	lb de, $1a, $1b
	call CopyCurrentLineTilesAndAttrCGB
	ret

; d = id of top left tile
; e = id of top right tile
; a = id of rest of tiles
; Assumes b = SCREEN_WIDTH and that VRAM bank 0 is loaded
CopyCurrentLineTilesAndAttrCGB: ; 1efb (0:1efb)
	push hl
	call CopyLine
	pop hl
;	fallthrough
CopyCurrentLineAttrCGB:
	call BankswitchVRAM_1
	ld a, [wFrameType] ; on CGB, wFrameType determines the palette and the other attributes
	ld e, a
	ld d, a
	call CopyLine
	call BankswitchVRAM_0
	ret

DrawRegularTextBoxSGB: ; 1f0f (0:1f0f)
	push bc
	push de
	call DrawRegularTextBoxDMG
	pop de
	pop bc
	ld a, [wFrameType]
	or a
	ret z
ColorizeTextBoxSGB
	push bc
	push de
	ld hl, $cae0
	ld de, AttrBlkPacket_1f4f
	ld c, $10
.copy_sgb_command_loop
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .copy_sgb_command_loop
	pop de
	pop bc
	ld hl, $cae4
	ld [hl], d
	inc hl
	ld [hl], e
	inc hl
	ld a, d
	add b
	dec a
	ld [hli], a
	ld a, e
	add c
	dec a
	ld [hli], a
	ld a, [wFrameType]
	and $80
	jr z, .asm_1f48
	ld a, $2
	ld [wcae2], a
.asm_1f48
	ld hl, $cae0
	call SendSGB
	ret

AttrBlkPacket_1f4f: ; 1f4f (0:1f4f)
	sgb ATTR_BLK, 1 ; sgb_command, length
	db 1 ; number of data sets
	; Control Code,  Color Palette Designation, X1, Y1, X2, Y2
	db ATTR_BLK_CTRL_INSIDE + ATTR_BLK_CTRL_LINE, 0 << 0 + 1 << 2, 0, 0, 0, 0 ; data set 1
	ds 6 ; data set 2
	ds 2 ; data set 3

Func_1f5f: ; 1f5f (0:1f5f)
	push de
	push af
	push hl
	add sp, $e0
	call DECoordToBGMap0Address
.asm_1f67
	push hl
	push bc
	ld hl, sp+$25
	ld d, [hl]
	ld hl, sp+$27
	ld a, [hl]
	ld hl, sp+$4
	push hl
.asm_1f72
	ld [hli], a
	add d
	dec b
	jr nz, .asm_1f72
	pop de
	pop bc
	pop hl
	push hl
	push bc
	ld c, b
	ld b, $0
	call SafeCopyDataDEtoHL
	ld hl, sp+$24
	ld a, [hl]
	ld hl, sp+$27
	add [hl]
	ld [hl], a
	pop bc
	pop de
	ld hl, $0020
	add hl, de
	dec c
	jr nz, .asm_1f67
	add sp, $24
	pop de
	ret
; 0x1f96

	INCROM $1f96, $20b0

Func_20b0: ; 20b0 (0:20b0)
	ld hl, $2fe8
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .asm_20bd
	ld hl, $37f8
.asm_20bd
	ld de, vTiles1 + $500
	ld b, $30
	jr asm_2121

Func_20c4: ; 20c4 (0:20c4)
	ld hl, $3028
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .asm_20d1
	ld hl, $3838
.asm_20d1
	ld de, vTiles1 + $540
	ld b, $c
	jr asm_2121

Func_20d8: ; 20d8 (0:20d8)
	ld b, $10
	jr asm_20de

Func_20dc: ; 20dc (0:20dc)
	ld b, $24
asm_20de
	ld hl, $32e8
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .asm_20eb
	ld hl, $3af8
.asm_20eb
	ld de, vTiles1 + $500
	jr asm_2121

Func_20f0: ; 20f0 (0:20f0)
	ld hl, $4008
	ld de, vTiles1 + $200
	ld b, $d
	call asm_2121
	ld hl, $3528
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .asm_2108
	ld hl, $3d38
.asm_2108
	ld de, vTiles1 + $500
	ld b, $30
	jr asm_2121

Func_210f: ; 210f (0:210f)
	ld hl, $40d8
	ld de, vTiles2 + $300
	ld b, $8
	jr asm_2121

Func_2119: ; 2119 (0:2119)
	ld hl, DuelGraphics - $4000
	ld de, vTiles2 ; destination
	ld b, $38 ; number of tiles
asm_2121
	ld a, BANK(DuelGraphics)
	call BankpushHome
	ld c, TILE_SIZE
	call CopyGfxData
	call BankpopHome
	ret
; 0x212f

	INCROM $212f, $2167

Func_2167: ; 2167 (0:2167)
	ld l, a
	ld h, $a0
	call HtimesL
	add hl, hl
	add hl, hl
	ld de, $4318
	add hl, de
	ld de, $8a00
	ld b, $28
	call asm_2121
	ld a, $a0
	ld hl, $010a
	ld bc, $0a04
	ld de, $0504
	jp Func_1f5f
; 0x2189

	INCROM $2189, $21c5

Func_21c5: ; 21c5 (0:21c5)
	push de
	push bc
	call Func_2298
	jr .asm_21e8
.asm_21cc
	cp $5
	jr c, .asm_21d9
	cp $10
	jr nc, .asm_21d9
	call Func_21f2
	jr .asm_21e8
.asm_21d9
	ld e, a
	ld d, [hl]
	call Func_2546
	jr nc, .asm_21e1
	inc hl
.asm_21e1
	call Func_22ca
	xor a
	call Func_21f2
.asm_21e8
	ld a, [hli]
	or a
	jr nz, .asm_21cc
	call Func_230f
	pop bc
	pop de
	ret

Func_21f2: ; 21f2 (0:21f2)
	or a
	jr z, .asm_2241
	cp $e
	jr z, .asm_2221
	cp $f
	jr z, .asm_2221
	cp $a
	jr z, .asm_224d
	cp $5
	jr z, .asm_2225
	cp $6
	jr z, .asm_220f
	cp $7
	jr z, .asm_2215
	scf
	ret
.asm_220f
	ld a, $1
	ld [wcd0a], a
	ret
.asm_2215
	call Func_230f
	xor a
	ld [wcd0a], a
	ld a, $f
	ldh [hffaf], a
	ret
.asm_2221
	ldh [hffaf], a
	xor a
	ret
.asm_2225
	ld a, [wcd0a]
	push af
	ld a, $1
	ld [wcd0a], a
	call Func_230f
	pop af
	ld [wcd0a], a
	ldh a, [$ffb0]
	or a
	jr nz, .asm_2240
	ld a, [hl]
	push hl
	call Func_22f2
	pop hl
.asm_2240
	inc hl
.asm_2241
	ldh a, [$ffae]
	or a
	ret z
	ld b, a
	ldh a, [$ffac]
	cp b
	jr z, .asm_224d
	xor a
	ret
.asm_224d
	call Func_230f
	ld a, [wcd08]
	or a
	call z, .asm_2257
.asm_2257
	xor a
	ldh [$ffac], a
	ldh a, [$ffad]
	add $20
	ld b, a
	ldh a, [$ffaa]
	and $e0
	add b
	ldh [$ffaa], a
	ldh a, [$ffab]
	adc $0
	ldh [$ffab], a
	ld a, [wcd09]
	inc a
	ld [wcd09], a
	xor a
	ret

Func_2275: ; 2275 (0:2275)
	ld a, d
	dec a
	ld [wcd04], a
	ld a, e
	ldh [$ffa8], a
	call Func_2298
	xor a
	ldh [$ffb0], a
	ldh [$ffa9], a
	ld a, $88
	ld [wcd06], a
	ld a, $80
	ld [wcd07], a
	ld hl, wc600
.asm_2292
	xor a
	ld [hl], a
	inc l
	jr nz, .asm_2292
	ret

Func_2298: ; 2298 (0:2298)
	xor a
	ld [wcd0a], a
	ldh [$ffac], a
	ld [wcd0b], a
	ld a, $f
	ldh [hffaf], a
	ret

Func_22a6: ; 22a6 (0:22a6)
	push af
	call Func_22ae
	pop af
	ldh [$ffae], a
	ret

Func_22ae: ; 22ae (0:22ae)
	push hl
	ld a, d
	ldh [$ffad], a
	xor a
	ldh [$ffae], a
	ld [wcd09], a
	call DECoordToBGMap0Address
	ld a, l
	ldh [$ffaa], a
	ld a, h
	ldh [$ffab], a
	call Func_2298
	xor a
	ld [wcd0b], a
	pop hl
	ret

Func_22ca: ; 22ca (0:22ca)
	push hl
	push de
	push bc
	ldh a, [$ffb0]
	and $1
	jr nz, .asm_22ed
	call Func_2325
	jr c, .asm_22de
	or a
	jr nz, .asm_22e9
	call Func_24ac
.asm_22de
	ldh a, [$ffb0]
	and $2
	jr nz, .asm_22e9
	ldh a, [$ffa9]
	call Func_22f2
.asm_22e9
	pop bc
	pop de
	pop hl
	ret
.asm_22ed
	call Func_235e
	jr .asm_22e9

Func_22f2: ; 22f2 (0:22f2)
	ld [wcd05], a
	ld hl, $ffaa
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	dec de
	ld l, e
	ld h, d
	ld de, $cd05
	ld c, $1
	call SafeCopyDataDEtoHL
	ld hl, $ffac
	inc [hl]
	ret

Func_230f: ; 230f (0:230f)
	ld a, [wcd0a]
	or a
	ret z
	ld a, [wcd0b]
	or a
	ret z
	push hl
	push de
	push bc
	ld e, $20
	call Func_22ca
	pop bc
	pop de
	pop hl
	ret

Func_2325: ; 2325 (0:2325)
	call Func_235e
	ret c
	or a
	ret nz
	ldh a, [$ffa8]
	ld hl, $cd04
	cp [hl]
	jr nz, .asm_2345
	ldh a, [$ffa9]
	ld h, $c8
.asm_2337
	ld l, a
	ld a, [hl]
	or a
	jr nz, .asm_2337
	ld h, $c9
	ld c, [hl]
	ld b, $c8
	xor a
	ld [bc], a
	jr .asm_234a
.asm_2345
	inc [hl]
	jr nz, .asm_2349
	inc [hl]
.asm_2349
	ld l, [hl]
.asm_234a
	ldh a, [$ffa9]
	ld c, a
	ld b, $c9
	ld a, l
	ldh [$ffa9], a
	ld [bc], a
	ld h, $c8
	ld [hl], c
	ld h, $c6
	ld [hl], e
	inc h
	ld [hl], d
	ld b, l
	xor a
	ret

; search linked-list for letters e/d (regisers), if found hoist the result to
; head of list and return it.  carry flag denotes success.
Func_235e: ; 235e (0:235e)
	ld a, [wcd0a]        ;
	or a                 ;
	jr z, .asm_2376      ; if [wcd0a] nonzero:
	call Uppercase       ;   uppercase e
	ld a, [wcd0b]
	ld d, a
	or a
	jr nz, .asm_2376     ;   if [wcd0b] is zero:
	ld a, e              ;
	ld [wcd0b], a        ;     [wcd0b] ← e
	ld a, $1             ;
	or a                 ;     return a = 1
	ret
.asm_2376
	xor a
	ld [wcd0b], a        ; [wcd0b] ← 0
	ldh a, [$ffa9]
	ld l, a              ; l ← [$ffa9]; index to to linked-list head
.asm_237d
	ld h, $c6                                     ;
	ld a, [hl]           ; a ← key1[l]            ;
	or a                                          ;
	ret z                ; if NULL, return a = 0  ;
	cp e                                          ; loop for e/d key in
	jr nz, .asm_238a     ;                        ; linked list
	inc h                ;                        ;
	ld a, [hl]           ; if key1[l] == e and    ;
	cp d                 ;    key2[l] == d:       ;
	jr z, .asm_238f      ;   break                ;
.asm_238a                                             ;
	ld h, $c8            ;                        ;
	ld l, [hl]           ; l ← next[l]            ;
	jr .asm_237d
.asm_238f
	ldh a, [$ffa9]
	cp l
	jr z, .asm_23af      ; assert at least one iteration
	ld c, a
	ld b, $c9
	ld a, l
	ld [bc], a           ; prev[i0] ← i
	ldh [$ffa9], a       ; [$ffa9] ← i  (update linked-list head)
	ld h, $c9
	ld b, [hl]
	ld [hl], $0          ; prev[i] ← 0
	ld h, $c8
	ld a, c
	ld c, [hl]
	ld [hl], a           ; next[i] ← i0
	ld l, b
	ld [hl], c           ; next[prev[i]] ← next[i]
	ld h, $c9
	inc c
	dec c
	jr z, .asm_23af      ; if next[i] != NULL:
	ld l, c              ;   l ← next[i]
	ld [hl], b           ;   prev[next[i]] ← prev[i]
.asm_23af
	scf                  ; set carry to indicate success
	ret                  ; (return new linked-list head in a)

; uppercases e if [wUppercaseFlag] is nonzero
Uppercase: ; 23b1 (0:23b1)
	ld a, [wUppercaseFlag]
	or a
	ret z
	ld a, e
	cp $60
	ret c
	cp $7b
	ret nc
	sub $20
	ld e, a
	ret

Func_23c1: ; 23c1 (0:23c1)
	ld a, [hl]
	cp $6
	jr nz, .asm_23cf
	call Func_23d3
	inc b
	srl b
	xor a
	sub b
	ret
.asm_23cf
	xor a
	ld [wcd0a], a
Func_23d3: ; 23d3 (0:23d3)
	push hl
	push de
	ld bc, $0000
.asm_23d8
	ld a, [hli]
	or a
	jr z, .asm_23f8
	inc c
	cp $5
	jr c, .asm_23ec
	cp $10
	jr nc, .asm_23ec
	cp $5
	jr nz, .asm_23d8
	inc b
	jr .asm_23f4
.asm_23ec
	ld e, a
	ld d, [hl]
	inc b
	call Func_2546
	jr nc, .asm_23d8
.asm_23f4
	inc c
	inc hl
	jr .asm_23d8
.asm_23f8
	xor a
	sub b
	pop de
	pop hl
	ret
; 0x23fd

	INCROM $23fd, $245d

Func_245d: ; 245d (0:245d)
	push de
	push bc
	ld de, wcaa0
	push de
	ld bc, $d8f0
	call Func_2499
	ld bc, $fc18
	call Func_2499
	ld bc, $ff9c
	call Func_2499
	ld bc, $fff6
	call Func_2499
	ld bc, $ffff
	call Func_2499
	xor a
	ld [de], a
	pop hl
	ld e, $5
.asm_2486
	inc hl
	ld a, [hl]
	cp $20
	jr nz, .asm_2495
	ld [hl], $0
	inc hl
	dec e
	jr nz, .asm_2486
	dec hl
	ld [hl], $20
.asm_2495
	dec hl
	pop bc
	pop de
	ret

Func_2499: ; 2499 (0:2499)
	ld a, $5
	ld [de], a
	inc de
	ld a, $1f
.asm_249f
	inc a
	add hl, bc
	jr c, .asm_249f
	ld [de], a
	inc de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	ret

Func_24ac: ; 24ac (0:24ac)
	push hl
	push de
	push bc
	ld a, [wcd0a]
	or a
	jr nz, .asm_24bf
	call Func_2510
	call SafeCopyDataDEtoHL
.asm_24bb
	pop bc
	pop de
	pop hl
	ret
.asm_24bf
	call Func_24ca
	call Func_2518
	call SafeCopyDataDEtoHL
	jr .asm_24bb

Func_24ca: ; 24ca (0:24ca)
	push bc
	ldh a, [hBankROM]
	push af
	ld a, BANK(VWF)
	call BankswitchHome
	push de
	ld a, e
	ld de, $ccf4
	call Func_24fa
	pop de
	ld a, d
	ld de, $ccf5
	call Func_24fa
	ld hl, $ccf4
	ld b, $8
.asm_24e8
	ld a, [hli]
	swap a
	or [hl]
	dec hl
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, .asm_24e8
	call BankpopHome
	pop bc
	ld de, $ccf4
	ret

Func_24fa: ; 24fa (0:24fa)
	sub $20
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, VWF
	add hl, bc
	ld b, $8
.asm_2508
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	dec b
	jr nz, .asm_2508
	ret

Func_2510: ; 2510 (0:2510)
	push bc
	call Func_256d
	call Func_252e
	pop bc
Func_2518: ; 2518 (0:2518)
	ld hl, $cd07
	ld a, b
	xor [hl]
	ld h, $0
	ld l, a
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld a, [wcd06]
	ld b, a
	ld c, $0
	add hl, bc
	ld c, $10
	ret

Func_252e: ; 252e (0:252e)
	ld a, $1d
	call BankpushHome
	ld de, $ccf4
	push de
	ld c, $8
.asm_2539
	ld a, [hli]
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec c
	jr nz, .asm_2539
	pop de
	call BankpopHome
	ret

Func_2546: ; 2546 (0:2546)
	ld a, [wcd0a]
	or a
	jr nz, .asm_255f
	ld a, e
	cp $10
	jr c, .asm_2561
	cp $60
	jr nc, .asm_2565
	ldh a, [hffaf]
	cp $f
	jr nz, .asm_2565
	ld d, $f
	or a
	ret
.asm_255f
	or a
	ret
.asm_2561
	cp $5
	jr c, .asm_2569
.asm_2565
	ld d, $0
	or a
	ret
.asm_2569
	ld e, d
	ld d, a
	scf
	ret

Func_256d: ; 256d (0:256d)
	ld bc, $0280
	ld a, d
	cp $e
	jr z, .asm_2580
	cp $f
	jr nz, .asm_2582
	ld bc, $0000
	ld a, e
	sub $10
	ld e, a
.asm_2580
	ld d, $0
.asm_2582
	ld l, e
	ld h, d
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, bc
	ret
; 0x2589

	INCROM $2589, $2636

; initializes cursor parameters given the 8 bytes starting at hl,
; which represent the following:
;   x position, y position, y displacement between items, number of items,
;   cursor tile number, tile behind cursor, ???? (unknown function pointer if non-0)
; also sets the current menu item to the one specified in register a
InitializeCursorParameters: ; 2636 (0:2636)
	ld [wCurMenuItem], a
	ldh [hCurrentMenuItem], a
	ld de, wCursorXPosition
	ld b, $8
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	xor a
	ld [wCursorBlinkCounter], a
	ret

; returns with the carry flag set if A or B were pressed
; returns a = 0 if A was pressed, a = -1 if B was pressed
HandleMenuInput: ; 264b (0:264b)
	xor a
	ld [wRefreshMenuCursorSFX], a
	ldh a, [hButtonsPressed2]
	or a
	jr z, .up_down_done
	ld b, a
	ld a, [wNumMenuItems]
	ld c, a
	ld a, [wCurMenuItem]
	bit D_UP_F, b
	jr z, .not_up
	dec a
	bit 7, a
	jr z, .handle_up_or_down
	ld a, [wNumMenuItems]
	dec a ; wrapping around, so load the bottommost item
	jr .handle_up_or_down
.not_up
	bit D_DOWN_F, b
	jr z, .up_down_done
	inc a
	cp c
	jr c, .handle_up_or_down
	xor a ; wrapping around, so load the topmost item
.handle_up_or_down
	push af
	ld a, $1
	ld [wRefreshMenuCursorSFX], a ; buffer sound for up/down
	call EraseCursor
	pop af
	ld [wCurMenuItem], a
	xor a
	ld [wCursorBlinkCounter], a
.up_down_done
	ld a, [wCurMenuItem]
	ldh [hCurrentMenuItem], a
	ld hl, wcd17
	ld a, [hli]
	or [hl]
	jr z, .check_A_or_B
	ld a, [hld]
	ld l, [hl]
	ld h, a
	ldh a, [hCurrentMenuItem]
	call CallHL
	jr nc, RefreshMenuCursor_CheckPlaySFX
.A_pressed_draw_cursor
	call DrawCursor2
.A_pressed
	call PlayOpenOrExitScreenSFX
	ld a, [wCurMenuItem]
	ld e, a
	ldh a, [hCurrentMenuItem]
	scf
	ret
.check_A_or_B
	ldh a, [hButtonsPressed]
	and A_BUTTON | B_BUTTON
	jr z, RefreshMenuCursor_CheckPlaySFX
	and A_BUTTON
	jr nz, HandleMenuInput.A_pressed_draw_cursor
	; b button pressed
	ld a, [wCurMenuItem]
	ld e, a
	ld a, $ff
	ldh [hCurrentMenuItem], a
	call PlayOpenOrExitScreenSFX
	scf
	ret

; plays an "open screen" sound if [hCurrentMenuItem] != 0xff
; plays a "exit screen" sound if [hCurrentMenuItem] == 0xff
PlayOpenOrExitScreenSFX: ; 26c0 (0:26c0)
	push af
	ldh a, [hCurrentMenuItem]
	inc a
	jr z, .play_exit_sfx
	ld a, $2
	jr .play_sfx
.play_exit_sfx
	ld a, $3
.play_sfx
	call PlaySFX
	pop af
	ret

RefreshMenuCursor_CheckPlaySFX: ; 26d1 (0:26d1)
	ld a, [wRefreshMenuCursorSFX]
	or a
	jr z, RefreshMenuCursor
	call PlaySFX
;	fallthrough
RefreshMenuCursor: ; 26da (0:26da)
	ld hl, wCursorBlinkCounter
	ld a, [hl]
	inc [hl]
; blink the cursor every 16 frames
	and $f
	ret nz
	ld a, [wCursorTileNumber]
	bit 4, [hl]
	jr z, DrawCursor
EraseCursor: ; 26e9 (0:26e9)
	ld a, [wTileBehindCursor]
DrawCursor:
	ld c, a
	ld a, [wYDisplacementBetweenMenuItems]
	ld l, a
	ld a, [wCurMenuItem]
	ld h, a
	call HtimesL
	ld a, l
	ld hl, wCursorXPosition
	ld d, [hl]
	inc hl
	add [hl]
	ld e, a
	call AdjustCoordinatesForWindow
	ld a, c
	ld c, e
	ld b, d
	call Func_06c3
	or a
	ret

; unlike DrawCursor, read cursor tile from wCursorTileNumber instead of register a
DrawCursor2: ; 270b (0:270b)
	ld a, [wCursorTileNumber]
	jr DrawCursor

SetMenuItem: ; 2710 (0:2710)
	ld [wCurMenuItem], a
	ldh [hCurrentMenuItem], a
	xor a
	ld [wCursorBlinkCounter], a
	ret

Func_271a: ; 271a (0:271a)
	ldh a, [hButtonsPressed2]
	or a
	jr z, .asm_2764
	ld b, a
	ld hl, wCurMenuItem
	and $c0
	jr z, .asm_272c
	ld a, [hl]
	xor $1
	jr .asm_2748
.asm_272c
	bit D_LEFT_F, b
	jr z, .asm_273b
	ld a, [hl]
	sub $2
	jr nc, .asm_2748
	and $1
	add $4
	jr .asm_2748
.asm_273b
	bit D_RIGHT_F, b
	jr z, .asm_275d
	ld a, [hl]
	add $2
	cp $6
	jr c, .asm_2748
	and $1
.asm_2748
	push af
	ld a, $1
	call PlaySFX
	call .asm_2772
	pop af
	ld [wCurMenuItem], a
	ldh [hCurrentMenuItem], a
	xor a
	ld [wCursorBlinkCounter], a
	jr .asm_2764
.asm_275d
	ldh a, [hButtonsPressed2]
	and A_BUTTON
	jp nz, HandleMenuInput.A_pressed
.asm_2764
	ld hl, wCursorBlinkCounter
	ld a, [hl]
	inc [hl]
	and $f
	ret nz
	ld a, $f
	bit 4, [hl]
	jr z, .asm_2774
.asm_2772
	ld a, $0
.asm_2774
	ld e, a
	ld a, [wCurMenuItem]
	add a
	ld c, a
	ld b, $0
	ld hl, $278d
	add hl, bc
	ld b, [hl]
	inc hl
	ld c, [hl]
	ld a, e
	call Func_06c3
	ld a, [wCurMenuItem]
	ld e, a
	or a
	ret
; 0x278d

	INCROM $278d, $29f5

Func_29f5: ; 29f5 (0:29f5)
	farcallx $6, $4000
	ret
; 0x29fa

Func_29fa: ; 29fa (0:29fa)
	lb bc, $0f, $00 ; cursor tile, tile behind cursor
	call SetCursorParametersForTextBox
WaitForButtonAorB: ; 2a00 (0:2a00)
	call DoFrame
	call RefreshMenuCursor
	ldh a, [hButtonsPressed]
	bit A_BUTTON_F, a
	jr nz, .a_pressed
	bit B_BUTTON_F, a
	jr z, WaitForButtonAorB
	call EraseCursor
	scf
	ret
.a_pressed
	call EraseCursor
	or a
	ret

SetCursorParametersForTextBox: ; 2a1a (0:2a1a)
	xor a
	ld hl, wCurMenuItem
	ld [hli], a
	ld [hl], d ; wCursorXPosition
	inc hl
	ld [hl], e ; wCursorYPosition
	inc hl
	ld [hl], 0 ; wYDisplacementBetweenMenuItems
	inc hl
	ld [hl], 1 ; wNumMenuItems
	inc hl
	ld [hl], b ; wCursorTileNumber
	inc hl
	ld [hl], c ; wTileBehindCursor
	ld [wCursorBlinkCounter], a
	ret
; 0x2a30

Func_2a30: ; 2a30 (0:2a30)
	call DrawWideTextBox_PrintTextNoDelay
	jp WaitForWideTextBoxInput
; 0x2a36

DrawWideTextBox_PrintTextNoDelay: ; 2a36 (0:2a36)
	push hl
	call DrawWideTextBox
	ld a, $13
	jr Func_2a44

DrawNarrowTextBox_PrintTextNoDelay: ; 2a3e (0:2a3e)
	push hl
	call DrawNarrowTextBox
	ld a, $b
;	fallthrough

Func_2a44: ; 2a44 (0:2a44)
	lb de, 1, 14
	call AdjustCoordinatesForWindow
	call Func_22a6
	pop hl
	ld a, l
	or h
	jp nz, PrintTextNoDelay
	ld hl, wc590
	jp Func_21c5

DrawWideTextBox_PrintText: ; 2a59 (0:2a59)
	push hl
	call DrawWideTextBox
	ld a, $13
	lb de, 1, 14
	call AdjustCoordinatesForWindow
	call Func_22a6
	call EnableLCD
	pop hl
	jp PrintText

; draws a 12x6 text box aligned to the bottom left of the screen
DrawNarrowTextBox: ; 2a6f (0:2a6f)
	lb de, 0, 12
	lb bc, 12, 6
	call AdjustCoordinatesForWindow
	call DrawRegularTextBox
	ret

DrawNarrowTextBox_WaitForInput: ; 2a7c (0:2a7c)
	call DrawNarrowTextBox_PrintTextNoDelay
	xor a
	ld hl, NarrowTextBoxPromptCursorData
	call InitializeCursorParameters
	call EnableLCD
.wait_A_or_B_loop
	call DoFrame
	call RefreshMenuCursor
	ldh a, [hButtonsPressed]
	and A_BUTTON | B_BUTTON
	jr z, .wait_A_or_B_loop
	ret

NarrowTextBoxPromptCursorData: ; 2a96 (0:2a96)
	db 10, 17 ; x, y
	db 1 ; y displacement between items
	db 1 ; number of items
	db $2f ; cursor tile number
	db $1d ; tile behind cursor
	dw $0000 ; unknown function pointer if non-0

; draws a 20x6 text box aligned to the bottom of the screen
DrawWideTextBox: ; 2a9e (0:2a9e)
	lb de, 0, 12
	lb bc, 20, 6
	call AdjustCoordinatesForWindow
	call DrawRegularTextBox
	ret

DrawWideTextBox_WaitForInput: ; 2aab (0:2aab)
	call DrawWideTextBox_PrintText
;	fallthrough
WaitForWideTextBoxInput: ; 2aae (0:2aae)
	xor a
	ld hl, WideTextBoxPromptCursorData
	call InitializeCursorParameters
	call EnableLCD
.wait_A_or_B_loop
	call DoFrame
	call RefreshMenuCursor
	ldh a, [hButtonsPressed]
	and A_BUTTON | B_BUTTON
	jr z, .wait_A_or_B_loop
	call EraseCursor
	ret

WideTextBoxPromptCursorData: ; 2ac8 (0:2ac8)
	db 18, 17 ; x, y
	db 1 ; y displacement between items
	db 1 ; number of items
	db $2f ; cursor tile number
	db $1d ; tile behind cursor
	dw $0000 ; unknown function pointer if non-0

TwoItemHorizontalMenu: ; 2ad0 (0:2ad0)
	call DrawWideTextBox_PrintText
	lb de, 6, 16 ; x, y
	ld a, d
	ld [wLeftmostItemCursorX], a
	lb bc, $0f, $00 ; cursor tile, tile behind cursor
	call SetCursorParametersForTextBox
	ld a, 1
	ld [wCurMenuItem], a
	call EnableLCD
	jp HandleYesOrNoMenu.refresh_menu
; 0x2aeb

Func_2aeb: ; 2aeb (0:2aeb)
	ld a, $01
	ld [wcd9a], a
;	fallthrough

; handle a yes / no menu with custom text provided in hl
; returns carry if "no" selected
YesOrNoMenuWithText: ; 2af0 (0:2af0)
	call DrawWideTextBox_PrintText
;	fallthrough
YesOrNoMenu: ; 2af3 (0:2af3)
	lb de, 7, 16 ; x, y
	call PrintYesOrNoItems
	lb de, 6, 16 ; x, y
	jr HandleYesOrNoMenu

YesOrNoMenuWithText_LeftAligned: ; 2afe (0:2afe)
	call DrawNarrowTextBox_PrintTextNoDelay
	lb de, 3, 16 ; x, y
	call PrintYesOrNoItems
	lb de, 2, 16 ; x, y
;	fallthrough
HandleYesOrNoMenu:
	ld a, d
	ld [wLeftmostItemCursorX], a
	lb bc, $0f, $00 ; cursor tile, tile behind cursor
	call SetCursorParametersForTextBox
	ld a, [wcd9a]
	ld [wCurMenuItem], a
	call EnableLCD
	jr .refresh_menu
.wait_button_loop
	call DoFrame
	call RefreshMenuCursor
	ldh a, [hButtonsPressed]
	bit A_BUTTON_F, a
	jr nz, .a_pressed
	ldh a, [hButtonsPressed2]
	and D_RIGHT | D_LEFT
	jr z, .wait_button_loop
	; left or right pressed, so switch to the other menu item
	ld a, $1
	call PlaySFX
	call EraseCursor
.refresh_menu
	ld a, [wLeftmostItemCursorX]
	ld c, a
	; default to the second option (NO)
	ld hl, wCurMenuItem
	ld a, [hl]
	xor $1
	ld [hl], a
	; x separation between left and right items is 4 tiles
	add a
	add a
	add c
	ld [wCursorXPosition], a
	xor a
	ld [wCursorBlinkCounter], a
	jr .wait_button_loop
.a_pressed
	ld a, [wCurMenuItem]
	ldh [hCurrentMenuItem], a
	or a
	jr nz, .no
;.yes
	ld [wcd9a], a ; 0
	ret
.no
	xor a
	ld [wcd9a], a ; 0
	ld a, $1
	ldh [hCurrentMenuItem], a
	scf
	ret

; prints YES NO at de
PrintYesOrNoItems: ; 2b66 (0:2b66)
	call AdjustCoordinatesForWindow
	ldtx hl, YesOrNoText
	call Func_2c1b
	ret
; 0x2b70

	INCROM $2b70, $2b78

; loads opponent deck to wOpponentDeck
LoadOpponentDeck: ; 2b78 (0:2b78)
	xor a
	ld [wIsPracticeDuel], a
	ld a, [wOpponentDeckId]
	cp SAMS_NORMAL_DECK - 2
	jr z, .normal_sam_duel
	or a ; cp SAMS_PRACTICE_DECK - 2
	jr nz, .not_practice_duel

; only practice duels will display help messages, but
; any duel with Sam will force the PRACTICE_PLAYER_DECK
;.practice_sam_duel
	inc a
	ld [wIsPracticeDuel], a

.normal_sam_duel
	xor a
	ld [wOpponentDeckId], a
	call SwapTurn
	ld a, PRACTICE_PLAYER_DECK
	call LoadDeck
	call SwapTurn
	ld hl, wRNG1
	ld a, $57
	ld [hli], a
	ld [hli], a
	ld [hl], a
	xor a

.not_practice_duel
	inc a
	inc a
	call LoadDeck
	ld a, [wOpponentDeckId]
	cp DECKS_END
	jr c, .valid_deck
	ld a, PRACTICE_PLAYER_DECK - 2
	ld [wOpponentDeckId], a

.valid_deck
; set opponent as controlled by AI
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld a, [wOpponentDeckId]
	or DUELIST_TYPE_AI_OPP
	ld [hl], a
	ret

Func_2bbf: ; 2bbf (0:2bbf)
	ld a, $1
	jr Func_2bdb

Func_2bc3: ; 2bc3 (0:2bc3)
	ld a, $2
	jr Func_2bdb

Func_2bc7: ; 2bc7 (0:2bc7)
	ld a, $3
	call Func_2bdb
	ld [$ff9d], a
	ret

Func_2bcf: ; 2bcf (0:2bcf)
	ld a, $4
	call Func_2bdb
	ld [$ffa0], a
	ret

Func_2bd7: ; 2bd7 (0:2bd7)
	ld a, $5
	jr Func_2bdb

Func_2bdb: ; 2bdb (0:2bdb)
	ld c, a
	ldh a, [hBankROM]
	push af
	ld a, $5
	call BankswitchHome
	ld a, [wOpponentDeckId]
	ld l, a
	ld h, $0
	add hl, hl
	ld de, $4000
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, c
	or a
	jr nz, .asm_2bfe
	ld e, [hl]
	inc hl
	ld d, [hl]
	call CopyDeckData
	jr .asm_2c01
.asm_2bfe
	call JumpToFunctionInTable
.asm_2c01
	ld c, a
	pop af
	call BankswitchHome
	ld a, c
	ret

Func_2c08: ; 2c08 (0:2c08)
	ld d, [hl]
	inc hl
	bit 7, d
	ret nz
	ld e, [hl]
	inc hl
	call Func_22ae
	push hl
	call Func_2c23
	pop hl
	inc hl
	inc hl
	jr Func_2c08

Func_2c1b: ; 2c1b (0:2c1b)
	call Func_22ae
	jr Func_2c29

Func_2c20: ; 2c20 (0:2c20)
	call Func_22ae
Func_2c23: ; 2c23 (0:2c23)
	ld a, [hli]
	or [hl]
	ret z
	ld a, [hld]
	ld l, [hl]
	ld h, a
Func_2c29: ; 2c29 (0:2c29)
	ldh a, [hBankROM]
	push af
	call ReadTextOffset
	call Func_21c5
	pop af
	call BankswitchHome
	ret
; 0x2c37

	INCROM $2c37, $2c73

Func_2c73: ; 2c73 (0:2c73)
	xor a
	call Func_2c84

Func_2c77: ; 2c77 (0:2c77)
	lb bc, $2f, $1d ; cursor tile, tile behind cursor
	lb de, 18, 17 ; x, y
	call SetCursorParametersForTextBox
	call WaitForButtonAorB
	ret

Func_2c84: ; 2c84 (0:2c84)
	ld [wce4b], a
	ldh a, [hBankROM]
	push af
	call ReadTextOffset
	call Func_2d15
	call Func_2cc8
.asm_2c93
	ld a, [wTextSpeed]
	ld c, a
	inc c
	jr .asm_2cac
.asm_2c9a
	ld a, [wTextSpeed]
	cp $2
	jr nc, .asm_2ca7
	ldh a, [hButtonsHeld]
	and B_BUTTON
	jr nz, .asm_2caf
.asm_2ca7
	push bc
	call DoFrame
	pop bc
.asm_2cac
	dec c
	jr nz, .asm_2c9a
.asm_2caf
	call Func_2d43
	jr c, .asm_2cc3
	ld a, [wcd09]
	cp $3
	jr c, .asm_2c93
	call Func_2c77
	call Func_2d15
	jr .asm_2c93
.asm_2cc3
	pop af
	call BankswitchHome
	ret

Func_2cc8: ; 2cc8 (0:2cc8)
	xor a
	ld [wce48], a
	ld [wce49], a
	ld [wce4a], a
	ld a, $f
	ld [hffaf], a
Func_2cd7: ; 2cd7 (0:2cd7)
	push hl
	call Func_2d06
	pop bc
	ld a, [hffaf]
	ld [hli], a
	ld a, [wcd0a]
	ld [hli], a
	ldh a, [hBankROM]
	ld [hli], a
	ld [hl], c
	inc hl
	ld [hl], b
	ret

Func_2ceb: ; 2ceb (0:2ceb)
	call Func_2cd7
	ld hl, $ce48
	inc [hl]
	ret

Func_2cf3: ; 2cf3 (0:2cf3)
	call Func_2d06
	ld a, [hli]
	ld [hffaf], a
	ld a, [hli]
	ld [wcd0a], a
	ld a, [hli]
	call BankswitchHome
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Func_2d06: ; 2d06 (0:2d06)
	ld a, [wce48]
	ld e, a
	add a
	add a
	add e
	ld e, a
	ld d, $0
	ld hl, $ce2b
	add hl, de
	ret

Func_2d15: ; 2d15 (0:2d15)
	push hl
	lb de, 0, 12
	lb bc, 20, 6
	call AdjustCoordinatesForWindow
	ld a, [wce4b]
	or a
	jr nz, .asm_2d2d
	call DrawRegularTextBox
	call EnableLCD
	jr .asm_2d36
.asm_2d2d
	ld hl, $ce4c
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DrawLabeledTextBox
.asm_2d36
	lb de, 1, 14
	call AdjustCoordinatesForWindow
	ld a, $13
	call Func_22a6
	pop hl
	ret

Func_2d43: ; 2d43 (0:2d43)
	call Func_2cf3
	ld a, [hli]
	or a
	jr z, .asm_2d79
	cp $5
	jr c, .asm_2d65
	cp $10
	jr nc, .asm_2d65
	call Func_21f2
	jr nc, .asm_2d74
	cp TX_RAM1
	jr z, .asm_2dc8
	cp TX_RAM2
	jr z, .asm_2d8a
	cp TX_RAM3
	jr z, .asm_2db3
	jr .asm_2d74
.asm_2d65
	ld e, a
	ld d, [hl]
	call Func_2546
	jr nc, .asm_2d6d
	inc hl
.asm_2d6d
	call Func_22ca
	xor a
	call Func_21f2
.asm_2d74
	call Func_2cd7
	or a
	ret
.asm_2d79
	ld a, [wce48]
	or a
	jr z, .asm_2d85
	dec a
	ld [wce48], a
	jr Func_2d43
.asm_2d85
	call Func_230f
	scf
	ret
.asm_2d8a
	call Func_2ceb
	ld a, $f
	ld [hffaf], a
	xor a
	ld [wcd0a], a
	ld de, $ce3f
	ld hl, $ce49
	call Func_2de0
	ld a, l
	or h
	jr z, .asm_2dab
	call ReadTextOffset
	call Func_2cd7
	jr Func_2d43
.asm_2dab
	ld hl, wc590
	call Func_2cd7
	jr Func_2d43
.asm_2db3
	call Func_2ceb
	ld de, $ce43
	ld hl, $ce4a
	call Func_2de0
	call Func_2e12
	call Func_2cd7
	jp Func_2d43
.asm_2dc8
	call Func_2ceb
	call Func_2e2c
	ld a, [wcaa0]
	cp $6
	jr z, .asm_2dda
	ld a, $7
	call Func_21f2
.asm_2dda
	call Func_2cd7
	jp Func_2d43

Func_2de0: ; 2de0 (0:2de0)
	push de
	ld a, [hl]
	inc [hl]
	add a
	ld e, a
	ld d, $0
	pop hl
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

; uses the two byte text id in hl to read the three byte text offset
; loads the correct bank for the specific text and returns the pointer in hl
ReadTextOffset: ; 2ded (0:2ded)
	push de
	ld e, l
	ld d, h
	add hl, hl
	add hl, de
	set 6, h ; hl = (hl * 3) + $4000
	ld a, BANK(TextOffsets)
	call BankswitchHome
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [hl]
	ld h, d
	rl h
	rla
	rl h
	rla
	add BANK(TextOffsets)
	call BankswitchHome
	res 7, d
	set 6, d ; $4000 ≤ de ≤ $7fff
	ld l, e
	ld h, d
	pop de
	ret

Func_2e12: ; 2e12 (0:2e12)
	ld a, [wcd0a]
	or a
	jp z, Func_245d
	ld de, wcaa0
	push de
	call Func_0663
	pop hl
	ld c, $4
.asm_2e23
	ld a, [hl]
	cp $30
	ret nz
	inc hl
	dec c
	jr nz, .asm_2e23
	ret

Func_2e2c: ; 2e2c (0:2e2c)
	ld de, wcaa0
	push de
	ldh a, [hWhoseTurn]
	cp OPPONENT_TURN
	jp z, .opponent_turn
	call PrintPlayerName
	pop hl
	ret
.opponent_turn
	call PrintOpponentName
	pop hl
	ret

; prints text with id at hl with letter delay in a textbox area
PrintText: ; 2e41 (0:2e41)
	ld a, l
	or h
	jr z, .from_ram
	ldh a, [hBankROM]
	push af
	call ReadTextOffset
	call .print_text
	pop af
	call BankswitchHome
	ret
.from_ram
	ld hl, wc590
.print_text
	call Func_2cc8
.next_tile_loop
	ldh a, [hButtonsHeld]
	ld b, a
	ld a, [wTextSpeed]
	inc a
	cp $3
	jr nc, .apply_delay
	; if text speed is 1, pressing b ignores it
	bit B_BUTTON_F, b
	jr nz, .skip_delay
	jr .apply_delay
.text_delay_loop
	; wait a number of frames equal to wTextSpeed between printing each text tile
	call DoFrame
.apply_delay
	dec a
	jr nz, .text_delay_loop
.skip_delay
	call Func_2d43
	jr nc, .next_tile_loop
	ret

; prints text with id at hl without letter delay in a textbox area
PrintTextNoDelay: ; 2e76 (0:2e76)
	ldh a, [hBankROM]
	push af
	call ReadTextOffset
	call Func_2cc8
.next_tile_loop
	call Func_2d43
	jr nc, .next_tile_loop
	pop af
	call BankswitchHome
	ret

; Prints a name in the left side of the top border of a text box, usually to identify the talked-to NPC.
; input:
	; hl: text id
	; de: where to print the name
PrintTextBoxBorderLabel: ; 2e89 (0:2e89)
	ld a, l
	or h
	jr z, .special
	ldh a, [hBankROM]
	push af
	call ReadTextOffset
.next_tile_loop
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, .next_tile_loop
	pop af
	call BankswitchHome
	dec de
	ret
.special
	ldh a, [hWhoseTurn]
	cp OPPONENT_TURN
	jp z, PrintOpponentName
	jp PrintPlayerName
; 0x2ea9

	INCROM $2ea9, $2ebb

Func_2ebb: ; 2ebb (0:2ebb)
	ld a, l
	ld [wce3f], a
	ld a, h
	ld [wce40], a
	ret

Func_2ec4: ; 2ec4 (0:2ec4)
	ld a, l
	ld [wce43], a
	ld a, h
	ld [wce44], a
	ret
; 0x2ecd

	INCROM $2ecd, $2f0a

; load data of card with id at e to wLoadedCard1 or wLoadedCard2
LoadCardDataToBuffer2: ; 2f0a (0:2f0a)
	push hl
	ld hl, wLoadedCard2
	jr LoadCardDataToRAM

LoadCardDataToBuffer1: ; 2f10 (0:2f10)
	push hl
	ld hl, wLoadedCard1

LoadCardDataToRAM: ; 2f14 (0:2f14)
	push de
	push bc
	push hl
	call GetCardPointer
	pop de
	jr c, .done
	ld a, BANK(CardPointers)
	call BankpushHome2
	ld b, PKMN_CARD_DATA_LENGTH
.copy_card_data_loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_card_data_loop
	call BankpopHome
	or a

.done
	pop bc
	pop de
	pop hl
	ret

Func_2f32: ; 2f32 (0:2f32)
	push hl
	call GetCardPointer
	jr c, .asm_2f43
	ld a, $c
	call BankpushHome2
	ld l, [hl]
	call BankpopHome
	ld a, l
	or a
.asm_2f43
	pop hl
	ret

Func_2f45: ; 2f45 (0:2f45)
	push hl
	call GetCardPointer
	jr c, .asm_2f5b
	ld a, $c
	call BankpushHome2
	ld de, $0003
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	call BankpopHome
	or a

.asm_2f5b
	pop hl
	ret

; from the card id in a, loads type into a, rarity into b, and set into c
GetCardHeader: ; 2f5d (0:2f5d)
	push hl
	push de
	ld d, $00
	ld e, a
	call GetCardPointer
	jr c, .card_not_found
	ld a, $0c
	call BankpushHome2
	ld e, [hl]
	ld bc, $5
	add hl, bc
	ld b, [hl]
	inc hl
	ld c, [hl]
	call BankpopHome
	ld a, e
	or a
.card_not_found
	pop de
	pop hl
	ret

; return at hl the pointer to the data of the card with id at e
; return carry if e was out of bounds, so no pointer was returned
GetCardPointer: ; 2f7c (0:2f7c)
	push de
	push bc
	ld l, e
	ld h, $0
	add hl, hl
	ld bc, CardPointers
	add hl, bc
	ld a, h
	cp a, (CardPointers + 2 + (2 * NUM_CARDS)) / $100
	jr nz, .nz
	ld a, l
	cp a, (CardPointers + 2 + (2 * NUM_CARDS)) % $100
.nz
	ccf
	jr c, .out_of_bounds
	ld a, BANK(CardPointers)
	call BankpushHome2
	ld a, [hli]
	ld h, [hl]
	ld l,a
	call BankpopHome
	or a
.out_of_bounds
	pop bc
	pop de
	ret

LoadCardGfx: ; 2fa0 (0:2fa0)
	ldh a, [hBankROM]
	push af
	push hl
	srl h
	srl h
	srl h
	ld a, BANK(CardGraphics)
	add h
	call BankswitchHome
	pop hl
	add hl, hl
	add hl, hl
	add hl, hl
	res 7, h
	set 6, h
	call CopyGfxData
	ld b, CGB_PAL_SIZE
	ld de, $ce23
.copy_card_palette
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_card_palette
	pop af
	call BankswitchHome
	ret

Func_2fcb: ; 2fcb (0:2fcb)
	ld a, $1d
	call BankpushHome
	ld c, TILE_SIZE
	call CopyGfxData
	call BankpopHome
	ret

; Checks if the command type at a is one of the commands of the move or card effect currently in use,
; and executes its associated function if so.
; input:
; a = command type to check
; [wLoadedMoveEffectCommands] = pointer to list of commands of current move or trainer card
TryExecuteEffectCommandFunction: ; 2fd9 (0:2fd9)
	push af
; grab pointer to command list from wLoadedMoveEffectCommands
	ld hl, wLoadedMoveEffectCommands
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	call CheckMatchingCommand
	jr nc, .execute_function
; return if no matching command was found
	or a
	ret

.execute_function
; executes the function at [wce22]:hl
	ldh a, [hBankROM]
	push af
	ld a, [wce22]
	call BankswitchHome
	or a
	call CallHL
	push af
; restore original bank and return
	pop bc
	pop af
	call BankswitchHome
	push bc
	pop af
	ret

; input:
  ; a = command type to check
  ; hl = list of commands of current move or trainer card
; return nc if command type matching a is found, c otherwise
CheckMatchingCommand: ; 2ffe (0:2ffe)
	ld c, a
	ld a, l
	or h
	jr nz, .not_null_pointer
; return c if pointer is $0000
	scf
	ret

.not_null_pointer
	ldh a, [hBankROM]
	push af
	ld a, BANK(EffectCommands)
	call BankswitchHome
; store the bank number of command functions ($b) in wce22
	ld a, $b
	ld [wce22],a
.check_command_loop
	ld a, [hli]
	or a
	jr z, .no_more_commands
	cp c
	jr z, .matching_command_found
; skip function pointer for this command and move to the next one
	inc hl
	inc hl
	jr .check_command_loop

.matching_command_found
; load function pointer for this command
	ld a, [hli]
	ld h, [hl]
	ld l, a
; restore bank and return nc
	pop af
	call BankswitchHome
	or a
	ret
; restore bank and return c
.no_more_commands
	pop af
	call BankswitchHome
	scf
	ret

; loads the deck id in a from DeckPointers
; sets carry flag if an invalid deck id is used
LoadDeck: ; 302c (0:302c)
	push hl
	ld l, a
	ld h, $0
	ldh a, [hBankROM]
	push af
	ld a, BANK(DeckPointers)
	call BankswitchHome
	add hl, hl
	ld de, DeckPointers
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, d
	or e
	jr z, .null_pointer
	call CopyDeckData
	pop af
	call BankswitchHome
	pop hl
	or a
	ret
.null_pointer
	pop af
	call BankswitchHome
	pop hl
	scf
	ret

Func_3055: ; 3055 (0:3055)
	push hl
	ld hl, wDamage
	add [hl]
	ld [hli], a
	ld a, $0
	adc [hl]
	ld [hl], a
	pop hl
	ret

Func_3061: ; 3061 (0:3061)
	push de
	push hl
	ld e, a
	ld hl, wDamage
	ld a, [hl]
	sub e
	ld [hli], a
	ld a, [hl]
	sbc $0
	ld [hl], a
	pop hl
	pop de
	ret

; function that executes one or more consecutive coin tosses during a duel (a = number of coin tosses),
; displaying each result ([O] or [X]) starting from the top left corner of the screen.
; text at de is printed in a text box during the coin toss.
;   returns: the number of heads in a and in $cd9d, and carry if at least one heads
TossCoinATimes: ; 3071 (0:3071)
	push hl
	ld hl, wCoinTossScreenTextId
	ld [hl], e
	inc hl
	ld [hl], d
	bank1call _TossCoin
	pop hl
	ret

; function that executes a single coin toss during a duel.
; text at de is printed in a text box during the coin toss.
;   returns: - carry, and 1 in a and in $cd9d if heads
;            - nc, and 0 in a and in $cd9d if tails
TossCoin: ; 307d (0:307d)
	push hl
	ld hl, wCoinTossScreenTextId
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $1
	bank1call _TossCoin
	ld hl, $cac2
	ld [hl], $0
	pop hl
	ret

CompareDEtoBC: ; 3090 (0:3090)
	ld a, d
	cp b
	ret nz
	ld a, e
	cp c
	ret

Func_3096: ; 3096 (0:3096)
	ldh a, [hBankROM]
	push af
	ld a, $2
	call BankswitchHome
	call $4000
	pop af
	call BankswitchHome
	ret

Func_30a6: ; 30a6 (0:30a6)
	ldh a, [hBankROM]
	push af
	ld a, $6
	call BankswitchHome
	ld a, $1
	ld [wce60], a
	call $40d5
	pop bc
	ld a, b
	call BankswitchHome
	ret

Func_30bc: ; 30bc (0:30bc)
	ld a, h
	ld [wce50], a
	ld a, l
	ld [wce51], a
	ldh a, [hBankROM]
	push af
	ld a, $2
	call BankswitchHome
	call $4211
	call DrawWideTextBox
	pop af
	call BankswitchHome
	ret

Func_30d7: ; 30d7 (0:30d7)
	ldh a, [hBankROM]
	push af
	ld a, $2
	call BankswitchHome
	call $433c
	pop af
	call BankswitchHome
	ret

Func_30e7: ; 30e7 (0:30e7)
	ldh a, [hBankROM]
	push af
	ld a, $2
	call BankswitchHome
	call $4764
	ld b, a
	pop af
	call BankswitchHome
	ld a, b
	ret

Func_30f9: ; 30f9 (0:30f9)
	ld b, a
	ldh a, [hBankROM]
	push af
	ld a, $2
	call BankswitchHome
	call $4932
	pop af
	call BankswitchHome
	ret

Func_310a: ; 310a (0:310a)
	ld [wce59], a
	ldh a, [hBankROM]
	push af
	ld a, $2
	call BankswitchHome
	call $4aaa
	pop af
	call BankswitchHome
	ret

Func_311d: ; 311d (0:311d)
	ldh a, [hBankROM]
	push af
	ld a, $2
	call BankswitchHome
	call $4b85
	pop af
	call BankswitchHome
	ret

Func_312d: ; 312d (0:312d)   ; serial transfer-related
	push hl
	ld hl, $ce64
	ld a, $88
	ld [hli], a          ; [wce64] ← $88
	ld a, $33
	ld [hli], a          ; [wce65] ← $33
	ld [hl], d           ; [wce66] ← d
	inc hl
	ld [hl], e           ; [wce67] ← e
	inc hl
	ld [hl], c           ; [wce68] ← c
	inc hl
	ld [hl], b           ; [wce69] ← b
	inc hl
	pop de
	ld [hl], e           ; [wce6a] ← l
	inc hl
	ld [hl], d           ; [wce6b] ← h
	inc hl
	ld de, $ff45
	ld [hl], e           ; [wce6c] ← $45
	inc hl
	ld [hl], d           ; [wce6d] ← $ff
	ld hl, $ce70
	ld [hl], $64         ; [wce70] ← $64
	inc hl
	ld [hl], $ce         ; [wce71] ← $ce
	call Func_0e8e
	ld a, $1
	ld [wce63], a        ; [wce63] ← 1
	call Func_31fc
.asm_315d
	call DoFrame
	ld a, [wce63]
	or a
	jr nz, .asm_315d
	call ResetSerial
	ld bc, $05dc
.asm_316c
	dec bc
	ld a, b
	or c
	jr nz, .asm_316c
	ld a, [wce6e]
	cp $81
	jr nz, .asm_3182
	ld a, [wce6f]
	ld l, a
	and $f1
	ld a, l
	ret z
	scf
	ret
.asm_3182
	ld a, $ff
	ld [wce6f], a
	scf
	ret

Func_3189: ; 3189 (0:3189)
	ld hl, PointerTable_3190
	dec a
	jp JumpToFunctionInTable

PointerTable_3190: ; 3190 (0:3190)
	dw Func_31a8
	dw Func_31a8
	dw Func_31a8
	dw Func_31a8
	dw Func_31a8
	dw Func_31b0
	dw Func_31ca
	dw Func_31dd
	dw Func_31e5
	dw Func_31ef
	dw Func_31ea
	dw Func_31f2

Func_31a8: ; 31a8 (0:31a8)
	call Func_31fc
Func_31ab: ; 31ab (0:31ab)
	ld hl, $ce63
	inc [hl]
	ret

Func_31b0: ; 31b0 (0:31b0)
	call Func_31ab
	ld hl, $ce68
	ld a, [hli]
	or [hl]
	jr nz, .asm_31bf
	call Func_31ab
	jr Func_31dd
.asm_31bf
	ld hl, $ce6a
	ld de, $ce70
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

Func_31ca: ; 31ca (0:31ca)
	call Func_31fc
	ld hl, $ce68
	ld a, [hl]
	dec [hl]
	or a
	jr nz, .asm_31d8
	inc hl
	dec [hl]
	dec hl
.asm_31d8
	ld a, [hli]
	or [hl]
	jr z, Func_31ab
	ret

Func_31dd: ; 31dd (0:31dd)
	ld a, [wce6c]
Func_31e0: ; 31e0 (0:31e0)
	call Func_3212
	jr Func_31ab

Func_31e5: ; 31e5 (0:31e5)
	ld a, [wce6d]
	jr Func_31e0

Func_31ea: ; 31ea (0:31ea)
	ld a, [rSB]
	ld [wce6e], a
Func_31ef: ; 31ef (0:31ef)
	xor a
	jr Func_31e0

Func_31f2: ; 31f2 (0:31f2)
	ld a, [rSB]
	ld [wce6f], a
	xor a
	ld [wce63], a
	ret

Func_31fc: ; 31fc (0:31fc)
	ld hl, $ce70
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ld e, a
	ld hl, $ce6c
	add [hl]
	ld [hli], a
	ld a, $0
	adc [hl]
	ld [hl], a
	ld a, e
;	fallthrough
Func_3212: ; 3212 (0:3212)
	ld [rSB], a
	ld a, $1
	ld [rSC], a
	ld a, $81
	ld [rSC], a
	ret

; doubles the damage at de if swords dance or focus energy was used in the last turn
HandleDoubleDamageSubstatus: ; 321d (0:321d)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS5
	call GetTurnDuelistVariable
	bit SUBSTATUS5_THIS_TURN_DOUBLE_DAMAGE, [hl]
	call nz, DoubleDamageAtDE
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	or a
	call nz, CommentedOut_323a
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	call nz, CommentedOut_3243
	ret

CommentedOut_323a: ; 323a (0:323a)
	ret

DoubleDamageAtDE: ; 323b (0:323b)
	ld a, e
	or d
	ret z
	sla e
	rl d
	ret

CommentedOut_3243: ; 3243 (0:3243)
	ret

; check if the attacked card has any substatus that reduces the damage this turn
HandleDamageReduction: ; 3244 (0:3244)
	call HandleDamageReductionExceptSubstatus2
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetNonTurnDuelistVariable
	or a
	ret z
	cp SUBSTATUS2_REDUCE_BY_20
	jr z, .reduce_damage_by_20
	cp SUBSTATUS2_POUNCE
	jr z, .reduce_damage_by_10
	cp SUBSTATUS2_GROWL
	jr z, .reduce_damage_by_10
	ret
.reduce_damage_by_20
	ld hl, -20
	add hl, de
	ld e, l
	ld d, h
	ret
.reduce_damage_by_10
	ld hl, -10
	add hl, de
	ld e, l
	ld d, h
	ret

HandleDamageReductionExceptSubstatus2: ; 3269 (0:3269)
	ld a, [wNoDamageOrEffect]
	or a
	jr nz, .no_damage
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	or a
	jr z, .not_affected_by_substatus1
	cp SUBSTATUS1_NO_DAMAGE_STIFFEN
	jr z, .no_damage
	cp SUBSTATUS1_NO_DAMAGE_10
	jr z, .no_damage
	cp SUBSTATUS1_NO_DAMAGE_11
	jr z, .no_damage
	cp SUBSTATUS1_NO_DAMAGE_17
	jr z, .no_damage
	cp SUBSTATUS1_REDUCE_BY_10
	jr z, .reduce_damage_by_10
	cp SUBSTATUS1_REDUCE_BY_20
	jr z, .reduce_damage_by_20
	cp SUBSTATUS1_HARDEN
	jr z, .prevent_less_than_40_damage
	cp SUBSTATUS1_HALVE_DAMAGE
	jr z, .halve_damage
.not_affected_by_substatus1
	call CheckIfUnderAnyCannotUseStatus
	ret c
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	ret z
	ld a, [wTempNonTurnDuelistCardId]
	cp MR_MIME
	jr z, .prevent_less_than_30_damage ; invisible wall
	cp KABUTO
	jr z, .halve_damage2 ; kabuto armor
	ret
.no_damage
	ld de, 0
	ret
.reduce_damage_by_10
	ld hl, -10
	add hl, de
	ld e, l
	ld d, h
	ret
.reduce_damage_by_20
	ld hl, -20
	add hl, de
	ld e, l
	ld d, h
	ret
.prevent_less_than_40_damage
	ld bc, 40
	call CompareDEtoBC
	ret nc
	ld de, 0
	ret
.halve_damage
	sla d
	rr e
	bit 0, e
	ret z
	ld hl, -5
	add hl, de
	ld e, l
	ld d, h
	ret
.prevent_less_than_30_damage
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	ret z
	ld bc, 30
	call CompareDEtoBC
	ret c
	ld de, 0
	ret
.halve_damage2
	sla d
	rr e
	bit 0, e
	ret z
	ld hl, -5
	add hl, de
	ld e, l
	ld d, h
	ret
; 0x32f7

	INCROM $32f7, $33c1

; return carry if card is under a condition that makes it unable to attack
; also return in hl the text id to be displayed
HandleCantAttackSubstatus: ; 33c1 (0:33c1)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	ret z
	ldtx hl, UnableToAttackDueToTailWagText
	cp SUBSTATUS2_TAIL_WAG
	jr z, .return_with_cant_attack
	ldtx hl, UnableToAttackDueToLeerText
	cp SUBSTATUS2_LEER
	jr z, .return_with_cant_attack
	ldtx hl, UnableToAttackDueToBoneAttackText
	cp SUBSTATUS2_BONE_ATTACK
	jr z, .return_with_cant_attack
	or a
	ret
.return_with_cant_attack
	scf
	ret

; return carry if card cannot use selected move due to amnesia
HandleAmnesiaSubstatus: ; 33e1 (0:33e1)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	jr nz, .check_amnesia
	ret
.check_amnesia
	cp SUBSTATUS2_AMNESIA
	jr z, .affected_by_amnesia
.not_the_disabled_move
	or a
	ret
.affected_by_amnesia
	ld a, DUELVARS_ARENA_CARD_DISABLED_MOVE_INDEX
	call GetTurnDuelistVariable
	ld a, [wSelectedMoveIndex]
	cp [hl]
	jr nz, .not_the_disabled_move
	ldtx hl, UnableToUseAttackDueToAmnesiaText
	scf
	ret

; return carry if the attack was unsuccessful due to sand attack or smokescreen effect
HandleSandAttackOrSmokescreenSubstatus: ; 3400 (0:3400)
	call CheckSandAttackOrSmokescreenSubstatus
	ret nc
	call TossCoin
	ld [wcc0a], a
	ccf
	ret nc
	ldtx hl, AttackUnsuccessfulText
	call DrawWideTextBox_WaitForInput
	scf
	ret

; return carry if card is under the effects of sand attack or smokescreen
CheckSandAttackOrSmokescreenSubstatus: ; 3414 (0:3414)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	ret z
	ldtx de, SandAttackCheckText
	cp SUBSTATUS2_SAND_ATTACK
	jr z, .card_is_affected
	ldtx de, SmokescreenCheckText
	cp SUBSTATUS2_SMOKESCREEN
	jr z, .card_is_affected
	or a
	ret
.card_is_affected
	ld a, [wcc0a]
	or a
	ret nz
	scf
	ret

; return carry if card being attacked is under a substatus that prevents
; any damage or effect dealt to it for a turn.
; also return the cause of the substatus at wNoDamageOrEffect
HandleNoDamageOrEffectSubstatus: ; 3432 (0:3432)
	xor a
	ld [wNoDamageOrEffect], a
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	ret z
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	ld e, NO_DAMAGE_OR_EFFECT_FLY
	ldtx hl, NoDamageOrEffectDueToFlyText
	cp SUBSTATUS1_FLY
	jr z, .no_damage_or_effect
	ld e, NO_DAMAGE_OR_EFFECT_BARRIER
	ldtx hl, NoDamageOrEffectDueToBarrierText
	cp SUBSTATUS1_BARRIER
	jr z, .no_damage_or_effect
	ld e, NO_DAMAGE_OR_EFFECT_AGILITY
	ldtx hl, NoDamageOrEffectDueToAgilityText
	cp SUBSTATUS1_AGILITY
	jr z, .no_damage_or_effect
	call CheckIfUnderAnyCannotUseStatus
	ccf
	ret nc
	ld a, [wTempNonTurnDuelistCardId]
	cp MEW1
	jr z, .neutralizing_shield
	or a
	ret
.no_damage_or_effect
	ld a, e
	ld [wNoDamageOrEffect], a
	scf
	ret
.neutralizing_shield
	ld a, [wcce6]
	or a
	ret nz
	ld a, [wTempTurnDuelistCardId]
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer2
	ld a, [wLoadedCard2Stage]
	or a
	ret z
	ld e, NO_DAMAGE_OR_EFFECT_NSHIELD
	ldtx hl, NoDamageOrEffectDueToNShieldText
	jr .no_damage_or_effect

; if the Pokemon being attacked is Haunter1, and its Transparency is active,
; there is a 50% chance that any damage or effect is prevented
HandleTransparency: ; 348a (0:348a)
	ld a, [wTempNonTurnDuelistCardId]
	cp HAUNTER1
	jr z, .transparency
.asm_3491
	or a
	ret
.transparency
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr z, .asm_3491
	ld a, [wcceb]
	call CheckIfUnderAnyCannotUseStatus2
	jr c, .asm_3491
	xor a
	ld [wcac2], a
	ldtx de, TransparencyCheckText
	call TossCoin
	ret nc
	ld a, NO_DAMAGE_OR_EFFECT_TRANSPARENCY
	ld [wNoDamageOrEffect], a
	ldtx hl, NoDamageOrEffectDueToTransparencyText
	scf
	ret
; 0x34b7

; return carry and return the appropriate text pointer in hl if the target has an
; special status or power that prevents any damage or effect done to it this turn
CheckNoDamageOrEffect: ; 34b7 (0:34b7)
	ld a, [wNoDamageOrEffect]
	or a
	ret z
	bit 7, a
	jr nz, .dont_print_text ; already been here so don't repeat the text
	ld hl, wNoDamageOrEffect
	set 7, [hl]
	dec a
	add a
	ld e, a
	ld d, $0
	ld hl, NoDamageOrEffectTextPointerTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	scf
	ret

.dont_print_text
	ld hl, $0000
	scf
	ret
; 0x34d8

NoDamageOrEffectTextPointerTable: ; 34d8 (0:34d8)
	tx NoDamageOrEffectDueToAgilityText      ; NO_DAMAGE_OR_EFFECT_AGILITY
	tx NoDamageOrEffectDueToBarrierText      ; NO_DAMAGE_OR_EFFECT_BARRIER
	tx NoDamageOrEffectDueToFlyText          ; NO_DAMAGE_OR_EFFECT_FLY
	tx NoDamageOrEffectDueToTransparencyText ; NO_DAMAGE_OR_EFFECT_TRANSPARENCY
	tx NoDamageOrEffectDueToNShieldText      ; NO_DAMAGE_OR_EFFECT_NSHIELD
; 0x34e2

Func_34e2: ; 34e2 (0:34e2)
	ld a, $27
	call Func_3509
	ccf
	ret nc
	ld a, $5c
	call Func_3525
	ret

; returns carry if paralyzed, asleep, confused, and/or toxic gas in play,
; meaning that move and/or pkmn power cannot be used
CheckIfUnderAnyCannotUseStatus: ; 34ef (0:34ef)
	xor a

; same as above, but if a is non-0, only toxic gas is checked
CheckIfUnderAnyCannotUseStatus2: ; 34f0 (0:34f0)
	or a
	jr nz, .check_toxic_gas
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and PASSIVE_STATUS_MASK
	ldtx hl, CannotUseDueToStatusText
	scf
	jr nz, .done ; return carry
.check_toxic_gas
	ld a, MUK
	call Func_3509
	ldtx hl, UnableDueToToxicGasText
.done
	ret

Func_3509: ; 3509 (0:3509)
	push bc
	ld [wce7c], a
	call Func_3525
	ld c, a
	call SwapTurn
	ld a, [wce7c]
	call Func_3525
	call SwapTurn
	add c
	or a
	scf
	jr nz, .asm_3523
	or a
.asm_3523
	pop bc
	ret

Func_3525: ; 3525 (0:3525)
	push hl
	push de
	push bc
	ld [wce7c], a
	ld c, $0
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp $ff
	jr z, .asm_3549
	call GetCardInDeckPosition
	ld a, [wce7c]
	cp e
	jr nz, .asm_3549
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and PASSIVE_STATUS_MASK
	jr nz, .asm_3549
	inc c
.asm_3549
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.asm_354e
	ld a, [hli]
	cp $ff
	jr z, .asm_3560
	call GetCardInDeckPosition
	ld a, [wce7c]
	cp e
	jr nz, .asm_355d
	inc c
.asm_355d
	inc b
	jr .asm_354e
.asm_3560
	ld a, c
	or a
	scf
	jr nz, .asm_3566
	or a
.asm_3566
	pop bc
	pop de
	pop hl
	ret
; 0x356a

	INCROM $356a, $35e6

; if swords dance or focus energy was used this turn,
; mark that the base power of the next turn's attack has to be doubled
HandleSwordsDanceOrFocusEnergySubstatus: ; 35e6 (0:35e6)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	ld [hl], $0
	or a
	ret z
	cp SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE
	ret nz
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS5
	call GetTurnDuelistVariable
	set SUBSTATUS5_THIS_TURN_DOUBLE_DAMAGE, [hl]
	ret

; clears the substatus 2 and updates the double damage condition of the turn holder
UpdateSubstatusConditions: ; 35fa (0:35fa)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS5
	call GetTurnDuelistVariable
	res 1, [hl]
	push hl
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	xor a
	ld [hl], a
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	pop hl
	cp SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE
	ret z
	res SUBSTATUS5_THIS_TURN_DOUBLE_DAMAGE, [hl]
	ret
; 0x3615

	INCROM $3615, $363b

; if the target card's HP is 0 and the attacking card's HP is not,
; the attacking card faints if it was affected by destiny bond
HandleDestinyBondSubstatus: ; 363b (0:363b)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetNonTurnDuelistVariable
	cp SUBSTATUS1_DESTINY_BOND
	jr z, .check_hp
	ret

.check_hp
	ld a, DUELVARS_ARENA_CARD
	call GetNonTurnDuelistVariable
	cp $ff
	ret z
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	or a
	ret nz
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	ret z
	ld [hl], $0
	push hl
	call $4f9d
	call $503a
	pop hl
	ld l, DUELVARS_ARENA_CARD
	ld a, [hl]
	call LoadDeckCardToBuffer2
	ld hl, wLoadedCard2Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_2ebb
	ldtx hl, KnockedOutDueToDestinyBondText
	call DrawWideTextBox_WaitForInput
	ret
; 0x367b

; when Machamp is damaged, if its Strikes Back is active,
; the attacking Pokemon takes 10 damage
HandleStrikesBack: ; 367b (0:367b)
	ld a, [wTempNonTurnDuelistCardId]
	cp MACHAMP
	jr z, .strikes_back
	ret
.strikes_back
	ld a, [wLoadedMoveCategory]
	and RESIDUAL
	ret nz
	ld a, [wccbf]
	or a
	ret z
	call SwapTurn
	call CheckIfUnderAnyCannotUseStatus
	call SwapTurn
	ret c
	ld hl, 10 ; damage to be dealt to attacker
	call ApplyStrikesBack
	call nc, WaitForWideTextBoxInput
	ret

ApplyStrikesBack: ; 36a2 (0:36a2)
	push hl
	call Func_2ec4
	ld a, [wTempTurnDuelistCardId]
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer2
	ld hl, wLoadedCard2Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Func_2ebb
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	pop de
	push af
	push hl
	call SubstractHP
	ldtx hl, ReceivesDamageDueToStrikesBackText
	call DrawWideTextBox_PrintText
	pop hl
	pop af
	or a
	ret z
	call WaitForWideTextBoxInput
	xor a
	call Func_1aac
	call $503a
	scf
	ret
; 0x36d9

	INCROM $36d9, $36f6

Func_36f6: ; 36f6 (0:36f6)
	xor a

Func_36f7: ; 36f7 (0:36f7)
	push hl
	push de
	ld e, a
	add $d4
	call GetTurnDuelistVariable
	bit 7, a
	jr nz, .asm_3718
.asm_3703
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardInDeckPosition
	call Func_2f32
	cp $10
	jr nz, .asm_3715
	ld a, $6
.asm_3715
	pop de
	pop hl
	ret
.asm_3718
	ld a, e
	call CheckIfUnderAnyCannotUseStatus2
	jr c, .asm_3703
	ld a, e
	add $d4
	call GetTurnDuelistVariable
	pop de
	pop hl
	and $f
	ret
; 0x3729

	INCROM $3729, $3730

Func_3730: ; 3730 (0:3730)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetTurnDuelistVariable
	or a
	ret nz
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadDeckCardToBuffer2
	ld a, [wLoadedCard2Weakness]
	ret
; 0x3743

	INCROM $3743, $374a

Func_374a: ; 374a (0:374a)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS4
	call GetTurnDuelistVariable
	or a
	ret nz
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadDeckCardToBuffer2
	ld a, [wLoadedCard2Resistance]
	ret
; 0x375d

; this function checks if charizard's energy burn is active, and if so
; turns all energies except double colorless energies into fire energies
HandleEnergyBurn: ; 375d (0:375d)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardInDeckPosition
	ld a, e
	cp CHARIZARD
	ret nz
	xor a
	call CheckIfUnderAnyCannotUseStatus2
	ret c
	ld hl, wAttachedEnergies
	ld c, COLORLESS - FIRE
	xor a
.zero_next_energy
	ld [hli], a
	dec c
	jr nz, .zero_next_energy
	ld a, [wTotalAttachedEnergies]
	ld [wAttachedEnergies], a
	ret
; 0x377f

SetupSound: ; 377f (0:377f)
	farcall _SetupSound
	ret

Func_3784: ; 3784 (0:3784)
	xor a
PlaySong: ; 3785 (0:3785)
	farcall _PlaySong
	ret

Func_378a: ; 378a (0:378a)
	farcall Func_f400f
	ret

Func_378f: ; 378f (0:378f)
	farcall Func_f4012
	ret

Func_3794: ; 3794 (0:3794)
	ld a, $04
PlaySFX: ; 3796 (0:3796)
	farcall _PlaySFX
	ret

Func_379b: ; 379b (0:379b)
	farcall Func_f401b
	ret

Func_37a0: ; 37a0 (0:37a0)
	farcall Func_f401e
	ret
; 0x37a5

	INCROM $37a5, $380e

Func_380e: ; 380e (0:380e)
	ld a, [wd0c1]
	bit 7, a
	ret nz
	ldh a, [hBankROM]
	push af
	ld a, BANK(SetScreenScrollWram)
	call BankswitchHome
	call SetScreenScrollWram
	call Func_c554
	ld a, BANK(Func_1c610)
	call BankswitchHome
	call Func_1c610
	call Func_3cb4
	ld a, BANK(Func_804d8)
	call BankswitchHome
	call Func_804d8
	call UpdateRNGSources
	pop af
	call BankswitchHome
	ret

Func_383d: ; 383d (0:383d)
	ld a, $1
	ld [wPlayTimeCounterEnable], a
	ldh a, [hBankROM]
	push af
.asm_3845
	call Func_3855
	jr nc, .asm_3850
	farcall LoadMap
	jr .asm_3845
.asm_3850
	pop af
	call BankswitchHome
	ret

Func_3855: ; 3855 (0:3855)
	ld a, [wd0b5]
	cp $7
	jr c, .asm_385e
	ld a, $6
.asm_385e
	ld hl, PointerTable_3864
	jp JumpToFunctionInTable

PointerTable_3864: ; 3864 (0:3864)
	dw Func_3874
	dw Func_38c0
	dw Func_38a3
	dw Func_3876
	dw Credits_3911
	dw Func_38fb
	dw Func_38db
	dw Func_3874

Func_3874: ; 3874 (0:3874)
	scf
	ret

Func_3876: ; 3876 (0:3876)
	ldh a, [hBankROM]
	push af
	call Func_379b
	ld a, MUSIC_CARDPOP
	call PlaySong
	ld a, $3
	ld [wd0c2], a
	ld a, [wd10e]
	or $10
	ld [wd10e], a
	farcall Func_b177
	ld a, [wd10e]
	and $ef
	ld [wd10e], a
	call Func_37a0
	pop af
	call BankswitchHome
	scf
	ret

Func_38a3: ; 38a3 (0:38a3)
	ld a, $2
	ld [wd0c2], a
	xor a
	ld [wd112], a
	ld a, $ff
	ld [wd0c3], a
	ld a, $2
	ld [wDuelTheme], a
	ld a, MUSIC_CARDPOP
	call PlaySong
	bank1call Func_758f
	scf
	ret

Func_38c0: ; 38c0 (0:38c0)
	ld a, $1
	ld [wd0c2], a
	xor a
	ld [wd112], a
	call EnableExtRAM
	xor a
	ld [$ba44], a
	call DisableExtRAM
	call Func_3a3b
	bank1call StartDuel
	scf
	ret

Func_38db: ; 38db (0:38db)
	ld a, $6
	ld [wd111], a
	call Func_39fc
	call EnableExtRAM
	xor a
	ld [$ba44], a
	call DisableExtRAM
asm_38ed
	farcall Func_131d3
	ld a, $9
	ld [wd111], a
	call Func_39fc
	scf
	ret

Func_38fb: ; 38fb (0:38fb)
	xor a
	ld [wd112], a
	bank1call Func_406f
	call EnableExtRAM
	ld a, [$ba44]
	call DisableExtRAM
	cp $ff
	jr z, asm_38ed
	scf
	ret

Credits_3911: ; 3911 (0:3911)
	farcall Credits_1d6ad
	or a
	ret

Func_3917: ; 3917 (0:3917)
	ld a, $22
	farcall CheckIfEventFlagSet
	call EnableExtRAM
	ld [$a00a], a
	call DisableExtRAM
	ret

GetFloorObjectFromPos: ; 3927 (0:3927)
	push hl
	call FindFloorTileFromPos
	ld a, [hl]
	pop hl
	ret
; 0x392e

	INCROM $392e, $3946

; puts a floor tile in hc given coords in bc (x,y. measured in tiles)
FindFloorTileFromPos: ; 3946 (0:3946)
	push bc
	srl b
	srl c
	swap c
	ld a, c
	and $f0
	or b
	ld c, a
	ld b, $0
	ld hl, wFloorObjectMap
	add hl, bc
	pop bc
	ret

Func_395a: ; 395a (0:395a)
	ldh a, [hBankROM]
	push af
	ld a, [wd4c6]
	call BankswitchHome
	call CopyGfxData
	pop af
	call BankswitchHome
	ret

Unknown_396b: ; 396b (0:396b)
	INCROM $396b, $3973

; Movement offsets for scripted movements
ScriptedMovementOffsetTable: ; 3973 (0:3973)
	db $00, -$02 ; move 2 tiles up
	db $02, $00 ; move 2 tiles right
	db $00, $02 ; move 2 tiles down
	db -$02, $00 ; move 2 tiles left

Unknown_397b: ; 397b (0:397b)
	INCROM $397b, $3997

Func_3997: ; 3997 (0:3997)
	ldh a, [hBankROM]
	push af
	ld a, BANK(Func_1c056)
	call BankswitchHome
	call Func_1c056
	pop af
	call BankswitchHome
	ret

Func_39a7: ; 39a7 (0:39a7)
	ld l, $0
	call Func_39ad
	ret

Func_39ad: ; 39ad (0:39ad)
	push bc
	cp $8
	jr c, .asm_39b4
	rst $38
	xor a
.asm_39b4
	add a
	add a
	ld h, a
	add a
	add h
	add l
	ld l, a
	ld h, $0
	ld bc, $d34a
	add hl, bc
	pop bc
	ret

Func_39c3: ; 39c3 (0:39c3)
	push hl
	push bc
	push de
	xor a
	ld [wd3aa], a
	ld b, a
	ld c, $8
	ld de, $000c
	ld hl, $d34a
	ld a, [wd3ab]
.asm_39d6
	cp [hl]
	jr z, .asm_39e1
	add hl, de
	inc b
	dec c
	jr nz, .asm_39d6
	scf
	jr z, .asm_39e6
.asm_39e1
	ld a, b
	ld [wd3aa], a
	or a
.asm_39e6
	pop de
	pop bc
	pop hl
	ret
; 0x39ea

	INCROM $39ea, $39fc

Func_39fc: ; 39fc (0:39fc)
	push hl
	push bc
	call Func_378a
	or a
	push af
	call Func_3a1f
	ld c, a
	pop af
	jr z, .asm_3a11
	ld a, c
	ld hl, $d112
	cp [hl]
	jr z, .asm_3a1c
.asm_3a11
	ld a, c
	cp $1f
	jr nc, .asm_3a1c
	ld [wd112], a
	call PlaySong
.asm_3a1c
	pop bc
	pop hl
	ret

Func_3a1f: ; 3a1f (0:3a1f)
	ld a, [wd3b8]
	or a
	jr z, .asm_3a37
	ld a, [wd32e]
	cp $2
	jr z, .asm_3a37
	cp $b
	jr z, .asm_3a37
	cp $c
	jr z, .asm_3a37
	ld a, MUSIC_RONALD
	ret
.asm_3a37
	ld a, [wd111]
	ret

Func_3a3b: ; 3a3b (0:3a3b)
	farcall Func_1124d
	ret

Func_3a40: ; 3a40 (0:3a40)
	farcall Func_11430
	ret
; 0x3a45

	INCROM $3a45, $3a5e

Func_3a5e: ; 3a5e (0:3a5e)
	ldh a, [hBankROM]
	push af
	ld l, $4
	call Func_3abd
	jr nc, .asm_3ab3
	ld a, BANK(Func_c653)
	call BankswitchHome
	call Func_c653
	ld a, $4
	call BankswitchHome
	ld a, [wd334]
	ld d, a
.asm_3a79
	ld a, [hli]
	bit 7, a
	jr nz, .asm_3ab3
	push bc
	push hl
	cp d
	jr nz, .asm_3aab
	ld a, [hli]
	cp b
	jr nz, .asm_3aab
	ld a, [hli]
	cp c
	jr nz, .asm_3aab
	ld a, [hli]
	ld [wd0c6], a
	ld a, [hli]
	ld [wd0c7], a
	ld a, [hli]
	ld [wd0ca], a
	ld a, [hli]
	ld [wd0cb], a
	ld a, [hli]
	ld [wd0c8], a
	ld a, [hli]
	ld [wd0c9], a
	pop hl
	pop bc
	pop af
	call BankswitchHome
	scf
	ret
.asm_3aab
	pop hl
	ld bc, $0008
	add hl, bc
	pop bc
	jr .asm_3a79
.asm_3ab3
	pop af
	call BankswitchHome
	ld l, $6
	call $49c2
	ret

Func_3abd: ; 3abd (0:3abd)
	push bc
	push hl
	ld a, [wCurMap]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, MapScripts
	add hl, bc
	pop bc
	ld b, $0
	add hl, bc
	ldh a, [hBankROM]
	push af
	ld a, BANK(MapScripts)
	call BankswitchHome
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	call BankswitchHome
	ld a, l
	or h
	jr nz, .asm_3ae5
	scf
.asm_3ae5
	ccf
	pop bc
	ret
; 0x3ae8

	INCROM $3ae8, $3aed

; finds an OWScript from the first byte and puts the next two bytes (usually arguments?) into cb
RunOverworldScript: ; 3aed (0:3aed)
	ld hl, wOWScriptPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld c, [hl]
	inc hl
	ld b, [hl]
	push bc
	rlca
	ld c, a
	ld b, $0
	ld hl, OverworldScriptTable
	add hl, bc
	ldh a, [hBankROM]
	push af
	ld a, BANK(OverworldScriptTable)
	call BankswitchHome
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	call BankswitchHome
	pop bc
	jp hl
; 0x3b11

	INCROM $3b11, $3b21

Func_3b21: ; 3b21 (0:3b21)
	ldh a, [hBankROM]
	push af
	ld a, $7
	call BankswitchHome
	call $48bc
	pop af
	call BankswitchHome
	ret

Func_3b31: ; 3b31 (0:3b31)
	ldh a, [hBankROM]
	push af
	ld a, $7
	call BankswitchHome
	call $4b18
	jr c, .asm_3b45
	xor a
	ld [wDoFrameFunction], a
	ld [wcad4], a
.asm_3b45
	call Func_099c
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	pop af
	call BankswitchHome
	ret

Func_3b52: ; 3b52 (0:3b52)
	push hl
	push bc
	ld a, [wd42a]
	ld hl, $d4c0
	and [hl]
	ld hl, $d423
	ld c, $7
.asm_3b60
	and [hl]
	inc hl
	dec c
	jr nz, .asm_3b60
	cp $ff
	pop bc
	pop hl
	ret

Func_3b6a: ; 3b6a (0:3b6a)
	ld [wd422], a
	ldh a, [hBankROM]
	push af
	ld [wd4be], a
	push hl
	push bc
	push de
	ld a, $7
	call BankswitchHome
	ld a, [wd422]
	cp $61
	jr nc, .asm_3b90
	ld hl, $d4ad
	ld a, [wd4ac]
	cp [hl]
	jr nz, .asm_3b90
	call Func_3b52
	jr nc, .asm_3b95
.asm_3b90
	call $4a31
	jr .asm_3b9a
.asm_3b95
	call $48ef
	jr .asm_3b9a
.asm_3b9a
	pop de
	pop bc
	pop hl
	pop af
	call BankswitchHome
	ret
; 0x3ba2

	INCROM $3ba2, $3bd2

; writes from hl the pointer to the function to be called by DoFrame
SetDoFrameFunction: ; 3bd2 (0:3bd2)
	ld a, l
	ld [wDoFrameFunction], a
	ld a, h
	ld [wDoFrameFunction + 1], a
	ret

ResetDoFrameFunction: ; 3bdb (0:3bdb)
	push hl
	ld hl, $0000
	call SetDoFrameFunction
	pop hl
	ret
; 0x3be4

	INCROM $3be4, $3bf5

Func_3bf5: ; 3bf5 (0:3bf5)
	ldh a, [hBankROM]
	push af
	push hl
	ld a, [wd4c6]
	call BankswitchHome
	ld a, [wd4c4]
	ld l, a
	ld a, [wd4c5]
	ld h, a
	call CopyDataHLtoDE_SaveRegisters
	pop hl
	pop af
	call BankswitchHome
	ret
; 0x3c10

	INCROM $3c10, $3c45

Func_3c45: ; 3c45 (0:3c45)
	jp hl
; 0x3c46

	INCROM $3c46, $3c48

DoFrameIfLCDEnabled: ; 3c48 (0:3c48)
	push af
	ld a, [rLCDC]
	bit rLCDC_ENABLE, a
	jr z, .done
	push bc
	push de
	push hl
	call DoFrame
	pop hl
	pop de
	pop bc
.done
	pop af
	ret

; divides BC by DE. Stores result in BC and stores remainder in HL
DivideBCbyDE: ; 3c5a (0:3c5a)
	ld hl, $0000
	rl c
	rl b
	ld a, $10
.asm_3c63
	ldh [$ffb6], a
	rl l
	rl h
	push hl
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ccf
	jr nc, .asm_3c78
	ld h, a
	add sp, $2
	scf
	jr .asm_3c79
.asm_3c78
	pop hl
.asm_3c79
	rl c
	rl b
	ldh a, [$ffb6]
	dec a
	jr nz, .asm_3c63
	ret

Func_3c83: ; 3c83 (0:3c83)
	call PlaySong
	ret
; 0x3c87

	INCROM $3c87, $3c96

Func_3c96: ; 3c96 (0:3c96)
	call DoFrameIfLCDEnabled
	call Func_378a
	or a
	jr nz, Func_3c96
	ret

Func_3ca0: ; 3ca0 (0:3ca0)
	xor a
	ld [wd5d7], a

Func_3ca4: ; 3ca4 (0:3ca4)
	ldh a, [hBankROM]
	push af
	ld a, BANK(Func_1296e)
	call BankswitchHome
	call Func_1296e
	pop af
	call BankswitchHome
	ret

Func_3cb4: ; 3cb4 (0:3cb4)
	ldh a, [hBankROM]
	push af
	ld a, BANK(Func_12a21)
	call BankswitchHome
	call Func_12a21
	pop af
	call BankswitchHome
	ret
; 0x3cc4

	INCROM $3cc4, $3d72

Func_3d72: ; 3d72 (0:3d72)
	ldh a, [hBankROM]
	push af
	push hl
	push hl
	ld a, [wd4ca]
	cp $ff
	jr nz, .asm_3d84
	ld de, Unknown_80e5a
	xor a
	jr .asm_3da1
.asm_3d84
	ld a, [wd4c4]
	ld l, a
	ld a, [wd4c5]
	ld h, a
	ld a, [wd4c6]
	call BankswitchHome
	ld a, [hli]
	push af
	ld a, [wd4ca]
	rlca
	ld e, [hl]
	add e
	ld e, a
	inc hl
	ld a, [hl]
	adc $0
	ld d, a
	pop af
.asm_3da1
	add BANK(Unknown_80e5a)
	pop hl
	ld bc, $000b
	add hl, bc
	ld [hli], a
	call BankswitchHome
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	pop hl
	pop af
	call BankswitchHome
	ret

Func_3db7: ; 3db7 (0:3db7)
	push bc
	ld c, $0
	call ModifyUnknownOAMBufferProperty
	pop bc
	ret

; this needs to be determined after we learn more about the buffer.
ModifyUnknownOAMBufferProperty: ; 3dbf (0:3dbf)
	ld a, [wd4cf]
	cp $10
	jr c, .asm_3dc9
	rst $38
	ld a, $f
.asm_3dc9
	push bc
	swap a
	push af
	and $f
	ld b, a
	pop af
	and $f0
	or c
	ld c, a
	ld hl, wOAMBuffer
	add hl, bc
	pop bc
	ret
; 0x3ddb

	INCROM $3ddb, $3df3

Func_3df3: ; 3df3 (0:3df3)
	push af
	ldh a, [hBankROM]
	push af
	push hl
	ld a, BANK(Func_12c7f)
	call BankswitchHome
	ld hl, sp+$5
	ld a, [hl]
	call Func_12c7f
	call SetFlushAllPalettes
	pop hl
	pop af
	call BankswitchHome
	pop af
	ld a, [wd61b]
	ret
; 0x3e10

Func_3e10: ; 3e10 (0:3e10)
	ld a, $1
	ld [wd61e], a
	ld a, $62
Func_3e17: ; 3e17 (0:3e17)
	ld [wd131], a
	ldh a, [hBankROM]
	push af
	ld a, $4
	call BankswitchHome
	call $6fc6
	pop af
	call BankswitchHome
	ret

Func_3e2a: ; 3e2a (0:3e2a)
	ld [wd61e], a
	ld a, $63
	jr Func_3e17
; 0x3e31

	INCROM $3e31, $3fe0

; jumps to 3f:hl
Bankswitch3dTo3f:: ; 3fe0 (0:3fe0)
	push af
	ld a, $3f
	ldh [hBankROM], a
	ld [MBC3RomBank], a
	pop af
	ld bc, Bankswitch3d
	push bc
	jp hl

Bankswitch3d: ; 3fe0 (0:3fe0)
	ld a, $3d
	ldh [hBankROM], a
	ld [MBC3RomBank], a
	ret

rept $a
	db $ff
endr
