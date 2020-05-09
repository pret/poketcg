; each map has a maximum of 8 scripts
; scripts are referenced with ids [0,2,4,6,8,a,c,e]
; each script id is used for a specific event
; if a script pointer is $0000, that map has no script for that event
; 0: NPC data
; 2: Called after every NPC is loaded (unused)
; 4: Interactable Objects
; 6: pressed A button (if nothing interactable is found)
; 8: load map
; a: after duel
; c: moved player
; e: load map/closed text box

MapScripts: ; 1162a (4:562a)
; OVERWORLD_MAP
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw LoadOverworld
	dw $0000
	dw $0000
	dw $0000

; MASON_LABORATORY
	dw MasonLabNPCS
	dw $0000
	dw MasonLabObjects
	dw MasonLabPressedA
	dw MasonLabLoadMap
	dw MasonLaboratoryAfterDuel
	dw $0000
	dw MasonLabCloseTextBox

; DECK_MACHINE_ROOM
	dw DeckMachineRoomNPCS
	dw $0000
	dw DeckMachineRoomObjects
	dw $0000
	dw $0000
	dw $589f
	dw $0000
	dw $58ad

; ISHIHARAS_HOUSE
	dw IshiharasHouseNPCS
	dw $0000
	dw IshiharasHouseObjects
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

; FIGHTING_CLUB_ENTRANCE
	dw FightingClubEntranceNPCS
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; FIGHTING_CLUB_LOBBY
	dw FightingClubLobbyNPCS
	dw $0000
	dw FightingClubLobbyObjects
	dw $0000
	dw $0000
	dw FightingClubLobbyAfterDuel
	dw $0000
	dw $0000

; FIGHTING_CLUB
	dw FightingClubNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $5da3
	dw $0000
	dw $0000

; ROCK_CLUB_ENTRANCE
	dw RockClubEntranceNPCS
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; ROCK_CLUB_LOBBY
	dw RockClubLobbyNPCS
	dw $0000
	dw RockClubLobbyObjects
	dw $0000
	dw $0000
	dw $5ed5
	dw $0000
	dw $0000

; ROCK_CLUB
	dw RockClubNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $5fd6
	dw $0000
	dw $0000

; WATER_CLUB_ENTRANCE
	dw WaterClubEntranceNPCS
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; WATER_CLUB_LOBBY
	dw WaterClubLobbyNPCS
	dw $0000
	dw WaterClubLobbyObjects
	dw $0000
	dw $0000
	dw $60a2
	dw $0000
	dw $0000

; WATER_CLUB
	dw WaterClubNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw WaterClubAfterDuel
	dw WaterClubMovePlayer
	dw $0000

; LIGHTNING_CLUB_ENTRANCE
	dw LightningClubEntranceNPCS
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; LIGHTNING_CLUB_LOBBY
	dw LightningClubLobbyNPCS
	dw $0000
	dw LightningClubLobbyObjects
	dw $0000
	dw $0000
	dw $636d
	dw $0000
	dw $0000

; LIGHTNING_CLUB
	dw LightningClubNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $63e8
	dw $0000
	dw $0000

; GRASS_CLUB_ENTRANCE
	dw GrassClubEntranceNPCS
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw GrassClubEntranceAfterDuel
	dw $0000
	dw $0000

; GRASS_CLUB_LOBBY
	dw GrassClubLobbyNPCS
	dw $0000
	dw GrassClubLobbyObjects
	dw $0000
	dw $0000
	dw GrassClubLobbyAfterDuel
	dw $0000
	dw $0000

; GRASS_CLUB
	dw GrassClubNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $66e7
	dw $0000
	dw $0000

; PSYCHIC_CLUB_ENTRANCE
	dw PsychicClubEntranceNPCS
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; PSYCHIC_CLUB_LOBBY
	dw PsychicClubLobbyNPCS
	dw $0000
	dw PsychicClubLobbyObjects
	dw $0000
	dw $6971
	dw $6963
	dw $0000
	dw $0000

; PSYCHIC_CLUB
	dw PsychicClubNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $6a46
	dw $0000
	dw $0000

; SCIENCE_CLUB_ENTRANCE
	dw ScienceClubEntranceNPCS
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; SCIENCE_CLUB_LOBBY
	dw ScienceClubLobbyNPCS
	dw $0000
	dw ScienceClubLobbyObjects
	dw $0000
	dw $0000
	dw $6b57
	dw $0000
	dw $0000

; SCIENCE_CLUB
	dw ScienceClubNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $6bf1
	dw $0000
	dw $0000

; FIRE_CLUB_ENTRANCE
	dw FireClubEntranceNPCS
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; FIRE_CLUB_LOBBY
	dw FireClubLobbyNPCS
	dw $0000
	dw FireClubLobbyObjects
	dw FireClubPressedA
	dw $0000
	dw $6d49
	dw $0000
	dw $0000

; FIRE_CLUB
	dw FireClubNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $6e93
	dw $0000
	dw $0000

; CHALLENGE_HALL_ENTRANCE
	dw ChallengeHallEntranceNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

; CHALLENGE_HALL_LOBBY
	dw ChallengeHallLobbyNPCS
	dw $0000
	dw ChallengeHallLobbyObjects
	dw $0000
	dw ChallengeHallLobbyLoadMap
	dw $0000
	dw $0000
	dw $0000

; CHALLENGE_HALL
	dw ChallengeHallNPCS
	dw $0000
	dw $0000
	dw $0000
	dw ChallengeHallLoadMap
	dw ChallengeHallAfterDuel
	dw $0000
	dw $0000

; POKEMON_DOME_ENTRANCE
	dw PokemonDomeEntranceNPCS
	dw $0000
	dw PokemonDomeEntranceObjects
	dw $0000
	dw $7607
	dw $0000
	dw $0000
	dw $762a

; POKEMON_DOME
	dw PokemonDomeNPCS
	dw $0000
	dw $0000
	dw $0000
	dw $7706
	dw $76e0
	dw $76c6
	dw $7718

; HALL_OF_HONOR
	dw HallOfHonorNPCS
	dw $0000
	dw HallOfHonorObjects
	dw $0000
	dw HallOfHonorLoadMap
	dw $0000
	dw $0000
	dw $0000
