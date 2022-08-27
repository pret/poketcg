AIActionTable_WondersOfScience:
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
	db MEWTWO_LV53
	db MEWTWO_ALT_LV60
	db MEWTWO_LV60
	db GRIMER
	db KOFFING
	db PORYGON
	db $00

.list_bench
	db GRIMER
	db KOFFING
	db MEWTWO_ALT_LV60
	db MEWTWO_LV60
	db MEWTWO_LV53
	db PORYGON
	db $00

.list_retreat
	db $00

.list_energy
	ai_energy GRIMER,          3, +0
	ai_energy MUK,             4, +0
	ai_energy KOFFING,         2, +0
	ai_energy WEEZING,         3, +0
	ai_energy MEWTWO_LV53,     2, -1
	ai_energy MEWTWO_ALT_LV60, 2, -1
	ai_energy MEWTWO_LV60,     2, -1
	ai_energy PORYGON,         2, -1
	db $00

.list_prize
	db MUK
	db $00

.store_list_pointers
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
