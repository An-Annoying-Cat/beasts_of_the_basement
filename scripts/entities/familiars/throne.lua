local Mod = BotB
local THRONE = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items
local Entities = BotB.Enums.Entities
function THRONE:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.THRONE.TYPE and npc.Variant == Familiars.THRONE.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.distThreshold == nil then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            end
            npc.State = 99

            sprite:Play("Idle")
        end
        if npc.IsFollower then
            npc:RemoveFromFollowers()
        end   
        --States
        -- 99 - idle
        -- 100 - teleport out
        -- 101 - teleport in
        npc.Velocity = Vector.Zero
        if npc.State == 99 then
            local roomEntities = Isaac.GetRoomEntities() -- table
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                if Game():GetRoom():CheckLine(entity.Position, npc.Position, 3) then
                    if entity:ToNPC() ~= nil and entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
                        if entity:GetData().botbLunacyDuration == nil then
                            entity:GetData().botbLunacyDuration = 2
                        else
                            entity:GetData().botbLunacyDuration = entity:GetData().botbLunacyDuration + 2
                        end
                        
                    end
                end
            end
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, THRONE.FamiliarUpdate, Isaac.GetEntityVariantByName("Throne"))

function THRONE:randomizeThronePos()
    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == Familiars.THRONE.VARIANT then
            local fentity = entity:ToFamiliar()
            for i=0, 1000 do
                fentity.Position =  Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(10), 1, true, false)
                if Game():GetRoom():CheckLine(fentity.Position, fentity.Player.Position, 3)  == true then
                    break
                end
            end
        end
        
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, THRONE.randomizeThronePos, 0)


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Throne"), "Familiar that appears in a random location in each room you enter. #Enemies in direct line of sight to this familiar are inflicted with {{StatusLunacy}} Lunacy. #Enemies with {{StatusLunacy}} Lunacy attempt to walk into bullets, weapons, and familiars that have contact damage.")
end
--Egocentrism moment

--Stats
function THRONE:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Throne"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Throne"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Throne"), BotB.Functions.GetExpectedFamiliarNum(player,Items.THRONE), player:GetCollectibleRNG(Isaac.GetItemIdByName("Throne")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Throne")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, THRONE.onCache,CacheFlag.CACHE_FAMILIARS)

function THRONE:findNearestLunacyTarget(npc)

    local roomEntities = Isaac.GetRoomEntities() -- table
    local baseDist = 99999
    local bestCandidate = npc
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if (entity.Type == EntityType.ENTITY_FAMILIAR and entity.CollisionDamage > 0) or
        (entity.Type == EntityType.ENTITY_TEAR) or
        (entity:ToProjectile() ~= nil and entity:ToProjectile():HasProjectileFlags(ProjectileFlags.HIT_ENEMIES)) or
        (entity:ToKnife() ~= nil) or
        (entity:ToLaser() ~= nil and entity:ToLaser().SpawnerEntity:ToNPC() == nil) or
        (entity:ToBomb() ~= nil) or
        (entity:ToNPC() ~= nil and entity:ToNPC():GetData().botbHasLunacy ~= true and EntityRef(entity).IsFriendly ~= true) then
            if (entity.Position - npc.Position):Length() <= baseDist then
                bestCandidate = entity
                baseDist = (entity.Position - npc.Position):Length()
            end
        end
        if entity:ToProjectile() ~= nil and entity:ToProjectile().SpawnerEntity ~= nil and entity:ToProjectile().SpawnerEntity:GetData().botbHasLunacy == true then
            if entity:ToProjectile():HasProjectileFlags(ProjectileFlags.HIT_ENEMIES) ~= true then
                entity:ToProjectile():AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
            end
        end
    end

    if bestCandidate ~= nil then
        return bestCandidate
    else
        return npc
    end
    

end

function THRONE:lunacyNPCUpdate(npc)
    local data = npc:GetData()
    if data.botbLunacyDuration == nil then
        data.botbLunacyDuration = 0
    end
    if data.botbLunacyImmune == true then
        if data.botbHasLunacy ~= false then
            data.botbHasLunacy = false
        end
    else
        if data.botbLunacyDuration ~= nil then
            if data.botbLunacyDuration ~= 0 then
                data.botbHasLunacy = true
                data.botbLunacyDuration = data.botbLunacyDuration - 1
            else
                data.botbHasLunacy = false
            end
        end
    end
    if EntityRef(npc).IsFriendly == true then
        data.botbHasLunacy = false
    end
    if data.botbHasLunacy == true then
        if data.botbLunacyIndicator == nil or data.botbLunacyIndicator:IsDead() then
            data.botbLunacyIndicator = Isaac.Spawn(Entities.BOTB_STATUS_EFFECT.TYPE,Entities.BOTB_STATUS_EFFECT.VARIANT,0,npc.Position,Vector.Zero, npc):ToEffect()
            data.botbLunacyIndicator.Parent = npc
            --data.botbLunacyIndicator.ParentOffset = Vector(0,-(npc.SpriteScale.Y * 70))
            data.botbLunacyIndicator:GetSprite():Play("Lunacy", true)
        end
        local lunacyTarget = THRONE:findNearestLunacyTarget(npc)
        if lunacyTarget ~= nil and EntityPtr(lunacyTarget) ~= EntityPtr(npc) then
            if npc.Type ~= EntityType.ENTITY_ROUND_WORM and npc.Type ~= EntityType.ENTITY_ROUNDY then
                npc.TargetPosition = lunacyTarget.Position
            end
            --
            npc.Target = lunacyTarget
        end
        

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, THRONE.lunacyNPCUpdate)


function THRONE:lunacyEffectUpdate(npc)
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Parent ~= nil then
        if sprite:IsPlaying("Lunacy") then
            if npc.Parent:GetData().botbHasLunacy == true then
                npc.Position = Vector(npc.Parent.Position.X, npc.Parent.Position.Y-(npc.SpriteScale.Y * 70))
            else
                npc:Remove()
            end
        end
    else
        npc:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, THRONE.lunacyEffectUpdate, Entities.BOTB_STATUS_EFFECT.VARIANT)



function THRONE:lunacyContactDamage(npc,collider,low)

    if (npc:GetData().botbHasLunacy ~= nil and npc:GetData().botbHasLunacy == true) then
        if collider:ToNPC() ~= nil and collider:IsVulnerableEnemy() then
            if npc.CollisionDamage > 0 then
                collider:TakeDamage(npc.CollisionDamage/4, DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(npc), 0)
            end
            
        end
    end
    if (collider:GetData().botbHasLunacy ~= nil and collider:GetData().botbHasLunacy == true) then
        if npc:ToNPC() ~= nil then
            if collider.CollisionDamage > 0 then
                npc:TakeDamage(collider.CollisionDamage/4, DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(collider), 0)
            end
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, THRONE.lunacyContactDamage)

function BotB:lunacyTestCMD(cmd, params)
    if not cmd == "lunacy" then return end
    if cmd == "lunacy" then
        --local playerTable = BotB:GetPlayers()
        --print("this better have been worth the effort")
        local roomEntities = Isaac.GetRoomEntities() -- table
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
                    entity:GetData().botbLunacyDuration = entity:GetData().botbLunacyDuration + 99999999
                end
            end
            

        


    end
    
    
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.lunacyTestCMD)