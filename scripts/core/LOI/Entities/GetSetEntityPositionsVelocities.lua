---@diagnostic disable: duplicate-set-field
function TSIL.Entities.GetEntityPositions(entities)
    if entities == nil then
        entities = TSIL.Entities.GetEntities()
    end

    local entityPositions = {}

    TSIL.Utils.Tables.ForEach(entities, function (_, entity)
        local ptr = EntityPtr(entity)
        entityPositions[ptr] = entity.Position
    end)

    return entityPositions
end


function TSIL.Entities.GetEntityVelocities(entities)
    if entities == nil then
        entities = TSIL.Entities.GetEntities()
    end

    local entityPositions = {}

    TSIL.Utils.Tables.ForEach(entities, function (_, entity)
        local ptr = EntityPtr(entity)
        entityPositions[ptr] = entity.Velocity
    end)

    return entityPositions
end


function TSIL.Entities.SetEntityPositions(positions, entities)
    if entities == nil then
        entities = TSIL.Entities.GetEntities()
    end

    TSIL.Utils.Tables.ForEach(entities, function (_, entity)
        local ptr = EntityPtr(entity)
        local position = positions[ptr]

        if position then
            entity.Position = position
        end
    end)
end


function TSIL.Entities.SetEntityVelocities(velocities, entities)
    if entities == nil then
        entities = TSIL.Entities.GetEntities()
    end

    TSIL.Utils.Tables.ForEach(entities, function (_, entity)
        local ptr = EntityPtr(entity)
        local velocity = velocities[ptr]

        if velocity then
            entity.Velocity = velocity
        end
    end)
end
