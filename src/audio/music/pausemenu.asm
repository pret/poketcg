Music_PauseMenu_Ch2: ; f6bb7 (3d:6bb7)
	speed 7
	stereo_panning 1, 1
	cutoff 8
	duty 2
	MainLoop
	volume 112
	Loop 4
	rest 16
	EndLoop
	speed 1
	octave 6
	C_ 4
	dec_octave
	rest 3
	B_ 4
	inc_octave
	volume 55
	C_ 3
	dec_octave
	volume 112
	G_ 4
	volume 55
	B_ 3
	volume 112
	D_ 4
	volume 55
	G_ 3
	music_call Branch_f6c24
	music_call Branch_f6c60
	volume 112
	octave 6
	C_ 4
	dec_octave
	volume 55
	E_ 3
	volume 112
	B_ 4
	inc_octave
	volume 55
	C_ 3
	dec_octave
	volume 112
	G_ 4
	volume 55
	B_ 3
	volume 112
	D_ 4
	volume 55
	G_ 3
	music_call Branch_f6c24
	music_call Branch_f6c60
	octave 6
	volume 96
	C_ 4
	dec_octave
	volume 55
	E_ 3
	music_call Branch_f6ce9
	music_call Branch_f6c80
	Loop 3
	octave 6
	cutoff 4
	C_ 1
	music_call Branch_f6ce9
	music_call Branch_f6c80
	EndLoop
	cutoff 8
	EndMainLoop

Branch_f6c24:
	Loop 3
	octave 6
	volume 112
	C_ 4
	dec_octave
	volume 55
	D_ 3
	volume 112
	B_ 4
	inc_octave
	volume 55
	C_ 3
	dec_octave
	volume 112
	G_ 4
	volume 55
	B_ 3
	volume 112
	D_ 4
	volume 55
	G_ 3
	EndLoop
	inc_octave
	volume 112
	C_ 4
	dec_octave
	volume 55
	D_ 3
	volume 112
	B_ 4
	inc_octave
	volume 55
	C_ 3
	dec_octave
	volume 112
	G_ 4
	volume 55
	B_ 3
	volume 112
	E_ 4
	volume 55
	G_ 3
	music_ret

Branch_f6c60:
	Loop 3
	octave 6
	volume 112
	C_ 4
	dec_octave
	volume 55
	E_ 3
	volume 112
	B_ 4
	inc_octave
	volume 55
	C_ 3
	dec_octave
	volume 112
	G_ 4
	volume 55
	B_ 3
	volume 112
	E_ 4
	volume 55
	G_ 3
	EndLoop
	music_ret

Branch_f6c80:
	octave 6
	cutoff 4
	C_ 1
	octave 3
	volume 112
	cutoff 8
	speed 1
	C_ 4
	volume 39
	C_ 3
	volume 96
	speed 7
	octave 5
	cutoff 4
	G_ 1
	E_ 1
	octave 3
	cutoff 8
	volume 112
	speed 1
	E_ 4
	volume 39
	E_ 3
	speed 7
	volume 96
	octave 5
	cutoff 4
	B_ 1
	G_ 1
	dec_octave
	volume 112
	cutoff 8
	speed 1
	C_ 4
	volume 39
	C_ 3
	volume 96
	speed 7
	octave 6
	cutoff 4
	C_ 1
	octave 3
	cutoff 8
	volume 112
	speed 1
	C_ 4
	volume 39
	C_ 3
	speed 7
	octave 5
	volume 96
	cutoff 4
	G_ 1
	E_ 1
	volume 112
	octave 3
	cutoff 8
	speed 1
	E_ 4
	volume 39
	E_ 3
	speed 7
	volume 96
	octave 5
	cutoff 4
	B_ 1
	G_ 1
	E_ 1
	music_ret

Branch_f6ce9:
	octave 2
	speed 1
	cutoff 8
	volume 112
	B_ 4
	volume 39
	B_ 3
	speed 7
	volume 96
	octave 5
	cutoff 4
	G_ 1
	D_ 1
	octave 3
	volume 112
	cutoff 8
	speed 1
	D_ 4
	volume 39
	D_ 3
	speed 7
	volume 96
	octave 5
	cutoff 4
	B_ 1
	G_ 1
	volume 112
	octave 3
	cutoff 8
	speed 1
	B_ 4
	volume 39
	B_ 3
	volume 96
	speed 7
	octave 6
	cutoff 4
	C_ 1
	volume 112
	octave 2
	cutoff 8
	speed 1
	B_ 4
	volume 39
	B_ 3
	speed 7
	volume 96
	octave 5
	cutoff 4
	G_ 1
	D_ 1
	volume 112
	octave 3
	cutoff 8
	speed 1
	D_ 4
	volume 39
	D_ 3
	speed 7
	volume 96
	octave 5
	cutoff 4
	B_ 1
	G_ 1
	D_ 1
	music_ret


Music_PauseMenu_Ch1: ; f6d4e (3d:6d4e)
	speed 7
	stereo_panning 1, 1
	cutoff 8
	duty 2
	MainLoop
	volume 128
	Loop 7
	rest 16
	EndLoop
	octave 5
	rest 8
	speed 1
	Loop 4
	B_ 4
	G_ 3
	E_ 4
	C_ 3
	dec_octave
	EndLoop
	speed 7
	Loop 4
	octave 1
	volume 208
	G_ 1
	octave 3
	volume 112
	speed 1
	D_ 4
	volume 39
	D_ 3
	volume 208
	speed 7
	octave 1
	cutoff 6
	G_ 1
	cutoff 4
	G_ 1
	octave 3
	cutoff 8
	volume 112
	speed 1
	F# 4
	volume 39
	F# 3
	dec_octave
	volume 208
	speed 7
	D_ 1
	G_ 1
	octave 4
	volume 112
	speed 1
	F# 4
	volume 39
	F# 3
	speed 7
	octave 1
	volume 208
	cutoff 8
	G_ 1
	octave 3
	volume 112
	speed 1
	D_ 4
	volume 39
	D_ 3
	speed 7
	volume 208
	octave 1
	cutoff 6
	G_ 1
	cutoff 4
	G_ 1
	octave 3
	cutoff 8
	speed 1
	F# 4
	volume 39
	F# 3
	speed 7
	octave 1
	volume 208
	B_ 1
	inc_octave
	C_ 1
	C# 1
	dec_octave
	D_ 1
	octave 3
	volume 112
	speed 1
	E_ 4
	volume 39
	E_ 3
	volume 208
	speed 7
	octave 1
	cutoff 6
	D_ 1
	cutoff 4
	D_ 1
	octave 3
	cutoff 8
	speed 1
	G_ 4
	volume 39
	G_ 3
	speed 7
	dec_octave
	volume 208
	C_ 1
	D_ 1
	octave 4
	volume 112
	speed 1
	G_ 4
	volume 39
	G_ 3
	speed 7
	octave 1
	volume 208
	cutoff 8
	D_ 1
	octave 3
	volume 112
	speed 1
	E_ 4
	volume 39
	E_ 3
	speed 7
	volume 208
	cutoff 6
	octave 1
	D_ 1
	cutoff 4
	D_ 1
	octave 3
	cutoff 8
	speed 1
	G_ 4
	volume 39
	G_ 3
	speed 7
	octave 1
	volume 208
	C_ 1
	C# 1
	inc_octave
	D_ 1
	EndLoop
	EndMainLoop


Music_PauseMenu_Ch3: ; f6e2d (3d:6e2d)
	speed 1
	wave 3
	stereo_panning 1, 1
	volume 64
	echo 96
	cutoff 4
	octave 4
	G_ 7
	cutoff 8
	F# 4
	volume 96
	G_ 3
	volume 64
	D_ 4
	volume 96
	F# 3
	dec_octave
	volume 64
	B_ 4
	inc_octave
	volume 96
	D_ 3
	MainLoop
	octave 4
	Loop 3
	volume 64
	G_ 4
	dec_octave
	volume 96
	B_ 3
	inc_octave
	volume 64
	F# 4
	volume 96
	G_ 3
	volume 64
	D_ 4
	volume 96
	F# 3
	dec_octave
	volume 64
	B_ 4
	inc_octave
	volume 96
	D_ 3
	EndLoop
	volume 64
	G_ 4
	dec_octave
	volume 96
	B_ 3
	inc_octave
	volume 64
	E_ 4
	volume 96
	G_ 3
	volume 64
	C_ 4
	volume 96
	E_ 3
	dec_octave
	volume 64
	A_ 4
	inc_octave
	volume 96
	C_ 3
	Loop 3
	volume 64
	G_ 4
	dec_octave
	volume 96
	A_ 3
	inc_octave
	volume 64
	E_ 4
	volume 96
	G_ 3
	volume 64
	C_ 4
	volume 96
	E_ 3
	dec_octave
	volume 64
	A_ 4
	inc_octave
	volume 96
	C_ 3
	EndLoop
	volume 64
	G_ 4
	dec_octave
	volume 96
	A_ 3
	inc_octave
	volume 64
	F# 4
	volume 96
	G_ 3
	volume 64
	D_ 4
	volume 96
	F# 3
	dec_octave
	volume 64
	B_ 4
	inc_octave
	volume 96
	D_ 3
	EndMainLoop


Music_PauseMenu_Ch4: ; f6ec8 (3d:6ec8)
	speed 7
	octave 1
	MainLoop
	Loop 2
	Loop 7
	bass 1
	snare3 1
	snare4 2
	snare1 1
	snare3 1
	snare4 1
	snare2 1
	bass 1
	snare3 1
	snare4 2
	snare1 1
	snare3 1
	snare4 1
	snare1 1
	EndLoop
	bass 1
	snare3 1
	snare4 2
	snare1 1
	snare3 1
	snare4 1
	speed 1
	snare2 4
	snare2 3
	speed 7
	Loop 8
	snare1 1
	EndLoop
	EndLoop
	EndMainLoop
; 0xf6ef1
