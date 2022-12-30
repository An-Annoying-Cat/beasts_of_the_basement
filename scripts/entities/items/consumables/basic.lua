local Mod = BotB

--IMPORTANT NOTES FOR CARD PROGRAMMING:
--Use player:GetData().activeRoomCards for cards whose effects last for one room.
--Use player:GetData().activeFloorCards for cards whose effects last for the floor.
--Cards that are permanent should just give you a passive item with the icon being the cardfront of the card in question.
player:GetData().activeRoomCards = {}
player:GetData().activeFloorCards = {}
--[[
function Mod:activeCardTableInit(isContinue)
    if not isContinue then
        print("[BASEMENTS AND BEASTIES] Card table initialized.")
        player:GetData().activeRoomCards = {}
        player:GetData().activeFloorCards = {}
    end
end
--]]
function Mod:flushRoomCards()
    --print("Clearing room cards...")
    player:GetData().activeRoomCards = {}
end

function Mod:flushFloorCards()
    --print("Clearing floor cards...")
    player:GetData().activeFloorCards = {}
end
--[[
function Mod:playerSTAPIDebugTest(player)
    print(player.EntityData.GridX .. " , " .. player.EntityData.GridY)
    
end
--]]
--Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.activeCardTableInit)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.flushRoomCards)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Mod.flushFloorCards)

--Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Mod.playerSTAPIDebugTest)