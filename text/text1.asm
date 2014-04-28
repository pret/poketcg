	db TX_START,"Hand",TX_END

	db TX_START,"Check",TX_END

	db TX_START,"Attack",TX_END

	db TX_START,"PKMN Power",TX_END

	db TX_START,"Done",TX_END

	db TX_START,"Type",TX_END

	db TX_START,"Retreat",TX_END

	db TX_START,"Weakness",TX_END

	db TX_START,"Resistance",TX_END

	db TX_START,"PKMN PWR",TX_END

	db $56,$19,$33,$3D,$16,$78,$4C,TX_END

	db TX_START,"Length",TX_END

	db TX_START,"Weight",TX_END

	db TX_START," Pok`mon",TX_END

	db $03,$4c,TX_END

	db TX_START,"lbs.",TX_END

	db $70,TX_END

	db $03,$52,TX_END

	db $03,$53,TX_END

	db $03,$54,TX_END

	db TX_START," All cards owned:",TX_END

	db TX_START,"Total number of cards",TX_END

	db TX_START,"Types of cards",TX_END

	db TX_START,"Grass Pok`mon",TX_END

	db TX_START,"Fire Pok`mon",TX_END

	db TX_START,"Water Pok`mon",TX_END

	db TX_START,"Lightning Pok`mon",TX_END

	db TX_START,"Fighting Pok`mon",TX_END

	db TX_START,"Psychic Pok`mon",TX_END

	db TX_START,"Colorless Pok`mon",TX_END

	db TX_START,"Trainer Card",TX_END

	db TX_START,"Energy Card",TX_END

	db TX_START,"Deck",TX_END

	db TX_START,"Attack",TX_END

	db TX_START,"No Pok`mon on the Bench.",TX_END

	db TX_START,"Unable to due to Sleep.",TX_END

	db TX_START,"Unable to due to Paralysis.",TX_END

	db TX_START,TX_RAM2," received\n"
	db "10 damage due to Poison.",TX_END

	db TX_START,TX_RAM2," received\n"
	db "20 damage due to Double Poison.",TX_END

	db TX_START,TX_RAM2," is\n"
	db "still Asleep.",TX_END

	db TX_START,TX_RAM2," is\n"
	db "cured of Sleep.",TX_END

	db TX_START,TX_RAM2," is\n"
	db "cured of Paralysis.",TX_END

	db TX_START,"Between Turns.",TX_END

	db TX_START,"Unable to use it.",TX_END

	db TX_START,"No Energy cards.",TX_END

	db TX_START,"Is this OK?",TX_END

	db TX_START,"Yes     No",TX_END

	db TX_START,"Discard",TX_END

	db TX_START,"Incomplete",TX_END

	db TX_START,"Damage",TX_END

	db TX_START,"Used ",TX_RAM2,".",TX_END

	db TX_START,"Received damage",TX_END

	db TX_START,TX_RAM2,"'s\n"
	db TX_START,TX_RAM2,"!",TX_END

	db TX_START,TX_RAM2," received\n"
	db TX_RAM3," damage due to Resistance!",TX_END

	db TX_START,TX_RAM2," received\n"
	db TX_RAM3," damage due to Weakness!",TX_END

	db TX_START,TX_RAM2," received\n"
	db TX_RAM3," damage due to Weakness!",TX_END

	db TX_START,TX_RAM2," did not\n"
	db "receive damage due to Resistance.",TX_END

	db TX_START,TX_RAM2," took\n"
	db TX_RAM3," damage.",TX_END

	db TX_START,TX_RAM2," did not\n"
	db "receive damage!",TX_END

	db TX_START,"No selectable Attack",TX_END

	db TX_START,"Unable to Retreat.",TX_END

	db TX_START,"You may only attach 1 Energy card\n"
	db "per turn.",TX_END

	db TX_START,"Use this Pok`mon Power?",TX_END

	db TX_START,"You do not need to select the\n"
	db "Pok`mon Power to use it.",TX_END

	db TX_START,"You may discard this card during\n"
	db "your turn.\n"
	db "It will be counted as a Knock Out\n"
	db "(This Discard is not\n"
	db "a Pok`mon Power)",TX_END

	db TX_START,TX_RAM1," will draw ",TX_RAM3," Prize(s).",TX_END

	db TX_START,TX_RAM1," drew ",TX_RAM3," Prize(s).",TX_END

	db TX_START,TX_RAM1," placed\n"
	db "a ",TX_RAM2,".",TX_END

	db TX_START,"Unable to select.",TX_END

	db TX_START,"Grass\n"
	db "Fire\n"
	db "Water\n"
	db "Lightning\n"
	db "Fighting\n"
	db "Psychic",TX_END

	db TX_GRASS,TX_END

	db TX_FIRE,TX_END

	db TX_WATER,TX_END

	db TX_LIGHTNING,TX_END

	db TX_FIGHTING,TX_END

	db TX_PSYCHIC,TX_END

	db TX_START,"Bench",TX_END

	db TX_START,"Knock Out",TX_END

	db TX_START,"20 damage to Self due to Confusion.",TX_END

	db TX_START,"Choose the Energy card\n"
	db "you wish to discard.",TX_END

	db TX_START,"The Active Pok`mon was Knocked Out.\n"
	db "Please choose the next Pok`mon.",TX_END

	db TX_START,"Press START\n"
	db "When you are ready.",TX_END

	db TX_START,"You play first.",TX_END

	db TX_START,"You play second.",TX_END

	db TX_START,"Transmission Error.\n"
	db "Start again from the beginning.",TX_END

	db TX_START,"Choose the card\n"
	db "you wish to examine.",TX_END

	db TX_START,"Transmitting data...",TX_END

	db TX_START,"Waiting...\n"
	db "    Hand        Examine",TX_END

	db TX_START,"Selecting Bench Pok`mon...\n"
	db "    Hand        Examine     Back",TX_END

	db TX_START,TX_RAM2,"\n"
	db "Retreated to the Bench.",TX_END

	db TX_START,TX_RAM2,"'s\n"
	db "Retreat was unsuccessful.",TX_END

	db TX_START,TX_RAM2," will use the\n"
	db "Pok`mon Power ",TX_RAM2,".",TX_END

	db TX_START,"Finished the Turn\n"
	db "without Attacking.",TX_END

	db TX_START,TX_RAM1,"'s Turn.",TX_END

	db TX_START,"Attached ",TX_RAM2,"\n"
	db "to ",TX_RAM2,".",TX_END

	db TX_START,TX_RAM2," evolved\n"
	db "into ",TX_RAM2,".",TX_END

	db TX_START,"Placed ",TX_RAM2,"\n"
	db "on the Bench.",TX_END

	db TX_START,TX_RAM2,"\n"
	db "was placed in the Arena.",TX_END

	db TX_START,TX_RAM1," shuffles the Deck.",TX_END

	db TX_START,"Since this is just practice,\n"
	db "Do not shuffle the Deck.",TX_END

	db TX_START,"Each player will\n"
	db "shuffle the opponent's Deck.",TX_END

	db TX_START,"Each player will draw 7 cards.",TX_END

	db TX_START,TX_RAM1,"\n"
	db "drew 7 cards.",TX_END

	db TX_START,TX_RAM1,"'s deck has ",TX_RAM3," cards.",TX_END

	db TX_START,"Choose a Basic Pok`mon\n"
	db "to place in the Arena.",TX_END

	db TX_START,"There are no Basic Pok`mon\n"
	db "in ",TX_RAM1,"'s hand.",TX_END

	db TX_START,"Neither player has any Basic\n"
	db "Pok`mon in his or her hand.",TX_END

	db TX_START,"Return the cards to the Deck\n"
	db "and draw again.",TX_END

	db TX_START,"You may choose up to 5 Basic Pok`mon\n"
	db "to place on the Bench.",TX_END

	db TX_START,"Please choose an\n"
	db "Active Pok`mon.",TX_END

	db TX_START,"Choose your\n"
	db "Bench Pok`mon.",TX_END

	db TX_START,"You drew ",TX_RAM2,".",TX_END

	db TX_START,"You cannot select this card.",TX_END

	db TX_START,"Placing the Prizes...",TX_END

	db TX_START,"Please place\n"
	db TX_RAM3," Prizes.",TX_END

	db TX_START,"If heads,\n"
	db TX_START,TX_RAM2," plays first.",TX_END

	db TX_START,"A coin will be tossed\n"
	db "to decide who plays first.",TX_END

	db TX_START,"Decision...",TX_END

	db TX_START,"The Duel with ",TX_RAM1,"\n"
	db "was a Draw!",TX_END

	db TX_START,"You won the Duel with ",TX_RAM1,"!",TX_END

	db TX_START,"You lost the Duel\n"
	db "with ",TX_RAM1,"...",TX_END

	db TX_START,"Start a Sudden-Death\n"
	db "Match for 1 Prize!",TX_END

	db TX_START,"Prizes Left\n"
	db "Active Pok`mon\n"
	db "Cards in Deck",TX_END

	db TX_START,"None",TX_END

	db TX_START,"Yes",TX_END

	db TX_START,"Cards",TX_END

	db TX_START,TX_RAM1," took\n"
	db "all the Prizes!",TX_END

	db TX_START,"There are no Pok`mon\n"
	db "in ",TX_RAM1,"'s Play Area!",TX_END

	db TX_START,TX_RAM2," was\n"
	db "Knocked Out!",TX_END

	db TX_START,TX_RAM2," have\n"
	db "Pok`mon Power.",TX_END

	db TX_START,"Unable to us Pok`mon Power due to\n"
	db "the effect of Toxic Gas.",TX_END

	db TX_START,"  Play\n"
	db "  Check",TX_END

	db TX_START,"  Play\n"
	db "  Check",TX_END

	db TX_START,"  Select\n"
	db "  Check",TX_END

	db $03,$31,$0C,$03,$42,$0C,TX_END

	db TX_START,TX_RAM1," is thinking.",TX_END

	db $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,TX_END

	db TX_START,"Select a computer opponent.",TX_END

	db TX_START,"Number of Prizes",TX_END

	db TX_START,"Random 1",TX_END

	db TX_START,"Random 2",TX_END

	db TX_START,"Random 3",TX_END

	db TX_START,"Random 4",TX_END

	db TX_START,"Training COM",TX_END

	db TX_START,"Player 1",TX_END

	db TX_START,"Player 2",TX_END

	db TX_START,"Left to Right",TX_END

	db TX_START,"Right to Left",TX_END

	db TX_START,"START: Change\n"
	db "    A: Execute\n"
	db "    B: End",TX_END

	db TX_START,"Other\n"
	db "Poison\n"
	db "Sleep\n"
	db "Payalysis\n"
	db "Confusion\n"
	db "Double Poison\n"
	db "Clear\n"
	db "Foul Gas\n"
	db "Opponent's Hand\n"
	db "Discard from Hand\n"
	db "Select Deck\n"
	db "Select Discard\n"
	db "From Hand to Deck\n"
	db "Take Prize\n"
	db "Change Player\n"
	db "Shuffle Deck\n"
	db "Discard Bench\n"
	db "Change Card",TX_END

	db TX_START,"WIN GAME\n"
	db "LOSE GAME\n"
	db "DRAW GAME\n"
	db "CHANGE CASE\n"
	db "PAUSE MODE\n"
	db "CHANGE COMPUTER OPPONENT\n"
	db "CHANGE PLAYER 2 TO COM\n"
	db "FLIP 20\n"
	db "SAVE NOW\n"
	db "LOAD FILE",TX_END

	db TX_START,"Save File",TX_END

	db TX_START,"Load File\n"
	db "  ",$07,$60,$06,"  Last Saved File",TX_END

	db TX_START,"Pause Mode is ON\n"
	db "Press SELECT to Pause",TX_END

	db TX_START,"Pause Mode is OFF",TX_END

	db TX_START,"Computer Mode is OFF",TX_END

	db TX_START,"Computer Mode is ON",TX_END

	db TX_START,TX_GRASS," Pok`mon\n"
	db TX_START,TX_FIRE," Pok`mon\n"
	db TX_START,TX_WATER," Pok`mon\n"
	db TX_START,TX_LIGHTNING," Pok`mon\n"
	db TX_START,TX_FIGHTING," Pok`mon\n"
	db TX_START,TX_PSYCHIC," Pok`mon\n"
	db TX_START,TX_COLORLESS," Pok`mon\n"
	db "Trainer Card\n"
	db "Energy Card",TX_END

	db TX_START,"Card List",TX_END

	db TX_START,"Test Coin Flip",TX_END

	db TX_START,"End without Prizes?",TX_END

	db TX_START,"Reset Back Up RAM?",TX_END

	db TX_START,"Your Data was destroyed\n"
	db "somehow.\n\n"
	db "The game cannot be continued\n"
	db "in its present condition.\n"
	db "Please restart the game after\n"
	db "the Data is reset.",TX_END

	db TX_START,"No cards in hand.",TX_END

	db TX_START,"The Discard Pile has no cards.",TX_END

	db TX_START,"Player's Discard Pile",TX_END

	db TX_START,TX_RAM1,"'s Hand",TX_END

	db TX_START,TX_RAM1,"'s Play Area",TX_END

	db TX_START,TX_RAM1,"'s Deck",TX_END

	db TX_START,"Please select\n"
	db "Hand.",TX_END

	db TX_START,"Please select\n"
	db "Card.",TX_END

	db TX_START,"There are no Pok`mon\n"
	db "with Damage Counters.",TX_END

	db TX_START,"There are no Damage Counters.",TX_END

	db TX_START,"No Energy cards are attached to\n"
	db "the opponent's Active Pok`mon.",TX_END

	db TX_START,"There are no Energy cards\n"
	db "in the the Discard Pile.",TX_END

	db TX_START,"There are no Basic Energy cards\n"
	db "in the Discard Pile.",TX_END

	db TX_START,"There are no cards left in the Deck.",TX_END

	db TX_START,"There is no space on the Bench.",TX_END

	db TX_START,"There are no Pok`mon capable\n"
	db "of Evolving.",TX_END

	db TX_START,"You cannot Evolve a Pok`mon\n"
	db "in the same turn it was placed.",TX_END

	db TX_START,"Not affected by Poison,\n"
	db "Sleep, Paralysis, or Confusion.",TX_END

	db TX_START,"Not enough cards in Hand.",TX_END

	db TX_START,"No Pok`mon on the Bench.",TX_END

	db TX_START,"There are no Pok`mon\n"
	db "in the Discard Pile.",TX_END

	db TX_START,"Conditions for evolving to\n"
	db "Stage 2 not fulfilled.",TX_END

	db TX_START,"There are no cards in Hand\n"
	db "that you can change.",TX_END

	db TX_START,"There are no cards in the\n"
	db "Discard Pile.",TX_END

	db TX_START,"There are no Stage 1 Pok`mon\n"
	db "in the Play Area.",TX_END

	db TX_START,"No Energy cards are attached to\n"
	db "Pok`mon in your Play Area.",TX_END

	db TX_START,"No Energy cards attached to Pok`mon\n"
	db "in your opponent's Play Area.",TX_END

	db TX_START,TX_RAM3," Energy cards\n"
	db "are required to Retreat.",TX_END

	db TX_START,"Not enough Energy cards.",TX_END

	db TX_START,"Not enough Fire Energy.",TX_END

	db TX_START,"Not enough Psychic Energy.",TX_END

	db TX_START,"Not enough Water Energy.",TX_END

	db TX_START,"There are no Trainer Cards\n"
	db "in the Discard Pile.",TX_END

	db TX_START,"No Attacks may be choosen.",TX_END

	db TX_START,"You did not receive an Attack\n"
	db "to Mirror Move.",TX_END

	db TX_START,"This attack cannot\n"
	db "be used twice.",TX_END

	db TX_START,"No Weakness.",TX_END

	db TX_START,"No Resistance.",TX_END

	db TX_START,"Only once per turn.",TX_END

	db TX_START,"Cannot use due to Sleep, Paralysis,\n"
	db "or Confusion.",TX_END

	db TX_START,"Cannot be used in the turn in\n"
	db "which it was played.",TX_END

	db TX_START,"There is no Energy card attached.",TX_END

	db TX_START,"No Grass Energy.",TX_END

	db TX_START,"Cannot use since there's only\n"
	db "1 Pok`mon.",TX_END

	db TX_START,"Cannot use because\n"
	db "it will be Knocked Out.",TX_END

	db TX_START,"Can only be used on the Bench.",TX_END

	db TX_START,"There are no Pok`mon on the Bench.",TX_END

	db TX_START,"Opponent is not Asleep",TX_END

	db TX_START,"Unable to use due to the\n"
	db "effects of Toxic Gas.",TX_END

	db TX_START,"A Transmission Error occured.",TX_END

	db TX_START,"Back Up is broken.",TX_END

	db TX_START,"Error No. 02:\n"
	db "Printer is not connected.",TX_END

	db TX_START,"Error No. 01:\n"
	db "Batteries have lost their charge.",TX_END

	db TX_START,"Error No. 03:\n"
	db "Printer paper is jammed.",TX_END

	db TX_START,"Error No. 02:\n"
	db "Check cable or printer switch.",TX_END

	db TX_START,"Error No. 04:\n"
	db "Printer Packet Error.",TX_END

	db TX_START,"Printing was interrupted.",TX_END

	db TX_START,"Card Pop! cannot be played\n"
	db "with the Game Boy.\n"
	db "Please use a\n"
	db "Game Boy Color.",TX_END

	db TX_START,"Sand-attack check!\n"
	db "If Tails, Attack is unsuccessful.",TX_END

	db TX_START,"Smokescreen check!\n"
	db "If Tails, Attack is unsuccessful.",TX_END

	db TX_START,"Paralysis check!\n"
	db "If Heads, opponent is Paralyzed.",TX_END

	db TX_START,"Sleep check!\n"
	db "If Heads, opponent becomes Asleep.",TX_END

	db TX_START,"Poison check!\n"
	db "If Heads, opponent is Poisoned.",TX_END

	db TX_START,"Confusion check! If Heads,\n"
	db "opponent becomes Confused.",TX_END

	db TX_START,"Venom Powder check! If Heads,\n"
	db "opponent is Poisoned & Confused.",TX_END

	db TX_START,"If Tails,  your Pok`mon\n"
	db "becomes Confused.",TX_END

	db TX_START,"Damage check!\n"
	db "If Tails, no damage!!!",TX_END

	db TX_START,"If Heads,\n"
	db "Draw 1 card from Deck!",TX_END

	db TX_START,"Flip until Tails appears.\n"
	db "10 damage for each Heads!!!",TX_END

	db TX_START,"If Heads, + 10 damage!\n"
	db "If Tails, +10 damage to yourself!",TX_END

	db TX_START,"10 damage to opponent's Bench if\n"
	db "Heads, damage to yours if Tails.",TX_END

	db TX_START,"If Heads, change opponent's\n"
	db "Active Pok`mon.",TX_END

	db TX_START,"If Heads,\n"
	db "Heal is successful.",TX_END

	db TX_START,"If Tails, ",TX_RAM3," damage\n"
	db "to yourself, too.",TX_END

	db TX_START,"Success check!!!\n"
	db "If Heads, Attack is successful!",TX_END

	db TX_START,"Trainer card success check!\n"
	db "If Heads, you're successful!",TX_END

	db TX_START,"Card check!\n"
	db "If Heads, 8 cards! If Tails, 1 card!",TX_END

	db TX_START,"If Heads, you will not receive\n"
	db "damage during opponent's next turn!",TX_END

	db TX_START,"Damage check",TX_END

	db TX_START,"Damage check!\n"
	db "If Heads, +",TX_RAM3," damage!!",TX_END

	db TX_START,"Damage check!\n"
	db "If Heads, x ",TX_RAM3," damage!!"