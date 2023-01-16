local Mod = BotB
local CHAFF = {}
local Entities = BotB.Enums.Entities

function CHAFF:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()

    --Chaff (Plays the wheeze sound, shoots an attack fly, checks for limit)
    if npc.Type == Entities.CHAFF.TYPE and npc.Variant == Entities.CHAFF.VARIANT then 
        if npc.State == 8 then npc.State = 9 sprite:Play("Shoot") end 
            if npc.State == 9 then
                if sprite:IsEventTriggered("Shoot") then
                    --3 flies per chaff max, so player doesn't get overwhelmed
                    if Isaac.CountEntities(npc, 18, 0) < 3 then
                        sfx:Play(Isaac.GetSoundIdByName("Wheeze"),1,0,false,math.random(75, 85)/100)
                        local spawnedFly = Isaac.Spawn(18, 0, 0, npc.Position + Vector(5,0):Rotated(targetangle), Vector(0,0), npc)
                        spawnedFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        spawnedFly.Velocity = Vector(6,0):Rotated(targetangle)
                        spawnedFly.HitPoints = 1
                    else
                        sfx:Play(Isaac.GetSoundIdByName("Wheeze"),0.5,0,false,math.random(100, 125)/100)
                    end
                end

                if sprite:IsEventTriggered("Back") then
                    npc.State = 4
                    npc.StateFrame = 0
                end
            end
    end

end

function CHAFF:NPCDeathCheck(npc)

    --Is it a Chaff?
    if npc.Type == Entities.CHAFF.TYPE and npc.Variant == Entities.CHAFF.VARIANT then 
        local spawnedFly = Isaac.Spawn(13, 0, 0, npc.Position, Vector(0,0), npc)
        spawnedFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        spawnedFly.Velocity = Vector(5,0):Rotated(math.random(0,360))
        local spawnedFly2 = Isaac.Spawn(13, 0, 0, npc.Position, Vector(0,0), npc)
        spawnedFly2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        spawnedFly2.Velocity = Vector(5,0):Rotated(math.random(0,360))
        local spawnedFly3 = Isaac.Spawn(13, 0, 0, npc.Position, Vector(0,0), npc)
        spawnedFly3:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        spawnedFly3.Velocity = Vector(5,0):Rotated(math.random(0,360))

    end


end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CHAFF.NPCUpdate, Isaac.GetEntityTypeByName("Chaff"))
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, CHAFF.NPCDeathCheck)