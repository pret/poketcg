; copy b bytes of data from hl to de, but only during hblank
HblankCopyDataHLtoDE::
	push bc
.loop
	ei
	di
	ldh a, [rSTAT]       ;
	and STAT_LCDC_STATUS ;
	jr nz, .loop         ; assert hblank
	ld a, [hl]
	ld [de], a
	ldh a, [rSTAT]       ;
	and STAT_LCDC_STATUS ;
	jr nz, .loop         ; assert still in hblank
	ei
	inc hl
	inc de
	dec b
	jr nz, .loop
	pop bc
	ret

; copy c bytes of data from de to hl, but only during hblank
HblankCopyDataDEtoHL::
	push bc
.loop
	ei
	di
	ldh a, [rSTAT]       ;
	and STAT_LCDC_STATUS ;
	jr nz, .loop         ; assert hblank
	ld a, [de]
	ld [hl], a
	ldh a, [rSTAT]       ;
	and STAT_LCDC_STATUS ;
	jr nz, .loop         ; assert still in hblank
	ei
	inc hl
	inc de
	dec c
	jr nz, .loop
	pop bc
	ret
