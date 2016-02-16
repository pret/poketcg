PLAYER_TURN   EQUS "wPlayerDuelVariables >> $8"
OPPONENT_TURN EQUS "wOpponentDuelVariables >> $8"

DUEL_WON  EQU $1
DUEL_LOST EQU $2
DUEL_DRAW EQU $3

DUELVARS_CARD_LOCATIONS                  EQUS "wPlayerCardLocations & $ff"
DUELVARS_HAND                            EQUS "wPlayerHand & $ff"
DUELVARS_DECK_CARDS                      EQUS "wPlayerDeckCards & $ff"
DUELVARS_NUMBER_OF_CARDS_NOT_IN_DECK     EQUS "wPlayerNumberOfCardsNotInDeck & $ff"
DUELVARS_ARENA_CARD                      EQUS "wPlayerArenaCard & $ff"
DUELVARS_BENCH                           EQUS "wPlayerBench & $ff"
DUELVARS_ARENA_CARD_HP                   EQUS "wPlayerArenaCardHP & $ff"
DUELVARS_BENCH1_CARD_HP                  EQUS "wPlayerBench1CardHP & $ff"
DUELVARS_BENCH2_CARD_HP                  EQUS "wPlayerBench2CardHP & $ff"
DUELVARS_BENCH3_CARD_HP                  EQUS "wPlayerBench3CardHP & $ff"
DUELVARS_BENCH4_CARD_HP                  EQUS "wPlayerBench4CardHP & $ff"
DUELVARS_BENCH5_CARD_HP                  EQUS "wPlayerBench5CardHP & $ff"
DUELVARS_PRIZES                          EQUS "wPlayerPrizes & $ff"
DUELVARS_NUMBER_OF_CARDS_IN_DISCARD_PILE EQUS "wPlayerNumberOfCardsInDiscardPile & $ff"
DUELVARS_NUMBER_OF_CARDS_IN_HAND         EQUS "wPlayerNumberOfCardsInHand & $ff"
DUELVARS_NUMBER_OF_POKEMON_IN_PLAY       EQUS "wPlayerNumberOfPokemonInPlay & $ff"
DUELVARS_ARENA_CARD_STATUS               EQUS "wPlayerArenaCardStatus & $ff"
DUELVARS_DUELIST_TYPE                    EQUS "wPlayerDuelistType & $ff"
