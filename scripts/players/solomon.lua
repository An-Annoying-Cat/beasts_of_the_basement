local Mod = BotB
local Solomon = {}

local PLAYER_SOLOMON = Isaac.GetPlayerTypeByName("Solomon")
BotB.JEZ_EXTRA = Isaac.GetCostumeIdByPath("gfx/characters/character_jez_extra.anm2")
function Solomon:playerGetCostume(player)
    --print("weebis")
    if player:GetPlayerType() == PLAYER_SOLOMON then
        --print("whongus")
        player:AddNullCostume(BotB.JEZ_EXTRA)
		player:SetPocketActiveItem(BotB.Enums.Items.THE_HUNGER, ActiveSlot.SLOT_POCKET, false)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Solomon.playerGetCostume, 0)

local myPlayerID = Isaac.GetPlayerTypeByName("Solomon")
EID:addBirthright(myPlayerID, "Monsters of the same general type as ones that the Bestiary has successfully been used on (i.e. flies, spiders, hosts, etc) are also counted as successfully targeted.")

function Solomon:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
    if player:GetPlayerType() == PLAYER_SOLOMON then
		print("am solomon hello")
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Solomon.playerUpdate, 0)