AIActionTable_StrangePsyshock: ; 15122 (5:5122)
	dw .do_turn ; unused
	dw .do_turn
	dw .start_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn ; 1512e (5:512e)
	call AIMainTurnLogic
	ret

.start_duel ; 15132 (5:5132)
	call InitAIDuelVars
	call .store_list_pointers
	call SetUpBossStartingHandAndDeck
	call TrySetUpBossStartingPlayArea
	ret nc
	call AIPlayInitialBasicCards
	ret

.forced_switch ; 15143 (5:5143)
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch ; 15147 (5:5147)
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize ; 1514b (5:514b)
	call AIPickPrizeCards
	ret

.list_arena ; 1514f (5:514f)
	db KANGASKHAN
	db CHANSEY
	db SNORLAX
	db MR_MIME
	db ABRA
	db $00

.list_bench ; 15155 (5:5155)
	db ABRA
	db MR_MIME
	db KANGASKHAN
	db SNORLAX
	db CHANSEY
	db $00

.list_retreat ; 1515b (5:515b)
	ai_retreat ABRA,       -3
	ai_retreat SNORLAX,    -3
	ai_retreat KANGASKHAN, -1
	ai_retreat CHANSEY,    -1
	db $00

.list_energy ; 15164 (5:5164)
	ai_energy ABRA,       3, +1
	ai_energy KADABRA,    3, +0
	ai_energy ALAKAZAM,   3, +0
	ai_energy MR_MIME,    2, +0
	ai_energy CHANSEY,    2, -2
	ai_energy KANGASKHAN, 4, -2
	ai_energy SNORLAX,    0, -8
	db $00

.list_prize ; 1517a (5:517a)
	db GAMBLER
	db MR_MIME
	db ALAKAZAM
	db SWITCH
	db $00

.store_list_pointers ; 1517f (5:517f)
	store_list_pointer wAICardListAvoidPrize, .list_prize
	store_list_pointer wAICardListArenaPriority, .list_arena
	store_list_pointer wAICardListBenchPriority, .list_bench
	store_list_pointer wAICardListPlayFromHandPriority, .list_bench
	; missing store_list_pointer wAICardListRetreatBonus, .list_retreat
	store_list_pointer wAICardListEnergyBonus, .list_energy
	ret
; 0x151ad
