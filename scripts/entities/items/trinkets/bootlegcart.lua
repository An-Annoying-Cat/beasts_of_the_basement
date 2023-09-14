local Mod = BotB
local BOOTLEG_CARTRIDGE = {}

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("Bootleg Cartridge"), "Getting hurt has a chance to activate the {{Collectible".. Isaac.GetItemIdByName("Unicorn Stump") .."}} Unicorn Stump effect. #{{Luck}} This chance is influenced by player luck.")
end

function BOOTLEG_CARTRIDGE:bootlegCartHurt(ent)
	
	local player = ent:ToPlayer()
	if not player:HasTrinket(Isaac.GetTrinketIdByName("Bootleg Cartridge"), true) then return end
	--print("cocks")
		local rng = player:GetTrinketRNG(Isaac.GetTrinketIdByName("Bootleg Cartridge"))
		local bootlegCartMultiplier = player:GetTrinketMultiplier(Isaac.GetTrinketIdByName("Bootleg Cartridge"))
		local bootlegCartRoll = rng:RandomFloat()
		--print(bootlegCartRoll)
		--print(1 - (0.75^(bootlegCartMultiplier)))
		if bootlegCartRoll < 1 - (0.75^(bootlegCartMultiplier)) then
			player:UseActiveItem(CollectibleType.COLLECTIBLE_UNICORN_STUMP, UseFlag.USE_NOANIM)
		end

end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BOOTLEG_CARTRIDGE.bootlegCartHurt, EntityType.ENTITY_PLAYER)