local Enums = {}
    
Enums.Entities = {

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
    DESIRER_ATTACK = Isaac.GetSoundIdByName("DesirerAttack")
    --add the rest of them
}

Enums.Projectiles = {
    HUMBLED_PROJECTILE = Isaac.GetEntityVariantByName("Humbled Projectile")
}
--[[
Enums.Items = {

    --Alpha Armor goes here

}
--]]
Enums.Consumables = {

    CARDS = {
        CORNERED_DESPOT = Isaac.GetCardIDByName("Cornered Despot"),
        AUGUST_PRESENCE = Isaac.GetCardIDByName("August Presence"),
        HOMECOMING = Isaac.GetCardIDByName("Homecoming"),
        AMMUNITION_DEPOT = Isaac.GetCardIDByName("Ammunition Depot"),

        OH_MY_FRIEND = Isaac.GetCardIDByName("Oh My Friend"),
        MIMYUUS_HAMMER = Isaac.GetCardIDByName("Mimyuu's Hammer"),
        FLIP_OUT = Isaac.GetCardIDByName("Flip Out"),
        FLAMETHROWER = Isaac.GetCardIDByName("Flamethrower"),

        TIME_WIZARD = Isaac.GetCardIDByName("Oh My Friend"),
        TOON_WORLD = Isaac.GetCardIDByName("Mimyuu's Hammer"),
        SEAL_OF_ORICHALCOS = Isaac.GetCardIDByName("Seal of Orichalcos"),
        POLYMERIZATION = Isaac.GetCardIDByName("Polymerization"),

        ANKHA = Isaac.GetCardIDByName("Ankha"),
        COCO = Isaac.GetCardIDByName("Coco"),
        RAYMOND = Isaac.GetCardIDByName("Raymond"),
        STITCHES = Isaac.GetCardIDByName("Stitches"),

        QUICKLOVE = Isaac.GetCardIDByName("Quicklove"),
        STARLIGHT = Isaac.GetCardIDByName("Starlight"),
        LUCKY_FLOWER = Isaac.GetCardIDByName("Lucky Flower"),
        PALE_BOX = Isaac.GetCardIDByName("Pale Box"),

        ZAP = Isaac.GetCardIDByName("Zap"),
        BLADE_DANCE = Isaac.GetCardIDByName("Blade Dance"),

        MISPRINTED_JUSTICE = Isaac.GetCardIDByName("Misprinted Justice"),
        BANK_ERROR_IN_YOUR_FAVOR = Isaac.GetCardIDByName("Bank Error In Your Favor"),
        --REVERSED_BANK_ERROR = Isaac.GetCardIDByName("Floating Point Error In Your Favor")


        FILLER_TILE = Isaac.GetCardIDByName("filler tile"),
    },

    OBJECTS = {
        MAHJONG = {
            WHITE_DRAGON = Isaac.GetCardIDByName("White Dragon"),
            RED_DRAGON = Isaac.GetCardIDByName("Red Dragon"),
            GREEN_DRAGON = Isaac.GetCardIDByName("Green Dragon"),

            ONE_DOT = Isaac.GetCardIDByName("1 Dot"),
            ONE_BAM = Isaac.GetCardIDByName("1 Bam"),
            ONE_CRAK = Isaac.GetCardIDByName("1 Crak"),

            NINE_DOT = Isaac.GetCardIDByName("9 Dot"),
            NINE_BAM = Isaac.GetCardIDByName("9 Bam"),
            NINE_CRAK = Isaac.GetCardIDByName("9 Crak"),
        },
        
    }
    

}


BotB.Enums = Enums