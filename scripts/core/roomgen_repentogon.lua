local mod = BotB
local JAIL_ROOMGEN = {}

--[[
function JAIL_ROOMGEN:testRoomProperties(slot, config, seed)
	if #slot:Neighbors() == 1 then
		print("hey we got a dead end and it's a " .. config.Type)
		if config.Type == 13 then
			--it's a sacrifice room, KILL IT
			return RoomConfigHolder.GetRoomByStageTypeAndVariant (StbType.SPECIAL_ROOMS,RoomType.ROOM_ANGEL,1,0)
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM,JAIL_ROOMGEN.testRoomProperties)



--[[
function JAIL_ROOMGEN:testRoomGenerator(generator)
	print("try to make an angel room")
	Game():GetLevel():PlaceRoom(Isaac.LevelGeneratorEntry(), RoomConfigHolder.GetRoomByStageTypeAndVariant (StbType.SPECIAL_ROOMS,RoomType.ROOM_ANGEL,1,0), 0)
end
Mod:AddCallback(ModCallbacks.MC_POST_LEVEL_LAYOUT_GENERATED,JAIL_ROOMGEN.testRoomGenerator)]]