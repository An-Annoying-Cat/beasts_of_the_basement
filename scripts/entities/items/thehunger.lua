local Mod = BotB
local THE_HUNGER = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local PLAYER_JEZEBEL = Isaac.GetPlayerTypeByName("Jezebel")

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("The Hunger"), "Active item charged by collecting hearts. #Enemies and bosses passively drop corpses on death. #These corpses come in three sizes: Small, Medium, and Large. #Using this active consumes all the corpses in the room. #Eating corpses heals you depending on how many exist when this active item is used. #Some corpses, dropped by specific demographics of enemy (i.e. ghost, demon, etc.) have special effects when consumed by this item.")
end

function THE_HUNGER:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

	function THE_HUNGER:hungerActiveItem(_, _, player, _, _, _)
		local playerConv = player:ToPlayer()
		local corpseEatQueueInt = 0
		local entities = Isaac.GetRoomEntities()
		local isSuccessful = false
		for i, entity in ipairs(entities) do
			if entity.Type == pickups.ENEMY_CORPSE_SMALL.TYPE and entity.Variant == pickups.ENEMY_CORPSE_SMALL.VARIANT then 
				if entity.SubType == pickups.ENEMY_CORPSE_SMALL.SUBTYPE then
					corpseEatQueueInt = corpseEatQueueInt + 1
					Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_EXPLOSION,0,entity.Position,Vector(0,0),player)
					Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_SPLAT,0,entity.Position,Vector(0,0),player)
					entity:Kill()
					isSuccessful = true
				end
				if entity.SubType == pickups.ENEMY_CORPSE_MEDIUM.SUBTYPE then
					corpseEatQueueInt = corpseEatQueueInt + 2
					Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_EXPLOSION,0,entity.Position,Vector(0,0),player)
					Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_SPLAT,0,entity.Position,Vector(0,0),player)
					entity:Kill()
					isSuccessful = true
				end
				if entity.SubType == pickups.ENEMY_CORPSE_LARGE.SUBTYPE then
					corpseEatQueueInt = corpseEatQueueInt + 4
					Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_EXPLOSION,0,entity.Position,Vector(0,0),player)
					Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_SPLAT,0,entity.Position,Vector(0,0),player)
					entity:Kill()
					isSuccessful = true
				end
			end
		end
		
		

		--Just evening it to make sure
		local technicalHealInt = corpseEatQueueInt
		if corpseEatQueueInt % 2 == 1 then
			corpseEatQueueInt = corpseEatQueueInt - 1
		end
		--corpseEatQueueInt is the amount you actually heal
		if playerConv:GetPlayerType() == PLAYER_JEZEBEL then
			if isSuccessful and technicalHealInt ~= 0 then
				player:AnimateCollectible(Isaac.GetItemIdByName("The Hunger"))
				sfx:Play(SoundEffect.SOUND_VAMP_DOUBLE,1,0,false,1)
				--print("choo choo motherfucker")
				local data = player:GetData()
				--Heal amount minus amount of empty heart containers
				local overheal = (technicalHealInt/2) - (playerConv:GetEffectiveMaxHearts() - playerConv:GetHearts())
				if overheal > 0 then
					--print("overheal time, bitch! you get " .. data.jezOverhealTimer + (120 * technicalHealInt) .. "frames")
					data.jezOverhealTimer = data.jezOverhealTimer + (120 * (technicalHealInt/2))
				end
				playerConv:AddHearts(corpseEatQueueInt/2)
			else
				player:AnimateSad()
				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0,false,1)
			end
		else
			if isSuccessful and corpseEatQueueInt ~= 0 then
				player:AnimateCollectible(Isaac.GetItemIdByName("The Hunger"))
				sfx:Play(SoundEffect.SOUND_VAMP_DOUBLE,1,0,false,1)
				playerConv:AddHearts(corpseEatQueueInt/2)
			else
				player:AnimateSad()
				sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0,false,1)
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,THE_HUNGER.hungerActiveItem,Isaac.GetItemIdByName("The Hunger"))

	--todo: Table of enemy type variant and subtype for each "meat demographic"

	function THE_HUNGER:NPCDeathCheck(entity,amount)
		--print("hurmt")
		local npc = entity:ToNPC()
		if amount >= entity.HitPoints and entity:IsVulnerableEnemy() then
			--print("khill")
			if entity.MaxHitPoints ~= 0 then
				local players = BotB.Functions:GetPlayers()
				local doTheyActuallyHaveThem = false
				for i=1,#players,1 do
					if players[i]:HasCollectible(BotB.Enums.Items.THE_HUNGER) then
						doTheyActuallyHaveThem = true
					end
				end
				if doTheyActuallyHaveThem then
					--print("fucking")
					local maxHealthCorpseQueue = npc.MaxHitPoints
					--print(maxHealthCorpseQueue)
					local corpseSelectQueue = 0
					local corpseIterand = 0
					repeat
						corpseSelectQueue = math.random(0,2)
						--print("skluntt " .. corpseSelectQueue)
						--Small
						if corpseSelectQueue == 0 then
							if maxHealthCorpseQueue - corpseIterand > 5 then
								local smallCorpse = Isaac.Spawn(pickups.ENEMY_CORPSE_SMALL.TYPE, pickups.ENEMY_CORPSE_SMALL.VARIANT, pickups.ENEMY_CORPSE_SMALL.SUBTYPE, npc.Position,Vector((0.1*math.random(-40,40)),(0.1*math.random(-40,40))),npc)
								--print("small")
								corpseIterand = corpseIterand + 5
							end
						end
						if corpseSelectQueue == 1 then
							if maxHealthCorpseQueue - corpseIterand > 25 then
								local medCorpse = Isaac.Spawn(pickups.ENEMY_CORPSE_MEDIUM.TYPE, pickups.ENEMY_CORPSE_MEDIUM.VARIANT, pickups.ENEMY_CORPSE_MEDIUM.SUBTYPE, npc.Position,Vector((0.1*math.random(-40,40)),(0.1*math.random(-40,40))),npc)
								--print("med")
								corpseIterand = corpseIterand + 25
							end
						end
						if corpseSelectQueue == 2 then
							if maxHealthCorpseQueue - corpseIterand > 100 then
								local largeCorpse = Isaac.Spawn(pickups.ENEMY_CORPSE_LARGE.TYPE, pickups.ENEMY_CORPSE_LARGE.VARIANT, pickups.ENEMY_CORPSE_LARGE.SUBTYPE, npc.Position,Vector((0.1*math.random(-40,40)),(0.1*math.random(-40,40))),npc)
								--print("large")
								corpseIterand = corpseIterand + 100
							end
						end
						--print(corpseIterand)
					until corpseIterand >= corpseSelectQueue
				end
				
			end
		end
		--Check if anyone has the item
		
	end

	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, THE_HUNGER.NPCDeathCheck)


	function THE_HUNGER:adjustCorpse(corpse,npc)
		--Place code to adjust corpse attributes here. Takes corpse entity and the npc that it came from.
	end

--Meats are technically NPCs

function THE_HUNGER:meatUpdate(npc)

    if npc.Type == pickups.ENEMY_CORPSE_SMALL.TYPE and npc.Variant == pickups.ENEMY_CORPSE_SMALL.VARIANT then 
		--print("schlong")

		local sprite = npc:GetSprite()
		local player = npc:GetPlayerTarget()
		local data = npc:GetData()

		if data.animInitialized == nil then
			if npc.SubType == 0 or npc.SubType == nil then
				--Small corpse
				sprite:Play("Small")
			elseif npc.SubType == 1 then
				--Medium corpse
				sprite:Play("Medium")
			elseif npc.SubType == 2 then
				--Big corpse
				sprite:Play("Large")
			else
				--Failsafe
				sprite:Play("Small")
				npc.Color = Color(1,1,1)
			end
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			data.animInitialized = true
		end
		
	end

end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, THE_HUNGER.meatUpdate, Isaac.GetEntityTypeByName("Enemy Corpse (Small)"))
--[[
THE_HUNGER.enemyTable = {}
function THE_HUNGER:populateHungerEnemyTable()

end
--]]





--Egocentrism moment

