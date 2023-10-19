local Mod = BotB
local COIN_OF_JUDGEMENT = {}
local Entities = BotB.Enums.Entities
local Items = BotB.Enums.Items
local hiddenItemManager = require("scripts.core.hidden_item_manager")

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Coin of Judgement"), "Upon one of many possible triggering events (i.e. new rooms, opening chests, et cetera), there is a 50% chance to flip a coin. #Depending on the outcome of a flip, you will gain one of many positive or negative outcomes relevant to the event that occured. #For example: #{{TreasureRoom}} {{ArrowUp}} Spawn a {{RestockMachine}} Restock Machine, or a Glass D6. #{{TreasureRoom}} {{ArrowDown}} Spawn 2 Bulbs, or forcibly reroll the items in the room on a countdown shown above the player's head. #...And many more for many other room types.")
end

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

function COIN_OF_JUDGEMENT:newRoomCheck()
    --print("balls")
    local room = Game():GetRoom()
    local doTheyActuallyHaveThem = false
	local players = getPlayers()
    local roomDescriptor = Game():GetLevel():GetCurrentRoomDesc()
    if roomDescriptor.VisitedCount == 1 and room:GetType() ~= RoomType.ROOM_DEFAULT and not (room:GetType() == RoomType.ROOM_BOSS and room:IsClear() == true) then
        for i=1,#players,1 do
            if players[i]:ToPlayer():HasCollectible(Isaac.GetItemIdByName("Coin of Judgement")) then
                if math.random(0,1) == 1 then
                    local coin = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.COIN_OF_JUDGEMENT.VARIANT,0,players[i].Position,Vector.Zero,players[i]):ToEffect()
                    coin.Parent = players[i]
                    coin.RenderZOffset = 99999
                    coin:GetData().botbCOJType = "newRoom"
                    SFXManager():Play(BotB.Enums.SFX.FAH_COIN_FLIP,1.5,0,false,1.0)
                end
                doTheyActuallyHaveThem = true
            end
            if players[i]:ToPlayer():GetData().botbHasPoundWhileInShops == true then
                --hiddenItemManager:AddForRoom(player,CollectibleType.COLLECTIBLE_POUND_OF_FLESH,-1,1,nil)
                if room:GetType() == RoomType.ROOM_DEVIL then
                    hiddenItemManager:RemoveAll(players[i]:ToPlayer(),"poundInShops")
                else
                    hiddenItemManager:AddForRoom(players[i]:ToPlayer(),CollectibleType.COLLECTIBLE_POUND_OF_FLESH,-1,1,"poundInShops")
                end
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,COIN_OF_JUDGEMENT.newRoomCheck)

function COIN_OF_JUDGEMENT:coinFlipEffect(effect)
    local room = Game():GetRoom()
    local sprite = effect:GetSprite()
    local data = effect:GetData()
    if effect.Parent ~= nil then
        effect.Position = Vector(effect.Parent.Position.X, effect.Parent.Position.Y-(effect.SpriteScale.Y * 80))
    end
    if effect.FrameCount == 2 then
        data.botbCoinStopSpinningFrame = math.random(32,64)
    end
    if data.botbCoinStopSpinningFrame ~= nil and effect.FrameCount == data.botbCoinStopSpinningFrame then
        if math.random(0,1) == 0 then
            sprite:Play("Heads")
            if effect.Parent ~= nil then
                effect.Parent:GetData().botbCoinOfJudgementState = "heads"
                effect.Parent:GetData().botbCoinOfJudgementType = effect:GetData().botbCOJType
            end
        else
            sprite:Play("Tails")
            if effect.Parent ~= nil then
                effect.Parent:GetData().botbCoinOfJudgementState = "tails"
                effect.Parent:GetData().botbCoinOfJudgementType = effect:GetData().botbCOJType
            end
        end
        SFXManager():Play(BotB.Enums.SFX.FAH_COIN_LAND,1.5,0,false,1.0)
    end
    if sprite:IsFinished("Heads") or sprite:IsFinished("Tails") then
        effect:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,COIN_OF_JUDGEMENT.coinFlipEffect, Isaac.GetEntityVariantByName("Coin Of Judgement"))

function COIN_OF_JUDGEMENT:playerUpdate(player)
    local data = player:GetData()
    if player:HasCollectible(Isaac.GetItemIdByName("Coin of Judgement")) then 
        if data.botbCoinOfJudgementState == "heads" then
            player:AnimateHappy()
            COIN_OF_JUDGEMENT:doPositiveCOJEffect(data.botbCoinOfJudgementType,player)
            data.botbCoinOfJudgementType = "none"
            data.botbCoinOfJudgementState = "none"
        elseif data.botbCoinOfJudgementState == "tails" then
            player:AnimateSad()
            COIN_OF_JUDGEMENT:doNegativeCOJEffect(data.botbCoinOfJudgementType,player)
            data.botbCoinOfJudgementType = "none"
            data.botbCoinOfJudgementState = "none"
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, COIN_OF_JUDGEMENT.playerUpdate, 0)



--do a positive Coin Of Judgement effect of type [string "type"]
function COIN_OF_JUDGEMENT:doPositiveCOJEffect(type, player)
    print("yaaay")
    if type == "newRoom" then
        local room = Game():GetRoom()
        --treasure: spawn a restock machine, or some glass dice
        if room:GetType() == RoomType.ROOM_TREASURE then
            if math.random(0,1) == 0 then
                --restock
                Isaac.Spawn(EntityType.ENTITY_SLOT,Isaac.GetEntityVariantByName("Shop Restock Machine"),0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,Isaac.GetCardIdByName("Glass D6"),room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
            end
        end
        --curse: free fool card, a black heart or immoral heart or two
        if room:GetType() == RoomType.ROOM_CURSE then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,Card.CARD_FOOL,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
        end
        --arcade: spawns a slot machine and a nickel
        if room:GetType() == RoomType.ROOM_ARCADE then
            --machine types:
            --slot, crane game, golden slot, poker table, glitch slot
            local slotTypesToSpawn = {
                Isaac.GetEntityVariantByName("Slot Machine"),
                Isaac.GetEntityVariantByName("Crane Game"),
                Isaac.GetEntityVariantByName("Golden Slot Machine"),
                Isaac.GetEntityVariantByName("Poker Table"),
            }
            if Epiphany then
                slotTypesToSpawn[#slotTypesToSpawn+1] = Isaac.GetEntityVariantByName("Dice Machine")
                slotTypesToSpawn[#slotTypesToSpawn+1] = Isaac.GetEntityVariantByName("Glitch Slot")
            end
            Isaac.Spawn(EntityType.ENTITY_SLOT,slotTypesToSpawn[math.random(1,#slotTypesToSpawn)],0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,CoinSubType.COIN_NICKEL,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
        end
        --boss: halves the boss's health
        if room:GetType() == RoomType.ROOM_BOSS then
            local roomEntities = Isaac.GetRoomEntities() -- table
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                if entity:IsVulnerableEnemy() and entity:IsBoss() and EntityRef(entity).IsFriendly ~= true then
                    entity:TakeDamage((entity.MaxHitPoints/2), DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 0)
                end
            end
            
        end
        --shop: spawns store credit or gives you Steam Sale
        if room:GetType() == RoomType.ROOM_SHOP then
            
            if math.random(0,1) == 0 then
                hiddenItemManager:AddForRoom(player,CollectibleType.COLLECTIBLE_STEAM_SALE,-1,1,nil)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,TrinketType.TRINKET_STORE_CREDIT,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
            end
        end

        --sacrifice: free blood bag
        if room:GetType() == RoomType.ROOM_SACRIFICE then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,666,0,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
        end
        --secret exit: pays back the entry fee
        if room:GetType() == RoomType.ROOM_SECRET_EXIT then
            if Game():GetLevel():GetStage() == LevelStage.STAGE1_1 or Game():GetLevel():GetStage() == LevelStage.STAGE1_2 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,KeySubType.KEY_NORMAL,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
            end
            if Game():GetLevel():GetStage() == LevelStage.STAGE2_1 or Game():GetLevel():GetStage() == LevelStage.STAGE2_2 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,BombSubType.BOMB_DOUBLEPACK,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
            end
            if Game():GetLevel():GetStage() == LevelStage.STAGE3_1 or Game():GetLevel():GetStage() == LevelStage.STAGE3_2 then
                player:UsePill(PillEffect.PILLEFFECT_FULL_HEALTH, PillColor.PILL_NULL+PillColor.PILL_COLOR_MASK, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
                player:UsePill(PillEffect.PILLEFFECT_FULL_HEALTH, PillColor.PILL_NULL+PillColor.PILL_COLOR_MASK, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
            end
            
        end

        --secret/super secret: spawns an item pedestal or reverse moon (rare)
        if room:GetType() == RoomType.ROOM_SECRET or room:GetType() == RoomType.ROOM_SUPERSECRET then
            if math.random(0,4) == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,Card.CARD_REVERSE_MOON,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,npc)
            end
        end

        --library: extra pedestal item
        if room:GetType() == RoomType.ROOM_LIBRARY then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,npc)
        end

        --clean bedroom: crawlspace!! or just a bomb.
        if room:GetType() == RoomType.ROOM_ISAACS then
            if math.random(0,3) == 0 then
                player:UseCard(Card.CARD_REVERSE_WORLD, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,BombSubType.BOMB_NORMAL,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
            end
            
        end

        --dirty bedroom: crawlspace!! or just a bomb.
        if room:GetType() == RoomType.ROOM_BARREN then
            if math.random(0,3) == 0 then
                player:UseCard(Card.CARD_REVERSE_WORLD, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,BombSubType.BOMB_NORMAL,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
            end
        end

        --challenge/boss challenge: strength card, or all stats up
        if room:GetType() == RoomType.ROOM_CHALLENGE then
            if math.random(0,1) == 1 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,Card.CARD_STRENGTH,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
            else
                hiddenItemManager:AddForRoom(player,CollectibleType.COLLECTIBLE_SAUSAGE,-1,1,nil)
            end
        end

        --vault: doubles pickups (diplopia)
        if room:GetType() == RoomType.ROOM_CHEST then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_DIPLOPIA, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
        end

        --ultra secret: extra item and queen of hearts
        if room:GetType() == RoomType.ROOM_ULTRASECRET then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
            player:UseCard(Card.CARD_QUEEN_OF_HEARTS, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
        end
        --devil: uses 2 health ups, converts red chests and devil beggars to shop items
        if room:GetType() == RoomType.ROOM_DEVIL then
            player:UsePill(PillEffect.PILLEFFECT_HEALTH_UP, PillColor.PILL_NULL+PillColor.PILL_COLOR_MASK, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
            player:UsePill(PillEffect.PILLEFFECT_HEALTH_UP, PillColor.PILL_NULL+PillColor.PILL_COLOR_MASK, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)

            local roomEntities = Isaac.GetRoomEntities() -- table
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                print(entity.Type, entity.Variant, entity.SubType)
                if (entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_REDCHEST) or (entity.Type == EntityType.ENTITY_SLOT and entity.Variant == 5) then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_SHOPITEM,0,entity.Position,Vector.Zero,player)
                    entity:Remove()
                end
            end

        end

        --angel: fuck it, get ALL the pedestals
        if room:GetType() == RoomType.ROOM_DEVIL then
            player:UsePill(PillEffect.PILLEFFECT_HEALTH_UP, PillColor.PILL_NULL+PillColor.PILL_COLOR_MASK, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
            player:UsePill(PillEffect.PILLEFFECT_HEALTH_UP, PillColor.PILL_NULL+PillColor.PILL_COLOR_MASK, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
            local roomEntities = Isaac.GetRoomEntities() -- table
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                print(entity.Type, entity.Variant, entity.SubType)
                if (entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE) then
                    entity:ToPickup().OptionsPickupIndex = 0
                end
            end
        end


    end
end






--do a negative Coin Of Judgement effect of type [string "type"]
function COIN_OF_JUDGEMENT:doNegativeCOJEffect(type, player)
    print("fuck")
    if type == "newRoom" then
        local room = Game():GetRoom()
        --treasure: does a 5 second countdown before blowing up a restock machine, or spawns 2 Bulbs :^)
        if room:GetType() == RoomType.ROOM_TREASURE then
            if math.random(0,1) == 1 then
                local restock = Isaac.Spawn(EntityType.ENTITY_SLOT,Isaac.GetEntityVariantByName("Shop Restock Machine"),0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
                for i = 1, 300 do
                    if room:GetType() == RoomType.ROOM_TREASURE then
                        if i % 30 == 0 then
                            SFXManager():Play(SoundEffect.SOUND_BEEP,3,0,false,0.8)
                        end
                        
                        local str = "" .. (9 - (i-i%30)/30)
                        
                        local AbacusFont = Font()
                        AbacusFont:Load("font/pftempestasevencondensed.fnt")
                        BotB.FF.scheduleForUpdate(function()
                            local pos = game:GetRoom():WorldToScreenPosition(player.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(player.SpriteScale.Y * 35) - i/2)
                            local opacity
                            if i >= 150 then
                                opacity = 1
                            else
                                opacity = i/150
                            end
                            
                            if i==300 then
                                Game():BombExplosionEffects(restock.Position, 1, TearFlags.TEAR_NORMAL, Color(1,1,1,1), player, 0.5, false, false, DamageFlag.DAMAGE_EXPLOSION)
                            else
                                AbacusFont:DrawString(str .. "...", pos.X, pos.Y, KColor(1,0,0,opacity), 0, false)
                            end
                        end, i, ModCallbacks.MC_POST_RENDER)

                    end
                end

                
                
            else
                Isaac.Spawn(EntityType.ENTITY_SUCKER,5,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
                Isaac.Spawn(EntityType.ENTITY_SUCKER,5,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
            end
        end
        --curse: spawns a Imp (enemy)
        if room:GetType() == RoomType.ROOM_CURSE then
            Isaac.Spawn(EntityType.ENTITY_IMP,0,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
        end
        --arcades: blows up all the machines
        if room:GetType() == RoomType.ROOM_ARCADE then
            local roomEntities = Isaac.GetRoomEntities() -- table
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                if entity.Type == EntityType.ENTITY_SLOT then
                    for i = 1, 120 do
                        if room:GetType() == RoomType.ROOM_TREASURE then
                            if i % 12 == 0 then
                                SFXManager():Play(SoundEffect.SOUND_BEEP,3,0,false,0.8)
                            end
                            
                            local str = "" .. (11 - (i-i%12)/12)
                            
                            local AbacusFont = Font()
                            AbacusFont:Load("font/pftempestasevencondensed.fnt")
                            BotB.FF.scheduleForUpdate(function()
                                local pos = game:GetRoom():WorldToScreenPosition(player.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(player.SpriteScale.Y * 35) - i/2)
                                local opacity
                                if i >= 30 then
                                    opacity = 1
                                else
                                    opacity = i/30
                                end
                                AbacusFont:DrawString(str .. "...", pos.X, pos.Y, KColor(1,0,0,opacity), 0, false)
                                if i==120 then
                                    Game():BombExplosionEffects(entity.Position, 1, TearFlags.TEAR_NORMAL, Color(1,1,1,1), player, 0.5, false, false, DamageFlag.DAMAGE_EXPLOSION)
                                end
                            end, i, ModCallbacks.MC_POST_RENDER)
    
                        end
                    end
                end
            end
        end
        --boss: vanishing twin effect
        if room:GetType() == RoomType.ROOM_BOSS then
            --SpawnBoss(EntityTypeentityType, integer variant, integer subType,Vectorposition,Vector? velocity, Entity? spawner, integer | RNG? seedOrRNG?, integer? numSegments)
            local roomEntities = Isaac.GetRoomEntities() -- table
            local didTheBossCopy = false
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                if entity:IsVulnerableEnemy() and entity:IsBoss() and EntityRef(entity).IsFriendly ~= true and didTheBossCopy ~= true then
                    local extraBoss = TSIL.Bosses.SpawnBoss(entity.Type, entity.Variant, entity.SubType,entity.Position,Vector.Zero):ToNPC()
                    --extraBoss.MaxHitPoints = extraBoss.MaxHitPoints / 2
                    --extraBoss.HitPoints = extraBoss.MaxHitPoints
                    extraBoss:GetData().botbDropCOJCollectibleOnDeath = true
                    didTheBossCopy = true
                end
            end
        end
        --shop: spikes around pickups?
        if room:GetType() == RoomType.ROOM_SHOP then
            if math.random(0,1) == 0 then
                player:GetData().botbHasPoundWhileInShops = true
                hiddenItemManager:AddForRoom(player:ToPlayer(),CollectibleType.COLLECTIBLE_POUND_OF_FLESH,-1,1,"poundInShops")
                Isaac.ExecuteCommand("restock")
            else
                if math.random(0,4) == 0 then
                    TSIL.Rooms.EmptyRoom()
                    Isaac.Spawn(EntityType.ENTITY_GREED,math.random(0,1),0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,nil)
                else
                    hiddenItemManager:AddForRoom(player,CollectibleType.COLLECTIBLE_POUND_OF_FLESH,-1,1,nil)
                    Isaac.ExecuteCommand("restock")
                end
            end
            
        end

        --secret exit: spawns a funny and relevant enemy
        if room:GetType() == RoomType.ROOM_SECRET_EXIT then
            if Game():GetLevel():GetStage() == LevelStage.STAGE1_1 or Game():GetLevel():GetStage() == LevelStage.STAGE1_2 then
                Isaac.Spawn(EntityType.ENTITY_POLTY,0,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
            end
            if Game():GetLevel():GetStage() == LevelStage.STAGE2_1 or Game():GetLevel():GetStage() == LevelStage.STAGE2_2 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,BombSubType.BOMB_SUPERTROLL,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
            end
            if Game():GetLevel():GetStage() == LevelStage.STAGE3_1 or Game():GetLevel():GetStage() == LevelStage.STAGE3_2 then
                Isaac.Spawn(BotB.Enums.Entities.CURSED_POOTER.TYPE,BotB.Enums.Entities.CURSED_POOTER.VARIANT,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
            end
            
        end
        --secret room: greed fight, or ??? pill
        if room:GetType() == RoomType.ROOM_SECRET then
            if math.random(0,4) == 0 then
                TSIL.Rooms.EmptyRoom()
                Isaac.Spawn(EntityType.ENTITY_GREED,math.random(0,1),0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,nil)
            else
                player:UsePill(PillEffect.PILLEFFECT_QUESTIONMARK, PillColor.PILL_NULL+PillColor.PILL_COLOR_MASK, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
            end
        end
        --super secret: black poop or ??? pill
        if room:GetType() == RoomType.ROOM_SECRET then
            if math.random(0,4) == 0 then
                TSIL.Rooms.EmptyRoom()
                Isaac.Spawn(EntityType.ENTITY_GREED,math.random(0,1),0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,nil)
            else
                player:UsePill(PillEffect.PILLEFFECT_QUESTIONMARK, PillColor.PILL_NULL+PillColor.PILL_COLOR_MASK, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
            end
        end

        --library: curse of the blind
        if room:GetType() == RoomType.ROOM_LIBRARY then
            Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_BLIND, true)
        end

        --clean bedroom: curse of darkness
        if room:GetType() == RoomType.ROOM_ISAACS then
            Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_DARKNESS, true)
        end

        --dirty bedroom: curse of darkness
        if room:GetType() == RoomType.ROOM_BARREN then
            Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_DARKNESS, true)
        end

        --challenge/boss challenge: addicted effect, or curse of the unknown
        if room:GetType() == RoomType.ROOM_CHALLENGE then
            if math.random(0,1) == 1 then
                Game():GetLevel():AddCurse(LevelCurse.CURSE_OF_THE_UNKNOWN, true)
            else
                player:UsePill(PillEffect.PILLEFFECT_ADDICTED, PillColor.PILL_NULL, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
            end
        end

        --vault: deletes pickups, spawns a penny
        if room:GetType() == RoomType.ROOM_CHEST then
            local roomEntities = Isaac.GetRoomEntities() -- table
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                if entity:ToPickup() ~= nil then
                    entity:Remove()
                end
            end
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,CoinSubType.COIN_PENNY,room:FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
        end

        --ultra secret: curse of the lost
        if room:GetType() == RoomType.ROOM_ULTRASECRET then
            player:UsePill(PillEffect.PILLEFFECT_AMNESIA, PillColor.PILL_NULL+PillColor.PILL_COLOR_MASK, UseFlag.USE_NOANIM | UseFlag.USE_NOHUD)
        end

        --devil: replaces devil deals with red chests (lol. lmao even.)
        if room:GetType() == RoomType.ROOM_DEVIL then
            local roomEntities = Isaac.GetRoomEntities() -- table
					for i = 1, #roomEntities do
						local entity = roomEntities[i]
						print(entity.Type, entity.Variant, entity.SubType)
						if entity.Type == EntityType.ENTITY_PICKUP and (entity.Variant == PickupVariant.PICKUP_SHOPITEM or entity.Variant == PickupVariant.PICKUP_COLLECTIBLE) then
							Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_REDCHEST,0,entity.Position,Vector.Zero,player)
                            entity:Remove()
						end
					end
        end


        --angel: YOU SHOULD FIGHT GABRIEL/URIEL...NOW!
        if room:GetType() == RoomType.ROOM_ANGEL then
            TSIL.Rooms.EmptyRoom()
            if math.random(0,1) == 1 then
                Isaac.Spawn(EntityType.ENTITY_GABRIEL,0,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
            else
                Isaac.Spawn(EntityType.ENTITY_URIEL,0,0,room:FindFreePickupSpawnPosition(room:GetCenterPos(), 1, true, false),Vector.Zero,player)
            end
        end
    end
end

function COIN_OF_JUDGEMENT:NPCUpdate(npc)
    local data = npc:GetData()
    if data.botbDropCOJCollectibleOnDeath == true then 
        if npc:HasMortalDamage() and data.botbDroppedCOJCollectible == nil then
            local room = Game():GetRoom()
            data.botbDroppedCOJCollectible = true
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,0,room:FindFreePickupSpawnPosition(npc.Position, 1, true, false),Vector.Zero,npc)
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, COIN_OF_JUDGEMENT.NPCUpdate)


function COIN_OF_JUDGEMENT:undoCurseOnNewLevel()
    local players = getPlayers()
    for i=1, #getPlayers() do
        local player = players[i]:ToPlayer()
        if player:GetData().botbHasPoundWhileInShops == true then
            player:GetData().botbHasPoundWhileInShops = false
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, COIN_OF_JUDGEMENT.undoCurseOnNewLevel)