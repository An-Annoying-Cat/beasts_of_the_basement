local Mod = BotB
local MUDPIE = {}
local Items = BotB.Enums.Items
local wormTable = {
	Isaac.GetTrinketIdByName("Pulse Worm"),
	Isaac.GetTrinketIdByName("Wiggle Worm"),
	Isaac.GetTrinketIdByName("Ring Worm"),
	Isaac.GetTrinketIdByName("Flat Worm"),
	Isaac.GetTrinketIdByName("Hook Worm"),
	Isaac.GetTrinketIdByName("Whip Worm"),
	Isaac.GetTrinketIdByName("Rainbow Worm"),
	Isaac.GetTrinketIdByName("Tape Worm"),
	Isaac.GetTrinketIdByName("Lazy Worm"),
	Isaac.GetTrinketIdByName("Ouroboros Worm"),
	Isaac.GetTrinketIdByName("Brain Worm"),
	Isaac.GetTrinketIdByName("Fortune Worm"),
	Isaac.GetTrinketIdByName("Trinity Worm"),
}

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Mud Pie"), "+1 max health.#Spawns Dirt Clump and a random worm trinket.")
end

--Spawn dirt clump and a random worm trinket
--[[
FiendFolio.AddItemPickupCallback(function(player)
	print("cock and ball torture")
	local rng = player:GetCollectibleRNG(BotB.Enums.Items.MUD_PIE)
	--local pickupType = FiendFolio.GetRandomObject(rng)
	BotB.Scheduler.Schedule(1,function()
		local room = game:GetRoom()
		local pickup = Isaac.Spawn(5, 350, Isaac.GetTrinketIdByName("Dirt Clump"), room:FindFreePickupSpawnPosition(player.Position, 20)+BotB.FF:shuntedPosition(10, rng), Vector.Zero, nil)
		local wormTable = {
			Isaac.GetTrinketIdByName("Pulse Worm"),
			Isaac.GetTrinketIdByName("Wiggle Worm"),
			Isaac.GetTrinketIdByName("Ring Worm"),
			Isaac.GetTrinketIdByName("Flat Worm"),
			Isaac.GetTrinketIdByName("Hook Worm"),
			Isaac.GetTrinketIdByName("Whip Worm"),
			Isaac.GetTrinketIdByName("Rainbow Worm"),
			Isaac.GetTrinketIdByName("Tape Worm"),
			Isaac.GetTrinketIdByName("Lazy Worm"),
			Isaac.GetTrinketIdByName("Ouroboros Worm"),
			Isaac.GetTrinketIdByName("Brain Worm"),
			Isaac.GetTrinketIdByName("Fortune Worm"),
			Isaac.GetTrinketIdByName("Trinity Worm"),
		}
		local randomWorm = wormTable[math.random(#wormTable)]
		local pickup2 = Isaac.Spawn(5, 350, randomWorm, room:FindFreePickupSpawnPosition(player.Position, 20)+BotB.FF:shuntedPosition(10, rng), Vector.Zero, nil)
	end, {})
end, nil, BotB.Enums.Items.MUD_PIE)
--]]

function MUDPIE:playerUpdate(player)
	local data = player:GetData()
	--local level = Game():GetLevel()
	if data.mudPieAmount == nil then
		data.mudPieAmount = 0
	end
	if data.mudPieAmount < player:GetCollectibleNum(BotB.Enums.Items.MUD_PIE, false) then
		local room = game:GetRoom()
		local pickup = Isaac.Spawn(5, 350, Isaac.GetTrinketIdByName("Dirt Clump"), room:FindFreePickupSpawnPosition(player.Position, 20), Vector.Zero, player)
		
		local randomWorm = wormTable[math.random(#wormTable)]
		print("your worm is " .. randomWorm)
		local pickup2 = Isaac.Spawn(5, 350, randomWorm, room:FindFreePickupSpawnPosition(player.Position, 20), Vector.Zero, player)
		data.mudPieAmount = data.mudPieAmount + 1
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, MUDPIE.playerUpdate, 0)