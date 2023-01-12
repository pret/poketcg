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
	C_ 7
	volume_envelope 3, 1
	C_ 8
	volume_envelope 4, 1
	C_ 8
	volume_envelope 9, 1
	G_ 7
	volume_envelope 3, 1
	G_ 8
	volume_envelope 4, 1
	C_ 7
	volume_envelope 9, 1
	E_ 7
	volume_envelope 3, 1
	E_ 8
	volume_envelope 4, 1
	E_ 8
	volume_envelope 9, 1
	C_ 7
	volume_envelope 3, 1
	C_ 8
	volume_envelope 4, 1
	C_ 7
	volume_envelope 9, 1
	G_ 7
	volume_envelope 3, 1
	G_ 8
	volume_envelope 9, 1
	cutoff 4
	F_ 7
	cutoff 5
	volume_envelope 4, 1
	G_ 8
	EndLoop
	volume_envelope 9, 1
	C_ 7
	volume_envelope 3, 1
	C_ 8
	volume_envelope 4, 1
	C_ 15
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
	C_ 8
	volume_envelope 2, 7
	C_ 8
	rest 7
	volume_envelope 11, 2
	C_ 7
	volume_envelope 2, 7
	C_ 8
	rest 7
	volume_envelope 11, 2
	dec_octave
	A_ 8
	volume_envelope 2, 7
	A_ 8
	rest 7
	inc_octave
	volume_envelope 11, 2
	C_ 7
	volume_envelope 2, 7
	C_ 8
	rest 15
	EndLoop
	volume_envelope 11, 2
	E_ 7
	volume_envelope 2, 7
	E_ 8
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
	C_ 7
	rest 8
	G_ 7
	inc_octave
	cutoff 5
	G_ 8
	cutoff 8
	rest 7
	dec_octave
	C_ 8
	inc_octave
	cutoff 5
	E_ 7
	dec_octave
	cutoff 8
	C_ 8
	D_ 7
	inc_octave
	cutoff 5
	C_ 8
	dec_octave
	rest 7
	cutoff 8
	A_ 8
	inc_octave
	cutoff 5
	G_ 7
	dec_octave
	dec_octave
	cutoff 8
	A_ 8
	inc_octave
	D_ 7
	rest 8
	E_ 7
	rest 8
	G_ 7
	inc_octave
	cutoff 5
	G_ 8
	rest 7
	dec_octave
	cutoff 8
	E_ 8
	inc_octave
	cutoff 5
	E_ 7
	dec_octave
	cutoff 8
	C_ 8
	F_ 7
	inc_octave
	cutoff 5
	C_ 8
	rest 7
	dec_octave
	cutoff 8
	F_ 8
	inc_octave
	cutoff 5
	G_ 7
	dec_octave
	cutoff 8
	E_ 8
	D_ 7
	rest 8
	EndLoop
	C_ 7
	rest 8
	G_ 7
	inc_octave
	cutoff 5
	G_ 8
	rest 7
	dec_octave
	cutoff 8
	C_ 8
	inc_octave
	cutoff 5
	E_ 7
	dec_octave
	dec_octave
	cutoff 8
	G_ 8
	inc_octave
	C_ 7
	inc_octave
	cutoff 5
	C_ 8
	rest 7
	dec_octave
	cutoff 8
	F_ 8
	inc_octave
	cutoff 5
	G_ 7
	dec_octave
	cutoff 8
	E_ 8
	D_ 7
	rest 8
	C_ 15
	rest 15
	speed 10
	rest 3
	speed 1
	rest 7
	dec_octave
	G_ 15
	rest 8
	A_ 7
	rest 8
	B_ 7
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
