; shows Copyright information for 300 frames
; or until Start button is pressed
UnusedCopyrightScreen: ; unreferenced
	call DisableLCD
	farcall Func_10a9b
	farcall InitMenuScreen
	ld bc, $0
	ld a, SCENE_COPYRIGHT
	call LoadScene
	farcall FadeScreenFromWhite
	ld bc, 300
.loop_frame
	push bc
	call DoFrameIfLCDEnabled
	call UpdateRNGSources
	pop bc
	ldh a, [hKeysPressed]
	and START
	jr nz, .exit
	dec bc
	ld a, b
	or c
	jr nz, .loop_frame
.exit
	farcall FadeScreenToWhite
	ret
