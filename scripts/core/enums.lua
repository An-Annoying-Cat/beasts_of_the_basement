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
        TYPE = Isaac.GetEntityTypeByName("Starver"),
        VARIANT = Isaac.GetEntityVariantByName("Starver"),
    },
    SEDUCER = {
        TYPE = Isaac.GetEntityTypeByName("Fester"),
        VARIANT = Isaac.GetEntityVariantByName("Fester"),
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
        TYPE = Isaac.GetEntityTypeByName("Snack"),
        VARIANT = Isaac.GetEntityVariantByName("Snack"),
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
    TROJAN = {
        TYPE = Isaac.GetEntityTypeByName("Trojan"),
        VARIANT = Isaac.GetEntityVariantByName("Trojan")
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
    PARANOIAC = {
        TYPE = Isaac.GetEntityTypeByName("Paranoiac"),
        VARIANT = Isaac.GetEntityVariantByName("Paranoiac"),
    },
    SLIGHT = {
        TYPE = Isaac.GetEntityTypeByName("Slight"),
        VARIANT = Isaac.GetEntityVariantByName("Slight"),
    },
    CURSED_HORF = {
        TYPE = Isaac.GetEntityTypeByName("Cursed Horf"),
        VARIANT = Isaac.GetEntityVariantByName("Cursed Horf"),
    },
    CURSED_MULLIGAN = {
        TYPE = Isaac.GetEntityTypeByName("Cursed Mulligan"),
        VARIANT = Isaac.GetEntityVariantByName("Cursed Mulligan"),
    },
    CURSED_MULLIBOOM = {
        TYPE = Isaac.GetEntityTypeByName("Cursed Mulliboom"),
        VARIANT = Isaac.GetEntityVariantByName("Cursed Mulliboom"),
    },
    CURSED_POOTER = {
        TYPE = Isaac.GetEntityTypeByName("Cursed Pooter"),
        VARIANT = Isaac.GetEntityVariantByName("Cursed Pooter"),
    },
    BABBY_REAL = {
        TYPE = Isaac.GetEntityTypeByName("Babby (Real)"),
        VARIANT = Isaac.GetEntityVariantByName("Babby (Real)"),
    },
    BABBY_FAKE = {
        TYPE = Isaac.GetEntityTypeByName("Babby (Fake)"),
        VARIANT = Isaac.GetEntityVariantByName("Babby (Fake)"),
    },
    PURSUER = {
        TYPE = Isaac.GetEntityTypeByName("Pursuer"),
        VARIANT = Isaac.GetEntityVariantByName("Pursuer"),
    },
    GEO_HORF = {
        TYPE = Isaac.GetEntityTypeByName("Geo Horf"),
        VARIANT = Isaac.GetEntityVariantByName("Geo Horf"),
    },
    GEO_FATTY = {
        TYPE = Isaac.GetEntityTypeByName("Geo Fatty"),
        VARIANT = Isaac.GetEntityVariantByName("Geo Fatty"),
    },
    DOUBLE_CHERRY = {
        TYPE = Isaac.GetEntityTypeByName("Double Cherry"),
        VARIANT = Isaac.GetEntityVariantByName("Double Cherry"),
    },
    DESPAIR = {
        TYPE = Isaac.GetEntityTypeByName("Despair"),
        VARIANT = Isaac.GetEntityVariantByName("Despair"),
    },
    DESPAIR_HORSE = {
        TYPE = Isaac.GetEntityTypeByName("Despair Horse"),
        VARIANT = Isaac.GetEntityVariantByName("Despair Horse"),
    },



    CROCKPOT_NEW = {
        TYPE = Isaac.GetEntityTypeByName("Crockpot (New)"),
        VARIANT = Isaac.GetEntityVariantByName("Crockpot (New)"),
    },
    
    OOZER = {
        TYPE = Isaac.GetEntityTypeByName("Oozer"),
        VARIANT = Isaac.GetEntityVariantByName("Oozer"),
    },

    HIGH_CLOTTY = {
        TYPE = Isaac.GetEntityTypeByName("High Clotty"),
        VARIANT = Isaac.GetEntityVariantByName("High Clotty"),
    },

    ANT = {
        TYPE = Isaac.GetEntityTypeByName("Ant"),
        VARIANT = Isaac.GetEntityVariantByName("Ant"),
    },

    BULLET_ANT = {
        TYPE = Isaac.GetEntityTypeByName("Bullet Ant"),
        VARIANT = Isaac.GetEntityVariantByName("Bullet Ant"),
    },

    SUPER_BULLET_ANT = {
        TYPE = Isaac.GetEntityTypeByName("Super Bullet Ant"),
        VARIANT = Isaac.GetEntityVariantByName("Super Bullet Ant"),
    },

    STUNKY = {
        TYPE = Isaac.GetEntityTypeByName("Stunky"),
        VARIANT = Isaac.GetEntityVariantByName("Stunky"),
    },

    ATTACK_ANT_ENEMY = {
        TYPE = Isaac.GetEntityTypeByName("Attack Ant (Enemy)"),
        VARIANT = Isaac.GetEntityVariantByName("Attack Ant (Enemy)"),
    },

    CLAY_SOLDIER = {
        TYPE = Isaac.GetEntityTypeByName("Clay Soldier"),
        VARIANT = Isaac.GetEntityVariantByName("Clay Soldier"),
    },

    DOORTRAP_EYE = {
        TYPE = Isaac.GetEntityTypeByName("Doortrap (Eye)"),
        VARIANT = Isaac.GetEntityVariantByName("Doortrap (Eye)"),
    },
    DOORTRAP_MOUTH = {
        TYPE = Isaac.GetEntityTypeByName("Doortrap (Mouth)"),
        VARIANT = Isaac.GetEntityVariantByName("Doortrap (Mouth)"),
    },
    DOORTRAP_BUTT = {
        TYPE = Isaac.GetEntityTypeByName("Doortrap (Butt)"),
        VARIANT = Isaac.GetEntityVariantByName("Doortrap (Butt)"),
    },
    DOORTRAP_HIVE = {
        TYPE = Isaac.GetEntityTypeByName("Doortrap (Hive)"),
        VARIANT = Isaac.GetEntityVariantByName("Doortrap (Hive)"),
    },
    DOORTRAP_CUBE = {
        TYPE = Isaac.GetEntityTypeByName("Doortrap (Cube)"),
        VARIANT = Isaac.GetEntityVariantByName("Doortrap (Cube)"),
    },

    SOPRANO = {
        TYPE = Isaac.GetEntityTypeByName("Soprano"),
        VARIANT = Isaac.GetEntityVariantByName("Soprano"),
    },
    ALTO = {
        TYPE = Isaac.GetEntityTypeByName("Alto"),
        VARIANT = Isaac.GetEntityVariantByName("Alto"),
    },
    TENOR = {
        TYPE = Isaac.GetEntityTypeByName("Tenor"),
        VARIANT = Isaac.GetEntityVariantByName("Tenor"),
    },

    GENERIC_NPC = {
        TYPE = Isaac.GetEntityTypeByName("Generic NPC"),
        VARIANT = Isaac.GetEntityVariantByName("Generic NPC"),
    },

    BILLY = {
        TYPE = Isaac.GetEntityTypeByName("I.L.L."),
        VARIANT = Isaac.GetEntityVariantByName("I.L.L."),
    },

    BILLY_CORD_DUMMY = {
        TYPE = Isaac.GetEntityTypeByName("I.L.L. Cord Dummy"),
        VARIANT = Isaac.GetEntityVariantByName("I.L.L. Cord Dummy"),
    },

    TRIACHNOID = {
        TYPE = Isaac.GetEntityTypeByName("Triachnoid"),
        VARIANT = Isaac.GetEntityVariantByName("Triachnoid"),
    },

    TRIACHNOID_CORD_DUMMY = {
        TYPE = Isaac.GetEntityTypeByName("Triachnoid Cord Dummy"),
        VARIANT = Isaac.GetEntityVariantByName("Triachnoid Cord Dummy"),
    },

    TRIACHNOID_LEG_CORD_DUMMY = {
        TYPE = Isaac.GetEntityTypeByName("Triachnoid Leg Cord Dummy"),
        VARIANT = Isaac.GetEntityVariantByName("Triachnoid Leg Cord Dummy"),
    },

    PRICKHEAD = {
        TYPE = Isaac.GetEntityTypeByName("Prickhead"),
        VARIANT = Isaac.GetEntityVariantByName("Prickhead"),
    },

    HALFTOP = {
        TYPE = Isaac.GetEntityTypeByName("Halftop"),
        VARIANT = Isaac.GetEntityVariantByName("Halftop"),
    },

    PUCK = {
        TYPE = Isaac.GetEntityTypeByName("Puck"),
        VARIANT = Isaac.GetEntityVariantByName("Puck"),
    },

    HOLY_DIP = {
        TYPE = Isaac.GetEntityTypeByName("Holy Dip"),
        VARIANT = Isaac.GetEntityVariantByName("Holy Dip"),
    },

    HOLY_SQUIRT = {
        TYPE = Isaac.GetEntityTypeByName("Holy Squirt"),
        VARIANT = Isaac.GetEntityVariantByName("Holy Squirt"),
    },

    POPE = {
        TYPE = Isaac.GetEntityTypeByName("Pope"),
        VARIANT = Isaac.GetEntityVariantByName("Pope"),
    },

    MACK = {
        TYPE = Isaac.GetEntityTypeByName("Mack"),
        VARIANT = Isaac.GetEntityVariantByName("Mack"),
    },

    SEGMENTED_ENEMY_TEST = {
        TYPE = Isaac.GetEntityTypeByName("Segmented Enemy Test"),
        VARIANT = Isaac.GetEntityVariantByName("Segmented Enemy Test"),
    },

    SEGMENTED_ENEMY_TEST_BODY = {
        TYPE = Isaac.GetEntityTypeByName("Segmented Enemy Test Body"),
        VARIANT = Isaac.GetEntityVariantByName("Segmented Enemy Test Body"),
    },

    SEGMENTED_ENEMY_TEST_TAIL = {
        TYPE = Isaac.GetEntityTypeByName("Segmented Enemy Test Tail"),
        VARIANT = Isaac.GetEntityVariantByName("Segmented Enemy Test Tail"),
    },

    SOMEBODY = {
        TYPE = Isaac.GetEntityTypeByName("Somebody"),
        VARIANT = Isaac.GetEntityVariantByName("Somebody"),
    },

    SPEECH_BUBBLE = {
        TYPE = Isaac.GetEntityTypeByName("Speech Bubble"),
        VARIANT = Isaac.GetEntityVariantByName("Speech Bubble"),
    },

    HUSHED_GRIMACE = {
        TYPE = Isaac.GetEntityTypeByName("Hushed Grimace"),
        VARIANT = Isaac.GetEntityVariantByName("Hushed Grimace"),
    },

    MOLDY_HORF = {
        TYPE = Isaac.GetEntityTypeByName("Moldy Horf"),
        VARIANT = Isaac.GetEntityVariantByName("Moldy Horf"),
    },

    SLEAZEBAG_REAL = {
        TYPE = Isaac.GetEntityTypeByName("Sleazebag (Real)"),
        VARIANT = Isaac.GetEntityVariantByName("Sleazebag (Real)"),
    },

    KAUFMANN = {
        TYPE = Isaac.GetEntityTypeByName("Kaufmann"),
        VARIANT = Isaac.GetEntityVariantByName("Kaufmann"),
    },

    PEEKABOX = {
        TYPE = Isaac.GetEntityTypeByName("Peekabox"),
        VARIANT = Isaac.GetEntityVariantByName("Peekabox"),
    },

    QUEENIE = {
        TYPE = Isaac.GetEntityTypeByName("Queenie"),
        VARIANT = Isaac.GetEntityVariantByName("Queenie"),
    },

    GLOOM_FLY = {
        TYPE = Isaac.GetEntityTypeByName("Gloom Fly"),
        VARIANT = Isaac.GetEntityVariantByName("Gloom Fly"),
    },

    GLOOM_FLY_TRAIL = {
        TYPE = Isaac.GetEntityTypeByName("Gloom Fly Trail"),
        VARIANT = Isaac.GetEntityVariantByName("Gloom Fly Trail"),
    },

    TELEPATH = {
        TYPE = Isaac.GetEntityTypeByName("Telepath"),
        VARIANT = Isaac.GetEntityVariantByName("Telepath"),
    },

    VANTAGE = {
        TYPE = Isaac.GetEntityTypeByName("Vantage"),
        VARIANT = Isaac.GetEntityVariantByName("Vantage"),
    },

    NYCTO = {
        TYPE = Isaac.GetEntityTypeByName("Nycto"),
        VARIANT = Isaac.GetEntityVariantByName("Nycto"),
    },

    HELIO = {
        TYPE = Isaac.GetEntityTypeByName("Helio"),
        VARIANT = Isaac.GetEntityVariantByName("Helio"),
    },

    LARS = {
        TYPE = Isaac.GetEntityTypeByName("Lars"),
        VARIANT = Isaac.GetEntityVariantByName("Lars"),
    },

    LARS_BODY = {
        TYPE = Isaac.GetEntityTypeByName("Lars Body"),
        VARIANT = Isaac.GetEntityVariantByName("Lars Body"),
    },

    LARS_TAIL = {
        TYPE = Isaac.GetEntityTypeByName("Lars Tail"),
        VARIANT = Isaac.GetEntityVariantByName("Lars Tail"),
    },

    JEM = {
        TYPE = Isaac.GetEntityTypeByName("Jem"),
        VARIANT = Isaac.GetEntityVariantByName("Jem"),
    },

    MINI = {
        TYPE = Isaac.GetEntityTypeByName("Mini"),
        VARIANT = Isaac.GetEntityVariantByName("Mini"),
    },

    MR_MUCUS = {
        TYPE = Isaac.GetEntityTypeByName("Mr. Mucus"),
        VARIANT = Isaac.GetEntityVariantByName("Mr. Mucus"),
    },

    FLEMMER = {
        TYPE = Isaac.GetEntityTypeByName("Flemmer"),
        VARIANT = Isaac.GetEntityVariantByName("Flemmer"),
    },

    CATARRH = {
        TYPE = Isaac.GetEntityTypeByName("Catarrh"),
        VARIANT = Isaac.GetEntityVariantByName("Catarrh"),
    },

    SINUSTRO = {
        TYPE = Isaac.GetEntityTypeByName("Sinustro"),
        VARIANT = Isaac.GetEntityVariantByName("Sinustro"),
    },

    GULLET = {
        TYPE = Isaac.GetEntityTypeByName("Gullet"),
        VARIANT = Isaac.GetEntityVariantByName("Gullet"),
    },

    MR_GULLET = {
        TYPE = Isaac.GetEntityTypeByName("Mr. Gullet"),
        VARIANT = Isaac.GetEntityVariantByName("Mr. Gullet"),
    },

    FAT_GUSHER = {
        TYPE = Isaac.GetEntityTypeByName("Fat Gusher"),
        VARIANT = Isaac.GetEntityVariantByName("Fat Gusher"),
    },

    PEECLOPIA = {
        TYPE = Isaac.GetEntityTypeByName("Peeclopia"),
        VARIANT = Isaac.GetEntityVariantByName("Peeclopia"),
    },

    CYAN_MOTER = {
        TYPE = Isaac.GetEntityTypeByName("Cyan Moter"),
        VARIANT = Isaac.GetEntityVariantByName("Cyan Moter"),
    },

    SPINNY_BOI_TEST = {
        TYPE = Isaac.GetEntityTypeByName("Spinny Boi Test"),
        VARIANT = Isaac.GetEntityVariantByName("Spinny Boi Test"),
    },

    SPINNY_BOI_CHILD_TEST = {
        TYPE = Isaac.GetEntityTypeByName("Spinny Boi Child Test"),
        VARIANT = Isaac.GetEntityVariantByName("Spinny Boi Child Test"),
    },

    CONQUEROR = {
        TYPE = Isaac.GetEntityTypeByName("Conqueror"),
        VARIANT = Isaac.GetEntityVariantByName("Conqueror"),
    },

    WARRIOR = {
        TYPE = Isaac.GetEntityTypeByName("Warrior"),
        VARIANT = Isaac.GetEntityVariantByName("Warrior"),
    },

    BLIGHTON = {
        TYPE = Isaac.GetEntityTypeByName("Blighton"),
        VARIANT = Isaac.GetEntityVariantByName("Blighton"),
    },

    OVIE = {
        TYPE = Isaac.GetEntityTypeByName("Ovie"),
        VARIANT = Isaac.GetEntityVariantByName("Ovie"),
    },

    ROSTELLUM = {
        TYPE = Isaac.GetEntityTypeByName("Rostellum"),
        VARIANT = Isaac.GetEntityVariantByName("Rostellum"),
    },

    ROSTELLUM_HEAD = {
        TYPE = Isaac.GetEntityTypeByName("Rostellum Head"),
        VARIANT = Isaac.GetEntityVariantByName("Rostellum Head"),
        SUBTYPE = 20,
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
    BESTIARY_TARGETED_ICON = {
        TYPE = Isaac.GetEntityTypeByName("Bestiary Targeted Icon"),
        VARIANT = Isaac.GetEntityVariantByName("Bestiary Targeted Icon")
    },
    RADIATION_CIRCLE = {
        TYPE = Isaac.GetEntityTypeByName("Radiation Circle"),
        VARIANT = Isaac.GetEntityVariantByName("Radiation Circle")
    },
    RADIATION_CIRCLE_TEMPORARY = {
        TYPE = Isaac.GetEntityTypeByName("Radiation Circle (Temporary)"),
        VARIANT = Isaac.GetEntityVariantByName("Radiation Circle (Temporary)")
    },
    BOTB_STATUS_EFFECT = {
        TYPE = Isaac.GetEntityTypeByName("BotB Status Effect"),
        VARIANT = Isaac.GetEntityVariantByName("BotB Status Effect")
    },
    TRIACHNOID_LEG = {
        TYPE = Isaac.GetEntityTypeByName("Triachnoid Leg"),
        VARIANT = Isaac.GetEntityVariantByName("Triachnoid Leg")
    },
    COIN_OF_JUDGEMENT = {
        TYPE = Isaac.GetEntityTypeByName("Coin Of Judgement"),
        VARIANT = Isaac.GetEntityVariantByName("Coin Of Judgement")
    },
    CURSE_OF_JUSTICE_EFFECT = {
        TYPE = Isaac.GetEntityTypeByName("Curse of Justice Effect"),
        VARIANT = Isaac.GetEntityVariantByName("Curse of Justice Effect")
    },
    JEM_CHAIN = {
        TYPE = Isaac.GetEntityTypeByName("Jem Chain"),
        VARIANT = Isaac.GetEntityVariantByName("Jem Chain")
    },
    ASYLUM_ENEMY_EASTER_EGG = {
        TYPE = Isaac.GetEntityTypeByName("Asylum Enemy Easter Egg"),
        VARIANT = Isaac.GetEntityVariantByName("Asylum Enemy Easter Egg")
    },
    MR_GULLET_CHAIN = {
        TYPE = Isaac.GetEntityTypeByName("Mr. Gullet Chain"),
        VARIANT = Isaac.GetEntityVariantByName("Mr. Gullet Chain")
    },

    PEECLOPIA_CORD_DUMMY = {
        TYPE = Isaac.GetEntityTypeByName("Peeclopia Cord Dummy"),
        VARIANT = Isaac.GetEntityVariantByName("Peeclopia Cord Dummy")
    },

    SPINNY_BOI_INTRO = {
        TYPE = Isaac.GetEntityTypeByName("Spinny Boi Intro"),
        VARIANT = Isaac.GetEntityVariantByName("Spinny Boi Intro")
    },

    

    BOTB_GRID = {
        TYPE = Isaac.GetEntityTypeByName("BotB Grid Spawner"),
        VARIANT = Isaac.GetEntityVariantByName("BotB Grid Spawner")
    },

}

Enums.Props = {
    SLOT_ROOM_PANEL = {
        TYPE = Isaac.GetEntityTypeByName("Slot Room Panel"),
        VARIANT = Isaac.GetEntityVariantByName("Slot Room Panel")
    },
    POPE_SPAWNPOINT = {
        TYPE = Isaac.GetEntityTypeByName("Pope Spawnpoint"),
        VARIANT = Isaac.GetEntityVariantByName("Pope Spawnpoint")
    },
    ON_TOTEM = {
        TYPE = Isaac.GetEntityTypeByName("On Totem"),
        VARIANT = Isaac.GetEntityVariantByName("On Totem")
    },
    OFF_TOTEM = {
        TYPE = Isaac.GetEntityTypeByName("Off Totem"),
        VARIANT = Isaac.GetEntityVariantByName("Off Totem")
    },
    TOTEM_SWITCH = {
        TYPE = Isaac.GetEntityTypeByName("Totem Switch"),
        VARIANT = Isaac.GetEntityVariantByName("Totem Switch")
    },
    TOTEM_LEVER = {
        TYPE = Isaac.GetEntityTypeByName("Totem Lever"),
        VARIANT = Isaac.GetEntityVariantByName("Totem Lever")
    },
    LIGHT_SWITCH = {
        TYPE = Isaac.GetEntityTypeByName("Light Switch"),
        VARIANT = Isaac.GetEntityVariantByName("Light Switch")
    },
    POWER_ON_BUTTON = {
        TYPE = Isaac.GetEntityTypeByName("Power On Button"),
        VARIANT = Isaac.GetEntityVariantByName("Power On Button")
    },
    POWER_OFF_BUTTON = {
        TYPE = Isaac.GetEntityTypeByName("Power Off Button"),
        VARIANT = Isaac.GetEntityVariantByName("Power Off Button")
    },
    ROOM_LIGHT_STATE_TRACKER = {
        TYPE = Isaac.GetEntityTypeByName("Room Light State Tracker"),
        VARIANT = Isaac.GetEntityVariantByName("Room Light State Tracker")
    },
}

Enums.Slots = {
    CHALLENGE_COMPUTER = {
        TYPE = Isaac.GetEntityTypeByName("Challenge Computer"),
        VARIANT = Isaac.GetEntityVariantByName("Challenge Computer")
    },
}

Enums.Grids = {
    RADIOACTIVE_BARREL = 1,
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
    JAIL_KEYGHOST = {
        TYPE = Isaac.GetEntityTypeByName("Jail Keyghost"),
        VARIANT = Isaac.GetEntityVariantByName("Jail Keyghost"),
    },
    LIL_ARI_PLUSH = {
        TYPE = Isaac.GetEntityTypeByName("Lil Ari (Plush)"),
        VARIANT = Isaac.GetEntityVariantByName("Lil Ari (Plush)"),
    },
    AMORPHOUS_GLOBOSA_FAMILIAR = {
        TYPE = Isaac.GetEntityTypeByName("Amorphous Globosa (Familiar)"),
        VARIANT = Isaac.GetEntityVariantByName("Amorphous Globosa (Familiar)"),
    },
    AMORPHOUS_GLOBOSA_MINI = {
        TYPE = Isaac.GetEntityTypeByName("Amorphous Globosa (Mini)"),
        VARIANT = Isaac.GetEntityVariantByName("Amorphous Globosa (Mini)"),
    },
    BUZZ_FLY = {
        TYPE = Isaac.GetEntityTypeByName("Buzz Fly"),
        VARIANT = Isaac.GetEntityVariantByName("Buzz Fly"),
    },
    ATTACK_ANT = {
        TYPE = Isaac.GetEntityTypeByName("Attack Ant"),
        VARIANT = Isaac.GetEntityVariantByName("Attack Ant"),
    },
    CLAY_SOLDIER_TRACKER = {
        TYPE = Isaac.GetEntityTypeByName("Clay Soldier (Tracker)"),
        VARIANT = Isaac.GetEntityVariantByName("Clay Soldier (Tracker)"),
    },
    CLAY_SOLDIER_CHARGEBAR = {
        TYPE = Isaac.GetEntityTypeByName("Clay Soldier (Chargebar)"),
        VARIANT = Isaac.GetEntityVariantByName("Clay Soldier (Chargebar)"),
    },
    IMMORTAL_BABY = {
        TYPE = Isaac.GetEntityTypeByName("Immortal Baby"),
        VARIANT = Isaac.GetEntityVariantByName("Immortal Baby"),
    },
    YEET_A_BABY = {
        TYPE = Isaac.GetEntityTypeByName("Yeet-a-baby"),
        VARIANT = Isaac.GetEntityVariantByName("Yeet-a-baby"),
    },
    TEZEBEL_KNIFE_HOLDER = {
        TYPE = Isaac.GetEntityTypeByName("Tezebel Knife Holder"),
        VARIANT = Isaac.GetEntityVariantByName("Tezebel Knife Holder"),
    },
    BUGGY_BABY = {
        TYPE = Isaac.GetEntityTypeByName("Buggy Baby"),
        VARIANT = Isaac.GetEntityVariantByName("Buggy Baby"),
    },
    THRONE = {
        TYPE = Isaac.GetEntityTypeByName("Throne"),
        VARIANT = Isaac.GetEntityVariantByName("Throne"),
    },
    VOICE_OF_YEN = {
        TYPE = Isaac.GetEntityTypeByName("Voice Of Yen"),
        VARIANT = Isaac.GetEntityVariantByName("Voice Of Yen"),
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

    CRYSTAL_FIRE = Isaac.GetSoundIdByName("CrystalFire"),
    CRYSTAL_FIRE_BIG = Isaac.GetSoundIdByName("CrystalFireBig"),
    CRYSTAL_FIRE_SMALL = Isaac.GetSoundIdByName("CrystalFireSmall"),

    GLITCHY_BOOM = Isaac.GetSoundIdByName("GlitchyBoom"),

    GEIGER_CLICK = Isaac.GetSoundIdByName("GeigerClick"),

    VANTAGE_SCREECH_LOOP = Isaac.GetSoundIdByName("VantageScreechLoop"),

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

    TELEPATH_PING = Isaac.GetSoundIdByName("TelepathPing"),

    SICK_COUGH = Isaac.GetSoundIdByName("SickCough"),

    PEEKABOX_ALERT = Isaac.GetSoundIdByName("PeekABoxAlert"),

    GRENADE_LAUNCHER_POP = Isaac.GetSoundIdByName("GrenadeLauncherPop"),

    QUEENIE_FALL = Isaac.GetSoundIdByName("QueenieFall"),

    QUEENIE_HI = Isaac.GetSoundIdByName("QueenieHi"),
    QUEENIE_GRUNT = Isaac.GetSoundIdByName("QueenieGrunt"),

    GLITCH_NOISE = Isaac.GetSoundIdByName("GlitchNoise"),

    PUER_IDLE = Isaac.GetSoundIdByName("PuerIdle"),
    PUER_TELE = Isaac.GetSoundIdByName("PuerTele"),
    PUER_SHOOT = Isaac.GetSoundIdByName("PuerShoot"),

    SLIGHT_PANIC = Isaac.GetSoundIdByName("SlightPanic"),

    CHOIR_HURT = Isaac.GetSoundIdByName("ChoirHurt"),
    CHOIR_HURT_FUNNY = Isaac.GetSoundIdByName("ChoirHurtFunny"),

    ARMOR_BLOCK = Isaac.GetSoundIdByName("ArmorBlock"),
    BLOONS_POP = Isaac.GetSoundIdByName("BloonsPop"),
    FURSUIT_MEOW = Isaac.GetSoundIdByName("FursuitMeow"),
    DISEASE_PROC = Isaac.GetSoundIdByName("DiseaseProc"),
    DISEASE_STACK = Isaac.GetSoundIdByName("DiseaseStack"),
    DIVINE_PROC = Isaac.GetSoundIdByName("DivineProc"),

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

    ARIRAL_SCREAM = Isaac.GetSoundIdByName("AriralScream"),

    MYPAD_USED = Isaac.GetSoundIdByName("MyPadUsed"),

    FUNNY_PIPE = Isaac.GetSoundIdByName("FunnyPipe"),

    JAIL_KEY_GET = Isaac.GetSoundIdByName("JailKeyGet"),

    PLUS_TEN = Isaac.GetSoundIdByName("PlusTen"),

    COW_MOO = Isaac.GetSoundIdByName("CowMoo"),

    FAH_COIN_FLIP = Isaac.GetSoundIdByName("FAHCoinFlip"),

    FAH_COIN_LAND = Isaac.GetSoundIdByName("FAHCoinLand"),

    CURSE_OF_JUSTICE = Isaac.GetSoundIdByName("CurseOfJustice"),

    ASYLUM_LIGHT_LOOP = Isaac.GetSoundIdByName("AsylumLightLoop"),

    NOELLE_POP = Isaac.GetSoundIdByName("NoellePop"),

    GTFO = Isaac.GetSoundIdByName("GTFO"),

    GTFO_INTRO = Isaac.GetSoundIdByName("GTFO_INTRO"),
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
    THE_DSM = Isaac.GetItemIdByName("The DSM"),
    SPOILED_MILK = Isaac.GetItemIdByName("Spoiled Milk"),
    LIQUID_LATEX = Isaac.GetItemIdByName("Liquid Latex"),
    WIGGLY_BOY = Isaac.GetItemIdByName("Wiggly Boy"),
    LUCKY_LIGHTER = Isaac.GetItemIdByName("Lucky Lighter"),
    ENLIGHTENMENT = Isaac.GetItemIdByName("Enlightenment"),
    ODD_MUSHROOM_ROUND = Isaac.GetItemIdByName("Odd Mushroom (Round)"),

    HEALTHY_SNACK = Isaac.GetItemIdByName("Healthy Snack"),
    TRIGGER_BUTTON = Isaac.GetItemIdByName("Trigger Button"),

    EMETER_COLLECTIBLE = Isaac.GetItemIdByName("E-Meter"),
    EMETER_IN = Isaac.GetItemIdByName("E-Meter (In)"),
    EMETER_OUT = Isaac.GetItemIdByName("E-Meter (Out)"),

    FUCK_THAT_NOISE = Isaac.GetItemIdByName("Fuck That Noise"),
    DECK_OF_TOO_MANY_THINGS = Isaac.GetItemIdByName("Deck Of Too Many Things"),

    DUSTY_D6 = Isaac.GetItemIdByName("Dusty D6"),
    DUSTY_D4 = Isaac.GetItemIdByName("Skew D4"),
    DUSTY_D100 = Isaac.GetItemIdByName("Dusty D Infinity"),
    D11 = Isaac.GetItemIdByName("D11"),

    BLOOD_MERIDIAN = Isaac.GetItemIdByName("Blood Meridian"),
    HOUSE_OF_LEAVES = Isaac.GetItemIdByName("House Of Leaves"),
    BLOOD_MERIDIAN_DUMMY = Isaac.GetItemIdByName("Blood Meridian Dummy"),

    LIL_ARI = Isaac.GetItemIdByName("Lil Ari"),

    QUICKLOVE = Isaac.GetItemIdByName("Quicklove"),
    STARLIGHT = Isaac.GetItemIdByName("Starlight"),
    LUCKY_FLOWER = Isaac.GetItemIdByName("Lucky Flower"),
    PALE_BOX = Isaac.GetItemIdByName("Pale Box"),

    JAIL_KEYGHOST = Isaac.GetItemIdByName("Jail Keyghost"),
    
    --x10 shitposts
    TEN_SOULS = Isaac.GetItemIdByName("Haah!"),
    TEN_TRINKETS = Isaac.GetItemIdByName("Fwoop!"),
    TEN_ITEMS = Isaac.GetItemIdByName("Ahhh..."),
    TEN_WISPS = Isaac.GetItemIdByName("Fwoosh!"),
    TEN_CARDS = Isaac.GetItemIdByName("Ksshk!"),
    TEN_PILLS = Isaac.GetItemIdByName("Gulp!"),
    TEN_CLOTS = Isaac.GetItemIdByName("Shlop!"),
    TEN_FLIES = Isaac.GetItemIdByName("Buzz Buzz!"),
    TEN_SPIDERS = Isaac.GetItemIdByName("Skitter Skitter!"),
    TEN_SKUZZES = Isaac.GetItemIdByName("Boing Boing!"),
    TEN_DIPS = Isaac.GetItemIdByName("Plop!"),
    TEN_POOPS = Isaac.GetItemIdByName("Ska Padaba!"),
    TEN_TENS = Isaac.GetItemIdByName("Oh Sweet Merciful Christ!"),

    FADED_NOTE = Isaac.GetItemIdByName("Faded Note"),
    AMORPHOUS_GLOBOSA = Isaac.GetItemIdByName("Amorphous Globosa"),
    BUZZ_FLY = Isaac.GetItemIdByName("Buzz Fly"),
    MILAS_HEAD = Isaac.GetItemIdByName("Mila's Head"),
    CLAY_SOLDIER = Isaac.GetItemIdByName("The Lesser Key"),
    BUPRINORPHINE = Isaac.GetItemIdByName("Buprinorphine"),
    KROKODIL = Isaac.GetItemIdByName("Krokodil"),
    FLIPPED_NOTE = Isaac.GetItemIdByName("Flipped Note"),
    PANDEMONIUM = Isaac.GetItemIdByName("Pandemonium"),
    TOY_PHONE = Isaac.GetItemIdByName("Toy Phone"),
    TOY_PHONE_ALT = Isaac.GetItemIdByName("Toy Phone?"),
    TOY_PHONE_DUMMY = Isaac.GetItemIdByName("Toy Phone Dummy"),

    FURSUIT = Isaac.GetItemIdByName("Fursuit"),
    MILAS_COLLAR = Isaac.GetItemIdByName("Mila's Collar"),
    DEAD_DAISY = Isaac.GetItemIdByName("Dead Daisy"),
    NAME_TAG = Isaac.GetItemIdByName("Name Tag"),
    IMMORTAL_BABY = Isaac.GetItemIdByName("Immortal Baby"),
    RABIES = Isaac.GetItemIdByName("Rabies"),
    DIVINE_MUD = Isaac.GetItemIdByName("Divine Mud"),
    STRANGE_STARS = Isaac.GetItemIdByName("Strange Stars"),
    PHOSSY_JAW = Isaac.GetItemIdByName("Phossy Jaw"),
    DADS_PANTS = Isaac.GetItemIdByName("Dad's Pants"),
    YEET_A_BABY = Isaac.GetItemIdByName("Yeet-a-baby"),
    BUGGY_BABY = Isaac.GetItemIdByName("Buggy Baby"),
    COIN_OF_JUDGEMENT = Isaac.GetItemIdByName("Coin Of Judgement"),
    COLOBOMA = Isaac.GetItemIdByName("Coloboma"),
    CURSE_OF_JUSTICE = Isaac.GetItemIdByName("Curse of Justice"),
    MYPAD = Isaac.GetItemIdByName("MyPad"),
    VOYAGER = Isaac.GetItemIdByName("Voyager"),
    SOLIDARITY = Isaac.GetItemIdByName("Solidarity"),
    VENERA = Isaac.GetItemIdByName("Venera"),
    THRONE = Isaac.GetItemIdByName("Throne"),
    VOICE_OF_YEN = Isaac.GetItemIdByName("Voice of Yen"),
    BRAIN_BEAN = Isaac.GetItemIdByName("Brain Bean"),
    CHICKEN_NOODLE_SOUP = Isaac.GetItemIdByName("Chicken Noodle Soup"),
    OXYGEN = Isaac.GetItemIdByName("Oxygen"),
    QUICKSILVER = Isaac.GetItemIdByName("Quicksilver"),
}

Enums.Trinkets = {

    DEMON_CORE = Isaac.GetTrinketIdByName("Demon Core"),
    A_SINGLE_RAISIN = Isaac.GetTrinketIdByName("A Single Raisin"),
    PLACEHOLDER_TRINKET = Isaac.GetTrinketIdByName("Trinket"),
    CANKER_SORE = Isaac.GetTrinketIdByName("Canker Sore"),
    CRYPTIC_PENNY = Isaac.GetTrinketIdByName("Cryptic Penny"),
    BOOTLEG_CARTRIDGE = Isaac.GetTrinketIdByName("Bootleg Cartridge"),
    FLASHCART = Isaac.GetTrinketIdByName("Flashcart"),
    IDOL_OF_MOLECH = Isaac.GetTrinketIdByName("Idol Of Molech"),
    --LITHOPEDION = Isaac.GetTrinketIdByName("Lithopedion"),
    BLANK_WHITE_CARD = Isaac.GetTrinketIdByName("Blank White Card"),
    YES = Isaac.GetTrinketIdByName("YES!"),
    FLOPPY_DISK = Isaac.GetTrinketIdByName("Floppy Disk"),
    PLASTIC_KEY = Isaac.GetTrinketIdByName("Plastic Key"),
    THE_OTHER_HAND = Isaac.GetTrinketIdByName("The Other Hand"),
    SCENTED_PENNY = Isaac.GetTrinketIdByName("Scented Penny"),
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
    JAIL_KEY = {
        TYPE = Isaac.GetEntityTypeByName("Jail Key"),
        VARIANT = Isaac.GetEntityVariantByName("Jail Key"),
        SUBTYPE = 33
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
    TOY_CHEST = {
        TYPE = Isaac.GetEntityTypeByName("Toy Chest"),
        VARIANT = Isaac.GetEntityVariantByName("Toy Chest"),
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

        TIME_WIZARD = Isaac.GetCardIdByName("Time Wizard"),
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

Enums.Curses = {
    STALKED = Isaac.GetCurseIdByName("Curse of the Stalked"),
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