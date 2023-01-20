---@diagnostic disable: duplicate-set-field
function TSIL.GridEntities.GetTopLeftWallGridIndex()
	local room = Game():GetRoom()
	local gridSize = room:GetGridSize()
	local roomShape = room:GetRoomShape()

	for i = 0, gridSize, 1 do
		if TSIL.Rooms.IsGridIndexInRoomShape(i, roomShape) then
			return i
		end
	end

	return 0
end


