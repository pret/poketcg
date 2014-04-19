Music_Imakuni_Ch1: ; fad55 (3e:6d55)
	Speed 3
	musicdc 17
	musicea 5
	musiceb 20
	musice8 8
	musice5 128
	musice6 160
	MainLoop
	Loop 16
	rest 10
	EndLoop
	music_call Branch_fadf9
	musicdx 4
	note D_, 15
	musicd8
	note B_, 7
	rest 8
	note G_, 7
	rest 8
	Speed 9
	note F_, 10
	musicd9
	Speed 1
	note F_, 7
	rest 8
	Speed 9
	rest 10
	music_call Branch_fadf9
	music_call Branch_fae1d
	Speed 1
	musicdx 4
	note E_, 7
	rest 15
	note E_, 3
	note C_, 2
	note E_, 3
	note C_, 15
	musicd8
	note G#, 15
	note A_, 7
	rest 8
	Speed 3
	rest 15
	Speed 1
	rest 15
	rest 15
	musicd7
	note E_, 7
	rest 8
	note F#, 7
	rest 8
	note G_, 15
	musicd9
	note G_, 7
	note F#, 3
	note G_, 2
	note F#, 3
	note E_, 7
	rest 8
	note D#, 7
	rest 8
	note E_, 15
	note C_, 7
	rest 8
	musicd8
	note G#, 7
	rest 8
	Speed 7
	note F#, 15
	Speed 9
	rest 10
	music_call Branch_fadf9
	music_call Branch_fae1d
	musicd8
	Speed 1
	note F_, 7
	rest 8
	note B_, 7
	musicd7
	note C_, 8
	musicd8
	note G#, 7
	note A_, 8
	note F_, 7
	rest 8
	note B_, 7
	musicd7
	note C_, 8
	musicd8
	note G#, 7
	note A_, 8
	Speed 3
	note F_, 10
	Speed 1
	note D#, 7
	rest 8
	note A_, 7
	note A#, 8
	note F#, 7
	note G_, 8
	note D#, 7
	rest 8
	note A_, 7
	note A#, 8
	note F#, 7
	note G_, 8
	Speed 3
	note D#, 10
	Speed 1
	Loop 4
	note D_, 7
	musicd8
	note A_, 8
	note D_, 7
	note A_, 8
	note D_, 7
	note A_, 8
	musicd7
	EndLoop
	note D_, 7
	musicd8
	note A_, 8
	note D_, 7
	note A_, 8
	musiceb 5
	Speed 3
	note D_, 10
	musiceb 20
	EndMainLoop

Branch_fadf9:
	Speed 1
	musicdx 4
	note C#, 7
	rest 15
	note C#, 3
	note D_, 2
	note C#, 3
	musicd8
	note A#, 15
	note B_, 15
	musicd7
	note D_, 7
	rest 8
	Speed 5
	rest 9
	Speed 1
	rest 15
	rest 15
	note D_, 7
	rest 8
	note E_, 7
	rest 8
	note F_, 15
	musicd9
	note F_, 7
	note E_, 3
	note F_, 2
	note E_, 3
	note D_, 7
	rest 8
	note C#, 7
	rest 8
	music_ret

Branch_fae1d:
	musicdx 4
	note D_, 7
	rest 8
	musicd8
	note G_, 7
	rest 8
	musicd7
	note G_, 7
	rest 8
	Speed 9
	note F_, 10
	musicd9
	Speed 1
	note F_, 7
	rest 8
	Speed 9
	rest 10
	music_ret


Music_Imakuni_Ch2: ; fae32 (3e:6e32)
	musicdc 17
	musicea 0
	musiceb 0
	musice8 8
	musice5 64
	musice6 160
	Loop 6
	music_call Branch_faea5
	EndLoop
	Loop 2
	Loop 2
	Speed 3
	rest 10
	Speed 1
	note C_, 7
	rest 8
	EndLoop
	rest 15
	note C_, 7
	rest 8
	Speed 3
	rest 10
	Speed 1
	note C_, 7
	rest 8
	rest 15
	Speed 3
	rest 10
	musiceb 8
	note C_, 10
	musiceb 0
	EndLoop
	Loop 2
	music_call Branch_faea5
	EndLoop
	Speed 1
	musicdx 2
	note F_, 15
	musicd9
	note F_, 7
	musicd7
	note F_, 8
	note D#, 7
	rest 8
	rest 15
	note G#, 7
	note A_, 8
	note F_, 7
	note D#, 8
	Speed 3
	rest 10
	Speed 1
	musicd8
	note D#, 15
	musicd9
	note D#, 7
	musicd7
	note D#, 8
	note C#, 7
	rest 8
	rest 15
	note F#, 7
	note G_, 8
	note D#, 7
	note C#, 8
	Speed 3
	rest 10
	Speed 1
	Loop 4
	note D_, 7
	rest 8
	Loop 2
	rest 15
	EndLoop
	EndLoop
	note D_, 7
	rest 8
	rest 15
	musiceb 5
	note D_, 15
	musicd9
	note D_, 7
	rest 8
	musiceb 0
	EndMainLoop

Branch_faea5:
	musicdx 3
	Speed 6
	rest 10
	Speed 1
	Loop 2
	rest 15
	note C#, 7
	rest 8
	EndLoop
	musiceb 8
	Speed 9
	rest 10
	Speed 3
	note C#, 10
	musiceb 0
	music_ret


Music_Imakuni_Ch3: ; faebc (3e:6ebc)
	musicdc 17
	musice6 32
	musice7 1
	musicea 6
	musiceb 0
	musice9 0
	musice8 8
	MainLoop
	music_call Branch_faf7d
	musiceb 8
	Speed 1
	note D_, 15
	musicd9
	note D_, 7
	musicd7
	musiceb 0
	note G_, 3
	musicd8
	note G_, 2
	musicd8
	note G_, 3
	music_call Branch_faf7d
	musiceb 8
	note D_, 10
	musiceb 0
	Loop 4
	music_call Branch_faf7d
	musiceb 8
	note D_, 10
	musiceb 0
	EndLoop
	Loop 2
	musicdx 2
	Speed 3
	note C_, 5
	rest 5
	musicd7
	Speed 1
	note E_, 7
	rest 8
	musicd8
	Speed 3
	note G#, 5
	note A_, 5
	musicd7
	Speed 1
	note D#, 7
	rest 8
	rest 15
	note D#, 7
	rest 8
	Speed 3
	rest 5
	musicd8
	note C_, 5
	musicd7
	Speed 1
	note E_, 7
	rest 8
	musicd8
	Speed 3
	note G#, 5
	note A_, 5
	rest 5
	musicd7
	musiceb 8
	note D#, 10
	musiceb 0
	EndLoop
	Loop 2
	music_call Branch_faf7d
	musiceb 8
	note D_, 10
	musiceb 0
	EndLoop
	Speed 1
	musicdx 1
	note F_, 15
	musicd9
	note F_, 7
	musicd7
	note F_, 8
	note D#, 7
	rest 8
	note F_, 7
	rest 8
	note G#, 7
	note A_, 8
	note F_, 7
	note D#, 8
	musiceb 5
	Speed 3
	note F_, 10
	musiceb 0
	Speed 1
	musicd8
	note D#, 15
	musicd9
	note D#, 7
	musicd7
	note D#, 8
	note C#, 7
	rest 8
	note D#, 7
	rest 8
	note F#, 7
	note G_, 8
	note D#, 7
	note C#, 8
	musiceb 5
	Speed 3
	note D#, 10
	musiceb 0
	Speed 1
	Loop 4
	musicdx 3
	note C_, 7
	rest 8
	musicdx 1
	note D_, 7
	rest 8
	note D_, 7
	rest 8
	EndLoop
	musicdx 3
	note C_, 7
	rest 8
	musicdx 1
	note D_, 7
	rest 8
	musicdx 3
	musiceb 5
	note C_, 15
	musicd9
	note C_, 7
	musicd7
	musiceb 0
	note G_, 3
	musicd8
	note G_, 2
	musicd8
	note G_, 3
	Speed 8
	EndMainLoop

Branch_faf7d:
	Speed 3
	musicdx 1
	note G_, 5
	rest 5
	musicd7
	Speed 1
	note G_, 7
	rest 8
	Speed 3
	note C#, 5
	note D_, 5
	musicd7
	Speed 1
	note D_, 7
	rest 8
	rest 15
	note D_, 7
	rest 8
	Speed 3
	rest 5
	musicdx 1
	note G_, 5
	musicd7
	Speed 1
	note G_, 7
	rest 8
	Speed 3
	note C#, 5
	note D_, 5
	rest 5
	musicd7
	music_ret


Music_Imakuni_Ch4: ; fafa4 (3e:6fa4)
	Speed 1
	musicdx 1
	Loop 10
	note bass, 15
	note snare3, 7
	note bass, 8
	note snare1, 15
	note bass, 15
	note snare3, 7
	note snare3, 8
	note snare4, 15
	note snare3, 7
	note snare3, 8
	note snare4, 15
	note snare3, 15
	note bass, 15
	note snare1, 15
	note snare4, 15
	note bass, 7
	note snare3, 8
	note snare1, 15
	note snare1, 15
	note snare3, 7
	note snare1, 8
	EndLoop
	Loop 2
	Speed 11
	note snare5, 2
	Speed 1
	note snare1, 8
	note snare1, 15
	note snare1, 15
	note snare1, 7
	note snare1, 8
	note snare1, 7
	note snare1, 8
	Speed 3
	note snare5, 10
	EndLoop
	Speed 1
	note snare1, 15
	note snare3, 7
	note snare1, 8
	note snare4, 15
	note snare1, 15
	note snare3, 7
	note snare1, 8
	note snare4, 15
	note snare1, 15
	note snare3, 7
	note snare1, 8
	note snare4, 15
	note snare1, 15
	note snare3, 7
	note snare1, 8
	note snare4, 15
	note snare1, 15
	note snare3, 4
	note snare3, 4
	note snare1, 7
	note snare1, 15
	note snare1, 15
	EndMainLoop
; 0xfafea