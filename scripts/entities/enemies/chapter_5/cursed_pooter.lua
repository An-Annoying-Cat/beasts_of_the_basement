local Mod = BotB
local CURSED_POOTER = {}
local Entities = BotB.Enums.Entities

function CURSED_POOTER:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local cursedPooterPathfinder = npc.Pathfinder


    if npc.Type == BotB.Enums.Entities.CURSED_POOTER.TYPE and npc.Variant == BotB.Enums.Entities.CURSED_POOTER.VARIANT then 
        --States:
        --99: Idle
        --100: Shoot
        if data.cursedPooterAttackCooldownMax == nil then
            data.cursedPooterAttackCooldownMax = 90
            data.cursedPooterAttackCooldown = data.cursedPooterAttackCooldownMax
        end

        if npc.State == 0 then
            --Init
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Fly")
            end
        end

        if npc.State == 99 then
            npc.Velocity = 0.8 * npc.Velocity
            cursedPooterPathfinder:MoveRandomly(true)
            if data.cursedPooterAttackCooldown ~= 0 then
                data.cursedPooterAttackCooldown = data.cursedPooterAttackCooldown - 1
            else
                npc.State = 100
                data.cursedPooterAttackCooldown = data.cursedPooterAttackCooldownMax
                sprite:Play("Attack")
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                sfx:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,math.random(90,110)/100)
                local cursedPooterProjParams = ProjectileParams()
                cursedPooterProjParams.BulletFlags = ProjectileFlags.SMART
                npc:FireProjectiles(npc.Position, Vector(8,0):Rotated(targetangle), 0, cursedPooterProjParams)
            end
            if sprite:IsFinished() then
                npc.State = 99
                sprite:Play("Fly")
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CURSED_POOTER.NPCUpdate, Isaac.GetEntityTypeByName("Cursed Pooter"))

function CURSED_POOTER:DamageCheck(npc, amount, _, _, _)
    --print("sharb")
    local npcConv = npc:ToNPC()
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Type == BotB.Enums.Entities.CURSED_POOTER.TYPE and npc.Variant == BotB.Enums.Entities.CURSED_POOTER.VARIANT then 
        if amount >= npc.HitPoints then
            sfx:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,math.random(90,110)/100)
            local cursedPooterDeathProjectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, npc.Position, Vector.Zero, npc):ToProjectile()
            cursedPooterDeathProjectile:AddProjectileFlags(ProjectileFlags.SMART)
        end 
    end
    --return true
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CURSED_POOTER.DamageCheck, Isaac.GetEntityTypeByName("Pong"))
