Music_CardPop_Ch1:
	speed 4
	stereo_panning TRUE, TRUE
	cutoff 8
	duty 2
	volume_envelope 9, 0
	MainLoop
	Loop 7
	rest 16
	EndLoop
	rest 14
	Loop 2
	octave 5
	cutoff 8
	note F#, 1
	note G_, 1
	cutoff 6
	note F#, 1
	volume_envelope 3, 7
	note F#, 1
	volume_envelope 9, 0
	note D_, 1
	volume_envelope 3, 7
	note F#, 1
	dec_octave
	volume_envelope 9, 0
	note A_, 1
	inc_octave
	volume_envelope 3, 7
	note D_, 1
	dec_octave
	volume_envelope 9, 0
	note G_, 1
	volume_envelope 3, 7
	note A_, 1
	volume_envelope 9, 0
	note F#, 1
	volume_envelope 3, 7
	note G_, 1
	volume_envelope 9, 0
	note D_, 1
	volume_envelope 3, 7
	note G_, 1
	dec_octave
	volume_envelope 9, 0
	note A_, 1
	volume_envelope 3, 7
	inc_octave
	note D_, 1
	dec_octave
	volume_envelope 9, 0
	note G_, 1
	volume_envelope 3, 7
	note A_, 1
	volume_envelope 9, 0
	note F#, 1
	volume_envelope 3, 7
	note G_, 1
	rest 1
	note F#, 1
	rest 12
	rest 16
	rest 14
	octave 5
	volume_envelope 9, 0
	cutoff 8
	note E_, 1
	note F_, 1
	cutoff 6
	note E_, 1
	volume_envelope 3, 7
	note E_, 1
	volume_envelope 9, 0
	note C_, 1
	volume_envelope 3, 7
	note E_, 1
	dec_octave
	volume_envelope 9, 0
	note G_, 1
	inc_octave
	volume_envelope 3, 7
	note C_, 1
	dec_octave
	volume_envelope 9, 0
	note F_, 1
	volume_envelope 3, 7
	note G_, 1
	volume_envelope 9, 0
	note E_, 1
	volume_envelope 3, 7
	note F_, 1
	volume_envelope 9, 0
	note C_, 1
	volume_envelope 3, 7
	note E_, 1
	dec_octave
	volume_envelope 9, 0
	note G_, 1
	volume_envelope 3, 7
	inc_octave
	note C_, 1
	dec_octave
	volume_envelope 9, 0
	note F_, 1
	volume_envelope 3, 7
	note G_, 1
	volume_envelope 9, 0
	note E_, 1
	volume_envelope 3, 7
	note F_, 1
	rest 1
	note E_, 1
	rest 12
	rest 16
	volume_envelope 9, 0
	rest 14
	EndLoop
	rest 2
	EndMainLoop


Music_CardPop_Ch2:
	speed 4
	stereo_panning TRUE, TRUE
	cutoff 8
	duty 2
	volume_envelope 6, 0
	cutoff 3
	Loop 2
	octave 2
	note A_, 2
	inc_octave
	note A_, 2
	inc_octave
	note A_, 2
	dec_octave
	note A_, 2
	inc_octave
	inc_octave
	note A_, 2
	dec_octave
	note A_, 2
	dec_octave
	note A_, 2
	inc_octave
	inc_octave
	note A_, 2
	dec_octave
	dec_octave
	note A_, 2
	dec_octave
	note A_, 2
	inc_octave
	note A_, 2
	inc_octave
	note A_, 2
	inc_octave
	note A_, 2
	dec_octave
	note A_, 2
	dec_octave
	note A_, 2
	inc_octave
	inc_octave
	note A_, 2
	EndLoop
	Loop 2
	octave 2
	note G_, 2
	inc_octave
	note G_, 2
	inc_octave
	note G_, 2
	dec_octave
	note G_, 2
	inc_octave
	inc_octave
	note G_, 2
	dec_octave
	note G_, 2
	dec_octave
	note G_, 2
	inc_octave
	inc_octave
	note G_, 2
	dec_octave
	dec_octave
	note G_, 2
	dec_octave
	note G_, 2
	inc_octave
	note G_, 2
	inc_octave
	note G_, 2
	inc_octave
	note G_, 2
	dec_octave
	note G_, 2
	dec_octave
	note G_, 2
	inc_octave
	inc_octave
	note G_, 2
	EndLoop
	EndMainLoop


Music_CardPop_Ch3:
	speed 4
	wave 1
	stereo_panning TRUE, TRUE
	volume_envelope 2, 0
	echo 0
	cutoff 8
	music_call Branch_f715b
	note C_, 2
	note C#, 2
	music_call Branch_f715b
	note D_, 2
	note C#, 2
	music_call Branch_f716c
	note D_, 2
	note C#, 2
	music_call Branch_f716c
	note C_, 2
	note C#, 2
	EndMainLoop

Branch_f715b:
	octave 1
	note D_, 2
	rest 2
	note D_, 4
	inc_octave
	note D_, 2
	dec_octave
	note D_, 2
	rest 2
	note F#, 2
	rest 2
	note G_, 2
	rest 2
	note G#, 2
	rest 2
	note A_, 2
	music_ret

Branch_f716c:
	octave 1
	note C_, 2
	rest 2
	note C_, 4
	inc_octave
	note C_, 2
	dec_octave
	note C_, 2
	rest 2
	note E_, 2
	rest 2
	note F_, 2
	rest 2
	note F#, 2
	rest 2
	note G_, 2
	music_ret


Music_CardPop_Ch4:
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
