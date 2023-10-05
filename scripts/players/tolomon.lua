local Mod = BotB
local Tolomon = {}

local PLAYER_TOLOMON = Isaac.GetPlayerTypeByName("Tolomon", true)
BotB.SOLOMON_EXTRA1 = Isaac.GetCostumeIdByPath("gfx/characters/character_solomon_extra1.anm2")
BotB.TOLOMON_EXTRA2 = Isaac.GetCostumeIdByPath("gfx/characters/character_tolomon_extra2.anm2")
local HiddenItemManager = require("scripts.core.hidden_item_manager")


--- Written by Zamiel, technique created by im_tem
-- @param player EntityPlayer
-- @param enabled boolean
-- @param modifyCostume boolean
function Tolomon:setBlindfold(player, enabled, modifyCostume)
    local game = Game()
    local character = player:GetPlayerType()
    local challenge = Isaac.GetChallenge()
  
    if enabled then
      game.Challenge = Challenge.CHALLENGE_SOLAR_SYSTEM -- This challenge has a blindfold
      player:ChangePlayerType(character)
      game.Challenge = challenge
  
      -- The costume is applied automatically
      if not modifyCostume then
        player:TryRemoveNullCostume(NullItemID.ID_BLINDFOLD)
      end
    else
      game.Challenge = Challenge.CHALLENGE_NULL
      player:ChangePlayerType(character)
      game.Challenge = challenge
  
      if modifyCostume then
        player:TryRemoveNullCostume(NullItemID.ID_BLINDFOLD)
      end
    end
  end


function Tolomon:playerGetCostume(player)
    --print("weebis")
    if player:GetPlayerType() == PLAYER_TOLOMON then
        --print("whongus")
        player:AddNullCostume(BotB.SOLOMON_EXTRA1)
        player:GetSprite():ReplaceSpritesheet(0,"gfx/characters/character_tolomon.png")
        player:GetSprite():LoadGraphics()
        --HiddenItemManager:Add(player,CollectibleType.COLLECTIBLE_TRANSCENDENCE,-1,1,"TOLOMON_PASSIVE")
        --local itemConfig = Isaac.GetItemConfig()
        --local itemConfigItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE)
        --player:RemoveCostume(itemConfigItem)
        player:AddNullCostume(BotB.TOLOMON_EXTRA2)
		--player:SetPocketActiveItem(Isaac.GetItemIdByName("The Lesser Key"), ActiveSlot.SLOT_POCKET, false)
        --local basicDudePickup = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,HeartSubType.HEART_HALF,Vector.Zero,Vector.Zero,player)
        --player:UseActiveItem(BotB.Enums.Items.CLAY_SOLDIER, UseFlag.USE_NOANIM)
        --local basicDudePickup = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,HeartSubType.HEART_HALF,Vector.Zero,Vector.Zero,player)
          --  player:UseActiveItem(BotB.Enums.Items.CLAY_SOLDIER, UseFlag.USE_NOANIM)
        
            
        if EID then
            local myPlayerID = Isaac.GetPlayerTypeByName("Tolomon")
            EID:addBirthright(myPlayerID, "Spawns 3-5 random pickups and recharges The Lesser Key upon entering a new floor.")
          
              --Lesser Key desriptions
                  -- For any entity.       Optional parameters: language
                  
              --
              
          
          end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Tolomon.playerGetCostume, 0)




function Tolomon:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
    if player:GetPlayerType() == PLAYER_TOLOMON then
        --print("fuck")
        --
        local itemConfig = Isaac.GetItemConfig()
        local itemConfigItem = itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE)
        player:RemoveCostume(itemConfigItem)
        if player:HasCollectible(Isaac.GetItemIdByName("The Lesser Key"), true) == false then
            player:SetPocketActiveItem(Isaac.GetItemIdByName("The Lesser Key"), ActiveSlot.SLOT_POCKET, false)
        end
        if player:HasCollectible(CollectibleType.COLLECTIBLE_TRANSCENDENCE, false) == false then
            HiddenItemManager:Add(player,CollectibleType.COLLECTIBLE_TRANSCENDENCE,-1,1,"TOLOMON_PASSIVE")
            Tolomon:setBlindfold(player,true,false)
        end
        --
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
            --grid damaging failsafe
            local grids = TSIL.GridEntities.GetGridEntities()
            for i=1, #grids do
                local grid = grids[i]
                if (grid.Position - player.Position):Length() < 60 then
                    --print("break that grid")
                    if player.FrameCount % 4 == 0 then
                        grid:Hurt(1)
                    end
                    
                end
            end
            --fireplace
            local roomEntities = Isaac.GetRoomEntities() -- table
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                --
                if entity.Type == EntityType.ENTITY_FIREPLACE and (entity.Position - player.Position):Length() < 60 then
                    if entity.Variant < 3 then
                        --print("the goddamn fire")
                        --local fireplacekiller = Isaac.Spawn(2,0,0,entity.Position,Vector.Zero,player):ToTear()
                        entity:TakeDamage(0.1, 0, EntityRef(player), 0)
                    end
                    --print("break that grid")
                    
                end
            end
            
        end

        if EID then
            if data.didTheEIDForTolomon == nil then
                local lesserKeyEIDTable = {
                    --variant, subtype, name, desc
        
                    --fiend hearts: half 1025.0, full 1024.0, blended 1026.0
                    --morbid hearts: full 1028.0, 2/3rds 1029.0, 1/3rd 1030.0
                    {10, 2, "Half Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Hearts add maximum health to created homunculi."},
                    {10, 1, "Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Hearts add maximum health to created homunculi."},
                    {10, 5, "Double Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Hearts add maximum health to created homunculi."},
                    {10, 3, "Soul Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Soul Hearts make homunculi recover from being killed more quickly."},
                    {10, 4, "Eternal Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Eternal Hearts give homunculi passive health regeneration, as well as making them leave a martyr ghost on death. #{{Warning}} The stats from this are applied to all present homunculi if you are inside the ghost's radius."},
                    {10, 8, "Soul Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Soul Hearts make homunculi recover from being killed more quickly."},
                    {10, 6, "Black Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Black Hearts provide an additive damage multiplier to the base damage of a homunculus."},
                    {10, 7, "Gold Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Gold Hearts make homunculi drop coins upon being damaged, and multiple coins on death! #(Also Midas freezes enemies around it on death.)"},
                    {10, 10, "Soul Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Hearts add maximum health to created homunculi. #Soul Hearts make homunculi recover from being killed more quickly. #Blended hearts are treated as half a Heart and half a Soul Heart."},
                    {10, 11, "Bone Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Bone Hearts make enemies killed by a homunculus drop Bone Spurs, and makes a homunculus drop Bone Orbitals on death, as well as granting a chance to fire tears with the effect of {{Collectible".. Isaac.GetItemIdByName("Compound Fracture") .. "}} Compound Fracture."},
                    {10, 12, "Rotten Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Rotten Hearts grant a chance for a homunculus to spawn blue flies, spiders, or ants upon killing an enemy, and make a homunculus explode into locusts and fleas on death."},
                    {1025, 0, "Half Immoral Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Immoral Hearts make homunculi drop Hollow Minions upon taking any form of damage, as well as spawning multiple on death."},
                    {1024, 0, "Immoral Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Immoral Hearts make homunculi drop Hollow Minions upon taking any form of damage, as well as spawning multiple on death."},
                    {1026, 0, "Blended Immoral Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Hearts add maximum health to created homunculi. #Immoral Hearts make homunculi drop Hollow Minions upon taking any form of damage, as well as spawning multiple on death. #Blended Immoral Hearts count as a Half Heart and a Half Immoral Heart."},
                    {1028, 0, "Morbid Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Morbid Hearts grant a chance for enemies killed by homunculi to spawn Morbid Chunks, the same type as when a Morbid Heart is fully depleted."},
                    {1029, 0, "Morbid Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Morbid Hearts grant a chance for enemies killed by homunculi to spawn Morbid Chunks, the same type as when a Morbid Heart is fully depleted."},
                    {1030, 0, "Morbid Heart", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Morbid Hearts grant a chance for enemies killed by homunculi to spawn Morbid Chunks, the same type as when a Morbid Heart is fully depleted."},
        
        
                    --Plain coins: penny 20.1, double 20.4, nickel 20.2, dime 20.3, sticky nickel 20.6
                        --lucky coins: lucky penny 20.5
                        --golden coins: golden penny 20.7
                        --cursed pennies: normal 20.213, golden 20.216
                        --haunted penny: 20.214
                        --honey penny: 20.215
                        --lego stud: 20.217
                    {20, 1, "Penny", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 2, "Nickel", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Nickels are counted as 5 Pennies. #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 2, "Dime", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Dimes are counted as 10 Pennies. #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 4, "Double Penny", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Double Pennies are counted as 2 Pennies. #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 5, "Lucky Penny", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Lucky Pennies make chance-based homunculi effect happen more often, and also count as a Penny. #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 6, "Sticky Nickel", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Nickels are counted as 5 Pennies. #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 7, "Golden Penny", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Golden Pennies are counted as 20 Pennies! #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 213, "Cursed Penny", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Cursed Pennies can count as anywhere from -3 to 3 Pennies, as well as giving homunculi a chance to spawn Hollow Minions upon damaging an enemy. #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 216, "Golden Cursed Penny", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Golden Cursed Pennies can count as anywhere from 0 to 45 pennies, as well as anywhere from 0 to 5 Cursed Pennies (for the purpose of giving homunculi a chance to spawn Hollow Minions upon damaging an enemy)! #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 214, "Haunted Penny", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} #Haunted Pennies grant a chance for homunculi to spawn a Purgatory ghost upon killing an enemy, as well as counting as 1 Penny. #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
                    {20, 215, "Honey Penny", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Honey Pennies aren't done yet lol"},
                    {20, 217, "Lego Stud", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Lego Studs grant nonfatal contact damage to homunculi, the strength of which is based on player damage, as well as counting as a Penny. #Pennies grant a small chance for an enemy to drop pickups on death. #For every 15 cents' worth of coins, a homunculus gains an extra tear fired upon attacking."},
        
        
        
        
        
                    {30, 1, "Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Keys hasten the fire rate of a homunculus."},
                    {30, 2, "Golden Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Golden Keys double the fire rate of a homunculus, after accounting for the fire rate improvement granted by other Keys!"},
                    {30, 3, "Key Ring", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Key Rings count as 2 Keys. #Keys hasten the fire rate of a homunculus."},
                    {30, 4, "Charged Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Charged Keys make homunculi occasional strike nearby enemies with chain lighting, the damage of which scales with its damage as well as your own. #Charged Keys also count as 1 Key. #Keys hasten the fire rate of a homunculus."},
                    {30, 179, "Spicy Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Spicy Keys cause a homunculus to occasionally set enemies near it on fire. #Spicy Keys also count as 2 Keys. #Keys hasten the fire rate of a homunculus."},
                    {30, 185, "Spicy Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Spicy Keys cause a homunculus to occasionally set enemies near it on fire. #Spicy Keys also count as 2 Keys. #Keys hasten the fire rate of a homunculus."},
                    {30, 180, "Super Spicy Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Spicy Keys cause a homunculus to occasionally set enemies near it on fire. #Super Spicy Keys also count as 3 Keys. #Keys hasten the fire rate of a homunculus."},
                    {30, 182, "Super Spicy Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Spicy Keys cause a homunculus to occasionally set enemies near it on fire. #Super Spicy Keys also count as 3 Keys. #Keys hasten the fire rate of a homunculus."},
                    {30, 186, "Super Spicy Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Spicy Keys cause a homunculus to occasionally set enemies near it on fire. #Super Spicy Keys also count as 3 Keys. #Keys hasten the fire rate of a homunculus."},
                    {30, 183, "Charged Spicy Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Spicy Keys cause a homunculus to occasionally set enemies near it on fire. #Charged Keys make homunculi occasional strike nearby enemies with chain lighting, the damage of which scales with its damage as well as your own. #Charged Spicy Keys count as Charged Keys, Spicy Keys, and Keys. #Keys hasten the fire rate of a homunculus."},
                    {30, 181, "Charged Spicy Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Spicy Keys cause a homunculus to occasionally set enemies near it on fire. #Charged Keys make homunculi occasional strike nearby enemies with chain lighting, the damage of which scales with its damage as well as your own. #Charged Spicy Keys count as Charged Keys, Spicy Keys, and Keys. #Keys hasten the fire rate of a homunculus."},
                    {30, 187, "Charged Spicy Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Spicy Keys cause a homunculus to occasionally set enemies near it on fire. #Charged Keys make homunculi occasional strike nearby enemies with chain lighting, the damage of which scales with its damage as well as your own. #Charged Spicy Keys count as Charged Keys, Spicy Keys, and Keys. #Keys hasten the fire rate of a homunculus."},
                    {30, 184, "Super Duper Spicy Key", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Spicy Keys cause a homunculus to occasionally set enemies near it on fire. #Super Duper Spicy Keys also count as 4 Keys. #Keys hasten the fire rate of a homunculus."},
        
                    --Bombs
                        --plain: single 40.1, double 40.2, 
                        --troll: single 40.3, megatroll 40.5
                        --golden: single 40.4, 
                        --giga: single 40.7
                        --copper: single 40.923, double 40.924, blended 40.925
                    {40, 1, "Bomb", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Bombs buff the damage of a homunculus."},
                    {40, 2, "Double Bomb", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Double Bombs count as 2 Bombs. #Bombs buff the damage of a homunculus."},
                    {40, 4, "Golden Bomb", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Gold Bombs double the damage of a homunculus!"},
                    {40, 7, "Giga Bomb", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Giga Bombs aren't done yet lol"},
                    {40, 923, "Copper Bomb", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Copper Bombs make a homunculus' damage value vary in a range. #Exactly half of this range is higher than base damage, and the other half is lower."},
                    {40, 924, "Double Copper Bomb", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Double Copper Bombs count as 2 Copper Bombs. Copper Bombs make a homunculus' damage value vary in a range. #Exactly half of this range is higher than base damage, and the other half is lower."},
                    {40, 925, "Mixed Double Bomb", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Mixed Double Bombs count as 1 Bomb and 1 Copper Bomb. #Bombs buff the damage of a homunculus. #Copper Bombs make a homunculus' damage value vary in a range. #Exactly half of this range is higher than base damage, and the other half is lower."},
                      --Batteries
                          --90.1 normal
                          --90.2 micro
                          --90.3 mega
                          --90.4 golden
                          --900 0 firework
                          --901 0 virtuous
                          --902 0 potato
                          --903 0 cursed
                     {90, 1, "Battery", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Batteries provide a large multiplicative bonus to a homunculus' damage, fire rate, and movement speed!"},
                     {90, 2, "Micro Battery", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Micro Batteries count as half of a Battery. #Batteries provide a large multiplicative bonus to a homunculus' damage, fire rate, and movement speed!"},
                     {90, 3, "Mega Battery", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Mega Batteries count as 2 Batteries! #Batteries provide a large multiplicative bonus to a homunculus' damage, fire rate, and movement speed!"},
                     {90, 4, "Golden Battery", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Golden Batteries count as 4 entire batteries! #Batteries provide a large multiplicative bonus to a homunculus' damage, fire rate, and movement speed! #{{Warning}} {{ColorGrey}}...Golden Batteries have a detrimental side effect to your homunculus' recovery time...{{ColorReset}}"},
                     {900, 0, "Firework Battery", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Firework Batteries count as a Battery, but also grant a homunculus the ability to occasionally fire a homing firework rocket! #Batteries provide a large multiplicative bonus to a homunculus' damage, fire rate, and movement speed!"},
                     {901, 0, "Virtuous Battery", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Firework Batteries count as a Battery, but also make enemies killed by the homunculus have a chance to spawn a random {{Collectible".. CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES .. "}} Book Of Virtues wisp! #Batteries provide a large multiplicative bonus to a homunculus' damage, fire rate, and movement speed!"},
                     {902, 0, "Potato Battery", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} ...Potato Batteries count as one quarter of a single Battery. #Batteries provide a large multiplicative bonus to a homunculus' damage, fire rate, and movement speed!"},
                     {903, 0, "Cursed Battery", "{{Collectible".. BotB.Enums.Items.CLAY_SOLDIER .. "}} Cursed Batteries can count as anywhere from just one quarter of a battery to 2 whole batteries, in addition to making enemies they kill discharge violent bursts of damaging chain lightning! #Batteries provide a large multiplicative bonus to a homunculus' damage, fire rate, and movement speed!"},



                }
                for i=1, #lesserKeyEIDTable do
                    local entry = lesserKeyEIDTable[i]
                    EID:addEntity(5, entry[1], entry[2], entry[3], entry[4])
                end
                local basicDudePickup = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,HeartSubType.HEART_HALF,Vector.Zero,Vector.Zero,player)
                player:UseActiveItem(BotB.Enums.Items.CLAY_SOLDIER, UseFlag.USE_NOANIM)
                data.didTheEIDForTolomon = true
            end
        end
        


    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Tolomon.playerUpdate, 0)

function Tolomon:onTolCache(player, cacheFlag)
	if player:GetPlayerType() == PLAYER_TOLOMON then
		if player.CanFly ~= true then
            player.CanFly = true
        end
    end
	
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Tolomon.onTolCache)


local tolFamiliarNames = {
    --actual ingame character names
    "Isaac", "Maggy", "Magdalene", "Cain", "Judas", "Eve", "Samson", "???", "Blue Baby", "Ethan", "Azazel", "Lazarus", "Eden", "Lost", "Lilith", "Keeper", "Apollyon", "Forgotten", "Bethany", "Jacob", "Esau",
    "Guppy", "Tammy", "Cricket", "Max", "Kalu", "Moxie", "Bob", 
    --modded characters
    "Rebekah", "Gappi", "Fiend", "Golem", "Icarus", "Mammon", "Deleted", "Awan", "Job", "Andromeda", "Samael", "Solomon", "Jezebel", "Bertran", "Sarah", "Dante", "Charon", "!!!",
    --devs :) and friends
    "Millie", "Crispy", "Kuba", "Gabs", "Moofy", "Hyper", "Puter", "Alter", "Emi", "Gabs", "Lalhs", "Meojo", "Mac", "Cheese", "Gunk", "Gen", "Eric", "Smelly", "One", 
    --characters from random shit
    "Brad", "Wayne", "Nowak", "Bosch", "Anton", "Hans", "Leviat", "Bimini", "Terry", "Cromslor", "Pinskidan", "Finn", "Jake", "Bronwyn", "Coconteppi", "Jerry", "Prismo", "Scarab", "GOLB", "Simon", "Betty", "Fionna", "Cake", "Griffin", "Justin", "Travis",
    "Cox", "Crendor", "Bluey", "Bingo", "Bandit", "Chilli", "Muffin", "Socks", "Orbo", "Peeb", "Doomguy", "Daisy", "Red", "Felix", "Faux", "DJ", "Cyber", "Boki", "Savant", "Lymia", "Isotope", "Analog",
    "Denji", "Dennis", "Asa", "Ashley", "Power", "Pawa", "Konata", "Kagami", "Tsukasa", "Miyuki", "Misao", "Wubbzy", "Walden", "Widget", "Omori", "Mari", "Aubrey", "Kel", "Basil", 
    "Airy", "Liam", "Plecak", "Bryce", "Hansen", "Amelia", "Euler", "Taylor", "Nolan", "Charlotte", "Stern", "Charlie", "Howling", "Texty", "Stone", "Folder", "Atom", 
    "Tara", "Strong", "Twilight", "Sparkle", "Pinkie", "Pie", "Rainbow", "Dash", "Apple", "Jack", "Bloom", "Big Mac", "Flutter", "Shy", "Rarity", "Spike", "Colin", "Puro",
    "Kiryu", "Majima", "Nishiki", "Akira", "Tetsuo", "Navidson", "Francis", "Gabby", "Zaggy", "Orpho", "Gale", "Ponytail", "Pogey", "Leverette", "Mama", "Zelle", "Your Dad", "Terence", "Pumpkin", "Kid", "Cupper", "Dup",
    "Izu", "Kamiya", "Cyl", "Burger", "Cornchip", "Benny", "Pete", "Courier", "Joshua", "Graham", "Doctor", "Gumball", "Tyrone", "Darwin", "Richard", "Penny", "Anais", "Carrie", "Watterson", "Calvin", "Hobbes", "Suzy", "Ami", "Kento", "Iyo", "Issa",
    "Mario", "Luigi", "Peach", "Wario", "Waluigi", "Toad", "Ena", "Moony", "Argemia", "Bob", "Patrick", "Rose", "Boykisser", "BK", "Burger King", "McDonalds", "Taco Bell", "The People's Republic Of China",
    "The United States Of America", "The United Kingdom", "Spain", "Ireland", "Tainwan", "Trans Rights", "Enby", "Wint", "Dril", "Kitty", "Melody", "Kuromi", "Romina", "Daniel", "Maru", "Hana",
    "Finnegan", "Dixie", "Muttais", "Jotaro", "Joseph", "Kakyoin", "Dio", "Solid", "Liquid", "Gas", "Plasma", "Bose-Einstein Condensate", "Peppino", "Noise", "Scrimmy", "Bingus", "Crungy", "Spingus",
    "Bippo", "Pelb", "Tootsy", "Spingus", "Doinkus", "Tume", "Blepp", "Lumpus Umpus", "Lorge", "Brumbus", "Luckie", "Master Chuk", "Master", "Screwball", "Fifi", "Potato", "Lord", "Margeline", "Henry the Squirrel", "Tappy",
    "Thomas", "Henry", "James", "Leyland", "Kirby", "Flaky", "Flippy", "Nutty", "Tran", "Leland", "Fat", "Friend", "Roybertito", "Mal0", "[REDACTED]", "[DATA EXPUNGED]", "[CENSORED]", "[REMOVED BY THE PEOPLE'S REPUBLIC OF CHINA]", "[TRUST ME YOU DON'T WANNA KNOW]",
    "Cyanide", "Bleach", "Hammond", "Care", "Marvin", "Paul", "Tiara", "Belle", "Lina", "Rainer", "Phillip", "Poisson", "Phil", "Fish", "Sylvie", "Veevee", "Manly", "Badass", "Hero", "Dipper", "Mabel", "Stan", "Soos", "Urist", "Cacame",
    "Q Girl", "Joppa", "Ash", "Spewer", "Golgotha", "Exodus", "Cloaca", "Niko", "Alula", "Calamus", "Plight", "Rue", "George", "Kelvin", "Madotsuki", "Poniko", "Uboa", "Skye", "Everest", "Madeline", "Celeste", "Theo",
    "Distant", "Cry", "Looks To The Moon", "Five Pebbles", "No Significant Harassment", "Survivor", "Monk", "Hunter", "Gourmand", "Rivulet", "Artificer", "Spearmaster", "Saint", "Enot", "Inv", "Sofanthiel", "Toby", "Noelle", "Kris", "Susie",
    "V1", "V2", "Minos", "Sisyphus", "Mother", "Corruptus", "Skibidirizz", "Ohiogyatt", "Help! I'm trapped in a name factory!", "Dreamy", "Bull", "Ambatu", "Omaygot", "Gachi", "Muchi", "[Roland 169 \'Ahh!\' sound]", "[Wilhelm scream]", "[Toilet flushing sound]",
    "[Shotgun cocking sound]", "[School fire alarm noises]", "[Stock baby crying sound]", "Hengus", "Grengus", "Belps", "Alpohol", "Claire", "Edgar", "Pim", "Mister", "Missus", "Mix", "Big", "Glaggle", "HELP!", "HEEEEEELP!",
    "Toyota", "Honda", "Mazda", "Bugatti", "Ford", "Subaru", "Car", "Bike", "Plane", "Scooter", "Segway", "Booster", "Ragdoll", "Prop", "Mingebag", "Chikn", "Chee", "Iscream", "Fwench Fwy", "Sody Pop", "Cofi", "Spherefriend", "Egg", "Heir",
    "Sklimpton", "Rick James", "Bitch", "Conan", "Fucknut", "Shitnuts", "Finger", "Waltuh", "Jesse", "Saul", "Jimmy", "Jerma", "Reimu", "Marisa", "Sanae", "Reisen", "Tewi", "[This space intentionally left blank.]", "[Sexual moan]", "[Painful groan]", "[Loud burp]", "[Fart sound]",
    "[Loud, abrasive white noise]", "[Car horn sound]", "[Stock crying sound]", "[Explosion]", "Horse", "Dog", "Cat", "Rabbit", "Bnuuy", "Doggo", "Pupper", "Kity", "Dogy", "Pringles", "Your Mom", "Ray", "William", "Johnson",
    "Ed", "Edd", "Eddy", "Rolf", "Johnny", "Dukey", "Uncle", "Grandpa", "Garnet", "Amethyst", "Pearl", "Ruby", "Sapphire", "Lapis", "Peridot", "Steven", "Greg",
    --random bullshit i and friends came up with
    "Gurt", "Skluntt", "Gorky", "Crungle", "Fuck", "Shit", "Piss", "Boner", --I am very mature
    "Chunt", "Bungleton", "Fugorp", "Fenchalor", "Beebis", "Chongo", "Scrunt", "Shanaenae", "Lakakos", "Foog",
    "Fergus", "Brempel", "Scrumble", "Wimphort", "Kevin", "Kebin", "FlingyDeengee", "Waoflumt", "Queamples",  "Gaben At Valve Software Dot Com",
    "[The entirety of Pulse Demon by Merzbow]", "Moist", "Brungtt", "Jungus", "Flobing", "Bitorong", "Bolainas", "Pilgor", "Buckley","Buttnick", "Wanka", "Ol Chap","Fred Fuchs", "Xavier", "Smokey","Luchetti", "DICKTONG", "ASSPLITS", "TILLBIRTH", "Friendlyvilleson",
    "Filbit", "Quartet", "Snarled", "Flossing", "Dingdong", "BABING", "ticktok", "Generic", "Placeholder", "Namenotfound", "Isaac", "David Streaks from The Popular Webcomic Full House", "E", "Dude", "The Cooler Dude",
    "The", "Postal", "I  I I  I I  L", "Ricardo", "Elver Galarga", "Sapee", "Rosamelano", 
    "Bolainas", "Pilgor", "Buckley", "Buttnick", "Wanka", "Ol Chap", "Fred Fuchs", "Xavier", "Smokey", "Flimflam", "Joe", "Cacarion", "Meaty", "SilSSSLLLLAMMER!",
}
local tolFamiliarLinks = {
    " ", "", "-", " and ", " with ", " or ", " without ", " when ", " at ", "...", " of ", " of the ", " for ", ": ", "_",  " because ", " for ", "/", " the "
}
local tolFamiliarLinksRare = {
    " when there's ", "'s face when ", " at the end of ", " out of ", " in the millenium of ",
    " think he ", " think she ", " think they ", " think xey ", ", voted ", ", abjurer of ", ", consumer of ", ", lover of ", ", buyer of ", ", secret crush of ", ", killer of ", ", little pissboy of ", ", friend of ",
    ", enemy of ", ", lover of ", ", divorced wife of ", ", divorced husband of ", ", divorced spouse of ", ", wife of ", ", husbando of ", ", waifu of ", ", who kins ", ", creator of ", ", progenitor of ", ", responsible for ",
    ", heir to ", ", bitch, ", ", motherfucker, "
}
local tolFamiliarPrefixes = {
    "Master ", "Mistress ", "Mr. ", "Mrs. ", "Ms. ", "Mx. ", "God-tier ", "Pretty Good ", "Decent ", "Kinda Shitty ", "Horrible ", "Proto-", "Neo-", "Macro-", "Micro-", "Anarcho-", "Dr. ", "Messrs. ", "Sir ", "Madam ", "Noble ", "Lady ", "Lord ", "Duke ", "Duchess ",
    "Prince ", "Princess ", "Queen ", "King ", "His Majesty ", "Her Majesty ", "Their Majesty, ", "Xir Majesty ", "His Excellency ", "Her Excellency ", "Their Excellency, ", "Xir Excellency ", "Professor ", "Chancellor ", "Vice Chancellor ", 
    "His Holiness ", "Her Holiness ", "Their Holiness, ", "Xir Holiness ", "His Eminence ", "Her Eminence ", "Their Eminence, ", "Xir Eminence ", "The Ultimate ", "The Final ", "The Real ", "The Last ", "The First ", "The Second ", "The First Coming of ", "The Second Coming of ",
    "Principal ", "Dean ", "Warden ", "Rector ", "Director ", "Provost ", "Chief Executive ", "Father ", "Mother ", "Sister ", "Brother ", "Elder ", "Reverend ", "Priest ", "Priestess ", "High ", "Low ", "Venerable ",
    "Judicio-", "Supreme Court Justice ", "Good Friend ", "Best Friend ", "Worst Friend ", "President ", "Prime Minister ", "Dictator ", "Senator ", "Congress Representative ", "Real ", "Psycho-", "Vino-", "Mega-", "Nano-", "Sykoh-", "Mc",
    "The ", "Super ", "Ultra ", "Mega ", "Mini ", "Tera ", "It's ", "That's ", "It's a ", "A ", "This ", "That ", "Fat ", "Big ", "Huge ", "Cream of ",
}
local tolFamiliarSuffixes = {
    "son", "erson", "kin", "daughter", "dottir", "kind", "kid", "pup", "kit", "star", "leaf", "stripe", "claw", "butt", "snoot", ", Esq.", ", M.D.", ", PhD", ", E.D.", "-san", "-tan", "-kun", "-chan", "-sama", "-sensei",
    "-senpai", "-hakase", "-heika", "-kakka", "-denka", "-domo", "-khan", "mancy", "mancer", "bender", "killer", "lover", "kisser", "drinker", "eater", "hater", "master", "fucker", "god", "shitter", "pisser", "nut", "sucker",", bitch!",
    "ford", "ley", "ing", "ington", "ingford", "ingley", "fart", "fuck", "...?",
}
--Oh Boy!
function Tolomon:generateRandomHomunculusEID(npc)
    local data = npc:GetData()
    --Format is based on number of total pickups collected

    --name, name+suffix, prefix+name, prefix+name+suffix, namename, 
    --link (stuff like " of ", " the ", )

    --Get total number of pickups
    local amtPickups = 0
    for k,v in pairs(data.pickupTable) do
        if v ~= 0 then
            amtPickups = amtPickups + v
        end
    end
    print("total of " .. amtPickups)
    local nameComplexity = ((amtPickups - (amtPickups % 5))/5) + 1
    if math.random(0,3) == 0 then
        nameComplexity = nameComplexity * math.random(1,5)
    end
    local nameStr = ""
    for i=1, nameComplexity do
        --Prefix
        if nameComplexity > 1 then
            if math.random(0,1) == 0 then
                local amtPrefixes = math.random(1,3)
                for j=0, amtPrefixes do
                    nameStr = nameStr .. tolFamiliarPrefixes[math.random(1,#tolFamiliarPrefixes)]
                end
            end
        end
        
        --Name
        if math.random(0,3) == 0 and nameComplexity > 2 then
            --Multi-name
            local amtNames = math.random(1,3)
            for j=0, amtNames do
                nameStr = nameStr .. tolFamiliarNames[math.random(1,#tolFamiliarNames)]
            end
        else
            --Single name
            nameStr = nameStr .. tolFamiliarNames[math.random(1,#tolFamiliarNames)]
        end
        --Suffix
        if math.random(0,1) == 0 and nameComplexity > 1 then
            local amtSuffixes = math.random(1,3)
            for j=0, amtSuffixes do
                nameStr = nameStr .. tolFamiliarSuffixes[math.random(1,#tolFamiliarSuffixes)]
            end
        end

        --Link
        if nameComplexity - i > 0 then
            if math.random(0,3) == 0 then
                --Rare link
                nameStr = nameStr .. tolFamiliarLinksRare[math.random(1,#tolFamiliarLinksRare)]
            else
                --link
                nameStr = nameStr .. tolFamiliarLinks[math.random(1,#tolFamiliarLinks)]
            end
        end
        
    end 
    local descStr = ""
    if data.pickupTable ~= nil then
        for k,v  in pairs(data.pickupTable) do
            if v ~= 0 then
                descStr = descStr .. "Has ".. v .." of type " .. k .."#"
                --print(k,v)
            end
        end
    end
    local homunculusEIDTable = {nameStr, descStr}

    return homunculusEIDTable
end


function Tolomon:nameGenCMD(cmd, params)
    if not cmd == "genTolName" then return end
    if cmd == "genTolName" then
        
        --local amtPickups = math.random(1,10)
    local nameComplexity = 1
    if math.random(0,3) == 0 then
        nameComplexity = nameComplexity * math.random(1,5)
    end
    local nameStr = ""
    --local nameComplexity = ((amtPickups - (amtPickups % 8))/8)
    if nameComplexity <= 0 then
        nameComplexity = 1
    end
    if math.random(0,1) == 0 then
        nameComplexity = math.ceil(nameComplexity * (1+((math.random(0,4)/4)-0.5)))
    end
    local nameStr = ""
    for i=1, nameComplexity do
        --Prefix
        if nameComplexity >= 1 then
            if math.random(0,1) == 0 then
                local amtPrefixes = math.random(0,nameComplexity)
                if amtPrefixes ~= 0 then
                    for j=0, amtPrefixes do
                        nameStr = nameStr .. tolFamiliarPrefixes[math.random(1,#tolFamiliarPrefixes)]
                    end
                end
            end
        end
        
        --Name
        if math.random(0,3) == 0 and nameComplexity > 2 then
            --Multi-name
            local amtNames = math.random(1,math.ceil(nameComplexity*1.25))
            for j=0, amtNames do
                nameStr = nameStr .. tolFamiliarNames[math.random(1,#tolFamiliarNames)]
            end
        else
            --Single name
            nameStr = nameStr .. tolFamiliarNames[math.random(1,#tolFamiliarNames)]
        end
        --Suffix
        if math.random(0,1) == 0 and nameComplexity >= 1 then
            local amtSuffixes = math.random(0,nameComplexity)
            if amtSuffixes ~= 0 then
                for j=0, amtSuffixes do
                    nameStr = nameStr .. tolFamiliarSuffixes[math.random(1,#tolFamiliarSuffixes)]
                end
            end
        end

        --Link
        if nameComplexity - i > 0 then
            
            if math.random(0,3) == 0 then
                --Rare link
                nameStr = nameStr .. tolFamiliarLinksRare[math.random(1,#tolFamiliarLinksRare)]
            else
                --link
                nameStr = nameStr .. tolFamiliarLinks[math.random(1,#tolFamiliarLinks)]
            end
        end
        
    end 
    print(nameStr)

    end
    
    
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, Tolomon.nameGenCMD)