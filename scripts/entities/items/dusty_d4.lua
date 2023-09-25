local Mod = BotB
local mod = FiendFolio
local DUSTY_D4 = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Dusty D4"), "Rerolls a single passive item the player possesses. #This reroll is weighted toward items of lower quality.")
end

--returns a table of tables accessible by the quality number
function DUSTY_D4:getDustyD4CandidateItems(player)
	--HiddenItemManager:RemoveAll(player, "FLASHCART_DUPES")
	local itemConfig = Isaac.GetItemConfig()
	
	local candidateItems = {
		zero = {},
		one = {},
		two = {},
		three = {},
		four = {},
		amt = 0,
	}
	if #candidateItems == 0 then
		-- Player has no confirmed "stackable" items. Fall back to any items that they're holding.
		for id=1, itemConfig:GetCollectibles().Size-1 do
			local item = itemConfig:GetCollectible(id)
			if item and item.Type ~= ItemType.ITEM_ACTIVE and not item:HasTags(ItemConfig.TAG_QUEST) and player:HasCollectible(id, true) then
				local quality = item.Quality
				if quality == 0 then
					table.insert(candidateItems.zero, id)
					candidateItems.amt = candidateItems.amt + 1
				elseif quality == 1 then
					table.insert(candidateItems.one, id)
					candidateItems.amt = candidateItems.amt + 1
				elseif quality == 2 then
					table.insert(candidateItems.two, id)
					candidateItems.amt = candidateItems.amt + 1
				elseif quality == 3 then
					table.insert(candidateItems.three, id)
					candidateItems.amt = candidateItems.amt + 1
				elseif quality == 4 then
					table.insert(candidateItems.four, id)
					candidateItems.amt = candidateItems.amt + 1
				end
				
			end
		end
	end
	--HiddenItemManager:RemoveAll(player, "FLASHCART_DUPES")
	return candidateItems
end



function DUSTY_D4:dustyD4ActiveItem(_, _, player, _, _, _)
	--print("lol how do i card")
	--print(#Isaac.GetItemConfig():GetCards())
	--At least I can get how many cards there are!
	--local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
	--Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
	local dustyD4Candidates = DUSTY_D4:getDustyD4CandidateItems(player)
	if dustyD4Candidates.amt ~= 0 then 
		if #dustyD4Candidates.zero ~= 0 then
			local itemToRemove = dustyD4Candidates.zero[math.random(1,#dustyD4Candidates.zero)]
			player:AnimateCollectible(itemToRemove)
			player:RemoveCollectible(itemToRemove, true)
		elseif #dustyD4Candidates.one ~= 0 then
			local itemToRemove = dustyD4Candidates.one[math.random(1,#dustyD4Candidates.one)]
			player:AnimateCollectible(itemToRemove)
			player:RemoveCollectible(itemToRemove, true)
		elseif #dustyD4Candidates.two ~= 0 then
			local itemToRemove = dustyD4Candidates.two[math.random(1,#dustyD4Candidates.two)]
			player:AnimateCollectible(itemToRemove)
			player:RemoveCollectible(itemToRemove, true)
		elseif #dustyD4Candidates.three ~= 0 then
			local itemToRemove = dustyD4Candidates.three[math.random(1,#dustyD4Candidates.three)]
			player:AnimateCollectible(itemToRemove)
			player:RemoveCollectible(itemToRemove, true)
		elseif #dustyD4Candidates.four ~= 0 then
			local itemToRemove = dustyD4Candidates.three[math.random(1,#dustyD4Candidates.three)]
			player:AnimateCollectible(itemToRemove)
			player:RemoveCollectible(itemToRemove, true)
		end
		SFXManager():Play(SoundEffect.SOUND_DEATH_CARD,1,0,false,math.random(200,300)/100,0)
		Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,0,Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 1, true, false),Vector.Zero,player)
	else
		SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1,0,false,math.random(700,1300)/1000,0)
	end
	
            

end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,DUSTY_D4.dustyD4ActiveItem,Isaac.GetItemIdByName("Dusty D4"))



