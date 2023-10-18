local Mod = BotB
local PRICKHEAD = {}
local Entities = BotB.Enums.Entities

function PRICKHEAD:NPCUpdate(npc)

    


    if npc.Type == BotB.Enums.Entities.PRICKHEAD.TYPE and npc.Variant == BotB.Enums.Entities.PRICKHEAD.VARIANT then 
        
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()

        if npc.State == 0 then
            if data.botbPrickheadJumpTarget == nil then
                data.botbPrickheadJumpTarget = npc.Position
                data.botbPrickheadJumpCooldownMax = 120
                data.botbPrickheadJumpCooldown = 120 --starts a little early
                data.botbPrickheadIsMidair = false
            end
            if sprite:IsPlaying("Appear") == false then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        --99: idle
        --100: hop
        if npc.State == 99 then
            
            npc.Velocity = 0.2 * npc.Velocity
            if data.botbPrickheadJumpCooldown ~= 0 then
                data.botbPrickheadJumpCooldown = data.botbPrickheadJumpCooldown - 1
            else
                data.botbPrickheadJumpTarget = Game():GetRoom():FindFreePickupSpawnPosition(targetpos+(Vector(math.random(10,40),0):Rotated(math.random(0,359))), 5, true, false)
                npc.State = 100
                sprite:Play("Hop")
            end
        end

        --print(Game():GetRoom():GetGridWidth())

        if npc.State == 100 then
            if sprite:IsEventTriggered("Jump") then
                data.botbPrickheadIsMidair = true
                npc:PlaySound(SoundEffect.SOUND_FETUS_JUMP,1,0,false,1)
            end
            if sprite:IsEventTriggered("Land") then
                data.botbPrickheadIsMidair = false
                npc.Position = data.botbPrickheadJumpTarget
                npc:PlaySound(SoundEffect.SOUND_BONE_HEART,1,0,false,0.5)
                local spikeStartPos = Game():GetRoom():GetGridPosition(Game():GetRoom():GetGridIndex(npc.Position))
                local baseIndex = Game():GetRoom():GetGridIndex(npc.Position)
                for i = 5, 80 do
                    BotB.FF.scheduleForUpdate(function()
                        npc.Position = spikeStartPos
                        if i % 5 == 0 then
                            local iteration = i/5
                            local testPos = Game():GetRoom():GetGridPosition(baseIndex + iteration)
                            if Game():GetRoom():IsPositionInRoom(testPos,0) 
                            and Game():GetRoom():GetGridCollision(baseIndex + iteration) ~= GridCollisionClass.COLLISION_SOLID
                            and Game():GetRoom():GetGridCollision(baseIndex + iteration) ~= GridCollisionClass.COLLISION_PIT
                            and Game():GetRoom():GetGridCollision(baseIndex + iteration) ~= GridCollisionClass.COLLISION_OBJECT
                            and Game():GetRoom():GetGridCollision(baseIndex + iteration) ~= GridCollisionClass.COLLISION_WALL
                            and Game():GetRoom():GetGridCollision(baseIndex + iteration) ~= GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
                            and Game():GetRoom():GetGridPosition(baseIndex).X < Game():GetRoom():GetGridPosition(baseIndex + iteration).X 
                            and Game():GetRoom():GetGridPosition(baseIndex).Y == Game():GetRoom():GetGridPosition(baseIndex + iteration).Y then
                                local spike = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.SPIKE,0,testPos,Vector.Zero,npc):ToEffect()
                                spike.Timeout = 200
                                SFXManager():Play(SoundEffect.SOUND_BONE_DROP,0.25,0,false,0.5)
                            end
                            local testPos = Game():GetRoom():GetGridPosition(baseIndex - iteration)
                            if Game():GetRoom():IsPositionInRoom(testPos,0) 
                            and Game():GetRoom():GetGridCollision(baseIndex - iteration) ~= GridCollisionClass.COLLISION_SOLID
                            and Game():GetRoom():GetGridCollision(baseIndex - iteration) ~= GridCollisionClass.COLLISION_PIT
                            and Game():GetRoom():GetGridCollision(baseIndex - iteration) ~= GridCollisionClass.COLLISION_OBJECT
                            and Game():GetRoom():GetGridCollision(baseIndex - iteration) ~= GridCollisionClass.COLLISION_WALL
                            and Game():GetRoom():GetGridCollision(baseIndex - iteration) ~= GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
                            and Game():GetRoom():GetGridPosition(baseIndex).X > Game():GetRoom():GetGridPosition(baseIndex - iteration).X 
                            and Game():GetRoom():GetGridPosition(baseIndex).Y == Game():GetRoom():GetGridPosition(baseIndex - iteration).Y then
                                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.SPIKE,0,testPos,Vector.Zero,npc)
                                SFXManager():Play(SoundEffect.SOUND_BONE_DROP,0.25,0,false,0.5)
                            end
                            local width = Game():GetRoom():GetGridWidth()

                            local testPos = Game():GetRoom():GetGridPosition(baseIndex + (width*iteration))
                            if Game():GetRoom():IsPositionInRoom(testPos,0) 
                            and Game():GetRoom():GetGridCollision(baseIndex + (width*iteration)) ~= GridCollisionClass.COLLISION_SOLID
                            and Game():GetRoom():GetGridCollision(baseIndex + (width*iteration)) ~= GridCollisionClass.COLLISION_PIT
                            and Game():GetRoom():GetGridCollision(baseIndex + (width*iteration)) ~= GridCollisionClass.COLLISION_OBJECT
                            and Game():GetRoom():GetGridCollision(baseIndex + (width*iteration)) ~= GridCollisionClass.COLLISION_WALL
                            and Game():GetRoom():GetGridCollision(baseIndex + (width*iteration)) ~= GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
                            and Game():GetRoom():GetGridPosition(baseIndex).X == Game():GetRoom():GetGridPosition(baseIndex + (width*iteration)).X 
                            and Game():GetRoom():GetGridPosition(baseIndex).Y < Game():GetRoom():GetGridPosition(baseIndex + (width*iteration)).Y then
                                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.SPIKE,0,testPos,Vector.Zero,npc)
                                SFXManager():Play(SoundEffect.SOUND_BONE_DROP,0.25,0,false,0.5)
                            end
                            local testPos = Game():GetRoom():GetGridPosition(baseIndex - (width*iteration))
                            if Game():GetRoom():IsPositionInRoom(testPos,0) 
                            and Game():GetRoom():GetGridCollision(baseIndex - (width*iteration)) ~= GridCollisionClass.COLLISION_SOLID
                            and Game():GetRoom():GetGridCollision(baseIndex - (width*iteration)) ~= GridCollisionClass.COLLISION_PIT
                            and Game():GetRoom():GetGridCollision(baseIndex - (width*iteration)) ~= GridCollisionClass.COLLISION_OBJECT
                            and Game():GetRoom():GetGridCollision(baseIndex - (width*iteration)) ~= GridCollisionClass.COLLISION_WALL
                            and Game():GetRoom():GetGridCollision(baseIndex - (width*iteration)) ~= GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
                            and Game():GetRoom():GetGridPosition(baseIndex).X == Game():GetRoom():GetGridPosition(baseIndex - (width*iteration)).X 
                            and Game():GetRoom():GetGridPosition(baseIndex).Y > Game():GetRoom():GetGridPosition(baseIndex - (width*iteration)).Y then
                                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.SPIKE,0,testPos,Vector.Zero,npc)
                                SFXManager():Play(SoundEffect.SOUND_BONE_DROP,0.25,0,false,0.5)
                            end


                            --[[
                            for j=0,270,90 do
                                
                                local spawnPos = roundedPos+Vector(40*iteration,0):Rotated(j)
                                local firstIndicator = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ULTRA_GREED_BLING,0,spawnPos,Vector.Zero,npc):ToEffect()
                                firstIndicator.Color = Color(1,0,0,1)
                                local secondIndicator = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ULTRA_GREED_BLING,0,Game():GetRoom():GetGridPosition(Game():GetRoom():GetGridIndex(roundedPos+Vector(40*iteration,0):Rotated(j))),Vector.Zero,npc):ToEffect()
                                local testPos = Game():GetRoom():GetGridPosition(Game():GetRoom():GetGridIndex(spawnPos))
                                if Game():GetRoom():IsPositionInRoom(testPos,0) and Game():GetRoom():GetGridEntityFromPos(testPos) == nil then
                                    Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.SPIKE,0,testPos,Vector.Zero,npc)
                                    SFXManager():Play(SoundEffect.SOUND_BONE_DROP,0.25,0,false,0.5)
                                end
                                
                            end]]
                        end
                        
                    end, i, ModCallbacks.MC_POST_RENDER)
                end
            end
            if data.botbPrickheadIsMidair == true then
                npc.Position = (0.75 * npc.Position) + (0.25 * data.botbPrickheadJumpTarget)
            end
            if sprite:IsFinished("Hop") then
                npc.State = 99
                sprite:Play("Idle")
                data.botbPrickheadJumpCooldown = data.botbPrickheadJumpCooldownMax + math.random(-60,60)
            end
        end

        if data.botbPrickheadIsMidair == true then
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            end
        else
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
        end
        
        

    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PRICKHEAD.NPCUpdate, Isaac.GetEntityTypeByName("Prickhead"))