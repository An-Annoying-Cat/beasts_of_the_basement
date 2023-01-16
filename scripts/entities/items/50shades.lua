local Mod = BotB
local FIFTY_SHADES = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local fiftyShadesBaseDuration = 480

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("50 Shades Of Grey"), "Charms or baits every enemy in the room for 8 seconds. #Whichever status an enemy recieves is chosen at random.")
end

function FIFTY_SHADES:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

	function FIFTY_SHADES:shadesActiveItem(_, _, player, _, _, _)
		player:AnimateCollectible(Isaac.GetItemIdByName("50 Shades Of Grey"))
		sfx:Play(BotB.FF.Sounds.EnergyFairy,3,0,false,math.random(8000,12000)/10000)
		for i, entity in ipairs(Isaac.GetRoomEntities()) do
			if entity:IsVulnerableEnemy() then
				local coinFlip = math.random(0,1)
				local statusDurationMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND)
				if coinFlip == 0 then
					entity:AddCharmed(EntityRef(player), fiftyShadesBaseDuration + (fiftyShadesBaseDuration * statusDurationMultiplier))
				else
					entity:GetData().fiftyShadesBaitTimer = fiftyShadesBaseDuration + (fiftyShadesBaseDuration * statusDurationMultiplier)
				end
				
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,FIFTY_SHADES.shadesActiveItem,Isaac.GetItemIdByName("50 Shades Of Grey"))

--Why the fuck isn't there a function to add the Bait status effect on a timer >:(   -millie
function FIFTY_SHADES:baitUpdate(npc)
		local sprite = npc:GetSprite()
		local player = npc:GetPlayerTarget()
		local data = npc:GetData()

		if data.fiftyShadesBaitTimer ~= nil then
			if data.fiftyShadesBaitTimer ~= 0 then
				npc:AddEntityFlags(EntityFlag.FLAG_BAITED)
				data.fiftyShadesBaitTimer = data.fiftyShadesBaitTimer - 1
				npc.Color = Color(0.05,0,0,255)
			else
				data.fiftyShadesBaitTimer = nil
				npc:ClearEntityFlags(EntityFlag.FLAG_BAITED)
				npc.Color = Color(0,0,0,255)
			end
		end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FIFTY_SHADES.baitUpdate)