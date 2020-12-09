AIActionTable_WondersOfScience: ; 151ad (5:51ad)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 151b9 (5:51b9)
	call AIMainTurnLogic
	ret

.start_duel ; 151bd (5:51bd)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 151ce (5:51ce)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 151d2 (5:51d2)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 151d6 (5:51d6)
	call AIPickPrizeCards
	ret

.list_arena ; 151da (5:51da)
	db MEWTWO1
	db MEWTWO3
	db MEWTWO2
	db GRIMER
	db KOFFING
	db PORYGON
	db $00

.list_bench ; 151e1 (5:51e1)
	db GRIMER
	db KOFFING
	db MEWTWO3
	db MEWTWO2
	db MEWTWO1
	db PORYGON
	db $00

.list_retreat ; 151e8 (5:51e8)
	db $00

.list_energy ; 151e9 (5:51e9)
	ai_energy GRIMER,  3, +0
	ai_energy MUK,     4, +0
	ai_energy KOFFING, 2, +0
	ai_energy WEEZING, 3, +0
	ai_energy MEWTWO1, 2, -1
	ai_energy MEWTWO3, 2, -1
	ai_energy MEWTWO2, 2, -1
	ai_energy PORYGON, 2, -1
	db $00

.list_prize ; 15202 (5:5202)
	db MUK
	db $00

.store_list_pointers ; 15204 (5:5204)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x15232
