BoosterSetRarityAmountTable: ; 1e4d4 (7::64d4)
; energies, commons, uncommons, rares
; commons + uncommons + rares needs to be equal to 10 minus the number of energy cards
; defined in the pack's data below; otherwise, the number of cards in the pack won't be 10.
	db $01, $05, $03, $01 ; COLOSSEUM >> 4
	db $01, $05, $03, $01 ; EVOLUTION >> 4
	db $00, $06, $03, $01 ; MYSTERY >> 4
	db $00, $06, $03, $01 ; LABORATORY >> 4

; For the energy or energy generation function, there are three options:
; - Ponter to a function that generates energies (some generate one, some generate a full pack)
; - A single energy of a specific type
; - $0000 if no card in the pack is an energy

PackColosseumNeutral:: ; 1e4e4 (7:64e4)
	db COLOSSEUM >> 4 ; booster pack set
	dw GenerateEndingEnergy ; energy or energy generation function

; Card Type Chances
	db $14 ; Grass Type Chance
	db $14 ; Fire Type Chance
	db $14 ; Water Type Chance
	db $14 ; Lightning Type Chance
	db $14 ; Fighting Type Chance
	db $14 ; Psychic Type Chance
	db $14 ; Colorless Type Chance
	db $14 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackColosseumGrass:: ; 1e4f0 (7:64f0)
	db COLOSSEUM >> 4 ; booster pack set
	dw GRASS_ENERGY  ; energy or energy generation function

; Card Type Chances
	db $30 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackColosseumFire:: ; 1e4fc (7:64fc)
	db COLOSSEUM >> 4 ; booster pack set
	dw FIRE_ENERGY  ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $30 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackColosseumWater:: ; 1e508 (7:6508)
	db COLOSSEUM >> 4 ; booster pack set
	dw WATER_ENERGY ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $30 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackColosseumLightning:: ; 1e514 (7:6514)
	db COLOSSEUM >> 4 ; booster pack set
	dw LIGHTNING_ENERGY ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $30 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackColosseumFighting:: ; 1e520 (7:6520)
	db COLOSSEUM >> 4 ; booster pack set
	dw FIGHTING_ENERGY ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $30 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackColosseumTrainer:: ; 1e52c (7:652c)
	db COLOSSEUM >> 4 ; booster pack set
	dw GenerateEndingEnergy ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $30 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEvolutionNeutral:: ; 1e538 (7:6538)
	db EVOLUTION >> 4 ; booster pack set
	dw GenerateEndingEnergy ; energy or energy generation function

; Card Type Chances
	db $14 ; Grass Type Chance
	db $14 ; Fire Type Chance
	db $14 ; Water Type Chance
	db $14 ; Lightning Type Chance
	db $14 ; Fighting Type Chance
	db $14 ; Psychic Type Chance
	db $14 ; Colorless Type Chance
	db $14 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEvolutionGrass:: ; 1e544 (7:6544)
	db EVOLUTION >> 4 ; booster pack set
	dw GRASS_ENERGY ; energy or energy generation function

; Card Type Chances
	db $30 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEvolutionNeutralFireEnergy:: ; 1e550 (7:6550)
	db EVOLUTION >> 4 ; booster pack set
	dw FIRE_ENERGY ; energy or energy generation function

; Card Type Chances
	db $14 ; Grass Type Chance
	db $14 ; Fire Type Chance
	db $14 ; Water Type Chance
	db $14 ; Lightning Type Chance
	db $14 ; Fighting Type Chance
	db $14 ; Psychic Type Chance
	db $14 ; Colorless Type Chance
	db $14 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEvolutionWater:: ; 1e55c (7:655c)
	db EVOLUTION >> 4 ; booster pack set
	dw WATER_ENERGY ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $30 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEvolutionFighting:: ; 1e568 (7:6568)
	db EVOLUTION >> 4 ; booster pack set
	dw FIGHTING_ENERGY ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $30 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEvolutionPsychic:: ; 1e574 (7:6574)
	db EVOLUTION >> 4 ; booster pack set
	dw PSYCHIC_ENERGY ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $30 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEvolutionTrainer:: ; 1e580 (7:6580)
	db EVOLUTION >> 4 ; booster pack set
	dw GenerateEndingEnergy ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $30 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackMysteryNeutral:: ; 1e58c (7:658c)
	db MYSTERY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $11 ; Grass Type Chance
	db $11 ; Fire Type Chance
	db $11 ; Water Type Chance
	db $11 ; Lightning Type Chance
	db $11 ; Fighting Type Chance
	db $11 ; Psychic Type Chance
	db $11 ; Colorless Type Chance
	db $11 ; Trainer Card Chance
	db $11 ; Energy Card Chance

PackMysteryGrassColorless:: ; 1e598 (7:6598)
	db MYSTERY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $30 ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $0C ; Water Type Chance
	db $0C ; Lightning Type Chance
	db $0C ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $0C ; Trainer Card Chance
	db $0C ; Energy Card Chance

PackMysteryWaterColorless:: ; 1e5a4 (7:65a4)
	db MYSTERY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $0C ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $30 ; Water Type Chance
	db $0C ; Lightning Type Chance
	db $0C ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $0C ; Trainer Card Chance
	db $0C ; Energy Card Chance

PackMysteryLightningColorless:: ; 1e5b0 (7:65b0)
	db MYSTERY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $0C ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $0C ; Water Type Chance
	db $30 ; Lightning Type Chance
	db $0C ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $0C ; Trainer Card Chance
	db $0C ; Energy Card Chance

PackMysteryFightingColorless:: ; 1e5bc (7:65bc)
	db MYSTERY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $0C ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $0C ; Water Type Chance
	db $0C ; Lightning Type Chance
	db $30 ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $0C ; Trainer Card Chance
	db $0C ; Energy Card Chance

PackMysteryTrainerColorless:: ; 1e5c8 (7:65c8)
	db MYSTERY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $0C ; Grass Type Chance
	db $0C ; Fire Type Chance
	db $0C ; Water Type Chance
	db $0C ; Lightning Type Chance
	db $0C ; Fighting Type Chance
	db $0C ; Psychic Type Chance
	db $16 ; Colorless Type Chance
	db $30 ; Trainer Card Chance
	db $0C ; Energy Card Chance

PackLaboratoryMostlyNeutral:: ; 1e5d4 (7:65d4)
	db LABORATORY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $14 ; Grass Type Chance
	db $14 ; Fire Type Chance
	db $14 ; Water Type Chance
	db $14 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $14 ; Psychic Type Chance
	db $14 ; Colorless Type Chance
	db $18 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackLaboratoryGrass:: ; 1e5e0 (7:65e0)
	db LABORATORY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $30 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackLaboratoryWater:: ; 1e5ec (7:65ec)
	db LABORATORY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $30 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackLaboratoryPsychic:: ; 1e5f8 (7:65f8)
	db LABORATORY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $30 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $10 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackLaboratoryTrainer:: ; 1e604 (7:6604)
	db LABORATORY >> 4 ; booster pack set
	dw $0000 ; energy or energy generation function

; Card Type Chances
	db $10 ; Grass Type Chance
	db $10 ; Fire Type Chance
	db $10 ; Water Type Chance
	db $10 ; Lightning Type Chance
	db $10 ; Fighting Type Chance
	db $10 ; Psychic Type Chance
	db $10 ; Colorless Type Chance
	db $30 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEnergyLightningFire:: ; 1e610 (7:6610)
	db COLOSSEUM >> 4 ; booster pack set
	dw GenerateEnergyBoosterLightningFire ; energy or energy generation function

; Card Type Chances
	db $00 ; Grass Type Chance
	db $00 ; Fire Type Chance
	db $00 ; Water Type Chance
	db $00 ; Lightning Type Chance
	db $00 ; Fighting Type Chance
	db $00 ; Psychic Type Chance
	db $00 ; Colorless Type Chance
	db $00 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEnergyWaterFighting:: ; 1e61c (7:661c)
	db COLOSSEUM >> 4 ; booster pack set
	dw GenerateEnergyBoosterWaterFighting ; energy or energy generation function

; Card Type Chances
	db $00 ; Grass Type Chance
	db $00 ; Fire Type Chance
	db $00 ; Water Type Chance
	db $00 ; Lightning Type Chance
	db $00 ; Fighting Type Chance
	db $00 ; Psychic Type Chance
	db $00 ; Colorless Type Chance
	db $00 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackEnergyGrassPsychic:: ; 1e628 (7:6628)
	db COLOSSEUM >> 4 ; booster pack set
	dw GenerateEnergyBoosterGrassPsychic ; energy or energy generation function

; Card Type Chances
	db $00 ; Grass Type Chance
	db $00 ; Fire Type Chance
	db $00 ; Water Type Chance
	db $00 ; Lightning Type Chance
	db $00 ; Fighting Type Chance
	db $00 ; Psychic Type Chance
	db $00 ; Colorless Type Chance
	db $00 ; Trainer Card Chance
	db $00 ; Energy Card Chance

PackRandomEnergies:: ; 1e634 (7:6634)
	db COLOSSEUM >> 4 ; booster pack set
	dw GenerateRandomEnergyBooster ; energy or energy generation function

; Card Type Chances
	db $00 ; Grass Type Chance
	db $00 ; Fire Type Chance
	db $00 ; Water Type Chance
	db $00 ; Lightning Type Chance
	db $00 ; Fighting Type Chance
	db $00 ; Psychic Type Chance
	db $00 ; Colorless Type Chance
	db $00 ; Trainer Card Chance
	db $00 ; Energy Card Chance
