AIActionTable_FireCharge: ; 15232 (5:5232)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 1523e (5:523e)
	call AIMainTurnLogic
	ret

.start_duel ; 15242 (5:5242)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 15253 (5:5253)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 15257 (5:5257)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 1525b (5:525b)
	call AIPickPrizeCards
	ret

.list_arena ; 1525f (5:525f)
	db JIGGLYPUFF3
	db CHANSEY
	db TAUROS
	db MAGMAR1
	db JIGGLYPUFF1
	db GROWLITHE
	db $00

.list_bench ; 15266 (5:5266)
	db JIGGLYPUFF3
	db CHANSEY
	db GROWLITHE
	db MAGMAR1
	db JIGGLYPUFF1
	db TAUROS
	db $00

.list_retreat ; 1526e (5:526e)
	ai_retreat JIGGLYPUFF1, -1
	ai_retreat CHANSEY,     -1
	ai_retreat GROWLITHE,   -1
	db $00

.list_energy ; 15274 (5:5274)
	ai_energy GROWLITHE,   3, +0
	ai_energy ARCANINE2,   4, +0
	ai_energy MAGMAR1,     3, +0
	ai_energy JIGGLYPUFF1, 3, +0
	ai_energy JIGGLYPUFF3, 2, +0
	ai_energy WIGGLYTUFF,  3, +0
	ai_energy CHANSEY,     4, +0
	ai_energy TAUROS,      3, +0
	db $00

.list_prize ; 1528d (5:528d)
	db GAMBLER
	db $00

.store_list_pointers ; 1528f (5:528f)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x152bd
