local Mod = BotB
local NAME_TAG = {}
local Items = BotB.Enums.Items

local NameTagPerCharBonus={
	DAMAGE=0.25,
	LUCK=0.5,
}

local function getPlayers()
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
  
	return players
end

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Name Tag"), "#Grants {{Damage}} + 0.25 and {{Luck}} + 0.5 per letter in your player character's name.")
end
--Egocentrism moment

--Stats
function NAME_TAG:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.NAME_TAG) then return end
	local Multiplier = player:GetCollectibleNum(Items.NAME_TAG, false) * #player:GetName()
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
	  player.Damage=player.Damage+Multiplier*NameTagPerCharBonus.DAMAGE
	end
	if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
	  player.Luck=player.Luck+Multiplier*NameTagPerCharBonus.LUCK
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, NAME_TAG.onCache)

function NAME_TAG:onItemGet(player, type)
	--print("test")
	local room = Game():GetRoom()
	if type == Isaac.GetItemIdByName("Name Tag") then
		local nameLen = #player:GetName()
		local spelledString = ""
		for i=1,nameLen do
			local letterToAdd = ""
			if string.sub(player:GetName(),i,i) == " " then
				letterToAdd = "[space]"
			else
				letterToAdd = string.sub(player:GetName(),i,i)
			end
			spelledString = spelledString .. letterToAdd 
			if i ~= nameLen then
				spelledString = spelledString .. "-"
			end
		end
		--spelled string should be in name
		local str = spelledString
		local AbacusFont = Font()
		AbacusFont:Load("font/pftempestasevencondensed.fnt")
		for i = 1, 60 do
			BotB.FF.scheduleForUpdate(function()
				local pos = game:GetRoom():WorldToScreenPosition(player.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(player.SpriteScale.Y * 35) - i/2)
				local opacity
				if i >= 30 then
					opacity = 1 - ((i-30)/30)
				else
					opacity = i/15
				end
				AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
			end, i, ModCallbacks.MC_POST_RENDER)
		end
	end
end
Mod:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, NAME_TAG.onItemGet)

