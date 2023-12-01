local Mod = BotB
local DESIRER = {}
local Entities = BotB.Enums.Entities

function DESIRER:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    --Desirer
    if npc.Type == BotB.Enums.Entities.DESIRER.TYPE and npc.Variant == BotB.Enums.Entities.DESIRER.VARIANT then 
        if npc.State == 8 then npc.State = 9 sprite:Play("ShootDown") end 
            if npc.State == 9 then
                if npc.StateFrame == 23 then npc.State = 3 npc.StateFrame = 0 end
                if sprite:IsEventTriggered("Shoot") then
                    
                    --npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, math.random(75,85)/100)
                    if Isaac.CountEntities(npc, BotB.Enums.Entities.HUMBLED.TYPE, BotB.Enums.Entities.HUMBLED.VARIANT) < 4 then
                        sfx:Play(Isaac.GetSoundIdByName("DesirerAttack"),1,0,false,math.random(90,110)/100)
                        local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle), npc):ToProjectile()
                        bullet:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                        bullet.FallingSpeed = -30;
		                bullet.FallingAccel = 2
		                bullet.Height = -10
                        bullet.Parent = npc
                        local bsprite = bullet:GetSprite()
                        bsprite:Load("gfx/monsters/chapter_3/humbled_projectile.anm2", true)
                        bsprite:Play("Move", true)
                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()
                    else
                        sfx:Play(Isaac.GetSoundIdByName("Wheeze"),0.5,0,false,math.random(100, 125)/100)
                    end
                end
            end
        end

end

function DESIRER:BulletCheck(bullet)
    --Humbled projectile spawnstuff
    if bullet.Parent ~= nil and bullet.Parent.Type == BotB.Enums.Entities.DESIRER.TYPE and bullet.Parent.Variant == BotB.Enums.Entities.DESIRER.VARIANT then
        
      --effect:PlaySound(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,math.random(120,150)/100)
      if bullet:IsDead() then
        local dumbass = Isaac.GetEntityVariantByName("Snack")
        sfx:Play(SoundEffect.SOUND_CLAP,1,0,false,math.random(120,150)/100)
        local idiot = Isaac.Spawn(EntityType.ENTITY_SWARM_SPIDER, dumbass, 0, bullet.Position, Vector.Zero, bullet.Parent)
        idiot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        bullet:Remove()
      end
    end
    

end



Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DESIRER.NPCUpdate, Isaac.GetEntityTypeByName("Starver"))
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, DESIRER.BulletCheck)