local Mod = BotB
local YGOCARDS = {}

if EID then
	EID:addCard(Mod.Enums.Consumables.CARDS.TIME_WIZARD, "Uses 1 of 3 effects at random: #Uses {{Collectible".. CollectibleType.COLLECTIBLE_HOURGLASS .."}} Hourglass. #Uses {{Collectible".. CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS .."}} Glowing Hourglass.  #Grants {{Collectible".. CollectibleType.COLLECTIBLE_STOP_WATCH .."}} Stop Watch for the floor. #Has a 1% chance to use {{Collectible".. CollectibleType.COLLECTIBLE_R_KEY .."}} R Key.")
end

local hiddenItemManager = require("scripts.core.hidden_item_manager")

--Use player:GetData().activeRoomCards for cards whose effects last for one room
--Use player:GetData().activeFloorCards for cards whose effects last for the floor

--Time Wizard
function YGOCARDS:timeWizardInit(cardID, player)
	local data = player:GetData()
	--print("AugPres = " .. Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	local timeWizardRandomInt = math.random(0,100)
	--print("TimeWizardRando = " .. timeWizardRandomInt)
	--use R Key if it's 100
	if timeWizardRandomInt == 100 then
		--Time to use R Key!
		player:UseActiveItem(CollectibleType.COLLECTIBLE_R_KEY, UseFlag.USE_NOANIM)
	end
	if player:HasCollectible(CollectibleType.COLLECTIBLE_TAROT_CLOTH, false) then
		local timeWizardRandomInt = math.random(0,2)

	else
		local timeWizardRandomInt = math.random(0,2)
		--0: Hourglass
		--1: Glowing Hourglass
		--2: Stopwatch
		if timeWizardRandomInt == 0 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_HOURGLASS, UseFlag.USE_NOANIM)
		end
		if timeWizardRandomInt == 1 then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, UseFlag.USE_NOANIM)
		end
		if timeWizardRandomInt == 2 then
			hiddenItemManager:AddForFloor(player, CollectibleType.COLLECTIBLE_STOP_WATCH)
		end
	end
	sfx:Play(BotB.Enums.SFX.YUGIOH_CARD,2,0,false,1)
end
Mod:AddCallback(ModCallbacks.MC_USE_CARD, YGOCARDS.timeWizardInit, Mod.Enums.Consumables.CARDS.TIME_WIZARD)
