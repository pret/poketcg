DeckMachineRoomAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_AARON
	db NPC_AARON
	dw Script_BeatAaron
	dw Script_LostToAaron
	db $00

DeckMachineRoomCloseTextBox:
	ld a, MAP_EVENT_FIGHTING_DECK_MACHINE
.asm_d8af
	push af
	farcall Func_80b89
	pop af
	inc a
	cp MAP_EVENT_FIRE_DECK_MACHINE + 1
	jr c, .asm_d8af
	ret

Script_Tech6:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text05f7, Text05f8
	quit_script_fully

Script_Tech7:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text05f9, Text05fa
	quit_script_fully

Script_Tech8:
	start_script
	test_if_event_not_equal EVENT_ALL_DECK_MACHINE_FLAGS, $ff
	print_variable_npc_text Text05fb, Text05fc
	quit_script_fully

Script_Aaron:
	start_script
	print_npc_text Text05fd
	ask_question_jump Text05fe, .ows_d8e9
.ows_d8e6
	print_text_quit_fully Text05ff

.ows_d8e9
	print_npc_text Text0600
	choose_deck_to_duel_against
	close_text_box
	jump_if_event_equal EVENT_AARON_DECK_MENU_CHOICE, AARON_DECK_MENU_CANCEL, .ows_d8e6
	ask_question_jump Text0601, .ows_d8fb
	script_jump .ows_d8e6

.ows_d8fb
	print_npc_text Text0602
	start_duel PRIZES_4, $ff, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatAaron:
	ld a, [wMultichoiceTextboxResult_ChooseDeckToDuelAgainst]
	ld c, a
	set_event_value EVENT_AARON_BOOSTER_REWARD

	start_script
	print_npc_text Text0603
	jump_if_event_equal EVENT_AARON_BOOSTER_REWARD, 1, .ows_d920
	jump_if_event_equal EVENT_AARON_BOOSTER_REWARD, 2, .ows_d927
	give_booster_packs BOOSTER_ENERGY_RANDOM, NO_BOOSTER, NO_BOOSTER
	script_jump Script_LostToAaron.ows_d92f

.ows_d920
	give_booster_packs BOOSTER_ENERGY_RANDOM, NO_BOOSTER, NO_BOOSTER
	script_jump Script_LostToAaron.ows_d92f

.ows_d927
	give_booster_packs BOOSTER_ENERGY_RANDOM, NO_BOOSTER, NO_BOOSTER
	script_jump Script_LostToAaron.ows_d92f

Script_LostToAaron:
	start_script
.ows_d92f
	print_text_quit_fully Text0604

Script_d932:
	start_script
	print_text Text0605
	ask_question_jump_default_yes Text0606, .ows_d93c
	quit_script_fully

.ows_d93c
	open_deck_machine DECK_MACHINE_BASIC
	quit_script_fully

Script_d93f:
	ld a, $02
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_FIGHTING_DECK_MACHINE_ACTIVE, .ows_d963
	print_text Text0608
	jump_if_event_true EVENT_BEAT_MITCH, .ows_d954
	quit_script_fully

.ows_d954
	ask_question_jump_default_yes Text0609, .ows_d95a
	quit_script_fully

.ows_d95a
	play_sfx SFX_INTRO_ORB_TITLE
	max_out_event_value EVENT_FIGHTING_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_FIGHTING_DECK_MACHINE
	print_text Text060a
.ows_d963
	ask_question_jump_default_yes Text060b, .ows_d969
	quit_script_fully

.ows_d969
	open_deck_machine DECK_MACHINE_FIGHTING
	quit_script_fully

Func_d96c:
	sub 2
	add a
	ld c, a
	ld b, 0
	ld hl, ClubMapNames
	add hl, bc
	ld a, [hli]
	ld [wTxRam2], a
	ld [wTxRam2_b], a
	ld a, [hl]
	ld [wTxRam2 + 1], a
	ld [wTxRam2_b + 1], a
	ret

ClubMapNames:
	tx FightingClubMapName
	tx RockClubMapName
	tx WaterClubMapName
	tx LightningClubMapName
	tx GrassClubMapName
	tx PsychicClubMapName
	tx ScienceClubMapName
	tx FireClubMapName

Script_d995:
	ld a, $03
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_ROCK_DECK_MACHINE_ACTIVE, .ows_d9b9
	print_text Text0608
	jump_if_event_true EVENT_BEAT_GENE, .ows_d9aa
	quit_script_fully

.ows_d9aa
	ask_question_jump_default_yes Text0609, .ows_d9b0
	quit_script_fully

.ows_d9b0
	play_sfx SFX_INTRO_ORB_TITLE
	max_out_event_value EVENT_ROCK_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_ROCK_DECK_MACHINE
	print_text Text060a
.ows_d9b9
	ask_question_jump_default_yes Text060b, .ows_d9bf
	quit_script_fully

.ows_d9bf
	open_deck_machine DECK_MACHINE_ROCK
	quit_script_fully

Script_d9c2:
	ld a, $04
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_WATER_DECK_MACHINE_ACTIVE, .ows_d9e6
	print_text Text0608
	jump_if_event_true EVENT_BEAT_AMY, .ows_d9d7
	quit_script_fully

.ows_d9d7
	ask_question_jump_default_yes Text0609, .ows_d9dd
	quit_script_fully

.ows_d9dd
	play_sfx SFX_INTRO_ORB_TITLE
	max_out_event_value EVENT_WATER_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_WATER_DECK_MACHINE
	print_text Text060a
.ows_d9e6
	ask_question_jump_default_yes Text060b, .ows_d9ec
	quit_script_fully

.ows_d9ec
	open_deck_machine DECK_MACHINE_WATER
	quit_script_fully

Script_d9ef:
	ld a, $05
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_LIGHTNING_DECK_MACHINE_ACTIVE, .ows_da13
	print_text Text0608
	jump_if_event_true EVENT_BEAT_ISAAC, .ows_da04
	quit_script_fully

.ows_da04
	ask_question_jump_default_yes Text0609, .ows_da0a
	quit_script_fully

.ows_da0a
	play_sfx SFX_INTRO_ORB_TITLE
	max_out_event_value EVENT_LIGHTNING_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_LIGHTNING_DECK_MACHINE
	print_text Text060a
.ows_da13
	ask_question_jump_default_yes Text060b, .ows_da19
	quit_script_fully

.ows_da19
	open_deck_machine DECK_MACHINE_LIGHTNING
	quit_script_fully

Script_da1c:
	ld a, $06
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_GRASS_DECK_MACHINE_ACTIVE, .ows_da40
	print_text Text0608
	jump_if_event_true EVENT_BEAT_NIKKI, .ows_da31
	quit_script_fully

.ows_da31
	ask_question_jump_default_yes Text0609, .ows_da37
	quit_script_fully

.ows_da37
	play_sfx SFX_INTRO_ORB_TITLE
	max_out_event_value EVENT_GRASS_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_GRASS_DECK_MACHINE
	print_text Text060a
.ows_da40
	ask_question_jump_default_yes Text060b, .ows_da46
	quit_script_fully

.ows_da46
	open_deck_machine DECK_MACHINE_GRASS
	quit_script_fully

Script_da49:
	ld a, $07
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_PSYCHIC_DECK_MACHINE_ACTIVE, .ows_da6d
	print_text Text0608
	jump_if_event_true EVENT_BEAT_MURRAY, .ows_da5e
	quit_script_fully

.ows_da5e
	ask_question_jump_default_yes Text0609, .ows_da64
	quit_script_fully

.ows_da64
	play_sfx SFX_INTRO_ORB_TITLE
	max_out_event_value EVENT_PSYCHIC_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_PSYCHIC_DECK_MACHINE
	print_text Text060a
.ows_da6d
	ask_question_jump_default_yes Text060b, .ows_da73
	quit_script_fully

.ows_da73
	open_deck_machine DECK_MACHINE_PSYCHIC
	quit_script_fully

Script_da76:
	ld a, $08
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_SCIENCE_DECK_MACHINE_ACTIVE, .ows_da9a
	print_text Text0608
	jump_if_event_true EVENT_BEAT_RICK, .ows_da8b
	quit_script_fully

.ows_da8b
	ask_question_jump_default_yes Text0609, .ows_da91
	quit_script_fully

.ows_da91
	play_sfx SFX_INTRO_ORB_TITLE
	max_out_event_value EVENT_SCIENCE_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_SCIENCE_DECK_MACHINE
	print_text Text060a
.ows_da9a
	ask_question_jump_default_yes Text060b, .ows_daa0
	quit_script_fully

.ows_daa0
	open_deck_machine DECK_MACHINE_SCIENCE
	quit_script_fully

Script_daa3:
	ld a, $09
	call Func_d96c

	start_script
	print_text Text0607
	jump_if_event_true EVENT_FIRE_DECK_MACHINE_ACTIVE, .ows_dac7
	print_text Text0608
	jump_if_event_true EVENT_BEAT_KEN, .ows_dab8
	quit_script_fully

.ows_dab8
	ask_question_jump_default_yes Text0609, .ows_dabe
	quit_script_fully

.ows_dabe
	play_sfx SFX_INTRO_ORB_TITLE
	max_out_event_value EVENT_FIRE_DECK_MACHINE_ACTIVE
	replace_map_blocks MAP_EVENT_FIRE_DECK_MACHINE
	print_text Text060a
.ows_dac7
	ask_question_jump_default_yes Text060b, .ows_dacd
	quit_script_fully

.ows_dacd
	open_deck_machine DECK_MACHINE_FIRE
	quit_script_fully

Script_dad0:
	start_script
	print_text Text060c
	ask_question_jump_default_yes Text060d, .ows_dada
	quit_script_fully

.ows_dada
	open_deck_machine DECK_MACHINE_SAVE
	quit_script_fully
