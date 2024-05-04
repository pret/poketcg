PokemonDomeMovePlayer:
	ld a, [wPlayerYCoord]
	cp $16
	ret nz
	ld a, [wPlayerXCoord]
	cp $0e
	ret c
	cp $11
	ret nc
	ld a, NPC_ROD
	ld [wTempNPC], a
	ld bc, Script_f84c
	jp SetNextNPCAndScript

PokemonDomeAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_COURTNEY
	db NPC_COURTNEY
	dw Script_BeatCourtney
	dw Script_LostToCourtney

	db NPC_STEVE
	db NPC_STEVE
	dw Script_BeatSteve
	dw Script_LostToSteve

	db NPC_JACK
	db NPC_JACK
	dw Script_BeatJack
	dw Script_LostToJack

	db NPC_ROD
	db NPC_ROD
	dw Script_BeatRod
	dw Script_LostToRod

	db NPC_RONALD1
	db NPC_RONALD1
	dw Script_BeatRonald1InPokemonDome
	dw Script_LostToRonald1InPokemonDome
	db $00

PokemonDomeLoadMap:
	ld a, $0d
	farcall TryGivePCPack
	get_event_value EVENT_POKEMON_DOME_IN_MENU
	or a
	ret z
	ld bc, Script_f80b
	jp SetNextScript

PokemonDomeCloseTextBox:
	ld a, MAP_EVENT_HALL_OF_HONOR_DOOR
	farcall Func_80b89
	ret

Script_Courtney:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text055a, Text055b
	quit_script_fully

Script_Steve:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text055c, Text055d
	quit_script_fully

Script_Jack:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text055e, Text055f
	quit_script_fully

Script_Rod:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0560, Text0561
	quit_script_fully

Preload_Courtney:
	get_event_value EVENT_COURTNEY_STATE
	cp COURTNEY_CHALLENGED
	jr z, PlacePokemonDomeOpponentAtDuelTable
	lb bc, $16, $0c
	cp COURTNEY_DEFEATED
	jr z, Func_f77d
	get_event_value EVENT_CHALLENGED_GRAND_MASTERS
	jr nz, Func_f762
	scf
	ret

Func_f762:
	ld a, [wLoadNPCYPos]
	add $02
	ld [wLoadNPCYPos], a
	scf
	ret

PlacePokemonDomeOpponentAtDuelTable:
	ld a, $12
	ld [wLoadNPCXPos], a
	ld a, $0e
	ld [wLoadNPCYPos], a
	ld a, WEST
	ld [wLoadNPCDirection], a
	scf
	ret

Func_f77d:
	ld a, WEST
	ld [wLoadNPCDirection], a
Func_f782:
	ld a, b
	ld [wLoadNPCXPos], a
	ld a, c
	ld [wLoadNPCYPos], a
	scf
	ret

Preload_Steve:
	get_event_value EVENT_STEVE_STATE
	cp STEVE_CHALLENGED
	jr z, PlacePokemonDomeOpponentAtDuelTable
	lb bc, $16, $0e
	cp STEVE_DEFEATED
	jr z, Func_f77d
	get_event_value EVENT_CHALLENGED_GRAND_MASTERS
	jr nz, Func_f762
	scf
	ret

Preload_Jack:
	get_event_value EVENT_JACK_STATE
	cp JACK_CHALLENGED
	jr z, PlacePokemonDomeOpponentAtDuelTable
	lb bc, $14, $0a
	cp JACK_DEFEATED
	jr z, Func_f77d
	get_event_value EVENT_CHALLENGED_GRAND_MASTERS
	jr nz, Func_f762
	scf
	ret

Preload_Rod:
	get_event_value EVENT_ROD_STATE
	cp ROD_CHALLENGED
	jr z, PlacePokemonDomeOpponentAtDuelTable
	get_event_value EVENT_POKEMON_DOME_STATE
	lb bc, $10, $0a
	cp POKEMON_DOME_DEFEATED
	jr z, Func_f782
	lb bc, $0e, $0a
	cp POKEMON_DOME_CHALLENGED
	jr z, Func_f782
	scf
	ret

Preload_Ronald1InPokemonDome:
	get_event_value EVENT_RONALD_POKEMON_DOME_STATE
	cp RONALD_DEFEATED
	ret nc
	get_event_value EVENT_RONALD_POKEMON_DOME_STATE
	or a
	jr z, .not_challenged
	ld a, MUSIC_RONALD
	ld [wDefaultSong], a
	jr PlacePokemonDomeOpponentAtDuelTable
.not_challenged
	scf
	ret

Script_f7ed:
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_f7f9
	print_npc_text Text0562
.ows_f7f4
	close_text_box
	move_player NORTH, 2
	quit_script_fully

.ows_f7f9
	print_npc_text Text0563
	ask_question_jump Text0564, .ows_f804
	script_jump .ows_f7f4

.ows_f804
	enter_map $0c, POKEMON_DOME_ENTRANCE, 22, 4, NORTH
	quit_script_fully

Script_f80b:
	start_script
	jump_if_event_equal EVENT_STEVE_STATE, STEVE_CHALLENGED, .ows_f820
	jump_if_event_equal EVENT_JACK_STATE, JACK_CHALLENGED, .ows_f82b
	jump_if_event_equal EVENT_ROD_STATE, ROD_CHALLENGED, .ows_f836
	jump_if_event_equal EVENT_RONALD_POKEMON_DOME_STATE, RONALD_CHALLENGED, .ows_f841
.ows_f820
	close_advanced_text_box
	set_next_npc_and_script NPC_STEVE, .ows_f827
	end_script
	ret

.ows_f827
	start_script
	script_jump Script_BeatCourtney.ows_f996

.ows_f82b
	close_advanced_text_box
	set_next_npc_and_script NPC_JACK, .ows_f832
	end_script
	ret

.ows_f832
	start_script
	script_jump Script_BeatSteve.ows_fa02

.ows_f836
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f83d
	end_script
	ret

.ows_f83d
	start_script
	script_jump Script_BeatJack.ows_fa78

.ows_f841
	close_advanced_text_box
	set_next_npc_and_script NPC_RONALD1, .ows_f848
	end_script
	ret

.ows_f848
	start_script
	script_jump Script_BeatRod.ows_fb20

Script_f84c:
	start_script
	jump_if_event_true EVENT_HALL_OF_HONOR_DOORS_OPEN, Script_f7ed
	print_npc_text Text0565
	ask_question_jump Text0566, .ows_f85f
	print_npc_text Text0567
	script_jump Script_f7ed.ows_f804

.ows_f85f
	print_npc_text Text0568
	close_text_box
	jump_if_player_coords_match 14, 22, .ows_f86f
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction NORTH
.ows_f86f
	move_player NORTH, 1
	move_player NORTH, 1
	set_player_direction WEST
	move_player WEST, 1
	move_player WEST, 1
	set_player_direction NORTH
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	move_player NORTH, 1
	set_player_direction EAST
	move_player EAST, 1
	move_player EAST, 1
	set_player_direction NORTH
	test_if_event_false EVENT_CHALLENGED_GRAND_MASTERS
	print_variable_npc_text Text0569, Text056a
	move_active_npc NPCMovement_fb8c
	jump_if_event_true EVENT_CHALLENGED_GRAND_MASTERS, .ows_f8ef
	print_npc_text Text056b
	close_advanced_text_box
	set_next_npc_and_script NPC_COURTNEY, .ows_f8af
	end_script
	ret

.ows_f8af
	start_script
	move_active_npc NPCMovement_fb8e
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f8ba
	end_script
	ret

.ows_f8ba
	start_script
	print_npc_text Text056c
	close_advanced_text_box
	set_next_npc_and_script NPC_STEVE, .ows_f8c5
	end_script
	ret

.ows_f8c5
	start_script
	move_active_npc NPCMovement_fb8e
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f8d0
	end_script
	ret

.ows_f8d0
	start_script
	print_npc_text Text056d
	close_advanced_text_box
	set_next_npc_and_script NPC_JACK, .ows_f8db
	end_script
	ret

.ows_f8db
	start_script
	move_active_npc NPCMovement_fb8e
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f8e6
	end_script
	ret

.ows_f8e6
	start_script
	max_out_event_value EVENT_CHALLENGED_GRAND_MASTERS
	print_npc_text Text056e
	script_jump .ows_f8f8

.ows_f8ef
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text056f, Text0570
.ows_f8f8
	print_npc_text Text0571
	close_text_box
	set_player_direction WEST
	move_player WEST, 1
	set_player_direction SOUTH
	move_player SOUTH, 1
	move_player SOUTH, 1
	set_player_direction EAST
	move_active_npc NPCMovement_fb8d
	set_event EVENT_POKEMON_DOME_STATE, POKEMON_DOME_CHALLENGED
	close_advanced_text_box
	set_next_npc_and_script NPC_COURTNEY, .ows_f918
	end_script
	ret

.ows_f918
	start_script
	try_give_pc_pack $0e
	set_event EVENT_COURTNEY_STATE, COURTNEY_CHALLENGED
	set_dialog_npc NPC_ROD
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0572, Text0573
	close_text_box
	set_dialog_npc NPC_COURTNEY
	move_active_npc NPCMovement_fba6
	set_active_npc_direction WEST
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0574, Text0575
	start_duel PRIZES_6, LEGENDARY_MOLTRES_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

Script_LostToCourtney:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0576, Text0577
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_f950
	end_script
	ret

.ows_f950
	start_script
	move_active_npc NPCMovement_fba1
	print_npc_text Text0578
	script_jump Script_f7ed.ows_f804

Script_BeatCourtney:
	start_script
	set_event EVENT_COURTNEY_STATE, COURTNEY_DEFEATED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0579, Text057a
	close_text_box
	move_active_npc NPCMovement_fbb7
	set_active_npc_direction WEST
	close_advanced_text_box
	set_next_npc_and_script NPC_STEVE, .ows_f974
	end_script
	ret

.ows_f974
	start_script
	try_give_pc_pack $0f
	set_event EVENT_STEVE_STATE, STEVE_CHALLENGED
	set_dialog_npc NPC_ROD
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text057b, Text057c
	close_text_box
	set_dialog_npc NPC_STEVE
	move_active_npc NPCMovement_fba4
	set_active_npc_direction WEST
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text057d, Text057e
.ows_f996
	zero_out_event_value EVENT_POKEMON_DOME_IN_MENU
	set_dialog_npc NPC_ROD
	print_npc_text Text057f
	ask_question_jump_default_yes Text0580, .ows_f9af
	print_npc_text Text0581
	set_dialog_npc NPC_STEVE
	print_npc_text Text0582
	start_duel PRIZES_6, LEGENDARY_ZAPDOS_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

.ows_f9af
	close_text_box
	max_out_event_value EVENT_POKEMON_DOME_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_f996

Script_LostToSteve:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0583, Text0584
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, Script_LostToCourtney.ows_f950
	end_script
	ret

Script_BeatSteve:
	start_script
	set_event EVENT_STEVE_STATE, STEVE_DEFEATED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0585, Text0586
	close_text_box
	move_active_npc NPCMovement_fbb8
	set_active_npc_direction WEST
	close_advanced_text_box
	set_next_npc_and_script NPC_JACK, .ows_f9e2
	end_script
	ret

.ows_f9e2
	start_script
	set_event EVENT_JACK_STATE, JACK_CHALLENGED
	set_dialog_npc NPC_ROD
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0587, Text0588
	close_text_box
	set_dialog_npc NPC_JACK
	move_active_npc NPCMovement_fbbc
	set_active_npc_direction WEST
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0589, Text058a
.ows_fa02
	zero_out_event_value EVENT_POKEMON_DOME_IN_MENU
	set_dialog_npc NPC_ROD
	print_npc_text Text058b
	ask_question_jump_default_yes Text058c, .ows_fa1b
	print_npc_text Text058d
	set_dialog_npc NPC_JACK
	print_npc_text Text058e
	start_duel PRIZES_6, LEGENDARY_ARTICUNO_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

.ows_fa1b
	close_text_box
	max_out_event_value EVENT_POKEMON_DOME_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_fa02

Script_LostToJack:
	start_script
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text058f, Text0590
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, Script_LostToCourtney.ows_f950
	end_script
	ret

Script_BeatJack:
	start_script
	set_event EVENT_JACK_STATE, JACK_DEFEATED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0591, Text0592
	close_text_box
	move_active_npc NPCMovement_fbc2
	set_active_npc_direction WEST
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_fa52
	move_npc NPC_ROD, NPCMovement_f390
	end_script
	ret

.ows_fa52
	start_script
	set_event EVENT_ROD_STATE, ROD_CHALLENGED
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text0593, Text0594
	close_text_box
	move_active_npc NPCMovement_fbaf
	set_active_npc_direction WEST
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_fa75
	test_if_event_false EVENT_CHALLENGED_RONALD
	print_variable_npc_text Text0595, Text0596
	script_jump .ows_fa78

.ows_fa75
	print_npc_text Text0597
.ows_fa78
	zero_out_event_value EVENT_POKEMON_DOME_IN_MENU
	print_npc_text Text0598
	ask_question_jump_default_yes Text0599, .ows_fa90
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text059a, Text059b
	start_duel PRIZES_6, LEGENDARY_DRAGONITE_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

.ows_fa90
	close_text_box
	max_out_event_value EVENT_POKEMON_DOME_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_fa78

Script_LostToRod:
	start_script
	print_npc_text Text059c
	close_text_box
	move_active_npc NPCMovement_fb9d
	set_active_npc_direction SOUTH
	test_if_event_false EVENT_RECEIVED_LEGENDARY_CARDS
	print_variable_npc_text Text059d, Text059e
	script_jump Script_f7ed.ows_f804

Script_BeatRod:
	start_script
	set_event EVENT_ROD_STATE, ROD_DEFEATED
	jump_if_event_true EVENT_RECEIVED_LEGENDARY_CARDS, .ows_fad5
	test_if_event_false EVENT_CHALLENGED_RONALD
	print_variable_npc_text Text059f, Text05a0
	close_text_box
	move_active_npc NPCMovement_fb90
	set_active_npc_direction SOUTH
	test_if_event_false EVENT_CHALLENGED_RONALD
	print_variable_npc_text Text05a1, Text05a2
	close_advanced_text_box
	set_next_npc_and_script NPC_RONALD1, .ows_fae9
	end_script
	ret

.ows_fad5
	print_npc_text Text05a3
	move_active_npc NPCMovement_fb96
	set_active_npc_direction SOUTH
	play_sfx SFX_POKEMON_DOME_DOORS
	replace_map_blocks MAP_EVENT_HALL_OF_HONOR_DOOR
	set_event EVENT_POKEMON_DOME_STATE, POKEMON_DOME_DEFEATED
	max_out_event_value EVENT_HALL_OF_HONOR_DOORS_OPEN
	print_text_quit_fully Text05a4

.ows_fae9
	start_script
	override_song MUSIC_STOP
	set_event EVENT_RONALD_POKEMON_DOME_STATE, RONALD_CHALLENGED
	play_sfx SFX_POKEMON_DOME_DOORS
	replace_map_blocks MAP_EVENT_HALL_OF_HONOR_DOOR
	move_active_npc NPCMovement_fbd2
	set_default_song MUSIC_RONALD
	play_default_song
	jump_if_event_true EVENT_CHALLENGED_RONALD, .ows_fb15
	print_npc_text Text05a5
	set_dialog_npc NPC_ROD
	move_npc NPC_ROD, NPCMovement_fb9b
	print_npc_text Text05a6
	set_dialog_npc NPC_RONALD1
	print_npc_text Text05a7
	move_npc NPC_ROD, NPCMovement_fb99
	script_jump .ows_fb18

.ows_fb15
	print_npc_text Text05a8
.ows_fb18
	close_text_box
	move_active_npc NPCMovement_fba8
	set_active_npc_direction WEST
	max_out_event_value EVENT_CHALLENGED_RONALD
.ows_fb20
	zero_out_event_value EVENT_POKEMON_DOME_IN_MENU
	set_dialog_npc NPC_ROD
	print_npc_text Text05a9
	ask_question_jump_default_yes Text05aa, .ows_fb40
	print_npc_text Text05ab
	set_dialog_npc NPC_RONALD1
	print_npc_text Text05ac
	set_dialog_npc NPC_ROD
	print_npc_text Text05ad
	set_dialog_npc NPC_RONALD1
	start_duel PRIZES_6, LEGENDARY_RONALD_DECK_ID, MUSIC_DUEL_THEME_3
	quit_script_fully

.ows_fb40
	close_text_box
	max_out_event_value EVENT_POKEMON_DOME_IN_MENU
	open_menu
	close_text_box
	script_jump .ows_fb20

Script_LostToRonald1InPokemonDome:
	start_script
	print_npc_text Text05ae
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, Script_LostToCourtney.ows_f950
	end_script
	ret

Script_BeatRonald1InPokemonDome:
	start_script
	set_event EVENT_RONALD_POKEMON_DOME_STATE, RONALD_DEFEATED
	print_npc_text Text05af
	set_dialog_npc NPC_ROD
	print_npc_text Text05b0
	print_text Text05b1
	set_dialog_npc NPC_RONALD1
	print_npc_text Text05b2
	close_text_box
	move_active_npc NPCMovement_fbc7
	unload_active_npc
	set_default_song MUSIC_HALL_OF_HONOR
	play_default_song
	close_advanced_text_box
	set_next_npc_and_script NPC_ROD, .ows_fb76
	end_script
	ret

.ows_fb76
	start_script
	move_active_npc NPCMovement_fba1
	set_player_direction NORTH
	print_npc_text Text05b3
	move_active_npc NPCMovement_fbb2
	set_event EVENT_POKEMON_DOME_STATE, POKEMON_DOME_DEFEATED
	max_out_event_value EVENT_HALL_OF_HONOR_DOORS_OPEN
	record_master_win $0a
	print_text_quit_fully Text05b4

NPCMovement_fb8c:
	db EAST
NPCMovement_fb8d:
	db SOUTH
NPCMovement_fb8e:
	db SOUTH
	db $ff

NPCMovement_fb90:
	db NORTH
	db NORTH
	db WEST
	db WEST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_fb96:
	db NORTH
	db NORTH
	db WEST
NPCMovement_fb99:
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_fb9b:
	db NORTH | NO_MOVE
	db $ff

NPCMovement_fb9d:
	db NORTH
	db NORTH
	db WEST
	db WEST
NPCMovement_fba1:
	db WEST
	db SOUTH
	db $ff

NPCMovement_fba4:
	db WEST
	db WEST
NPCMovement_fba6:
	db WEST
	db SOUTH
NPCMovement_fba8:
	db SOUTH
	db SOUTH
	db EAST
	db SOUTH
	db SOUTH
	db WEST | NO_MOVE
	db $ff

NPCMovement_fbaf:
	db EAST
	db $fe, -7

NPCMovement_fbb2:
	db NORTH
	db EAST
	db EAST
	db SOUTH | NO_MOVE
	db $ff

NPCMovement_fbb7:
	db NORTH
NPCMovement_fbb8:
	db EAST
	db EAST
	db WEST | NO_MOVE
	db $ff

NPCMovement_fbbc:
	db EAST
	db EAST
	db EAST
	db EAST
	db $fe, -26

NPCMovement_fbc2:
	db NORTH
	db NORTH
	db EAST
	db WEST | NO_MOVE
	db $ff

NPCMovement_fbc7:
	db SOUTH
	db SOUTH
	db WEST
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db SOUTH
	db $ff

NPCMovement_fbd2:
	db WEST
	db WEST
	db WEST
	db WEST
	db WEST
	db WEST
	db WEST
	db $fe, -12
