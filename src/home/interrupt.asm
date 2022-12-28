; enable timer interrupt
EnableInt_Timer::
	ldh a, [rIE]
	or 1 << INT_TIMER
	ldh [rIE], a
	ret

; enable vblank interrupt
EnableInt_VBlank::
	ldh a, [rIE]
	or 1 << INT_VBLANK
	ldh [rIE], a
	ret

; enable lcdc interrupt on hblank mode
EnableInt_HBlank::
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
DisableInt_HBlank::
	ldh a, [rSTAT]
	and ~(1 << STAT_MODE_HBLANK)
	ldh [rSTAT], a
	xor a
	ldh [rIF], a
	ldh a, [rIE]
	and ~(1 << INT_LCD_STAT)
	ldh [rIE], a
	ret
