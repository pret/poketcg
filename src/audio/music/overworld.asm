Music_Overworld_Ch1: ; f71a0 (3d:71a0)
	speed 7
	duty 0
	stereo_panning 1, 1
	vibrato_type 9
	vibrato_delay 25
	volume 162
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
	volume 160
	A_ 5
	volume 55
	A_ 1
	inc_octave
	volume 160
	C_ 5
	volume 55
	C_ 1
	volume 160
	F_ 3
	speed 1
	E_ 11
	volume 55
	E_ 10
	volume 160
	speed 7
	G_ 3
	speed 1
	F_ 11
	volume 55
	F_ 10
	speed 7
	volume 160
	C_ 12
	volume 55
	C_ 2
	duty 0
	volume 146
	cutoff 7
	octave 3
	E_ 4
	E_ 3
	E_ 3
	duty 1
	volume 160
	cutoff 8
	music_call Branch_f72fb
	C_ 6
	volume 55
	C_ 6
	volume 160
	C_ 3
	D_ 3
	E_ 3
	G_ 6
	volume 55
	G_ 3
	volume 160
	F_ 4
	volume 55
	F_ 2
	volume 160
	C_ 3
	dec_octave
	A_ 6
	A# 9
	volume 55
	A# 6
	volume 160
	A# 3
	inc_octave
	D_ 3
	F_ 3
	A_ 3
	volume 55
	A_ 6
	volume 160
	G_ 3
	volume 55
	G_ 3
	volume 160
	E_ 3
	D_ 3
	volume 55
	D_ 3
	volume 160
	E_ 2
	volume 55
	E_ 1
	volume 160
	cutoff 8
	C_ 9
	volume 55
	C_ 3
	volume 160
	dec_octave
	A_ 3
	inc_octave
	speed 1
	C_ 11
	volume 64
	C_ 10
	speed 7
	volume 160
	G_ 3
	speed 1
	F_ 11
	volume 64
	F_ 10
	speed 7
	volume 160
	C_ 12
	volume 55
	C_ 6
	duty 2
	cutoff 8
	volume 95
	octave 4
	G_ 1
	tie
	E_ 1
	tie
	C_ 1
	tie
	dec_octave
	G_ 1
	tie
	E_ 1
	tie
	C_ 1
	duty 1
	volume 160
	cutoff 8
	music_call Branch_f72fb
	C_ 6
	volume 55
	C_ 6
	volume 160
	C_ 3
	D_ 3
	E_ 3
	F_ 9
	volume 55
	F_ 12
	volume 160
	F_ 2
	G_ 1
	A_ 1
	volume 55
	A_ 2
	volume 160
	A_ 12
	volume 55
	A_ 3
	volume 160
	D_ 3
	A_ 3
	A# 9
	volume 55
	A# 6
	volume 160
	A_ 5
	volume 55
	A_ 1
	volume 160
	G_ 5
	volume 55
	G_ 1
	volume 144
	F_ 8
	tie
	F_ 8
	tie
	F_ 8
	tie
	F_ 8
	tie
	F_ 8
	tie
	F_ 8
	volume 55
	F_ 3
	duty 0
	volume 162
	cutoff 7
	EndMainLoop

Branch_f72ba:
	octave 3
	F_ 3
	F_ 2
	A_ 1
	inc_octave
	volume 160
	cutoff 4
	C_ 1
	rest 1
	dec_octave
	volume 146
	cutoff 7
	A# 3
	A# 1
	inc_octave
	volume 160
	cutoff 4
	D_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	G_ 3
	A# 3
	rest 3
	A_ 3
	A_ 2
	inc_octave
	C_ 1
	volume 160
	cutoff 4
	C_ 1
	rest 1
	dec_octave
	volume 146
	cutoff 7
	A# 3
	A# 1
	inc_octave
	volume 160
	cutoff 4
	D_ 1
	rest 2
	volume 146
	cutoff 7
	C_ 3
	dec_octave
	A# 3
	music_ret

Branch_f72fb:
	octave 4
	volume 160
	D_ 5
	volume 55
	D_ 1
	volume 160
	F_ 5
	volume 55
	F_ 1
	volume 160
	A_ 3
	speed 1
	G_ 11
	volume 55
	G_ 10
	speed 7
	inc_octave
	volume 160
	C_ 3
	dec_octave
	speed 1
	A# 11
	volume 55
	A# 10
	speed 7
	volume 160
	C# 12
	volume 55
	C# 6
	volume 160
	D# 3
	speed 1
	C# 11
	volume 55
	C# 10
	volume 160
	speed 7
	music_ret


Music_Overworld_Ch2: ; f7334 (3d:7334)
	speed 7
	duty 0
	stereo_panning 1, 1
	vibrato_type 9
	vibrato_delay 30
	cutoff 7
	octave 3
	music_call Branch_f7535
	MainLoop
	music_call Branch_f7535
	volume 146
	cutoff 7
	rest 3
	C_ 5
	C_ 3
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	C_ 4
	C_ 3
	C_ 3
	rest 3
	C_ 5
	C_ 3
	volume 144
	cutoff 4
	inc_octave
	G_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	D_ 4
	D_ 3
	C_ 3
	rest 3
	dec_octave
	A# 5
	inc_octave
	D_ 3
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	C_ 4
	C_ 3
	dec_octave
	A# 3
	rest 3
	A# 5
	inc_octave
	C# 3
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	C# 4
	dec_octave
	F_ 3
	A# 3
	rest 3
	inc_octave
	C_ 3
	E_ 2
	C_ 3
	volume 144
	cutoff 4
	inc_octave
	G_ 1
	cutoff 7
	volume 96
	cutoff 8
	octave 3
	E_ 3
	F_ 3
	G_ 3
	cutoff 7
	A# 6
	volume 146
	cutoff 7
	octave 3
	D_ 3
	volume 96
	cutoff 8
	octave 3
	A_ 3
	volume 146
	cutoff 7
	octave 2
	A_ 2
	inc_octave
	inc_octave
	volume 144
	cutoff 4
	F_ 1
	dec_octave
	rest 2
	volume 146
	cutoff 7
	D_ 4
	D_ 3
	dec_octave
	A_ 3
	rest 3
	A# 3
	inc_octave
	D_ 2
	dec_octave
	A# 3
	volume 144
	cutoff 4
	inc_octave
	inc_octave
	F_ 1
	rest 2
	dec_octave
	dec_octave
	volume 146
	cutoff 7
	A# 4
	A# 3
	A# 3
	rest 3
	A# 3
	inc_octave
	D_ 2
	dec_octave
	A# 3
	volume 144
	cutoff 4
	inc_octave
	A_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	A# 6
	inc_octave
	D_ 1
	dec_octave
	A# 3
	rest 3
	inc_octave
	C_ 5
	C_ 3
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 2
	volume 146
	cutoff 7
	dec_octave
	C_ 4
	C_ 3
	C_ 3
	rest 3
	C_ 5
	C_ 3
	volume 144
	cutoff 4
	inc_octave
	G_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	D_ 4
	duty 2
	volume 95
	cutoff 8
	octave 4
	C_ 1
	tie
	dec_octave
	G_ 1
	tie
	E_ 1
	tie
	C_ 1
	tie
	dec_octave
	G_ 1
	tie
	E_ 1
	duty 0
	volume 146
	cutoff 7
	octave 2
	rest 3
	A# 5
	inc_octave
	D_ 3
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	C_ 4
	C_ 3
	dec_octave
	A# 3
	rest 3
	A# 5
	inc_octave
	C# 3
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	C# 4
	C# 3
	C# 3
	rest 3
	C_ 3
	dec_octave
	A_ 2
	inc_octave
	C_ 3
	volume 144
	cutoff 4
	inc_octave
	G_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	C_ 4
	E_ 3
	C_ 3
	rest 3
	D_ 6
	dec_octave
	B_ 2
	inc_octave
	inc_octave
	volume 144
	cutoff 4
	F_ 1
	rest 2
	dec_octave
	volume 146
	cutoff 7
	D_ 4
	volume 96
	cutoff 8
	octave 4
	D_ 2
	E_ 1
	F_ 1
	volume 39
	F_ 2
	volume 96
	F_ 11
	volume 146
	cutoff 7
	octave 4
	volume 144
	cutoff 4
	F_ 1
	rest 2
	dec_octave
	dec_octave
	volume 146
	cutoff 7
	A# 1
	volume 96
	cutoff 8
	octave 3
	A# 3
	inc_octave
	F_ 3
	G_ 9
	volume 146
	cutoff 7
	octave 3
	D_ 2
	dec_octave
	A# 3
	inc_octave
	inc_octave
	volume 144
	cutoff 4
	F_ 1
	cutoff 8
	volume 96
	octave 4
	C_ 5
	volume 39
	C_ 1
	dec_octave
	volume 144
	A# 5
	volume 39
	A# 1
	volume 146
	cutoff 7
	octave 3
	rest 3
	F_ 3
	C_ 2
	F_ 1
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 1
	dec_octave
	volume 146
	cutoff 7
	G_ 3
	G_ 3
	speed 1
	volume 144
	cutoff 8
	inc_octave
	F_ 4
	C_ 3
	speed 7
	dec_octave
	volume 146
	cutoff 7
	E_ 3
	G_ 2
	inc_octave
	volume 144
	cutoff 4
	F_ 1
	volume 146
	cutoff 7
	dec_octave
	rest 3
	A_ 3
	F_ 2
	A_ 1
	inc_octave
	volume 144
	cutoff 4
	F_ 1
	rest 1
	dec_octave
	volume 146
	cutoff 7
	G_ 3
	G_ 3
	speed 1
	volume 144
	cutoff 8
	inc_octave
	F_ 4
	C_ 3
	dec_octave
	speed 7
	volume 146
	cutoff 7
	A_ 3
	G_ 2
	inc_octave
	volume 144
	cutoff 4
	F_ 1
	EndMainLoop

Branch_f7535:
	octave 3
	volume 146
	cutoff 7
	rest 3
	C_ 3
	C_ 2
	F_ 1
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 1
	dec_octave
	volume 146
	cutoff 7
	G_ 3
	G_ 1
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 1
	dec_octave
	cutoff 8
	speed 1
	inc_octave
	F_ 4
	C_ 3
	speed 7
	volume 146
	cutoff 7
	dec_octave
	E_ 3
	G_ 2
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	dec_octave
	rest 3
	volume 146
	cutoff 8
	F_ 3
	F_ 2
	A_ 1
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 1
	dec_octave
	volume 146
	cutoff 7
	G_ 3
	G_ 1
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	rest 1
	dec_octave
	cutoff 8
	speed 1
	inc_octave
	F_ 4
	C_ 3
	speed 7
	volume 146
	cutoff 7
	dec_octave
	A_ 3
	G_ 2
	volume 144
	cutoff 4
	inc_octave
	F_ 1
	dec_octave
	music_ret


Music_Overworld_Ch3: ; f75a1 (3d:75a1)
	speed 7
	stereo_panning 1, 1
	volume 32
	wave 1
	echo 64
	cutoff 7
	octave 1
	music_call Branch_f77f8
	F_ 2
	inc_octave
	C_ 1
	MainLoop
	music_call Branch_f77f8
	F_ 3
	music_call Branch_f7826
	octave 1
	cutoff 8
	F_ 1
	A# 2
	rest 1
	octave 3
	cutoff 3
	C# 2
	dec_octave
	cutoff 8
	F_ 1
	A# 1
	rest 1
	inc_octave
	cutoff 3
	F_ 2
	rest 1
	inc_octave
	C# 1
	octave 1
	cutoff 8
	A# 1
	rest 1
	octave 3
	cutoff 7
	G_ 1
	octave 1
	cutoff 8
	A# 1
	rest 1
	F_ 1
	inc_octave
	cutoff 3
	A# 2
	dec_octave
	cutoff 8
	A# 1
	octave 3
	cutoff 3
	C# 2
	octave 1
	cutoff 8
	F_ 1
	A_ 2
	rest 1
	octave 3
	cutoff 3
	E_ 2
	octave 1
	cutoff 8
	A_ 1
	octave 3
	cutoff 3
	G_ 2
	cutoff 7
	E_ 1
	cutoff 8
	dec_octave
	E_ 1
	rest 1
	inc_octave
	inc_octave
	cutoff 3
	E_ 1
	octave 1
	cutoff 8
	A_ 1
	rest 1
	inc_octave
	A_ 1
	rest 2
	dec_octave
	A_ 1
	inc_octave
	A_ 1
	E_ 1
	C_ 1
	dec_octave
	A_ 1
	rest 1
	inc_octave
	A_ 1
	dec_octave
	D_ 2
	rest 1
	octave 3
	cutoff 3
	F_ 2
	octave 1
	cutoff 8
	A_ 1
	inc_octave
	D_ 2
	dec_octave
	A_ 1
	octave 3
	cutoff 3
	D_ 2
	inc_octave
	C_ 1
	octave 1
	cutoff 8
	D_ 2
	octave 3
	cutoff 3
	F_ 2
	rest 1
	octave 1
	cutoff 8
	A_ 1
	octave 3
	cutoff 3
	F_ 2
	octave 1
	cutoff 8
	D_ 1
	octave 3
	cutoff 3
	D_ 2
	cutoff 8
	octave 1
	A_ 1
	G_ 2
	rest 1
	octave 3
	cutoff 3
	D_ 2
	octave 1
	cutoff 8
	G_ 1
	octave 3
	cutoff 3
	F_ 2
	cutoff 7
	D_ 1
	dec_octave
	cutoff 8
	D_ 1
	rest 1
	cutoff 3
	inc_octave
	A# 1
	octave 1
	cutoff 8
	G_ 1
	rest 1
	octave 3
	cutoff 3
	D_ 2
	rest 1
	dec_octave
	cutoff 8
	D_ 1
	inc_octave
	cutoff 3
	F_ 2
	octave 1
	cutoff 8
	G_ 1
	octave 3
	cutoff 3
	D_ 2
	cutoff 8
	dec_octave
	D_ 1
	C_ 2
	rest 1
	inc_octave
	cutoff 3
	D_ 2
	octave 1
	cutoff 8
	G_ 1
	octave 3
	cutoff 3
	F_ 2
	cutoff 7
	D_ 1
	octave 1
	cutoff 8
	C_ 1
	rest 1
	octave 3
	cutoff 3
	F_ 1
	dec_octave
	cutoff 8
	C_ 1
	rest 1
	inc_octave
	cutoff 3
	D_ 2
	rest 1
	octave 1
	cutoff 8
	E_ 1
	inc_octave
	C_ 1
	rest 1
	inc_octave
	cutoff 7
	F_ 1
	cutoff 3
	E_ 2
	cutoff 8
	octave 1
	E_ 1
	music_call Branch_f7826
	cutoff 8
	octave 2
	C_ 1
	C# 2
	rest 1
	inc_octave
	cutoff 3
	C# 2
	octave 1
	cutoff 8
	G# 1
	inc_octave
	C# 1
	rest 1
	inc_octave
	cutoff 3
	F_ 2
	rest 1
	inc_octave
	C# 1
	octave 2
	cutoff 8
	C# 1
	rest 1
	inc_octave
	G_ 1
	dec_octave
	cutoff 8
	C# 1
	rest 1
	dec_octave
	G# 1
	octave 3
	cutoff 3
	G_ 2
	dec_octave
	cutoff 8
	C# 1
	inc_octave
	cutoff 3
	F_ 2
	octave 1
	cutoff 8
	G# 1
	inc_octave
	C_ 2
	rest 1
	inc_octave
	cutoff 3
	E_ 2
	dec_octave
	cutoff 8
	G_ 1
	inc_octave
	cutoff 3
	C_ 2
	cutoff 7
	E_ 1
	dec_octave
	cutoff 8
	E_ 1
	rest 1
	octave 4
	cutoff 3
	E_ 1
	octave 2
	cutoff 8
	C_ 1
	rest 1
	inc_octave
	cutoff 3
	E_ 2
	rest 1
	octave 1
	cutoff 8
	G_ 1
	octave 3
	cutoff 3
	G_ 2
	dec_octave
	cutoff 8
	C_ 1
	inc_octave
	cutoff 3
	E_ 2
	octave 1
	cutoff 8
	G_ 1
	B_ 2
	rest 1
	octave 3
	cutoff 3
	F_ 2
	dec_octave
	cutoff 8
	F_ 1
	B_ 2
	F_ 1
	inc_octave
	cutoff 3
	D_ 2
	inc_octave
	D_ 1
	octave 1
	cutoff 8
	B_ 2
	octave 3
	cutoff 3
	F_ 2
	rest 1
	dec_octave
	cutoff 8
	F_ 1
	B_ 2
	F_ 1
	dec_octave
	B_ 2
	rest 1
	A# 2
	rest 1
	octave 3
	cutoff 3
	D_ 2
	dec_octave
	cutoff 8
	F_ 1
	A# 2
	F_ 1
	inc_octave
	cutoff 3
	F_ 2
	inc_octave
	D_ 1
	octave 1
	cutoff 8
	A# 1
	rest 1
	octave 3
	cutoff 7
	D_ 1
	octave 1
	cutoff 8
	A# 1
	rest 2
	A# 2
	inc_octave
	F_ 1
	A# 1
	rest 2
	C_ 2
	rest 1
	inc_octave
	cutoff 3
	D_ 2
	octave 1
	cutoff 8
	G_ 1
	octave 3
	cutoff 3
	F_ 2
	cutoff 7
	D_ 1
	octave 1
	cutoff 8
	C_ 1
	rest 1
	octave 4
	cutoff 3
	D_ 1
	octave 2
	cutoff 8
	C_ 1
	rest 1
	inc_octave
	cutoff 3
	D_ 2
	rest 1
	octave 1
	cutoff 8
	E_ 1
	inc_octave
	C_ 1
	dec_octave
	G_ 1
	E_ 1
	C_ 1
	rest 1
	E_ 1
	F_ 3
	octave 3
	cutoff 3
	A_ 2
	dec_octave
	cutoff 8
	C_ 1
	inc_octave
	cutoff 5
	F_ 2
	A_ 1
	inc_octave
	C_ 1
	dec_octave
	rest 1
	A# 2
	rest 1
	A# 1
	inc_octave
	D_ 1
	dec_octave
	rest 2
	G_ 2
	dec_octave
	cutoff 8
	C_ 1
	inc_octave
	cutoff 5
	A# 2
	inc_octave
	C_ 1
	octave 1
	cutoff 8
	F_ 3
	octave 4
	cutoff 3
	C_ 2
	octave 2
	cutoff 8
	C_ 1
	inc_octave
	cutoff 5
	A_ 2
	inc_octave
	C_ 1
	C_ 1
	rest 1
	dec_octave
	A# 2
	rest 1
	A# 1
	inc_octave
	D_ 1
	rest 2
	C_ 2
	octave 2
	cutoff 8
	C_ 1
	inc_octave
	cutoff 5
	A# 2
	dec_octave
	cutoff 8
	C_ 1
	EndMainLoop

Branch_f77f8:
	octave 1
	F_ 3
	octave 3
	cutoff 3
	A_ 2
	dec_octave
	cutoff 8
	C_ 1
	F_ 2
	C_ 1
	rest 2
	F_ 1
	rest 2
	F_ 1
	rest 2
	C_ 1
	F_ 2
	C_ 1
	dec_octave
	F_ 2
	inc_octave
	C_ 1
	dec_octave
	F_ 3
	octave 4
	cutoff 3
	C_ 2
	octave 2
	cutoff 8
	C_ 1
	F_ 2
	C_ 1
	rest 2
	F_ 1
	rest 2
	F_ 1
	rest 2
	C_ 1
	F_ 2
	C_ 1
	dec_octave
	music_ret

Branch_f7826:
	octave 1
	F_ 2
	rest 1
	octave 3
	cutoff 3
	F_ 2
	dec_octave
	cutoff 8
	C_ 1
	F_ 1
	rest 1
	inc_octave
	cutoff 3
	F_ 2
	rest 1
	inc_octave
	C_ 1
	octave 1
	cutoff 8
	F_ 1
	rest 1
	octave 3
	cutoff 7
	G_ 1
	octave 1
	cutoff 8
	F_ 1
	rest 1
	C_ 1
	octave 3
	cutoff 3
	G_ 2
	octave 1
	cutoff 8
	F_ 1
	octave 3
	cutoff 7
	F_ 2
	octave 1
	cutoff 8
	G_ 1
	A_ 2
	rest 1
	octave 3
	cutoff 3
	E_ 2
	dec_octave
	cutoff 8
	E_ 1
	A_ 1
	rest 1
	inc_octave
	cutoff 3
	E_ 2
	rest 1
	inc_octave
	C_ 1
	octave 1
	cutoff 8
	A_ 1
	rest 1
	octave 3
	cutoff 7
	E_ 1
	octave 1
	cutoff 8
	Loop 2
	A_ 1
	rest 1
	E_ 1
	EndLoop
	A_ 2
	rest 1
	A# 2
	rest 1
	octave 3
	cutoff 3
	D_ 2
	dec_octave
	cutoff 8
	F_ 1
	A# 1
	rest 1
	inc_octave
	cutoff 3
	F_ 2
	rest 1
	inc_octave
	D_ 1
	octave 1
	cutoff 8
	A# 1
	rest 1
	octave 3
	cutoff 7
	D_ 1
	octave 1
	cutoff 8
	A# 1
	rest 1
	F_ 1
	octave 3
	cutoff 3
	D_ 2
	octave 1
	cutoff 8
	A# 1
	octave 3
	cutoff 3
	D_ 2
	music_ret


Music_Overworld_Ch4: ; f78af (3d:78af)
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
; 0xf7919
