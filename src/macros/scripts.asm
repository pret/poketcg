DEF start_script EQUS "rst $20"

MACRO run_command
	db \1_index
ENDM

	const_def
	const ScriptCommand_EndScript_index                                      ; $00
	const ScriptCommand_CloseAdvancedTextBox_index                           ; $01
	const ScriptCommand_PrintNPCText_index                                   ; $02
	const ScriptCommand_PrintText_index                                      ; $03
	const ScriptCommand_AskQuestionJump_index                                ; $04
	const ScriptCommand_StartDuel_index                                      ; $05
	const ScriptCommand_PrintVariableNPCText_index                           ; $06
	const ScriptCommand_PrintVariableText_index                              ; $07
	const ScriptCommand_PrintTextQuitFully_index                             ; $08
	const ScriptCommand_UnloadActiveNPC_index                                ; $09
	const ScriptCommand_MoveActiveNPCByDirection_index                       ; $0a
	const ScriptCommand_CloseTextBox_index                                   ; $0b
	const ScriptCommand_GiveBoosterPacks_index                               ; $0c
	const ScriptCommand_JumpIfCardOwned_index                                ; $0d
	const ScriptCommand_JumpIfCardInCollection_index                         ; $0e
	const ScriptCommand_GiveCard_index                                       ; $0f
	const ScriptCommand_TakeCard_index                                       ; $10
	const ScriptCommand_JumpIfAnyEnergyCardsInCollection_index               ; $11
	const ScriptCommand_RemoveAllEnergyCardsFromCollection_index             ; $12
	const ScriptCommand_JumpIfEnoughCardsOwned_index                         ; $13
	const ScriptCommand_JumpBasedOnFightingClubPupilStatus_index             ; $14
	const ScriptCommand_SetActiveNPCDirection_index                          ; $15
	const ScriptCommand_PickNextMan1RequestedCard_index                      ; $16
	const ScriptCommand_LoadMan1RequestedCardIntoTxRamSlot_index             ; $17
	const ScriptCommand_JumpIfMan1RequestedCardOwned_index                   ; $18
	const ScriptCommand_JumpIfMan1RequestedCardInCollection_index            ; $19
	const ScriptCommand_RemoveMan1RequestedCardFromCollection_index          ; $1a
	const ScriptCommand_Jump_index                                           ; $1b
	const ScriptCommand_TryGiveMedalPCPacks_index                            ; $1c
	const ScriptCommand_SetPlayerDirection_index                             ; $1d
	const ScriptCommand_MovePlayer_index                                     ; $1e
	const ScriptCommand_ShowCardReceivedScreen_index                         ; $1f
	const ScriptCommand_SetDialogNPC_index                                   ; $20
	const ScriptCommand_SetNextNPCAndScript_index                            ; $21
	const ScriptCommand_SetSpriteAttributes_index                            ; $22
	const ScriptCommand_SetActiveNPCCoords_index                             ; $23
	const ScriptCommand_DoFrames_index                                       ; $24
	const ScriptCommand_JumpIfActiveNPCCoordsMatch_index                     ; $25
	const ScriptCommand_JumpIfPlayerCoordsMatch_index                        ; $26
	const ScriptCommand_MoveActiveNPC_index                                  ; $27
	const ScriptCommand_GiveOneOfEachTrainerBooster_index                    ; $28
	const ScriptCommand_JumpIfNPCLoaded_index                                ; $29
	const ScriptCommand_ShowMedalReceivedScreen_index                        ; $2a
	const ScriptCommand_LoadCurrentMapNameIntoTxRamSlot_index                ; $2b
	const ScriptCommand_LoadChallengeHallNPCIntoTxRamSlot_index              ; $2c
	const ScriptCommand_StartChallengeHallDuel_index                         ; $2d
	const ScriptCommand_PrintTextForChallengeCup_index                       ; $2e
	const ScriptCommand_MoveChallengeHallNPC_index                           ; $2f
	const ScriptCommand_UnloadChallengeHallNPC_index                         ; $30
	const ScriptCommand_SetChallengeHallNPCCoords_index                      ; $31
	const ScriptCommand_PickChallengeHallOpponent_index                      ; $32
	const ScriptCommand_OpenMenu_index                                       ; $33
	const ScriptCommand_PickChallengeCupPrizeCard_index                      ; $34
	const ScriptCommand_QuitScriptFully_index                                ; $35
	const ScriptCommand_ReplaceMapBlocks_index                               ; $36
	const ScriptCommand_ChooseDeckToDuelAgainstMultichoice_index             ; $37
	const ScriptCommand_OpenDeckMachine_index                                ; $38
	const ScriptCommand_ChooseStarterDeckMultichoice_index                   ; $39
	const ScriptCommand_EnterMap_index                                       ; $3a
	const ScriptCommand_MoveArbitraryNPC_index                               ; $3b
	const ScriptCommand_PickLegendaryCard_index                              ; $3c
	const ScriptCommand_FlashScreen_index                                    ; $3d
	const ScriptCommand_SaveGame_index                                       ; $3e
	const ScriptCommand_BattleCenter_index                                   ; $3f
	const ScriptCommand_GiftCenter_index                                     ; $40
	const ScriptCommand_PlayCredits_index                                    ; $41
	const ScriptCommand_TryGivePCPack_index                                  ; $42
	const ScriptCommand_nop_index                                            ; $43
	const ScriptCommand_GiveStarterDeck_index                                ; $44
	const ScriptCommand_WalkPlayerToMasonLaboratory_index                    ; $45
	const ScriptCommand_OverrideSong_index                                   ; $46
	const ScriptCommand_SetDefaultSong_index                                 ; $47
	const ScriptCommand_PlaySong_index                                       ; $48
	const ScriptCommand_PlaySFX_index                                        ; $49
	const ScriptCommand_PauseSong_index                                      ; $4a
	const ScriptCommand_ResumeSong_index                                     ; $4b
	const ScriptCommand_PlayDefaultSong_index                                ; $4c
	const ScriptCommand_WaitForSongToFinish_index                            ; $4d
	const ScriptCommand_RecordMasterWin_index                                ; $4e
	const ScriptCommand_AskQuestionJumpDefaultYes_index                      ; $4f
	const ScriptCommand_ShowSamNormalMultichoice_index                       ; $50
	const ScriptCommand_ShowSamRulesMultichoice_index                        ; $51
	const ScriptCommand_ChallengeMachine_index                               ; $52
	const ScriptCommand_EndScript2_index                                     ; $53
	const ScriptCommand_EndScript3_index                                     ; $54
	const ScriptCommand_EndScript4_index                                     ; $55
	const ScriptCommand_EndScript5_index                                     ; $56
	const ScriptCommand_EndScript6_index                                     ; $57
	const ScriptCommand_SetEventValue_index                                  ; $58
	const ScriptCommand_JumpIfEventZero_index                                ; $59
	const ScriptCommand_JumpIfEventNonzero_index                             ; $5a
	const ScriptCommand_JumpIfEventEqual_index                               ; $5b
	const ScriptCommand_JumpIfEventNotEqual_index                            ; $5c
	const ScriptCommand_JumpIfEventGreaterOrEqual_index                      ; $5d
	const ScriptCommand_JumpIfEventLessThan_index                            ; $5e
	const ScriptCommand_MaxOutEventValue_index                               ; $5f
	const ScriptCommand_ZeroOutEventValue_index                              ; $60
	const ScriptCommand_JumpIfEventTrue_index                                ; $61
	const ScriptCommand_JumpIfEventFalse_index                               ; $62
	const ScriptCommand_IncrementEventValue_index                            ; $63
	const ScriptCommand_EndScript7_index                                     ; $64
	const ScriptCommand_EndScript8_index                                     ; $65
	const ScriptCommand_EndScript9_index                                     ; $66
	const ScriptCommand_EndScript10_index                                    ; $67

DEF NUM_SCRIPT_COMMANDS EQU const_value


; Script Macros

; Stops the current script and returns control flow back to assembly
MACRO end_script
	run_command ScriptCommand_EndScript
ENDM

; Closes current dialog window
MACRO close_advanced_text_box
	run_command ScriptCommand_CloseAdvancedTextBox
ENDM

; Opens a new dialog window and displays the given text and active npc name
MACRO print_npc_text
	run_command ScriptCommand_PrintNPCText
	tx \1 ; Text Pointer
ENDM

; Opens a new dialog window and displays the given text
MACRO print_text
	run_command ScriptCommand_PrintText
	tx \1 ; Text Pointer
ENDM

; Displays text and allows players to choose yes or no. Will jump on yes.
; if first argument is 0000 (NULL), will overwrite last text with yes/no.
MACRO ask_question_jump
	run_command ScriptCommand_AskQuestionJump
	IF ISCONST(\1)
		dw \1 ; NULL
	ELSE
		tx \1 ; Text Pointer
	ENDC
	dw \2 ; Jump Location
ENDM

; Begins a duel with the NPC currently being spoken to
MACRO start_duel
	run_command ScriptCommand_StartDuel
	db \1 ; Prize Amount (ex PRIZES_2)
	db \2 ; Deck ID (ex SAMS_PRACTICE_DECK_ID)
	db \3 ; Duel Music (ex MUSIC_DUEL_THEME_1)
ENDM

; Prints the first or second npc text depending on if wScriptControlByte is nonzero or zero respectively
MACRO print_variable_npc_text
	run_command ScriptCommand_PrintVariableNPCText
	tx \1 ; Text Pointer
	tx \2 ; Text Pointer
ENDM

; Prints the first or second text depending on if wScriptControlByte is nonzero or zero respectively
MACRO print_variable_text
	run_command ScriptCommand_PrintVariableText
	tx \1 ; Text Pointer
	tx \2 ; Text Pointer
ENDM

; Displays text then fully quits out of scripting system (Does NOT return to RST20)
MACRO print_text_quit_fully
	run_command ScriptCommand_PrintTextQuitFully
	tx \1 ; Text Pointer
ENDM

; Removes the current NPC from the map
MACRO unload_active_npc
	run_command ScriptCommand_UnloadActiveNPC
ENDM

; Moves the current NPC depending on their current direction
; Argument points to a table of 4 NPCMovements chosen based on direction value
MACRO move_active_npc_by_direction
	run_command ScriptCommand_MoveActiveNPCByDirection
	dw \1 ; Movement Table
ENDM

; Closes the textbox currently on the screen
MACRO close_text_box
	run_command ScriptCommand_CloseTextBox
ENDM

; Gives the player up to 3 booster packs. Arguments can be replaced by NO_BOOSTER
MACRO give_booster_packs
	run_command ScriptCommand_GiveBoosterPacks
	db \1 ; booster pack (ex BOOSTER_LABORATORY_NEUTRAL)
	db \2 ; booster pack
	db \3 ; booster pack
ENDM

; Jumps to a given script position if the player owns a card anywhere
MACRO jump_if_card_owned
	run_command ScriptCommand_JumpIfCardOwned
	db \1 ; card ID (ex LAPRAS)
	dw \2 ; script label
ENDM

; Jumps to a given script position if the player has a card specifically in their collection
MACRO jump_if_card_in_collection
	run_command ScriptCommand_JumpIfCardInCollection
	db \1 ; card ID (ex LAPRAS)
	dw \2 ; script label
ENDM

; Gives the player a card straight to their collection.
; Does not show the card received screen. For that see show_card_received_screen
MACRO give_card
	run_command ScriptCommand_GiveCard
	db \1 ; card ID (ex LAPRAS)
ENDM

; Removes a card from the player's collection, usually to trade
MACRO take_card
	run_command ScriptCommand_TakeCard
	db \1 ; card ID (ex LAPRAS)
ENDM

; Jumps to a given script position if the player has any energy cards in their collection
MACRO jump_if_any_energy_cards_in_collection
	run_command ScriptCommand_JumpIfAnyEnergyCardsInCollection
	dw \1 ; script label
ENDM

; Removes all of the player's energy cards from their collection
MACRO remove_all_energy_cards_from_collection
	run_command ScriptCommand_RemoveAllEnergyCardsFromCollection
ENDM

; Jumps to a given script position if the player owns enough cards
MACRO jump_if_enough_cards_owned
	run_command ScriptCommand_JumpIfEnoughCardsOwned
	dw \1 ; amount of cards needed
	dw \2 ; script label
ENDM

; Jumps to a script position depending on how far in the fight club pupil quest you are
MACRO fight_club_pupil_jump
	run_command ScriptCommand_JumpBasedOnFightingClubPupilStatus
	dw \1 ; Script Label (First Interaction)
	dw \2 ; Script Label (Three Pupils Remaining)
	dw \3 ; Script Label (Two Pupils Remaining)
	dw \4 ; Script Label (One Pupil Remaining)
	dw \5 ; Script Label (All Pupils Defeated)
ENDM

; Causes the active NPC to face the specified direction
MACRO set_active_npc_direction
	run_command ScriptCommand_SetActiveNPCDirection
	db \1 ; Direction (ex NORTH)
ENDM

; Picks the next card gift that will be requested by NPC_MAN1
MACRO pick_next_man1_requested_card
	run_command ScriptCommand_PickNextMan1RequestedCard
ENDM

; Loads into the given txram slot the name of the card gift requested by NPC_MAN1
MACRO load_man1_requested_card_into_txram_slot
	run_command ScriptCommand_LoadMan1RequestedCardIntoTxRamSlot
	db \1 ; TxRam slot
ENDM

; Jumps to the given script position if the player owns the card gift requested by NPC_MAN1
MACRO jump_if_man1_requested_card_owned
	run_command ScriptCommand_JumpIfMan1RequestedCardOwned
	dw \1 ; Script Label
ENDM

; Jumps to the given script position if the player's collection contains the card gift requested by NPC_MAN1
MACRO jump_if_man1_requested_card_in_collection
	run_command ScriptCommand_JumpIfMan1RequestedCardInCollection
	dw \1 ; Script Label
ENDM

; Removes from the player's collection the card gift requested by NPC_MAN1
MACRO remove_man1_requested_card_from_collection
	run_command ScriptCommand_RemoveMan1RequestedCardFromCollection
ENDM

; Jumps to a given script position
MACRO script_jump
	run_command ScriptCommand_Jump
	dw \1 ; Script Label
ENDM

; Attempts to send Dr. Mason's PC Packs to the player
MACRO try_give_medal_pc_packs
	run_command ScriptCommand_TryGiveMedalPCPacks
ENDM

; Causes the player to face the specified direction
MACRO set_player_direction
	run_command ScriptCommand_SetPlayerDirection
	db \1 ; Direction (ex NORTH)
ENDM

; Moves the player
MACRO move_player
	run_command ScriptCommand_MovePlayer
	db \1 ; Direction (ex NORTH)
	db \2 ; Speed
ENDM

; Shows a fullscreen image of a card and says the player has received it
MACRO show_card_received_screen
	run_command ScriptCommand_ShowCardReceivedScreen
	db \1 ; Card received (ex LAPRAS)
ENDM

; Sets the active NPC
MACRO set_dialog_npc
	run_command ScriptCommand_SetDialogNPC
	db \1 ; NPC (ex NPC_DRMASON)
ENDM

; Sets the active NPC and script. Not immediately executed.
MACRO set_next_npc_and_script
	run_command ScriptCommand_SetNextNPCAndScript
	db \1 ; NPC (ex NPC_DRMASON)
	dw \2 ; Script Label
ENDM

; Sets some NPC sprite attributes
MACRO set_sprite_attributes
	run_command ScriptCommand_SetSpriteAttributes
	db \1 ; sprite animation non-CGB (SPRITE_ANIM_*)
	db \2 ; sprite animation CGB (SPRITE_ANIM_*)
	db \3 ; NPC animation flags (NPC_FLAG_*)
ENDM

; Sets the active NPC's coords
MACRO set_active_npc_coords
	run_command ScriptCommand_SetActiveNPCCoords
	db \1 ; X Coord
	db \2 ; Y Coord
ENDM

; Waits a number of frames
MACRO do_frames
	run_command ScriptCommand_DoFrames
	db \1 ; Number of frames to wait
ENDM

; Jumps to a script position if the active NPC's X and Y match the given values
MACRO jump_if_active_npc_coords_match
	run_command ScriptCommand_JumpIfActiveNPCCoordsMatch
	db \1 ; X Coord
	db \2 ; Y Coord
	dw \3 ; Script Label
ENDM

; Jumps to a script position if the player's X and Y match the given values
MACRO jump_if_player_coords_match
	run_command ScriptCommand_JumpIfPlayerCoordsMatch
	db \1 ; X Coord
	db \2 ; Y Coord
	dw \3 ; Script Label
ENDM

; Moves the active NPC using an NPCMovement
MACRO move_active_npc
	run_command ScriptCommand_MoveActiveNPC
	dw \1 ; NPCMovement (ex NPCMovement_d880)
ENDM

; Gives the player one of each booster pack with a trainer focus
MACRO give_one_of_each_trainer_booster
	run_command ScriptCommand_GiveOneOfEachTrainerBooster
ENDM

; Jumps to a script position if the NPC is loaded
MACRO jump_if_npc_loaded
	run_command ScriptCommand_JumpIfNPCLoaded
	db \1 ; NPC (ex NPC_DRMASON)
	dw \2 ; Script Label
ENDM

; Shows the medal received screen for the given master medal
MACRO show_medal_received_screen
	run_command ScriptCommand_ShowMedalReceivedScreen
	db \1 ; medal event (ex EVENT_BEAT_NIKKI)
ENDM

; Loads the current map name into the given txram slot
MACRO load_current_map_name_into_txram_slot
	run_command ScriptCommand_LoadCurrentMapNameIntoTxRamSlot
	db \1 ; TxRam slot
ENDM

; Loads the challenge hall opponent NPC name into the given txram slot
MACRO load_challenge_hall_npc_into_txram_slot
	run_command ScriptCommand_LoadChallengeHallNPCIntoTxRamSlot
	db \1 ; TxRam slot
ENDM

; Begins a duel with the challenge hall opponent
; The deck and song arguments are overwritten when the duel is initialized
MACRO start_challenge_hall_duel
	run_command ScriptCommand_StartChallengeHallDuel
	db \1 ; Prize Amount (ex PRIZES_2)
	db \2 ; Deck ID (ex SAMS_PRACTICE_DECK_ID)
	db \3 ; Duel Music (ex MUSIC_DUEL_THEME_1)
ENDM

; Prints the text based on the current challenge cup number
MACRO print_text_for_challenge_cup
	run_command ScriptCommand_PrintTextForChallengeCup
	tx \1 ; Text Pointer for Challenge Cup #1
	tx \2 ; Text Pointer for Challenge Cup #2
	tx \3 ; Text Pointer for Challenge Cup #3
ENDM

; Moves the Challenge Hall opponent NPC using an NPCMovement
MACRO move_challenge_hall_npc
	run_command ScriptCommand_MoveChallengeHallNPC
	dw \1 ; NPCMovement (ex NPCMovement_d880)
ENDM

; Unloads the Challenge Hall opponent NPC
MACRO unload_challenge_hall_npc
	run_command ScriptCommand_UnloadChallengeHallNPC
ENDM

; Sets the Challenge Hall opponent NPC's coords
MACRO set_challenge_hall_npc_coords
	run_command ScriptCommand_SetChallengeHallNPCCoords
	db \1 ; X Coord
	db \2 ; Y Coord
ENDM

; Picks the next Challenge Hall opponent NPC
MACRO pick_challenge_hall_opponent
	run_command ScriptCommand_PickChallengeHallOpponent
ENDM

; Opens the pause menu
MACRO open_menu
	run_command ScriptCommand_OpenMenu
ENDM

; Picks the Challenge Cup prize card
MACRO pick_challenge_cup_prize_card
	run_command ScriptCommand_PickChallengeCupPrizeCard
ENDM

; Closes Advanced TextBoxes then Ends Script Loop
MACRO quit_script_fully
	run_command ScriptCommand_QuitScriptFully
ENDM

; Replaces map blocks
; used for deck machines, challenge machine, Pokemon Dome doors, Hall of Honor doors etc
; accepts as argument any of MAP_EVENT_* constants
MACRO replace_map_blocks
	run_command ScriptCommand_ReplaceMapBlocks
	db \1 ; id
ENDM

MACRO choose_deck_to_duel_against
	run_command ScriptCommand_ChooseDeckToDuelAgainstMultichoice
ENDM

; Opens the deck machine
MACRO open_deck_machine
	run_command ScriptCommand_OpenDeckMachine
	db \1 ; DECK_MACHINE_* constant
ENDM

MACRO choose_starter_deck
	run_command ScriptCommand_ChooseStarterDeckMultichoice
ENDM

; Enters a given map screen
MACRO enter_map
	run_command ScriptCommand_EnterMap
	db \1 ; Unused
	db \2 ; Room (ex MASON_LABORATORY)
	db \3 ; Player X
	db \4 ; Player Y
	db \5 ; Player Direction
ENDM

; Moves any NPC using an NPCMovement
MACRO move_npc
	run_command ScriptCommand_MoveArbitraryNPC
	db \1 ; NPC (ex NPC_JOSHUA)
	dw \2 ; NPCMovement (NPCMovement_e2ab)
ENDM

; Picks the next legendary card
MACRO pick_legendary_card
	run_command ScriptCommand_PickLegendaryCard
ENDM

; Flashes the screen to white
; if arg is non-zero, keep the screen white
; otherwise, fade the screen back in
MACRO flash_screen
	run_command ScriptCommand_FlashScreen
	db \1 ; keep screen white?
ENDM

; Saves the game
; if arg is non-zero, save the player in MASON_LABORATORY
; otherwise, save the player in their current location
MACRO save_game
	run_command ScriptCommand_SaveGame
	db \1 ; send to MASON_LABORATORY?
ENDM

; Loads the Battle Center
MACRO battle_center
	run_command ScriptCommand_BattleCenter
ENDM

; Loads the Gift Center
; if arg is zero, display the options selection menu
; otherwise, execute the player's previously chosen selection
MACRO gift_center
	run_command ScriptCommand_GiftCenter
	db \1 ; execute selection?
ENDM

; Plays the credits
MACRO play_credits
	run_command ScriptCommand_PlayCredits
ENDM

; Tries to give the player a specific PC Pack from Dr. Mason
MACRO try_give_pc_pack
	run_command ScriptCommand_TryGivePCPack
	db \1 ; PC Pack Index
ENDM

; Nothing.
MACRO script_nop
	run_command ScriptCommand_nop
ENDM

; Gives the player their previously chosen starter deck
MACRO give_stater_deck
	run_command ScriptCommand_GiveStarterDeck
ENDM

; Walks the player across the overworld map to MASON_LABORATORY
MACRO walk_player_to_mason_lab
	run_command ScriptCommand_WalkPlayerToMasonLaboratory
ENDM

; Plays a song and saves it to wSongOverride
MACRO override_song
	run_command ScriptCommand_OverrideSong
	db \1 ; Song ID (ex MUSIC_BOOSTER_PACK)
ENDM

; Sets the default song for the overworld
MACRO set_default_song
	run_command ScriptCommand_SetDefaultSong
	db \1 ; Song ID (ex MUSIC_BOOSTER_PACK)
ENDM

; Plays a song
MACRO play_song
	run_command ScriptCommand_PlaySong
	db \1 ; Song ID (ex MUSIC_BOOSTER_PACK)
ENDM

; Plays a sound effect
MACRO play_sfx
	run_command ScriptCommand_PlaySFX
	db \1 ; Sound Effect (ex SFX_SAVE_GAME)
ENDM

; Pauses the current song
MACRO pause_song
	run_command ScriptCommand_PauseSong
ENDM

; Resumes the current song
MACRO resume_song
	run_command ScriptCommand_ResumeSong
ENDM

; Plays the default overworld song
MACRO play_default_song
	run_command ScriptCommand_PlayDefaultSong
ENDM

; Waits for the current song to finish
MACRO wait_for_song_to_finish
	run_command ScriptCommand_WaitForSongToFinish
ENDM

; Records when the player defeats a master (the 8 Club Masters or the Ronald Grand Master duel)
; the order of wins is stored in wMastersBeatenList
; the purpose of this is still unknown
MACRO record_master_win
	run_command ScriptCommand_RecordMasterWin
	db \1 ; which master duel
ENDM

; Asks the player a question then jumps
MACRO ask_question_jump_default_yes
	run_command ScriptCommand_AskQuestionJumpDefaultYes
	IF ISCONST(\1)
		dw \1 ; NULL
	ELSE
		tx \1 ; Text Pointer
	ENDC
	dw \2 ; Script Label
ENDM

MACRO show_sam_normal_multichoice
	run_command ScriptCommand_ShowSamNormalMultichoice
ENDM

MACRO show_sam_rules_multichoice
	run_command ScriptCommand_ShowSamRulesMultichoice
ENDM

; Runs the Challenge Machine
MACRO challenge_machine
	run_command ScriptCommand_ChallengeMachine
ENDM

; Sets an event's value
MACRO set_event
	run_command ScriptCommand_SetEventValue
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; new value
ENDM

; Jumps to a script position if a given event is zero
MACRO jump_if_event_zero
	run_command ScriptCommand_JumpIfEventZero
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	dw \2 ; Script Label
ENDM

; Tests if a given event is zero
MACRO test_if_event_zero
	run_command ScriptCommand_JumpIfEventZero
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	dw NULL
ENDM

; Jumps to a script position if a given event is nonzero
MACRO jump_if_event_nonzero
	run_command ScriptCommand_JumpIfEventNonzero
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	dw \2 ; Script Label
ENDM

; Jumps to a script position if an event matches given value
MACRO jump_if_event_equal
	run_command ScriptCommand_JumpIfEventEqual
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw \3 ; Script Label
ENDM

; Tests if an event matches given value
MACRO test_if_event_equal
	run_command ScriptCommand_JumpIfEventEqual
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw NULL
ENDM

; Jumps to a script position if an event does not match a given value
MACRO jump_if_event_not_equal
	run_command ScriptCommand_JumpIfEventNotEqual
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw \3 ; Script Label
ENDM

; Tests if an event does not match a given value
MACRO test_if_event_not_equal
	run_command ScriptCommand_JumpIfEventNotEqual
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw NULL
ENDM

; Jumps to a script position if an event is greater than or equal to a given value
MACRO jump_if_event_greater_or_equal
	run_command ScriptCommand_JumpIfEventGreaterOrEqual
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw \3 ; Script Label
ENDM

; Jumps to a script position if an event is less than a given value
MACRO jump_if_event_less_than
	run_command ScriptCommand_JumpIfEventLessThan
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw \3 ; Script Label
ENDM

; Tests if an event is less than a given value
MACRO test_if_event_less_than
	run_command ScriptCommand_JumpIfEventLessThan
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw NULL
ENDM

; Sets an event to its maximum possible value
MACRO max_out_event_value
	run_command ScriptCommand_MaxOutEventValue
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
ENDM

; Sets an event's value to zero
MACRO zero_out_event_value
	run_command ScriptCommand_ZeroOutEventValue
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
ENDM

; Jumps to a script position if an event is true
MACRO jump_if_event_true
	run_command ScriptCommand_JumpIfEventTrue
	db \1 ; event (ex EVENT_RECEIVED_LEGENDARY_CARDS)
	dw \2 ; Script Label
ENDM

; Jumps to a script position if an event is false
MACRO jump_if_event_false
	run_command ScriptCommand_JumpIfEventFalse
	db \1 ; event (ex EVENT_RECEIVED_LEGENDARY_CARDS)
	dw \2 ; Script Label
ENDM

; Tests if an event is false
MACRO test_if_event_false
	run_command ScriptCommand_JumpIfEventFalse
	db \1 ; event (ex EVENT_RECEIVED_LEGENDARY_CARDS)
	dw NULL
ENDM

; Increments given event's value (truncates the new value)
MACRO increment_event_value
	run_command ScriptCommand_IncrementEventValue
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
ENDM
