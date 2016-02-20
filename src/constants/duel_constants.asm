PLAYER_TURN   EQUS "wPlayerDuelVariables >> $8"
OPPONENT_TURN EQUS "wOpponentDuelVariables >> $8"

DUEL_WON  EQU $1
DUEL_LOST EQU $2
DUEL_DRAW EQU $3

DUELVARS_CARD_LOCATIONS                  EQUS "wPlayerCardLocations & $ff"              ; 00
DUELVARS_HAND                            EQUS "wPlayerHand & $ff"                       ; 42
DUELVARS_DECK_CARDS                      EQUS "wPlayerDeckCards & $ff"                  ; 7e
DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK     EQUS "wPlayerNumberOfCardsNotInDeck & $ff"     ; ba
DUELVARS_ARENA_CARD                      EQUS "wPlayerArenaCard & $ff"                  ; bb
DUELVARS_BENCH                           EQUS "wPlayerBench & $ff"                      ; bc
DUELVARS_ARENA_CARD_HP                   EQUS "wPlayerArenaCardHP & $ff"                ; c8
DUELVARS_BENCH1_CARD_HP                  EQUS "wPlayerBench1CardHP & $ff"               ; c9
DUELVARS_BENCH2_CARD_HP                  EQUS "wPlayerBench2CardHP & $ff"               ; ca
DUELVARS_BENCH3_CARD_HP                  EQUS "wPlayerBench3CardHP & $ff"               ; cb
DUELVARS_BENCH4_CARD_HP                  EQUS "wPlayerBench4CardHP & $ff"               ; cc
DUELVARS_BENCH5_CARD_HP                  EQUS "wPlayerBench5CardHP & $ff"               ; cd
DUELVARS_PRIZES                          EQUS "wPlayerPrizes & $ff"                     ; ec
DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE EQUS "wPlayerNumberOfCardsInDiscardPile & $ff" ; ed
DUELVARS_NUMBER_OF_CARDS_IN_HAND         EQUS "wPlayerNumberOfCardsInHand & $ff"        ; ee
DUELVARS_NUMBER_OF_POKEMON_IN_PLAY       EQUS "wPlayerNumberOfPokemonInPlay & $ff"      ; ef
DUELVARS_ARENA_CARD_STATUS               EQUS "wPlayerArenaCardStatus & $ff"            ; f0
DUELVARS_DUELIST_TYPE                    EQUS "wPlayerDuelistType & $ff"                ; f1
