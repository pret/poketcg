Music_CardPop_Ch1: ; f703a (3d:703a)
	speed 4
	musicdc 17
	musice8 8
	duty 2
	volume 144
	MainLoop
	Loop 7
	rest 16
	EndLoop
	rest 14
	Loop 2
	octave 5
	musice8 8
	note F#, 1
	note G_, 1
	musice8 6
	note F#, 1
	volume 55
	note F#, 1
	volume 144
	note D_, 1
	volume 55
	note F#, 1
	dec_octave
	volume 144
	note A_, 1
	inc_octave
	volume 55
	note D_, 1
	dec_octave
	volume 144
	note G_, 1
	volume 55
	note A_, 1
	volume 144
	note F#, 1
	volume 55
	note G_, 1
	volume 144
	note D_, 1
	volume 55
	note G_, 1
	dec_octave
	volume 144
	note A_, 1
	volume 55
	inc_octave
	note D_, 1
	dec_octave
	volume 144
	note G_, 1
	volume 55
	note A_, 1
	volume 144
	note F#, 1
	volume 55
	note G_, 1
	rest 1
	note F#, 1
	rest 12
	rest 16
	rest 14
	octave 5
	volume 144
	musice8 8
	note E_, 1
	note F_, 1
	musice8 6
	note E_, 1
	volume 55
	note E_, 1
	volume 144
	note C_, 1
	volume 55
	note E_, 1
	dec_octave
	volume 144
	note G_, 1
	inc_octave
	volume 55
	note C_, 1
	dec_octave
	volume 144
	note F_, 1
	volume 55
	note G_, 1
	volume 144
	note E_, 1
	volume 55
	note F_, 1
	volume 144
	note C_, 1
	volume 55
	note E_, 1
	dec_octave
	volume 144
	note G_, 1
	volume 55
	inc_octave
	note C_, 1
	dec_octave
	volume 144
	note F_, 1
	volume 55
	note G_, 1
	volume 144
	note E_, 1
	volume 55
	note F_, 1
	rest 1
	note E_, 1
	rest 12
	rest 16
	volume 144
	rest 14
	EndLoop
	rest 2
	EndMainLoop


Music_CardPop_Ch2: ; f70df (3d:70df)
	speed 4
	musicdc 17
	musice8 8
	duty 2
	volume 96
	musice8 3
	Loop 2
	octave 2
	note A_, 2
	inc_octave
	note A_, 2
	inc_octave
	note A_, 2
	dec_octave
	note A_, 2
	inc_octave
	inc_octave
	note A_, 2
	dec_octave
	note A_, 2
	dec_octave
	note A_, 2
	inc_octave
	inc_octave
	note A_, 2
	dec_octave
	dec_octave
	note A_, 2
	dec_octave
	note A_, 2
	inc_octave
	note A_, 2
	inc_octave
	note A_, 2
	inc_octave
	note A_, 2
	dec_octave
	note A_, 2
	dec_octave
	note A_, 2
	inc_octave
	inc_octave
	note A_, 2
	EndLoop
	Loop 2
	octave 2
	note G_, 2
	inc_octave
	note G_, 2
	inc_octave
	note G_, 2
	dec_octave
	note G_, 2
	inc_octave
	inc_octave
	note G_, 2
	dec_octave
	note G_, 2
	dec_octave
	note G_, 2
	inc_octave
	inc_octave
	note G_, 2
	dec_octave
	dec_octave
	note G_, 2
	dec_octave
	note G_, 2
	inc_octave
	note G_, 2
	inc_octave
	note G_, 2
	inc_octave
	note G_, 2
	dec_octave
	note G_, 2
	dec_octave
	note G_, 2
	inc_octave
	inc_octave
	note G_, 2
	EndLoop
	EndMainLoop


Music_CardPop_Ch3: ; f713a (3d:713a)
	speed 4
	wave 1
	musicdc 17
	volume 32
	musice9 0
	musice8 8
	music_call Branch_f715b
	note C_, 2
	note C#, 2
	music_call Branch_f715b
	note D_, 2
	note C#, 2
	music_call Branch_f716c
	note D_, 2
	note C#, 2
	music_call Branch_f716c
	note C_, 2
	note C#, 2
	EndMainLoop

Branch_f715b:
	octave 1
	note D_, 2
	rest 2
	note D_, 4
	inc_octave
	note D_, 2
	dec_octave
	note D_, 2
	rest 2
	note F#, 2
	rest 2
	note G_, 2
	rest 2
	note G#, 2
	rest 2
	note A_, 2
	music_ret

Branch_f716c:
	octave 1
	note C_, 2
	rest 2
	note C_, 4
	inc_octave
	note C_, 2
	dec_octave
	note C_, 2
	rest 2
	note E_, 2
	rest 2
	note F_, 2
	rest 2
	note F#, 2
	rest 2
	note G_, 2
	music_ret


Music_CardPop_Ch4: ; f717d (3d:717d)
	speed 4
	octave 1
	Loop 11
	music_call Branch_f7196
	note snare4, 4
	note snare1, 2
	note snare3, 2
	note snare4, 2
	note snare1, 2
	EndLoop
	music_call Branch_f7196
	note snare4, 2
	note snare2, 1
	note snare2, 1
	Loop 4
	note snare1, 2
	EndLoop
	EndMainLoop

Branch_f7196:
	note bass, 2
	note snare3, 2
	note snare4, 4
	note snare1, 2
	note snare3, 2
	note snare4, 2
	note snare1, 2
	note bass, 2
	note snare1, 2
	music_ret
; 0xf71a0