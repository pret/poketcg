Music_Imakuni_Ch1: ; fad55 (3e:6d55)
	speed 3
	musicdc 17
	vibrato_rate 5
	vibrato_delay 20
	musice8 8
	duty 2
	volume 160
	MainLoop
	Loop 16
	rest 10
	EndLoop
	music_call Branch_fadf9
	octave 4
	note D_, 15
	dec_octave
	note B_, 7
	rest 8
	note G_, 7
	rest 8
	speed 9
	note F_, 10
	no_fade
	speed 1
	note F_, 7
	rest 8
	speed 9
	rest 10
	music_call Branch_fadf9
	music_call Branch_fae1d
	speed 1
	octave 4
	note E_, 7
	rest 15
	note E_, 3
	note C_, 2
	note E_, 3
	note C_, 15
	dec_octave
	note G#, 15
	note A_, 7
	rest 8
	speed 3
	rest 15
	speed 1
	rest 15
	rest 15
	inc_octave
	note E_, 7
	rest 8
	note F#, 7
	rest 8
	note G_, 15
	no_fade
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
	dec_octave
	note G#, 7
	rest 8
	speed 7
	note F#, 15
	speed 9
	rest 10
	music_call Branch_fadf9
	music_call Branch_fae1d
	dec_octave
	speed 1
	note F_, 7
	rest 8
	note B_, 7
	inc_octave
	note C_, 8
	dec_octave
	note G#, 7
	note A_, 8
	note F_, 7
	rest 8
	note B_, 7
	inc_octave
	note C_, 8
	dec_octave
	note G#, 7
	note A_, 8
	speed 3
	note F_, 10
	speed 1
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
	speed 3
	note D#, 10
	speed 1
	Loop 4
	note D_, 7
	dec_octave
	note A_, 8
	note D_, 7
	note A_, 8
	note D_, 7
	note A_, 8
	inc_octave
	EndLoop
	note D_, 7
	dec_octave
	note A_, 8
	note D_, 7
	note A_, 8
	vibrato_delay 5
	speed 3
	note D_, 10
	vibrato_delay 20
	EndMainLoop

Branch_fadf9:
	speed 1
	octave 4
	note C#, 7
	rest 15
	note C#, 3
	note D_, 2
	note C#, 3
	dec_octave
	note A#, 15
	note B_, 15
	inc_octave
	note D_, 7
	rest 8
	speed 5
	rest 9
	speed 1
	rest 15
	rest 15
	note D_, 7
	rest 8
	note E_, 7
	rest 8
	note F_, 15
	no_fade
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
	octave 4
	note D_, 7
	rest 8
	dec_octave
	note G_, 7
	rest 8
	inc_octave
	note G_, 7
	rest 8
	speed 9
	note F_, 10
	no_fade
	speed 1
	note F_, 7
	rest 8
	speed 9
	rest 10
	music_ret


Music_Imakuni_Ch2: ; fae32 (3e:6e32)
	musicdc 17
	vibrato_rate 0
	vibrato_delay 0
	musice8 8
	duty 1
	volume 160
	Loop 6
	music_call Branch_faea5
	EndLoop
	Loop 2
	Loop 2
	speed 3
	rest 10
	speed 1
	note C_, 7
	rest 8
	EndLoop
	rest 15
	note C_, 7
	rest 8
	speed 3
	rest 10
	speed 1
	note C_, 7
	rest 8
	rest 15
	speed 3
	rest 10
	vibrato_delay 8
	note C_, 10
	vibrato_delay 0
	EndLoop
	Loop 2
	music_call Branch_faea5
	EndLoop
	speed 1
	octave 2
	note F_, 15
	no_fade
	note F_, 7
	inc_octave
	note F_, 8
	note D#, 7
	rest 8
	rest 15
	note G#, 7
	note A_, 8
	note F_, 7
	note D#, 8
	speed 3
	rest 10
	speed 1
	dec_octave
	note D#, 15
	no_fade
	note D#, 7
	inc_octave
	note D#, 8
	note C#, 7
	rest 8
	rest 15
	note F#, 7
	note G_, 8
	note D#, 7
	note C#, 8
	speed 3
	rest 10
	speed 1
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
	vibrato_delay 5
	note D_, 15
	no_fade
	note D_, 7
	rest 8
	vibrato_delay 0
	EndMainLoop

Branch_faea5:
	octave 3
	speed 6
	rest 10
	speed 1
	Loop 2
	rest 15
	note C#, 7
	rest 8
	EndLoop
	vibrato_delay 8
	speed 9
	rest 10
	speed 3
	note C#, 10
	vibrato_delay 0
	music_ret


Music_Imakuni_Ch3: ; faebc (3e:6ebc)
	musicdc 17
	volume 32
	duty3 1
	vibrato_rate 6
	vibrato_delay 0
	musice9 0
	musice8 8
	MainLoop
	music_call Branch_faf7d
	vibrato_delay 8
	speed 1
	note D_, 15
	no_fade
	note D_, 7
	inc_octave
	vibrato_delay 0
	note G_, 3
	dec_octave
	note G_, 2
	dec_octave
	note G_, 3
	music_call Branch_faf7d
	vibrato_delay 8
	note D_, 10
	vibrato_delay 0
	Loop 4
	music_call Branch_faf7d
	vibrato_delay 8
	note D_, 10
	vibrato_delay 0
	EndLoop
	Loop 2
	octave 2
	speed 3
	note C_, 5
	rest 5
	inc_octave
	speed 1
	note E_, 7
	rest 8
	dec_octave
	speed 3
	note G#, 5
	note A_, 5
	inc_octave
	speed 1
	note D#, 7
	rest 8
	rest 15
	note D#, 7
	rest 8
	speed 3
	rest 5
	dec_octave
	note C_, 5
	inc_octave
	speed 1
	note E_, 7
	rest 8
	dec_octave
	speed 3
	note G#, 5
	note A_, 5
	rest 5
	inc_octave
	vibrato_delay 8
	note D#, 10
	vibrato_delay 0
	EndLoop
	Loop 2
	music_call Branch_faf7d
	vibrato_delay 8
	note D_, 10
	vibrato_delay 0
	EndLoop
	speed 1
	octave 1
	note F_, 15
	no_fade
	note F_, 7
	inc_octave
	note F_, 8
	note D#, 7
	rest 8
	note F_, 7
	rest 8
	note G#, 7
	note A_, 8
	note F_, 7
	note D#, 8
	vibrato_delay 5
	speed 3
	note F_, 10
	vibrato_delay 0
	speed 1
	dec_octave
	note D#, 15
	no_fade
	note D#, 7
	inc_octave
	note D#, 8
	note C#, 7
	rest 8
	note D#, 7
	rest 8
	note F#, 7
	note G_, 8
	note D#, 7
	note C#, 8
	vibrato_delay 5
	speed 3
	note D#, 10
	vibrato_delay 0
	speed 1
	Loop 4
	octave 3
	note C_, 7
	rest 8
	octave 1
	note D_, 7
	rest 8
	note D_, 7
	rest 8
	EndLoop
	octave 3
	note C_, 7
	rest 8
	octave 1
	note D_, 7
	rest 8
	octave 3
	vibrato_delay 5
	note C_, 15
	no_fade
	note C_, 7
	inc_octave
	vibrato_delay 0
	note G_, 3
	dec_octave
	note G_, 2
	dec_octave
	note G_, 3
	speed 8
	EndMainLoop

Branch_faf7d:
	speed 3
	octave 1
	note G_, 5
	rest 5
	inc_octave
	speed 1
	note G_, 7
	rest 8
	speed 3
	note C#, 5
	note D_, 5
	inc_octave
	speed 1
	note D_, 7
	rest 8
	rest 15
	note D_, 7
	rest 8
	speed 3
	rest 5
	octave 1
	note G_, 5
	inc_octave
	speed 1
	note G_, 7
	rest 8
	speed 3
	note C#, 5
	note D_, 5
	rest 5
	inc_octave
	music_ret


Music_Imakuni_Ch4: ; fafa4 (3e:6fa4)
	speed 1
	octave 1
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
	speed 11
	note snare5, 2
	speed 1
	note snare1, 8
	note snare1, 15
	note snare1, 15
	note snare1, 7
	note snare1, 8
	note snare1, 7
	note snare1, 8
	speed 3
	note snare5, 10
	EndLoop
	speed 1
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