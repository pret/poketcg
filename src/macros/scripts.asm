start_script EQUS "rst $20"

run_command: MACRO
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

; Script Macros

; Stops the current script and returns control flow back to assembly
end_script: MACRO
	run_command ScriptCommand_EndScript
ENDM

; Closes current dialog window
close_advanced_text_box: MACRO
	run_command ScriptCommand_CloseAdvancedTextBox
ENDM

; Opens a new dialog window and displays the given text and active npc name
print_npc_text: MACRO
	run_command ScriptCommand_PrintNPCText
	tx \1 ; Text Pointer
ENDM

; Opens a new dialog window and displays the given text
print_text: MACRO
	run_command ScriptCommand_PrintText
	tx \1 ; Text Pointer
ENDM

; Displays text and allows players to choose yes or no. Will jump on yes.
; if first argument is 0000 (NULL), will overwrite last text with yes/no.
ask_question_jump: MACRO
	run_command ScriptCommand_AskQuestionJump
IF ISCONST(\1)
	dw \1 ; NULL
ELSE
	tx \1 ; Text Pointer
ENDC
	dw \2 ; Jump Location
ENDM

; Begins a duel with the NPC currently being spoken to
start_duel: MACRO
	run_command ScriptCommand_StartDuel
	db \1 ; Prize Amount (ex PRIZES_2)
	db \2 ; Deck ID (ex SAMS_PRACTICE_DECK_ID)
	db \3 ; Duel Music (ex MUSIC_DUEL_THEME_1)
ENDM

; Prints the first or second npc text depending on if wScriptControlByte is nonzero or zero respectively
print_variable_npc_text: MACRO
	run_command ScriptCommand_PrintVariableNPCText
	tx \1 ; Text Pointer
	tx \2 ; Text Pointer
ENDM

; Prints the first or second text depending on if wScriptControlByte is nonzero or zero respectively
print_variable_text: MACRO
	run_command ScriptCommand_PrintVariableText
	tx \1 ; Text Pointer
	tx \2 ; Text Pointer
ENDM

; Displays text then fully quits out of scripting system (Does NOT return to RST20)
print_text_quit_fully: MACRO
	run_command ScriptCommand_PrintTextQuitFully
	tx \1 ; Text Pointer
ENDM

; Removes the current NPC from the map
unload_active_npc: MACRO
	run_command ScriptCommand_UnloadActiveNPC
ENDM

; Moves the current NPC depending on their current direction
; Argument points to a table of 4 NPCMovements chosen based on direction value
move_active_npc_by_direction: MACRO
	run_command ScriptCommand_MoveActiveNPCByDirection
	dw \1 ; Movement Table
ENDM

; Closes the textbox currently on the screen
close_text_box: MACRO
	run_command ScriptCommand_CloseTextBox
ENDM

; Gives the player up to 3 booster packs. Arguments can be replaced by NO_BOOSTER
give_booster_packs: MACRO
	run_command ScriptCommand_GiveBoosterPacks
	db \1 ; booster pack (ex BOOSTER_LABORATORY_NEUTRAL)
	db \2 ; booster pack
	db \3 ; booster pack
ENDM

; Jumps to a given script position if the player owns a card anywhere
jump_if_card_owned: MACRO
	run_command ScriptCommand_JumpIfCardOwned
	db \1 ; card ID (ex LAPRAS)
	dw \2 ; script label
ENDM

; Jumps to a given script position if the player has a card specifically in their collection
jump_if_card_in_collection: MACRO
	run_command ScriptCommand_JumpIfCardInCollection
	db \1 ; card ID (ex LAPRAS)
	dw \2 ; script label
ENDM

; Gives the player a card straight to their collection.
; Does not show the card received screen. For that see show_card_received_screen
give_card: MACRO
	run_command ScriptCommand_GiveCard
	db \1 ; card ID (ex LAPRAS)
ENDM

; Removes a card from the player's collection, usually to trade
take_card: MACRO
	run_command ScriptCommand_TakeCard
	db \1 ; card ID (ex LAPRAS)
ENDM

; Jumps to a given script position if the player has any energy cards in their collection
jump_if_any_energy_cards_in_collection: MACRO
	run_command ScriptCommand_JumpIfAnyEnergyCardsInCollection
	dw \1 ; script label
ENDM

; Removes all of the player's energy cards from their collection
remove_all_energy_cards_from_collection: MACRO
	run_command ScriptCommand_RemoveAllEnergyCardsFromCollection
ENDM

; Jumps to a given script position if the player owns enough cards
jump_if_enough_cards_owned: MACRO
	run_command ScriptCommand_JumpIfEnoughCardsOwned
	dw \1 ; amount of cards needed
	dw \2 ; script label
ENDM

; Jumps to a script position depending on how far in the fight club pupil quest you are
fight_club_pupil_jump: MACRO
	run_command ScriptCommand_JumpBasedOnFightingClubPupilStatus
	dw \1 ; Script Label (First Interaction)
	dw \2 ; Script Label (Three Pupils Remaining)
	dw \3 ; Script Label (Two Pupils Remaining)
	dw \4 ; Script Label (One Pupil Remaining)
	dw \5 ; Script Label (All Pupils Defeated)
ENDM

; Causes the active NPC to face the specified direction
set_active_npc_direction: MACRO
	run_command ScriptCommand_SetActiveNPCDirection
	db \1 ; Direction (ex NORTH)
ENDM

; Picks the next card gift that will be requested by NPC_MAN1
pick_next_man1_requested_card: MACRO
	run_command ScriptCommand_PickNextMan1RequestedCard
ENDM

; Loads into the given txram slot the name of the card gift requested by NPC_MAN1
load_man1_requested_card_into_txram_slot: MACRO
	run_command ScriptCommand_LoadMan1RequestedCardIntoTxRamSlot
	db \1 ; TxRam slot
ENDM

; Jumps to the given script position if the player owns the card gift requested by NPC_MAN1
jump_if_man1_requested_card_owned: MACRO
	run_command ScriptCommand_JumpIfMan1RequestedCardOwned
	dw \1 ; Script Label
ENDM

; Jumps to the given script position if the player's collection contains the card gift requested by NPC_MAN1
jump_if_man1_requested_card_in_collection: MACRO
	run_command ScriptCommand_JumpIfMan1RequestedCardInCollection
	dw \1 ; Script Label
ENDM

; Removes from the player's collection the card gift requested by NPC_MAN1
remove_man1_requested_card_from_collection: MACRO
	run_command ScriptCommand_RemoveMan1RequestedCardFromCollection
ENDM

; Jumps to a given script position
script_jump: MACRO
	run_command ScriptCommand_Jump
	dw \1 ; Script Label
ENDM

; Attempts to send Dr. Mason's PC Packs to the player
try_give_medal_pc_packs: MACRO
	run_command ScriptCommand_TryGiveMedalPCPacks
ENDM

; Causes the player to face the specified direction
set_player_direction: MACRO
	run_command ScriptCommand_SetPlayerDirection
	db \1 ; Direction (ex NORTH)
ENDM

; Moves the player
move_player: MACRO
	run_command ScriptCommand_MovePlayer
	db \1 ; Direction (ex NORTH)
	db \2 ; Speed
ENDM

; Shows a fullscreen image of a card and says the player has received it
show_card_received_screen: MACRO
	run_command ScriptCommand_ShowCardReceivedScreen
	db \1 ; Card received (ex LAPRAS)
ENDM

; Sets the active NPC
set_dialog_npc: MACRO
	run_command ScriptCommand_SetDialogNPC
	db \1 ; NPC (ex NPC_DRMASON)
ENDM

; Sets the active NPC and script. Not immediately executed.
set_next_npc_and_script: MACRO
	run_command ScriptCommand_SetNextNPCAndScript
	db \1 ; NPC (ex NPC_DRMASON)
	dw \2 ; Script Label
ENDM

; Sets some NPC sprite attributes
set_sprite_attributes: MACRO
	run_command ScriptCommand_SetSpriteAttributes
	db \1 ; Relates to LOADED_NPC_FIELD_06
	db \2 ; Relates to LOADED_NPC_FIELD_06
	db \3 ; Relates to LOADED_NPC_FIELD_05
ENDM

; Sets the active NPC's coords
set_active_npc_coords: MACRO
	run_command ScriptCommand_SetActiveNPCCoords
	db \1 ; X Coord
	db \2 ; Y Coord
ENDM

; Waits a number of frames
do_frames: MACRO
	run_command ScriptCommand_DoFrames
	db \1 ; Number of frames to wait
ENDM

; Jumps to a script position if the active NPC's X and Y match the given values
jump_if_active_npc_coords_match: MACRO
	run_command ScriptCommand_JumpIfActiveNPCCoordsMatch
	db \1 ; X Coord
	db \2 ; Y Coord
	dw \3 ; Script Label
ENDM

; Jumps to a script position if the player's X and Y match the given values
jump_if_player_coords_match: MACRO
	run_command ScriptCommand_JumpIfPlayerCoordsMatch
	db \1 ; X Coord
	db \2 ; Y Coord
	dw \3 ; Script Label
ENDM

; Moves the active NPC using an NPCMovement
move_active_npc: MACRO
	run_command ScriptCommand_MoveActiveNPC
	dw \1 ; NPCMovement (ex NPCMovement_d880)
ENDM

; Gives the player one of each booster pack with a trainer focus
give_one_of_each_trainer_booster: MACRO
	run_command ScriptCommand_GiveOneOfEachTrainerBooster
ENDM

; Jumps to a script position if the NPC is loaded
jump_if_npc_loaded: MACRO
	run_command ScriptCommand_JumpIfNPCLoaded
	db \1 ; NPC (ex NPC_DRMASON)
	dw \2 ; Script Label
ENDM

; Shows the medal received screen for the given master medal
show_medal_received_screen: MACRO
	run_command ScriptCommand_ShowMedalReceivedScreen
	db \1 ; medal event (ex EVENT_BEAT_NIKKI)
ENDM

; Loads the current map name into the given txram slot
load_current_map_name_into_txram_slot: MACRO
	run_command ScriptCommand_LoadCurrentMapNameIntoTxRamSlot
	db \1 ; TxRam slot
ENDM

; Loads the challenge hall opponent NPC name into the given txram slot
load_challenge_hall_npc_into_txram_slot: MACRO
	run_command ScriptCommand_LoadChallengeHallNPCIntoTxRamSlot
	db \1 ; TxRam slot
ENDM

; Begins a duel with the challenge hall opponent
; The deck and song arguments are overwritten when the duel is initialized
start_challenge_hall_duel: MACRO
	run_command ScriptCommand_StartChallengeHallDuel
	db \1 ; Prize Amount (ex PRIZES_2)
	db \2 ; Deck ID (ex SAMS_PRACTICE_DECK_ID)
	db \3 ; Duel Music (ex MUSIC_DUEL_THEME_1)
ENDM

; Prints the text based on the current challenge cup number
print_text_for_challenge_cup: MACRO
	run_command ScriptCommand_PrintTextForChallengeCup
	tx \1 ; Text Pointer for Challenge Cup #1
	tx \2 ; Text Pointer for Challenge Cup #2
	tx \3 ; Text Pointer for Challenge Cup #3
ENDM

; Moves the Challenge Hall opponent NPC using an NPCMovement
move_challenge_hall_npc: MACRO
	run_command ScriptCommand_MoveChallengeHallNPC
	dw \1 ; NPCMovement (ex NPCMovement_d880)
ENDM

; Unloads the Challenge Hall opponent NPC
unload_challenge_hall_npc: MACRO
	run_command ScriptCommand_UnloadChallengeHallNPC
ENDM

; Sets the Challenge Hall opponent NPC's coords
set_challenge_hall_npc_coords: MACRO
	run_command ScriptCommand_SetChallengeHallNPCCoords
	db \1 ; X Coord
	db \2 ; Y Coord
ENDM

; Picks the next Challenge Hall opponent NPC
pick_challenge_hall_opponent: MACRO
	run_command ScriptCommand_PickChallengeHallOpponent
ENDM

; Opens the pause menu
open_menu: MACRO
	run_command ScriptCommand_OpenMenu
ENDM

; Picks the Challenge Cup prize card
pick_challenge_cup_prize_card: MACRO
	run_command ScriptCommand_PickChallengeCupPrizeCard
ENDM

; Closes Advanced TextBoxes then Ends Script Loop
quit_script_fully: MACRO
	run_command ScriptCommand_QuitScriptFully
ENDM

; Replaces map blocks
; used for deck machines, challenge machine, Pokemon Dome doors, Hall of Honor doors etc
replace_map_blocks: MACRO
	run_command ScriptCommand_ReplaceMapBlocks
	db \1 ; id
ENDM

choose_deck_to_duel_against: MACRO
	run_command ScriptCommand_ChooseDeckToDuelAgainstMultichoice
ENDM

; Opens the deck machine
open_deck_machine: MACRO
	run_command ScriptCommand_OpenDeckMachine
	db \1 ; Deck Machine Type?
ENDM

choose_starter_deck: MACRO
	run_command ScriptCommand_ChooseStarterDeckMultichoice
ENDM

; Enters a given map screen
enter_map: MACRO
	run_command ScriptCommand_EnterMap
	db \1 ; Unused
	db \2 ; Room (ex MASON_LABORATORY)
	db \3 ; Player X
	db \4 ; Player Y
	db \5 ; Player Direction
ENDM

; Moves any NPC using an NPCMovement
move_npc: MACRO
	run_command ScriptCommand_MoveArbitraryNPC
	db \1 ; NPC (ex NPC_JOSHUA)
	dw \2 ; NPCMovement (NPCMovement_e2ab)
ENDM

; Picks the next legendary card
pick_legendary_card: MACRO
	run_command ScriptCommand_PickLegendaryCard
ENDM

; Flashes the screen to white
; if arg is non-zero, keep the screen white
; otherwise, fade the screen back in
flash_screen: MACRO
	run_command ScriptCommand_FlashScreen
	db \1 ; keep screen white?
ENDM

; Saves the game
; if arg is non-zero, save the player in MASON_LABORATORY
; otherwise, save the player in their current location
save_game: MACRO
	run_command ScriptCommand_SaveGame
	db \1 ; send to MASON_LABORATORY?
ENDM

; Loads the Battle Center
battle_center: MACRO
	run_command ScriptCommand_BattleCenter
ENDM

; Loads the Gift Center
; if arg is zero, display the options selection menu
; otherwise, execute the player's previously chosen selection
gift_center: MACRO
	run_command ScriptCommand_GiftCenter
	db \1 ; execute selection?
ENDM

; Plays the credits
play_credits: MACRO
	run_command ScriptCommand_PlayCredits
ENDM

; Tries to give the player a specific PC Pack from Dr. Mason
try_give_pc_pack: MACRO
	run_command ScriptCommand_TryGivePCPack
	db \1 ; PC Pack Index
ENDM

; Nothing.
script_nop: MACRO
	run_command ScriptCommand_nop
ENDM

; Gives the player their previously chosen starter deck
give_stater_deck: MACRO
	run_command ScriptCommand_GiveStarterDeck
ENDM

; Walks the player across the overworld map to MASON_LABORATORY
walk_player_to_mason_lab: MACRO
	run_command ScriptCommand_WalkPlayerToMasonLaboratory
ENDM

; Plays a song and saves it to wd112
override_song: MACRO
	run_command ScriptCommand_OverrideSong
	db \1 ; Song ID (ex MUSIC_BOOSTER_PACK)
ENDM

; Sets the default song for the overworld
set_default_song: MACRO
	run_command ScriptCommand_SetDefaultSong
	db \1 ; Song ID (ex MUSIC_BOOSTER_PACK)
ENDM

; Plays a song
play_song: MACRO
	run_command ScriptCommand_PlaySong
	db \1 ; Song ID (ex MUSIC_BOOSTER_PACK)
ENDM

; Plays a sound effect
play_sfx: MACRO
	run_command ScriptCommand_PlaySFX
	db \1 ; Sound Effect (ex SFX_56)
ENDM

; Pauses the current song
pause_song: MACRO
	run_command ScriptCommand_PauseSong
ENDM

; Resumes the current song
resume_song: MACRO
	run_command ScriptCommand_ResumeSong
ENDM

; Plays the default overworld song
play_default_song: MACRO
	run_command ScriptCommand_PlayDefaultSong
ENDM

; Waits for the current song to finish
wait_for_song_to_finish: MACRO
	run_command ScriptCommand_WaitForSongToFinish
ENDM

; Records when the player defeats a master (the 8 Club Masters or the Ronald Grand Master duel)
; the order of wins is stored in wd3bb
; the purpose of this is still unknown
record_master_win: MACRO
	run_command ScriptCommand_RecordMasterWin
	db \1 ; which master duel
ENDM

; Asks the player a question then jumps
ask_question_jump_default_yes: MACRO
	run_command ScriptCommand_AskQuestionJumpDefaultYes
IF ISCONST(\1)
	dw \1 ; NULL
ELSE
	tx \1 ; Text Pointer
ENDC
	dw \2 ; Script Label
ENDM

show_sam_normal_multichoice: MACRO
	run_command ScriptCommand_ShowSamNormalMultichoice
ENDM

show_sam_rules_multichoice: MACRO
	run_command ScriptCommand_ShowSamRulesMultichoice
ENDM

; Runs the Challenge Machine
challenge_machine: MACRO
	run_command ScriptCommand_ChallengeMachine
ENDM

; Sets an event's value
set_event: MACRO
	run_command ScriptCommand_SetEventValue
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; new value
ENDM

; Jumps to a script position if a given event is zero
jump_if_event_zero: MACRO
	run_command ScriptCommand_JumpIfEventZero
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	dw \2 ; Script Label
ENDM

; Jumps to a script position if a given event is nonzero
jump_if_event_nonzero: MACRO
	run_command ScriptCommand_JumpIfEventNonzero
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	dw \2 ; Script Label
ENDM

; Jumps to a script position if an event matches given value
jump_if_event_equal: MACRO
	run_command ScriptCommand_JumpIfEventEqual
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw \3 ; Script Label
ENDM

; Jumps to a script position if an event does not match a given value
jump_if_event_not_equal: MACRO
	run_command ScriptCommand_JumpIfEventNotEqual
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw \3 ; Script Label
ENDM

; Jumps to a script position if an event is greater than or equal to a given value
jump_if_event_greater_or_equal: MACRO
	run_command ScriptCommand_JumpIfEventGreaterOrEqual
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw \3 ; Script Label
ENDM

; Jumps to a script position if an event is less than a given value
jump_if_event_less_than: MACRO
	run_command ScriptCommand_JumpIfEventLessThan
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
	db \2 ; value
	dw \3 ; Script Label
ENDM

; Sets an event to its maximum possible value
max_out_event_value: MACRO
	run_command ScriptCommand_MaxOutEventValue
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
ENDM

; Sets an event's value to zero
zero_out_event_value: MACRO
	run_command ScriptCommand_ZeroOutEventValue
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
ENDM

; Jumps to a script position if an event is true
jump_if_event_true: MACRO
	run_command ScriptCommand_JumpIfEventTrue
	db \1 ; event (ex EVENT_RECEIVED_LEGENDARY_CARDS)
	dw \2 ; Script Label
ENDM

; Jumps to a script position if an event is false
jump_if_event_false: MACRO
	run_command ScriptCommand_JumpIfEventFalse
	db \1 ; event (ex EVENT_RECEIVED_LEGENDARY_CARDS)
	dw \2 ; Script Label
ENDM

; Increments given event's value (truncates the new value)
increment_event_value: MACRO
	run_command ScriptCommand_IncrementEventValue
	db \1 ; event (ex EVENT_IMAKUNI_WIN_COUNT)
ENDM
