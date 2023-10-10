local Mod = BotB
local IMMORTAL_BABY = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

function IMMORTAL_BABY:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.IMMORTAL_BABY.TYPE and npc.Variant == Familiars.IMMORTAL_BABY.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.distThreshold == nil then
                --How close does it have to get before attacking?
                data.distThreshold = 50
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

        --[[
        if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            data.zapFrequency = 5
        else
            data.zapFrequency = 10
        end]]
        --[[
        if npc.Target ~= nil then
            local targetpos = npc.Target.Position
            local targetangle = (targetpos - npc.Position):GetAngleDegrees()
            local targetdistance = (targetpos - npc.Position):Length()
        end]]

        --States
        -- 99 - idle
        -- 100 - moving
        -- 101 - summon the sword
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
                npc.Velocity = ((0.99 * npc.Velocity) + (0.01 * (npc.Target.Position - npc.Position))):Clamped(-8,-8,8,8)

                if (npc.Target.Position - npc.Position):Length() <= data.distThreshold and (data.immortalBabyInvisibleFetus == nil or data.immortalBabyInvisibleFetus:IsDead())  then
                    npc.State = 101
                    sprite:Play("SummonSword")
                end
            else
                npc.State = 99
            end
        end

        if npc.State == 101 then
            if sprite:GetFrame() == 1 then
                if data.immortalBabyInvisibleFetus == nil or data.immortalBabyInvisibleFetus:IsDead() then
                    data.immortalBabyInvisibleFetus = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FETUS,0,npc.Position,Vector.Zero,npc.Player):ToTear()
                    data.immortalBabyInvisibleFetus:AddTearFlags(TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_SWORD | TearFlags.TEAR_SPECTRAL)
                    data.immortalBabyInvisibleFetus.HomingFriction = 0
                    data.immortalBabyInvisibleFetus:GetData().isImmortalBabyInvisibleFetus = true
                    data.immortalBabyInvisibleFetus.Color = Color(1,1,1,1)
                    data.immortalBabyInvisibleFetus.Visible = false
                    data.immortalBabyInvisibleFetus.FallingSpeed = -1
                    data.immortalBabyInvisibleFetus.FallingAcceleration = -0.25
                    data.immortalBabyInvisibleFetus.Scale = 1.5
                    data.immortalBabyInvisibleFetus:GetData().followThisDude = npc
                end
            end
            if sprite:IsFinished("SummonSword") then
                npc.State = 100
                sprite:Play("Idle")
            end
        end

        if npc.FrameCount % 4 == 0 then
            local didProc = false
            local roomEntities = Isaac.GetRoomEntities()
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                if (entity.Position - npc.Position):Length() <= 20 then
                    if entity.Type == EntityType.ENTITY_PROJECTILE and entity:ToProjectile() ~= nil and (entity:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) and entity:ToProjectile():HasProjectileFlags(ProjectileFlags.HIT_ENEMIES)) == false then
                        --print("delete projectile")
                        for i = 1, #roomEntities do
                            local entity = roomEntities[i]
                            if (entity.Position - npc.Position):Length() <= 20 then
                                if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly() == false then
                                    entity:TakeDamage(0.5 * npc.Player.Damage, DamageFlag.DAMAGE_IGNORE_ARMOR, npc, 0)
                                    if didProc ~= true then
                                        didProc = true
                                    end
                                end
                            end
                        end
                        entity:Remove()
                    end
                end
            end
            if didProc == true then
                SFXManager():Play(BotB.Enums.SFX.DIVINE_PROC,0.5,0, false, 1, 0)
            end
        end

        

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, IMMORTAL_BABY.FamiliarUpdate, Isaac.GetEntityVariantByName("Immortal Baby"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Immortal Baby"), "Familiar that automatically seeks out enemies and slashes at them with a {{Collectible".. Isaac.GetItemIdByName("Spirit Sword") .."}} sword. #Sword damage scales with your damage. #Blocks projectiles, and deals half of your damage stat to every enemy in the room when blocking one. #This damage ignores armor!")
end
--Egocentrism moment

--Stats
function IMMORTAL_BABY:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Immortal Baby"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Immortal Baby"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Immortal Baby"), BotB.Functions.GetExpectedFamiliarNum(player,Items.IMMORTAL_BABY), player:GetCollectibleRNG(Isaac.GetItemIdByName("Immortal Baby")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Immortal Baby")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, IMMORTAL_BABY.onCache,CacheFlag.CACHE_FAMILIARS)



function IMMORTAL_BABY:onUpdTear(tear)
	
	--this basically exists to make doing forgotten club and spirit sword much easier
    if tear:GetData().isImmortalBabyInvisibleFetus ~= true then return end
    local data = tear:GetData()
    if data.followThisDude == nil or data.followThisDude:IsDead() or tear.FrameCount >= 40 then
        --data.followThisDude:GetData().immortalBabyInvisibleFetus = nil
        tear:Remove()
    else
        
        local sprite = tear:GetSprite()
        --print(sprite:GetFrame())
        --tear:AddTearFlags(TearFlags.TEAR_FETUS | TearFlags.TEAR_FETUS_SWORD)
        tear.Scale = 1.5
        tear.Position = data.followThisDude.Position
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, IMMORTAL_BABY.onUpdTear)