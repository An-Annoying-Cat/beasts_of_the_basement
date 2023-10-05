local Mod = BotB
local SPOILED_MILK = {}
local Items = BotB.Enums.Items

local SpoiledMilkStats={
	TEAR=3,
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
	EID:addCollectible(Isaac.GetItemIdByName("Spoiled Milk"), "x0.33 fire rate. #Tears are fired in a chaotic shotgun spread, with varying damage values.#The exact amount varies, but the higher your damage stat, the more tears you fire.")
end
--Egocentrism moment

--Stats
function SPOILED_MILK:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.SPOILED_MILK) then return end
	local Multiplier = player:GetCollectibleNum(Items.SPOILED_MILK, false)
	if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
		player.MaxFireDelay = player.MaxFireDelay * ((SpoiledMilkStats.TEAR*Multiplier))
	end
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
		player.Damage=player.Damage*(Multiplier*SpoiledMilkStats.DAMAGE)
	  end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, SPOILED_MILK.onCache)

--Shotgun of tears



function SPOILED_MILK:onTear(tear)
	
	if not tear.Parent:ToPlayer():HasCollectible(Items.SPOILED_MILK) then  return end
	print('milk')
	--tear:GetData().isSpoiledMilkOriginator = true
	--
	local data = tear:GetData()
	if data.isSpoiledMilkOriginator == nil and data.spoiledMilkImmunity ~= true then
		data.isSpoiledMilkOriginator = true
		data.inheritedTearFlags = tear.TearFlags
		--tear.TearFlags = TearFlags.TEAR_NORMAL
		tear.Color = Color(2,2,1,1)
		tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		data.inheritedData = {}
		for key, value in pairs(tear:GetData()) do
			if key ~= "isSpoiledMilkOriginator" and value ~= nil then
				tear:GetData().inheritedData[key] = value
			end
		end

		SFXManager():Stop(SoundEffect.SOUND_TEARS_FIRE)
	end
	
	--[[
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


	end]]
	
	--tear.Parent:ToPlayer():GetData().isSpawningSpoiledMilkTears = false
	--tear:ToTear():Remove()
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, SPOILED_MILK.onTear)
--[[
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
]]


function SPOILED_MILK:onUpdTear(tear)
	
	if tear.Parent == nil then return end
	if tear.Parent:ToPlayer() == nil then return end
	if not tear.Parent:ToPlayer():HasCollectible(Items.SPOILED_MILK) then  return end
	if not tear:GetData().isSpoiledMilkOriginator == true then return end

	if tear:GetData().isSpoiledMilkOriginator == true then
		local player = tear.Parent:ToPlayer()
		local Multiplier = player:GetCollectibleNum(Items.SPOILED_MILK, false)
		local shotgunAmt = 5 * Multiplier
		if tear.FrameCount == 1 then
			print("go")
			--
			for i=1, shotgunAmt do
				local spoiledMilkShotgunTear = Isaac.Spawn(2,0,0,tear.Position,tear.Velocity:Rotated(math.random(-56,56)/10):Resized(tear.Velocity:Length()*(math.random(600,1400)/1000)),player):ToTear()
				spoiledMilkShotgunTear:GetData().isSpoiledMilkOriginator = false
				spoiledMilkShotgunTear:GetData().spoiledMilkImmunity = true
				spoiledMilkShotgunTear:ChangeVariant(tear.Variant)
				local spoiledMilkCoeff = (math.random(25,125)/100)
				spoiledMilkShotgunTear.CollisionDamage = tear.CollisionDamage * spoiledMilkCoeff
				spoiledMilkShotgunTear.Scale = tear.Scale * spoiledMilkCoeff
				spoiledMilkShotgunTear.TearFlags = tear:GetData().inheritedTearFlags
				spoiledMilkShotgunTear.Parent = tear.Parent
				for key, value in pairs(tear:GetData().inheritedData) do
					--print(key, value)
					spoiledMilkShotgunTear:GetData()[key] = value
				end
			end
			

				tear:Remove()
		end
	end

	--[[
	if tear:GetData().isFlippedNoteBaseTear == true then
		local player = tear.Parent:ToPlayer()
		if tear.FrameCount == 1 then
			--print("do it")
			local flippedNoteFollowerTear = Isaac.Spawn(2,0,0,tear.Position,Vector.Zero,player):ToTear()
			
			flippedNoteFollowerTear:GetData().flippedNoteFollowerTarget = tear
			flippedNoteFollowerTear:ChangeVariant(tear.Variant)
			flippedNoteFollowerTear.CollisionDamage = tear.CollisionDamage
			flippedNoteFollowerTear.Scale = tear.Scale
			flippedNoteFollowerTear.TearFlags = tear:GetData().inheritedTearFlags | TearFlags.TEAR_PIERCING
			flippedNoteFollowerTear:GetData().dontSetMeAsAFlippedNoteTear = true
			flippedNoteFollowerTear.Parent = tear.Parent

			for key, value in pairs(tear:GetData()) do
				flippedNoteFollowerTear:GetData()[key] = value
			end
			flippedNoteFollowerTear:GetData().isFlippedNoteBaseTear = false
			tear.Visible = false
		end
	end
	
	if tear:GetData().dontSetMeAsAFlippedNoteTear == true then
		if tear:GetData().flippedNoteFollowerTarget == nil then
			tear:Remove()
		end
		if tear:GetData().flippedNoteFollowerTarget:IsDead() then
			tear:Remove()
		end
		if tear.FrameCount % 4 == 0 and tear:GetData().flippedNoteFollowerTarget ~= nil then
			local roomEntities = Isaac.GetRoomEntities() -- table
			for i = 1, #roomEntities do
				local entity = roomEntities[i]
				if (entity.Position - tear.Position):Length() <= 40*tear.Scale then
					if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
						entity:TakeDamage(tear.CollisionDamage, 0, EntityRef(tear), 0)
					end
				end
			end

			tear.Position = tear:GetData().flippedNoteFollowerTarget.Position
			--Game():BombDamage(tear.Position, tear.CollisionDamage, 40*tear.Scale, false, tear.Parent:ToPlayer(), tear.TearFlags, DamageFlag.DAMAGE_EXPLOSION - 4, false)
			
			for i = 1, #roomEntities do
				local entity = roomEntities[i]
				if (entity.Position - tear.Position):Length() <= 40*tear.Scale then
					if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
						entity:TakeDamage(tear.CollisionDamage, 0, EntityRef(tear), 0)
					end
				end
			end
		end
	end]]

	--print("lmao flipnote")

	--tear:ToTear():Remove()
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, SPOILED_MILK.onUpdTear)