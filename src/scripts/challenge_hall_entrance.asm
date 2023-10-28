Preload_Clerk9:
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	ld hl, .jump_table
	cp 9
	jp c, JumpToFunctionInTable
	debug_nop
	jr .less_than_three_medals

.jump_table
	dw .less_than_three_medals
	dw .less_than_three_medals
	dw .less_than_three_medals
	dw .three_medals
	dw .four_medals
	dw .five_medals
	dw .more_than_five_medals
	dw .more_than_five_medals
	dw .more_than_five_medals

.three_medals
	get_event_value EVENT_CHALLENGE_CUP_1_STATE
	or a ; cp CHALLENGE_CUP_NOT_STARTED
	jr nz, .less_than_three_medals
	ld c, CHALLENGE_CUP_READY_TO_START
	set_event_value EVENT_CHALLENGE_CUP_1_STATE
	jr .less_than_three_medals

.five_medals
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	or a ; cp CHALLENGE_CUP_NOT_STARTED
	jr nz, .four_medals
	ld c, CHALLENGE_CUP_READY_TO_START
	set_event_value EVENT_CHALLENGE_CUP_2_STATE
	jr .four_medals

.more_than_five_medals
	ld c, CHALLENGE_CUP_OVER
	set_event_value EVENT_CHALLENGE_CUP_2_STATE
.four_medals
	ld c, CHALLENGE_CUP_OVER
	set_event_value EVENT_CHALLENGE_CUP_1_STATE
.less_than_three_medals
	set_event_false EVENT_CHALLENGE_CUP_STARTING
	get_event_value EVENT_CHALLENGE_CUP_1_STATE
	cp CHALLENGE_CUP_NOT_STARTED
	jr z, .check_challenge_cup_two
	cp CHALLENGE_CUP_OVER
	jr z, .check_challenge_cup_two
	ld c, 1
	jr .start_challenge_cup

.check_challenge_cup_two
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	cp CHALLENGE_CUP_NOT_STARTED
	jr z, .check_challenge_cup_three
	cp CHALLENGE_CUP_OVER
	jr z, .check_challenge_cup_three
	ld c, 2
	jr .start_challenge_cup

.check_challenge_cup_three
	get_event_value EVENT_CHALLENGE_CUP_3_STATE
	cp CHALLENGE_CUP_NOT_STARTED
	jr z, .no_challenge_cup
	cp CHALLENGE_CUP_OVER
	jr z, .no_challenge_cup
	ld c, 3
.start_challenge_cup
	set_event_value EVENT_CHALLENGE_CUP_NUMBER
	max_event_value EVENT_CHALLENGE_CUP_STARTING
	ld a, MUSIC_CHALLENGE_HALL
	ld [wDefaultSong], a
.no_challenge_cup
	scf
	ret

Script_Clerk9:
	start_script
	jump_if_event_zero EVENT_CHALLENGE_CUP_1_STATE, .ows_f066
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_OVER, .ows_f069
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_LOST, .ows_f06f
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_WON, .ows_f072
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_READY_TO_START, .ows_f06c
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_OVER, .ows_f069
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_LOST, .ows_f06f
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_WON, .ows_f072
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_READY_TO_START, .ows_f06c
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_OVER, .ows_f069
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_LOST, .ows_f06f
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_WON, .ows_f072
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_READY_TO_START, .ows_f06c
.ows_f066
	print_text_quit_fully Clerk9DefaultText

.ows_f069
	print_text_quit_fully Clerk9ChallengeCupOverText

.ows_f06c
	print_text_quit_fully Clerk9ChallengeCupReadyText

.ows_f06f
	print_text_quit_fully Clerk9ChallengeCupLostText

.ows_f072
	print_text_quit_fully Clerk9ChallengeCupWonText
