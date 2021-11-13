; a = keys to escape
WaitUntilKeysArePressed:
	push bc
	ld b, a
.loop_input
	push bc
	call DoFrameIfLCDEnabled
	pop bc
	ldh a, [hKeysPressed]
	and b
	jr z, .loop_input
	pop bc
	ret
