; copy DMA to hDMAFunction
CopyDMAFunction::
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
DMA::
	ld a, HIGH(wOAM)
	ldh [rDMA], a
	ld a, 40
.wait
	dec a
	jr nz, .wait
	ret
