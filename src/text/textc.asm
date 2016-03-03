DamageSwapDescription: ; 60000 (18:4000)
	db TX_START,"As often as you like during your\n"
	db "turn (before your attack), you may\n"
	db "move 1 damage counter from 1 of your\n"
	db "Pok`mon to another as long as you\n"
	db "don't Knock Out that Pok`mon.\n"
	db "This power can't be used if Alakazam\n"
	db "is Asleep, Confused, or Paralyzed.",TX_END

AlakazamDescription: ; 600f2 (18:40f2)
	db TX_START,"Its brain can outperform a\n"
	db "supercomputer. Its intelligence\n"
	db "quotient is said to be 5000.",TX_END

SlowpokeName: ; 6014b (18:414b)
	db TX_START,"Slowpoke",TX_END

SlowpokesAmnesiaDescription: ; 60155 (18:4155)
	db TX_START,"Choose 1 of the Defending Pok`mon's\n"
	db "attacks. That Pok`mon can't use\n"
	db "that attack during your opponent's\n"
	db "next turn.",TX_END

SlowpokeKind: ; 601c8 (18:41c8)
	db TX_START,"Dopey",TX_END

Slowpoke1Description: ; 601cf (18:41cf)
	db TX_START,"Incredibly slow and dopey. It takes\n"
	db "5 seconds for it to feel pain when\n"
	db "under attack.",TX_END

SpacingOutName: ; 60225 (18:4225)
	db TX_START,"Spacing Out",TX_END

SpacingOutDescription: ; 60232 (18:4232)
	db TX_START,"Flip a coin. If heads, remove a\n"
	db "damage counter from Slowpoke. This\n"
	db "attack can't be used if Slowpoke\n"
	db "has no damage counters on it.",TX_END

ScavengeName: ; 602b5 (18:42b5)
	db TX_START,"Scavenge",TX_END

ScavengeDescription: ; 602bf (18:42bf)
	db TX_START,"Discard 1 ",TX_PSYCHIC," Energy card attached\n"
	db "to Slowpoke in order to use this\n"
	db "attack. Put a Trainer card from your\n"
	db "discard pile into your hand.",TX_END

SlowbroName: ; 60345 (18:4345)
	db TX_START,"Slowbro",TX_END

StrangeBehaviorName: ; 6034e (18:434e)
	db TX_START,"Strange Behavior",TX_END

StrangeBehaviorDescription: ; 60360 (18:4360)
	db TX_START,"As often as you like during your\n"
	db "turn (before your attack), you may\n"
	db "move 1 damage counter from 1 of your\n"
	db "Pok`mon to Slowbro as long as you\n"
	db "don't Knock Out Slowbro. This power\n"
	db "can't be used if Slowbro is Asleep,\n"
	db "Confused, or Paralyzed.",TX_END

SlowbroKind: ; 6044c (18:444c)
	db TX_START,"Hermitcrab",TX_END

SlowbroDescription: ; 60458 (18:4458)
	db TX_START,"The Shellder that is latched onto\n"
	db "Slowpoke's tail is said to feed on\n"
	db "the host's left-over scraps.",TX_END

GastlyName: ; 604bb (18:44bb)
	db TX_START,"Gastly",TX_END

SleepingGasName: ; 604c3 (18:44c3)
	db TX_START,"Sleeping Gas",TX_END

MayInflictSleepDescription: ; 604d1 (18:44d1)
	db TX_START,"Flip a coin. If heads, the Defending\n"
	db "Pok`mon is now Asleep.",TX_END

DestinyBondName: ; 6050e (18:450e)
	db TX_START,"Destiny Bond",TX_END

DestinyBondDescription: ; 6051c (18:451c)
	db TX_START,"Discard 1 ",TX_PSYCHIC," Energy card attached to\n"
	db "Gastly in order to use this attack.\n"
	db "If a Pok`mon Knocks Out Gastly\n"
	db "during your opponent's next turn,\n"
	db "Knock Out that Pok`mon.",TX_END

GastlyKind: ; 605bf (18:45bf)
	db TX_START,"Gas",TX_END

Gastly1Description: ; 605c4 (18:45c4)
	db TX_START,"Almost invisible, this gaseous\n"
	db "Pok`mon cloaks the target and puts\n"
	db "it to sleep without notice.",TX_END

LickName: ; 60623 (18:4623)
	db TX_START,"Lick",TX_END

EnergyConversionName: ; 60629 (18:4629)
	db TX_START,"Energy Conversion",TX_END

EnergyConversionDescription: ; 6063c (18:463c)
	db TX_START,"Put up to 2 Energy cards from your\n"
	db "discard pile into your hand. Gastly\n"
	db "does 10 damage to itself.",TX_END

Gastly2Description: ; 6069e (18:469e)
	db TX_START,"A mysterious Pok`mon. Some say it is\n"
	db "a lifeform from another dimension,\n"
	db "while others believe it is formed\n"
	db "from smog.",TX_END

HaunterName: ; 60714 (18:4714)
	db TX_START,"Haunter",TX_END

TransparencyName: ; 6071d (18:471d)
	db TX_START,"Transparency",TX_END

TransparencyDescription: ; 6072b (18:472b)
	db TX_START,"Whenever an attack does anything to\n"
	db "Haunter, flip a coin. If heads,\n"
	db "prevent all effects of that attack,\n"
	db "including damage, done to Haunter.\n"
	db "This power stops working while\n"
	db "Haunter is Asleep, Confused, or\n"
	db "Paralyzed.",TX_END

NightmareName: ; 60801 (18:4801)
	db TX_START,"Nightmare",TX_END

HaunterDescription: ; 6080c (18:480c)
	db TX_START,"Because of its ability to slip\n"
	db "through block walls, it is said to\n"
	db "be from another dimension.",TX_END

DreamEaterName: ; 6086a (18:486a)
	db TX_START,"Dream Eater",TX_END

DreamEaterDescription: ; 60877 (18:4877)
	db TX_START,"You can't use this attack unless\n"
	db "the Defending Pok`mon is Asleep.",TX_END

GengarName: ; 608ba (18:48ba)
	db TX_START,"Gengar",TX_END

CurseName: ; 608c2 (18:48c2)
	db TX_START,"Curse",TX_END

CurseDescription: ; 608c9 (18:48c9)
	db TX_START,"Once during your turn (before your\n"
	db "attack), you may move 1 damage\n"
	db "counter from 1 of your opponent's\n"
	db "Pok`mon to another (even if it would\n"
	db "Knock Out the other Pok`mon).\n"
	db "This power can't be used if Gengar\n"
	db "is Asleep, Confused, or Paralyzed.",TX_END

DarkMindName: ; 609b7 (18:49b7)
	db TX_START,"Dark Mind",TX_END

DarkMindDescription: ; 609c2 (18:49c2)
	db TX_START,"If your opponent has any Benched\n"
	db "Pok`mon, choose 1 of them and this\n"
	db "attack does 10 damage to it.\n"
	db "(Don't apply Weakness and Resistance\n"
	db "for Benched Pok`mon.)",TX_END

GengarKind: ; 60a5f (18:4a5f)
	db TX_START,"Shadow",TX_END

GengarDescription: ; 60a67 (18:4a67)
	db TX_START,"Under a full moon, this Pok`mon\n"
	db "likes to mimic the shadows of people\n"
	db "and laugh at their fright.",TX_END

DrowzeeName: ; 60ac8 (18:4ac8)
	db TX_START,"Drowzee",TX_END

PoundName: ; 60ad1 (18:4ad1)
	db TX_START,"Pound",TX_END

DrowzeeDescription: ; 60ad8 (18:4ad8)
	db TX_START,"Puts enemies to sleep, then eats\n"
	db "their dreams. Occasionally gets sick\n"
	db "from eating bad dreams.",TX_END

HypnoName: ; 60b37 (18:4b37)
	db TX_START,"Hypno",TX_END

ProphecyName: ; 60b3e (18:4b3e)
	db TX_START,"Prophecy",TX_END

ProphecyDescription: ; 60b48 (18:4b48)
	db TX_START,"Look at up to 3 cards from the top\n"
	db "of either player's deck and\n"
	db "rearrange them as you like.",TX_END

HypnoDescription: ; 60ba4 (18:4ba4)
	db TX_START,"When it locks eyes with an enemy,\n"
	db "it will use a mix of psi moves such\n"
	db "as Hypnosis and Confusion.",TX_END

MrMimeName: ; 60c06 (18:4c06)
	db TX_START,"Mr. Mime",TX_END

InvisibleWallName: ; 60c10 (18:4c10)
	db TX_START,"Invisible Wall",TX_END

InvisibleWallDescription: ; 60c20 (18:4c20)
	db TX_START,"Whenever an attack (including your\n"
	db "own) does 30 or more damage to Mr.\n"
	db "Mime (after applying Weakness and\n"
	db "Resistance), prevent that damage.\n"
	db "(Any other effects of attacks still\n"
	db "happen.)",TX_END

InvisibleWallDescriptionCont: ; 60cd8 (18:4cd8)
	db TX_START,"This power can't be used if Mr. Mime\n"
	db "is Asleep, Confused, or Paralyzed.",TX_END

MeditateName: ; 60d21 (18:4d21)
	db TX_START,"Meditate",TX_END

MrMimesMeditateDescription: ; 60d2b (18:4d2b)
	db TX_START,"Does 10 damage plus 10 more damage\n"
	db "for each damage counter on the\n"
	db "Defending Pok`mon.",TX_END

MrMimeKindOrBarrierName: ; 60d81 (18:4d81)
	db TX_START,"Barrier",TX_END

MrMimeDescription: ; 60d8a (18:4d8a)
	db TX_START,"If interrupted while miming, it will\n"
	db "slap around the enemy with its broad\n"
	db "hands.",TX_END

JynxName: ; 60ddc (18:4ddc)
	db TX_START,"Jynx",TX_END

DoubleAttackX10Description: ; 60de2 (18:4de2)
	db TX_START,"Flip 2 coins. This attack does 10\n"
	db "damage times the number of heads.",TX_END

JynxsMeditateDescription: ; 60e27 (18:4e27)
	db TX_START,"Does 20 damage plus 10 more damage\n"
	db "for each damage counter on the\n"
	db "Defending Pok`mon.",TX_END

JynxKind: ; 60e7d (18:4e7d)
	db TX_START,"Human Shape",TX_END

JynxDescription: ; 60e8a (18:4e8a)
	db TX_START,"Merely by meditating, the Pok`mon\n"
	db "launches a powerful psychic energy\n"
	db "attack.",TX_END

MewtwoName: ; 60ed8 (18:4ed8)
	db TX_START,"Mewtwo",TX_END

PsychicName: ; 60ee0 (18:4ee0)
	db TX_START,"Psychic",TX_END

PsychicDescription: ; 60ee9 (18:4ee9)
	db TX_START,"Does 10 damage plus 10 more damage\n"
	db "for each Energy card attached to the\n"
	db "Defending Pok`mon.",TX_END

BarrierDescription: ; 60f45 (18:4f45)
	db TX_START,"Discard 1 ",TX_PSYCHIC," Energy card attached to\n"
	db "Mewtwo in order to use this attack.\n"
	db "During your opponent's next turn,\n"
	db "prevent all effects of attacks,\n"
	db "including damage, done to Mewtwo.",TX_END

MewtwoKind: ; 60ff3 (18:4ff3)
	db TX_START,"Genetic",TX_END

Mewtwo1Description: ; 60ffc (18:4ffc)
	db TX_START,"A scientist created this Pok`mon\n"
	db "after years of horrific\n"
	db "gene-splicing and DNA engineering\n"
	db "experiments.",TX_END

EnergyAbsorptionName: ; 61065 (18:5065)
	db TX_START,"Energy Absorption",TX_END

EnergyAbsorptionDescription: ; 61078 (18:5078)
	db TX_START,"Choose up to 2 Energy cards from\n"
	db "your discard pile and attach them\n"
	db "to Mewtwo.",TX_END

PsyburnName: ; 610c7 (18:50c7)
	db TX_START,"Psyburn",TX_END

Mewtwo2Description: ; 610d0 (18:50d0)
	db TX_START,"Years of genetic experiments\n"
	db "resulted in the creation of this\n"
	db "never-before-seen violent Pok`mon.",TX_END

MewName: ; 61132 (18:5132)
	db TX_START,"Mew",TX_END

NeutralizingShieldName: ; 61137 (18:5137)
	db TX_START,"Neutralizing Shield",TX_END

NeutralizingShieldDescription: ; 6114c (18:514c)
	db TX_START,"Prevent all effects of attacks,\n"
	db "including damage, done to Mew by\n"
	db "evolved Pok`mon (excluding your\n"
	db "own). This power stops working while\n"
	db "Mew is Asleep, Confused, or\n"
	db "Paralyzed.",TX_END

MewKind: ; 611fa (18:51fa)
	db TX_START,"New Species",TX_END

Mew1Description: ; 61207 (18:5207)
	db TX_START,"So rare that it is still said to be\n"
	db "a mirage by many experts. Only a few\n"
	db "people have seen it worldwide.",TX_END

MysteryAttackName: ; 61270 (18:5270)
	db TX_START,"Mystery Attack",TX_END

MysteryAttackDescription: ; 61280 (18:5280)
	db TX_START,"Does a random amount of damage to\n"
	db "the Defending Pok`mon and may cause\n"
	db "a random effect to the Defending\n"
	db "Pok`mon.",TX_END

Mew2Description: ; 612f1 (18:52f1)
	db TX_START,"When viewed through a microscope, \n"
	db "this Pok`mon's short, fine, delicate\n"
	db "hair can be seen.",TX_END

PsywaveName: ; 6134c (18:534c)
	db TX_START,"Psywave",TX_END

PsywaveDescription: ; 61355 (18:5355)
	db TX_START,"Does 10 damage times the number of\n"
	db "Energy cards attached to the\n"
	db "Defending Pok`mon.",TX_END

DevolutionBeamName: ; 613a9 (18:53a9)
	db TX_START,"Devolution Beam",TX_END

DevolutionBeamDescription: ; 613ba (18:53ba)
	db TX_START,"Choose an evolved Pok`mon (Your\n"
	db "own or your opponent's). Return\n"
	db "the highest stage evolution card\n"
	db "on that Pok`mon to Its player's\n"
	db "hand.",TX_END

PidgeyName: ; 61442 (18:5442)
	db TX_START,"Pidgey",TX_END

PidgeyKind: ; 6144a (18:544a)
	db TX_START,"Tiny Bird",TX_END

PidgeyDescription: ; 61455 (18:5455)
	db TX_START,"A common sight in forests and woods.\n"
	db "It flaps its wings at ground level\n"
	db "to kick up blinding sand.",TX_END

PidgeottoName: ; 614b8 (18:54b8)
	db TX_START,"Pidgeotto",TX_END

MirrorMoveName: ; 614c3 (18:54c3)
	db TX_START,"Mirror Move",TX_END

PidgeottosMirrorMoveDescription: ; 614d0 (18:54d0)
	db TX_START,"If Pidgeotto was attacked last turn,\n"
	db "do the final result of that attack\n"
	db "on Pidgeotto to the Defending\n"
	db "Pok`mon.",TX_END

PidgeottoKind: ; 61540 (18:5540)
	db TX_START,"Bird",TX_END

PidgeottoDescription: ; 61546 (18:5546)
	db TX_START,"Very protective of its sprawling\n"
	db "territory, this Pok`mon will\n"
	db "fiercely peck at any intruder.",TX_END

PidgeotName: ; 615a4 (18:55a4)
	db TX_START,"Pidgeot",TX_END

SlicingWindName: ; 615ad (18:55ad)
	db TX_START,"Slicing Wind",TX_END

SlicingWildDescription: ; 615bb (18:55bb)
	db TX_START,"Does 30 damage to 1 of your\n"
	db "opponent's Pok`mon chosen at random.\n"
	db "Don't apply Weakness and Resistance\n"
	db "for this attack. (Any other effects\n"
	db "that would happen after applying\n"
	db "Weakness and Resistance still\n"
	db "happen.)",TX_END

GaleName: ; 6168d (18:568d)
	db TX_START,"Gale",TX_END

GaleDescription: ; 61693 (18:5693)
	db TX_START,"Switch Pidgeot with 1 of your\n"
	db "Benched Pok`mon chosen at random.\n"
	db "If your opponent has any Benched\n"
	db "Pok`mon, switch the Defending\n"
	db "Pok`mon with 1 of them chosen at\n"
	db "random. (Do the damage before\n"
	db "switching the Pok`mon.)",TX_END

Pidgeot1Description: ; 6176a (18:576a)
	db TX_START,"This Pok`mon flies at Mach 2 speed,\n"
	db "seeking prey. Its large talons are\n"
	db "feared as wicked weapons.",TX_END

HurricaneName: ; 617cc (18:57cc)
	db TX_START,"Hurricane",TX_END

HurricaneDescription: ; 617d7 (18:57d7)
	db TX_START,"Unless this attack Knocks Out the\n"
	db "Defending Pok`mon, return the\n"
	db "Defending Pok`mon and all cards\n"
	db "attached to it to your opponent's\n"
	db "hand.",TX_END

Pidgeot2Description: ; 61860 (18:5860)
	db TX_START,"When hunting, it skims the surface\n"
	db "of water at high speed to pick off\n"
	db "unwary prey such as Magikarp.",TX_END

RattataName: ; 618c5 (18:58c5)
	db TX_START,"Rattata",TX_END

RattataKind: ; 618ce (18:58ce)
	db TX_START,"Rat",TX_END

RattataDescription: ; 618d3 (18:58d3)
	db TX_START,"Bites anything when it attacks.\n"
	db "Small and very quick, it is a common\n"
	db "sight in many places.",TX_END

RaticateName: ; 6192f (18:592f)
	db TX_START,"Raticate",TX_END

SuperFangName: ; 61939 (18:5939)
	db TX_START,"Super Fang",TX_END

SuperFangDescription: ; 61945 (18:5945)
	db TX_START,"Does damage to the Defending Pok`mon\n"
	db "equal to half the Defending\n"
	db "Pok`mon's remaining HP (rounded up\n"
	db "to the nearest 10).",TX_END

RaticateDescription: ; 619be (18:59be)
	db TX_START,"It uses its whiskers to maintain its\n"
	db "balance. It seems to slow down if\n"
	db "they are cut off.",TX_END

SpearowName: ; 61a18 (18:5a18)
	db TX_START,"Spearow",TX_END

PeckName: ; 61a21 (18:5a21)
	db TX_START,"Peck",TX_END

SpearowsMirrorMoveDescription: ; 61a27 (18:5a27)
	db TX_START,"If Spearow was attacked last turn,\n"
	db "do the final result of that attack\n"
	db "on Spearow to the Defending Pok`mon.",TX_END

SpearowDescription: ; 61a93 (18:5a93)
	db TX_START,"Eats bugs in grassy areas. It has to\n"
	db "flap its short wings at high speed\n"
	db "to stay airborne.",TX_END

FearowName: ; 61aee (18:5aee)
	db TX_START,"Fearow",TX_END

FearowsAgilityDescription: ; 61af6 (18:5af6)
	db TX_START,"Flip a coin. If heads, during your\n"
	db "opponent's next turn, prevent all\n"
	db "effects of attacks, including\n"
	db "damage, done to Fearow.",TX_END

DrillPeckName: ; 61b72 (18:5b72)
	db TX_START,"Drill Peck",TX_END

FearowKind: ; 61b7e (18:5b7e)
	db TX_START,"Beak",TX_END

FearowDescription: ; 61b84 (18:5b84)
	db TX_START,"With its huge and magnificent wings,\n"
	db "it can keep aloft without ever\n"
	db "having to land for rest.",TX_END

ClefairyName: ; 61be2 (18:5be2)
	db TX_START,"Clefairy",TX_END

SingName: ; 61bec (18:5bec)
	db TX_START,"Sing",TX_END

MetronomeName: ; 61bf2 (18:5bf2)
	db TX_START,"Metronome",TX_END

ClefairysMetronomeDescription: ; 61bfd (18:5bfd)
	db TX_START,"Choose 1 of the Defending Pok`mon's\n"
	db "attacks. Metronome copies that\n"
	db "attack except for its Energy costs.\n"
	db "(No matter what type the Defending\n"
	db "Pokemon is, Clefairy's type is\n"
	db "still Colorless.)",TX_END

ClefairyKind: ; 61cb9 (18:5cb9)
	db TX_START,"Fairy",TX_END

ClefairyDescription: ; 61cc0 (18:5cc0)
	db TX_START,"Its magical and cute appeal has many\n"
	db "admirers. It is rare and found only\n"
	db "in certain areas.",TX_END

ClefableName: ; 61d1c (18:5d1c)
	db TX_START,"Clefable",TX_END

ClefablesMetronomeDescription: ; 61d26 (18:5d26)
	db TX_START,"Choose 1 of the Defending Pok`mon's\n"
	db "attacks. Metronome copies that\n"
	db "attack except for its Energy costs.\n"
	db "(No matter what type the Defending\n"
	db "Pok`mon is, Clefable's type is\n"
	db "still Colorless.)",TX_END

ClefablesMinimizeDescription: ; 61de2 (18:5de2)
	db TX_START,"All damage done by attacks to\n"
	db "Clefable during your opponent's next\n"
	db "turn is reduced by 20 (after\n"
	db "applying Weakness and Resistance).",TX_END

ClefableDescription: ; 61e66 (18:5e66)
	db TX_START,"A timid Fairy Pok`mon that is rarely\n"
	db "seen. It will run and hide the\n"
	db "moment it senses people.",TX_END

JigglypuffName: ; 61ec4 (18:5ec4)
	db TX_START,"Jigglypuff",TX_END

FirstAidName: ; 61ed0 (18:5ed0)
	db TX_START,"First Aid",TX_END

FirstAidDescription: ; 61edb (18:5edb)
	db TX_START,"Remove 1 damage counter from\n"
	db "Jigglypuff.",TX_END

DoubleEdgeName: ; 61f05 (18:5f05)
	db TX_START,"Double-edge",TX_END

JigglypuffsDoubleEdgeDescription: ; 61f12 (18:5f12)
	db TX_START,"Jigglypuff does 20 damage to itself.",TX_END

JigglypuffKind: ; 61f38 (18:5f38)
	db TX_START,"Balloon",TX_END

Jigglypuff1Description: ; 61f41 (18:5f41)
	db TX_START,"When its huge eyes light up, it\n"
	db "sings a mysteriously soothing\n"
	db "melody that lulls its enemies to\n"
	db "sleep.",TX_END

FriendshipSongName: ; 61fa8 (18:5fa8)
	db TX_START,"Friendship Song",TX_END

FriendshipSongDescription: ; 61fb9 (18:5fb9)
	db TX_START,"Flip a coin. If heads, put a Basic\n"
	db "Pok`mon card chosen at random from\n"
	db "your deck onto your Bench. (You\n"
	db "can't use this attack if your Bench\n"
	db "is full.)",TX_END

ExpandName: ; 6204e (18:604e)
	db TX_START,"Expand",TX_END

ExpandDescription: ; 62056 (18:6056)
	db TX_START,"All damage done to Jigglypuff during\n"
	db "your opponent's next turn is reduced\n"
	db "by 10 (after applying Weakness and\n"
	db "Resistance).",TX_END

Jigglypuff2Description: ; 620d1 (18:60d1)
	db TX_START,"Uses its alluring eyes to enrapture\n"
	db "its foe. It then sings a pleasing\n"
	db "melody that lulls the foe to sleep.",TX_END

LullabyName: ; 6213c (18:613c)
	db TX_START,"Lullaby",TX_END

Jigglypuff3Description: ; 62145 (18:6145)
	db TX_START,"When its huge eyes light up, it\n"
	db "sings a mysteriously soothing melody\n"
	db "that lulls its enemies to sleep.",TX_END

WigglytuffName: ; 621ac (18:61ac)
	db TX_START,"Wigglytuff",TX_END

DotheWaveName: ; 621b8 (18:61b8)
	db TX_START,"Do the Wave",TX_END

DotheWaveDescription: ; 621c5 (18:61c5)
	db TX_START,"Does 10 damage plus 10 more damage\n"
	db "for each of your Benched Pok`mon.",TX_END

WigglytuffDescription: ; 6220b (18:620b)
	db TX_START,"The body is soft and rubbery. When\n"
	db "angered, it will suck in air and\n"
	db "inflate itself to an enormous size.",TX_END

MeowthName: ; 62274 (18:6274)
	db TX_START,"Meowth",TX_END

CatPunchName: ; 6227c (18:627c)
	db TX_START,"Cat Punch",TX_END

CatPunchDescription: ; 62287 (18:6287)
	db TX_START,"Does 20 damage to 1 of your\n"
	db "opponent's Pok`mon chosen at random.\n"
	db "Don't apply Weakness and Resistance\n"
	db "for this attack. (Any other effects\n"
	db "that would happen after applying\n"
	db "Weakness and Resistance still\n"
	db "happen.)",TX_END

MeowthKind: ; 62359 (18:6359)
	db TX_START,"Scratch Cat",TX_END

Meowth1Description: ; 62366 (18:6366)
	db TX_START,"Appears to be more active at night.\n"
	db "It loves round and shiny things, so\n"
	db "it can't stop from picking them up.",TX_END

PayDayName: ; 623d3 (18:63d3)
	db TX_START,"Pay Day",TX_END

PayDayDescription: ; 623dc (18:63dc)
	db TX_START,"Flip a coin. If heads, draw a card.",TX_END

Meowth2Description: ; 62401 (18:6401)
	db TX_START,"Adores circular objects. Wanders\n"
	db "the streets on a nightly basis to\n"
	db "look for dropped loose change.",TX_END

PersianName: ; 62464 (18:6464)
	db TX_START,"Persian",TX_END

PounceName: ; 6246d (18:646d)
	db TX_START,"Pounce",TX_END

PounceDescription: ; 62475 (18:6475)
	db TX_START,"If the Defending Pok`mon attacks\n"
	db "Persian during your opponent's next\n"
	db "turn, any damage done by the attack\n"
	db "is reduced by 10 (after applying\n"
	db "Weakness and Resistance). (Benching\n"
	db "or evolving either Pok`mon ends this\n"
	db "effect.)",TX_END

PersianKind: ; 62552 (18:6552)
	db TX_START,"Classy Cat",TX_END

PersianDescription: ; 6255e (18:655e)
	db TX_START,"Although its fur has many admirers,\n"
	db "it is tough to raise as a pet\n"
	db "because of its fickle meanness.",TX_END

FarfetchdName: ; 625c1 (18:65c1)
	db TX_START,"Farfetch'd",TX_END

LeekSlapName: ; 625cd (18:65cd)
	db TX_START,"Leek Slap",TX_END

LeekSlapDescription: ; 625d8 (18:65d8)
	db TX_START,"Flip a coin. If tails, this attack\n"
	db "does nothing. Either way, you can't\n"
	db "use this attack again as long as\n"
	db "Farfetch'd stays in play (even\n"
	db "putting Farfetch'd on the Bench\n"
	db "won't let you use it again).",TX_END

PotSmashName: ; 6269d (18:669d)
	db TX_START,"Pot Smash",TX_END

FarfetchdKind: ; 626a8 (18:66a8)
	db TX_START,"Wild Duck",TX_END

FarfetchdDescription: ; 626b3 (18:66b3)
	db TX_START,"The sprig of green onions it holds\n"
	db "is its weapon. This sprig is used\n"
	db "much like a metal sword.",TX_END

DoduoName: ; 62712 (18:6712)
	db TX_START,"Doduo",TX_END

FuryAttackName: ; 62719 (18:6719)
	db TX_START,"Fury Attack",TX_END

DoduoKind: ; 62726 (18:6726)
	db TX_START,"Twin Bird",TX_END

DoduoDescription: ; 62731 (18:6731)
	db TX_START,"A bird that makes up for its poor\n"
	db "flying with its fast foot speed.\n"
	db "Leaves giant footprints.",TX_END

DodrioName: ; 6278e (18:678e)
	db TX_START,"Dodrio",TX_END

RetreatAidName: ; 62796 (18:6796)
	db TX_START,"Retreat Aid",TX_END

RetreatAidDescription: ; 627a3 (18:67a3)
	db TX_START,"As long as Dodrio is Benched, pay\n"
	db TX_COLORLESS," less to retreat your Active\n"
	db "Pok`mon.",TX_END

DodriosRageDescription: ; 627ee (18:67ee)
	db TX_START,"Does 10 damage plus 10 more damage\n"
	db "for each damage counter on Dodrio.",TX_END

DodrioKind: ; 62835 (18:6835)
	db TX_START,"Triplebird",TX_END

DodrioDescription: ; 62841 (18:6841)
	db TX_START,"Uses its three brains to execute\n"
	db "complex plans. While two heads\n"
	db "sleep, one head stays awake.",TX_END

LickitungName: ; 6289f (18:689f)
	db TX_START,"Lickitung",TX_END

TongueWrapName: ; 628aa (18:68aa)
	db TX_START,"Tongue Wrap",TX_END

LickitungKind: ; 628b7 (18:68b7)
	db TX_START,"Licking",TX_END

LickitungDescription: ; 628c0 (18:68c0)
	db TX_START,"Its tongue can be extended like a\n"
	db "chameleon's. It leaves a stinging\n"
	db "sensation when it licks enemies.",TX_END

ChanseyName: ; 62926 (18:6926)
	db TX_START,"Chansey",TX_END

ScrunchName: ; 6292f (18:692f)
	db TX_START,"Scrunch",TX_END

ScrunchDescription: ; 62938 (18:6938)
	db TX_START,"Flip a coin. If heads, prevent all\n"
	db "damage done to Chansey during your\n"
	db "opponent's next turn. (Any other\n"
	db "effects of attacks still happen.)",TX_END

ChanseysDoubleEdgeDescription: ; 629c2 (18:69c2)
	db TX_START,"Chansey does 80 damage to itself.",TX_END

ChanseyDescription: ; 629e5 (18:69e5)
	db TX_START,"A rare and elusive Pok`mon that is\n"
	db "said to bring happiness to those\n"
	db "who manage to catch it.",TX_END

KangaskhanName: ; 62a42 (18:6a42)
	db TX_START,"Kangaskhan",TX_END

FetchName: ; 62a4e (18:6a4e)
	db TX_START,"Fetch",TX_END

FetchDescription: ; 62a55 (18:6a55)
	db TX_START,"Draw a card.",TX_END

CometPunchName: ; 62a63 (18:6a63)
	db TX_START,"Comet Punch",TX_END

KangaskhanKind: ; 62a70 (18:6a70)
	db TX_START,"Parent",TX_END

KangaskhanDescription: ; 62a78 (18:6a78)
	db TX_START,"The infant rarely ventures out of\n"
	db "its mother's protective pouch until\n"
	db "it is three years old.",TX_END

TaurosName: ; 62ad6 (18:6ad6)
	db TX_START,"Tauros",TX_END

RampageName: ; 62ade (18:6ade)
	db TX_START,"Rampage",TX_END

RampageDescription: ; 62ae7 (18:6ae7)
	db TX_START,"Does 20 damage plus 10 more damage\n"
	db "for each damage counter on Tauros.\n"
	db "Flip a coin. If tails, Tauros is\n"
	db "now Confused (after doing damage).",TX_END

TaurosKind: ; 62b72 (18:6b72)
	db TX_START,"Wild Bull",TX_END

TaurosDescription: ; 62b7d (18:6b7d)
	db TX_START,"When it targets an enemy, it charges\n"
	db "furiously while whipping its body\n"
	db "with its long tails.",TX_END

DittoName: ; 62bda (18:6bda)
	db TX_START,"Ditto",TX_END

MorphName: ; 62be1 (18:6be1)
	db TX_START,"Morph",TX_END

MorphDescription: ; 62be8 (18:6be8)
	db TX_START,"Remove all damage counters from\n"
	db "Ditto. For the rest of the game,\n"
	db "replace Ditto with a copy of a Basic\n"
	db "Pok`mon card (other than Ditto)\n"
	db "chosen at random from your deck.",TX_END

MorphDescriptionCont: ; 62c90 (18:6c90)
	db TX_START,"Ditto is no longer Asleep, Confused,\n"
	db "Paralyzed, Poisoned, or anything\n"
	db "else that might be the result of an\n"
	db "attack (just as if you had evolved\n"
	db "it).",TX_END

DittoKind: ; 62d23 (18:6d23)
	db TX_START,"Transform",TX_END

DittoDescription: ; 62d2e (18:6d2e)
	db TX_START,"When it spots an enemy, its body\n"
	db "transfigures into an almost perfect\n"
	db "copy of its opponent.",TX_END

TailWagName: ; 62d8a (18:6d8a)
	db TX_START,"Tail Wag",TX_END

TailWagDescription: ; 62d94 (18:6d94)
	db TX_START,"Flip a coin. If heads, the Defending\n"
	db "Pok`mon can't attack Eevee during\n"
	db "your opponent's next turn. (Benching\n"
	db "or evolving either Pok`mon ends this\n"
	db "effect.)",TX_END

EeveeKind: ; 62e2f (18:6e2f)
	db TX_START,"Evolution",TX_END

EeveeDescription: ; 62e3a (18:6e3a)
	db TX_START,"Its genetic code is irregular.\n"
	db "It may mutate if it is exposed to\n"
	db "radiation from elemental stones.",TX_END

PorygonName: ; 62e9d (18:6e9d)
	db TX_START,"Porygon",TX_END

Conversion1Name: ; 62ea6 (18:6ea6)
	db TX_START,"Conversion 1",TX_END

Conversion1Description: ; 62eb4 (18:6eb4)
	db TX_START,"If the Defending Pok`mon has a\n"
	db "Weakness, you may change it to a\n"
	db "type of your choice other than\n"
	db "Colorless.",TX_END

Conversion2Name: ; 62f1f (18:6f1f)
	db TX_START,"Conversion 2",TX_END

Conversion2Description: ; 62f2d (18:6f2d)
	db TX_START,"Change Porygon's Resistance to a\n"
	db "type of your choice other than\n"
	db "Colorless.",TX_END

PorygonKind: ; 62f79 (18:6f79)
	db TX_START,"Virtual",TX_END

PorygonDescription: ; 62f82 (18:6f82)
	db TX_START,"A Pok`mon that consists entirely of\n"
	db "programming code. Capable of moving\n"
	db "freely in cyberspace.",TX_END

SnorlaxName: ; 62fe1 (18:6fe1)
	db TX_START,"Snorlax",TX_END

ThickSkinnedName: ; 62fea (18:6fea)
	db TX_START,"Thick Skinned",TX_END

ThickSkinnedDescription: ; 62ff9 (18:6ff9)
	db TX_START,"Snorlax can't become Asleep,\n"
	db "Confused, Paralyzed, or Poisoned.\n"
	db "This power can't be used if Snorlax\n"
	db "is already Asleep, Confused, or\n"
	db "Paralyzed.",TX_END

BodySlamName: ; 63088 (18:7088)
	db TX_START,"Body Slam",TX_END

SnorlaxKind: ; 63093 (18:7093)
	db TX_START,"Sleeping",TX_END

SnorlaxDescription: ; 6309d (18:709d)
	db TX_START,"Very lazy. Just eats and sleeps.\n"
	db "As its rotund bulk builds,\n"
	db "it becomes steadily more slothful.",TX_END

DratiniName: ; 630fd (18:70fd)
	db TX_START,"Dratini",TX_END

DratiniDescription: ; 63106 (18:7106)
	db TX_START,"Long considered a mythical Pok`mon\n"
	db "until recently, when a small colony\n"
	db "was found living underwater.",TX_END

DragonairName: ; 6316b (18:716b)
	db TX_START,"Dragonair",TX_END

SlamName: ; 63176 (18:7176)
	db TX_START,"Slam",TX_END

DragonairDescription: ; 6317c (18:717c)
	db TX_START,"A mystical Pok`mon that exudes a\n"
	db "gentle aura. Has the ability to\n"
	db "change climate conditions.",TX_END

DragoniteName: ; 631d9 (18:71d9)
	db TX_START,"Dragonite",TX_END

HealingWindName: ; 631e4 (18:71e4)
	db TX_START,"Healing Wind",TX_END

HealingWindDescription: ; 631f2 (18:71f2)
	db TX_START,"When you put Dragonite into play,\n"
	db "remove 2 damage counters from each\n"
	db "of your Pok`mon. If a Pok`mon has \n"
	db "fewer damage counters than that,\n"
	db "remove all of them from that\n"
	db "Pok`mon.",TX_END

Dragonite1Description: ; 632a2 (18:72a2)
	db TX_START,"It is said that this Pok`mon lives\n"
	db "somewhere in the sea and that it\n"
	db "flies. However, it is only a rumor.",TX_END

StepInName: ; 6330b (18:730b)
	db TX_START,"Step In",TX_END

StepInDescription: ; 63314 (18:7314)
	db TX_START,"Once during your turn (before your\n"
	db "attack), if Dragonite is on your\n"
	db "Bench, you may switch it with your\n"
	db "Active Pok`mon.",TX_END

DoubleAttackX40Description: ; 6338c (18:738c)
	db TX_START,"Flip 2 coins. This attack does 40\n"
	db "damage times the number of heads.",TX_END

DragoniteDescription: ; 633d1 (18:73d1)
	db TX_START,"An extremely rarely seen marine\n"
	db "Pok`mon. Its intelligence is said\n"
	db "to match that of humans.",TX_END

ProfessorOakName: ; 6342d (18:742d)
	db TX_START,"Professor Oak",TX_END

ProfessorOakDescription: ; 6343c (18:743c)
	db TX_START,"Discard your hand, then draw 7\n"
	db "cards.",TX_END

ImposterProfessorOakName: ; 63463 (18:7463)
	db TX_START,"Imposter Professor Oak",TX_END

ImposterProfessorOakDescription: ; 6347b (18:747b)
	db TX_START,"Your opponent shuffles his or her\n"
	db "hand into his or her deck, then\n"
	db "draws 7 cards.",TX_END

BillName: ; 634cd (18:74cd)
	db TX_START,"Bill",TX_END

BillDescription: ; 634d3 (18:74d3)
	db TX_START,"Draw 2 cards.",TX_END

MrFujiName: ; 634e2 (18:74e2)
	db TX_START,"Mr.Fuji",TX_END

MrFujiDescription: ; 634eb (18:74eb)
	db TX_START,"Choose a Pok`mon on your Bench.\n"
	db "Shuffle it and any cards attached\n"
	db "to it into your deck.",TX_END

LassName: ; 63544 (18:7544)
	db TX_START,"Lass",TX_END

LassDescription: ; 6354a (18:754a)
	db TX_START,"You and your opponent show each\n"
	db "other your hands, then shuffle all\n"
	db "the Trainer cards from your hands\n"
	db "into your decks.",TX_END

ImakuniName: ; 635c1 (18:75c1)
	db TX_START,"Imakuni?",TX_END

ImakuniDescription: ; 635cb (18:75cb)
	db TX_START,"Your Active Pok`mon is now Confused.\n"
	db "Imakuni wants you to play him as a\n"
	db "Basic Pok`mon, but you can't.\n"
	db "A mysterious creature not listed in\n"
	db "the Pok`dex. He asks kids around the\n"
	db "world,\"Who is cuter-Pikachu or me?\"",TX_END

PokemonTraderName: ; 6369f (18:769f)
	db TX_START,"Pok`mon Trader",TX_END

PokemonTraderDescription: ; 636af (18:76af)
	db TX_START,"Trade 1 of the Basic Pok`mon or\n"
	db "Evolution cards in your hand for 1\n"
	db "of the Basic Pok`mon or Evolution\n"
	db "cards from your deck. Show both\n"
	db "cards to your opponent.\n"
	db "Shuffle your deck afterward.",TX_END

PokemonBreederName: ; 6376a (18:776a)
	db TX_START,"Pok`mon Breeder",TX_END

PokemonBreederDescription: ; 6377b (18:777b)
	db TX_START,"Put a Stage 2 Evolution card from\n"
	db "your hand on the matching Basic\n"
	db "Pok`mon. You can only play this card\n"
	db "when you would be allowed to evolve\n"
	db "that Pok`mon anyway.",TX_END

ClefairyDollName: ; 6381c (18:781c)
	db TX_START,"Clefairy Doll",TX_END

ClefairyDollDescription: ; 6382b (18:782b)
	db TX_START,"Play Clefairy Doll as if it were a\n"
	db "Basic Pok`mon. While in play,\n"
	db "Clefairy Doll counts as a Pok`mon\n"
	db "(instead of a Trainer card).\n"
	db "Clefairy Doll has no attacks, can't\n"
	db "retreat, and can't be Asleep,\n"
	db "Confused, Paralyzed, or Poisoned.",TX_END

ClefairyDollDescriptionCont: ; 63910 (18:7910)
	db TX_START,"If Clefairy Doll is Knocked Out, it\n"
	db "doesn't count as a Knocked Out\n"
	db "Pok`mon. At any time during your\n"
	db "turn before your attack, you may\n"
	db "discard Clefairy Doll.\n"
	db "(Use GameBoy Pok`mon Power menu\n"
	db "option to do this.)",TX_END

MysteriousFossilDescription: ; 639e1 (18:79e1)
	db TX_START,"Play Mysterious Fossil as if it were\n"
	db "a Basic Pok`mon. While in play,\n"
	db "Mysterious Fossil counts as a\n"
	db "Pok`mon (instead of a Trainer card).\n"
	db "Mysterious Fossil has no attacks,\n"
	db "can't retreat, and can't be Asleep,\n"
	db "Confused, Paralyzed, or Poisoned.",TX_END

MysteriousFossilDescriptionCont: ; 63ad2 (18:7ad2)
	db TX_START,"If Mysterious Fossil is Knocked Out,\n"
	db "it doesn't count as a Knocked Out\n"
	db "Pok`mon. (Discard it anyway.) At any\n"
	db "time during your turn before your\n"
	db "attack, you may discard Mysterious\n"
	db "Fossil from play. (Use GameBoy Pok`-\n"
	db "mon Power menu option to do this.)",TX_END

EnergyRetrievalName: ; 63bcc (18:7bcc)
	db TX_START,"Energy Retrieval",TX_END

EnergyRetrievalDescription: ; 63bde (18:7bde)
	db TX_START,"Trade 1 of the other cards in your\n"
	db "hand for up to 2 basic Energy cards\n"
	db "from your discard pile.",TX_END

SuperEnergyRetrievalName: ; 63c3e (18:7c3e)
	db TX_START,"Super Energy Retrieval",TX_END

SuperEnergyRetrievalDescription: ; 63c56 (18:7c56)
	db TX_START,"Trade 2 of the other cards in your\n"
	db "hand for up to 4 basic Energy cards\n"
	db "from your discard pile.",TX_END

EnergySearchName: ; 63cb6 (18:7cb6)
	db TX_START,"Energy Search",TX_END

EnergySearchDescription: ; 63cc5 (18:7cc5)
	db TX_START,"Search your deck for a basic Energy\n"
	db "card and put it into your hand.\n"
	db "Shuffle your deck afterward.",TX_END

EnergyRemovalName: ; 63d27 (18:7d27)
	db TX_START,"Energy Removal",TX_END

EnergyRemovalDescription: ; 63d37 (18:7d37)
	db TX_START,"Choose 1 Energy card attached to 1\n"
	db "of your opponent's Pok`mon and\n"
	db "discard it.",TX_END

SuperEnergyRemovalName: ; 63d86 (18:7d86)
	db TX_START,"Super Energy Removal",TX_END

SuperEnergyRemovalDescription: ; 63d9c (18:7d9c)
	db TX_START,"Discard 1 Energy card attached to 1\n"
	db "of your own Pok`mon in order to\n"
	db "choose 1 of your opponent's Pok`mon\n"
	db "and up to 2 Energy cards attached\n"
	db "to it. Discard those Energy cards.",TX_END

SwitchName: ; 63e4a (18:7e4a)
	db TX_START,"Switch",TX_END

SwitchDescription: ; 63e52 (18:7e52)
	db TX_START,"Switch 1 of your Benched Pok`mon\n"
	db "with your Active Pok`mon.",TX_END

PokemonCenterName: ; 63e8e (18:7e8e)
	db TX_START,"Pok`mon Center",TX_END

PokemonCenterDescription: ; 63e9e (18:7e9e)
	db TX_START,"Remove all damage counters from all\n"
	db "of your own Pok`mon with damage\n"
	db "counters on them, then discard all\n"
	db "Energy cards attached to those\n"
	db "Pok`mon.",TX_END

PokeBallName: ; 63f2e (18:7f2e)
	db TX_START,"Pok` Ball",TX_END

PokeBallDescription: ; 63f39 (18:7f39)
	db TX_START,"Flip a coin. If heads, you may\n"
	db "search your deck for any Basic\n"
	db "Pok`mon or Evolution card. Show that\n"
	db "card to your opponent, then put it\n"
	db "into your hand. Shuffle your deck\n"
	db "afterward.",TX_END

ScoopUpName: ; 63fed (18:7fed)
	db TX_START,"Scoop Up",TX_END
