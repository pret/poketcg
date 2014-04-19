Music_PauseMenu_Ch2: ; f6bb7 (3d:6bb7)
	Speed 7
	musicdc 17
	musice8 8
	musice5 128
	MainLoop
	musice6 112
	Loop 4
	rest 16
	EndLoop
	Speed 1
	musicdx 6
	note C_, 4
	musicd8
	rest 3
	note B_, 4
	musicd7
	musice6 55
	note C_, 3
	musicd8
	musice6 112
	note G_, 4
	musice6 55
	note B_, 3
	musice6 112
	note D_, 4
	musice6 55
	note G_, 3
	music_call Branch_f6c24
	music_call Branch_f6c60
	musice6 112
	musicdx 6
	note C_, 4
	musicd8
	musice6 55
	note E_, 3
	musice6 112
	note B_, 4
	musicd7
	musice6 55
	note C_, 3
	musicd8
	musice6 112
	note G_, 4
	musice6 55
	note B_, 3
	musice6 112
	note D_, 4
	musice6 55
	note G_, 3
	music_call Branch_f6c24
	music_call Branch_f6c60
	musicdx 6
	musice6 96
	note C_, 4
	musicd8
	musice6 55
	note E_, 3
	music_call Branch_f6ce9
	music_call Branch_f6c80
	Loop 3
	musicdx 6
	musice8 4
	note C_, 1
	music_call Branch_f6ce9
	music_call Branch_f6c80
	EndLoop
	musice8 8
	EndMainLoop

Branch_f6c24:
	Loop 3
	musicdx 6
	musice6 112
	note C_, 4
	musicd8
	musice6 55
	note D_, 3
	musice6 112
	note B_, 4
	musicd7
	musice6 55
	note C_, 3
	musicd8
	musice6 112
	note G_, 4
	musice6 55
	note B_, 3
	musice6 112
	note D_, 4
	musice6 55
	note G_, 3
	EndLoop
	musicd7
	musice6 112
	note C_, 4
	musicd8
	musice6 55
	note D_, 3
	musice6 112
	note B_, 4
	musicd7
	musice6 55
	note C_, 3
	musicd8
	musice6 112
	note G_, 4
	musice6 55
	note B_, 3
	musice6 112
	note E_, 4
	musice6 55
	note G_, 3
	music_ret

Branch_f6c60:
	Loop 3
	musicdx 6
	musice6 112
	note C_, 4
	musicd8
	musice6 55
	note E_, 3
	musice6 112
	note B_, 4
	musicd7
	musice6 55
	note C_, 3
	musicd8
	musice6 112
	note G_, 4
	musice6 55
	note B_, 3
	musice6 112
	note E_, 4
	musice6 55
	note G_, 3
	EndLoop
	music_ret

Branch_f6c80:
	musicdx 6
	musice8 4
	note C_, 1
	musicdx 3
	musice6 112
	musice8 8
	Speed 1
	note C_, 4
	musice6 39
	note C_, 3
	musice6 96
	Speed 7
	musicdx 5
	musice8 4
	note G_, 1
	note E_, 1
	musicdx 3
	musice8 8
	musice6 112
	Speed 1
	note E_, 4
	musice6 39
	note E_, 3
	Speed 7
	musice6 96
	musicdx 5
	musice8 4
	note B_, 1
	note G_, 1
	musicd8
	musice6 112
	musice8 8
	Speed 1
	note C_, 4
	musice6 39
	note C_, 3
	musice6 96
	Speed 7
	musicdx 6
	musice8 4
	note C_, 1
	musicdx 3
	musice8 8
	musice6 112
	Speed 1
	note C_, 4
	musice6 39
	note C_, 3
	Speed 7
	musicdx 5
	musice6 96
	musice8 4
	note G_, 1
	note E_, 1
	musice6 112
	musicdx 3
	musice8 8
	Speed 1
	note E_, 4
	musice6 39
	note E_, 3
	Speed 7
	musice6 96
	musicdx 5
	musice8 4
	note B_, 1
	note G_, 1
	note E_, 1
	music_ret

Branch_f6ce9:
	musicdx 2
	Speed 1
	musice8 8
	musice6 112
	note B_, 4
	musice6 39
	note B_, 3
	Speed 7
	musice6 96
	musicdx 5
	musice8 4
	note G_, 1
	note D_, 1
	musicdx 3
	musice6 112
	musice8 8
	Speed 1
	note D_, 4
	musice6 39
	note D_, 3
	Speed 7
	musice6 96
	musicdx 5
	musice8 4
	note B_, 1
	note G_, 1
	musice6 112
	musicdx 3
	musice8 8
	Speed 1
	note B_, 4
	musice6 39
	note B_, 3
	musice6 96
	Speed 7
	musicdx 6
	musice8 4
	note C_, 1
	musice6 112
	musicdx 2
	musice8 8
	Speed 1
	note B_, 4
	musice6 39
	note B_, 3
	Speed 7
	musice6 96
	musicdx 5
	musice8 4
	note G_, 1
	note D_, 1
	musice6 112
	musicdx 3
	musice8 8
	Speed 1
	note D_, 4
	musice6 39
	note D_, 3
	Speed 7
	musice6 96
	musicdx 5
	musice8 4
	note B_, 1
	note G_, 1
	note D_, 1
	music_ret


Music_PauseMenu_Ch1: ; f6d4e (3d:6d4e)
	Speed 7
	musicdc 17
	musice8 8
	musice5 128
	MainLoop
	musice6 128
	Loop 7
	rest 16
	EndLoop
	musicdx 5
	rest 8
	Speed 1
	Loop 4
	note B_, 4
	note G_, 3
	note E_, 4
	note C_, 3
	musicd8
	EndLoop
	Speed 7
	Loop 4
	musicdx 1
	musice6 208
	note G_, 1
	musicdx 3
	musice6 112
	Speed 1
	note D_, 4
	musice6 39
	note D_, 3
	musice6 208
	Speed 7
	musicdx 1
	musice8 6
	note G_, 1
	musice8 4
	note G_, 1
	musicdx 3
	musice8 8
	musice6 112
	Speed 1
	note F#, 4
	musice6 39
	note F#, 3
	musicd8
	musice6 208
	Speed 7
	note D_, 1
	note G_, 1
	musicdx 4
	musice6 112
	Speed 1
	note F#, 4
	musice6 39
	note F#, 3
	Speed 7
	musicdx 1
	musice6 208
	musice8 8
	note G_, 1
	musicdx 3
	musice6 112
	Speed 1
	note D_, 4
	musice6 39
	note D_, 3
	Speed 7
	musice6 208
	musicdx 1
	musice8 6
	note G_, 1
	musice8 4
	note G_, 1
	musicdx 3
	musice8 8
	Speed 1
	note F#, 4
	musice6 39
	note F#, 3
	Speed 7
	musicdx 1
	musice6 208
	note B_, 1
	musicd7
	note C_, 1
	note C#, 1
	musicd8
	note D_, 1
	musicdx 3
	musice6 112
	Speed 1
	note E_, 4
	musice6 39
	note E_, 3
	musice6 208
	Speed 7
	musicdx 1
	musice8 6
	note D_, 1
	musice8 4
	note D_, 1
	musicdx 3
	musice8 8
	Speed 1
	note G_, 4
	musice6 39
	note G_, 3
	Speed 7
	musicd8
	musice6 208
	note C_, 1
	note D_, 1
	musicdx 4
	musice6 112
	Speed 1
	note G_, 4
	musice6 39
	note G_, 3
	Speed 7
	musicdx 1
	musice6 208
	musice8 8
	note D_, 1
	musicdx 3
	musice6 112
	Speed 1
	note E_, 4
	musice6 39
	note E_, 3
	Speed 7
	musice6 208
	musice8 6
	musicdx 1
	note D_, 1
	musice8 4
	note D_, 1
	musicdx 3
	musice8 8
	Speed 1
	note G_, 4
	musice6 39
	note G_, 3
	Speed 7
	musicdx 1
	musice6 208
	note C_, 1
	note C#, 1
	musicd7
	note D_, 1
	EndLoop
	EndMainLoop


Music_PauseMenu_Ch3: ; f6e2d (3d:6e2d)
	Speed 1
	musice7 3
	musicdc 17
	musice6 64
	musice9 96
	musice8 4
	musicdx 4
	note G_, 7
	musice8 8
	note F#, 4
	musice6 96
	note G_, 3
	musice6 64
	note D_, 4
	musice6 96
	note F#, 3
	musicd8
	musice6 64
	note B_, 4
	musicd7
	musice6 96
	note D_, 3
	MainLoop
	musicdx 4
	Loop 3
	musice6 64
	note G_, 4
	musicd8
	musice6 96
	note B_, 3
	musicd7
	musice6 64
	note F#, 4
	musice6 96
	note G_, 3
	musice6 64
	note D_, 4
	musice6 96
	note F#, 3
	musicd8
	musice6 64
	note B_, 4
	musicd7
	musice6 96
	note D_, 3
	EndLoop
	musice6 64
	note G_, 4
	musicd8
	musice6 96
	note B_, 3
	musicd7
	musice6 64
	note E_, 4
	musice6 96
	note G_, 3
	musice6 64
	note C_, 4
	musice6 96
	note E_, 3
	musicd8
	musice6 64
	note A_, 4
	musicd7
	musice6 96
	note C_, 3
	Loop 3
	musice6 64
	note G_, 4
	musicd8
	musice6 96
	note A_, 3
	musicd7
	musice6 64
	note E_, 4
	musice6 96
	note G_, 3
	musice6 64
	note C_, 4
	musice6 96
	note E_, 3
	musicd8
	musice6 64
	note A_, 4
	musicd7
	musice6 96
	note C_, 3
	EndLoop
	musice6 64
	note G_, 4
	musicd8
	musice6 96
	note A_, 3
	musicd7
	musice6 64
	note F#, 4
	musice6 96
	note G_, 3
	musice6 64
	note D_, 4
	musice6 96
	note F#, 3
	musicd8
	musice6 64
	note B_, 4
	musicd7
	musice6 96
	note D_, 3
	EndMainLoop


Music_PauseMenu_Ch4: ; f6ec8 (3d:6ec8)
	Speed 7
	musicdx 1
	MainLoop
	Loop 2
	Loop 7
	note bass, 1
	note snare3, 1
	note snare4, 2
	note snare1, 1
	note snare3, 1
	note snare4, 1
	note snare2, 1
	note bass, 1
	note snare3, 1
	note snare4, 2
	note snare1, 1
	note snare3, 1
	note snare4, 1
	note snare1, 1
	EndLoop
	note bass, 1
	note snare3, 1
	note snare4, 2
	note snare1, 1
	note snare3, 1
	note snare4, 1
	Speed 1
	note snare2, 4
	note snare2, 3
	Speed 7
	Loop 8
	note snare1, 1
	EndLoop
	EndLoop
	EndMainLoop
; 0xf6ef1