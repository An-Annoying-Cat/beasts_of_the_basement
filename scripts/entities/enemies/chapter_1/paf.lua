local Mod = BotB
local PAF = {}
local Entities = BotB.Enums.Entities

--Subtype 1 is Sub Paf

function PAF:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()
    local level = Game():GetLevel()


    if npc.Type == BotB.Enums.Entities.PAF.TYPE and npc.Variant == BotB.Enums.Entities.PAF.VARIANT then 
        if npc.SubType == 0 or npc.SubType == nil then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        elseif npc.SubType == 1 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
        end
        if data.shotCooldownMax == nil then
            if npc.SubType == 1 then
                data.shotCooldownMax = 28
            else
                data.shotCooldownMax = 8
            end
            data.shotCooldown = data.shotCooldownMax
        end
        --States:
        --99: Idle
        --100: Shoot
        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                sprite:Play("Shake")
                npc.State = 99
            end
        end

        if npc.State == 99 then
            if data.shotCooldown == 0 then
                if targetdistance <= 200 then
                    npc.State = 100
                    if npc.SubType == 0 or npc.SubType == nil then
                        npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR, 0.5, 0, false, math.random(120,150)/100)
                    elseif npc.SubType == 1 then
                        npc:PlaySound(SoundEffect.SOUND_FAT_GRUNT, 0.35, 0, false, math.random(160,180)/100)
                    end
                    
                    sprite:Play("Attack")
                end
            else
                data.shotCooldown = data.shotCooldown - 1
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                if npc.SubType == 0 or npc.SubType == nil then
                    local pafParams = ProjectileParams()
                    pafParams.Scale = 0.5
                    pafParams.HeightModifier = 15
                    pafParams.FallingSpeedModifier = 2.5
                    npc:FireProjectiles(npc.Position, Vector(10,0):Rotated(targetangle-180), 0, pafParams)
                    npc.Velocity = npc.Velocity + Vector (20,0):Rotated(targetangle)
                    data.shotCooldown = data.shotCooldownMax
                elseif npc.SubType == 1 then
                    npc:PlaySound(SoundEffect.SOUND_BOSS2_BUBBLES, 0.25, 0, false, math.random(100,120)/100)
                    local pafParams = ProjectileParams()
                    pafParams.Scale = 0.5
                    pafParams.HeightModifier = 15
                    pafParams.FallingSpeedModifier = 2.5
                    if level:GetStageType() == StageType.STAGETYPE_REPENTANCE then
                        pafParams.Variant = ProjectileVariant.PROJECTILE_TEAR
                    elseif level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B then
                        pafParams.Variant = ProjectileVariant.PROJECTILE_PUKE
                    end
                    npc:FireProjectiles(npc.Position, Vector(10,0):Rotated(targetangle-math.random(160,200)), 0, pafParams)
                    npc.Velocity = npc.Velocity + Vector (3,0):Rotated(targetangle)
                    data.shotCooldown = data.shotCooldownMax
                end
                
            end
            if sprite:GetFrame() == 29 and npc.SubType == 1 then
                if targetdistance <= 200 then
                    sprite:SetFrame(9)
                end
            end
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                sprite:Play("Shake")
            end
            
        end
        if npc.SubType == 0 or npc.SubType == nil then
            npc.Velocity = (0.8*npc.Velocity)
        elseif npc.SubType == 1 then
            npc.Velocity = (0.9*npc.Velocity)
        end
        

    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PAF.NPCUpdate, Isaac.GetEntityTypeByName("Paf"))