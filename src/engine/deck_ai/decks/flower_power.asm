AIActionTable_FlowerPower: ; 1509b (5:509b)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 150a7 (5:50a7)
	call AIMainTurnLogic
	ret

.start_duel ; 150ab (5:50ab)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 150bc (5:50bc)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 150c0 (5:50c0)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 150c4 (5:50c4)
	call AIPickPrizeCards
	ret

.list_arena ; 150c8 (5:50c8)
	db ODDISH
	db EXEGGCUTE
	db BULBASAUR
	db $00

.list_bench ; 150cc (5:50cc)
	db BULBASAUR
	db EXEGGCUTE
	db ODDISH
	db $00

.list_retreat ; 150cf (5:50cf)
	ai_retreat GLOOM,     -2
	ai_retreat VILEPLUME, -2
	ai_retreat BULBASAUR, -2
	ai_retreat IVYSAUR,   -2
	db $00

.list_energy ; 150d9 (5:50d9)
	ai_energy BULBASAUR,  3, +0
	ai_energy IVYSAUR,    4, +0
	ai_energy VENUSAUR2,  4, +0
	ai_energy ODDISH,     2, +0
	ai_energy GLOOM,      3, -1
	ai_energy VILEPLUME,  3, -1
	ai_energy EXEGGCUTE,  3, +0
	ai_energy EXEGGUTOR, 22, +0
	db $00

.list_prize ; 150f2 (5:50f2)
	db VENUSAUR2
	db $00

.store_list_pointers ; 150f4 (5:50f4)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x15122
