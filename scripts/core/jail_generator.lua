local mod = BotB

function mod:MakeDoorJail(door)
	local doorSprite = door:GetSprite()
	local iscustomstage
	
	if StageAPI then
		iscustomstage = StageAPI.InOverriddenStage()
	end
	
	--if not iscustomstage then
		doorSprite:Load("gfx/grid/taintedtreasureroomdoor.anm2", true)
		doorSprite:ReplaceSpritesheet(0, "gfx/grid/taintedtreasureroomdoor.png")
	--end
	doorSprite:LoadGraphics()
	doorSprite:Play("Closed")
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, iscontinued)
	if not iscontinued then
		local taintedbeggarQ4chance = 1
		local itemconfig = Isaac:GetItemConfig()

	if iscontinued and not BasementRenovator and not mod.roomdata and not mod.luarooms then
		mod:scheduleForUpdate(function()
			mod.roomdata = {}
			mod:InitializeRoomData("dice", 12000, mod.maxvariant, mod.roomdata)
		end, 0, ModCallbacks.MC_POST_RENDER)
	end
	
	

	rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
end)

function mod:OnNewLevel()
	local level = game:GetLevel()
	mod.savedata.spawnchancemultiplier = mod.savedata.spawnchancemultiplier or 1
	mod.savedata.TaintedLuarooms = {}
	mod.DoneFullMapping = 0
	mod.SecretRoomIndex = level:QueryRoomTypeIndex(RoomType.ROOM_SECRET, false, rng)
	mod.TreasureRoomIndex = level:QueryRoomTypeIndex(RoomType.ROOM_TREASURE, false, rng)
	mod.BossRoomIndex = level:QueryRoomTypeIndex(RoomType.ROOM_BOSS, false, rng)
	mod.SecretRoomVisited = false
	mod.TreasureRoomVisited = false
	mod.BossRoomVisited = false
	altPathItemChecked = {}
	
	
	
	--Handles Tainted Room spawning
	if not mod.roomdata and level:GetStage() ~= LevelStage.STAGE1_1 and not BasementRenovator and (not StageAPI or not StageAPI.InOverriddenStage()) and not mod.luarooms then
		mod.roomdata = {}
		mod:InitializeRoomData("dice", 12000, mod.maxvariant, mod.roomdata)
	end
	
	local spawnchance = 0.5
	--[[
	local stagelimit = mod:GetTaintedTreasureRoomThreshold()
	if level:GetStage() ~= LevelStage.STAGE1_1 and level:GetStage() < stagelimit and not level:IsAscent() and Isaac.GetChallenge() == 0 and (not StageAPI or not StageAPI.InOverriddenStage()) then
		for _, player in pairs(mod:GetAllPlayers()) do
			for j, entry in pairs(mod.savedata.taintedsets) do
				if player:HasCollectible(entry[1], true) and not mod:GetConditionValue(entry[3]) then
					spawnchance = spawnchance + (0.2 * (1 + mod:GetTotalTrinketMult(TaintedTrinkets.PURPLE_STAR)))
				end
			end
		end
	end
	]]

	local totalchance = mod.savedata.spawnchancemultiplier*spawnchance
	local newchance = Isaac.RunCallback("POST_JAIL_CHANCE", totalchance)
	totalchance = newchance or totalchance

	--print(totalchance)
	if totalchance > 0 then
		if rng:RandomFloat() <= totalchance then
			if not game:IsGreedMode() then
				if not mod.luarooms then
					local newroomdesc = mod:GenerateRoomFromDataset(mod.roomdata, true)
				else
					local newroomdesc = mod:GenerateRoomFromLuarooms(mod.luarooms.TT, true)
					if newroomdesc then
						mod.savedata.TaintedLuarooms = mod.savedata.TaintedLuarooms or {}
						mod.savedata.TaintedLuarooms[newroomdesc.GridIndex] = true
					end
				end
			else
				local treasureroomidx = mod:GetRandomElem({98, 85}) --Silver, gold
				local currentroomidx = level:GetCurrentRoomIndex()
				if level:GetRoomByIdx(99).GridIndex == -1 and level:GetRoomByIdx(86).GridIndex == -1 then
					for i, player in pairs(mod:GetAllPlayers()) do
						player:GetData().ResetPosition = player.Position
					end
					Isaac.ExecuteCommand("goto s.dice."..mod:RandomInt(12000, mod.maxvariant))
					local data = level:GetRoomByIdx(-3,0).Data
					game:StartRoomTransition(currentroomidx, 0, RoomTransitionAnim.FADE)
					local levelstage = level:GetStage()
					local stagetype = level:GetStageType()
					level:SetStage(7, 0)
					if level:MakeRedRoomDoor(treasureroomidx, DoorSlot.RIGHT0) then
						local newroomdesc = level:GetRoomByIdx(treasureroomidx+1,0)
						newroomdesc.Data = data
						newroomdesc.Flags = 0
						table.insert(mod.minimaprooms, newroomdesc.GridIndex)
					end
					level:SetStage(levelstage, stagetype)
					mod:scheduleForUpdate(function()
						for i, player in pairs(mod:GetAllPlayers()) do
							player.Position = player:GetData().ResetPosition
						end
					end, 0)
					mod.savedata.spawnchancemultiplier = 0.5
				end
			end
		elseif mod.savedata.spawnchancemultiplier < 3 then
			mod.savedata.spawnchancemultiplier = mod.savedata.spawnchancemultiplier + 0.5
		end
	end

end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewLevel)