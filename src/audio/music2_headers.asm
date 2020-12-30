NumberOfSongs2: ; f8ee5 (3e:4ee5)
	db $1f

SongBanks2: ; f8ee6 (3e:4ee6)
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

SongHeaderPointers2: ; f8f05 (3e:4f05)
	dw Music_Stop
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw Music_PCMainMenu
	dw $0000
	dw $0000
	dw $0000
	dw Music_PokemonDome
	dw Music_ChallengeHall
	dw Music_Club1
	dw Music_Club2
	dw Music_Club3
	dw Music_Ronald
	dw Music_Imakuni
	dw Music_HallOfHonor
	dw Music_Credits
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Stop
	db %0000

;Music_TitleScreen
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_DuelTheme1
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_DuelTheme2
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_DuelTheme3
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_PauseMenu
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_PCMainMenu: ; f8f71 (3e:4f71)
	db %1111
	dw Music_PCMainMenu_Ch1
	dw Music_PCMainMenu_Ch2
	dw Music_PCMainMenu_Ch3
	dw Music_PCMainMenu_Ch4

;Music_DeckMachine
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_CardPop
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Overworld
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

Music_PokemonDome: ; f8f95 (3e:4f95)
	db %1111
	dw Music_PokemonDome_Ch1
	dw Music_PokemonDome_Ch2
	dw Music_PokemonDome_Ch3
	dw Music_PokemonDome_Ch4

Music_ChallengeHall: ; f8f9e (3e:4f9e)
	db %1111
	dw Music_ChallengeHall_Ch1
	dw Music_ChallengeHall_Ch2
	dw Music_ChallengeHall_Ch3
	dw Music_ChallengeHall_Ch4

Music_Club1: ; f8fa7 (3e:4fa7)
	db %1111
	dw Music_Club1_Ch1
	dw Music_Club1_Ch2
	dw Music_Club1_Ch3
	dw Music_Club1_Ch4

Music_Club2: ; f8fb0 (3e:4fb0)
	db %0111
	dw Music_Club2_Ch1
	dw Music_Club2_Ch2
	dw Music_Club2_Ch3
	dw $0000

Music_Club3: ; f8fb9 (3e:4fb9)
	db %1111
	dw Music_Club3_Ch1
	dw Music_Club3_Ch2
	dw Music_Club3_Ch3
	dw Music_Club3_Ch4

Music_Ronald: ; f8fc2 (3e:4fc2)
	db %1111
	dw Music_Ronald_Ch1
	dw Music_Ronald_Ch2
	dw Music_Ronald_Ch3
	dw Music_Ronald_Ch4

Music_Imakuni: ; f8fcb (3e:4fcb)
	db %1111
	dw Music_Imakuni_Ch1
	dw Music_Imakuni_Ch2
	dw Music_Imakuni_Ch3
	dw Music_Imakuni_Ch4

Music_HallOfHonor: ; f8fd4 (3e:4fd4)
	db %0111
	dw Music_HallOfHonor_Ch1
	dw Music_HallOfHonor_Ch2
	dw Music_HallOfHonor_Ch3
	dw $0000

Music_Credits: ; f8fdd (3e:4fdd)
	db %1111
	dw Music_Credits_Ch1
	dw Music_Credits_Ch2
	dw Music_Credits_Ch3
	dw Music_Credits_Ch4

;Music_Unused13
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Unused14
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchStart1
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchStart2
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchStart3
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchVictory
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchLoss
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_MatchDraw
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Unused1b
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_BoosterPack
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Medal
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_Unused1e
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000
