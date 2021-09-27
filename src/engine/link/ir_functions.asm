; hl = text ID
LoadLinkConnectingScene:
	push hl
	call SetSpriteAnimationsAsVBlankFunction
	ld a, SCENE_GAMEBOY_LINK_CONNECTING
	lb bc, 0, 0
	call LoadScene
	pop hl
	call DrawWideTextBox_PrintText
	call EnableLCD
	ret

; shows Link Not Connected scene
; then asks the player whether they want to try again
; if the player selects "no", return carry
; input:
;  - hl = text ID
LoadLinkNotConnectedSceneAndAskWhetherToTryAgain:
	push hl
	call RestoreVBlankFunction
	call SetSpriteAnimationsAsVBlankFunction
	ld a, SCENE_GAMEBOY_LINK_NOT_CONNECTED
	lb bc, 0, 0
	call LoadScene
	pop hl
	call DrawWideTextBox_WaitForInput
	ldtx hl, WouldYouLikeToTryAgainText
	call YesOrNoMenuWithText_SetCursorToYes
;	fallthrough

ClearRPAndRestoreVBlankFunction:
	push af
	call ClearRP
	call RestoreVBlankFunction
	pop af
	ret

; prepares IR communication parameter data
; a = a IRPARAM_* constant for the function of this connection
InitIRCommunications:
	ld hl, wOwnIRCommunicationParams
	ld [hl], a
	inc hl
	ld [hl], $50
	inc hl
	ld [hl], $4b
	inc hl
	ld [hl], $31
	ld a, $ff
	ld [wIRCommunicationErrorCode], a
	ld a, PLAYER_TURN
	ldh [hWhoseTurn], a
; clear wNameBuffer and wOpponentName
	xor a
	ld [wNameBuffer], a
	ld hl, wOpponentName
	ld [hli], a
	ld [hl], a
; loads player's name from SRAM
; to wDefaultText
	call EnableSRAM
	ld hl, sPlayerName
	ld de, wDefaultText
	ld c, NAME_BUFFER_LENGTH
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	call DisableSRAM
	ret

; returns carry if communication was unsuccessful
; if a = 0, then it was a communication error
; if a = 1, then operation was cancelled by the player
PrepareSendCardOrDeckConfigurationThroughIR:
	call InitIRCommunications

; pressing A button triggers request for IR communication
.loop_frame
	call DoFrame
	ldh a, [hKeysPressed]
	bit B_BUTTON_F, a
	jr nz, .b_btn
	ldh a, [hKeysHeld]
	bit A_BUTTON_F, a
	jr z, .loop_frame
; a btn
	call TrySendIRRequest
	jr nc, .request_success
	or a
	jr z, .loop_frame
	xor a
	scf
	ret

.b_btn
	; cancelled by the player
	ld a, $01
	scf
	ret

.request_success
	call ExchangeIRCommunicationParameters
	ret c
	ld a, [wOtherIRCommunicationParams + 3]
	cp $31
	jr nz, SetIRCommunicationErrorCode_Error
	or a
	ret

; exchanges player names and IR communication parameters
; checks whether parameters for communication match
; and if they don't, an error is issued
ExchangeIRCommunicationParameters:
	ld hl, wOwnIRCommunicationParams
	ld de, wOtherIRCommunicationParams
	ld c, 4
	call RequestDataTransmissionThroughIR
	jr c, .error
	ld hl, wOtherIRCommunicationParams + 1
	ld a, [hli]
	cp $50
	jr nz, .error
	ld a, [hli]
	cp $4b
	jr nz, .error
	ld a, [wOwnIRCommunicationParams]
	ld hl, wOtherIRCommunicationParams
	cp [hl] ; do parameters match?
	jr nz, SetIRCommunicationErrorCode_Error

; receives wDefaultText from other device
; and writes it to wNameBuffer
	ld hl, wDefaultText
	ld de, wNameBuffer
	ld c, NAME_BUFFER_LENGTH
	call RequestDataTransmissionThroughIR
	jr c, .error
; transmits wDefaultText to be
; written in wNameBuffer in the other device
	ld hl, wDefaultText
	ld de, wNameBuffer
	ld c, NAME_BUFFER_LENGTH
	call RequestDataReceivalThroughIR
	jr c, .error
	or a
	ret

.error
	xor a
	scf
	ret

SetIRCommunicationErrorCode_Error:
	ld hl, wIRCommunicationErrorCode
	ld [hl], $01
	ld de, wIRCommunicationErrorCode
	ld c, 1
	call RequestDataReceivalThroughIR
	call RequestCloseIRCommunication
	ld a, $01
	scf
	ret

SetIRCommunicationErrorCode_NoError:
	ld hl, wOwnIRCommunicationParams
	ld [hl], $00
	ld de, wIRCommunicationErrorCode
	ld c, 1
	call RequestDataReceivalThroughIR
	ret c
	call RequestCloseIRCommunication
	or a
	ret

; makes device receptive to receive data from other device
; to write in wDuelTempList (either list of cards or a deck configuration)
; returns carry if some error occurred
TryReceiveCardOrDeckConfigurationThroughIR:
	call InitIRCommunications
.loop_receive_request
	xor a
	ld [wDuelTempList], a
	call TryReceiveIRRequest
	jr nc, .receive_data
	bit 1, a
	jr nz, .cancelled
	jr .loop_receive_request
.receive_data
	call ExecuteReceivedIRCommands
	ld a, [wIRCommunicationErrorCode]
	or a
	ret z ; no error
	xor a
	scf
	ret

.cancelled
	ld a, $01
	scf
	ret

; returns carry if card(s) wasn't successfully sent
_SendCard:
	call StopMusic
	ldtx hl, SendingACardText
	call LoadLinkConnectingScene
	ld a, IRPARAM_SEND_CARDS
	call PrepareSendCardOrDeckConfigurationThroughIR
	jr c, .fail

	; send cards
	xor a
	ld [wDuelTempList + DECK_SIZE], a
	ld hl, wDuelTempList
	ld e, l
	ld d, h
	ld c, DECK_SIZE + 1
	call RequestDataReceivalThroughIR
	jr c, .fail
	call SetIRCommunicationErrorCode_NoError
	jr c, .fail
	call ExecuteReceivedIRCommands
	jr c, .fail
	ld a, [wOwnIRCommunicationParams + 1]
	cp $4f
	jr nz, .fail
	call PlayCardPopSong
	xor a
	call ClearRPAndRestoreVBlankFunction
	ret

.fail
	call PlayCardPopSong
	ldtx hl, CardTransferWasntSuccessful1Text
	call LoadLinkNotConnectedSceneAndAskWhetherToTryAgain
	jr nc, _SendCard ; loop back and try again
	; failed
	scf
	ret

PlayCardPopSong:
	ld a, MUSIC_CARD_POP
	jp PlaySong

_ReceiveCard:
	call StopMusic
	ldtx hl, ReceivingACardText
	call LoadLinkConnectingScene
	ld a, IRPARAM_SEND_CARDS
	call TryReceiveCardOrDeckConfigurationThroughIR
	ld a, $4f
	ld [wOwnIRCommunicationParams + 1], a
	ld hl, wOwnIRCommunicationParams
	ld e, l
	ld d, h
	ld c, 4
	call RequestDataReceivalThroughIR
	jr c, .fail
	call RequestCloseIRCommunication
	jr c, .fail
	call PlayCardPopSong
	or a
	call ClearRPAndRestoreVBlankFunction
	ret

.fail
	call PlayCardPopSong
	ldtx hl, CardTransferWasntSuccessful2Text
	call LoadLinkNotConnectedSceneAndAskWhetherToTryAgain
	jr nc, _ReceiveCard
	scf
	ret

_SendDeckConfiguration:
	call StopMusic
	ldtx hl, SendingADeckConfigurationText
	call LoadLinkConnectingScene
	ld a, IRPARAM_SEND_DECK
	call PrepareSendCardOrDeckConfigurationThroughIR
	jr c, .fail
	ld hl, wDuelTempList
	ld e, l
	ld d, h
	ld c, DECK_STRUCT_SIZE
	call RequestDataReceivalThroughIR
	jr c, .fail
	call SetIRCommunicationErrorCode_NoError
	jr c, .fail
	call PlayCardPopSong
	call ClearRPAndRestoreVBlankFunction
	or a
	ret

.fail
	call PlayCardPopSong
	ldtx hl, DeckConfigurationTransferWasntSuccessful1Text
	call LoadLinkNotConnectedSceneAndAskWhetherToTryAgain
	jr nc, _SendDeckConfiguration
	scf
	ret

_ReceiveDeckConfiguration:
	call StopMusic
	ldtx hl, ReceivingDeckConfigurationText
	call LoadLinkConnectingScene
	ld a, IRPARAM_SEND_DECK
	call TryReceiveCardOrDeckConfigurationThroughIR
	jr c, .fail
	call PlayCardPopSong
	call ClearRPAndRestoreVBlankFunction
	or a
	ret

.fail
	call PlayCardPopSong
	ldtx hl, DeckConfigurationTransferWasntSuccessful2Text
	call LoadLinkNotConnectedSceneAndAskWhetherToTryAgain
	jr nc, _ReceiveDeckConfiguration ; loop back and try again
	scf
	ret
