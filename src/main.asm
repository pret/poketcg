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

SECTION "Bank 3", ROMX
INCLUDE "engine/bank03.asm"

SECTION "Bank 4", ROMX
INCLUDE "engine/bank04.asm"

SECTION "AI Logic 1", ROMX
INCLUDE "data/deck_ai_pointers.asm"
INCLUDE "engine/ai/core.asm"

SECTION "Menus 2", ROMX
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
INCLUDE "engine/sprite_vblank.asm"

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
INCLUDE "engine/ai/trainer_cards.asm"
INCLUDE "engine/ai/pkmn_powers.asm"
INCLUDE "engine/ai/common.asm"

SECTION "Effect Functions", ROMX
INCLUDE "engine/effect_functions.asm"

SECTION "Decks", ROMX
INCLUDE "data/decks.asm"

SECTION "Cards", ROMX
INCLUDE "data/cards.asm"

SECTION "Bank 1C", ROMX
INCLUDE "engine/bank1c.asm"

SECTION "Bank 20", ROMX
INCLUDE "engine/bank20.asm"
