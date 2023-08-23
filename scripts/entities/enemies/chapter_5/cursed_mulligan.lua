local Mod = BotB
local CURSED_MULLIGAN = {}
local Entities = BotB.Enums.Entities

function CURSED_MULLIGAN:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local cursedMulliganPathfinder = npc.Pathfinder


    if npc.Type == BotB.Enums.Entities.CURSED_MULLIGAN.TYPE and npc.Variant == BotB.Enums.Entities.CURSED_MULLIGAN.VARIANT then 
        --States:
        --99: Flee
        --102: Teleport out
        --103: Teleport in
        if data.cursedMulliganSelfTeleportCooldownMax == nil then
            data.cursedMulliganSelfTeleportCooldownMax = 360
            data.cursedMulliganSelfTeleportCooldown = data.cursedMulliganSelfTeleportCooldownMax + math.random(0,100)
        end

        if npc.State == 102 or npc.State == 103 then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        else
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end

        if npc.State == 100 or npc.State == 101 then
            data.cursedHorfDoTeleportOnHurt = true
        else
            if data.cursedHorfDoTeleportOnHurt ~= false then
                data.cursedHorfDoTeleportOnHurt = false
            end
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 0 then
            --Init
            
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:PlayOverlay("Walk")
            end
        end

        if npc.State ~= 99 then
            sprite:PlayOverlay("Wait")
        end

        if npc.State == 99 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            cursedMulliganPathfinder:EvadeTarget(targetpos)
            cursedMulliganPathfinder:EvadeTarget(targetpos)
            if data.cursedMulliganSelfTeleportCooldown ~= 0 then
                data.cursedMulliganSelfTeleportCooldown = data.cursedMulliganSelfTeleportCooldown - 1
            else
                npc.State = 102
                data.cursedMulliganSelfTeleportCooldown = data.cursedMulliganSelfTeleportCooldownMax
                sprite:Play("TeleOut")
                sprite:PlayOverlay("Wait")
            end
        end

        if npc.State == 102 then
            if sprite:IsEventTriggered("Land") then
                if Isaac.CountEntities(npc, BotB.Enums.Entities.CURSED_POOTER.TYPE, BotB.Enums.Entities.CURSED_POOTER.VARIANT) < 2 then
                    --local cursedMulliganPooter = Isaac.Spawn(BotB.Enums.Entities.CURSED_POOTER.TYPE, BotB.Enums.Entities.CURSED_POOTER.VARIANT, 0, npc.Position, Vector.Zero, npc):ToNPC()
                end
            end
            if sprite:IsEventTriggered("Teleport") then
                npc.Position = game:GetRoom():GetRandomPosition(10)
                npc.State = 103
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,math.random(120,130)/100)
                npc:GetSprite():Play("TeleIn")
            end
        end

        if npc.State == 103 then
            if sprite:IsEventTriggered("Land") then
                local cursedMulliganProjParams = ProjectileParams()
                cursedMulliganProjParams.BulletFlags = (ProjectileFlags.SMART | ProjectileFlags.DECELERATE | ProjectileFlags.NO_WALL_COLLIDE | ProjectileFlags.BOOMERANG | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT)
                cursedMulliganProjParams.ChangeTimeout = 10
                cursedMulliganProjParams.HeightModifier = 15
                --cursedMulliganProjParams.FallingSpeedModifier = -1
                cursedMulliganProjParams.FallingAccelModifier = -0.15
                cursedMulliganProjParams.ChangeFlags = (ProjectileFlags.SMART | ProjectileFlags.NO_WALL_COLLIDE)
                for i=0,240,120 do
                    npc:FireProjectiles(npc.Position, Vector(3,0):Rotated(targetangle+i), 0, cursedMulliganProjParams)
                end
                --local cursedMulliganProjectiles = npc:FireProjectiles(npc.Position, Vector(3,3), 9, cursedMulliganProjParams)
            end
            if sprite:IsEventTriggered("Back") then
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL2,1,0,false,math.random(120,130)/100)

                

                npc.State = 99
                sprite:PlayOverlay("Walk")
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CURSED_MULLIGAN.NPCUpdate, Isaac.GetEntityTypeByName("Cursed Mulligan"))



function CURSED_MULLIGAN:TeleportCheck(npc, _, _, _, _)
    --print("sharb")
    if npc.Type == BotB.Enums.Entities.CURSED_MULLIGAN.TYPE and npc.Variant == BotB.Enums.Entities.CURSED_MULLIGAN.VARIANT then 
        if npc:ToNPC().State ~= 102 and npc:ToNPC().State ~= 103 then
            npc:ToNPC().State = 102
            --local data = npc:GetData()
            npc:GetSprite():Play("TeleOut")
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CURSED_MULLIGAN.TeleportCheck, Isaac.GetEntityTypeByName("Cursed Mulligan"))
--[[
function CURSED_MULLIGAN:BulletCheck(bullet)

    --Seducer projectiles spawn red creep when they splat
    if bullet.Parent ~= nil and bullet.Spawner.Type == BotB.Enums.Entities.CURSED_MULLIGAN.TYPE and bullet.Parent.Variant == BotB.Enums.CURSED_MULLIGAN.VARIANT then
        
        if bullet:HasProjectileFlags(ProjectileFlags.DECELERATE) then 
            bullet.Velocity = bullet.Velocity * 0.6
        end
    end
    

end
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, CURSED_MULLIGAN.BulletCheck)
]]