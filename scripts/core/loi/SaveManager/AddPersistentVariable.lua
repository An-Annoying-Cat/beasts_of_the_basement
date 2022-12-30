---@diagnostic disable: duplicate-set-field

function TSIL.SaveManager.AddPersistentVariable(mod, variableName, value, persistenceMode, ignoreGlowingHourglass, conditionalSave)
	if ignoreGlowingHourglass == nil then
		ignoreGlowingHourglass = false
	end

	local PersistentData = TSIL.__VERSION_PERSISTENT_DATA.PersistentData

	local tables = TSIL.Utils.Tables

	local modPersistentData = tables.FindFirst(PersistentData, function (_, modPersistentData)
		return modPersistentData.mod == mod.Name
	end)

	if modPersistentData == nil then
		modPersistentData = {
			mod = mod.Name,
			variables = {}
		}
		table.insert(PersistentData, modPersistentData)
	end

	local modVariables = modPersistentData.variables

	local foundVariable = tables.FindFirst(modVariables, function (_, modVariable)
		return modVariable.name == variableName
	end)

	if foundVariable ~= nil then
		return
	end

	local newVariable = {
		name = variableName,
		default = TSIL.Utils.DeepCopy.DeepCopy(value, TSIL.Enums.SerializationType.NONE),
		value = value,
		persistenceMode = persistenceMode,
		ignoreGlowingHourglass = ignoreGlowingHourglass,
		conditionalSave = conditionalSave
	}
	table.insert(modVariables, newVariable)
end
