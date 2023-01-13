Music_PCMainMenu_Ch1:
	speed 7
	stereo_panning TRUE, TRUE
	cutoff 8
	octave 3
	duty 2
	MainLoop
	music_call Branch_f90c2
	rest 4
	dec_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	note F_, 1
	rest 1
	duty 2
	cutoff 8
	volume_envelope 11, 4
	note A_, 1
	volume_envelope 3, 7
	note A_, 1
	rest 2
	inc_octave
	volume_envelope 11, 4
	note C_, 1
	volume_envelope 3, 7
	note C_, 1
	dec_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	note F_, 1
	rest 1
	duty 2
	cutoff 8
	volume_envelope 11, 4
	note B_, 1
	volume_envelope 3, 7
	note B_, 1
	music_call Branch_f90c2
	rest 4
	dec_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	note F_, 1
	rest 1
	inc_octave
	duty 2
	cutoff 8
	volume_envelope 11, 4
	note E_, 1
	volume_envelope 3, 7
	note E_, 1
	rest 2
	volume_envelope 11, 4
	note C_, 1
	volume_envelope 3, 7
	note C_, 1
	duty 1
	cutoff 5
	volume_envelope 6, 1
	dec_octave
	note F_, 1
	rest 1
	inc_octave
	duty 2
	cutoff 8
	volume_envelope 11, 4
	note D_, 1
	volume_envelope 3, 7
	note D_, 1
	EndMainLoop

Branch_f90c2:
	octave 3
	rest 4
	duty 1
	volume_envelope 6, 1
	cutoff 5
	note G_, 1
	rest 3
	cutoff 8
	duty 2
	volume_envelope 11, 4
	note B_, 2
	inc_octave
	note D_, 1
	volume_envelope 2, 7
	note D_, 1
	dec_octave
	duty 1
	volume_envelope 6, 1
	cutoff 5
	note G_, 1
	rest 1
	inc_octave
	duty 2
	cutoff 8
	volume_envelope 11, 4
	note C_, 1
	volume_envelope 3, 7
	note C_, 1
	music_ret


Music_PCMainMenu_Ch2:
	speed 7
	stereo_panning TRUE, TRUE
	cutoff 8
	octave 3
	duty 2
	MainLoop
	music_call Branch_f915e
	rest 4
	inc_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	note C_, 1
	rest 1
	dec_octave
	duty 2
	cutoff 8
	volume_envelope 8, 4
	note F_, 1
	volume_envelope 2, 7
	note F_, 1
	rest 2
	volume_envelope 8, 4
	note A_, 1
	volume_envelope 2, 7
	note A_, 1
	duty 1
	cutoff 5
	volume_envelope 6, 1
	inc_octave
	note C_, 1
	rest 1
	dec_octave
	duty 2
	cutoff 8
	volume_envelope 8, 4
	note G_, 1
	volume_envelope 2, 7
	note G_, 1
	music_call Branch_f915e
	rest 4
	inc_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	note C_, 1
	rest 1
	duty 2
	cutoff 8
	volume_envelope 8, 4
	note C_, 1
	volume_envelope 2, 7
	note C_, 1
	rest 2
	dec_octave
	volume_envelope 8, 4
	note A_, 1
	volume_envelope 2, 7
	note A_, 1
	duty 1
	inc_octave
	volume_envelope 6, 1
	cutoff 5
	note C_, 1
	rest 1
	dec_octave
	duty 2
	cutoff 8
	volume_envelope 8, 4
	note B_, 1
	volume_envelope 2, 7
	note B_, 1
	EndMainLoop

Branch_f915e:
	octave 4
	rest 4
	duty 1
	cutoff 5
	volume_envelope 6, 1
	note D_, 1
	rest 3
	duty 2
	cutoff 8
	dec_octave
	volume_envelope 8, 4
	note G_, 2
	note B_, 1
	volume_envelope 2, 7
	note B_, 1
	inc_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	note D_, 1
	rest 1
	dec_octave
	duty 2
	cutoff 8
	volume_envelope 8, 4
	note A_, 1
	volume_envelope 2, 7
	note A_, 1
	music_ret


Music_PCMainMenu_Ch3:
	speed 7
	volume_envelope 2, 0
	stereo_panning TRUE, TRUE
	wave 1
	cutoff 7
	echo 0
	MainLoop
	octave 1
	cutoff 7
	note G_, 1
	rest 1
	cutoff 8
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
	cutoff 4
	inc_octave
	note C_, 1
	rest 1
	note C_, 1
	cutoff 8
	note C#, 2
	note D_, 2
	dec_octave
	note G_, 1
	tie
	note F#, 1
	cutoff 7
	note F_, 1
	rest 1
	cutoff 8
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
	cutoff 4
	note A#, 1
	rest 1
	note A#, 1
	cutoff 8
	note B_, 2
	inc_octave
	note C_, 2
	dec_octave
	note F_, 1
	tie
	note F#, 1
	cutoff 7
	note G_, 1
	rest 1
	cutoff 8
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
	cutoff 4
	inc_octave
	note C_, 1
	rest 1
	note C_, 1
	cutoff 8
	note C#, 2
	note D_, 2
	dec_octave
	note G_, 1
	tie
	note F#, 1
	cutoff 7
	note F_, 1
	rest 1
	cutoff 8
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
	cutoff 8
	speed 1
	note F#, 4
	tie
	note G_, 3
	tie
	speed 7
	note G_, 1
	cutoff 4
	note F_, 1
	cutoff 8
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


Music_PCMainMenu_Ch4:
	speed 7
	octave 1
	MainLoop
	Loop 7
	music_call Branch_f9248
	snare3 1
	bass 1
	snare1 2
	snare3 1
	snare4 1
	EndLoop
	music_call Branch_f9248
	snare4 1
	speed 1
	snare2 4
	snare2 3
	speed 7
	snare1 2
	snare1 1
	snare1 1
	EndMainLoop

Branch_f9248:
	bass 2
	snare3 1
	snare3 1
	snare1 2
	snare3 1
	snare4 1
	bass 1
	snare2 1
	music_ret
