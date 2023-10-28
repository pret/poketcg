; Objects around maps that can be interacted with but are not represented
; by NPCs. Things like Deck Machines and the PCs.
; Format:
; Direction you need to face, X coord, Y coord
; Routine that gets called when you hit A in front of it
; Object Name, and Object default Text
MasonLabObjects:
	db NORTH, 18, 2
	dw PrintInteractableObjectText
	tx WhatIsADeckBookText
	tx WhatIsADeckBookName

	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx CardsVol1BookText
	tx CardsVol1BookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx CardsVol2BookText
	tx CardsVol2BookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx CardsVol3BookText
	tx CardsVol3BookName

	db NORTH, 20, 14
	dw PrintInteractableObjectText
	tx WinOrLossOfAMatchVol1BookText
	tx WinOrLossOfAMatchVol1BookName

	db NORTH, 22, 14
	dw PrintInteractableObjectText
	tx WinOrLossOfAMatchVol2BookText
	tx WinOrLossOfAMatchVol2BookName

	db NORTH, 24, 14
	dw PrintInteractableObjectText
	tx WinOrLossOfAMatchVol3BookText
	tx WinOrLossOfAMatchVol3BookName

	db NORTH, 2, 2
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db $ff


DeckMachineRoomObjects:
	db NORTH, 2, 2
	dw Script_d932
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 4, 2
	dw Script_d932
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 2
	dw Script_d93f
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 8, 2
	dw Script_d93f
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 10, 2
	dw Script_d995
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 12, 2
	dw Script_d995
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 14, 2
	dw Script_d9c2
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 16, 2
	dw Script_d9c2
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 18, 2
	dw Script_d9ef
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 20, 2
	dw Script_d9ef
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 14, 10
	dw Script_da1c
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 16, 10
	dw Script_da1c
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 18, 10
	dw Script_da49
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 20, 10
	dw Script_da49
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 14, 18
	dw Script_da76
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 16, 18
	dw Script_da76
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 18, 18
	dw Script_daa3
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 20, 18
	dw Script_daa3
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 2, 18
	dw Script_dad0
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 4, 18
	dw Script_dad0
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db $ff


IshiharasHouseObjects:
	db NORTH, 6, 2
	dw PrintInteractableObjectText
	tx CombosBookText
	tx CombosBookName

	db NORTH, 8, 2
	dw PrintInteractableObjectText
	tx EnergyTransBookText
	tx EnergyTransBookName

	db NORTH, 10, 2
	dw PrintInteractableObjectText
	tx ToxicGasBookText
	tx ToxicGasBookName

	db NORTH, 12, 2
	dw PrintInteractableObjectText
	tx RainDanceBookText
	tx RainDanceBookName

	db NORTH, 14, 2
	dw PrintInteractableObjectText
	tx SelfdestructBookText
	tx SelfdestructBookName

	db NORTH, 16, 2
	dw PrintInteractableObjectText
	tx DamageSwapBookText
	tx DamageSwapBookName

	db NORTH, 2, 12
	dw PrintInteractableObjectText
	tx HyperBeamBookText
	tx HyperBeamBookName

	db NORTH, 4, 12
	dw PrintInteractableObjectText
	tx PrehistoricPowerBookText
	tx PrehistoricPowerBookName

	db NORTH, 6, 12
	dw PrintInteractableObjectText
	tx PhantomCardsBookText
	tx PhantomCardsBookName

	db NORTH, 12, 12
	dw PrintInteractableObjectText
	tx WeaknessAndResistanceBookText
	tx WeaknessAndResistanceBookName

	db NORTH, 14, 12
	dw PrintInteractableObjectText
	tx DrawingDesiredCardsBookText
	tx DrawingDesiredCardsBookName

	db NORTH, 16, 12
	dw PrintInteractableObjectText
	tx RetreatingBookText
	tx RetreatingBookName

	db $ff


FightingClubLobbyObjects:
	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx FightingPokemonBookText
	tx FightingPokemonBookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx FightingPokemonAndCombosBookText
	tx FightingPokemonAndCombosBookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx DoubleColorlessEnergyBookText
	tx DoubleColorlessEnergyBookName

	db NORTH, 2, 8
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 6
	dw Script_fc52
	tx PlaceholderMessageText
	tx ClerkNPCName

	db NORTH, 10, 6
	dw Func_fc7a
	tx PlaceholderMessageText
	tx ClerkNPCName

	db $ff


RockClubLobbyObjects:
	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx RockPokemonBookText
	tx RockPokemonBookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx WinningWithFightingPokemonBookText
	tx WinningWithFightingPokemonBookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx BasicPokemonBookText
	tx BasicPokemonBookName

	db NORTH, 2, 8
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 6
	dw Script_fc52
	tx PlaceholderMessageText
	tx ClerkNPCName

	db NORTH, 10, 6
	dw Func_fc7a
	tx PlaceholderMessageText
	tx ClerkNPCName

	db $ff


WaterClubLobbyObjects:
	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx WaterPokemonBookText
	tx WaterPokemonBookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx WaterPokemonAttacksBookText
	tx WaterPokemonAttacksBookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx ParalyzeBookText
	tx ParalyzeBookName

	db NORTH, 2, 8
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 6
	dw Script_fc52
	tx PlaceholderMessageText
	tx ClerkNPCName

	db NORTH, 10, 6
	dw Func_fc7a
	tx PlaceholderMessageText
	tx ClerkNPCName

	db $ff


LightningClubLobbyObjects:
	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx LightningPokemonBookText
	tx LightningPokemonBookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx EnergyCardsBookText
	tx EnergyCardsBookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx CardPopBookText
	tx CardPopBookName

	db NORTH, 2, 8
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 6
	dw Script_fc52
	tx PlaceholderMessageText
	tx ClerkNPCName

	db NORTH, 10, 6
	dw Func_fc7a
	tx PlaceholderMessageText
	tx ClerkNPCName

	db $ff


GrassClubLobbyObjects:
	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx GrassPokemonBookText
	tx GrassPokemonBookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx PoisonBookText
	tx PoisonBookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx GrassPokemonPokemonBreederBookText
	tx GrassPokemonPokemonBreederBookName

	db NORTH, 2, 8
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 6
	dw Script_fc52
	tx PlaceholderMessageText
	tx ClerkNPCName

	db NORTH, 10, 6
	dw Func_fc7a
	tx PlaceholderMessageText
	tx ClerkNPCName

	db $ff


PsychicClubLobbyObjects:
	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx PsychicPokemonBookText
	tx PsychicPokemonBookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx SleepBookText
	tx SleepBookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx PokemonPowerBookText
	tx PokemonPowerBookName

	db NORTH, 2, 8
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 6
	dw Script_fc52
	tx PlaceholderMessageText
	tx ClerkNPCName

	db NORTH, 10, 6
	dw Func_fc7a
	tx PlaceholderMessageText
	tx ClerkNPCName

	db $ff


ScienceClubLobbyObjects:
	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx ScienceClubPokemonBookText
	tx ScienceClubPokemonBookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx ConfusionBookText
	tx ConfusionBookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx UsefulButtonsBookText
	tx UsefulButtonsBookName

	db NORTH, 2, 8
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 6
	dw Script_fc52
	tx PlaceholderMessageText
	tx ClerkNPCName

	db NORTH, 10, 6
	dw Func_fc7a
	tx PlaceholderMessageText
	tx ClerkNPCName

	db $ff


FireClubLobbyObjects:
	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx FirePokemonBookText
	tx FirePokemonBookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx FirePokemonAttacksBookText
	tx FirePokemonAttacksBookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx OriginalGameBoyCardsBookText
	tx OriginalGameBoyCardsBookName

	db NORTH, 2, 8
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 6
	dw Script_fc52
	tx PlaceholderMessageText
	tx ClerkNPCName

	db NORTH, 10, 6
	dw Func_fc7a
	tx PlaceholderMessageText
	tx ClerkNPCName

	db $ff


ChallengeHallLobbyObjects:
	db NORTH, 20, 2
	dw PrintInteractableObjectText
	tx ColorlessPokemonBookText
	tx ColorlessPokemonBookName

	db NORTH, 22, 2
	dw PrintInteractableObjectText
	tx DragonPokemonBookText
	tx DragonPokemonBookName

	db NORTH, 24, 2
	dw PrintInteractableObjectText
	tx BirdPokemonBookText
	tx BirdPokemonBookName

	db NORTH, 2, 8
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 6, 6
	dw Script_fc52
	tx PlaceholderMessageText
	tx ClerkNPCName

	db NORTH, 10, 6
	dw Func_fc7a
	tx PlaceholderMessageText
	tx ClerkNPCName

	db $ff


PokemonDomeEntranceObjects:
	db NORTH, 2, 2
	dw PrintInteractableObjectText
	tx LegendaryPokemonCardsVol1BookText
	tx LegendaryPokemonCardsVol1BookName

	db NORTH, 4, 2
	dw PrintInteractableObjectText
	tx LegendaryPokemonCardsVol2BookText
	tx LegendaryPokemonCardsVol2BookName

	db NORTH, 6, 2
	dw PrintInteractableObjectText
	tx LegendaryPokemonCardsVol3BookText
	tx LegendaryPokemonCardsVol3BookName

	db NORTH, 2, 8
	dw PrintInteractableObjectText
	tx LegendaryPokemonCardsVol4BookText
	tx LegendaryPokemonCardsVol4BookName

	db NORTH, 4, 8
	dw PrintInteractableObjectText
	tx TheGrandMastersBookText
	tx TheGrandMastersBookName

	db NORTH, 6, 8
	dw PrintInteractableObjectText
	tx MasterMedalsBookText
	tx MasterMedalsBookName

	db NORTH, 18, 0
	dw Script_f631
	tx PlateOfLegendsText
	tx PlateOfLegendsName

	db NORTH, 20, 0
	dw Script_f631
	tx PlateOfLegendsText
	tx PlateOfLegendsName

	db NORTH, 22, 0
	dw Script_f6af
	tx MysteriousVoiceDoorNotEnoughMedalsText
	tx MysteriousVoiceDoorName

	db NORTH, 24, 0
	dw Script_f6af
	tx MysteriousVoiceDoorNotEnoughMedalsText
	tx MysteriousVoiceDoorName

	db NORTH, 28, 2
	dw PCMenu
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db $ff


HallOfHonorObjects:
	; Legendary Cards
	db NORTH, 10, 10
	dw Script_fbf1
	dw NULL
	dw NULL

	; Legendary Cards
	db NORTH, 12, 10
	dw Script_fbf1
	dw NULL
	dw NULL

	db NORTH, 10, 2
	dw Script_fbe1
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db NORTH, 12, 2
	dw Script_fbe1
	tx PlaceholderMessageText
	tx PokemonTradingCards101Text

	db $ff
