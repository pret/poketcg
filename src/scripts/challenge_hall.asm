ChallengeHallAfterDuel:
	ld c, 0
	ld a, [wDuelResult]
	or a ; cp DUEL_WIN
	jr z, .won
	ld c, 2
.won
	ld b, 0
	ld hl, ChallengeHallAfterDuelTable
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, NPC_HOST
	ld [wTempNPC], a
	jp SetNextNPCAndScript

ChallengeHallAfterDuelTable:
	dw Script_WonAtChallengeHall
	dw Script_LostAtChallengeHall

ChallengeHallLoadMap:
	get_event_value EVENT_CHALLENGE_CUP_IN_MENU
	or a
	ret z
	ld a, NPC_HOST
	ld [wTempNPC], a
	call FindLoadedNPC
	ld bc, Script_f433
	jp SetNextNPCAndScript

Script_Clerk13:
	start_script
	print_text_quit_fully Clerk13Text

Preload_Guide:
	get_event_value EVENT_CHALLENGE_CUP_STARTING
	or a
	jr z, .asm_f281
	ld a, $1c
	ld [wLoadNPCXPos], a
	ld a, $02
	ld [wLoadNPCYPos], a
.asm_f281
	scf
	ret

Script_Guide:
	start_script
	jump_if_event_false EVENT_CHALLENGE_CUP_STARTING, .ows_f28b
	print_text_quit_fully GuideChallengeCupActiveText

.ows_f28b
	jump_if_event_zero EVENT_CHALLENGE_CUP_1_STATE, .ows_f292
	print_text_quit_fully GuideChallengeCupOverText

.ows_f292
	print_text_quit_fully GuideChallengeCupPreparingText

Script_Clerk12:
	start_script
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_LOST, .ows_f2c4
	jump_if_event_equal EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_WON, .ows_f2c1
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_LOST, .ows_f2c4
	jump_if_event_equal EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_WON, .ows_f2c1
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_LOST, .ows_f2c4
	jump_if_event_equal EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_WON, .ows_f2c1
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 2, .ows_f2cd
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f2d3
	script_jump .ows_f2c7

.ows_f2c1
	print_text_quit_fully Clerk12ChallengeCupWonText

.ows_f2c4
	print_text_quit_fully Clerk12ChallengeCupLostText

.ows_f2c7
	print_npc_text Clerk12ChallengeCup1ActiveText
	script_jump .ows_f2d6

.ows_f2cd
	print_npc_text Clerk12ChallengeCup2ActiveText
	script_jump .ows_f2d6

.ows_f2d3
	print_npc_text Clerk12ChallengeCup3ActiveText
.ows_f2d6
	print_npc_text Clerk12ChallengeCupInviteText
	ask_question_jump Clerk12WillYouEnterText, .ows_f2e1
	print_text_quit_fully Clerk12DeclinedText

.ows_f2e1
	max_out_event_value EVENT_PLAYER_ENTERED_CHALLENGE_CUP
	print_npc_text Clerk12AcceptedText
	close_text_box
	move_active_npc NPCMovement_f349
	jump_if_player_coords_match 8, 18, .ows_f2fa
	jump_if_player_coords_match 12, 18, .ows_f302
	move_player NORTH, 2
	script_jump .ows_f307

.ows_f2fa
	set_player_direction EAST
	move_player EAST, 2
	script_jump .ows_f307

.ows_f302
	set_player_direction WEST
	move_player WEST, 2
.ows_f307
	set_player_direction NORTH
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	jump_if_event_true EVENT_CHALLENGE_CUP_STAGE_VISITED, .ows_f33a
	max_out_event_value EVENT_CHALLENGE_CUP_STAGE_VISITED
	move_player NORTH, 1
	move_player NORTH, 1
	set_player_direction EAST
	do_frames 30
	set_player_direction SOUTH
	do_frames 20
	set_player_direction EAST
	do_frames 20
	set_player_direction SOUTH
	do_frames 30
	move_player SOUTH, 1
	move_player SOUTH, 1
.ows_f33a
	set_player_direction EAST
	move_player EAST, 1
	move_active_npc NPCMovement_f34e
	close_advanced_text_box
	set_next_npc_and_script NPC_HOST, Script_f353
	end_script
	ret

NPCMovement_f349:
	db NORTH
	db NORTH
	db EAST
NPCMovement_f34c:
	db WEST | NO_MOVE
	db $ff

NPCMovement_f34e:
	db WEST
	db SOUTH
	db SOUTH
	db $ff

Script_Host:
	ret

Script_f353:
	start_script
	do_frames 20
	move_active_npc NPCMovement_f37d
	do_frames 20
	move_active_npc NPCMovement_f390
	load_challenge_hall_npc_into_txram_slot 0
	print_npc_text Clerk12ChallengeCupIntroText
	close_text_box
	move_active_npc NPCMovement_f37f
	print_npc_text Clerk12ChallengeCupContenderText
	close_text_box
	move_active_npc NPCMovement_f388
	print_npc_text Clerk12ChallengeCupRound1ChallengerText
	close_text_box
	move_active_npc NPCMovement_f38e
	print_npc_text Clerk12ChallengeCupRound1DuelStartText
	start_challenge_hall_duel PRIZES_4, SAMS_PRACTICE_DECK_ID, MUSIC_STOP
	quit_script_fully

NPCMovement_f37d:
	db EAST | NO_MOVE
	db $ff

NPCMovement_f37f:
	db EAST
	db EAST
	db SOUTH
	db $ff

NPCMovement_f383:
	db NORTH
	db WEST
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_f388:
	db NORTH
	db WEST
	db WEST
NPCMovement_f38b:
	db WEST
	db SOUTH
	db $ff

NPCMovement_f38e:
	db NORTH
	db EAST
NPCMovement_f390:
	db SOUTH | NO_MOVE
	db $ff

Script_LostAtChallengeHall:
	start_script
	do_frames 20
	move_active_npc NPCMovement_f37d
	do_frames 20
	move_active_npc NPCMovement_f390
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2, Script_f410
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 3, Script_f410.ows_f41a
	load_challenge_hall_npc_into_txram_slot 0
	load_challenge_hall_npc_into_txram_slot 1
	print_npc_text Clerk12ChallengeCupRound2PlayerLostText
.ows_f3ae
	close_text_box
	move_active_npc NPCMovement_f38b
	print_npc_text Clerk12ChallengeCupLostContinuedText
	close_text_box
	move_active_npc NPCMovement_f38e
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 2, .ows_f3ce
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f3d9
	set_event EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_LOST
	set_event EVENT_CHALLENGE_CUP_1_RESULT, CHALLENGE_CUP_LOST
	zero_out_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_2
	script_jump .ows_f3e2

.ows_f3ce
	set_event EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_LOST
	set_event EVENT_CHALLENGE_CUP_2_RESULT, CHALLENGE_CUP_LOST
	zero_out_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_6
	script_jump .ows_f3e2

.ows_f3d9
	set_event EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_LOST
	set_event EVENT_CHALLENGE_CUP_3_RESULT, CHALLENGE_CUP_LOST
	script_jump .ows_f3e2

.ows_f3e2
	close_advanced_text_box
	set_next_npc_and_script NPC_CLERK12, Script_f3e9
	end_script
	ret

Script_f3e9:
	start_script
	move_active_npc NPCMovement_f40a
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_active_npc NPCMovement_f40d
	quit_script_fully

NPCMovement_f40a:
	db WEST
	db EAST | NO_MOVE
	db $ff

NPCMovement_f40d:
	db EAST
	db SOUTH | NO_MOVE
	db $ff

Script_f410:
	load_challenge_hall_npc_into_txram_slot 0
	load_challenge_hall_npc_into_txram_slot 1
	print_npc_text Clerk12ChallengeCupRound1PlayerLostText
	script_jump Script_LostAtChallengeHall.ows_f3ae

.ows_f41a
	print_npc_text Clerk12ChallengeCupPlayerLostToRonaldText
	set_dialog_npc NPC_RONALD1
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f42e
	test_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 1
	print_variable_npc_text RonaldChallengeCup2Or3PlayerLostText, RonaldChallengeCup1PlayerLostText
.ows_f42e
	set_dialog_npc NPC_HOST
	script_jump Script_LostAtChallengeHall.ows_f3ae

Script_f433:
	start_script
	do_frames 20
	move_active_npc NPCMovement_f37d
	do_frames 20
	move_active_npc NPCMovement_f390
	script_jump Script_WonAtChallengeHall.ows_f4a4

Script_WonAtChallengeHall:
	start_script
	do_frames 20
	move_active_npc NPCMovement_f37d
	do_frames 20
	move_active_npc NPCMovement_f390
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 3, Script_f4db
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2, .ows_f456
.ows_f456
	test_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 1
	print_variable_npc_text Clerk12ChallengeCupRound1PlayerWonText, Clerk12ChallengeCupRound2PlayerWonText
	move_active_npc NPCMovement_f37f
	load_challenge_hall_npc_into_txram_slot 0
	print_npc_text Clerk12ChallengeCupPlayerWonContinuedText
	close_text_box
	move_challenge_hall_npc NPCMovement_f4c8
	unload_challenge_hall_npc
	print_npc_text Clerk12ChallengeCupNextChallengerText
	close_text_box
	pick_challenge_hall_opponent
	set_challenge_hall_npc_coords 20, 20
	move_challenge_hall_npc NPCMovement_f4d0
	load_challenge_hall_npc_into_txram_slot 0
	test_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2
	print_variable_npc_text Clerk12ChallengeCupRound2ChallengerText, Clerk12ChallengeCupRound3ChallengerText
	move_active_npc NPCMovement_f383
	jump_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2, .ows_f4a4
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f4a1
	close_text_box
	set_dialog_npc NPC_RONALD1
	test_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 1
	print_variable_npc_text RonaldChallengeCup2BeforeDuelText, RonaldChallengeCup1BeforeDuelText
	set_dialog_npc NPC_HOST
	close_text_box
.ows_f4a1
	print_npc_text Clerk12ChallengeCupRound3DuelReadyText
.ows_f4a4
	zero_out_event_value EVENT_CHALLENGE_CUP_IN_MENU
	print_npc_text Clerk12AreYourDecksReadyText
	ask_question_jump_default_yes Clerk12PrepareYourDeckText, .ows_f4bd
	test_if_event_equal EVENT_CHALLENGE_CUP_OPPONENT_NUMBER, 2
	print_variable_npc_text Clerk12ChallengeCupRound2DuelStartText, Clerk12ChallengeCupRound3DuelStartText
	start_challenge_hall_duel PRIZES_4, SAMS_PRACTICE_DECK_ID, MUSIC_STOP
	quit_script_fully

.ows_f4bd
	print_npc_text Clerk12MakeYourPreparationsText
	close_text_box
	max_out_event_value EVENT_CHALLENGE_CUP_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_f4a4

NPCMovement_f4c8:
	db EAST
NPCMovement_f4c9:
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

NPCMovement_f4d0:
	db NORTH
	db NORTH
	db NORTH
	db NORTH
	db NORTH
	db NORTH
	db WEST
	db $ff

NPCMovement_f4d8:
	db EAST
	db SOUTH | NO_MOVE
	db $ff

Script_f4db:
	print_npc_text Clerk12ChallengeCupRound3PlayerWon1Text
	move_active_npc NPCMovement_f37f
	load_challenge_hall_npc_into_txram_slot 0
	print_npc_text Clerk12ChallengeCupRound3PlayerWon2Text
	close_text_box
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f513
	set_dialog_npc NPC_RONALD1
	test_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 1
	print_variable_npc_text RonaldChallengeCup1PlayerWon1Text, RonaldChallengeCup2Or3PlayerWon1Text
	move_challenge_hall_npc NPCMovement_f4d8
	do_frames 40
	move_challenge_hall_npc NPCMovement_f34c
	test_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 1
	print_variable_npc_text RonaldChallengeCup1PlayerWon2Text, RonaldChallengeCup2Or3PlayerWon2Text
	set_dialog_npc NPC_HOST
	close_text_box
	move_challenge_hall_npc NPCMovement_f4c9
	script_jump .ows_f516

.ows_f513
	move_challenge_hall_npc NPCMovement_f4c8
.ows_f516
	unload_challenge_hall_npc
	move_active_npc NPCMovement_f383
	print_npc_text Clerk12ChallengeCupRound3PlayerWon3Text
	close_text_box
	move_active_npc NPCMovement_f38b
	pick_challenge_cup_prize_card
	print_npc_text Clerk12ChallengeCupRound3PlayerWon4Text
	give_card VARIABLE_CARD
	show_card_received_screen VARIABLE_CARD
	print_npc_text Clerk12ChallengeCupRound3PlayerWon5Text
	close_text_box
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 2, .ows_f540
	jump_if_event_equal EVENT_CHALLENGE_CUP_NUMBER, 3, .ows_f549
	set_event EVENT_CHALLENGE_CUP_1_STATE, CHALLENGE_CUP_WON
	set_event EVENT_CHALLENGE_CUP_1_RESULT, CHALLENGE_CUP_WON
	script_jump .ows_f552

.ows_f540
	set_event EVENT_CHALLENGE_CUP_2_STATE, CHALLENGE_CUP_WON
	set_event EVENT_CHALLENGE_CUP_2_RESULT, CHALLENGE_CUP_WON
	script_jump .ows_f552

.ows_f549
	set_event EVENT_CHALLENGE_CUP_3_STATE, CHALLENGE_CUP_WON
	set_event EVENT_CHALLENGE_CUP_3_RESULT, CHALLENGE_CUP_WON
	script_jump .ows_f552

.ows_f552
	close_advanced_text_box
	set_next_npc_and_script NPC_CLERK12, Script_f3e9
	end_script
	ret

; Loads the NPC to fight at the challenge hall
Preload_ChallengeHallOpponent:
	get_event_value EVENT_CHALLENGE_CUP_STARTING
	or a
	ret z
	get_event_value EVENT_CHALLENGE_CUP_OPPONENT_CHOSEN
	or a
	jr z, .asm_f56e
	ld a, [wChallengeHallNPC]
	ld [wTempNPC], a
	scf
	ret

.asm_f56e
	call Func_f5db
	ld c, 1
	set_event_value EVENT_CHALLENGE_CUP_OPPONENT_NUMBER
	call Func_f580
	max_event_value EVENT_CHALLENGE_CUP_OPPONENT_CHOSEN
	scf
	ret

Func_f580:
	get_event_value EVENT_CHALLENGE_CUP_NUMBER
	cp 3
	jr z, .pick_challenger_include_ronald
	get_event_value EVENT_CHALLENGE_CUP_OPPONENT_NUMBER
	cp 3
	ld d, ChallengeHallNPCs.end - ChallengeHallNPCs - 1 ; discount Ronald
	jr nz, .pick_challenger
	ld a, NPC_RONALD1
	jr .force_ronald

.pick_challenger_include_ronald
	ld d, ChallengeHallNPCs.end - ChallengeHallNPCs

.pick_challenger
	ld a, d
	call Random
	ld c, a
	call Func_f5cc
	jr c, .pick_challenger
	call Func_f5d4
	ld b, 0
	ld hl, ChallengeHallNPCs
	add hl, bc
	ld a, [hl]

.force_ronald
	ld [wTempNPC], a
	ld [wChallengeHallNPC], a
	ret

ChallengeHallNPCs:
	db NPC_CHRIS
	db NPC_MICHAEL
	db NPC_JESSICA
	db NPC_MATTHEW
	db NPC_RYAN
	db NPC_ANDREW
	db NPC_SARA
	db NPC_AMANDA
	db NPC_JOSHUA
	db NPC_JENNIFER
	db NPC_NICHOLAS
	db NPC_BRANDON
	db NPC_BRITTANY
	db NPC_KRISTIN
	db NPC_HEATHER
	db NPC_ROBERT
	db NPC_DANIEL
	db NPC_STEPHANIE
	db NPC_JOSEPH
	db NPC_DAVID
	db NPC_ERIK
	db NPC_JOHN
	db NPC_ADAM
	db NPC_JONATHAN
	db NPC_RONALD1
.end

Func_f5cc:
	call Func_f5e9
	ld a, [hl]
	and b
	ret z
	scf
	ret

Func_f5d4:
	call Func_f5e9
	ld a, [hl]
	or b
	ld [hl], a
	ret

Func_f5db:
	xor a
	ld [wd698 + 0], a
	ld [wd698 + 1], a
	ld [wd698 + 2], a
	ld [wd698 + 3], a
	ret

Func_f5e9:
	ld hl, wd698
	ld a, c
.asm_f5ed
	cp $08
	jr c, .asm_f5f6
	sub $08
	inc hl
	jr .asm_f5ed
.asm_f5f6
	ld b, $80
	jr .asm_f5fd
.asm_f5fa
	srl b
	dec a
.asm_f5fd
	cp $00
	jr nz, .asm_f5fa
	ret

Func_f602:
	set_event_false EVENT_CHALLENGE_CUP_OPPONENT_CHOSEN
	ret
