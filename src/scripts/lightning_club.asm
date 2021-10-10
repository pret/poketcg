LightningClubAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_JENNIFER
	db NPC_JENNIFER
	dw Script_BeatJennifer
	dw Script_LostToJennifer

	db NPC_NICHOLAS
	db NPC_NICHOLAS
	dw Script_BeatNicholas
	dw Script_LostToNicholas

	db NPC_BRANDON
	db NPC_BRANDON
	dw Script_BeatBrandon
	dw Script_LostToBrandon

	db NPC_ISAAC
	db NPC_ISAAC
	dw Script_BeatIsaac
	dw Script_LostToIsaac
	db $00

Script_Jennifer:
	start_script
	print_npc_text Text061b
	ask_question_jump Text061c, .ows_e415
	print_npc_text Text061d
	quit_script_fully

.ows_e415
	print_npc_text Text061e
	start_duel PRIZES_4, PIKACHU_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatJennifer:
	start_script
	max_out_event_value EVENT_BEAT_JENNIFER
	print_npc_text Text061f
	give_booster_packs BOOSTER_MYSTERY_LIGHTNING_COLORLESS, BOOSTER_MYSTERY_LIGHTNING_COLORLESS, NO_BOOSTER
	print_npc_text Text0620
	quit_script_fully

Script_LostToJennifer:
	start_script
	print_text_quit_fully Text0621

Script_Nicholas:
	start_script
	print_npc_text Text0622
	ask_question_jump Text0623, .ows_e43c
	print_npc_text Text0624
	quit_script_fully

.ows_e43c
	print_npc_text Text0625
	start_duel PRIZES_4, BOOM_BOOM_SELFDESTRUCT_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatNicholas:
	start_script
	max_out_event_value EVENT_BEAT_NICHOLAS
	print_npc_text Text0626
	give_booster_packs BOOSTER_COLOSSEUM_LIGHTNING, BOOSTER_COLOSSEUM_LIGHTNING, NO_BOOSTER
	print_npc_text Text0627
	quit_script_fully

Script_LostToNicholas:
	start_script
	print_text_quit_fully Text0628

Script_Brandon:
	start_script
	jump_if_event_false EVENT_BEAT_JENNIFER, .ows_e469
	jump_if_event_false EVENT_BEAT_NICHOLAS, .ows_e469
	jump_if_event_false EVENT_BEAT_BRANDON, .ows_e469
	print_npc_text Text0629
	script_jump .ows_e46c

.ows_e469
	print_npc_text Text062a
.ows_e46c
	print_npc_text Text062b
	ask_question_jump Text062c, .ows_e478
	print_npc_text Text062d
	quit_script_fully

.ows_e478
	print_npc_text Text062e
	start_duel PRIZES_4, POWER_GENERATOR_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatBrandon:
	start_script
	try_give_pc_pack $05
	max_out_event_value EVENT_BEAT_BRANDON
	print_npc_text Text062f
	give_booster_packs BOOSTER_COLOSSEUM_LIGHTNING, BOOSTER_COLOSSEUM_LIGHTNING, NO_BOOSTER
	print_npc_text Text0630
	quit_script_fully

Script_LostToBrandon:
	start_script
	print_text_quit_fully Text0631

Preload_Isaac:
	get_event_value EVENT_BEAT_JENNIFER
	jr z, .asm_e4ab
	get_event_value EVENT_BEAT_NICHOLAS
	jr z, .asm_e4ab
	get_event_value EVENT_BEAT_BRANDON
	jr z, .asm_e4ab
	ld a, SOUTH
	ld [wLoadNPCDirection], a
.asm_e4ab
	scf
	ret

Script_Isaac:
	start_script
	jump_if_event_false EVENT_BEAT_JENNIFER, .ows_e4bd
	jump_if_event_false EVENT_BEAT_NICHOLAS, .ows_e4bd
	jump_if_event_false EVENT_BEAT_BRANDON, .ows_e4bd
	script_jump .ows_e4c1

.ows_e4bd
	print_npc_text Text0632
	quit_script_fully

.ows_e4c1
	jump_if_event_true EVENT_BEAT_ISAAC, Script_LostToIsaac.ows_e503
	test_if_event_false EVENT_ISAAC_TALKED
	print_variable_npc_text Text0633, Text0634
	max_out_event_value EVENT_ISAAC_TALKED
	ask_question_jump Text0635, .ows_e4d9
	print_npc_text Text0636
	quit_script_fully

.ows_e4d9
	print_npc_text Text0637
	start_duel PRIZES_6, ZAPPING_SELFDESTRUCT_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatIsaac:
	start_script
	jump_if_event_true EVENT_BEAT_ISAAC, Script_LostToIsaac.ows_e517
	print_npc_text Text0638
	max_out_event_value EVENT_BEAT_ISAAC
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_ISAAC
	record_master_win $04
	print_npc_text Text0639
	give_booster_packs BOOSTER_MYSTERY_LIGHTNING_COLORLESS, BOOSTER_MYSTERY_LIGHTNING_COLORLESS, NO_BOOSTER
	print_npc_text Text063a
	quit_script_fully

Script_LostToIsaac:
	start_script
	jump_if_event_true EVENT_BEAT_ISAAC, .ows_e522
	print_text_quit_fully Text063b

.ows_e503
	print_npc_text Text063c
	ask_question_jump Text0635, .ows_e50f
	print_npc_text Text063d
	quit_script_fully

.ows_e50f
	print_npc_text Text063e
	start_duel PRIZES_6, ZAPPING_SELFDESTRUCT_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_e517
	print_npc_text Text063f
	give_booster_packs BOOSTER_MYSTERY_LIGHTNING_COLORLESS, BOOSTER_MYSTERY_LIGHTNING_COLORLESS, NO_BOOSTER
	print_npc_text Text0640
	quit_script_fully

.ows_e522
	print_text_quit_fully Text0641
