Music_Club2_Ch1: ; fa077 (3e:6077)
	speed 6
	duty 2
	musicdc 17
	musice8 8
	MainLoop
	octave 4
	Loop 8
	volume 117
	note G_, 4
	note E_, 4
	note C_, 4
	volume 119
	note F#, 4
	no_fade
	note F#, 16
	volume 117
	note G_, 4
	note A_, 4
	note B_, 4
	volume 119
	note F#, 4
	no_fade
	note F#, 16
	EndLoop
	volume 117
	note G_, 4
	note D_, 4
	dec_octave
	note B_, 4
	inc_octave
	volume 119
	note B_, 4
	no_fade
	note B_, 16
	volume 117
	note G_, 4
	note D_, 4
	note C_, 4
	volume 119
	note B_, 4
	no_fade
	note B_, 16
	dec_octave
	volume 117
	note F#, 4
	dec_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	dec_octave
	note C_, 4
	dec_octave
	note C_, 4
	note E_, 4
	note G_, 4
	inc_octave
	note C_, 4
	note E_, 4
	note G_, 4
	inc_octave
	note C_, 4
	dec_octave
	note D_, 4
	dec_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note A_, 4
	note A_, 3
	no_fade
	speed 1
	note A_, 3
	inc_octave
	volume 119
	rest 4
	note D_, 5
	no_fade
	speed 6
	note D_, 15
	no_fade
	note D_, 16
	EndMainLoop


Music_Club2_Ch2: ; fa0e3 (3e:60e3)
	speed 6
	duty 2
	musicdc 17
	musice8 8
	MainLoop
	octave 2
	Loop 8
	volume 117
	note C_, 4
	note G_, 4
	inc_octave
	note G_, 4
	inc_octave
	volume 119
	note D_, 4
	no_fade
	note D_, 16
	dec_octave
	dec_octave
	volume 117
	note C_, 4
	note G_, 4
	inc_octave
	inc_octave
	note C_, 4
	volume 119
	note D_, 4
	no_fade
	note D_, 16
	dec_octave
	dec_octave
	EndLoop
	dec_octave
	volume 117
	note B_, 4
	inc_octave
	note G_, 4
	inc_octave
	note G_, 4
	inc_octave
	volume 119
	note G_, 4
	no_fade
	note G_, 16
	dec_octave
	dec_octave
	dec_octave
	volume 117
	note A_, 4
	inc_octave
	note A_, 4
	inc_octave
	note A_, 4
	inc_octave
	volume 119
	note C_, 4
	no_fade
	note C_, 16
	dec_octave
	dec_octave
	volume 117
	note D_, 4
	octave 2
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note G_, 4
	dec_octave
	dec_octave
	note E_, 4
	note G_, 4
	inc_octave
	note C_, 4
	note E_, 4
	note G_, 4
	inc_octave
	note C_, 4
	note E_, 4
	note F#, 4
	dec_octave
	dec_octave
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note E_, 3
	no_fade
	speed 1
	note E_, 3
	dec_octave
	volume 116
	note A_, 8
	inc_octave
	volume 119
	note F#, 7
	no_fade
	speed 6
	note F#, 14
	no_fade
	note F#, 16
	EndMainLoop


Music_Club2_Ch3: ; fa164 (3e:6164)
	speed 6
	volume 32
	musicdc 17
	duty3 0
	vibrato_rate 4
	vibrato_delay 35
	musice8 6
	musice9 64
	MainLoop
	volume 96
	musice8 8
	rest 2
	octave 4
	note G_, 4
	note E_, 4
	note C_, 4
	note F#, 2
	rest 2
	rest 16
	note G_, 4
	note A_, 4
	note B_, 4
	note F#, 2
	rest 2
	rest 14
	volume 64
	musice9 96
	music_call Branch_fa1cf
	octave 4
	musice8 8
	note G_, 8
	music_call Branch_fa1cf
	musice9 64
	volume 32
	octave 3
	musice8 8
	note G_, 8
	music_call Branch_fa1f3
	octave 3
	note G_, 16
	no_fade
	note G_, 12
	rest 16
	rest 8
	musice8 8
	note E_, 8
	music_call Branch_fa1f3
	octave 3
	note G_, 16
	no_fade
	note G_, 12
	no_fade
	note G_, 16
	no_fade
	note G_, 8
	rest 4
	musice8 8
	note A_, 2
	note G_, 2
	musice8 6
	note F#, 16
	no_fade
	note F#, 12
	rest 4
	note F#, 1
	no_fade
	note G_, 15
	no_fade
	note G_, 12
	rest 4
	note G#, 1
	no_fade
	note A_, 15
	no_fade
	note A_, 16
	rest 16
	rest 16
	musice9 96
	EndMainLoop

Branch_fa1cf:
	musice8 6
	octave 5
	note C#, 1
	no_fade
	note D_, 15
	no_fade
	note D_, 12
	musice8 8
	note C_, 2
	dec_octave
	note B_, 2
	musice8 6
	note G_, 16
	no_fade
	note G_, 8
	rest 4
	musice8 8
	note E_, 4
	note B_, 4
	inc_octave
	note C_, 4
	dec_octave
	note B_, 4
	musice8 6
	note A_, 16
	no_fade
	note A_, 8
	no_fade
	note A_, 16
	rest 4
	music_ret

Branch_fa1f3:
	octave 4
	note C#, 1
	no_fade
	note D_, 15
	no_fade
	note D_, 4
	note E_, 4
	dec_octave
	note B_, 4
	inc_octave
	note C_, 4
	musice8 6
	note D_, 16
	no_fade
	note D_, 8
	rest 4
	musice8 8
	note C_, 2
	dec_octave
	note B_, 2
	inc_octave
	note C_, 2
	dec_octave
	note B_, 2
	musice8 6
	music_ret
; 0xfa210