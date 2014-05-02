Music_PCMainMenu_Ch1: ; f9052 (3e:5052)
	speed 7
	musicdc 17
	musice8 8
	octave 3
	duty 2
	MainLoop
	music_call Branch_f90c2
	rest 4
	dec_octave
	duty 1
	musice8 5
	volume 97
	note F_, 1
	rest 1
	duty 2
	musice8 8
	volume 180
	note A_, 1
	volume 55
	note A_, 1
	rest 2
	inc_octave
	volume 180
	note C_, 1
	volume 55
	note C_, 1
	dec_octave
	duty 1
	musice8 5
	volume 97
	note F_, 1
	rest 1
	duty 2
	musice8 8
	volume 180
	note B_, 1
	volume 55
	note B_, 1
	music_call Branch_f90c2
	rest 4
	dec_octave
	duty 1
	musice8 5
	volume 97
	note F_, 1
	rest 1
	inc_octave
	duty 2
	musice8 8
	volume 180
	note E_, 1
	volume 55
	note E_, 1
	rest 2
	volume 180
	note C_, 1
	volume 55
	note C_, 1
	duty 1
	musice8 5
	volume 97
	dec_octave
	note F_, 1
	rest 1
	inc_octave
	duty 2
	musice8 8
	volume 180
	note D_, 1
	volume 55
	note D_, 1
	EndMainLoop

Branch_f90c2:
	octave 3
	rest 4
	duty 1
	volume 97
	musice8 5
	note G_, 1
	rest 3
	musice8 8
	duty 2
	volume 180
	note B_, 2
	inc_octave
	note D_, 1
	volume 39
	note D_, 1
	dec_octave
	duty 1
	volume 97
	musice8 5
	note G_, 1
	rest 1
	inc_octave
	duty 2
	musice8 8
	volume 180
	note C_, 1
	volume 55
	note C_, 1
	music_ret


Music_PCMainMenu_Ch2: ; f90ed (3e:50ed)
	speed 7
	musicdc 17
	musice8 8
	octave 3
	duty 2
	MainLoop
	music_call Branch_f915e
	rest 4
	inc_octave
	duty 1
	musice8 5
	volume 97
	note C_, 1
	rest 1
	dec_octave
	duty 2
	musice8 8
	volume 132
	note F_, 1
	volume 39
	note F_, 1
	rest 2
	volume 132
	note A_, 1
	volume 39
	note A_, 1
	duty 1
	musice8 5
	volume 97
	inc_octave
	note C_, 1
	rest 1
	dec_octave
	duty 2
	musice8 8
	volume 132
	note G_, 1
	volume 39
	note G_, 1
	music_call Branch_f915e
	rest 4
	inc_octave
	duty 1
	musice8 5
	volume 97
	note C_, 1
	rest 1
	duty 2
	musice8 8
	volume 132
	note C_, 1
	volume 39
	note C_, 1
	rest 2
	dec_octave
	volume 132
	note A_, 1
	volume 39
	note A_, 1
	duty 1
	inc_octave
	volume 97
	musice8 5
	note C_, 1
	rest 1
	dec_octave
	duty 2
	musice8 8
	volume 132
	note B_, 1
	volume 39
	note B_, 1
	EndMainLoop

Branch_f915e:
	octave 4
	rest 4
	duty 1
	musice8 5
	volume 97
	note D_, 1
	rest 3
	duty 2
	musice8 8
	dec_octave
	volume 132
	note G_, 2
	note B_, 1
	volume 39
	note B_, 1
	inc_octave
	duty 1
	musice8 5
	volume 97
	note D_, 1
	rest 1
	dec_octave
	duty 2
	musice8 8
	volume 132
	note A_, 1
	volume 39
	note A_, 1
	music_ret


Music_PCMainMenu_Ch3: ; f9189 (3e:5189)
	speed 7
	volume 32
	musicdc 17
	wave 1
	musice8 7
	musice9 0
	MainLoop
	octave 1
	musice8 7
	note G_, 1
	rest 1
	musice8 8
	note G_, 1
	rest 1
	speed 1
	note A#, 4
	tie
	note B_, 3
	tie
	speed 7
	note B_, 1
	rest 1
	musice8 4
	inc_octave
	note C_, 1
	rest 1
	note C_, 1
	musice8 8
	note C#, 2
	note D_, 2
	dec_octave
	note G_, 1
	tie
	note F#, 1
	musice8 7
	note F_, 1
	rest 1
	musice8 8
	note F_, 1
	rest 1
	speed 1
	note G#, 4
	tie
	note A_, 3
	tie
	speed 7
	note A_, 1
	rest 1
	musice8 4
	note A#, 1
	rest 1
	note A#, 1
	musice8 8
	note B_, 2
	inc_octave
	note C_, 2
	dec_octave
	note F_, 1
	tie
	note F#, 1
	musice8 7
	note G_, 1
	rest 1
	musice8 8
	note G_, 1
	rest 1
	speed 1
	note A#, 4
	tie
	note B_, 3
	tie
	speed 7
	note B_, 1
	rest 1
	musice8 4
	inc_octave
	note C_, 1
	rest 1
	note C_, 1
	musice8 8
	note C#, 2
	note D_, 2
	dec_octave
	note G_, 1
	tie
	note F#, 1
	musice8 7
	note F_, 1
	rest 1
	musice8 8
	note F_, 1
	rest 1
	speed 1
	note B_, 4
	tie
	inc_octave
	note C_, 3
	tie
	speed 7
	note C_, 1
	rest 1
	musice8 8
	speed 1
	note F#, 4
	tie
	note G_, 3
	tie
	speed 7
	note G_, 1
	musice8 4
	note F_, 1
	musice8 8
	note C_, 2
	note F_, 2
	speed 1
	note C_, 3
	tie
	dec_octave
	note B_, 3
	tie
	note A#, 3
	tie
	note A_, 3
	tie
	note G#, 2
	speed 7
	EndMainLoop


Music_PCMainMenu_Ch4: ; f922b (3e:522b)
	speed 7
	octave 1
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
	speed 1
	note snare2, 4
	note snare2, 3
	speed 7
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