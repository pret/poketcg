NumberOfSongs1: ; f4ee5 (3d:4ee5)
	db $1f

SongBanks1: ; f4ee6 (3d:4ee6)
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

SongHeaderPointers1: ; f4f05 (3d:4f05)
	dw Music_Stop
	dw Music_TitleScreen
	dw Music_DuelTheme1
	dw Music_DuelTheme2
	dw Music_DuelTheme3
	dw Music_PauseMenu
	dw $0000
	dw Music_DeckMachine
	dw Music_CardPop
	dw Music_Overworld
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
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

Music_Stop: ; f4f43 (3d:4f43)
	db %0000

Music_TitleScreen: ; f4f44 (3d:4f44)
	db %1111
	dw Music_TitleScreen_Ch1
	dw Music_TitleScreen_Ch2
	dw Music_TitleScreen_Ch3
	dw Music_TitleScreen_Ch4

Music_DuelTheme1: ; f4f4d (3d:4f4d)
	db %1111
	dw Music_DuelTheme1_Ch1
	dw Music_DuelTheme1_Ch2
	dw Music_DuelTheme1_Ch3
	dw Music_DuelTheme1_Ch4

Music_DuelTheme2: ; f4f56 (3d:4f56)
	db %1111
	dw Music_DuelTheme2_Ch1
	dw Music_DuelTheme2_Ch2
	dw Music_DuelTheme2_Ch3
	dw Music_DuelTheme2_Ch4

Music_DuelTheme3: ; f4f5f (3d:4f5f)
	db %1111
	dw Music_DuelTheme3_Ch1
	dw Music_DuelTheme3_Ch2
	dw Music_DuelTheme3_Ch3
	dw Music_DuelTheme3_Ch4

Music_PauseMenu: ; f4f68 (3d:4f68)
	db %1111
	dw Music_PauseMenu_Ch1
	dw Music_PauseMenu_Ch2
	dw Music_PauseMenu_Ch3
	dw Music_PauseMenu_Ch4

;Music_PCMainMenu
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_DeckMachine: ; f4f7a (3d:4f7a)
	db %1111
	dw Music_DeckMachine_Ch1
	dw Music_DeckMachine_Ch2
	dw Music_DeckMachine_Ch3
	dw Music_DeckMachine_Ch4

Music_CardPop: ; f4f83 (3d:4f83)
	db %1111
	dw Music_CardPop_Ch1
	dw Music_CardPop_Ch2
	dw Music_CardPop_Ch3
	dw Music_CardPop_Ch4

Music_Overworld: ; f4f8c (3d:4f8c)
	db %1111
	dw Music_Overworld_Ch1
	dw Music_Overworld_Ch2
	dw Music_Overworld_Ch3
	dw Music_Overworld_Ch4

;Music_PokemonDome
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_ChallengeHall
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Club1
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Club2
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Club3
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Ronald
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Imakuni
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_HallOfHonor
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Credits
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_Unused13: ; f4fe6 (3d:4fe6)
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_Unused14: ; f4fef (3d:4fef)
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_MatchStart1: ; f4ff8 (3d:4ff8)
	db %0001
	dw Music_MatchStart1_Ch1
	dw $0000
	dw $0000
	dw $0000

Music_MatchStart2: ; f5001 (3d:5001)
	db %0011
	dw Music_MatchStart2_Ch1
	dw Music_MatchStart2_Ch2
	dw $0000
	dw $0000

Music_MatchStart3: ; f500a (3d:500a)
	db %0011
	dw Music_MatchStart3_Ch1
	dw Music_MatchStart3_Ch2
	dw $0000
	dw $0000

Music_MatchVictory: ; f5013 (3d:5013)
	db %0111
	dw Music_MatchVictory_Ch1
	dw Music_MatchVictory_Ch2
	dw Music_MatchVictory_Ch3
	dw $0000

Music_MatchLoss: ; f501c (3d:501c)
	db %0111
	dw Music_MatchLoss_Ch1
	dw Music_MatchLoss_Ch2
	dw Music_MatchLoss_Ch3
	dw $0000

Music_MatchDraw: ; f5025 (3d:5025)
	db %0111
	dw Music_MatchDraw_Ch1
	dw Music_MatchDraw_Ch2
	dw Music_MatchDraw_Ch3
	dw $0000

Music_Unused1b: ; f502e (3d:502e)
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_BoosterPack: ; f5037 (3d:5037)
	db %0111
	dw Music_BoosterPack_Ch1
	dw Music_BoosterPack_Ch2
	dw Music_BoosterPack_Ch3
	dw $0000

Music_Medal: ; f5040 (3d:5040)
	db %0111
	dw Music_Medal_Ch1
	dw Music_Medal_Ch2
	dw Music_Medal_Ch3
	dw $0000

Music_Unused1e: ; f5049 (3d:5049)
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
