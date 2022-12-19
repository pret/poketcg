; each Auto Deck Machine has 5 slots for deck configurations
; each entry in an Auto Deck Machine consists of a card list
; (see data/auto_deck_card_lists.asm) and two text IDs
; for the corresponding deck name and description/flavor text

MACRO auto_deck
	dw \1 ; deck card list
	tx \2 ; deck name text ID
	tx \3 ; deck description text ID
ENDM

AutoDeckMachineEntries:
	table_width 6, AutoDeckMachineEntries

; Fighting Auto Deck Machine
	auto_deck AllFightingPokemonCardList,   AllFightingPokemonText,   AllFightingPokemonDescriptionText
	auto_deck BenchAttackCardList,          BenchAttackText,          BenchAttackDescriptionText
	auto_deck BattleContestCardList,        BattleContestText,        BattleContestDescriptionText
	auto_deck HeatedBattleCardList,         HeatedBattleText,         HeatedBattleDescriptionText
	auto_deck FirstStrikeCardList,          FirstStrikeText,          FirstStrikeDescriptionText

; Rock Auto Deck Machine
	auto_deck SqueakingMouseCardList,       SqueakingMouseText,       SqueakingMouseDescriptionText
	auto_deck GreatQuakeCardList,           GreatQuakeText,           GreatQuakeDescriptionText
	auto_deck BoneAttackCardList,           BoneAttackText,           BoneAttackDescriptionText
	auto_deck ExcavationCardList,           ExcavationText,           ExcavationDescriptionText
	auto_deck RockCrusherCardList,          RockCrusherText,          RockCrusherDescriptionText

; Water Auto Deck Machine
	auto_deck BlueWaterCardList,            BlueWaterText,            BlueWaterDescriptionText
	auto_deck OnTheBeachCardList,           OnTheBeachText,           OnTheBeachDescriptionText
	auto_deck ParalyzeCardList,             ParalyzeText,             ParalyzeDescriptionText
	auto_deck EnergyRemovalCardList,        EnergyRemovalText,        EnergyRemovalDescriptionText
	auto_deck RainDancerCardList,           RainDancerText,           RainDancerDescriptionText

; Lightning Auto Deck Machine
	auto_deck CutePokemonCardList,          CutePokemonText,          CutePokemonDescriptionText
	auto_deck PokemonFluteCardList,         PokemonFluteText,         PokemonFluteDescriptionText
	auto_deck YellowFlashCardList,          YellowFlashText,          YellowFlashDescriptionText
	auto_deck ElectricShockCardList,        ElectricShockText,        ElectricShockDescriptionText
	auto_deck ZappingSelfdestructCardList,  ZappingSelfdestructText,  ZappingSelfdestructDescriptionText

; Grass Auto Deck Machine
	auto_deck InsectCollectionCardList,     InsectCollectionText,     InsectCollectionDescriptionText
	auto_deck JungleCardList,               JungleText,               JungleDescriptionText
	auto_deck FlowerGardenCardList,         FlowerGardenText,         FlowerGardenDescriptionText
	auto_deck KaleidoscopeCardList,         KaleidoscopeText,         KaleidoscopeDescriptionText
	auto_deck FlowerPowerCardList,          FlowerPowerText,          FlowerPowerDescriptionText

; Psychic Auto Deck Machine
	auto_deck PsychicPowerCardList,         PsychicPowerText,         PsychicPowerDescriptionText
	auto_deck DreamEaterHaunterCardList,    DreamEaterHaunterText,    DreamEaterHaunterDescriptionText
	auto_deck ScavengingSlowbroCardList,    ScavengingSlowbroText,    ScavengingSlowbroDescriptionText
	auto_deck StrangePowerCardList,         StrangePowerText,         StrangePowerDescriptionText
	auto_deck StrangePsyshockCardList,      StrangePsyshockText,      StrangePsyshockDescriptionText

; Science Auto Deck Machine
	auto_deck LovelyNidoranCardList,        LovelyNidoranText,        LovelyNidoranDescriptionText
	auto_deck ScienceCorpsCardList,         ScienceCorpsText,         ScienceCorpsDescriptionText
	auto_deck FlyinPokemonCardList,         FlyinPokemonText,         FlyinPokemonDescriptionText
	auto_deck PoisonCardList,               PoisonText,               PoisonDescriptionText
	auto_deck WondersOfScienceCardList,     WondersOfScienceText,     WondersOfScienceDescriptionText

; Fire Auto Deck Machine
	auto_deck ReplaceEmAllCardList,         ReplaceEmAllText,         ReplaceEmAllDescriptionText
	auto_deck ChariSaurCardList,            ChariSaurText,            ChariSaurDescriptionText
	auto_deck TrafficLightCardList,         TrafficLightText,         TrafficLightDescriptionText
	auto_deck FirePokemonCardList,          FirePokemonDeckText,      FirePokemonDescriptionText
	auto_deck FireChargeCardList,           FireChargeText,           FireChargeDescriptionText

; Auto Deck Machine
	auto_deck CharmanderAndFriendsCardList, CharmanderAndFriendsText, CharmanderAndFriendsDescriptionText
	auto_deck SquirtleAndFriendsCardList,   SquirtleAndFriendsText,   SquirtleAndFriendsDescriptionText
	auto_deck BulbasaurAndFriendsCardList,  BulbasaurAndFriendsText,  BulbasaurAndFriendsDescriptionText
	auto_deck PsychicMachampCardList,       PsychicMachampText,       PsychicMachampDescriptionText
	auto_deck WaterBeetleCardList,          WaterBeetleText,          WaterBeetleDescriptionText

; Legendary Auto Deck Machine
	auto_deck LegendaryMoltresCardList,     LegendaryMoltresText,     LegendaryMoltresDescriptionText
	auto_deck LegendaryZapdosCardList,      LegendaryZapdosText,      LegendaryZapdosDescriptionText
	auto_deck LegendaryArticunoCardList,    LegendaryArticunoText,    LegendaryArticunoDescriptionText
	auto_deck LegendaryDragoniteCardList,   LegendaryDragoniteText,   LegendaryDragoniteDescriptionText
	auto_deck MysteriousPokemonCardList,    MysteriousPokemonText,    MysteriousPokemonDescriptionText

	assert_table_length NUM_DECK_MACHINE_SLOTS * NUM_DECK_MACHINES
