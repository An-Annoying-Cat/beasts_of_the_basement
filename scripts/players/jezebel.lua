local Mod = BotB
local Jezebel = {}

local PLAYER_JEZEBEL = Isaac.GetPlayerTypeByName("Jezebel")
BotB.JEZ_EXTRA = Isaac.GetCostumeIdByPath("gfx/characters/character_jez_extra.anm2")
function Jezebel:playerGetCostume(player)
    --print("weebis")
    if player:GetPlayerType() == PLAYER_JEZEBEL then
        --print("whongus")
        player:AddNullCostume(BotB.JEZ_EXTRA)
		player:SetPocketActiveItem(BotB.Enums.Items.THE_HUNGER, ActiveSlot.SLOT_POCKET, false)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Jezebel.playerGetCostume, 0)

local myPlayerID = Isaac.GetPlayerTypeByName("Jezebel")
EID:addBirthright(myPlayerID, "Overheal stat bonus takes twice as long to completely deplete. #In cleared rooms, the rate of depletion is halved once more, totaling at a quarter of the normal drain speed.")

function Jezebel:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
    if player:GetPlayerType() == PLAYER_JEZEBEL then
        if data.jezOverhealTimer == nil then
			data.jezOverhealTimer = 0
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezBloodColor = Color(1,0,0)
			data.jezBloodDamage = player.Damage/2
			data.jezDoBlood = false
			--]]

		end
		--JOKES ON YOU THE BLOOD 
		if data.jezOverhealTimer ~= 0 then
			if player:HasCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM) == false then
				if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
					if level:GetCurrentRoomDesc().Clear then
						--Honestly it just flat out shouldn't drain
					else
						if player.FrameCount % 16 == 0 then
							data.jezOverhealTimer = data.jezOverhealTimer - 1
						end
					end
				else
					if level:GetCurrentRoomDesc().Clear then
						if player.FrameCount % 16 == 0 then
							data.jezOverhealTimer = data.jezOverhealTimer - 1
						end
					else
						if player.FrameCount % 8 == 0 then
							data.jezOverhealTimer = data.jezOverhealTimer - 1
						end
					end
				end
			end
			--print("overheal: " .. data.jezOverhealTimer)
			--print("cache your shit dawg")
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK )
			player:EvaluateItems()
			--[[
			if player.FrameCount % 4 == 0 then
				local jezCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT,data.jezBloodVariant,0,player.Position,Vector(0,0),player)
				if data.jezBloodColor ~= nil then
					jezCreep.Color = data.jezBloodColor
				else
					jezCreep.Color:Reset()
				end
				jezCreep.CollisionDamage = player.Damage/2
				--[[
				if data.jezBloodVariant == EffectVariant.PLAYER_CREEP_WHITE then
					jezCreep.IsFollowing = true
				else
					jezCreep.IsFollowing = false
				end
				--]]
			--]]
		end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Jezebel.playerUpdate, 0)





function Jezebel:nullHearts(pickup,player,_)
	local playerCast = player:ToPlayer()
	local data = player:GetData()
	if player.Type == EntityType.ENTITY_PLAYER and playerCast:GetPlayerType() == PLAYER_JEZEBEL then
        --print("whongus")
        Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_EXPLOSION,0,pickup.Position,Vector(0,0),player)
		Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_SPLAT,0,pickup.Position,Vector(0,0),player)
		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,0.75)
		sfx:Play(SoundEffect.SOUND_VAMP_GULP,0.125,0,false,1.5)
		local heartType = pickup.SubType
		--local heartQueueValue
		--240 is the base amount of blood time that a heart gives.

		--Full heart
		if heartType == 1 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezOverhealTimer = data.jezOverhealTimer + 240
			data.jezBloodColor = Color(1,0,0)
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,2,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true
		end
		--Half
		if heartType == 2 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezOverhealTimer = data.jezOverhealTimer + 120
			data.jezBloodColor = Color(1,0,0)
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,1,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 1,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true

		end
		--Soul
		if heartType == 3 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL
			data.jezOverhealTimer = data.jezOverhealTimer + 120
			data.jezBloodColor = nil
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,2,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true
		end
		--Eternal
		if heartType == 3 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL
			data.jezOverhealTimer = data.jezOverhealTimer + 120
			data.jezBloodColor = Color(1,1,1)
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,2,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true
		end
		--Double
		if heartType == 5 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezOverhealTimer = data.jezOverhealTimer + 480
			data.jezBloodColor = Color(1,0,0)
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,4,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 4,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true
		end
		--Black
		if heartType == 6 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_BLACKPOWDER
			data.jezOverhealTimer = data.jezOverhealTimer + 240
			data.jezBloodColor = nil
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,2,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true
		end
		--Gold
		if heartType == 6 then
			return nil
		end
		--HSoul
		if heartType == 7 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezOverhealTimer = data.jezOverhealTimer + 120
			data.jezBloodColor = Color(1,0,0)
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,1,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 1,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true

		end
		--Scared
		if heartType == 8 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezOverhealTimer = data.jezOverhealTimer + 240
			data.jezBloodColor = Color(1,0,0)
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,2,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true
		end
		--Blended
		if heartType == 9 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezOverhealTimer = data.jezOverhealTimer + 240
			data.jezBloodColor = Color(1,0,0)
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,2,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true
		end
		--Bone
		if heartType == 10 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezOverhealTimer = data.jezOverhealTimer + 240
			data.jezBloodColor = Color(1,0,0)
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,2,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true
		end
		--Rotten
		if heartType == 11 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezOverhealTimer = data.jezOverhealTimer + 240
			data.jezBloodColor = Color(1,0,0)
			--]]
			TSIL.Charge.AddCharge(playerCast,ActiveSlot.SLOT_POCKET,2,true)
			--playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)
			pickup:Remove()
			return true
		end
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Jezebel.nullHearts, PickupVariant.PICKUP_HEART)


--Jezebel-specific overheal mechanic

local jezOverhealBonus={
	TEAR=0.2,
	SPEED=0.05,
	LUCK=0.5,
	RANGE=5,
	DAMAGE=1
}

--Stats
--240 is baseline amt of decay frames for stat boost
function Jezebel:onJezCache(player, cacheFlag)
	if player:GetPlayerType() == PLAYER_JEZEBEL then
		local data = player:GetData()
		if data.jezOverhealTimer ~= 0 then
			local Multiplier = data.jezOverhealTimer / 240
			if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
			  player.Damage=player.Damage+Multiplier*jezOverhealBonus.DAMAGE
			end
			if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
			  local tps=30.0/(player.MaxFireDelay+1.0)
			  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*jezOverhealBonus.TEAR))-1
			end
			if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
			  player.TearRange=player.TearRange+Multiplier*jezOverhealBonus.RANGE
			end
			if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
			  player.MoveSpeed=player.MoveSpeed+Multiplier*jezOverhealBonus.SPEED
			end
			if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
			  player.Luck=player.Luck+Multiplier*jezOverhealBonus.LUCK
			end
		elseif data.jezOverhealTimer == 0 or data.jezOverhealTimer == nil then
			return
		end
    end
	
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Jezebel.onJezCache)