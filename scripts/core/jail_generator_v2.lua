local mod = BotB

-- ROOM GEN
mod.adjindexes = {
	[RoomShape.ROOMSHAPE_1x1] = {
		[DoorSlot.LEFT0] = -1, 
		[DoorSlot.UP0] = -13, 
		[DoorSlot.RIGHT0] = 1, 
		[DoorSlot.DOWN0] = 13
	},
	[RoomShape.ROOMSHAPE_IH] = {
		[DoorSlot.LEFT0] = -1, 
		[DoorSlot.RIGHT0] = 1
	},
	[RoomShape.ROOMSHAPE_IV] = {
		[DoorSlot.UP0] = -13, 
		[DoorSlot.DOWN0] = 13
	},
	[RoomShape.ROOMSHAPE_1x2] = {
		[DoorSlot.LEFT0] = -1, 
		[DoorSlot.UP0] = -13, 
		[DoorSlot.RIGHT0] = 1, 
		[DoorSlot.DOWN0] = 26,
		[DoorSlot.LEFT1] = 12, 
		[DoorSlot.RIGHT1] = 14
	},
	[RoomShape.ROOMSHAPE_IIV] = {
		[DoorSlot.UP0] = -13, 
		[DoorSlot.DOWN0] = 26
	},
	[RoomShape.ROOMSHAPE_2x1] = {
		[DoorSlot.LEFT0] = -1, 
		[DoorSlot.UP0] = -13, 
		[DoorSlot.RIGHT0] = 2,
		[DoorSlot.DOWN0] = 13,
		[DoorSlot.UP1] = -12,
		[DoorSlot.DOWN1] = 14
	},
	[RoomShape.ROOMSHAPE_IIH] = {
		[DoorSlot.LEFT0] = -1, 
		[DoorSlot.RIGHT0] = 3
	},
	[RoomShape.ROOMSHAPE_2x2] = {
		[DoorSlot.LEFT0] = -1, 
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 2,
		[DoorSlot.DOWN0] = 26,
		[DoorSlot.LEFT1] = 12,
		[DoorSlot.UP1] = -12, 
		[DoorSlot.RIGHT1] = 15, 
		[DoorSlot.DOWN1] = 27
	},
	[RoomShape.ROOMSHAPE_LTL] = {
		[DoorSlot.LEFT0] = -1,
		[DoorSlot.UP0] = -1,
		[DoorSlot.RIGHT0] = 1, 
		[DoorSlot.DOWN0] = 25,
		[DoorSlot.LEFT1] = 11, 
		[DoorSlot.UP1] = -13, 
		[DoorSlot.RIGHT1] = 14, 
		[DoorSlot.DOWN1] = 26
	},
	[RoomShape.ROOMSHAPE_LTR] = {
		[DoorSlot.LEFT0] = -1, 
		[DoorSlot.UP0] = -13, 
		[DoorSlot.RIGHT0] = 1,
		[DoorSlot.DOWN0] = 26,
		[DoorSlot.LEFT1] = 12, 
		[DoorSlot.UP1] = 1,
		[DoorSlot.RIGHT1] = 15, 
		[DoorSlot.DOWN1] = 27
	},
	[RoomShape.ROOMSHAPE_LBL] = {
		[DoorSlot.LEFT0] = -1, 
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 2,
		[DoorSlot.DOWN0] = 13,
		[DoorSlot.LEFT1] = 13,
		[DoorSlot.UP1] = -12, 
		[DoorSlot.RIGHT1] = 15, 
		[DoorSlot.DOWN1] = 27
	},
	[RoomShape.ROOMSHAPE_LBR] = {
		[DoorSlot.LEFT0] = -1, 
		[DoorSlot.UP0] = -13,
		[DoorSlot.RIGHT0] = 2,
		[DoorSlot.DOWN0] = 26,
		[DoorSlot.LEFT1] = 12,
		[DoorSlot.UP1] = -12,
		[DoorSlot.RIGHT1] = 14,
		[DoorSlot.DOWN1] = 14
	}
}

mod.borderrooms = {
	[DoorSlot.LEFT0] = {0, 13, 26, 39, 52, 65, 78, 91, 104, 117, 130, 143, 156},
	[DoorSlot.UP0] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
	[DoorSlot.RIGHT0] = {12, 25, 38, 51, 64, 77, 90, 103, 116, 129, 142, 155, 168},
	[DoorSlot.DOWN0] = {156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168},
	[DoorSlot.LEFT1] = {0, 13, 26, 39, 52, 65, 78, 91, 104, 117, 130, 143, 156},
	[DoorSlot.UP1] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
	[DoorSlot.RIGHT1] = {12, 25, 38, 51, 64, 77, 90, 103, 116, 129, 142, 155, 168},
	[DoorSlot.DOWN1] = {156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168}
}

mod.oppslots = {
	[DoorSlot.LEFT0] = DoorSlot.RIGHT0, 
	[DoorSlot.UP0] = DoorSlot.DOWN0, 
	[DoorSlot.RIGHT0] = DoorSlot.LEFT0, 
	[DoorSlot.LEFT1] = DoorSlot.RIGHT0, 
	[DoorSlot.DOWN0] = DoorSlot.UP0, 
	[DoorSlot.UP1] = DoorSlot.DOWN0, 
	[DoorSlot.RIGHT1] = DoorSlot.LEFT0, 
	[DoorSlot.DOWN1] = DoorSlot.UP0
}

mod.shapeindexes = {
	[RoomShape.ROOMSHAPE_1x1] = { 0 },
	[RoomShape.ROOMSHAPE_IH] = { 0 },
	[RoomShape.ROOMSHAPE_IV] = { 0 },
	[RoomShape.ROOMSHAPE_1x2] = { 0, 13 },
	[RoomShape.ROOMSHAPE_IIV] = { 0, 13 },
	[RoomShape.ROOMSHAPE_2x1] = { 0, 1 },
	[RoomShape.ROOMSHAPE_IIH] = { 0, 1 },
	[RoomShape.ROOMSHAPE_2x2] = { 0, 1, 13, 14 },
	[RoomShape.ROOMSHAPE_LTL] = { 1, 13, 14 },
	[RoomShape.ROOMSHAPE_LTR] = { 0, 13, 14 },
	[RoomShape.ROOMSHAPE_LBL] = { 0, 1, 14 },
	[RoomShape.ROOMSHAPE_LBR] = { 0, 1, 13 },
}


local function runUpdates(tab) --This is from Fiend Folio
    for i = #tab, 1, -1 do
        local f = tab[i]
        f.Delay = f.Delay - 1
        if f.Delay <= 0 then
            f.Func()
            table.remove(tab, i)
        end
    end
end

mod.delayedFuncs = {}
function mod:scheduleForUpdate(foo, delay, callback)
    callback = callback or ModCallbacks.MC_POST_UPDATE
    if not mod.delayedFuncs[callback] then
        mod.delayedFuncs[callback] = {}
        mod:AddCallback(callback, function()
            runUpdates(mod.delayedFuncs[callback])
        end)
    end

    table.insert(mod.delayedFuncs[callback], { Func = foo, Delay = delay })
end

function mod:RandomInt(min, max, customRNG) --This and GetRandomElem were written by Guwahavel (hi)
    local rand = customRNG or rng
    if not max then
        max = min
        min = 0
    end  
    if min > max then 
        local temp = min
        min = max
        max = temp
    end
    return min + (rand:RandomInt(max - min + 1))
end

function mod:Shuffle(tbl)
	for i = #tbl, 2, -1 do
    local j = mod:RandomInt(1, i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

if StageAPI then
	mod.luarooms = {}
	mod.luarooms.Jails = StageAPI.RoomsList("Jails", require("resources.luarooms.jails"))
end

if MinimapAPI then
	local jailsprite = Sprite()
	jailsprite:Load("gfx/ui/minimapapi/jailicon.anm2", true)
	jailsprite:SetFrame("CustomIconJail", 0)
	MinimapAPI:AddIcon("Jail", jailsprite)
end
mod.minimaprooms = {} --Stores rooms that need to be updated on MinimapAPI

function mod:IsDeadEnd(roomidx, shape)
	local level = game:GetLevel()
	shape = shape or RoomShape.ROOMSHAPE_1x1
	local deadend = false
	local adjindex = mod.adjindexes[shape]
	local adjrooms = 0
	for i, entry in pairs(adjindex) do
		local oob = false
		for j, idx in pairs(mod.borderrooms[i]) do
			if idx == roomidx then
				oob = true
			end
		end
		if level:GetRoomByIdx(roomidx+entry).GridIndex ~= -1 and not oob then
			adjrooms = adjrooms+1
		end
	end
	if adjrooms == 1 then
		deadend = true
	end
	return deadend
end

function mod:GetDeadEnds(roomdesc)
	local level = game:GetLevel()
	local roomidx = roomdesc.SafeGridIndex
	local shape = roomdesc.Data.Shape
	local adjindex = mod.adjindexes[shape]
	local deadends = {}
	for i, entry in pairs(adjindex) do
		if level:GetRoomByIdx(roomidx).Data then
			local oob = false
			for j, idx in pairs(mod.borderrooms[i]) do
				for k, shapeidx in pairs(mod.shapeindexes[shape]) do
					if idx == roomidx+shapeidx then
						oob = true
					end
				end
			end
			if roomdesc.Data.Doors & (1 << i) > 0 and mod:IsDeadEnd(roomidx+adjindex[i]) and level:GetRoomByIdx(roomidx+adjindex[i]).GridIndex == -1 and not oob then
				table.insert(deadends, {Slot = i, GridIndex = roomidx+adjindex[i]})
			end
		end
	end
	
	if #deadends >= 1 then
		return deadends
	else
		return nil
	end
end


function mod:MakeDoorJail(door)
	local doorSprite = door:GetSprite()
	local iscustomstage
	
	if StageAPI then
		iscustomstage = StageAPI.InOverriddenStage()
	end
	door:SetVariant(DoorVariant.DOOR_LOCKED_KEYFAMILIAR)
	--if not iscustomstage then
		doorSprite:Load("gfx/grid/jaildoor.anm2", true)
		doorSprite:ReplaceSpritesheet(0, "gfx/grid/jaildoor.png")
		--print(door.ExtraSprite)
	--end
	doorSprite:LoadGraphics()
	doorSprite:Play("Closed")
	--door:Bar()
	door:Update()
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

function mod:forceJailDoorClosed(doorswitch)
	local door = doorswitch:ToDoor()
	if door:GetSprite():GetFilename() == "gfx/grid/jaildoor.anm2" then
		--[[
		if door.Desc.Variant ~= DoorVariant.DOOR_LOCKED_BARRED then
			door:SetType(GridEntityType.GRID_DOOR)
			door:SetVariant(DoorVariant.DOOR_LOCKED_BARRED)
			door:Update()
		end]]
		local players = getPlayers()
		local doTheyActuallyHaveThem = false
		local playerWhoOpens
		for i=1,#players,1 do
			if players[i]:GetData().hasOpenedTheJailDoorThisFloor == true then
				doTheyActuallyHaveThem = true
				playerWhoOpens = players[i]:ToPlayer()
			elseif players[i]:GetData().hasOpenedTheJailDoorThisFloor == false or players[i]:GetData().hasOpenedTheJailDoorThisFloor == nil then
				doTheyActuallyHaveThem = false
			end
		end

		if doTheyActuallyHaveThem then
			if door.State ~= DoorState.STATE_OPEN then
				--print("open the goddamn door")
				TSIL.Doors.OpenDoorFast(door)
			end
			
		else
			if door.State ~= DoorState.STATE_CLOSED then
				--print("shut the goddamn door")
				TSIL.Doors.CloseDoorFast(door)
			end
		end

	end
end
mod:AddCallback(TSIL.Enums.CustomCallback.POST_DOOR_UPDATE, mod.forceJailDoorClosed)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, iscontinued)
	if not iscontinued then
		--local taintedbeggarQ4chance = 1
		--local itemconfig = Isaac:GetItemConfig()

	if iscontinued and not BasementRenovator and not mod.roomdata and not mod.luarooms then
		mod:scheduleForUpdate(function()
			mod.roomdata = {}
			mod:InitializeRoomData("miniboss", 12000, mod.maxvariant, mod.roomdata)
		end, 0, ModCallbacks.MC_POST_RENDER)
	end

	end
	
	

	rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
end)

function mod:IsRoomDescJail(roomdesc)
	if roomdesc and roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_MINIBOSS then
		if (roomdesc.Data.Variant >= 12000) or mod.savedata.JailLuarooms[roomdesc.GridIndex] then
			return true
		end
	end
	return false
end



function mod:GetOppositeDoorSlot(slot)
	return mod.oppslots[slot]
end

function mod:UpdateRoomDisplayFlags(initroomdesc)
	local level = game:GetLevel()
	local roomdesc = level:GetRoomByIdx(initroomdesc.GridIndex) --Only roomdescriptors from level:GetRoomByIdx() are mutable
	local roomdata = roomdesc.Data
	if level:GetRoomByIdx(roomdesc.GridIndex).DisplayFlags then
		if level:GetRoomByIdx(roomdesc.GridIndex) ~= level:GetCurrentRoomDesc().GridIndex then
			if roomdata then 
				if level:GetStateFlag(LevelStateFlag.STATE_FULL_MAP_EFFECT) then
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_ICON
				elseif roomdata.Type ~= RoomType.ROOM_DEFAULT and roomdata.Type ~= RoomType.ROOM_SECRET and roomdata.Type ~= RoomType.ROOM_SUPERSECRET and roomdata.Type ~= RoomType.ROOM_ULTRASECRET and level:GetStateFlag(LevelStateFlag.STATE_COMPASS_EFFECT) then
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_ICON
				elseif roomdata and level:GetStateFlag(LevelStateFlag.STATE_BLUE_MAP_EFFECT) and (roomdata.Type == RoomType.ROOM_SECRET or roomdata.Type == RoomType.ROOM_SUPERSECRET) then
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_ICON
				elseif level:GetStateFlag(LevelStateFlag.STATE_MAP_EFFECT) then
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_BOX
				else
					roomdesc.DisplayFlags = RoomDescriptor.DISPLAY_NONE
				end
			end
		end
	end
end

function mod:UpdateLevelDisplayFlags()
	local level = game:GetLevel()
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc then
			mod:UpdateRoomDisplayFlags(roomdesc)
		end
	end
end

function mod:GenerateSpecialRoom(roomtype, minvariant, maxvariant, onnewlevel) --Roomtype must be provided as a string for goto use, enter nil to generate an ordinary room
	onnewlevel = onnewlevel or false
	local level = game:GetLevel()
	local hascurseofmaze = false
	local floordeadends = {}
	local roomvariants = {}
	local currentroomidx = level:GetCurrentRoomIndex()
	local currentroomvisitcount = level:GetRoomByIdx(currentroomidx).VisitedCount
	
	if onnewlevel then
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			player:GetData().ResetPosition = player.Position
		end
	end
	
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		mod.applyingcurseofmaze = true
	end
	
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc and roomdesc.Data.Type == RoomType.ROOM_DEFAULT and roomdesc.Data.Subtype ~= 34 then
		local deadends = mod:GetDeadEnds(roomdesc)
			if deadends and not (onnewlevel and roomdesc.GridIndex == currentroomidx) then
				for j, deadend in pairs(deadends) do
					table.insert(floordeadends, {Slot = deadend.Slot, GridIndex = deadend.GridIndex, roomidx = roomdesc.GridIndex, visitcount = roomdesc.VisitedCount})
				end
			end
		end
	end
	
	if not floordeadends[1] then
		return false
	end
	
	for i = minvariant, maxvariant do
		table.insert(roomvariants, i)
	end
	
	mod:Shuffle(roomvariants)
	mod:Shuffle(floordeadends)
	
	for i, roomvariant in pairs(roomvariants) do
		if roomtype then
			Isaac.ExecuteCommand("goto s."..roomtype.."."..roomvariant)
		else
			Isaac.ExecuteCommand("goto d."..roomvariant)
		end
		local data = level:GetRoomByIdx(-3,0).Data
		
		if data.Shape == RoomShape.ROOMSHAPE_1x1 then
			for i, entry in pairs(floordeadends) do
				local deadendslot = entry.Slot
				local deadendidx = entry.GridIndex
				local roomidx = entry.roomidx
				local visitcount = entry.visitcount
				local roomdesc = level:GetRoomByIdx(roomidx)
				if roomdesc.Data and level:GetRoomByIdx(roomdesc.GridIndex).GridIndex ~= -1 and mod:GetOppositeDoorSlot(deadendslot) and data.Doors & (1 << mod:GetOppositeDoorSlot(deadendslot)) > 0 then
						if level:MakeRedRoomDoor(roomidx, deadendslot) then
							local newroomdesc = level:GetRoomByIdx(deadendidx, 0)
							newroomdesc.Data = data
							newroomdesc.Flags = 0
							mod:scheduleForUpdate(function()
								SFXManager():Stop(SoundEffect.SOUND_UNLOCK00)
								game:StartRoomTransition(currentroomidx, 0, RoomTransitionAnim.FADE)
								if level:GetRoomByIdx(currentroomidx).VisitedCount ~= currentroomvisitcount then
									level:GetRoomByIdx(currentroomidx).VisitedCount = currentroomvisitcount-1
								end
								mod:UpdateRoomDisplayFlags(newroomdesc)
								level:UpdateVisibility()
								if onnewlevel then
									for i = 0, game:GetNumPlayers() - 1 do
										local player = Isaac.GetPlayer(i)
										player.Position = player:GetData().ResetPosition
									end
								end
							end, 0, ModCallbacks.MC_POST_RENDER)
							mod:scheduleForUpdate(function()
								if hascurseofmaze then
									level:AddCurse(LevelCurse.CURSE_OF_MAZE)
									mod.applyingcurseofmaze = false
								end
								if onnewlevel then
									for i = 0, game:GetNumPlayers() - 1 do --You have to do it twice or it doesn't look right, not sure why
										local player = Isaac.GetPlayer(i)
										player.Position = player:GetData().ResetPosition
									end
								end
								level:UpdateVisibility()
							end, 0, ModCallbacks.MC_POST_UPDATE)
						table.insert(mod.minimaprooms, newroomdesc.GridIndex)
						return newroomdesc
					end
				end
			end
		end
	end
	
	game:StartRoomTransition(currentroomidx, 0, RoomTransitionAnim.FADE)
	mod:scheduleForUpdate(function()
		if onnewlevel then
			for i = 0, game:GetNumPlayers() - 1 do
				local player = Isaac.GetPlayer(i)
				player.Position = player:GetData().ResetPosition
			end
		end
	end, 0)
	return false
end

function mod:GenerateExtraRoom()
	local level = game:GetLevel()
	local floordeadends = {}
	local currentroomidx = level:GetCurrentRoomIndex()
	for j = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(j-1)
		if roomdesc then
			local deadends = mod:GetDeadEnds(roomdesc)
			if deadends and roomdesc.GridIndex ~= currentroomidx then
				for k, deadend in pairs(deadends) do
					table.insert(floordeadends, {Slot = deadend.Slot, GridIndex = deadend.GridIndex, roomidx = roomdesc.GridIndex, visitcount = roomdesc.VisitedCount})
				end
			end
		end
	end
	
	mod:Shuffle(floordeadends)
	
	for i, deadend in pairs(floordeadends) do
		local deadendslot = deadend.Slot
		local deadendidx = deadend.GridIndex
		local roomidx = deadend.roomidx
		local roomdesc = level:GetRoomByIdx(roomidx)
		if roomdesc.Data and roomdesc.Data.Type == RoomType.ROOM_DEFAULT and level:GetRoomByIdx(roomdesc.GridIndex).GridIndex ~= -1 then
			if level:MakeRedRoomDoor(roomidx, deadendslot) then
				local newroomdesc = level:GetRoomByIdx(deadendidx, 0)
				newroomdesc.Flags = 0
				mod:UpdateRoomDisplayFlags(newroomdesc)
				level:UpdateVisibility()
				table.insert(mod.minimaprooms, newroomdesc.GridIndex)
				return true
			end
		end
	end
end

function mod:InitializeRoomData(roomtype, minvariant, maxvariant, dataset)
	local level = game:GetLevel()
	local currentroomidx = level:GetCurrentRoomIndex()
	local currentroomvisitcount = level:GetRoomByIdx(currentroomidx).VisitedCount
	local hascurseofmaze = false
	
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		mod.applyingcurseofmaze = true
	end
	
	for i = minvariant, maxvariant, 1 do
		if roomtype then
			Isaac.ExecuteCommand("goto s."..roomtype.."."..i)
			table.insert(dataset, level:GetRoomByIdx(-3,0).Data)
		else
			Isaac.ExecuteCommand("goto d."..i)
			table.insert(dataset, level:GetRoomByIdx(-3,0).Data)
		end
	end
	game:StartRoomTransition(currentroomidx, 0, RoomTransitionAnim.FADE)
	
	if level:GetRoomByIdx(currentroomidx).VisitedCount ~= currentroomvisitcount then
		level:GetRoomByIdx(currentroomidx).VisitedCount = currentroomvisitcount - 1
	end
	
	if hascurseofmaze then
		mod:scheduleForUpdate(function()
			level:AddCurse(LevelCurse.CURSE_OF_MAZE)
			mod.applyingcurseofmaze = false
		end, 0, ModCallbacks.MC_POST_UPDATE)
	end
end

--we can do this the easy way....
function mod:GenerateRoomFromLuarooms(dataset, onnewlevel)
	onnewlevel = onnewlevel or false
	local level = game:GetLevel()
	local floordeadends = {}
	local currentroomidx = level:GetCurrentRoomIndex()
	
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc and roomdesc.Data.Type == RoomType.ROOM_DEFAULT and roomdesc.Data.Subtype ~= 34 and roomdesc.Data.Subtype ~= 10 then --Subtype checks protect against generation off of Mirror or Mineshaft entrance rooms
		local deadends = mod:GetDeadEnds(roomdesc)
			if deadends and not (onnewlevel and roomdesc.GridIndex == currentroomidx) then
				for j, deadend in pairs(deadends) do
					table.insert(floordeadends, {Slot = deadend.Slot, GridIndex = deadend.GridIndex, roomidx = roomdesc.GridIndex, visitcount = roomdesc.VisitedCount})
				end
			end
		end
	end
	
	if not floordeadends[1] then
		return false
	end
	
	--for i, data in pairs(dataset) do
		--table.insert(setcopy, data)
	--end
	
	mod:Shuffle(floordeadends)
	
	for i, entry in pairs(floordeadends) do
		local deadendslot = entry.Slot
		local deadendidx = entry.GridIndex
		local roomidx = entry.roomidx
		local visitcount = entry.visitcount
		local roomdesc = level:GetRoomByIdx(roomidx)
		if roomdesc.Data and level:GetRoomByIdx(roomdesc.GridIndex).GridIndex ~= -1 and mod:GetOppositeDoorSlot(deadendslot) then
			if level:MakeRedRoomDoor(roomidx, deadendslot) then
				local newroomdesc = level:GetRoomByIdx(deadendidx, 0)
				newroomdesc.Data = data
				local data = StageAPI.GetGotoDataForTypeShape(RoomType.ROOM_MINIBOSS, RoomShape.ROOMSHAPE_1x1)

				newroomdesc.Data = data
				local luaroom = StageAPI.LevelRoom{
					RoomType = RoomType.ROOM_DEFAULT,
					RequireRoomType = false,
					RoomsList = dataset,
					RoomDescriptor = newroomdesc
				}
				StageAPI.SetLevelRoom(luaroom, newroomdesc.ListIndex)
				newroomdesc.Flags = 0
				mod:UpdateRoomDisplayFlags(newroomdesc)
				level:UpdateVisibility()
				table.insert(mod.minimaprooms, newroomdesc.GridIndex)
				return newroomdesc
			end
		end
	end
end

--or the hard way.
function mod:GenerateRoomFromDataset(dataset, onnewlevel)
	onnewlevel = onnewlevel or false
	local level = game:GetLevel()
	local floordeadends = {}
	local setcopy = dataset
	local currentroomidx = level:GetCurrentRoomIndex()
	
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc and roomdesc.Data.Type == RoomType.ROOM_DEFAULT and roomdesc.Data.Subtype ~= 34 and roomdesc.Data.Subtype ~= 10 then --Subtype checks protect against generation off of Mirror or Mineshaft entrance rooms
		local deadends = mod:GetDeadEnds(roomdesc)
			if deadends and not (onnewlevel and roomdesc.GridIndex == currentroomidx) then
				for j, deadend in pairs(deadends) do
					table.insert(floordeadends, {Slot = deadend.Slot, GridIndex = deadend.GridIndex, roomidx = roomdesc.GridIndex, visitcount = roomdesc.VisitedCount})
				end
			end
		end
	end
	
	if not floordeadends[1] then
		return false
	end
	
	--for i, data in pairs(dataset) do
		--table.insert(setcopy, data)
	--end
	
	mod:Shuffle(floordeadends)
	mod:Shuffle(setcopy)
	
	for i, data in pairs(setcopy) do
		if data.Shape == RoomShape.ROOMSHAPE_1x1 then
			for i, entry in pairs(floordeadends) do
				local deadendslot = entry.Slot
				local deadendidx = entry.GridIndex
				local roomidx = entry.roomidx
				local visitcount = entry.visitcount
				local roomdesc = level:GetRoomByIdx(roomidx)
				if roomdesc.Data and level:GetRoomByIdx(roomdesc.GridIndex).GridIndex ~= -1 and mod:GetOppositeDoorSlot(deadendslot) and data.Doors & (1 << mod:GetOppositeDoorSlot(deadendslot)) > 0 then
					if level:MakeRedRoomDoor(roomidx, deadendslot) then
						local newroomdesc = level:GetRoomByIdx(deadendidx, 0)
						newroomdesc.Data = data
						newroomdesc.Flags = 0
						mod:UpdateRoomDisplayFlags(newroomdesc)
						level:UpdateVisibility()
						table.insert(mod.minimaprooms, newroomdesc.GridIndex)
						return newroomdesc
					end
				end
			end
		end
	end
end




function mod:OnNewLevel()
	local level = game:GetLevel()
	mod.savedata.spawnchancemultiplier = mod.savedata.spawnchancemultiplier or 1
	mod.savedata.JailLuarooms = {}
	mod.DoneFullMapping = 0
	mod.SecretRoomIndex = level:QueryRoomTypeIndex(RoomType.ROOM_SECRET, false, rng)
	mod.TreasureRoomIndex = level:QueryRoomTypeIndex(RoomType.ROOM_TREASURE, false, rng)
	mod.BossRoomIndex = level:QueryRoomTypeIndex(RoomType.ROOM_BOSS, false, rng)
	mod.SecretRoomVisited = false
	mod.TreasureRoomVisited = false
	mod.BossRoomVisited = false
	altPathItemChecked = {}
	
	
	
	--Handles jail spawning (i hope)
	if not mod.roomdata and level:GetStage() ~= LevelStage.STAGE1_1 and not BasementRenovator and (not StageAPI or not StageAPI.InOverriddenStage()) and not mod.luarooms then
		mod.roomdata = {}
		mod:InitializeRoomData("miniboss", 12000, mod.maxvariant, mod.roomdata)
	end
	
	local spawnchance = 0
	--local stagelimit = 9
	if not level:IsAscent() and Isaac.GetChallenge() == 0 and (not StageAPI or not StageAPI.InOverriddenStage()) then
		--for debug reasons
		spawnchance = 1
	end
	
	local totalchance = mod.savedata.spawnchancemultiplier*spawnchance
	local newchance = 1
	totalchance = newchance or totalchance

	--print(totalchance)
	if totalchance > 0 then
		if rng:RandomFloat() <= totalchance then
			if not game:IsGreedMode() then
				if not mod.luarooms then
					local newroomdesc = mod:GenerateRoomFromDataset(mod.roomdata, true)
					--print("we got a jail!!")
				else
					local newroomdesc = mod:GenerateRoomFromLuarooms(mod.luarooms.Jails, true)
					--print("we got a jail!!")
					if newroomdesc then
						mod.savedata.JailLuarooms = mod.savedata.JailLuarooms or {}
						mod.savedata.JailLuarooms[newroomdesc.GridIndex] = true
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

	mod:SaveData(json.encode(mod.savedata))
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewLevel)




mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_) --Andromeda was used as the reference for managing new room types
	local level = game:GetLevel()
	local roomidx = level:GetCurrentRoomIndex()
	local roomdesc = level:GetCurrentRoomDesc()
	local roomdata = roomdesc.Data
	local room = game:GetRoom()
	local roomtype = room:GetType()

	if roomtype == RoomType.ROOM_SECRET then
		if roomidx == mod.SecretRoomIndex then
			mod.SecretRoomVisited = true
		end
	elseif roomtype == RoomType.ROOM_TREASURE then
		if roomidx == mod.TreasureRoomIndex then
			mod.TreasureRoomVisited = true
		end
	elseif roomtype == RoomType.ROOM_BOSS then
		if roomidx == mod.BossRoomIndex then
			mod.BossRoomVisited = true
		end
	end

	for i = 0, DoorSlot.NUM_DOOR_SLOTS do
		local door = room:GetDoor(i)
		if door then
			local targetroomdesc = level:GetRoomByIdx(door.TargetRoomIndex)
			if mod:IsRoomDescJail(targetroomdesc) then
				mod:MakeDoorJail(door)
				--door.ExtraVisible = false
				--door:Bar()
			end
		end
	end
	
	if mod:IsRoomDescJail(roomdesc) then
		local haschaos = false
		local dice = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DICE_FLOOR)
		if #dice > 0 then
			for i = 1, #dice do
				dice[i]:Remove()
			end
		end
		--[[
		mod:scheduleForUpdate(function()
			MusicManager():Play(TaintedTracks.SACRIFICIAL, 1)
			MusicManager():UpdateVolume()
		end, 0, ModCallbacks.MC_POST_RENDER)
		]]
		for i = 0, DoorSlot.NUM_DOOR_SLOTS do
			local door = room:GetDoor(i)
			if door then
				local doorSprite = door:GetSprite()
				mod:MakeDoorJail(door)
				doorSprite:Play("Opened")

				--From Andromeda, probably don't even need this here but leaving it just to be safe: Fix for the room infinitely looping when using joker or similar card
				if door.TargetRoomIndex == GridRooms.ROOM_DEBUG_IDX then
					game:StartRoomTransition(84, 1, RoomTransitionAnim.FADE)
				end
			end
		end
		
		
		if room:GetBackdropType() ~= BackdropType.DARK_CLOSET then
			game:ShowHallucination(0, BackdropType.DARK_CLOSET)
			SFXManager():Stop(SoundEffect.SOUND_DEATH_CARD)
		end
		
		for i = 0, 118 do
			local grident = room:GetGridEntity(i)
			if grident and grident:ToRock() and grident:GetType() ~= 6 then
				grident:GetSprite():ReplaceSpritesheet(0, "gfx/grid/rocks_jail.png")
				grident:GetSprite():LoadGraphics()
			end
			if grident and grident:ToPit() then
				grident:GetSprite():ReplaceSpritesheet(0, "gfx/grid/grid_pit_jail.png")
				grident:GetSprite():LoadGraphics()
			end
			if grident and grident:GetType() == GridEntityType.GRID_DECORATION then
				grident:GetSprite():ReplaceSpritesheet(0, "gfx/grid/props_05_depths.png")
				grident:GetSprite():LoadGraphics()
			end
		end

		--mod:UpdateTaintedItems()
	end

	
	if MinimapAPI and #mod.minimaprooms > 0 then
		for i, roomidx in pairs(mod.minimaprooms) do
			local minimaproom = MinimapAPI:GetRoomByIdx(roomidx)
			mod:scheduleForUpdate(function()
				if minimaproom then
					minimaproom.Color = Color(MinimapAPI.Config.DefaultRoomColorR, MinimapAPI.Config.DefaultRoomColorG, MinimapAPI.Config.DefaultRoomColorB, 1, 0, 0, 0)
					if mod:IsRoomDescJail(minimaproom.Descriptor) then
						minimaproom.PermanentIcons = {"Jail"}
					end
					mod.minimaprooms[i] = nil
				end
			end, 0)
		end
	else
		mod.minimaprooms = {}
	end

	mod.CustomFireWaves = {}
	mod.GridPaths = {}
end)
