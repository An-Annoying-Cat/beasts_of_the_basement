---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Tables.Filter(toFilter, predicate)
	local filtered = {}

	for index, value in pairs(toFilter) do
		if predicate(index, value) then
			filtered[index] = value
		end
	end

	return filtered
end
