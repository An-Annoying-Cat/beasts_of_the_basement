local Mod = BotB

Mod.LoadScripts({
    --ENTITIES
    "scripts.entities.drifter",
    "scripts.entities.golfball",

    --GRIDS
    "scripts.entities.grids.radioactive_barrel",
    "scripts.entities.grids.slot_room_panel",
    "scripts.entities.grids.totems",
    "scripts.entities.grids.lights_mechanic",
    "scripts.entities.grids.ehehe",
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
    "scripts.entities.enemies.chapter_1.moldy_horf",
    "scripts.entities.enemies.chapter_1.kaufmann",
    "scripts.entities.enemies.chapter_1.peekabox",
    "scripts.entities.enemies.chapter_1.lars",
    "scripts.entities.enemies.chapter_1.jem",
    "scripts.entities.enemies.chapter_1.mr_mucus",
    "scripts.entities.enemies.chapter_1.flemmer",
    "scripts.entities.enemies.chapter_1.catarrh",
    "scripts.entities.enemies.chapter_1.sinustro",
    "scripts.entities.enemies.chapter_1.fat_gusher",
    "scripts.entities.enemies.chapter_1.cyan_moter",
    "scripts.entities.enemies.chapter_1.blighton",


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
    "scripts.entities.enemies.chapter_2_alt.ashpit.prick",
    "scripts.entities.enemies.chapter_2_alt.warrior",

    "scripts.entities.enemies.chapter_3.seducer",
    "scripts.entities.enemies.chapter_3.desirer",
    "scripts.entities.enemies.chapter_3.palesniffle",
    "scripts.entities.enemies.chapter_3.puer_puella",
    "scripts.entities.enemies.chapter_3.paranoiac",
    "scripts.entities.enemies.chapter_3.slight",
    "scripts.entities.enemies.chapter_3.somebody",
    "scripts.entities.enemies.chapter_3.gloom_fly",
    "scripts.entities.enemies.chapter_3.telepath",
    "scripts.entities.enemies.chapter_3.vantage",
    "scripts.entities.enemies.chapter_3.nycto",
    "scripts.entities.enemies.chapter_3.helio",
    "scripts.entities.enemies.chapter_3.gullet",
    "scripts.entities.enemies.chapter_3.mr_gullet",

    "scripts.entities.minibosses.babby",
    "scripts.entities.minibosses.babby_fake",

    "scripts.entities.enemies.chapter_3_alt.kehehan",
    --"scripts.entities.enemies.chapter_3_alt.shard",
    "scripts.entities.enemies.chapter_3_alt.cursed_horf",

    "scripts.entities.enemies.chapter_3_alt.gehenna.mabel",

    "scripts.entities.enemies.chapter_4.womb.giblet",
    "scripts.entities.enemies.chapter_4.womb.gibby",
    "scripts.entities.enemies.chapter_4.womb.cadre",
    "scripts.entities.enemies.chapter_4.utero.trojan",
    "scripts.entities.enemies.chapter_4.triachnoid",
    "scripts.entities.enemies.chapter_4.halftop",
    "scripts.entities.enemies.chapter_4.utero.peeclopia",
    "scripts.entities.enemies.chapter_4.rostellum",

    "scripts.entities.enemies.chapter_4_alt.billy",

    "scripts.entities.enemies.chapter_5.cursed_mulligan",
    "scripts.entities.enemies.chapter_5.cursed_pooter",
    "scripts.entities.enemies.chapter_5.cursed_mulliboom",
    "scripts.entities.enemies.chapter_5.choir",
    "scripts.entities.enemies.chapter_5.holy_dip",
    "scripts.entities.enemies.chapter_5.holy_squirt",
    "scripts.entities.enemies.chapter_5.pope",
    "scripts.entities.enemies.chapter_5.conqueror",


    "scripts.entities.enemies.ascent.batso",
    "scripts.entities.enemies.ascent.double_cherry",

    "scripts.entities.enemies.special.pursuer",
    "scripts.entities.enemies.special.pursuer_v2",
    "scripts.entities.enemies.special.mack",
    "scripts.entities.enemies.special.segmented_enemy_test",
    "scripts.entities.enemies.special.hushed_grimace",
    "scripts.entities.enemies.special.spinny_boi_test",

    "scripts.entities.enemies.special.generic_npc",
    "scripts.entities.enemies.special.generic_npc_old",

    --BOSSES
    "scripts.entities.bosses.despair",
    "scripts.entities.bosses.doortrap",
    "scripts.entities.bosses.thaumaturge",
    "scripts.entities.bosses.queenie",

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
    "scripts.entities.familiars.immortal_baby",
    "scripts.entities.familiars.yeet_a_baby",
    "scripts.entities.familiars.buggy_baby",
    "scripts.entities.familiars.throne",
    "scripts.entities.familiars.voice_of_yen",

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
    "scripts.entities.items.krokodil",
    "scripts.entities.items.toy_phone",
    "scripts.entities.items.milas_collar",
    "scripts.entities.items.fursuit",
    "scripts.entities.items.name_tag",
    "scripts.entities.items.rabies",
    "scripts.entities.items.strange_stars",
    "scripts.entities.items.divine_mud",
    "scripts.entities.items.dads_pants",
    "scripts.entities.items.pandemonium",
    "scripts.entities.items.coin_of_judgement",
    "scripts.entities.items.coloboma",
    "scripts.entities.items.curse_of_justice",
    "scripts.entities.items.mypad",
    "scripts.entities.items.voyager",
    "scripts.entities.items.brain_bean",
    "scripts.entities.items.chicken_noodle_soup",

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
    "scripts.entities.items.trinkets.the_other_hand",
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

    --Slots
    "scripts.entities.slots.challenge_computer",
    
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
    "scripts.challenges.mybasement",
    --"scripts.challenges.basement_crossing",

    --CURSES
    "scripts.curses.curses",

    --SPECIAL
    "scripts.core.roomgen_repentogon",
    "scripts.core.menu_changes",

})