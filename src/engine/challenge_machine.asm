ChallengeMachine_Reset:
	call ChallengeMachine_Initialize
	call EnableSRAM
	xor a
	ld [sTotalChallengeMachineWins], a
	ld [sTotalChallengeMachineWins + 1], a
	ld [sPresentConsecutiveWins], a
	ld [sPresentConsecutiveWins + 1], a
	ld [sPresentConsecutiveWinsBackup], a
	ld [sPresentConsecutiveWinsBackup + 1], a
	ld [sPlayerInChallengeMachine], a
	call DisableSRAM
	ret

; if a challenge is already in progress, then resume
; otherwise, start a new 5 round challenge
ChallengeMachine_Start::
	ld a, DOUBLE_SPACED
	ld [wLineSeparation], a
	call LoadConsolePaletteData
	call ChallengeMachine_Initialize

	call EnableSRAM
	ld a, [sPlayerInChallengeMachine]
	call DisableSRAM
	cp $ff
	jr z, .resume_challenge

; new challenge
	call ChallengeMachine_PickOpponentSequence
	call ChallengeMachine_DrawScoreScreen
	call FlashWhiteScreen
	ldtx hl, PlayTheChallengeMachineText
	call YesOrNoMenuWithText_SetCursorToYes
	jp c, .end_challenge

	ldtx hl, LetUsChooseYourOpponentText
	call PrintScrollableText_NoTextBoxLabel
	call FadeScreenToWhite
	call EnableSRAM
	xor a
	ld [sPresentConsecutiveWinsBackup], a
	ld [sPresentConsecutiveWinsBackup + 1], a
	call DisableSRAM

	call ChallengeMachine_DrawOpponentList
	call FlashWhiteScreen
	ldtx hl, YourOpponentsForThisGameText
	call PrintScrollableText_NoTextBoxLabel
; begin challenge loop
.next_opponent
	call ChallengeMachine_GetCurrentOpponent
	call ChallengeMachine_AreYouReady
	jr nc, .start_duel
	ldtx hl, IfYouQuitTheDuelText
	call PrintScrollableText_NoTextBoxLabel
	ldtx hl, WouldYouLikeToQuitTheDuelText
	call YesOrNoMenuWithText
	jr c, .next_opponent
	jp .quit

.start_duel
	call EnableSRAM
	ld a, $ff
	ld [sPlayerInChallengeMachine], a
	call DisableSRAM
	call ChallengeMachine_Duel
.resume_challenge
	call EnableSRAM
	xor a
	ld [sPlayerInChallengeMachine], a
	bank1call DiscardSavedDuelData
	call DisableSRAM
	call ChallengeMachine_GetCurrentOpponent
	call ChallengeMachine_RecordDuelResult
	call ChallengeMachine_DrawOpponentList
	call FlashWhiteScreen
	ld a, [wDuelResult]
	or a
	jr nz, .lost
; won
	call ChallengeMachine_DuelWon
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	cp NUM_CHALLENGE_MACHINE_OPPONENTS - 1
	jr z, .defeated_five_opponents
	ld hl, sChallengeMachineOpponentNumber
	inc [hl]
	call DisableSRAM
	jr .next_opponent

.defeated_five_opponents
	ld hl, sTotalChallengeMachineWins
	call ChallengeMachine_IncrementHLMax999
	call FadeScreenToWhite
	call ChallengeMachine_CheckForNewRecord
	call ChallengeMachine_DrawScoreScreen
	call FlashWhiteScreen
	call EnableSRAM
	ld a, [sTotalChallengeMachineWins]
	ld [wTxRam3], a
	ld a, [sTotalChallengeMachineWins + 1]
	ld [wTxRam3 + 1], a
	call DisableSRAM
	ldtx hl, SuccessfullyDefeated5OpponentsText
	call PrintScrollableText_NoTextBoxLabel
	jr .end_challenge

.lost
	call ChallengeMachine_GetCurrentOpponent
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	inc a
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	call DisableSRAM
	call ChallengeMachine_GetOpponentNameAndDeck
	ld a, [wOpponentName]
	ld [wTxRam2], a
	ld a, [wOpponentName + 1]
	ld [wTxRam2 + 1], a
	ldtx hl, LostToTheNthOpponentText
	call PrintScrollableText_NoTextBoxLabel
.quit
	call ChallengeMachine_PrintFinalConsecutiveWinStreak
	call FadeScreenToWhite
	call ChallengeMachine_CheckForNewRecord
	call ChallengeMachine_DrawScoreScreen
	call FlashWhiteScreen
	call EnableSRAM
; reset streak
	xor a
	ld [sPresentConsecutiveWins], a
	ld [sPresentConsecutiveWins + 1], a
	call DisableSRAM
.end_challenge ; end, win or lose
	call ChallengeMachine_CheckForNewRecord ; redundant?
	call EnableSRAM
	ld a, [sPresentConsecutiveWins]
	ld [sPresentConsecutiveWinsBackup], a
	ld a, [sPresentConsecutiveWins + 1]
	ld [sPresentConsecutiveWinsBackup + 1], a
	call ChallengeMachine_ShowNewRecord
	call DisableSRAM
	ldtx hl, WeAwaitYourNextChallengeText
	call PrintScrollableText_NoTextBoxLabel
	ret

; update wChallengeMachineOpponent with the current
; opponent in the sChallengeMachineOpponents list
ChallengeMachine_GetCurrentOpponent:
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	ld e, a
	ld d, 0
	ld hl, sChallengeMachineOpponents
	add hl, de
	ld a, [hl]
	ld [wChallengeMachineOpponent], a
	call DisableSRAM
	ret

; play the appropriate match start theme
; then duel the current opponent
ChallengeMachine_Duel:
	call ChallengeMachine_PrepareDuel
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	ld e, a
	call DisableSRAM
	ld d, 0
	ld hl, ChallengeMachine_SongIDs
	add hl, de
	ld a, [hl]
	call PlaySong
	call WaitForSongToFinish
	xor a
	ld [wSongOverride], a
	call SaveGeneralSaveData
	bank1call StartDuel_VSAIOpp
	ret

ChallengeMachine_SongIDs:
	db MUSIC_MATCH_START_1
	db MUSIC_MATCH_START_1
	db MUSIC_MATCH_START_1
	db MUSIC_MATCH_START_2
	db MUSIC_MATCH_START_2

; get the current opponent's name, deck, and prize count
ChallengeMachine_PrepareDuel:
	call ChallengeMachine_GetOpponentNameAndDeck
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	ld e, a
	call DisableSRAM
	ld d, 0
	ld hl, ChallengeMachine_Prizes
	add hl, de
	ld a, [hl]
	ld [wNPCDuelPrizes], a
	ret

ChallengeMachine_Prizes:
	db PRIZES_4
	db PRIZES_4
	db PRIZES_4
	db PRIZES_6
	db PRIZES_6

; store the result of the last duel in the current
; position of the sChallengeMachineDuelResults list
ChallengeMachine_RecordDuelResult:
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	ld e, a
	ld d, 0
	ld hl, sChallengeMachineDuelResults
	add hl, de
	ld a, [wDuelResult]
	or a
	jr nz, .lost
	ld a, 1 ; won
	ld [hl], a
	call DisableSRAM
	ld hl, sPresentConsecutiveWins
	call ChallengeMachine_IncrementHLMax999
	ret

.lost
	ld a, 2 ; lost
	ld [hl], a
	call DisableSRAM
	ret

; increment the value at hl
; without going above 999
ChallengeMachine_IncrementHLMax999:
	call EnableSRAM
	inc hl
	ld a, [hld]
	cp HIGH(999)
	jr nz, .increment
	ld a, [hl]
	cp LOW(999)
	jr z, .skip
.increment
	ld a, [hl]
	add 1
	ld [hli], a
	ld a, [hl]
	adc 0
	ld [hl], a
.skip
	call DisableSRAM
	ret

; update sMaximumConsecutiveWins if the player set a new record
ChallengeMachine_CheckForNewRecord:
	call EnableSRAM
	ld hl, sMaximumConsecutiveWins + 1
	ld a, [sPresentConsecutiveWins + 1]
	cp [hl]
	jr nz, .high_bytes_different
; high bytes equal, check low bytes
	dec hl
	ld a, [sPresentConsecutiveWins]
	cp [hl]
.high_bytes_different
	jr c, .no_record
	jr z, .no_record
; new record
	ld hl, sMaximumConsecutiveWins
	ld a, [sPresentConsecutiveWins]
	ld [hli], a
	ld a, [sPresentConsecutiveWins + 1]
	ld [hl], a
	ld hl, sPlayerName
	ld de, sChallengeMachineRecordHolderName
	ld bc, NAME_BUFFER_LENGTH
	call CopyDataHLtoDE_SaveRegisters
; remember to show congrats message later
	ld a, TRUE
	ld [sConsecutiveWinRecordIncreased], a
.no_record
	call DisableSRAM
	ret

; print the next opponent's name and ask the
; player if they want to begin the next duel
ChallengeMachine_AreYouReady:
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	inc a
	ld [wTxRam3], a
	ld [wTxRam3_b], a
	xor a
	ld [wTxRam3 + 1], a
	ld [wTxRam3_b + 1], a
	ldtx hl, NthOpponentIsText
	ld a, [sPresentConsecutiveWins + 1]
	or a
	jr nz, .streak
	ld a, [sPresentConsecutiveWins]
	cp 2
	jr c, .no_streak
.streak
	ldtx hl, XConsecutiveWinsNthOpponentIsText
	ld a, [sPresentConsecutiveWins]
	ld [wTxRam3], a
	ld a, [sPresentConsecutiveWins + 1]
	ld [wTxRam3 + 1], a
.no_streak
	call DisableSRAM
	push hl ; text id
	call ChallengeMachine_GetOpponentNameAndDeck
	ld a, [wOpponentName]
	ld [wTxRam2], a
	ld a, [wOpponentName + 1]
	ld [wTxRam2 + 1], a
	pop hl ; text id
	call PrintScrollableText_NoTextBoxLabel
	ldtx hl, WouldYouLikeToBeginTheDuelText
	call YesOrNoMenuWithText_SetCursorToYes
	ret

; print opponent win count
; play a jingle for beating 5 opponents
ChallengeMachine_DuelWon:
	call EnableSRAM
	ld a, [sChallengeMachineOpponentNumber]
	inc a
	ld [wTxRam3], a
	xor a
	ld [wTxRam3 + 1], a
	ldtx hl, WonAgainstXOpponentsText
	ld a, [sChallengeMachineOpponentNumber]
	call DisableSRAM
	cp NUM_CHALLENGE_MACHINE_OPPONENTS - 1
	jr z, .beat_five_opponents
	call PrintScrollableText_NoTextBoxLabel
	ret

.beat_five_opponents
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ldtx hl, Defeated5OpponentsText
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	ret

; when a player's streak ends, print the final
; consecutive win count
ChallengeMachine_PrintFinalConsecutiveWinStreak:
	call EnableSRAM
	ld a, [sPresentConsecutiveWins]
	ld [wTxRam3], a
	ld a, [sPresentConsecutiveWins + 1]
	ld [wTxRam3 + 1], a
	or a
	jr nz, .streak
	ld a, [sPresentConsecutiveWins]
	cp 2
	jr c, .no_streak
.streak
	ldtx hl, ConsecutiveWinsEndedAtText
	call PrintScrollableText_NoTextBoxLabel
.no_streak
	call DisableSRAM
	ret

; if the player achieved a new record, play a jingle
; otherwise, do nothing
ChallengeMachine_ShowNewRecord:
	call EnableSRAM
	ld a, [sConsecutiveWinRecordIncreased]
	or a
	ret z ; no new record
	ld a, [sMaximumConsecutiveWins]
	ld [wTxRam3], a
	ld a, [sMaximumConsecutiveWins + 1]
	ld [wTxRam3 + 1], a
	call DisableSRAM
	call PauseSong
	ld a, MUSIC_MEDAL
	call PlaySong
	ldtx hl, ConsecutiveWinRecordIncreasedText
	call PrintScrollableText_NoTextBoxLabel
	call WaitForSongToFinish
	call ResumeSong
	ret

ChallengeMachine_DrawScoreScreen:
	call InitMenuScreen
	lb de, $30, $bf
	call SetupText
	lb de,  0,  0
	lb bc, 20, 13
	call DrawRegularTextBox
	lb de,  0, 12
	lb bc, 20,  6
	call DrawRegularTextBox
	call EnableSRAM
	ld hl, sChallengeMachineRecordHolderName
	ld de, wDefaultText
	ld bc, NAME_BUFFER_LENGTH
	call CopyDataHLtoDE
	call DisableSRAM
	xor a
	ld [wTxRam2], a
	ld [wTxRam2 + 1], a
	ld hl, ChallengeMachine_PlayerScoreLabels
	call PrintLabels
	ld hl, ChallengeMachine_PlayerScoreValues
	call ChallengeMachine_PrintScores
	ret

ChallengeMachine_PlayerScoreLabels:
	db 1, 0
	tx ChallengeMachineText

	db 1, 2
	tx PlayersScoreText

	db 2, 4
	tx Defeated5OpponentsXTimesText

	db 2, 6
	tx PresentConsecutiveWinsText

	db 1, 8
	tx MaximumConsecutiveWinsText

	db 17, 6
	tx WinsText

	db 16, 10
	tx WinsText
	db $ff

ChallengeMachine_PlayerScoreValues:
	dw sTotalChallengeMachineWins
	db 12, 4

	dw sPresentConsecutiveWins
	db 14, 6

	dw sMaximumConsecutiveWins
	db 13, 10

	dw NULL

ChallengeMachine_DrawOpponentList:
	call InitMenuScreen
	lb de, $30, $bf
	call SetupText
	lb de,  0,  0
	lb bc, 20, 13
	call DrawRegularTextBox
	lb de,  0, 12
	lb bc, 20,  6
	call DrawRegularTextBox
	ld hl, ChallengeMachine_OpponentNumberLabels
	call PrintLabels
	call ChallengeMachine_PrintOpponentInfo
	call ChallengeMachine_PrintDuelResultIcons
	ret

ChallengeMachine_OpponentNumberLabels:
	db 1, 0
	tx ChallengeMachineText

	db 2, 2
	tx ChallengeMachineOpponent1Text

	db 2, 4
	tx ChallengeMachineOpponent2Text

	db 2, 6
	tx ChallengeMachineOpponent3Text

	db 2, 8
	tx ChallengeMachineOpponent4Text

	db 2, 10
	tx ChallengeMachineOpponent5Text
	db $ff

ChallengeMachine_PrintOpponentInfo:
	ld hl, sChallengeMachineOpponents
	ld bc, 2 ; beginning y-pos
	ld e, NUM_CHALLENGE_MACHINE_OPPONENTS
.loop
	push hl
	push bc
	push de
	call EnableSRAM
	ld a, [hl]
	ld [wChallengeMachineOpponent], a
	ld b, 14 ; x-pos
	call ChallengeMachine_PrintOpponentName
	ld b, 4 ; x-pos
	call ChallengeMachine_PrintOpponentClubStatus
	pop de
	pop bc
	pop hl
	inc hl

; down two rows
	inc c
	inc c

	dec e
	jr nz, .loop
	call DisableSRAM
	ret

ChallengeMachine_PrintOpponentName:
	push bc
	call ChallengeMachine_GetOpponentNameAndDeck
	ld de, 2 ; name
	add hl, de
	call ChallengeMachine_PrintText
	pop bc
	ret

ChallengeMachine_PrintText:
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, c
	ld d, b
	push de
	call InitTextPrinting
	call PrintTextNoDelay
	pop de
	ret

; print the opponent's rank and element
ChallengeMachine_PrintOpponentClubStatus:
	push bc
	call ChallengeMachine_GetOpponentNameAndDeck
	push hl
	ld de, 6 ; rank
	add hl, de
	call ChallengeMachine_PrintText
	ld a, d
	add $07
	ld d, a
	call InitTextPrinting
	pop hl
	ld bc, 8 ; element
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	or h
	jr z, .no_element
	call PrintTextNoDelay
.no_element
	pop bc
	ret

ChallengeMachine_GetOpponentNameAndDeck:
	push de
	ld a, [wChallengeMachineOpponent]
	ld e, a
	ld d, 0
	ld hl, ChallengeMachine_OpponentDeckIDs
	add hl, de
	ld a, [hl]
	ld [wNPCDuelDeckID], a
	call _GetChallengeMachineDuelConfigurations
	pop de
	ret

ChallengeMachine_PrintDuelResultIcons:
	ld hl, sChallengeMachineDuelResults
	ld c, NUM_CHALLENGE_MACHINE_OPPONENTS
	lb de, 1, 2
.print_loop
	push hl
	push bc
	push de
	call InitTextPrinting
	call EnableSRAM
	ld a, [hl]
	add a
	ld e, a
	ld d, 0
	ld hl, ChallengeMachine_DuelResultIcons
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintTextNoDelay
	pop de
	pop bc
	pop hl
	inc hl

; down two rows
	inc e
	inc e

	dec c
	jr nz, .print_loop
	call DisableSRAM
	ret

ChallengeMachine_DuelResultIcons:
	tx ChallengeMachineNotDuelledIconText
	tx ChallengeMachineDuelWonIconText
	tx ChallengeMachineDuelLostIconText

; print all scores in the table pointed to by hl
ChallengeMachine_PrintScores:
.loop
	call EnableSRAM
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	or e
	jr z, .done
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	push hl
	push bc
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	call ConvertWordToNumericalDigits
	pop bc
	call BCCoordToBGMap0Address
	ld hl, wDecimalChars
	ld b, 3
	call SafeCopyDataHLtoDE
	pop hl
	jr .loop

.done
	call DisableSRAM
	ret

; if this is the first time the challenge machine has ever
; been used on this cartridge, then clear all vars and
; set Dr. Mason as the record holder
ChallengeMachine_Initialize:
	call EnableSRAM
	ld a, [sChallengeMachineMagic]
	cp $e3
	jr nz, .init_vars
	ld a, [sChallengeMachineMagic + 1]
	cp $95
	jr z, .done

.init_vars
	ld hl, sChallengeMachineMagic
	ld c, sChallengeMachineEnd - sChallengeMachineStart
	ld a, $e3
	ld [hli], a
	ld a, $95
	ld [hli], a

	xor a
.clear_loop
	ld [hli], a
	dec c
	jr nz, .clear_loop

	ld hl, ChallengeMachine_DrMasonText
	ld de, sChallengeMachineRecordHolderName
	ld bc, NAME_BUFFER_LENGTH
	call CopyDataHLtoDE_SaveRegisters
	ld a, 1
	ld [sMaximumConsecutiveWins], a
	xor a
	ld [sMaximumConsecutiveWins + 1], a

.done
	ld a, [sPlayerInChallengeMachine]
	call DisableSRAM
	ret

ChallengeMachine_DrMasonText:
	text "Dr. Mason", TX_END, TX_END, TX_END, TX_END, TX_END, TX_END

; pick the next opponent sequence and clear challenge vars
ChallengeMachine_PickOpponentSequence:
	call EnableSRAM

; pick first opponent
	ld a, CLUB_MASTERS_START
	call Random
	ld [sChallengeMachineOpponents], a

.pick_second_opponent
	ld a, CLUB_MASTERS_START
	call Random
	ld c, 1
	call ChallengeMachine_CheckIfOpponentAlreadySelected
	jr c, .pick_second_opponent
	ld [sChallengeMachineOpponents + 1], a

.pick_third_opponent
	ld a, CLUB_MASTERS_START
	call Random
	ld c, 2
	call ChallengeMachine_CheckIfOpponentAlreadySelected
	jr c, .pick_third_opponent
	ld [sChallengeMachineOpponents + 2], a

; pick fourth opponent
	ld a, GRAND_MASTERS_START - CLUB_MASTERS_START
	call Random
	add CLUB_MASTERS_START
	ld [sChallengeMachineOpponents + 3], a

; pick fifth opponent
	call UpdateRNGSources
	ld hl, ChallengeMachine_FinalOpponentProbabilities
.next
	sub [hl]
	jr c, .got_opponent
	inc hl
	inc hl
	jr .next
.got_opponent
	inc hl
	ld a, [hl]
	ld [sChallengeMachineOpponents + 4], a

	xor a
	ld [sChallengeMachineOpponentNumber], a
	ld [sConsecutiveWinRecordIncreased], a
	ld hl, sChallengeMachineDuelResults
	ld c, NUM_CHALLENGE_MACHINE_OPPONENTS
.clear_results
	ld [hli], a
	dec c
	jr nz, .clear_results
	ld a, [sPresentConsecutiveWinsBackup]
	ld [sPresentConsecutiveWins], a
	ld a, [sPresentConsecutiveWinsBackup + 1]
	ld [sPresentConsecutiveWins + 1], a
	call DisableSRAM
	ret

ChallengeMachine_FinalOpponentProbabilities:
	db  56, GRAND_MASTERS_START + 0 ; 56/256, courtney
	db  56, GRAND_MASTERS_START + 1 ; 56/256, steve
	db  56, GRAND_MASTERS_START + 2 ; 56/256, jack
	db  56, GRAND_MASTERS_START + 3 ; 56/256, rod
	db   8, GRAND_MASTERS_START + 4 ;  8/256, aaron
	db   8, GRAND_MASTERS_START + 5 ;  8/256, aaron
	db   8, GRAND_MASTERS_START + 6 ;  8/256, aaron
	db 255, GRAND_MASTERS_START + 7 ;  8/256, imakuni (catch-all)

; return carry if the opponent in a is already among
; the first c opponents in sChallengeMachineOpponents
ChallengeMachine_CheckIfOpponentAlreadySelected:
	ld hl, sChallengeMachineOpponents
.loop
	cp [hl]
	jr z, .found
	inc hl
	dec c
	jr nz, .loop
; not found
	or a
	ret
.found
	scf
	ret

ChallengeMachine_OpponentDeckIDs:
.club_members
	db MUSCLES_FOR_BRAINS_DECK_ID
	db HEATED_BATTLE_DECK_ID
	db LOVE_TO_BATTLE_DECK_ID
	db EXCAVATION_DECK_ID
	db BLISTERING_POKEMON_DECK_ID
	db HARD_POKEMON_DECK_ID
	db WATERFRONT_POKEMON_DECK_ID
	db LONELY_FRIENDS_DECK_ID
	db SOUND_OF_THE_WAVES_DECK_ID
	db PIKACHU_DECK_ID
	db BOOM_BOOM_SELFDESTRUCT_DECK_ID
	db POWER_GENERATOR_DECK_ID
	db ETCETERA_DECK_ID
	db FLOWER_GARDEN_DECK_ID
	db KALEIDOSCOPE_DECK_ID
	db GHOST_DECK_ID
	db NAP_TIME_DECK_ID
	db STRANGE_POWER_DECK_ID
	db FLYIN_POKEMON_DECK_ID
	db LOVELY_NIDORAN_DECK_ID
	db POISON_DECK_ID
	db ANGER_DECK_ID
	db FLAMETHROWER_DECK_ID
	db RESHUFFLE_DECK_ID
.club_masters
	db FIRST_STRIKE_DECK_ID
	db ROCK_CRUSHER_DECK_ID
	db GO_GO_RAIN_DANCE_DECK_ID
	db ZAPPING_SELFDESTRUCT_DECK_ID
	db FLOWER_POWER_DECK_ID
	db STRANGE_PSYSHOCK_DECK_ID
	db WONDERS_OF_SCIENCE_DECK_ID
	db FIRE_CHARGE_DECK_ID
.grand_masters
	db LEGENDARY_MOLTRES_DECK_ID
	db LEGENDARY_ZAPDOS_DECK_ID
	db LEGENDARY_ARTICUNO_DECK_ID
	db LEGENDARY_DRAGONITE_DECK_ID
	db LIGHTNING_AND_FIRE_DECK_ID
	db WATER_AND_FIGHTING_DECK_ID
	db GRASS_AND_PSYCHIC_DECK_ID
	db IMAKUNI_DECK_ID

DEF CLUB_MASTERS_START  EQU ChallengeMachine_OpponentDeckIDs.club_masters - ChallengeMachine_OpponentDeckIDs.club_members
DEF GRAND_MASTERS_START EQU ChallengeMachine_OpponentDeckIDs.grand_masters - ChallengeMachine_OpponentDeckIDs.club_members
