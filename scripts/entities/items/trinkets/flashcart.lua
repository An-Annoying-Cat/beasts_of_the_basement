local Mod = BotB
local mod = FiendFolio
local FLASH_CART= {}

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("Flashcart"), "Grants an additional instance of the effect of a passive item the player possesses. #The item it imitates is randomized each new room. #{{Warning}} This is weighted towards items that aren't useless when stacked.")
end

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

local HiddenItemManager = require("scripts.core.hidden_item_manager")
HiddenItemManager:Init(BotB)
--yoinking code from Fiend Folio (namely, loaded dice) so that i can efficiently get items that stack effectively
function FLASH_CART:getLoadedDiceCandidateItems(player)
	--HiddenItemManager:RemoveAll(player, "FLASHCART_DUPES")
	local itemConfig = Isaac.GetItemConfig()
	
	local candidateItems = {}
	
	-- Get all stackable items that the player is holding.
	for id, _ in pairs(mod:GetStackableItemsTable()) do
		if player:HasCollectible(id, true) then
			table.insert(candidateItems, id)
		end
	end
	
	if #candidateItems == 0 then
		-- Player has no confirmed "stackable" items. Fall back to any items that they're holding.
		for id=1, itemConfig:GetCollectibles().Size-1 do
			local item = itemConfig:GetCollectible(id)
			if item and item.Type ~= ItemType.ITEM_ACTIVE and not item:HasTags(ItemConfig.TAG_QUEST) and player:HasCollectible(id, true) then
				table.insert(candidateItems, id)
			end
		end
	end
	--HiddenItemManager:RemoveAll(player, "FLASHCART_DUPES")
	return candidateItems
end



function FLASH_CART:flashCartNewRoom()
	local room = Game():GetRoom()
	--print("balls")
	local players = getPlayers()
	local doesSomeoneHaveFlashcart = false
	for i=1,#players,1 do
		if players[i]:ToPlayer():HasTrinket(Isaac.GetTrinketIdByName("Flashcart")) then
			--print("dicks")
			local playerWithFlashcart = players[i]:ToPlayer()
			--HiddenItemManager:RemoveAll(players[i]:ToPlayer(), "FLASHCART_DUPES")
			local rng = players[i]:ToPlayer():GetTrinketRNG(Isaac.GetTrinketIdByName("Flashcart"))
			local flashcartMultiplier = players[i]:ToPlayer():GetTrinketMultiplier(Isaac.GetTrinketIdByName("Flashcart"))
			--print(flashcartMultiplier)
			--HiddenItemManager:RemoveAll(players[i]:ToPlayer(), "FLASHCART_DUPES")
			local flashcartPossibleItemsTable = FLASH_CART:getLoadedDiceCandidateItems(players[i]:ToPlayer())
			for i=1,flashcartMultiplier,1 do
				--print("gay people")
				local roll = rng:RandomInt(#flashcartPossibleItemsTable)+1
				local newItem = flashcartPossibleItemsTable[roll]
				HiddenItemManager:AddForRoom(players[i]:ToPlayer(), newItem, 0, 1, "FLASHCART_DUPES")
			end
		end
	end

end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, FLASH_CART.flashCartNewRoom)