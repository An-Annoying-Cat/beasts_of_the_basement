local Mod = BotB
local ONYXMARBLE = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items
local Entities = BotB.Enums.Entities

function ONYXMARBLE:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.ONYXMARBLE.TYPE and npc.Variant == Familiars.ONYXMARBLE.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.velocityToDamageCoeff == nil then
                data.velocityToDamageCoeff = 0.5
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end

            npc.State = 99
            sprite:Play("Idle")
        end


        if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            data.velocityToDamageCoeff = 1
        else
            data.velocityToDamageCoeff = 0.5
        end



        --States
        -- 99 - Literally everything
        if npc.State == 99 then
            if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, 0) then
                npc.Velocity = 0.995*npc.Velocity +(0.05*Vector(-50,0))
            end
            if Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, 0) then
                npc.Velocity = 0.995*npc.Velocity +(0.05*Vector(50,0))
            end
            if Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, 0) then
                npc.Velocity = 0.995*npc.Velocity +(0.05*Vector(0,-50))
            end
            if Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, 0) then
                npc.Velocity = 0.995*npc.Velocity +(0.05*Vector(0,50))
            end
            if not Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, 0) and not Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, 0) and not Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, 0) and not Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, 0) then
                npc.Velocity = 0.995*npc.Velocity
            end
            npc.CollisionDamage = npc.Velocity:Length() * data.velocityToDamageCoeff
            if npc.Velocity:Length() > 0.125 then
                if sprite:GetAnimation() ~= "Moving" then
                    sprite:Play("Moving")
                end
            else
                if sprite:GetAnimation() ~= "Idle" then
                    sprite:Play("Idle")
                end
            end

            npc.Velocity = npc.Velocity:Clamped(-40,-40,40,40)
            if npc.Velocity:Length() > 9 and npc:CollidesWithGrid() then
                sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,0.25,0,false,math.random(175, 185)/100)
                local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DARK_BALL_SMOKE_PARTICLE,0,npc.Position,Vector(0,0),npc)
                for i=0,5,1 do
                    --local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.NAIL_PARTICLE,0,npc.Position,Vector((0.1*math.random(-20,20))+npc.Velocity,(0.1*math.random(-20,20))),npc)
                    local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ROCK_POOF,0,npc.Position,Vector((0.1*math.random(-20,20)),(0.1*math.random(-20,20)))+npc.Velocity/4,npc)
                
                end
                --[[
                local grid = room:GetGridEntityFromPos(npc.Position + npc.Velocity:Resized(50))
                if grid ~= nil and grid.Desc.Type == GridEntityType.GRID_ROCK or grid.Desc.Type == GridEntityType.GRID_ROCKT or grid.Desc.Type == GridEntityType.GRID_ROCK_BOMB or grid.Desc.Type == GridEntityType.GRID_ROCKSS or grid.Desc.Type == GridEntityType.GRID_ROCK_SPIKED or grid.Desc.Type == GridEntityType.GRID_ROCK_GOLD then
                    local index = room:GetGridIndex(npc.Position+ npc.Velocity:Resized(50))
                    Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF02,0,grid.Position,Vector(0,0),npc)
                    --Isaac.Spawn(BotB.Enums.Entities.SHARD.TYPE,BotB.Enums.Entities.SHARD.VARIANT,3,grid.Position,Vector(0,0),npc)
                    room:DestroyGrid(index, true)
                    --sfx:Play(SoundEffect.SOUND_BLACK_POOF,1,0,false,math.random(80,90)/100)
                    
                    print("yeah")
                end
                --]]
            end


            


        end

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, ONYXMARBLE.FamiliarUpdate, Isaac.GetEntityVariantByName("Onyx Marble"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Onyx Marble"), "Familiar controlled (loosely) by the keys used to shoot.#Deals contact damage based on its velocity.")
end
--Egocentrism moment

--Stats
function ONYXMARBLE:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.ONYXMARBLE) then return end
	if (cacheFlag&CacheFlag.CACHE_FAMILIARS)==CacheFlag.CACHE_FAMILIARS then
        local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Onyx Marble"))
        local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Onyx Marble"))
        player:CheckFamiliar(Isaac.GetEntityVariantByName("Onyx Marble"), player:GetCollectibleNum(Items.ONYXMARBLE, false), collectibleRNG, itemConfig)
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ONYXMARBLE.onCache)