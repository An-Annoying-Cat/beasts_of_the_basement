local Mod = BotB
local WARRIOR = {}
local Entities = BotB.Enums.Entities
local mod = FiendFolio
print("Shunglewifhsjdkn")
function WARRIOR:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local warriorPathfinder = npc.Pathfinder


    if npc.Type == BotB.Enums.Entities.WARRIOR.TYPE and npc.Variant == BotB.Enums.Entities.WARRIOR.VARIANT then 
        --States:
        --99: Idle
        --100: Shoot
        if data.warriorAttackCooldownMax == nil then
            data.warriorAttackCooldownMax = 45
            data.warriorAttackCooldown = 30
            data.botbWarriorSmallJumpCooldownMax = 60
            data.botbWarriorSmallJumpCooldown = data.botbWarriorSmallJumpCooldownMax
            data.botbWarriorBigJumpCooldownMax = 80
            data.botbWarriorBigJumpCooldown = data.botbWarriorBigJumpCooldownMax
            data.botbWarriorBigJumpBaseFrame = 0
            data.botbWarriorIsMidair = false
            data.botbWarriorTimesJumped = 0
        end

        if data.botbWarriorIsMidair == false then
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
        else
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            end
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            end
        end

        if npc.State == 0 then
            --Init
            
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end
        --
        if npc.State == 99 then
            npc.Velocity = 0.8 * npc.Velocity  
            if npc.FrameCount % 6 == 0 then
                npc.Velocity = npc.Velocity + Vector(3,0):Rotated(targetangle)
            end          
            if data.botbWarriorSmallJumpCooldown ~= 0 then
                data.botbWarriorSmallJumpCooldown = data.botbWarriorSmallJumpCooldown - 1
            else
                if targetdistance >= 120 and targetdistance <= 240 and Isaac.CountEntities(npc,FiendFolio.FF.BlastedMine.ID, FiendFolio.FF.BlastedMine.Var, 0) < 2 then
                    data.botbWarriorTimesJumped = 0
                    npc.State = 98
                    data.botbWarriorSmallJumpCooldown = data.botbWarriorSmallJumpCooldownMax
                    data.botbWarriorJumpTarget = Game():GetRoom():FindFreePickupSpawnPosition(targetpos)
                    local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,data.botbWarriorJumpTarget,Vector(0,0),nil):ToEffect()
                                    warningTarget.Color = Color(1,1,1,1,2,1,1)
                                    warningTarget.SpriteScale = Vector(1,1)
                    sprite:Play("Jump")
                end
                
            end

            if data.warriorAttackCooldown ~= 0 then
                data.warriorAttackCooldown = data.warriorAttackCooldown - 1
            else
                npc.State = 100
                data.warriorAttackCooldown = data.warriorAttackCooldownMax
                sprite:Play("Shoot")
            end
            
        end

        if npc.State == 100 then
            npc.Velocity = 0.4 * npc.Velocity  
            if sprite:IsEventTriggered("Shit") then
                --[[
                sfx:Play(SoundEffect.SOUND_BLOODSHOOT,1,0,false,math.random(90,110)/100)
                local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_TEAR, 0, npc.Position, Vector(6,0):Rotated(targetangle), npc):ToProjectile()
                        --bullet:GetData().doSpinnyBoiBulletAccel = true
                        bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        bullet.Parent = npc
                        bullet.FallingAccel = -0.0825
                        bullet.FallingSpeed = 0
                        local bsprite = bullet:GetSprite()
                        bullet:AddProjectileFlags(ProjectileFlags.SMART | ProjectileFlags.CHANGE_FLAGS_AFTER_TIMEOUT)
                        bullet.ChangeTimeout = 8
                        bullet.ChangeFlags = (ProjectileFlags.SMART)
                        --bsprite:Load("gfx/monsters/chapter_1/mold_projectile.anm2", true)
                        --bsprite:Play("Move", true)
                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()]]
                npc:PlaySound(Isaac.GetSoundIdByName("CMonstroBarf"),0.5,0,false,math.random(200,250)/100)
                local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle-15), npc):ToProjectile();
		        projectile.FallingSpeed = -30;
		        projectile.FallingAccel = 2
		        projectile.Height = -10
                projectile:GetData().projType = "thrownbomb"
                projectile:GetData().pinkBomb = true
            end
            if sprite:IsFinished() then
                npc.State = 99

                sprite:Play("Idle")
            end
        end

        if npc.State == 98 then
            if sprite:IsEventTriggered("Shit") then
                data.botbWarriorIsMidair = true
                npc:PlaySound(Isaac.GetSoundIdByName("FunnyFart"),1,0,false,1)
                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.FART,0,npc.Position,Vector.Zero,npc)
                Isaac.Spawn(FiendFolio.FF.BlastedMine.ID, FiendFolio.FF.BlastedMine.Var, 0, npc.Position + Vector(0,5), Vector.Zero, npc):ToNPC()
            end
            if sprite:IsEventTriggered("Land") then
                data.botbWarriorIsMidair = false
                npc.Position = data.botbWarriorJumpTarget
                --npc:PlaySound(SoundEffect.SOUND_BONE_HEART,1,0,false,0.5)
            end
            if data.botbWarriorIsMidair == true then
                npc.Position = (0.75 * npc.Position) + (0.25 * data.botbWarriorJumpTarget)
            end
            if sprite:IsFinished("Jump") then
                npc.State = 97
                sprite:Play("Idle")
            end
        end

        if npc.State == 97 then
            if data.botbWarriorTimesJumped < 1 then
                data.botbWarriorJumpTarget = Game():GetRoom():FindFreePickupSpawnPosition(targetpos)
                local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,data.botbWarriorJumpTarget,Vector(0,0),nil):ToEffect()
                                warningTarget.Color = Color(1,1,1,1,2,1,1)
                                warningTarget.SpriteScale = Vector(1,1)
                npc.State = 98
                sprite:Play("Jump")
                data.botbWarriorTimesJumped = data.botbWarriorTimesJumped + 1
            else
                npc.State = 99
                sprite:Play("Idle")
                data.botbWarriorSmallJumpCooldown = data.botbWarriorSmallJumpCooldownMax + math.random(-10,10)
                data.botbWarriorTimesJumped = 0
            end
        end






    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, WARRIOR.NPCUpdate, Isaac.GetEntityTypeByName("Warrior"))




function WARRIOR:WarriorHurt(npc, damage, damageFlags, source)
	if npc.Variant == Entities.WARRIOR.VARIANT then
        if FiendFolio:HasDamageFlag(DamageFlag.DAMAGE_EXPLOSION, damageFlags) and not FiendFolio:IsPlayerDamage(source) then
			return false
	    end
    end
	
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, WARRIOR.WarriorHurt, Isaac.GetEntityTypeByName("Warrior"))