---@diagnostic disable: duplicate-set-field
function TSIL.Entities.GetEntities(entityType, variant, subType, ignoreFriendly)
	entityType = entityType or -1
	variant = variant or -1
	subType = subType or -1

	if ignoreFriendly == nil then
		ignoreFriendly = false
	end

	if entityType == -1 then
		return Isaac.GetRoomEntities()
	end

	return Isaac.FindByType(entityType, variant, subType, ignoreFriendly)
end
