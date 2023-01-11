local Mod = BotB
local CROCKPOT = {}
local Entities = BotB.Enums.Entities
local sfx = SFXManager()
local mod = FiendFolio
local level = Game():GetLevel()
--local kettlesFiring = 0
--local isDoingKettleSound = false

--Todo: If subtype is 1, have them keep firing after room is complete (do not deactivate)

function CROCKPOT:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    
    

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.CROCKPOT.TYPE and npc.Variant == BotB.Enums.Entities.CROCKPOT.VARIANT then 

        --Data that is unique to Crockpots
        if data.targetPosNew == nil then
            --Used for laser's slow tracking
            --data.targetPosOld = npc.Position
            data.targetPosNew = npc.Position
            data.targetPosLerped = npc.Position
            data.laserTargetAngle = 0
            --Distance within which the Kettle will open.
            data.triggerDistance = 175
            --data.activated = true
            npc.State = 3
            --If subtype is one, the Crockpot will stay active regardless of whether the room is cleared. this is meant for trap rooms only
            if npc.SubType == 1 then
                data.AlwaysOn = true
            else
                data.AlwaysOn = false
            end
            data.pleaseStayHere = npc.Position
            npc:AddEntityFlags(EntityFlag.FLAG_APPEAR | EntityFlag.FLAG_PERSISTENT)
        end
        --States:
        --3: idle
        --4: Opening
        --5: Opened
        --6: Closing, back to 3

        --7: Room has been cleared. Deactivating...
        --8: Deactivated

        --State init
        if npc.State == 0 then
            npc.State = 3
            sprite:Play("Idle")
        end

        --Keep initial position
        npc.Position = data.pleaseStayHere
        --Before anything else, close it so it cant get a cheap shot on you
        --If the room is cleared and subtype is not 1 (always on), go to state 7
        if level:GetCurrentRoomDesc().Clear and data.AlwaysOn == false and npc.State ~= 7 and npc.State ~= 8 then
            npc.State = 7
            sprite:Play("Deactivate")
        end

        if npc.State == 7 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 8
                npc:PlaySound(SoundEffect.SOUND_URN_CLOSE, 4, 0, false, mod:RandomInt(85,95)/100)
                sprite:Play("Inactive")
            end
        end

        if npc.State == 8 then
            npc.State = 8
        end

        --Lerp targeting positions
        --data.targetPosOld = data.targetPosOld
        data.targetPosNew = targetpos
        data.targetPosLerped = (0.05 * data.targetPosNew) + (0.95 * data.targetPosLerped)
        data.laserTargetAngle = (data.targetPosLerped - npc.Position):GetAngleDegrees()
        

        if npc.State == 3 then
            if targetdistance <= data.triggerDistance then
                npc:PlaySound(SoundEffect.SOUND_URN_OPEN, 4, 0, false, mod:RandomInt(120,130)/100)
                npc.State = 4
                sprite:Play("Open")
            end
        end

        if npc.State == 4 then
            if npc.FrameCount < 2 then
                npc.State = 3
                sprite:Play("Idle")
            end
            if sprite:IsEventTriggered("Back") then
                npc.State = 5
                --kettlesFiring = kettlesFiring + 1
                sprite:Play("Opened")
                
                
                data.CrockBeam = EntityLaser.ShootAngle(2, npc.Position, data.laserTargetAngle, 1, Vector(0,-12), npc)
                data.CrockBeam.DepthOffset = 128
                data.crockDot = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.TECH_DOT,0,npc.Position + Vector(0,-14),Vector(0,0),npc):ToEffect()
                data.crockDot.DepthOffset = 256
                data.crockDot:SetTimeout(1)
            end
            if targetdistance >= data.triggerDistance then
                npc.State = 6
                npc:PlaySound(SoundEffect.SOUND_URN_CLOSE, 4, 0, false, mod:RandomInt(105,120)/100)
                sprite:Play("Close")
            end
        end

        if npc.State == 5 then
            if targetdistance >= data.triggerDistance then
                npc.State = 6
                --kettlesFiring = kettlesFiring - 1
                npc:PlaySound(SoundEffect.SOUND_URN_CLOSE, 4, 0, false, mod:RandomInt(105,120)/100)
                sprite:Play("Close")
            else
                --LASER TIME
                data.CrockBeam:SetTimeout(data.CrockBeam.Timeout + 1)
                data.crockDot:SetTimeout(data.crockDot.Timeout + 1)
                data.crockDot.Position = npc.Position + Vector(0,-14)
                data.CrockBeam.Angle = data.laserTargetAngle
                data.CrockBeam.MaxDistance = (data.targetPosLerped - npc.Position):Length()
                
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


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CROCKPOT.NPCUpdate, Isaac.GetEntityTypeByName("Crockpot"))