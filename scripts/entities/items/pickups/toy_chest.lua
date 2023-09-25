local Mod = BotB
local sfx = SFXManager()
local game = Game()
local TOY_CHEST = {}

local function getPlayers()
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
  
	return players
end

--Code fram Rare Chests


local function optionsCheck(pickup)
	if pickup.OptionsPickupIndex and pickup.OptionsPickupIndex > 0 then
		for _, entity in pairs(Isaac.FindByType(5, -1, -1)) do
			if entity:ToPickup().OptionsPickupIndex and entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and GetPtrHash(entity:ToPickup()) ~= GetPtrHash(pickup) then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
			entity:Remove()
			end
		end
	end
end




local ToyItemPool = {
    Isaac.GetItemIdByName("Spindown Dice"),
    Isaac.GetItemIdByName("R Key"),
    Isaac.GetItemIdByName("Booster Pack"),
    Isaac.GetItemIdByName("X-Ray Vision"),
    Isaac.GetItemIdByName("The Gamekid"),
    Isaac.GetItemIdByName("Starter Deck"),
    Isaac.GetItemIdByName("R Key"),
    Isaac.GetItemIdByName("The D6"),
    Isaac.GetItemIdByName("Portable Slot"),
    Isaac.GetItemIdByName("SMB Super Fan"),
    Isaac.GetItemIdByName("Missing No"),
    Isaac.GetItemIdByName("D100"),
    Isaac.GetItemIdByName("D4"),
    Isaac.GetItemIdByName("D10"),
    Isaac.GetItemIdByName("Gnawed Leaf"),
    Isaac.GetItemIdByName("Magic Mushroom"),
    Isaac.GetItemIdByName("Blank Card"),
    CollectibleType.COLLECTIBLE_1UP,
    Isaac.GetItemIdByName("D12"),
    Isaac.GetItemIdByName("D7"),
    Isaac.GetItemIdByName("Mystery Gift"),
    Isaac.GetItemIdByName("Notched Axe"),
    CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX,
    CollectibleType.COLLECTIBLE_POKE_GO,
    CollectibleType.COLLECTIBLE_1UP,
    CollectibleType.COLLECTIBLE_YO_LISTEN,
    CollectibleType.COLLECTIBLE_D20,
    CollectibleType.COLLECTIBLE_MAGGYS_BOW,
    CollectibleType.COLLECTIBLE_MR_DOLLY,
    CollectibleType.COLLECTIBLE_FRIEND_BALL,
    CollectibleType.COLLECTIBLE_GB_BUG,
    CollectibleType.COLLECTIBLE_D8,
    CollectibleType.COLLECTIBLE_MINE_CRAFTER,
    CollectibleType.COLLECTIBLE_D1,
    CollectibleType.COLLECTIBLE_D_INFINITY,
    CollectibleType.COLLECTIBLE_MARBLES,
    CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE,
    CollectibleType.COLLECTIBLE_MEGA_MUSH,
    CollectibleType.COLLECTIBLE_PLUM_FLUTE,
    CollectibleType.COLLECTIBLE_SPIN_TO_WIN,
    CollectibleType.COLLECTIBLE_CANDY_HEART,
    CollectibleType.COLLECTIBLE_TMTRAINER,
    CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, --Well, Isaac died in a toy chest, didn't he?

    BotB.Enums.Items.ALPHA_ARMOR,
    BotB.Enums.Items.BHF,
    BotB.Enums.Items.DECK_OF_TOO_MANY_THINGS,
    BotB.Enums.Items.DUSTY_D100,
    BotB.Enums.Items.DUSTY_D6,
    BotB.Enums.Items.D11,
    BotB.Enums.Items.LIL_ARI,
    BotB.Enums.Items.LIQUID_LATEX,
    BotB.Enums.Items.CHAMPS_MASK,
    BotB.Enums.Items.CROWBAR,
}

if FiendFolio then
    local ffToyItems = {
         Isaac.GetItemIdByName("Eternal D12"),
         Isaac.GetItemIdByName("Eternal D10"),
         Isaac.GetItemIdByName("D2"),
         Isaac.GetItemIdByName("Azurite Spindown"),
         Isaac.GetItemIdByName("Dusty D10"),
         Isaac.GetItemIdByName("Loaded D6"),
         Isaac.GetItemIdByName("D3"),
         Isaac.GetItemIdByName("Fiddle Cube"),
         Isaac.GetItemIdByName("A.V.G.M."),
         Isaac.GetItemIdByName("Wrong Warp"),
         Isaac.GetItemIdByName("Toy Camera"),
         Isaac.GetItemIdByName("Dazzling Slot"),
         Isaac.GetItemIdByName("Gamma Gloves"),
         Isaac.GetItemIdByName("Error's Crazy Slots"),
         Isaac.GetItemIdByName("Sculpted Pepper"),
         Isaac.GetItemIdByName("Dice Bag"),
         Isaac.GetItemIdByName("Chirumiru"),
         Isaac.GetItemIdByName("Birthday Gift"),
         Isaac.GetItemIdByName("Clear Case"),
         Isaac.GetItemIdByName("Secret Stash"),
         Isaac.GetItemIdByName("Leftover Takeout"),
         Isaac.GetItemIdByName("Lawn Darts"),
         Isaac.GetItemIdByName("Toy Piano"),
         Isaac.GetItemIdByName("Hypno Ring"),
         Isaac.GetItemIdByName("Model Rocket"),
         Isaac.GetItemIdByName("Greg The Egg"),
         Isaac.GetItemIdByName("Chaldean Axe"),
         Isaac.GetItemIdByName("Evil Sticker"),
         Isaac.GetItemIdByName("Dice Goblin"),
         Isaac.GetItemIdByName("D3"),
         Isaac.GetItemIdByName("Emoji Glasses"),
         Isaac.GetItemIdByName("Crazy Jackpot"),
         Isaac.GetItemIdByName("Kinda Egg"),
         Isaac.GetItemIdByName("Time Itself"),
         Isaac.GetItemIdByName("Maria's Smash Trophy"),
         Isaac.GetItemIdByName("Fist Full Of Ash"),
         Isaac.GetItemIdByName("Isaac.chr"),
         Isaac.GetItemIdByName("Brick Figure"),
         Isaac.GetItemIdByName("Goldshi Lunch"),
         Isaac.GetItemIdByName("Twinkle of Contagion"),
         Isaac.GetItemIdByName("Token Bag"),
         Isaac.GetItemIdByName("Green Orange"),
         Isaac.GetItemIdByName("Reheated Pizza"),
         --Isaac.GetItemIdByName("Fiend's Third Leg"),

    }
    for i=1, #ffToyItems do
        ToyItemPool[#ToyItemPool+1] = ffToyItems[i]
    end
end
if Epiphany then
    local epiToyItems = {
         Isaac.GetItemIdByName("D5"),
         Isaac.GetItemIdByName("Chance Cube"),
         Isaac.GetItemIdByName("Blighted Dice"),
         Isaac.GetItemIdByName("Surprise Box"),
         Isaac.GetItemIdByName("Empty Deck"),
         Isaac.GetItemIdByName("Portable Dice Machine"),
         Isaac.GetItemIdByName("Delirious Die Dispenser"),
         Isaac.GetItemIdByName("Stock Fluctuation"),
         Isaac.GetItemIdByName("Woolen Cap"),
    }
    for i=0,#epiToyItems do
        ToyItemPool[#ToyItemPool+1] = epiToyItems[i]
    end
end
if Deliverance then
    local delToyItems = {
         Isaac.GetItemIdByName("D<3"),
         Isaac.GetItemIdByName("Edgeless Cube Battery"),
         Isaac.GetItemIdByName("Time Gal"),
         Isaac.GetItemIdByName("Air Strike!"),
         Isaac.GetItemIdByName("Battle Royale"),
         Isaac.GetItemIdByName("Golden Apple"),
         Isaac.GetItemIdByName("Urn Of Want"),
    }
    for i=1,#delToyItems do
        ToyItemPool[#ToyItemPool+1] = delToyItems[i]
    end
end
if Revelations then
    local revToyItems = {
         Isaac.GetItemIdByName("Hyper Dice"),
         Isaac.GetItemIdByName("Cardboard Robot"),
         Isaac.GetItemIdByName("Moxie's Yarn"),
         Isaac.GetItemIdByName("Super Meat Blade"),
         Isaac.GetItemIdByName("Waka Waka"),
         Isaac.GetItemIdByName("Cabbage Patch"),
    }
    for i=1,#revToyItems do
        ToyItemPool[#ToyItemPool+1] = revToyItems[i]
    end
end

if Retribution then
    local retToyItems = {
         Isaac.GetItemIdByName("Sculpting Clay"),
         Isaac.GetItemIdByName("Bottled Fairy"),
         Isaac.GetItemIdByName("Everlasting Pill"),
         Isaac.GetItemIdByName("Monster Candy"),
         Isaac.GetItemIdByName("Gacha-Go"),
         Isaac.GetItemIdByName("Seed Sack"),
         Isaac.GetItemIdByName("Bygone Arm"),
         Isaac.GetItemIdByName("Coinflip"),
         Isaac.GetItemIdByName("Celestial Berry"),
         Isaac.GetItemIdByName("Heart Shaped Balloon"),
         Isaac.GetItemIdByName("Silver Flesh"),
         Isaac.GetItemIdByName("Slick Spade"),
         Isaac.GetItemIdByName("Tool"),
         Isaac.GetItemIdByName("Spoils Pouch"),
         Isaac.GetItemIdByName("Multi-Capsule"),
         Isaac.GetItemIdByName("Kompu Gacha"),
         Isaac.GetItemIdByName("Pride Pin"),
         Isaac.GetItemIdByName("Polaris"),
         Isaac.GetItemIdByName("Bag of Seeds"),
         Isaac.GetItemIdByName("False Promise"),
    }
    for i=1,#retToyItems do
        ToyItemPool[#ToyItemPool+1] = retToyItems[i]
    end
end


local VanillaToyConsumablePool = {
    --by card id which gives subtype
    Card.CARD_CLUBS_2,
    Card.CARD_HEARTS_2,
    Card.CARD_SPADES_2,
    Card.CARD_DIAMONDS_2,
    Card.CARD_ACE_OF_CLUBS,
    Card.CARD_ACE_OF_DIAMONDS,
    Card.CARD_ACE_OF_HEARTS,
    Card.CARD_ACE_OF_SPADES,
    Card.CARD_JOKER,
    Card.CARD_CHAOS,
    Card.CARD_CREDIT,
    Card.CARD_RULES,
    Card.CARD_SUICIDE_KING,
    Card.CARD_GET_OUT_OF_JAIL,
    Card.CARD_QUESTIONMARK,
    Card.CARD_DICE_SHARD,
    Card.CARD_EMERGENCY_CONTACT,
    Card.CARD_HUGE_GROWTH,
    Card.CARD_ANCIENT_RECALL,
    Card.CARD_ERA_WALK,
    Card.CARD_CRACKED_KEY,
    Card.CARD_QUEEN_OF_HEARTS,
    Card.CARD_WILD,

    --BotB cards and objects
    Isaac.GetCardIdByName("White Dragon"),
    Isaac.GetCardIdByName("Red Dragon"),
    Isaac.GetCardIdByName("Green Dragon"),
    Isaac.GetCardIdByName("1 Dot"),
    Isaac.GetCardIdByName("1 Bam"),
    Isaac.GetCardIdByName("1 Crak"),
    Isaac.GetCardIdByName("9 Dot"),
    Isaac.GetCardIdByName("9 Bam"),
    Isaac.GetCardIdByName("9 Crak"),

    Isaac.GetCardIdByName("Cornered Despot"),
    Isaac.GetCardIdByName("August Presence"),
    Isaac.GetCardIdByName("Ammunition Depot"),
    Isaac.GetCardIdByName("Homecoming"),

    Isaac.GetCardIdByName("Mimyuu's Hammer"),
    Isaac.GetCardIdByName("Flip Out"),
    Isaac.GetCardIdByName("Oh My Friend"),
    Isaac.GetCardIdByName("Flamethrower"),

    Isaac.GetCardIdByName("Quicklove"),
    Isaac.GetCardIdByName("Starlight"),
    Isaac.GetCardIdByName("Lucky Flower"),
    Isaac.GetCardIdByName("Pale Box"),

    Isaac.GetCardIdByName("Zap"),
    Isaac.GetCardIdByName("Blade Dance"),
    Isaac.GetCardIdByName("Bank Error In Your Favor"),
}
--just batteries i guess? cant think of much else
local VanillaToyPickupPool = {
    {90,1},
    {90,2},
    {90,3},
    {90,4},
}
--FF cards, goes by card id
local ffToyCardConsumablePool = {
    Isaac.GetCardIdByName("+3 Fireballs"),
    Isaac.GetCardIdByName('+3 Fireballs?'),
    Isaac.GetCardIdByName("Imp-losion"),
    
    Isaac.GetCardIdByName("Grotto Beast"),
    Isaac.GetCardIdByName("Puzzle Piece"),
    Isaac.GetCardIdByName("Plague of Decay"),
    Isaac.GetCardIdByName("Defuse"),
    
    Isaac.GetCardIdByName("Skip Card"),
    Isaac.GetCardIdByName("Pot of Greed"),
    Isaac.GetCardIdByName("Gift Card"),
            --Club Penguin
    Isaac.GetCardIdByName("CardJitsu Soccer"),
    Isaac.GetCardIdByName("CardJitsu Flooring Upgrade"),
    Isaac.GetCardIdByName("CardJitsu AC3000"),
            --Clubs
    Isaac.GetCardIdByName("3 of Clubs"),
    Isaac.GetCardIdByName("Jack of Clubs"),
    Isaac.GetCardIdByName("Queen of Clubs"),
    Isaac.GetCardIdByName("King of Clubs"),
            --Diamonds
    Isaac.GetCardIdByName("3 of Diamonds"),
    Isaac.GetCardIdByName("Jack of Diamonds"),
    Isaac.GetCardIdByName("Queen of Diamonds"),
    Isaac.GetCardIdByName("King of Diamonds"),
            --Spades
    Isaac.GetCardIdByName("3 of Spades"),
    Isaac.GetCardIdByName("Jack of Spades"),
    Isaac.GetCardIdByName("Queen of Spades"),
    Isaac.GetCardIdByName("King of Spades"),
            --Hearts
    Isaac.GetCardIdByName("3 of Hearts"),
    Isaac.GetCardIdByName("Jack of Hearts"),
            --Other
    Isaac.GetCardIdByName("Misprinted Joker"),
    Isaac.GetCardIdByName("Joke of Clubs"),
    Isaac.GetCardIdByName("Misprinted 2 of Clubs"),
    Isaac.GetCardIdByName("13 of Stars"),
            --Joke Cards
    Isaac.GetCardIdByName("King of Clubs?"),
            --Pokemon Cards
    Isaac.GetCardIdByName("Grass Energy"),
    Isaac.GetCardIdByName("Fire Energy"),
    Isaac.GetCardIdByName("Water Energy"),
    Isaac.GetCardIdByName("Lightning Energy"),
    Isaac.GetCardIdByName("Fighting Energy"),
    Isaac.GetCardIdByName("Psychic Energy"),
    Isaac.GetCardIdByName("Colorless Energy"),
    Isaac.GetCardIdByName("Darkness Energy"),
    Isaac.GetCardIdByName("Metal Energy"),
    Isaac.GetCardIdByName("Dragon Energy"),
    Isaac.GetCardIdByName("Fairy Energy"),
    --Isaac.GetCardIdByName("Trainer Card"), --Unused as of now I think
            --Objects
    Isaac.GetCardIdByName("Green House"),
    Isaac.GetCardIdByName("Brick Seperator"),
    Isaac.GetCardIdByName("Blank Letter Tile"),
    Isaac.GetCardIdByName("Horse Push-Pop"),
    Isaac.GetCardIdByName("TopHat"),
    Isaac.GetCardIdByName("Stud"),
    Isaac.GetCardIdByName("2 Studs"),
    Isaac.GetCardIdByName("3 Studs"),
    Isaac.GetCardIdByName("4 Studs"),
    Isaac.GetCardIdByName("5 Studs"),
    Isaac.GetCardIdByName("6 Studs"),
    Isaac.GetCardIdByName("Christmas Cracker"),
            --Discs
    Isaac.GetCardIdByName("Treasure Disc"),
    Isaac.GetCardIdByName("Shop Disc"),
    Isaac.GetCardIdByName("Boss Disc"),
    Isaac.GetCardIdByName("Secret Disc"),
    Isaac.GetCardIdByName("Devil Disc"),
    Isaac.GetCardIdByName("Angel Disc"),
    Isaac.GetCardIdByName("Planetarium Disc"),
    Isaac.GetCardIdByName("Chaos Disc"),
    Isaac.GetCardIdByName("Broken Disc"),
    --Isaac.GetCardIdByName("Tainted Treasure Disc"), --only if both ff and taintedtreasure
            --Glass Dice
    Isaac.GetCardIdByName("Glass D6"),
    Isaac.GetCardIdByName("Glass D4"),
    Isaac.GetCardIdByName("Glass D8"),
    Isaac.GetCardIdByName("Glass D100"),
    Isaac.GetCardIdByName("Glass D10"),
    Isaac.GetCardIdByName("Glass D20"),
    Isaac.GetCardIdByName("Glass D12"),
    Isaac.GetCardIdByName("Glass Spindown"),
    Isaac.GetCardIdByName("Glass Azurite Spindown"),
    Isaac.GetCardIdByName("Glass D2"),
    --storage batteries
    Isaac.GetCardIdByName("Storage Battery"),
    Isaac.GetCardIdByName("Storage Battery (1)"),
    Isaac.GetCardIdByName("Storage Battery (2)"),
    Isaac.GetCardIdByName("Storage Battery (Full)"),
    Isaac.GetCardIdByName("Corroded Battery"),
    Isaac.GetCardIdByName("Corroded Battery (1)"),
    Isaac.GetCardIdByName("Corroded Battery (2)"),
    Isaac.GetCardIdByName("Corroded Battery (Full)"),
}
local ffTTConsumablePool = {
    Isaac.GetCardIdByName("Tainted Treasure Disc"),
}
--just tokens and stud pennies i guess. type = 5, variant is variable
local ffToyPickupPool = {
    {961,0}, --token
    {20,217}, --Stud penny
    {666,11}, --52 Deck
    {901,0}, --the Cool Batteries...
    {900,0},
    {902,0},
    {903,0},
}
local retToyConsumablePool = {
    Isaac.GetCardIdByName("Sword Capsule"),
    Isaac.GetCardIdByName("Heart Capsule"),
    Isaac.GetCardIdByName("Tear Capsule"),
    Isaac.GetCardIdByName("Bow Capsule"),
    Isaac.GetCardIdByName("Fling Capsule"),
    Isaac.GetCardIdByName("Boot Capsule"),
    Isaac.GetCardIdByName("Clover Capsule"),
    Isaac.GetCardIdByName("Combo Capsule"),
    Isaac.GetCardIdByName(" Combo Capsule"),
    Isaac.GetCardIdByName("  Combo Capsule"),
    Isaac.GetCardIdByName("   Combo Capsule"),
    Isaac.GetCardIdByName("    Combo Capsule"),
    Isaac.GetCardIdByName("     Combo Capsule"),
    Isaac.GetCardIdByName("      Combo Capsule"),
    Isaac.GetCardIdByName("       Combo Capsule"),
    Isaac.GetCardIdByName("        Combo Capsule"),
    Isaac.GetCardIdByName("         Combo Capsule"),
    Isaac.GetCardIdByName("          Combo Capsule"),
    Isaac.GetCardIdByName("           Combo Capsule"),
    Isaac.GetCardIdByName("            Combo Capsule"),
    Isaac.GetCardIdByName("             Combo Capsule"),
    Isaac.GetCardIdByName("              Combo Capsule"),
    Isaac.GetCardIdByName("               Combo Capsule"),
    Isaac.GetCardIdByName("                Combo Capsule"),
    Isaac.GetCardIdByName("                 Combo Capsule"),
    Isaac.GetCardIdByName("                  Combo Capsule"),
    Isaac.GetCardIdByName("                   Combo Capsule"),
    Isaac.GetCardIdByName("                    Combo Capsule"),
    Isaac.GetCardIdByName("Whale Card"),
    Isaac.GetCardIdByName("Monster Candy"),
    Isaac.GetCardIdByName("Maxed Credit Card"),
}
--just minicapsules
local retToyPickupPool = {
    {1882,0}
}
--deliverance consumables
local delToyConsumablePool = {
    Isaac.GetCardIdByName("Abyss"),
    Isaac.GetCardIdByName("Firestorms"),
    Isaac.GetCardIdByName("Farewell Stone"),
}

local epiToyConsumablePool = {
    Isaac.GetCardIdByName("Queen of Hearts?"),
    Isaac.GetCardIdByName("Two of Spades?"),
    Isaac.GetCardIdByName("Two of Clubs?"),
    Isaac.GetCardIdByName("Two of Diamonds?"),
    Isaac.GetCardIdByName("Two of Hearts?"),
    Isaac.GetCardIdByName("! Card"),
    Isaac.GetCardIdByName("Debit Card"),
    Isaac.GetCardIdByName("Go to Jail"),
    Isaac.GetCardIdByName("+1 Card"),
    Isaac.GetCardIdByName("Reverse Card"),
    Isaac.GetCardIdByName("Drawn Card"),
    Isaac.GetCardIdByName("-1 Card"),
    Isaac.GetCardIdByName("Inverse Card"),
    Isaac.GetCardIdByName("Pain in a Box"),
    Isaac.GetCardIdByName("Capsule D1"),
    Isaac.GetCardIdByName("Capsule D4"),
    Isaac.GetCardIdByName("Capsule D6"),
    Isaac.GetCardIdByName("Capsule Eternal D6"),
    Isaac.GetCardIdByName("Capsule D7"),
    Isaac.GetCardIdByName("Capsule D8"),
    Isaac.GetCardIdByName("Capsule D10"),
    Isaac.GetCardIdByName("Capsule D12"),
    Isaac.GetCardIdByName("Capsule D20"),
    Isaac.GetCardIdByName("Capsule D100"),
    Isaac.GetCardIdByName("Capsule Spindown Dice"),
}

local epiFFToyConsumablePool = {
    Isaac.GetCardIdByName("Capsule D2"),
    Isaac.GetCardIdByName("Capsule D3"),
    Isaac.GetCardIdByName("Capsule Loaded D6"),
    Isaac.GetCardIdByName("Capsule Eternal D10"),
    Isaac.GetCardIdByName("Capsule Dusty D10"),
    Isaac.GetCardIdByName("Capsule Eternal D12"),
    Isaac.GetCardIdByName("Capsule Azurite Spindown"),
}

local epiToyPickupPool = {
    {20,1777}, --Tasty penny
}
if FiendFolio then
    for i=1, #ffToyCardConsumablePool do
        VanillaToyConsumablePool[#VanillaToyConsumablePool+1] = ffToyCardConsumablePool[i]
    end
    for i=1, #ffToyPickupPool do
        VanillaToyPickupPool[#VanillaToyPickupPool+1] = ffToyPickupPool[i]
    end
end

if FiendFolio and TaintedTreasure then
    for i=1, #ffTTConsumablePool do
        VanillaToyConsumablePool[#ffTTConsumablePool+1] = ffTTConsumablePool[i]
    end
end

if Epiphany then
    for i=1, #epiToyConsumablePool do
        VanillaToyConsumablePool[#VanillaToyConsumablePool+1] = epiToyConsumablePool[i]
    end
    for i=1, #epiToyPickupPool do
        VanillaToyPickupPool[#VanillaToyPickupPool+1] = epiToyPickupPool[i]
    end
end

if FiendFolio and Epiphany then
    for i=1, #epiFFToyConsumablePool do
        VanillaToyConsumablePool[#ffTTConsumablePool+1] = epiFFToyConsumablePool[i]
    end
end

if Retribution then
    for i=1,#retToyConsumablePool do
        VanillaToyConsumablePool[#VanillaToyConsumablePool+1] = retToyConsumablePool[i]
    end
    for i=1, #retToyPickupPool do
        VanillaToyPickupPool[#VanillaToyPickupPool+1] = retToyPickupPool[i]
    end
end

if Deliverance then
    for i=1,#delToyConsumablePool do
        VanillaToyConsumablePool[#VanillaToyConsumablePool+1] = delToyConsumablePool[i]
    end
end



function TOY_CHEST.openToyChest(pickup, player)
    if pickup:GetSprite():GetAnimation() == "Open" then return end
	optionsCheck(pickup)
	pickup.SubType = 1
	pickup:GetData()["IsInRoom"] = true
	pickup:GetSprite():Play("Open")
	SFXManager():Play(SoundEffect.SOUND_CHEST_OPEN, 1, 2, false, 1.5, 0)
	if math.random(10) <= 1 then
		local item
        local foundItem = {}
		for i = 1, 1000 do 
			local unique = true
			item = ToyItemPool[math.random(#ToyItemPool)]
			for y = 1, #foundItem do if item == data.foundItem[y] then unique = false end end
			if (Isaac.GetItemConfig():GetCollectible(item).Tags & ItemConfig.TAG_NO_LOST_BR == ItemConfig.TAG_NO_LOST_BR and player:GetPlayerType() == 10 and player:HasCollectible(619)) or (Isaac.GetItemConfig():GetCollectible(item).Tags & ItemConfig.TAG_OFFENSIVE ~= ItemConfig.TAG_OFFENSIVE and player:GetPlayerType() == 31) then unique = false end
			if Isaac.GetItemConfig():GetCollectible(item).Quality <= 2 and player:GetPlayerType() == 31 and math.random(5) == 1 then unique = false end
			if Isaac.GetItemConfig():GetCollectible(item).Quality <= 2 and player:HasCollectible(691) and math.random(3) == 1 then unique = false end
			if Isaac.GetItemConfig():GetCollectible(item).Quality <= 1 and player:HasCollectible(691) then unique = false end
			if unique == true then break end
			if i == 1000 then item = 25 end
		end
		local pedestal = Isaac.Spawn(5, 100, item, pickup.Position, Vector.Zero, pickup)
		pedestal:GetSprite():ReplaceSpritesheet(5,"gfx/items/pick ups/toy_pedestal.png") 
		pedestal:GetSprite():LoadGraphics()
		pickup:Remove()
	else
		--Pickups...
        local amtPickups
        local amtCards
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KEY) then
            amtPickups = math.random(2,6)
            amtCards = math.random(2,4)
        else
            amtPickups = math.random(1,3)
            amtCards = math.random(1,2)
        end
        print("pickups lol")
        for i=1,amtPickups do
            local toyChestPickupPick = VanillaToyPickupPool[math.random(1,#VanillaToyPickupPool)]
            local chestPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP,toyChestPickupPick[1],toyChestPickupPick[2],pickup.Position,Vector(math.random(2,5),0):Rotated(math.random(0,359)),pickup)
        end
        for i=1,amtCards do
            local toyChestCardPick = VanillaToyConsumablePool[math.random(1,#VanillaToyConsumablePool)]
            local chestPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,toyChestCardPick,pickup.Position,Vector(math.random(2,5),0):Rotated(math.random(0,359)),pickup)
        end
        pickup.Timeout = 16

	end
end



function TOY_CHEST:chestCollision(pickup, collider, _)	
	if not collider:ToPlayer() then return end
    local forfeit = false
	local player = collider:ToPlayer()
	local sprite = pickup:GetSprite()
	if sprite:IsPlaying("Appear") then forfeit = true end	
    if sprite:IsPlaying("Opened") or sprite:IsPlaying("Open") then forfeit = true end
	if not forefeit and pickup.Variant == BotB.Enums.Pickups.TOY_CHEST.VARIANT then 
        TOY_CHEST.openToyChest(pickup, player) 
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, TOY_CHEST.chestCollision, BotB.Enums.Pickups.TOY_CHEST.VARIANT)

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("Plastic Key"), "Chests have a 1 in 3 chance to become Toy Chests.")
    EID:addTrinket(Isaac.GetTrinketIdByName("Plastic Key")+TrinketType.TRINKET_GOLDEN_FLAG, "Chests have a {{ColorRainbow}}1 in 2 chance{{ColorReset}} to become Toy Chests.")
end


--[[

--yoinked from Fiend Folio and then modified
function TOY_CHEST:chestInit(chest)
	--local room = game:GetRoom()
	--local chestseed = tostring(chest.InitSeed)
    --local d = chest:GetData()
	--local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'ChestData', chestseed, {})
	--if not d.chestRerollCheck then
		grng:SetSeed(chest.InitSeed, 0)
        print("chest")
		--Toy Chest
        local rhchance
		if FiendFolio.anyPlayerHas(BotB.Enums.Trinkets.PLASTIC_KEY, true) then
			rhchance = 3
			if FiendFolio.getTrinketMultiplierAcrossAllPlayers(BotB.Enums.Trinkets.PLASTIC_KEY) > 1 then
				rhchance = 2
			end
			if grng:RandomInt(rhchance) == 0 then
                print("TOY")
				chest:Morph(5,1229, 0, true)
			end
        else
            --1 in 64 chance of toy chest
            rhchance = 63
            if grng:RandomInt(rhchance) == 0 then
                print("TOY")
				chest:Morph(5,1229, 0, true)
			end
		end


	--end
end

Mod:AddCallback(TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST, TOY_CHEST.chestInit, PickupVariant.PICKUP_CHEST)
Mod:AddCallback(TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST, TOY_CHEST.chestInit, PickupVariant.PICKUP_LOCKEDCHEST)
]]

--yoinked from rare chests and modified with FF code
local grng = RNG()
function TOY_CHEST:chestUpdate(pickup)
	if (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast")) and pickup:GetSprite():GetFrame() == 1 and Game():GetRoom():GetType() ~= 11 and Game():GetLevel():GetStage() ~= 11 and not pickup:GetData().nomorph then
        --if player has Plastic Key
		if pickup.Variant == 50 then
            grng:SetSeed(pickup.InitSeed, 0)
            print("chest")
            --Toy Chest
            local rhchance
            if FiendFolio.anyPlayerHas(BotB.Enums.Trinkets.PLASTIC_KEY, true) then
                rhchance = 3
                if FiendFolio.getTrinketMultiplierAcrossAllPlayers(BotB.Enums.Trinkets.PLASTIC_KEY) > 1 then
                    rhchance = 2
                end
                if grng:RandomInt(rhchance) == 0 then
                    print("TOY")
                    pickup:Morph(5,1229, 0, true)
                    SFXManager():Play(21, 1, 2, false, 1.5, 0)
                end
            else
                --1 in 64 base chance of toy chest
                rhchance = 63
                if grng:RandomInt(rhchance) == 0 then
                    print("TOY")
                    pickup:Morph(5,1229, 0, true)
                    SFXManager():Play(21, 1, 2, false, 1.5, 0)
                end
            end
			
		end

        if pickup.Variant == 60 then
            grng:SetSeed(pickup.InitSeed, 0)
            print("chest")
            --Toy Chest
            local rhchance
            if FiendFolio.anyPlayerHas(BotB.Enums.Trinkets.PLASTIC_KEY, true) then
                rhchance = 3
                if FiendFolio.getTrinketMultiplierAcrossAllPlayers(BotB.Enums.Trinkets.PLASTIC_KEY) > 1 then
                    rhchance = 2
                end
                if grng:RandomInt(rhchance) == 0 then
                    print("TOY")
                    pickup:Morph(5,1229, 0, true)
                    SFXManager():Play(21, 1, 2, false, 1.5, 0)
                end
            else
                --1 in 64 base chance of toy chest
                rhchance = 63
                if grng:RandomInt(rhchance) == 0 then
                    print("TOY")
                    pickup:Morph(5,1229, 0, true)
                    SFXManager():Play(21, 1, 2, false, 1.5, 0)
                end
            end
			
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, TOY_CHEST.chestUpdate)