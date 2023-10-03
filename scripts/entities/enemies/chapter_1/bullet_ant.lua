local Mod = BotB
local BULLET_ANT = {}
local Entities = BotB.Enums.Entities

function BULLET_ANT:NPCUpdate(npc)


    if npc.Type == BotB.Enums.Entities.BULLET_ANT.TYPE and npc.Variant == BotB.Enums.Entities.BULLET_ANT.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local antPathfinder = npc.Pathfinder
        
       --States: 
       --0:Appear
       --99: Idle
       --100: Wander
       --101: Charge at target
       if npc.State == 0 then
        if data.botbAntWalkDuration == nil then
            data.botbAntWalkDurationMax = 120
            data.botbAntWalkDuration = data.botbAntWalkDurationMax
            data.botbAntWalkCooldownMax = 60
            data.botbAntWalkCooldown = data.botbAntWalkCooldownMax
            data.randomRoomPos = Vector(0,0)
            data.antRandomWalkDir = 0
        end
        if not sprite:IsPlaying("Appear") then
            sprite:Play("Appear")
        end
        if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
            sprite:Play("Idle")
            npc.State = 99
        end
        end

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end

        if npc.State == 99 then
            npc.Velocity = 0.25 * npc.Velocity
            if data.botbAntWalkCooldown ~= 0 then
                data.botbAntWalkCooldown = data.botbAntWalkCooldown - 1
            else
                if targetdistance <= 200 then
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
                    local bullet = Isaac.Spawn(9, 0, 0, npc.Position, Vector(12,0):Rotated(targetangle), npc):ToProjectile()
                    bullet.FallingAccel = -0.05
                        bullet.Parent = npc
                    npc.State = 101
                    data.botbAntWalkCooldown = data.botbAntWalkCooldownMax
                    data.botbAntWalkDuration = data.botbAntWalkDurationMax
                    sprite:Play("Walk")
                else
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
                    local bullet = Isaac.Spawn(9, 0, 0, npc.Position, Vector(12,0):Rotated(targetangle), npc):ToProjectile()
                    bullet.FallingAccel = -0.05
                        bullet.Parent = npc
                    --local room = Game():GetRoom()
                    --data.randomRoomPos = room:FindFreeTilePosition(room:GetRandomPosition(10), 100)
                    if math.random(0,1) == 1 then
                        --First direction order
                        local room = Game():GetRoom()
                        for i=0,3 do
                            if antPathfinder:HasPathToPos(npc.Position+Vector(100,0):Rotated(90*i), false) and room:IsPositionInRoom(npc.Position+Vector(100,0):Rotated(90*i), 25) then
                                data.randomRoomPos = npc.Position+Vector(35,0):Rotated(90*i)
                                break
                            end
                        end
                    else
                        --Other direction order
                        local room = Game():GetRoom()
                        for i=3,0,-1 do
                            if antPathfinder:HasPathToPos(npc.Position+Vector(100,0):Rotated(90*i), false) and room:IsPositionInRoom(npc.Position+Vector(100,0):Rotated(90*i), 25) then
                                data.randomRoomPos = npc.Position+Vector(35,0):Rotated(90*i)
                                break
                            end
                        end
                    end
                    npc.State = 100
                    data.botbAntWalkCooldown = data.botbAntWalkCooldownMax
                    data.botbAntWalkDuration = data.botbAntWalkDurationMax
                    sprite:Play("Walk")
                end
            end
        end

        if npc.State == 100 or npc.State == 101 then
            if data.botbAntWalkDuration ~= 0 then
                data.botbAntWalkDuration = data.botbAntWalkDuration - 1
            else
                npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
                local bullet = Isaac.Spawn(9, 0, 0, npc.Position, Vector(12,0):Rotated(targetangle), npc):ToProjectile()
                bullet.FallingAccel = -0.05
                    bullet.Parent = npc
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        if npc.State == 100 then
            --[[
            antPathfinder:FindGridPath(Vector(npc.Position.X, data.randomRoomPos.Y), 1, 0, true)
            antPathfinder:FindGridPath(Vector(data.randomRoomPos.X, npc.Position.Y), 1, 0, true)
            print(npc.Position:Distance(data.randomRoomPos))
            if npc.Position:Distance(data.randomRoomPos) <= 10 then
                print("dink!")
                local room = Game():GetRoom()
                data.randomRoomPos = room:FindFreeTilePosition(room:GetRandomPosition(10), 100)
            end]]
            if npc.FrameCount % 32 == 0 then
                if math.random(0,1) == 1 then
                    --First direction order
                    local room = Game():GetRoom()
                    for i=0,3 do
                        if antPathfinder:HasPathToPos(npc.Position+Vector(100,0):Rotated(90*i), false) and room:IsPositionInRoom(npc.Position+Vector(100,0):Rotated(90*i), 25) then
                            data.randomRoomPos = npc.Position+Vector(100,0):Rotated(90*i)
                            break
                        end
                    end
                else
                    --Other direction order
                    local room = Game():GetRoom()
                    for i=3,0,-1 do
                        if antPathfinder:HasPathToPos(npc.Position+Vector(100,0):Rotated(90*i), false) and room:IsPositionInRoom(npc.Position+Vector(100,0):Rotated(90*i), 25) then
                            data.randomRoomPos = npc.Position+Vector(100,0):Rotated(90*i)
                            break
                        end
                    end
                end
            end
            antPathfinder:FindGridPath(data.randomRoomPos, 1.25, 0, true)

        end

        if npc.State == 101 then
            antPathfinder:FindGridPath(Vector(npc.Position.X, targetpos.Y), 1.25, 0, true)
            antPathfinder:FindGridPath(Vector(targetpos.X, npc.Position.Y), 1.25, 0, true)

        end


    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BULLET_ANT.NPCUpdate, Isaac.GetEntityTypeByName("Bullet Ant"))





--[[
function BULLET_ANT:BulletCheck(bullet)

    --Seducer projectiles spawn red creep when they splat
    if bullet.Parent ~= nil and bullet.Parent.Type == BotB.Enums.Entities.BULLET_ANT.TYPE and bullet.Parent.Variant == BotB.Enums.Entities.BULLET_ANT.VARIANT then
        local npc = bullet.Parent:ToNPC()
        if bullet.FrameCount % 12 == 0 then
            bullet.Velocity = Vector(1,0):Resized(bullet.Velocity:Length()):Rotated((npc:GetPlayerTarget().Position - bullet.Position):GetAngleDegrees())
        end
        
        
    end
    

end

Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, BULLET_ANT.BulletCheck)]]