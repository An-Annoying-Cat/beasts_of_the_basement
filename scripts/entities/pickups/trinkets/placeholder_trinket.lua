local Mod = BotB
local PLACEHOLDER_TRINKET = {}
local Trinkets = BotB.Enums.Trinkets

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("Trinket"), "This trinket is automatically gulped on pickup. #All trinkets collected afterwards are automatically gulped. #{{Warning}} All spawned trinkets post-gulping {{Trinket".. Trinkets.PLACEHOLDER_TRINKET .."}} Trinket have a 25% chance to be replaced with this trinket! #{{Warning}} Unlike {{Collectible".. BotB.Enums.Items.PLACEHOLDER_ITEM .."}} Item, this chance does not increase the more copies you possess.")
end

local function getPlayers()
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
  
	return players
end

function PLACEHOLDER_TRINKET:onUpdate()	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
			--Check if player has the placeholder trinket
			--print("gooch")
			if player:HasTrinket(Trinkets.PLACEHOLDER_TRINKET) then
				--print("bussy")
				local trinket1 = player:GetTrinket(0)
				local trinket2 = player:GetTrinket(1)
				
				local trinket1valid = false
				local trinket2valid = false
				
				if trinket1 ~= 0 then
					trinket1valid = true
				end
				if trinket2 ~= 0 then
					trinket2valid = true
				end
				--[[			IMPLEMENT THIS LATER
				if player:GetTrinketMultiplier(Trinkets.PLACEHOLDER_TRINKET) > 1 then
				--If the placeholder trinket is golden or if the player has Mom's Box, then gild the trinkets upon being gulped
					if trinket1valid == true then
						player:TryRemoveTrinket(trinket1)
						player:AddTrinket(trinket1 + 32768)
						if trinket2valid == true or trinket2 == 0 then
							player:TryRemoveTrinket(trinket2)
							player:AddTrinket(trinket2 + 32768)
							player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
						else
							player:TryRemoveTrinket(trinket2)
							player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
							player:AddTrinket(trinket2)
						end
						SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
					elseif trinket2valid == true then
						player:TryRemoveTrinket(trinket1)
						player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
						player:AddTrinket(trinket1)
						SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
					end

				else
					if trinket1valid == true then
						if trinket2valid == true or trinket2 == 0 then
							player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
						else
							player:TryRemoveTrinket(trinket2)
							player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
							player:AddTrinket(trinket2)
						end
						SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
					elseif trinket2valid == true then
						player:TryRemoveTrinket(trinket1)
						player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
						player:AddTrinket(trinket1)
						SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
					end
				end
				--]]
				if trinket1valid == true then
					if trinket2valid == true or trinket2 == 0 then
						player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
					else
						player:TryRemoveTrinket(trinket2)
						player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
						player:AddTrinket(trinket2)
					end
					SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
				elseif trinket2valid == true then
					player:TryRemoveTrinket(trinket1)
					player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
					player:AddTrinket(trinket1)
					SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
				end
			else
				--If they don't have it, initiate the gulp only if the trinket they hold is Trinket
				--print("sklench")
				local trinket1 = player:GetTrinket(0)
				local trinket2 = player:GetTrinket(1)
				
				local trinket1valid = false
				local trinket2valid = false
				
				if trinket1 == Trinkets.PLACEHOLDER_TRINKET then
					trinket1valid = true
				end
				if trinket2 == Trinkets.PLACEHOLDER_TRINKET then
					trinket2valid = true
				end
				
				if trinket1valid == true then
					if trinket2valid == true or trinket2 == 0 then
						player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
					else
						player:TryRemoveTrinket(trinket2)
						player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
						player:AddTrinket(trinket2)
					end
					SFXManager():Play(SoundEffect.SOUND_THUMBSUP,1,0,false,math.random(800,900)/1000)
				elseif trinket2valid == true then
					player:TryRemoveTrinket(trinket1)
					player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
					player:AddTrinket(trinket1)
					SFXManager():Play(SoundEffect.SOUND_THUMBSUP,1,0,false,math.random(800,900)/1000)
				end
			end
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, PLACEHOLDER_TRINKET.onUpdate)

--Replacement chance
function PLACEHOLDER_TRINKET:replaceTrinket(pickup)
	--local config = Isaac.GetItemConfig()
	--local item = config:GetCollectible(pickup.SubType)
	--local room = game:GetRoom()

	if pickup.SubType ~= 0 and pickup.SubType ~= Trinkets.PLACEHOLDER_TRINKET and pickup.FrameCount == 1 then
		--local numPlaceholders = 0
		local doTheyActuallyHaveThem = false
		local players = getPlayers()
		for i=1,#players,1 do
			if players[i]:HasTrinket(Trinkets.PLACEHOLDER_TRINKET) then
				--numPlaceholders = numPlaceholders + players[i]:GetCollectibleNum(Items.PLACEHOLDER_ITEM, false)
				doTheyActuallyHaveThem = true
			end
		end

		if doTheyActuallyHaveThem == true then
			local chance = math.random(100)
			--print(chance .. "/" .. 80*(0.5^(0.5*(numPlaceholders-1))))
			--print(numPlaceholders)
			if chance >= 75 then
				sfx:Play(SoundEffect.SOUND_EDEN_GLITCH,0.5,0,false,math.random(20, 40)/100)
				sfx:Play(SoundEffect.SOUND_DOGMA_BLACKHOLE_OPEN,0.5,0,false,math.random(60, 80)/100)
				for i=0,15,1 do
					local rubble = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DOGMA_DEBRIS,0,pickup.Position,Vector((0.1*math.random(-10,10)),(0.1*math.random(-10,10))),pickup)
				end
				pickup:Morph(5, 350, Trinkets.PLACEHOLDER_TRINKET, true)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, PLACEHOLDER_TRINKET.replaceTrinket, 350)
