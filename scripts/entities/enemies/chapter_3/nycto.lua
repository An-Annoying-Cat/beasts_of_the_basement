local Mod = BotB
local NYCTO = {}
local Entities = BotB.Enums.Entities

function NYCTO:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.NYCTO.TYPE and npc.Variant == BotB.Enums.Entities.NYCTO.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local nyctoPathfinder = npc.Pathfinder
        npc.CanShutDoors = false
        if npc.State == 0 then
            data.nyctoSpawnPoint = npc.Position
            data.nyctoButtonPosition = NYCTO:FindNearestLightsOffButton(npc.Position)
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        --States:
        --99: Inactive
        --100: Reappear animation
        --101: Dissappear animation
        --102: Active
        if npc.State == 99 then
            npc.Visible = false
            npc.Position = data.nyctoSpawnPoint
        end

        if npc.State ~= 99 then
            npc.Visible = true
        end

        if npc.State == 100 then
            if not sprite:IsPlaying("Reappear") then
                sprite:Play("Reappear")
            end
            if sprite:GetFrame() > 7 then
                sprite:Play("WalkHori")
                sprite:PlayOverlay("Head")
                npc.State = 102
            end
        end

        if npc.State == 101 then
            if not sprite:IsPlaying("Vanish") then
                sprite:Play("Vanish")
            end
            if sprite:IsFinished("Vanish") then
                npc.State = 99
            end
        end

        if npc.State ~= 102 then
            sprite:RemoveOverlay()
        else
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
        end

        if npc.State == 102 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            local buttonangle = (data.nyctoButtonPosition - npc.Position):GetAngleDegrees()
            nyctoPathfinder:FindGridPath(data.nyctoButtonPosition + Vector(20,0):Rotated(buttonangle), 1, 0, true)

            local measureFromPos = data.nyctoButtonPosition
            local measureToPos = npc.Position
            if (measureToPos.X >= measureFromPos.X - 40 and measureToPos.X <= measureFromPos.X + 40) and (measureToPos.Y >= measureFromPos.Y - 40 and measureToPos.Y <= measureFromPos.Y + 40)  then
                SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN,1,0,false,0.6)
                --OH BOY HERE WE GO
                NYCTO:changeAllLightSwitches()
                npc.State = 101
                ---sprite:RemoveOverlay()
                --sprite:Play("Vanish")
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, NYCTO.NPCUpdate, Isaac.GetEntityTypeByName("Nycto"))

function NYCTO:FindNearestLightsOffButton(pos)
    local baseDist = 999999
    local nyctoTarget
    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and (entity.Variant == BotB.Enums.Props.POWER_OFF_BUTTON.VARIANT or entity.Variant == BotB.Enums.Props.LIGHT_SWITCH.VARIANT) then
            if (entity.Position - pos):Length() <= baseDist then
                baseDist = (entity.Position - pos):Length()
                nyctoTarget = entity:ToNPC()
            end
        end
    end
    return nyctoTarget.Position
end




function NYCTO:changeAllLightSwitches()
    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and (entity.Variant == BotB.Enums.Props.POWER_ON_BUTTON.VARIANT or entity.Variant == BotB.Enums.Props.POWER_OFF_BUTTON.VARIANT or entity.Variant == BotB.Enums.Props.LIGHT_SWITCH.VARIANT or entity.Variant == BotB.Enums.Props.ROOM_LIGHT_STATE_TRACKER.VARIANT) then
            
            if entity:GetData().State == "on" then
                entity:GetData().State = "on2off"
            end
            if entity:GetData().State == "off" then
                entity:GetData().State = "off2on"
            end
        end
    end
end