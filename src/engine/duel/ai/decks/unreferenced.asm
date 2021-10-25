AIActionTable_Unreferenced: ; unreferenced
	dw $406c
	dw .do_turn
	dw .do_turn
	dw .star_duel
	dw .forced_switch
	dw .ko_switch
	dw .take_prize

.do_turn
	call AIDecidePlayPokemonCard
	call AIDecideWhetherToRetreat
	jr nc, .try_attack
	call AIDecideBenchPokemonToSwitchTo
	call AITryToRetreat
	call AIDecideWhetherToRetreat
	jr nc, .try_attack
	call AIDecideBenchPokemonToSwitchTo
	call AITryToRetreat
.try_attack
	call AIProcessAndTryToPlayEnergy
	call AIProcessAndTryToUseAttack
	ret c
	ld a, OPPACTION_FINISH_NO_ATTACK
	bank1call AIMakeDecision
	ret

.star_duel
	call AIPlayInitialBasicCards
	ret

.forced_switch
	call AIDecideBenchPokemonToSwitchTo
	ret

.ko_switch
	call AIDecideBenchPokemonToSwitchTo
	ret

.take_prize
	call AIPickPrizeCards
	ret
