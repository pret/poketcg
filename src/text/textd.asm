Text0b8e: ; 64000 (19:4000)
	db TX_START,"Choose 1 of your Pok`mon in play\n"
	db "and return its Basic Pok`mon card to\n"
	db "your hand. (Discard all cards\n"
	db "attached to that card.)",TX_END

Text0b8f: ; 6407d (19:407d)
	db TX_START,"Computer Search",TX_END

Text0b90: ; 6408e (19:408e)
	db TX_START,"Discard 2 of the other cards from\n"
	db "your hand in order to search your\n"
	db "deck for any card and put it into\n"
	db "your hand. Shuffle your deck\n"
	db "afterward.",TX_END

Text0b91: ; 6411d (19:411d)
	db TX_START,"Pok`dex",TX_END

Text0b92: ; 64126 (19:4126)
	db TX_START,"Look at up to 5 cards from the top\n"
	db "of your deck and rearrange them as\n"
	db "you like.",TX_END

Text0b93: ; 64177 (19:4177)
	db TX_START,"PlusPower",TX_END

Text0b94: ; 64182 (19:4182)
	db TX_START,"Attach PlusPower to your Active\n"
	db "Pok`mon. At the end of your turn,\n"
	db "discard PlusPower. If this Pok`mon's\n"
	db "attack does damage to any Active\n"
	db "Pok`mon (after applying Weakness and\n"
	db "Resistance), the attack does 10 more\n"
	db "damage to that Active Pok`mon.",TX_END

Text0b95: ; 64274 (19:4274)
	db TX_START,"Defender",TX_END

Text0b96: ; 6427e (19:427e)
	db TX_START,"Attach Defender to 1 of your\n"
	db "Pok`mon. At the end of your\n"
	db "opponent's next turn, discard\n"
	db "Defender. Damage done to that\n"
	db "Pok`mon by attacks is reduced by 20\n"
	db "(after applying Weakness and\n"
	db "Resistance).",TX_END

Text0b97: ; 64342 (19:4342)
	db TX_START,"Item Finder",TX_END

Text0b98: ; 6434f (19:434f)
	db TX_START,"Discard 2 of the other cards from\n"
	db "your hand in order to put a Trainer\n"
	db "card from your discard pile into\n"
	db "your hand.",TX_END

Text0b99: ; 643c2 (19:43c2)
	db TX_START,"Gust of Wind",TX_END

Text0b9a: ; 643d0 (19:43d0)
	db TX_START,"Choose 1 of your opponent's Benched\n"
	db "Pok`mon and switch it with his or\n"
	db "her Active Pok`mon.",TX_END

Text0b9b: ; 6442b (19:442b)
	db TX_START,"Devolution Spray",TX_END

Text0b9c: ; 6443d (19:443d)
	db TX_START,"Choose 1 of your own Pok`mon in play\n"
	db "and a Stage of Evolution. Discard\n"
	db "all Evolution cards of that Stage or\n"
	db "higher attached to that Pok`mon.",TX_END

Text0b9d: ; 644cb (19:44cb)
	db TX_START,"That Pok`mon is no longer Asleep,\n"
	db "Confused, Paralyzed, Poisoned, or\n"
	db "anything else that might be the\n"
	db "result of an attack (just as if you\n"
	db "had evolved it).",TX_END

Text0b9e: ; 64565 (19:4565)
	db TX_START,"Potion",TX_END

Text0b9f: ; 6456d (19:456d)
	db TX_START,"Remove 2 damage counters from 1 of\n"
	db "your Pok`mon. If that Pok`mon has\n"
	db "fewer damage counters than that,\n"
	db "remove all of them.",TX_END

Text0ba0: ; 645e8 (19:45e8)
	db TX_START,"Super Potion",TX_END

Text0ba1: ; 645f6 (19:45f6)
	db TX_START,"Discard 1 Energy card attached to 1\n"
	db "of your own Pok`mon in order to\n"
	db "remove 4 damage counters from that\n"
	db "Pok`mon. If the Pok`mon has fewer\n"
	db "damage counters than that, remove\n"
	db "all of them.",TX_END

Text0ba2: ; 646af (19:46af)
	db TX_START,"Full Heal",TX_END

Text0ba3: ; 646ba (19:46ba)
	db TX_START,"Your Active Pok`mon is no longer\n"
	db "Asleep, Confused, Paralyzed, or\n"
	db "Poisoned.",TX_END

Text0ba4: ; 64706 (19:4706)
	db TX_START,"Revive",TX_END

Text0ba5: ; 6470e (19:470e)
	db TX_START,"Put 1 Basic Pok`mon card from your\n"
	db "discard pile onto your Bench.\n"
	db "Put damage counters on that Pok`mon\n"
	db "equal to half its HP (rounded down\n"
	db "to the nearest 10). (You can't play\n"
	db "Revive if your Bench is full.)",TX_END

Text0ba6: ; 647da (19:47da)
	db TX_START,"Maintenance",TX_END

Text0ba7: ; 647e7 (19:47e7)
	db TX_START,"Shuffle 2 of the other cards from\n"
	db "your hand into your deck in order\n"
	db "to draw a card.",TX_END

Text0ba8: ; 6483c (19:483c)
	db TX_START,"Pok`mon Flute",TX_END

Text0ba9: ; 6484b (19:484b)
	db TX_START,"Choose 1 Basic Pok`mon card from\n"
	db "your opponent's discard pile and put\n"
	db "it onto his or her Bench. (You can't\n"
	db "play Pok`mon Flute if your\n"
	db "opponent's Bench is full.)",TX_END

Text0baa: ; 648ed (19:48ed)
	db TX_START,"Gambler",TX_END

Text0bab: ; 648f6 (19:48f6)
	db TX_START,"Shuffle your hand into your deck.\n"
	db "Flip a coin. If heads, draw 8 cards.\n"
	db "If tails, draw 1 card.",TX_END

Text0bac: ; 64955 (19:4955)
	db TX_START,"Recycle",TX_END

Text0bad: ; 6495e (19:495e)
	db TX_START,"Flip a coin. If heads, put a card\n"
	db "in your discard pile on top of your\n"
	db "deck.",TX_END

rept $3655
db $ff
endr
