OverworldMap_PlayerMovementPaths:
	table_width 2, OverworldMap_PlayerMovementPaths
	dw OverworldMap_MasonLaboratoryPaths
	dw OverworldMap_IshiharasHousePaths
	dw OverworldMap_FightingClubPaths
	dw OverworldMap_RockClubPaths
	dw OverworldMap_WaterClubPaths
	dw OverworldMap_LightningClubPaths
	dw OverworldMap_GrassClubPaths
	dw OverworldMap_PsychicClubPaths
	dw OverworldMap_ScienceClubPaths
	dw OverworldMap_FireClubPaths
	dw OverworldMap_ChallengeHallPaths
	dw OverworldMap_PokemonDomePaths
	assert_table_length NUM_OWMAPS - 1

OverworldMap_MasonLaboratoryPaths:
	table_width 2, OverworldMap_MasonLaboratoryPaths
	dw OverworldMap_NoMovement
	dw OverworldMap_MasonLaboratoryPathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_MasonLaboratoryPathToRockClub
	dw OverworldMap_MasonLaboratoryPathToWaterClub
	dw OverworldMap_MasonLaboratoryPathToLightningClub
	dw OverworldMap_MasonLaboratoryPathToGrassClub
	dw OverworldMap_MasonLaboratoryPathToPsychicClub
	dw OverworldMap_MasonLaboratoryPathToScienceClub
	dw OverworldMap_MasonLaboratoryPathToFireClub
	dw OverworldMap_MasonLaboratoryPathToChallengeHall
	dw OverworldMap_MasonLaboratoryPathToPokemonDome
	assert_table_length NUM_OWMAPS - 1

OverworldMap_IshiharasHousePaths:
	table_width 2, OverworldMap_IshiharasHousePaths
	dw OverworldMap_IshiharasHousePathToMasonLaboratory
	dw OverworldMap_NoMovement
	dw OverworldMap_IshiharasHousePathToFightingClub
	dw OverworldMap_IshiharasHousePathToRockClub
	dw OverworldMap_IshiharasHousePathToWaterClub
	dw OverworldMap_IshiharasHousePathToLightningClub
	dw OverworldMap_IshiharasHousePathToGrassClub
	dw OverworldMap_IshiharasHousePathToPsychicClub
	dw OverworldMap_IshiharasHousePathToScienceClub
	dw OverworldMap_IshiharasHousePathToFireClub
	dw OverworldMap_IshiharasHousePathToChallengeHall
	dw OverworldMap_IshiharasHousePathToPokemonDome
	assert_table_length NUM_OWMAPS - 1

OverworldMap_FightingClubPaths:
	table_width 2, OverworldMap_FightingClubPaths
	dw OverworldMap_StraightPath
	dw OverworldMap_FightingClubPathToIshiharasHouse
	dw OverworldMap_NoMovement
	dw OverworldMap_FightingClubPathToRockClub
	dw OverworldMap_FightingClubPathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_FightingClubPathToPsychicClub
	dw OverworldMap_StraightPath
	dw OverworldMap_FightingClubPathToFireClub
	dw OverworldMap_FightingClubPathToChallengeHall
	dw OverworldMap_StraightPath
	assert_table_length NUM_OWMAPS - 1

OverworldMap_RockClubPaths:
	table_width 2, OverworldMap_RockClubPaths
	dw OverworldMap_RockClubPathToMasonLaboratory
	dw OverworldMap_RockClubPathToIshiharasHouse
	dw OverworldMap_RockClubPathToFightingClub
	dw OverworldMap_NoMovement
	dw OverworldMap_RockClubPathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_RockClubPathToGrassClub
	dw OverworldMap_StraightPath
	dw OverworldMap_RockClubPathToScienceClub
	dw OverworldMap_RockClubPathToFireClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	assert_table_length NUM_OWMAPS - 1

OverworldMap_WaterClubPaths:
	table_width 2, OverworldMap_WaterClubPaths
	dw OverworldMap_WaterClubPathToMasonLaboratory
	dw OverworldMap_WaterClubPathToIshiharasHouse
	dw OverworldMap_WaterClubPathToFightingClub
	dw OverworldMap_WaterClubPathToRockClub
	dw OverworldMap_NoMovement
	dw OverworldMap_WaterClubPathToLightningClub
	dw OverworldMap_WaterClubPathToGrassClub
	dw OverworldMap_WaterClubPathToPsychicClub
	dw OverworldMap_WaterClubPathToScienceClub
	dw OverworldMap_WaterClubPathToFireClub
	dw OverworldMap_WaterClubPathToChallengeHall
	dw OverworldMap_WaterClubPathToPokemonDome
	assert_table_length NUM_OWMAPS - 1

OverworldMap_LightningClubPaths:
	table_width 2, OverworldMap_LightningClubPaths
	dw OverworldMap_LightningClubPathToMasonLaboratory
	dw OverworldMap_LightningClubPathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_LightningClubPathToWaterClub
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath
	dw OverworldMap_LightningClubPathToPsychicClub
	dw OverworldMap_LightningClubPathToScienceClub
	dw OverworldMap_LightningClubPathToFireClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	assert_table_length NUM_OWMAPS - 1

OverworldMap_GrassClubPaths:
	table_width 2, OverworldMap_GrassClubPaths
	dw OverworldMap_GrassClubPathToMasonLaboratory
	dw OverworldMap_GrassClubPathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_GrassClubPathToRockClub
	dw OverworldMap_GrassClubPathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_GrassClubPathToChallengeHall
	dw OverworldMap_StraightPath
	assert_table_length NUM_OWMAPS - 1

OverworldMap_PsychicClubPaths:
	table_width 2, OverworldMap_PsychicClubPaths
	dw OverworldMap_PsychicClubPathToMasonLaboratory
	dw OverworldMap_PsychicClubPathToIshiharasHouse
	dw OverworldMap_PsychicClubPathToFightingClub
	dw OverworldMap_StraightPath
	dw OverworldMap_PsychicClubPathToWaterClub
	dw OverworldMap_PsychicClubPathToLightningClub
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	assert_table_length NUM_OWMAPS - 1

OverworldMap_ScienceClubPaths:
	table_width 2, OverworldMap_ScienceClubPaths
	dw OverworldMap_ScienceClubPathToMasonLaboratory
	dw OverworldMap_ScienceClubPathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_ScienceClubPathToRockClub
	dw OverworldMap_ScienceClubPathToWaterClub
	dw OverworldMap_ScienceClubPathToLightningClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath
	dw OverworldMap_ScienceClubPathToChallengeHall
	dw OverworldMap_StraightPath
	assert_table_length NUM_OWMAPS - 1

OverworldMap_FireClubPaths:
	table_width 2, OverworldMap_FireClubPaths
	dw OverworldMap_FireClubPathToMasonLaboratory
	dw OverworldMap_FireClubPathToIshiharasHouse
	dw OverworldMap_FireClubPathToFightingClub
	dw OverworldMap_FireClubPathToRockClub
	dw OverworldMap_FireClubPathToWaterClub
	dw OverworldMap_FireClubPathToLightningClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement
	dw OverworldMap_FireClubPathToChallengeHall
	dw OverworldMap_FireClubPathToPokemonDome
	assert_table_length NUM_OWMAPS - 1

OverworldMap_ChallengeHallPaths:
	table_width 2, OverworldMap_ChallengeHallPaths
	dw OverworldMap_ChallengeHallPathToMasonLaboratory
	dw OverworldMap_ChallengeHallPathToIshiharasHouse
	dw OverworldMap_ChallengeHallPathToFightingClub
	dw OverworldMap_StraightPath
	dw OverworldMap_ChallengeHallPathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_ChallengeHallPathToGrassClub
	dw OverworldMap_StraightPath
	dw OverworldMap_ChallengeHallPathToScienceClub
	dw OverworldMap_ChallengeHallPathToFireClub
	dw OverworldMap_NoMovement
	dw OverworldMap_StraightPath
	assert_table_length NUM_OWMAPS - 1

OverworldMap_PokemonDomePaths:
	table_width 2, OverworldMap_PokemonDomePaths
	dw OverworldMap_PokemonDomePathToMasonLaboratory
	dw OverworldMap_PokemonDomePathToIshiharasHouse
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_PokemonDomePathToWaterClub
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_StraightPath
	dw OverworldMap_PokemonDomePathToFireClub
	dw OverworldMap_StraightPath
	dw OverworldMap_NoMovement
	assert_table_length NUM_OWMAPS - 1

OverworldMap_IshiharasHousePathToRockClub:
OverworldMap_RockClubPathToIshiharasHouse:
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToWaterClub:
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToMasonLaboratory:
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToFireClub:
	db $2c, $28
	db $3c, $40
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToIshiharasHouse:
	db $5c, $30
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToIshiharasHouse:
	db $2c, $78
	db $3c, $68
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToMasonLaboratory:
	db $2c, $28
	db $3c, $40
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToRockClub:
	db $2c, $78
	db $3c, $68
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToMasonLaboratory:
	db $3c, $48
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToLightningClub:
OverworldMap_LightningClubPathToMasonLaboratory:
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToGrassClub:
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_GrassClubPathToMasonLaboratory:
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToPsychicClub:
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_PsychicClubPathToMasonLaboratory:
	db $5c, $48
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToScienceClub:
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_ScienceClubPathToMasonLaboratory:
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToFireClub:
	db $2c, $78
	db $3c, $68
	db $5c, $68
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToMasonLaboratory:
	db $5c, $30
	db $5c, $68
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToChallengeHall:
	db $2c, $78
	db $3c, $68
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_ChallengeHallPathToMasonLaboratory:
	db $3c, $40
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_MasonLaboratoryPathToPokemonDome:
	db $2c, $78
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_PokemonDomePathToMasonLaboratory:
	db $3c, $68
	db $2c, $78
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToFightingClub:
OverworldMap_FightingClubPathToIshiharasHouse:
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToWaterClub:
	db $2c, $28
	db $3c, $48
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToIshiharasHouse:
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $3c, $48
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToLightningClub:
OverworldMap_LightningClubPathToIshiharasHouse:
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToGrassClub:
	db $2c, $28
	db $3c, $40
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_GrassClubPathToIshiharasHouse:
	db $5c, $48
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToPsychicClub:
	db $2c, $28
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_PsychicClubPathToIshiharasHouse:
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToScienceClub:
	db $2c, $28
	db $3c, $40
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_ScienceClubPathToIshiharasHouse:
	db $5c, $48
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToChallengeHall:
	db $2c, $28
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_ChallengeHallPathToIshiharasHouse:
	db $3c, $40
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_IshiharasHousePathToPokemonDome:
	db $2c, $28
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_PokemonDomePathToIshiharasHouse:
	db $3c, $48
	db $2c, $28
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToRockClub:
	db $3c, $68
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToFightingClub:
	db $3c, $48
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToWaterClub:
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToFightingClub:
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToPsychicClub:
OverworldMap_PsychicClubPathToFightingClub:
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToFireClub:
	db $5c, $68
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToFightingClub:
	db $5c, $30
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_FightingClubPathToChallengeHall:
OverworldMap_ChallengeHallPathToFightingClub:
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToWaterClub:
	db $3c, $48
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToRockClub:
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToGrassClub:
OverworldMap_GrassClubPathToRockClub:
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToFireClub:
	db $3c, $40
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToRockClub:
	db $5c, $30
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToLightningClub:
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_LightningClubPathToWaterClub:
	db $3c, $68
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToGrassClub:
OverworldMap_WaterClubPathToPsychicClub:
OverworldMap_WaterClubPathToScienceClub:
	db $74, $7c
	db $5c, $7c
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_GrassClubPathToWaterClub:
OverworldMap_PsychicClubPathToWaterClub:
OverworldMap_ScienceClubPathToWaterClub:
	db $5c, $68
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToFireClub:
	db $74, $7c
	db $5c, $7c
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToWaterClub:
	db $5c, $30
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToChallengeHall:
	db $74, $7c
	db $5c, $7c
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_ChallengeHallPathToWaterClub:
	db $5c, $48
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_WaterClubPathToPokemonDome:
	db $74, $7c
	db $5c, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_PokemonDomePathToWaterClub:
	db $5c, $7c
	db $74, $7c
	db $00, $00
	db $ff, $ff

OverworldMap_LightningClubPathToPsychicClub:
OverworldMap_PsychicClubPathToLightningClub:
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_LightningClubPathToScienceClub:
	db $3c, $68
	db $5c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_ScienceClubPathToLightningClub:
	db $5c, $68
	db $3c, $68
	db $00, $00
	db $ff, $ff

OverworldMap_LightningClubPathToFireClub:
	db $3c, $48
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToLightningClub:
	db $5c, $30
	db $3c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_GrassClubPathToChallengeHall:
OverworldMap_ScienceClubPathToChallengeHall:
OverworldMap_ChallengeHallPathToGrassClub:
OverworldMap_ChallengeHallPathToScienceClub:
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_FireClubPathToChallengeHall:
OverworldMap_FireClubPathToPokemonDome:
OverworldMap_ChallengeHallPathToFireClub:
OverworldMap_PokemonDomePathToFireClub:
	db $5c, $30
	db $00, $00
	db $ff, $ff

OverworldMap_RockClubPathToScienceClub:
	db $3c, $40
	db $5c, $48
	db $00, $00
	db $ff, $ff

OverworldMap_ScienceClubPathToRockClub:
	db $5c, $48
	db $3c, $40
	db $00, $00
	db $ff, $ff

OverworldMap_StraightPath:
	db $00, $00
	db $ff, $ff

OverworldMap_NoMovement:
	db $ff, $ff
