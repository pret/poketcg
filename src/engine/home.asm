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
	call BankswitchSRAM
	call BankswitchVRAM0
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
	call hDMAFunction ; DMA-copy $ca00-$ca9f to OAM memory
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
	ld b, -68 ; Value for Normal Speed
	call CheckForCGB
	jr c, .set_timer
	ld a, [rKEY1]
	and $80
	jr z, .set_timer
	ld b, $100 - 2 * 68 ; Value for CGB Double Speed
.set_timer
	ld a, b
	ld [rTMA], a
	ld a, rTAC_16384_HZ
	ld [rTAC], a
	ld a, $7
	ld [rTAC], a
	ret

; return carry if not CGB
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
	ld a, FLUSH_ALL
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
	ld [hl], LOW(NopF)   ;
	inc hl               ; load `jp NopF`
	ld [hl], HIGH(NopF)  ;
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

; clear VRAM tile data
SetupVRAM: ; 03a1 (0:03a1)
	call FillTileMap
	call CheckForCGB
	jr c, .vram0
	call BankswitchVRAM1
	call .vram0
	call BankswitchVRAM0
.vram0
	ld hl, v0Tiles0
	ld bc, v0BGMapTiles1 - v0Tiles0
.loop
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

; fill VRAM0 BG maps with [wTileMapFill] and VRAM1 BG Maps with 0
FillTileMap: ; 03c0 (0:03c0)
	call BankswitchVRAM0
	ld hl, v0BGMapTiles1
	ld bc, v0BGMapTiles2 - v0BGMapTiles1
.vram0_loop
	ld a, [wTileMapFill]
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .vram0_loop
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret nz
	call BankswitchVRAM1
	ld hl, v1BGMapTiles1
	ld bc, v1BGMapTiles2 - v1BGMapTiles1
.vram1_loop
	xor a
	ld [hli], a
	dec bc
	ld a, c
	or b
	jr nz, .vram1_loop
	call BankswitchVRAM0
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
	ld a, FLUSH_ALL
	jr SetFlushPalettes

; Flush non-CGB palettes and a single CGB palette,
; provided in a as an index between 0-7 (BGP) or 8-15 (OBP)
SetFlushPalette: ; 0408 (0:0408)
	or FLUSH_ONE
	jr SetFlushPalettes

; Set wBGP to the specified value, flush non-CGB palettes, and the first CGB palette.
SetBGP: ; 040c (0:040c)
	ld [wBGP], a

SetFlushPalette0:
	ld a, FLUSH_ONE

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
	; if bit6 (FLUSH_ALL_F) of [wFlushPaletteFlags] is set, flush all 16 of them
	ld a, [wFlushPaletteFlags]
	bit FLUSH_ALL_F, a
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

EmptyScreen: ; 04a2 (0:04a2)
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

; returns v*BGMapTiles1 + BG_MAP_WIDTH * c + b in de.
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
	ld b, HIGH(v0BGMapTiles1)
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
	ld c, LOW(hDMAFunction)
	ld b, JumpToFunctionInTable - DMA
	ld hl, DMA
.loop
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .loop
	ret

; CopyDMAFunction copies this function to hDMAFunction ($ff83)
DMA: ; 05a1 (0:05a1)
	ld a, HIGH(wOAM)
	ld [rDMA], a
	ld a, $28
.wait
	dec a
	jr nz, .wait
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
	jr nz, .call_hl
	pop af
	ret
.call_hl
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

; copy b bytes of data from hl to de
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

; copy c bytes of data from hl to de, b times.
; used to copy gfx data.
CopyGfxData: ; 070c (0:070c)
	ld a, [wLCDC]
	rla
	jr nc, .next_tile
.hblank_copy
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
	jr nz, .hblank_copy
	ret
.next_tile
	push bc
.copy_tile
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_tile
	pop bc
	dec b
	jr nz, .next_tile
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
; set top2 of H to 01 (switchable ROM bank area),
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
	set 6, d ; $4000 ≤ de ≤ $7fff
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

; switch SRAM bank
BankswitchSRAM: ; 07a9 (0:07a9)
	push af
	ldh [hBankSRAM], a
	ld [MBC3SRamBank], a
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; enable external RAM
EnableSRAM: ; 07b6 (0:07b6)
	push af
	ld a, SRAM_ENABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; disable external RAM
DisableSRAM: ; 07be (0:07be)
	push af
	xor a ; SRAM_DISABLE
	ld [MBC3SRamEnable], a
	pop af
	ret

; set current dest VRAM bank to 0
BankswitchVRAM0: ; 07c5 (0:07c5)
	push af
	xor a
	ldh [hBankVRAM], a
	ld [rVBK], a
	pop af
	ret

; set current dest VRAM bank to 1
BankswitchVRAM1: ; 07cd (0:07cd)
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
	call BankswitchSRAM
	ld hl, sa000
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
	call DisableSRAM
	ret
.asm_82f
	ld hl, sa000
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
	call DisableSRAM
	ret

Func_084d: ; 084d (0:084d)
	ld a, 3
.clear_loop
	call ClearExtRAMBank
	dec a
	cp -1
	jr nz, .clear_loop
	ld hl, sa000
	ld [hl], $4
	inc hl
	ld [hl], $21
	inc hl
	ld [hl], $5
	ret

ClearExtRAMBank: ; 0863 (0:0863)
	push af
	call BankswitchSRAM
	call EnableSRAM
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
	ld hl, wcad6
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wcad8
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
	ld hl, wcadc
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
	ld hl, wcad6
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
	ld hl, wcad6
	ld [hl], c
	inc hl
	ld [hl], b
	ld hl, wcadd
	ld b, [hl]
	inc hl
	inc hl
	ld c, [hl]
	inc [hl]
	ld [bc], a
	ret
.asm_92a
	ld [wcade], a
	ld hl, wcada
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
	ld hl, wcad6
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

; set the Y Position and X Position of all sprites in wOAM to $00
InitSpritePositions: ; 099c (0:099c)
	xor a
	ld [wcab5], a
	ld hl, wOAM
	ld c, 40
	xor a
.loop
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	dec c
	jr nz, .loop
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
	ld de, v0Tiles1
	ld bc, v0BGMapTiles1 - v0Tiles1
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ld hl, v0BGMapTiles1
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

; copy b bytes of data from hl to de, but only during hblank
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

; copy c bytes of data from de to hl, but only during hblank
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

; returns a *= 10
Func_0c4b: ; 0c4b (0:0c4b)
	push de
	ld e, a
	add a
	add a
	add e
	add a
	pop de
	ret
; 0xc53

; returns hl *= 10
Func_0c53: ; 0c53 (0:0c53)
	push de
	ld l, a
	ld e, a
	ld h, $00
	ld d, h
	add hl, hl
	add hl, hl
	add hl, de
	add hl, hl
	pop de
	ret
; 0xc5f

	INCROM $0c5f, $0c91

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

Func_0cc5: ; 0cc5 (0:0cc5)
	ld hl, wSerialRecvCounter
	or a
	jr nz, .asm_cdc
	ld a, [hl]
	or a
	ret z
	ld [hl], $00
	ld a, [wSerialRecvBuf]
	ld e, $12
	cp $29
	jr z, .asm_cfa
	xor a
	scf
	ret
.asm_cdc
	ld a, $29
	ld [rSB], a
	ld a, $01
	ld [rSC], a
	ld a, $81
	ld [rSC], a
.asm_ce8
	ld a, [hl]
	or a
	jr z, .asm_ce8
	ld [hl], $00
	ld a, [wSerialRecvBuf]
	ld e, $29
	cp $12
	jr z, .asm_cfa
	xor a
	scf
	ret
.asm_cfa
	xor a
	ld [wSerialSendBufIndex], a
	ld [wcb80], a
	ld [wSerialSendBufToggle], a
	ld [wSerialSendSave], a
	ld [wcba3], a
	ld [wSerialRecvIndex], a
	ld [wSerialRecvCounter], a
	ld [wSerialLastReadCA], a
	ld a, e
	cp $29
	jr nz, .asm_d21
	ld bc, $800
.asm_d1b
	dec bc
	ld a, c
	or b
	jr nz, .asm_d1b
	ld a, e
.asm_d21
	ld [wSerialOp], a
	scf
	ret
; 0xd26

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

DuelTransmissionError: ; 0f35 (0:0f35)
	ld a, [wSerialFlags]
	ld l, a
	ld h, 0
	call LoadTxRam3
	ldtx hl, TransmissionErrorText
	call DrawWideTextBox_WaitForInput
	ld a, $ff
	ld [wd0c3], a
	ld hl, wcbe5
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
	ld hl, wcbe2
	ld de, wRNG1
	jr .asm_f76
.asm_f70
	ld hl, wRNG1
	ld de, wcbe2
.asm_f76
	ld c, $3
	call Func_0e63
	jp c, DuelTransmissionError
	ret

; sets hAIActionTableIndex to an AI action specified in register a
; also appears to handle sending data in a link duel
SetDuelAIAction: ; 0f7f (0:0f7f)
	push hl
	push bc
	ldh [hAIActionTableIndex], a
	ld a, DUELVARS_DUELIST_TYPE
	call GetNonTurnDuelistVariable
	cp DUELIST_TYPE_LINK_OPP
	jr nz, .not_link
	ld hl, hAIActionTableIndex
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
	ld hl, hAIActionTableIndex
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
	jp c, DuelTransmissionError
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
	jp c, DuelTransmissionError
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
	call BankswitchSRAM
	call $669d
	xor a
	call BankswitchSRAM
	call EnableSRAM
	ld hl, sa008
	ld a, [hl]
	inc [hl]
	call DisableSRAM
	and $3
	add $28
	ld l, $0
	ld h, a
	add hl, hl
	add hl, hl
	ld a, $3
	call BankswitchSRAM
	push hl
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempTurnDuelistCardID], a
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempNonTurnDuelistCardID], a
	call SwapTurn
	pop hl
	push hl
	call EnableSRAM
	ld a, [wDuelTurns]
	ld [hli], a
	ld a, [wTempNonTurnDuelistCardID]
	ld [hli], a
	ld a, [wTempTurnDuelistCardID]
	ld [hli], a
	pop hl
	ld de, $0010
	add hl, de
	ld e, l
	ld d, h
	call DisableSRAM
	bank1call $66a4
	xor a
	call BankswitchSRAM
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
	ld hl, wcce9
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
	debug_ret
	scf
	ret
; 0x10aa

; return, in register a, the amount of unclaimed prizes that the turn holder has left
CountPrizes: ; 10aa (0:10aa)
	push hl
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	ld l, a
	xor a
.count_loop
	rr l
	adc $00
	inc l
	dec l
	jr nz, .count_loop
	pop hl
	ret
; 0x10bc

; shuffles the turn holder's deck
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
	ld l, a ; hl = DUELVARS_DECK_CARDS + [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK]
	ld a, b ; a = number of cards in the deck
	call ShuffleCards
	ret

; draw a card from the turn holder's deck, saving its location as CARD_LOCATION_JUST_DRAWN
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

; add a card to the top of the turn holder's deck
; the card is identified by register a, which contains the card number within the deck (0-59)
ReturnCardToDeck: ; 10e8 (0:10e8)
	push hl
	push af
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	dec a
	ld [hl], a ; decrement number of cards not in deck
	add DUELVARS_DECK_CARDS
	ld l, a ; point to top deck card
	pop af
	ld [hl], a ; set top deck card
	ld l, a
	ld [hl], CARD_LOCATION_DECK
	ld a, l
	pop hl
	ret
; 0x10fc

; search a card in the turn holder's deck, extract it, and add it to the hand
; the card is identified by register a, which contains the card number within the deck (0-59)
SearchCardInDeckAndAddToHand: ; 10fc (0:10fc)
	push af
	push hl
	push de
	push bc
	ld c, a
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld a, DECK_SIZE
	sub [hl]
	inc [hl] ; increment number of cards not in deck
	ld b, a ; DECK_SIZE - [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK] (number of cards in deck)
	ld l, c
	set CARD_LOCATION_JUST_DRAWN_F, [hl]
	ld l, DUELVARS_DECK_CARDS + DECK_SIZE - 1
	ld e, l
	ld d, h ; hl = de = DUELVARS_DECK_CARDS + DECK_SIZE - 1 (last card)
	inc b
	jr .match
.loop
	ld a, [hld]
	cp c
	jr z, .match
	ld [de], a
	dec de
.match
	dec b
	jr nz, .loop
	pop bc
	pop de
	pop hl
	pop af
	ret
; 0x1123

; adds a card to the turn holder's hand and increments the number of cards in the hand
; the card is identified by register a, which contains the card number within the deck (0-59)
AddCardToHand: ; 1123 (0:1123)
	push af
	push hl
	push de
	ld e, a
	ld l, a
	ldh a, [hWhoseTurn]
	ld h, a
	; write CARD_LOCATION_HAND into the location of this card
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

; removes a card from the turn holder's hand and decrements the number of cards in the hand
; the card is identified by register a, which contains the card number within the deck (0-59)
RemoveCardFromHand: ; 1139 (0:1139)
	push af
	push hl
	push bc
	push de
	ld c, a
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	or a
	jr z, .done ; done if no cards in hand
	ld b, a ; number of cards in hand
	ld l, DUELVARS_HAND
	ld e, l
	ld d, h
.next_card
	ld a, [hli]
	cp c
	jr nz, .no_match
	push hl
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	dec [hl]
	pop hl
	jr .done_card
.no_match
	ld [de], a ; keep card in hand
	inc de
.done_card
	dec b
	jr nz, .next_card
.done
	pop de
	pop bc
	pop hl
	pop af
	ret
; 0x1160

; moves a card to the turn holder's discard pile, as long as it is in the hand
; the card is identified by register a, which contains the card number within the deck (0-59)
MoveHandCardToDiscardPile: ; 1160 (0:1160)
	call GetTurnDuelistVariable
	ld a, [hl]
	and $ff ^ CARD_LOCATION_JUST_DRAWN
	cp CARD_LOCATION_HAND
	ret nz ; return if card not in hand
	ld a, l
	call RemoveCardFromHand
;	fallthrough

; puts the card with the deck index (0-59) given in a into the discard pile
PutCardInDiscardPile: ; 116a (0:116a)
	push af
	push hl
	push de
	call GetTurnDuelistVariable
	ld [hl], CARD_LOCATION_DISCARD_PILE
	ld e, l
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	inc [hl]
	ld a, DUELVARS_DECK_CARDS - 1
	add [hl]
	ld l, a
	ld [hl], e ; save card to DUELVARS_DECK_CARDS + [DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE]
	pop de
	pop hl
	pop af
	ret
; 0x1182

; search a card in the turn holder's discard pile, extract it, and add it to the hand
; the card is identified by register a, which contains the card number within the deck (0-59)
MoveDiscardPileCardToHand: ; 1182 (0:1182)
	push hl
	push de
	push bc
	call GetTurnDuelistVariable
	set CARD_LOCATION_JUST_DRAWN_F, [hl]
	ld b, l
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	ld a, [hl]
	or a
	jr z, .done ; done if no cards in discard pile
	ld c, a
	dec [hl] ; decrement number of cards in discard pile
	ld l, DUELVARS_DECK_CARDS
	ld e, l
	ld d, h ; de = hl = DUELVARS_DECK_CARDS
.next_card
	ld a, [hli]
	cp b
	jr z, .match
	ld [de], a
	inc de
.match
	dec c
	jr nz, .next_card
	ld a, b
.done
	pop bc
	pop de
	pop hl
	ret
; 0x11a5

; return in the z flag whether turn holder's prize a (0-7) has been taken or not
; z: taken, nz: not taken
CheckPrizeTaken: ; 11a5 (0:11a5)
	ld e, a
	ld d, 0
	ld hl, PowersOf2
	add hl, de
	ld a, [hl]
	ld e, a
	cpl
	ld d, a
	ld a, DUELVARS_PRIZES
	call GetTurnDuelistVariable
	and e
	ret

PowersOf2:
	db $01, $02, $04, $08, $10, $20, $40, $80
; 0x11bf

; fill wDuelTempList with the turn holder's discard pile cards (their 0-59 deck index)
; return carry if the turn holder has no cards in the discard pile
CreateDiscardPileCardList: ; 11bf (0:11bf)
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	ld b, [hl]
	ld a, DUELVARS_DECK_CARDS - 1
	add [hl] ; point to last card in discard pile
	ld l, a
	ld de, wDuelTempList
	inc b
	jr .begin_loop
.next_card_loop
	ld a, [hld]
	ld [de], a
	inc de
.begin_loop
	dec b
	jr nz, .next_card_loop
	ld a, $ff ; $ff-terminated
	ld [de], a
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	ld a, [hl]
	or a
	ret nz
	scf
	ret
; 0x11df

; fill wDuelTempList with the turn holder's remaining deck cards (their 0-59 deck index)
; return carry if the turn holder has no cards left in the deck
CreateDeckCardList: ; 11df (0:11df)
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE
	jr nc, .no_cards_left_in_deck
	ld a, DECK_SIZE
	sub [hl]
	ld c, a
	ld b, a ; c = b = DECK_SIZE - [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK]
	ld a, [hl]
	add DUELVARS_DECK_CARDS
	ld l, a ; l = DUELVARS_DECK_CARDS + [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK]
	inc b
	ld de, wDuelTempList
	jr .begin_loop
.next_card
	ld a, [hli]
	ld [de], a
	inc de
.begin_loop
	dec b
	jr nz, .next_card
	ld a, $ff ; $ff-terminated
	ld [de], a
	ld a, c
	or a
	ret
.no_cards_left_in_deck
	ld a, $ff
	ld [wDuelTempList], a
	scf
	ret
; 0x120a

; fill wDuelTempList with the turn holder's energy cards
; in the arena or in a bench slot (their 0-59 deck index).
; if a == 0: search in CARD_LOCATION_ARENA
; if a != 0: search in CARD_LOCATION_BENCH_[A]
; return carry if no energy cards were found
CreateArenaOrBenchEnergyCardList: ; 120a (0:120a)
	or CARD_LOCATION_PLAY_AREA
	ld c, a
	ld de, wDuelTempList
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.next_card_loop
	ld a, [hl]
	cp c
	jr nz, .skip_card ; jump if not in specified play area location
	ld a, l
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	and 1 << TYPE_ENERGY_F
	jr z, .skip_card ; jump if Pokemon or trainer card
	ld a, l
	ld [de], a ; add to wDuelTempList
	inc de
.skip_card
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .next_card_loop
	; all cards checked
	ld a, $ff
	ld [de], a
	ld a, [wDuelTempList]
	cp $ff
	jr z, .no_energies_found
	or a
	ret
.no_energies_found
	scf
	ret
; 0x123b

; fill wDuelTempList with the turn holder's hand cards (their 0-59 deck index)
; return carry if the turn holder has no cards in hand
CreateHandCardList: ; 123b (0:123b)
	call FindLastCardInHand
	inc b
	jr .skip_card

.check_next_card_loop
	ld a, [hld]
	push hl
	ld l, a
	bit CARD_LOCATION_JUST_DRAWN_F, [hl]
	pop hl
	jr nz, .skip_card
	ld [de], a
	inc de

.skip_card
	dec b
	jr nz, .check_next_card_loop
	ld a, $ff ; $ff-terminated
	ld [de], a
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	ld a, [hl]
	or a
	ret nz
	scf
	ret
; 0x1258

; sort the turn holder's hand cards by ID (highest to lowest ID)
; makes use of wDuelTempList
SortHandCardsByID: ; 1258 (0:1258)
	call FindLastCardInHand
.loop
	ld a, [hld]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ld a, $ff
	ld [de], a
	call SortCardsInDuelTempListByID
	call FindLastCardInHand
.loop2
	ld a, [de]
	inc de
	ld [hld], a
	dec b
	jr nz, .loop2
	ret
; 0x1271

; returns:
; b = turn holder's number of cards in hand (DUELVARS_NUMBER_OF_CARDS_IN_HAND)
; hl = pointer to turn holder's last (newest) card in DUELVARS_HAND
; de = wDuelTempList
FindLastCardInHand: ; 1271 (0:1271)
	ldh a, [hWhoseTurn]
	ld h, a
	ld l, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	ld b, [hl]
	ld a, DUELVARS_HAND - 1
	add [hl]
	ld l, a
	ld de, wDuelTempList
	ret

; shuffles the deck by swapping the position of each card with the position of another random card
; input:
; - a  = how many cards to shuffle
; - hl = DUELVARS_DECK_CARDS + [DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK]
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

; sort a $ff-terminated list of deck index cards by ID (lowest to highest ID).
; the list is wDuelTempList.
SortCardsInDuelTempListByID: ; 12a3 (0:12a3)
	ld hl, hTempListPtr_ff99
	ld [hl], LOW(wDuelTempList)
	inc hl
	ld [hl], HIGH(wDuelTempList)
	jr SortCardsInListByID_CheckForListTerminator

; sort a $ff-terminated list of deck index cards by ID (lowest to highest ID).
; the pointer to the list is given in hTempListPtr_ff99.
; sorting by ID rather than deck index means that the order of equal (same ID) cards does not matter,
; even if they have a different deck index.
SortCardsInListByID: ; 12ad (0:12ad)
	; load [hTempListPtr_ff99] into hl and de
	ld hl, hTempListPtr_ff99
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, l
	ld d, h

	; get ID of card with deck index at [de]
	ld a, [de]
	call GetCardIDFromDeckIndex_bc
	ld a, c
	ldh [hTempCardID_ff9b], a
	ld a, b
	ldh [hTempCardID_ff9b + 1], a ; 0

	; hl = [hTempListPtr_ff99] + 1
	inc hl
	jr .check_list_end

.next_card_in_list
	ld a, [hl]
	call GetCardIDFromDeckIndex_bc
	ldh a, [hTempCardID_ff9b + 1]
	cp b
	jr nz, .go
	ldh a, [hTempCardID_ff9b]
	cp c

.go
	jr c, .not_lower_id

	; this card has the lowest ID of those checked so far
	ld e, l
	ld d, h
	ld a, c
	ldh [hTempCardID_ff9b], a
	ld a, b
	ldh [hTempCardID_ff9b + 1], a

.not_lower_id
	inc hl

.check_list_end
	bit 7, [hl] ; $ff is the list terminator
	jr z, .next_card_in_list

	; reached list terminator
	ld hl, hTempListPtr_ff99
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; swap the lowest ID card found with the card in the current list position
	ld c, [hl]
	ld a, [de]
	ld [hl], a
	ld a, c
	ld [de], a
	pop hl
	; [hTempListPtr_ff99] += 1 (point hl to next card in list)
	inc [hl]
	jr nz, SortCardsInListByID_CheckForListTerminator
	inc hl
	inc [hl]
;	fallthrough

SortCardsInListByID_CheckForListTerminator: ; 12ef (0:12ef)
	ld hl, hTempListPtr_ff99
	ld a, [hli]
	ld h, [hl]
	ld l, a
	bit 7, [hl] ; $ff is the list terminator
	jr z, SortCardsInListByID
	ret
; 0x12fa

; returns, in register bc, the id of the card with the deck index specified in register a
; preserves hl
GetCardIDFromDeckIndex_bc: ; 12fa (0:12fa)
	push hl
	call _GetCardIDFromDeckIndex
	ld c, a
	ld b, $0
	pop hl
	ret
; 0x1303

; return [wDuelTempList + a] in a and in hTempCardIndex_ff98
GetCardInDuelTempList_OnlyDeckIndex: ; 1303 (0:1303)
	push hl
	push de
	ld e, a
	ld d, $0
	ld hl, wDuelTempList
	add hl, de
	ld a, [hl]
	ldh [hTempCardIndex_ff98], a
	pop de
	pop hl
	ret
; 0x1312

; given the deck index (0-59) of a card in [wDuelTempList + a], return:
;  - the id of the card with that deck index in register de
;  - [wDuelTempList + a] in hTempCardIndex_ff98 and in register a
GetCardInDuelTempList: ; 1312 (0:1312)
	push hl
	ld e, a
	ld d, $0
	ld hl, wDuelTempList
	add hl, de
	ld a, [hl]
	ldh [hTempCardIndex_ff98], a
	call GetCardIDFromDeckIndex
	pop hl
	ldh a, [hTempCardIndex_ff98]
	ret
; 0x1324

; returns, in register de, the id of the card with the deck index (0-59) specified by register a
; preserves af and hl
GetCardIDFromDeckIndex: ; 1324 (0:1324)
	push af
	push hl
	call _GetCardIDFromDeckIndex
	ld e, a
	ld d, $0
	pop hl
	pop af
	ret
; 0x132f

; remove card c from wDuelTempList (it contains a $ff-terminated list of deck indexes)
RemoveCardFromDuelTempList: ; 132f (0:132f)
	push hl
	push de
	push bc
	ld hl, wDuelTempList
	ld e, l
	ld d, h
	ld c, a
	ld b, $00
.next
	ld a, [hli]
	cp $ff
	jr z, .end_of_list
	cp c
	jr z, .match
	ld [de], a
	inc de
	inc b
.match
	jr .next
.end_of_list
	ld [de], a
	ld a, b
	or a
	jr nz, .done
	scf
.done
	pop bc
	pop de
	pop hl
	ret
; 0x1351

; return the number of cards in wDuelTempList in a
CountCardsInDuelTempList: ; 1351 (0:1351)
	push hl
	push bc
	ld hl, wDuelTempList
	ld b, -1
.loop
	inc b
	ld a, [hli]
	cp $ff
	jr nz, .loop
	ld a, b
	pop bc
	pop hl
	ret
; 0x1362

; returns, in register a, the id of the card with the deck index (0-59) specified in register a
_GetCardIDFromDeckIndex: ; 1362 (0:1362)
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

; load data of card with deck index a (0-59) to wLoadedCard1
LoadCardDataToBuffer1_FromDeckIndex: ; 1376 (0:1376)
	push hl
	push de
	push bc
	push af
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer1_FromCardID
	pop af
	ld hl, wLoadedCard1
	bank1call ConvertTrainerCardToPokemon
	ld a, e
	pop bc
	pop de
	pop hl
	ret

; load data of card with deck index a (0-59) to wLoadedCard2
LoadCardDataToBuffer2_FromDeckIndex: ; 138c (0:138c)
	push hl
	push de
	push bc
	push af
	call GetCardIDFromDeckIndex
	call LoadCardDataToBuffer2_FromCardID
	pop af
	ld hl, wLoadedCard2
	bank1call ConvertTrainerCardToPokemon
	ld a, e
	pop bc
	pop de
	pop hl
	ret
; 0x13a2

Func_13a2: ; 13a2 (0:13a2)
	ldh a, [hTempCardIndex_ff98]
	ld d, a
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	ld e, a
	call Func_13f7
	ret c
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	ld e, a
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld [wccee], a
	call LoadCardDataToBuffer2_FromDeckIndex
	ldh a, [hTempCardIndex_ff98]
	ld [hl], a
	call LoadCardDataToBuffer1_FromDeckIndex
	ldh a, [hTempCardIndex_ff98]
	call PutHandCardInPlayArea
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	ld a, e
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ld a, [wLoadedCard2HP]
	ld c, a
	ld a, [wLoadedCard1HP]
	sub c
	add [hl]
	ld [hl], a
	ld a, e
	add $c2
	ld l, a
	ld [hl], $00
	ld a, e
	add DUELVARS_ARENA_CARD_CHANGED_TYPE
	ld l, a
	ld [hl], $00
	ld a, e
	or a
	call z, ResetStatusConditions
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	add DUELVARS_ARENA_CARD_STAGE
	call GetTurnDuelistVariable
	ld a, [wLoadedCard1Stage]
	ld [hl], a
	or a
	ret ; !
	scf
	ret
; 0x13f7

Func_13f7: ; 13f7 (0:13f7)
	push de
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
	ld hl, wLoadedCard2Name
	ld de, wLoadedCard1NonPokemonDescription
	ld a, [de]
	cp [hl]
	jr nz, .asm_1427
	inc de
	inc hl
	ld a, [de]
	cp [hl]
	jr nz, .asm_1427
	pop de
	ld a, e
	add $c2
	call GetTurnDuelistVariable
	and $80
	jr nz, .asm_1425
	ld a, $01
	or a
	scf
	ret
.asm_1425
	or a
	ret
.asm_1427
	pop de
	xor a
	scf
	ret
; 0x142b

Func_142b: ; 142b (0:142b)
	ld a, e
	add $c2
	call GetTurnDuelistVariable
	and $80
	jr nz, .asm_1437
	jr .asm_145e
.asm_1437
	ld a, e
	add DUELVARS_ARENA_CARD
	ld l, a
	ld a, [hl]
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
	ld hl, wLoadedCard1NonPokemonDescription
	ld e, [hl]
	inc hl
	ld d, [hl]
	call $2ecd
	ld hl, wLoadedCard2Name
	ld de, wLoadedCard1NonPokemonDescription
	ld a, [de]
	cp [hl]
	jr nz, .asm_145e
	inc de
	inc hl
	ld a, [de]
	cp [hl]
	jr nz, .asm_145e
	or a
	ret
.asm_145e
	xor a
	scf
	ret
; 0x1461

; init the status and all substatuses of the turn holder's arena Pokemon.
; called when sending a new Pokemon into the arena.
; does not reset Headache, since it targets a player rather than a Pokemon.
ResetStatusConditions: ; 1461 (0:1461)
	push hl
	ldh a, [hWhoseTurn]
	ld h, a
	xor a
	ld l, DUELVARS_ARENA_CARD_STATUS
	ld [hl], a
	ld l, DUELVARS_ARENA_CARD_SUBSTATUS1
	ld [hl], a
	ld l, DUELVARS_ARENA_CARD_SUBSTATUS2
	ld [hl], a
	ld l, DUELVARS_ARENA_CARD_CHANGED_WEAKNESS
	ld [hl], a
	ld l, DUELVARS_ARENA_CARD_CHANGED_RESISTANCE
	ld [hl], a
	ld l, DUELVARS_ARENA_CARD_SUBSTATUS3
	res SUBSTATUS3_THIS_TURN_DOUBLE_DAMAGE, [hl]
	ld l, DUELVARS_ARENA_CARD_DISABLED_MOVE_INDEX
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	pop hl
	ret
; 0x1485

; Removes a Pokemon card from the hand and places it in the arena or first available bench slot.
; If the Pokemon is placed in the arena, the status conditions of the player's arena card are zeroed.
; input:
; - a = deck index of the card
; return carry if there is no room for more Pokemon
PutHandPokemonCardInPlayArea: ; 1485 (0:1485)
	push af
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY
	call GetTurnDuelistVariable
	cp MAX_PLAY_AREA_POKEMON
	jr nc, .already_max_pkmn_in_play
	inc [hl]
	ld e, a ; play area offset to place card
	pop af
	push af
	call PutHandCardInPlayArea
	ld a, e
	add DUELVARS_ARENA_CARD
	ld l, a
	pop af
	ld [hl], a ; set card in arena or benchx
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, DUELVARS_ARENA_CARD_HP
	add e
	ld l, a
	ld a, [wLoadedCard2HP]
	ld [hl], a ; set card's HP
	ld a, $c2
	add e
	ld l, a
	ld [hl], $0
	ld a, DUELVARS_ARENA_CARD_CHANGED_TYPE
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
	ld a, DUELVARS_ARENA_CARD_STAGE
	add e
	ld l, a
	ld a, [wLoadedCard2Stage]
	ld [hl], a ; set card's evolution stage
	ld a, e
	or a
	call z, ResetStatusConditions ; only call if Pokemon is being place in the arena
	ld a, e
	or a
	ret

.already_max_pkmn_in_play
	pop af
	scf
	ret
; 0x14d2

; Removes a card from the hand and changes its location to arena or bench. Given that
; DUELVARS_ARENA_CARD or DUELVARS_BENCH aren't affected, this function is meant for energy and trainer cards.
; input:
; - a = deck index of the card
; - e = play area location offset (PLAY_AREA_*)
; returns
; - a = CARD_LOCATION_PLAY_AREA + e
PutHandCardInPlayArea: ; 14d2 (0:14d2)
	call RemoveCardFromHand
	call GetTurnDuelistVariable
	ld a, e
	or CARD_LOCATION_PLAY_AREA
	ld [hl], a
	ret
; 0x14dd

; move the play area Pokemon card of the turn holder at CARD_LOCATION_PLAY_AREA + a
; to the discard pile
MovePlayAreaCardToDiscardPile: ; 14dd (0:14dd)
	call EmptyPlayAreaSlot
	ld l, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY
	dec [hl]
	ld l, DUELVARS_CARD_LOCATIONS
.next_card
	ld a, e
	or CARD_LOCATION_PLAY_AREA
	cp [hl]
	jr nz, .not_in_location
	push de
	ld a, l
	call PutCardInDiscardPile
	pop de
.not_in_location
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .next_card
	ret
; 0x14f8

; init a turn holder's play area slot to empty
; which slot (arena or benchx) is determined by the play area location offset (PLAY_AREA_*) in e
EmptyPlayAreaSlot: ; 14f8 (0:14f8)
	ldh a, [hWhoseTurn]
	ld h, a
	ld d, -1
	ld a, DUELVARS_ARENA_CARD
	call .init_duelvar
	ld d, 0
	ld a, DUELVARS_ARENA_CARD_HP
	call .init_duelvar
	ld a, DUELVARS_ARENA_CARD_STAGE
	call .init_duelvar
	ld a, DUELVARS_ARENA_CARD_CHANGED_TYPE
	call .init_duelvar
	ld a, $da
	call .init_duelvar
	ld a, $e0
.init_duelvar
	add e
	ld l, a
	ld [hl], d
	ret
; 0x151e

; shift play area Pokemon of both players to the first available play area (arena + benchx) slots
ShiftAllPokemonToFirstPlayAreaSlots: ; 151e (0:151e)
	call ShiftTurnPokemonToFirstPlayAreaSlots
	call SwapTurn
	call ShiftTurnPokemonToFirstPlayAreaSlots
	call SwapTurn
	ret
; 0x152b

; shift play area Pokemon of the turn holder to the first available play area (arena + benchx) slots
ShiftTurnPokemonToFirstPlayAreaSlots: ; 152b (0:152b)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	lb de, PLAY_AREA_ARENA, PLAY_AREA_ARENA
.next_play_area_slot
	bit 7, [hl]
	jr nz, .empty_slot
	call SwapPlayAreaPokemon
	inc e
.empty_slot
	inc hl
	inc d
	ld a, d
	cp MAX_PLAY_AREA_POKEMON
	jr nz, .next_play_area_slot
	ret
; 0x1543

; swap the data of the turn holder's arena Pokemon card with the
; data of the turn holder's Pokemon card in play area e.
; reset the status and all substatuses of the arena Pokemon before swapping.
; e is the play area location offset of the bench Pokemon (PLAY_AREA_*).
SwapArenaWithBenchPokemon: ; 1543 (0:1543)
	call ResetStatusConditions
	ld d, PLAY_AREA_ARENA
;	fallthrough

; swap the data of the turn holder's Pokemon card in play area d with the
; data of the turn holder's Pokemon card in play area e.
; d and e are play area location offsets (PLAY_AREA_*).
SwapPlayAreaPokemon: ; 1548 (0:1548)
	push bc
	push de
	push hl
	ld a, e
	cp d
	jr z, .done
	ldh a, [hWhoseTurn]
	ld h, a
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call .swap_duelvar
	ld a, DUELVARS_ARENA_CARD_HP
	call .swap_duelvar
	ld a, $c2
	call .swap_duelvar
	ld a, DUELVARS_ARENA_CARD_STAGE
	call .swap_duelvar
	ld a, DUELVARS_ARENA_CARD_CHANGED_TYPE
	call .swap_duelvar
	ld a, $e0
	call .swap_duelvar
	ld a, $da
	call .swap_duelvar
	set CARD_LOCATION_PLAY_AREA_F, d
	set CARD_LOCATION_PLAY_AREA_F, e
	ld l, DUELVARS_CARD_LOCATIONS
.update_card_locations_loop
	; update card locations of the two swapped cards
	ld a, [hl]
	cp e
	jr nz, .next1
	ld a, d
	jr .update_location
.next1
	cp d
	jr nz, .next2
	ld a, e
.update_location
	ld [hl], a
.next2
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .update_card_locations_loop
.done
	pop hl
	pop de
	pop bc
	ret

.swap_duelvar
	ld c, a
	add e ; play area location offset of card 1
	ld l, a
	ld a, c
	add d ; play area location offset of card 2
	ld c, a
	ld a, [bc]
	push af
	ld a, [hl]
	ld [bc], a
	pop af
	ld [hl], a
	ret
; 0x159f

; Find which and how many energy cards are attached to the turn holder's Pokemon card in the arena,
; or a Pokemon card in the bench, depending on the value of register e.
; input: e (location to check) = CARD_LOCATION_* - CARD_LOCATION_PLAY_AREA
; Feedback is returned in wAttachedEnergies and wTotalAttachedEnergies.
GetPlayAreaCardAttachedEnergies: ; 159f (0:159f)
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
	ld a, CARD_LOCATION_PLAY_AREA
	or e ; if e is non-0, a bench location is checked instead
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
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	bit TYPE_ENERGY_F, a
	jr z, .not_an_energy_card
	and TYPE_PKMN ; zero bit 3 to extract the type
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
; b = location to consider (CARD_LOCATION_*)
; h = PLAYER_TURN or OPPONENT_TURN
CountCardIDInLocation: ; 15ef (0:15ef)
	push bc
	ld l, DUELVARS_CARD_LOCATIONS
	ld c, $0
.next_card
	ld a, [hl]
	cp b
	jr nz, .unmatching_card_location_or_ID
	ld a, l
	push hl
	call _GetCardIDFromDeckIndex
	cp e
	pop hl
	jr nz, .unmatching_card_location_or_ID
	inc c
.unmatching_card_location_or_ID
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

Func_161e: ; 161e (0:161e)
	ldh a, [hTempCardIndex_ff98]
	call ClearChangedTypesIfMuk
	ldh a, [hTempCardIndex_ff98]
	ld d, a
	ld e, $00
	call CopyMoveDataAndDamage_FromDeckIndex
	call Func_16f6
	ldh a, [hTempCardIndex_ff98]
	ldh [hTempCardIndex_ff9f], a
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempTurnDuelistCardID], a
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	ret nz
	call $6510
	ldh a, [hTempCardIndex_ff98]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ldtx hl, HavePokemonPowerText
	call DrawWideTextBox_WaitForInput
	call Func_0f58
	ld a, [wLoadedCard1ID]
	cp MUK
	jr z, .use_pokemon_power
	ld a, $01 ; check only Muk
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	jr nc, .use_pokemon_power
	call $6510
	ldtx hl, UnableToUsePkmnPowerDueToToxicGasText
	call DrawWideTextBox_WaitForInput
	call Func_0f58
	ret

.use_pokemon_power
	ld hl, wLoadedMoveEffectCommands
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $07
	call CheckMatchingCommand
	ret c ; return if command not found
	bank1call $4f9d
	ldh a, [hTempCardIndex_ff9f]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld de, wLoadedCard1Name
	ld hl, wTxRam2
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld de, wLoadedMoveName
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ldtx hl, WillUseThePokemonPowerText
	call DrawWideTextBox_WaitForInput
	call Func_0f58
	call $7415
	ld a, $07
	call TryExecuteEffectCommandFunction
	ret
; 0x16ad

; copies, given a card identified by register a (card ID):
; - e into wSelectedMoveIndex and d into hTempCardIndex_ff9f
; - Move1 (if e == 0) or Move2 (if e == 1) data into wLoadedMove
; - Also from that move, its Damage field into wDamage
CopyMoveDataAndDamage_FromCardID: ; 16ad (0:16ad)
	push de
	push af
	ld a, e
	ld [wSelectedMoveIndex], a
	ld a, d
	ldh [hTempCardIndex_ff9f], a
	pop af
	ld e, a
	ld d, $00
	call LoadCardDataToBuffer1_FromCardID
	pop de
	jr CopyMoveDataAndDamage_FromDeckIndex.card_loaded

; copies, given a card identified by register d (0-59 deck index):
; - e into wSelectedMoveIndex and d into hTempCardIndex_ff9f
; - Move1 (if e == 0) or Move2 (if e == 1) data into wLoadedMove
; - Also from that move, its Damage field into wDamage
CopyMoveDataAndDamage_FromDeckIndex: ; 16c0 (0:16c0)
	ld a, e
	ld [wSelectedMoveIndex], a
	ld a, d
	ldh [hTempCardIndex_ff9f], a
	call LoadCardDataToBuffer1_FromDeckIndex
.card_loaded
	ld a, [wLoadedCard1ID]
	ld [wTempCardID_ccc2], a
	ld hl, wLoadedCard1Move1
	dec e
	jr nz, .got_move
	ld hl, wLoadedCard1Move2
.got_move
	ld de, wLoadedMove
	ld c, CARD_DATA_MOVE2 - CARD_DATA_MOVE1
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
	ld hl, wTempDamage_ccbf
	ld [hli], a
	ld [hl], a
	ret

; inits hTempCardIndex_ff9f, wTempTurnDuelistCardID, wTempNonTurnDuelistCardID, and other temp variables
Func_16f6: ; 16f6 (0:16f6)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ldh [hTempCardIndex_ff9f], a
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempTurnDuelistCardID], a
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempNonTurnDuelistCardID], a
	call SwapTurn
	xor a
	ld [wccec], a
	ld [wcccd], a
	ld [wcced], a
	ld [wDamageToSelfMode], a
	ld [wccef], a
	ld [wccf0], a
	ld [wccf1], a
	bank1call $7189
	ret

Func_1730: ; 1730 (0:1730)
	ld a, [wSelectedMoveIndex]
	ld [wcc10], a
	ldh a, [hTempCardIndex_ff9f]
	ld [wcc11], a
	ld a, [wTempCardID_ccc2]
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
	call SetDuelAIAction
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
	call SetDuelAIAction
	call $7415
	ld a, [wLoadedMoveCategory]
	and RESIDUAL
	jr nz, .asm_17ad
	call SwapTurn
	call HandleNoDamageOrEffectSubstatus
	call SwapTurn
.asm_17ad
	xor a
	ldh [hTempPlayAreaLocationOffset_ff9d], a
	ld a, $3
	call TryExecuteEffectCommandFunction
	call ApplyDamageModifiers_DamageToTarget
	call Func_189d
	ld hl, wTempDamage_ccbf
	ld [hl], e
	inc hl
	ld [hl], d
	ld b, $0
	ld a, [wDamageEffectiveness]
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
	call PrintKnockedOutIfHLZero
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
	ld a, [wTempNonTurnDuelistCardID]
	push af
	ld a, $4
	call TryExecuteEffectCommandFunction
	pop af
	ld [wTempNonTurnDuelistCardID], a
	call HandleStrikesBack_AgainstResidualMove
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
	ld [wDamageToSelfMode], a
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
	call SetDuelAIAction
	call Func_0f58
	ld a, $d
	call SetDuelAIAction
	ld a, $3
	call TryExecuteEffectCommandFunction
	ld a, $16
	call SetDuelAIAction
	ret

Func_1874: ; 1874 (0:1874)
	ld a, [wccec]
	or a
	ret nz
	ldh a, [hffa0]
	push af
	ldh a, [hTempCardIndex_ff9f]
	push af
	ld a, $1
	ld [wccec], a
	ld a, [wcc11]
	ldh [hTempCardIndex_ff9f], a
	ld a, [wcc10]
	ldh [hffa0], a
	ld a, $8
	call SetDuelAIAction
	call Func_0f58
	pop af
	ldh [hTempCardIndex_ff9f], a
	pop af
	ldh [hffa0], a
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
	ld [wTempPlayAreaLocationOffset_cceb], a
	call HandleTransparency
	call SwapTurn
	pop de
	ret nc
	bank1call $4f9d
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetNonTurnDuelistVariable
	ld [hl], $0
	ld de, 0
	ret

; return carry and 1 into wccc9 if damage is dealt to oneself due to confusion
CheckSelfConfusionDamage: ; 18d7 (0:18d7)
	xor a
	ld [wccc9], a
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
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

; use the trainer card with deck index at hTempCardIndex_ff98
; a trainer card is like a move effect, with its own effect commands
UseTrainerCard: ; 18f9 (0:18f9)
	call CheckCantUseTrainerDueToHeadache
	jr c, .cant_use
	ldh a, [hWhoseTurn]
	ld h, a
	ldh a, [hTempCardIndex_ff98]
	ldh [hTempCardIndex_ff9f], a
	call LoadNonPokemonCardEffectCommands
	ld a, $01
	call TryExecuteEffectCommandFunction
	jr nc, .can_use
.cant_use
	call DrawWideTextBox_WaitForInput
	scf
	ret
.can_use
	ld a, $02
	call TryExecuteEffectCommandFunction
	jr c, .done
	ld a, $06
	call SetDuelAIAction
	call $666a
	call Func_0f58
	ld a, $06
	call TryExecuteEffectCommandFunction
	ld a, $05
	call TryExecuteEffectCommandFunction
	ld a, $07
	call SetDuelAIAction
	ld a, $03
	call TryExecuteEffectCommandFunction
	ldh a, [hTempCardIndex_ff9f]
	call MoveHandCardToDiscardPile
	call Func_0f58
.done
	or a
	ret
; 0x1944

; loads the effect commands of a (trainer or energy) card with deck index (0-59) at hTempCardIndex_ff9f
; into wLoadedMoveEffectCommands
LoadNonPokemonCardEffectCommands: ; 1944 (0:1944)
	ldh a, [hTempCardIndex_ff9f]
	call LoadCardDataToBuffer1_FromDeckIndex
	ld hl, wLoadedCard1EffectCommands
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
; this function appears to handle dealing damage to self due to confusion
Func_195c: ; 195c (0:195c)
	ld hl, wDamage
	ld [hli], a
	ld [hl], $0
	ld a, [wNoDamageOrEffect]
	push af
	xor a
	ld [wNoDamageOrEffect], a
	bank1call $7415
	ld a, [wTempNonTurnDuelistCardID]
	push af
	ld a, [wTempTurnDuelistCardID]
	ld [wTempNonTurnDuelistCardID], a
	bank1call ApplyDamageModifiers_DamageToSelf ; switch to bank 1, but call a home func
	ld a, [wDamageEffectiveness]
	ld c, a
	ld b, $0
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	bank1call $7469
	call PrintKnockedOutIfHLZero
	pop af
	ld [wTempNonTurnDuelistCardID], a
	pop af
	ld [wNoDamageOrEffect], a
	ret

; given a damage value at wDamage:
; - if the non-turn holder's arena card is weak to the turn holder's arena card color: double damage
; - if the non-turn holder's arena card resists the turn holder's arena card color: reduce damage by 30
; - also apply Pluspower, Defender, and other kinds of damage reduction accordingly
; return resulting damage in de
ApplyDamageModifiers_DamageToTarget: ; 1994 (0:1994)
	xor a
	ld [wDamageEffectiveness], a
	ld hl, wDamage
	ld a, [hli]
	or [hl]
	jr nz, .non_zero_damage
	ld de, 0
	ret
.non_zero_damage
	xor a ; PLAY_AREA_ARENA
	ldh [hTempPlayAreaLocationOffset_ff9d], a
	ld d, [hl]
	dec hl
	ld e, [hl]
	bit 7, d
	jr z, .safe
	res 7, d ; cap at 2^15
	xor a
	ld [wDamageEffectiveness], a
	call HandleDoubleDamageSubstatus
	jr .check_pluspower_and_defender
.safe
	call HandleDoubleDamageSubstatus
	ld a, e
	or d
	ret z
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	call GetPlayAreaCardColor
	call TranslateColorToWR
	ld b, a
	call SwapTurn
	call GetArenaCardWeakness
	call SwapTurn
	and b
	jr z, .not_weak
	sla e
	rl d
	ld hl, wDamageEffectiveness
	set WEAKNESS, [hl]
.not_weak
	call SwapTurn
	call GetArenaCardResistance
	call SwapTurn
	and b
	jr z, .check_pluspower_and_defender ; jump if not resistant
	ld hl, -30
	add hl, de
	ld e, l
	ld d, h
	ld hl, wDamageEffectiveness
	set RESISTANCE, [hl]
.check_pluspower_and_defender
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	call SwapTurn
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedDefender
	call HandleDamageReduction
	bit 7, d
	jr z, .no_underflow
	ld de, 0
.no_underflow
	call SwapTurn
	ret

; convert a color to its equivalent WR_* (weakness/resistance) value
TranslateColorToWR: ; 1a0e (0:1a0e)
	push hl
	add LOW(InvertedPowersOf2)
	ld l, a
	ld a, HIGH(InvertedPowersOf2)
	adc $0
	ld h, a
	ld a, [hl]
	pop hl
	ret

InvertedPowersOf2: ; 1a1a (0:1a1a)
	db $80, $40, $20, $10, $08, $04, $02, $01

; given a damage value at wDamage:
; - if the turn holder's arena card is weak to its own color: double damage
; - if the turn holder's arena card resists its own color: reduce damage by 30
; return resulting damage in de
ApplyDamageModifiers_DamageToSelf: ; 1a22 (0:1a22)
	xor a
	ld [wDamageEffectiveness], a
	ld hl, wDamage
	ld a, [hli]
	or [hl]
	or a
	jr z, .no_damage
	ld d, [hl]
	dec hl
	ld e, [hl]
	call GetArenaCardColor
	call TranslateColorToWR
	ld b, a
	call GetArenaCardWeakness
	and b
	jr z, .not_weak
	sla e
	rl d
	ld hl, wDamageEffectiveness
	set WEAKNESS, [hl]
.not_weak
	call GetArenaCardResistance
	and b
	jr z, .not_resistant
	ld hl, -30
	add hl, de
	ld e, l
	ld d, h
	ld hl, wDamageEffectiveness
	set RESISTANCE, [hl]
.not_resistant
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedDefender
	bit 7, d ; test for underflow
	ret z
.no_damage
	ld de, 0
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
	ld [hl], 0
.no_underflow
	ld a, [hl]
	or a
	jr z, .zero
	scf
.zero
	pop de
	pop hl
	ret

; given a play area location offset in a, check if the turn holder's Pokemon card in
; that location has no HP left, and, if so, print that it was knocked out.
PrintPlayAreaCardKnockedOutIfNoHP: ; 1aac (0:1aac)
	ld e, a
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	or a
	ret nz ; return if arena card has non-0 HP
	ld a, [wTempNonTurnDuelistCardID]
	push af
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1ID]
	ld [wTempNonTurnDuelistCardID], a
	call PrintKnockedOut
	pop af
	ld [wTempNonTurnDuelistCardID], a
	scf
	ret

PrintKnockedOutIfHLZero: ; 1ad0 (0:1ad0)
	ld a, [hl] ; this is supposed to point to a remaining HP value after some form of damage calculation
	or a
	ret nz
;	fallthrough

; print in a text box that the Pokemon card at wTempNonTurnDuelistCardID was knocked out and wait 40 frames
PrintKnockedOut: ; 1ad3 (0:1ad3)
	ld a, [wTempNonTurnDuelistCardID]
	ld e, a
	call LoadCardDataToBuffer1_FromCardID
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ldtx hl, WasKnockedOutText
	call DrawWideTextBox_PrintText
	ld a, 40
.wait_frames
	call DoFrame
	dec a
	jr nz, .wait_frames
	scf
	ret
; 0x1af3

; seems to be a function to deal damage to a card
Func_1af3: ; 1af3 (0:1af3)
	ld a, $78
	ld [wLoadedMoveAnimation], a
	ld a, b
	ld [wTempPlayAreaLocationOffset_cceb], a
	or a ; cp PLAY_AREA_ARENA
	jr nz, .skip_no_damage_or_effect_check
	ld a, [wNoDamageOrEffect]
	or a
	ret nz
.skip_no_damage_or_effect_check
	push hl
	push de
	push bc
	xor a
	ld [wNoDamageOrEffect], a
	push de
	ld a, [wTempPlayAreaLocationOffset_cceb]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	ld [wTempNonTurnDuelistCardID], a
	pop de
	ld a, [wTempPlayAreaLocationOffset_cceb]
	or a ; cp PLAY_AREA_ARENA
	jr nz, .next
	ld a, [wDamageToSelfMode]
	or a
	jr z, .turn_swapped
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	jr .next
.turn_swapped
	call SwapTurn
	ld b, CARD_LOCATION_ARENA
	call ApplyAttachedPluspower
	call SwapTurn
.next
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr z, .skip_defender
	ld a, [wTempPlayAreaLocationOffset_cceb]
	or CARD_LOCATION_PLAY_AREA
	ld b, a
	call ApplyAttachedDefender
.skip_defender
	ld a, [wTempPlayAreaLocationOffset_cceb]
	or a ; cp PLAY_AREA_ARENA
	jr nz, .in_bench
	push de
	call HandleNoDamageOrEffectSubstatus
	pop de
	call HandleDamageReduction
.in_bench
	bit 7, d
	jr z, .no_underflow
	ld de, 0
.no_underflow
	call HandleDamageReductionOrNoDamageFromPkmnPowerEffects
	ld a, [wTempPlayAreaLocationOffset_cceb]
	ld b, a
	or a ; cp PLAY_AREA_ARENA
	jr nz, .benched
	; add damage at de to [wTempDamage_ccbf]
	ld hl, wTempDamage_ccbf
	ld a, e
	add [hl]
	ld [hli], a
	ld a, d
	adc [hl]
	ld [hl], a
.benched
	ld c, $00
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	push af
	bank1call $7469
	pop af
	or a
	jr z, .skip_knocked_out
	push de
	call PrintKnockedOutIfHLZero
	pop de
.skip_knocked_out
	call HandleStrikesBack_AgainstDamagingMove
	pop bc
	pop de
	pop hl
	ret
; 0x1b8d

Func_1b8d: ; 1b8d (0:1b8d)
	bank1call $4f9d
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, $12
	call Func_29f5
	ld [hl], $0
	ld hl, wTxRam2
	xor a
	ld [hli], a
	ld [hli], a
	ld a, [wLoadedMoveName]
	ld [hli], a ; wTxRam2_b
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
	ldh [hTempPlayAreaLocationOffset_ff9d], a
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
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, $12
	call Func_29f5
	ld [hl], $0
	ld hl, $0000
	call LoadTxRam2
	ld hl, wLoadedMoveName
	ld de, wTxRam2_b
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

; return in a the retreat cost of the turn holder's arena or benchx Pokemon
; given the PLAY_AREA_* value in hTempPlayAreaLocationOffset_ff9d
GetPlayAreaCardRetreatCost: ; 1c05 (0:1c05)
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	call GetLoadedCard1RetreatCost
	ret
; 0x1c13

; move the turn holder's card with ID at de to the discard pile
; if it's currently in the arena.
MoveCardToDiscardPileIfInArena: ; 1c13 (0:1c13)
	ld c, e
	ld b, d
	ld l, DUELVARS_CARD_LOCATIONS
.next_card
	ld a, [hl]
	and CARD_LOCATION_ARENA
	jr z, .skip ; jump if card not in arena
	ld a, l
	call GetCardIDFromDeckIndex
	ld a, c
	cp e
	jr nz, .skip ; jump if not the card id provided in c
	ld a, b
	cp d ; card IDs are 8-bit so d is always 0
	jr nz, .skip
	ld a, l
	push bc
	call PutCardInDiscardPile
	pop bc
.skip
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .next_card
	ret
; 0x1c35

; substract [hl] HP from the turn holder's card at CARD_LOCATION_PLAY_AREA + e
; return the result in a
SubstractHPFromCard: ; 1c35 (0:1c35)
	push hl
	push de
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	pop de
	push de
	ld a, DUELVARS_ARENA_CARD_HP
	add e
	call GetTurnDuelistVariable
	ld a, [wLoadedCard2HP]
	ld c, a
	sub [hl]
	pop de
	pop hl
	ret
; 0x1c50

; check if a flag of wLoadedMove is set
; input: a = %fffffbbb, where f = flag address counting from wLoadedMoveFlag1, and b = flag bit
; return carry if the flag is set
CheckLoadedMoveFlag: ; 1c50 (0:1c50)
	push hl
	push de
	push bc
	ld c, a ; %fffffbbb
	and $07
	ld e, a
	ld d, $00
	ld hl, PowersOf2
	add hl, de
	ld b, [hl]
	ld a, c
	rra
	rra
	rra
	and $1f
	ld e, a ; %000fffff
	ld hl, wLoadedMoveFlag1
	add hl, de
	ld a, [hl]
	and b
	jr z, .done
	scf ; set carry if the move has this flag set
.done
	pop bc
	pop de
	pop hl
	ret
; 0x1c72

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

; copy the $00-terminated player's name from sPlayerName to de
CopyPlayerName: ; 1c7d (0:1c7d)
	call EnableSRAM
	ld hl, sPlayerName
.loop
	ld a, [hli]
	ld [de], a
	inc de
	or a
	jr nz, .loop
	dec de
	call DisableSRAM
	ret

; copy the opponent's name to de (usually via PrintTextBoxBorderLabel)
CopyOpponentName: ; 1c8e (0:1c8e)
	ld hl, wOpponentName
	ld a, [hli]
	or [hl]
	jr z, .special_name
	ld a, [hld]
	ld l, [hl]
	ld h, a
	jp PrintTextBoxBorderLabel
.special_name
	ld hl, wc500
	ld a, [hl]
	or a
	jr z, .print_player2
	jr CopyPlayerName.loop
.print_player2
	ldtx hl, Player2Text
	jp PrintTextBoxBorderLabel

; return, in hl, the total amount of cards owned anywhere, including duplicates
GetRawAmountOfCardsOwned: ; 1caa (0:1caa)
	push de
	push bc
	call EnableSRAM
	ld hl, $0000
	ld de, sDeck1Cards
	ld c, NUM_DECKS
.next_deck
	ld a, [de]
	or a
	jr z, .skip_deck ; jump if deck empty
	ld a, c
	ld bc, DECK_SIZE
	add hl, bc
	ld c, a

.skip_deck
	ld a, sDeck2Cards - sDeck1Cards
	add e
	ld e, a
	ld a, $0
	adc d
	ld d, a ; de = sDeck*Cards[x]
	dec c
	jr nz, .next_deck

	; hl = DECK_SIZE * (no. of non-empty decks)
	ld de, sCardCollection
.next_card
	ld a, [de]
	bit CARD_NOT_OWNED_F, a
	jr nz, .skip_card
	ld c, a ; card count in sCardCollection
	ld b, $0
	add hl, bc

.skip_card
	inc e
	jr nz, .next_card ; assumes sCardCollection is $100 bytes long (CARD_COLLECTION_SIZE)
	call DisableSRAM
	pop bc
	pop de
	ret

; return carry if the count in sCardCollection plus the count in each deck (sDeck*)
; of the card with id given in a is 0 (if card not owned).
; also return the count (total owned amount) in a.
GetCardCountInCollectionAndDecks: ; 1ce1 (0:1ce1)
	push hl
	push de
	push bc
	call EnableSRAM
	ld c, a
	ld b, $0
	ld hl, sDeck1Cards
	ld d, NUM_DECKS
.next_deck
	ld a, [hl]
	or a
	jr z, .deck_done ; jump if deck empty
	push hl
	ld e, DECK_SIZE
.next_card
	ld a, [hli]
	cp c
	jr nz, .no_match
	inc b ; this deck card matches card c

.no_match
	dec e
	jr nz, .next_card
	pop hl

.deck_done
	push de
	ld de, sDeck2Cards - sDeck1Cards
	add hl, de
	pop de
	dec d
	jr nz, .next_deck

	; all decks done
	ld h, HIGH(sCardCollection)
	ld l, c
	ld a, [hl]
	bit CARD_NOT_OWNED_F, a
	jr nz, .done
	add b ; if card seen, add b to count

.done
	and CARD_COUNT_MASK
	call DisableSRAM
	pop bc
	pop de
	pop hl
	or a
	ret nz
	scf
	ret

; return carry if the count in sCardCollection of the card with id given in a is 0.
; also return the count (amount owned outside of decks) in a.
GetCardCountInCollection: ; 1d1d (0:1d1d)
	push hl
	call EnableSRAM
	ld h, HIGH(sCardCollection)
	ld l, a
	ld a, [hl]
	call DisableSRAM
	pop hl
	and CARD_COUNT_MASK
	ret nz
	scf
	ret

; creates a list at wTempCardCollection of every card the player owns and how many
CreateTempCardCollection: ; 1d2e (0:1d2e)
	call EnableSRAM
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
	call DisableSRAM
	ret

; adds the cards from a deck to wTempCardCollection given de = sDeck*Name
AddDeckCardsToTempCardCollection: ; 1d59 (0:1d59)
	ld a, [de]
	or a
	ret z ; return if empty name (empty deck)
	ld hl, sDeck1Cards - sDeck1Name
	add hl, de
	ld e, l
	ld d, h
	ld h, HIGH(wTempCardCollection)
	ld c, DECK_SIZE
.next_card
	ld a, [de] ; count of current card being added
	inc de ; move to next card for next iteration
	ld l, a
	inc [hl] ; increment count
	dec c
	jr nz, .next_card
	ret

; add card with id given in a to sCardCollection, provided that
; the player has less than MAX_AMOUNT_OF_CARD (99) of them
AddCardToCollection: ; 1d6e (0:1d6e)
	push hl
	push de
	push bc
	ld l, a
	push hl
	call CreateTempCardCollection
	pop hl
	call EnableSRAM
	ld h, HIGH(wTempCardCollection)
	ld a, [hl]
	and CARD_COUNT_MASK
	cp MAX_AMOUNT_OF_CARD
	jr nc, .already_max
	ld h, HIGH(sCardCollection)
	ld a, [hl]
	and CARD_COUNT_MASK
	inc a
	ld [hl], a
.already_max
	call DisableSRAM
	pop bc
	pop de
	pop hl
	ret

; remove a card with id given in a from sCardCollection (decrement its count if non-0)
RemoveCardFromCollection: ; 1d91 (0:1d91)
	push hl
	call EnableSRAM
	ld h, HIGH(sCardCollection)
	ld l, a
	ld a, [hl]
	and CARD_COUNT_MASK
	jr z, .zero
	dec a
	ld [hl], a
.zero
	call DisableSRAM
	pop hl
	ret
; 0x1da4

; return the amount of different cards that the player has collected in d
; return NUM_CARDS in e, minus 1 if VENUSAUR1 or MEW2 has not been collected (minus 2 if neither)
GetCardAlbumProgress: ; 1da4 (0:1da4)
	push hl
	call EnableSRAM
	ld e, NUM_CARDS
	ld h, HIGH(sCardCollection)
	ld l, VENUSAUR1
	bit CARD_NOT_OWNED_F, [hl]
	jr z, .next1
	dec e ; if VENUSAUR1 not owned
.next1
	ld l, MEW2
	bit CARD_NOT_OWNED_F, [hl]
	jr z, .next2
	dec e ; if MEW2 not owned
.next2
	ld d, LOW(sCardCollection)
	ld l, d
.next_card
	bit CARD_NOT_OWNED_F, [hl]
	jr nz, .skip
	inc d ; if this card owned
.skip
	inc l
	jr nz, .next_card ; assumes sCardCollection is $100 bytes long (CARD_COLLECTION_SIZE)
	call DisableSRAM
	pop hl
	ret
; 0x1dca

; copy c bytes of data from de to hl
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

; returns v*BGMapTiles1 + BG_MAP_WIDTH * e + d in hl.
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
	adc HIGH(v0BGMapTiles1)
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
	ld a, [wTextBoxFrameType]
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

; copies b bytes of data to sp-$1f and to hl, and returns hl += BG_MAP_WIDTH
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
	call BankswitchVRAM1
	ld a, [wTextBoxFrameType]
	ld e, a
	ld d, a
	xor a
	call CopyLine
	call BankswitchVRAM0
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
	call BankswitchVRAM1
	ld a, [wTextBoxFrameType] ; on CGB, wTextBoxFrameType determines the palette and the other attributes
	ld e, a
	ld d, a
	call CopyLine
	call BankswitchVRAM0
	ret

DrawRegularTextBoxSGB: ; 1f0f (0:1f0f)
	push bc
	push de
	call DrawRegularTextBoxDMG
	pop de
	pop bc
	ld a, [wTextBoxFrameType]
	or a
	ret z
ColorizeTextBoxSGB:
	push bc
	push de
	ld hl, wTempSGBPacket
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
	ld hl, wTempSGBPacket + 4
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
	ld a, [wTextBoxFrameType]
	and $80
	jr z, .asm_1f48
	ld a, $2
	ld [wTempSGBPacket + 2], a
.asm_1f48
	ld hl, wTempSGBPacket
	call SendSGB
	ret

AttrBlkPacket_1f4f: ; 1f4f (0:1f4f)
	sgb ATTR_BLK, 1 ; sgb_command, length
	db 1 ; number of data sets
	; Control Code,  Color Palette Designation, X1, Y1, X2, Y2
	db ATTR_BLK_CTRL_INSIDE + ATTR_BLK_CTRL_LINE, 0 << 0 + 1 << 2, 0, 0, 0, 0 ; data set 1
	ds 6 ; data set 2
	ds 2 ; data set 3

; Fill a bxc rectangle at de and at sp-$26,
; using tile a and the subsequent ones in the following pattern:
; | a+0*l+0*h | a+0*l+1*h | a+0*l+2*h |
; | a+1*l+0*h | a+1*l+1*h | a+1*l+2*h |
; | a+2*l+0*h | a+2*l+1*h | a+2*l+2*h |
FillRectangle: ; 1f5f (0:1f5f)
	push de
	push af
	push hl
	add sp, -BG_MAP_WIDTH
	call DECoordToBGMap0Address
.next_row
	push hl
	push bc
	ld hl, sp+$25
	ld d, [hl]
	ld hl, sp+$27
	ld a, [hl]
	ld hl, sp+$4
	push hl
.next_tile
	ld [hli], a
	add d
	dec b
	jr nz, .next_tile
	pop de
	pop bc
	pop hl
	push hl
	push bc
	ld c, b
	ld b, 0
	call SafeCopyDataDEtoHL
	ld hl, sp+$24
	ld a, [hl]
	ld hl, sp+$27
	add [hl]
	ld [hl], a
	pop bc
	pop de
	ld hl, BG_MAP_WIDTH
	add hl, de
	dec c
	jr nz, .next_row
	add sp, $24
	pop de
	ret
; 0x1f96

	INCROM $1f96, $20b0

Func_20b0: ; 20b0 (0:20b0)
	ld hl, DuelGraphics + $680 - $4000
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .asm_20bd
	ld hl, DuelGraphics + $e90 - $4000
.asm_20bd
	ld de, v0Tiles1 + $500
	ld b, $30
	jr CopyFontsOrDuelGraphicsTiles

Func_20c4: ; 20c4 (0:20c4)
	ld hl, DuelGraphics + $6c0 - $4000
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .copy
	ld hl, DuelGraphics + $ed0 - $4000
.copy
	ld de, v0Tiles1 + $540
	ld b, $c
	jr CopyFontsOrDuelGraphicsTiles

Func_20d8: ; 20d8 (0:20d8)
	ld b, $10
	jr Func_20dc.asm_20de

Func_20dc: ; 20dc (0:20dc)
	ld b, $24
.asm_20de
	ld hl, DuelGraphics + $980 - $4000
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .copy
	ld hl, DuelGraphics + $1190 - $4000
.copy
	ld de, v0Tiles1 + $500
	jr CopyFontsOrDuelGraphicsTiles

Func_20f0: ; 20f0 (0:20f0)
	ld hl, Fonts + $8
	ld de, v0Tiles1 + $200
	ld b, $d
	call CopyFontsOrDuelGraphicsTiles
	ld hl, DuelGraphics + $bc0 - $4000
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .copy
	ld hl, DuelGraphics + $13d0 - $4000
.copy
	ld de, v0Tiles1 + $500
	ld b, $30
	jr CopyFontsOrDuelGraphicsTiles

Func_210f: ; 210f (0:210f)
	ld hl, DuelGraphics + $1770 - $4000
	ld de, v0Tiles2 + $300
	ld b, $8
	jr CopyFontsOrDuelGraphicsTiles

Func_2119: ; 2119 (0:2119)
	ld hl, DuelGraphics - $4000
	ld de, v0Tiles2 ; destination
	ld b, $38 ; number of tiles
;	fallthrough

; if hl ≤ $3fff
;   copy b tiles from Gfx1:(hl+$4000) to de
; if $4000 ≤ hl ≤ $7fff
;   copy b tiles from Gfx2:hl to de
CopyFontsOrDuelGraphicsTiles:
	ld a, BANK(Fonts); BANK(DuelGraphics); BANK(VWF)
	call BankpushHome
	ld c, TILE_SIZE
	call CopyGfxData
	call BankpopHome
	ret
; 0x212f

; this function appears to copy duel gfx data into sram
Func_212f: ; 212f (0:212f)
	ld hl, DuelGraphics - $4000
	ld de, $a400
	ld b, $30
	call CopyFontsOrDuelGraphicsTiles
	ld hl, DuelGraphics + $17f0 - $4000
	ld de, $a700
	ld b, $08
	call CopyFontsOrDuelGraphicsTiles
	call GetCardSymbolData
	sub $d0
	ld l, a
	ld h, $00
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld de, DuelGraphics + $680 - $4000
	add hl, de
	ld de, $a780
	ld b, $04
	call CopyFontsOrDuelGraphicsTiles
	ld hl, DuelGraphics + $680 - $4000
	ld de, $b100
	ld b, $30
	jr CopyFontsOrDuelGraphicsTiles
; 0x2167

DrawDuelBoxMessage: ; 2167 (0:2167)
	ld l, a
	ld h, (40 * TILE_SIZE) / 4 ; boxes are 10x4 tiles
	call HtimesL
	add hl, hl
	add hl, hl
	; hl = a * $280
	ld de, DuelBoxMessages
	add hl, de
	ld de, v0Tiles1 + $200
	ld b, $28
	call CopyFontsOrDuelGraphicsTiles
	ld a, $a0
	lb hl, 1, 10
	lb bc, 10, 4
	lb de, 5, 4
	jp FillRectangle
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
	ldh a, [hffb0]
	or a
	jr nz, .asm_2240
	ld a, [hl]
	push hl
	call Func_22f2
	pop hl
.asm_2240
	inc hl
.asm_2241
	ldh a, [hffae]
	or a
	ret z
	ld b, a
	ldh a, [hffac]
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
	ldh [hffac], a
	ldh a, [hffad]
	add $20
	ld b, a
	ldh a, [hffaa]
	and $e0
	add b
	ldh [hffaa], a
	ldh a, [hffab]
	adc $0
	ldh [hffab], a
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
	ldh [hffa8], a
	call Func_2298
	xor a
	ldh [hffb0], a
	ldh [hffa9], a
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
	ldh [hffac], a
	ld [wcd0b], a
	ld a, $f
	ldh [hffaf], a
	ret

Func_22a6: ; 22a6 (0:22a6)
	push af
	call Func_22ae
	pop af
	ldh [hffae], a
	ret

Func_22ae: ; 22ae (0:22ae)
	push hl
	ld a, d
	ldh [hffad], a
	xor a
	ldh [hffae], a
	ld [wcd09], a
	call DECoordToBGMap0Address
	ld a, l
	ldh [hffaa], a
	ld a, h
	ldh [hffab], a
	call Func_2298
	xor a
	ld [wcd0b], a
	pop hl
	ret

Func_22ca: ; 22ca (0:22ca)
	push hl
	push de
	push bc
	ldh a, [hffb0]
	and $1
	jr nz, .asm_22ed
	call Func_2325
	jr c, .asm_22de
	or a
	jr nz, .asm_22e9
	call Func_24ac
.asm_22de
	ldh a, [hffb0]
	and $2
	jr nz, .asm_22e9
	ldh a, [hffa9]
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
	ld hl, hffaa
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
	ld de, wcd05
	ld c, 1
	call SafeCopyDataDEtoHL
	ld hl, hffac
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
	ldh a, [hffa8]
	ld hl, wcd04
	cp [hl]
	jr nz, .asm_2345
	ldh a, [hffa9]
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
	ldh a, [hffa9]
	ld c, a
	ld b, $c9
	ld a, l
	ldh [hffa9], a
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
	ldh a, [hffa9]
	ld l, a              ; l ← [hffa9]; index to to linked-list head
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
	ldh a, [hffa9]
	cp l
	jr z, .asm_23af      ; assert at least one iteration
	ld c, a
	ld b, $c9
	ld a, l
	ld [bc], a           ; prev[i0] ← i
	ldh [hffa9], a       ; [hffa9] ← i  (update linked-list head)
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
	ld de, wccf4
	call Func_24fa
	pop de
	ld a, d
	ld de, wccf5
	call Func_24fa
	ld hl, wccf4
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
	ld de, wccf4
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
.set_timer8
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	dec b
	jr nz, .set_timer8
	ret

Func_2510: ; 2510 (0:2510)
	push bc
	call Func_256d
	call Func_252e
	pop bc
Func_2518: ; 2518 (0:2518)
	ld hl, wcd07
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
	ld a, BANK(Fonts); BANK(DuelGraphics); BANK(VWF)
	call BankpushHome
	ld de, wccf4
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
;   x coord, y coord, y displacement between items, number of items,
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

	INCROM $278d, $2988

CardTypeToSymbolID: ; 2988 (0:2988)
	ld a, [wLoadedCard1Type]
	cp TYPE_TRAINER
	jr nc, .trainer_card
	cp TYPE_ENERGY_FIRE
	jr c, .pokemon_card
	; energy card
	and 7 ; convert energy constant to type constant
	ret
.trainer_card
	ld a, 11
	ret
.pokemon_card
	ld a, [wLoadedCard1Stage] ; different symbol for each evolution stage
	add 8
	ret
; 0x299f

GetCardSymbolData: ; 299f (0:299f)
	call CardTypeToSymbolID
	add a
	ld c, a
	ld b, 0
	ld hl, CardSymbolTable
	add hl, bc
	ld a, [hl]
	ret
; 0x29ac

DrawCardSymbol: ; 29ac (0:29ac)
	push hl
	push de
	push bc
	call GetCardSymbolData
	dec d
	dec d
	dec e
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .tiles
	; CGB-only attrs (palette)
	push hl
	inc hl
	ld a, [hl]
	lb bc, 2, 2
	lb hl, 0, 0
	call BankswitchVRAM1
	call FillRectangle
	call BankswitchVRAM0
	pop hl
.tiles
	ld a, [hl]
	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle
	pop bc
	pop de
	pop hl
	ret
; 0x29dd

CardSymbolTable:
; starting tile, cgb palette (grey, red, blue, pink)
	db $e0, $01 ; TYPE_ENERGY_FIRE
	db $e4, $02 ; TYPE_ENERGY_GRASS
	db $e8, $01 ; TYPE_ENERGY_LIGHTNING
	db $ec, $02 ; TYPE_ENERGY_WATER
	db $f0, $03 ; TYPE_ENERGY_PSYCHIC
	db $f4, $03 ; TYPE_ENERGY_FIGHTING
	db $f8, $00 ; TYPE_ENERGY_DOUBLE_COLORLESS
	db $fc, $02 ; TYPE_ENERGY_UNUSED
	db $d0, $02 ; TYPE_PKMN_*, Stage 0
	db $d4, $02 ; TYPE_PKMN_*, Stage 1
	db $d8, $01 ; TYPE_PKMN_*, Stage 2
	db $dc, $02 ; TYPE_TRAINER

Func_29f5: ; 29f5 (0:29f5)
	farcall $6, $4000
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
	ld hl, wDefaultText
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

Func_2b70: ; 2b70 (0:2b70)
	ld a, BANK(Func_407a)
	call BankswitchHome
	jp Func_407a
; 0x2b78

; loads opponent deck to wOpponentDeck
LoadOpponentDeck: ; 2b78 (0:2b78)
	xor a
	ld [wIsPracticeDuel], a
	ld a, [wOpponentDeckID]
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
	ld [wOpponentDeckID], a
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
	ld a, [wOpponentDeckID]
	cp DECKS_END
	jr c, .valid_deck
	ld a, PRACTICE_PLAYER_DECK - 2
	ld [wOpponentDeckID], a

.valid_deck
; set opponent as controlled by AI
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld a, [wOpponentDeckID]
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
	ldh [hTempPlayAreaLocationOffset_ff9d], a
	ret

Func_2bcf: ; 2bcf (0:2bcf)
	ld a, $4
	call Func_2bdb
	ldh [hffa0], a
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
	ld a, [wOpponentDeckID]
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
	ld hl, wce48
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
	ld hl, wce2b
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
	ld hl, wce4c
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
	jr z, .tx_ram1
	cp TX_RAM2
	jr z, .tx_ram2
	cp TX_RAM3
	jr z, .tx_ram3
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
.tx_ram2
	call Func_2ceb
	ld a, $f
	ld [hffaf], a
	xor a
	ld [wcd0a], a
	ld de, wTxRam2
	ld hl, wce49
	call Func_2de0
	ld a, l
	or h
	jr z, .asm_2dab
	call ReadTextOffset
	call Func_2cd7
	jr Func_2d43
.asm_2dab
	ld hl, wDefaultText
	call Func_2cd7
	jr Func_2d43
.tx_ram3
	call Func_2ceb
	ld de, wTxRam3
	ld hl, wce4a
	call Func_2de0
	call Func_2e12
	call Func_2cd7
	jp Func_2d43
.tx_ram1
	call Func_2ceb
	call CopyTurnDuelistName
	ld a, [wcaa0]
	cp $6
	jr z, .asm_2dda
	ld a, $7
	call Func_21f2
.asm_2dda
	call Func_2cd7
	jp Func_2d43

; inc [hl]
; hl = [de + 2*[hl]]
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

; copy the name of the duelist whose turn it is to de
CopyTurnDuelistName: ; 2e2c (0:2e2c)
	ld de, wcaa0
	push de
	ldh a, [hWhoseTurn]
	cp OPPONENT_TURN
	jp z, .opponent_turn
	call CopyPlayerName
	pop hl
	ret
.opponent_turn
	call CopyOpponentName
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
	ld hl, wDefaultText
.print_text
	call Func_2cc8
.next_tile_loop
	ldh a, [hButtonsHeld]
	ld b, a
	ld a, [wTextSpeed]
	inc a
	cp 3
	jr nc, .apply_delay
	; if text speed is 1, pressing b ignores it
	bit B_BUTTON_F, b
	jr nz, .skip_delay
	jr .apply_delay
.text_delay_loop
	; wait a number of frames equal to [wTextSpeed] between printing each text tile
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
	jp z, CopyOpponentName
	jp CopyPlayerName
; 0x2ea9

Func_2ea9: ; 2ea9 (0:2ea9)
	ldh [hff96], a
	ldh a, [hBankROM]
	push af
	call ReadTextOffset
	ldh a, [hff96]
	call $23fd
	pop af
	call BankswitchHome
	ret
; 0x2ebb

; text pointer (usually of a card name) for TX_RAM2
LoadTxRam2: ; 2ebb (0:2ebb)
	ld a, l
	ld [wTxRam2], a
	ld a, h
	ld [wTxRam2 + 1], a
	ret

; a number between 0 and 65535 for TX_RAM3
LoadTxRam3: ; 2ec4 (0:2ec4)
	ld a, l
	ld [wTxRam3], a
	ld a, h
	ld [wTxRam3 + 1], a
	ret
; 0x2ecd

	INCROM $2ecd, $2f0a

; load data of card with id at e to wLoadedCard2
LoadCardDataToBuffer2_FromCardID: ; 2f0a (0:2f0a)
	push hl
	ld hl, wLoadedCard2
	jr LoadCardDataToHL_FromCardID

; load data of card with id at e to wLoadedCard1
LoadCardDataToBuffer1_FromCardID: ; 2f10 (0:2f10)
	push hl
	ld hl, wLoadedCard1
;	fallthrough

LoadCardDataToHL_FromCardID: ; 2f14 (0:2f14)
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

; return in a the type (TYPE_* constant) of the card with id at e
GetCardType: ; 2f32 (0:2f32)
	push hl
	call GetCardPointer
	jr c, .done
	ld a, BANK(CardPointers)
	call BankpushHome2
	ld l, [hl]
	call BankpopHome
	ld a, l
	or a
.done
	pop hl
	ret

; return in a the 2-byte text id of the name of the card with id at e
GetCardName: ; 2f45 (0:2f45)
	push hl
	call GetCardPointer
	jr c, .done
	ld a, BANK(CardPointers)
	call BankpushHome2
	ld de, CARD_DATA_NAME
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	call BankpopHome
	or a
.done
	pop hl
	ret

; from the card id in a, returns type into a, rarity into b, and set into c
GetCardTypeRarityAndSet: ; 2f5d (0:2f5d)
	push hl
	push de
	ld d, 0
	ld e, a
	call GetCardPointer
	jr c, .done
	ld a, BANK(CardPointers)
	call BankpushHome2
	ld e, [hl] ; CARD_DATA_TYPE
	ld bc, CARD_DATA_RARITY
	add hl, bc
	ld b, [hl] ; CARD_DATA_RARITY
	inc hl
	ld c, [hl] ; CARD_DATA_SET
	call BankpopHome
	ld a, e
	or a
.done
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
	cp HIGH(CardPointers + 2 + (2 * NUM_CARDS))
	jr nz, .nz
	ld a, l
	cp LOW(CardPointers + 2 + (2 * NUM_CARDS))
.nz
	ccf
	jr c, .out_of_bounds
	ld a, BANK(CardPointers)
	call BankpushHome2
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call BankpopHome
	or a
.out_of_bounds
	pop bc
	pop de
	ret

; input: hl = card_gfx_index
; card_gfx_index = (<Name>CardGfx - CardGraphics) / 8 ; using absolute ROM addresses
LoadCardGfx: ; 2fa0 (0:2fa0)
	ldh a, [hBankROM]
	push af
	push hl
	; first, get the bank with the card gfx is at
	srl h
	srl h
	srl h
	ld a, BANK(CardGraphics)
	add h
	call BankswitchHome
	pop hl
	; once we have the bank, get the pointer: multiply by 8 and discard the bank offset
	add hl, hl
	add hl, hl
	add hl, hl
	res 7, h
	set 6, h ; $4000 ≤ de ≤ $7fff
	call CopyGfxData
	ld b, CGB_PAL_SIZE
	ld de, wce23
.copy_card_palette
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_card_palette
	pop af
	call BankswitchHome
	ret

; identical to CopyFontsOrDuelGraphicsTiles
CopyFontsOrDuelGraphicsTiles2: ; 2fcb (0:2fcb)
	ld a, BANK(Fonts); BANK(DuelGraphics); BANK(VWF)
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
	ld [wce22], a
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
;   returns: the number of heads in a and in wcd9d, and carry if at least one heads
TossCoinATimes: ; 3071 (0:3071)
	push hl
	ld hl, wCoinTossScreenTextID
	ld [hl], e
	inc hl
	ld [hl], d
	bank1call _TossCoin
	pop hl
	ret

; function that executes a single coin toss during a duel.
; text at de is printed in a text box during the coin toss.
;   returns: - carry, and 1 in a and in wcd9d if heads
;            - nc, and 0 in a and in wcd9d if tails
TossCoin: ; 307d (0:307d)
	push hl
	ld hl, wCoinTossScreenTextID
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $1
	bank1call _TossCoin
	ld hl, wcac2
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
	ld hl, wce64
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
	ld hl, wce70
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
	ld hl, wce63
	inc [hl]
	ret

Func_31b0: ; 31b0 (0:31b0)
	call Func_31ab
	ld hl, wce68
	ld a, [hli]
	or [hl]
	jr nz, .asm_31bf
	call Func_31ab
	jr Func_31dd
.asm_31bf
	ld hl, wce6a
	ld de, wce70
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

Func_31ca: ; 31ca (0:31ca)
	call Func_31fc
	ld hl, wce68
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
	ld hl, wce70
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	ld e, a
	ld hl, wce6c
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
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetTurnDuelistVariable
	bit SUBSTATUS3_THIS_TURN_DOUBLE_DAMAGE, [hl]
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
; damage is given in de as input and the possibly updated damage is also returned in de
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

; check if the attacked card has any substatus that reduces the damage this turn
; substatus 2 is not checked
; damage is given in de as input and the possibly updated damage is also returned in de
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
	call CheckCannotUseDueToStatus
	ret c
.pkmn_power
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	ret z
	ld a, [wTempNonTurnDuelistCardID]
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

; check for Invisible Wall, Kabuto Armor, NShield, or Transparency, in order to
; possibly reduce or make zero the damage at de.
HandleDamageReductionOrNoDamageFromPkmnPowerEffects: ; 32f7 (0:32f7)
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	ret z
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	ret c
	ld a, [wTempPlayAreaLocationOffset_cceb]
	or a
	call nz, HandleDamageReductionExceptSubstatus2.pkmn_power
	push de ; push damage from call above, which handles Invisible Wall and Kabuto Armor
	call HandleNoDamageOrEffectSubstatus.pkmn_power
	call nc, HandleTransparency
	pop de ; restore damage
	ret nc
	; if carry was set due to NShield or Transparency, damage is 0
	ld de, 0
	ret
; 0x3317

; when Machamp is damaged, if its Strikes Back is active,
; the attacking Pokemon takes 10 damage.
; used to bounce back a damaging move.
HandleStrikesBack_AgainstDamagingMove: ; 3317 (0:3317)
	ld a, e
	or d
	ret z
	ld a, [wDamageToSelfMode]
	or a
	ret nz
	ld a, [wTempNonTurnDuelistCardID]
	cp MACHAMP
	ret nz
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	ret c
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	ret z
	ld a, [wTempPlayAreaLocationOffset_cceb]
	or a ; cp PLAY_AREA_ARENA
	jr nz, .in_bench
	call CheckCannotUseDueToStatus
	ret c
.in_bench
	push hl
	push de
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	push af
	push hl
	ld de, 10
	call SubstractHP
	ld a, [wLoadedCard2ID]
	ld [wTempNonTurnDuelistCardID], a
	ld hl, 10
	call LoadTxRam3
	ld hl, wLoadedCard2Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ldtx hl, ReceivesDamageDueToStrikesBackText
	call DrawWideTextBox_WaitForInput
	pop hl
	pop af
	or a
	jr z, .not_knocked_out
	xor a
	call PrintPlayAreaCardKnockedOutIfNoHP
.not_knocked_out
	call SwapTurn
	pop de
	pop hl
	ret
; 0x337f

; return carry if NShield or Transparency activate, and print their corresponding text if so
HandleNShieldAndTransparency: ; 337f (0:337f)
	push de
	ld a, DUELVARS_ARENA_CARD
	add e
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp MEW1
	jr z, .nshield
	cp HAUNTER1
	jr z, .transparency
.done
	pop de
	or a
	ret
.nshield
	ld a, DUELVARS_ARENA_CARD_STAGE
	call GetNonTurnDuelistVariable
	or a
	jr z, .done
	ld a, NO_DAMAGE_OR_EFFECT_NSHIELD
	ld [wNoDamageOrEffect], a
	ldtx hl, NoDamageOrEffectDueToNShieldText
.print_text
	call DrawWideTextBox_WaitForInput
	pop de
	scf
	ret
.transparency
	xor a
	ld [wcac2], a
	ldtx de, TransparencyCheckText
	call TossCoin
	jr nc, .done
	ld a, NO_DAMAGE_OR_EFFECT_TRANSPARENCY
	ld [wNoDamageOrEffect], a
	ldtx hl, NoDamageOrEffectDueToTransparencyText
	jr .print_text
; 0x33c1

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
	call CheckCannotUseDueToStatus
	ccf
	ret nc
.pkmn_power
	ld a, [wTempNonTurnDuelistCardID]
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
	ld a, [wDamageToSelfMode]
	or a
	ret nz
	; prevent damage if attacked by a non-basic Pokemon
	ld a, [wTempTurnDuelistCardID]
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer2_FromCardID
	ld a, [wLoadedCard2Stage]
	or a
	ret z
	ld e, NO_DAMAGE_OR_EFFECT_NSHIELD
	ldtx hl, NoDamageOrEffectDueToNShieldText
	jr .no_damage_or_effect

; if the Pokemon being attacked is Haunter1, and its Transparency is active,
; there is a 50% chance that any damage or effect is prevented
; return carry if damage is prevented
HandleTransparency: ; 348a (0:348a)
	ld a, [wTempNonTurnDuelistCardID]
	cp HAUNTER1
	jr z, .transparency
.done
	or a
	ret
.transparency
	ld a, [wLoadedMoveCategory]
	cp POKEMON_POWER
	jr z, .done ; Transparency has no effect against Pkmn Powers
	ld a, [wTempPlayAreaLocationOffset_cceb]
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	jr c, .done
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

; return carry if turn holder has Omanyte and its Clairvoyance Pkmn Power is active
IsClairvoyanceActive: ; 34e2 (0:34e2)
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	ccf
	ret nc
	ld a, OMANYTE
	call CountPokemonIDInPlayArea
	ret

; returns carry if paralyzed, asleep, confused, and/or toxic gas in play,
; meaning that move and/or pkmn power cannot be used
CheckCannotUseDueToStatus: ; 34ef (0:34ef)
	xor a

; same as above, but if a is non-0, only toxic gas is checked
CheckCannotUseDueToStatus_OnlyToxicGasIfANon0: ; 34f0 (0:34f0)
	or a
	jr nz, .check_toxic_gas
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	ldtx hl, CannotUseDueToStatusText
	scf
	jr nz, .done ; return carry
.check_toxic_gas
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	ldtx hl, UnableDueToToxicGasText
.done
	ret

; return, in a, the amount of times that the Pokemon card with a given ID is found in the
; play area of both duelists. Also return carry if the Pokemon card is at least found once.
; if the arena Pokemon is asleep, confused, or paralyzed (Pkmn Power-incapable), it doesn't count.
; input: a = Pokemon card ID to search
CountPokemonIDInBothPlayAreas: ; 3509 (0:3509)
	push bc
	ld [wTempPokemonID_ce7e], a
	call CountPokemonIDInPlayArea
	ld c, a
	call SwapTurn
	ld a, [wTempPokemonID_ce7e]
	call CountPokemonIDInPlayArea
	call SwapTurn
	add c
	or a
	scf
	jr nz, .found
	or a
.found
	pop bc
	ret

; return, in a, the amount of times that the Pokemon card with a given ID is found in the
; turn holder's play area. Also return carry if the Pokemon card is at least found once.
; if the arena Pokemon is asleep, confused, or paralyzed (Pkmn Power-incapable), it doesn't count.
; input: a = Pokemon card ID to search
CountPokemonIDInPlayArea: ; 3525 (0:3525)
	push hl
	push de
	push bc
	ld [wTempPokemonID_ce7e], a
	ld c, $0
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp -1
	jr z, .check_bench
	call GetCardIDFromDeckIndex
	ld a, [wTempPokemonID_ce7e]
	cp e
	jr nz, .check_bench
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	and CNF_SLP_PRZ
	jr nz, .check_bench
	inc c
.check_bench
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.next_bench_slot
	ld a, [hli]
	cp -1
	jr z, .done
	call GetCardIDFromDeckIndex
	ld a, [wTempPokemonID_ce7e]
	cp e
	jr nz, .skip
	inc c
.skip
	inc b
	jr .next_bench_slot
.done
	ld a, c
	or a
	scf
	jr nz, .found
	or a
.found
	pop bc
	pop de
	pop hl
	ret
; 0x356a

; return, in a, the retreat cost of the card in wLoadedCard1,
; adjusting for any Dodrio's Retreat Aid Pkmn Power that is active.
GetLoadedCard1RetreatCost: ; 356a (0:356a)
	ld c, 0
	ld a, DUELVARS_BENCH
	call GetTurnDuelistVariable
.check_bench_loop
	ld a, [hli]
	cp -1
	jr z, .no_more_bench
	call GetCardIDFromDeckIndex
	ld a, e
	cp DODRIO
	jr nz, .not_dodrio
	inc c
.not_dodrio
	jr .check_bench_loop
.no_more_bench
	ld a, c
	or a
	jr nz, .dodrio_found
.muk_found
	ld a, [wLoadedCard1RetreatCost] ; return regular retreat cost
	ret
.dodrio_found
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	jr c, .muk_found
	ld a, [wLoadedCard1RetreatCost]
	sub c ; apply Retreat Aid for each Pkmn Power-capable Dodrio
	ret nc
	xor a
	ret
; 0x3597

; return carry if the turn holder's active Pokemon is affected by Acid and can't retreat
CheckCantRetreatDueToAcid: ; 3597 (0:3597)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	ret z
	cp SUBSTATUS2_UNABLE_RETREAT
	jr z, .cant_retreat
	or a
	ret
.cant_retreat
	ldtx hl, UnableToRetreatDueToAcidText
	scf
	ret
; 0x35a9

; return carry if the turn holder's active Pokemon is affected by Headache and trainer cards can't be used
CheckCantUseTrainerDueToHeadache: ; 35a9 (0:35a9)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetTurnDuelistVariable
	or a
	bit SUBSTATUS3_HEADACHE, [hl]
	ret z
	ldtx hl, UnableToUseTrainerDueToHeadacheText
	scf
	ret
; 0x35b7

; return carry if turn holder has Aerodactyl and its Prehistoric Power Pkmn Power is active
IsPrehistoricPowerActive: ; 35b7 (0:35b7)
	ld a, AERODACTYL
	call CountPokemonIDInBothPlayAreas
	ret nc
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	ldtx hl, UnableToEvolveDueToPrehistoricPowerText
	ccf
	ret
; 0x35c7

; clears some substatus 2 conditions from the turn holder's active Pokemon
Func_35c7: ; 35c7 (0:35c7)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetTurnDuelistVariable
	or a
	ret z
	cp SUBSTATUS2_REDUCE_BY_20
	jr z, .zero
	cp SUBSTATUS2_POUNCE
	jr z, .zero
	cp SUBSTATUS2_GROWL
	jr z, .zero
	cp SUBSTATUS2_TAIL_WAG
	jr z, .zero
	cp SUBSTATUS2_LEER
	jr z, .zero
	ret
.zero
	ld [hl], 0
	ret
; 0x35e6

; clears the substatus 1 and updates the double damage condition of the player about to start his turn
UpdateSubstatusConditions_StartOfTurn: ; 35e6 (0:35e6)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	ld [hl], $0
	or a
	ret z
	cp SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE
	ret nz
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetTurnDuelistVariable
	set SUBSTATUS3_THIS_TURN_DOUBLE_DAMAGE, [hl]
	ret

; clears the substatus 2, Headache, and updates the double damage condition of the player ending his turn
UpdateSubstatusConditions_EndOfTurn: ; 35fa (0:35fa)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetTurnDuelistVariable
	res SUBSTATUS3_HEADACHE, [hl]
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
	res SUBSTATUS3_THIS_TURN_DOUBLE_DAMAGE, [hl]
	ret
; 0x3615

; return carry if turn holder has Blastoise and its Rain Dance Pkmn Power is active
IsRainDanceActive: ; 3615 (0:3615)
	ld a, BLASTOISE
	call CountPokemonIDInPlayArea
	ret nc ; return if no Pkmn Power-capable Blastoise found in turn holder's play area
	ld a, MUK
	call CountPokemonIDInBothPlayAreas
	ccf
	ret
; 0x3622

; return carry if card at [hTempCardIndex_ff98] is a water energy card AND
; if card at [hTempPlayAreaLocationOffset_ff9d] is a water Pokemon card.
CheckRainDanceScenario: ; 3622 (0:3622)
	ldh a, [hTempCardIndex_ff98]
	call GetCardIDFromDeckIndex
	call GetCardType
	cp TYPE_ENERGY_WATER
	jr nz, .done
	ldh a, [hTempPlayAreaLocationOffset_ff9d]
	call GetPlayAreaCardColor
	cp TYPE_PKMN_WATER
	jr nz, .done
	scf
	ret
.done
	or a
	ret
; 0x363b

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
	cp -1
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
	call LoadCardDataToBuffer2_FromDeckIndex
	ld hl, wLoadedCard2Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ldtx hl, KnockedOutDueToDestinyBondText
	call DrawWideTextBox_WaitForInput
	ret
; 0x367b

; when Machamp is damaged, if its Strikes Back is active,
; the attacking Pokemon takes 10 damage.
; used to bounce back a move of the RESIDUAL category
HandleStrikesBack_AgainstResidualMove: ; 367b (0:367b)
	ld a, [wTempNonTurnDuelistCardID]
	cp MACHAMP
	jr z, .strikes_back
	ret
.strikes_back
	ld a, [wLoadedMoveCategory]
	and RESIDUAL
	ret nz
	ld a, [wTempDamage_ccbf]
	or a
	ret z
	call SwapTurn
	call CheckCannotUseDueToStatus
	call SwapTurn
	ret c
	ld hl, 10 ; damage to be dealt to attacker
	call ApplyStrikesBack_AgainstResidualMove
	call nc, WaitForWideTextBoxInput
	ret

ApplyStrikesBack_AgainstResidualMove: ; 36a2 (0:36a2)
	push hl
	call LoadTxRam3
	ld a, [wTempTurnDuelistCardID]
	ld e, a
	ld d, $0
	call LoadCardDataToBuffer2_FromCardID
	ld hl, wLoadedCard2Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
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
	call PrintPlayAreaCardKnockedOutIfNoHP
	call $503a
	scf
	ret
; 0x36d9

; if the id of the card provided in register a as a deck index is Muk,
; clear the changed type of all arena and bench Pokemon
ClearChangedTypesIfMuk: ; 36d9 (0:36d9)
	call GetCardIDFromDeckIndex
	ld a, e
	cp MUK
	ret nz
	call SwapTurn
	call .zero_changed_types
	call SwapTurn
.zero_changed_types
	ld a, DUELVARS_ARENA_CARD_CHANGED_TYPE
	call GetTurnDuelistVariable
	ld c, MAX_PLAY_AREA_POKEMON
.zero_changed_types_loop
	xor a
	ld [hli], a
	dec c
	jr nz, .zero_changed_types_loop
	ret
; 0x36f6

; return the turn holder's arena card's color in a, accounting for Venomoth's Shift Pokemon Power if active
GetArenaCardColor: ; 36f6 (0:36f6)
	xor a
;	fallthrough

; input: a = play area location offset (PLAY_AREA_*) of the desired card
; return the turn holder's card's color in a, accounting for Venomoth's Shift Pokemon Power if active
GetPlayAreaCardColor: ; 36f7 (0:36f7)
	push hl
	push de
	ld e, a
	add DUELVARS_ARENA_CARD_CHANGED_TYPE
	call GetTurnDuelistVariable
	bit 7, a
	jr nz, .has_changed_color
.regular_color
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	call GetCardType
	cp TYPE_TRAINER
	jr nz, .got_type
	ld a, COLORLESS
.got_type
	pop de
	pop hl
	ret
.has_changed_color
	ld a, e
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	jr c, .regular_color ; jump if can't use Shift
	ld a, e
	add DUELVARS_ARENA_CARD_CHANGED_TYPE
	call GetTurnDuelistVariable
	pop de
	pop hl
	and $f
	ret
; 0x3729

; return in a the weakness of the turn holder's arena or benchx Pokemon given the PLAY_AREA_* value in a
; if a == 0 and [DUELVARS_ARENA_CARD_CHANGED_WEAKNESS] != 0,
; return [DUELVARS_ARENA_CARD_CHANGED_WEAKNESS] instead
GetPlayAreaCardWeakness: ; 3729 (0:3729)
	or a
	jr z, GetArenaCardWeakness
	add DUELVARS_ARENA_CARD
	jr GetCardWeakness

; return in a the weakness of the turn holder's arena Pokemon
; if [DUELVARS_ARENA_CARD_CHANGED_WEAKNESS] != 0, return it instead
GetArenaCardWeakness: ; 3730 (0:3730)
	ld a, DUELVARS_ARENA_CARD_CHANGED_WEAKNESS
	call GetTurnDuelistVariable
	or a
	ret nz
	ld a, DUELVARS_ARENA_CARD
;	fallthrough

GetCardWeakness:
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Weakness]
	ret
; 0x3743

; return in a the resistance of the turn holder's arena or benchx Pokemon given the PLAY_AREA_* value in a
; if a == 0 and [DUELVARS_ARENA_CARD_CHANGED_RESISTANCE] != 0,
; return [DUELVARS_ARENA_CARD_CHANGED_RESISTANCE] instead
GetPlayAreaCardResistance: ; 3743 (0:3743)
	or a
	jr z, GetArenaCardResistance
	add DUELVARS_ARENA_CARD
	jr GetCardResistance

; return in a the resistance of the arena Pokemon
; if [DUELVARS_ARENA_CARD_CHANGED_RESISTANCE] != 0, return it instead
GetArenaCardResistance: ; 374a (0:374a)
	ld a, DUELVARS_ARENA_CARD_CHANGED_RESISTANCE
	call GetTurnDuelistVariable
	or a
	ret nz
	ld a, DUELVARS_ARENA_CARD
;	fallthrough

GetCardResistance:
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Resistance]
	ret
; 0x375d

; this function checks if charizard's energy burn is active, and if so
; turns all energies except double colorless energies into fire energies
HandleEnergyBurn: ; 375d (0:375d)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	cp CHARIZARD
	ret nz
	xor a
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret c
	ld hl, wAttachedEnergies
	ld c, NUM_COLORED_TYPES
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

PauseSong: ; 379b (0:379b)
	farcall _PauseSong
	ret

ResumeSong: ; 37a0 (0:37a0)
	farcall _ResumeSong
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
	call PauseSong
	ld a, MUSIC_CARD_POP
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
	call ResumeSong
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
	ld a, MUSIC_CARD_POP
	call PlaySong
	bank1call Func_758f
	scf
	ret

Func_38c0: ; 38c0 (0:38c0)
	ld a, $1
	ld [wd0c2], a
	xor a
	ld [wd112], a
	call EnableSRAM
	xor a
	ld [$ba44], a
	call DisableSRAM
	call Func_3a3b
	bank1call StartDuel
	scf
	ret

Func_38db: ; 38db (0:38db)
	ld a, $6
	ld [wd111], a
	call Func_39fc
	call EnableSRAM
	xor a
	ld [$ba44], a
	call DisableSRAM
.asm_38ed
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
	call EnableSRAM
	ld a, [$ba44]
	call DisableSRAM
	cp $ff
	jr z, Func_38db.asm_38ed
	scf
	ret

Credits_3911: ; 3911 (0:3911)
	farcall Credits_1d6ad
	or a
	ret

Func_3917: ; 3917 (0:3917)
	ld a, $22
	farcall CheckIfEventFlagSet
	call EnableSRAM
	ld [sa00a], a
	call DisableSRAM
	ret

GetFloorObjectFromPos: ; 3927 (0:3927)
	push hl
	call FindFloorTileFromPos
	ld a, [hl]
	pop hl
	ret
; 0x392e

SetFloorObjectFromPos: ; 392e (0:392e)
	push hl
	push af
	call FindFloorTileFromPos
	pop af
	ld [hl], a
	pop hl
	ret
; 0x3937

UpdateFloorObjectFromPos: ; 3937 (0:3937)
	push hl
	push bc
	push de
	cpl
	ld e, a
	call FindFloorTileFromPos
	ld a, [hl]
	and e
	ld [hl], a
	pop de
	pop bc
	pop hl
	ret
; 0x3946

; puts a floor tile in hl given coords in bc (x,y. measured in tiles)
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
	db $00, -$01, $01, $00, $00, $01, -$01, $00

; Movement offsets for scripted movements
ScriptedMovementOffsetTable: ; 3973 (0:3973)
	db  0, -2 ; move 2 tiles up
	db  2,  0 ; move 2 tiles right
	db  0,  2 ; move 2 tiles down
	db -2,  0 ; move 2 tiles left

Unknown_397b: ; 397b (0:397b)
	dw $0323
	dw $0323
	dw $0324
	dw $0325
	dw $0326
	dw $0327
	dw $0328
	dw $0329
	dw $032a
	dw $032b
	dw $032c
	dw $032d
	dw $032e
	dw $032f

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
	debug_ret
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
	ld bc, wd34a
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
	ld hl, wd34a
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

Func_39ea: ; 39ea (0:39ea)
	push bc
	ldh a, [hBankROM]
	push af
	ld a, $03
	call BankswitchHome
	ld a, [bc]
	ld c, a
	pop af
	call BankswitchHome
	ld a, c
	pop bc
	ret
; 0x39fc

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
	ld hl, wd112
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

Func_3a45: ; 3a45 (0:3a45)
	farcall Func_11343
	ret
; 0x3a4a

Func_3a4a: ; 3a4a (0:3a4a)
	farcall Func_115a3
	ret
; 0x3a4f

Func_3a4f: ; 3a4f (0:3a4f)
	push af
	push bc
	push de
	push hl
	ld c, $00
	farcall Func_1157c
	pop hl
	pop de
	pop bc
	pop af
	ret
; 0x3a5e

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

Func_3ae8: ; 3ae8 (0:3ae8)
	farcall Func_11f4e
	ret
; 0x3aed

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

Func_3b11: ; 3b11 (0:3b11)
	ldh a, [hBankROM]
	push af
	ld a, $04
	call BankswitchHome
	call $66d1
	pop af
	call BankswitchHome
	ret
; 0x3b21

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
	call InitSpritePositions
	ld a, $1
	ld [wVBlankOAMCopyToggle], a
	pop af
	call BankswitchHome
	ret

Func_3b52: ; 3b52 (0:3b52)
	push hl
	push bc
	ld a, [wd42a]
	ld hl, wd4c0
	and [hl]
	ld hl, wd423
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
	ld hl, wd4ad
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

Func_3be4: ; 3be4 (0:3be4)
	ldh a, [hBankROM]
	push af
	ld a, [wd4c6]
	call BankswitchHome
	call Func_08de
	pop af
	call BankswitchHome
	ret
; 0x3bf5

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

Func_3c46: ; 3c46 (0:3c46)
	push bc
	ret
; 0x3c48

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
	ldh [hffb6], a
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
	ldh a, [hffb6]
	dec a
	jr nz, .asm_3c63
	ret

Func_3c83: ; 3c83 (0:3c83)
	call PlaySong
	ret
; 0x3c87

Func_3c87: ; 3c87 (0:3c87)
	push af
	call PauseSong
	pop af
	call PlaySong
	call Func_3c96
	call ResumeSong
	ret
; 0x3c96

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
	ld c, SPRITE_ANIM_FIELD_00
	call GetSpriteAnimBufferProperty
	pop bc
	ret

; return hl pointing to the property (byte) c of a sprite in wSpriteAnimBuffer.
; the sprite is identified by its index in wWhichSprite.
GetSpriteAnimBufferProperty: ; 3dbf (0:3dbf)
	ld a, [wWhichSprite]
	cp SPRITE_ANIM_BUFFER_CAPACITY
	jr c, .got_sprite
	debug_ret
	ld a, SPRITE_ANIM_BUFFER_CAPACITY - 1 ; default to last sprite
.got_sprite
	push bc
	swap a ; a *= SPRITE_ANIM_LENGTH
	push af
	and $f
	ld b, a
	pop af
	and $f0
	or c ; add the property offset
	ld c, a
	ld hl, wSpriteAnimBuffer
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
