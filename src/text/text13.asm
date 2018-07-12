ScoopUpDescription: ; 64000 (19:4000)
	text "Choose 1 of your Pokémon in play"
	line "and return its Basic Pokémon card to"
	line "your hand. (Discard all cards"
	line "attached to that card.)"
	done

ComputerSearchName: ; 6407d (19:407d)
	text "Computer Search"
	done

ComputerSearchDescription: ; 6408e (19:408e)
	text "Discard 2 of the other cards from"
	line "your hand in order to search your"
	line "deck for any card and put it into"
	line "your hand. Shuffle your deck"
	line "afterward."
	done

PokedexName: ; 6411d (19:411d)
	text "Pokédex"
	done

PokedexDescription: ; 64126 (19:4126)
	text "Look at up to 5 cards from the top"
	line "of your deck and rearrange them as"
	line "you like."
	done

PlusPowerName: ; 64177 (19:4177)
	text "PlusPower"
	done

PlusPowerDescription: ; 64182 (19:4182)
	text "Attach PlusPower to your Active"
	line "Pokémon. At the end of your turn,"
	line "discard PlusPower. If this Pokémon's"
	line "attack does damage to any Active"
	line "Pokémon (after applying Weakness and"
	line "Resistance), the attack does 10 more"
	line "damage to that Active Pokémon."
	done

DefenderName: ; 64274 (19:4274)
	text "Defender"
	done

DefenderDescription: ; 6427e (19:427e)
	text "Attach Defender to 1 of your"
	line "Pokémon. At the end of your"
	line "opponent's next turn, discard"
	line "Defender. Damage done to that"
	line "Pokémon by attacks is reduced by 20"
	line "(after applying Weakness and"
	line "Resistance)."
	done

ItemFinderName: ; 64342 (19:4342)
	text "Item Finder"
	done

ItemFinderDescription: ; 6434f (19:434f)
	text "Discard 2 of the other cards from"
	line "your hand in order to put a Trainer"
	line "card from your discard pile into"
	line "your hand."
	done

GustOfWindName: ; 643c2 (19:43c2)
	text "Gust of Wind"
	done

GustOfWindDescription: ; 643d0 (19:43d0)
	text "Choose 1 of your opponent's Benched"
	line "Pokémon and switch it with his or"
	line "her Active Pokémon."
	done

DevolutionSprayName: ; 6442b (19:442b)
	text "Devolution Spray"
	done

DevolutionSprayDescription: ; 6443d (19:443d)
	text "Choose 1 of your own Pokémon in play"
	line "and a Stage of Evolution. Discard"
	line "all Evolution cards of that Stage or"
	line "higher attached to that Pokémon."
	done

DevolutionSprayDescriptionCont: ; 644cb (19:44cb)
	text "That Pokémon is no longer Asleep,"
	line "Confused, Paralyzed, Poisoned, or"
	line "anything else that might be the"
	line "result of an attack (just as if you"
	line "had evolved it)."
	done

PotionName: ; 64565 (19:4565)
	text "Potion"
	done

PotionDescription: ; 6456d (19:456d)
	text "Remove 2 damage counters from 1 of"
	line "your Pokémon. If that Pokémon has"
	line "fewer damage counters than that,"
	line "remove all of them."
	done

SuperPotionName: ; 645e8 (19:45e8)
	text "Super Potion"
	done

SuperPotionDescription: ; 645f6 (19:45f6)
	text "Discard 1 Energy card attached to 1"
	line "of your own Pokémon in order to"
	line "remove 4 damage counters from that"
	line "Pokémon. If the Pokémon has fewer"
	line "damage counters than that, remove"
	line "all of them."
	done

FullHealName: ; 646af (19:46af)
	text "Full Heal"
	done

FullHealDescription: ; 646ba (19:46ba)
	text "Your Active Pokémon is no longer"
	line "Asleep, Confused, Paralyzed, or"
	line "Poisoned."
	done

ReviveName: ; 64706 (19:4706)
	text "Revive"
	done

ReviveDescription: ; 6470e (19:470e)
	text "Put 1 Basic Pokémon card from your"
	line "discard pile onto your Bench."
	line "Put damage counters on that Pokémon"
	line "equal to half its HP (rounded down"
	line "to the nearest 10). (You can't play"
	line "Revive if your Bench is full.)"
	done

MaintenanceName: ; 647da (19:47da)
	text "Maintenance"
	done

MaintenanceDescription: ; 647e7 (19:47e7)
	text "Shuffle 2 of the other cards from"
	line "your hand into your deck in order"
	line "to draw a card."
	done

PokemonFluteName: ; 6483c (19:483c)
	text "Pokémon Flute"
	done

PokemonFluteDescription: ; 6484b (19:484b)
	text "Choose 1 Basic Pokémon card from"
	line "your opponent's discard pile and put"
	line "it onto his or her Bench. (You can't"
	line "play Pokémon Flute if your"
	line "opponent's Bench is full.)"
	done

GamblerName: ; 648ed (19:48ed)
	text "Gambler"
	done

GamblerDescription: ; 648f6 (19:48f6)
	text "Shuffle your hand into your deck."
	line "Flip a coin. If heads, draw 8 cards."
	line "If tails, draw 1 card."
	done

RecycleName: ; 64955 (19:4955)
	text "Recycle"
	done

RecycleDescription: ; 6495e (19:495e)
	text "Flip a coin. If heads, put a card"
	line "in your discard pile on top of your"
	line "deck."
	done

rept $3655
	db $ff
endr
