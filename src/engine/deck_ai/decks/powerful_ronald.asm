AIActionTable_PowerfulRonald: ; 1534b (5:534b)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 15357 (5:5357)
	call AIMainTurnLogic
	ret

.start_duel ; 1535b (5:535b)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 1536c (5:536c)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 15370 (5:5370)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 15374 (5:5374)
	call AIPickPrizeCards
	ret

.list_arena ; 15378 (5:5378)
	db KANGASKHAN
	db ELECTABUZZ2
	db HITMONCHAN
	db MR_MIME
	db LICKITUNG
	db HITMONLEE
	db TAUROS
	db JYNX
	db MEWTWO1
	db DODUO
	db $00

.list_bench ; 15383 (5:5383)
	db KANGASKHAN
	db HITMONLEE
	db HITMONCHAN
	db TAUROS
	db DODUO
	db JYNX
	db MEWTWO1
	db ELECTABUZZ2
	db MR_MIME
	db LICKITUNG
	db $00

.list_retreat ; 1538e (5:538e)
	ai_retreat KANGASKHAN, -1
	ai_retreat DODUO,      -1
	ai_retreat DODRIO,     -1
	db $00

.list_energy ; 15395 (5:5395)
	ai_energy ELECTABUZZ2, 2, +1
	ai_energy HITMONLEE,   3, +1
	ai_energy HITMONCHAN,  3, +1
	ai_energy MR_MIME,     2, +0
	ai_energy JYNX,        3, +0
	ai_energy MEWTWO1,     2, +0
	ai_energy DODUO,       3, -1
	ai_energy DODRIO,      3, -1
	ai_energy LICKITUNG,   2, +0
	ai_energy KANGASKHAN,  4, -1
	ai_energy TAUROS,      3, +0
	db $00

.list_prize ; 153b7 (5:53b7)
	db GAMBLER
	db ENERGY_REMOVAL
	db $00

.store_list_pointers ; 153ba (5:53ba)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x153e8
