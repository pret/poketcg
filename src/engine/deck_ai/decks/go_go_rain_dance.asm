AIActionTable_GoGoRainDance: ; 14f8f (5:4f8f)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14f9b (5:4f9b)
	call AIMainTurnLogic
	ret

.start_duel ; 14f9f (5:4f9f)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 14fb0 (5:4fb0)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 14fb4 (5:4fb4)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 14fb8 (5:4fb8)
	call AIPickPrizeCards
	ret

.list_arena ; 14fbc (5:4fbc)
	db LAPRAS
	db HORSEA
	db GOLDEEN
	db SQUIRTLE
	db $00

.list_bench ; 14fc1 (5:4fc1)
	db SQUIRTLE
	db HORSEA
	db GOLDEEN
	db LAPRAS
	db $00

.list_retreat ; 14fc6 (5:4fc6)
	ai_retreat SQUIRTLE,  -3
	ai_retreat WARTORTLE, -2
	ai_retreat HORSEA,    -1
	db $00

.list_energy ; 14fcd (5:4fcd)
	ai_energy SQUIRTLE,  2, +0
	ai_energy WARTORTLE, 3, +0
	ai_energy BLASTOISE, 5, +0
	ai_energy GOLDEEN,   1, +0
	ai_energy SEAKING,   2, +0
	ai_energy HORSEA,    2, +0
	ai_energy SEADRA,    3, +0
	ai_energy LAPRAS,    3, +0
	db $00

.list_prize ; 14fe6 (5:4fe6)
	db GAMBLER
	db ENERGY_RETRIEVAL
	db SUPER_ENERGY_RETRIEVAL
	db BLASTOISE
	db $00

.store_list_pointers ; 14feb (5:4feb)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x15019
