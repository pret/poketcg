Music_PCMainMenu_Ch1: ; f9052 (3e:5052)
	Speed 7
	musicdc 17
	musice8 8
	musicdx 3
	musice5 128
	MainLoop
	music_call Branch_f90c2
	rest 4
	musicd8
	musice5 64
	musice8 5
	musice6 97
	note F_, 1
	rest 1
	musice5 128
	musice8 8
	musice6 180
	note A_, 1
	musice6 55
	note A_, 1
	rest 2
	musicd7
	musice6 180
	note C_, 1
	musice6 55
	note C_, 1
	musicd8
	musice5 64
	musice8 5
	musice6 97
	note F_, 1
	rest 1
	musice5 128
	musice8 8
	musice6 180
	note B_, 1
	musice6 55
	note B_, 1
	music_call Branch_f90c2
	rest 4
	musicd8
	musice5 64
	musice8 5
	musice6 97
	note F_, 1
	rest 1
	musicd7
	musice5 128
	musice8 8
	musice6 180
	note E_, 1
	musice6 55
	note E_, 1
	rest 2
	musice6 180
	note C_, 1
	musice6 55
	note C_, 1
	musice5 64
	musice8 5
	musice6 97
	musicd8
	note F_, 1
	rest 1
	musicd7
	musice5 128
	musice8 8
	musice6 180
	note D_, 1
	musice6 55
	note D_, 1
	EndMainLoop

Branch_f90c2:
	musicdx 3
	rest 4
	musice5 64
	musice6 97
	musice8 5
	note G_, 1
	rest 3
	musice8 8
	musice5 128
	musice6 180
	note B_, 2
	musicd7
	note D_, 1
	musice6 39
	note D_, 1
	musicd8
	musice5 64
	musice6 97
	musice8 5
	note G_, 1
	rest 1
	musicd7
	musice5 128
	musice8 8
	musice6 180
	note C_, 1
	musice6 55
	note C_, 1
	music_ret


Music_PCMainMenu_Ch2: ; f90ed (3e:50ed)
	Speed 7
	musicdc 17
	musice8 8
	musicdx 3
	musice5 128
	MainLoop
	music_call Branch_f915e
	rest 4
	musicd7
	musice5 64
	musice8 5
	musice6 97
	note C_, 1
	rest 1
	musicd8
	musice5 128
	musice8 8
	musice6 132
	note F_, 1
	musice6 39
	note F_, 1
	rest 2
	musice6 132
	note A_, 1
	musice6 39
	note A_, 1
	musice5 64
	musice8 5
	musice6 97
	musicd7
	note C_, 1
	rest 1
	musicd8
	musice5 128
	musice8 8
	musice6 132
	note G_, 1
	musice6 39
	note G_, 1
	music_call Branch_f915e
	rest 4
	musicd7
	musice5 64
	musice8 5
	musice6 97
	note C_, 1
	rest 1
	musice5 128
	musice8 8
	musice6 132
	note C_, 1
	musice6 39
	note C_, 1
	rest 2
	musicd8
	musice6 132
	note A_, 1
	musice6 39
	note A_, 1
	musice5 64
	musicd7
	musice6 97
	musice8 5
	note C_, 1
	rest 1
	musicd8
	musice5 128
	musice8 8
	musice6 132
	note B_, 1
	musice6 39
	note B_, 1
	EndMainLoop

Branch_f915e:
	musicdx 4
	rest 4
	musice5 64
	musice8 5
	musice6 97
	note D_, 1
	rest 3
	musice5 128
	musice8 8
	musicd8
	musice6 132
	note G_, 2
	note B_, 1
	musice6 39
	note B_, 1
	musicd7
	musice5 64
	musice8 5
	musice6 97
	note D_, 1
	rest 1
	musicd8
	musice5 128
	musice8 8
	musice6 132
	note A_, 1
	musice6 39
	note A_, 1
	music_ret


Music_PCMainMenu_Ch3: ; f9189 (3e:5189)
	Speed 7
	musice6 32
	musicdc 17
	musice7 1
	musice8 7
	musice9 0
	MainLoop
	musicdx 1
	musice8 7
	note G_, 1
	rest 1
	musice8 8
	note G_, 1
	rest 1
	Speed 1
	note A#, 4
	musicd9
	note B_, 3
	musicd9
	Speed 7
	note B_, 1
	rest 1
	musice8 4
	musicd7
	note C_, 1
	rest 1
	note C_, 1
	musice8 8
	note C#, 2
	note D_, 2
	musicd8
	note G_, 1
	musicd9
	note F#, 1
	musice8 7
	note F_, 1
	rest 1
	musice8 8
	note F_, 1
	rest 1
	Speed 1
	note G#, 4
	musicd9
	note A_, 3
	musicd9
	Speed 7
	note A_, 1
	rest 1
	musice8 4
	note A#, 1
	rest 1
	note A#, 1
	musice8 8
	note B_, 2
	musicd7
	note C_, 2
	musicd8
	note F_, 1
	musicd9
	note F#, 1
	musice8 7
	note G_, 1
	rest 1
	musice8 8
	note G_, 1
	rest 1
	Speed 1
	note A#, 4
	musicd9
	note B_, 3
	musicd9
	Speed 7
	note B_, 1
	rest 1
	musice8 4
	musicd7
	note C_, 1
	rest 1
	note C_, 1
	musice8 8
	note C#, 2
	note D_, 2
	musicd8
	note G_, 1
	musicd9
	note F#, 1
	musice8 7
	note F_, 1
	rest 1
	musice8 8
	note F_, 1
	rest 1
	Speed 1
	note B_, 4
	musicd9
	musicd7
	note C_, 3
	musicd9
	Speed 7
	note C_, 1
	rest 1
	musice8 8
	Speed 1
	note F#, 4
	musicd9
	note G_, 3
	musicd9
	Speed 7
	note G_, 1
	musice8 4
	note F_, 1
	musice8 8
	note C_, 2
	note F_, 2
	Speed 1
	note C_, 3
	musicd9
	musicd8
	note B_, 3
	musicd9
	note A#, 3
	musicd9
	note A_, 3
	musicd9
	note G#, 2
	Speed 7
	EndMainLoop


Music_PCMainMenu_Ch4: ; f922b (3e:522b)
	Speed 7
	musicdx 1
	MainLoop
	Loop 7
	music_call Branch_f9248
	note snare3, 1
	note bass, 1
	note snare1, 2
	note snare3, 1
	note snare4, 1
	EndLoop
	music_call Branch_f9248
	note snare4, 1
	Speed 1
	note snare2, 4
	note snare2, 3
	Speed 7
	note snare1, 2
	note snare1, 1
	note snare1, 1
	EndMainLoop

Branch_f9248:
	note bass, 2
	note snare3, 1
	note snare3, 1
	note snare1, 2
	note snare3, 1
	note snare4, 1
	note bass, 1
	note snare2, 1
	music_ret
; 0xf9251