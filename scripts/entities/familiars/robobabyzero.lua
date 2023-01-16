local Mod = BotB
local ROBOBABYZERO = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

function ROBOBABYZERO:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.ROBOBABYZERO.TYPE and npc.Variant == Familiars.ROBOBABYZERO.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.distThreshold == nil then
                --How close does it have to get before attacking?
                data.distThreshold = 100
                --When attacking it will spawn chain lightning each X frames
                data.zapFrequency = 10
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                --Is it following player?
                data.isFollowing = true
                --Switch to tell code that isfollowing is already changed
                data.isFollowingQueueChange = false
                --npc:AddToFollowers()
            end
            npc.State = 99
            sprite:Play("Idle")
        end


        if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            data.zapFrequency = 5
        else
            data.zapFrequency = 10
        end



        --States
        -- 99 - idle
        -- 100 - moving
        -- 101 - attack start
        -- 102 - attacking
        -- 103 - attack end
        if npc.State == 99 then
            if room:IsClear() == false then
                if npc.IsFollower then
                    npc:RemoveFromFollowers()
                end              
                npc:PickEnemyTarget(1000, 13, 0)
                npc.State = 100
            else
                if not npc.IsFollower then
                    npc:AddToFollowers()
                else
                    npc:FollowParent()
                end  
            end
        end

        if npc.State == 100 then
            if npc.Target ~= nil then
                npc.Velocity = ((0.995 * npc.Velocity) + (0.005 * (npc.Target.Position - npc.Position))):Clamped(-7,-7,7,7)

                if (npc.Target.Position - npc.Position):Length() <= data.distThreshold then
                    npc.State = 101
                    sprite:Play("ZapBegin")
                end
            else
                npc.State = 99
            end
        end

        if npc.State == 101 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 102
                sprite:Play("ZapLoop")
            end
        end

        if npc.State == 101 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 102
                sprite:Play("ZapLoop")
            end
        end

        if npc.State == 102 then
            npc.Velocity = 0.85 * npc.Velocity
            if npc.FrameCount % data.zapFrequency == 0 then
                local zappies = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CHAIN_LIGHTNING,0,npc.Position,Vector.Zero,npc):ToEffect()
                zappies.CollisionDamage = 1.25
            end
            if npc.Target == nil or (npc.Target.Position - npc.Position):Length() > data.distThreshold  then
                npc.State = 103
                sprite:Play("ZapEnd")
            end
        end

        if npc.State == 103 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, ROBOBABYZERO.FamiliarUpdate, Isaac.GetEntityVariantByName("Robo-Baby Zero"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Robo-Baby Zero"), "Familiar that automatically seeks out enemies, and zaps them with chain lightning#Chain lightning is identical to that spawned by {{Collectible".. Isaac.GetItemIdByName("Jacob's Ladder") .."}} Jacob's Ladder. #Chain lightening deals 1.25 damage, and is summoned up approximately 6 times per second when the familiar is attacking.")
end
--Egocentrism moment

--Stats
function ROBOBABYZERO:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Robo-Baby Zero"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Robo-Baby Zero"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Robo-Baby Zero"), BotB.Functions.GetExpectedFamiliarNum(player,Items.ROBOBABYZERO), player:GetCollectibleRNG(Isaac.GetItemIdByName("Robo-Baby Zero")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Robo-Baby Zero")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ROBOBABYZERO.onCache,CacheFlag.CACHE_FAMILIARS)