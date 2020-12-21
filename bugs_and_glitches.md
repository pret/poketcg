# Bugs and Glitches

These are documented bugs and glitches in the original Pokémon Trading Card Game.

Fixes are written in the `diff` format.

```diff
 this is some code
-delete red - lines
+add green + lines
```

**Disclaimer regarding the fixes:** since the project is still in the process of being disassembled, applying code modifications that result in a different number of bytes in the instructions will lead to lots of pointer invalidation, which will potentially lead to crashes.

## Contents

- [AI wrongfully adds score twice for attaching energy to Arena card](#ai-wrongfully-adds-score-twice-for-attaching-energy-to-arena-card)
- [Cards in AI decks that are not supposed to be placed as Prize cards are ignored](#cards-in-ai-decks-that-are-not-supposed-to-be-placed-as-prize-cards-are-ignored)
- [AI score modifiers for retreating are never used](#ai-score-modifiers-for-retreating-are-never-used)
- [AI handles Basic Pokémon cards in hand wrong when scoring the use of Professor Oak](#ai-handles-basic-pokémon-cards-in-hand-wrong-when-scoring-the-use-of-professor-oak)
- [Rick never plays Energy Search](#rick-never-plays-energy-search)
- [Rick uses wrong Pokédex AI subroutine](#rick-uses-wrong-pokédex-ai-subroutine)
- [Chris never uses Revive on Kangaskhan](#chris-never-uses-revive-on-kangaskhan)
- [AI Pokemon Trader may result in unintended effects](#ai-pokemon-trader-may-result-in-unintended-effects)
- [AI never uses Energy Trans in order to retreat Arena card](#ai-never-uses-energy-trans-in-order-to-retreat-arena-card)
- [Sam's practice deck does wrong card ID check](#sams-practice-deck-does-wrong-card-id-check)
- [AI does not account for Mysterious Fossil or Clefairy Doll when using Shift Pkmn Power](#ai-does-not-account-for-mysterious-fossil-or-clefairy-doll-when-using-shift-pkmn-power)

## AI wrongfully adds score twice for attaching energy to Arena card

When the AI is scoring each Play Area Pokémon card to attach an Energy card, it first checks whether it's the Arena card and, if so, checks whether the attack can KO the Defending Pokémon. If it's true, then 20 is added to the score. Then it does the same Arena card check to increase the score further. The intention is probably to score the card with 20 if it can KO the opponent regardless of Play Area position, and additionally if it's the Arena card it should score 10 more points.

**Fix:** Edit `DetermineAIScoreOfMoveEnergyRequirement` in [src/engine/bank05.asm](https://github.com/pret/poketcg/blob/master/src/engine/bank05.asm):
```diff
DetermineAIScoreOfMoveEnergyRequirement: ; 16695 (5:6695)
 	...
-; if the move KOs player and this is the active card, add to AI score.
+; if the move KOs player add to AI score.
-	ldh a, [hTempPlayAreaLocation_ff9d]
-	or a
-	jr nz, .check_evolution
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr z, .move_kos_defending
	jr nc, .check_evolution
.move_kos_defending
	ld a, 20
	call AddToAIScore

-; this is possibly a bug.
-; this is an identical check as above to test whether this card is active.
-; in case it is active, the score gets added 10 more points,
-; in addition to the 20 points already added above.
-; what was probably intended was to add 20 points
-; plus 10 in case it is the Arena card.
+; add 10 more in case it's the Arena card
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .check_evolution
	ld a, 10
	call AddToAIScore
 	...
```

## Cards in AI decks that are not supposed to be placed as Prize cards are ignored

Each deck AI lists some card IDs that are not supposed to be placed as Prize cards in the beginning of the duel. If the deck configuration after the initial shuffling results in any of these cards being placed as Prize cards, the game is supposed to reshuffle the deck. An example of such a list, for the Go GO Rain Dance deck, is:
```
.list_prize ; 14fe6 (5:4fe6)
	db GAMBLER
	db ENERGY_RETRIEVAL
	db SUPER_ENERGY_RETRIEVAL
	db BLASTOISE
	db $00
```

However, the routine to iterate these lists and look for these cards is buggy, which results in the game ignoring it completely.

**Fix:** Edit `SetUpBossStartingHandAndDeck` in [src/engine/bank05.asm](https://github.com/pret/poketcg/blob/master/src/engine/bank05.asm):
```diff
SetUpBossStartingHandAndDeck: ; 172af (5:72af)
	...
-; expectation: return carry if card ID corresponding
+; return carry if card ID corresponding
; to the input deck index is listed in wAICardListAvoidPrize;
-; reality: always returns no carry because when checking terminating
-; byte in wAICardListAvoidPrize ($00), it wrongfully uses 'cp a' instead of 'or a',
-; so it always ends up returning in the first item in list.
; input:
;	- a = deck index of card to check
.CheckIfIDIsInList ; 17366 (5:7366)
	ld b, a
	ld a, [wAICardListAvoidPrize + 1]
	or a
	ret z ; null
	push hl
	ld h, a
	ld a, [wAICardListAvoidPrize]
	ld l, a

	ld a, b
	call GetCardIDFromDeckIndex
.loop_id_list
	ld a, [hli]
-	cp a ; bug, should be 'or a'
+	or a
	jr z, .false
	cp e
	jr nz, .loop_id_list

; true
	pop hl
	scf
	ret
.false
	pop hl
	or a
	ret
```

## AI score modifiers for retreating are never used

Each deck AI lists some Pokémon card IDs that have an associated score for retreating. That way, the game can fine-tune the likelihood that the AI duelist will retreat to a given Pokémon from the bench. For example, the Legendary Dragonite deck has the following list of retreat score modifiers:
```
.list_retreat ; 14d99 (5:4d99)
	ai_retreat CHARMANDER, -1
	ai_retreat MAGIKARP,   -5
	db $00
```

However, the game never actually stores the pointer to these lists (a notable expection being the Legendary Moltres deck), so the AI cannot access these score modifiers.

**Fix:** Edit all applicable decks in `src/engine/deck_ai/decks/`, uncommenting the following line:
```diff
.store_list_pointers
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
-	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
+	store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
```

## AI handles Basic Pokémon cards in hand wrong when scoring the use of Professor Oak

When the AI is checking whether to play Professor Oak or not, it does a hand check to see if there are any Basic/Evolved Pokémon cards. One of these checks is supposed to add to the score if there are Basic Pokémon in hand, but as it is coded, it will never execute the score addition.

**Fix:** Edit `AIDecide_ProfessorOak` in [src/engine/bank08.asm](https://github.com/pret/poketcg/blob/master/src/engine/bank08.asm):
```diff
AIDecide_ProfessorOak: ; 20cc1 (8:4cc1)
 	...
-; this part seems buggy
-; the AI loops through all the cards in hand and checks
-; if any of them is not a Pokemon card and has Basic stage.
-; it seems like the intention was that if there was
-; any Basic Pokemon still in hand, the AI would add to the score.
.check_hand
	call CreateHandCardList
	ld hl, wDuelTempList
.loop_hand
	ld a, [hli]
	cp $ff
	jr z, .check_evolution

	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, [wLoadedCard1Type]
	cp TYPE_ENERGY
-	jr c, .loop_hand ; bug, should be jr nc
+	jr nc, .loop_hand
 	...
```

## Rick never plays Energy Search

The AI's decision to play Energy Search has two special cases: one for the Heated Battle deck and the other for the Wonders of Science deck. The former calls a subroutine to check only for Fire and Lightning energy cards in the deck, and the latter only checks for... Fire and Lightning energy cards. In a deck filled only with Grass and Psychic types. Needless is to say, poor Rick never finds any of those energy cards in the deck, so the Energy Search card is left forever unplayed. There's an unreferenced subroutine that looks for Grass energy that is supposed to be used instead.

**Fix:** Edit `AIDecide_EnergySearch` in [src/engine/bank08.asm](https://github.com/pret/poketcg/blob/master/src/engine/bank08.asm):
```diff
AIDecide_EnergySearch: ; 211aa (8:51aa)
 	...
-; this subroutine has a bug.
-; it was supposed to use the .CheckUsefulGrassEnergy subroutine
-; but uses .CheckUsefulFireOrLightningEnergy instead.
.wonders_of_science
	ld a, CARD_LOCATION_DECK
	call FindBasicEnergyCardsInLocation
	jr c, .no_carry
-	call .CheckUsefulFireOrLightningEnergy
+	call .CheckUsefulGrassEnergy
	jr c, .no_carry
	scf
	ret
 	...
```

## Rick uses wrong Pokédex AI subroutine

Seems Rick can't catch a break. When deciding which cards to prioritize in the Pokédex card effect, the AI checks if it's playing the Wonders of Science deck, then completely disregards the result and jumps unconditionally. Thus, Rick uses the generic algorithm for sorting the deck cards.

**Fix:** Edit `AIDecide_Pokedex` in [src/engine/bank08.asm](https://github.com/pret/poketcg/blob/master/src/engine/bank08.asm):
```diff
AIDecide_Pokedex: ; 212dc (8:52dc)
 	...
.pick_cards
-; the following comparison is disregarded
-; the Wonders of Science deck was probably intended
-; to use PickPokedexCards_Unreferenced instead
	ld a, [wOpponentDeckID]
	cp WONDERS_OF_SCIENCE_DECK_ID
-	jp PickPokedexCards ; bug, should be jp nz
+	jp nz, PickPokedexCards
+	; fallthrough

; picks order of the cards in deck from the effects of Pokedex.
; prioritizes Pokemon cards, then Trainer cards, then energy cards.
; stores the resulting order in wce1a.
-PickPokedexCards_Unreferenced: ; 212ff (8:52ff)
-; unreferenced
	xor a
	ld [wAIPokedexCounter], a ; reset counter
 	...
```

## Chris never uses Revive on Kangaskhan

Because of an error in the AI logic, Chris never considers using Revive on a Kangaskhan card in the Discard Pile, even though it is listed as one of the cards for the AI to check.

**Fix:** Edit `AIDecide_Revive` in [src/engine/bank08.asm](https://github.com/pret/poketcg/blob/master/src/engine/bank08.asm):
```diff
AIDecide_Revive: ; 218a9 (8:58a9)
 	...
-; these checks have a bug.
-; it works fine for Hitmonchan and Hitmonlee,
-; but in case it's a Tauros card, the routine will fallthrough
-; into the Kangaskhan check. since it will never be equal to Kangaskhan,
-; it will fallthrough into the set carry branch.
-; in case it's a Kangaskhan card, the check will fail in the Tauros check
-; and jump back into the loop. so just by accident the Tauros check works,
-; but Kangaskhan will never be correctly checked because of this.
	cp HITMONCHAN
	jr z, .set_carry
	cp HITMONLEE
	jr z, .set_carry
	cp TAUROS
-	jr nz, .loop_discard_pile ; bug, these two lines should be swapped
+	jr z, .set_carry
	cp KANGASKHAN
-	jr z, .set_carry ; bug, these two lines should be swapped
+	jr nz, .loop_discard_pile
 	...
```

## AI Pokemon Trader may result in unintended effects

A missing line in AI logic might result in strange behavior when executing the effect of Pokémon Trader for Power Generator deck.

**Fix:** Edit `AIDecide_PokemonTrader_PowerGenerator` in [src/engine/bank08.asm](https://github.com/pret/poketcg/blob/master/src/engine/bank08.asm):
```diff
AIDecide_PokemonTrader_PowerGenerator: ; 2200b (8:600b)
 	...
	call LookForCardIDInDeck_GivenCardIDInHand
	jr c, .find_duplicates
-	; bug, missing jr .no_carry
+	jr .no_carry

-; since this last check falls through regardless of result,
-; register a might hold an invalid deck index,
-; which might lead to hilarious results like Brandon
-; trading a Pikachu with a Grass Energy from the deck.
-; however, since it's deep in a tower of conditionals,
-; reaching here is extremely unlikely.

; a card in deck was found to look for,
; check if there are duplicates in hand to trade with.
 	...
```

## AI never uses Energy Trans in order to retreat Arena card

There is a mistake in the AI retreat logic, in [src/engine/deck_ai/decks/general.asm](https://github.com/pret/poketcg/blob/master/src/engine/deck_ai/decks/general.asm):
```
.used_switch
; if AI used switch, unset its AI flag
	ld a, [wPreviousAIFlags]
	and ~AI_FLAG_USED_SWITCH ; clear Switch flag
	ld [wPreviousAIFlags], a

; bug, this doesn't make sense being here, since at this point
; Switch Trainer card was already used to retreat the Pokemon.
; what the routine will do is just transfer Energy cards to
; the Arena Pokemon for the purpose of retreating, and
; then not actually retreat, resulting in unusual behaviour.
; this would only work placed right after the AI checks whether
; they have Switch card in hand to use and doesn't have one.
; (and probably that was the original intention.)
	ld a, AI_ENERGY_TRANS_RETREAT ; retreat
	farcall HandleAIEnergyTrans
	ret
```

**Fix:** TODO

## Sam's practice deck does wrong card ID check

There is a mistake in the AI logic for deciding which Pokémon for Sam to switch to, in [src/engine/deck_ai/decks/sams_practice.asm](https://github.com/pret/poketcg/blob/master/src/engine/deck_ai/decks/sams_practice.asm):
```
; this is a bug, it's attempting to compare a card ID with a deck index.
; the intention was to change the card to switch to depending on whether
; the first Machop was KO'd at this point in the Duel or not.
; because of the buggy comparison, this will always jump the
; 'inc a' instruction and switch to PLAY_AREA_BENCH_1.
; in a normal Practice Duel following Dr. Mason's instructions,
; this will always lead to the AI correctly switching Raticate with Machop,
; but in case of a "Free" Duel where the first Machop is not KO'd,
; the intention was to switch to PLAY_AREA_BENCH_2 instead.
; but due to 'inc a' always being skipped, it will switch to Raticate.
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp MACHOP ; wrong
	ld a, PLAY_AREA_BENCH_1
	jr nz, .retreat
	inc a ; PLAY_AREA_BENCH_2
```

**Fix:** Edit `AIDecide_PokemonTrader_PowerGenerator` in [src/engine/bank08.asm](https://github.com/pret/poketcg/blob/master/src/engine/bank08.asm):
```diff
AIPerformScriptedTurn: ; 1483a (5:483a)
 	...
-; this is a bug, it's attempting to compare a card ID with a deck index.
-; the intention was to change the card to switch to depending on whether
-; the first Machop was KO'd at this point in the Duel or not.
-; because of the buggy comparison, this will always jump the
-; 'inc a' instruction and switch to PLAY_AREA_BENCH_1.
-; in a normal Practice Duel following Dr. Mason's instructions,
-; this will always lead to the AI correctly switching Raticate with Machop,
-; but in case of a "Free" Duel where the first Machop is not KO'd,
-; the intention was to switch to PLAY_AREA_BENCH_2 instead.
-; but due to 'inc a' always being skipped, it will switch to Raticate.
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
+	call GetCardIDFromDeckIndex
+	ld a, e
-	cp MACHOP ; wrong
+	cp MACHOP
	ld a, PLAY_AREA_BENCH_1
	jr nz, .retreat
	inc a ; PLAY_AREA_BENCH_2

.retreat
	call AITryToRetreat
	ret
 	...
```

## AI does not account for Mysterious Fossil or Clefairy Doll when using Shift Pkmn Power

**Fix:** Edit `HandleAIShift` in [src/engine/bank08.asm](https://github.com/pret/poketcg/blob/master/src/engine/bank08.asm):
```diff
HandleAIShift: ; 22476 (8:6476)
 	...
.CheckWhetherTurnDuelistHasColor ; 224c6 (8:64c6)
	ld a, [wAIDefendingPokemonWeakness]
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
.loop_play_area
	ld a, [hli]
	cp $ff
	jr z, .false
	push bc
	call GetCardIDFromDeckIndex
	call GetCardType
-	; in case this is a Mysterious Fossil or Clefairy Doll card,
-	; AI might read the type of the card incorrectly here.
-	; uncomment the following lines to account for this
-	; cp TYPE_TRAINER
-	; jr nz, .not_trainer
-	; pop bc
-	; jr .loop_play_area
-; .not_trainer
+	cp TYPE_TRAINER
+	jr nz, .not_trainer
+	pop bc
+	jr .loop_play_area
+.not_trainer
	call TranslateColorToWR
	pop bc
	and b
	jr z, .loop_play_area
; true
	scf
	ret
.false
	or a
	ret
 	...
```
