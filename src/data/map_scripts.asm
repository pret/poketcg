; each map has a maximum of 8 scripts
; scripts are referenced with ids [0,2,4,6,8,a,c,e]
; each script id is used for a specific event
; if a script pointer is $0000, that map has no script for that event
; 0: NPC data
; 2: Called after every NPC is loaded (unused)
; 4: pressed A button
; 6: pressed A button
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
	dw NPCData_772f
	dw $0000
	dw $7b04
	dw $5565
	dw $5549
	dw $553b
	dw $0000
	dw $555e

; DECK_MACHINE_ROOM
	dw NPCData_775a
	dw $0000
	dw $7b4d
	dw $0000
	dw $0000
	dw $589f
	dw $0000
	dw $58ad

; ISHIHARAS_HOUSE
	dw NPCData_7773
	dw $0000
	dw $7c02
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

; FIGHTING_CLUB_ENTRANCE
	dw NPCData_7786
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; FIGHTING_CLUB_LOBBY
	dw NPCData_779f
	dw $0000
	dw $7c6f
	dw $0000
	dw $0000
	dw $5c68
	dw $0000
	dw $0000

; FIGHTING_CLUB
	dw NPCData_77ca
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $5da3
	dw $0000
	dw $0000

; ROCK_CLUB_ENTRANCE
	dw NPCData_77e3
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; ROCK_CLUB_LOBBY
	dw NPCData_77fc
	dw $0000
	dw $7ca6
	dw $0000
	dw $0000
	dw $5ed5
	dw $0000
	dw $0000

; ROCK_CLUB
	dw NPCData_7827
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $5fd6
	dw $0000
	dw $0000

; WATER_CLUB_ENTRANCE
	dw NPCData_783a
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; WATER_CLUB_LOBBY
	dw NPCData_7853
	dw $0000
	dw $7cdd
	dw $0000
	dw $0000
	dw $60a2
	dw $0000
	dw $0000

; WATER_CLUB
	dw NPCData_787e
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw WaterClubAfterDuel
	dw WaterClubMovePlayer
	dw $0000

; LIGHTNING_CLUB_ENTRANCE
	dw NPCData_7897
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; LIGHTNING_CLUB_LOBBY
	dw NPCData_78b0
	dw $0000
	dw $7d14
	dw $0000
	dw $0000
	dw $636d
	dw $0000
	dw $0000

; LIGHTNING_CLUB
	dw NPCData_78d5
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $63e8
	dw $0000
	dw $0000

; GRASS_CLUB_ENTRANCE
	dw NPCData_78ee
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw GrassClubEntranceAfterDuel
	dw $0000
	dw $0000

; GRASS_CLUB_LOBBY
	dw NPCData_790d
	dw $0000
	dw $7d4b
	dw $0000
	dw $0000
	dw GrassClubLobbyAfterDuel
	dw $0000
	dw $0000

; GRASS_CLUB
	dw NPCData_7932
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $66e7
	dw $0000
	dw $0000

; PSYCHIC_CLUB_ENTRANCE
	dw NPCData_7945
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; PSYCHIC_CLUB_LOBBY
	dw NPCData_7964
	dw $0000
	dw $7d82
	dw $0000
	dw $6971
	dw $6963
	dw $0000
	dw $0000

; PSYCHIC_CLUB
	dw NPCData_798f
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $6a46
	dw $0000
	dw $0000

; SCIENCE_CLUB_ENTRANCE
	dw NPCData_79a8
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; SCIENCE_CLUB_LOBBY
	dw NPCData_79c1
	dw $0000
	dw $7db9
	dw $0000
	dw $0000
	dw $6b57
	dw $0000
	dw $0000

; SCIENCE_CLUB
	dw NPCData_79ec
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $6bf1
	dw $0000
	dw $0000

; FIRE_CLUB_ENTRANCE
	dw NPCData_7a05
	dw $0000
	dw $0000
	dw $0000
	dw LoadClubEntrance
	dw ClubEntranceAfterDuel
	dw $0000
	dw $0000

; FIRE_CLUB_LOBBY
	dw NPCData_7a1e
	dw $0000
	dw $7df0
	dw $6d57
	dw $0000
	dw $6d49
	dw $0000
	dw $0000

; FIRE_CLUB
	dw NPCData_7a43
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $6e93
	dw $0000
	dw $0000

; CHALLENGE_HALL_ENTRANCE
	dw NPCData_7a5c
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

; CHALLENGE_HALL_LOBBY
	dw NPCData_7a63
	dw $0000
	dw $7e27
	dw $0000
	dw $7088
	dw $0000
	dw $0000
	dw $0000

; CHALLENGE_HALL
	dw NPCData_7a9a
	dw $0000
	dw $0000
	dw $0000
	dw $7258
	dw $7239
	dw $0000
	dw $0000

; POKEMON_DOME_ENTRANCE
	dw NPCData_7ab9
	dw $0000
	dw $7e5e
	dw $0000
	dw $7607
	dw $0000
	dw $0000
	dw $762a

; POKEMON_DOME
	dw NPCData_7ac0
	dw $0000
	dw $0000
	dw $0000
	dw $7706
	dw $76e0
	dw $76c6
	dw $7718

; HALL_OF_HONOR
	dw NPCData_7adf
	dw $0000
	dw $7ec2
	dw $0000
	dw $7bdb
	dw $0000
	dw $0000
	dw $0000
