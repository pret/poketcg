; card lists read by AutoDeckMachineEntries
; each list entry is a card count and card ID pair

AllFightingPokemonCardList: ; 1b0da (6:70da)
	db 26, FIGHTING_ENERGY
	db  2, SANDSHREW
	db  1, SANDSLASH
	db  2, DIGLETT
	db  1, DUGTRIO
	db  2, MANKEY
	db  1, PRIMEAPE
	db  3, MACHOP
	db  2, MACHOKE
	db  1, MACHAMP
	db  2, GEODUDE
	db  1, GRAVELER
	db  1, GOLEM
	db  1, ONIX
	db  2, CUBONE
	db  1, MAROWAK1
	db  1, HITMONLEE
	db  1, HITMONCHAN
	db  2, RHYHORN
	db  1, RHYDON
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  1, SWITCH
	db  2, POTION
	db  0 ; end of list

BenchAttackCardList: ; 1b10b (6:710b)
	db 12, LIGHTNING_ENERGY
	db 14, FIGHTING_ENERGY
	db  4, VOLTORB
	db  2, ELECTRODE2
	db  2, ZAPDOS1
	db  4, HITMONLEE
	db  2, HITMONCHAN
	db  4, MEOWTH1
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  1, MR_FUJI
	db  2, ENERGY_RETRIEVAL
	db  2, SWITCH
	db  1, SCOOP_UP
	db  2, PLUSPOWER
	db  2, DEFENDER
	db  1, ITEM_FINDER
	db  1, GUST_OF_WIND
	db  1, MAINTENANCE
	db  0 ; end of list

BattleContestCardList: ; 1b132 (6:7132)
	db 24, FIGHTING_ENERGY
	db  2, DOUBLE_COLORLESS_ENERGY
	db  3, MANKEY
	db  4, MACHOP
	db  3, MACHOKE
	db  2, HITMONLEE
	db  2, HITMONCHAN
	db  3, MEOWTH1
	db  2, PERSIAN
	db  3, DRATINI
	db  2, DRAGONAIR
	db  1, DRAGONITE2
	db  1, PROFESSOR_OAK
	db  3, PLUSPOWER
	db  3, DEFENDER
	db  2, POTION
	db  0 ; end of list

HeatedBattleCardList: ; 1b153 (6:7153)
	db  8, FIRE_ENERGY
	db  4, LIGHTNING_ENERGY
	db 15, FIGHTING_ENERGY
	db  4, MAGMAR1
	db  2, ELECTABUZZ2
	db  3, MANKEY
	db  2, PRIMEAPE
	db  3, HITMONLEE
	db  3, HITMONCHAN
	db  2, KANGASKHAN
	db  2, ENERGY_SEARCH
	db  2, SCOOP_UP
	db  3, PLUSPOWER
	db  2, DEFENDER
	db  3, POTION
	db  2, FULL_HEAL
	db  0 ; end of list

FirstStrikeCardList: ; 1b174 (6:7174)
	db 25, FIGHTING_ENERGY
	db  4, MACHOP
	db  3, MACHOKE
	db  2, MACHAMP
	db  2, HITMONCHAN
	db  4, HITMONLEE
	db  4, MANKEY
	db  1, PRIMEAPE
	db  2, POTION
	db  2, DEFENDER
	db  2, PLUSPOWER
	db  2, SWITCH
	db  3, GUST_OF_WIND
	db  4, BILL
	db  0 ; end of list

SqueakingMouseCardList: ; 1b191 (6:7191)
	db  8, LIGHTNING_ENERGY
	db 15, FIGHTING_ENERGY
	db  2, DOUBLE_COLORLESS_ENERGY
	db  2, PIKACHU1
	db  2, PIKACHU2
	db  1, RAICHU1
	db  1, RAICHU2
	db  4, SANDSHREW
	db  3, SANDSLASH
	db  4, RATTATA
	db  3, RATICATE
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  1, POKEMON_TRADER
	db  2, ENERGY_RETRIEVAL
	db  1, COMPUTER_SEARCH
	db  3, PLUSPOWER
	db  2, DEFENDER
	db  2, POTION
	db  1, SUPER_POTION
	db  0 ; end of list

GreatQuakeCardList: ; 1b1ba (6:71ba)
	db 25, FIGHTING_ENERGY
	db  4, DIGLETT
	db  3, DUGTRIO
	db  4, ONIX
	db  3, RHYHORN
	db  2, RHYDON
	db  2, KANGASKHAN
	db  1, TAUROS
	db  1, SNORLAX
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  2, POKEMON_TRADER
	db  3, SWITCH
	db  4, DEFENDER
	db  3, POTION
	db  0 ; end of list

BoneAttackCardList: ; 1b1d9 (6:71d9)
	db 24, FIGHTING_ENERGY
	db  3, SANDSHREW
	db  2, SANDSLASH
	db  3, GEODUDE
	db  2, GRAVELER
	db  1, GOLEM
	db  4, ONIX
	db  4, CUBONE
	db  1, MAROWAK1
	db  2, MAROWAK2
	db  2, RHYHORN
	db  1, RHYDON
	db  2, BILL
	db  1, MR_FUJI
	db  2, POKE_BALL
	db  1, POKEDEX
	db  3, DEFENDER
	db  2, POKEMON_FLUTE
	db  0 ; end of list

ExcavationCardList: ; 1b1fe (6:71fe)
	db 15, FIGHTING_ENERGY
	db  8, WATER_ENERGY
	db  3, SHELLDER
	db  1, CLOYSTER
	db  3, OMANYTE
	db  2, OMASTAR
	db  4, SANDSHREW
	db  2, SANDSLASH
	db  3, CUBONE
	db  1, MAROWAK2
	db  3, HITMONCHAN
	db  2, KABUTO
	db  1, KABUTOPS
	db  2, AERODACTYL
	db  2, PROFESSOR_OAK
	db  2, BILL
	db  2, POKEMON_BREEDER
	db  4, MYSTERIOUS_FOSSIL
	db  0 ; end of list

RockCrusherCardList: ; 1b223 (6:7223)
	db 24, FIGHTING_ENERGY
	db  2, DOUBLE_COLORLESS_ENERGY
	db  4, DIGLETT
	db  2, DUGTRIO
	db  4, GEODUDE
	db  3, GRAVELER
	db  2, GOLEM
	db  3, ONIX
	db  3, RHYHORN
	db  2, PROFESSOR_OAK
	db  1, POKEMON_BREEDER
	db  2, ENERGY_REMOVAL
	db  2, SWITCH
	db  1, COMPUTER_SEARCH
	db  2, DEFENDER
	db  1, SUPER_POTION
	db  2, POTION
	db  0 ; end of list

BlueWaterCardList: ; 1b246 (6:7246)
	db 25, WATER_ENERGY
	db  2, PSYDUCK
	db  1, GOLDUCK
	db  2, POLIWAG
	db  1, POLIWHIRL
	db  1, POLIWRATH
	db  2, SEEL
	db  1, DEWGONG
	db  2, SHELLDER
	db  1, CLOYSTER
	db  2, KRABBY
	db  1, KINGLER
	db  2, HORSEA
	db  1, SEADRA
	db  1, MAGIKARP
	db  1, GYARADOS
	db  1, LAPRAS
	db  1, OMANYTE
	db  1, OMASTAR
	db  1, ARTICUNO1
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  1, POKEMON_TRADER
	db  2, MYSTERIOUS_FOSSIL
	db  1, ENERGY_SEARCH
	db  1, POKE_BALL
	db  1, POTION
	db  1, SUPER_POTION
	db  0 ; end of list

OnTheBeachCardList: ; 1b27f (6:727f)
	db 16, WATER_ENERGY
	db 10, FIGHTING_ENERGY
	db  2, SEEL
	db  1, DEWGONG
	db  3, SHELLDER
	db  2, CLOYSTER
	db  3, KRABBY
	db  2, KINGLER
	db  3, STARYU
	db  2, STARMIE
	db  3, SANDSHREW
	db  2, SANDSLASH
	db  2, BILL
	db  2, ENERGY_RETRIEVAL
	db  2, ENERGY_REMOVAL
	db  2, GUST_OF_WIND
	db  3, POTION
	db  0 ; end of list

ParalyzeCardList: ; 1b2a2 (6:72a2)
	db  8, GRASS_ENERGY
	db 14, WATER_ENERGY
	db  4, DOUBLE_COLORLESS_ENERGY
	db  3, CATERPIE
	db  2, METAPOD
	db  3, SQUIRTLE
	db  2, WARTORTLE
	db  3, SHELLDER
	db  2, CLOYSTER
	db  4, STARYU
	db  3, STARMIE
	db  2, PROFESSOR_OAK
	db  2, BILL
	db  2, PLUSPOWER
	db  2, DEFENDER
	db  4, POTION
	db  0 ; end of list

EnergyRemovalCardList: ; 1b2c3 (6:72c3)
	db 15, WATER_ENERGY
	db  8, PSYCHIC_ENERGY
	db  3, DOUBLE_COLORLESS_ENERGY
	db  3, PSYDUCK
	db  2, GOLDUCK
	db  4, POLIWAG
	db  3, POLIWHIRL
	db  2, POLIWRATH
	db  4, GASTLY2
	db  3, HAUNTER1
	db  3, DRATINI
	db  2, DRAGONAIR
	db  1, PROFESSOR_OAK
	db  1, BILL
	db  1, LASS
	db  2, ENERGY_SEARCH
	db  2, ENERGY_REMOVAL
	db  1, SUPER_ENERGY_REMOVAL
	db  0 ; end of list

RainDancerCardList: ; 1b2e8 (6:72e8)
	db 24, WATER_ENERGY
	db  4, SQUIRTLE
	db  3, WARTORTLE
	db  2, BLASTOISE
	db  4, GOLDEEN
	db  3, SEAKING
	db  3, HORSEA
	db  2, SEADRA
	db  2, LAPRAS
	db  2, PROFESSOR_OAK
	db  1, POKEMON_BREEDER
	db  1, ENERGY_RETRIEVAL
	db  1, SUPER_ENERGY_RETRIEVAL
	db  2, ENERGY_REMOVAL
	db  1, SUPER_ENERGY_REMOVAL
	db  2, SWITCH
	db  2, POTION
	db  1, GAMBLER
	db  0 ; end of list

CutePokemonCardList: ; 1b30d (6:730d)
	db  4, FIRE_ENERGY
	db  6, WATER_ENERGY
	db  8, LIGHTNING_ENERGY
	db  2, DOUBLE_COLORLESS_ENERGY
	db  1, FLAREON2
	db  1, VAPOREON2
	db  1, PIKACHU1
	db  1, PIKACHU2
	db  1, PIKACHU3
	db  1, PIKACHU4
	db  1, FLYING_PIKACHU
	db  1, SURFING_PIKACHU1
	db  1, SURFING_PIKACHU2
	db  1, RAICHU1
	db  1, RAICHU2
	db  1, JOLTEON2
	db  2, CLEFAIRY
	db  1, CLEFABLE
	db  1, JIGGLYPUFF1
	db  2, JIGGLYPUFF2
	db  1, JIGGLYPUFF3
	db  2, WIGGLYTUFF
	db  4, EEVEE
	db  2, PROFESSOR_OAK
	db  3, BILL
	db  2, CLEFAIRY_DOLL
	db  2, SCOOP_UP
	db  1, COMPUTER_SEARCH
	db  1, PLUSPOWER
	db  1, DEFENDER
	db  3, POTION
	db  0 ; end of list

PokemonFluteCardList: ; 1b34c (6:734c)
	db  9, WATER_ENERGY
	db 12, LIGHTNING_ENERGY
	db  2, STARYU
	db  2, LAPRAS
	db  3, PIKACHU1
	db  1, RAICHU1
	db  2, MAGNEMITE1
	db  3, ELECTABUZZ2
	db  2, RATTATA
	db  1, RATICATE
	db  2, PROFESSOR_OAK
	db  4, BILL
	db  3, ENERGY_REMOVAL
	db  1, COMPUTER_SEARCH
	db  3, PLUSPOWER
	db  2, ITEM_FINDER
	db  4, GUST_OF_WIND
	db  4, POKEMON_FLUTE
	db  0 ; end of list

YellowFlashCardList: ; 1b371 (6:7371)
	db 26, LIGHTNING_ENERGY
	db  2, PIKACHU1
	db  1, PIKACHU2
	db  1, RAICHU1
	db  1, RAICHU2
	db  2, MAGNEMITE1
	db  1, MAGNEMITE2
	db  1, MAGNETON1
	db  1, MAGNETON2
	db  3, VOLTORB
	db  1, ELECTRODE1
	db  1, ELECTRODE2
	db  1, ELECTABUZZ1
	db  1, ELECTABUZZ2
	db  1, JOLTEON1
	db  1, JOLTEON2
	db  1, ZAPDOS1
	db  1, ZAPDOS2
	db  3, EEVEE
	db  1, ENERGY_RETRIEVAL
	db  2, ENERGY_REMOVAL
	db  2, POKE_BALL
	db  2, PLUSPOWER
	db  2, DEFENDER
	db  1, GUST_OF_WIND
	db  0 ; end of list

ElectricShockCardList: ; 1b3a4 (6:73a4)
	db 24, LIGHTNING_ENERGY
	db  1, DOUBLE_COLORLESS_ENERGY
	db  2, PIKACHU2
	db  1, PIKACHU3
	db  1, PIKACHU4
	db  2, RAICHU1
	db  2, MAGNEMITE1
	db  2, MAGNEMITE2
	db  2, MAGNETON1
	db  4, VOLTORB
	db  3, ELECTRODE2
	db  1, ZAPDOS2
	db  3, PORYGON
	db  2, ENERGY_RETRIEVAL
	db  2, PLUSPOWER
	db  3, DEFENDER
	db  2, ITEM_FINDER
	db  3, GUST_OF_WIND
	db  0 ; end of list

ZappingSelfdestructCardList: ; 1b3c9 (6:73c9)
	db 24, LIGHTNING_ENERGY
	db  2, DOUBLE_COLORLESS_ENERGY
	db  4, MAGNEMITE1
	db  3, MAGNETON1
	db  4, VOLTORB
	db  2, ELECTRODE1
	db  4, ELECTABUZZ2
	db  2, KANGASKHAN
	db  1, TAUROS
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  2, SWITCH
	db  4, DEFENDER
	db  1, GUST_OF_WIND
	db  4, POTION
	db  0 ; end of list

InsectCollectionCardList: ; 1b3e8 (6:73e8)
	db 24, GRASS_ENERGY
	db  3, CATERPIE
	db  2, METAPOD
	db  1, BUTTERFREE
	db  3, WEEDLE
	db  2, KAKUNA
	db  1, BEEDRILL
	db  4, PARAS
	db  3, PARASECT
	db  2, VENONAT
	db  1, VENOMOTH
	db  1, SCYTHER
	db  1, PINSIR
	db  2, BILL
	db  2, POKEMON_BREEDER
	db  2, SWITCH
	db  2, POKE_BALL
	db  2, POKEDEX
	db  2, POTION
	db  0 ; end of list

JungleCardList: ; 1b40f (6:740f)
	db 25, GRASS_ENERGY
	db  1, DOUBLE_COLORLESS_ENERGY
	db  2, EKANS
	db  1, ARBOK
	db  2, ZUBAT
	db  1, GOLBAT
	db  2, ODDISH
	db  1, GLOOM
	db  1, VILEPLUME
	db  2, PARAS
	db  1, PARASECT
	db  2, VENONAT
	db  1, VENOMOTH
	db  2, BELLSPROUT
	db  1, WEEPINBELL
	db  1, VICTREEBEL
	db  1, PINSIR
	db  1, LICKITUNG
	db  1, KANGASKHAN
	db  2, BILL
	db  1, SWITCH
	db  1, POKE_BALL
	db  2, PLUSPOWER
	db  2, DEFENDER
	db  2, POTION
	db  1, FULL_HEAL
	db  0 ; end of list

FlowerGardenCardList: ; 1b444 (6:7444)
	db 24, GRASS_ENERGY
	db  2, DOUBLE_COLORLESS_ENERGY
	db  3, BULBASAUR
	db  2, IVYSAUR
	db  2, VENUSAUR2
	db  3, ODDISH
	db  2, GLOOM
	db  2, VILEPLUME
	db  2, BELLSPROUT
	db  1, WEEPINBELL
	db  1, VICTREEBEL
	db  2, TANGELA1
	db  1, TANGELA2
	db  2, LICKITUNG
	db  2, POKEMON_TRADER
	db  3, POKEMON_BREEDER
	db  1, ENERGY_SEARCH
	db  2, SWITCH
	db  2, POTION
	db  1, FULL_HEAL
	db  0 ; end of list

KaleidoscopeCardList: ; 1b46d (6:746d)
	db 10, GRASS_ENERGY
	db  4, FIRE_ENERGY
	db  4, WATER_ENERGY
	db  4, LIGHTNING_ENERGY
	db  3, DOUBLE_COLORLESS_ENERGY
	db  3, VENONAT
	db  2, VENOMOTH
	db  1, FLAREON1
	db  1, FLAREON2
	db  1, VAPOREON1
	db  1, VAPOREON2
	db  1, JOLTEON1
	db  1, JOLTEON2
	db  4, DITTO
	db  4, EEVEE
	db  4, PORYGON
	db  2, BILL
	db  2, MR_FUJI
	db  2, ENERGY_SEARCH
	db  4, SWITCH
	db  2, GUST_OF_WIND
	db  0 ; end of list

FlowerPowerCardList: ; 1b498 (6:7498)
	db 18, GRASS_ENERGY
	db  4, PSYCHIC_ENERGY
	db  4, BULBASAUR
	db  3, IVYSAUR
	db  2, VENUSAUR2
	db  4, ODDISH
	db  3, GLOOM
	db  2, VILEPLUME
	db  4, EXEGGCUTE
	db  3, EXEGGUTOR
	db  2, PROFESSOR_OAK
	db  3, BILL
	db  2, POKEMON_BREEDER
	db  2, ENERGY_RETRIEVAL
	db  2, SWITCH
	db  2, POTION
	db  0 ; end of list

PsychicPowerCardList: ; 1b4b9 (6:74b9)
	db 25, PSYCHIC_ENERGY
	db  3, ABRA
	db  2, KADABRA
	db  1, ALAKAZAM
	db  2, SLOWPOKE2
	db  1, SLOWBRO
	db  1, GASTLY1
	db  2, GASTLY2
	db  1, HAUNTER1
	db  1, HAUNTER2
	db  1, GENGAR
	db  2, DROWZEE
	db  1, HYPNO
	db  1, MR_MIME
	db  1, JYNX
	db  1, MEWTWO1
	db  1, MEW3
	db  1, CLEFAIRY
	db  1, CLEFABLE
	db  1, SNORLAX
	db  2, PROFESSOR_OAK
	db  1, POKEMON_TRADER
	db  1, POKEMON_BREEDER
	db  2, SWITCH
	db  1, POKEMON_CENTER
	db  2, PLUSPOWER
	db  1, DEVOLUTION_SPRAY
	db  0 ; end of list

DreamEaterHaunterCardList: ; 1b40f (6:740f)
	db  7, GRASS_ENERGY
	db 17, PSYCHIC_ENERGY
	db  3, ZUBAT
	db  2, GOLBAT
	db  4, GASTLY1
	db  1, HAUNTER1
	db  2, HAUNTER2
	db  2, GENGAR
	db  3, DROWZEE
	db  2, HYPNO
	db  2, JIGGLYPUFF3
	db  2, MEOWTH2
	db  2, PROFESSOR_OAK
	db  2, BILL
	db  2, ENERGY_RETRIEVAL
	db  1, SUPER_ENERGY_RETRIEVAL
	db  2, SWITCH
	db  1, COMPUTER_SEARCH
	db  3, REVIVE
	db  0 ; end of list

ScavengingSlowbroCardList: ; 1b517 (6:7517)
	db 23, PSYCHIC_ENERGY
	db  4, SLOWPOKE2
	db  3, SLOWBRO
	db  3, JYNX
	db  2, MEWTWO1
	db  2, MEW3
	db  2, JIGGLYPUFF2
	db  2, JIGGLYPUFF3
	db  2, EEVEE
	db  2, ENERGY_RETRIEVAL
	db  3, ENERGY_REMOVAL
	db  2, PLUSPOWER
	db  3, DEFENDER
	db  3, POTION
	db  4, RECYCLE
	db  0 ; end of list

StrangePowerCardList: ; 1b536 (6:7536)
	db 25, PSYCHIC_ENERGY
	db  1, DOUBLE_COLORLESS_ENERGY
	db  3, SLOWPOKE1
	db  2, SLOWBRO
	db  4, DROWZEE
	db  3, HYPNO
	db  2, MR_MIME
	db  2, JYNX
	db  1, MEW1
	db  2, MEW3
	db  2, LICKITUNG
	db  1, SNORLAX
	db  2, POKEMON_TRADER
	db  2, ENERGY_RETRIEVAL
	db  2, ENERGY_REMOVAL
	db  1, SUPER_ENERGY_REMOVAL
	db  2, PLUSPOWER
	db  1, ITEM_FINDER
	db  1, GUST_OF_WIND
	db  1, FULL_HEAL
	db  0 ; end of list

StrangePsyshockCardList: ; 1b55f (6:755f)
	db 22, PSYCHIC_ENERGY
	db  4, ABRA
	db  3, KADABRA
	db  2, ALAKAZAM
	db  2, MR_MIME
	db  3, CHANSEY
	db  3, KANGASKHAN
	db  2, SNORLAX
	db  2, PROFESSOR_OAK
	db  2, POKEMON_CENTER
	db  3, ENERGY_REMOVAL
	db  3, GUST_OF_WIND
	db  4, SCOOP_UP
	db  4, SWITCH
	db  1, GAMBLER
	db  0 ; end of list

LovelyNidoranCardList: ; 1b57e (6:757e)
	db 20, GRASS_ENERGY
	db  4, NIDORANF
	db  3, NIDORINA
	db  2, NIDOQUEEN
	db  4, NIDORANM
	db  4, NIDORINO
	db  4, NIDOKING
	db  3, LICKITUNG
	db  2, PROFESSOR_OAK
	db  3, POKEMON_TRADER
	db  3, POKEMON_BREEDER
	db  2, ENERGY_RETRIEVAL
	db  3, SWITCH
	db  1, COMPUTER_SEARCH
	db  2, ITEM_FINDER
	db  0 ; end of list

ScienceCorpsCardList: ; 1b59d (6:759d)
	db 26, GRASS_ENERGY
	db  2, EKANS
	db  1, ARBOK
	db  2, NIDORANF
	db  1, NIDORINA
	db  1, NIDOQUEEN
	db  3, NIDORANM
	db  2, NIDORINO
	db  1, NIDOKING
	db  2, ZUBAT
	db  1, GOLBAT
	db  2, GRIMER
	db  1, MUK
	db  2, KOFFING
	db  1, WEEZING
	db  2, MEOWTH2
	db  1, PERSIAN
	db  1, PROFESSOR_OAK
	db  1, BILL
	db  1, POKEMON_TRADER
	db  1, POKEMON_BREEDER
	db  1, POTION
	db  1, FULL_HEAL
	db  1, MAINTENANCE
	db  1, GAMBLER
	db  1, RECYCLE
	db  0 ; end of list

FlyinPokemonCardList: ; 1b5d2 (6:75d2)
	db 13, GRASS_ENERGY
	db 10, LIGHTNING_ENERGY
	db  2, DOUBLE_COLORLESS_ENERGY
	db  4, ZUBAT
	db  3, GOLBAT
	db  2, FLYING_PIKACHU
	db  4, PIDGEY
	db  3, PIDGEOTTO
	db  1, PIDGEOT1
	db  1, PIDGEOT2
	db  4, SPEAROW
	db  3, FEAROW
	db  2, IMPOSTER_PROFESSOR_OAK
	db  2, LASS
	db  2, BILL
	db  4, POTION
	db  0 ; end of list

PoisonCardList: ; 1b5f3 (6:75f3)
	db 24, GRASS_ENERGY
	db  3, WEEDLE
	db  2, KAKUNA
	db  1, BEEDRILL
	db  4, EKANS
	db  3, ARBOK
	db  4, NIDORANM
	db  3, NIDORINO
	db  2, NIDOKING
	db  3, KOFFING
	db  2, WEEZING
	db  1, PROFESSOR_OAK
	db  2, IMPOSTER_PROFESSOR_OAK
	db  1, POKEMON_BREEDER
	db  2, POTION
	db  2, FULL_HEAL
	db  1, GAMBLER
	db  0 ; end of list

WondersOfScienceCardList: ; 1b616 (6:7616)
	db 15, GRASS_ENERGY
	db  8, PSYCHIC_ENERGY
	db  4, GRIMER
	db  3, MUK
	db  4, KOFFING
	db  3, WEEZING
	db  2, MEWTWO1
	db  1, MEWTWO3
	db  1, MEWTWO2
	db  2, PORYGON
	db  1, IMPOSTER_PROFESSOR_OAK
	db  2, PROFESSOR_OAK
	db  2, BILL
	db  2, ENERGY_SEARCH
	db  2, SWITCH
	db  2, COMPUTER_SEARCH
	db  2, POKEDEX
	db  2, MAINTENANCE
	db  2, FULL_HEAL
	db  0 ; end of list

ReplaceEmAllCardList: ; 1b63d (6:763d)
	db 24, FIRE_ENERGY
	db  4, VULPIX
	db  2, NINETAILS1
	db  1, NINETAILS2
	db  4, GROWLITHE
	db  1, ARCANINE1
	db  1, ARCANINE2
	db  4, PIDGEY
	db  3, PIDGEOTTO
	db  1, PIDGEOT1
	db  1, PIDGEOT2
	db  3, DODUO
	db  2, DODRIO
	db  2, PROFESSOR_OAK
	db  2, IMPOSTER_PROFESSOR_OAK
	db  2, LASS
	db  3, GUST_OF_WIND
	db  0 ; end of list

ChariSaurCardList: ; 1b660 (6:7660)
	db 12, GRASS_ENERGY
	db 10, FIRE_ENERGY
	db  4, BULBASAUR
	db  3, IVYSAUR
	db  2, VENUSAUR2
	db  4, CHARMANDER
	db  3, CHARMELEON
	db  2, CHARIZARD
	db  3, FLAREON1
	db  4, EEVEE
	db  2, BILL
	db  3, POKEMON_TRADER
	db  3, POKEMON_BREEDER
	db  2, ENERGY_RETRIEVAL
	db  1, ENERGY_REMOVAL
	db  2, POTION
	db  0 ; end of list

TrafficLightCardList: ; 1b681 (6:7681)
	db 10, FIRE_ENERGY
	db  8, WATER_ENERGY
	db  8, LIGHTNING_ENERGY
	db  3, CHARMANDER
	db  2, CHARMELEON
	db  3, PONYTA
	db  2, RAPIDASH
	db  2, FLAREON1
	db  2, VAPOREON1
	db  2, PIKACHU1
	db  3, VOLTORB
	db  2, ELECTRODE2
	db  2, JOLTEON1
	db  4, EEVEE
	db  2, ENERGY_SEARCH
	db  2, SWITCH
	db  3, PLUSPOWER
	db  0 ; end of list

FirePokemonCardList: ; 1b6a4 (6:76a4)
	db 24, FIRE_ENERGY
	db  2, DOUBLE_COLORLESS_ENERGY
	db  3, CHARMANDER
	db  2, CHARMELEON
	db  1, CHARIZARD
	db  3, VULPIX
	db  1, NINETAILS1
	db  1, NINETAILS2
	db  2, GROWLITHE
	db  1, ARCANINE2
	db  2, PONYTA
	db  1, RAPIDASH
	db  1, MAGMAR1
	db  1, MAGMAR2
	db  1, FLAREON1
	db  1, FLAREON2
	db  1, MOLTRES1
	db  3, EEVEE
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  1, POKEMON_TRADER
	db  1, POKEMON_BREEDER
	db  1, ENERGY_RETRIEVAL
	db  1, SUPER_ENERGY_RETRIEVAL
	db  1, SWITCH
	db  1, GUST_OF_WIND
	db  0 ; end of list

FireChargeCardList: ; 1b6d9 (6:76d9)
	db 21, FIRE_ENERGY
	db  4, DOUBLE_COLORLESS_ENERGY
	db  4, GROWLITHE
	db  3, ARCANINE2
	db  2, MAGMAR1
	db  3, JIGGLYPUFF1
	db  1, JIGGLYPUFF3
	db  1, WIGGLYTUFF
	db  2, CHANSEY
	db  2, TAUROS
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  2, ENERGY_RETRIEVAL
	db  1, POKE_BALL
	db  1, COMPUTER_SEARCH
	db  2, DEFENDER
	db  3, POTION
	db  1, FULL_HEAL
	db  3, RECYCLE
	db  1, GAMBLER
	db  0 ; end of list

CharmanderAndFriendsCardList: ; 1b702 (6:7702)
	db  8, GRASS_ENERGY
	db 10, FIRE_ENERGY
	db  6, WATER_ENERGY
	db  2, CATERPIE
	db  1, METAPOD
	db  2, NIDORANF
	db  1, NIDORANM
	db  1, PINSIR
	db  2, CHARMANDER
	db  1, CHARMELEON
	db  1, CHARIZARD
	db  2, GROWLITHE
	db  1, ARCANINE2
	db  2, PONYTA
	db  1, MAGMAR1
	db  2, SEEL
	db  1, DEWGONG
	db  2, GOLDEEN
	db  1, SEAKING
	db  2, RATTATA
	db  1, RATICATE
	db  1, MEOWTH1
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  1, SWITCH
	db  1, COMPUTER_SEARCH
	db  1, PLUSPOWER
	db  2, POTION
	db  2, FULL_HEAL
	db  0 ; end of list

SquirtleAndFriendsCardList: ; 1b73d (6:773d)
	db  8, FIRE_ENERGY
	db 11, WATER_ENERGY
	db  6, LIGHTNING_ENERGY
	db  2, CHARMANDER
	db  1, CHARMELEON
	db  1, GROWLITHE
	db  1, ARCANINE2
	db  1, MAGMAR1
	db  2, SQUIRTLE
	db  1, WARTORTLE
	db  1, BLASTOISE
	db  2, SEEL
	db  1, DEWGONG
	db  1, GOLDEEN
	db  1, SEAKING
	db  1, STARYU
	db  1, STARMIE
	db  1, LAPRAS
	db  2, PIKACHU1
	db  1, MAGNEMITE1
	db  1, MAGNETON1
	db  1, ELECTABUZZ2
	db  2, RATTATA
	db  1, RATICATE
	db  1, MEOWTH1
	db  1, PROFESSOR_OAK
	db  1, BILL
	db  1, SWITCH
	db  1, POKE_BALL
	db  1, SCOOP_UP
	db  1, ITEM_FINDER
	db  1, POTION
	db  1, FULL_HEAL
	db  0 ; end of list

BulbasaurAndFriendsCardList: ; 1b780 (6:7780)
	db  9, GRASS_ENERGY
	db  8, LIGHTNING_ENERGY
	db  6, PSYCHIC_ENERGY
	db  2, BULBASAUR
	db  1, IVYSAUR
	db  1, VENUSAUR2
	db  2, NIDORANF
	db  2, NIDORANM
	db  1, NIDORINO
	db  1, TANGELA2
	db  2, PIKACHU1
	db  1, RAICHU1
	db  1, MAGNEMITE1
	db  1, ELECTABUZZ2
	db  2, ABRA
	db  1, KADABRA
	db  2, GASTLY1
	db  1, HAUNTER2
	db  1, JYNX
	db  1, JIGGLYPUFF3
	db  1, MEOWTH1
	db  1, KANGASKHAN
	db  1, PROFESSOR_OAK
	db  1, BILL
	db  1, SWITCH
	db  1, POKE_BALL
	db  2, PLUSPOWER
	db  1, DEFENDER
	db  1, GUST_OF_WIND
	db  2, POTION
	db  2, FULL_HEAL
	db  0 ; end of list

PsychicMachampCardList: ; 1b7b (6:77b)
	db 12, FIGHTING_ENERGY
	db 12, PSYCHIC_ENERGY
	db  2, DIGLETT
	db  1, DUGTRIO
	db  2, MACHOP
	db  1, MACHOKE
	db  1, MACHAMP
	db  1, ONIX
	db  1, HITMONLEE
	db  1, HITMONCHAN
	db  2, ABRA
	db  1, KADABRA
	db  1, ALAKAZAM
	db  2, GASTLY1
	db  1, HAUNTER2
	db  1, GENGAR
	db  1, MR_MIME
	db  1, JYNX
	db  1, MEW3
	db  2, PIDGEY
	db  1, PIDGEOTTO
	db  1, PIDGEOT2
	db  2, RATTATA
	db  1, RATICATE
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  1, SWITCH
	db  1, GUST_OF_WIND
	db  2, POTION
	db  1, FULL_HEAL
	db  0 ; end of list

WaterBeetleCardList: ; 1b7fc (6:77fc)
	db 14, GRASS_ENERGY
	db 10, WATER_ENERGY
	db  2, WEEDLE
	db  1, KAKUNA
	db  1, BEEDRILL
	db  2, NIDORANM
	db  1, NIDORINO
	db  1, NIDOKING
	db  2, BELLSPROUT
	db  1, WEEPINBELL
	db  1, VICTREEBEL
	db  1, SCYTHER
	db  2, POLIWAG
	db  1, POLIWHIRL
	db  1, POLIWRATH
	db  2, KRABBY
	db  1, KINGLER
	db  2, MAGIKARP
	db  1, GYARADOS
	db  1, LAPRAS
	db  1, ARTICUNO1
	db  1, LICKITUNG
	db  1, KANGASKHAN
	db  1, TAUROS
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  1, ENERGY_RETRIEVAL
	db  1, ENERGY_SEARCH
	db  1, SWITCH
	db  1, PLUSPOWER
	db  1, FULL_HEAL
	db  0 ; end of list

LegendaryMoltresCardList: ; 1b83b (6:783b)
	db 25, FIRE_ENERGY
	db  4, VULPIX
	db  3, NINETAILS2
	db  4, GROWLITHE
	db  2, ARCANINE2
	db  2, MAGMAR1
	db  2, MAGMAR2
	db  2, MOLTRES1
	db  2, MOLTRES2
	db  3, BILL
	db  2, LASS
	db  1, POKEMON_TRADER
	db  1, ENERGY_RETRIEVAL
	db  1, SUPER_ENERGY_RETRIEVAL
	db  2, ENERGY_REMOVAL
	db  2, SWITCH
	db  1, POTION
	db  1, SUPER_POTION
	db  0 ; end of list

LegendaryZapdosCardList: ; 1b860 (6:7860)
	db 25, LIGHTNING_ENERGY
	db  4, VOLTORB
	db  3, ELECTRODE1
	db  4, ELECTABUZZ2
	db  2, JOLTEON2
	db  1, ZAPDOS1
	db  1, ZAPDOS2
	db  2, ZAPDOS3
	db  3, EEVEE
	db  4, BILL
	db  2, ENERGY_RETRIEVAL
	db  2, SWITCH
	db  3, PLUSPOWER
	db  3, POTION
	db  1, GAMBLER
	db  0 ; end of list

LegendaryArticunoCardList: ; 1b87f (6:787f)
	db 25, WATER_ENERGY
	db  4, SEEL
	db  3, DEWGONG
	db  4, LAPRAS
	db  2, ARTICUNO2
	db  2, ARTICUNO1
	db  3, CHANSEY
	db  2, DITTO
	db  2, PROFESSOR_OAK
	db  2, POKEMON_TRADER
	db  3, ENERGY_RETRIEVAL
	db  3, SWITCH
	db  4, SCOOP_UP
	db  1, GAMBLER
	db  0 ; end of list

LegendaryDragoniteCardList: ; 1b89c (6:789c)
	db 20, WATER_ENERGY
	db  4, DOUBLE_COLORLESS_ENERGY
	db  3, CHARMANDER
	db  2, CHARMELEON
	db  2, CHARIZARD
	db  3, MAGIKARP
	db  2, GYARADOS
	db  2, LAPRAS
	db  2, KANGASKHAN
	db  4, DRATINI
	db  3, DRAGONAIR
	db  2, DRAGONITE1
	db  2, PROFESSOR_OAK
	db  2, POKEMON_TRADER
	db  2, POKEMON_BREEDER
	db  1, ENERGY_RETRIEVAL
	db  1, SUPER_ENERGY_RETRIEVAL
	db  2, SWITCH
	db  1, GAMBLER
	db  0 ; end of list

MysteriousPokemonCardList: ; 1b8c3 (6:78c3)
	db 12, GRASS_ENERGY
	db 14, PSYCHIC_ENERGY
	db  4, BULBASAUR
	db  3, IVYSAUR
	db  2, VENUSAUR1
	db  2, SCYTHER
	db  4, ABRA
	db  3, KADABRA
	db  2, ALAKAZAM
	db  2, MR_MIME
	db  1, MEW1
	db  2, MEW2
	db  1, PROFESSOR_OAK
	db  2, BILL
	db  2, POKEMON_BREEDER
	db  1, ENERGY_REMOVAL
	db  2, SWITCH
	db  1, POKEMON_CENTER
	db  0 ; end of list
; 0x1b8e8
