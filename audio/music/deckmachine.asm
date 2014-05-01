Music_DeckMachine_Ch1: ; f6ef1 (3d:6ef1)
	musicdc 17
	musice8 8
	duty 3
	MainLoop
	octave 5
	speed 1
	Loop 9
	musice8 6
	volume 145
	note C_, 7
	volume 49
	note C_, 8
	volume 65
	note C_, 8
	volume 145
	note G_, 7
	volume 49
	note G_, 8
	volume 65
	note C_, 7
	volume 145
	note E_, 7
	volume 49
	note E_, 8
	volume 65
	note E_, 8
	volume 145
	note C_, 7
	volume 49
	note C_, 8
	volume 65
	note C_, 7
	volume 145
	note G_, 7
	volume 49
	note G_, 8
	volume 145
	musice8 4
	note F_, 7
	musice8 5
	volume 65
	note G_, 8
	EndLoop
	volume 145
	note C_, 7
	volume 49
	note C_, 8
	volume 65
	note C_, 15
	speed 10
	rest 9
	EndMainLoop


Music_DeckMachine_Ch2: ; f6f41 (3d:6f41)
	musicdc 17
	musice8 8
	duty 1
	musice8 7
	MainLoop
	octave 3
	speed 1
	Loop 9
	rest 15
	volume 178
	rest 7
	note C_, 8
	volume 39
	note C_, 8
	rest 7
	volume 178
	note C_, 7
	volume 39
	note C_, 8
	rest 7
	volume 178
	dec_octave
	note A_, 8
	volume 39
	note A_, 8
	rest 7
	inc_octave
	volume 178
	note C_, 7
	volume 39
	note C_, 8
	rest 15
	EndLoop
	volume 178
	note E_, 7
	volume 39
	note E_, 8
	rest 15
	speed 10
	rest 9
	EndMainLoop


Music_DeckMachine_Ch3: ; f6f7b (3d:6f7b)
	musicdc 17
	volume 32
	wave 1
	musice9 96
	musice8 8
	MainLoop
	octave 2
	speed 1
	Loop 4
	note C_, 7
	rest 8
	note G_, 7
	inc_octave
	musice8 5
	note G_, 8
	musice8 8
	rest 7
	dec_octave
	note C_, 8
	inc_octave
	musice8 5
	note E_, 7
	dec_octave
	musice8 8
	note C_, 8
	note D_, 7
	inc_octave
	musice8 5
	note C_, 8
	dec_octave
	rest 7
	musice8 8
	note A_, 8
	inc_octave
	musice8 5
	note G_, 7
	dec_octave
	dec_octave
	musice8 8
	note A_, 8
	inc_octave
	note D_, 7
	rest 8
	note E_, 7
	rest 8
	note G_, 7
	inc_octave
	musice8 5
	note G_, 8
	rest 7
	dec_octave
	musice8 8
	note E_, 8
	inc_octave
	musice8 5
	note E_, 7
	dec_octave
	musice8 8
	note C_, 8
	note F_, 7
	inc_octave
	musice8 5
	note C_, 8
	rest 7
	dec_octave
	musice8 8
	note F_, 8
	inc_octave
	musice8 5
	note G_, 7
	dec_octave
	musice8 8
	note E_, 8
	note D_, 7
	rest 8
	EndLoop
	note C_, 7
	rest 8
	note G_, 7
	inc_octave
	musice8 5
	note G_, 8
	rest 7
	dec_octave
	musice8 8
	note C_, 8
	inc_octave
	musice8 5
	note E_, 7
	dec_octave
	dec_octave
	musice8 8
	note G_, 8
	inc_octave
	note C_, 7
	inc_octave
	musice8 5
	note C_, 8
	rest 7
	dec_octave
	musice8 8
	note F_, 8
	inc_octave
	musice8 5
	note G_, 7
	dec_octave
	musice8 8
	note E_, 8
	note D_, 7
	rest 8
	note C_, 15
	rest 15
	speed 10
	rest 3
	speed 1
	rest 7
	dec_octave
	note G_, 15
	rest 8
	note A_, 7
	rest 8
	note B_, 7
	rest 8
	EndMainLoop


Music_DeckMachine_Ch4: ; f7018 (3d:7018)
	speed 1
	octave 1
	MainLoop
	Loop 9
	music_call Branch_f7031
	note snare4, 15
	note snare1, 7
	note snare3, 8
	note snare4, 15
	EndLoop
	music_call Branch_f7031
	note snare4, 7
	note snare2, 4
	note snare2, 4
	note snare1, 7
	note snare1, 8
	note snare1, 7
	note snare1, 8
	EndMainLoop

Branch_f7031:
	note bass, 7
	note snare3, 8
	note snare4, 15
	note snare1, 7
	note snare3, 8
	note snare4, 15
	note bass, 7
	note snare3, 8
	music_ret
; 0xf703a