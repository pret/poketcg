Music_CardPop_Ch1: ; f703a (3d:703a)
	speed 4
	stereo_panning 1, 1
	cutoff 8
	duty 2
	volume 144
	MainLoop
	Loop 7
	rest 16
	EndLoop
	rest 14
	Loop 2
	octave 5
	cutoff 8
	F# 1
	G_ 1
	cutoff 6
	F# 1
	volume 55
	F# 1
	volume 144
	D_ 1
	volume 55
	F# 1
	dec_octave
	volume 144
	A_ 1
	inc_octave
	volume 55
	D_ 1
	dec_octave
	volume 144
	G_ 1
	volume 55
	A_ 1
	volume 144
	F# 1
	volume 55
	G_ 1
	volume 144
	D_ 1
	volume 55
	G_ 1
	dec_octave
	volume 144
	A_ 1
	volume 55
	inc_octave
	D_ 1
	dec_octave
	volume 144
	G_ 1
	volume 55
	A_ 1
	volume 144
	F# 1
	volume 55
	G_ 1
	rest 1
	F# 1
	rest 12
	rest 16
	rest 14
	octave 5
	volume 144
	cutoff 8
	E_ 1
	F_ 1
	cutoff 6
	E_ 1
	volume 55
	E_ 1
	volume 144
	C_ 1
	volume 55
	E_ 1
	dec_octave
	volume 144
	G_ 1
	inc_octave
	volume 55
	C_ 1
	dec_octave
	volume 144
	F_ 1
	volume 55
	G_ 1
	volume 144
	E_ 1
	volume 55
	F_ 1
	volume 144
	C_ 1
	volume 55
	E_ 1
	dec_octave
	volume 144
	G_ 1
	volume 55
	inc_octave
	C_ 1
	dec_octave
	volume 144
	F_ 1
	volume 55
	G_ 1
	volume 144
	E_ 1
	volume 55
	F_ 1
	rest 1
	E_ 1
	rest 12
	rest 16
	volume 144
	rest 14
	EndLoop
	rest 2
	EndMainLoop


Music_CardPop_Ch2: ; f70df (3d:70df)
	speed 4
	stereo_panning 1, 1
	cutoff 8
	duty 2
	volume 96
	cutoff 3
	Loop 2
	octave 2
	A_ 2
	inc_octave
	A_ 2
	inc_octave
	A_ 2
	dec_octave
	A_ 2
	inc_octave
	inc_octave
	A_ 2
	dec_octave
	A_ 2
	dec_octave
	A_ 2
	inc_octave
	inc_octave
	A_ 2
	dec_octave
	dec_octave
	A_ 2
	dec_octave
	A_ 2
	inc_octave
	A_ 2
	inc_octave
	A_ 2
	inc_octave
	A_ 2
	dec_octave
	A_ 2
	dec_octave
	A_ 2
	inc_octave
	inc_octave
	A_ 2
	EndLoop
	Loop 2
	octave 2
	G_ 2
	inc_octave
	G_ 2
	inc_octave
	G_ 2
	dec_octave
	G_ 2
	inc_octave
	inc_octave
	G_ 2
	dec_octave
	G_ 2
	dec_octave
	G_ 2
	inc_octave
	inc_octave
	G_ 2
	dec_octave
	dec_octave
	G_ 2
	dec_octave
	G_ 2
	inc_octave
	G_ 2
	inc_octave
	G_ 2
	inc_octave
	G_ 2
	dec_octave
	G_ 2
	dec_octave
	G_ 2
	inc_octave
	inc_octave
	G_ 2
	EndLoop
	EndMainLoop


Music_CardPop_Ch3: ; f713a (3d:713a)
	speed 4
	wave 1
	stereo_panning 1, 1
	volume 32
	echo 0
	cutoff 8
	music_call Branch_f715b
	C_ 2
	C# 2
	music_call Branch_f715b
	D_ 2
	C# 2
	music_call Branch_f716c
	D_ 2
	C# 2
	music_call Branch_f716c
	C_ 2
	C# 2
	EndMainLoop

Branch_f715b:
	octave 1
	D_ 2
	rest 2
	D_ 4
	inc_octave
	D_ 2
	dec_octave
	D_ 2
	rest 2
	F# 2
	rest 2
	G_ 2
	rest 2
	G# 2
	rest 2
	A_ 2
	music_ret

Branch_f716c:
	octave 1
	C_ 2
	rest 2
	C_ 4
	inc_octave
	C_ 2
	dec_octave
	C_ 2
	rest 2
	E_ 2
	rest 2
	F_ 2
	rest 2
	F# 2
	rest 2
	G_ 2
	music_ret


Music_CardPop_Ch4: ; f717d (3d:717d)
	speed 4
	octave 1
	Loop 11
	music_call Branch_f7196
	snare4 4
	snare1 2
	snare3 2
	snare4 2
	snare1 2
	EndLoop
	music_call Branch_f7196
	snare4 2
	snare2 1
	snare2 1
	Loop 4
	snare1 2
	EndLoop
	EndMainLoop

Branch_f7196:
	bass 2
	snare3 2
	snare4 4
	snare1 2
	snare3 2
	snare4 2
	snare1 2
	bass 2
	snare1 2
	music_ret
; 0xf71a0
