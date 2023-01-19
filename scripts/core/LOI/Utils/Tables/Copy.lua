---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Tables.Copy(toCopy)
	local copy = {}
	for index, value in pairs(toCopy) do
		if type(value) == "table" then
			copy[index] = TSIL.Utils.Tables.Copy(value)
		else
			copy[index] = value
		end
	end

	return copy
end
