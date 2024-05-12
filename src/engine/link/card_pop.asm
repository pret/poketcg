_DoCardPop:
; loads scene for Card Pop! screen
; then checks if console is SGB
; and issues an error message in case it is
	call SetSpriteAnimationsAsVBlankFunction
	ld a,SCENE_CARD_POP
	lb bc, 0, 0
	call LoadScene
	ldtx hl, AreYouBothReadyToCardPopText
	call PrintScrollableText_NoTextBoxLabel
	call RestoreVBlankFunction
	ldtx hl, CardPopCannotBePlayedWithTheGameBoyText
	ld a, [wConsole]
	cp CONSOLE_SGB
	jr z, .error

; initiate the communications
	call PauseSong
	call SetSpriteAnimationsAsVBlankFunction
	ld a, SCENE_GAMEBOY_LINK_CONNECTING
	lb bc, 0, 0
	call LoadScene
	ldtx hl, PositionGameBoyColorsAndPressAButtonText
	call DrawWideTextBox_PrintText
	call EnableLCD
	call HandleCardPopCommunications
	push af
	push hl
	call ClearRP
	call RestoreVBlankFunction
	pop hl
	pop af
	jr c, .error

; show the received card detail page
; and play the corresponding song
	ld a, [wLoadedCard1ID]
	call AddCardToCollectionAndUpdateAlbumProgress
	ld hl, wLoadedCard1Name
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call LoadTxRam2
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	ld a, SFX_RECEIVE_CARD_POP
	call PlaySFX
.wait_sfx
	call AssertSFXFinished
	or a
	jr nz, .wait_sfx
	ld a, [wCardPopCardObtainSong]
	call PlaySong
	ldtx hl, ReceivedThroughCardPopText
	bank1call _DisplayCardDetailScreen
	call ResumeSong
	lb de, $38, $9f
	call SetupText
	bank1call OpenCardPage_FromHand
	ret

.error
; show Card Pop! error scene
; and print text in hl
	push hl
	call ResumeSong
	call SetSpriteAnimationsAsVBlankFunction
	ld a, SCENE_CARD_POP_ERROR
	lb bc, 0, 0
	call LoadScene
	pop hl
	call PrintScrollableText_NoTextBoxLabel
	call RestoreVBlankFunction
	ret

; handles all communications to the other device to do Card Pop!
; returns carry if Card Pop! is unsuccessful
; and returns in hl the corresponding error text ID
HandleCardPopCommunications:
; copy CardPopNameList from SRAM to WRAM
	call EnableSRAM
	ld hl, sCardPopNameList
	ld de, wCardPopNameList
	ld bc, CARDPOP_NAME_LIST_SIZE
	call CopyDataHLtoDE
	call DisableSRAM

	ld a, IRPARAM_CARD_POP
	call InitIRCommunications
.loop_request
	call TryReceiveIRRequest ; receive request
	jr nc, .execute_commands
	bit 1, a
	jr nz, .fail
	call TrySendIRRequest ; send request
	jr c, .loop_request

; do the player name search, then transmit the result
	call ExchangeIRCommunicationParameters
	jr c, .fail
	ld hl, wCardPopNameList
	ld de, wOtherPlayerCardPopNameList
	ld c, 0 ; $100 bytes = CARDPOP_NAME_LIST_SIZE
	call RequestDataTransmissionThroughIR
	jr c, .fail
	call LookUpNameInCardPopNameList
	ld hl, wCardPopNameSearchResult
	ld de, wCardPopNameSearchResult
	ld c, 1
	call RequestDataReceivalThroughIR
	jr c, .fail
	call SetIRCommunicationErrorCode_NoError
	jr c, .fail
	call ExecuteReceivedIRCommands
	jr c, .fail
	jr .check_search_result

.execute_commands
; will receive commands to send card pop name list,
; and to receive the result of the name list search
	call ExecuteReceivedIRCommands
	ld a, [wIRCommunicationErrorCode]
	or a
	jr nz, .fail
	call RequestCloseIRCommunication
	jr c, .fail

.check_search_result
	ld a, [wCardPopNameSearchResult]
	or a
	jr z, .success
	; not $00, means the name was found in the list
	ldtx hl, CannotCardPopWithFriendPreviouslyPoppedWithText
	scf
	ret

.success
	call DecideCardToReceiveFromCardPop

; increment number of times Card Pop! was done
; and write the other player's name to sCardPopNameList
; the spot where this is written in the list is derived
; from the lower nybble of sTotalCardPopsDone
; that means that after 16 Card Pop!, the older
; names start to get overwritten
	call EnableSRAM
	ld hl, sTotalCardPopsDone
	ld a, [hl]
	inc [hl]
	and $0f
	swap a ; *NAME_BUFFER_LENGTH
	ld l, a
	ld h, $0
	ld de, sCardPopNameList
	add hl, de
	ld de, wNameBuffer
	ld c, NAME_BUFFER_LENGTH
.loop_write_name
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .loop_write_name
	call DisableSRAM
	or a
	ret

.fail
	ldtx hl, ThePopWasntSuccessfulText
	scf
	ret

; looks up the name in wNameBuffer in wCardPopNameList
; used to know whether this save file has done Card Pop!
; with the other player already
; returns carry and wCardPopNameSearchResult = $ff if the name was found;
; returns no carry and wCardPopNameSearchResult = $00 otherwise
LookUpNameInCardPopNameList:
; searches for other player's name in this game's name list
	ld hl, wCardPopNameList
	ld c, CARDPOP_NAME_LIST_MAX_ELEMS
.loop_own_card_pop_name_list
	push hl
	ld de, wNameBuffer
	call .CompareNames
	pop hl
	jr nc, .found_name
	ld de, NAME_BUFFER_LENGTH
	add hl, de
	dec c
	jr nz, .loop_own_card_pop_name_list

; name was not found in wCardPopNameList

; searches for this player's name in the other game's name list
; this is useless since it discards the result from the name comparisons
; as a result this loop will always return no carry
	call EnableSRAM
	ld hl, wOtherPlayerCardPopNameList
	ld c, CARDPOP_NAME_LIST_MAX_ELEMS
.loop_other_card_pop_name_list
	push hl
	ld de, sPlayerName
	call .CompareNames
	pop hl
	; bug: discards result from comparison
	; to fix, uncomment line below
	; jr nc, .found_name
	ld de, NAME_BUFFER_LENGTH
	add hl, de
	dec c
	jr nz, .loop_other_card_pop_name_list
	xor a
	jr .no_carry

.found_name
	ld a, $ff
	scf
.no_carry
	call DisableSRAM
	ld [wCardPopNameSearchResult], a ; $00 if name was not found, $ff otherwise
	ret

; compares names in hl and de
; if they are different, return carry
.CompareNames
	ld b, NAME_BUFFER_LENGTH
.loop_chars
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .not_same
	inc hl
	dec b
	jr nz, .loop_chars
	or a
	ret
.not_same
	scf
	ret

; loads in wLoadedCard1 a random card to be received
; this selection is done based on the rarity
; decided from the names of both participants
; the result will always be a non-Energy card that
; is not from a Promotional set, with the exception
; of VenusaurLv64 and MewLv15
; output:
; - e = card ID chosen
DecideCardToReceiveFromCardPop:
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
	call EnableSRAM
	ld hl, sPlayerName
	call CalculateNameHash
	call DisableSRAM
	push de
	ld hl, wNameBuffer
	call CalculateNameHash
	pop bc

; de = other player's name  hash
; bc = this player's name hash

; updates RNG values to subtraction of these two hashes
	ld hl, wRNG1
	ld a, b
	sub d
	ld d, a ; b - d
	ld [hli], a ; wRNG1
	ld a, c
	sub e
	ld e, a ; c - e
	ld [hli], a ; wRNG2
	ld [hl], $0 ; wRNGCounter

; depending on the values obtained from the hashes,
; determine which rarity card to give to the player
; along with the song to play with each rarity
; the probabilities of each possibility can be calculated
; as follows (given 2 random player names):
; 101/256 ~ 39% for Circle
;  90/256 ~ 35% for Diamond
;  63/256 ~ 25% for Star
;   1/256 ~ .4% for VenusaurLv64 or MewLv15
	ld a, e
	cp 5
	jr z, .venusaur1_or_mew2
	cp 64
	jr c, .star_rarity ; < 64
	cp 154
	jr c, .diamond_rarity ; < 154
	; >= 154

	ld a, MUSIC_BOOSTER_PACK
	ld b, CIRCLE
	jr .got_rarity
.diamond_rarity
	ld a, MUSIC_BOOSTER_PACK
	ld b, DIAMOND
	jr .got_rarity
.star_rarity
	ld a, MUSIC_MATCH_VICTORY
	ld b, STAR
.got_rarity
	ld [wCardPopCardObtainSong], a
	ld a, b
	call CreateCardPopCandidateList
	; shuffle candidates and pick first from list
	call ShuffleCards
	ld a, [hl]
	ld e, a
.got_card_id
	ld d, $0
	call LoadCardDataToBuffer1_FromCardID
	ld a, e
	ret

.venusaur1_or_mew2
; choose either VenusaurLv64 or MewLv15
; depending on whether the lower
; bit of d is unset or set, respectively

; since the parameters for this decision is
; based on the cumulative xoring and addition
; of the players' names, they have the same parity
; and thus, the lower bit in d will always be 1
; as a result, VenusaurLv64 is functionally unobtainable
	ld a, MUSIC_MEDAL
	ld [wCardPopCardObtainSong], a
	ld e, VENUSAUR_LV64
	ld a, d
	and $1 ; get lower bit
	jr z, .got_card_id
	ld e, MEW_LV15
	jr .got_card_id

; lists in wCardPopCardCandidates all cards that:
; - are not Energy cards;
; - have the same rarity as input register a;
; - are not from Promotional set.
; input:
; - a = card rarity
; output:
; - a = number of candidates
CreateCardPopCandidateList:
	ld hl, wPlayerDeck
	push hl
	push de
	push bc
	ld b, a

	lb de, 0, GRASS_ENERGY
.loop_card_ids
	call LoadCardDataToBuffer1_FromCardID
	jr c, .count ; no more card IDs
	ld a, [wLoadedCard1Type]
	and TYPE_ENERGY
	jr nz, .next_card_id ; not Pokemon card
	ld a, [wLoadedCard1Rarity]
	cp b
	jr nz, .next_card_id ; not equal rarity
	ld a, [wLoadedCard1Set]
	and $f0
	cp PROMOTIONAL
	jr z, .next_card_id ; no promos
	ld [hl], e
	inc hl
.next_card_id
	inc de
	jr .loop_card_ids

; count all the cards that were listed
; and return it in a
.count
	ld [hl], $00 ; invalid card ID as end of list
	ld hl, wPlayerDeck
	ld c, -1
.loop_count
	inc c
	ld a, [hli]
	or a
	jr nz, .loop_count
	ld a, c
	pop bc
	pop de
	pop hl
	ret

; creates a unique two-byte hash from the name given in hl
; the low byte is calculated by simply adding up all characters
; the high byte is calculated by xoring all characters together
; input:
; - hl = points to the start of the name buffer
; output:
; - de = hash
CalculateNameHash:
	ld c, NAME_BUFFER_LENGTH
	ld de, $0
.loop
	ld a, e
	add [hl]
	ld e, a
	ld a, d
	xor [hl]
	ld d, a
	inc hl
	dec c
	jr nz, .loop
	ret
