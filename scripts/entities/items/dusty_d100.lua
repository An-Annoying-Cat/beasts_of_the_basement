local Mod = BotB
local mod = FiendFolio
local DUSTY_D100 = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Dusty D100"), "Uses a random dice effect. #If the dice is passive, i.e. D3 from Fiend Folio, it simply grants the effect for the rest of the floor. #{{Warning}} Includes modded dice! #Compatible mods include: Fiend Folio, Epiphany, Deliverance, and Revelations.")
end

local HiddenItemManager = require("scripts.core.hidden_item_manager")
function DUSTY_D100:dustyD6ActiveItem(_, _, player, _, _, _)
	--player:AnimateCollectible(Isaac.GetItemIdByName("Dusty D100"))
	--print("lol how do i card")
	--print(#Isaac.GetItemConfig():GetCards())
	--At least I can get how many cards there are!
	--local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
	--Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(player.Position, 10),Vector.Zero,player)
	local diceItems = {
		{"active", CollectibleType.COLLECTIBLE_D1,},
		{"active", CollectibleType.COLLECTIBLE_D4,},
		{"active", CollectibleType.COLLECTIBLE_D6,},
		{"active", CollectibleType.COLLECTIBLE_ETERNAL_D6,},
		{"active", CollectibleType.COLLECTIBLE_D7,},
		{"active", CollectibleType.COLLECTIBLE_D8,},
		{"active", CollectibleType.COLLECTIBLE_D10,},
		{"active", CollectibleType.COLLECTIBLE_D12,},
		{"active", CollectibleType.COLLECTIBLE_D20,},
		{"active", CollectibleType.COLLECTIBLE_D100,},
		{"active", CollectibleType.COLLECTIBLE_SPINDOWN_DICE,},
		--ours
		{"active", Isaac.GetItemIdByName("Dusty D6"),},
		{"active", Isaac.GetItemIdByName("Dusty D4"),},
		{"active", Isaac.GetItemIdByName("D11"),},
		--lmao recursion
		{"active", Isaac.GetItemIdByName("Dusty D100"),},
	}
	if FiendFolio then
		local ffDiceItems = {
			{"active", Isaac.GetItemIdByName("Eternal D12"),},
			{"active", Isaac.GetItemIdByName("Eternal D10"),},
			{"active", Isaac.GetItemIdByName("D2"),},
			{"active", Isaac.GetItemIdByName("Azurite Spindown"),},
			{"active", Isaac.GetItemIdByName("Dusty D10"),},
			{"active", Isaac.GetItemIdByName("Loaded D6"),},
			{"passive",Isaac.GetItemIdByName("D3"),},
			{"passive",Isaac.GetItemIdByName("Isaac'D's Eulogy")},
		}
		for i=1, #ffDiceItems do
			diceItems[#diceItems+1] = ffDiceItems[i]
		end
	end
	if Epiphany then
		local epiDiceItems = {
			{"active", Isaac.GetItemIdByName("D5"),},
			{"active", Isaac.GetItemIdByName("Chance Cube"),},
			{"active", Isaac.GetItemIdByName("Blighted Dice"),},
		}
		for i=0,#epiDiceItems do
			diceItems[#diceItems+1] = epiDiceItems[i]
		end
	end
	if Deliverance then
		local delDiceItems = {
			{"active", Isaac.GetItemIdByName("D<3"),},
		}
		for i=1,#delDiceItems do
			diceItems[#diceItems+1] = delDiceItems[i]
		end
	end
	if Revelations then
		local revDiceItems = {
			{"active", Isaac.GetItemIdByName("Hyper Dice"),},
		}
		for i=1,#revDiceItems do
			diceItems[#diceItems+1] = revDiceItems[i]
		end
	end
	--now that THAT's over with
	local randomPick = math.random(1,#diceItems)
	print(diceItems[randomPick][1], diceItems[randomPick][2])
	if diceItems[randomPick][1] == "active" then
		--just use the active
		player:AnimateCollectible(diceItems[randomPick][2])
		player:UseActiveItem(diceItems[randomPick][2], UseFlag.USE_MIMIC)
	elseif diceItems[randomPick][1] == "passive" then
		player:AnimateCollectible(diceItems[randomPick][2])
		HiddenItemManager:AddForFloor(player,diceItems[randomPick][2])
	end
            

end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,DUSTY_D100.dustyD6ActiveItem,Isaac.GetItemIdByName("Dusty D100"))



