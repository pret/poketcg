EffectCommands: ; 186f7 (6:46f7)
; Each move has a two-byte effect pointer (move's 7th param) that points to one of these structures.
; Similarly, trainer cards have a two-byte pointer (7th param) to one of these structures, which determines the card's function.
; Energy cards also point to one of these, but their data is just $00.
;	db EFFECTCMDTYPE_* ($01 - $0a)
;	dw Function
;	...
;	db $00

; Commands are associated to a time or a scope (EFFECTCMDTYPE_*) that determines when their function is executed during the turn.
; - EFFECTCMDTYPE_INITIAL_EFFECT_1: Executed right after move or trainer card is used. Bypasses Smokescreen and Sand Attack effects.
; - EFFECTCMDTYPE_INITIAL_EFFECT_2: Executed right after move, Pokemon Power, or trainer card is used.
; - EFFECTCMDTYPE_DISCARD_ENERGY: For moves or trainer cards that require putting one or more attached energy cards into the discard pile.
; - EFFECTCMDTYPE_REQUIRE_SELECTION: For moves, Pokemon Powers, or trainer cards requring the user to select a card (from e.g. play area screen or card list).
; - EFFECTCMDTYPE_BEFORE_DAMAGE: Effect command of a move executed prior to the damage step. For trainer card or Pokemon Power, usually the main effect.
; - EFFECTCMDTYPE_AFTER_DAMAGE: Effect command executed after the damage step
; - EFFECTCMDTYPE_SWITCH_DEFENDING_PKMN: For moves that may result in the defending Pokemon being switched out
; - EFFECTCMDTYPE_PKMN_POWER_TRIGGER: Pokemon Power effects that trigger the moment the Pokemon card is played
; - EFFECTCMDTYPE_AI: Used for AI scoring
; - EFFECTCMDTYPE_UNKNOWN_08: Unknown

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
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, SpitPoison_Poison50PercentEffect
	dbw EFFECTCMDTYPE_AI, SpitPoison_AIEffect
	db  $00

EkansWrapEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

ArbokTerrorStrikeEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, TerrorStrike_SwitchDefendingPokemon
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, TerrorStrike_50PercentSelectSwitchPokemon
	dbw EFFECTCMDTYPE_SWITCH_DEFENDING_PKMN, TerrorStrike_50PercentSelectSwitchPokemon
	db  $00

ArbokPoisonFangEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, PoisonEffect
	dbw EFFECTCMDTYPE_AI, PoisonFang_AIEffect
	db  $00

WeepinbellPoisonPowderEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Poison50PercentEffect
	dbw EFFECTCMDTYPE_AI, WeepinbellPoisonPowder_AIEffect
	db  $00

VictreebelLureEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $4740
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $476a
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $474b
	dbw EFFECTCMDTYPE_UNKNOWN_08, $4764
	db  $00

VictreebelAcidEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, AcidEffect
	db  $00

PinsirIronGripEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

CaterpieStringShotEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

GloomPoisonPowderEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, PoisonEffect
	dbw EFFECTCMDTYPE_AI, GloomPoisonPowder_AIEffect
	db  $00

GloomFoulOdorEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, FoulOdorEffect
	db  $00

KakunaStiffenEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, KakunaStiffenEffect
	db  $00

KakunaPoisonPowderEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Poison50PercentEffect
	dbw EFFECTCMDTYPE_AI, KakunaPoisonPowder_AIEffect
	db  $00

GolbatLeechLifeEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $47bc
	db  $00

VenonatStunSporeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

VenonatLeechLifeEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $47c6
	db  $00

ScytherSwordsDanceEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, SwordsDanceEffect
	db  $00

ZubatSupersonicEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, ZubatSupersonicEffect
	db  $00

ZubatLeechLifeEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $47e3
	db  $00

BeedrillTwineedleEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Twineedle_MultiplierEffect
	dbw EFFECTCMDTYPE_AI, Twineedle_AIEffect
	db  $00

BeedrillPoisonStingEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Poison50PercentEffect
	dbw EFFECTCMDTYPE_AI, $480d
	db  $00

ExeggcuteHypnosisEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, SleepEffect
	db  $00

ExeggcuteLeechSeedEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4815
	db  $00

KoffingFoulGasEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, FoulGas_PoisonOrConfusionEffect
	dbw EFFECTCMDTYPE_AI, FoulGas_AIEffect
	db  $00

MetapodStiffenEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, MetapodStiffenEffect
	db  $00

MetapodStunSporeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

OddishStunSporeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

OddishSproutEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $484a
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $48cc
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $485a
	dbw EFFECTCMDTYPE_UNKNOWN_08, $48b7
	db  $00

ExeggutorTeleportEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $48ec
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $491a
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $48f7
	dbw EFFECTCMDTYPE_UNKNOWN_08, $490f
	db  $00

ExeggutorBigEggsplosionEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, BigEggsplosion_MultiplierEffect
	dbw EFFECTCMDTYPE_AI, BigEggsplosion_AIEffect
	db  $00

NidokingThrashEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Thrash_ModifierEffect
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, Func_2c982
	dbw EFFECTCMDTYPE_AI, Thrash_AIEffect
	db  $00

NidokingToxicEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Toxic_DoublePoisonEffect
	dbw EFFECTCMDTYPE_AI, Toxic_AIEffect
	db  $00

NidoqueenBoyfriendsEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4998
	db  $00

NidoranFFurySweepesEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $49c6
	dbw EFFECTCMDTYPE_AI, $49be
	db  $00

NidoranFCallForFamilyEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $49db
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4a6e
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $49eb
	dbw EFFECTCMDTYPE_UNKNOWN_08, $4a55
	db  $00

NidoranMHornHazardEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4a96
	dbw EFFECTCMDTYPE_AI, $4a8e
	db  $00

NidorinaSupersonicEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4aac
	db  $00

NidorinaDoubleKickEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4abb
	dbw EFFECTCMDTYPE_AI, $4ab3
	db  $00

NidorinoDoubleKickEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4adb
	dbw EFFECTCMDTYPE_AI, $4ad3
	db  $00

ButterfreeWhirlwindEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4b09
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $4af3
	dbw EFFECTCMDTYPE_SWITCH_DEFENDING_PKMN, $4af3
	db  $00

ButterfreeMegaDrainEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4b0f
	db  $00

ParasSporeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, SleepEffect
	db  $00

ParasectSporeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, SleepEffect
	db  $00

WeedlePoisonStingEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Poison50PercentEffect
	dbw EFFECTCMDTYPE_AI, $4b27
	db  $00

IvysaurPoisonPowderEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, PoisonEffect
	dbw EFFECTCMDTYPE_AI, $4b2f
	db  $00

BulbasaurLeechSeedEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4b37
	db  $00

VenusaurEnergyTransEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $4b44
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4b77
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4bfb
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $4b6f
	db  $00

GrimerNastyGooEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

GrimerMinimizeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4c30
	db  $00

MukToxicGasEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $4c36
	db  $00

MukSludgeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Poison50PercentEffect
	dbw EFFECTCMDTYPE_AI, $4c38
	db  $00

BellsproutCallForFamilyEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $4c40
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4cc2
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $4c50
	dbw EFFECTCMDTYPE_UNKNOWN_08, $4cad
	db  $00

WeezingSmogEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Poison50PercentEffect
	dbw EFFECTCMDTYPE_AI, $4ce2
	db  $00

WeezingSelfdestructEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4cea
	db  $00

VenomothShiftEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $4d09
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4d5d
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $4d21
	db  $00

VenomothVenomPowderEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4d8c
	dbw EFFECTCMDTYPE_AI, $4d84
	db  $00

TangelaBindEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

TangelaPoisonPowderEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, PoisonEffect
	dbw EFFECTCMDTYPE_AI, $4da0
	db  $00

VileplumeHealEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $4da8
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4dc7
	db  $00

VileplumePetalDanceEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4e2b
	dbw EFFECTCMDTYPE_AI, $4e23
	db  $00

TangelaStunSporeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

TangelaPoisonWhipEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, PoisonEffect
	dbw EFFECTCMDTYPE_AI, $4e4b
	db  $00

VenusaurSolarPowerEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $4e53
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4e82
	db  $00

VenusaurMegaDrainEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4eb0
	db  $00

OmastarWaterGunEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4f05
	dbw EFFECTCMDTYPE_AI, $4f05
	db  $00

OmastarSpikeCannonEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4f12
	dbw EFFECTCMDTYPE_AI, $4f0a
	db  $00

OmanyteClairvoyanceEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $4f2a
	db  $00

OmanyteWaterGunEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4f2c
	dbw EFFECTCMDTYPE_AI, $4f2c
	db  $00

WartortleWithdrawEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4f32
	db  $00

BlastoiseRainDanceEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $4f46
	db  $00

BlastoiseHydroPumpEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4f48
	dbw EFFECTCMDTYPE_AI, $4f48
	db  $00

GyaradosBubblebeamEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

KinglerFlailEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $4f54
	dbw EFFECTCMDTYPE_AI, $4f4e
	db  $00

KrabbyCallForFamilyEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $4f5d
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $4fdf
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $4f6d
	dbw EFFECTCMDTYPE_UNKNOWN_08, $4fca
	db  $00

MagikarpFlailEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5005
	dbw EFFECTCMDTYPE_AI, $4fff
	db  $00

PsyduckHeadacheEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $500e
	db  $00

PsyduckFurySweepesEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $501e
	dbw EFFECTCMDTYPE_AI, $5016
	db  $00

GolduckPsyshockEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

GolduckHyperBeamEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $506b
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5033
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5065
	db  $00

SeadraWaterGunEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5085
	dbw EFFECTCMDTYPE_AI, $5085
	db  $00

SeadraAgilityEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $508b
	db  $00

ShellderSupersonicEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $509d
	db  $00

ShellderHideInShellEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $50a4
	db  $00

VaporeonQuickAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $50c0
	dbw EFFECTCMDTYPE_AI, $50b8
	db  $00

VaporeonWaterGunEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $50d3
	dbw EFFECTCMDTYPE_AI, $50d3
	db  $00

DewgongIceBeamEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

StarmieRecoverEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $50d9
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $50f0
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5114
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $510e
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5103
	db  $00

StarmieStarFreezeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

SquirtleBubbleEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

SquirtleWithdrawEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5120
	db  $00

HorseaSmokescreenEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5134
	db  $00

TentacruelSupersonicEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $513a
	db  $00

TentacruelJellyfishStingEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, PoisonEffect
	dbw EFFECTCMDTYPE_AI, $5141
	db  $00

PoliwhirlAmnesiaEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5149
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $516f
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5179
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5173
	db  $00

PoliwhirlDoubleslapEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $51c8
	dbw EFFECTCMDTYPE_AI, $51c0
	db  $00

PoliwrathWaterGunEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $51e0
	dbw EFFECTCMDTYPE_AI, $51e0
	db  $00

PoliwrathWhirlpoolEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5214
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $51e6
	dbw EFFECTCMDTYPE_UNKNOWN_08, $520e
	db  $00

PoliwagWaterGunEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5227
	dbw EFFECTCMDTYPE_AI, $5227
	db  $00

CloysterClampEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $522d
	db  $00

CloysterSpikeCannonEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $524e
	dbw EFFECTCMDTYPE_AI, $5246
	db  $00

ArticunoFreezeDryEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

ArticunoBlizzardEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5266
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $526f
	db  $00

TentacoolCowardiceEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $528b
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $52c3
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $52ae
	db  $00

LaprasWaterGunEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $52eb
	dbw EFFECTCMDTYPE_AI, $52eb
	db  $00

LaprasConfuseRayEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Confusion50PercentEffect
	db  $00

ArticunoQuickfreezeEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $52f1
	dbw EFFECTCMDTYPE_PKMN_POWER_TRIGGER, $52f3
	db  $00

ArticunoIceBreathEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5329
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $532e
	db  $00

VaporeonFocusEnergyEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $533f
	db  $00

ArcanineFlamethrowerEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5363
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5371
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $5379
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5375
	db  $00

ArcanineTakeDownEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $537f
	db  $00

ArcanineQuickAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $538d
	dbw EFFECTCMDTYPE_AI, $5385
	db  $00

ArcanineFlamesOfRageEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $53a0
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $53ae
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $53ef
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $53de
	dbw EFFECTCMDTYPE_UNKNOWN_08, $53d5
	dbw EFFECTCMDTYPE_AI, $53e9
	db  $00

RapidashStompEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5400
	dbw EFFECTCMDTYPE_AI, $53f8
	db  $00

RapidashAgilityEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5413
	db  $00

NinetailsLureEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5425
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $544f
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5430
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5449
	db  $00

NinetailsFireBlastEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5463
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5471
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $5479
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5475
	db  $00

CharmanderEmberEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $547f
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $548d
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $5495
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5491
	db  $00

MoltresWildfireEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $549b
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $54a9
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $54f4
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $54e1
	dbw EFFECTCMDTYPE_UNKNOWN_08, $54dd
	db  $00

Moltres1DiveBombEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $552b
	dbw EFFECTCMDTYPE_AI, $5523
	db  $00

FlareonQuickAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5549
	dbw EFFECTCMDTYPE_AI, $5541
	db  $00

FlareonFlamethrowerEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $555c
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $556a
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $5572
	dbw EFFECTCMDTYPE_UNKNOWN_08, $556e
	db  $00

MagmarFlamethrowerEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5578
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5586
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $558e
	dbw EFFECTCMDTYPE_UNKNOWN_08, $558a
	db  $00

MagmarSmokescreenEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5594
	db  $00

MagmarSmogEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Poison50PercentEffect
	dbw EFFECTCMDTYPE_AI, $559a
	db  $00

CharmeleonFlamethrowerEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $55a2
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $55b0
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $55b8
	dbw EFFECTCMDTYPE_UNKNOWN_08, $55b4
	db  $00

CharizardEnergyBurnEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $55be
	db  $00

CharizardFireSpinEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $55c0
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $55cd
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $5614
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5606
	db  $00

VulpixConfuseRayEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Confusion50PercentEffect
	db  $00

FlareonRageEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $563e
	dbw EFFECTCMDTYPE_AI, $5638
	db  $00

NinetailsMixUpEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5647
	db  $00

NinetailsDancingEmbersEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $56ab
	dbw EFFECTCMDTYPE_AI, $56a3
	db  $00

MoltresFiregiverEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $56c0
	dbw EFFECTCMDTYPE_PKMN_POWER_TRIGGER, $56c2
	db  $00

Moltres2DiveBombEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5776
	dbw EFFECTCMDTYPE_AI, $576e
	db  $00

AbraPsyshockEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

GengarCurseEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $57fc
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $58bb
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5834
	db  $00

GengarDarkMindEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $593c
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5903
	dbw EFFECTCMDTYPE_UNKNOWN_08, $592a
	db  $00

GastlySleepingGasEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $594f
	db  $00

GastlyDestinyBondEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5956
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5964
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5987
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $5981
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5976
	db  $00

GastlyLickEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

GastlyEnergyConversionEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $598d
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $59b4
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5994
	dbw EFFECTCMDTYPE_UNKNOWN_08, $599b
	db  $00

HaunterHypnosisEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, SleepEffect
	db  $00

HaunterDreamEaterEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $59d6
	db  $00

HaunterTransparencyEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $59e5
	db  $00

HaunterNightmareEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, SleepEffect
	db  $00

HypnoProphecyEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $59e7
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5a41
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5a00
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5a3c
	db  $00

HypnoDarkMindEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5b64
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5b2b
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5b52
	db  $00

DrowzeeConfuseRayEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Confusion50PercentEffect
	db  $00

MrMimeInvisibleWallEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5b77
	db  $00

MrMimeMeditateEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5b7f
	dbw EFFECTCMDTYPE_AI, $5b79
	db  $00

AlakazamDamageSwapEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5b8e
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5ba2
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5c27
	db  $00

AlakazamConfuseRayEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Confusion50PercentEffect
	db  $00

MewPsywaveEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5c49
	db  $00

MewDevolutionBeamEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5c53
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5c64
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5cb6
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5cbb
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5c9e
	db  $00

MewNeutralizingShieldEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5d79
	db  $00

MewPsyshockEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

MewtwoPsychicEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5d81
	dbw EFFECTCMDTYPE_AI, $5d7b
	db  $00

MewtwoBarrierEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5d8e
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5d9c
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5dbf
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $5db9
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5dae
	db  $00

Mewtwo3EnergyAbsorptionEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5dc5
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5dec
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5dcc
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5dd3
	db  $00

Mewtwo2EnergyAbsorptionEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5dff
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5e26
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5e06
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5e0d
	db  $00

SlowbroStrangeBehaviorEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5e39
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5e5b
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5eb3
	db  $00

SlowbroPsyshockEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

SlowpokeSpacingOutEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5ed5
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5ee0
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5ef1
	db  $00

SlowpokeScavengeEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5f05
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5f1a
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5f5f
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $5f46
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $5f40
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5f2d
	db  $00

SlowpokeAmnesiaEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5f74
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5f7b
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5f85
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5f7f
	db  $00

KadabraRecoverEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $5f89
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $5fa0
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $5fc3
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $5fbd
	dbw EFFECTCMDTYPE_UNKNOWN_08, $5fb2
	db  $00

JynxDoubleslapEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5fd7
	dbw EFFECTCMDTYPE_AI, $5fcf
	db  $00

JynxMeditateEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $5ff2
	dbw EFFECTCMDTYPE_AI, $5fec
	db  $00

MewMysteryAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6009
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $603e
	dbw EFFECTCMDTYPE_AI, $6001
	db  $00

GeodudeStoneBarrageEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6052
	dbw EFFECTCMDTYPE_AI, $604a
	db  $00

OnixHardenEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6075
	db  $00

PrimeapeFurySweepesEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6083
	dbw EFFECTCMDTYPE_AI, $607b
	db  $00

PrimeapeTantrumEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6099
	db  $00

MachampStrikesBackEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $60af
	db  $00

KabutoKabutoArmorEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $60b1
	db  $00

KabutopsAbsorbEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $60b3
	db  $00

CuboneSnivelEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $60cb
	db  $00

CuboneRageEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $60d7
	dbw EFFECTCMDTYPE_AI, $60d1
	db  $00

MarowakBonemerangEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $60e8
	dbw EFFECTCMDTYPE_AI, $60e0
	db  $00

MarowakCallforFriendEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6100
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6194
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $6110
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6177
	db  $00

MachokeKarateChopEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $61ba
	dbw EFFECTCMDTYPE_AI, $61b4
	db  $00

MachokeSubmissionEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $61d1
	db  $00

GolemSelfdestructEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $61d7
	db  $00

GravelerHardenEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $61f6
	db  $00

RhydonRamEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6212
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $61fc
	dbw EFFECTCMDTYPE_SWITCH_DEFENDING_PKMN, $61fc
	db  $00

RhyhornLeerEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $621d
	db  $00

HitmonleeStretchKickEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6231
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $625b
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $623c
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6255
	db  $00

SandshrewSandAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $626b
	db  $00

SandslashFurySweepesEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6279
	dbw EFFECTCMDTYPE_AI, $6271
	db  $00

DugtrioEarthquakeEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $628f
	db  $00

AerodactylPrehistoricPowerEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $629a
	db  $00

MankeyPeekEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $629c
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $62b4
	db  $00

MarowakBoneAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $630f
	db  $00

MarowakWailEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $631c
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6335
	db  $00

ElectabuzzThundershockEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

ElectabuzzThunderpunchEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $63a1
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $63b0
	dbw EFFECTCMDTYPE_AI, $6399
	db  $00

ElectabuzzLightScreenEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $63ba
	db  $00

ElectabuzzQuickAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $63c8
	dbw EFFECTCMDTYPE_AI, $63c0
	db  $00

MagnemiteThunderWaveEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

MagnemiteSelfdestructEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $63db
	db  $00

ZapdosThunderEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $63fa
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6409
	db  $00

ZapdosThunderboltEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6419
	db  $00

ZapdosThunderstormEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6429
	db  $00

JolteonQuickAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $64c3
	dbw EFFECTCMDTYPE_AI, $64bb
	db  $00

JolteonPinMissileEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $64de
	dbw EFFECTCMDTYPE_AI, $64d6
	db  $00

FlyingPikachuThundershockEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

FlyingPikachuFlyEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $64fc
	dbw EFFECTCMDTYPE_AI, $64f4
	db  $00

PikachuThunderJoltEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $651a
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6529
	db  $00

PikachuSparkEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6574
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $6539
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6562
	db  $00

Pikachu3GrowlEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6589
	db  $00

Pikachu3ThundershockEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

Pikachu4GrowlEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $658f
	db  $00

Pikachu4ThundershockEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

ElectrodeChainLightningEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6595
	db  $00

RaichuAgilityEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $65dc
	db  $00

RaichuThunderEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $65ee
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $65fd
	db  $00

RaichuGigashockEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $671f
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $660d
	dbw EFFECTCMDTYPE_UNKNOWN_08, $66c3
	db  $00

MagnetonThunderWaveEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

Magneton1SelfdestructEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6739
	db  $00

MagnetonSonicboomEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6758
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $675e
	dbw EFFECTCMDTYPE_AI, $6758
	db  $00

Magneton2SelfdestructEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $675f
	db  $00

ZapdosPealOfThunderEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $677e
	dbw EFFECTCMDTYPE_PKMN_POWER_TRIGGER, $6780
	db  $00

ZapdosBigThunderEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $67cb
	db  $00

MagnemiteMagneticStormEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $67d5
	db  $00

ElectrodeSonicboomEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6870
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6876
	dbw EFFECTCMDTYPE_AI, $6870
	db  $00

ElectrodeEnergySpikeEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6877
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $68f6
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $687b
	dbw EFFECTCMDTYPE_UNKNOWN_08, $68f1
	db  $00

JolteonDoubleKickEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6938
	dbw EFFECTCMDTYPE_AI, $6930
	db  $00

JolteonStunNeedleEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

EeveeTailWagEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $694e
	db  $00

EeveeQuickAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $696a
	dbw EFFECTCMDTYPE_AI, $6962
	db  $00

SpearowMirrorMoveEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $697f
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $6981
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6987
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6989
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $6983
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6985
	dbw EFFECTCMDTYPE_AI, $697d
	db  $00

FearowAgilityEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6ab8
	db  $00

DragoniteStepInEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $6aca
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6ae8
	db  $00

Dragonite2SlamEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6afe
	dbw EFFECTCMDTYPE_AI, $6af6
	db  $00

SnorlaxThickSkinnedEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6b15
	db  $00

SnorlaxBodySlamEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

FarfetchdLeekSlapEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6b1f
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6b34
	dbw EFFECTCMDTYPE_DISCARD_ENERGY, $6b2c
	dbw EFFECTCMDTYPE_AI, $6b17
	db  $00

KangaskhanFetchEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6b40
	db  $00

KangaskhanCometPunchEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6b65
	dbw EFFECTCMDTYPE_AI, $6b5d
	db  $00

TaurosStompEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6b83
	dbw EFFECTCMDTYPE_AI, $6b7b
	db  $00

TaurosRampageEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6ba1
	dbw EFFECTCMDTYPE_AI, $6b96
	db  $00

DoduoFuryAttackEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6bc2
	dbw EFFECTCMDTYPE_AI, $6bba
	db  $00

DodrioRetreatAidEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6bd7
	db  $00

DodrioRageEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6bdf
	dbw EFFECTCMDTYPE_AI, $6bd9
	db  $00

MeowthPayDayEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6be8
	db  $00

DragonairSlamEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6c14
	dbw EFFECTCMDTYPE_AI, $6c0c
	db  $00

DragonairHyperBeamEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6c35
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $6c2c
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6c2f
	db  $00

ClefableMetronomeEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6c77
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $6c82
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6c7e
	db  $00

ClefableMinimizeEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6c88
	db  $00

PidgeotHurricaneEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6c8e
	db  $00

PidgeottoWhirlwindEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6ce9
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $6cd3
	dbw EFFECTCMDTYPE_SWITCH_DEFENDING_PKMN, $6cd3
	db  $00

PidgeottoMirrorMoveEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6cf2
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $6cf5
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6cfe
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6d01
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $6cf8
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6cfb
	dbw EFFECTCMDTYPE_AI, $6cef
	db  $00

ClefairySingEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6d04
	db  $00

ClefairyMetronomeEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6d0b
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $6d16
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6d12
	db  $00

WigglytuffLullabyEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, SleepEffect
	db  $00

WigglytuffDoTheWaveEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6d87
	dbw EFFECTCMDTYPE_AI, $6d87
	db  $00

JigglypuffLullabyEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, SleepEffect
	db  $00

JigglypuffFirstAidEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6d94
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6d9f
	db  $00

JigglypuffDoubleEdgeEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6da6
	db  $00

PersianPounceEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6dac
	db  $00

LickitungTongueWrapEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, Paralysis50PercentEffect
	db  $00

LickitungSupersonicEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6db2
	db  $00

PidgeyWhirlwindEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6dcf
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $6db9
	dbw EFFECTCMDTYPE_SWITCH_DEFENDING_PKMN, $6db9
	db  $00

PorygonConversion1EffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6dd5
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $6ded
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6dfb
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6df7
	db  $00

PorygonConversion2EffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6e1f
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $6e31
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6e5e
	dbw EFFECTCMDTYPE_UNKNOWN_08, $6e3c
	db  $00

ChanseyScrunchEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6ee7
	db  $00

ChanseyDoubleEdgeEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6efb
	db  $00

RaticateSuperFangEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6f07
	dbw EFFECTCMDTYPE_AI, $6f01
	db  $00

TrainerCardAsPokemonEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $6f18
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6f3c
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $6f27
	db  $00

DragoniteHealingWindEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $6f51
	dbw EFFECTCMDTYPE_PKMN_POWER_TRIGGER, $6f53
	db  $00

Dragonite1SlamEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $6fa4
	dbw EFFECTCMDTYPE_AI, $6f9c
	db  $00

MeowthCatPunchEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6fe0
	db  $00

DittoMorphEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $6ff6
	db  $00

PidgeotSlicingWindEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $70bf
	db  $00

PidgeotGaleEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $70d0
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $70d6
	db  $00

JigglypuffFriendshipSongEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $710d
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $7119
	db  $00

JigglypuffExpandEffectCommands:
	dbw EFFECTCMDTYPE_AFTER_DAMAGE, $7153
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
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7159
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7167
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $71b5
	db  $00

ImakuniEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7216
	db  $00

EnergyRemovalEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7252
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $725f
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7273
	dbw EFFECTCMDTYPE_UNKNOWN_08, $726f
	db  $00

EnergyRetrievalEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $728e
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $72a0
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $72f8
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $72b9
	db  $00

EnergySearchEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $731c
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7372
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $7328
	db  $00

ProfessorOakEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $73a1
	db  $00

PotionEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $73ca
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $73d1
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $73ef
	db  $00

GamblerEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $73f9
	db  $00

ItemFinderEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $743b
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $744a
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7463
	db  $00

DefenderEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7488
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7499
	db  $00

MysteriousFossilEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $74b3
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $74bf
	db  $00

FullHealEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $74c5
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $74d1
	db  $00

ImposterProfessorOakEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, ImposterProfessorOakEffect
	db  $00

ComputerSearchEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7513
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $752a
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7545
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $752e
	db  $00

ClefairyDollEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7561
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $756d
	db  $00

MrFujiEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7573
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $757e
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $758f
	db  $00

PlusPowerEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $75e0
	db  $00

SwitchEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $75ee
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $75f9
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $760a
	db  $00

PokemonCenterEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7611
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7618
	db  $00

PokemonFluteEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7659
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7672
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $768f
	db  $00

PokemonBreederEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $76b3
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $76c1
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $76f4
	db  $00

ScoopUpEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7795
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $77a0
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $77c3
	db  $00

PokemonTraderEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7826
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7838
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $788d
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $7853
	db  $00

PokedexEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $78e1
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $79aa
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $78ed
	db  $00

BillEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $79c4
	db  $00

LassEffectCommands:
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $79e3
	db  $00

MaintenanceEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7a70
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7a7b
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7a85
	db  $00

PokeBallEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7aad
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7b15
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $7ab9
	db  $00

RecycleEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7b36
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7b68
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $7b41
	db  $00

ReviveEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7b80
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7b93
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7bb0
	db  $00

DevolutionSprayEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7c0b
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7c24
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7c99
	db  $00

SuperEnergyRemovalEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7cd0
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7ce4
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7d73
	db  $00

SuperEnergyRetrievalEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7da4
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7db6
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7dfa
	dbw EFFECTCMDTYPE_REQUIRE_SELECTION, $7dba
	db  $00

GustOfWindEffectCommands:
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_1, $7e6e
	dbw EFFECTCMDTYPE_INITIAL_EFFECT_2, $7e79
	dbw EFFECTCMDTYPE_BEFORE_DAMAGE, $7e90
	db  $00
