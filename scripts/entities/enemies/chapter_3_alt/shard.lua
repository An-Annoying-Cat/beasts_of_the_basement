local Mod = BotB
local SHARD = {}
local Entities = BotB.Enums.Entities
local mod = FiendFolio

function SHARD:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    if npc.Type == BotB.Enums.Entities.SHARD.TYPE and npc.Variant == BotB.Enums.Entities.SHARD.VARIANT then
        local shardPathfinder = npc.Pathfinder
        if data.hasSpawnedFriends == nil then
            data.hasSpawnedFriends = false
            data.faceChanged = false
            data.whichFace = math.random(7)
            --Just a basic one
            data.deathTimer = math.random(110,130)
            --print(data.whichFace)
        end

        if npc.State == 0 then
            npc.State = 3
            npc.StateFrame = 0
        end

        if npc.State == 3 then
            --npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            

            if game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
                local targetvelocity = (targetpos - npc.Position):Resized(5)
                --npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
                npc.Velocity = (0.75 * npc.Velocity) + (0.25 * targetvelocity)
            else
                shardPathfinder:FindGridPath(targetpos, 0.7, 1, true)
            end
    
            if npc.Velocity:Length() > 1 then
                npc:AnimWalkFrame("WalkHori","WalkVert",0)
            else
                sprite:SetFrame("WalkVert", 0)
            end





            if data.deathTimer ~= 0 then
                data.deathTimer = data.deathTimer - 1
            else
                npc.State = 99
                sprite:Play("Shatter")
            end
        end

        if npc.State == 99 then
            if sprite:IsEventTriggered("Break") then
                --Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF03,0,npc.Position,Vector(0,0),npc)
                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,npc.Position,Vector(0,0),npc)
                npc:PlaySound(SoundEffect.SOUND_GLASS_BREAK,0.5,0,false,math.random(120,150)/100)
                npc:Remove()
            end
        end


    end
    --Friend spawning and face changing
    if npc.Type == BotB.Enums.Entities.SHARD.TYPE and npc.Variant == BotB.Enums.Entities.SHARD.VARIANT and data.hasSpawnedFriends == false then 
        --Spawn friends
        if npc.SubType ~= 0 then
            local friendsToSpawn = npc.SubType
            for i=1,friendsToSpawn,1 do
                local newestFren = Isaac.Spawn(BotB.Enums.Entities.SHARD.TYPE, BotB.Enums.Entities.SHARD.VARIANT, 0, npc.Position, Vector.Zero, npc)
                --newestFren:GetData().whichFace = math.random(7)
            end
            data.hasSpawnedFriends = true
        end
        --Face sprite change stuff
        if data.faceChanged == false then
            if data.whichFace ~= 1 then
                sprite:ReplaceSpritesheet(1, "gfx/monsters/chapter_3.5/shard/shard" .. data.whichFace .. ".png")
            end
            sprite:LoadGraphics()
            data.faceChanged = true
        end
        
    end
end

function SHARD:DamageNull(npc, _, _, _, _)
    --print("sharb")
    if npc.Type == BotB.Enums.Entities.SHARD.TYPE and npc.Variant == BotB.Enums.Entities.SHARD.VARIANT then 
        --print("nope!")
        return false
    end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SHARD.NPCUpdate, Isaac.GetEntityTypeByName("Shard"))
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SHARD.DamageNull, Isaac.GetEntityTypeByName("Shard"))