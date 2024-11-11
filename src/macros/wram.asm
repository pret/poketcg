MACRO card_data_struct
\1Type::          ds 1
\1Gfx::           ds 2
\1Name::          ds 2
\1Rarity::        ds 1
\1Set::           ds 1
\1ID::            ds 1
\1EffectCommands:: ; ds 2
\1HP::            ds 1
\1Stage::         ds 1
\1NonPokemonDescription:: ; ds 2
\1PreEvoName::    ds 2
\1Atk1::         atk_data_struct \1Atk1
\1Atk2::         atk_data_struct \1Atk2
\1RetreatCost::   ds 1
\1Weakness::      ds 1
\1Resistance::    ds 1
\1Category::      ds 2
\1PokedexNumber:: ds 1
ds 1
\1Level::         ds 1
\1Length::        ds 2
\1Weight::        ds 2
\1Description::   ds 2
\1AIInfo::        ds 1
ENDM

MACRO atk_data_struct
\1EnergyCost::     ds NUM_TYPES / 2
\1Name::           ds 2
\1Description::    ds 4
\1Damage::         ds 1
\1Category::       ds 1
\1EffectCommands:: ds 2
\1Flag1::          ds 1
\1Flag2::          ds 1
\1Flag3::          ds 1
\1EffectParam::    ds 1
\1Animation::      ds 1
ENDM

MACRO text_header
\1DefaultFont:: ds 1
\1FontWidth::   ds 1
\1Address::     ds 2
\1RomBank::     ds 1
ENDM

MACRO sprite_anim_struct
\1Enabled::             ds 1
\1Attributes::          ds 1
\1CoordX::              ds 1
\1CoordY::              ds 1
\1TileID::              ds 1
\1ID::                  ds 1
\1Bank::                ds 1
\1Pointer::             ds 2
\1FrameOffsetPointer::  ds 2
\1FrameBank::           ds 1
\1FrameDataPointer::    ds 2
\1Counter::             ds 1
\1Flags::               ds 1
ENDM

MACRO loaded_npc_struct
\1ID::         ds 1
\1Sprite::     ds 1
\1CoordX::     ds 1
\1CoordY::     ds 1
\1Direction::  ds 1
\1Field0x05::  ds 1
\1Field0x06::  ds 1
\1Field0x07::  ds 1
\1Field0x08::  ds 1
\1Field0x09::  ds 1
\1Field0x0a::  ds 1
\1Field0x0b::  ds 1
ENDM

MACRO sprite_vram_struct
\1Valid::      ds 1
\1ID::         ds 1
\1TileOffset:: ds 1
\1TileSize::   ds 1
ENDM

MACRO duel_anim_struct
\1ID::             ds 1
\1Screen::         ds 1
\1DuelistSide::    ds 1
\1LocationParam::  ds 1
\1Damage::         ds 2
\1Unknown2::       ds 1
\1Bank::           ds 1
ENDM

MACRO deck_struct
\1Name::  ds DECK_NAME_SIZE
\1Cards:: ds DECK_SIZE
ENDM

MACRO duel_vars
	ASSERT (LOW(@) == 0), "must be aligned to $100"

; 60-byte array that indicates where each of the 60 cards is.
;	$00 - deck
;	$01 - hand
;	$02 - discard pile
;	$08 - prize
;	$10 - arena (active pokemon or a card attached to it)
;	$1X - bench (where X is bench position from 1 to 5)
\1CardLocations::                ds DECK_SIZE

; deck indexes of the up to 6 cards placed as prizes
\1PrizeCards::                   ds $6

; deck indexes of the cards that are in the duelist's hand
\1Hand::                         ds DECK_SIZE

; 60-byte array that maps each card to its position in the deck or anywhere else
; This array is initialized to 00, 01, 02, ..., 59, until deck is shuffled.
; Cards in the discard pile go first, cards still in the deck go last, and others go in-between.
\1DeckCards::                    ds DECK_SIZE

; Stores x = (60 - deck remaining cards).
; The first x cards in the \1DeckCards array are no longer in the drawable deck this duel.
; The top card of the duelist's deck is at \1DeckCards + [\1NumberOfCardsNotInDeck].
\1NumberOfCardsNotInDeck::       ds $1

; Deck index of the card that is in duelist's side of the field
; -1 indicates no pokemon
\1ArenaCard::                    ds $1

; Deck indexes of the cards that are in duelist's bench, plus an $ff (-1) terminator
; -1 indicates no pokemon
\1Bench::                        ds MAX_BENCH_POKEMON + 1

\1ArenaCardFlags::               ds $1

	ds $5

\1ArenaCardHP::                  ds $1
\1Bench1CardHP::                 ds $1
\1Bench2CardHP::                 ds $1
\1Bench3CardHP::                 ds $1
\1Bench4CardHP::                 ds $1
\1Bench5CardHP::                 ds $1
\1ArenaCardStage::               ds $1
\1Bench1CardStage::              ds $1
\1Bench2CardStage::              ds $1
\1Bench3CardStage::              ds $1
\1Bench4CardStage::              ds $1
\1Bench5CardStage::              ds $1

; changed type from Venomoth's Shift Pokemon Power
; if bit 7 == 1, then bits 0-3 override the Pokemon's actual color
\1ArenaCardChangedType::         ds $1
\1Bench1CardChangedType::        ds $1
\1Bench2CardChangedType::        ds $1
\1Bench3CardChangedType::        ds $1
\1Bench4CardChangedType::        ds $1
\1Bench5CardChangedType::        ds $1

\1ArenaCardAttachedDefender::    ds $1
\1Bench1CardAttachedDefender::   ds $1
\1Bench2CardAttachedDefender::   ds $1
\1Bench3CardAttachedDefender::   ds $1
\1Bench4CardAttachedDefender::   ds $1
\1Bench5CardAttachedDefender::   ds $1

\1ArenaCardAttachedPluspower::   ds $1
\1Bench1CardAttachedPluspower::  ds $1
\1Bench2CardAttachedPluspower::  ds $1
\1Bench3CardAttachedPluspower::  ds $1
\1Bench4CardAttachedPluspower::  ds $1
\1Bench5CardAttachedPluspower::  ds $1

	ds $1

\1ArenaCardSubstatus1::          ds $1
\1ArenaCardSubstatus2::          ds $1

; changed weakness from Conversion 1
\1ArenaCardChangedWeakness::     ds $1
; changed resistance from Conversion 2
\1ArenaCardChangedResistance::   ds $1

\1ArenaCardSubstatus3::          ds $1

; each bit represents a prize that this duelist can draw (1 = not drawn ; 0 = drawn)
\1Prizes::                       ds $1

\1NumberOfCardsInDiscardPile::   ds $1
\1NumberOfCardsInHand::          ds $1

; Pokemon cards in arena + bench
\1NumberOfPokemonInPlayArea::    ds $1

\1ArenaCardStatus::              ds $1

; $00   - player
; $01   - link
; other - AI controlled
\1DuelistType::                  ds $1

; if under the effects of amnesia, which attack (0 or 1) can't be used
\1ArenaCardDisabledAttackIndex:: ds $1

; damage taken the last time the opponent attacked (0 if no damage)
\1ArenaCardLastTurnDamage::      ds $2

; status condition received the last time the opponent attacked (0 if none)
\1ArenaCardLastTurnStatus::      ds $1

; substatus2 that the opponent card got last turn
\1ArenaCardLastTurnSubstatus2::  ds $1

; indicates color of weakness that was changed
; for this card last turn
\1ArenaCardLastTurnChangeWeak::  ds $1

; stores an effect that was used on the Arena card last turn.
; see LAST_TURN_EFFECT_* constants.
\1ArenaCardLastTurnEffect::      ds $1

	ds $7
ENDM
