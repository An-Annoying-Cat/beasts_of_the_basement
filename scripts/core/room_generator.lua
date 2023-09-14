-- COPIED AND ADAPTED from Beyond's adaptation of the TaintedTreasure mod, credits to them!
local botb_room_generator = {}

local locals =
{
	-- to be setup using the Setup function
	callback_holder = nil,

	-- MiniAPI (and more) compatibility (access through GetMinimapRooms())
	handled_rooms = {},

	applyingcurseofmaze = false,
	delayedFuncs = {},

	-- allows finding all adjacent room indexes of a room based on its shape
	adjindexes = {
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
	},

	-- allows finding all indexes of a room based on its shape
	all_indexes = {
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
	},

	-- allows finding all rooms on borders
	borderrooms = {
		[DoorSlot.LEFT0] = {0, 13, 26, 39, 52, 65, 78, 91, 104, 117, 130, 143, 156},
		[DoorSlot.UP0] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
		[DoorSlot.RIGHT0] = {12, 25, 38, 51, 64, 77, 90, 103, 116, 129, 142, 155, 168},
		[DoorSlot.DOWN0] = {156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168},
		[DoorSlot.LEFT1] = {0, 13, 26, 39, 52, 65, 78, 91, 104, 117, 130, 143, 156},
		[DoorSlot.UP1] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
		[DoorSlot.RIGHT1] = {12, 25, 38, 51, 64, 77, 90, 103, 116, 129, 142, 155, 168},
		[DoorSlot.DOWN1] = {156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168}
	},

	-- allows finding opposing door slots
	oppslots = {
		[DoorSlot.LEFT0] = DoorSlot.RIGHT0, 
		[DoorSlot.UP0] = DoorSlot.DOWN0, 
		[DoorSlot.RIGHT0] = DoorSlot.LEFT0, 
		[DoorSlot.LEFT1] = DoorSlot.RIGHT0, 
		[DoorSlot.DOWN0] = DoorSlot.UP0, 
		[DoorSlot.UP1] = DoorSlot.DOWN0, 
		[DoorSlot.RIGHT1] = DoorSlot.LEFT0, 
		[DoorSlot.DOWN1] = DoorSlot.UP0
	},

	data_cache = {},
}

local game = Game()

function botb_room_generator:SetCallbackHolder(callback_holder)
	locals.callback_holder = callback_holder
end

function botb_room_generator:GetHandledRooms()
	return locals.handled_rooms
end

function botb_room_generator:ClearHandledRooms()
	locals.handled_rooms = {}
end

local function Shuffle(tbl)
	local rng = botb_gs.rng
	for i = #tbl, 2, -1 do
		local j = rng:RandomInt(i)+1
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

RoomGenerationMode =
{
	ALLOW_DEADENDS_ONLY = 1,
	ALLOW_ADJ_TO_NORMAL_ROOMS = 2,
	ALLOW_ADJ_TO_MOST_SPECIAL_ROOMS = 3,
}

local function IsValidCandidate(roomidx,room_generation_mode)
	local shape = RoomShape.ROOMSHAPE_1x1 -- will only be able to generate 1x1 rooms, could be added as a parameter for further uses
	local level = game:GetLevel()
	local adj_room_count = 0
	local allow_adj_to_most_special_rooms = room_generation_mode == RoomGenerationMode.ALLOW_ADJ_TO_MOST_SPECIAL_ROOMS

	local all_indexes = locals.all_indexes[shape]
	for door_slot, entry in pairs(locals.adjindexes[shape]) do
		local oob = false
		for _, border_idx in pairs(locals.borderrooms[door_slot]) do
			for _, all_idx in pairs(all_indexes) do
				if border_idx == roomidx+all_idx then
					oob = true
					break
				end
			end
		end

		local roomdesc = level:GetRoomByIdx(roomidx+entry)
		if not oob -- index is valid and not out of bounds (for instance we don't want to check index 12 while testing left door on index 13, as 13 is a room on the left border itself!)
		and roomdesc.GridIndex ~= -1 then -- adj room exists!
			if roomdesc.Data.Type == RoomType.ROOM_ERROR
			or roomdesc.Data.Type == RoomType.ROOM_BOSS
			or roomdesc.Data.Type == RoomType.ROOM_DUNGEON
			or roomdesc.Data.Type == RoomType.ROOM_BOSSRUSH
			or roomdesc.Data.Type == RoomType.ROOM_BLACK_MARKET
			or roomdesc.Data.Type == RoomType.ROOM_GREED_EXIT
			or roomdesc.Data.Type == RoomType.ROOM_TELEPORTER
			or roomdesc.Data.Type == RoomType.ROOM_TELEPORTER_EXIT
			or roomdesc.Data.Type == RoomType.ROOM_SECRET_EXIT
			or roomdesc.Data.Type == RoomType.ROOM_ULTRASECRET then
				return false -- don't want room generation adjacent to those rooms, ever
			end

			if not allow_adj_to_most_special_rooms and
			( roomdesc.Data.Type == RoomType.ROOM_SHOP
			or roomdesc.Data.Type == RoomType.ROOM_TREASURE
			or roomdesc.Data.Type == RoomType.ROOM_MINIBOSS
			or roomdesc.Data.Type == RoomType.ROOM_SECRET
			or roomdesc.Data.Type == RoomType.ROOM_SUPERSECRET
			or roomdesc.Data.Type == RoomType.ROOM_ARCADE
			or roomdesc.Data.Type == RoomType.ROOM_CURSE
			or roomdesc.Data.Type == RoomType.ROOM_CHALLENGE
			or roomdesc.Data.Type == RoomType.ROOM_LIBRARY
			or roomdesc.Data.Type == RoomType.ROOM_SACRIFICE
			or roomdesc.Data.Type == RoomType.ROOM_DEVIL
			or roomdesc.Data.Type == RoomType.ROOM_ANGEL
			or roomdesc.Data.Type == RoomType.ROOM_ISAACS
			or roomdesc.Data.Type == RoomType.ROOM_BARREN
			or roomdesc.Data.Type == RoomType.ROOM_CHEST
			or roomdesc.Data.Type == RoomType.ROOM_DICE
			or roomdesc.Data.Type == RoomType.ROOM_PLANETARIUM
			or roomdesc.Data.Type == RoomType.ROOM_BLUE ) then
				return false
			end

			adj_room_count = adj_room_count+1
		end
	end
	return room_generation_mode==RoomGenerationMode.ALLOW_DEADENDS_ONLY and (adj_room_count == 1) or true
end


local function ShouldParseRoom(roomdesc,room_generation_mode)
	if not roomdesc then return false end

	-- Subtype checks protect against generation off of Mirror or Mineshaft entrance rooms
	if roomdesc.Data.Type == RoomType.ROOM_DEFAULT 
	and (roomdesc.Data.Subtype == 34 or roomdesc.Data.Subtype == 10) then return false end 

	if room_generation_mode == RoomGenerationMode.ALLOW_DEADENDS_ONLY
	or room_generation_mode == RoomGenerationMode.ALLOW_ADJ_TO_NORMAL_ROOMS then
		return roomdesc.Data.Type == RoomType.ROOM_DEFAULT
	end

	return true
end

local function GetCandidatesForGeneration(roomdesc,room_generation_mode)
	if not ShouldParseRoom(roomdesc,room_generation_mode) then return nil end

	local level = game:GetLevel()
	local roomidx = roomdesc.SafeGridIndex
	if not level:GetRoomByIdx(roomidx).Data then return nil end

	local candidates = {}
	local shape = roomdesc.Data.Shape

	local all_indexes = locals.all_indexes[shape]

	for door_slot, entry in pairs(locals.adjindexes[shape]) do
		if roomdesc.Data.Doors & (1 << door_slot) > 0 -- doorslot compatibility
		and level:GetRoomByIdx(roomidx+entry).GridIndex == -1 then -- actually non existent room
			-- check that the "future adjacent room" on that door slot isn't out of bounds! (outside of the 13x13 grid)
			-- this is done by checking whether any of the indexes of the room isn't part of the border rooms indexes for that door slot
			-- eg: when testing the roomidx==145 and shape==ROOMSHAPE_1x2, DoorSlot.DOWN0 is made INVALID because 158 (145+13) is part of the border
			local oob = false
			for _, border_idx in pairs(locals.borderrooms[door_slot]) do
				for _, all_idx in pairs(all_indexes) do
					if border_idx == roomidx+all_idx then
						oob = true
						break
					end
				end
			end

			if not oob and IsValidCandidate(roomidx+entry, room_generation_mode) then
				table.insert(candidates, {Slot = door_slot, GridIndex = roomidx+entry})
			end
		end
	end
	
	return candidates[1] and candidates or nil
end

function botb_room_generator:GetOppositeDoorSlot(slot)
	return locals.oppslots[slot]
end

function botb_room_generator:UpdateRoomDisplayFlags(initroomdesc)
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

function botb_room_generator:UpdateLevelDisplayFlags()
	local level = game:GetLevel()
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc then
			botb_room_generator:UpdateRoomDisplayFlags(roomdesc)
		end
	end
end

function botb_room_generator:GetRoomVariantRange(minvariant, maxvariant)
	local roomvariants = {}
	for i = minvariant, maxvariant do
		table.insert(roomvariants, i)
	end
	return roomvariants
end

-- for any existing adjacent room to grid_idx, we want to check whether roomdata can have a door going to that door 
local function CheckDoors(roomdata,grid_idx)
	local shape = roomdata.Shape
	local roomidx = grid_idx
	local all_indexes = locals.all_indexes[shape]

	for door_slot, entry in pairs(locals.adjindexes[shape]) do
		local oob = false
		for _, border_idx in pairs(locals.borderrooms[door_slot]) do
			for _, all_idx in pairs(all_indexes) do
				if border_idx == roomidx+all_idx then
					oob = true
					break
				end
			end
		end

		if not oob -- index needs to be checked (for instance we don't want to check index 12 while testing left door on index 13, as 13 is a room on the left border itself!)
		and Game():GetLevel():GetRoomByIdx(roomidx+entry).GridIndex ~= -1 then -- adj room exists!
		
			if roomdata.Doors & (1 << door_slot) == 0 then
				return false
			end
		end
	end
	return true
end

-- when replacing, we whant the replacement to have AT least the same door slot, if not more, less doors IS FORBIDDEN (bug with USR)
local function CheckDoorsForReplacement(replacement_data,replaced_data)
	return (replacement_data.Doors & replaced_data.Doors) == replaced_data.Doors
end

 -- roomtype must be provided as a string for goto use, enter nil to generate an ordinary room
function botb_room_generator:GenerateExtraRoom(roomtype, roomvariants, onnewlevel, room_generation_mode)
	onnewlevel = onnewlevel or false
	room_generation_mode = room_generation_mode or RoomGenerationMode.ALLOW_DEADENDS_ONLY
	local level = game:GetLevel()
	local hascurseofmaze = false
	local currentroomidx = level:GetCurrentRoomIndex()
	local currentroomvisitcount = level:GetRoomByIdx(currentroomidx).VisitedCount
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		player:GetData().ResetPosition = player.Position
	end
	
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		locals.applyingcurseofmaze = true
	end

	local available_grid_spaces = {}
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc and not (onnewlevel and roomdesc.GridIndex == currentroomidx) then -- we do not want to generate a room adjacent to the very first room on a new level: fishy: why not?
			local candidates = GetCandidatesForGeneration(roomdesc,room_generation_mode)
			if candidates then
				for j, candidate in pairs(candidates) do
					-- check for unicity if needed (do not add multiple times the same candidate)
					local already_in = false
					if room_generation_mode ~= RoomGenerationMode.ALLOW_DEADENDS_ONLY then
						for k, entry in pairs(available_grid_spaces) do
							if entry.GridIndex == candidate.GridIndex and entry.Slot == candidate.Slot then
								already_in = true
								break
							end
						end
					end
					if not already_in then
						table.insert(available_grid_spaces, {Slot = candidate.Slot, GridIndex = candidate.GridIndex, roomidx = roomdesc.GridIndex, visitcount = roomdesc.VisitedCount})
					end
				end
			end
		end
	end
	
	if not available_grid_spaces[1] then
		-- print("[Warning] RoomGeneratorAPI: could not find an available grid space to generate a room, try to use a more flexible generation mode")
		return false
	end

	Shuffle(roomvariants)
	Shuffle(available_grid_spaces)
	-- print("#spaces: "..#available_grid_spaces)

	local need_go_back_to_start = false

	for _, roomvariant in pairs(roomvariants) do
		-- clear old desc, if any
		local old_desc = level:GetRoomByIdx(-3,0)
		if old_desc and old_desc.Data then
			old_desc.Data = nil
		end

		local variant_data = nil
		if roomtype then
			if locals.data_cache[roomtype] and locals.data_cache[roomtype][roomvariant] then
				variant_data = locals.data_cache[roomtype][roomvariant]
			else
				need_go_back_to_start = true
				Isaac.ExecuteCommand("goto s."..roomtype.."."..roomvariant)
				variant_data = level:GetRoomByIdx(-3).Data
			end
		else
			if locals.data_cache["nil"] and locals.data_cache["nil"][roomvariant] then
				variant_data = locals.data_cache["nil"][roomvariant]
			else
				need_go_back_to_start = true
				Isaac.ExecuteCommand("goto d."..roomvariant)
				variant_data = level:GetRoomByIdx(-3).Data
			end
		end
		
		if variant_data and variant_data.Shape == RoomShape.ROOMSHAPE_1x1 then
			-- todo: check for doors!
			for _, entry in pairs(available_grid_spaces) do
				local available_grid_space_red_door_slot = entry.Slot
				local available_grid_space_idx = entry.GridIndex
				local visitcount = entry.visitcount
				local roomidx = entry.roomidx
				local roomdesc = level:GetRoomByIdx(roomidx) -- adjacent room where it's being generated from
				if roomdesc.Data
				and CheckDoors(variant_data,available_grid_space_idx) 
				--and level:GetRoomByIdx(roomdesc.GridIndex).GridIndex ~= -1 -- supposedly not needed (true by design)
				and botb_room_generator:GetOppositeDoorSlot(available_grid_space_red_door_slot) 
				and variant_data.Doors & (1 << botb_room_generator:GetOppositeDoorSlot(available_grid_space_red_door_slot)) > 0 then
					if level:MakeRedRoomDoor(roomidx, available_grid_space_red_door_slot) then
						-- print("variant "..roomvariant.." was placed in "..entry.GridIndex)

						local newroomdesc = level:GetRoomByIdx(available_grid_space_idx)
						newroomdesc.Data = variant_data
						newroomdesc.Flags = 0

						SFXManager():Stop(SoundEffect.SOUND_UNLOCK00)

						if need_go_back_to_start then
							game:StartRoomTransition(currentroomidx, 0)
							if level:GetRoomByIdx(currentroomidx).VisitedCount ~= currentroomvisitcount then
								level:GetRoomByIdx(currentroomidx).VisitedCount = currentroomvisitcount-1
							end

							for i = 0, game:GetNumPlayers() - 1 do
								local player = Isaac.GetPlayer(i)
								player.Position = player:GetData().ResetPosition
							end
						end

						botb_room_generator:UpdateRoomDisplayFlags(newroomdesc)
						level:UpdateVisibility()
						
						if hascurseofmaze then
							-- after the next update; so that we are not teleported right away
							botb_utils:schedule_for_update( function()
								level:AddCurse(LevelCurse.CURSE_OF_MAZE)
								locals.applyingcurseofmaze = false
							end, 0)
						end
							
						table.insert(locals.handled_rooms, {idx=newroomdesc.GridIndex,generated=true,generation_data={roomtype=roomtype,roomvariant=roomvariant,roomidx=roomidx,red_door=available_grid_space_red_door_slot}} )

						return newroomdesc
					end
				end
			end
		-- else
			-- print("[Warning] RoomGeneratorAPI: unhandled shape for room generation, you may want to add a case or specify only variants with handled shapes")
		end
	end
	
	if need_go_back_to_start then
		game:StartRoomTransition(currentroomidx, 0)
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			player.Position = player:GetData().ResetPosition
		end
	end
	if hascurseofmaze then
		-- after the next update; so that we are not teleported right away
		botb_utils:schedule_for_update(function()
			level:AddCurse(LevelCurse.CURSE_OF_MAZE)
			locals.applyingcurseofmaze = false
		end, 0, ModCallbacks.MC_POST_UPDATE)
	end

	-- print("[Warning] RoomGeneratorAPI: couldn't generate a room with provided variants and mode, see previous warnings or errors or retry with a more flexible mode")
	return false
end

local function remove_dummies_for_mirror_world()
	for _,var in pairs({BeyondDummyVariant.YUMMY_TRINKET_FOR_SALE,
						BeyondDummyVariant.VIRTUE_ITEM_SOUL_OF_SIN,
						BeyondDummyVariant.SIN_ITEM_SOUL_OF_SIN,
						BeyondDummyVariant.PHANTOM_THIEF_SIGNATURE}) do
		for _, entity in pairs(Isaac.FindByType(EntityType.ENTITY_DUMMY,var)) do
			entity:Remove()
		end
	end
end

function botb_room_generator:HandleMirrorWorld()
	local level = game:GetLevel()
	local hascurseofmaze = false
	local currentroomidx = level:GetCurrentRoomIndex()
	local currentroomvisitcount = level:GetRoomByIdx(currentroomidx).VisitedCount
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		player:GetData().ResetPosition = player.Position
	end
	
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		locals.applyingcurseofmaze = true
	end

	-- iterate through all the generated/replaced rooms and try to generate/replace them again in the mirror world!
	for i, room_data in pairs(locals.handled_rooms) do
		if room_data.generated then
			local gen_data = room_data.generation_data
			
			if gen_data.roomtype then
				Isaac.ExecuteCommand("goto s."..gen_data.roomtype.."."..gen_data.roomvariant)
			else
				Isaac.ExecuteCommand("goto d."..gen_data.roomvariant)
			end
			need_go_back_to_start = true

			local variant_data = level:GetRoomByIdx(-3).Data
			if variant_data then
				if level:MakeRedRoomDoor(gen_data.roomidx, gen_data.red_door) then
					local newroomdesc = level:GetRoomByIdx(room_data.idx)
					newroomdesc.Data = variant_data
					newroomdesc.Flags = 0
					SFXManager():Stop(SoundEffect.SOUND_UNLOCK00)
						-- remove yummy trinket for sale
						game:StartRoomTransition(room_data.idx, 0)
						remove_dummies_for_mirror_world()
						level:GetRoomByIdx(room_data.idx).VisitedCount = 0
					botb_room_generator:UpdateRoomDisplayFlags(newroomdesc)
				end
			end
		elseif room_data.replaced then
			local rep_data = room_data.replacement_data
			if rep_data.prev_type ~= RoomType.ROOM_TREASURE then -- treasure rooms are never replaced in the mirror world (to avoid breaking the game!)
				if rep_data.roomtype then
					Isaac.ExecuteCommand("goto s."..rep_data.roomtype.."."..rep_data.roomvariant)
				else
					Isaac.ExecuteCommand("goto d."..rep_data.roomvariant)
				end
				need_go_back_to_start = true

				local variant_data = level:GetRoomByIdx(-3).Data
				if variant_data then
					local replaced_room_desc = level:GetRoomByIdx(room_data.idx)
					replaced_room_desc.Data = variant_data
					replaced_room_desc.Flags = 0
						-- remove yummy trinket for sale
						game:StartRoomTransition(room_data.idx, 0)
						remove_dummies_for_mirror_world()
						level:GetRoomByIdx(room_data.idx).VisitedCount = 0
					botb_room_generator:UpdateRoomDisplayFlags(replaced_room_desc)
				end
			end
		end
	end

	if need_go_back_to_start then
		game:StartRoomTransition(currentroomidx, 0)
		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			player.Position = player:GetData().ResetPosition
		end
	end
	if hascurseofmaze then
		-- after the next update; so that we are not teleported right away
		botb_utils:schedule_for_update(function()
			level:AddCurse(LevelCurse.CURSE_OF_MAZE)
			locals.applyingcurseofmaze = false
		end, 0, ModCallbacks.MC_POST_UPDATE)
	end
	if level:GetRoomByIdx(currentroomidx).VisitedCount ~= currentroomvisitcount then
		level:GetRoomByIdx(currentroomidx).VisitedCount = currentroomvisitcount-1
	end
	level:UpdateVisibility()
end

-- replace all the rooms that matched replaced_room_functor by rooms from the provided type and variants
 -- roomtype must be provided as a string for goto use, enter nil to use ordinary rooms
function botb_room_generator:ReplaceRooms(replaced_room_functor, roomtype, roomvariants)
	local level = game:GetLevel()
	local hascurseofmaze = false
	local currentroomidx = level:GetCurrentRoomIndex()
	local currentroomvisitcount = level:GetRoomByIdx(currentroomidx).VisitedCount
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		player:GetData().ResetPosition = player.Position
	end
	
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		locals.applyingcurseofmaze = true
	end

	local need_go_back_to_start = false

	-- for every room that...
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		-- ... is to be replaced ...
		if replaced_room_functor(roomdesc) then

			-- shuffle again so multiple rooms being replaced do not end up with the same layout
			Shuffle(roomvariants)

			-- ... go through the provided rooms to find a...
			for _, roomvariant in pairs(roomvariants) do
				-- clear old desc, if any
				local old_desc = level:GetRoomByIdx(-3,0)
				if old_desc and old_desc.Data then
					old_desc.Data = nil
				end

				local variant_data = nil
				if roomtype then
					if locals.data_cache[roomtype] and locals.data_cache[roomtype][roomvariant] then
						variant_data = locals.data_cache[roomtype][roomvariant]
					else
						need_go_back_to_start = true
						Isaac.ExecuteCommand("goto s."..roomtype.."."..roomvariant)
						variant_data = level:GetRoomByIdx(-3).Data
					end
				else
					if locals.data_cache["nil"] and locals.data_cache["nil"][roomvariant] then
						variant_data = locals.data_cache["nil"][roomvariant]
					else
						need_go_back_to_start = true
						Isaac.ExecuteCommand("goto d."..roomvariant)
						variant_data = level:GetRoomByIdx(-3).Data
					end
				end

				-- ... suitable replacement.
				if variant_data
				and variant_data.Shape == RoomShape.ROOMSHAPE_1x1
				and CheckDoorsForReplacement(variant_data,roomdesc.Data) then
					local replaced_room_desc = level:GetRoomByIdx(roomdesc.GridIndex)
					local previous_type = replaced_room_desc.Data.Type
					replaced_room_desc.Data = variant_data
					replaced_room_desc.Flags = 0
					botb_room_generator:UpdateRoomDisplayFlags(replaced_room_desc)

					table.insert(locals.handled_rooms, {idx=replaced_room_desc.GridIndex,replaced=true,replacement_data={roomtype=roomtype,roomvariant=roomvariant,prev_type=previous_type}})
					break
				end
			end
		end
	end

	if hascurseofmaze then
		botb_utils:schedule_for_update(function()
			level:AddCurse(LevelCurse.CURSE_OF_MAZE)
			locals.applyingcurseofmaze = false
		end, 0, ModCallbacks.MC_POST_UPDATE)
	end

	if need_go_back_to_start then
		SFXManager():Stop(SoundEffect.SOUND_UNLOCK00)

		game:StartRoomTransition(currentroomidx, 0)
		if level:GetRoomByIdx(currentroomidx).VisitedCount ~= currentroomvisitcount then
			level:GetRoomByIdx(currentroomidx).VisitedCount = currentroomvisitcount-1
		end

		for i = 0, game:GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			player.Position = player:GetData().ResetPosition
		end
	end

	level:UpdateVisibility()
end

-- replace the current room with one the provided variants of the provided type
-- CURRENTLY not working well: previous grid entities and more, from the current room, persist
function botb_room_generator:ReplaceCurrentRoom(roomtype,roomvariants)
	local level = game:GetLevel()
	local current_room_desc = level:GetRoomByIdx(level:GetCurrentRoomIndex())
	local current_room_visit_count_at_start = current_room_desc.VisitedCount
	
	for i = 0, game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(i)
		player:GetData().ResetPosition = player.Position
	end
	
	local hascurseofmaze = false
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		locals.applyingcurseofmaze = true
	end

	local need_go_back_to_start = false
	local room_idx_at_start = level:GetCurrentRoomIndex()

	Shuffle(roomvariants)

	for _, roomvariant in pairs(roomvariants) do
		local variant_data = nil
		if roomtype then
			if locals.data_cache[roomtype] and locals.data_cache[roomtype][roomvariant] then
				variant_data = locals.data_cache[roomtype][roomvariant]
			else
				need_go_back_to_start = true
				Isaac.ExecuteCommand("goto s."..roomtype.."."..roomvariant)
				variant_data = level:GetRoomByIdx(-3).Data
			end
		else
			if locals.data_cache["nil"] and locals.data_cache["nil"][roomvariant] then
				variant_data = locals.data_cache["nil"][roomvariant]
			else
				need_go_back_to_start = true
				Isaac.ExecuteCommand("goto d."..roomvariant)
				variant_data = level:GetRoomByIdx(-3).Data
			end
		end

		-- find a suitable replacement.
		if variant_data 
		and variant_data.Shape == RoomShape.ROOMSHAPE_1x1
		and CheckDoors(variant_data,current_room_desc.GridIndex) then
			local previous_type = current_room_desc.Data.Type
			current_room_desc.Data = variant_data
			current_room_desc.Flags = 0
			botb_room_generator:UpdateRoomDisplayFlags(current_room_desc)

			table.insert(locals.handled_rooms, {idx=current_room_desc.GridIndex,replaced=true,replacement_data={roomtype=roomtype,roomvariant=roomvariant,prev_type=previous_type}})
			need_go_back_to_start = false
			break
		end
	end

	if hascurseofmaze then
		botb_utils:schedule_for_update(function()
			level:AddCurse(LevelCurse.CURSE_OF_MAZE)
			locals.applyingcurseofmaze = false
		end, 0, ModCallbacks.MC_POST_UPDATE)
	end

	if need_go_back_to_start then
		-- not needed if a suitable variant was found, we're already in the room by design
		game:StartRoomTransition(room_idx_at_start, 0)
	end

	SFXManager():Stop(SoundEffect.SOUND_UNLOCK00)

	if current_room_desc.VisitedCount ~= current_room_visit_count_at_start then
		current_room_desc.VisitedCount = current_room_visit_count_at_start-1
	end

	local room = Game():GetRoom()
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		player.Position = room:FindFreeTilePosition(player:GetData().ResetPosition,500000) -- arbitrary high value
	end

	level:UpdateVisibility()
end

-- do note that using the data cache on default rooms is super messy (you need to clear then update it on every floor!)
-- this cache system is mostly there to avoid breaking multiplayer (except the very first time a game is launched and the cache isn't filled)
function botb_room_generator:FillDataCache(roomtype, variants)
	local level = game:GetLevel()
	local currentroomidx = level:GetCurrentRoomIndex()
	local currentroomvisitcount = level:GetRoomByIdx(currentroomidx).VisitedCount
	local hascurseofmaze = false
	
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		locals.applyingcurseofmaze = true
	end

	if roomtype and not locals.data_cache[roomtype] then
		locals.data_cache[roomtype] = {}
	elseif not locals.data_cache["nil"] then
		locals.data_cache["nil"] = {}
	end
	
	local need_go_back_to_start = false
	for _,variant in pairs(variants) do
		if roomtype then
			if not locals.data_cache[roomtype][variant] then
				need_go_back_to_start = true
				Isaac.ExecuteCommand("goto s."..roomtype.."."..variant)
				locals.data_cache[roomtype][variant] = level:GetRoomByIdx(-3,0).Data
			end
		else
			if not locals.data_cache["nil"][variant] then
				need_go_back_to_start = true
				Isaac.ExecuteCommand("goto d."..variant)
				locals.data_cache["nil"][variant] = level:GetRoomByIdx(-3,0).Data
			end
		end
	end

	if need_go_back_to_start then
		game:StartRoomTransition(currentroomidx, 0, RoomTransitionAnim.FADE)
	
		if level:GetRoomByIdx(currentroomidx).VisitedCount ~= currentroomvisitcount then
			level:GetRoomByIdx(currentroomidx).VisitedCount = currentroomvisitcount - 1
		end

		-- clear desc for future users (polite!)
		level:GetRoomByIdx(-3,0).Data = nil
	end
	
	if hascurseofmaze then
		botb_utils:schedule_for_update(function()
			level:AddCurse(LevelCurse.CURSE_OF_MAZE)
			locals.applyingcurseofmaze = false
		end, 0, ModCallbacks.MC_POST_UPDATE)
	end
end

 -- roomtype must be provided as a string for goto use, enter nil to generate an ordinary room
function botb_room_generator:GenerateExtraRedRoom(room_generation_mode)
	room_generation_mode = room_generation_mode or RoomGenerationMode.ALLOW_DEADENDS_ONLY
	local level = game:GetLevel()
	local hascurseofmaze = false
	local currentroomidx = level:GetCurrentRoomIndex()
	local currentroomvisitcount = level:GetRoomByIdx(currentroomidx).VisitedCount
	
	for i = 0, game:GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		player:GetData().ResetPosition = player.Position
	end
	
	if level:GetCurses() & LevelCurse.CURSE_OF_MAZE > 0 then
		level:RemoveCurses(LevelCurse.CURSE_OF_MAZE)
		hascurseofmaze = true
		locals.applyingcurseofmaze = true
	end

	local available_grid_spaces = {}
	for i = level:GetRooms().Size, 0, -1 do
		local roomdesc = level:GetRooms():Get(i-1)
		if roomdesc then
			local candidates = GetCandidatesForGeneration(roomdesc,room_generation_mode)
			if candidates then
				for j, candidate in pairs(candidates) do
					-- check for unicity if needed (do not add multiple times the same candidate)
					local already_in = false
					if room_generation_mode ~= RoomGenerationMode.ALLOW_DEADENDS_ONLY then
						for k, entry in pairs(available_grid_spaces) do
							if entry.GridIndex == candidate.GridIndex and entry.Slot == candidate.Slot then
								already_in = true
								break
							end
						end
					end
					if not already_in then
						table.insert(available_grid_spaces, {Slot = candidate.Slot, GridIndex = candidate.GridIndex, roomidx = roomdesc.GridIndex, visitcount = roomdesc.VisitedCount})
					end
				end
			end
		end
	end
	
	if not available_grid_spaces[1] then
		-- print("[Warning] RoomGeneratorAPI: could not find an available grid space to generate a room, try to use a more flexible generation mode")
		return false
	end

	Shuffle(available_grid_spaces)
	-- print("#spaces: "..#available_grid_spaces)

	for _, entry in pairs(available_grid_spaces) do
		local available_grid_space_red_door_slot = entry.Slot
		local roomidx = entry.roomidx

		if level:MakeRedRoomDoor(roomidx, available_grid_space_red_door_slot) then
			return true
		end
	end

	-- print("[Warning] RoomGeneratorAPI: couldn't generate a room with provided variants and mode, see previous warnings or errors or retry with a more flexible mode")
	return false
end

return botb_room_generator