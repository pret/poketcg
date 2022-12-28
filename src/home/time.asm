; timer interrupt handler
TimerHandler::
	push af
	push hl
	push de
	push bc
	ei
	call SerialTimerHandler
	; only trigger every fourth interrupt ≈ 60.24 Hz
	ld hl, wTimerCounter
	ld a, [hl]
	inc [hl]
	and $3
	jr nz, .done
	; increment the 60-60-60-255-255 counter
	call IncrementPlayTimeCounter
	; check in-timer flag
	ld hl, wReentrancyFlag
	bit IN_TIMER, [hl]
	jr nz, .done
	set IN_TIMER, [hl]
	ldh a, [hBankROM]
	push af
	ld a, BANK(SoundTimerHandler)
	call BankswitchROM
	call SoundTimerHandler
	pop af
	call BankswitchROM
	; clear in-timer flag
	ld hl, wReentrancyFlag
	res IN_TIMER, [hl]
.done
	pop bc
	pop de
	pop hl
	pop af
	reti

; increment play time counter by a tick
IncrementPlayTimeCounter::
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
SetupTimer::
	ld b, -68 ; Value for Normal Speed
	call CheckForCGB
	jr c, .set_timer
	ldh a, [rKEY1]
	and $80
	jr z, .set_timer
	ld b, $100 - 2 * 68 ; Value for CGB Double Speed
.set_timer
	ld a, b
	ldh [rTMA], a
	ld a, TAC_16384_HZ
	ldh [rTAC], a
	ld a, TAC_START | TAC_16384_HZ
	ldh [rTAC], a
	ret

; return carry if not CGB
CheckForCGB::
	ld a, [wConsole]
	cp CONSOLE_CGB
	ret z
	scf
	ret
