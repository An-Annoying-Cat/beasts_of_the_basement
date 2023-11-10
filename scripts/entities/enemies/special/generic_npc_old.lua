



--God is dead
















--Don't spoil yourself. It ruins the fun.






























--Last call before I start. Abandon all hope ye who enter here.





















































































































--Don't ruin this for yourself.


































--If you read this, please don't talk about it to other people. It ruins the fun of making the puzzle in the first place.

local Mod = BotB
local GNPCOLD = {}
function GNPCOLD:funSwitchCMD(cmd, params)
    if not cmd == "miriam" then return end
    if cmd == "miriam" then
        if params == ("c".. Isaac.GetItemIdByName("Blood of the Martyr") .. "c" .. Isaac.GetItemIdByName("Stigmata") .. "c" .. Isaac.GetItemIdByName("Crucifix")) then
            print("I have no mouth")
            BotB.FF.scheduleForUpdate(function()
                print("I have no mouth")
            end, 15, ModCallbacks.MC_POST_RENDER)

            BotB.FF.scheduleForUpdate(function()
                print("I HAVE NO MOUTH")
            end, 60, ModCallbacks.MC_POST_RENDER)
            local str = "GOD IS DEAD"
            for i=1,120 do
                BotB.FF.scheduleForUpdate(function()

                    local nameLen = #str
                    local spelledString = ""
                    local spacesString = ""
                    for k=0,((i/2)-((i/2)%1)) do
                        spacesString = spacesString .. " "
                    end
                    for j=1,nameLen do
                        local letterToAdd = ""
                        letterToAdd = string.sub(str,j,j)..spacesString
                        spelledString = spelledString .. letterToAdd 
                        if i ~= nameLen then
                            spelledString = spelledString .. " "
                        end
                    end

                    print(spelledString)
                end, 120+((1200/(31-i))-((1200/(31-i)) % 1)), ModCallbacks.MC_POST_RENDER)
            end
            BotB.FF.scheduleForUpdate(function()
                local roomEntities = Isaac.GetRoomEntities() -- table
                for i = 1, #roomEntities do
                    local entity = roomEntities[i]
                    entity:Remove()
                end
            end, 161, ModCallbacks.MC_POST_RENDER)
            
        else
            print("NOT YET")
            print("Need ID | Proof: HISBLOOD/HISWOUNDS/HISEND")
        end
    end
    
    
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, GNPCOLD.funSwitchCMD)