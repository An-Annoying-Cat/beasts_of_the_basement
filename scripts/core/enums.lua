local Enums = {}
    
Enums.Entities = {

    --Not really a variant of anything in particular, using a shopkeeper as a test at this point
    DRIFTER = {
        TYPE = Isaac.GetEntityTypeByName("Drifter"),
        VARIANT = Isaac.GetEntityVariantByName("Drifter"),
    },

    --GAPERS

    --Gaper Variants
    ACME = {
        TYPE = Isaac.GetEntityTypeByName("Acme"),
        VARIANT = Isaac.GetEntityVariantByName("Acme"),
    },

    --Hive Variants
    SLEAZEBAG = {
        TYPE = Isaac.GetEntityTypeByName("Sleazebag"),
        VARIANT = Isaac.GetEntityVariantByName("Sleazebag"),
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

    --INSECTS

    --Swarm Spider Variants
    HUMBLED = {
        TYPE = Isaac.GetEntityTypeByName("Humbled"),
        VARIANT = Isaac.GetEntityVariantByName("Humbled"),
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

    --Host Variants
    TIPPYTAP = {
        TYPE = Isaac.GetEntityTypeByName("Tippytap"),
        VARIANT = Isaac.GetEntityVariantByName("Tippytap")
    },
    CROAST = {
        TYPE = Isaac.GetEntityTypeByName("Croast"),
        VARIANT = Isaac.GetEntityVariantByName("Croast")
    },


    --Effects
    ACMES_ANVIL = {
        TYPE = Isaac.GetEntityTypeByName("Acme's Anvil"),
        VARIANT = Isaac.GetEntityVariantByName("Acme's Anvil")
    },

    WARNING_TARGET = {
        TYPE = Isaac.GetEntityTypeByName("Warning Target"),
        VARIANT = Isaac.GetEntityVariantByName("Warning Target")
    }
}

Enums.SFX = {
    DESIRER_ATTACK = Isaac.GetSoundIdByName("DesirerAttack"),
    ACME_DEATH = Isaac.GetSoundIdByName("AcmeDeath"),
    SEDUCER_ATTACK = Isaac.GetSoundIdByName("SeducerAttack"),
    WHEEZE = Isaac.GetSoundIdByName("Wheeze"),
    CARTOON_RICOCHET = Isaac.GetSoundIdByName("CartoonRicochet"),
    TIPPYTAPLOOP = Isaac.GetSoundIdByName("TippyTapLoop"),
    TIPPYTAPSTEP = Isaac.GetSoundIdByName("TippyTapStep"),

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

    DEMON_CORE_EFFECT = Isaac.GetSoundIdByName("DemonCoreEffect")
    --Rest added :)
}
Enums.Projectiles = {
    HUMBLED_PROJECTILE = Isaac.GetEntityVariantByName("Humbled Projectile")
}

Enums.Items = {

    --Alpha Armor goes here
    ALPHA_ARMOR = Isaac.GetItemIdByName("Alpha Armor"),
    TREEMAN_SYNDROME = Isaac.GetItemIdByName("Treeman Syndrome")

}

Enums.Trinkets = {

    --Alpha Armor goes here
    DEMON_CORE = Isaac.GetTrinketIdByName("Demon Core"),
    --CANKER_SORE = Isaac.GetItemIdByName("Canker Sore"),
    --BOOTLEG_CARTRIDGE = Isaac.GetItemIdByName("Bootleg Cartridge")

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

        
        FILLER_TILE = Isaac.GetCardIdByName("filler tile"),
    },

    OBJECTS = {
        MAHJONG = {
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
    },

}


BotB.Enums = Enums