Music_PauseMenu_Ch2:
	speed 7
	stereo_panning TRUE, TRUE
	cutoff 8
	duty 2
	MainLoop
	volume_envelope 7, 0
	Loop 4
	rest 16
	EndLoop
	speed 1
	octave 6
	note C_, 4
	dec_octave
	rest 3
	note B_, 4
	inc_octave
	volume_envelope 3, 7
	note C_, 3
	dec_octave
	volume_envelope 7, 0
	note G_, 4
	volume_envelope 3, 7
	note B_, 3
	volume_envelope 7, 0
	note D_, 4
	volume_envelope 3, 7
	note G_, 3
	music_call Branch_f6c24
	music_call Branch_f6c60
	volume_envelope 7, 0
	octave 6
	note C_, 4
	dec_octave
	volume_envelope 3, 7
	note E_, 3
	volume_envelope 7, 0
	note B_, 4
	inc_octave
	volume_envelope 3, 7
	note C_, 3
	dec_octave
	volume_envelope 7, 0
	note G_, 4
	volume_envelope 3, 7
	note B_, 3
	volume_envelope 7, 0
	note D_, 4
	volume_envelope 3, 7
	note G_, 3
	music_call Branch_f6c24
	music_call Branch_f6c60
	octave 6
	volume_envelope 6, 0
	note C_, 4
	dec_octave
	volume_envelope 3, 7
	note E_, 3
	music_call Branch_f6ce9
	music_call Branch_f6c80
	Loop 3
	octave 6
	cutoff 4
	note C_, 1
	music_call Branch_f6ce9
	music_call Branch_f6c80
	EndLoop
	cutoff 8
	EndMainLoop

Branch_f6c24:
	Loop 3
	octave 6
	volume_envelope 7, 0
	note C_, 4
	dec_octave
	volume_envelope 3, 7
	note D_, 3
	volume_envelope 7, 0
	note B_, 4
	inc_octave
	volume_envelope 3, 7
	note C_, 3
	dec_octave
	volume_envelope 7, 0
	note G_, 4
	volume_envelope 3, 7
	note B_, 3
	volume_envelope 7, 0
	note D_, 4
	volume_envelope 3, 7
	note G_, 3
	EndLoop
	inc_octave
	volume_envelope 7, 0
	note C_, 4
	dec_octave
	volume_envelope 3, 7
	note D_, 3
	volume_envelope 7, 0
	note B_, 4
	inc_octave
	volume_envelope 3, 7
	note C_, 3
	dec_octave
	volume_envelope 7, 0
	note G_, 4
	volume_envelope 3, 7
	note B_, 3
	volume_envelope 7, 0
	note E_, 4
	volume_envelope 3, 7
	note G_, 3
	music_ret

Branch_f6c60:
	Loop 3
	octave 6
	volume_envelope 7, 0
	note C_, 4
	dec_octave
	volume_envelope 3, 7
	note E_, 3
	volume_envelope 7, 0
	note B_, 4
	inc_octave
	volume_envelope 3, 7
	note C_, 3
	dec_octave
	volume_envelope 7, 0
	note G_, 4
	volume_envelope 3, 7
	note B_, 3
	volume_envelope 7, 0
	note E_, 4
	volume_envelope 3, 7
	note G_, 3
	EndLoop
	music_ret

Branch_f6c80:
	octave 6
	cutoff 4
	note C_, 1
	octave 3
	volume_envelope 7, 0
	cutoff 8
	speed 1
	note C_, 4
	volume_envelope 2, 7
	note C_, 3
	volume_envelope 6, 0
	speed 7
	octave 5
	cutoff 4
	note G_, 1
	note E_, 1
	octave 3
	cutoff 8
	volume_envelope 7, 0
	speed 1
	note E_, 4
	volume_envelope 2, 7
	note E_, 3
	speed 7
	volume_envelope 6, 0
	octave 5
	cutoff 4
	note B_, 1
	note G_, 1
	dec_octave
	volume_envelope 7, 0
	cutoff 8
	speed 1
	note C_, 4
	volume_envelope 2, 7
	note C_, 3
	volume_envelope 6, 0
	speed 7
	octave 6
	cutoff 4
	note C_, 1
	octave 3
	cutoff 8
	volume_envelope 7, 0
	speed 1
	note C_, 4
	volume_envelope 2, 7
	note C_, 3
	speed 7
	octave 5
	volume_envelope 6, 0
	cutoff 4
	note G_, 1
	note E_, 1
	volume_envelope 7, 0
	octave 3
	cutoff 8
	speed 1
	note E_, 4
	volume_envelope 2, 7
	note E_, 3
	speed 7
	volume_envelope 6, 0
	octave 5
	cutoff 4
	note B_, 1
	note G_, 1
	note E_, 1
	music_ret

Branch_f6ce9:
	octave 2
	speed 1
	cutoff 8
	volume_envelope 7, 0
	note B_, 4
	volume_envelope 2, 7
	note B_, 3
	speed 7
	volume_envelope 6, 0
	octave 5
	cutoff 4
	note G_, 1
	note D_, 1
	octave 3
	volume_envelope 7, 0
	cutoff 8
	speed 1
	note D_, 4
	volume_envelope 2, 7
	note D_, 3
	speed 7
	volume_envelope 6, 0
	octave 5
	cutoff 4
	note B_, 1
	note G_, 1
	volume_envelope 7, 0
	octave 3
	cutoff 8
	speed 1
	note B_, 4
	volume_envelope 2, 7
	note B_, 3
	volume_envelope 6, 0
	speed 7
	octave 6
	cutoff 4
	note C_, 1
	volume_envelope 7, 0
	octave 2
	cutoff 8
	speed 1
	note B_, 4
	volume_envelope 2, 7
	note B_, 3
	speed 7
	volume_envelope 6, 0
	octave 5
	cutoff 4
	note G_, 1
	note D_, 1
	volume_envelope 7, 0
	octave 3
	cutoff 8
	speed 1
	note D_, 4
	volume_envelope 2, 7
	note D_, 3
	speed 7
	volume_envelope 6, 0
	octave 5
	cutoff 4
	note B_, 1
	note G_, 1
	note D_, 1
	music_ret


Music_PauseMenu_Ch1:
	speed 7
	stereo_panning TRUE, TRUE
	cutoff 8
	duty 2
	MainLoop
	volume_envelope 8, 0
	Loop 7
	rest 16
	EndLoop
	octave 5
	rest 8
	speed 1
	Loop 4
	note B_, 4
	note G_, 3
	note E_, 4
	note C_, 3
	dec_octave
	EndLoop
	speed 7
	Loop 4
	octave 1
	volume_envelope 13, 0
	note G_, 1
	octave 3
	volume_envelope 7, 0
	speed 1
	note D_, 4
	volume_envelope 2, 7
	note D_, 3
	volume_envelope 13, 0
	speed 7
	octave 1
	cutoff 6
	note G_, 1
	cutoff 4
	note G_, 1
	octave 3
	cutoff 8
	volume_envelope 7, 0
	speed 1
	note F#, 4
	volume_envelope 2, 7
	note F#, 3
	dec_octave
	volume_envelope 13, 0
	speed 7
	note D_, 1
	note G_, 1
	octave 4
	volume_envelope 7, 0
	speed 1
	note F#, 4
	volume_envelope 2, 7
	note F#, 3
	speed 7
	octave 1
	volume_envelope 13, 0
	cutoff 8
	note G_, 1
	octave 3
	volume_envelope 7, 0
	speed 1
	note D_, 4
	volume_envelope 2, 7
	note D_, 3
	speed 7
	volume_envelope 13, 0
	octave 1
	cutoff 6
	note G_, 1
	cutoff 4
	note G_, 1
	octave 3
	cutoff 8
	speed 1
	note F#, 4
	volume_envelope 2, 7
	note F#, 3
	speed 7
	octave 1
	volume_envelope 13, 0
	note B_, 1
	inc_octave
	note C_, 1
	note C#, 1
	dec_octave
	note D_, 1
	octave 3
	volume_envelope 7, 0
	speed 1
	note E_, 4
	volume_envelope 2, 7
	note E_, 3
	volume_envelope 13, 0
	speed 7
	octave 1
	cutoff 6
	note D_, 1
	cutoff 4
	note D_, 1
	octave 3
	cutoff 8
	speed 1
	note G_, 4
	volume_envelope 2, 7
	note G_, 3
	speed 7
	dec_octave
	volume_envelope 13, 0
	note C_, 1
	note D_, 1
	octave 4
	volume_envelope 7, 0
	speed 1
	note G_, 4
	volume_envelope 2, 7
	note G_, 3
	speed 7
	octave 1
	volume_envelope 13, 0
	cutoff 8
	note D_, 1
	octave 3
	volume_envelope 7, 0
	speed 1
	note E_, 4
	volume_envelope 2, 7
	note E_, 3
	speed 7
	volume_envelope 13, 0
	cutoff 6
	octave 1
	note D_, 1
	cutoff 4
	note D_, 1
	octave 3
	cutoff 8
	speed 1
	note G_, 4
	volume_envelope 2, 7
	note G_, 3
	speed 7
	octave 1
	volume_envelope 13, 0
	note C_, 1
	note C#, 1
	inc_octave
	note D_, 1
	EndLoop
	EndMainLoop


Music_PauseMenu_Ch3:
	speed 1
	wave 3
	stereo_panning TRUE, TRUE
	volume_envelope 4, 0
	echo 96
	cutoff 4
	octave 4
	note G_, 7
	cutoff 8
	note F#, 4
	volume_envelope 6, 0
	note G_, 3
	volume_envelope 4, 0
	note D_, 4
	volume_envelope 6, 0
	note F#, 3
	dec_octave
	volume_envelope 4, 0
	note B_, 4
	inc_octave
	volume_envelope 6, 0
	note D_, 3
	MainLoop
	octave 4
	Loop 3
	volume_envelope 4, 0
	note G_, 4
	dec_octave
	volume_envelope 6, 0
	note B_, 3
	inc_octave
	volume_envelope 4, 0
	note F#, 4
	volume_envelope 6, 0
	note G_, 3
	volume_envelope 4, 0
	note D_, 4
	volume_envelope 6, 0
	note F#, 3
	dec_octave
	volume_envelope 4, 0
	note B_, 4
	inc_octave
	volume_envelope 6, 0
	note D_, 3
	EndLoop
	volume_envelope 4, 0
	note G_, 4
	dec_octave
	volume_envelope 6, 0
	note B_, 3
	inc_octave
	volume_envelope 4, 0
	note E_, 4
	volume_envelope 6, 0
	note G_, 3
	volume_envelope 4, 0
	note C_, 4
	volume_envelope 6, 0
	note E_, 3
	dec_octave
	volume_envelope 4, 0
	note A_, 4
	inc_octave
	volume_envelope 6, 0
	note C_, 3
	Loop 3
	volume_envelope 4, 0
	note G_, 4
	dec_octave
	volume_envelope 6, 0
	note A_, 3
	inc_octave
	volume_envelope 4, 0
	note E_, 4
	volume_envelope 6, 0
	note G_, 3
	volume_envelope 4, 0
	note C_, 4
	volume_envelope 6, 0
	note E_, 3
	dec_octave
	volume_envelope 4, 0
	note A_, 4
	inc_octave
	volume_envelope 6, 0
	note C_, 3
	EndLoop
	volume_envelope 4, 0
	note G_, 4
	dec_octave
	volume_envelope 6, 0
	note A_, 3
	inc_octave
	volume_envelope 4, 0
	note F#, 4
	volume_envelope 6, 0
	note G_, 3
	volume_envelope 4, 0
	note D_, 4
	volume_envelope 6, 0
	note F#, 3
	dec_octave
	volume_envelope 4, 0
	note B_, 4
	inc_octave
	volume_envelope 6, 0
	note D_, 3
	EndMainLoop


Music_PauseMenu_Ch4:
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
