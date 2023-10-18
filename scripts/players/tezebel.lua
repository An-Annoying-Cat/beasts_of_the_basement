local Mod = BotB
local Tezebel = {}

local PLAYER_TEZEBEL = Isaac.GetPlayerTypeByName("Tezebel", true)
BotB.JEZ_EXTRA = Isaac.GetCostumeIdByPath("gfx/characters/character_jez_extra.anm2")
function Tezebel:playerGetCostume(player)
    --print("weebis")
    if player:GetPlayerType() == PLAYER_TEZEBEL then
        --print("whongus")
        --
        player.Visible = false
        player.Color = Color(0,0,0,0)
        player.Visible = false
        player.Color = Color(0,0,0,0)
        Game():Fadeout(1, 1)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Tezebel.playerGetCostume, 0)

--[[]]
function Tezebel:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
    if player:GetPlayerType() == PLAYER_TEZEBEL then
        --print("fuck")
        --
        player.Visible = false
        player.Color = Color(0,0,0,0)
        Game():Fadeout(1, 1)

    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Tezebel.playerUpdate, 0)


