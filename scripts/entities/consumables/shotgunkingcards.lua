local Mod = BotB

if EID then
	EID:addCard(Mod.Enums.Consumables.CARDS.CORNERED_DESPOT, "Grants a large fire rate boost (-2 fire rate) for the room when within 2 tiles of the room's edge.")
	EID:addCard(Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE, "Grants an aura that pushes away projectiles, and repels enemies while lightly damaging them.")
	EID:addCard(Mod.Enums.Consumables.CARDS.HOMECOMING, "Turns the non-boss enemy with the highest base HP into a rainbow champion.#{{Warning}} Only works on enemies capable of becoming champions in the first place.")
	EID:addCard(Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT, "Doubles the max health of all enemies in the room.#All affected enemies drop pickups on death.")
end

--Use player:GetData().activeRoomCards for cards whose effects last for one room
--Use player:GetData().activeFloorCards for cards whose effects last for the floor

--Todo: Literally everything lmao

	function Mod:corneredDespotInit(cardID, player)
		print("CornDes = " .. Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
		--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
	end

	function Mod:augustPresenceInit(cardID, player)
		print("AugPres = " .. Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
		--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
	end

	function Mod:homecomingTransform(cardID, player)
		print("HomeCom = " .. Mod.Enums.Consumables.CARDS.HOMECOMING)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
		--Do the conversion shit here. It's just one enemy and it already drops all the stuff, so it doesn't need a table entry
	end

	function Mod:ammoDepotTransform(cardID, player)
		print("AmmDep = " .. Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
		--table.insert(player:GetData().activeRoomCards,Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT)
		--The above line is only here to keep a callback so enemies can drop pickups when killed
	end

	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.corneredDespotInit, Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.augustPresenceInit, Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.homecomingTransform, Mod.Enums.Consumables.CARDS.HOMECOMING)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.ammoDepotTransform, Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT)