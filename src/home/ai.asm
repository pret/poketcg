; loads opponent deck at wOpponentDeckID to wOpponentDeck, and initializes wPlayerDuelistType.
; on a duel against Sam, also loads PRACTICE_PLAYER_DECK to wPlayerDeck.
; also, sets wRNG1, wRNG2, and wRNGCounter to $57.
LoadOpponentDeck::
	xor a
	ld [wIsPracticeDuel], a
	ld a, [wOpponentDeckID]
	cp SAMS_NORMAL_DECK_ID
	jr z, .normal_sam_duel
	or a ; cp SAMS_PRACTICE_DECK_ID
	jr nz, .not_practice_duel
; only practice duels will display help messages, but
; any duel with Sam will force the PRACTICE_PLAYER_DECK
;.practice_sam_duel
	inc a
	ld [wIsPracticeDuel], a
.normal_sam_duel
	xor a
	ld [wOpponentDeckID], a
	call SwapTurn
	ld a, PRACTICE_PLAYER_DECK
	call LoadDeck
	call SwapTurn
	ld hl, wRNG1
	ld a, $57
	ld [hli], a
	ld [hli], a
	ld [hl], a
	xor a
.not_practice_duel
	inc a
	inc a ; convert from *_DECK_ID constant read from wOpponentDeckID to *_DECK constant
	call LoadDeck
	ld a, [wOpponentDeckID]
	cp NUM_DECK_IDS + 1
	jr c, .valid_deck
	ld a, PRACTICE_PLAYER_DECK_ID
	ld [wOpponentDeckID], a
.valid_deck
; set opponent as controlled by AI
	ld a, DUELVARS_DUELIST_TYPE
	call GetTurnDuelistVariable
	ld a, [wOpponentDeckID]
	or DUELIST_TYPE_AI_OPP
	ld [hl], a
	ret

AIDoAction_Turn::
	ld a, AIACTION_DO_TURN
	jr AIDoAction

AIDoAction_StartDuel::
	ld a, AIACTION_START_DUEL
	jr AIDoAction

AIDoAction_ForcedSwitch::
	ld a, AIACTION_FORCED_SWITCH
	call AIDoAction
	ldh [hTempPlayAreaLocation_ff9d], a
	ret

AIDoAction_KOSwitch::
	ld a, AIACTION_KO_SWITCH
	call AIDoAction
	ldh [hTemp_ffa0], a
	ret

AIDoAction_TakePrize::
	ld a, AIACTION_TAKE_PRIZE
	jr AIDoAction ; this line is not needed

; calls the appropriate AI routine to handle action,
; depending on the deck ID (see engine/duel/ai/deck_ai.asm)
; input:
;	- a = AIACTION_* constant
AIDoAction::
	ld c, a

; load bank for Opponent Deck pointer table
	ldh a, [hBankROM]
	push af
	ld a, BANK(DeckAIPointerTable)
	call BankswitchROM

; load hl with the corresponding pointer
	ld a, [wOpponentDeckID]
	ld l, a
	ld h, $0
	add hl, hl ; two bytes per deck
	ld de, DeckAIPointerTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, c
	or a
	jr nz, .not_zero

; if input was 0, copy deck data of turn player
	ld e, [hl]
	inc hl
	ld d, [hl]
	call CopyDeckData
	jr .done

; jump to corresponding AI routine related to input
.not_zero
	call JumpToFunctionInTable

.done
	ld c, a
	pop af
	call BankswitchROM
	ld a, c
	ret
