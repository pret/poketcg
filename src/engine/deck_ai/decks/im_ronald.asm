AIActionTable_ImRonald: ; 152bd (5:52bd)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 152c9 (5:52c9)
	call AIMainTurnLogic
	ret

.start_duel ; 152cd (5:52cd)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 152de (5:52de)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 152e2 (5:52e2)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 152e6 (5:52e6)
	call AIPickPrizeCards
	ret

.list_arena ; 152ea (5:52ea)
	db LAPRAS
	db SEEL
	db CHARMANDER
	db CUBONE
	db SQUIRTLE
	db GROWLITHE
	db $00

.list_bench ; 152f1 (5:52f1)
	db CHARMANDER
	db SQUIRTLE
	db SEEL
	db CUBONE
	db GROWLITHE
	db LAPRAS
	db $00

.list_retreat ; 152f8 (5:52f8)
	db $00

.list_energy ; 152f9 (5:52f9)
	ai_energy CHARMANDER, 3, +0
	ai_energy CHARMELEON, 5, +0
	ai_energy GROWLITHE,  2, +0
	ai_energy ARCANINE2,  4, +0
	ai_energy SQUIRTLE,   2, +0
	ai_energy WARTORTLE,  3, +0
	ai_energy SEEL,       3, +0
	ai_energy DEWGONG,    4, +0
	ai_energy LAPRAS,     3, +0
	ai_energy CUBONE,     3, +0
	ai_energy MAROWAK1,   3, +0
	db $00

.list_prize ; 1531b (5:531b)
	db LAPRAS
	db $00

.store_list_pointers ; 1531d (5:531d)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x1534b
