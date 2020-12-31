Music_DeckMachine_Ch1: ; f6ef1 (3d:6ef1)
	stereo_panning 1, 1
	cutoff 8
	duty 3
	MainLoop
	octave 5
	speed 1
	Loop 9
	cutoff 6
	volume 145
	C_ 7
	volume 49
	C_ 8
	volume 65
	C_ 8
	volume 145
	G_ 7
	volume 49
	G_ 8
	volume 65
	C_ 7
	volume 145
	E_ 7
	volume 49
	E_ 8
	volume 65
	E_ 8
	volume 145
	C_ 7
	volume 49
	C_ 8
	volume 65
	C_ 7
	volume 145
	G_ 7
	volume 49
	G_ 8
	volume 145
	cutoff 4
	F_ 7
	cutoff 5
	volume 65
	G_ 8
	EndLoop
	volume 145
	C_ 7
	volume 49
	C_ 8
	volume 65
	C_ 15
	speed 10
	rest 9
	EndMainLoop


Music_DeckMachine_Ch2: ; f6f41 (3d:6f41)
	stereo_panning 1, 1
	cutoff 8
	duty 1
	cutoff 7
	MainLoop
	octave 3
	speed 1
	Loop 9
	rest 15
	volume 178
	rest 7
	C_ 8
	volume 39
	C_ 8
	rest 7
	volume 178
	C_ 7
	volume 39
	C_ 8
	rest 7
	volume 178
	dec_octave
	A_ 8
	volume 39
	A_ 8
	rest 7
	inc_octave
	volume 178
	C_ 7
	volume 39
	C_ 8
	rest 15
	EndLoop
	volume 178
	E_ 7
	volume 39
	E_ 8
	rest 15
	speed 10
	rest 9
	EndMainLoop


Music_DeckMachine_Ch3: ; f6f7b (3d:6f7b)
	stereo_panning 1, 1
	volume 32
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


Music_DeckMachine_Ch4: ; f7018 (3d:7018)
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
; 0xf703a
