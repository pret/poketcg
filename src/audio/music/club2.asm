Music_Club2_Ch1:
	speed 6
	duty 2
	stereo_panning TRUE, TRUE
	cutoff 8
	MainLoop
	octave 4
	Loop 8
	volume_envelope 7, 5
	note G_, 4
	note E_, 4
	note C_, 4
	volume_envelope 7, 7
	note F#, 4
	tie
	note F#, 16
	volume_envelope 7, 5
	note G_, 4
	note A_, 4
	note B_, 4
	volume_envelope 7, 7
	note F#, 4
	tie
	note F#, 16
	EndLoop
	volume_envelope 7, 5
	note G_, 4
	note D_, 4
	dec_octave
	note B_, 4
	inc_octave
	volume_envelope 7, 7
	note B_, 4
	tie
	note B_, 16
	volume_envelope 7, 5
	note G_, 4
	note D_, 4
	note C_, 4
	volume_envelope 7, 7
	note B_, 4
	tie
	note B_, 16
	dec_octave
	volume_envelope 7, 5
	note F#, 4
	dec_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	dec_octave
	note C_, 4
	dec_octave
	note C_, 4
	note E_, 4
	note G_, 4
	inc_octave
	note C_, 4
	note E_, 4
	note G_, 4
	inc_octave
	note C_, 4
	dec_octave
	note D_, 4
	dec_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note A_, 4
	note A_, 3
	tie
	speed 1
	note A_, 3
	inc_octave
	volume_envelope 7, 7
	rest 4
	note D_, 5
	tie
	speed 6
	note D_, 15
	tie
	note D_, 16
	EndMainLoop


Music_Club2_Ch2:
	speed 6
	duty 2
	stereo_panning TRUE, TRUE
	cutoff 8
	MainLoop
	octave 2
	Loop 8
	volume_envelope 7, 5
	note C_, 4
	note G_, 4
	inc_octave
	note G_, 4
	inc_octave
	volume_envelope 7, 7
	note D_, 4
	tie
	note D_, 16
	dec_octave
	dec_octave
	volume_envelope 7, 5
	note C_, 4
	note G_, 4
	inc_octave
	inc_octave
	note C_, 4
	volume_envelope 7, 7
	note D_, 4
	tie
	note D_, 16
	dec_octave
	dec_octave
	EndLoop
	dec_octave
	volume_envelope 7, 5
	note B_, 4
	inc_octave
	note G_, 4
	inc_octave
	note G_, 4
	inc_octave
	volume_envelope 7, 7
	note G_, 4
	tie
	note G_, 16
	dec_octave
	dec_octave
	dec_octave
	volume_envelope 7, 5
	note A_, 4
	inc_octave
	note A_, 4
	inc_octave
	note A_, 4
	inc_octave
	volume_envelope 7, 7
	note C_, 4
	tie
	note C_, 16
	dec_octave
	dec_octave
	volume_envelope 7, 5
	note D_, 4
	octave 2
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note G_, 4
	dec_octave
	dec_octave
	note E_, 4
	note G_, 4
	inc_octave
	note C_, 4
	note E_, 4
	note G_, 4
	inc_octave
	note C_, 4
	note E_, 4
	note F#, 4
	dec_octave
	dec_octave
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note F#, 4
	note A_, 4
	inc_octave
	note D_, 4
	note E_, 3
	tie
	speed 1
	note E_, 3
	dec_octave
	volume_envelope 7, 4
	note A_, 8
	inc_octave
	volume_envelope 7, 7
	note F#, 7
	tie
	speed 6
	note F#, 14
	tie
	note F#, 16
	EndMainLoop


Music_Club2_Ch3:
	speed 6
	volume_envelope 2, 0
	stereo_panning TRUE, TRUE
	wave 0
	vibrato_type 4
	vibrato_delay 35
	cutoff 6
	echo 64
	MainLoop
	volume_envelope 6, 0
	cutoff 8
	rest 2
	octave 4
	note G_, 4
	note E_, 4
	note C_, 4
	note F#, 2
	rest 2
	rest 16
	note G_, 4
	note A_, 4
	note B_, 4
	note F#, 2
	rest 2
	rest 14
	volume_envelope 4, 0
	echo 96
	music_call Branch_fa1cf
	octave 4
	cutoff 8
	note G_, 8
	music_call Branch_fa1cf
	echo 64
	volume_envelope 2, 0
	octave 3
	cutoff 8
	note G_, 8
	music_call Branch_fa1f3
	octave 3
	note G_, 16
	tie
	note G_, 12
	rest 16
	rest 8
	cutoff 8
	note E_, 8
	music_call Branch_fa1f3
	octave 3
	note G_, 16
	tie
	note G_, 12
	tie
	note G_, 16
	tie
	note G_, 8
	rest 4
	cutoff 8
	note A_, 2
	note G_, 2
	cutoff 6
	note F#, 16
	tie
	note F#, 12
	rest 4
	note F#, 1
	tie
	note G_, 15
	tie
	note G_, 12
	rest 4
	note G#, 1
	tie
	note A_, 15
	tie
	note A_, 16
	rest 16
	rest 16
	echo 96
	EndMainLoop

Branch_fa1cf:
	cutoff 6
	octave 5
	note C#, 1
	tie
	note D_, 15
	tie
	note D_, 12
	cutoff 8
	note C_, 2
	dec_octave
	note B_, 2
	cutoff 6
	note G_, 16
	tie
	note G_, 8
	rest 4
	cutoff 8
	note E_, 4
	note B_, 4
	inc_octave
	note C_, 4
	dec_octave
	note B_, 4
	cutoff 6
	note A_, 16
	tie
	note A_, 8
	tie
	note A_, 16
	rest 4
	music_ret

Branch_fa1f3:
	octave 4
	note C#, 1
	tie
	note D_, 15
	tie
	note D_, 4
	note E_, 4
	dec_octave
	note B_, 4
	inc_octave
	note C_, 4
	cutoff 6
	note D_, 16
	tie
	note D_, 8
	rest 4
	cutoff 8
	note C_, 2
	dec_octave
	note B_, 2
	inc_octave
	note C_, 2
	dec_octave
	note B_, 2
	cutoff 6
	music_ret
