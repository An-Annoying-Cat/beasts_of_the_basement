local Mod = BotB
local MABEL = {}
local Entities = BotB.Enums.Entities
local Sounds = BotB.Enums.SFX
local sfx = SFXManager()

function MABEL:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()


    if npc.Type == BotB.Enums.Entities.MABEL.TYPE and npc.Variant == BotB.Enums.Entities.MABEL.VARIANT then 
        if data.mabelApproachDir == nil then
            data.mabelApproachDir = npc.SubType
            data.chargeTimerMax = 7
            data.chargeTimer = data.chargeTimerMax
            data.chargeCooldownMax = 120
            data.chargeCooldown = data.chargeCooldownMax
            --npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            --data.mabelVelLerped = Vector.Zero
            npc.Target = target
            print(npc.Target)
            data.mabelDashVelocity = Vector.Zero
            data.exitDelayFrame = 0
            data.mabelSoundPitch = 1
        end

        --States: 
        --O: init
        --98: Approaching from offscreen
        --99: Idle, cooldown after dash
        --100: Dash telegraph
        --101: Dash start
        --102: Dashing
        --103: Dash end
        --104: Gtfo (in room)
        --105: Gtfo (out of room)

        --Compute sound volume for falloff
        -- ^ Nah bruh fuck that shit, I cant make that happen

        if npc.State == 0 then
            --npc.Position = room:GetCenterPos()+Vector(500,0):Rotated(45*data.mabelApproachDir)
            sprite:Play("Idle")
            npc:PlaySound(Sounds.MABELALERT,1,0,false,1)
            --npc.Position = room:GetCenterPos()+Vector(500,0):Rotated(45*data.mabelApproachDir)
            npc.State = 98
        end

        if npc.State == 98 then
            npc.Velocity = ((0.995 * npc.Velocity) + (0.005 * (target.Position - npc.Position)))
            npc:PlaySound(Sounds.MABELLOOP,1,0,true,data.mabelSoundPitch)
            sfx:AdjustPitch(Sounds.MABELLOOP,data.mabelSoundPitch)
            if room:IsPositionInRoom(npc.Position, 100) then
                npc.State = 99
            end
        end

        if npc.State == 99 then
            npc.Velocity = (0.9975 * npc.Velocity) + (0.0025 * (target.Position - npc.Position))
            data.mabelSoundPitch = (1 * 0.05) + (data.mabelSoundPitch * 0.95)
            sfx:AdjustPitch(Sounds.MABELLOOP,data.mabelSoundPitch)
            if data.chargeCooldown == 0 and room:IsPositionInRoom(npc.Position, 100)then
                npc:PlaySound(Sounds.MABELREV,10,0,false,math.random(60,80)/100)
                npc.State = 100
                sprite:Play("Telegraph")
            end
        end

        if npc.State == 100 then
            npc.Velocity = (0.5 * npc.Velocity) + (0.05 * (Vector.Zero))
            data.mabelSoundPitch = (2 * 0.005) + (data.mabelSoundPitch * 0.995)
            sfx:AdjustPitch(Sounds.MABELLOOP,data.mabelSoundPitch)
            if sprite:IsEventTriggered("Back") then
                npc.State = 101
                sprite:Play("DashStart")
                data.mabelDashVelocity = Vector(25,0):Rotated(targetangle)
            end
        end

        if npc.State == 101 then
            npc.Velocity = (0.9 * npc.Velocity) + (0.1 * data.mabelDashVelocity)
            data.mabelSoundPitch = (4 * 0.05) + (data.mabelSoundPitch * 0.95)
            sfx:AdjustPitch(Sounds.MABELLOOP,data.mabelSoundPitch)
            if sprite:IsEventTriggered("Back") then
                npc.State = 102
                sprite:Play("Dash")
                data.chargeTimer = data.chargeTimerMax
            end
        end

        if npc.State == 102 then
            npc.Velocity = data.mabelDashVelocity
            if data.chargeTimer == 0 then
                npc.State = 103
                npc:PlaySound(Sounds.MABELSTOP,2,0,false,math.random(90,100)/100)
                sfx:Stop(Sounds.MABELLOOP)
                sprite:Play("DashEnd")
                data.chargeCooldown = data.chargeCooldownMax
            end
        end

        if npc.State == 103 then
            npc.Velocity = (0.95 * npc.Velocity) + (0.05 * Vector.Zero)
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                sprite:Play("Idle")
                data.mabelSoundPitch = 0.5
                npc:PlaySound(Sounds.MABELLOOP,1,0,true,data.mabelSoundPitch)
                sfx:AdjustPitch(Sounds.MABELLOOP,data.mabelSoundPitch)
            end
        end



        --Variable shit
        if data.chargeCooldown ~= 0 then
            data.chargeCooldown = data.chargeCooldown - 1
        end
        if data.chargeTimer ~= 0 then
            data.chargeTimer = data.chargeTimer - 1
        end

        --Exit in a cleared room shit
        if room:IsClear() and npc.State ~= 104 and npc.State ~= 105 then
            npc.State = 104
            sprite:Play("Idle")
        end

        if npc.State == 104 then
            npc.Velocity = -((0.995 * npc.Velocity) + (0.005 * (target.Position - npc.Position)))
            data.exitDelayFrame = 0
            if room:IsPositionInRoom(npc.Position, 100) == false then
                npc.State = 105
            end
            
        end

        

        if npc.State == 105 then
            data.exitDelayFrame = data.exitDelayFrame + 1
            npc.Velocity = -((0.995 * npc.Velocity) + (0.005 * (target.Position - npc.Position)))
            if data.exitDelayFrame >= 60 then
                sfx:Stop(Sounds.MABELLOOP)
                npc:Remove()
            else
                npc.Color = Color:Lerp(npc.Color, Color(0,0,0,0), (60-data.exitDelayFrame)/60)
            end
            npc.State = 105
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MABEL.NPCUpdate, Isaac.GetEntityTypeByName("Mabel"))