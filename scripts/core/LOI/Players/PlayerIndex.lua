---@diagnostic disable: duplicate-set-field

function TSIL.Players.GetPlayerIndex(player)
	return player:GetCollectibleRNG(1):GetSeed()
end


