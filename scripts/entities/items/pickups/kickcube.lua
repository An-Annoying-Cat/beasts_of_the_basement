local Mod = BotB
sfx = SFXManager()
game = Game()
local KICKCUBE = {}

--Yoinking this from Fiend Folio--unbiased pickup spawns


function KICKCUBE:KickStart(pickup,collider,_)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    --print(pickup.Type .. "," .. pickup.Variant .. "," .. pickup.SubType)
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.KICKCUBE.SUBTYPE and collider.Type == Isaac.GetEntityTypeByName("Player") and data.canBeKicked == true then
        sfx:Play(SoundEffect.SOUND_THREAD_SNAP,2,0,false,math.random(80, 120)/100)
        sprite:Play("Fly")
        if data.beenKicked == false then
            data.beenKicked = true
            data.numKicks = 1
            pickup.Parent = collider
        else
            data.numKicks = data.numKicks + 1
        end
        data.kickTimer = data.kickTimerMax
        pickup.Friction = 15
        return false
    end
end

function KICKCUBE:KickCubeUpdate(pickup)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.KICKCUBE.SUBTYPE then
        if data.beenKicked == nil then
            data.beenKicked = false
            data.kickTimer = 0
            data.kickTimerMax = 60
            data.isAirborne = false
            data.offsetHeight = 0
            data.numKicks = 0
            data.rewardTier = 0
            data.rewardType = 0
            data.canBeKicked = true
        end
        --print(data.kickTimer)
        --Update sprite offset based on the formula for the correct parabola
        -- -0.05*x*(x-60)
        if data.beenKicked == true then
            if data.kickTimer ~= 0 then
                data.offsetHeight = 0.1*data.kickTimer*(data.kickTimer-60)
                --print("offset" .. data.offsetHeight)
                pickup.SpriteOffset = Vector(0,data.offsetHeight)
                data.kickTimer = data.kickTimer - 1
                if data.offsetHeight <= 5 then
                    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                else
                    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                end
            end
            if data.kickTimer % 6 == 0 and data.kickTimer ~= 0 then
                if data.numKicks < 5 then
                    sfx:Play(Mod.Enums.SFX.KICKCUBE1,1,0,false,1)
                    data.rewardTier = 1
                elseif data.numKicks < 10 then
                    sfx:Play(Mod.Enums.SFX.KICKCUBE2,1,0,false,1)
                    data.rewardTier = 2
                else
                    sfx:Play(Mod.Enums.SFX.KICKCUBE3,1,0,false,1)
                    data.rewardTier = 3
                end
                
            end
        end
        --Kick game end
        if data.kickTimer == 0 and data.beenKicked == true then
            data.canBeKicked = false
            sfx:Play(SoundEffect.SOUND_SCAMPER,2,0,false,math.random(80, 120)/100)
            print("Number of kicks: " .. data.numKicks)
            sprite:Play("Idle")
            pickup.Friction = 0.5
            pickup.SpriteOffset = Vector(0,0)
            data.beenKicked = false

            local str = data.numKicks
            local AbacusFont = Font()
            AbacusFont:Load("font/pftempestasevencondensed.fnt")
            for i = 1, 60 do
                BotB.FF.scheduleForUpdate(function()
                    local pos = game:GetRoom():WorldToScreenPosition(pickup.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(pickup.SpriteScale.Y * 35) - i/2)
                    local opacity
                    if i >= 30 then
                        opacity = 1 - ((i-30)/30)
                    else
                        opacity = i/15
                    end
                    AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(math.random(0, 2)/2,math.random(0, 2)/2,math.random(0, 2)/2,opacity), 0, false)
                end, i, ModCallbacks.MC_POST_RENDER)
            end
            --RANDOM SELECT TIME
            
            if data.rewardTier == 2 then
                --sfx:Play(BotB.FF.Sounds.CrowdCheer,2,0,false,1)
                pickup.Parent:ToPlayer():AnimateHappy()
            elseif data.rewardTier == 3 then
                sfx:Play(BotB.FF.Sounds.CrowdCheer,2,0,false,1)
                --local fireworks = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.FIREWORKS,0,pickup.Position,Vector.Zero,pickup.Parent)
                for i=0,50,1 do
                    local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ULTRA_GREED_BLING,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                end
                pickup.Parent:ToPlayer():AnimateHappy()
            end
            data.rewardType = math.random(1,8)
            --[[
            The order:
            1 - Hearts
            2 - Money
            3 - Keys
            4 - Bombs
            5 - Pills
            6 - Cards
            7 - Batteries
            8 - Trinkets
            9 - WTF
            ]]
            if data.rewardType == 9 then
                --50% chance for the WTF result to be rerolled to make it more rare
                if math.random(0,1) == 1 then
                    data.rewardType = math.random(1,8)
                end
            end
            --local rewardRepeatVariable = 1
            if data.rewardType == 1 then
                --Hearts
                sprite:Play("Hearts")
            end
            if data.rewardType == 2 then
                --Money
                sprite:Play("Coins")
            end
            if data.rewardType == 3 then
                --Keys
                sprite:Play("Keys")
            end
            if data.rewardType == 4 then
                --Bombs
                sprite:Play("Bombs")
            end
            if data.rewardType == 5 then
                --Pills
                sprite:Play("Pills")
            end
            if data.rewardType == 6 then
                --Cards
                sprite:Play("Cards")
            end
            if data.rewardType == 7 then
                --Batteries
                sprite:Play("Objects")
            end
            if data.rewardType == 8 then
                --Trinkets
                sprite:Play("Trinkets")
            end
            if data.rewardType == 9 then
                --WTF
                sprite:Play("WTF")
            end
            pickup.State = 99
        end


        if pickup.State == 99 then
            --Kill it when the animation is done
            if sprite:IsFinished(sprite:GetAnimation()) then
                pickup:Remove()
            end
            --Spawn reward at appropriate time
            if sprite:IsEventTriggered("Reward") then
                local pickupChoice
                print(data.rewardType .. " at " .. data.rewardTier)
                if data.rewardType == 1 then
                    --Hearts
                    --Reward Tier conditionals...

                    
                    --pickupChoice = Mod.unbiasedFromSuit("Hearts")
                    if data.rewardTier == 1 then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                    elseif data.rewardTier == 2 then
                        for i=0,2,1 do
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                        end
                        pickupChoice = Mod.unbiasedFromSuit("Hearts")
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,mod.CardNamePickups["Hearts"], pickupChoice, pickup.Position, Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))), pickup)
                    else
                        for i=0,3,1 do
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_HEART,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                        end
                        for i=0,4,1 do
                            pickupChoice = Mod.unbiasedFromSuit("Hearts")
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,mod.CardNamePickups["Hearts"], pickupChoice, pickup.Position, Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))), pickup)
                        end
                    end
                end
                if data.rewardType == 2 then
                    --Money
                    --pickupChoice = Mod.unbiasedFromSuit("Diamonds")
                    if data.rewardTier == 1 then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                    elseif data.rewardTier == 2 then
                        for i=0,5,1 do
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                        end
                        pickupChoice = Mod.unbiasedFromSuit("Diamonds")
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,mod.CardNamePickups["Diamonds"], pickupChoice, pickup.Position, Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))), pickup)
                    else
                        for i=0,7,1 do
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COIN,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                        end
                        for i=0,3,1 do
                            pickupChoice = Mod.unbiasedFromSuit("Diamonds")
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,mod.CardNamePickups["Diamonds"], pickupChoice, pickup.Position, Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))), pickup)
                        end
                    end
                end
                if data.rewardType == 3 then
                    --Keys
                    --print("penis")
                    if data.rewardTier == 1 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                    elseif data.rewardTier == 2 then
                        for i=0,2,1 do
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                        end
                        for i=0,2,1 do
                            pickupChoice = Mod.unbiasedFromSuit("Spades")
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,mod.CardNamePickups["Spades"], pickupChoice, pickup.Position, Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))), pickup)
                        end
                    else
                        for i=0,3,1 do
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_KEY,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                        end
                        for i=0,4,1 do
                            pickupChoice = Mod.unbiasedFromSuit("Spades")
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,mod.CardNamePickups["Spades"], pickupChoice, pickup.Position, Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))), pickup)
                        end
                    end
                end
                if data.rewardType == 4 then
                    --Bombs
                    if data.rewardTier == 1 then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                    elseif data.rewardTier == 2 then
                        for i=0,2,1 do
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                        end
                        for i=0,3,1 do
                            pickupChoice = Mod.unbiasedFromSuit("Clubs")
                            Isaac.Spawn(5, mod.CardNamePickups["Clubs"], pickupChoice, pickup.Position, Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))), Pickup)
                        end
                    else
                        for i=0,3,1 do
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_BOMB,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                        end
                        for i=0,3,1 do
                            pickupChoice = Mod.unbiasedFromSuit("Clubs")
                            Isaac.Spawn(5, mod.CardNamePickups["Clubs"], pickupChoice, pickup.Position, Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))), Pickup)
                        end
                    end
                end
                if data.rewardType == 5 then
                    --Pills
                    if data.rewardTier == 1 then
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_PILL,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                    elseif data.rewardTier == 2 then
                        for i=0,4,1 do
                            local coloursNum = mod.AchievementTrackers.GoldenPillsUnlocked and 14 or 13
                            pickupChoice = math.random(0,coloursNum)  + 1
                            if math.random(0,1) == 1 and mod.AchievementTrackers.HorsePillsUnlocked then
                                pickupChoice = pickupChoice + 2048
                            end
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_PILL,pickupChoice,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                        end
                    else
                        for i=0,6,1 do
                            local coloursNum = mod.AchievementTrackers.GoldenPillsUnlocked and 14 or 13
                            pickupChoice = math.random(0,coloursNum) + 1
                            if math.random(0,1) == 1 and mod.AchievementTrackers.HorsePillsUnlocked then
                                pickupChoice = pickupChoice + 2048
                            end
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_PILL,pickupChoice,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                        end
                    end
                end
                if data.rewardType == 6 then
                    --Cards
                    if data.rewardTier == 1 then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                    elseif data.rewardTier == 2 then
                        for i=0,4,1 do
                            local toSpawn = 1
                            if toSpawn == 0 then
                                --basic card
                                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                            elseif toSpawn == 1 then
                                local objectRNG = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DICE_GOBLIN)
                                local pickupType = mod.GetRandomObject(objectRNG:Next())
                                Isaac.Spawn(EntityType.ENTITY_PICKUP,300,pickupType,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                            end
                        end
                    else
                        for i=0,8,1 do
                            local toSpawn = math.random(0,1)
                            if toSpawn == 0 then
                                --basic card
                                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                            elseif toSpawn == 1 then
                                local objectRNG = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.DICE_GOBLIN)
                                local pickupType = mod.GetRandomObject(objectRNG:Next())
                                Isaac.Spawn(EntityType.ENTITY_PICKUP,300,pickupType,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                            end
                        end
                    end
                end
                if data.rewardType == 7 then
                    --Batteries
                    if data.rewardTier == 1 then
                        local spawnedCard = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_LIL_BATTERY,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                    elseif data.rewardTier == 2 then
                        for i=0,3,1 do
                            local spawnedCard = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_LIL_BATTERY,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                        end
                    else
                        for i=0,6,1 do
                            local spawnedCard = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_LIL_BATTERY,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                        end
                    end
                end
                if data.rewardType == 8 then
                    --Trinkets
                    if data.rewardTier == 1 then
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,0,pickup.Position,Vector((0.1*math.random(-50,50)),(0.1*math.random(-50,50))),pickup)
                    elseif data.rewardTier == 2 then
                        for i=0,1,1 do
                            if math.random(0,1) == 1 then
                                local trinketToGold = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                                trinketToGold:ToPickup():Morph(5, 350, trinketToGold.SubType + 32768, false)
                            else
                                Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                            end
                        end
                    else
                        for i=0,2,1 do
                            if math.random(0,1) == 1 then
                                local trinketToGold = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                                trinketToGold:ToPickup():Morph(5, 350, trinketToGold.SubType + 32768, false)
                            else
                                local trinketToGold = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                            end
                            local trinketGolded = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TRINKET,0,pickup.Position,Vector((0.1*math.random(-150,150)),(0.1*math.random(-150,150))),pickup)
                            trinketGolded:ToPickup():Morph(5, 350, trinketToGold.SubType + 32768, false)
                        end

                    end

                end
                if data.rewardType == 9 then
                    --WTF
                end
            end
            

        end






    end
    --print(Card.NUM_CARDS)
end



Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION,KICKCUBE.KickStart,PickupVariant.PICKUP_GRAB_BAG)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE,KICKCUBE.KickCubeUpdate,PickupVariant.PICKUP_GRAB_BAG)