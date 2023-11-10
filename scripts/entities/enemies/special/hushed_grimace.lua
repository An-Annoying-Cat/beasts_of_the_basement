local Mod = BotB
local HUSHED_GRIMACE = {}
local Entities = BotB.Enums.Entities
local sfx = SFXManager()
local mod = FiendFolio

--local kettlesFiring = 0
--local isDoingKettleSound = false

--Todo: If subtype is 1, have them keep firing after room is complete (do not deactivate)

function HUSHED_GRIMACE:NPCUpdate(npc)
    
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local level = Game():GetLevel()
    
    

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.HUSHED_GRIMACE.TYPE and npc.Variant == BotB.Enums.Entities.HUSHED_GRIMACE.VARIANT then 

        --Data that is unique to Hushed Grimaces
        if data.botbHushedGrimaceActivationCooldownMax == nil then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
	        npc.Velocity = Vector.Zero
            --data.activated = true
            data.fakeState = 99
            --If subtype is one, the Hushed Grimace will stay active regardless of whether the room is cleared. this is meant for trap rooms only
            if npc.SubType == 1 then
                data.AlwaysOn = true
                
            else
                data.AlwaysOn = false
            end
            data.botbHushedGrimaceActivationCooldownMax = 240
            data.botbHushedGrimaceActivationCooldown = data.botbHushedGrimaceActivationCooldownMax
            data.botbHushedGrimaceActiveDurationMax = 120
            data.botbHushedGrimaceActiveDuration = data.botbHushedGrimaceActiveDurationMax
            data.pleaseStayHere = npc.Position
            sprite:Play("Idle")
            --npc:AddEntityFlags(EntityFlag.FLAG_APPEAR | EntityFlag.FLAG_PERSISTENT)
        end
        if npc.State ~= 16 or data.AlwaysOn then

            
            --[[
            if npc.State == 99 then
                if data.botbHushedGrimaceActivationCooldown ~= 0 then
                    data.botbHushedGrimaceActivationCooldown = data.botbHushedGrimaceActivationCooldown - 1
                else
                    npc.State = 100
                    data.botbHushedGrimaceLaserStartPos = target.Position
                    local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,data.botbHushedGrimaceLaserStartPos,Vector(0,0),npc):ToEffect()
                    warningTarget.Scale = 0.75
                    warningTarget:GetSprite().Color = Color(1,1,1,1,0,0,0)
                    sprite:Play("Start")
                end
            end

            if npc.State == 100 then
                if sprite:GetFrame() == 29 then
                    data.botbHushedGrimaceActiveDuration = data.botbHushedGrimaceActiveDurationMax
                    --spawn the laser
                    data.botbHushedGrimaceMyLaser = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.HUSHED_LASER.VARIANT,0,data.botbHushedGrimaceLaserStartPos,Vector.Zero,npc):ToEffect()
                    data.botbHushedGrimaceMyLaser:GetData().followThisDude = target
                    data.botbHushedGrimaceMyLaser:GetSprite():Play("Start")
                    npc.State = 101
                    npc:PlaySound(SoundEffect.SOUND_HUSH_ROAR,0.75,0,false,2)
                    sprite:Play("Loop")
                end
            end

            if npc.State == 101 then
                if data.botbHushedGrimaceActiveDuration ~= 0 then
                    data.botbHushedGrimaceActiveDuration = data.botbHushedGrimaceActiveDuration - 1
                else
                    npc.State = 102
                    data.botbHushedGrimaceMyLaser:GetSprite():Play("End", true)
                    sprite:Play("End")
                end
            end

            if npc.State == 102 then
                if sprite:GetFrame() == 12 then
                    data.botbHushedGrimaceActivationCooldown = data.botbHushedGrimaceActivationCooldownMax
                    npc.State = 99
                    sprite:Play("Idle")
                end
            end]]
            npc.State = 3

            print(data.fakeState)

            if data.fakeState == 99 then
                if data.botbHushedGrimaceActivationCooldown ~= 0 then
                    data.botbHushedGrimaceActivationCooldown = data.botbHushedGrimaceActivationCooldown - 1
                else
                    data.fakeState = 100
                    data.botbHushedGrimaceLaserStartPos = target.Position
                    local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,data.botbHushedGrimaceLaserStartPos,Vector(0,0),npc):ToEffect()
                    warningTarget.Scale = 0.75
                    warningTarget:GetSprite().Color = Color(1,1,1,1,0,0,0)
                    sprite:Play("Start")
                end
            end

            if data.fakeState == 100 then
                if sprite:GetFrame() == 29 then
                    data.botbHushedGrimaceActiveDuration = data.botbHushedGrimaceActiveDurationMax
                    --spawn the laser
                    data.botbHushedGrimaceMyLaser = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.HUSH_LASER,0,data.botbHushedGrimaceLaserStartPos,Vector.Zero,npc):ToEffect()
                    data.botbHushedGrimaceMyLaser:GetData().followThisDude = target
                    data.botbHushedGrimaceMyLaser:GetSprite():Play("Start")
                    data.fakeState = 101
                    npc:PlaySound(SoundEffect.SOUND_HUSH_ROAR,0.75,0,false,2)
                    sprite:Play("Loop")
                end
            end

            if data.fakeState == 101 then
                if data.botbHushedGrimaceActiveDuration ~= 0 then
                    data.botbHushedGrimaceActiveDuration = data.botbHushedGrimaceActiveDuration - 1
                else
                    data.fakeState = 102
                    data.botbHushedGrimaceMyLaser:GetSprite():Play("End", true)
                    sprite:Play("End")
                end
            end

            if data.fakeState == 102 then
                if sprite:GetFrame() == 12 then
                    data.botbHushedGrimaceActivationCooldown = data.botbHushedGrimaceActivationCooldownMax
                    data.fakeState = 99
                    sprite:Play("Idle")
                end
            end


        else
            if data.AlwaysOn ~= true then
                if sprite:IsPlaying("Deactivate") ~= true and sprite:IsPlaying("Inactive") ~= true then
                    sprite:Play("Deactivate")
                end
    
                if sprite:IsFinished("Deactivate") then
                    sprite:Play("Inactive")
                end
            else

                

            end
            


        end
        --States:
        --3: idle
        --4: windup
        --5: firing
        --6: stopping

        --7: Room has been cleared. Deactivating...
        --8: Deactivated

        --State init
        

        




    end

end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, HUSHED_GRIMACE.NPCUpdate, Isaac.GetEntityTypeByName("Crockpot (New)"))







--[[
function HUSHED_GRIMACE:laserEffect(effect)
    if effect:GetData().followThisDude ~= nil then
        effect.Velocity = ((0.9975 * effect.Velocity) + (0.0025 * (effect:GetData().followThisDude.Position - effect.Position))):Clamped(-15,-15,15,15)
    end

    if effect:GetSprite():IsFinished("Start") then
        effect:GetSprite():Play("Loop")
    end
    if effect:GetSprite():IsFinished("End") then
        effect:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,HUSHED_GRIMACE.laserEffect, BotB.Enums.Entities.HUSHED_LASER.VARIANT)]]