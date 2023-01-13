Music_Overworld_Ch1:
	speed 7
	duty 0
	stereo_panning TRUE, TRUE
	vibrato_type 9
	vibrato_delay 25
	volume_envelope 10, 2
	cutoff 7
	octave 3
	rest 3
	music_call Branch_f72ba
	rest 3
	MainLoop
	music_call Branch_f72ba
	duty 1
	cutoff 8
	octave 3
	volume_envelope 10, 0
	note A_, 5
	volume_envelope 3, 7
	note A_, 1
	inc_octave
	volume_envelope 10, 0
	note C_, 5
	volume_envelope 3, 7
	note C_, 1
	volume_envelope 10, 0
	note F_, 3
	speed 1
	note E_, 11
	volume_envelope 3, 7
	note E_, 10
	volume_envelope 10, 0
	speed 7
	note G_, 3
	speed 1
	note F_, 11
	volume_envelope 3, 7
	note F_, 10
	speed 7
	volume_envelope 10, 0
	note C_, 12
	volume_envelope 3, 7
	note C_, 2
	duty 0
	volume_envelope 9, 2
	cutoff 7
	octave 3
	note E_, 4
	note E_, 3
	note E_, 3
	duty 1
	volume_envelope 10, 0
	cutoff 8
	music_call Branch_f72fb
	note C_, 6
	volume_envelope 3, 7
	note C_, 6
	volume_envelope 10, 0
	note C_, 3
	note D_, 3
	note E_, 3
	note G_, 6
	volume_envelope 3, 7
	note G_, 3
	volume_envelope 10, 0
	note F_, 4
	volume_envelope 3, 7
	note F_, 2
	volume_envelope 10, 0
	note C_, 3
	dec_octave
	note A_, 6
	note A#, 9
	volume_envelope 3, 7
	note A#, 6
	volume_envelope 10, 0
	note A#, 3
	inc_octave
	note D_, 3
	note F_, 3
	note A_, 3
	volume_envelope 3, 7
	note A_, 6
	volume_envelope 10, 0
	note G_, 3
	volume_envelope 3, 7
	note G_, 3
	volume_envelope 10, 0
	note E_, 3
	note D_, 3
	volume_envelope 3, 7
	note D_, 3
	volume_envelope 10, 0
	note E_, 2
	volume_envelope 3, 7
	note E_, 1
	volume_envelope 10, 0
	cutoff 8
	note C_, 9
	volume_envelope 3, 7
	note C_, 3
	volume_envelope 10, 0
	dec_octave
	note A_, 3
	inc_octave
	speed 1
	note C_, 11
	volume_envelope 4, 0
	note C_, 10
	speed 7
	volume_envelope 10, 0
	note G_, 3
	speed 1
	note F_, 11
	volume_envelope 4, 0
	note F_, 10
	speed 7
	volume_envelope 10, 0
	note C_, 12
	volume_envelope 3, 7
	note C_, 6
	duty 2
	cutoff 8
	volume_envelope 5, -7
	octave 4
	note G_, 1
	tie
	note E_, 1
	tie
	note C_, 1
	tie
	dec_octave
	note G_, 1
	tie
	note E_, 1
	tie
	note C_, 1
	duty 1
	volume_envelope 10, 0
	cutoff 8
	music_call Branch_f72fb
	note C_, 6
	volume_envelope 3, 7
	note C_, 6
	volume_envelope 10, 0
	note C_, 3
	note D_, 3
	note E_, 3
	note F_, 9
	volume_envelope 3, 7
	note F_, 12
	volume_envelope 10, 0
	note F_, 2
	note G_, 1
	note A_, 1
	volume_envelope 3, 7
	note A_, 2
	volume_envelope 10, 0
	note A_, 12
	volume_envelope 3, 7
	note A_, 3
	volume_envelope 10, 0
	note D_, 3
	note A_, 3
	note A#, 9
	volume_envelope 3, 7
	note A#, 6
	volume_envelope 10, 0
	note A_, 5
	volume_envelope 3, 7
	note A_, 1
	volume_envelope 10, 0
	note G_, 5
	volume_envelope 3, 7
	note G_, 1
	volume_envelope 9, 0
	note F_, 8
	tie
	note F_, 8
	tie
	note F_, 8
	tie
	note F_, 8
	tie
	note F_, 8
	tie
	note F_, 8
	volume_envelope 3, 7
	note F_, 3
	duty 0
	volume_envelope 10, 2
	cutoff 7
	EndMainLoop

Branch_f72ba:
	octave 3
	note F_, 3
	note F_, 2
	note A_, 1
	inc_octave
	volume_envelope 10, 0
	cutoff 4
	note C_, 1
	rest 1
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note A#, 3
	note A#, 1
	inc_octave
	volume_envelope 10, 0
	cutoff 4
	note D_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note G_, 3
	note A#, 3
	rest 3
	note A_, 3
	note A_, 2
	inc_octave
	note C_, 1
	volume_envelope 10, 0
	cutoff 4
	note C_, 1
	rest 1
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note A#, 3
	note A#, 1
	inc_octave
	volume_envelope 10, 0
	cutoff 4
	note D_, 1
	rest 2
	volume_envelope 9, 2
	cutoff 7
	note C_, 3
	dec_octave
	note A#, 3
	music_ret

Branch_f72fb:
	octave 4
	volume_envelope 10, 0
	note D_, 5
	volume_envelope 3, 7
	note D_, 1
	volume_envelope 10, 0
	note F_, 5
	volume_envelope 3, 7
	note F_, 1
	volume_envelope 10, 0
	note A_, 3
	speed 1
	note G_, 11
	volume_envelope 3, 7
	note G_, 10
	speed 7
	inc_octave
	volume_envelope 10, 0
	note C_, 3
	dec_octave
	speed 1
	note A#, 11
	volume_envelope 3, 7
	note A#, 10
	speed 7
	volume_envelope 10, 0
	note C#, 12
	volume_envelope 3, 7
	note C#, 6
	volume_envelope 10, 0
	note D#, 3
	speed 1
	note C#, 11
	volume_envelope 3, 7
	note C#, 10
	volume_envelope 10, 0
	speed 7
	music_ret


Music_Overworld_Ch2:
	speed 7
	duty 0
	stereo_panning TRUE, TRUE
	vibrato_type 9
	vibrato_delay 30
	cutoff 7
	octave 3
	music_call Branch_f7535
	MainLoop
	music_call Branch_f7535
	volume_envelope 9, 2
	cutoff 7
	rest 3
	note C_, 5
	note C_, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note C_, 4
	note C_, 3
	note C_, 3
	rest 3
	note C_, 5
	note C_, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note G_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note D_, 4
	note D_, 3
	note C_, 3
	rest 3
	dec_octave
	note A#, 5
	inc_octave
	note D_, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note C_, 4
	note C_, 3
	dec_octave
	note A#, 3
	rest 3
	note A#, 5
	inc_octave
	note C#, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note C#, 4
	dec_octave
	note F_, 3
	note A#, 3
	rest 3
	inc_octave
	note C_, 3
	note E_, 2
	note C_, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note G_, 1
	cutoff 7
	volume_envelope 6, 0
	cutoff 8
	octave 3
	note E_, 3
	note F_, 3
	note G_, 3
	cutoff 7
	note A#, 6
	volume_envelope 9, 2
	cutoff 7
	octave 3
	note D_, 3
	volume_envelope 6, 0
	cutoff 8
	octave 3
	note A_, 3
	volume_envelope 9, 2
	cutoff 7
	octave 2
	note A_, 2
	inc_octave
	inc_octave
	volume_envelope 9, 0
	cutoff 4
	note F_, 1
	dec_octave
	rest 2
	volume_envelope 9, 2
	cutoff 7
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
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note A#, 4
	note A#, 3
	note A#, 3
	rest 3
	note A#, 3
	inc_octave
	note D_, 2
	dec_octave
	note A#, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note A_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note A#, 6
	inc_octave
	note D_, 1
	dec_octave
	note A#, 3
	rest 3
	inc_octave
	note C_, 5
	note C_, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 2
	volume_envelope 9, 2
	cutoff 7
	dec_octave
	note C_, 4
	note C_, 3
	note C_, 3
	rest 3
	note C_, 5
	note C_, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note G_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note D_, 4
	duty 2
	volume_envelope 5, -7
	cutoff 8
	octave 4
	note C_, 1
	tie
	dec_octave
	note G_, 1
	tie
	note E_, 1
	tie
	note C_, 1
	tie
	dec_octave
	note G_, 1
	tie
	note E_, 1
	duty 0
	volume_envelope 9, 2
	cutoff 7
	octave 2
	rest 3
	note A#, 5
	inc_octave
	note D_, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note C_, 4
	note C_, 3
	dec_octave
	note A#, 3
	rest 3
	note A#, 5
	inc_octave
	note C#, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note C#, 4
	note C#, 3
	note C#, 3
	rest 3
	note C_, 3
	dec_octave
	note A_, 2
	inc_octave
	note C_, 3
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note G_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note C_, 4
	note E_, 3
	note C_, 3
	rest 3
	note D_, 6
	dec_octave
	note B_, 2
	inc_octave
	inc_octave
	volume_envelope 9, 0
	cutoff 4
	note F_, 1
	rest 2
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note D_, 4
	volume_envelope 6, 0
	cutoff 8
	octave 4
	note D_, 2
	note E_, 1
	note F_, 1
	volume_envelope 2, 7
	note F_, 2
	volume_envelope 6, 0
	note F_, 11
	volume_envelope 9, 2
	cutoff 7
	octave 4
	volume_envelope 9, 0
	cutoff 4
	note F_, 1
	rest 2
	dec_octave
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note A#, 1
	volume_envelope 6, 0
	cutoff 8
	octave 3
	note A#, 3
	inc_octave
	note F_, 3
	note G_, 9
	volume_envelope 9, 2
	cutoff 7
	octave 3
	note D_, 2
	dec_octave
	note A#, 3
	inc_octave
	inc_octave
	volume_envelope 9, 0
	cutoff 4
	note F_, 1
	cutoff 8
	volume_envelope 6, 0
	octave 4
	note C_, 5
	volume_envelope 2, 7
	note C_, 1
	dec_octave
	volume_envelope 9, 0
	note A#, 5
	volume_envelope 2, 7
	note A#, 1
	volume_envelope 9, 2
	cutoff 7
	octave 3
	rest 3
	note F_, 3
	note C_, 2
	note F_, 1
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note G_, 3
	note G_, 3
	speed 1
	volume_envelope 9, 0
	cutoff 8
	inc_octave
	note F_, 4
	note C_, 3
	speed 7
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note E_, 3
	note G_, 2
	inc_octave
	volume_envelope 9, 0
	cutoff 4
	note F_, 1
	volume_envelope 9, 2
	cutoff 7
	dec_octave
	rest 3
	note A_, 3
	note F_, 2
	note A_, 1
	inc_octave
	volume_envelope 9, 0
	cutoff 4
	note F_, 1
	rest 1
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note G_, 3
	note G_, 3
	speed 1
	volume_envelope 9, 0
	cutoff 8
	inc_octave
	note F_, 4
	note C_, 3
	dec_octave
	speed 7
	volume_envelope 9, 2
	cutoff 7
	note A_, 3
	note G_, 2
	inc_octave
	volume_envelope 9, 0
	cutoff 4
	note F_, 1
	EndMainLoop

Branch_f7535:
	octave 3
	volume_envelope 9, 2
	cutoff 7
	rest 3
	note C_, 3
	note C_, 2
	note F_, 1
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note G_, 3
	note G_, 1
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	cutoff 8
	speed 1
	inc_octave
	note F_, 4
	note C_, 3
	speed 7
	volume_envelope 9, 2
	cutoff 7
	dec_octave
	note E_, 3
	note G_, 2
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	dec_octave
	rest 3
	volume_envelope 9, 2
	cutoff 8
	note F_, 3
	note F_, 2
	note A_, 1
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	volume_envelope 9, 2
	cutoff 7
	note G_, 3
	note G_, 1
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	rest 1
	dec_octave
	cutoff 8
	speed 1
	inc_octave
	note F_, 4
	note C_, 3
	speed 7
	volume_envelope 9, 2
	cutoff 7
	dec_octave
	note A_, 3
	note G_, 2
	volume_envelope 9, 0
	cutoff 4
	inc_octave
	note F_, 1
	dec_octave
	music_ret


Music_Overworld_Ch3:
	speed 7
	stereo_panning TRUE, TRUE
	volume_envelope 2, 0
	wave 1
	echo 64
	cutoff 7
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
	cutoff 8
	note F_, 1
	note A#, 2
	rest 1
	octave 3
	cutoff 3
	note C#, 2
	dec_octave
	cutoff 8
	note F_, 1
	note A#, 1
	rest 1
	inc_octave
	cutoff 3
	note F_, 2
	rest 1
	inc_octave
	note C#, 1
	octave 1
	cutoff 8
	note A#, 1
	rest 1
	octave 3
	cutoff 7
	note G_, 1
	octave 1
	cutoff 8
	note A#, 1
	rest 1
	note F_, 1
	inc_octave
	cutoff 3
	note A#, 2
	dec_octave
	cutoff 8
	note A#, 1
	octave 3
	cutoff 3
	note C#, 2
	octave 1
	cutoff 8
	note F_, 1
	note A_, 2
	rest 1
	octave 3
	cutoff 3
	note E_, 2
	octave 1
	cutoff 8
	note A_, 1
	octave 3
	cutoff 3
	note G_, 2
	cutoff 7
	note E_, 1
	cutoff 8
	dec_octave
	note E_, 1
	rest 1
	inc_octave
	inc_octave
	cutoff 3
	note E_, 1
	octave 1
	cutoff 8
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
	cutoff 3
	note F_, 2
	octave 1
	cutoff 8
	note A_, 1
	inc_octave
	note D_, 2
	dec_octave
	note A_, 1
	octave 3
	cutoff 3
	note D_, 2
	inc_octave
	note C_, 1
	octave 1
	cutoff 8
	note D_, 2
	octave 3
	cutoff 3
	note F_, 2
	rest 1
	octave 1
	cutoff 8
	note A_, 1
	octave 3
	cutoff 3
	note F_, 2
	octave 1
	cutoff 8
	note D_, 1
	octave 3
	cutoff 3
	note D_, 2
	cutoff 8
	octave 1
	note A_, 1
	note G_, 2
	rest 1
	octave 3
	cutoff 3
	note D_, 2
	octave 1
	cutoff 8
	note G_, 1
	octave 3
	cutoff 3
	note F_, 2
	cutoff 7
	note D_, 1
	dec_octave
	cutoff 8
	note D_, 1
	rest 1
	cutoff 3
	inc_octave
	note A#, 1
	octave 1
	cutoff 8
	note G_, 1
	rest 1
	octave 3
	cutoff 3
	note D_, 2
	rest 1
	dec_octave
	cutoff 8
	note D_, 1
	inc_octave
	cutoff 3
	note F_, 2
	octave 1
	cutoff 8
	note G_, 1
	octave 3
	cutoff 3
	note D_, 2
	cutoff 8
	dec_octave
	note D_, 1
	note C_, 2
	rest 1
	inc_octave
	cutoff 3
	note D_, 2
	octave 1
	cutoff 8
	note G_, 1
	octave 3
	cutoff 3
	note F_, 2
	cutoff 7
	note D_, 1
	octave 1
	cutoff 8
	note C_, 1
	rest 1
	octave 3
	cutoff 3
	note F_, 1
	dec_octave
	cutoff 8
	note C_, 1
	rest 1
	inc_octave
	cutoff 3
	note D_, 2
	rest 1
	octave 1
	cutoff 8
	note E_, 1
	inc_octave
	note C_, 1
	rest 1
	inc_octave
	cutoff 7
	note F_, 1
	cutoff 3
	note E_, 2
	cutoff 8
	octave 1
	note E_, 1
	music_call Branch_f7826
	cutoff 8
	octave 2
	note C_, 1
	note C#, 2
	rest 1
	inc_octave
	cutoff 3
	note C#, 2
	octave 1
	cutoff 8
	note G#, 1
	inc_octave
	note C#, 1
	rest 1
	inc_octave
	cutoff 3
	note F_, 2
	rest 1
	inc_octave
	note C#, 1
	octave 2
	cutoff 8
	note C#, 1
	rest 1
	inc_octave
	note G_, 1
	dec_octave
	cutoff 8
	note C#, 1
	rest 1
	dec_octave
	note G#, 1
	octave 3
	cutoff 3
	note G_, 2
	dec_octave
	cutoff 8
	note C#, 1
	inc_octave
	cutoff 3
	note F_, 2
	octave 1
	cutoff 8
	note G#, 1
	inc_octave
	note C_, 2
	rest 1
	inc_octave
	cutoff 3
	note E_, 2
	dec_octave
	cutoff 8
	note G_, 1
	inc_octave
	cutoff 3
	note C_, 2
	cutoff 7
	note E_, 1
	dec_octave
	cutoff 8
	note E_, 1
	rest 1
	octave 4
	cutoff 3
	note E_, 1
	octave 2
	cutoff 8
	note C_, 1
	rest 1
	inc_octave
	cutoff 3
	note E_, 2
	rest 1
	octave 1
	cutoff 8
	note G_, 1
	octave 3
	cutoff 3
	note G_, 2
	dec_octave
	cutoff 8
	note C_, 1
	inc_octave
	cutoff 3
	note E_, 2
	octave 1
	cutoff 8
	note G_, 1
	note B_, 2
	rest 1
	octave 3
	cutoff 3
	note F_, 2
	dec_octave
	cutoff 8
	note F_, 1
	note B_, 2
	note F_, 1
	inc_octave
	cutoff 3
	note D_, 2
	inc_octave
	note D_, 1
	octave 1
	cutoff 8
	note B_, 2
	octave 3
	cutoff 3
	note F_, 2
	rest 1
	dec_octave
	cutoff 8
	note F_, 1
	note B_, 2
	note F_, 1
	dec_octave
	note B_, 2
	rest 1
	note A#, 2
	rest 1
	octave 3
	cutoff 3
	note D_, 2
	dec_octave
	cutoff 8
	note F_, 1
	note A#, 2
	note F_, 1
	inc_octave
	cutoff 3
	note F_, 2
	inc_octave
	note D_, 1
	octave 1
	cutoff 8
	note A#, 1
	rest 1
	octave 3
	cutoff 7
	note D_, 1
	octave 1
	cutoff 8
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
	cutoff 3
	note D_, 2
	octave 1
	cutoff 8
	note G_, 1
	octave 3
	cutoff 3
	note F_, 2
	cutoff 7
	note D_, 1
	octave 1
	cutoff 8
	note C_, 1
	rest 1
	octave 4
	cutoff 3
	note D_, 1
	octave 2
	cutoff 8
	note C_, 1
	rest 1
	inc_octave
	cutoff 3
	note D_, 2
	rest 1
	octave 1
	cutoff 8
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
	cutoff 3
	note A_, 2
	dec_octave
	cutoff 8
	note C_, 1
	inc_octave
	cutoff 5
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
	cutoff 8
	note C_, 1
	inc_octave
	cutoff 5
	note A#, 2
	inc_octave
	note C_, 1
	octave 1
	cutoff 8
	note F_, 3
	octave 4
	cutoff 3
	note C_, 2
	octave 2
	cutoff 8
	note C_, 1
	inc_octave
	cutoff 5
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
	cutoff 8
	note C_, 1
	inc_octave
	cutoff 5
	note A#, 2
	dec_octave
	cutoff 8
	note C_, 1
	EndMainLoop

Branch_f77f8:
	octave 1
	note F_, 3
	octave 3
	cutoff 3
	note A_, 2
	dec_octave
	cutoff 8
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
	cutoff 3
	note C_, 2
	octave 2
	cutoff 8
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
	cutoff 3
	note F_, 2
	dec_octave
	cutoff 8
	note C_, 1
	note F_, 1
	rest 1
	inc_octave
	cutoff 3
	note F_, 2
	rest 1
	inc_octave
	note C_, 1
	octave 1
	cutoff 8
	note F_, 1
	rest 1
	octave 3
	cutoff 7
	note G_, 1
	octave 1
	cutoff 8
	note F_, 1
	rest 1
	note C_, 1
	octave 3
	cutoff 3
	note G_, 2
	octave 1
	cutoff 8
	note F_, 1
	octave 3
	cutoff 7
	note F_, 2
	octave 1
	cutoff 8
	note G_, 1
	note A_, 2
	rest 1
	octave 3
	cutoff 3
	note E_, 2
	dec_octave
	cutoff 8
	note E_, 1
	note A_, 1
	rest 1
	inc_octave
	cutoff 3
	note E_, 2
	rest 1
	inc_octave
	note C_, 1
	octave 1
	cutoff 8
	note A_, 1
	rest 1
	octave 3
	cutoff 7
	note E_, 1
	octave 1
	cutoff 8
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
	cutoff 3
	note D_, 2
	dec_octave
	cutoff 8
	note F_, 1
	note A#, 1
	rest 1
	inc_octave
	cutoff 3
	note F_, 2
	rest 1
	inc_octave
	note D_, 1
	octave 1
	cutoff 8
	note A#, 1
	rest 1
	octave 3
	cutoff 7
	note D_, 1
	octave 1
	cutoff 8
	note A#, 1
	rest 1
	note F_, 1
	octave 3
	cutoff 3
	note D_, 2
	octave 1
	cutoff 8
	note A#, 1
	octave 3
	cutoff 3
	note D_, 2
	music_ret


Music_Overworld_Ch4:
	speed 7
	octave 1
	music_call Branch_f78ee
	music_call Branch_f78fb
	MainLoop
	music_call Branch_f78ee
	bass 3
	snare3 2
	bass 1
	snare1 3
	snare3 2
	snare4 1
	bass 2
	snare3 1
	snare3 3
	snare1 1
	snare3 1
	snare3 1
	snare1 3
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
	bass 3
	snare3 2
	bass 1
	snare1 3
	snare3 2
	snare4 1
	bass 2
	snare3 1
	snare3 3
	snare1 3
	snare3 2
	snare4 1
	music_ret

Branch_f78fb:
	bass 3
	snare3 2
	bass 1
	snare1 3
	snare3 2
	snare4 1
	bass 2
	snare3 1
	snare3 3
	snare1 1
	snare3 1
	snare3 1
	snare3 2
	snare4 1
	music_ret

Branch_f790a:
	bass 3
	snare3 2
	bass 1
	snare1 3
	snare3 2
	snare4 1
	bass 2
	snare3 1
	snare3 3
	snare1 1
	snare3 1
	snare3 1
	snare1 2
	snare1 1
	music_ret
