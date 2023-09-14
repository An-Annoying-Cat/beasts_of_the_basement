local Mod = BotB
local BABBY_REAL = {}
local Entities = BotB.Enums.Entities

function BABBY_REAL:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.BABBY_REAL.TYPE and npc.Variant == BotB.Enums.Entities.BABBY_REAL.VARIANT then 
        local realBabbyPathfinder = npc.Pathfinder
        if npc.State == 0 then
            --Init
            if data.botbBabbyHealthRatio == nil then
                data.botbBabbyHealthRatio = 1 --(max health)
                data.botbBabbyFakesToSpawn = 2
                data.botbBabbyRealGotHit = false --Reset this each time it disguises itself
                data.botbBabbyRealAttackTimerMax = 60 --1 sec attack cooldown
                data.botbBabbyRealAttackTimer = data.botbBabbyRealAttackTimerMax
                data.botbBabbyTransformProjParams = ProjectileParams()
                data.botbBabbyTransformProjParams.VelocityMulti = 2
                data.botbBabbyAttackProjParams = ProjectileParams()
                --data.botbBabbyAttackProjParams.BulletFlags = ProjectileFlags.RED_CREEP
                data.botbBabbyAttackProjParams.VelocityMulti = 0.5
                data.botbBabbyRealHealthCheck = npc.HitPoints
            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("RealIntroVanish")
            end
        end

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end

        --States:
        --99: Intro teleport out (so it can spawn the fake ones)
        --100: Teleport in, disguised
        --101: Disguised idle
        --102: Disguise broken, becomes true form
        --103: Chase in true form
        --104: Shoot in true form
        --105: Teleport out, return to 100 after spawning minions
        if npc.State == 99 then
            if sprite:IsEventTriggered("Back") then
                --Choose a random position
                npc.Position = game:GetRoom():GetRandomPosition(10)
                --Check the amount of health it has left
                --Base = 1 fake
                -->66 = 2 fakes
                -->33 = 3 fakes
                data.botbBabbyHealthRatio = npc.HitPoints / npc.MaxHitPoints
                if data.botbBabbyHealthRatio < 0.333 then
                    data.botbBabbyFakesToSpawn = 3
                elseif data.botbBabbyFakesToSpawn < 0.666 then
                    data.botbBabbyFakesToSpawn = 2
                else
                    data.botbBabbyFakesToSpawn = 1
                end
                for i=1,data.botbBabbyFakesToSpawn,1 do
                    --Spawns the fakers
                    --print("i would spawn now but it's bugged sowwy")
                    Isaac.Spawn(BotB.Enums.Entities.BABBY_FAKE.TYPE,BotB.Enums.Entities.BABBY_FAKE.VARIANT,0,game:GetRoom():GetRandomPosition(10),Vector.Zero,npc)
                end
                npc:GetData().botbBabbyRealGotHit = false
                data.botbBabbyRealHealthCheck = npc.HitPoints
                npc.State = 100
                sprite:Play("RealSpawn")
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 101
                sprite:Play("RealIdle")
            end
        end

        if npc.State == 101 then
            realBabbyPathfinder:MoveRandomly()
            if data.botbBabbyRealGotHit or data.botbBabbyRealHealthCheck > npc.HitPoints then
                npc.State = 102
                sprite:Play("RealTransform")
            end
        end

        if npc.State == 102 then
            npc.Velocity = Vector.Zero
            if sprite:IsEventTriggered("Gibs") then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 5, npc.Position, Vector.Zero, npc)
                --local params = ProjectileParams()
                
                --params.BulletFlags = ProjectileFlags.ACID_RED
                game:ShakeScreen(3)
                npc:PlaySound(SoundEffect.SOUND_ROCKET_BLAST_DEATH, 0.4, 0, false, 0.5)
                npc:PlaySound(SoundEffect.SOUND_FART_GURG, 1, 0, false, 0.75)
                npc:FireBossProjectiles(10, npc.Position, 6, data.botbBabbyTransformProjParams)
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector.Zero, npc):ToEffect()
                creep.SpriteScale = Vector(2.5, 2.5)
                creep:Update()
            end
            if sprite:IsEventTriggered("Back") then
                npc:PlaySound(FiendFolio.Sounds.FlashBaby,1,2,false,(math.random(30,40)/100))
                npc:PlaySound(FiendFolio.Sounds.FlashBaby,1,2,false,(math.random(30,40)/100))
                npc.State = 103
                sprite:Play("RealTrueChase")
            end
        end

        if npc.State == 103 then
            npc.Velocity = ((0.999 * npc.Velocity) + (0.001 * (target.Position - npc.Position))):Clamped(-10,-10,10,10)
            if npc.FrameCount % 4 == 0 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector.Zero, npc):ToEffect()
                creep.SpriteScale = Vector(1, 1)
                creep:SetTimeout(8)
                creep:Update()
            end
            if data.botbBabbyRealAttackTimer ~= 0 then
                data.botbBabbyRealAttackTimer = data.botbBabbyRealAttackTimer - 1
            else
                npc.State = 104
                sprite:Play("RealTrueShoot")
            end
        end

        if npc.State == 104 then
            if sprite:GetFrame() == 7 then
                npc:PlaySound(FiendFolio.Sounds.FlashBaby,1,2,false,(math.random(60,80)/100))
                npc:PlaySound(FiendFolio.Sounds.FlashBaby,1,2,false,(math.random(60,80)/100))
                local params = ProjectileParams()
                params.VelocityMulti = 1
                npc:FireBossProjectiles(12, targetpos, 2, data.botbBabbyAttackProjParams)
            end
            if sprite:IsEventTriggered("Back") then
                npc.State = 105
                sprite:Play("RealVanish")
                data.botbBabbyRealAttackTimer = data.botbBabbyRealAttackTimerMax
            end
        end

        if npc.State == 105 then
            if sprite:IsEventTriggered("Back") then
                --Choose a random position
                npc.Position = game:GetRoom():GetRandomPosition(10)
                --Check the amount of health it has left
                --Base = 2 fakes
                -->66 = 3 fakes
                -->33 = 4 fakes
                data.botbBabbyHealthRatio = npc.HitPoints / npc.MaxHitPoints
                if data.botbBabbyHealthRatio < 0.333 then
                    data.botbBabbyFakesToSpawn = 4
                elseif data.botbBabbyFakesToSpawn < 0.666 then
                    data.botbBabbyFakesToSpawn = 3
                else
                    data.botbBabbyFakesToSpawn = 2
                end
                for i=1,data.botbBabbyFakesToSpawn,1 do
                    --Spawns the fakers
                    Isaac.Spawn(BotB.Enums.Entities.BABBY_FAKE.TYPE,BotB.Enums.Entities.BABBY_FAKE.VARIANT,0,game:GetRoom():GetRandomPosition(10),Vector.Zero,npc)
                end
                npc:GetData().botbBabbyRealGotHit = false
                data.botbBabbyRealHealthCheck = npc.HitPoints
                npc.State = 100
                sprite:Play("RealSpawn")
            end
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BABBY_REAL.NPCUpdate, Isaac.GetEntityTypeByName("Babby (Real)"))



function BABBY_REAL:DamageCheck(npc, _, _, _, _)
    --print("sharb")
    if npc.Type == BotB.Enums.Entities.BABBY_REAL.TYPE and npc.Variant == BotB.Enums.Entities.BABBY_REAL.VARIANT then 
        if npc.State == 101 then
            npc:GetData().botbBabbyRealGotHit = true
        end
        if npc.State == 99 or npc.State == 100 or npc.State == 105 then
            return false
            --States you cant hurt it in
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BABBY_REAL.DamageCheck, Isaac.GetEntityTypeByName("Babby (Fake)"))



function BABBY_REAL:BulletCheck(bullet)

    --Seducer projectiles spawn red creep when they splat
    if bullet.SpawnerType == BotB.Enums.Entities.BABBY_REAL.TYPE and bullet.SpawnerVariant == BotB.Enums.Entities.BABBY_REAL.VARIANT then
        
        
        if bullet:IsDead() then
            sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,0.25,0,false,math.random(120,150)/100)
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, bullet.Position, Vector(0,0), bullet):ToEffect()
            creep:SetTimeout(40)
            creep:Update()
        end
    end
    

end
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, BABBY_REAL.BulletCheck)