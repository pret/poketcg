Text00f5: ; 38000 (e:4000)
	db TX_START,"Acid check! If Heads,\n"
	db "unable to Retreat during next turn.",TX_END

Text00f6: ; 3803b (e:403b)
	db TX_START,"Transparency check! If Heads,\n"
	db "do not receive opponent's Attack!",TX_END

Text00f7: ; 3807c (e:407c)
	db TX_START,"Confusion check,\n"
	db "If Tails, damage to yourself!",TX_END

Text00f8: ; 380ac (e:40ac)
	db TX_START,"Confusion check!\n"
	db "If Tails, unable to Retreat.",TX_END

Text00f9: ; 380db (e:40db)
	db TX_START,TX_RAM2,"'s Sleep check.",TX_END

Text00fa: ; 380ed (e:40ed)
	db TX_START,"Opponent is Poisoned if Heads,\n"
	db "and Confused if Tails.",TX_END

Text00fb: ; 38124 (e:4124)
	db TX_START,"If Heads, do not receive damage\n"
	db "or effect of opponent's next Attack!",TX_END

Text00fc: ; 3816a (e:416a)
	db TX_START,"If Heads, opponent cannot Attack\n"
	db "next turn!",TX_END

AttackUnsuccessful: ; 38197 (e:4197)
	db TX_START,"Attack unsuccessful.",TX_END

UnableToRetreatDueToAcid: ; 381ad (e:41ad)
	db TX_START,"Unable to Retreat due to\n"
	db "the effects of Acid.",TX_END

UnableToUseTrainerDueToHeadache: ; 381dc (e:41dc)
	db TX_START,"Unable to use a Trainer card\n"
	db "due to the effects of Headache.",TX_END

UnableToAttackDueToTailWag: ; 3821a (e:421a)
	db TX_START,"Unable to Attack due to\n"
	db "the effects of Tail wag.",TX_END

UnableToAttackDueToLeer: ; 3824c (e:424c)
	db TX_START,"Unable to Attack due to\n"
	db "the effects of Leer.",TX_END

UnableToAttackDueToBoneAttack: ; 3827a (e:427a)
	db TX_START,"Unable to Attack due to\n"
	db "the effects of Bone attack.",TX_END

UnableToUseAttackDueToAmnesia: ; 382af (e:42af)
	db TX_START,"Unable to use this Attack\n"
	db "due to the effects of Amnesia.",TX_END

KnockedOutDueToDestinyBond: ; 382e9 (e:42e9)
	db TX_START,TX_RAM2," was Knocked Out\n"
	db "due to the effects of Destiny Bond.",TX_END

ReceivesDamageDueToStrikesBack: ; 38320 (e:4320)
	db TX_START,TX_RAM2," receives ",TX_RAM3," damage\n"
	db "due to the effects of Strikes Back.",TX_END

UnableToEvolveDueToPrehistoricPower: ; 38359 (e:4359)
	db TX_START,"Unable to evolve due to the\n"
	db "effects of Prehistoric Power.",TX_END

NoDamageOrEffectDueToFly: ; 38394 (e:4394)
	db TX_START,"No damage or effect on next Attack\n"
	db "due to the effects of Fly.",TX_END

NoDamageOrEffectDueToBarrier: ; 383d3 (e:43d3)
	db TX_START,"No damage or effect on next Attack\n"
	db "due to the effects of Barrier.",TX_END

NoDamageOrEffectDueToAgility: ; 38416 (e:4416)
	db TX_START,"No damage or effect on next Attack\n"
	db "due to the effects of Agility.",TX_END

UnableToUseAttackDueToNShield: ; 38459 (e:4459)
	db TX_START,"Unable to use this Attack due to\n"
	db "the effects of N Shield.",TX_END

NoDamageOrEffectDueToNShield: ; 38494 (e:4494)
	db TX_START,"No damage or effect on next Attack\n"
	db "due to the effects of N Shield.",TX_END

NoDamageOrEffectDueToTransparency: ; 384d8 (e:44d8)
	db TX_START,"No damage or effect on next Attack\n"
	db "due to the effects of Transparency",TX_END

Text010d: ; 3851f (e:451f)
	db TX_START,TX_RAM2,"\n"
	db "metamorphs to ",TX_RAM2,".",TX_END

SelectMonOnBenchToSwitchWithActive: ; 38533 (e:4533)
	db TX_START,"Select a Pok`mon on the Bench\n"
	db "to switch with the Active Pok`mon.",TX_END

Text010f: ; 38575 (e:4575)
	db TX_START,"Select a Pok`mon to place\n"
	db "in the Arena.",TX_END

Text0110: ; 3859e (e:459e)
	db TX_START,TX_RAM1," is selecting a Pok`mon\n"
	db "to place in the Arena.",TX_END

Text0111: ; 385cf (e:45cf)
	db TX_START,"Choose the Weakness you wish\n"
	db "to change with Conversion 1.",TX_END

Text0112: ; 3860a (e:460a)
	db TX_START,"Choose the Resistance you wish\n"
	db "to change with Conversion 2.",TX_END

Text0113: ; 38647 (e:4647)
	db TX_START,"Choose the Pok`mon whose color you\n"
	db "wish to change with Color change.",TX_END

Text0114: ; 3868d (e:468d)
	db TX_START,"Changed the Weakness of\n"
	db TX_START,TX_RAM2," to ",TX_RAM2,".",TX_END

Text0115: ; 386af (e:46af)
	db TX_START,"Changed the Resistance of\n"
	db TX_START,TX_RAM2," to ",TX_RAM2,".",TX_END

Text0116: ; 386d3 (e:46d3)
	db TX_START,"Changed the color of\n"
	db TX_START,TX_RAM2," to ",TX_RAM2,".",TX_END

Text0117: ; 386f2 (e:46f2)
	db TX_START,"Draw 1 card from the Deck.",TX_END

Text0118: ; 3870e (e:470e)
	db TX_START,"Draw ",TX_RAM3," card(s) from the Deck.",TX_END

Text0119: ; 3872d (e:472d)
	db TX_START,"Cannot draw a card because\n"
	db "there are no cards in the Deck.",TX_END

Text011a: ; 38769 (e:4769)
	db TX_START,"Choose a Pok`mon on the Bench\n"
	db "to give damage to.",TX_END

Text011b: ; 3879b (e:479b)
	db TX_START,"Choose up to 3 Pok`mon on the\n"
	db "Bench to give damage to.",TX_END

Text011c: ; 387d3 (e:47d3)
	db TX_START,"Choose 1 Basic Energy card\n"
	db "from the Deck.",TX_END

Text011d: ; 387fe (e:47fe)
	db TX_START,"Choose a Pok`mon to attach\n"
	db "the Energy card to.",TX_END

Text011e: ; 3882e (e:482e)
	db TX_START,"Choose and Discard\n"
	db "1 Fire Energy card.",TX_END

Text011f: ; 38856 (e:4856)
	db TX_START,"Choose and Discard\n"
	db "2 Fire Energy cards.",TX_END

Text0120: ; 3887f (e:487f)
	db TX_START,"Discard from opponent's Deck as many\n"
	db "Fire Energy cards as were discarded.",TX_END

Text0121: ; 388ca (e:48ca)
	db TX_START,"Choose and Discard\n"
	db "2 Energy cards.",TX_END

Text0122: ; 388ee (e:48ee)
	db TX_START,"Choose a Krabby\n"
	db "from the Deck.",TX_END

Text0123: ; 3890e (e:490e)
	db TX_START,"Choose and Discard an Energy card\n"
	db "from the opponent's Active Pok`mon.",TX_END

Text0124: ; 38955 (e:4955)
	db TX_START,"Choose the Attack the opponent will\n"
	db "not be able to use on the next turn.",TX_END

Text0125: ; 3899f (e:499f)
	db TX_START,"Choose a Basic Fighting Pok`mon\n"
	db "from the Deck.",TX_END

Text0126: ; 389cf (e:49cf)
	db TX_START,"Choose an Oddish\n"
	db "from the Deck.",TX_END

Text0127: ; 389f0 (e:49f0)
	db TX_START,"Choose an Oddish",TX_END

Text0128: ; 38a02 (e:4a02)
	db TX_START,"Choose a Krabby.",TX_END

Text0129: ; 38a14 (e:4a14)
	db TX_START,"Choose a Basic\n"
	db "Energy card.",TX_END

Text012a: ; 38a31 (e:4a31)
	db TX_START,"Choose a Nidoran% or a\n"
	db "Nidoran$ from the Deck.",TX_END

Text012b: ; 38a61 (e:4a61)
	db TX_START,"Choose a Nidoran%\n"
	db "or a Nidoran$.",TX_END

Text012c: ; 38a83 (e:4a83)
	db TX_START,"Choose a Basic\n"
	db "Fighting Pok`mon",TX_END

Text012d: ; 38aa4 (e:4aa4)
	db TX_START,"Procedure for Energy Transfer:\n\n"
	db "1. Choose the Pok`mon to move Grass\n"
	db "   Energy from.  Press the A Button.\n\n"
	db "2. Choose the Pok`mon to move the\n"
	db "   energy to and press the A Button.\n\n"
	db "3. Repeat steps 1 and 2.\n\n"
	db "4. Press the B Button to end.",TX_END

Text012e: ; 38b8f (e:4b8f)
	db TX_START,"Choose a Bellsprout\n"
	db "from the Deck.",TX_END

Text012f: ; 38bb3 (e:4bb3)
	db TX_START,"Choose a Bellsprout.",TX_END

Text0130: ; 38bc9 (e:4bc9)
	db TX_START,"Choose a Pok`mon to remove\n"
	db "the Damage counter from.",TX_END

Text0131: ; 38bfe (e:4bfe)
	db TX_START,"Procedure for Curse:\n\n"
	db "1. Choose a Pok`mon to move the\n"
	db "   Damage counter from and press\n"
	db "   the A Button.\n\n"
	db "2. Choose a Pok`mon to move the\n"
	db "   Damage counter to and press\n"
	db "   the A Button.\n\n"
	db "3. Press the B Button to cancel.",TX_END

Text0132: ; 38cda (e:4cda)
	db TX_START,"Choose 2 Energy cards from the\n"
	db "Discard Pileto attach to a Pok`mon.",TX_END

Text0133: ; 38d1e (e:4d1e)
	db TX_START,"Choose 2 Energy cards from the\n"
	db "Discard Pile for your Hand.",TX_END

Text0134: ; 38d5a (e:4d5a)
	db TX_START,"Choose an Energy\n"
	db "card.",TX_END

Text0135: ; 38d72 (e:4d72)
	db TX_START,"Procedure for Prophecy:\n\n"
	db "1. Choose either your Deck\n"
	db "   or your opponent's Deck\n\n"
	db "2. Choose the cards you wish to\n"
	db "   place on top and press the\n"
	db "   A Button.\n\n"
	db "3. Select Yes after you choose\n"
	db "   the 3 cards and their order.\n\n"
	db "4. Press the B Button to cancel.",TX_END

Text0136: ; 38e70 (e:4e70)
	db TX_START,"Choose the order\n"
	db "of the cards.",TX_END

Text0137: ; 38e90 (e:4e90)
	db TX_START,"Procedure for Damage Swap:\n\n"
	db "1. Choose a Pok`mon to move a\n"
	db "   Damage counter from and press\n"
	db "   the A Button.\n\n"
	db "2. Choose a Pok`mon to move the\n"
	db "   Damage counter to and press\n"
	db "   the A Button.\n\n"
	db "3. Repeat steps 1 and 2.\n\n"
	db "4. Press the B Button to end.\n\n"
	db "5. You cannot move the counter if\n"
	db "   it will Knock Out the Pok`mon.",TX_END

Text0138: ; 38fcc (e:4fcc)
	db TX_START,"Procedure for Devolution Beam.\n\n"
	db "1. Choose either a Pok`mon in your\n"
	db "   Play Area or your opponent's\n"
	db "   Play Area and press the A Button.\n\n"
	db "2. Choose the Pok`mon to Devolve\n"
	db "   and press the A Button.\n\n"
	db "3. Press the B Button to cancel.",TX_END

Text0139: ; 390b4 (e:50b4)
	db TX_START,"Procedure for Strange Behavior:\n\n"
	db "1. Choose the Pok`mon with the\n"
	db "   Damage counters to move to\n"
	db "   Slowbro and press the A Button.\n\n"
	db "2. Repeat step 1 as many times as\n"
	db "   you wish to move the counters.\n\n"
	db "3. Press the B Button to end.\n\n"
	db "4. You cannot move the damage if\n"
	db "   Slowbro will be Knocked Out.",TX_END

Text013a: ; 391dc (e:51dc)
	db TX_START,"Choose the opponent's Attack\n"
	db "to be used with Metronome.",TX_END

Text013b: ; 39215 (e:5215)
	db TX_START,"There is no ",TX_RAM2,"\n"
	db "in the Deck.",TX_END

Text013c: ; 39231 (e:5231)
	db TX_START,"Would you like to check the Deck?",TX_END

Text013d: ; 39254 (e:5254)
	db TX_START,"Please select the Deck:\n"
	db "            Yours   Opponent's",TX_END

Text013e: ; 3928c (e:528c)
	db TX_START,"Please select the Play Area:\n"
	db "            Yours   Opponent's",TX_END

Text013f: ; 392c9 (e:52c9)
	db TX_START,"Nidoran$ Nidoran%",TX_END

Text0140: ; 392dc (e:52dc)
	db TX_START,"Oddish",TX_END

Text0141: ; 392e4 (e:52e4)
	db TX_START,"Bellsprout",TX_END

Text0142: ; 392f0 (e:52f0)
	db TX_START,"Krabby",TX_END

Text0143: ; 392f8 (e:52f8)
	db TX_START,"Fighting Pok`mon",TX_END

Text0144: ; 3930a (e:530a)
	db TX_START,"Basic Energy",TX_END

Text0145: ; 39318 (e:5318)
	db TX_START,"Peek was used to look at the\n"
	db TX_RAM2," in your Hand.",TX_END

Text0146: ; 39346 (e:5346)
	db TX_START,"Card Peek was used on",TX_END

Text0147: ; 3935d (e:535d)
	db TX_START,TX_RAM2," and all attached\n"
	db "cards were returned to the Hand.",TX_END

Text0148: ; 39392 (e:5392)
	db TX_START,TX_RAM2," was chosen\n"
	db "for the effect of Amnesia.",TX_END

Text0149: ; 393bb (e:53bb)
	db TX_START,"A Basic Pok`mon was placed\n"
	db "on each Bench.",TX_END

WasUnsuccessful: ; 393e6 (e:53e6)
	db TX_START,TX_RAM2,"'s\n"
	db TX_RAM2," was unsuccessful.",TX_END

Text014b: ; 393ff (e:53ff)
	db TX_START,"There was no effect\n"
	db "from ",TX_RAM2,".",TX_END

Text014c: ; 3941c (e:541c)
	db TX_START,"The Energy card from ",TX_RAM1,"'s\n"
	db "Play Area was moved.",TX_END

Text014d: ; 3944b (e:544b)
	db TX_START,TX_RAM1," drew\n"
	db TX_RAM3," Fire Energy from the Hand.",TX_END

Text014e: ; 39470 (e:5470)
	db TX_START,"The Pok`mon cards in ",TX_RAM1,"'s\n"
	db "Hand and Deck were shuffled",TX_END

Text014f: ; 394a6 (e:54a6)
	db TX_START,"Remove Damage counter each time the\n"
	db "A Button is pressed. B Button quits.",TX_END

Text0150: ; 394f0 (e:54f0)
	db TX_START,"Choose a Pok`mon to remove\n"
	db "the Damage counter from.",TX_END

Text0151: ; 39525 (e:5525)
	db TX_START,"Choose the card to Discard\n"
	db "from the Hand.",TX_END

Text0152: ; 39550 (e:5550)
	db TX_START,"Choose a Pok`mon to remove\n"
	db "Energy from and choose the Energy.",TX_END

Text0153: ; 3958f (e:558f)
	db TX_START,"Choose 2 Basic Energy cards\n"
	db "from the Discard Pile.",TX_END

Text0154: ; 395c3 (e:55c3)
	db TX_START,"Choose a Pok`mon and press the A\n"
	db "Button to remove Damage counters.",TX_END

Text0155: ; 39607 (e:5607)
	db TX_START,"Choose 2 cards from the Hand\n"
	db "to Discard.",TX_END

Text0156: ; 39631 (e:5631)
	db TX_START,"Choose 2 cards from the Hand\n"
	db "to return to the Deck.",TX_END

Text0157: ; 39666 (e:5666)
	db TX_START,"Choose a card to\n"
	db "place in the Hand.",TX_END

Text0158: ; 3968b (e:568b)
	db TX_START,"Choose a Pok`mon to\n"
	db "attach Defender to.",TX_END

Text0159: ; 396b4 (e:56b4)
	db TX_START,"You can draw up to ",TX_RAM3," cards.\n"
	db "A to Draw, B to End.",TX_END

Text015a: ; 396e6 (e:56e6)
	db TX_START,"Choose a Pok`mon to\n"
	db "return to the Deck.",TX_END

Text015b: ; 3970f (e:570f)
	db TX_START,"Choose a Pok`mon to\n"
	db "place in play.",TX_END

Text015c: ; 39733 (e:5733)
	db TX_START,"Choose a Basic Pok`mon\n"
	db "to Evolve.",TX_END

Text015d: ; 39756 (e:5756)
	db TX_START,"Choose a Pok`mon to\n"
	db "Scoop Up.",TX_END

Text015e: ; 39775 (e:5775)
	db TX_START,"Choose a card from your\n"
	db "Hand to Switch.",TX_END

Text015f: ; 3979e (e:579e)
	db TX_START,"Choose a card to\n"
	db "Switch.",TX_END

Text0160: ; 397b8 (e:57b8)
	db TX_START,"Choose a Basic or Evolution\n"
	db "Pok`mon card from the Deck.",TX_END

Text0161: ; 397f1 (e:57f1)
	db TX_START,"Choose\n"
	db "a Pok`mon card.",TX_END

Text0162: ; 39809 (e:5809)
	db TX_START,"Rearrange the 5 cards at\n"
	db "the top of the Deck.",TX_END

Text0163: ; 39838 (e:5838)
	db TX_START,"Please check the opponent's\n"
	db "Hand.",TX_END

Text0164: ; 3985b (e:585b)
	db TX_START,"Evolution card",TX_END

Text0165: ; 3986b (e:586b)
	db TX_START,TX_RAM2," was chosen.",TX_END

Text0166: ; 3987a (e:587a)
	db TX_START,"Choose a Basic Pok`mon\n"
	db "to place on the Bench.",TX_END

Text0167: ; 398a9 (e:58a9)
	db TX_START,"Choose an Evolution card and\n"
	db "press the A Button to Devolve 1.",TX_END

Text0168: ; 398e8 (e:58e8)
	db TX_START,"Choose a Pok`mon in your Area, then\n"
	db "a Pok`mon in your opponent's.",TX_END

Text0169: ; 3992b (e:592b)
	db TX_START,"Choose up to 4\n"
	db "from the Discard Pile.",TX_END

Text016a: ; 39952 (e:5952)
	db TX_START,"Choose a Pok`mon to switch\n"
	db "with the Active Pok`mon.",TX_END

Text016b: ; 39987 (e:5987)
	db TX_START,TX_RAM2," and all attached\n"
	db "cards were returned to the Deck.",TX_END

Text016c: ; 399bc (e:59bc)
	db TX_START,TX_RAM2," was returned\n"
	db "from the Arena to the Hand.",TX_END

Text016d: ; 399e8 (e:59e8)
	db TX_START,TX_RAM2," was returned\n"
	db "from the Bench to the Hand.",TX_END

Text016e: ; 39a14 (e:5a14)
	db TX_START,TX_RAM2," was returned\n"
	db "to the Deck.",TX_END

Text016f: ; 39a31 (e:5a31)
	db TX_START,TX_RAM2," was placed\n"
	db "in the Hand.",TX_END

Text0170: ; 39a4c (e:5a4c)
	db TX_START,"The card you received",TX_END

Text0171: ; 39a63 (e:5a63)
	db TX_START,"You received these cards:",TX_END

Text0172: ; 39a7e (e:5a7e)
	db TX_START,"Choose the card\n"
	db "to put back.",TX_END

Text0173: ; 39a9c (e:5a9c)
	db TX_START,"Choose the card\n"
	db "to Discard.",TX_END

Text0174: ; 39ab9 (e:5ab9)
	db TX_START,"Discarded ",TX_RAM3," cards\n"
	db "from ",TX_RAM1,"'s Deck.",TX_END

Text0175: ; 39adb (e:5adb)
	db TX_START,"Discarded ",TX_RAM2,"\n"
	db "from the Hand.",TX_END

Text0176: ; 39af7 (e:5af7)
	db TX_START,"None came!",TX_END

Text0177: ; 39b03 (e:5b03)
	db TX_START,TX_RAM2,"\n"
	db "came to the Bench!",TX_END

Text0178: ; 39b19 (e:5b19)
	db TX_START,TX_RAM1," has\n"
	db "no cards in Hand!",TX_END

Text0179: ; 39b32 (e:5b32)
	db TX_START,TX_RAM2," healed\n"
	db TX_RAM3," damage!",TX_END

Text017a: ; 39b46 (e:5b46)
	db TX_START,TX_RAM2," devolved\n"
	db "to ",TX_RAM2,"!",TX_END

Text017b: ; 39b58 (e:5b58)
	db TX_START,"There was no Fire Energy.",TX_END

Text017c: ; 39b73 (e:5b73)
	db TX_START,"You can select ",TX_RAM3," more cards. Quit?",TX_END

Text017d: ; 39b97 (e:5b97)
	db TX_START,"There was no effect!",TX_END

Text017e: ; 39bad (e:5bad)
	db TX_START,"There was no effect\n"
	db "from Toxic",TX_END

Text017f: ; 39bcd (e:5bcd)
	db TX_START,"There was no effect\n"
	db "from Poison.",TX_END

Text0180: ; 39bef (e:5bef)
	db TX_START,"There was no effect\n"
	db "from Sleep.",TX_END

Text0181: ; 39c10 (e:5c10)
	db TX_START,"There was no effect\n"
	db "from Paralysis.",TX_END

Text0182: ; 39c35 (e:5c35)
	db TX_START,"There was no effect\n"
	db "from Confusion.",TX_END

Text0183: ; 39c5a (e:5c5a)
	db TX_START,"There was no effet\n"
	db "from Poison, Confusion.",TX_END

Text0184: ; 39c86 (e:5c86)
	db TX_START,"Exchanged the cards\n"
	db "in ",TX_RAM1,"'s Hand.",TX_END

Text0185: ; 39ca8 (e:5ca8)
	db TX_START,"Battle Center",TX_END

Text0186: ; 39cb7 (e:5cb7)
	db TX_START,"Prizes\n"
	db "       cards",TX_END

Text0187: ; 39ccc (e:5ccc)
	db TX_START,"Choose the number\n"
	db "of Prizes.",TX_END

Text0188: ; 39cea (e:5cea)
	db TX_START,"Please wait...\n"
	db "Deciding the number of Prizes...",TX_END

Text0189: ; 39d1b (e:5d1b)
	db TX_START,"Begin a ",TX_RAM3,"-Prize Duel\n"
	db "with ",TX_RAM1,".",TX_END

Text018a: ; 39d39 (e:5d39)
	db TX_START,"Are you both ready\n"
	db "to Card Pop! ?",TX_END

Text018b: ; 39d5c (e:5d5c)
	db TX_START,"The Pop! wasn't successful.\n"
	db "Please try again.",TX_END

Text018c: ; 39d8b (e:5d8b)
	db TX_START,"You cannot Card Pop! with a\n"
	db "friend you previously Popped! with.",TX_END

Text018d: ; 39dcc (e:5dcc)
	db TX_START,"Position the Game Boy Colors\n"
	db "and press the A Button.",TX_END

Text018e: ; 39e02 (e:5e02)
	db TX_START,"Received ",TX_RAM2,"\n"
	db "through Card Pop!",TX_END

ReceivedCard: ; 39e20 (e:5e20)
	db TX_START,TX_RAM1," received\n"
	db "a ",TX_RAM2,"!",TX_END

ReceivedPromotionalCard: ; 39e31 (e:5e31)
	db TX_START,TX_RAM1," received a Promotional\n"
	db "card ",TX_RAM2,"!",TX_END

ReceivedLegendaryCard: ; 39e53 (e:5e53)
	db TX_START,TX_RAM1," received the Legendary\n"
	db "card ",TX_RAM2,"!",TX_END

ReceivedPromotionalFlyingPikachu: ; 39e75 (e:5e75)
	db TX_START,TX_RAM1," received a Promotinal\n"
	db "card Flyin' Pikachu!",TX_END

ReceivedPromotionalSurfingPikachu: ; 39ea3 (e:5ea3)
	db TX_START,TX_RAM1," received a Promotional\n"
	db "card Surfin' Pikachu!",TX_END

Text0194: ; 39ed3 (e:5ed3)
	db TX_START,"Received a Flareon!!!\n"
	db "Looked at the card list!",TX_END

Text0195: ; 39f03 (e:5f03)
	db TX_START,"Now printing.\n"
	db "Please wait...",TX_END

Text0196: ; 39f21 (e:5f21)
	db TX_START,"Booster Pack",TX_END

Text0197: ; 39f2f (e:5f2f)
	db TX_START,"Would you like to try again?",TX_END

Text0198: ; 39f4d (e:5f4d)
	db TX_START,"Sent to ",TX_RAM1,".",TX_END

Text0199: ; 39f59 (e:5f59)
	db TX_START,"Received from ",TX_RAM1,".",TX_END

Text019a: ; 39f6b (e:5f6b)
	db TX_START,"Sending a card...Move the Game\n"
	db "Boys close and press the A Button.",TX_END

Text019b: ; 39fae (e:5fae)
	db TX_START,"Receiving a card...Move\n"
	db "the Game Boys close together.",TX_END

Text019c: ; 39fe5 (e:5fe5)
	db TX_START,"Sending a Deck Configuration...\n"
	db "Position the Game Boys and press A.",TX_END

Text019d: ; 3a02a (e:602a)
	db TX_START,"Receiving Deck configuration...\n"
	db "Position the Game Boys and press A.",TX_END

Text019e: ; 3a06f (e:606f)
	db TX_START,"Card transfer wasn't successful.",TX_END

Text019f: ; 3a091 (e:6091)
	db TX_START,"Card transfer wasn't successful",TX_END

Text01a0: ; 3a0b2 (e:60b2)
	db TX_START,"Deck configuration transfer\n"
	db "wasn't successful",TX_END

Text01a1: ; 3a0e1 (e:60e1)
	db TX_START,"Deck configuration transfer\n"
	db "wasn't successful.",TX_END

Text01a2: ; 3a111 (e:6111)
	db TX_START,"Now printing...",TX_END

Text01a3: ; 3a122 (e:6122)
	db TX_START,"Dr. Mason",TX_END

Text01a4: ; 3a12d (e:612d)
	db TX_START,"Draw 7 cards,\n\n"
	db "and get ready for the battle!\n"
	db "Choose your Active Pok`mon.\n"
	db "You can only choose Basic Pok`mon\n"
	db "as your Active Pok`mon,\n"
	db "so you can choose either Goldeen\n"
	db "or Staryu.\n"
	db "For our practice duel,\n"
	db "choose Goldeen.",TX_END

Text01a5: ; 3a204 (e:6204)
	db TX_START,"Choose Goldeen for this\n"
	db "practice duel, OK?",TX_END

Text01a6: ; 3a230 (e:6230)
	db TX_START,"Next, put your Pok`mon on your\n"
	db "Bench.\n"
	db "You can switch Benched Pok`mon\n"
	db "with your Active Pok`mon.\n"
	db "Again, only Basic Pok`mon can be\n"
	db "placed on your Bench.\n"
	db "Choose Staryu from your hand and\n"
	db "put it there.",TX_END

Text01a7: ; 3a2f6 (e:62f6)
	db TX_START,"Choose Staryu for this\n"
	db "practice duel, OK?",TX_END

Text01a8: ; 3a321 (e:6321)
	db TX_START,"When you have no Pok`mon to put on\n"
	db "your Bench, press the B Button to\n"
	db "finish.",TX_END

Text01a9: ; 3a36f (e:636f)
	db TX_START,"1. Choose Hand from the Menu.\n"
	db "   Select a Water Energy card.",TX_END

Text01aa: ; 3a3ad (e:63ad)
	db TX_START,"2. Attach a Water Energy card to\n"
	db "   your Active Pok`mon, Goldeen.",TX_END

Text01ab: ; 3a3f0 (e:63f0)
	db TX_START,"3. Choose Attack from the Menu\n"
	db "   and select Horn Attack.",TX_END

Text01ac: ; 3a42b (e:642b)
	db TX_START,"1. Evolve Goldeen by\n"
	db "   attaching Seaking to it.",TX_END

Text01ad: ; 3a45d (e:645d)
	db TX_START,"2. Attach a Psychic Energy card\n"
	db "   to the evolved Seaking.",TX_END

Text01ae: ; 3a499 (e:6499)
	db TX_START,"3. Choose Attack and select\n"
	db "   Waterfall to attack your\n"
	db "   opponent.",TX_END

Text01af: ; 3a4df (e:64df)
	db TX_START,"1. Attach a Water Energy card to\n"
	db "   your Benched Staryu.",TX_END

Text01b0: ; 3a519 (e:6519)
	db TX_START,"2. Choose Attack and attack your\n"
	db "   opponent with Horn Attack.",TX_END

Text01b1: ; 3a559 (e:6559)
	db TX_END

Text01b2: ; 3a55a (e:655a)
	db TX_START,"1. Take Drowzee from your hand\n"
	db "   and put it on your Bench.",TX_END

Text01b3: ; 3a597 (e:6597)
	db TX_START,"2. Attach a Water Energy card to\n"
	db "   your Benched Drowzee.",TX_END

Text01b4: ; 3a5d2 (e:65d2)
	db TX_START,"3. Choose Seaking and attack your\n"
	db "   opponent with Waterfall.",TX_END

Text01b5: ; 3a611 (e:6611)
	db TX_START,"1. Choose a Water Energy card from\n"
	db "   your hand and attach it to\n"
	db "   Staryu.",TX_END

Text01b6: ; 3a65e (e:665e)
	db TX_START,"2. Choose Staryu and attack your\n"
	db "   opponent with Slap.",TX_END

Text01b7: ; 3a697 (e:6697)
	db TX_START,"1. Choose the Potion card in your\n"
	db "   hand to recover Staryu's HP.",TX_END

Text01b8: ; 3a6da (e:66da)
	db TX_START,"2. Attach a Water Energy card to\n"
	db "   Staryu.",TX_END

Text01b9: ; 3a707 (e:6707)
	db TX_START,"3. Choose Staryu and attack your\n"
	db "   opponent with Slap.",TX_END

Text01ba: ; 3a740 (e:6740)
	db TX_START,"1. Evolve Staryu by\n"
	db "   attaching Starmie to it.",TX_END

Text01bb: ; 3a771 (e:6771)
	db TX_START,"2. Select the evolved Starmie and\n"
	db "   attack your opponent with Star \n"
	db "   Freeze.",TX_END

Text01bc: ; 3a7c2 (e:67c2)
	db TX_START,"1. Select Starmie and attack your\n"
	db "   opponent with Star Freeze.",TX_END

Text01bd: ; 3a803 (e:6803)
	db TX_START,"2. You Knocked Machop Out.\n"
	db "   Now you can draw a Prize.",TX_END

Text01be: ; 3a83c (e:683c)
	db TX_START,"1. Your Seaking was Knocked Out.\n"
	db "   Choose your Benched Staryu\n"
	db "   and press the A Button to set\n"
	db "   it as your Active Pok`mon.",TX_END

Text01bf: ; 3a8bb (e:68bb)
	db TX_START,"2. You can check Pok`mon data by\n"
	db "   pressing SELECT.",TX_END

Text01c0: ; 3a8f1 (e:68f1)
	db TX_START,"To use the attack command, you need\n"
	db "to attach Energy cards to your\n"
	db "Pok`mon.\n\n"
	db "Choose Cards from the Menu, and\n"
	db "select a Water Energy card.",TX_END

Text01c1: ; 3a97b (e:697b)
	db TX_START,"Next, choose your Active Pok`mon,\n"
	db "Goldeen, and press the A Button.\n"
	db "Then the Water Energy card will\n"
	db "be attached to Goldeen.",TX_END

Text01c2: ; 3a9f7 (e:69f7)
	db TX_START,"Finally, attack your opponent by\n"
	db "selecting an attack command.\n"
	db "Choose Attack from the Menu, and\n"
	db "select Horn Attack.",TX_END

Text01c3: ; 3aa6b (e:6a6b)
	db TX_START,"Your Goldeen's gonna get Knocked\n"
	db "Out. Let's evolve it!\n"
	db "Choose Seaking from your hand and\n"
	db "attach it to Goldeen to\n"
	db "Evolve it.\n"
	db "Its HP increases from 40 to 70.",TX_END

Text01c4: ; 3ab08 (e:6b08)
	db TX_START,"Your Seaking doesn't have enough\n"
	db "Energy to use Waterfall.\n"
	db "You need to attach a Psychic Energy\n"
	db "card to Seaking.\n"
	db TX_COLORLESS," means any Energy card.\n"
	db "Now you can use Waterfall.\n"
	db "Keep the Water Energy card for\n"
	db "other Pok`mon.",TX_END

Text01c5: ; 3abdb (e:6bdb)
	db TX_START,"Now let's attack your opponent with\n"
	db "Seaking's Waterfall!",TX_END

Text01c6: ; 3ac15 (e:6c15)
	db TX_START,"Seaking's got enough Energy, so\n"
	db "you don't need to attach any more.\n"
	db "Attach Energy cards to your Benched\n"
	db "Pok`mon to get them ready for\n"
	db "battle.\n\n"
	db "Attach a Water Energy card to your\n"
	db "Benched Staryu.",TX_END

Text01c7: ; 3acd7 (e:6cd7)
	db TX_START,"Next, select the attack command.\n"
	db "Machop has 10 HP left.\n"
	db "Seaking's Horn Attack will be\n"
	db "enough to Knock out Machop.\n"
	db "Now, choose Seaking's\n"
	db "Horn Attack.",TX_END

Text01c8: ; 3ad6d (e:6d6d)
	db TX_START,"Now Machop's HP is 0 and it is\n"
	db "Knocked Out.\n"
	db "When you Knock Out the Defending\n"
	db "Pok`mon, you can pick up a\n"
	db "Prize.",TX_END

Text01c9: ; 3addd (e:6ddd)
	db TX_START,"When all your Pok`mon are Knocked\n"
	db "Out and there are no Pok`mon on your\n"
	db "Bench, you lose the game.\n\n"
	db "Put Drowzee, the Basic Pok`mon\n"
	db "you just drew, on your Bench.",TX_END

Text01ca: ; 3ae7d (e:6e7d)
	db TX_START,"Attach a Water Energy card to\n"
	db "Drowzee to get it ready to\n"
	db "attack.",TX_END

Text01cb: ; 3aebf (e:6ebf)
	db TX_START,"Choose your Active Seaking and\n"
	db "attack your opponent with\n"
	db "Waterfall.",TX_END

Text01cc: ; 3af04 (e:6f04)
	db TX_START,"Staryu evolves into Starmie!\n\n"
	db "Let's get Staryu ready to use\n"
	db "Starmie's attack command when it\n"
	db "evolves to Starmie.\n\n"
	db "Choose the Water Energy card from\n"
	db "your hand and attach it to Staryu.",TX_END

Text01cd: ; 3afbc (e:6fbc)
	db TX_START,"Attack your opponent with Staryu's\n"
	db "Slap.",TX_END

Text01ce: ; 3afe6 (e:6fe6)
	db TX_START,"Now, recover Staryu with a Trainer\n"
	db "card.\n"
	db "Choose Potion from your hand.",TX_END

Text01cf: ; 3b02e (e:702e)
	db TX_START,"Now let's get ready to evolve\n"
	db "it to Starmie.\n"
	db "Also, attach a Water Energy card to\n"
	db "Staryu.",TX_END

Text01d0: ; 3b088 (e:7088)
	db TX_START,"Attack your opponent with Staryu's\n"
	db "Slap to end your turn.",TX_END

Text01d1: ; 3b0c3 (e:70c3)
	db TX_START,"Now you have finally drawn a\n"
	db "Starmie card!\n"
	db "Choose Starmie from your hand and\n"
	db "use it to evolve Staryu.",TX_END

Text01d2: ; 3b12a (e:712a)
	db TX_START,"You've already attached enough\n"
	db "Energy to use Star Freeze.\n"
	db "Attack your opponent with\n"
	db "Starmie's Star Freeze.",TX_END

Text01d3: ; 3b196 (e:7196)
	db TX_START,"Now Machop has only 10 HP left.\n"
	db "Let's finish the battle!\n"
	db "Attack with Starmie's Star Freeze.\n"
	db TX_END

Text01d4: ; 3b1f4 (e:71f4)
	db TX_START,"You've Knocked Out your opponent!\n\n"
	db "Pick up the last Prize.\n"
	db TX_START,TX_RAM1," is the winner!",TX_END

Text01d5: ; 3b242 (e:7242)
	db TX_START,"Choose a Benched Pok`mon to replace\n"
	db "your Knocked Out Pok`mon.\n"
	db "You now have Drowzee and Staryu\n"
	db "on your Bench.\n"
	db "Choose Staryu as the Active Pok`mon\n"
	db "for this practice duel.",TX_END

Text01d6: ; 3b2ec (e:72ec)
	db TX_START,"Here, press SELECT to\n"
	db "check Pok`mon data.\n"
	db "It is important to know your cards\n"
	db "and the status of your Pok`mon.",TX_END

Text01d7: ; 3b35a (e:735a)
	db TX_START,"Select Staryu for this practice,\n"
	db "OK?",TX_END

Text01d8: ; 3b380 (e:7380)
	db TX_START,"Now, let's play the game!",TX_END

Text01d9: ; 3b39b (e:739b)
	db TX_START,"Do you need to practice again?",TX_END

Text01da: ; 3b3bb (e:73bb)
	db TX_START,"This is Practice Mode, so\n"
	db "please follow my guidance.\n"
	db "Do it again.",TX_END

Text01db: ; 3b3fe (e:73fe)
	db TX_START,TX_RAM1,"'s turn ",TX_RAM3,TX_END

Text01dc: ; 3b40a (e:740a)
	db TX_START," Replace due to Knockout ",TX_END

Text01dd: ; 3b425 (e:7425)
	db TX_START,"Dummy",TX_END

PracticePlayerDeckName: ; 3b42c (e:742c)
	db TX_START,"Practice Player",TX_END

SamsPracticeDeckName: ; 3b43d (e:743d)
	db TX_START,"Sam's Practice",TX_END

CharmanderAndFriendsDeckName: ; 3b44d (e:744d)
	db TX_START,"Charmander & Friends",TX_END

CharmanderExtraDeckName: ; 3b463 (e:7463)
	db TX_START,"Charmander extra",TX_END

SquirtleAndFriendsDeckName: ; 3b475 (e:7475)
	db TX_START,"Squirtle & Friends",TX_END

SquirtleExtraDeckName: ; 3b489 (e:7489)
	db TX_START,"Squirtle extra",TX_END

BulbasaurAndFriendsDeckName: ; 3b499 (e:7499)
	db TX_START,"Bulbasaur & Friends",TX_END

BulbasaurExtraDeckName: ; 3b4ae (e:74ae)
	db TX_START,"Bulbasaur extra",TX_END

FirstStrikeDeckName: ; 3b4bf (e:74bf)
	db TX_START,"First-Strike",TX_END

RockCrusherDeckName: ; 3b4cd (e:74cd)
	db TX_START,"Rock Crusher",TX_END

GoGoRainDanceDeckName: ; 3b4db (e:74db)
	db TX_START,"Go Go Rain Dance",TX_END

ZappingSelfdestructDeckName: ; 3b4ed (e:74ed)
	db TX_START,"Zapping Selfdestruct",TX_END

FlowerPowerDeckName: ; 3b503 (e:7503)
	db TX_START,"Flower Power",TX_END

StrangePsyshockDeckName: ; 3b511 (e:7511)
	db TX_START,"Strange Psyshock",TX_END

WondersofScienceDeckName: ; 3b523 (e:7523)
	db TX_START,"Wonders of Science",TX_END

FireChargeDeckName: ; 3b537 (e:7537)
	db TX_START,"Fire Charge",TX_END

LegendaryMoltresDeckName: ; 3b544 (e:7544)
	db TX_START,"Legendary Moltres",TX_END

LegendaryZapdosDeckName: ; 3b557 (e:7557)
	db TX_START,"Legendary Zapdos",TX_END

LegendaryArticunoDeckName: ; 3b569 (e:7569)
	db TX_START,"Legendary Articuno",TX_END

LegendaryDragoniteDeckName: ; 3b57d (e:757d)
	db TX_START,"Legendary Dragonite",TX_END

ImRonaldDeckName: ; 3b592 (e:7592)
	db TX_START,"I'm Ronald!",TX_END

PowerfulRonaldDeckName: ; 3b59f (e:759f)
	db TX_START,"Powerful Ronald",TX_END

InvincibleRonaldDeckName: ; 3b5b0 (e:75b0)
	db TX_START,"Invincible Ronald",TX_END

LegendaryRonaldDeckName: ; 3b5c3 (e:75c3)
	db TX_START,"Legendary Ronald",TX_END

WaterfrontPokemonDeckName: ; 3b5d5 (e:75d5)
	db TX_START,"Waterfront Pok`mon",TX_END

LonelyFriendsDeckName: ; 3b5e9 (e:75e9)
	db TX_START,"Lonely Friends",TX_END

SoundoftheWavesDeckName: ; 3b5f9 (e:75f9)
	db TX_START,"Sound of the Waves",TX_END

AngerDeckName: ; 3b60d (e:760d)
	db TX_START,"Anger",TX_END

FlamethrowerDeckName: ; 3b614 (e:7614)
	db TX_START,"Flamethrower",TX_END

ReshuffleDeckName: ; 3b622 (e:7622)
	db TX_START,"Reshuffle",TX_END

ExcavationDeckName: ; 3b62d (e:762d)
	db TX_START,"Excavation",TX_END

BlisteringPokemonDeckName: ; 3b639 (e:7639)
	db TX_START,"Blistering Pok`mon",TX_END

HardPokemonDeckName: ; 3b64d (e:764d)
	db TX_START,"Hard Pok`mon",TX_END

EtceteraDeckName: ; 3b65b (e:765b)
	db TX_START,"Etcetera",TX_END

FlowerGardenDeckName: ; 3b665 (e:7665)
	db TX_START,"Flower Garden",TX_END

KaleidoscopeDeckName: ; 3b674 (e:7674)
	db TX_START,"Kaleidoscope",TX_END

MusclesforBrainsDeckName: ; 3b682 (e:7682)
	db TX_START,"Muscles for Brains",TX_END

HeatedBattleDeckName: ; 3b696 (e:7696)
	db TX_START,"Heated Battle",TX_END

LovetoBattleDeckName: ; 3b6a5 (e:76a5)
	db TX_START,"Love to Battle",TX_END

PikachuDeckName: ; 3b6b5 (e:76b5)
	db TX_START,"Pikachu",TX_END

BoomBoomSelfdestructDeckName: ; 3b6be (e:76be)
	db TX_START,"Boom Boom Selfdestruct",TX_END

PowerGeneratorDeckName: ; 3b6d6 (e:76d6)
	db TX_START,"Power Generator",TX_END

GhostDeckName: ; 3b6e7 (e:76e7)
	db TX_START,"Ghost",TX_END

NapTimeDeckName: ; 3b6ee (e:76ee)
	db TX_START,"Nap Time",TX_END

StrangePowerDeckName: ; 3b6f8 (e:76f8)
	db TX_START,"Strange Power",TX_END

FlyinPokemonDeckName: ; 3b707 (e:7707)
	db TX_START,"Flyin' Pok`mon",TX_END

LovelyNidoranDeckName: ; 3b717 (e:7717)
	db TX_START,"Lovely Nidoran",TX_END

PoisonDeckName: ; 3b727 (e:7727)
	db TX_START,"Poison",TX_END

ImakuniDeckName: ; 3b72f (e:772f)
	db TX_START,"Imakuni?",TX_END

LightningAndFireDeckName: ; 3b739 (e:7739)
	db TX_START,"Lightning & Fire",TX_END

WaterAndFightingDeckName: ; 3b74b (e:774b)
	db TX_START,"Water & Fighting",TX_END

GrassAndPsychicDeckName: ; 3b75d (e:775d)
	db TX_START,"Grass & Psychic",TX_END

Text0212: ; 3b76e (e:776e)
	db TX_START,"Retreat Cost",TX_END

Text0213: ; 3b77c (e:777c)
	db $03,$42,$03,$46,$03,$38,$03,$43,$03,$32,$03,$37,$70,$03,$43,$03,$3e,$70,$03,$44,$03,$3f,$03,$3f,$03,$34,$03,$41,TX_END

Text0214: ; 3b799 (e:7799)
	db $03,$42,$03,$46,$03,$38,$03,$43,$03,$32,$03,$37,$70,$03,$43,$03,$3e,$70,$03,$3b,$03,$3e,$03,$46,$03,$34,$03,$41,TX_END

Text0215: ; 3b7b6 (e:77b6)
	db $03,$7a,TX_END

Text0216: ; 3b7b9 (e:77b9)
	db $03,$7b,TX_END

Text0217: ; 3b7bc (e:77bc)
	db TX_START,"Your Discard Pile",TX_END

Text0218: ; 3b7cf (e:77cf)
	db TX_START,"Opponent's Discard Pile",TX_END

Text0219: ; 3b7e8 (e:77e8)
	db TX_START,"Deck",TX_END

Text021a: ; 3b7ee (e:77ee)
	db $0e,$2b,$37,$3e,$25,TX_END

Text021b: ; 3b7f4 (e:77f4)
	db $16,$20,$16,$25,TX_END

Text021c: ; 3b7f9 (e:77f9)
	db $03,$30,$03,$31,$03,$32,TX_END

Text021d: ; 3b800 (e:7800)
	db TX_START,"End",TX_END

Text021e: ; 3b805 (e:7805)
	db TX_START,"What is your name?",TX_END

Text021f: ; 3b819 (e:7819)
	db $0e,$11,$70,$16,$70,$1b,$70,$20,$70,$25,$70,$2a,$70,$2f,$70,$34,$70,$37,"\n"
	db $12,$70,$17,$70,$1c,$70,$21,$70,$26,$70,$2b,$70,$30,$70,$35,$70,$38,"\n"
	db $13,$70,$18,$70,$1d,$70,$22,$70,$27,$70,$2c,$70,$31,$70,$36,$70,$39,"\n"
	db $14,$70,$19,$70,$1e,$70,$23,$70,$28,$70,$2d,$70,$32,$70,$3c,$70,$3a,"\n"
	db $15,$70,$1a,$70,$1f,$70,$24,$70,$29,$70,$2e,$70,$33,$70,$3d,$70,$3b,"\n"
	db $5c,$70,$5d,$70,$5e,$70,$5f,$70,$10,$70,$03,$59,$70,$03,$5b,$70,$78,TX_END

Text0220: ; 3b886 (e:7886)
	db $11,$70,$16,$70,$1b,$70,$20,$70,$25,$70,$2a,$70,$2f,$70,$34,$70,$37,"\n"
	db $12,$70,$17,$70,$1c,$70,$21,$70,$26,$70,$2b,$70,$30,$70,$35,$70,$38,"\n"
	db $13,$70,$18,$70,$1d,$70,$22,$70,$27,$70,$2c,$70,$31,$70,$36,$70,$39,"\n"
	db $14,$70,$19,$70,$1e,$70,$23,$70,$28,$70,$2d,$70,$32,$70,$3c,$70,$3a,"\n"
	db $15,$70,$1a,$70,$1f,$70,$24,$70,$29,$70,$2e,$70,$33,$70,$3d,$70,$3b,"\n"
	db $5c,$70,$5d,$70,$5e,$70,$5f,$70,$10,$70,$03,$59,$70,$03,$5b,$70,$78,TX_END

Text0221: ; 3b8f2 (e:78f2)
	db $03,$30,$70,$03,$31,$70,$03,$32,$70,$03,$33,$70,$03,$34,$70,$03,$35,$70,$03,$36,$70,$03,$37,$70,$03,$38,"\n"
	db $03,$39,$70,$03,$3a,$70,$03,$3b,$70,$03,$3c,$70,$03,$3d,$70,$03,$3e,$70,$03,$3f,$70,$03,$40,$70,$03,$41,"\n"
	db $03,$42,$70,$03,$43,$70,$03,$44,$70,$03,$45,$70,$03,$46,$70,$03,$47,$70,$03,$48,$70,$03,$49,$70,$6e,"\n"
	db $6f,$70,$03,$5d,$70,$6a,$70,$6b,$70,$77,$70,$60,$70,$61,$70,$62,$70,$63,"\n"
	db $64,$70,$65,$70,$66,$70,$67,$70,$68,$70,$69,$70,$05,$13,$70,TX_LVL,$70,$70,"\n"
	db $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,TX_END

Text0222: ; 3b97b (e:797b)
	db $03,$30,$70,$03,$31,$70,$03,$32,$70,$03,$33,$70,$03,$34,$70,$03,$35,$70,$03,$36,$70,$03,$37,$70,$03,$38,"\n"
	db $03,$39,$70,$03,$3a,$70,$03,$3b,$70,$03,$3c,$70,$03,$3d,$70,$03,$3e,$70,$03,$3f,$70,$03,$40,$70,$03,$41,"\n"
	db $03,$42,$70,$03,$43,$70,$03,$44,$70,$03,$45,$70,$03,$46,$70,$03,$47,$70,$03,$48,$70,$03,$49,$70,$6e,"\n"
	db $6f,$70,$03,$5d,$70,$6a,$70,$6b,$70,$03,$7a,$70,$60,$70,$61,$70,$62,$70,$63,"\n"
	db $64,$70,$65,$70,$66,$70,$67,$70,$68,$70,$69,$70,$70,$70,$70,$70,$70,"\n"
	db $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,TX_END

NewDeck: ; 3ba03 (e:7a03)
	db TX_START,"New deck",TX_END

PleaseSelectDeck: ; 3ba0d (e:7a0d)
	db TX_START,"Please select deck.",TX_END

Text0225: ; 3ba22 (e:7a22)
	db TX_START,"Modify deck",TX_END

Text0226: ; 3ba2f (e:7a2f)
	db TX_START,"Change name",TX_END

Text0227: ; 3ba3c (e:7a3c)
	db TX_START,"Select deck",TX_END

Text0228: ; 3ba49 (e:7a49)
	db TX_START,"Cancel",TX_END

Text0229: ; 3ba51 (e:7a51)
	db TX_START,"as",TX_END

ChosenAsDuelingDeck: ; 3ba55 (e:7a55)
	db TX_START,TX_RAM2," was\n"
	db "chosen as the dueling deck!",TX_END

Text022b: ; 3ba78 (e:7a78)
	db $61,$77,TX_END

Text022c: ; 3ba7b (e:7a7b)
	db $62,$77,TX_END

Text022d: ; 3ba7e (e:7a7e)
	db $63,$77,TX_END

Text022e: ; 3ba81 (e:7a81)
	db $64,$77,TX_END

ThereIsNoDeckHere: ; 3ba84 (e:7a84)
	db TX_START,"There is no Deck here!",TX_END

Text0230: ; 3ba9c (e:7a9c)
	db TX_START,"Confirm",TX_END

Text0231: ; 3baa5 (e:7aa5)
	db TX_START,"Dismantle",TX_END

Text0232: ; 3bab0 (e:7ab0)
	db TX_START,"Modify",TX_END

Text0233: ; 3bab8 (e:7ab8)
	db TX_START,"Save",TX_END

Text0234: ; 3babe (e:7abe)
	db TX_START,"Name",TX_END

Text0235: ; 3bac4 (e:7ac4)
	db TX_START,"There is only 1 Deck, so this\n"
	db "Deck cannot be dismantled.",TX_END

Text0236: ; 3bafe (e:7afe)
	db TX_START,"There are no Basic Pok`mon\n"
	db "in this Deck!",TX_END

Text0237: ; 3bb28 (e:7b28)
	db TX_START,"You must include a Basic Pok`mon\n"
	db "in the Deck!",TX_END

Text0238: ; 3bb57 (e:7b57)
	db TX_START,"This isn't a 60-card deck!",TX_END

Text0239: ; 3bb73 (e:7b73)
	db TX_START,"The Deck must include 60 cards!",TX_END

Text023a: ; 3bb94 (e:7b94)
	db TX_START,"Return to original configuration?",TX_END

Text023b: ; 3bbb7 (e:7bb7)
	db TX_START,"Save this Deck?",TX_END

Text023c: ; 3bbc8 (e:7bc8)
	db TX_START,"Quit modifying the Deck?",TX_END

Text023d: ; 3bbe2 (e:7be2)
	db TX_START,"Dismantle this Deck?",TX_END

Text023e: ; 3bbf8 (e:7bf8)
	db TX_START,"No cards chosen.",TX_END

Text023f: ; 3bc0a (e:7c0a)
	db TX_START,"Your Pok`mon",TX_END

Text0240: ; 3bc18 (e:7c18)
	db TX_START,"Your Discard Pile",TX_END

Text0241: ; 3bc2b (e:7c2b)
	db TX_START,"Your Hand",TX_END

Text0242: ; 3bc36 (e:7c36)
	db TX_START,"To Your Play Area",TX_END

Text0243: ; 3bc49 (e:7c49)
	db TX_START,"Opponent's Pok`mon",TX_END

Text0244: ; 3bc5d (e:7c5d)
	db TX_START,"Opponent's Discard Pile",TX_END

Text0245: ; 3bc76 (e:7c76)
	db TX_START,"Opponent Hand",TX_END

Text0246: ; 3bc85 (e:7c85)
	db TX_START,"To Opponent's Play Area",TX_END

Text0247: ; 3bc9e (e:7c9e)
	db TX_START,TX_RAM1,"'s Play Area",TX_END

Text0248: ; 3bcad (e:7cad)
	db TX_START,"Your Play Area",TX_END

Text0249: ; 3bcbd (e:7cbd)
	db TX_START,"Opp. Play Area",TX_END

Text024a: ; 3bccd (e:7ccd)
	db TX_START,"In Play Area",TX_END

Text024b: ; 3bcdb (e:7cdb)
	db TX_START,"Glossary",TX_END

Text024c: ; 3bce5 (e:7ce5)
	db TX_START,"Which card would you like to see?",TX_END

Text024d: ; 3bd08 (e:7d08)
	db TX_START,"Please choose a Prize.",TX_END

Text024e: ; 3bd20 (e:7d20)
	db TX_START,"Hand",TX_END

Text024f: ; 3bd26 (e:7d26)
	db TX_START,TX_RAM1,"'s Hand",TX_END

Text0250: ; 3bd30 (e:7d30)
	db TX_START,TX_RAM1,"'s Discard Pile",TX_END

Text0251: ; 3bd42 (e:7d42)
	db $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,TX_END

Text0252: ; 3bd55 (e:7d55)
	db TX_START,"Booster Pack",TX_END

Text0253: ; 3bd63 (e:7d63)
	db TX_START,"1. Colosseum",TX_END

Text0254: ; 3bd71 (e:7d71)
	db TX_START,"2. Evolution",TX_END

Text0255: ; 3bd7f (e:7d7f)
	db TX_START,"3. Mystery",TX_END

Text0256: ; 3bd8b (e:7d8b)
	db TX_START,"4. Laboratory",TX_END

Text0257: ; 3bd9a (e:7d9a)
	db TX_START,"5. Promotional Card",TX_END

Text0258: ; 3bdaf (e:7daf)
	db TX_START,"View which Card File?",TX_END

Text0259: ; 3bdc6 (e:7dc6)
	db $6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,TX_END

Text025a: ; 3bdd1 (e:7dd1)
	db TX_START,"'s Cards",TX_END

Text025b: ; 3bddb (e:7ddb)
	db $6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,$6b,TX_END

Text025c: ; 3bdea (e:7dea)
	db TX_START,"  Deck Save Machine   ",TX_END

Text025d: ; 3be02 (e:7e02)
	db TX_START,"Save a Deck",TX_END

Text025e: ; 3be0f (e:7e0f)
	db TX_START,"Delete a Deck",TX_END

Text025f: ; 3be1e (e:7e1e)
	db TX_START,"Build a Deck",TX_END

Text0260: ; 3be2c (e:7e2c)
	db TX_START,"Choose a Deck to Save.",TX_END

Text0261: ; 3be44 (e:7e44)
	db TX_START,"You may only Save 60 Decks.\n"
	db "Please Delete a Deck first.",TX_END

Text0262: ; 3be7d (e:7e7d)
	db TX_START,"for",TX_END

Text0263: ; 3be82 (e:7e82)
	db TX_START,"Saved the configuration for\n"
	db TX_START,TX_RAM2,"! ",TX_END

Text0264: ; 3bea4 (e:7ea4)
	db TX_START,"No Deck is saved.",TX_END

Text0265: ; 3beb7 (e:7eb7)
	db TX_START,"Please choose a Deck \n"
	db "configuration to delete.",TX_END

Text0266: ; 3bee7 (e:7ee7)
	db TX_START,"Do you really wish to delete?",TX_END

Text0267: ; 3bf06 (e:7f06)
	db TX_START,"Deleted the configuration for\n"
	db TX_START,TX_RAM2,".",TX_END

Text0268: ; 3bf29 (e:7f29)
	db TX_START,"You may only carry 4 Decks!",TX_END

Text0269: ; 3bf46 (e:7f46)
	db TX_START,"Choose a deck to dismantle.",TX_END

Text026a: ; 3bf63 (e:7f63)
	db TX_START,"Dismantled\n"
	db TX_START,TX_RAM2,".",TX_END

Text026b: ; 3bf73 (e:7f73)
	db TX_START,"Please choose the Deck\n"
	db "you wish to Build.",TX_END

Text026c: ; 3bf9e (e:7f9e)
	db TX_START,"This Deck can only be built if\n"
	db "you dismantle another Deck.",TX_END
