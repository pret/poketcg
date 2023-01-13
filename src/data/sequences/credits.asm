INCLUDE "macros/credits_sequence.asm"

CreditsSequence:
	credits_seq_disable_lcd
	credits_seq_load_ow_map 0, 0, OVERWORLD_MAP
	credits_seq_init_volcano_sprite
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_print_text_box 2, 1, OverworldMapPokemonDomeText
	credits_seq_print_text 0, 0, PokemonTradingCardGameStaffText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 32, 144, 0
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_ow_map 0, 0, MASON_LABORATORY
	credits_seq_load_npc 14, 6, SOUTH, NPC_DRMASON
	credits_seq_load_npc 4, 14, EAST, NPC_SAM
	credits_seq_load_npc 6, 4, SOUTH, NPC_TECH5
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 3
	credits_seq_print_text 0, 0, ProducersText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_ow_map 0, 0, DECK_MACHINE_ROOM
	credits_seq_load_npc 6, 8, SOUTH, NPC_TECH6
	credits_seq_load_npc 6, 22, WEST, NPC_TECH7
	credits_seq_load_npc 10, 18, WEST, NPC_TECH8
	credits_seq_load_npc 12, 12, WEST, NPC_AARON
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, DirectorText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_club_map 0
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 5
	credits_seq_print_text 0, 0, ProgrammersText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_club_map 1
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, GBGraphicDesigners1Text
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_draw_rectangle 4, 3
	credits_seq_print_text 0, 4, GBGraphicDesigners2Text
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_draw_rectangle 4, 3
	credits_seq_print_text 0, 4, GBGraphicDesigners3Text
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_club_map 2
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, MusicText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 5
	credits_seq_print_text 0, 0, SoundEffectsText
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_club_map 3
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, SoundDirectorText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 5
	credits_seq_print_text 0, 0, SoundSystemSupportText
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 112, 32
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_booster 6, 3, SCENE_CHARIZARD_INTRO
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 6
	credits_seq_print_text 0, 0, CardGameCreator1Text
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_booster 6, 3, SCENE_SCYTHER_INTRO
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 5
	credits_seq_print_text 0, 0, CardGameCreator2Text
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_booster 6, 3, SCENE_AERODACTYL_INTRO
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 5
	credits_seq_print_text 0, 0, CardGameCreator3Text
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_ow_map 0, 0, ISHIHARAS_HOUSE
	credits_seq_load_npc 8, 8, SOUTH, NPC_ISHIHARA
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 8
	credits_seq_print_text 0, 0, CardIllustrators1Text
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 96, 48
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_draw_rectangle 4, 4
	credits_seq_print_text 0, 4, CardIllustrators2Text
	credits_seq_transform_overlay 0, 24, 96, 48
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_ow_map 16, 8, LIGHTNING_CLUB_LOBBY
	credits_seq_load_npc 6, 4, SOUTH, NPC_CLERK10
	credits_seq_load_npc 10, 4, SOUTH, NPC_GIFT_CENTER_CLERK
	credits_seq_load_npc 18, 16, WEST, NPC_CHAP2
	credits_seq_load_npc 18, 2, NORTH, NPC_IMAKUNI
	credits_seq_load_npc 8, 12, SOUTH, NPC_LASS4
	credits_seq_load_npc 20, 8, SOUTH, NPC_HOOD1
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 8
	credits_seq_print_text 0, 0, SpecialAppearances1Text
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 112, 32
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_draw_rectangle 4, 4
	credits_seq_print_text 0, 4, SpecialAppearances2Text
	credits_seq_transform_overlay 0, 24, 112, 32
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_ow_map 48, 0, CHALLENGE_HALL
	credits_seq_load_npc 14, 4, SOUTH, NPC_HOST
	credits_seq_load_npc 18, 8, WEST, NPC_RONALD1
	credits_seq_load_npc 12, 8, EAST, NPC_PLAYER_CREDITS
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, USCoordination1Text
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 32, 144, 0
	credits_seq_transform_overlay 0, 32, 112, 32
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 32, 144, 0
	credits_seq_draw_rectangle 4, 4
	credits_seq_print_text 0, 5, USCoordination2Text
	credits_seq_transform_overlay 0, 32, 112, 32
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 32, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, USCoordination3Text
	credits_seq_transform_overlay 0, 40, 144, 0
	credits_seq_transform_overlay 0, 40, 112, 32
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 40, 144, 0
	credits_seq_draw_rectangle 6, 4
	credits_seq_print_text 0, 6, USCoordination4Text
	credits_seq_transform_overlay 0, 40, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 40, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_booster 6, 3, SCENE_COLOSSEUM_BOOSTER
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 8
	credits_seq_print_text 0, 0, TranslationDraftText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_booster 6, 3, SCENE_EVOLUTION_BOOSTER
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 6
	credits_seq_print_text 0, 0, MasteringText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_booster 6, 3, SCENE_MYSTERY_BOOSTER
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 6
	credits_seq_print_text 0, 0, ManualCreationText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_booster 6, 3, SCENE_LABORATORY_BOOSTER
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 6
	credits_seq_print_text 0, 0, ManualIllustrationsText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_club_map 4
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, PokemonOriginalStoryText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, CreatedInCooperationWithText
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_club_map 5
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, WithCooperation1Text
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_draw_rectangle 4, 5
	credits_seq_print_text 0, 4, WithCooperation2Text
	credits_seq_transform_overlay 0, 24, 96, 48
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_draw_rectangle 4, 4
	credits_seq_print_text 0, 4, WithCooperation3Text
	credits_seq_transform_overlay 0, 24, 96, 48
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_club_map 6
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 8
	credits_seq_print_text 0, 0, ProjectManagerText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 120, 24
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_club_map 7
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, SupervisorText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_club_map 8
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, ExecutiveProducerText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_ow_map 16, 16, HALL_OF_HONOR
	credits_seq_load_npc 10, 8, NORTH, NPC_LEGENDARY_CARD_TOP_LEFT
	credits_seq_load_npc 12, 8, NORTH, NPC_LEGENDARY_CARD_TOP_RIGHT
	credits_seq_load_npc 8, 10, NORTH, NPC_LEGENDARY_CARD_LEFT_SPARK
	credits_seq_load_npc 10, 10, NORTH, NPC_LEGENDARY_CARD_BOTTOM_LEFT
	credits_seq_load_npc 12, 10, NORTH, NPC_LEGENDARY_CARD_BOTTOM_RIGHT
	credits_seq_load_npc 14, 10, NORTH, NPC_LEGENDARY_CARD_RIGHT_SPARK
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_draw_rectangle 0, 7
	credits_seq_print_text 0, 0, CreatedByText
	credits_seq_fade_in
	credits_seq_wait 60
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 24, 104, 40
	credits_seq_wait 225
	credits_seq_transform_overlay 0, 24, 144, 0
	credits_seq_transform_overlay 0, 0, 144, 0
	credits_seq_fade_out

	credits_seq_load_scene 0, 0, SCENE_COMPANIES
	credits_seq_init_overlay 0, 0, 144, 0
	credits_seq_fade_in
	credits_seq_wait 225
	credits_seq_end
