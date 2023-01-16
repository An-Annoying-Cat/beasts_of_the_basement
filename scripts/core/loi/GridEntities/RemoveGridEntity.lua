---@diagnostic disable: duplicate-set-field
function TSIL.GridEntities.RemoveGridEntity(gridEntityOrGridIndex, updateRoom)
    local room = Game():GetRoom()

    local gridEntity

    if type(gridEntityOrGridIndex) == "number" then
        gridEntity = room:GetGridEntity(gridEntityOrGridIndex)

        if not gridEntity then
            error("Couldn't find a grid entity at the given grid index: " .. gridEntityOrGridIndex)
        end
    else
        gridEntity = gridEntityOrGridIndex
    end

    local gridEntityType = gridEntity:GetType()
    local gridEntityVariant = gridEntity:GetVariant()
    local gridEntityPosition = gridEntity.Position

    room:RemoveGridEntity(gridEntity:GetGridIndex(), 0, false)

    if updateRoom then
        TSIL.Rooms.UpdateRoom()
    end

    if gridEntityType == GridEntityType.GRID_STATUE then
        local effectVariant = EffectVariant.DEVIL

        if gridEntityVariant == TSIL.Enums.StatueVariant.ANGEL then
            effectVariant = EffectVariant.ANGEL
        end

        local effects = TSIL.EntitySpecific.GetEffects(effectVariant)

        table.sort(effects, function (a, b)
            return a.Position:DistanceSquared(gridEntityPosition) <= b.Position:DistanceSquared(gridEntityPosition)
        end)

        effects[1]:Remove()
    end
end


