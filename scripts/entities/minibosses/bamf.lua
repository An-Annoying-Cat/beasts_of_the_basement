local Mod = BotB
local BAMF = {}
local Entities = BotB.Enums.Entities

function BAMF:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.BAMF.TYPE and npc.Variant == BotB.Enums.Entities.BAMF.VARIANT then 
        if npc.State == 0 then
            if data.bamfAttackCooldownMax == nil then
                --Spit cooldown
                data.bamfAttackCooldownMax = 120
                data.bamfAttackCooldown = data.bamfAttackCooldownMax
                --Shit cooldown
                data.bamfAttack2CooldownMax = 240
                data.bamfAttack2Cooldown = data.bamfAttack2CooldownMax
                --Ram cooldown
                data.bamfAttack3CooldownMax = 320
                data.bamfAttack3Cooldown = data.bamfAttack3CooldownMax
            end
            sprite:Play("Idle")
            npc.State = 99
        end
        --States:
        --99: IDle
        --100: Spit
        --101: Shit
        --102: Ram start
        --103: Ram 
        --104: Ram End
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end
        
        if npc.State == 99 then
            --Chase
            npc.Velocity = ((0.995*npc.Velocity) + (0.005*Vector(16,0):Rotated(targetangle))):Clamped(-8,-8,8,8)
            --Cooldowns
            if data.bamfAttackCooldown ~= 0 then
                data.bamfAttackCooldown = data.bamfAttackCooldown - 1
            end
            if data.bamfAttack2Cooldown ~= 0 then
                data.bamfAttack2Cooldown = data.bamfAttack2Cooldown - 1
            end
            if data.bamfAttack3Cooldown ~= 0 then
                data.bamfAttack3Cooldown = data.bamfAttack3Cooldown - 1
            end

            if data.bamfAttackCooldown == 0 then
                --Count the attack flies
                if Isaac.CountEntities(npc, 18, 0,0) < 2 then
                    --Can do the spit attack
                    npc:PlaySound(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, math.random(125,150)/100)
                    npc.State = 100
                    sprite:Play("Spit")
                end
            end
            if data.bamfAttack2Cooldown == 0 then
                --Count the level 2 flies
                if Isaac.CountEntities(npc, 214, 0,0) < 1 then
                    --Can shit himself
                    npc:PlaySound(SoundEffect.SOUND_MONSTER_GRUNT_4, 1, 0, false, math.random(125,150)/100)
                    npc.State = 101
                    sprite:Play("Shit")
                end
            end
            if data.bamfAttack3Cooldown == 0 then
                --No counting required, just do the ram
                npc:PlaySound(SoundEffect.SOUND_ANGRY_GURGLE, 1, 0, false, math.random(125,150)/100)
                npc.State = 102
                sprite:Play("RamStart")
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Spit") then
                npc:PlaySound(BotB.Enums.SFX.DESIRER_ATTACK, 1, 0, false, math.random(125,150)/100)
                local bamfFlyball = Isaac.Spawn(BotB.Enums.Entities.BAMF_FLYBALL.TYPE, BotB.Enums.Entities.BAMF_FLYBALL.VARIANT, 0, npc.Position, Vector(14,0):Rotated(targetangle), npc):ToNPC()
                bamfFlyball.Parent = npc
                --Spawn fly ball
            end
            if sprite:IsEventTriggered("Back") then
                data.bamfAttackCooldown = data.bamfAttackCooldownMax
                sprite:Play("Idle")
                npc.State = 99
            end
        end

        if npc.State == 101 then
            if sprite:IsEventTriggered("Shit") then
                npc:PlaySound(SoundEffect.SOUND_FART, 1, 0, false, math.random(65,85)/100)
                local bamfLvl2Fly = Isaac.Spawn(214, 0, 0, npc.Position, Vector(10,0):Rotated(math.random(360)), npc):ToNPC()
                bamfLvl2Fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                bamfLvl2Fly.MaxHitPoints = 0.5 * bamfLvl2Fly.MaxHitPoints
                bamfLvl2Fly.HitPoints = bamfLvl2Fly.MaxHitPoints 
                local bamfLvl2Fly2 = Isaac.Spawn(214, 0, 0, npc.Position, Vector(10,0):Rotated(math.random(360)), npc):ToNPC()
                bamfLvl2Fly2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                Game():ButterBeanFart(npc.Position, 300, npc, true, false)
            end
            if sprite:IsEventTriggered("Back") then
                data.bamfAttack2Cooldown = data.bamfAttack2CooldownMax
                sprite:Play("Idle")
                npc.State = 99
            end
        end
        --Ram start
        if npc.State == 102 then
            npc.Velocity = 0.5*npc.Velocity
            if sprite:IsEventTriggered("Back") then
                npc.Velocity = Vector(16,0):Rotated(targetangle)
                sprite:Play("RamLoop")
                npc.State = 103
            end
        end
        --Ram loop
        if npc.State == 103 then
            npc.Velocity = ((0.975*npc.Velocity) + (0.025*Vector(20,0):Rotated(targetangle))):Clamped(-20,-20,20,20)
            if npc:CollidesWithGrid() then
                --creep and stuff
                
                local params = ProjectileParams()
                params.VelocityMulti = 3
                game:ShakeScreen(6)
                npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, 1)
                npc:FireBossProjectiles(10, npc.Position, 10, params)
                npc:FireBossProjectiles(10, npc.Position, 10, params)
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), npc):ToEffect()
                local newScale = Vector(4,4)
                --print(newScale)
                creep.SpriteScale = newScale
                creep.Timeout = 75
                creep:Update()
                sprite:Play("RamEnd")
                npc.State = 104
            end
        end
        --Ram end
        if npc.State == 104 then
            if sprite:IsEventTriggered("Back") then
                sprite:Play("Idle")
                data.bamfAttack3Cooldown = data.bamfAttack3CooldownMax
                npc.State = 99
            end
        end







    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BAMF.NPCUpdate, Isaac.GetEntityTypeByName("Bamf"))




function BAMF:FlyBallUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.BAMF_FLYBALL.TYPE and npc.Variant == BotB.Enums.Entities.BAMF_FLYBALL.VARIANT then 
        if npc.State == 0 then
            sprite:Play("Idle")
            npc.State = 99
        end
        if npc.Parent == nil then
            npc:Remove()
        end
        --States: 99 (flying)
        --States: 100 (explode)
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
        if npc.State == 99 then
            if npc:CollidesWithGrid() then
                npc.State = 100
                sprite:Play("Explode")
            end
        end
        if npc.State == 100 then
            npc.Velocity = Vector.Zero
            if sprite:IsFinished("Explode") then
                --Spawn the flies
                local spawnedFly = Isaac.Spawn(18, 0, 0, npc.Position, Vector(0,0), npc.Parent)
                spawnedFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                spawnedFly.Velocity = Vector(12,0):Rotated(math.random(0,360))
                local spawnedFly2 = Isaac.Spawn(18, 0, 0, npc.Position, Vector(0,0), npc.Parent)
                spawnedFly2:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                spawnedFly2.Velocity = Vector(12,0):Rotated(math.random(0,360))
                local spawnedFly3 = Isaac.Spawn(18, 0, 0, npc.Position, Vector(0,0), npc.Parent)
                spawnedFly3:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                spawnedFly3.Velocity = Vector(12,0):Rotated(math.random(0,360))
                npc:BloodExplode()
                npc:Remove()
            end
        end
        
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BAMF.FlyBallUpdate, Isaac.GetEntityTypeByName("Bamf Flyball"))