DoFrameIfLCDEnabled::
	push af
	ldh a, [rLCDC]
	bit LCDC_ENABLE_F, a
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
