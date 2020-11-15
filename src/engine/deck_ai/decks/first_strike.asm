AIActionTable_FirstStrike: ; 14e89 (5:4e89)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 14e95 (5:4e95)
	call AIMainTurnLogic
	ret

.start_duel ; 14e99 (5:4e99)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 14eaa (5:4eaa)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 14eae (5:4eae)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 14eb2 (5:4eb2)
	call AIPickPrizeCards
	ret

.list_arena ; 14eb6 (5:1eb6)
	db HITMONCHAN
	db MACHOP
	db HITMONLEE
	db MANKEY
	db $00

.list_bench ; 14ebb (5:1ebb)
	db MACHOP
	db HITMONLEE
	db HITMONCHAN
	db MANKEY
	db $00

.list_retreat ; 14ec0 (5:1ec0)
	ai_retreat MACHOP,  -1
	ai_retreat MACHOKE, -1
	ai_retreat MANKEY,  -2
	db $00

.list_energy ; 14ec7 (5:1ec7)
	ai_energy MACHOP,     3, +0
	ai_energy MACHOKE,    4, +0
	ai_energy MACHAMP,    4, -1
	ai_energy HITMONCHAN, 3, +0
	ai_energy HITMONLEE,  3, +0
	ai_energy MANKEY,     2, -1
	ai_energy PRIMEAPE,   3, -1
	db $00

.list_prize ; 14edd (5:1edd)
	db HITMONLEE
	db HITMONCHAN
	db $00

.store_list_pointers ; 14ee0 (5:4ee0)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x14f0e
