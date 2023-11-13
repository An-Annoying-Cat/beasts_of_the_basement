local Mod = BotB
local SINUSTRO = {}
local Entities = BotB.Enums.Entities
local FF = BotB.FF

function SINUSTRO:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.SINUSTRO.TYPE and npc.Variant == BotB.Enums.Entities.SINUSTRO.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local somebodyPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.sinustroJumpCooldown == nil then
                data.sinustroJumpCooldown = 12
                data.sinustroShootCooldown = 24
                data.sinustroTriggerDist = 180
                data.sinustroHopToPos = npc.Position
                data.sinustroIsAirborne = false
            end
            npc.State = 99
            sprite:Play("Idle")
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if data.sinustroIsAirborne == false then
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
        else
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            end
        end
        
        npc.SplatColor = FiendFolio.ColorSpittyGreen

        --99: Idle
        --100: Hop
        --101: Shoot
        --print(npc.Velocity:Length())
        if npc.State == 99 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            --npc:AnimWalkFrame("WalkHori", "WalkVert", 0.25)
            --somebodyPathfinder:FindGridPath(targetpos, 0.325, 0, false)
            npc.Velocity = 0.5 * npc.Velocity
            if data.sinustroJumpCooldown == 0 then
                if targetdistance <= (data.sinustroTriggerDist * 1.25) then
                    data.sinustroHopToPos = Game():GetRoom():FindFreeTilePosition(npc.Position + Vector(120,0):Rotated(targetangle), 0)
                else
                    data.sinustroHopToPos = Game():GetRoom():FindFreeTilePosition(npc.Position + Vector(120,0):Rotated(math.random(360)), 0)
                end
                local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,data.sinustroHopToPos,Vector(0,0),npc):ToEffect()
                npc.State = 100
                sprite:Play("Hop")
                
                
            else
                data.sinustroJumpCooldown = data.sinustroJumpCooldown - 1
            end
            if data.sinustroShootCooldown == 0 then
                if targetdistance <= data.sinustroTriggerDist then
                    npc.State = 101
                    sprite:Play("Attack")
                end
            else
                data.sinustroShootCooldown = data.sinustroShootCooldown - 1
            end
        end

        if data.sinustroIsAirborne == false and npc.Velocity:Length() >= 5 then
            if npc.FrameCount % 2 == 0 then
                local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect();
			    creep.SpriteScale = Vector(0.75, 1)
			    creep:SetTimeout(math.floor(creep.Timeout * 0.75))
			    creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
			    creep:Update()
            end
        end

        if npc.State == 100 then
            --Hop
            if sprite:IsEventTriggered("Jump") then
                data.sinustroIsAirborne = true
                npc:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,0.25,0,false,math.random(75,85)/100)
            end
            if sprite:IsEventTriggered("Land") then
                data.sinustroIsAirborne = false
                local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect();
                creep.SpriteScale = Vector(1.5, 1)
                creep:SetTimeout(math.floor(creep.Timeout * 0.75))
                creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
                creep:Update()
                npc:PlaySound(BotB.Enums.SFX.CROASTLAND,0.5,0,false,math.random(85,105)/100)
            end
            if data.sinustroIsAirborne == true then
                npc.Velocity = ((0.99 * npc.Velocity) + (0.01 * (data.sinustroHopToPos - npc.Position))):Clamped(-15,-15,15,15)
            end
            if sprite:IsFinished() then
                npc.State = 99
                data.sinustroJumpCooldown = 24
                sprite:Play("Idle")
            end
        end

        if npc.State == 101 then
            --Shoot
            npc.Velocity = 0.8 * npc.Velocity
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(FiendFolio.Sounds.SpitumCharge,0.25,0,false,math.random(75,85)/100)
                npc:PlaySound(FiendFolio.Sounds.AGShoot,0.5,0,false,math.random(75,85)/100)
                for i = 1, 10 do
                    local proj = Isaac.Spawn(9, 0, 0, npc.Position, (target.Position - npc.Position):Resized(math.random(2,7)):Rotated(-15+math.random(30)), npc):ToProjectile()
                    proj.Scale = math.random(8,10)/10
                    proj.Color = FiendFolio.ColorSpittyGreen
                    proj.FallingSpeed = -15 - math.random(20)/10
                    proj.FallingAccel = 0.9 + math.random(10)/10
                    local pd = proj:GetData()
                    pd.projType = "acidic splot"
                    if npc.SpawnerEntity and npc.SpawnerEntity.Type == 20 then
                        pd.creepTimer = 30
                    end
                end
            end

            if sprite:IsFinished() then
                npc.State = 99
                data.sinustroShootCooldown = 36
                sprite:Play("Idle")
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SINUSTRO.NPCUpdate, Isaac.GetEntityTypeByName("Sinustro"))