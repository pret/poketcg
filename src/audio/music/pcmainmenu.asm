Music_PCMainMenu_Ch1:
	speed 7
	stereo_panning 1, 1
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
	F_ 1
	rest 1
	duty 2
	cutoff 8
	volume_envelope 11, 4
	A_ 1
	volume_envelope 3, 7
	A_ 1
	rest 2
	inc_octave
	volume_envelope 11, 4
	C_ 1
	volume_envelope 3, 7
	C_ 1
	dec_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	F_ 1
	rest 1
	duty 2
	cutoff 8
	volume_envelope 11, 4
	B_ 1
	volume_envelope 3, 7
	B_ 1
	music_call Branch_f90c2
	rest 4
	dec_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	F_ 1
	rest 1
	inc_octave
	duty 2
	cutoff 8
	volume_envelope 11, 4
	E_ 1
	volume_envelope 3, 7
	E_ 1
	rest 2
	volume_envelope 11, 4
	C_ 1
	volume_envelope 3, 7
	C_ 1
	duty 1
	cutoff 5
	volume_envelope 6, 1
	dec_octave
	F_ 1
	rest 1
	inc_octave
	duty 2
	cutoff 8
	volume_envelope 11, 4
	D_ 1
	volume_envelope 3, 7
	D_ 1
	EndMainLoop

Branch_f90c2:
	octave 3
	rest 4
	duty 1
	volume_envelope 6, 1
	cutoff 5
	G_ 1
	rest 3
	cutoff 8
	duty 2
	volume_envelope 11, 4
	B_ 2
	inc_octave
	D_ 1
	volume_envelope 2, 7
	D_ 1
	dec_octave
	duty 1
	volume_envelope 6, 1
	cutoff 5
	G_ 1
	rest 1
	inc_octave
	duty 2
	cutoff 8
	volume_envelope 11, 4
	C_ 1
	volume_envelope 3, 7
	C_ 1
	music_ret


Music_PCMainMenu_Ch2:
	speed 7
	stereo_panning 1, 1
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
	C_ 1
	rest 1
	dec_octave
	duty 2
	cutoff 8
	volume_envelope 8, 4
	F_ 1
	volume_envelope 2, 7
	F_ 1
	rest 2
	volume_envelope 8, 4
	A_ 1
	volume_envelope 2, 7
	A_ 1
	duty 1
	cutoff 5
	volume_envelope 6, 1
	inc_octave
	C_ 1
	rest 1
	dec_octave
	duty 2
	cutoff 8
	volume_envelope 8, 4
	G_ 1
	volume_envelope 2, 7
	G_ 1
	music_call Branch_f915e
	rest 4
	inc_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	C_ 1
	rest 1
	duty 2
	cutoff 8
	volume_envelope 8, 4
	C_ 1
	volume_envelope 2, 7
	C_ 1
	rest 2
	dec_octave
	volume_envelope 8, 4
	A_ 1
	volume_envelope 2, 7
	A_ 1
	duty 1
	inc_octave
	volume_envelope 6, 1
	cutoff 5
	C_ 1
	rest 1
	dec_octave
	duty 2
	cutoff 8
	volume_envelope 8, 4
	B_ 1
	volume_envelope 2, 7
	B_ 1
	EndMainLoop

Branch_f915e:
	octave 4
	rest 4
	duty 1
	cutoff 5
	volume_envelope 6, 1
	D_ 1
	rest 3
	duty 2
	cutoff 8
	dec_octave
	volume_envelope 8, 4
	G_ 2
	B_ 1
	volume_envelope 2, 7
	B_ 1
	inc_octave
	duty 1
	cutoff 5
	volume_envelope 6, 1
	D_ 1
	rest 1
	dec_octave
	duty 2
	cutoff 8
	volume_envelope 8, 4
	A_ 1
	volume_envelope 2, 7
	A_ 1
	music_ret


Music_PCMainMenu_Ch3:
	speed 7
	volume_envelope 2, 0
	stereo_panning 1, 1
	wave 1
	cutoff 7
	echo 0
	MainLoop
	octave 1
	cutoff 7
	G_ 1
	rest 1
	cutoff 8
	G_ 1
	rest 1
	speed 1
	A# 4
	tie
	B_ 3
	tie
	speed 7
	B_ 1
	rest 1
	cutoff 4
	inc_octave
	C_ 1
	rest 1
	C_ 1
	cutoff 8
	C# 2
	D_ 2
	dec_octave
	G_ 1
	tie
	F# 1
	cutoff 7
	F_ 1
	rest 1
	cutoff 8
	F_ 1
	rest 1
	speed 1
	G# 4
	tie
	A_ 3
	tie
	speed 7
	A_ 1
	rest 1
	cutoff 4
	A# 1
	rest 1
	A# 1
	cutoff 8
	B_ 2
	inc_octave
	C_ 2
	dec_octave
	F_ 1
	tie
	F# 1
	cutoff 7
	G_ 1
	rest 1
	cutoff 8
	G_ 1
	rest 1
	speed 1
	A# 4
	tie
	B_ 3
	tie
	speed 7
	B_ 1
	rest 1
	cutoff 4
	inc_octave
	C_ 1
	rest 1
	C_ 1
	cutoff 8
	C# 2
	D_ 2
	dec_octave
	G_ 1
	tie
	F# 1
	cutoff 7
	F_ 1
	rest 1
	cutoff 8
	F_ 1
	rest 1
	speed 1
	B_ 4
	tie
	inc_octave
	C_ 3
	tie
	speed 7
	C_ 1
	rest 1
	cutoff 8
	speed 1
	F# 4
	tie
	G_ 3
	tie
	speed 7
	G_ 1
	cutoff 4
	F_ 1
	cutoff 8
	C_ 2
	F_ 2
	speed 1
	C_ 3
	tie
	dec_octave
	B_ 3
	tie
	A# 3
	tie
	A_ 3
	tie
	G# 2
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
