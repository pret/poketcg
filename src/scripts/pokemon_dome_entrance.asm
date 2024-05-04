PokemonDomeEntranceLoadMap:
	set_event_false EVENT_HALL_OF_HONOR_DOORS_OPEN
	set_event_zero EVENT_POKEMON_DOME_STATE
	set_event_zero EVENT_COURTNEY_STATE
	set_event_zero EVENT_STEVE_STATE
	set_event_zero EVENT_JACK_STATE
	set_event_zero EVENT_ROD_STATE
	get_event_value EVENT_RECEIVED_LEGENDARY_CARDS
	or a
	ret nz
	set_event_zero EVENT_RONALD_POKEMON_DOME_STATE
	ret

PokemonDomeEntranceCloseTextBox:
	ld a, MAP_EVENT_POKEMON_DOME_DOOR
	farcall Func_80b89
	ret

Script_f631:
	start_script
	print_npc_text PlateOfLegendsText
	close_advanced_text_box
	set_next_npc_and_script NPC_RONALD1, .ows_f63c
	end_script
	ret

.ows_f63c
	call TryGiveMedalPCPacks
	get_event_value EVENT_MEDAL_COUNT
	ld [wTxRam3], a
	inc a
	ld [wTxRam3_b], a
	xor a
	ld [wTxRam3 + 1], a
	ld [wTxRam3_b + 1], a

	start_script
	jump_if_event_greater_or_equal EVENT_MEDAL_COUNT, 7, .ows_f69b
	jump_if_event_false EVENT_RONALD_FIRST_CLUB_ENTRANCE_ENCOUNTER, .ows_f69b
	jump_if_event_true EVENT_RONALD_POKEMON_DOME_ENTRANCE_ENCOUNTER, .ows_f69b
	override_song MUSIC_RONALD
	max_out_event_value EVENT_RONALD_POKEMON_DOME_ENTRANCE_ENCOUNTER
	jump_if_player_coords_match 18, 2, .ows_f66e
	move_active_npc NPCMovement_f69c
	script_jump .ows_f671

.ows_f66e
	move_active_npc NPCMovement_f69d
.ows_f671
	print_npc_text Text0553
	close_text_box
	set_player_direction SOUTH
	move_player SOUTH, 1
	print_npc_text Text0554
	ask_question_jump_default_yes NULL, .ows_f688
	print_npc_text Text0555
	script_jump .ows_f695

.ows_f688
	jump_if_event_zero EVENT_MEDAL_COUNT, .ows_f692
	print_npc_text Text0556
	script_jump .ows_f695

.ows_f692
	print_npc_text Text0557
.ows_f695
	close_text_box
	move_active_npc NPCMovement_f6a6
	unload_active_npc
	play_default_song
.ows_f69b
	quit_script_fully

NPCMovement_f69c:
	db EAST
NPCMovement_f69d:
	db NORTH
	db NORTH
	db NORTH
	db NORTH
	db EAST
	db EAST
	db NORTH
	db NORTH
	db $ff

NPCMovement_f6a6:
	db WEST
	db WEST
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

Script_f6af:
	start_script
	try_give_medal_pc_packs
	jump_if_event_equal EVENT_MEDAL_COUNT, 8, .ows_f6b9
	print_text_quit_fully MysteriousVoiceDoorNotEnoughMedalsText

.ows_f6b9
	print_npc_text Text0559
	play_sfx SFX_POKEMON_DOME_DOORS
	replace_map_blocks MAP_EVENT_POKEMON_DOME_DOOR
	do_frames 30
	move_player NORTH, 1
	quit_script_fully
