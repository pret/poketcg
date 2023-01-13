; each map has a maximum of 8 scripts
; scripts are referenced with ids [0,2,4,6,8,a,c,e]
; each script id is used for a specific event
; if a script pointer is NULL, that map has no script for that event
; 0: NPC data
; 2: Called after every NPC is loaded (unused)
; 4: Interactable Objects
; 6: pressed A button (if nothing interactable is found)
; 8: load map
; a: after duel
; c: moved player
; e: load map/closed text box

MapScripts::
	table_width NUM_MAP_SCRIPTS * 2, MapScripts

; OVERWORLD_MAP
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw LoadOverworld
	dw NULL
	dw NULL
	dw NULL

; MASON_LABORATORY
	dw MasonLabNPCS
	dw NULL
	dw MasonLabObjects
	dw MasonLabPressedA
	dw MasonLabLoadMap
	dw MasonLaboratoryAfterDuel
	dw NULL
	dw MasonLabCloseTextBox

; DECK_MACHINE_ROOM
	dw DeckMachineRoomNPCS
	dw NULL
	dw DeckMachineRoomObjects
	dw NULL
	dw NULL
	dw DeckMachineRoomAfterDuel
	dw NULL
	dw DeckMachineRoomCloseTextBox

; ISHIHARAS_HOUSE
	dw IshiharasHouseNPCS
	dw NULL
	dw IshiharasHouseObjects
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw NULL

; FIGHTING_CLUB_ENTRANCE
	dw FightingClubEntranceNPCS
	dw NULL
	dw NULL
	dw NULL
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw NULL
	dw NULL

; FIGHTING_CLUB_LOBBY
	dw FightingClubLobbyNPCS
	dw NULL
	dw FightingClubLobbyObjects
	dw NULL
	dw NULL
	dw FightingClubLobbyAfterDuel
	dw NULL
	dw NULL

; FIGHTING_CLUB
	dw FightingClubNPCS
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw FightingClubAfterDuel
	dw NULL
	dw NULL

; ROCK_CLUB_ENTRANCE
	dw RockClubEntranceNPCS
	dw NULL
	dw NULL
	dw NULL
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw NULL
	dw NULL

; ROCK_CLUB_LOBBY
	dw RockClubLobbyNPCS
	dw NULL
	dw RockClubLobbyObjects
	dw NULL
	dw NULL
	dw RockClubLobbyAfterDuel
	dw NULL
	dw NULL

; ROCK_CLUB
	dw RockClubNPCS
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw RockClubAfterDuel
	dw NULL
	dw NULL

; WATER_CLUB_ENTRANCE
	dw WaterClubEntranceNPCS
	dw NULL
	dw NULL
	dw NULL
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw NULL
	dw NULL

; WATER_CLUB_LOBBY
	dw WaterClubLobbyNPCS
	dw NULL
	dw WaterClubLobbyObjects
	dw NULL
	dw NULL
	dw WaterClubLobbyAfterDuel
	dw NULL
	dw NULL

; WATER_CLUB
	dw WaterClubNPCS
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw WaterClubAfterDuel
	dw WaterClubMovePlayer
	dw NULL

; LIGHTNING_CLUB_ENTRANCE
	dw LightningClubEntranceNPCS
	dw NULL
	dw NULL
	dw NULL
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw NULL
	dw NULL

; LIGHTNING_CLUB_LOBBY
	dw LightningClubLobbyNPCS
	dw NULL
	dw LightningClubLobbyObjects
	dw NULL
	dw NULL
	dw LightningClubLobbyAfterDuel
	dw NULL
	dw NULL

; LIGHTNING_CLUB
	dw LightningClubNPCS
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw LightningClubAfterDuel
	dw NULL
	dw NULL

; GRASS_CLUB_ENTRANCE
	dw GrassClubEntranceNPCS
	dw NULL
	dw NULL
	dw NULL
	dw LoadClubEntrance
	dw GrassClubEntranceAfterDuel
	dw NULL
	dw NULL

; GRASS_CLUB_LOBBY
	dw GrassClubLobbyNPCS
	dw NULL
	dw GrassClubLobbyObjects
	dw NULL
	dw NULL
	dw GrassClubLobbyAfterDuel
	dw NULL
	dw NULL

; GRASS_CLUB
	dw GrassClubNPCS
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw GrassClubAfterDuel
	dw NULL
	dw NULL

; PSYCHIC_CLUB_ENTRANCE
	dw PsychicClubEntranceNPCS
	dw NULL
	dw NULL
	dw NULL
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw NULL
	dw NULL

; PSYCHIC_CLUB_LOBBY
	dw PsychicClubLobbyNPCS
	dw NULL
	dw PsychicClubLobbyObjects
	dw NULL
	dw PsychicClubLobbyLoadMap
	dw PsychicClubLobbyAfterDuel
	dw NULL
	dw NULL

; PSYCHIC_CLUB
	dw PsychicClubNPCS
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw PsychicClubAfterDuel
	dw NULL
	dw NULL

; SCIENCE_CLUB_ENTRANCE
	dw ScienceClubEntranceNPCS
	dw NULL
	dw NULL
	dw NULL
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw NULL
	dw NULL

; SCIENCE_CLUB_LOBBY
	dw ScienceClubLobbyNPCS
	dw NULL
	dw ScienceClubLobbyObjects
	dw NULL
	dw NULL
	dw ScienceClubLobbyAfterDuel
	dw NULL
	dw NULL

; SCIENCE_CLUB
	dw ScienceClubNPCS
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw ScienceClubAfterDuel
	dw NULL
	dw NULL

; FIRE_CLUB_ENTRANCE
	dw FireClubEntranceNPCS
	dw NULL
	dw NULL
	dw NULL
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw NULL
	dw NULL

; FIRE_CLUB_LOBBY
	dw FireClubLobbyNPCS
	dw NULL
	dw FireClubLobbyObjects
	dw FireClubPressedA
	dw NULL
	dw FireClubLobbyAfterDuel
	dw NULL
	dw NULL

; FIRE_CLUB
	dw FireClubNPCS
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw FireClubAfterDuel
	dw NULL
	dw NULL

; CHALLENGE_HALL_ENTRANCE
	dw ChallengeHallEntranceNPCS
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw NULL

; CHALLENGE_HALL_LOBBY
	dw ChallengeHallLobbyNPCS
	dw NULL
	dw ChallengeHallLobbyObjects
	dw NULL
	dw ChallengeHallLobbyLoadMap
	dw NULL
	dw NULL
	dw NULL

; CHALLENGE_HALL
	dw ChallengeHallNPCS
	dw NULL
	dw NULL
	dw NULL
	dw ChallengeHallLoadMap
	dw ChallengeHallAfterDuel
	dw NULL
	dw NULL

; POKEMON_DOME_ENTRANCE
	dw PokemonDomeEntranceNPCS
	dw NULL
	dw PokemonDomeEntranceObjects
	dw NULL
	dw PokemonDomeEntranceLoadMap
	dw NULL
	dw NULL
	dw PokemonDomeEntranceCloseTextBox

; POKEMON_DOME
	dw PokemonDomeNPCS
	dw NULL
	dw NULL
	dw NULL
	dw PokemonDomeLoadMap
	dw PokemonDomeAfterDuel
	dw PokemonDomeMovePlayer
	dw PokemonDomeCloseTextBox

; HALL_OF_HONOR
	dw HallOfHonorNPCS
	dw NULL
	dw HallOfHonorObjects
	dw NULL
	dw HallOfHonorLoadMap
	dw NULL
	dw NULL
	dw NULL

	assert_table_length NUM_MAPS
