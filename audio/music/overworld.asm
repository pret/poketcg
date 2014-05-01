Music_Overworld_Ch1: ; f71a0 (3d:71a0)
	speed 7
	duty 0
	musicdc 17
	vibrato_rate 9
	vibrato_delay 25
	volume 162
	musice8 7
	octave 3
	rest 3
	music_call Branch_f72ba
	rest 3
	MainLoop
	music_call Branch_f72ba
	duty 1
	musice8 8
	octave 3
	volume 160
	note A_, 5
	volume 55
	note A_, 1
	inc_octave
	volume 160
	note C_, 5
	volume 55
	note C_, 1
	volume 160
	note F_, 3
	speed 1
	note E_, 11
	volume 55
	note E_, 10
	volume 160
	speed 7
	note G_, 3
	speed 1
	note F_, 11
	volume 55
	note F_, 10
	speed 7
	volume 160
	note C_, 12
	volume 55
	note C_, 2
	duty 0
	volume 146
	musice8 7
	octave 3
	note E_, 4
	note E_, 3
	note E_, 3
	duty 1
	volume 160
	musice8 8
	music_call Branch_f72fb
	note C_, 6
	volume 55
	note C_, 6
	volume 160
	note C_, 3
	note D_, 3
	note E_, 3
	note G_, 6
	volume 55
	note G_, 3
	volume 160
	note F_, 4
	volume 55
	note F_, 2
	volume 160
	note C_, 3
	dec_octave
	note A_, 6
	note A#, 9
	volume 55
	note A#, 6
	volume 160
	note A#, 3
	inc_octave
	note D_, 3
	note F_, 3
	note A_, 3
	volume 55
	note A_, 6
	volume 160
	note G_, 3
	volume 55
	note G_, 3
	volume 160
	note E_, 3
	note D_, 3
	volume 55
	note D_, 3
	volume 160
	note E_, 2
	volume 55
	note E_, 1
	volume 160
	musice8 8
	note C_, 9
	volume 55
	note C_, 3
	volume 160
	dec_octave
	note A_, 3
	inc_octave
	speed 1
	note C_, 11
	volume 64
	note C_, 10
	speed 7
	volume 160
	note G_, 3
	speed 1
	note F_, 11
	volume 64
	note F_, 10
	speed 7
	volume 160
	note C_, 12
	volume 55
	note C_, 6
	duty 2
	musice8 8
	volume 95
	octave 4
	note G_, 1
	no_fade
	note E_, 1
	no_fade
	note C_, 1
	no_fade
	dec_octave
	note G_, 1
	no_fade
	note E_, 1
	no_fade
	note C_, 1
	duty 1
	volume 160
	musice8 8
	music_call Branch_f72fb
	note C_, 6
	volume 55
	note C_, 6
	volume 160
	note C_, 3
	note D_, 3
	note E_, 3
	note F_, 9
	volume 55
	note F_, 12
	volume 160
	note F_, 2
	note G_, 1
	note A_, 1
	volume 55
	note A_, 2
	volume 160
	note A_, 12
	volume 55
	note A_, 3
	volume 160
	note D_, 3
	note A_, 3
	note A#, 9
	volume 55
	note A#, 6
	volume 160
	note A_, 5
	volume 55
	note A_, 1
	volume 160
	note G_, 5
	volume 55
	note G_, 1
	volume 144
	note F_, 8
	no_fade
	note F_, 8
	no_fade
	note F_, 8
	no_fade
	note F_, 8
	no_fade
	note F_, 8
	no_fade
	note F_, 8
	volume 55
	note F_, 3
	duty 0
	volume 162
	musice8 7
	EndMainLoop

Branch_f72ba:
	octave 3
	note F_, 3
	note F_, 2
	note A_, 1
	inc_octave
	volume 160
	musice8 4
	note C_, 1
	rest 1
	dec_octave
	volume 146
	musice8 7
	note A#, 3
	note A#, 1
	inc_octave
	volume 160
	musice8 4
	note D_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note G_, 3
	note A#, 3
	rest 3
	note A_, 3
	note A_, 2
	inc_octave
	note C_, 1
	volume 160
	musice8 4
	note C_, 1
	rest 1
	dec_octave
	volume 146
	musice8 7
	note A#, 3
	note A#, 1
	inc_octave
	volume 160
	musice8 4
	note D_, 1
	rest 2
	volume 146
	musice8 7
	note C_, 3
	dec_octave
	note A#, 3
	music_ret

Branch_f72fb:
	octave 4
	volume 160
	note D_, 5
	volume 55
	note D_, 1
	volume 160
	note F_, 5
	volume 55
	note F_, 1
	volume 160
	note A_, 3
	speed 1
	note G_, 11
	volume 55
	note G_, 10
	speed 7
	inc_octave
	volume 160
	note C_, 3
	dec_octave
	speed 1
	note A#, 11
	volume 55
	note A#, 10
	speed 7
	volume 160
	note C#, 12
	volume 55
	note C#, 6
	volume 160
	note D#, 3
	speed 1
	note C#, 11
	volume 55
	note C#, 10
	volume 160
	speed 7
	music_ret


Music_Overworld_Ch2: ; f7334 (3d:7334)
	speed 7
	duty 0
	musicdc 17
	vibrato_rate 9
	vibrato_delay 30
	musice8 7
	octave 3
	music_call Branch_f7535
	MainLoop
	music_call Branch_f7535
	volume 146
	musice8 7
	rest 3
	note C_, 5
	note C_, 3
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note C_, 4
	note C_, 3
	note C_, 3
	rest 3
	note C_, 5
	note C_, 3
	volume 144
	musice8 4
	inc_octave
	note G_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note D_, 4
	note D_, 3
	note C_, 3
	rest 3
	dec_octave
	note A#, 5
	inc_octave
	note D_, 3
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note C_, 4
	note C_, 3
	dec_octave
	note A#, 3
	rest 3
	note A#, 5
	inc_octave
	note C#, 3
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note C#, 4
	dec_octave
	note F_, 3
	note A#, 3
	rest 3
	inc_octave
	note C_, 3
	note E_, 2
	note C_, 3
	volume 144
	musice8 4
	inc_octave
	note G_, 1
	musice8 7
	volume 96
	musice8 8
	octave 3
	note E_, 3
	note F_, 3
	note G_, 3
	musice8 7
	note A#, 6
	volume 146
	musice8 7
	octave 3
	note D_, 3
	volume 96
	musice8 8
	octave 3
	note A_, 3
	volume 146
	musice8 7
	octave 2
	note A_, 2
	inc_octave
	inc_octave
	volume 144
	musice8 4
	note F_, 1
	dec_octave
	rest 2
	volume 146
	musice8 7
	note D_, 4
	note D_, 3
	dec_octave
	note A_, 3
	rest 3
	note A#, 3
	inc_octave
	note D_, 2
	dec_octave
	note A#, 3
	volume 144
	musice8 4
	inc_octave
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	dec_octave
	volume 146
	musice8 7
	note A#, 4
	note A#, 3
	note A#, 3
	rest 3
	note A#, 3
	inc_octave
	note D_, 2
	dec_octave
	note A#, 3
	volume 144
	musice8 4
	inc_octave
	note A_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note A#, 6
	inc_octave
	note D_, 1
	dec_octave
	note A#, 3
	rest 3
	inc_octave
	note C_, 5
	note C_, 3
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 2
	volume 146
	musice8 7
	dec_octave
	note C_, 4
	note C_, 3
	note C_, 3
	rest 3
	note C_, 5
	note C_, 3
	volume 144
	musice8 4
	inc_octave
	note G_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note D_, 4
	duty 2
	volume 95
	musice8 8
	octave 4
	note C_, 1
	no_fade
	dec_octave
	note G_, 1
	no_fade
	note E_, 1
	no_fade
	note C_, 1
	no_fade
	dec_octave
	note G_, 1
	no_fade
	note E_, 1
	duty 0
	volume 146
	musice8 7
	octave 2
	rest 3
	note A#, 5
	inc_octave
	note D_, 3
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note C_, 4
	note C_, 3
	dec_octave
	note A#, 3
	rest 3
	note A#, 5
	inc_octave
	note C#, 3
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note C#, 4
	note C#, 3
	note C#, 3
	rest 3
	note C_, 3
	dec_octave
	note A_, 2
	inc_octave
	note C_, 3
	volume 144
	musice8 4
	inc_octave
	note G_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note C_, 4
	note E_, 3
	note C_, 3
	rest 3
	note D_, 6
	dec_octave
	note B_, 2
	inc_octave
	inc_octave
	volume 144
	musice8 4
	note F_, 1
	rest 2
	dec_octave
	volume 146
	musice8 7
	note D_, 4
	volume 96
	musice8 8
	octave 4
	note D_, 2
	note E_, 1
	note F_, 1
	volume 39
	note F_, 2
	volume 96
	note F_, 11
	volume 146
	musice8 7
	octave 4
	volume 144
	musice8 4
	note F_, 1
	rest 2
	dec_octave
	dec_octave
	volume 146
	musice8 7
	note A#, 1
	volume 96
	musice8 8
	octave 3
	note A#, 3
	inc_octave
	note F_, 3
	note G_, 9
	volume 146
	musice8 7
	octave 3
	note D_, 2
	dec_octave
	note A#, 3
	inc_octave
	inc_octave
	volume 144
	musice8 4
	note F_, 1
	musice8 8
	volume 96
	octave 4
	note C_, 5
	volume 39
	note C_, 1
	dec_octave
	volume 144
	note A#, 5
	volume 39
	note A#, 1
	volume 146
	musice8 7
	octave 3
	rest 3
	note F_, 3
	note C_, 2
	note F_, 1
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	volume 146
	musice8 7
	note G_, 3
	note G_, 3
	speed 1
	volume 144
	musice8 8
	inc_octave
	note F_, 4
	note C_, 3
	speed 7
	dec_octave
	volume 146
	musice8 7
	note E_, 3
	note G_, 2
	inc_octave
	volume 144
	musice8 4
	note F_, 1
	volume 146
	musice8 7
	dec_octave
	rest 3
	note A_, 3
	note F_, 2
	note A_, 1
	inc_octave
	volume 144
	musice8 4
	note F_, 1
	rest 1
	dec_octave
	volume 146
	musice8 7
	note G_, 3
	note G_, 3
	speed 1
	volume 144
	musice8 8
	inc_octave
	note F_, 4
	note C_, 3
	dec_octave
	speed 7
	volume 146
	musice8 7
	note A_, 3
	note G_, 2
	inc_octave
	volume 144
	musice8 4
	note F_, 1
	EndMainLoop

Branch_f7535:
	octave 3
	volume 146
	musice8 7
	rest 3
	note C_, 3
	note C_, 2
	note F_, 1
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	volume 146
	musice8 7
	note G_, 3
	note G_, 1
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	musice8 8
	speed 1
	inc_octave
	note F_, 4
	note C_, 3
	speed 7
	volume 146
	musice8 7
	dec_octave
	note E_, 3
	note G_, 2
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	dec_octave
	rest 3
	volume 146
	musice8 8
	note F_, 3
	note F_, 2
	note A_, 1
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	volume 146
	musice8 7
	note G_, 3
	note G_, 1
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	musice8 8
	speed 1
	inc_octave
	note F_, 4
	note C_, 3
	speed 7
	volume 146
	musice8 7
	dec_octave
	note A_, 3
	note G_, 2
	volume 144
	musice8 4
	inc_octave
	note F_, 1
	dec_octave
	music_ret


Music_Overworld_Ch3: ; f75a1 (3d:75a1)
	speed 7
	musicdc 17
	volume 32
	wave 1
	musice9 64
	musice8 7
	octave 1
	music_call Branch_f77f8
	note F_, 2
	inc_octave
	note C_, 1
	MainLoop
	music_call Branch_f77f8
	note F_, 3
	music_call Branch_f7826
	octave 1
	musice8 8
	note F_, 1
	note A#, 2
	rest 1
	octave 3
	musice8 3
	note C#, 2
	dec_octave
	musice8 8
	note F_, 1
	note A#, 1
	rest 1
	inc_octave
	musice8 3
	note F_, 2
	rest 1
	inc_octave
	note C#, 1
	octave 1
	musice8 8
	note A#, 1
	rest 1
	octave 3
	musice8 7
	note G_, 1
	octave 1
	musice8 8
	note A#, 1
	rest 1
	note F_, 1
	inc_octave
	musice8 3
	note A#, 2
	dec_octave
	musice8 8
	note A#, 1
	octave 3
	musice8 3
	note C#, 2
	octave 1
	musice8 8
	note F_, 1
	note A_, 2
	rest 1
	octave 3
	musice8 3
	note E_, 2
	octave 1
	musice8 8
	note A_, 1
	octave 3
	musice8 3
	note G_, 2
	musice8 7
	note E_, 1
	musice8 8
	dec_octave
	note E_, 1
	rest 1
	inc_octave
	inc_octave
	musice8 3
	note E_, 1
	octave 1
	musice8 8
	note A_, 1
	rest 1
	inc_octave
	note A_, 1
	rest 2
	dec_octave
	note A_, 1
	inc_octave
	note A_, 1
	note E_, 1
	note C_, 1
	dec_octave
	note A_, 1
	rest 1
	inc_octave
	note A_, 1
	dec_octave
	note D_, 2
	rest 1
	octave 3
	musice8 3
	note F_, 2
	octave 1
	musice8 8
	note A_, 1
	inc_octave
	note D_, 2
	dec_octave
	note A_, 1
	octave 3
	musice8 3
	note D_, 2
	inc_octave
	note C_, 1
	octave 1
	musice8 8
	note D_, 2
	octave 3
	musice8 3
	note F_, 2
	rest 1
	octave 1
	musice8 8
	note A_, 1
	octave 3
	musice8 3
	note F_, 2
	octave 1
	musice8 8
	note D_, 1
	octave 3
	musice8 3
	note D_, 2
	musice8 8
	octave 1
	note A_, 1
	note G_, 2
	rest 1
	octave 3
	musice8 3
	note D_, 2
	octave 1
	musice8 8
	note G_, 1
	octave 3
	musice8 3
	note F_, 2
	musice8 7
	note D_, 1
	dec_octave
	musice8 8
	note D_, 1
	rest 1
	musice8 3
	inc_octave
	note A#, 1
	octave 1
	musice8 8
	note G_, 1
	rest 1
	octave 3
	musice8 3
	note D_, 2
	rest 1
	dec_octave
	musice8 8
	note D_, 1
	inc_octave
	musice8 3
	note F_, 2
	octave 1
	musice8 8
	note G_, 1
	octave 3
	musice8 3
	note D_, 2
	musice8 8
	dec_octave
	note D_, 1
	note C_, 2
	rest 1
	inc_octave
	musice8 3
	note D_, 2
	octave 1
	musice8 8
	note G_, 1
	octave 3
	musice8 3
	note F_, 2
	musice8 7
	note D_, 1
	octave 1
	musice8 8
	note C_, 1
	rest 1
	octave 3
	musice8 3
	note F_, 1
	dec_octave
	musice8 8
	note C_, 1
	rest 1
	inc_octave
	musice8 3
	note D_, 2
	rest 1
	octave 1
	musice8 8
	note E_, 1
	inc_octave
	note C_, 1
	rest 1
	inc_octave
	musice8 7
	note F_, 1
	musice8 3
	note E_, 2
	musice8 8
	octave 1
	note E_, 1
	music_call Branch_f7826
	musice8 8
	octave 2
	note C_, 1
	note C#, 2
	rest 1
	inc_octave
	musice8 3
	note C#, 2
	octave 1
	musice8 8
	note G#, 1
	inc_octave
	note C#, 1
	rest 1
	inc_octave
	musice8 3
	note F_, 2
	rest 1
	inc_octave
	note C#, 1
	octave 2
	musice8 8
	note C#, 1
	rest 1
	inc_octave
	note G_, 1
	dec_octave
	musice8 8
	note C#, 1
	rest 1
	dec_octave
	note G#, 1
	octave 3
	musice8 3
	note G_, 2
	dec_octave
	musice8 8
	note C#, 1
	inc_octave
	musice8 3
	note F_, 2
	octave 1
	musice8 8
	note G#, 1
	inc_octave
	note C_, 2
	rest 1
	inc_octave
	musice8 3
	note E_, 2
	dec_octave
	musice8 8
	note G_, 1
	inc_octave
	musice8 3
	note C_, 2
	musice8 7
	note E_, 1
	dec_octave
	musice8 8
	note E_, 1
	rest 1
	octave 4
	musice8 3
	note E_, 1
	octave 2
	musice8 8
	note C_, 1
	rest 1
	inc_octave
	musice8 3
	note E_, 2
	rest 1
	octave 1
	musice8 8
	note G_, 1
	octave 3
	musice8 3
	note G_, 2
	dec_octave
	musice8 8
	note C_, 1
	inc_octave
	musice8 3
	note E_, 2
	octave 1
	musice8 8
	note G_, 1
	note B_, 2
	rest 1
	octave 3
	musice8 3
	note F_, 2
	dec_octave
	musice8 8
	note F_, 1
	note B_, 2
	note F_, 1
	inc_octave
	musice8 3
	note D_, 2
	inc_octave
	note D_, 1
	octave 1
	musice8 8
	note B_, 2
	octave 3
	musice8 3
	note F_, 2
	rest 1
	dec_octave
	musice8 8
	note F_, 1
	note B_, 2
	note F_, 1
	dec_octave
	note B_, 2
	rest 1
	note A#, 2
	rest 1
	octave 3
	musice8 3
	note D_, 2
	dec_octave
	musice8 8
	note F_, 1
	note A#, 2
	note F_, 1
	inc_octave
	musice8 3
	note F_, 2
	inc_octave
	note D_, 1
	octave 1
	musice8 8
	note A#, 1
	rest 1
	octave 3
	musice8 7
	note D_, 1
	octave 1
	musice8 8
	note A#, 1
	rest 2
	note A#, 2
	inc_octave
	note F_, 1
	note A#, 1
	rest 2
	note C_, 2
	rest 1
	inc_octave
	musice8 3
	note D_, 2
	octave 1
	musice8 8
	note G_, 1
	octave 3
	musice8 3
	note F_, 2
	musice8 7
	note D_, 1
	octave 1
	musice8 8
	note C_, 1
	rest 1
	octave 4
	musice8 3
	note D_, 1
	octave 2
	musice8 8
	note C_, 1
	rest 1
	inc_octave
	musice8 3
	note D_, 2
	rest 1
	octave 1
	musice8 8
	note E_, 1
	inc_octave
	note C_, 1
	dec_octave
	note G_, 1
	note E_, 1
	note C_, 1
	rest 1
	note E_, 1
	note F_, 3
	octave 3
	musice8 3
	note A_, 2
	dec_octave
	musice8 8
	note C_, 1
	inc_octave
	musice8 5
	note F_, 2
	note A_, 1
	inc_octave
	note C_, 1
	dec_octave
	rest 1
	note A#, 2
	rest 1
	note A#, 1
	inc_octave
	note D_, 1
	dec_octave
	rest 2
	note G_, 2
	dec_octave
	musice8 8
	note C_, 1
	inc_octave
	musice8 5
	note A#, 2
	inc_octave
	note C_, 1
	octave 1
	musice8 8
	note F_, 3
	octave 4
	musice8 3
	note C_, 2
	octave 2
	musice8 8
	note C_, 1
	inc_octave
	musice8 5
	note A_, 2
	inc_octave
	note C_, 1
	note C_, 1
	rest 1
	dec_octave
	note A#, 2
	rest 1
	note A#, 1
	inc_octave
	note D_, 1
	rest 2
	note C_, 2
	octave 2
	musice8 8
	note C_, 1
	inc_octave
	musice8 5
	note A#, 2
	dec_octave
	musice8 8
	note C_, 1
	EndMainLoop

Branch_f77f8:
	octave 1
	note F_, 3
	octave 3
	musice8 3
	note A_, 2
	dec_octave
	musice8 8
	note C_, 1
	note F_, 2
	note C_, 1
	rest 2
	note F_, 1
	rest 2
	note F_, 1
	rest 2
	note C_, 1
	note F_, 2
	note C_, 1
	dec_octave
	note F_, 2
	inc_octave
	note C_, 1
	dec_octave
	note F_, 3
	octave 4
	musice8 3
	note C_, 2
	octave 2
	musice8 8
	note C_, 1
	note F_, 2
	note C_, 1
	rest 2
	note F_, 1
	rest 2
	note F_, 1
	rest 2
	note C_, 1
	note F_, 2
	note C_, 1
	dec_octave
	music_ret

Branch_f7826:
	octave 1
	note F_, 2
	rest 1
	octave 3
	musice8 3
	note F_, 2
	dec_octave
	musice8 8
	note C_, 1
	note F_, 1
	rest 1
	inc_octave
	musice8 3
	note F_, 2
	rest 1
	inc_octave
	note C_, 1
	octave 1
	musice8 8
	note F_, 1
	rest 1
	octave 3
	musice8 7
	note G_, 1
	octave 1
	musice8 8
	note F_, 1
	rest 1
	note C_, 1
	octave 3
	musice8 3
	note G_, 2
	octave 1
	musice8 8
	note F_, 1
	octave 3
	musice8 7
	note F_, 2
	octave 1
	musice8 8
	note G_, 1
	note A_, 2
	rest 1
	octave 3
	musice8 3
	note E_, 2
	dec_octave
	musice8 8
	note E_, 1
	note A_, 1
	rest 1
	inc_octave
	musice8 3
	note E_, 2
	rest 1
	inc_octave
	note C_, 1
	octave 1
	musice8 8
	note A_, 1
	rest 1
	octave 3
	musice8 7
	note E_, 1
	octave 1
	musice8 8
	Loop 2
	note A_, 1
	rest 1
	note E_, 1
	EndLoop
	note A_, 2
	rest 1
	note A#, 2
	rest 1
	octave 3
	musice8 3
	note D_, 2
	dec_octave
	musice8 8
	note F_, 1
	note A#, 1
	rest 1
	inc_octave
	musice8 3
	note F_, 2
	rest 1
	inc_octave
	note D_, 1
	octave 1
	musice8 8
	note A#, 1
	rest 1
	octave 3
	musice8 7
	note D_, 1
	octave 1
	musice8 8
	note A#, 1
	rest 1
	note F_, 1
	octave 3
	musice8 3
	note D_, 2
	octave 1
	musice8 8
	note A#, 1
	octave 3
	musice8 3
	note D_, 2
	music_ret


Music_Overworld_Ch4: ; f78af (3d:78af)
	speed 7
	octave 1
	music_call Branch_f78ee
	music_call Branch_f78fb
	MainLoop
	music_call Branch_f78ee
	note bass, 3
	note snare3, 2
	note bass, 1
	note snare1, 3
	note snare3, 2
	note snare4, 1
	note bass, 2
	note snare3, 1
	note snare3, 3
	note snare1, 1
	note snare3, 1
	note snare3, 1
	note snare1, 3
	Loop 3
	music_call Branch_f78ee
	music_call Branch_f78fb
	EndLoop
	music_call Branch_f78ee
	music_call Branch_f790a
	Loop 3
	music_call Branch_f78ee
	music_call Branch_f78fb
	EndLoop
	music_call Branch_f78ee
	music_call Branch_f790a
	music_call Branch_f78ee
	music_call Branch_f78fb
	EndMainLoop

Branch_f78ee:
	note bass, 3
	note snare3, 2
	note bass, 1
	note snare1, 3
	note snare3, 2
	note snare4, 1
	note bass, 2
	note snare3, 1
	note snare3, 3
	note snare1, 3
	note snare3, 2
	note snare4, 1
	music_ret

Branch_f78fb:
	note bass, 3
	note snare3, 2
	note bass, 1
	note snare1, 3
	note snare3, 2
	note snare4, 1
	note bass, 2
	note snare3, 1
	note snare3, 3
	note snare1, 1
	note snare3, 1
	note snare3, 1
	note snare3, 2
	note snare4, 1
	music_ret

Branch_f790a:
	note bass, 3
	note snare3, 2
	note bass, 1
	note snare1, 3
	note snare3, 2
	note snare4, 1
	note bass, 2
	note snare3, 1
	note snare3, 3
	note snare1, 1
	note snare3, 1
	note snare3, 1
	note snare1, 2
	note snare1, 1
	music_ret
; 0xf7919