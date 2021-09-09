ScriptPlaySong: ; 3c83 (0:3c83)
	call PlaySong
	ret

Func_3c87: ; 3c87 (0:3c87)
	push af
	call PauseSong
	pop af
	call PlaySong
	call WaitForSongToFinish
	call ResumeSong
	ret

WaitForSongToFinish: ; 3c96 (0:3c96)
	call DoFrameIfLCDEnabled
	call AssertSongFinished
	or a
	jr nz, WaitForSongToFinish
	ret
