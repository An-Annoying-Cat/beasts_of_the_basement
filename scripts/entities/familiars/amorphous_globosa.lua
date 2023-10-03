local Mod = BotB
local AMORPHOUS_GLOBOSA = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items
function AMORPHOUS_GLOBOSA:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.AMORPHOUS_GLOBOSA_FAMILIAR.TYPE and npc.Variant == Familiars.AMORPHOUS_GLOBOSA_FAMILIAR.VARIANT then 
        ----print(npc.State)

        if npc.State == 0 then
            if data.shotCooldownMax == nil then
                data.shotCooldownMax = 60
                data.shotCooldown = data.shotCooldownMax
                data.hasBabyBender = false
                data.TargetEntity = nil
            end
            npc.State = 99
            sprite:Play("Idle")
        end


        if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            data.shotCooldownMax = 30
        else
            data.shotCooldownMax = 60
        end

        if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
            if data.hasBabyBender ~= true then
                data.hasBabyBender = true
            end
        else
            if data.hasBabyBender ~= false then
                data.hasBabyBender = false
            end
        end

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end

        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ENEMIES then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
        end

        --States
        -- 99 - moving
        -- 100 - enemy contact, shoot
        if npc.State == 99 then
            if not sprite:IsPlaying("Idle") then
                sprite:Play("Idle")
            end
            npc:MoveDiagonally(1)
            if room:IsClear() then
            
            else
             if data.shotCooldown ~= 0 then
                 data.shotCooldown = data.shotCooldown - 1
             else
                 --npc:PickEnemyTarget(20, 1, 1)
                 --local gotAnEnemy = false
                 if room:IsClear() == false then
                     local roomEntities = Isaac.GetRoomEntities() -- table
                     for i = 1, #roomEntities do
                         local entity = roomEntities[i]
                         ----print(entity.Type, entity.Variant, entity.SubType)
                         if entity:IsEnemy() and (not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) and (not entity:IsInvincible()) then
                             if (entity.Position - npc.Position):Length() <= 100 then
                                 data.TargetEntity = entity
                                 npc.State = 100
                                 sprite:Play("Shoot")
                                 break
                             end
                         end
                     end
                 end
             end
 
            end
        end

        if npc.State == 100 then
            npc.Velocity = 0.5 * npc.Velocity
            if sprite:GetFrame() == 8 then
                --print("fire")
                SFXManager():Play(SoundEffect.SOUND_LITTLE_SPIT,1,0,false,1,0)
                local amGlobTear1 = npc:FireProjectile(Vector(2,0):Rotated((data.TargetEntity.Position - npc.Position):GetAngleDegrees()))
                local amGlobTear2 = npc:FireProjectile(Vector(2,0):Rotated((data.TargetEntity.Position - npc.Position):GetAngleDegrees()+120))
                local amGlobTear3 = npc:FireProjectile(Vector(2,0):Rotated((data.TargetEntity.Position - npc.Position):GetAngleDegrees()+240))
                amGlobTear1:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_POP)
                    amGlobTear2:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_POP)
                    amGlobTear3:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_POP)
                if data.hasBabyBender then
                    amGlobTear1:AddTearFlags(TearFlags.TEAR_HOMING)
                    amGlobTear2:AddTearFlags(TearFlags.TEAR_HOMING)
                    amGlobTear3:AddTearFlags(TearFlags.TEAR_HOMING)
                end
            end
            if sprite:IsFinished("Shoot") or room:IsClear() then
                data.shotCooldown = data.shotCooldownMax
                npc.State = 99
                sprite:Play("Idle")
            end
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, AMORPHOUS_GLOBOSA.FamiliarUpdate, Isaac.GetEntityVariantByName("Amorphous Globosa (Familiar)"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Amorphous Globosa"), "Familiar that bounces diagonally around the room, shooting three shots in a triangle when it comes into contact with an enemy. #Enemies hit by its shots drop temporary, miniature versions of this familiar on death.")
end
--Egocentrism moment

--Stats
function AMORPHOUS_GLOBOSA:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Robo-Baby Zero"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Robo-Baby Zero"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Amorphous Globosa (Familiar)"), BotB.Functions.GetExpectedFamiliarNum(player,Items.AMORPHOUS_GLOBOSA), player:GetCollectibleRNG(Items.AMORPHOUS_GLOBOSA), Isaac.GetItemConfig():GetCollectible(Items.AMORPHOUS_GLOBOSA))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, AMORPHOUS_GLOBOSA.onCache,CacheFlag.CACHE_FAMILIARS)




function AMORPHOUS_GLOBOSA:MiniFamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.AMORPHOUS_GLOBOSA_MINI.TYPE and npc.Variant == Familiars.AMORPHOUS_GLOBOSA_MINI.VARIANT then 
        ----print(npc.State)

        if npc.State == 0 then
            if data.shotCooldownMax == nil then
                data.shotCooldownMax = 60
                data.shotCooldown = data.shotCooldownMax
                data.hasBabyBender = false
                data.TargetEntity = nil
                data.GlobVariant = math.random(1,4)
                data.idleAnim = "Idle" .. data.GlobVariant
                data.shootAnim = "Shoot" .. data.GlobVariant
            end
            npc.State = 99
            sprite:Play(data.idleAnim)
        end


        if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            data.shotCooldownMax = 30
        else
            data.shotCooldownMax = 60
        end

        if player:HasTrinket(TrinketType.TRINKET_BABY_BENDER) then
            if data.hasBabyBender ~= true then
                data.hasBabyBender = true
            end
        else
            if data.hasBabyBender ~= false then
                data.hasBabyBender = false
            end
        end

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end

        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ENEMIES then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
        end

        --States
        -- 99 - moving
        -- 100 - enemy contact, shoot
        if npc.State == 99 then
            if not sprite:IsPlaying(data.idleAnim) then
                sprite:Play(data.idleAnim)
            end
            npc:MoveDiagonally(1)
           if room:IsClear() then
            
           else
            if data.shotCooldown ~= 0 then
                data.shotCooldown = data.shotCooldown - 1
            else
                --npc:PickEnemyTarget(20, 1, 1)
                --local gotAnEnemy = false
                if room:IsClear() == false then
                    local roomEntities = Isaac.GetRoomEntities() -- table
                    for i = 1, #roomEntities do
                        local entity = roomEntities[i]
                        ----print(entity.Type, entity.Variant, entity.SubType)
                        if entity:IsEnemy() and (not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) and (not entity:IsInvincible()) then
                            if (entity.Position - npc.Position):Length() <= 100 then
                                data.TargetEntity = entity
                                npc.State = 100
                                sprite:Play(data.shootAnim)
                                break
                            end
                        end
                    end
                end
            end

           end
            
        end
        
        if npc.State == 100 then
            npc.Velocity = 0.5 * npc.Velocity
            if sprite:GetFrame() == 8 then
                --print("fire")
                SFXManager():Play(SoundEffect.SOUND_LITTLE_SPIT,0.5,0,false,2,0)
                local amGlobTear1 = npc:FireProjectile(Vector(0.125,0):Rotated((data.TargetEntity.Position - npc.Position):GetAngleDegrees()))
                amGlobTear1:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_POP)
                amGlobTear1.CollisionDamage = 1
            end
            if sprite:IsFinished(data.shootAnim) or room:IsClear() then
                data.shotCooldown = data.shotCooldownMax
                npc.State = 99
                sprite:Play(data.idleAnim)
            end
        end
        --
        --print(npc.RoomClearCount)
        if npc.RoomClearCount >= 2 then
            --npc.HitPoints = 0
            npc:Kill()
        end

    end
end

--print(BotB.Enums.SFX.COW_MOO)

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, AMORPHOUS_GLOBOSA.MiniFamiliarUpdate, Isaac.GetEntityVariantByName("Amorphous Globosa (Mini)"))




function AMORPHOUS_GLOBOSA:MarkHitEnemy(npc, amount, _, source, _)
    ----print(source.Entity.SpawnerEntity.Type .. ", " .. source.Entity.SpawnerEntity.Variant)
    if source.Entity == nil or source.Entity.SpawnerEntity == nil then return end
    if source.Entity.SpawnerEntity.Type == EntityType.ENTITY_FAMILIAR and source.Entity.SpawnerEntity.Variant == Familiars.AMORPHOUS_GLOBOSA_FAMILIAR.VARIANT then 
        --print("Gunt")
        if npc:GetData().isAmorphousGlobosaMarked ~= true then
            npc:GetData().isAmorphousGlobosaMarked = true
            npc:GetData().AmGlobMarkSource = source.Entity.SpawnerEntity
        end
        
    end

    if npc:GetData().isAmorphousGlobosaMarked == true and amount >= npc.HitPoints then 
        --print("FUCK.")
        if --Isaac.CountEntities(npc:GetData().AmGlobMarkSource:ToFamiliar(), EntityType.ENTITY_FAMILIAR, Familiars.AMORPHOUS_GLOBOSA_MINI.VARIANT) <= 4 * Isaac.CountEntities(nil, EntityType.ENTITY_FAMILIAR, Familiars.AMORPHOUS_GLOBOSA_FAMILIAR.VARIANT) 
            true then
            SFXManager():Play(BotB.Enums.SFX.COW_MOO, 4, 0, false, math.random(140,180)/100,0)
            local miniAmGlob = Isaac.Spawn(EntityType.ENTITY_FAMILIAR,Familiars.AMORPHOUS_GLOBOSA_MINI.VARIANT,0,npc.Position,Vector(math.random(10,30)/10,0):Rotated(math.random(0,359)),npc:GetData().AmGlobMarkSource:ToFamiliar()):ToFamiliar()
            miniAmGlob.Player = npc:GetData().AmGlobMarkSource:ToFamiliar().Player
        end
        
    end
    ----print("sharb")
    --if flags & DamageFlag.DAMAGE_EXPLOSION ~= 0 then return false end
    
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, AMORPHOUS_GLOBOSA.MarkHitEnemy)

--[[
function AMORPHOUS_GLOBOSA:SpawnMiniGlobs(npc)
    --print("COCKS")
    
    --if not ((source.Entity.Type == Familiars.AMORPHOUS_GLOBOSA_FAMILIAR.TYPE and source.Entity.Variant == Familiars.AMORPHOUS_GLOBOSA_FAMILIAR.VARIANT) or (source.Entity.Type == EntityType.ENTITY_PLAYER) or (source.Entity.Type == EntityType.ENTITY_FAMILIAR) or (source.IsFriendly)) then return end
    

end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, AMORPHOUS_GLOBOSA.SpawnMiniGlobs)]]