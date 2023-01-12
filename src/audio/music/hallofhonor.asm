Music_HallOfHonor_Ch1:
	speed 7
	stereo_panning TRUE, TRUE
	cutoff 8
	duty 2
	Loop 4
	music_call Branch_fb016
	EndLoop
	MainLoop
	Loop 8
	music_call Branch_fb016
	EndLoop
	octave 4
	volume_envelope 5, 5
	C_ 1
	volume_envelope 2, 7
	C_ 1
	music_call Branch_fb044
	Loop 23
	volume_envelope 5, 5
	C_ 1
	volume_envelope 2, 7
	G_ 1
	music_call Branch_fb044
	EndLoop
	EndMainLoop

Branch_fb016:
	octave 4
	volume_envelope 6, 5
	C_ 1
	volume_envelope 2, 7
	C_ 1
	volume_envelope 6, 5
	F_ 1
	volume_envelope 2, 7
	F_ 1
	volume_envelope 6, 5
	G_ 1
	volume_envelope 2, 7
	G_ 1
	volume_envelope 6, 5
	F_ 1
	volume_envelope 2, 7
	F_ 1
	inc_octave
	volume_envelope 6, 5
	C_ 1
	volume_envelope 2, 7
	C_ 1
	dec_octave
	volume_envelope 6, 5
	F_ 1
	volume_envelope 2, 7
	F_ 1
	volume_envelope 6, 5
	G_ 1
	volume_envelope 2, 7
	G_ 1
	music_ret

Branch_fb044:
	octave 4
	volume_envelope 5, 5
	F_ 1
	volume_envelope 2, 7
	C_ 1
	volume_envelope 5, 5
	G_ 1
	volume_envelope 2, 7
	F_ 1
	volume_envelope 5, 5
	F_ 1
	volume_envelope 2, 7
	G_ 1
	inc_octave
	volume_envelope 5, 5
	C_ 1
	dec_octave
	volume_envelope 2, 7
	F_ 1
	volume_envelope 5, 5
	F_ 1
	inc_octave
	volume_envelope 2, 7
	C_ 1
	dec_octave
	volume_envelope 5, 5
	G_ 1
	volume_envelope 2, 7
	F_ 1
	music_ret


Music_HallOfHonor_Ch2:
	speed 7
	stereo_panning TRUE, TRUE
	cutoff 8
	duty 2
	frequency_offset -1
	rest 2
	speed 1
	rest 4
	speed 7
	volume_envelope 1, 7
	Loop 3
	music_call Branch_fb1ec
	EndLoop
	octave 4
	C_ 1
	rest 1
	F_ 1
	rest 1
	G_ 1
	rest 1
	F_ 1
	rest 1
	inc_octave
	C_ 1
	rest 1
	dec_octave
	F_ 1
	speed 1
	rest 3
	speed 7
	frequency_offset 0
	MainLoop
	octave 1
	duty 1
	Loop 3
	music_call Branch_fb0bb
	octave 1
	volume_envelope 6, -5
	E_ 5
	volume_envelope 13, 0
	E_ 11
	tie
	E_ 12
	EndLoop
	music_call Branch_fb0bb
	octave 1
	volume_envelope 6, -5
	G_ 5
	volume_envelope 13, 0
	G_ 11
	tie
	G_ 12
	EndMainLoop

Branch_fb0bb:
	octave 1
	volume_envelope 6, -5
	F_ 5
	volume_envelope 13, 0
	F_ 11
	tie
	F_ 12
	volume_envelope 6, -5
	E_ 5
	volume_envelope 13, 0
	E_ 11
	tie
	E_ 12
	volume_envelope 6, -5
	D_ 5
	volume_envelope 13, 0
	D_ 11
	tie
	D_ 12
	music_ret


Music_HallOfHonor_Ch3:
	speed 7
	volume_envelope 4, 0
	stereo_panning TRUE, TRUE
	wave 2
	vibrato_type 4
	vibrato_delay 35
	cutoff 6
	echo 64
	rest 3
	volume_envelope 6, 0
	cutoff 8
	frequency_offset -1
	Loop 4
	rest 14
	EndLoop
	MainLoop
	octave 5
	Loop 7
	music_call Branch_fb1ec
	EndLoop
	C_ 1
	rest 1
	F_ 1
	rest 1
	G_ 1
	rest 1
	F_ 1
	rest 1
	inc_octave
	C_ 1
	rest 1
	dec_octave
	F_ 1
	volume_envelope 2, 0
	frequency_offset 0
	octave 4
	speed 1
	cutoff 6
	B_ 3
	inc_octave
	C_ 4
	tie
	speed 7
	C_ 15
	tie
	C_ 8
	dec_octave
	cutoff 8
	B_ 2
	cutoff 4
	A_ 2
	cutoff 6
	G_ 6
	C_ 10
	tie
	C_ 12
	speed 1
	cutoff 8
	B_ 3
	inc_octave
	cutoff 6
	C_ 4
	tie
	speed 7
	C_ 15
	tie
	C_ 6
	dec_octave
	cutoff 8
	B_ 2
	inc_octave
	C_ 2
	cutoff 4
	D_ 2
	dec_octave
	speed 1
	cutoff 8
	F# 3
	cutoff 6
	G_ 4
	tie
	speed 7
	G_ 15
	tie
	G_ 6
	cutoff 8
	G_ 2
	A_ 2
	cutoff 4
	B_ 2
	speed 1
	cutoff 8
	B_ 3
	inc_octave
	C_ 4
	tie
	speed 7
	C_ 15
	tie
	C_ 8
	dec_octave
	B_ 2
	cutoff 4
	A_ 2
	cutoff 6
	G_ 6
	cutoff 8
	speed 1
	B_ 3
	inc_octave
	cutoff 6
	C_ 4
	tie
	speed 7
	C_ 9
	tie
	C_ 6
	dec_octave
	cutoff 8
	G_ 2
	inc_octave
	C_ 2
	cutoff 4
	E_ 2
	speed 1
	cutoff 8
	E_ 3
	F_ 4
	tie
	speed 7
	F_ 1
	E_ 2
	cutoff 4
	C_ 2
	cutoff 7
	C_ 10
	tie
	C_ 10
	cutoff 4
	E_ 2
	speed 1
	cutoff 8
	E_ 3
	F_ 4
	tie
	speed 7
	F_ 1
	E_ 2
	cutoff 4
	C_ 2
	cutoff 6
	C_ 10
	tie
	C_ 12
	speed 1
	cutoff 8
	F# 3
	cutoff 7
	G_ 4
	tie
	speed 7
	G_ 15
	tie
	G_ 8
	cutoff 8
	F_ 2
	cutoff 4
	E_ 2
	cutoff 8
	F_ 2
	cutoff 4
	E_ 2
	C_ 2
	dec_octave
	cutoff 7
	G_ 10
	tie
	G_ 10
	cutoff 8
	E_ 2
	F_ 2
	inc_octave
	cutoff 4
	C_ 2
	cutoff 7
	C_ 12
	tie
	C_ 10
	dec_octave
	cutoff 8
	E_ 2
	F_ 2
	inc_octave
	cutoff 4
	C_ 2
	cutoff 6
	C_ 12
	tie
	C_ 12
	rest 3
	volume_envelope 6, 0
	frequency_offset -1
	cutoff 8
	EndMainLoop

Branch_fb1ec:
	octave 4
	C_ 1
	rest 1
	F_ 1
	rest 1
	G_ 1
	rest 1
	F_ 1
	rest 1
	inc_octave
	C_ 1
	rest 1
	dec_octave
	F_ 1
	rest 1
	G_ 1
	rest 1
	music_ret
