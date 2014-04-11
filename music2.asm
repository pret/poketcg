INCBIN "baserom.gbc",$f8000,$f8ee6 - $f8000

SongBanks2: ; f8ee6 (3e:4ee6)
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

;Music_BattleTheme1
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_BattleTheme2
	db %0000
	dw $0000
	dw $0000
	dw $0000
	dw $0000

;Music_BattleTheme3
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
	dw Music_PCMainMenu_Ch1 ; 5052
	dw Music_PCMainMenu_Ch2 ; 50ED
	dw Music_PCMainMenu_Ch3 ; 5189
	dw Music_PCMainMenu_Ch4 ; 522B

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
	dw Music_PokemonDome_Ch1 ; 5251
	dw Music_PokemonDome_Ch2 ; 53F8
	dw Music_PokemonDome_Ch3 ; 5579
	dw Music_PokemonDome_Ch4 ; 5629

Music_ChallengeHall: ; f8f9e (3e:4f9e)
	db %1111
	dw Music_ChallengeHall_Ch1 ; 5646
	dw Music_ChallengeHall_Ch2 ; 5883
	dw Music_ChallengeHall_Ch3 ; 5a92
	dw Music_ChallengeHall_Ch4 ; 5bA9

Music_Club1: ; f8fa7 (3e:4fa7)
	db %1111
	dw Music_Club1_Ch1 ; 5bE5
	dw Music_Club1_Ch2 ; 5d5F
	dw Music_Club1_Ch3 ; 5eC4
	dw Music_Club1_Ch4 ; 6044

Music_Club2: ; f8fb0 (3e:4fb0)
	db %0111
	dw Music_Club2_Ch1 ; 6077
	dw Music_Club2_Ch2 ; 60E3
	dw Music_Club2_Ch3 ; 6164
	dw $0000

Music_Club3: ; f8fb9 (3e:4fb9)
	db %1111
	dw Music_Club3_Ch1 ; 6210
	dw Music_Club3_Ch2 ; 6423
	dw Music_Club3_Ch3 ; 663E
	dw Music_Club3_Ch4 ; 6772

Music_Ronald: ; f8fc2 (3e:4fc2)
	db %1111
	dw Music_Ronald_Ch1 ; 67A0
	dw Music_Ronald_Ch2 ; 6a0E
	dw Music_Ronald_Ch3 ; 6bC0
	dw Music_Ronald_Ch4 ; 6cE0

Music_Imakuni: ; f8fcb (3e:4fcb)
	db %1111
	dw Music_Imakuni_Ch1 ; 6d55
	dw Music_Imakuni_Ch2 ; 6e32
	dw Music_Imakuni_Ch3 ; 6eBC
	dw Music_Imakuni_Ch4 ; 6fA4

Music_HallOfHonor: ; f8fd4 (3e:4fd4)
	db %0111
	dw Music_HallOfHonor_Ch1 ; 6fEA
	dw Music_HallOfHonor_Ch2 ; 706E
	dw Music_HallOfHonor_Ch3 ; 70D5
	dw $0000

Music_Credits: ; f8fdd (3e:4fdd)
	db %1111
	dw Music_Credits_Ch1 ; 71FE
	dw Music_Credits_Ch2 ; 768A
	dw Music_Credits_Ch3 ; 7b9D
	dw Music_Credits_Ch4 ; 7e51

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

;Music_DarkDiddly
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

Music_PCMainMenu_Ch1: ; f9052 (3e:5052)
INCBIN "baserom.gbc",$f9052,$f90ed - $f9052

Music_PCMainMenu_Ch2: ; f90ed (3e:50ed)
INCBIN "baserom.gbc",$f90ed,$f9189 - $f90ed

Music_PCMainMenu_Ch3: ; f9189 (3e:5189)
INCBIN "baserom.gbc",$f9189,$f922b - $f9189

Music_PCMainMenu_Ch4: ; f922b (3e:522b)
INCBIN "baserom.gbc",$f922b,$f9251 - $f922b

Music_PokemonDome_Ch1: ; f9251 (3e:5251)
INCBIN "baserom.gbc",$f9251,$f93f8 - $f9251

Music_PokemonDome_Ch2: ; f93f8 (3e:53f8)
INCBIN "baserom.gbc",$f93f8,$f9579 - $f93f8

Music_PokemonDome_Ch3: ; f9579 (3e:5579)
INCBIN "baserom.gbc",$f9579,$f9629 - $f9579

Music_PokemonDome_Ch4: ; f9629 (3e:5629)
INCBIN "baserom.gbc",$f9629,$f9646 - $f9629

Music_ChallengeHall_Ch1: ; f9646 (3e:5646)
INCBIN "baserom.gbc",$f9646,$f9883 - $f9646

Music_ChallengeHall_Ch2: ; f9883 (3e:5883)
INCBIN "baserom.gbc",$f9883,$f9a92 - $f9883

Music_ChallengeHall_Ch3: ; f9a92 (3e:5a92)
INCBIN "baserom.gbc",$f9a92,$f9ba9 - $f9a92

Music_ChallengeHall_Ch4: ; f9ba9 (3e:5ba9)
INCBIN "baserom.gbc",$f9ba9,$f9be5 - $f9ba9

Music_Club1_Ch1: ; f9be5 (3e:5be5)
INCBIN "baserom.gbc",$f9be5,$f9d5f - $f9be5

Music_Club1_Ch2: ; f9d5f (3e:5d5f)
INCBIN "baserom.gbc",$f9d5f,$f9ec4 - $f9d5f

Music_Club1_Ch3: ; f9ec4 (3e:5ec4)
INCBIN "baserom.gbc",$f9ec4,$fa044 - $f9ec4

Music_Club1_Ch4: ; fa044 (3e:6044)
INCBIN "baserom.gbc",$fa044,$fa077 - $fa044

Music_Club2_Ch1: ; fa077 (3e:6077)
INCBIN "baserom.gbc",$fa077,$fa0e3 - $fa077

Music_Club2_Ch2: ; fa0e3 (3e:60e3)
INCBIN "baserom.gbc",$fa0e3,$fa164 - $fa0e3

Music_Club2_Ch3: ; fa164 (3e:6164)
INCBIN "baserom.gbc",$fa164,$fa210 - $fa164

Music_Club3_Ch1: ; fa210 (3e:6210)
INCBIN "baserom.gbc",$fa210,$fa423 - $fa210

Music_Club3_Ch2: ; fa423 (3e:6423)
INCBIN "baserom.gbc",$fa423,$fa63e - $fa423

Music_Club3_Ch3: ; fa63e (3e:663e)
INCBIN "baserom.gbc",$fa63e,$fa772 - $fa63e

Music_Club3_Ch4: ; fa772 (3e:6772)
INCBIN "baserom.gbc",$fa772,$fa7a0 - $fa772

Music_Ronald_Ch1: ; fa7a0 (3e:67a0)
INCBIN "baserom.gbc",$fa7a0,$faa0e - $fa7a0

Music_Ronald_Ch2: ; faa0e (3e:6a0e)
INCBIN "baserom.gbc",$faa0e,$fabC0 - $faa0e

Music_Ronald_Ch3: ; fabC0 (3e:6bC0)
INCBIN "baserom.gbc",$fabC0,$face0 - $fabC0

Music_Ronald_Ch4: ; face0 (3e:6ce0)
INCBIN "baserom.gbc",$face0,$fad55 - $face0

Music_Imakuni_Ch1: ; fad55 (3e:6d55)
INCBIN "baserom.gbc",$fad55,$fae32 - $fad55

Music_Imakuni_Ch2: ; fae32 (3e:6e32)
INCBIN "baserom.gbc",$fae32,$faebc - $fae32

Music_Imakuni_Ch3: ; faebc (3e:6ebc)
INCBIN "baserom.gbc",$faebc,$fafa4 - $faebc

Music_Imakuni_Ch4: ; fafa4 (3e:6fa4)
INCBIN "baserom.gbc",$fafa4,$fafea - $fafa4

Music_HallOfHonor_Ch1: ; fafea (3e:6fea)
INCBIN "baserom.gbc",$fafea,$fb06e - $fafea

Music_HallOfHonor_Ch2: ; fb06e (3e:706e)
INCBIN "baserom.gbc",$fb06e,$fb0d5 - $fb06e

Music_HallOfHonor_Ch3: ; fb0d5 (3e:70d5)
INCBIN "baserom.gbc",$fb0d5,$fb1fe - $fb0d5

Music_Credits_Ch1: ; fb1fe (3e:71fe)
INCBIN "baserom.gbc",$fb1fe,$fb68a - $fb1fe

Music_Credits_Ch2: ; fb68a (3e:768a)
INCBIN "baserom.gbc",$fb68a,$fbb9d - $fb68a

Music_Credits_Ch3: ; fbb9d (3e:7b9d)
INCBIN "baserom.gbc",$fbb9d,$fbe51 - $fbb9d

Music_Credits_Ch4: ; fbe51 (3e:7e51)
INCBIN "baserom.gbc",$fbe51,$fc000 - $fbe51