local Mod = BotB
local TROJAN = {}
local Entities = BotB.Enums.Entities

function TROJAN:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.TROJAN.TYPE and npc.Variant == BotB.Enums.Entities.TROJAN.VARIANT then 
        if data.trojanReadyToOpen == nil then
            data.trojanReadyToOpen = false
            --Jank Wranglers for how knights work
            data.trojanChargingAnimName = "Test"
            data.trojanIsFlipped = false
            data.trojanBruteForceAnimName = "HoriShoot"
            data.trojanBruteForceAnimFrame = 0
            data.trojanIsOpen = false
            data.trojanFireDir = Vector(0,0)
            data.trojanBruteForceMaxHitPoints = npc.MaxHitPoints
        end
        
        if npc.State == 8 then 
            --is charging
            --Wrangling so much jank rn
            --Probably making more at the same time...
            data.trojanChargingAnimName = sprite:GetAnimation()
            data.trojanIsFlipped = sprite.FlipX
            if data.trojanReadyToOpen == false then
                data.trojanReadyToOpen = true
            end
            npc.Velocity = (0.85 * npc.Velocity) + (0.15*(1.25*npc.Velocity))
        end
        if npc.State == 4 then 
            --is roaming
            if data.trojanReadyToOpen == true and npc:CollidesWithGrid() then
                --print("Shoot now")
                --print(sprite:GetAnimation())
                data.trojanReadyToOpen = false
                if data.trojanChargingAnimName == "Hori" then
                    --I don't know why it makes me do this. I'm sorry.
                    data.trojanBruteForceAnimName = "HoriShoot"
                    data.trojanBruteForceAnimFrame = 0
                end
                if data.trojanChargingAnimName == "Up" then
                    data.trojanBruteForceAnimName = "UpShoot"
                    data.trojanBruteForceAnimFrame = 0
                end                
                if data.trojanChargingAnimName == "Down" then
                    data.trojanBruteForceAnimName = "DownShoot"
                    data.trojanBruteForceAnimFrame = 0
                end
                data.trojanIsOpen = true
                npc.State = 99
                --data.trojanReadyToOpen = false
            end
        end



        if npc.State == 99 then 
            npc.Velocity = Vector.Zero
            npc.Position = npc.Position
            
            --Fine, game, if you're gonna be like this. Ugh
            sprite:Stop()
            sprite:SetAnimation(data.trojanBruteForceAnimName, false)
            sprite:SetFrame(data.trojanBruteForceAnimFrame)
            if sprite.FlipX ~= data.trojanIsFlipped then
               sprite.FlipX = data.trojanIsFlipped
            end
            data.trojanBruteForceAnimFrame = data.trojanBruteForceAnimFrame + 1

            if sprite:IsEventTriggered("Open") then
                npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, 1)
                
            end

            if sprite:IsEventTriggered("Close") then
                npc:PlaySound(SoundEffect.SOUND_ANIMAL_SQUISH, 1, 0, false, 1)
            end

            if sprite:IsEventTriggered("Shoot") then
                --Check the direction
                if data.trojanBruteForceAnimName == "HoriShoot" then
                    if sprite.FlipX then
                        data.trojanFireDir = Vector(8,0)
                    else
                        data.trojanFireDir = Vector(-8,0)
                    end
                end
                if data.trojanBruteForceAnimName == "UpShoot" then
                    data.trojanFireDir = Vector(0,8)
                end                
                if data.trojanBruteForceAnimName == "DownShoot" then
                    data.trojanFireDir = Vector(0,-8)
                end
                --3 small
                local trojanShotParams = ProjectileParams()
                trojanShotParams.Spread = 1
                npc:FireProjectiles(npc.Position, data.trojanFireDir, 3, trojanShotParams)
            end

            if sprite:IsEventTriggered("Back") then
                sprite:Play("Up")
                data.trojanIsOpen = false
                data.trojanBruteForceAnimFrame = 0
                npc.State = 4
            end
            
        end

        if not data.trojanIsOpen then
            npc.MaxHitPoints = 0
        else
            npc.State = 99
            npc.MaxHitPoints = data.trojanBruteForceMaxHitPoints
        end
        
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, TROJAN.NPCUpdate, Isaac.GetEntityTypeByName("Trojan"))


