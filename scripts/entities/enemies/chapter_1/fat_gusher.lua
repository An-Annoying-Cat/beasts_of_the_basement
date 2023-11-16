local Mod = BotB
local FAT_GUSHER = {}
local Entities = BotB.Enums.Entities

function FAT_GUSHER:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.FAT_GUSHER.TYPE and npc.Variant == BotB.Enums.Entities.FAT_GUSHER.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local somebodyPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.fatGusherShotCooldown == nil then
                data.fatGusherShotCooldown = 4
                data.botbGoHere = FiendFolio:FindRandomValidPathPosition(npc, 3)
            end
            npc.State = 99
            sprite:PlayOverlay("Blood")
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 99 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            somebodyPathfinder:FindGridPath(data.botbGoHere, 0.25, 0, false)
            npc.Velocity = 0.8 * npc.Velocity
            if (data.botbGoHere - npc.Position):Length() <= 50 then
                data.botbGoHere = FiendFolio:FindRandomValidPathPosition(npc, 3)
            end
            if data.fatGusherShotCooldown ~= 0 then
                data.fatGusherShotCooldown = data.fatGusherShotCooldown - 1
            else
                local bullet = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(4, 6) / 10), 6),0):Rotated(math.random(360)):Resized(math.random(5,25)/10), npc):ToProjectile()
                    bullet.FallingSpeed = -15;
		            bullet.FallingAccel = 0.5
		            bullet.Height = -18
                    bullet.Scale = 2
                    bullet.Parent = npc
                    data.fatGusherShotCooldown = 32
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,math.random(65,85)/100)
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FAT_GUSHER.NPCUpdate, Isaac.GetEntityTypeByName("Fat Gusher"))



function FAT_GUSHER:BulletCheck(bullet)

    --Seducer projectiles spawn red creep when they splat
    if bullet.Parent ~= nil and bullet.Parent.Type == BotB.Enums.Entities.FAT_GUSHER.TYPE and bullet.Parent.Variant == BotB.Enums.Entities.FAT_GUSHER.VARIANT then
        if bullet:IsDead() then
            sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,0.5,0,false,math.random(120,150)/100)
            local creep = Isaac.Spawn(1000, EffectVariant.CREEP_RED, 0, bullet.Position, Vector(0,0), bullet)
            creep.SpriteScale = creep.SpriteScale * 1.5
        end
    end
    

end
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, FAT_GUSHER.BulletCheck)