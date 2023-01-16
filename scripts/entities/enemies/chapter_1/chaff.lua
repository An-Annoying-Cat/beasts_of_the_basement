local Mod = BotB
local CHAFF = {}
local Entities = BotB.Enums.Entities
local Fiend = Mod.FF

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

                    local data = npc:GetData()
                    if not data["BotBChildren"] then --create eternal fly table
                        data["BotBChildren"] = {}
                    end

                    if #data["BotBChildren"] < 2 then --spawn eternal flies if none exist
                        sfx:Play(Isaac.GetSoundIdByName("Wheeze"),1,0,false,math.random(75, 85)/100)
                        local spawnedEternalFly = Isaac.Spawn(Fiend.FF.DeadFlyOrbital.ID, Fiend.FF.DeadFlyOrbital.Var, 0, npc.Position + Vector(1,0):Rotated(targetangle), Vector(6,0):Rotated(targetangle), npc)
                        spawnedEternalFly.Parent = npc
                        npc.Child = spawnedEternalFly
                        table.insert(data["BotBChildren"], spawnedEternalFly)

                    elseif Isaac.CountEntities(npc, Fiend.FF.DeadFlyOrbital.ID, Fiend.FF.DeadFlyOrbital.Var) >= 2 then

                        for _, ent in ipairs(Isaac.FindInRadius(npc.Position, 20, EntityPartition.ENEMY)) do
                            if ent.Type == Fiend.FF.DeadFlyOrbital.ID and ent.Variant == Fiend.FF.DeadFlyOrbital.Var then
                                --if fly is too close then just wheeze
                                sfx:Play(Isaac.GetSoundIdByName("Wheeze"),0.5,0,false,math.random(100, 125)/100)
                            return end
                        end

                        sfx:Play(Isaac.GetSoundIdByName("Wheeze"),1,0,false,math.random(75, 85)/100)
                        for i = #data["BotBChildren"], 1, -1 do --detach eternal flies
                            local fly = data["BotBChildren"][i]
                            fly.Parent = nil
                            fly:ToNPC():Morph(Fiend.FF.DeadFlyOrbital.ID, Fiend.FF.DeadFlyOrbital.Var, 0, -1)
                            fly.HitPoints = 1
                            fly.SpriteScale = Vector(0.5,0.5)
                            fly.SpawnerEntity = npc
                        end
                    else
                        for i = #data["BotBChildren"], 1, -1 do
                            local fly = data["BotBChildren"][i]
                            if not fly:Exists() then table.remove(data["BotBChildren"], i) end
                        end
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

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CHAFF.NPCUpdate, Entities.CHAFF.TYPE)
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, CHAFF.NPCDeathCheck)