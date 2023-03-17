local Mod = BotB
local SPIDERBOI = {}
local Entities = BotB.Enums.Entities
local ff = BotB.FiendFolio
local ff = FiendFolio

--Normal
function SPIDERBOI:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.SPIDERBOI.TYPE and npc.Variant == BotB.Enums.Entities.SPIDERBOI.VARIANT then 
        local spiderBoiPathfinder = npc.Pathfinder
        if data.sBoiMovementChangeTimerMax == nil then
            data.sBoiMovementChangeTimerMax = 150
            data.sBoiMovementChangeTimer = data.sBoiMovementChangeTimerMax
            data.sBoiProjTimerMax = 75
            data.sBoiProjTimer = data.sBoiProjTimerMax
            data.sBoiPouncePos = Vector.Zero
            data.sBoiIsAirborne = false
        end
        if npc.State == 0 then
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
                npc:PlaySound(BotB.Enums.SFX.SPIDERBOI_APPEAR, 1, 0, false, 1)
                sprite:Play("WalkVert")
                npc.State = 99
            end
        end  
        --States:
        --99: Chase
        --100: Pounce
        --101: Short spit
        --102: Long spit (Brood projectile)
        --103: Long spit (Web projectile)
        if npc.State == 99 then
            spiderBoiPathfinder:FindGridPath(targetpos, 0.7, 1, false)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            if data.sBoiMovementChangeTimer ~= 0 then
                data.sBoiMovementChangeTimer = data.sBoiMovementChangeTimer- 1
            else
                npc.State = 100
                sprite:Play("Pounce")
                data.sBoiPouncePos = targetpos
            end
            if data.sBoiProjTimer ~= 0 then
                data.sBoiProjTimer = data.sBoiProjTimer - 1
            else
                --If it's closer to the player, do the line of 3 white creep projectiles
                --If it's further, and the spiders count less than 3, do the brood projectile. Otherwise, do the web one.
                if targetdistance <= 150 then
                    npc.State = 101
                    sprite:Play("ShootShort")
                else
                    if Isaac.CountEntities(npc, 85, 0,0) < 2 then
                        --Can spawn spiders
                        
                        npc.State = 102
                        sprite:Play("Shoot")
                    else
                        
                        npc.State = 103
                        sprite:Play("Shoot")
                    end
                end
            end
        end 
        --Trite jump
        if npc.State == 100 then
            if sprite:IsEventTriggered("Jump") then
                npc:PlaySound(BotB.Enums.SFX.SPIDERBOI_JUMP, 1, 0, false, 1)
                data.sBoiIsAirborne = true
            end
            if sprite:IsEventTriggered("Land") then
                data.sBoiIsAirborne = false
            end
            if sprite:IsEventTriggered("Back") then
                data.sBoiMovementChangeTimer = data.sBoiMovementChangeTimerMax
                sprite:Play("WalkVert")
                npc.State = 99
            end
        end

        if data.sBoiIsAirborne then
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            end
            --This should make him jump more like a Trite
            npc.Position = (0.75*npc.Position) + (0.25*data.sBoiPouncePos)
        else
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
        end

        --Short spit
        if npc.State == 101 then
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(BotB.Enums.SFX.SPIDERBOI_SPIT, 1, 0, false, 1)
                --[[
                local spiderBoiSmallProjParams = ProjectileParams()
                spiderBoiSmallProjParams.Color = Color(1,1,1,1)
                spiderBoiSmallProjParams.Variant = ProjectileVariant.PROJECTILE_TEAR
                spiderBoiSmallProjParams.BulletFlags = ProjectileFlags.GOO
                npc:FireProjectiles(npc.Position, Vector(8,0):Rotated(targetangle), 0, spiderBoiSmallProjParams)
                npc:FireProjectiles(npc.Position, Vector(6,0):Rotated(targetangle), 0, spiderBoiSmallProjParams)
                npc:FireProjectiles(npc.Position, Vector(4,0):Rotated(targetangle), 0, spiderBoiSmallProjParams)
                ]]
                for i=0,2,1 do
                    local proj = Isaac.Spawn(9, 8, 0, npc.Position-Vector(0,10), Vector(3.5*i,0):Rotated(targetangle), npc):ToProjectile()
                    local pSprite = proj:GetSprite()
                    pSprite:Load("gfx/monsters/miniboss/projectile_broodEgg_spiderboi.anm2", true)
                    pSprite:Play("Projectile", true)
                    proj:GetData().projType = "sBoiCreep"
                    proj.Scale = 0.5
                    proj:GetData().target = target
                    proj.Parent = npc
                    proj.FallingAccel = 1
                    proj.FallingSpeed = -25
                    proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.NO_WALL_COLLIDE
                    if ff:isFriend(npc) then
                        proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
                        proj:GetData().friend = true
                    elseif ff:isCharm(npc) then
                        proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER
                        proj:GetData().friend = true
                    end
                    proj:Update()
                end
                




            end
            if sprite:IsEventTriggered("Back") then
                data.sBoiProjTimer = data.sBoiProjTimerMax
                sprite:Play("WalkVert")
                npc.State = 99
            end
        end
        --Long spit (spider)
        if npc.State == 102 then
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(BotB.Enums.SFX.SPIDERBOI_SPIT, 1, 0, false, 1)
                local proj = Isaac.Spawn(9, 8, 0, npc.Position-Vector(0,10), (target.Position-npc.Position)*0.03, npc):ToProjectile()
                local pSprite = proj:GetSprite()
                pSprite:Load("gfx/monsters/miniboss/projectile_broodEgg_spiderboi.anm2", true)
                pSprite:Play("Projectile", true)
                proj:GetData().projType = "sBoiBrood"
                proj:GetData().target = target
                proj.Parent = npc
                proj.FallingAccel = 1
                proj.FallingSpeed = -25
                proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.NO_WALL_COLLIDE
                if ff:isFriend(npc) then
                    proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
                    proj:GetData().friend = true
                elseif ff:isCharm(npc) then
                    proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER
                    proj:GetData().friend = true
                end
                proj:Update()

            end
            if sprite:IsEventTriggered("Back") then
                data.sBoiProjTimer = data.sBoiProjTimerMax
                sprite:Play("WalkVert")
                npc.State = 99
            end
        end
        --Long spit (web)
        if npc.State == 103 then
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(BotB.Enums.SFX.SPIDERBOI_SPIT, 1, 0, false, 1)
                --Web projectile
                local proj = Isaac.Spawn(9, 8, 0, npc.Position-Vector(0,10), (target.Position-npc.Position)*0.03, npc):ToProjectile()
                local pSprite = proj:GetSprite()
                pSprite:Load("gfx/monsters/miniboss/projectile_broodEgg_spiderboi.anm2", true)
                pSprite:Play("Projectile", true)
                proj.Color = Color(0.8,0.8,0.8)
                proj.Scale = 2.5
                proj:GetData().projType = "sBoiWeb"
                proj:GetData().target = target
                proj.Parent = npc
                proj.FallingAccel = 1
                proj.FallingSpeed = -25
                proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.NO_WALL_COLLIDE
                if ff:isFriend(npc) then
                    proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES
                    proj:GetData().friend = true
                elseif ff:isCharm(npc) then
                    proj.ProjectileFlags = proj.ProjectileFlags | ProjectileFlags.CANT_HIT_PLAYER
                    proj:GetData().friend = true
                end
                proj:Update()

            end
            if sprite:IsEventTriggered("Back") then
                data.sBoiProjTimer = data.sBoiProjTimerMax
                sprite:Play("WalkVert")
                npc.State = 99
            end
        end


    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SPIDERBOI.NPCUpdate, Isaac.GetEntityTypeByName("Spider Boi"))

--Spider projectile
function SPIDERBOI:SpiderBoiBroodTear(v)
    local d = v:GetData()
    local parent = v.Parent
    if d.projType == "sBoiBrood" then
        if parent ~= nil then
            
            local room = Game():GetRoom()
            local testSpiders = false
			--local testPos = v.Position
			sfx:Play(SoundEffect.SOUND_BOIL_HATCH, 0.6, 0, false, math.random(80, 120)/100)
			if room:GetGridCollisionAtPos(v.Position) == GridCollisionClass.COLLISION_NONE then
				testSpiders = true
			else
				if room:GetGridCollisionAtPos(v.Position-v.Velocity:Resized(40)) == GridCollisionClass.COLLISION_NONE then
					testSpiders = true
					--testPos = v.Velocity:Resized(25)
				end
				
			end
			
			if testSpiders == true then
				EntityNPC.ThrowSpider(v.Position, v.Parent, v.Position+Vector(25,0):Rotated(math.random(360)), false, 0)
                EntityNPC.ThrowSpider(v.Position, v.Parent, v.Position+Vector(25,0):Rotated(math.random(360)), false, 0)
			end


        end 
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, SPIDERBOI.SpiderBoiBroodTear, EntityType.ENTITY_PROJECTILE)
--Web projectile
function SPIDERBOI:SpiderBoiWebTear(v)
    local d = v:GetData()
    if d.projType == "sBoiWeb" then
        local room = Game():GetRoom()
        local checkGrid = room:GetGridEntityFromPos(v.Position)
		if not checkGrid or checkGrid:GetType() ~= 20 then
			Isaac.GridSpawn(10, 0, v.Position, true)
		end
		for i = 90, 360, 90 do
			checkGrid = room:GetGridEntityFromPos(v.Position + Vector(40, 0):Rotated(i))
			if not checkGrid or checkGrid:GetType() ~= 20 then
				Isaac.GridSpawn(10, 0, v.Position + Vector(40, 0):Rotated(i), true)
			end
		end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, SPIDERBOI.SpiderBoiWebTear, EntityType.ENTITY_PROJECTILE)

--Web projectile
function SPIDERBOI:SpiderBoiCreepTear(v)
    local d = v:GetData()
    if d.projType == "sBoiCreep" then
        local effect = Isaac.Spawn(1000,2,2,v.Position,Vector.Zero,v)
		effect.Color = ff.ColorPureWhite
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_WHITE, 0, v.Position, Vector(0,0), v):ToEffect()
                creep.SpriteScale = creep.SpriteScale * 2.5
                creep.Timeout = 120
                creep:Update()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, SPIDERBOI.SpiderBoiCreepTear, EntityType.ENTITY_PROJECTILE)

--Champ