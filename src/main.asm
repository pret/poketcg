INCLUDE "macros.asm"
INCLUDE "constants.asm"

INCLUDE "engine/home.asm"

SECTION "Game Loop", ROMX
INCLUDE "engine/game_loop.asm"

SECTION "Duel Core", ROMX
INCLUDE "engine/duel/core.asm"

SECTION "Menus Common", ROMX
INCLUDE "engine/menus/common.asm"

SECTION "Menus 1", ROMX
INCLUDE "engine/menus/duel.asm"
INCLUDE "engine/menus/deck_selection.asm"
INCLUDE "engine/menus/deck_check.asm"
INCLUDE "engine/menus/deck_configuration.asm"
INCLUDE "engine/menus/card_album.asm"
INCLUDE "engine/menus/printer.asm"
INCLUDE "engine/menus/deck_machine.asm"

SECTION "Overworld Scripting", ROMX
INCLUDE "engine/overworld/overworld.asm"
INCLUDE "engine/overworld/scripting.asm"

SECTION "Menus 2", ROMX
INCLUDE "engine/menus/init_menu.asm"
INCLUDE "engine/menus/status.asm"
INCLUDE "engine/menus/diary.asm"
INCLUDE "engine/menus/print_stats.asm"
INCLUDE "engine/menus/medal.asm"
INCLUDE "engine/menus/give_booster_pack.asm"
INCLUDE "engine/menus/duel_init.asm"
INCLUDE "engine/menus/pc_glossary.asm"
INCLUDE "engine/menus/config.asm"
INCLUDE "engine/menus/mail.asm"

SECTION "Color", ROMX
INCLUDE "engine/gfx/color.asm"

SECTION "Gift Center Menu", ROMX
INCLUDE "engine/menus/gift_center.asm"

SECTION "Overworld Map", ROMX
INCLUDE "engine/overworld_map.asm"
INCLUDE "engine/menus/labels.asm"

SECTION "Save", ROMX
INCLUDE "engine/save.asm"

SECTION "Map Scripts", ROMX
INCLUDE "data/map_scripts.asm"
INCLUDE "engine/overworld/npcs.asm"
INCLUDE "data/duel/duel_configurations.asm"
INCLUDE "data/script_table.asm"
INCLUDE "data/multichoice.asm"
INCLUDE "data/overworld_map/player_movement_paths.asm"

SECTION "Menus 3", ROMX
INCLUDE "engine/menus/debug_main.asm"
INCLUDE "engine/menus/main_menu.asm"
INCLUDE "engine/menus/debug.asm"
INCLUDE "engine/menus/wait_keys.asm"
INCLUDE "engine/gfx/default_palettes.asm"
INCLUDE "engine/menus/naming.asm"

SECTION "Sprite Animations", ROMX
INCLUDE "engine/gfx/sprite_animations.asm"

SECTION "Scenes", ROMX
INCLUDE "engine/scenes.asm"

SECTION "Challenge Machine", ROMX
INCLUDE "engine/challenge_machine.asm"

SECTION "Map Objects", ROMX
INCLUDE "data/npc_map_data.asm"
INCLUDE "data/map_objects.asm"

SECTION "AI Logic 1", ROMX
INCLUDE "data/deck_ai_pointers.asm"
INCLUDE "engine/duel/ai/core.asm"

SECTION "Menus 4", ROMX
INCLUDE "engine/copy_card_name.asm"
INCLUDE "engine/menus/play_area.asm"
INCLUDE "engine/menus/glossary.asm"
INCLUDE "engine/menus/unknown.asm"

SECTION "Effect Commands", ROMX
INCLUDE "engine/duel/effect_commands.asm"

SECTION "Animation Commands", ROMX
INCLUDE "engine/duel/animations/commands.asm"

SECTION "IR Communications Core", ROMX
INCLUDE "engine/link/ir_core.asm"

SECTION "Sprite Animations VBlank", ROMX
INCLUDE "engine/gfx/sprite_vblank.asm"

SECTION "Starter Deck", ROMX
INCLUDE "engine/starter_deck.asm"

SECTION "Link Functions", ROMX
INCLUDE "engine/link/ir_functions.asm"
INCLUDE "engine/link/card_pop.asm"
INCLUDE "engine/link/printer.asm"
INCLUDE "engine/link/link_duel.asm"

SECTION "Promotional Card", ROMX
INCLUDE "engine/promotional_card.asm"

SECTION "Booster Pack Menu", ROMX
INCLUDE "engine/menus/booster_pack.asm"

SECTION "Unused Save Validation", ROMX
INCLUDE "engine/unused_save_validation.asm"

SECTION "Input Name", ROMX
INCLUDE "engine/input_name.asm"

SECTION "Auto Deck Machines", ROMX
INCLUDE "engine/auto_deck_machines.asm"

SECTION "Bank 7", ROMX
INCLUDE "engine/bank07.asm"

SECTION "Duel Animations", ROMX
INCLUDE "engine/duel/animations/core.asm"
INCLUDE "engine/duel/animations/screen_effects.asm"
INCLUDE "data/duel/animations/duel_animations.asm"

SECTION "Start Menu", ROMX
INCLUDE "engine/menus/start.asm"

SECTION "Intro Sequence", ROMX
INCLUDE "engine/intro.asm"
INCLUDE "engine/sequences/intro_sequence_commands.asm"

SECTION "Unused Copyright", ROMX
INCLUDE "engine/unused_copyright.asm"

SECTION "Credits Sequence", ROMX
INCLUDE "engine/credits.asm"
INCLUDE "engine/sequences/credits_sequence_commands.asm"
INCLUDE "data/sequences/credits.asm"

SECTION "Booster Packs", ROMX
INCLUDE "engine/booster_packs.asm"

SECTION "AI Logic 2", ROMX
INCLUDE "engine/duel/ai/trainer_cards.asm"
INCLUDE "engine/duel/ai/pkmn_powers.asm"
INCLUDE "engine/duel/ai/common.asm"

SECTION "Effect Functions", ROMX
INCLUDE "engine/duel/effect_functions.asm"

SECTION "Decks", ROMX
INCLUDE "data/decks.asm"

SECTION "Cards", ROMX
INCLUDE "data/cards.asm"

SECTION "SGB", ROMX
INCLUDE "engine/sgb.asm"

SECTION "Bank 20", ROMX
INCLUDE "engine/bank20.asm"

SECTION "Gfx", ROMX
INCLUDE "engine/gfx/gfx_table_pointers.asm"
INCLUDE "engine/gfx/tilemaps.asm"
INCLUDE "engine/gfx/tilesets.asm"
INCLUDE "engine/gfx/sprites.asm"
INCLUDE "data/sprite_animation_pointers.asm"
INCLUDE "data/palette_pointers.asm"
INCLUDE "data/maps/tilemaps.asm"
