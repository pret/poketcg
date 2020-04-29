; When you press the A button in front of something it will find a data entry somewhere on this list
; it will then jump to the pointer in the data item. All jumps lead to an RST20 operation.
PointerTable_118f5:
	dw Data_119dd
	dw Data_119dd
	dw RonaldData
	dw Data_11a11
	dw ImakuniData
	dw Data_119dd
	dw Data_119dd
	dw SamData
	dw Data_11a38
	dw Data_11a45
	dw Data_11a52
	dw Data_11a5f
	dw Data_11a6c
	dw Data_11a79
	dw Data_11a86
	dw Data_11a93
	dw Data_11aa0
	dw Data_11aad
	dw Data_11aba
	dw Data_11ac7
	dw Data_11ad4
	dw Data_11ae1
	dw Data_11aee
	dw ChrisData
	dw MichaelData
	dw JessicaData
	dw MitchData
	dw MatthewData
	dw RyanData
	dw AndrewData
	dw GeneData
	dw SaraData
	dw AmandaData
	dw JoshuaData
	dw AmyData
	dw JenniferData
	dw NicholasData
	dw BrandonData
	dw IsaacData
	dw BrittanyData
	dw KristinData
	dw HeatherData
	dw NikkiData
	dw RobertData
	dw DanielData
	dw StephanieData
	dw MurrayData
	dw JosephData
	dw DavidData
	dw ErikData
	dw RickData
	dw JohnData
	dw AdamData
	dw JonathanData
	dw KenData
	dw CourtneyData
	dw SteveData
	dw JackData
	dw RodData
	dw Data_11cdc
	dw Data_11ce9
	dw Data_11cf6
	dw Data_11d03
	dw Data_11d10
	dw Data_11d1d
	dw Data_11d2a
	dw Data_11d37
	dw Data_11d44
	dw Data_11d51
	dw Data_11d5e
	dw Data_11d6b
	dw Data_11d78
	dw Data_11d85
	dw Data_11d92
	dw Data_11d9f
	dw Data_11dac
	dw Data_11db9
	dw Data_11dc6
	dw Data_11dd3
	dw Data_11de0
	dw Data_11ded
	dw Data_11dfa
	dw Data_11e07
	dw Data_11e14
	dw Data_11e21
	dw Data_11e2e
	dw Data_11e3b
	dw Data_11e48
	dw Data_11e55
	dw Data_11e62
	dw Data_11e6f
	dw Data_11e7c
	dw Data_11e89
	dw Data_11e96
	dw Data_11ea3
	dw Data_11eb0
	dw Data_11ebd
	dw Data_11eca
	dw Data_11ed7
	dw AaronData
	dw Data_11ef1
	dw Data_11efe
	dw Data_11f0b
	dw Data_11f18
	dw Data_11f1f
	dw Data_11f26
	dw Data_11f2d
	dw Data_11f34
	dw Data_11f3b
	dw Data_11f42
	dw Data_11f49
	dw Data_11f49
	dw Murray2Data
	dw Ronald2Data
	dw Ronald3Data
	dw Data_11f49
Data_119dd:
	db $01
	db $02
	db $00
	db $26
	db $00
	dw $5727 ; Pointer to NPC Data
	db $ac
	db $03
	db $00
	db $00
	db $00
	db $00
RonaldData:
	db RONALD
	db $01
	db $04
	db $0e
	db $00
	dw $5c4b ; Pointer to NPC Data
	tx RonaldNPCName
	db RONALD_PIC
	db INVINCIBLE_RONALD_DECK_ID
	db $0f
	db MUSIC_MATCH_START_2
Ronald2Data:
	db RONALD2
	db $01
	db $04
	db $0e
	db $00
	dw $5c4b ; Pointer to NPC Data
	tx RonaldNPCName
	db RONALD_PIC
	db INVINCIBLE_RONALD_DECK_ID
	db $0f
	db MUSIC_MATCH_START_2
Ronald3Data:
	db RONALD3
	db $01
	db $04
	db $0e
	db $00
	dw $5c4b ; Pointer to NPC Data
	tx RonaldNPCName
	db RONALD_PIC
	db INVINCIBLE_RONALD_DECK_ID
	db $0f
	db MUSIC_MATCH_START_2
Data_11a11:
	db $03
	db $03
	db $04
	db $22
	db $00
	dw $5b4a ; Pointer to NPC Data
	db $ae
	db $03
	db $00
	db $00
	db $00
	db $00
ImakuniData:
	db IMAKUNI
	db $04
	db $00
	db $0e
	db $00
	dw $5d0d ; Pointer to NPC Data
	tx ImakuniNPCName
	db IMAKUNI_PIC
	db IMAKUNI_DECK_ID
	db $10
	db MUSIC_MATCH_START_1
SamData:
	db SAM
	db $18 ; sprite ID
	db $00
	db $0e
	db $00
	dw $561d ; Pointer to NPC Data
	tx SamNPCName
	db SAM_PIC
	db SAMS_NORMAL_DECK_ID
	db $02
	db MUSIC_MATCH_START_1
Data_11a38:
	db $08
	db $18
	db $00
	db $0e
	db $00
	dw $5583 ; Pointer to NPC Data
	db $b2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11a45:
	db $09
	db $18
	db $00
	db $0e
	db $00
	dw $55ca ; Pointer to NPC Data
	db $b2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11a52:
	db $0a
	db $18
	db $00
	db $0e
	db $00
	dw $55d5 ; Pointer to NPC Data
	db $b2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11a5f:
	db $0b
	db $18
	db $00
	db $0e
	db $00
	dw $55e0 ; Pointer to NPC Data
	db $b2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11a6c:
	db $0c
	db $18
	db $00
	db $0e
	db $00
	dw $55f9 ; Pointer to NPC Data
	db $b2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11a79:
	db $0d
	db $18
	db $00
	db $0e
	db $00
	dw $58bb ; Pointer to NPC Data
	db $b2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11a86:
	db $0e
	db $21
	db $0a
	db $30
	db $00
	dw $5c64 ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11a93:
	db $0f
	db $21
	db $0a
	db $30
	db $00
	dw $5ed1 ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11aa0:
	db $10
	db $21
	db $0a
	db $30
	db $00
	dw $609e ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11aad:
	db $11
	db $21
	db $0a
	db $30
	db $00
	dw $6369 ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11aba:
	db $12
	db $21
	db $0a
	db $30
	db $00
	dw $6566 ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11ac7:
	db $13
	db $21
	db $0a
	db $30
	db $00
	dw $684c ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11ad4:
	db $14
	db $21
	db $0a
	db $30
	db $00
	dw $6b53 ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11ae1:
	db $15
	db $21
	db $0a
	db $30
	db $00
	dw $6d45 ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11aee:
	db $16
	db $21
	db $0a
	db $30
	db $00
	dw $7025 ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
ChrisData:
	db CHRIS
	db $15
	db $00
	db $26
	db $00
	dw $5ef2 ; Pointer to NPC Data
	tx ChrisNPCName
	db CHRIS_PIC
	db MUSCLES_FOR_BRAINS_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
MichaelData:
	db MICHAEL
	db $15
	db $00
	db $26
	db $00
	dw $6573 ; Pointer to NPC Data
	tx MichaelNPCName
	db MICHAEL_PIC
	db HEATED_BATTLE_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
JessicaData:
	db JESSICA
	db $1f
	db $04
	db $1a
	db $00
	dw $6d96 ; Pointer to NPC Data
	tx JessicaNPCName
	db JESSICA_PIC
	db LOVE_TO_BATTLE_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
MitchData:
	db MITCH
	db $0a
	db $00
	db $0e
	db $00
	dw $5dc3 ; Pointer to NPC Data
	tx MitchNPCName
	db MITCH_PIC
	db FIRST_STRIKE_DECK_ID
	db $03
	db MUSIC_MATCH_START_2
MatthewData:
	db MATTHEW
	db $15
	db $00
	db $16
	db $00
	dw $5f39 ; Pointer to NPC Data
	tx MatthewNPCName
	db MATTHEW_PIC
	db HARD_POKEMON_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
RyanData:
	db RYAN
	db $11
	db $00
	db $26
	db $00
	dw $5ff0 ; Pointer to NPC Data
	tx RyanNPCName
	db RYAN_PIC
	db EXCAVATION_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
AndrewData:
	db ANDREW
	db $1a
	db $00
	db $16
	db $00
	dw $6017 ; Pointer to NPC Data
	tx AndrewNPCName
	db ANDREW_PIC
	db BLISTERING_POKEMON_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
GeneData:
	db GENE
	db $0b
	db $04
	db $1e
	db $00
	dw $603e ; Pointer to NPC Data
	tx GeneNPCName
	db GENE_PIC
	db ROCK_CRUSHER_DECK_ID
	db $03
	db MUSIC_MATCH_START_2
SaraData:
	db SARA
	db $20
	db $00
	db $0e
	db $00
	dw OWSequence_Sara ; Pointer to NPC Data
	tx SaraNPCName
	db SARA_PIC
	db WATERFRONT_POKEMON_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
AmandaData:
	db AMANDA
	db $20
	db $00
	db $16
	db $00
	dw OWSequence_Amanda ; Pointer to NPC Data
	tx AmandaNPCName
	db AMANDA_PIC
	db LONELY_FRIENDS_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
JoshuaData:
	db JOSHUA
	db $16
	db $00
	db $26
	db $00
	dw OWSequence_Joshua ; Pointer to NPC Data
	tx JoshuaNPCName
	db JOSHUA_PIC
	db SOUND_OF_THE_WAVES_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
AmyData:
	db AMY
	db $08
	db $08
	db $2e
	db $10
	dw $6304 ; Pointer to NPC Data
	tx AmyNPCName
	db AMY_PIC
	db GO_GO_RAIN_DANCE_DECK_ID
	db $03
	db MUSIC_MATCH_START_2
JenniferData:
	db JENNIFER
	db $1c
	db $04
	db $0e
	db $00
	dw $6408 ; Pointer to NPC Data
	tx JenniferNPCName
	db JENNIFER_PIC
	db PIKACHU_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
NicholasData:
	db NICHOLAS
	db $17
	db $04
	db $1e
	db $00
	dw $642f ; Pointer to NPC Data
	tx NicholasNPCName
	db NICHOLAS_PIC
	db BOOM_BOOM_SELFDESTRUCT_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
BrandonData:
	db BRANDON
	db $17
	db $04
	db $1e
	db $00
	dw $6456 ; Pointer to NPC Data
	tx BrandonNPCName
	db BRANDON_PIC
	db POWER_GENERATOR_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
IsaacData:
	db ISAAC
	db $09
	db $00
	db $16
	db $00
	dw $64ad ; Pointer to NPC Data
	tx IsaacNPCName
	db ISAAC_PIC
	db ZAPPING_SELFDESTRUCT_DECK_ID
	db $03
	db MUSIC_MATCH_START_2
BrittanyData:
	db BRITTANY
	db $1c
	db $04
	db $0e
	db $00
	dw $65d2 ; Pointer to NPC Data
	tx BrittanyNPCName
	db BRITTANY_PIC
	db ETCETERA_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
KristinData:
	db KRISTIN
	db $1e
	db $00
	db $1e
	db $00
	dw $6701 ; Pointer to NPC Data
	tx KristinNPCName
	db KRISTIN_PIC
	db FLOWER_GARDEN_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
HeatherData:
	db HEATHER
	db $1d
	db $04
	db $22
	db $00
	dw $6745 ; Pointer to NPC Data
	tx HeatherNPCName
	db HEATHER_PIC
	db KALEIDOSCOPE_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
NikkiData:
	db NIKKI
	db $05
	db $00
	db $1a
	db $00
	dw $679e ; Pointer to NPC Data
	tx NikkiNPCName
	db NIKKI_PIC
	db FLOWER_POWER_DECK_ID
	db $03
	db MUSIC_MATCH_START_2
RobertData:
	db ROBERT
	db $11
	db $04
	db $16
	db $00
	dw $6980 ; Pointer to NPC Data
	tx RobertNPCName
	db ROBERT_PIC
	db GHOST_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
DanielData:
	db DANIEL
	db $12
	db $04
	db $1a
	db $00
	dw $6a60 ; Pointer to NPC Data
	tx DanielNPCName
	db DANIEL_PIC
	db NAP_TIME_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
StephanieData:
	db STEPHANIE
	db $1c
	db $04
	db $0e
	db $00
	dw $6aa2 ; Pointer to NPC Data
	tx StephanieNPCName
	db STEPHANIE_PIC
	db STRANGE_POWER_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
MurrayData:
	db MURRAY
	db $0c
	db $00
	db $12
	db $00
	dw $6adf ; Pointer to NPC Data
	tx MurrayNPCName
	db MURRAY_PIC
	db STRANGE_PSYSHOCK_DECK_ID
	db $03
	db MUSIC_MATCH_START_2
Murray2Data:
	db MURRAY2
	db $0c
	db $03
	db $15
	db $10
	dw $6adf ; Pointer to NPC Data
	tx MurrayNPCName
	db MURRAY_PIC
	db STRANGE_PSYSHOCK_DECK_ID
	db $03
	db MUSIC_MATCH_START_2
JosephData:
	db JOSEPH
	db $18
	db $00
	db $0e
	db $00
	dw $6cdb ; Pointer to NPC Data
	tx JosephNPCName
	db JOSEPH_PIC
	db FLYIN_POKEMON_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
DavidData:
	db DAVID
	db $18
	db $00
	db $0e
	db $00
	dw $6c11 ; Pointer to NPC Data
	tx DavidNPCName
	db DAVID_PIC
	db LOVELY_NIDORAN_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
ErikData:
	db ERIK
	db $18
	db $00
	db $0e
	db $00
	dw $6c42 ; Pointer to NPC Data
	tx ErikNPCName
	db ERIK_PIC
	db POISON_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
RickData:
	db RICK
	db $06
	db $00
	db $0e
	db $00
	dw $6c67 ; Pointer to NPC Data
	tx RickNPCName
	db RICK_PIC
	db WONDERS_OF_SCIENCE_DECK_ID
	db $03
	db MUSIC_MATCH_START_2
JohnData:
	db JOHN
	db $12
	db $04
	db $1a
	db $00
	dw $6eb3 ; Pointer to NPC Data
	tx JohnNPCName
	db JOHN_PIC
	db ANGER_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
AdamData:
	db ADAM
	db $13
	db $00
	db $22
	db $00
	dw $6ed8 ; Pointer to NPC Data
	tx AdamNPCName
	db ADAM_PIC
	db FLAMETHROWER_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
JonathanData:
	db JONATHAN
	db $11
	db $04
	db $16
	db $00
	dw $6efd ; Pointer to NPC Data
	tx JonathanNPCName
	db JONATHAN_PIC
	db RESHUFFLE_DECK_ID
	db $03
	db MUSIC_MATCH_START_1
KenData:
	db KEN
	db $07
	db $04
	db $1e
	db $00
	dw $6f22 ; Pointer to NPC Data
	tx KenNPCName
	db KEN_PIC
	db FIRE_CHARGE_DECK_ID
	db $03
	db MUSIC_MATCH_START_2
CourtneyData:
	db COURTNEY
	db $0d
	db $00
	db $12
	db $00
	dw $771f ; Pointer to NPC Data
	tx CourtneyNPCName
	db COURTNEY_PIC
	db LEGENDARY_MOLTRES_DECK_ID
	db $04
	db MUSIC_MATCH_START_3
SteveData:
	db STEVE
	db $0e
	db $00
	db $2a
	db $00
	dw $772a ; Pointer to NPC Data
	tx SteveNPCName
	db STEVE_PIC
	db LEGENDARY_ZAPDOS_DECK_ID
	db $04
	db MUSIC_MATCH_START_3
JackData:
	db JACK
	db $0f
	db $00
	db $26
	db $00
	dw $7735 ; Pointer to NPC Data
	tx JackNPCName
	db JACK_PIC
	db LEGENDARY_ARTICUNO_DECK_ID
	db $04
	db MUSIC_MATCH_START_3
RodData:
	db ROD
	db $10
	db $00
	db $0e
	db $00
	dw $7740 ; Pointer to NPC Data
	tx RodNPCName
	db ROD_PIC
	db LEGENDARY_DRAGONITE_DECK_ID
	db $04
	db MUSIC_MATCH_START_3
Data_11cdc:
	db $3b
	db $21
	db $0a
	db $30
	db $00
	dw $4c3e ; Pointer to NPC Data
	db $b0
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11ce9:
	db $3c
	db $21
	db $0a
	db $30
	db $00
	dw $4c3e ; Pointer to NPC Data
	db $b0
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11cf6:
	db $3d
	db $1a
	db $00
	db $16
	db $00
	dw $5c76 ; Pointer to NPC Data
	db $d8
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d03:
	db $3e
	db $23
	db $04
	db $1e
	db $00
	dw $5f83 ; Pointer to NPC Data
	db $d9
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d10:
	db $3f
	db $19
	db $00
	db $1a
	db $00
	dw $5fc0 ; Pointer to NPC Data
	db $da
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d1d:
	db $40
	db $22
	db $00
	db $16
	db $00
	dw $60cf ; Pointer to NPC Data
	db $db
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d2a:
	db $41
	db $1e
	db $00
	db $1e
	db $00
	dw $6111 ; Pointer to NPC Data
	db $dc
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d37:
	db $42
	db $19
	db $00
	db $1a
	db $00
	dw $639a ; Pointer to NPC Data
	db $da
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d44:
	db $43
	db $1e
	db $00
	db $1e
	db $00
	dw $661f ; Pointer to NPC Data
	db $dc
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d51:
	db $44
	db $1b
	db $00
	db $22
	db $00
	dw $69a5 ; Pointer to NPC Data
	db $dd
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d5e:
	db $45
	db $12
	db $04
	db $1a
	db $00
	dw $6b84 ; Pointer to NPC Data
	db $de
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d6b:
	db $46
	db $11
	db $04
	db $16
	db $00
	dw $6e2c ; Pointer to NPC Data
	db $de
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d78:
	db $47
	db $19
	db $00
	db $1a
	db $00
	dw $6de8 ; Pointer to NPC Data
	db $da
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d85:
	db $48
	db $22
	db $00
	db $16
	db $00
	dw $7295 ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d92:
	db $49
	db $22
	db $00
	db $16
	db $00
	dw $726c ; Pointer to NPC Data
	db $b3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11d9f:
	db $4a
	db $22
	db $00
	db $16
	db $00
	dw $7352 ; Pointer to NPC Data
	db $df
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11dac:
	db $4b
	db $13
	db $00
	db $22
	db $00
	dw $5d82 ; Pointer to NPC Data
	db $e0
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11db9:
	db $4c
	db $14
	db $00
	db $16
	db $00
	dw $5d8d ; Pointer to NPC Data
	db $e1
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11dc6:
	db $4d
	db $24
	db $00
	db $16
	db $00
	dw $5d9f ; Pointer to NPC Data
	db $e5
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11dd3:
	db $4e
	db $1d
	db $04
	db $22
	db $00
	dw $5fd2 ; Pointer to NPC Data
	db $dc
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11de0:
	db $4f
	db $1a
	db $00
	db $16
	db $00
	dw $6137 ; Pointer to NPC Data
	db $d8
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11ded:
	db $50
	db $1b
	db $00
	db $22
	db $00
	dw $613b ; Pointer to NPC Data
	db $dd
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11dfa:
	db $51
	db $1d
	db $04
	db $22
	db $00
	dw $63d9 ; Pointer to NPC Data
	db $dc
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e07:
	db $52
	db $17
	db $04
	db $1e
	db $00
	dw $63dd ; Pointer to NPC Data
	db $e2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e14:
	db $53
	db $24
	db $00
	db $16
	db $00
	dw $66d8 ; Pointer to NPC Data
	db $e5
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e21:
	db $54
	db $22
	db $00
	db $16
	db $00
	dw $66e3 ; Pointer to NPC Data
	db $db
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e2e:
	db $55
	db $12
	db $04
	db $1a
	db $00
	dw $6850 ; Pointer to NPC Data
	db $de
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e3b:
	db $56
	db $22
	db $00
	db $16
	db $00
	dw $6a30 ; Pointer to NPC Data
	db $db
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e48:
	db $57
	db $19
	db $00
	db $1a
	db $00
	dw $6a3b ; Pointer to NPC Data
	db $da
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e55:
	db $58
	db $1a
	db $00
	db $16
	db $00
	dw $6bc1 ; Pointer to NPC Data
	db $d8
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e62:
	db $59
	db $18
	db $00
	db $0e
	db $00
	dw $6bc5 ; Pointer to NPC Data
	db $e0
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e6f:
	db $5a
	db $13
	db $00
	db $22
	db $00
	dw $6bed ; Pointer to NPC Data
	db $e0
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e7c:
	db $5b
	db $23
	db $04
	db $1e
	db $00
	dw $4c3e ; Pointer to NPC Data
	db $d9
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e89:
	db $5c
	db $15
	db $00
	db $26
	db $00
	dw $6e88 ; Pointer to NPC Data
	db $e4
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11e96:
	db $5d
	db $1b
	db $00
	db $22
	db $00
	dw $709c ; Pointer to NPC Data
	db $dd
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11ea3:
	db $5e
	db $22
	db $00
	db $16
	db $00
	dw $70a0 ; Pointer to NPC Data
	db $db
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11eb0:
	db $5f
	db $15
	db $00
	db $26
	db $00
	dw $70a4 ; Pointer to NPC Data
	db $e3
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11ebd:
	db $60
	db $17
	db $04
	db $1e
	db $00
	dw $70a8 ; Pointer to NPC Data
	db $e2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11eca:
	db $61
	db $1f
	db $04
	db $1a
	db $00
	dw $70ac ; Pointer to NPC Data
	db $dc
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11ed7:
	db $62
	db $19
	db $00
	db $1a
	db $00
	dw $70b0 ; Pointer to NPC Data
	db $da
	db $03
	db $00
	db $00
	db $00
	db $00
AaronData:
	db AARON
	db $18
	db $00
	db $0e
	db $00
	dw $58dd ; Pointer to NPC Data
	tx AaronNPCName
	db AARON_PIC
	db LIGHTNING_AND_FIRE_DECK_ID
	db $02
	db MUSIC_MATCH_START_1
Data_11ef1:
	db $64
	db $1a
	db $00
	db $16
	db $00
	dw $7283 ; Pointer to NPC Data
	db $e6
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11efe:
	db $65
	db $18
	db $00
	db $0e
	db $00
	dw $58c6 ; Pointer to NPC Data
	db $b2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11f0b:
	db $66
	db $18
	db $00
	db $0e
	db $00
	dw $58d1 ; Pointer to NPC Data
	db $b2
	db $03
	db $00
	db $00
	db $00
	db $00
Data_11f18:
	db $67
	db $26
	db $3a
	db $3a
	db $10
	dw $4c3e ; Pointer to NPC Data
Data_11f1f:
	db $68
	db $27
	db $3b
	db $41
	db $50
	dw $4c3e ; Pointer to NPC Data
Data_11f26:
	db $69
	db $27
	db $3c
	db $42
	db $50
	dw $4c3e ; Pointer to NPC Data
Data_11f2d:
	db $6a
	db $27
	db $3d
	db $43
	db $50
	dw $4c3e ; Pointer to NPC Data
Data_11f34:
	db $6b
	db $27
	db $3e
	db $44
	db $50
	dw $4c3e ; Pointer to NPC Data
Data_11f3b:
	db $6c
	db $27
	db $3f
	db $45
	db $50
	dw $4c3e ; Pointer to NPC Data
Data_11f42:
	db $6d
	db $27
	db $40
	db $46
	db $50
	dw $4c3e ; Pointer to NPC Data
Data_11f49:
	db $00
	db $00
	db $00
	db $1e
	db $00
