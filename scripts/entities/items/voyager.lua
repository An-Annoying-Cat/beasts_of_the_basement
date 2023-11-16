local Mod = BotB
local VOYAGER = {}
local Items = BotB.Enums.Items

local SoulBonus={
	TEAR=0.025,
	SPEED=0.01,
	LUCK=0.05,
	RANGE=1,
	DAMAGE=0.05
}

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

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Voyager"), "Gain a minor but stacking all stats up every time you visit a room for the first time!")
end
--Egocentrism moment

--Stats
function VOYAGER:onCache(player, cacheFlag)
	local data = player:GetData()
	if not player:HasCollectible(Items.VOYAGER) then return end
	local Multiplier = (player:GetCollectibleNum(Items.VOYAGER, false))*data.voyagerEffectStacks
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
	  player.Damage=player.Damage+Multiplier*SoulBonus.DAMAGE
	end
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
	  local tps=30.0/(player.MaxFireDelay+1.0)
	  player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*SoulBonus.TEAR))-1
	end
	if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
	  player.TearRange=player.TearRange+Multiplier*SoulBonus.RANGE
	end
	if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
	  player.MoveSpeed=player.MoveSpeed+Multiplier*SoulBonus.SPEED
	end
	if (cacheFlag&CacheFlag.CACHE_LUCK)==CacheFlag.CACHE_LUCK then
	  player.Luck=player.Luck+Multiplier*SoulBonus.LUCK
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, VOYAGER.onCache)


function VOYAGER:incrementVoyagerStacks()
    local room = Game():GetRoom()
    local game = Game()
     local level = game:GetLevel()
     local roomDescriptor = level:GetCurrentRoomDesc()
     local roomConfigRoom = roomDescriptor.Data
    if not roomDescriptor.VisitedCount == 1 then return end
    local players = getPlayers()
	if roomDescriptor.VisitedCount == 1 then 
	
		local players = BotB.Functions:GetPlayers()
	local doTheyActuallyHaveThem = false
	for i=1,#players,1 do
		if players[i]:HasCollectible(BotB.Enums.Items.VOYAGER) then
			players[i]:GetData().voyagerEffectStacks = players[i]:GetData().voyagerEffectStacks + 1
			--players[i]:GetData().champsMaskCurrent = players[i]:GetData().champsMaskCurrent + 5
		end
	end	
	
	end
	
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, VOYAGER.incrementVoyagerStacks, 0)



function VOYAGER:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
    if data.voyagerEffectStacks == nil then
		data.voyagerEffectStacks = 0
		--[[
		data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
		data.jezBloodColor = Color(1,0,0)
		data.jezBloodDamage = player.Damage/2
		data.jezDoBlood = false
		--]]

	end
	--JOKES ON YOU THE BLOOD 
	if data.voyagerEffectStacks ~= 0 then
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
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, VOYAGER.playerUpdate, 0)
