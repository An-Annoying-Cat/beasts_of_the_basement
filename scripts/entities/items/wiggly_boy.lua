local Mod = BotB
local WIGGLY_BOY = {}
local sfx = SFXManager()


if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Wiggly Boy"), "Enemies have a chance to spawn Minisaacs on death. #{{Luck}} Base chance is 1 in 8, but is subtly affected by luck. #100% chance to spawn at 50 luck. #Additional copies make more Minisaacs spawn at once.")
end

function WIGGLY_BOY:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

	function WIGGLY_BOY:NPCDeathCheck(entity,amount)
		--print("hurmt")
		if not entity:IsEnemy() then return end
		if not entity:IsVulnerableEnemy() then return end
		if amount >= entity.HitPoints then
			--print("khill")
			local players = BotB.Functions:GetPlayers()
				local doTheyActuallyHaveThem = false
				for i=1,#players,1 do
					if players[i]:HasCollectible(BotB.Enums.Items.WIGGLY_BOY) then
						local wigglyBoyPlayer = players[i]:ToPlayer()
						doTheyActuallyHaveThem = true
						--
						local wigglyBoyThreshold = 125+(players[i].Luck*50)
						if wigglyBoyThreshold < 125 then
							wigglyBoyThreshold = 125
							--Base 1 in 8 chance even if luck is negative
						end
						if math.random(0,1000) <= wigglyBoyThreshold then
							for i=1,players[i]:GetCollectibleNum(BotB.Enums.Items.WIGGLY_BOY, false),1 do
								wigglyBoyPlayer:AddMinisaac(entity.Position, true)
							end
						end
					end
				end
			if doTheyActuallyHaveThem ~= false then return end

		end
		--Check if anyone has the item
		
	end

	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, WIGGLY_BOY.NPCDeathCheck)
