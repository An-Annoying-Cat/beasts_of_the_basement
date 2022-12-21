local Mod = BotB
local PLANECREEP = {}
local Entities = BotB.Enums.Entities

function PLANECREEP:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()

    --I have no idea why Wall Creeps have state 4 as their idle when most enemies just use 3...
    if npc.Type == BotB.Enums.Entities.PLANECREEP.TYPE and npc.Variant == BotB.Enums.Entities.PLANECREEP.VARIANT then 

        if data.shootCooldown == nil then
            data.shootCooldownMax = 30
            data.shootCooldown = data.shootCooldownMax
        end

        if npc.State == 8 then 
            if data.shootCooldown == 0 then
                npc.State = 9 
                sprite:Play("Attack") 
            else
                npc.State = 4
                sprite:Play("Walk")
            end
            
        end 
            if npc.State == 9 then
                --Shoot
                if sprite:IsEventTriggered("Sound") then
                    npc:PlaySound(SoundEffect.SOUND_WHEEZY_COUGH,0.25,0,false,math.random(110,130)/100)
                    npc:PlaySound(BotB.Enums.SFX.WHEEZE,1,0,false,math.random(110,130)/100)

                    local params = ProjectileParams()
                    params.HeightModifier = 15
                    params.FallingSpeedModifier = -2
                    params.Spread = 14
                    npc:FireProjectiles(npc.Position, Vector(2,0):Rotated(90+npc.SpriteRotation), 1, params)
                    params.Spread = 4
                    npc:FireProjectiles(npc.Position, Vector(3,0):Rotated(90+npc.SpriteRotation), 1, params)
                    --print(npc.SpriteRotation)
                    data.shootCooldown = data.shootCooldownMax
                end
                --Return
                if sprite:IsEventTriggered("Back") then
                    npc.State = 4
                    npc.StateFrame = 0
                    sprite:Play("Walk")
                end
            end
        --Idling and also targeting stuff
        if npc.State == 4 then
            if data.shootCooldown ~= 0 then
                data.shootCooldown = data.shootCooldown - 1
            end

            --print(targetangle)
            if targetangle <= 30+npc.SpriteRotation or targetangle >= 150+npc.SpriteRotation then
                if targetdistance <= 200 then
                    if data.shootCooldown == 0 then
                        npc.State = 9 
                        sprite:Play("Attack") 
                    else
                        npc.State = 4
                        sprite:Play("Walk")
                    end
                end
            end

        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PLANECREEP.NPCUpdate, Isaac.GetEntityTypeByName("Plane Creep"))