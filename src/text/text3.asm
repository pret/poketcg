Text026d: ; 3c000 (f:4000)
	text "You do not own all cards needed\n"
	db   "to build this Deck."
	done

Text026e: ; 3c035 (f:4035)
	text "Built\n"
	db   TX_RAM2
	done

Text026f: ; 3c03e (f:403e)
	text "These cards are needed\n"
	db   "to build this Deck:"
	done

Text0270: ; 3c06a (f:406a)
	text "Dismantle these Decks?"
	done

Text0271: ; 3c082 (f:4082)
	text "Dismantled the Deck."
	done

Text0272: ; 3c098 (f:4098)
	text "OK if this file is deleted?"
	done

Text0273: ; 3c0b5 (f:40b5)
	text "Read the Instructions"
	done

Text0274: ; 3c0cc (f:40cc)
	text "Print this card?\n"
	db   "      Yes     No"
	done

Text0275: ; 3c0ef (f:40ef)
	text "Please choose a Deck configuration\n"
	db   "to print."
	done

Text0276: ; 3c11d (f:411d)
	text "Print this Deck?"
	done

Text0277: ; 3c12f (f:412f)
	text "Print the card list?\n"
	db   "      Yes     No"
	done

Text0278: ; 3c156 (f:4156)
	text "Pok`mon Cards\n"
	db   "Deck Configuration\n"
	db   "Card List\n"
	db   "Print Quality\n"
	db   "Quit Print"
	done

Text0279: ; 3c19b (f:419b)
	text "What would you like to print?"
	done

Text027a: ; 3c1ba (f:41ba)
	text "Please set the contrast:\n"
	db   "  Light   1   2   3   4   5   Dark"
	done

Text027b: ; 3c1f7 (f:41f7)
	text "Please make sure to turn\n"
	db   "the Game Boy Printer OFF."
	done

Text027c: ; 3c22b (f:422b)
	text "Procedures for sending cards:"
	done

Text027d: ; 3c24a (f:424a)
	text "1. Choose the card you wish to send.\n"
	db   "   Press left/right to choose more.\n\n"
	db   "2. Choose all the cards. Then press\n"
	db   "   the B Button to open the menu.\n\n"
	db   "3. Choose Send to finish\n"
	db   "   the process."
	done

Text027e: ; 3c305 (f:4305)
	text "Please read the procedures\n"
	db   "for sending cards."
	done

Text027f: ; 3c334 (f:4334)
	text "Send"
	done

Text0280: ; 3c33a (f:433a)
	text "Card received"
	done

Text0281: ; 3c349 (f:4349)
	text "Card to send"
	done

Text0282: ; 3c357 (f:4357)
	text "Send these cards?"
	done

Text0283: ; 3c36a (f:436a)
	text "Received these cards\n"
	db   "from  ",TX_RAM2,"!"
	done

Text0284: ; 3c389 (f:4389)
	text "Please choose a Deck \n"
	db   "configuration to send."
	done

Text0285: ; 3c3b7 (f:43b7)
	text "Please choose a Save Slot."
	done

Text0286: ; 3c3d3 (f:43d3)
	text "Receive configuration."
	done

Text0287: ; 3c3eb (f:43eb)
	text "Received a deck configuration\n"
	db   "from  ",TX_RAM2,"!"
	done

Text0288: ; 3c413 (f:4413)
	text "  Fighting Machine  "
	done

Text0289: ; 3c429 (f:4429)
	text "  Rock Machine  "
	done

Text028a: ; 3c43b (f:443b)
	text "  Water Machine   "
	done

Text028b: ; 3c44f (f:444f)
	text "  Lightning Machine   "
	done

Text028c: ; 3c467 (f:4467)
	text "  Grass Machine   "
	done

Text028d: ; 3c47b (f:447b)
	text "  Psychic Machine   "
	done

Text028e: ; 3c491 (f:4491)
	text "  Science Machine   "
	done

Text028f: ; 3c4a7 (f:44a7)
	text "  Fire Machine  "
	done

Text0290: ; 3c4b9 (f:44b9)
	text "  Auto Machine  "
	done

Text0291: ; 3c4cb (f:44cb)
	text "  Legendary Machine   "
	done

Text0292: ; 3c4e3 (f:44e3)
	text "All Fighting Pok`mon"
	done

Text0293: ; 3c4f9 (f:44f9)
	text "Bench Attack"
	done

Text0294: ; 3c507 (f:4507)
	text "Battle Contest"
	done

Text0295: ; 3c517 (f:4517)
	text "Heated Battle"
	done

Text0296: ; 3c526 (f:4526)
	text "First-Strike"
	done

Text0297: ; 3c534 (f:4534)
	text "Squeaking Mouse"
	done

Text0298: ; 3c545 (f:4545)
	text "Great Quake"
	done

Text0299: ; 3c552 (f:4552)
	text "Bone Attack"
	done

Text029a: ; 3c55f (f:455f)
	text "Excavation"
	done

Text029b: ; 3c56b (f:456b)
	text "Rock Crusher"
	done

Text029c: ; 3c579 (f:4579)
	text "Blue Water"
	done

Text029d: ; 3c585 (f:4585)
	text "On the Beach"
	done

Text029e: ; 3c593 (f:4593)
	text "Paralyze!"
	done

Text029f: ; 3c59e (f:459e)
	text "Energy Removal"
	done

Text02a0: ; 3c5ae (f:45ae)
	text "Rain Dancer"
	done

Text02a1: ; 3c5bb (f:45bb)
	text "Cute Pok`mon"
	done

Text02a2: ; 3c5c9 (f:45c9)
	text "Pok`mon Flute"
	done

Text02a3: ; 3c5d8 (f:45d8)
	text "Yellow Flash"
	done

Text02a4: ; 3c5e6 (f:45e6)
	text "Electric Shock"
	done

Text02a5: ; 3c5f6 (f:45f6)
	text "Zapping Selfdestruct"
	done

Text02a6: ; 3c60c (f:460c)
	text "Insect Collection"
	done

Text02a7: ; 3c61f (f:461f)
	text "Jungle"
	done

Text02a8: ; 3c627 (f:4627)
	text "Flower Garden"
	done

Text02a9: ; 3c636 (f:4636)
	text "Kaleidoscope"
	done

Text02aa: ; 3c644 (f:4644)
	text "Flower Power"
	done

Text02ab: ; 3c652 (f:4652)
	text "Psychic Power"
	done

Text02ac: ; 3c661 (f:4661)
	text "Dream Eater Haunter"
	done

Text02ad: ; 3c676 (f:4676)
	text "Scavenging Slowbro"
	done

Text02ae: ; 3c68a (f:468a)
	text "Strange Power"
	done

Text02af: ; 3c699 (f:4699)
	text "Strange Psyshock"
	done

Text02b0: ; 3c6ab (f:46ab)
	text "Lovely Nidoran"
	done

Text02b1: ; 3c6bb (f:46bb)
	text "Science Corps"
	done

Text02b2: ; 3c6ca (f:46ca)
	text "Flyin' Pok`mon"
	done

Text02b3: ; 3c6da (f:46da)
	text "Poison"
	done

Text02b4: ; 3c6e2 (f:46e2)
	text "Wonders of Science"
	done

Text02b5: ; 3c6f6 (f:46f6)
	text "Replace 'Em All"
	done

Text02b6: ; 3c707 (f:4707)
	text "Chari-Saur"
	done

Text02b7: ; 3c713 (f:4713)
	text "Traffic Light"
	done

Text02b8: ; 3c722 (f:4722)
	text "Fire Pok`mon"
	done

Text02b9: ; 3c730 (f:4730)
	text "Fire Charge"
	done

Text02ba: ; 3c73d (f:473d)
	text "Charmander & Friends"
	done

Text02bb: ; 3c753 (f:4753)
	text "Squirtle & Friends"
	done

Text02bc: ; 3c767 (f:4767)
	text "Bulbasaur & Friends"
	done

Text02bd: ; 3c77c (f:477c)
	text "Psychic Machamp"
	done

Text02be: ; 3c78d (f:478d)
	text "Water Beetle"
	done

Text02bf: ; 3c79b (f:479b)
	text "Legendary Moltres"
	done

Text02c0: ; 3c7ae (f:47ae)
	text "Legendary Zapdos"
	done

Text02c1: ; 3c7c0 (f:47c0)
	text "Legendary Articuno"
	done

Text02c2: ; 3c7d4 (f:47d4)
	text "Legendary Dragonite"
	done

Text02c3: ; 3c7e9 (f:47e9)
	text "Mysterious Pok`mon"
	done

Text02c4: ; 3c7fd (f:47fd)
	text "A Deck of Fighting Pok`mon:\n"
	db   "Feel their Fighting power!"
	done

Text02c5: ; 3c835 (f:4835)
	text "A Deck of Pok`mon that can\n"
	db   "attack the Bench."
	done

Text02c6: ; 3c863 (f:4863)
	text "A Deck which uses Fighting Attacks\n"
	db   "such as Slash and Punch."
	done

Text02c7: ; 3c8a0 (f:48a0)
	text "A powerful Deck with both Fire\n"
	db   "and Fighting Pok`mon."
	done

Text02c8: ; 3c8d6 (f:48d6)
	text "A Deck for fast and furious \n"
	db   "attacks."
	done

Text02c9: ; 3c8fd (f:48fd)
	text "A Deck made of Mouse Pok`mon.\n"
	db   "Uses PlusPower to Power up!"
	done

Text02ca: ; 3c938 (f:4938)
	text "Use Dugtrio's Earthquake\n"
	db   "to cause great damage."
	done

Text02cb: ; 3c969 (f:4969)
	text "A Deck of Cubone and Marowak - \n"
	db   "A call for help."
	done

Text02cc: ; 3c99b (f:499b)
	text "A Deck which creates Pok`mon by\n"
	db   "evolving Mysterious Fossils."
	done

Text02cd: ; 3c9d9 (f:49d9)
	text "A Deck of Rock Pok`mon. It's\n"
	db   "Strong against Lightning Pok`mon."
	done

Text02ce: ; 3ca19 (f:4a19)
	text "A Deck of Water Pok`mon: Their\n"
	db   "Blue Horror washes over enemies."
	done

Text02cf: ; 3ca5a (f:4a5a)
	text "A well balanced Deck\n"
	db   "of Sandshrew and Water Pok`mon!"
	done

Text02d0: ; 3ca90 (f:4a90)
	text "Paralyze the opponent's Pok`mon:\n"
	db   "Stop 'em and drop 'em!"
	done

Text02d1: ; 3cac9 (f:4ac9)
	text "Uses Whirlpool and Hyper Beam to\n"
	db   "remove opponents' Energy cards."
	done

Text02d2: ; 3cb0b (f:4b0b)
	text "Use Rain Dance to attach Water\n"
	db   "Energy for powerful Attacks!"
	done

Text02d3: ; 3cb48 (f:4b48)
	text "A Deck of cute Pok`mon such as\n"
	db   "Pikachu and Eevee."
	done

Text02d4: ; 3cb7b (f:4b7b)
	text "Use the Pok`mon Flute to revive\n"
	db   "opponents' Pok`mon and Attack!"
	done

Text02d5: ; 3cbbb (f:4bbb)
	text "A deck of Pok`mon that use Lightning\n"
	db   "Energy to zap opponents."
	done

Text02d6: ; 3cbfa (f:4bfa)
	text "A Deck which Shocks and Paralyzes\n"
	db   "opponents with its Attacks."
	done

Text02d7: ; 3cc39 (f:4c39)
	text "Selfdestruct causes great damage \n"
	db   "- even to the opponent's Bench."
	done

Text02d8: ; 3cc7c (f:4c7c)
	text "A Deck made of Insect Pok`mon\n"
	db   "Go Bug Power!"
	done

Text02d9: ; 3cca9 (f:4ca9)
	text "A Deck of Grass Pok`mon: There \n"
	db   "are many dangers in the Jungle."
	done

Text02da: ; 3ccea (f:4cea)
	text "A Deck of Flower Pok`mon:\n"
	db   "Beautiful but Dangerous"
	done

Text02db: ; 3cd1d (f:4d1d)
	text "Uses Venomoth's Pok`mon Power to\n"
	db   "change the opponent's Weakness."
	done

Text02dc: ; 3cd5f (f:4d5f)
	text "A powerful Big Eggsplosion \n"
	db   "and Energy Transfer combo!"
	done

Text02dd: ; 3cd97 (f:4d97)
	text "Use the Psychic power of the\n"
	db   "Psychic Pok`mon to Attack!"
	done

Text02de: ; 3cdd0 (f:4dd0)
	text "Uses Haunter's Dream Eater\n"
	db   "to cause great damage!"
	done

Text02df: ; 3ce03 (f:4e03)
	text "Continually draw Trainer \n"
	db   "Cards from the Discard Pile!"
	done

Text02e0: ; 3ce3b (f:4e3b)
	text "Confuse opponents with\n"
	db   "mysterious power!"
	done

Text02e1: ; 3ce65 (f:4e65)
	text "Use Alakazam's Damage Swap\n"
	db   "to move damage counters!"
	done

Text02e2: ; 3ce9a (f:4e9a)
	text "Uses Nidoqueen's Boyfriends to cause\n"
	db   "great damage to the opponent."
	done

Text02e3: ; 3cede (f:4ede)
	text "The march of the Science Corps!\n"
	db   "Attack with the power of science!"
	done

Text02e4: ; 3cf21 (f:4f21)
	text "Pok`mon with feathers flock \n"
	db   "together! Retreating is easy!"
	done

Text02e5: ; 3cf5d (f:4f5d)
	text "A Deck that uses Poison to \n"
	db   "slowly Knock Out the opponent."
	done

Text02e6: ; 3cf99 (f:4f99)
	text "Block Pok`mon Powers with \n"
	db   "Muk and attack with Mewtwo!"
	done

Text02e7: ; 3cfd1 (f:4fd1)
	text "A Deck that shuffles\n"
	db   "the opponent's cards"
	done

Text02e8: ; 3cffc (f:4ffc)
	text "Attack with Charizard - with \n"
	db   "just a few Fire Energy cards!"
	done

Text02e9: ; 3d039 (f:5039)
	text "Pok`mon that can Attack with\n"
	db   "Fire, Water or Lightning Energy!"
	done

Text02ea: ; 3d078 (f:5078)
	text "With Fire Pok`mon like Charizard, \n"
	db   "Rapidash and Magmar, it's hot!"
	done

Text02eb: ; 3d0bb (f:50bb)
	text "Desperate attacks Damage your \n"
	db   "opponent and you!"
	done

Text02ec: ; 3d0ed (f:50ed)
	text "A Fire, Grass and Water Deck:\n"
	db   "Charmander, Pinsir and Seel"
	done

Text02ed: ; 3d128 (f:5128)
	text "A Water, Fire, and Lightning Deck:\n"
	db   "Squirtle, Charmander and Pikachu"
	done

Text02ee: ; 3d16d (f:516d)
	text "A Grass, Lightning and Psychic Deck:\n"
	db   "Bulbasaur, Pikachu and Abra"
	done

Text02ef: ; 3d1af (f:51af)
	text "Machamp, Hitmonlee, Hitmonchan\n"
	db   "Gengar and Alakazam are furious!"
	done

Text02f0: ; 3d1f0 (f:51f0)
	text "An Evolution Deck with Weedle, \n"
	db   "Nidoran$ and Bellsprout."
	done

Text02f1: ; 3d22a (f:522a)
	text "Gather Fire Energy with the\n"
	db   "Legendary Moltres!"
	done

Text02f2: ; 3d25a (f:525a)
	text "Zap opponents with the\n"
	db   "Legandary Zapdos!"
	done

Text02f3: ; 3d284 (f:5284)
	text "Paralyze opponents with the\n"
	db   "Legendary Articuno!"
	done

Text02f4: ; 3d2b5 (f:52b5)
	text "Heal your Pok`mon with the\n"
	db   "Legendary Dragonite!"
	done

Text02f5: ; 3d2e6 (f:52e6)
	text "A very special Deck made of\n"
	db   "very rare Pok`mon cards!"
	done

Text02f6: ; 3d31c (f:531c)
	text "Pok`mon Card Glossary"
	done

Text02f7: ; 3d333 (f:5333)
	text "Deck                Active Pok`mon\n"
	db   "Discard Pile        Bench Pok`mon\n"
	db   "Hand                Prizes    \n"
	db   "Arena               Damage Counter\n"
	db   "Bench               To next page    "
	done

Text02f8: ; 3d3e0 (f:53e0)
	text "Energy Card         Pok`mon Power \n"
	db   "Trainer Card        Weakness       \n"
	db   "Basic Pok`mon       Resistance\n"
	db   "Evolution Card      Retreat       \n"
	db   "Attack              To previous page"
	done

Text02f9: ; 3d48f (f:548f)
	text "Choose a word and press the\n"
	db   "A button."
	done

Text02fa: ; 3d4b6 (f:54b6)
	text "About the Deck"
	done

Text02fb: ; 3d4c6 (f:54c6)
	text "About the Discard Pile"
	done

Text02fc: ; 3d4de (f:54de)
	text "About the Hand"
	done

Text02fd: ; 3d4ee (f:54ee)
	text "About the Arena"
	done

Text02fe: ; 3d4ff (f:54ff)
	text "About the Bench"
	done

Text02ff: ; 3d510 (f:5510)
	text "About the Active Pok`mon"
	done

Text0300: ; 3d52a (f:552a)
	text "About Bench Pok`mon"
	done

Text0301: ; 3d53f (f:553f)
	text "About Prizes"
	done

Text0302: ; 3d54d (f:554d)
	text "About Damage Counters"
	done

Text0303: ; 3d564 (f:5564)
	text "About Energy Cards"
	done

Text0304: ; 3d578 (f:5578)
	text "About Trainer Cards"
	done

Text0305: ; 3d58d (f:558d)
	text "About Basic Pok`mon"
	done

Text0306: ; 3d5a2 (f:55a2)
	text "About Evolution Cards"
	done

Text0307: ; 3d5b9 (f:55b9)
	text "About Attacking"
	done

Text0308: ; 3d5ca (f:55ca)
	text "About Pok`mon Power"
	done

Text0309: ; 3d5df (f:55df)
	text "About Weakness"
	done

Text030a: ; 3d5ef (f:55ef)
	text "About Resistance"
	done

Text030b: ; 3d601 (f:5601)
	text "About Retreating"
	done

Text030c: ; 3d613 (f:5613)
	text "The Deck is the pile of cards\n"
	db   "you will be drawing from.\n"
	db   "At the beginning of your turn, you\n"
	db   "will draw 1 card from your Deck.\n"
	db   "If there are no cards to draw\n"
	db   "from the Deck, you lose the game."
	done

Text030d: ; 3d6d0 (f:56d0)
	text "The pile in which you place used\n"
	db   "cards is called the Discard Pile.\n"
	db   "You can look at both yours and your\n"
	db   "opponent's Discard Pile \n"
	db   "with the Check command."
	done

Text030e: ; 3d769 (f:5769)
	text "The cards held by each player\n"
	db   "are called a Hand.\n"
	db   "There is no restriction to the\n"
	db   "number of cards in the Hand.\n"
	db   "You may even have 10 or 20 \n"
	db   "cards in your Hand."
	done

Text030f: ; 3d807 (f:5807)
	text "The place where the Pok`mon\n"
	db   "that is actively fighting\n"
	db   "is placed is called the Arena.\n"
	db   "The game proceeds by using the\n"
	db   "Active Pok`mon in the Arena."
	done

Text0310: ; 3d899 (f:5899)
	text "The Bench is where your Pok`mon\n"
	db   "that are in play but aren't actively\n"
	db   "fighting sit.\n"
	db   "They're ready to come out and fight\n"
	db   "if the Active Pok`mon retreats or\n"
	db   "is Knocked Out.\n"
	db   "You can have up to 5 Pok`mon on\n"
	db   "the Bench."
	done

Text0311: ; 3d96e (f:596e)
	text "The Active Pok`mon is the \n"
	db   "Pok`mon that is in the Arena.\n"
	db   "Only Active Pok`mon can \n"
	db   "attack."
	done

Text0312: ; 3d9c9 (f:59c9)
	text "The Pok`mon that are in play\n"
	db   "but aren't actively fighting\n"
	db   "are called Bench Pok`mon.\n"
	db   "They're ready to come out and fight\n"
	db   "if the Active Pok`mon retreats or\n"
	db   "is Knocked Out.\n"
	db   "If the Active Pok`mon is Knocked\n"
	db   "Out and you don't have a Bench \n"
	db   "Pok`mon, you lose the game."
	done

Text0313: ; 3dad1 (f:5ad1)
	text "Prizes are the cards placed to\n"
	db   "count the number of the opponent's\n"
	db   "Pok`mon you Knocked Out.\n"
	db   "Every time one of your opponent's\n"
	db   "Pok`mon is Knocked Out, you take 1\n"
	db   "of your Prizes into your Hand.\n"
	db   "When you take all of your Prizes,\n"
	db   "you win the game."
	done

Text0314: ; 3dbc5 (f:5bc5)
	text "A Damage Counter represents the\n"
	db   "amount of damage a certain Pok`mon\n"
	db   "has taken.\n"
	db   "1 Damage Counter represents\n"
	db   "10 HP of damage.\n"
	db   "If a Pok`mon with an HP of 30 has\n"
	db   "3 Damage Counters, it has received\n"
	db   "30 HP of damage, and its remaining\n"
	db   "HP is 0."
	done

Text0315: ; 3dcb2 (f:5cb2)
	text "Energy Cards are cards that power\n"
	db   "your Pok`mon, making them able\n"
	db   "to Attack.\n"
	db   "There are 7 types of Energy Cards\n"
	db   "[",TX_GRASS," Grass] [",TX_FIRE," Fire]\n"
	db   "[",TX_WATER," Water] [",TX_LIGHTNING," Lightning]\n"
	db   "[",TX_PSYCHIC," Psychic] [",TX_FIGHTING," Fighting]\n"
	db   "and [",TX_COLORLESS," Double Colorless]\n"
	db   "You may only play 1 Energy Card\n"
	db   "from your Hand per turn."
	done

Text0316: ; 3ddbe (f:5dbe)
	text "Trainer Cards are support cards.\n"
	db   "There are many Trainer Cards\n"
	db   "with different effects.\n"
	db   "Trainer Cards are played during\n"
	db   "your turn by following the\n"
	db   "instructions on the card and then\n"
	db   "discarding it.\n"
	db   "You may use as many Trainer Cards\n"
	db   "as you like."
	done

Text0317: ; 3deb0 (f:5eb0)
	text "Basic Pok`mon are cards that \n"
	db   "can be played directly from your \n"
	db   "hand into the play area. Basic \n"
	db   "Pok`mon act as the base for \n"
	db   "Evolution Cards. Charmander, \n"
	db   "Squirtle and Bulbasaur are\n"
	db   "examples of Basic Pok`mon."
	done

Text0318: ; 3df82 (f:5f82)
	text "Evolution Cards are cards you\n"
	db   "play on top of a Basic Pok`mon card\n"
	db   "(or sometimes on top of another\n"
	db   "Evolution Card) to make it stronger.\n"
	db   "There are Stage 1 and Stage 2\n"
	db   "Evolution Cards.\n"
	db   "If you do not have a Basic Pok`mon\n"
	db   "in the Play Area, you cannot place\n"
	db   "the Stage 1 Evolution Card, and if\n"
	db   "you do not have a Stage 1 Evolution\n"
	db   "Card in the Play Area, you cannot\n"
	db   "place the Stage 2 Evolution Card."
	done

Text0319: ; 3e10a (f:610a)
	text "By choosing Attack, your Pok`mon\n"
	db   "will fight your opponent's Pok`mon.\n"
	db   "Your Pok`mon require Energy\n"
	db   "in order to Attack.\n"
	db   "The amount of Energy required\n"
	db   "differs according to the Attack.\n"
	db   "The Active Pok`mon is the only\n"
	db   "Pok`mon that can Attack."
	done

Text031a: ; 3e1f7 (f:61f7)
	text "Unlike Attacks, Pok`mon Power\n"
	db   "can be used by Active or Benched\n"
	db   "Pok`mon. Some Pok`mon Power are\n"
	db   "effective by just placing the\n"
	db   "Pok`mon in the Play Area, but for\n"
	db   "some you must choose the\n"
	db   "command, PKMN Power."
	done

Text031b: ; 3e2c5 (f:62c5)
	text "Some Pok`mon have a Weakness.\n"
	db   "If a Pok`mon has a Weakness, it\n"
	db   "takes double damage when attacked by\n"
	db   "Pok`mon of a certain type."
	done

Text031c: ; 3e344 (f:6344)
	text "Some Pok`mon have Resistance.\n"
	db   "If a Pok`mon has Resistance, it\n"
	db   "takes 30 less damage whenever\n"
	db   "attacked by Pok`mon of\n"
	db   "a certain type."
	done

Text031d: ; 3e3c8 (f:63c8)
	text "By choosing Retreat, you can\n"
	db   "switch the Active Pok`mon with\n"
	db   "a Pok`mon on your Bench.\n"
	db   "Energy is required to Retreat\n"
	db   "your Active Pok`mon.\n"
	db   "The amount of Energy required to\n"
	db   "Retreat differs for each Pok`mon.\n"
	db   "To Retreat, you must discard\n"
	db   "Energy equal to the Retreat Cost\n"
	db   "of the retreating Pok`mon."
	done

Text031e: ; 3e4ed (f:64ed)
	text "Modify Deck\n"
	db   "Card List\n"
	db   "Album List\n"
	db   "Deck Save Machine\n"
	db   "Printing Menu\n"
	db   "Auto Deck Machine\n"
	db   "Gift Center\n"
	db   "Name Input"
	done

Text031f: ; 3e558 (f:6558)
	text "Fighting Machine\n"
	db   "Rock Machine\n"
	db   "Water Machine\n"
	db   "Lightning Machine\n"
	db   "Grass Machine\n"
	db   "Psychic Machine\n"
	db   "Science Machine\n"
	db   "Fire Machine\n"
	db   "Auto Machine\n"
	db   "Legendary Machine"
	done

Text0320: ; 3e5f1 (f:65f1)
	text "Send a Card\n"
	db   "Receive a Card\n"
	db   "Give Deck Instructions\n"
	db   "Receive Deck Instructions"
	done

Text0321: ; 3e63e (f:663e)
	text "Lecture Duel"
	done

Text0322: ; 3e64c (f:664c)
	text "First Strike Deck\n"
	db   TX_END

Text0323: ; 3e660 (f:6660)
	text "  Mason Laboratory  "
	done

Text0324: ; 3e676 (f:6676)
	text "  ISHIHARA's House  "
	done

Text0325: ; 3e68c (f:668c)
	text "   Fighting Club    "
	done

Text0326: ; 3e6a2 (f:66a2)
	text "     Rock Club      "
	done

Text0327: ; 3e6b8 (f:66b8)
	text "     Water Club     "
	done

Text0328: ; 3e6ce (f:66ce)
	text "   Lightning Club   "
	done

Text0329: ; 3e6e4 (f:66e4)
	text "     Grass Club     "
	done

Text032a: ; 3e6fa (f:66fa)
	text "    Psychic Club    "
	done

Text032b: ; 3e710 (f:6710)
	text "    Science Club    "
	done

Text032c: ; 3e726 (f:6726)
	text "     Fire Club      "
	done

Text032d: ; 3e73c (f:673c)
	text "   Challenge Hall   "
	done

Text032e: ; 3e752 (f:6752)
	text "    Pok`mon Dome    "
	done

Text032f: ; 3e768 (f:6768)
	text "     ??'s House     "
	done

Text0330: ; 3e77e (f:677e)
	text "Mason Laboratory"
	done

Text0331: ; 3e790 (f:6790)
	text "Mr Ishihara's House"
	done

Text0332: ; 3e7a5 (f:67a5)
	text "Fighting"
	done

Text0333: ; 3e7af (f:67af)
	text "Rock"
	done

Text0334: ; 3e7b5 (f:67b5)
	text "Water"
	done

Text0335: ; 3e7bc (f:67bc)
	text "Lightning"
	done

Text0336: ; 3e7c7 (f:67c7)
	text "Grass"
	done

Text0337: ; 3e7ce (f:67ce)
	text "Psychic"
	done

Text0338: ; 3e7d7 (f:67d7)
	text "Science"
	done

Text0339: ; 3e7e0 (f:67e0)
	text "Fire"
	done

Text033a: ; 3e7e6 (f:67e6)
	text "Challenge Hall"
	done

Text033b: ; 3e7f6 (f:67f6)
	text "Pok`mon Dome"
	done

Text033c: ; 3e804 (f:6804)
	text "??'s House"
	done

Text033d: ; 3e810 (f:6810)
	text "Status\n"
	db   "Diary\n"
	db   "Deck\n"
	db   "Card\n"
	db   "Config\n"
	db   "Exit"
	done

Text033e: ; 3e834 (f:6834)
	text "Status\n"
	db   "Diary\n"
	db   "Deck\n"
	db   "Card\n"
	db   "Config\n"
	db   "Debug\n"
	db   "Close"
	done

Text033f: ; 3e85f (f:685f)
	text "Name ",TX_RAM1
	done

Text0340: ; 3e867 (f:6867)
	text "Album           ",$07,$6d
	done

Text0341: ; 3e87b (f:687b)
	text "Play time         ",$07,$03,$5e
	done

Text0342: ; 3e892 (f:6892)
	text ""
	db   TX_RAM1,"'s diary"
	done

Text0343: ; 3e89d (f:689d)
	text "Master Medals Won "
	done

Text0344: ; 3e8b1 (f:68b1)
	text "Would you like to keep a diary?"
	done

Text0345: ; 3e8d2 (f:68d2)
	text ""
	db   TX_RAM1,"\n"
	db   "wrote in the diary."
	done

Text0346: ; 3e8e9 (f:68e9)
	text "Nothing was recorded \n"
	db   "in the diary."
	done

Text0347: ; 3e90e (f:690e)
	text "Master Medals"
	done

Text0348: ; 3e91d (f:691d)
	text "           Change Settings"
	done

Text0349: ; 3e939 (f:6939)
	text "Message Speed\n\n"
	db   "   Slow   1   2   3   4   5   Fast"
	done

Text034a: ; 3e96c (f:696c)
	text "Duel Animation\n\n"
	db   "  Show All    Skip Some       None"
	done

Text034b: ; 3e9a0 (f:69a0)
	text "   Exit Settings"
	done

Text034c: ; 3e9b2 (f:69b2)
	text "Duel           [",TX_RAM2,"]\n"
	db   "SELECT         [",TX_RAM2,"]\n"
	db   "Receive many cards\n"
	db   "To Pok`mon Dome 1\n"
	db   "To Pok`mon Dome 2"
	done

Text034d: ; 3ea10 (f:6a10)
	text "Normal Duel"
	done

Text034e: ; 3ea1d (f:6a1d)
	text "Skip"
	done

Text034f: ; 3ea23 (f:6a23)
	text "Normal"
	done

Text0350: ; 3ea2b (f:6a2b)
	text "Freeze Screen"
	done

Text0351: ; 3ea3a (f:6a3a)
	text "Card Album\n"
	db   "Read Mail\n"
	db   "Glossary\n"
	db   "Print\n"
	db   "Shut Down"
	done

TurnedPCOnText: ; 3ea69 (f:6a69)
	text ""
	db   TX_RAM1,"\n"
	db   "turned the PC on!"
	done

TurnedPCOffText: ; 3ea7e (f:6a7e)
	text ""
	db   TX_RAM1,"\n"
	db   "turned the PC off!"
	done

Text0354: ; 3ea94 (f:6a94)
	text "Send Card\n"
	db   "Receive Card\n"
	db   "Send Deck Configuration\n"
	db   "Receive Deck Configuration\n"
	db   "Exit"
	done

Text0355: ; 3eae4 (f:6ae4)
	text "Send Card"
	done

Text0356: ; 3eaef (f:6aef)
	text "Receive Card"
	done

Text0357: ; 3eafd (f:6afd)
	text "Send Deck Configuration"
	done

Text0358: ; 3eb16 (f:6b16)
	text "Receive Deck Configuration"
	done

Text0359: ; 3eb32 (f:6b32)
	text "   Mail ",TX_RAM1," "
	done

Text035a: ; 3eb3e (f:6b3e)
	text "Which mail would you like to read?"
	done

Text035b: ; 3eb62 (f:6b62)
	text "Mail 0 1 2 3 4 5 6 7 8 9101112131415"
	done

Text035c: ; 3eb88 (f:6b88)
	db   "ppppp"
	done

Text035d: ; 3eb8e (f:6b8e)
	text "Mail 1"
	done

Text035e: ; 3eb96 (f:6b96)
	text "Mail 2"
	done

Text035f: ; 3eb9e (f:6b9e)
	text "Mail 3"
	done

Text0360: ; 3eba6 (f:6ba6)
	text "Mail 4"
	done

Text0361: ; 3ebae (f:6bae)
	text "Mail 5"
	done

Text0362: ; 3ebb6 (f:6bb6)
	text "Mail 6"
	done

Text0363: ; 3ebbe (f:6bbe)
	text "Mail 7"
	done

Text0364: ; 3ebc6 (f:6bc6)
	text "Mail 8"
	done

Text0365: ; 3ebce (f:6bce)
	text "Mail 9"
	done

Text0366: ; 3ebd6 (f:6bd6)
	text "Mail 10"
	done

Text0367: ; 3ebdf (f:6bdf)
	text "Mail 11"
	done

Text0368: ; 3ebe8 (f:6be8)
	text "Mail 12"
	done

Text0369: ; 3ebf1 (f:6bf1)
	text "Mail 13"
	done

Text036a: ; 3ebfa (f:6bfa)
	text "Mail 14"
	done

Text036b: ; 3ec03 (f:6c03)
	text "Mail 15"
	done

Text036c: ; 3ec0c (f:6c0c)
	text "NEW GAME"
	done

Text036d: ; 3ec16 (f:6c16)
	text "CARD POP!\n"
	db   "CONTINUE FROM DIARY\n"
	db   "NEW GAME"
	done

Text036e: ; 3ec3e (f:6c3e)
	text "CARD POP!\n"
	db   "CONTINUE FROM DIARY\n"
	db   "New Game\n"
	db   "CONTINUE DUEL"
	done

Text036f: ; 3ec74 (f:6c74)
	text "When you CARD POP! with a friend,\n"
	db   "you will each receive a new card!"
	done

Text0370: ; 3ecb9 (f:6cb9)
	text "  ",TX_RAM1,"  ",TX_RAM2,"\n"
	db   "      Master Medals Won ",$07,$0c,$06,"\n"
	db   "      Album           ",$07,$6d,$06,"\n"
	db   "      Play time         ",$07,$03,$5e,$06
	done

Text0371: ; 3ed14 (f:6d14)
	text "Start a New Game.\n"
	db   TX_END

Text0372: ; 3ed28 (f:6d28)
	text "The Game will continue from \n"
	db   "the point in the duel at\n"
	db   "which the power was turned OFF."
	done

Text0373: ; 3ed7f (f:6d7f)
	text "Saved data already exists.\n"
	db   "If you continue, you will lose\n"
	db   "all the cards you have collected."
	done

Text0374: ; 3eddc (f:6ddc)
	text "OK to delete the data?"
	done

Text0375: ; 3edf4 (f:6df4)
	text "All data was deleted."
	done

Text0376: ; 3ee0b (f:6e0b)
	text "Data exists from when the power \n"
	db   "was turned OFF during a duel.\n"
	db   "Choose CONTINUE DUEL on the\n"
	db   "Main Menu to continue the duel.\n"
	db   "If you continue now, the heading,\n"
	db   "CONTINUE DUEL, will be\n"
	db   "deleted, and the game will start\n"
	db   "from the point when you last \n"
	db   "wrote in the Diary.\n\n"
	db   "Would you like to continue the Game\n"
	db   "from the point saved in"
	done

Text0377: ; 3ef50 (f:6f50)
	text "CONTINUE FROM DIARY?"
	done

Text0378: ; 3ef66 (f:6f66)
	text "You can access Card Pop! only\n"
	db   "with two Game Boy Colors.\n"
	db   "Please play using a Game Boy Color."
	done

Text0379: ; 3efc3 (f:6fc3)
	text ""
	db   TX_RAM1," is crazy about Pok`mon\n"
	db   "and Pok`mon card collecting!\n"
	db   "One day,\n"
	db   TX_RAM1," heard a rumor:\n"
	db   " \"The Legendary Pok`mon Cards...\n"
	db   "  the extremely rare and powerful \n"
	db   "  cards held by Pok`mon Trading \n"
	db   "  Card Game's greatest players... \n"
	db   "  The Grand Masters are searching\n"
	db   "  for one to inherit the legend!\"\n"
	db   "Dreaming of inheriting the\n"
	db   "Legendary Pok`mon Cards,\n"
	db   TX_RAM1," visits the Pok`mon\n"
	db   "card researcher, Dr. Mason..."
	done

Text037a: ; 3f147 (f:7147)
	text "POWER ON\n"
	db   "DUEL MODE\n"
	db   "CONTINUE FROM DIARY\n"
	db   "CGB TEST\n"
	db   "SGB FRAME\n"
	db   "STANDARD BG CHARACTER\n"
	db   "LOOK AT SPR\n"
	db   "V EFFECT\n"
	db   "CREATE BOOSTER PACK\n"
	db   "CREDITS\n"
	db   "QUIT"
	done

Text037b: ; 3f1ce (f:71ce)
	text "NORMAL DUEL\n"
	db   "SKIP"
	done

Text037c: ; 3f1e0 (f:71e0)
	text "COLOSSEUM\n"
	db   "EVOLUTION\n"
	db   "MYSTERY\n"
	db   "LABORATORY\n"
	db   "Energy"
	done

Text037d: ; 3f20f (f:720f)
	text "1\n"
	db   "2\n"
	db   "3\n"
	db   "4\n"
	db   "5\n"
	db   "6\n"
	db   "7"
	done

Text037e: ; 3f21e (f:721e)
	text "1\n"
	db   "2\n"
	db   "3\n"
	db   "4\n"
	db   "5\n"
	db   "6"
	done

Text037f: ; 3f22b (f:722b)
	text "1\n"
	db   "2\n"
	db   "3\n"
	db   "4\n"
	db   "5"
	done

Text0380: ; 3f236 (f:7236)
	text "1\n"
	db   "2\n"
	db   "3\n"
	db   "4"
	done

Text0381: ; 3f23f (f:723f)
	text "A                   TIME\n"
	db   "     TO      (Change with Start)\n"
	db   "            A+B: Stop Animation\n"
	db   "            Select: Exit"
	done

Text0382: ; 3f2b3 (f:72b3)
	text "Left"
	done

Text0383: ; 3f2b9 (f:72b9)
	text "Right"
	done

Text0384: ; 3f2c0 (f:72c0)
	text "SPR_"
	done

Text0385: ; 3f2c6 (f:72c6)
	text "WIN      ",TX_RAM3," Prizes Duel\n"
	db   "LOSE     with ",TX_RAM2,"(",TX_RAM3,")"
	done

Text0386: ; 3f2f1 (f:72f1)
	text "         Use ",TX_RAM3,"'s Deck"
	done

ReceivedBoosterPackText: ; 3f308 (f:7308)
	text ""
	db   TX_RAM1," received a Booster\n"
	db   "Pack: ",TX_RAM2,"."
	done

AndAnotherBoosterPackText: ; 3f327 (f:7327)
	text "...And another Booster Pack:\n"
	db   TX_RAM2,"."
	done

CheckedCardsInBoosterPackText: ; 3f348 (f:7348)
	text ""
	db   TX_RAM1," checked the cards\n"
	db   "in the Booster Pack!!"
	done

Text038a: ; 3f373 (f:7373)
	text "Substitute screen for\n"
	db   "receiving cards."
	done

WonTheMedalText: ; 3f39b (f:739b)
	text ""
	db   TX_RAM1,"\n"
	db   "Won the ",TX_RAM2," Medal!"
	done

Text038c: ; 3f3af (f:73af)
	text "Substitute screen for sending\n"
	db   "cards by Link cable."
	done

Text038d: ; 3f3e3 (f:73e3)
	text "Substitute screen for receiving\n"
	db   "cards by Link cable."
	done

Text038e: ; 3f419 (f:7419)
	text "Substitute screen for sending\n"
	db   "a Deck design."
	done

Text038f: ; 3f447 (f:7447)
	text "Substitute screen for receiving\n"
	db   "a Deck design."
	done

Text0390: ; 3f477 (f:7477)
	text "????"
	done

Text0391: ; 3f47d (f:747d)
	text "Ending Screen\n"
	db   "THE END"
	done

Text0392: ; 3f494 (f:7494)
	text "Was the data transfer successful?"
	done

Text0393: ; 3f4b7 (f:74b7)
	text "(Person transferring data to)"
	done

Text0394: ; 3f4d6 (f:74d6)
	text "(Name of Deck transferring)"
	done

Text0395: ; 3f4f3 (f:74f3)
	text ""
	db   TX_RAM2,"  ",TX_RAM2
	done

Text0396: ; 3f4f9 (f:74f9)
	text ""
	db   TX_RAM2," Deck"
	done

Text0397: ; 3f501 (f:7501)
	text "Fighting Club Member"
	done

Text0398: ; 3f517 (f:7517)
	text "Rock Club Member"
	done

Text0399: ; 3f529 (f:7529)
	text "Water Club Member"
	done

Text039a: ; 3f53c (f:753c)
	text "Lightning Club Member"
	done

Text039b: ; 3f553 (f:7553)
	text "Grass Club Member"
	done

Text039c: ; 3f566 (f:7566)
	text "Psychic Club Member"
	done

Text039d: ; 3f57b (f:757b)
	text "Science Club Member"
	done

Text039e: ; 3f590 (f:7590)
	text "Fire Club Member"
	done

Text039f: ; 3f5a2 (f:75a2)
	text "Fighting Club Master"
	done

Text03a0: ; 3f5b8 (f:75b8)
	text "Rock Club Master"
	done

Text03a1: ; 3f5ca (f:75ca)
	text "Water Club Master"
	done

Text03a2: ; 3f5dd (f:75dd)
	text "Lightning Club Master"
	done

Text03a3: ; 3f5f4 (f:75f4)
	text "Grass Club Master"
	done

Text03a4: ; 3f607 (f:7607)
	text "Psychic Club Master"
	done

Text03a5: ; 3f61c (f:761c)
	text "Science Club Master"
	done

Text03a6: ; 3f631 (f:7631)
	text "Fire Club Master"
	done

Text03a7: ; 3f643 (f:7643)
	db   TX_END

Text03a8: ; 3f644 (f:7644)
	text "COLOSSEUM"
	done

Text03a9: ; 3f64f (f:764f)
	text "EVOLUTION"
	done

Text03aa: ; 3f65a (f:765a)
	text "MYSTERY"
	done

Text03ab: ; 3f663 (f:7663)
	text "LABORATORY"
	done

Text03ac: ; 3f66f (f:766f)
	text "Dr. Mason"
	done

Text03ad: ; 3f67a (f:767a)
	text "Ronald"
	done

Text03ae: ; 3f682 (f:7682)
	text "ISHIHARA"
	done

Text03af: ; 3f68c (f:768c)
	text "Imakuni?"
	done

Text03b0: ; 3f696 (f:7696)
	text "CLERK"
	done

Text03b1: ; 3f69d (f:769d)
	text "Sam"
	done

Text03b2: ; 3f6a2 (f:76a2)
	text "TECH"
	done

Text03b3: ; 3f6a8 (f:76a8)
	text "CLERK"
	done

Text03b4: ; 3f6af (f:76af)
	text "Chris"
	done

Text03b5: ; 3f6b6 (f:76b6)
	text "Michael"
	done

Text03b6: ; 3f6bf (f:76bf)
	text "Jessica"
	done

Text03b7: ; 3f6c8 (f:76c8)
	text "Mitch"
	done

Text03b8: ; 3f6cf (f:76cf)
	text "Matthew"
	done

Text03b9: ; 3f6d8 (f:76d8)
	text "Ryan"
	done

Text03ba: ; 3f6de (f:76de)
	text "Andrew"
	done

Text03bb: ; 3f6e6 (f:76e6)
	text "Gene"
	done

Text03bc: ; 3f6ec (f:76ec)
	text "Sara"
	done

Text03bd: ; 3f6f2 (f:76f2)
	text "Amanda"
	done

Text03be: ; 3f6fa (f:76fa)
	text "Joshua"
	done

Text03bf: ; 3f702 (f:7702)
	text "Amy"
	done

Text03c0: ; 3f707 (f:7707)
	text "Jennifer"
	done

Text03c1: ; 3f711 (f:7711)
	text "Nicholas"
	done

Text03c2: ; 3f71b (f:771b)
	text "Brandon"
	done

Text03c3: ; 3f724 (f:7724)
	text "Isaac"
	done

Text03c4: ; 3f72b (f:772b)
	text "Brittany"
	done

Text03c5: ; 3f735 (f:7735)
	text "Kristin"
	done

Text03c6: ; 3f73e (f:773e)
	text "Heather"
	done

Text03c7: ; 3f747 (f:7747)
	text "Nikki"
	done

Text03c8: ; 3f74e (f:774e)
	text "Robert"
	done

Text03c9: ; 3f756 (f:7756)
	text "Daniel"
	done

Text03ca: ; 3f75e (f:775e)
	text "Stephanie"
	done

Text03cb: ; 3f769 (f:7769)
	text "Murray"
	done

Text03cc: ; 3f771 (f:7771)
	text "Joseph"
	done

Text03cd: ; 3f779 (f:7779)
	text "David"
	done

Text03ce: ; 3f780 (f:7780)
	text "Erik"
	done

Text03cf: ; 3f786 (f:7786)
	text "Rick"
	done

Text03d0: ; 3f78c (f:778c)
	text "John"
	done

Text03d1: ; 3f792 (f:7792)
	text "Adam"
	done

Text03d2: ; 3f798 (f:7798)
	text "Jonathan"
	done

Text03d3: ; 3f7a2 (f:77a2)
	text "Ken"
	done

Text03d4: ; 3f7a7 (f:77a7)
	text "COURTNEY"
	done

Text03d5: ; 3f7b1 (f:77b1)
	text "Steve"
	done

Text03d6: ; 3f7b8 (f:77b8)
	text "Jack"
	done

Text03d7: ; 3f7be (f:77be)
	text "Rod"
	done

Text03d8: ; 3f7c3 (f:77c3)
	text "Man"
	done

Text03d9: ; 3f7c8 (f:77c8)
	text "Woman"
	done

Text03da: ; 3f7cf (f:77cf)
	text "CHAP"
	done

Text03db: ; 3f7d5 (f:77d5)
	text "GAL"
	done

Text03dc: ; 3f7da (f:77da)
	text "Lass"
	done

Text03dd: ; 3f7e0 (f:77e0)
	text "Pappy"
	done

Text03de: ; 3f7e7 (f:77e7)
	text "Lad"
	done

Text03df: ; 3f7ec (f:77ec)
	text "HOST"
	done

Text03e0: ; 3f7f2 (f:77f2)
	text "Specs"
	done

Text03e1: ; 3f7f9 (f:77f9)
	text "Butch"
	done

Text03e2: ; 3f800 (f:7800)
	text "Hood"
	done

Text03e3: ; 3f806 (f:7806)
	text "Champ"
	done

Text03e4: ; 3f80d (f:780d)
	text "Mania"
	done

Text03e5: ; 3f814 (f:7814)
	text "Granny"
	done

Text03e6: ; 3f81c (f:781c)
	text "Guide"
	done

Text03e7: ; 3f823 (f:7823)
	text "Aaron"
	done

Text03e8: ; 3f82a (f:782a)
	text ""
	db   TX_LVL,"60 MEWTWO "
	done

Text03e9: ; 3f838 (f:7838)
	text ""
	db   TX_LVL,"8 MEW "
	done

Text03ea: ; 3f842 (f:7842)
	text ""
	db   TX_LVL,"34 ARCANINE"
	done

Text03eb: ; 3f851 (f:7851)
	text ""
	db   TX_LVL,"16 PIKACHU"
	done

Text03ec: ; 3f85f (f:785f)
	text ""
	db   TX_LVL,"13 SURFING PIKACHU"
	done

Text03ed: ; 3f875 (f:7875)
	text ""
	db   TX_LVL,"20 ELECTABUZZ"
	done

Text03ee: ; 3f886 (f:7886)
	text ""
	db   TX_LVL,"9 SLOWPOKE"
	done

Text03ef: ; 3f894 (f:7894)
	text ""
	db   TX_LVL,"12 JIGGLYPUFF"
	done

Text03f0: ; 3f8a5 (f:78a5)
	text ""
	db   TX_LVL,"68 ZAPDOS"
	done

Text03f1: ; 3f8b2 (f:78b2)
	text ""
	db   TX_LVL,"37 MOLTRES"
	done

Text03f2: ; 3f8c0 (f:78c0)
	text ""
	db   TX_LVL,"37 ARTICUNO"
	done

Text03f3: ; 3f8cf (f:78cf)
	text ""
	db   TX_LVL,"41 DRAGONITE"
	done

Text03f4: ; 3f8df (f:78df)
	text "Super Energy Retrieval"
	done

Text03f5: ; 3f8f7 (f:78f7)
	text ""
	db   TX_LVL,"12 FLYING PIKACHU"
	done

Text03f6: ; 3f90c (f:790c)
	text "Lightning & Fire Deck"
	done

Text03f7: ; 3f923 (f:7923)
	text "Water & Fighting Deck"
	done

Text03f8: ; 3f93a (f:793a)
	text "Grass & Psychic Deck"
	done

Text03f9: ; 3f950 (f:7950)
	text "Please select the Deck\n"
	db   "you wish to Duel against."
	done

Text03fa: ; 3f982 (f:7982)
	text "CHARMANDER & Friends Deck"
	done

Text03fb: ; 3f99d (f:799d)
	text "SQUIRTLE & Friends Deck"
	done

Text03fc: ; 3f9b6 (f:79b6)
	text "BULBASAUR & Friends Deck"
	done

Text03fd: ; 3f9d0 (f:79d0)
	text "Please select the Deck you want."
	done

Text03fe: ; 3f9f2 (f:79f2)
	text "Hi, ",TX_RAM1,".\n"
	db   "How can I help you?"
	done

Text03ff: ; 3fa0e (f:7a0e)
	text "Normal Duel\n"
	db   "Practice\n"
	db   "Rules\n"
	db   "Nothing"
	done

Text0400: ; 3fa32 (f:7a32)
	text "Energy\n"
	db   "Attacking\n"
	db   "Retreating\n"
	db   "Evolving Pok`mon\n"
	db   "Using Pok`mon Power\n"
	db   "Ending Your Turn\n"
	db   "Win or Loss of a Duel\n"
	db   "Nothing to Ask"
	done

Text0401: ; 3faaa (f:7aaa)
	text ""
	db   TX_RAM1,",\n"
	db   "It's me, Doctor Mason.\n"
	db   "Are you getting the hang of\n"
	db   "the Pok`mon Trading Card Game?\n"
	db   "I have some information for you\n"
	db   "about Booster Packs. \n"
	db   "If you want to collect the same\n"
	db   "cards, duel the same person many\n"
	db   "times to get a particular Booster\n"
	db   "Pack! By doing so, you will be able \n"
	db   "to collect the same cards, making it\n"
	db   "easier for you to build your Deck.\n"
	db   "Another method for collecting \n"
	db   "cards is to use CARD POP!\n"
	db   "When you and a friend use CARD POP!,\n"
	db   "you will each receive a new card!\n"
	db   "Once you POP! with a certain\n"
	db   "friend, you won't be able to POP!\n"
	db   "with that friend again, so find \n"
	db   "many friends who own the Pok`mon \n"
	db   "Trading Card Game for Game Boy,\n"
	db   "and CARD POP! with them to\n"
	db   "get new cards!\n"
	db   "Oh, here's something for you..."
	done

Text0402: ; 3fd72 (f:7d72)
	text "I'll be sending you useful\n"
	db   "information by e-mail.\n"
	db   "I'll also attach a Booster Pack\n"
	db   "for you, so check your mail\n"
	db   "often.\n"
	db   "Mason Laboratory\n"
	db   "      Doctor Mason  ;)"
	done

Text0403: ; 3fe10 (f:7e10)
	text ""
	db   TX_RAM1,",\n"
	db   "It's me, Doctor Mason.\n"
	db   "I have some information for you\n"
	db   "about Mitch's deck - he's \n"
	db   "the Master of the Fighting Club.\n"
	db   "His First-Strike Deck is built\n"
	db   "for a quick attack, but it's\n"
	db   "weak against Psychic Pok`mon!\n"
	db   "I suggest you duel him using\n"
	db   "the Deck from the Psychic Medal\n"
	db   "Deck Machine.\n"
	db   "Here's a Booster Pack for you..."
	done

Text0404: ; 3ff4d (f:7f4d)
	text ""
	db   TX_RAM1,", I know you can do it!\n"
	db   "Go win the Fighting Medal!\n"
	db   "Mason Laboratory\n"
	db   "      Doctor Mason ;)"
	done
