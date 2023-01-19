local Mod = BotB
local MUDPIE = {}
local Items = BotB.Enums.Items

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Mud Pie"), "+1 max health.#Spawns Dirt Clump and a random worm trinket. #{{Warning}} This item includes the modded worm trinkets from Fiend Folio and Retribution if their respective mods are present! If there are any more major mods that add worm trinkets, please let me know so I can add them!")
end

local wormNames = {
	TrinketType.TRINKET_PULSE_WORM,
	TrinketType.TRINKET_WIGGLE_WORM,
	TrinketType.TRINKET_RING_WORM,
	TrinketType.TRINKET_FLAT_WORM,
	TrinketType.TRINKET_HOOK_WORM,
	TrinketType.TRINKET_WHIP_WORM,
	TrinketType.TRINKET_RAINBOW_WORM,
	TrinketType.TRINKET_TAPE_WORM,
	TrinketType.TRINKET_LAZY_WORM,
	TrinketType.TRINKET_OUROBOROS_WORM,
	TrinketType.TRINKET_BRAIN_WORM
}

if FiendFolio then
	--print("ff worms added")
	wormNames[#wormNames+1] = Isaac.GetTrinketIdByName("Fortune Worm")
	wormNames[#wormNames+1] = Isaac.GetTrinketIdByName("Trinity Worm")
end
if Retribution then
	--print("ret worms added")
	wormNames[#wormNames+1] = Isaac.GetTrinketIdByName("Heart Worm")
end

--print("your super special random worm is " .. wormNames[math.random(#wormNames)])

function MUDPIE:onItemGet(player, type)
	print("test")
	local room = Game():GetRoom()
	if type == Isaac.GetItemIdByName("Mud Pie") then
		local room = game:GetRoom()
		local pickup = Isaac.Spawn(5, 350, Isaac.GetTrinketIdByName("Dirt Clump"), room:FindFreePickupSpawnPosition(player.Position, 20), Vector.Zero, player)
		local pickup2 = Isaac.Spawn(5, 350, wormNames[math.random(#wormNames)], room:FindFreePickupSpawnPosition(player.Position, 20), Vector.Zero, player)
	end
end
Mod:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, MUDPIE.onItemGet)