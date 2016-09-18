EffectCommands: ; 186f7 (6:46f7)
; Each move has a two-byte effect pointer (move's 7th param) that points to one of these structures.
; Similarly, trainer cards have a two-byte pointer (7th param) to one of these structures, which determines the card's function.
; Energy cards also point to one of these, but their data is just $00.
;	db CommandType ($01 - $0a)
;	dw Function
;	...
;	db $00

; Commands are associated to a time or a scope (CommandType) that determines when their function is executed during the turn.
; For example type $03 is executed right before dealing damage while type $09 is AI related and executed during enemy turn only.
; Similar move effects of different Pokemon cards all point to a different command list,
; even though in some cases their commands and function pointers match.

; Function name examples
;	PoisonEffect                     ; generic effect shared by multiple moves.
;	Paralysis50PercentEffect         ;
;	KakunaStiffenEffect              ; unique effect from a move known by multiple cards.
;	MetapodStiffenEffect             ;
;	AcidEffect                       ; unique effect from a move known by a single card
;	FoulOdorEffect                   ;
;	SpitPoison_Poison50PercentEffect ; unique effect made of more than one command.
;	SpitPoison_AIEffect              ;

EkansSpitPoisonEffectCommands:
	dbw $03, SpitPoison_Poison50PercentEffect
	dbw $09, SpitPoison_AIEffect
	db  $00

EkansWrapEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

ArbokTerrorStrikeEffectCommands:
	dbw $04, $4726
	dbw $05, $470a
	dbw $0a, $470a
	db  $00

ArbokPoisonFangEffectCommands:
	dbw $03, PoisonEffect
	dbw $09, PoisonFang_AIEffect
	db  $00

WeepinbellPoisonPowderEffectCommands:
	dbw $03, Poison50PercentEffect
	dbw $09, WeepinbellPoisonPowder_AIEffect
	db  $00

VictreebelLureEffectCommands:
	dbw $01, $4740
	dbw $04, $476a
	dbw $05, $474b
	dbw $08, $4764
	db  $00

VictreebelAcidEffectCommands:
	dbw $03, AcidEffect
	db  $00

PinsirIronGripEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

CaterpieStringShotEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

GloomPoisonPowderEffectCommands:
	dbw $03, PoisonEffect
	dbw $09, GloomPoisonPowder_AIEffect
	db  $00

GloomFoulOdorEffectCommands:
	dbw $03, FoulOdorEffect
	db  $00

KakunaStiffenEffectCommands:
	dbw $03, KakunaStiffenEffect
	db  $00

KakunaPoisonPowderEffectCommands:
	dbw $03, Poison50PercentEffect
	dbw $09, KakunaPoisonPowder_AIEffect
	db  $00

GolbatLeechLifeEffectCommands:
	dbw $04, $47bc
	db  $00

VenonatStunSporeEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

VenonatLeechLifeEffectCommands:
	dbw $04, $47c6
	db  $00

ScytherSwordsDanceEffectCommands:
	dbw $03, SwordsDanceEffect
	db  $00

ZubatSupersonicEffectCommands:
	dbw $03, ZubatSupersonicEffect
	db  $00

ZubatLeechLifeEffectCommands:
	dbw $04, $47e3
	db  $00

BeedrillTwineedleEffectCommands:
	dbw $03, $47f5
	dbw $09, $47ed
	db  $00

BeedrillPoisonStingEffectCommands:
	dbw $03, Poison50PercentEffect
	dbw $09, $480d
	db  $00

ExeggcuteHypnosisEffectCommands:
	dbw $03, SleepEffect
	db  $00

ExeggcuteLeechSeedEffectCommands:
	dbw $04, $4815
	db  $00

KoffingFoulGasEffectCommands:
	dbw $03, $482a
	dbw $09, $4822
	db  $00

MetapodStiffenEffectCommands:
	dbw $03, MetapodStiffenEffect
	db  $00

MetapodStunSporeEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

OddishStunSporeEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

OddishSproutEffectCommands:
	dbw $01, $484a
	dbw $04, $48cc
	dbw $05, $485a
	dbw $08, $48b7
	db  $00

ExeggutorTeleportEffectCommands:
	dbw $01, $48ec
	dbw $04, $491a
	dbw $05, $48f7
	dbw $08, $490f
	db  $00

ExeggutorBigEggsplosionEffectCommands:
	dbw $03, $4944
	dbw $09, $4925
	db  $00

NidokingThrashEffectCommands:
	dbw $03, $4973
	dbw $04, $4982
	dbw $09, $496b
	db  $00

NidokingToxicEffectCommands:
	dbw $03, $4994
	dbw $09, $498c
	db  $00

NidoqueenBoyfriendsEffectCommands:
	dbw $03, $4998
	db  $00

NidoranFFurySweepesEffectCommands:
	dbw $03, $49c6
	dbw $09, $49be
	db  $00

NidoranFCallforFamilyEffectCommands:
	dbw $01, $49db
	dbw $04, $4a6e
	dbw $05, $49eb
	dbw $08, $4a55
	db  $00

NidoranMHornHazardEffectCommands:
	dbw $03, $4a96
	dbw $09, $4a8e
	db  $00

NidorinaSupersonicEffectCommands:
	dbw $03, $4aac
	db  $00

NidorinaDoubleKickEffectCommands:
	dbw $03, $4abb
	dbw $09, $4ab3
	db  $00

NidorinoDoubleKickEffectCommands:
	dbw $03, $4adb
	dbw $09, $4ad3
	db  $00

ButterfreeWhirlwindEffectCommands:
	dbw $04, $4b09
	dbw $05, $4af3
	dbw $0a, $4af3
	db  $00

ButterfreeMegaDrainEffectCommands:
	dbw $04, $4b0f
	db  $00

ParasSporeEffectCommands:
	dbw $03, SleepEffect
	db  $00

ParasectSporeEffectCommands:
	dbw $03, SleepEffect
	db  $00

WeedlePoisonStingEffectCommands:
	dbw $03, Poison50PercentEffect
	dbw $09, $4b27
	db  $00

IvysaurPoisonPowderEffectCommands:
	dbw $03, PoisonEffect
	dbw $09, $4b2f
	db  $00

BulbasaurLeechSeedEffectCommands:
	dbw $04, $4b37
	db  $00

VenusaurEnergyTransEffectCommands:
	dbw $02, $4b44
	dbw $03, $4b77
	dbw $04, $4bfb
	dbw $05, $4b6f
	db  $00

GrimerNastyGooEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

GrimerMinimizeEffectCommands:
	dbw $03, $4c30
	db  $00

MukToxicGasEffectCommands:
	dbw $01, $4c36
	db  $00

MukSludgeEffectCommands:
	dbw $03, Poison50PercentEffect
	dbw $09, $4c38
	db  $00

BellsproutCallforFamilyEffectCommands:
	dbw $01, $4c40
	dbw $04, $4cc2
	dbw $05, $4c50
	dbw $08, $4cad
	db  $00

WeezingSmogEffectCommands:
	dbw $03, Poison50PercentEffect
	dbw $09, $4ce2
	db  $00

WeezingSelfdestructEffectCommands:
	dbw $04, $4cea
	db  $00

VenomothShiftEffectCommands:
	dbw $02, $4d09
	dbw $03, $4d5d
	dbw $05, $4d21
	db  $00

VenomothVenomPowderEffectCommands:
	dbw $03, $4d8c
	dbw $09, $4d84
	db  $00

TangelaBindEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

TangelaPoisonPowderEffectCommands:
	dbw $03, PoisonEffect
	dbw $09, $4da0
	db  $00

VileplumeHealEffectCommands:
	dbw $02, $4da8
	dbw $03, $4dc7
	db  $00

VileplumePetalDanceEffectCommands:
	dbw $03, $4e2b
	dbw $09, $4e23
	db  $00

TangelaStunSporeEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

TangelaPoisonWhipEffectCommands:
	dbw $03, PoisonEffect
	dbw $09, $4e4b
	db  $00

VenusaurSolarPowerEffectCommands:
	dbw $02, $4e53
	dbw $03, $4e82
	db  $00

VenusaurMegaDrainEffectCommands:
	dbw $04, $4eb0
	db  $00

OmastarWaterGunEffectCommands:
	dbw $03, $4f05
	dbw $09, $4f05
	db  $00

OmastarSpikeCannonEffectCommands:
	dbw $03, $4f12
	dbw $09, $4f0a
	db  $00

OmanyteClairvoyanceEffectCommands:
	dbw $01, $4f2a
	db  $00

OmanyteWaterGunEffectCommands:
	dbw $03, $4f2c
	dbw $09, $4f2c
	db  $00

WartortleWithdrawEffectCommands:
	dbw $03, $4f32
	db  $00

BlastoiseRainDanceEffectCommands:
	dbw $01, $4f46
	db  $00

BlastoiseHydroPumpEffectCommands:
	dbw $03, $4f48
	dbw $09, $4f48
	db  $00

GyaradosBubblebeamEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

KinglerFlailEffectCommands:
	dbw $03, $4f54
	dbw $09, $4f4e
	db  $00

KrabbyCallforFamilyEffectCommands:
	dbw $01, $4f5d
	dbw $04, $4fdf
	dbw $05, $4f6d
	dbw $08, $4fca
	db  $00

MagikarpFlailEffectCommands:
	dbw $03, $5005
	dbw $09, $4fff
	db  $00

PsyduckHeadacheEffectCommands:
	dbw $03, $500e
	db  $00

PsyduckFurySweepesEffectCommands:
	dbw $03, $501e
	dbw $09, $5016
	db  $00

GolduckPsyshockEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

GolduckHyperBeamEffectCommands:
	dbw $04, $506b
	dbw $05, $5033
	dbw $08, $5065
	db  $00

SeadraWaterGunEffectCommands:
	dbw $03, $5085
	dbw $09, $5085
	db  $00

SeadraAgilityEffectCommands:
	dbw $03, $508b
	db  $00

ShellderSupersonicEffectCommands:
	dbw $03, $509d
	db  $00

ShellderHideinShellEffectCommands:
	dbw $03, $50a4
	db  $00

VaporeonQuickAttackEffectCommands:
	dbw $03, $50c0
	dbw $09, $50b8
	db  $00

VaporeonWaterGunEffectCommands:
	dbw $03, $50d3
	dbw $09, $50d3
	db  $00

DewgongIceBeamEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

StarmieRecoverEffectCommands:
	dbw $01, $50d9
	dbw $02, $50f0
	dbw $04, $5114
	dbw $06, $510e
	dbw $08, $5103
	db  $00

StarmieStarFreezeEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

SquirtleBubbleEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

SquirtleWithdrawEffectCommands:
	dbw $03, $5120
	db  $00

HorseaSmokescreenEffectCommands:
	dbw $03, $5134
	db  $00

TentacruelSupersonicEffectCommands:
	dbw $03, $513a
	db  $00

TentacruelJellyfishStingEffectCommands:
	dbw $03, PoisonEffect
	dbw $09, $5141
	db  $00

PoliwhirlAmnesiaEffectCommands:
	dbw $01, $5149
	dbw $02, $516f
	dbw $03, $5179
	dbw $08, $5173
	db  $00

PoliwhirlDoubleslapEffectCommands:
	dbw $03, $51c8
	dbw $09, $51c0
	db  $00

PoliwrathWaterGunEffectCommands:
	dbw $03, $51e0
	dbw $09, $51e0
	db  $00

PoliwrathWhirlpoolEffectCommands:
	dbw $04, $5214
	dbw $05, $51e6
	dbw $08, $520e
	db  $00

PoliwagWaterGunEffectCommands:
	dbw $03, $5227
	dbw $09, $5227
	db  $00

CloysterClampEffectCommands:
	dbw $03, $522d
	db  $00

CloysterSpikeCannonEffectCommands:
	dbw $03, $524e
	dbw $09, $5246
	db  $00

ArticunoFreezeDryEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

ArticunoBlizzardEffectCommands:
	dbw $03, $5266
	dbw $04, $526f
	db  $00

TentacoolCowardiceEffectCommands:
	dbw $02, $528b
	dbw $03, $52c3
	dbw $05, $52ae
	db  $00

LaprasWaterGunEffectCommands:
	dbw $03, $52eb
	dbw $09, $52eb
	db  $00

LaprasConfuseRayEffectCommands:
	dbw $03, Confusion50PercentEffect
	db  $00

ArticunoQuickfreezeEffectCommands:
	dbw $01, $52f1
	dbw $07, $52f3
	db  $00

ArticunoIceBreathEffectCommands:
	dbw $03, $5329
	dbw $04, $532e
	db  $00

VaporeonFocusEnergyEffectCommands:
	dbw $03, $533f
	db  $00

ArcanineFlamethrowerEffectCommands:
	dbw $01, $5363
	dbw $02, $5371
	dbw $06, $5379
	dbw $08, $5375
	db  $00

ArcanineTakeDownEffectCommands:
	dbw $04, $537f
	db  $00

ArcanineQuickAttackEffectCommands:
	dbw $03, $538d
	dbw $09, $5385
	db  $00

ArcanineFlamesofRageEffectCommands:
	dbw $01, $53a0
	dbw $02, $53ae
	dbw $03, $53ef
	dbw $06, $53de
	dbw $08, $53d5
	dbw $09, $53e9
	db  $00

RapidashStompEffectCommands:
	dbw $03, $5400
	dbw $09, $53f8
	db  $00

RapidashAgilityEffectCommands:
	dbw $03, $5413
	db  $00

NinetailsLureEffectCommands:
	dbw $01, $5425
	dbw $04, $544f
	dbw $05, $5430
	dbw $08, $5449
	db  $00

NinetailsFireBlastEffectCommands:
	dbw $01, $5463
	dbw $02, $5471
	dbw $06, $5479
	dbw $08, $5475
	db  $00

CharmanderEmberEffectCommands:
	dbw $01, $547f
	dbw $02, $548d
	dbw $06, $5495
	dbw $08, $5491
	db  $00

MoltresWildfireEffectCommands:
	dbw $01, $549b
	dbw $02, $54a9
	dbw $04, $54f4
	dbw $06, $54e1
	dbw $08, $54dd
	db  $00

Moltres1DiveBombEffectCommands:
	dbw $03, $552b
	dbw $09, $5523
	db  $00

FlareonQuickAttackEffectCommands:
	dbw $03, $5549
	dbw $09, $5541
	db  $00

FlareonFlamethrowerEffectCommands:
	dbw $01, $555c
	dbw $02, $556a
	dbw $06, $5572
	dbw $08, $556e
	db  $00

MagmarFlamethrowerEffectCommands:
	dbw $01, $5578
	dbw $02, $5586
	dbw $06, $558e
	dbw $08, $558a
	db  $00

MagmarSmokescreenEffectCommands:
	dbw $03, $5594
	db  $00

MagmarSmogEffectCommands:
	dbw $03, Poison50PercentEffect
	dbw $09, $559a
	db  $00

CharmeleonFlamethrowerEffectCommands:
	dbw $01, $55a2
	dbw $02, $55b0
	dbw $06, $55b8
	dbw $08, $55b4
	db  $00

CharizardEnergyBurnEffectCommands:
	dbw $01, $55be
	db  $00

CharizardFireSpinEffectCommands:
	dbw $01, $55c0
	dbw $02, $55cd
	dbw $06, $5614
	dbw $08, $5606
	db  $00

VulpixConfuseRayEffectCommands:
	dbw $03, Confusion50PercentEffect
	db  $00

FlareonRageEffectCommands:
	dbw $03, $563e
	dbw $09, $5638
	db  $00

NinetailsMixUpEffectCommands:
	dbw $04, $5647
	db  $00

NinetailsDancingEmbersEffectCommands:
	dbw $03, $56ab
	dbw $09, $56a3
	db  $00

MoltresFiregiverEffectCommands:
	dbw $01, $56c0
	dbw $07, $56c2
	db  $00

Moltres2DiveBombEffectCommands:
	dbw $03, $5776
	dbw $09, $576e
	db  $00

AbraPsyshockEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

GengarCurseEffectCommands:
	dbw $02, $57fc
	dbw $03, $58bb
	dbw $05, $5834
	db  $00

GengarDarkMindEffectCommands:
	dbw $04, $593c
	dbw $05, $5903
	dbw $08, $592a
	db  $00

GastlySleepingGasEffectCommands:
	dbw $03, $594f
	db  $00

GastlyDestinyBondEffectCommands:
	dbw $01, $5956
	dbw $02, $5964
	dbw $03, $5987
	dbw $06, $5981
	dbw $08, $5976
	db  $00

GastlyLickEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

GastlyEnergyConversionEffectCommands:
	dbw $01, $598d
	dbw $04, $59b4
	dbw $05, $5994
	dbw $08, $599b
	db  $00

HaunterHypnosisEffectCommands:
	dbw $03, SleepEffect
	db  $00

HaunterDreamEaterEffectCommands:
	dbw $01, $59d6
	db  $00

HaunterTransparencyEffectCommands:
	dbw $01, $59e5
	db  $00

HaunterNightmareEffectCommands:
	dbw $03, SleepEffect
	db  $00

HypnoProphecyEffectCommands:
	dbw $01, $59e7
	dbw $04, $5a41
	dbw $05, $5a00
	dbw $08, $5a3c
	db  $00

HypnoDarkMindEffectCommands:
	dbw $04, $5b64
	dbw $05, $5b2b
	dbw $08, $5b52
	db  $00

DrowzeeConfuseRayEffectCommands:
	dbw $03, Confusion50PercentEffect
	db  $00

MrMimeInvisibleWallEffectCommands:
	dbw $01, $5b77
	db  $00

MrMimeMeditateEffectCommands:
	dbw $03, $5b7f
	dbw $09, $5b79
	db  $00

AlakazamDamageSwapEffectCommands:
	dbw $02, $5b8e
	dbw $03, $5ba2
	dbw $04, $5c27
	db  $00

AlakazamConfuseRayEffectCommands:
	dbw $03, Confusion50PercentEffect
	db  $00

MewPsywaveEffectCommands:
	dbw $03, $5c49
	db  $00

MewDevolutionBeamEffectCommands:
	dbw $01, $5c53
	dbw $02, $5c64
	dbw $03, $5cb6
	dbw $04, $5cbb
	dbw $08, $5c9e
	db  $00

MewNeutralizingShieldEffectCommands:
	dbw $01, $5d79
	db  $00

MewPsyshockEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

MewtwoPsychicEffectCommands:
	dbw $03, $5d81
	dbw $09, $5d7b
	db  $00

MewtwoMrMimeKindAndBarrierEffectCommands:
	dbw $01, $5d8e
	dbw $02, $5d9c
	dbw $03, $5dbf
	dbw $06, $5db9
	dbw $08, $5dae
	db  $00

Mewtwo3EnergyAbsorptionEffectCommands:
	dbw $01, $5dc5
	dbw $04, $5dec
	dbw $05, $5dcc
	dbw $08, $5dd3
	db  $00

Mewtwo2EnergyAbsorptionEffectCommands:
	dbw $01, $5dff
	dbw $04, $5e26
	dbw $05, $5e06
	dbw $08, $5e0d
	db  $00

SlowbroStrangeBehaviorEffectCommands:
	dbw $02, $5e39
	dbw $03, $5e5b
	dbw $04, $5eb3
	db  $00

SlowbroPsyshockEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

SlowpokeSpacingOutEffectCommands:
	dbw $01, $5ed5
	dbw $03, $5ee0
	dbw $04, $5ef1
	db  $00

SlowpokeScavengeEffectCommands:
	dbw $01, $5f05
	dbw $02, $5f1a
	dbw $04, $5f5f
	dbw $05, $5f46
	dbw $06, $5f40
	dbw $08, $5f2d
	db  $00

SlowpokeAmnesiaEffectCommands:
	dbw $01, $5f74
	dbw $02, $5f7b
	dbw $03, $5f85
	dbw $08, $5f7f
	db  $00

KadabraRecoverEffectCommands:
	dbw $01, $5f89
	dbw $02, $5fa0
	dbw $04, $5fc3
	dbw $06, $5fbd
	dbw $08, $5fb2
	db  $00

JynxDoubleslapEffectCommands:
	dbw $03, $5fd7
	dbw $09, $5fcf
	db  $00

JynxMeditateEffectCommands:
	dbw $03, $5ff2
	dbw $09, $5fec
	db  $00

MewMysteryAttackEffectCommands:
	dbw $03, $6009
	dbw $04, $603e
	dbw $09, $6001
	db  $00

GeodudeStoneBarrageEffectCommands:
	dbw $03, $6052
	dbw $09, $604a
	db  $00

OnixHardenEffectCommands:
	dbw $03, $6075
	db  $00

PrimeapeFurySweepesEffectCommands:
	dbw $03, $6083
	dbw $09, $607b
	db  $00

PrimeapeTantrumEffectCommands:
	dbw $03, $6099
	db  $00

MachampStrikesBackEffectCommands:
	dbw $01, $60af
	db  $00

KabutoKabutoArmorEffectCommands:
	dbw $01, $60b1
	db  $00

KabutopsAbsorbEffectCommands:
	dbw $04, $60b3
	db  $00

CuboneSnivelEffectCommands:
	dbw $03, $60cb
	db  $00

CuboneRageEffectCommands:
	dbw $03, $60d7
	dbw $09, $60d1
	db  $00

MarowakBonemerangEffectCommands:
	dbw $03, $60e8
	dbw $09, $60e0
	db  $00

MarowakCallforFriendEffectCommands:
	dbw $01, $6100
	dbw $04, $6194
	dbw $05, $6110
	dbw $08, $6177
	db  $00

MachokeKarateChopEffectCommands:
	dbw $03, $61ba
	dbw $09, $61b4
	db  $00

MachokeSubmissionEffectCommands:
	dbw $04, $61d1
	db  $00

GolemSelfdestructEffectCommands:
	dbw $04, $61d7
	db  $00

GravelerHardenEffectCommands:
	dbw $03, $61f6
	db  $00

RhydonRamEffectCommands:
	dbw $04, $6212
	dbw $05, $61fc
	dbw $0a, $61fc
	db  $00

RhyhornLeerEffectCommands:
	dbw $03, $621d
	db  $00

HitmonleeStretchKickEffectCommands:
	dbw $01, $6231
	dbw $04, $625b
	dbw $05, $623c
	dbw $08, $6255
	db  $00

SandshrewSandAttackEffectCommands:
	dbw $03, $626b
	db  $00

SandslashFurySweepesEffectCommands:
	dbw $03, $6279
	dbw $09, $6271
	db  $00

DugtrioEarthquakeEffectCommands:
	dbw $04, $628f
	db  $00

AerodactylPrehistoricPowerEffectCommands:
	dbw $01, $629a
	db  $00

MankeyPeekEffectCommands:
	dbw $02, $629c
	dbw $03, $62b4
	db  $00

MarowakBoneAttackEffectCommands:
	dbw $03, $630f
	db  $00

MarowakWailEffectCommands:
	dbw $01, $631c
	dbw $04, $6335
	db  $00

ElectabuzzThundershockEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

ElectabuzzThunderpunchEffectCommands:
	dbw $03, $63a1
	dbw $04, $63b0
	dbw $09, $6399
	db  $00

ElectabuzzLightScreenEffectCommands:
	dbw $03, $63ba
	db  $00

ElectabuzzQuickAttackEffectCommands:
	dbw $03, $63c8
	dbw $09, $63c0
	db  $00

MagnemiteThunderWaveEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

MagnemiteSelfdestructEffectCommands:
	dbw $04, $63db
	db  $00

ZapdosThunderEffectCommands:
	dbw $03, $63fa
	dbw $04, $6409
	db  $00

ZapdosThunderboltEffectCommands:
	dbw $03, $6419
	db  $00

ZapdosThunderstormEffectCommands:
	dbw $04, $6429
	db  $00

JolteonQuickAttackEffectCommands:
	dbw $03, $64c3
	dbw $09, $64bb
	db  $00

JolteonPinMissileEffectCommands:
	dbw $03, $64de
	dbw $09, $64d6
	db  $00

FlyingPikachuThundershockEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

FlyingPikachuFlyEffectCommands:
	dbw $03, $64fc
	dbw $09, $64f4
	db  $00

PikachuThunderJoltEffectCommands:
	dbw $03, $651a
	dbw $04, $6529
	db  $00

PikachuSparkEffectCommands:
	dbw $04, $6574
	dbw $05, $6539
	dbw $08, $6562
	db  $00

Pikachu3GrowlEffectCommands:
	dbw $03, $6589
	db  $00

Pikachu3ThundershockEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

Pikachu4GrowlEffectCommands:
	dbw $03, $658f
	db  $00

Pikachu4ThundershockEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

ElectrodeChainLightningEffectCommands:
	dbw $04, $6595
	db  $00

RaichuAgilityEffectCommands:
	dbw $03, $65dc
	db  $00

RaichuThunderEffectCommands:
	dbw $03, $65ee
	dbw $04, $65fd
	db  $00

RaichuGigashockEffectCommands:
	dbw $04, $671f
	dbw $05, $660d
	dbw $08, $66c3
	db  $00

MagnetonThunderWaveEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

Magneton1SelfdestructEffectCommands:
	dbw $04, $6739
	db  $00

MagnetonSonicboomEffectCommands:
	dbw $03, $6758
	dbw $04, $675e
	dbw $09, $6758
	db  $00

Magneton2SelfdestructEffectCommands:
	dbw $04, $675f
	db  $00

ZapdosPealofThunderEffectCommands:
	dbw $01, $677e
	dbw $07, $6780
	db  $00

ZapdosBigThunderEffectCommands:
	dbw $04, $67cb
	db  $00

MagnemiteMagneticStormEffectCommands:
	dbw $04, $67d5
	db  $00

ElectrodeSonicboomEffectCommands:
	dbw $03, $6870
	dbw $04, $6876
	dbw $09, $6870
	db  $00

ElectrodeEnergySpikeEffectCommands:
	dbw $01, $6877
	dbw $04, $68f6
	dbw $05, $687b
	dbw $08, $68f1
	db  $00

JolteonDoubleKickEffectCommands:
	dbw $03, $6938
	dbw $09, $6930
	db  $00

JolteonStunNeedleEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

EeveeTailWagEffectCommands:
	dbw $03, $694e
	db  $00

EeveeQuickAttackEffectCommands:
	dbw $03, $696a
	dbw $09, $6962
	db  $00

SpearowMirrorMoveEffectCommands:
	dbw $01, $697f
	dbw $02, $6981
	dbw $03, $6987
	dbw $04, $6989
	dbw $05, $6983
	dbw $08, $6985
	dbw $09, $697d
	db  $00

FearowAgilityEffectCommands:
	dbw $03, $6ab8
	db  $00

DragoniteStepInEffectCommands:
	dbw $02, $6aca
	dbw $03, $6ae8
	db  $00

Dragonite2SlamEffectCommands:
	dbw $03, $6afe
	dbw $09, $6af6
	db  $00

SnorlaxThickSkinnedEffectCommands:
	dbw $01, $6b15
	db  $00

SnorlaxBodySlamEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

FarfetchdLeekSlapEffectCommands:
	dbw $01, $6b1f
	dbw $03, $6b34
	dbw $06, $6b2c
	dbw $09, $6b17
	db  $00

KangaskhanFetchEffectCommands:
	dbw $04, $6b40
	db  $00

KangaskhanCometPunchEffectCommands:
	dbw $03, $6b65
	dbw $09, $6b5d
	db  $00

TaurosStompEffectCommands:
	dbw $03, $6b83
	dbw $09, $6b7b
	db  $00

TaurosRampageEffectCommands:
	dbw $03, $6ba1
	dbw $09, $6b96
	db  $00

DoduoFuryAttackEffectCommands:
	dbw $03, $6bc2
	dbw $09, $6bba
	db  $00

DodrioRetreatAidEffectCommands:
	dbw $01, $6bd7
	db  $00

DodrioRageEffectCommands:
	dbw $03, $6bdf
	dbw $09, $6bd9
	db  $00

MeowthPayDayEffectCommands:
	dbw $04, $6be8
	db  $00

DragonairSlamEffectCommands:
	dbw $03, $6c14
	dbw $09, $6c0c
	db  $00

DragonairHyperBeamEffectCommands:
	dbw $04, $6c35
	dbw $05, $6c2c
	dbw $08, $6c2f
	db  $00

ClefableMetronomeEffectCommands:
	dbw $01, $6c77
	dbw $02, $6c82
	dbw $08, $6c7e
	db  $00

ClefableMinimizeEffectCommands:
	dbw $03, $6c88
	db  $00

PidgeotHurricaneEffectCommands:
	dbw $04, $6c8e
	db  $00

PidgeottoWhirlwindEffectCommands:
	dbw $04, $6ce9
	dbw $05, $6cd3
	dbw $0a, $6cd3
	db  $00

PidgeottoMirrorMoveEffectCommands:
	dbw $01, $6cf2
	dbw $02, $6cf5
	dbw $03, $6cfe
	dbw $04, $6d01
	dbw $05, $6cf8
	dbw $08, $6cfb
	dbw $09, $6cef
	db  $00

ClefairySingEffectCommands:
	dbw $03, $6d04
	db  $00

ClefairyMetronomeEffectCommands:
	dbw $01, $6d0b
	dbw $02, $6d16
	dbw $08, $6d12
	db  $00

WigglytuffLullabyEffectCommands:
	dbw $03, SleepEffect
	db  $00

WigglytuffDotheWaveEffectCommands:
	dbw $03, $6d87
	dbw $09, $6d87
	db  $00

JigglypuffLullabyEffectCommands:
	dbw $03, SleepEffect
	db  $00

JigglypuffFirstAidEffectCommands:
	dbw $01, $6d94
	dbw $04, $6d9f
	db  $00

JigglypuffDoubleEdgeEffectCommands:
	dbw $04, $6da6
	db  $00

PersianPounceEffectCommands:
	dbw $03, $6dac
	db  $00

LickitungTongueWrapEffectCommands:
	dbw $03, Paralysis50PercentEffect
	db  $00

LickitungSupersonicEffectCommands:
	dbw $03, $6db2
	db  $00

PidgeyWhirlwindEffectCommands:
	dbw $04, $6dcf
	dbw $05, $6db9
	dbw $0a, $6db9
	db  $00

PorygonConversion1EffectCommands:
	dbw $01, $6dd5
	dbw $02, $6ded
	dbw $04, $6dfb
	dbw $08, $6df7
	db  $00

PorygonConversion2EffectCommands:
	dbw $01, $6e1f
	dbw $02, $6e31
	dbw $04, $6e5e
	dbw $08, $6e3c
	db  $00

ChanseyScrunchEffectCommands:
	dbw $03, $6ee7
	db  $00

ChanseyDoubleEdgeEffectCommands:
	dbw $04, $6efb
	db  $00

RaticateSuperFangEffectCommands:
	dbw $03, $6f07
	dbw $09, $6f01
	db  $00

TrainerCardAsPokemonEffectCommands:
	dbw $02, $6f18
	dbw $03, $6f3c
	dbw $05, $6f27
	db  $00

DragoniteHealingWindEffectCommands:
	dbw $01, $6f51
	dbw $07, $6f53
	db  $00

Dragonite1SlamEffectCommands:
	dbw $03, $6fa4
	dbw $09, $6f9c
	db  $00

MeowthCatPunchEffectCommands:
	dbw $04, $6fe0
	db  $00

DittoMorphEffectCommands:
	dbw $04, $6ff6
	db  $00

PidgeotSlicingWindEffectCommands:
	dbw $04, $70bf
	db  $00

PidgeotGaleEffectCommands:
	dbw $03, $70d0
	dbw $04, $70d6
	db  $00

JigglypuffFriendshipSongEffectCommands:
	dbw $01, $710d
	dbw $04, $7119
	db  $00

JigglypuffExpandEffectCommands:
	dbw $04, $7153
	db  $00

DoubleColorlessEnergyEffectCommands:
	db  $00

PsychicEnergyEffectCommands:
	db  $00

FightingEnergyEffectCommands:
	db  $00

LightningEnergyEffectCommands:
	db  $00

WaterEnergyEffectCommands:
	db  $00

FireEnergyEffectCommands:
	db  $00

GrassEnergyEffectCommands:
	db  $00

SuperPotionEffectCommands:
	dbw $01, $7159
	dbw $02, $7167
	dbw $03, $71b5
	db  $00

ImakuniEffectCommands:
	dbw $03, $7216
	db  $00

EnergyRemovalEffectCommands:
	dbw $01, $7252
	dbw $02, $725f
	dbw $03, $7273
	dbw $08, $726f
	db  $00

EnergyRetrievalEffectCommands:
	dbw $01, $728e
	dbw $02, $72a0
	dbw $03, $72f8
	dbw $05, $72b9
	db  $00

EnergySearchEffectCommands:
	dbw $01, $731c
	dbw $03, $7372
	dbw $05, $7328
	db  $00

ProfessorOakEffectCommands:
	dbw $03, $73a1
	db  $00

PotionEffectCommands:
	dbw $01, $73ca
	dbw $02, $73d1
	dbw $03, $73ef
	db  $00

GamblerEffectCommands:
	dbw $03, $73f9
	db  $00

ItemFinderEffectCommands:
	dbw $01, $743b
	dbw $02, $744a
	dbw $03, $7463
	db  $00

DefenderEffectCommands:
	dbw $02, $7488
	dbw $03, $7499
	db  $00

MysteriousFossilEffectCommands:
	dbw $01, $74b3
	dbw $03, $74bf
	db  $00

FullHealEffectCommands:
	dbw $01, $74c5
	dbw $03, $74d1
	db  $00

ImposterProfessorOakEffectCommands:
	dbw $03, $74e1
	db  $00

ComputerSearchEffectCommands:
	dbw $01, $7513
	dbw $02, $752a
	dbw $03, $7545
	dbw $05, $752e
	db  $00

ClefairyDollEffectCommands:
	dbw $01, $7561
	dbw $03, $756d
	db  $00

MrFujiEffectCommands:
	dbw $01, $7573
	dbw $02, $757e
	dbw $03, $758f
	db  $00

PlusPowerEffectCommands:
	dbw $03, $75e0
	db  $00

SwitchEffectCommands:
	dbw $01, $75ee
	dbw $02, $75f9
	dbw $03, $760a
	db  $00

PokemonCenterEffectCommands:
	dbw $01, $7611
	dbw $03, $7618
	db  $00

PokemonFluteEffectCommands:
	dbw $01, $7659
	dbw $02, $7672
	dbw $03, $768f
	db  $00

PokemonBreederEffectCommands:
	dbw $01, $76b3
	dbw $02, $76c1
	dbw $03, $76f4
	db  $00

ScoopUpEffectCommands:
	dbw $01, $7795
	dbw $02, $77a0
	dbw $03, $77c3
	db  $00

PokemonTraderEffectCommands:
	dbw $01, $7826
	dbw $02, $7838
	dbw $03, $788d
	dbw $05, $7853
	db  $00

PokedexEffectCommands:
	dbw $01, $78e1
	dbw $03, $79aa
	dbw $05, $78ed
	db  $00

BillEffectCommands:
	dbw $03, $79c4
	db  $00

LassEffectCommands:
	dbw $03, $79e3
	db  $00

MaintenanceEffectCommands:
	dbw $01, $7a70
	dbw $02, $7a7b
	dbw $03, $7a85
	db  $00

PokeBallEffectCommands:
	dbw $01, $7aad
	dbw $03, $7b15
	dbw $05, $7ab9
	db  $00

RecycleEffectCommands:
	dbw $01, $7b36
	dbw $03, $7b68
	dbw $05, $7b41
	db  $00

ReviveEffectCommands:
	dbw $01, $7b80
	dbw $02, $7b93
	dbw $03, $7bb0
	db  $00

DevolutionSprayEffectCommands:
	dbw $01, $7c0b
	dbw $02, $7c24
	dbw $03, $7c99
	db  $00

SuperEnergyRemovalEffectCommands:
	dbw $01, $7cd0
	dbw $02, $7ce4
	dbw $03, $7d73
	db  $00

SuperEnergyRetrievalEffectCommands:
	dbw $01, $7da4
	dbw $02, $7db6
	dbw $03, $7dfa
	dbw $05, $7dba
	db  $00

GustofWindEffectCommands:
	dbw $01, $7e6e
	dbw $02, $7e79
	dbw $03, $7e90
	db  $00
