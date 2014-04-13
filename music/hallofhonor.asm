Music_HallOfHonor_Ch1: ; fafea (3e:6fea)
	Speed 7
	musicdc 17
	musice8 8
	musice5 128
	Loop 4
	music_call Branch_fb016
	EndLoop
	MainLoop
	Loop 8
	music_call Branch_fb016
	EndLoop
	musicdx 4
	musice6 85
	note C_, 1
	musice6 39
	note C_, 1
	music_call Branch_fb044
	Loop 23
	musice6 85
	note C_, 1
	musice6 39
	note G_, 1
	music_call Branch_fb044
	EndLoop
	EndMainLoop

Branch_fb016:
	musicdx 4
	musice6 101
	note C_, 1
	musice6 39
	note C_, 1
	musice6 101
	note F_, 1
	musice6 39
	note F_, 1
	musice6 101
	note G_, 1
	musice6 39
	note G_, 1
	musice6 101
	note F_, 1
	musice6 39
	note F_, 1
	musicd7
	musice6 101
	note C_, 1
	musice6 39
	note C_, 1
	musicd8
	musice6 101
	note F_, 1
	musice6 39
	note F_, 1
	musice6 101
	note G_, 1
	musice6 39
	note G_, 1
	music_ret

Branch_fb044:
	musicdx 4
	musice6 85
	note F_, 1
	musice6 39
	note C_, 1
	musice6 85
	note G_, 1
	musice6 39
	note F_, 1
	musice6 85
	note F_, 1
	musice6 39
	note G_, 1
	musicd7
	musice6 85
	note C_, 1
	musicd8
	musice6 39
	note F_, 1
	musice6 85
	note F_, 1
	musicd7
	musice6 39
	note C_, 1
	musicd8
	musice6 85
	note G_, 1
	musice6 39
	note F_, 1
	music_ret


Music_HallOfHonor_Ch2: ; fb06e (3e:706e)
	Speed 7
	musicdc 17
	musice8 8
	musice5 128
	musice4 255
	rest 2
	Speed 1
	rest 4
	Speed 7
	musice6 23
	Loop 3
	music_call Branch_fb1ec
	EndLoop
	musicdx 4
	note C_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	musicd7
	note C_, 1
	rest 1
	musicd8
	note F_, 1
	Speed 1
	rest 3
	Speed 7
	musice4 0
	MainLoop
	musicdx 1
	musice5 64
	Loop 3
	music_call Branch_fb0bb
	musicdx 1
	musice6 109
	note E_, 5
	musice6 208
	note E_, 11
	musicd9
	note E_, 12
	EndLoop
	music_call Branch_fb0bb
	musicdx 1
	musice6 109
	note G_, 5
	musice6 208
	note G_, 11
	musicd9
	note G_, 12
	EndMainLoop

Branch_fb0bb:
	musicdx 1
	musice6 109
	note F_, 5
	musice6 208
	note F_, 11
	musicd9
	note F_, 12
	musice6 109
	note E_, 5
	musice6 208
	note E_, 11
	musicd9
	note E_, 12
	musice6 109
	note D_, 5
	musice6 208
	note D_, 11
	musicd9
	note D_, 12
	music_ret


Music_HallOfHonor_Ch3: ; fb0d5 (3e:70d5)
	Speed 7
	musice6 64
	musicdc 17
	musice7 2
	musicea 4
	musiceb 35
	musice8 6
	musice9 64
	rest 3
	musice6 96
	musice8 8
	musice4 255
	Loop 4
	rest 14
	EndLoop
	MainLoop
	musicdx 5
	Loop 7
	music_call Branch_fb1ec
	EndLoop
	note C_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	musicd7
	note C_, 1
	rest 1
	musicd8
	note F_, 1
	musice6 32
	musice4 0
	musicdx 4
	Speed 1
	musice8 6
	note B_, 3
	musicd7
	note C_, 4
	musicd9
	Speed 7
	note C_, 15
	musicd9
	note C_, 8
	musicd8
	musice8 8
	note B_, 2
	musice8 4
	note A_, 2
	musice8 6
	note G_, 6
	note C_, 10
	musicd9
	note C_, 12
	Speed 1
	musice8 8
	note B_, 3
	musicd7
	musice8 6
	note C_, 4
	musicd9
	Speed 7
	note C_, 15
	musicd9
	note C_, 6
	musicd8
	musice8 8
	note B_, 2
	musicd7
	note C_, 2
	musice8 4
	note D_, 2
	musicd8
	Speed 1
	musice8 8
	note F#, 3
	musice8 6
	note G_, 4
	musicd9
	Speed 7
	note G_, 15
	musicd9
	note G_, 6
	musice8 8
	note G_, 2
	note A_, 2
	musice8 4
	note B_, 2
	Speed 1
	musice8 8
	note B_, 3
	musicd7
	note C_, 4
	musicd9
	Speed 7
	note C_, 15
	musicd9
	note C_, 8
	musicd8
	note B_, 2
	musice8 4
	note A_, 2
	musice8 6
	note G_, 6
	musice8 8
	Speed 1
	note B_, 3
	musicd7
	musice8 6
	note C_, 4
	musicd9
	Speed 7
	note C_, 9
	musicd9
	note C_, 6
	musicd8
	musice8 8
	note G_, 2
	musicd7
	note C_, 2
	musice8 4
	note E_, 2
	Speed 1
	musice8 8
	note E_, 3
	note F_, 4
	musicd9
	Speed 7
	note F_, 1
	note E_, 2
	musice8 4
	note C_, 2
	musice8 7
	note C_, 10
	musicd9
	note C_, 10
	musice8 4
	note E_, 2
	Speed 1
	musice8 8
	note E_, 3
	note F_, 4
	musicd9
	Speed 7
	note F_, 1
	note E_, 2
	musice8 4
	note C_, 2
	musice8 6
	note C_, 10
	musicd9
	note C_, 12
	Speed 1
	musice8 8
	note F#, 3
	musice8 7
	note G_, 4
	musicd9
	Speed 7
	note G_, 15
	musicd9
	note G_, 8
	musice8 8
	note F_, 2
	musice8 4
	note E_, 2
	musice8 8
	note F_, 2
	musice8 4
	note E_, 2
	note C_, 2
	musicd8
	musice8 7
	note G_, 10
	musicd9
	note G_, 10
	musice8 8
	note E_, 2
	note F_, 2
	musicd7
	musice8 4
	note C_, 2
	musice8 7
	note C_, 12
	musicd9
	note C_, 10
	musicd8
	musice8 8
	note E_, 2
	note F_, 2
	musicd7
	musice8 4
	note C_, 2
	musice8 6
	note C_, 12
	musicd9
	note C_, 12
	rest 3
	musice6 96
	musice4 255
	musice8 8
	EndMainLoop

Branch_fb1ec:
	musicdx 4
	note C_, 1
	rest 1
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	note F_, 1
	rest 1
	musicd7
	note C_, 1
	rest 1
	musicd8
	note F_, 1
	rest 1
	note G_, 1
	rest 1
	music_ret
; 0xfb1fe