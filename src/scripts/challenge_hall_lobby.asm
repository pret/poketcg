Preload_ChallengeHallNPCs2: ; Challenge Cup Inactive
	call Preload_ChallengeHallNPCs1
	ccf
	ret

Preload_ChallengeHallNPCs1: ; Challenge Cup Active
	get_event_value EVENT_CHALLENGE_CUP_STARTING
	or a
	jr z, .quit
	ld a, MUSIC_CHALLENGE_HALL
	ld [wDefaultSong], a
	scf
.quit
	ret

ChallengeHallLobbyLoadMap:
	get_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE
	or a
	ret z
	ld a, NPC_RONALD1
	ld [wTempNPC], a
	call FindLoadedNPC
	ld bc, Script_f166
	jp SetNextNPCAndScript

Script_Pappy3: ; Preload_ChallengeHallNPCs1
	start_script
	print_text_quit_fully Pappy3Text

Script_Gal4: ; Preload_ChallengeHallNPCs1
	start_script
	print_text_quit_fully Gal4Text

Script_Champ: ; Preload_ChallengeHallNPCs1
	start_script
	print_text_quit_fully ChampText

Script_Hood2: ; Preload_ChallengeHallNPCs1
	start_script
	print_text_quit_fully Hood2Text

Script_Lass5: ; Preload_ChallengeHallNPCs2
	start_script
	print_text_quit_fully Lass5Text

Script_Chap5: ; Preload_ChallengeHallNPCs2
	start_script
	print_text_quit_fully Chap5Text

Preload_ChallengeHallLobbyRonald1:
	set_event_zero EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	jr nz, .challenge_cup_2_ended
	get_event_value EVENT_PLAYER_ENTERED_CHALLENGE_CUP
	or a
	jr nz, .dont_load
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	cp CHALLENGE_CUP_NOT_STARTED
	jr z, .check_challenge_cup_1
	call .challenge_cup_1_ended
	get_event_value EVENT_CHALLENGE_CUP_2_STATE
	ld e, a
	get_event_value EVENT_CHALLENGE_CUP_2_RESULT
	ld d, a
	ld hl, RonaldChallengeHallLobbyCup2States
	call SetRonaldChallengeHallLobbyState
	jr nc, .dont_load
	jr .load_ronald

.check_challenge_cup_1
	get_event_value EVENT_CHALLENGE_CUP_1_STATE
	ld e, a
	get_event_value EVENT_CHALLENGE_CUP_1_RESULT
	ld d, a
	ld hl, RonaldChallengeHallLobbyCup1States
	call SetRonaldChallengeHallLobbyState
	jr nc, .dont_load
.load_ronald
	ld a, [wPlayerYCoord]
	ld [wLoadNPCYPos], a
	scf
	ret

.challenge_cup_2_ended
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_5
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_6
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_7
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_8
.challenge_cup_1_ended
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_1
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_2
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_3
	max_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_4
.dont_load
	or a
	ret

SetRonaldChallengeHallLobbyState:
	ld c, 4
.loop
	ld a, [hli]
	cp e
	jr nz, .next_inc
	ld a, [hli]
	cp d
	jr nz, .next
	ld a, [hl]
	call GetEventValue
	or a
	jr nz, .next
	ld a, [hl]
	call MaxOutEventValue
	inc hl
	ld c, [hl]
	set_event_value EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE
	scf
	ret

.next_inc
	inc hl
.next
	inc hl
	inc hl
	dec c
	jr nz, .loop
	or a
	ret

; format: cup state, cup result, convo event, convo number
; if the current cup state/result match a row in the table
; and the convo has not already occurred,
;   then load the corresponding conversation
RonaldChallengeHallLobbyCup1States:
	db CHALLENGE_CUP_READY_TO_START, CHALLENGE_CUP_NOT_STARTED, EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_1, 1
	db CHALLENGE_CUP_LOST,           CHALLENGE_CUP_LOST,        EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_2, 2
	db CHALLENGE_CUP_OVER,           CHALLENGE_CUP_LOST,        EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_3, 3
	db CHALLENGE_CUP_OVER,           CHALLENGE_CUP_NOT_STARTED, EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_4, 4

RonaldChallengeHallLobbyCup2States:
	db CHALLENGE_CUP_READY_TO_START, CHALLENGE_CUP_NOT_STARTED, EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_5, 5
	db CHALLENGE_CUP_LOST,           CHALLENGE_CUP_LOST,        EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_6, 6
	db CHALLENGE_CUP_OVER,           CHALLENGE_CUP_LOST,        EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_7, 7
	db CHALLENGE_CUP_OVER,           CHALLENGE_CUP_NOT_STARTED, EVENT_RONALD_CHALLENGE_HALL_LOBBY_CONVO_8, 8

Script_f166:
	start_script
	move_active_npc NPCMovement_f232
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 1, .ows_f192
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 2, .ows_f1a5
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 3, .ows_f1b8
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 4, .ows_f1cb
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 5, .ows_f1de
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 6, .ows_f1f1
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 7, .ows_f204
	jump_if_event_equal EVENT_RONALD_CHALLENGE_HALL_LOBBY_STATE, 8, .ows_f217
.ows_f192
	print_npc_text RonaldChallengeCup1NotStarted1Text
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text RonaldChallengeCup1NotStarted2Text
	script_jump .ows_f227

.ows_f1a5
	print_npc_text RonaldChallengeCup1LostActive1Text
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text RonaldChallengeCup1LostActive2Text
	script_jump .ows_f227

.ows_f1b8
	print_npc_text RonaldChallengeCup1LostInactive1Text
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text RonaldChallengeCup1LostInactive2Text
	script_jump .ows_f227

.ows_f1cb
	print_npc_text RonaldChallengeCup1Missed1Text
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text RonaldChallengeCup1Missed2Text
	script_jump .ows_f227

.ows_f1de
	print_npc_text RonaldChallengeCup2NotStarted1Text
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text RonaldChallengeCup2NotStarted2Text
	script_jump .ows_f227

.ows_f1f1
	print_npc_text RonaldChallengeCup2LostActive1Text
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text RonaldChallengeCup2LostActive2Text
	script_jump .ows_f227

.ows_f204
	print_npc_text RonaldChallengeCup2LostInactive1Text
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text RonaldChallengeCup2LostInactive2Text
	script_jump .ows_f227

.ows_f217
	print_npc_text RonaldChallengeCup2Missed1Text
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	move_player WEST, 1
	print_npc_text RonaldChallengeCup2Missed2Text
.ows_f227
	close_text_box
	set_player_direction SOUTH
	move_player NORTH, 4
	move_active_npc NPCMovement_f232
	unload_active_npc
	quit_script_fully

NPCMovement_f232:
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db EAST
	db $ff
