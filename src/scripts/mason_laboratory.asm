Script_BeginGame:
	start_script
	do_frames 60
	walk_player_to_mason_lab
	do_frames 120
	enter_map $02, MASON_LABORATORY, 14, 26, NORTH
	quit_script_fully

MasonLaboratoryAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_SAM
	db NPC_SAM
	dw Script_BeatSam
	dw Script_LostToSam
	db $00

MasonLabLoadMap:
	get_event_value EVENT_MASON_LAB_STATE
	cp MASON_LAB_RECEIVED_STARTER_DECK
	ret nc
	ld a, NPC_DRMASON
	ld [wTempNPC], a
	call FindLoadedNPC
	ld bc, Script_EnterLabFirstTime
	jp SetNextNPCAndScript

MasonLabCloseTextBox:
	ld a, MAP_EVENT_CHALLENGE_MACHINE
	farcall Func_80b89
	ret

; Lets you access the Challenge Machine if available
MasonLabPressedA:
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	ret z
	ld hl, ChallengeMachineObjectTable
	call FindExtraInteractableObjects
	ret

ChallengeMachineObjectTable:
	db 10, 4, NORTH
	dw Script_ChallengeMachine
	db 12, 4, NORTH
	dw Script_ChallengeMachine
	db $00

Script_ChallengeMachine:
	start_script
	print_text ItsTheChallengeMachineText
	challenge_machine
	quit_script_fully

Script_Tech1:
	lb bc, 0, EnergyCardList.end - EnergyCardList
	ld hl, EnergyCardList
.count_loop
	ld a, [hli]
	call GetCardCountInCollection
	add b
	ld b, a
	dec c
	jr nz, .count_loop
	ld a, b
	cp 10
	jr c, .low_on_energies

	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech1MasterMedalExplanationText, Tech1AutoDeckMachineExplanationText
	quit_script_fully

.low_on_energies
	ld c, EnergyCardList.end - EnergyCardList
	ld hl, EnergyCardList
.next_energy_card
	ld b, 10
	ld a, [hli]
.add_loop
	push af
	call AddCardToCollection
	pop af
	dec b
	jr nz, .add_loop
	dec c
	jr nz, .next_energy_card

	start_script
	print_npc_text Tech1FewEnergyCardsText
	pause_song
	play_song MUSIC_BOOSTER_PACK
	print_npc_text Tech1ReceivedEnergyCardsText
	wait_for_song_to_finish
	resume_song
	print_text_quit_fully Tech1GoodbyeText

EnergyCardList:
	db GRASS_ENERGY
	db FIRE_ENERGY
	db WATER_ENERGY
	db LIGHTNING_ENERGY
	db FIGHTING_ENERGY
	db PSYCHIC_ENERGY
.end

Script_Tech2:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech2LegendaryCardsExplanationText, Tech2LegendaryCardsCongratsText
	quit_script_fully

Script_Tech3:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech3BoosterPackExplanationText, Tech3LegendaryCardsCongratsText
	quit_script_fully

Script_Tech4:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech4ClubsExplanationText, Tech4DefeatedTheGrandMastersText
	quit_script_fully

Preload_Tech5:
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	jr z, .skip
	ld hl, wLoadNPCXPos
	inc [hl]
	inc [hl]
.skip
	scf
	ret

Script_Tech5:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Tech5DiaryAndEmailExplanationText, Tech5ChallengeMachineExplanationText
	quit_script_fully

Preload_Sam:
	get_event_value EVENT_MASON_LAB_STATE
	cp MASON_LAB_IN_PRACTICE_DUEL
	jr nc, .sam_at_table
	ld a, $0a
	ld [wLoadNPCXPos], a
	ld a, $08
	ld [wLoadNPCYPos], a
	ld a, SOUTH
	ld [wLoadNPCDirection], a
.sam_at_table
	scf
	ret

Script_Sam:
	start_script
	show_sam_normal_multichoice
	close_text_box
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NORMAL_DUEL, .ows_d63b
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_RULES, Script_LostToSam.ows_d6b0
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NOTHING, .ows_d637
; SAM_MENU_PRACTICE_DUEL
	print_npc_text Text05cb
	ask_question_jump Text05cc, .ows_d647
.ows_d637
	print_npc_text Text05cd
	quit_script_fully

.ows_d63b
	print_npc_text Text05ce
	ask_question_jump Text05cf, .ows_d647
	print_npc_text Text05d0
	quit_script_fully

.ows_d647
	close_text_box
	jump_if_player_coords_match 4, 12, .ows_above_sam
	jump_if_player_coords_match 2, 14, .ows_left_of_sam
; ows_below_sam
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction NORTH
	move_player NORTH, 1
.ows_left_of_sam
	set_player_direction NORTH
	move_player NORTH, 1
	set_player_direction EAST
	move_player EAST, 1
.ows_above_sam
	set_player_direction EAST
	move_player EAST, 1
	move_player EAST, 1
	move_player EAST, 1
	set_player_direction SOUTH
	move_player SOUTH, 1
	set_player_direction WEST
	move_active_npc NPCMovement_d889
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NORMAL_DUEL, .ows_d685
	start_duel PRIZES_2, SAMS_PRACTICE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

.ows_d685
	start_duel PRIZES_2, SAMS_NORMAL_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatSam:
	start_script
	jump_if_event_equal EVENT_MASON_LAB_STATE, MASON_LAB_IN_PRACTICE_DUEL, Script_EnterLabFirstTime.ows_d82d
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_PRACTICE_DUEL, Script_LostToSam.ows_d6ad
	print_npc_text Text05d1
	give_booster_packs BOOSTER_ENERGY_RANDOM, NO_BOOSTER, NO_BOOSTER
	print_text_quit_fully Text05d2

Script_LostToSam:
	start_script
	jump_if_event_equal EVENT_MASON_LAB_STATE, MASON_LAB_IN_PRACTICE_DUEL, Script_EnterLabFirstTime.ows_d82d
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_PRACTICE_DUEL, .ows_d6ad
	print_text_quit_fully Text05d3

.ows_d6ad
	print_text_quit_fully Text05d4

.ows_d6b0
	print_npc_text Text05d5
.ows_d6b3
	close_text_box
	show_sam_rules_multichoice
	close_text_box
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NOTHING_TO_ASK, Script_Sam.ows_d637
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_ATTACKING, .ows_d6df
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_RETREATING, .ows_d6e5
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_EVOLVING, .ows_d6eb
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_POKEMON_POWER, .ows_d6f1
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_ENDING_YOUR_TURN, .ows_d6f7
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_WIN_OR_LOSS, .ows_d6fd
; SAM_MENU_ENERGY
	print_npc_text Text05d6
	script_jump .ows_d6b3

.ows_d6df
	print_npc_text Text05d7
	script_jump .ows_d6b3

.ows_d6e5
	print_npc_text Text05d8
	script_jump .ows_d6b3

.ows_d6eb
	print_npc_text Text05d9
	script_jump .ows_d6b3

.ows_d6f1
	print_npc_text Text05da
	script_jump .ows_d6b3

.ows_d6f7
	print_npc_text Text05db
	script_jump .ows_d6b3

.ows_d6fd
	print_npc_text Text05dc
	script_jump .ows_d6b3

Func_d703:
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	ret z
	ld a, $0a
	farcall Func_80ba4
	ret

Preload_DrMason:
	call Func_d703
	get_event_value EVENT_MASON_LAB_STATE
	cp MASON_LAB_IN_PRACTICE_DUEL
	jr nz, .not_practice_duel
	ld a, $06
	ld [wLoadNPCXPos], a
	ld a, $0c
	ld [wLoadNPCYPos], a
.not_practice_duel
	scf
	ret

Script_DrMason:
	start_script
	jump_if_event_true EVENT_RONALD_FIRST_CLUB_ENTRANCE_ENCOUNTER, .ows_d72f
	print_text_quit_fully Text05dd

.ows_d72f
	try_give_medal_pc_packs
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 2, .ows_d738
	print_text_quit_fully Text05de

.ows_d738
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 7, .ows_d740
	print_text_quit_fully Text05df

.ows_d740
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_d747
	print_text_quit_fully Text05e0

.ows_d747
	jump_if_event_true EVENT_DRMASON_CONGRATULATED_PLAYER, .ows_d750
	max_out_event_value EVENT_DRMASON_CONGRATULATED_PLAYER
	print_text_quit_fully Text05e1

.ows_d750
	print_text_quit_fully Text05e2

Script_EnterLabFirstTime:
	start_script
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	move_player NORTH, 2
	print_npc_text Text05e3
	close_advanced_text_box
	set_next_npc_and_script NPC_SAM, .ows_d779
	end_script
	ret

.ows_d779
	start_script
	move_active_npc NPCMovement_d880
	print_npc_text Text05e4
	set_dialog_npc NPC_DRMASON
	print_npc_text Text05e5
	close_text_box
	move_active_npc NPCMovement_d882
	set_active_npc_direction EAST
	set_player_direction WEST
	close_advanced_text_box
	set_next_npc_and_script NPC_DRMASON, .ows_d794
	end_script
	ret

.ows_d794
	start_script
	move_active_npc NPCMovement_d88b
	do_frames 40
	print_npc_text Text05e6
	close_text_box
	move_player WEST, 1
	move_player WEST, 1
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	move_player SOUTH, 1
	set_player_direction WEST
	move_active_npc NPCMovement_d894
	print_npc_text Text05e7
	set_dialog_npc NPC_SAM
	print_npc_text Text05e8
.ows_d7bc
	close_text_box
	show_sam_rules_multichoice
	close_text_box
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_NOTHING_TO_ASK, .ows_d80c
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_ATTACKING, .ows_d7e8
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_RETREATING, .ows_d7ee
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_EVOLVING, .ows_d7f4
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_POKEMON_POWER, .ows_d7fa
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_ENDING_YOUR_TURN, .ows_d800
	jump_if_event_equal EVENT_SAM_MENU_CHOICE, SAM_MENU_WIN_OR_LOSS, .ows_d806
; SAM_MENU_ENERGY
	print_npc_text Text05d6
	script_jump .ows_d7bc

.ows_d7e8
	print_npc_text Text05d7
	script_jump .ows_d7bc

.ows_d7ee
	print_npc_text Text05d8
	script_jump .ows_d7bc

.ows_d7f4
	print_npc_text Text05d9
	script_jump .ows_d7bc

.ows_d7fa
	print_npc_text Text05da
	script_jump .ows_d7bc

.ows_d800
	print_npc_text Text05db
	script_jump .ows_d7bc

.ows_d806
	print_npc_text Text05dc
	script_jump .ows_d7bc

.ows_d80c
	print_npc_text Text05e9
	ask_question_jump_default_yes NULL, .ows_d817
	script_jump .ows_d7bc

.ows_d817
	set_dialog_npc NPC_DRMASON
	print_npc_text Text05ea
	script_nop
	set_event EVENT_MASON_LAB_STATE, MASON_LAB_IN_PRACTICE_DUEL
	close_advanced_text_box
	set_next_npc_and_script NPC_SAM, .ows_d827
	end_script
	ret

.ows_d827
	start_script
	start_duel PRIZES_2, SAMS_PRACTICE_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

.ows_d82d
	close_advanced_text_box
	set_next_npc_and_script NPC_DRMASON, Script_AfterPracticeDuel
	end_script
	ret

Script_AfterPracticeDuel:
	start_script
	print_npc_text Text05eb
	print_npc_text Text05ef
	close_text_box
	move_active_npc NPCMovement_d896
	set_player_direction NORTH
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	set_player_direction EAST
	move_player EAST, 1
	move_player EAST, 1
	set_player_direction NORTH
	print_npc_text Text05f0
	close_text_box
	print_text Text05f1
	close_text_box
	print_npc_text Text05f2
.ows_d85f
	choose_starter_deck
	close_text_box
	ask_question_jump Text05f3, .ows_d869
	script_jump .ows_d85f

.ows_d869
	print_npc_text Text05f4
	close_text_box
	pause_song
	play_song MUSIC_BOOSTER_PACK
	print_text Text05f5
	wait_for_song_to_finish
	resume_song
	close_text_box
	set_event EVENT_MASON_LAB_STATE, MASON_LAB_RECEIVED_STARTER_DECK
	give_stater_deck
	print_npc_text Text05f6
	save_game 0
	quit_script_fully

NPCMovement_d880:
	db EAST
	db $ff

NPCMovement_d882:
	db SOUTH
	db SOUTH
	db WEST
	db WEST
	db WEST
	db WEST
	db SOUTH
NPCMovement_d889:
	db EAST | NO_MOVE
	db $ff

NPCMovement_d88b:
	db WEST
	db SOUTH
	db SOUTH
	db SOUTH
	db WEST
	db WEST
	db WEST
	db EAST | NO_MOVE
	db $ff

NPCMovement_d894:
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_d896:
	db NORTH
	db NORTH
	db NORTH
	db EAST
	db EAST
	db EAST
	db EAST
	db SOUTH | NO_MOVE
	db $ff
