local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local ATTACK_ANT = {}
--[[
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local d = fam:GetData()
	local sprite = fam:GetSprite()
	if fam.Player:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) then
		if not fam.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
			fam.SpriteScale = Vector(1.25,1.25)
		end
		if not d.HiveMinded then
			fam:SetSize(18, Vector(1.25,1.25), 12)
			d.HiveMinded = true
		end
	elseif fam.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		fam.SpriteScale = Vector(0.8,0.8)
		if d.HiveMinded then
			fam:SetSize(13, Vector(1,1), 12)
			d.HiveMinded = nil
		end
	else
		fam.SpriteScale = Vector(1,1)
		if d.HiveMinded then
			fam:SetSize(13, Vector(1,1), 12)
			d.HiveMinded = nil
		end
	end
	if not d.init then
		d.init = true
		sprite.Offset = Vector(0, 0)
		d.jumpytimer = 0
		d.state = "idle"
		d.stateframe = 0
		fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
		fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	end
	if d.state == "idle" then
		if not sprite:IsPlaying("land") then
			mod:spritePlay(sprite, "idle")
			fam.Velocity = mod:Lerp(fam.Velocity, Vector(0,0), 0.75)
		elseif sprite:IsFinished("land") then
			mod:spritePlay(sprite, "idle")
		else
			fam.Velocity = mod:Lerp(fam.Velocity, Vector(0,0), 0.4)
		end
		--just in case
		if not d.jumpytimer then
			d.jumpytimer = 30
		end
		if d.jumpytimer <= 0 then
			d.state = "hop"
			--sfx:Play(SoundEffect.SOUND_FETUS_LAND,0.6,1,false,2.7)
			mod:spritePlay(sprite, "hopstart")
			d.stateframe = 0;
			local targetpos = mod:chooserandomlocationforskuzz(fam, 150, 50, true, true)
			local lengthto = targetpos - fam.Position
			fam.Velocity = Vector(lengthto.X / 15 , lengthto.Y / 15) * 0.90
			fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			fam.GridCollisionClass = GridCollisionClass.COLLISION_NONE
		else
			d.jumpytimer = d.jumpytimer - 1
		end
	elseif d.state == "hop" then
		if not sprite:IsPlaying("hopstart") then
			mod:spritePlay(sprite, "hop")
		elseif sprite:IsFinished("hopstart") then
			mod:spritePlay(sprite, "hop")
		end
		sprite.Offset = Vector(0, -2 * (-0.025 * ((d.stateframe - 30)^2) + 29.5))
		if sprite.Offset.Y > 0 then
			sprite.Offset = Vector(0,0)
			d.state = "idle"
			mod:spritePlay(sprite, "land")
			--sfx:Play(SoundEffect.SOUND_FETUS_LAND,0.6,1,false,1.7)
			d.jumpytimer = math.random(10, 30)
			fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
			fam.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		else
		d.stateframe = d.stateframe + 4
		end
	else
		d.state = "idle"
	end
end, FamiliarVariant.ATTACK_SKUZZ)]]




function ATTACK_ANT:NPCUpdate(npc)


    if npc.Type == BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE and npc.Variant == BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local playerConv = npc:GetPlayerTarget():ToPlayer()
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
            npc:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
        end


        if playerConv:HasCollectible(CollectibleType.COLLECTIBLE_HIVE_MIND) then
            if not playerConv:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
                npc.SpriteScale = Vector(1.25,1.25)
            end
            if not data.HiveMinded then
                npc:SetSize(18, Vector(1.25,1.25), 12)
                data.HiveMinded = true
            end
        elseif playerConv:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
            npc.SpriteScale = Vector(0.8,0.8)
            if data.HiveMinded then
                npc:SetSize(13, Vector(1,1), 12)
                data.HiveMinded = nil
            end
        else
            npc.SpriteScale = Vector(1,1)
            if data.HiveMinded then
                npc:SetSize(13, Vector(1,1), 12)
                data.HiveMinded = nil
            end
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
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end

        if npc.State == 99 then
            npc.Velocity = 0.25 * npc.Velocity
            if data.botbAntWalkCooldown ~= 0 then
                data.botbAntWalkCooldown = data.botbAntWalkCooldown - 1
            else
                if targetdistance <= 200 then
                    npc.State = 101
                    data.botbAntWalkCooldown = data.botbAntWalkCooldownMax
                    data.botbAntWalkDuration = data.botbAntWalkDurationMax
                    sprite:Play("Walk")
                else
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


        --Morph check

        local closest
        local candidate
        local baseDist = 500
        local roomEntities = Isaac.GetRoomEntities() -- table
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            if (entity.Position - npc.Position):Length() < baseDist and not (entity.Type == BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE and entity.Variant == BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT) then
                candidate = entity
                baseDist = (candidate.Position - npc.Position):Length()
            end
        end
        closest = candidate 
        --print(closest.Type, closest.Variant, closest.SubType)
        --print((closest.Position - npc.Position):Length())
        if closest:IsVulnerableEnemy() then
            if (closest.Position - npc.Position):Length() <= 60 and closest.Type ~= EntityType.ENTITY_PLAYER then
                --npc.State = 99
                --npc:Morph(EntityType.ENTITY_FAMILIAR, BotB.Enums.Familiars.ATTACK_ANT.VARIANT, 0, 0)
                local reconvert = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, BotB.Enums.Familiars.ATTACK_ANT.VARIANT, 0, npc.Position, Vector.Zero, player):ToFamiliar()
                reconvert.Player = player:ToPlayer()
                reconvert:GetData().HiveMinded = data.HiveMinded
                reconvert:GetData().SpriteScale = npc.SpriteScale
                reconvert:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                npc:Remove()

                --morph into familiar when near target
            end
        end
        --[[
        
        ]]

    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, ATTACK_ANT.NPCUpdate, Isaac.GetEntityTypeByName("Attack Ant (Enemy)"))


local Familiars = BotB.Enums.Familiars

function ATTACK_ANT:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player or Game():GetPlayer(0)


    if npc.Type == EntityType.ENTITY_FAMILIAR and npc.Variant == BotB.Enums.Familiars.ATTACK_ANT.VARIANT then 
        --print("gogurt")

        if not sprite:IsPlaying("Walk") then
            sprite:Play("Walk")
        end

        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ENEMIES then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
        end

       if npc.State == 3 then
            npc.State = 99
       end
       npc:PickEnemyTarget(9999, 1)
       if npc.Target ~= nil then
        npc.Position = 0.8*npc.Position + 0.2*npc.Target.Position
       else
        local reconvert = Isaac.Spawn(BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0, npc.Position, Vector.Zero, npc.Player):ToNPC()
                reconvert:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                reconvert:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
                npc:Remove()
       end
       
        --States
        -- 99 - spawning
        -- 100 - chasing, failsafe
        if npc.State == 99 then
            --npc.Velocity = Vector.Zero
            
            if npc.Target ~= nil then
                --npc.Parent = npc.Target
                npc.State = 100
                --sprite:Play("Walk")
                
            end
        end

        if npc.State == 100 then
            if npc.Target:IsDead() then
                local reconvert = Isaac.Spawn(BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE, BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT, 0, npc.Position, Vector.Zero, npc.Player):ToNPC()
                reconvert:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                reconvert:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
                npc:Remove()
            else
                npc.Position = 0.8*npc.Position + 0.2*npc.Target.Position
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, ATTACK_ANT.FamiliarUpdate, BotB.Enums.Familiars.ATTACK_ANT.VARIANT)



--
Mod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, function(_, fam, collider)
	if collider:IsEnemy() and collider:IsVulnerableEnemy() and collider:IsActiveEnemy() and not (mod:isFriend(collider) or collider:HasEntityFlags(EntityFlag.FLAG_NO_TARGET)) then
		local dmgMulti = 3
		if fam:GetData().HiveMinded then
			dmgMulti = dmgMulti * 2
		end
		collider:TakeDamage(fam.Player.Damage * dmgMulti, 0, EntityRef(fam.Player), 0)
		if fam.SubType ~= 100 then
			fam:Kill()
		end
	end
end, BotB.Enums.Familiars.ATTACK_ANT.VARIANT)



function ATTACK_ANT:resetPosOnNewRoom ()
    local roomEntities = Isaac.GetRoomEntities() 
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity.Type == BotB.Enums.Entities.ATTACK_ANT_ENEMY.TYPE and entity.Variant == BotB.Enums.Entities.ATTACK_ANT_ENEMY.VARIANT then
            entity.Position = entity:ToNPC():GetPlayerTarget().Position
        end
    end

end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,ATTACK_ANT.resetPosOnNewRoom)