---@diagnostic disable: duplicate-set-field
function TSIL.Players.AddSmeltedTrinket(player, trinketId)
	local heldTrinket = player:GetTrinket(0)
	local heldTrinket2 = player:GetTrinket(1)

	if heldTrinket == 0 then
		player:AddTrinket(trinketId, false)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)
	else
		if heldTrinket2 ~= 0 then
			player:TryRemoveTrinket(heldTrinket2)
		end

		player:TryRemoveTrinket(heldTrinket)

		player:AddTrinket(trinketId, false)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)

		player:AddTrinket(heldTrinket, false)

		if heldTrinket2 ~= 0 then
			player:AddTrinket(heldTrinket2, false)
		end
	end
end
