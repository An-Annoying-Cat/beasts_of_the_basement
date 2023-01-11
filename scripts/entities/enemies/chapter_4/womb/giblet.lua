local Mod = BotB
local GIBLET = {}
local Entities = BotB.Enums.Entities

function GIBLET:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    if npc.Type == BotB.Enums.Entities.GIBLET.TYPE and npc.Variant == BotB.Enums.Entities.GIBLET.VARIANT then
        if data.hasSpawnedFriends == nil then
            data.hasSpawnedFriends = false
            data.faceChanged = false
            data.whichFace = math.random(7)
            --print(data.whichFace)
        end
    end
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    if npc.Type == BotB.Enums.Entities.GIBLET.TYPE and npc.Variant == BotB.Enums.Entities.GIBLET.VARIANT and data.hasSpawnedFriends == false then 
        --Spawn friends
        if npc.SubType ~= 0 then
            local friendsToSpawn = npc.SubType
            for i=1,friendsToSpawn,1 do
                local newestFren = Isaac.Spawn(BotB.Enums.Entities.GIBLET.TYPE, BotB.Enums.Entities.GIBLET.VARIANT, 0, npc.Position, Vector.Zero, npc)
                --newestFren:GetData().whichFace = math.random(7)
            end
            data.hasSpawnedFriends = true
        end
        --Face sprite change stuff
        if data.faceChanged == false then
            if data.whichFace ~= 1 then
                sprite:ReplaceSpritesheet(1, "gfx/monsters/chapter_4/womb/giblet/giblet" .. data.whichFace .. ".png")
            end
            sprite:LoadGraphics()
            data.faceChanged = true
        end
        --[[
        if npc.Parent ~= nil and npc.Parent.Type == BotB.Enums.Entities.GIBBY.TYPE and npc.Parent.Variant == BotB.Enums.Entities.GIBBY.VARIANT and npc.FrameCount <= 5 then
            npc.Friction = 1.5
        else
            npc.Friction = 1
        end
        --]]

    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GIBLET.NPCUpdate, Isaac.GetEntityTypeByName("Giblet"))