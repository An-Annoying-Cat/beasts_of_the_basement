local Mod = BotB
local SKIP_FLY = {}
local Entities = BotB.Enums.Entities

function SKIP_FLY:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.SKIP_FLY.TYPE and npc.Variant == BotB.Enums.Entities.SKIP_FLY.VARIANT then
        if data.SkipFlyHopAngle == nil then
            --What angle is it hopping in?
            data.SkipFlyIsMidair = false
            data.SkipFlyHopAngle = 0
            data.SkipFlyBigHopCooldownMax = 60
            data.SkipFlyBigHopCooldown = data.SkipFlyBigHopCooldownMax
            data.SkipFlyStunCooldownMax = 60
            data.SkipFlyStunCooldown = data.SkipFlyStunCooldownMax
            data.SkipFlyCanBigHop = false
            npc.Friction = 0.5
        end
        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
                sprite:Play("Hop")
                npc.State = 99
            end
        end
        
        --States:
        --99: Small hop
        --100: Big hop
        if npc.State == 99 then
            if sprite:IsEventTriggered("Jump") then
                data.SkipFlyHopAngle = targetangle
                data.SkipFlyIsMidair = true
                npc.CollisionDamage = 0
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            end
            if sprite:IsEventTriggered("Land") then
                npc:PlaySound(BotB.Enums.SFX.SKIPFLY_BOUNCE, 1, 0, false, math.random(90,110)/100)
                data.SkipFlyIsMidair = false
                npc.Velocity = Vector.Zero
                npc.CollisionDamage = 1
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                --projectile attack and stuff

                --local skipFlyProjParams = ProjectileParams()
                --npc:FireProjectiles(npc.Position, Vector(3,0), 6, skipFlyProjParams)

                if data.SkipFlyCanBigHop == true then
                    npc.State = 100
                    sprite:Play("BigHop")
                end
            end
            if data.SkipFlyIsMidair == true then
                npc.Velocity = Vector(8,0):Rotated(data.SkipFlyHopAngle)
            end
            if data.SkipFlyBigHopCooldown ~= 0 then
                if data.SkipFlyCanBigHop ~= false then
                    data.SkipFlyCanBigHop = false
                end
                data.SkipFlyBigHopCooldown = data.SkipFlyBigHopCooldown - 1
                --print(data.SkipFlyBigHopCooldown)
            else
                data.SkipFlyCanBigHop = true
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Jump") then
                data.SkipFlyHopAngle = targetangle
                data.SkipFlyIsMidair = true
                npc.CollisionDamage = 0
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            end
            if sprite:IsEventTriggered("BigLand") then
                Game():ShakeScreen(8)
                npc:PlaySound(BotB.Enums.SFX.SKIPFLY_BOUNCE, 1, 0, false, math.random(65,85)/100)
                data.SkipFlyIsMidair = false
                npc.Velocity = Vector.Zero
                npc.CollisionDamage = 1
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                --big projectile attack

                local skipFlyBigProjParams = ProjectileParams()
                npc:FireProjectiles(npc.Position, Vector(6,0), 8, skipFlyBigProjParams)

                data.SkipFlyStunCooldown = data.SkipFlyStunCooldownMax
            end
            if data.SkipFlyIsMidair == true then
                npc.Velocity = Vector(8,0):Rotated(data.SkipFlyHopAngle)
            end

            if data.SkipFlyStunCooldown ~= 0 then
                if sprite:GetFrame() > 36 then
                    sprite:SetFrame(36)
                end
                data.SkipFlyStunCooldown =  data.SkipFlyStunCooldown - 1
            end

            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                sprite:Play("Hop")
                data.SkipFlyBigHopCooldown = data.SkipFlyBigHopCooldownMax
            end

        end

    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SKIP_FLY.NPCUpdate, Isaac.GetEntityTypeByName("Skip Fly"))