local Mod = BotB
local PARANOIAC = {}
local Entities = BotB.Enums.Entities

function PARANOIAC:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local paranoiacPathfinder = npc.Pathfinder
    local room = Game():GetRoom()

    if npc.Type == BotB.Enums.Entities.PARANOIAC.TYPE and npc.Variant == BotB.Enums.Entities.PARANOIAC.VARIANT then 
        if data.paranoiacSpawnCooldownMax == nil then
            data.paranoiacSpawnCooldownMax = 120
            data.paranoiacSpawnCooldown = data.paranoiacSpawnCooldownMax

        end
        data.targPos = targetpos
        --:AnimWalkFrame(HorizontalAnim, VerticalAnim, SpeedThreshold)
        --States:
        --99: Walk
        --100: Summon a Slight
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        if npc.State == 0 then
            --Init
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:PlayOverlay("Walk")
            end
        end

        if npc.State == 99 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            paranoiacPathfinder:EvadeTarget(targetpos)
            paranoiacPathfinder:EvadeTarget(targetpos)
            --print(data.paranoiacSpawnCooldown)
            if data.paranoiacSpawnCooldown ~= 0 then
                data.paranoiacSpawnCooldown = data.paranoiacSpawnCooldown - 1
            else
                    if Isaac.CountEntities(npc, BotB.Enums.Entities.SLIGHT.TYPE, BotB.Enums.Entities.SLIGHT.VARIANT) < 3 then
                        sprite:PlayOverlay("Shoot")
                        npc.State = 100
                        data.paranoiacSpawnCooldown = data.paranoiacSpawnCooldownMax
                    end
            end
        end

        if npc.State == 100 then
            --sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),1,0,false,math.random(110,130)/100)
            if sprite:GetOverlayFrame() == 5 then
                sfx:Play(SoundEffect.SOUND_FAT_GRUNT,0.5,0,false,math.random(75,85)/100)
                local paranoiacSlight = Isaac.Spawn(BotB.Enums.Entities.SLIGHT.TYPE, BotB.Enums.Entities.SLIGHT.VARIANT, 0, npc.Position, Vector(6,0):Rotated(-targetangle), npc):ToNPC()
                paranoiacSlight.Parent = npc
            end
            if sprite:GetOverlayFrame() == 10 then
                sprite:PlayOverlay("Walk")
                npc.State = 99
            end
            --summon a slight and set the paranoiac as its parent
            
            
        end
        
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PARANOIAC.NPCUpdate, Isaac.GetEntityTypeByName("Paranoiac"))


--SLIGHT