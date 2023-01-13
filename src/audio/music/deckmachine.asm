Music_DeckMachine_Ch1:
	stereo_panning TRUE, TRUE
	cutoff 8
	duty 3
	MainLoop
	octave 5
	speed 1
	Loop 9
	cutoff 6
	volume_envelope 9, 1
	note C_, 7
	volume_envelope 3, 1
	note C_, 8
	volume_envelope 4, 1
	note C_, 8
	volume_envelope 9, 1
	note G_, 7
	volume_envelope 3, 1
	note G_, 8
	volume_envelope 4, 1
	note C_, 7
	volume_envelope 9, 1
	note E_, 7
	volume_envelope 3, 1
	note E_, 8
	volume_envelope 4, 1
	note E_, 8
	volume_envelope 9, 1
	note C_, 7
	volume_envelope 3, 1
	note C_, 8
	volume_envelope 4, 1
	note C_, 7
	volume_envelope 9, 1
	note G_, 7
	volume_envelope 3, 1
	note G_, 8
	volume_envelope 9, 1
	cutoff 4
	note F_, 7
	cutoff 5
	volume_envelope 4, 1
	note G_, 8
	EndLoop
	volume_envelope 9, 1
	note C_, 7
	volume_envelope 3, 1
	note C_, 8
	volume_envelope 4, 1
	note C_, 15
	speed 10
	rest 9
	EndMainLoop


Music_DeckMachine_Ch2:
	stereo_panning TRUE, TRUE
	cutoff 8
	duty 1
	cutoff 7
	MainLoop
	octave 3
	speed 1
	Loop 9
	rest 15
	volume_envelope 11, 2
	rest 7
	note C_, 8
	volume_envelope 2, 7
	note C_, 8
	rest 7
	volume_envelope 11, 2
	note C_, 7
	volume_envelope 2, 7
	note C_, 8
	rest 7
	volume_envelope 11, 2
	dec_octave
	note A_, 8
	volume_envelope 2, 7
	note A_, 8
	rest 7
	inc_octave
	volume_envelope 11, 2
	note C_, 7
	volume_envelope 2, 7
	note C_, 8
	rest 15
	EndLoop
	volume_envelope 11, 2
	note E_, 7
	volume_envelope 2, 7
	note E_, 8
	rest 15
	speed 10
	rest 9
	EndMainLoop


Music_DeckMachine_Ch3:
	stereo_panning TRUE, TRUE
	volume_envelope 2, 0
	wave 1
	echo 96
	cutoff 8
	MainLoop
	octave 2
	speed 1
	Loop 4
	note C_, 7
	rest 8
	note G_, 7
	inc_octave
	cutoff 5
	note G_, 8
	cutoff 8
	rest 7
	dec_octave
	note C_, 8
	inc_octave
	cutoff 5
	note E_, 7
	dec_octave
	cutoff 8
	note C_, 8
	note D_, 7
	inc_octave
	cutoff 5
	note C_, 8
	dec_octave
	rest 7
	cutoff 8
	note A_, 8
	inc_octave
	cutoff 5
	note G_, 7
	dec_octave
	dec_octave
	cutoff 8
	note A_, 8
	inc_octave
	note D_, 7
	rest 8
	note E_, 7
	rest 8
	note G_, 7
	inc_octave
	cutoff 5
	note G_, 8
	rest 7
	dec_octave
	cutoff 8
	note E_, 8
	inc_octave
	cutoff 5
	note E_, 7
	dec_octave
	cutoff 8
	note C_, 8
	note F_, 7
	inc_octave
	cutoff 5
	note C_, 8
	rest 7
	dec_octave
	cutoff 8
	note F_, 8
	inc_octave
	cutoff 5
	note G_, 7
	dec_octave
	cutoff 8
	note E_, 8
	note D_, 7
	rest 8
	EndLoop
	note C_, 7
	rest 8
	note G_, 7
	inc_octave
	cutoff 5
	note G_, 8
	rest 7
	dec_octave
	cutoff 8
	note C_, 8
	inc_octave
	cutoff 5
	note E_, 7
	dec_octave
	dec_octave
	cutoff 8
	note G_, 8
	inc_octave
	note C_, 7
	inc_octave
	cutoff 5
	note C_, 8
	rest 7
	dec_octave
	cutoff 8
	note F_, 8
	inc_octave
	cutoff 5
	note G_, 7
	dec_octave
	cutoff 8
	note E_, 8
	note D_, 7
	rest 8
	note C_, 15
	rest 15
	speed 10
	rest 3
	speed 1
	rest 7
	dec_octave
	note G_, 15
	rest 8
	note A_, 7
	rest 8
	note B_, 7
	rest 8
	EndMainLoop


Music_DeckMachine_Ch4:
	speed 1
	octave 1
	MainLoop
	Loop 9
	music_call Branch_f7031
	snare4 15
	snare1 7
	snare3 8
	snare4 15
	EndLoop
	music_call Branch_f7031
	snare4 7
	snare2 4
	snare2 4
	snare1 7
	snare1 8
	snare1 7
	snare1 8
	EndMainLoop

Branch_f7031:
	bass 7
	snare3 8
	snare4 15
	snare1 7
	snare3 8
	snare4 15
	bass 7
	snare3 8
	music_ret
