INCLUDE "macros.asm"
INCLUDE "constants.asm"

INCLUDE "engine/home.asm"

SECTION "Game Loop", ROMX
INCLUDE "engine/game_loop.asm"

SECTION "Duel Core", ROMX
INCLUDE "engine/duel/core.asm"

SECTION "Menus Common", ROMX
INCLUDE "engine/menus/common.asm"

SECTION "Menus", ROMX
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

SECTION "Bank 4", ROMX
INCLUDE "engine/bank04.asm"

SECTION "AI Logic 1", ROMX
INCLUDE "data/deck_ai_pointers.asm"
INCLUDE "engine/ai/core.asm"

SECTION "Bank 6", ROMX
INCLUDE "engine/bank06.asm"

SECTION "Bank 7", ROMX
INCLUDE "engine/bank07.asm"

SECTION "Credits Sequence", ROMX
INCLUDE "engine/sequences/credits_sequence_commands.asm"
INCLUDE "data/sequences/credits_sequence.asm"

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
