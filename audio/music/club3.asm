Music_Club3_Ch1: ; fa210 (3e:6210)
	speed 9
	musicdc 17
	vibrato_rate 5
	vibrato_delay 20
	musice8 8
	MainLoop
	duty 0
	Loop 2
	octave 2
	volume 144
	rest 4
	note G_, 2
	volume 55
	note G_, 1
	inc_octave
	volume 144
	note C_, 1
	volume 55
	note C_, 2
	dec_octave
	volume 144
	note A#, 6
	tie
	note A#, 12
	volume 55
	note A#, 4
	rest 4
	volume 144
	note G_, 2
	volume 55
	note G_, 1
	inc_octave
	volume 144
	speed 1
	note C_, 5
	tie
	note C#, 4
	tie
	speed 9
	note C_, 1
	volume 55
	note C_, 1
	dec_octave
	volume 144
	note A#, 6
	tie
	note A#, 12
	volume 55
	note A#, 4
	EndLoop
	duty 1
	volume 147
	musice8 7
	music_call Branch_fa330
	music_call Branch_fa403
	note A#, 1
	note F_, 1
	note F#, 1
	note G_, 1
	inc_octave
	note D_, 1
	inc_octave
	note D_, 1
	dec_octave
	note D_, 1
	inc_octave
	note F_, 1
	dec_octave
	note D_, 1
	note D#, 1
	inc_octave
	note G_, 1
	octave 2
	note G_, 1
	octave 4
	note C#, 1
	note C_, 1
	octave 2
	note G_, 1
	inc_octave
	musice8 8
	speed 1
	note G_, 5
	volume 55
	note G_, 4
	speed 9
	volume 128
	note C#, 1
	note C_, 1
	dec_octave
	note A#, 1
	volume 147
	musice8 7
	music_call Branch_fa330
	music_call Branch_fa403
	inc_octave
	note D_, 1
	dec_octave
	note F_, 1
	note F#, 1
	note G_, 1
	inc_octave
	note D_, 1
	inc_octave
	note D_, 1
	dec_octave
	note D_, 1
	inc_octave
	note F_, 1
	dec_octave
	note C#, 1
	note D_, 1
	inc_octave
	note F#, 1
	octave 2
	note G_, 1
	octave 4
	note C#, 1
	note C_, 1
	octave 2
	note G_, 1
	octave 4
	duty 2
	volume 112
	speed 1
	musice8 8
	note G_, 5
	note C#, 4
	note C_, 5
	dec_octave
	note A#, 4
	note G_, 5
	note C#, 4
	note C_, 5
	dec_octave
	note A#, 4
	duty 1
	musice8 7
	speed 9
	music_call Branch_fa370
	music_call Branch_fa403
	note A#, 1
	note F_, 1
	note F#, 1
	note G_, 1
	inc_octave
	note D_, 1
	inc_octave
	note D_, 1
	dec_octave
	note D_, 1
	inc_octave
	note F_, 1
	dec_octave
	note D_, 1
	note D#, 1
	inc_octave
	note G_, 1
	octave 2
	note G_, 1
	octave 4
	note C#, 1
	note C_, 1
	octave 2
	note G_, 1
	inc_octave
	musice8 8
	speed 1
	note G_, 5
	volume 55
	note G_, 4
	speed 9
	volume 128
	note C#, 1
	note C_, 1
	dec_octave
	note A#, 1
	music_call Branch_fa370
	music_call Branch_fa403
	inc_octave
	note D_, 1
	dec_octave
	note F_, 1
	note F#, 1
	note G_, 1
	inc_octave
	note D_, 1
	inc_octave
	note D_, 1
	dec_octave
	note D_, 1
	inc_octave
	note F_, 1
	dec_octave
	note C_, 1
	note C#, 1
	inc_octave
	note F#, 1
	octave 2
	note G_, 1
	octave 4
	note C#, 1
	note C_, 1
	dec_octave
	note A#, 1
	inc_octave
	duty 2
	speed 1
	musice8 8
	volume 112
	note G_, 5
	note C#, 4
	note C_, 5
	dec_octave
	note A#, 4
	note G_, 5
	note C#, 4
	note C_, 5
	dec_octave
	note A#, 4
	speed 9
	musice8 8
	EndMainLoop

Branch_fa330:
	octave 2
	note G_, 1
	inc_octave
	note D_, 1
	inc_octave
	note D_, 1
	dec_octave
	note D_, 1
	inc_octave
	note C#, 1
	note C_, 1
	dec_octave
	note D_, 1
	note A#, 1
	note D_, 1
	dec_octave
	note G_, 1
	inc_octave
	note A#, 1
	dec_octave
	speed 1
	musice8 8
	note F_, 5
	note F#, 4
	speed 9
	musice8 7
	note G_, 1
	inc_octave
	note E_, 1
	dec_octave
	note F_, 1
	note F#, 1
	note G_, 1
	inc_octave
	note D_, 1
	inc_octave
	note D_, 1
	dec_octave
	note D_, 1
	inc_octave
	note F_, 1
	note E_, 1
	dec_octave
	note D_, 1
	inc_octave
	note G_, 1
	octave 2
	note G_, 1
	octave 4
	note C#, 1
	note C_, 1
	octave 2
	note G_, 1
	note A#, 1
	inc_octave
	note C_, 1
	dec_octave
	note F_, 1
	note F#, 1
	music_ret

Branch_fa370:
	octave 2
	volume 147
	musice8 7
	note G_, 1
	inc_octave
	note D_, 1
	inc_octave
	note D_, 1
	dec_octave
	note D_, 1
	inc_octave
	note C#, 1
	note C_, 1
	dec_octave
	note D_, 1
	note A#, 1
	note D_, 1
	dec_octave
	note G_, 1
	inc_octave
	note A#, 1
	dec_octave
	speed 1
	musice8 8
	note F_, 5
	note F#, 4
	octave 4
	duty 2
	volume 112
	note G_, 3
	volume 23
	note G_, 2
	inc_octave
	volume 112
	note D_, 2
	volume 23
	dec_octave
	note G_, 2
	inc_octave
	volume 112
	note G_, 3
	volume 23
	note D_, 2
	volume 112
	note D_, 2
	volume 23
	note G_, 2
	dec_octave
	volume 112
	note G_, 3
	volume 23
	inc_octave
	note D_, 2
	volume 112
	note D_, 2
	volume 23
	dec_octave
	note G_, 2
	inc_octave
	volume 112
	note G_, 3
	volume 23
	note D_, 2
	volume 112
	note D_, 2
	volume 23
	note G_, 2
	speed 9
	duty 1
	musice8 7
	volume 147
	octave 2
	note G_, 1
	inc_octave
	note D_, 1
	inc_octave
	note D_, 1
	dec_octave
	note D_, 1
	inc_octave
	note F_, 1
	note E_, 1
	dec_octave
	note D_, 1
	inc_octave
	note G_, 1
	octave 2
	note G_, 1
	octave 4
	note C#, 1
	note C_, 1
	octave 2
	note G_, 1
	octave 5
	duty 2
	speed 1
	musice8 8
	volume 112
	octave 5
	note G_, 5
	note C#, 4
	note C_, 5
	dec_octave
	note A#, 4
	note G_, 5
	note C#, 4
	note C_, 5
	dec_octave
	note A#, 4
	speed 9
	duty 1
	musice8 7
	volume 147
	music_ret

Branch_fa403:
	octave 2
	note G_, 1
	inc_octave
	note D_, 1
	inc_octave
	note D_, 1
	dec_octave
	note D_, 1
	inc_octave
	note C#, 1
	note C_, 1
	dec_octave
	note D_, 1
	note A#, 1
	note D_, 1
	dec_octave
	note G_, 1
	inc_octave
	note A#, 1
	dec_octave
	speed 1
	musice8 8
	note F_, 5
	note F#, 4
	speed 9
	musice8 7
	note G_, 1
	music_ret


Music_Club3_Ch2: ; fa423 (3e:6423)
	speed 9
	musicdc 17
	vibrato_rate 5
	vibrato_delay 20
	musice8 8
	MainLoop
	duty 0
	Loop 2
	octave 2
	volume 112
	rest 4
	note D_, 2
	volume 55
	note D_, 1
	volume 112
	note F_, 1
	volume 55
	note F_, 2
	volume 112
	note E_, 6
	tie
	note E_, 12
	volume 55
	note E_, 4
	rest 4
	volume 112
	note D_, 2
	volume 55
	note D_, 1
	volume 112
	speed 1
	note F_, 5
	tie
	note F#, 4
	speed 9
	note F_, 1
	volume 55
	note F_, 1
	volume 112
	note E_, 6
	tie
	note E_, 12
	volume 55
	note E_, 4
	EndLoop
	duty 1
	Loop 2
	music_call Branch_fa5a6
	speed 9
	rest 1
	inc_octave
	volume 128
	speed 1
	note D_, 5
	volume 55
	note D_, 4
	speed 9
	volume 147
	musice8 7
	note G_, 1
	dec_octave
	speed 1
	musice8 8
	volume 128
	note F_, 5
	note F#, 4
	inc_octave
	speed 9
	volume 147
	musice8 7
	note G_, 1
	note G_, 1
	volume 55
	note G_, 1
	volume 147
	note F_, 1
	volume 55
	note F_, 2
	dec_octave
	volume 147
	note D_, 1
	inc_octave
	inc_octave
	volume 128
	speed 1
	note D_, 5
	volume 55
	note D_, 4
	volume 147
	speed 9
	rest 1
	dec_octave
	speed 1
	musice8 8
	note G_, 5
	note D_, 4
	dec_octave
	note A#, 5
	volume 55
	note A#, 4
	inc_octave
	inc_octave
	volume 147
	note D_, 5
	volume 55
	note D_, 4
	speed 9
	volume 128
	rest 1
	dec_octave
	speed 1
	note D_, 5
	volume 55
	note D_, 4
	speed 9
	volume 147
	musice8 7
	note G_, 1
	dec_octave
	speed 1
	musice8 8
	volume 128
	note F_, 5
	note F#, 4
	inc_octave
	speed 9
	volume 147
	musice8 7
	note A#, 1
	volume 55
	note A#, 2
	inc_octave
	volume 147
	note C#, 1
	volume 55
	note C#, 1
	dec_octave
	volume 147
	note G_, 1
	volume 55
	note G_, 1
	dec_octave
	speed 1
	volume 128
	note A#, 5
	volume 55
	note C_, 4
	speed 9
	rest 1
	dec_octave
	volume 128
	musice8 8
	note A#, 1
	note B_, 1
	inc_octave
	note C_, 1
	music_call Branch_fa5a6
	speed 9
	rest 1
	inc_octave
	speed 1
	volume 128
	note D_, 5
	volume 55
	note D_, 4
	speed 9
	volume 147
	musice8 7
	note G_, 1
	dec_octave
	speed 1
	musice8 8
	volume 128
	note F_, 5
	note F#, 4
	inc_octave
	speed 9
	volume 147
	musice8 7
	note G_, 1
	note G_, 1
	volume 55
	note G_, 1
	volume 147
	note F_, 1
	volume 55
	note F_, 2
	volume 147
	note D_, 1
	inc_octave
	volume 128
	speed 1
	note G_, 5
	volume 55
	note G_, 4
	speed 9
	rest 1
	dec_octave
	dec_octave
	speed 1
	volume 128
	note G_, 5
	volume 55
	note G_, 4
	inc_octave
	volume 128
	note D_, 5
	volume 55
	note D_, 4
	speed 9
	rest 1
	rest 1
	speed 1
	volume 128
	note D_, 5
	volume 55
	note D_, 4
	speed 9
	volume 147
	musice8 7
	note G_, 1
	dec_octave
	speed 1
	musice8 8
	volume 128
	note F_, 5
	note F#, 4
	inc_octave
	inc_octave
	speed 9
	volume 147
	musice8 7
	note C#, 1
	volume 55
	note C#, 2
	volume 147
	note C_, 1
	volume 55
	note C_, 1
	dec_octave
	volume 147
	note G_, 1
	volume 55
	note G_, 1
	volume 128
	speed 1
	note F_, 5
	volume 55
	note F_, 4
	volume 128
	speed 9
	rest 1
	dec_octave
	musice8 8
	note D_, 1
	note D#, 1
	note E_, 1
	EndLoop
	EndMainLoop

Branch_fa5a6:
	octave 3
	rest 1
	volume 128
	speed 1
	note D_, 5
	volume 55
	note D_, 4
	speed 9
	volume 147
	musice8 7
	note G_, 1
	dec_octave
	speed 1
	volume 128
	musice8 8
	note F_, 5
	note F#, 4
	inc_octave
	speed 9
	musice8 7
	volume 147
	note G_, 1
	note G_, 1
	volume 55
	note G_, 1
	volume 147
	note F_, 1
	volume 55
	note F_, 2
	volume 147
	note E_, 1
	inc_octave
	volume 128
	musice8 8
	speed 1
	note D_, 5
	volume 55
	note D_, 4
	volume 128
	speed 9
	rest 1
	dec_octave
	speed 1
	musice8 8
	note G_, 5
	note D_, 4
	dec_octave
	note A#, 5
	volume 55
	note A#, 4
	volume 128
	inc_octave
	inc_octave
	note D_, 5
	volume 55
	note D_, 4
	speed 9
	rest 1
	dec_octave
	speed 1
	volume 128
	note D_, 5
	volume 55
	note D_, 4
	speed 9
	volume 147
	musice8 7
	note G_, 1
	dec_octave
	speed 1
	volume 128
	musice8 8
	note F_, 5
	note F#, 4
	speed 9
	inc_octave
	volume 147
	musice8 7
	note A#, 1
	volume 55
	note A#, 2
	inc_octave
	volume 147
	note C#, 1
	volume 55
	note C#, 1
	dec_octave
	volume 147
	note G_, 1
	volume 55
	note G_, 1
	dec_octave
	volume 147
	note A#, 1
	volume 55
	note A#, 1
	musice8 8
	volume 128
	note A#, 1
	volume 55
	note A#, 2
	music_ret


Music_Club3_Ch3: ; fa63e (3e:663e)
	speed 9
	musicdc 17
	volume 32
	wave 1
	musice9 0
	musice8 8
	Loop 4
	octave 1
	note G_, 1
	rest 1
	note G_, 14
	rest 1
	inc_octave
	note F_, 1
	rest 2
	note G_, 1
	rest 2
	dec_octave
	note G_, 1
	rest 1
	note E_, 3
	note F_, 1
	rest 1
	note F#, 1
	rest 1
	EndLoop
	Loop 2
	octave 1
	note G_, 1
	octave 3
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note G_, 1
	inc_octave
	note F_, 1
	note G_, 1
	rest 1
	dec_octave
	note G_, 1
	rest 1
	inc_octave
	note G_, 1
	rest 1
	octave 4
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note E_, 1
	note F_, 1
	octave 4
	musice8 4
	note G_, 1
	octave 1
	musice8 8
	note G_, 1
	octave 3
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note G_, 1
	inc_octave
	note F_, 1
	note G_, 1
	rest 1
	dec_octave
	note G_, 1
	rest 1
	inc_octave
	note G_, 1
	rest 1
	inc_octave
	musice8 4
	note F_, 1
	rest 1
	musice8 8
	note E_, 1
	octave 1
	note F_, 1
	note F#, 1
	note D#, 1
	octave 3
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note D#, 1
	inc_octave
	note D_, 1
	note D#, 1
	rest 1
	dec_octave
	note D#, 1
	rest 1
	inc_octave
	note D#, 1
	rest 1
	octave 4
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note C_, 1
	note C#, 1
	octave 4
	musice8 4
	note G_, 1
	octave 1
	musice8 8
	note D#, 1
	octave 3
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note D#, 1
	inc_octave
	note D_, 1
	note D#, 1
	rest 1
	dec_octave
	note D#, 1
	rest 1
	inc_octave
	note D#, 1
	rest 1
	inc_octave
	musice8 4
	note F_, 1
	rest 1
	dec_octave
	musice8 8
	note D_, 1
	note D#, 1
	note E_, 1
	dec_octave
	note C_, 1
	octave 3
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note C_, 1
	note A#, 1
	inc_octave
	note C_, 1
	rest 1
	dec_octave
	note C_, 1
	rest 1
	inc_octave
	note C_, 1
	rest 1
	octave 4
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note A_, 1
	note A#, 1
	octave 4
	musice8 4
	note G_, 1
	octave 1
	musice8 8
	note C_, 1
	octave 3
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note C_, 1
	note A#, 1
	inc_octave
	note C_, 1
	rest 1
	dec_octave
	note C_, 1
	rest 1
	inc_octave
	note C_, 1
	rest 1
	inc_octave
	musice8 4
	note F_, 1
	rest 1
	musice8 8
	note E_, 1
	octave 1
	note A#, 1
	note B_, 1
	note D_, 1
	octave 3
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note D_, 1
	inc_octave
	note C_, 1
	note D_, 1
	rest 1
	dec_octave
	note D_, 1
	rest 1
	inc_octave
	note D_, 1
	rest 1
	octave 4
	musice8 4
	note C_, 1
	rest 1
	octave 2
	musice8 6
	note A#, 1
	dec_octave
	musice8 8
	note C_, 1
	note C#, 1
	note D_, 1
	octave 3
	musice8 4
	note G_, 1
	rest 1
	octave 1
	musice8 8
	note D_, 1
	inc_octave
	note C_, 1
	note D_, 1
	rest 1
	dec_octave
	note D_, 1
	rest 1
	note F_, 1
	rest 1
	inc_octave
	musice8 4
	note A#, 1
	rest 1
	dec_octave
	musice8 8
	note A#, 1
	note B_, 1
	inc_octave
	note C_, 1
	EndLoop
	EndMainLoop


Music_Club3_Ch4: ; fa772 (3e:6772)
	speed 9
	octave 1
	MainLoop
	Loop 3
	music_call Branch_fa796
	note snare1, 2
	note snare4, 2
	music_call Branch_fa796
	note snare1, 2
	note snare3, 1
	note snare1, 1
	EndLoop
	music_call Branch_fa796
	note snare1, 2
	note snare4, 2
	music_call Branch_fa796
	note snare1, 1
	speed 1
	note snare3, 5
	note snare1, 4
	speed 9
	note snare1, 1
	note snare1, 1
	EndMainLoop

Branch_fa796:
	note bass, 2
	note snare3, 2
	note snare1, 2
	note snare3, 1
	note snare1, 1
	note snare3, 1
	note bass, 1
	note snare4, 1
	note bass, 1
	music_ret
; 0xfa7a0