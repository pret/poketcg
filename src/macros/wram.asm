card_data_struct: MACRO
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
\1Unknown1::      ds 1
\1Level::         ds 1
\1Length::        ds 2
\1Weight::        ds 2
\1Description::   ds 2
\1Unknown2::      ds 1
ENDM

atk_data_struct: MACRO
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

text_header: MACRO
\1DefaultFont:: ds 1
\1FontWidth::   ds 1
\1Address::     ds 2
\1RomBank::     ds 1
ENDM

sprite_anim_struct: MACRO
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

loaded_npc_struct: MACRO
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

sprite_vram_struct: MACRO
\1Valid::      ds 1
\1ID::         ds 1
\1TileOffset:: ds 1
\1TileSize::   ds 1
ENDM

duel_anim_struct: MACRO
\1ID::             ds 1
\1Screen::         ds 1
\1DuelistSide::    ds 1
\1LocationParam::  ds 1
\1Damage::         ds 2
\1Unknown2::       ds 1
\1Bank::           ds 1
ENDM

deck_struct: MACRO
\1Name::  ds DECK_NAME_SIZE
\1Cards:: ds DECK_SIZE
ENDM
