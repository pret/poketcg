# Bugs and Glitches

These are documented bugs and glitches in the original Pokémon Trading Card Game.

Fixes are written in the `diff` format.

```diff
 this is some code
-delete red - lines
+add green + lines
```

## Contents
- [Game engine](#game-engine)
  - [AI wrongfully adds score twice for attaching energy to Arena card](#ai-wrongfully-adds-score-twice-for-attaching-energy-to-arena-card)
  - [Cards in AI decks that are not supposed to be placed as Prize cards are ignored](#cards-in-ai-decks-that-are-not-supposed-to-be-placed-as-prize-cards-are-ignored)
  - [AI score modifiers for retreating are never used](#ai-score-modifiers-for-retreating-are-never-used)
  - [AI handles Basic Pokémon cards in hand wrong when scoring Professor Oak use](#ai-handles-basic-pokémon-cards-in-hand-wrong-when-scoring-professor-oak-use)
  - [Rick never plays Energy Search](#rick-never-plays-energy-search)
  - [Rick uses wrong Pokédex AI subroutine](#rick-uses-wrong-pokédex-ai-subroutine)
  - [Chris never uses Revive on Kangaskhan](#chris-never-uses-revive-on-kangaskhan)
  - [AI Pokémon Trader may result in unintended effects](#ai-pokémon-trader-may-result-in-unintended-effects)
  - [AI Full Heal has flawed logic for sleep](#ai-full-heal-has-flawed-logic-for-sleep)
  - [AI Full Heal has flawed logic for paralysis](#ai-full-heal-has-flawed-logic-for-paralysis)
  - [AI might use a Pkmn Power as an attack](#ai-might-use-a-pkmn-power-as-an-attack)
  - [AI never uses Energy Trans in order to retreat Arena card](#ai-never-uses-energy-trans-in-order-to-retreat-arena-card)
  - [Sam's practice deck does wrong card ID check](#sams-practice-deck-does-wrong-card-id-check)
  - [AI does not use Shift properly](#ai-does-not-use-shift-properly)
  - [AI does not use Cowardice properly](#ai-does-not-use-cowardice-properly)
  - [Phantom Venusaur will never be obtained through Card Pop!](#phantom-venusaur-will-never-be-obtained-through-card-pop)
- [Graphics](#graphics)
  - [Water Club master room uses the wrong void color](#water-club-master-room-uses-the-wrong-void-color)
  - [Club entrances use incorrect medal emblem tiling](#club-entrances-use-incorrect-medal-emblem-tiling)
  - [Green NPCs have incorrect frame data](#green-npcs-have-incorrect-frame-data)
  - [Big Lightning animation has incorrect frame data](#big-lightning-animation-has-incorrect-frame-data)
  - [Dive Bomb animation has incorrect frame data](#dive-bomb-animation-has-incorrect-frame-data)
- [Text](#text)
  - [Both Ninetales cards misspell its name](#both-ninetales-cards-misspell-its-name)
  - [Challenge host uses wrong name for the first rival](#challenge-host-uses-wrong-name-for-the-first-rival)

## Game engine

### AI wrongfully adds score twice for attaching energy to Arena card

When the AI is scoring each Play Area Pokémon card to attach an Energy card, it first checks whether it's the Arena card and, if so, checks whether the attack can KO the Defending Pokémon. If it's true, then 20 is added to the score. Then it does the same Arena card check to increase the score further. The intention is probably to score the card with 20 if it can KO the opponent regardless of Play Area position, and additionally if it's the Arena card it should score 10 more points.

**Fix:** Edit `DetermineAIScoreOfAttackEnergyRequirement` in [src/engine/duel/ai/energy.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/energy.asm):
```diff
DetermineAIScoreOfAttackEnergyRequirement:
	...
-; if the attack KOs player and this is the active card, add to AI score.
+; if the attack KOs player add to AI score.
-	ldh a, [hTempPlayAreaLocation_ff9d]
-	or a
-	jr nz, .check_evolution
	ld a, [wSelectedAttack]
	call EstimateDamage_VersusDefendingCard
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	ld hl, wDamage
	sub [hl]
	jr z, .atk_kos_defending
	jr nc, .check_evolution
.atk_kos_defending
	ld a, 20
	call AIEncourage

-; this is possibly a bug.
-; this is an identical check as above to test whether this card is active.
+; add 10 more in case it's the Arena card
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .check_evolution
	ld a, 10
	call AIEncourage
	...
```

### Cards in AI decks that are not supposed to be placed as Prize cards are ignored

Each deck AI lists some card IDs that are not supposed to be placed as Prize cards in the beginning of the duel. If the deck configuration after the initial shuffling results in any of these cards being placed as Prize cards, the game is supposed to reshuffle the deck. An example of such a list, for the Go GO Rain Dance deck, is:
```
.list_prize 
	db GAMBLER
	db ENERGY_RETRIEVAL
	db SUPER_ENERGY_RETRIEVAL
	db BLASTOISE
	db $00
```

However, the routine to iterate these lists and look for these cards is buggy, as it will always return no carry because when checking terminating byte in wAICardListAvoidPrize ($00), it wrongfully uses 'cp a' instead of 'or a'. This results in the game ignoring it completely. 

**Fix:** Edit `SetUpBossStartingHandAndDeck` in [src/engine/duel/ai/boss_deck_set_up.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/boss_deck_set_up.asm):
```diff
SetUpBossStartingHandAndDeck:
	...
-; expectation: return carry if card ID corresponding
+; return carry if card ID corresponding
; to the input deck index is listed in wAICardListAvoidPrize;
-; reality: always returns no carry
; input:
;	- a = deck index of card to check
.CheckIfIDIsInList
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

### AI score modifiers for retreating are never used

Each deck AI lists some Pokémon card IDs that have an associated score for retreating. That way, the game can fine-tune the likelihood that the AI duelist will retreat to a given Pokémon from the bench. For example, the Legendary Dragonite deck has the following list of retreat score modifiers:
```
.list_retreat
	ai_retreat CHARMANDER, -1
	ai_retreat MAGIKARP,   -5
	db $00
```

However, the game never actually stores the pointer to these lists (a notable exception being the Legendary Moltres deck), so the AI cannot access these score modifiers.

**Fix:** Edit all applicable decks in `src/engine/duel/ai/decks/`, uncommenting the following line:
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

### AI handles Basic Pokémon cards in hand wrong when scoring Professor Oak use

When the AI is checking whether to play Professor Oak or not, it does a hand check to see if there are any Basic/Evolved Pokémon cards. One of these checks is supposed to add to the score if there are any Basic Pokémon in hand, but as it is written, it will never execute the score addition.

**Fix:** Edit `AIDecide_ProfessorOak` in [src/engine/duel/ai/trainer_cards.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/trainer_cards.asm):
```diff
AIDecide_ProfessorOak:
	...
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

### Rick never plays Energy Search

The AI's decision to play Energy Search has two special cases: one for the Heated Battle deck and the other for the Wonders of Science deck. The former calls a subroutine to check only for Fire and Lightning energy cards in the deck, and the latter only checks for... Fire and Lightning energy cards. In a deck filled only with Grass and Psychic types. Needless is to say, poor Rick never finds any of those energy cards in the deck, so the Energy Search card is left forever unplayed. There's an unreferenced subroutine that looks for Grass energy that is supposed to be used instead.

**Fix:** Edit `AIDecide_EnergySearch` in [src/engine/duel/ai/trainer_cards.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/trainer_cards.asm):
```diff
AIDecide_EnergySearch:
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

### Rick uses wrong Pokédex AI subroutine

Seems Rick can't catch a break. When deciding which cards to prioritize in the Pokédex card effect, the AI checks if it's playing the Wonders of Science deck, then completely disregards the result and jumps unconditionally. Thus, Rick uses the generic algorithm for sorting the deck cards.

**Fix:** Edit `AIDecide_Pokedex` in [src/engine/duel/ai/trainer_cards.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/trainer_cards.asm):
```diff
AIDecide_Pokedex:
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
-PickPokedexCards_Unreferenced:
-; unreferenced
	xor a
	ld [wAIPokedexCounter], a ; reset counter
	...
```

### Chris never uses Revive on Kangaskhan

Because of an error in the AI logic, Chris never considers using Revive on a Kangaskhan card in the Discard Pile, even though it is listed as one of the cards for the AI to check. This works fine for Hitmonchan and Hitmonlee, but in case it's a Tauros card, the routine will fallthrough into the Kangaskhan check and then will fallthrough into the set carry branch (since it fails this check). In case it's a Kangaskhan card, the check will fail in the Tauros check and jump back into the loop. So the Tauros check works by accident, while Kangaskhan will never be correctly checked because of this.

**Fix:** Edit `AIDecide_Revive` in [src/engine/duel/ai/trainer_cards.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/trainer_cards.asm):
```diff
AIDecide_Revive:
	...
; look in Discard Pile for specific cards.
	ld hl, wDuelTempList
.loop_discard_pile
	ld a, [hli]
	cp $ff
	jr z, .no_carry
	ld b, a
	call LoadCardDataToBuffer1_FromDeckIndex
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

### AI Pokémon Trader may result in unintended effects

A missing line in AI logic might result in strange behavior when executing the effect of Pokémon Trader for Power Generator deck. Since the last check falls through regardless of result, register a might hold an invalid deck index, which might lead to incorrect (and hilarious) results like Brandon trading a Pikachu with a Grass Energy from the deck. However, since it's deep in a tower of conditionals, reaching here is extremely unlikely.

**Fix:** Edit `AIDecide_PokemonTrader_PowerGenerator` in [src/engine/duel/ai/trainer_cards.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/trainer_cards.asm):
```diff
AIDecide_PokemonTrader_PowerGenerator:
	...
	ld a, RAICHU_LV40
	call LookForCardIDInDeck_GivenCardIDInHandAndPlayArea
-	jr c, .find_duplicates
+	jp c, .find_duplicates
	ld a, PIKACHU_LV14
	ld b, RAICHU_LV40
	...
	call LookForCardIDInDeck_GivenCardIDInHand
	jr c, .find_duplicates
-	; bug, missing jr .no_carry
+	jr .no_carry

; a card in deck was found to look for,
; check if there are duplicates in hand to trade with.
	...
.set_carry
	scf
+; fallthrough
+.no_carry
	ret
```

### AI Full Heal has flawed logic for sleep

The AI has the following checks when it is deciding whether to play Full Heal and its Active card is asleep in in [src/engine/duel/ai/trainer_cards.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/trainer_cards.asm):

```
.asleep
; set carry if any of the following
; cards are in the Play Area.
	ld a, GASTLY_LV8
	ld b, PLAY_AREA_ARENA
	call LookForCardIDInPlayArea_Bank8
	jr c, .set_carry
	ld a, GASTLY_LV17
	ld b, PLAY_AREA_ARENA
	call LookForCardIDInPlayArea_Bank8
	jr c, .set_carry
	ld a, HAUNTER_LV22
	ld b, PLAY_AREA_ARENA
	call LookForCardIDInPlayArea_Bank8
	jr c, .set_carry
```

The intention was to use Full Heal when their Active card is asleep and the player has either GastlyLv8, GastlyLv17 or HaunterLv22 as their Active Pokémon. But actually, `LookForCardIDInPlayArea_Bank8` is checking its own Play Area, and not the player's

**Fix:** Edit `AIDecide_FullHeal` in [src/engine/duel/ai/trainer_cards.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/trainer_cards.asm):
```diff
AIDecide_FullHeal:
	...
.asleep
; set carry if any of the following
; cards are in the Play Area.
	ld a, GASTLY_LV8
-	ld b, PLAY_AREA_ARENA
-	call LookForCardIDInPlayArea_Bank8
+	call .CheckPlayerArenaCard
	jr c, .set_carry
	ld a, GASTLY_LV17
-	ld b, PLAY_AREA_ARENA
-	call LookForCardIDInPlayArea_Bank8
+	call .CheckPlayerArenaCard
	jr c, .set_carry
	ld a, HAUNTER_LV22
-	ld b, PLAY_AREA_ARENA
-	call LookForCardIDInPlayArea_Bank8
+	call .CheckPlayerArenaCard
	jr c, .set_carry
+	jr .paralyzed
+
+; returns carry if player's Arena card
+; is card in register a
+.CheckPlayerArenaCard:
+	call SwapTurn
+	ld b, PLAY_AREA_ARENA
+	call LookForCardIDInPlayArea_Bank8
+	jp SwapTurn

-	; otherwise fallthrough
.paralyzed
	...
```

### AI Full Heal has flawed logic for paralysis

The AI does some incorrect checks when analysing whether to heal paralysis with a Full Heal in [src/engine/duel/ai/trainer_cards.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/trainer_cards.asm). Firstly it incorrectly calls `CheckIfCanDamageDefendingPokemon` to determine whether the Arena card can damage the defending card, but it will always return no carry (because it is paralyzed). Then it does some retreating checks, which don't make sense after determining that the card can damage. The intention was to use Full Heal in case it is able to damage, otherwise to use Full Heal if the Ai is planning on retreating it.

**Fix:** One way to fix would be to temporarily set the status of the card to NO_STATUS to perform these checks. Edit `AIDecide_FullHeal` in [src/engine/duel/ai/trainer_cards.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/trainer_cards.asm):
```diff
AIDecide_FullHeal:
	...
.no_scoop_up_prz
-; return no carry if Arena card
-; cannot damage the defending Pokémon
+; return carry if Arena card
+; can damage the defending Pokémon

-; this is a bug, since CheckIfCanDamageDefendingPokemon
-; also takes into account whether card is paralyzed
+; temporarily remove status effect for damage checking
+	ld a, DUELVARS_ARENA_CARD_STATUS
+	call GetTurnDuelistVariable
+	ld b, [hl]
+	ld [hl], NO_STATUS
+	push hl
+	push bc
	xor a ; PLAY_AREA_ARENA
	farcall CheckIfCanDamageDefendingPokemon
+	pop bc
+	pop hl
+	ld [hl], b
-	jr nc, .no_carry
+	jr c, .set_carry

; if it can play an energy card to retreat, set carry.
	ld a, [wAIPlayEnergyCardForRetreat]
	or a
	jr nz, .set_carry

; if not, check whether it's a card it would rather retreat,
; and if it isn't, set carry.
	farcall AIDecideWhetherToRetreat
	jr nc, .set_carry
	...
```

### AI might use a Pkmn Power as an attack

Under very specific conditions, the AI might attempt to use its Arena card's Pkmn Power as an attack. This is because when the AI plays Pluspower, it is hardcoding which attack to use when it finally decides to attack. This does not account for the case where afterwards, for example, the AI plays a Professor Oak and obtains an evolution of that card, and then evolves that card. If the new evolved Pokémon has Pkmn Power on the first "attack slot", and the AI hardcoded to use that attack, then it will be used. This specific combination can be seen when playing with John, since his deck contains Professor Oak, Pluspower, and Doduo and its evolution Dodrio (which has the Pkmn Power Retreat Aid).

**Fix:** Edit `AIDecideEvolution` in [src/engine/duel/ai/hand_pokemon.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/hand_pokemon.asm):
```diff
AIDecideEvolution:
	...
; if AI score >= 133, go through with the evolution
.check_score
	ld a, [wAIScore]
	cp 133
	jr c, .done_bench_pokemon
	ld a, [wTempAI]
	ldh [hTempPlayAreaLocation_ffa1], a
	ld a, [wTempAIPokemonCard]
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_EVOLVE_PKMN
	bank1call AIMakeDecision
+
+	; disregard PlusPower attack choice
+	; in case the Arena card evolved
+	ld a, [wTempAI]
+	or a
+	jr nz, .skip_reset_pluspower_atk
+	ld hl, wPreviousAIFlags
+	res 0, [hl] ; AI_FLAG_USED_PLUSPOWER
+.skip_reset_pluspower_atk
	pop bc
	jr .done_hand_card
	...
```

### AI never uses Energy Trans in order to retreat Arena card

There is a mistake in the AI retreat logic, in [src/engine/duel/ai/decks/general.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/decks/general.asm). HandleAIEnergyTrans for retreating doesn't make sense being at the end, since at this point Switch Trainer card was already used to retreat the Pokémon. What the routine will do is just transfer Energy cards to the Arena Pokémon for the purpose of retreating, and then not actually retreat, resulting in unusual behaviour. This would only work placed right after the AI checks whether they have Switch card in hand to use and doesn't have one (and probably that was the original intention).
```
; handles AI retreating logic
AIProcessRetreat:
	...
.used_switch
; if AI used switch, unset its AI flag
	ld a, [wPreviousAIFlags]
	and ~AI_FLAG_USED_SWITCH ; clear Switch flag
	ld [wPreviousAIFlags], a

	ld a, AI_ENERGY_TRANS_RETREAT
	farcall HandleAIEnergyTrans
	ret
```

**Fix:** TODO

### Sam's practice deck does wrong card ID check

There is a mistake in the AI logic for deciding which Pokémon for Sam to switch to in [src/engine/duel/ai/decks/sams_practice.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/decks/sams_practice.asm). It attempts to compare a card ID with a deck index. The intention was to change the card to switch to depending on whether the first Machop was KO'd at this point in the Duel or not. Because of the buggy comparison, this will always skip the 'inc a' instruction and switch to PLAY_AREA_BENCH_1. In a normal Practice Duel following Dr. Mason's instructions, this will always lead to the AI correctly switching Raticate with Machop, but in case of a "Free" Duel where the first Machop is not KO'd, the intention was to switch to PLAY_AREA_BENCH_2 instead.
```
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	cp MACHOP ; wrong
	ld a, PLAY_AREA_BENCH_1
	jr nz, .retreat
	inc a ; PLAY_AREA_BENCH_2
```

**Fix:** Edit `AIPerformScriptedTurn` in [src/engine/duel/ai/decks/sams_practice.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/decks/sams_practice.asm):
```diff
AIPerformScriptedTurn:
	...
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

### AI does not use Shift properly

The AI misuses the Shift Pkmn Power. It reads garbage data if there is a Clefairy Doll or Mysterious Fossil in play and also does not account for already changed types (including its own Shift effect).

**Fix:** Edit `HandleAIShift` in [src/engine/duel/ai/pkmn_powers.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/pkmn_powers.asm):
```diff
HandleAIShift:
	...
.CheckWhetherTurnDuelistHasColor
	ld a, [wAIDefendingPokemonWeakness]
	ld b, a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
+	ld c, PLAY_AREA_ARENA
.loop_play_area
	ld a, [hli]
	cp $ff
	jr z, .false
	push bc
-	call GetCardIDFromDeckIndex
-	call GetCardType ; bug, this could be a Trainer card
+	ld a, c
+	call GetPlayAreaCardColor
	call TranslateColorToWR
	pop bc
	and b
-	jr z, .loop_play_area
+	jr nz, .true
+	inc c
+	jr .loop_play_area
-; true
+.true
	scf
	ret
.false
	or a
	ret
	...
```

### AI does not use Cowardice properly

The AI does not respect the rule in Cowardice which states it cannot be used on the same turn as when Tentacool was played.

**Fix:** Edit `HandleAICowardice` in [src/engine/duel/ai/pkmn_powers.asm](https://github.com/pret/poketcg/blob/master/src/engine/duel/ai/pkmn_powers.asm):
```diff
; handles AI logic for Cowardice
HandleAICowardice:
	...
.CheckWhetherToUseCowardice
	ld a, c
	ldh [hTemp_ffa0], a
	ld e, a
+	add DUELVARS_ARENA_CARD_FLAGS
+	call GetTurnDuelistVariable
+	and CAN_EVOLVE_THIS_TURN
+	ret z ; return if was played this turn
	...
```

### Phantom Venusaur will never be obtained through Card Pop!

([Video](https://youtu.be/vr8MZwW6gpI?si=qZuMBGRSrMyoGVJj&t=60))

The routine used by Card Pop! to generate what card the player will receive is flawed, preventing one from ever receiving the Venusaur Phantom Card.

**Fix:** TODO

## Graphics

### Water Club master room uses the wrong void color

The bottom of Amy's room uses the incorrect void color, causing parts of it to appear black instead of dark blue.

**Fix:** Edit [water_club.bin](https://github.com/pret/poketcg/blob/master/src/data/maps/tiles/cgb/water_club.bin):
- Open the file with [Tilemap Studio](https://github.com/Rangi42/tilemap-studio).
- Select the `GBC tiles + attributes` option, and set the map to have a width of `28`.
- In `Tileset`, use `Add` on the [waterclub.png](https://github.com/pret/poketcg/blob/master/src/gfx/tilesets/waterclub.png) tileset, then enter `080` in the "Start at ID" field.
- Lastly, go to the `Palettes` tab, and replace the instances of palette `0` with palette `1`.

### Club entrances use incorrect medal emblem tiling
Each club entrance features a medal emblem, though all but the Fighting Club use incorrect/inconsistent tiling when compared to the actual medals the player can obtain. Despite this, all the required tiles exist, though a handful [ends up unused](https://tcrf.net/Pokémon_Trading_Card_Game/Unused_Graphics#Tileset_03).

![image](https://raw.githubusercontent.com/pret/poketcg/master/src/gfx/medals.png)

**Fix:** Edit the [XXX_club_entrance.bin](https://github.com/pret/poketcg/blob/master/src/data/maps/tiles/cgb) files with Tilemap Studio, using this chart as a guide for which emblem graphics to replace:
```diff
Lightning Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:CB, $0:CC, $0:9F
	$0:AC, $0:CE, $0:CF, $0:AF
-	$0:BC, $0:C9, $0:CA, $0:BF
+	$0:BC, $0:B9, $0:CA, $0:BF

Rock Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:D6, $0:D7, $0:9F
	$0:AC, $0:D8, $0:D9, $0:AF
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:B9, $0:DA, $0:BF

Psychic Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:DB, $0:DC, $0:9F
	$0:AC, $0:DD, $0:DE, $0:DF
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:C9, $0:CA, $0:BF

Fire Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:C5, $0:C6, $0:9F
	$0:AC, $0:C7, $0:C8, $0:C3
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:C9, $0:CA, $0:BF

Science Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:BB, $0:C0, $0:9F
	$0:AC, $0:C1, $0:C2, $0:C3
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:BD, $0:C4, $0:BF

Grass Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:A6, $0:A7, $0:9F
-	$0:AC, $0:B6, $0:B7, $0:AF
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:AC, $0:B6, $0:B7, $0:B8
+	$0:BC, $0:B9, $0:BA, $0:BF

Water Club:
	$0:8C, $0:8D, $0:8E, $0:8F
	$0:9C, $0:D0, $0:D1, $0:D2
	$0:AC, $0:D3, $0:D4, $0:D5
-	$0:BC, $0:BD, $0:BE, $0:BF
+	$0:BC, $0:C9, $0:CA, $0:BF
```

### Green NPCs have incorrect frame data

Characters that are assigned the green NPC palette have incorrect profile frame data. Talking to the from either the left or right will not draw the correct tiles for the upper corner of their head.

**Fix:** Edit `AnimFrameTable7` in [src/data/duel/animations/anims1.asm](https://github.com/pret/poketcg/blob/master/src/data/duel/animations/anims1.asm):
```diff
.data_a9459
	db 4 ; size
-	db 0, 0, 6, %011 | (1 << OAM_OBP_NUM)
+	db 0, 0, 12, %011 | (1 << OAM_OBP_NUM)
	db 0, 8, 13, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 14, %011 | (1 << OAM_OBP_NUM)
	db 8, 8, 15, %011 | (1 << OAM_OBP_NUM)

.data_a946a
	db 4 ; size
-	db 0, 0, 8, %011 | (1 << OAM_OBP_NUM)
+	db 0, 0, 16, %011 | (1 << OAM_OBP_NUM)
	db 0, 8, 17, %011 | (1 << OAM_OBP_NUM)
	db 8, 0, 18, %011 | (1 << OAM_OBP_NUM)
	db 8, 8, 19, %011 | (1 << OAM_OBP_NUM)

...


.data_a94ae
	db 4 ; size
	db 0, 0, 13, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 15, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
-	db 0, 8, 6, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
+	db 0, 8, 12, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 14, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)

.data_a94bf
	db 4 ; size
	db 0, 0, 17, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 0, 19, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
-	db 0, 8, 8, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
+	db 0, 8, 16, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
	db 8, 8, 18, %011 | (1 << OAM_OBP_NUM) | (1 << OAM_X_FLIP)
```

### Big Lightning animation has incorrect frame data

One of the bolts from the "big lightning" duel animation has its topmost row of tiles accidentally shifted one tile to the left.

**Fix:** Edit `AnimFrameTable29` in [data/duel/animations/anims1.asm](https://github.com/pret/poketcg/blob/master/src/data/duel/animations/anims1.asm):
```diff
.data_ab5fd
	db 28 ; size
-	db -72, -8, 0, (1 << OAM_X_FLIP)
+	db -72, 0, 0, (1 << OAM_X_FLIP)
	db -16, 32, 27, $0
	...
	db -56, 10, 42, $0
```

The base of the lightning being cut-off is addressed below, though that specific fix will cause a byte overflow, forcing one to rearrange `anim1.asm`.

```diff
.data_ab5fd
-	db 28 ; size
-	db -72, -8, 0, (1 << OAM_X_FLIP)
+	db 29 ; size
+	db -72, 0, 0, (1 << OAM_X_FLIP)
+	db -72, -8, 1, (1 << OAM_X_FLIP)
	db -16, 32, 27, $0
	...
	db -56, 10, 42, $0
```

### Dive Bomb animation has incorrect frame data

The fire blasts from Dive Bomb's duel animation mistakenly reuse the same tile twice, causing one tile to go unused, and the animation itself to look less refined.

**Fix:** Edit `AnimFrameTable32` in [data/duel/animations/anims2.asm](https://github.com/pret/poketcg/blob/master/src/data/duel/animations/anims2.asm):
```diff
.data_ac685
	db 19 ; size
	...
	db -8, 8, 11, (1 << OAM_X_FLIP)
	db -8, 16, 10, (1 << OAM_X_FLIP)
-	db 0, 24, 10, (1 << OAM_X_FLIP)
+	db 0, 24, 12, (1 << OAM_X_FLIP)
	db 0, 16, 13, (1 << OAM_X_FLIP)
	db 0, 8, 14, (1 << OAM_X_FLIP)
	db 8, 8, 17, (1 << OAM_X_FLIP)
	db 8, 16, 16, (1 << OAM_X_FLIP)
	db 8, 24, 15, (1 << OAM_X_FLIP)
	db 16, 24, 18, (1 << OAM_X_FLIP)

.data_ac6d2
	db 19 ; size
	...
	db -8, -16, 11, $0
	db -8, -24, 10, $0
-	db 0, -32, 10, $0
+	db 0, -32, 12, $0
	db 0, -24, 13, $0
	db 0, -16, 14, $0
	db 8, -16, 17, $0
	db 8, -24, 16, $0
	db 8, -32, 15, $0
	db 16, -32, 18, $0

.data_ac71f
	db 29 ; size
	...
	db -8, 8, 11, (1 << OAM_X_FLIP)
	db -8, 16, 10, (1 << OAM_X_FLIP)
-	db 0, 24, 10, (1 << OAM_X_FLIP)
+	db 0, 24, 12, (1 << OAM_X_FLIP)
	db 0, 16, 13, (1 << OAM_X_FLIP)
	db 0, 8, 14, (1 << OAM_X_FLIP)
	db 8, 8, 17, (1 << OAM_X_FLIP)
	db 8, 16, 16, (1 << OAM_X_FLIP)
	db 8, 24, 15, (1 << OAM_X_FLIP)
	db 16, 24, 18, (1 << OAM_X_FLIP)
```

The flames of one of the blasts being cut-off is addressed below, though that specific fix will cause a byte overflow, forcing one to rearrange `anim2.asm`.

```diff
.data_ac685
-	db 19 ; size
+	db 20 ; size
	...
	db -8, 8, 11, (1 << OAM_X_FLIP)
	db -8, 16, 10, (1 << OAM_X_FLIP)
-	db 0, 24, 10, (1 << OAM_X_FLIP)
+	db 0, 24, 12, (1 << OAM_X_FLIP)
	db 0, 16, 13, (1 << OAM_X_FLIP)
	db 0, 8, 14, (1 << OAM_X_FLIP)
	db 8, 8, 17, (1 << OAM_X_FLIP)
	db 8, 16, 16, (1 << OAM_X_FLIP)
	db 8, 24, 15, (1 << OAM_X_FLIP)
+	db 16, 16, 19, (1 << OAM_X_FLIP)
	db 16, 24, 18, (1 << OAM_X_FLIP)

.data_ac6d2
-	db 19 ; size
+	db 20 ; size
	...
	db -8, -16, 11, $0
	db -8, -24, 10, $0
-	db 0, -32, 10, $0
+	db 0, -32, 12, $0
	db 0, -24, 13, $0
	db 0, -16, 14, $0
	db 8, -16, 17, $0
	db 8, -24, 16, $0
	db 8, -32, 15, $0
+	db 16, -24, 19, $0
	db 16, -32, 18, $0

.data_ac71f
	db 29 ; size
	...
	db -8, 8, 11, (1 << OAM_X_FLIP)
	db -8, 16, 10, (1 << OAM_X_FLIP)
-	db 0, 24, 10, (1 << OAM_X_FLIP)
+	db 0, 24, 12, (1 << OAM_X_FLIP)
	db 0, 16, 13, (1 << OAM_X_FLIP)
	db 0, 8, 14, (1 << OAM_X_FLIP)
	db 8, 8, 17, (1 << OAM_X_FLIP)
	db 8, 16, 16, (1 << OAM_X_FLIP)
	db 8, 24, 15, (1 << OAM_X_FLIP)
	db 16, 24, 18, (1 << OAM_X_FLIP)
```

## Text

### Challenge host uses wrong name for the first rival

([Video](https://www.youtube.com/watch?v=1igDbNxRfUw&t=17310s))

When playing the challenge cup, player name is used instead of rival name before the first fight.

**Fix:** Edit `Clerk12ChallengeCupContenderText` in [src/text/text6.asm](https://github.com/pret/poketcg/blob/master/src/text/text6.asm):
```diff
-	text "Presently, <RAMNAME> is still"
+	text "Presently, <RAMTEXT> is still"
```

### Both Ninetales cards misspell its name
The name string used for both NinetalesLv32 and NinetalesLv35 misspells the Pokémon's name as "Ninetails".

**Fix:** Edit `NinetalesName` in [src/text/text10.asm](https://github.com/pret/poketcg/blob/master/src/text/text10.asm):
```diff
NinetalesName:
-	text "Ninetails"
+	text "Ninetales"
	done
```
