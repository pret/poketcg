AcidCheckText: ; 38000 (e:4000)
	text "Acid check! If Heads,"
	line "unable to Retreat during next turn."
	done

TransparencyCheckText: ; 3803b (e:403b)
	text "Transparency check! If Heads,"
	line "do not receive opponent's Attack!"
	done

ConfusionCheckDamageText: ; 3807c (e:407c)
	text "Confusion check,"
	line "If Tails, damage to yourself!"
	done

Text00f8: ; 380ac (e:40ac)
	text "Confusion check!"
	line "If Tails, unable to Retreat."
	done

Text00f9: ; 380db (e:40db)
	text TX_RAM2, "'s Sleep check."
	done

Text00fa: ; 380ed (e:40ed)
	text "Opponent is Poisoned if Heads,"
	line "and Confused if Tails."
	done

Text00fb: ; 38124 (e:4124)
	text "If Heads, do not receive damage"
	line "or effect of opponent's next Attack!"
	done

Text00fc: ; 3816a (e:416a)
	text "If Heads, opponent cannot Attack"
	line "next turn!"
	done

AttackUnsuccessfulText: ; 38197 (e:4197)
	text "Attack unsuccessful."
	done

UnableToRetreatDueToAcidText: ; 381ad (e:41ad)
	text "Unable to Retreat due to"
	line "the effects of Acid."
	done

UnableToUseTrainerDueToHeadacheText: ; 381dc (e:41dc)
	text "Unable to use a Trainer card"
	line "due to the effects of Headache."
	done

UnableToAttackDueToTailWagText: ; 3821a (e:421a)
	text "Unable to Attack due to"
	line "the effects of Tail wag."
	done

UnableToAttackDueToLeerText: ; 3824c (e:424c)
	text "Unable to Attack due to"
	line "the effects of Leer."
	done

UnableToAttackDueToBoneAttackText: ; 3827a (e:427a)
	text "Unable to Attack due to"
	line "the effects of Bone attack."
	done

UnableToUseAttackDueToAmnesiaText: ; 382af (e:42af)
	text "Unable to use this Attack"
	line "due to the effects of Amnesia."
	done

KnockedOutDueToDestinyBondText: ; 382e9 (e:42e9)
	text TX_RAM2, " was Knocked Out"
	line "due to the effects of Destiny Bond."
	done

ReceivesDamageDueToStrikesBackText: ; 38320 (e:4320)
	text TX_RAM2, " receives ", TX_RAM3, " damage"
	line "due to the effects of Strikes Back."
	done

UnableToEvolveDueToPrehistoricPowerText: ; 38359 (e:4359)
	text "Unable to evolve due to the"
	line "effects of Prehistoric Power."
	done

NoDamageOrEffectDueToFlyText: ; 38394 (e:4394)
	text "No damage or effect on next Attack"
	line "due to the effects of Fly."
	done

NoDamageOrEffectDueToBarrierText: ; 383d3 (e:43d3)
	text "No damage or effect on next Attack"
	line "due to the effects of Barrier."
	done

NoDamageOrEffectDueToAgilityText: ; 38416 (e:4416)
	text "No damage or effect on next Attack"
	line "due to the effects of Agility."
	done

UnableToUseAttackDueToNShieldText: ; 38459 (e:4459)
	text "Unable to use this Attack due to"
	line "the effects of N Shield."
	done

NoDamageOrEffectDueToNShieldText: ; 38494 (e:4494)
	text "No damage or effect on next Attack"
	line "due to the effects of N Shield."
	done

NoDamageOrEffectDueToTransparencyText: ; 384d8 (e:44d8)
	text "No damage or effect on next Attack"
	line "due to the effects of Transparency"
	done

Text010d: ; 3851f (e:451f)
	text TX_RAM2, ""
	line "metamorphs to ", TX_RAM2, "."
	done

SelectPkmnOnBenchToSwitchWithActiveText: ; 38533 (e:4533)
	text "Select a Pokémon on the Bench"
	line "to switch with the Active Pokémon."
	done

Text010f: ; 38575 (e:4575)
	text "Select a Pokémon to place"
	line "in the Arena."
	done

Text0110: ; 3859e (e:459e)
	text TX_RAM1, " is selecting a Pokémon"
	line "to place in the Arena."
	done

Text0111: ; 385cf (e:45cf)
	text "Choose the Weakness you wish"
	line "to change with Conversion 1."
	done

Text0112: ; 3860a (e:460a)
	text "Choose the Resistance you wish"
	line "to change with Conversion 2."
	done

Text0113: ; 38647 (e:4647)
	text "Choose the Pokémon whose color you"
	line "wish to change with Color change."
	done

Text0114: ; 3868d (e:468d)
	text "Changed the Weakness of"
	line ""
	text TX_RAM2, " to ", TX_RAM2, "."
	done

Text0115: ; 386af (e:46af)
	text "Changed the Resistance of"
	line ""
	text TX_RAM2, " to ", TX_RAM2, "."
	done

Text0116: ; 386d3 (e:46d3)
	text "Changed the color of"
	line ""
	text TX_RAM2, " to ", TX_RAM2, "."
	done

Text0117: ; 386f2 (e:46f2)
	text "Draw 1 card from the Deck."
	done

DrawCardsFromTheDeck: ; 3870e (e:470e)
	text "Draw ", TX_RAM3, " card(s) from the Deck."
	done

NoCardsInDeckCannotDraw: ; 3872d (e:472d)
	text "Cannot draw a card because"
	line "there are no cards in the Deck."
	done

Text011a: ; 38769 (e:4769)
	text "Choose a Pokémon on the Bench"
	line "to give damage to."
	done

Text011b: ; 3879b (e:479b)
	text "Choose up to 3 Pokémon on the"
	line "Bench to give damage to."
	done

Text011c: ; 387d3 (e:47d3)
	text "Choose 1 Basic Energy card"
	line "from the Deck."
	done

Text011d: ; 387fe (e:47fe)
	text "Choose a Pokémon to attach"
	line "the Energy card to."
	done

Text011e: ; 3882e (e:482e)
	text "Choose and Discard"
	line "1 Fire Energy card."
	done

Text011f: ; 38856 (e:4856)
	text "Choose and Discard"
	line "2 Fire Energy cards."
	done

Text0120: ; 3887f (e:487f)
	text "Discard from opponent's Deck as many"
	line "Fire Energy cards as were discarded."
	done

Text0121: ; 388ca (e:48ca)
	text "Choose and Discard"
	line "2 Energy cards."
	done

Text0122: ; 388ee (e:48ee)
	text "Choose a Krabby"
	line "from the Deck."
	done

Text0123: ; 3890e (e:490e)
	text "Choose and Discard an Energy card"
	line "from the opponent's Active Pokémon."
	done

Text0124: ; 38955 (e:4955)
	text "Choose the Attack the opponent will"
	line "not be able to use on the next turn."
	done

Text0125: ; 3899f (e:499f)
	text "Choose a Basic Fighting Pokémon"
	line "from the Deck."
	done

Text0126: ; 389cf (e:49cf)
	text "Choose an Oddish"
	line "from the Deck."
	done

Text0127: ; 389f0 (e:49f0)
	text "Choose an Oddish"
	done

Text0128: ; 38a02 (e:4a02)
	text "Choose a Krabby."
	done

Text0129: ; 38a14 (e:4a14)
	text "Choose a Basic"
	line "Energy card."
	done

Text012a: ; 38a31 (e:4a31)
	text "Choose a Nidoran♀ or a"
	line "Nidoran♂ from the Deck."
	done

Text012b: ; 38a61 (e:4a61)
	text "Choose a Nidoran♀"
	line "or a Nidoran♂."
	done

Text012c: ; 38a83 (e:4a83)
	text "Choose a Basic"
	line "Fighting Pokémon"
	done

Text012d: ; 38aa4 (e:4aa4)
	text "Procedure for Energy Transfer:"
	line ""
	line "1. Choose the Pokémon to move Grass"
	line "   Energy from.  Press the A Button."
	line ""
	line "2. Choose the Pokémon to move the"
	line "   energy to and press the A Button."
	line ""
	line "3. Repeat steps 1 and 2."
	line ""
	line "4. Press the B Button to end."
	done

Text012e: ; 38b8f (e:4b8f)
	text "Choose a Bellsprout"
	line "from the Deck."
	done

Text012f: ; 38bb3 (e:4bb3)
	text "Choose a Bellsprout."
	done

Text0130: ; 38bc9 (e:4bc9)
	text "Choose a Pokémon to remove"
	line "the Damage counter from."
	done

Text0131: ; 38bfe (e:4bfe)
	text "Procedure for Curse:"
	line ""
	line "1. Choose a Pokémon to move the"
	line "   Damage counter from and press"
	line "   the A Button."
	line ""
	line "2. Choose a Pokémon to move the"
	line "   Damage counter to and press"
	line "   the A Button."
	line ""
	line "3. Press the B Button to cancel."
	done

Text0132: ; 38cda (e:4cda)
	text "Choose 2 Energy cards from the"
	line "Discard Pileto attach to a Pokémon."
	done

Text0133: ; 38d1e (e:4d1e)
	text "Choose 2 Energy cards from the"
	line "Discard Pile for your Hand."
	done

Text0134: ; 38d5a (e:4d5a)
	text "Choose an Energy"
	line "card."
	done

Text0135: ; 38d72 (e:4d72)
	text "Procedure for Prophecy:"
	line ""
	line "1. Choose either your Deck"
	line "   or your opponent's Deck"
	line ""
	line "2. Choose the cards you wish to"
	line "   place on top and press the"
	line "   A Button."
	line ""
	line "3. Select Yes after you choose"
	line "   the 3 cards and their order."
	line ""
	line "4. Press the B Button to cancel."
	done

Text0136: ; 38e70 (e:4e70)
	text "Choose the order"
	line "of the cards."
	done

Text0137: ; 38e90 (e:4e90)
	text "Procedure for Damage Swap:"
	line ""
	line "1. Choose a Pokémon to move a"
	line "   Damage counter from and press"
	line "   the A Button."
	line ""
	line "2. Choose a Pokémon to move the"
	line "   Damage counter to and press"
	line "   the A Button."
	line ""
	line "3. Repeat steps 1 and 2."
	line ""
	line "4. Press the B Button to end."
	line ""
	line "5. You cannot move the counter if"
	line "   it will Knock Out the Pokémon."
	done

Text0138: ; 38fcc (e:4fcc)
	text "Procedure for Devolution Beam."
	line ""
	line "1. Choose either a Pokémon in your"
	line "   Play Area or your opponent's"
	line "   Play Area and press the A Button."
	line ""
	line "2. Choose the Pokémon to Devolve"
	line "   and press the A Button."
	line ""
	line "3. Press the B Button to cancel."
	done

Text0139: ; 390b4 (e:50b4)
	text "Procedure for Strange Behavior:"
	line ""
	line "1. Choose the Pokémon with the"
	line "   Damage counters to move to"
	line "   Slowbro and press the A Button."
	line ""
	line "2. Repeat step 1 as many times as"
	line "   you wish to move the counters."
	line ""
	line "3. Press the B Button to end."
	line ""
	line "4. You cannot move the damage if"
	line "   Slowbro will be Knocked Out."
	done

Text013a: ; 391dc (e:51dc)
	text "Choose the opponent's Attack"
	line "to be used with Metronome."
	done

Text013b: ; 39215 (e:5215)
	text "There is no ", TX_RAM2, ""
	line "in the Deck."
	done

Text013c: ; 39231 (e:5231)
	text "Would you like to check the Deck?"
	done

Text013d: ; 39254 (e:5254)
	text "Please select the Deck:"
	line "            Yours   Opponent's"
	done

Text013e: ; 3928c (e:528c)
	text "Please select the Play Area:"
	line "            Yours   Opponent's"
	done

Text013f: ; 392c9 (e:52c9)
	text "Nidoran♂ Nidoran♀"
	done

Text0140: ; 392dc (e:52dc)
	text "Oddish"
	done

Text0141: ; 392e4 (e:52e4)
	text "Bellsprout"
	done

Text0142: ; 392f0 (e:52f0)
	text "Krabby"
	done

Text0143: ; 392f8 (e:52f8)
	text "Fighting Pokémon"
	done

Text0144: ; 3930a (e:530a)
	text "Basic Energy"
	done

Text0145: ; 39318 (e:5318)
	text "Peek was used to look at the"
	line TX_RAM2, " in your Hand."
	done

Text0146: ; 39346 (e:5346)
	text "Card Peek was used on"
	done

Text0147: ; 3935d (e:535d)
	text TX_RAM2, " and all attached"
	line "cards were returned to the Hand."
	done

Text0148: ; 39392 (e:5392)
	text TX_RAM2, " was chosen"
	line "for the effect of Amnesia."
	done

Text0149: ; 393bb (e:53bb)
	text "A Basic Pokémon was placed"
	line "on each Bench."
	done

WasUnsuccessfulText: ; 393e6 (e:53e6)
	text TX_RAM2, "'s"
	line TX_RAM2, " was unsuccessful."
	done

Text014b: ; 393ff (e:53ff)
	text "There was no effect"
	line "from ", TX_RAM2, "."
	done

Text014c: ; 3941c (e:541c)
	text "The Energy card from ", TX_RAM1, "'s"
	line "Play Area was moved."
	done

Text014d: ; 3944b (e:544b)
	text TX_RAM1, " drew"
	line TX_RAM3, " Fire Energy from the Hand."
	done

Text014e: ; 39470 (e:5470)
	text "The Pokémon cards in ", TX_RAM1, "'s"
	line "Hand and Deck were shuffled"
	done

Text014f: ; 394a6 (e:54a6)
	text "Remove Damage counter each time the"
	line "A Button is pressed. B Button quits."
	done

Text0150: ; 394f0 (e:54f0)
	text "Choose a Pokémon to remove"
	line "the Damage counter from."
	done

Text0151: ; 39525 (e:5525)
	text "Choose the card to Discard"
	line "from the Hand."
	done

Text0152: ; 39550 (e:5550)
	text "Choose a Pokémon to remove"
	line "Energy from and choose the Energy."
	done

Text0153: ; 3958f (e:558f)
	text "Choose 2 Basic Energy cards"
	line "from the Discard Pile."
	done

Text0154: ; 395c3 (e:55c3)
	text "Choose a Pokémon and press the A"
	line "Button to remove Damage counters."
	done

Text0155: ; 39607 (e:5607)
	text "Choose 2 cards from the Hand"
	line "to Discard."
	done

Text0156: ; 39631 (e:5631)
	text "Choose 2 cards from the Hand"
	line "to return to the Deck."
	done

Text0157: ; 39666 (e:5666)
	text "Choose a card to"
	line "place in the Hand."
	done

Text0158: ; 3968b (e:568b)
	text "Choose a Pokémon to"
	line "attach Defender to."
	done

Text0159: ; 396b4 (e:56b4)
	text "You can draw up to ", TX_RAM3, " cards."
	line "A to Draw, B to End."
	done

Text015a: ; 396e6 (e:56e6)
	text "Choose a Pokémon to"
	line "return to the Deck."
	done

Text015b: ; 3970f (e:570f)
	text "Choose a Pokémon to"
	line "place in play."
	done

Text015c: ; 39733 (e:5733)
	text "Choose a Basic Pokémon"
	line "to Evolve."
	done

Text015d: ; 39756 (e:5756)
	text "Choose a Pokémon to"
	line "Scoop Up."
	done

Text015e: ; 39775 (e:5775)
	text "Choose a card from your"
	line "Hand to Switch."
	done

Text015f: ; 3979e (e:579e)
	text "Choose a card to"
	line "Switch."
	done

Text0160: ; 397b8 (e:57b8)
	text "Choose a Basic or Evolution"
	line "Pokémon card from the Deck."
	done

Text0161: ; 397f1 (e:57f1)
	text "Choose"
	line "a Pokémon card."
	done

Text0162: ; 39809 (e:5809)
	text "Rearrange the 5 cards at"
	line "the top of the Deck."
	done

Text0163: ; 39838 (e:5838)
	text "Please check the opponent's"
	line "Hand."
	done

Text0164: ; 3985b (e:585b)
	text "Evolution card"
	done

Text0165: ; 3986b (e:586b)
	text TX_RAM2, " was chosen."
	done

Text0166: ; 3987a (e:587a)
	text "Choose a Basic Pokémon"
	line "to place on the Bench."
	done

Text0167: ; 398a9 (e:58a9)
	text "Choose an Evolution card and"
	line "press the A Button to Devolve 1."
	done

Text0168: ; 398e8 (e:58e8)
	text "Choose a Pokémon in your Area, then"
	line "a Pokémon in your opponent's."
	done

Text0169: ; 3992b (e:592b)
	text "Choose up to 4"
	line "from the Discard Pile."
	done

Text016a: ; 39952 (e:5952)
	text "Choose a Pokémon to switch"
	line "with the Active Pokémon."
	done

Text016b: ; 39987 (e:5987)
	text TX_RAM2, " and all attached"
	line "cards were returned to the Deck."
	done

Text016c: ; 399bc (e:59bc)
	text TX_RAM2, " was returned"
	line "from the Arena to the Hand."
	done

Text016d: ; 399e8 (e:59e8)
	text TX_RAM2, " was returned"
	line "from the Bench to the Hand."
	done

Text016e: ; 39a14 (e:5a14)
	text TX_RAM2, " was returned"
	line "to the Deck."
	done

Text016f: ; 39a31 (e:5a31)
	text TX_RAM2, " was placed"
	line "in the Hand."
	done

TheCardYouReceivedText: ; 39a4c (e:5a4c)
	text "The card you received"
	done

YouReceivedTheseCardsText: ; 39a63 (e:5a63)
	text "You received these cards:"
	done

Text0172: ; 39a7e (e:5a7e)
	text "Choose the card"
	line "to put back."
	done

Text0173: ; 39a9c (e:5a9c)
	text "Choose the card"
	line "to Discard."
	done

Text0174: ; 39ab9 (e:5ab9)
	text "Discarded ", TX_RAM3, " cards"
	line "from ", TX_RAM1, "'s Deck."
	done

Text0175: ; 39adb (e:5adb)
	text "Discarded ", TX_RAM2, ""
	line "from the Hand."
	done

Text0176: ; 39af7 (e:5af7)
	text "None came!"
	done

Text0177: ; 39b03 (e:5b03)
	text TX_RAM2, ""
	line "came to the Bench!"
	done

Text0178: ; 39b19 (e:5b19)
	text TX_RAM1, " has"
	line "no cards in Hand!"
	done

Text0179: ; 39b32 (e:5b32)
	text TX_RAM2, " healed"
	line TX_RAM3, " damage!"
	done

Text017a: ; 39b46 (e:5b46)
	text TX_RAM2, " devolved"
	line "to ", TX_RAM2, "!"
	done

Text017b: ; 39b58 (e:5b58)
	text "There was no Fire Energy."
	done

Text017c: ; 39b73 (e:5b73)
	text "You can select ", TX_RAM3, " more cards. Quit?"
	done

Text017d: ; 39b97 (e:5b97)
	text "There was no effect!"
	done

Text017e: ; 39bad (e:5bad)
	text "There was no effect"
	line "from Toxic"
	done

Text017f: ; 39bcd (e:5bcd)
	text "There was no effect"
	line "from Poison."
	done

Text0180: ; 39bef (e:5bef)
	text "There was no effect"
	line "from Sleep."
	done

Text0181: ; 39c10 (e:5c10)
	text "There was no effect"
	line "from Paralysis."
	done

Text0182: ; 39c35 (e:5c35)
	text "There was no effect"
	line "from Confusion."
	done

Text0183: ; 39c5a (e:5c5a)
	text "There was no effet"
	line "from Poison, Confusion."
	done

Text0184: ; 39c86 (e:5c86)
	text "Exchanged the cards"
	line "in ", TX_RAM1, "'s Hand."
	done

Text0185: ; 39ca8 (e:5ca8)
	text "Battle Center"
	done

Text0186: ; 39cb7 (e:5cb7)
	text "Prizes"
	line "       cards"
	done

Text0187: ; 39ccc (e:5ccc)
	text "Choose the number"
	line "of Prizes."
	done

Text0188: ; 39cea (e:5cea)
	text "Please wait..."
	line "Deciding the number of Prizes..."
	done

Text0189: ; 39d1b (e:5d1b)
	text "Begin a ", TX_RAM3, "-Prize Duel"
	line "with ", TX_RAM1, "."
	done

Text018a: ; 39d39 (e:5d39)
	text "Are you both ready"
	line "to Card Pop! ?"
	done

Text018b: ; 39d5c (e:5d5c)
	text "The Pop! wasn't successful."
	line "Please try again."
	done

Text018c: ; 39d8b (e:5d8b)
	text "You cannot Card Pop! with a"
	line "friend you previously Popped! with."
	done

Text018d: ; 39dcc (e:5dcc)
	text "Position the Game Boy Colors"
	line "and press the A Button."
	done

Text018e: ; 39e02 (e:5e02)
	text "Received ", TX_RAM2, ""
	line "through Card Pop!"
	done

ReceivedCardText: ; 39e20 (e:5e20)
	text TX_RAM1, " received"
	line "a ", TX_RAM2, "!"
	done

ReceivedPromotionalCardText: ; 39e31 (e:5e31)
	text TX_RAM1, " received a Promotional"
	line "card ", TX_RAM2, "!"
	done

ReceivedLegendaryCardText: ; 39e53 (e:5e53)
	text TX_RAM1, " received the Legendary"
	line "card ", TX_RAM2, "!"
	done

ReceivedPromotionalFlyingPikachuText: ; 39e75 (e:5e75)
	text TX_RAM1, " received a Promotinal"
	line "card Flyin' Pikachu!"
	done

ReceivedPromotionalSurfingPikachuText: ; 39ea3 (e:5ea3)
	text TX_RAM1, " received a Promotional"
	line "card Surfin' Pikachu!"
	done

Text0194: ; 39ed3 (e:5ed3)
	text "Received a Flareon!!!"
	line "Looked at the card list!"
	done

Text0195: ; 39f03 (e:5f03)
	text "Now printing."
	line "Please wait..."
	done

Text0196: ; 39f21 (e:5f21)
	text "Booster Pack"
	done

Text0197: ; 39f2f (e:5f2f)
	text "Would you like to try again?"
	done

Text0198: ; 39f4d (e:5f4d)
	text "Sent to ", TX_RAM1, "."
	done

Text0199: ; 39f59 (e:5f59)
	text "Received from ", TX_RAM1, "."
	done

Text019a: ; 39f6b (e:5f6b)
	text "Sending a card...Move the Game"
	line "Boys close and press the A Button."
	done

Text019b: ; 39fae (e:5fae)
	text "Receiving a card...Move"
	line "the Game Boys close together."
	done

Text019c: ; 39fe5 (e:5fe5)
	text "Sending a Deck Configuration..."
	line "Position the Game Boys and press A."
	done

Text019d: ; 3a02a (e:602a)
	text "Receiving Deck configuration..."
	line "Position the Game Boys and press A."
	done

Text019e: ; 3a06f (e:606f)
	text "Card transfer wasn't successful."
	done

Text019f: ; 3a091 (e:6091)
	text "Card transfer wasn't successful"
	done

Text01a0: ; 3a0b2 (e:60b2)
	text "Deck configuration transfer"
	line "wasn't successful"
	done

Text01a1: ; 3a0e1 (e:60e1)
	text "Deck configuration transfer"
	line "wasn't successful."
	done

Text01a2: ; 3a111 (e:6111)
	text "Now printing..."
	done

DrMasonText: ; 3a122 (e:6122)
	text "Dr. Mason"
	done

Text01a4: ; 3a12d (e:612d)
	text "Draw 7 cards,"
	line ""
	line "and get ready for the battle!"
	line "Choose your Active Pokémon."
	line "You can only choose Basic Pokémon"
	line "as your Active Pokémon,"
	line "so you can choose either Goldeen"
	line "or Staryu."
	line "For our practice duel,"
	line "choose Goldeen."
	done

Text01a5: ; 3a204 (e:6204)
	text "Choose Goldeen for this"
	line "practice duel, OK?"
	done

Text01a6: ; 3a230 (e:6230)
	text "Next, put your Pokémon on your"
	line "Bench."
	line "You can switch Benched Pokémon"
	line "with your Active Pokémon."
	line "Again, only Basic Pokémon can be"
	line "placed on your Bench."
	line "Choose Staryu from your hand and"
	line "put it there."
	done

Text01a7: ; 3a2f6 (e:62f6)
	text "Choose Staryu for this"
	line "practice duel, OK?"
	done

Text01a8: ; 3a321 (e:6321)
	text "When you have no Pokémon to put on"
	line "your Bench, press the B Button to"
	line "finish."
	done

Text01a9: ; 3a36f (e:636f)
	text "1. Choose Hand from the Menu."
	line "   Select a Water Energy card."
	done

Text01aa: ; 3a3ad (e:63ad)
	text "2. Attach a Water Energy card to"
	line "   your Active Pokémon, Goldeen."
	done

Text01ab: ; 3a3f0 (e:63f0)
	text "3. Choose Attack from the Menu"
	line "   and select Horn Attack."
	done

Text01ac: ; 3a42b (e:642b)
	text "1. Evolve Goldeen by"
	line "   attaching Seaking to it."
	done

Text01ad: ; 3a45d (e:645d)
	text "2. Attach a Psychic Energy card"
	line "   to the evolved Seaking."
	done

Text01ae: ; 3a499 (e:6499)
	text "3. Choose Attack and select"
	line "   Waterfall to attack your"
	line "   opponent."
	done

Text01af: ; 3a4df (e:64df)
	text "1. Attach a Water Energy card to"
	line "   your Benched Staryu."
	done

Text01b0: ; 3a519 (e:6519)
	text "2. Choose Attack and attack your"
	line "   opponent with Horn Attack."
	done

Text01b1: ; 3a559 (e:6559)
	db TX_END

Text01b2: ; 3a55a (e:655a)
	text "1. Take Drowzee from your hand"
	line "   and put it on your Bench."
	done

Text01b3: ; 3a597 (e:6597)
	text "2. Attach a Water Energy card to"
	line "   your Benched Drowzee."
	done

Text01b4: ; 3a5d2 (e:65d2)
	text "3. Choose Seaking and attack your"
	line "   opponent with Waterfall."
	done

Text01b5: ; 3a611 (e:6611)
	text "1. Choose a Water Energy card from"
	line "   your hand and attach it to"
	line "   Staryu."
	done

Text01b6: ; 3a65e (e:665e)
	text "2. Choose Staryu and attack your"
	line "   opponent with Slap."
	done

Text01b7: ; 3a697 (e:6697)
	text "1. Choose the Potion card in your"
	line "   hand to recover Staryu's HP."
	done

Text01b8: ; 3a6da (e:66da)
	text "2. Attach a Water Energy card to"
	line "   Staryu."
	done

Text01b9: ; 3a707 (e:6707)
	text "3. Choose Staryu and attack your"
	line "   opponent with Slap."
	done

Text01ba: ; 3a740 (e:6740)
	text "1. Evolve Staryu by"
	line "   attaching Starmie to it."
	done

Text01bb: ; 3a771 (e:6771)
	text "2. Select the evolved Starmie and"
	line "   attack your opponent with Star "
	line "   Freeze."
	done

Text01bc: ; 3a7c2 (e:67c2)
	text "1. Select Starmie and attack your"
	line "   opponent with Star Freeze."
	done

Text01bd: ; 3a803 (e:6803)
	text "2. You Knocked Machop Out."
	line "   Now you can draw a Prize."
	done

Text01be: ; 3a83c (e:683c)
	text "1. Your Seaking was Knocked Out."
	line "   Choose your Benched Staryu"
	line "   and press the A Button to set"
	line "   it as your Active Pokémon."
	done

Text01bf: ; 3a8bb (e:68bb)
	text "2. You can check Pokémon data by"
	line "   pressing SELECT."
	done

Text01c0: ; 3a8f1 (e:68f1)
	text "To use the attack command, you need"
	line "to attach Energy cards to your"
	line "Pokémon."
	line ""
	line "Choose Cards from the Menu, and"
	line "select a Water Energy card."
	done

Text01c1: ; 3a97b (e:697b)
	text "Next, choose your Active Pokémon,"
	line "Goldeen, and press the A Button."
	line "Then the Water Energy card will"
	line "be attached to Goldeen."
	done

Text01c2: ; 3a9f7 (e:69f7)
	text "Finally, attack your opponent by"
	line "selecting an attack command."
	line "Choose Attack from the Menu, and"
	line "select Horn Attack."
	done

Text01c3: ; 3aa6b (e:6a6b)
	text "Your Goldeen's gonna get Knocked"
	line "Out. Let's evolve it!"
	line "Choose Seaking from your hand and"
	line "attach it to Goldeen to"
	line "Evolve it."
	line "Its HP increases from 40 to 70."
	done

Text01c4: ; 3ab08 (e:6b08)
	text "Your Seaking doesn't have enough"
	line "Energy to use Waterfall."
	line "You need to attach a Psychic Energy"
	line "card to Seaking."
	line "<COLORLESS> means any Energy card."
	line "Now you can use Waterfall."
	line "Keep the Water Energy card for"
	line "other Pokémon."
	done

Text01c5: ; 3abdb (e:6bdb)
	text "Now let's attack your opponent with"
	line "Seaking's Waterfall!"
	done

Text01c6: ; 3ac15 (e:6c15)
	text "Seaking's got enough Energy, so"
	line "you don't need to attach any more."
	line "Attach Energy cards to your Benched"
	line "Pokémon to get them ready for"
	line "battle."
	line ""
	line "Attach a Water Energy card to your"
	line "Benched Staryu."
	done

Text01c7: ; 3acd7 (e:6cd7)
	text "Next, select the attack command."
	line "Machop has 10 HP left."
	line "Seaking's Horn Attack will be"
	line "enough to Knock out Machop."
	line "Now, choose Seaking's"
	line "Horn Attack."
	done

Text01c8: ; 3ad6d (e:6d6d)
	text "Now Machop's HP is 0 and it is"
	line "Knocked Out."
	line "When you Knock Out the Defending"
	line "Pokémon, you can pick up a"
	line "Prize."
	done

Text01c9: ; 3addd (e:6ddd)
	text "When all your Pokémon are Knocked"
	line "Out and there are no Pokémon on your"
	line "Bench, you lose the game."
	line ""
	line "Put Drowzee, the Basic Pokémon"
	line "you just drew, on your Bench."
	done

Text01ca: ; 3ae7d (e:6e7d)
	text "Attach a Water Energy card to"
	line "Drowzee to get it ready to"
	line "attack."
	done

Text01cb: ; 3aebf (e:6ebf)
	text "Choose your Active Seaking and"
	line "attack your opponent with"
	line "Waterfall."
	done

Text01cc: ; 3af04 (e:6f04)
	text "Staryu evolves into Starmie!"
	line ""
	line "Let's get Staryu ready to use"
	line "Starmie's attack command when it"
	line "evolves to Starmie."
	line ""
	line "Choose the Water Energy card from"
	line "your hand and attach it to Staryu."
	done

Text01cd: ; 3afbc (e:6fbc)
	text "Attack your opponent with Staryu's"
	line "Slap."
	done

Text01ce: ; 3afe6 (e:6fe6)
	text "Now, recover Staryu with a Trainer"
	line "card."
	line "Choose Potion from your hand."
	done

Text01cf: ; 3b02e (e:702e)
	text "Now let's get ready to evolve"
	line "it to Starmie."
	line "Also, attach a Water Energy card to"
	line "Staryu."
	done

Text01d0: ; 3b088 (e:7088)
	text "Attack your opponent with Staryu's"
	line "Slap to end your turn."
	done

Text01d1: ; 3b0c3 (e:70c3)
	text "Now you have finally drawn a"
	line "Starmie card!"
	line "Choose Starmie from your hand and"
	line "use it to evolve Staryu."
	done

Text01d2: ; 3b12a (e:712a)
	text "You've already attached enough"
	line "Energy to use Star Freeze."
	line "Attack your opponent with"
	line "Starmie's Star Freeze."
	done

Text01d3: ; 3b196 (e:7196)
	text "Now Machop has only 10 HP left."
	line "Let's finish the battle!"
	line "Attack with Starmie's Star Freeze."
	line TX_END

Text01d4: ; 3b1f4 (e:71f4)
	text "You've Knocked Out your opponent!"
	line ""
	line "Pick up the last Prize."
	line ""
	text TX_RAM1, " is the winner!"
	done

Text01d5: ; 3b242 (e:7242)
	text "Choose a Benched Pokémon to replace"
	line "your Knocked Out Pokémon."
	line "You now have Drowzee and Staryu"
	line "on your Bench."
	line "Choose Staryu as the Active Pokémon"
	line "for this practice duel."
	done

Text01d6: ; 3b2ec (e:72ec)
	text "Here, press SELECT to"
	line "check Pokémon data."
	line "It is important to know your cards"
	line "and the status of your Pokémon."
	done

Text01d7: ; 3b35a (e:735a)
	text "Select Staryu for this practice,"
	line "OK?"
	done

Text01d8: ; 3b380 (e:7380)
	text "Now, let's play the game!"
	done

Text01d9: ; 3b39b (e:739b)
	text "Do you need to practice again?"
	done

Text01da: ; 3b3bb (e:73bb)
	text "This is Practice Mode, so"
	line "please follow my guidance."
	line "Do it again."
	done

Text01db: ; 3b3fe (e:73fe)
	text TX_RAM1, "'s turn ", TX_RAM3
	done

Text01dc: ; 3b40a (e:740a)
	text " Replace due to Knockout "
	done

Text01dd: ; 3b425 (e:7425)
	text "Dummy"
	done

PracticePlayerDeckName: ; 3b42c (e:742c)
	text "Practice Player"
	done

SamsPracticeDeckName: ; 3b43d (e:743d)
	text "Sam's Practice"
	done

CharmanderAndFriendsDeckName: ; 3b44d (e:744d)
	text "Charmander & Friends"
	done

CharmanderExtraDeckName: ; 3b463 (e:7463)
	text "Charmander extra"
	done

SquirtleAndFriendsDeckName: ; 3b475 (e:7475)
	text "Squirtle & Friends"
	done

SquirtleExtraDeckName: ; 3b489 (e:7489)
	text "Squirtle extra"
	done

BulbasaurAndFriendsDeckName: ; 3b499 (e:7499)
	text "Bulbasaur & Friends"
	done

BulbasaurExtraDeckName: ; 3b4ae (e:74ae)
	text "Bulbasaur extra"
	done

FirstStrikeDeckName: ; 3b4bf (e:74bf)
	text "First-Strike"
	done

RockCrusherDeckName: ; 3b4cd (e:74cd)
	text "Rock Crusher"
	done

GoGoRainDanceDeckName: ; 3b4db (e:74db)
	text "Go Go Rain Dance"
	done

ZappingSelfdestructDeckName: ; 3b4ed (e:74ed)
	text "Zapping Selfdestruct"
	done

FlowerPowerDeckName: ; 3b503 (e:7503)
	text "Flower Power"
	done

StrangePsyshockDeckName: ; 3b511 (e:7511)
	text "Strange Psyshock"
	done

WondersofScienceDeckName: ; 3b523 (e:7523)
	text "Wonders of Science"
	done

FireChargeDeckName: ; 3b537 (e:7537)
	text "Fire Charge"
	done

LegendaryMoltresDeckName: ; 3b544 (e:7544)
	text "Legendary Moltres"
	done

LegendaryZapdosDeckName: ; 3b557 (e:7557)
	text "Legendary Zapdos"
	done

LegendaryArticunoDeckName: ; 3b569 (e:7569)
	text "Legendary Articuno"
	done

LegendaryDragoniteDeckName: ; 3b57d (e:757d)
	text "Legendary Dragonite"
	done

ImRonaldDeckName: ; 3b592 (e:7592)
	text "I'm Ronald!"
	done

PowerfulRonaldDeckName: ; 3b59f (e:759f)
	text "Powerful Ronald"
	done

InvincibleRonaldDeckName: ; 3b5b0 (e:75b0)
	text "Invincible Ronald"
	done

LegendaryRonaldDeckName: ; 3b5c3 (e:75c3)
	text "Legendary Ronald"
	done

WaterfrontPokemonDeckName: ; 3b5d5 (e:75d5)
	text "Waterfront Pokémon"
	done

LonelyFriendsDeckName: ; 3b5e9 (e:75e9)
	text "Lonely Friends"
	done

SoundoftheWavesDeckName: ; 3b5f9 (e:75f9)
	text "Sound of the Waves"
	done

AngerDeckName: ; 3b60d (e:760d)
	text "Anger"
	done

FlamethrowerDeckName: ; 3b614 (e:7614)
	text "Flamethrower"
	done

ReshuffleDeckName: ; 3b622 (e:7622)
	text "Reshuffle"
	done

ExcavationDeckName: ; 3b62d (e:762d)
	text "Excavation"
	done

BlisteringPokemonDeckName: ; 3b639 (e:7639)
	text "Blistering Pokémon"
	done

HardPokemonDeckName: ; 3b64d (e:764d)
	text "Hard Pokémon"
	done

EtceteraDeckName: ; 3b65b (e:765b)
	text "Etcetera"
	done

FlowerGardenDeckName: ; 3b665 (e:7665)
	text "Flower Garden"
	done

KaleidoscopeDeckName: ; 3b674 (e:7674)
	text "Kaleidoscope"
	done

MusclesforBrainsDeckName: ; 3b682 (e:7682)
	text "Muscles for Brains"
	done

HeatedBattleDeckName: ; 3b696 (e:7696)
	text "Heated Battle"
	done

LovetoBattleDeckName: ; 3b6a5 (e:76a5)
	text "Love to Battle"
	done

PikachuDeckName: ; 3b6b5 (e:76b5)
	text "Pikachu"
	done

BoomBoomSelfdestructDeckName: ; 3b6be (e:76be)
	text "Boom Boom Selfdestruct"
	done

PowerGeneratorDeckName: ; 3b6d6 (e:76d6)
	text "Power Generator"
	done

GhostDeckName: ; 3b6e7 (e:76e7)
	text "Ghost"
	done

NapTimeDeckName: ; 3b6ee (e:76ee)
	text "Nap Time"
	done

StrangePowerDeckName: ; 3b6f8 (e:76f8)
	text "Strange Power"
	done

FlyinPokemonDeckName: ; 3b707 (e:7707)
	text "Flyin' Pokémon"
	done

LovelyNidoranDeckName: ; 3b717 (e:7717)
	text "Lovely Nidoran"
	done

PoisonDeckName: ; 3b727 (e:7727)
	text "Poison"
	done

ImakuniDeckName: ; 3b72f (e:772f)
	text "Imakuni?"
	done

LightningAndFireDeckName: ; 3b739 (e:7739)
	text "Lightning & Fire"
	done

WaterAndFightingDeckName: ; 3b74b (e:774b)
	text "Water & Fighting"
	done

GrassAndPsychicDeckName: ; 3b75d (e:775d)
	text "Grass & Psychic"
	done

Text0212: ; 3b76e (e:776e)
	text "Retreat Cost"
	done

Text0213: ; 3b77c (e:777c)
	db $03,$42,$03,$46,$03,$38,$03,$43,$03,$32,$03,$37,$70,$03,$43,$03,$3e,$70,$03,$44,$03,$3f,$03,$3f,$03,$34,$03,$41
	done

Text0214: ; 3b799 (e:7799)
	db $03,$42,$03,$46,$03,$38,$03,$43,$03,$32,$03,$37,$70,$03,$43,$03,$3e,$70,$03,$3b,$03,$3e,$03,$46,$03,$34,$03,$41
	done

Text0215: ; 3b7b6 (e:77b6)
	db $03,$7a
	done

Text0216: ; 3b7b9 (e:77b9)
	db $03,$7b
	done

YourDiscardPileText: ; 3b7bc (e:77bc)
	text "Your Discard Pile"
	done

OpponentsDiscardPileText: ; 3b7cf (e:77cf)
	text "Opponent's Discard Pile"
	done

Text0219: ; 3b7e8 (e:77e8)
	text "Deck"
	done

Text021a: ; 3b7ee (e:77ee)
	db $0e,$2b,$37,$3e,$25
	done

Text021b: ; 3b7f4 (e:77f4)
	db $16,$20,$16,$25
	done

Text021c: ; 3b7f9 (e:77f9)
	db $03,$30,$03,$31,$03,$32
	done

Text021d: ; 3b800 (e:7800)
	text "End"
	done

Text021e: ; 3b805 (e:7805)
	text "What is your name?"
	done

Text021f: ; 3b819 (e:7819)
	db $0e,$11,$70,$16,$70,$1b,$70,$20,$70,$25,$70,$2a,$70,$2f,$70,$34,$70,$37,""
	line $12,$70,$17,$70,$1c,$70,$21,$70,$26,$70,$2b,$70,$30,$70,$35,$70,$38,""
	line $13,$70,$18,$70,$1d,$70,$22,$70,$27,$70,$2c,$70,$31,$70,$36,$70,$39,""
	line $14,$70,$19,$70,$1e,$70,$23,$70,$28,$70,$2d,$70,$32,$70,$3c,$70,$3a,""
	line $15,$70,$1a,$70,$1f,$70,$24,$70,$29,$70,$2e,$70,$33,$70,$3d,$70,$3b,""
	line $5c,$70,$5d,$70,$5e,$70,$5f,$70,$10,$70,$03,$59,$70,$03,$5b,$70,$78
	done

Text0220: ; 3b886 (e:7886)
	db $11,$70,$16,$70,$1b,$70,$20,$70,$25,$70,$2a,$70,$2f,$70,$34,$70,$37,""
	line $12,$70,$17,$70,$1c,$70,$21,$70,$26,$70,$2b,$70,$30,$70,$35,$70,$38,""
	line $13,$70,$18,$70,$1d,$70,$22,$70,$27,$70,$2c,$70,$31,$70,$36,$70,$39,""
	line $14,$70,$19,$70,$1e,$70,$23,$70,$28,$70,$2d,$70,$32,$70,$3c,$70,$3a,""
	line $15,$70,$1a,$70,$1f,$70,$24,$70,$29,$70,$2e,$70,$33,$70,$3d,$70,$3b,""
	line $5c,$70,$5d,$70,$5e,$70,$5f,$70,$10,$70,$03,$59,$70,$03,$5b,$70,$78
	done

Text0221: ; 3b8f2 (e:78f2)
	db $03,$30,$70,$03,$31,$70,$03,$32,$70,$03,$33,$70,$03,$34,$70,$03,$35,$70,$03,$36,$70,$03,$37,$70,$03,$38,""
	line $03,$39,$70,$03,$3a,$70,$03,$3b,$70,$03,$3c,$70,$03,$3d,$70,$03,$3e,$70,$03,$3f,$70,$03,$40,$70,$03,$41,""
	line $03,$42,$70,$03,$43,$70,$03,$44,$70,$03,$45,$70,$03,$46,$70,$03,$47,$70,$03,$48,$70,$03,$49,$70,$6e,""
	line $6f,$70,$03,$5d,$70,$6a,$70,$6b,$70,$77,$70,$60,$70,$61,$70,$62,$70,$63,""
	line $64,$70,$65,$70,$66,$70,$67,$70,$68,$70,$69,$70,$05,$13,$70,$05,$11,$70,$70,""
	line $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70
	done

Text0222: ; 3b97b (e:797b)
	db $03,$30,$70,$03,$31,$70,$03,$32,$70,$03,$33,$70,$03,$34,$70,$03,$35,$70,$03,$36,$70,$03,$37,$70,$03,$38,""
	line $03,$39,$70,$03,$3a,$70,$03,$3b,$70,$03,$3c,$70,$03,$3d,$70,$03,$3e,$70,$03,$3f,$70,$03,$40,$70,$03,$41,""
	line $03,$42,$70,$03,$43,$70,$03,$44,$70,$03,$45,$70,$03,$46,$70,$03,$47,$70,$03,$48,$70,$03,$49,$70,$6e,""
	line $6f,$70,$03,$5d,$70,$6a,$70,$6b,$70,$03,$7a,$70,$60,$70,$61,$70,$62,$70,$63,""
	line $64,$70,$65,$70,$66,$70,$67,$70,$68,$70,$69,$70,$70,$70,$70,$70,$70,""
	line $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70
	done

NewDeckText: ; 3ba03 (e:7a03)
	text "New deck"
	done

PleaseSelectDeckText: ; 3ba0d (e:7a0d)
	text "Please select deck."
	done

Text0225: ; 3ba22 (e:7a22)
	text "Modify deck"
	done

Text0226: ; 3ba2f (e:7a2f)
	text "Change name"
	done

Text0227: ; 3ba3c (e:7a3c)
	text "Select deck"
	done

Text0228: ; 3ba49 (e:7a49)
	text "Cancel"
	done

Text0229: ; 3ba51 (e:7a51)
	text "as"
	done

ChosenAsDuelingDeckText: ; 3ba55 (e:7a55)
	text TX_RAM2, " was"
	line "chosen as the dueling deck!"
	done

Text022b: ; 3ba78 (e:7a78)
	db $61,$77
	done

Text022c: ; 3ba7b (e:7a7b)
	db $62,$77
	done

Text022d: ; 3ba7e (e:7a7e)
	db $63,$77
	done

Text022e: ; 3ba81 (e:7a81)
	db $64,$77
	done

ThereIsNoDeckHereText: ; 3ba84 (e:7a84)
	text "There is no Deck here!"
	done

Text0230: ; 3ba9c (e:7a9c)
	text "Confirm"
	done

Text0231: ; 3baa5 (e:7aa5)
	text "Dismantle"
	done

Text0232: ; 3bab0 (e:7ab0)
	text "Modify"
	done

Text0233: ; 3bab8 (e:7ab8)
	text "Save"
	done

Text0234: ; 3babe (e:7abe)
	text "Name"
	done

Text0235: ; 3bac4 (e:7ac4)
	text "There is only 1 Deck, so this"
	line "Deck cannot be dismantled."
	done

Text0236: ; 3bafe (e:7afe)
	text "There are no Basic Pokémon"
	line "in this Deck!"
	done

Text0237: ; 3bb28 (e:7b28)
	text "You must include a Basic Pokémon"
	line "in the Deck!"
	done

Text0238: ; 3bb57 (e:7b57)
	text "This isn't a 60-card deck!"
	done

Text0239: ; 3bb73 (e:7b73)
	text "The Deck must include 60 cards!"
	done

Text023a: ; 3bb94 (e:7b94)
	text "Return to original configuration?"
	done

Text023b: ; 3bbb7 (e:7bb7)
	text "Save this Deck?"
	done

Text023c: ; 3bbc8 (e:7bc8)
	text "Quit modifying the Deck?"
	done

Text023d: ; 3bbe2 (e:7be2)
	text "Dismantle this Deck?"
	done

Text023e: ; 3bbf8 (e:7bf8)
	text "No cards chosen."
	done

Text023f: ; 3bc0a (e:7c0a)
	text "Your Pokémon"
	done

Text0240: ; 3bc18 (e:7c18)
	text "Your Discard Pile"
	done

Text0241: ; 3bc2b (e:7c2b)
	text "Your Hand"
	done

Text0242: ; 3bc36 (e:7c36)
	text "To Your Play Area"
	done

Text0243: ; 3bc49 (e:7c49)
	text "Opponent's Pokémon"
	done

Text0244: ; 3bc5d (e:7c5d)
	text "Opponent's Discard Pile"
	done

Text0245: ; 3bc76 (e:7c76)
	text "Opponent Hand"
	done

Text0246: ; 3bc85 (e:7c85)
	text "To Opponent's Play Area"
	done

Text0247: ; 3bc9e (e:7c9e)
	text TX_RAM1, "'s Play Area"
	done

Text0248: ; 3bcad (e:7cad)
	text "Your Play Area"
	done

Text0249: ; 3bcbd (e:7cbd)
	text "Opp. Play Area"
	done

Text024a: ; 3bccd (e:7ccd)
	text "In Play Area"
	done

Text024b: ; 3bcdb (e:7cdb)
	text "Glossary"
	done

Text024c: ; 3bce5 (e:7ce5)
	text "Which card would you like to see?"
	done

Text024d: ; 3bd08 (e:7d08)
	text "Please choose a Prize."
	done

Text024e: ; 3bd20 (e:7d20)
	text "Hand"
	done

Text024f: ; 3bd26 (e:7d26)
	text TX_RAM1, "'s Hand"
	done

Text0250: ; 3bd30 (e:7d30)
	text TX_RAM1, "'s Discard Pile"
	done

Text0251: ; 3bd42 (e:7d42)
	db $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70
	done

Text0252: ; 3bd55 (e:7d55)
	text "Booster Pack"
	done

Text0253: ; 3bd63 (e:7d63)
	text "1. Colosseum"
	done

Text0254: ; 3bd71 (e:7d71)
	text "2. Evolution"
	done

Text0255: ; 3bd7f (e:7d7f)
	text "3. Mystery"
	done

Text0256: ; 3bd8b (e:7d8b)
	text "4. Laboratory"
	done

Text0257: ; 3bd9a (e:7d9a)
	text "5. Promotional Card"
	done

Text0258: ; 3bdaf (e:7daf)
	text "View which Card File?"
	done

Text0259: ; 3bdc6 (e:7dc6)
	db $6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b
	done

Text025a: ; 3bdd1 (e:7dd1)
	text "'s Cards"
	done

Text025b: ; 3bddb (e:7ddb)
	db $6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b
	done

Text025c: ; 3bdea (e:7dea)
	text "  Deck Save Machine   "
	done

Text025d: ; 3be02 (e:7e02)
	text "Save a Deck"
	done

Text025e: ; 3be0f (e:7e0f)
	text "Delete a Deck"
	done

Text025f: ; 3be1e (e:7e1e)
	text "Build a Deck"
	done

Text0260: ; 3be2c (e:7e2c)
	text "Choose a Deck to Save."
	done

Text0261: ; 3be44 (e:7e44)
	text "You may only Save 60 Decks."
	line "Please Delete a Deck first."
	done

Text0262: ; 3be7d (e:7e7d)
	text "for"
	done

Text0263: ; 3be82 (e:7e82)
	text "Saved the configuration for"
	line ""
	text TX_RAM2, "! "
	done

Text0264: ; 3bea4 (e:7ea4)
	text "No Deck is saved."
	done

Text0265: ; 3beb7 (e:7eb7)
	text "Please choose a Deck "
	line "configuration to delete."
	done

Text0266: ; 3bee7 (e:7ee7)
	text "Do you really wish to delete?"
	done

Text0267: ; 3bf06 (e:7f06)
	text "Deleted the configuration for"
	line ""
	text TX_RAM2, "."
	done

Text0268: ; 3bf29 (e:7f29)
	text "You may only carry 4 Decks!"
	done

Text0269: ; 3bf46 (e:7f46)
	text "Choose a deck to dismantle."
	done

Text026a: ; 3bf63 (e:7f63)
	text "Dismantled"
	line ""
	text TX_RAM2, "."
	done

Text026b: ; 3bf73 (e:7f73)
	text "Please choose the Deck"
	line "you wish to Build."
	done

Text026c: ; 3bf9e (e:7f9e)
	text "This Deck can only be built if"
	line "you dismantle another Deck."
	done
