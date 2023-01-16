---@diagnostic disable: duplicate-set-field


function TSIL.EntitySpecific.GetEffects(effectVariant, subType)
	local entities = TSIL.Entities.GetEntities(EntityType.ENTITY_EFFECT, effectVariant, subType)

	local effects = {}

	for _, v in pairs(entities) do
		local effect = v:ToEffect()
		if effect then
			table.insert(effects, effect)
		end
	end

	return effects
end
















