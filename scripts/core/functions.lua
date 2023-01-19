local Functions = {}

local Mod = BotB
local game = Mod.Game
local ffmod = FiendFolio

Functions.RNG = include("scripts.core.rngman")
Functions.Tables = include("scripts.core.table_functions")
Mod.Scheduler = include("scripts.core.schedule_data")

--- LINEAR INTERPOLATION
function Functions:Lerp(first,second,percent)
	return (first + (second - first)*percent)
end
---- GET PLAYERS
function Functions:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end
--- GET PLAYERS WITH ITEM
function Functions:GetPlayersWithItem(collectible)
	local playersWithItem = {}

	for i = 1, game:GetNumPlayers() do
		if game:GetPlayer(i):HasCollectible(collectible) then
			table.insert(playersWithItem, game:GetPlayer(i))
		end
	end

	return playersWithItem
end
--- GET FIRST PLAYER WITH ITEM
function Functions:GetFirstPlayerWithCollectible(collectible)
	local selectedPlayer

	for _, v in pairs(Functions:GetPlayers()) do
		selectedPlayer = selectedPlayer or v:HasCollectible(collectible) and v:ToPlayer()
	end

	return selectedPlayer
end

Functions.item_exists = Functions.GetFirstPlayerWithCollectible

--- GET FIRST PLAYER WITH TRINKET 
function Functions:GetFirstPlayerWithTrinket(trinket)
	local selectedPlayer 

	for _, v in pairs(Functions:GetPlayers()) do
		selectedPlayer = selectedPlayer or v:HasTrinket(trinket) and v:ToPlayer()
	end

	return selectedPlayer
end

function Functions.GetExpectedFamiliarNum(player, item)
	return player:GetCollectibleNum(item) + player:GetEffects():GetCollectibleEffectNum(item)
end

function Functions:CreateEnemiesCache()
	BotBRoomEntitiesCache = Isaac.GetRoomEntities()
	return BotBRoomEntitiesCache
end

function Functions:GetClosestEnemy(pos, excludeFiresAndTNT)
	local ents = BotBRoomEntitiesCache or Functions:CreateEnemiesCache()

	local closest
	local dist = 99999

	for _, ent in pairs(ents) do
		if ent:IsEnemy() and not (ent:HasEntityFlags(EntityFlag.FLAG_PERSISTENT) or ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
			if not excludeFiresAndTNT or (ent.Type ~= 33 and ent.Type ~= 292) then
				local d = pos:Distance(ent.Position)

				if d < dist then
					closest = ent
					dist = d
				end
			end
		end
	end

	return closest
end

function Functions:GetEntityNameString(entity)
	local e = entity:ToNPC()
	if e.Type > 9 and e.Type < 1000 and e.FrameCount >= 1 then
		local data = e:GetData()
		if not data.BotBNameTag then
			local config = StageAPI.GetEntityConfig(e.Type, e.Variant, e.SubType)
			if config and config.Name then
				local name = config.Name
				if string.sub(name, 1, 1) == "#" then
					name = string.sub(name, 2, -1)
					name = string.gsub(name, "_", " ")
					name = string.lower(name)
					name = string.gsub(" "..name, "%W%l", string.upper):sub(2)
				end

				data.BotBNameTag = name
				return data.BotBNameTag
			else
				data.BotBNameTag = "Bruh"
			end
		elseif data.BotBNameTag ~= "Bruh" then
			if e.Visible and e.Color.A ~= 0 then
				local str = data.BotBNameTag

				if str == "Inch Worm" or str == "Chode" and data.IsUnder ~= true then str = nil end

				return str
			end
		end
	end
end


function Functions:ClampToCardinal(vec1, vec2)

	if math.abs(vec1.X - vec2.X) < math.abs(vec1.Y - vec2.Y) then
		if vec1.X - vec2.X < 0 then
			
			-- Left
			return Vector(0, -vec1.Y)
		else
			-- Right
			return Vector(0, vec1.Y)
		end
	else
		if vec1.Y - vec2.Y < 0 then
			-- Up
			return Vector(vec1.X, 0)
		else
			-- Down
			return -Vector(vec1.X, 0)
		end
	end
end

--yoink



function Functions.MakeTrinketGolden(trinket)
	if ffmod.AchievementTrackers.GoldenTrinketsUnlocked then
		if trinket > TrinketType.TRINKET_GOLDEN_FLAG then
			return trinket
		end
		return trinket + TrinketType.TRINKET_GOLDEN_FLAG
	else
		return trinket
	end
end

function Functions.TryMakeTrinketGolden(trinket)
	local checkingForGolden = false
	if ffmod.AchievementTrackers.GoldenTrinketsUnlocked then
		if trinket > TrinketType.TRINKET_GOLDEN_FLAG then
			return trinket
		end
		
		checkingForGolden = true
		local potentialGoldenTrinket = Game():GetItemPool():GetTrinket()
		checkingForGolden = false

		if potentialGoldenTrinket > TrinketType.TRINKET_GOLDEN_FLAG then
			return trinket + TrinketType.TRINKET_GOLDEN_FLAG
		end
		
		return trinket
	else
		return trinket
	end
end

-- Extra item callbacks
local TrackedItems = {
	Players = {},
	Callbacks = {
		Collect = {},
		Trinket = {}
	}
}

function Mod.AddItemPickupCallback(onAdd, onRemove, item, forceAddOnRepickup)
	local entry = TrackedItems.Callbacks.Collect[item]
	local listing = { Add = onAdd, Remove = onRemove, ForceAddOnRepickup = forceAddOnRepickup }
	if not entry then
		TrackedItems.Callbacks.Collect[item] = { listing }
	else
		table.insert(entry, listing)
	end
end

function Mod.AddTrinketPickupCallback(onAdd, onRemove, item, onGulp)
	local entry = TrackedItems.Callbacks.Trinket[item]
	local listing = { Add = onAdd, Remove = onRemove, Gulp = onGulp }
	if not entry then
		TrackedItems.Callbacks.Trinket[item] = { listing }
	else
		table.insert(entry, listing)
	end
end

BotB.Functions = Functions