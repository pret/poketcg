NumberOfSongs1:
	db $1f

SongBanks1:
	table_width 1, SongBanks1
	db BANK(Music_Stop)
	db BANK(Music_TitleScreen)
	db BANK(Music_DuelTheme1)
	db BANK(Music_DuelTheme2)
	db BANK(Music_DuelTheme3)
	db BANK(Music_PauseMenu)
	db BANK(Music_PCMainMenu)
	db BANK(Music_DeckMachine)
	db BANK(Music_CardPop)
	db BANK(Music_Overworld)
	db BANK(Music_PokemonDome)
	db BANK(Music_ChallengeHall)
	db BANK(Music_Club1)
	db BANK(Music_Club2)
	db BANK(Music_Club3)
	db BANK(Music_Ronald)
	db BANK(Music_Imakuni)
	db BANK(Music_HallOfHonor)
	db BANK(Music_Credits)
	db BANK(Music_Unused13)
	db BANK(Music_Unused14)
	db BANK(Music_MatchStart1)
	db BANK(Music_MatchStart2)
	db BANK(Music_MatchStart3)
	db BANK(Music_MatchVictory)
	db BANK(Music_MatchLoss)
	db BANK(Music_MatchDraw)
	db BANK(Music_Unused1b)
	db BANK(Music_BoosterPack)
	db BANK(Music_Medal)
	db BANK(Music_Unused1e)
	assert_table_length NUM_SONGS

SongHeaderPointers1:
	table_width 2, SongHeaderPointers1
	dw Music_Stop
	dw Music_TitleScreen
	dw Music_DuelTheme1
	dw Music_DuelTheme2
	dw Music_DuelTheme3
	dw Music_PauseMenu
	dw NULL
	dw Music_DeckMachine
	dw Music_CardPop
	dw Music_Overworld
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw NULL
	dw Music_Unused13
	dw Music_Unused14
	dw Music_MatchStart1
	dw Music_MatchStart2
	dw Music_MatchStart3
	dw Music_MatchVictory
	dw Music_MatchLoss
	dw Music_MatchDraw
	dw Music_Unused1b
	dw Music_BoosterPack
	dw Music_Medal
	dw Music_Unused1e
	assert_table_length NUM_SONGS

Music_Stop:
	db %0000

Music_TitleScreen:
	db %1111
	dw Music_TitleScreen_Ch1
	dw Music_TitleScreen_Ch2
	dw Music_TitleScreen_Ch3
	dw Music_TitleScreen_Ch4

Music_DuelTheme1:
	db %1111
	dw Music_DuelTheme1_Ch1
	dw Music_DuelTheme1_Ch2
	dw Music_DuelTheme1_Ch3
	dw Music_DuelTheme1_Ch4

Music_DuelTheme2:
	db %1111
	dw Music_DuelTheme2_Ch1
	dw Music_DuelTheme2_Ch2
	dw Music_DuelTheme2_Ch3
	dw Music_DuelTheme2_Ch4

Music_DuelTheme3:
	db %1111
	dw Music_DuelTheme3_Ch1
	dw Music_DuelTheme3_Ch2
	dw Music_DuelTheme3_Ch3
	dw Music_DuelTheme3_Ch4

Music_PauseMenu:
	db %1111
	dw Music_PauseMenu_Ch1
	dw Music_PauseMenu_Ch2
	dw Music_PauseMenu_Ch3
	dw Music_PauseMenu_Ch4

;Music_PCMainMenu
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

Music_DeckMachine:
	db %1111
	dw Music_DeckMachine_Ch1
	dw Music_DeckMachine_Ch2
	dw Music_DeckMachine_Ch3
	dw Music_DeckMachine_Ch4

Music_CardPop:
	db %1111
	dw Music_CardPop_Ch1
	dw Music_CardPop_Ch2
	dw Music_CardPop_Ch3
	dw Music_CardPop_Ch4

Music_Overworld:
	db %1111
	dw Music_Overworld_Ch1
	dw Music_Overworld_Ch2
	dw Music_Overworld_Ch3
	dw Music_Overworld_Ch4

;Music_PokemonDome
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

;Music_ChallengeHall
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

;Music_Club1
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

;Music_Club2
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

;Music_Club3
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

;Music_Ronald
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

;Music_Imakuni
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

;Music_HallOfHonor
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

;Music_Credits
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

Music_Unused13:
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

Music_Unused14:
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

Music_MatchStart1:
	db %0001
	dw Music_MatchStart1_Ch1
	dw NULL
	dw NULL
	dw NULL

Music_MatchStart2:
	db %0011
	dw Music_MatchStart2_Ch1
	dw Music_MatchStart2_Ch2
	dw NULL
	dw NULL

Music_MatchStart3:
	db %0011
	dw Music_MatchStart3_Ch1
	dw Music_MatchStart3_Ch2
	dw NULL
	dw NULL

Music_MatchVictory:
	db %0111
	dw Music_MatchVictory_Ch1
	dw Music_MatchVictory_Ch2
	dw Music_MatchVictory_Ch3
	dw NULL

Music_MatchLoss:
	db %0111
	dw Music_MatchLoss_Ch1
	dw Music_MatchLoss_Ch2
	dw Music_MatchLoss_Ch3
	dw NULL

Music_MatchDraw:
	db %0111
	dw Music_MatchDraw_Ch1
	dw Music_MatchDraw_Ch2
	dw Music_MatchDraw_Ch3
	dw NULL

Music_Unused1b:
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL

Music_BoosterPack:
	db %0111
	dw Music_BoosterPack_Ch1
	dw Music_BoosterPack_Ch2
	dw Music_BoosterPack_Ch3
	dw NULL

Music_Medal:
	db %0111
	dw Music_Medal_Ch1
	dw Music_Medal_Ch2
	dw Music_Medal_Ch3
	dw NULL

Music_Unused1e:
	db %0000
	dw NULL
	dw NULL
	dw NULL
	dw NULL
