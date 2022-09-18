AIActionTable_ImRonald:
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn
	call AIMainTurnLogic
	ret

.start_duel
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize
	call AIPickPrizeCards
	ret

.list_arena
	db LAPRAS
	db SEEL
	db CHARMANDER
	db CUBONE
	db SQUIRTLE
	db GROWLITHE
	db $00

.list_bench
	db CHARMANDER
	db SQUIRTLE
	db SEEL
	db CUBONE
	db GROWLITHE
	db LAPRAS
	db $00

.list_retreat
	db $00

.list_energy
	ai_energy CHARMANDER,     3, +0
	ai_energy CHARMELEON,     5, +0
	ai_energy GROWLITHE,      2, +0
	ai_energy ARCANINE_LV45,  4, +0
	ai_energy SQUIRTLE,       2, +0
	ai_energy WARTORTLE,      3, +0
	ai_energy SEEL,           3, +0
	ai_energy DEWGONG,        4, +0
	ai_energy LAPRAS,         3, +0
	ai_energy CUBONE,         3, +0
	ai_energy MAROWAK_LV26,   3, +0
	db $00

.list_prize
	db LAPRAS
	db $00

.store_list_pointers
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
