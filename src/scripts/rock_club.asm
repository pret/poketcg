RockClubAfterDuel:
	ld hl, .after_duel_table
	call FindEndOfDuelScript
	ret

.after_duel_table
	db NPC_RYAN
	db NPC_RYAN
	dw Script_BeatRyan
	dw Script_LostToRyan

	db NPC_ANDREW
	db NPC_ANDREW
	dw Script_BeatAndrew
	dw Script_LostToAndrew

	db NPC_GENE
	db NPC_GENE
	dw Script_BeatGene
	dw Script_LostToGene
	db $00

Script_Ryan:
	start_script
	try_give_pc_pack $03
	print_npc_text Text0795
	ask_question_jump Text0796, .ows_dfff
	print_npc_text Text0797
	quit_script_fully

.ows_dfff
	print_npc_text Text0798
	start_duel PRIZES_3, EXCAVATION_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatRyan:
	start_script
	print_npc_text Text0799
	give_booster_packs BOOSTER_EVOLUTION_FIGHTING, BOOSTER_EVOLUTION_FIGHTING, NO_BOOSTER
	print_npc_text Text079a
	quit_script_fully

Script_LostToRyan:
	start_script
	print_text_quit_fully Text079b

Script_Andrew:
	start_script
	try_give_pc_pack $03
	print_npc_text Text079c
	ask_question_jump Text079d, .ows_e026
	print_npc_text Text079e
	quit_script_fully

.ows_e026
	print_npc_text Text079f
	start_duel PRIZES_4, BLISTERING_POKEMON_DECK_ID, MUSIC_DUEL_THEME_1
	quit_script_fully

Script_BeatAndrew:
	start_script
	print_npc_text Text07a0
	give_booster_packs BOOSTER_COLOSSEUM_FIGHTING, BOOSTER_COLOSSEUM_FIGHTING, NO_BOOSTER
	print_npc_text Text07a1
	quit_script_fully

Script_LostToAndrew:
	start_script
	print_text_quit_fully Text07a2

Script_Gene:
	start_script
	try_give_pc_pack $03
	jump_if_event_true EVENT_BEAT_GENE, Script_LostToGene.ows_e07b
	print_npc_text Text07a3
	ask_question_jump Text07a4, .ows_e051
	print_npc_text Text07a5
	quit_script_fully

.ows_e051
	print_npc_text Text07a6
	start_duel PRIZES_6, ROCK_CRUSHER_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

Script_BeatGene:
	start_script
	jump_if_event_true EVENT_BEAT_GENE, Script_LostToGene.ows_e08f
	print_npc_text Text07a7
	max_out_event_value EVENT_BEAT_GENE
	try_give_medal_pc_packs
	show_medal_received_screen EVENT_BEAT_GENE
	record_master_win $02
	print_npc_text Text07a8
	give_booster_packs BOOSTER_MYSTERY_FIGHTING_COLORLESS, BOOSTER_MYSTERY_FIGHTING_COLORLESS, NO_BOOSTER
	print_npc_text Text07a9
	quit_script_fully

Script_LostToGene:
	start_script
	jump_if_event_true EVENT_BEAT_GENE, .ows_e09a
	print_text_quit_fully Text07aa

.ows_e07b
	print_npc_text Text07ab
	ask_question_jump Text07a4, .ows_e087
	print_npc_text Text07ac
	quit_script_fully

.ows_e087
	print_npc_text Text07ad
	start_duel PRIZES_6, ROCK_CRUSHER_DECK_ID, MUSIC_DUEL_THEME_2
	quit_script_fully

.ows_e08f
	print_npc_text Text07ae
	give_booster_packs BOOSTER_MYSTERY_FIGHTING_COLORLESS, BOOSTER_MYSTERY_FIGHTING_COLORLESS, NO_BOOSTER
	print_npc_text Text07af
	quit_script_fully

.ows_e09a
	print_text_quit_fully Text07b0
	ret
