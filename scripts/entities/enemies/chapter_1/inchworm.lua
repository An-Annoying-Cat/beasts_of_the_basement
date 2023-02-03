local Mod = BotB
local INCH_WORM = {}
local Entities = BotB.Enums.Entities

function INCH_WORM:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()
    


    if npc.Type == BotB.Enums.Entities.INCH_WORM.TYPE and npc.Variant == BotB.Enums.Entities.INCH_WORM.VARIANT then 
        local inchWormPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.isUnder == nil then
                --Is it underground?
                data.isUnder = false
                --What distance from the player will it come up?
                data.digDistance = 75
                --Timer for going underground and raising
                if npc.SubType ~= 1 then
                    data.underTimerMax = 10
                else
                    data.underTimerMax = 5
                end
                data.underTimer = data.underTimerMax
                --Using this to delay where they shoot towards
                data.fireAtPos = npc.Position
                --Using this to better find a spot near the player to dig up at
                data.digPos = nil
                data.gotValidDigPos = false
                if npc.SubType == 2 then
                    data.fireDirAlt = false
                end
                if npc.SubType == 3 or npc.SubType == 4 then
                    data.underTimerMax = 120
                    data.isMealWormMoving = true
                    --data.mealWormRandomPatrolPos = room:GetRandomPosition(0)
                    npc.Friction = 1
                    npc.GridCollisionClass = GridCollisionClass.COLLISION_SOLID
                    data.digDistance = 25
                end
            end
            npc.State = 99
            sprite:Play("Idle")
        end
        --States:
        --99: Aboveground
        --100: Go below
        --101: Underground
        --102: Shoot/Surface

        --print(targetdistance)
        --aboveground countin down
        if npc.State == 99 then
            if data.underTimer == 0 then
                if targetdistance >= data.digDistance + 25 then
                    npc.State = 100
                    sprite:Play("DigIn")
                    if npc.SubType == 3 or npc.SubType == 4 then
                        data.underTimer = math.floor(data.underTimerMax/4)
                    else
                        data.underTimer = data.underTimerMax
                    end
                else
                    npc.State = 99
                    sprite:Play("Idle")
                    data.underTimer = data.underTimerMax
                end
                
                
            else
                data.underTimer = data.underTimer - 1
            end
        end



        if npc.State == 100 then
            --Going underground
            if npc.SubType == 3 or npc.SubType == 4 then
                data.isMealWormMoving = false
            end
            if sprite:IsEventTriggered("Back") then
                data.isUnder = true
                npc.CollisionDamage = 0
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                npc.State = 101
                data.gotValidDigPos = false
                sprite:Play("Under")
            end
        end


        --Searching for valid position to surface from underground
        if npc.State == 101 then
            if data.underTimer == 0 then
                npc.Position = data.digPos
                data.isUnder = false
                npc.CollisionDamage = 1
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                npc.State = 102
                sprite:Play("DigOut")
                data.underTimer = data.underTimerMax
            else
                --Get random position then check validity
                if data.gotValidDigPos == false then
                    data.digPos = targetpos + Vector(data.digDistance,0):Rotated(math.random(360))
                end
                if room:GetGridCollisionAtPos(data.digPos) ~= GridCollisionClass.COLLISION_NONE then
                    data.gotValidDigPos = false
                else
                    data.gotValidDigPos = true
                end
                data.underTimer = data.underTimer - 1
            end
        end

        if npc.State == 102 then
            if sprite:IsEventTriggered("PreShoot") then
                data.fireAtPos = targetpos
            end
            if sprite:IsEventTriggered("Shoot") then
                if npc.SubType == 0 or npc.SubType == nil then
                    npc:PlaySound(SoundEffect.SOUND_WORM_SPIT,0.75,0,false,math.random(150,200)/100)
                    npc:FireProjectiles(npc.Position, (data.fireAtPos - npc.Position):Normalized()*5, 0, ProjectileParams())
                end
                if npc.SubType == 1 then
                    npc:PlaySound(SoundEffect.SOUND_WORM_SPIT,0.75,0,false,math.random(110,140)/100)
                    local projectile = Isaac.Spawn(9, 0, 0, npc.Position, (data.fireAtPos - npc.Position):Normalized()*7, npc):ToProjectile();
                    projectile.FallingSpeed = -30;
                    projectile.FallingAccel = 2
                    projectile.Height = -10
                    projectile.Color = Color(0, 0.9, 0.4, 1, 0, 0, 0)
                    projectile:AddProjectileFlags(ProjectileFlags.BURST)
                end
                if npc.SubType == 2 then
                    npc:PlaySound(SoundEffect.SOUND_WORM_SPIT,0.75,0,false,math.random(110,140)/100)
                    if data.fireDirAlt then
                        local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(0,10), npc):ToProjectile();
                        projectile:AddProjectileFlags(ProjectileFlags.CURVE_LEFT | ProjectileFlags.NO_WALL_COLLIDE)
                        projectile.CurvingStrength = 0.025 
                        projectile.FallingAccel = 0.0625
                        --projectile.Color = Color(0, 0.9, 0.4, 1, 0, 0, 0)
                        local projectile2 = Isaac.Spawn(9, 0, 0, npc.Position, Vector(0,-10), npc):ToProjectile();
                        projectile2.CurvingStrength = 0.025 
                        projectile2.FallingAccel = 0.0625
                        projectile2:AddProjectileFlags(ProjectileFlags.CURVE_LEFT | ProjectileFlags.NO_WALL_COLLIDE)
                        --projectile2.Color = Color(0, 0.9, 0.4, 1, 0, 0, 0)
                        data.fireDirAlt = false
                    else
                        local projectile3 = Isaac.Spawn(9, 0, 0, npc.Position, Vector(10,0), npc):ToProjectile();
                        projectile3:AddProjectileFlags(ProjectileFlags.CURVE_LEFT | ProjectileFlags.NO_WALL_COLLIDE)
                        projectile3.CurvingStrength = 0.025 
                        projectile3.FallingAccel = 0.0625
                        --projectile.Color = Color(0, 0.9, 0.4, 1, 0, 0, 0)
                        local projectile4 = Isaac.Spawn(9, 0, 0, npc.Position, Vector(-10,0), npc):ToProjectile();
                        projectile4.CurvingStrength = 0.025 
                        projectile4:AddProjectileFlags(ProjectileFlags.CURVE_LEFT | ProjectileFlags.NO_WALL_COLLIDE)
                        projectile4.FallingAccel = 0.0625
                        --projectile2.Color = Color(0, 0.9, 0.4, 1, 0, 0, 0)
                        data.fireDirAlt = true
                    end
                end
                if npc.SubType == 3 or npc.SubType == 4 then
                    data.isMealWormMoving = true
                end
            end
            --Going underground
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end
        --
        if data.isMealWormMoving == true then
            --[[
            if npc.Target ~= nil then
                print("shitfuck")
                inchWormPathfinder:FindGridPath(targetpos, 6, 99, false)
            else
                print("fuckshit")
                if data.underTimer == 0 then
                    print("cockass")
                    repeat
                        local randoPosPreAdjust = room:GetRandomPosition(0)
                        data.mealWormRandomPatrolPos = room:FindFreeTilePosition(randoPosPreAdjust, 100)
                    until inchWormPathfinder:HasPathToPos(data.mealWormRandomPatrolPos, false) and room:GetGridCollisionAtPos(data.mealWormRandomPatrolPos) == GridCollisionClass.COLLISION_NONE
                end
                inchWormPathfinder:FindGridPath(data.mealWormRandomPatrolPos, 6, 99, false)
            end
            ]]
            if game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
                local targetvelocity = (targetpos - npc.Position):Resized(5)
                --npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.25)
                npc.Velocity = (0.75 * npc.Velocity) + (0.25 * targetvelocity)
            else
                inchWormPathfinder:FindGridPath(targetpos, 2, 1, true)
            end
            if npc.SubType == 4 and npc.FrameCount % 3 == 0 then
                npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,0.5,0,false,math.random(110,140)/100)
                local projectile = Isaac.Spawn(9, 0, 0, npc.Position, npc.Velocity+Vector(4,0):Rotated(math.random(360)), npc):ToProjectile()
                projectile.Scale = 0.5
                projectile.FallingSpeed = -15
                projectile.FallingAccel = 2
                projectile.Height = -10
            end
            if npc.SubType == 4 and npc.FrameCount % 2 == 0 then
                local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector.Zero, npc):ToEffect()
                creep.Scale = creep.Scale * 0.35
                creep:SetTimeout(40)
                creep:Update()
            end
        else
            npc.Velocity = (0.8*npc.Velocity) + (0.2*Vector.Zero)
        end
        --print(data.isMealWormMoving)
        --print(data.mealWormRandomPatrolPos)
        --npc.Velocity = Vector(55,0)

        --inchWormPathfinder:FindGridPath(targetpos, 0.7, 99, true)
        



    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, INCH_WORM.NPCUpdate, Isaac.GetEntityTypeByName("Inch Worm"))

function INCH_WORM:DamageNull(npc, _, _, _, _)
    --print("sharb")
    local data = npc:GetData()
    if npc.Type == BotB.Enums.Entities.INCH_WORM.TYPE and npc.Variant == BotB.Enums.Entities.INCH_WORM.VARIANT and data.isUnder == true then 
        --print("nope!")
        return false
    end
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, INCH_WORM.DamageNull, Isaac.GetEntityTypeByName("Inch Worm"))