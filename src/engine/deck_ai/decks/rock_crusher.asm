AIActionTable_RockCrusher: ; 14f0e (5:4f0e)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14f1a (5:4f1a)
	call AIMainTurnLogic
	ret

.start_duel ; 14f1e (5:4f1e)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 14f2f (5:4f2f)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 14f33 (5:4f33)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 14f37 (5:4f37)
	call AIPickPrizeCards
	ret

.list_arena ; 14f3b (5:4f3b)
	db RHYHORN
	db ONIX
	db GEODUDE
	db DIGLETT
	db $00

.list_bench ; 14f40 (5:4f40)
	db DIGLETT
	db GEODUDE
	db RHYHORN
	db ONIX
	db $00

.list_retreat ; 14f45 (5:4f45)
	ai_retreat DIGLETT, -1
	db $00

.list_energy ; 14f48 (5:4f48)
	ai_energy DIGLETT,  3, +1
	ai_energy DUGTRIO,  4, +0
	ai_energy GEODUDE,  2, +1
	ai_energy GRAVELER, 3, +0
	ai_energy GOLEM,    4, +0
	ai_energy ONIX,     2, -1
	ai_energy RHYHORN,  3, +0
	db $00

.list_prize ; 14f5e (5:4f5e)
	db ENERGY_REMOVAL
	db RHYHORN
	db $00

.store_list_pointers ; 14f61 (5:4f61)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x14f8f
