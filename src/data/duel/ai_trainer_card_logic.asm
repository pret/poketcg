MACRO ai_trainer_card_logic
	db \1 ; AI_TRAINER_CARD_PHASE_* constant
	db \2 ; ID of trainer card
	dw \3 ; function for AI decision to play card
	dw \4 ; function for AI playing the card
ENDM

AITrainerCardLogic:
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_07, POTION,                 AIDecide_Potion_Phase07,                 AIPlay_Potion
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_10, POTION,                 AIDecide_Potion_Phase10,                 AIPlay_Potion
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_08, SUPER_POTION,           AIDecide_SuperPotion1,                   AIPlay_SuperPotion
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_11, SUPER_POTION,           AIDecide_SuperPotion2,                   AIPlay_SuperPotion
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_13, DEFENDER,               AIDecide_Defender1,                      AIPlay_Defender
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_14, DEFENDER,               AIDecide_Defender2,                      AIPlay_Defender
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_13, PLUSPOWER,              AIDecide_Pluspower1,                     AIPlay_Pluspower
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_14, PLUSPOWER,              AIDecide_Pluspower2,                     AIPlay_Pluspower
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_09, SWITCH,                 AIDecide_Switch,                         AIPlay_Switch
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_07, GUST_OF_WIND,           AIDecide_GustOfWind,                     AIPlay_GustOfWind
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_10, GUST_OF_WIND,           AIDecide_GustOfWind,                     AIPlay_GustOfWind
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_04, BILL,                   AIDecide_Bill,                           AIPlay_Bill
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_05, ENERGY_REMOVAL,         AIDecide_EnergyRemoval,                  AIPlay_EnergyRemoval
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_05, SUPER_ENERGY_REMOVAL,   AIDecide_SuperEnergyRemoval,             AIPlay_SuperEnergyRemoval
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_07, POKEMON_BREEDER,        AIDecide_PokemonBreeder,                 AIPlay_PokemonBreeder
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_15, PROFESSOR_OAK,          AIDecide_ProfessorOak,                   AIPlay_ProfessorOak
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_10, ENERGY_RETRIEVAL,       AIDecide_EnergyRetrieval,                AIPlay_EnergyRetrieval
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_11, SUPER_ENERGY_RETRIEVAL, AIDecide_SuperEnergyRetrieval,           AIPlay_SuperEnergyRetrieval
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_06, POKEMON_CENTER,         AIDecide_PokemonCenter,                  AIPlay_PokemonCenter
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_07, IMPOSTER_PROFESSOR_OAK, AIDecide_ImposterProfessorOak,           AIPlay_ImposterProfessorOak
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_12, ENERGY_SEARCH,          AIDecide_EnergySearch,                   AIPlay_EnergySearch
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_03, POKEDEX,                AIDecide_Pokedex,                        AIPlay_Pokedex
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_07, FULL_HEAL,              AIDecide_FullHeal,                       AIPlay_FullHeal
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_10, MR_FUJI,                AIDecide_MrFuji,                         AIPlay_MrFuji
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_10, SCOOP_UP,               AIDecide_ScoopUp,                        AIPlay_ScoopUp
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_02, MAINTENANCE,            AIDecide_Maintenance,                    AIPlay_Maintenance
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_03, RECYCLE,                AIDecide_Recycle,                        AIPlay_Recycle
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_13, LASS,                   AIDecide_Lass,                           AIPlay_Lass
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_04, ITEM_FINDER,            AIDecide_ItemFinder,                     AIPlay_ItemFinder
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_01, IMAKUNI_CARD,           AIDecide_Imakuni,                        AIPlay_Imakuni
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_01, GAMBLER,                AIDecide_Gambler,                        AIPlay_Gambler
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_05, REVIVE,                 AIDecide_Revive,                         AIPlay_Revive
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_13, POKEMON_FLUTE,          AIDecide_PokemonFlute,                   AIPlay_PokemonFlute
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_05, CLEFAIRY_DOLL,          AIDecide_ClefairyDollOrMysteriousFossil, AIPlay_ClefairyDollOrMysteriousFossil
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_05, MYSTERIOUS_FOSSIL,      AIDecide_ClefairyDollOrMysteriousFossil, AIPlay_ClefairyDollOrMysteriousFossil
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_02, POKE_BALL,              AIDecide_Pokeball,                       AIPlay_Pokeball
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_02, COMPUTER_SEARCH,        AIDecide_ComputerSearch,                 AIPlay_ComputerSearch
	ai_trainer_card_logic AI_TRAINER_CARD_PHASE_02, POKEMON_TRADER,         AIDecide_PokemonTrader,                  AIPlay_PokemonTrader
	db $ff
