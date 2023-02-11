local Mod = BotB
local TAPE_WORM = {}
local Entities = BotB.Enums.Entities

function TAPE_WORM:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()
    


    if npc.Type == BotB.Enums.Entities.TAPE_WORM.TYPE and npc.Variant == BotB.Enums.Entities.TAPE_WORM.VARIANT then 
        local inchWormPathfinder = npc.Pathfinder
        local roomPits = TSIL.GridSpecific.GetPits()
        local length = #roomPits
        if npc.State == 0 then
            if data.isUnder == nil then
                --Is it underground?
                data.isUnder = false
                --What distance from the player will it come up?
                data.digDistance = 75
                --Timer for going underground and raising
                if npc.SubType ~= 1 then
                    data.underTimerMax = 30
                else
                    data.underTimerMax = 15
                end
                data.underTimer = data.underTimerMax
                --Using this to delay where they shoot towards
                data.fireAtPos = npc.Position
                --Using this to better find a spot near the player to dig up at
                data.digPos = nil
                data.oldPos = npc.Position
                data.gotValidDigPos = false
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_PITSONLY
                npc.Friction = 0
                --Isaac.GridSpawn(GridEntityType.GRID_PIT, 0, npc.Position, true)
                
                --print (length)
                data.MyPit = roomPits[math.random(length)]
                data.stuffInMyPit = {}
                roomPits = TSIL.GridSpecific.GetPits()
                for i=1,#roomPits,1 do
                    --print(roomPits[i])
                    if roomPits[i] ~= nil then
                        local currentPit = roomPits[i]
                        local myPitPos = currentPit.Position
                        local pitCheck = Isaac.FindInRadius(myPitPos, 25,0xFFFFFFFF)
                        --print(pitCheck)
                        --print(#pitCheck)
                        if pitCheck ~= nil then
                            data.stuffInMyPit = Isaac.FindInRadius(myPitPos, 25,0xFFFFFFFF)
                            for i=1,#data.stuffInMyPit,1 do
                                if data.stuffInMyPit[i].Type == BotB.Enums.Entities.TAPE_WORM.TYPE and data.stuffInMyPit[i].Variant == BotB.Enums.Entities.TAPE_WORM.VARIANT then
                                    table.remove(roomPits,i)
                                end
                            end
                        end
                    end
                end
                --print(roomPits)
                length = #roomPits
                --print (length)
                data.MyPit = roomPits[math.random(length)]
                --data.MyPit:GetData().isTakenByTapeworm = true
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
                data.oldPos = npc.Position
                data.gotValidDigPos = false
                sprite:Play("Under")
            end
        end


        --Searching for valid position to surface from underground
        if npc.State == 101 then
            if data.underTimer == 0 then
                --[[
                if data.gotValidDigPos == true then
                    npc.Position = data.digPos
                else
                    npc.Position = data.oldPos
                end
                ]]
                --npc.Position = data.MyPit.Position
                --local mod = BotB.FiendFolio
                --npc.Position = mod:FindRandomPit(npc, not (mod:isConfuse(npc) or mod:isScare(npc)))
                data.isUnder = false
                npc.CollisionDamage = 1
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                npc.State = 102
                sprite:Play("DigOut")
                data.underTimer = data.underTimerMax
            else
                --print(TSIL.GridSpecific.GetPits())
                --data.MyPit:GetData().isTakenByTapeworm = false
                roomPits = TSIL.GridSpecific.GetPits()
                --print(#roomPits)
                for i=1,#roomPits,1 do
                    --print(roomPits[i])
                    if roomPits[i] ~= nil then
                        local currentPit = roomPits[i]
                        local myPitPos = currentPit.Position
                        local pitCheck = Isaac.FindInRadius(myPitPos, 25,0xFFFFFFFF)
                        --print(pitCheck)
                        --print(#pitCheck)
                        if pitCheck ~= nil then
                            --print("pipis")
                            data.stuffInMyPit = Isaac.FindInRadius(myPitPos, 25,0xFFFFFFFF)
                            for i=1,#data.stuffInMyPit,1 do
                                if data.stuffInMyPit[i].Type == BotB.Enums.Entities.TAPE_WORM.TYPE and data.stuffInMyPit[i].Variant == BotB.Enums.Entities.TAPE_WORM.VARIANT then
                                    --print("WEE WOO WEE WOO SECURITY BREACH SECURITY BREACH")
                                    table.remove(roomPits,i)
                                end
                            end
                        end
                    end
                end
                --print(roomPits)
                length = #roomPits
                --print (length)
                data.MyPit = roomPits[math.random(length)]
                --data.MyPit:GetData().isTakenByTapeworm = true

                --[[
                if data.gotValidDigPos == false then
                    data.digPos = targetpos + Vector(data.digDistance,0):Rotated(math.random(360))
                end
                if room:GetGridCollisionAtPos(data.digPos) ~= GridCollisionClass.COLLISION_PIT then
                    data.gotValidDigPos = false
                else
                    if room:IsPositionInRoom(data.digPos, 999) then
                        data.gotValidDigPos = true
                    else
                        data.gotValidDigPos = false
                    end
                end
                ]]

                data.underTimer = data.underTimer - 1
            end
        end

        if npc.State == 102 then
            if sprite:IsEventTriggered("PreShoot") then
                data.fireAtPos = targetpos
            end
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(SoundEffect.SOUND_WORM_SPIT,4,0,false,math.random(70,80)/100)
                local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(10,0):Rotated(targetangle), npc):ToProjectile();
                projectile.Height = -50
                projectile.Scale = 0.75
                local projectile2 = Isaac.Spawn(9, 0, 0, npc.Position, Vector(8,0):Rotated(targetangle), npc):ToProjectile();
                projectile2.Height = -50
                projectile2.Scale = 1.5
                local projectile3 = Isaac.Spawn(9, 0, 0, npc.Position, Vector(6,0):Rotated(targetangle), npc):ToProjectile();
                projectile3.Height = -50
                projectile3.Scale = 2.0
            end
            --Going underground
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end
        
        npc.Position = data.MyPit.Position
        npc.Velocity = Vector.Zero
        if npc.Position.X > target.Position.X then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end


    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, TAPE_WORM.NPCUpdate, Isaac.GetEntityTypeByName("Tape Worm"))

function TAPE_WORM:DamageNull(npc, _, _, _, _)
    --print("sharb")
    local data = npc:GetData()
    if npc.Type == BotB.Enums.Entities.TAPE_WORM.TYPE and npc.Variant == BotB.Enums.Entities.TAPE_WORM.VARIANT and data.isUnder == true then 
        --print("nope!")
        return false
    end
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, TAPE_WORM.DamageNull, Isaac.GetEntityTypeByName("Tape Worm"))