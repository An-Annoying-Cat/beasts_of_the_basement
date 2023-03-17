local Mod = BotB
local Enums = {}
    
Enums.Entities = {
    --GAPERS

    --Gaper Variants
    ACME = {
        TYPE = Isaac.GetEntityTypeByName("Acme"),
        VARIANT = Isaac.GetEntityVariantByName("Acme"),
    },

    --Mr Horf Variants
    HORF_GIRL = {
        TYPE = Isaac.GetEntityTypeByName("Horf (girl)"),
        VARIANT = Isaac.GetEntityVariantByName("Horf (girl)"),
        SUBTYPE = 10
    },
    LADY_HORF = {
        TYPE = Isaac.GetEntityTypeByName("Lady Horf"),
        VARIANT = Isaac.GetEntityVariantByName("Lady Horf"),
        SUBTYPE = 10
    },

    --Skinny variants
    GIBBY = {
        TYPE = Isaac.GetEntityTypeByName("Gibby"),
        VARIANT = Isaac.GetEntityVariantByName("Gibby"),
    },

    --Hive Variants
    SLEAZEBAG = {
        TYPE = Isaac.GetEntityTypeByName("Sleazebag"),
        VARIANT = Isaac.GetEntityVariantByName("Sleazebag"),
    },
    
    --Bony variants
    SPICY_BONY = {
        TYPE = Isaac.GetEntityTypeByName("Spicy Bony"),
        VARIANT = Isaac.GetEntityVariantByName("Spicy Bony"),
    },

    --Keeper Variants
    DESIRER = {
        TYPE = Isaac.GetEntityTypeByName("Desirer"),
        VARIANT = Isaac.GetEntityVariantByName("Desirer"),
    },
    SEDUCER = {
        TYPE = Isaac.GetEntityTypeByName("Seducer"),
        VARIANT = Isaac.GetEntityVariantByName("Seducer"),
    },

    --Ms Horf
    MS_HORF = {
        TYPE = Isaac.GetEntityTypeByName("Ms. Horf"),
        VARIANT = Isaac.GetEntityVariantByName("Ms. Horf"),
    },
    MS_HORF_HEAD = {
        TYPE = Isaac.GetEntityTypeByName("Thrown Horf (girl)"),
        VARIANT = Isaac.GetEntityVariantByName("Thrown Horf (girl)"),
        SUBTYPE = 0
    },

    --Maw variants
    CHAFF = {
        TYPE = Isaac.GetEntityTypeByName("Chaff"),
        VARIANT = Isaac.GetEntityVariantByName("Chaff"),
    },

    --Sniffle Variants
    PALE_SNIFFLE = {
        TYPE = Isaac.GetEntityTypeByName("Pale Sniffle"),
        VARIANT = Isaac.GetEntityVariantByName("Pale Sniffle"),
    },

    --Blood Cultist Variants
    KEHEHAN = {
        TYPE = Isaac.GetEntityTypeByName("Kehehan"),
        VARIANT = Isaac.GetEntityVariantByName("Kehehan"),
        SUBTYPE = 10
    },
    THAUMATURGE = {
        TYPE = Isaac.GetEntityTypeByName("Thaumaturge"),
        VARIANT = Isaac.GetEntityVariantByName("Thaumaturge"),
        SUBTYPE = 11
    },

    --INSECTS

    --Swarm Spider Variants
    HUMBLED = {
        TYPE = Isaac.GetEntityTypeByName("Humbled"),
        VARIANT = Isaac.GetEntityVariantByName("Humbled"),
    },

    --Wall Creep Variants
    PLANECREEP = {
        TYPE = Isaac.GetEntityTypeByName("Plane Creep"),
        VARIANT = Isaac.GetEntityVariantByName("Plane Creep"),
    },

    --Skuzz Variants
    SKUZZ = {
        TYPE = Isaac.GetEntityTypeByName("Skuzz"),
        VARIANT = Isaac.GetEntityVariantByName("Skuzz"),
    },
    SKOOTER = {
        TYPE = Isaac.GetEntityTypeByName("Skooter"),
        VARIANT = Isaac.GetEntityVariantByName("Skooter"),
        SUBTYPE = 10
    },
    SUPER_SKOOTER = {
        TYPE = Isaac.GetEntityTypeByName("Super Skooter"),
        VARIANT = Isaac.GetEntityVariantByName("Super Skooter"),
        SUBTYPE = 11
    },
    ETERNAL_FLY_DUMMY = {
        TYPE = Isaac.GetEntityTypeByName("Eternal Fly Dummy"),
        VARIANT = Isaac.GetEntityVariantByName("Eternal Fly Dummy"),
    },

    -- Level 2 Fly Variants
    DRONE = {
        TYPE = Isaac.GetEntityTypeByName("Drone"),
        VARIANT = Isaac.GetEntityVariantByName("Drone"),
    },

    -- Level 2 Fly Variants
    UNBOXER = {
        TYPE = Isaac.GetEntityTypeByName("Unboxer"),
        VARIANT = Isaac.GetEntityVariantByName("Unboxer"),
    },

    --Larry Variants (Larriants, if you will)
    CADRE = {
        TYPE = Isaac.GetEntityTypeByName("Cadre"),
        VARIANT = Isaac.GetEntityVariantByName("Cadre"),
        SUBTYPE = 30
    },

    --ANIMATES

    --Ministro Variants
    CULO = {
        TYPE = Isaac.GetEntityTypeByName("Culo"),
        VARIANT = Isaac.GetEntityVariantByName("Culo")
    },

    --Dip Variants
    PING = {
        TYPE = Isaac.GetEntityTypeByName("Ping"),
        VARIANT = Isaac.GetEntityVariantByName("Ping")
    },
    PONG = {
        TYPE = Isaac.GetEntityTypeByName("Pong"),
        VARIANT = Isaac.GetEntityVariantByName("Pong")
    },

    --Host Variants
    TIPPYTAP = {
        TYPE = Isaac.GetEntityTypeByName("Tippytap"),
        VARIANT = Isaac.GetEntityVariantByName("Tippytap")
    },
    CROAST = {
        TYPE = Isaac.GetEntityTypeByName("Croast"),
        VARIANT = Isaac.GetEntityVariantByName("Croast")
    },

    --Globin Variants
    GIBLET = {
        TYPE = Isaac.GetEntityTypeByName("Giblet"),
        VARIANT = Isaac.GetEntityVariantByName("Giblet")
    },


    --FAUNA

    --Fat Bat variants
    BATSO = {
        TYPE = Isaac.GetEntityTypeByName("Batso"),
        VARIANT = Isaac.GetEntityVariantByName("Batso")
    },
    FUN_GUY = {
        TYPE = Isaac.GetEntityTypeByName("Fun Guy"),
        VARIANT = Isaac.GetEntityVariantByName("Fun Guy")
    },

    --CONSTRUCTS

    --Knight variants
    HYDROKNIGHT = {
        TYPE = Isaac.GetEntityTypeByName("Hydro Knight"),
        VARIANT = Isaac.GetEntityVariantByName("Hydro Knight")
    },




    --Uniques
    KETTLE = {
        TYPE = Isaac.GetEntityTypeByName("Kettle"),
        VARIANT = Isaac.GetEntityVariantByName("Kettle")
    },
    --Yes, I know Crockpot comes after Shard in terms of variant number, but it's literally a stone version of crockpot so cut me some slack
    CROCKPOT = {
        TYPE = Isaac.GetEntityTypeByName("Crockpot"),
        VARIANT = Isaac.GetEntityVariantByName("Crockpot"),
    },
    SHARD = {
        TYPE = Isaac.GetEntityTypeByName("Shard"),
        VARIANT = Isaac.GetEntityVariantByName("Shard")
    },
    --Back on that Drifter grind...
    DRIFTER = {
        TYPE = Isaac.GetEntityTypeByName("Drifter"),
        VARIANT = Isaac.GetEntityVariantByName("Drifter"),
    },
    GOLFBALL = {
        TYPE = Isaac.GetEntityTypeByName("Golf Ball"),
        VARIANT = Isaac.GetEntityVariantByName("Golf Ball"),
    },
    INNIE_CW = {
        TYPE = Isaac.GetEntityTypeByName("Innie (CW)"),
        VARIANT = Isaac.GetEntityVariantByName("Innie (CW)"),
    },
    INNIE_CCW = {
        TYPE = Isaac.GetEntityTypeByName("Innie (CCW)"),
        VARIANT = Isaac.GetEntityVariantByName("Innie (CCW)"),
    },
    MABEL = {
        TYPE = Isaac.GetEntityTypeByName("Mabel"),
        VARIANT = Isaac.GetEntityVariantByName("Mabel"),
    },
    INCH_WORM = {
        TYPE = Isaac.GetEntityTypeByName("Inch Worm"),
        VARIANT = Isaac.GetEntityVariantByName("Inch Worm"),
    },
    PUER = {
        TYPE = Isaac.GetEntityTypeByName("Puer"),
        VARIANT = Isaac.GetEntityVariantByName("Puer"),
    },
    PUELLA = {
        TYPE = Isaac.GetEntityTypeByName("Puella"),
        VARIANT = Isaac.GetEntityVariantByName("Puella"),
    },
    OJ_TRAPCARD = {
        TYPE = Isaac.GetEntityTypeByName("OJ Trap Card"),
        VARIANT = Isaac.GetEntityVariantByName("OJ Trap Card"),
    },
    TAPE_WORM = {
        TYPE = Isaac.GetEntityTypeByName("Tape Worm"),
        VARIANT = Isaac.GetEntityVariantByName("Tape Worm"),
    },
    FERAL = {
        TYPE = Isaac.GetEntityTypeByName("Feral"),
        VARIANT = Isaac.GetEntityVariantByName("Feral"),
    },
    PAF = {
        TYPE = Isaac.GetEntityTypeByName("Paf"),
        VARIANT = Isaac.GetEntityVariantByName("Paf"),
    },
    SKIP_FLY = {
        TYPE = Isaac.GetEntityTypeByName("Skip Fly"),
        VARIANT = Isaac.GetEntityVariantByName("Skip Fly"),
    },
    FLAPJACK = {
        TYPE = Isaac.GetEntityTypeByName("Flapjack"),
        VARIANT = Isaac.GetEntityVariantByName("Flapjack"),
    },
    FLAPSTACK = {
        TYPE = Isaac.GetEntityTypeByName("Flapstack"),
        VARIANT = Isaac.GetEntityVariantByName("Flapstack"),
    },
    GRILLED_FLAPJACK = {
        TYPE = Isaac.GetEntityTypeByName("Grilled Flapjack"),
        VARIANT = Isaac.GetEntityVariantByName("Grilled Flapjack"),
    },
    GRILLED_FLAPSTACK = {
        TYPE = Isaac.GetEntityTypeByName("Grilled Flapstack"),
        VARIANT = Isaac.GetEntityVariantByName("Grilled Flapstack"),
    },
    SHITHEAD = {
        TYPE = Isaac.GetEntityTypeByName("Shithead"),
        VARIANT = Isaac.GetEntityVariantByName("Shithead"),
    },
    CHERRY = {
        TYPE = Isaac.GetEntityTypeByName("Cherry"),
        VARIANT = Isaac.GetEntityVariantByName("Cherry"),
    },
    BAMF = {
        TYPE = Isaac.GetEntityTypeByName("Bamf"),
        VARIANT = Isaac.GetEntityVariantByName("Bamf"),
    },
    BAMF_FLYBALL = {
        TYPE = Isaac.GetEntityTypeByName("Bamf Flyball"),
        VARIANT = Isaac.GetEntityVariantByName("Bamf Flyball"),
    },
    SPIDERBOI = {
        TYPE = Isaac.GetEntityTypeByName("Spider Boi"),
        VARIANT = Isaac.GetEntityVariantByName("Spider Boi"),
    },
    


    --Effects
    ACMES_ANVIL = {
        TYPE = Isaac.GetEntityTypeByName("Acme's Anvil"),
        VARIANT = Isaac.GetEntityVariantByName("Acme's Anvil")
    },

    WARNING_TARGET = {
        TYPE = Isaac.GetEntityTypeByName("Warning Target"),
        VARIANT = Isaac.GetEntityVariantByName("Warning Target")
    },

    CHARLESHELI = {
        TYPE = Isaac.GetEntityTypeByName("Charles Heli"),
        VARIANT = Isaac.GetEntityVariantByName("Charles Heli")
    },
    CHARLESHELIFUNNY = {
        TYPE = Isaac.GetEntityTypeByName("Charles Heli (Funny)"),
        VARIANT = Isaac.GetEntityVariantByName("Charles Heli (Funny)")
    },
    ABB_AURA = {
        TYPE = Isaac.GetEntityTypeByName("Atom Bomb Baby Aura"),
        VARIANT = Isaac.GetEntityVariantByName("Atom Bomb Baby Aura")
    },
    PP_AFTERIMAGE = {
        TYPE = Isaac.GetEntityTypeByName("PP Afterimage"),
        VARIANT = Isaac.GetEntityVariantByName("PP Afterimage")
    },
    BOX_PARTICLE = {
        TYPE = Isaac.GetEntityTypeByName("Box Particle"),
        VARIANT = Isaac.GetEntityVariantByName("Box Particle")
    },
    REVERSED_CONTROLS = {
        TYPE = Isaac.GetEntityTypeByName("Reversed Controls Icon"),
        VARIANT = Isaac.GetEntityVariantByName("Reversed Controls Icon")
    },
    SOLOMON_BESTIARY_UI = {
        TYPE = Isaac.GetEntityTypeByName("Solomon Bestiary UI"),
        VARIANT = Isaac.GetEntityVariantByName("Solomon Bestiary UI")
    },
    SOLOMON_KP_UI = {
        TYPE = Isaac.GetEntityTypeByName("Solomon KP UI"),
        VARIANT = Isaac.GetEntityVariantByName("Solomon KP UI")
    },


}

Enums.Familiars = {
    ROBOBABYZERO = {
        TYPE = Isaac.GetEntityTypeByName("Robo-Baby Zero"),
        VARIANT = Isaac.GetEntityVariantByName("Robo-Baby Zero"),
    },
    --[[
    NEEDLESPIANO = {
        TYPE = Isaac.GetEntityTypeByName("Needles Piano"),
        VARIANT = Isaac.GetEntityVariantByName("Needles Piano"),
    },
    --]]
    ONYXMARBLE = {
        TYPE = Isaac.GetEntityTypeByName("Onyx Marble"),
        VARIANT = Isaac.GetEntityVariantByName("Onyx Marble"),
    },
    ATOMBOMBBABY = {
        TYPE = Isaac.GetEntityTypeByName("Atom Bomb Baby"),
        VARIANT = Isaac.GetEntityVariantByName("Atom Bomb Baby"),
    },
    BHF = {
        TYPE = Isaac.GetEntityTypeByName("B.H.F."),
        VARIANT = Isaac.GetEntityVariantByName("B.H.F."),
    },
    FAITHFUL_FLEET = {
        TYPE = Isaac.GetEntityTypeByName("Faithful Fleet"),
        VARIANT = Isaac.GetEntityVariantByName("Faithful Fleet"),
    },
}

Enums.SFX = {
    DESIRER_ATTACK = Isaac.GetSoundIdByName("DesirerAttack"),
    ACME_DEATH = Isaac.GetSoundIdByName("AcmeDeath"),
    SEDUCER_ATTACK = Isaac.GetSoundIdByName("SeducerAttack"),
    WHEEZE = Isaac.GetSoundIdByName("Wheeze"),
    CARTOON_RICOCHET = Isaac.GetSoundIdByName("CartoonRicochet"),
    TIPPYTAPLOOP = Isaac.GetSoundIdByName("TippyTapLoop"),
    TIPPYTAPSTEP = Isaac.GetSoundIdByName("TippyTapStep"),
    CROASTLAND = Isaac.GetSoundIdByName("CroastLand"),
    SKIPFLY_BOUNCE = Isaac.GetSoundIdByName("SkipFlyBounce"),

    THAUMATURGE_LAUGH = Isaac.GetSoundIdByName("ThaumLaugh"),
    THAUMATURGE_SHOOT = Isaac.GetSoundIdByName("ThaumShoot"),
    THAUMATURGE_TAUNT = Isaac.GetSoundIdByName("ThaumTaunt"),
    THAUMATURGE_DEATH = Isaac.GetSoundIdByName("ThaumDeath"),

    SPIDERBOI_APPEAR = Isaac.GetSoundIdByName("SBoiAppear"),
    SPIDERBOI_SPIT = Isaac.GetSoundIdByName("SBoiSpit"),
    SPIDERBOI_JUMP = Isaac.GetSoundIdByName("SBoiJump"),

    MABELALERT = Isaac.GetSoundIdByName("MabelAlert"),
    MABELLOOP = Isaac.GetSoundIdByName("MabelLoop"),
    MABELREV = Isaac.GetSoundIdByName("MabelRev"),
    MABELSTOP = Isaac.GetSoundIdByName("MabelStop"),
    MABELVROOM = Isaac.GetSoundIdByName("MabelVroom"),

    PONGPOP = Isaac.GetSoundIdByName("PongPop"),

    PUER_IDLE = Isaac.GetSoundIdByName("PuerIdle"),
    PUER_TELE = Isaac.GetSoundIdByName("PuerTele"),
    PUER_SHOOT = Isaac.GetSoundIdByName("PuerShoot"),

    ARMOR_BLOCK = Isaac.GetSoundIdByName("ArmorBlock"),
    BLOONS_POP = Isaac.GetSoundIdByName("BloonsPop"),

    ANKHA_LOOP = Isaac.GetSoundIdByName("AnkhaLoop"),

    SHOTGUNKING_CARD = Isaac.GetSoundIdByName("ShotgunKingCard"),
    OJ_CARD = Isaac.GetSoundIdByName("OJCard"),
    YUGIOH_CARD = Isaac.GetSoundIdByName("YugiohCard"),
    AMIIBO_CARD = Isaac.GetSoundIdByName("AmiiboCard"),
    VOIDRAIN_CARD = Isaac.GetSoundIdByName("VoidRainCard"),

    MAHJONG_ILLEGAL = Isaac.GetSoundIdByName("MahjongIllegal"),
    MAHJONG_MATCH = Isaac.GetSoundIdByName("MahjongMatch"),
    MAHJONG_SELECT = Isaac.GetSoundIdByName("MahjongSelect"),
    MAHJONG_LAYOUT = Isaac.GetSoundIdByName("MahjongLayout"),

    KICKCUBE1 = Isaac.GetSoundIdByName("KickCube1"),
    KICKCUBE2 = Isaac.GetSoundIdByName("KickCube2"),
    KICKCUBE3 = Isaac.GetSoundIdByName("KickCube3"),

    DEMON_CORE_EFFECT = Isaac.GetSoundIdByName("DemonCoreEffect"),

    CHARLES_CUE = Isaac.GetSoundIdByName("CharlesCue"),
    CHARLES_CUE_FUNNY = Isaac.GetSoundIdByName("CharlesCueFunny"),
    TOY_HELICOPTER_ATTACK = Isaac.GetSoundIdByName("ToyHeli"),

    BHF_EXPLODE_PREPARE = Isaac.GetSoundIdByName("BHFExplodePrepare"),
    BHF_EXPLODE = Isaac.GetSoundIdByName("BHFExplode"),
    BHF_RESPAWN = Isaac.GetSoundIdByName("BHFRespawn"),

    FUNNY_PIPE = Isaac.GetSoundIdByName("FunnyPipe"),
    --Rest added :)
}
Enums.Projectiles = {
    HUMBLED_PROJECTILE = Isaac.GetEntityVariantByName("Humbled Projectile")
}

Enums.Items = {

    --Alpha Armor goes here
    ALPHA_ARMOR = Isaac.GetItemIdByName("Alpha Armor"),
    TREEMAN_SYNDROME = Isaac.GetItemIdByName("Treeman Syndrome"),
    PLACEHOLDER_ITEM = Isaac.GetItemIdByName("Item"),
    ROBOBABYZERO = Isaac.GetItemIdByName("Robo-Baby Zero"),
    ONYXMARBLE = Isaac.GetItemIdByName("Onyx Marble"),
    TOY_HELICOPTER = Isaac.GetItemIdByName("Toy Helicopter"),
    ATOMBOMBBABY = Isaac.GetItemIdByName("Atom Bomb Baby"),
    BHF = Isaac.GetItemIdByName("B.H.F."),
    THE_HUNGER = Isaac.GetItemIdByName("The Hunger"),
    FIFTY_SHADES = Isaac.GetItemIdByName("50 Shades Of Grey"),
    FAITHFUL_FLEET = Isaac.GetItemIdByName("Faithful Fleet"),
    GRUB = Isaac.GetItemIdByName("Grub"),
    MUD_PIE = Isaac.GetItemIdByName("Mud Pie"),
    HOUSEPLANT = Isaac.GetItemIdByName("Houseplant"),
    BIB = Isaac.GetItemIdByName("Bib"),
    CHAMPS_MASK = Isaac.GetItemIdByName("Champ's Mask"),
    THE_HUMAN_SOUL = Isaac.GetItemIdByName("The Human Soul"),
    THE_BESTIARY = Isaac.GetItemIdByName("The Bestiary"),
    TECH_NANO = Isaac.GetItemIdByName("Tech Nano"),
    CROWBAR = Isaac.GetItemIdByName("Crowbar"),

    QUICKLOVE = Isaac.GetItemIdByName("Quicklove"),
    STARLIGHT = Isaac.GetItemIdByName("Starlight"),
    LUCKY_FLOWER = Isaac.GetItemIdByName("Lucky Flower"),
    PALE_BOX = Isaac.GetItemIdByName("Pale Box"),

}

Enums.Trinkets = {

    DEMON_CORE = Isaac.GetTrinketIdByName("Demon Core"),
    A_SINGLE_RAISIN = Isaac.GetTrinketIdByName("A Single Raisin"),
    PLACEHOLDER_TRINKET = Isaac.GetTrinketIdByName("Trinket"),
    CANKER_SORE = Isaac.GetTrinketIdByName("Canker Sore"),
    CRYPTIC_PENNY = Isaac.GetTrinketIdByName("Cryptic Penny"),
    --BOOTLEG_CARTRIDGE = Isaac.GetItemIdByName("Bootleg Cartridge")

}

Enums.Pickups = {

    KICKCUBE = {
        TYPE = Isaac.GetEntityTypeByName("Kick Cube"),
        VARIANT = Isaac.GetEntityVariantByName("Kick Cube"),
        SUBTYPE = 30
    },
    JUMPCRYSTAL = {
        TYPE = Isaac.GetEntityTypeByName("Jump Crystal"),
        VARIANT = Isaac.GetEntityVariantByName("Jump Crystal"),
    },
    ENEMY_CORPSE_SMALL = {
        TYPE = Isaac.GetEntityTypeByName("Enemy Corpse (Small)"),
        VARIANT = Isaac.GetEntityVariantByName("Enemy Corpse (Small)"),
        SUBTYPE = 0
    },
    ENEMY_CORPSE_MEDIUM = {
        TYPE = Isaac.GetEntityTypeByName("Enemy Corpse (Medium)"),
        VARIANT = Isaac.GetEntityVariantByName("Enemy Corpse (Medium)"),
        SUBTYPE = 1
    },
    ENEMY_CORPSE_LARGE = {
        TYPE = Isaac.GetEntityTypeByName("Enemy Corpse (Large)"),
        VARIANT = Isaac.GetEntityVariantByName("Enemy Corpse (Large)"),
        SUBTYPE = 2
    },
    SHITCOIN = {
        TYPE = Isaac.GetEntityTypeByName("Shitcoin"),
        VARIANT = Isaac.GetEntityVariantByName("Shitcoin"),
        SUBTYPE = 80
    },
    GIGA_PENNY = {
        TYPE = Isaac.GetEntityTypeByName("Giga Penny"),
        VARIANT = Isaac.GetEntityVariantByName("Giga Penny"),
        SUBTYPE = 81
    },
    GIGA_KEY = {
        TYPE = Isaac.GetEntityTypeByName("Giga Key"),
        VARIANT = Isaac.GetEntityVariantByName("Giga Key"),
        SUBTYPE = 80
    },
    KP_SMALL = {
        TYPE = Isaac.GetEntityTypeByName("Knowledge Point (small)"),
        VARIANT = Isaac.GetEntityVariantByName("Knowledge Point (small)"),
        SUBTYPE = 31
    },
    KP_LARGE = {
        TYPE = Isaac.GetEntityTypeByName("Knowledge Point (large)"),
        VARIANT = Isaac.GetEntityVariantByName("Knowledge Point (large)"),
        SUBTYPE = 32
    },

}

Enums.Consumables = {

    CARDS = {
        CORNERED_DESPOT = Isaac.GetCardIdByName("Cornered Despot"),
        AUGUST_PRESENCE = Isaac.GetCardIdByName("August Presence"),
        HOMECOMING = Isaac.GetCardIdByName("Homecoming"),
        AMMUNITION_DEPOT = Isaac.GetCardIdByName("Ammunition Depot"),

        OH_MY_FRIEND = Isaac.GetCardIdByName("Oh My Friend"),
        MIMYUUS_HAMMER = Isaac.GetCardIdByName("Mimyuu's Hammer"),
        FLIP_OUT = Isaac.GetCardIdByName("Flip Out"),
        FLAMETHROWER = Isaac.GetCardIdByName("Flamethrower"),

        TIME_WIZARD = Isaac.GetCardIdByName("Oh My Friend"),
        TOON_WORLD = Isaac.GetCardIdByName("Mimyuu's Hammer"),
        SEAL_OF_ORICHALCOS = Isaac.GetCardIdByName("Seal of Orichalcos"),
        POLYMERIZATION = Isaac.GetCardIdByName("Polymerization"),

        ANKHA = Isaac.GetCardIdByName("Ankha"),
        COCO = Isaac.GetCardIdByName("Coco"),
        RAYMOND = Isaac.GetCardIdByName("Raymond"),
        STITCHES = Isaac.GetCardIdByName("Stitches"),

        QUICKLOVE = Isaac.GetCardIdByName("Quicklove"),
        STARLIGHT = Isaac.GetCardIdByName("Starlight"),
        LUCKY_FLOWER = Isaac.GetCardIdByName("Lucky Flower"),
        PALE_BOX = Isaac.GetCardIdByName("Pale Box"),

        ZAP = Isaac.GetCardIdByName("Zap"),
        BLADE_DANCE = Isaac.GetCardIdByName("Blade Dance"),

        MISPRINTED_JUSTICE = Isaac.GetCardIdByName("Misprinted Justice"),
        BANK_ERROR_IN_YOUR_FAVOR = Isaac.GetCardIdByName("Bank Error In Your Favor"),
        --REVERSED_BANK_ERROR = Isaac.GetCardIdByName("Floating Point Error In Your Favor"),
    },

    OBJECTS = {
        WHITE_DRAGON = Isaac.GetCardIdByName("White Dragon"),
        RED_DRAGON = Isaac.GetCardIdByName("Red Dragon"),
        GREEN_DRAGON = Isaac.GetCardIdByName("Green Dragon"),

        ONE_DOT = Isaac.GetCardIdByName("1 Dot"),
        ONE_BAM = Isaac.GetCardIdByName("1 Bam"),
        ONE_CRAK = Isaac.GetCardIdByName("1 Crak"),

        NINE_DOT = Isaac.GetCardIdByName("9 Dot"),
        NINE_BAM = Isaac.GetCardIdByName("9 Bam"),
        NINE_CRAK = Isaac.GetCardIdByName("9 Crak"),
    },

}


BotB.Enums = Enums


--Oh boy here we go
-- BESTIARY MONSTER CONVERSION LIST

Enums.BestiaryBlacklist = {
    --Loafer, Bowler Ball --> Bowler
	{
		Type = 180,
		Variant = 760,
		SubType = 1,
        CanConvert = true,
		ToType = 180,
		ToVariant = 760,
		ToSubType = 0
	},
	{
		Type = 180,
		Variant = 760,
		SubType = 2,
        CanConvert = true,
		ToType = 180,
		ToVariant = 760,
		ToSubType = 0
	},
    --Potluck, Poobottle --> Level 2 Fly
    {
		Type = 450,
		Variant = 60,
		SubType = 0,
        CanConvert = true,
		ToType = 214,
		ToVariant = 0,
		ToSubType = 0
	},
	{
		Type = 160,
		Variant = 560,
		SubType = 0,
        CanConvert = true,
		ToType = 214,
		ToVariant = 0,
		ToSubType = 0
	},
}