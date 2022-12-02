local Functions = {}

local Mod = BotB
local game = Mod.Game

---- GET PLAYERS
function Functions:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end
--- GET PLAYERS WITH ITEM
function Functions:GetPlayersWithItem(collectible)
	local playersWithItem = {}

	for i = 1, game:GetNumPlayers() do
		if game:GetPlayer(i):HasCollectible(collectible) then
			table.insert(playersWithItem, game:GetPlayer(i))
		end
	end

	return playersWithItem
end
--- GET FIRST PLAYER WITH ITEM
function Functions:GetFirstPlayerWithCollectible(collectible)
	local selectedPlayer

	for _, v in pairs(Functions:GetPlayers()) do
		selectedPlayer = selectedPlayer or v:HasCollectible(collectible) and v:ToPlayer()
	end

	return selectedPlayer
end

Functions.item_exists = Functions.GetFirstPlayerWithCollectible

--- GET FIRST PLAYER WITH TRINKET 
function Functions:GetFirstPlayerWithTrinket(trinket)
	local selectedPlayer 

	for _, v in pairs(Functions:GetPlayers()) do
		selectedPlayer = selectedPlayer or v:HasTrinket(trinket) and v:ToPlayer()
	end

	return selectedPlayer
end

BotB.Functions = Functions