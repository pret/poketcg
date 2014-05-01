Music_PauseMenu_Ch2: ; f6bb7 (3d:6bb7)
	speed 7
	musicdc 17
	musice8 8
	duty 2
	MainLoop
	volume 112
	Loop 4
	rest 16
	EndLoop
	speed 1
	octave 6
	note C_, 4
	dec_octave
	rest 3
	note B_, 4
	inc_octave
	volume 55
	note C_, 3
	dec_octave
	volume 112
	note G_, 4
	volume 55
	note B_, 3
	volume 112
	note D_, 4
	volume 55
	note G_, 3
	music_call Branch_f6c24
	music_call Branch_f6c60
	volume 112
	octave 6
	note C_, 4
	dec_octave
	volume 55
	note E_, 3
	volume 112
	note B_, 4
	inc_octave
	volume 55
	note C_, 3
	dec_octave
	volume 112
	note G_, 4
	volume 55
	note B_, 3
	volume 112
	note D_, 4
	volume 55
	note G_, 3
	music_call Branch_f6c24
	music_call Branch_f6c60
	octave 6
	volume 96
	note C_, 4
	dec_octave
	volume 55
	note E_, 3
	music_call Branch_f6ce9
	music_call Branch_f6c80
	Loop 3
	octave 6
	musice8 4
	note C_, 1
	music_call Branch_f6ce9
	music_call Branch_f6c80
	EndLoop
	musice8 8
	EndMainLoop

Branch_f6c24:
	Loop 3
	octave 6
	volume 112
	note C_, 4
	dec_octave
	volume 55
	note D_, 3
	volume 112
	note B_, 4
	inc_octave
	volume 55
	note C_, 3
	dec_octave
	volume 112
	note G_, 4
	volume 55
	note B_, 3
	volume 112
	note D_, 4
	volume 55
	note G_, 3
	EndLoop
	inc_octave
	volume 112
	note C_, 4
	dec_octave
	volume 55
	note D_, 3
	volume 112
	note B_, 4
	inc_octave
	volume 55
	note C_, 3
	dec_octave
	volume 112
	note G_, 4
	volume 55
	note B_, 3
	volume 112
	note E_, 4
	volume 55
	note G_, 3
	music_ret

Branch_f6c60:
	Loop 3
	octave 6
	volume 112
	note C_, 4
	dec_octave
	volume 55
	note E_, 3
	volume 112
	note B_, 4
	inc_octave
	volume 55
	note C_, 3
	dec_octave
	volume 112
	note G_, 4
	volume 55
	note B_, 3
	volume 112
	note E_, 4
	volume 55
	note G_, 3
	EndLoop
	music_ret

Branch_f6c80:
	octave 6
	musice8 4
	note C_, 1
	octave 3
	volume 112
	musice8 8
	speed 1
	note C_, 4
	volume 39
	note C_, 3
	volume 96
	speed 7
	octave 5
	musice8 4
	note G_, 1
	note E_, 1
	octave 3
	musice8 8
	volume 112
	speed 1
	note E_, 4
	volume 39
	note E_, 3
	speed 7
	volume 96
	octave 5
	musice8 4
	note B_, 1
	note G_, 1
	dec_octave
	volume 112
	musice8 8
	speed 1
	note C_, 4
	volume 39
	note C_, 3
	volume 96
	speed 7
	octave 6
	musice8 4
	note C_, 1
	octave 3
	musice8 8
	volume 112
	speed 1
	note C_, 4
	volume 39
	note C_, 3
	speed 7
	octave 5
	volume 96
	musice8 4
	note G_, 1
	note E_, 1
	volume 112
	octave 3
	musice8 8
	speed 1
	note E_, 4
	volume 39
	note E_, 3
	speed 7
	volume 96
	octave 5
	musice8 4
	note B_, 1
	note G_, 1
	note E_, 1
	music_ret

Branch_f6ce9:
	octave 2
	speed 1
	musice8 8
	volume 112
	note B_, 4
	volume 39
	note B_, 3
	speed 7
	volume 96
	octave 5
	musice8 4
	note G_, 1
	note D_, 1
	octave 3
	volume 112
	musice8 8
	speed 1
	note D_, 4
	volume 39
	note D_, 3
	speed 7
	volume 96
	octave 5
	musice8 4
	note B_, 1
	note G_, 1
	volume 112
	octave 3
	musice8 8
	speed 1
	note B_, 4
	volume 39
	note B_, 3
	volume 96
	speed 7
	octave 6
	musice8 4
	note C_, 1
	volume 112
	octave 2
	musice8 8
	speed 1
	note B_, 4
	volume 39
	note B_, 3
	speed 7
	volume 96
	octave 5
	musice8 4
	note G_, 1
	note D_, 1
	volume 112
	octave 3
	musice8 8
	speed 1
	note D_, 4
	volume 39
	note D_, 3
	speed 7
	volume 96
	octave 5
	musice8 4
	note B_, 1
	note G_, 1
	note D_, 1
	music_ret


Music_PauseMenu_Ch1: ; f6d4e (3d:6d4e)
	speed 7
	musicdc 17
	musice8 8
	duty 2
	MainLoop
	volume 128
	Loop 7
	rest 16
	EndLoop
	octave 5
	rest 8
	speed 1
	Loop 4
	note B_, 4
	note G_, 3
	note E_, 4
	note C_, 3
	dec_octave
	EndLoop
	speed 7
	Loop 4
	octave 1
	volume 208
	note G_, 1
	octave 3
	volume 112
	speed 1
	note D_, 4
	volume 39
	note D_, 3
	volume 208
	speed 7
	octave 1
	musice8 6
	note G_, 1
	musice8 4
	note G_, 1
	octave 3
	musice8 8
	volume 112
	speed 1
	note F#, 4
	volume 39
	note F#, 3
	dec_octave
	volume 208
	speed 7
	note D_, 1
	note G_, 1
	octave 4
	volume 112
	speed 1
	note F#, 4
	volume 39
	note F#, 3
	speed 7
	octave 1
	volume 208
	musice8 8
	note G_, 1
	octave 3
	volume 112
	speed 1
	note D_, 4
	volume 39
	note D_, 3
	speed 7
	volume 208
	octave 1
	musice8 6
	note G_, 1
	musice8 4
	note G_, 1
	octave 3
	musice8 8
	speed 1
	note F#, 4
	volume 39
	note F#, 3
	speed 7
	octave 1
	volume 208
	note B_, 1
	inc_octave
	note C_, 1
	note C#, 1
	dec_octave
	note D_, 1
	octave 3
	volume 112
	speed 1
	note E_, 4
	volume 39
	note E_, 3
	volume 208
	speed 7
	octave 1
	musice8 6
	note D_, 1
	musice8 4
	note D_, 1
	octave 3
	musice8 8
	speed 1
	note G_, 4
	volume 39
	note G_, 3
	speed 7
	dec_octave
	volume 208
	note C_, 1
	note D_, 1
	octave 4
	volume 112
	speed 1
	note G_, 4
	volume 39
	note G_, 3
	speed 7
	octave 1
	volume 208
	musice8 8
	note D_, 1
	octave 3
	volume 112
	speed 1
	note E_, 4
	volume 39
	note E_, 3
	speed 7
	volume 208
	musice8 6
	octave 1
	note D_, 1
	musice8 4
	note D_, 1
	octave 3
	musice8 8
	speed 1
	note G_, 4
	volume 39
	note G_, 3
	speed 7
	octave 1
	volume 208
	note C_, 1
	note C#, 1
	inc_octave
	note D_, 1
	EndLoop
	EndMainLoop


Music_PauseMenu_Ch3: ; f6e2d (3d:6e2d)
	speed 1
	wave 3
	musicdc 17
	volume 64
	musice9 96
	musice8 4
	octave 4
	note G_, 7
	musice8 8
	note F#, 4
	volume 96
	note G_, 3
	volume 64
	note D_, 4
	volume 96
	note F#, 3
	dec_octave
	volume 64
	note B_, 4
	inc_octave
	volume 96
	note D_, 3
	MainLoop
	octave 4
	Loop 3
	volume 64
	note G_, 4
	dec_octave
	volume 96
	note B_, 3
	inc_octave
	volume 64
	note F#, 4
	volume 96
	note G_, 3
	volume 64
	note D_, 4
	volume 96
	note F#, 3
	dec_octave
	volume 64
	note B_, 4
	inc_octave
	volume 96
	note D_, 3
	EndLoop
	volume 64
	note G_, 4
	dec_octave
	volume 96
	note B_, 3
	inc_octave
	volume 64
	note E_, 4
	volume 96
	note G_, 3
	volume 64
	note C_, 4
	volume 96
	note E_, 3
	dec_octave
	volume 64
	note A_, 4
	inc_octave
	volume 96
	note C_, 3
	Loop 3
	volume 64
	note G_, 4
	dec_octave
	volume 96
	note A_, 3
	inc_octave
	volume 64
	note E_, 4
	volume 96
	note G_, 3
	volume 64
	note C_, 4
	volume 96
	note E_, 3
	dec_octave
	volume 64
	note A_, 4
	inc_octave
	volume 96
	note C_, 3
	EndLoop
	volume 64
	note G_, 4
	dec_octave
	volume 96
	note A_, 3
	inc_octave
	volume 64
	note F#, 4
	volume 96
	note G_, 3
	volume 64
	note D_, 4
	volume 96
	note F#, 3
	dec_octave
	volume 64
	note B_, 4
	inc_octave
	volume 96
	note D_, 3
	EndMainLoop


Music_PauseMenu_Ch4: ; f6ec8 (3d:6ec8)
	speed 7
	octave 1
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
	speed 1
	note snare2, 4
	note snare2, 3
	speed 7
	Loop 8
	note snare1, 1
	EndLoop
	EndLoop
	EndMainLoop
; 0xf6ef1