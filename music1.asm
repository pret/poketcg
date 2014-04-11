Func_f4000: ; f4000 (3d:4000)
	jp $407d

Func_f4003: ; f4003 (3d:4003)
	jp $40e9
; 0xf4006

INCBIN "baserom.gbc",$f4006,$f4ee6 - $f4006

SongBanks1: ; f4ee6 (3d:4ee6)
	db BANK(Music_Stop)
	db BANK(Music_TitleScreen)
	db BANK(Music_BattleTheme1)
	db BANK(Music_BattleTheme2)
	db BANK(Music_BattleTheme3)
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
	db BANK(Music_DarkDiddly)
	db BANK(Music_Unused1b)
	db BANK(Music_BoosterPack)
	db BANK(Music_Medal)
	db BANK(Music_Unused1e)

SongHeaderPointers1: ; f4f05 (3d:4f05)
	dw Music_Stop
	dw Music_TitleScreen
	dw Music_BattleTheme1
	dw Music_BattleTheme2
	dw Music_BattleTheme3
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
	dw Music_DarkDiddly
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

Music_BattleTheme1: ; f4f4d (3d:4f4d)
	db %1111
	dw Music_BattleTheme1_Ch1
	dw Music_BattleTheme1_Ch2
	dw Music_BattleTheme1_Ch3
	dw Music_BattleTheme1_Ch4

Music_BattleTheme2: ; f4f56 (3d:4f56)
	db %1111
	dw Music_BattleTheme2_Ch1
	dw Music_BattleTheme2_Ch2
	dw Music_BattleTheme2_Ch3
	dw Music_BattleTheme2_Ch4

Music_BattleTheme3: ; f4f5f (3d:4f5f)
	db %1111
	dw Music_BattleTheme3_Ch1
	dw Music_BattleTheme3_Ch2
	dw Music_BattleTheme3_Ch3
	dw Music_BattleTheme3_Ch4

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

Music_DarkDiddly: ; f5025 (3d:5025)
	db %0111
	dw Music_DarkDiddly_Ch1
	dw Music_DarkDiddly_Ch2
	dw Music_DarkDiddly_Ch3
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

Music_TitleScreen_Ch1: ; f5052 (3d:5052)
INCBIN "baserom.gbc",$f5052,$f5193 - $f5052

Music_TitleScreen_Ch2: ; f5193 (3d:5193)
INCBIN "baserom.gbc",$f5193,$f5286 - $f5193

Music_TitleScreen_Ch3: ; f5286 (3d:5286)
INCBIN "baserom.gbc",$f5286,$f52fa - $f5286

Music_TitleScreen_Ch4: ; f52fa (3d:52fa)
INCBIN "baserom.gbc",$f52fa,$f532a - $f52fa

Music_BattleTheme1_Ch1: ; f532a (3d:532a)
INCBIN "baserom.gbc",$f532a,$f55e7 - $f532a

Music_BattleTheme1_Ch2: ; f55e7 (3d:55e7)
INCBIN "baserom.gbc",$f55e7,$f5a32 - $f55e7

Music_BattleTheme1_Ch3: ; f5a32 (3d:5a32)
INCBIN "baserom.gbc",$f5a32,$f5c9a - $f5a32

Music_BattleTheme1_Ch4: ; f5c9a (3d:5c9a)
INCBIN "baserom.gbc",$f5c9a,$f5d68 - $f5c9a

Music_BattleTheme2_Ch1: ; f5d68 (3d:5d68)
INCBIN "baserom.gbc",$f5d68,$f5fad - $f5d68

Music_BattleTheme2_Ch2: ; f5fad (3d:5fad)
INCBIN "baserom.gbc",$f5fad,$f61ac - $f5fad

Music_BattleTheme2_Ch3: ; f61ac (3d:61ac)
INCBIN "baserom.gbc",$f61ac,$f62f3 - $f61ac

Music_BattleTheme2_Ch4: ; f62f3 (3d:62f3)
INCBIN "baserom.gbc",$f62f3,$f63a1 - $f62f3

Music_BattleTheme3_Ch1: ; f63a1 (3d:63a1)
INCBIN "baserom.gbc",$f63a1,$f6649 - $f63a1

Music_BattleTheme3_Ch2: ; f6649 (3d:6649)
INCBIN "baserom.gbc",$f6649,$f68c2 - $f6649

Music_BattleTheme3_Ch3: ; f68c2 (3d:68c2)
INCBIN "baserom.gbc",$f68c2,$f6a3f - $f68c2

Music_BattleTheme3_Ch4: ; f6a3f (3d:6a3f)
INCBIN "baserom.gbc",$f6a3f,$f6bb7 - $f6a3f

Music_PauseMenu_Ch2: ; f6bb7 (3d:6bb7)
INCBIN "baserom.gbc",$f6bb7,$f6d4e - $f6bb7

Music_PauseMenu_Ch1: ; f6d4e (3d:6d4e)
INCBIN "baserom.gbc",$f6d4e,$f6e2d - $f6d4e

Music_PauseMenu_Ch3: ; f6e2d (3d:6e2d)
INCBIN "baserom.gbc",$f6e2d,$f6ec8 - $f6e2d

Music_PauseMenu_Ch4: ; f6ec8 (3d:6ec8)
INCBIN "baserom.gbc",$f6ec8,$f6ef1 - $f6ec8

Music_DeckMachine_Ch1: ; f6ef1 (3d:6ef1)
INCBIN "baserom.gbc",$f6ef1,$f6f41 - $f6ef1

Music_DeckMachine_Ch2: ; f6f41 (3d:6f41)
INCBIN "baserom.gbc",$f6f41,$f6f7b - $f6f41

Music_DeckMachine_Ch3: ; f6f7b (3d:6f7b)
INCBIN "baserom.gbc",$f6f7b,$f7018 - $f6f7b

Music_DeckMachine_Ch4: ; f7018 (3d:7018)
INCBIN "baserom.gbc",$f7018,$f703a - $f7018

Music_CardPop_Ch1: ; f703a (3d:703a)
INCBIN "baserom.gbc",$f703a,$f70df - $f703a

Music_CardPop_Ch2: ; f70df (3d:70df)
INCBIN "baserom.gbc",$f70df,$f713a - $f70df

Music_CardPop_Ch3: ; f713a (3d:713a)
INCBIN "baserom.gbc",$f713a,$f717d - $f713a

Music_CardPop_Ch4: ; f717d (3d:717d)
INCBIN "baserom.gbc",$f717d,$f71a0 - $f717d

Music_Overworld_Ch1: ; f71a0 (3d:71a0)
INCBIN "baserom.gbc",$f71a0,$f7334 - $f71a0

Music_Overworld_Ch2: ; f7334 (3d:7334)
INCBIN "baserom.gbc",$f7334,$f75a1 - $f7334

Music_Overworld_Ch3: ; f75a1 (3d:75a1)
INCBIN "baserom.gbc",$f75a1,$f78af - $f75a1

Music_Overworld_Ch4: ; f78af (3d:78af)
INCBIN "baserom.gbc",$f78af,$f7919 - $f78af

Music_MatchStart1_Ch1: ; f7919 (3d:7919)
INCBIN "baserom.gbc",$f7919,$f7956 - $f7919

Music_MatchStart2_Ch1: ; f7956 (3d:7956)
INCBIN "baserom.gbc",$f7956,$f79b4 - $f7956

Music_MatchStart2_Ch2: ; f79b4 (3d:79b4)
INCBIN "baserom.gbc",$f79b4,$f7a0f - $f79b4

Music_MatchStart3_Ch1: ; f7a0f (3d:7a0f)
INCBIN "baserom.gbc",$f7a0f,$f7aba - $f7a0f

Music_MatchStart3_Ch2: ; f7aba (3d:7aba)
INCBIN "baserom.gbc",$f7aba,$f7b61 - $f7aba

Music_MatchVictory_Ch1: ; f7b61 (3d:7b61)
INCBIN "baserom.gbc",$f7b61,$f7bb0 - $f7b61

Music_MatchVictory_Ch2: ; f7bb0 (3d:7bb0)
INCBIN "baserom.gbc",$f7bb0,$f7c09 - $f7bb0

Music_MatchVictory_Ch3: ; f7c09 (3d:7c09)
INCBIN "baserom.gbc",$f7c09,$f7c2e - $f7c09

Music_MatchLoss_Ch1: ; f7c2e (3d:7c2e)
INCBIN "baserom.gbc",$f7c2e,$f7c87 - $f7c2e

Music_MatchLoss_Ch2: ; f7c87 (3d:7c87)
INCBIN "baserom.gbc",$f7c87,$f7ca7 - $f7c87

Music_MatchLoss_Ch3: ; f7ca7 (3d:7ca7)
INCBIN "baserom.gbc",$f7ca7,$f7cdf - $f7ca7

Music_DarkDiddly_Ch1: ; f7cdf (3d:7cdf)
INCBIN "baserom.gbc",$f7cdf,$f7d17 - $f7cdf

Music_DarkDiddly_Ch2: ; f7d17 (3d:7d17)
INCBIN "baserom.gbc",$f7d17,$f7d47 - $f7d17

Music_DarkDiddly_Ch3: ; f7d47 (3d:7d47)
INCBIN "baserom.gbc",$f7d47,$f7d60 - $f7d47

Music_BoosterPack_Ch1: ; f7d60 (3d:7d60)
INCBIN "baserom.gbc",$f7d60,$f7d9e - $f7d60

Music_BoosterPack_Ch2: ; f7d9e (3d:7d9e)
INCBIN "baserom.gbc",$f7d9e,$f7ddb - $f7d9e

Music_BoosterPack_Ch3: ; f7ddb (3d:7ddb)
INCBIN "baserom.gbc",$f7ddb,$f7df8 - $f7ddb

Music_Medal_Ch1: ; f7df8 (3d:7df8)
INCBIN "baserom.gbc",$f7df8,$f7e4b - $f7df8

Music_Medal_Ch2: ; f7e4b (3d:7e4b)
INCBIN "baserom.gbc",$f7e4b,$f7e9D - $f7e4b

Music_Medal_Ch3: ; f7e9D (3d:7e9D)
INCBIN "baserom.gbc",$f7e9d,$f8000 - $f7e9d