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
\1Move1::         move_data_struct \1Move1
\1Move2::         move_data_struct \1Move2
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

move_data_struct: MACRO
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

; TODO: Figure out what the rest are for
sprite_anim_struct: MACRO
\1Field0x00::  ds 1
\1Field0x01::  ds 1 ; movement handling / palette
\1CoordX::     ds 1
\1CoordY::     ds 1
\1TileID::     ds 1
\1Field0x05::  ds 1
\1Field0x06::  ds 1
\1Field0x07::  ds 1
\1Field0x08::  ds 1
\1Field0x09::  ds 1
\1Field0x0a::  ds 1
\1Field0x0b::  ds 1
\1Field0x0c::  ds 1
\1Field0x0d::  ds 1
\1MovementCounter::  ds 1
\1Field0x0f::  ds 1
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
