---@diagnostic disable: duplicate-set-field

function TSIL.SaveManager.SetPersistentVariable(mod, variableName, newValue, overrideType)
	local PersistentData = TSIL.__VERSION_PERSISTENT_DATA.PersistentData

	local tables = TSIL.Utils.Tables

	local modPersistentData = tables.FindFirst(PersistentData, function (_, modPersistentData)
		return modPersistentData.mod == mod.Name
	end)

	if modPersistentData == nil then
		return
	end

	local modVariables = modPersistentData.variables

	local foundVariable = tables.FindFirst(modVariables, function (_, modVariable)
		return modVariable.name == variableName
	end)

	if foundVariable == nil then
		return
	end

	if not overrideType then
		local defaultType = type(foundVariable.default)
		if defaultType == "userdata" then defaultType = getmetatable(foundVariable.default).__type end

		local newType = type(newValue)
		if newType == "userdata" then newType = getmetatable(newValue).__type end

		if defaultType ~= newType then
			error("The variable is defined as " .. defaultType .. ". Cannot convert it to " .. newType)
		end
	end

	foundVariable.value = newValue
end
