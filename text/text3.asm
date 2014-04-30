Text026d: ; 3c000 (f:4000)
	db TX_START,"You do not own all cards needed\n"
	db "to build this Deck.",TX_END

Text026e: ; 3c035 (f:4035)
	db TX_START,"Built\n"
	db TX_RAM2,TX_END

Text026f: ; 3c03e (f:403e)
	db TX_START,"These cards are needed\n"
	db "to build this Deck:",TX_END

Text0270: ; 3c06a (f:406a)
	db TX_START,"Dismantle these Decks?",TX_END

Text0271: ; 3c082 (f:4082)
	db TX_START,"Dismantled the Deck.",TX_END

Text0272: ; 3c098 (f:4098)
	db TX_START,"OK if this file is deleted?",TX_END

Text0273: ; 3c0b5 (f:40b5)
	db TX_START,"Read the Instructions",TX_END

Text0274: ; 3c0cc (f:40cc)
	db TX_START,"Print this card?\n"
	db "      Yes     No",TX_END

Text0275: ; 3c0ef (f:40ef)
	db TX_START,"Please choose a Deck configuration\n"
	db "to print.",TX_END

Text0276: ; 3c11d (f:411d)
	db TX_START,"Print this Deck?",TX_END

Text0277: ; 3c12f (f:412f)
	db TX_START,"Print the card list?\n"
	db "      Yes     No",TX_END

Text0278: ; 3c156 (f:4156)
	db TX_START,"Pok`mon Cards\n"
	db "Deck Configuration\n"
	db "Card List\n"
	db "Print Quality\n"
	db "Quit Print",TX_END

Text0279: ; 3c19b (f:419b)
	db TX_START,"What would you like to print?",TX_END

Text027a: ; 3c1ba (f:41ba)
	db TX_START,"Please set the contrast:\n"
	db "  Light   1   2   3   4   5   Dark",TX_END

Text027b: ; 3c1f7 (f:41f7)
	db TX_START,"Please make sure to turn\n"
	db "the Game Boy Printer OFF.",TX_END

Text027c: ; 3c22b (f:422b)
	db TX_START,"Procedures for sending cards:",TX_END

Text027d: ; 3c24a (f:424a)
	db TX_START,"1. Choose the card you wish to send.\n"
	db "   Press left/right to choose more.\n\n"
	db "2. Choose all the cards. Then press\n"
	db "   the B Button to open the menu.\n\n"
	db "3. Choose Send to finish\n"
	db "   the process.",TX_END

Text027e: ; 3c305 (f:4305)
	db TX_START,"Please read the procedures\n"
	db "for sending cards.",TX_END

Text027f: ; 3c334 (f:4334)
	db TX_START,"Send",TX_END

Text0280: ; 3c33a (f:433a)
	db TX_START,"Card received",TX_END

Text0281: ; 3c349 (f:4349)
	db TX_START,"Card to send",TX_END

Text0282: ; 3c357 (f:4357)
	db TX_START,"Send these cards?",TX_END

Text0283: ; 3c36a (f:436a)
	db TX_START,"Received these cards\n"
	db "from  ",TX_RAM2,"!",TX_END

Text0284: ; 3c389 (f:4389)
	db TX_START,"Please choose a Deck \n"
	db "configuration to send.",TX_END

Text0285: ; 3c3b7 (f:43b7)
	db TX_START,"Please choose a Save Slot.",TX_END

Text0286: ; 3c3d3 (f:43d3)
	db TX_START,"Receive configuration.",TX_END

Text0287: ; 3c3eb (f:43eb)
	db TX_START,"Received a deck configuration\n"
	db "from  ",TX_RAM2,"!",TX_END

Text0288: ; 3c413 (f:4413)
	db TX_START,"  Fighting Machine  ",TX_END

Text0289: ; 3c429 (f:4429)
	db TX_START,"  Rock Machine  ",TX_END

Text028a: ; 3c43b (f:443b)
	db TX_START,"  Water Machine   ",TX_END

Text028b: ; 3c44f (f:444f)
	db TX_START,"  Lightning Machine   ",TX_END

Text028c: ; 3c467 (f:4467)
	db TX_START,"  Grass Machine   ",TX_END

Text028d: ; 3c47b (f:447b)
	db TX_START,"  Psychic Machine   ",TX_END

Text028e: ; 3c491 (f:4491)
	db TX_START,"  Science Machine   ",TX_END

Text028f: ; 3c4a7 (f:44a7)
	db TX_START,"  Fire Machine  ",TX_END

Text0290: ; 3c4b9 (f:44b9)
	db TX_START,"  Auto Machine  ",TX_END

Text0291: ; 3c4cb (f:44cb)
	db TX_START,"  Legendary Machine   ",TX_END

Text0292: ; 3c4e3 (f:44e3)
	db TX_START,"All Fighting Pok`mon",TX_END

Text0293: ; 3c4f9 (f:44f9)
	db TX_START,"Bench Attack",TX_END

Text0294: ; 3c507 (f:4507)
	db TX_START,"Battle Contest",TX_END

Text0295: ; 3c517 (f:4517)
	db TX_START,"Heated Battle",TX_END

Text0296: ; 3c526 (f:4526)
	db TX_START,"First-Strike",TX_END

Text0297: ; 3c534 (f:4534)
	db TX_START,"Squeaking Mouse",TX_END

Text0298: ; 3c545 (f:4545)
	db TX_START,"Great Quake",TX_END

Text0299: ; 3c552 (f:4552)
	db TX_START,"Bone Attack",TX_END

Text029a: ; 3c55f (f:455f)
	db TX_START,"Excavation",TX_END

Text029b: ; 3c56b (f:456b)
	db TX_START,"Rock Crusher",TX_END

Text029c: ; 3c579 (f:4579)
	db TX_START,"Blue Water",TX_END

Text029d: ; 3c585 (f:4585)
	db TX_START,"On the Beach",TX_END

Text029e: ; 3c593 (f:4593)
	db TX_START,"Paralyze!",TX_END

Text029f: ; 3c59e (f:459e)
	db TX_START,"Energy Removal",TX_END

Text02a0: ; 3c5ae (f:45ae)
	db TX_START,"Rain Dancer",TX_END

Text02a1: ; 3c5bb (f:45bb)
	db TX_START,"Cute Pok`mon",TX_END

Text02a2: ; 3c5c9 (f:45c9)
	db TX_START,"Pok`mon Flute",TX_END

Text02a3: ; 3c5d8 (f:45d8)
	db TX_START,"Yellow Flash",TX_END

Text02a4: ; 3c5e6 (f:45e6)
	db TX_START,"Electric Shock",TX_END

Text02a5: ; 3c5f6 (f:45f6)
	db TX_START,"Zapping Selfdestruct",TX_END

Text02a6: ; 3c60c (f:460c)
	db TX_START,"Insect Collection",TX_END

Text02a7: ; 3c61f (f:461f)
	db TX_START,"Jungle",TX_END

Text02a8: ; 3c627 (f:4627)
	db TX_START,"Flower Garden",TX_END

Text02a9: ; 3c636 (f:4636)
	db TX_START,"Kaleidoscope",TX_END

Text02aa: ; 3c644 (f:4644)
	db TX_START,"Flower Power",TX_END

Text02ab: ; 3c652 (f:4652)
	db TX_START,"Psychic Power",TX_END

Text02ac: ; 3c661 (f:4661)
	db TX_START,"Dream Eater Haunter",TX_END

Text02ad: ; 3c676 (f:4676)
	db TX_START,"Scavenging Slowbro",TX_END

Text02ae: ; 3c68a (f:468a)
	db TX_START,"Strange Power",TX_END

Text02af: ; 3c699 (f:4699)
	db TX_START,"Strange Psyshock",TX_END

Text02b0: ; 3c6ab (f:46ab)
	db TX_START,"Lovely Nidoran",TX_END

Text02b1: ; 3c6bb (f:46bb)
	db TX_START,"Science Corps",TX_END

Text02b2: ; 3c6ca (f:46ca)
	db TX_START,"Flyin' Pok`mon",TX_END

Text02b3: ; 3c6da (f:46da)
	db TX_START,"Poison",TX_END

Text02b4: ; 3c6e2 (f:46e2)
	db TX_START,"Wonders of Science",TX_END

Text02b5: ; 3c6f6 (f:46f6)
	db TX_START,"Replace 'Em All",TX_END

Text02b6: ; 3c707 (f:4707)
	db TX_START,"Chari-Saur",TX_END

Text02b7: ; 3c713 (f:4713)
	db TX_START,"Traffic Light",TX_END

Text02b8: ; 3c722 (f:4722)
	db TX_START,"Fire Pok`mon",TX_END

Text02b9: ; 3c730 (f:4730)
	db TX_START,"Fire Charge",TX_END

Text02ba: ; 3c73d (f:473d)
	db TX_START,"Charmander & Friends",TX_END

Text02bb: ; 3c753 (f:4753)
	db TX_START,"Squirtle & Friends",TX_END

Text02bc: ; 3c767 (f:4767)
	db TX_START,"Bulbasaur & Friends",TX_END

Text02bd: ; 3c77c (f:477c)
	db TX_START,"Psychic Machamp",TX_END

Text02be: ; 3c78d (f:478d)
	db TX_START,"Water Beetle",TX_END

Text02bf: ; 3c79b (f:479b)
	db TX_START,"Legendary Moltres",TX_END

Text02c0: ; 3c7ae (f:47ae)
	db TX_START,"Legendary Zapdos",TX_END

Text02c1: ; 3c7c0 (f:47c0)
	db TX_START,"Legendary Articuno",TX_END

Text02c2: ; 3c7d4 (f:47d4)
	db TX_START,"Legendary Dragonite",TX_END

Text02c3: ; 3c7e9 (f:47e9)
	db TX_START,"Mysterious Pok`mon",TX_END

Text02c4: ; 3c7fd (f:47fd)
	db TX_START,"A Deck of Fighting Pok`mon:\n"
	db "Feel their Fighting power!",TX_END

Text02c5: ; 3c835 (f:4835)
	db TX_START,"A Deck of Pok`mon that can\n"
	db "attack the Bench.",TX_END

Text02c6: ; 3c863 (f:4863)
	db TX_START,"A Deck which uses Fighting Attacks\n"
	db "such as Slash and Punch.",TX_END

Text02c7: ; 3c8a0 (f:48a0)
	db TX_START,"A powerful Deck with both Fire\n"
	db "and Fighting Pok`mon.",TX_END

Text02c8: ; 3c8d6 (f:48d6)
	db TX_START,"A Deck for fast and furious \n"
	db "attacks.",TX_END

Text02c9: ; 3c8fd (f:48fd)
	db TX_START,"A Deck made of Mouse Pok`mon.\n"
	db "Uses PlusPower to Power up!",TX_END

Text02ca: ; 3c938 (f:4938)
	db TX_START,"Use Dugtrio's Earthquake\n"
	db "to cause great damage.",TX_END

Text02cb: ; 3c969 (f:4969)
	db TX_START,"A Deck of Cubone and Marowak - \n"
	db "A call for help.",TX_END

Text02cc: ; 3c99b (f:499b)
	db TX_START,"A Deck which creates Pok`mon by\n"
	db "evolving Mysterious Fossils.",TX_END

Text02cd: ; 3c9d9 (f:49d9)
	db TX_START,"A Deck of Rock Pok`mon. It's\n"
	db "Strong against Lightning Pok`mon.",TX_END

Text02ce: ; 3ca19 (f:4a19)
	db TX_START,"A Deck of Water Pok`mon: Their\n"
	db "Blue Horror washes over enemies.",TX_END

Text02cf: ; 3ca5a (f:4a5a)
	db TX_START,"A well balanced Deck\n"
	db "of Sandshrew and Water Pok`mon!",TX_END

Text02d0: ; 3ca90 (f:4a90)
	db TX_START,"Paralyze the opponent's Pok`mon:\n"
	db "Stop 'em and drop 'em!",TX_END

Text02d1: ; 3cac9 (f:4ac9)
	db TX_START,"Uses Whirlpool and Hyper Beam to\n"
	db "remove opponents' Energy cards.",TX_END

Text02d2: ; 3cb0b (f:4b0b)
	db TX_START,"Use Rain Dance to attach Water\n"
	db "Energy for powerful Attacks!",TX_END

Text02d3: ; 3cb48 (f:4b48)
	db TX_START,"A Deck of cute Pok`mon such as\n"
	db "Pikachu and Eevee.",TX_END

Text02d4: ; 3cb7b (f:4b7b)
	db TX_START,"Use the Pok`mon Flute to revive\n"
	db "opponents' Pok`mon and Attack!",TX_END

Text02d5: ; 3cbbb (f:4bbb)
	db TX_START,"A deck of Pok`mon that use Lightning\n"
	db "Energy to zap opponents.",TX_END

Text02d6: ; 3cbfa (f:4bfa)
	db TX_START,"A Deck which Shocks and Paralyzes\n"
	db "opponents with its Attacks.",TX_END

Text02d7: ; 3cc39 (f:4c39)
	db TX_START,"Selfdestruct causes great damage \n"
	db "- even to the opponent's Bench.",TX_END

Text02d8: ; 3cc7c (f:4c7c)
	db TX_START,"A Deck made of Insect Pok`mon\n"
	db "Go Bug Power!",TX_END

Text02d9: ; 3cca9 (f:4ca9)
	db TX_START,"A Deck of Grass Pok`mon: There \n"
	db "are many dangers in the Jungle.",TX_END

Text02da: ; 3ccea (f:4cea)
	db TX_START,"A Deck of Flower Pok`mon:\n"
	db "Beautiful but Dangerous",TX_END

Text02db: ; 3cd1d (f:4d1d)
	db TX_START,"Uses Venomoth's Pok`mon Power to\n"
	db "change the opponent's Weakness.",TX_END

Text02dc: ; 3cd5f (f:4d5f)
	db TX_START,"A powerful Big Eggsplosion \n"
	db "and Energy Transfer combo!",TX_END

Text02dd: ; 3cd97 (f:4d97)
	db TX_START,"Use the Psychic power of the\n"
	db "Psychic Pok`mon to Attack!",TX_END

Text02de: ; 3cdd0 (f:4dd0)
	db TX_START,"Uses Haunter's Dream Eater\n"
	db "to cause great damage!",TX_END

Text02df: ; 3ce03 (f:4e03)
	db TX_START,"Continually draw Trainer \n"
	db "Cards from the Discard Pile!",TX_END

Text02e0: ; 3ce3b (f:4e3b)
	db TX_START,"Confuse opponents with\n"
	db "mysterious power!",TX_END

Text02e1: ; 3ce65 (f:4e65)
	db TX_START,"Use Alakazam's Damage Swap\n"
	db "to move damage counters!",TX_END

Text02e2: ; 3ce9a (f:4e9a)
	db TX_START,"Uses Nidoqueen's Boyfriends to cause\n"
	db "great damage to the opponent.",TX_END

Text02e3: ; 3cede (f:4ede)
	db TX_START,"The march of the Science Corps!\n"
	db "Attack with the power of science!",TX_END

Text02e4: ; 3cf21 (f:4f21)
	db TX_START,"Pok`mon with feathers flock \n"
	db "together! Retreating is easy!",TX_END

Text02e5: ; 3cf5d (f:4f5d)
	db TX_START,"A Deck that uses Poison to \n"
	db "slowly Knock Out the opponent.",TX_END

Text02e6: ; 3cf99 (f:4f99)
	db TX_START,"Block Pok`mon Powers with \n"
	db "Muk and attack with Mewtwo!",TX_END

Text02e7: ; 3cfd1 (f:4fd1)
	db TX_START,"A Deck that shuffles\n"
	db "the opponent's cards",TX_END

Text02e8: ; 3cffc (f:4ffc)
	db TX_START,"Attack with Charizard - with \n"
	db "just a few Fire Energy cards!",TX_END

Text02e9: ; 3d039 (f:5039)
	db TX_START,"Pok`mon that can Attack with\n"
	db "Fire, Water or Lightning Energy!",TX_END

Text02ea: ; 3d078 (f:5078)
	db TX_START,"With Fire Pok`mon like Charizard, \n"
	db "Rapidash and Magmar, it's hot!",TX_END

Text02eb: ; 3d0bb (f:50bb)
	db TX_START,"Desperate attacks Damage your \n"
	db "opponent and you!",TX_END

Text02ec: ; 3d0ed (f:50ed)
	db TX_START,"A Fire, Grass and Water Deck:\n"
	db "Charmander, Pinsir and Seel",TX_END

Text02ed: ; 3d128 (f:5128)
	db TX_START,"A Water, Fire, and Lightning Deck:\n"
	db "Squirtle, Charmander and Pikachu",TX_END

Text02ee: ; 3d16d (f:516d)
	db TX_START,"A Grass, Lightning and Psychic Deck:\n"
	db "Bulbasaur, Pikachu and Abra",TX_END

Text02ef: ; 3d1af (f:51af)
	db TX_START,"Machamp, Hitmonlee, Hitmonchan\n"
	db "Gengar and Alakazam are furious!",TX_END

Text02f0: ; 3d1f0 (f:51f0)
	db TX_START,"An Evolution Deck with Weedle, \n"
	db "Nidoran$ and Bellsprout.",TX_END

Text02f1: ; 3d22a (f:522a)
	db TX_START,"Gather Fire Energy with the\n"
	db "Legendary Moltres!",TX_END

Text02f2: ; 3d25a (f:525a)
	db TX_START,"Zap opponents with the\n"
	db "Legandary Zapdos!",TX_END

Text02f3: ; 3d284 (f:5284)
	db TX_START,"Paralyze opponents with the\n"
	db "Legendary Articuno!",TX_END

Text02f4: ; 3d2b5 (f:52b5)
	db TX_START,"Heal your Pok`mon with the\n"
	db "Legendary Dragonite!",TX_END

Text02f5: ; 3d2e6 (f:52e6)
	db TX_START,"A very special Deck made of\n"
	db "very rare Pok`mon cards!",TX_END

Text02f6: ; 3d31c (f:531c)
	db TX_START,"Pok`mon Card Glossary",TX_END

Text02f7: ; 3d333 (f:5333)
	db TX_START,"Deck                Active Pok`mon\n"
	db "Discard Pile        Bench Pok`mon\n"
	db "Hand                Prizes    \n"
	db "Arena               Damage Counter\n"
	db "Bench               To next page    ",TX_END

Text02f8: ; 3d3e0 (f:53e0)
	db TX_START,"Energy Card         Pok`mon Power \n"
	db "Trainer Card        Weakness       \n"
	db "Basic Pok`mon       Resistance\n"
	db "Evolution Card      Retreat       \n"
	db "Attack              To previous page",TX_END

Text02f9: ; 3d48f (f:548f)
	db TX_START,"Choose a word and press the\n"
	db "A button.",TX_END

Text02fa: ; 3d4b6 (f:54b6)
	db TX_START,"About the Deck",TX_END

Text02fb: ; 3d4c6 (f:54c6)
	db TX_START,"About the Discard Pile",TX_END

Text02fc: ; 3d4de (f:54de)
	db TX_START,"About the Hand",TX_END

Text02fd: ; 3d4ee (f:54ee)
	db TX_START,"About the Arena",TX_END

Text02fe: ; 3d4ff (f:54ff)
	db TX_START,"About the Bench",TX_END

Text02ff: ; 3d510 (f:5510)
	db TX_START,"About the Active Pok`mon",TX_END

Text0300: ; 3d52a (f:552a)
	db TX_START,"About Bench Pok`mon",TX_END

Text0301: ; 3d53f (f:553f)
	db TX_START,"About Prizes",TX_END

Text0302: ; 3d54d (f:554d)
	db TX_START,"About Damage Counters",TX_END

Text0303: ; 3d564 (f:5564)
	db TX_START,"About Energy Cards",TX_END

Text0304: ; 3d578 (f:5578)
	db TX_START,"About Trainer Cards",TX_END

Text0305: ; 3d58d (f:558d)
	db TX_START,"About Basic Pok`mon",TX_END

Text0306: ; 3d5a2 (f:55a2)
	db TX_START,"About Evolution Cards",TX_END

Text0307: ; 3d5b9 (f:55b9)
	db TX_START,"About Attacking",TX_END

Text0308: ; 3d5ca (f:55ca)
	db TX_START,"About Pok`mon Power",TX_END

Text0309: ; 3d5df (f:55df)
	db TX_START,"About Weakness",TX_END

Text030a: ; 3d5ef (f:55ef)
	db TX_START,"About Resistance",TX_END

Text030b: ; 3d601 (f:5601)
	db TX_START,"About Retreating",TX_END

Text030c: ; 3d613 (f:5613)
	db TX_START,"The Deck is the pile of cards\n"
	db "you will be drawing from.\n"
	db "At the beginning of your turn, you\n"
	db "will draw 1 card from your Deck.\n"
	db "If there are no cards to draw\n"
	db "from the Deck, you lose the game.",TX_END

Text030d: ; 3d6d0 (f:56d0)
	db TX_START,"The pile in which you place used\n"
	db "cards is called the Discard Pile.\n"
	db "You can look at both yours and your\n"
	db "opponent's Discard Pile \n"
	db "with the Check command.",TX_END

Text030e: ; 3d769 (f:5769)
	db TX_START,"The cards held by each player\n"
	db "are called a Hand.\n"
	db "There is no restriction to the\n"
	db "number of cards in the Hand.\n"
	db "You may even have 10 or 20 \n"
	db "cards in your Hand.",TX_END

Text030f: ; 3d807 (f:5807)
	db TX_START,"The place where the Pok`mon\n"
	db "that is actively fighting\n"
	db "is placed is called the Arena.\n"
	db "The game proceeds by using the\n"
	db "Active Pok`mon in the Arena.",TX_END

Text0310: ; 3d899 (f:5899)
	db TX_START,"The Bench is where your Pok`mon\n"
	db "that are in play but aren't actively\n"
	db "fighting sit.\n"
	db "They're ready to come out and fight\n"
	db "if the Active Pok`mon retreats or\n"
	db "is Knocked Out.\n"
	db "You can have up to 5 Pok`mon on\n"
	db "the Bench.",TX_END

Text0311: ; 3d96e (f:596e)
	db TX_START,"The Active Pok`mon is the \n"
	db "Pok`mon that is in the Arena.\n"
	db "Only Active Pok`mon can \n"
	db "attack.",TX_END

Text0312: ; 3d9c9 (f:59c9)
	db TX_START,"The Pok`mon that are in play\n"
	db "but aren't actively fighting\n"
	db "are called Bench Pok`mon.\n"
	db "They're ready to come out and fight\n"
	db "if the Active Pok`mon retreats or\n"
	db "is Knocked Out.\n"
	db "If the Active Pok`mon is Knocked\n"
	db "Out and you don't have a Bench \n"
	db "Pok`mon, you lose the game.",TX_END

Text0313: ; 3dad1 (f:5ad1)
	db TX_START,"Prizes are the cards placed to\n"
	db "count the number of the opponent's\n"
	db "Pok`mon you Knocked Out.\n"
	db "Every time one of your opponent's\n"
	db "Pok`mon is Knocked Out, you take 1\n"
	db "of your Prizes into your Hand.\n"
	db "When you take all of your Prizes,\n"
	db "you win the game.",TX_END

Text0314: ; 3dbc5 (f:5bc5)
	db TX_START,"A Damage Counter represents the\n"
	db "amount of damage a certain Pok`mon\n"
	db "has taken.\n"
	db "1 Damage Counter represents\n"
	db "10 HP of damage.\n"
	db "If a Pok`mon with an HP of 30 has\n"
	db "3 Damage Counters, it has received\n"
	db "30 HP of damage, and its remaining\n"
	db "HP is 0.",TX_END

Text0315: ; 3dcb2 (f:5cb2)
	db TX_START,"Energy Cards are cards that power\n"
	db "your Pok`mon, making them able\n"
	db "to Attack.\n"
	db "There are 7 types of Energy Cards\n"
	db "[",TX_GRASS," Grass] [",TX_FIRE," Fire]\n"
	db "[",TX_WATER," Water] [",TX_LIGHTNING," Lightning]\n"
	db "[",TX_PSYCHIC," Psychic] [",TX_FIGHTING," Fighting]\n"
	db "and [",TX_COLORLESS," Double Colorless]\n"
	db "You may only play 1 Energy Card\n"
	db "from your Hand per turn.",TX_END

Text0316: ; 3ddbe (f:5dbe)
	db TX_START,"Trainer Cards are support cards.\n"
	db "There are many Trainer Cards\n"
	db "with different effects.\n"
	db "Trainer Cards are played during\n"
	db "your turn by following the\n"
	db "instructions on the card and then\n"
	db "discarding it.\n"
	db "You may use as many Trainer Cards\n"
	db "as you like.",TX_END

Text0317: ; 3deb0 (f:5eb0)
	db TX_START,"Basic Pok`mon are cards that \n"
	db "can be played directly from your \n"
	db "hand into the play area. Basic \n"
	db "Pok`mon act as the base for \n"
	db "Evolution Cards. Charmander, \n"
	db "Squirtle and Bulbasaur are\n"
	db "examples of Basic Pok`mon.",TX_END

Text0318: ; 3df82 (f:5f82)
	db TX_START,"Evolution Cards are cards you\n"
	db "play on top of a Basic Pok`mon card\n"
	db "(or sometimes on top of another\n"
	db "Evolution Card) to make it stronger.\n"
	db "There are Stage 1 and Stage 2\n"
	db "Evolution Cards.\n"
	db "If you do not have a Basic Pok`mon\n"
	db "in the Play Area, you cannot place\n"
	db "the Stage 1 Evolution Card, and if\n"
	db "you do not have a Stage 1 Evolution\n"
	db "Card in the Play Area, you cannot\n"
	db "place the Stage 2 Evolution Card.",TX_END

Text0319: ; 3e10a (f:610a)
	db TX_START,"By choosing Attack, your Pok`mon\n"
	db "will fight your opponent's Pok`mon.\n"
	db "Your Pok`mon require Energy\n"
	db "in order to Attack.\n"
	db "The amount of Energy required\n"
	db "differs according to the Attack.\n"
	db "The Active Pok`mon is the only\n"
	db "Pok`mon that can Attack.",TX_END

Text031a: ; 3e1f7 (f:61f7)
	db TX_START,"Unlike Attacks, Pok`mon Power\n"
	db "can be used by Active or Benched\n"
	db "Pok`mon. Some Pok`mon Power are\n"
	db "effective by just placing the\n"
	db "Pok`mon in the Play Area, but for\n"
	db "some you must choose the\n"
	db "command, PKMN Power.",TX_END

Text031b: ; 3e2c5 (f:62c5)
	db TX_START,"Some Pok`mon have a Weakness.\n"
	db "If a Pok`mon has a Weakness, it\n"
	db "takes double damage when attacked by\n"
	db "Pok`mon of a certain type.",TX_END

Text031c: ; 3e344 (f:6344)
	db TX_START,"Some Pok`mon have Resistance.\n"
	db "If a Pok`mon has Resistance, it\n"
	db "takes 30 less damage whenever\n"
	db "attacked by Pok`mon of\n"
	db "a certain type.",TX_END

Text031d: ; 3e3c8 (f:63c8)
	db TX_START,"By choosing Retreat, you can\n"
	db "switch the Active Pok`mon with\n"
	db "a Pok`mon on your Bench.\n"
	db "Energy is required to Retreat\n"
	db "your Active Pok`mon.\n"
	db "The amount of Energy required to\n"
	db "Retreat differs for each Pok`mon.\n"
	db "To Retreat, you must discard\n"
	db "Energy equal to the Retreat Cost\n"
	db "of the retreating Pok`mon.",TX_END

Text031e: ; 3e4ed (f:64ed)
	db TX_START,"Modify Deck\n"
	db "Card List\n"
	db "Album List\n"
	db "Deck Save Machine\n"
	db "Printing Menu\n"
	db "Auto Deck Machine\n"
	db "Gift Center\n"
	db "Name Input",TX_END

Text031f: ; 3e558 (f:6558)
	db TX_START,"Fighting Machine\n"
	db "Rock Machine\n"
	db "Water Machine\n"
	db "Lightning Machine\n"
	db "Grass Machine\n"
	db "Psychic Machine\n"
	db "Science Machine\n"
	db "Fire Machine\n"
	db "Auto Machine\n"
	db "Legendary Machine",TX_END

Text0320: ; 3e5f1 (f:65f1)
	db TX_START,"Send a Card\n"
	db "Receive a Card\n"
	db "Give Deck Instructions\n"
	db "Receive Deck Instructions",TX_END

Text0321: ; 3e63e (f:663e)
	db TX_START,"Lecture Duel",TX_END

Text0322: ; 3e64c (f:664c)
	db TX_START,"First Strike Deck\n"
	db TX_END

Text0323: ; 3e660 (f:6660)
	db TX_START,"  Mason Laboratory  ",TX_END

Text0324: ; 3e676 (f:6676)
	db TX_START,"  ISHIHARA's House  ",TX_END

Text0325: ; 3e68c (f:668c)
	db TX_START,"   Fighting Club    ",TX_END

Text0326: ; 3e6a2 (f:66a2)
	db TX_START,"     Rock Club      ",TX_END

Text0327: ; 3e6b8 (f:66b8)
	db TX_START,"     Water Club     ",TX_END

Text0328: ; 3e6ce (f:66ce)
	db TX_START,"   Lightning Club   ",TX_END

Text0329: ; 3e6e4 (f:66e4)
	db TX_START,"     Grass Club     ",TX_END

Text032a: ; 3e6fa (f:66fa)
	db TX_START,"    Psychic Club    ",TX_END

Text032b: ; 3e710 (f:6710)
	db TX_START,"    Science Club    ",TX_END

Text032c: ; 3e726 (f:6726)
	db TX_START,"     Fire Club      ",TX_END

Text032d: ; 3e73c (f:673c)
	db TX_START,"   Challenge Hall   ",TX_END

Text032e: ; 3e752 (f:6752)
	db TX_START,"    Pok`mon Dome    ",TX_END

Text032f: ; 3e768 (f:6768)
	db TX_START,"     ??'s House     ",TX_END

Text0330: ; 3e77e (f:677e)
	db TX_START,"Mason Laboratory",TX_END

Text0331: ; 3e790 (f:6790)
	db TX_START,"Mr Ishihara's House",TX_END

Text0332: ; 3e7a5 (f:67a5)
	db TX_START,"Fighting",TX_END

Text0333: ; 3e7af (f:67af)
	db TX_START,"Rock",TX_END

Text0334: ; 3e7b5 (f:67b5)
	db TX_START,"Water",TX_END

Text0335: ; 3e7bc (f:67bc)
	db TX_START,"Lightning",TX_END

Text0336: ; 3e7c7 (f:67c7)
	db TX_START,"Grass",TX_END

Text0337: ; 3e7ce (f:67ce)
	db TX_START,"Psychic",TX_END

Text0338: ; 3e7d7 (f:67d7)
	db TX_START,"Science",TX_END

Text0339: ; 3e7e0 (f:67e0)
	db TX_START,"Fire",TX_END

Text033a: ; 3e7e6 (f:67e6)
	db TX_START,"Challenge Hall",TX_END

Text033b: ; 3e7f6 (f:67f6)
	db TX_START,"Pok`mon Dome",TX_END

Text033c: ; 3e804 (f:6804)
	db TX_START,"??'s House",TX_END

Text033d: ; 3e810 (f:6810)
	db TX_START,"Status\n"
	db "Diary\n"
	db "Deck\n"
	db "Card\n"
	db "Config\n"
	db "Exit",TX_END

Text033e: ; 3e834 (f:6834)
	db TX_START,"Status\n"
	db "Diary\n"
	db "Deck\n"
	db "Card\n"
	db "Config\n"
	db "Debug\n"
	db "Close",TX_END

Text033f: ; 3e85f (f:685f)
	db TX_START,"Name ",TX_RAM1,TX_END

Text0340: ; 3e867 (f:6867)
	db TX_START,"Album           ",$07,$6d,TX_END

Text0341: ; 3e87b (f:687b)
	db TX_START,"Play time         ",$07,$03,$5e,TX_END

Text0342: ; 3e892 (f:6892)
	db TX_START,TX_RAM1,"'s diary",TX_END

Text0343: ; 3e89d (f:689d)
	db TX_START,"Master Medals Won ",TX_END

Text0344: ; 3e8b1 (f:68b1)
	db TX_START,"Would you like to keep a diary?",TX_END

Text0345: ; 3e8d2 (f:68d2)
	db TX_START,TX_RAM1,"\n"
	db "wrote in the diary.",TX_END

Text0346: ; 3e8e9 (f:68e9)
	db TX_START,"Nothing was recorded \n"
	db "in the diary.",TX_END

Text0347: ; 3e90e (f:690e)
	db TX_START,"Master Medals",TX_END

Text0348: ; 3e91d (f:691d)
	db TX_START,"           Change Settings",TX_END

Text0349: ; 3e939 (f:6939)
	db TX_START,"Message Speed\n\n"
	db "   Slow   1   2   3   4   5   Fast",TX_END

Text034a: ; 3e96c (f:696c)
	db TX_START,"Duel Animation\n\n"
	db "  Show All    Skip Some       None",TX_END

Text034b: ; 3e9a0 (f:69a0)
	db TX_START,"   Exit Settings",TX_END

Text034c: ; 3e9b2 (f:69b2)
	db TX_START,"Duel           [",TX_RAM2,"]\n"
	db "SELECT         [",TX_RAM2,"]\n"
	db "Receive many cards\n"
	db "To Pok`mon Dome 1\n"
	db "To Pok`mon Dome 2",TX_END

Text034d: ; 3ea10 (f:6a10)
	db TX_START,"Normal Duel",TX_END

Text034e: ; 3ea1d (f:6a1d)
	db TX_START,"Skip",TX_END

Text034f: ; 3ea23 (f:6a23)
	db TX_START,"Normal",TX_END

Text0350: ; 3ea2b (f:6a2b)
	db TX_START,"Freeze Screen",TX_END

Text0351: ; 3ea3a (f:6a3a)
	db TX_START,"Card Album\n"
	db "Read Mail\n"
	db "Glossary\n"
	db "Print\n"
	db "Shut Down",TX_END

Text0352: ; 3ea69 (f:6a69)
	db TX_START,TX_RAM1,"\n"
	db "turned the PC on!",TX_END

Text0353: ; 3ea7e (f:6a7e)
	db TX_START,TX_RAM1,"\n"
	db "turned the PC off!",TX_END

Text0354: ; 3ea94 (f:6a94)
	db TX_START,"Send Card\n"
	db "Receive Card\n"
	db "Send Deck Configuration\n"
	db "Receive Deck Configuration\n"
	db "Exit",TX_END

Text0355: ; 3eae4 (f:6ae4)
	db TX_START,"Send Card",TX_END

Text0356: ; 3eaef (f:6aef)
	db TX_START,"Receive Card",TX_END

Text0357: ; 3eafd (f:6afd)
	db TX_START,"Send Deck Configuration",TX_END

Text0358: ; 3eb16 (f:6b16)
	db TX_START,"Receive Deck Configuration",TX_END

Text0359: ; 3eb32 (f:6b32)
	db TX_START,"   Mail ",TX_RAM1," ",TX_END

Text035a: ; 3eb3e (f:6b3e)
	db TX_START,"Which mail would you like to read?",TX_END

Text035b: ; 3eb62 (f:6b62)
	db TX_START,"Mail 0 1 2 3 4 5 6 7 8 9101112131415",TX_END

Text035c: ; 3eb88 (f:6b88)
	db "ppppp",TX_END

Text035d: ; 3eb8e (f:6b8e)
	db TX_START,"Mail 1",TX_END

Text035e: ; 3eb96 (f:6b96)
	db TX_START,"Mail 2",TX_END

Text035f: ; 3eb9e (f:6b9e)
	db TX_START,"Mail 3",TX_END

Text0360: ; 3eba6 (f:6ba6)
	db TX_START,"Mail 4",TX_END

Text0361: ; 3ebae (f:6bae)
	db TX_START,"Mail 5",TX_END

Text0362: ; 3ebb6 (f:6bb6)
	db TX_START,"Mail 6",TX_END

Text0363: ; 3ebbe (f:6bbe)
	db TX_START,"Mail 7",TX_END

Text0364: ; 3ebc6 (f:6bc6)
	db TX_START,"Mail 8",TX_END

Text0365: ; 3ebce (f:6bce)
	db TX_START,"Mail 9",TX_END

Text0366: ; 3ebd6 (f:6bd6)
	db TX_START,"Mail 10",TX_END

Text0367: ; 3ebdf (f:6bdf)
	db TX_START,"Mail 11",TX_END

Text0368: ; 3ebe8 (f:6be8)
	db TX_START,"Mail 12",TX_END

Text0369: ; 3ebf1 (f:6bf1)
	db TX_START,"Mail 13",TX_END

Text036a: ; 3ebfa (f:6bfa)
	db TX_START,"Mail 14",TX_END

Text036b: ; 3ec03 (f:6c03)
	db TX_START,"Mail 15",TX_END

Text036c: ; 3ec0c (f:6c0c)
	db TX_START,"NEW GAME",TX_END

Text036d: ; 3ec16 (f:6c16)
	db TX_START,"CARD POP!\n"
	db "CONTINUE FROM DIARY\n"
	db "NEW GAME",TX_END

Text036e: ; 3ec3e (f:6c3e)
	db TX_START,"CARD POP!\n"
	db "CONTINUE FROM DIARY\n"
	db "New Game\n"
	db "CONTINUE DUEL",TX_END

Text036f: ; 3ec74 (f:6c74)
	db TX_START,"When you CARD POP! with a friend,\n"
	db "you will each receive a new card!",TX_END

Text0370: ; 3ecb9 (f:6cb9)
	db TX_START,"  ",TX_RAM1,"  ",TX_RAM2,"\n"
	db "      Master Medals Won ",$07,$0c,$06,"\n"
	db "      Album           ",$07,$6d,$06,"\n"
	db "      Play time         ",$07,$03,$5e,$06,TX_END

Text0371: ; 3ed14 (f:6d14)
	db TX_START,"Start a New Game.\n"
	db TX_END

Text0372: ; 3ed28 (f:6d28)
	db TX_START,"The Game will continue from \n"
	db "the point in the duel at\n"
	db "which the power was turned OFF.",TX_END

Text0373: ; 3ed7f (f:6d7f)
	db TX_START,"Saved data already exists.\n"
	db "If you continue, you will lose\n"
	db "all the cards you have collected.",TX_END

Text0374: ; 3eddc (f:6ddc)
	db TX_START,"OK to delete the data?",TX_END

Text0375: ; 3edf4 (f:6df4)
	db TX_START,"All data was deleted.",TX_END

Text0376: ; 3ee0b (f:6e0b)
	db TX_START,"Data exists from when the power \n"
	db "was turned OFF during a duel.\n"
	db "Choose CONTINUE DUEL on the\n"
	db "Main Menu to continue the duel.\n"
	db "If you continue now, the heading,\n"
	db "CONTINUE DUEL, will be\n"
	db "deleted, and the game will start\n"
	db "from the point when you last \n"
	db "wrote in the Diary.\n\n"
	db "Would you like to continue the Game\n"
	db "from the point saved in",TX_END

Text0377: ; 3ef50 (f:6f50)
	db TX_START,"CONTINUE FROM DIARY?",TX_END

Text0378: ; 3ef66 (f:6f66)
	db TX_START,"You can access Card Pop! only\n"
	db "with two Game Boy Colors.\n"
	db "Please play using a Game Boy Color.",TX_END

Text0379: ; 3efc3 (f:6fc3)
	db TX_START,TX_RAM1," is crazy about Pok`mon\n"
	db "and Pok`mon card collecting!\n"
	db "One day,\n"
	db TX_RAM1," heard a rumor:\n"
	db " \"The Legendary Pok`mon Cards...\n"
	db "  the extremely rare and powerful \n"
	db "  cards held by Pok`mon Trading \n"
	db "  Card Game's greatest players... \n"
	db "  The Grand Masters are searching\n"
	db "  for one to inherit the legend!\"\n"
	db "Dreaming of inheriting the\n"
	db "Legendary Pok`mon Cards,\n"
	db TX_RAM1," visits the Pok`mon\n"
	db "card researcher, Dr. Mason...",TX_END

Text037a: ; 3f147 (f:7147)
	db TX_START,"POWER ON\n"
	db "DUEL MODE\n"
	db "CONTINUE FROM DIARY\n"
	db "CGB TEST\n"
	db "SGB FRAME\n"
	db "STANDARD BG CHARACTER\n"
	db "LOOK AT SPR\n"
	db "V EFFECT\n"
	db "CREATE BOOSTER PACK\n"
	db "CREDITS\n"
	db "QUIT",TX_END

Text037b: ; 3f1ce (f:71ce)
	db TX_START,"NORMAL DUEL\n"
	db "SKIP",TX_END

Text037c: ; 3f1e0 (f:71e0)
	db TX_START,"COLOSSEUM\n"
	db "EVOLUTION\n"
	db "MYSTERY\n"
	db "LABORATORY\n"
	db "Energy",TX_END

Text037d: ; 3f20f (f:720f)
	db TX_START,"1\n"
	db "2\n"
	db "3\n"
	db "4\n"
	db "5\n"
	db "6\n"
	db "7",TX_END

Text037e: ; 3f21e (f:721e)
	db TX_START,"1\n"
	db "2\n"
	db "3\n"
	db "4\n"
	db "5\n"
	db "6",TX_END

Text037f: ; 3f22b (f:722b)
	db TX_START,"1\n"
	db "2\n"
	db "3\n"
	db "4\n"
	db "5",TX_END

Text0380: ; 3f236 (f:7236)
	db TX_START,"1\n"
	db "2\n"
	db "3\n"
	db "4",TX_END

Text0381: ; 3f23f (f:723f)
	db TX_START,"A                   TIME\n"
	db "     TO      (Change with Start)\n"
	db "            A+B: Stop Animation\n"
	db "            Select: Exit",TX_END

Text0382: ; 3f2b3 (f:72b3)
	db TX_START,"Left",TX_END

Text0383: ; 3f2b9 (f:72b9)
	db TX_START,"Right",TX_END

Text0384: ; 3f2c0 (f:72c0)
	db TX_START,"SPR_",TX_END

Text0385: ; 3f2c6 (f:72c6)
	db TX_START,"WIN      ",TX_RAM3," Prizes Duel\n"
	db "LOSE     with ",TX_RAM2,"(",TX_RAM3,")",TX_END

Text0386: ; 3f2f1 (f:72f1)
	db TX_START,"         Use ",TX_RAM3,"'s Deck",TX_END

Text0387: ; 3f308 (f:7308)
	db TX_START,TX_RAM1," received a Booster\n"
	db "Pack: ",TX_RAM2,".",TX_END

Text0388: ; 3f327 (f:7327)
	db TX_START,"...And another Booster Pack:\n"
	db TX_RAM2,".",TX_END

Text0389: ; 3f348 (f:7348)
	db TX_START,TX_RAM1," checked the cards\n"
	db "in the Booster Pack!!",TX_END

Text038a: ; 3f373 (f:7373)
	db TX_START,"Substitute screen for\n"
	db "receiving cards.",TX_END

Text038b: ; 3f39b (f:739b)
	db TX_START,TX_RAM1,"\n"
	db "Won the ",TX_RAM2," Medal!",TX_END

Text038c: ; 3f3af (f:73af)
	db TX_START,"Substitute screen for sending\n"
	db "cards by Link cable.",TX_END

Text038d: ; 3f3e3 (f:73e3)
	db TX_START,"Substitute screen for receiving\n"
	db "cards by Link cable.",TX_END

Text038e: ; 3f419 (f:7419)
	db TX_START,"Substitute screen for sending\n"
	db "a Deck design.",TX_END

Text038f: ; 3f447 (f:7447)
	db TX_START,"Substitute screen for receiving\n"
	db "a Deck design.",TX_END

Text0390: ; 3f477 (f:7477)
	db TX_START,"????",TX_END

Text0391: ; 3f47d (f:747d)
	db TX_START,"Ending Screen\n"
	db "THE END",TX_END

Text0392: ; 3f494 (f:7494)
	db TX_START,"Was the data transfer successful?",TX_END

Text0393: ; 3f4b7 (f:74b7)
	db TX_START,"(Person transferring data to)",TX_END

Text0394: ; 3f4d6 (f:74d6)
	db TX_START,"(Name of Deck transferring)",TX_END

Text0395: ; 3f4f3 (f:74f3)
	db TX_START,TX_RAM2,"  ",TX_RAM2,TX_END

Text0396: ; 3f4f9 (f:74f9)
	db TX_START,TX_RAM2," Deck",TX_END

Text0397: ; 3f501 (f:7501)
	db TX_START,"Fighting Club Member",TX_END

Text0398: ; 3f517 (f:7517)
	db TX_START,"Rock Club Member",TX_END

Text0399: ; 3f529 (f:7529)
	db TX_START,"Water Club Member",TX_END

Text039a: ; 3f53c (f:753c)
	db TX_START,"Lightning Club Member",TX_END

Text039b: ; 3f553 (f:7553)
	db TX_START,"Grass Club Member",TX_END

Text039c: ; 3f566 (f:7566)
	db TX_START,"Psychic Club Member",TX_END

Text039d: ; 3f57b (f:757b)
	db TX_START,"Science Club Member",TX_END

Text039e: ; 3f590 (f:7590)
	db TX_START,"Fire Club Member",TX_END

Text039f: ; 3f5a2 (f:75a2)
	db TX_START,"Fighting Club Master",TX_END

Text03a0: ; 3f5b8 (f:75b8)
	db TX_START,"Rock Club Master",TX_END

Text03a1: ; 3f5ca (f:75ca)
	db TX_START,"Water Club Master",TX_END

Text03a2: ; 3f5dd (f:75dd)
	db TX_START,"Lightning Club Master",TX_END

Text03a3: ; 3f5f4 (f:75f4)
	db TX_START,"Grass Club Master",TX_END

Text03a4: ; 3f607 (f:7607)
	db TX_START,"Psychic Club Master",TX_END

Text03a5: ; 3f61c (f:761c)
	db TX_START,"Science Club Master",TX_END

Text03a6: ; 3f631 (f:7631)
	db TX_START,"Fire Club Master",TX_END

Text03a7: ; 3f643 (f:7643)
	db TX_END

Text03a8: ; 3f644 (f:7644)
	db TX_START,"COLOSSEUM",TX_END

Text03a9: ; 3f64f (f:764f)
	db TX_START,"EVOLUTION",TX_END

Text03aa: ; 3f65a (f:765a)
	db TX_START,"MYSTERY",TX_END

Text03ab: ; 3f663 (f:7663)
	db TX_START,"LABORATORY",TX_END

Text03ac: ; 3f66f (f:766f)
	db TX_START,"Dr. Mason",TX_END

Text03ad: ; 3f67a (f:767a)
	db TX_START,"Ronald",TX_END

Text03ae: ; 3f682 (f:7682)
	db TX_START,"ISHIHARA",TX_END

Text03af: ; 3f68c (f:768c)
	db TX_START,"Imakuni?",TX_END

Text03b0: ; 3f696 (f:7696)
	db TX_START,"CLERK",TX_END

Text03b1: ; 3f69d (f:769d)
	db TX_START,"Sam",TX_END

Text03b2: ; 3f6a2 (f:76a2)
	db TX_START,"TECH",TX_END

Text03b3: ; 3f6a8 (f:76a8)
	db TX_START,"CLERK",TX_END

Text03b4: ; 3f6af (f:76af)
	db TX_START,"Chris",TX_END

Text03b5: ; 3f6b6 (f:76b6)
	db TX_START,"Michael",TX_END

Text03b6: ; 3f6bf (f:76bf)
	db TX_START,"Jessica",TX_END

Text03b7: ; 3f6c8 (f:76c8)
	db TX_START,"Mitch",TX_END

Text03b8: ; 3f6cf (f:76cf)
	db TX_START,"Matthew",TX_END

Text03b9: ; 3f6d8 (f:76d8)
	db TX_START,"Ryan",TX_END

Text03ba: ; 3f6de (f:76de)
	db TX_START,"Andrew",TX_END

Text03bb: ; 3f6e6 (f:76e6)
	db TX_START,"Gene",TX_END

Text03bc: ; 3f6ec (f:76ec)
	db TX_START,"Sara",TX_END

Text03bd: ; 3f6f2 (f:76f2)
	db TX_START,"Amanda",TX_END

Text03be: ; 3f6fa (f:76fa)
	db TX_START,"Joshua",TX_END

Text03bf: ; 3f702 (f:7702)
	db TX_START,"Amy",TX_END

Text03c0: ; 3f707 (f:7707)
	db TX_START,"Jennifer",TX_END

Text03c1: ; 3f711 (f:7711)
	db TX_START,"Nicholas",TX_END

Text03c2: ; 3f71b (f:771b)
	db TX_START,"Brandon",TX_END

Text03c3: ; 3f724 (f:7724)
	db TX_START,"Isaac",TX_END

Text03c4: ; 3f72b (f:772b)
	db TX_START,"Brittany",TX_END

Text03c5: ; 3f735 (f:7735)
	db TX_START,"Kristin",TX_END

Text03c6: ; 3f73e (f:773e)
	db TX_START,"Heather",TX_END

Text03c7: ; 3f747 (f:7747)
	db TX_START,"Nikki",TX_END

Text03c8: ; 3f74e (f:774e)
	db TX_START,"Robert",TX_END

Text03c9: ; 3f756 (f:7756)
	db TX_START,"Daniel",TX_END

Text03ca: ; 3f75e (f:775e)
	db TX_START,"Stephanie",TX_END

Text03cb: ; 3f769 (f:7769)
	db TX_START,"Murray",TX_END

Text03cc: ; 3f771 (f:7771)
	db TX_START,"Joseph",TX_END

Text03cd: ; 3f779 (f:7779)
	db TX_START,"David",TX_END

Text03ce: ; 3f780 (f:7780)
	db TX_START,"Erik",TX_END

Text03cf: ; 3f786 (f:7786)
	db TX_START,"Rick",TX_END

Text03d0: ; 3f78c (f:778c)
	db TX_START,"John",TX_END

Text03d1: ; 3f792 (f:7792)
	db TX_START,"Adam",TX_END

Text03d2: ; 3f798 (f:7798)
	db TX_START,"Jonathan",TX_END

Text03d3: ; 3f7a2 (f:77a2)
	db TX_START,"Ken",TX_END

Text03d4: ; 3f7a7 (f:77a7)
	db TX_START,"COURTNEY",TX_END

Text03d5: ; 3f7b1 (f:77b1)
	db TX_START,"Steve",TX_END

Text03d6: ; 3f7b8 (f:77b8)
	db TX_START,"Jack",TX_END

Text03d7: ; 3f7be (f:77be)
	db TX_START,"Rod",TX_END

Text03d8: ; 3f7c3 (f:77c3)
	db TX_START,"Man",TX_END

Text03d9: ; 3f7c8 (f:77c8)
	db TX_START,"Woman",TX_END

Text03da: ; 3f7cf (f:77cf)
	db TX_START,"CHAP",TX_END

Text03db: ; 3f7d5 (f:77d5)
	db TX_START,"GAL",TX_END

Text03dc: ; 3f7da (f:77da)
	db TX_START,"Lass",TX_END

Text03dd: ; 3f7e0 (f:77e0)
	db TX_START,"Pappy",TX_END

Text03de: ; 3f7e7 (f:77e7)
	db TX_START,"Lad",TX_END

Text03df: ; 3f7ec (f:77ec)
	db TX_START,"HOST",TX_END

Text03e0: ; 3f7f2 (f:77f2)
	db TX_START,"Specs",TX_END

Text03e1: ; 3f7f9 (f:77f9)
	db TX_START,"Butch",TX_END

Text03e2: ; 3f800 (f:7800)
	db TX_START,"Hood",TX_END

Text03e3: ; 3f806 (f:7806)
	db TX_START,"Champ",TX_END

Text03e4: ; 3f80d (f:780d)
	db TX_START,"Mania",TX_END

Text03e5: ; 3f814 (f:7814)
	db TX_START,"Granny",TX_END

Text03e6: ; 3f81c (f:781c)
	db TX_START,"Guide",TX_END

Text03e7: ; 3f823 (f:7823)
	db TX_START,"Aaron",TX_END

Text03e8: ; 3f82a (f:782a)
	db TX_START,TX_LVL,"60 MEWTWO ",TX_END

Text03e9: ; 3f838 (f:7838)
	db TX_START,TX_LVL,"8 MEW ",TX_END

Text03ea: ; 3f842 (f:7842)
	db TX_START,TX_LVL,"34 ARCANINE",TX_END

Text03eb: ; 3f851 (f:7851)
	db TX_START,TX_LVL,"16 PIKACHU",TX_END

Text03ec: ; 3f85f (f:785f)
	db TX_START,TX_LVL,"13 SURFING PIKACHU",TX_END

Text03ed: ; 3f875 (f:7875)
	db TX_START,TX_LVL,"20 ELECTABUZZ",TX_END

Text03ee: ; 3f886 (f:7886)
	db TX_START,TX_LVL,"9 SLOWPOKE",TX_END

Text03ef: ; 3f894 (f:7894)
	db TX_START,TX_LVL,"12 JIGGLYPUFF",TX_END

Text03f0: ; 3f8a5 (f:78a5)
	db TX_START,TX_LVL,"68 ZAPDOS",TX_END

Text03f1: ; 3f8b2 (f:78b2)
	db TX_START,TX_LVL,"37 MOLTRES",TX_END

Text03f2: ; 3f8c0 (f:78c0)
	db TX_START,TX_LVL,"37 ARTICUNO",TX_END

Text03f3: ; 3f8cf (f:78cf)
	db TX_START,TX_LVL,"41 DRAGONITE",TX_END

Text03f4: ; 3f8df (f:78df)
	db TX_START,"Super Energy Retrieval",TX_END

Text03f5: ; 3f8f7 (f:78f7)
	db TX_START,TX_LVL,"12 FLYING PIKACHU",TX_END

Text03f6: ; 3f90c (f:790c)
	db TX_START,"Lightning & Fire Deck",TX_END

Text03f7: ; 3f923 (f:7923)
	db TX_START,"Water & Fighting Deck",TX_END

Text03f8: ; 3f93a (f:793a)
	db TX_START,"Grass & Psychic Deck",TX_END

Text03f9: ; 3f950 (f:7950)
	db TX_START,"Please select the Deck\n"
	db "you wish to Duel against.",TX_END

Text03fa: ; 3f982 (f:7982)
	db TX_START,"CHARMANDER & Friends Deck",TX_END

Text03fb: ; 3f99d (f:799d)
	db TX_START,"SQUIRTLE & Friends Deck",TX_END

Text03fc: ; 3f9b6 (f:79b6)
	db TX_START,"BULBASAUR & Friends Deck",TX_END

Text03fd: ; 3f9d0 (f:79d0)
	db TX_START,"Please select the Deck you want.",TX_END

Text03fe: ; 3f9f2 (f:79f2)
	db TX_START,"Hi, ",TX_RAM1,".\n"
	db "How can I help you?",TX_END

Text03ff: ; 3fa0e (f:7a0e)
	db TX_START,"Normal Duel\n"
	db "Practice\n"
	db "Rules\n"
	db "Nothing",TX_END

Text0400: ; 3fa32 (f:7a32)
	db TX_START,"Energy\n"
	db "Attacking\n"
	db "Retreating\n"
	db "Evolving Pok`mon\n"
	db "Using Pok`mon Power\n"
	db "Ending Your Turn\n"
	db "Win or Loss of a Duel\n"
	db "Nothing to Ask",TX_END

Text0401: ; 3faaa (f:7aaa)
	db TX_START,TX_RAM1,",\n"
	db "It's me, Doctor Mason.\n"
	db "Are you getting the hang of\n"
	db "the Pok`mon Trading Card Game?\n"
	db "I have some information for you\n"
	db "about Booster Packs. \n"
	db "If you want to collect the same\n"
	db "cards, duel the same person many\n"
	db "times to get a particular Booster\n"
	db "Pack! By doing so, you will be able \n"
	db "to collect the same cards, making it\n"
	db "easier for you to build your Deck.\n"
	db "Another method for collecting \n"
	db "cards is to use CARD POP!\n"
	db "When you and a friend use CARD POP!,\n"
	db "you will each receive a new card!\n"
	db "Once you POP! with a certain\n"
	db "friend, you won't be able to POP!\n"
	db "with that friend again, so find \n"
	db "many friends who own the Pok`mon \n"
	db "Trading Card Game for Game Boy,\n"
	db "and CARD POP! with them to\n"
	db "get new cards!\n"
	db "Oh, here's something for you...",TX_END

Text0402: ; 3fd72 (f:7d72)
	db TX_START,"I'll be sending you useful\n"
	db "information by e-mail.\n"
	db "I'll also attach a Booster Pack\n"
	db "for you, so check your mail\n"
	db "often.\n"
	db "Mason Laboratory\n"
	db "      Doctor Mason  ;)",TX_END

Text0403: ; 3fe10 (f:7e10)
	db TX_START,TX_RAM1,",\n"
	db "It's me, Doctor Mason.\n"
	db "I have some information for you\n"
	db "about Mitch's deck - he's \n"
	db "the Master of the Fighting Club.\n"
	db "His First-Strike Deck is built\n"
	db "for a quick attack, but it's\n"
	db "weak against Psychic Pok`mon!\n"
	db "I suggest you duel him using\n"
	db "the Deck from the Psychic Medal\n"
	db "Deck Machine.\n"
	db "Here's a Booster Pack for you...",TX_END

Text0404: ; 3ff4d (f:7f4d)
	db TX_START,TX_RAM1,", I know you can do it!\n"
	db "Go win the Fighting Medal!\n"
	db "Mason Laboratory\n"
	db "      Doctor Mason ;)",TX_END