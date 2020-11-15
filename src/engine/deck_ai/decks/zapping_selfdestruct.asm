AIActionTable_ZappingSelfdestruct: ; 15019 (5:5019)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 15025 (5:5025)
	call AIMainTurnLogic
	ret

.start_duel ; 15029 (5:5029)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 1503a (5:503a)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 1503e (5:503e)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 15042 (5:5042)
	call AIPickPrizeCards
	ret

.list_arena ; 15046 (5:5046)
	db KANGASKHAN
	db ELECTABUZZ2
	db TAUROS
	db MAGNEMITE1
	db VOLTORB
	db $00

.list_bench ; 1504c (5:504c)
	db MAGNEMITE1
	db VOLTORB
	db ELECTABUZZ2
	db TAUROS
	db KANGASKHAN
	db $00

.list_retreat ; 15052 (5:5052)
	ai_retreat VOLTORB, -1
	db $00

.list_energy ; 15055 (5:5055)
	ai_energy MAGNEMITE1,  3, +1
	ai_energy MAGNETON1,   4, +0
	ai_energy VOLTORB,     3, +1
	ai_energy ELECTRODE1,  3, +0
	ai_energy ELECTABUZZ2, 1, +0
	ai_energy KANGASKHAN,  2, -2
	ai_energy TAUROS,      3, +0
	db $00

.list_prize ; 1506b (5:506b)
	db KANGASKHAN
	db $00

.store_list_pointers ; 1506d (5:506d)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x1509b
