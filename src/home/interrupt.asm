; enable timer interrupt
EnableInt_Timer: ; 02dd (0:02dd)
	ldh a, [rIE]
	or 1 << INT_TIMER
	ldh [rIE], a
	ret

; enable vblank interrupt
EnableInt_VBlank: ; 02e4 (0:02e4)
	ldh a, [rIE]
	or 1 << INT_VBLANK
	ldh [rIE], a
	ret

; enable lcdc interrupt on hblank mode
EnableInt_HBlank: ; 02eb (0:02eb)
	ldh a, [rSTAT]
	or 1 << STAT_MODE_HBLANK
	ldh [rSTAT], a
	xor a
	ldh [rIF], a
	ldh a, [rIE]
	or 1 << INT_LCD_STAT
	ldh [rIE], a
	ret

; disable lcdc interrupt and the hblank mode trigger
DisableInt_HBlank: ; 02fb (0:02fb)
	ldh a, [rSTAT]
	and ~(1 << STAT_MODE_HBLANK)
	ldh [rSTAT], a
	xor a
	ldh [rIF], a
	ldh a, [rIE]
	and ~(1 << INT_LCD_STAT)
	ldh [rIE], a
	ret
