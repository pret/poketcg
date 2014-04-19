Music_DeckMachine_Ch1: ; f6ef1 (3d:6ef1)
	musicdc 17
	musice8 8
	musice5 192
	MainLoop
	musicdx 5
	Speed 1
	Loop 9
	musice8 6
	musice6 145
	note C_, 7
	musice6 49
	note C_, 8
	musice6 65
	note C_, 8
	musice6 145
	note G_, 7
	musice6 49
	note G_, 8
	musice6 65
	note C_, 7
	musice6 145
	note E_, 7
	musice6 49
	note E_, 8
	musice6 65
	note E_, 8
	musice6 145
	note C_, 7
	musice6 49
	note C_, 8
	musice6 65
	note C_, 7
	musice6 145
	note G_, 7
	musice6 49
	note G_, 8
	musice6 145
	musice8 4
	note F_, 7
	musice8 5
	musice6 65
	note G_, 8
	EndLoop
	musice6 145
	note C_, 7
	musice6 49
	note C_, 8
	musice6 65
	note C_, 15
	Speed 10
	rest 9
	EndMainLoop


Music_DeckMachine_Ch2: ; f6f41 (3d:6f41)
	musicdc 17
	musice8 8
	musice5 64
	musice8 7
	MainLoop
	musicdx 3
	Speed 1
	Loop 9
	rest 15
	musice6 178
	rest 7
	note C_, 8
	musice6 39
	note C_, 8
	rest 7
	musice6 178
	note C_, 7
	musice6 39
	note C_, 8
	rest 7
	musice6 178
	musicd8
	note A_, 8
	musice6 39
	note A_, 8
	rest 7
	musicd7
	musice6 178
	note C_, 7
	musice6 39
	note C_, 8
	rest 15
	EndLoop
	musice6 178
	note E_, 7
	musice6 39
	note E_, 8
	rest 15
	Speed 10
	rest 9
	EndMainLoop


Music_DeckMachine_Ch3: ; f6f7b (3d:6f7b)
	musicdc 17
	musice6 32
	musice7 1
	musice9 96
	musice8 8
	MainLoop
	musicdx 2
	Speed 1
	Loop 4
	note C_, 7
	rest 8
	note G_, 7
	musicd7
	musice8 5
	note G_, 8
	musice8 8
	rest 7
	musicd8
	note C_, 8
	musicd7
	musice8 5
	note E_, 7
	musicd8
	musice8 8
	note C_, 8
	note D_, 7
	musicd7
	musice8 5
	note C_, 8
	musicd8
	rest 7
	musice8 8
	note A_, 8
	musicd7
	musice8 5
	note G_, 7
	musicd8
	musicd8
	musice8 8
	note A_, 8
	musicd7
	note D_, 7
	rest 8
	note E_, 7
	rest 8
	note G_, 7
	musicd7
	musice8 5
	note G_, 8
	rest 7
	musicd8
	musice8 8
	note E_, 8
	musicd7
	musice8 5
	note E_, 7
	musicd8
	musice8 8
	note C_, 8
	note F_, 7
	musicd7
	musice8 5
	note C_, 8
	rest 7
	musicd8
	musice8 8
	note F_, 8
	musicd7
	musice8 5
	note G_, 7
	musicd8
	musice8 8
	note E_, 8
	note D_, 7
	rest 8
	EndLoop
	note C_, 7
	rest 8
	note G_, 7
	musicd7
	musice8 5
	note G_, 8
	rest 7
	musicd8
	musice8 8
	note C_, 8
	musicd7
	musice8 5
	note E_, 7
	musicd8
	musicd8
	musice8 8
	note G_, 8
	musicd7
	note C_, 7
	musicd7
	musice8 5
	note C_, 8
	rest 7
	musicd8
	musice8 8
	note F_, 8
	musicd7
	musice8 5
	note G_, 7
	musicd8
	musice8 8
	note E_, 8
	note D_, 7
	rest 8
	note C_, 15
	rest 15
	Speed 10
	rest 3
	Speed 1
	rest 7
	musicd8
	note G_, 15
	rest 8
	note A_, 7
	rest 8
	note B_, 7
	rest 8
	EndMainLoop


Music_DeckMachine_Ch4: ; f7018 (3d:7018)
	Speed 1
	musicdx 1
	MainLoop
	Loop 9
	music_call Branch_f7031
	note noise9, 15
	note noise3, 7
	note noise7, 8
	note noise9, 15
	EndLoop
	music_call Branch_f7031
	note noise9, 7
	note noise5, 4
	note noise5, 4
	note noise3, 7
	note noise3, 8
	note noise3, 7
	note noise3, 8
	EndMainLoop

Branch_f7031:
	note noise1, 7
	note noise7, 8
	note noise9, 15
	note noise3, 7
	note noise7, 8
	note noise9, 15
	note noise1, 7
	note noise7, 8
	music_ret
; 0xf703a