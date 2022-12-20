local Mod = BotB
local KETTLE = {}
local Entities = BotB.Enums.Entities

function KETTLE:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.KETTLE.TYPE and npc.Variant == BotB.Enums.Entities.KETTLE.VARIANT then 

        --Data that is unique to Kettles
        if data.targetPosNew == nil then
            --Used for laser's slow tracking
            --data.targetPosOld = npc.Position
            data.targetPosNew = npc.Position
            data.targetPosLerped = npc.Position
            data.laserTargetAngle = 0
            --Distance within which the Kettle will open. Try to find a way to link this to subtype
            data.triggerDistance = 175
            npc.State = 3
        end
        --States:
        --3: idle
        --4: Opening
        --5: Opened
        --6: Closing, back to 3

        --State init
        if npc.State == 0 then
            npc.State = 3
            sprite:Play("Idle")
        end

        --Lerp targeting positions
        --data.targetPosOld = data.targetPosOld
        data.targetPosNew = targetpos
        data.targetPosLerped = (0.05 * data.targetPosNew) + (0.95 * data.targetPosLerped)
        data.laserTargetAngle = (data.targetPosLerped - npc.Position):GetAngleDegrees()
        

        if npc.State == 3 then
            if targetdistance <= data.triggerDistance then
                --npc:PlaySound(Mod.Enums.SFX.THAUMATURGE_SHOOT, 4, 0, false, mod:RandomInt(120,130)/100)
                --print("pingas")
                npc.State = 4
                sprite:Play("Open")
            end
        end

        if npc.State == 4 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 5
                sprite:Play("Opened")
                data.KettleBeam = EntityLaser.ShootAngle(2, npc.Position, data.laserTargetAngle, 1, Vector(0,-12), npc)
                data.KettleBeam.DepthOffset = 128
                data.littleDot = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.TECH_DOT,0,npc.Position + Vector(0,-14),Vector(0,0),npc):ToEffect()
                data.littleDot.DepthOffset = 256
                data.littleDot:SetTimeout(1)
            end
            if targetdistance >= data.triggerDistance then
                --npc:PlaySound(Mod.Enums.SFX.THAUMATURGE_SHOOT, 4, 0, false, mod:RandomInt(120,130)/100)
                --print("pingas")
                npc.State = 6
                sprite:Play("Close")
            end
        end

        if npc.State == 5 then
            if targetdistance >= data.triggerDistance then
                --npc:PlaySound(Mod.Enums.SFX.THAUMATURGE_SHOOT, 4, 0, false, mod:RandomInt(120,130)/100)
                --print("pingas")
                npc.State = 6
                sprite:Play("Close")
            else
                --LASER TIME
                data.KettleBeam:SetTimeout(data.KettleBeam.Timeout + 1)
                data.littleDot:SetTimeout(data.littleDot.Timeout + 1)
                data.KettleBeam.Angle = data.laserTargetAngle
                data.KettleBeam.MaxDistance = (data.targetPosLerped - npc.Position):Length()
                
            end

        end

        if npc.State == 6 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 3
                sprite:Play("Idle")
            end
        end




    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, KETTLE.NPCUpdate, Isaac.GetEntityTypeByName("Kettle"))