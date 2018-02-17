card_data_struct: MACRO
\1Type::          db
\1Gfx::           dw
\1Name::          dw
\1Rarity::        db
\1Set::           db
\1ID::            db
\1EnergyCardEffectCommands::  ; dw
\1TrainerCardEffectCommands:: ; dw
\1HP::            db
\1Stage::         db
\1EnergyCardDescription::     ; dw
\1TrainerCardDescription::    ; dw
\1PreEvoName::    dw
\1Move1::         move_data_struct \1Move1
\1Move2::         move_data_struct \1Move2
\1RetreatCost::   db
\1Weakness::      db
\1Resistance::    db
\1Kind::          dw
\1PokedexNumber:: db
\1Unknown1::      db
\1Level::         db
\1Length::        dw
\1Weight::        dw
\1Description::   dw
\1Unknown2::      db
ENDM

move_data_struct: MACRO
\1Energy::         ds $4
\1Name::           dw
\1Description::    ds $4
\1Damage::         db
\1Category::       db
\1EffectCommands:: dw
\1Flag1::          db
\1Flag2::          db
\1Flag3::          db
\1Unknown1::       db
\1Animation::      db
ENDM

sprite_buffer_struct: MACRO
\1Property1::  ds 1
\1Property2::  ds 1
\1Property3::  ds 1
\1Property4::  ds 1
\1Property5::  ds 1
\1Property6::  ds 1
\1Property7::  ds 1
\1Property8::  ds 1
\1Property9::  ds 1
\1Property10::  ds 1
\1Property11::  ds 1
\1Property12::  ds 1
\1Property13::  ds 1
\1Property14::  ds 1
\1Property15::  ds 1
\1Property16::  ds 1
ENDM