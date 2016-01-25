hBankROM                    EQU $FF80
hBankRAM                    EQU $FF81
hBankVRAM                   EQU $FF82

hDMAFunction                EQU $FF83

hDPadRepeat                 EQU $FF8D
hButtonsReleased            EQU $FF8E
hButtonsPressed2            EQU $FF8F
hButtonsHeld                EQU $FF90
hButtonsPressed             EQU $FF91

hSCX                        EQU $FF92
hSCY                        EQU $FF93
hWX                         EQU $FF94
hWY                         EQU $FF95

; $c2 = player ; $c3 = opponent
hWhoseTurn                  EQU $FF97
