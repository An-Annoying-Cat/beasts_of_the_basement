local Enums = {}
    
Enums.Entities = {

    --GAPERS

    --Gaper Variants
    ACME = {
        Type = Isaac.GetEntityTypeByName("Acme"),
        Variant = Isaac.GetEntityVariantByName("Acme"),
    },

    --Hive Variants
    SLEAZEBAG = {
        Type = Isaac.GetEntityTypeByName("Sleazebag"),
        Variant = Isaac.GetEntityVariantByName("Sleazebag"),
    },

    --Keeper Variants
    DESIRER = {
        Type = Isaac.GetEntityTypeByName("Desirer"),
        Variant = Isaac.GetEntityVariantByName("Desirer"),
    },
    SEDUCER = {
        Type = Isaac.GetEntityTypeByName("Seducer"),
        Variant = Isaac.GetEntityVariantByName("Seducer"),
    },

    --INSECTS

    --Swarm Spider Variants
    HUMBLED = {
        Type = Isaac.GetEntityTypeByName("Humbled"),
        Variant = Isaac.GetEntityVariantByName("Humbled"),
    },

    --Skuzz Variants
    SKUZZ = {
        Type = Isaac.GetEntityTypeByName("Skuzz"),
        Variant = Isaac.GetEntityVariantByName("Skuzz"),
    },
    SKOOTER = {
        Type = Isaac.GetEntityTypeByName("Skooter"),
        Variant = Isaac.GetEntityVariantByName("Skooter"),
        Subtype = 10
    },
    SUPER_SKOOTER = {
        Type = Isaac.GetEntityTypeByName("Super Skooter"),
        Variant = Isaac.GetEntityVariantByName("Super Skooter"),
        Subtype = 11
    },

    --ANIMATES

    --Ministro Variants
    CULO = {
        Type = Isaac.GetEntityTypeByName("Culo"),
        Variant = Isaac.GetEntityVariantByName("Culo")
    },

    --Dip Variants
    PING = {
        Type = Isaac.GetEntityTypeByName("Ping"),
        Variant = Isaac.GetEntityVariantByName("Ping")
    },


    --Effects
    ACMES_ANVIL = {
        Type = Isaac.GetEntityTypeByName("Acme's Anvil"),
        Variant = Isaac.GetEntityVariantByName("Acme's Anvil")
    }
}

Enums.Projectiles = {
    HUMBLED_PROJECTILE = Isaac.GetEntityVariantByName("Humbled Projectile")
}


BotB.Enums = Enums