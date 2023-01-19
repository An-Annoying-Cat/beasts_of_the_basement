---@diagnostic disable: duplicate-set-field



local function CheckCollectedItems(player, playerState)
	local itemConfig = Isaac.GetItemConfig()
	local itemList = itemConfig:GetCollectibles()

	for id = 1, itemList.Size - 1, 1 do
		local item = itemConfig:GetCollectible(id)
		if item and item.Type ~= ItemType.ITEM_ACTIVE then
			local itemId = item.ID
			local itemIdStr = tostring(itemId)

			local pastCollectibleNum = playerState.CollectedItems[itemIdStr] or 0
			local actualCollectibleNum = player:GetCollectibleNum(itemId, true)

			if actualCollectibleNum > pastCollectibleNum then
				playerState.CollectedItems[itemIdStr] = actualCollectibleNum
				for _ = 1, actualCollectibleNum - pastCollectibleNum, 1 do
					table.insert(playerState.InventoryOrdered, { Type = TSIL.Enums.InventoryType.COLLECTIBLE, Id = itemId })
				end

				TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, player, itemId)
			elseif actualCollectibleNum < pastCollectibleNum then
				playerState.CollectedItems[itemIdStr] = actualCollectibleNum

				for i = 1, #playerState.InventoryOrdered, 1 do
					local inventoryItem = playerState.InventoryOrdered[i]
					if inventoryItem.Type == TSIL.Enums.InventoryType.COLLECTIBLE and inventoryItem.Id == itemId then
						for _ = 1, pastCollectibleNum - actualCollectibleNum, 1 do
							table.remove(playerState.InventoryOrdered, i)
						end
						break
					end
				end

				TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_REMOVED, player, itemId)
			end
		end
	end
end


local function CheckGulpedTrinkets(player, playerState)
	local itemConfig = Isaac.GetItemConfig()
	local trinketList = itemConfig:GetTrinkets()

	for id = 1, trinketList.Size - 1, 1 do
		local trinket = itemConfig:GetTrinket(id)
		if trinket then
			local trinketId = trinket.ID
			local trinketIdStr = tostring(trinketId)

			local pastGulpedNum = playerState.GulpedTrinkets[trinketIdStr] or 0
			local actualGulpedNum = TSIL.Players.GetSmeltedTrinketMultiplier(player, trinketId)

			if actualGulpedNum > pastGulpedNum then
				playerState.GulpedTrinkets[trinketIdStr] = actualGulpedNum

				for _ = 1, actualGulpedNum - pastGulpedNum, 1 do
					table.insert(playerState.InventoryOrdered, { Type = TSIL.Enums.InventoryType.TRINKET, Id = trinketId })
				end

				TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_PLAYER_GULPED_TRINKET_ADDED, player, trinketId)
			elseif actualGulpedNum < pastGulpedNum then
				playerState.GulpedTrinkets[trinketIdStr] = actualGulpedNum

				for i = 1, #playerState.InventoryOrdered, 1 do
					local inventoryItem = playerState.InventoryOrdered[i]
					if inventoryItem.Type == TSIL.Enums.InventoryType.TRINKET and inventoryItem.Id == trinketId then

						for _ = 1, pastGulpedNum - actualGulpedNum, 1 do
							table.remove(playerState.InventoryOrdered, i)
						end

						break
					end
				end

				TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_PLAYER_GULPED_TRINKET_REMOVED, player, trinketId)
			end
		end
	end
end


local function OnPeffectUpdate(_, player)
	local playerInventories = TSIL.SaveManager.GetPersistentVariable(TSIL.__MOD, "PLAYER_INVENTORIES")
	local playerIndex = TSIL.Players.GetPlayerIndex(player)
	local playerInventory = TSIL.Utils.Tables.FindFirst(playerInventories, function(_, playerInventory)
		return playerInventory.PlayerIndex == playerIndex
	end)

	if not playerInventory then
		local newInventory = {
			PlayerIndex = playerIndex,
			InventoryOrdered = {},
			GulpedTrinkets = {},
			CollectedItems = {}
		}
		table.insert(playerInventories, newInventory)

		playerInventory = newInventory
	end

	CheckCollectedItems(player, playerInventory)

	CheckGulpedTrinkets(player, playerInventory)
end
TSIL.__AddInternalCallback(
	"PLAYER_INVENTORY_PEFFECT_UPDATE",
	ModCallbacks.MC_POST_PEFFECT_UPDATE,
	OnPeffectUpdate
)


local function OnTSILLoaded()
	TSIL.SaveManager.AddPersistentVariable(TSIL.__MOD, "PLAYER_INVENTORIES", {}, TSIL.Enums.VariablePersistenceMode.RESET_RUN)
end
TSIL.__AddInternalCallback(
	"PLAYER_INVENTORY_TSIL_LOADED",
	TSIL.Enums.CustomCallback.POST_TSIL_LOAD,
	OnTSILLoaded
)

function TSIL.Players.GetPlayerInventory(player, inventoryTypeFilter)
	local playerIndex = TSIL.Players.GetPlayerIndex(player)

	local TablesUtils = TSIL.Utils.Tables

	local playerInventories = TSIL.SaveManager.GetPersistentVariable(TSIL.__MOD, "PLAYER_INVENTORIES")

	local chosenInventory = TablesUtils.Filter(playerInventories, function(_, playerInventory)
		return playerInventory.PlayerIndex == playerIndex
	end)[1].InventoryOrdered

	if inventoryTypeFilter then
		local filteredInventory = TablesUtils.Filter(chosenInventory, function(_, inventoryItem)
			return inventoryItem.Type == inventoryTypeFilter
		end)

		return filteredInventory
	else
		return TablesUtils.Copy(chosenInventory)
	end
end
