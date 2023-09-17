local Mod = BotB
local mod = FiendFolio
local E_METER = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local Items = BotB.Enums.Items

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("E-Meter"), "This active item can be switched between two modes: In and Out; via pressing the map key. #In: Stores the consumable in the room you are closest to permanently. #Out: Uses a random consumable from storage. #The more consumables are in storage, the less charges it takes to use Out. #{{Warning}} For code limitation reasons, this item does not work on pills.")
	EID:addCollectible(Isaac.GetItemIdByName("E-Meter (In)"), "This active item can be switched between two modes: In and Out; via pressing the map key. #In: Stores the consumable in the room you are closest to permanently. #Out: Uses a random consumable from storage. #The more consumables are in storage, the less charges it takes to use Out. #{{Warning}} For code limitation reasons, this item does not work on pills.")
	EID:addCollectible(Isaac.GetItemIdByName("E-Meter (Out)"), "This active item can be switched between two modes: In and Out; via pressing the map key. #In: Stores the consumable in the room you are closest to permanently. #Out: Uses a random consumable from storage. #The more consumables are in storage, the less charges it takes to use Out. #{{Warning}} For code limitation reasons, this item does not work on pills.")
end
	--[[
	function E_METER:onItemGet(player, type)
		----print("test")
		local room = Game():GetRoom()
		if type == Isaac.GetItemIdByName("E-Meter") then
			player:RemoveCollectible(BotB.Enums.Items.EMETER_COLLECTIBLE)
			player:AddCollectible(Items.EMETER_IN, 0, false, ActiveSlot.SLOT_PRIMARY)
		end
	end
	Mod:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, E_METER.onItemGet)
	]]


	function E_METER:eMeterInActiveItem(_, _, player, _, _, _)
		player:AnimateCollectible(Isaac.GetItemIdByName("E-Meter"))
		local data = player:GetData()
		if data.botbEMeterTable == nil then
			data.botbEMeterTable = { {useFunctionType = "card", useID = "1"},}
		end
		local eMeterTable = data.botbEMeterTable
		--print("in")

		--find the nearest card
		local roomCards = Isaac.GetRoomEntities()
		local bestCardCandidate
		--local relevantCard
		local initialComparisonDist = 300
		--This is also the maximum search distance, so I'm probably going to lower it so it isn't broken
		for i = 1, #roomCards do
			local entity = roomCards[i]
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then
				--print("card located " .. entity.Type, entity.Variant, entity.SubType)
				if player.Position:Distance(entity.Position) < initialComparisonDist then
					bestCardCandidate = entity
					initialComparisonDist = player.Position:Distance(entity.Position)
				end
			end
		end
		--print("best is " .. bestCardCandidate.Type, bestCardCandidate.Variant, bestCardCandidate.SubType)
		--this should end up pickingthe nearest card

		if bestCardCandidate ~= nil then
			--print("card " .. bestCardCandidate.SubType)
			--append card to table
			data.botbEMeterTable[#data.botbEMeterTable+1] = {
				useFunctionType = "card",
				useID = bestCardCandidate.SubType,
			}
			SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS,1,0,false,0.5,0)
			--player:DropPocketItem(0, Vector(99999,99999))
			bestCardCandidate:Remove()
			data.botbEMeterSwappedCharges = data.botbEMeterSwappedCharges + 2
		--[[
		elseif player:GetPill(0) ~= 0 then
			--print("pill " .. player:GetPill(0))
			data.botbEMeterTable[#data.botbEMeterTable+1] = {
				useFunctionType = "pill",
				useID = player:GetPill(0),
			}
			SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS,1,0,false,0.5,0)
			player:DropPocketItem(0, Vector(999,999))
			]]
		else
			SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1,0,false,1,0)
		end

		--[[
		if player:GetCard(0) ~= 0 then
			--print("card " .. player:GetCard(0))
			--append card to table
			data.botbEMeterTable[#data.botbEMeterTable+1] = {
				useFunctionType = "card",
				useID = player:GetCard(0),
			}
			SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS,1,0,false,0.5,0)
			player:DropPocketItem(0, Vector(99999,99999))

		else
			SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ,1,0,false,1,0)
		end]]
		

	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,E_METER.eMeterInActiveItem,Isaac.GetItemIdByName("E-Meter (In)"))

	function E_METER:eMeterOutActiveItem(_, _, player, _, _, _)
		player:AnimateCollectible(Isaac.GetItemIdByName("E-Meter"))
		local data = player:GetData()
		local eMeterTable = data.botbEMeterTable
		--have to use the UseFunctionType cuz cards and pills and other shit have different use types
		if data.botbEMeterTable ~= nil then
			--print("we have the table")
			if #data.botbEMeterTable ~= 0 then
				--here we go!!!
				local eMeterUseTableIndex = math.random(1,#data.botbEMeterTable)
				if data.botbEMeterTable[eMeterUseTableIndex].useFunctionType == "card" then

					player:UseCard(data.botbEMeterTable[eMeterUseTableIndex].useID, 0)
				--[[
				elseif data.botbEMeterTable[eMeterUseTableIndex].useFunctionType == "pill" then

					--UsePill is kind of bullshit so gonna have to do a kind of hack here
					--Store current pocket item, set current pocket to pill, use placebo, remove pill and replace pocket item
					local pocketToReplace = {}
					if player:GetCard(0) ~= 0 then
						--print("card " .. player:GetCard(0))
						--append card to table
						pocketToReplace = {
							useFunctionType = "card",
							useID = player:GetCard(0),
						}
					elseif player:GetPill(0) ~= 0 then
						--print("pill " .. player:GetPill(0))
						pocketToReplace = {
							useFunctionType = "pill",
							useID = player:GetPill(0),
						}
					end
					player:SetPill(0, data.botbEMeterTable[eMeterUseTableIndex].useID)
					player:UseActiveItem(CollectibleType.COLLECTIBLE_PLACEBO, UseFlag.USE_NOANIM)
					--player:DropPocketItem(1, Vector.Zero)
					
					if pocketToReplace.useFunctionType == "card" then
						player:SetCard(0, pocketToReplace.useID)
					elseif pocketToReplace.useFunctionType == "pill" then
						player:SetPill(0,pocketToReplace.useID)
					end
					]]

				end

			end

		end

	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,E_METER.eMeterOutActiveItem,Isaac.GetItemIdByName("E-Meter (Out)"))

	function E_METER:eMeterPlayerUpdate(player)
		for i=0,3,1 do
			--bulk check every active slot cuz fuck it
			if (not player:GetActiveItem(i) == Items.EMETER_COLLECTIBLE) 
			or (not player:GetActiveItem(i) == Items.EMETER_IN) 
			or (not player:GetActiveItem(i) == Items.EMETER_OUT) 
			then return end
		end
		local data = player:GetData()
		if data.botbEMeterTable == nil then
			data.botbEMeterTable = {}
			data.botbEMeterSwappedCharges = 0
		end
		
		--
		if player:GetActiveItem(0) == Items.EMETER_COLLECTIBLE then
			--remove the dummy collectible
			player:RemoveCollectible(BotB.Enums.Items.EMETER_COLLECTIBLE)
			player:AddCollectible(Items.EMETER_IN, 0, false, ActiveSlot.SLOT_PRIMARY)
		end

		if Input.IsActionTriggered(ButtonAction.ACTION_MAP, player.ControllerIndex) then
			--data.botbEMeterSwappedCharges = 0
			--drop is pressed
			--print("drop pressed")
			--
			if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == Items.EMETER_OUT then
				--out to in
				data.botbEMeterSwappedCharges = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
				--print("swapped charges = " .. data.botbEMeterSwappedCharges)
				player:RemoveCollectible(BotB.Enums.Items.EMETER_OUT)
				player:AddCollectible(Items.EMETER_IN, 0, false, ActiveSlot.SLOT_PRIMARY)

			elseif player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == Items.EMETER_IN then
				--in to out
				player:RemoveCollectible(Items.EMETER_IN)
				player:AddCollectible(BotB.Enums.Items.EMETER_OUT, 0, false, ActiveSlot.SLOT_PRIMARY)
				player:SetActiveCharge(data.botbEMeterSwappedCharges, ActiveSlot.SLOT_PRIMARY)
				--print("init with " .. data.botbEMeterSwappedCharges .. " charges")
			end
			--[[
			if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == Isaac.GetItemIdByName("E-Meter (Out)") then
				player:RemoveCollectible(Isaac.GetItemIdByName("E-Meter (Out)"), true, ActiveSlot.SLOT_PRIMARY)
				player:AddCollectible(Items.EMETER_IN, 0, false, ActiveSlot.SLOT_PRIMARY)
			end
			Game():GetHUD():InvalidateActiveItem(player, ActiveSlot.SLOT_PRIMARY)
			Game():GetHUD():Update()
			--print(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) .. " vs. " .. Isaac.GetItemIdByName("E-Meter (In)") )
			]]
		end

		if Input.IsActionTriggered(ButtonAction.ACTION_ITEM, player.ControllerIndex) then
			--data.botbEMeterSwappedCharges = 0
			--drop is pressed
			--print("item pressed")
			--
			if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == Items.EMETER_OUT then
				player:DischargeActiveItem(ActiveSlot.SLOT_PRIMARY)
				local eMeterChargeBonus = math.floor(#data.botbEMeterTable/3)
				if eMeterChargeBonus > 4 then
					eMeterChargeBonus = 4
				end
				TSIL.Charge.AddCharge(player,ActiveSlot.SLOT_PRIMARY,eMeterChargeBonus,true)
			end
			--[[
			if player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) == Isaac.GetItemIdByName("E-Meter (Out)") then
				player:RemoveCollectible(Isaac.GetItemIdByName("E-Meter (Out)"), true, ActiveSlot.SLOT_PRIMARY)
				player:AddCollectible(Items.EMETER_IN, 0, false, ActiveSlot.SLOT_PRIMARY)
			end
			Game():GetHUD():InvalidateActiveItem(player, ActiveSlot.SLOT_PRIMARY)
			Game():GetHUD():Update()
			--print(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY) .. " vs. " .. Isaac.GetItemIdByName("E-Meter (In)") )
			]]
		end


	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,E_METER.eMeterPlayerUpdate)






--[[
	function E_METER:eMeterPickupDeleteHack(pickup)
		if pickup.Position == Vector(99999,99999) then
			pickup:Remove()
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT,E_METER.eMeterPickupDeleteHack,PickupVariant.PICKUP_TAROTCARD)
	]]





