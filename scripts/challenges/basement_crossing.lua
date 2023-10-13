local game = Game()
local map = include("resources.luarooms.basement_crossing")
local mapList = StageAPI.RoomsList("BOTBBasementCrossing", map)
local doOnFirstUpdate
local Mod = BotB
local BASEMENT_CROSSING = {}
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
    doOnFirstUpdate = nil
    if not continued and game.Challenge == Isaac.GetChallengeIdByName("[BOTB] Basement Crossing")  then
        doOnFirstUpdate = true
    end
end)

Mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if doOnFirstUpdate then
        local map = StageAPI.CreateMapFromRoomsList(mapList, nil, {NoChampions = true})
        StageAPI.InitCustomLevel(map, true)
        game:GetHUD():SetVisible(false)
        doOnFirstUpdate = nil
    end
end)

Mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, function()
    if game.Challenge == Isaac.GetChallengeIdByName("[BOTB] Basement Crossing")  then
        return 0
    end
end)


function BASEMENT_CROSSING:onRender(t)
    if game.Challenge == Isaac.GetChallengeIdByName("[BOTB] Basement Crossing")  then   
        local f = Font() -- init font object
        f:Load("font/terminus.fnt") -- load a font into the font object
        local date = os.date('*t')
        local time = os.date("*t")
        local str = os.date("%A, %m %B %Y | ") .. ("%02d:%02d:%02d"):format(time.hour, time.min, time.sec)
        
        --print(os.date("%A, %m %B %Y | "), ("%02d:%02d:%02d"):format(time.hour, time.min, time.sec))
        --string:format(os.date("%A, %m %B %Y | "))
        f:DrawString(str,((Isaac.GetScreenWidth()/2)-(0.5*f:GetStringWidth(str))),25,KColor(1,1,1,1),0,true) -- render string with loaded font on position 60x50y
        
    else
        return
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_RENDER, BASEMENT_CROSSING.onRender)

--[[
local date = os.date('*t')
local time = os.date("*t")
print(os.date("%A, %m %B %Y | "), ("%02d:%02d:%02d"):format(time.hour, time.min, time.sec))]]

