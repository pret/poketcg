; enable timer interrupt
EnableInt_Timer::
	ldh a, [rIE]
	or IE_TIMER
	ldh [rIE], a
	ret

; enable vblank interrupt
EnableInt_VBlank::
	ldh a, [rIE]
	or IE_VBLANK
	ldh [rIE], a
	ret

; enable lcdc interrupt on hblank mode
EnableInt_HBlank::
	ldh a, [rSTAT]
	or STAT_MODE_0
	ldh [rSTAT], a
	xor a
	ldh [rIF], a
	ldh a, [rIE]
	or IE_STAT
	ldh [rIE], a
	ret

; disable lcdc interrupt and the hblank mode trigger
DisableInt_HBlank::
	ldh a, [rSTAT]
	and ~STAT_MODE_0
	ldh [rSTAT], a
	xor a
	ldh [rIF], a
	ldh a, [rIE]
	and ~IE_STAT
	ldh [rIE], a
	ret
