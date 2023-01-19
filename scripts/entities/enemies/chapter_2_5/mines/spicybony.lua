local Mod = BotB
local SPICY_BONY = {}
local Entities = BotB.Enums.Entities

--print("spice girls")

function SPICY_BONY:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.SPICY_BONY.TYPE and npc.Variant == BotB.Enums.Entities.SPICY_BONY.VARIANT then 
        --print("so tell me whatcha want whatcha really really want")
        if sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(SoundEffect.SOUND_FIRE_RUSH,0.25,0,false,math.random(175,225)/100)
            --get the right velocity?
            data.correctShootVel = Vector.Zero
            if sprite:IsPlaying("AttackDown") then
                data.correctShootVel = Vector(0,8)
            elseif sprite:IsPlaying("AttackUp") then
                data.correctShootVel = Vector(0,-8)
            elseif sprite:IsPlaying("AttackHori") then
                if sprite.FlipX then
                    data.correctShootVel = Vector(-8,0)
                else
                    data.correctShootVel = Vector(8,0)
                end
            end
            --Fire a projectile
            local bullet = Isaac.Spawn(9, 0, 0, npc.Position, data.correctShootVel, npc):ToProjectile()
            bullet.FallingSpeed = 1;
            bullet.FallingAccel = 1
            bullet.Height = -10
            bullet.Parent = npc
            bullet:AddProjectileFlags(ProjectileFlags.BOUNCE_FLOOR)
            local bsprite = bullet:GetSprite()
            bsprite:Load("gfx/monsters/chapter_2.5/mines/spicy_bone_projectile.anm2", true)
            bsprite:Play("Move", true)
            --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
            bullet:Update()
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SPICY_BONY.NPCUpdate, Isaac.GetEntityTypeByName("Spicy Bony"))



function SPICY_BONY:BulletCheck(bullet)
    local room = Game():GetRoom()
    --Humbled projectile spawnstuff
    if bullet.SpawnerType == BotB.Enums.Entities.SPICY_BONY.TYPE and bullet.SpawnerVariant == BotB.Enums.Entities.SPICY_BONY.VARIANT then
        if bullet:GetSprite():GetFilename() ~= "gfx/monsters/chapter_2.5/mines/spicy_bone_projectile.anm2" then
          bullet:Remove()
        end
    end

    if (bullet.Parent ~= nil and bullet.Parent.Type == BotB.Enums.Entities.SPICY_BONY.TYPE and bullet.Parent.Variant == BotB.Enums.Entities.SPICY_BONY.VARIANT) or bullet:GetSprite():GetFilename() == "gfx/monsters/chapter_2.5/mines/spicy_bone_projectile.anm2" then
        if bullet:IsDead() then
            sfx:Play(SoundEffect.SOUND_BLACK_POOF,0.5,0,false,math.random(125,175)/100)
            local fire = Isaac.Spawn(33,10,0, room:GetGridPosition(room:GetClampedGridIndex(bullet.Position)), Vector.Zero, bullet.Parent)
            fire.HitPoints = fire.HitPoints
			fire.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
			fire:Update()
            bullet:Remove()
        end
        --print(bullet.Height)
        if bullet.Height == -5.0 then
            local fire = Isaac.Spawn(33,10,0, bullet.Position, Vector.Zero, bullet.Parent)
            --fire:GetSprite().Scale = Vector(0.5,0.5)
            fire.HitPoints = fire.HitPoints / 2
			fire.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
			fire:Update()
        end
    end
    

end
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, SPICY_BONY.BulletCheck)