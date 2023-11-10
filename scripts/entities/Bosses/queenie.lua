local Mod = BotB
local QUEENIE = {}
local Entities = BotB.Enums.Entities
--SFXManager():Play(BotB.Enums.SFX.QUEENIE_FALL,5,0,false,1,0)
----print("geo horf script loaded!")
function QUEENIE:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.QUEENIE.TYPE and npc.Variant == BotB.Enums.Entities.QUEENIE.VARIANT then 

        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local cursedPooterPathfinder = npc.Pathfinder

        --States:
        --99: Idle
        --100: Shoot
        ----print(sprite:GetFrame())
        ----print(sprite:GetAnimation())
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end

        if data.botbQueenieActionCooldown == nil then
            data.botbQueenieActionCooldown = 45
            data.botbQueenieRollDurationMax = 120
            data.botbQueenieRollDuration = 0
        end

        if npc.State == 0 then
            --Init
            sprite:SetFrame("Appear", npc.FrameCount)
            if sprite:GetFrame() == 1 then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                SFXManager():Play(BotB.Enums.SFX.QUEENIE_FALL,5,0,false,1,0)
            end

            if sprite:IsEventTriggered("Shake") then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,5,0,false,0.75,0)
                Game():ShakeScreen(30)
                local params2 = ProjectileParams()
                params2.Variant = 9
                params2.FallingSpeedModifier = 40
                params2.FallingAccelModifier = 2
                local rng = npc:GetDropRNG()
                params2.HeightModifier = FiendFolio:RandomInt(-1000, -800, rng)
                for i=0,4 do
                    params2.Scale = math.random(5,25)/10
                    npc:FireProjectiles(Game():GetRoom():GetRandomPosition(20), RandomVector() * 0.5, 0, params2)
                end
            end
            
            --
            if sprite:GetFrame() == 94 then
                SFXManager():Play(BotB.Enums.SFX.QUEENIE_HI,1,0,false,math.random(80,90)/100,0)
                npc.State = 99
                sprite:Play("Idle")
            end
        end
        if npc.State ~= 0 then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.State ~= 102 then
            npc.Velocity = 0.8*npc.Velocity
        end
        if npc.State == 99 then
            if data.botbQueenieActionCooldown ~= 0 then
                data.botbQueenieActionCooldown = data.botbQueenieActionCooldown - 1
            else
                if math.random(0,3) <= 2 then
                    --poot
                    if Isaac.CountEntities(npc, BotB.Enums.Entities.ANT.TYPE, BotB.Enums.Entities.ANT.VARIANT) < 4 then
                        SFXManager():Play(BotB.Enums.SFX.QUEENIE_GRUNT,1,0,false,math.random(80,90)/100,0)
                        --print("Poot")
                        npc.State = 100
                        sprite:Play("Poot")
                        data.botbQueenieActionCooldown = 30
                    end
                else
                    --roll
                    --print("Roll")
                    npc.State = 101
                    sprite:Play("RollStart")
                    data.botbQueenieActionCooldown = 60
                end
            end
        end
        if npc.State == 100 then
            --poot
            if sprite:IsEventTriggered("Spawn") then
                sfx:Play(Isaac.GetSoundIdByName("FunnyFart"),10,0,false,math.random(90,110)/100)
                if Isaac.CountEntities(npc, BotB.Enums.Entities.BULLET_ANT.TYPE, BotB.Enums.Entities.BULLET_ANT.VARIANT) < 1 then
                    Isaac.Spawn(BotB.Enums.Entities.BULLET_ANT.TYPE, BotB.Enums.Entities.BULLET_ANT.VARIANT, 0, npc.Position, Vector(0,-12), npc):ToNPC()
                else
                    for i=0,1 do
                        local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position + Vector(0,-65), Vector(math.floor(0.05 * targetdistance * (math.random(9, 11) / 10), 6),0):Rotated(targetangle), npc):ToProjectile()
                        bullet:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                        bullet.FallingSpeed = -30;
		                bullet.FallingAccel = 2
		                bullet.Height = -10
                        bullet.Parent = npc
                        bullet:GetData().botbSpawnAnAntPlease = true
                        local bsprite = bullet:GetSprite()
                        bsprite:Load("gfx/bosses/queenie/ant_projectile.anm2", true)
                        bsprite:Play("Move", true)
                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()
                    end
                end
                        
            end
            if sprite:IsFinished() then
                npc.State = 99
                sprite:Play("Idle")
            end

        end

        --101: roll start
        if npc.State == 101 then
            if sprite:IsFinished() then
                npc.State = 102
                sprite:Play("Roll")
                npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                if targetpos.X > npc.Position.X then
                    npc.Velocity = (0.5 * Vector(-36,0)) + (0.5 * Vector(6,0):Rotated(targetangle))
                else
                    npc.Velocity = (0.5 * Vector(36,0)) + (0.5 * Vector(6,0):Rotated(targetangle))
                end
                data.botbQueenieRollDuration = data.botbQueenieRollDurationMax
            end
        end
        --102: rolling
        if npc.State == 102 then
            npc.Velocity = 0.5*npc.Velocity + 0.5*npc.Velocity:Resized(12)
            if npc:CollidesWithGrid() then
                local room = Game():GetRoom()
                local topLeft = room:GetTopLeftPos()
                local bottomRight = room:GetBottomRightPos()
                local sizeVec = bottomRight - topLeft
                local xLowThreshold = (topLeft.X + 0.2*sizeVec.X)
                local xHighThreshold = (topLeft.X + 0.8*sizeVec.X)
                if npc.Position.X <= xLowThreshold then
                    SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,5,0,false,0.75,0)
                    Game():ShakeScreen(30)
                    local params2 = ProjectileParams()
                    params2.Variant = 9
                    params2.FallingSpeedModifier = 40
                    params2.FallingAccelModifier = 2
                    local rng = npc:GetDropRNG()
                    params2.HeightModifier = FiendFolio:RandomInt(-1000, -800, rng)
                    for i=0,4 do
                        params2.Scale = math.random(5,25)/10
                        npc:FireProjectiles(Game():GetRoom():GetRandomPosition(20), RandomVector() * 0.5, 0, params2)
                    end
                    npc:FireProjectiles(targetpos+Vector(math.random(-40,40),math.random(-40,40)), RandomVector() * 0.5, 0, params2)
                    SFXManager():Play(BotB.Enums.SFX.QUEENIE_GRUNT,1,0,false,math.random(80,90)/100,0)
                elseif npc.Position.X >= xHighThreshold then 
                    SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,5,0,false,0.75,0)
                    Game():ShakeScreen(30)
                    local params2 = ProjectileParams()
                    params2.Variant = 9
                    params2.FallingSpeedModifier = 40
                    params2.FallingAccelModifier = 2
                    local rng = npc:GetDropRNG()
                    params2.HeightModifier = FiendFolio:RandomInt(-1000, -800, rng)
                    for i=0,4 do
                        params2.Scale = math.random(5,25)/10
                        npc:FireProjectiles(Game():GetRoom():GetRandomPosition(20), RandomVector() * 0.5, 0, params2)
                    end
                    npc:FireProjectiles(targetpos+Vector(math.random(-40,40),math.random(-40,40)), RandomVector() * 0.5, 0, params2)
                    SFXManager():Play(BotB.Enums.SFX.QUEENIE_GRUNT,1,0,false,math.random(80,90)/100,0)
                end                
            end
            if data.botbQueenieRollDuration ~= 0 then
                data.botbQueenieRollDuration = data.botbQueenieRollDuration - 1
            else
                npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                npc.State = 103
                sfx:Play(Isaac.GetSoundIdByName("SkidUltraShort"),1,0,false,math.random(90,110)/100)
                sprite:Play("RollStop")
            end
        end
        --103: roll end
        if npc.State == 103 then
            if sprite:IsFinished() then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        if npc:HasMortalDamage() then
            for i=0,9 do
                BotB.FF.scheduleForUpdate(function()
                if i==9 then
                    sfx:Play(SoundEffect.SOUND_ROCKET_BLAST_DEATH,1,0,false,math.random(80,90)/100)
                else
                    if i % 2 == 0 then
                        sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS,1,0,false,math.random(120,150)/100)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_EXPLOSION,0,npc.Position+Vector(math.random(-48,48),math.random(-24,24)),Vector.Zero,npc)  
                    end
                    
                end
                
                    

                end, i*4, ModCallbacks.MC_POST_RENDER)
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, QUEENIE.NPCUpdate, Isaac.GetEntityTypeByName("Queenie"))


function QUEENIE:BulletCheck(bullet)
    --Humbled projectile spawnstuff
    if bullet.Parent ~= nil and bullet.Parent.Type == BotB.Enums.Entities.QUEENIE.TYPE and bullet.Parent.Variant == BotB.Enums.Entities.QUEENIE.VARIANT and bullet:GetData().botbSpawnAnAntPlease == true then
        
      --effect:PlaySound(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,math.random(120,150)/100)
      if bullet:IsDead() then
        local dumbass = Isaac.GetEntityVariantByName("Ant")
        sfx:Play(SoundEffect.SOUND_CLAP,1,0,false,math.random(120,150)/100)
        local idiot = Isaac.Spawn(Entities.ANT.TYPE, Entities.ANT.VARIANT, 0, bullet.Position, Vector.Zero, bullet.Parent)
        idiot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        bullet:Remove()
      end
    end
    

end
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, QUEENIE.BulletCheck)



function QUEENIE:firstDegreeMurder(queen, victim, low)
    if queen.Type ~= Entities.QUEENIE.TYPE or queen.Variant ~= Entities.QUEENIE.VARIANT then return end
    if queen.State ~= 102 then return end
    if victim.Type == Entities.ANT.TYPE and victim.Variant == Entities.ANT.VARIANT then
        --squish >:3
        sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,math.random(80,90)/100)
            local creep = Isaac.Spawn(1000, EffectVariant.CREEP_RED, 0, victim.Position, Vector(0,0), queen)
            creep.SpriteScale = creep.SpriteScale * 2
            creep:Update()
            victim:Kill()
    end
    if victim.Type == Entities.BULLET_ANT.TYPE and victim.Variant == Entities.BULLET_ANT.VARIANT then
        --squish >:3
        sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,math.random(80,90)/100)
            local creep = Isaac.Spawn(1000, EffectVariant.CREEP_RED, 0, victim.Position, Vector(0,0), queen)
            creep.SpriteScale = creep.SpriteScale * 4
            creep:Update()
            victim:Kill()
    end
    if victim.Type == Entities.SUPER_BULLET_ANT.TYPE and victim.Variant == Entities.SUPER_BULLET_ANT.VARIANT then
        --squish >:3
        sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,math.random(80,90)/100)
            local creep = Isaac.Spawn(1000, EffectVariant.CREEP_RED, 0, victim.Position, Vector(0,0), queen)
            creep.SpriteScale = creep.SpriteScale * 4
            creep:Update()
            victim:Kill()
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, QUEENIE.firstDegreeMurder, Isaac.GetEntityTypeByName("Queenie"))