DoFrameIfLCDEnabled::
	push af
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
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
