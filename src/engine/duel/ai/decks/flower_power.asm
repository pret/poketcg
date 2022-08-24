AIActionTable_FlowerPower:
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
	db ODDISH
	db EXEGGCUTE
	db BULBASAUR
	db $00

.list_bench
	db BULBASAUR
	db EXEGGCUTE
	db ODDISH
	db $00

.list_retreat
	ai_retreat GLOOM,     -2
	ai_retreat VILEPLUME, -2
	ai_retreat BULBASAUR, -2
	ai_retreat IVYSAUR,   -2
	db $00

.list_energy
	ai_energy BULBASAUR,      3, +0
	ai_energy IVYSAUR,        4, +0
	ai_energy VENUSAUR_LV67,  4, +0
	ai_energy ODDISH,         2, +0
	ai_energy GLOOM,          3, -1
	ai_energy VILEPLUME,      3, -1
	ai_energy EXEGGCUTE,      3, +0
	ai_energy EXEGGUTOR,     22, +0
	db $00

.list_prize
	db VENUSAUR_LV67
	db $00

.store_list_pointers
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
