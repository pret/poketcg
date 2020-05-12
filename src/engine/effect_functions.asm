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
	lb bc, PSN_DBLPSN, PARALYZED
	jr ApplyStatusEffect

Confusion50PercentEffect: ; 2c01d (b:401d)
	ldtx de, ConfusionCheckText
	call TossCoin_BankB
	ret nc

ConfusionEffect: ; 2c024 (b:4024)
	lb bc, PSN_DBLPSN, CONFUSED
	jr ApplyStatusEffect

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

	INCROM $2c174, $2c1ec

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
	call .HandleNoDamageOrEffect
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
.HandleNoDamageOrEffect: ; 2c216 (b:4216)
	call CheckNoDamageOrEffect
	ret nc
	ld a, l
	or h
	call nz, DrawWideTextBox_PrintText
	scf
	ret
; 0x2c221

; applies HP recovery on Pokemon after HP drain attack
; and handles its animation.
; input:
;	d = damage effectiveness
;	e = HP amount to recover
ApplyAndAnimateHPDrain: ; 2c221 (b:4221)
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

	INCROM $2c25b, $2c2a4

; makes a list in wDuelTempList with the deck indices
; of all the energy cards found in opponent's Discard Pile.
; if (c == 0), all energy cards are allowed;
; if (c != 0), double colorless energy cards are not counted.
; returns carry if no energy cards were found.
CreateEnergyCardListFromOpponentDiscardPile: ; 2c2a4 (b:42a4)
	ld c, $00

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

	INCROM $2c391, $2c487

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

	INCROM $2c4da, $2c564

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
	ld a, 5
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

; outputs in hTemp_ffa0 the result of the coin toss
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
	ldtx hl, LureNoPokemonOnTheBenchText
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
	call ApplyAndAnimateHPDrain
	ret
; 0x2c7c6

VenonatLeechLifeEffect: ; 2c7c6 (b:47c6)
	ld hl, wDealtDamage
	ld e, [hl]
	inc hl ; wDamageEffectiveness
	ld d, [hl]
	call ApplyAndAnimateHPDrain
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
	call ApplyAndAnimateHPDrain
	ret
; 0x2c7ed

Twineedle_AIEffect: ; 2c7ed (b:47ed)
	ld a, 30
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
	call ApplyAndAnimateHPDrain
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
	ld a, 35
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
	call Func_1955
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
	ld a, 15
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
	ld a, 15
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
	ld a, 30
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
	ld a, 30
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
	call ApplyAndAnimateHPDrain
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
	call ApplyAndAnimateHPDrain
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
	bank1call Func_57df
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
	ldh [hCurPlayAreaItem], a
	bank1call Func_61a1

.draw_play_area
	bank1call PrintPlayAreaCardList_EnableLCD
	push af
	ldh a, [hCurPlayAreaItem]
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
	ldh [hTempPlayAreaLocation_ffa1], a
	ldh [hCurPlayAreaItem], a
	call CheckIfCardHasGrassEnergyAttached
	jr c, .play_sfx ; no Grass attached

	ldh [hAIEnergyTransEnergyCard], a
	ldh a, [hAIEnergyTransEnergyCard] ; useless
	; temporarily take card away to draw Play Area
	call AddCardToHand
	bank1call PrintPlayAreaCardList_EnableLCD
	ldh a, [hTempPlayAreaLocation_ffa1]
	ld e, a
	ldh a, [hAIEnergyTransEnergyCard]
	; give card back
	call PutHandCardInPlayArea

	; draw Grass symbol near cursor
	ldh a, [hTempPlayAreaLocation_ffa1]
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
	ldh [hCurPlayAreaItem], a
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
	ldh a, [hTempPlayAreaLocation_ffa1]
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

; returns carry if no cards in Deck or if
; Play Area is full already.
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
	call Func_1955
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

	INCROM $2cd84, $2f4e1
	
ImposterProfessorOakEffect: ; 2f4e1 (b:74e1)
        call SwapTurn
        call CreateHandCardList
        call SortCardsInDuelTempListByID
        ld hl, wDuelTempList
.return_hand_to_deck_loop
        ld a, [hli]
        cp $ff
        jr z, .shuffle
        call RemoveCardFromHand
        call ReturnCardToDeck
        jr .return_hand_to_deck_loop
.shuffle
        call Func_2c0bd
        ld a, $07
        bank1call $4935
        ld c, $07
.draw_loop
        call DrawCardFromDeck
        jr c, .revert_turn_to_user
        call AddCardToHand
        dec c
        jr nz, .draw_loop
.revert_turn_to_user
        call SwapTurn
        ret
; 0x2f513

	INCROM $2f513, $30000

