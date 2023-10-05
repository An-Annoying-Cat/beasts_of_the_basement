local Mod = BotB

Mod.LoadScripts({
    --ENTITIES
    "scripts.entities.drifter",
    "scripts.entities.golfball",

    --GRIDS
    "scripts.entities.grids.radioactive_barrel",

    --ENEMIES
    "scripts.entities.enemies.eternalfly",

    "scripts.entities.enemies.chapter_1.skooter",
    "scripts.entities.enemies.chapter_1.ping",
    "scripts.entities.enemies.chapter_1.pong",
    "scripts.entities.enemies.chapter_1.inchworm",
    "scripts.entities.enemies.chapter_1.sleazebag",
    "scripts.entities.enemies.chapter_1.chaff",
    "scripts.entities.enemies.chapter_1.innie",
    "scripts.entities.enemies.chapter_1.inniereverse",
    "scripts.entities.enemies.chapter_1.planecreep",
    "scripts.entities.enemies.chapter_1.ms_horf",
    "scripts.entities.enemies.chapter_1.feral",
    "scripts.entities.enemies.chapter_1.paf",
    "scripts.entities.enemies.chapter_1.skipfly",
    "scripts.entities.enemies.chapter_1.flapjack",
    "scripts.entities.enemies.chapter_1.flapstack",
    "scripts.entities.enemies.chapter_1.grilled_flapjack",
    "scripts.entities.enemies.chapter_1.grilled_flapstack",
    "scripts.entities.enemies.chapter_1.cherry",
    "scripts.entities.enemies.chapter_1.high_clotty",
    "scripts.entities.enemies.chapter_1.ant",
    "scripts.entities.enemies.chapter_1.bullet_ant",
    "scripts.entities.enemies.chapter_1.super_bullet_ant",
    "scripts.entities.enemies.chapter_1.stunky",



    "scripts.entities.enemies.chapter_1.drone",
    "scripts.entities.enemies.chapter_1.unboxer",

    "scripts.entities.minibosses.bamf",
    "scripts.entities.minibosses.spiderboi",

    "scripts.entities.enemies.chapter_1_alt.dross.culo",
    "scripts.entities.enemies.chapter_1_alt.dross.shithead",

    "scripts.entities.enemies.chapter_2.tippytap",
    "scripts.entities.enemies.chapter_2.croast",
    "scripts.entities.enemies.chapter_2.funguy",
    "scripts.entities.enemies.chapter_2.tapeworm",

    "scripts.entities.enemies.chapter_2.flooded_caves.hydroknight",

    "scripts.entities.enemies.chapter_2_alt.mines.kettle",
    "scripts.entities.enemies.chapter_2_alt.mines.crockpot",
    "scripts.entities.enemies.chapter_2_alt.mines.crockpot_new",
    "scripts.entities.enemies.chapter_2_alt.mines.spicybony",
    "scripts.entities.enemies.chapter_2_alt.mines.geohorf",
    "scripts.entities.enemies.chapter_2_alt.mines.geo_fatty",
    "scripts.entities.enemies.chapter_2_alt.ashpit.oozer",

    "scripts.entities.enemies.chapter_3.seducer",
    "scripts.entities.enemies.chapter_3.desirer",
    "scripts.entities.enemies.chapter_3.palesniffle",
    "scripts.entities.enemies.chapter_3.puer_puella",
    "scripts.entities.enemies.chapter_3.paranoiac",
    "scripts.entities.enemies.chapter_3.slight",

    "scripts.entities.minibosses.babby",
    "scripts.entities.minibosses.babby_fake",

    "scripts.entities.enemies.chapter_3_alt.kehehan",
    --"scripts.entities.enemies.chapter_3_alt.shard",
    "scripts.entities.enemies.chapter_3_alt.cursed_horf",

    "scripts.entities.bosses.thaumaturge",

    "scripts.entities.enemies.chapter_3_alt.gehenna.mabel",

    "scripts.entities.enemies.chapter_4.womb.giblet",
    "scripts.entities.enemies.chapter_4.womb.gibby",
    "scripts.entities.enemies.chapter_4.womb.cadre",
    "scripts.entities.enemies.chapter_4.utero.trojan",

    "scripts.entities.enemies.chapter_5.cursed_mulligan",
    "scripts.entities.enemies.chapter_5.cursed_pooter",
    "scripts.entities.enemies.chapter_5.cursed_mulliboom",


    "scripts.entities.enemies.ascent.batso",
    "scripts.entities.enemies.ascent.double_cherry",

    "scripts.entities.enemies.special.pursuer",

    --BOSSES
    "scripts.entities.bosses.despair",

    --FAMILIARS
    "scripts.entities.familiars.robobabyzero",
    "scripts.entities.familiars.onyxmarble",
    "scripts.entities.familiars.atombombbaby",
    "scripts.entities.familiars.bhf",
    "scripts.entities.familiars.faithfulfleet",
    --"scripts.entities.familiars.jail_keyghost",
    "scripts.entities.familiars.amorphous_globosa",
    "scripts.entities.familiars.buzz_fly",
    "scripts.entities.familiars.attack_ant",
    "scripts.entities.familiars.clay_soldier",


    --ITEMS
    "scripts.entities.items.alphaarmor",
    "scripts.entities.items.treemansyndrome",
    "scripts.entities.items.placeholder_item",
    "scripts.entities.items.toy_helicopter",
    "scripts.entities.items.thehunger",
    "scripts.entities.items.50shades",
    "scripts.entities.items.grub",
    "scripts.entities.items.mudpie",
    "scripts.entities.items.houseplant",
    "scripts.entities.items.champs_mask",
    "scripts.entities.items.the_human_soul",
    "scripts.entities.items.thebestiary",
    "scripts.entities.items.technano",
    "scripts.entities.items.crowbar",
    "scripts.entities.items.spoiled_milk",
    "scripts.entities.items.liquid_latex",
    "scripts.entities.items.wiggly_boy",
    "scripts.entities.items.lucky_lighter",
    "scripts.entities.items.enlightenment",
    "scripts.entities.items.odd_mushroom_round",
    "scripts.entities.items.healthy_snack",
    "scripts.entities.items.trigger_button",
    "scripts.entities.items.e-meter",
    "scripts.entities.items.deck_of_too_many_things",
    "scripts.entities.items.dusty_d6",
    "scripts.entities.items.fuck_that_noise",
    "scripts.entities.items.dusty_d100",
    "scripts.entities.items.d11",
    "scripts.entities.items.house_of_leaves",
    "scripts.entities.items.blood_meridian",
    "scripts.entities.items.lil_ari",
    "scripts.entities.items.dusty_d4",
    "scripts.entities.items.x10_shitposts",
    "scripts.entities.items.faded_note",
    "scripts.entities.items.milas_head",
    "scripts.entities.items.buprinorphine",
    "scripts.entities.items.flipped_note",


    --TRINKETS
    "scripts.entities.items.trinkets.demoncore",
    "scripts.entities.items.trinkets.asingleraisin",
    "scripts.entities.items.trinkets.placeholder_trinket",
    "scripts.entities.items.trinkets.cankersore",
    "scripts.entities.items.trinkets.bootlegcart",
    "scripts.entities.items.trinkets.flashcart",
    "scripts.entities.items.trinkets.idol_of_molech",
    -- 
    "scripts.entities.items.trinkets.blank_white_card",
    "scripts.entities.items.trinkets.yes",
    "scripts.entities.items.trinkets.floppy_disk",
    --
    "scripts.entities.items.trinkets.scented_penny",


    --PICKUPS
    "scripts.entities.items.pickups.kickcube",
    "scripts.entities.items.pickups.jumpcrystal",
    "scripts.entities.items.pickups.gigapenny",
    "scripts.entities.items.pickups.gigakey",
    "scripts.entities.items.pickups.shitcoin",
    "scripts.entities.items.pickups.knowledge_points",
    --"scripts.entities.items.pickups.jail_key",
    "scripts.entities.items.pickups.toy_chest",


    --CONSUMABLES
    "scripts.entities.consumables.pills",
    "scripts.entities.consumables.shotgunkingcards",
    "scripts.entities.consumables.ojcards",
    "scripts.entities.consumables.ygocards",
    "scripts.entities.consumables.voidraincards",
    "scripts.entities.consumables.mahjongtiles",
    "scripts.entities.consumables.othercards",
    
    --STATUS EFFECTS
    "scripts.status_effects.fire_rework",

    --Effects
    --"scripts.entities.effects.trippin",
    "scripts.entities.effects.solomon_bestiary_ui",

    --PLAYERS
    "scripts.players.jezebel",
    "scripts.players.solomon",
    "scripts.players.tezebel",
    "scripts.players.tolomon",

    --CHALLENGES
    "scripts.challenges.back_pocket",
    --"scripts.challenges.mybasement",

})