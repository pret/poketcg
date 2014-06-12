Music_HallOfHonor_Ch1: ; fafea (3e:6fea)
	speed 7
	musicdc 17
	musice8 8
	duty 2
	Loop 4
	music_call Branch_fb016
	EndLoop
	MainLoop
	Loop 8
	music_call Branch_fb016
	EndLoop
	octave 4
	volume 85
	note C_, 1
	volume 39
	note C_, 1
	music_call Branch_fb044
	Loop 23
	volume 85
	note C_, 1
	volume 39
	note G_, 1
	music_call Branch_fb044
	EndLoop
	EndMainLoop

Branch_fb016:
	octave 4
	volume 101
	note C_, 1
	volume 39
	note C_, 1
	volume 101
	note F_, 1
	volume 39
	note F_, 1
	volume 101
	note G_, 1
	volume 39
	note G_, 1
	volume 101
	note F_, 1
	volume 39
	note F_, 1
	inc_octave
	volume 101
	note C_, 1
	volume 39
	note C_, 1
	dec_octave
	volume 101
	note F_, 1
	volume 39
	note F_, 1
	volume 101
	note G_, 1
	volume 39
	note G_, 1
	music_ret

Branch_fb044:
	octave 4
	volume 85
	note F_, 1
	volume 39
	note C_, 1
	volume 85
	note G_, 1
	volume 39
	note F_, 1
	volume 85
	note F_, 1
	volume 39
	note G_, 1
	inc_octave
	volume 85
	note C_, 1
	dec_octave
	volume 39
	note F_, 1
	volume 85
	note F_, 1
	inc_octave
	volume 39
	note C_, 1
	dec_octave
	volume 85
	note G_, 1
	volume 39
	note F_, 1
	music_ret


Music_HallOfHonor_Ch2: ; fb06e (3e:706e)
	speed 7
	musicdc 17
	musice8 8
	duty 2
	musice4 255
	rest 2
	speed 1
	rest 4
	speed 7
	volume 23
	Loop 3
	music_call Branch_fb1ec
	EndLoop
	octave 4
	note C_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	inc_octave
	note C_, 1
	rest 1
	dec_octave
	note F_, 1
	speed 1
	rest 3
	speed 7
	musice4 0
	MainLoop
	octave 1
	duty 1
	Loop 3
	music_call Branch_fb0bb
	octave 1
	volume 109
	note E_, 5
	volume 208
	note E_, 11
	tie
	note E_, 12
	EndLoop
	music_call Branch_fb0bb
	octave 1
	volume 109
	note G_, 5
	volume 208
	note G_, 11
	tie
	note G_, 12
	EndMainLoop

Branch_fb0bb:
	octave 1
	volume 109
	note F_, 5
	volume 208
	note F_, 11
	tie
	note F_, 12
	volume 109
	note E_, 5
	volume 208
	note E_, 11
	tie
	note E_, 12
	volume 109
	note D_, 5
	volume 208
	note D_, 11
	tie
	note D_, 12
	music_ret


Music_HallOfHonor_Ch3: ; fb0d5 (3e:70d5)
	speed 7
	volume 64
	musicdc 17
	wave 2
	vibrato_type 4
	vibrato_delay 35
	musice8 6
	musice9 64
	rest 3
	volume 96
	musice8 8
	musice4 255
	Loop 4
	rest 14
	EndLoop
	MainLoop
	octave 5
	Loop 7
	music_call Branch_fb1ec
	EndLoop
	note C_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	inc_octave
	note C_, 1
	rest 1
	dec_octave
	note F_, 1
	volume 32
	musice4 0
	octave 4
	speed 1
	musice8 6
	note B_, 3
	inc_octave
	note C_, 4
	tie
	speed 7
	note C_, 15
	tie
	note C_, 8
	dec_octave
	musice8 8
	note B_, 2
	musice8 4
	note A_, 2
	musice8 6
	note G_, 6
	note C_, 10
	tie
	note C_, 12
	speed 1
	musice8 8
	note B_, 3
	inc_octave
	musice8 6
	note C_, 4
	tie
	speed 7
	note C_, 15
	tie
	note C_, 6
	dec_octave
	musice8 8
	note B_, 2
	inc_octave
	note C_, 2
	musice8 4
	note D_, 2
	dec_octave
	speed 1
	musice8 8
	note F#, 3
	musice8 6
	note G_, 4
	tie
	speed 7
	note G_, 15
	tie
	note G_, 6
	musice8 8
	note G_, 2
	note A_, 2
	musice8 4
	note B_, 2
	speed 1
	musice8 8
	note B_, 3
	inc_octave
	note C_, 4
	tie
	speed 7
	note C_, 15
	tie
	note C_, 8
	dec_octave
	note B_, 2
	musice8 4
	note A_, 2
	musice8 6
	note G_, 6
	musice8 8
	speed 1
	note B_, 3
	inc_octave
	musice8 6
	note C_, 4
	tie
	speed 7
	note C_, 9
	tie
	note C_, 6
	dec_octave
	musice8 8
	note G_, 2
	inc_octave
	note C_, 2
	musice8 4
	note E_, 2
	speed 1
	musice8 8
	note E_, 3
	note F_, 4
	tie
	speed 7
	note F_, 1
	note E_, 2
	musice8 4
	note C_, 2
	musice8 7
	note C_, 10
	tie
	note C_, 10
	musice8 4
	note E_, 2
	speed 1
	musice8 8
	note E_, 3
	note F_, 4
	tie
	speed 7
	note F_, 1
	note E_, 2
	musice8 4
	note C_, 2
	musice8 6
	note C_, 10
	tie
	note C_, 12
	speed 1
	musice8 8
	note F#, 3
	musice8 7
	note G_, 4
	tie
	speed 7
	note G_, 15
	tie
	note G_, 8
	musice8 8
	note F_, 2
	musice8 4
	note E_, 2
	musice8 8
	note F_, 2
	musice8 4
	note E_, 2
	note C_, 2
	dec_octave
	musice8 7
	note G_, 10
	tie
	note G_, 10
	musice8 8
	note E_, 2
	note F_, 2
	inc_octave
	musice8 4
	note C_, 2
	musice8 7
	note C_, 12
	tie
	note C_, 10
	dec_octave
	musice8 8
	note E_, 2
	note F_, 2
	inc_octave
	musice8 4
	note C_, 2
	musice8 6
	note C_, 12
	tie
	note C_, 12
	rest 3
	volume 96
	musice4 255
	musice8 8
	EndMainLoop

Branch_fb1ec:
	octave 4
	note C_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	inc_octave
	note C_, 1
	rest 1
	dec_octave
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	music_ret
; 0xfb1fe
