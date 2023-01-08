local Functions = {}

local Mod = BotB
local game = Mod.Game

Functions.RNG = include("scripts.core.rngman")
Functions.Tables = include("scripts.core.table_functions")
Mod.Scheduler = include("scripts.core.schedule_data")
local scheduler = Mod.Scheduler

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

--- LINEAR INTERPOLATION
function Functions:Lerp(first,second,percent)
	return (first + (second - first)*percent)
end

---works for both entities and sprites
---@param entity Entity
---@param red number @default 0
---@param green number @default 0
---@param blue number @default 0
---@param amount number @default 1
---@param fadeout? boolean @default false
---@param duration? integer @default 0
function Functions:Colorize(entity, red, green, blue, amount, fadeout, duration)
	local color = entity.Color
	local initColor = color

	color:SetColorize(red, green, blue, amount)
	entity.Color = color

	if fadeout then
		table.insert(scheduler.FadeoutData, {
			Entity = entity, ---@type Entity
			Modifier = "colorize", ---@type "tint"|"colorize"|"offset"
			InitColor = initColor, ---@type Color
			Duration = duration, ---@type integer
			R = red, ---@type number
			G = green, ---@type number
			B = blue, ---@type number
			A = amount, ---@type number
			Time = 0, ---@type number
		})
		Mod:AddCallback(ModCallbacks.MC_POST_RENDER, scheduler.RenderFadeout)
	end
end

---works for both entities and sprites
---@param entity Entity
---@param red number @default 0
---@param green number @default 0
---@param blue number @default 0
---@param alpha number @default 1
---@param fadeout? boolean @default false
---@param duration? integer @default 0
function Functions:Tint(entity, red, green, blue, alpha, fadeout, duration)
	local color = entity.Color
	local initColor = color

	color:SetTint(red, green, blue, alpha)
	entity.Color = color

	if fadeout then
		table.insert(scheduler.FadeoutData, {
			Entity = entity, ---@type Entity
			Modifier = "tint", ---@type "tint"|"colorize"|"offset"
			InitColor = initColor, ---@type Color
			Duration = duration, ---@type integer
			R = red, ---@type number
			G = green, ---@type number
			B = blue, ---@type number
			A = alpha, ---@type number
			Time = 0, ---@type number
		})
		Mod:AddCallback(ModCallbacks.MC_POST_RENDER, scheduler.RenderFadeout)
	end
end

---works for both entities and sprites
---@param entity Entity
---@param red number @default 0
---@param green number @default 0
---@param blue number @default 0
---@param fadeout? boolean @default false
---@param duration? integer @default 0
function Functions:Offset(entity, red, green, blue, fadeout, duration)
	local color = entity.Color
	local initColor = color

	color:SetOffset(red, green, blue)
	entity.Color = color

	if fadeout then
		table.insert(scheduler.FadeoutData, {
			Entity = entity, ---@type Entity
			Modifier = "offset", ---@type "tint"|"colorize"|"offset"
			InitColor = initColor, ---@type Color
			Duration = duration, ---@type integer
			R = red, ---@type number
			G = green, ---@type number
			B = blue, ---@type number
			A = 0, ---@type number
			Time = 0, ---@type number
		})
		Mod:AddCallback(ModCallbacks.MC_POST_RENDER, scheduler.RenderFadeout)
	end
end

BotB.Functions = Functions