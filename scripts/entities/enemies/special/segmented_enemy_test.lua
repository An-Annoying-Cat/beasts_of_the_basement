local Mod = BotB
local SEGMENTED_ENEMY_TEST = {}
local Entities = BotB.Enums.Entities

--her name is beebis

function SEGMENTED_ENEMY_TEST:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.SEGMENTED_ENEMY_TEST.TYPE and npc.Variant == BotB.Enums.Entities.SEGMENTED_ENEMY_TEST.VARIANT then 
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS 
        end
        if npc.State == 0 then
            if data.botbSegTestNumSegments == nil then
                if npc.SubType ~= nil then
                    data.botbSegTestNumSegments = npc.SubType
                else
                    data.botbSegTestNumSegments = 3
                end
                data.botbSegTestList = {}
                for i=1, data.botbSegTestNumSegments do
                    local thisSegment = Isaac.Spawn(Entities.SEGMENTED_ENEMY_TEST_BODY.TYPE,Entities.SEGMENTED_ENEMY_TEST_BODY.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
                    print("spawned")
                    data.botbSegTestList[#data.botbSegTestList+1] = thisSegment
                    thisSegment:GetData().botbSegTestMasterSegment = npc
                    if i~= 1 then
                        thisSegment.Parent = data.botbSegTestList[i-1]
                        data.botbSegTestList[i-1].Child = thisSegment
                    else
                        thisSegment.Parent = npc
                        npc.Child = thisSegment
                    end
                    if i == data.botbSegTestNumSegments then
                        thisSegment:GetData().botbTestSegSpawnTail = true
                    end 
                end
            end
            --local thisSegment = Isaac.Spawn(Entities.SEGMENTED_ENEMY_TEST_BODY.TYPE,Entities.SEGMENTED_ENEMY_TEST_BODY.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
            sprite:ReplaceSpritesheet(0, "gfx/monsters/tests/segment_head.png")
			sprite:LoadGraphics()
            sprite:Play("Idle")
            npc.State = 99
        end
        if npc.State == 99 then
            npc.Pathfinder:FindGridPath(targetpos, 0.5, 0, true)
            --[[
            if npc.Child ~= nil then
                local cordedEnt = npc.Child
                local cordedEntLength = 40
                local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
                if cordedEntDist > cordedEntLength then
                    local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                    npc.Velocity = npc.Velocity + distToClose*(1/8)
                end
            end]]
            if npc.Child ~= nil then
                local thisPos = npc.Position
                local child = npc.Child:ToNPC()
                BotB.FF.scheduleForUpdate(function()
                    child.Position = thisPos
                end, 15, ModCallbacks.MC_POST_NPC_UPDATE)
            end


        end

        if npc.Parent ~= nil and npc.Parent:IsDead() then
            npc:Kill()
        end
        if npc.Child ~= nil and npc.Child:IsDead() then
            npc:Kill()
        end

        if npc:HasMortalDamage() then
            if npc.Parent ~= nil then
                npc.Parent:Kill()
            end
            if npc.Child ~= nil then
                npc.Child:Kill()
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SEGMENTED_ENEMY_TEST.NPCUpdate, Isaac.GetEntityTypeByName("Segmented Enemy Test"))

function SEGMENTED_ENEMY_TEST:BodyUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.SEGMENTED_ENEMY_TEST_BODY.TYPE and npc.Variant == BotB.Enums.Entities.SEGMENTED_ENEMY_TEST_BODY.VARIANT then 
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS 
        end
        if npc.State == 0 then
            if data.botbTestSegSpawnTail == true then
                local thisSegment = Isaac.Spawn(Entities.SEGMENTED_ENEMY_TEST_TAIL.TYPE,Entities.SEGMENTED_ENEMY_TEST_TAIL.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
                thisSegment.Parent = npc
                npc.Child = thisSegment
            end
            sprite:ReplaceSpritesheet(0, "gfx/monsters/tests/segment_body.png")
			sprite:LoadGraphics()
            sprite:Play("Idle")
            npc.State = 99
        end
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
                    npc.Velocity = npc.Velocity + distToClose*(1/8)
                end
            end
            if npc.Parent ~= nil then
                local cordedEnt2 = npc.Parent
                local cordedEntLength2 = 40
                local cordedEntDist2 = (cordedEnt2.Position - npc.Position):Length()
                if cordedEntDist2 > cordedEntLength2 then
                    local distToClose = (cordedEnt2.Position - npc.Position) - (cordedEnt2.Position - npc.Position):Resized(cordedEntLength2)
                    npc.Velocity = npc.Velocity + distToClose*(1/8)
                end
            end]]
            if npc.Child ~= nil then
                local thisPos = npc.Position
                local child = npc.Child:ToNPC()
                BotB.FF.scheduleForUpdate(function()
                    child.Position = thisPos
                end, 15, ModCallbacks.MC_POST_NPC_UPDATE)
            end

        end

        if npc.Parent ~= nil and npc.Parent:IsDead() then
            npc:Kill()
        end
        if npc.Child ~= nil and npc.Child:IsDead() then
            npc:Kill()
        end

        if npc:HasMortalDamage() then
            if npc.Parent ~= nil then
                npc.Parent:Kill()
            end
            if npc.Child ~= nil then
                npc.Child:Kill()
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SEGMENTED_ENEMY_TEST.BodyUpdate, Isaac.GetEntityTypeByName("Segmented Enemy Test Body"))

function SEGMENTED_ENEMY_TEST:TailUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.SEGMENTED_ENEMY_TEST_TAIL.TYPE and npc.Variant == BotB.Enums.Entities.SEGMENTED_ENEMY_TEST_TAIL.VARIANT then 
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS 
        end
        if npc.State == 0 then
            sprite:ReplaceSpritesheet(0, "gfx/monsters/tests/segment_tail.png")
			sprite:LoadGraphics()
            sprite:Play("Idle")
            npc.State = 99
        end
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
                    npc.Velocity = npc.Velocity + distToClose*(1/8)
                end
            end
            if npc.Parent ~= nil then
                local cordedEnt2 = npc.Parent
                local cordedEntLength2 = 40
                local cordedEntDist2 = (cordedEnt2.Position - npc.Position):Length()
                if cordedEntDist2 > cordedEntLength2 then
                    local distToClose = (cordedEnt2.Position - npc.Position) - (cordedEnt2.Position - npc.Position):Resized(cordedEntLength2)
                    npc.Velocity = npc.Velocity + distToClose*(1/8)
                end
            end]]
            if npc.Child ~= nil then
                local thisPos = npc.Position
                local child = npc.Child:ToNPC()
                BotB.FF.scheduleForUpdate(function()
                    child.Position = thisPos
                end, 15, ModCallbacks.MC_POST_NPC_UPDATE)
            end

        end

        if npc.Parent ~= nil and npc.Parent:IsDead() then
            npc:Kill()
        end
        if npc.Child ~= nil and npc.Child:IsDead() then
            npc:Kill()
        end

        if npc:HasMortalDamage() then
            if npc.Parent ~= nil then
                npc.Parent:Kill()
            end
            if npc.Child ~= nil then
                npc.Child:Kill()
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SEGMENTED_ENEMY_TEST.TailUpdate, Isaac.GetEntityTypeByName("Segmented Enemy Test Tail"))