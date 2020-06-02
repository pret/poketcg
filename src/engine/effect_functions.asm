Poison50PercentEffect: ; 2c000 (b:4000)
	ldtx de, PoisonCheckText
	call TossCoin_BankB
	ret nc

PoisonEffect: ; 2c007 (b:4007)
	lb bc, CNF_SLP_PRZ, POISONED
	jr ApplyStatusEffect

DoublePoisonEffect: ; 2c00c (b:400c)
	lb bc, CNF_SLP_PRZ, DOUBLE_POISONED
	jr ApplyStatusEffect

Paralysis50PercentEffect: ; 2c011 (b:4011)
	ldtx de, ParalysisCheckText
	call TossCoin_BankB
	ret nc

ParalysisEffect: ; 2c018 (b:4018)
	lb bc, PSN_DBLPSN, PARALYZED
	jr ApplyStatusEffect

Confusion50PercentEffect: ; 2c01d (b:401d)
	ldtx de, ConfusionCheckText
	call TossCoin_BankB
	ret nc

ConfusionEffect: ; 2c024 (b:4024)
	lb bc, PSN_DBLPSN, CONFUSED
	jr ApplyStatusEffect

Sleep50PercentEffect: ; 2c029 (b:4029)
	ldtx de, SleepCheckText
	call TossCoin_BankB
	ret nc

SleepEffect: ; 2c030 (b:4030)
	lb bc, PSN_DBLPSN, ASLEEP
	jr ApplyStatusEffect

ApplyStatusEffect:
	ldh a, [hWhoseTurn]
	ld hl, wWhoseTurn
	cp [hl]
	jr nz, .can_induce_status
	ld a, [wTempNonTurnDuelistCardID]
	cp CLEFAIRY_DOLL
	jr z, .cant_induce_status
	cp MYSTERIOUS_FOSSIL
	jr z, .cant_induce_status
	; Snorlax's Thick Skinned prevents it from being statused...
	cp SNORLAX
	jr nz, .can_induce_status
	call SwapTurn
	xor a
	; ...unless already so, or if affected by Muk's Toxic Gas
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	call SwapTurn
	jr c, .can_induce_status

.cant_induce_status
	ld a, c
	ld [wNoEffectFromStatus], a
	call SetNoEffectFromStatus
	or a
	ret

.can_induce_status
	ld hl, wEffectFunctionsFeedbackIndex
	push hl
	ld e, [hl]
	ld d, $0
	ld hl, wEffectFunctionsFeedback
	add hl, de
	call SwapTurn
	ldh a, [hWhoseTurn]
	ld [hli], a
	call SwapTurn
	ld [hl], b ; mask of status conditions not to discard on the target
	inc hl
	ld [hl], c ; status condition to inflict to the target
	pop hl
	; advance wEffectFunctionsFeedbackIndex
	inc [hl]
	inc [hl]
	inc [hl]
	scf
	ret

TossCoin_BankB: ; 2c07e (b:407e)
	call TossCoin
	ret

TossCoinATimes_BankB: ; 2c082 (b:4082)
	call TossCoinATimes
	ret

CommentedOut_2c086: ; 2c086 (b:4086)
	ret

Func_2c087: ; 2c087 (b:4087)
	xor a
	jr Func_2c08c

Func_2c08a: ; 2c08a (b:408a)
	ld a, $1

Func_2c08c:
	push de
	push af
	ld a, OPPACTION_TOSS_COIN_A_TIMES
	call SetOppAction_SerialSendDuelData
	pop af
	pop de
	call SerialSend8Bytes
	call TossCoinATimes
	ret

SetNoEffectFromStatus: ; 2c09c (b:409c)
	ld a, EFFECT_FAILED_NO_EFFECT
	ld [wEffectFailed], a
	ret

SetWasUnsuccessful: ; 2c0a2 (b:40a2)
	ld a, EFFECT_FAILED_UNSUCCESSFUL
	ld [wEffectFailed], a
	ret

Func_2c0a8: ; 2c0a8 (b:40a8)
	ldh a, [hTemp_ffa0]
	push af
	ldh a, [hWhoseTurn]
	ldh [hTemp_ffa0], a
	ld a, OPPACTION_6B30
	call SetOppAction_SerialSendDuelData
	bank1call Func_4f2d
	ld c, a
	pop af
	ldh [hTemp_ffa0], a
	ld a, c
	ret

Func_2c0bd: ; 2c0bd (b:40bd)
	call ExchangeRNG
	bank1call Func_4f2d
	call ShuffleDeck
	ret

; return carry if Turn Duelist is the Player
CheckIfTurnDuelistIsPlayer: ; 2c0c7 (b:40c7)
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .player
	or a
	ret
.player
	scf
	ret

; Stores information about the attack damage for AI purposes
; taking into account poison damage between turns.
; if target poisoned
;	[wAIMinDamage] <- [wDamage]
;	[wAIMaxDamage] <- [wDamage]
; else
; 	[wAIMinDamage] <- [wDamage] + d
; 	[wAIMaxDamage] <- [wDamage] + e
; 	[wDamage]      <- [wDamage] + a
StoreAIPoisonDamageInfo: ; 2c0d4 (b:40d4)
	push af
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	and POISONED | DOUBLE_POISONED
	jr z, Func_2c0e9.skip_push_af
	pop af
	ld a, [wDamage]
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	ret

Func_2c0e9: ; 2c0e9 (b:40e9)
	push af

.skip_push_af
	ld hl, wDamage
	ld a, [hl]
	add d
	ld [wAIMinDamage], a
	ld a, [hl]
	add e
	ld [wAIMaxDamage], a
	pop af
	add [hl]
	ld [hl], a
	ret

; Stores information about the attack damage for AI purposes
; [wDamage]      <- a (average amount of damage)
; [wAIMinDamage] <- d (minimum)
; [wAIMaxDamage] <- e (maximum)
StoreAIDamageInfo: ; 2c0fb (b:40fb)
	ld [wDamage], a
	xor a
	ld [wDamage + 1], a
	ld a, d
	ld [wAIMinDamage], a
	ld a, e
	ld [wAIMaxDamage], a
	ret

Func_2c10b: ; 2c10b (b:410b)
	ldh [hTempPlayAreaLocation_ff9d], a
	bank1call Func_61a1
	bank1call PrintPlayAreaCardList_EnableLCD
	bank1call Func_6194
	ret

; deal damage to all the turn holder's benched Pokemon
; input: a = amount of damage to deal to each Pokemon
DealDamageToAllBenchedPokemon: ; 2c117 (b:4117)
	ld e, a
	ld d, $00
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld b, PLAY_AREA_ARENA
	jr .skip_to_bench
.loop
	push bc
	call DealDamageToPlayAreaPokemon
	pop bc
.skip_to_bench
	inc b
	dec c
	jr nz, .loop
	ret

Func_2c12e: ; 2c12e (b:412e)
	ld [wLoadedMoveAnimation], a
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld b, a
	ld c, $0 ; neither WEAKNESS nor RESISTANCE
	ldh a, [hWhoseTurn]
	ld h, a
	bank1call PlayMoveAnimation
	bank1call WaitMoveAnimation
	ret

; apply a status condition of type 1 identified by register a to the target
ApplySubstatus1ToDefendingCard: ; 2c140 (b:4140)
	push af
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS1
	call GetTurnDuelistVariable
	pop af
	ld [hli], a
	ret

; apply a status condition of type 2 identified by register a to the target,
; unless prevented by wNoDamageOrEffect
ApplySubstatus2ToDefendingCard: ; 2c149 (b:4149)
	push af
	call CheckNoDamageOrEffect
	jr c, .no_damage_orEffect
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS2
	call GetNonTurnDuelistVariable
	pop af
	ld [hl], a
	ld l, $f6
	ld [hl], a
	ret

.no_damage_orEffect
	pop af
	push hl
	bank1call $4f9d
	pop hl
	ld a, l
	or h
	call nz, DrawWideTextBox_PrintText
	ret

; overwrites in wDamage, wAIMinDamage and wAIMaxDamage
; with the value in a.
StoreDamageInfo: ; 2c166 (b:4166)
	ld [wDamage], a
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	xor a
	ld [wDamage + 1], a
	ret
; 0x2c174

; overwrites wAIMinDamage and wAIMaxDamage
; with value in wDamage.
SetMinMaxDamageSameAsDamage: ; 2c174 (b:4174)
	ld a, [wDamage]
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	ret
; 0x2c17e

; returns in a a random Play Area location
; of card in Turn Duelist's Play Area.
PickRandomPlayAreaCard: ; 2c17e (b:417e)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	call Random
	or a
	ret
; 0x2c188

; outputs in hl the current position
; in hTempCardList list to place a new card.
GetCurPositionInTempList: ; 2c188 (b:4188)
	push de
	ld hl, hEffectItemSelection
	ld a, [hl]
	inc [hl]
	ld e, a
	ld d, $00
	ld hl, hTempCardList
	add hl, de
	pop de
	ret
; 0x2c197

; creates in wDuelTempList list of attached Fire Energy cards
; that are attached to the Turn Duelist's Arena card.
CreateListOfFireEnergyAttachedToArena: ; 2c197 (b:4197)
	ld a, TYPE_ENERGY_FIRE
	; fallthrough

; creates in wDuelTempList a list of cards that
; are in the Arena that are the same type as input a.
; used to list are Energy cards of a specific type
; that are attached to the Arena Pokemon.
; input:
;	a = TYPE_ENERGY_* constant
; output:
;	a = number of cards in list;
;	wDuelTempList filled with cards, terminated by $ff
CreateListOfEnergyAttachedToArena: ; 2c199 (b:4199)
	ld b, a
	ld c, 0
	ld de, wDuelTempList
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.loop
	ld a, [hl]
	cp CARD_LOCATION_ARENA
	jr nz, .next
	push de
	ld a, l
	call GetCardIDFromDeckIndex
	call GetCardType
	pop de
	cp b
	jr nz, .next ; is same as input type?
	ld a, l
	ld [de], a
	inc de
	inc c
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop

	ld a, $ff
	ld [de], a
	ld a, c
	ret
; 0x2c1c4

; prints the text "<X> devolved to <Y>!" with
; the proper card names and levels.
; input:
;	d = deck index of the lower stage card
;	e = deck index of card that was devolved
PrintDevolvedCardNameAndLevelText: ; 2c1c4 (b:41c4)
	push de
	ld a, e
	call LoadCardDataToBuffer1_FromDeckIndex
	ld bc, wTxRam2
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hl]
	ld [bc], a

	inc bc ; wTxRam2_b
	xor a
	ld [bc], a
	inc bc
	ld [bc], a

	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
	ld a, 18
	call CopyCardNameAndLevel
	ld [hl], $00
	ldtx hl, PokemonDevolvedToText
	call DrawWideTextBox_WaitForInput
	pop de
	ret
; 0x2c1ec

HandleSwitchDefendingPokemonEffect: ; 2c1ec (b:41ec)
	ld e, a
	cp $ff
	ret z

; check Defending Pokemon's HP
	ld a, DUELVARS_ARENA_CARD_HP
	call GetNonTurnDuelistVariable
	or a
	jr nz, .switch

; if 0, handle Destiny Bond first
	push de
	bank1call HandleDestinyBondSubstatus
	pop de

.switch
	call HandleNoDamageOrEffect
	ret c

; attack was successful, switch Defending Pokemon
	call SwapTurn
	call SwapArenaWithBenchPokemon
	call SwapTurn

	xor a
	ld [wccc5], a
	ld [wDuelDisplayedScreen], a
	inc a
	ld [wccef], a
	ret

; returns carry if Defending has No Damage or Effect
; if so, print its appropriate text.
HandleNoDamageOrEffect: ; 2c216 (b:4216)
	call CheckNoDamageOrEffect
	ret nc
	ld a, l
	or h
	call nz, DrawWideTextBox_PrintText
	scf
	ret
; 0x2c221

; applies HP recovery on Pokemon after an attack
; with HP recovery effect, and handles its animation.
; input:
;	d = damage effectiveness
;	e = HP amount to recover
ApplyAndAnimateHPRecovery: ; 2c221 (b:4221)
	push de
	ld hl, wccbd
	ld [hl], e
	inc hl
	ld [hl], d

; get Arena card's damage
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	pop de
	or a
	ret z ; return if no damage

; load correct animation
	push de
	ld a, $79
	ld [wLoadedMoveAnimation], a
	ld bc, $01 ; arrow
	bank1call PlayMoveAnimation

; compare HP to be restores with max HP
; if HP to be restored would cause HP to
; be larger than max HP, cap it accordingly
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	ld b, $00
	pop de
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	add e
	ld e, a
	ld a, 0
	adc d
	ld d, a 
	; de = damage dealt + current HP
	; bc = max HP of card
	call CompareDEtoBC
	jr c, .skip_cap
	; cap de to value in bc
	ld e, c
	ld d, b

.skip_cap
	ld [hl], e ; apply new HP to arena card
	bank1call WaitMoveAnimation
	ret
; 0x2c25b

; returns carry if Play Area has no damage counters.
CheckIfPlayAreaHasAnyDamage: ; 2c25b (b:425b)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld d, a
	ld e, PLAY_AREA_ARENA
.loop_play_area
	call GetCardDamageAndMaxHP
	or a
	ret nz ; found damage
	inc e
	dec d
	jr nz, .loop_play_area
	; no damage found
	scf
	ret
; 0x2c26e

; makes a list in wDuelTempList with the deck indices
; of Trainer cards found in Turn Duelist's Discard Pile.
; returns carry set if no Trainer cars found, and loads
; corresponding text to notify this.
CreateTrainerCardListFromDiscardPile: ; 2c26e (b:426e)
; get number of cards in Discard Pile
; and have hl point to the end of the
; Discard Pile list in wOpponentDeckCards.
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	call GetTurnDuelistVariable
	ld b, a
	add DUELVARS_DECK_CARDS
	ld l, a

	ld de, wDuelTempList
	inc b
	jr .next_card

.check_trainer
	ld a, [hl]
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	cp TYPE_TRAINER
	jr nz, .next_card

	ld a, [hl]
	ld [de], a
	inc de

.next_card
	dec l
	dec b
	jr nz, .check_trainer

	ld a, $ff ; terminating byte
	ld [de], a
	ld a, [wDuelTempList]
	cp $ff
	jr z, .no_trainers
	or a
	ret
.no_trainers
	ldtx hl, ThereAreNoTrainerCardsInDiscardPileText
	scf
	ret
; 0x2c2a0

; makes a list in wDuelTempList with the deck indices
; of all energy cards (including Double Colorless)
; found in Turn Duelist's Discard Pile.
CreateEnergyCardListFromDiscardPile_IncludeDoubleColorless: ; 2c2a0 (b:42a0)
	ld c, $01
	jr CreateEnergyCardListFromDiscardPile

; makes a list in wDuelTempList with the deck indices
; of all basic energy cards found in Turn Duelist's Discard Pile.
CreateEnergyCardListFromDiscardPile_OnlyBasic: ; 2c2a4 (b:42a4)
	ld c, $00
;	fallthrough

; makes a list in wDuelTempList with the deck indices
; of energy cards found in Turn Duelist's Discard Pile.
; if (c == 0), all energy cards are allowed;
; if (c != 0), double colorless energy cards are not included.
; returns carry if no energy cards were found.
CreateEnergyCardListFromDiscardPile: ; 2c2a6 (b:42a6)
; get number of cards in Discard Pile
; and have hl point to the end of the
; Discard Pile list in wOpponentDeckCards.
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE
	call GetTurnDuelistVariable
	ld b, a
	add DUELVARS_DECK_CARDS
	ld l, a

	ld de, wDuelTempList
	inc b
	jr .next_card

.check_energy
	ld a, [hl]
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	and TYPE_ENERGY
	jr z, .next_card

; if (c != $00), then we dismiss Double Colorless
; energy cards found.
	ld a, c
	or a
	jr z, .copy
	ld a, [wLoadedCard2Type]
	cp TYPE_ENERGY_DOUBLE_COLORLESS
	jr nc, .next_card

.copy
	ld a, [hl]
	ld [de], a
	inc de

; goes through Discard Pile list
; in wOpponentDeckCards in descending order.
.next_card
	dec l
	dec b
	jr nz, .check_energy

; terminating byte on wDuelTempList
	ld a, $ff
	ld [de], a

; check if any energy card was found
; by checking whether the first byte
; in wDuelTempList is $ff.
; if none were found, return carry.
	ld a, [wDuelTempList]
	cp $ff
	jr z, .set_carry
	or a
	ret

.set_carry
	scf
	ret
; 0x2c2e0

; returns carry if Deck is empty
CheckIfDeckIsEmpty: ; 2c2e0 (b:42e0)
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ldtx hl, NoCardsLeftInTheDeckText
	cp DECK_SIZE
	ccf
	ret
; 0x2c2ec

; searches through Deck in wDuelTempList looking for
; a certain card or cards, and prints text depending
; on whether at least one was found.
; if none were found, asks the Player whether to look
; in the Deck anyway, and returns carry if No is selected.
; uses SEARCHEFFECT_* as input which determines what to search for:
;	SEARCHEFFECT_CARD_ID = search for card ID in e
;	SEARCHEFFECT_NIDORAN = search for either NidoranM or NidoranF
;	SEARCHEFFECT_BASIC_FIGHTING = search for any Basic Fighting Pokemon
;	SEARCHEFFECT_BASIC_ENERGY = search for any Basic Energy
;	SEARCHEFFECT_POKEMON = search for any Pokemon card
; input:
;	d = SEARCHEFFECT_* constant
;	e = (optional) card ID to search for in deck
;	hl = text to print if Deck has card(s)
; output:
;	carry set if refuse to look at deck
LookForCardInDeck: ; 2c2ec (b:42ec)
	push hl
	push bc
	ld a, [wDuelTempList]
	cp $ff
	jr z, .none_in_deck
	ld a, d
	ld hl, .search_table
	call JumpToFunctionInTable
	jr c, .none_in_deck
	pop bc
	pop hl
	call DrawWideTextBox_WaitForInput
	or a
	ret

.none_in_deck
	pop hl
	call LoadTxRam2
	pop hl
	ldtx hl, ThereIsNoInTheDeckText
	call DrawWideTextBox_WaitForInput
	ldtx hl, WouldYouLikeToCheckTheDeckText
	call YesOrNoMenuWithText_SetCursorToYes
	ret
; 0x2c317

.search_table
	dw .SearchDeckForE
	dw .SearchDeckForNidoran
	dw .SearchDeckForBasicFighting
	dw .SearchDeckForBasicEnergy
	dw .SearchDeckForPokemon

.set_carry ; 2c321 (b:4321)
	scf
	ret
; 0x2c323

; returns carry if no card with
; same card ID as e is found in Deck
.SearchDeckForE ; 2c323 (b:4323)
	ld hl, wDuelTempList
.loop_deck_e
	ld a, [hli]
	cp $ff
	jr z, .set_carry
	push de
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	cp e
	jr nz, .loop_deck_e
	or a
	ret
; 0x2c336

; returns carry if no NidoranM or NidoranF card is found in Deck
.SearchDeckForNidoran ; 2c336 (b:4336)
	ld hl, wDuelTempList
.loop_deck_nidoran
	ld a, [hli]
	cp $ff
	jr z, .set_carry
	call GetCardIDFromDeckIndex
	ld a, e
	cp NIDORANF
	jr z, .found_nidoran
	cp NIDORANM
	jr nz, .loop_deck_nidoran
.found_nidoran
	or a
	ret
; 0x2c34c

; returns carry if no Basic Fighting Pokemon is found in Deck
.SearchDeckForBasicFighting ; 2c34c (b:434c)
	ld hl, wDuelTempList
.loop_deck_fighting
	ld a, [hli]
	cp $ff
	jr z, .set_carry
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	cp TYPE_PKMN_FIGHTING
	jr nz, .loop_deck_fighting
	ld a, [wLoadedCard2Stage]
	or a ; BASIC
	jr nz, .loop_deck_fighting
	ret
; 0x2c365

; returns carry if no Basic Energy cards are found in Deck
.SearchDeckForBasicEnergy ; 2c365 (b:4365)
	ld hl, wDuelTempList
.loop_deck_energy
	ld a, [hli]
	cp $ff
	jr z, .set_carry
	call GetCardIDFromDeckIndex
	call GetCardType
	cp TYPE_ENERGY_DOUBLE_COLORLESS
	jr z, .loop_deck_energy
	and TYPE_ENERGY
	jr z, .loop_deck_energy
	or a
	ret
; 0x2c37d

; returns carry if no Pokemon cards are found in Deck
.SearchDeckForPokemon ; 2c37d (b:437d)
	ld hl, wDuelTempList
.loop_deck_pkmn
	ld a, [hli]
	cp $ff
	jr z, .set_carry
	call GetCardIDFromDeckIndex
	call GetCardType
	cp TYPE_ENERGY
	jr nc, .loop_deck_pkmn
	or a
	ret
; 0x2c391

; outputs the Player selection of attack
; to use Amnesia on.
HandleAmnesiaScreen: ; 2c391 (b:4391)
	bank1call DrawDuelMainScene
	call SwapTurn
	xor a
	ldh [hEffectItemSelection], a

.start
	bank1call PrintAndLoadMovesToDuelTempList
	push af
	ldh a, [hEffectItemSelection]
	ld hl, .menu_parameters
	call InitializeMenuParameters
	pop af

	ld [wNumMenuItems], a
	call EnableLCD
.loop_input
	call DoFrame
	ldh a, [hKeysPressed]
	bit B_BUTTON_F, a
	jr nz, .set_carry
	and START
	jr nz, .open_move_page
	call HandleMenuInput
	jr nc, .loop_input
	cp $ff
	jr z, .loop_input

; a move was selected
	ldh a, [hCurMenuItem]
	add a
	ld e, a
	ld d, $00
	ld hl, wDuelTempList
	add hl, de
	ld d, [hl]
	inc hl
	ld e, [hl]
	call SwapTurn
	or a
	ret

.set_carry
	call SwapTurn
	scf
	ret

.open_move_page
	ldh a, [hCurMenuItem]
	ldh [hEffectItemSelection], a
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	bank1call OpenMovePage
	call SwapTurn
	bank1call DrawDuelMainScene
	call SwapTurn
	jr .start
; 0x2c3f4

.menu_parameters
	db 1, 13 ; cursor x, cursor y
	db 2 ; y displacement between items
	db 2 ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw $0000 ; function pointer if non-0
; 0x2c3fc

; loads in hl the pointer to attack's name.
; input:
;	d = deck index of card
; 	e = attack index (0 = first attack, 1 = second attack)
GetAttackName: ; 2c3fc (b:43fc)
	ld a, d
	call LoadCardDataToBuffer1_FromDeckIndex
	ld hl, wLoadedCard1Move1Name
	inc e
	dec e
	jr z, .load_name
	ld hl, wLoadedCard1Move2Name
.load_name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret
; 0x2c40e

; returns carry if Defending Pokemon
; doesn't have an attack.
CheckIfDefendingPokemonHasAnyAttack: ; 2c40e (b:440e)
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Move1Category]
	cp POKEMON_POWER
	jr nz, .has_attack
	ld hl, wLoadedCard2Move2Name
	ld a, [hli]
	or [hl]
	jr nz, .has_attack
	call SwapTurn
	scf
	ret
.has_attack
	call SwapTurn
	or a
	ret
; 0x2c431

; overwrites HP and Stage data of the card that was
; devolved in the Play Area to the values of new card.
; if the damage exceeds HP of pre-evolution,
; then HP is set to zero.
; input:
;	a = card index of pre-evolved card
UpdateDevolvedCardHPAndStage: ; 2c431 (b:4431)
	push bc
	push de
	push af
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetCardDamageAndMaxHP
	ld b, a ; store damage
	ld a, e
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	pop af

	ld [hl], a
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, e
	add DUELVARS_ARENA_CARD_HP
	ld l, a
	ld a, [wLoadedCard2HP]
	sub b ; subtract damage from new HP
	jr nc, .got_hp
	; damage exceeds HP
	xor a ; 0 HP
.got_hp
	ld [hl], a
	ld a, e
; overwrite card stage
	add DUELVARS_ARENA_CARD_STAGE
	ld l, a
	ld a, [wLoadedCard2Stage]
	ld [hl], a
	pop de
	pop bc
	ret
; 0x2c45d

; reset various status after devolving card.
ResetDevolvedCardStatus: ; 2c45d (b:445d)
; if it's Arena card, clear status conditions
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .skip_clear_status
	call ClearAllStatusConditions
.skip_clear_status
; reset changed color status
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_CHANGED_COLOR
	call GetTurnDuelistVariable
	ld [hl], $00
; reset C2 flags
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_FLAGS_C2
	ld l, a
	ld [hl], $00
	ret
; 0x2c476

; prompts the Player with a Yes/No question
; whether to quit the screen, even though
; they can select more cards from list.
; [hEffectItemSelection] holds number of cards
; that were already selected by the Player.
; input:
;	- a = total number of cards that can be selected
AskWhetherToQuitSelectingCards: ; 2c476 (b:4476)
	ld hl, hEffectItemSelection
	sub [hl]
	ld l, a
	ld h, $00
	call LoadTxRam3
	ldtx hl, YouCanSelectMoreCardsQuitText
	call YesOrNoMenuWithText
	ret
; 0x2c487

; handles the selection of a forced switch
; by link/AI opponent or by the player.
; outputs the Play Area location of the chosen
; bench card in hTempPlayAreaLocation_ff9d.
DuelistSelectForcedSwitch: ; 2c487 (b:4487)
	ld a, DUELVARS_DUELIST_TYPE
	call GetNonTurnDuelistVariable
	cp DUELIST_TYPE_LINK_OPP
	jr z, .link_opp

	cp DUELIST_TYPE_PLAYER
	jr z, .player

; AI opponent
	call SwapTurn
	bank1call AIDoAction_ForcedSwitch
	call SwapTurn

	ld a, [wPlayerAttackingMoveIndex]
	ld e, a
	ld a, [wPlayerAttackingCardIndex]
	ld d, a
	ld a, [wPlayerAttackingCardID]
	call CopyMoveDataAndDamage_FromCardID
	call Func_16f6
	ret

.player
	ldtx hl, SelectPkmnOnBenchToSwitchWithActiveText
	call DrawWideTextBox_WaitForInput
	call SwapTurn
	bank1call HasAlivePokemonInBench
	ld a, $01
	ld [wcbd4], a
.asm_2c4c0
	bank1call OpenPlayAreaScreenForSelection
	jr c, .asm_2c4c0
	call SwapTurn
	ret

.link_opp
; get selection from link opponent
	ld a, OPPACTION_FORCE_SWITCH_ACTIVE
	call SetOppAction_SerialSendDuelData
.loop
	call SerialRecvByte
	jr nc, .received
	halt
	nop
	jr .loop
.received
	ldh [hTempPlayAreaLocation_ff9d], a
	ret
; 0x2c4da

; returns in a the card index of energy card
; attached to Defending Pokemon
; that is to be discarded by the AI for an effect.
; outputs $ff is none was found.
; output:
;	a = deck index of attached energy card chosen
AIPickEnergyCardToDiscardFromDefendingPokemon: ; 2c4da (b:44da)
	call SwapTurn
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies

	xor a
	call CreateArenaOrBenchEnergyCardList
	jr nc, .has_energy
	; no energy, return
	ld a, $ff
	jr .done

.has_energy
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex
	ld e, COLORLESS
	ld a, [wAttachedEnergies + COLORLESS]
	or a
	jr nz, .pick_color ; has colorless attached?

	; no colorless energy attached.
	; if it's colorless Pokemon, just
	; pick any energy card at random...
	ld a, [wLoadedCard1Type]
	cp COLORLESS
	jr nc, .choose_random

	; ...if not, check if it has its
	; own color energy attached.
	; if it doesn't, pick at random.
	ld e, a
	ld d, $00
	ld hl, wAttachedEnergies
	add hl, de
	ld a, [hl]
	or a
	jr z, .choose_random

; pick attached card with same color as e
.pick_color
	ld hl, wDuelTempList
.loop_energy
	ld a, [hli]
	cp $ff
	jr z, .choose_random
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	and TYPE_PKMN
	cp e
	jr nz, .loop_energy
	dec hl

.done_chosen
	ld a, [hl]
.done
	call SwapTurn
	ret

.choose_random
	call CountCardsInDuelTempList
	ld hl, wDuelTempList
	call ShuffleCards
	jr .done_chosen
; 0x2c532

; handles AI logic to pick attack for Amnesia
AIPickAttackForAmnesia: ; 2c532 (b:4532)
; load Defending Pokemon attacks
	call SwapTurn
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	call HandleEnergyBurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	call LoadCardDataToBuffer2_FromDeckIndex
; if has no attack 1 name, return
	ld hl, wLoadedCard2Move1Name
	ld a, [hli]
	or [hl]
	jr z, .chosen

; if Defending Pokemon has enough energy for second attack, choose it
	ld e, SECOND_ATTACK
	bank1call _CheckIfEnoughEnergiesToMove
	jr nc, .chosen
; otherwise if first attack isn't a Pkmn Power, choose it instead.
	ld e, FIRST_ATTACK_OR_PKMN_POWER
	ld a, [wLoadedCard2Move1Category]
	cp POKEMON_POWER
	jr nz, .chosen
; if it is a Pkmn Power, choose second attack.
	ld e, SECOND_ATTACK
.chosen
	ld a, e
	call SwapTurn
	ret
; 0x2c564

; outputs in a the Play Area location (PLAY_AREA_* constant)
; of lowest HP card in non-duelist's Bench.
AIFindBenchWithLowestHP: ; 2c564 (b:4564)
	call SwapTurn
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	lb de, PLAY_AREA_ARENA, $ff
	ld b, d
	ld a, DUELVARS_BENCH1_CARD_HP
	call GetTurnDuelistVariable
	jr .start
; find Play Area location with least amount of HP
.loop_bench
	ld a, e
	cp [hl]
	jr c, .next ; skip if HP is higher
	ld e, [hl]
	ld d, b

.next
	inc hl
.start
	inc b
	dec c
	jr nz, .loop_bench

	ld a, d
	call SwapTurn
	ret
; 0x2c588

; handles drawing the Shift Screen and its input.
; outputs in a the color that was selected or,
; if B was pressed, returns carry.
; input:
;	a  = Play Area location (PLAY_AREA_*), with bit 7 set or unset
;	hl = text to be printed in the bottom box
; output:
;	a = color that was selected
HandleShiftScreen: ; 2c588 (b:4588)
	or a
	call z, SwapTurn
	push af
	call .DrawScreen
	pop af
	call z, SwapTurn

	ld hl, .menu_params
	xor a
	call InitializeMenuParameters
	call EnableLCD

.loop_input
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input
	cp -1 ; b pressed?
	jr z, .set_carry
	ld e, a
	ld d, $00
	ld hl, ShiftListItemToColor
	add hl, de
	ld a, [hl]
	or a
	ret
.set_carry
	scf
	ret

.menu_params
	db 1, 1 ; cursor x, cursor y
	db 2 ; y displacement between items
	db MAX_PLAY_AREA_POKEMON ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw $0000 ; function pointer if non-0
; 0x2c5be

.DrawScreen: ; 2c5be (b:45be)
	push hl
	push af
	call EmptyScreen
	call ZeroObjectPositions
	call LoadDuelCardSymbolTiles

; load card data
	pop af
	and $7f
	ld [wTempPlayAreaLocation_cceb], a
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex

; draw card gfx
	ld de, v0Tiles1 + $20 tiles ; destination offset of loaded gfx
	ld hl, wLoadedCard1Gfx
	ld a, [hli]
	ld h, [hl]
	ld l, a
	lb bc, $30, TILE_SIZE
	call LoadCardGfx
	bank1call SetBGP6OrSGB3ToCardPalette
	bank1call FlushAllPalettesOrSendPal23Packet
	ld a, $a0
	lb hl, 6, 1
	lb de, 9, 2
	lb bc, 8, 6
	call FillRectangle
	bank1call ApplyBGP6OrSGB3ToCardImage

; print card name and level at the top
	ld a, 16
	call CopyCardNameAndLevel
	ld [hl], $00
	lb de, 7, 0
	call InitTextPrinting
	ld hl, wDefaultText
	call ProcessText

; list all the colors
	ld hl, ShiftMenuData
	call PlaceTextItems

; print card's color, resistance and weakness
	ld a, [wTempPlayAreaLocation_cceb]
	call GetPlayAreaCardColor
	inc a
	lb bc, 15, 9
	call WriteByteToBGMap0
	ld a, [wTempPlayAreaLocation_cceb]
	call GetPlayAreaCardWeakness
	lb bc, 15, 10
	bank1call PrintCardPageWeaknessesOrResistances
	ld a, [wTempPlayAreaLocation_cceb]
	call GetPlayAreaCardResistance
	lb bc, 15, 11
	bank1call PrintCardPageWeaknessesOrResistances

	call DrawWideTextBox

; print list of color names on all list items
	lb de, 4, 1
	ldtx hl, ColorListText
	call InitTextPrinting_ProcessTextFromID

; print input hl to text box
	lb de, 1, 14
	pop hl
	call InitTextPrinting_ProcessTextFromID

; draw and apply palette to color icons
	ld hl, ColorTileAndBGP
	lb de, 2, 0
	ld c, NUM_COLORED_TYPES
.loop_colors
	ld a, [hli]
	push de
	push bc
	push hl
	lb hl, 1, 2
	lb bc, 2, 2
	call FillRectangle

	ld a, [wConsole]
	cp CONSOLE_CGB
	jr nz, .skip_vram1
	pop hl  ; unnecessary
	push hl ; unnecessary
	call BankswitchVRAM1
	ld a, [hl]
	lb hl, 0, 0
	lb bc, 2, 2
	call FillRectangle
	call BankswitchVRAM0

.skip_vram1
	pop hl
	pop bc
	pop de
	inc hl
	inc e
	inc e
	dec c
	jr nz, .loop_colors
	ret
; 0x2c686

; loads wTxRam2 and wTxRam2_b:
; [wTxRam2]   <- wLoadedCard1Name
; [wTxRam2_b] <- input color as text symbol
; input:
;	a = type (color) constant
LoadCardNameAndInputColor: ; 2c686 (b:4686)
	add a
	ld e, a
	ld d, $00
	ld hl, ColorToTextSymbol
	add hl, de

; load wTxRam2 with card's name
	ld de, wTxRam2
	ld a, [wLoadedCard1Name]
	ld [de], a
	inc de
	ld a, [wLoadedCard1Name + 1]
	ld [de], a

; load wTxRam2_b with ColorToTextSymbol
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ret
; 0x2c6a1

ShiftMenuData: ; 2c6a1 (b:46a1)
	; x, y, text id
	textitem 10,  9, TypeText
	textitem 10, 10, WeaknessText
	textitem 10, 11, ResistanceText
	db $ff

ColorTileAndBGP: ; 2c6ae (b:46ae)
	; tile, BG
	db $E4, $02
	db $E0, $01
	db $EC, $02
	db $E8, $01
	db $F0, $03
	db $F4, $03

ShiftListItemToColor: ; 2c6ba (b:46ba)
	db GRASS
	db FIRE
	db WATER
	db LIGHTNING
	db FIGHTING
	db PSYCHIC

ColorToTextSymbol:  ; 2c6c0 (b:46c0)
	tx FireSymbolText
	tx GrassSymbolText
	tx LightningSymbolText
	tx WaterSymbolText
	tx FightingSymbolText
	tx PsychicSymbolText

DrawSymbolOnPlayAreaCursor: ; 2c6cc (b:46cc)
	ld c, a
	add a
	add c
	add 2
	; a = 3*a + 2
	ld c, a
	ld a, b
	ld b, 0
	call WriteByteToBGMap0
	ret
; 0x2c6d9

	INCROM $2c6d9, $2c6e0

PlayAreaSelectionMenuParameters: ; 2c6e0 (b:46e0)
	db 0, 0 ; cursor x, cursor y
	db 3 ; y displacement between items
	db MAX_PLAY_AREA_POKEMON ; number of items
	db SYM_CURSOR_R ; cursor tile number
	db SYM_SPACE ; tile behind cursor
	dw $0000 ; function pointer if non-0
; 0x2c6e8

	INCROM $2c6e8, $2c6f0

SpitPoison_AIEffect: ; 2c6f0 (b:46f0)
	ld a, 10 / 2
	lb de, 0, 10
	jp StoreAIDamageInfo
; 0x2c6f8

; If heads, defending Pokemon becomes poisoned
SpitPoison_Poison50PercentEffect: ; 2c6f8 (b:46f8)
	ldtx de, PoisonCheckText
	call TossCoin_BankB
	jp c, PoisonEffect
	ld a, $8c
	ld [wLoadedMoveAnimation], a
	call SetNoEffectFromStatus
	ret

; outputs in [hTemp_ffa0] the result of the coin toss
; (0 = tails, 1 = heads) and, in case it was heads,
; stores in hTempPlayAreaLocation_ffa1 the location
; of the Bench Pokemon that was selected for switch.
TerrorStrike_50PercentSelectSwitchPokemon: ; 2c70a (b:470a)
	xor a
	ldh [hTemp_ffa0], a

; return failure if no Pokemon to switch to
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	cp 2
	ret c

; toss coin and store whether it was tails (0)
; or heads (1) in hTemp_ffa0
; return if it was tails.
	ldtx de, IfHeadsChangeOpponentsActivePokemonText
	call Func_2c08a
	ldh [hTemp_ffa0], a
	ret nc

	call DuelistSelectForcedSwitch
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTempPlayAreaLocation_ffa1], a
	ret

; if coin toss was heads and it's possible,
; switch Defending Pokemon
TerrorStrike_SwitchDefendingPokemon: ; 2c726 (b:4726)
	ldh a, [hTemp_ffa0]
	or a
	ret z
	ldh a, [hTempPlayAreaLocation_ffa1]
	call HandleSwitchDefendingPokemonEffect
	ret

PoisonFang_AIEffect: ; 2c730 (b:4730)
	ld a, 10
	lb de, 10, 10
	jp StoreAIPoisonDamageInfo
; 0x2c738

WeepinbellPoisonPowder_AIEffect: ; 2c738 (b:4738)
	ld a, 5
	lb de, 0, 10
	jp StoreAIPoisonDamageInfo
; 0x2c740

; returns carry if non-duelist has no Bench Pokemon
VictreebelLure_CheckBench: ; 2c740 (b:4740)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	ldtx hl, EffectNoPokemonOnTheBenchText
	cp 2
	ret
; 0x2c74b

VictreebelLure_PlayerSelectEffect: ; 2c74b (b:474b)
	ldtx hl, SelectPkmnOnBenchToSwitchWithActiveText
	call DrawWideTextBox_WaitForInput
	call SwapTurn
	bank1call HasAlivePokemonInBench
.loop_selection
	bank1call OpenPlayAreaScreenForSelection
	jr c, .loop_selection
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	call SwapTurn
	ret
; 0x2c764

VictreebelLure_AISelectEffect: ; 2c764 (b:4764)
	call AIFindBenchWithLowestHP
	ldh [hTemp_ffa0], a
	ret
; 0x2c76a

VictreebelLure_SwitchEffect: ; 2c76a (b:476a)
	call SwapTurn
	ldh a, [hTemp_ffa0]
	ld e, a
	call HandleNShieldAndTransparency
	call nc, SwapArenaWithBenchPokemon
	call SwapTurn
	xor a
	ld [wDuelDisplayedScreen], a
	ret

; If heads, defending Pokemon can't retreat next turn
AcidEffect: ; 2c77e (b:477e)
	ldtx de, AcidCheckText
	call TossCoin_BankB
	ret nc
	ld a, SUBSTATUS2_UNABLE_RETREAT
	call ApplySubstatus2ToDefendingCard
	ret

GloomPoisonPowder_AIEffect: ; 2c78b (b:478b)
	ld a, 10
	lb de, 10, 10
	jp StoreAIPoisonDamageInfo
; 0x2c793

; Defending Pokemon and user become confused
FoulOdorEffect: ; 2c793 (b:4793)
	call ConfusionEffect
	call SwapTurn
	call ConfusionEffect
	call SwapTurn
	ret

; If heads, prevent all damage done to user next turn
KakunaStiffenEffect: ; 2c7a0 (b:47a0)
	ldtx de, IfHeadsNoDamageNextTurnText
	call TossCoin_BankB
	jp nc, SetWasUnsuccessful
	ld a, $4f
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_NO_DAMAGE_STIFFEN
	call ApplySubstatus1ToDefendingCard
	ret

KakunaPoisonPowder_AIEffect: ; 2c7b4 (b:47b4)
	ld a, 5
	lb de, 0, 10
	jp StoreAIPoisonDamageInfo
; 0x2c7bc

GolbatLeechLifeEffect: ; 2c7bc (b:47bc)
	ld hl, wDealtDamage
	ld e, [hl]
	inc hl ; wDamageEffectiveness
	ld d, [hl]
	call ApplyAndAnimateHPRecovery
	ret
; 0x2c7c6

VenonatLeechLifeEffect: ; 2c7c6 (b:47c6)
	ld hl, wDealtDamage
	ld e, [hl]
	inc hl ; wDamageEffectiveness
	ld d, [hl]
	call ApplyAndAnimateHPRecovery
	ret
; 0x2c7d0

; During your next turn, double damage
SwordsDanceEffect: ; 2c7d0 (b:47d0)
	ld a, [wTempTurnDuelistCardID]
	cp SCYTHER
	ret nz
	ld a, SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE
	call ApplySubstatus1ToDefendingCard
	ret

; If heads, defending Pokemon becomes confused
ZubatSupersonicEffect: ; 2c7dc (b:47dc)
	call Confusion50PercentEffect
	call nc, SetNoEffectFromStatus
	ret
; 0x2c7e3

ZubatLeechLifeEffect: ; 2c7e3 (b:47e3)
	ld hl, wDealtDamage
	ld e, [hl]
	inc hl
	ld d, [hl]
	call ApplyAndAnimateHPRecovery
	ret
; 0x2c7ed

Twineedle_AIEffect: ; 2c7ed (b:47ed)
	ld a, 60 / 2
	lb de, 0, 60
	jp StoreAIDamageInfo
; 0x2c7f5

; Flip 2 coins; deal 30x number of heads
Twineedle_MultiplierEffect: ; 2c7f5 (b:47f5)
	ld hl, 30
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 2
	call TossCoinATimes_BankB
	ld e, a
	add a
	add e
	call ATimes10
	call StoreDamageInfo
	ret
; 0x2c80d

BeedrillPoisonSting_AIEffect: ; 2c80d (b:480d)
	ld a, 5
	lb de, 0, 10
	jp StoreAIPoisonDamageInfo
; 0x2c815

ExeggcuteLeechSeedEffect: ; 2c815 (b:4815)
	ld hl, wDealtDamage
	ld a, [hli]
	or a
	ret z ; return if no damage dealt
	ld de, 10
	call ApplyAndAnimateHPRecovery
	ret
; 0x2c822

FoulGas_AIEffect: ; 2c822 (b:4822)
	ld a, 5
	lb de, 0, 10
	jp Func_2c0e9

; If heads, defending Pokemon becomes poisoned. If tails, defending Pokemon becomes confused
FoulGas_PoisonOrConfusionEffect: ; 2c82a (b:482a)
	ldtx de, PoisonedIfHeadsConfusedIfTailsText
	call TossCoin_BankB
	jp c, PoisonEffect
	jp ConfusionEffect

; an exact copy of KakunaStiffenEffect
; If heads, prevent all damage done to user next turn
MetapodStiffenEffect: ; 2c836 (b:4836)
	ldtx de, IfHeadsNoDamageNextTurnText
	call TossCoin_BankB
	jp nc, SetWasUnsuccessful
	ld a, $4f
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_NO_DAMAGE_STIFFEN
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2c84a

; returns carry if no cards in Deck or if
; Play Area is full already.
Sprout_CheckDeckAndPlayArea: ; 2c84a (b:484a)
	call CheckIfDeckIsEmpty
	ret c ; return if no cards in deck
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ldtx hl, NoSpaceOnTheBenchText
	cp MAX_PLAY_AREA_POKEMON
	ccf
	ret
; 0x2c85a

Sprout_PlayerSelectEffect: ; 2c85a (b:485a)
	ld a, $ff
	ldh [hTemp_ffa0], a

	call CreateDeckCardList
	ldtx hl, ChooseAnOddishFromDeckText
	ldtx bc, OddishText
	lb de, SEARCHEFFECT_CARD_ID, ODDISH
	call LookForCardInDeck
	ret c

; draw Deck list interface and print text
	bank1call Func_5591
	ldtx hl, ChooseAnOddishText
	ldtx de, DuelistDeckText
	bank1call SetCardListHeaderText

.loop
	bank1call DisplayCardList
	jr c, .pressed_b
	call GetCardIDFromDeckIndex
	ld bc, ODDISH
	call CompareDEtoBC
	jr nz, .play_sfx

; Oddish was selected
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	or a
	ret

.play_sfx
	; play SFX and loop back
	call Func_3794
	jr .loop

.pressed_b
; figure if Player can exit the screen without selecting,
; that is, if the Deck has no Oddish card.
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.loop_b_press
	ld a, [hl]
	cp CARD_LOCATION_DECK
	jr nz, .next
	ld a, l
	call GetCardIDFromDeckIndex
	ld bc, ODDISH
	call CompareDEtoBC
	jr z, .play_sfx ; found Oddish, go back to top loop
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop_b_press

; no Oddish in Deck, can safely exit screen
	ld a, $ff
	ldh [hTemp_ffa0], a
	or a
	ret
; 0x2c8b7

Sprout_AISelectEffect: ; 2c8b7 (b:48b7)
	call CreateDeckCardList
	ld hl, wDuelTempList
.loop_deck
	ld a, [hli]
	ldh [hTemp_ffa0], a
	cp $ff
	ret z ; no Oddish
	call GetCardIDFromDeckIndex
	ld a, e
	cp ODDISH
	jr nz, .loop_deck
	ret ; Oddish found
; 0x2c8cc

Sprout_PutInPlayAreaEffect: ; 2c8cc (b:48cc)
	ldh a, [hTemp_ffa0]
	cp $ff
	jr z, .shuffle
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	call PutHandPokemonCardInPlayArea
	call CheckIfTurnDuelistIsPlayer
	jr c, .shuffle
	; display card on screen
	ldh a, [hTemp_ffa0]
	ldtx hl, PlacedOnTheBenchText
	bank1call DisplayCardDetailScreen
.shuffle
	call Func_2c0bd
	ret
; 0x2c8ec

; returns carry if no Pokemon on Bench
Teleport_CheckBench: ; 2c8ec (b:48ec)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ldtx hl, ThereAreNoPokemonOnBenchText
	cp 2
	ret
; 0x2c8f7

Teleport_PlayerSelectEffect: ; 2c8f7 (b:48f7)
	ldtx hl, SelectPkmnOnBenchToSwitchWithActiveText
	call DrawWideTextBox_WaitForInput
	bank1call HasAlivePokemonInBench
	ld a, $01
	ld [wcbd4], a
.loop
	bank1call OpenPlayAreaScreenForSelection
	jr c, .loop
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	ret
; 0x2c90f

Teleport_AISelectEffect: ; 2c90f (b:490f)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	call Random
	ldh [hTemp_ffa0], a
	ret
; 0x2c91a

Teleport_SwitchEffect: ; 2c91a (b:491a)
	ldh a, [hTemp_ffa0]
	ld e, a
	call SwapArenaWithBenchPokemon
	xor a
	ld [wDuelDisplayedScreen], a
	ret
; 0x2c925

BigEggsplosion_AIEffect: ; 2c925 (b:4925)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	call SetDamageToATimes20
	inc h
	jr nz, .capped
	ld l, 255
.capped
	ld a, l
	ld [wAIMaxDamage], a
	srl a
	ld [wDamage], a
	xor a
	ld [wAIMinDamage], a
	ret

; Flip coins equal to attached energies; deal 20x number of heads
BigEggsplosion_MultiplierEffect: ; 2c944 (b:4944)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld hl, 20
	call LoadTxRam3
	ld a, [wTotalAttachedEnergies]
	ldtx de, DamageCheckIfHeadsXDamageText
	call TossCoinATimes_BankB
;	fallthrough

; set damage to 20*a. Also return result in hl
SetDamageToATimes20: ; 2c958 (b:4958)
	ld l, a
	ld h, $00
	ld e, l
	ld d, h
	add hl, hl
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	ld a, l
	ld [wDamage], a
	ld a, h
	ld [wDamage + 1], a
	ret

Thrash_AIEffect: ; 2c96b (b:496b)
	ld a, (30 + 40) / 2
	lb de, 30, 40
	jp StoreAIDamageInfo
; 0x2c973

; If heads 10 more damage; if tails, 10 damage to itself
Thrash_ModifierEffect: ; 2c973 (b:4973)
	ldtx de, IfHeadPlus10IfTails10ToYourselfText
	call TossCoin_BankB
	ldh [hTemp_ffa0], a
	ret nc
	ld a, 10
	call AddToDamage
	ret

Func_2c982: ; 2c982 (b:4982)
	ldh a, [hTemp_ffa0]
	or a
	ret nz
	ld a, 10
	call DealRecoilDamageToSelf
	ret

Toxic_AIEffect: ; 2c98c (b:498c)
	ld a, 20
	lb de, 20, 20
	jp Func_2c0e9

; Defending Pokémon becomes poisoned, but takes 20 damage (double poisoned)
Toxic_DoublePoisonEffect: ; 2c994 (b:4994)
	call DoublePoisonEffect
	ret
; 0x2c998

BoyfriendsEffect: ; 2c998 (b:4998)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld c, PLAY_AREA_ARENA
.loop
	ld a, [hl]
	cp $ff
	jr z, .done
	call GetCardIDFromDeckIndex
	ld a, e
	cp NIDOKING
	jr nz, .next
	ld a, d
	cp $00 ; why check d? Card IDs are only 1 byte long
	jr nz, .next
	inc c
.next
	inc hl
	jr .loop
.done
; c holds number of Nidoking found in Play Area
	ld a, c
	add a
	call ATimes10
	call AddToDamage ; adds 2 * 10 * c
	ret
; 0x2c9be

NidoranFFurySwipes_AIEffect: ; 2c9be (b:49be)
	ld a, 30 / 2
	lb de, 0, 30
	jp StoreAIDamageInfo
; 0x2c9c6

NidoranFFurySwipes_MultiplierEffect: ; 2c9c6 (b:49c6)
	ld hl, 10
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 3
	call TossCoinATimes_BankB
	call ATimes10
	call StoreDamageInfo
	ret
; 0x2c9db

NidoranFCallForFamily_CheckDeckAndPlayArea: ; 2c9db (b:49db)
	call CheckIfDeckIsEmpty
	ret c ; return if no cards in deck
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ldtx hl, NoSpaceOnTheBenchText
	cp MAX_PLAY_AREA_POKEMON
	ccf
	ret
; 0x2c9eb

NidoranFCallForFamily_PlayerSelectEffect: ; 2c9eb (b:49eb)
	ld a, $ff
	ldh [hTemp_ffa0], a

	call CreateDeckCardList
	ldtx hl, ChooseNidoranFromDeckText
	ldtx bc, NidoranMNidoranFText
	lb de, SEARCHEFFECT_NIDORAN, $00
	call LookForCardInDeck
	ret c

; draw Deck list interface and print text
	bank1call Func_5591
	ldtx hl, ChooseNidoranText
	ldtx de, DuelistDeckText
	bank1call SetCardListHeaderText

.loop
	bank1call DisplayCardList
	jr c, .pressed_b
	call GetCardIDFromDeckIndex
	ld bc, NIDORANF
	call CompareDEtoBC
	jr z, .selected_nidoran
	ld bc, NIDORANM
	call CompareDEtoBC
	jr nz, .loop ; .play_sfx would be more appropriate here

.selected_nidoran
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	or a
	ret

.play_sfx
	; play SFX and loop back
	call Func_3794
	jr .loop

.pressed_b
; figure if Player can exit the screen without selecting,
; that is, if the Deck has no NidoranF or NidoranM card.
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.loop_b_press
	ld a, [hl]
	cp CARD_LOCATION_DECK
	jr nz, .next
	ld a, l
	call GetCardIDFromDeckIndex
	ld bc, NIDORANF
	call CompareDEtoBC
	jr z, .play_sfx ; found, go back to top loop
	ld bc, NIDORANM
	jr z, .play_sfx ; found, go back to top loop
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop_b_press

; no Nidoran in Deck, can safely exit screen
	ld a, $ff
	ldh [hTemp_ffa0], a
	or a
	ret
; 0x2ca55

NidoranFCallForFamily_AISelectEffect: ; 2ca55 (b:4a55)
	call CreateDeckCardList
	ld hl, wDuelTempList
.loop_deck
	ld a, [hli]
	ldh [hTemp_ffa0], a
	cp $ff
	ret z ; none found
	call GetCardIDFromDeckIndex
	ld a, e
	cp NIDORANF
	jr z, .found
	cp NIDORANM
	jr nz, .loop_deck
.found
	ret
; 0x2ca6e

NidoranFCallForFamily_PutInPlayAreaEffect: ; 2ca6e (b:4a6e)
	ldh a, [hTemp_ffa0]
	cp $ff
	jr z, .shuffle
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	call PutHandPokemonCardInPlayArea
	call CheckIfTurnDuelistIsPlayer
	jr c, .shuffle
	; display card on screen
	ldh a, [hTemp_ffa0]
	ldtx hl, PlacedOnTheBenchText
	bank1call DisplayCardDetailScreen
.shuffle
	call Func_2c0bd
	ret
; 0x2ca8e

HornHazard_AIEffect: ; 2ca8e (b:4a8e)
	ld a, 30 / 2
	lb de, 0, 30
	jp StoreAIDamageInfo
; 0x2ca96

HornHazard_Failure50PercentEffect: ; 2ca96 (b:4a96)
	ldtx de, DamageCheckIfTailsNoDamageText
	call TossCoin_BankB
	jr c, .heads
	xor a
	call StoreDamageInfo
	call SetWasUnsuccessful
	ret
.heads
	ld a, $01
	ld [wLoadedMoveAnimation], a
	ret
; 0x2caac

NidorinaSupersonicEffect: ; 2caac (b:4aac)
	call Confusion50PercentEffect
	call nc, SetNoEffectFromStatus
	ret
; 0x2cab3

NidorinaDoubleKick_AIEffect: ; 2cab3 (b:4ab3)
	ld a, 60 / 2
	lb de, 0, 60
	jp StoreAIDamageInfo
; 0x2cabb

NidorinaDoubleKick_MultiplierEffect: ; 2cabb (b:4abb)
	ld hl, 30
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 2
	call TossCoinATimes_BankB
	ld e, a
	add a
	add e
	call ATimes10
	call StoreDamageInfo
	ret
; 0x2cad3

NidorinoDoubleKick_AIEffect: ; 2cad3 (b:4ad3)
	ld a, 60 / 2
	lb de, 0, 60
	jp StoreAIDamageInfo
; 0x2cadb

NidorinoDoubleKick_MultiplierEffect: ; 2cabb (b:4abb)
	ld hl, 30
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 2
	call TossCoinATimes_BankB
	ld e, a
	add a
	add e
	call ATimes10
	call StoreDamageInfo
	ret
; 0x2caf3

ButterfreeWhirlwind_CheckBench: ; 2caf3 (b:4af3)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	cp 2
	jr nc, .has_bench
	; no bench, do not do effect
	ld a, $ff
	ldh [hTemp_ffa0], a
	ret
.has_bench
	call DuelistSelectForcedSwitch
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	ret
; 0x2cb09

ButterfreeWhirlwind_SwitchEffect: ; 2cb09 (b:4b09)
	ldh a, [hTemp_ffa0]
	call HandleSwitchDefendingPokemonEffect
	ret
; 0x2cb0f

ButterfreeMegaDrainEffect: ; 2cb0f (b:4b0f)
	ld hl, wDealtDamage
	ld a, [hli]
	ld h, [hl]
	ld l, a
	srl h
	rr l
	bit 0, l
	jr z, .rounded
	; round up to nearest 10
	ld de, 10 / 2
	add hl, de
.rounded
	ld e, l
	ld d, h
	call ApplyAndAnimateHPRecovery
	ret
; 0x2cb27

WeedlePoisonSting_AIEffect: ; 2cb27 (b:4b27)
	ld a, 5
	lb de, 0, 10
	jp StoreAIPoisonDamageInfo
; 0x2cb2f

IvysaurPoisonPowder_AIEffect: ; 2cb2f (b:4b2f)
	ld a, 10
	lb de, 10, 10
	jp StoreAIPoisonDamageInfo
; 0x2cb37

BulbasaurLeechSeedEffect: ; 2cb37 (b:4b37)
	ld hl, wDealtDamage
	ld a, [hli]
	or [hl]
	ret z ; return if no damage dealt
	lb de, 0, 10
	call ApplyAndAnimateHPRecovery
	ret
; 0x2cb44

; returns carry if no Grass Energy in Play Area
EnergyTrans_CheckPlayArea: ; 2cb44 (b:4b44)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	ldh a, [hTempPlayAreaLocation_ff9d]
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret c ; cannot use Pkmn Power

; search in Play Area for at least 1 Grass Energy type
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.loop_deck
	ld a, [hl]
	and CARD_LOCATION_PLAY_AREA
	jr z, .next
	push hl
	ld a, l
	call GetCardIDFromDeckIndex
	call GetCardType
	pop hl
	cp TYPE_ENERGY_GRASS
	ret z
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop_deck

; none found
	ldtx hl, NoGrassEnergyText
	scf
	ret
; 0x2cb6f

EnergyTrans_PrintProcedure: ; 2cb6f (b:4b6f)
	ldtx hl, ProcedureForEnergyTransferText
	bank1call DrawWholeScreenTextBox
	or a
	ret
; 0x2cb77

EnergyTrans_TransferEffect: ; 2cb77 (b:4b77)
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .player
; not player
	bank1call Func_61a1
	bank1call PrintPlayAreaCardList_EnableLCD
	ret

.player
	xor a
	ldh [hEffectItemSelection], a
	bank1call Func_61a1

.draw_play_area
	bank1call PrintPlayAreaCardList_EnableLCD
	push af
	ldh a, [hEffectItemSelection]
	ld hl, PlayAreaSelectionMenuParameters
	call InitializeMenuParameters
	pop af
	ld [wNumMenuItems], a

; handle the action of taking a Grass Energy card
.loop_input_take
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input_take
	cp -1 ; b press?
	ret z

; a press
	ldh [hAIPkmnPowerEffectParam], a
	ldh [hEffectItemSelection], a
	call CheckIfCardHasGrassEnergyAttached
	jr c, .play_sfx ; no Grass attached

	ldh [hAIEnergyTransEnergyCard], a
	ldh a, [hAIEnergyTransEnergyCard] ; useless
	; temporarily take card away to draw Play Area
	call AddCardToHand
	bank1call PrintPlayAreaCardList_EnableLCD
	ldh a, [hAIPkmnPowerEffectParam]
	ld e, a
	ldh a, [hAIEnergyTransEnergyCard]
	; give card back
	call PutHandCardInPlayArea

	; draw Grass symbol near cursor
	ldh a, [hAIPkmnPowerEffectParam]
	ld b, SYM_GRASS
	call DrawSymbolOnPlayAreaCursor

; handle the action of placing a Grass Energy card
.loop_input_put
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input_put
	cp -1 ; b press?
	jr z, .remove_symbol

; a press
	ldh [hEffectItemSelection], a
	ldh [hAIEnergyTransPlayAreaLocation], a
	ld a, OPPACTION_6B15
	call SetOppAction_SerialSendDuelData
	ldh a, [hAIEnergyTransPlayAreaLocation]
	ld e, a
	ldh a, [hAIEnergyTransEnergyCard]
	; give card being held to this Pokemon
	call AddCardToHand
	call PutHandCardInPlayArea

.remove_symbol
	ldh a, [hAIPkmnPowerEffectParam]
	ld b, SYM_SPACE
	call DrawSymbolOnPlayAreaCursor
	call EraseCursor
	jr .draw_play_area

.play_sfx
	call Func_3794
	jr .loop_input_take
; 0x2cbfb

EnergyTrans_AIEffect: ; 2cbfb (b:4bfb)
	ldh a, [hAIEnergyTransPlayAreaLocation]
	ld e, a
	ldh a, [hAIEnergyTransEnergyCard]
	call AddCardToHand
	call PutHandCardInPlayArea
	bank1call PrintPlayAreaCardList_EnableLCD
	ret
; 0x2cc0a

; returns carry if no Grass Energy cards
; attached to card in Play Area location of a.
; input:
;	a = PLAY_AREA_* of location to check
CheckIfCardHasGrassEnergyAttached: ; 2cc0a (b:4c0a)
	or CARD_LOCATION_PLAY_AREA
	ld e, a

	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.loop
	ld a, [hl]
	cp e
	jr nz, .next
	push de
	push hl
	ld a, l
	call GetCardIDFromDeckIndex
	call GetCardType
	pop hl
	pop de
	cp TYPE_ENERGY_GRASS
	jr z, .no_carry
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop
	scf
	ret
.no_carry
	ld a, l
	or a
	ret
; 0x2cc30

GrimerMinimizeEffect: ; 2cc30 (b:4c30)
	ld a, SUBSTATUS1_REDUCE_BY_20
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2cc36

ToxicGasEffect: ; 2cc36 (b:4c36)
	scf
	ret
; 0x2cc38

Sludge_AIEffect: ; 2cc38 (b:4c38)
	ld a, 5
	lb de, 0, 10
	jp StoreAIPoisonDamageInfo
; 0x2cc40

; returns carry if no cards in Deck
; or if Play Area is full already.
BellsproutCallForFamily_CheckDeckAndPlayArea: ; 2cc40 (b:4c40)
	call CheckIfDeckIsEmpty
	ret c ; return if no cards in deck
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ldtx hl, NoSpaceOnTheBenchText
	cp MAX_PLAY_AREA_POKEMON
	ccf
	ret
; 0x2cc50

BellsproutCallForFamily_PlayerSelectEffect: ; 2cc50 (b:4c50)
	ld a, $ff
	ldh [hTemp_ffa0], a

	call CreateDeckCardList
	ldtx hl, ChooseABellsproutFromDeckText
	ldtx bc, BellsproutText
	lb de, SEARCHEFFECT_CARD_ID, BELLSPROUT
	call LookForCardInDeck
	ret c

; draw Deck list interface and print text
	bank1call Func_5591
	ldtx hl, ChooseABellsproutText
	ldtx de, DuelistDeckText
	bank1call SetCardListHeaderText

.loop
	bank1call DisplayCardList
	jr c, .pressed_b
	call GetCardIDFromDeckIndex
	ld bc, BELLSPROUT
	call CompareDEtoBC
	jr nz, .play_sfx

; Bellsprout was selected
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	or a
	ret

.play_sfx
	; play SFX and loop back
	call Func_3794
	jr .loop

.pressed_b
; figure if Player can exit the screen without selecting,
; that is, if the Deck has no Bellsprout card.
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.loop_b_press
	ld a, [hl]
	cp CARD_LOCATION_DECK
	jr nz, .next
	ld a, l
	call GetCardIDFromDeckIndex
	ld bc, BELLSPROUT
	call CompareDEtoBC
	jr z, .play_sfx ; found Bellsprout, go back to top loop
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop_b_press

; no Bellsprout in Deck, can safely exit screen
	ld a, $ff
	ldh [hTemp_ffa0], a
	or a
	ret
; 0x2ccad

BellsproutCallForFamily_AISelectEffect: ; 2ccad (b:4cad)
	call CreateDeckCardList
	ld hl, wDuelTempList
.loop_deck
	ld a, [hli]
	ldh [hTemp_ffa0], a
	cp $ff
	ret z ; no Bellsprout
	call GetCardIDFromDeckIndex
	ld a, e
	cp BELLSPROUT
	jr nz, .loop_deck
	ret ; Bellsprout found
; 0x2ccc2

BellsproutCallForFamily_PutInPlayAreaEffect: ; 2ccc2 (b:4cc2)
	ldh a, [hTemp_ffa0]
	cp $ff
	jr z, .shuffle
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	call PutHandPokemonCardInPlayArea
	call CheckIfTurnDuelistIsPlayer
	jr c, .shuffle
	ldh a, [hTemp_ffa0]
	ldtx hl, PlacedOnTheBenchText
	bank1call DisplayCardDetailScreen
.shuffle
	call Func_2c0bd
	ret
; 0x2cce2

WeezingSmog_AIEffect: ; 2cce2 (b:4ce2)
	ld a, 5
	lb de, 0, 10
	jp StoreAIPoisonDamageInfo
; 0x2ccea

WeezingSelfdestructEffect: ; 2ccea (b:4cea)
	ld a, 60
	call DealRecoilDamageToSelf
	ld a, $01
	ld [wIsDamageToSelf], a
	ld a, 10
	call DealDamageToAllBenchedPokemon
	call SwapTurn
	xor a
	ld [wIsDamageToSelf], a
	ld a, 10
	call DealDamageToAllBenchedPokemon
	call SwapTurn
	ret
; 0x2cd09

Shift_OncePerTurnCheck: ; 2cd09 (b:4d09)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	add DUELVARS_ARENA_CARD_FLAGS_C2
	call GetTurnDuelistVariable
	and USED_PKMN_POWER_THIS_TURN
	jr nz, .already_used
	ldh a, [hTempPlayAreaLocation_ff9d]
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret
.already_used
	ldtx hl, OnlyOncePerTurnText
	scf
	ret
; 0x2cd21

Shift_PlayerSelectEffect: ; 2cd21 (b:4d21)
	ldtx hl, ChoosePokemonWishToColorChangeText
	ldh a, [hTemp_ffa0]
	or $80
	call HandleShiftScreen
	ldh [hAIPkmnPowerEffectParam], a
	ret c ; cancelled

; check whether the color selected is valid
	; look in Turn Duelist's Play Area
	call .CheckColorInPlayArea
	ret nc
	; look in NonTurn Duelist's Play Area
	call SwapTurn
	call .CheckColorInPlayArea
	call SwapTurn
	ret nc
	; not found in either Duelist's Play Area
	ldtx hl, UnableToSelectText
	call DrawWideTextBox_WaitForInput
	jr Shift_PlayerSelectEffect ; loop back to start
; 0x2cd44

; checks in input color in a exists in Turn Duelist's Play Area
; returns carry if not found.
.CheckColorInPlayArea: ; 2cd44 (b:4d44)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a
	ld b, PLAY_AREA_ARENA
.loop_play_area
	push bc
	ld a, b
	call GetPlayAreaCardColor
	pop bc
	ld hl, hAIPkmnPowerEffectParam
	cp [hl]
	ret z ; found
	inc b
	dec c
	jr nz, .loop_play_area
	; not found
	scf
	ret
; 0x2cd5d

Shift_ChangeColorEffect: ; 2cd5d (b:4d5d)
	ldh a, [hTemp_ffa0]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex

	ldh a, [hTemp_ffa0]
	add DUELVARS_ARENA_CARD_FLAGS_C2
	call GetTurnDuelistVariable
	set USED_PKMN_POWER_THIS_TURN_F, [hl]

	ldh a, [hTemp_ffa0]
	add DUELVARS_ARENA_CARD_CHANGED_COLOR
	ld l, a
	ldh a, [hAIPkmnPowerEffectParam]
	or HAS_CHANGED_COLOR
	ld [hl], a
	call LoadCardNameAndInputColor
	ldtx hl, ChangedTheColorOfText
	call DrawWideTextBox_WaitForInput
	ret
; 0x2cd84

VenomPowder_AIEffect: ; 2cd84 (b:4d84)
	ld a, 5
	lb de, 0, 10
	jp Func_2c0e9
; 0x2cd8c

VenomPowder_PoisonConfusion50PercentEffect: ; 2cd8c (b:4d8c)
	ldtx de, VenomPowderCheckText
	call TossCoin_BankB
	ret nc ; return if tails

; heads
	call PoisonEffect
	call ConfusionEffect
	ret c
	ld a, CONFUSED | POISONED
	ld [wNoEffectFromStatus], a
	ret
; 0x2cda0

TangelaPoisonPowder_AIEffect: ; 2cda0 (b:4da0)
	ld a, 5
	lb de, 0, 10
	jp StoreAIPoisonDamageInfo
; 0x2cda8

Heal_OncePerTurnCheck: ; 2cda8 (b:4da8)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	add DUELVARS_ARENA_CARD_FLAGS_C2
	call GetTurnDuelistVariable
	and USED_PKMN_POWER_THIS_TURN
	jr nz, .already_used

	call CheckIfPlayAreaHasAnyDamage
	ldtx hl, NoPokemonWithDamageCountersText
	ret c ; no damage counters to heal

	ldh a, [hTempPlayAreaLocation_ff9d]
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret

.already_used
	ldtx hl, OnlyOncePerTurnText
	scf
	ret
; 0x2cdc7

Heal_RemoveDamageEffect: ; 2cdc7 (b:4dc7)
	ldtx de, IfHeadsHealIsSuccessfulText
	call TossCoin_BankB
	ldh [hAIPkmnPowerEffectParam], a
	jr nc, .done

	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_LINK_OPP
	jr z, .link_opp
	and DUELIST_TYPE_AI_OPP
	jr nz, .done

; player
	ldtx hl, ChoosePkmnToRemoveDamageCounterText
	call DrawWideTextBox_WaitForInput
	bank1call HasAlivePokemonInPlayArea
.loop_input
	bank1call OpenPlayAreaScreenForSelection
	jr c, .loop_input
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hPkmnPowerPlayAreaTarget], a
	ld e, a
	call GetCardDamageAndMaxHP
	or a
	jr z, .loop_input ; has no damage counters
	ldh a, [hTempPlayAreaLocation_ff9d]
	call SerialSend8Bytes
	jr .done

.link_opp
	call SerialRecv8Bytes
	ldh [hPkmnPowerPlayAreaTarget], a
	; fallthrough

.done
; flag Pkmn Power as being used regardless of coin outcome
	ldh a, [hTemp_ffa0]
	add DUELVARS_ARENA_CARD_FLAGS_C2
	call GetTurnDuelistVariable
	set USED_PKMN_POWER_THIS_TURN_F, [hl]
	ldh a, [hAIPkmnPowerEffectParam]
	or a
	ret z ; return if coin was tails

	ldh a, [hPkmnPowerPlayAreaTarget]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	add 10 ; remove 1 damage counter
	ld [hl], a
	ldh a, [hPkmnPowerPlayAreaTarget]
	call Func_2c10b
	call ExchangeRNG
	ret
; 0x2ce23

PetalDance_AIEffect: ; 2ce23 (b:4e23)
	ld a, 120 / 2
	lb de, 0, 120
	jp StoreAIDamageInfo
; 0x2ce2b

PetalDance_MultiplierEffect: ; 2ce2b (b:4e2b)
	ld hl, 40
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 3
	call TossCoinATimes_BankB
	add a
	add a
	call ATimes10
	; a = 4 * 10 * heads
	call StoreDamageInfo
	call SwapTurn
	call ConfusionEffect
	call SwapTurn
	ret
; 0x2ce4b

PoisonWhip_AIEffect: ; 2ce4b (b:4e4b)
	ld a, 10
	lb de, 10, 10
	jp StoreAIPoisonDamageInfo
; 0x2ce53

SolarPower_CheckUse: ; 2ce53 (b:4e53)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	add DUELVARS_ARENA_CARD_FLAGS_C2
	call GetTurnDuelistVariable
	and USED_PKMN_POWER_THIS_TURN
	jr nz, .already_used

	ldh a, [hTempPlayAreaLocation_ff9d]
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret c ; can't use PKMN due to status or Toxic Gas

; return carry if none of the Arena cards have status conditions
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetTurnDuelistVariable
	or a
	jr nz, .has_status
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	or a
	jr z, .no_status
.has_status
	or a
	ret
.already_used
	ldtx hl, OnlyOncePerTurnText
	scf
	ret
.no_status
	ldtx hl, NotAffectedByPoisonSleepParalysisOrConfusionText
	scf
	ret
; 0x2ce82

SolarPower_RemoveStatusEffect: ; 2ce82 (b:4e82)
	ld a, $8e
	ld [wLoadedMoveAnimation], a
	bank1call Func_7415
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld b, a
	ld c, $00
	ldh a, [hWhoseTurn]
	ld h, a
	bank1call PlayMoveAnimation
	bank1call WaitMoveAnimation

	ldh a, [hTemp_ffa0]
	add DUELVARS_ARENA_CARD_FLAGS_C2
	call GetTurnDuelistVariable
	set USED_PKMN_POWER_THIS_TURN_F, [hl]
	ld l, DUELVARS_ARENA_CARD_STATUS
	ld [hl], NO_STATUS

	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	ld [hl], NO_STATUS
	bank1call DrawDuelHUDs
	ret
; 0x2ceb0

VenusaurMegaDrainEffect: ; 2ceb0 (b:4eb0)
	ld hl, wDealtDamage
	ld a, [hli]
	ld h, [hl]
	ld l, a
	srl h
	rr l
	bit 0, l
	jr z, .rounded
	; round up to nearest 10
	ld de, 10 / 2
	add hl, de
.rounded
	ld e, l
	ld d, h
	call ApplyAndAnimateHPRecovery
	ret
; 0x2cec8

; applies the damage bonus for attacks that get bonus
; from extra Water energy cards.
; this bonus is always 10 more damage for each extra Water energy
; and is always capped at a maximum of 20 damage.
; input:
;	b = number of Water energy cards needed for paying Energy Cost
;	c = number of colorless energy cards needed for paying Energy Cost
ApplyExtraWaterEnergyDamageBonus: ; 2cec8 (b:4ec8)
	ld a, [wccf0]
	or a
	jr z, .asm_2ced1
	ld c, a
	ld b, 0

.asm_2ced1
	push bc
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld e, a
	call GetPlayAreaCardAttachedEnergies
	pop bc

	ld hl, wAttachedEnergies + WATER
	ld a, c
	or a
	jr z, .check_bonus ; is Energy cost all water energy?

	; it's not, so we need to remove the
	; Water energy cards from calculations
	; if they pay for colorless instead.
	ld a, [wTotalAttachedEnergies]
	cp [hl]
	jr nz, .check_bonus ; skip if at least 1 non-Water energy attached

	; Water is the only energy color attached
	ld a, c
	add b
	ld b, a
	; b += c

.check_bonus
	ld a, [hl]
	sub b
	jr c, .skip_bonus ; is water energy <  b?
	jr z, .skip_bonus ; is water energy == b?

; a holds number of water energy not payed for energy cost
	cp 3
	jr c, .less_than_3
	ld a, 2 ; cap this to 2 for bonus effect
.less_than_3
	call ATimes10
	call AddToDamage ; add 10 * a to damage

.skip_bonus
	ld a, [wDamage]
	ld [wAIMinDamage], a
	ld [wAIMaxDamage], a
	ret
; 0x2cf05

OmastarWaterGunEffect: ; 2cf05 (b:4f05)
	lb bc, 1, 1
	jr ApplyExtraWaterEnergyDamageBonus
; 0x2cf0a

OmastarSpikeCannon_AIEffect: ; 2cf0a (b:4f0a)
	ld a, 60 / 2
	lb de, 0, 60
	jp StoreAIDamageInfo
; 0x2cf12

OmastarSpikeCannon_MultiplierEffect: ; 2cf12 (b:4f12)
	ld hl, 30
	call LoadTxRam3
	ld a, 2
	ldtx de, DamageCheckIfHeadsXDamageText
	call TossCoinATimes_BankB
	ld e, a
	add a
	add e
	call ATimes10
	call StoreDamageInfo ; 3 * 10 * heads
	ret
; 0x2cf2a

ClairvoyanceEffect: ; 2cf2a (b:4f2a)
	scf
	ret
; 0x2cf2c

OmanyteWaterGunEffect: ; 2cf2c (b:4f2c)
	lb bc, 1, 0
	jp ApplyExtraWaterEnergyDamageBonus
; 0x2cf32

WartortleWithdrawEffect: ; 2cf32 (b:4f32)
	ldtx de, IfHeadsNoDamageNextTurnText
	call TossCoin_BankB
	jp nc, SetWasUnsuccessful
	ld a, $4f
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_NO_DAMAGE_10
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2cf46

RainDanceEffect: ; 2cf46 (b:4f46)
	scf
	ret
; 0x2cf48

HydroPumpEffect: ; 2cf48 (b:4f48)
	lb bc, 3, 0
	jp ApplyExtraWaterEnergyDamageBonus
; 0x2cf4e

KinglerFlail_AIEffect: ; 2cf4e (b:4f4e)
	call KinglerFlail_HPCheck
	jp SetMinMaxDamageSameAsDamage
; 0x2cf54

KinglerFlail_HPCheck: ; 2cf54 (b:4f54)
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	call StoreDamageInfo
	ret
; 0x2cf5d

; returns carry if no cards in Deck
; or if Play Area is full already.
KrabbyCallForFamily_CheckDeckAndPlayArea: ; 2cf5d (b:4f5d)
	call CheckIfDeckIsEmpty
	ret c ; return if no cards in deck
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ldtx hl, NoSpaceOnTheBenchText
	cp MAX_PLAY_AREA_POKEMON
	ccf
	ret
; 0x2cf6d

KrabbyCallForFamily_PlayerSelectEffect: ; 2cf6d (b:4f6d)
	ld a, $ff
	ldh [hTemp_ffa0], a

	call CreateDeckCardList
	ldtx hl, ChooseAKrabbyFromDeckText
	ldtx bc, KrabbyText
	lb de, SEARCHEFFECT_CARD_ID, KRABBY
	call LookForCardInDeck
	ret c

; draw Deck list interface and print text
	bank1call Func_5591
	ldtx hl, ChooseAKrabbyText
	ldtx de, DuelistDeckText
	bank1call SetCardListHeaderText

.loop
	bank1call DisplayCardList
	jr c, .pressed_b
	call GetCardIDFromDeckIndex
	ld bc, KRABBY
	call CompareDEtoBC
	jr nz, .play_sfx

; Krabby was selected
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	or a
	ret

.play_sfx
	; play SFX and loop back
	call Func_3794
	jr .loop

.pressed_b
; figure if Player can exit the screen without selecting,
; that is, if the Deck has no Krabby card.
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
.loop_b_press
	ld a, [hl]
	cp CARD_LOCATION_DECK
	jr nz, .next
	ld a, l
	call GetCardIDFromDeckIndex
	ld bc, KRABBY
	call CompareDEtoBC
	jr z, .play_sfx ; found Krabby, go back to top loop
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop_b_press

; no Krabby in Deck, can safely exit screen
	ld a, $ff
	ldh [hTemp_ffa0], a
	or a
	ret
; 0x2cfdf

KrabbyCallForFamily_AISelectEffect: ; 2cfdf (b:4fdf)
	call CreateDeckCardList
	ld hl, wDuelTempList
.loop_deck
	ld a, [hli]
	ldh [hTemp_ffa0], a
	cp $ff
	ret z ; no Krabby
	call GetCardIDFromDeckIndex
	ld a, e
	cp KRABBY
	jr nz, .loop_deck
	ret ; Krabby found
; 0x2cfca

KrabbyCallForFamily_PutInPlayAreaEffect: ; 2cfca (b:4fca)
	ldh a, [hTemp_ffa0]
	cp $ff
	jr z, .shuffle
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	call PutHandPokemonCardInPlayArea
	call CheckIfTurnDuelistIsPlayer
	jr c, .shuffle
	ldh a, [hTemp_ffa0]
	ldtx hl, PlacedOnTheBenchText
	bank1call DisplayCardDetailScreen
.shuffle
	call Func_2c0bd
	ret
; 0x2cfff

MagikarpFlail_AIEffect: ; 2cfff (b:4fff)
	call MagikarpFlail_HPCheck
	jp SetMinMaxDamageSameAsDamage
; 0x2d005

MagikarpFlail_HPCheck: ; 2d005 (b:5005)
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	call StoreDamageInfo
	ret
; 0x2d00e

HeadacheEffect: ; 2d00e (b:500e)
	ld a, DUELVARS_ARENA_CARD_SUBSTATUS3
	call GetNonTurnDuelistVariable
	set SUBSTATUS3_HEADACHE, [hl]
	ret
; 0x2d016

PsyduckFurySwipes_AIEffect: ; 2d016 (b:5016)
	ld a, 30 / 2
	lb de, 0, 30
	jp StoreAIDamageInfo
; 0x2d01e

PsyduckFurySwipes_MultiplierEffect: ; 2d01e (b:501e)
	ld hl, 10
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 3
	call TossCoinATimes_BankB
	call ATimes10
	call StoreDamageInfo
	ret
; 0x2d033

GolduckHyperBeam_PlayerSelectEffect: ; 2d033 (b:5033)
	call SwapTurn
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wTotalAttachedEnergies]
	or a
	jr z, .no_energy

; draw Energy Card list screen
	ldtx hl, ChooseDiscardEnergyCardFromOpponentText
	call DrawWideTextBox_WaitForInput
	xor a ; PLAY_AREA_ARENA
	call CreateArenaOrBenchEnergyCardList
	xor a ; PLAY_AREA_ARENA
	bank1call DisplayEnergyDiscardScreen

.loop_input
	bank1call HandleEnergyDiscardMenuInput
	jr c, .loop_input

	call SwapTurn
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a ; store selected card to discard
	ret

.no_energy
	call SwapTurn
	ld a, $ff
	ldh [hTemp_ffa0], a
	or a
	ret
; 0x2d065

GolduckHyperBeam_AISelectEffect: ; 2d065 (b:5065)
	call AIPickEnergyCardToDiscardFromDefendingPokemon
	ldh [hTemp_ffa0], a
	ret
; 0x2d06b

GolduckHyperBeam_DiscardEffect: ; 2d06b (b:506b)
	call HandleNoDamageOrEffect
	ret c ; return if attack had no effect

	; check if energy card was chosen to discard
	ldh a, [hTemp_ffa0]
	cp $ff
	ret z ; return if none selected

	; discard Defending card's energy
	call SwapTurn
	call PutCardInDiscardPile
	ld a, DUELVARS_ARENA_CARD_LAST_TURN_EFFECT
	call GetTurnDuelistVariable
	ld [hl], LAST_TURN_EFFECT_DISCARD_ENERGY
	call SwapTurn
	ret
; 0x2d085

SeadraWaterGunEffect: ; 2d085 (b:5085)
	lb bc, 1, 1
	jp ApplyExtraWaterEnergyDamageBonus
; 0x2d08b

SeadraAgilityEffect: ; 2d08b (b:508b)
	ldtx de, IfHeadsDoNotReceiveDamageOrEffectText
	call TossCoin_BankB
	ret nc ; return if tails
	ld a, $52
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_AGILITY
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2d09d

ShellderSupersonicEffect: ; 2d09d (b:509d)
	call Confusion50PercentEffect
	call nc, SetNoEffectFromStatus
	ret
; 0x2d0a4

HideInShellEffect: ; 2d0a4 (b:50a4)
	ldtx de, IfHeadsNoDamageNextTurnText
	call TossCoin_BankB
	jp nc, SetWasUnsuccessful
	ld a, $4f
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_NO_DAMAGE_11
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2d0b8

VaporeonQuickAttack_AIEffect: ; 2d0b8 (b:50b8)
	ld a, (10 + 30) / 2
	lb de, 10, 30
	jp StoreAIDamageInfo
; 0x2d0c0

VaporeonQuickAttack_DamageBoostEffect: ; 2d0c0 (b:50c0)
	ld hl, 20
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsPlusDamageText
	call TossCoin_BankB
	ret nc ; return if tails
	ld a, 20
	call AddToDamage
	ret
; 0x2d0d3

VaporeonWaterGunEffect: ; 2d0d3 (b:50d3)
	lb bc, 2, 1
	jp ApplyExtraWaterEnergyDamageBonus
; 0x2d0d9

; returns carry if Arena card has no Water Energy attached
; or if it doesn't have any damage counters.
StarmieRecover_CheckEnergyHP: ; 2d0d9 (b:50d9)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + WATER]
	ldtx hl, NotEnoughWaterEnergyText
	cp 1
	ret c ; return if not enough energy
	call GetCardDamageAndMaxHP
	ldtx hl, NoDamageCountersText
	cp 10
	ret ; return carry if no damage
; 0x2d0f0

StarmieRecover_PlayerSelectEffect: ; 2d0f0 (b:50f0)
	ld a, TYPE_ENERGY_WATER
	call CreateListOfEnergyAttachedToArena
	xor a ; PLAY_AREA_ARENA
	bank1call DisplayEnergyDiscardScreen
.loop_input
	bank1call HandleEnergyDiscardMenuInput
	jr c, .loop_input
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a ; store card chosen
	ret
; 0x2d103

StarmieRecover_AISelectEffect: ; 2d103 (b:5103)
	ld a, TYPE_ENERGY_WATER
	call CreateListOfEnergyAttachedToArena
	ld a, [wDuelTempList] ; pick first card
	ldh [hTemp_ffa0], a
	ret
; 0x2d10e

StarmieRecover_DiscardEffect: ; 2d10e (b:510e)
	ldh a, [hTemp_ffa0]
	call PutCardInDiscardPile
	ret
; 0x2d114

StarmieRecover_HPRecoveryEffect: ; 2d114 (b:5114)
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	ld e, a ; all damage for recovery
	ld d, 0
	call ApplyAndAnimateHPRecovery
	ret
; 0x2d120

SquirtleWithdrawEffect: ; 2d120 (b:5120)
	ldtx de, IfHeadsNoDamageNextTurnText
	call TossCoin_BankB
	jp nc, SetWasUnsuccessful
	ld a, $4f
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_NO_DAMAGE_10
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2d134

HorseaSmokescreenEffect: ; 2d134 (b:5134)
	ld a, SUBSTATUS2_SMOKESCREEN
	call ApplySubstatus2ToDefendingCard
	ret
; 0x2d13a

TentacruelSupersonicEffect: ; 2d13a (b:513a)
	call Confusion50PercentEffect
	call nc, SetNoEffectFromStatus
	ret
; 0x2d141

JellyfishSting_AIEffect: ; 2d141 (b:5141)
	ld a, 10
	lb de, 10, 10
	jp StoreAIPoisonDamageInfo
; 0x2d149

; returns carry if Defending Pokemon has no attacks
PoliwhirlAmnesia_CheckAttacks: ; 2d149 (b:5149)
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Move1Category]
	cp POKEMON_POWER
	jr nz, .has_attack
	ld hl, wLoadedCard2Move2Name
	ld a, [hli]
	or [hl]
	jr nz, .has_attack
; has no attack
	call SwapTurn
	ldtx hl, NoAttackMayBeChoosenText
	scf
	ret
.has_attack
	call SwapTurn
	or a
	ret
; 0x2d16f

PoliwhirlAmnesia_PlayerSelectEffect: ; 2d16f (b:516f)
	call PlayerPickAttackForAmnesia
	ret
; 0x2d173

PoliwhirlAmnesia_AISelectEffect: ; 2d173 (b:5173)
	call AIPickAttackForAmnesia
	ldh [hTemp_ffa0], a
	ret
; 0x2d179

PoliwhirlAmnesia_DisableEffect: ; 2d179 (b:5179)
	call ApplyAmnesiaToAttack
	ret
; 0x2d17d

PlayerPickAttackForAmnesia: ; 2d17d (b:517d)
	ldtx hl, ChooseAttackOpponentWillNotBeAbleToUseText
	call DrawWideTextBox_WaitForInput
	call HandleAmnesiaScreen
	ld a, e
	ldh [hTemp_ffa0], a
	ret
; 0x2d18a

; applies the Amnesia effect on the defending Pokemon,
; for the attack index in hTemp_ffa0.
ApplyAmnesiaToAttack: ; 2d18a (b:518a)
	ld a, SUBSTATUS2_AMNESIA
	call ApplySubstatus2ToDefendingCard
	ld a, [wNoDamageOrEffect]
	or a
	ret nz ; no effect

; set selected attack as disabled
	ld a, DUELVARS_ARENA_CARD_DISABLED_MOVE_INDEX
	call GetNonTurnDuelistVariable
	ldh a, [hTemp_ffa0]
	ld [hl], a

	ld l, DUELVARS_ARENA_CARD_LAST_TURN_EFFECT
	ld [hl], LAST_TURN_EFFECT_AMNESIA

	call CheckIfTurnDuelistIsPlayer
	ret c ; return if Player

; the rest of the routine if for Opponent
; to announce which move was used for Amnesia.
	call SwapTurn
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, a
	ldh a, [hTemp_ffa0]
	ld e, a
	call GetAttackName
	call LoadTxRam2
	ldtx hl, WasChosenForTheEffectOfAmnesiaText
	call DrawWideTextBox_WaitForInput
	call SwapTurn
	ret
; 0x2d1c0

PoliwhirlDoubleslap_AIEffect: ; 2d1c0 (b:51c0)
	ld a, 60 / 2
	lb de, 0, 60
	jp StoreAIDamageInfo
; 0x2d1c8

PoliwhirlDoubleslap_MultiplierEffect: ; 2d1c8 (b:51c8)
	ld hl, 30
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 2
	call TossCoinATimes_BankB
	ld e, a
	add a
	add e
	call ATimes10
	call StoreDamageInfo
	ret
; 0x2d1e0

PoliwrathWaterGunEffect: ; 2d1e0 (b:51e0)
	lb bc, 2, 1
	jp ApplyExtraWaterEnergyDamageBonus
; 0x2d1e6

Whirlpool_PlayerSelectEffect: ; 2d1e6 (b:51e6)
	call SwapTurn
	xor a ; PLAY_AREA_ARENA
	call CreateArenaOrBenchEnergyCardList
	jr c, .no_energy

	ldtx hl, ChooseDiscardEnergyCardFromOpponentText
	call DrawWideTextBox_WaitForInput
	xor a ; PLAY_AREA_ARENA
	bank1call DisplayEnergyDiscardScreen
.loop_input
	bank1call HandleEnergyDiscardMenuInput
	jr c, .loop_input

	call SwapTurn
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a ; store selected card to discard
	ret

.no_energy
	call SwapTurn
	ld a, $ff
	ldh [hTemp_ffa0], a
	ret
; 0x2d20e

Whirlpool_AISelectEffect: ; 2d20e (b:520e)
	call AIPickEnergyCardToDiscardFromDefendingPokemon
	ldh [hTemp_ffa0], a
	ret
; 0x2d214

Whirlpool_DiscardEffect: ; 2d214 (b:5214)
	call HandleNoDamageOrEffect
	ret c ; return if attack had no effect
	ldh a, [hTemp_ffa0]
	cp $ff
	ret z ; return if none selected

	; discard Defending card's energy
	; this doesn't update DUELVARS_ARENA_CARD_LAST_TURN_EFFECT
	call SwapTurn
	call PutCardInDiscardPile
	; ld a, DUELVARS_ARENA_CARD_LAST_TURN_EFFECT
	; call GetTurnDuelistVariable
	; ld [hl], LAST_TURN_EFFECT_DISCARD_ENERGY
	call SwapTurn
	ret
; 0x2d227

PoliwagWaterGunEffect: ; 2d227 (b:5227)
	lb bc, 1, 0
	jp ApplyExtraWaterEnergyDamageBonus
; 0x2d22d

ClampEffect: ; 2d22d (b:522d)
	ld a, $05
	ld [wLoadedMoveAnimation], a
	ldtx de, SuccessCheckIfHeadsAttackIsSuccessfulText
	call TossCoin_BankB
	jp c, ParalysisEffect
; unsuccessful
	xor a
	ld [wLoadedMoveAnimation], a
	call StoreDamageInfo
	call SetWasUnsuccessful
	ret
; 0x2d246

CloysterSpikeCannon_AIEffect: ; 2d246 (b:5246)
	ld a, 60 / 2
	lb de, 0, 60
	jp StoreAIDamageInfo
; 0x2d24e

CloysterSpikeCannon_MultiplierEffect: ; 2d24e (b:524e)
	ld hl, 30
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 2
	call TossCoinATimes_BankB
	ld e, a
	add a
	add e
	call ATimes10
	call StoreDamageInfo
	ret
; 0x2d266

Blizzard_BenchDamage50PercentEffect: ; 2d266 (b:5266)
	ldtx de, DamageToOppBenchIfHeadsDamageToYoursIfTailsText
	call TossCoin_BankB
	ldh [hTemp_ffa0], a ; store coin result
	ret
; 0x2d26f

Blizzard_BenchDamageEffect: ; 2d26f (b:526f)
	ldh a, [hTemp_ffa0]
	or a
	jr nz, .opp_bench

; own bench
	ld a, $01
	ld [wIsDamageToSelf], a
	ld a, 10
	call DealDamageToAllBenchedPokemon
	ret

.opp_bench
	call SwapTurn
	ld a, 10
	call DealDamageToAllBenchedPokemon
	call SwapTurn
	ret
; 0x2d28b

; return carry if can use Cowardice
Cowardice_Check: ; 2d28b (b:528b)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret c ; return if cannot use

	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ldtx hl, EffectNoPokemonOnTheBenchText
	cp 2
	ret c ; return if no bench

	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_FLAGS_C2
	call GetTurnDuelistVariable
	ldtx hl, CannotBeUsedInTurnWhichWasPlayedText
	and CAN_EVOLVE_THIS_TURN
	scf
	ret z ; return if was played this turn

	or a
	ret
; 0x2d2ae

Cowardice_PlayerSelectEffect: ; 2d2ae (b:52ae)
	ldh a, [hTemp_ffa0]
	or a
	ret nz ; return if not Arena card
	ldtx hl, SelectPokemonToPlaceInTheArenaText
	call DrawWideTextBox_WaitForInput
	bank1call HasAlivePokemonInBench
	bank1call OpenPlayAreaScreenForSelection
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hAIPkmnPowerEffectParam], a
	ret
; 0x2d2c3

Cowardice_RemoveFromPlayAreaEffect: ; 2d2c3 (b:52c3)
	ldh a, [hTemp_ffa0]
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable

; put card in Discard Pile temporarily, so that
; all cards attached are discarded as well.
	push af
	ldh a, [hTemp_ffa0]
	ld e, a
	call MovePlayAreaCardToDiscardPile

; if card was in Arena, swap selected Bench
; Pokemon with Arena, otherwise skip.
	ldh a, [hTemp_ffa0]
	or a
	jr nz, .skip_switch
	ldh a, [hAIPkmnPowerEffectParam]
	ld e, a
	call SwapArenaWithBenchPokemon

.skip_switch
; move card back to Hand from Discard Pile
; and adjust Play Area
	pop af
	call MoveDiscardPileCardToHand
	call AddCardToHand
	call ShiftAllPokemonToFirstPlayAreaSlots

	xor a
	ld [wDuelDisplayedScreen], a
	ret
; 0x2d2eb

LaprasWaterGunEffect: ; 2d2eb (b:52eb)
	lb bc, 1, 0
	jp ApplyExtraWaterEnergyDamageBonus
; 0x2d2f1

Quickfreeze_InitialEffect: ; 2d2f1 (b:52f1)
	scf
	ret
; 0x2d2f3

Quickfreeze_Paralysis50PercentEffect: ; 2d2f3 (b:52f3)
	ldtx de, ParalysisCheckText
	call TossCoin_BankB
	jr c, .heads

; tails
	call SetWasUnsuccessful
	bank1call DrawDuelMainScene
	bank1call Func_1bca
	call WaitForWideTextBoxInput
	ret

.heads
	call ParalysisEffect
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld b, a
	ld c, $00
	ldh a, [hWhoseTurn]
	ld h, a
	bank1call PlayMoveAnimation
	bank1call Func_741a
	bank1call WaitMoveAnimation
	bank1call Func_6df1
	bank1call DrawDuelHUDs
	bank1call Func_1bca
	call c, WaitForWideTextBoxInput
	ret
; 0x2d329

IceBreath_ZeroDamage: ; 2d329 (b:5329)
	xor a
	call StoreDamageInfo
	ret
; 0x2d32e

IceBreath_RandomPokemonDamageEffect: ; 2d32e (b:532e)
	call SwapTurn
	call PickRandomPlayAreaCard
	ld b, a
	ld de, 40
	call DealDamageToPlayAreaPokemon
	call SwapTurn
	ret
; 0x2d33f

FocusEnergyEffect: ; 2d33f (b:533f)
	ld a, [wTempTurnDuelistCardID]
	cp VAPOREON1
	ret nz ; return if no Vaporeon1
	ld a, SUBSTATUS1_NEXT_TURN_DOUBLE_DAMAGE
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2d34b

PlayerPickFireEnergyCardToDiscard: ; 2d34b (b:534b)
	call CreateListOfFireEnergyAttachedToArena
	xor a
	bank1call DisplayEnergyDiscardScreen
	bank1call HandleEnergyDiscardMenuInput
	ldh a, [hTempCardIndex_ff98]
	ldh [hTempCardList], a
	ret
; 0x2d35a

AIPickFireEnergyCardToDiscard: ; 2d35a (b:535a)
	call CreateListOfFireEnergyAttachedToArena
	ld a, [wDuelTempList]
	ldh [hTempCardList], a ; pick first in list
	ret
; 0x2d363

; returns carry if Arena card has no Fire Energy cards
ArcanineFlamethrower_CheckEnergy: ; 2d363 (b:5363)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies]
	ldtx hl, NotEnoughFireEnergyText
	cp 1
	ret
; 0x2d371

ArcanineFlamethrower_PlayerSelectEffect: ; 2d371 (b:5371)
	call PlayerPickFireEnergyCardToDiscard
	ret
; 0x2d375

ArcanineFlamethrower_AISelectEffect: ; 2d375 (b:5375)
	call AIPickFireEnergyCardToDiscard
	ret
; 0x2d379

ArcanineFlamethrower_DiscardEffect: ; 2d379 (b:5379)
	ldh a, [hTempCardList]
	call PutCardInDiscardPile
	ret
; 0x2d37f

TakeDownEffect: ; 2d37f (b:537f)
	ld a, 30
	call DealRecoilDamageToSelf
	ret
; 0x2d385

ArcanineQuickAttack_AIEffect: ; 2d385 (b:5385)
	ld a, (10 + 30) / 2
	lb de, 10, 30
	jp StoreAIDamageInfo
; 0x2d38d

ArcanineQuickAttack_DamageBoostEffect: ; 2d38d (b:538d)
	ld hl, 20
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsPlusDamageText
	call TossCoin_BankB
	ret nc ; return if tails
	ld a, 20
	call AddToDamage
	ret
; 0x2d3a0

; return carry if has less than 2 Fire Energy cards
FlamesOfRage_CheckEnergy: ; 2d3a0 (b:53a0)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies]
	ldtx hl, NotEnoughFireEnergyText
	cp 2
	ret
; 0x2d3ae

FlamesOfRage_PlayerSelectEffect: ; 2d3ae (b:53ae)
	ldtx hl, ChooseAndDiscard2FireEnergyCardsText
	call DrawWideTextBox_WaitForInput

	xor a
	ldh [hEffectItemSelection], a
	call CreateListOfFireEnergyAttachedToArena
	xor a
	bank1call DisplayEnergyDiscardScreen
.loop_input
	bank1call HandleEnergyDiscardMenuInput
	ret c
	call GetCurPositionInTempList
	ldh a, [hTempCardIndex_ff98]
	ld [hl], a
	call RemoveCardFromDuelTempList
	ldh a, [hEffectItemSelection]
	cp 2
	ret nc ; return when 2 have been chosen
	bank1call DisplayEnergyDiscardMenu
	jr .loop_input
; 0x2d3d5

FlamesOfRage_AISelectEffect: ; 2d3d5 (b:53d5)
	call AIPickFireEnergyCardToDiscard
	ld a, [wDuelTempList + 1]
	ldh [hTempCardList + 1], a
	ret
; 0x2d3de

FlamesOfRage_DiscardEffect: ; 2d3de (b:53de)
	ldh a, [hTempCardList]
	call PutCardInDiscardPile
	ldh a, [hTempCardList + 1]
	call PutCardInDiscardPile
	ret
; 0x2d3e9

FlamesOfRage_AIEffect: ; 2d3e9 (b:53e9)
	call FlamesOfRage_DamageBoostEffect
	jp SetMinMaxDamageSameAsDamage
; 0x2d3ef

FlamesOfRage_DamageBoostEffect: ; 2d3ef (b:53ef)
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	call AddToDamage
	ret
; 0x2d3f8

RapidashStomp_AIEffect: ; 2d3f8 (b:53f8)
	ld a, (20 + 30) / 2
	lb de, 20, 30
	jp StoreAIDamageInfo
; 0x2d400

RapidashStomp_DamageBoostEffect: ; 2d400 (b:5400)
	ld hl, 10
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsPlusDamageText
	call TossCoin_BankB
	ret nc ; return if tails
	ld a, 10
	call AddToDamage
	ret
; 0x2d413

RapidashAgilityEffect: ; 2d413 (b:5413)
	ldtx de, IfHeadsDoNotReceiveDamageOrEffectText
	call TossCoin_BankB
	ret nc ; return if tails
	ld a, $52
	ld [wLoadedMoveAnimation], a
	ld a, SUBSTATUS1_AGILITY
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2d425

; returns carry if Opponent has no Pokemon in bench
NinetailsLure_CheckBench: ; 2d425 (b:5425)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	ldtx hl, EffectNoPokemonOnTheBenchText
	cp 2
	ret
; 0x2d430

NinetailsLure_PlayerSelectEffect: ; 2d430 (b:5430)
	ldtx hl, SelectPkmnOnBenchToSwitchWithActiveText
	call DrawWideTextBox_WaitForInput
	call SwapTurn
	bank1call HasAlivePokemonInBench
.loop_input
	bank1call OpenPlayAreaScreenForSelection
	jr c, .loop_input
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	call SwapTurn
	ret
; 0x2d449

NinetailsLure_AISelectEffect: ; 2d449 (b:5449)
	call AIFindBenchWithLowestHP
	ldh [hTemp_ffa0], a
	ret
; 0x2d44f

NinetailsLure_SwitchEffect: ; 2d44f (b:544f)
	call SwapTurn
	ldh a, [hTemp_ffa0]
	ld e, a
	call HandleNShieldAndTransparency
	call nc, SwapArenaWithBenchPokemon
	call SwapTurn
	xor a
	ld [wDuelDisplayedScreen], a
	ret
; 0x2d463

; return carry if no Fire energy cards
FireBlast_CheckEnergy: ; 2d463 (b:5463)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ldtx hl, NotEnoughFireEnergyText
	ld a, [wAttachedEnergies]
	cp 1
	ret
; 0x2d471

FireBlast_PlayerSelectEffect: ; 2d471 (b:5471)
	call PlayerPickFireEnergyCardToDiscard
	ret
; 0x2d475

FireBlast_AISelectEffect: ; 2d475 (b:5475)
	call AIPickFireEnergyCardToDiscard
	ret
; 0x2d479

FireBlast_DiscardEffect: ; 2d479 (b:5479)
	ldh a, [hTempCardList]
	call PutCardInDiscardPile
	ret
; 0x2d47f

; return carry if no Fire energy cards
Ember_CheckEnergy: ; 2d47f (b:547f)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ldtx hl, NotEnoughFireEnergyText
	ld a, [wAttachedEnergies]
	cp 1
	ret
; 0x2d48d

Ember_PlayerSelectEffect: ; 2d48d (b:548d)
	call PlayerPickFireEnergyCardToDiscard
	ret
; 0x2d491

Ember_AISelectEffect: ; 2d491 (b:5491)
	call AIPickFireEnergyCardToDiscard
	ret
; 0x2d495

Ember_DiscardEffect: ; 2d495 (b:5495)
	ldh a, [hTempCardList]
	call PutCardInDiscardPile
	ret
; 0x2d49b

; return carry if no Fire energy cards
Wildfire_CheckEnergy: ; 2d49b (b:549b)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ldtx hl, NotEnoughFireEnergyText
	ld a, [wAttachedEnergies]
	cp 1
	ret
; 0x2d4a9

Wildfire_PlayerSelectEffect: ; 2d4a9 (b:54a9)
	ldtx hl, DiscardOppDeckAsManyFireEnergyCardsText
	call DrawWideTextBox_WaitForInput

	xor a
	ldh [hEffectItemSelection], a
	call CreateListOfFireEnergyAttachedToArena
	xor a
	bank1call DisplayEnergyDiscardScreen

; show list to Player and for each card selected to discard,
; just increase a counter and store it.
; this will be the output used by Wildfire_DiscardEnergyEffect.
	xor a
	ld [wcbfa], a
.loop
	ldh a, [hEffectItemSelection]
	ld [wcbfb], a
	bank1call HandleEnergyDiscardMenuInput
	jr c, .done
	ld hl, hEffectItemSelection
	inc [hl]
	call RemoveCardFromDuelTempList
	jr c, .done
	bank1call DisplayEnergyDiscardMenu
	jr .loop

.done
; return carry if no cards were discarded
; output the result in hTemp_ffa0
	ldh a, [hEffectItemSelection]
	ldh [hTemp_ffa0], a
	or a
	ret nz
	scf
	ret
; 0x2d4dd

Wildfire_AISelectEffect: ; 2d4dd (b:54dd)
; AI always chooses 0 cards to discard
	xor a
	ldh [hTempCardList], a
	ret
; 0x2d4e1

Wildfire_DiscardEnergyEffect: ; 2d4e1 (b:54e1)
	call CreateListOfFireEnergyAttachedToArena
	ldh a, [hTemp_ffa0]
	or a
	ret z ; no cards to discard

; discard cards from wDuelTempList equal to the number
; of cards that were input in hTemp_ffa0.
; these are all the Fire Energy cards attached to Arena card
; so it will discard the cards in order, regardless
; of the actual order that was selected by Player.
	ld c, a
	ld hl, wDuelTempList
.loop_discard
	ld a, [hli]
	call PutCardInDiscardPile
	dec c
	jr nz, .loop_discard
	ret
; 0x2d4f4

Wildfire_DiscardDeckEffect: ; 2d4f4 (b:54f4)
	ldh a, [hTemp_ffa0]
	ld c, a
	ld b, $00
	call SwapTurn
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld a, DECK_SIZE
	sub [hl]
	cp c
	jr nc, .start_discard
	; only discard number of cards that are left in deck
	ld c, a

.start_discard
	push bc
	inc c
	jr .check_remaining

.loop
	; discard top card from deck
	call DrawCardFromDeck
	call nc, PutCardInDiscardPile
.check_remaining
	dec c
	jr nz, .loop

	pop hl
	call LoadTxRam3
	ldtx hl, DiscardedCardsFromDeckText
	call DrawWideTextBox_PrintText
	call SwapTurn
	ret
; 0x2d523

Moltres1DiveBomb_AIEffect: ; 2d523 (b:5523)
	ld a, 80 / 2
	lb de, 0, 80
	jp StoreAIDamageInfo
; 0x2d52b

Moltres1DiveBomb_Failure50PercentEffect: ; 2d52b (b:552b)
	ldtx de, SuccessCheckIfHeadsAttackIsSuccessfulText
	call TossCoin_BankB
	jr c, .heads
; tails
	xor a
	call StoreDamageInfo
	call SetWasUnsuccessful
	ret
.heads
	ld a, $11
	ld [wLoadedMoveAnimation], a
	ret
; 0x2d541

FlareonQuickAttack_AIEffect: ; 2d541 (b:5541)
	ld a, (10 + 30) / 2
	lb de, 10, 30
	jp StoreAIDamageInfo
; 0x2d549

FlareonQuickAttack_DamageBoostEffect: ; 2d549 (b:5549)
	ld hl, 20
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsPlusDamageText
	call TossCoin_BankB
	ret nc ; return if tails
	ld a, 20
	call AddToDamage
	ret
; 0x2d55c

; return carry if no Fire Energy attached
FlareonFlamethrower_CheckEnergy: ; 2d55c (b:555c)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ldtx hl, NotEnoughFireEnergyText
	ld a, [wAttachedEnergies]
	cp 1
	ret
; 0x2d56a

FlareonFlamethrower_PlayerSelectEffect: ; 2d56a (b:556a)
	call PlayerPickFireEnergyCardToDiscard
	ret
; 0x2d56e

FlareonFlamethrower_AISelectEffect: ; 2d56e (b:556e)
	call AIPickFireEnergyCardToDiscard
	ret
; 0x2d572

FlareonFlamethrower_DiscardEffect: ; 2d572 (b:5572)
	ldh a, [hTempCardList]
	call PutCardInDiscardPile
	ret
; 0x2d578

; return carry if no Fire Energy attached
MagmarFlamethrower_CheckEnergy: ; 2d578 (b:5578)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ldtx hl, NotEnoughFireEnergyText
	ld a, [wAttachedEnergies]
	cp 1
	ret
; 0x2d586

MagmarFlamethrower_PlayerSelectEffect: ; 2d586 (b:5586)
	call PlayerPickFireEnergyCardToDiscard
	ret
; 0x2d58a

MagmarFlamethrower_AISelectEffect: ; 2d58a (b:558a)
	call AIPickFireEnergyCardToDiscard
	ret
; 0x2d58e

MagmarFlamethrower_DiscardEffect: ; 2d58e (b:558e)
	ldh a, [hTempCardList]
	call PutCardInDiscardPile
	ret
; 0x2d594

MagmarSmokescreenEffect: ; 2d594 (b:5594)
	ld a, SUBSTATUS2_SMOKESCREEN
	call ApplySubstatus2ToDefendingCard
	ret
; 0x2d59a

MagmarSmog_AIEffect: ; 2d59a (b:559a)
	ld a, 5
	lb de, 0, 10
	jp StoreAIPoisonDamageInfo
; 0x2d5a2

; return carry if no Fire Energy attached
CharmeleonFlamethrower_CheckEnergy: ; 2d5a2 (b:55a2)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ldtx hl, NotEnoughFireEnergyText
	ld a, [wAttachedEnergies]
	cp 1
	ret
; 0x2d5b0

CharmeleonFlamethrower_PlayerSelectEffect: ; 2d5b0 (b:55b0)
	call PlayerPickFireEnergyCardToDiscard
	ret
; 0x2d5b4

CharmeleonFlamethrower_AISelectEffect: ; 2d5b4 (b:55b4)
	call AIPickFireEnergyCardToDiscard
	ret
; 0x2d5b8

CharmeleonFlamethrower_DiscardEffect: ; 2d5b8 (b:55b8)
	ldh a, [hTempCardList]
	call PutCardInDiscardPile
	ret
; 0x2d5be

EnergyBurnEffect: ; 2d5be (b:55be)
	scf
	ret
; 0x2d5c0

; return carry if has less than 2 Fire Energy cards
FireSpin_CheckEnergy: ; 2d5c0 (b:55c0)
	xor a ; PLAY_AREA_ARENA
	call CreateArenaOrBenchEnergyCardList
	call CountCardsInDuelTempList
	ldtx hl, NotEnoughEnergyCardsText
	cp 2
	ret
; 0x2d5cd

FireSpin_PlayerSelectEffect: ; 2d5cd (b:55cd)
	ldtx hl, ChooseAndDiscard2EnergyCardsText
	call DrawWideTextBox_WaitForInput

	xor a
	ldh [hEffectItemSelection], a
	xor a
	call CreateArenaOrBenchEnergyCardList
	call SortCardsInDuelTempListByID
	xor a
	bank1call DisplayEnergyDiscardScreen

	ld a, 2
	ld [wcbfa], a
.loop_input
	bank1call HandleEnergyDiscardMenuInput
	ret c
	call GetCurPositionInTempList
	ldh a, [hTempCardIndex_ff98]
	ld [hl], a
	ld hl, wcbfb
	inc [hl]
	ldh a, [hEffectItemSelection]
	cp 2
	jr nc, .done
	ldh a, [hTempCardIndex_ff98]
	call RemoveCardFromDuelTempList
	bank1call DisplayEnergyDiscardMenu
	jr .loop_input
.done
; return when 2 have been chosen
	or a
	ret
; 0x2d606

FireSpin_AISelectEffect: ; 2d606 (b:5606)
	xor a ; PLAY_AREA_ARENA
	call CreateArenaOrBenchEnergyCardList
	ld hl, wDuelTempList
	ld a, [hli]
	ldh [hTempCardList], a
	ld a, [hl]
	ldh [hTempCardList + 1], a
	ret
; 0x2d614

FireSpin_DiscardEffect: ; 2d614 (b:5614)
	ld hl, hTempCardList
	ld a, [hli]
	call PutCardInDiscardPile
	ld a, [hli]
	call PutCardInDiscardPile
	ret
; 0x2d620

; returns carry if Pkmn Power cannot be used
; or if Arena card is not Charizard.
; this is unused.
EnergyBurnCheck_Unreferenced: ; 2d620 (b:5620)
	xor a
	bank1call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret c
	ld a, DUELVARS_ARENA_CARD
	push de
	call GetTurnDuelistVariable
	call GetCardIDFromDeckIndex
	ld a, e
	pop de
	cp CHARIZARD
	jr nz, .not_charizard
	or a
	ret
.not_charizard
	scf
	ret
; 0x2d638

FlareonRage_AIEffect: ; 2d638 (b:5638)
	call FlareonRage_DamageBoostEffect
	jp SetMinMaxDamageSameAsDamage
; 0x2d63e

FlareonRage_DamageBoostEffect: ; 2d63e (b:563e)
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	call AddToDamage
	ret
; 0x2d647

MixUpEffect: ; 2d647 (b:5647)
	call SwapTurn
	call CreateHandCardList
	call SortCardsInDuelTempListByID

; first go through Hand to place
; all Pkmn cards in it in the Deck.
	ld hl, wDuelTempList
	ld c, 0
.loop_hand
	ld a, [hl]
	cp $ff
	jr z, .done_hand
	call .CheckIfCardIsPkmnCard
	jr nc, .next_hand
	; found Pkmn card, place in deck
	inc c
	ld a, [hl]
	call RemoveCardFromHand
	call ReturnCardToDeck
.next_hand
	inc hl
	jr .loop_hand

.done_hand
	ld a, c
	ldh [hEffectItemSelection], a
	push bc
	ldtx hl, ThePkmnCardsInHandAndDeckWereShuffledText
	call DrawWideTextBox_WaitForInput

	call Func_2c0bd
	call CreateDeckCardList
	pop bc
	ldh a, [hEffectItemSelection]
	or a
	jr z, .done ; if no cards were removed from Hand, return

; c holds the number of cards that were placed in the Deck.
; now pick Pkmn cards from the Deck to place in Hand.
	ld hl, wDuelTempList
.loop_deck
	ld a, [hl]
	call .CheckIfCardIsPkmnCard
	jr nc, .next_deck
	dec c
	ld a, [hl]
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
.next_deck
	inc hl
	ld a, c
	or a
	jr nz, .loop_deck
.done
	call SwapTurn
	ret
; 0x2d69a

; returns carry if card index in a is Pkmn card
.CheckIfCardIsPkmnCard: ; 2d69a (b:569a)
	call LoadCardDataToBuffer2_FromDeckIndex
	ld a, [wLoadedCard2Type]
	cp TYPE_ENERGY
	ret
; 0x2d6a3

DancingEmbers_AIEffect: ; 2d6a3 (b:56a3)
	ld a, 80 / 2
	lb de, 0, 80
	jp StoreAIDamageInfo
; 0x2d6ab

DancingEmbers_MultiplierEffect: ; 2d6ab (b:56ab)
	ld hl, 10
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 8
	call TossCoinATimes_BankB
	call ATimes10
	call StoreDamageInfo
	ret
; 0x2d6c0

Firegiver_InitialEffect: ; 2d6c0 (b:56c0)
	scf
	ret
; 0x2d6c2

Firegiver_AddToHandEffect: ; 2d6c2 (b:56c2)
; fill wDuelTempList with all Fire Energy card
; deck indices that are in the Deck.
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable
	ld de, wDuelTempList
	ld c, 0
.loop_cards
	ld a, [hl]
	cp CARD_LOCATION_DECK
	jr nz, .next
	push hl
	push de
	ld a, l
	call GetCardIDFromDeckIndex
	call GetCardType
	pop de
	pop hl
	cp TYPE_ENERGY_FIRE
	jr nz, .next
	ld a, l
	ld [de], a
	inc de
	inc c
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop_cards
	ld a, $ff
	ld [de], a

; check how many were found
	ld a, c
	or a
	jr nz, .found
	; return if none found
	ldtx hl, ThereWasNoFireEnergyText
	call DrawWideTextBox_WaitForInput
	call Func_2c0bd
	ret

.found
; pick a random number between 1 and 4,
; up to the maximum number of Fire Energy
; cards that were found.
	ld a, 4
	call Random
	inc a
	cp c
	jr c, .ok
	ld a, c

.ok
	ldh [hEffectItemSelection], a
; load correct Move animation depending
; on what side the effect is from.
	ld d, $84
	ld a, [wDuelistType]
	cp DUELIST_TYPE_PLAYER
	jr z, .player_1
; opponent
	ld d, $85
.player_1
	ld a, d
	ld [wLoadedMoveAnimation], a

; start loop for adding Energy cards to hand
	ldh a, [hEffectItemSelection]
	ld c, a
	ld hl, wDuelTempList
.loop_energy
	push hl
	push bc
	ld bc, $0
	ldh a, [hWhoseTurn]
	ld h, a
	bank1call PlayMoveAnimation
	bank1call WaitMoveAnimation

; load correct coordinates to update the number of cards
; in hand and deck during animation.
	lb bc, 18, 7 ; x, y for hand number
	ld e, 3 ; y for deck number
	ld a, [wLoadedMoveAnimation]
	cp $84
	jr z, .player_2
	lb bc, 4, 5 ; x, y for hand number
	ld e, 10 ; y for deck number

.player_2
; update and print number of cards in hand
	ld a, DUELVARS_NUMBER_OF_CARDS_IN_HAND
	call GetTurnDuelistVariable
	inc a
	bank1call WriteTwoDigitNumberInTxSymbolFormat
; update and print number of cards in deck
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld a, DECK_SIZE - 1
	sub [hl]
	ld c, e
	bank1call WriteTwoDigitNumberInTxSymbolFormat

; load Fire Energy card index and add to hand
	pop bc
	pop hl
	ld a, [hli]
	call SearchCardInDeckAndAddToHand
	call AddCardToHand
	dec c
	jr nz, .loop_energy

; load the number of cards added to hand and print text
	ldh a, [hEffectItemSelection]
	ld l, a
	ld h, $00
	call LoadTxRam3
	ldtx hl, DrewFireEnergyFromTheHandText
	call DrawWideTextBox_WaitForInput
	call Func_2c0bd
	ret
; 0x2d76e

Moltres2DiveBomb_AIEffect: ; 2d76e (b:576e)
	ld a, 70 / 2
	lb de, 0, 70
	jp StoreAIDamageInfo
; 0x2d776

Moltres2DiveBomb_Failure50PercentEffect: ; 2d776 (b:5776)
	ldtx de, SuccessCheckIfHeadsAttackIsSuccessfulText
	call TossCoin_BankB
	jr c, .heads
; tails
	xor a
	call StoreDamageInfo
	call SetWasUnsuccessful
	ret
.heads
	ld a, $11
	ld [wLoadedMoveAnimation], a
	ret
; 0x2d78c

; output in de the number of energy cards
; attached to the Defending Pokemon times 10.
; used for attacks that deal 10x number of energy
; cards attached to the Defending card.
GetEnergyAttachedMultiplierDamage: ; 2d78c (b:578c)
	call SwapTurn
	ld a, DUELVARS_CARD_LOCATIONS
	call GetTurnDuelistVariable

	ld c, 0
.loop
	ld a, [hl]
	cp CARD_LOCATION_ARENA
	jr nz, .next
	; is in Arena
	ld a, l
	call GetCardIDFromDeckIndex
	call GetCardType
	and TYPE_ENERGY
	jr z, .next
	; is Energy attached to Arena card
	inc c
.next
	inc l
	ld a, l
	cp DECK_SIZE
	jr c, .loop

	call SwapTurn
	ld l, c
	ld h, $00
	ld b, $00
	add hl, hl ; hl =  2 * c
	add hl, hl ; hl =  4 * c
	add hl, bc ; hl =  5 * c
	add hl, hl ; hl = 10 * c
	ld e, l
	ld d, h
	ret
; 0x2d7bc

; draws list of Energy Cards in Discard Pile
; for Player to select from.
; the Player can select up to 2 cards from the list.
; these cards are given in $ff-terminated list
; in hTempCardList.
HandleEnergyCardsInDiscardPileSelection: ; 2d7bc (b:57bc)
	push hl
	xor a
	ldh [hEffectItemSelection], a
	call CreateEnergyCardListFromDiscardPile_OnlyBasic
	pop hl
	jr c, .finish

	call DrawWideTextBox_WaitForInput
.loop
; draws Discard Pile screen and textbox,
; and handles Player input
	bank1call InitAndDrawCardListScreenLayout
	ldtx hl, ChooseAnEnergyCardText
	ldtx de, PlayerDiscardPileText
	bank1call SetCardListHeaderText
	bank1call DisplayCardList
	jr nc, .selected

; Player is trying to exit screen,
; but can select up to 2 cards total.
; prompt Player to confirm exiting screen.
	ld a, 2
	call AskWhetherToQuitSelectingCards
	jr c, .loop
	jr .finish

.selected
; a card was selected, so add it to list
	call GetCurPositionInTempList
	ldh a, [hTempCardIndex_ff98]
	ld [hl], a
	call RemoveCardFromDuelTempList
	or a
	jr z, .finish ; no more cards?
	ldh a, [hEffectItemSelection]
	cp 2
	jr c, .loop ; already selected 2 cards?

.finish
; place terminating byte on list
	call GetCurPositionInTempList
	ld [hl], $ff
	or a
	ret
; 0x2d7fc

; returns carry if Pkmn Power cannot be used, and
; sets the correct text in hl for failure.
Curse_CheckDamageAndBench: ; 2d7fc (b:57fc)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a

; fail if Pkmn Power has already been used
	add DUELVARS_ARENA_CARD_FLAGS_C2
	call GetTurnDuelistVariable
	ldtx hl, OnlyOncePerTurnText
	and USED_PKMN_POWER_THIS_TURN
	jr nz, .set_carry

; fail if Opponent only has 1 Pokemon in Play Area
	call SwapTurn
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	call SwapTurn
	ldtx hl, CannotUseSinceTheresOnly1PkmnText
	cp 2
	jr c, .set_carry

; fail if Opponent has no damage counters
	call SwapTurn
	call CheckIfPlayAreaHasAnyDamage
	call SwapTurn
	ldtx hl, NoPokemonWithDamageCountersText
	jr c, .set_carry

; return carry if Pkmn Power cannot be used due
; to Toxic Gas or status.
	ldh a, [hTempPlayAreaLocation_ff9d]
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret

.set_carry
	scf
	ret
; 0x2d834

Curse_PlayerSelectEffect: ; 2d834 (b:5834)
	ldtx hl, ProcedureForCurseText
	bank1call DrawWholeScreenTextBox
	call SwapTurn
	xor a
	ldh [hEffectItemSelection], a
	bank1call Func_61a1
.start
	bank1call PrintPlayAreaCardList_EnableLCD
	push af
	ldh a, [hEffectItemSelection]
	ld hl, PlayAreaSelectionMenuParameters
	call InitializeMenuParameters
	pop af
	ld [wNumMenuItems], a

; first pick a target to take 1 damage counter from.
.loop_input_first
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input_first
	cp $ff
	jr z, .cancel
	ldh [hEffectItemSelection], a
	ldh [hTempPlayAreaLocation_ffa1], a
	call GetCardDamageAndMaxHP
	or a
	jr nz, .picked_first ; test if has damage
	; play sfx
	call Func_3794
	jr .loop_input_first

.picked_first
; give 10 HP to card selected, draw the scene,
; then immediately revert this.
	ldh a, [hTempPlayAreaLocation_ffa1]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	push af
	push hl
	add 10
	ld [hl], a
	bank1call PrintPlayAreaCardList_EnableLCD
	pop hl
	pop af
	ld [hl], a

; draw damage counter on cursor
	ldh a, [hTempPlayAreaLocation_ffa1]
	ld b, SYM_HP_NOK
	call DrawSymbolOnPlayAreaCursor

; handle input to pick the target to receive the damage counter.
.loop_input_second
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input_second
	ldh [hPkmnPowerPlayAreaTarget], a
	cp $ff
	jr nz, .a_press ; was a pressed?

; b press
; erase the damage counter symbol
; and loop back up again.
	ldh a, [hTempPlayAreaLocation_ffa1]
	ld b, SYM_SPACE
	call DrawSymbolOnPlayAreaCursor
	call EraseCursor
	jr .start

.a_press
	ld hl, hTempPlayAreaLocation_ffa1
	cp [hl]
	jr z, .loop_input_second ; same as first?
; a different Pokemon was picked,
; so store this Play Area location
; and erase the damage counter in the cursor.
	ldh a, [hTempPlayAreaLocation_ffa1]
	ld b, SYM_SPACE
	call DrawSymbolOnPlayAreaCursor
	call EraseCursor
	call SwapTurn
	or a
	ret

.cancel
; return carry if operation was cancelled.
	call SwapTurn
	scf
	ret
; 0x2d8bb

Curse_TransferDamageEffect: ; 2d8bb (b:58bb)
; set Pkmn Power as used
	ldh a, [hTempCardList]
	add DUELVARS_ARENA_CARD_FLAGS_C2
	call GetTurnDuelistVariable
	set USED_PKMN_POWER_THIS_TURN_F, [hl]

; figure out the type of duelist that used Curse.
; if it was the player, no need to draw the Play Area screen.
	call SwapTurn
	ld a, DUELVARS_DUELIST_TYPE
	call GetNonTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .vs_player

; vs. oppponent
	bank1call Func_61a1
.vs_player
; transfer the damage counter to the targets that were selected.
	ldh a, [hPkmnPowerPlayAreaTarget]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	sub 10
	ld [hl], a
	ldh a, [hTempPlayAreaLocation_ffa1]
	add DUELVARS_ARENA_CARD_HP
	ld l, a
	ld a, 10
	add [hl]
	ld [hl], a

	bank1call PrintPlayAreaCardList_EnableLCD
	ld a, DUELVARS_DUELIST_TYPE
	call GetNonTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .done
; vs. opponent
	ldh a, [hPkmnPowerPlayAreaTarget]
	ldh [hTempPlayAreaLocation_ff9d], a
	bank1call Func_6194

.done
	call SwapTurn
	call ExchangeRNG
	bank1call Func_6e49
	ret
; 0x2d903

GengarDarkMind_PlayerSelectEffect: ; 2d903 (b:5903)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	cp 2
	jr nc, .has_bench
; no bench Pokemon to damage.
	ld a, $ff
	ldh [hTemp_ffa0], a
	ret

.has_bench
; opens Play Area screen to select Bench Pokemon
; to damage, and store it before returning.
	ldtx hl, ChoosePkmnInTheBenchToGiveDamageText
	call DrawWideTextBox_WaitForInput
	call SwapTurn
	bank1call HasAlivePokemonInBench
.loop_input
	bank1call OpenPlayAreaScreenForSelection
	jr c, .loop_input
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	call SwapTurn
	ret
; 0x2d92a

GengarDarkMind_AISelectEffect: ; 2d92a (b:592a)
	ld a, $ff
	ldh [hTemp_ffa0], a
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	cp 2
	ret c ; return if no Bench Pokemon
; just pick Pokemon with lowest remaining HP.
	call AIFindBenchWithLowestHP
	ldh [hTemp_ffa0], a
	ret
; 0x2d93c

GengarDarkMind_DamageBenchEffect: ; 2d93c (b:593c)
	ldh a, [hTemp_ffa0]
	cp $ff
	ret z ; no target chosen
	call SwapTurn
	ld b, a
	ld de, 10
	call DealDamageToPlayAreaPokemon
	call SwapTurn
	ret
; 0x2d94f

SleepingGasEffect: ; 2d94f (b:594f)
	call Sleep50PercentEffect
	call nc, SetNoEffectFromStatus
	ret
; 0x2d956

DestinyBond_CheckEnergy: ; 2d956 (b:5956)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + PSYCHIC]
	ldtx hl, NotEnoughPsychicEnergyText
	cp 1
	ret
; 0x2d964

DestinyBond_PlayerSelectEffect: ; 2d964 (b:5964)
; handle input and display of Energy card list
	ld a, TYPE_ENERGY_PSYCHIC
	call CreateListOfEnergyAttachedToArena
	xor a
	bank1call DisplayEnergyDiscardScreen
	bank1call HandleEnergyDiscardMenuInput
	ret c
	ldh a, [hTempCardIndex_ff98]
	ldh [hTempCardList], a
	ret
; 0x2d976

DestinyBond_AISelectEffect: ; 2d976 (b:5976)
; pick first card in list
	ld a, TYPE_ENERGY_PSYCHIC
	call CreateListOfEnergyAttachedToArena
	ld a, [wDuelTempList]
	ldh [hTempCardList], a
	ret
; 0x2d981

DestinyBond_DiscardEffect: ; 2d981 (b:5981)
	ldh a, [hTempCardList]
	call PutCardInDiscardPile
	ret
; 0x2d987

DestinyBond_DestinyBondEffect: ; 2d987 (b:5987)
	ld a, SUBSTATUS1_DESTINY_BOND
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2d98d

; returns carry if no Energy cards in Discard Pile.
EnergyConversion_CheckEnergy: ; 2d98d (b:598d)
	call CreateEnergyCardListFromDiscardPile_OnlyBasic
	ldtx hl, ThereAreNoEnergyCardsInDiscardPileText
	ret
; 0x2d994

EnergyConversion_PlayerSelectEffect: ; 2d994 (b:5994)
	ldtx hl, Choose2EnergyCardsFromDiscardPileForHandText
	call HandleEnergyCardsInDiscardPileSelection
	ret
; 0x2d99b

EnergyConversion_AISelectEffect: ; 2d99b (b:599b)
	call CreateEnergyCardListFromDiscardPile_OnlyBasic
	ld hl, wDuelTempList
	ld de, hTempCardList
	ld c, 2
; select the first two energy cards found in Discard Pile
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	ld [de], a
	inc de
	dec c
	jr nz, .loop
.done
	ld a, $ff
	ld [de], a
	ret
; 0x2d9b4

EnergyConversion_AddToHandEffect: ; 2d9b4 (b:59b4)
; damage itself
	ld a, 10
	call DealRecoilDamageToSelf

; loop cards that were chosen
; until $ff is reached,
; and move them to the hand.
	ld hl, hTempCardList
	ld de, wDuelTempList
.loop_cards
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr z, .done
	call MoveDiscardPileCardToHand
	call AddCardToHand
	jr .loop_cards

.done
	call CheckIfTurnDuelistIsPlayer
	ret c
	bank1call Func_4b38
	ret
; 0x2d9d6

; return carry if Defending Pokemon is not asleep
DreamEaterEffect: ; 2d9d6 (b:59d6)
	ld a, DUELVARS_ARENA_CARD_STATUS
	call GetNonTurnDuelistVariable
	and CNF_SLP_PRZ
	cp ASLEEP
	ret z ; return if asleep
; not asleep, set carry and load text
	ldtx hl, OpponentIsNotAsleepText
	scf
	ret
; 0x2d9e5

TransparencyEffect: ; 2d9e5 (b:59e5)
	scf
	ret
; 0x2d9e7

; returns carry if neither the Turn Duelist or
; the non-Turn Duelist have any deck cards.
Prophecy_CheckDeck: ; 2d9e7 (b:59e7)
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE
	jr c, .no_carry
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetNonTurnDuelistVariable
	cp DECK_SIZE
	jr c, .no_carry
	ldtx hl, NoCardsLeftInTheDeckText
	scf
	ret
.no_carry
	or a
	ret
; 0x2da00

Prophecy_PlayerSelectEffect: ; 2da00 (b:5a00)
	ldtx hl, ProcedureForProphecyText
	bank1call DrawWholeScreenTextBox
.select_deck
	bank1call DrawDuelMainScene
	ldtx hl, PleaseSelectTheDeckText
	call TwoItemHorizontalMenu
	ldh a, [hKeysHeld]
	and B_BUTTON
	jr nz, Prophecy_PlayerSelectEffect ; loop back to start

	ldh a, [hCurMenuItem]
	ldh [hTempCardList], a ; store selection in first position in list
	or a
	jr z, .turn_duelist

; non-turn duelist
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetNonTurnDuelistVariable
	cp DECK_SIZE
	jr nc, .select_deck ; no cards, go back to deck selection
	call SwapTurn
	call HandleProphecyScreen
	call SwapTurn
	ret

.turn_duelist
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	cp DECK_SIZE
	jr nc, .select_deck ; no cards, go back to deck selection
	call HandleProphecyScreen
	ret
; 0x2da3c

Prophecy_AISelectEffect: ; 2da3c (b:5a3c)
; AI doesn't ever choose this attack
; so this it does no sorting.
	ld a, $ff
	ldh [hTemp_ffa0], a
	ret
; 0x2da41

Prophecy_ReorderDeckEffect: ; 2da41 (b:5a41)
	ld hl, hTempCardList
	ld a, [hli]
	or a
	jr z, .ReorderCards ; turn duelist's deck
	cp $ff
	ret z

	; non-turn duelist's deck
	call SwapTurn
	call .ReorderCards
	call SwapTurn
	ret

.ReorderCards
	ld c, 0
; add selected cards to hand in the specified order
.loop_add_hand
	ld a, [hli]
	cp $ff
	jr z, .dec_hl
	call SearchCardInDeckAndAddToHand
	inc c
	jr .loop_add_hand

.dec_hl
; go to last card that was in the list
	dec hl
	dec hl

.loop_return_deck
; return the cards to the top of the deck
	ld a, [hld]
	call ReturnCardToDeck
	dec c
	jr nz, .loop_return_deck
	call CheckIfTurnDuelistIsPlayer
	ret c
	; print text in case it was the opponent
	ldtx hl, ExchangedCardsInDuelistsHandText
	call DrawWideTextBox_WaitForInput
	ret
; 0x2da76

; draw and handle Player selection for reordering
; the top 3 cards of Deck.
; the resulting list is output in order in hTempCardList.
HandleProphecyScreen: ; 2da76 (b:5a76)
	ld a, DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK
	call GetTurnDuelistVariable
	ld b, a
	ld a, DECK_SIZE
	sub [hl] ; a = number of cards in deck

; store in c the number of cards that will be reordered.
; this number is 3, unless the deck as fewer cards than
; that in which case it will be the number of cards remaining.
	ld c, 3
	cp c
	jr nc, .got_number_cards
	ld c, a ; store number of remaining cards in c
.got_number_cards
	ld a, c
	inc a
	ld [wNumberOfCardsToOrder], a

; store in wDuelTempList the cards
; at top of Deck to be reordered.
	ld a, b
	add DUELVARS_DECK_CARDS
	ld l, a
	ld de, wDuelTempList
.loop_top_cards
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop_top_cards
	ld a, $ff ; terminating byte
	ld [de], a

.start
	call CountCardsInDuelTempList
	ld b, a
	ld a, 1 ; start at 1
	ldh [hEffectItemSelection], a

; initialize buffer ahead in wDuelTempList.
	ld hl, wDuelTempList + 10
	xor a
.loop_init_buffer
	ld [hli], a
	dec b
	jr nz, .loop_init_buffer
	ld [hl], $ff

	bank1call InitAndDrawCardListScreenLayout
	ldtx hl, ChooseTheOrderOfTheCardsText
	ldtx de, DuelistDeckText
	bank1call SetCardListHeaderText
	bank1call Func_5735

.loop_selection
	bank1call DisplayCardList
	jr c, .clear

; first check if this card was already selected
	ldh a, [hCurMenuItem]
	ld e, a
	ld d, $00
	ld hl, wDuelTempList + 10
	add hl, de
	ld a, [hl]
	or a
	jr nz, .loop_selection ; already chosen

; being here means card hasn't been selected yet,
; so add its order number to buffer and increment
; the sort number for the next card.
	ldh a, [hEffectItemSelection]
	ld [hl], a
	inc a
	ldh [hEffectItemSelection], a
	bank1call Func_5744
	ldh a, [hEffectItemSelection]
	ld hl, wNumberOfCardsToOrder
	cp [hl]
	jr c, .loop_selection ; still more cards

; confirm that the ordering has been completed
	call EraseCursor
	ldtx hl, IsThisOKText
	call YesOrNoMenuWithText_LeftAligned
	jr c, .start ; if not, return back to beginning of selection

; write in hTempCardList the card list
; in order that was selected.
	ld hl, wDuelTempList + 10
	ld de, wDuelTempList
	ld c, 0
.loop_order
	ld a, [hli]
	cp $ff
	jr z, .done
	push hl
	push bc
	ld c, a
	ld b, $00
	ld hl, hTempCardList
	add hl, bc
	ld a, [de]
	ld [hl], a
	pop bc
	pop hl
	inc de
	inc c
	jr .loop_order
; now hTempCardList has the list of card deck indices
; in the order selected to be place on top of the deck.

.done
	ld b, $00
	ld hl, hTempCardList + 1
	add hl, bc
	ld [hl], $ff ; terminating byte
	or a
	ret

.clear
; check if any reordering was done.
	ld hl, hEffectItemSelection
	ld a, [hl]
	cp 1
	jr z, .loop_selection ; none done, go back
; clear the order that was selected thus far.
	dec a
	ld [hl], a
	ld c, a
	ld hl, wDuelTempList + 10
.loop_clear
	ld a, [hli]
	cp c
	jr nz, .loop_clear
	; clear this byte
	dec hl
	ld [hl], $00
	bank1call Func_5744
	jr .loop_selection
; 0x2db2b

HypnoDarkMind_PlayerSelectEffect: ; 2db2b (b:5b2b)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	cp 2
	jr nc, .has_bench
; no bench Pokemon to damage.
	ld a, $ff
	ldh [hTemp_ffa0], a
	ret

.has_bench
; opens Play Area screen to select Bench Pokemon
; to damage, and store it before returning.
	ldtx hl, ChoosePkmnInTheBenchToGiveDamageText
	call DrawWideTextBox_WaitForInput
	call SwapTurn
	bank1call HasAlivePokemonInBench
.loop_input
	bank1call OpenPlayAreaScreenForSelection
	jr c, .loop_input
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	call SwapTurn
	ret
; 0x2db52

HypnoDarkMind_AISelectEffect: ; 2db52 (b:5b52)
	ld a, $ff
	ldh [hTemp_ffa0], a
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetNonTurnDuelistVariable
	cp 2
	ret c ; return if no Bench Pokemon
; just pick Pokemon with lowest remaining HP.
	call AIFindBenchWithLowestHP
	ldh [hTemp_ffa0], a
	ret
; 0x2db64

HypnoDarkMind_DamageBenchEffect: ; 2db64 (b:5b64)
	ldh a, [hTemp_ffa0]
	cp $ff
	ret z ; no target chosen
	call SwapTurn
	ld b, a
	ld de, 10
	call DealDamageToPlayAreaPokemon
	call SwapTurn
	ret
; 0x2db77

InvisibleWallEffect: ; 2db77 (b:5b77)
	scf
	ret
; 0x2db79

MrMimeMeditate_AIEffect: ; 2db79 (b:5b79)
	call MrMimeMeditate_DamageBoostEffect
	jp SetMinMaxDamageSameAsDamage
; 0x2db7f

MrMimeMeditate_DamageBoostEffect: ; 2db7f (b:5b7f)
; add damage counters of Defending card to damage
	call SwapTurn
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	call SwapTurn
	call AddToDamage
	ret
; 0x2db8e

; returns carry if Damage Swap cannot be used.
DamageSwap_CheckDamage: ; 2db8e (b:5b8e)
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	call CheckIfPlayAreaHasAnyDamage
	jr c, .no_damage
	ldh a, [hTempPlayAreaLocation_ff9d]
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret
.no_damage
	ldtx hl, NoPokemonWithDamageCountersText
	scf
	ret
; 0x2dba2

DamageSwap_SelectAndSwapEffect: ; 2dba2 (b:5ba2)
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .player
; non-player
	bank1call Func_61a1
	bank1call PrintPlayAreaCardList_EnableLCD
	ret

.player
	ldtx hl, ProcedureForDamageSwapText
	bank1call DrawWholeScreenTextBox
	xor a
	ldh [hEffectItemSelection], a
	bank1call Func_61a1

.start
	bank1call PrintPlayAreaCardList_EnableLCD
	push af
	ldh a, [hEffectItemSelection]
	ld hl, PlayAreaSelectionMenuParameters
	call InitializeMenuParameters
	pop af
	ld [wNumMenuItems], a

; handle selection of Pokemon to take damage from
.loop_input_first
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input_first
	cp $ff
	ret z ; quit when B button is pressed

	ldh [hTempPlayAreaLocation_ffa1], a
	ldh [hEffectItemSelection], a

; if card has no damage, play sfx and return to start
	call GetCardDamageAndMaxHP
	or a
	jr z, .no_damage

; take damage away temporarily to draw UI.
	ldh a, [hTempPlayAreaLocation_ffa1]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	push af
	push hl
	add 10
	ld [hl], a
	bank1call PrintPlayAreaCardList_EnableLCD
	pop hl
	pop af
	ld [hl], a

; draw damage counter in cursor
	ldh a, [hTempPlayAreaLocation_ffa1]
	ld b, SYM_HP_NOK
	call DrawSymbolOnPlayAreaCursor

; handle selection of Pokemon to give damage to
.loop_input_second
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input_second
	; if B is pressed, return damage counter
	; to card that it was taken from
	cp $ff
	jr z, .update_ui

; try to give the card selected the damage counter
; if it would KO, ignore it.
	ldh [hPkmnPowerPlayAreaTarget], a
	ldh [hEffectItemSelection], a
	call TryGiveDamageCounter_DamageSwap
	jr c, .loop_input_second

	ld a, OPPACTION_6B15
	call SetOppAction_SerialSendDuelData

.update_ui
	ldh a, [hTempPlayAreaLocation_ffa1]
	ld b, SYM_SPACE
	call DrawSymbolOnPlayAreaCursor
	call EraseCursor
	jr .start

.no_damage
	call Func_3794
	jr .loop_input_first
; 0x2dc27

; tries to give damage counter to hPkmnPowerPlayAreaTarget,
; and if successful updates UI screen.
DamageSwap_SwapEffect: ; 2dc27 (b:5c27)
	call TryGiveDamageCounter_DamageSwap
	ret c
	bank1call PrintPlayAreaCardList_EnableLCD
	or a
	ret
; 0x2dc30

; tries to give the damage counter to the target
; chosen by the Player (hPkmnPowerPlayAreaTarget).
; if the damage counter would KO card, then do
; not give the damage counter and return carry.
TryGiveDamageCounter_DamageSwap: ; 2dc30 (b:5c30)
	ldh a, [hPkmnPowerPlayAreaTarget]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	sub 10
	jr z, .set_carry ; would bring HP to zero?
; has enough HP to receive a damage counter
	ld [hl], a
	ldh a, [hTempPlayAreaLocation_ffa1]
	add DUELVARS_ARENA_CARD_HP
	ld l, a
	ld a, 10
	add [hl]
	ld [hl], a
	or a
	ret
.set_carry
	scf
	ret
; 0x2dc49

PsywaveEffect: ; 2dc49 (b:5c49)
	call GetEnergyAttachedMultiplierDamage
	ld hl, wDamage
	ld [hl], e
	inc hl
	ld [hl], d
	ret
; 0x2dc53

; returns carry if neither Duelist has evolved Pokemon.
DevolutionBeam_CheckPlayArea: ; 2dc53 (b:5c53)
	call CheckIfTurnDuelistHasEvolvedCards
	ret nc
	call SwapTurn
	call CheckIfTurnDuelistHasEvolvedCards
	call SwapTurn
	ldtx hl, ThereAreNoStage1PokemonText
	ret
; 0x2dc64

; returns carry of Player cancelled selection.
; otherwise, output in hTemp_ffa0 which Play Area
; was selected ($0 = own Play Area, $1 = opp. Play Area)
; and in hTempPlayAreaLocation_ffa1 selected card.
DevolutionBeam_PlayerSelectEffect: ; 2dc64 (b:5c64)
	ldtx hl, ProcedureForDevolutionBeamText
	bank1call DrawWholeScreenTextBox

.start
	bank1call DrawDuelMainScene
	ldtx hl, PleaseSelectThePlayAreaText
	call TwoItemHorizontalMenu
	ldh a, [hKeysHeld]
	and B_BUTTON
	jr nz, .set_carry

; a Play Area was selected
	ldh a, [hCurMenuItem]
	or a
	jr nz, .opp_chosen

; player chosen
	call HandleEvolvedCardSelection
	jr c, .start

	xor a
.store_selection
	ld hl, hTemp_ffa0
	ld [hli], a ; store which Duelist Play Area selected
	ldh a, [hTempPlayAreaLocation_ff9d]
	ld [hl], a ; store which card selected
	or a
	ret

.opp_chosen
	call SwapTurn
	call HandleEvolvedCardSelection
	call SwapTurn
	jr c, .start
	ld a, $01
	jr .store_selection

.set_carry
	scf
	ret
; 0x2dc9e

DevolutionBeam_AISelectEffect: ; 2dc9e (b:5c9e)
	ld a, $01
	ldh [hTemp_ffa0], a
	call SwapTurn
	call FindFirstNonBasicCardInPlayArea
	call SwapTurn
	jr c, .found
	xor a
	ldh [hTemp_ffa0], a
	call FindFirstNonBasicCardInPlayArea
.found
	ldh [hTempPlayAreaLocation_ffa1], a
	ret
; 0x2dcb6

DevolutionBeam_LoadAnimation: ; 2dcb6 (b:5cb6)
	xor a
	ld [wLoadedMoveAnimation], a
	ret
; 0x2dcbb

DevolutionBeam_DevolveEffect: ; 2dcbb (b:5cbb)
	ldh a, [hTemp_ffa0]
	or a
	jr z, .DevolvePokemon
	cp $ff
	ret z

; opponent's Play Area
	call SwapTurn
	ldh a, [hTempPlayAreaLocation_ffa1]
	jr nz, .skip_handle_no_damage_effect
	call HandleNoDamageOrEffect
	jr c, .unaffected
.skip_handle_no_damage_effect
	call .DevolvePokemon
.unaffected
	call SwapTurn
	ret

.DevolvePokemon
	ld a, $5d
	ld [wLoadedMoveAnimation], a
	ldh a, [hTempPlayAreaLocation_ffa1]
	ld b, a
	ld c, $00
	ldh a, [hWhoseTurn]
	ld h, a
	bank1call PlayMoveAnimation
	bank1call WaitMoveAnimation

; load selected card's data
	ldh a, [hTempPlayAreaLocation_ffa1]
	ldh [hTempPlayAreaLocation_ff9d], a
	ld [wTempPlayAreaLocation_cceb], a
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	call LoadCardDataToBuffer1_FromDeckIndex

; check if car is affected
	ld a, [wLoadedCard1ID]
	ld [wTempNonTurnDuelistCardID], a
	ld de, $0
	ldh a, [hTempPlayAreaLocation_ff9d]
	or a
	jr nz, .skip_substatus_check
	call HandleNoDamageOrEffectSubstatus
	jr c, .check_no_damage_effect
.skip_substatus_check
	call HandleDamageReductionOrNoDamageFromPkmnPowerEffects
.check_no_damage_effect
	call CheckNoDamageOrEffect
	jr nc, .devolve
	call DrawWideTextBox_WaitForInput
	ret

.devolve
	ldh a, [hTempPlayAreaLocation_ffa1]
	ldh [hTempPlayAreaLocation_ff9d], a
	add DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	bank1call GetCardOneStageBelow
	call PrintDevolvedCardNameAndLevelText

	ld a, d
	call UpdateDevolvedCardHPAndStage
	call ResetDevolvedCardStatus

; add the evolved card to the hand
	ld a, e
	call AddCardToHand

; check if this devolution KO's card
	ldh a, [hTempPlayAreaLocation_ffa1]
	call PrintPlayAreaCardKnockedOutIfNoHP

	xor a
	ld [wDuelDisplayedScreen], a
	ret
; 0x2dd3b

; returns carry if Turn Duelist
; has no Stage1 or Stage2 cards in Play Area.
CheckIfTurnDuelistHasEvolvedCards: ; 2dd3b (b:5d3b)
	ld a, DUELVARS_ARENA_CARD
	call GetTurnDuelistVariable
	ld d, h
	ld e, DUELVARS_ARENA_CARD_STAGE
.loop
	ld a, [hli]
	cp $ff
	jr z, .set_carry
	ld a, [de]
	inc de
	or a
	jr z, .loop ; is Basic Stage
	ret
.set_carry
	scf
	ret
; 0x2dd50

; handles Player selection of an evolved card in Play Area.
; returns carry if Player cancelled operation.
HandleEvolvedCardSelection: ; 2dd50 (b:5d50)
	bank1call HasAlivePokemonInPlayArea
.loop
	bank1call OpenPlayAreaScreenForSelection
	ret c
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_STAGE
	call GetTurnDuelistVariable
	or a
	jr z, .loop ; if Basic, loop
	ret
; 0x2dd62

; finds first occurence in Play Area
; of Stage 1 or 2 card, and outputs its
; Play Area location in a, with carry set.
; if none found, don't return carry set.
FindFirstNonBasicCardInPlayArea: ; 2dd62 (b:5d62)
	ld a, DUELVARS_NUMBER_OF_POKEMON_IN_PLAY_AREA
	call GetTurnDuelistVariable
	ld c, a

	ld b, PLAY_AREA_ARENA
	ld l, DUELVARS_ARENA_CARD_STAGE
.loop
	ld a, [hli]
	or a
	jr nz, .not_basic
	inc b
	dec c
	jr nz, .loop
	or a
	ret
.not_basic
	ld a, b
	scf
	ret
; 0x2dd79

NeutralizingShieldEffect: ; 2dd79 (b:5d79)
	scf
	ret
; 0x2dd7b

Psychic_AIEffect: ; 2dd7b (b:5d7b)
	call Psychic_DamageBoostEffect
	jp SetMinMaxDamageSameAsDamage
; 0x2dd81

Psychic_DamageBoostEffect: ; 2dd81 (b:5d81)
	call GetEnergyAttachedMultiplierDamage
	ld hl, wDamage
	ld a, e
	add [hl]
	ld [hli], a
	ld a, d
	adc [hl]
	ld [hl], a
	ret
; 0x2dd8e

; return carry if no Psychic Energy attached
Barrier_CheckEnergy: ; 2dd8e (b:5d8e)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + PSYCHIC]
	ldtx hl, NotEnoughPsychicEnergyText
	cp 1
	ret
; 0x2dd9c

Barrier_PlayerSelectEffect: ; 2dd9c (b:5d9c)
	ld a, TYPE_ENERGY_PSYCHIC
	call CreateListOfEnergyAttachedToArena
	xor a ; PLAY_AREA_ARENA
	bank1call DisplayEnergyDiscardScreen
	bank1call HandleEnergyDiscardMenuInput
	ret c
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	ret
; 0x2ddae

Barrier_AISelectEffect: ; 2ddae (b:5dae)
; AI picks the first energy in list
	ld a, TYPE_ENERGY_PSYCHIC
	call CreateListOfEnergyAttachedToArena
	ld a, [wDuelTempList]
	ldh [hTemp_ffa0], a
	ret
; 0x2ddb9

Barrier_DiscardEffect: ; 2ddb9 (b:5db9)
	ldh a, [hTemp_ffa0]
	call PutCardInDiscardPile
	ret
; 0x2ddbf

Barrier_BarrierEffect: ; 2ddbf (b:5dbf)
	ld a, SUBSTATUS1_BARRIER
	call ApplySubstatus1ToDefendingCard
	ret
; 0x2ddc5

Mewtwo3EnergyAbsorption_CheckDiscardPile: ; 2ddc5 (b:5dc5)
	call CreateEnergyCardListFromDiscardPile_OnlyBasic
	ldtx hl, ThereAreNoEnergyCardsInDiscardPileText
	ret
; 0x2ddcc

Mewtwo3EnergyAbsorption_PlayerSelectEffect: ; 2ddcc (b:5dcc)
	ldtx hl, Choose2EnergyCardsFromDiscardPileToAttachText
	call HandleEnergyCardsInDiscardPileSelection
	ret
; 0x2ddd3

Mewtwo3EnergyAbsorption_AISelectEffect: ; 2ddd3 (b:5dd3)
; AI picks first 2 energy cards
	call CreateEnergyCardListFromDiscardPile_OnlyBasic
	ld hl, wDuelTempList
	ld de, hTempCardList
	ld c, 2
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	ld [de], a
	inc de
	dec c
	jr nz, .loop
.done
	ld a, $ff ; terminating byte
	ld [de], a
	ret
; 0x2ddec

Mewtwo3EnergyAbsorption_AddToHandEffect: ; 2ddec (b:5dec)
	ld hl, hTempCardList
.loop
	ld a, [hli]
	cp $ff
	ret z
	push hl
	call MoveDiscardPileCardToHand
	call GetTurnDuelistVariable
	ld [hl], CARD_LOCATION_ARENA
	pop hl
	jr .loop
; 0x2ddff

Mewtwo2EnergyAbsorption_CheckDiscardPile: ; 2ddff (b:5dff)
	call CreateEnergyCardListFromDiscardPile_OnlyBasic
	ldtx hl, ThereAreNoEnergyCardsInDiscardPileText
	ret
; 0x2de06

Mewtwo2EnergyAbsorption_PlayerSelectEffect: ; 2de06 (b:5e06)
	ldtx hl, Choose2EnergyCardsFromDiscardPileToAttachText
	call HandleEnergyCardsInDiscardPileSelection
	ret
; 0x2de0d

Mewtwo2EnergyAbsorption_AISelectEffect: ; 2de0d (b:5e0d)
; AI picks first 2 energy cards
	call CreateEnergyCardListFromDiscardPile_OnlyBasic
	ld hl, wDuelTempList
	ld de, hTempCardList
	ld c, 2
.loop
	ld a, [hli]
	cp $ff
	jr z, .done
	ld [de], a
	inc de
	dec c
	jr nz, .loop
.done
	ld a, $ff ; terminating byte
	ld [de], a
	ret
; 0x2de26

Mewtwo2EnergyAbsorption_AddToHandEffect: ; 2de26 (b:5e26)
	ld hl, hTempCardList
.loop
	ld a, [hli]
	cp $ff
	ret z
	push hl
	call MoveDiscardPileCardToHand
	call GetTurnDuelistVariable
	ld [hl], CARD_LOCATION_ARENA
	pop hl
	jr .loop
; 0x2de39

; returns carry if Strange Behavior cannot be used.
StrangeBehavior_CheckDamage: ; 2de39 (b:5e39)
; does Play Area have any damage counters?
	ldh a, [hTempPlayAreaLocation_ff9d]
	ldh [hTemp_ffa0], a
	call CheckIfPlayAreaHasAnyDamage
	ldtx hl, NoPokemonWithDamageCountersText
	jr c, .set_carry
; can Slowbro receive any damage counters without KOing?
	ldh a, [hTempPlayAreaLocation_ff9d]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	ldtx hl, CannotUseBecauseItWillBeKnockedOutText
	cp 10 + 10
	jr c, .set_carry
; can Pkmn Power be used?
	ldh a, [hTempPlayAreaLocation_ff9d]
	call CheckCannotUseDueToStatus_OnlyToxicGasIfANon0
	ret

.set_carry
	scf
	ret
; 0x2de5b

StrangeBehavior_SelectAndSwapEffect: ; 2de5b (b:5e5b)
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	cp DUELIST_TYPE_PLAYER
	jr z, .player

; not player
	bank1call Func_61a1
	bank1call PrintPlayAreaCardList_EnableLCD
	ret

.player
	ldtx hl, ProcedureForStrangeBehaviorText
	bank1call DrawWholeScreenTextBox

	xor a
	ldh [hEffectItemSelection], a
	bank1call Func_61a1
.start
	bank1call PrintPlayAreaCardList_EnableLCD
	push af
	ldh a, [hEffectItemSelection]
	ld hl, PlayAreaSelectionMenuParameters
	call InitializeMenuParameters
	pop af

	ld [wNumMenuItems], a
.loop_input
	call DoFrame
	call HandleMenuInput
	jr nc, .loop_input
	cp -1
	ret z ; return when B button is pressed

	ldh [hEffectItemSelection], a
	ldh [hTempPlayAreaLocation_ffa1], a
	ld hl, hTemp_ffa0
	cp [hl]
	jr z, .play_sfx ; can't select Slowbro itself

	call GetCardDamageAndMaxHP
	or a
	jr z, .play_sfx ; can't select card without damage

	call TryGiveDamageCounter_StrangeBehavior
	jr c, .play_sfx
	ld a, OPPACTION_6B15
	call SetOppAction_SerialSendDuelData
	jr .start

.play_sfx
	call Func_3794
	jr .loop_input
; 0x2deb3

StrangeBehavior_SwapEffect: ; 2deb3 (b:5eb3)
	call TryGiveDamageCounter_StrangeBehavior
	ret c
	bank1call PrintPlayAreaCardList_EnableLCD
	or a
	ret
; 0x2debc

; tries to give the damage counter to the target
; chosen by the Player (hTemp_ffa0).
; if the damage counter would KO card, then do
; not give the damage counter and return carry.
TryGiveDamageCounter_StrangeBehavior: ; 2debc (b:5ebc)
	ldh a, [hTemp_ffa0]
	add DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	sub 10
	jr z, .set_carry  ; would bring HP to zero?
; has enough HP to receive a damage counter
	ld [hl], a
	ldh a, [hTempPlayAreaLocation_ffa1]
	add DUELVARS_ARENA_CARD_HP
	ld l, a
	ld a, 10
	add [hl]
	ld [hl], a
	or a
	ret
.set_carry
	scf
	ret
; 0x2ded5

; returns carry if has no damage counters.
SpacingOut_CheckDamage: ; 2ded5 (b:5ed5)
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	ldtx hl, NoDamageCountersText
	cp 10
	ret
; 0x2dee0

SpacingOut_Failure50PercentEffect: ; 2dee0 (b:5ee0)
	ldtx de, SuccessCheckIfHeadsAttackIsSuccessfulText
	call TossCoin_BankB
	ldh [hTemp_ffa0], a
	jp nc, SetWasUnsuccessful
	ld a, $58
	ld [wLoadedMoveAnimation], a
	ret
; 0x2def1

SpacingOut_HealEffect: ; 2def1 (b:5ef1)
	ldh a, [hTemp_ffa0]
	or a
	ret z ; coin toss was tails
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	or a
	ret z ; no damage counters
	ld a, DUELVARS_ARENA_CARD_HP
	call GetTurnDuelistVariable
	add 10
	ld [hl], a
	ret
; 0x2df05

; sets carry if no Trainer cards in the Discard Pile.
Scavenge_CheckDiscardPile: ; 2df05 (b:5f05)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + PSYCHIC]
	ldtx hl, NotEnoughPsychicEnergyText
	cp 1
	ret c ; return if no Psychic energy attached
	call CreateTrainerCardListFromDiscardPile
	ldtx hl, ThereAreNoTrainerCardsInDiscardPileText ; this is redundant
	ret
; 0x2df1a

Scavenge_PlayerSelectEnergyEffect: ; 2df1a (b:5f1a)
	ld a, TYPE_ENERGY_PSYCHIC
	call CreateListOfEnergyAttachedToArena
	xor a ; PLAY_AREA_ARENA
	bank1call DisplayEnergyDiscardScreen
	bank1call HandleEnergyDiscardMenuInput
	ret c
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a
	or a
	ret
; 0x2df2d

Scavenge_AISelectEffect: ; 2df2d (b:5f2d)
; AI picks first Energy card in list
	ld a, TYPE_ENERGY_PSYCHIC
	call CreateListOfEnergyAttachedToArena
	ld a, [wDuelTempList]
	ldh [hTemp_ffa0], a
; AI picks first Trainer card in list
	call CreateTrainerCardListFromDiscardPile
	ld a, [wDuelTempList]
	ldh [hTempPlayAreaLocation_ffa1], a
	ret
; 0x2df40

Scavenge_DiscardEffect: ; 2df40 (b:5f40)
	ldh a, [hTemp_ffa0]
	call PutCardInDiscardPile
	ret
; 0x2df46

Scavenge_PlayerSelectTrainerEffect: ; 2df46 (b:5f46)
	call CreateTrainerCardListFromDiscardPile
	bank1call Func_5591
	ldtx hl, PleaseSelectCardText
	ldtx de, PlayerDiscardPileText
	bank1call SetCardListHeaderText
.loop_input
	bank1call DisplayCardList
	jr c, .loop_input
	ldh a, [hTempCardIndex_ff98]
	ldh [hTempPlayAreaLocation_ffa1], a
	ret
; 0x2df5f

Scavenge_AddToHandEffect: ; 2df5f (b:5f5f)
	ldh a, [hTempPlayAreaLocation_ffa1]
	call MoveDiscardPileCardToHand
	call AddCardToHand
	call CheckIfTurnDuelistIsPlayer
	ret c
	ldh a, [hTempPlayAreaLocation_ffa1]
	ldtx hl, WasPlacedInTheHandText
	bank1call DisplayCardDetailScreen
	ret
; 0x2df74

; returns carry if Defending Pokemon has no attacks
SlowpokeAmnesia_CheckAttacks: ; 2df74 (b:5f74)
	call CheckIfDefendingPokemonHasAnyAttack
	ldtx hl, NoAttackMayBeChoosenText
	ret
; 0x2df7b

SlowpokeAmnesia_PlayerSelectEffect: ; 2df7b (b:5f7b)
	call PlayerPickAttackForAmnesia
	ret
; 0x2df7f

SlowpokeAmnesia_AISelectEffect: ; 2df7f (b:5f7f)
	call AIPickAttackForAmnesia
	ldh [hTemp_ffa0], a
	ret
; 0x2df85

SlowpokeAmnesia_DisableEffect: ; 2df85 (b:5f85)
	call ApplyAmnesiaToAttack
	ret
; 0x2df89

; returns carry if Arena card has no Psychic Energy attached
; or if it doesn't have any damage counters.
KadabraRecover_CheckEnergyHP: ; 2df89 (b:5f89)
	ld e, PLAY_AREA_ARENA
	call GetPlayAreaCardAttachedEnergies
	ld a, [wAttachedEnergies + PSYCHIC]
	ldtx hl, NotEnoughPsychicEnergyText
	cp 1
	ret c ; return if not enough energy
	call GetCardDamageAndMaxHP
	ldtx hl, NoDamageCountersText
	cp 10
	ret ; return carry if no damage
; 0x2dfa0

KadabraRecover_PlayerSelectEffect: ; 2dfa0 (b:5fa0)
	ld a, TYPE_ENERGY_PSYCHIC
	call CreateListOfEnergyAttachedToArena
	xor a ; PLAY_AREA_ARENA
	bank1call DisplayEnergyDiscardScreen
	bank1call HandleEnergyDiscardMenuInput
	ret c
	ldh a, [hTempCardIndex_ff98]
	ldh [hTemp_ffa0], a ; store card chosen
	ret
; 0x2dfb2

KadabraRecover_AISelectEffect: ; 2dfb2 (b:5fb2)
	ld a, TYPE_ENERGY_PSYCHIC
	call CreateListOfEnergyAttachedToArena
	ld a, [wDuelTempList] ; pick first card
	ldh [hTemp_ffa0], a
	ret
; 0x2dfbd

KadabraRecover_DiscardEffect: ; 2dfbd (b:5fbd)
	ldh a, [hTemp_ffa0]
	call PutCardInDiscardPile
	ret
; 0x2dfc3

KadabraRecover_HPRecoveryEffect: ; 2dfc3 (b:5fc3)
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	ld e, a ; all damage for recovery
	ld d, 0
	call ApplyAndAnimateHPRecovery
	ret
; 0x2dfd7

JynxDoubleslap_AIEffect: ; 2dfd7 (b:5fd7)
	ld a, 20 / 2
	lb de, 0, 20
	jp StoreAIDamageInfo
; 0x2dfcf

JynxDoubleslap_MultiplierEffect: ; 2dfcf (b:5fcf)
	ld hl, 10
	call LoadTxRam3
	ldtx de, DamageCheckIfHeadsXDamageText
	ld a, 2
	call TossCoinATimes_BankB
	call ATimes10
	call StoreDamageInfo
	ret
; 0x2dff2

JynxMeditate_AIEffect: ; 2dff2 (b:5ff2)
	call JynxMeditate_DamageBoostEffect
	jp SetMinMaxDamageSameAsDamage
; 0x2dfec

JynxMeditate_DamageBoostEffect: ; 2dfec (b:5fec)
; add damage counters of Defending card to damage
	call SwapTurn
	ld e, PLAY_AREA_ARENA
	call GetCardDamageAndMaxHP
	call SwapTurn
	call AddToDamage
	ret
; 0x2e001

MysteryAttack_AIEffect: ; 2e001 (b:6001)
	ld a, 10
	lb de, 0, 20
	jp StoreAIDamageInfo
; 0x2e009

MysteryAttack_RandomEffect: ; 2e009 (b:6009)
	ld a, 10
	call StoreDamageInfo

; chooses a random effect from 8 possible options.
	call UpdateRNGSources
	and %111
	ldh [hTemp_ffa0], a
	ld hl, .random_effect
	jp JumpToFunctionInTable

.random_effect
	dw ParalysisEffect
	dw PoisonEffect
	dw SleepEffect
	dw ConfusionEffect
	dw .no_effect ; this will actually activate recovery effect afterwards
	dw .no_effect
	dw .more_damage
	dw .no_damage

.more_damage
	ld a, 20
	call StoreDamageInfo
	ret

.no_damage
	ld a, $5b
	ld [wLoadedMoveAnimation], a
	xor a
	call StoreDamageInfo
	call SetNoEffectFromStatus
.no_effect
	ret
; 0x2e03e

MysteryAttack_RecoverEffect: ; 2e03e (b:603e)
; in case the 5th option was chosen for random effect,
; trigger recovery effect for 10 HP.
	ldh a, [hTemp_ffa0]
	cp 4
	ret nz
	lb de, 0, 10
	call ApplyAndAnimateHPRecovery
	ret
; 0x2e04a

	INCROM $2e04a, $30000
