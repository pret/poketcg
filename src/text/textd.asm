ScoopUpDescription: ; 64000 (19:4000)
	text "Choose 1 of your Pok`mon in play\n"
	db   "and return its Basic Pok`mon card to\n"
	db   "your hand. (Discard all cards\n"
	db   "attached to that card.)"
	done

ComputerSearchName: ; 6407d (19:407d)
	text "Computer Search"
	done

ComputerSearchDescription: ; 6408e (19:408e)
	text "Discard 2 of the other cards from\n"
	db   "your hand in order to search your\n"
	db   "deck for any card and put it into\n"
	db   "your hand. Shuffle your deck\n"
	db   "afterward."
	done

PokedexName: ; 6411d (19:411d)
	text "Pok`dex"
	done

PokedexDescription: ; 64126 (19:4126)
	text "Look at up to 5 cards from the top\n"
	db   "of your deck and rearrange them as\n"
	db   "you like."
	done

PlusPowerName: ; 64177 (19:4177)
	text "PlusPower"
	done

PlusPowerDescription: ; 64182 (19:4182)
	text "Attach PlusPower to your Active\n"
	db   "Pok`mon. At the end of your turn,\n"
	db   "discard PlusPower. If this Pok`mon's\n"
	db   "attack does damage to any Active\n"
	db   "Pok`mon (after applying Weakness and\n"
	db   "Resistance), the attack does 10 more\n"
	db   "damage to that Active Pok`mon."
	done

DefenderName: ; 64274 (19:4274)
	text "Defender"
	done

DefenderDescription: ; 6427e (19:427e)
	text "Attach Defender to 1 of your\n"
	db   "Pok`mon. At the end of your\n"
	db   "opponent's next turn, discard\n"
	db   "Defender. Damage done to that\n"
	db   "Pok`mon by attacks is reduced by 20\n"
	db   "(after applying Weakness and\n"
	db   "Resistance)."
	done

ItemFinderName: ; 64342 (19:4342)
	text "Item Finder"
	done

ItemFinderDescription: ; 6434f (19:434f)
	text "Discard 2 of the other cards from\n"
	db   "your hand in order to put a Trainer\n"
	db   "card from your discard pile into\n"
	db   "your hand."
	done

GustofWindName: ; 643c2 (19:43c2)
	text "Gust of Wind"
	done

GustofWindDescription: ; 643d0 (19:43d0)
	text "Choose 1 of your opponent's Benched\n"
	db   "Pok`mon and switch it with his or\n"
	db   "her Active Pok`mon."
	done

DevolutionSprayName: ; 6442b (19:442b)
	text "Devolution Spray"
	done

DevolutionSprayDescription: ; 6443d (19:443d)
	text "Choose 1 of your own Pok`mon in play\n"
	db   "and a Stage of Evolution. Discard\n"
	db   "all Evolution cards of that Stage or\n"
	db   "higher attached to that Pok`mon."
	done

DevolutionSprayDescriptionCont: ; 644cb (19:44cb)
	text "That Pok`mon is no longer Asleep,\n"
	db   "Confused, Paralyzed, Poisoned, or\n"
	db   "anything else that might be the\n"
	db   "result of an attack (just as if you\n"
	db   "had evolved it)."
	done

PotionName: ; 64565 (19:4565)
	text "Potion"
	done

PotionDescription: ; 6456d (19:456d)
	text "Remove 2 damage counters from 1 of\n"
	db   "your Pok`mon. If that Pok`mon has\n"
	db   "fewer damage counters than that,\n"
	db   "remove all of them."
	done

SuperPotionName: ; 645e8 (19:45e8)
	text "Super Potion"
	done

SuperPotionDescription: ; 645f6 (19:45f6)
	text "Discard 1 Energy card attached to 1\n"
	db   "of your own Pok`mon in order to\n"
	db   "remove 4 damage counters from that\n"
	db   "Pok`mon. If the Pok`mon has fewer\n"
	db   "damage counters than that, remove\n"
	db   "all of them."
	done

FullHealName: ; 646af (19:46af)
	text "Full Heal"
	done

FullHealDescription: ; 646ba (19:46ba)
	text "Your Active Pok`mon is no longer\n"
	db   "Asleep, Confused, Paralyzed, or\n"
	db   "Poisoned."
	done

ReviveName: ; 64706 (19:4706)
	text "Revive"
	done

ReviveDescription: ; 6470e (19:470e)
	text "Put 1 Basic Pok`mon card from your\n"
	db   "discard pile onto your Bench.\n"
	db   "Put damage counters on that Pok`mon\n"
	db   "equal to half its HP (rounded down\n"
	db   "to the nearest 10). (You can't play\n"
	db   "Revive if your Bench is full.)"
	done

MaintenanceName: ; 647da (19:47da)
	text "Maintenance"
	done

MaintenanceDescription: ; 647e7 (19:47e7)
	text "Shuffle 2 of the other cards from\n"
	db   "your hand into your deck in order\n"
	db   "to draw a card."
	done

PokemonFluteName: ; 6483c (19:483c)
	text "Pok`mon Flute"
	done

PokemonFluteDescription: ; 6484b (19:484b)
	text "Choose 1 Basic Pok`mon card from\n"
	db   "your opponent's discard pile and put\n"
	db   "it onto his or her Bench. (You can't\n"
	db   "play Pok`mon Flute if your\n"
	db   "opponent's Bench is full.)"
	done

GamblerName: ; 648ed (19:48ed)
	text "Gambler"
	done

GamblerDescription: ; 648f6 (19:48f6)
	text "Shuffle your hand into your deck.\n"
	db   "Flip a coin. If heads, draw 8 cards.\n"
	db   "If tails, draw 1 card."
	done

RecycleName: ; 64955 (19:4955)
	text "Recycle"
	done

RecycleDescription: ; 6495e (19:495e)
	text "Flip a coin. If heads, put a card\n"
	db   "in your discard pile on top of your\n"
	db   "deck."
	done

rept $3655
db $ff
endr
