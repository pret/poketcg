; AI card retreat score bonus
; when the AI retreat routine runs through the Bench to choose
; a Pokemon to switch to, it looks up in this list and if
; a card ID matches, applies a retreat score bonus to this card.
; positive (negative) means more (less) likely to switch to this card.
ai_retreat: MACRO
	db \1       ; card ID
	db $80 + \2 ; retreat score (ranges between -128 and 127)
ENDM

; AI card energy attach score bonus
; when the AI energy attachment routine runs through the Play Area to choose
; a Pokemon to attach an energy card, it looks up in this list and if
; a card ID matches, skips this card if the maximum number of energy
; cards attached has been reached. If it hasn't been reached, additionally
; applies a positive (or negative) AI score to attach energy to this card.
ai_energy: MACRO
	db \1       ; card ID
	db \2       ; maximum number of attached cards
	db $80 + \3 ; energy score (ranges between -128 and 127)
ENDM

; stores in WRAM pointer to data in argument
; e.g. store_list_pointer wSomeListPointer, SomeData
store_list_pointer: MACRO
	ld hl, \1
	ld de, \2
	ld [hl], e
	inc hl
	ld [hl], d
ENDM

; deck AIs are specialized to work on a given deck ID.
; they decide what happens during a turn, what Pokemon cards
; to pick during the start of the duel, etc.
; the different scenarios these are used are listed in AIACTION_* constants.
; each of these have a pointer table with the following structure:
; dw .do_turn       : never called;
;
; dw .do_turn       : called to handle the main turn logic, from the beginning
;                     of the turn up to the attack (or lack thereof);
;
; dw .start_duel    : called at the start of the duel to initialize some
;                     variables and optionally set up CPU hand and deck;
;
; dw .forced_switch : logic to determine what Pokemon to pick when there's
;                     an effect that forces AI to switch to Bench card;
;
; dw .ko_switch     : logic for picking which card to use after a KO;
;
; dw .take_prize    : logic to decide which prize card to pick.

; optionally, decks can also declare card lists that will add
; more specialized logic during various generic AI routines,
; and read during the .start_duel routines.
; the pointers to these lists are stored in memory:
; wAICardListAvoidPrize    : list of cards to avoid being placed as prize;
; wAICardListArenaPriority : priority list of Arena card at duel start;
; wAICardListBenchPriority : priority list of Bench cards at duel start;
; wAICardListPlayFromHandPriority : priority list of cards to play from hand;
; wAICardListRetreatBonus  : scores given to certain cards for retreat;
; wAICardListEnergyBonus   : max number of energy cards and card scores.

INCLUDE "engine/deck_ai/decks/general.asm"
INCLUDE "engine/deck_ai/decks/sams_practice.asm"
INCLUDE "engine/deck_ai/decks/general_no_retreat.asm"
INCLUDE "engine/deck_ai/decks/legendary_moltres.asm"
INCLUDE "engine/deck_ai/decks/legendary_zapdos.asm"
INCLUDE "engine/deck_ai/decks/legendary_articuno.asm"
INCLUDE "engine/deck_ai/decks/legendary_dragonite.asm"
INCLUDE "engine/deck_ai/decks/first_strike.asm"
INCLUDE "engine/deck_ai/decks/rock_crusher.asm"
INCLUDE "engine/deck_ai/decks/go_go_rain_dance.asm"
INCLUDE "engine/deck_ai/decks/zapping_selfdestruct.asm"
INCLUDE "engine/deck_ai/decks/flower_power.asm"
INCLUDE "engine/deck_ai/decks/strange_psyshock.asm"
INCLUDE "engine/deck_ai/decks/wonders_of_science.asm"
INCLUDE "engine/deck_ai/decks/fire_charge.asm"
INCLUDE "engine/deck_ai/decks/im_ronald.asm"
INCLUDE "engine/deck_ai/decks/powerful_ronald.asm"
INCLUDE "engine/deck_ai/decks/invincible_ronald.asm"
INCLUDE "engine/deck_ai/decks/legendary_ronald.asm"
