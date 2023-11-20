local Mod = BotB
local CYAN_MOTER = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function CYAN_MOTER:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.CYAN_MOTER.TYPE and npc.Variant == BotB.Enums.Entities.CYAN_MOTER.VARIANT then 
        if npc.State == 0 then

            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
                sprite:Play("Fly")
                npc.State = 99
            end
        end
        --States:
        --99: Idle

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end

        --Idle
        if npc.State == 99 then
            npc.Velocity = (0.9875 * npc.Velocity) + (0.0125*Vector(8,0):Rotated(targetangle)):Clamped(-5,-5,5,5)
            if npc.HitPoints ~= npc.MaxHitPoints then
                npc.State = 100
                sprite:Play("Shoot")
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,1,0,false,math.random(175,225)/100)
                npc:PlaySound(BotB.Enums.SFX.PONGPOP,0.75,0,false,math.random(175,225)/100)
                        local spawnedFly = Isaac.Spawn(18, 0, 0, npc.Position + Vector(5,0):Rotated(targetangle), Vector(0,0), npc)
                        spawnedFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                        spawnedFly:GetSprite():Load("gfx/monsters/chapter_1/cyan_moter_fly.anm2", true)
                        spawnedFly.Velocity = Vector(32,0):Rotated(targetangle)
                        spawnedFly.HitPoints = 1
            end
            if sprite:IsFinished() then
                npc.State = 101
                sprite:Play("Fly2")
            end
        end

        if npc.State == 101 then
            npc.Velocity = (0.95 * npc.Velocity) + (0.05*Vector(8,0):Rotated(targetangle)):Clamped(-8,-8,8,8)
            if npc.FrameCount % 3 == 0 then
                npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.5,0,false,math.random(110,140)/100)
                local projectile = Isaac.Spawn(9, 0, 0, npc.Position, npc.Velocity+Vector(1,0):Rotated(math.random(360)), npc):ToProjectile()
                projectile.Scale = 0.5
                projectile.FallingSpeed = -15
                projectile.FallingAccel = 2
                projectile.Height = -10
                projectile.DepthOffset = -99999
            end
            if npc.FrameCount % 2 == 0 then
                local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector.Zero, npc):ToEffect()
                creep.Scale = creep.Scale * 0.35
                creep:SetTimeout(40)
                creep:Update()
            end
        end


    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CYAN_MOTER.NPCUpdate, Isaac.GetEntityTypeByName("Cherry"))