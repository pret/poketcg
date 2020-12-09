AIActionTable_InvincibleRonald: ; 153e8 (5:53e8)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 153f4 (5:53f4)
	call AIMainTurnLogic
	ret

.start_duel ; 153f8 (5:53f8)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 15409 (5:5409)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 1540d (5:540d)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 15411 (5:5411)
	call AIPickPrizeCards
	ret

.list_arena ; 15415 (5:5415)
	db KANGASKHAN
	db MAGMAR2
	db CHANSEY
	db GEODUDE
	db SCYTHER
	db GRIMER
	db $00

.list_bench ; 1541c (5:541c)
	db GRIMER
	db SCYTHER
	db GEODUDE
	db CHANSEY
	db MAGMAR2
	db KANGASKHAN
	db $00

.list_retreat ; 15423 (5:5423)
	ai_retreat GRIMER, -1
	db $00

.list_energy ; 15426 (5:5426)
	ai_energy GRIMER,     1, -1
	ai_energy MUK,        3, -1
	ai_energy SCYTHER,    4, +1
	ai_energy MAGMAR2,    2, +0
	ai_energy GEODUDE,    2, +0
	ai_energy GRAVELER,   3, +0
	ai_energy CHANSEY,    4, +0
	ai_energy KANGASKHAN, 4, -1
	db $00

.list_prize ; 1543f (5:543f)
	db GAMBLER
	db $00

.store_list_pointers ; 15441 (5:5441)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x1546f
