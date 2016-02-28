DuelMenuText_Hand: ; 3630a (d:630a)
	db TX_START,"Hand",TX_END

DuelMenuText_Check: ; 36310 (d:6310)
	db TX_START,"Check",TX_END

DuelMenuText_Attack: ; 36317 (d:6317)
	db TX_START,"Attack",TX_END

DuelMenuText_PKMNPower: ; 3631f (d:631f)
	db TX_START,"PKMN Power",TX_END

DuelMenuText_Done: ; 3632b (d:632b)
	db TX_START,"Done",TX_END

DuelMenuText_Type: ; 36331 (d:6331)
	db TX_START,"Type",TX_END

CardInfoPageText_Retreat: ; 36337 (d:6337)
	db TX_START,"Retreat",TX_END

CardInfoPageText_Weakness: ; 36340 (d:6340)
	db TX_START,"Weakness",TX_END

CardInfoPageText_Resistance: ; 3634a (d:634a)
	db TX_START,"Resistance",TX_END

CardInfoPageText_PKMNPWR: ; 36356 (d:6356)
	db TX_START,"PKMN PWR",TX_END

Text000b: ; 36360 (d:6360)
	db $56,$19,$33,$3d,$16,$78,$4c,TX_END

CardInfoPageText_Length: ; 36368 (d:6368)
	db TX_START,"Length",TX_END

CardInfoPageText_Weight: ; 36370 (d:6370)
	db TX_START,"Weight",TX_END

CardInfoPageText_Pokemon: ; 36378 (d:6378)
	db TX_START," Pok`mon",TX_END

Text000f: ; 36382 (d:6382)
	db $03,$4c,TX_END

CardInfoPageText_lbs: ; 36385 (d:6385)
	db TX_START,"lbs.",TX_END

Text0011: ; 3638b (d:638b)
	db $70,TX_END

Text0012: ; 3638d (d:638d)
	db $03,$52,TX_END

Text0013: ; 36390 (d:6390)
	db $03,$53,TX_END

Text0014: ; 36393 (d:6393)
	db $03,$54,TX_END

Text0015: ; 36396 (d:6396)
	db TX_START," All cards owned:",TX_END

Text0016: ; 363a9 (d:63a9)
	db TX_START,"Total number of cards",TX_END

Text0017: ; 363c0 (d:63c0)
	db TX_START,"Types of cards",TX_END

Text0018: ; 363d0 (d:63d0)
	db TX_START,"Grass Pok`mon",TX_END

Text0019: ; 363df (d:63df)
	db TX_START,"Fire Pok`mon",TX_END

Text001a: ; 363ed (d:63ed)
	db TX_START,"Water Pok`mon",TX_END

Text001b: ; 363fc (d:63fc)
	db TX_START,"Lightning Pok`mon",TX_END

Text001c: ; 3640f (d:640f)
	db TX_START,"Fighting Pok`mon",TX_END

Text001d: ; 36421 (d:6421)
	db TX_START,"Psychic Pok`mon",TX_END

Text001e: ; 36432 (d:6432)
	db TX_START,"Colorless Pok`mon",TX_END

Text001f: ; 36445 (d:6445)
	db TX_START,"Trainer Card",TX_END

Text0020: ; 36453 (d:6453)
	db TX_START,"Energy Card",TX_END

Text0021: ; 36460 (d:6460)
	db TX_START,"Deck",TX_END

Text0022: ; 36466 (d:6466)
	db TX_START,"Attack",TX_END

NoPokemonOnTheBench: ; 3646e (d:646e)
	db TX_START,"No Pok`mon on the Bench.",TX_END

UnableDueToSleep: ; 36488 (d:6488)
	db TX_START,"Unable to due to Sleep.",TX_END

UnableDueToParalysis: ; 364a1 (d:64a1)
	db TX_START,"Unable to due to Paralysis.",TX_END

Received10DamageDueToPoison: ; 364be (d:64be)
	db TX_START,TX_RAM2," received\n"
	db "10 damage due to Poison.",TX_END

Received20DamageDueToPoison: ; 364e3 (d:64e3)
	db TX_START,TX_RAM2," received\n"
	db "20 damage due to Double Poison.",TX_END

IsStillAsleep: ; 3650f (d:650f)
	db TX_START,TX_RAM2," is\n"
	db "still Asleep.",TX_END

IsCuredOfSleep: ; 36523 (d:6523)
	db TX_START,TX_RAM2," is\n"
	db "cured of Sleep.",TX_END

IsCuredOfParalysis: ; 36539 (d:6539)
	db TX_START,TX_RAM2," is\n"
	db "cured of Paralysis.",TX_END

Text002b: ; 36553 (d:6553)
	db TX_START,"Between Turns.",TX_END

Text002c: ; 36563 (d:6563)
	db TX_START,"Unable to use it.",TX_END

Text002d: ; 36576 (d:6576)
	db TX_START,"No Energy cards.",TX_END

Text002e: ; 36588 (d:6588)
	db TX_START,"Is this OK?",TX_END

YesOrNo: ; 36595 (d:6595)
	db TX_START,"Yes     No",TX_END

DiscardName: ; 365a1 (d:65a1)
	db TX_START,"Discard",TX_END

Text0031: ; 365aa (d:65aa)
	db TX_START,"Incomplete",TX_END

Text0032: ; 365b6 (d:65b6)
	db TX_START,"Damage",TX_END

Text0033: ; 365be (d:65be)
	db TX_START,"Used ",TX_RAM2,".",TX_END

Text0034: ; 365c7 (d:65c7)
	db TX_START,"Received damage",TX_END

PokemonsAttack: ; 365d8 (d:65d8)
	db TX_START,TX_RAM2,"'s\n"
	db TX_START,TX_RAM2,"!",TX_END

Text0036: ; 365e1 (d:65e1)
	db TX_START,TX_RAM2," received\n"
	db TX_RAM3," damage due to Resistance!",TX_END

Text0037: ; 36609 (d:6609)
	db TX_START,TX_RAM2," received\n"
	db TX_RAM3," damage due to Weakness!",TX_END

Text0038: ; 3662f (d:662f)
	db TX_START,TX_RAM2," received\n"
	db TX_RAM3," damage due to Weakness!",TX_END

Text0039: ; 36655 (d:6655)
	db TX_START,TX_RAM2," did not\n"
	db "receive damage due to Resistance.",TX_END

Text003a: ; 36682 (d:6682)
	db TX_START,TX_RAM2," took\n"
	db TX_RAM3," damage.",TX_END

Text003b: ; 36694 (d:6694)
	db TX_START,TX_RAM2," did not\n"
	db "receive damage!",TX_END

NoSelectableAttack: ; 366af (d:66af)
	db TX_START,"No selectable Attack",TX_END

UnableToRetreat: ; 366c5 (d:66c5)
	db TX_START,"Unable to Retreat.",TX_END

Text003e: ; 366d9 (d:66d9)
	db TX_START,"You may only attach 1 Energy card\n"
	db "per turn.",TX_END

Text003f: ; 36706 (d:6706)
	db TX_START,"Use this Pok`mon Power?",TX_END

Text0040: ; 3671f (d:671f)
	db TX_START,"You do not need to select the\n"
	db "Pok`mon Power to use it.",TX_END

DiscardDescription: ; 36757 (d:6757)
	db TX_START,"You may discard this card during\n"
	db "your turn.\n"
	db "It will be counted as a Knock Out\n"
	db "(This Discard is not\n"
	db "a Pok`mon Power)",TX_END

Text0042: ; 367cc (d:67cc)
	db TX_START,TX_RAM1," will draw ",TX_RAM3," Prize(s).",TX_END

Text0043: ; 367e5 (d:67e5)
	db TX_START,TX_RAM1," drew ",TX_RAM3," Prize(s).",TX_END

Text0044: ; 367f9 (d:67f9)
	db TX_START,TX_RAM1," placed\n"
	db "a ",TX_RAM2,".",TX_END

Text0045: ; 36808 (d:6808)
	db TX_START,"Unable to select.",TX_END

Text0046: ; 3681b (d:681b)
	db TX_START,"Grass\n"
	db "Fire\n"
	db "Water\n"
	db "Lightning\n"
	db "Fighting\n"
	db "Psychic",TX_END

Text0047: ; 36848 (d:6848)
	db TX_GRASS,TX_END

Text0048: ; 3684b (d:684b)
	db TX_FIRE,TX_END

Text0049: ; 3684e (d:684e)
	db TX_WATER,TX_END

Text004a: ; 36851 (d:6851)
	db TX_LIGHTNING,TX_END

Text004b: ; 36854 (d:6854)
	db TX_FIGHTING,TX_END

Text004c: ; 36857 (d:6857)
	db TX_PSYCHIC,TX_END

Text004d: ; 3685a (d:685a)
	db TX_START,"Bench",TX_END

Text004e: ; 36861 (d:6861)
	db TX_START,"Knock Out",TX_END

DamageToSelfDueToConfusion: ; 3686c (d:686c)
	db TX_START,"20 damage to Self due to Confusion.",TX_END

Text0050: ; 36891 (d:6891)
	db TX_START,"Choose the Energy card\n"
	db "you wish to discard.",TX_END

Text0051: ; 368be (d:68be)
	db TX_START,"The Active Pok`mon was Knocked Out.\n"
	db "Please choose the next Pok`mon.",TX_END

Text0052: ; 36903 (d:6903)
	db TX_START,"Press START\n"
	db "When you are ready.",TX_END

Text0053: ; 36924 (d:6924)
	db TX_START,"You play first.",TX_END

Text0054: ; 36935 (d:6935)
	db TX_START,"You play second.",TX_END

TransmissionError: ; 36947 (d:6947)
	db TX_START,"Transmission Error.\n"
	db "Start again from the beginning.",TX_END

Text0056: ; 3697c (d:697c)
	db TX_START,"Choose the card\n"
	db "you wish to examine.",TX_END

Text0057: ; 369a2 (d:69a2)
	db TX_START,"Transmitting data...",TX_END

Text0058: ; 369b8 (d:69b8)
	db TX_START,"Waiting...\n"
	db "    Hand        Examine",TX_END

Text0059: ; 369dc (d:69dc)
	db TX_START,"Selecting Bench Pok`mon...\n"
	db "    Hand        Examine     Back",TX_END

Text005a: ; 36a19 (d:6a19)
	db TX_START,TX_RAM2,"\n"
	db "Retreated to the Bench.",TX_END

Text005b: ; 36a34 (d:6a34)
	db TX_START,TX_RAM2,"'s\n"
	db "Retreat was unsuccessful.",TX_END

Text005c: ; 36a53 (d:6a53)
	db TX_START,TX_RAM2," will use the\n"
	db "Pok`mon Power ",TX_RAM2,".",TX_END

Text005d: ; 36a74 (d:6a74)
	db TX_START,"Finished the Turn\n"
	db "without Attacking.",TX_END

Text005e: ; 36a9a (d:6a9a)
	db TX_START,TX_RAM1,"'s Turn.",TX_END

Text005f: ; 36aa5 (d:6aa5)
	db TX_START,"Attached ",TX_RAM2,"\n"
	db "to ",TX_RAM2,".",TX_END

Text0060: ; 36ab7 (d:6ab7)
	db TX_START,TX_RAM2," evolved\n"
	db "into ",TX_RAM2,".",TX_END

Text0061: ; 36aca (d:6aca)
	db TX_START,"Placed ",TX_RAM2,"\n"
	db "on the Bench.",TX_END

Text0062: ; 36ae2 (d:6ae2)
	db TX_START,TX_RAM2,"\n"
	db "was placed in the Arena.",TX_END

Text0063: ; 36afe (d:6afe)
	db TX_START,TX_RAM1," shuffles the Deck.",TX_END

Text0064: ; 36b14 (d:6b14)
	db TX_START,"Since this is just practice,\n"
	db "Do not shuffle the Deck.",TX_END

Text0065: ; 36b4b (d:6b4b)
	db TX_START,"Each player will\n"
	db "shuffle the opponent's Deck.",TX_END

Text0066: ; 36b7a (d:6b7a)
	db TX_START,"Each player will draw 7 cards.",TX_END

Text0067: ; 36b9a (d:6b9a)
	db TX_START,TX_RAM1,"\n"
	db "drew 7 cards.",TX_END

Text0068: ; 36bab (d:6bab)
	db TX_START,TX_RAM1,"'s deck has ",TX_RAM3," cards.",TX_END

Text0069: ; 36bc2 (d:6bc2)
	db TX_START,"Choose a Basic Pok`mon\n"
	db "to place in the Arena.",TX_END

Text006a: ; 36bf1 (d:6bf1)
	db TX_START,"There are no Basic Pok`mon\n"
	db "in ",TX_RAM1,"'s hand.",TX_END

Text006b: ; 36c1a (d:6c1a)
	db TX_START,"Neither player has any Basic\n"
	db "Pok`mon in his or her hand.",TX_END

Text006c: ; 36c54 (d:6c54)
	db TX_START,"Return the cards to the Deck\n"
	db "and draw again.",TX_END

Text006d: ; 36c82 (d:6c82)
	db TX_START,"You may choose up to 5 Basic Pok`mon\n"
	db "to place on the Bench.",TX_END

Text006e: ; 36cbf (d:6cbf)
	db TX_START,"Please choose an\n"
	db "Active Pok`mon.",TX_END

Text006f: ; 36ce1 (d:6ce1)
	db TX_START,"Choose your\n"
	db "Bench Pok`mon.",TX_END

Text0070: ; 36cfd (d:6cfd)
	db TX_START,"You drew ",TX_RAM2,".",TX_END

Text0071: ; 36d0a (d:6d0a)
	db TX_START,"You cannot select this card.",TX_END

Text0072: ; 36d28 (d:6d28)
	db TX_START,"Placing the Prizes...",TX_END

Text0073: ; 36d3f (d:6d3f)
	db TX_START,"Please place\n"
	db TX_RAM3," Prizes.",TX_END

Text0074: ; 36d57 (d:6d57)
	db TX_START,"If heads,\n"
	db TX_START,TX_RAM2," plays first.",TX_END

Text0075: ; 36d72 (d:6d72)
	db TX_START,"A coin will be tossed\n"
	db "to decide who plays first.",TX_END

Decision: ; 36da4 (d:6da4)
	db TX_START,"Decision...",TX_END

DuelWasDraw: ; 36db1 (d:6db1)
	db TX_START,"The Duel with ",TX_RAM1,"\n"
	db "was a Draw!",TX_END

WonDuel: ; 36dce (d:6dce)
	db TX_START,"You won the Duel with ",TX_RAM1,"!",TX_END

LostDuel: ; 36de8 (d:6de8)
	db TX_START,"You lost the Duel\n"
	db "with ",TX_RAM1,"...",TX_END

StartSuddenDeathMatch: ; 36e05 (d:6e05)
	db TX_START,"Start a Sudden-Death\n"
	db "Match for 1 Prize!",TX_END

Text007b: ; 36e2e (d:6e2e)
	db TX_START,"Prizes Left\n"
	db "Active Pok`mon\n"
	db "Cards in Deck",TX_END

Text007c: ; 36e58 (d:6e58)
	db TX_START,"None",TX_END

Text007d: ; 36e5e (d:6e5e)
	db TX_START,"Yes",TX_END

Text007e: ; 36e63 (d:6e63)
	db TX_START,"Cards",TX_END

Text007f: ; 36e6a (d:6e6a)
	db TX_START,TX_RAM1," took\n"
	db "all the Prizes!",TX_END

Text0080: ; 36e82 (d:6e82)
	db TX_START,"There are no Pok`mon\n"
	db "in ",TX_RAM1,"'s Play Area!",TX_END

WasKnockedOut: ; 36eaa (d:6eaa)
	db TX_START,TX_RAM2," was\n"
	db "Knocked Out!",TX_END

Text0082: ; 36ebe (d:6ebe)
	db TX_START,TX_RAM2," have\n"
	db "Pok`mon Power.",TX_END

Text0083: ; 36ed5 (d:6ed5)
	db TX_START,"Unable to us Pok`mon Power due to\n"
	db "the effect of Toxic Gas.",TX_END

Text0084: ; 36f11 (d:6f11)
	db TX_START,"  Play\n"
	db "  Check",TX_END

Text0085: ; 36f21 (d:6f21)
	db TX_START,"  Play\n"
	db "  Check",TX_END

Text0086: ; 36f31 (d:6f31)
	db TX_START,"  Select\n"
	db "  Check",TX_END

Text0087: ; 36f43 (d:6f43)
	db $03,$31,$0c,$03,$42,$0c,TX_END

DuelistIsThinking: ; 36f4a (d:6f4a)
	db TX_START,TX_RAM1," is thinking.",TX_END

Text0089: ; 36f5a (d:6f5a)
	db $70,$70,$70,$70,$70,$70,$70,$70,$70,$70,TX_END

Text008a: ; 36f65 (d:6f65)
	db TX_START,"Select a computer opponent.",TX_END

Text008b: ; 36f82 (d:6f82)
	db TX_START,"Number of Prizes",TX_END

Text008c: ; 36f94 (d:6f94)
	db TX_START,"Random 1",TX_END

Text008d: ; 36f9e (d:6f9e)
	db TX_START,"Random 2",TX_END

Text008e: ; 36fa8 (d:6fa8)
	db TX_START,"Random 3",TX_END

Text008f: ; 36fb2 (d:6fb2)
	db TX_START,"Random 4",TX_END

Text0090: ; 36fbc (d:6fbc)
	db TX_START,"Training COM",TX_END

Text0091: ; 36fca (d:6fca)
	db TX_START,"Player 1",TX_END

Player2: ; 36fd4 (d:6fd4)
	db TX_START,"Player 2",TX_END

Text0093: ; 36fde (d:6fde)
	db TX_START,"Left to Right",TX_END

Text0094: ; 36fed (d:6fed)
	db TX_START,"Right to Left",TX_END

Text0095: ; 36ffc (d:6ffc)
	db TX_START,"START: Change\n"
	db "    A: Execute\n"
	db "    B: End",TX_END

Text0096: ; 37025 (d:7025)
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

Text0097: ; 370f9 (d:70f9)
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

Text0098: ; 37179 (d:7179)
	db TX_START,"Save File",TX_END

Text0099: ; 37184 (d:7184)
	db TX_START,"Load File\n"
	db "  ",$07,$60,$06,"  Last Saved File",TX_END

Text009a: ; 371a6 (d:71a6)
	db TX_START,"Pause Mode is ON\n"
	db "Press SELECT to Pause",TX_END

Text009b: ; 371ce (d:71ce)
	db TX_START,"Pause Mode is OFF",TX_END

Text009c: ; 371e1 (d:71e1)
	db TX_START,"Computer Mode is OFF",TX_END

Text009d: ; 371f7 (d:71f7)
	db TX_START,"Computer Mode is ON",TX_END

Text009e: ; 3720c (d:720c)
	db TX_START,TX_GRASS," Pok`mon\n"
	db TX_START,TX_FIRE," Pok`mon\n"
	db TX_START,TX_WATER," Pok`mon\n"
	db TX_START,TX_LIGHTNING," Pok`mon\n"
	db TX_START,TX_FIGHTING," Pok`mon\n"
	db TX_START,TX_PSYCHIC," Pok`mon\n"
	db TX_START,TX_COLORLESS," Pok`mon\n"
	db "Trainer Card\n"
	db "Energy Card",TX_END

Text009f: ; 37279 (d:7279)
	db TX_START,"Card List",TX_END

Text00a0: ; 37284 (d:7284)
	db TX_START,"Test Coin Flip",TX_END

Text00a1: ; 37294 (d:7294)
	db TX_START,"End without Prizes?",TX_END

ResetBackUpRam: ; 372a9 (d:72a9)
	db TX_START,"Reset Back Up RAM?",TX_END

Text00a3: ; 372bd (d:72bd)
	db TX_START,"Your Data was destroyed\n"
	db "somehow.\n\n"
	db "The game cannot be continued\n"
	db "in its present condition.\n"
	db "Please restart the game after\n"
	db "the Data is reset.",TX_END

NoCardsInHand: ; 37348 (d:7348)
	db TX_START,"No cards in hand.",TX_END

Text00a5: ; 3735b (d:735b)
	db TX_START,"The Discard Pile has no cards.",TX_END

Text00a6: ; 3737b (d:737b)
	db TX_START,"Player's Discard Pile",TX_END

Text00a7: ; 37392 (d:7392)
	db TX_START,TX_RAM1,"'s Hand",TX_END

Text00a8: ; 3739c (d:739c)
	db TX_START,TX_RAM1,"'s Play Area",TX_END

Text00a9: ; 373ab (d:73ab)
	db TX_START,TX_RAM1,"'s Deck",TX_END

Text00aa: ; 373b5 (d:73b5)
	db TX_START,"Please select\n"
	db "Hand.",TX_END

Text00ab: ; 373ca (d:73ca)
	db TX_START,"Please select\n"
	db "Card.",TX_END

Text00ac: ; 373df (d:73df)
	db TX_START,"There are no Pok`mon\n"
	db "with Damage Counters.",TX_END

Text00ad: ; 3740b (d:740b)
	db TX_START,"There are no Damage Counters.",TX_END

Text00ae: ; 3742a (d:742a)
	db TX_START,"No Energy cards are attached to\n"
	db "the opponent's Active Pok`mon.",TX_END

Text00af: ; 3746a (d:746a)
	db TX_START,"There are no Energy cards\n"
	db "in the the Discard Pile.",TX_END

Text00b0: ; 3749e (d:749e)
	db TX_START,"There are no Basic Energy cards\n"
	db "in the Discard Pile.",TX_END

Text00b1: ; 374d4 (d:74d4)
	db TX_START,"There are no cards left in the Deck.",TX_END

Text00b2: ; 374fa (d:74fa)
	db TX_START,"There is no space on the Bench.",TX_END

Text00b3: ; 3751b (d:751b)
	db TX_START,"There are no Pok`mon capable\n"
	db "of Evolving.",TX_END

Text00b4: ; 37546 (d:7546)
	db TX_START,"You cannot Evolve a Pok`mon\n"
	db "in the same turn it was placed.",TX_END

Text00b5: ; 37583 (d:7583)
	db TX_START,"Not affected by Poison,\n"
	db "Sleep, Paralysis, or Confusion.",TX_END

Text00b6: ; 375bc (d:75bc)
	db TX_START,"Not enough cards in Hand.",TX_END

Text00b7: ; 375d7 (d:75d7)
	db TX_START,"No Pok`mon on the Bench.",TX_END

Text00b8: ; 375f1 (d:75f1)
	db TX_START,"There are no Pok`mon\n"
	db "in the Discard Pile.",TX_END

Text00b9: ; 3761c (d:761c)
	db TX_START,"Conditions for evolving to\n"
	db "Stage 2 not fulfilled.",TX_END

Text00ba: ; 3764f (d:764f)
	db TX_START,"There are no cards in Hand\n"
	db "that you can change.",TX_END

Text00bb: ; 37680 (d:7680)
	db TX_START,"There are no cards in the\n"
	db "Discard Pile.",TX_END

Text00bc: ; 376a9 (d:76a9)
	db TX_START,"There are no Stage 1 Pok`mon\n"
	db "in the Play Area.",TX_END

Text00bd: ; 376d9 (d:76d9)
	db TX_START,"No Energy cards are attached to\n"
	db "Pok`mon in your Play Area.",TX_END

Text00be: ; 37715 (d:7715)
	db TX_START,"No Energy cards attached to Pok`mon\n"
	db "in your opponent's Play Area.",TX_END

Text00bf: ; 37758 (d:7758)
	db TX_START,TX_RAM3," Energy cards\n"
	db "are required to Retreat.",TX_END

NotEnoughEnergyCards: ; 37781 (d:7781)
	db TX_START,"Not enough Energy cards.",TX_END

Text00c1: ; 3779b (d:779b)
	db TX_START,"Not enough Fire Energy.",TX_END

Text00c2: ; 377b4 (d:77b4)
	db TX_START,"Not enough Psychic Energy.",TX_END

Text00c3: ; 377d0 (d:77d0)
	db TX_START,"Not enough Water Energy.",TX_END

Text00c4: ; 377ea (d:77ea)
	db TX_START,"There are no Trainer Cards\n"
	db "in the Discard Pile.",TX_END

Text00c5: ; 3781b (d:781b)
	db TX_START,"No Attacks may be choosen.",TX_END

Text00c6: ; 37837 (d:7837)
	db TX_START,"You did not receive an Attack\n"
	db "to Mirror Move.",TX_END

Text00c7: ; 37866 (d:7866)
	db TX_START,"This attack cannot\n"
	db "be used twice.",TX_END

Text00c8: ; 37889 (d:7889)
	db TX_START,"No Weakness.",TX_END

Text00c9: ; 37897 (d:7897)
	db TX_START,"No Resistance.",TX_END

Text00ca: ; 378a7 (d:78a7)
	db TX_START,"Only once per turn.",TX_END

CannotUseDueToStatus: ; 378bc (d:78bc)
	db TX_START,"Cannot use due to Sleep, Paralysis,\n"
	db "or Confusion.",TX_END

Text00cc: ; 378ef (d:78ef)
	db TX_START,"Cannot be used in the turn in\n"
	db "which it was played.",TX_END

Text00cd: ; 37923 (d:7923)
	db TX_START,"There is no Energy card attached.",TX_END

Text00ce: ; 37946 (d:7946)
	db TX_START,"No Grass Energy.",TX_END

Text00cf: ; 37958 (d:7958)
	db TX_START,"Cannot use since there's only\n"
	db "1 Pok`mon.",TX_END

Text00d0: ; 37982 (d:7982)
	db TX_START,"Cannot use because\n"
	db "it will be Knocked Out.",TX_END

Text00d1: ; 379ae (d:79ae)
	db TX_START,"Can only be used on the Bench.",TX_END

Text00d2: ; 379ce (d:79ce)
	db TX_START,"There are no Pok`mon on the Bench.",TX_END

Text00d3: ; 379f2 (d:79f2)
	db TX_START,"Opponent is not Asleep",TX_END

UnableDueToToxicGas: ; 37a0a (d:7a0a)
	db TX_START,"Unable to use due to the\n"
	db "effects of Toxic Gas.",TX_END

Text00d5: ; 37a3a (d:7a3a)
	db TX_START,"A Transmission Error occured.",TX_END

Text00d6: ; 37a59 (d:7a59)
	db TX_START,"Back Up is broken.",TX_END

Text00d7: ; 37a6d (d:7a6d)
	db TX_START,"Error No. 02:\n"
	db "Printer is not connected.",TX_END

Text00d8: ; 37a96 (d:7a96)
	db TX_START,"Error No. 01:\n"
	db "Batteries have lost their charge.",TX_END

Text00d9: ; 37ac7 (d:7ac7)
	db TX_START,"Error No. 03:\n"
	db "Printer paper is jammed.",TX_END

Text00da: ; 37aef (d:7aef)
	db TX_START,"Error No. 02:\n"
	db "Check cable or printer switch.",TX_END

Text00db: ; 37b1d (d:7b1d)
	db TX_START,"Error No. 04:\n"
	db "Printer Packet Error.",TX_END

Text00dc: ; 37b42 (d:7b42)
	db TX_START,"Printing was interrupted.",TX_END

Text00dd: ; 37b5d (d:7b5d)
	db TX_START,"Card Pop! cannot be played\n"
	db "with the Game Boy.\n"
	db "Please use a\n"
	db "Game Boy Color.",TX_END

Text00de: ; 37ba9 (d:7ba9)
	db TX_START,"Sand-attack check!\n"
	db "If Tails, Attack is unsuccessful.",TX_END

Text00df: ; 37bdf (d:7bdf)
	db TX_START,"Smokescreen check!\n"
	db "If Tails, Attack is unsuccessful.",TX_END

Text00e0: ; 37c15 (d:7c15)
	db TX_START,"Paralysis check!\n"
	db "If Heads, opponent is Paralyzed.",TX_END

Text00e1: ; 37c48 (d:7c48)
	db TX_START,"Sleep check!\n"
	db "If Heads, opponent becomes Asleep.",TX_END

Text00e2: ; 37c79 (d:7c79)
	db TX_START,"Poison check!\n"
	db "If Heads, opponent is Poisoned.",TX_END

Text00e3: ; 37ca8 (d:7ca8)
	db TX_START,"Confusion check! If Heads,\n"
	db "opponent becomes Confused.",TX_END

Text00e4: ; 37cdf (d:7cdf)
	db TX_START,"Venom Powder check! If Heads,\n"
	db "opponent is Poisoned & Confused.",TX_END

Text00e5: ; 37d1f (d:7d1f)
	db TX_START,"If Tails,  your Pok`mon\n"
	db "becomes Confused.",TX_END

Text00e6: ; 37d4a (d:7d4a)
	db TX_START,"Damage check!\n"
	db "If Tails, no damage!!!",TX_END

Text00e7: ; 37d70 (d:7d70)
	db TX_START,"If Heads,\n"
	db "Draw 1 card from Deck!",TX_END

Text00e8: ; 37d92 (d:7d92)
	db TX_START,"Flip until Tails appears.\n"
	db "10 damage for each Heads!!!",TX_END

Text00e9: ; 37dc9 (d:7dc9)
	db TX_START,"If Heads, + 10 damage!\n"
	db "If Tails, +10 damage to yourself!",TX_END

Text00ea: ; 37e03 (d:7e03)
	db TX_START,"10 damage to opponent's Bench if\n"
	db "Heads, damage to yours if Tails.",TX_END

Text00eb: ; 37e46 (d:7e46)
	db TX_START,"If Heads, change opponent's\n"
	db "Active Pok`mon.",TX_END

Text00ec: ; 37e73 (d:7e73)
	db TX_START,"If Heads,\n"
	db "Heal is successful.",TX_END

Text00ed: ; 37e92 (d:7e92)
	db TX_START,"If Tails, ",TX_RAM3," damage\n"
	db "to yourself, too.",TX_END

Text00ee: ; 37eb8 (d:7eb8)
	db TX_START,"Success check!!!\n"
	db "If Heads, Attack is successful!",TX_END

Text00ef: ; 37eea (d:7eea)
	db TX_START,"Trainer card success check!\n"
	db "If Heads, you're successful!",TX_END

Text00f0: ; 37f24 (d:7f24)
	db TX_START,"Card check!\n"
	db "If Heads, 8 cards! If Tails, 1 card!",TX_END

Text00f1: ; 37f56 (d:7f56)
	db TX_START,"If Heads, you will not receive\n"
	db "damage during opponent's next turn!",TX_END

Text00f2: ; 37f9a (d:7f9a)
	db TX_START,"Damage check",TX_END

Text00f3: ; 37fa8 (d:7fa8)
	db TX_START,"Damage check!\n"
	db "If Heads, +",TX_RAM3," damage!!",TX_END

Text00f4: ; 37fcd (d:7fcd)
	db TX_START,"Damage check!\n"
	db "If Heads, x ",TX_RAM3," damage!!",TX_END
