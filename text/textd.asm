	db TX_START,"Choose 1 of your Pok`mon in play\n"
	db "and return its Basic Pok`mon card to\n"
	db "your hand. (Discard all cards\n"
	db "attached to that card.)",TX_END

	db TX_START,"Computer Search",TX_END

	db TX_START,"Discard 2 of the other cards from\n"
	db "your hand in order to search your\n"
	db "deck for any card and put it into\n"
	db "your hand. Shuffle your deck\n"
	db "afterward.",TX_END

	db TX_START,"Pok`dex",TX_END

	db TX_START,"Look at up to 5 cards from the top\n"
	db "of your deck and rearrange them as\n"
	db "you like.",TX_END

	db TX_START,"PlusPower",TX_END

	db TX_START,"Attach PlusPower to your Active\n"
	db "Pok`mon. At the end of your turn,\n"
	db "discard PlusPower. If this Pok`mon's\n"
	db "attack does damage to any Active\n"
	db "Pok`mon (after applying Weakness and\n"
	db "Resistance), the attack does 10 more\n"
	db "damage to that Active Pok`mon.",TX_END

	db TX_START,"Defender",TX_END

	db TX_START,"Attach Defender to 1 of your\n"
	db "Pok`mon. At the end of your\n"
	db "opponent's next turn, discard\n"
	db "Defender. Damage done to that\n"
	db "Pok`mon by attacks is reduced by 20\n"
	db "(after applying Weakness and\n"
	db "Resistance).",TX_END

	db TX_START,"Item Finder",TX_END

	db TX_START,"Discard 2 of the other cards from\n"
	db "your hand in order to put a Trainer\n"
	db "card from your discard pile into\n"
	db "your hand.",TX_END

	db TX_START,"Gust of Wind",TX_END

	db TX_START,"Choose 1 of your opponent's Benched\n"
	db "Pok`mon and switch it with his or\n"
	db "her Active Pok`mon.",TX_END

	db TX_START,"Devolution Spray",TX_END

	db TX_START,"Choose 1 of your own Pok`mon in play\n"
	db "and a Stage of Evolution. Discard\n"
	db "all Evolution cards of that Stage or\n"
	db "higher attached to that Pok`mon.",TX_END

	db TX_START,"That Pok`mon is no longer Asleep,\n"
	db "Confused, Paralyzed, Poisoned, or\n"
	db "anything else that might be the\n"
	db "result of an attack (just as if you\n"
	db "had evolved it).",TX_END

	db TX_START,"Potion",TX_END

	db TX_START,"Remove 2 damage counters from 1 of\n"
	db "your Pok`mon. If that Pok`mon has\n"
	db "fewer damage counters than that,\n"
	db "remove all of them.",TX_END

	db TX_START,"Super Potion",TX_END

	db TX_START,"Discard 1 Energy card attached to 1\n"
	db "of your own Pok`mon in order to\n"
	db "remove 4 damage counters from that\n"
	db "Pok`mon. If the Pok`mon has fewer\n"
	db "damage counters than that, remove\n"
	db "all of them.",TX_END

	db TX_START,"Full Heal",TX_END

	db TX_START,"Your Active Pok`mon is no longer\n"
	db "Asleep, Confused, Paralyzed, or\n"
	db "Poisoned.",TX_END

	db TX_START,"Revive",TX_END

	db TX_START,"Put 1 Basic Pok`mon card from your\n"
	db "discard pile onto your Bench.\n"
	db "Put damage counters on that Pok`mon\n"
	db "equal to half its HP (rounded down\n"
	db "to the nearest 10). (You can't play\n"
	db "Revive if your Bench is full.)",TX_END

	db TX_START,"Maintenance",TX_END

	db TX_START,"Shuffle 2 of the other cards from\n"
	db "your hand into your deck in order\n"
	db "to draw a card.",TX_END

	db TX_START,"Pok`mon Flute",TX_END

	db TX_START,"Choose 1 Basic Pok`mon card from\n"
	db "your opponent's discard pile and put\n"
	db "it onto his or her Bench. (You can't\n"
	db "play Pok`mon Flute if your\n"
	db "opponent's Bench is full.)",TX_END

	db TX_START,"Gambler",TX_END

	db TX_START,"Shuffle your hand into your deck.\n"
	db "Flip a coin. If heads, draw 8 cards.\n"
	db "If tails, draw 1 card.",TX_END

	db TX_START,"Recycle",TX_END

	db TX_START,"Flip a coin. If heads, put a card\n"
	db "in your discard pile on top of your\n"
	db "deck.",TX_END

rept $3655
db $ff
endr