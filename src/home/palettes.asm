; Flush all non-CGB and CGB palettes
FlushAllPalettes::
	ld a, FLUSH_ALL_PALS
	jr FlushPalettes

; Flush non-CGB palettes and a single CGB palette,
; provided in a as an index between 0-7 (BGP) or 8-15 (OBP)
FlushPalette::
	or FLUSH_ONE_PAL
	jr FlushPalettes

; Set wBGP to the specified value, flush non-CGB palettes, and the first CGB palette.
SetBGP::
	ld [wBGP], a
;	fallthrough

; Flush non-CGB palettes and the first CGB palette
FlushPalette0::
	ld a, FLUSH_ONE_PAL
;	fallthrough

FlushPalettes::
	ld [wFlushPaletteFlags], a
	ld a, [wLCDC]
	rla
	ret c
	push hl
	push de
	push bc
	call FlushPalettesIfRequested
	pop bc
	pop de
	pop hl
	ret

; Set wOBP0 to the specified value, flush non-CGB palettes, and the first CGB palette.
SetOBP0::
	ld [wOBP0], a
	jr FlushPalette0

; Set wOBP1 to the specified value, flush non-CGB palettes, and the first CGB palette.
SetOBP1::
	ld [wOBP1], a
	jr FlushPalette0

; Flushes non-CGB palettes from [wBGP], [wOBP0], [wOBP1] as well as CGB
; palettes from [wBackgroundPalettesCGB..wBackgroundPalettesCGB+$3f] (BG palette)
; and [wObjectPalettesCGB+$00..wObjectPalettesCGB+$3f] (sprite palette).
; Only flushes if [wFlushPaletteFlags] is nonzero, and only flushes
; a single CGB palette if bit6 of that location is reset.
FlushPalettesIfRequested::
	ld a, [wFlushPaletteFlags]
	or a
	ret z
	; flush grayscale (non-CGB) palettes
	ld hl, wBGP
	ld a, [hli]
	ldh [rBGP], a
	ld a, [hli]
	ldh [rOBP0], a
	ld a, [hl]
	ldh [rOBP1], a
	ld a, [wConsole]
	cp CONSOLE_CGB
	jr z, .CGB
.done
	xor a
	ld [wFlushPaletteFlags], a
	ret
.CGB
	; flush a single CGB BG or OB palette
	; if bit6 (FLUSH_ALL_PALS_F) of [wFlushPaletteFlags] is set, flush all 16 of them
	ld a, [wFlushPaletteFlags]
	bit FLUSH_ALL_PALS_F, a
	jr nz, FlushAllCGBPalettes
	ld b, CGB_PAL_SIZE
	call CopyCGBPalettes
	jr .done

FlushAllCGBPalettes::
	; flush 8 BGP palettes
	xor a
	ld b, 8 palettes
	call CopyCGBPalettes
	; flush 8 OBP palettes
	ld a, CGB_PAL_SIZE
	ld b, 8 palettes
	call CopyCGBPalettes
	jr FlushPalettesIfRequested.done

; copy b bytes of CGB palette data starting at
; (wBackgroundPalettesCGB + a palettes) into rBGPD or rOBPD.
CopyCGBPalettes::
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
	ldh a, [rSTAT]
	and 1 << STAT_BUSY ; wait until hblank or vblank
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
