Music_Imakuni_Ch1: ; fad55 (3e:6d55)
	speed 3
	stereo_panning 1, 1
	vibrato_type 5
	vibrato_delay 20
	cutoff 8
	duty 2
	volume 160
	MainLoop
	Loop 16
	rest 10
	EndLoop
	music_call Branch_fadf9
	octave 4
	D_ 15
	dec_octave
	B_ 7
	rest 8
	G_ 7
	rest 8
	speed 9
	F_ 10
	tie
	speed 1
	F_ 7
	rest 8
	speed 9
	rest 10
	music_call Branch_fadf9
	music_call Branch_fae1d
	speed 1
	octave 4
	E_ 7
	rest 15
	E_ 3
	C_ 2
	E_ 3
	C_ 15
	dec_octave
	G# 15
	A_ 7
	rest 8
	speed 3
	rest 15
	speed 1
	rest 15
	rest 15
	inc_octave
	E_ 7
	rest 8
	F# 7
	rest 8
	G_ 15
	tie
	G_ 7
	F# 3
	G_ 2
	F# 3
	E_ 7
	rest 8
	D# 7
	rest 8
	E_ 15
	C_ 7
	rest 8
	dec_octave
	G# 7
	rest 8
	speed 7
	F# 15
	speed 9
	rest 10
	music_call Branch_fadf9
	music_call Branch_fae1d
	dec_octave
	speed 1
	F_ 7
	rest 8
	B_ 7
	inc_octave
	C_ 8
	dec_octave
	G# 7
	A_ 8
	F_ 7
	rest 8
	B_ 7
	inc_octave
	C_ 8
	dec_octave
	G# 7
	A_ 8
	speed 3
	F_ 10
	speed 1
	D# 7
	rest 8
	A_ 7
	A# 8
	F# 7
	G_ 8
	D# 7
	rest 8
	A_ 7
	A# 8
	F# 7
	G_ 8
	speed 3
	D# 10
	speed 1
	Loop 4
	D_ 7
	dec_octave
	A_ 8
	D_ 7
	A_ 8
	D_ 7
	A_ 8
	inc_octave
	EndLoop
	D_ 7
	dec_octave
	A_ 8
	D_ 7
	A_ 8
	vibrato_delay 5
	speed 3
	D_ 10
	vibrato_delay 20
	EndMainLoop

Branch_fadf9:
	speed 1
	octave 4
	C# 7
	rest 15
	C# 3
	D_ 2
	C# 3
	dec_octave
	A# 15
	B_ 15
	inc_octave
	D_ 7
	rest 8
	speed 5
	rest 9
	speed 1
	rest 15
	rest 15
	D_ 7
	rest 8
	E_ 7
	rest 8
	F_ 15
	tie
	F_ 7
	E_ 3
	F_ 2
	E_ 3
	D_ 7
	rest 8
	C# 7
	rest 8
	music_ret

Branch_fae1d:
	octave 4
	D_ 7
	rest 8
	dec_octave
	G_ 7
	rest 8
	inc_octave
	G_ 7
	rest 8
	speed 9
	F_ 10
	tie
	speed 1
	F_ 7
	rest 8
	speed 9
	rest 10
	music_ret


Music_Imakuni_Ch2: ; fae32 (3e:6e32)
	stereo_panning 1, 1
	vibrato_type 0
	vibrato_delay 0
	cutoff 8
	duty 1
	volume 160
	Loop 6
	music_call Branch_faea5
	EndLoop
	Loop 2
	Loop 2
	speed 3
	rest 10
	speed 1
	C_ 7
	rest 8
	EndLoop
	rest 15
	C_ 7
	rest 8
	speed 3
	rest 10
	speed 1
	C_ 7
	rest 8
	rest 15
	speed 3
	rest 10
	vibrato_delay 8
	C_ 10
	vibrato_delay 0
	EndLoop
	Loop 2
	music_call Branch_faea5
	EndLoop
	speed 1
	octave 2
	F_ 15
	tie
	F_ 7
	inc_octave
	F_ 8
	D# 7
	rest 8
	rest 15
	G# 7
	A_ 8
	F_ 7
	D# 8
	speed 3
	rest 10
	speed 1
	dec_octave
	D# 15
	tie
	D# 7
	inc_octave
	D# 8
	C# 7
	rest 8
	rest 15
	F# 7
	G_ 8
	D# 7
	C# 8
	speed 3
	rest 10
	speed 1
	Loop 4
	D_ 7
	rest 8
	Loop 2
	rest 15
	EndLoop
	EndLoop
	D_ 7
	rest 8
	rest 15
	vibrato_delay 5
	D_ 15
	tie
	D_ 7
	rest 8
	vibrato_delay 0
	EndMainLoop

Branch_faea5:
	octave 3
	speed 6
	rest 10
	speed 1
	Loop 2
	rest 15
	C# 7
	rest 8
	EndLoop
	vibrato_delay 8
	speed 9
	rest 10
	speed 3
	C# 10
	vibrato_delay 0
	music_ret


Music_Imakuni_Ch3: ; faebc (3e:6ebc)
	stereo_panning 1, 1
	volume 32
	wave 1
	vibrato_type 6
	vibrato_delay 0
	echo 0
	cutoff 8
	MainLoop
	music_call Branch_faf7d
	vibrato_delay 8
	speed 1
	D_ 15
	tie
	D_ 7
	inc_octave
	vibrato_delay 0
	G_ 3
	dec_octave
	G_ 2
	dec_octave
	G_ 3
	music_call Branch_faf7d
	vibrato_delay 8
	D_ 10
	vibrato_delay 0
	Loop 4
	music_call Branch_faf7d
	vibrato_delay 8
	D_ 10
	vibrato_delay 0
	EndLoop
	Loop 2
	octave 2
	speed 3
	C_ 5
	rest 5
	inc_octave
	speed 1
	E_ 7
	rest 8
	dec_octave
	speed 3
	G# 5
	A_ 5
	inc_octave
	speed 1
	D# 7
	rest 8
	rest 15
	D# 7
	rest 8
	speed 3
	rest 5
	dec_octave
	C_ 5
	inc_octave
	speed 1
	E_ 7
	rest 8
	dec_octave
	speed 3
	G# 5
	A_ 5
	rest 5
	inc_octave
	vibrato_delay 8
	D# 10
	vibrato_delay 0
	EndLoop
	Loop 2
	music_call Branch_faf7d
	vibrato_delay 8
	D_ 10
	vibrato_delay 0
	EndLoop
	speed 1
	octave 1
	F_ 15
	tie
	F_ 7
	inc_octave
	F_ 8
	D# 7
	rest 8
	F_ 7
	rest 8
	G# 7
	A_ 8
	F_ 7
	D# 8
	vibrato_delay 5
	speed 3
	F_ 10
	vibrato_delay 0
	speed 1
	dec_octave
	D# 15
	tie
	D# 7
	inc_octave
	D# 8
	C# 7
	rest 8
	D# 7
	rest 8
	F# 7
	G_ 8
	D# 7
	C# 8
	vibrato_delay 5
	speed 3
	D# 10
	vibrato_delay 0
	speed 1
	Loop 4
	octave 3
	C_ 7
	rest 8
	octave 1
	D_ 7
	rest 8
	D_ 7
	rest 8
	EndLoop
	octave 3
	C_ 7
	rest 8
	octave 1
	D_ 7
	rest 8
	octave 3
	vibrato_delay 5
	C_ 15
	tie
	C_ 7
	inc_octave
	vibrato_delay 0
	G_ 3
	dec_octave
	G_ 2
	dec_octave
	G_ 3
	speed 8
	EndMainLoop

Branch_faf7d:
	speed 3
	octave 1
	G_ 5
	rest 5
	inc_octave
	speed 1
	G_ 7
	rest 8
	speed 3
	C# 5
	D_ 5
	inc_octave
	speed 1
	D_ 7
	rest 8
	rest 15
	D_ 7
	rest 8
	speed 3
	rest 5
	octave 1
	G_ 5
	inc_octave
	speed 1
	G_ 7
	rest 8
	speed 3
	C# 5
	D_ 5
	rest 5
	inc_octave
	music_ret


Music_Imakuni_Ch4: ; fafa4 (3e:6fa4)
	speed 1
	octave 1
	Loop 10
	bass 15
	snare3 7
	bass 8
	snare1 15
	bass 15
	snare3 7
	snare3 8
	snare4 15
	snare3 7
	snare3 8
	snare4 15
	snare3 15
	bass 15
	snare1 15
	snare4 15
	bass 7
	snare3 8
	snare1 15
	snare1 15
	snare3 7
	snare1 8
	EndLoop
	Loop 2
	speed 11
	snare5 2
	speed 1
	snare1 8
	snare1 15
	snare1 15
	snare1 7
	snare1 8
	snare1 7
	snare1 8
	speed 3
	snare5 10
	EndLoop
	speed 1
	snare1 15
	snare3 7
	snare1 8
	snare4 15
	snare1 15
	snare3 7
	snare1 8
	snare4 15
	snare1 15
	snare3 7
	snare1 8
	snare4 15
	snare1 15
	snare3 7
	snare1 8
	snare4 15
	snare1 15
	snare3 4
	snare3 4
	snare1 7
	snare1 15
	snare1 15
	EndMainLoop
; 0xfafea
