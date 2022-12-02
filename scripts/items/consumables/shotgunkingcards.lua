local Mod = BotB

if EID then
	EID:addCard(Mod.Enums.Consumables.CARDS.CORNERED_DESPOT, "Grants a large fire rate boost (-2 fire rate) for the room when within 2 tiles of the room's edge.")
	EID:addCard(Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE, "Grants an aura that pushes away projectiles, and repels enemies while lightly damaging them.")
	EID:addCard(Mod.Enums.Consumables.CARDS.HOMECOMING, "Turns the non-boss enemy with the highest base HP into a rainbow champion.#{{Warning}} Only works on enemies capable of becoming champions in the first place.")
	EID:addCard(Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT, "Doubles the max health of all enemies in the room.#All affected enemies drop pickups on death.")
end

--Todo: Literally everything lmao

	function Mod:corneredDespotInit(cardID, player)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
	end

	function Mod:augustPresenceInit(cardID, player)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
	end

	function Mod:homecomingTransform(cardID, player)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
	end

	function Mod:ammoDepotTransform(cardID, player)
		sfx:Play(Isaac.GetSoundIdByName("ShotgunKingCard"),1,0,false,1)
	end

	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.corneredDespotInit, Mod.Enums.Consumables.CARDS.CORNERED_DESPOT)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.augustPresenceInit, Mod.Enums.Consumables.CARDS.AUGUST_PRESENCE)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.homecomingTransform, Mod.Enums.Consumables.CARDS.HOMECOMING)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.ammoDepotTransform, Mod.Enums.Consumables.CARDS.AMMUNITION_DEPOT)