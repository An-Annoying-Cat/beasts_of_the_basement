---@diagnostic disable: duplicate-set-field
function TSIL.GridEntities.SpawnGridEntity(gridEntityType, gridEntityVariant, gridIndexOrPosition, force)
    if force == nil then
        force = true
    end

    local room = Game():GetRoom()
    local position = gridIndexOrPosition

    if type(gridIndexOrPosition) == "number" then
        position = room:GetGridPosition(gridIndexOrPosition)
    end

    local existingGridEntity = room:GetGridEntityFromPos(position)

    if existingGridEntity then
        if not force then
            return
        else
            TSIL.GridEntities.RemoveGridEntity(existingGridEntity, true)
        end
    end

    local gridEntity = Isaac.GridSpawn(gridEntityType, gridEntityVariant, position, true)

    if not gridEntity then
        return
    end

    if gridEntityType == GridEntityType.GRID_PIT then
        local pit = gridEntity:ToPit()

        if pit then
            pit:UpdateCollision()
        end
    elseif gridEntityType == GridEntityType.GRID_WALL then
        gridEntity.CollisionClass = GridCollisionClass.COLLISION_WALL
    end

    return gridEntity
end




