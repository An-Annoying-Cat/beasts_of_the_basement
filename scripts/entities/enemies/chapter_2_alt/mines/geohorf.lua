local Mod = BotB
local GEO_HORF = {}
local Entities = BotB.Enums.Entities
--print("geo horf script loaded!")
function GEO_HORF:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local cursedPooterPathfinder = npc.Pathfinder


    if npc.Type == BotB.Enums.Entities.GEO_HORF.TYPE and npc.Variant == BotB.Enums.Entities.GEO_HORF.VARIANT then 
        --States:
        --99: Idle
        --100: Shoot
        if data.geoHorfAttackCooldownMax == nil then
            data.geoHorfAttackCooldownMax = 180
            data.geoHorfAttackCooldown = 90
            data.geoHorfDoBouncedLaser = false
            data.geoHorfBouncedLaserPos = Vector.Zero
            data.geoHorfBouncedLaserAngle = 0
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 0 then
            --Init
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Shake")
            end
        end

        if npc.State == 99 then
            npc.Velocity = 0.8 * npc.Velocity
            --cursedPooterPathfinder:MoveRandomly(true)
            if data.geoHorfAttackCooldown ~= 0 then
                data.geoHorfAttackCooldown = data.geoHorfAttackCooldown - 1
            else
                npc.State = 100
                data.geoHorfAttackCooldown = data.geoHorfAttackCooldownMax
                sprite:Play("Attack")
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                sfx:Play(BotB.Enums.SFX.CRYSTAL_FIRE,1,0,false,math.random(90,110)/100)
                --SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK,1,0,false,math.random(90,110)/100)
                --local geoHorfProjParams = ProjectileParams()
                --geoHorfProjParams.ChangeTimeout = 60
                --geoHorfProjParams.ChangeVelocity = 4
                --geoHorfProjParams.BulletFlags = 
                --local geoHorfProjectile = npc:FireProjectiles(npc.Position, Vector(0.01,0):Rotated(targetangle), 0, geoHorfProjParams)
                --
                local geoHorfProjectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,npc.Position, Vector(0.001,0):Rotated(targetangle),npc):ToProjectile()
                geoHorfProjectile.ChangeTimeout = 30
                geoHorfProjectile.ChangeVelocity = 11
                geoHorfProjectile.FallingSpeed = 0
                geoHorfProjectile.FallingAccel = -0.1
                geoHorfProjectile:AddProjectileFlags(ProjectileFlags.BOUNCE | ProjectileFlags.BOUNCE_FLOOR | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.CHANGE_VELOCITY_AFTER_TIMEOUT)
                geoHorfProjectile.Parent = npc
                --geoHorfProjectile:GetData().botbGeoHorfNewLaserCountdown = -1
                geoHorfProjectile:AddScale(-0.99)
                local geoHorfLaser = EntityLaser.ShootAngle(2, npc.Position, targetangle, 480, Vector.Zero, npc):ToLaser()
                geoHorfLaser.SubType = 4
                geoHorfLaser.Color = Color(0,0,0,1,1,0,1)
                --geoHorfLaser:AddTearFlags(TearFlags.TEAR_BOUNCE)
                geoHorfLaser:SetMaxDistance(1)
                geoHorfLaser.Parent = geoHorfProjectile
                --geoHorfLaser.OneHit = true
                geoHorfLaser.DisableFollowParent = true
                geoHorfLaser:Update()
                geoHorfLaser:GetData().isBotbGeoHorfLaser = true
                --geoHorfLaser:GetData().StartingAngle = targetangle
                
            end
            if sprite:IsFinished() then
                npc.State = 99
                sprite:Play("Shake")
            end
        end

        --do a bounced laser
        if data.geoHorfDoBouncedLaser == true then
            data.geoHorfDoBouncedLaser = false
                if geoHorfProjectile ~= nil then
                    geoHorfProjectile:Remove()
                end
                --SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK,1,0,false,math.random(90,110)/100)
                --local geoHorfProjParams = ProjectileParams()
                --geoHorfProjParams.ChangeTimeout = 60
                --geoHorfProjParams.ChangeVelocity = 4
                --geoHorfProjParams.BulletFlags = 
                --local geoHorfProjectile = npc:FireProjectiles(npc.Position, Vector(0.01,0):Rotated(targetangle), 0, geoHorfProjParams)
                --
                local geoHorfProjectile = Isaac.Spawn(EntityType.ENTITY_PROJECTILE,ProjectileVariant.PROJECTILE_NORMAL,0,data.geoHorfBouncedLaserPos, Vector(0.001,0):Rotated(data.geoHorfBouncedLaserAngle),npc):ToProjectile()
                geoHorfProjectile.ChangeTimeout = 30
                geoHorfProjectile.ChangeVelocity = 11
                geoHorfProjectile.FallingSpeed = 0
                geoHorfProjectile.FallingAccel = -0.1
                geoHorfProjectile:AddProjectileFlags(ProjectileFlags.BOUNCE | ProjectileFlags.BOUNCE_FLOOR | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.CHANGE_VELOCITY_AFTER_TIMEOUT)
                geoHorfProjectile.Parent = npc
                geoHorfProjectile:AddScale(-0.99)
                local geoHorfLaser = EntityLaser.ShootAngle(2, data.geoHorfBouncedLaserPos, data.geoHorfBouncedLaserAngle, 480, Vector.Zero, npc):ToLaser()
                geoHorfLaser.SubType = 4
                geoHorfLaser.Color = Color(0,0,0,1,1,0,1)
                --geoHorfLaser:AddTearFlags(TearFlags.TEAR_BOUNCE)
                geoHorfLaser:SetMaxDistance(1)
                geoHorfLaser.Parent = geoHorfProjectile
                --geoHorfLaser.OneHit = true
                geoHorfLaser.DisableFollowParent = true
                geoHorfLaser:Update()
                geoHorfLaser:GetData().isBotbGeoHorfLaser = true
                --geoHorfLaser:GetData().StartingAngle = targetangle
                
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GEO_HORF.NPCUpdate, Isaac.GetEntityTypeByName("Geo Horf"))


--
function GEO_HORF:BulletCheck(bullet)
    local sprite = bullet:GetSprite()
    --Invisible intangible projectile that handles the slow laser
    if bullet.Parent ~= nil and bullet.Parent.Type == BotB.Enums.Entities.GEO_HORF.TYPE and bullet.Parent.Variant == BotB.Enums.Entities.GEO_HORF.VARIANT then

        --if bullet:GetData().botbGeoHorfNewLaserCountdown == nil then
        --    bullet:GetData().botbGeoHorfNewLaserCountdown = -1
        --end

        if bullet.FrameCount == 1 then
            bullet:GetData().botbGeoHorfBulletStartAngle = math.floor(bullet.Velocity:GetAngleDegrees())
            sprite.Color = Color(1,1,1,0)
            --Make it invisible
        end
        if bullet.FrameCount >= 480 then
            bullet:Remove()
        end
        --[[
        if bullet:GetData().botbTimeForNewGeoHorfLaser then
            print('initiated countdown')
            bullet:GetData().botbGeoHorfNewLaserCountdown = 2
            bullet:GetData().botbTimeForNewGeoHorfLaser = false
        end
        print(bullet:GetData().botbGeoHorfNewLaserCountdown)]]
        --[[
        local geoHorfLaser = EntityLaser.ShootAngle(2, bullet.Position, bullet.Velocity:GetAngleDegrees(), 480, Vector.Zero, bullet):ToLaser()
                geoHorfLaser.SubType = 4
                geoHorfLaser:AddTearFlags(TearFlags.TEAR_BOUNCE)
                geoHorfLaser:SetMaxDistance(60)
                geoHorfLaser.Parent = bullet
                --geoHorfLaser.Time
                geoHorfLaser:Update()
                geoHorfLaser:GetData().isBotbGeoHorfLaser = true]]
        --[[
        if bullet:GetData().botbGeoHorfNewLaserCountdown > 0 then
            print(bullet:GetData().botbGeoHorfNewLaserCountdown)
            bullet:GetData().botbGeoHorfNewLaserCountdown = bullet:GetData().botbGeoHorfNewLaserCountdown - 1
        elseif bullet:GetData().botbGeoHorfNewLaserCountdown == 0 then
            print("GO")
            bullet.Parent:GetData().geoHorfBouncedLaserPos = bullet.Position 
            bullet.Parent:GetData().geoHorfBouncedLaserAngle = bullet.Velocity:GetAngleDegrees()
            bullet.Parent:GetData().geoHorfDoBouncedLaser = true
        end
        ]]
        if math.floor(bullet.Velocity:GetAngleDegrees()) ~= bullet:GetData().botbGeoHorfBulletStartAngle then
            --print("GO")
            bullet.Parent:GetData().geoHorfBouncedLaserPos = bullet.Position 
            bullet.Parent:GetData().geoHorfBouncedLaserAngle = bullet.Velocity:GetAngleDegrees()
            bullet.Parent:GetData().geoHorfDoBouncedLaser = true
            bullet.Velocity = Vector.Zero
            bullet:Remove()
        end
        


      end
    

end

Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, GEO_HORF.BulletCheck)


function GEO_HORF:LaserCheck(laser)
    local data = laser:GetData()
    if not data.isBotbGeoHorfLaser == true then return end
    local sprite = laser:GetSprite()
    if data.isBotbGeoHorfLaser == true and (laser.Parent == nil or laser.Parent.Parent == nil) then
        laser:Remove()
    end
        
        --print(laser.Position:Distance(laser:GetEndPoint()))
        if laser.Position:Distance(laser:GetEndPoint()) < 33 and laser.FrameCount >= 30 then
            --print("gunt")
            --scrontch
            --data.botbGeoHorfScronchFrame = 0
            --laser.Parent:GetData().botbTimeForNewGeoHorfLaser = true
            laser:Remove()
        end
        --laser.Velocity = FiendFolio:diagonalMove(laser, 2, 1)
        if sprite.Color ~= Color(0,0,0,1,1,0,1) then
            sprite.Color = Color(0,0,0,1,1,0,1)
            --crystal colored
        end
        --
        if laser.FrameCount <= 30 then
            laser:SetMaxDistance(laser.FrameCount*4)
            if laser.Parent ~= nil then
                laser.Parent.Position = laser.Position
            end
        else
            if laser.Parent ~= nil then
            laser.Parent.Position = laser.Position
            laser.Velocity = laser.Parent.Velocity
            laser.Angle = laser.Parent.Velocity:GetAngleDegrees()
            else
                laser:Remove()
            end
            
        end
    
    
    
    

end

Mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, GEO_HORF.LaserCheck)


--
function GEO_HORF:DamageCheck(npc, _, _, source, _)
    --print("sharb")
    local npcConv = npc:ToNPC()
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Type == BotB.Enums.Entities.GEO_HORF.TYPE and npc.Variant == BotB.Enums.Entities.GEO_HORF.VARIANT then 
        if source.Entity.Type == 501 and source.Entity.Variant == 41 then
            return false
        end
        
        
    end
    --return true
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, GEO_HORF.DamageCheck, Isaac.GetEntityTypeByName("Geo Horf"))