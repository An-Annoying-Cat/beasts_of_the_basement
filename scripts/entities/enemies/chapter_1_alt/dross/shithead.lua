local Mod = BotB
local SHITHEAD = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

--Pronounced "shih-THEED", thank you very much! - Millie

function SHITHEAD:NPCUpdate(npc)

    


    if npc.Type == BotB.Enums.Entities.SHITHEAD.TYPE and npc.Variant == BotB.Enums.Entities.SHITHEAD.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local shitheadPathfinder = npc.Pathfinder
        if data.numBigDipsMax == nil then
            data.numBigDipsMax = 2
            data.shitheadFartCooldownMax = 120
            data.shitheadFartCooldown = data.shitheadFartCooldownMax
        end

        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
                sprite:Play("WalkHori")
                npc.State = 99
            end
        end
        --0: init
        --99: Walking
        --100: Fart/Dip summon
        if npc.State == 99 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            shitheadPathfinder:FindGridPath(targetpos, 0.4, 1, false)
            --[[
            if npc.FrameCount % 8 == 0 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CREEP_SLIPPERY_BROWN,0,npc.Position,Vector.Zero,npc):ToEffect()
                creep.SpriteScale = creep.SpriteScale * 0.8
                creep.Timeout = 90
                creep:Update()
            end
            ]]
            if data.shitheadFartCooldown ~= 0 then
                data.shitheadFartCooldown = data.shitheadFartCooldown - 1
            else
                if targetdistance <= 300 then
                    if sprite:GetAnimation() == "WalkVert" then
                        sprite:Play("AttackVert")
                    elseif sprite:GetAnimation() == "WalkHori" then
                        sprite:Play("AttackHori")
                    else
                        sprite:Play("AttackVert")
                    end
                    npc:PlaySound(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR, 1, 0, false, math.random(125,150)/100)
                    npc.State = 100
                    data.shitheadFartCooldown = data.shitheadFartCooldownMax
                end
            end
        end
        --Attacking
        if npc.State == 100 then
            if npc.Velocity ~= Vector.Zero then
                npc.Velocity = Vector.Zero
            end
            if sprite:IsEventTriggered("Shoot") then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.COLOSTOMIA_PUDDLE,0,npc.Position,Vector.Zero,npc):ToEffect()
                creep.SpriteScale = creep.SpriteScale * 1
                creep.Timeout = 180
                creep:Update()
                --npc:PlaySound(ff.Sounds.FunnyFart, 1, 0, false, math.random(65,85)/100)
                --print(data.numBigDipsMax)
                if Isaac.CountEntities(npc, 217, 3,0) < data.numBigDipsMax then
                    npc:PlaySound(ff.Sounds.FunnyFart, 1, 0, false, math.random(65,85)/100)
                    local spawnedFly = Isaac.Spawn(217, 3, 0, npc.Position, Vector(3,0):Rotated(math.random(360)), npc)
                    spawnedFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    local spawnedSprite = spawnedFly:GetSprite()
                    spawnedFly.HitPoints = 1
                    spawnedSprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_1.5/dross/big_corn_shithead.png")
                    spawnedSprite:LoadGraphics()
                    local spawnedFly2 = Isaac.Spawn(217, 3, 0, npc.Position, Vector(3,0):Rotated(math.random(360)), npc)
                    spawnedFly2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    local spawnedSprite2 = spawnedFly2:GetSprite()
                    spawnedSprite2:ReplaceSpritesheet(0, "gfx/monsters/chapter_1.5/dross/big_corn_shithead.png")
                    spawnedSprite2:LoadGraphics()
                    spawnedFly2.HitPoints = 1
                else
                    npc:PlaySound(ff.Sounds.FunnyFart, 0.5, 0, false, math.random(165,185)/100)
                end
            end
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SHITHEAD.NPCUpdate, Isaac.GetEntityTypeByName("Shithead"))