local Mod = BotB
local LARS = {}
local Entities = BotB.Enums.Entities

--her name is beebis

function LARS:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.LARS.TYPE and npc.Variant == BotB.Enums.Entities.LARS.VARIANT then 
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 0 then
            if data.botbLarsNumSegments == nil then
                if npc.SubType ~= nil then
                    data.botbLarsNumSegments = npc.SubType
                    npc.MaxHitPoints = (data.botbLarsNumSegments * 3) + 1
                end
                if npc.SubType == 0 or npc.SubType == nil then
                    data.botbLarsNumSegments = 0
                    npc.MaxHitPoints = 3 + 1
                end
                
                npc.HitPoints = npc.MaxHitPoints
                data.botbLarsOnKillSectionNum = npc.SubType - 1
                data.botbLarsOnKillSectionNumOther = 0
                data.botbLarsList = {}
                if data.botbLarsNumSegments == 0 then
                    local thisSegment = Isaac.Spawn(Entities.LARS_TAIL.TYPE,Entities.LARS_TAIL.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
                    thisSegment.Parent = npc
                    npc.Child = thisSegment
                else
                    for i=1, data.botbLarsNumSegments do
                        local thisSegment = Isaac.Spawn(Entities.LARS_BODY.TYPE,Entities.LARS_BODY.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
                        print("spawned")
                        thisSegment:GetData().botbLarsSegmentIndex = i
                        thisSegment:GetData().botbLarsOnKillSectionNum = (data.botbLarsNumSegments - i) - 1
                        thisSegment:GetData().botbLarsOnKillSectionNumOther = (thisSegment:GetData().botbLarsSegmentIndex - 1) - 1
                        data.botbLarsList[#data.botbLarsList+1] = thisSegment
                        thisSegment:GetData().botbLarsMasterSegment = npc
                        if i~= 1 then
                            thisSegment.Parent = data.botbLarsList[i-1]
                            data.botbLarsList[i-1].Child = thisSegment
                        else
                            thisSegment.Parent = npc
                            npc.Child = thisSegment
                        end
                        if i == data.botbLarsNumSegments then
                            thisSegment:GetData().botbLarsSpawnTail = true
                        end 
                    end
                end
            end
            --local thisSegment = Isaac.Spawn(Entities.LARS_BODY.TYPE,Entities.LARS_BODY.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
            --sprite:ReplaceSpritesheet(0, "gfx/monsters/tests/segment_head.png")
			--sprite:LoadGraphics()
            --sprite:Play("Idle")
            npc.State = 99
        end

        if npc.Velocity.Y >= 0 then
            npc:AnimWalkFrame("WalkHeadHori", "WalkHeadDown", 0.1)
        else
            npc:AnimWalkFrame("WalkHeadHori", "WalkHeadUp", 0.1)
        end

        if npc.State == 99 then
            if targetdistance <= 120 then
                npc.Pathfinder:FindGridPath(targetpos, 0.625, 0, true)
            else
                npc.Pathfinder:FindGridPath(targetpos, 0.625, 0, true)
            end
            
            --[[
            if npc.Child ~= nil then
                local cordedEnt = npc.Child
                local cordedEntLength = 40
                local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
                if cordedEntDist > cordedEntLength then
                    local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                    npc.Velocity = npc.Velocity + distToClose*(1/6)
                end
            end]]
            if npc.Child ~= nil then
                local thisPos = npc.Position
                local child = npc.Child:ToNPC()
                BotB.FF.scheduleForUpdate(function()
                    child.Position = thisPos
                end, 6, ModCallbacks.MC_POST_NPC_UPDATE)
            end


        end

        if npc.Parent ~= nil and npc.Parent:IsDead() then
            npc:Kill()
        end
        if npc.Child ~= nil and npc.Child:IsDead() then
            npc:Kill()
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, LARS.NPCUpdate, Isaac.GetEntityTypeByName("Lars"))

function LARS:BodyUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.LARS_BODY.TYPE and npc.Variant == BotB.Enums.Entities.LARS_BODY.VARIANT then 
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS 
        end
        if npc.State == 0 then
            if data.botbLarsSpawnTail == true then
                local thisSegment = Isaac.Spawn(Entities.LARS_TAIL.TYPE,Entities.LARS_TAIL.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
                thisSegment.Parent = npc
                npc.Child = thisSegment
            end
            --sprite:ReplaceSpritesheet(0, "gfx/monsters/tests/segment_body.png")
			--sprite:LoadGraphics()
            --sprite:Play("Idle")
            npc.State = 99
        end

        npc:AnimWalkFrame("WalkHori", "WalkHori", 0.1)

        if npc.State == 99 then
            --just attempts to move toward the player
            --checks distance of all children and is pulled accordingly
            --[[
            if npc.Child ~= nil then
                local cordedEnt = npc.Child
                local cordedEntLength = 40
                local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
                if cordedEntDist > cordedEntLength then
                    local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                    npc.Velocity = npc.Velocity + distToClose*(1/6)
                end
            end
            if npc.Parent ~= nil then
                local cordedEnt2 = npc.Parent
                local cordedEntLength2 = 40
                local cordedEntDist2 = (cordedEnt2.Position - npc.Position):Length()
                if cordedEntDist2 > cordedEntLength2 then
                    local distToClose = (cordedEnt2.Position - npc.Position) - (cordedEnt2.Position - npc.Position):Resized(cordedEntLength2)
                    npc.Velocity = npc.Velocity + distToClose*(1/6)
                end
            end]]
            if npc.Child ~= nil then
                local thisPos = npc.Position
                local child = npc.Child:ToNPC()
                BotB.FF.scheduleForUpdate(function()
                    child.Position = thisPos
                end, 6, ModCallbacks.MC_POST_NPC_UPDATE)
            end

        end

        if npc.Parent ~= nil and npc.Parent:IsDead() then
            npc:Kill()
        end
        if npc.Child ~= nil and npc.Child:IsDead() then
            npc:Kill()
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, LARS.BodyUpdate, Isaac.GetEntityTypeByName("Lars Body"))

function LARS:TailUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.LARS_TAIL.TYPE and npc.Variant == BotB.Enums.Entities.LARS_TAIL.VARIANT then 
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS 
        end
        if npc.State == 0 then
            --sprite:ReplaceSpritesheet(0, "gfx/monsters/tests/segment_tail.png")
			--sprite:LoadGraphics()
            --sprite:Play("Idle")
            npc.State = 99
        end
        npc:AnimWalkFrame("WalkHori", "WalkHori", 0.1)
        if npc.State == 99 then
            --just attempts to move toward the player
            --checks distance of all children and is pulled accordingly
            --[[
            if npc.Child ~= nil then
                local cordedEnt = npc.Child
                local cordedEntLength = 40
                local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
                if cordedEntDist > cordedEntLength then
                    local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                    npc.Velocity = npc.Velocity + distToClose*(1/6)
                end
            end
            if npc.Parent ~= nil then
                local cordedEnt2 = npc.Parent
                local cordedEntLength2 = 40
                local cordedEntDist2 = (cordedEnt2.Position - npc.Position):Length()
                if cordedEntDist2 > cordedEntLength2 then
                    local distToClose = (cordedEnt2.Position - npc.Position) - (cordedEnt2.Position - npc.Position):Resized(cordedEntLength2)
                    npc.Velocity = npc.Velocity + distToClose*(1/6)
                end
            end]]
            if npc.Child ~= nil then
                local thisPos = npc.Position
                local child = npc.Child:ToNPC()
                BotB.FF.scheduleForUpdate(function()
                    child.Position = thisPos
                end, 6, ModCallbacks.MC_POST_NPC_UPDATE)
            end

        end

        if npc.Parent ~= nil and npc.Parent:IsDead() then
            npc:Kill()
        end
        if npc.Child ~= nil and npc.Child:IsDead() then
            npc:Kill()
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, LARS.TailUpdate, Isaac.GetEntityTypeByName("Lars Tail"))




function LARS:DamageCheck(npc, amount, damageFlags, source, _)
    if (npc.Type ~= BotB.Enums.Entities.LARS.TYPE or npc.Variant ~= BotB.Enums.Entities.LARS.VARIANT) and (npc.Type ~= BotB.Enums.Entities.LARS_BODY.TYPE or npc.Variant ~= BotB.Enums.Entities.LARS_BODY.VARIANT) and (npc.Type ~= BotB.Enums.Entities.LARS_TAIL.TYPE or npc.Variant ~= BotB.Enums.Entities.LARS_TAIL.VARIANT) then return end
    local data = npc:GetData()
    if amount >= npc.HitPoints then
        if npc.Child ~= nil then
            npc.Child:Kill()
        end
    else
        if npc.Parent ~= nil then
            npc.Parent:ToNPC():TakeDamage(amount, damageFlags, source, 0)
            return false
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, LARS.DamageCheck, Isaac.GetEntityTypeByName("Lars"))