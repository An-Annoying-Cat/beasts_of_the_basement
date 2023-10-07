local Mod = BotB
local KROKODIL = {}
local sfx = SFXManager()


if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Krokodil"), "Enemies have a chance to Bone Spurs and red creep on hit, and Bone Orbitals and Morbid Chunks on death.")
end

function KROKODIL:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

	function KROKODIL:NPCDeathCheck(entity,amount)
		--print("hurmt")
		if not entity:IsEnemy() then return end
		if not entity:IsVulnerableEnemy() then return end
		if amount >= entity.HitPoints then
			--print("khill")
			local players = BotB.Functions:GetPlayers()
				local doTheyActuallyHaveThem = false
				for i=1,#players,1 do
					if players[i]:HasCollectible(BotB.Enums.Items.KROKODIL) then
						local wigglyBoyPlayer = players[i]:ToPlayer()
						doTheyActuallyHaveThem = true
						--
						local wigglyBoyThreshold = 125+(players[i].Luck*50)
						if wigglyBoyThreshold < 125 then
							wigglyBoyThreshold = 125
							--Base 1 in 8 chance even if luck is negative
						end
						if math.random(0,1000) <= wigglyBoyThreshold then
							--bone orbital
							local amountOfBones = math.random(1,3)
							for i=1,amountOfBones do
								local minion = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL, 0, entity.Position, Vector(math.random(5,25),0):Rotated(math.random(0,359)), nil)
								--minion.EntityCollisionClass = 4
							end
							
						end
						if math.random(0,1000) <= math.floor(wigglyBoyThreshold / 2) then
							--morbid chunk
							local minion = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, Isaac.GetEntityVariantByName("Morbid Chunk"), 0, entity.Position, Vector.Zero, nil)
							minion.EntityCollisionClass = 4
						end
					end
				end
			if doTheyActuallyHaveThem ~= false then return end
		else
			local players = BotB.Functions:GetPlayers()
				local doTheyActuallyHaveThem = false
				for i=1,#players,1 do
					if players[i]:HasCollectible(BotB.Enums.Items.KROKODIL) then
						local wigglyBoyPlayer = players[i]:ToPlayer()
						doTheyActuallyHaveThem = true
						--
						local wigglyBoyThreshold = 125+(players[i].Luck*50)
						if wigglyBoyThreshold < 125 then
							wigglyBoyThreshold = 125
							--Base 1 in 8 chance even if luck is negative
						end
						if math.random(0,1000) <= wigglyBoyThreshold then
							--bone orbital
							local amountOfCreep = math.random(1,3)
							for i=1,amountOfCreep do
								local minion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, entity.Position+Vector(math.random(0,50),0):Rotated(math.random(0,359)), Vector.Zero, nil)
								--minion.EntityCollisionClass = 4
							end
							
						end
						if math.random(0,1000) <= math.floor(wigglyBoyThreshold / 2) then
							--morbid chunk
							local amountOfCreep = math.random(1,3)
							for i=1,amountOfCreep do
								local minion = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_SPUR, 0, entity.Position+Vector(math.random(0,50),0):Rotated(math.random(0,359)), Vector(math.random(1,5),0):Rotated(math.random(0,359)), nil)
								--minion.EntityCollisionClass = 4
							end
						end
					end
				end
			if doTheyActuallyHaveThem ~= false then return end
		end
		--Check if anyone has the item
		
	end

	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, KROKODIL.NPCDeathCheck)
