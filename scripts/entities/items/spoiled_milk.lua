local Mod = BotB
local SPOILED_MILK = {}
local Items = BotB.Enums.Items

local SpoiledMilkStats={
	TEAR=0.5,
	DAMAGE=1.1,
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
	EID:addCollectible(Isaac.GetItemIdByName("Spoiled Milk"), "-0.5 fire rate. #Tears are fired in a chaotic shotgun spread, with varying damage values.#The exact amount varies, but the higher your damage stat, the more tears you fire.")
end
--Egocentrism moment

--Stats
function SPOILED_MILK:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.SPOILED_MILK) then return end
	local Multiplier = player:GetCollectibleNum(Items.SPOILED_MILK, false)
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = player.MaxFireDelay * (1/(SpoiledMilkStats.TEAR/Multiplier))
	end
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
		player.Damage=player.Damage*(Multiplier*SpoiledMilkStats.DAMAGE)
	  end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SPOILED_MILK.onCache)

--Shotgun of tears



function SPOILED_MILK:onTear(tear)
	
	if not tear.Parent:ToPlayer():HasCollectible(Items.SPOILED_MILK) then  return end
	
	if tear.Parent:ToPlayer():GetData().isSpawningSpoiledMilkTears ~= true then
		tear.Parent:ToPlayer():GetData().isSpawningSpoiledMilkTears = true
		
	if tear:GetData().spoiledMilkCannotTriggerShotgun then  return end
	if tear.BaseDamage < tear.Parent:ToPlayer().Damage then  return end
	if tear.Parent:ToPlayer().FireDelay ~= tear.Parent:ToPlayer().MaxFireDelay then  return end
	tear.Visible = false
	
	--print(tear.Parent:ToPlayer().FireDelay)
	local baseDamage = tear.BaseDamage
	local player = tear.Parent:ToPlayer()
	local tearParentDamage = tear.Parent:ToPlayer().Damage
	local tearParentDamageMult = math.ceil(tearParentDamage)*100
	local spoiledMilkRando = 0
	--print(tearParentDamageMult)
	--print("------------------")
	for i=0,5,1 do
		--print("FUCK")
		if tearParentDamageMult > 0 then
			--print(tearParentDamageMult)
			if tearParentDamageMult ~= 1 then
				spoiledMilkRando = math.random(1,tearParentDamageMult)
				
			else
				spoiledMilkRando = 1
			end
			--print("...to " .. spoiledMilkRando)
			
			if spoiledMilkRando <= tearParentDamageMult and spoiledMilkRando ~= 0 then
				
				SPOILED_MILK:FireSpoiledMilkTears(player, tear, baseDamage, spoiledMilkRando)
				tearParentDamageMult = tearParentDamageMult - math.ceil(spoiledMilkRando/2)
				
			end
			
		end
	end

	end
	
	tear.Parent:ToPlayer():GetData().isSpawningSpoiledMilkTears = false
	--tear:ToTear():Remove()
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, SPOILED_MILK.onTear)

function SPOILED_MILK:FireSpoiledMilkTears(player, tear, bd, rando)
	--print("SHITBONER")
	if player.FireDelay ~= player.MaxFireDelay or bd ~= player.Damage then return end
	if not(tear.BaseDamage < player.Damage) then
		print(rando)
		local spoiledMilkShotgunTear = player:FireTear(player.Position, tear.Velocity:Rotated(math.random(-50,50)/10):Resized(tear.Velocity:Length()*(math.random(600,1400)/1000)), true, false, false, nil, rando/200):ToTear()
		--print("I do " .. spoiledMilkShotgunTear.CollisionDamage .. " damage")
		spoiledMilkShotgunTear:GetData().spoiledMilkCannotTriggerShotgun = true
	end
end