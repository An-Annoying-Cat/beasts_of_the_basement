local Mod = BotB
local CHAMPS_MASK = {}
local Items = BotB.Enums.Items

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Champ's Mask"), "Grants a stacking minor boost to all stats each time an enemy is killed. #{{Warning}} Getting hurt resets this boost to nothing, and it will slowly grow back to maximum over time!")
end





--Timer shit
function CHAMPS_MASK:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
    if data.champsMaskStacks == nil then
		data.champsMaskStacks = 0
		data.champsMaskCurrent = data.champsMaskStacks
	end
	--Grows over time back to height
	if data.champsMaskCurrent < data.champsMaskStacks then
		if player.FrameCount % 8 == 0 then
			data.champsMaskCurrent = data.champsMaskCurrent + 1
			player:AddCacheFlags(CacheFlag.CACHE_ALL)
			player:EvaluateItems()
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CHAMPS_MASK.playerUpdate, 0)

--Stats per stack
local ChampsMaskBonus={
	TEAR=0.005,
	SPEED=0.005,
	LUCK=0.025,
	RANGE=0.5,
	DAMAGE=0.025
}

--Stats
--Stats
function CHAMPS_MASK:onCache(player, cacheFlag)
	--print(player:GetData().champsMaskCurrent .. " out of " .. player:GetData().champsMaskStacks)
	if not player:HasCollectible(Items.CHAMPS_MASK) then return end
	local Multiplier = player:GetData().champsMaskCurrent
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
	  player.Damage=player.Damage+Multiplier*ChampsMaskBonus.DAMAGE
	end
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
	  local tps=30.0/(player.MaxFireDelay+1.0)
	  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*ChampsMaskBonus.TEAR))-1
	end
	if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
	  player.TearRange=player.TearRange+Multiplier*ChampsMaskBonus.RANGE
	end
	if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
	  player.MoveSpeed=player.MoveSpeed+Multiplier*ChampsMaskBonus.SPEED
	end
	if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
	  player.Luck=player.Luck+Multiplier*ChampsMaskBonus.LUCK
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CHAMPS_MASK.onCache)

--Increment stacks when an enemy is killed

function CHAMPS_MASK:NPCDeathCheck(entity,amount)
	--print("hurmt")
	local npc = entity:ToNPC()
	if amount >= entity.HitPoints and entity:IsVulnerableEnemy() then
		--print("khill")
		if entity.MaxHitPoints ~= 0 then
			local players = BotB.Functions:GetPlayers()
			local doTheyActuallyHaveThem = false
			for i=1,#players,1 do
				if players[i]:HasCollectible(BotB.Enums.Items.CHAMPS_MASK) then
					players[i]:GetData().champsMaskStacks = players[i]:GetData().champsMaskStacks + 5
					--players[i]:GetData().champsMaskCurrent = players[i]:GetData().champsMaskCurrent + 5
				end
			end
		end
	end
	--Check if anyone has the item
	
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CHAMPS_MASK.NPCDeathCheck)


--Reset current to zero when player is hurt

function CHAMPS_MASK:champsMaskHurt()
	--print("cocks")
	local player = Isaac.GetPlayer()
	local data = player:GetData()
		if player:HasCollectible(Isaac.GetItemIdByName("Champ's Mask")) then
			if data.champsMaskCurrent ~= nil then
				data.champsMaskCurrent = 0
			end
		end
	end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CHAMPS_MASK.champsMaskHurt, EntityType.ENTITY_PLAYER)